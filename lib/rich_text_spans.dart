part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// ZENGİN METİN SPAN'LARI (RichTextSpans)
// Bir "text" bloğu içindeki metnin hangi aralıklarının kalın/italik/altı
// çizili olduğunu, ayrıca hangi aralıkların özel yazı boyutu/renk/yazı
// tipi ailesine sahip olduğunu tutan, content_blocks.dart'tan bağımsız
// küçük bir yardımcı katman. Bu dosya content_blocks.dart'ı DEĞİŞTİRMEZ;
// sadece span verisiyle ilgili ayrıştırma/temizleme/karşılaştırma
// mantığını burada tutar. content_blocks.dart içine sadece bu sınıfı
// çağıran birkaç satır eklenmesi yeterli olacak (bkz. sohbetteki
// entegrasyon notları).
//
// Veri şekli (bir text bloğu içinde "spans" alanı olarak saklanır):
//   [{"start": 0, "end": 5, "bold": true, "italic": false,
//     "underline": false, "strikethrough": false, "fontSize": 20.0,
//     "color": 0xFFFF0000, "fontFamily": "serif"}, ...]
//
// - start/end: metindeki karakter indeksleri (start dahil, end hariç —
//   Dart'ın String.substring(start, end) kuralıyla aynı).
// - bold/italic/underline/strikethrough/highlight: AÇ/KAPA (boolean)
//   özellikler — toggle ile uygulanır (bkz. toggleBold/toggleItalic/
//   toggleUnderline/toggleStrikethrough/toggleHighlight). highlight,
//   metnin arka planını sabit bir vurgu rengiyle boyar (Google Docs/
//   Gmail'deki sarı vurgu kalemine benzer); renk seçimi YOKTUR, tek bir
//   AÇ/KAPA durumudur (renk seçilebilir vurgu istenirse ileride 'color'
//   deseninde ayrı bir 'highlightColor' alanı eklenebilir).
// - fontSize/color/fontFamily/link: DEĞER bazlı özellikler — bir
//   picker'dan/diyalogdan seçilen değer doğrudan atanır (bkz. setFontSize/
//   setColor/setFontFamily/setLink). null, "bu aralıkta özel bir değer
//   yok, blok/tema varsayılanını kullan" (link için: "bu aralık bir link
//   değil") anlamına gelir.
// - Aralıklar üst üste binebilir (ör. hem kalın hem italik hem de özel
//   renkli olan bir kısım, tek bir span map'i içinde bold:true,
//   italic:true, color:... alanlarının hepsini birden taşıyabilir —
//   run birleştirme mantığı bunu otomatik yönetir).
// - Eski notlarda "spans" alanı hiç yok -> boş liste kabul edilir, metin
//   düz yazı gibi davranmaya devam eder (geriye dönük uyumluluk). Eski
//   spans'larda fontSize/color/fontFamily alanları yoksa null kabul
//   edilir (varsayılan görünüm bozulmaz).
// ════════════════════════════════════════════════════════════════════════
class RichTextSpans {
  RichTextSpans._();

  // JSON'dan (ya da zaten decode edilmiş dynamic'ten) span listesini okur.
  // Alan hiç yoksa, null ise, liste değilse ya da bir öğe beklenen
  // alanlara sahip değilse o öğe sessizce atlanır — bozuk/eksik veri asla
  // hata fırlatmaz. content_blocks.dart -> parse() içinde her text
  // bloğu için çağrılması yeterlidir:
  //   m['spans'] = RichTextSpans.parse(m['spans']);
  static List<Map<String, dynamic>> parse(dynamic raw) {
    if (raw is! List) return [];
    final result = <Map<String, dynamic>>[];
    for (final e in raw) {
      if (e is! Map) continue;
      final start = (e['start'] as num?)?.toInt();
      final end = (e['end'] as num?)?.toInt();
      if (start == null || end == null || start < 0 || end <= start) {
        continue; // geçersiz aralık, atla
      }
      result.add({
        'start': start,
        'end': end,
        'bold': e['bold'] == true,
        'italic': e['italic'] == true,
        'underline': e['underline'] == true,
        'strikethrough': e['strikethrough'] == true,
        'highlight': e['highlight'] == true,
        'fontSize': (e['fontSize'] as num?)?.toDouble(),
        'color': (e['color'] as num?)?.toInt(),
        'fontFamily': e['fontFamily'] is String ? e['fontFamily'] as String : null,
        'link': e['link'] is String ? e['link'] as String : null,
      });
    }
    return result;
  }

