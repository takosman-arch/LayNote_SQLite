part of 'main.dart';

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

  // Bildirim paneline sabitleme, hatırlatıcıdan tamamen ayrı bir bildirim
  // numarası kullanır ('pin_' önekiyle farklı bir hash üretilir); böylece
  // aynı notun hem hatırlatıcısı hem de sabitlenmiş bildirimi aynı anda var
  // olabilir, biri diğerini iptal etmez.
  int _pinNotificationIdFor(String noteId) =>
      'pin_$noteId'.hashCode & 0x7fffffff;

  Future<void> schedule({
    required String noteId,
    required String title,
    required String body,
    required DateTime dateTime,
    // null/'none': tek seferlik, 'hourly': her saat, 'daily': her gün aynı
    // saatte, 'weekly': her hafta aynı gün/saatte, 'monthly': her ay aynı
    // günde/saatte, 'yearly': her yıl aynı ay/gün/saatte tekrarlar.
    String? repeat,
  }) async {
    if (!_initialized) await init();
    final id = _notificationIdFor(noteId);
    await _plugin.cancel(id);

    // 'hourly' seçeneğinde eklentinin matchDateTimeComponents mekanizması
    // (yalnızca saat/gün/ay eşleştirir) kullanılamaz; bunun yerine sabit
    // aralıklı tekrar API'si kullanılır.
    if (repeat == 'hourly') {
      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          'dnote_reminders',
          'Not Hatırlatıcıları',
          channelDescription: 'DNote uygulamasındaki not hatırlatıcıları',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      );
      try {
        await _plugin.periodicallyShow(
          id,
          title.isEmpty ? 'Hatırlatıcı' : title,
          body,
          RepeatInterval.hourly,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      } catch (_) {
        // Planlama başarısız oldu; sessizce yut, uygulama çökmesin.
      }
      return;
    }

    final isRepeating = repeat == 'daily' ||
        repeat == 'weekly' ||
        repeat == 'monthly' ||
        repeat == 'yearly';
    // Tekrarsız hatırlatıcılarda geçmiş bir zaman kurulamaz. Tekrarlı
    // olanlarda ise verilen tarih sadece saat (ve haftalık/aylık/yıllık
    // olanlarda gün/ay) bilgisini belirlemek için kullanılır; eklenti bir
    // sonraki uygun zamanı otomatik bulduğu için geçmişte olması sorun
    // değildir.
    if (!isRepeating && dateTime.isBefore(DateTime.now())) return;

    final DateTimeComponents? matchComponents = repeat == 'daily'
        ? DateTimeComponents.time
        : repeat == 'weekly'
        ? DateTimeComponents.dayOfWeekAndTime
        : repeat == 'monthly'
        ? DateTimeComponents.dayOfMonthAndTime
        : repeat == 'yearly'
        ? DateTimeComponents.dateAndTime
        : null;

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
        matchDateTimeComponents: matchComponents,
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
          matchDateTimeComponents: matchComponents,
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

  // ── Bildirim Paneline Sabitleme ────────────────────────────────────────
  // Notu, kullanıcı kaydırarak kapatana kadar (veya "Sabitlemeyi Kaldır"
  // seçilene kadar) bildirim panelinde kalıcı olarak gösterir. Sessiz ve
  // düşük öncelikli ayrı bir kanal ('dnote_pinned') kullanılır ki normal
  // hatırlatıcı bildirimleri gibi ses/titreşimle rahatsız etmesin; sadece
  // panelde sabit bir simge/özet olarak kalır.
  Future<void> pinToNotificationPanel({
    required String noteId,
    required String title,
    required String body,
  }) async {
    if (!_initialized) await init();
    final id = _pinNotificationIdFor(noteId);
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'dnote_pinned',
        'Sabitlenmiş Notlar',
        channelDescription:
            'Bildirim paneline sabitlenen DNote notları',
        importance: Importance.low,
        priority: Priority.low,
        ongoing: true,
        autoCancel: false,
        showWhen: false,
        playSound: false,
        enableVibration: false,
        icon: '@mipmap/ic_launcher',
        styleInformation: BigTextStyleInformation(body),
      ),
      iOS: const DarwinNotificationDetails(presentSound: false),
    );
    try {
      await _plugin.show(
        id,
        title.isEmpty ? 'Not' : title,
        body,
        details,
      );
    } catch (_) {
      // Bildirim izni verilmemiş olabilir; sessizce yut.
    }
  }

  Future<void> unpinFromNotificationPanel(String noteId) async {
    if (!_initialized) await init();
    await _plugin.cancel(_pinNotificationIdFor(noteId));
  }

  // Uygulama açılışında, cihaz yeniden başlatıldığında veya uygulama tamamen
  // kapatılıp açıldığında sistem tarafından temizlenmiş olabilecek sabitlenmiş
  // bildirimleri, veritabanındaki 'isPinnedToNotification' işaretine bakarak
  // yeniden gösterir.
  Future<void> restorePinnedNotes(List<Map<String, dynamic>> notes) async {
    if (!_initialized) await init();
    for (final note in notes) {
      if (note['isPinnedToNotification'] != true) continue;
      final noteId = note['id']?.toString();
      if (noteId == null) continue;
      final title = (note['title'] ?? '').toString().trim();
      final content = ContentBlocks.plainText(note['content'] as String?);
      await pinToNotificationPanel(
        noteId: noteId,
        title: title.isEmpty ? 'Not' : title,
        body: content,
      );
    }
  }
}

