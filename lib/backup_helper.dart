part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// YEREL YEDEKLEME MOTORU (BACKUP ENGINE) - AŞAMA 7 (ÇÖP KUTUSU ENTEGRASYONU)
// Uygulamanın tüm verilerini ve ekli dosyalarını tek bir .zip yedek dosyasında
// paketler. v6 şemasındaki 'deletedDate' alanı yedekleme motoruna işlenmiştir.
// ════════════════════════════════════════════════════════════════════════
class BackupHelper {
  BackupHelper._internal();
  static final BackupHelper instance = BackupHelper._internal();

  static const int backupFormatVersion = 1;
  static const String _dataFileName = 'backup_data.json';

  Future<Directory> backupsDir() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docsDir.path, 'dnote_backups'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  String _timestampForFileName(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}${two(dt.month)}${two(dt.day)}_${two(dt.hour)}${two(dt.minute)}${two(dt.second)}';
  }

  Future<Map<String, dynamic>> _collectBackupData() async {
    final db = DBHelper.instance;

    final notes = await db.getNotes();
    final deletedNotes = await db.getDeletedNotes();
    final categoriesData = await db.getCategoriesData();
    final settings = await db.getAllSettings();

    final lockedCategories = (categoriesData['locked'] as Set).cast<String>().toList();

    return {
      'formatVersion': backupFormatVersion,
      'appName': 'dnote',
      'createdAt': DateTime.now().toIso8601String(),
      'notes': notes,
      'deletedNotes': deletedNotes,
      'categories': categoriesData['categories'],
      'categoryColors': categoriesData['colors'],
      'lockedCategories': lockedCategories,
      'settings': settings,
    };
  }

  Future<File> createBackup({
    void Function(double progress, String step)? onProgress,
  }) async {
    onProgress?.call(0.05, 'Veriler hazırlanıyor...');

    final backupData = await _collectBackupData();
    onProgress?.call(0.15, 'Notlar ve kategoriler paketleniyor...');

    final jsonBytesRaw = utf8.encode(jsonEncode(backupData));
    final jsonBytes = jsonBytesRaw is Uint8List ? jsonBytesRaw : Uint8List.fromList(jsonBytesRaw);

    onProgress?.call(0.2, 'Ek dosyalar okunuyor...');
    final attDir = await DBHelper.instance.attachmentsDir();
    final attachmentNames = <String>[];
    final attachmentBytesList = <Uint8List>[];
    if (await attDir.exists()) {
      final files = attDir.listSync().whereType<File>().toList();
      for (var i = 0; i < files.length; i++) {
        final file = files[i];
        final bytes = await file.readAsBytes();
        attachmentNames.add('attachments/${p.basename(file.path)}');
        attachmentBytesList.add(bytes);
        if (files.isNotEmpty) {
          onProgress?.call(
            0.2 + 0.35 * ((i + 1) / files.length),
            'Ek dosyalar okunuyor... (${i + 1}/${files.length})',
          );
        }
      }
    }

    onProgress?.call(0.6, 'Zip dosyası sıkıştırılıyor...');
    final zipBytes = await compute(_encodeZipIsolate, {
      'dataFileName': _dataFileName,
      'jsonBytes': jsonBytes,
      'attachmentNames': attachmentNames,
      'attachmentBytesList': attachmentBytesList,
    });
    onProgress?.call(0.9, 'Dosya kaydediliyor...');

    final dir = await backupsDir();
    final fileName = 'dnote_yedek_${_timestampForFileName(DateTime.now())}.zip';
    final zipFile = File(p.join(dir.path, fileName));
    try {
      await zipFile.writeAsBytes(zipBytes, flush: true);
    } catch (e) {
      throw BackupOperationException.fromError(e);
    }

    await _saveLastBackupDate(DateTime.now());

    onProgress?.call(1.0, 'Tamamlandı');
    return zipFile;
  }

  static Uint8List _encodeZipIsolate(Map<String, dynamic> job) {
    final archive = Archive();
    final dataFileName = job['dataFileName'] as String;
    final jsonBytes = job['jsonBytes'] as Uint8List;
    archive.addFile(ArchiveFile(dataFileName, jsonBytes.length, jsonBytes));

    final names = job['attachmentNames'] as List<String>;
    final bytesList = job['attachmentBytesList'] as List<Uint8List>;
    for (var i = 0; i < names.length; i++) {
      final bytes = bytesList[i];
      archive.addFile(ArchiveFile(names[i], bytes.length, bytes));
    }

    final encoded = ZipEncoder().encode(archive);
    if (encoded == null) {
      throw Exception('Zip arşivi oluşturulamadı (ZipEncoder null döndürdü).');
    }
    return encoded is Uint8List ? encoded : Uint8List.fromList(encoded);
  }

  Future<List<File>> listBackups() async {
    final dir = await backupsDir();
    if (!await dir.exists()) return [];
    final files = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith('.zip'))
        .toList();
    files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    return files;
  }

  Future<void> deleteBackupFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }

  static const int largeBackupWarningBytes = 100 * 1024 * 1024;

  Future<int> estimateAttachmentsSize() async {
    try {
      final dir = await DBHelper.instance.attachmentsDir();
      if (!await dir.exists()) return 0;
      var total = 0;
      for (final f in dir.listSync().whereType<File>()) {
        total += await f.length();
      }
      return total;
    } catch (_) {
      return 0;
    }
  }

  Future<bool> _isLegacyAndroid() async {
    if (!Platform.isAndroid) return false;
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      return info.version.sdkInt <= 29;
    } catch (_) {
      return false;
    }
  }

  Future<bool> ensureStoragePermissionIfNeeded() async {
    if (!await _isLegacyAndroid()) return true;
    final status = await Permission.storage.status;
    if (status.isGranted) return true;
    final result = await Permission.storage.request();
    return result.isGranted;
  }

  Future<bool> isStoragePermissionPermanentlyDenied() async {
    if (!await _isLegacyAndroid()) return false;
    final status = await Permission.storage.status;
    return status.isPermanentlyDenied;
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  static const String lastBackupDateSettingKey = 'last_backup_date';

  Future<void> _saveLastBackupDate(DateTime dt) async {
    try {
      await DBHelper.instance.setSetting(lastBackupDateSettingKey, dt.toIso8601String());
    } catch (_) {}
  }

  Future<DateTime?> getLastBackupDate() async {
    try {
      final settings = await DBHelper.instance.getAllSettings();
      final raw = settings[lastBackupDateSettingKey];
      if (raw == null) return null;
      return DateTime.tryParse(raw.toString());
    } catch (_) {
      return null;
    }
  }

  Future<Archive> _decodeArchive(Uint8List bytes) async {
    try {
      return await compute(_decodeZipIsolate, bytes);
    } catch (_) {
      throw BackupValidationException(
        'Dosya bozuk veya geçerli bir yedek dosyası değil.',
        type: BackupErrorType.corruptedFile,
      );
    }
  }

  static Archive _decodeZipIsolate(Uint8List bytes) {
    return ZipDecoder().decodeBytes(bytes);
  }

  Map<String, dynamic> _validateAndParseData(Archive archive) {
    final dataEntry = archive.files.where((f) => f.isFile && f.name == _dataFileName);
    if (dataEntry.isEmpty) {
      throw BackupValidationException(
        'Yedek dosyası içinde veri bulunamadı (backup_data.json eksik).',
        type: BackupErrorType.notDnoteBackup,
      );
    }

    Map<String, dynamic> data;
    try {
      final jsonStr = utf8.decode(dataEntry.first.content as List<int>);
      final decoded = jsonDecode(jsonStr);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('kök öğe bir obje değil');
      }
      data = decoded;
    } catch (_) {
      throw BackupValidationException(
        'Yedek verisi okunamadı (bozuk JSON).',
        type: BackupErrorType.corruptedFile,
      );
    }

    if (data['appName'] != 'dnote') {
      throw BackupValidationException(
        'Bu dosya dnote uygulamasına ait bir yedek değil.',
        type: BackupErrorType.notDnoteBackup,
      );
    }
    final formatVersion = data['formatVersion'];
    if (formatVersion is! int) {
      throw BackupValidationException(
        'Yedek dosyasının sürüm bilgisi okunamadı.',
        type: BackupErrorType.corruptedFile,
      );
    }
    if (formatVersion > backupFormatVersion) {
      throw BackupValidationException(
        'Bu yedek, uygulamanın şu anki sürümünün desteklemediği daha yeni bir formatta. Lütfen uygulamayı güncelleyin.',
        type: BackupErrorType.incompatibleVersion,
      );
    }
    if (formatVersion < 1) {
      throw BackupValidationException(
        'Yedek dosyasının sürüm bilgisi geçersiz.',
        type: BackupErrorType.corruptedFile,
      );
    }

    bool isListOf<T>(dynamic v) => v is List && v.every((e) => e is T);

    if (data['notes'] is! List) {
      throw BackupValidationException(
        'Yedek verisi beklenen formatta değil (notlar alanı eksik).',
        type: BackupErrorType.corruptedFile,
      );
    }
    if (data['deletedNotes'] is! List) {
      throw BackupValidationException(
        'Yedek verisi beklenen formatta değil (çöp kutusu alanı eksik).',
        type: BackupErrorType.corruptedFile,
      );
    }
    if (data['categories'] is! List || !isListOf<String>(data['categories'])) {
      throw BackupValidationException(
        'Yedek verisi beklenen formatta değil (kategori listesi geçersiz).',
        type: BackupErrorType.corruptedFile,
      );
    }
    if (data['settings'] != null && data['settings'] is! Map) {
      throw BackupValidationException(
        'Yedek verisi beklenen formatta değil (ayarlar alanı geçersiz).',
        type: BackupErrorType.corruptedFile,
      );
    }
    for (final list in [data['notes'], data['deletedNotes']]) {
      for (final item in (list as List)) {
        if (item is! Map) {
          throw BackupValidationException(
            'Yedek verisi beklenen formatta değil (bir not kaydı geçersiz).',
            type: BackupErrorType.corruptedFile,
          );
        }
        final id = item['id'];
        if (id == null || id.toString().trim().isEmpty) {
          throw BackupValidationException(
            'Yedek verisi beklenen formatta değil (kimliksiz bir not kaydı bulundu).',
            type: BackupErrorType.corruptedFile,
          );
        }
      }
    }

    return data;
  }

  Future<Map<String, dynamic>> readBackupData(File zipFile) async {
    if (!await zipFile.exists()) {
      throw BackupValidationException('Yedek dosyası bulunamadı.', type: BackupErrorType.fileNotFound);
    }
    final bytes = await zipFile.readAsBytes();
    final archive = await _decodeArchive(bytes);
    return _validateAndParseData(archive);
  }

  Set<String> _referencedAttachmentNames(List<dynamic> notes) {
    final names = <String>{};
    for (final note in notes) {
      if (note is! Map) continue;
      final atts = note['attachments'];
      if (atts is! List) continue;
      for (final att in atts) {
        if (att is Map && att['fileName'] != null) {
          final name = att['fileName'].toString();
          if (name.isNotEmpty) names.add(name);
        }
      }
    }
    return names;
  }

  Future<BackupPreview> loadBackupPreview(File zipFile) async {
    if (!await zipFile.exists()) {
      throw BackupValidationException('Yedek dosyası bulunamadı.', type: BackupErrorType.fileNotFound);
    }

    Uint8List bytes;
    try {
      bytes = await zipFile.readAsBytes();
    } on BackupValidationException {
      rethrow;
    } catch (e) {
      throw BackupOperationException.fromError(e);
    }

    final archive = await _decodeArchive(bytes);
    final data = _validateAndParseData(archive);

    final notes = (data['notes'] as List?) ?? const [];
    final deletedNotes = (data['deletedNotes'] as List?) ?? const [];
    final categories = (data['categories'] as List?) ?? const [];
    final attachmentEntries = archive.files.where((f) => f.isFile && f.name.startsWith('attachments/'));
    final attachmentCount = attachmentEntries.length;
    final attachmentBytes = attachmentEntries.fold<int>(0, (sum, f) => sum + f.size);

    final referenced = _referencedAttachmentNames([...notes, ...deletedNotes]);
    final presentNames = attachmentEntries.map((f) => f.name.substring('attachments/'.length)).toSet();
    final missingAttachmentNames = referenced.difference(presentNames).toList()..sort();

    DateTime? createdAt;
    final createdAtRaw = data['createdAt'];
    if (createdAtRaw is String) {
      createdAt = DateTime.tryParse(createdAtRaw);
    }

    return BackupPreview(
      data: data,
      archive: archive,
      sourceFile: zipFile,
      noteCount: notes.length,
      deletedNoteCount: deletedNotes.length,
      categoryCount: categories.length,
      attachmentCount: attachmentCount,
      attachmentBytesTotal: attachmentBytes,
      createdAt: createdAt,
      formatVersion: data['formatVersion'] as int,
      missingAttachmentNames: missingAttachmentNames,
    );
  }

  Future<void> restoreBackup(
    File zipFile, {
    void Function(double progress, String step)? onProgress,
    BackupPreview? preloaded,
  }) async {
    onProgress?.call(0.05, 'Yedek doğrulanıyor...');
    final preview = preloaded ?? await loadBackupPreview(zipFile);
    final data = preview.data;
    final archive = preview.archive;
    onProgress?.call(0.15, 'Yedek doğrulandı, veriler hazırlanıyor...');

    final db = DBHelper.instance;

    final notes = List<Map<String, dynamic>>.from(
      (data['notes'] as List? ?? []).map((n) => Map<String, dynamic>.from(n)),
    );
    final deletedNotes = List<Map<String, dynamic>>.from(
      (data['deletedNotes'] as List? ?? []).map((n) => Map<String, dynamic>.from(n)),
    );
    onProgress?.call(0.25, 'Notlar yazılıyor...');
    try {
      await db.replaceNotes(notes);
      onProgress?.call(0.35, 'Çöp kutusu yazılıyor...');
      await db.replaceDeletedNotes(deletedNotes);
    } catch (e) {
      throw BackupOperationException.fromError(e);
    }
    onProgress?.call(0.4, 'Çöp kutusu yazıldı');

    final categories = List<String>.from((data['categories'] as List? ?? []).map((e) => e.toString()));
    final categoryColors = Map<String, String>.from(
      (data['categoryColors'] as Map? ?? {}).map((k, v) => MapEntry(k.toString(), v.toString())),
    );
    final lockedCategories = Set<String>.from((data['lockedCategories'] as List? ?? []).map((e) => e.toString()));
    onProgress?.call(0.48, 'Kategoriler yazılıyor...');
    await db.replaceCategories(categories, categoryColors, lockedCategories);
    onProgress?.call(0.55, 'Kategoriler yazıldı');

    final settings = Map<String, String>.from(
      (data['settings'] as Map? ?? {}).map((k, v) => MapEntry(k.toString(), v.toString())),
    );
    onProgress?.call(0.58, 'Ayarlar yazılıyor...');
    for (final entry in settings.entries) {
      await db.setSetting(entry.key, entry.value);
    }
    onProgress?.call(0.62, 'Ayarlar yazıldı');

    onProgress?.call(0.65, 'Eski ek dosyalar temizleniyor...');
    final attDir = await db.attachmentsDir();
    if (await attDir.exists()) {
      final existing = attDir.listSync().whereType<File>();
      for (final f in existing) {
        try {
          await f.delete();
        } catch (_) {}
      }
    }

    final attachmentEntries = archive.files.where((f) => f.isFile && f.name.startsWith('attachments/')).toList();
    if (attachmentEntries.isEmpty) {
      onProgress?.call(0.95, 'Ek dosya bulunmuyor, tamamlanıyor...');
    }
    for (var i = 0; i < attachmentEntries.length; i++) {
      final entry = attachmentEntries[i];
      final name = entry.name.substring('attachments/'.length);
      if (name.isEmpty) continue;
      final outFile = File(p.join(attDir.path, name));
      try {
        await outFile.writeAsBytes(entry.content as List<int>, flush: true);
      } catch (e) {
        throw BackupOperationException.fromError(e);
      }
      if (attachmentEntries.isNotEmpty) {
        onProgress?.call(
          0.65 + 0.3 * ((i + 1) / attachmentEntries.length),
          'Ekler geri yükleniyor... (${i + 1}/${attachmentEntries.length})',
        );
      }
    }

    onProgress?.call(1.0, 'Tamamlandı');
  }

  static Future<void> enforceLocalRetention(int maxBackups) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${directory.path}/dnote_backups');
      
      if (!await backupDir.exists()) return;

      List<FileSystemEntity> files = backupDir.listSync();
      final backupFiles = files.whereType<File>()
          .where((f) => f.path.toLowerCase().endsWith('.zip'))
          .toList()
        ..sort((a, b) => a.statSync().modified.compareTo(b.statSync().modified));

      if (backupFiles.length > maxBackups) {
        int deleteCount = backupFiles.length - maxBackups;
        for (int i = 0; i < deleteCount; i++) {
          await backupFiles[i].delete();
        }
      }
    } catch (e) {
      debugPrint("Yerel otomatik temizleme hatası: $e");
    }
  }
}

