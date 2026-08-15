part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// NOT ETİKETLERİ (TAGS) — Not düzenleme diyalogundaki "Etiketler" alt
// menüsü. Önceden note_list_note_dialog_mixin.dart içinde bir local
// closure olarak tanımlıydı; dialog mixin'ini gereksiz büyütmemek için
// ayrı bir dosyaya taşındı. Bağımsız (mixin üyelerine erişmeyen) top-level
// fonksiyonlar olduğu için taşınması dialog mixin'in davranışını değiştirmez.
// ════════════════════════════════════════════════════════════════════════

/// Etiket düzenleme sheet'inde otomatik tamamlama önerileri için: verilen
/// not listesindeki (genelde aktif `_notes`) şu ana kadar kullanılmış
/// etiketlerin, tekrarsız ve alfabetik sıralı listesini döndürür. Çöp
/// kutusundaki notlar çağıran taraf bilinçli olarak dahil etmez (silinmiş
/// bir nota özgü etiket önerilmemeli).
List<String> collectAllKnownTags(List<Map<String, dynamic>> notes) {
  final set = <String>{};
  for (final note in notes) {
    final raw = note['tags'];
    if (raw is List) {
      for (final t in raw) {
        final s = t.toString().trim();
        if (s.isNotEmpty) set.add(s);
      }
    }
  }
  final list = set.toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return list;
}

/// Verilen not listesinde [tag] etiketine (büyük/küçük harf duyarsız)
/// sahip kaç not olduğunu sayar. Etiket silme onayında "şu kadar nottan
/// kaldırılacak" uyarısını oluşturmak için kullanılır.
int countNotesWithTag(List<Map<String, dynamic>> notes, String tag) {
  final needle = tag.toLowerCase();
  var count = 0;
  for (final note in notes) {
    final raw = note['tags'];
    if (raw is! List) continue;
    if (raw.any((t) => t.toString().toLowerCase() == needle)) count++;
  }
  return count;
}

// ════════════════════════════════════════════════════════════════════════
// Etikete basılı tutunca (ör. arama modundaki etiket şeridinde) açılan
// "Yeniden Adlandır / Sil" seçenek sheet'i ve bunların kendi diyalogları.
// Bu üç fonksiyon da (showNoteTagsSheet gibi) bağımsız top-level'dır;
// gerçek veri mutasyonu (not listesindeki `tags` alanlarını güncelleme)
// çağıran tarafta (bkz. note_list_build_mixin.dart -> _handleTagLongPress)
// yapılır — burası sadece UI.
// ════════════════════════════════════════════════════════════════════════

