import 'package:flutter/foundation.dart' show compute;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // compute için
import 'package:device_info_plus/device_info_plus.dart'; // DeviceInfoPlugin için
import 'package:permission_handler/permission_handler.dart'; // Permission, openAppSettings için
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'package:workmanager/workmanager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';



part 'db_helper.dart';
part 'backup_helper.dart';
part 'backup_restore_screen.dart';
part 'reminder_service.dart';
part 'content_blocks.dart';
part 'text_selection_menu.dart';
part 'theme.dart';
part 'note_list_screen.dart';
part 'settings_page.dart';
part 'calendar_screen.dart';
part 'backup_history_screen.dart';
part 'backup_last_info_widget.dart';
part 'google_drive_helper.dart';
part 'auto_backup_service.dart';
part 'auto_backup_settings_screen.dart';
part 'undo_redo_stack.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Otomatik yedekleme: WorkManager'ı başlat ve kayıtlı ayarlara göre
  // periyodik görevi yeniden zamanla (bkz. auto_backup_service.dart
  // başındaki açıklama — bazı OEM'lerde görev kaydı silinebildiğinden
  // her açılışta tekrar çağrılması güvenli ve gereklidir).
  await AutoBackupService.instance.initializeWorkmanager();
  await AutoBackupService.instance.rescheduleFromSavedSettings();

  // Hatırlatıcı bildirimleri için bildirim eklentisini ve zaman dilimi
  // verisini uygulama açılışında bir kez hazırla.
  await ReminderService.instance.init();

  // Uygulama ilk kez çizilmeden önce kayıtlı tema tercihini oku; böylece
  // açılışta koyu tema bir an için yanıp sönmez.
  final settings = await DBHelper.instance.getAllSettings();
  final storedThemeMode = settings['theme_mode'];
  if (storedThemeMode != null) {
    appThemeMode.value = themeModeFromSettingValue(storedThemeMode);
  } else {
    // Eski sürümden geliyorsa (theme_mode hiç yoksa) 'dark_theme' anahtarına
    // bakarak geri uyumlu bir geçiş yap.
    final legacyDark = settings['dark_theme'];
    if (legacyDark != null) {
      appThemeMode.value = legacyDark == 'true'
          ? ThemeMode.dark
          : ThemeMode.light;
    }
  }

  SystemChrome.setSystemUIOverlayStyle(
    dNoteSystemBarsStyleForMode(appThemeMode.value),
  );
  runApp(const DNoteApp());
}

final ThemeData _dNoteDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.amber,
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardTheme: const CardThemeData(color: Color(0xFF1E1E1E)),
  dividerColor: const Color(0xFF2A2A2A),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    // Liste kaydırıldığında AppBar'ın rengi otomatik koyulaşmasın diye
    // Material 3'ün scroll-altı tint/elevation efektini kapatıyoruz.
    surfaceTintColor: Colors.transparent,
    scrolledUnderElevation: 0,
  ),
  dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF1E1E1E)),
  popupMenuTheme: const PopupMenuThemeData(color: Color(0xFF2A2A2A)),
);

final ThemeData _dNoteLightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.amber,
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  cardTheme: const CardThemeData(color: Colors.white),
  dividerColor: const Color(0xFFE0E0E0),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    scrolledUnderElevation: 0,
  ),
  dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
  popupMenuTheme: const PopupMenuThemeData(color: Colors.white),
);

// ── Ekranlar genelinde kullanılan, temaya duyarlı yardımcı renkler ──────
// ThemeData'nın doğrudan karşılamadığı özel yüzey tonları (ör. çekmece
// başlığı, ikincil yüzey, kenarlık) için kullanılır. Aşama aşama tüm
// ekranlar bu yardımcılarla (veya doğrudan Theme.of(context) ile) güncellenir.
bool dNoteIsDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

Color dNoteSurfaceVariant(BuildContext context) =>
    dNoteIsDark(context) ? const Color(0xFF2A2A2A) : const Color(0xFFEDEDED);

Color dNoteBorderColor(BuildContext context) =>
    dNoteIsDark(context) ? const Color(0xFF3A3A3A) : const Color(0xFFDADADA);

Color dNoteHeaderColor(BuildContext context) =>
    dNoteIsDark(context) ? const Color(0xFF161616) : const Color(0xFFEDEDED);

// Seçili/vurgulanmış öğe arka planı: koyu temada hafif beyaz, açık temada
// hafif siyah — her iki temada da göz alıcı olmayan tutarlı bir vurgu verir.
Color dNoteHighlight(BuildContext context) =>
    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08);

// Kart / panel yüzeyi: _dNoteDarkTheme ve _dNoteLightTheme içindeki
// cardTheme ile birebir aynı tonlar. Ayarlar ekranı gibi elle Container
// çizen yerlerde ThemeData.cardTheme yerine bu kullanılır.
Color dNoteCardColor(BuildContext context) =>
    dNoteIsDark(context) ? const Color(0xFF1E1E1E) : Colors.white;

// Bir tarihi "gg.aa.yyyy ss:dd" biçiminde döndürür. Hatırlatıcı tarihini hem
// not düzenleyicide hem de önizleme kartlarında tutarlı biçimde göstermek
// için kullanılır.
String _formatDateTimeTr(DateTime dt) {
  final day = dt.day.toString().padLeft(2, '0');
  final month = dt.month.toString().padLeft(2, '0');
  final hour = dt.hour.toString().padLeft(2, '0');
  final minute = dt.minute.toString().padLeft(2, '0');
  return '$day.$month.${dt.year} $hour:$minute';
}

