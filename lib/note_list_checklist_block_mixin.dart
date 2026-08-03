part of 'main.dart';

// ignore_for_file: unused_element

/// _showNoteDialog içindeki içerik blokları döngüsünden çağrılan,
/// 'checklist' tipindeki bir bloğun (madde listesi) arayüzünü oluşturan
/// mixin. Kod, NoteListNoteDialogMixin içindeki dev _showNoteDialog
/// metodunu küçültmek için buraya taşındı.
mixin NoteListChecklistBlockMixin on State<NoteListScreen> {
  // ---- Diğer mixin'lerde tanımlı, burada kullanılan üyeler ----
  List<Map<String, dynamic>> get _notes;
  double get _globalFontSize;
  Color? get _textColor;

  Widget _buildChecklistContentBlock({
    required BuildContext context,
    required int blockIndex,
    required int? noteIndex,
    required Map<String, dynamic> block,
    required List<TextEditingController> itemCtrls,
    required List<FocusNode> itemFns,
    required VoidCallback pushUndoCheckpoint,
    required void Function(void Function()) setModalState,
    required void Function(String sessionKey, TextEditingController controller)
        noteTextEdited,
    // Zengin metin (kalın/italik/vb.) desteği: yeni bir madde Enter'la
    // eklendiğinde bu iki fabrika kullanılarak controller/focus node
    // kurulur (NoteListNoteDialogMixin'deki asıl controller/focus node'larla
    // BİREBİR AYNI kurulumu yapar — undo/odak/span mantığı tek bir yerde
    // kalır, burada tekrarlanmaz). shiftSpansForTextChange, madde metni
    // değiştiğinde span aralıklarını kaydırmak (ve varsa bekleyen
    // kalın/italik/vb. biçimi yeni yazılan karaktere uygulamak) için
    // kullanılır — text bloğuyla aynı jenerik fonksiyon.
    required TextEditingController Function(Map<String, dynamic> item)
        createItemController,
    required FocusNode Function(Map<String, dynamic> item) createItemFocusNode,
    required void Function(
      Map<String, dynamic> spansHolder,
      String oldText,
      String newText,
    ) shiftSpansForTextChange,
  }) {
    final i = blockIndex;
    final index = noteIndex;
    final items = List<Map<String, dynamic>>.from(block['items'] ?? const []);

    return Padding(
      key: ValueKey('blk_checklist_$i'),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ReorderableListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        buildDefaultDragHandles: false,
        onReorder: (oldIndex, newIndex) {
          pushUndoCheckpoint();
          setModalState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            final movedItem = items.removeAt(oldIndex);
            items.insert(newIndex, movedItem);
            block['items'] = items;
            if (oldIndex < itemCtrls.length) {
              final movedCtrl = itemCtrls.removeAt(oldIndex);
              itemCtrls.insert(newIndex, movedCtrl);
            }
            if (oldIndex < itemFns.length) {
              final movedFn = itemFns.removeAt(oldIndex);
              itemFns.insert(newIndex, movedFn);
            }
          });
        },
        children: [
          for (int j = 0; j < items.length; j++)
            Row(
              key: ValueKey(items[j]),
              children: [
                ReorderableDragStartListener(
                  index: j,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.drag_indicator,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
                Checkbox(
                  value: items[j]['checked'] as bool? ?? false,
                  activeColor: Colors.amber,
                  onChanged: (val) {
                    pushUndoCheckpoint();
                    setModalState(() {
                      items[j]['checked'] = val ?? false;
                      block['items'] = items;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    selectionWidthStyle: ui.BoxWidthStyle.tight,
                    controller: j < itemCtrls.length ? itemCtrls[j] : null,
                    focusNode: j < itemFns.length ? itemFns[j] : null,
                    textInputAction: TextInputAction.next,
                    // Enter'a basınca Flutter'ın TextInputAction.next için
                    // uyguladığı VARSAYILAN odak değiştirme davranışını devre
                    // dışı bırakıyoruz; odak yönetimini zaten onSubmitted
                    // içinde biz yapıyoruz. Aksi halde klavye önce (yanlış bir
                    // widget'a odaklanıldığı için) kapanıp hemen ardından
                    // bizim requestFocus() çağrımızla tekrar açılıyordu
                    // (aşağı inip tekrar yukarı çıkma).
                    onEditingComplete: () {},
                    textCapitalization: TextCapitalization.sentences,
                    contextMenuBuilder: buildCustomContextMenu,
                    selectionHeightStyle: ui.BoxHeightStyle.max,
                    style: TextStyle(
                      color: items[j]['checked'] == true
                          ? Colors.grey
                          : dNoteEffectiveTextColor(context, _textColor),
                      decoration: items[j]['checked'] == true
                          ? TextDecoration.lineThrough
                          : null,
                      fontSize: index != null
                          ? ((_notes[index]['fontSize'] as num?)
                                  ?.toDouble() ??
                              _globalFontSize)
                          : _globalFontSize,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Madde...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    onChanged: (val) {
                      noteTextEdited('blk_checklist_${i}_$j', itemCtrls[j]);
                      // Span kaydırma için bu tuş vuruşundan ÖNCEKİ metin
                      // (henüz üzerine yazılmadan önceki hali) gerekiyor —
                      // bkz. text bloğundaki aynı desen.
                      final oldTextForSpans =
                          (items[j]['text'] ?? '').toString();
                      shiftSpansForTextChange(items[j], oldTextForSpans, val);
                      items[j]['text'] = val;
                      block['items'] = items;
                    },
                    onSubmitted: (_) {
                      // DÜZELTME: Boş bırakılan bir maddede Enter'a
                      // basılınca artık yeni bir madde EKLENMİYOR — bunun
                      // yerine bu boş madde listeden silinip kontrol
                      // listesi tamamlanmış sayılıyor (klavye kapatılıyor).
                      // NoteListNoteDialogMixin'deki checklist TİPİ notlar
                      // için uygulanan AYNI davranış, burada checklist
                      // BLOĞU (karma içerikli notun içine gömülü) için de
                      // uygulanıyor.
                      final isEmpty =
                          (j < itemCtrls.length
                                  ? itemCtrls[j].text
                                  : (items[j]['text'] ?? '').toString())
                              .trim()
                              .isEmpty;
                      if (isEmpty) {
                        pushUndoCheckpoint();
                        FocusNode? removedFocusNode;
                        if (j < itemFns.length) {
                          removedFocusNode = itemFns[j];
                          if (removedFocusNode.hasFocus) {
                            removedFocusNode.unfocus();
                          }
                        }
                        setModalState(() {
                          // Liste tamamen boş kalmasın diye en az 1 madde
                          // her zaman korunur — tek madde varsa ve o da
                          // boşsa silinmez, sadece klavye kapatılır.
                          if (items.length > 1) {
                            items.removeAt(j);
                            block['items'] = items;
                            if (j < itemCtrls.length) {
                              itemCtrls.removeAt(j).dispose();
                            }
                            if (j < itemFns.length) {
                              itemFns.removeAt(j);
                            }
                          }
                        });
                        if (removedFocusNode != null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            removedFocusNode!.dispose();
                          });
                        }
                        return;
                      }
                      pushUndoCheckpoint();
                      setModalState(() {
                        final newIndex = j + 1;
                        final newItem = {
                          'text': '',
                          'checked': false,
                          'spans': <Map<String, dynamic>>[],
                        };
                        items.insert(newIndex, newItem);
                        block['items'] = items;
                        itemCtrls.insert(
                          newIndex,
                          createItemController(newItem),
                        );
                        itemFns.insert(
                          newIndex,
                          createItemFocusNode(newItem),
                        );
                      });
                      // Not: requestFocus'u Future.microtask yerine
                      // addPostFrameCallback ile çağırıyoruz. Microtask, yeni
                      // eklenen alanın widget ağacına henüz oturmadığı bir
                      // anda çalışabiliyor; bu da klavyenin bir an için
                      // odaksız kalıp kapanmasına ve hemen ardından tekrar
                      // açılmasına (aşağı inip tekrar yukarı kalkmasına) yol
                      // açıyordu.
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        itemFns[j + 1].requestFocus();
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                    size: 18,
                  ),
                  onPressed: () {
                    pushUndoCheckpoint();
                    // Aynı beyaz ekran sorunu: odaklı bir FocusNode'u önce
                    // odaktan çıkarmadan dispose etmeyelim.
                    FocusNode? removedFocusNode;
                    if (j < itemFns.length) {
                      removedFocusNode = itemFns[j];
                      if (removedFocusNode.hasFocus) {
                        removedFocusNode.unfocus();
                      }
                    }
                    setModalState(() {
                      items.removeAt(j);
                      block['items'] = items;
                      if (j < itemCtrls.length) {
                        itemCtrls.removeAt(j).dispose();
                      }
                      if (j < itemFns.length) {
                        itemFns.removeAt(j);
                      }
                    });
                    if (removedFocusNode != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        removedFocusNode!.dispose();
                      });
                    }
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
