part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// SON YEDEKLEME BİLGİSİ — AŞAMA 5.2
// Son başarılı yedeklemenin ne zaman alındığını gösteren, tekrar
// kullanılabilir küçük bir widget. Tarih, BackupHelper.instance
// .getLastBackupDate() ile okunur (bkz. backup_helper_5_2.dart) — bu
// değer her başarılı createBackup() çağrısından sonra otomatik olarak
// güncellenir.
//
// Bu aşamada BackupRestoreScreen'in en üstüne eklendi. Uygulamanın
// Ayarlar ekranına da eklenmesi istendiği için widget kasıtlı olarak
// bağımsız/kendi kendine yeten (StatefulWidget, kendi verisini kendi
// yükler) tasarlandı — herhangi bir ekrana tek satırla eklenebilir:
//
//   const LastBackupInfoTile(),
//
// Ayarlar ekranı dosyası bu proje kapsamında paylaşılmadığından, o
// dosyadaki değişiklik doğrudan burada yapılamadı; en alttaki notta
// nereye ekleneceği açıklanmıştır.
// ════════════════════════════════════════════════════════════════════════
class LastBackupInfoTile extends StatefulWidget {
  const LastBackupInfoTile({super.key});

  @override
  State<LastBackupInfoTile> createState() => _LastBackupInfoTileState();
}

class _LastBackupInfoTileState extends State<LastBackupInfoTile> {
  bool _loading = true;
  DateTime? _lastBackup;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    DateTime? dt;
    try {
      dt = await BackupHelper.instance.getLastBackupDate();
    } catch (_) {
      dt = null;
    }
    if (!mounted) return;
    setState(() {
      _lastBackup = dt;
      _loading = false;
    });
  }

  // Dışarıdan (örn. yeni bir yedek oluşturulduktan hemen sonra, ekrandan
  // çıkıp geri girmeye gerek kalmadan) yeniden okumak için kullanılır.
  // Bkz. BackupRestoreScreen._createBackup() içindeki kullanımı.
  Future<void> refresh() => _load();

  String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    final now = DateTime.now();
    final sameDay =
        now.year == dt.year && now.month == dt.month && now.day == dt.day;
    final timeStr = '${two(dt.hour)}:${two(dt.minute)}';
    if (sameDay) return 'Bugün $timeStr';
    return '${two(dt.day)}.${two(dt.month)}.${dt.year} $timeStr';
  }

  @override
  Widget build(BuildContext context) {
    // Yükleniyor durumunda hiçbir şey göstermeyip yer kaplamıyoruz;
    // ilk açılışta anlık bir "boş kutu" titremesi yaratmamak için.
    if (_loading) return const SizedBox.shrink();

    final hasBackup = _lastBackup != null;
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
            hasBackup ? Icons.check_circle_outline : Icons.info_outline,
            color: hasBackup ? Colors.green : Colors.amber,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              hasBackup
                  ? 'Son yedekleme: ${_formatDate(_lastBackup!)}'
                  : 'Henüz hiç yedek alınmadı.',
              style: TextStyle(
                color: dNoteTextColor(context).withValues(alpha: 0.85),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
// AYARLAR EKRANINIZA EKLEMEK İÇİN (bilgi amaçlı not):
// Ayarlar ekranınızın build() metodunda, uygun bir satıra şunu ekleyin:
//
//   const LastBackupInfoTile(),
//
// Widget kendi verisini kendi yükler; ek bir parametre veya state
// yönetimi gerekmez. Ayarlar ekranı dosyası bu proje kapsamında
// paylaşılmadığından değişiklik doğrudan o dosyaya işlenemedi.
// ════════════════════════════════════════════════════════════════════════
