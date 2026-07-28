part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// GOOGLE DRIVE YEDEKLEME — AŞAMA 6.1
// GİRİŞ / ÇIKIŞ VE YETKİLENDİRME TEMELİ
//
// Bu aşamada SADECE Google hesabıyla giriş yapma, oturumu sessizce devam
// ettirme ve Drive API'sine yetkili bir istemci (client) oluşturma
// altyapısı eklenir. Yükleme/indirme/listeleme bir sonraki aşamalarda
// (6.2, 6.3, 6.4) bu altyapının üzerine inşa edilecektir.
//
// NEDEN "drive.appdata" SCOPE'U?
// Google Drive API iki farklı erişim kapsamı sunar:
//   • drive.file  → uygulamanın oluşturduğu dosyalar, kullanıcının Drive'ında
//     GÖRÜNÜR (normal "Drive'ım" klasöründe listelenir).
//   • drive.appdata → "Uygulama Verileri" adı verilen özel, GİZLİ bir alan.
//     Bu alandaki dosyalar kullanıcının Drive web/mobil arayüzünde HİÇBİR
//     ZAMAN görünmez; sadece bu uygulama (aynı OAuth istemcisiyle) bu
//     dosyalara erişebilir. Kullanıcının isteği ("gizli dosya olarak
//     kaydedilecek") tam olarak bu scope ile karşılanır.
// Bu yüzden aşağıda SADECE drive.appdata scope'u istenir — uygulama,
// kullanıcının Drive'ındaki hiçbir başka dosyaya erişemez ve kullanıcının
// normal depolama kotasını (görünür şekilde) kirletmez.
//
// GEREKLİ EK BAĞIMLILIKLAR (pubspec.yaml'a eklenmesi gerekir):
//   google_sign_in: ^6.2.2
//   googleapis: ^13.2.0
//   extension_google_sign_in_as_googleapis_auth: ^2.0.1
// (sürüm numaraları örnektir; projenizdeki diğer paketlerle uyumlu en
// güncel sürümleri kullanmanız yeterlidir.)
//
// GEREKLİ EK IMPORT (ana dosyada, main.dart içinde, bu "part" dosyası
// derlenebilsin diye):
//   import 'package:google_sign_in/google_sign_in.dart';
//   import 'package:googleapis/drive/v3.dart' as drive;
//   import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
//
// NEDEN elle bir http.BaseClient yazmak yerine bu paket kullanılıyor?
// extension_google_sign_in_as_googleapis_auth, google_sign_in oturumunu
// googleapis'in beklediği bir istemciye çevirirken TOKEN SÜRESİ DOLDUĞUNDA
// OTOMATİK OLARAK YENİLER. Bu, özellikle Aşama 6.8'de eklenecek arka plan
// otomatik yedeklemesinde kritik önemde: kullanıcı ekranda olmasa bile
// (ve dolayısıyla elle giriş yapamayacak durumda iken) token'ın geçerli
// kalması gerekir.
//
// PLATFORM YAPILANDIRMASI (bu aşamada yapılması gerekenler):
//   • Android: Google Cloud Console'da bir OAuth 2.0 istemci kimliği
//     (Android türünde) oluşturup uygulamanın SHA-1 imza parmak izini
//     kaydetmeniz gerekir. android/app/build.gradle içindeki
//     applicationId ile Console'daki paket adı birebir eşleşmelidir.
//   • iOS: Console'da iOS türünde bir istemci oluşturup indirilen
//     GoogleService-Info.plist'i ios/Runner/ klasörüne eklemeniz ve
//     ios/Runner/Info.plist içine REVERSED_CLIENT_ID değerini
//     CFBundleURLSchemes olarak eklemeniz gerekir. (google_sign_in
//     paketinin kendi kurulum dokümanı bu adımları ayrıntılı anlatır.)
//   • Google Cloud Console'da "Google Drive API"nin etkinleştirilmiş
//     olması gerekir (API'ler ve Hizmetler → Kitaplık → Google Drive API
//     → Etkinleştir).
// Bu adımlar kod dışıdır; kodun kendisi bu aşamada bağımsız çalışır ama
// yukarıdaki Console yapılandırması yapılmadan giriş denemesi hata verir.
// ════════════════════════════════════════════════════════════════════════
class GoogleDriveHelper {
  GoogleDriveHelper._internal();
  static final GoogleDriveHelper instance = GoogleDriveHelper._internal();

