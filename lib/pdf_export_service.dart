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

  static Future<void> _ensureFonts() async {
    if (_regularFont != null && _boldFont != null) return;
    final regularData = await rootBundle.load(
      'assets/fonts/NotoSans-Regular.ttf',
    );
    final boldData = await rootBundle.load('assets/fonts/NotoSans-Bold.ttf');
    _regularFont = pw.Font.ttf(regularData);
    _boldFont = pw.Font.ttf(boldData);
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
  ) {
    const spacing = 6.0;
    final pageContentWidth = PdfPageFormat.a4.width - (32 * 2);

    pw.Widget docPlaceholder(Map<String, dynamic> att, double size) {
      final name = (att['fileName'] ?? 'Ek dosya').toString();
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
    required String noteType,
    required List<Map<String, dynamic>> blocks,
    required List<Map<String, dynamic>> checkItems,
    required List<Map<String, dynamic>> attachments,
    double fontSize = 16.0,
    // Not düzenleyicideki gerçek telefon ekranı genişliği (dp). PDF sayfası
    // (A4) telefon ekranından çok daha geniş olduğundan, aynı sayısal
    // fontSize değeri PDF'te satır başına çok daha fazla kelime sığdırır
    // ve editördekinden farklı (ve görsel olarak küçük) görünür. Bu yüzden
    // fontSize'ı, PDF sayfa genişliği / telefon ekranı genişliği oranına
    // göre büyütüyoruz — böylece satır başına düşen kelime sayısı (ve
    // algılanan yazı boyutu) editördekiyle aynı kalır. Değer verilmezse
    // (ör. eski çağrılar), yaygın bir telefon genişliği varsayılır.
    double? phoneScreenWidth,
  }) async {
    await _ensureFonts();
    final regular = _regularFont!;
    final bold = _boldFont!;

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

    final content = <pw.Widget>[
      pw.Text(
        title.trim().isEmpty ? 'Başlıksız Not' : title.trim(),
        style: pw.TextStyle(font: bold, fontSize: titleFontSize),
      ),
      pw.SizedBox(height: 4),
      pw.Text(
        _formatDateTimeTr(DateTime.now()),
        style: pw.TextStyle(font: regular, fontSize: dateFontSize, color: PdfColors.grey600),
      ),
      pw.SizedBox(height: 16),
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
          if (text.trim().isEmpty) continue;
          content.add(
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Text(
                text,
                style: pw.TextStyle(font: regular, fontSize: effectiveFontSize),
              ),
            ),
          );
        } else if (type == 'checklist') {
          final items = List<Map>.from(block['items'] ?? const []);
          final rows = <pw.Widget>[];
          for (final item in items) {
            final text = (item['text'] ?? '').toString();
            if (text.trim().isEmpty) continue;
            rows.add(checklistRow(text, item['checked'] == true));
          }
          if (rows.isNotEmpty) {
            content.add(
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: rows,
                ),
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
            if (label.trim().isEmpty && valueText.trim().isEmpty) continue;
            total += ContentBlocks.parseCalcValue(row['value']);
            tableRows.add(
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 4,
                    ),
                    child: pw.Text(
                      label,
                      style: pw.TextStyle(font: regular, fontSize: effectiveFontSize),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 4,
                    ),
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
                    color: PdfColors.grey400,
                    width: 0.5,
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
        } else if (type == 'attachments') {
          final ids = List<String>.from(
            (block['ids'] as List? ?? const []).map((e) => e.toString()),
          );
          final validIds = ids.where((id) => attachmentsById[id] != null).toList();
          if (validIds.isNotEmpty) {
            content.add(
              _buildAttachmentGrid(validIds, attachmentsById, imageCache, regular, placeholderFontSize),
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
              // Tam ekranda çizilmiş, önizlemeden (220) daha uzun içerik
              // kırpılmadan aktarılsın diye gerçek kapsamına göre yükseklik
              // hesaplanıyor (bkz. NoteDrawingRenderer.requiredCanvasHeight).
              final canvasHeight =
                  NoteDrawingRenderer.requiredCanvasHeight(strokes);
              final pngBytes = await NoteDrawingRenderer.renderStrokesToPng(
                strokes,
                width: phoneContentWidth,
                height: canvasHeight,
                mapWhiteToBlack: true,
              );
              if (pngBytes != null) {
                final drawingHeight = canvasHeight * scale;
                content.add(
                  pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 8),
                    width: pdfContentWidth,
                    height: drawingHeight,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
                      // Düzenleyicideki koyu tuval zemininin aksine PDF
                      // sayfası her zaman beyazdır; bu yüzden beyaz kalemle
                      // çizilen izler artık PNG'ye gömülmeden ÖNCE siyaha
                      // çevriliyor (bkz. renderStrokesToPng'deki
                      // mapWhiteToBlack). Yine de hafif gri zemin, diğer
                      // renkli izlerin kenarlarını biraz daha belirgin
                      // kılmak için korunuyor.
                      color: PdfColors.grey100,
                    ),
                    child: pw.Image(
                      pw.MemoryImage(pngBytes),
                      width: pdfContentWidth,
                      height: drawingHeight,
                      fit: pw.BoxFit.fill,
                    ),
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