  // Kaydetmeden (serialize) önce span listesini temizler: geçersiz
  // öğeleri atar, alanları sabit bir şekle sokar. parse() zaten aynı
  // temizliği yaptığı için burada tekrar ona yönlendirmek yeterli.
  // content_blocks.dart -> serialize() içinde her text bloğu için
  // çağrılması yeterlidir:
  //   m['spans'] = RichTextSpans.clean(m['spans'] as List?);
  static List<Map<String, dynamic>> clean(List? spans) {
    if (spans == null || spans.isEmpty) return [];
    return parse(spans);
  }

  // equalsStoredContent() içinde iki span listesini karşılaştırmak için.
  // Sıra da anlamlıdır (checklist/calc_table karşılaştırmalarıyla aynı
  // desen): spans genelde ekleniş sırasına göre oluştuğundan, sıra
  // değişmesi de içerik değişikliği sayılır — aksi halde "biçim değişti
  // ama içerik aynı" sanılıp kaydetme atlanabilir.
  // content_blocks.dart -> equalsStoredContent() içindeki 'text' dalına
  // eklenmesi yeterlidir:
  //   if (!RichTextSpans.listEquals(a['spans'] as List?, b['spans'] as List?))
  //     return false;
  static bool listEquals(List? a, List? b) {
    final la = parse(a);
    final lb = parse(b);
    if (la.length != lb.length) return false;
    for (int i = 0; i < la.length; i++) {
      final sa = la[i];
      final sb = lb[i];
      if (sa['start'] != sb['start'] ||
          sa['end'] != sb['end'] ||
          sa['bold'] != sb['bold'] ||
          sa['italic'] != sb['italic'] ||
          sa['underline'] != sb['underline'] ||
          sa['strikethrough'] != sb['strikethrough'] ||
          sa['highlight'] != sb['highlight'] ||
          sa['fontSize'] != sb['fontSize'] ||
          sa['color'] != sb['color'] ||
          sa['fontFamily'] != sb['fontFamily'] ||
          sa['link'] != sb['link']) {
        return false;
      }
    }
    return true;
  }

  // ── Aşama 6 düzeltmesi: metne ekleme/silme yapıldığında span kaydırma ──
  // Bullet kısayolu gibi, kullanıcının doğrudan yazmadığı ama kodun
  // metnin ortasına/satır başına karakter EKLEYİP ÇIKARDIĞI durumlarda
  // (ör. "• " işaretinin satır başına eklenmesi/kaldırılması), mevcut
  // span'ların start/end değerleri de buna göre kaymalıdır. Aksi halde
  // ekleme/silme noktasından sonraki span'lar yanlış karakter aralığını
  // işaret etmeye devam eder (bkz. test.txt'teki risk notu).
  //
  // shiftForInsert: [at] konumuna [length] karakter eklendiğinde çağrılır.
  // - Ekleme noktası bir span'ın İÇİNDEYSE (start < at < end), span
  //   eklenen metni de kapsayacak şekilde genişletilir (end += length) —
  //   ör. kalın bir kelimenin ortasına yeni harf yazmak o kelimeyi kalın
  //   tutmaya devam etmeli.
  // - Ekleme noktası bir span'ın start'ında veya ondan önceyse, span
  //   bütünüyle ileri kaydırılır (start ve end += length).
  // - Ekleme noktası bir span'ın end'inde veya ondan sonraysa, span hiç
  //   etkilenmez.
  static List<Map<String, dynamic>> shiftForInsert(
    List? spans,
    int at,
    int length,
  ) {
    if (length <= 0) return parse(spans);
    final result = <Map<String, dynamic>>[];
    for (final s in parse(spans)) {
      var start = s['start'] as int;
      var end = s['end'] as int;
      if (at <= start) {
        start += length;
        end += length;
      } else if (at < end) {
        end += length;
      }
      result.add({
        'start': start,
        'end': end,
        'bold': s['bold'],
        'italic': s['italic'],
        'underline': s['underline'],
        'strikethrough': s['strikethrough'],
        'highlight': s['highlight'],
        'fontSize': s['fontSize'],
        'color': s['color'],
        'fontFamily': s['fontFamily'],
        'link': s['link'],
      });
    }
    return result;
  }