  // Sadece "Uygulama Verileri" (gizli) alanına erişim isteniyor — bkz.
  // yukarıdaki not. Kullanıcının görünür Drive dosyalarına erişim YOK.
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveAppdataScope],
  );

  GoogleSignInAccount? _currentUser;

  // Arayüz katmanının "bağlı hesap" bilgisini göstermesi için.
  bool get isSignedIn => _currentUser != null;
  String? get accountEmail => _currentUser?.email;
  String? get accountDisplayName => _currentUser?.displayName;

  // AŞAMA 6.1: Uygulama her açıldığında (örn. main() içinde veya Ayarlar/
  // Yedekle ekranı ilk açıldığında) bu fonksiyon çağrılarak, kullanıcı daha
  // önce giriş yaptıysa oturumun sistem tarafından SESSİZCE (herhangi bir
  // diyalog göstermeden) geri yüklenmesi denenir. Böylece kullanıcı her
  // seferinde yeniden giriş yapmak zorunda kalmaz. Başarısız olursa (örn.
  // hiç giriş yapılmamışsa veya oturum süresi dolmuşsa) sessizce false
  // döner — arayüz katmanı bunu "giriş yapılmamış" olarak yorumlamalıdır.
  Future<bool> trySilentSignIn() async {
    try {
      final account = await _googleSignIn.signInSilently();
      _currentUser = account;
      return account != null;
    } catch (_) {
      _currentUser = null;
      return false;
    }
  }

  // Kullanıcıya Google'ın standart hesap seçme/izin ekranını gösterir.
  // Kullanıcı bir hesap seçip izin verirse true, iptal ederse veya bir
  // hata oluşursa false döner. Hata detayını arayüz katmanına iletmek
  // isterseniz GoogleDriveException fırlatan bir varyantı Aşama 6.10'da
  // eklenecektir; bu aşamada basit tutulmuştur.
  Future<bool> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      _currentUser = account;
      return account != null;
    } catch (_) {
      _currentUser = null;
      return false;
    }
  }

  // Oturumu kapatır. Not: signOut() sadece bu uygulamadaki oturumu
  // sonlandırır; kullanıcının cihazındaki genel Google hesabını
  // etkilemez. "Farklı hesapla giriş yap" senaryosu için de bu
  // kullanılabilir (signOut() sonrası tekrar signIn() çağrılır).
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Sessizce geç; zaten çıkış hedefleniyor.
    } finally {
      _currentUser = null;
    }
  }

  // AŞAMA 6.1: Yetkili bir Drive API istemcisi oluşturur. Giriş yapılmamışsa
  // (veya oturum geçersizse/token yenilenemiyorsa) null döner — çağıran
  // taraf (6.2/6.3/6.4) bunu "önce giriş yapılmalı" olarak yorumlamalıdır.
  //
  // NASIL ÇALIŞIR: extension_google_sign_in_as_googleapis_auth paketinin
  // sağladığı authenticatedClient() extension'ı, seçilen hesabın OAuth
  // bilgilerini googleapis'in beklediği bir istemciye (AuthClient) çevirir
  // VE bu istemci token süresi dolduğunda otomatik olarak yeniler. Elde
  // edilen istemci doğrudan drive.DriveApi'ye verilir.
  //
  // ÖNEMLİ: Dönen AuthClient'ın işiniz bittiğinde close() ile kapatılması
  // önerilir (aksi halde alttaki http istemcisi açık kalır). Bu yüzden
  // bu fonksiyonu kullanan her yer (6.2/6.3/6.4/6.5), işlemi bitirdiğinde
  // client'ı kapatmalıdır — aşağıdaki örnek kullanım şablonuna bakınız.
  // NOT: googleapis 13.x'te DriveApi artık dışarıya açık bir ".client"
  // getter'ı sunmuyor (kapatılabilecek http istemcisi kütüphane içinde
  // saklanıyor). Bu yüzden burada DriveApi ile birlikte, işiniz bitince
  // kapatabilmeniz için orijinal client de bir Dart "record" içinde
  // döndürülüyor.
  Future<({drive.DriveApi api, dynamic client})?> getDriveApi() async {
    // Oturum düşmüş olabilir ihtimaline karşı önce sessiz girişi dene.
    if (_currentUser == null) {
      final restored = await trySilentSignIn();
      if (!restored) return null;
    }

    try {
      debugPrint('[DRIVE DEBUG] authenticatedClient() çağrılıyor...');
      final client = await _googleSignIn.authenticatedClient();
      debugPrint('[DRIVE DEBUG] authenticatedClient() sonucu: ${client != null ? "ALINDI" : "NULL"}');
      if (client == null) return null;
      return (api: drive.DriveApi(client), client: client);
    } catch (e, stack) {
      debugPrint('[DRIVE DEBUG] authenticatedClient() HATASI: $e');
      debugPrint('[DRIVE DEBUG] Stack: $stack');
      return null;
    }
  }

  // ÖRNEK KULLANIM (6.3/6.4'te de izlenecek desen):
  //
  //   final session = await GoogleDriveHelper.instance.getDriveApi();
  //   if (session == null) { /* giriş yapılmamış, kullanıcıyı bilgilendir */ }
  //   try {
  //     // ... session.api ile istekler ...
  //   } finally {
  //     session?.client.close();
  //   }

  // ── DRIVE'A YÜKLEME (UPLOAD) — AŞAMA 6.2 ────────────────────────────
  //
  // Verilen yerel .zip yedek dosyasını Drive'ın GİZLİ "Uygulama Verileri"
  // (appDataFolder) alanına yükler. `parents: ['appDataFolder']` burada
  // gerçek bir klasör kimliği DEĞİL, Drive API'sinin özel bir takma adıdır
  // ("özel ad" — alias); Google bunu görünce dosyayı otomatik olarak
  // uygulamaya özel gizli alana koyar. Bu alandaki dosyalar:
  //   • Kullanıcının drive.google.com'daki normal görünümünde YER ALMAZ.
  //   • Kullanıcının Drive kotasını (görünür şekilde) TÜKETİR ama "Diğer"
  //     kategorisinde sayılır — normal dosyalarıyla karışmaz.
  //   • Sadece BU uygulamanın OAuth istemcisiyle silinebilir/okunabilir.
  //
  // NOT — İLERLEME (progress) SINIRLAMASI: googleapis paketinin media
  // upload akışı, http gönderiminin ham baytlarına göre ince taneli bir
  // "yüzde tamamlandı" bilgisi vermez (Drive API v3'ün resumable upload
  // protokolü elle yönetilmeden bu bilgi alınamaz). Bu yüzden burada
  // sadece "başlıyor / bitti" adımları raporlanır; büyük dosyalarda
  // gerçek yüzde ilerlemesi istenirse Aşama 6.10'da resumable upload'a
  // (drive.Media ile chunk bazlı elle takip) geçilebilir — şimdilik
  // yeterli ve daha basit.
  //
  // HATA DURUMU: giriş yapılmamışsa veya yükleme sırasında bir ağ/izin
  // hatası oluşursa GoogleDriveException fırlatılır. Arayüz katmanı
  // (Aşama 6.6) bunu yakalayıp kullanıcıya anlaşılır bir mesaj gösterir.
  Future<GoogleDriveBackupFile> uploadBackup(
    File localZipFile, {
    void Function(double progress, String step)? onProgress,
  }) async {
    onProgress?.call(0.05, 'Google hesabı doğrulanıyor...');
    final session = await getDriveApi();
    if (session == null) {
      throw GoogleDriveException(
        'Google Drive\'a bağlı değilsiniz. Lütfen önce Google hesabınızla '
        'giriş yapın.',
        type: GoogleDriveErrorType.notSignedIn,
        retryable: false,
      );
    }
    final driveApi = session.api;

    try {
      onProgress?.call(0.2, 'Yedek Drive\'a yükleniyor...');

      // NOT: Dosya artık STREAM olarak (localZipFile.openRead()) değil,
      // tamamı belleğe okunup (readAsBytes()) SABİT UZUNLUKLU bir byte
      // listesi olarak gönderiliyor. Stream tabanlı gönderimde googleapis
      // paketi isteği "Transfer-Encoding: chunked" ile atabiliyor; bazı
      // ev router'ları / ISS'ler / bazı Wifi ağlarındaki DNS-filtre veya
      // güvenlik katmanları chunked POST isteklerini (özellikle Drive'ın
      // upload.*.googleapis.com uç noktasına giden isteklerde) sessizce
      // askıda bırakabiliyor — GET istekleri (listeleme, sign-in) bundan
      // etkilenmez, sadece dosya yükleme etkilenir; tam olarak gördüğümüz
      // belirti buydu. Baytları önceden okuyup sabit Content-Length ile
      // göndermek bu sorunu ortadan kaldırır. Yedek dosyaları (özellikle
      // ek/attachment içermeyenler) küçük olduğu için tamamını belleğe
      // almak sorun yaratmaz.
      final bytes = await localZipFile.readAsBytes();
      debugPrint('[DRIVE DEBUG] Yüklenecek dosya boyutu: ${bytes.length} byte');
      final metadata = drive.File()
        ..name = p.basename(localZipFile.path)
        ..parents = ['appDataFolder'];

      final media = drive.Media(Stream.value(bytes), bytes.length);

      debugPrint('[DRIVE DEBUG] files.create() çağrılıyor...');
      final created = await driveApi.files
          .create(
            metadata,
            uploadMedia: media,
            $fields: 'id, name, size, modifiedTime',
          )
          .timeout(
            const Duration(seconds: 120),
            onTimeout: () {
              debugPrint('[DRIVE DEBUG] files.create() 120 saniyede CEVAP VERMEDİ (timeout)');
              throw GoogleDriveException(
                'Google Drive\'a yükleme 120 saniye içinde tamamlanamadı '
                '(sunucudan yanıt gelmedi). Lütfen bağlantınızı kontrol edip '
                'tekrar deneyin.',
                type: GoogleDriveErrorType.network,
                retryable: true,
              );
            },
          );

      debugPrint('[DRIVE DEBUG] files.create() BAŞARILI: id=${created.id}, name=${created.name}');
      onProgress?.call(1.0, 'Tamamlandı');
      return GoogleDriveBackupFile.fromDriveFile(created);
    } catch (e, stack) {
      debugPrint('[DRIVE DEBUG] uploadBackup HATASI: $e');
      debugPrint('[DRIVE DEBUG] Stack: $stack');
      throw GoogleDriveException.fromError(e);
    } finally {
      session.client.close();
    }
  }

  // ── DRIVE'DAKİ YEDEKLERİ LİSTELEME — AŞAMA 6.3 ──────────────────────
  //
  // appDataFolder (gizli alan) içindeki tüm dnote yedeklerini, en yeni en
  // üstte olacak şekilde döner. `spaces: 'appDataFolder'` parametresi
  // aramayı SADECE bu uygulamanın gizli alanıyla sınırlar — kullanıcının
  // normal Drive dosyaları hiçbir şekilde bu listeye karışmaz (zaten
  // drive.appdata scope'uyla erişim izni de yok).
  //
  // PERFORMANS NOTU (bkz. cihaz tarafındaki listBackups() — Aşama 5.1/5.3
  // ile aynı prensip): bu çağrı sadece metadata (id/ad/boyut/tarih) okur,
  // zip içeriğini indirmez; bu yüzden çok sayıda yedek olsa bile hızlıdır.
  //
  // SAYFALAMA (pagination): Drive API sonuçları büyük listelerde sayfalar
  // halinde döner (nextPageToken). appDataFolder'da genelde az sayıda
  // dosya birikeceği için (özellikle Aşama 6.5'teki otomatik temizlik
  // devreye girdiğinde) tek sayfa yeterli olur, ama doğruluk için
  // aşağıda tüm sayfalar dolaşılır.
  Future<List<GoogleDriveBackupFile>> listBackups() async {
    final session = await getDriveApi();
    if (session == null) {
      throw GoogleDriveException(
        'Google Drive\'a bağlı değilsiniz. Lütfen önce Google hesabınızla '
        'giriş yapın.',
        type: GoogleDriveErrorType.notSignedIn,
        retryable: false,
      );
    }
    final driveApi = session.api;

    try {
      final results = <GoogleDriveBackupFile>[];
      String? pageToken;
      do {
        final response = await driveApi.files.list(
          spaces: 'appDataFolder',
          q: 'trashed = false',
          $fields: 'nextPageToken, files(id, name, size, modifiedTime)',
          orderBy: 'modifiedTime desc',
          pageSize: 200,
          pageToken: pageToken,
        );
        final files = response.files ?? const <drive.File>[];
        results.addAll(files.map(GoogleDriveBackupFile.fromDriveFile));
        pageToken = response.nextPageToken;
      } while (pageToken != null);
      return results;
    } catch (e) {
      throw GoogleDriveException.fromError(e);
    } finally {
      session.client.close();
    }
  }

  // ── DRIVE'DAN İNDİRME — AŞAMA 6.4 ───────────────────────────────────
  //
  // Seçilen Drive yedeğini indirip CİHAZDAKİ yedek klasörüne
  // (BackupHelper.instance.backupsDir() — aynı "dnote_backups" klasörü)
  // normal bir .zip dosyası olarak kaydeder. Bilinçli bir tasarım kararı:
  // indirilen dosya AYRI bir geçici konuma değil, doğrudan cihazın kendi
  // yedek klasörüne yazılır. Bunun iki faydası vardır:
  //   1) İndirilen dosya otomatik olarak "Yedek Geçmişi" (cihaz listesi)
  //      ekranında da görünür — Aşama 6.7'de Drive sekmesi eklendiğinde
  //      aynı dosya iki yerde ayrı ayrı yönetilmek zorunda kalmaz.
  //   2) GERİ YÜKLEME İÇİN EK KOD GEREKMEZ: bu fonksiyon geriye normal bir
  //      `File` döndürür. Bu dosya, BackupRestoreScreen'deki MEVCUT
  //      _restoreFromFile(File) akışına (Aşama 4'te tamamlanan önizleme/
  //      onay/geri yükleme mantığı — bkz. backup_restore_screen.dart)
  //      DOĞRUDAN verilebilir. Yani "Drive'dan geri yükleme" için ayrı bir
  //      restore mantığı yazılmaz; sadece dosyanın KAYNAĞI değişir
  //      (dosya seçici / cihaz geçmişi / Drive — üçü de aynı File'ı üretir
  //      ve aynı tek akıştan geçer). Bu, projenin baştan beri izlediği
  //      "kod tekrarı yok" prensibiyle birebir uyumludur.
  //
  // İSİM ÇAKIŞMASI: Drive'daki dosya adları zaten `dnote_yedek_<zaman
  // damgası>.zip` biçiminde ve saniye hassasiyetinde üretildiği için
  // (bkz. BackupHelper._timestampForFileName) pratikte çakışma yaşanmaz.
  // Yine de aynı adda bir dosya cihazda zaten varsa (örn. dosya daha önce
  // buradan yedeklenip Drive'a yüklenmişse), üzerine güvenle yazılır —
  // zaten içerik birebir aynı yedeğin kopyasıdır.
  //
  // GERÇEK YÜZDE İLERLEMESİ: Upload'ın aksine (bkz. 6.2'deki not), indirme
  // tarafında Drive dosyanın toplam boyutunu (driveFile.sizeBytes) zaten
  // metadata'dan bildiğimiz için, indirilen bayt sayısını toplam boyuta
  // bölerek GERÇEK bir yüzde ilerlemesi hesaplanabiliyor.
  Future<File> downloadBackup(
    GoogleDriveBackupFile driveFile, {
    void Function(double progress, String step)? onProgress,
  }) async {
    onProgress?.call(0.05, 'Google hesabı doğrulanıyor...');
    final session = await getDriveApi();
    if (session == null) {
      throw GoogleDriveException(
        'Google Drive\'a bağlı değilsiniz. Lütfen önce Google hesabınızla '
        'giriş yapın.',
        type: GoogleDriveErrorType.notSignedIn,
        retryable: false,
      );
    }
    final driveApi = session.api;

    try {
      onProgress?.call(0.1, 'Yedek Drive\'dan indiriliyor...');
      final media = await driveApi.files.get(
        driveFile.id,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final totalBytes = driveFile.sizeBytes > 0
          ? driveFile.sizeBytes
          : (media.length ?? 0);
      final buffer = <int>[];
      var downloaded = 0;
      await for (final chunk in media.stream) {
        buffer.addAll(chunk);
        downloaded += chunk.length;
        if (totalBytes > 0) {
          // İndirme adımına 0.1–0.9 arası bir aralık ayrılır; başındaki
          // %10 doğrulama, sonundaki %10 diske yazma için bırakılır.
          onProgress?.call(
            0.1 + 0.8 * (downloaded / totalBytes).clamp(0.0, 1.0),
            'Yedek Drive\'dan indiriliyor... '
            '(${BackupHelper.instance.formatFileSize(downloaded)} / '
            '${BackupHelper.instance.formatFileSize(totalBytes)})',
          );
        }
      }

      onProgress?.call(0.95, 'Dosya cihaza kaydediliyor...');
      final localDir = await BackupHelper.instance.backupsDir();
      final localFile = File(p.join(localDir.path, driveFile.name));
      await localFile.writeAsBytes(buffer, flush: true);

      onProgress?.call(1.0, 'Tamamlandı');
      return localFile;
    } catch (e) {
      throw GoogleDriveException.fromError(e);
    } finally {
      session.client.close();
    }
  }

  // ── DRIVE'DAN SİLME — AŞAMA 6.5 ──────────────────────────────────────
  //
  // Belirtilen Drive dosyasını (kimliğiyle) kalıcı olarak siler. Cihaz
  // tarafındaki BackupHelper.deleteBackupFile() ile aynı işlevi görür,
  // sadece hedef Drive'ın gizli appDataFolder alanıdır.
  //
  // NOT: files.delete() zaten "çöp kutusuna taşı" değil, DOĞRUDAN kalıcı
  // silme yapar (appDataFolder içindeki dosyalar zaten kullanıcının
  // normal Drive çöp kutusunda da görünmez). Bu yüzden cihaz tarafındaki
  // silme onay diyaloğuyla (Aşama 5.1) aynı ciddiyette ele alınmalıdır —
  // arayüz katmanı (Aşama 6.7) burada da bir onay diyaloğu göstermelidir.
  Future<void> deleteBackup(String fileId) async {
    final session = await getDriveApi();
    if (session == null) {
      throw GoogleDriveException(
        'Google Drive\'a bağlı değilsiniz. Lütfen önce Google hesabınızla '
        'giriş yapın.',
        type: GoogleDriveErrorType.notSignedIn,
        retryable: false,
      );
    }
    try {
      await session.api.files.delete(fileId);
    } catch (e) {
      throw GoogleDriveException.fromError(e);
    } finally {
      session.client.close();
    }
  }

  // ── OTOMATİK TEMİZLİK (RETENTION) — AŞAMA 6.5 ───────────────────────
  //
  // Drive'da (appDataFolder'da) sınırsız yedek birikmesini önlemek için
  // kullanılır. En yeni `maxBackupsToKeep` kadar yedek TUTULUR, geri
  // kalan (daha eski) tüm yedekler kalıcı olarak silinir.
  //
  // NE ZAMAN ÇAĞRILIR: Bu fonksiyon kendi kendine periyodik çalışmaz —
  // her başarılı Drive yüklemesinden SONRA çağrılması beklenir. Aşama
  // 6.6'da "Google Drive'a Yedekle" akışı, 6.8'de ise otomatik arka plan
  // yedeklemesi bu fonksiyonu uploadBackup()'tan hemen sonra çağıracaktır.
  // Böylece kullanıcı hiçbir şey yapmadan Drive'daki yedek sayısı kontrol
  // altında kalır (örn. günlük otomatik yedeklemede Drive'da sonsuza
  // kadar dosya birikip kullanıcının kotasını yavaşça tüketmesi önlenir).
  //
  // GÜVENLİ TASARIM: Silme işlemlerinden biri başarısız olursa (örn. o
  // sırada ağ kesilirse) işlem durdurulmaz; diğer eski yedekler silinmeye
  // devam edilir ve en sonda toplam kaç yedeğin silindiği/silinemediği
  // bilgisi RetentionResult ile döndürülür. Böylece geçici bir hata,
  // tüm temizlik işlemini iptal etmez.
  static const int defaultMaxDriveBackupsToKeep = 10;

  Future<RetentionResult> enforceRetention({
    int maxBackupsToKeep = defaultMaxDriveBackupsToKeep,
  }) async {
    final all = await listBackups(); // zaten en yeni en üstte sıralı
    if (all.length <= maxBackupsToKeep) {
      return RetentionResult(deletedCount: 0, failedCount: 0);
    }

    final toDelete = all.sublist(maxBackupsToKeep);
    var deleted = 0;
    var failed = 0;
    for (final backup in toDelete) {
      try {
        await deleteBackup(backup.id);
        deleted++;
      } catch (_) {
        // Tek bir dosyanın silinememesi tüm temizliği durdurmaz; bir
        // sonraki senkronizasyonda tekrar denenecektir (yedek Drive'da
        // kalmaya devam ettiği için listBackups() onu bir dahaki sefere
        // yine görecek ve tekrar silmeyi deneyecektir).
        failed++;
      }
    }
    return RetentionResult(deletedCount: deleted, failedCount: failed);
  }
}

