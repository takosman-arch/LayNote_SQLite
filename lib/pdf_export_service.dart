part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// PDF DIŞA AKTARMA (PdfExportService)
// Not düzenleyicideki üç nokta menüsünden çağrılır. Notun başlığını,
// bloklarını (metin / kontrol listesi / hesap tablosu / ekler) tek bir
// PDF dosyasına dönüştürüp cihazın geçici (temp) klasörüne yazar; çağıran
// taraf bu dosyayı share_plus ile paylaşım sayfasına gönderir.
//
// Türkçe karakterler (ı, ğ, ş, ç, ö, ü, İ) standart PDF fontlarında (Helvetica)
// düzgün görünmediği için pubspec.yaml'da tanımlı "NotoSansTr" TTF fontu
// gömülü olarak kullanılır (bkz. assets/fonts/NotoSans-Regular.ttf/Bold.ttf).
// ════════════════════════════════════════════════════════════════════════
class PdfExportService {
  static pw.Font? _regularFont;
  static pw.Font? _boldFont;

  // ── AŞAMA 1: Yazı stili → TTF asset eşleme tablosu ─────────────────────
  // Ayarlar > Kişiselleştirme > Yazı Tipi'nde seçilen değer, önce
  // settings_page.dart'taki dNoteFontFamilyValue() ile Flutter'ın
  // TextStyle.fontFamily alanının anladığı isme çevrilir (null / 'DNoteMono'
  // / 'DNoteSerif' / 'DNoteCursive') — çağrı zincirinde PDF/JPG servislerine
  // de AYNI çevrilmiş değer akar (bkz. note_list_note_dialog_mixin.dart'taki
  // dNoteFontFamilyValue(_fontFamily) çağrısı). Bu tablo, o değeri
  // pubspec.yaml'da tanımlı gerçek TTF dosya yollarına eşler; 'pdf' paketi
  // Flutter'ın font motorunu kullanmadığından, her aile için regular/bold
  // TTF'i kendimiz rootBundle üzerinden yüklememiz gerekir (bkz. AŞAMA 2:
  // _ensureFonts). null / eşleşmeyen değer → varsayılan (NotoSansTr) kullanılır.
  static const Map<String, ({String regular, String bold})> _fontAssetMap = {
    'DNoteMono': (
      regular: 'assets/fonts/JetBrainsMono-Regular.ttf',
      bold: 'assets/fonts/JetBrainsMono-Bold.ttf',
    ),
    'DNoteSerif': (
      regular: 'assets/fonts/Merriweather_96pt-Regular.ttf',
      bold: 'assets/fonts/Merriweather_96pt-Bold.ttf',
    ),
    'DNoteCursive': (
      regular: 'assets/fonts/DancingScript-Regular.ttf',
      bold: 'assets/fonts/DancingScript-Bold.ttf',
    ),
  };

  // Varsayılan (Türkçe karakter destekli) font — fontFamily null/eşleşmeyen
  // bir değer olduğunda fallback olarak kullanılır.
  static const ({String regular, String bold}) _defaultFontAsset = (
    regular: 'assets/fonts/NotoSans-Regular.ttf',
    bold: 'assets/fonts/NotoSans-Bold.ttf',
  );

  // ── Zengin metin (rich text) renkleri ──────────────────────────────────
  // PDF sayfası her zaman beyaz zemin olduğundan, kullanıcının telefonunda
  // hangi tema (açık/koyu) aktif olursa olsun editördeki AÇIK TEMA vurgu
  // rengiyle birebir aynı ton kullanılır (bkz.
  // rich_block_text_controller.dart -> _highlightColorLight = 0xFFFFF59D).
  // Koyu temanın vurgu rengi (_highlightColorDark) burada KASITLI olarak
  // kullanılmaz — beyaz kağıt üzerinde o ton okunaksız/çok koyu kalırdı.
  // NOT: bu sabit, rich_block_text_controller.dart içindeki
  // _highlightColorLight ile birbirinden BAĞIMSIZ tutulur; biri
  // değiştirilirse diğeri de elle güncellenmelidir.
  static final PdfColor _highlightColorPdf = PdfColor.fromInt(0xFFFFF59D);
  // Link olarak işaretlenmiş metnin rengi; rich_block_text_controller.dart
  // içindeki _linkColor (0xFF1A73E8) ile aynı.
  static final PdfColor _linkColorPdf = PdfColor.fromInt(0xFF1A73E8);

