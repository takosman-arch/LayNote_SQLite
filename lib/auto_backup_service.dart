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
  // Mevcut kaydı iptal edip (varsa) ayarlara göre yeniden kaydeder.
  // isEnabled() false ise sadece iptal eder ve çıkar. Ayarlar ekranındaki
  // HER değişiklikten sonra (switch, hedef, sıklık, wifi-only) çağrılır —
  // bu yüzden idempotent olacak şekilde her seferinde önce cancel edilir.
  Future<void> rescheduleFromSavedSettings() async {
    await Workmanager().cancelByUniqueName(_autoBackupTaskUniqueName);

    final enabled = await isEnabled();
    if (!enabled) return;

    final frequencyHours = await getFrequencyHours();
    final wifiOnly = await getWifiOnly();
    final target = await getTarget();

    // WorkManager'ın minimum periyodik aralığı Android kısıtlaması
    // gereği 15 dakikadır; ayarlar ekranındaki en düşük seçenek zaten
    // 6 saat olduğu için burada ek bir clamp'e gerek yok.
    await Workmanager().registerPeriodicTask(
      _autoBackupTaskUniqueName,
      _autoBackupTaskName,
      frequency: Duration(hours: frequencyHours),
      constraints: Constraints(
        // Hedef sadece 'local' ise ağ şartı aranmaz; drive/both ise
        // wifiOnly ayarına göre ağ kısıtlaması uygulanır.
        networkType: target == AutoBackupTarget.local
            ? NetworkType.not_required
            : (wifiOnly ? NetworkType.unmetered : NetworkType.connected),
      ),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(minutes: 15),
    );
  }

  // ── Görev Mantığı (arka plan isolate'inde çalışır) ───────────────────
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

    final target = await getTarget();
    final maxLocalBackups = await getMaxLocalBackups();

    final messages = <String>[];
    var anySuccess = false;

    // 2. Yerel yedekleme (target: local veya both)
    if (target == AutoBackupTarget.local || target == AutoBackupTarget.both) {
      try {
        await BackupHelper.instance.createBackup();
        await BackupHelper.enforceLocalRetention(maxLocalBackups);
        messages.add('Yerel yedekleme başarılı.');
        anySuccess = true;
      } catch (e) {
        messages.add('Yerel yedekleme başarısız: $e');
      }
    }

    // 3. Google Drive yedekleme (target: drive veya both)
    if (target == AutoBackupTarget.drive || target == AutoBackupTarget.both) {
      try {
        // Arka plan isolate'inde kullanıcı etkileşimli signIn() ÇAĞRILAMAZ
        // (hiçbir diyalog gösterilemez); sadece daha önce verilmiş bir
        // oturumun sessizce (token yenileyerek) devam ettirilmesi denenir.
        final signedIn = await GoogleDriveHelper.instance.trySilentSignIn();
        if (!signedIn) {
          messages.add(
            'Drive yedeklemesi atlandı: Google hesabı bağlı değil veya '
            'oturum süresi dolmuş. Lütfen uygulamayı açıp tekrar bağlanın.',
          );
        } else {
          // Drive'a yüklenecek zip'i önce yerel olarak üretmemiz gerekir
          // (target sadece 'drive' ise 2. adımda hiç oluşturulmamış
          // olabilir).
          File zipFile;
          if (target == AutoBackupTarget.both) {
            // 2. adımda zaten oluşturuldu; en yeni yerel yedeği kullan.
            final backups = await BackupHelper.instance.listBackups();
            zipFile = backups.first;
          } else {
            zipFile = await BackupHelper.instance.createBackup();
          }
          await GoogleDriveHelper.instance.uploadBackup(zipFile);
          await GoogleDriveHelper.instance.enforceRetention();
          messages.add('Drive yedeklemesi başarılı.');
          anySuccess = true;
        }
      } catch (e) {
        final ex = GoogleDriveException.fromError(e);
        messages.add('Drive yedeklemesi başarısız: ${ex.message}');
      }
    }

    await _saveLastRun(success: anySuccess, message: messages.join(' '));

    if (!anySuccess) {
      throw Exception(messages.join(' '));
    }
  }
}
