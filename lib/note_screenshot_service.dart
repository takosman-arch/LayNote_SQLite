part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// EKRAN GÖRÜNTÜSÜ TARZI JPG DIŞA AKTARMA (NoteScreenshotService)
// PdfExportService'ten farklı olarak PDF'i araya sokmaz: notu doğrudan
// uygulamanın kendi görünümüyle (koyu/açık tema, gerçek checkbox ikonu,
// telefon ekran genişliği) statik bir widget ağacı olarak çizer ve
// RepaintBoundary ile resme çevirir. Bu widget kullanıcıya hiç görünmez:
// Overlay'e ekranın çok dışına (negatif offset) yerleştirilir, birkaç kare
// boyandıktan sonra görüntüsü alınır ve hemen kaldırılır.
//
// NOT: JPEG kodlaması için pubspec.yaml'a "image" paketi eklenmesi
// gerekir (ör. image: ^4.2.0) — dart:ui yalnızca PNG/ham veri üretir,
// PNG'yi gerçek bir JPEG'e çevirmek bu paketle yapılıyor.
// ════════════════════════════════════════════════════════════════════════
class NoteScreenshotService {
  static Future<File> exportNoteAsScreenshotJpg({
    required BuildContext context,
    required String title,
    // Not başlığındaki kalın/italik/altı çizili/üstü çizili/vurgu/özel
    // renk-link span'ları (bkz. rich_text_spans.dart). Verilmezse (null/boş)
    // başlık eskisi gibi tek tip w600 düz metin olarak çizilir.
    List<dynamic>? titleSpans,
    required String noteType,
    required List<Map<String, dynamic>> blocks,
    required List<Map<String, dynamic>> checkItems,
    required List<Map<String, dynamic>> attachments,
    required double fontSize,
    // Notun/uygulamanın genel yazı stili (Ayarlar > Kişiselleştirme >
    // Yazı Stili). Span bazlı özel font override'ları (RichTextSpans)
    // zaten kendi 'fontFamily' değerini taşıdığından bunlardan
    // etkilenmez; bu yalnızca span'da özel font seçilmemiş metinlerin
    // düşeceği TABAN fonttur. null ise sistem varsayılanı kullanılır
    // (eskiden zaten hep bu oluyordu).
    String? fontFamily,
    required Color textColor,
    required Color borderColor,
    required Color backgroundColor,
  }) async {
    final overlay = Overlay.of(context, rootOverlay: true);
    // Düzenleyicideki modalın kendisi de ekranın tam genişliğini,
    // içerikte ise 20+20'lik yatay padding'i kullanıyor (bkz.
    // note_list_screen.dart, SingleChildScrollView padding: EdgeInsets.all(20)).
    // Aynı oranları birebir yakalamak için gerçek ekran genişliğini kullanıyoruz.
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = 20.0;
    final contentWidth = screenWidth - (horizontalPadding * 2);

    final boundaryKey = GlobalKey();
    final attachmentsDir = await DBHelper.instance.attachmentsDir();

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        left: -screenWidth * 4, // ekranın tamamen dışında, kullanıcı görmez
        top: 0,
        child: Material(
          type: MaterialType.transparency,
          child: RepaintBoundary(
            key: boundaryKey,
            child: Container(
              width: screenWidth,
              color: backgroundColor,
              padding: const EdgeInsets.all(horizontalPadding),
              child: _NoteScreenshotContent(
                title: title,
                titleSpans: titleSpans,
                noteType: noteType,
                blocks: blocks,
                checkItems: checkItems,
                attachments: attachments,
                fontSize: fontSize,
                fontFamily: fontFamily,
                textColor: textColor,
                borderColor: borderColor,
                contentWidth: contentWidth,
                attachmentsDirPath: attachmentsDir.path,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Uint8List pngBytes;
    try {
      // Image.file ile diskten okunan ekli fotoğrafların ilk kareye tam
      // olarak çizilebilmesi için birkaç kare bekliyoruz; tek
      // postFrameCallback bazen resimler hazır olmadan yakalamaya
      // çalışıyordu.
      for (var i = 0; i < 4; i++) {
        await WidgetsBinding.instance.endOfFrame;
      }

      final renderObject = boundaryKey.currentContext?.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) {
        throw Exception('Ekran görüntüsü alınamadı (boundary bulunamadı)');
      }
      final image = await renderObject.toImage(pixelRatio: 2.5);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (byteData == null) {
        throw Exception('Ekran görüntüsü verisi oluşturulamadı');
      }
      pngBytes = byteData.buffer.asUint8List();
    } finally {
      entry.remove();
    }

    // dart:ui yalnızca PNG üretebildiği için gerçek bir JPEG'e çevirmek
    // amacıyla "image" paketiyle decode/encode ediyoruz.
    final decoded = img.decodePng(pngBytes);
    if (decoded == null) {
      throw Exception('Görüntü işlenemedi (PNG çözümlenemedi)');
    }
    final jpgBytes = img.encodeJpg(decoded, quality: 92);

    final tempDir = await getTemporaryDirectory();
    final safeTitle = title.trim().isEmpty
        ? 'not'
        : title.trim().replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    final filePath = p.join(
      tempDir.path,
      '${safeTitle}_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    final file = File(filePath);
    await file.writeAsBytes(jpgBytes);
    return file;
  }
}

// Notun ekran görüntüsü için çizilen, salt-okunur (etkileşimsiz) içerik.
// Düzenleyicideki TextField'lar burada düz Text widget'larına karşılık
// gelir; checkbox'lar da gerçek Icons.check_box / check_box_outline_blank
// ikonlarıyla (uygulamadaki Checkbox widget'ının görünümüne yakın) çizilir.
class _NoteScreenshotContent extends StatelessWidget {
  final String title;
  final List<dynamic>? titleSpans;
  final String noteType;
  final List<Map<String, dynamic>> blocks;
  final List<Map<String, dynamic>> checkItems;
  final List<Map<String, dynamic>> attachments;
  final double fontSize;
  final String? fontFamily;
  final Color textColor;
  final Color borderColor;
  final double contentWidth;
  final String attachmentsDirPath;

  const _NoteScreenshotContent({
    required this.title,
    this.titleSpans,
    required this.noteType,
    required this.blocks,
    required this.checkItems,
    required this.attachments,
    required this.fontSize,
    this.fontFamily,
    required this.textColor,
    required this.borderColor,
    required this.contentWidth,
    required this.attachmentsDirPath,
  });

  Widget _checklistRow(String text, bool checked) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            checked ? Icons.check_box : Icons.check_box_outline_blank,
            color: checked ? appAccentColor.value : Colors.grey,
            size: fontSize + 6,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: fontFamily,
                color: checked ? Colors.grey : textColor,
                decoration: checked ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attachmentGrid(List<String> ids) {
    final byId = {for (final a in attachments) a['id'].toString(): a};
    final items = ids.where((id) => byId[id] != null).toList();
    if (items.isEmpty) return const SizedBox.shrink();

    const spacing = 4.0;
    final singleFull = items.length == 1;
    // Düzenleyicideki _buildAttachmentGrid ile birebir aynı kurallar:
    // tek foto tam genişlik + sabit 220 yükseklik, birden fazlaysa kare
    // ızgara (bkz. note_list_screen.dart _AttachmentTile kullanımı).
    final itemWidth = singleFull ? contentWidth : (contentWidth - spacing) / 2;
    final itemHeight = singleFull ? 220.0 : itemWidth;

    Widget tile(Map<String, dynamic> att) {
      final isImage = att['isImage'] == true;
      final filePath = p.join(attachmentsDirPath, att['storedName'].toString());
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          width: itemWidth,
          height: itemHeight,
          child: isImage
              ? Image.file(
                  File(filePath),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade800,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.broken_image_outlined,
                      color: Colors.grey,
                    ),
                  ),
                )
              : Container(
                  color: Colors.grey.shade800,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    '📎 ${(att['fileName'] ?? 'Ek dosya').toString()}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: items.map((id) => tile(byId[id]!)).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // PDF dışa aktarmadaki aynı kural: not sadece TEK bir çizim bloğundan
    // ibaretse (başka metin/kontrol listesi/hesap tablosu/ek yoksa)
    // başlık/tarih hiç gösterilmiyor; çizim görselin tamamını kullanır.
    final isDrawingOnlyNote = noteType != 'checklist' &&
        blocks.length == 1 &&
        blocks.first['type'] == 'drawing';

    final children = <Widget>[
      if (!isDrawingOnlyNote) ...[
        Text.rich(
          RichTextSpans.buildStaticSpan(
            text: title.trim().isEmpty ? 'Başlıksız Not' : title.trim(),
            rawSpans: titleSpans,
            style: TextStyle(
              fontSize: 20,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _formatDateTimeTr(DateTime.now()),
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        SizedBox(height: 16, child: Divider(color: borderColor, height: 1)),
        const SizedBox(height: 12),
      ],
    ];

    if (noteType == 'checklist') {
      for (final item in checkItems) {
        final text = (item['text'] ?? '').toString();
        if (text.trim().isEmpty) continue;
        children.add(_checklistRow(text, item['checked'] == true));
      }
    } else {
      for (final block in blocks) {
        final type = block['type'];
        if (type == 'text') {
          final text = (block['text'] ?? '').toString();
          if (text.trim().isEmpty) continue;
          // DÜZELTME: JPG dışa aktarma eskiden düzenleyicideki spans
          // (kalın/italik/altı çizili/üzeri çizili/vurgu/özel renk-boyut-
          // yazı tipi/link) verisini hiç okumadan metni düz bir Text
          // widget'ına veriyordu — bu yüzden zengin metinli notlar dışa
          // aktarılan görselde biçimsiz görünüyordu. Artık düzenleyicideki
          // RichBlockTextController.buildTextSpan ile AYNI mantığı kullanan
          // RichTextSpans.buildStaticSpan çağrılıyor (bkz. rich_text_spans.dart).
          final isDark = Theme.of(context).brightness == Brightness.dark;
          children.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text.rich(
                RichTextSpans.buildStaticSpan(
                  text: text,
                  rawSpans: block['spans'] as List?,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontFamily: fontFamily,
                    color: textColor,
                    height: 1.4,
                  ),
                  isDark: isDark,
                ),
              ),
            ),
          );
        } else if (type == 'checklist') {
          final items = List<Map>.from(block['items'] ?? const []);
          final rows = <Widget>[];
          for (final item in items) {
            final text = (item['text'] ?? '').toString();
            if (text.trim().isEmpty) continue;
            rows.add(_checklistRow(text, item['checked'] == true));
          }
          if (rows.isNotEmpty) {
            children.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: rows,
                ),
              ),
            );
          }
        } else if (type == 'calc_table') {
          final rows = List<Map>.from(block['rows'] ?? const []);
          double total = 0;
          final tableRows = <TableRow>[];
          for (final row in rows) {
            final label = (row['label'] ?? '').toString();
            final valueText = (row['value'] ?? '').toString();
            if (label.trim().isEmpty && valueText.trim().isEmpty) continue;
            total += ContentBlocks.parseCalcValue(row['value']);
            tableRows.add(
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                        color: textColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                    child: Text(
                      valueText,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          if (tableRows.isNotEmpty) {
            tableRows.add(
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                    child: Text(
                      'Toplam',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                    child: Text(
                      ContentBlocks.formatCalcNumber(total),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
            children.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Table(
                  border: TableBorder.all(color: borderColor, width: 0.5),
                  columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1)},
                  children: tableRows,
                ),
              ),
            );
          }
        } else if (type == 'divider') {
          children.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(color: borderColor, height: 1),
            ),
          );
        } else if (type == 'attachments') {
          final ids = List<String>.from(
            (block['ids'] as List? ?? const []).map((e) => e.toString()),
          );
          children.add(_attachmentGrid(ids));
        } else if (type == 'drawing') {
          // Düzenleyicideki NoteDrawingBlock ile birebir aynı görünüm için
          // aynı _DrawingPainter doğrudan kullanılıyor (etkileşimsiz,
          // sadece render). ÖNEMLİ (kırpılma düzeltmesi): tuval eskiden
          // sabit `contentWidth` (telefon ekranı genişliği) ile
          // çiziliyordu; ama tam ekranda kenar boşluksuz çizilmiş, ekrandan
          // daha geniş stroke'lar bu durumda RepaintBoundary'nin sağ
          // kenarının dışında kalıp kırpılıyordu. PDF export'taki
          // NoteDrawingRenderer.requiredCanvasWidth/Height ile BİREBİR
          // aynı mantık burada da uygulanıyor: önce çizimin gerçek (tam,
          // kırpılmamış) kapsamı hesaplanır, ardından bu doğal boyut
          // en/boy oranı KORUNARAK `contentWidth`'e sığdırılır (yalnızca
          // gerekiyorsa küçültülür, asla büyütülmez) ve FittedBox ile hem
          // X hem Y ekseninde ortalanır.
          final strokes = List<Map<String, dynamic>>.from(
            block['strokes'] ?? const [],
          );
          if (strokes.isNotEmpty) {
            final canvasWidth = NoteDrawingRenderer.requiredCanvasWidth(
              strokes,
              minWidth: contentWidth,
            );
            final canvasHeight =
                NoteDrawingRenderer.requiredCanvasHeight(strokes);
            // Sadece küçültme yönünde ölçekle (fitScale asla 1.0'ı geçmez):
            // çizim contentWidth'ten dar/eşitse hiç ölçeklenmez.
            final fitScale = canvasWidth > contentWidth
                ? contentWidth / canvasWidth
                : 1.0;
            final displayHeight = canvasHeight * fitScale;
            children.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SizedBox(
                  width: contentWidth,
                  height: displayHeight,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: canvasWidth,
                      height: canvasHeight,
                      child: CustomPaint(
                        painter: _DrawingPainter(
                          strokes: strokes,
                          livePoints: null,
                          liveColor: Colors.transparent,
                          liveWidth: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