  // Uzun bir paragrafı, yaklaşık `maxChars` karakteri geçmeyecek şekilde
  // (kelime ortasından KIRMADAN) parçalara böler. pw.Text'in bu pakette
  // sayfalar arası kendi kendine bölünmesi güvenilir çalışmadığı için,
  // her parça tek başına bir sayfaya sığacak kadar kısa tutulup ayrı bir
  // widget olarak eklenir (bkz. exportNoteToPdf içindeki kullanım).
  // Sadece geriye dönük uyumluluk içindir: formattedDateTime verilmeden
  // çağrılan (güncellenmemiş) eski çağrı yerleri için, önceki sabit
  // "gg.aa.yyyy sa:dk" davranışını (eski main.dart:_formatDateTimeTr)
  // birebir korur. Bu servis context almadığından burada dile göre bir
  // çözünürlük YAPILAMAZ — asıl düzeltme, çağıran tarafın
  // dNoteFormatNumericDateParts ile üretip formattedDateTime'ı geçmesidir
  // (bkz. note_list_actions_mixin.dart).
  static String _legacyFixedDateTimeFallback(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}.${two(dt.month)}.${dt.year} ${two(dt.hour)}:${two(dt.minute)}';
  }

  static List<String> _chunkPlainText(String text, int maxChars) {
    if (text.length <= maxChars) return [text];
    final words = text.split(RegExp(r'(?<=\s)'));
    final chunks = <String>[];
    final buffer = StringBuffer();
    for (final word in words) {
      if (buffer.length + word.length > maxChars && buffer.isNotEmpty) {
        chunks.add(buffer.toString());
        buffer.clear();
      }
      buffer.write(word);
    }
    if (buffer.isNotEmpty) chunks.add(buffer.toString());
    return chunks;
  }

  // _chunkPlainText ile AYNI amaç (bir sayfaya sığacak kadar kısa, kelime
  // ortasından kırılmayan parçalara bölme) ama bu sefer span'ları (kalın/
  // italik/altı çizili/üstü çizili/vurgu/özel renk-boyut/link) da parçayla
  // BİRLİKTE, parçaya göre yeniden hizalanmış (yerel/0 tabanlı) indekslerle
  // taşır. Böylece uzun bir metin bloğu birden fazla widget'a bölünse bile
  // (pw.MultiPage kendi kendine bölünemediği için — bkz. _chunkPlainText
  // yorumu) biçimlendirme parça sınırlarında kaybolmaz.
  static List<({String text, List<Map<String, dynamic>> spans})>
      _chunkRichText(
    String text,
    List<Map<String, dynamic>> spans,
    int maxChars,
  ) {
    if (text.isEmpty) return const [];
    if (text.length <= maxChars) {
      return [(text: text, spans: spans)];
    }
    final words = text.split(RegExp(r'(?<=\s)'));
    final chunks = <({String text, List<Map<String, dynamic>> spans})>[];
    final buffer = StringBuffer();
    var chunkStart = 0;

    void flush() {
      if (buffer.isEmpty) return;
      final chunkText = buffer.toString();
      final chunkEnd = chunkStart + chunkText.length;
      final localSpans = <Map<String, dynamic>>[];
      for (final s in spans) {
        final sStart = s['start'] as int;
        final sEnd = s['end'] as int;
        final clampedStart = math.max(sStart, chunkStart);
        final clampedEnd = math.min(sEnd, chunkEnd);
        if (clampedEnd <= clampedStart) continue;
        localSpans.add({
          ...s,
          'start': clampedStart - chunkStart,
          'end': clampedEnd - chunkStart,
        });
      }
      chunks.add((text: chunkText, spans: localSpans));
      chunkStart = chunkEnd;
      buffer.clear();
    }

    for (final word in words) {
      if (buffer.length + word.length > maxChars && buffer.isNotEmpty) {
        flush();
      }
      buffer.write(word);
    }
    flush();
    return chunks;
  }

  // Bir metin parçasını ve o parçaya ait (parçaya göre yeniden hizalanmış)
  // span listesini, RichBlockTextController.buildTextSpan (bkz.
  // rich_block_text_controller.dart) ile AYNI algoritmayla — kırılma
  // noktaları çıkarıp her aralıkta o an etkin olan özellikleri toplayarak —
  // bir pw.RichText'e dönüştürür. Hiç span yoksa (düz metin) gereksiz
  // sarmalamadan kaçınmak için basit bir pw.Text döner.
  // [baseFont]: span'da 'bold' işaretlenmemiş kısımlarda kullanılacak font.
  // Gövde metni için varsayılan (regular) yeterlidir; başlık için ise
  // taban zaten her zaman kalın olduğundan (bkz. exportNoteToPdf'teki
  // başlık çağrısı) buraya `bold` verilir — böylece başlığın span'la
  // biçimlendirilmemiş kısımları da eskisi gibi kalın kalır, sadece
  // italik/altı çizili/vurgu/renk/link gibi span'a özgü stiller ek olarak
  // uygulanabilir hale gelir.
  static pw.Widget _buildRichTextWidget(
    String text,
    List<Map<String, dynamic>> spans,
    pw.Font regular,
    pw.Font bold,
    double fontSize, {
    pw.Font? baseFont,
  }) {
    final defaultFont = baseFont ?? regular;
    if (spans.isEmpty || text.isEmpty) {
      return pw.Text(
        text,
        style: pw.TextStyle(font: defaultFont, fontSize: fontSize),
      );
    }

    int clampIndex(num raw, int max) {
      final v = raw.toInt();
      if (v < 0) return 0;
      if (v > max) return max;
      return v;
    }

    final breakpoints = <int>{0, text.length};
    for (final s in spans) {
      breakpoints.add(clampIndex(s['start'] as num, text.length));
      breakpoints.add(clampIndex(s['end'] as num, text.length));
    }
    final points = breakpoints.toList()..sort();

    final children = <pw.TextSpan>[];
    for (var i = 0; i < points.length - 1; i++) {
      final start = points[i];
      final end = points[i + 1];
      if (start >= end) continue;

      var isBold = false;
      var italic = false;
      var underline = false;
      var strikethrough = false;
      var highlight = false;
      double? customSize;
      int? colorValue;
      String? link;
      for (final s in spans) {
        final sStart = clampIndex(s['start'] as num, text.length);
        final sEnd = clampIndex(s['end'] as num, text.length);
        if (start >= sStart && end <= sEnd) {
          if (s['bold'] == true) isBold = true;
          if (s['italic'] == true) italic = true;
          if (s['underline'] == true) underline = true;
          if (s['strikethrough'] == true) strikethrough = true;
          if (s['highlight'] == true) highlight = true;
          final sz = s['fontSize'];
          if (sz is num) customSize = sz.toDouble();
          final c = s['color'];
          if (c is num) colorValue = c.toInt();
          final lk = s['link'];
          if (lk is String && lk.isNotEmpty) link = lk;
        }
      }

      // Link'ler editördeki gibi her zaman altı çizili gösterilir; ayrıca
      // 'underline' span verisine yazılmaz (bkz.
      // rich_block_text_controller.dart'taki aynı kural).
      final showUnderline = underline || link != null;
      pw.TextDecoration? decoration;
      if (showUnderline || strikethrough) {
        decoration = pw.TextDecoration.combine([
          if (showUnderline) pw.TextDecoration.underline,
          if (strikethrough) pw.TextDecoration.lineThrough,
        ]);
      }
      // Kullanıcı bu aralığa özel bir renk atamadıysa (colorValue == null)
      // link mavisi kullanılır; özel renk atanmışsa kullanıcının seçimine
      // saygı gösterilir (editördeki mantıkla birebir aynı).
      final effectiveColor = colorValue != null
          ? PdfColor.fromInt(colorValue)
          : (link != null ? _linkColorPdf : PdfColors.black);

      children.add(
        pw.TextSpan(
          text: text.substring(start, end),
          style: pw.TextStyle(
            // Not: yalnızca Regular/Bold TTF gömülü olduğundan "kalın",
            // fontWeight yerine doğrudan bold TTF'ye geçilerek uygulanır
            // (dosyanın geri kalanındaki mevcut desenle aynı).
            font: isBold ? bold : defaultFont,
            fontSize: customSize ?? fontSize,
            fontStyle: italic ? pw.FontStyle.italic : pw.FontStyle.normal,
            decoration: decoration,
            color: effectiveColor,
            // Vurgu: metnin kendi rengine dokunmadan arkasına sabit bir
            // bant ekler (bkz. sınıf başındaki _highlightColorPdf notu).
            background:
                highlight ? pw.BoxDecoration(color: _highlightColorPdf) : null,
          ),
        ),
      );
    }

    return pw.RichText(text: pw.TextSpan(children: children));
  }

  // ── AŞAMA 2: Çoklu font desteği ────────────────────────────────────────
  // Eskiden tek statik çift (_regularFont/_boldFont) her zaman NotoSans'a
  // sabitliydi. Artık asset yoluna göre anahtarlanan bir cache tutuyoruz
  // (_fontCache), böylece uygulamanın 4 yazı stili seçeneğinin (Varsayılan/
  // Monospace/Serif/Cursive) her biri kendi TTF'ini yükleyip önbelleğe
  // alabiliyor — aynı font aynı export/oturum içinde tekrar tekrar diskten
  // okunmuyor.
  static final Map<String, pw.Font> _fontCache = {};

  static Future<pw.Font> _loadCachedFont(String assetPath) async {
    final cached = _fontCache[assetPath];
    if (cached != null) return cached;
    final data = await rootBundle.load(assetPath);
    final font = pw.Font.ttf(data);
    _fontCache[assetPath] = font;
    return font;
  }

  // [fontFamily]: dNoteFontFamilyValue() çıktısı (null / 'DNoteMono' /
  // 'DNoteSerif' / 'DNoteCursive'). _fontAssetMap'te karşılığı yoksa (null
  // dahil) _defaultFontAsset (NotoSansTr) kullanılır. DNoteMono/Serif/
  // Cursive'in Bold TTF'i de artık pubspec.yaml'a eklendiği için burada
  // gerçek bir bold font yükleniyor (eskiden bu üçünde bold TTF yoktu).
  static Future<({pw.Font regular, pw.Font bold})> _ensureFonts([
    String? fontFamily,
  ]) async {
    final asset = _fontAssetMap[fontFamily] ?? _defaultFontAsset;
    final regular = await _loadCachedFont(asset.regular);
    final bold = await _loadCachedFont(asset.bold);
    // Geriye dönük uyumluluk: eski _regularFont/_boldFont alanlarını hâlâ
    // okuyan bir kod kalmışsa (AŞAMA 3 tamamlanana kadar exportNoteToPdf
    // bunu yapıyor) en son yüklenen fontu bu alanlara da yazıyoruz.
    _regularFont = regular;
    _boldFont = bold;
    return (regular: regular, bold: bold);
  }

  // Kameradan gelen fotoğraflar genelde çok yüksek çözünürlüktedir (ör.
  // 4000x3000 px, birkaç MB). Bu ham veri doğrudan pw.MemoryImage'a
  // verilirse, "pdf" paketinin resim kod çözücüsü (saf Dart, yavaş) çok
  // uzun sürebiliyor ya da cihazda bellek yetersizliğinden PDF oluşturma
  // tamamen başarısız oluyor — resimli notlarda dışa aktarmanın
  // çalışmamasının sebebi budur. Bunu önlemek için resmi PDF'e gömülmeden
  // önce Flutter'ın kendi (yerel, hızlı) kod çözücüsüyle makul bir
  // boyuta küçültüyoruz. allowUpscaling: false ile zaten küçük olan
  // resimlerin gereksiz yere büyütülmesi engellenir.
  static Future<Uint8List> _downscaleForPdf(
    Uint8List bytes, {
    int maxDimension = 1600,
  }) async {
    ui.Codec? codec;
    ui.FrameInfo? frame;
    try {
      codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: maxDimension,
        allowUpscaling: false,
      );
      frame = await codec.getNextFrame();
      final byteData = await frame.image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) return bytes;
      return byteData.buffer.asUint8List();
    } catch (e, st) {
      // Küçültme başarısız olursa (ör. desteklenmeyen format) orijinal
      // veriyle devam edilir; en kötü ihtimalle eski (yavaş) davranışa
      // düşülür ama PDF tamamen başarısız olmaz.
      debugPrint('[PDF] downscale hata: $e\n$st');
      return bytes;
    } finally {
      frame?.image.dispose();
      codec?.dispose();
    }
  }

  // Not düzenleyicideki _buildAttachmentGrid ile aynı düzeni PDF'e taşır:
  // tek fotoğraf sayfa genişliğinde, sabit (kırpılmış) bir yükseklikte;
  // birden fazla fotoğraf ise 2'li, kare, kırpılmış bir ızgara olarak
  // dizilir. Böylece dışa aktarılan PDF, kullanıcının editörde gördüğü
  // önizlemeyle birebir aynı görünür (tam boy/orantılı görsel yerine).
  static pw.Widget _buildAttachmentGrid(
    List<String> ids,
    Map<String, Map<String, dynamic>> attachmentsById,
    Map<String, pw.MemoryImage> imageCache,
    pw.Font regular,
    double placeholderFontSize,
    String defaultAttachmentName,
  ) {
    const spacing = 6.0;
    final pageContentWidth = PdfPageFormat.a4.width - (32 * 2);

    pw.Widget docPlaceholder(Map<String, dynamic> att, double size) {
      final name = (att['fileName'] ?? defaultAttachmentName).toString();
      return pw.Container(
        width: size,
        height: size,
        alignment: pw.Alignment.center,
        padding: const pw.EdgeInsets.all(6),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
        ),
        child: pw.Text(
          '📎 $name',
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(font: regular, fontSize: placeholderFontSize, color: PdfColors.grey700),
        ),
      );
    }

    if (ids.length == 1) {
      final id = ids.first;
      final att = attachmentsById[id]!;
      final img = imageCache[id];
      // Uygulamadaki liste kartı önizlemeleriyle aynı 16:9 oranı (bkz.
      // _kGridPreviewAspectRatio); düzenleyicideki sabit 220 yükseklik,
      // ekran genişliği ile PDF sayfa genişliği çok farklı olduğu için
      // burada aynı görsel oranı vermiyordu.
      final singleImageHeight = pageContentWidth * 9 / 16;
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 8),
        child: img != null
            ? pw.Container(
                width: pageContentWidth,
                height: singleImageHeight,
                child: pw.Image(img, fit: pw.BoxFit.cover),
              )
            : docPlaceholder(att, pageContentWidth),
      );
    }

    final itemWidth = (pageContentWidth - spacing) / 2;
    final tiles = <pw.Widget>[];
    for (final id in ids) {
      final att = attachmentsById[id]!;
      final img = imageCache[id];
      tiles.add(
        img != null
            ? pw.Container(
                width: itemWidth,
                height: itemWidth,
                child: pw.Image(img, fit: pw.BoxFit.cover),
              )
            : docPlaceholder(att, itemWidth),
      );
    }
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Wrap(spacing: spacing, runSpacing: spacing, children: tiles),
    );
  }

  // Notu PDF'e dönüştürüp geçici klasöre yazar ve oluşan dosyayı döndürür.
  //
  // [fontSize]: notun düzenleyicideki metin boyutu (not kendi fontSize'ını
  // taşıyorsa o, taşımıyorsa _globalFontSize). Düzenleyicideki davranışla
  // birebir eşleşmesi için gövde metni, kontrol listesi maddeleri ve hesap
  // tablosu satırlarının (etiket + değer) HEPSİ bu değeri (ölçeklenmiş
  // haliyle, bkz. effectiveFontSize) doğrudan kullanır — düzenleyicide de
  // bu üçü arasında oranlama/küçültme yapılmıyor. Başlık ve tarih de
  // düzenleyicideki gibi sabit oranlarda (20pt / 9pt) kalır, ama PDF sayfa
  // genişliği ile telefon ekranı arasındaki farka göre aynı `scale`
  // faktörüyle büyütülür.
  static Future<File> exportNoteToPdf({
    required String title,
    // Not başlığındaki kalın/italik/altı çizili/üstü çizili/vurgu/özel
    // renk-link span'ları (bkz. rich_text_spans.dart). Verilmezse (null/boş)
    // başlık eskisi gibi tamamen düz kalın metin olarak basılır.
    List<dynamic>? titleSpans,
    required String noteType,
    required List<Map<String, dynamic>> blocks,
    required List<Map<String, dynamic>> checkItems,
    required List<Map<String, dynamic>> attachments,
    double fontSize = 16.0,
    // AŞAMA 3: dNoteFontFamilyValue() çıktısı (null / 'DNoteMono' /
    // 'DNoteSerif' / 'DNoteCursive') — _ensureFonts'a iletilip AŞAMA 1'deki
    // _fontAssetMap üzerinden doğru regular/bold TTF çiftinin seçilmesini
    // sağlar. JPG dışa aktarmadaki aynı parametreyle (NoteScreenshotService)
    // birebir aynı anlam ve akışa sahiptir.
    String? fontFamily,
    // Not düzenleyicideki gerçek telefon ekranı genişliği (dp). PDF sayfası
    // (A4) telefon ekranından çok daha geniş olduğundan, aynı sayısal
    // fontSize değeri PDF'te satır başına çok daha fazla kelime sığdırır
    // ve editördekinden farklı (ve görsel olarak küçük) görünür. Bu yüzden
    // fontSize'ı, PDF sayfa genişliği / telefon ekranı genişliği oranına
    // göre büyütüyoruz — böylece satır başına düşen kelime sayısı (ve
    // algılanan yazı boyutu) editördekiyle aynı kalır. Değer verilmezse
    // (ör. eski çağrılar), yaygın bir telefon genişliği varsayılır.
    double? phoneScreenWidth,
    // Lokalize edilmiş yedek metinler — çağıran taraf (BuildContext'e
    // erişimi olan yer) AppLocalizations üzerinden geçer. Bu servis static
    // olduğu ve context almadığı için varsayılan olarak Türkçe değerler
    // kullanılır (bkz. app_tr.arb: pdfExportUntitledNoteLabel,
    // pdfExportDefaultAttachmentName).
    String untitledNoteLabel = 'Başlıksız Not',
    String defaultAttachmentName = 'Ek dosya',
    // Dışa aktarılan PDF'in üstündeki tarih/saat damgası. Aynı yukarıdaki
    // untitledNoteLabel/defaultAttachmentName paterni: çağıran taraf
    // (BuildContext'e erişimi olan yer) theme.dart'taki merkezi
    // dNoteFormatNumericDateParts ile dile göre doğru sıra + ayraçla
    // üretip geçirir (bkz. Aşama 3.4). Bu servis static olduğu ve context
    // almadığı için, değer verilmezse (ör. eski çağrılar) önceki sabit
    // "gg.aa.yyyy sa:dk" davranışı (eski _formatDateTimeTr, main.dart)
    // korunur — böylece geriye dönük uyumluluk bozulmaz.
    String? formattedDateTime,
  }) async {
    final fonts = await _ensureFonts(fontFamily);
    final regular = fonts.regular;
    final bold = fonts.bold;
    final resolvedDateTime = formattedDateTime ?? _legacyFixedDateTimeFallback(DateTime.now());

    // Not editöründeki içerik genişliği: ekran genişliği eksi 20+20 padding
    // (bkz. note_list_screen.dart SingleChildScrollView padding: EdgeInsets.all(20)).
    final phoneContentWidth = (phoneScreenWidth ?? 400.0) - 40.0;
    // PDF içerik genişliği: A4 genişliği eksi 32+32 margin (aşağıdaki
    // pw.MultiPage margin ile aynı olmalı).
    final pdfContentWidth = PdfPageFormat.a4.width - 64.0;
    // Editördeki kelime/satır oranını korumak için fontSize'ı bu oranla
    // büyütüyoruz; başlık ve diğer sabit boyutlu metinler de aynı oranla
    // ölçekleniyor ki genel görünüm (title/body oranı) editördekiyle aynı
    // kalsın.
    final scale = pdfContentWidth / phoneContentWidth;
    final effectiveFontSize = fontSize * scale;
    final titleFontSize = 20.0 * scale;
    final dateFontSize = 9.0 * scale;
    final placeholderFontSize = 9.0 * scale;

    // Bir sayfaya (üst/alt margin düşülünce) sığabilecek en büyük yükseklik.
    // Çizim (drawing) ve uzun metin bölme mantığı bunu paylaşır.
    final maxSinglePageHeight = PdfPageFormat.a4.height - 64 - 16;
    // pw.Text'in bu pakette (pdf: 3.12.x) sayfalar arası kendi kendine
    // bölünmesi (spanning) güvenilir çalışmıyor: tek bir Text widget'ı bir
    // sayfadan uzunsa "Widget won't fit into the page..." hatasıyla TÜM
    // PDF başarısız oluyordu — kısa metinlerde sorun çıkmıyordu çünkü zaten
    // tek sayfaya sığıyorlardı. Bunu kalıcı çözmek için uzun metinleri
    // kendimiz kelime sınırlarından, kabaca bir sayfaya sığacak parçalara
    // bölüp her parçayı ayrı bir widget olarak ekliyoruz (bkz.
    // _chunkPlainText). Karakter/satır tahminleri kaba (font'un gerçek
    // glyph genişlikleri değil, fontSize'a dayalı bir yaklaşım) ama güvenlik
    // payı bırakıldığı için pratikte yeterli.
    final _approxCharWidth = effectiveFontSize * 0.5;
    final _charsPerLine = (pdfContentWidth / _approxCharWidth).floor().clamp(10, 300);
    final _lineHeight = effectiveFontSize * 1.3;
    final _maxLinesPerChunk = (maxSinglePageHeight / _lineHeight).floor().clamp(1, 2000);
    final maxCharsPerTextChunk = ((_charsPerLine * _maxLinesPerChunk) * 0.8).floor().clamp(20, 100000);

    // Not içindeki resim eklerini önceden pw.MemoryImage'a çevir (dosya
    // okuma asenkron olduğundan widget ağacı kurulmadan önce yapılmalı).
    final attachmentsDir = await DBHelper.instance.attachmentsDir();
    final Map<String, pw.MemoryImage> imageCache = {};
    for (final att in attachments) {
      if (att['isImage'] != true) continue;
      final storedName = att['storedName']?.toString();
      if (storedName == null) continue;
      final file = File(p.join(attachmentsDir.path, storedName));
      if (await file.exists()) {
        try {
          final rawBytes = await file.readAsBytes();
          final resizedBytes = await _downscaleForPdf(rawBytes);
          imageCache[att['id'].toString()] = pw.MemoryImage(resizedBytes);
        } catch (e, st) {
          // Bozuk/okunamayan resim dosyası: PDF'te atlanır.
          debugPrint('[PDF] resim hata (${att['storedName']}): $e\n$st');
        }
      }
    }
    final attachmentsById = {for (final a in attachments) a['id'].toString(): a};

    // Kontrol listesi maddesi için, uygulamadaki kare checkbox görünümüne
    // yakın, çizili bir kutucuk (işaretliyse dolu, değilse boş çerçeve).
    pw.Widget checkboxSquare(bool checked) {
      final size = effectiveFontSize * 0.85;
      return pw.Container(
        width: size,
        height: size,
        margin: const pw.EdgeInsets.only(right: 6, top: 2),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey600, width: 1),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
          color: checked ? PdfColors.grey800 : null,
        ),
      );
    }

    pw.Widget checklistRow(String text, bool checked) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 4),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            checkboxSquare(checked),
            pw.Expanded(
              child: pw.Text(
                text,
                style: pw.TextStyle(
                  font: regular,
                  fontSize: effectiveFontSize,
                  decoration: checked ? pw.TextDecoration.lineThrough : null,
                  color: checked ? PdfColors.grey600 : PdfColors.black,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Not sadece TEK bir çizim bloğundan oluşuyorsa (başka metin, kontrol
    // listesi, hesap tablosu ya da ek yoksa) başlık/tarih başlığı hiç
    // gösterilmiyor; böylece çizim sayfanın tamamını kullanabiliyor. Diğer
    // tüm not türlerinde başlık/tarih eskisi gibi gösterilmeye devam eder.
    final isDrawingOnlyNote = noteType != 'checklist' &&
        blocks.length == 1 &&
        blocks.first['type'] == 'drawing';

    final trimmedTitle = title.trim();
    final hasTitle = trimmedTitle.isNotEmpty;

    final content = <pw.Widget>[
      if (!isDrawingOnlyNote) ...[
        // Başlık boşsa "Başlıksız Not" yazmak yerine başlık satırı hiç
        // basılmıyor; tarih ve altındaki boşluk/içerik eskisi gibi kalır.
        if (hasTitle) ...[
          _buildRichTextWidget(
            trimmedTitle,
            RichTextSpans.parse(titleSpans),
            regular,
            bold,
            titleFontSize,
            baseFont: bold,
          ),
          pw.SizedBox(height: 4),
        ],
        pw.Text(
          resolvedDateTime,
          style: pw.TextStyle(font: regular, fontSize: dateFontSize, color: PdfColors.grey600),
        ),
        pw.SizedBox(height: 16),
      ],
    ];

    if (noteType == 'checklist') {
      for (final item in checkItems) {
        final text = (item['text'] ?? '').toString();
        if (text.trim().isEmpty) continue;
        content.add(checklistRow(text, item['checked'] == true));
      }
    } else {
      for (final block in blocks) {
        final type = block['type'];
        if (type == 'text') {
          final text = (block['text'] ?? '').toString();
          // DÜZELTME: eskiden bloğun tamamı boşsa (`text.trim().isEmpty`)
          // burada erken `continue` ile blok tümden atlanıyordu; bu yüzden
          // editörde sadece Enter'a basılıp bırakılan boş satırlar PDF'te
          // hiç görünmüyordu. Artık erken atlama YOK — aşağıdaki paragraf
          // döngüsü zaten boş paragrafları (`para.trim().isEmpty`) bir
          // SizedBox boşluğu olarak işliyor; tamamen boş metin de
          // split('\n') sonrası tek boş paragraf olarak aynı yoldan geçip
          // ekrandaki gibi bir boş satır bırakıyor.
          // DÜZELTME: eskiden burada sadece düz metin (block['text'])
          // basılıyor, blok'un 'spans' alanı (kalın/italik/altı çizili/
          // üstü çizili/vurgu/özel renk-boyut/link — bkz.
          // rich_text_spans.dart) HİÇ okunmuyordu; bu yüzden editörde
          // zengin biçimlendirilmiş notlar PDF'e dışa aktarıldığında
          // tamamen düz metin olarak çıkıyordu. Artık span'lar okunup
          // paragraf/satır sınırlarına göre yeniden hizalanarak
          // _buildRichTextWidget ile uygulanıyor.
          final spans = RichTextSpans.parse(block['spans']);
          final paragraphs = text.split('\n');
          var paraOffset = 0;
          for (final para in paragraphs) {
            final paraStart = paraOffset;
            final paraEnd = paraStart + para.length;
            // +1: paragraflar arasındaki '\n' karakteri için (text.split
            // bu karakteri kaldırır ama span indeksleri orijinal, '\n'
            // dahil metne göredir).
            paraOffset = paraEnd + 1;

            if (para.trim().isEmpty) {
              // DÜZELTME: eskiden bu boşluk `effectiveFontSize * 0.6`
              // yüksekliğindeydi — bu, dolu bir satırın gerçek satır
              // yüksekliğinin (yaklaşık 1.2-1.4 katı) yarısı kadardı, bu
              // yüzden boş satırlar PDF'te fark edilmeyecek kadar küçük
              // görünüyordu. Artık dolu bir metin satırının kapladığı
              // alanla aynı yükseklikte (`* 1.2`) tutuluyor ki boş satır
              // ekrandaki gibi normal bir satır boşluğu bıraksın.
              content.add(pw.SizedBox(height: effectiveFontSize * 1.2));
              continue;
            }

            // Bu paragrafla kesişen span'ları paragraf-yerel (0 tabanlı)
            // indekslere çevir.
            final paraSpans = <Map<String, dynamic>>[];
            for (final s in spans) {
              final sStart = s['start'] as int;
              final sEnd = s['end'] as int;
              final clampedStart = math.max(sStart, paraStart);
              final clampedEnd = math.min(sEnd, paraEnd);
              if (clampedEnd <= clampedStart) continue;
              paraSpans.add({
                ...s,
                'start': clampedStart - paraStart,
                'end': clampedEnd - paraStart,
              });
            }

            for (final chunk
                in _chunkRichText(para, paraSpans, maxCharsPerTextChunk)) {
              content.add(
                _buildRichTextWidget(
                  chunk.text,
                  chunk.spans,
                  regular,
                  bold,
                  effectiveFontSize,
                ),
              );
            }
          }
          // DÜZELTME: eskiden bu sabit 8pt boşluk, bloğun içeriği ne
          // olursa olsun (boş ya da dolu) HER metin bloğundan sonra
          // ekleniyordu. Bu yüzden kendi başına ayrı, tamamen boş bir
          // metin bloğu (ör. iki blok arasına bırakılan boş satır),
          // zaten aldığı `effectiveFontSize * 1.2` boşluğunun ÜSTÜNE bir
          // de bu sabit 8pt'yi alıyor, oysa AYNI boş satır bir bloğun
          // İÇİNDE (başka metnin ortasında) olsaydı sadece
          // `effectiveFontSize * 1.2` alıyordu — iki durum arasında
          // tutarsız yükseklik oluşuyordu. Artık bu fazladan boşluk
          // yalnızca blok GERÇEK (boş olmayan) metin içeriyorsa
          // ekleniyor; tamamen boş bir blok, blok içindeki bir boş
          // satırla birebir aynı yüksekliği alıyor.
          if (text.trim().isNotEmpty) {
            content.add(pw.SizedBox(height: 8));
          }
        } else if (type == 'checklist') {
          final items = List<Map>.from(block['items'] ?? const []);
          final validItems = items.where(
            (item) => (item['text'] ?? '').toString().trim().isNotEmpty,
          ).toList();
          // Not: tüm maddeler TEK bir pw.Column içine paketlenmiyor —
          // paketlenirse (uzun kontrol listelerinde) tek widget bir
          // sayfadan uzun olabiliyor ve MultiPage bunu hiçbir şekilde
          // bölemeyip "Widget won't fit into the page..." hatasıyla tüm
          // PDF'i başarısız kılıyordu (bkz. drawing bloğundaki aynı sorun).
          // Bunun yerine her madde ayrı bir üst seviye widget olarak
          // eklenir, böylece MultiPage gerektiğinde maddeler arasından
          // sayfa bölebilir.
          for (var i = 0; i < validItems.length; i++) {
            final item = validItems[i];
            final text = (item['text'] ?? '').toString();
            final isLast = i == validItems.length - 1;
            content.add(
              pw.Padding(
                padding: pw.EdgeInsets.only(bottom: isLast ? 8 : 0),
                child: checklistRow(text, item['checked'] == true),
              ),
            );
          }
        } else if (type == 'calc_table') {
          final rows = List<Map>.from(block['rows'] ?? const []);
          double total = 0;
          final tableRows = <pw.TableRow>[];
          for (final row in rows) {
            final label = (row['label'] ?? '').toString();
            final valueText = (row['value'] ?? '').toString();
            // DÜZELTME: eskiden hem 'Kalem' hem 'Tutar' alanı boş olan
            // satırlar (`continue`) tamamen atlanıyordu; bu yüzden
            // editörde görünen boş satırlar PDF'te kayboluyordu. Artık
            // hiçbir satır atlanmıyor — ekrandaki (NoteCalcTableBlock)
            // davranışıyla birebir aynı şekilde her satır, boş da olsa
            // tabloya ekleniyor.
            total += ContentBlocks.parseCalcValue(row['value']);
            // DÜZELTME: Bir önceki deneme (boş hücreye ' ' karakteri
            // vermek) yetmedi — bu PDF kütüphanesi satır yüksekliğini
            // görünür bir karaktere (glyph) göre hesaplıyor gibi
            // görünüyor, boşluk karakteri de "iz" bırakmadığı için satır
            // yine neredeyse sıfıra çöküyordu. Bu sefer metne bağlı
            // olmayan, AÇIKÇA zorlanan bir minimum yükseklik kullanıyoruz
            // (pw.Container + constraints.minHeight) — böylece hücre
            // boş da olsa dolu da olsa satır kesinlikle aynı yüksekliği
            // alıyor.
            final rowMinHeight = effectiveFontSize * 1.4 + 6; // + dikey padding (3+3)
            tableRows.add(
              pw.TableRow(
                children: [
                  pw.Container(
                    constraints: pw.BoxConstraints(minHeight: rowMinHeight),
                    padding: const pw.EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 4,
                    ),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      label,
                      style: pw.TextStyle(font: regular, fontSize: effectiveFontSize),
                    ),
                  ),
                  pw.Container(
                    constraints: pw.BoxConstraints(minHeight: rowMinHeight),
                    padding: const pw.EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 4,
                    ),
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      valueText,
                      style: pw.TextStyle(font: regular, fontSize: effectiveFontSize),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }
          if (tableRows.isNotEmpty) {
            tableRows.add(
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 4,
                    ),
                    child: pw.Text(
                      'Toplam',
                      style: pw.TextStyle(font: bold, fontSize: effectiveFontSize),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 4,
                    ),
                    child: pw.Text(
                      ContentBlocks.formatCalcNumber(total),
                      style: pw.TextStyle(font: bold, fontSize: effectiveFontSize),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
            content.add(
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColors.grey700,
                    width: 0.75,
                  ),
                  columnWidths: const {
                    0: pw.FlexColumnWidth(2),
                    1: pw.FlexColumnWidth(1),
                  },
                  children: tableRows,
                ),
              ),
            );
          }
        } else if (type == 'table') {
          // "table" (Notion tarzı basit satır/sütun tablosu) bloğu. Her
          // hücre artık zengin metin taşıyabilir ({"text","spans"}, bkz.
          // content_blocks.dart/rich_text_spans.dart); eski notlarda hücre
          // düz bir String'ti — ContentBlocks._tableCellText/_tableCellSpans
          // (aynı kütüphanenin part'ı olduğumuzdan buradan erişilebilir)
          // her iki biçimi de sorunsuz okur. calc_table'dan farkı: sabit
          // sütun sayısı ve toplam satırı YOK; sütun genişlikleri
          // pw.Table'ın varsayılanına bırakılır (columnWidths hiç
          // verilmez), her hücre kendi span'larıyla (kalın/italik/altı
          // çizili) çiziliyor.
          final rawRows = block['rows'] as List? ?? const [];
          final hasContent = rawRows.any((r) => (r as List)
              .any((c) => ContentBlocks._tableCellText(c).trim().isNotEmpty));
          if (hasContent) {
            // DÜZELTME: columnWidths verilmediğinde pw.Table varsayılan
            // olarak IntrinsicColumnWidth kullanıyor, yani her sütun kendi
            // İÇERİĞİNİN genişliğine göre boyutlanıyor (ör. "Jjeje" 5 harf
            // olduğu için sütunu, "Je" 2 harf olan sütundan çok daha geniş
            // çıkıyordu). Düzenleyicideki not_table_block.dart ise sütunları
            // EŞİT genişlikte çiziyor; PDF'in editörle aynı görünmesi için
            // burada da sütun sayısı kadar eşit FlexColumnWidth(1) veriyoruz.
            final columnCount = rawRows.fold<int>(
              0,
              (max, r) => (r as List).length > max ? (r as List).length : max,
            );
            final tableColumnWidths = <int, pw.TableColumnWidth>{
              for (var i = 0; i < columnCount; i++) i: const pw.FlexColumnWidth(1),
            };
            final tableRows = rawRows.map((r) {
              final cells = (r as List).map((c) {
                final cellText = ContentBlocks._tableCellText(c);
                final cellSpans =
                    RichTextSpans.parse(ContentBlocks._tableCellSpans(c));
                // DÜZELTME: boş hücreye ' ' karakteri vermek yetmedi —
                // bu kütüphane satır yüksekliğini görünür glyph'e göre
                // hesaplıyor gibi görünüyor. Artık calc_table'daki gibi
                // metne bağlı olmayan, açıkça zorlanan bir minimum
                // yükseklik (pw.Container + constraints.minHeight)
                // kullanılıyor.
                final rowMinHeight = effectiveFontSize * 1.4 + 6;
                return pw.Container(
                  constraints: pw.BoxConstraints(minHeight: rowMinHeight),
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 4,
                  ),
                  alignment: pw.Alignment.centerLeft,
                  child: _buildRichTextWidget(
                    cellText,
                    cellSpans,
                    regular,
                    bold,
                    effectiveFontSize,
                  ),
                );
              }).toList();
              return pw.TableRow(children: cells);
            }).toList();
            content.add(
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColors.grey700,
                    width: 0.75,
                  ),
                  columnWidths: tableColumnWidths,
                  children: tableRows,
                ),
              ),
            );
          }
        } else if (type == 'divider') {
          content.add(
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 8),
              child: pw.Divider(color: PdfColors.grey400, thickness: 0.75),
            ),
          );
        } else if (type == 'attachments') {
          final ids = List<String>.from(
            (block['ids'] as List? ?? const []).map((e) => e.toString()),
          );
          final validIds = ids.where((id) => attachmentsById[id] != null).toList();
          if (validIds.isNotEmpty) {
            content.add(
              _buildAttachmentGrid(validIds, attachmentsById, imageCache, regular, placeholderFontSize, defaultAttachmentName),
            );
          }
        } else if (type == 'drawing') {
          // "pdf" paketinin kendi çizim API'si yerine, ekranda/ekran
          // görüntüsünde kullanılan AYNI painter ile (dart:ui üzerinden
          // offscreen) üretilmiş bir PNG gömülüyor — bkz.
          // NoteDrawingRenderer (note_drawing_block.dart). Genişlik
          // editördeki gerçek tuval genişliği (phoneContentWidth) baz
          // alınarak üretiliyor, sonra diğer her şeyle aynı `scale`
          // faktörüyle PDF sayfa genişliğine büyütülüyor — bu yüzden
          // en/boy oranı bozulmadan (uzayıp basılmadan) aktarılıyor.
          final strokes = List<Map<String, dynamic>>.from(
            block['strokes'] ?? const [],
          );
          if (strokes.isNotEmpty) {
            try {
              // Tam ekranda çizilmiş, önizlemeden (220) daha uzun/geniş
              // içerik kırpılmadan aktarılsın diye gerçek kapsamına göre
              // genişlik VE yükseklik hesaplanıyor (bkz.
              // NoteDrawingRenderer.requiredCanvasHeight/Width). Genişlik
              // için minimum olarak phoneContentWidth veriliyor; tam ekran
              // (kenar boşluksuz) modda çizilmiş, bu değerden daha geniş
              // stroke'lar varsa gerçek kapsam kullanılır — aksi halde sağ
              // taraftaki çizgiler PNG'nin dışında kalıp kaybolurdu.
              final canvasWidth = NoteDrawingRenderer.requiredCanvasWidth(
                strokes,
                minWidth: phoneContentWidth,
              );
              final canvasHeight =
                  NoteDrawingRenderer.requiredCanvasHeight(strokes);
              final pngBytes = await NoteDrawingRenderer.renderStrokesToPng(
                strokes,
                width: canvasWidth,
                height: canvasHeight,
                mapWhiteToBlack: true,
              );
              if (pngBytes != null) {
                // Eskiden sayfaya sığmayan (uzun) çizimler PNG üzerinde
                // yatay şeritlere bölünüp ayrı sayfalara dağıtılıyordu; bu
                // hem çizimi ortadan ikiye bölüyor hem de son şeridin (çoğu
                // zaman neredeyse boş bir sayfaya denk gelen) bomboş bir
                // sayfa gibi görünmesine yol açıyordu. Artık HİÇBİR şekilde
                // bölünmüyor: sayfaya sığmayan çizimler, en boy oranı
                // KORUNARAK (hem genişlik hem yükseklik yönünden) tek
                // sayfaya sığacak şekilde küçültülüyor (tıpkı bir fotoğrafı
                // "sayfaya sığdır" ile küçültmek gibi).
                // ÖNEMLİ: çizim, sayfanın TAMAMINA (üst/alt margin dışındaki
                // tüm alana) göre ölçekleniyor. Ama not başlık/tarih de
                // gösteriyorsa (yani not sadece çizimden ibaret DEĞİLSE),
                // bunlar sayfanın üstünde zaten yer kaplar; bu durumda o
                // yükseklik de hesaptan düşülüyor ki çizim başlığın altına,
                // hâlâ 1. sayfaya sığsın. Not sadece çizimden ibaretse
                // (başlık/tarih hiç gösterilmiyorsa) tüm sayfa çizime ait
                // olur.
                final headerHeight = isDrawingOnlyNote
                    ? 0.0
                    : (titleFontSize * 1.3) + 4 + (dateFontSize * 1.3) + 16;
                final availableWidth = pdfContentWidth;
                final availableHeight =
                    maxSinglePageHeight - 4 - headerHeight;

                // Aynı `scale` faktörüyle büyütülmüş "doğal" (kırpılmamış,
                // orantılı) boyut. Bu, çizimin gerçek en/boy oranını
                // (canvasWidth:canvasHeight) korur.
                final naturalWidth = canvasWidth * scale;
                final naturalHeight = canvasHeight * scale;

                // Hem genişlik hem yükseklik yönünden sayfaya sığdırmak
                // için gereken ölçeği (ikisinin en küçüğünü) al; sayfadan
                // küçükse GEREKSİZ yere büyütme (yalnızca küçültme yönünde
                // ölçekle, fitScale asla 1.0'ı geçmesin).
                final fitScale = math.min(
                  math.min(
                    availableWidth / naturalWidth,
                    availableHeight / naturalHeight,
                  ),
                  1.0,
                );
                final boxWidth = naturalWidth * fitScale;
                final boxHeight = naturalHeight * fitScale;

                pw.Widget drawingBox(pw.MemoryImage image, double width, double height) {
                  // fit: contain DEĞİL fill kullanılıyor çünkü width/height
                  // zaten yukarıda aynı en/boy oranıyla hesaplandı; fill
                  // burada güvenlidir ve gereksiz iç boşluk bırakmaz.
                  return pw.Image(image, width: width, height: height, fit: pw.BoxFit.fill);
                }

                // Dış kutuya (sayfada çizime ayrılan TÜM alan) açıkça
                // genişlik/yükseklik verip alignment: center kullanmak,
                // pdf paketindeki pw.Center'ın (üst widget'ların cross-axis
                // davranışına bağlı) güvenilmez ortalamasından bağımsız
                // olarak çizimi HEM X HEM Y ekseninde garanti ortalar.
                content.add(
                  pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 4),
                    width: availableWidth,
                    height: availableHeight,
                    alignment: pw.Alignment.center,
                    child: drawingBox(pw.MemoryImage(pngBytes), boxWidth, boxHeight),
                  ),
                );
              }
            } catch (e, st) {
              // Rasterizasyon başarısız olursa çizim PDF'te atlanır; notun
              // geri kalanı yine de dışa aktarılabilsin.
              debugPrint('[PDF] çizim render hata: $e\n$st');
            }
          }
        }
      }
    }

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => content,
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final safeTitle = title.trim().isEmpty
        ? 'not'
        : title.trim().replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    final filePath = p.join(
      tempDir.path,
      '${safeTitle}_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    final file = File(filePath);
    await file.writeAsBytes(await doc.save());
    return file;
  }
}
