part of 'main.dart';

// NOT: Bu dosya link tıklamayı (TapGestureRecognizer) ve link açmayı
// (launchUrl) kullanıyor. main.dart'ta şu iki import satırının bulunması
// gerekir (main.dart bu dosyanın "part of" bağlandığı yer olduğundan
// importlar oraya eklenmelidir, buraya değil):
//   import 'package:flutter/gestures.dart';
//   import 'package:url_launcher/url_launcher.dart';
// Ayrıca pubspec.yaml -> dependencies altına:
//   url_launcher: ^6.3.1
// eklenip `flutter pub get` çalıştırılmalıdır.

// Link olarak işaretlenmiş metnin rengi (Google Docs/Gmail'deki link
// mavisine yakın bir ton).
const Color _linkColor = Color(0xFF1A73E8);

// Vurgulanmış (highlight) metnin arka plan rengi (Google Docs/Gmail'deki
// sarı vurgu kalemine yakın bir ton). Metin rengine dokunmaz, sadece
// backgroundColor olarak uygulanır.
//
// NOT: Tek bir sabit renk hem açık hem koyu temada aynı anda iyi kontrast
// veremiyor — açık temada metin koyu (siyaha yakın), koyu temada metin
// açık (beyaza yakın) olduğundan, tek bir "orta açıklıkta" sarı iki
// durumdan birinde mutlaka okunaksız kalıyordu (koyu temada beyaz yazı
// açık sarının üstünde kayboluyordu). Bu yüzden iki ayrı ton tanımlanıp
// aşağıda buildTextSpan içinde Theme.of(context).brightness'a göre
// seçiliyor.
// Açık tema: klasik açık sarı fosforlu kalem tonu, üstüne koyu/siyah yazı
// gelir.
const Color _highlightColorLight = Color(0xFFFFF59D);
// Koyu tema: aynı amber ailesinden, belirgin ölçüde koyulaştırılmış bir
// ton — üstüne beyaz yazı geldiğinde yeterli kontrastı sağlar, yine de
// "vurgu kalemi" hissini (amber/sarı ton) korur.
const Color _highlightColorDark = Color(0xFF7A5B00);

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

  // ── Link (URL) span'ları için tıklama tanıyıcıları ──────────────────────
  // Bir span 'link' alanına sahipse, o aralığın TextSpan'ine bir
  // TapGestureRecognizer eklenir (tıklanınca tarayıcıda açılsın diye).
  // buildTextSpan HER ÇİZİMDE yeniden çağrıldığından, önceki çizimde
  // oluşturulan recognizer'lar burada tutulup her yeni çizimden önce
  // dispose edilir — aksi halde her tuş vuruşunda/rebuild'de eski
  // recognizer'lar hiç serbest bırakılmadan birikir (bellek sızıntısı).
  final List<TapGestureRecognizer> _linkRecognizers = [];

  void _disposeLinkRecognizers() {
    for (final r in _linkRecognizers) {
      r.dispose();
    }
    _linkRecognizers.clear();
  }

  @override
  void dispose() {
    _disposeLinkRecognizers();
    super.dispose();
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Link açılamadıysa (desteklenmeyen şema, tarayıcı yok vb.) sessizce
      // yok say — burada bir BuildContext olmadığından kullanıcıya
      // SnackBar gibi bir geri bildirim gösteremiyoruz.
    }
  }

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
    // O anki temaya göre uygulanacak highlight rengi. Ekran her yeniden
    // çizildiğinde (ör. tema değişince) buildTextSpan zaten yeniden
    // çağrılır, dolayısıyla bu her seferinde güncel kalır.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveHighlightColor =
        isDark ? _highlightColorDark : _highlightColorLight;
    // Bu çizimde yeniden oluşturulacak recognizer'lardan önce, bir ÖNCEKİ
    // çizimden kalanları serbest bırak (bkz. sınıf başındaki not).
    _disposeLinkRecognizers();
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
      bool highlight = false;
      double? fontSize;
      int? color;
      String? fontFamily;
      String? link;
      for (final s in spans) {
        final sStart = _clampIndex(s['start'] as num, text.length);
        final sEnd = _clampIndex(s['end'] as num, text.length);
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
        // Altı çizili ve üzeri çizili aynı anda AÇIK olabilir — bunlar
        // Flutter'da tek bir TextDecoration.underline/lineThrough
        // değeriyle değil, TextDecoration.combine([...]) ile birlikte
        // uygulanmalı, aksi halde ikisinden biri (son atanan) diğerinin
        // üzerine yazar ve kaybolur.
        // Link'ler görsel olarak her zaman altı çizili gösterilir —
        // 'underline' span verisine YAZILMAZ (o, kullanıcının ayrıca
        // açtığı/kapattığı ayrı bir özellik olarak kalır), sadece bu
        // çizimde ek olarak uygulanır.
        final showUnderline = underline || link != null;
        TextDecoration? decoration = style?.decoration;
        if (showUnderline || strikethrough) {
          final parts = <TextDecoration>[
            if (showUnderline) TextDecoration.underline,
            if (strikethrough) TextDecoration.lineThrough,
          ];
          decoration = TextDecoration.combine(parts);
        }
        // Link rengi de aynı şekilde: kullanıcı o aralığa ayrıca özel bir
        // renk atamadıysa (color == null) link mavisi kullanılır; özel
        // renk atanmışsa (nadir ama mümkün) kullanıcının seçimine saygı
        // gösterilir.
        final effectiveColor =
            color != null ? Color(color) : (link != null ? _linkColor : style?.color);
        partStyle = (style ?? const TextStyle()).copyWith(
          fontWeight: bold ? FontWeight.bold : style?.fontWeight,
          fontStyle: italic ? FontStyle.italic : style?.fontStyle,
          decoration: decoration,
          fontSize: fontSize ?? style?.fontSize,
          color: effectiveColor,
          fontFamily: fontFamily ?? style?.fontFamily,
          // Vurgu, metnin kendi rengine dokunmadan sadece arkasına sarı
          // bir bant ekler (Google Docs vurgu kalemiyle aynı görsel
          // davranış). Vurgulanmamış kısımda önceki backgroundColor
          // (varsa) korunur.
          backgroundColor:
              highlight ? effectiveHighlightColor : style?.backgroundColor,
        );
      }
      GestureRecognizer? recognizer;
      if (link != null) {
        final url = link;
        final rec = TapGestureRecognizer()..onTap = () => _openLink(url);
        _linkRecognizers.add(rec);
        recognizer = rec;
      }
      children.add(TextSpan(
        text: text.substring(start, end),
        style: partStyle,
        recognizer: recognizer,
      ));
    }

    return TextSpan(style: style, children: children);
  }
}
