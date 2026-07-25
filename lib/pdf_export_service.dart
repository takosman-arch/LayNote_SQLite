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

  // Notu PDF'e dönüştürüp geçici klasöre yazar ve oluşan dosyayı döndürür.
  static Future<File> exportNoteToPdf({
    required String title,
    required String noteType,
    required List<Map<String, dynamic>> blocks,
    required List<Map<String, dynamic>> checkItems,
    required List<Map<String, dynamic>> attachments,
  }) async {
    await _ensureFonts();
    final regular = _regularFont!;
    final bold = _boldFont!;

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
          imageCache[att['id'].toString()] = pw.MemoryImage(
            await file.readAsBytes(),
          );
        } catch (_) {
          // Bozuk/okunamayan resim dosyası: PDF'te atlanır.
        }
      }
    }
    final attachmentsById = {for (final a in attachments) a['id'].toString(): a};

    pw.Widget checklistRow(String text, bool checked) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 4),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              checked ? '[x]  ' : '[ ]  ',
              style: pw.TextStyle(font: regular, fontSize: 12),
            ),
            pw.Expanded(
              child: pw.Text(
                text,
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 12,
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
        style: pw.TextStyle(font: bold, fontSize: 20),
      ),
      pw.SizedBox(height: 4),
      pw.Text(
        _formatDateTimeTr(DateTime.now()),
        style: pw.TextStyle(font: regular, fontSize: 9, color: PdfColors.grey600),
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
                style: pw.TextStyle(font: regular, fontSize: 12),
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
                      style: pw.TextStyle(font: regular, fontSize: 11),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 4,
                    ),
                    child: pw.Text(
                      valueText,
                      style: pw.TextStyle(font: regular, fontSize: 11),
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
                      style: pw.TextStyle(font: bold, fontSize: 11),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 4,
                    ),
                    child: pw.Text(
                      ContentBlocks.formatCalcNumber(total),
                      style: pw.TextStyle(font: bold, fontSize: 11),
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
          for (final id in ids) {
            final att = attachmentsById[id];
            if (att == null) continue;
            final img = imageCache[id];
            if (img != null) {
              content.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Image(img, fit: pw.BoxFit.contain),
                ),
              );
            } else {
              final name = (att['fileName'] ?? 'Ek dosya').toString();
              content.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Text(
                    '📎 $name',
                    style: pw.TextStyle(
                      font: regular,
                      fontSize: 11,
                      color: PdfColors.grey700,
                    ),
                  ),
                ),
              );
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
