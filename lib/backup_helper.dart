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

  // BUG DÜZELTMESİ: Drive'dan (veya cihazdan) bir yedek geri yüklendiğinde
  // veriler veritabanına doğru şekilde yazılıyordu, ama NoteListScreen'in
  // bellekte tuttuğu _notes/_categories listeleri sadece initState()'te bir
  // kez _loadData() ile okunduğu için güncellenmiyordu — bu yüzden geri
  // yüklenen notlar uygulama kapatılıp yeniden açılana kadar ekranda
  // görünmüyordu. Çözüm: ReminderService.instance.onNotificationTapped ile
  // AYNI desende bir callback. NoteListLifecycleMixin.initState() bunu kendi
  // _loadData()'sına bağlar; restoreBackup() başarıyla tamamlandığında
  // BackupRestoreScreen bu callback'i tetikleyerek ekranı, kullanıcı geri
  // dönmeden ANINDA tazeler.
  VoidCallback? onRestoreCompleted;

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
    required AppLocalizations l10n,
    void Function(double progress, String step)? onProgress,
  }) async {
    onProgress?.call(0.05, l10n.backupCreatePreparingDataLabel);

    final backupData = await _collectBackupData();
    onProgress?.call(0.15, l10n.backupCreatePackagingNotesLabel);

    final jsonBytes = utf8.encode(jsonEncode(backupData));

    onProgress?.call(0.2, l10n.backupCreateReadingAttachmentsLabel);
    final attDir = await DBHelper.instance.attachmentsDir();
    final attachmentNames = <String>[];
    final attachmentBytesList = <Uint8List>[];
    if (await attDir.exists()) {
      // Yedeğe SADECE aktif notlara (çöp kutusu HARİÇ) referans veren ek
      // dosyaları dahil ediyoruz. Bu tek satır iki sorunu birden çözer:
      //  1) Öksüz (orphan) ekler: bir nota eklenmiş dosya sonradan
      //     silinmiş olsa bile fiziksel dosya attachmentsDir()'da kalıp
      //     her yedekte gereksiz yer kaplıyordu — artık hiçbir aktif nota
      //     referans vermeyen dosyalar zip'e hiç girmiyor.
      //  2) Çöp kutusundaki notların ekleri: kasıtlı bir tasarım kararı
      //     olarak yedeğe (ve dolayısıyla Drive'a) dahil edilmiyor — bir
      //     not çöpe atıldığında eki de artık "gidici" kabul ediliyor.
      //     (Not: deletedNotes'un kendisi JSON'da hâlâ yer alıyor, sadece
      //     fiziksel ek dosyası paketlenmiyor; restore tarafındaki
      //     "eksik ek" tespiti bu durumu zaten kullanıcıya bildiriyor.)
      // Notları referans kontrolünden önce JSON temsiline normalize
      // ediyoruz. db.getNotes() düz Map değil de toJson() içeren özel bir
      // model döndürüyorsa, _referencedAttachmentNames() içindeki
      // "note is! Map" kontrolü onu sessizce atlardı — bu da referans
      // listesinin boş kalıp AKTİF notların eklerinin bile yanlışlıkla
      // filtrelenmesine yol açardı. jsonEncode/jsonDecode round-trip'i,
      // backup_data.json'a giden ile birebir aynı şekli garanti eder.
      final notesJson = jsonDecode(jsonEncode(backupData['notes'])) as List<dynamic>;
      final referencedNames = _referencedAttachmentNames(notesJson);
      final files = attDir
          .listSync()
          .whereType<File>()
          .where((f) => referencedNames.contains(p.basename(f.path)))
          .toList();
      for (var i = 0; i < files.length; i++) {
        final file = files[i];
        final bytes = await file.readAsBytes();
        attachmentNames.add('attachments/${p.basename(file.path)}');
        attachmentBytesList.add(bytes);
        if (files.isNotEmpty) {
          onProgress?.call(
            0.2 + 0.35 * ((i + 1) / files.length),
            l10n.backupCreateReadingAttachmentsProgressLabel(i + 1, files.length),
          );
        }
      }
    }

    onProgress?.call(0.6, l10n.backupCreateCompressingLabel);
    Uint8List zipBytes;
    try {
      zipBytes = await compute(_encodeZipIsolate, {
        'dataFileName': _dataFileName,
        'jsonBytes': jsonBytes,
        'attachmentNames': attachmentNames,
        'attachmentBytesList': attachmentBytesList,
      });
    } catch (_) {
      throw BackupOperationException(
        BackupErrorType.unknown,
        l10n.backupErrorZipEncodeFailedMessage,
      );
    }
    onProgress?.call(0.9, l10n.backupCreateSavingFileLabel);

    final dir = await backupsDir();
    final fileName = 'Layout_${l10n.backupFileNameLabel}_${_timestampForFileName(DateTime.now())}.zip';
    final zipFile = File(p.join(dir.path, fileName));
    try {
      await zipFile.writeAsBytes(zipBytes, flush: true);
    } catch (e) {
      throw BackupOperationException.fromError(e, l10n);
    }

    await _saveLastBackupDate(DateTime.now());

    onProgress?.call(1.0, l10n.backupDriveOperationCompletedLabel);
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
      throw Exception('ZipEncoder returned null');
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

  Future<Archive> _decodeArchive(Uint8List bytes, AppLocalizations l10n) async {
    try {
      return await compute(_decodeZipIsolate, bytes);
    } catch (_) {
      throw BackupValidationException(
        l10n.backupValidationCorruptedFileMessage,
        type: BackupErrorType.corruptedFile,
      );
    }
  }

  static Archive _decodeZipIsolate(Uint8List bytes) {
    return ZipDecoder().decodeBytes(bytes);
  }

  Map<String, dynamic> _validateAndParseData(Archive archive, AppLocalizations l10n) {
    final dataEntry = archive.files.where((f) => f.isFile && f.name == _dataFileName);
    if (dataEntry.isEmpty) {
      throw BackupValidationException(
        l10n.backupValidationMissingDataMessage,
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
        l10n.backupValidationInvalidJsonMessage,
        type: BackupErrorType.corruptedFile,
      );
    }

    if (data['appName'] != 'dnote') {
      throw BackupValidationException(
        l10n.backupValidationNotDnoteBackupMessage,
        type: BackupErrorType.notDnoteBackup,
      );
    }
    final formatVersion = data['formatVersion'];
    if (formatVersion is! int) {
      throw BackupValidationException(
        l10n.backupValidationVersionUnreadableMessage,
        type: BackupErrorType.corruptedFile,
      );
    }
    if (formatVersion > backupFormatVersion) {
      throw BackupValidationException(
        l10n.backupValidationIncompatibleVersionMessage,
        type: BackupErrorType.incompatibleVersion,
      );
    }
    if (formatVersion < 1) {
      throw BackupValidationException(
        l10n.backupValidationInvalidVersionMessage,
        type: BackupErrorType.corruptedFile,
      );
    }

    bool isListOf<T>(dynamic v) => v is List && v.every((e) => e is T);

    if (data['notes'] is! List) {
      throw BackupValidationException(
        l10n.backupValidationMissingNotesFieldMessage,
        type: BackupErrorType.corruptedFile,
      );
    }
    if (data['deletedNotes'] is! List) {
      throw BackupValidationException(
        l10n.backupValidationMissingTrashFieldMessage,
        type: BackupErrorType.corruptedFile,
      );
    }
    if (data['categories'] is! List || !isListOf<String>(data['categories'])) {
      throw BackupValidationException(
        l10n.backupValidationInvalidCategoriesFieldMessage,
        type: BackupErrorType.corruptedFile,
      );
    }
    if (data['settings'] != null && data['settings'] is! Map) {
      throw BackupValidationException(
        l10n.backupValidationInvalidSettingsFieldMessage,
        type: BackupErrorType.corruptedFile,
      );
    }
    for (final list in [data['notes'], data['deletedNotes']]) {
      for (final item in (list as List)) {
        if (item is! Map) {
          throw BackupValidationException(
            l10n.backupValidationInvalidNoteRecordMessage,
            type: BackupErrorType.corruptedFile,
          );
        }
        final id = item['id'];
        if (id == null || id.toString().trim().isEmpty) {
          throw BackupValidationException(
            l10n.backupValidationMissingNoteIdMessage,
            type: BackupErrorType.corruptedFile,
          );
        }
      }
    }

    return data;
  }

  Future<Map<String, dynamic>> readBackupData(File zipFile, AppLocalizations l10n) async {
    if (!await zipFile.exists()) {
      throw BackupValidationException(l10n.backupValidationFileNotFoundMessage, type: BackupErrorType.fileNotFound);
    }
    final bytes = await zipFile.readAsBytes();
    final archive = await _decodeArchive(bytes, l10n);
    return _validateAndParseData(archive, l10n);
  }

  Set<String> _referencedAttachmentNames(List<dynamic> notes) {
    final names = <String>{};
    for (final note in notes) {
      if (note is! Map) continue;
      final atts = note['attachments'];
      if (atts is! List) continue;
      for (final att in atts) {
        if (att is Map && att['storedName'] != null) {
          final name = att['storedName'].toString();
          if (name.isNotEmpty) names.add(name);
        }
      }
    }
    return names;
  }

  Future<BackupPreview> loadBackupPreview(File zipFile, AppLocalizations l10n) async {
    if (!await zipFile.exists()) {
      throw BackupValidationException(l10n.backupValidationFileNotFoundMessage, type: BackupErrorType.fileNotFound);
    }

    Uint8List bytes;
    try {
      bytes = await zipFile.readAsBytes();
    } on BackupValidationException {
      rethrow;
    } catch (e) {
      throw BackupOperationException.fromError(e, l10n);
    }

    final archive = await _decodeArchive(bytes, l10n);
    final data = _validateAndParseData(archive, l10n);

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
    required AppLocalizations l10n,
    void Function(double progress, String step)? onProgress,
    BackupPreview? preloaded,
  }) async {
    onProgress?.call(0.05, l10n.backupRestoreValidatingLabel);
    final preview = preloaded ?? await loadBackupPreview(zipFile, l10n);
    final data = preview.data;
    final archive = preview.archive;
    onProgress?.call(0.15, l10n.backupRestoreValidatedPreparingDataLabel);

    final db = DBHelper.instance;

    final notes = List<Map<String, dynamic>>.from(
      (data['notes'] as List? ?? []).map((n) => Map<String, dynamic>.from(n)),
    );
    final deletedNotes = List<Map<String, dynamic>>.from(
      (data['deletedNotes'] as List? ?? []).map((n) => Map<String, dynamic>.from(n)),
    );
    onProgress?.call(0.25, l10n.backupRestoreWritingNotesLabel);
    try {
      await db.replaceNotes(notes);
      onProgress?.call(0.35, l10n.backupRestoreWritingTrashLabel);
      await db.replaceDeletedNotes(deletedNotes);
    } catch (e) {
      throw BackupOperationException.fromError(e, l10n);
    }
    onProgress?.call(0.4, l10n.backupRestoreTrashWrittenLabel);

    final categories = List<String>.from((data['categories'] as List? ?? []).map((e) => e.toString()));
    final categoryColors = Map<String, String>.from(
      (data['categoryColors'] as Map? ?? {}).map((k, v) => MapEntry(k.toString(), v.toString())),
    );
    final lockedCategories = Set<String>.from((data['lockedCategories'] as List? ?? []).map((e) => e.toString()));
    onProgress?.call(0.48, l10n.backupRestoreWritingCategoriesLabel);
    await db.replaceCategories(categories, categoryColors, lockedCategories);
    onProgress?.call(0.55, l10n.backupRestoreCategoriesWrittenLabel);

    final settings = Map<String, String>.from(
      (data['settings'] as Map? ?? {}).map((k, v) => MapEntry(k.toString(), v.toString())),
    );
    onProgress?.call(0.58, l10n.backupRestoreWritingSettingsLabel);
    for (final entry in settings.entries) {
      await db.setSetting(entry.key, entry.value);
    }
    onProgress?.call(0.62, l10n.backupRestoreSettingsWrittenLabel);

    onProgress?.call(0.65, l10n.backupRestoreCleaningOldAttachmentsLabel);
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
      onProgress?.call(0.95, l10n.backupRestoreNoAttachmentsFinishingLabel);
    }
    for (var i = 0; i < attachmentEntries.length; i++) {
      final entry = attachmentEntries[i];
      final name = entry.name.substring('attachments/'.length);
      if (name.isEmpty) continue;
      final outFile = File(p.join(attDir.path, name));
      try {
        await outFile.writeAsBytes(entry.content as List<int>, flush: true);
      } catch (e) {
        throw BackupOperationException.fromError(e, l10n);
      }
      if (attachmentEntries.isNotEmpty) {
        onProgress?.call(
          0.65 + 0.3 * ((i + 1) / attachmentEntries.length),
          l10n.backupRestoreAttachmentsProgressLabel(i + 1, attachmentEntries.length),
        );
      }
    }

    onProgress?.call(1.0, l10n.backupRestoreCompletedLabel);
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

  factory BackupOperationException.fromError(Object error, AppLocalizations l10n) {
    if (error is BackupOperationException) return error;
    if (error is BackupValidationException) {
      return BackupOperationException(error.type, error.message, retryable: error.retryable);
    }
    if (error is FileSystemException) {
      final errno = error.osError?.errorCode ?? -1;
      if (errno == 28) {
        return BackupOperationException(
          BackupErrorType.insufficientStorage,
          l10n.backupErrorInsufficientStorageMessage,
        );
      }
      if (errno == 13 || errno == 1) {
        return BackupOperationException(
          BackupErrorType.permissionDenied,
          l10n.backupErrorPermissionDeniedMessage,
        );
      }
      return BackupOperationException(
        BackupErrorType.unknown,
        l10n.backupErrorFileOperationMessage(error.message),
      );
    }
    return BackupOperationException(
      BackupErrorType.unknown,
      l10n.backupErrorUnexpectedMessage(error.toString()),
    );
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