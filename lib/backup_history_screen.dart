part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// YEDEK GEÇMİŞİ EKRANI — AŞAMA 5.1
// Cihazda (dnote_backups klasöründe) bulunan tüm yedek dosyalarını, en
// yeni en üstte olacak şekilde, tarih ve boyut bilgisiyle listeler.
// Her yedek satırı için üç aksiyon sunulur:
//   • Geri Yükle → seçilen dosya BackupRestoreScreen'e geri döndürülür;
//     önizleme/onay/geri yükleme akışının TAMAMI (Aşama 4'te tamamlanan
//     mantık) orada, tek bir yerde çalışır — kod tekrarı yapılmaz.
//   • Paylaş    → share_plus ile dosyayı paylaşıma açar.
//   • Sil       → onay alındıktan sonra dosyayı diskten kalıcı olarak siler.
//
// PERFORMANS NOTU (bkz. Aşama 5.3): liste sadece dosya adı + son değişiklik
// tarihi + boyutunu okur; zip içeriğini AÇMAZ / decode ETMEZ. Bu sayede çok
// sayıda veya büyük yedek olsa bile liste anında yüklenir.
// ════════════════════════════════════════════════════════════════════════
class BackupHistoryScreen extends StatefulWidget {
  const BackupHistoryScreen({super.key});

  @override
  State<BackupHistoryScreen> createState() => _BackupHistoryScreenState();
}

class _BackupHistoryScreenState extends State<BackupHistoryScreen> {
  bool _loading = true;
  bool _busy = false;
  List<File> _backups = [];

  @override
  void initState() {
    super.initState();
    _loadBackups();
  }

  Future<void> _loadBackups() async {
    if (!mounted) return;
    setState(() => _loading = true);
    List<File> files;
    try {
      files = await BackupHelper.instance.listBackups();
    } catch (_) {
      files = [];
    }
    if (!mounted) return;
    setState(() {
      _backups = files;
      _loading = false;
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

  String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}.${two(dt.month)}.${dt.year} '
        '${two(dt.hour)}:${two(dt.minute)}';
  }

  Future<void> _shareBackup(File file) async {
    try {
      await Share.shareXFiles([XFile(file.path)], text: 'dnote yedek dosyası');
    } catch (e) {
      _showSnack('Paylaşım başlatılamadı: $e', isError: true);
    }
  }

  Future<void> _deleteBackup(File file) async {
    if (_busy) return;
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

    setState(() => _busy = true);
    await BackupHelper.instance.deleteBackupFile(file);
    if (!mounted) return;
    setState(() {
      _backups.removeWhere((f) => f.path == file.path);
      _busy = false;
    });
    _showSnack('Yedek silindi.');
  }

  // AŞAMA 5.1: seçilen dosyayı BackupRestoreScreen'e geri döndürür; asıl
  // önizleme/onay/geri yükleme akışı orada (Aşama 4 mantığı) çalışır.
  // Böylece geri yükleme mantığı iki ayrı yerde tekrar yazılmış olmaz ve
  // ileride o mantıkta yapılacak bir değişiklik tek yerden yönetilir.
  void _restoreBackup(File file) {
    if (_busy) return;
    Navigator.pop(context, file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yedek Geçmişi')),
      body: AbsorbPointer(
        absorbing: _busy,
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              )
            : _backups.isEmpty
                ? _emptyState(context)
                : RefreshIndicator(
                    onRefresh: _loadBackups,
                    color: Colors.amber,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _backups.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (ctx, i) => _backupTile(ctx, _backups[i]),
                    ),
                  ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_outlined,
              size: 48,
              color: dNoteTextColor(context).withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),
            Text(
              'Henüz cihazda kayıtlı bir yedek yok.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: dNoteTextColor(context).withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '"Yedek Oluştur" ile ilk yedeğinizi alabilirsiniz.',
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

  Widget _backupTile(BuildContext context, File file) {
    final stat = file.statSync();
    return Container(
      decoration: BoxDecoration(
        color: dNoteCardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dNoteBorderColor(context)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.folder_zip_outlined, color: Colors.amber, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.basename(file.path),
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
                  '${_formatDate(stat.modified)} · '
                  '${BackupHelper.instance.formatFileSize(stat.size)}',
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
            onSelected: (value) {
              switch (value) {
                case 'restore':
                  _restoreBackup(file);
                  break;
                case 'share':
                  _shareBackup(file);
                  break;
                case 'delete':
                  _deleteBackup(file);
                  break;
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'restore',
                child: Row(
                  children: [
                    const Icon(
                      Icons.restore_outlined,
                      size: 18,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Geri Yükle',
                      style: TextStyle(color: dNoteTextColor(ctx)),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(
                      Icons.share_outlined,
                      size: 18,
                      color: dNoteTextColor(ctx),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Paylaş',
                      style: TextStyle(color: dNoteTextColor(ctx)),
                    ),
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