// enforceRetention() sonucunu taşıyan basit veri sınıfı. Arayüz katmanı
// (örn. Aşama 6.9'daki otomatik yedekleme ayarları veya 6.6'daki manuel
// "Drive'a Yedekle" akışı) isterse kullanıcıya "3 eski yedek temizlendi"
// gibi bilgilendirici bir mesaj göstermek için kullanabilir; zorunlu
// değildir.
class RetentionResult {
  final int deletedCount;
  final int failedCount;

  RetentionResult({required this.deletedCount, required this.failedCount});
}

// ── DRIVE YEDEK METADATA MODELİ — AŞAMA 6.2 ─────────────────────────────
// Drive'daki bir yedek dosyasının hafif metadata temsili. Zip içeriğini
// TAŞIMAZ — sadece listeleme (6.3), geri yükleme için indirme (6.4) ve
// silme (6.5) işlemlerinde kullanılacak kimlik/ad/boyut/tarih bilgisini
// tutar. Cihazdaki File nesnesinin Drive karşılığı gibi düşünülebilir.
class GoogleDriveBackupFile {
  final String id;
  final String name;
  final int sizeBytes;
  final DateTime? modifiedTime;

  GoogleDriveBackupFile({
    required this.id,
    required this.name,
    required this.sizeBytes,
    required this.modifiedTime,
  });

