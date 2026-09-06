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
  //   {"type": "text", "text": "...", "spans": [...]?}
  //   {"type": "checkbox", "text": "...", "checked": bool, "spans": [...]?}
  //   {"type": "table_row", "label": "...", "value": "..."}
  //   {"type": "table_total", "value": "..."}
  //   {"type": "drawing"}
  // "spans" alanı YALNIZCA o satırda gerçekten en az bir zengin metin
  // aralığı varsa eklenir (yoksa hiç yazılmaz). Biçimi rich_text_spans.dart
  // -> RichTextSpans.parse ile aynıdır (start/end/bold/italic/underline/
  // strikethrough/highlight/fontSize/color/fontFamily/link), TEK fark:
  // start/end burada SATIRA göre (satırın kırpılmış/trim'lenmiş haline
  // göre) indexlenmiştir, bloğun tüm metnine göre DEĞİL — native taraf
  // (NoteWidgetRemoteViewsService.kt -> buildRichLineText) her satırı ayrı
  // ayrı çizdiğinden bu şekilde daha basittir.
  // NOT: "attachments" (fotoğraf) blokları widget'ta hiç gösterilmez —
  // ne görsel ne de metin ipucu olarak; bilinçli bir tercihtir.
  static const String keyAllNotesLinesJson = 'all_notes_lines_json';

  // Bu serviste BuildContext yok, dolayısıyla AppLocalizations.of(context)
  // kullanılamıyor. Bunun yerine main.dart'taki locale resolution
  // callback'i (Aşama 13) her dil değişiminde bu alanı günceller; burada
  // lookupAppLocalizations(currentLocale) ile çeviri metinlerine erişilir.
  static Locale currentLocale = const Locale('tr');

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
      final l10n = lookupAppLocalizations(currentLocale);
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
          : (latest != null ? '' : l10n.noteWidgetNoNotesPlaceholder);
      final preview = latest != null ? _buildPreview(latest, l10n) : '';

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
          'preview': _buildPreview(n, l10n),
          'modifiedDate': n['modifiedDate']?.toString() ?? '',
        };
        allNotesLinesMap[id] = _buildStructuredLines(n);
      }

      // GEÇİCİ TEŞHİS: widget'ın GERÇEKTEN okuduğu veri bu — NoteWidget.kt
      // (Glance) değil, NoteWidgetRemoteViewsService + ListView kullanıyor
      // ve o servis 'all_notes_lines_json' içinden bu notun satırlarını
      // okuyor. Önceki 'preview' logu bu yüzden yanıltıcıydı; asıl bakmamız
      // gereken buradaki JSON — her satırın "text" alanında boş string
      // ("") var mı yok mu, ona bakılacak.
      if (latest != null) {
        final latestId = latest['id']?.toString();
        // ignore: avoid_print
        print(
          'WIDGET LINES DEBUG ($latestId): '
          '${jsonEncode(allNotesLinesMap[latestId])}',
        );
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
  String _buildPreview(Map<String, dynamic> note, AppLocalizations l10n) {
    // DÜZELTME: Bloklar artık tek bir düz listeye değil, her biri kendi
    // "parça"sına (chunk) yazılıyor; parçalar arasına -bir yazı bloğu ile
    // hemen ardından gelen bir hesap tablosu gibi farklı blok tiplerinin
    // arasında da boşluk görünmesi için- boş bir satır ekleniyor. Aksi
    // halde boşluk sadece TEK bir metin bloğunun kendi içindeki satırlar
    // arasında görünüyordu, bloklar birbirine yapışık kalıyordu.

    List<String> checklistChunk(List items) {
      final chunk = <String>[];
      for (final it in items) {
        final m = it as Map;
        final t = (m['text'] ?? '').toString().trim();
        if (t.isEmpty) continue;
        final checked = m['checked'] == true;
        chunk.add('${checked ? '✓' : '☐'} $t');
      }
      return chunk;
    }

    List<String> calcTableChunk(List rows) {
      final chunk = <String>[];
      double total = 0;
      var any = false;
      for (final r in rows) {
        final row = r as Map;
        final label = (row['label'] ?? '').toString();
        final valueText = (row['value'] ?? '').toString();
        total += ContentBlocks.parseCalcValue(row['value']);
        if (label.trim().isNotEmpty || valueText.trim().isNotEmpty) {
          any = true;
          chunk.add('$label: $valueText');
        }
      }
      if (any) {
        chunk.add(
          l10n.noteWidgetPreviewTotalLabel(
            ContentBlocks.formatCalcNumber(total),
          ),
        );
      }
      return chunk;
    }

    // "table" (Notion tarzı basit satır/sütun tablosu) bloğunun her
    // satırını, hücreleri " | " ile ayrılmış tek bir düz metin satırına
    // çevirir — content_blocks.dart -> ContentBlocks.toPlainTextLines'taki
    // AYNI birleştirme deseni.
    List<String> tableChunk(List rows) {
      final chunk = <String>[];
      for (final r in rows) {
        // DÜZELTME: boş hücreler satıra hiç dahil edilmiyor (ne metin ne
        // ayraç) — aksi halde bir satırda bazı sütunlar hep boşsa, boş
        // hücreler yine de kendi " | " ayracıyla satıra giriyor ve widget'ta
        // dolu hücrenin yanında art arda boşluklu "|" karakterleri kalıyordu.
        final cells = (r as List)
            .map((c) => ContentBlocks._tableCellText(c))
            .where((t) => t.trim().isNotEmpty)
            .toList();
        if (cells.isEmpty) continue;
        chunk.add(cells.join(' | '));
      }
      return chunk;
    }

    List<String> textChunk(String raw) {
      final rawLines = raw.split('\n');
      // Bloğun sadece en baş/sonundaki boş satırlar kırpılır; arada kalan
      // boş satırlar (kullanıcının bıraktığı paragraf boşlukları) korunur.
      var start = 0;
      var end = rawLines.length;
      while (start < end && rawLines[start].trim().isEmpty) {
        start++;
      }
      while (end > start && rawLines[end - 1].trim().isEmpty) {
        end--;
      }
      return [for (var i = start; i < end; i++) rawLines[i].trim()];
    }

    final chunks = <List<String>>[];

    if (note['type']?.toString() == 'checklist') {
      chunks.add(checklistChunk(note['checkItems'] as List? ?? const []));
    } else {
      final blocks = ContentBlocks.parse(note['content']?.toString());
      for (final b in blocks) {
        switch (b['type']) {
          case 'text':
            chunks.add(textChunk((b['text'] ?? '').toString()));
            break;
          case 'checklist':
            chunks.add(checklistChunk(b['items'] as List? ?? const []));
            break;
          case 'calc_table':
            chunks.add(calcTableChunk(b['rows'] as List? ?? const []));
            break;
          case 'table':
            chunks.add(tableChunk(b['rows'] as List? ?? const []));
            break;
          case 'attachments':
            // İstek üzerine widget'ta fotoğraf gösterilmiyor VE fotoğraf
            // olduğuna dair bir metin ipucu da bırakılmıyor; bu blok
            // sessizce atlanır (chunk hiç eklenmez).
            break;
          case 'drawing':
            final strokes = (b['strokes'] as List? ?? const []);
            chunks.add(
              strokes.isNotEmpty
                  ? [l10n.noteWidgetPreviewDrawingLabel]
                  : const [],
            );
            break;
        }
      }
    }

    final nonEmptyChunks = chunks.where((c) => c.isNotEmpty).toList();
    final assembled = <String>[];
    for (var i = 0; i < nonEmptyChunks.length; i++) {
      if (i > 0) assembled.add('');
      assembled.addAll(nonEmptyChunks[i]);
    }

    var text = assembled.join('\n');
    const maxLen = 200;
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
  /// Widget artık gerçek bir kaydırılabilir liste (ListView) olduğundan
  /// [maxLines], "ekrana kaç satır sığar" için DEĞİL, sadece SharedPreferences'a
  /// yazılan JSON'un makul boyutta kalması için bir üst sınır. Native tarafın
  /// gerçekten kaç satır ÇİZECEĞİ NoteWidgetRemoteViewsService.kt ->
  /// maxRenderLines ile ayrıca sınırlanıyor — buradaki değer o sabitin
  /// ALTINDA kalırsa kullanıcı kaydırırken içeriğin geri kalanını hiç
  /// görmeden "…" ile karşılaşır (bkz. DÜZELTME: bu, "kaydırırken yarıda
  /// kesiliyor" şikayetinin sebebiydi). Bu yüzden bu değer o sabitle (40)
  /// eşit tutulmalı; biri değişirse diğeri de güncellenmeli.
  List<Map<String, dynamic>> _buildStructuredLines(
    Map<String, dynamic> note, {
    int maxLines = 40,
  }) {
    // DÜZELTME: Önceki sürüm tüm blokların satırlarını TEK bir listeye
    // ekliyordu; bu yüzden boşluk sadece bir metin bloğunun KENDİ İÇİNDEKİ
    // boş satırlarında görünüyordu — farklı bloklar (örn. bir yazı
    // paragrafının hemen ardından gelen bir hesap tablosu) arasına hiç
    // ayraç eklenmiyordu, bloklar birbirine yapışık görünüyordu. Şimdi her
    // blok kendi "parça"sını (chunk) üretiyor; boş parçalar (örn. hiç
    // satırı olmayan attachments/drawing'siz drawing bloğu) elenip, geri
    // kalan parçalar arasına -in-app görünümdeki blok boşluğunu yansıtacak
    // şekilde- boş bir satır ekleniyor. `maxLines` sınırı, ayraçlar dahil
    // TÜM parçalar birleştirildikten SONRA uygulanıyor; aksi halde
    // ayraçlar bütçeyi haksız yere tüketebilirdi.

    // Blok/madde metnine göre (rawStart/rawEnd karakter aralığına göre)
    // saklanmış span listesinden, sadece [rawStart, rawEnd) ile kesişen
    // parçaları alıp bunları [rawStart, rawEnd) aralığının 0-index'ine
    // göre yeniden konumlandırarak döner. Kesişim yoksa boş liste döner.
    // Hem textChunk (satır bazlı) hem checklistChunk (trim bazlı) aynı
    // kaydırma mantığına ihtiyaç duyduğu için ortak tutuldu.
    List<Map<String, dynamic>> spansForLine(
      List<Map<String, dynamic>> spans,
      int rawStart,
      int rawEnd,
    ) {
      final result = <Map<String, dynamic>>[];
      for (final s in spans) {
        final sStart = (s['start'] as int).clamp(rawStart, rawEnd);
        final sEnd = (s['end'] as int).clamp(rawStart, rawEnd);
        if (sEnd <= sStart) continue; // bu aralıkla kesişmiyor
        result.add({
          ...s,
          'start': sStart - rawStart,
          'end': sEnd - rawStart,
        });
      }
      return result;
    }

    List<Map<String, dynamic>> checklistChunk(List items) {
      final chunk = <Map<String, dynamic>>[];
      for (final it in items) {
        final m = it as Map;
        final rawText = (m['text'] ?? '').toString();
        final t = rawText.trim();
        if (t.isEmpty) continue;
        // DÜZELTME: madde metni trim edilirken (baştaki/sondaki boşluk
        // atılırken) span'ların start/end'i de aynı miktarda kaydırılmalı
        // — aksi halde trim sonrası metinle span aralıkları kayar ve
        // native taraf yanlış karakterleri kalın/italik gösterir (ya da
        // hiç göstermez, çünkü aralık artık metin uzunluğunu aşar).
        final leading = rawText.length - rawText.trimLeft().length;
        final lineSpans = spansForLine(
          RichTextSpans.parse(m['spans']),
          leading,
          leading + t.length,
        );
        chunk.add({
          'type': 'checkbox',
          'text': t,
          'checked': m['checked'] == true,
          if (lineSpans.isNotEmpty) 'spans': lineSpans,
        });
      }
      return chunk;
    }

    List<Map<String, dynamic>> calcTableChunk(List rows) {
      final chunk = <Map<String, dynamic>>[];
      double total = 0;
      var any = false;
      for (final r in rows) {
        final row = r as Map;
        final label = (row['label'] ?? '').toString();
        final valueText = (row['value'] ?? '').toString();
        total += ContentBlocks.parseCalcValue(row['value']);
        if (label.trim().isNotEmpty || valueText.trim().isNotEmpty) {
          any = true;
          chunk.add({
            'type': 'table_row',
            'label': label,
            'value': valueText,
          });
        }
      }
      if (any) {
        chunk.add({
          'type': 'table_total',
          'value': ContentBlocks.formatCalcNumber(total),
        });
      }
      return chunk;
    }

    // "table" bloğu için native tarafta özel bir composable yok (bkz.
    // _buildPreview'daki addTableRows üzerindeki açıklama) — bu yüzden
    // her satır, native widget'ın zaten bildiği düz 'text' satırı olarak
    // eklenir; hücreler " | " ile ayrılır.
    //
    // DÜZELTME (tablo hücrelerindeki zengin metin widget'ta görünmüyordu):
    // her hücrenin kendi 'spans'ı (bkz. content_blocks.dart ->
    // _tableCellSpans) hücrenin KENDİ metnine göre indexlenmiş durumda.
    // Hücreler " | " ile TEK bir satıra birleştirildiğinde, her hücrenin
    // span'ları o hücrenin birleşik satırdaki başlangıç offset'i kadar
    // kaydırılmadan doğrudan eklenirse yanlış karakterleri işaretler
    // (ya da hiç eşleşmez). Bu yüzden her hücre için offset takip edilip
    // span'lar buna göre kaydırılıyor.
    List<Map<String, dynamic>> tableChunk(List rows) {
      final chunk = <Map<String, dynamic>>[];
      const separator = ' | ';
      for (final r in rows) {
        final cells = r as List;
        final cellTexts =
            cells.map((c) => ContentBlocks._tableCellText(c)).toList();

        // DÜZELTME (boş hücre "düz çizgi" gibi görünüyordu): boş hücreler
        // satıra hiç dahil edilmiyor (ne metin ne ayraç). Önceden TÜM
        // hücreler (boş olsa dahi) " | " ile birleştiriliyor, satır sadece
        // TÜMÜ boşsa atlanıyordu; bu yüzden bir sütun hep boş bırakılmışsa
        // her satırda dolu hücrenin yanında art arda boşluklu "|"
        // karakterleri kalıyor, widget'ta alt alta sıralanınca sadece
        // çizgilermiş gibi görünüyordu. Span offset hesabı da artık
        // sadece DAHİL EDİLEN hücrelere göre yapılıyor.
        final nonEmptyIndices = <int>[
          for (var i = 0; i < cellTexts.length; i++)
            if (cellTexts[i].trim().isNotEmpty) i,
        ];
        if (nonEmptyIndices.isEmpty) continue;

        final line = nonEmptyIndices.map((i) => cellTexts[i]).join(separator);

        final lineSpans = <Map<String, dynamic>>[];
        var cellOffset = 0;
        for (var idx = 0; idx < nonEmptyIndices.length; idx++) {
          final i = nonEmptyIndices[idx];
          final cellText = cellTexts[i];
          final cellSpans = RichTextSpans.parse(
            ContentBlocks._tableCellSpans(cells[i]),
          );
          lineSpans.addAll(
            spansForLine(cellSpans, 0, cellText.length).map((s) => {
                  ...s,
                  'start': (s['start'] as int) + cellOffset,
                  'end': (s['end'] as int) + cellOffset,
                }),
          );
          cellOffset += cellText.length;
          if (idx < nonEmptyIndices.length - 1) cellOffset += separator.length;
        }

        chunk.add({
          'type': 'text',
          'text': line,
          if (lineSpans.isNotEmpty) 'spans': lineSpans,
        });
      }
      return chunk;
    }

    List<Map<String, dynamic>> textChunk(String raw, List? rawSpans) {
      final spans = RichTextSpans.parse(rawSpans);
      final rawLines = raw.split('\n');
      // Bloğun sadece en baş/sonundaki boş satırlar kırpılır; arada kalan
      // boş satırlar (kullanıcının bıraktığı paragraf boşlukları) korunur.
      var start = 0;
      var end = rawLines.length;
      while (start < end && rawLines[start].trim().isEmpty) {
        start++;
      }
      while (end > start && rawLines[end - 1].trim().isEmpty) {
        end--;
      }

      // DÜZELTME (zengin metin widget'ta görünmüyordu): span'lar TÜM blok
      // metnine göre (karakter index'i olarak) saklanır, ama burada metin
      // '\n' ile satırlara bölünüp her satır ayrıca trim ediliyor. Bu
      // yüzden her satırın blok içindeki [trimStart, trimEnd) aralığını
      // hesaplayıp, o aralığa denk düşen span parçalarını satır-yerel
      // (satırın kendi 0-index'ine göre) koordinatlara kaydırmamız
      // gerekiyor — aksi halde native taraf hangi satırın hangi
      // biçimlendirmeyi taşıdığını hiç bilemez.
      final lineOffsets = <int>[];
      var offset = 0;
      for (final l in rawLines) {
        lineOffsets.add(offset);
        offset += l.length + 1; // +1 => aradaki '\n'
      }

      final result = <Map<String, dynamic>>[];
      for (var i = start; i < end; i++) {
        final line = rawLines[i];
        final trimmed = line.trim();
        final leading = line.length - line.trimLeft().length;
        final trimStart = lineOffsets[i] + leading;
        final trimEnd = trimStart + trimmed.length;
        final lineSpans = spansForLine(spans, trimStart, trimEnd);
        result.add({
          'type': 'text',
          'text': trimmed,
          if (lineSpans.isNotEmpty) 'spans': lineSpans,
        });
      }
      return result;
    }

    final chunks = <List<Map<String, dynamic>>>[];

    if (note['type']?.toString() == 'checklist') {
      chunks.add(checklistChunk(note['checkItems'] as List? ?? const []));
    } else {
      final blocks = ContentBlocks.parse(note['content']?.toString());
      for (final b in blocks) {
        switch (b['type']) {
          case 'text':
            chunks.add(
              textChunk((b['text'] ?? '').toString(), b['spans'] as List?),
            );
            break;
          case 'checklist':
            chunks.add(checklistChunk(b['items'] as List? ?? const []));
            break;
          case 'calc_table':
            chunks.add(calcTableChunk(b['rows'] as List? ?? const []));
            break;
          case 'table':
            chunks.add(tableChunk(b['rows'] as List? ?? const []));
            break;
          case 'attachments':
            // İstek üzerine widget'ta fotoğraf gösterilmiyor VE fotoğraf
            // olduğuna dair bir metin ipucu da bırakılmıyor; bu blok
            // sessizce atlanır (chunk hiç eklenmez).
            break;
          case 'drawing':
            final strokes = (b['strokes'] as List? ?? const []);
            chunks.add(
              strokes.isNotEmpty
                  ? [
                      {'type': 'drawing'}
                    ]
                  : const [],
            );
            break;
        }
      }
    }

    // Boş parçaları at (ör. çizim bloğu ama hiç çizgi yoksa), kalanları
    // aralarına boş bir 'text' satırı koyarak birleştir.
    final nonEmptyChunks = chunks.where((c) => c.isNotEmpty).toList();
    final assembled = <Map<String, dynamic>>[];
    for (var i = 0; i < nonEmptyChunks.length; i++) {
      if (i > 0) assembled.add({'type': 'text', 'text': ''});
      assembled.addAll(nonEmptyChunks[i]);
    }

    final truncated = assembled.length > maxLines;
    final lines = assembled.take(maxLines).toList();
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
