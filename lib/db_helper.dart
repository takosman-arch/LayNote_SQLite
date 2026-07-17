part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// SQLITE VERİ TABANI KATMANI - AŞAMA 7 (ÇÖP KUTUSU SİSTEMİ ENTEGRASYONU)
// Notlar, çöp kutusu, kategoriler ve ayarlar SQLite veritabanında (dnote.db) tutulur.
// v6 ile çöp kutusundaki notların silinme tarihini takip eden 'deletedDate' eklenmiştir.
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
      version: 6, // Aşama 7.1: Sürüm 5'ten 6'ya yükseltildi
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE notes ADD COLUMN attachments TEXT');
          await db.execute('ALTER TABLE deleted_notes ADD COLUMN attachments TEXT');
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE notes ADD COLUMN reminderDate TEXT');
          await db.execute('ALTER TABLE deleted_notes ADD COLUMN reminderDate TEXT');
        }
        if (oldVersion < 4) {
          await db.execute('ALTER TABLE notes ADD COLUMN assignedDate TEXT');
          await db.execute('ALTER TABLE deleted_notes ADD COLUMN assignedDate TEXT');
        }
        if (oldVersion < 5) {
          await db.execute('ALTER TABLE notes ADD COLUMN reminderRepeat TEXT');
          await db.execute('ALTER TABLE deleted_notes ADD COLUMN reminderRepeat TEXT');
        }
        if (oldVersion < 6) {
          // Aşama 7.1: 30 günlük otomatik silme takibi için silinme tarihi sütunu ekleniyor
          await db.execute('ALTER TABLE notes ADD COLUMN deletedDate TEXT');
          await db.execute('ALTER TABLE deleted_notes ADD COLUMN deletedDate TEXT');
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
            deletedDate TEXT,
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
            deletedDate TEXT,
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
      'checkItems': note['checkItems'] != null ? jsonEncode(note['checkItems']) : null,
      'attachments': (note['attachments'] != null && (note['attachments'] as List).isNotEmpty)
          ? jsonEncode(note['attachments'])
          : null,
      'reminderDate': note['reminderDate']?.toString(),
      'assignedDate': note['assignedDate']?.toString(),
      'reminderRepeat': note['reminderRepeat']?.toString(),
      'deletedDate': note['deletedDate']?.toString(), // Aşama 7.1
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
      if (row['checkItems'] != null) 'checkItems': jsonDecode(row['checkItems'] as String),
      if (row['attachments'] != null) 'attachments': jsonDecode(row['attachments'] as String),
      if (row['reminderDate'] != null) 'reminderDate': row['reminderDate'],
      if (row['assignedDate'] != null) 'assignedDate': row['assignedDate'],
      if (row['reminderRepeat'] != null) 'reminderRepeat': row['reminderRepeat'],
      if (row['deletedDate'] != null) 'deletedDate': row['deletedDate'], // Aşama 7.1
      'isLocked': row['isLocked'] == 1,
      'isArchived': row['isArchived'] == 1,
      'isFavorite': row['isFavorite'] == 1,
    };
  }

  // ── Notlar (Aktif ve Silinmiş İşlemleri) ───────────────────────────────
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
        batch.insert('notes', _noteToRow(n), conflictAlgorithm: ConflictAlgorithm.replace);
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
        batch.insert('deleted_notes', _noteToRow(n), conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
  }

  // ── Aşama 7.1: Yeni Çöp Kutusu Yönetim Metotları ───────────────────────
  
  /// Bir notu aktif notlardan silip çöp kutusu tablosuna taşır ve silinme tarihini işler.
  Future<void> moveToTrash(Map<String, dynamic> note) async {
    final db = await database;
    final updatedNote = Map<String, dynamic>.from(note);
    updatedNote['deletedDate'] = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      await txn.delete('notes', where: 'id = ?', whereArgs: [note['id']]);
      await txn.insert(
        'deleted_notes', 
        _noteToRow(updatedNote), 
        conflictAlgorithm: ConflictAlgorithm.replace
      );
    });
  }

  /// Bir notu çöp kutusundan çıkartıp tekrar aktif notlar tablosuna geri yükler.
  Future<void> restoreFromTrash(Map<String, dynamic> note) async {
    final db = await database;
    final updatedNote = Map<String, dynamic>.from(note);
    updatedNote['deletedDate'] = null;

    await db.transaction((txn) async {
      await txn.delete('deleted_notes', where: 'id = ?', whereArgs: [note['id']]);
      await txn.insert(
        'notes', 
        _noteToRow(updatedNote), 
        conflictAlgorithm: ConflictAlgorithm.replace
      );
    });
  }

  /// Bir veya birden fazla notu çöp kutusundan kalıcı olarak diskten ve veri tabanından siler.
  Future<void> permanentlyDeleteNote(String noteId, List<dynamic>? attachments) async {
    final db = await database;
    
    // Varsa nota ait fiziksel ek dosyaları temizle
    if (attachments != null) {
      for (final att in attachments) {
        if (att is Map && att['storedName'] != null) {
          await deleteAttachmentFile(att['storedName'].toString());
        }
      }
    }
    await db.delete('deleted_notes', where: 'id = ?', whereArgs: [noteId]);
  }

  /// Çöp kutusundaki 30 günü geçmiş notları otomatik olarak kalıcı olarak siler.
  Future<void> autoCleanOldDeletedNotes() async {
    final db = await database;
    final rows = await db.query('deleted_notes');
    final now = DateTime.now();

    for (final row in rows) {
      final note = _rowToNote(row);
      final deletedDateStr = note['deletedDate'];
      if (deletedDateStr != null) {
        final deletedDate = DateTime.tryParse(deletedDateStr.toString());
        if (deletedDate != null) {
          final difference = now.difference(deletedDate).inDays;
          if (difference >= 30) {
            await permanentlyDeleteNote(note['id'].toString(), note['attachments'] as List?);
          }
        }
      }
    }
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
    } catch (_) {}
  }

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
      final newStored = '${DateTime.now().microsecondsSinceEpoch}_${counter++}$ext';
      await oldFile.copy(p.join(dir.path, newStored));
      result.add({...a, 'id': '${a['id']}_copy', 'storedName': newStored});
    }
    return result;
  }
}