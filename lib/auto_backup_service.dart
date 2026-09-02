part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// ARKA PLAN OTOMATİK YEDEKLEME SERVİSİ — AŞAMA 8
// (Aşama 7'deki eski servisin yerine geçer; API'si AutoBackupSettingsScreen
// ile birebir uyumludur.)
//
// NE DEĞİŞTİ (Aşama 7 → Aşama 8)?
//   • Eski servis SADECE uygulama açıldığında (triggerPeriodicTasks() init()
//     içinden) çalışıyordu — yani uygulama günlerce açılmazsa yedek de
//     alınmıyordu. Bu, gerçek bir "arka plan" servisi değildi.
//   • Bu sürüm, workmanager paketiyle işletim sistemi seviyesinde
//     PERİYODİK bir görev kaydeder. Android bu görevi uygulama kapalıyken
//     bile (sistem kısıtlamaları/Doze modu dahilinde) tetikler.
//   • AutoBackupTarget (local/drive/both) eklendi — hedefe göre yerel
//     ve/veya Drive yedeklemesi tetiklenir.
//   • Ayarlar ekranının beklediği tam API sağlanır: isEnabled/getTarget/
//     setTarget/getFrequencyHours/getWifiOnly/getLastRunAt/getLastStatus/
//     getLastMessage/rescheduleFromSavedSettings.
//
// GEREKLİ EK BAĞIMLILIK (pubspec.yaml):
//   workmanager: ^0.6.0
//
// main.dart İÇİNDE YAPILMASI GEREKENLER (main()'in en başında, runApp'ten
// önce, bu sırayla):
//   1) WidgetsFlutterBinding.ensureInitialized();
//   2) await AutoBackupService.instance.initializeWorkmanager();
//   3) await AutoBackupService.instance.rescheduleFromSavedSettings();
// (initializeWorkmanager() mutlaka rescheduleFromSavedSettings()'ten ÖNCE
// çağrılmalıdır — aksi halde Workmanager plugin channel'ı hazır olmadan
// registerPeriodicTask/cancelByUniqueName çağrılmış olur ve runtime hatası
// alınır.)
//
// ANDROID: android/app/src/main/AndroidManifest.xml içinde ek bir izin
// GEREKMEZ (workmanager kendi gerekli servis/receiver kayıtlarını kendi
// manifest'inden merge eder). Sadece minSdkVersion >= 21 olmalı.
//
// ÖNEMLİ — ARKA PLAN İZOLASYONU: callbackDispatcher() içindeki kod AYRI
// bir Flutter engine/isolate'te çalışır; bu isolate'te UI, mevcut
// widget state'i veya "part of main.dart" dışındaki hiçbir global state
// YOKTUR. Bu yüzden _runBackupTask() içinde sadece DBHelper, BackupHelper
// ve GoogleDriveHelper gibi kendi kendine yeten (self-contained) sınıflar
// kullanılır — bunların hepsi zaten singleton ve bağımsız çalışacak
// şekilde tasarlanmıştı.
// ════════════════════════════════════════════════════════════════════════

enum AutoBackupTarget { local, drive, both }

const String _autoBackupTaskName = 'dnote_auto_backup_task';
const String _autoBackupTaskUniqueName = 'dnote_auto_backup_unique';

// WorkManager'ın arka plan isolate'inde ilk açtığı, TÜM periyodik
// görevler için tek giriş noktası. Üst seviyede (top-level) ve
// @pragma('vm:entry-point') ile işaretli olmak ZORUNDADIR — aksi halde
// release modunda tree-shaking bu fonksiyonu silebilir ve görev sessizce
// hiç çalışmaz.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == _autoBackupTaskName) {
      try {
        await AutoBackupService.instance._runBackupTask();
        return Future.value(true);
      } catch (e) {
        debugPrint('Arka plan otomatik yedekleme görevi hata verdi: $e');
        // false dönmek WorkManager'a görevin başarısız olduğunu ve
        // (constraints uygunsa) yeniden denenmesi gerektiğini bildirir.
        return Future.value(false);
      }
    }
    return Future.value(true);
  });
}