  factory GoogleDriveBackupFile.fromDriveFile(drive.File f) {
    return GoogleDriveBackupFile(
      id: f.id ?? '',
      name: f.name ?? 'bilinmeyen_yedek.zip',
      sizeBytes: int.tryParse(f.size ?? '') ?? 0,
      modifiedTime: f.modifiedTime,
    );
  }
}

// ── HATA SINIFLANDIRMASI — AŞAMA 6.2 (temel) ────────────────────────────
// BackupErrorType / BackupOperationException'daki mantığın Drive
// tarafındaki karşılığı. Bu aşamada temel kategoriler tanımlanır; Aşama
// 6.10'da (token süresi dolmuş, kota aşıldı, ağ yok gibi) daha ayrıntılı
// sınıflandırma ve arayüz entegrasyonu eklenecektir.
enum GoogleDriveErrorType {
  notSignedIn, // Google hesabıyla giriş yapılmamış
  network, // İnternet bağlantısı yok / zaman aşımı
  quotaExceeded, // Drive depolama kotası dolu
  notFound, // Belirtilen Drive dosyası bulunamadı
  unknown, // Sınıflandırılamayan diğer hatalar
}

class GoogleDriveException implements Exception {
  final String message;
  final GoogleDriveErrorType type;
  final bool retryable;

