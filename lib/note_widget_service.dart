part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// ANA EKRAN WİDGET'I - VERİ SENKRONİZASYON SERVİSİ
// Bu dosya, not verisini native (Android/iOS) ana ekran widget'ının
// okuyabileceği paylaşımlı depoya yazar ve widget'ın yeniden çizilmesini
// tetikler. UI/dialog kodlarıyla hiçbir bağlantısı yoktur; DBHelper gibi
// bağımsız bir servis katmanıdır.
//
// Native widget tarafı (Glance) henüz oluşturulmadıysa (Aşama 2
// tamamlanmadıysa) buradaki HomeWidget.updateWidget çağrısı sessizce
// başarısız olur ve try/catch içinde yutulur; uygulamanın geri kalanını
// etkilemez.
// ════════════════════════════════════════════════════════════════════════
class NoteWidgetService {
  NoteWidgetService._internal();
  static final NoteWidgetService instance = NoteWidgetService._internal();

  // Aşama 2'de Android tarafında oluşturulacak Glance receiver'ının tam
  // (paket dahil) sınıf adı. Kotlin dosyasını yazarken bu isimle birebir
  // eşleşmesi gerekir.
  static const String _androidQualifiedReceiver =
      'com.example.flutter_application_1.NoteWidgetReceiver';

  // Widget'ın okuyacağı anahtarlar (Aşama 2'deki Kotlin/Glance kodu bu
  // anahtarları SharedPreferences üzerinden okuyacak).
  static const String keyNoteTitle = 'note_title';
  static const String keyNoteContent = 'note_content';
  static const String keyNoteCount = 'note_count';
  static const String keyUpdatedAt = 'note_updated_at';

  bool _isSyncing = false;
  // _isSyncing sırasında gelen istekleri kaybetmemek için: senkronizasyon
  // bitince tekrar çalıştırılacak "bekleyen" not listesi.
  List<Map<String, dynamic>>? _pendingNotes;

  /// Aktif not listesinden widget'ta gösterilecek özeti çıkarıp native
  /// tarafa yazar. Kilitli/arşivlenmiş notlar gizlilik gereği widget'ta
  /// hiç gösterilmez.
  Future<void> syncFromNotes(List<Map<String, dynamic>> notes) async {
    if (_isSyncing) {
      // Zaten devam eden bir senkronizasyon varsa, en güncel veriyi
      // kaybetmemek için bekleyen listeye kaydedip çık; mevcut çağrı
      // bittiğinde bu veriyle tekrar tetiklenecek.
      _pendingNotes = notes;
      return;
    }
    _isSyncing = true;
    try {
      final visible = notes.where(
        (n) => n['isLocked'] != true && n['isArchived'] != true,
      ).toList();

      visible.sort((a, b) {
        final da = DateTime.tryParse(a['modifiedDate']?.toString() ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);
        final db_ = DateTime.tryParse(b['modifiedDate']?.toString() ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);
        return db_.compareTo(da);
      });

      final latest = visible.isNotEmpty ? visible.first : null;
      final title = (latest?['title']?.toString().trim().isNotEmpty == true)
          ? latest!['title'].toString()
          : (latest != null ? 'Başlıksız not' : 'Henüz not yok');
      final rawContent = latest?['content']?.toString() ?? '';
      final preview = _buildPreview(rawContent);

      await Future.wait([
        HomeWidget.saveWidgetData<String>(keyNoteTitle, title),
        HomeWidget.saveWidgetData<String>(keyNoteContent, preview),
        HomeWidget.saveWidgetData<int>(keyNoteCount, visible.length),
        HomeWidget.saveWidgetData<String>(
          keyUpdatedAt,
          DateTime.now().toIso8601String(),
        ),
      ]);

      await HomeWidget.updateWidget(
        qualifiedAndroidName: _androidQualifiedReceiver,
      );
    } catch (_) {
      // Widget native tarafı henüz kurulmamış olabilir (Aşama 2
      // tamamlanana kadar) veya cihazda widget hiç eklenmemiş olabilir;
      // bu normal bir durumdur, sessizce yut.
    } finally {
      _isSyncing = false;
      final pending = _pendingNotes;
      _pendingNotes = null;
      if (pending != null) {
        // Beklerken gelen en güncel veriyle tekrar dene.
        unawaited(syncFromNotes(pending));
      }
    }
  }

  /// content alanı bazen düz metin, bazen blok tabanlı içerik (JSON)
  /// olabilir. Widget'ta gösterecek kısa, sade bir önizleme metni üretir.
  String _buildPreview(String rawContent) {
    var text = rawContent.trim();
    // Blok tabanlı içerik JSON gibi görünüyorsa (örn. '{' veya '[' ile
    // başlıyorsa) ham JSON'ı widget'ta göstermemek için boşaltıyoruz;
    // ileride content_blocks.dart'taki yapıdan düz metin çıkarma
    // eklenebilir.
    if (text.startsWith('{') || text.startsWith('[')) {
      text = '';
    }
    text = text.replaceAll('\n', ' ').trim();
    const maxLen = 80;
    if (text.length > maxLen) {
      text = '${text.substring(0, maxLen)}…';
    }
    return text;
  }

  /// Ayarlar sayfasındaki Widget bölümünden (Aşama 4) veya uygulama
  /// açılışında kayıtlı ayarlar yüklendiğinde çağrılır. Widget'ın görünüm
  /// tercihlerini (yazı boyutu, arka plan saydamlığı, koyu/açık tema)
  /// native tarafa yazar ve widget'ı yeniden çizer. Bu üç anahtar,
  /// NoteWidget.kt içinde tanımlı KEY_FONT_SIZE / KEY_BG_OPACITY / KEY_DARK
  /// ile birebir eşleşir.
  Future<void> syncAppearanceSettings({
    required double fontSize,
    required double bgOpacity,
    required bool dark,
  }) async {
    try {
      await Future.wait([
        HomeWidget.saveWidgetData<double>('widget_font_size', fontSize),
        HomeWidget.saveWidgetData<double>('widget_bg_opacity', bgOpacity),
        HomeWidget.saveWidgetData<bool>('widget_dark', dark),
      ]);
      await HomeWidget.updateWidget(
        qualifiedAndroidName: _androidQualifiedReceiver,
      );
    } catch (_) {
      // Bkz. syncFromNotes: native taraf henüz kurulmamış veya widget
      // eklenmemiş olabilir, bu normaldir.
    }
  }
}