class AutoBackupService {
  AutoBackupService._internal();
  static final AutoBackupService instance = AutoBackupService._internal();

  // ── Ayar Anahtarları ────────────────────────────────────────────────
  static const String _enabledKey = 'auto_backup_enabled';
  static const String _targetKey = 'auto_backup_target';
  static const String _frequencyHoursKey = 'auto_backup_frequency_hours';
  static const String _wifiOnlyKey = 'auto_backup_wifi_only';
  static const String _maxLocalBackupsKey = 'auto_backup_max_local_count';

  // ── Son Çalışma Durumu Anahtarları ─────────────────────────────────
  static const String _lastRunAtKey = 'auto_backup_last_run_at';
  static const String _lastStatusKey = 'auto_backup_last_status'; // 'success' | 'error'
  static const String _lastMessageKey = 'auto_backup_last_message';

  // ── Ayarlar: okuma ──────────────────────────────────────────────────

  Future<bool> isEnabled() async {
    final settings = await DBHelper.instance.getAllSettings();
    return (settings[_enabledKey] ?? 'false') == 'true';
  }

  Future<AutoBackupTarget> getTarget() async {
    final settings = await DBHelper.instance.getAllSettings();
    final raw = settings[_targetKey] ?? 'local';
    return AutoBackupTarget.values.firstWhere(
      (t) => t.name == raw,
      orElse: () => AutoBackupTarget.local,
    );
  }

  Future<int> getFrequencyHours() async {
    final settings = await DBHelper.instance.getAllSettings();
    return int.tryParse(settings[_frequencyHoursKey] ?? '24') ?? 24;
  }

  Future<bool> getWifiOnly() async {
    final settings = await DBHelper.instance.getAllSettings();
    return (settings[_wifiOnlyKey] ?? 'true') == 'true';
  }

  Future<int> getMaxLocalBackups() async {
    final settings = await DBHelper.instance.getAllSettings();
    return int.tryParse(settings[_maxLocalBackupsKey] ?? '5') ?? 5;
  }