  // shiftForDelete: [start, end) aralığındaki metin silindiğinde çağrılır.
  // - Silinen aralığın tamamen içinde kalan span'lar (start/end silinen
  //   aralığa denk düşüyorsa) o kısmı kaybeder; span tamamen silinen
  //   aralığın içindeyse listeden çıkarılır.
  // - Silinen aralıktan sonraki span'lar, silinen uzunluk kadar geri
  //   kaydırılır.
  static List<Map<String, dynamic>> shiftForDelete(
    List? spans,
    int start,
    int end,
  ) {
    final length = end - start;
    if (length <= 0) return parse(spans);
    final result = <Map<String, dynamic>>[];
    for (final s in parse(spans)) {
      var sStart = s['start'] as int;
      var sEnd = s['end'] as int;
      if (sStart >= end) {
        sStart -= length;
      } else if (sStart > start) {
        sStart = start;
      }
      if (sEnd >= end) {
        sEnd -= length;
      } else if (sEnd > start) {
        sEnd = start;
      }
      if (sEnd <= sStart) continue; // span tamamen silindi
      result.add({
        'start': sStart,
        'end': sEnd,
        'bold': s['bold'],
        'italic': s['italic'],
        'underline': s['underline'],
        'strikethrough': s['strikethrough'],
        'highlight': s['highlight'],
        'fontSize': s['fontSize'],
        'color': s['color'],
        'fontFamily': s['fontFamily'],
        'link': s['link'],
      });
    }
    return result;
  }

  // Verilen span listesini, [0, textLength] aralığını tamamen kapsayan,
  // örtüşmeyen "run"lara ayırır (RichBlockTextController.buildTextSpan ile
  // AYNI breakpoint mantığı). Seçim sınırları (start/end) da kırılma
  // noktası olarak eklenir ki sonraki toggle/set işlemi tam seçim
  // sınırında dursun. Her run, o aralıkta etkili olan TÜM özellikleri
  // (bold/italic/underline/fontSize/color/fontFamily) taşır — bu sayede
  // ör. sadece kalınlığı değiştiren bir toggle, aynı aralıktaki rengi
  // yanlışlıkla silmez.
  static List<Map<String, dynamic>> _buildRuns(
    List<Map<String, dynamic>> spans,
    int textLength,
    int start,
    int end,
  ) {
    final breakpoints = <int>{0, textLength, start, end};
    for (final s in spans) {
      breakpoints.add(s['start'] as int);
      breakpoints.add(s['end'] as int);
    }
    final points = breakpoints.toList()..sort();

    final runs = <Map<String, dynamic>>[];
    for (int i = 0; i < points.length - 1; i++) {
      final rStart = points[i];
      final rEnd = points[i + 1];
      if (rStart >= rEnd) continue;
      bool bold = false;
      bool italic = false;
      bool underline = false;
      bool strikethrough = false;
      bool highlight = false;
      double? fontSize;
      int? color;
      String? fontFamily;
      String? link;
      for (final s in spans) {
        final sStart = s['start'] as int;
        final sEnd = s['end'] as int;
        if (rStart >= sStart && rEnd <= sEnd) {
          if (s['bold'] == true) bold = true;
          if (s['italic'] == true) italic = true;
          if (s['underline'] == true) underline = true;
          if (s['strikethrough'] == true) strikethrough = true;
          if (s['highlight'] == true) highlight = true;
          if (s['fontSize'] != null) fontSize = s['fontSize'] as double;
          if (s['color'] != null) color = s['color'] as int;
          if (s['fontFamily'] != null) fontFamily = s['fontFamily'] as String;
          if (s['link'] != null) link = s['link'] as String;
        }
      }
      runs.add({
        'start': rStart,
        'end': rEnd,
        'bold': bold,
        'italic': italic,
        'underline': underline,
        'strikethrough': strikethrough,
        'highlight': highlight,
        'fontSize': fontSize,
        'color': color,
        'fontFamily': fontFamily,
        'link': link,
      });
    }
    return runs;
  }

