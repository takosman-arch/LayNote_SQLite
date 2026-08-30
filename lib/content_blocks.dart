part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// İÇERİK BLOKLARI (ContentBlocks)
// Not içeriği artık düz metin yerine, sırayla dizilmiş "bloklar"dan oluşur:
//   {"type": "text", "text": "..."}
//   {"type": "attachments", "ids": ["att1", "att2", ...]}
//   {"type": "calc_table", "rows": [{"label": "...", "value": "..."}, ...]}
//   {"type": "table", "rows": [["hücre", "hücre", ...], ["hücre", ...], ...]}
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
    'checklist',
    'table',
  ];

  // Tek bir tablo hücresini normalize eder: her zaman {"text": "...",
  // "spans": [...]} biçiminde bir Map döner. Eski notlarda hücre düz bir
  // String'ti (span'sız); bu durumda text o String, spans boş liste olur.
  // Yeni notlarda hücre zaten {"text":..., "spans":...} biçiminde bir Map
  // olabilir — bu durumda spans RichTextSpans.parse ile normalize edilir
  // (bozuk/eksik span verisi sessizce elenir, bkz. RichTextSpans.parse).
  static Map<String, dynamic> _normalizeTableCell(dynamic c) {
    if (c is Map) {
      return {
        'text': (c['text'] ?? '').toString(),
        'spans': RichTextSpans.parse(c['spans']),
      };
    }
    return {
      'text': (c ?? '').toString(),
      'spans': <Map<String, dynamic>>[],
    };
  }

  // 'table' bloğunun rows verisini normalize eder: her satırı
  // List<Map<String,dynamic>> (her hücre {"text":..., "spans":...})
  // olarak döner, böylece UI katmanı her zaman düzenli bir "satırlar
  // listesi -> zengin metin hücre listesi" yapısıyla çalışabilir.
  static List<List<Map<String, dynamic>>> _parseTableRows(dynamic raw) {
    final rows = raw as List? ?? const [];
    return rows.map((r) {
      final cells = r as List? ?? const [];
      return cells.map(_normalizeTableCell).toList();
    }).toList();
  }

  // 'table' bloğundaki tek bir hücreden düz metni okur. Hücre eski
  // notlarda düz bir String'ti; yeni notlarda ise zengin metin (kalın/
  // italik/altı çizili) taşıyabilmesi için {"text": "...", "spans": [...]}
  // biçiminde bir Map olarak saklanıyor (bkz. _tableCellSpans, ve 'text'
  // bloğundaki aynı desen). Bu metot her iki biçimi de tek bir düz
  // String'e indirger. note_widget_service.dart, note_screenshot_service.dart
  // ve pdf_export_service.dart bu metodu kullanır (aynı kütüphanenin
  // part'ı oldukları için private üyeye buradan erişebilirler).
  static String _tableCellText(dynamic c) {
    if (c is Map) {
      return (c['text'] ?? '').toString();
    }
    return (c ?? '').toString();
  }

  // Aynı hücrenin zengin metin span verisini döner (kalın/italik/altı
  // çizili aralıkları). Eski (düz String) hücrelerde span bilgisi hiç
  // yoktur, bu yüzden null döner; RichTextSpans.parse(null) boş bir liste
  // üretir ve hücre düz metin olarak çizilir.
  static dynamic _tableCellSpans(dynamic c) {
    if (c is Map) {
      return c['spans'];
    }
    return null;
  }

  // Checklist bloğunun items listesini normalize eder.
  // Her eleman {"text": "...", "checked": false} şeklinde döner.
  static List<Map<String, dynamic>> _parseChecklistItems(dynamic raw) {
    final list = raw as List? ?? const [];
    return list.map((it) {
      final m = Map<String, dynamic>.from(it as Map);
      return {
        'text': (m['text'] ?? '').toString(),
        'checked': m['checked'] == true,
      };
    }).toList();
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
              _knownTypes.contains(e['type']))) {
        return List<Map<String, dynamic>>.from(
          decoded.map((e) {
            var m = Map<String, dynamic>.from(e as Map);
            if (m['type'] == 'checklist') {
              m['items'] = _parseChecklistItems(m['items']);
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
            if (m['type'] == 'table') {
              m['rows'] = _parseTableRows(m['rows']);
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
      if (b['type'] == 'checklist') {
        return (b['items'] as List?)?.isNotEmpty == true;
      }
      if (b['type'] == 'table') {
        final rows = b['rows'] as List? ?? const [];
        return rows.isNotEmpty &&
            rows.any((r) => (r as List).any(
                (c) => _tableCellText(c).trim().isNotEmpty));
      }
      return true;
    }).map((b) {
      if (b['type'] == 'text') {
        final m = Map<String, dynamic>.from(b);
        m['spans'] = RichTextSpans.clean(b['spans'] as List?);
        return m;
      }
      if (b['type'] == 'table') {
        final m = Map<String, dynamic>.from(b);
        m['rows'] = (b['rows'] as List? ?? const []).map((r) {
          return (r as List).map((c) {
            final cell = _normalizeTableCell(c);
            cell['spans'] = RichTextSpans.clean(cell['spans'] as List?);
            return cell;
          }).toList();
        }).toList();
        return m;
      }
      return b;
    }).toList();
    if (cleaned.isEmpty) {
      cleaned.add({'type': 'text', 'text': '', 'spans': <Map<String, dynamic>>[]});
    }
    return jsonEncode(cleaned);
  }

  // Hesap tablosu toplam satırının etiketini üretir. Bu sınıftaki metotlar
  // static olduğundan (ve bazıları BuildContext olmayan yerlerden de
  // çağrılabildiğinden, bkz. plainText'in arama/kopyalama/paylaşma
  // kullanımı) etiketi doğrudan AppLocalizations ile üretemezler. Çağıran
  // taraf isterse [totalLabelBuilder] ile kendi (yerelleştirilmiş) etiketini
  // sağlayabilir; sağlamazsa geriye dönük uyumluluk için eski sabit metin
  // kullanılır.
  static String _defaultTotalLabel(String amount) => 'Toplam: $amount';

  // Aramada, kopyalamada, paylaşmada ve önizlemede kullanılacak düz metin.
  static String plainText(
    String? raw, {
    String Function(String amount)? totalLabelBuilder,
  }) {
    final buildTotalLabel = totalLabelBuilder ?? _defaultTotalLabel;
    final blocks = parse(raw);
    return blocks
        .where((b) =>
            b['type'] == 'text' ||
            b['type'] == 'calc_table' ||
            b['type'] == 'checklist' ||
            b['type'] == 'table')
        .map((b) {
          if (b['type'] == 'checklist') {
            final items = (b['items'] as List? ?? const []);
            return items
                .map((it) {
                  final m = it as Map;
                  final text = (m['text'] ?? '').toString();
                  return text;
                })
                .where((line) => line.trim().isNotEmpty)
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
            lines.add(buildTotalLabel(formatCalcNumber(total)));
            return lines.join('\n');
          }
          if (b['type'] == 'table') {
            final rows = (b['rows'] as List? ?? const []);
            // DÜZELTME (önizlemede boş hücrelerin yanında da " | " çizgisi
            // görünmesi): önceden TÜM hücreler (boş olanlar dahil) ' | '
            // ile birleştiriliyordu, bu da "Elma |  | 5" gibi boş hücre
            // etrafında da çizgi kalmasına yol açıyordu. Artık her satırda
            // ÖNCE boş hücreler filtreleniyor, SONRA sadece dolu hücreler
            // ' | ' ile birleştiriliyor — böylece çizgi yalnızca iki dolu
            // hücre arasında görünür.
            return rows
                .map((r) => (r as List)
                    .map((c) => _tableCellText(c))
                    .where((cell) => cell.trim().isNotEmpty)
                    .join(' | '))
                .where((line) => line.trim().isNotEmpty)
                .join('\n');
          }
          return (b['text'] ?? '').toString();
        })
        .join('\n')
        .trim();
  }

  // ── Önizlemede zengin metin (kalın/italik/renk/link/vurgu) ─────────────
  // plainText() ile BİREBİR AYNI metni üretir, ayrıca o metnin karakter
  // indekslerine göre kaydırılmış (offset'lenmiş) bir span listesi de
  // döndürür. Liste/ızgara kart önizlemesinde gövde metni artık düz Text
  // yerine RichText + buildStaticTextSpan ile çizilebilsin diye eklendi
  // (bkz. note_list_build_mixin.dart -> previewContentText/previewContentSpans).
  //
  // ÖNEMLİ: plainText() KENDİSİ DEĞİŞTİRİLMEDİ — arama/kopyalama/paylaşma
  // gibi ondan bağımsız her yer eskisi gibi çalışmaya devam eder. Burada
  // sadece plainText()'in izlediği AYNI adımlar (aynı blok filtresi, aynı
  // '\n' ile join, aynı .trim()) tekrarlanıyor; tek fark, 'text' tipi
  // bloklardan gelen span'ların start/end'inin, o bloğun birleşik metindeki
  // başlangıç konumuna göre kaydırılarak toplanması. calc_table ve
  // checklist blokları zaten span taşımıyor (bkz. RichTextSpans/
  // _parseChecklistItems), dolayısıyla onlar için sadece metin uzunluğu
  // kadar offset ilerletmek yeterli.
  static (String, List<Map<String, dynamic>>) previewTextWithSpans(
    String? raw, {
    String Function(String amount)? totalLabelBuilder,
  }) {
    final buildTotalLabel = totalLabelBuilder ?? _defaultTotalLabel;
    final blocks = parse(raw);
    final relevant = blocks
        .where((b) =>
            b['type'] == 'text' ||
            b['type'] == 'calc_table' ||
            b['type'] == 'checklist' ||
            b['type'] == 'table')
        .toList();

    final segments = <String>[];
    final allSpans = <Map<String, dynamic>>[];
    int offset = 0;

    for (final b in relevant) {
      String segmentText;
      if (b['type'] == 'checklist') {
        final items = (b['items'] as List? ?? const []);
        segmentText = items
            .map((it) => ((it as Map)['text'] ?? '').toString())
            .where((line) => line.trim().isNotEmpty)
            .join('\n');
      } else if (b['type'] == 'calc_table') {
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
        segmentText = lines.isEmpty
            ? ''
            : (lines..add(buildTotalLabel(formatCalcNumber(total)))).join('\n');
      } else if (b['type'] == 'table') {
        final rows = (b['rows'] as List? ?? const []);
        // DÜZELTME (önizlemede "text. spans" gibi bozuk metin görünmesi):
        // hücreler artık düz String değil {"text":...,"spans":...} Map'i
        // (bkz. _normalizeTableCell); (c ?? '').toString() bir Map
        // üzerinde çağrıldığında Map'in kendi toString() temsilini
        // (ör. "{text: ..., spans: []}") üretiyordu. plainText() ile
        // AYNI şekilde _tableCellText(c) kullanılmalı.
        // DÜZELTME (boş hücrelerin yanında da " | " çizgisi görünmesi):
        // plainText() ile AYNI mantık — önce boş hücreler filtrelenir,
        // sonra sadece dolu hücreler ' | ' ile birleştirilir.
        segmentText = rows
            .map((r) => (r as List)
                .map((c) => _tableCellText(c))
                .where((cell) => cell.trim().isNotEmpty)
                .join(' | '))
            .where((line) => line.trim().isNotEmpty)
            .join('\n');
      } else {
        // 'text' bloğu: hem metni hem de o bloğun kendi span'larını
        // (offset'lenerek) al.
        segmentText = (b['text'] ?? '').toString();
        final blockSpans = RichTextSpans.parse(b['spans']);
        for (final s in blockSpans) {
          final shifted = Map<String, dynamic>.from(s);
          shifted['start'] = (s['start'] as int) + offset;
          shifted['end'] = (s['end'] as int) + offset;
          allSpans.add(shifted);
        }
      }
      segments.add(segmentText);
      // plainText()'teki .join('\n') ile aynı ayraç: her segmentten sonra
      // 1 karakterlik ('\n') offset ilerletilir (join, elemanlar arasına
      // tam olarak bunu ekler).
      offset += segmentText.length + 1;
    }

    final combined = segments.join('\n');
    final trimmedText = combined.trim();

    // plainText() sonunda .trim() çağrılıyor; baştan atılan boşluk kadar
    // tüm span'ları geri kaydırmak gerekir, yoksa metin kaymışken span
    // indeksleri eski (kaymamış) konumu göstermeye devam eder.
    final leadingTrimmed = combined.length - combined.trimLeft().length;
    if (leadingTrimmed > 0) {
      for (final s in allSpans) {
        s['start'] = (s['start'] as int) - leadingTrimmed;
        s['end'] = (s['end'] as int) - leadingTrimmed;
      }
    }
    // Sondan atılan boşluk sadece metnin toplam uzunluğunu kısaltır;
    // güvenlik amacıyla, artık metin sınırının dışında kalan/taşan
    // span'lar burada temizlenir (buildStaticTextSpan zaten ayrıca
    // clamp uyguluyor, bu sadece ekstra güvenlik).
    allSpans.removeWhere((s) => (s['start'] as int) >= trimmedText.length);
    for (final s in allSpans) {
      if ((s['end'] as int) > trimmedText.length) {
        s['end'] = trimmedText.length;
      }
    }

    return (trimmedText, allSpans);
  }

  // Kart önizlemesinde (liste/ızgara görünümü) gösterilecek satır listesini
  // üretir. Blok sırası korunur: metin ve hesap tablosu blokları satır
  // satır (yeni satıra göre) düz metne çevrilir. Boş metin satırları
  // atlanır.
  static List<Map<String, dynamic>> previewLines(
    String? raw, {
    String Function(String amount)? totalLabelBuilder,
  }) {
    final buildTotalLabel = totalLabelBuilder ?? _defaultTotalLabel;
    final blocks = parse(raw);
    final lines = <Map<String, dynamic>>[];
    for (final b in blocks) {
      if (b['type'] == 'text') {
        final text = (b['text'] ?? '').toString();
        for (final line in text.split('\n')) {
          if (line.trim().isEmpty) continue;
          lines.add({'checklist': false, 'text': line});
        }
      } else if (b['type'] == 'checklist') {
        final items = (b['items'] as List? ?? const []);
        for (final it in items) {
          final m = it as Map;
          final text = (m['text'] ?? '').toString();
          if (text.trim().isEmpty) continue;
          lines.add({'checklist': true, 'checked': m['checked'] == true, 'text': text});
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
            'text': buildTotalLabel(formatCalcNumber(total)),
          });
        }
      } else if (b['type'] == 'table') {
        final rows = (b['rows'] as List? ?? const []);
        // DÜZELTME: aynı "text. spans" bozuk-metin hatası (bkz.
        // previewTextWithSpans yorumu) — hücre artık bir Map olduğundan
        // _tableCellText(c) ile okunmalı, (c ?? '').toString() değil.
        // DÜZELTME: boş hücrelerin yanında da " | " çizgisi görünmesi
        // (bkz. plainText() yorumu) — önce boş hücreler filtrelenir,
        // sonra sadece dolu hücreler ' | ' ile birleştirilir.
        for (final r in rows) {
          final cells = (r as List)
              .map((c) => _tableCellText(c))
              .where((cell) => cell.trim().isNotEmpty);
          final line = cells.join(' | ');
          if (line.trim().isEmpty) continue;
          lines.add({'checklist': false, 'text': line});
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
      if (b['type'] == 'checklist' &&
          (b['items'] as List? ?? const []).any((it) =>
              (it as Map)['text'].toString().trim().isNotEmpty)) {
        return true;
      }
      if (b['type'] == 'table' &&
          (b['rows'] as List? ?? const []).any((r) =>
              (r as List).any((c) => _tableCellText(c).trim().isNotEmpty))) {
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
      } else if (a['type'] == 'checklist') {
        final ai = List<Map>.from(a['items'] ?? const []);
        final bi = List<Map>.from(b['items'] ?? const []);
        if (ai.length != bi.length) return false;
        for (int j = 0; j < ai.length; j++) {
          if ((ai[j]['text'] ?? '') != (bi[j]['text'] ?? '') ||
              ai[j]['checked'] != bi[j]['checked']) {
            return false;
          }
        }
      } else if (a['type'] == 'table') {
        final ar = List<List>.from(
          (a['rows'] as List? ?? const []).map((r) => List.from(r as List)),
        );
        final br = List<List>.from(
          (b['rows'] as List? ?? const []).map((r) => List.from(r as List)),
        );
        if (ar.length != br.length) return false;
        for (int j = 0; j < ar.length; j++) {
          if (ar[j].length != br[j].length) return false;
          for (int k = 0; k < ar[j].length; k++) {
            if (_tableCellText(ar[j][k]) != _tableCellText(br[j][k])) {
              return false;
            }
            if (!RichTextSpans.listEquals(
              _tableCellSpans(ar[j][k]) as List?,
              _tableCellSpans(br[j][k]) as List?,
            )) {
              return false;
            }
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

