part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// YEDEKLE & GERİ YÜKLE EKRANI — AŞAMA 3
// "Yedekle & Geri Yükle" menüsünden açılan ekran. İki ana eylem sunar:
//   1) Yedek Oluştur  → BackupHelper.createBackup() ile .zip oluşturur,
//      cihaza kaydeder ve isteğe bağlı olarak share_plus ile paylaşır.
//   2) Cihazdan Yedek Seç → file_picker ile bir .zip seçtirir ve
//      BackupHelper.restoreBackup() ile geri yükler.
// Onay diyalogları, adım adım yükleniyor göstergesi (4.2), hataya özel
// SnackBar + "Tekrar Dene" aksiyonları (4.3b) ve (4.3c) eksik ek dosya /
// boş yedek uyarıları ile geri yükleme sonrası daha bilgilendirici
// mesajlar tamamlanmış durumdadır.
//
// AŞAMA 5.1: "Yedek Geçmişi" kartı eklendi — BackupHistoryScreen'de
// listelenen bir yedek "Geri Yükle" ile seçildiğinde bu ekrana geri
// döner ve aşağıdaki _restoreFromFile() üzerinden AYNI önizleme/onay/
// geri yükleme akışı çalışır (dosya seçiciyle seçilen yedekle birebir
// aynı davranış — kod tekrarı yok). Bu yüzden dosya-seçme adımı
// (_pickAndRestore) ile asıl geri yükleme akışı (_restoreFromFile) ayrı
// fonksiyonlara bölündü.
// AŞAMA 5.2: Ekranın en üstüne, son başarılı yedeklemenin ne zaman
// alındığını gösteren LastBackupInfoTile widget'ı eklendi (bkz.
// backup_last_info_widget_5_2.dart). Yeni bir yedek oluşturulduğunda bu
// bilgi, ekrandan çıkıp geri girmeye gerek kalmadan _lastBackupKey
// üzerinden anında yenilenir.
// AŞAMA 5.3: büyük yedeklerde işlem başlamadan önce kullanıcı
// bilgilendiriliyor. Yedek oluşturmadan önce ek dosyaların tahmini
// boyutu (BackupHelper.estimateAttachmentsSize — dosya içerikleri
// okunmadan, hızlı), geri yüklemeden önce ise seçilen .zip dosyasının
// kendi boyutu kontrol edilir; eşik (BackupHelper.largeBackupWarningBytes)
// aşılırsa _confirmLargeOperation() ile "bu biraz sürebilir" onayı
// alınır. Asıl sıkıştırma/çözme işlemleri artık BackupHelper içinde
// arka plan isolate'ında (compute()) çalıştığından, bu uyarı sadece
// kullanıcı beklentisini yönetmek içindir — arayüz zaten donmaz.
// AŞAMA 5.4: Yedek Oluştur ve Cihazdan Yedek Seç akışları artık başlamadan
// önce _ensurePermission() ile (yalnızca eski Android sürümlerinde
// devreye giren) depolama izni kontrolünden geçiyor. İzin reddedilirse
// kullanıcı bilgilendirilip isterse uygulama ayarlarına yönlendiriliyor;
// Android 11+ cihazlarda bu kontrol anlık olarak true döner ve kullanıcı
// hiçbir ek adım/gecikme görmez.
// ════════════════════════════════════════════════════════════════════════
class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  State<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  bool _busy = false;
  String? _busyLabel;
  double? _progress;

  // AŞAMA 5.2: LastBackupInfoTile'ı yeni bir yedek oluşturulduktan sonra
  // ekrandan çıkıp geri girmeye gerek kalmadan yenilemek için kullanılır.
  final GlobalKey<_LastBackupInfoTileState> _lastBackupKey = GlobalKey();

  void _setBusy(bool value, {String? label}) {
    if (!mounted) return;
    setState(() {
      _busy = value;
      _busyLabel = label;
      if (!value) _progress = null;
    });
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
      ),
    );
  }

  // ── AŞAMA 4.3b: hataya özel SnackBar + "Tekrar Dene" aksiyonu ─────────
  // BackupHelper katmanından gelen BackupValidationException /
  // BackupOperationException, kendi `message` ve `retryable` alanlarını
  // zaten taşıyor (bkz. Aşama 4.3a). Burada tek iş: mesajı göstermek ve
  // `retryable == true` ise kullanıcıya işlemi tek dokunuşla tekrar
  // başlatabileceği bir aksiyon sunmak. Bozuk dosya / uyumsuz sürüm gibi
  // "tekrar denemekle düzelmeyecek" hatalarda aksiyon gösterilmez.
  void _showErrorSnack(
    String message, {
    bool retryable = false,
    VoidCallback? onRetry,
  }) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 6),
        action: (retryable && onRetry != null)
            ? SnackBarAction(
                label: 'Tekrar Dene',
                textColor: Colors.amber,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }

  // AŞAMA 5.4: yalnızca eski Android sürümlerinde (bkz. BackupHelper
  // .ensureStoragePermissionIfNeeded) devreye giren depolama izni
  // kontrolü. İzin verilmişse veya cihaz zaten izin gerektirmiyorsa
  // (Android 11+, iOS vb.) sessizce `true` döner. İzin reddedilirse
  // kullanıcıya açıklayıcı bir diyalog gösterilir; izin kalıcı olarak
  // reddedilmişse ("bir daha sorma") sistem diyaloğu artık
  // gösterilemeyeceğinden kullanıcı doğrudan uygulama ayarlarına
  // yönlendirilebilir.
  Future<bool> _ensurePermission() async {
    final granted = await BackupHelper.instance.ensureStoragePermissionIfNeeded();
    if (granted) return true;
    if (!mounted) return false;

    final permanentlyDenied =
        await BackupHelper.instance.isStoragePermissionPermanentlyDenied();

    final goToSettings = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dNoteCardColor(ctx),
        title: const Text(
          'Depolama İzni Gerekli',
          style: TextStyle(color: Colors.amber),
        ),
        content: Text(
          permanentlyDenied
              ? 'Bu Android sürümünde yedekleme/geri yükleme için '
                  'depolama izni gereklidir. İzin kalıcı olarak '
                  'reddedildiğinden, lütfen uygulama ayarlarından izni '
                  'elle etkinleştirin.'
              : 'Bu Android sürümünde yedekleme/geri yükleme için '
                  'depolama izni gereklidir. Devam edebilmek için lütfen '
                  'izni verin.',
          style: TextStyle(color: dNoteTextColor(ctx)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(permanentlyDenied ? 'Ayarlara Git' : 'Tekrar Dene'),
          ),
        ],
      ),
    );

    if (goToSettings != true) return false;
    if (permanentlyDenied) {
      await openAppSettings();
      return false;
    }
    // Kalıcı reddetme değilse sistem izin diyaloğunu bir kez daha
    // deneyebiliriz.
    return BackupHelper.instance.ensureStoragePermissionIfNeeded();
  }

  // ── Yedek oluştur ────────────────────────────────────────────────────
  Future<void> _createBackup() async {
    if (_busy) return;

    // AŞAMA 5.4: gerçek işlem başlamadan önce (yalnızca eski Android'de
    // anlamlı olan) depolama izni kontrol edilir.
    if (!await _ensurePermission()) return;

    // AŞAMA 5.3: gerçek işlem başlamadan önce ek dosyaların tahmini
    // boyutuna hızlıca bakılır (dosya içerikleri OKUNMAZ, sadece meta
    // veri). Eşik aşılıyorsa kullanıcı önceden bilgilendirilir; devam
    // etmek isteyip istemediğine kendisi karar verir.
    final estimatedSize = await BackupHelper.instance.estimateAttachmentsSize();
    if (estimatedSize >= BackupHelper.largeBackupWarningBytes) {
      if (!mounted) return;
      final proceed = await _confirmLargeOperation(
        sizeText: BackupHelper.instance.formatFileSize(estimatedSize),
        actionLabel: 'yedekleme',
      );
      if (proceed != true) return;
    }

    _setBusy(true, label: 'Yedek oluşturuluyor...');
    File? file;
    try {
      file = await BackupHelper.instance.createBackup(
        onProgress: (progress, step) {
          if (mounted) {
            setState(() {
              _progress = progress;
              _busyLabel = step;
            });
          }
        },
      );
    } catch (e) {
      _setBusy(false);
      // AŞAMA 4.3b: ham hata BackupOperationException'a çevrilerek hem
      // kullanıcı dostu bir mesaj hem de "tekrar denemek anlamlı mı"
      // bilgisi (retryable) elde edilir.
      final ex = BackupOperationException.fromError(e);
      _showErrorSnack(
        'Yedek oluşturulamadı: ${ex.message}',
        retryable: ex.retryable,
        onRetry: _createBackup,
      );
      return;
    }
    _setBusy(false);
    if (!mounted) return;
    // AŞAMA 4.3c: son rötuş — kullanıcı yedeğin boyutunu görmek için
    // ayrıca dosya listesine bakmak zorunda kalmasın diye dosya boyutu
    // doğrudan başarı mesajında da gösterilir.
    final sizeText = BackupHelper.instance.formatFileSize(
      await file.length(),
    );
    _showSnack('Yedek oluşturuldu: ${p.basename(file.path)} ($sizeText)');
    // AŞAMA 5.2: yeni yedek başarıyla oluşturulduğunda üstteki "son
    // yedekleme" bilgisini anında yenile (ekrandan çıkıp geri girmeye
    // gerek kalmadan).
    _lastBackupKey.currentState?.refresh();
    await _offerShare(file);
  }

  // AŞAMA 5.3: yedekleme veya geri yükleme için tahmini/gerçek boyut eşiği
  // aşıldığında gösterilen, ortak "bu biraz sürebilir" onay diyaloğu. Hem
  // _createBackup hem de _restoreFromFile tarafından kullanılır.
  Future<bool?> _confirmLargeOperation({
    required String sizeText,
    required String actionLabel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dNoteCardColor(ctx),
        title: const Text('Büyük Yedek', style: TextStyle(color: Colors.amber)),
        content: Text(
          'İşlenecek veri boyutu yaklaşık $sizeText. Bu boyuttaki bir '
          '$actionLabel işlemi cihazınıza bağlı olarak biraz zaman '
          'alabilir. İşlem sürerken uygulamadan çıkmamanız yeterlidir, '
          'devam etmek ister misiniz?',
          style: TextStyle(color: dNoteTextColor(ctx)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Devam Et'),
          ),
        ],
      ),
    );
  }

  Future<void> _offerShare(File file) async {
    if (!mounted) return;
    final share = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dNoteCardColor(ctx),
        title: const Text('Yedek Hazır', style: TextStyle(color: Colors.amber)),
        content: Text(
          'Yedek dosyanız cihazınıza kaydedildi. Dosyayı şimdi paylaşmak '
          '(örn. bulut depolama, e-posta, başka bir cihaz) ister misiniz?',
          style: TextStyle(color: dNoteTextColor(ctx)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Kapat'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Paylaş'),
          ),
        ],
      ),
    );
    if (share == true) {
      await _shareBackup(file);
    }
  }

  Future<void> _shareBackup(File file) async {
    try {
      await Share.shareXFiles([XFile(file.path)], text: 'dnote yedek dosyası');
    } catch (e) {
      _showSnack('Paylaşım başlatılamadı: $e', isError: true);
    }
  }

  // AŞAMA 5.1: Yedek Geçmişi ekranını açar. Kullanıcı listeden bir yedeği
  // "Geri Yükle" ile seçerse o ekran Navigator.pop(context, file) ile bu
  // dosyayı geri döndürür ve _restoreFromFile() ile aynı akış devreye
  // girer. Kullanıcı sadece göz atıp geri dönerse (hiçbir şey seçmezse)
  // `selected` null olur ve hiçbir şey yapılmaz.
  Future<void> _openHistory() async {
    if (_busy) return;
    final selected = await Navigator.push<File>(
      context,
      MaterialPageRoute(builder: (_) => const BackupHistoryScreen()),
    );
    if (selected != null) {
      await _restoreFromFile(selected);
    }
  }

  // ── Cihazdan yedek seç & geri yükle ─────────────────────────────────
  Future<void> _pickAndRestore() async {
    if (_busy) return;

    // AŞAMA 5.4: dosya seçici açılmadan önce (yalnızca eski Android'de
    // anlamlı olan) depolama izni kontrol edilir.
    if (!await _ensurePermission()) return;

    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );
    } catch (e) {
      _showSnack('Dosya seçilemedi: $e', isError: true);
      return;
    }
    if (result == null || result.files.isEmpty) return;

    final path = result.files.single.path;
    if (path == null) {
      _showSnack('Seçilen dosyaya erişilemedi.', isError: true);
      return;
    }
    await _restoreFromFile(File(path));
  }

  // AŞAMA 5.1: Yedek Geçmişi ekranından (Navigator.pop ile dönen File) ile
  // dosya seçiciden gelen dosyanın izleyeceği önizleme/onay/geri yükleme
  // akışı BİREBİR aynıdır; bu yüzden ortak bir fonksiyona alındı. Hem
  // _pickAndRestore hem de _openHistory bunu çağırır.
  Future<void> _restoreFromFile(File zipFile) async {
    if (_busy) return;

    // AŞAMA 5.3: zip'i açıp doğrulamaya (loadBackupPreview) başlamadan
    // önce, seçilen dosyanın kendi boyutuna hızlıca bakılır. Eşik
    // aşılıyorsa kullanıcı önceden bilgilendirilir.
    int fileSize = 0;
    try {
      fileSize = await zipFile.length();
    } catch (_) {
      // Boyut okunamazsa uyarı gösterilmez; zaten aşağıdaki adımlarda
      // dosyaya erişilemiyorsa uygun hata mesajı gösterilecektir.
    }
    if (fileSize >= BackupHelper.largeBackupWarningBytes) {
      if (!mounted) return;
      final proceed = await _confirmLargeOperation(
        sizeText: BackupHelper.instance.formatFileSize(fileSize),
        actionLabel: 'geri yükleme',
      );
      if (proceed != true) return;
    }

    // ── AŞAMA 4.1: Geri yüklemeden ÖNCE yedeği okuyup doğrula ve içeriğini
    // önizle. Böylece kullanıcı onay vermeden önce bozuk/uyumsuz bir
    // dosyayı seçtiğini hemen öğrenir; ayrıca onay diyaloğunda yedeğin
    // içeriği (kaç not, ne zaman alınmış vb.) gösterilebilir.
    _setBusy(true, label: 'Yedek kontrol ediliyor...');
    BackupPreview preview;
    try {
      preview = await BackupHelper.instance.loadBackupPreview(zipFile);
    } on BackupValidationException catch (e) {
      _setBusy(false);
      // Bozuk dosya / dnote'a ait olmayan yedek / uyumsuz sürüm gibi
      // doğrulama hataları genelde `retryable: false` gelir çünkü aynı
      // dosyayı tekrar okumak sonucu değiştirmez — kullanıcı önce başka
      // bir dosya seçmelidir. Buna rağmen sınıf `retryable: true`
      // işaretlemişse (örn. gelecekte eklenebilecek geçici bir durum)
      // aksiyon otomatik olarak gösterilir.
      _showErrorSnack(
        e.message,
        retryable: e.retryable,
        onRetry: e.retryable ? () => _restoreFromFile(zipFile) : null,
      );
      return;
    } catch (e) {
      _setBusy(false);
      final ex = BackupOperationException.fromError(e);
      _showErrorSnack(
        'Yedek dosyası okunamadı: ${ex.message}',
        retryable: ex.retryable,
        onRetry: () => _restoreFromFile(zipFile),
      );
      return;
    }
    _setBusy(false);

    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dNoteCardColor(ctx),
        title: const Text(
          'Yedeği Geri Yükle',
          style: TextStyle(color: Colors.amber),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seçilen yedeğin içeriği:',
                style: TextStyle(
                  color: dNoteTextColor(ctx),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _previewRow(
                ctx,
                Icons.description_outlined,
                'Not sayısı',
                '${preview.noteCount}',
              ),
              _previewRow(
                ctx,
                Icons.delete_outline,
                'Çöp kutusundaki not',
                '${preview.deletedNoteCount}',
              ),
              _previewRow(
                ctx,
                Icons.folder_outlined,
                'Kategori sayısı',
                '${preview.categoryCount}',
              ),
              _previewRow(
                ctx,
                Icons.attach_file,
                'Ek dosya',
                preview.attachmentCount == 0
                    ? 'Yok'
                    : '${preview.attachmentCount} dosya '
                        '(${BackupHelper.instance.formatFileSize(preview.attachmentBytesTotal)})',
              ),
              _previewRow(
                ctx,
                Icons.schedule,
                'Oluşturulma tarihi',
                _formatPreviewDate(preview.createdAt),
              ),

              // ── AŞAMA 4.3c: yedek tamamen boşsa kullanıcıyı uyar ────────
              // Kullanıcı yanlışlıkla boş/hiç veri içermeyen bir zip
              // seçmiş olabilir. Geri yükleme yine de mevcut verileri
              // silip yerine "boş" veri yazacağı için bunu önceden
              // belirtmek önemlidir.
              if (_isPreviewEmpty(preview)) ...[
                const SizedBox(height: 14),
                _infoBox(
                  ctx,
                  icon: Icons.info_outline,
                  color: Colors.blueGrey,
                  title: 'Bu yedek boş görünüyor',
                  body:
                      'Seçilen dosyada not, kategori veya ek dosya '
                      'bulunamadı. Yine de devam ederseniz mevcut '
                      'verileriniz silinip yerine bu boş yedek yazılır.',
                ),
              ],

              // ── AŞAMA 4.3c: eksik ek dosya uyarısı ──────────────────────
              // Aşama 4.3a'da tespit edilen, notlarda referans verilip
              // zip içinde bulunamayan ek dosyalar burada kullanıcıya
              // önceden gösterilir. Böylece geri yükleme bittikten sonra
              // "eklerim nerede?" şaşkınlığı yaşanmaz.
              if (preview.hasMissingAttachments) ...[
                const SizedBox(height: 14),
                _infoBox(
                  ctx,
                  icon: Icons.warning_amber_rounded,
                  color: Colors.orange,
                  title:
                      '${preview.missingAttachmentNames.length} ek dosya '
                      'yedekte bulunamadı',
                  body:
                      'Bu dosyalara sahip notlar geri yüklenecek, ancak '
                      'ek dosyalar olmadan (yedek alınırken eksik ya da '
                      'bozuk kalmış olabilirler): '
                      '${_missingAttachmentsSummary(preview.missingAttachmentNames)}',
                ),
              ],

              const Divider(height: 26),
              Text(
                'Bu işlem; mevcut tüm notlarınızın, çöp kutunuzun, '
                'kategorilerinizin, ayarlarınızın ve eklerinizin YERİNE '
                'yukarıdaki yedekteki verileri yazacaktır. Mevcut veriler '
                'kalıcı olarak kaybolur ve bu işlem geri alınamaz.',
                style: TextStyle(
                  color: dNoteTextColor(ctx).withValues(alpha: 0.85),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Geri Yükle'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _executeRestore(zipFile, preview);
  }

  // AŞAMA 4.3b: asıl geri yükleme işlemi, "Tekrar Dene" aksiyonundan da
  // çağrılabilmesi için ayrı bir fonksiyona alındı. Böylece bir hata
  // (örn. geçici bir izin/depolama sorunu) sonrası kullanıcı dosyayı
  // yeniden seçmek ve onay diyaloğunu tekrar geçmek zorunda kalmadan,
  // zaten doğrulanmış aynı `preview` ile işlemi tek dokunuşla tekrarlar.
  Future<void> _executeRestore(File zipFile, BackupPreview preview) async {
    _setBusy(true, label: 'Yedek geri yükleniyor...');
    try {
      await BackupHelper.instance.restoreBackup(
        zipFile,
        preloaded: preview,
        onProgress: (progress, step) {
          if (mounted) {
            setState(() {
              _progress = progress;
              _busyLabel = step;
            });
          }
        },
      );
      _setBusy(false);
      if (!mounted) return;
      // AŞAMA 4.3c: geri yükleme sonrası bilgilendirme, önizlemede tespit
      // edilen eksik ek dosya durumuna göre özelleştirilir. Kullanıcı
      // onay diyaloğunda bu uyarıyı zaten görmüştü; burada bir kez daha
      // hatırlatılarak "eklerim nerede?" karışıklığı önlenir.
      if (preview.hasMissingAttachments) {
        _showSnack(
          'Yedek geri yüklendi. Ancak ${preview.missingAttachmentNames.length} '
          'ek dosya yedekte bulunamadığı için geri yüklenemedi. '
          'Değişikliklerin tam yansıması için uygulamayı yeniden '
          'başlatmanız önerilir.',
        );
      } else {
        _showSnack(
          'Yedek başarıyla geri yüklendi. Değişikliklerin tam olarak '
          'yansıması için uygulamayı yeniden başlatmanız önerilir.',
        );
      }
    } on BackupValidationException catch (e) {
      _setBusy(false);
      _showErrorSnack(
        e.message,
        retryable: e.retryable,
        onRetry: e.retryable ? () => _executeRestore(zipFile, preview) : null,
      );
    } catch (e) {
      _setBusy(false);
      // Notlar/kategoriler kısmen yazılmış olsa bile (bkz. BackupHelper
      // içindeki try/catch'ler), hata sınıflandırılıp kullanıcıya net bir
      // mesajla ve — anlamlıysa — "Tekrar Dene" aksiyonu ile sunulur.
      final ex = BackupOperationException.fromError(e);
      _showErrorSnack(
        'Geri yükleme sırasında hata oluştu: ${ex.message}',
        retryable: ex.retryable,
        onRetry: () => _executeRestore(zipFile, preview),
      );
    }
  }

  // Önizleme diyaloğunda tek bir "ikon + etiket + değer" satırı çizer.
  Widget _previewRow(
    BuildContext ctx,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: dNoteTextColor(ctx).withValues(alpha: 0.75),
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: dNoteTextColor(ctx),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // AŞAMA 4.3c: seçilen yedekte hiç not, kategori ya da ek dosya yoksa
  // true döner. Onay diyaloğunda ayrı bir uyarı göstermek için kullanılır.
  bool _isPreviewEmpty(BackupPreview preview) {
    return preview.noteCount == 0 &&
        preview.deletedNoteCount == 0 &&
        preview.categoryCount == 0 &&
        preview.attachmentCount == 0;
  }

  // AŞAMA 4.3c: eksik ek dosya adlarından kısa, okunabilir bir özet
  // metni üretir. Liste uzunsa ilk birkaç ad gösterilip geri kalanı
  // "ve N tane daha" olarak özetlenir (diyalog taşmasın diye).
  String _missingAttachmentsSummary(List<String> names) {
    if (names.isEmpty) return '';
    const maxShown = 3;
    final shown = names.take(maxShown).join(', ');
    if (names.length > maxShown) {
      return '$shown ve ${names.length - maxShown} tane daha';
    }
    return shown;
  }

  // AŞAMA 4.3c: onay diyaloğunda kullanılan, ikon + başlık + gövde metni
  // içeren renkli bir bilgi/uyarı kutusu. Hem "boş yedek" hem de
  // "eksik ek dosya" uyarıları bu ortak widget'ı kullanır.
  Widget _infoBox(
    BuildContext ctx, {
    required IconData icon,
    required MaterialColor color,
    required String title,
    required String body,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: TextStyle(
              color: dNoteTextColor(ctx).withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Önizlemedeki oluşturulma tarihini "16.07.2026 14:32" biçiminde,
  // tarih okunamıyorsa "Bilinmiyor" olarak döner.
  String _formatPreviewDate(DateTime? dt) {
    if (dt == null) return 'Bilinmiyor';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}.${two(dt.month)}.${dt.year} '
        '${two(dt.hour)}:${two(dt.minute)}';
  }


  // AŞAMA 4.2: işlem sürerken (yedekleme/geri yükleme) kullanıcının geri
  // tuşu, sistem geri hareketi veya AppBar'daki geri okuyla ekrandan
  // çıkmasını engeller. Aksi halde işlem yarıda kesilirse veritabanı
  // tutarsız bir durumda kalabilir.
  void _blockedExitWarning() {
    _showSnack(
      'İşlem sürüyor, lütfen tamamlanmasını bekleyin.',
      isError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_busy,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _busy) {
          _blockedExitWarning();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Yedekle & Geri Yükle'),
          automaticallyImplyLeading: !_busy,
          leading: _busy
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'İşlem sürüyor',
                  onPressed: _blockedExitWarning,
                )
              : null,
        ),
        body: AbsorbPointer(
          absorbing: _busy,
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // AŞAMA 5.2: son yedekleme tarihi bilgisi.
                  LastBackupInfoTile(key: _lastBackupKey),
                  Text(
                    'Notlarınızı, kategorilerinizi, ayarlarınızı ve eklerinizi '
                    'tek bir .zip dosyası olarak yedekleyebilir veya daha '
                    'önce aldığınız bir yedeği geri yükleyebilirsiniz.',
                    style: TextStyle(
                      color: dNoteTextColor(context).withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _actionCard(
                    context,
                    icon: Icons.backup_outlined,
                    title: 'Yedek Oluştur',
                    subtitle:
                        'Tüm verilerinizi tek bir .zip dosyası olarak cihaza '
                        'kaydedin ve isterseniz paylaşın.',
                    buttonLabel: 'Yedek Oluştur',
                    onPressed: _createBackup,
                  ),
                  const SizedBox(height: 16),
                  _actionCard(
                    context,
                    icon: Icons.restore_outlined,
                    title: 'Cihazdan Yedek Seç',
                    subtitle:
                        'Daha önce aldığınız bir .zip yedeğini seçip geri '
                        'yükleyin.',
                    buttonLabel: 'Yedek Seç',
                    onPressed: _pickAndRestore,
                  ),
                  const SizedBox(height: 16),
                  // AŞAMA 5.1: cihazda oluşturulmuş yedeklerin tarih ve
                  // boyut bilgisiyle listelendiği geçmiş ekranına geçiş.
                  _actionCard(
                    context,
                    icon: Icons.history_outlined,
                    title: 'Yedek Geçmişi',
                    subtitle:
                        'Cihazda kayıtlı tüm yedekleri tarih ve boyutlarıyla '
                        'görüntüleyin; buradan doğrudan paylaşabilir, geri '
                        'yükleyebilir veya silebilirsiniz.',
                    buttonLabel: 'Geçmişi Görüntüle',
                    onPressed: _openHistory,
                  ),
                ],
              ),
              if (_busy)
                PopScope(
                  // AŞAMA 4.2: overlay üstündeyken de geri tuşu/gesture
                  // engellenir (dış PopScope'a ek güvence).
                  canPop: false,
                  child: Container(
                    color: Colors.black54,
                    child: Center(
                      child: Card(
                        color: dNoteCardColor(context),
                        child: Container(
                          width: 260,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 52,
                                height: 52,
                                child: CircularProgressIndicator(
                                  value: _progress,
                                  color: Colors.amber,
                                  backgroundColor:
                                      Colors.amber.withValues(alpha: 0.15),
                                  strokeWidth: 4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _progress != null
                                    ? '%${(_progress! * 100).clamp(0, 100).toStringAsFixed(0)}'
                                    : '',
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _busyLabel ?? 'İşleniyor...',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: dNoteTextColor(context),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Lütfen bekleyin, işlem tamamlanmadan '
                                'uygulamadan çıkmayın.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: dNoteTextColor(context)
                                      .withValues(alpha: 0.6),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonLabel,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: dNoteCardColor(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: dNoteBorderColor(context)),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.amber, size: 26),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: dNoteTextColor(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: dNoteTextColor(context).withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              onPressed: onPressed,
              child: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}