  // Bitişik, TÜM özellikleri (bold/italic/underline/fontSize/color/
  // fontFamily) birebir aynı olan run'ları tek span'e birleştirir;
  // hiçbir özelliği "açık"/atanmış olmayan (tamamen varsayılan) run'lar
  // span listesine hiç girmez — bu sayede spans listesi her zaman minimal
  // kalır.
  static List<Map<String, dynamic>> _mergeRuns(
    List<Map<String, dynamic>> runs,
  ) {
    final merged = <Map<String, dynamic>>[];
    for (final r in runs) {
      final isDefault = r['bold'] != true &&
          r['italic'] != true &&
          r['underline'] != true &&
          r['strikethrough'] != true &&
          r['highlight'] != true &&
          r['fontSize'] == null &&
          r['color'] == null &&
          r['fontFamily'] == null &&
          r['link'] == null;
      if (isDefault) continue;
      if (merged.isNotEmpty &&
          merged.last['end'] == r['start'] &&
          merged.last['bold'] == r['bold'] &&
          merged.last['italic'] == r['italic'] &&
          merged.last['underline'] == r['underline'] &&
          merged.last['strikethrough'] == r['strikethrough'] &&
          merged.last['highlight'] == r['highlight'] &&
          merged.last['fontSize'] == r['fontSize'] &&
          merged.last['color'] == r['color'] &&
          merged.last['fontFamily'] == r['fontFamily'] &&
          merged.last['link'] == r['link']) {
        merged.last['end'] = r['end'];
      } else {
        merged.add(Map<String, dynamic>.from(r));
      }
    }
    return merged;
  }

