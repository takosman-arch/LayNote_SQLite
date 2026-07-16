part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// AŞAMA 5.4 NOTU — ESKİ ANDROID İZİN KONTROLLERİ:
// Android 11 (API 30) ile gelen "scoped storage" modeli sayesinde bu
// uygulama zaten sadece kendi özel klasörünü (getApplicationDocuments
// Directory → backupsDir/attachmentsDir) ve SAF (Storage Access
// Framework — file_picker'ın kullandığı sistem dosya seçici) üzerinden
// erişilen dosyaları kullanıyor; bunların HİÇBİRİ çalışma zamanı izni
// gerektirmez. Ancak Android 10 (API 29) ve altı sürümlerde bazı
// cihaz/OEM kombinasyonlarında dosya işlemleri yine de klasik
// READ/WRITE_EXTERNAL_STORAGE iznine takılabiliyor. Bu yüzden aşağıdaki
// kontrol SADECE bu eski sürümlerde devreye girer; Android 11+
// cihazlarda tamamen atlanır (gereksiz izin isteğiyle kullanıcıyı
// rahatsız etmemek için).
//
// GEREKLİ EK BAĞIMLILIKLAR (pubspec.yaml'a eklenmesi gerekir):
//   permission_handler: ^11.0.0
//   device_info_plus: ^10.0.0
// (sürüm numaraları örnektir; projenizdeki diğer paketlerle uyumlu en
// güncel sürümleri kullanmanız yeterlidir.)
//
// GEREKLİ EK IMPORT (ana dosyada, main_asama_4_3a.dart içinde):
//   import 'package:permission_handler/permission_handler.dart';
//   import 'package:device_info_plus/device_info_plus.dart';
//
// GEREKLİ MANİFEST İZNİ (android/app/src/main/AndroidManifest.xml,
// <manifest> etiketi içine, <application> etiketinden ÖNCE):
//   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
//       android:maxSdkVersion="32" />
//   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
//       android:maxSdkVersion="29" />
// (maxSdkVersion, iznin yalnızca belirtilen sürüme kadar istenmesini
// sağlar; daha yeni cihazlarda sistem bu satırları zaten yok sayar ama
// eklemek en güvenlisidir.)
// ════════════════════════════════════════════════════════════════════════

// ════════════════════════════════════════════════════════════════════════
// AŞAMA 5.3 NOTU — PERFORMANS İNCE AYARLARI (büyük dosyalar):
// 1) Zip SIKIŞTIRMA (createBackup) ve zip ÇÖZME (decode/preview/restore)
//    işlemleri artık compute() ile ARKA PLAN isolate'ında çalışır. Bu
//    işlemler CPU-yoğun ve senkron olduğundan, büyük yedeklerde (çok
//    sayıda / büyük ek dosya) ana isolate'ta çalıştırılırlarsa arayüz
//    donar ve Android'de "Yanıt Vermiyor" (ANR) uyarısına bile yol
//    açabilirdi. Artık dosya okuma/yazma (I/O) hâlâ ana isolate'ta ama
//    zaten asenkron olduğu için sorun değil; sadece sıkıştırma/çözme gibi
//    saf CPU işi arka plana taşındı.
// 2) estimateAttachmentsSize() ile arayüz katmanı, işlem başlamadan ÖNCE
//    (dosya içeriklerini okumadan, sadece meta veriyle) yaklaşık boyutu
//    öğrenip kullanıcıyı "bu biraz sürebilir" diye uyarabiliyor (bkz.
//    backup_restore_screen_5_3.dart).
//
// GEREKLİ EK IMPORT (ana dosyada, main_asama_4_3a.dart içinde, bu "part"
// dosyaları derlenebilsin diye zaten olması/eklenmesi gerekenler):
//   import 'dart:typed_data';            // Uint8List
//   import 'package:flutter/foundation.dart'; // compute()
// (material.dart genelde foundation.dart'ı örtülü olarak sürüklese de,
// derleme hatası alırsan bu iki satırı ana dosyaya eklemen yeterli.)
// ════════════════════════════════════════════════════════════════════════

// ════════════════════════════════════════════════════════════════════════
// AŞAMA 5.2 NOTU: Son başarılı yedekleme zamanı artık createBackup()
// içinde otomatik olarak ayarlara kaydediliyor (bkz. aşağıdaki
// lastBackupDateSettingKey / _saveLastBackupDate / getLastBackupDate).
// Ayrı bir tablo/dosya açılmadı — DBHelper.setSetting/getAllSettings
// üzerinden diğer uygulama ayarlarıyla aynı mekanizma kullanıldı.
// ════════════════════════════════════════════════════════════════════════