  Future<DateTime?> getLastRunAt() async {
    final settings = await DBHelper.instance.getAllSettings();
    final raw = settings[_lastRunAtKey];
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  Future<String?> getLastStatus() async {
    final settings = await DBHelper.instance.getAllSettings();
    return settings[_lastStatusKey];
  }

  Future<String?> getLastMessage() async {
    final settings = await DBHelper.instance.getAllSettings();
    return settings[_lastMessageKey];
  }

  // ── Ayarlar: yazma ──────────────────────────────────────────────────
  // Not: Bu setter'lar SADECE ayarı diske yazar; WorkManager görevini
  // yeniden PLANLAMAZ. Ayarlar ekranı her değişiklikten sonra ayrıca
  // rescheduleFromSavedSettings() çağırır (bkz. _saveAndReschedule).

  Future<void> setEnabled(bool value) async {
    await DBHelper.instance.setSetting(_enabledKey, value ? 'true' : 'false');
  }

  Future<void> setTarget(AutoBackupTarget target) async {
    await DBHelper.instance.setSetting(_targetKey, target.name);
  }

  Future<void> setFrequencyHours(int hours) async {
    await DBHelper.instance.setSetting(_frequencyHoursKey, hours.toString());
  }

  Future<void> setWifiOnly(bool value) async {
    await DBHelper.instance.setSetting(_wifiOnlyKey, value ? 'true' : 'false');
  }

  Future<void> setMaxLocalBackups(int count) async {
    await DBHelper.instance.setSetting(_maxLocalBackupsKey, count.toString());
  }

  // ── Arka Plan İçin Dil Çözümleme (Aşama 7 → manuel dil seçici) ───────
  //
  // _runBackupTask() BuildContext OLMAYAN ayrı bir isolate'te çalıştığı
  // için AppLocalizations.of(context) burada kullanılamaz. Bunun yerine
  // AppLocalizations.delegate.load(locale) ile context'siz bir örnek
  // üretilir. Locale kaynağı artık cihaz dili DEĞİL, kullanıcının Ayarlar
  // ekranında elle seçtiği 'app_language' ayarıdır (DBHelper.setSetting
  // ile theme_mode/accent_color ile aynı depoda tutulur) — böylece ön
  // planda (settings_page.dart) ve arka planda (burada) aynı kaynak
  // kullanılır ve dil tutarsızlığı ihtimali kalmaz.
  // 'tr'/'en' ise doğrudan o dil kullanılır; ayar yoksa veya 'system' ise
  // (henüz seçim yapılmamış / kullanıcı sistem dilini takip etmeyi
  // seçmiş) cihaz dili kontrol edilir, desteklenmiyorsa Türkçe'ye düşülür.
  Future<AppLocalizations> _resolveL10n() async {
    final settings = await DBHelper.instance.getAllSettings();
    final lang = settings['app_language'] ?? 'system';

    late final Locale locale;
    if (lang == 'tr' || lang == 'en') {
      locale = Locale(lang);
    } else {
      final deviceLocale = ui.PlatformDispatcher.instance.locale;
      locale = AppLocalizations.delegate.isSupported(deviceLocale)
          ? deviceLocale
          : const Locale('tr');
    }
    return AppLocalizations.delegate.load(locale);
  }

  Future<void> _saveLastRun({required bool success, required String message}) async {
    await DBHelper.instance.setSetting(_lastRunAtKey, DateTime.now().toIso8601String());
    await DBHelper.instance.setSetting(_lastStatusKey, success ? 'success' : 'error');
    await DBHelper.instance.setSetting(_lastMessageKey, message);
  }

  // ── WorkManager Başlatma ──────────────────────────────────────────────
  //
  // main()'de, runApp'ten önce ve rescheduleFromSavedSettings()'ten ÖNCE
  // bir kez çağrılmalıdır. Workmanager().initialize() çağrılmadan
  // registerPeriodicTask/cancelByUniqueName kullanmak runtime hatası verir.
  // isInDebugMode true iken workmanager, çalıştırdığı her görev için bir
  // bildirim gösterir ve daha ayrıntılı log basar — bu sayede geliştirme
  // sırasında görevin gerçekten tetiklenip tetiklenmediği kolayca görülür;
  // release modunda otomatik olarak kapanır.
  Future<void> initializeWorkmanager() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
  }