  // ── Statik (salt-okunur) render için TextSpan ağacı üretimi ────────────
  // RichBlockTextController.buildTextSpan içindeki dilimleme/stil mantığının
  // AYNISI, ancak düzenleme yapılmayan yerlerde (JPG ekran görüntüsü dışa
  // aktarma, PDF dışa aktarma vb.) kullanılmak üzere buraya taşındı. FARK:
  // TapGestureRecognizer YOK — bu bir controller değil, tek seferlik statik
  // bir görüntü; link'ler yalnızca görsel olarak (mavi + altı çizili)
  // gösterilir, tıklanabilir değildir.
  //
  // Bu metot eklenmeden önce ekran görüntüsü/PDF dışa aktarma, blok
  // metnini doğrudan düz bir Text widget'ına veriyordu — bu yüzden
  // düzenleyicide kalın/italik/vurgu/link uygulanmış metinler dışa
  // aktarılan JPG'de düz metin olarak görünüyordu (spans verisi hiç
  // okunmuyordu). Çağıran taraf artık:
  //   Text.rich(RichTextSpans.buildStaticSpan(
  //     text: text, rawSpans: block['spans'], style: ..., isDark: ...,
  //   ))
  // kullanmalıdır.
  static TextSpan buildStaticSpan({
    required String text,
    required List? rawSpans,
    required TextStyle? style,
    required bool isDark,
  }) {
    final spans = parse(rawSpans);
    if (spans.isEmpty || text.isEmpty) {
      return TextSpan(style: style, text: text);
    }
    final effectiveHighlightColor =
        isDark ? _highlightColorDark : _highlightColorLight;

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

    final children = <TextSpan>[];
    for (int i = 0; i < points.length - 1; i++) {
      final start = points[i];
      final end = points[i + 1];
      if (start >= end) continue;
      bool bold = false;
      bool italic = false;
      bool underline = false;
      bool strikethrough = false;
      bool highlight = false;
      double? fontSize;
      int? color;
      String? fontFamily;
      String? link;
      for (final s in spans) {
        final sStart = clampIndex(s['start'] as num, text.length);
        final sEnd = clampIndex(s['end'] as num, text.length);
        if (start >= sStart && end <= sEnd) {
          if (s['bold'] == true) bold = true;
          if (s['italic'] == true) italic = true;
          if (s['underline'] == true) underline = true;
          if (s['strikethrough'] == true) strikethrough = true;
          if (s['highlight'] == true) highlight = true;
          final sz = s['fontSize'];
          if (sz is num) fontSize = sz.toDouble();
          final c = s['color'];
          if (c is num) color = c.toInt();
          final ff = s['fontFamily'];
          if (ff is String) fontFamily = ff;
          final lk = s['link'];
          if (lk is String && lk.isNotEmpty) link = lk;
        }
      }
      TextStyle? partStyle = style;
      if (bold || italic || underline || strikethrough || highlight ||
          fontSize != null || color != null || fontFamily != null ||
          link != null) {
        // Bkz. RichBlockTextController.buildTextSpan'daki aynı satırlar:
        // altı çizili + üzeri çizili birlikte açık olabileceğinden
        // TextDecoration.combine kullanılıyor; link'ler her zaman ek
        // olarak altı çizili gösterilir (span verisine yazılmadan).
        final showUnderline = underline || link != null;
        TextDecoration? decoration = style?.decoration;
        if (showUnderline || strikethrough) {
          final parts = <TextDecoration>[
            if (showUnderline) TextDecoration.underline,
            if (strikethrough) TextDecoration.lineThrough,
          ];
          decoration = TextDecoration.combine(parts);
        }
        final effectiveColor = color != null
            ? Color(color)
            : (link != null ? _linkColor : style?.color);
        partStyle = (style ?? const TextStyle()).copyWith(
          fontWeight: bold ? _boldWeightFor(style?.fontWeight) : style?.fontWeight,
          fontStyle: italic ? FontStyle.italic : style?.fontStyle,
          decoration: decoration,
          fontSize: fontSize ?? style?.fontSize,
          color: effectiveColor,
          fontFamily: fontFamily ?? style?.fontFamily,
          backgroundColor:
              highlight ? effectiveHighlightColor : style?.backgroundColor,
        );
      }
      children.add(
        TextSpan(text: text.substring(start, end), style: partStyle),
      );
    }
    return TextSpan(style: style, children: children);
  }

  // ── Seçili aralığa kalın/italik/altı çizili uygulama (toggle) ──────────
  // Klavye üstü toolbar butonları bunları çağırır. Seçili aralıktaki
  // run'lar zaten hepsi attr==true ise KAPATIR, aksi halde (hiç yoksa ya
  // da kısmen varsa) hepsini AÇAR — Word/Docs davranışıyla aynı. Aynı
  // aralıktaki fontSize/color/fontFamily gibi diğer özellikler korunur.
  static List<Map<String, dynamic>> toggleBold(
    List? spans,
    int textLength,
    int start,
    int end,
  ) => _toggleAttribute(spans, textLength, start, end, 'bold');

