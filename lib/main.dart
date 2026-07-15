import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

// ════════════════════════════════════════════════════════════════════════
// SQLITE VERİ TABANI KATMANI
// Notlar, çöp kutusu, kategoriler ve ayarlar artık SharedPreferences yerine
// yerel bir SQLite veritabanında (dnote.db) tutulur.
// Üst katmandaki (_NoteListScreenState) _notes / _deletedNotes / _categories
// gibi değişkenler AYNI ŞEKİLDE bellekte List/Map olarak kullanılmaya devam
// eder; sadece _loadData()/_saveData() artık DBHelper üzerinden çalışır.
// ════════════════════════════════════════════════════════════════════════
class DBHelper {
  DBHelper._internal();
  static final DBHelper instance = DBHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbDir = await getDatabasesPath();
    final path = p.join(dbDir, 'dnote.db');
    return openDatabase(
      path,
      version: 3,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // v1 -> v2: dosya/görsel ekleme özelliği için attachments sütunu.
          await db.execute('ALTER TABLE notes ADD COLUMN attachments TEXT');
          await db.execute(
            'ALTER TABLE deleted_notes ADD COLUMN attachments TEXT',
          );
        }
        if (oldVersion < 3) {
          // v2 -> v3: hatırlatıcı özelliği için reminderDate sütunu.
          await db.execute('ALTER TABLE notes ADD COLUMN reminderDate TEXT');
          await db.execute(
            'ALTER TABLE deleted_notes ADD COLUMN reminderDate TEXT',
          );
        }
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id TEXT PRIMARY KEY,
            title TEXT,
            content TEXT,
            date TEXT,
            createdDate TEXT,
            modifiedDate TEXT,
            category TEXT,
            color TEXT,
            type TEXT,
            fontSize REAL,
            checkItems TEXT,
            attachments TEXT,
            reminderDate TEXT,
            isLocked INTEGER NOT NULL DEFAULT 0,
            isArchived INTEGER NOT NULL DEFAULT 0,
            isFavorite INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE deleted_notes (
            id TEXT PRIMARY KEY,
            title TEXT,
            content TEXT,
            date TEXT,
            createdDate TEXT,
            modifiedDate TEXT,
            category TEXT,
            color TEXT,
            type TEXT,
            fontSize REAL,
            checkItems TEXT,
            attachments TEXT,
            reminderDate TEXT,
            isLocked INTEGER NOT NULL DEFAULT 0,
            isArchived INTEGER NOT NULL DEFAULT 0,
            isFavorite INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE categories (
            name TEXT PRIMARY KEY,
            color TEXT,
            isLocked INTEGER NOT NULL DEFAULT 0,
            sortOrder INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE settings (
            key TEXT PRIMARY KEY,
            value TEXT
          )
        ''');
      },
    );
  }

  // ── Not <-> satır dönüşümleri ─────────────────────────────────────────
  Map<String, dynamic> _noteToRow(Map<String, dynamic> note) {
    return {
      'id': note['id']?.toString(),
      'title': note['title']?.toString(),
      'content': note['content']?.toString(),
      'date': note['date']?.toString(),
      'createdDate': note['createdDate']?.toString(),
      'modifiedDate': note['modifiedDate']?.toString(),
      'category': note['category'],
      'color': note['color']?.toString(),
      'type': note['type']?.toString(),
      'fontSize': (note['fontSize'] as num?)?.toDouble(),
      'checkItems': note['checkItems'] != null
          ? jsonEncode(note['checkItems'])
          : null,
      'attachments': (note['attachments'] != null && (note['attachments'] as List).isNotEmpty)
          ? jsonEncode(note['attachments'])
          : null,
      'reminderDate': note['reminderDate']?.toString(),
      'isLocked': (note['isLocked'] == true) ? 1 : 0,
      'isArchived': (note['isArchived'] == true) ? 1 : 0,
      'isFavorite': (note['isFavorite'] == true) ? 1 : 0,
    };
  }

  Map<String, dynamic> _rowToNote(Map<String, dynamic> row) {
    return {
      'id': row['id'],
      'title': row['title'],
      'content': row['content'],
      'date': row['date'],
      'createdDate': row['createdDate'],
      'modifiedDate': row['modifiedDate'],
      'category': row['category'],
      'color': row['color'],
      'type': row['type'],
      if (row['fontSize'] != null) 'fontSize': row['fontSize'],
      if (row['checkItems'] != null)
        'checkItems': jsonDecode(row['checkItems'] as String),
      if (row['attachments'] != null)
        'attachments': jsonDecode(row['attachments'] as String),
      if (row['reminderDate'] != null) 'reminderDate': row['reminderDate'],
      'isLocked': row['isLocked'] == 1,
      'isArchived': row['isArchived'] == 1,
      'isFavorite': row['isFavorite'] == 1,
    };
  }

  // ── Notlar ─────────────────────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;
    final rows = await db.query('notes');
    return rows.map(_rowToNote).toList();
  }

  Future<List<Map<String, dynamic>>> getDeletedNotes() async {
    final db = await database;
    final rows = await db.query('deleted_notes');
    return rows.map(_rowToNote).toList();
  }

  Future<void> replaceNotes(List<Map<String, dynamic>> notes) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('notes');
      final batch = txn.batch();
      for (final n in notes) {
        batch.insert(
          'notes',
          _noteToRow(n),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  Future<void> replaceDeletedNotes(List<Map<String, dynamic>> notes) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('deleted_notes');
      final batch = txn.batch();
      for (final n in notes) {
        batch.insert(
          'deleted_notes',
          _noteToRow(n),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  // ── Kategoriler ──────────────────────────────────────────────────────
  Future<void> replaceCategories(
    List<String> categories,
    Map<String, String> colors,
    Set<String> locked,
  ) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('categories');
      final batch = txn.batch();
      for (var i = 0; i < categories.length; i++) {
        final name = categories[i];
        batch.insert('categories', {
          'name': name,
          'color': colors[name],
          'isLocked': locked.contains(name) ? 1 : 0,
          'sortOrder': i,
        });
      }
      await batch.commit(noResult: true);
    });
  }

  Future<Map<String, dynamic>> getCategoriesData() async {
    final db = await database;
    final rows = await db.query('categories', orderBy: 'sortOrder ASC');
    final categories = <String>[];
    final colors = <String, String>{};
    final locked = <String>{};
    for (final row in rows) {
      final name = row['name'] as String;
      categories.add(name);
      if (row['color'] != null) colors[name] = row['color'] as String;
      if (row['isLocked'] == 1) locked.add(name);
    }
    return {'categories': categories, 'colors': colors, 'locked': locked};
  }

  // ── Ayarlar (key-value) ──────────────────────────────────────────────
  Future<void> setSetting(String key, String? value) async {
    final db = await database;
    if (value == null) {
      await db.delete('settings', where: 'key = ?', whereArgs: [key]);
    } else {
      await db.insert('settings', {
        'key': key,
        'value': value,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<Map<String, String>> getAllSettings() async {
    final db = await database;
    final rows = await db.query('settings');
    return {for (final r in rows) r['key'] as String: r['value'] as String};
  }

  // ── Ek dosyalar (attachments) - fiziksel dosya yönetimi ─────────────────
  // Dosyalar, veritabanıyla aynı uygulama verisi dizini altında "attachments"
  // klasöründe saklanır (ör: .../app_flutter/attachments/<storedName>).
  Future<Directory> attachmentsDir() async {
    final dbDir = await getDatabasesPath();
    final baseDir = p.dirname(dbDir);
    final dir = Directory(p.join(baseDir, 'attachments'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<void> deleteAttachmentFile(String storedName) async {
    try {
      final dir = await attachmentsDir();
      final file = File(p.join(dir.path, storedName));
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Dosya zaten yoksa veya silinemiyorsa sessizce geç; not verisi
      // her durumda kaldırılmış olacak.
    }
  }

  // Bir notu kopyalarken (Kopya Oluştur) ekli dosyaların ikisi de AYNI
  // fiziksel dosyayı göstermesin diye, her ek dosya diskte de kopyalanır ve
  // kopyaya yeni bir storedName atanır.
  Future<List<Map<String, dynamic>>> duplicateAttachmentFiles(
    List<Map<String, dynamic>> attachments,
  ) async {
    final dir = await attachmentsDir();
    final result = <Map<String, dynamic>>[];
    var counter = 0;
    for (final a in attachments) {
      final oldStored = a['storedName']?.toString();
      if (oldStored == null) continue;
      final oldFile = File(p.join(dir.path, oldStored));
      if (!await oldFile.exists()) continue;
      final ext = p.extension(oldStored);
      final newStored =
          '${DateTime.now().microsecondsSinceEpoch}_${counter++}$ext';
      await oldFile.copy(p.join(dir.path, newStored));
      result.add({...a, 'id': '${a['id']}_copy', 'storedName': newStored});
    }
    return result;
  }
}

// ════════════════════════════════════════════════════════════════════════
// HATIRLATICI SERVİSİ (ReminderService)
// Notlara eklenen hatırlatıcıları yerel bildirim (local notification) olarak
// planlar/iptal eder. Her not, id'sinin hash'inden türetilen sabit bir
// bildirim numarasına sahiptir; böylece aynı not için tekrar planlama
// yapıldığında eski bildirim otomatik olarak günceller/iptal eder.
// ════════════════════════════════════════════════════════════════════════
class ReminderService {
  ReminderService._internal();
  static final ReminderService instance = ReminderService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.local);
    } catch (_) {
      // Yerel zaman dilimi belirlenemezse varsayılan (UTC benzeri) kalır.
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(initSettings);

    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImpl?.requestNotificationsPermission();
    await androidImpl?.requestExactAlarmsPermission();

    _initialized = true;
  }

  // Not id'si (createdDate string'i) her zaman aynı 31-bit bildirim
  // numarasına dönüşsün diye kullanılır.
  int _notificationIdFor(String noteId) => noteId.hashCode & 0x7fffffff;

  Future<void> schedule({
    required String noteId,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    if (!_initialized) await init();
    final id = _notificationIdFor(noteId);
    await _plugin.cancel(id);
    if (dateTime.isBefore(DateTime.now())) return;

    final scheduledDate = tz.TZDateTime.from(dateTime, tz.local);
    try {
      await _plugin.zonedSchedule(
        id,
        title.isEmpty ? 'Hatırlatıcı' : title,
        body,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'dnote_reminders',
            'Not Hatırlatıcıları',
            channelDescription: 'DNote uygulamasındaki not hatırlatıcıları',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (_) {
      // Kesin alarm izni verilmemiş olabilir; en yakın zamanda (inexact)
      // planlamayı dene ki hatırlatıcı tamamen sessizce kaybolmasın.
      try {
        await _plugin.zonedSchedule(
          id,
          title.isEmpty ? 'Hatırlatıcı' : title,
          body,
          scheduledDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'dnote_reminders',
              'Not Hatırlatıcıları',
              channelDescription:
                  'DNote uygulamasındaki not hatırlatıcıları',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (_) {
        // Planlama başarısız oldu; sessizce yut, uygulama çökmesin.
      }
    }
  }

  Future<void> cancel(String noteId) async {
    if (!_initialized) await init();
    await _plugin.cancel(_notificationIdFor(noteId));
  }
}

// ════════════════════════════════════════════════════════════════════════
// İÇERİK BLOKLARI (ContentBlocks)
// Not içeriği artık düz metin yerine, sırayla dizilmiş "bloklar"dan oluşur:
//   {"type": "text", "text": "..."}
//   {"type": "attachments", "ids": ["att1", "att2", ...]}
// Böylece kullanıcı imlecin olduğu yere fotoğraf/belge ekleyebilir, ekin
// altına/üstüne yazı yazabilir. Eski (düz metin) notlarla geriye dönük
// uyumluluk korunur: içerik JSON blok listesi olarak çözümlenemezse, tüm
// içerik tek bir metin bloğu olarak kabul edilir.
// ════════════════════════════════════════════════════════════════════════
class ContentBlocks {
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
          decoded.every(
            (e) => e is Map && (e['type'] == 'text' || e['type'] == 'attachments'),
          )) {
        return List<Map<String, dynamic>>.from(
          decoded.map((e) => Map<String, dynamic>.from(e as Map)),
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
        .where((b) => b['type'] == 'text')
        .map((b) => (b['text'] ?? '').toString())
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

// ════════════════════════════════════════════════════════════════════════
// TEMA (Açık / Koyu / Sistem)
// Uygulama genelinde tema modu bu global ValueNotifier üzerinden yönetilir.
// Ayarlar ekranındaki seçim değiştiğinde appThemeMode.value güncellenir;
// bunu dinleyen DNoteApp, MaterialApp'i otomatik olarak yeniden kurar.
// ════════════════════════════════════════════════════════════════════════
final ValueNotifier<ThemeMode> appThemeMode = ValueNotifier<ThemeMode>(
  ThemeMode.dark,
);

ThemeMode themeModeFromSettingValue(String? value) {
  switch (value) {
    case 'light':
      return ThemeMode.light;
    case 'system':
      return ThemeMode.system;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.dark; // ayar hiç kaydedilmemişse eski davranış korunur
  }
}

String themeModeToSettingValue(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return 'light';
    case ThemeMode.system:
      return 'system';
    case ThemeMode.dark:
      return 'dark';
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hatırlatıcı bildirimleri için bildirim eklentisini ve zaman dilimi
  // verisini uygulama açılışında bir kez hazırla.
  await ReminderService.instance.init();

  // Uygulama ilk kez çizilmeden önce kayıtlı tema tercihini oku; böylece
  // açılışta koyu tema bir an için yanıp sönmez.
  final settings = await DBHelper.instance.getAllSettings();
  final storedThemeMode = settings['theme_mode'];
  if (storedThemeMode != null) {
    appThemeMode.value = themeModeFromSettingValue(storedThemeMode);
  } else {
    // Eski sürümden geliyorsa (theme_mode hiç yoksa) 'dark_theme' anahtarına
    // bakarak geri uyumlu bir geçiş yap.
    final legacyDark = settings['dark_theme'];
    if (legacyDark != null) {
      appThemeMode.value = legacyDark == 'true'
          ? ThemeMode.dark
          : ThemeMode.light;
    }
  }

  SystemChrome.setSystemUIOverlayStyle(
    dNoteSystemBarsStyleForMode(appThemeMode.value),
  );
  runApp(const DNoteApp());
}

final ThemeData _dNoteDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.amber,
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardTheme: const CardThemeData(color: Color(0xFF1E1E1E)),
  dividerColor: const Color(0xFF2A2A2A),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    // Liste kaydırıldığında AppBar'ın rengi otomatik koyulaşmasın diye
    // Material 3'ün scroll-altı tint/elevation efektini kapatıyoruz.
    surfaceTintColor: Colors.transparent,
    scrolledUnderElevation: 0,
  ),
  dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF1E1E1E)),
  popupMenuTheme: const PopupMenuThemeData(color: Color(0xFF2A2A2A)),
);

final ThemeData _dNoteLightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.amber,
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  cardTheme: const CardThemeData(color: Colors.white),
  dividerColor: const Color(0xFFE0E0E0),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    scrolledUnderElevation: 0,
  ),
  dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
  popupMenuTheme: const PopupMenuThemeData(color: Colors.white),
);

// ── Ekranlar genelinde kullanılan, temaya duyarlı yardımcı renkler ──────
// ThemeData'nın doğrudan karşılamadığı özel yüzey tonları (ör. çekmece
// başlığı, ikincil yüzey, kenarlık) için kullanılır. Aşama aşama tüm
// ekranlar bu yardımcılarla (veya doğrudan Theme.of(context) ile) güncellenir.
bool dNoteIsDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

Color dNoteSurfaceVariant(BuildContext context) =>
    dNoteIsDark(context) ? const Color(0xFF2A2A2A) : const Color(0xFFEDEDED);

Color dNoteBorderColor(BuildContext context) =>
    dNoteIsDark(context) ? const Color(0xFF3A3A3A) : const Color(0xFFDADADA);

Color dNoteHeaderColor(BuildContext context) =>
    dNoteIsDark(context) ? const Color(0xFF161616) : const Color(0xFFEDEDED);

// Seçili/vurgulanmış öğe arka planı: koyu temada hafif beyaz, açık temada
// hafif siyah — her iki temada da göz alıcı olmayan tutarlı bir vurgu verir.
Color dNoteHighlight(BuildContext context) =>
    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08);

// Kart / panel yüzeyi: _dNoteDarkTheme ve _dNoteLightTheme içindeki
// cardTheme ile birebir aynı tonlar. Ayarlar ekranı gibi elle Container
// çizen yerlerde ThemeData.cardTheme yerine bu kullanılır.
Color dNoteCardColor(BuildContext context) =>
    dNoteIsDark(context) ? const Color(0xFF1E1E1E) : Colors.white;

// Bir tarihi "gg.aa.yyyy ss:dd" biçiminde döndürür. Hatırlatıcı tarihini hem
// not düzenleyicide hem de önizleme kartlarında tutarlı biçimde göstermek
// için kullanılır.
String _formatDateTimeTr(DateTime dt) {
  final day = dt.day.toString().padLeft(2, '0');
  final month = dt.month.toString().padLeft(2, '0');
  final hour = dt.hour.toString().padLeft(2, '0');
  final minute = dt.minute.toString().padLeft(2, '0');
  return '$day.$month.${dt.year} $hour:$minute';
}

// Birincil metin rengi: koyu temada beyaz, açık temada neredeyse siyah.
// Sabit "Colors.white" kullanan eski kodun açık temada okunmaz hale
// gelmesini önlemek için eklendi.
Color dNoteTextColor(BuildContext context) =>
    dNoteIsDark(context) ? Colors.white : const Color(0xFF1A1A1A);

// Kullanıcı, uygulama henüz açık tema desteklemezken (veya "Beyaz" rengini
// bilerek) Kişiselleştirme > Metin Rengi'nden saf beyazı seçmiş olabilir.
// Açık temada bu seçim doğrudan uygulanırsa metin, beyaz kart zemininde
// tamamen okunmaz hale gelir. Bu yüzden: açık temadayken saf beyaz özel
// renk varsa otomatik (temaya duyarlı) renge düşülür; kullanıcının seçtiği
// diğer tüm renkler (ve koyu temadaki beyaz seçimi) olduğu gibi korunur.
Color dNoteEffectiveTextColor(BuildContext context, Color? customColor) {
  if (customColor == null) return dNoteTextColor(context);
  if (!dNoteIsDark(context) && customColor.toARGB32() == Colors.white.toARGB32()) {
    return dNoteTextColor(context);
  }
  return customColor;
}

// ── Sistem çubukları (durum çubuğu + gezinme çubuğu) ────────────────────
// ÖNEMLİ: SystemUiOverlayStyle çağrılırken yalnızca durum çubuğu alanları
// verilip gezinme çubuğu (systemNavigationBar*) alanları boş bırakılırsa,
// platform gezinme çubuğunu kendi varsayılanına (genelde açık/beyaz bir
// görünüme) sıfırlayabiliyor. Bu yüzden HER çağrıda ikisi birlikte ve o
// anki temaya göre ayarlanır; ayrı ayrı, birbirini unutan çağrılar
// yazılmamalıdır.
SystemUiOverlayStyle dNoteSystemBarsStyle(
  BuildContext context, {
  Color? statusBarColor,
  Brightness? statusBarIconBrightnessOverride,
}) {
  final isDark = dNoteIsDark(context);
  return SystemUiOverlayStyle(
    statusBarColor: statusBarColor ?? Colors.transparent,
    statusBarIconBrightness:
        statusBarIconBrightnessOverride ??
        (isDark ? Brightness.light : Brightness.dark),
    statusBarBrightness:
        statusBarIconBrightnessOverride == null
            ? (isDark ? Brightness.dark : Brightness.light)
            : (statusBarIconBrightnessOverride == Brightness.light
                  ? Brightness.dark
                  : Brightness.light),
    systemNavigationBarColor: isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF5F5F5),
    systemNavigationBarIconBrightness: isDark
        ? Brightness.light
        : Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
  );
}

// main() içinde uygulama ilk açılırken henüz bir BuildContext yok; bu
// yüzden appThemeMode.value ve (Sistem seçiliyse) platform parlaklığına
// bakarak aynı stili context'siz üretir.
bool dNoteResolveIsDark(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.dark:
      return true;
    case ThemeMode.light:
      return false;
    case ThemeMode.system:
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
  }
}

SystemUiOverlayStyle dNoteSystemBarsStyleForMode(ThemeMode mode) {
  final isDark = dNoteResolveIsDark(mode);
  return SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    systemNavigationBarColor: isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF5F5F5),
    systemNavigationBarIconBrightness: isDark
        ? Brightness.light
        : Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
  );
}

class DNoteApp extends StatelessWidget {
  const DNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeMode,
      builder: (context, mode, _) {
        // Tema (Açık/Koyu/Sistem) her değiştiğinde durum ve gezinme
        // çubuklarını hemen yeni temaya göre günceller; aksi halde bir
        // sonraki ekran geçişine kadar eski (yanlış) stil görünür kalır.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          SystemChrome.setSystemUIOverlayStyle(
            dNoteSystemBarsStyleForMode(mode),
          );
        });
        return MaterialApp(
          title: 'DNote',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('tr', 'TR'), Locale('en', 'US')],
          locale: const Locale('tr', 'TR'),
          themeMode: mode,
          theme: _dNoteLightTheme,
          darkTheme: _dNoteDarkTheme,
          home: const NoteListScreen(),
        );
      },
    );
  }
}

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> _notes = [];
  List<Map<String, dynamic>> _deletedNotes = [];
  List<String> _categories = [];
  Map<String, String> _categoryColors = {};
  Set<String> _lockedCategories = {};
  String _activeCategory = 'Tümü';
  DateTime? _lastBackPressTime;

  static const List<Color> _categoryPalette = [
    Color(0xFFFFD600), // Canlı sarı
    Color(0xFFFF6D00), // Turuncu
    Color(0xFFFF1744), // Kırmızı
    Color(0xFFFF4081), // Pembe
    Color(0xFFD500F9), // Mor
    Color(0xFF651FFF), // Derin mor
    Color(0xFF2979FF), // Mavi
    Color(0xFF00B0FF), // Açık mavi
    Color(0xFF00E5FF), // Turkuaz
    Color(0xFF00E676), // Yeşil
    Color(0xFFB2FF59), // Açık yeşil
    Color(0xFF69F0AE), // Nane yeşili
  ];

  Color _getCategoryColor(String? category) {
    if (category == null || category.isEmpty) return Colors.amber;
    final hex = _categoryColors[category];
    if (hex != null) {
      return Color(int.parse(hex, radix: 16));
    }
    return Colors.amber;
  }

  String _searchQuery = "";
  bool _isSearching = false;

  String _sortCriteria = "Oluşturulma";
  bool _isAscending = true;
  bool _isListView = true;

  // ── Ayarlar ──────────────────────────────────────────────
  // Güvenlik
  bool _notePasswordEnabled = false;
  String _notePassword = '';
  String _passwordHintQuestion = '';
  String _passwordHintAnswer = '';

  // Tema (Açık / Koyu / Sistem) — gerçek kaynak appThemeMode notifier'ıdır,
  // burada sadece Ayarlar ekranındaki seçili seçeneği göstermek için tutulur.
  ThemeMode _themeMode = ThemeMode.dark;
  bool _colorfulNotes = false;

  // Kişiselleştirme
  String _fontFamily = 'Varsayılan';
  double _globalFontSize = 16.0;
  // null == "Varsayılan": temaya göre otomatik (koyu temada beyaz, açık
  // temada koyu gri). Kullanıcı Metin Rengi seçiciden bir renk seçerse bu
  // alan o rengi tutar ve tema değişse bile sabit kalır.
  Color? _textColor;
  int _previewLines = 3;

  // Widget
  double _widgetFontSize = 14.0;
  double _widgetBgOpacity = 1.0;
  bool _widgetDark = true;
  // ─────────────────────────────────────────────────────────

  OverlayEntry? _snackOverlay;
  Timer? _snackTimer;
  // Not kartlarında görsel önizleme gösterebilmek için eklerin fiziksel
  // klasör yolu; uygulama açılışında bir kez okunup önbelleğe alınır.
  String? _attachmentsDirPath;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    DBHelper.instance.attachmentsDir().then((d) {
      if (mounted) setState(() => _attachmentsDirPath = d.path);
    });
  }

  Future<void> _loadData() async {
    final db = DBHelper.instance;

    final catData = await db.getCategoriesData();
    final notes = await db.getNotes();
    final deletedNotes = await db.getDeletedNotes();
    final settings = await db.getAllSettings();
    // Veritabanı hiç yazılmamışsa (uygulamanın ilk açılışı) 'never
    // initialized' durumu; bu durumda hoş geldin notu eklenir. Kullanıcı
    // daha sonra tüm notlarını silerse (notes tablosu boş ama initialized
    // işaretli) hoş geldin notu tekrar EKLENMEZ.
    final bool neverInitialized = !settings.containsKey('_initialized');

    setState(() {
      _categories = List<String>.from(catData['categories'] as List);
      _categoryColors = Map<String, String>.from(catData['colors'] as Map);
      _lockedCategories = Set<String>.from(catData['locked'] as Set);

      if (notes.isNotEmpty || !neverInitialized) {
        _notes = notes;
      } else {
        _notes = [
          {
            'id': '2026-06-18 22:05:00',
            'title': 'DNote\'a Hoş Geldiniz! 🚀',
            'content': 'Yeni özellikler eklendi!',
            'date': '18.06.2026 22:05',
            'createdDate': '2026-06-18 22:05:00',
            'modifiedDate': '2026-06-18 22:05:00',
            'category': null,
            'color': 'Amber',
            'type': 'text',
            'isLocked': false,
          },
        ];
      }

      _deletedNotes = deletedNotes;

      _sortCriteria = settings['sort_criteria'] ?? 'Oluşturulma';
      _isAscending = (settings['is_ascending'] ?? 'true') == 'true';
      _isListView = (settings['is_list_view'] ?? 'true') == 'true';
      _activeCategory = 'Tümü'; // Her açılışta Notlar ekranından başlat
      // Güvenlik: uygulama kapanıp açıldığında "Kilitli" klasörü şifre
      // sorulmadan otomatik açılmasın; varsayılan görünüme dön.
      if (_activeCategory == '__locked__') {
        _activeCategory = 'Tümü';
      }

      // Ayarlar
      _notePasswordEnabled =
          (settings['note_password_enabled'] ?? 'false') == 'true';
      _notePassword = settings['note_password'] ?? '';
      _passwordHintQuestion = settings['password_hint_question'] ?? '';
      _passwordHintAnswer = settings['password_hint_answer'] ?? '';
      if (settings.containsKey('theme_mode')) {
        _themeMode = themeModeFromSettingValue(settings['theme_mode']);
      } else {
        // Eski sürümden gelen 'dark_theme' (true/false) ayarını göç ettir.
        _themeMode = (settings['dark_theme'] ?? 'true') == 'true'
            ? ThemeMode.dark
            : ThemeMode.light;
      }
      // Uygulama genelindeki temayı da senkronize et (açılışta main() zaten
      // ayarlamıştı, ama eski 'dark_theme' göçü burada da tutarlı olsun).
      appThemeMode.value = _themeMode;
      _colorfulNotes = (settings['colorful_notes'] ?? 'false') == 'true';
      _fontFamily = settings['font_family'] ?? 'Varsayılan';
      _globalFontSize =
          double.tryParse(settings['global_font_size'] ?? '') ?? 16.0;
      final textColorVal = int.tryParse(settings['text_color'] ?? '');
      _textColor = textColorVal != null ? Color(textColorVal) : null;
      _previewLines = int.tryParse(settings['preview_lines'] ?? '') ?? 3;
      _widgetFontSize =
          double.tryParse(settings['widget_font_size'] ?? '') ?? 14.0;
      _widgetBgOpacity =
          double.tryParse(settings['widget_bg_opacity'] ?? '') ?? 1.0;
      _widgetDark = (settings['widget_dark'] ?? 'true') == 'true';
    });

    // İlk açılışta oluşturulan hoş geldin notunu kalıcı hale getir ve
    // veritabanının artık başlatılmış olduğunu işaretle.
    if (neverInitialized) {
      await db.replaceNotes(_notes);
      await db.setSetting('_initialized', 'true');
    }
  }

  Future<void> _saveData() async {
    final db = DBHelper.instance;
    await db.replaceNotes(_notes);
    await db.replaceDeletedNotes(_deletedNotes);
    await db.replaceCategories(_categories, _categoryColors, _lockedCategories);

    await db.setSetting('_initialized', 'true');
    await db.setSetting('sort_criteria', _sortCriteria);
    await db.setSetting('is_ascending', _isAscending.toString());
    await db.setSetting('is_list_view', _isListView.toString());
    await db.setSetting('active_category', _activeCategory);

    // Ayarlar
    await db.setSetting(
      'note_password_enabled',
      _notePasswordEnabled.toString(),
    );
    await db.setSetting('note_password', _notePassword);
    await db.setSetting('password_hint_question', _passwordHintQuestion);
    await db.setSetting('password_hint_answer', _passwordHintAnswer);
    await db.setSetting('theme_mode', themeModeToSettingValue(_themeMode));
    await db.setSetting('colorful_notes', _colorfulNotes.toString());
    await db.setSetting('font_family', _fontFamily);
    await db.setSetting('global_font_size', _globalFontSize.toString());
    await db.setSetting('text_color', _textColor?.toARGB32().toString());
    await db.setSetting('preview_lines', _previewLines.toString());
    await db.setSetting('widget_font_size', _widgetFontSize.toString());
    await db.setSetting('widget_bg_opacity', _widgetBgOpacity.toString());
    await db.setSetting('widget_dark', _widgetDark.toString());
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$day.$month.${now.year} $hour:$minute';
  }

  int _getCountForCategory(String category) {
    return _notes.where((note) {
      final isArchived = note['isArchived'] == true;
      final isFavorite = note['isFavorite'] == true;
      final isLocked = note['isLocked'] == true;

      if (category == 'Tümü' || category == 'Notlar') {
        return !isArchived && !isLocked;
      } else if (category == '__favorites__') {
        return isFavorite && !isArchived && !isLocked;
      } else if (category == '__locked__') {
        return isLocked && !isArchived;
      } else if (category == '__archive__') {
        return isArchived && !isLocked;
      } else if (category == '__reminders__') {
        return _hasActiveReminder(note) && !isArchived && !isLocked;
      } else {
        return !isArchived && !isLocked && note['category'] == category;
      }
    }).length;
  }

  String _getCategoryDisplayName(String category) {
    if (category == 'Tümü' || category == 'Notlar') {
      return 'Notlar';
    } else if (category == '__favorites__') {
      return 'Favoriler';
    } else if (category == '__locked__') {
      return 'Kilitli';
    } else if (category == '__archive__') {
      return 'Arşiv';
    } else if (category == '__trash__') {
      return 'Çöp Kutusu';
    } else if (category == '__reminders__') {
      return 'Hatırlatmalar';
    } else {
      return category;
    }
  }

  void _deleteCategory(String category) {
    setState(() {
      _categories.remove(category);
      _categoryColors.remove(category);
      _lockedCategories.remove(category);
      for (final note in _notes) {
        if (note['category'] == category) {
          note['category'] = null;
        }
      }
      for (final note in _deletedNotes) {
        if (note['category'] == category) {
          note['category'] = null;
        }
      }
      if (_activeCategory == category) {
        _activeCategory = 'Tümü';
      }
    });
    _saveData();
  }

  void _showCategoryOptions(String category) {
    final isLocked = _lockedCategories.contains(category);
    showModalBottomSheet(
      context: context,
      backgroundColor: dNoteCardColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dNoteIsDark(sheetContext)
                        ? Colors.grey[700]
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  category,
                  style: TextStyle(
                    color: dNoteTextColor(sheetContext),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.edit_outlined,
                  color: dNoteTextColor(sheetContext),
                ),
                title: Text(
                  'Adını Düzenle / Renk',
                  style: TextStyle(color: dNoteTextColor(sheetContext)),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showAddCategoryDialog(editingCategory: category);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  isLocked ? Icons.lock_open_outlined : Icons.lock_outline,
                  color: Colors.blueGrey,
                ),
                title: Text(
                  isLocked ? 'Kilidi Kaldır' : 'Kilitle',
                  style: TextStyle(color: dNoteTextColor(sheetContext)),
                ),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  if (!_notePasswordEnabled) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: dNoteCardColor(ctx),
                        title: const Text(
                          'Parola Gerekiyor',
                          style: TextStyle(color: Colors.amber),
                        ),
                        content: Text(
                          'Kategoriyi kilitleyebilmek için önce Ayarlar > Not Şifresi bölümünden bir parola belirlemeniz gerekiyor.',
                          style: TextStyle(color: dNoteTextColor(ctx)),
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                            ),
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text(
                              'Tamam',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  final ok = await _checkPasswordPrompt();
                  if (!mounted) return;
                  if (ok) {
                    setState(() {
                      if (isLocked) {
                        _lockedCategories.remove(category);
                      } else {
                        _lockedCategories.add(category);
                        if (_activeCategory == category) {
                          _activeCategory = 'Tümü';
                        }
                      }
                    });
                    _saveData();
                    _showInfoBar(
                      isLocked ? 'Kilit kaldırıldı' : 'Kategori kilitlendi',
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: dNoteCardColor(ctx),
                        title: const Text(
                          'Hatalı Parola',
                          style: TextStyle(color: Colors.red),
                        ),
                        content: Text(
                          'Girdiğiniz parola yanlış.',
                          style: TextStyle(color: dNoteTextColor(ctx)),
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                            ),
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text(
                              'Tamam',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Kategoriyi Sil',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  showDialog(
                    context: context,
                    builder: (confirmContext) => AlertDialog(
                      backgroundColor: dNoteCardColor(confirmContext),
                      title: const Text(
                        'Kategoriyi Sil',
                        style: TextStyle(color: Colors.amber),
                      ),
                      content: Text(
                        '"$category" kategorisini silmek istediğinize emin misiniz? Bu kategorideki notlar kategorisiz kalacak.',
                        style: TextStyle(color: dNoteTextColor(confirmContext)),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(confirmContext),
                          child: const Text(
                            'İptal',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.pop(confirmContext);
                            _deleteCategory(category);
                          },
                          child: const Text(
                            'Sil',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteNote(int index) {
    final deletedNote = _notes[index];
    final noteId = deletedNote['id']?.toString();
    if (noteId != null) {
      ReminderService.instance.cancel(noteId);
    }
    setState(() {
      _notes.removeAt(index);
      _deletedNotes.add(deletedNote);
    });
    _saveData();

    _showDeletedBar(deletedNote);
  }

  // Bir not çöp kutusundan geri yüklendiğinde veya kopyalandığında, hâlâ
  // gelecekte olan bir hatırlatıcısı varsa bildirimini yeniden planlar.
  void _rescheduleNoteReminder(Map<String, dynamic> note) {
    final noteId = note['id']?.toString();
    final rawReminder = note['reminderDate']?.toString();
    if (noteId == null || rawReminder == null || rawReminder.isEmpty) return;
    final reminder = DateTime.tryParse(rawReminder);
    if (reminder == null || reminder.isBefore(DateTime.now())) return;
    final title = (note['title'] ?? '').toString();
    final preview = ContentBlocks.plainText(note['content']?.toString());
    ReminderService.instance.schedule(
      noteId: noteId,
      title: title.isEmpty ? 'Hatırlatıcı' : title,
      body: (note['type'] == 'checklist')
          ? 'Kontrol listeni kontrol etmeyi unutma'
          : (preview.isEmpty ? 'Notunu kontrol etmeyi unutma' : preview),
      dateTime: reminder,
    );
  }

  // Bir notun ekli dosyalarını diskten siler (not kalıcı olarak silinirken
  // çağrılır). Not verisinin kendisine dokunmaz.
  void _cleanupAttachmentFiles(Map<String, dynamic> note) {
    final noteId = note['id']?.toString();
    if (noteId != null) {
      ReminderService.instance.cancel(noteId);
    }
    final atts = note['attachments'];
    if (atts is List) {
      for (final a in atts) {
        final storedName = (a as Map)['storedName']?.toString();
        if (storedName != null) {
          DBHelper.instance.deleteAttachmentFile(storedName);
        }
      }
    }
  }

  Future<void> _duplicateNote(int index) async {
    final original = _notes[index];
    final now = DateTime.now();
    final newRawTime = now.toString();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final formattedDate = '$day.$month.${now.year} $hour:$minute';
    final duplicate = Map<String, dynamic>.from(original);
    duplicate['id'] = newRawTime;
    duplicate['createdDate'] = newRawTime;
    duplicate['modifiedDate'] = newRawTime;
    duplicate['date'] = formattedDate;

    // checkItems ve attachments listeleri orijinalle AYNI referansı
    // paylaşmasın diye derin kopya alınır.
    final origCheckItems = original['checkItems'];
    if (origCheckItems is List) {
      duplicate['checkItems'] = origCheckItems
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }

    final origAttachments = original['attachments'];
    if (origAttachments is List && origAttachments.isNotEmpty) {
      // Ekli dosyaların kendisi de diskte fiziksel olarak kopyalanır; aksi
      // halde iki not aynı dosyayı paylaşır ve biri kalıcı silinince
      // diğerinin eki de kaybolur.
      duplicate['attachments'] = await DBHelper.instance
          .duplicateAttachmentFiles(
            List<Map<String, dynamic>>.from(
              origAttachments.map((e) => Map<String, dynamic>.from(e as Map)),
            ),
          );
    }

    setState(() => _notes.insert(index + 1, duplicate));
    _saveData();
    _rescheduleNoteReminder(duplicate);
    _showInfoBar('Kopya oluşturuldu');
  }

  Future<void> _copyNoteContent(int index) async {
    final note = _notes[index];
    final title = (note['title'] ?? '').toString().trim();
    final content = ContentBlocks.plainText(note['content'] as String?);
    final text = [
      if (title.isNotEmpty) title,
      if (content.isNotEmpty) content,
    ].join('\n\n');
    await Clipboard.setData(ClipboardData(text: text));
    _showInfoBar('Kopyalandı');
  }

  void _showInfoBar(String message) {
    _hideDeletedBar();
    _snackOverlay = OverlayEntry(
      builder: (ctx) => Positioned(
        bottom: 24,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: dNoteCardColor(context),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.amber, size: 18),
                const SizedBox(width: 10),
                Text(message, style: TextStyle(color: dNoteTextColor(context))),
              ],
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_snackOverlay!);
    _snackTimer = Timer(const Duration(seconds: 2), _hideDeletedBar);
  }

  void _showTextSizeSlider(int noteIndex) {
    final currentSize =
        (_notes[noteIndex]['fontSize'] as num?)?.toDouble() ?? _globalFontSize;
    double tempSize = currentSize;
    showModalBottomSheet(
      context: context,
      backgroundColor: dNoteCardColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (context, setSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dNoteIsDark(context)
                        ? Colors.grey[700]
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Metin Boyutu',
                  style: TextStyle(
                    color: dNoteTextColor(context),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.text_fields, color: Colors.grey, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.amber,
                          inactiveTrackColor: dNoteBorderColor(context),
                          thumbColor: Colors.amber,
                          overlayColor: Colors.amber.withValues(alpha: 0.2),
                          valueIndicatorColor: Colors.amber,
                          valueIndicatorTextStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Slider(
                          value: tempSize,
                          min: 10,
                          max: 30,
                          divisions: 20,
                          label: '${tempSize.round()}',
                          onChanged: (v) => setSheet(() => tempSize = v),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.text_fields, color: Colors.grey, size: 26),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Örnek metin',
                  style: TextStyle(
                    color: dNoteTextColor(context).withValues(alpha: 0.7),
                    fontSize: tempSize,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(sheetCtx),
                        child: const Text(
                          'İptal',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        onPressed: () {
                          setState(
                            () => _notes[noteIndex]['fontSize'] = tempSize,
                          );
                          _saveData();
                          Navigator.pop(sheetCtx);
                        },
                        child: const Text(
                          'Uygula',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Yeni: parola doğrulama dialogu (true dönerse doğru parola girildi)
  Future<bool> _checkPasswordPrompt() async {
    if (!_notePasswordEnabled) return false;
    final ctrl = TextEditingController();
    final completer = Completer<bool>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setDlg) => AlertDialog(
          backgroundColor: dNoteCardColor(ctx2),
          title: const Text(
            'Parola Gerekiyor',
            style: TextStyle(color: Colors.amber),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                selectionWidthStyle: ui.BoxWidthStyle.tight,
                contextMenuBuilder: buildCustomContextMenu,
                selectionHeightStyle: ui.BoxHeightStyle.max,
                controller: ctrl,
                obscureText: true,
                style: TextStyle(color: dNoteTextColor(ctx2)),
                decoration: InputDecoration(
                  hintText: 'Parolayı girin',
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: dNoteBorderColor(ctx2)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
              ),
              if (_passwordHintQuestion.isNotEmpty) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () {
                      Navigator.pop(ctx);
                      completer.complete(false);
                      _showForgotPasswordDialog();
                    },
                    child: const Text(
                      'Şifremi unuttum',
                      style: TextStyle(color: Colors.amber, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                completer.complete(false);
              },
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                final ok = ctrl.text == _notePassword;
                Navigator.pop(ctx);
                completer.complete(ok);
              },
              child: const Text(
                'Doğrula',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );

    return completer.future;
  }

  // Yeni: "Şifremi unuttum" akışı — güvenlik sorusu/cevabı ile şifreyi hatırlatır.
  void _showForgotPasswordDialog() {
    final answerCtrl = TextEditingController();
    String? errorText;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setDlg) => AlertDialog(
          backgroundColor: dNoteCardColor(ctx2),
          title: const Text(
            'Güvenlik Sorusu',
            style: TextStyle(color: Colors.amber),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _passwordHintQuestion,
                style: TextStyle(
                  color: dNoteTextColor(ctx2),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                selectionWidthStyle: ui.BoxWidthStyle.tight,
                contextMenuBuilder: buildCustomContextMenu,
                selectionHeightStyle: ui.BoxHeightStyle.max,
                controller: answerCtrl,
                style: TextStyle(color: dNoteTextColor(ctx2)),
                decoration: InputDecoration(
                  hintText: 'Cevabınız',
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: dNoteBorderColor(ctx2)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                  errorText: errorText,
                ),
                onSubmitted: (_) {},
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                final correct =
                    answerCtrl.text.trim().toLowerCase() ==
                    _passwordHintAnswer.trim().toLowerCase();
                if (correct) {
                  Navigator.pop(ctx);
                  _showRevealedPasswordDialog();
                } else {
                  setDlg(() => errorText = 'Cevap yanlış. Tekrar deneyin.');
                }
              },
              child: const Text(
                'Onayla',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Yeni: güvenlik sorusu doğrulandıktan sonra şifreyi gösterir.
  void _showRevealedPasswordDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dNoteCardColor(ctx),
        title: const Text('Şifreniz', style: TextStyle(color: Colors.amber)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Not şifreniz:',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: dNoteSurfaceVariant(ctx),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                _notePassword,
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Tamam',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Not: notu doğrudan açar. Kilitli notlar zaten "Kilitli" klasöründe ve
  // o klasöre girişte parola soruluyor; notun kendisinde tekrar parola
  // sorup içeriği gizlemeye gerek yok.
  Future<void> _openNoteWithPasswordCheck(int index) async {
    if (index < 0 || index >= _notes.length) return;
    _showNoteDialog(index: index);
  }

  // ── Ayarlar Sayfası ────────────────────────────────────────
  void _openSettings() {
    Navigator.pop(context); // drawer'ı kapat
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => _SettingsPage(state: this)));
  }

  // Yeni: "Kilitli" klasörüne girmeden önce parola sorar.
  Future<void> _openLockedFolder() async {
    Navigator.pop(context); // drawer'ı önce kapat

    if (!_notePasswordEnabled) {
      // Parola kapalıyken kilitli klasöre girişte parola sorulmaz,
      // ama kullanıcı parola belirlemediği için uyarılır.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Önce Ayarlar > Not Şifresi ile parola belirleyin.'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _activeCategory = '__locked__');
      _saveData();
      return;
    }

    final ok = await _checkPasswordPrompt();
    if (!mounted) return;
    if (ok) {
      setState(() => _activeCategory = '__locked__');
      _saveData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parola yanlış.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _hideDeletedBar() {
    _snackTimer?.cancel();
    _snackOverlay?.remove();
    _snackOverlay = null;
    _snackTimer = null;
  }

  void _showDeletedBar(Map<String, dynamic> deletedNote) {
    _hideDeletedBar();

    _snackOverlay = OverlayEntry(
      builder: (ctx) => Positioned(
        bottom: 24,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: dNoteCardColor(context),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Not silindi',
                  style: TextStyle(color: dNoteTextColor(context)),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _notes.add(deletedNote);
                      _deletedNotes.removeWhere(
                        (n) => n['id'] == deletedNote['id'],
                      );
                    });
                    _saveData();
                    _hideDeletedBar();
                  },
                  child: const Text(
                    'Geri Getir',
                    style: TextStyle(color: Colors.amber),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_snackOverlay!);
    _snackTimer = Timer(const Duration(seconds: 2), _hideDeletedBar);
  }

  void _showAddMenu() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          24,
          16,
          MediaQuery.of(context).padding.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.text_snippet_outlined,
                color: Colors.amber,
              ),
              title: const Text(
                'Metin Notu',
              ),
              onTap: () {
                Navigator.pop(context);
                _showNoteDialog(type: 'text');
              },
            ),
            ListTile(
              leading: const Icon(Icons.checklist, color: Colors.amber),
              title: const Text(
                'Kontrol Listesi',
              ),
              onTap: () {
                Navigator.pop(context);
                _showNoteDialog(type: 'checklist');
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_outlined, color: Colors.amber),
              title: const Text(
                'Kategori',
              ),
              onTap: () {
                Navigator.pop(context);
                _showAddCategoryDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  // İlk harfi Türkçe kurallarına göre büyütür (örn. "istanbul" -> "İstanbul",
  // "iş" -> "İş"). Dart'ın standart toUpperCase() metodu Türkçe'deki
  // noktalı/noktasız I ayrımını bilmediğinden ("i" -> "I" yapar, "İ" değil),
  // ilk harf için özel bir eşleme kullanılır.
  String _capitalizeFirstLetterTr(String text) {
    if (text.isEmpty) return text;
    final firstChar = text[0];
    const Map<String, String> trUpperMap = {
      'i': 'İ',
      'ı': 'I',
      'ö': 'Ö',
      'ü': 'Ü',
      'ş': 'Ş',
      'ç': 'Ç',
      'ğ': 'Ğ',
    };
    final upperFirst = trUpperMap[firstChar] ?? firstChar.toUpperCase();
    return upperFirst + text.substring(1);
  }

  void _showAddCategoryDialog({
    void Function(String)? onAdded,
    String? editingCategory,
  }) {
    final isEditing = editingCategory != null;
    final controller = TextEditingController(
      text: isEditing ? editingCategory : '',
    );
    Color selectedColor = isEditing
        ? _getCategoryColor(editingCategory)
        : _categoryPalette[_categories.length % _categoryPalette.length];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: dNoteCardColor(context),
          title: Text(
            isEditing ? 'Kategoriyi Düzenle' : 'Yeni Kategori',
            style: const TextStyle(color: Colors.amber),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                selectionWidthStyle: ui.BoxWidthStyle.tight,
                contextMenuBuilder: buildCustomContextMenu,
                selectionHeightStyle: ui.BoxHeightStyle.max,
                controller: controller,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Kategori adı',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: dNoteBorderColor(context)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                style: TextStyle(color: dNoteTextColor(context)),
              ),
              const SizedBox(height: 18),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Renk',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _categoryPalette.map((color) {
                  final isSelected =
                      selectedColor.toARGB32() == color.toARGB32();
                  return GestureDetector(
                    onTap: () {
                      setDialogState(() {
                        selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 2.5)
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 18,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                final rawName = controller.text.trim();
                final name = _capitalizeFirstLetterTr(rawName);
                final colorHex = selectedColor.toARGB32().toRadixString(16);
                if (name.isEmpty) {
                  Navigator.pop(context);
                  return;
                }

                if (isEditing) {
                  if (name != editingCategory && _categories.contains(name)) {
                    Navigator.pop(context);
                    return;
                  }
                  setState(() {
                    if (name != editingCategory) {
                      final idx = _categories.indexOf(editingCategory);
                      if (idx != -1) _categories[idx] = name;
                      _categoryColors.remove(editingCategory);
                      for (final note in _notes) {
                        if (note['category'] == editingCategory) {
                          note['category'] = name;
                        }
                      }
                      for (final note in _deletedNotes) {
                        if (note['category'] == editingCategory) {
                          note['category'] = name;
                        }
                      }
                      if (_activeCategory == editingCategory) {
                        _activeCategory = name;
                      }
                    }
                    _categoryColors[name] = colorHex;
                  });
                  _saveData();
                } else {
                  if (!_categories.contains(name)) {
                    setState(() {
                      _categories.add(name);
                      _categoryColors[name] = colorHex;
                    });
                    _saveData();
                  }
                  onAdded?.call(name);
                }
                Navigator.pop(context);
              },
              child: Text(
                isEditing ? 'Kaydet' : 'Ekle',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClassifyDialog(int noteIndex, {void Function(String?)? onChanged}) {
    final currentCategory = _notes[noteIndex]['category'] as String?;

    void assignCategory(String? category) {
      setState(() {
        _notes[noteIndex]['category'] = category;
      });
      _saveData();
      onChanged?.call(category);
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: dNoteCardColor(context),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dNoteIsDark(sheetContext)
                        ? Colors.grey[700]
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Sınıflandır',
                style: TextStyle(
                  color: dNoteTextColor(sheetContext),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.add_circle_outline,
                  color: dNoteTextColor(sheetContext),
                ),
                title: Text(
                  'Kategori Ekle',
                  style: TextStyle(
                    color: dNoteTextColor(sheetContext),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showAddCategoryDialog(
                    onAdded: (name) {
                      assignCategory(name);
                    },
                  );
                },
              ),
              if (_categories.isNotEmpty) ...[
                Divider(color: Theme.of(sheetContext).dividerColor, height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 280),
                  child: ListView(
                    shrinkWrap: true,
                    children: _categories.map((cat) {
                      final isSelected = currentCategory == cat;
                      final catColor = _getCategoryColor(cat);
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.folder_outlined,
                          color: isSelected
                              ? catColor
                              : catColor.withValues(alpha: 0.6),
                        ),
                        title: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected
                                ? catColor
                                : dNoteTextColor(sheetContext),
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_circle, color: catColor)
                            : null,
                        onTap: () {
                          Navigator.pop(sheetContext);
                          assignCategory(cat);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
              if (currentCategory != null && currentCategory.isNotEmpty) ...[
                Divider(color: Theme.of(sheetContext).dividerColor, height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.label_off_outlined,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Mevcut Kategoriyi Kaldır',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    assignCategory(null);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Not ayrıntılarını gösteren dialog
  void _showNoteDetails(int noteIndex) {
    if (noteIndex < 0 || noteIndex >= _notes.length) return;
    final note = _notes[noteIndex];

    String formatDetailDate(String? rawDate) {
      if (rawDate == null || rawDate.isEmpty) return 'Bilinmiyor';
      try {
        final dt = DateTime.parse(rawDate);
        final day = dt.day.toString().padLeft(2, '0');
        final month = dt.month.toString().padLeft(2, '0');
        final hour = dt.hour.toString().padLeft(2, '0');
        final minute = dt.minute.toString().padLeft(2, '0');
        return '$day.$month.${dt.year} $hour:$minute';
      } catch (_) {
        return rawDate;
      }
    }

    final content = ContentBlocks.plainText(note['content'] as String?);
    final charCount = content.length;
    final wordCount = content.isEmpty
        ? 0
        : content.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

    final createdStr = formatDetailDate(note['createdDate'] as String?);
    final modifiedStr = formatDetailDate(note['modifiedDate'] as String?);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dNoteCardColor(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.lightBlueAccent, size: 22),
            const SizedBox(width: 10),
            Text(
              'Ayrıntılar',
              style: TextStyle(
                color: dNoteTextColor(ctx),
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow(
                Icons.calendar_today_outlined,
                Colors.amber,
                'Oluşturulma',
                createdStr,
              ),
              const SizedBox(height: 14),
              _detailRow(
                Icons.edit_calendar_outlined,
                Colors.greenAccent,
                'Son Düzenleme',
                modifiedStr,
              ),
              const SizedBox(height: 14),
              _detailRow(
                Icons.abc_outlined,
                Colors.purpleAccent,
                'Karakter Sayısı',
                '$charCount karakter',
              ),
              const SizedBox(height: 14),
              _detailRow(
                Icons.text_fields_outlined,
                Colors.cyanAccent,
                'Kelime Sayısı',
                '$wordCount kelime',
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Tamam',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(
    IconData icon,
    Color iconColor,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: dNoteTextColor(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Güncellenmiş: not eylemleri (kilitle/kilidi kaldır dahil)
  void _showNoteActions(BuildContext ctx, int noteIndex, bool isTrash) {
    if (noteIndex < 0 || noteIndex >= _notes.length) return;
    final isFavorite = _notes[noteIndex]['isFavorite'] == true;
    final isArchived = _notes[noteIndex]['isArchived'] == true;
    final isLocked = _notes[noteIndex]['isLocked'] == true;

    final actions = [
      {
        'icon': isFavorite ? Icons.star : Icons.star_outline,
        'label': isFavorite ? 'Favoriden Çıkar' : 'Favori',
        'color': Colors.amber,
        'key': 'favorite',
      },
      {
        'icon': isLocked ? Icons.lock_open : Icons.lock_outline,
        'label': isLocked ? 'Kilidi Kaldır' : 'Kilitle',
        'color': Colors.blueGrey,
        'key': 'lock',
      },
      {
        'icon': isArchived ? Icons.unarchive_outlined : Icons.archive_outlined,
        'label': isArchived ? 'Arşivden Çıkar' : 'Arşiv',
        'color': Colors.teal,
        'key': 'archive',
      },
      {
        'icon': Icons.label_outline,
        'label': 'Sınıflandır',
        'color': Colors.purple,
        'key': 'classify',
      },
      {
        'icon': Icons.delete_outline,
        'label': 'Sil',
        'color': Colors.red,
        'key': 'delete',
      },
      {
        'icon': Icons.share_outlined,
        'label': 'Paylaş',
        'color': Colors.blue,
        'key': 'share',
      },
      {
        'icon': Icons.copy_all_outlined,
        'label': 'Kopya Oluştur',
        'color': Colors.green,
        'key': 'duplicate',
      },
      {
        'icon': Icons.content_paste,
        'label': 'İçeriği Kopyala',
        'color': Colors.cyan,
        'key': 'copy_text',
      },
      {
        'icon': Icons.text_fields,
        'label': 'Metin Boyutu',
        'color': Colors.pink,
        'key': 'text_size',
      },
      {
        'icon': Icons.info_outline,
        'label': 'Ayrıntılar',
        'color': Colors.lightBlueAccent,
        'key': 'details',
      },
    ];

    showModalBottomSheet(
      context: ctx,
      backgroundColor: Theme.of(context).cardColor,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Eylem Seç',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.95,
                ),
                itemCount: actions.length,
                itemBuilder: (_, i) {
                  final action = actions[i];
                  return GestureDetector(
                    onTap: () async {
                      final key = action['key'] as String;
                      Navigator.pop(ctx);
                      if (noteIndex < 0) return;

                      if (key == 'favorite') {
                        setState(() {
                          _notes[noteIndex]['isFavorite'] =
                              !(_notes[noteIndex]['isFavorite'] == true);
                        });
                        _saveData();
                      } else if (key == 'archive') {
                        setState(() {
                          _notes[noteIndex]['isArchived'] =
                              !(_notes[noteIndex]['isArchived'] == true);
                        });
                        _saveData();
                      } else if (key == 'delete') {
                        _deleteNote(noteIndex);
                      } else if (key == 'classify') {
                        _showClassifyDialog(noteIndex);
                      } else if (key == 'duplicate') {
                        await _duplicateNote(noteIndex);
                      } else if (key == 'share') {
                        final note = _notes[noteIndex];
                        final title = (note['title'] ?? '').toString().trim();
                        final content = ContentBlocks.plainText(
                          note['content'] as String?,
                        );
                        final text = [
                          if (title.isNotEmpty) title,
                          if (content.isNotEmpty) content,
                        ].join('\n\n');
                        if (text.isNotEmpty) {
                          await SharePlus.instance.share(
                            ShareParams(text: text),
                          );
                        }
                      } else if (key == 'copy_text') {
                        _copyNoteContent(noteIndex);
                      } else if (key == 'text_size') {
                        _showTextSizeSlider(noteIndex);
                      } else if (key == 'lock') {
                        final currentlyLocked =
                            _notes[noteIndex]['isLocked'] == true;
                        if (currentlyLocked) {
                          setState(() => _notes[noteIndex]['isLocked'] = false);
                          _saveData();
                          _showInfoBar('Kilidi kaldırıldı');
                        } else {
                          if (!_notePasswordEnabled) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Önce Ayarlar > Not Şifresi ile parola belirleyin.',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          setState(() => _notes[noteIndex]['isLocked'] = true);
                          _saveData();
                          _showInfoBar('Not kilitlendi');
                        }
                      } else if (key == 'details') {
                        _showNoteDetails(noteIndex);
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: dNoteSurfaceVariant(context),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            action['icon'] as IconData,
                            color: action['color'] as Color,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          action['label'] as String,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _saveNoteIfValid(
    int? index,
    String noteType,
    List<Map<String, dynamic>> checkItems, [
    List<Map<String, dynamic>> attachments = const [],
    List<Map<String, dynamic>> blocks = const [],
    DateTime? reminder,
  ]) {
    final isValid =
        (noteType == 'text'
            ? ContentBlocks.hasAnyContent(blocks)
            : checkItems.any((e) => (e['text'] as String).trim().isNotEmpty)) ||
        attachments.isNotEmpty;

    if (isValid) {
      if (index != null) {
        // Mevcut bir not düzenleniyor: gerçekten bir değişiklik olup
        // olmadığını kontrol et. Değişiklik yoksa (not sadece açılıp
        // kapatıldıysa) modifiedDate güncellenmemeli, yoksa not "son
        // düzenleme" sıralamasında haksız yere başa taşınır.
        final newTitle = _capitalizeFirstLetterTr(_titleController.text.trim());
        final newContent = noteType == 'text'
            ? ContentBlocks.serialize(blocks)
            : '';
        final newCheckItems = noteType == 'checklist'
            ? checkItems
            : <Map<String, dynamic>>[];

        final oldTitle = (_notes[index]['title'] ?? '').toString();
        final oldContent = (_notes[index]['content'] ?? '').toString();
        final oldType = (_notes[index]['type'] ?? 'text').toString();
        final oldCheckItemsRaw = _notes[index]['checkItems'];
        final oldCheckItems = oldCheckItemsRaw is List
            ? List<Map<String, dynamic>>.from(
                oldCheckItemsRaw.map((e) => Map<String, dynamic>.from(e)),
              )
            : <Map<String, dynamic>>[];

        final checkItemsChanged =
            newCheckItems.length != oldCheckItems.length ||
            List.generate(newCheckItems.length, (i) {
              final a = newCheckItems[i];
              final b = oldCheckItems[i];
              return a['text'] != b['text'] || a['checked'] != b['checked'];
            }).any((changed) => changed);

        final oldAttachmentsRaw = _notes[index]['attachments'];
        final oldAttachmentIds = oldAttachmentsRaw is List
            ? oldAttachmentsRaw.map((e) => (e as Map)['id']).toList()
            : <dynamic>[];
        final newAttachmentIds = attachments.map((e) => e['id']).toList();
        final attachmentsChanged =
            oldAttachmentIds.length != newAttachmentIds.length ||
            !List.generate(
              newAttachmentIds.length,
              (i) => oldAttachmentIds[i] == newAttachmentIds[i],
            ).every((same) => same);

        final contentChanged = noteType == 'text'
            ? !ContentBlocks.equalsStoredContent(blocks, oldContent)
            : newContent != oldContent;

        final oldReminderRaw = _notes[index]['reminderDate']?.toString();
        final newReminderRaw = reminder?.toIso8601String();
        final reminderChanged = oldReminderRaw != newReminderRaw;

        final hasChanges =
            newTitle != oldTitle ||
            contentChanged ||
            noteType != oldType ||
            checkItemsChanged ||
            attachmentsChanged ||
            reminderChanged;

        if (!hasChanges) return false;

        final currentRawTime = DateTime.now().toString();
        final noteId = (_notes[index]['id'] ?? currentRawTime).toString();
        setState(() {
          _notes[index] = {
            ..._notes[index],
            'title': newTitle,
            'content': newContent,
            'checkItems': newCheckItems,
            'attachments': attachments,
            'modifiedDate': currentRawTime,
            'type': noteType,
            'reminderDate': newReminderRaw,
          };
        });
        _saveData();
        if (reminderChanged) {
          if (reminder != null) {
            final preview = ContentBlocks.plainText(newContent);
            ReminderService.instance.schedule(
              noteId: noteId,
              title: newTitle.isEmpty ? 'Hatırlatıcı' : newTitle,
              body: noteType == 'checklist'
                  ? 'Kontrol listeni kontrol etmeyi unutma'
                  : (preview.isEmpty ? 'Notunu kontrol etmeyi unutma' : preview),
              dateTime: reminder,
            );
          } else {
            ReminderService.instance.cancel(noteId);
          }
        }
        return true;
      } else {
        final currentRawTime = DateTime.now().toString();
        final newTitle = _capitalizeFirstLetterTr(_titleController.text.trim());
        setState(() {
          _notes.add({
            'id': currentRawTime,
            'title': newTitle,
            'content': noteType == 'text'
                ? ContentBlocks.serialize(blocks)
                : '',
            'checkItems': noteType == 'checklist' ? checkItems : [],
            'attachments': attachments,
            'date': _getFormattedDate(),
            'createdDate': currentRawTime,
            'modifiedDate': currentRawTime,
            'category':
                (_activeCategory == 'Tümü' ||
                    _activeCategory == '__favorites__' ||
                    _activeCategory == '__locked__' ||
                    _activeCategory == '__archive__' ||
                    _activeCategory == '__trash__' ||
                    _activeCategory == '__reminders__')
                ? null
                : _activeCategory,
            'color': 'Amber',
            'type': noteType,
            'isFavorite': _activeCategory == '__favorites__',
            'isLocked': _activeCategory == '__locked__',
            'isArchived': _activeCategory == '__archive__',
            'reminderDate': reminder?.toIso8601String(),
          });
        });
        _saveData();
        if (reminder != null) {
          final preview = ContentBlocks.plainText(
            noteType == 'text' ? ContentBlocks.serialize(blocks) : '',
          );
          ReminderService.instance.schedule(
            noteId: currentRawTime,
            title: newTitle.isEmpty ? 'Hatırlatıcı' : newTitle,
            body: noteType == 'checklist'
                ? 'Kontrol listeni kontrol etmeyi unutma'
                : (preview.isEmpty ? 'Notunu kontrol etmeyi unutma' : preview),
            dateTime: reminder,
          );
        }
        return true;
      }
    }
    return false;
  }

  Future<bool> _handleBackPress() async {
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Çıkmak için tekrar geri tuşuna basın',
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF424242),
          ),
        );
      }
      return false;
    }
    SystemNavigator.pop();
    return true;
  }

  // ── Ek (fotoğraf/belge) IZGARASI ────────────────────────────────────────
  // Tek ek varsa tam genişlikte, 2+ ek varsa 2 sütunlu ızgara (grid) olarak
  // gösterilir. Aralarında çok az boşluk bırakılır. Hem not düzenleme
  // ekranındaki metin içi eklerde, hem de kontrol listesi (checklist)
  // eklerinde kullanılır.
  // ── PDF ilk sayfa küçük resmi (thumbnail) ──────────────────────────────
  // Aynı dosya için tekrar tekrar render etmemek için sonuçlar bellekte
  // (uygulama açıkken) önbelleğe alınır.
  static final Map<String, Uint8List> _pdfThumbCache = {};

  Future<Uint8List?> _getPdfThumbnail(String filePath) async {
    if (_pdfThumbCache.containsKey(filePath)) {
      return _pdfThumbCache[filePath];
    }
    PdfDocument? doc;
    PdfPage? page;
    try {
      doc = await PdfDocument.openFile(filePath);
      page = await doc.getPage(1);
      final image = await page.render(
        width: page.width * 1.6,
        height: page.height * 1.6,
        format: PdfPageImageFormat.jpeg,
        backgroundColor: '#FFFFFF',
      );
      if (image != null) {
        _pdfThumbCache[filePath] = image.bytes;
        return image.bytes;
      }
    } catch (_) {
      // PDF açılamadı/bozuk -> yedek (fallback) ikon gösterilecek.
    } finally {
      await page?.close();
      await doc?.close();
    }
    return null;
  }

  // Görsel olmayan eklerin türüne göre önizlemesi: PDF için gerçek ilk
  // sayfa küçük resmi, XLSX/XLS için belirgin yeşil tablo ikonu, diğer
  // dosya türleri için genel amber belge ikonu.
  Widget _buildDocPreview(Map<String, dynamic> att, String filePath) {
    final fileName = (att['fileName'] ?? '').toString();
    final ext = p.extension(fileName).toLowerCase();

    if (ext == '.pdf') {
      return FutureBuilder<Uint8List?>(
        future: _getPdfThumbnail(filePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.memory(snapshot.data!, fit: BoxFit.cover),
                Positioned(
                  left: 4,
                  bottom: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'PDF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return _docFallback(fileName, Icons.picture_as_pdf, Colors.red.shade400);
        },
      );
    }

    if (ext == '.xlsx' || ext == '.xls') {
      return _docFallback(fileName, Icons.table_chart, Colors.green.shade400);
    }

    return _docFallback(fileName, Icons.insert_drive_file_outlined, Colors.amber);
  }

  Widget _docFallback(String fileName, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(
            fileName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentGrid({
    required List<String> ids,
    required List<Map<String, dynamic>> attachmentsList,
    required void Function(String id) onRemove,
    required void Function(Map<String, dynamic> att) onOpen,
    required String? deletingId,
    required void Function(String? id) onDeletingIdChanged,
  }) {
    final items = ids
        .map(
          (id) => attachmentsList.firstWhere(
            (a) => a['id'] == id,
            orElse: () => <String, dynamic>{},
          ),
        )
        .where((a) => a.isNotEmpty)
        .toList();
    if (items.isEmpty) return const SizedBox.shrink();

    return FutureBuilder<String>(
      future: DBHelper.instance.attachmentsDir().then((d) => d.path),
      builder: (context, snapshot) {
        final dirPath = snapshot.data;
        if (dirPath == null) return const SizedBox.shrink();
        return LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 4.0;
            final singleFull = items.length == 1;
            final itemWidth = singleFull
                ? constraints.maxWidth
                : (constraints.maxWidth - spacing) / 2;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: items.map((att) {
                final isImage = att['isImage'] == true;
                final filePath = p.join(dirPath, att['storedName'].toString());
                final preview = isImage
                    ? Image.file(
                        File(filePath),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey,
                        ),
                      )
                    : _buildDocPreview(att, filePath);
                return _AttachmentTile(
                  width: itemWidth,
                  height: singleFull ? 220 : itemWidth,
                  preview: preview,
                  showDelete: deletingId == att['id'].toString(),
                  onOpen: () => onOpen(att),
                  onRemove: () => onRemove(att['id'].toString()),
                  onLongPress: () => onDeletingIdChanged(att['id'].toString()),
                  onDismissDelete: () => onDeletingIdChanged(null),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  void _showNoteDialog({int? index, String type = 'text'}) {
    String noteDate = "";
    String noteType = type;
    List<Map<String, dynamic>> checkItems = [];
    List<TextEditingController> checkControllers = [];
    List<FocusNode> checkFocusNodes = [];
    List<Map<String, dynamic>> attachments = [];
    int? newlyAddedIndex; // hangi maddeye autofocus verilecek
    String? noteCategory;
    // Basılı tutulunca sil ikonu gösterilen ekin id'si (aynı anda tek ek).
    String? deletingAttachmentId;
    // Hatırlatıcı: notun bildirim ile hatırlatılacağı tarih/saat (yoksa null).
    DateTime? noteReminder;

    // ── İçerik blokları (metin + araya eklenen fotoğraf/belge grupları) ──
    List<Map<String, dynamic>> blocks = [];
    List<TextEditingController?> blockControllers = [];
    List<FocusNode?> blockFocusNodes = [];
    int focusedBlockIndex = 0;

    // Blok listesi değiştiğinde (ekleme/silme/birleştirme) controller ve
    // focus node'ları tamamen yeniden kurar. Metin bloğu olmayan (ek)
    // konumlar için null tutulur.
    void rebuildBlockControllers() {
      for (final c in blockControllers) {
        c?.dispose();
      }
      for (final f in blockFocusNodes) {
        f?.dispose();
      }
      blockControllers = [];
      blockFocusNodes = [];
      for (int i = 0; i < blocks.length; i++) {
        if (blocks[i]['type'] == 'text') {
          final ctrl = TextEditingController(
            text: (blocks[i]['text'] ?? '').toString(),
          );
          final fn = FocusNode();
          final capturedIndex = i;
          fn.addListener(() {
            if (fn.hasFocus) focusedBlockIndex = capturedIndex;
          });
          blockControllers.add(ctrl);
          blockFocusNodes.add(fn);
        } else {
          blockControllers.add(null);
          blockFocusNodes.add(null);
        }
      }
    }

    void syncControllersAndFocusNodes() {
      // controller ve focusnode sayısını checkItems ile eşitle
      while (checkControllers.length < checkItems.length) {
        final idx = checkControllers.length;
        checkControllers.add(
          TextEditingController(text: checkItems[idx]['text'] as String? ?? ''),
        );
        checkFocusNodes.add(FocusNode());
      }
      while (checkControllers.length > checkItems.length) {
        checkControllers.removeLast().dispose();
        checkFocusNodes.removeLast().dispose();
      }
    }

    if (index != null) {
      _titleController.text = _notes[index]['title'] ?? '';
      noteDate = _notes[index]['date'] ?? "";
      noteType = _notes[index]['type'] ?? 'text';
      noteCategory = _notes[index]['category'] as String?;
      final rawReminder = _notes[index]['reminderDate'];
      if (rawReminder != null && rawReminder.toString().isNotEmpty) {
        noteReminder = DateTime.tryParse(rawReminder.toString());
      }
      if (noteType == 'checklist') {
        final raw = _notes[index]['checkItems'];
        if (raw != null) {
          checkItems = List<Map<String, dynamic>>.from(
            (raw as List).map((e) => Map<String, dynamic>.from(e)),
          );
        }
      }
      final rawAttachments = _notes[index]['attachments'];
      if (rawAttachments != null) {
        attachments = List<Map<String, dynamic>>.from(
          (rawAttachments as List).map((e) => Map<String, dynamic>.from(e)),
        );
      }
      blocks = ContentBlocks.parse(_notes[index]['content'] as String?);
    } else {
      _titleController.clear();
      blocks = [
        {'type': 'text', 'text': ''},
      ];
      if (noteType == 'checklist') {
        checkItems = [
          {'text': '', 'checked': false},
        ];
        newlyAddedIndex = 0;
      }
    }
    syncControllersAndFocusNodes();
    rebuildBlockControllers();

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              // Verilen dosya yollarını (path) ekler klasörüne kopyalar,
              // attachments listesine ekler ve (metin notuysa) imlecin
              // bulunduğu yere gömer. pickAttachments / galeri / kamera
              // akışlarının ortak son adımıdır.
              Future<void> addFilesAsAttachments(
                List<Map<String, String>> files,
              ) async {
                if (files.isEmpty) return;
                final dir = await DBHelper.instance.attachmentsDir();
                final newOnes = <Map<String, dynamic>>[];
                for (final f in files) {
                  final srcPath = f['path'];
                  if (srcPath == null || srcPath.isEmpty) continue;
                  final srcFile = File(srcPath);
                  final name = (f['name'] != null && f['name']!.isNotEmpty)
                      ? f['name']!
                      : p.basename(srcPath);
                  final ext = p.extension(name);
                  final uniqueId =
                      '${DateTime.now().microsecondsSinceEpoch}_${newOnes.length}';
                  final storedName = '$uniqueId$ext';
                  int sizeBytes = 0;
                  try {
                    await srcFile.copy(p.join(dir.path, storedName));
                    sizeBytes = await srcFile.length();
                  } catch (_) {
                    continue;
                  }
                  final isImage = const [
                    '.jpg',
                    '.jpeg',
                    '.png',
                    '.gif',
                    '.webp',
                    '.bmp',
                  ].contains(ext.toLowerCase());
                  newOnes.add({
                    'id': uniqueId,
                    'fileName': name,
                    'storedName': storedName,
                    'sizeBytes': sizeBytes,
                    'isImage': isImage,
                  });
                }
                if (newOnes.isNotEmpty) {
                  final newIds = newOnes
                      .map((e) => e['id'].toString())
                      .toList();
                  setModalState(() {
                    attachments.addAll(newOnes);
                    if (noteType == 'text') {
                      // İmlecin bulunduğu metin bloğunu bul; imleç orada
                      // yoksa son metin bloğuna eklenir.
                      int idx = focusedBlockIndex;
                      if (idx < 0 ||
                          idx >= blocks.length ||
                          blocks[idx]['type'] != 'text') {
                        idx = blocks.lastIndexWhere(
                          (b) => b['type'] == 'text',
                        );
                        if (idx == -1) {
                          blocks.add({'type': 'text', 'text': ''});
                          idx = blocks.length - 1;
                        }
                      }
                      final controller = blockControllers[idx];
                      final text =
                          controller?.text ??
                          (blocks[idx]['text'] ?? '').toString();
                      int offset = controller?.selection.baseOffset ?? -1;
                      if (offset < 0 || offset > text.length) {
                        offset = text.length;
                      }
                      final leftText = text.substring(0, offset);
                      final rightText = text.substring(offset);

                      if (leftText.trim().isEmpty &&
                          idx > 0 &&
                          blocks[idx - 1]['type'] == 'attachments') {
                        // Önceki blok zaten bir ek grubu: yeni ekleri oraya
                        // ekle, bu metin bloğunu (sağ kalan) koru.
                        (blocks[idx - 1]['ids'] as List).addAll(newIds);
                        blocks[idx]['text'] = rightText;
                      } else if (rightText.trim().isEmpty &&
                          idx < blocks.length - 1 &&
                          blocks[idx + 1]['type'] == 'attachments') {
                        // Sonraki blok zaten bir ek grubu: yeni ekleri oraya
                        // ekle, bu metin bloğunu (sol kalan) koru.
                        (blocks[idx + 1]['ids'] as List).addAll(newIds);
                        blocks[idx]['text'] = leftText;
                      } else {
                        blocks[idx]['text'] = leftText;
                        blocks.insert(idx + 1, {
                          'type': 'attachments',
                          'ids': newIds,
                        });
                        blocks.insert(idx + 2, {
                          'type': 'text',
                          'text': rightText,
                        });
                        focusedBlockIndex = idx + 2;
                      }
                      rebuildBlockControllers();
                      // Yeni imleç konumunu (sağ kalan metnin başına) ayarla.
                      final newFocusIdx = focusedBlockIndex.clamp(
                        0,
                        blockControllers.length - 1,
                      );
                      final newCtrl = blockControllers[newFocusIdx];
                      if (newCtrl != null) {
                        newCtrl.selection = TextSelection.collapsed(
                          offset: 0,
                        );
                      }
                    }
                  });
                }
              }

              Future<void> pickAttachments() async {
                final result = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  type: FileType.any,
                );
                if (result == null) return;
                final files = result.files
                    .where((f) => f.path != null)
                    .map((f) => {'path': f.path!, 'name': f.name})
                    .toList();
                await addFilesAsAttachments(files);
              }

              // Telefondaki fotoğraflar arasından (sadece görseller, temel
              // albümler görünümü) birden fazla görsel seçilmesini sağlar.
              Future<void> pickImagesFromGallery() async {
                final picker = ImagePicker();
                final images = await picker.pickMultiImage();
                if (images.isEmpty) return;
                final files = images
                    .map((x) => {'path': x.path, 'name': x.name})
                    .toList();
                await addFilesAsAttachments(files);
              }

              // Telefonun kamerasını açıp çekilen fotoğrafı eklere ekler.
              Future<void> pickImageFromCamera() async {
                final picker = ImagePicker();
                final photo = await picker.pickImage(
                  source: ImageSource.camera,
                );
                if (photo == null) return;
                await addFilesAsAttachments([
                  {'path': photo.path, 'name': photo.name},
                ]);
              }

              // Kontrol listesi (checklist) notlarında, ekler ayrı bir
              // liste halinde altta gösterilir; index'e göre kaldırılır.
              void removeAttachment(int i) {
                final att = attachments[i];
                final storedName = att['storedName']?.toString();
                if (storedName != null) {
                  DBHelper.instance.deleteAttachmentFile(storedName);
                }
                setModalState(() {
                  attachments.removeAt(i);
                  deletingAttachmentId = null;
                });
              }

              // Serbest metin notlarında, imlecin bulunduğu yere gömülü
              // eklerden birini kaldırır; ek grubu boşalırsa komşu metin
              // blokları birleştirilir.
              void removeAttachmentById(String id) {
                final gi = attachments.indexWhere((a) => a['id'] == id);
                if (gi != -1) {
                  final storedName = attachments[gi]['storedName']
                      ?.toString();
                  if (storedName != null) {
                    DBHelper.instance.deleteAttachmentFile(storedName);
                  }
                }
                setModalState(() {
                  deletingAttachmentId = null;
                  if (gi != -1) attachments.removeAt(gi);
                  for (int i = 0; i < blocks.length; i++) {
                    if (blocks[i]['type'] != 'attachments') continue;
                    final ids = List<String>.from(blocks[i]['ids'] ?? const []);
                    if (!ids.remove(id)) continue;
                    if (ids.isEmpty) {
                      final prevIsText =
                          i > 0 && blocks[i - 1]['type'] == 'text';
                      final nextIsText =
                          i < blocks.length - 1 &&
                          blocks[i + 1]['type'] == 'text';
                      if (prevIsText && nextIsText) {
                        final mergedText =
                            ((blocks[i - 1]['text'] ?? '').toString()) +
                            ((blocks[i + 1]['text'] ?? '').toString());
                        blocks[i - 1]['text'] = mergedText;
                        blocks.removeAt(i + 1);
                        blocks.removeAt(i);
                      } else {
                        blocks.removeAt(i);
                      }
                    } else {
                      blocks[i]['ids'] = ids;
                    }
                    break;
                  }
                  if (blocks.isEmpty) {
                    blocks.add({'type': 'text', 'text': ''});
                  }
                  rebuildBlockControllers();
                });
              }

              Future<void> openAttachment(Map<String, dynamic> att) async {
                final dir = await DBHelper.instance.attachmentsDir();
                final path = p.join(dir.path, att['storedName'].toString());
                if (att['isImage'] == true) {
                  if (!context.mounted) return;
                  showDialog(
                    context: context,
                    barrierColor: Colors.black.withValues(alpha: 0.9),
                    builder: (dialogCtx) => Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: const EdgeInsets.all(8),
                      child: Stack(
                        children: [
                          InteractiveViewer(
                            child: Image.file(File(path), fit: BoxFit.contain),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(dialogCtx),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  await OpenFile.open(path);
                }
              }

              final catColor = _getCategoryColor(noteCategory);
              final isDark =
                  ThemeData.estimateBrightnessForColor(catColor) ==
                  Brightness.dark;
              SystemChrome.setSystemUIOverlayStyle(
                dNoteSystemBarsStyle(
                  context,
                  statusBarColor: catColor,
                  statusBarIconBrightnessOverride: isDark
                      ? Brightness.light
                      : Brightness.dark,
                ),
              );
              return PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                  if (deletingAttachmentId != null) {
                    setModalState(() => deletingAttachmentId = null);
                    return;
                  }
                  final saved = _saveNoteIfValid(index, noteType, checkItems, attachments, blocks, noteReminder);
                  SystemChrome.setSystemUIOverlayStyle(
                    dNoteSystemBarsStyle(context),
                  );
                  if (saved) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Not kaydedildi ✓',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: const Color(0xFF3D3D3D),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.04,
                          left: 60,
                          right: 60,
                        ),
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
                child: Scaffold(
                  backgroundColor: Theme.of(context).cardColor,
                  resizeToAvoidBottomInset: true,
                  appBar: AppBar(
                    backgroundColor: dNoteHeaderColor(context),
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () {
                        if (deletingAttachmentId != null) {
                          setModalState(() => deletingAttachmentId = null);
                          return;
                        }
                        final saved = _saveNoteIfValid(
                          index,
                          noteType,
                          checkItems,
                          attachments,
                          blocks,
                          noteReminder,
                        );
                        SystemChrome.setSystemUIOverlayStyle(
                          dNoteSystemBarsStyle(context),
                        );
                        if (saved) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Not kaydedildi ✓',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: const Color(0xFF3D3D3D),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.04,
                                left: 60,
                                right: 60,
                              ),
                            ),
                          );
                        }
                        Navigator.pop(context);
                      },
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(
                          noteReminder != null
                              ? Icons.notifications_active
                              : Icons.notifications_none,
                          color: noteReminder != null
                              ? Colors.amber
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                        tooltip: 'Hatırlatıcı',
                        onPressed: () async {
                          final now = DateTime.now();
                          final initialDate = noteReminder ?? now.add(
                            const Duration(hours: 1),
                          );
                          if (noteReminder != null) {
                            final action = await showModalBottomSheet<String>(
                              context: context,
                              backgroundColor: dNoteCardColor(context),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              builder: (sheetCtx) => SafeArea(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                        Icons.edit_calendar,
                                        color: Colors.amber,
                                      ),
                                      title: const Text('Hatırlatıcıyı değiştir'),
                                      onTap: () =>
                                          Navigator.pop(sheetCtx, 'edit'),
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.notifications_off,
                                        color: Colors.redAccent,
                                      ),
                                      title: const Text('Hatırlatıcıyı kaldır'),
                                      onTap: () =>
                                          Navigator.pop(sheetCtx, 'remove'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                            if (action == 'remove') {
                              setModalState(() => noteReminder = null);
                              return;
                            } else if (action != 'edit') {
                              return;
                            }
                          }

                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: initialDate.isBefore(now)
                                ? now
                                : initialDate,
                            firstDate: now,
                            lastDate: now.add(const Duration(days: 3650)),
                          );
                          if (pickedDate == null) return;
                          if (!context.mounted) return;
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(initialDate),
                          );
                          if (pickedTime == null) return;
                          final combined = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          if (combined.isBefore(DateTime.now())) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Geçmiş bir zaman seçilemez',
                                ),
                              ),
                            );
                            return;
                          }
                          setModalState(() => noteReminder = combined);
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  bottomNavigationBar: SafeArea(
                    child: Builder(
                      builder: (context) {
                        final Color barColor;
                        if (_colorfulNotes && index != null && index! >= 0) {
                          barColor =
                              _categoryPalette[index! % _categoryPalette.length]
                                  .withValues(alpha: 0.75);
                        } else {
                          barColor = _getCategoryColor(noteCategory);
                        }
                        return Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: dNoteHeaderColor(context),
                            border: Border(
                              top: BorderSide(color: barColor, width: 3),
                            ),
                          ),
                          child: Row(
                            children: [
                              PopupMenuButton<String>(
                                icon: Icon(
                                  Icons.add,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                onSelected: (value) {
                                  if (value == 'file') {
                                    pickAttachments();
                                  } else if (value == 'image') {
                                    pickImagesFromGallery();
                                  } else if (value == 'camera') {
                                    pickImageFromCamera();
                                  }
                                },
                                itemBuilder: (_) => [
                                  const PopupMenuItem(
                                    value: 'image',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.image_outlined,
                                          color: Colors.blueAccent,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Görsel Ekle',
                                        ),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'camera',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.tealAccent,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Kamera',
                                        ),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'file',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.attach_file,
                                          color: Colors.orange,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Dosya Ekle',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      index != null
                                          ? (noteDate.isNotEmpty
                                                ? noteDate
                                                : _getFormattedDate())
                                          : _getFormattedDate(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: barColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (noteReminder != null)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            color: Colors.amber,
                                            size: 12,
                                          ),
                                          const SizedBox(width: 3),
                                          Flexible(
                                            child: Text(
                                              _formatDateTimeTr(noteReminder!),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.amber,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                onPressed: () => _showNoteActions(
                                  context,
                                  index ?? -1,
                                  false,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  body: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (deletingAttachmentId != null) {
                        setModalState(() => deletingAttachmentId = null);
                      }
                    },
                    child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          selectionWidthStyle: ui.BoxWidthStyle.tight,
                          contextMenuBuilder: buildCustomContextMenu,
                          selectionHeightStyle: ui.BoxHeightStyle.max,
                          controller: _titleController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Başlık',
                            hintStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: dNoteBorderColor(context),
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber),
                            ),
                          ),
                          style: TextStyle(
                            color: dNoteEffectiveTextColor(context, _textColor),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (noteType == 'text')
                          ...List.generate(blocks.length, (i) {
                            final block = blocks[i];
                            if (block['type'] == 'attachments') {
                              final ids = List<String>.from(
                                block['ids'] ?? const [],
                              );
                              return Padding(
                                key: ValueKey('blk_att_$i'),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: _buildAttachmentGrid(
                                  ids: ids,
                                  attachmentsList: attachments,
                                  onRemove: removeAttachmentById,
                                  onOpen: openAttachment,
                                  deletingId: deletingAttachmentId,
                                  onDeletingIdChanged: (id) => setModalState(
                                    () => deletingAttachmentId = id,
                                  ),
                                ),
                              );
                            }
                            return TextField(
                              key: ValueKey('blk_text_$i'),
                              selectionWidthStyle: ui.BoxWidthStyle.tight,
                              contextMenuBuilder: buildCustomContextMenu,
                              selectionHeightStyle: ui.BoxHeightStyle.max,
                              controller: blockControllers[i],
                              focusNode: blockFocusNodes[i],
                              autofocus: i == 0 && index == null,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                hintText: i == 0
                                    ? 'Notunuzu buraya yazın...'
                                    : null,
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                color: dNoteEffectiveTextColor(context, _textColor),
                                fontSize: index != null
                                    ? ((_notes[index!]['fontSize'] as num?)
                                              ?.toDouble() ??
                                          _globalFontSize)
                                    : _globalFontSize,
                                height: 1.6,
                              ),
                              onChanged: (val) => block['text'] = val,
                              onTap: () => focusedBlockIndex = i,
                            );
                          })
                        else ...[
                          ...checkItems.asMap().entries.map((entry) {
                            final i = entry.key;
                            final item = entry.value;
                            return Row(
                              children: [
                                Checkbox(
                                  value: item['checked'] as bool,
                                  activeColor: Colors.amber,
                                  onChanged: (val) {
                                    setModalState(() {
                                      checkItems[i]['checked'] = val ?? false;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: TextField(
                                    selectionWidthStyle: ui.BoxWidthStyle.tight,
                                    controller: checkControllers[i],
                                    focusNode: checkFocusNodes[i],
                                    autofocus: newlyAddedIndex == i,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    contextMenuBuilder: buildCustomContextMenu,
                                    selectionHeightStyle: ui.BoxHeightStyle.max,
                                    style: TextStyle(
                                      color: dNoteEffectiveTextColor(context, _textColor),
                                      fontSize: 16,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Madde...',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (val) {
                                      checkItems[i]['text'] = val;
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
                                    setModalState(() {
                                      checkItems.removeAt(i);
                                      checkControllers.removeAt(i).dispose();
                                      checkFocusNodes.removeAt(i).dispose();
                                      newlyAddedIndex = null;
                                    });
                                  },
                                ),
                              ],
                            );
                          }),
                          TextButton.icon(
                            onPressed: () {
                              setModalState(() {
                                checkItems.add({'text': '', 'checked': false});
                                checkControllers.add(TextEditingController());
                                checkFocusNodes.add(FocusNode());
                                newlyAddedIndex = checkItems.length - 1;
                              });
                              // Kısa gecikmeyle focus ver (widget build olduktan sonra)
                              Future.microtask(() {
                                checkFocusNodes.last.requestFocus();
                              });
                            },
                            icon: const Icon(Icons.add, color: Colors.amber),
                            label: const Text(
                              'Madde Ekle',
                              style: TextStyle(color: Colors.amber),
                            ),
                          ),
                        ],
                        if (noteType != 'text' && attachments.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          FutureBuilder<String>(
                            future: DBHelper.instance.attachmentsDir().then(
                              (d) => d.path,
                            ),
                            builder: (context, snapshot) {
                              final dirPath = snapshot.data;
                              if (dirPath == null) {
                                return const SizedBox.shrink();
                              }
                              return Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: List.generate(attachments.length, (
                                  i,
                                ) {
                                  final att = attachments[i];
                                  final isImage = att['isImage'] == true;
                                  final filePath = p.join(
                                    dirPath,
                                    att['storedName'].toString(),
                                  );
                                  final preview = isImage
                                      ? Image.file(
                                          File(filePath),
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(
                                                Icons.broken_image_outlined,
                                                color: Colors.grey,
                                              ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons
                                                    .insert_drive_file_outlined,
                                                color: Colors.amber,
                                                size: 28,
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                (att['fileName'] ?? '')
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                  return _AttachmentTile(
                                    width: isImage ? 84 : 130,
                                    height: 84,
                                    preview: preview,
                                    showDelete:
                                        deletingAttachmentId ==
                                        att['id'].toString(),
                                    onOpen: () => openAttachment(att),
                                    onRemove: () => removeAttachment(i),
                                    onLongPress: () => setModalState(
                                      () => deletingAttachmentId =
                                          att['id'].toString(),
                                    ),
                                    onDismissDelete: () => setModalState(
                                      () => deletingAttachmentId = null,
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                        ],
                        const SizedBox(height: 20),
                        Builder(
                          builder: (context) {
                            final hasCategory =
                                noteCategory != null &&
                                noteCategory!.isNotEmpty;
                            if (!hasCategory) return const SizedBox.shrink();
                            return OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    dNoteEffectiveTextColor(context, _textColor),
                                side: BorderSide(
                                  color: dNoteBorderColor(context),
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                              ),
                              child: Text(noteCategory!),
                              onPressed: () {
                                if (index != null) {
                                  _showClassifyDialog(
                                    index!,
                                    onChanged: (cat) {
                                      setModalState(() {
                                        noteCategory = cat;
                                      });
                                    },
                                  );
                                } else {
                                  _saveNoteIfValid(index, noteType, checkItems, attachments, blocks, noteReminder);
                                  if (_notes.isNotEmpty) {
                                    final newIndex = _notes.length - 1;
                                    _showClassifyDialog(
                                      newIndex,
                                      onChanged: (cat) {
                                        setModalState(() {
                                          noteCategory = cat;
                                          index = newIndex;
                                        });
                                      },
                                    );
                                  }
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  ),
                ),
              );
            },
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredNotes;
    SystemChrome.setSystemUIOverlayStyle(dNoteSystemBarsStyle(context));
    bool isTrash = _activeCategory == '__trash__';

    if (isTrash) {
      filteredNotes = _deletedNotes.where((note) {
        final title = (note['title'] ?? '').toString().toLowerCase();
        final content = ContentBlocks.plainText(
          note['content'] as String?,
        ).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || content.contains(query);
      }).toList();
    } else {
      filteredNotes = _notes.where((note) {
        final title = (note['title'] ?? '').toString().toLowerCase();
        final content = ContentBlocks.plainText(
          note['content'] as String?,
        ).toLowerCase();
        final query = _searchQuery.toLowerCase();
        final matchesSearch = title.contains(query) || content.contains(query);
        final isArchived = note['isArchived'] == true;
        final isFavorite = note['isFavorite'] == true;
        final isLocked = note['isLocked'] == true;

        if (_activeCategory == 'Tümü' || _activeCategory == 'Notlar') {
          return matchesSearch && !isArchived && !isLocked;
        } else if (_activeCategory == '__favorites__') {
          return matchesSearch && isFavorite && !isArchived && !isLocked;
        } else if (_activeCategory == '__locked__') {
          return matchesSearch && isLocked && !isArchived;
        } else if (_activeCategory == '__archive__') {
          return matchesSearch && isArchived && !isLocked;
        } else if (_activeCategory == '__reminders__') {
          return matchesSearch &&
              _hasActiveReminder(note) &&
              !isArchived &&
              !isLocked;
        } else {
          return matchesSearch &&
              !isArchived &&
              !isLocked &&
              note['category'] == _activeCategory;
        }
      }).toList();
    }

    if (_activeCategory == '__reminders__') {
      filteredNotes.sort((a, b) {
        final aDate =
            DateTime.tryParse((a['reminderDate'] ?? '').toString()) ??
            DateTime(9999);
        final bDate =
            DateTime.tryParse((b['reminderDate'] ?? '').toString()) ??
            DateTime(9999);
        return aDate.compareTo(bDate);
      });
    } else {
      filteredNotes.sort((a, b) {
        int compareResult = 0;
        switch (_sortCriteria) {
          case "Başlık":
            compareResult = (a['title'] ?? '').toString().compareTo(
              (b['title'] ?? '').toString(),
            );
            break;
          case "Kategori":
            compareResult = (a['category'] ?? '').toString().compareTo(
              (b['category'] ?? '').toString(),
            );
            break;
          case "Renk":
            compareResult = (a['color'] ?? '').toString().compareTo(
              (b['color'] ?? '').toString(),
            );
            break;
          case "Son Düzenleme":
            compareResult = (a['modifiedDate'] ?? '').toString().compareTo(
              (b['modifiedDate'] ?? '').toString(),
            );
            break;
          case "Oluşturulma":
          default:
            compareResult = (a['createdDate'] ?? '').toString().compareTo(
              (b['createdDate'] ?? '').toString(),
            );
            break;
        }
        return _isAscending ? compareResult : -compareResult;
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_scaffoldKey.currentState?.isDrawerOpen == true) {
          _scaffoldKey.currentState?.closeDrawer();
          return;
        }
        if (_isSearching) {
          setState(() {
            _isSearching = false;
            _searchQuery = "";
            _searchController.clear();
          });
          FocusScope.of(context).unfocus();
          return;
        }

        if (_activeCategory != 'Tümü' && _activeCategory != 'Notlar') {
          setState(() {
            _activeCategory = 'Tümü';
          });
          _saveData();
          return;
        }

        await _handleBackPress();
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        drawerEdgeDragWidth: MediaQuery.of(context).size.width,
        // Menü (Drawer) açıldığında Flutter'ın varsayılan siyah yarı saydam
        // scrim'i arka planı koyulaştırıyor. Koyu temada zaten koyu bir zemin
        // üzerine bindiği için fark edilmiyordu; açık temada ise FAB gibi alt
        // bar öğelerini soluklaştırıyordu. Scrim'i kaldırarak her iki temada
        // da tutarlı, koyu temadaki gibi "silikleşmeyen" bir görünüm sağlanır.
        drawerScrimColor: Colors.transparent,
        appBar: AppBar(
          title: _isSearching
              ? TextField(
                  selectionWidthStyle: ui.BoxWidthStyle.tight,
                  controller: _searchController,
                  autofocus: true,
                  contextMenuBuilder: buildCustomContextMenu,
                  selectionHeightStyle: ui.BoxHeightStyle.max,
                  decoration: const InputDecoration(
                    hintText: 'Notlarda ara...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: const TextStyle(fontSize: 18),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                )
              : Text(
                  _getCategoryDisplayName(_activeCategory),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    fontSize: 18,
                  ),
                ),
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: Colors.amber),
          actions: [
            IconButton(
              icon: Icon(
                _isSearching ? Icons.close : Icons.search,
                color: Colors.amber,
              ),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchQuery = "";
                    _searchController.clear();
                  }
                });
              },
            ),
            if (isTrash)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.amber),
                onSelected: (String choice) {
                  if (choice == 'empty') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'Çöpü Boşalt',
                          style: TextStyle(color: Colors.amber),
                        ),
                        content: const Text(
                          'Tüm silinen notlar kalıcı olarak silinecek. Emin misiniz?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'İptal',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              for (final n in _deletedNotes) {
                                _cleanupAttachmentFiles(n);
                              }
                              setState(() {
                                _deletedNotes.clear();
                              });
                              _saveData();
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Sil',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (choice == 'restore_all') {
                    final restored = List<Map<String, dynamic>>.from(
                      _deletedNotes,
                    );
                    setState(() {
                      for (var n in _deletedNotes) {
                        n['createdDate'] = DateTime.now().toString();
                        n['modifiedDate'] = DateTime.now().toString();
                      }
                      _notes.insertAll(0, _deletedNotes);
                      _deletedNotes.clear();
                    });
                    _saveData();
                    for (final n in restored) {
                      _rescheduleNoteReminder(n);
                    }
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem(
                      value: 'empty',
                      child: Text(
                        'Çöpü Boşalt',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'restore_all',
                      child: Text(
                        'Hepsini Geri Yükle',
                        style: TextStyle(color: Colors.amber),
                      ),
                    ),
                  ];
                },
              )
            else
              PopupMenuButton<String>(
                icon: const Icon(Icons.sort, color: Colors.amber),
                tooltip: 'Notları Sırala',
                onSelected: (String choice) {
                  setState(() {
                    if (choice == "Artan") {
                      _isAscending = true;
                    } else if (choice == "Azalan") {
                      _isAscending = false;
                    } else {
                      _sortCriteria = choice;
                    }
                  });
                  _saveData();
                },
                itemBuilder: (BuildContext context) {
                  return [
                    CheckedPopupMenuItem<String>(
                      value: 'Artan',
                      checked: _isAscending,
                      child: const Text('Düzen: Artan (A-Z)'),
                    ),
                    CheckedPopupMenuItem<String>(
                      value: 'Azalan',
                      checked: !_isAscending,
                      child: const Text('Düzen: Azalan (Z-A)'),
                    ),
                    const PopupMenuDivider(),
                    CheckedPopupMenuItem<String>(
                      value: 'Başlık',
                      checked: _sortCriteria == 'Başlık',
                      child: const Text('Sırala: Başlık'),
                    ),
                    CheckedPopupMenuItem<String>(
                      value: 'Son Düzenleme',
                      checked: _sortCriteria == 'Son Düzenleme',
                      child: const Text('Sırala: Son Düzenleme'),
                    ),
                    CheckedPopupMenuItem<String>(
                      value: 'Oluşturulma',
                      checked: _sortCriteria == 'Oluşturulma',
                      child: const Text('Sırala: Oluşturulma'),
                    ),
                    CheckedPopupMenuItem<String>(
                      value: 'Kategori',
                      checked: _sortCriteria == 'Kategori',
                      child: const Text('Sırala: Kategori'),
                    ),
                  ];
                },
              ),
            IconButton(
              icon: Icon(
                _isListView ? Icons.grid_view : Icons.view_list,
                color: Colors.amber,
              ),
              tooltip: _isListView ? 'Izgara Görünümü' : 'Liste Görünümü',
              onPressed: () {
                setState(() {
                  _isListView = !_isListView;
                });
                _saveData();
              },
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SafeArea(
            top: false,
            child: Container(
              color: Theme.of(context).cardColor,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: dNoteHeaderColor(context)),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'DNote',
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Kişisel Not Defteriniz',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
                    child: Text(
                      'NOTLAR',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Container(
                    color:
                        (_activeCategory == 'Tümü' ||
                            _activeCategory == 'Notlar')
                        ? dNoteHighlight(context)
                        : Colors.transparent,
                    child: ListTile(
                      leading: const Icon(Icons.notes, color: Colors.amber),
                      title: const Text('Notlar'),
                      trailing: Text(
                        _getCountForCategory('Tümü').toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        setState(() => _activeCategory = 'Tümü');
                        _saveData();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    color: _activeCategory == '__favorites__'
                        ? dNoteHighlight(context)
                        : Colors.transparent,
                    child: ListTile(
                      leading: const Icon(
                        Icons.star_outline,
                        color: Colors.amber,
                      ),
                      title: const Text(
                        'Favoriler',
                      ),
                      trailing: Text(
                        _getCountForCategory('__favorites__').toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        setState(() => _activeCategory = '__favorites__');
                        _saveData();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    color: _activeCategory == '__reminders__'
                        ? dNoteHighlight(context)
                        : Colors.transparent,
                    child: ListTile(
                      leading: const Icon(
                        Icons.notifications_active_outlined,
                        color: Colors.amber,
                      ),
                      title: const Text('Hatırlatmalar'),
                      trailing: Text(
                        _getCountForCategory('__reminders__').toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        setState(() => _activeCategory = '__reminders__');
                        _saveData();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    color: _activeCategory == '__locked__'
                        ? dNoteHighlight(context)
                        : Colors.transparent,
                    child: ListTile(
                      leading: const Icon(
                        Icons.lock_outline,
                        color: Colors.amber,
                      ),
                      title: const Text(
                        'Kilitli',
                      ),
                      trailing: Text(
                        _getCountForCategory('__locked__').toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () => _openLockedFolder(),
                    ),
                  ),
                  Container(
                    color: _activeCategory == '__archive__'
                        ? dNoteHighlight(context)
                        : Colors.transparent,
                    child: ListTile(
                      leading: const Icon(
                        Icons.archive_outlined,
                        color: Colors.amber,
                      ),
                      title: const Text(
                        'Arşiv',
                      ),
                      trailing: Text(
                        _getCountForCategory('__archive__').toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        setState(() => _activeCategory = '__archive__');
                        _saveData();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    color: _activeCategory == '__trash__'
                        ? dNoteHighlight(context)
                        : Colors.transparent,
                    child: ListTile(
                      leading: const Icon(
                        Icons.delete_outline,
                        color: Colors.amber,
                      ),
                      title: const Text(
                        'Çöp Kutusu',
                      ),
                      trailing: Text(
                        _deletedNotes.length.toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        setState(() => _activeCategory = '__trash__');
                        _saveData();
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  Divider(
                    color: Theme.of(context).dividerColor,
                    thickness: 1,
                    height: 24,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 4, bottom: 4),
                    child: Text(
                      'KATEGORİLER',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  ..._categories.map((cat) {
                    final catColor = _getCategoryColor(cat);
                    final isCatLocked = _lockedCategories.contains(cat);
                    return Container(
                      color: _activeCategory == cat
                          ? dNoteHighlight(context)
                          : Colors.transparent,
                      child: ListTile(
                        leading: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(Icons.folder_outlined, color: catColor),
                            if (isCatLocked)
                              Positioned(
                                right: -4,
                                bottom: -4,
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.blueGrey[300],
                                  size: 12,
                                ),
                              ),
                          ],
                        ),
                        title: Text(
                          cat,
                          style: TextStyle(
                            color: _activeCategory == cat
                                ? catColor
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        trailing: Text(
                          _getCountForCategory(cat).toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () async {
                          if (isCatLocked) {
                            Navigator.pop(context); // drawer'ı kapat
                            await Future.delayed(
                              const Duration(milliseconds: 350),
                            );
                            if (!mounted) return;
                            if (!_notePasswordEnabled) {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text(
                                    'Parola Gerekiyor',
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                  content: const Text(
                                    'Kilitli kategoriye girebilmek için önce Ayarlar > Not Şifresi bölümünden bir parola belirlemeniz gerekiyor.',
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber,
                                      ),
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text(
                                        'Tamam',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }
                            final ok = await _checkPasswordPrompt();
                            if (!mounted) return;
                            if (ok) {
                              setState(() => _activeCategory = cat);
                              _saveData();
                            } else {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text(
                                    'Hatalı Parola',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: const Text(
                                    'Girdiğiniz parola yanlış.',
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber,
                                      ),
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text(
                                        'Tamam',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else {
                            setState(() => _activeCategory = cat);
                            _saveData();
                            Navigator.pop(context);
                          }
                        },
                        onLongPress: () => _showCategoryOptions(cat),
                      ),
                    );
                  }),
                  ListTile(
                    leading: Icon(
                      Icons.add_circle_outline,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    title: const Text(
                      'Kategori Ekle',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showAddCategoryDialog();
                    },
                  ),

                  const Divider(
                    thickness: 1,
                    height: 24,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 4, bottom: 4),
                    child: Text(
                      'UYGULAMA',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.settings_outlined,
                      color: Colors.amber,
                    ),
                    title: const Text(
                      'Ayarlar',
                    ),
                    onTap: _openSettings,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.backup_outlined,
                      color: Colors.amber,
                    ),
                    title: const Text(
                      'Yedekle & Geri Yükle',
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.workspace_premium_outlined,
                      color: Colors.amber,
                    ),
                    title: const Text(
                      'Pro\'ya Yükselt',
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.volunteer_activism_outlined,
                      color: Colors.amber,
                    ),
                    title: const Text(
                      'Geliştirme Desteği',
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.rate_review_outlined,
                      color: Colors.amber,
                    ),
                    title: const Text(
                      'Geri Bildirim',
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.info_outline,
                      color: Colors.amber,
                    ),
                    title: const Text(
                      'Hakkında',
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (_isSearching) {
              setState(() {
                _isSearching = false;
                _searchQuery = "";
                _searchController.clear();
              });
              FocusScope.of(context).unfocus();
            } else {
              FocusScope.of(context).unfocus();
            }
          },
          child: Padding(
            padding: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: filteredNotes.isEmpty
                ? const Center(
                    child: Text(
                      'Not bulunamadı.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : _isListView
                ? ListView.builder(
                    padding: const EdgeInsets.only(top: 12.0),
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      final originalIndex = isTrash
                          ? _deletedNotes.indexWhere(
                              (n) =>
                                  n['id'] == note['id'] &&
                                  n['createdDate'] == note['createdDate'],
                            )
                          : _notes.indexWhere(
                              (n) =>
                                  n['id'] == note['id'] &&
                                  n['createdDate'] == note['createdDate'],
                            );
                      final hasTitle = (note['title'] ?? '')
                          .toString()
                          .isNotEmpty;
                      final isChecklist = note['type'] == 'checklist';
                      final isFavorite = note['isFavorite'] == true;
                      final noteCardColor = _colorfulNotes
                          ? _categoryPalette[(originalIndex < 0
                                        ? 0
                                        : originalIndex) %
                                    _categoryPalette.length]
                                .withValues(alpha: 0.75)
                          : (dNoteIsDark(context)
                                ? const Color(0xFF2D2D2D)
                                : Theme.of(context).cardColor);
                      final fontScale = _previewFontScale(note);
                      final previewImage = _firstImageAttachment(note);

                      return GestureDetector(
                        onLongPress: isTrash
                            ? () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Theme.of(context).cardColor,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (_) => SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.amber,
                                            ),
                                            icon: const Icon(
                                              Icons.restore_outlined,
                                              color: Colors.black,
                                            ),
                                            label: const Text(
                                              'Geri Yükle',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            onPressed: () {
                                              final restoredNote =
                                                  _deletedNotes[originalIndex];
                                              setState(() {
                                                _notes.insert(
                                                  0,
                                                  _deletedNotes[originalIndex],
                                                );
                                                _deletedNotes.removeAt(
                                                  originalIndex,
                                                );
                                              });
                                              _saveData();
                                              _rescheduleNoteReminder(
                                                restoredNote,
                                              );
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            icon: const Icon(
                                              Icons.delete_forever,
                                              color: Colors.white,
                                            ),
                                            label: const Text(
                                              'Kalıcı Sil',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              _cleanupAttachmentFiles(_deletedNotes[originalIndex]);
                                            setState(() {
                                              _deletedNotes.removeAt(originalIndex);
                                            });
                                              _saveData();
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            : () => _showNoteActions(
                                context,
                                originalIndex,
                                false,
                              ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Card(
                            margin: EdgeInsets.zero,
                            color: noteCardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: isTrash
                                  ? () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Theme.of(context).cardColor,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                        ),
                                        builder: (_) => SafeArea(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.amber,
                                                      ),
                                                  icon: const Icon(
                                                    Icons.restore_outlined,
                                                    color: Colors.black,
                                                  ),
                                                  label: const Text(
                                                    'Geri Yükle',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    final restoredNote =
                                                        _deletedNotes[originalIndex];
                                                    setState(() {
                                                      _deletedNotes[originalIndex]['createdDate'] =
                                                          DateTime.now()
                                                              .toString();
                                                      _deletedNotes[originalIndex]['modifiedDate'] =
                                                          DateTime.now()
                                                              .toString();
                                                      _notes.insert(
                                                        0,
                                                        _deletedNotes[originalIndex],
                                                      );
                                                      _deletedNotes.removeAt(
                                                        originalIndex,
                                                      );
                                                    });
                                                    _saveData();
                                                    _rescheduleNoteReminder(
                                                      restoredNote,
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                  icon: const Icon(
                                                    Icons.delete_forever,
                                                    color: Colors.white,
                                                  ),
                                                  label: const Text(
                                                    'Kalıcı Sil',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    _cleanupAttachmentFiles(_deletedNotes[originalIndex]);
                                            setState(() {
                                              _deletedNotes.removeAt(originalIndex);
                                            });
                                                    _saveData();
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  : () => _openNoteWithPasswordCheck(
                                      originalIndex,
                                    ),
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (previewImage != null &&
                                        _attachmentsDirPath != null) ...[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: SizedBox(
                                          width: 56,
                                          height: 56,
                                          child: Image.file(
                                            File(
                                              p.join(
                                                _attachmentsDirPath!,
                                                previewImage['storedName']
                                                    .toString(),
                                              ),
                                            ),
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                Container(
                                                  color: dNoteSurfaceVariant(
                                                    context,
                                                  ),
                                                  child: const Icon(
                                                    Icons
                                                        .broken_image_outlined,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                    ],
                                    Expanded(
                                      child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (hasTitle) ...[
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _capitalizeFirstLetterTr(
                                                (note['title'] ?? '')
                                                    .toString(),
                                              ),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18 * fontScale,
                                                color: dNoteEffectiveTextColor(context, _textColor),
                                              ),
                                            ),
                                          ),
                                          if (isFavorite)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 6,
                                              ),
                                              child: Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 18,
                                              ),
                                            ),
                                          if (note['isLocked'] == true)
                                            const Padding(
                                              padding: EdgeInsets.only(left: 6),
                                              child: Icon(
                                                Icons.lock,
                                                color: Colors.grey,
                                                size: 14,
                                              ),
                                            ),
                                          if (_hasActiveReminder(note))
                                            const Padding(
                                              padding: EdgeInsets.only(left: 6),
                                              child: Icon(
                                                Icons.notifications_active,
                                                color: Colors.amber,
                                                size: 14,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                    if (isChecklist)
                                      ...((note['checkItems'] as List? ?? [])
                                          .take(_previewLines)
                                          .map<Widget>(
                                            (item) => Row(
                                              children: [
                                                Icon(
                                                  item['checked'] == true
                                                      ? Icons.check_box
                                                      : Icons
                                                            .check_box_outline_blank,
                                                  color: Colors.amber,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(
                                                    item['text'] ?? '',
                                                    style: TextStyle(
                                                      color:
                                                          item['checked'] ==
                                                              true
                                                          ? Colors.grey
                                                          : (dNoteEffectiveTextColor(context, _textColor)),
                                                      decoration:
                                                          item['checked'] ==
                                                              true
                                                          ? TextDecoration
                                                                .lineThrough
                                                          : null,
                                                      fontSize:
                                                          (note['fontSize']
                                                                  as num?)
                                                              ?.toDouble() ??
                                                          _globalFontSize,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                          .toList())
                                    else
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              ContentBlocks.plainText(
                                                note['content'] as String?,
                                              ),
                                              style: TextStyle(
                                                color: dNoteEffectiveTextColor(context, _textColor),
                                                fontSize:
                                                    (note['fontSize'] as num?)
                                                        ?.toDouble() ??
                                                    _globalFontSize,
                                              ),
                                              maxLines: _previewLines,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (isFavorite)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 6,
                                              ),
                                              child: Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 18,
                                              ),
                                            ),
                                        ],
                                      ),
                                    if ((note['category'] ?? '')
                                        .toString()
                                        .isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          note['category'],
                                          style: TextStyle(
                                            color:
                                                (dNoteEffectiveTextColor(context, _textColor))
                                                    .withValues(alpha: 0.7),
                                            fontSize:
                                                (note['fontSize'] as num?)
                                                    ?.toDouble() ??
                                                _globalFontSize,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                    if (_formattedReminderText(note) !=
                                        null) ...[
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            color: Colors.amber,
                                            size: 13,
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              _formattedReminderText(note)!,
                                              style: TextStyle(
                                                color: Colors.amber
                                                    .withValues(alpha: 0.9),
                                                fontSize:
                                                    ((note['fontSize'] as num?)
                                                                ?.toDouble() ??
                                                            _globalFontSize) -
                                                    2,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: _buildGridView(
                      filteredNotes: filteredNotes,
                      isTrash: isTrash,
                    ),
                  ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddMenu,
          backgroundColor: Colors.amber,
          child: const Icon(Icons.add, color: Colors.black, size: 30),
        ),
      ),
    );
  }

  // Izgara görünümü: kart yüksekliği sabit DEĞİLDİR, içerik kadar yer kaplar.
  // Üst sınır: Ayarlar > Not Önizleme Satırı (_previewLines) ile belirlenir.
  // 2 sütunlu "staggered" (Pinterest tarzı) düzen — sütunlar arasında en kısa
  // olana yeni kart eklenerek sütun yükseklikleri dengelenir.
  Widget _buildGridView({
    required List<Map<String, dynamic>> filteredNotes,
    required bool isTrash,
  }) {
    const int crossAxisCount = 2;
    const double spacing = 10;
    const double outerPadding = 0.0; // dış konteyner zaten 16px padding veriyor
    const double cardInnerPadding =
        16.0; // _buildGridNoteCard içindeki Padding değeri

    // Her sütunun gerçek genişliğini hesapla: ekran genişliğinden dış
    // padding'leri ve sütunlar arası boşluğu çıkar, crossAxisCount'a böl.
    final screenWidth = MediaQuery.of(context).size.width;
    final totalSpacing = (outerPadding * 2) + (spacing * (crossAxisCount - 1));
    final columnWidth = (screenWidth - totalSpacing) / crossAxisCount;
    // Kartın iç padding'ini çıkararak metnin gerçekte sarabileceği genişliği bul.
    final cardContentWidth = (columnWidth - (cardInnerPadding * 2)).clamp(
      0.0,
      columnWidth,
    );

    final List<List<Widget>> columnChildren = List.generate(
      crossAxisCount,
      (_) => <Widget>[],
    );
    final List<double> columnHeights = List.filled(crossAxisCount, 0.0);

    for (int index = 0; index < filteredNotes.length; index++) {
      final note = filteredNotes[index];
      final originalIndex = isTrash
          ? _deletedNotes.indexWhere(
              (n) =>
                  n['id'] == note['id'] &&
                  n['createdDate'] == note['createdDate'],
            )
          : _notes.indexWhere(
              (n) =>
                  n['id'] == note['id'] &&
                  n['createdDate'] == note['createdDate'],
            );

      // Kartı, şu anda en kısa olan sütuna ekle (sütun yüksekliklerini dengeler).
      int shortestColumn = 0;
      for (int c = 1; c < crossAxisCount; c++) {
        if (columnHeights[c] < columnHeights[shortestColumn]) {
          shortestColumn = c;
        }
      }

      final estimatedHeight = _estimateNoteHeight(note, cardContentWidth);
      columnHeights[shortestColumn] += estimatedHeight;

      columnChildren[shortestColumn].add(
        Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: SizedBox(
            width: double.infinity,
            child: _buildGridNoteCard(
              note: note,
              originalIndex: originalIndex,
              isTrash: isTrash,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(crossAxisCount, (c) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: c == 0 ? 0 : spacing / 2,
                right: c == crossAxisCount - 1 ? 0 : spacing / 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: columnChildren[c],
              ),
            ),
          );
        }),
      ),
    );
  }

  // Bir notun önizlemede kullanacağı yazı boyutu ölçek katsayısını döndürür.
  // Not kendi özel fontSize'ını taşıyorsa o değer, taşımıyorsa Ayarlar >
  // Kişiselleştirme > Metin Boyutu (_globalFontSize) baz alınır. 16.0
  // varsayılan/temel boyut olduğundan ölçek = seçilen boyut / 16.0 şeklinde
  // hesaplanır; bu sayede mevcut tüm fontSize değerleri (başlık, içerik,
  // checklist) orantılı şekilde büyür/küçülür.
  double _previewFontScale(Map<String, dynamic> note) {
    final noteFontSize =
        (note['fontSize'] as num?)?.toDouble() ?? _globalFontSize;
    return noteFontSize / 16.0;
  }

  // Kart önizlemesinde göstermek üzere, notun eklerinden ilk görseli bulur.
  Map<String, dynamic>? _firstImageAttachment(Map<String, dynamic> note) {
    final atts = note['attachments'];
    if (atts is List) {
      for (final a in atts) {
        if (a is Map &&
            a['isImage'] == true &&
            (a['storedName'] ?? '').toString().isNotEmpty) {
          return Map<String, dynamic>.from(a);
        }
      }
    }
    return null;
  }

  // Verilen metnin, belirtilen genişlik ve yazı stiliyle gerçekte kaç satıra
  // SARACAĞINI ölçer (TextPainter ile). Basit "\n sayısı" tahmini, satır
  // kendiliğinden sardığında (özellikle metin boyutu büyütüldüğünde) yanlış
  // sonuç verip sütun dengesini bozduğu için bunun yerine gerçek ölçüm
  // kullanılır.
  int _measureWrappedLineCount(String text, double maxWidth, TextStyle style) {
    if (text.isEmpty) return 0;
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: maxWidth);
    return painter.computeLineMetrics().length;
  }

  // Kartın gerçekte kaç piksel yükseklik kaplayacağını ölçer (sütun
  // dengelemesi için). Önceki sürüm sadece "satır sayısı" topluyordu; bu,
  // başlık/içerik/checklist satırlarının farklı font boyutlarına ve kartın
  // sabit iç boşluklarına (padding, SizedBox aralıkları) duyarsız kalıp
  // sütunlar arasında kümülatif sapmaya yol açıyordu (bazı notların hep
  // aynı sütuna yığılması). Gerçek piksel yüksekliği, kartın
  // _buildGridNoteCard içindeki gerçek yapısıyla (16px iç padding, başlık
  // sonrası 12px boşluk, kategori öncesi 8px boşluk, checklist öğeleri
  // arası 4px boşluk) bire bir eşleşecek şekilde hesaplanır.
  double _estimateNoteHeight(
    Map<String, dynamic> note,
    double cardContentWidth,
  ) {
    final hasTitle = (note['title'] ?? '').toString().isNotEmpty;
    final isChecklist = note['type'] == 'checklist';
    final fontScale = _previewFontScale(note);
    double height = 32.0; // kartın iç padding'i: 16 üst + 16 alt

    if (_firstImageAttachment(note) != null) {
      height += 120.0; // üstteki görsel önizleme yüksekliği
    }

    if (hasTitle) {
      height += (18 * fontScale) * 1.2; // başlık satırı (tek satır, maxLines:1)
      height += 12.0; // başlık sonrası SizedBox
    }

    if (isChecklist) {
      final items = (note['checkItems'] as List? ?? []);
      final itemCount = items.length.clamp(0, _previewLines);
      // Her checklist öğesi tek satır + altında 4px boşluk.
      height += itemCount * ((12 * fontScale) * 1.3 + 4.0);
    } else {
      final content = ContentBlocks.plainText(note['content'] as String?);
      if (content.isNotEmpty) {
        final noteFontSize =
            (note['fontSize'] as num?)?.toDouble() ?? _globalFontSize;
        final style = TextStyle(fontSize: noteFontSize, height: 1.3);
        int wrapped = 0;
        for (final paragraph in content.split('\n')) {
          wrapped += _measureWrappedLineCount(
            paragraph,
            cardContentWidth,
            style,
          ).clamp(0, 999);
          if (paragraph.isEmpty) wrapped += 1; // boş satır da yer kaplar
        }
        final cappedLines = wrapped.clamp(0, _previewLines);
        height += cappedLines * (noteFontSize * 1.3);
      }
    }

    if ((note['category'] ?? '').toString().isNotEmpty) {
      height += 8.0; // kategori öncesi SizedBox
      height += (11 * fontScale) * 1.2; // kategori satırı
    }

    return height < 1 ? 1 : height;
  }

  // Izgara görünümündeki tek bir not kartı. Yüksekliği içeriğe göre belirlenir;
  // başlık + içerik metni doğal yüksekliğini alır (Expanded YOK), maksimum
  // satır sayısı ayarlardaki _previewLines değeriyle sınırlandırılır.
  Widget _buildGridNoteCard({
    required Map<String, dynamic> note,
    required int originalIndex,
    required bool isTrash,
  }) {
    final hasTitle = (note['title'] ?? '').toString().isNotEmpty;
    final isChecklist = note['type'] == 'checklist';
    final isFavorite = note['isFavorite'] == true;
    final gridCardColor = _colorfulNotes
        ? _categoryPalette[(originalIndex < 0 ? 0 : originalIndex) %
                  _categoryPalette.length]
              .withValues(alpha: 0.75)
        : (dNoteIsDark(context)
              ? const Color(0xFF2D2D2D)
              : Theme.of(context).cardColor);
    final fontScale = _previewFontScale(note);
    final previewImage = _firstImageAttachment(note);

    return GestureDetector(
      onLongPress: isTrash
          ? () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Theme.of(context).cardColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                          ),
                          icon: const Icon(
                            Icons.restore_outlined,
                            color: Colors.black,
                          ),
                          label: const Text(
                            'Geri Yükle',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            final restoredNote = _deletedNotes[originalIndex];
                            setState(() {
                              _deletedNotes[originalIndex]['createdDate'] =
                                  DateTime.now().toString();
                              _deletedNotes[originalIndex]['modifiedDate'] =
                                  DateTime.now().toString();
                              _notes.insert(0, _deletedNotes[originalIndex]);
                              _deletedNotes.removeAt(originalIndex);
                            });
                            _saveData();
                            _rescheduleNoteReminder(restoredNote);
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Kalıcı Sil',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            _cleanupAttachmentFiles(_deletedNotes[originalIndex]);
                                            setState(() {
                                              _deletedNotes.removeAt(originalIndex);
                                            });
                            _saveData();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          : () => _showNoteActions(context, originalIndex, false),
      child: Card(
        margin: EdgeInsets.zero,
        color: gridCardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: isTrash
              ? () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Theme.of(context).cardColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (_) => SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                              ),
                              icon: const Icon(
                                Icons.restore_outlined,
                                color: Colors.black,
                              ),
                              label: const Text(
                                'Geri Yükle',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                final restoredNote =
                                    _deletedNotes[originalIndex];
                                setState(() {
                                  _deletedNotes[originalIndex]['createdDate'] =
                                      DateTime.now().toString();
                                  _deletedNotes[originalIndex]['modifiedDate'] =
                                      DateTime.now().toString();
                                  _notes.insert(
                                    0,
                                    _deletedNotes[originalIndex],
                                  );
                                  _deletedNotes.removeAt(originalIndex);
                                });
                                _saveData();
                                _rescheduleNoteReminder(restoredNote);
                                Navigator.pop(context);
                              },
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Kalıcı Sil',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                _cleanupAttachmentFiles(_deletedNotes[originalIndex]);
                                            setState(() {
                                              _deletedNotes.removeAt(originalIndex);
                                            });
                                _saveData();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              : () => _openNoteWithPasswordCheck(originalIndex),
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (previewImage != null && _attachmentsDirPath != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: SizedBox(
                        height: 120,
                        width: double.infinity,
                        child: Image.file(
                          File(
                            p.join(
                              _attachmentsDirPath!,
                              previewImage['storedName'].toString(),
                            ),
                          ),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: dNoteSurfaceVariant(context),
                            child: const Icon(
                              Icons.broken_image_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasTitle)
                          Text(
                            _capitalizeFirstLetterTr(
                              (note['title'] ?? '').toString(),
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18 * fontScale,
                              color: dNoteEffectiveTextColor(context, _textColor),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            textDirection: TextDirection.ltr,
                          ),
                        if (hasTitle) const SizedBox(height: 12),
                        isChecklist
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: (note['checkItems'] as List? ?? [])
                                    .take(_previewLines)
                                    .map<Widget>(
                                      (item) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        child: Row(
                                          textDirection: TextDirection.ltr,
                                          children: [
                                            Icon(
                                              item['checked'] == true
                                                  ? Icons.check_box
                                                  : Icons
                                                        .check_box_outline_blank,
                                              color: Colors.amber,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                item['text'] ?? '',
                                                style: TextStyle(
                                                  color:
                                                      item['checked'] == true
                                                      ? Colors.grey
                                                      : (dNoteEffectiveTextColor(context, _textColor)),
                                                  decoration:
                                                      item['checked'] == true
                                                      ? TextDecoration
                                                            .lineThrough
                                                      : null,
                                                  fontSize:
                                                      (note['fontSize']
                                                              as num?)
                                                          ?.toDouble() ??
                                                      _globalFontSize,
                                                ),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                                textDirection:
                                                    TextDirection.ltr,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              )
                            : Text(
                                ContentBlocks.plainText(
                                  note['content'] as String?,
                                ),
                                style: TextStyle(
                                  color: dNoteEffectiveTextColor(context, _textColor),
                                  fontSize:
                                      (note['fontSize'] as num?)?.toDouble() ??
                                      _globalFontSize,
                                ),
                                maxLines: _previewLines,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                              ),
                        if ((note['category'] ?? '').toString().isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            note['category'],
                            style: TextStyle(
                              color: (dNoteEffectiveTextColor(context, _textColor))
                                  .withValues(alpha: 0.7),
                              fontSize:
                                  (note['fontSize'] as num?)?.toDouble() ??
                                  _globalFontSize,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                        if (_formattedReminderText(note) != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Colors.amber,
                                size: 13,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  _formattedReminderText(note)!,
                                  style: TextStyle(
                                    color: Colors.amber.withValues(alpha: 0.9),
                                    fontSize:
                                        ((note['fontSize'] as num?)
                                                    ?.toDouble() ??
                                                _globalFontSize) -
                                        2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (isFavorite)
                Positioned(
                  top: 8,
                  right: note['isLocked'] == true ? 36 : 8,
                  child: const Icon(Icons.star, color: Colors.amber, size: 18),
                ),
              if (note['isLocked'] == true)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.lock, color: Colors.grey, size: 16),
                ),
              if (_hasActiveReminder(note))
                Positioned(
                  top: 8,
                  right:
                      8 +
                      (note['isLocked'] == true ? 28 : 0) +
                      (isFavorite ? 28 : 0),
                  child: const Icon(
                    Icons.notifications_active,
                    color: Colors.amber,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Notun gelecekte planlanmış bir hatırlatıcısı var mı?
  bool _hasActiveReminder(Map<String, dynamic> note) {
    final raw = note['reminderDate']?.toString();
    if (raw == null || raw.isEmpty) return false;
    final dt = DateTime.tryParse(raw);
    return dt != null && dt.isAfter(DateTime.now());
  }

  // Hatırlatıcı tarihini "gg.aa.yyyy ss:dd" biçiminde döndürür (kartlarda ve
  // not içinde gösterilir); yoksa null döner.
  String? _formattedReminderText(Map<String, dynamic> note) {
    if (!_hasActiveReminder(note)) return null;
    final dt = DateTime.parse(note['reminderDate'].toString());
    return _formatDateTimeTr(dt);
  }
}

// ═══════════════════════════════════════════════════════════════════
// AYARLAR SAYFASI
// ═══════════════════════════════════════════════════════════════════

class _SettingsPage extends StatefulWidget {
  final _NoteListScreenState state;
  const _SettingsPage({required this.state});

  @override
  State<_SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<_SettingsPage> {
  _NoteListScreenState get s => widget.state;

  // ── Şifre ipucu soruları (sabit liste) ──────────────────────────────
  static const List<String> _hintQuestions = [
    'İlk evcil hayvanınızın adı nedir?',
    'En sevdiğiniz öğretmeninizin adı nedir?',
    'Doğduğunuz şehir nedir?',
    'En sevdiğiniz yemek nedir?',
    'Annenizin kızlık soyadı nedir?',
    'İlk okuduğunuz okulun adı nedir?',
    'En sevdiğiniz renk nedir?',
  ];

  // ── Görünüm (Açık/Koyu/Sistem) seçim diyaloğu ────────────────────────
  void _showThemeModeDialog() {
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDlg) {
          Widget option(ThemeMode mode, String label, IconData icon) {
            final selected = s._themeMode == mode;
            return ListTile(
              leading: Icon(
                icon,
                color: selected ? Colors.amber : Colors.grey,
              ),
              title: Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.amber : dNoteTextColor(ctx),
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: selected
                  ? const Icon(Icons.check, color: Colors.amber)
                  : null,
              onTap: () {
                s.setState(() => s._themeMode = mode);
                appThemeMode.value = mode;
                setState(() {});
                s._saveData();
                Navigator.pop(ctx);
              },
            );
          }

          return AlertDialog(
            backgroundColor: dNoteCardColor(ctx),
            title: const Text('Görünüm', style: TextStyle(color: Colors.amber)),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                option(ThemeMode.light, 'Açık', Icons.light_mode_outlined),
                option(ThemeMode.dark, 'Koyu', Icons.dark_mode_outlined),
                option(
                  ThemeMode.system,
                  'Sistem Varsayılanı',
                  Icons.smartphone_outlined,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Güvenlik sorusu düzenleme diyaloğu ──────────────────────────────
  void _showHintQuestionDialog() {
    String? selectedQuestion = s._passwordHintQuestion.isNotEmpty
        ? s._passwordHintQuestion
        : null;
    final answerCtrl = TextEditingController(text: s._passwordHintAnswer);

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          backgroundColor: dNoteCardColor(ctx),
          title: const Text(
            'Güvenlik Sorusu',
            style: TextStyle(color: Colors.amber),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Şifrenizi unutursanız, bu soruyu doğru cevaplayarak şifrenizi hatırlayabilirsiniz.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: selectedQuestion,
                dropdownColor: dNoteSurfaceVariant(ctx),
                style: TextStyle(color: dNoteTextColor(ctx), fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Güvenlik sorusu seçin',
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                items: _hintQuestions
                    .map(
                      (q) => DropdownMenuItem(
                        value: q,
                        child: Text(q, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setDlg(() => selectedQuestion = val),
              ),
              const SizedBox(height: 12),
              TextField(
                selectionWidthStyle: ui.BoxWidthStyle.tight,
                contextMenuBuilder: buildCustomContextMenu,
                selectionHeightStyle: ui.BoxHeightStyle.max,
                controller: answerCtrl,
                style: TextStyle(color: dNoteTextColor(ctx)),
                decoration: InputDecoration(
                  hintText: 'Cevabınız',
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                if (selectedQuestion == null ||
                    answerCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Soru ve cevap boş olamaz!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                s.setState(() {
                  s._passwordHintQuestion = selectedQuestion!;
                  s._passwordHintAnswer = answerCtrl.text.trim();
                });
                s._saveData();
                Navigator.pop(ctx);
                setState(() {});
              },
              child: const Text(
                'Kaydet',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Şifre diyaloğu ────────────────────────────────────────────────
  void _showPasswordDialog({required bool isNew}) {
    final ctrl1 = TextEditingController();
    final ctrl2 = TextEditingController();
    final hintAnswerCtrl = TextEditingController();
    bool obscure1 = true;
    bool obscure2 = true;
    String? selectedHintQuestion = s._passwordHintQuestion.isNotEmpty
        ? s._passwordHintQuestion
        : null;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          backgroundColor: dNoteCardColor(ctx),
          title: Text(
            isNew ? 'Şifre Oluştur' : 'Mevcut Şifreyi Gir',
            style: const TextStyle(color: Colors.amber),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isNew)
                  TextField(
                    selectionWidthStyle: ui.BoxWidthStyle.tight,
                    contextMenuBuilder: buildCustomContextMenu,
                    selectionHeightStyle: ui.BoxHeightStyle.max,
                    controller: ctrl1,
                    obscureText: obscure1,
                    style: TextStyle(color: dNoteTextColor(ctx)),
                    decoration: InputDecoration(
                      hintText: 'Mevcut şifre',
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure1 ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () => setDlg(() => obscure1 = !obscure1),
                      ),
                    ),
                  )
                else ...[
                  TextField(
                    selectionWidthStyle: ui.BoxWidthStyle.tight,
                    contextMenuBuilder: buildCustomContextMenu,
                    selectionHeightStyle: ui.BoxHeightStyle.max,
                    controller: ctrl1,
                    obscureText: obscure1,
                    style: TextStyle(color: dNoteTextColor(ctx)),
                    decoration: InputDecoration(
                      hintText: 'Yeni şifre',
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure1 ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () => setDlg(() => obscure1 = !obscure1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    selectionWidthStyle: ui.BoxWidthStyle.tight,
                    contextMenuBuilder: buildCustomContextMenu,
                    selectionHeightStyle: ui.BoxHeightStyle.max,
                    controller: ctrl2,
                    obscureText: obscure2,
                    style: TextStyle(color: dNoteTextColor(ctx)),
                    decoration: InputDecoration(
                      hintText: 'Şifreyi tekrar gir',
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure2 ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () => setDlg(() => obscure2 = !obscure2),
                      ),
                    ),
                  ),
                  Divider(color: Theme.of(ctx).dividerColor, height: 28),
                  const Text(
                    'Şifrenizi unutursanız diye bir güvenlik sorusu belirleyin.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: selectedHintQuestion,
                    dropdownColor: dNoteSurfaceVariant(ctx),
                    style: TextStyle(color: dNoteTextColor(ctx), fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Güvenlik sorusu seçin',
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                    ),
                    items: _hintQuestions
                        .map(
                          (q) => DropdownMenuItem(
                            value: q,
                            child: Text(q, overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                    onChanged: (val) =>
                        setDlg(() => selectedHintQuestion = val),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    selectionWidthStyle: ui.BoxWidthStyle.tight,
                    contextMenuBuilder: buildCustomContextMenu,
                    selectionHeightStyle: ui.BoxHeightStyle.max,
                    controller: hintAnswerCtrl,
                    style: TextStyle(color: dNoteTextColor(ctx)),
                    decoration: InputDecoration(
                      hintText: 'Cevabınız',
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Bu alan zorunlu değildir ama şiddetle önerilir.',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                if (isNew) {
                  if (ctrl1.text.isEmpty) return;
                  if (ctrl1.text != ctrl2.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Şifreler eşleşmiyor!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  s.setState(() {
                    s._notePassword = ctrl1.text;
                    s._notePasswordEnabled = true;
                    s._passwordHintQuestion = selectedHintQuestion ?? '';
                    s._passwordHintAnswer = hintAnswerCtrl.text.trim();
                  });
                  s._saveData();
                  Navigator.pop(ctx);
                  setState(() {});
                } else {
                  // Disable: verify old password
                  if (ctrl1.text == s._notePassword) {
                    s.setState(() {
                      s._notePasswordEnabled = false;
                      s._notePassword = '';
                      s._passwordHintQuestion = '';
                      s._passwordHintAnswer = '';
                    });
                    s._saveData();
                    Navigator.pop(ctx);
                    setState(() {});
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Yanlış şifre!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text(
                isNew ? 'Kaydet' : 'Kaldır',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Yazı tipi seçici ──────────────────────────────────────────────
  static const List<String> _fonts = [
    'Varsayılan',
    'Monospace',
    'Serif',
    'Cursive',
  ];

  static String? _fontFamilyValue(String name) {
    switch (name) {
      case 'Monospace':
        return 'monospace';
      case 'Serif':
        return 'serif';
      case 'Cursive':
        return 'cursive';
      default:
        return null;
    }
  }

  // ── Metin rengi seçici ────────────────────────────────────────────
  static const List<Color> _textPalette = [
    Colors.white,
    Color(0xFFE0E0E0),
    Color(0xFFBDBDBD),
    Colors.amber,
    Colors.cyanAccent,
    Colors.greenAccent,
    Colors.pinkAccent,
    Colors.lightBlueAccent,
    Colors.orangeAccent,
  ];

  void _showTextColorPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: dNoteCardColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(
                    bottom: 16,
                    left: 120,
                    right: 120,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'Metin Rengi',
                  style: TextStyle(
                    color: dNoteTextColor(ctx),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Not içerik metninin rengini belirler.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    // "Varsayılan": özel bir renk seçilmemiş, metin rengi
                    // temaya göre otomatik belirlenir (koyu temada beyaz,
                    // açık temada koyu gri).
                    _TextColorSwatch(
                      selected: s._textColor == null,
                      onTap: () {
                        s.setState(() => s._textColor = null);
                        setSheet(() {});
                        s._saveData();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white, Colors.black87],
                            stops: [0.5, 0.5],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'A',
                          style: TextStyle(
                            color: s._textColor == null
                                ? Colors.amber
                                : Colors.grey[500],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    ..._textPalette.map((c) {
                      final selected = s._textColor == c;
                      return _TextColorSwatch(
                        selected: selected,
                        color: c,
                        onTap: () {
                          s.setState(() => s._textColor = c);
                          setSheet(() {});
                          s._saveData();
                        },
                        child: selected
                            ? Icon(
                                Icons.check,
                                color: c == Colors.white
                                    ? Colors.black
                                    : Colors.black87,
                                size: 20,
                              )
                            : null,
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text(
                      'Tamam',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 6),
    child: Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Colors.amber,
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.4,
      ),
    ),
  );

  Widget _settingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) => ListTile(
    leading: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: iconColor, size: 20),
    ),
    title: Text(
      title,
      style: TextStyle(color: dNoteTextColor(context), fontSize: 14),
    ),
    subtitle: subtitle != null
        ? Text(
            subtitle,
            style: TextStyle(color: Colors.grey[500], fontSize: 11),
          )
        : null,
    trailing: trailing,
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: dNoteCardColor(context),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: dNoteTextColor(context)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ayarlar',
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            // ── 1. GÜVENLİK ─────────────────────────────────────────────
            _sectionHeader('Güvenlik'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: dNoteCardColor(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _settingTile(
                    icon: Icons.lock_outline,
                    iconColor: Colors.blueAccent,
                    title: 'Not Şifresi',
                    subtitle: s._notePasswordEnabled
                        ? 'Şifre ayarlandı ✓'
                        : 'Şifre ayarlanmadı',
                    trailing: Switch(
                      value: s._notePasswordEnabled,
                      activeThumbColor: Colors.amber,
                      onChanged: (val) {
                        if (val) {
                          _showPasswordDialog(isNew: true);
                        } else {
                          if (s._notePassword.isEmpty) {
                            s.setState(() => s._notePasswordEnabled = false);
                            s._saveData();
                            setState(() {});
                          } else {
                            _showPasswordDialog(isNew: false);
                          }
                        }
                      },
                    ),
                  ),
                  if (s._notePasswordEnabled) ...[
                    Divider(
                      color: Theme.of(context).dividerColor,
                      height: 1,
                      indent: 56,
                    ),
                    _settingTile(
                      icon: Icons.help_outline,
                      iconColor: Colors.orangeAccent,
                      title: 'Güvenlik Sorusu',
                      subtitle: s._passwordHintQuestion.isNotEmpty
                          ? 'Belirlendi ✓ — şifreyi unutursanız kullanılır'
                          : 'Belirlenmedi — şifrenizi kaybederseniz kurtaramazsınız',
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onTap: () => _showHintQuestionDialog(),
                    ),
                  ],
                ],
              ),
            ),

            // ── 2. TEMA ──────────────────────────────────────────────────
            _sectionHeader('Tema'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: dNoteCardColor(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _settingTile(
                    icon: Icons.dark_mode_outlined,
                    iconColor: Colors.indigoAccent,
                    title: 'Görünüm',
                    subtitle: switch (s._themeMode) {
                      ThemeMode.light => 'Açık',
                      ThemeMode.dark => 'Koyu',
                      ThemeMode.system => 'Sistem Varsayılanı',
                    },
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: () => _showThemeModeDialog(),
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    height: 1,
                    indent: 56,
                  ),
                  _settingTile(
                    icon: Icons.palette_outlined,
                    iconColor: Colors.orangeAccent,
                    title: 'Değişken Not Renkleri',
                    subtitle: 'Her not kartı farklı renk tonu alır.',
                    trailing: Switch(
                      value: s._colorfulNotes,
                      activeThumbColor: Colors.amber,
                      onChanged: (val) {
                        s.setState(() => s._colorfulNotes = val);
                        setState(() {});
                        s._saveData();
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ── 3. KİŞİSELLEŞTİRME ──────────────────────────────────────
            _sectionHeader('Kişiselleştirme'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: dNoteCardColor(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  // Yazı tipi
                  _settingTile(
                    icon: Icons.font_download_outlined,
                    iconColor: Colors.tealAccent,
                    title: 'Yazı Tipi',
                    subtitle: s._fontFamily,
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: dNoteCardColor(context),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) => SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Yazı Tipi',
                                  style: TextStyle(
                                    color: dNoteTextColor(context),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ..._fonts.map(
                                  (f) => ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      f,
                                      style: TextStyle(
                                        color: s._fontFamily == f
                                            ? Colors.amber
                                            : dNoteTextColor(context),
                                        fontFamily: _fontFamilyValue(f),
                                      ),
                                    ),
                                    trailing: s._fontFamily == f
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: Colors.amber,
                                          )
                                        : null,
                                    onTap: () {
                                      s.setState(() => s._fontFamily = f);
                                      setState(() {});
                                      s._saveData();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    height: 1,
                    indent: 56,
                  ),
                  // Metin boyutu
                  _settingTile(
                    icon: Icons.text_fields,
                    iconColor: Colors.pinkAccent,
                    title: 'Metin Boyutu',
                    subtitle:
                        '${s._globalFontSize.round()} pt — tüm notlara uygulanır.',
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      double tempSize = s._globalFontSize;
                      bool applyToAll = false;
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: dNoteCardColor(context),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        isScrollControlled: true,
                        builder: (_) => StatefulBuilder(
                          builder: (ctx, setSheet) => SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                16,
                                24,
                                24,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[500],
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Metin Boyutu',
                                    style: TextStyle(
                                      color: dNoteTextColor(ctx),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.text_fields,
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: SliderTheme(
                                          data: SliderTheme.of(context)
                                              .copyWith(
                                                activeTrackColor: Colors.amber,
                                                inactiveTrackColor:
                                                    dNoteSurfaceVariant(ctx),
                                                thumbColor: Colors.amber,
                                                overlayColor: Colors.amber
                                                    .withValues(alpha: 0.2),
                                                valueIndicatorColor:
                                                    Colors.amber,
                                                valueIndicatorTextStyle:
                                                    const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                          child: Slider(
                                            value: tempSize,
                                            min: 10,
                                            max: 30,
                                            divisions: 20,
                                            label: '${tempSize.round()}',
                                            onChanged: (v) =>
                                                setSheet(() => tempSize = v),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.text_fields,
                                        color: Colors.grey,
                                        size: 26,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Örnek metin - ${tempSize.round()} pt',
                                    style: TextStyle(
                                      color: dNoteTextColor(
                                        ctx,
                                      ).withValues(alpha: 0.7),
                                      fontSize: tempSize,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: applyToAll,
                                        activeColor: Colors.amber,
                                        onChanged: (v) => setSheet(
                                          () => applyToAll = v ?? false,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Mevcut notlara uygula',
                                          style: TextStyle(
                                            color: dNoteTextColor(
                                              ctx,
                                            ).withValues(alpha: 0.7),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      left: 12,
                                      bottom: 16,
                                    ),
                                    child: Text(
                                      'Bireysel not boyutu ayarı varsa bu ayar o notları etkilemez.',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: const Text(
                                            'İptal',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.amber,
                                          ),
                                          onPressed: () {
                                            s.setState(() {
                                              s._globalFontSize = tempSize;
                                              if (applyToAll) {
                                                for (final note in s._notes) {
                                                  note['fontSize'] = tempSize;
                                                }
                                              }
                                            });
                                            setState(() {});
                                            s._saveData();
                                            Navigator.pop(ctx);
                                          },
                                          child: const Text(
                                            'Uygula',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    height: 1,
                    indent: 56,
                  ),
                  // Metin rengi
                  _settingTile(
                    icon: Icons.format_color_text,
                    iconColor: Colors.lightBlueAccent,
                    title: 'Metin Rengi',
                    subtitle: 'Not içerik metni için renk.',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: dNoteEffectiveTextColor(context, s._textColor),
                            border: Border.all(color: Colors.grey[600]!),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                    onTap: _showTextColorPicker,
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    height: 1,
                    indent: 56,
                  ),
                  // Not önizleme satırı
                  _settingTile(
                    icon: Icons.wrap_text,
                    iconColor: Colors.amberAccent,
                    title: 'Not Önizleme Satırı',
                    subtitle:
                        'En fazla ${s._previewLines} satır göster. Not daha kısaysa gerçek satır sayısı görünür.',
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      int tempLines = s._previewLines;
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: dNoteCardColor(context),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) => StatefulBuilder(
                          builder: (ctx, setSheet) => SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                16,
                                24,
                                24,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[500],
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Not Önizleme Satırı',
                                    style: TextStyle(
                                      color: dNoteTextColor(ctx),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Şu an: $tempLines satır',
                                    style: const TextStyle(
                                      color: Colors.amber,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Colors.amber,
                                      inactiveTrackColor: dNoteSurfaceVariant(
                                        ctx,
                                      ),
                                      thumbColor: Colors.amber,
                                      overlayColor: Colors.amber.withValues(
                                        alpha: 0.2,
                                      ),
                                      valueIndicatorColor: Colors.amber,
                                      valueIndicatorTextStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    child: Slider(
                                      value: tempLines.toDouble(),
                                      min: 1,
                                      max: 10,
                                      divisions: 9,
                                      label: '$tempLines',
                                      onChanged: (v) =>
                                          setSheet(() => tempLines = v.round()),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16,
                                    ),
                                    child: Text(
                                      'Maksimum önizlenecek satır sayısını belirler. Not daha az satıra sahipse gerçek satır sayısı gösterilir.',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 11,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: const Text(
                                            'İptal',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.amber,
                                          ),
                                          onPressed: () {
                                            s.setState(
                                              () => s._previewLines = tempLines,
                                            );
                                            setState(() {});
                                            s._saveData();
                                            Navigator.pop(ctx);
                                          },
                                          child: const Text(
                                            'Uygula',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ── 4. WİDGET ────────────────────────────────────────────────
            _sectionHeader('Widget'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: dNoteCardColor(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  // Bilgi kutusu
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.08),
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.amber, size: 18),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Widget ayarları yakında aktif olacak.',
                            style: TextStyle(color: Colors.amber, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Opacity(
                    opacity: 0.45,
                    child: Column(
                      children: [
                        _settingTile(
                          icon: Icons.text_fields,
                          iconColor: Colors.cyanAccent,
                          title: 'Widget Metin Boyutu',
                          subtitle: '${s._widgetFontSize.round()} pt',
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).dividerColor,
                          height: 1,
                          indent: 56,
                        ),
                        _settingTile(
                          icon: Icons.opacity,
                          iconColor: Colors.lightBlueAccent,
                          title: 'Arka Plan Saydamlığı',
                          subtitle: '%${(s._widgetBgOpacity * 100).round()}',
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).dividerColor,
                          height: 1,
                          indent: 56,
                        ),
                        _settingTile(
                          icon: Icons.dark_mode_outlined,
                          iconColor: Colors.deepPurpleAccent,
                          title: 'Koyu Widget',
                          subtitle: 'Widget için koyu renk şeması.',
                          trailing: Switch(
                            value: s._widgetDark,
                            activeThumbColor: Colors.amber,
                            onChanged: null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Ek dosya kutucuğu: basılı tutunca sil ikonu gösterir ────────────────
// Sil ikonunun görünürlüğü dışarıdan (showDelete) kontrol edilir; böylece
// liste içindeki bir öğe silindiğinde, kalan öğelerin durumu widget'ların
// yeniden kullanılmasından (state reuse) etkilenmez.
// ── Metin Rengi seçicideki tek bir renk karesi ───────────────────────────
// `color` verilmezse (Varsayılan seçeneği) kare tamamen `child` tarafından
// çizilir; verilirse düz bir renk karesi olur.
class _TextColorSwatch extends StatelessWidget {
  final Color? color;
  final bool selected;
  final VoidCallback onTap;
  final Widget? child;

  const _TextColorSwatch({
    this.color,
    required this.selected,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: selected ? Colors.amber : Colors.grey[500]!,
            width: selected ? 2.5 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  final Widget preview;
  final double width;
  final double height;
  final bool showDelete;
  final VoidCallback onOpen;
  final VoidCallback onRemove;
  final VoidCallback onLongPress;
  final VoidCallback onDismissDelete;

  const _AttachmentTile({
    required this.preview,
    required this.width,
    required this.height,
    required this.showDelete,
    required this.onOpen,
    required this.onRemove,
    required this.onLongPress,
    required this.onDismissDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showDelete ? onDismissDelete : onOpen,
      onLongPress: showDelete ? null : onLongPress,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: dNoteSurfaceVariant(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: dNoteBorderColor(context)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(child: preview),
            if (showDelete)
              Positioned.fill(
                child: Container(color: Colors.black54),
              ),
            if (showDelete)
              Center(
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
