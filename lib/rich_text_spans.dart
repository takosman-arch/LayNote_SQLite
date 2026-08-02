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
// - bold/italic/underline/strikethrough: AÇ/KAPA (boolean) özellikler —
//   toggle ile uygulanır (bkz. toggleBold/toggleItalic/toggleUnderline/
//   toggleStrikethrough).
// - fontSize/color/fontFamily: DEĞER bazlı özellikler — bir picker'dan
//   seçilen değer doğrudan atanır (bkz. setFontSize/setColor/
//   setFontFamily). null, "bu aralıkta özel bir değer yok, blok/tema
//   varsayılanını kullan" anlamına gelir.
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
        'fontSize': (e['fontSize'] as num?)?.toDouble(),
        'color': (e['color'] as num?)?.toInt(),
        'fontFamily': e['fontFamily'] is String ? e['fontFamily'] as String : null,
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
          sa['fontSize'] != sb['fontSize'] ||
          sa['color'] != sb['color'] ||
          sa['fontFamily'] != sb['fontFamily']) {
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
        'fontSize': s['fontSize'],
        'color': s['color'],
        'fontFamily': s['fontFamily'],
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
        'fontSize': s['fontSize'],
        'color': s['color'],
        'fontFamily': s['fontFamily'],
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
      double? fontSize;
      int? color;
      String? fontFamily;
      for (final s in spans) {
        final sStart = s['start'] as int;
        final sEnd = s['end'] as int;
        if (rStart >= sStart && rEnd <= sEnd) {
          if (s['bold'] == true) bold = true;
          if (s['italic'] == true) italic = true;
          if (s['underline'] == true) underline = true;
          if (s['strikethrough'] == true) strikethrough = true;
          if (s['fontSize'] != null) fontSize = s['fontSize'] as double;
          if (s['color'] != null) color = s['color'] as int;
          if (s['fontFamily'] != null) fontFamily = s['fontFamily'] as String;
        }
      }
      runs.add({
        'start': rStart,
        'end': rEnd,
        'bold': bold,
        'italic': italic,
        'underline': underline,
        'strikethrough': strikethrough,
        'fontSize': fontSize,
        'color': color,
        'fontFamily': fontFamily,
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
          r['fontSize'] == null &&
          r['color'] == null &&
          r['fontFamily'] == null;
      if (isDefault) continue;
      if (merged.isNotEmpty &&
          merged.last['end'] == r['start'] &&
          merged.last['bold'] == r['bold'] &&
          merged.last['italic'] == r['italic'] &&
          merged.last['underline'] == r['underline'] &&
          merged.last['strikethrough'] == r['strikethrough'] &&
          merged.last['fontSize'] == r['fontSize'] &&
          merged.last['color'] == r['color'] &&
          merged.last['fontFamily'] == r['fontFamily']) {
        merged.last['end'] = r['end'];
      } else {
        merged.add(Map<String, dynamic>.from(r));
      }
    }
    return merged;
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

    final selectedRuns = runs.where(
      (r) => (r['start'] as int) >= start && (r['end'] as int) <= end,
    );
    final allOn =
        selectedRuns.isNotEmpty && selectedRuns.every((r) => r[attr] == true);
    for (final r in runs) {
      if ((r['start'] as int) >= start && (r['end'] as int) <= end) {
        r[attr] = !allOn;
      }
    }
    return _mergeRuns(runs);
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
}
