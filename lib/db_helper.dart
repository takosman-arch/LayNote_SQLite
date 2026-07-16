part of 'main.dart';

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
      version: 5,
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
        if (oldVersion < 4) {
          // v3 -> v4: takvimde notu istenen güne atayabilmek için
          // assignedDate sütunu (boşsa createdDate esas alınır).
          await db.execute('ALTER TABLE notes ADD COLUMN assignedDate TEXT');
          await db.execute(
            'ALTER TABLE deleted_notes ADD COLUMN assignedDate TEXT',
          );
        }
        if (oldVersion < 5) {
          // v4 -> v5: hatırlatıcının her gün/her hafta tekrarlaması için
          // reminderRepeat sütunu ('hourly' / 'daily' / 'weekly' / 'monthly'
          // / 'yearly' / null).
          await db.execute(
            'ALTER TABLE notes ADD COLUMN reminderRepeat TEXT',
          );
          await db.execute(
            'ALTER TABLE deleted_notes ADD COLUMN reminderRepeat TEXT',
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
            assignedDate TEXT,
            reminderRepeat TEXT,
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
            assignedDate TEXT,
            reminderRepeat TEXT,
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
      'assignedDate': note['assignedDate']?.toString(),
      'reminderRepeat': note['reminderRepeat']?.toString(),
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
      if (row['assignedDate'] != null) 'assignedDate': row['assignedDate'],
      if (row['reminderRepeat'] != null)
        'reminderRepeat': row['reminderRepeat'],
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