/// Bir etiket üzerinde basılı tutulduğunda açılan kısa seçenek sheet'i.
/// [onRename] ve [onDelete] callback'leri sheet kapandıktan SONRA
/// çağrılır (Navigator.pop tamamlandıktan sonra), böylece ardından açılan
/// diyalog/onay penceresi kapanmakta olan sheet'le çakışmaz.
void showTagOptionsSheet(
  BuildContext context, {
  required String tag,
  required VoidCallback onRename,
  required VoidCallback onDelete,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: dNoteCardColor(context),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetCtx) {
      return SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Icon(Icons.sell_outlined, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      tag,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: dNoteTextColor(sheetCtx),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.edit_outlined,
                color: dNoteTextColor(sheetCtx),
              ),
              title: Text(
                'Yeniden Adlandır',
                style: TextStyle(color: dNoteTextColor(sheetCtx)),
              ),
              onTap: () {
                Navigator.pop(sheetCtx);
                onRename();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Sil', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(sheetCtx);
                onDelete();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}

/// Etiketi yeniden adlandırma diyaloğu. Onaylanırsa trim'lenmiş yeni ismi,
/// vazgeçilirse (ya da yeni isim boş/eskisiyle aynıysa) null döner.
Future<String?> showRenameTagDialog(
  BuildContext context,
  String currentTag,
) async {
  final controller = TextEditingController(text: currentTag);
  return showDialog<String>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: dNoteCardColor(ctx),
        title: Text(
          'Etiketi Yeniden Adlandır',
          style: TextStyle(color: dNoteTextColor(ctx)),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: TextStyle(color: dNoteTextColor(ctx)),
          decoration: const InputDecoration(
            hintText: 'Yeni etiket adı',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onSubmitted: (value) {
            final trimmed = value.trim();
            if (trimmed.isEmpty || trimmed == currentTag) {
              Navigator.pop(ctx);
            } else {
              Navigator.pop(ctx, trimmed);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: appAccentColor.value,
            ),
            onPressed: () {
              final trimmed = controller.text.trim();
              if (trimmed.isEmpty || trimmed == currentTag) {
                Navigator.pop(ctx);
              } else {
                Navigator.pop(ctx, trimmed);
              }
            },
            child: const Text(
              'Kaydet',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}

/// Etiket silme onay diyaloğu. [affectedCount] sıfırdan büyükse (etiket en
/// az bir notta kullanılıyorsa) bu notlardan kaç tanesinde etiketin
/// kaldırılacağı uyarısı gösterilir; sıfırsa sade bir onay metni yeterlidir.
/// Kullanıcı onaylarsa true, vazgeçerse false döner.
Future<bool> showDeleteTagConfirmDialog(
  BuildContext context, {
  required String tag,
  required int affectedCount,
}) async {
  final message = affectedCount > 0
      ? '"$tag" etiketi $affectedCount nottan kaldırılacak. Devam edilsin mi?'
      : '"$tag" etiketi silinsin mi?';
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: dNoteCardColor(ctx),
        title: Text(
          'Etiketi Sil',
          style: TextStyle(color: dNoteTextColor(ctx)),
        ),
        content: Text(
          message,
          style: TextStyle(color: dNoteTextColor(ctx).withOpacity(0.85)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sil', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

/// Not diyalogundaki üç nokta menüsünden açılan "Etiketler" alt sheet'i.
/// Mevcut etiketler silinebilir chip olarak gösterilir, altta yeni etiket
/// yazmak için bir TextField vardır; yazarken `allKnownTags` içinden
/// eşleşenler öneri olarak listelenir.
///
/// Sheet kendi iç state'ini (`StatefulBuilder` ile) yönetir; her ekle/sil
/// anında güncel etiket listesini [onChanged] callback'i ile çağırana
/// bildirir — böylece çağıran taraf (ör. ana diyalogdaki `tags` değişkeni)
/// `setModalState` gibi kendi state güncelleme mekanizmasıyla senkron
/// kalabilir.
void showNoteTagsSheet(
  BuildContext context, {
  required List<String> currentTags,
  required List<String> allKnownTags,
  required void Function(List<String> newTags) onChanged,
  // Bir etikete basılı tutulunca "Yeniden Adlandır / Sil" seçenekleri
  // sunulur (bkz. showTagOptionsSheet). Bu iki callback, arama şeridindeki
  // long-press davranışıyla AYNI global işlemi yapar — yani sadece bu
  // nottan değil, etiketin kullanıldığı TÜM notlardan yeniden adlandırır/
  // siler. Onay diyaloğu, sayım ve _notes mutasyonu tamamen çağıran
  // tarafın (bkz. note_list_build_mixin.dart -> _renameTagGlobally /
  // _deleteTagGlobally) sorumluluğundadır; burası sadece sonucu (yeni ad
  // ya da silindi/silinmedi) alıp bu notun yerel `tags` listesini ve
  // dolayısıyla `onChanged`'i buna göre günceller.
  required Future<String?> Function(String oldTag) onRenameTagGlobally,
  required Future<bool> Function(String tag) onDeleteTagGlobally,
}) {
  var tags = List<String>.from(currentTags);
  final tagInputController = TextEditingController();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: dNoteCardColor(context),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetCtx) {
      return StatefulBuilder(
        builder: (sheetCtx, setSheetState) {
          final query = tagInputController.text.trim().toLowerCase();
          // Sorgu boşken de mevcut (bu notta henüz olmayan) tüm bilinen
          // etiketler listelenir — kullanıcı yazmadan da dokunup
          // ekleyebilsin diye. Sorgu girildiğinde ise bu liste, yazılanla
          // eşleşenlere daraltılır (öneri/otomatik tamamlama davranışı).
          final availableTags = allKnownTags
              .where(
                (t) => !tags.any(
                  (existing) => existing.toLowerCase() == t.toLowerCase(),
                ),
              )
              .toList();
          final suggestions = query.isEmpty
              ? availableTags
              : availableTags
                    .where((t) => t.toLowerCase().contains(query))
                    .toList();

          void addTag(String raw) {
            final value = raw.trim();
            if (value.isEmpty) return;
            final alreadyExists = tags.any(
              (t) => t.toLowerCase() == value.toLowerCase(),
            );
            if (alreadyExists) {
              tagInputController.clear();
              setSheetState(() {});
              return;
            }
            tags = [...tags, value];
            onChanged(tags);
            tagInputController.clear();
            setSheetState(() {});
          }

          void removeTag(String value) {
            tags = tags.where((t) => t != value).toList();
            onChanged(tags);
            setSheetState(() {});
          }

          // Bir chip'e basılı tutulunca çağrılır: seçenek sheet'ini açar,
          // "Yeniden Adlandır" ya da "Sil" seçilirse global işlemi
          // tetikler ve sonucu bu notun yerel `tags` listesine yansıtır.
          void handleTagLongPress(String tag) {
            showTagOptionsSheet(
              sheetCtx,
              tag: tag,
              onRename: () async {
                final newTag = await onRenameTagGlobally(tag);
                if (newTag == null) return;
                final idx = tags.indexWhere(
                  (t) => t.toLowerCase() == tag.toLowerCase(),
                );
                if (idx == -1) return;
                final duplicateIdx = tags.indexWhere(
                  (t) => t.toLowerCase() == newTag.toLowerCase(),
                );
                if (duplicateIdx != -1 && duplicateIdx != idx) {
                  tags.removeAt(idx);
                } else {
                  tags[idx] = newTag;
                }
                onChanged(tags);
                setSheetState(() {});
              },
              onDelete: () async {
                final deleted = await onDeleteTagGlobally(tag);
                if (!deleted) return;
                tags = tags
                    .where((t) => t.toLowerCase() != tag.toLowerCase())
                    .toList();
                onChanged(tags);
                setSheetState(() {});
              },
            );
          }


          return SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Etiketler',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: dNoteTextColor(sheetCtx),
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags
                          .map(
                            (t) => GestureDetector(
                              onLongPress: () => handleTagLongPress(t),
                              child: Chip(
                                label: Text(t),
                                backgroundColor: appAccentColor.value
                                    .withOpacity(0.15),
                                labelStyle: TextStyle(
                                  color: dNoteTextColor(sheetCtx),
                                ),
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () => removeTag(t),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  else
                    Text(
                      'Bu notta henüz etiket yok.',
                      style: TextStyle(
                        color: dNoteTextColor(sheetCtx).withOpacity(0.6),
                      ),
                    ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: tagInputController,
                    autofocus: true,
                    style: TextStyle(color: dNoteTextColor(sheetCtx)),
                    decoration: InputDecoration(
                      hintText: 'Yeni etiket yaz...',
                      hintStyle: TextStyle(
                        color: dNoteTextColor(sheetCtx).withOpacity(0.5),
                      ),
                      isDense: true,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(sheetCtx).primaryColor,
                        ),
                        onPressed: () => addTag(tagInputController.text),
                      ),
                    ),
                    onChanged: (_) => setSheetState(() {}),
                    onSubmitted: addTag,
                  ),
                  if (suggestions.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Text(
                      'Mevcut etiketler',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: dNoteTextColor(sheetCtx).withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 160),
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: suggestions
                              .map(
                                (s) => ActionChip(
                                  label: Text(s),
                                  onPressed: () => addTag(s),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