  static List<Map<String, dynamic>> toggleItalic(
    List? spans,
    int textLength,
    int start,
    int end,
  ) => _toggleAttribute(spans, textLength, start, end, 'italic');

  static List<Map<String, dynamic>> toggleUnderline(
    List? spans,
    int textLength,
    int start,
    int end,
  ) => _toggleAttribute(spans, textLength, start, end, 'underline');

  static List<Map<String, dynamic>> toggleStrikethrough(
    List? spans,
    int textLength,
    int start,
    int end,
  ) => _toggleAttribute(spans, textLength, start, end, 'strikethrough');

  // Metin vurgulama (highlight): arka planı sabit bir vurgu rengiyle
  // boyar/kaldırır. Diğer toggle'larla (bold/italic/underline/
  // strikethrough) AYNI desen — kısmen vurgulanmış bir seçimde hepsini
  // AÇAR, tamamı zaten vurgulanmışsa hepsini KAPATIR.
  static List<Map<String, dynamic>> toggleHighlight(
    List? spans,
    int textLength,
    int start,
    int end,
  ) => _toggleAttribute(spans, textLength, start, end, 'highlight');

  static List<Map<String, dynamic>> _toggleAttribute(
    List? rawSpans,
    int textLength,
    int rawStart,
    int rawEnd,
    String attr,
  ) {
    final spans = parse(rawSpans);
    final start = rawStart.clamp(0, textLength);
    final end = rawEnd.clamp(0, textLength);
    if (start >= end) return spans; // seçim yok/geçersiz: değişiklik yok

    final runs = _buildRuns(spans, textLength, start, end);

    final allOn = isAttributeFullyActive(rawSpans, textLength, start, end, attr);
    for (final r in runs) {
      if ((r['start'] as int) >= start && (r['end'] as int) <= end) {
        r[attr] = !allOn;
      }
    }
    return _mergeRuns(runs);
  }

  // ── Seçili aralıkta bir AÇ/KAPA özelliğin (bold/italic/underline/
  // strikethrough/highlight) GERÇEKTEN aktif olup olmadığını okur ────────
  // _toggleAttribute'daki "allOn" hesabıyla BİREBİR AYNI mantık — buradan
  // dışa açılmasının sebebi, araç çubuğu ikonlarının (basılınca vurgu
  // rengi alması gereken Kalın/İtalik/Altı Çizili/Üzeri Çizili/Vurgula
  // butonları) "şu an aktif mi" durumunu, imleç tek noktadayken kullanılan
  // pending* değişkenleri yerine, GERÇEK bir metin seçimi varken seçili
  // aralığın span'larından okuyabilmesi — tıpkı getEffectiveFontSize/
  // getEffectiveColor'ın value bazlı özellikler için zaten yaptığı gibi
  // (bkz. o metotların üzerindeki açıklama). Bu karşılık daha önce
  // eklenmediğinden, seçili (ve zaten kalın/italik/vb. olan) bir metin
  // üzerinde ikonlar hiç vurgu rengi almıyordu — kullanıcı butona
  // BASMADIĞI sürece pending* hiç güncellenmiyordu.
  //
  // Dönen değer: seçili aralık en az bir run içeriyor VE o run'ların
  // TAMAMINDA [attr] true İSE true; aksi halde (kısmi/karışık seçim,
  // tamamı kapalı, ya da geçersiz aralık) false. Bu, _toggleAttribute'un
  // "bir sonraki basışta AÇACAK mı KAPATACAK mı" kararıyla aynı tanımı
  // kullandığından, ikonun gösterdiği "aktif" durumu ile butona basınca
  // olacak davranış her zaman tutarlı kalır.
  static bool isAttributeFullyActive(
    List? rawSpans,
    int textLength,
    int rawStart,
    int rawEnd,
    String attr,
  ) {
    final spans = parse(rawSpans);
    final start = rawStart.clamp(0, textLength);
    final end = rawEnd.clamp(0, textLength);
    if (start >= end) return false; // seçim yok/geçersiz: aktif sayılmaz

    final runs = _buildRuns(spans, textLength, start, end);
    final selectedRuns = runs.where(
      (r) => (r['start'] as int) >= start && (r['end'] as int) <= end,
    );
    return selectedRuns.isNotEmpty && selectedRuns.every((r) => r[attr] == true);
  }