enum BackupErrorType {
  insufficientStorage,
  permissionDenied,
  corruptedFile,
  incompatibleVersion,
  notDnoteBackup,
  fileNotFound,
  missingAttachments,
  unknown,
}

class BackupValidationException implements Exception {
  final String message;
  final BackupErrorType type;
  final bool retryable;

  BackupValidationException(this.message, {this.type = BackupErrorType.unknown, this.retryable = false});

  @override
  String toString() => message;
}

class BackupOperationException implements Exception {
  final BackupErrorType type;
  final String message;
  final bool retryable;

  BackupOperationException(this.type, this.message, {this.retryable = true});

  @override
  String toString() => message;

  factory BackupOperationException.fromError(Object error) {
    if (error is BackupOperationException) return error;
    if (error is BackupValidationException) {
      return BackupOperationException(error.type, error.message, retryable: error.retryable);
    }
    if (error is FileSystemException) {
      final errno = error.osError?.errorCode ?? -1;
      if (errno == 28) {
        return BackupOperationException(
          BackupErrorType.insufficientStorage,
          'Cihazda yeterli boş depolama alanı yok. Lütfen yer açıp tekrar deneyin.',
        );
      }
      if (errno == 13 || errno == 1) {
        return BackupOperationException(
          BackupErrorType.permissionDenied,
          'Dosya erişim izni reddedildi. Lütfen uygulama izinlerini kontrol edip tekrar deneyin.',
        );
      }
      return BackupOperationException(BackupErrorType.unknown, 'Dosya işlemi sırasında bir hata oluştu: ${error.message}');
    }
    return BackupOperationException(BackupErrorType.unknown, 'Beklenmeyen bir hata oluştu: $error');
  }
}

class BackupPreview {
  final Map<String, dynamic> data;
  final Archive archive;
  final File sourceFile;
  final int noteCount;
  final int deletedNoteCount;
  final int categoryCount;
  final int attachmentCount;
  final int attachmentBytesTotal;
  final DateTime? createdAt;
  final int formatVersion;
  final List<String> missingAttachmentNames;

  bool get hasMissingAttachments => missingAttachmentNames.isNotEmpty;

  BackupPreview({
    required this.data,
    required this.archive,
    required this.sourceFile,
    required this.noteCount,
    required this.deletedNoteCount,
    required this.categoryCount,
    required this.attachmentCount,
    required this.attachmentBytesTotal,
    required this.createdAt,
    required this.formatVersion,
    this.missingAttachmentNames = const [],
  });
}