  GoogleDriveException(
    this.message, {
    this.type = GoogleDriveErrorType.unknown,
    this.retryable = true,
  });

  @override
  String toString() => message;

  factory GoogleDriveException.fromError(Object error) {
    if (error is GoogleDriveException) return error;
    final text = error.toString().toLowerCase();
    if (text.contains('storagequotaexceeded') || text.contains('quota')) {
      return GoogleDriveException(
        'Google Drive depolama alanınız dolu. Lütfen Drive\'da yer açıp '
        'tekrar deneyin.',
        type: GoogleDriveErrorType.quotaExceeded,
        retryable: false,
      );
    }
    if (text.contains('socketexception') ||
        text.contains('failed host lookup') ||
        text.contains('network')) {
      return GoogleDriveException(
        'İnternet bağlantısı sağlanamadı. Lütfen bağlantınızı kontrol edip '
        'tekrar deneyin.',
        type: GoogleDriveErrorType.network,
        retryable: true,
      );
    }
    if (text.contains('404') || text.contains('not found')) {
      return GoogleDriveException(
        'Belirtilen yedek dosyası Drive\'da bulunamadı. Silinmiş olabilir.',
        type: GoogleDriveErrorType.notFound,
        retryable: false,
      );
    }
    return GoogleDriveException(
      'Google Drive işlemi sırasında beklenmeyen bir hata oluştu: $error',
      type: GoogleDriveErrorType.unknown,
      retryable: true,
    );
  }
}
