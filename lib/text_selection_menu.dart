part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// ÖZEL METİN SEÇİM MENÜSÜ
// Sıra: Kes, Kopyala, Yapıştır, Tümünü Seç, Paylaş, Çevir.
// Metin Türkçe değilse "Çevir" en başa alınır.
// Tüm butonlar Android'in native görünümünü korur (AdaptiveTextSelectionToolbar).
// ════════════════════════════════════════════════════════════════════════

// Türkçe tespiti: score >= 3 olursa Türkçe sayılır.
// Türkçe karakter varsa +3 (güçlü sinyal), Türkçe kelime varsa +1.
// Saf İngilizce metin genellikle 0 alır.
bool _looksTurkish(String text) {
  final trimmed = text.trim();
  if (trimmed.length < 3) return true;
  final lower = trimmed.toLowerCase();
  int score = 0;
  for (final ch in ['ı', 'ğ', 'ş', 'ç', 'ö', 'ü']) {
    if (lower.contains(ch)) {
      score += 3;
      break;
    } // bir tane yeter, Türkçe harf kesin
  }
  for (final word in [
    'bir',
    've',
    'ile',
    'için',
    'değil',
    'var',
    'yok',
    'gibi',
    'ama',
    'çünkü',
    'daha',
    'evet',
    'hayır',
    'olan',
    'olarak',
  ]) {
    if (RegExp('\\b$word\\b').hasMatch(lower)) score += 1;
  }
  return score >= 3;
}

Future<void> _shareSelectedText(BuildContext context, String text) async {
  if (text.trim().isEmpty) return;
  try {
    await SharePlus.instance.share(ShareParams(text: text));
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Paylaşım başlatılamadı.')));
    }
  }
}

Future<void> _openInTranslate(BuildContext context, String text) async {
  if (text.trim().isEmpty) return;
  final uri = Uri.parse(
    'https://translate.google.com/?sl=auto&tl=tr&text=${Uri.encodeComponent(text)}&op=translate',
  );
  try {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Çeviri açılamadı.')));
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Çeviri açılamadı.')));
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

  // İstenen sıra: Kes, Kopyala, Yapıştır, Tümünü Seç, Paylaş, Çevir
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
      label: 'Paylaş',
      onPressed: () {
        editableTextState.hideToolbar();
        _shareSelectedText(context, selectedText);
      },
    );
  }

  // Çevir butonu (yalnızca seçim varsa)
  ContextMenuButtonItem? translateBtn;
  if (hasSelection) {
    translateBtn = ContextMenuButtonItem(
      label: 'Çevir',
      onPressed: () {
        editableTextState.hideToolbar();
        _openInTranslate(context, selectedText);
      },
    );
  }

  // Sıra: Çevir, Paylaş — metin Türkçe değilse Çevir en başa alınır
  if (translateBtn != null) {
    if (_looksTurkish(fullText)) {
      ordered.add(translateBtn);
      if (shareBtn != null) ordered.add(shareBtn);
    } else {
      ordered.insert(0, translateBtn);
      if (shareBtn != null) ordered.add(shareBtn);
    }
  } else {
    if (shareBtn != null) ordered.add(shareBtn);
  }

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

