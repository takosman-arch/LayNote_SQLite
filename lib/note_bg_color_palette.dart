part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// NOT ARKA PLANI PALETİ (noteBgColorOptions / bgColorSwatch)
// note_list_note_dialog_mixin.dart'taki "Yazı Rengi" ikonundan hemen sonra
// eklenen palet ikonu tarafından kullanılır. O renk paletinden (textColor
// Options) BİLİNÇLİ OLARAK ayrı tutulur: burası notun TÜM arka planına
// uygulanacağından, üzerindeki metnin okunabilir kalması için canlı
// tonlar yerine soft/pastel tonlar seçildi.
//
// noteBgColor, span/seçim bazlı bir özellik DEĞİLDİR (RichTextSpans'a
// dokunmaz) — doğrudan not düzeyinde tek bir değerdir (int? renk kodu,
// null = varsayılan/kategori rengi).
// ════════════════════════════════════════════════════════════════════════
const noteBgColorOptions = <(String, int?)>[
  ('Varsayılan', null),
  ('Pembe', 0xFFFFE4EC),
  ('Kırmızı', 0xFFFFD6D6),
  ('Turuncu', 0xFFFFE3C2),
  ('Sarı', 0xFFFFF6C4),
  ('Yeşil', 0xFFDCF3D9),
  ('Mavi', 0xFFD6E9FA),
  ('Mor', 0xFFE7DCF5),
  ('Gri', 0xFFE6E6E6),
];

// Tekil bir arka plan renk dairesini çizer. colorSwatch (Yazı Rengi
// paletindeki) ile aynı görsel dilde ama iki farkla:
// - "seçili" durumu (selectedValue ile karşılaştırma) birincil renkle
//   vurgulanan bir çerçeve olarak gösterilir (Yazı Rengi paletinde seçili
//   durum gösterilmiyordu çünkü orada "aktif" kavramı imleç konumuna
//   göre değişken; burada tek bir sabit değer olduğu için göstermek
//   anlamlı ve kullanıcıya hangi rengin uygulı olduğunu net gösterir).
// - onSelect callback'i span'a değil doğrudan not state'ine yazar.
Widget bgColorSwatch(
  BuildContext ctx,
  int? colorValue,
  int? selectedValue,
  void Function(int? color) onSelect,
) {
  final isSelected = colorValue == selectedValue;
  return InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: () => onSelect(colorValue),
    child: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorValue != null ? Color(colorValue) : null,
        border: Border.all(
          color: isSelected
              ? Theme.of(ctx).colorScheme.primary
              : Theme.of(ctx).dividerColor,
          width: isSelected ? 2.5 : (colorValue == null ? 1.5 : 1),
        ),
      ),
      alignment: Alignment.center,
      child: colorValue == null
          ? const Icon(Icons.format_color_reset, size: 18)
          : null,
    ),
  );
}
