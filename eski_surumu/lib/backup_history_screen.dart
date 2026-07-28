part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// YEDEK GEÇMİŞİ EKRANI — AŞAMA 5.1 + AŞAMA 6.7
//
// AŞAMA 5.1: Cihazda (dnote_backups klasöründe) bulunan tüm yedek
// dosyalarını, en yeni en üstte olacak şekilde, tarih ve boyut bilgisiyle
// listeler. Her yedek satırı için üç aksiyon sunulur: Geri Yükle / Paylaş /
// Sil.
//
// AŞAMA 6.7: Ekrana "Cihaz" ve "Google Drive" olmak üzere iki sekme
// eklendi. Drive sekmesi, GoogleDriveHelper.listBackups() (Aşama 6.3) ile
// appDataFolder'daki yedekleri aynı görünümde listeler. Drive yedeklerinde
// de üç aksiyon vardır, ama ikisi (Geri Yükle / Paylaş) önce dosyayı
// GoogleDriveHelper.downloadBackup() (Aşama 6.4) ile cihaza indirir —
// çünkü Drive'daki bir dosya doğrudan paylaşılamaz veya geri
// yüklenemez, önce yerel bir File olması gerekir. İndirme bittikten
// sonra:
//   • Geri Yükle → indirilen dosya, cihaz sekmesindeki "Geri Yükle" ile
//     TAMAMEN AYNI şekilde bu ekranı kapatıp BackupRestoreScreen'e geri
//     döner (Navigator.pop(context, file)); önizleme/onay/geri yükleme
//     akışının tamamı orada, tek bir yerde çalışır — kod tekrarı yoktur.
//   • Paylaş → indirilen dosya share_plus ile paylaşılır (cihaz
//     sekmesindeki paylaşımla birebir aynı mekanizma).
//   • Sil    → indirme YAPILMAZ; GoogleDriveHelper.deleteBackup() ile
//     doğrudan Drive'dan silinir (onay diyaloğu ile, bkz. google_drive_
//     helper.dart Aşama 6.5 notu: appDataFolder silme işlemi kalıcıdır).
//
// NOT — GEREKLİ EK PART: main.dart içine aşağıdaki satırın eklenmesi
// gerekir (bu dosya Aşama 5'te yoktu, Aşama 6.1'de google_drive_helper.dart
// oluşturuldu ama part listesine henüz eklenmemişti):
//   part 'google_drive_helper.dart';
//
// PERFORMANS NOTU (bkz. Aşama 5.3): cihaz listesi sadece dosya adı + son
// değişiklik tarihi + boyutunu okur; zip içeriğini AÇMAZ / decode ETMEZ.
// Drive listesi de aynı şekilde sadece metadata okur (Aşama 6.3).
// ════════════════════════════════════════════════════════════════════════
class BackupHistoryScreen extends StatefulWidget {
  const BackupHistoryScreen({super.key});

  @override
  State<BackupHistoryScreen> createState() => _BackupHistoryScreenState();
}