  // ── Seçili aralığa yazı boyutu / renk / yazı tipi ailesi uygulama ──────
  // Bunlar toggle DEĞİLDİR: bir picker'dan (boyut listesi, renk paleti,
  // yazı tipi listesi) seçilen DEĞER doğrudan seçili aralığa atanır.
  // value == null verilirse seçili aralıktaki o özellik temizlenir (blok/
  // tema varsayılanına döner) — "Varsayılan" seçeneği bunu kullanır.
  static List<Map<String, dynamic>> setFontSize(
    List? spans,
    int textLength,
    int start,
    int end,
    double? value,
  ) => _setValueAttribute(spans, textLength, start, end, 'fontSize', value);

  static List<Map<String, dynamic>> setColor(
    List? spans,
    int textLength,
    int start,
    int end,
    int? value,
  ) => _setValueAttribute(spans, textLength, start, end, 'color', value);

  static List<Map<String, dynamic>> setFontFamily(
    List? spans,
    int textLength,
    int start,
    int end,
    String? value,
  ) => _setValueAttribute(spans, textLength, start, end, 'fontFamily', value);

  // Seçili aralığa link (URL) uygular; value == null verilirse seçili
  // aralıktaki linki kaldırır ("Linki Kaldır" gibi bir seçenek eklenirse
  // kullanılabilir). Diğer set* fonksiyonlarıyla AYNI desen — link de bir
  // toggle değil, doğrudan atanan bir DEĞER'dir (bir seçim zaten ya link
  // içerir ya içermez; iki linki "birleştirme" gibi bir belirsizlik yok
  // çünkü link ekleme akışı her zaman kullanıcının o an girdiği TEK bir
  // URL'i uygular).
  static List<Map<String, dynamic>> setLink(
    List? spans,
    int textLength,
    int start,
    int end,
    String? value,
  ) => _setValueAttribute(spans, textLength, start, end, 'link', value);

  static List<Map<String, dynamic>> _setValueAttribute(
    List? rawSpans,
    int textLength,
    int rawStart,
    int rawEnd,
    String attr,
    dynamic value,
  ) {
    final spans = parse(rawSpans);
    final start = rawStart.clamp(0, textLength);
    final end = rawEnd.clamp(0, textLength);
    if (start >= end) return spans; // seçim yok/geçersiz: değişiklik yok

    final runs = _buildRuns(spans, textLength, start, end);
    for (final r in runs) {
      if ((r['start'] as int) >= start && (r['end'] as int) <= end) {
        r[attr] = value;
      }
    }
    return _mergeRuns(runs);
  }

