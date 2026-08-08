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
      'com.example.flutter_application_1.NoteWidgetReceiverV2';

  // Widget'ın okuyacağı anahtarlar (Aşama 2'deki Kotlin/Glance kodu bu
  // anahtarları SharedPreferences üzerinden okuyacak).
  static const String keyNoteTitle = 'note_title';
  static const String keyNoteContent = 'note_content';
  static const String keyNoteCount = 'note_count';
  static const String keyUpdatedAt = 'note_updated_at';
  // Widget'ta gösterilen notun id'si. Widget'a tıklanınca uygulamanın
  // doğrudan bu notu açabilmesi için native tarafa yazılır (bkz.
  // NoteWidgetReceiverV2.kt / NoteWidget.kt'deki tıklama Intent'i ve
  // NoteListLifecycleMixin._handleWidgetLaunchUri).
  static const String keyNoteId = 'note_id';
  // TÜM görünür notların id -> {title, preview, modifiedDate} haritası
  // (JSON). Widget ekleme sırasında kullanıcının hangi notu göstermek
  // istediğini seçebilmesi için (bkz. NoteWidgetConfigActivity.kt) ve o an
  // seçili notun güncel başlık/önizlemesini native tarafın kendi başına
  // çözebilmesi için yazılır. keyNoteId/keyNoteTitle/keyNoteContent hâlâ
  // "en son not" değerini taşır ve widget hiç yapılandırılmamışsa (veya
  // seçili not silinmiş/kilitlenmişse) yedek (fallback) olarak kullanılır.
  static const String keyAllNotesJson = 'all_notes_json';

  // Widget'ın checklist/hesap tablosu bloklarını in-app görünümle aynı
  // şekilde (satır satır checkbox, tablo satırları + toplam) çizebilmesi
  // için üretilen YAPILANDIRILMIŞ önizleme. keyNoteContent hâlâ tek
  // satırlık düz metin özet olarak yazılır (kilit ekranı, eski widget
  // sürümleri veya metin gösteremeyen yerler için yedek); bu anahtar ise
  // native Glance kodunun gerçek satır tiplerini ayırt edip kendi
  // checkbox/tablo Composable'larıyla çizmesi içindir.
  //
  // JSON formatı: {"noteId": [ {satır...}, ... ], ...} — her not id'si
  // için ayrı bir satır listesi (keyAllNotesJson ile aynı mantık: widget
  // yapılandırılırken hangi not seçilirse seçilsin native taraf kendi
  // satırlarını burada bulabilsin).
  //
  // Her satır şu tiplerden biridir:
  //   {"type": "text", "text": "..."}
  //   {"type": "checkbox", "text": "...", "checked": bool}
  //   {"type": "table_row", "label": "...", "value": "..."}
  //   {"type": "table_total", "value": "..."}
  //   {"type": "drawing"}
  // NOT: "attachments" (fotoğraf) blokları widget'ta hiç gösterilmez —
  // ne görsel ne de metin ipucu olarak; bilinçli bir tercihtir.
  static const String keyAllNotesLinesJson = 'all_notes_lines_json';

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
      // Notun başlığı boşsa artık "Başlıksız not" YAZILMIYOR — native taraf
      // boş string gördüğünde başlık satırını tamamen gizleyip içeriği
      // (checklist/tablo/metin) doğrudan en üstten gösteriyor. Hiç not
      // yokken (latest == null) hâlâ "Henüz not yok" gösterilir; bu farklı
      // bir durum (placeholder), boş başlıkla karıştırılmamalı.
      final title = (latest?['title']?.toString().trim().isNotEmpty == true)
          ? latest!['title'].toString()
          : (latest != null ? '' : 'Henüz not yok');
      final preview = latest != null ? _buildPreview(latest) : '';

      // Widget yapılandırma ekranının (not seçici) listeleyebilmesi ve her
      // widget örneğinin kendi seçtiği notun güncel içeriğini native
      // tarafta bulabilmesi için TÜM görünür notların özetini id'ye göre
      // haritalayıp JSON olarak yazıyoruz.
      final allNotesMap = <String, dynamic>{};
      final allNotesLinesMap = <String, dynamic>{};
      for (final n in visible) {
        final id = n['id']?.toString();
        if (id == null || id.isEmpty) continue;
        // Aynı şekilde: başlık boşsa "Başlıksız not" değil, boş string
        // yazılır (bkz. yukarıdaki açıklama).
        final nTitle = (n['title']?.toString().trim().isNotEmpty == true)
            ? n['title'].toString()
            : '';
        allNotesMap[id] = {
          'title': nTitle,
          'preview': _buildPreview(n),
          'modifiedDate': n['modifiedDate']?.toString() ?? '',
        };
        allNotesLinesMap[id] = _buildStructuredLines(n);
      }

      await Future.wait([
        HomeWidget.saveWidgetData<String>(
          keyNoteId,
          latest?['id']?.toString() ?? '',
        ),
        HomeWidget.saveWidgetData<String>(keyNoteTitle, title),
        HomeWidget.saveWidgetData<String>(keyNoteContent, preview),
        HomeWidget.saveWidgetData<String>(
          keyAllNotesJson,
          jsonEncode(allNotesMap),
        ),
        HomeWidget.saveWidgetData<String>(
          keyAllNotesLinesJson,
          jsonEncode(allNotesLinesMap),
        ),
        HomeWidget.saveWidgetData<int>(keyNoteCount, visible.length),
        HomeWidget.saveWidgetData<String>(
          keyUpdatedAt,
          DateTime.now().toIso8601String(),
        ),
      ]);

      await HomeWidget.updateWidget(
        qualifiedAndroidName: _androidQualifiedReceiver,
      );
    } catch (e, st) {
      // GEÇİCİ TEŞHİS: hatayı artık yutmuyoruz, ekrana basıyoruz.
      // ignore: avoid_print
      print('WIDGET HATASI (syncFromNotes): $e');
      // ignore: avoid_print
      print(st);
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
  /// olabilir. Widget önizlemesi için bloklar tek tek işlenir ki zengin
  /// metin/bloklu notlarda içerik boş kalmasın.
  ///
  /// Notun kendisi tamamen "checklist" tipindeyse (type == 'checklist'),
  /// maddeler content alanında değil, ayrı bir checkItems alanında
  /// tutulur (bkz. DBHelper._rowToNote). Bu durumda önizleme checkItems
  /// listesinden üretilir; aksi halde content bloklara ayrıştırılıp
  /// (ContentBlocks.parse) işlenir — böylece bir metin notunun İÇİNE
  /// eklenmiş checklist/hesap tablosu blokları da doğru gösterilir.
  ///
  /// Checklist maddeleri, işaretli olup olmadığını widget'ta da
  /// görülebilir kılmak için ✓ (işaretli) / ☐ (işaretsiz) sembolüyle
  /// başlar.
  String _buildPreview(Map<String, dynamic> note) {
    final lines = <String>[];

    void addChecklistItems(List items) {
      for (final it in items) {
        final m = it as Map;
        final t = (m['text'] ?? '').toString().trim();
        if (t.isEmpty) continue;
        final checked = m['checked'] == true;
        lines.add('${checked ? '✓' : '☐'} $t');
      }
    }

    void addCalcTableRows(List rows) {
      double total = 0;
      var any = false;
      for (final r in rows) {
        final row = r as Map;
        final label = (row['label'] ?? '').toString();
        final valueText = (row['value'] ?? '').toString();
        total += ContentBlocks.parseCalcValue(row['value']);
        if (label.trim().isNotEmpty || valueText.trim().isNotEmpty) {
          any = true;
          lines.add('$label: $valueText');
        }
      }
      if (any) {
        lines.add('Toplam: ${ContentBlocks.formatCalcNumber(total)}');
      }
    }

    if (note['type']?.toString() == 'checklist') {
      addChecklistItems(note['checkItems'] as List? ?? const []);
    } else {
      final blocks = ContentBlocks.parse(note['content']?.toString());
      for (final b in blocks) {
        switch (b['type']) {
          case 'text':
            final t = (b['text'] ?? '').toString();
            for (final line in t.split('\n')) {
              if (line.trim().isNotEmpty) lines.add(line.trim());
            }
            break;
          case 'checklist':
            addChecklistItems(b['items'] as List? ?? const []);
            break;
          case 'calc_table':
            addCalcTableRows(b['rows'] as List? ?? const []);
            break;
          case 'attachments':
            // İstek üzerine widget'ta fotoğraf gösterilmiyor VE fotoğraf
            // olduğuna dair bir metin ipucu da bırakılmıyor; bu blok
            // sessizce atlanır.
            break;
          case 'drawing':
            final strokes = (b['strokes'] as List? ?? const []);
            if (strokes.isNotEmpty) {
              lines.add('✏️ Çizim');
            }
            break;
        }
      }
    }

    // Satırları tek boşlukla birleştirmek "Elma: 5 Armut: 3 Toplam: 8" gibi
    // okunması zor bir bloğa dönüşüyordu. Satırları " • " ile ayırarak
    // widget'ın tek satırlık alanında bile hangi kısmın nereye ait olduğu
    // görülebiliyor.
    var text = lines.where((l) => l.trim().isNotEmpty).join(' • ');
    const maxLen = 80;
    if (text.length > maxLen) {
      text = '${text.substring(0, maxLen)}…';
    }
    return text;
  }

  /// [_buildPreview] ile aynı veriden yola çıkar ama satırları tek bir
  /// stringe eritmek yerine tiplenmiş (checkbox / tablo satırı / metin)
  /// bir liste olarak döner. Native widget bu listeyi parse edip her
  /// satır tipini kendi Composable'ıyla (checkbox ikonu, iki kolonlu
  /// tablo satırı vb.) çizerek in-app görünümle aynı düzeni elde edebilir.
  ///
  /// Widget alanı sınırlı olduğundan satır sayısı [maxLines] ile
  /// kısıtlanır; kesilen içerik için son satıra "…" eklenir.
  List<Map<String, dynamic>> _buildStructuredLines(
    Map<String, dynamic> note, {
    int maxLines = 12,
  }) {
    final lines = <Map<String, dynamic>>[];
    var truncated = false;

    void addLine(Map<String, dynamic> line) {
      if (lines.length >= maxLines) {
        truncated = true;
        return;
      }
      lines.add(line);
    }

    void addChecklistItems(List items) {
      for (final it in items) {
        final m = it as Map;
        final t = (m['text'] ?? '').toString().trim();
        if (t.isEmpty) continue;
        addLine({
          'type': 'checkbox',
          'text': t,
          'checked': m['checked'] == true,
        });
      }
    }

    void addCalcTableRows(List rows) {
      double total = 0;
      var any = false;
      for (final r in rows) {
        final row = r as Map;
        final label = (row['label'] ?? '').toString();
        final valueText = (row['value'] ?? '').toString();
        total += ContentBlocks.parseCalcValue(row['value']);
        if (label.trim().isNotEmpty || valueText.trim().isNotEmpty) {
          any = true;
          addLine({
            'type': 'table_row',
            'label': label,
            'value': valueText,
          });
        }
      }
      if (any) {
        addLine({
          'type': 'table_total',
          'value': ContentBlocks.formatCalcNumber(total),
        });
      }
    }

    if (note['type']?.toString() == 'checklist') {
      addChecklistItems(note['checkItems'] as List? ?? const []);
    } else {
      final blocks = ContentBlocks.parse(note['content']?.toString());
      for (final b in blocks) {
        switch (b['type']) {
          case 'text':
            final t = (b['text'] ?? '').toString();
            for (final line in t.split('\n')) {
              if (line.trim().isNotEmpty) {
                addLine({'type': 'text', 'text': line.trim()});
              }
            }
            break;
          case 'checklist':
            addChecklistItems(b['items'] as List? ?? const []);
            break;
          case 'calc_table':
            addCalcTableRows(b['rows'] as List? ?? const []);
            break;
          case 'attachments':
            // İstek üzerine widget'ta fotoğraf gösterilmiyor VE fotoğraf
            // olduğuna dair bir metin ipucu da bırakılmıyor; bu blok
            // sessizce atlanır.
            break;
          case 'drawing':
            final strokes = (b['strokes'] as List? ?? const []);
            if (strokes.isNotEmpty) {
              addLine({'type': 'drawing'});
            }
            break;
        }
      }
    }

    if (truncated && lines.isNotEmpty) {
      lines.add({'type': 'text', 'text': '…'});
    }
    return lines;
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
    } catch (e, st) {
      // GEÇİCİ TEŞHİS: hatayı artık yutmuyoruz, ekrana basıyoruz.
      // ignore: avoid_print
      print('WIDGET HATASI (syncAppearanceSettings): $e');
      // ignore: avoid_print
      print(st);
    }
  }
}
