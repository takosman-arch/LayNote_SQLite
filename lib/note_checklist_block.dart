part of 'main.dart';

/// Bir notun içeriğindeki 'checklist' bloğunu çizen widget.
///
/// NoteCalcTableBlock gibi saf sunumdan sorumludur: checkbox listesini
/// çizer, tıklanınca onToggle, sil butonuyla onRemove, Enter'da onAddItem
/// callback'lerini tetikler. State mantığı çağıran tarafa (NoteListNoteDialogMixin)
/// bırakılmıştır.
///
/// Ek davranış:
/// - Herhangi bir madde boşken Backspace'e basılırsa [onConvertItemToText]
///   tetiklenir; o madde checklist'ten çıkıp imleç aynı satırda kalacak
///   şekilde boş bir düz metin satırına dönüşür (kutucuk kalkar).
/// - Çarpı ikonuna basılırsa artık [onRemoveItem] tetiklenir; bu, maddeyi
///   HEMEN listeden çıkarmaz — [isItemRemoving] bu maddeyi "siliniyor"
///   işaretlemesi için çağıranın state'ini günceller, widget da kısa bir
///   soluklaşma+daralma animasyonu oynatır; animasyon bitince
///   [onRemoveAnimationComplete] tetiklenir ve gerçek kaldırma orada
///   yapılır (bkz. onRemoveItem/onRemoveAnimationComplete dokümanı).
class NoteChecklistBlock extends StatelessWidget {
  const NoteChecklistBlock({
    super.key,
    required this.blockIndex,
    required this.items,
    required this.controllers,
    required this.focusNodes,
    required this.fontSize,
    this.fontFamily,
    required this.textColor,
    required this.onToggle,
    required this.onTextChanged,
    required this.onAddItem,
    required this.onConvertItemToText,
    required this.onRemoveItem,
    required this.isItemRemoving,
    required this.onRemoveAnimationComplete,
    required this.onReorder,
  });

  /// Bu bloğun blocks listesindeki indeksi (yalnızca ValueKey için).
  final int blockIndex;

  /// Her eleman {"text": "...", "checked": bool} şeklindedir.
  final List<Map<String, dynamic>> items;

  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  final double fontSize;
  // Ayarlar > Kişiselleştirme > Yazı Tipi. null ise Flutter varsayılan
  // (sistem) fontuna düşer.
  final String? fontFamily;
  final Color? textColor;

  /// Bir maddenin checkbox'ına tıklandığında çağrılır.
  final void Function(int itemIndex) onToggle;

  /// Bir maddenin metin alanı değiştiğinde çağrılır.
  final void Function(int itemIndex, String value) onTextChanged;

  /// Metin alanında Enter'a basıldığında (yeni madde eklenmesi
  /// gerektiğinde) çağrılır.
  final void Function(int itemIndex) onAddItem;

  /// Bir madde boşken Backspace'e basıldığında çağrılır: madde
  /// checklist'ten çıkar, imleç aynı satırda kalacak şekilde boş bir düz
  /// metin satırına dönüşür.
  final void Function(int itemIndex) onConvertItemToText;

  /// Çarpı ikonuna basıldığında çağrılır: maddeyi HEMEN kaldırmaz, sadece
  /// çağıranın "siliniyor" state'ini işaretlemesini tetikler (bkz.
  /// isItemRemoving) — gerçek kaldırma, animasyon bitince
  /// onRemoveAnimationComplete ile yapılır.
  final void Function(int itemIndex) onRemoveItem;

  /// Bu maddenin şu an silinme animasyonunda olup olmadığını döndürür.
  /// true olduğunda satır soluklaşıp daralarak kaybolur.
  final bool Function(Map<String, dynamic> item) isItemRemoving;