  // ── Seçili aralığın "etkin" (effective) DEĞER'ini okuma ─────────────────
  // Araç çubuğundaki Yazı Boyutu/Renk gösterimi (ikon rengi, hangi çipin
  // "seçili" göründüğü), imleç tek noktadayken pendingFontSize/pendingColor
  // gibi "bekleyen" değişkenlere bakar (bkz. note_list_note_dialog_mixin.dart
  // içindeki aynı isimli alanlar) — ÇÜNKÜ o durumda henüz span'lara hiçbir
  // şey yazılmamıştır, uygulanacak değer sadece bir sonraki karaktere
  // uygulanmak üzere beklemektedir.
  // Ama GERÇEK bir metin seçimi varken (start < end) durum farklıdır: bir
  // boyut/renk seçildiğinde bu setFontSize/setColor üzerinden DOĞRUDAN
  // seçili aralığın span'larına yazılır, pending* değişkenleri hiç
  // değişmez. Bu yüzden arayüzün "şu an aktif" durumunu doğru göstermesi
  // için, gerçek bir seçim olduğunda pending* yerine BURADAN, seçili
  // aralığın span'larından okunan gerçek değer kullanılmalıdır.
  //
  // _toggleAttribute'daki "allOn" mantığının değer (value) bazlı karşılığı:
  // seçili aralık _buildRuns ile run'lara bölünür, seçim sınırları içinde
  // kalan TÜM run'ların [attr] değeri birebir aynıysa o değer döner;
  // aralık boşsa, hiç run yoksa ya da run'lar arasında FARKLI değerler
  // varsa (karışık/kısmi seçim — ör. seçimin bir kısmı 20pt, diğer kısmı
  // varsayılan) null döner. null, arayüzde "belirli/tekil bir değer yok"
  // anlamına gelir ve vurgu/ikon rengi buna göre pasif gösterilmelidir —
  // Word/Google Docs'ta karışık boyutlu bir seçimde boyut kutusunun boş
  // görünmesiyle aynı yaklaşım.
  static double? getEffectiveFontSize(
    List? rawSpans,
    int textLength,
    int start,
    int end,
  ) => _getEffectiveValue(rawSpans, textLength, start, end, 'fontSize')
      as double?;

  // getEffectiveFontSize ile aynı hesaplamayı yapar, ama tek bir double?
  // yerine (value, isMixed) çifti döner. Amaç: düz "null" dönüşünün iki
  // farklı anlamını (1) "seçim gerçekten varsayılan boyutta" ve (2)
  // "seçim karışık — bir kısmı bir boyutta, diğeri başka/varsayılan"
  // birbirinden ayırt edebilmek. getEffectiveFontSize bu ikisini ayırt
  // edemediği için "Varsayılan" seçeneği arayüzde hiçbir zaman aktif
  // gösterilemiyordu; bu metod sayesinde yalnızca GERÇEKTEN varsayılan
  // olan durumda (isMixed == false, value == null) "Varsayılan" aktif
  // işaretlenebilir.
  static (double?, bool) getEffectiveFontSizeInfo(
    List? rawSpans,
    int textLength,
    int start,
    int end,
  ) {
    final spans = parse(rawSpans);
    final clampedStart = start.clamp(0, textLength);
    final clampedEnd = end.clamp(0, textLength);
    if (clampedStart >= clampedEnd) return (null, false);

    final runs = _buildRuns(spans, textLength, clampedStart, clampedEnd);
    final selectedRuns = runs.where(
      (r) =>
          (r['start'] as int) >= clampedStart &&
          (r['end'] as int) <= clampedEnd,
    );
    if (selectedRuns.isEmpty) return (null, false);

    final firstValue = selectedRuns.first['fontSize'] as double?;
    for (final r in selectedRuns) {
      if (r['fontSize'] != firstValue) return (null, true); // karışık seçim
    }
    return (firstValue, false);
  }

  static int? getEffectiveColor(
    List? rawSpans,
    int textLength,
    int start,
    int end,
  ) => _getEffectiveValue(rawSpans, textLength, start, end, 'color') as int?;

  static dynamic _getEffectiveValue(
    List? rawSpans,
    int textLength,
    int rawStart,
    int rawEnd,
    String attr,
  ) {
    final spans = parse(rawSpans);
    final start = rawStart.clamp(0, textLength);
    final end = rawEnd.clamp(0, textLength);
    if (start >= end) return null; // seçim yok/geçersiz: belirli bir değer yok

    final runs = _buildRuns(spans, textLength, start, end);
    final selectedRuns = runs.where(
      (r) => (r['start'] as int) >= start && (r['end'] as int) <= end,
    );
    if (selectedRuns.isEmpty) return null;

    final firstValue = selectedRuns.first[attr];
    for (final r in selectedRuns) {
      if (r[attr] != firstValue) return null; // karışık seçim: tekil değer yok
    }
    return firstValue;
  }
}
