part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// ÖZEL METİN SEÇİM MENÜSÜ
// Sıra: Kes, Kopyala, Yapıştır, Tümünü Seç, Paylaş.
// Tüm butonlar Android'in native görünümünü korur (AdaptiveTextSelectionToolbar).
// ════════════════════════════════════════════════════════════════════════

Future<void> _shareSelectedText(BuildContext context, String text) async {
  if (text.trim().isEmpty) return;
  try {
    await SharePlus.instance.share(ShareParams(text: text));
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.textSelectionMenuShareFailedSnackbar),
        ),
      );
    }
  }
}

ContextMenuButtonItem? _findBtn(
  List<ContextMenuButtonItem> items,
  ContextMenuButtonType type,
) {
  for (final item in items) {
    if (item.type == type) return item;
  }
  return null;
}

Widget buildCustomContextMenu(
  BuildContext context,
  EditableTextState editableTextState,
) {
  final base = editableTextState.contextMenuButtonItems;
  final fullText = editableTextState.textEditingValue.text;
  final selection = editableTextState.textEditingValue.selection;
  final selectedText = selection.isValid && !selection.isCollapsed
      ? selection.textInside(fullText)
      : '';
  final hasSelection = selectedText.trim().isNotEmpty;

  // İstenen sıra: Kes, Kopyala, Yapıştır, Tümünü Seç, Paylaş
  final ordered = <ContextMenuButtonItem>[];

  final cut = _findBtn(base, ContextMenuButtonType.cut);
  final copy = _findBtn(base, ContextMenuButtonType.copy);
  final paste = _findBtn(base, ContextMenuButtonType.paste);
  final selectAll = _findBtn(base, ContextMenuButtonType.selectAll);

  if (cut != null) ordered.add(cut);
  if (copy != null) ordered.add(copy);
  if (paste != null) ordered.add(paste);
  if (selectAll != null) ordered.add(selectAll);

  // Paylaş butonu (yalnızca seçim varsa)
  ContextMenuButtonItem? shareBtn;
  if (hasSelection) {
    shareBtn = ContextMenuButtonItem(
      label: AppLocalizations.of(context)!.textSelectionMenuShareButton,
      onPressed: () {
        editableTextState.hideToolbar();
        _shareSelectedText(context, selectedText);
      },
    );
  }

  if (shareBtn != null) ordered.add(shareBtn);

  if (ordered.isEmpty) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  return AdaptiveTextSelectionToolbar.buttonItems(
    anchors: editableTextState.contextMenuAnchors,
    buttonItems: ordered,
  );
}