// ════════════════════════════════════════════════════════════════════════
// AŞAMA 5.1 NOTU: Yedek Geçmişi ekranı (backup_history_screen_5_1.dart)
// bu dosyadaki listBackups(), deleteBackupFile() ve formatFileSize()
// fonksiyonlarını DOĞRUDAN kullanır — bunlar zaten Aşama 1'den beri
// mevcuttu, bu yüzden bu dosyada işlevsel bir değişiklik YOK. Sadece
// dosya, üst katmandaki yeni ekranla tutarlı sürüm numarasıyla (5_1)
// yeniden adlandırıldı.
// ════════════════════════════════════════════════════════════════════════

// ════════════════════════════════════════════════════════════════════════
// AŞAMA 4.3c NOTU: Bu dosyanın mantık katmanında (BackupErrorType,
// BackupOperationException, BackupValidationException, BackupPreview,
// eksik ek dosya tespiti) 4.3a'da tamamlanan altyapı değişmeden kullanılır.
// 4.3c'de asıl değişiklikler arayüz tarafında (backup_restore_screen):
// eksik ek dosya uyarısının onay diyaloğunda gösterilmesi, geri yükleme
// sonrası daha bilgilendirici mesajlar ve küçük son rötuşlar.
// ════════════════════════════════════════════════════════════════════════

// ════════════════════════════════════════════════════════════════════════
// YEREL YEDEKLEME MOTORU (BACKUP ENGINE) — AŞAMA 1
// Uygulamanın tüm verilerini (notlar, çöp kutusundaki notlar, kategoriler,
// ayarlar) ve ekli dosyaları (attachments) tek bir .zip yedek dosyasında
// paketler. Yedekler cihazda "backups" klasöründe saklanır.
//
// NOT: Bu aşamada sadece YEDEK OLUŞTURMA mantığı vardır. Yedeği geri yükleme
// (restore) mantığı bir sonraki aşamada eklenecek, arayüz (ekran/buton) ise
// daha sonraki bir aşamada bağlanacaktır.
// ════════════════════════════════════════════════════════════════════════
class BackupHelper {
  BackupHelper._internal();
  static final BackupHelper instance = BackupHelper._internal();

  // Yedek dosyası formatının versiyonu. İleride yedek formatı değişirse
  // (örn. yeni bir tablo/alan eklenirse) geri yükleme sırasında bu numaraya
  // bakılarak eski/yeni yedekler arasında uyumluluk kontrolü yapılabilir.
  static const int backupFormatVersion = 1;

  // Zip içindeki veri dosyasının adı.
  static const String _dataFileName = 'backup_data.json';

