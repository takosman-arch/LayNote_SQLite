part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// İÇERİK BLOKLARI (ContentBlocks)
// Not içeriği artık düz metin yerine, sırayla dizilmiş "bloklar"dan oluşur:
//   {"type": "text", "text": "..."}
//   {"type": "attachments", "ids": ["att1", "att2", ...]}
//   {"type": "checklist", "items": [{"text": "...", "checked": false}, ...]}
//   {"type": "calc_table", "rows": [{"label": "...", "value": "..."}, ...]}
// Böylece kullanıcı imlecin olduğu yere fotoğraf/belge, bir kontrol listesi
// veya toplamı otomatik hesaplanan bir hesap tablosu ekleyebilir, bunların
// altına/üstüne yazı yazabilir. Eski (düz metin) notlarla geriye dönük
// uyumluluk korunur: içerik JSON blok listesi olarak çözümlenemezse, tüm
// içerik tek bir metin bloğu olarak kabul edilir.
// ════════════════════════════════════════════════════════════════════════
class ContentBlocks {
  static const List<String> _knownTypes = [
    'text',
    'attachments',
    'checklist',
    'calc_table',
  ];

  // Sayıyı toplam satırında gösterirken tam sayıysa ondalık kısmı at,
  // değilse en fazla 2 ondalık basamak göster.
  static String formatCalcNumber(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }

  // Bir hesap tablosu hücresindeki serbest metni sayıya çevirir; boş veya
  // geçersiz girişler toplama 0 olarak katılır (yok sayılır).
  static double parseCalcValue(dynamic raw) {
    final text = (raw ?? '').toString().trim().replaceAll(',', '.');
    if (text.isEmpty) return 0;
    return double.tryParse(text) ?? 0;
  }

  static List<Map<String, dynamic>> parse(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return [
        {'type': 'text', 'text': ''},
      ];
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List &&
          decoded.isNotEmpty &&
          decoded.every((e) => e is Map && _knownTypes.contains(e['type']))) {
        return List<Map<String, dynamic>>.from(
          decoded.map((e) {
            final m = Map<String, dynamic>.from(e as Map);
            if (m['type'] == 'checklist') {
              m['items'] = (m['items'] as List? ?? const [])
                  .map((it) => Map<String, dynamic>.from(it as Map))
                  .toList();
            }
            if (m['type'] == 'calc_table') {
              m['rows'] = (m['rows'] as List? ?? const [])
                  .map((r) => Map<String, dynamic>.from(r as Map))
                  .toList();
            }
            return m;
          }),
        );
      }
    } catch (_) {
      // JSON değil -> eski düz metin not.
    }
    return [
      {'type': 'text', 'text': raw},
    ];
  }

  static String serialize(List<Map<String, dynamic>> blocks) {
    final cleaned = blocks.where((b) {
      if (b['type'] == 'attachments') {
        return (b['ids'] as List?)?.isNotEmpty == true;
      }
      if (b['type'] == 'checklist') {
        return (b['items'] as List?)?.isNotEmpty == true;
      }
      if (b['type'] == 'calc_table') {
        return (b['rows'] as List?)?.isNotEmpty == true;
      }
      return true;
    }).toList();
    if (cleaned.isEmpty) {
      cleaned.add({'type': 'text', 'text': ''});
    }
    return jsonEncode(cleaned);
  }

  // Aramada, kopyalamada, paylaşmada ve önizlemede kullanılacak düz metin.
  static String plainText(String? raw) {
    final blocks = parse(raw);
    return blocks
        .where((b) =>
            b['type'] == 'text' ||
            b['type'] == 'checklist' ||
            b['type'] == 'calc_table')
        .map((b) {
          if (b['type'] == 'checklist') {
            return (b['items'] as List? ?? const [])
                .map((it) => ((it as Map)['text'] ?? '').toString())
                .where((t) => t.trim().isNotEmpty)
                .join('\n');
          }
          if (b['type'] == 'calc_table') {
            final rows = (b['rows'] as List? ?? const []);
            double total = 0;
            final lines = <String>[];
            for (final r in rows) {
              final row = r as Map;
              final label = (row['label'] ?? '').toString();
              final valueText = (row['value'] ?? '').toString();
              total += parseCalcValue(row['value']);
              if (label.trim().isNotEmpty || valueText.trim().isNotEmpty) {
                lines.add('$label: $valueText');
              }
            }
            if (lines.isEmpty) return '';
            lines.add('Toplam: ${formatCalcNumber(total)}');
            return lines.join('\n');
          }
          return (b['text'] ?? '').toString();
        })
        .join('\n')
        .trim();
  }

  static bool hasAnyContent(List<Map<String, dynamic>> blocks) {
    for (final b in blocks) {
      if (b['type'] == 'text' &&
          ((b['text'] ?? '').toString().trim().isNotEmpty)) {
        return true;
      }
      if (b['type'] == 'attachments' &&
          ((b['ids'] as List?)?.isNotEmpty ?? false)) {
        return true;
      }
      if (b['type'] == 'checklist' &&
          (b['items'] as List? ?? const []).any(
            (it) => ((it as Map)['text'] ?? '').toString().trim().isNotEmpty,
          )) {
        return true;
      }
      if (b['type'] == 'calc_table' &&
          (b['rows'] as List? ?? const []).any((r) {
            final row = r as Map;
            return (row['label'] ?? '').toString().trim().isNotEmpty ||
                (row['value'] ?? '').toString().trim().isNotEmpty;
          })) {
        return true;
      }
    }
    return false;
  }

  static bool equalsStoredContent(
    List<Map<String, dynamic>> blocks,
    String? rawOldContent,
  ) {
    final oldBlocks = parse(rawOldContent);
    if (oldBlocks.length != blocks.length) return false;
    for (int i = 0; i < blocks.length; i++) {
      final a = oldBlocks[i];
      final b = blocks[i];
      if (a['type'] != b['type']) return false;
      if (a['type'] == 'text') {
        if ((a['text'] ?? '') != (b['text'] ?? '')) return false;
      } else if (a['type'] == 'checklist') {
        final ai = List<Map>.from(a['items'] ?? const []);
        final bi = List<Map>.from(b['items'] ?? const []);
        if (ai.length != bi.length) return false;
        for (int j = 0; j < ai.length; j++) {
          if ((ai[j]['text'] ?? '') != (bi[j]['text'] ?? '') ||
              (ai[j]['checked'] ?? false) != (bi[j]['checked'] ?? false)) {
            return false;
          }
        }
      } else if (a['type'] == 'calc_table') {
        final ar = List<Map>.from(a['rows'] ?? const []);
        final br = List<Map>.from(b['rows'] ?? const []);
        if (ar.length != br.length) return false;
        for (int j = 0; j < ar.length; j++) {
          if ((ar[j]['label'] ?? '') != (br[j]['label'] ?? '') ||
              (ar[j]['value'] ?? '') != (br[j]['value'] ?? '')) {
            return false;
          }
        }
      } else {
        final ai = List.from(a['ids'] ?? const []);
        final bi = List.from(b['ids'] ?? const []);
        if (ai.length != bi.length) return false;
        for (int j = 0; j < ai.length; j++) {
          if (ai[j] != bi[j]) return false;
        }
      }
    }
    return true;
  }
}

