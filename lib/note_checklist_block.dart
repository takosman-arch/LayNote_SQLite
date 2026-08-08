part of 'main.dart';

/// Bir notun içeriğindeki 'checklist' bloğunu çizen widget.
///
/// NoteCalcTableBlock gibi saf sunumdan sorumludur: checkbox listesini
/// çizer, tıklanınca onToggle, sil butonuyla onRemove, Enter'da onAddItem
/// callback'lerini tetikler. State mantığı çağıran tarafa (NoteListNoteDialogMixin)
/// bırakılmıştır.
///
/// Ek davranış: herhangi bir madde boşken Backspace'e basılırsa ya da
/// çarpı ikonuna basılırsa [onConvertItemToText] tetiklenir; o madde
/// checklist'ten çıkıp imleç aynı satırda kalacak şekilde boş bir düz
/// metin satırına dönüşür (kutucuk kalkar, varsa metin silinir).
class NoteChecklistBlock extends StatelessWidget {
  const NoteChecklistBlock({
    super.key,
    required this.blockIndex,
    required this.items,
    required this.controllers,
    required this.focusNodes,
    required this.fontSize,
    required this.textColor,
    required this.onToggle,
    required this.onTextChanged,
    required this.onAddItem,
    required this.onConvertItemToText,
    required this.onReorder,
  });

  /// Bu bloğun blocks listesindeki indeksi (yalnızca ValueKey için).
  final int blockIndex;

  /// Her eleman {"text": "...", "checked": bool} şeklindedir.
  final List<Map<String, dynamic>> items;

  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  final double fontSize;
  final Color? textColor;

  /// Bir maddenin checkbox'ına tıklandığında çağrılır.
  final void Function(int itemIndex) onToggle;

  /// Bir maddenin metin alanı değiştiğinde çağrılır.
  final void Function(int itemIndex, String value) onTextChanged;

  /// Metin alanında Enter'a basıldığında (yeni madde eklenmesi
  /// gerektiğinde) çağrılır.
  final void Function(int itemIndex) onAddItem;

  /// Bir madde boşken Backspace'e basıldığında ya da çarpı ikonuyla
  /// dönüştürme istendiğinde çağrılır: madde checklist'ten çıkar, imleç
  /// aynı satırda kalacak şekilde boş bir düz metin satırına dönüşür.
  final void Function(int itemIndex) onConvertItemToText;

  /// Sürükleme tutamacıyla bir madde başka bir konuma taşındığında
  /// çağrılır. [oldIndex] ve [newIndex], ReorderableListView'ın standart
  /// semantiğiyle verilir (newIndex, öğe eski listeden çıkarılmadan
  /// ÖNCEKİ hedef konumu ifade eder — çağıran taraf gerekirse kendi
  /// düzeltmesini yapar).
  final void Function(int oldIndex, int newIndex) onReorder;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = dNoteEffectiveTextColor(context, textColor);

    return Padding(
      key: ValueKey('blk_checklist_$blockIndex'),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Madde listesi — bloğu sil butonu ilk madde satırının sonunda
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            proxyDecorator: (child, index, animation) => Material(
              color: Colors.transparent,
              child: child,
            ),
            onReorder: onReorder,
            children: [
              for (int j = 0; j < items.length; j++)
                Row(
                  key: ValueKey('checklist_${blockIndex}_item_$j'),
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Sürükleme tutamacı — satırı yeniden sıralamak için.
                    ReorderableDragStartListener(
                      index: j,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.drag_indicator_rounded,
                          color: Colors.grey[400],
                          size: fontSize + 4,
                        ),
                      ),
                    ),
                    // Checkbox
                    GestureDetector(
                      onTap: () => onToggle(j),
                      child: Icon(
                        items[j]['checked'] == true
                            ? Icons.check_box_rounded
                            : Icons.check_box_outline_blank_rounded,
                        color: items[j]['checked'] == true
                            ? Colors.amber
                            : Colors.grey[400],
                        size: fontSize + 6,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Metin alanı — madde (hangi sırada olursa olsun)
                    // boşken Backspace algılanırsa kutucuk kalkar ve
                    // satır düz metne dönüşür (imleç aynı satırda kalır).
                    Expanded(
                      child: KeyboardListener(
                        // canRequestFocus: false → klavye odağını çalmaz,
                        // yalnızca olayları dinler.
                        focusNode: FocusNode(canRequestFocus: false),
                        onKeyEvent: (event) {
                          if (event is KeyDownEvent &&
                              event.logicalKey ==
                                  LogicalKeyboardKey.backspace &&
                              j < controllers.length &&
                              controllers[j].text.isEmpty) {
                            onConvertItemToText(j);
                          }
                        },
                        child: TextField(
                          selectionWidthStyle: ui.BoxWidthStyle.tight,
                          controller:
                              j < controllers.length ? controllers[j] : null,
                          focusNode:
                              j < focusNodes.length ? focusNodes[j] : null,
                          textCapitalization: TextCapitalization.sentences,
                          contextMenuBuilder: buildCustomContextMenu,
                          selectionHeightStyle: ui.BoxHeightStyle.max,
                          textInputAction: TextInputAction.next,
                          // Flutter'ın varsayılan odak değiştirme davranışını
                          // devre dışı bırakıyoruz; aksi halde Enter'da klavye
                          // kapanıp yeniden açılıyor.
                          onEditingComplete: () {},
                          style: TextStyle(
                            color: items[j]['checked'] == true
                                ? effectiveColor?.withOpacity(0.5)
                                : effectiveColor,
                            fontSize: fontSize,
                            decoration: items[j]['checked'] == true
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationColor: items[j]['checked'] == true
                                ? Colors.grey[700]
                                : effectiveColor?.withOpacity(0.75),
                            decorationStyle: TextDecorationStyle.solid,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Madde ekle...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 6),
                          ),
                          onChanged: (val) => onTextChanged(j, val),
                          onSubmitted: (_) => onAddItem(j),
                        ),
                      ),
                    ),
                    // Maddeyi düz metne dönüştür (kutucuk kalkar, varsa
                    // metin silinir, imleç aynı satırda kalır).
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 18,
                      ),
                      onPressed: () => onConvertItemToText(j),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