  // Yedeklerin diskte tutulduğu klasör: .../Documents/dnote_backups/
  Future<Directory> backupsDir() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docsDir.path, 'dnote_backups'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  // Dosya adı için "20260716_143205" biçiminde bir zaman damgası üretir.
  String _timestampForFileName(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}${two(dt.month)}${two(dt.day)}_'
        '${two(dt.hour)}${two(dt.minute)}${two(dt.second)}';
  }

  // Tüm uygulama verilerini tek bir Map olarak toplar (JSON'a çevrilebilir).
  Future<Map<String, dynamic>> _collectBackupData() async {
    final db = DBHelper.instance;

    final notes = await db.getNotes();
    final deletedNotes = await db.getDeletedNotes();
    final categoriesData = await db.getCategoriesData();
    final settings = await db.getAllSettings();

    final lockedCategories =
        (categoriesData['locked'] as Set).cast<String>().toList();

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

  // Tüm verileri ve ek dosyaları içeren bir .zip yedeği oluşturur, dosyayı
  // backupsDir() içine kaydeder ve oluşan File nesnesini döner.
  //
  // onProgress: (0.0 - 1.0 arası ilerleme, kullanıcıya gösterilecek adım
  // etiketi) — AŞAMA 4.2'de eklenen adım adım ilerleme göstergesi için
  // kullanılır.
  Future<File> createBackup({
    void Function(double progress, String step)? onProgress,
  }) async {
    onProgress?.call(0.05, 'Veriler hazırlanıyor...');

    final backupData = await _collectBackupData();
    onProgress?.call(0.15, 'Notlar ve kategoriler paketleniyor...');

    final jsonBytesRaw = utf8.encode(jsonEncode(backupData));
    final jsonBytes = jsonBytesRaw is Uint8List
        ? jsonBytesRaw
        : Uint8List.fromList(jsonBytesRaw);

    // AŞAMA 5.3: ek dosyalar önce (asenkron I/O ile, ana isolate'ı
    // kilitlemeden) belleğe okunur. Asıl CPU-yoğun iş olan zip
    // sıkıştırması bu adımda YAPILMAZ — okuma bittikten sonra tek bir
    // compute() çağrısıyla arka planda yapılır (aşağıya bakınız).
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

    // ── AŞAMA 5.3: zip arşivinin oluşturulması VE sıkıştırılması, ana
    // isolate'ı (dolayısıyla arayüzü) kilitlememesi için compute() ile
    // ayrı bir isolate'a taşındı. Büyük yedeklerde bu adım birkaç saniye
    // sürebilir; ama bu sırada kullanıcı arayüzü (ilerleme göstergesi,
    // geri tuşu engeli vb.) donmadan tepkimeye devam eder.
    onProgress?.call(0.6, 'Zip dosyası sıkıştırılıyor...');
    final zipBytes = await compute(_encodeZipIsolate, {
      'dataFileName': _dataFileName,
      'jsonBytes': jsonBytes,
      'attachmentNames': attachmentNames,
      'attachmentBytesList': attachmentBytesList,
    });
    onProgress?.call(0.9, 'Dosya kaydediliyor...');

    // AŞAMA 4.3a: dosyaya yazma sırasında oluşabilecek "yetersiz depolama"
    // veya "izin reddedildi" gibi hatalar burada sınıflandırılıp arayüze
    // anlamlı bir mesajla iletilir.
    final dir = await backupsDir();
    final fileName = 'dnote_yedek_${_timestampForFileName(DateTime.now())}.zip';
    final zipFile = File(p.join(dir.path, fileName));
    try {
      await zipFile.writeAsBytes(zipBytes, flush: true);
    } catch (e) {
      throw BackupOperationException.fromError(e);
    }

    // AŞAMA 5.2: dosya diske başarıyla yazıldıktan hemen sonra "son
    // yedekleme zamanı" ayarlara kaydedilir. Bu kayıt işlemi başarısız
    // olsa bile yedek dosyasının kendisi zaten oluşturulmuş olduğundan
    // hata yutulur; kullanıcıya yanlışlıkla "yedekleme başarısız" izlenimi
    // verilmez (bkz. _saveLastBackupDate).
    await _saveLastBackupDate(DateTime.now());

    onProgress?.call(1.0, 'Tamamlandı');
    return zipFile;
  }

  // AŞAMA 5.3: zip arşivinin bellekte oluşturulup sıkıştırılması — saf CPU
  // işi. compute() tarafından çağrılabilmesi için üst düzey/static bir
  // fonksiyon olmalı ve yalnızca serileştirilebilir/kopyalanabilir
  // parametreler (String, Uint8List, bunların List/Map'leri) almalıdır.
  static Uint8List _encodeZipIsolate(Map<String, dynamic> job) {
    final archive = Archive();
    final dataFileName = job['dataFileName'] as String;
    final jsonBytes = job['jsonBytes'] as Uint8List;
    archive.addFile(
      ArchiveFile(dataFileName, jsonBytes.length, jsonBytes),
    );

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

  // backupsDir() içindeki mevcut yedek dosyalarını, en yeni en üstte olacak
  // şekilde sıralanmış olarak listeler.
  Future<List<File>> listBackups() async {
    final dir = await backupsDir();
    if (!await dir.exists()) return [];
    final files = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith('.zip'))
        .toList();
    files.sort(
      (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
    );
    return files;
  }

  // Bir yedek dosyasını diskten siler.
  Future<void> deleteBackupFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Sessizce geç; dosya zaten yoksa sorun değil.
    }
  }

  // ── PERFORMANS / BÜYÜK DOSYA İNCE AYARLARI — AŞAMA 5.3 ──────────────

  // Bu boyutun üzerindeki (tahmini) yedeklerde arayüz katmanı kullanıcıyı
  // "bu biraz sürebilir" diye önceden uyarır (bkz. backup_restore_screen
  // içindeki _confirmLargeOperation). Sadece bir bilgilendirme eşiğidir;
  // işlemi engellemez, kullanıcı isterse yine de devam edebilir.
  static const int largeBackupWarningBytes = 100 * 1024 * 1024; // 100 MB

  // Cihazdaki ek dosyaların toplam boyutunu, dosya İÇERİKLERİNİ OKUMADAN
  // (yalnızca dosya sistemi meta verisiyle, yani hızlıca) hesaplar. Yedek
  // oluşturmadan ÖNCE "büyük yedek" uyarısı gösterilip gösterilmeyeceğine
  // karar vermek için arayüz katmanında kullanılır.
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

  // ── ESKİ ANDROID İZİN KONTROLLERİ — AŞAMA 5.4 ────────────────────────

  // Cihazın Android sürümünün "eski" (API 29 / Android 10 ve altı)
  // sayılıp sayılmadığını döner. Android dışı platformlarda (iOS vb.)
  // her zaman false döner — izin akışı sadece Android'e özgüdür.
  Future<bool> _isLegacyAndroid() async {
    if (!Platform.isAndroid) return false;
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      return info.version.sdkInt <= 29;
    } catch (_) {
      // Sürüm bilgisi okunamazsa güvenli tarafta kal: izin akışını
      // tetikleme (yeni cihazlarda gereksiz bir izin isteği göstermemek
      // için "eski değil" varsayılır).
      return false;
    }
  }

  // Gerekliyse (yalnızca Android 10 ve altında) depolama iznini kontrol
  // eder, verilmemişse sistem izin diyaloğunu göstererek ister. Android
  // 11+ veya Android dışı platformlarda hiçbir şey yapmadan doğrudan
  // `true` döner (izin zaten gerekmediği için). Kullanıcı izni
  // reddederse `false` döner; arayüz katmanı bu durumda kullanıcıyı
  // bilgilendirip isterse uygulama ayarlarına yönlendirebilir (bkz.
  // backup_restore_screen_5_4.dart içindeki _ensurePermission).
  Future<bool> ensureStoragePermissionIfNeeded() async {
    if (!await _isLegacyAndroid()) return true;
    final status = await Permission.storage.status;
    if (status.isGranted) return true;
    final result = await Permission.storage.request();
    return result.isGranted;
  }

  // Kullanıcı izni "bir daha sorma" ile kalıcı olarak reddettiyse true
  // döner. Bu durumda sistem izin diyaloğu bir daha gösterilemeyeceği
  // için arayüz katmanı, kullanıcıyı doğrudan uygulama ayarlarına
  // yönlendiren bir seçenek sunmalıdır (openAppSettings()).
  Future<bool> isStoragePermissionPermanentlyDenied() async {
    if (!await _isLegacyAndroid()) return false;
    final status = await Permission.storage.status;
    return status.isPermanentlyDenied;
  }

  // Bayt cinsinden bir dosya boyutunu "1.2 MB" gibi okunabilir bir metne
  // çevirir (yedek listesi ekranında kullanılmak üzere hazırlanmıştır).
  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // ── SON YEDEKLEME TARİHİ — AŞAMA 5.2 ────────────────────────────────

  // Son başarılı yedekleme zamanının ayarlarda saklanması için kullanılan
  // anahtar. DBHelper.setSetting/getAllSettings üzerinden diğer uygulama
  // ayarlarıyla aynı mekanizmada tutulur — ayrı bir dosya/tablo gerekmez.
  static const String lastBackupDateSettingKey = 'last_backup_date';

  // Son başarılı yedekleme zamanını ayarlara kaydeder. createBackup()
  // içinde, zip dosyası diske başarıyla yazıldıktan hemen sonra çağrılır.
  // Kaydetme başarısız olsa bile (örn. veritabanı geçici olarak meşgulse)
  // yedek dosyasının kendisi zaten diskte oluşturulmuş olduğundan bu hata
  // sessizce yutulur — aksi halde kullanıcıya yanlışlıkla "yedekleme
  // başarısız oldu" izlenimi verilmiş olur.
  Future<void> _saveLastBackupDate(DateTime dt) async {
    try {
      await DBHelper.instance.setSetting(
        lastBackupDateSettingKey,
        dt.toIso8601String(),
      );
    } catch (_) {
      // Sessizce geç.
    }
  }

  // Son başarılı yedeklemenin ne zaman alındığını döner. Hiç yedek
  // alınmamışsa veya kayıt okunamıyorsa (örn. bozuk tarih metni) null
  // döner — çağıran taraf bunu "henüz yedek yok" olarak yorumlamalıdır.
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

  // ── GERİ YÜKLEME (RESTORE) — AŞAMA 2 ─────────────────────────────────

  // zip baytlarını Archive nesnesine çözer. Dosya bozuksa
  // BackupValidationException fırlatır. Hem readBackupData hem de
  // loadBackupPreview tarafından ortak kullanılır (kod tekrarını önler).
  //
  // AŞAMA 5.3: zip çözme (decode) de saf CPU işi olduğundan ve büyük
  // yedeklerde gözle görülür bir donmaya yol açabildiğinden, sıkıştırma
  // gibi compute() ile arka plan isolate'ına taşındı.
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

  // compute() tarafından çağrılan üst düzey/static yardımcı. Sadece
  // serileştirilebilir bir Uint8List alır, Archive döner.
  static Archive _decodeZipIsolate(Uint8List bytes) {
    return ZipDecoder().decodeBytes(bytes);
  }

  // Bir Archive içindeki backup_data.json'u okuyup doğrular ve Map olarak
  // döner. Format bozuksa veya dosya bu uygulamaya ait değilse ya da daha
  // yeni/desteklenmeyen bir sürümdeyse BackupValidationException fırlatır.
  Map<String, dynamic> _validateAndParseData(Archive archive) {
    final dataEntry = archive.files.where(
      (f) => f.isFile && f.name == _dataFileName,
    );
    if (dataEntry.isEmpty) {
      throw BackupValidationException(
        'Yedek dosyası içinde veri bulunamadı (backup_data.json eksik). '
        'Bu dosya dnote uygulamasına ait bir yedek olmayabilir.',
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
        'Yedek verisi okunamadı (bozuk JSON). Dosya eksik indirilmiş veya '
        'başka bir uygulama tarafından değiştirilmiş olabilir.',
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
        'Yedek dosyasının sürüm bilgisi okunamadı (bozuk yedek).',
        type: BackupErrorType.corruptedFile,
      );
    }
    if (formatVersion > backupFormatVersion) {
      throw BackupValidationException(
        'Bu yedek, uygulamanın şu anki sürümünün desteklemediği daha yeni '
        'bir formatta oluşturulmuş. Lütfen önce uygulamayı güncelleyin.',
        type: BackupErrorType.incompatibleVersion,
      );
    }
    if (formatVersion < 1) {
      throw BackupValidationException(
        'Yedek dosyasının sürüm bilgisi geçersiz (bozuk yedek).',
        type: BackupErrorType.corruptedFile,
      );
    }
    // Not: formatVersion < backupFormatVersion durumunda (eski ama geçerli
    // bir yedek) hata FIRLATILMAZ; ileride sürümler arası dönüştürme
    // (migration) burada eklenebilir. Şimdilik eski yedekler de doğrudan
    // kabul edilir.

    // ── AŞAMA 4.3a: DAHA SIKI FORMAT/YAPI KONTROLÜ ─────────────────────
    // Önceki sürümde alanlar sadece "varsa ve tipi yanlışsa" reddediliyordu.
    // Artık temel alanların (notes/deletedNotes/categories/settings)
    // MUTLAKA var ve doğru tipte olması, ayrıca liste elemanlarının da
    // (her not/kategori girdisinin) beklenen temel yapıda olması aranır.
    // Böylece yarım kalmış/elle bozulmuş dosyalar geri yükleme sırasında
    // değil, daha erken ve daha net bir mesajla reddedilir.
    bool isListOf<T>(dynamic v) => v is List && v.every((e) => e is T);

    if (data['notes'] is! List) {
      throw BackupValidationException(
        'Yedek verisi beklenen formatta değil (notlar alanı eksik veya '
        'geçersiz).',
        type: BackupErrorType.corruptedFile,
      );
    }
    if (data['deletedNotes'] is! List) {
      throw BackupValidationException(
        'Yedek verisi beklenen formatta değil (çöp kutusu alanı eksik '
        'veya geçersiz).',
        type: BackupErrorType.corruptedFile,
      );
    }
    if (data['categories'] is! List || !isListOf<String>(data['categories'])) {
      throw BackupValidationException(
        'Yedek verisi beklenen formatta değil (kategori listesi eksik '
        'veya geçersiz).',
        type: BackupErrorType.corruptedFile,
      );
    }
    if (data['settings'] != null && data['settings'] is! Map) {
      throw BackupValidationException(
        'Yedek verisi beklenen formatta değil (ayarlar alanı geçersiz).',
        type: BackupErrorType.corruptedFile,
      );
    }
    // Her not girdisi bir obje olmalı ve en azından geçerli bir 'id'
    // taşımalıdır; aksi halde veritabanına yazılırken sessizce bozuk
    // kayıtlar oluşabilir.
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
            'Yedek verisi beklenen formatta değil (kimliksiz bir not '
            'kaydı bulundu).',
            type: BackupErrorType.corruptedFile,
          );
        }
      }
    }

    return data;
  }

  // Bir .zip yedek dosyasını okuyup içindeki veriyi doğrular ve Map olarak
  // döner. Format bozuksa veya dosya bu uygulamaya ait değilse
  // BackupValidationException fırlatır.
  Future<Map<String, dynamic>> readBackupData(File zipFile) async {
    if (!await zipFile.exists()) {
      throw BackupValidationException(
        'Yedek dosyası bulunamadı.',
        type: BackupErrorType.fileNotFound,
      );
    }
    final bytes = await zipFile.readAsBytes();
    final archive = await _decodeArchive(bytes);
    return _validateAndParseData(archive);
  }

  // Bir notun 'attachments' alanındaki girdilerden dosya adlarını (varsa)
  // çıkarır. Ek dosyalar notlarda {'fileName': ..., ...} biçiminde
  // saklanır (bkz. üst katmandaki ek dosya ekleme akışı).
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

  // ── AŞAMA 4.1: YEDEK ÖNİZLEME ────────────────────────────────────────
  // Geri yüklemeden önce kullanıcıya yedeğin içeriği hakkında bilgi
  // (kaç not, kaç kategori, kaç ek dosya, ne zaman oluşturulduğu) gösterip
  // onay almak için kullanılır. Aynı zamanda zip'i sadece BİR KEZ decode
  // ederek bu sonucu restoreBackup()'a da aktarabiliriz (büyük yedeklerde
  // gereksiz ikinci bir okuma/decode işleminden kaçınmak için — bkz.
  // Aşama 5 performans notları).
  Future<BackupPreview> loadBackupPreview(File zipFile) async {
    if (!await zipFile.exists()) {
      throw BackupValidationException(
        'Yedek dosyası bulunamadı.',
        type: BackupErrorType.fileNotFound,
      );
    }

    Uint8List bytes;
    try {
      bytes = await zipFile.readAsBytes();
    } on BackupValidationException {
      rethrow;
    } catch (e) {
      // Dosya okunurken beklenmeyen bir hata (izin, I/O vb.) oluştuysa
      // bunu sınıflandırılmış bir hataya çevirip fırlat.
      throw BackupOperationException.fromError(e);
    }

    final archive = await _decodeArchive(bytes);
    final data = _validateAndParseData(archive);

    final notes = (data['notes'] as List?) ?? const [];
    final deletedNotes = (data['deletedNotes'] as List?) ?? const [];
    final categories = (data['categories'] as List?) ?? const [];
    final attachmentEntries = archive.files.where(
      (f) => f.isFile && f.name.startsWith('attachments/'),
    );
    final attachmentCount = attachmentEntries.length;
    final attachmentBytes = attachmentEntries.fold<int>(
      0,
      (sum, f) => sum + f.size,
    );

    // ── AŞAMA 4.3a: EKSİK EK DOSYA TESPİTİ ─────────────────────────────
    // Notlarda referans verilen ek dosya adları ile zip içindeki
    // 'attachments/' klasöründe gerçekten bulunan dosyalar karşılaştırılır.
    // Aradaki fark, kullanıcıya geri yükleme onay diyaloğunda gösterilmek
    // üzere `missingAttachmentNames` alanında toplanır (bkz. Aşama 4.3c).
    final referenced = _referencedAttachmentNames([...notes, ...deletedNotes]);
    final presentNames = attachmentEntries
        .map((f) => f.name.substring('attachments/'.length))
        .toSet();
    final missingAttachmentNames =
        referenced.difference(presentNames).toList()..sort();

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

  // Bir .zip yedek dosyasını geri yükler. DİKKAT: mevcut notlar, çöp
  // kutusu, kategoriler, ayarlar ve ek dosyaların TAMAMININ YERİNE
  // yedekteki veriler yazılır — mevcut veriler kalıcı olarak kaybolur.
  // Bu yüzden çağıran taraf (arayüz), işlemden önce kullanıcıdan onay
  // almalıdır (Aşama 4'te eklenecek).
  Future<void> restoreBackup(
    File zipFile, {
    // AŞAMA 4.2: onProgress artık (0.0-1.0 ilerleme, kullanıcıya gösterilecek
    // adım etiketi) çifti gönderir; böylece arayüzde "Notlar yazılıyor",
    // "Ekler geri yükleniyor" gibi adım adım bilgi gösterilebilir.
    void Function(double progress, String step)? onProgress,
    // Aşama 4.1: eğer arayüz katmanı önizleme için zip'i zaten
    // loadBackupPreview() ile okuyup doğruladıysa, aynı sonucu buraya
    // aktararak dosyanın ikinci kez okunup decode edilmesi önlenir
    // (büyük yedeklerde gereksiz gecikmeyi engeller).
    BackupPreview? preloaded,
  }) async {
    onProgress?.call(0.05, 'Yedek doğrulanıyor...');
    final preview = preloaded ?? await loadBackupPreview(zipFile);
    final data = preview.data;
    final archive = preview.archive;
    onProgress?.call(0.15, 'Yedek doğrulandı, veriler hazırlanıyor...');

    final db = DBHelper.instance;

    // 1) Notlar ve çöp kutusu
    final notes = List<Map<String, dynamic>>.from(
      (data['notes'] as List? ?? []).map((n) => Map<String, dynamic>.from(n)),
    );
    final deletedNotes = List<Map<String, dynamic>>.from(
      (data['deletedNotes'] as List? ?? [])
          .map((n) => Map<String, dynamic>.from(n)),
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

    // 2) Kategoriler
    final categories = List<String>.from(
      (data['categories'] as List? ?? []).map((e) => e.toString()),
    );
    final categoryColors = Map<String, String>.from(
      (data['categoryColors'] as Map? ?? {}).map(
        (k, v) => MapEntry(k.toString(), v.toString()),
      ),
    );
    final lockedCategories = Set<String>.from(
      (data['lockedCategories'] as List? ?? []).map((e) => e.toString()),
    );
    onProgress?.call(0.48, 'Kategoriler yazılıyor...');
    await db.replaceCategories(categories, categoryColors, lockedCategories);
    onProgress?.call(0.55, 'Kategoriler yazıldı');

    // 3) Ayarlar
    final settings = Map<String, String>.from(
      (data['settings'] as Map? ?? {}).map(
        (k, v) => MapEntry(k.toString(), v.toString()),
      ),
    );
    onProgress?.call(0.58, 'Ayarlar yazılıyor...');
    for (final entry in settings.entries) {
      await db.setSetting(entry.key, entry.value);
    }
    onProgress?.call(0.62, 'Ayarlar yazıldı');

    // 4) Ek dosyalar (attachments): önce mevcut klasördeki dosyalar
    // temizlenir, ardından yedekteki dosyalar diske yazılır. Böylece
    // yedekte olmayan eski dosyalar birikip yer kaplamaz.
    onProgress?.call(0.65, 'Eski ek dosyalar temizleniyor...');
    final attDir = await db.attachmentsDir();
    if (await attDir.exists()) {
      final existing = attDir.listSync().whereType<File>();
      for (final f in existing) {
        try {
          await f.delete();
        } catch (_) {
          // Silinemeyen dosyayı atla, geri yüklemeyi durdurma.
        }
      }
    }

    final attachmentEntries = archive.files
        .where((f) => f.isFile && f.name.startsWith('attachments/'))
        .toList();
    if (attachmentEntries.isEmpty) {
      onProgress?.call(0.95, 'Ek dosya bulunmuyor, tamamlanıyor...');
    }
    // AŞAMA 4.3a: ek dosyalar yazılırken oluşabilecek "yetersiz depolama"
    // veya "izin reddedildi" hataları burada sınıflandırılır. Tek bir
    // dosyanın yazılamaması tüm geri yüklemeyi (ki bu noktada notlar,
    // kategoriler ve ayarlar zaten yazılmış durumda) durdurur ve arayüze
    // anlamlı bir hata olarak iletilir.
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
}

// ── AŞAMA 4.3a: HATA SINIFLANDIRMASI ─────────────────────────────────
// Yedekleme/geri yükleme sırasında oluşabilecek hatalar tek bir genel
// mesaj yerine daha spesifik kategorilere ayrılır. Böylece arayüz katmanı
// (Aşama 4.3b) hataya uygun bir mesaj ve gerekiyorsa "Tekrar Dene"
// aksiyonu sunabilir.
enum BackupErrorType {
  insufficientStorage, // Diskte yeterli boş alan yok
  permissionDenied, // Dosya sistemi izin hatası
  corruptedFile, // Zip/JSON bozuk, okunamıyor veya beklenmeyen formatta
  incompatibleVersion, // Desteklenmeyen/daha yeni yedek sürümü
  notDnoteBackup, // Bu uygulamaya ait bir yedek değil
  fileNotFound, // Yedek dosyası bulunamadı / erişilemedi
  missingAttachments, // Notlarda referans verilen bazı ek dosyalar zip'te yok
  unknown, // Sınıflandırılamayan diğer hatalar
}

// Yedek dosyası doğrulanamadığında veya okunamadığında fırlatılan hata.
// Arayüz katmanı bu hatayı yakalayıp kullanıcıya `message` alanını
// (Türkçe, kullanıcı dostu bir açıklama) gösterebilir. `type` alanı,
// hatanın kategorisine göre farklı davranış (örn. tekrar dene aksiyonu
// gösterip göstermeme) sergilemek için kullanılır. `retryable` alanı,
// aynı işlemi tekrar denemenin anlamlı olup olmadığını belirtir — örn.
// bozuk bir dosyayı tekrar denemek sonucu değiştirmez, ama bir izin
// hatasını kullanıcı izin verdikten sonra tekrar denemek anlamlıdır.
class BackupValidationException implements Exception {
  final String message;
  final BackupErrorType type;
  final bool retryable;

  BackupValidationException(
    this.message, {
    this.type = BackupErrorType.unknown,
    this.retryable = false,
  });

  @override
  String toString() => message;
}

// Yedekleme/geri yükleme sırasında (doğrulama dışında) oluşan, ham bir
// hatadan (örn. FileSystemException) sınıflandırılarak üretilen hata.
// BackupHelper'daki disk/dosya işlemleri sırasında yakalanan beklenmeyen
// hatalar bu tipe çevrilerek fırlatılır.
class BackupOperationException implements Exception {
  final BackupErrorType type;
  final String message;
  final bool retryable;

  BackupOperationException(
    this.type,
    this.message, {
    this.retryable = true,
  });

  @override
  String toString() => message;

  // Ham bir hatayı inceleyip uygun bir BackupErrorType ile sarmalar.
  // FileSystemException'ın taşıdığı işletim sistemi hata koduna (errno)
  // bakılarak "yetersiz depolama" (ENOSPC=28) ve "izin reddedildi"
  // (EACCES=13 / EPERM=1) gibi durumlar ayırt edilir. Bu kodlar Android
  // ve iOS'ta da POSIX tabanlı olduğundan geçerlidir.
  factory BackupOperationException.fromError(Object error) {
    if (error is BackupOperationException) return error;
    if (error is BackupValidationException) {
      return BackupOperationException(
        error.type,
        error.message,
        retryable: error.retryable,
      );
    }
    if (error is FileSystemException) {
      final errno = error.osError?.errorCode ?? -1;
      if (errno == 28) {
        return BackupOperationException(
          BackupErrorType.insufficientStorage,
          'Cihazda yeterli boş depolama alanı yok. Lütfen yer açıp '
          'tekrar deneyin.',
        );
      }
      if (errno == 13 || errno == 1) {
        return BackupOperationException(
          BackupErrorType.permissionDenied,
          'Dosya erişim izni reddedildi. Lütfen uygulama izinlerini '
          'kontrol edip tekrar deneyin.',
        );
      }
      return BackupOperationException(
        BackupErrorType.unknown,
        'Dosya işlemi sırasında bir hata oluştu: ${error.message}',
      );
    }
    return BackupOperationException(
      BackupErrorType.unknown,
      'Beklenmeyen bir hata oluştu: $error',
    );
  }
}

// ── AŞAMA 4.1: YEDEK ÖNİZLEME MODELİ ─────────────────────────────────
// loadBackupPreview() tarafından üretilir; hem onay diyaloğunda özet
// bilgi göstermek hem de restoreBackup()'a zip'i tekrar okutmadan
// aktarmak için kullanılır.
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
  // AŞAMA 4.3a: notlarda referans verilen ama zip içinde bulunamayan ek
  // dosyaların adları. Boşsa yedek eksiksizdir.
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