// Hatırlatıcı tekrar seçeneğinin Türkçe etiketi. Hem yeni hatırlatıcı
// dialogunda hem de not kartlarındaki hatırlatıcı rozetinde ortak kullanılır.
String _reminderRepeatLabelTr(String? repeat) {
  switch (repeat) {
    case 'hourly':
      return 'Her saat';
    case 'daily':
      return 'Her gün';
    case 'weekly':
      return 'Her hafta';
    case 'monthly':
      return 'Her ay';
    case 'yearly':
      return 'Her yıl';
    default:
      return 'Tekrar yok';
  }
}

const List<String> _dNoteMonthNamesTr = [
  'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
  'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
];

// Hatırlatıcı dialogundaki tarih satırının etiketi: bugünse "Bugün",
// yarınsa "Yarın", değilse "16 Temmuz" gibi gün + ay adı biçimi.
String _reminderDateLabelTr(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));
  final target = DateTime(date.year, date.month, date.day);
  if (target == today) return 'Bugün';
  if (target == tomorrow) return 'Yarın';
  return '${date.day} ${_dNoteMonthNamesTr[date.month - 1]}';
}

// _showReminderPickerDialog'un sonucu: seçilen tarih/saat ve tekrar sıklığı.
class _ReminderPickResult {
  final DateTime dateTime;
  // null: tekrarsız. Diğerleri: 'hourly' | 'daily' | 'weekly' | 'monthly' |
  // 'yearly'.
  final String? repeat;
  const _ReminderPickResult(this.dateTime, this.repeat);
}

// Birincil metin rengi: koyu temada beyaz, açık temada neredeyse siyah.
// Sabit "Colors.white" kullanan eski kodun açık temada okunmaz hale
// gelmesini önlemek için eklendi.
Color dNoteTextColor(BuildContext context) =>
    dNoteIsDark(context) ? Colors.white : const Color(0xFF1A1A1A);

// Kullanıcı, uygulama henüz açık tema desteklemezken (veya "Beyaz" rengini
// bilerek) Kişiselleştirme > Metin Rengi'nden saf beyazı seçmiş olabilir.
// Açık temada bu seçim doğrudan uygulanırsa metin, beyaz kart zemininde
// tamamen okunmaz hale gelir. Bu yüzden: açık temadayken saf beyaz özel
// renk varsa otomatik (temaya duyarlı) renge düşülür; kullanıcının seçtiği
// diğer tüm renkler (ve koyu temadaki beyaz seçimi) olduğu gibi korunur.
Color dNoteEffectiveTextColor(BuildContext context, Color? customColor) {
  if (customColor == null) return dNoteTextColor(context);
  if (!dNoteIsDark(context) && customColor.toARGB32() == Colors.white.toARGB32()) {
    return dNoteTextColor(context);
  }
  return customColor;
}

// ── Sistem çubukları (durum çubuğu + gezinme çubuğu) ────────────────────
// ÖNEMLİ: SystemUiOverlayStyle çağrılırken yalnızca durum çubuğu alanları
// verilip gezinme çubuğu (systemNavigationBar*) alanları boş bırakılırsa,
// platform gezinme çubuğunu kendi varsayılanına (genelde açık/beyaz bir
// görünüme) sıfırlayabiliyor. Bu yüzden HER çağrıda ikisi birlikte ve o
// anki temaya göre ayarlanır; ayrı ayrı, birbirini unutan çağrılar
// yazılmamalıdır.
SystemUiOverlayStyle dNoteSystemBarsStyle(
  BuildContext context, {
  Color? statusBarColor,
  Brightness? statusBarIconBrightnessOverride,
}) {
  final isDark = dNoteIsDark(context);
  return SystemUiOverlayStyle(
    statusBarColor: statusBarColor ?? Colors.transparent,
    statusBarIconBrightness:
        statusBarIconBrightnessOverride ??
        (isDark ? Brightness.light : Brightness.dark),
    statusBarBrightness:
        statusBarIconBrightnessOverride == null
            ? (isDark ? Brightness.dark : Brightness.light)
            : (statusBarIconBrightnessOverride == Brightness.light
                  ? Brightness.dark
                  : Brightness.light),
    systemNavigationBarColor: isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF5F5F5),
    systemNavigationBarIconBrightness: isDark
        ? Brightness.light
        : Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
  );
}

// main() içinde uygulama ilk açılırken henüz bir BuildContext yok; bu
// yüzden appThemeMode.value ve (Sistem seçiliyse) platform parlaklığına
// bakarak aynı stili context'siz üretir.
bool dNoteResolveIsDark(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.dark:
      return true;
    case ThemeMode.light:
      return false;
    case ThemeMode.system:
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
  }
}

SystemUiOverlayStyle dNoteSystemBarsStyleForMode(ThemeMode mode) {
  final isDark = dNoteResolveIsDark(mode);
  return SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    systemNavigationBarColor: isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF5F5F5),
    systemNavigationBarIconBrightness: isDark
        ? Brightness.light
        : Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
  );
}

class DNoteApp extends StatelessWidget {
  const DNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeMode,
      builder: (context, mode, _) {
        // Tema (Açık/Koyu/Sistem) her değiştiğinde durum ve gezinme
        // çubuklarını hemen yeni temaya göre günceller; aksi halde bir
        // sonraki ekran geçişine kadar eski (yanlış) stil görünür kalır.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          SystemChrome.setSystemUIOverlayStyle(
            dNoteSystemBarsStyleForMode(mode),
          );
        });
        return MaterialApp(
          title: 'DNote',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('tr', 'TR'), Locale('en', 'US')],
          locale: const Locale('tr', 'TR'),
          themeMode: mode,
          theme: _dNoteLightTheme,
          darkTheme: _dNoteDarkTheme,
          home: const NoteListScreen(),
        );
      },
    );
  }
}

