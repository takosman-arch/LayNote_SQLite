part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// RichBlockTextController
// Bir metin bloğunun 'spans' listesine (bkz. rich_text_spans.dart) bakarak
// metni kalın/italik parçalara ayırıp çizen TextEditingController.
//
// TextField widget'ının kendisi DEĞİŞMEZ — sadece controller olarak bunun
// bir örneği verilir. Flutter, imleç/seçim çizimi, IME kompozisyonu,
// kopyala/yapıştır gibi her şeyi normal TextEditingController gibi bu
// sınıftan da alır; tek override edilen şey, metnin EKRANDA nasıl
// boyandığını belirleyen buildTextSpan().
//
// spans verisi controller'ın kendi state'i DEĞİLDİR: getSpans callback'i
// ile dışarıdan (o anki blocks[i]['spans']) okunur. Böylece "kalın" butonuna
// basıldığında sadece blocks[i]['spans'] güncellenip ekran yeniden
// çizdirilir (requestEditorRebuild ile) — controller'ı yeniden kurmaya
// gerek kalmaz.
// ════════════════════════════════════════════════════════════════════════
class RichBlockTextController extends TextEditingController {
  RichBlockTextController({super.text, required this.getSpans});

  /// O anki text bloğunun spans listesini döndürür (start/end/bold/italic
  /// map'leri). Her çizimde çağrılır; RichTextSpans.parse zaten ucuz bir
  /// işlem olduğundan burada normalize edilmiş veri döndürülmesi önerilir:
  ///   getSpans: () => RichTextSpans.parse(blocks[i]['spans'])
  final List<Map<String, dynamic>> Function() getSpans;

  int _clampIndex(num raw, int max) {
    final v = raw.toInt();
    if (v < 0) return 0;
    if (v > max) return max;
    return v;
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    // DÜZELTME (bold/italic imleç taşınınca kayboluyordu): withComposing,
    // "şu an IME kompozisyonu var" değil "bu alan şu an focus'ta mı" demek
    // (EditableText içinde withComposing: !readOnly && _hasFocus olarak
    // geçiliyor). Klavyenin otomatik düzeltme/öneri motoru en son yazılan
    // kelimenin etrafına bir composing range koyduğunda (bu yalnızca
    // Çince/Japonca/Korece'ye özel değil, Latin klavyelerde de olur)
    // isComposingRangeValid true oluyor. Eskiden bu durumda TÜMÜYLE
    // super.buildTextSpan()'a düşülüyordu; bu da span'ları (kalın/italik)
    // yok sayıp metni düz gösteriyordu — kullanıcı bir yeri kalın yapıp
    // imleci taşıdığında (klavye yeni bir composing range açtığında)
    // kalınlığın kaybolmasının sebebi buydu. Artık composing aralığını
    // TAMAMEN görmezden gelmek yerine, span tabanlı bold/italic render'ı
    // her zaman uyguluyoruz; composing aralığına sadece EK olarak alt
    // çizgi (composing göstergesi) ekliyoruz.
    // DÜZELTME 2 (kalın yazının ortasına yazınca harfler büyük/küçük diye
    // dönüşümlü çıkıyordu): composing aralığını ayrıca alt çizgiyle
    // göstermek için burada composingStart/composingEnd de birer kırılma
    // noktası olarak ekleniyordu. Bu, kullanıcı kalın/italik bir span'ın
    // İÇİNDE ya da tam sınırında yazarken (composing aralığı imleçle
    // birlikte kaydığı için) her tek tuş vuruşunda span ağacının TAM
    // İMLEÇ NOKTASINDA yeniden dilimlenmesine yol açıyordu. Bazı Android
    // klavyeleri (özellikle Samsung klavyesi, bazı Gboard sürümleri)
    // otomatik büyük harf/shift durumunu render edilen span yapısından
    // türetiyor; bu yapı her karakterde tam imleç noktasında değişince
    // klavyenin shift-durumu takibi şaşırıp harfleri dönüşümlü büyük/küçük
    // yazmaya başlıyordu. Composing alt çizgisi salt kozmetik bir gösterge
    // olduğundan kaldırıldı; asıl düzeltme (composing sırasında bold/italic
    // hiç kaybolmasın) aşağıda spans her zaman uygulanarak korunuyor.
    final text = this.text;
    final spans = getSpans();
    if (spans.isEmpty || text.isEmpty) {
      return TextSpan(style: style, text: text);
    }

    // Metni, herhangi bir span'in başladığı/bittiği her noktada kesecek
    // "kırılma noktaları" çıkar; ardından her parçayı, o aralıkta etkili
    // olan bold/italic durumuna göre ayrı bir TextSpan olarak oluştur.
    final breakpoints = <int>{0, text.length};
    for (final s in spans) {
      breakpoints.add(_clampIndex(s['start'] as num, text.length));
      breakpoints.add(_clampIndex(s['end'] as num, text.length));
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
      double? fontSize;
      int? color;
      String? fontFamily;
      for (final s in spans) {
        final sStart = _clampIndex(s['start'] as num, text.length);
        final sEnd = _clampIndex(s['end'] as num, text.length);
        if (start >= sStart && end <= sEnd) {
          if (s['bold'] == true) bold = true;
          if (s['italic'] == true) italic = true;
          if (s['underline'] == true) underline = true;
          if (s['strikethrough'] == true) strikethrough = true;
          final sz = s['fontSize'];
          if (sz is num) fontSize = sz.toDouble();
          final c = s['color'];
          if (c is num) color = c.toInt();
          final ff = s['fontFamily'];
          if (ff is String) fontFamily = ff;
        }
      }
      TextStyle? partStyle = style;
      if (bold || italic || underline || strikethrough || fontSize != null ||
          color != null || fontFamily != null) {
        // Altı çizili ve üzeri çizili aynı anda AÇIK olabilir — bunlar
        // Flutter'da tek bir TextDecoration.underline/lineThrough
        // değeriyle değil, TextDecoration.combine([...]) ile birlikte
        // uygulanmalı, aksi halde ikisinden biri (son atanan) diğerinin
        // üzerine yazar ve kaybolur.
        TextDecoration? decoration = style?.decoration;
        if (underline || strikethrough) {
          final parts = <TextDecoration>[
            if (underline) TextDecoration.underline,
            if (strikethrough) TextDecoration.lineThrough,
          ];
          decoration = TextDecoration.combine(parts);
        }
        partStyle = (style ?? const TextStyle()).copyWith(
          fontWeight: bold ? FontWeight.bold : style?.fontWeight,
          fontStyle: italic ? FontStyle.italic : style?.fontStyle,
          decoration: decoration,
          fontSize: fontSize ?? style?.fontSize,
          color: color != null ? Color(color) : style?.color,
          fontFamily: fontFamily ?? style?.fontFamily,
        );
      }
      children.add(TextSpan(text: text.substring(start, end), style: partStyle));
    }

    return TextSpan(style: style, children: children);
  }
}