  /// Silinme animasyonu (soluklaşma+daralma) tamamlanınca çağrılır —
  /// maddenin gerçek `items`/controller/focus listelerinden çıkarılması
  /// burada yapılmalıdır. İndeks yerine madde referansı (Map) verilir;
  /// çünkü animasyon süresince başka maddeler de eklenip çıkarılmış
  /// olabileceğinden çağıran taraf güncel indeksi kendisi bulmalıdır.
  final void Function(Map<String, dynamic> item) onRemoveAnimationComplete;

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
                _buildAnimatedItemRow(context, effectiveColor, j),
            ],
          ),
        ],
      ),
    );
  }

  // Silme animasyonu: madde "siliniyor" işaretliyken satır soluklaşarak
  // (AnimatedOpacity) ve daralarak (AnimatedSize + Align/heightFactor)
  // kaybolur. Alttaki maddeler ayrıca bir "taşınma" animasyonuna ihtiyaç
  // duymaz — bu satırın yüksekliği küçüldükçe, doğal düzen (layout)
  // akışı gereği kendiliğinden yukarı kayarlar.
  Widget _buildAnimatedItemRow(
    BuildContext context,
    Color? effectiveColor,
    int j,
  ) {
    final removing = isItemRemoving(items[j]);
    return AnimatedSize(
      // DÜZELTME (asıl kök sebep — klavye kapanıp titriyordu): bu key
      // eskiden POZİSYONA göreydi (ValueKey('..._item_$j')). Bir madde
      // silinince ondan sonraki maddeler bir pozisyon kayar, dolayısıyla
      // key'leri de değişirdi (ör. item_5 → item_4). Flutter eşleştirmeyi
      // key'e göre yaptığından bu durumu "aynı satır, yeni pozisyon"
      // olarak tanımıyor, o satırın TextField'ını (ve altındaki
      // EditableText / platform metin-giriş bağlantısını) komple yok
      // edip yeniden kuruyordu — klavyenin bir kapanıp açılması ve
      // titreme muhtemelen asıl buradan kaynaklanıyordu, herhangi bir
      // odak/focus koduyla ilgisiz. ObjectKey(items[j]) maddenin kendi
      // kimliğine (Map referansı) bağlı olduğundan, madde pozisyon
      // değiştirse bile Flutter aynı satırı/aynı TextField state'ini
      // tanıyor ve hiçbir şeyi yeniden kurmuyor.
      key: ObjectKey(items[j]),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: ClipRect(
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: removing ? 0.0 : 1.0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            opacity: removing ? 0.0 : 1.0,
            onEnd: () {
              if (removing) onRemoveAnimationComplete(items[j]);
            },
            child: Row(
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
                            ? appAccentColor.value
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
                            fontFamily: fontFamily,
                            decoration: items[j]['checked'] == true
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationColor: items[j]['checked'] == true
                                ? Colors.grey[700]
                                : effectiveColor?.withOpacity(0.75),
                            decorationStyle: TextDecorationStyle.solid,
                          ),
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.checklistItemHint,
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
                    // Maddeyi tamamen kaldır (dönüştürmez; animasyon
                    // bitince gerçek kaldırma yapılır — bkz. onRemoveItem
                    // dokümanı).
                    //
                    // DÜZELTME (klavye kapanıp titriyordu): asıl sebep
                    // onRemoveItem'daki odak taşıma mantığı değildi —
                    // IconButton, Material'ın standart davranışı gereği
                    // onPressed çağrılmadan HEMEN ÖNCE kendi üzerine
                    // (Focus.of(context).requestFocus(...) ile) odak
                    // alıyor. Bu, o an odaklı olan TextField'ı anında
                    // odaktan çıkarıp klavyeyi kapatıyordu; onRemoveItem
                    // içindeki requestFocus() ise bunun ARDINDAN, ayrı bir
                    // adımda geldiğinden native tarafta klavye bir kapanıp
                    // tekrar açılıyor (titreme + "kapanma" hissi) —
                    // ikisi Dart tarafında aynı frame'de olsa bile.
                    // canRequestFocus: false verilen bir FocusNode ile
                    // IconButton'ın kendi kendine odak almasını en baştan
                    // engelliyoruz; böylece TextField hiç odaktan çıkmıyor,
                    // onRemoveItem'daki requestFocus() de doğrudan (araya
                    // hiçbir şey girmeden) bir alandan diğerine geçiyor.
                    IconButton(
                      focusNode: FocusNode(
                        canRequestFocus: false,
                        skipTraversal: true,
                      ),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 18,
                      ),
                      onPressed: () => onRemoveItem(j),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
            ),
          ),
        ),
      ),
    );
  }
}