  // ── WorkManager Planlama ─────────────────────────────────────────────
  //
  // Ayarlara göre periyodik görevi (yeniden) kaydeder. isEnabled() false
  // ise sadece iptal eder ve çıkar.
  //
  // [resetIfExists] — AŞAMA 8.1 DÜZELTMESİ:
  // Önceden bu metot HER çağrıldığında önce cancelByUniqueName() ile
  // mevcut görevi iptal edip ExistingWorkPolicy.replace ile sıfırdan
  // kaydediyordu. main.dart -> _initBackgroundServices() bu metodu HER
  // UYGULAMA AÇILIŞINDA (OEM'lerin görevi sessizce silebilmesine karşı
  // bir güvenlik önlemi olarak) çağırdığı için, kullanıcı uygulamayı
  // günde bir kez bile açsa periyodik görevin dahili geri sayımı her
  // seferinde sıfırlanıyor ve süre hiçbir zaman dolmadığı için otomatik
  // yedekleme fiilen HİÇ TETİKLENMİYORDU.
  //
  // Bu yüzden artık iki farklı kullanım var:
  //   • resetIfExists: true  (varsayılan, ayarlar ekranından kullanıcı
  //     bir ayarı GERÇEKTEN değiştirdiğinde çağrılır) → cancel + replace
  //     ile görev sıfırdan kurulur; yeni sıklık/hedef/wifi ayarı hemen
  //     uygulanır. Kullanıcı bilinçli bir değişiklik yaptığı için geri
  //     sayımın sıfırlanması burada beklenen ve doğru davranıştır.
  //   • resetIfExists: false (main.dart -> _initBackgroundServices()'ten
  //     her açılışta çağrılır) → ExistingWorkPolicy.keep kullanılır: görev
  //     zaten kayıtlıysa dokunulmaz (geri sayım korunur), sadece bir OEM
  //     tarafından silinmişse yeniden oluşturulur. Böylece hem "OEM görevi
  //     sildi" senaryosuna karşı korunmuş oluruz hem de normal açılışlarda
  //     sayaç sıfırlanmaz.
  Future<void> rescheduleFromSavedSettings({bool resetIfExists = true}) async {
    final enabled = await isEnabled();
    if (!enabled) {
      await Workmanager().cancelByUniqueName(_autoBackupTaskUniqueName);
      return;
    }

    if (resetIfExists) {
      await Workmanager().cancelByUniqueName(_autoBackupTaskUniqueName);
    }

    final frequencyHours = await getFrequencyHours();
    final wifiOnly = await getWifiOnly();
    final target = await getTarget();

    // WorkManager'ın minimum periyodik aralığı Android kısıtlaması gereği
    // 15 dakikadır. Ayarlar ekranındaki seçenekler zaten 6 saat ve üzerinde
    // olduğu için bir clamp'e gerek yoktur.
    final frequency = Duration(hours: frequencyHours);

    await Workmanager().registerPeriodicTask(
      _autoBackupTaskUniqueName,
      _autoBackupTaskName,
      frequency: frequency,
      constraints: Constraints(
        // Hedef sadece 'local' ise ağ şartı aranmaz; drive/both ise
        // wifiOnly ayarına göre ağ kısıtlaması uygulanır.
        networkType: target == AutoBackupTarget.local
            ? NetworkType.not_required
            : (wifiOnly ? NetworkType.unmetered : NetworkType.connected),
      ),
      // resetIfExists=false iken 'keep' kullanılır ki her açılışta görev
      // sıfırlanıp geri sayım baştan başlamasın (bkz. yukarıdaki not).
      existingWorkPolicy:
          resetIfExists ? ExistingWorkPolicy.replace : ExistingWorkPolicy.keep,
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(minutes: 15),
    );
  }

  // ── AŞAMA 9: Ön Planda "Yakalama" (Catch-up) Mantığı ─────────────────
  //
  // NEDEN GEREKLİ: Bazı OEM'lerin (Samsung, Xiaomi, Huawei) agresif pil
  // yönetimi, WorkManager görevini ekran kapalıyken başlatıp yarıda
  // dondurabiliyor veya hiç çalıştırmayabiliyor. Kullanıcı bu ayarları
  // kendi başına asla bulup açmayacağı için, arka plan görevine %100
  // güvenemeyiz. Bu metot bir GÜVENCE KATMANIDIR — arka planın YERİNE
  // geçmez, sadece arka plan çalışmadığında devreye girer.
  //
  // main.dart -> _initBackgroundServices() içinde, rescheduleFromSavedSettings()
  // çağrısından SONRA, uygulama her açıldığında çağrılmalıdır:
  //
  //   await AutoBackupService.instance.checkAndRunIfDue();
  //
  // Mantık: otomatik yedekleme açık mı, ve son yedekten bu yana ayarlanan
  // sıklık (frequencyHours) kadar süre geçmiş mi diye bakar. Geçmişse,
  // yedeklemeyi ÖN PLANDA (uygulama açıkken, herhangi bir arka plan/Doze
  // kısıtlaması olmadan) hemen çalıştırır. Geçmemişse hiçbir şey yapmaz —
  // yani arka plan zaten görevini yapmışsa bu metot devreye bile girmez.
  Future<void> checkAndRunIfDue() async {
    if (!await isEnabled()) return;

    final lastRun = await getLastRunAt();
    final frequencyHours = await getFrequencyHours();
    final dueInterval = Duration(hours: frequencyHours);

    final isOverdue =
        lastRun == null || DateTime.now().difference(lastRun) >= dueInterval;
    if (!isOverdue) return;

    try {
      await _runBackupTask();
    } catch (_) {
      // _runBackupTask zaten _saveLastRun() içinde hata durumunu da
      // kaydediyor (bkz. aşağısı); burada sessizce yutuyoruz ki
      // uygulama açılışı bir yedekleme hatası yüzünden kesintiye
      // uğramasın. Kullanıcı zaten Ayarlar ekranındaki durum kartından
      // hatayı görebilir.
    }
  }

