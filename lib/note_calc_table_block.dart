part of 'main.dart';

/// Bir notun içeriğindeki 'calc_table' (hesap tablosu) bloğunu çizen widget.
///
/// Bu widget saf sunumdan sorumludur: satırları, etiket/tutar alanlarını ve
/// toplamı gösterir. Satır ekleme/silme, checkpoint (undo) ve controller/
/// focus node yönetimi gibi state mantığı kasıtlı olarak burada YOK — bunlar
/// [NoteListNoteDialogMixin]'deki _showNoteDialog içinde tutulan mutable
/// state'e (blocks, blockTableLabelControllers, vb.) ihtiyaç duyduğu için
/// çağıran taraftan callback olarak veriliyor. Böylece bu widget o state'e
/// hiç dokunmadan test edilebilir/yeniden kullanılabilir kalıyor.
class NoteCalcTableBlock extends StatelessWidget {
  const NoteCalcTableBlock({
    super.key,
    required this.blockIndex,
    required this.rows,
    required this.labelControllers,
    required this.valueControllers,
    required this.labelFocusNodes,
    required this.valueFocusNodes,
    required this.fontSize,
    this.fontFamily,
    required this.textColor,
    required this.onLabelChanged,
    required this.onValueChanged,
    required this.onSubmitRow,
    required this.onRemoveRow,
  });

  /// Bu bloğun blocks listesindeki indeksi (yalnızca ValueKey için).
  final int blockIndex;

  final List<Map<String, dynamic>> rows;
  final List<TextEditingController> labelControllers;
  final List<TextEditingController> valueControllers;
  final List<FocusNode> labelFocusNodes;
  final List<FocusNode> valueFocusNodes;

  final double fontSize;
  // Ayarlar > Kişiselleştirme > Yazı Tipi. null ise Flutter varsayılan
  // (sistem) fontuna düşer.
  final String? fontFamily;
  final Color? textColor;

  /// Bir satırın "Kalem" alanı değiştiğinde çağrılır.
  final void Function(int rowIndex, String value) onLabelChanged;

  /// Bir satırın "Tutar" alanı değiştiğinde çağrılır.
  final void Function(int rowIndex, String value) onValueChanged;

  /// Tutar alanında Enter/Next'e basıldığında (yeni satır eklenmesi
  /// gerektiğinde) çağrılır.
  final void Function(int rowIndex) onSubmitRow;

  /// Satırın çarpı ikonuyla silinmesi istendiğinde çağrılır.
  final void Function(int rowIndex) onRemoveRow;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveDividerColor = Color.lerp(
      dNoteBorderColor(context),
      isDark ? Colors.white : Colors.black,
      0.1,
    )!;
    double total = 0;
    for (final r in rows) {
      total += ContentBlocks.parseCalcValue(r['value']);
    }

    return Padding(
      key: ValueKey('blk_calctable_$blockIndex'),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int j = 0; j < rows.length; j++)
                Row(
                  key: ValueKey(rows[j]),
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        selectionWidthStyle: ui.BoxWidthStyle.tight,
                        controller: j < labelControllers.length
                            ? labelControllers[j]
                            : null,
                        focusNode: j < labelFocusNodes.length
                            ? labelFocusNodes[j]
                            : null,
                        textCapitalization: TextCapitalization.sentences,
                        contextMenuBuilder: buildCustomContextMenu,
                        selectionHeightStyle: ui.BoxHeightStyle.max,
                        textInputAction: TextInputAction.next,
                        // Bkz. aşağıdaki tutar alanı için açıklama:
                        // Flutter'ın TextInputAction.next varsayılan odak
                        // değiştirme davranışı devre dışı bırakılıyor, aksi
                        // halde Enter'a basınca klavye önce kapanıp hemen
                        // ardından tekrar açılıyordu.
                        onEditingComplete: () {},
                        style: TextStyle(
                          color: dNoteEffectiveTextColor(context, textColor),
                          fontSize: fontSize,
                          fontFamily: fontFamily,
                        ),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.calcTableItemHint,
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        onChanged: (val) => onLabelChanged(j, val),
                        onSubmitted: (_) {
                          if (j < valueFocusNodes.length) {
                            valueFocusNodes[j].requestFocus();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        selectionWidthStyle: ui.BoxWidthStyle.tight,
                        controller: j < valueControllers.length
                            ? valueControllers[j]
                            : null,
                        focusNode: j < valueFocusNodes.length
                            ? valueFocusNodes[j]
                            : null,
                        contextMenuBuilder: buildCustomContextMenu,
                        selectionHeightStyle: ui.BoxHeightStyle.max,
                        textAlign: TextAlign.right,
                        inputFormatters: [CalcTableInputFormatter()],
                        textInputAction: TextInputAction.next,
                        // Bkz. yukarıdaki madde alanı için açıklama:
                        // Flutter'ın TextInputAction.next varsayılan odak
                        // değiştirme davranışı devre dışı bırakılıyor, aksi
                        // halde Enter'a basınca klavye önce kapanıp hemen
                        // ardından tekrar açılıyordu.
                        onEditingComplete: () {},
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        style: TextStyle(
                          color: dNoteEffectiveTextColor(context, textColor),
                          fontSize: fontSize,
                          fontFamily: fontFamily,
                        ),
                        decoration: const InputDecoration(
                          hintText: '0',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        onChanged: (val) => onValueChanged(j, val),
                        onSubmitted: (_) => onSubmitRow(j),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 18,
                      ),
                      onPressed: () => onRemoveRow(j),
                    ),
                  ],
                ),
            ],
          ),
          Divider(color: effectiveDividerColor, thickness: 2),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  AppLocalizations.of(context)!.calcTableTotalRowLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: dNoteEffectiveTextColor(context, textColor),
                    fontSize: fontSize,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Text(
                  ContentBlocks.formatCalcNumber(total),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: dNoteEffectiveTextColor(context, textColor),
                    fontSize: fontSize,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ],
      ),
    );
  }
}
