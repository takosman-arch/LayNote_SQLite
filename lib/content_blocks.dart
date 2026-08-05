part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// İÇERİK BLOKLARI (ContentBlocks)
// Not içeriği artık düz metin yerine, sırayla dizilmiş "bloklar"dan oluşur:
//   {"type": "text", "text": "..."}
//   {"type": "attachments", "ids": ["att1", "att2", ...]}
//   {"type": "calc_table", "rows": [{"label": "...", "value": "..."}, ...]}
//   {"type": "drawing", "strokes": [
//       {"color": <int argb>, "width": <double>, "points": [[x, y], ...]},
//       ...
//   ]}
// "drawing" bloğu vektör tabanlıdır: her el hareketi (stroke) renk, kalınlık
// ve nokta listesi olarak saklanır; ekranda bir CustomPainter ile çizilir.
// Böylece not tekrar açıldığında çizime kaldığı yerden devam edilebilir ve
// farklı ekran boyutlarında/yakınlaştırmada kalite kaybı olmaz (bkz.
// NoteDrawingCanvas, henüz eklenmedi — Stage 2).
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
    'calc_table',
    'drawing',
    'divider',
  ];

  // Checklist özelliği kaldırıldı. Eski notlarda hâlâ {"type": "checklist",
  // "items": [...]} bloğu olabilir; bunu ham JSON olarak ekrana dökmemek
  // (ya da tamamen kaybetmemek) için sade bir metin bloğuna çeviriyoruz —
  // her madde kendi satırı olur.
  static Map<String, dynamic> _migrateLegacyChecklistBlock(Map<String, dynamic> m) {
    final items = (m['items'] as List? ?? const []);
    final text = items
        .map((it) => ((it as Map)['text'] ?? '').toString())
        .where((t) => t.trim().isNotEmpty)
        .join('\n');
    return {'type': 'text', 'text': text, 'spans': <Map<String, dynamic>>[]};
  }

  // Sayıyı toplam satırında gösterirken tam sayıysa ondalık kısmı at,
  // değilse en fazla 2 ondalık basamak göster. Binlik basamaklar nokta
  // ile ayrılır, ondalık kısım virgülle gösterilir (ör. 1.234.567,5).
  static String formatCalcNumber(double value) {
    final isNegative = value < 0;
    final absValue = value.abs();
    String intPart;
    String? fracPart;
    if (absValue == absValue.roundToDouble()) {
      intPart = absValue.toInt().toString();
    } else {
      final fixed = absValue.toStringAsFixed(2);
      final dotIndex = fixed.indexOf('.');
      intPart = fixed.substring(0, dotIndex);
      fracPart = fixed.substring(dotIndex + 1);
    }
    final buffer = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) buffer.write('.');
      buffer.write(intPart[i]);
    }
    var result = buffer.toString();
    if (fracPart != null) result += ',$fracPart';
    return isNegative ? '-$result' : result;
  }

  // Bir hesap tablosu hücresindeki serbest metni sayıya çevirir; boş veya
  // geçersiz girişler toplama 0 olarak katılır (yok sayılır).
  //
  // Hem yeni (binlik ayracı noktalı, ondalık virgüllü, ör. "1.234,5") hem
  // de eski, ayraçsız veriyi ("1234.5" ya da "1234,5") doğru ayrıştırır:
  // - Hem virgül hem nokta varsa: nokta binlik ayracıdır, silinir; virgül
  //   ondalık ayracına çevrilir.
  // - Sadece virgül varsa: ondalık ayracıdır, noktaya çevrilir.
  // - Sadece nokta varsa: noktadan sonraki her grup tam olarak 3 haneyse
  //   (ör. "1.234" veya "12.345.678") binlik ayracı kabul edilip silinir;
  //   aksi halde (ör. eski veride "12.5") ondalık nokta olarak bırakılır.
  static double parseCalcValue(dynamic raw) {
    var text = (raw ?? '').toString().trim();
    if (text.isEmpty) return 0;
    final isNegative = text.startsWith('-');
    if (isNegative) text = text.substring(1);

    final hasComma = text.contains(',');
    final hasDot = text.contains('.');
    if (hasComma && hasDot) {
      text = text.replaceAll('.', '').replaceAll(',', '.');
    } else if (hasComma) {
      text = text.replaceAll(',', '.');
    } else if (hasDot) {
      final parts = text.split('.');
      final looksGrouped = parts.length > 1 &&
          parts.first.isNotEmpty &&
          parts.sublist(1).every((p) => p.length == 3);
      if (looksGrouped) {
        text = text.replaceAll('.', '');
      }
    }
    final value = double.tryParse(text) ?? 0;
    return isNegative ? -value : value;
  }

  static List<Map<String, dynamic>> parse(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return [
        {'type': 'text', 'text': '', 'spans': <Map<String, dynamic>>[]},
      ];
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List &&
          decoded.isNotEmpty &&
          decoded.every((e) =>
              e is Map &&
              (_knownTypes.contains(e['type']) || e['type'] == 'checklist'))) {
        return List<Map<String, dynamic>>.from(
          decoded.map((e) {
            var m = Map<String, dynamic>.from(e as Map);
            if (m['type'] == 'checklist') {
              m = _migrateLegacyChecklistBlock(m);
            }
            if (m['type'] == 'calc_table') {
              m['rows'] = (m['rows'] as List? ?? const [])
                  .map((r) => Map<String, dynamic>.from(r as Map))
                  .toList();
            }
            if (m['type'] == 'drawing') {
              m['strokes'] = (m['strokes'] as List? ?? const [])
                  .map((s) {
                    final stroke = Map<String, dynamic>.from(s as Map);
                    stroke['points'] = (stroke['points'] as List? ?? const [])
                        .map((pt) => List<num>.from(pt as List))
                        .toList();
                    return stroke;
                  })
                  .toList();
            }
            if (m['type'] == 'text') {
              m['spans'] = RichTextSpans.parse(m['spans']);
            }
            return m;
          }),
        );
      }
    } catch (_) {
      // JSON değil -> eski düz metin not.
    }
    return [
      {'type': 'text', 'text': raw, 'spans': <Map<String, dynamic>>[]},
    ];
  }

  static String serialize(List<Map<String, dynamic>> blocks) {
    final cleaned = blocks.where((b) {
      if (b['type'] == 'attachments') {
        return (b['ids'] as List?)?.isNotEmpty == true;
      }
      if (b['type'] == 'calc_table') {
        return (b['rows'] as List?)?.isNotEmpty == true;
      }
      if (b['type'] == 'drawing') {
        return (b['strokes'] as List?)?.isNotEmpty == true;
      }
      return true;
    }).map((b) {
      if (b['type'] == 'text') {
        final m = Map<String, dynamic>.from(b);
        m['spans'] = RichTextSpans.clean(b['spans'] as List?);
        return m;
      }
      return b;
    }).toList();
    if (cleaned.isEmpty) {
      cleaned.add({'type': 'text', 'text': '', 'spans': <Map<String, dynamic>>[]});
    }
    return jsonEncode(cleaned);
  }

  // Aramada, kopyalamada, paylaşmada ve önizlemede kullanılacak düz metin.
  static String plainText(String? raw) {
    final blocks = parse(raw);
    return blocks
        .where((b) => b['type'] == 'text' || b['type'] == 'calc_table')
        .map((b) {
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

  // Kart önizlemesinde (liste/ızgara görünümü) gösterilecek satır listesini
  // üretir. Blok sırası korunur: metin ve hesap tablosu blokları satır
  // satır (yeni satıra göre) düz metne çevrilir. Boş metin satırları
  // atlanır.
  static List<Map<String, dynamic>> previewLines(String? raw) {
    final blocks = parse(raw);
    final lines = <Map<String, dynamic>>[];
    for (final b in blocks) {
      if (b['type'] == 'text') {
        final text = (b['text'] ?? '').toString();
        for (final line in text.split('\n')) {
          if (line.trim().isEmpty) continue;
          lines.add({'checklist': false, 'text': line});
        }
      } else if (b['type'] == 'calc_table') {
        final rows = (b['rows'] as List? ?? const []);
        double total = 0;
        var any = false;
        for (final r in rows) {
          final row = r as Map;
          final label = (row['label'] ?? '').toString();
          final valueText = (row['value'] ?? '').toString();
          total += parseCalcValue(row['value']);
          if (label.trim().isNotEmpty || valueText.trim().isNotEmpty) {
            any = true;
            lines.add({'checklist': false, 'text': '$label: $valueText'});
          }
        }
        if (any) {
          lines.add({
            'checklist': false,
            'text': 'Toplam: ${formatCalcNumber(total)}',
          });
        }
      }
    }
    return lines;
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
      if (b['type'] == 'calc_table' &&
          (b['rows'] as List? ?? const []).any((r) {
            final row = r as Map;
            return (row['label'] ?? '').toString().trim().isNotEmpty ||
                (row['value'] ?? '').toString().trim().isNotEmpty;
          })) {
        return true;
      }
      if (b['type'] == 'drawing' &&
          (b['strokes'] as List?)?.isNotEmpty == true) {
        return true;
      }
      if (b['type'] == 'divider') {
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
        if (!RichTextSpans.listEquals(
          a['spans'] as List?,
          b['spans'] as List?,
        )) {
          return false;
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
      } else if (a['type'] == 'drawing') {
        final as_ = List<Map>.from(a['strokes'] ?? const []);
        final bs = List<Map>.from(b['strokes'] ?? const []);
        if (as_.length != bs.length) return false;
        for (int j = 0; j < as_.length; j++) {
          final sa = as_[j];
          final sb = bs[j];
          if ((sa['color'] ?? 0) != (sb['color'] ?? 0) ||
              (sa['width'] ?? 0) != (sb['width'] ?? 0)) {
            return false;
          }
          final pa = List<List>.from(
            (sa['points'] as List? ?? const []).map((p) => List.from(p)),
          );
          final pb = List<List>.from(
            (sb['points'] as List? ?? const []).map((p) => List.from(p)),
          );
          if (pa.length != pb.length) return false;
          for (int k = 0; k < pa.length; k++) {
            if (pa[k][0] != pb[k][0] || pa[k][1] != pb[k][1]) return false;
          }
        }
      } else if (a['type'] == 'divider') {
        // divider bloğunun ek alanı yok; tip eşitliği yeterli.
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

// Hesap tablosu tutar hücrelerinde yazarken canlı olarak binlik ayracı
// (nokta) ekleyen TextInputFormatter. Ondalık kısım için virgül kullanılır
// (ör. "1234" yazılınca "1.234" olur, "1234,5" -> "1.234,5"). İmleç her
// zaman metnin sonuna taşınır; hesap tablosu hücreleri kısa metinler
// içerdiğinden bu basit yaklaşım yeterli ve öngörülebilir bir davranış
// sağlıyor.
class CalcTableInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (text.isEmpty) return newValue;

    final isNegative = text.startsWith('-');
    if (isNegative) text = text.substring(1);

    // Bazı klavyelerde ondalık tuşu nokta ('.') gönderir. Kullanıcı henüz
    // virgül girmemişse ve az önce eklenen karakter nokta ise bunu ondalık
    // ayracı (virgül) kabul ediyoruz; böylece hem nokta hem virgül tuşuyla
    // ondalık girilebiliyor ve sonuç her zaman virgülle gösteriliyor.
    if (!text.contains(',') &&
        text.endsWith('.') &&
        text.length == oldValue.text.length + 1) {
      text = '${text.substring(0, text.length - 1)},';
    }

    // Sadece rakamlar ve tek bir virgül (ondalık ayracı) korunur; eski
    // binlik noktaları ve fazladan virgüller temizlenir.
    final commaIndex = text.indexOf(',');
    String intDigits;
    String? fracDigits;
    if (commaIndex >= 0) {
      intDigits = text
          .substring(0, commaIndex)
          .replaceAll(RegExp(r'[^0-9]'), '');
      fracDigits = text
          .substring(commaIndex + 1)
          .replaceAll(RegExp(r'[^0-9]'), '');
    } else {
      intDigits = text.replaceAll(RegExp(r'[^0-9]'), '');
    }

    final buffer = StringBuffer();
    for (int i = 0; i < intDigits.length; i++) {
      if (i > 0 && (intDigits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(intDigits[i]);
    }
    var result = buffer.toString();
    if (fracDigits != null) result += ',$fracDigits';
    if (result.isEmpty && !isNegative) return const TextEditingValue();
    if (isNegative) result = '-$result';

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

