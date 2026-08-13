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
      version: 10, // Başlık zengin metin (titleSpans) desteği: 9'dan 10'a yükseltildi
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _addColumnIfMissing(db, 'notes', 'attachments', 'TEXT');
          await _addColumnIfMissing(db, 'deleted_notes', 'attachments', 'TEXT');
        }
        if (oldVersion < 3) {
          await _addColumnIfMissing(db, 'notes', 'reminderDate', 'TEXT');
          await _addColumnIfMissing(db, 'deleted_notes', 'reminderDate', 'TEXT');
        }
        if (oldVersion < 4) {
          await _addColumnIfMissing(db, 'notes', 'assignedDate', 'TEXT');
          await _addColumnIfMissing(db, 'deleted_notes', 'assignedDate', 'TEXT');
        }
        if (oldVersion < 5) {
          await _addColumnIfMissing(db, 'notes', 'reminderRepeat', 'TEXT');
          await _addColumnIfMissing(db, 'deleted_notes', 'reminderRepeat', 'TEXT');
        }
        if (oldVersion < 6) {
          // Aşama 7.1: 30 günlük otomatik silme takibi için silinme tarihi sütunu ekleniyor
          await _addColumnIfMissing(db, 'notes', 'deletedDate', 'TEXT');
          await _addColumnIfMissing(db, 'deleted_notes', 'deletedDate', 'TEXT');
        }
        if (oldVersion < 7) {
          // Bildirim paneline sabitleme durumunu tutan sütun ekleniyor.
          await _addColumnIfMissing(
            db,
            'notes',
            'isPinnedToNotification',
            'INTEGER NOT NULL DEFAULT 0',
          );
          await _addColumnIfMissing(
            db,
            'deleted_notes',
            'isPinnedToNotification',
            'INTEGER NOT NULL DEFAULT 0',
          );
        }
        if (oldVersion < 8) {
          // Alt klasör desteği: bir kategorinin başka bir kategorinin
          // (üst klasörün) altında olup olmadığını tutan sütun eklenir.
          // Null ise kategori üst seviyededir (alt klasör değildir).
          await _addColumnIfMissing(db, 'categories', 'parent', 'TEXT');
        }
        if (oldVersion < 9) {
          // Not arka planı paleti: notun tüm arka planına uygulanan tek
          // renk değeri (int? renk kodu, null = varsayılan/kategori rengi).
          // Bkz. note_bg_color_palette.dart.
          await _addColumnIfMissing(db, 'notes', 'bgColor', 'INTEGER');
          await _addColumnIfMissing(db, 'deleted_notes', 'bgColor', 'INTEGER');
        }
        if (oldVersion < 10) {
          // Not başlığındaki zengin metin (kalın/italik/renk/vb.) span
          // listesi. content_blocks içindeki 'spans' ile aynı JSON şekli
          // ('RichTextSpans'), ama başlık 'content' JSON'ının DIŞINDA ayrı
          // bir alan olduğundan kendi sütununa ihtiyaç duyar. Bu sütun
          // eklenmeden önce titleSpans hiçbir yere yazılmıyordu; bu yüzden
          // başlığa uygulanan zengin metin uygulama yeniden açıldığında
          // kayboluyordu.
          await _addColumnIfMissing(db, 'notes', 'titleSpans', 'TEXT');
          await _addColumnIfMissing(db, 'deleted_notes', 'titleSpans', 'TEXT');
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
            bgColor INTEGER,
            titleSpans TEXT,
            isLocked INTEGER NOT NULL DEFAULT 0,
            isArchived INTEGER NOT NULL DEFAULT 0,
            isFavorite INTEGER NOT NULL DEFAULT 0,
            isPinnedToNotification INTEGER NOT NULL DEFAULT 0
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
            bgColor INTEGER,
            titleSpans TEXT,
            isLocked INTEGER NOT NULL DEFAULT 0,
            isArchived INTEGER NOT NULL DEFAULT 0,
            isFavorite INTEGER NOT NULL DEFAULT 0,
            isPinnedToNotification INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE categories (
            name TEXT PRIMARY KEY,
            color TEXT,
            isLocked INTEGER NOT NULL DEFAULT 0,
            sortOrder INTEGER NOT NULL DEFAULT 0,
            parent TEXT
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

  /// Bir tabloda belirtilen sütun yoksa güvenli şekilde ekler.
  /// Sütun zaten varsa (örn. yarım kalmış bir önceki migration yüzünden)
  /// "duplicate column name" hatası fırlatmadan sessizce atlar.
  Future<void> _addColumnIfMissing(
    Database db,
    String table,
    String column,
    String type,
  ) async {
    final result = await db.rawQuery('PRAGMA table_info($table)');
    final exists = result.any((row) => row['name'] == column);
    if (!exists) {
      await db.execute('ALTER TABLE $table ADD COLUMN $column $type');
    }
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
      'bgColor': (note['bgColor'] as num?)?.toInt(),
      // Başlığın zengin metin span'ları (bkz. RichTextSpans). Boşsa null
      // yazılır ki eski notlarda olduğu gibi "spans hiç yok" davranışı
      // korunsun (RichTextSpans.parse zaten null'ı boş liste sayıyor).
      'titleSpans': (note['titleSpans'] != null && (note['titleSpans'] as List).isNotEmpty)
          ? jsonEncode(note['titleSpans'])
          : null,
      'isLocked': (note['isLocked'] == true) ? 1 : 0,
      'isArchived': (note['isArchived'] == true) ? 1 : 0,
      'isFavorite': (note['isFavorite'] == true) ? 1 : 0,
      'isPinnedToNotification': (note['isPinnedToNotification'] == true) ? 1 : 0,
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
      if (row['bgColor'] != null) 'bgColor': row['bgColor'],
      if (row['titleSpans'] != null)
        'titleSpans': jsonDecode(row['titleSpans'] as String),
      'isLocked': row['isLocked'] == 1,
      'isArchived': row['isArchived'] == 1,
      'isFavorite': row['isFavorite'] == 1,
      'isPinnedToNotification': row['isPinnedToNotification'] == 1,
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
    // Not listesi her kaydedildiğinde ana ekran widget'ını da güncelle.
    // Widget güncellemesi başarısız olsa bile (ör. native taraf henüz
    // kurulmamışsa) not kaydetme işlemini etkilememesi için senkron
    // akışın dışında (unawaited) tetiklenir.
    unawaited(NoteWidgetService.instance.syncFromNotes(notes));
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

  /// Tek bir notun 'isPinnedToNotification' alanını, tüm not listesini
  /// yeniden yazmadan (replaceNotes gibi) doğrudan veritabanında günceller.
  /// Bildirim panelindeki "Kaldır" aksiyonuna uygulama tamamen kapalıyken
  /// dokunulduğunda, ayrı bir arka plan isolate'ından (bkz.
  /// reminder_service.dart -> _dNoteOnBackgroundNotificationResponse)
  /// çağrılır; bu yüzden çalışan bir _notes listesine bağımlı olmayan,
  /// bağımsız ve ucuz bir yazım olmalıdır. Not artık mevcut değilse (ör.
  /// arada silinmişse) sessizce hiçbir şey yapmaz.
  Future<void> setPinnedToNotification(String noteId, bool value) async {
    final db = await database;
    await db.update(
      'notes',
      {'isPinnedToNotification': value ? 1 : 0},
      where: 'id = ?',
      whereArgs: [noteId],
    );
  }

  // ── Kategoriler ──────────────────────────────────────────────────────
  Future<void> replaceCategories(
    List<String> categories,
    Map<String, String> colors,
    Set<String> locked, [
    // Alt klasör desteği: bir kategori adını, ait olduğu üst kategorinin
    // adına eşler. Üst seviye bir kategori/klasör için değer null'dur
    // (veya harita içinde hiç bulunmaz).
    Map<String, String?> parents = const {},
  ]) async {
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
          'parent': parents[name],
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
    final parents = <String, String?>{};
    for (final row in rows) {
      final name = row['name'] as String;
      categories.add(name);
      if (row['color'] != null) colors[name] = row['color'] as String;
      if (row['isLocked'] == 1) locked.add(name);
      final parentName = row['parent'] as String?;
      if (parentName != null && parentName.isNotEmpty) {
        parents[name] = parentName;
      }
    }
    return {
      'categories': categories,
      'colors': colors,
      'locked': locked,
      'parents': parents,
    };
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

  // Not: her sonuç öğesi 'oldId' alanını da taşır (yeni 'id' değeriyle
  // birlikte). Bu, çağıran tarafın (not kopyalama akışı) not içeriğindeki
  // ('content' JSON'ındaki 'attachments'/'layout' blokları gibi) eski id
  // referanslarını yeni id'lere eşleyebilmesi için gereklidir; aksi halde
  // kopyalanan nota gömülü resimler eski (artık var olmayan) id'lere işaret
  // ederek görünmez hale gelir.
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
      result.add({
        ...a,
        'oldId': a['id'],
        'id': '${a['id']}_copy',
        'storedName': newStored,
      });
    }
    return result;
  }
}