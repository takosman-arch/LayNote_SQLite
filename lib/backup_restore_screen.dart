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

  // AŞAMA 6.6: Google Drive bağlantı durumu. `_driveSignedIn` ve
  // `_driveAccountEmail`, ekran her açıldığında GoogleDriveHelper'daki
  // sessiz girişle senkronize edilir (bkz. initState/_refreshDriveStatus).
  // Bu sayede kullanıcı daha önce bağlandıysa, ekrana her girdiğinde
  // yeniden bağlanmasına gerek kalmaz.
  bool _driveSignedIn = false;
  String? _driveAccountEmail;

  // Otomatik yedekleme AÇIK/KAPALI durumu — Drive kartıyla aynı desende
  // ayrı bir küçük durum kartında gösterilir (bkz. _autoBackupStatusCard).
  // Ekran her açıldığında ve Ayarlar ekranından geri dönüldüğünde
  // AutoBackupService'ten tazelenir (bkz. initState/_openAutoBackupSettings).
  bool _autoBackupEnabled = false;

  // AŞAMA 5.2: LastBackupInfoTile'ı yeni bir yedek oluşturulduktan sonra
  // ekrandan çıkıp geri girmeye gerek kalmadan yenilemek için kullanılır.
  final GlobalKey<_LastBackupInfoTileState> _lastBackupKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // AŞAMA 6.6: ekran açılır açılmaz Google Drive oturumunun sessizce
    // (kullanıcıya herhangi bir diyalog göstermeden) geri yüklenip
    // yüklenemeyeceği kontrol edilir.
    _refreshDriveStatus();
    _refreshAutoBackupStatus();
  }

  // AŞAMA 6.6: Google Drive bağlantı durumunu tazeler. Hem initState'te
  // hem de bağlan/bağlantıyı kes işlemlerinden sonra çağrılır.
  Future<void> _refreshDriveStatus() async {
    final signedIn = await GoogleDriveHelper.instance.trySilentSignIn();
    if (!mounted) return;
    setState(() {
      _driveSignedIn = signedIn;
      _driveAccountEmail = GoogleDriveHelper.instance.accountEmail;
    });
  }

  // Otomatik yedekleme AÇIK/KAPALI durumunu tazeler. initState'te ve
  // Otomatik Yedekleme Ayarları ekranından geri dönüldüğünde çağrılır
  // (bkz. _openAutoBackupSettings) — kullanıcı o ekranda anahtarı
  // değiştirip geri geldiğinde bu ekrandaki küçük durum kartı da güncel
  // kalsın diye.
  Future<void> _refreshAutoBackupStatus() async {
    final enabled = await AutoBackupService.instance.isEnabled();
    if (!mounted) return;
    setState(() => _autoBackupEnabled = enabled);
  }

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
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        action: (retryable && onRetry != null)
            ? SnackBarAction(
                label: 'Tekrar Dene',
                textColor: appAccentColor.value,
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
        title: Text(
          'Depolama İzni Gerekli',
          style: TextStyle(color: appAccentColor.value),
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
              backgroundColor: appAccentColor.value,
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

  // ── AŞAMA 6.6: GOOGLE DRIVE BAĞLANTI YÖNETİMİ ───────────────────────

  // Kullanıcıya Google'ın standart hesap seçme ekranını gösterir. Başarılı
  // olursa bağlantı durumu tazelenir ve kullanıcıya bilgi verilir.
  Future<void> _connectGoogleDrive() async {
    if (_busy) return;
    _setBusy(true, label: 'Google hesabına bağlanılıyor...');
    final ok = await GoogleDriveHelper.instance.signIn();
    _setBusy(false);
    if (!mounted) return;
    if (ok) {
      setState(() {
        _driveSignedIn = true;
        _driveAccountEmail = GoogleDriveHelper.instance.accountEmail;
      });
      _showSnack(
        'Google Drive hesabına bağlanıldı'
        '${_driveAccountEmail != null ? ': $_driveAccountEmail' : '.'}',
      );
    } else {
      _showSnack(
        'Google hesabına bağlanılamadı veya işlem iptal edildi.',
        isError: true,
      );
    }
  }

  // Bağlantıyı kesmeden önce kullanıcıdan onay alır — yanlışlıkla
  // bağlantının kesilip otomatik yedeklemenin durmasını önlemek için.
  Future<void> _disconnectGoogleDrive() async {
    if (_busy) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dNoteCardColor(ctx),
        title: Text(
          'Google Drive Bağlantısını Kes',
          style: TextStyle(color: appAccentColor.value),
        ),
        content: Text(
          'Bağlantı kesilirse Drive\'a manuel veya otomatik yedekleme '
          'yapılamaz. Drive\'da halihazırda duran yedekleriniz silinmez, '
          'yalnızca bu cihazdan erişim kaldırılır.',
          style: TextStyle(color: dNoteTextColor(ctx)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Bağlantıyı Kes'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await GoogleDriveHelper.instance.signOut();
    if (!mounted) return;
    setState(() {
      _driveSignedIn = false;
      _driveAccountEmail = null;
    });
    _showSnack('Google Drive bağlantısı kesildi.');
  }

  // Henüz Google'a bağlı değilken "Drive'a Yedekle" / "Drive'dan Geri
  // Yükle" denendiğinde önce kullanıcıya bağlanmak isteyip istemediği
  // sorulur — aksi halde işlem sessizce başarısız olur ve kullanıcı
  // neden çalışmadığını anlayamaz.
  Future<bool> _confirmConnectDriveFirst() async {
    final proceed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dNoteCardColor(ctx),
        title: Text(
          'Google Hesabı Gerekli',
          style: TextStyle(color: appAccentColor.value),
        ),
        content: Text(
          'Bu işlem için Google hesabınızla bağlanmanız gerekiyor. Şimdi '
          'bağlanmak ister misiniz?',
          style: TextStyle(color: dNoteTextColor(ctx)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: appAccentColor.value,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Bağlan'),
          ),
        ],
      ),
    );
    return proceed == true;
  }

  // ── GOOGLE DRIVE'A YEDEKLE — AŞAMA 6.6 ───────────────────────────────
  //
  // Akış: izin kontrolü → (gerekiyorsa) Google'a bağlanma → büyük yedek
  // uyarısı (mevcut _confirmLargeOperation ile aynı) → yerel yedek
  // oluşturma (BackupHelper.createBackup — Aşama 1'den beri değişmedi) →
  // Drive'a yükleme (Aşama 6.2) → eski Drive yedeklerini temizleme
  // (Aşama 6.5). Yerel yedek oluşturma adımı, bu ekrandaki normal "Yedek
  // Oluştur" ile BİREBİR aynı fonksiyonu kullanır — iki ayrı yedekleme
  // mantığı yoktur, sadece oluşan dosyanın gideceği yer farklıdır.
  Future<void> _backupToDrive() async {
    if (_busy) return;

    if (!await _ensurePermission()) return;

    if (!_driveSignedIn) {
      if (!await _confirmConnectDriveFirst()) return;
      await _connectGoogleDrive();
      if (!_driveSignedIn) return;
    }

    final estimatedSize = await BackupHelper.instance.estimateAttachmentsSize();
    if (estimatedSize >= BackupHelper.largeBackupWarningBytes) {
      if (!mounted) return;
      final proceed = await _confirmLargeOperation(
        sizeText: BackupHelper.instance.formatFileSize(estimatedSize),
        actionLabel: 'Drive\'a yedekleme',
      );
      if (proceed != true) return;
    }

    _setBusy(true, label: 'Yedek oluşturuluyor...');
    File localFile;
    try {
      localFile = await BackupHelper.instance.createBackup(
        onProgress: (progress, step) {
          if (mounted) {
            // Yerel oluşturma adımına toplam ilerlemenin ilk yarısı
            // (0.0–0.5) ayrılır; Drive'a yükleme ikinci yarıyı (0.5–1.0)
            // kullanır. Böylece kullanıcı tek bir sürekli ilerleme çubuğu
            // görür, iki ayrı işlem olduğunu fark etmesine gerek kalmaz.
            setState(() {
              _progress = progress * 0.5;
              _busyLabel = step;
            });
          }
        },
      );
    } catch (e) {
      _setBusy(false);
      final ex = BackupOperationException.fromError(e);
      _showErrorSnack(
        'Yedek oluşturulamadı: ${ex.message}',
        retryable: ex.retryable,
        onRetry: _backupToDrive,
      );
      return;
    }

    try {
      await GoogleDriveHelper.instance.uploadBackup(
        localFile,
        onProgress: (progress, step) {
          if (mounted) {
            setState(() {
              _progress = 0.5 + progress * 0.5;
              _busyLabel = step;
            });
          }
        },
      );
    } catch (e) {
      // Yükleme başarısız oldu: bu ekran kullanıcıdan hiçbir zaman ayrıca
      // yerel bir kopya istemedi, o yüzden başarısız denemede de
      // localFile fallback olarak TUTULMAZ — "Tekrar Dene" ile üst üste
      // denense bile cihazda hiçbir iz birikmez.
      await BackupHelper.instance.deleteBackupFile(localFile);
      _setBusy(false);
      final ex = GoogleDriveException.fromError(e);
      _showErrorSnack(
        'Google Drive\'a yükleme başarısız: ${ex.message}',
        retryable: ex.retryable,
        onRetry: _backupToDrive,
      );
      return;
    }

    // TEMİZ ÇÖZÜM: yükleme başarılıysa, Drive'a yedeklemek için sadece
    // geçici olarak oluşturulan bu yerel zip artık gereksizdir — bu
    // ekrandaki "Drive'a Yedekle" akışı kullanıcıdan hiçbir zaman ayrıca
    // yerel bir kopya istemedi. Silinmezse her manuel Drive
    // yedeklemesinde cihazda sessizce bir dosya daha birikirdi.
    await BackupHelper.instance.deleteBackupFile(localFile);

    // AŞAMA 6.5: yükleme başarılı olduktan sonra eski Drive yedekleri
    // sessizce temizlenir. Bu adım başarısız olsa bile (örn. anlık ağ
    // kopması) kullanıcının asıl istediği işlem (yedekleme) zaten
    // tamamlanmış olduğundan hata gösterilmez — sessizce yutulur.
    try {
      await GoogleDriveHelper.instance.enforceRetention();
    } catch (_) {
      // Sessizce geç; bir sonraki Drive yedeklemesinde tekrar denenecek.
    }

    _setBusy(false);
    if (!mounted) return;
    _showSnack('Yedek Google Drive\'a başarıyla yüklendi.');
    // AŞAMA 5.2 ile aynı mantık: son yedekleme bilgisini anında yenile.
    _lastBackupKey.currentState?.refresh();
  }

  // ── GOOGLE DRIVE'DAN GERİ YÜKLE — AŞAMA 6.6 ─────────────────────────
  //
  // Akış: izin kontrolü → (gerekiyorsa) Google'a bağlanma → Drive
  // yedeklerini listeleme (Aşama 6.3) → kullanıcının bir yedek seçmesi →
  // indirme (Aşama 6.4) → MEVCUT _restoreFromFile() akışı (Aşama 4).
  // Not: burada basit bir seçim diyaloğu kullanılır; Aşama 6.7'de bu
  // seçim, cihaz yedekleriyle aynı ekranda (Yedek Geçmişi) sekmeli/
  // birleşik bir listeye taşınacak — bu fonksiyonun kendisi değişmeyecek,
  // sadece listeyi kimin gösterdiği değişecek.
  Future<void> _restoreFromDrive() async {
    if (_busy) return;

    if (!await _ensurePermission()) return;

    if (!_driveSignedIn) {
      if (!await _confirmConnectDriveFirst()) return;
      await _connectGoogleDrive();
      if (!_driveSignedIn) return;
    }

    _setBusy(true, label: 'Drive yedekleri listeleniyor...');
    List<GoogleDriveBackupFile> backups;
    try {
      backups = await GoogleDriveHelper.instance.listBackups();
    } catch (e) {
      _setBusy(false);
      final ex = GoogleDriveException.fromError(e);
      _showErrorSnack(
        'Yedekler listelenemedi: ${ex.message}',
        retryable: ex.retryable,
        onRetry: _restoreFromDrive,
      );
      return;
    }
    _setBusy(false);

    if (backups.isEmpty) {
      _showSnack('Google Drive\'da henüz bir yedek bulunmuyor.');
      return;
    }

    if (!mounted) return;
    final selected = await showDialog<GoogleDriveBackupFile>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dNoteCardColor(ctx),
        title: Text(
          'Drive\'dan Yedek Seç',
          style: TextStyle(color: appAccentColor.value),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: backups.length,
            separatorBuilder: (_, __) => Divider(
              color: dNoteBorderColor(ctx),
              height: 1,
            ),
            itemBuilder: (_, i) {
              final b = backups[i];
              return ListTile(
                leading: Icon(
                  Icons.cloud_outlined,
                  color: appAccentColor.value,
                ),
                title: Text(
                  b.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: dNoteTextColor(ctx), fontSize: 13),
                ),
                subtitle: Text(
                  '${_formatDriveDate(b.modifiedTime)} · '
                  '${BackupHelper.instance.formatFileSize(b.sizeBytes)}',
                  style: TextStyle(
                    color: dNoteTextColor(ctx).withValues(alpha: 0.65),
                    fontSize: 12,
                  ),
                ),
                onTap: () => Navigator.pop(ctx, b),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
        ],
      ),
    );
    if (selected == null) return;

    _setBusy(true, label: 'Yedek Drive\'dan indiriliyor...');
    File localFile;
    try {
      localFile = await GoogleDriveHelper.instance.downloadBackup(
        selected,
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
      final ex = GoogleDriveException.fromError(e);
      _showErrorSnack(
        'İndirme başarısız: ${ex.message}',
        retryable: ex.retryable,
        onRetry: _restoreFromDrive,
      );
      return;
    }
    _setBusy(false);

    // AŞAMA 6.4'te açıklandığı gibi: indirilen dosya artık normal bir
    // cihaz yedeğidir; kod tekrarı olmadan mevcut önizleme/onay/geri
    // yükleme akışına (Aşama 4) doğrudan verilir.
    await _restoreFromFile(localFile);
  }

  // Drive'dan gelen değiştirilme tarihini (DateTime?) ekrandaki diğer
  // tarih formatlarıyla (bkz. _formatPreviewDate) tutarlı biçimde yazar.
  String _formatDriveDate(DateTime? dt) {
    if (dt == null) return 'Bilinmiyor';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}.${two(dt.month)}.${dt.year} '
        '${two(dt.hour)}:${two(dt.minute)}';
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
    // AŞAMA: manuel ("Cihaza Yedekle") yedeklerde de aynı yerel saklama
    // sınırı uygulanır. Önceden enforceLocalRetention() yalnızca otomatik
    // yedekleme akışında çağrılıyordu; bu yüzden elle alınan yedekler hiç
    // silinmeden birikiyordu (7, 8, 9... gibi). Ayarlar ekranındaki
    // "maks. yerel yedek sayısı" (varsayılan 5) artık burada da geçerli.
    try {
      final maxLocalBackups =
          await AutoBackupService.instance.getMaxLocalBackups();
      await BackupHelper.enforceLocalRetention(maxLocalBackups);
    } catch (_) {
      // Sessizce geç: temizleme başarısız olsa bile yeni yedek zaten
      // oluşturuldu, kullanıcı akışını bozmaya değmez.
    }
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
        title: Text('Büyük Yedek', style: TextStyle(color: appAccentColor.value)),
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
              backgroundColor: appAccentColor.value,
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
        title: Text('Yedek Hazır', style: TextStyle(color: appAccentColor.value)),
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
              backgroundColor: appAccentColor.value,
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
    // Kullanıcı bu ekranda Google hesabına bağlanmış/bağlantıyı kesmiş
    // olabilir (BackupHistoryScreen kendi ayrı Drive bağlantı state'ini
    // tutuyor) — geri dönüşte burası da tazelenmezse Drive kartı eski
    // durumda kalmaya devam eder.
    _refreshDriveStatus();
    if (selected != null) {
      await _restoreFromFile(selected);
    }
  }

  // Yedekleme ayarlarının tek bir ekranda toplanması amacıyla eklendi:
  // Ayarlar sayfasındaki "Otomatik Yedekleme Ayarları" girişi kaldırıldı,
  // buradan açılıyor.
  void _openAutoBackupSettings() async {
    if (_busy) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AutoBackupSettingsScreen()),
    );
    // Kullanıcı ayarlar ekranında anahtarı değiştirip geri dönmüş
    // olabilir; bu ekrandaki küçük durum kartının güncel kalması için
    // tazelenir. Ayrıca o ekrandan Google hesabına bağlanmış/bağlantıyı
    // kesmiş olabilir (AutoBackupSettingsScreen kendi Drive bağlantı
    // durumunu ayrı bir state olarak tutuyor) — bu yüzden Drive kartı da
    // burada tazelenmezse eski durumda ("bağlı değil") kalmaya devam eder.
    _refreshAutoBackupStatus();
    _refreshDriveStatus();
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
        title: Text(
          'Yedeği Geri Yükle',
          style: TextStyle(color: appAccentColor.value),
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
          Icon(icon, size: 16, color: appAccentColor.value),
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
                  // AŞAMA 6.6: Google Drive bağlantı durumu — bağlıysa
                  // hesap e-postası ve "Bağlantıyı Kes", bağlı değilse
                  // "Bağlan" butonu gösterilir.
                  _driveStatusCard(context),
                  // Otomatik yedekleme durumu — Drive kartıyla aynı
                  // tasarımda, hemen altında. Ayarlar sayfasındaki eski
                  // "Otomatik Yedekleme Ayarları" girişi kaldırıldığı gibi,
                  // bu ekrandaki eski büyük _actionCard girişi de kaldırılıp
                  // buraya taşındı.
                  _autoBackupStatusCard(context),
                  Text(
                    'Notlarınızı, kategorilerinizi, ayarlarınızı ve eklerinizi '
                    'tek bir .zip dosyası olarak yedekleyebilir veya daha '
                    'önce aldığınız bir yedeği geri yükleyebilirsiniz.',
                    style: TextStyle(
                      color: dNoteTextColor(context).withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // AŞAMA 6.6/8: Google Drive'a manuel yedekleme.
                  _actionCard(
                    context,
                    icon: Icons.cloud_upload_outlined,
                    title: 'Google Drive\'a Yedekle',
                    subtitle:
                        'Yeni bir yedek oluşturup doğrudan Google Drive\'ınızın '
                        'gizli alanına yükleyin.',
                    buttonLabel: 'Drive\'a Yedekle',
                    onPressed: _backupToDrive,
                  ),
                  const SizedBox(height: 16),
                  _actionCard(
                    context,
                    icon: Icons.backup_outlined,
                    title: 'Cihaza Yedekle',
                    subtitle:
                        'Tüm verilerinizi tek bir .zip dosyası olarak cihaza '
                        'kaydedin ve isterseniz paylaşın.',
                    buttonLabel: 'Cihaza Yedekle',
                    onPressed: _createBackup,
                  ),
                  const SizedBox(height: 16),
                  // AŞAMA 5.1: cihazda oluşturulmuş yedeklerin tarih ve
                  // boyut bilgisiyle listelendiği geçmiş ekranına geçiş.
                  // "Cihazdan Yedek Seç" ve "Google Drive'dan Geri Yükle"
                  // işlevleri artık bu ekrandan yapılıyor.
                  _actionCard(
                    context,
                    icon: Icons.history_outlined,
                    title: 'Yedek Geçmişi',
                    subtitle:
                        'Cihazda kayıtlı tüm yedekleri tarih ve boyutlarıyla '
                        'görüntüleyin; buradan doğrudan paylaşabilir, geri '
                        'yükleyebilir veya silebilirsiniz.',
                    buttonLabel: 'Geri Yükle',
                    onPressed: _openHistory,
                    outlined: true,
                  ),
                  const SizedBox(height: 28),
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
                                  color: appAccentColor.value,
                                  backgroundColor:
                                      appAccentColor.value.withValues(alpha: 0.15),
                                  strokeWidth: 4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _progress != null
                                    ? '%${(_progress! * 100).clamp(0, 100).toStringAsFixed(0)}'
                                    : '',
                                style: TextStyle(
                                  color: appAccentColor.value,
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

  // AŞAMA 6.6: Google hesabına bağlı olup olunmadığını gösteren, bağlan/
  // bağlantıyı kes aksiyonu içeren küçük durum kartı. LastBackupInfoTile
  // ile aynı görsel dilde ama bu ekranla sınırlı (bağımsız bir dosyaya
  // çıkarılmadı, çünkü sadece burada ve — Aşama 6.9'da — Ayarlar'da
  // kullanılacak; ihtiyaç doğarsa o aşamada ayrı bir widget'a taşınabilir).
  Widget _driveStatusCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: dNoteCardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dNoteBorderColor(context)),
      ),
      child: Row(
        children: [
          Icon(
            _driveSignedIn ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
            color: _driveSignedIn ? Colors.green : appAccentColor.value,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _driveSignedIn
                  ? 'Google Drive: bağlı'
                      '${_driveAccountEmail != null ? ' ($_driveAccountEmail)' : ''}'
                  : 'Google Drive: bağlı değil',
              style: TextStyle(
                color: dNoteTextColor(context).withValues(alpha: 0.85),
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed:
                _driveSignedIn ? _disconnectGoogleDrive : _connectGoogleDrive,
            child: Text(
              _driveSignedIn ? 'Bağlantıyı Kes' : 'Bağlan',
              style: TextStyle(
                color: _driveSignedIn ? Colors.red : appAccentColor.value,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Otomatik yedekleme AÇIK/KAPALI durumunu gösteren, _driveStatusCard ile
  // BİREBİR AYNI tasarımda küçük durum kartı. Solda ikon + durum metni,
  // sağda ayarlar ekranını açan "Ayarla" butonu. Eskiden bu ekranda büyük
  // bir _actionCard (başlık+açıklama+tam genişlik buton) olarak duruyordu;
  // Drive kartıyla aynı yerde/dilde gösterilmesi istendiği için kaldırılıp
  // buraya taşındı.
  Widget _autoBackupStatusCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: dNoteCardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dNoteBorderColor(context)),
      ),
      child: Row(
        children: [
          Icon(
            _autoBackupEnabled ? Icons.cloud_sync_outlined : Icons.sync_disabled,
            color: _autoBackupEnabled ? Colors.green : appAccentColor.value,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _autoBackupEnabled
                  ? 'Otomatik Yedekleme: açık'
                  : 'Otomatik Yedekleme: kapalı',
              style: TextStyle(
                color: dNoteTextColor(context).withValues(alpha: 0.85),
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: _openAutoBackupSettings,
            child: Text(
              'Ayarla',
              style: TextStyle(
                color: appAccentColor.value,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // AŞAMA: tüm _actionCard butonlarının aynı (sabit) genişlikte olmasını
  // sağlamak için kullanılan metin stili ve en uzun etiket. Buton
  // genişliği artık double.infinity (kartın tamamı) değil, bu sabit
  // değere göre hesaplanıyor — böylece kısa etiketli butonlar (ör.
  // "Ayarları Aç") gereksiz yere kocaman görünmüyor, ama hepsi görsel
  // olarak aynı boyda kalıyor.
  static const String _longestActionButtonLabel = 'Drive\'a Yedekle';
  static const TextStyle _actionButtonTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // En uzun buton etiketinin ("Drive'a Yedekle") mevcut yazı tipiyle
  // gerçek genişliğini ölçüp buna FilledButton'ın varsayılan yatay
  // padding'ini (Material 3'te 24+24) ekleyerek sabit bir buton
  // genişliği hesaplar. Bu sayede metin hiçbir zaman kesilmez ve diğer
  // (daha kısa) etiketli butonlar da aynı genişlikte durur.
  double _actionButtonWidth(BuildContext context) {
    final painter = TextPainter(
      text: const TextSpan(
        text: _longestActionButtonLabel,
        style: _actionButtonTextStyle,
      ),
      textDirection: Directionality.of(context),
      // DÜZELTME (buton metni bir alt satıra düşüyordu): eskiden burada
      // textScaler hiç verilmiyordu, yani ölçüm HER ZAMAN ölçeksiz (1.0)
      // yapılıyordu. Cihazda Erişilebilirlik > Yazı Tipi Boyutu normalden
      // büyük ayarlıysa, FilledButton'ın kendi Text'i sistem ölçeğine göre
      // BÜYÜK render ediliyordu ama biz genişliği hep KÜÇÜK (ölçeksiz)
      // hesaplıyorduk — metin gerçek genişlikte sığmayıp "Yedekle" bir alt
      // satıra taşıyordu. Artık ölçüm de MediaQuery'nin gerçek yazı tipi
      // ölçeğini kullanıyor.
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    // DÜZELTME (devamı): sabit +48 payı (24+24 varsayılan FilledButton
    // yatay padding'i) teorik olarak yeterli görünse de, gerçek Material 3
    // render'ında (harf aralığı/font metrikleri gibi küçük farklar
    // yüzünden) tam sınırda kalabiliyordu — özellikle en uzun etiketin
    // KENDİSİ ("Drive'a Yedekle") bazen bir-iki piksel taşıp yine alt
    // satıra düşüyordu. Küçük bir güvenlik payı (+16) eklenerek metnin
    // HER koşulda (farklı yazı tipi ölçekleri dahil) tek satırda kalması
    // garanti edildi.
    return painter.width + 48 + 16;
  }

  Widget _actionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonLabel,
    required VoidCallback onPressed,
    // "Yedek Geçmişi" kartındaki "Geri Yükle" butonu diğer kartlardaki
    // (dolu, amber arka planlı) butonlardan görsel olarak ayrışsın diye
    // eklendi: true olduğunda buton koyu gri zeminli, amber (tema rengi)
    // yazılı ve amber ince kenarlıklı olur — diğer kartlar etkilenmez.
    bool outlined = false,
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
              Icon(icon, color: appAccentColor.value, size: 26),
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
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: _actionButtonWidth(context),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor:
                      outlined ? dNoteCardColor(context) : appAccentColor.value,
                  foregroundColor:
                      outlined ? appAccentColor.value : Colors.black,
                  textStyle: _actionButtonTextStyle,
                  side: outlined
                      ? BorderSide(color: appAccentColor.value, width: 1)
                      : BorderSide.none,
                ),
                onPressed: onPressed,
                child: Text(buttonLabel, textAlign: TextAlign.center),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