  // ── Görev Mantığı (arka plan isolate'inde çalışır VEYA ön planda
  // checkAndRunIfDue() üzerinden manuel tetiklenir) ────────────────────
  //
  // callbackDispatcher() tarafından çağrılır. Uygulama açıkken manuel
  // test etmek isterseniz de doğrudan çağrılabilir (ayarlar ekranına
  // "Şimdi Yedekle" gibi bir test butonu eklemek isterseniz kullanışlı).
  Future<void> _runBackupTask() async {
    // 1. Çöp kutusu temizliği (Aşama 7.1 ile aynı davranış korunur).
    try {
      await DBHelper.instance.autoCleanOldDeletedNotes();
    } catch (_) {
      // Çöp kutusu temizliği başarısız olsa da yedeklemeyi engellemesin.
    }

    // 1.1 Ana ekran widget'ını tazele (bkz. note_widget_service.dart).
    // Normalde her not kaydında zaten senkronize olur (db_helper.dart ->
    // replaceNotes), ama bu adım ek bir güvenlik ağı sağlar: uygulama
    // günlerce hiç açılmasa bile widget güncel kalır ve widget yakın
    // zamanda eklenip de ilk senkronizasyonu kaçırmışsa (ör. o an bir
    // önceki senkronizasyon sürüyorken eklendiyse) burada kendiliğinden
    // onarılır (self-healing). Bu periyodik görev yalnızca otomatik
    // yedekleme AÇIKKEN (isEnabled() true) çalıştığı için, widget
    // yenilemesinin bu ek güvenlik ağı da yalnızca o durumda işler; not
    // kaydedildiğinde çalışan asıl senkronizasyon (db_helper.dart) her
    // koşulda zaten çalışmaya devam eder.
    try {
      final notes = await DBHelper.instance.getNotes();
      await NoteWidgetService.instance.syncFromNotes(notes);
    } catch (_) {
      // Widget güncellemesi başarısız olsa da yedekleme görevini
      // engellemesin.
    }

    final target = await getTarget();
    final maxLocalBackups = await getMaxLocalBackups();
    final l10n = await _resolveL10n();

    final messages = <String>[];
    var anySuccess = false;

    // 2. Yerel yedekleme (target: local veya both)
    if (target == AutoBackupTarget.local || target == AutoBackupTarget.both) {
      try {
        await BackupHelper.instance.createBackup(l10n: l10n);
        await BackupHelper.enforceLocalRetention(maxLocalBackups);
        messages.add(l10n.autoBackupLocalSuccessMessage);
        anySuccess = true;
      } catch (e) {
        messages.add(l10n.autoBackupLocalFailedMessage(e.toString()));
      }
    }

    // 3. Google Drive yedekleme (target: drive veya both)
    if (target == AutoBackupTarget.drive || target == AutoBackupTarget.both) {
      final swDriveBlock = Stopwatch()..start();
      try {
        // Arka plan isolate'inde kullanıcı etkileşimli signIn() ÇAĞRILAMAZ
        // (hiçbir diyalog gösterilemez); sadece daha önce verilmiş bir
        // oturumun sessizce (token yenileyerek) devam ettirilmesi denenir.
        final signedIn = await GoogleDriveHelper.instance.trySilentSignIn();
        if (!signedIn) {
          messages.add(l10n.autoBackupDriveSkippedNotConnectedMessage);
        } else {
          // PERFORMANS: Bu adımda yapılacak tüm Drive işlemleri (yükleme +
          // eski yedekleri temizleme) için TEK bir DriveSession açılır ve
          // en sonda (finally'de) tek seferde kapatılır. Önceden
          // uploadBackup()/enforceRetention() her biri kendi içinde
          // sıfırdan authenticatedClient() çağırıyordu (+ enforceRetention
          // içindeki her deleteBackup() de ayrıca); bu, tek bir yedekleme
          // döngüsünde 3+ kez tam kimlik doğrulama + yeni bağlantı kurma
          // anlamına geliyordu ve zayıf/yüksek gecikmeli ağlarda gözle
          // görülür bir yavaşlığın (onlarca saniye) asıl sebebiydi. Session
          // artık tüm alt çağrılara paylaşılarak sadece bir kez açılıyor.
          final session = await GoogleDriveHelper.instance.getDriveApi();
          if (session == null) {
            messages.add(l10n.autoBackupDriveSkippedNotConnectedMessage);
          } else {
            try {
              // Drive'a yüklenecek zip'i önce yerel olarak üretmemiz gerekir
              // (target sadece 'drive' ise 2. adımda hiç oluşturulmamış
              // olabilir).
              File zipFile;
              // Hedef sadece 'drive' iken oluşturulan bu zip, Drive'a
              // yüklendikten sonra cihazda TUTULMAMASI gereken, sadece
              // yükleme için üretilmiş geçici bir dosyadır (bkz. aşağıdaki
              // "temiz çözüm" notu). 'both' hedefinde ise zaten 2. adımda
              // kasıtlı olarak kalıcı bir yerel yedek isteniyor, o yüzden
              // silinmez.
              final isDriveOnly = target == AutoBackupTarget.drive;
              if (target == AutoBackupTarget.both) {
                // 2. adımda zaten oluşturuldu; en yeni yerel yedeği kullan.
                final backups = await BackupHelper.instance.listBackups();
                zipFile = backups.first;
              } else {
                zipFile = await BackupHelper.instance.createBackup(l10n: l10n);
              }
              try {
                await GoogleDriveHelper.instance.uploadBackup(zipFile, session: session, l10n: l10n);
                await GoogleDriveHelper.instance.enforceRetention(session: session, l10n: l10n);
                messages.add(l10n.autoBackupDriveSuccessMessage);
                anySuccess = true;
              } catch (e) {
                rethrow;
              } finally {
                // Hedef sadece 'drive' ise, bu zip Drive'a yükleme için
                // üretilmiş geçici bir dosyadır — kullanıcı yerel kopya hiç
                // istemedi. Yükleme BAŞARILI da olsa BAŞARISIZ da olsa
                // cihazda tutulmaz: başarısız denemede yerelde "fallback"
                // bırakmak, art arda başarısız denemelerde gereksiz
                // dosya birikimine yol açardı; bunun yerine hiç iz
                // bırakılmaması tercih edildi.
                if (isDriveOnly) {
                  await BackupHelper.instance.deleteBackupFile(zipFile);
                }
              }
            } finally {
              session.client.close();
            }
          }
        }
      } catch (e) {
        // AŞAMA 8.2 DÜZELTMESİ: l10n burada AÇIKÇA geçilmezse
        // GoogleDriveException.fromError() context tabanlı _driveL10n'e
        // düşer (navigatorKey.currentContext), bu isolate'te her zaman
        // null'dır ve ASIL hatayı gizleyen bir çökmeye yol açar — böylece
        // _saveLastRun() hiç çağrılamaz (bkz. google_drive_helper.dart).
        final ex = GoogleDriveException.fromError(e, l10n: l10n);
        messages.add(l10n.autoBackupDriveFailedMessage(ex.message));
      }
      debugPrint('[DRIVE TIMING] Drive bloğu (adım 3) TOPLAM: ${swDriveBlock.elapsedMilliseconds}ms');
    }

    await _saveLastRun(success: anySuccess, message: messages.join(' '));

    if (!anySuccess) {
      throw Exception(messages.join(' '));
    }
  }
}