class _BackupHistoryScreenState extends State<BackupHistoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // ── Cihaz sekmesi durumu (Aşama 5.1) ─────────────────────────────────
  bool _loadingDevice = true;
  bool _busyDevice = false;
  List<File> _deviceBackups = [];

  // ── Google Drive sekmesi durumu (Aşama 6.7) ─────────────────────────
  bool _loadingDrive = true;
  bool _busyDrive = false;
  bool _driveSignedIn = false;
  String? _driveAccountEmail;
  List<GoogleDriveBackupFile> _driveBackups = [];
  String? _driveErrorMessage;
  bool _driveErrorRetryable = false;

  // İndirme (restore/share öncesi) ilerlemesi — Drive sekmesinde üstte
  // ince bir ilerleme çubuğu olarak gösterilir.
  double? _driveProgress;
  String? _driveProgressLabel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDeviceBackups();
    _loadDriveStatusAndBackups();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
      ),
    );
  }

  String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}.${two(dt.month)}.${dt.year} '
        '${two(dt.hour)}:${two(dt.minute)}';
  }

  String _formatDriveDate(DateTime? dt) {
    if (dt == null) return 'Bilinmiyor';
    return _formatDate(dt);
  }

  // ══════════════════════════════════════════════════════════════════
  // CİHAZ SEKMESİ — AŞAMA 5.1 (değişmedi, sadece isimler netleştirildi)
  // ══════════════════════════════════════════════════════════════════

  Future<void> _loadDeviceBackups() async {
    if (!mounted) return;
    setState(() => _loadingDevice = true);
    List<File> files;
    try {
      files = await BackupHelper.instance.listBackups();
    } catch (_) {
      files = [];
    }
    if (!mounted) return;
    setState(() {
      _deviceBackups = files;
      _loadingDevice = false;
    });
  }

  Future<void> _shareBackup(File file) async {
    try {
      await Share.shareXFiles([XFile(file.path)], text: 'dnote yedek dosyası');
    } catch (e) {
      _showSnack('Paylaşım başlatılamadı: $e', isError: true);
    }
  }

  Future<void> _deleteBackup(File file) async {
    if (_busyDevice) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dNoteCardColor(ctx),
        title: const Text('Yedeği Sil', style: TextStyle(color: Colors.amber)),
        content: Text(
          '"${p.basename(file.path)}" adlı yedek dosyasını kalıcı olarak '
          'silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
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
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _busyDevice = true);
    await BackupHelper.instance.deleteBackupFile(file);
    if (!mounted) return;
    setState(() {
      _deviceBackups.removeWhere((f) => f.path == file.path);
      _busyDevice = false;
    });
    _showSnack('Yedek silindi.');
  }

  // Seçilen dosyayı BackupRestoreScreen'e geri döndürür; asıl önizleme/
  // onay/geri yükleme akışı orada (Aşama 4 mantığı) çalışır.
  void _restoreDeviceBackup(File file) {
    if (_busyDevice) return;
    Navigator.pop(context, file);
  }

  // ══════════════════════════════════════════════════════════════════
  // GOOGLE DRIVE SEKMESİ — AŞAMA 6.7
  // ══════════════════════════════════════════════════════════════════

  // Sekme her açıldığında / yenilendiğinde: önce sessiz giriş denenir
  // (oturum devam ediyor olabilir), sonra bağlıysa Drive yedekleri
  // listelenir. Bu fonksiyon RefreshIndicator ile de tetiklenebilir.
  Future<void> _loadDriveStatusAndBackups() async {
    if (!mounted) return;
    setState(() {
      _loadingDrive = true;
      _driveErrorMessage = null;
    });

    final signedIn = await GoogleDriveHelper.instance.trySilentSignIn();
    if (!mounted) return;

    if (!signedIn) {
      setState(() {
        _driveSignedIn = false;
        _driveAccountEmail = null;
        _driveBackups = [];
        _loadingDrive = false;
      });
      return;
    }

    setState(() {
      _driveSignedIn = true;
      _driveAccountEmail = GoogleDriveHelper.instance.accountEmail;
    });

    try {
      final backups = await GoogleDriveHelper.instance.listBackups();
      if (!mounted) return;
      setState(() {
        _driveBackups = backups;
        _loadingDrive = false;
      });
    } catch (e) {
      if (!mounted) return;
      final ex = GoogleDriveException.fromError(e);
      setState(() {
        _driveErrorMessage = ex.message;
        _driveErrorRetryable = ex.retryable;
        _driveBackups = [];
        _loadingDrive = false;
      });
    }
  }

  Future<void> _connectDrive() async {
    if (_busyDrive) return;
    setState(() => _busyDrive = true);
    final ok = await GoogleDriveHelper.instance.signIn();
    if (!mounted) return;
    if (ok) {
      await _loadDriveStatusAndBackups();
      if (!mounted) return;
      setState(() => _busyDrive = false);
    } else {
      setState(() => _busyDrive = false);
      _showSnack(
        'Google hesabına bağlanılamadı veya işlem iptal edildi.',
        isError: true,
      );
    }
  }

  Future<void> _disconnectDrive() async {
    if (_busyDrive) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dNoteCardColor(ctx),
        title: const Text(
          'Google Drive Bağlantısını Kes',
          style: TextStyle(color: Colors.amber),
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

    setState(() => _busyDrive = true);
    await GoogleDriveHelper.instance.signOut();
    if (!mounted) return;
    setState(() {
      _driveSignedIn = false;
      _driveAccountEmail = null;
      _driveBackups = [];
      _busyDrive = false;
    });
    _showSnack('Google Drive bağlantısı kesildi.');
  }

  // Ortak indirme yardımcısı: hem "Geri Yükle" hem "Paylaş" aksiyonu,
  // Drive'daki dosyayı önce cihaza indirmek zorunda (bkz. dosya başındaki
  // Aşama 6.7 notu). Başarısız olursa null döner ve hata zaten
  // kullanıcıya gösterilmiş olur.
  Future<File?> _downloadDriveBackup(GoogleDriveBackupFile file) async {
    setState(() {
      _busyDrive = true;
      _driveProgress = 0;
      _driveProgressLabel = 'Başlıyor...';
    });
    try {
      final localFile = await GoogleDriveHelper.instance.downloadBackup(
        file,
        onProgress: (progress, step) {
          if (!mounted) return;
          setState(() {
            _driveProgress = progress;
            _driveProgressLabel = step;
          });
        },
      );
      return localFile;
    } catch (e) {
      final ex = GoogleDriveException.fromError(e);
      _showSnack('İndirme başarısız: ${ex.message}', isError: true);
      return null;
    } finally {
      if (mounted) {
        setState(() {
          _busyDrive = false;
          _driveProgress = null;
          _driveProgressLabel = null;
        });
      }
    }
  }

  // İndirilen dosya, cihaz sekmesindeki "Geri Yükle" ile BİREBİR aynı
  // şekilde bu ekranı kapatıp BackupRestoreScreen'e geri döner — orada
  // Aşama 4'ün önizleme/onay/geri yükleme akışı çalışır.
  Future<void> _restoreDriveBackup(GoogleDriveBackupFile file) async {
    if (_busyDrive) return;
    final localFile = await _downloadDriveBackup(file);
    if (localFile == null || !mounted) return;
    Navigator.pop(context, localFile);
  }

  Future<void> _shareDriveBackup(GoogleDriveBackupFile file) async {
    if (_busyDrive) return;
    final localFile = await _downloadDriveBackup(file);
    if (localFile == null || !mounted) return;
    try {
      await Share.shareXFiles([XFile(localFile.path)], text: 'dnote yedek dosyası');
    } catch (e) {
      _showSnack('Paylaşım başlatılamadı: $e', isError: true);
    }
  }

  // Drive silme İNDİRME GEREKTİRMEZ — doğrudan Drive'daki dosya kimliğiyle
  // silinir (bkz. google_drive_helper.dart Aşama 6.5: kalıcı silme, çöp
  // kutusuna taşımaz).
  Future<void> _deleteDriveBackup(GoogleDriveBackupFile file) async {
    if (_busyDrive) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dNoteCardColor(ctx),
        title: const Text(
          'Drive Yedeğini Sil',
          style: TextStyle(color: Colors.amber),
        ),
        content: Text(
          '"${file.name}" adlı yedeği Google Drive\'dan kalıcı olarak '
          'silmek istediğinize emin misiniz? Bu işlem geri alınamaz ve '
          'dosya çöp kutusuna taşınmaz.',
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
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _busyDrive = true);
    try {
      await GoogleDriveHelper.instance.deleteBackup(file.id);
      if (!mounted) return;
      setState(() {
        _driveBackups.removeWhere((f) => f.id == file.id);
        _busyDrive = false;
      });
      _showSnack('Drive yedeği silindi.');
    } catch (e) {
      if (!mounted) return;
      final ex = GoogleDriveException.fromError(e);
      setState(() => _busyDrive = false);
      _showSnack('Silinemedi: ${ex.message}', isError: true);
    }
  }

  // ══════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yedek Geçmişi'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.amber,
          unselectedLabelColor: dNoteTextColor(context).withValues(alpha: 0.6),
          tabs: const [
            Tab(icon: Icon(Icons.smartphone_outlined), text: 'Cihaz'),
            Tab(icon: Icon(Icons.cloud_outlined), text: 'Google Drive'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _deviceTab(context),
          _driveTab(context),
        ],
      ),
    );
  }

  // ── Cihaz sekmesi görünümü ────────────────────────────────────────
  Widget _deviceTab(BuildContext context) {
    return AbsorbPointer(
      absorbing: _busyDevice,
      child: _loadingDevice
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _deviceBackups.isEmpty
              ? _emptyState(
                  context,
                  icon: Icons.history_outlined,
                  title: 'Henüz cihazda kayıtlı bir yedek yok.',
                  subtitle: '"Yedek Oluştur" ile ilk yedeğinizi alabilirsiniz.',
                )
              : RefreshIndicator(
                  onRefresh: _loadDeviceBackups,
                  color: Colors.amber,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _deviceBackups.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (ctx, i) => _deviceTile(ctx, _deviceBackups[i]),
                  ),
                ),
    );
  }

  // ── Drive sekmesi görünümü ────────────────────────────────────────
  Widget _driveTab(BuildContext context) {
    if (_loadingDrive) {
      return const Center(child: CircularProgressIndicator(color: Colors.amber));
    }

    if (!_driveSignedIn) {
      return _driveSignInPrompt(context);
    }

    return AbsorbPointer(
      absorbing: _busyDrive,
      child: Column(
        children: [
          _driveAccountBar(context),
          if (_busyDrive && _driveProgress != null) _driveProgressBar(context),
          Expanded(
            child: _driveErrorMessage != null
                ? _driveErrorState(context)
                : _driveBackups.isEmpty
                    ? _emptyState(
                        context,
                        icon: Icons.cloud_off_outlined,
                        title: 'Google Drive\'da henüz bir yedek yok.',
                        subtitle:
                            '"Google Drive\'a Yedekle" ile ilk bulut '
                            'yedeğinizi oluşturabilirsiniz.',
                      )
                    : RefreshIndicator(
                        onRefresh: _loadDriveStatusAndBackups,
                        color: Colors.amber,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _driveBackups.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (ctx, i) =>
                              _driveTile(ctx, _driveBackups[i]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _driveSignInPrompt(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_outlined,
              size: 48,
              color: dNoteTextColor(context).withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),
            Text(
              'Drive yedeklerinizi görmek için Google hesabınızla bağlanın.',
              textAlign: TextAlign.center,
              style: TextStyle(color: dNoteTextColor(context).withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 16),
            _busyDrive
                ? const CircularProgressIndicator(color: Colors.amber)
                : FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: _connectDrive,
                    icon: const Icon(Icons.login),
                    label: const Text('Google ile Bağlan'),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _driveAccountBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: dNoteCardColor(context),
      child: Row(
        children: [
          const Icon(Icons.account_circle_outlined, size: 18, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _driveAccountEmail ?? 'Bağlı',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: dNoteTextColor(context).withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ),
          TextButton(
            onPressed: _busyDrive ? null : _disconnectDrive,
            child: const Text(
              'Bağlantıyı Kes',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _driveProgressBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: dNoteCardColor(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _driveProgressLabel ?? '',
            style: TextStyle(
              color: dNoteTextColor(context).withValues(alpha: 0.75),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _driveProgress,
              backgroundColor: dNoteBorderColor(context),
              color: Colors.amber,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _driveErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40, color: Colors.red.shade400),
            const SizedBox(height: 12),
            Text(
              _driveErrorMessage ?? 'Bilinmeyen bir hata oluştu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: dNoteTextColor(context).withValues(alpha: 0.8)),
            ),
            if (_driveErrorRetryable) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                onPressed: _loadDriveStatusAndBackups,
                icon: const Icon(Icons.refresh),
                label: const Text('Tekrar Dene'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _emptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: dNoteTextColor(context).withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: dNoteTextColor(context).withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: dNoteTextColor(context).withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deviceTile(BuildContext context, File file) {
    final stat = file.statSync();
    return _backupTileShell(
      context,
      icon: Icons.folder_zip_outlined,
      title: p.basename(file.path),
      subtitle: '${_formatDate(stat.modified)} · '
          '${BackupHelper.instance.formatFileSize(stat.size)}',
      onSelected: (value) {
        switch (value) {
          case 'restore':
            _restoreDeviceBackup(file);
            break;
          case 'share':
            _shareBackup(file);
            break;
          case 'delete':
            _deleteBackup(file);
            break;
        }
      },
    );
  }

  Widget _driveTile(BuildContext context, GoogleDriveBackupFile file) {
    return _backupTileShell(
      context,
      icon: Icons.cloud_outlined,
      title: file.name,
      subtitle: '${_formatDriveDate(file.modifiedTime)} · '
          '${BackupHelper.instance.formatFileSize(file.sizeBytes)}',
      onSelected: (value) {
        switch (value) {
          case 'restore':
            _restoreDriveBackup(file);
            break;
          case 'share':
            _shareDriveBackup(file);
            break;
          case 'delete':
            _deleteDriveBackup(file);
            break;
        }
      },
    );
  }

  // Cihaz ve Drive satırları görsel olarak birebir aynı; tek fark ikon ve
  // veri kaynağı. Bu yüzden ortak bir "kabuk" widget'a ayrıldı — kod
  // tekrarı yok.
  Widget _backupTileShell(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required void Function(String value) onSelected,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: dNoteCardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dNoteBorderColor(context)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: dNoteTextColor(context),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: dNoteTextColor(context).withValues(alpha: 0.65),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: dNoteTextColor(context)),
            color: dNoteCardColor(context),
            onSelected: onSelected,
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'restore',
                child: Row(
                  children: [
                    const Icon(Icons.restore_outlined, size: 18, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text('Geri Yükle', style: TextStyle(color: dNoteTextColor(ctx))),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share_outlined, size: 18, color: dNoteTextColor(ctx)),
                    const SizedBox(width: 8),
                    Text('Paylaş', style: TextStyle(color: dNoteTextColor(ctx))),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Sil', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
