part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// KAPAK RENGİ SEÇİCİ
// note_tags_sheet.dart ile aynı desen: dialog mixin'i büyütmemek için,
// "Kapak Rengi" diyaloğunun görsel kodu ve seçim mantığı buraya taşındı.
// NoteListNoteDialogMixin > showBgColorSheet() burada tanımlanan
// showNoteBgColorSheet()'i çağıran ince bir sarmalayıcıdan ibarettir;
// gerçek state (noteBgColor) hâlâ dialog mixin'in yerel değişkeninde
// tutulur, buraya sadece mevcut değer + onChanged callback'i geçirilir.
//
// Seçilen renk YALNIZCA notun liste/grid önizleme KARTININ rengini
// belirler (bkz. NoteListBuildMixin > baseNoteCardColor/baseGridCardColor);
// editörün kendi yazma alanı arka planına dokunmaz.
// ════════════════════════════════════════════════════════════════════════
void showNoteBgColorSheet(
  BuildContext context, {
  // Notun şu anki kapak rengi (ARGB int, null = varsayılan/kapak yok).
  required int? currentColor,
  // Renk seçenekleri: Ayarlar > Tema > Değişken Not Renkleri ile aynı
  // _categoryPalette geçirilir ki otomatik atanan renklerle görsel
  // olarak tutarlı kalsın.
  required List<Color> palette,
  // Kullanıcı bir renk seçtiğinde (ya da "Varsayılan"a bastığında, bu
  // durumda null ile) çağrılır. Dialog mixin bunu setModalState içine
  // sarıp noteBgColor'ı günceller.
  required ValueChanged<int?> onChanged,
}) {
  showDialog(
    context: context,
    builder: (dialogCtx) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.noteBgColorDialogTitle),
        content: SizedBox(
          width: double.maxFinite,
          child: Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              // "Varsayılan" (kapak rengi yok) seçeneği.
              GestureDetector(
                onTap: () {
                  onChanged(null);
                  Navigator.pop(dialogCtx);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: currentColor == null
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      width: currentColor == null ? 3 : 1,
                    ),
                  ),
                  child: Icon(
                    Icons.not_interested,
                    size: 18,
                    color: Colors.grey[500],
                  ),
                ),
              ),
              ...palette.map((color) {
                final int argb = color.toARGB32();
                final bool selected = currentColor == argb;
                return GestureDetector(
                  onTap: () {
                    onChanged(argb);
                    Navigator.pop(dialogCtx);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.6),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: selected
                        ? const Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 20,
                          )
                        : null,
                  ),
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}
