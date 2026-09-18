import 'package:flutter/foundation.dart'; // compute için
import 'package:device_info_plus/device_info_plus.dart'; // DeviceInfoPlugin için
import 'package:package_info_plus/package_info_plus.dart'; // Ayarlar > Hakkında ekranında sürüm bilgisi için
import 'package:permission_handler/permission_handler.dart'; // Permission, openAppSettings için
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart'; // NoteEditorScrollPhysics (uzun not editöründe daha yumuşak/uzun kayma) için
import 'package:flutter/rendering.dart' hide Constraints;
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart'; // TapGestureRecognizer için (link tıklama)
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart'; // AppLocalizations için — paket adınız farklıysa 'package:PAKET_ADINIZ/l10n/app_localizations.dart' olarak değiştirin
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart'; // Ek fotoğrafları kırpma/döndürme için
import 'package:gal/gal.dart'; // Fotoğrafı cihaz galerisine kaydetme için
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
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdf/pdf.dart' hide PdfDocument, PdfPage;
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;
import 'package:video_player/video_player.dart';
// ── Not içindeki görsellerde galeri tarzı kaydırma (zoom + sağa-sola
// geçiş) için ──
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:home_widget/home_widget.dart'; // Ana ekran widget'ı için



part 'db_helper.dart';
part 'note_widget_service.dart';
part 'backup_helper.dart';
part 'backup_restore_screen.dart';
part 'reminder_service.dart';
part 'content_blocks.dart';
part 'rich_text_spans.dart';
part 'rich_block_text_controller.dart';
// Aşama 6: not içi "Bul ve Değiştir" özelliği. rich_block_text_controller.
// dart'ın hemen altına eklendi — ikisi de RichBlockTextController'ın vurgu
// katmanına (TextHighlightSnapshot) bağlı, birbirine en yakın iki part.
part 'note_find_session.dart';
part 'note_find_bar.dart';
part 'text_selection_menu.dart';
part 'theme.dart';
part 'note_list_screen.dart';
part 'note_list_selection_mixin.dart';
part 'note_list_lifecycle_mixin.dart';
part 'note_list_data_category_mixin.dart';
part 'note_list_actions_mixin.dart';
part 'note_list_attachment_mixin.dart';
part 'note_list_note_dialog_mixin.dart';
part 'note_tags_sheet.dart';
part 'note_list_build_mixin.dart';
part 'note_flag_mixin.dart';
part 'settings_page.dart';
part 'about_screen.dart';
part 'calendar_screen.dart';
part 'gundem_screen.dart';
part 'backup_history_screen.dart';
part 'backup_last_info_widget.dart';
part 'google_drive_helper.dart';
part 'auto_backup_service.dart';
part 'auto_backup_settings_screen.dart';
part 'undo_redo_stack.dart';
part 'pdf_export_service.dart';
part 'note_screenshot_service.dart';
part 'image_crop_helper.dart';
part 'note_drawing_block.dart';
part 'note_calc_table_block.dart';
part 'note_table_block.dart';
part 'note_checklist_block.dart';





// google_drive_helper.dart gibi BuildContext almayan servis sınıflarının
// AppLocalizations'a erişebilmesi için global bir navigatorKey. MaterialApp'a
// aşağıda (DNoteApp) verilir.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Bayrak (flama) renklerine kullanıcı tarafından verilen isimler (hex ->
// isim). Notlara özel değil, sabit palete (NoteFlagMixin._flagPalette)
// özeldir; bu yüzden tek bir global ValueNotifier olarak tutulur ve
// uygulama açılışında main()'de DBHelper'dan doldurulur (bkz.
// note_flag_mixin.dart -> _showFlagNameDialog, DBHelper.setFlagColorName).
final ValueNotifier<Map<String, String>> flagColorNames =
    ValueNotifier<Map<String, String>>({});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  // Vurgu rengi tercihini de aynı şekilde ilk çizimden önce oku; böylece
  // açılışta bir an için eski (varsayılan) renk yanıp sönmez. Hiç kayıtlı
  // değer yoksa (ilk kurulum), yukarıda okunan tema moduna göre varsayılan
  // renk kullanılır: koyu temada Amber, açık temada Blue.
  appAccentColor.value = accentColorFromSettingValue(
    settings['accent_color'],
    fallback: dNoteDefaultAccentColorForThemeMode(appThemeMode.value),
  );

  // Widget yapılandırma (not seçim) ekranının Açık/Koyu tema tercihiyle
  // tutarlı açılabilmesi için geçerli parlaklığı native tarafa yaz (bkz.
  // theme.dart -> dNoteSyncThemeToWidgetStorage). appThemeMode her
  // değiştiğinde (ör. Ayarlar sayfasından) de tekrar yazılması için bir
  // dinleyici eklenir; bu dinleyici uygulama ömrü boyunca kalır.
  unawaited(dNoteSyncThemeToWidgetStorage());
  appThemeMode.addListener(() {
    unawaited(dNoteSyncThemeToWidgetStorage());
  });

  // Dil tercihi: kayıtlı ayar yoksa (ilk kurulum) 'system' kalır.
  appLanguage.value = settings['app_language'] ?? 'system';

  // Bayrak renklerine daha önce verilmiş isimler (varsa) ilk çizimden
  // önce yüklenir; böylece kart rozetleri/menü satırı vb. ilk açılışta
  // isimsiz görünüp bir an sonra ismiyle güncellenmez.
  flagColorNames.value = await DBHelper.instance.getFlagColorNames();

  SystemChrome.setSystemUIOverlayStyle(
    dNoteSystemBarsStyleForMode(appThemeMode.value),
  );
  runApp(const DNoteApp());

  // AŞAĞIDAKİLER İLK FRAME'İ BLOKLAMASIN DİYE runApp()'TAN SONRAYA
  // ALINDI: Bildirime dokunarak soğuk başlangıçta açılan bir notun,
  // Workmanager/otomatik yedekleme/ReminderService başlatma işleri
  // bitene kadar beklemesine yol açıyordu. Bu işler notu açmak için
  // gerekli değildir; NoteListScreen zaten kendi initState/_loadData
  // akışında ReminderService.instance.getLaunchNoteId() ile bildirimden
  // gelen notu ayrıca kontrol edip açıyor (bkz.
  // note_list_data_category_mixin.dart -> _loadData,
  // note_list_lifecycle_mixin.dart -> _openNoteByIdFromNotification).
  unawaited(_initBackgroundServices());
}

// Uygulamanın ilk frame'i çizildikten sonra arka planda başlatılan,
// kullanıcının notu görmesi için beklenmesi gerekmeyen servisler.
Future<void> _initBackgroundServices() async {
  // Hatırlatıcı bildirimleri için bildirim eklentisini ve zaman dilimi
  // verisini hazırla. NoteListScreen._loadData() içindeki
  // getLaunchNoteId() çağrısı zaten kendi içinde "if (!_initialized)
  // await init()" ile bunu bekliyor; burada erken başlatmak sadece o
  // beklemeyi kısaltır.
  await ReminderService.instance.init();

  // Otomatik yedekleme: WorkManager'ı başlat ve kayıtlı ayarlara göre
  // periyodik görevi (gerekiyorsa) yeniden zamanla. Bu, notun açılmasıyla
  // hiçbir ilgisi olmadığından ilk frame'den sonraya bırakıldı.
  //
  // resetIfExists: false — AŞAMA 8.1 DÜZELTMESİ: Bu çağrı HER uygulama
  // açılışında yapıldığı için, önceden kullanılan varsayılan (replace)
  // davranış periyodik görevin geri sayımını her açılışta sıfırlıyor ve
  // otomatik yedeklemenin fiilen hiç tetiklenmemesine yol açıyordu.
  // 'keep' politikası, görev zaten kayıtlıysa dokunmaz (geri sayım
  // korunur); sadece bir OEM tarafından sessizce silinmişse yeniden
  // oluşturur (bkz. auto_backup_service.dart -> rescheduleFromSavedSettings
  // açıklaması). Kullanıcı Ayarlar ekranından bir ayarı GERÇEKTEN
  // değiştirdiğinde ise o ekran varsayılan (resetIfExists: true) ile
  // çağırmaya devam eder — yeni ayarların hemen uygulanması gerekir.
  await AutoBackupService.instance.initializeWorkmanager();
  await AutoBackupService.instance
      .rescheduleFromSavedSettings(resetIfExists: false);

  // Çöp kutusu temizliği: otomatik yedekleme AÇIK/KAPALI olmasından
  // bağımsız olarak her zaman kayıtlı tutulur — böylece kullanıcı
  // yedeklemeyi kapatsa bile 30 günü geçen çöp kutusu notları arka
  // planda silinmeye devam eder (bkz. auto_backup_service.dart ->
  // scheduleTrashCleanupTask).
  await AutoBackupService.instance.scheduleTrashCleanupTask();

  // AŞAMA 9: Arka plan görevi (WorkManager) OEM pil optimizasyonu
  // yüzünden çalışmamış olabilir; süresi dolmuşsa yedeklemeyi burada,
  // ön planda "yakalayarak" tamamlar. _initBackgroundServices() zaten
  // runApp()'tan sonra unawaited() ile çağrıldığı için (bkz. main()
  // içindeki not) bu, ilk frame'i bloklamaz — uygulama anında açılır,
  // yedekleme varsa arka planda sessizce devam eder.
  await AutoBackupService.instance.checkAndRunIfDue();
}

final ThemeData _dNoteDarkTheme = ThemeData(
  brightness: Brightness.dark,
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
// Hatırlatıcı tekrar seçeneğinin etiketi. Hem yeni hatırlatıcı dialogunda
// hem de not kartlarındaki hatırlatıcı rozetinde ortak kullanılır.
String _reminderRepeatLabelTr(BuildContext context, String? repeat) {
  final l10n = AppLocalizations.of(context)!;
  switch (repeat) {
    case 'hourly':
      return l10n.gundemRepeatHourly;
    case 'daily':
      return l10n.gundemRepeatDaily;
    case 'weekly':
      return l10n.gundemRepeatWeekly;
    case 'monthly':
      return l10n.gundemRepeatMonthly;
    case 'yearly':
      return l10n.gundemRepeatYearly;
    default:
      return l10n.reminderRepeatNoneLabel;
  }
}

// Tam ay isimleri calendar_screen.dart / note_list_data_category_mixin.dart
// ile aynı ARB anahtarlarını (calendarMonthJan..Dec) kullanır.
List<String> _dNoteMonthNamesTr(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return [
    l10n.calendarMonthJan, l10n.calendarMonthFeb, l10n.calendarMonthMar,
    l10n.calendarMonthApr, l10n.calendarMonthMay, l10n.calendarMonthJun,
    l10n.calendarMonthJul, l10n.calendarMonthAug, l10n.calendarMonthSep,
    l10n.calendarMonthOct, l10n.calendarMonthNov, l10n.calendarMonthDec,
  ];
}

// Hatırlatıcı dialogundaki tarih satırının etiketi: bugünse "Bugün",
// yarınsa "Yarın", değilse "16 Temmuz" gibi gün + ay adı biçimi.
String _reminderDateLabelTr(BuildContext context, DateTime date) {
  final l10n = AppLocalizations.of(context)!;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));
  final target = DateTime(date.year, date.month, date.day);
  if (target == today) return l10n.gundemSectionToday;
  if (target == tomorrow) return l10n.gundemSectionTomorrow;
  return '${date.day} ${_dNoteMonthNamesTr(context)[date.month - 1]}';
}

// ── Not içi otomatik matematik hesaplayıcı ──────────────────────────────
// Kullanıcı bir not satırına dört işlem (+ - * /) ve üs alma içeren bir
// ifade yazıp satırın SONUNA "=" karakterini eklediğinde, ifadeyi anında
// hesaplayıp sonucu "=" işaretinden hemen sonra otomatik olarak yazar.
// Örn: "(2+4)+5*4+2^2-4/2=" yazılınca satır
//      "(2+4)+5*4+2^2-4/2=28" haline gelir. İfade satırın tamamı olmak
// zorunda değildir; "Toplam: 2+4=" gibi öncesinde düz metin bulunan
// satırlarda da yalnızca "=" işaretine kadar geriye doğru geçerli olan
// en uzun matematik ifadesi ("2+4") hesaplanır.
// "=" işaretinden hemen önce bir boşluk varsa (ör. "100 + 12 ="), sonuç da
// bir boşlukla eklenir ("100 + 12 = 112"); boşluk yoksa sonuç doğrudan "="
// işaretinin ardına eklenir (ör. "2+4=6").
// Üs (kuvvet) işareti için hem "^" hem de "'" kabul edilir; bazı
// klavyelerde "^" yazmak zahmetli olduğundan kullanıcı tırnak işaretiyle
// de (ör. "2'2") üs alabilir.
//
// Yüzde (%): "+" veya "-" işaretinden HEMEN SONRA "%sayı" yazılırsa,
// bu sayı sabit bir değer değil, o ana kadar biriken sonucun YÜZDESİ
// olarak yorumlanır — normal cep hesap makinelerindeki "+ %" tuşuyla
// AYNI mantık. Örn: "100+%12=" -> 100 + (100'ün %12'si) = 112.
// "250-%10=" -> 250 - (250'nin %10'u) = 225.
// "%" işareti "*" veya "/"'den sonra ya da ifadenin başında/parantez
// içinde kullanılırsa (ör. "50*%20"), bu durumda bağlamdan bağımsız,
// sadece o sayıyı 100'e bölen bir kısayoldur ("%20" = 0,2) — yani
// "50*%20=10" olur (50 * 0,2).
//
// Not: Bu yalnızca sözdizimsel olarak geçerli bir matematik ifadesiyse
// devreye girer (yalnızca rakam, boşluk, ondalık ayırıcı ve + - * / ^ '
// ( ) karakterleri). Harf içeren normal cümlelerde veya "=" satırın
// ortasına eklendiğinde hiçbir şey yapmaz; kullanıcının yazdığı "="
// olduğu gibi kalır. TEK İSTİSNA: satır yalnızca bir "toplam" anahtar
// kelimesinden ibaretse ("toplam=", "Total=") üstteki liste satırlarını
// toplama modu devreye girer (bkz. _dNoteAutoSumAboveLines).
//
// Birim (para birimi) sembolü: bir sayının HEMEN ardına ₺, $, €, £, ¥,
// ₽ ya da ₹ sembollerinden biri eklenirse, bu sembol hesaba katılmadan
// çıkarılıp aslında ifade hesaplanır, ardından aynı sembol sonuca da
// eklenir. Örn: "100$+%5=" -> "100$+%5=105$". Bir satırda birden fazla
// sayının ardında birim varsa hepsi AYNI sembol olmalıdır; farklı
// birimlerin karışık kullanımı (ör. "100$+5€") geçersiz sayılır ve
// normal metin gibi davranılıp hiçbir hesaplama yapılmaz.

class _MathExprSyntaxError implements Exception {}

// Sonuca eklenebilecek "birim" (para birimi) sembolleri. Bir sayının HEMEN
// ardına yazılan bu semboller ifadeden çıkarılıp asıl hesap yapılır, sonra
// aynı sembol sonuca da eklenir. Örn: "100$+%5=" -> "100$+%5=105$".
// İfadede birden fazla sayının ardında birim varsa hepsi AYNI sembol olmak
// zorundadır; farklı birimlerin karışık kullanımı (ör. "100$+5€") geçersiz
// sayılır ve normal metin gibi davranılıp hiçbir hesaplama yapılmaz.
const List<String> _dNoteCalcUnitSymbols = ['₺', '\$', '€', '£', '¥', '₽', '₹'];

// _MathExpressionEvaluator.tryEvaluateWithUnit'in dönüş değeri: hesaplanan
// sayısal sonuç ve (varsa) ifadede bulunan birim sembolü.
class _CalcResult {
  final double value;
  final String? unit;
  // Birim sembolü ifadede sayının ÖNÜNDE mi ("$100") yoksa ARDINDA mı
  // ("100$") kullanılmış — sonuca eklerken aynı konumu korumak için.
  // unit null ise anlamsızdır (varsayılan false).
  final bool unitIsPrefix;
  const _CalcResult(this.value, this.unit, {this.unitIsPrefix = false});
}

class _MathExpressionEvaluator {
  final String _src;
  int _pos = 0;
  _MathExpressionEvaluator._(this._src);

  // ── DÜZELTME: postfix '%' desteği, '+'/'-' bağlamı ──────────────────
  // "100+%18=118" (önek) zaten çalışıyordu; kullanıcı "100+18%=118" (sonek)
  // biçimini de istedi. Bu regex, operatörden hemen sonra gelen "ÇIPLAK
  // sayı + %" örüntüsünü (aralarında başka işlem YOKKEN) yakalar — bu
  // sayede _parseExpression, rhs'i genel _parseTerm() zincirine hiç
  // sokmadan (ki o zincir '%'i genel "/100" kısayolu olarak tüketip
  // "soldaki değerin yüzdesi" anlamını kaybederdi) doğrudan "soldaki
  // değerin yüzdesi" formülünü uygulayabilir. Sadece '+'/'-' hemen
  // ardından BAŞKA bir işlem olmadan gelen basit "sayı%" biçimini kapsar;
  // "100+2*5%" gibi daha karmaşık durumlar bilerek buraya düşmez, genel
  // atom-seviyesi postfix kısayoluna (bkz. _parseUnary) bırakılır.
  //
  // DÜZELTME (500+18%=500,18 gibi yanlış sonuç): burada '^' işareti
  // KULLANILAMAZ. '^', Dart'ta (ve JS'te) girdinin MUTLAK başlangıcına
  // (index 0) bağlıdır; matchAsPrefix(_src, pos) çağrısındaki [pos]
  // parametresine göre yeniden konumlanmaz. "500+18%" gibi bir ifadede
  // '+'dan sonraki konum (pos=4) asla 0 olmadığından '^' şartı HİÇBİR
  // ZAMAN sağlanmıyor, bareMatch hep null dönüyor ve kod sessizce genel
  // atom-seviyesi postfix yoluna (18% -> 0,18, düz sayı toplaması) düşüp
  // yanlış sonuç (500,18) üretiyordu. matchAsPrefix zaten eşleşmenin tam
  // olarak [pos]'ta başlamasını garanti ettiğinden '^' burada gereksiz
  // VE zararlıydı.
  static final RegExp _bareNumberPercentRegex = RegExp(
    r'([0-9]+(?:[.,][0-9]+)?)\s*%',
  );

  /// [raw] geçerli bir matematik ifadesiyse sonucu döndürür; değilse
  /// (harf içeriyorsa, dengesiz parantez varsa, sıfıra bölme vb.) null
  /// döner — bu durumda çağıran taraf hiçbir şey yapmamalıdır.
  static double? tryEvaluate(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    // Sadece rakam / boşluk / ondalık ayırıcı (. veya ,) / dört işlem /
    // üs (^ veya ') / parantez içeriyorsa bir hesap ifadesi say.
    if (!RegExp(r"^[0-9\s.,+\-*/^'()%]+$").hasMatch(trimmed)) return null;
    if (!RegExp(r'[0-9]').hasMatch(trimmed)) return null;
    try {
      final evaluator = _MathExpressionEvaluator._(
        trimmed.replaceAll("'", '^'),
      );
      final value = evaluator._parseExpression();
      evaluator._skipSpaces();
      if (evaluator._pos != evaluator._src.length) {
        // İfadenin tamamı tüketilmedi (ör. "2+2)" gibi fazlalık kaldı).
        return null;
      }
      if (value.isNaN || value.isInfinite) return null;
      return value;
    } catch (_) {
      return null;
    }
  }

  /// [tryEvaluate] ile aynı işi yapar, ek olarak ifadede bir birim sembolü
  /// (ör. "100$" ya da "$100" içindeki "$") olup olmadığını da tespit eder.
  /// Sembol, hesaplama öncesinde ifadeden çıkarılır; sonuçta hem sayı hem de
  /// (varsa) aynı sembol ve konumu (önde/sonda) [_CalcResult.unit] /
  /// [_CalcResult.unitIsPrefix] olarak geri döner. Aynı ifadede birden
  /// fazla FARKLI sembol kullanılması, bir sembolün hem önde hem sonda
  /// (tutarsız) kullanılması, ya da sembolün sayıya bitişik olmayan bir
  /// yerde geçmesi durumunda null döner (hesap yapılmaz).
  static _CalcResult? tryEvaluateWithUnit(String raw) {
    var stripped = raw;
    String? unit;
    var unitIsPrefix = false;
    for (final symbol in _dNoteCalcUnitSymbols) {
      if (!stripped.contains(symbol)) continue;
      if (unit != null) return null; // birden fazla farklı birim: geçersiz
      // Sembol sayının ÖNÜNDE mi ("$100") yoksa ARDINDA mı ("100$")
      // kullanılmış — ikisi ayrı ayrı sayılır, aynı ifadede İKİSİ BİRDEN
      // (ör. "$100+12€... " gibi karışık kullanım değil, "$100+12$" gibi
      // tutarlı ama karışık konumlu kullanım) geçersiz sayılır: tüm
      // geçişler ya hep önde ya hep sonda olmalı.
      final beforeDigit = RegExp('${RegExp.escape(symbol)}([0-9])');
      final afterDigit = RegExp('([0-9])${RegExp.escape(symbol)}');
      final totalOccurrences = symbol.allMatches(stripped).length;
      final beforeDigitOccurrences = beforeDigit.allMatches(stripped).length;
      final afterDigitOccurrences = afterDigit.allMatches(stripped).length;
      final isAllPrefix = beforeDigitOccurrences == totalOccurrences;
      final isAllSuffix = afterDigitOccurrences == totalOccurrences;
      if (!isAllPrefix && !isAllSuffix) return null;
      unit = symbol;
      unitIsPrefix = isAllPrefix;
      stripped = stripped.replaceAllMapped(
        isAllPrefix ? beforeDigit : afterDigit,
        (m) => m.group(1)!,
      );
    }
    final value = tryEvaluate(stripped);
    if (value == null) return null;
    return _CalcResult(value, unit, unitIsPrefix: unitIsPrefix);
  }

  void _skipSpaces() {
    while (_pos < _src.length && _src[_pos] == ' ') {
      _pos++;
    }
  }

  bool _isDigit(String ch) => ch.codeUnitAt(0) >= 48 && ch.codeUnitAt(0) <= 57;

  // Toplama / çıkarma (en düşük öncelik).
  double _parseExpression() {
    _skipSpaces();
    double value = _parseTerm();
    _skipSpaces();
    while (_pos < _src.length && (_src[_pos] == '+' || _src[_pos] == '-')) {
      final op = _src[_pos];
      _pos++;
      _skipSpaces();
      // "+%12" / "-%12": '%' işareti operatörden HEMEN SONRA geldiyse
      // bu bir sabit sayı DEĞİL, soldaki (o ana kadar biriken) değerin
      // yüzdesidir (ör. "100+%12" -> 100 + 100*12/100). Bu yüzden '%'yi
      // burada tüketip sağ tarafı normal bir terim olarak (yüzde
      // OLMADAN, düz sayı olarak) okuyoruz; _parseUnary'deki genel
      // "%sayı = sayı/100" kısayoluna düşmesin diye '%' zaten burada
      // yutuldu.
      final isPercentOfValue = _pos < _src.length && _src[_pos] == '%';
      if (isPercentOfValue) _pos++;
      // DÜZELTME: prefix ("%18") zaten yukarıda ele alınıyor. Postfix
      // ("18%") için, rhs'i genel zincire sokmadan ÖNCE bakılır — aksi
      // halde _parseUnary'deki genel postfix kısayolu '%'i tüketip
      // rhs'i (18/100=0,18) döndürür ve "soldaki değerin yüzdesi" değil
      // düz bir sayı toplaması gibi yanlış yorumlanır.
      final bareMatch = isPercentOfValue
          ? null
          : _bareNumberPercentRegex.matchAsPrefix(_src, _pos);
      final isPostfixPercentOfValue = bareMatch != null;
      final double rhs;
      if (isPostfixPercentOfValue) {
        rhs = double.parse(
          bareMatch!.group(1)!.replaceAll(',', '.'),
        );
        _pos = bareMatch.end;
      } else {
        rhs = _parseTerm();
      }
      final delta = (isPercentOfValue || isPostfixPercentOfValue)
          ? value * rhs / 100
          : rhs;
      value = op == '+' ? value + delta : value - delta;
      _skipSpaces();
    }
    return value;
  }

  // Çarpma / bölme.
  double _parseTerm() {
    _skipSpaces();
    double value = _parsePower();
    _skipSpaces();
    while (_pos < _src.length && (_src[_pos] == '*' || _src[_pos] == '/')) {
      final op = _src[_pos];
      _pos++;
      final rhs = _parsePower();
      if (op == '*') {
        value = value * rhs;
      } else {
        if (rhs == 0) throw _MathExprSyntaxError();
        value = value / rhs;
      }
      _skipSpaces();
    }
    return value;
  }

  // Üs alma (sağdan sola birleşimli): 2^3^2 = 2^(3^2).
  double _parsePower() {
    _skipSpaces();
    final base = _parseUnary();
    _skipSpaces();
    if (_pos < _src.length && _src[_pos] == '^') {
      _pos++;
      final exponent = _parsePower();
      final result = math.pow(base, exponent);
      if (result is int) return result.toDouble();
      return result as double;
    }
    return base;
  }

  // Tekli artı/eksi: -5, +(2+3) gibi.
  double _parseUnary() {
    _skipSpaces();
    // Genel '%' kısayolu: burada (yani '+' / '-' operatöründen HEMEN
    // sonrası DIŞINDAKİ her yerde — çarpma/bölme, ifadenin başı, parantez
    // içi vb.) '%sayı' bağlamdan bağımsız olarak sadece sayı/100'dür.
    // Bağlama duyarlı ("soldaki değerin yüzdesi") özel durum zaten
    // _parseExpression içinde '+'/'-' için ayrıca ele alınıp '%' orada
    // tüketiliyor; oraya hiç gelmeyen (ör. "50*%20") tüm '%' kullanımları
    // buraya düşer.
    if (_pos < _src.length && _src[_pos] == '%') {
      _pos++;
      final value = _parseUnary();
      return value / 100;
    }
    if (_pos < _src.length && (_src[_pos] == '+' || _src[_pos] == '-')) {
      final op = _src[_pos];
      _pos++;
      final value = _parseUnary();
      return op == '-' ? -value : value;
    }
    final value = _parseAtom();
    // ── DÜZELTME: postfix '%' desteği (ör. "50*20%" -> 50*0,2) ──────────
    // Şimdiye kadar '%' yalnızca sayının ÖNÜNDE tanınıyordu (bkz. bu
    // fonksiyonun başındaki '%sayı' kısayolu). Sayının ARDINDA kullanımı
    // (klasik hesap makinelerindeki "%" tuşu gibi) hiç desteklenmiyordu;
    // "18%" yazıldığında '%' karakteri tüketilmeden kalıyor, ifadenin
    // tamamı tüketilemediği için tryEvaluate baştan null dönüyordu.
    // Burada, herhangi bir atomun (sayı ya da parantezli alt ifade)
    // hemen ardından gelen '%' aynı anlamı taşır: değeri 100'e böler.
    // Bu, '+' / '-' bağlamındaki özel "soldaki değerin yüzdesi" durumuyla
    // ÇAKIŞMAZ; o durum _parseExpression içinde bu noktaya hiç
    // gelmeden (rhs hiç _parseTerm/_parseUnary'e uğramadan) ayrıca ele
    // alınıyor (bkz. aşağıdaki _bareNumberPercentRegex kullanımı).
    _skipSpaces();
    if (_pos < _src.length && _src[_pos] == '%') {
      _pos++;
      return value / 100;
    }
    return value;
  }

  // Parantezli alt ifade ya da tek bir sayı.
  double _parseAtom() {
    _skipSpaces();
    if (_pos >= _src.length) throw _MathExprSyntaxError();
    if (_src[_pos] == '(') {
      _pos++;
      final value = _parseExpression();
      _skipSpaces();
      if (_pos >= _src.length || _src[_pos] != ')') {
        throw _MathExprSyntaxError();
      }
      _pos++;
      return value;
    }
    return _parseNumber();
  }

  double _parseNumber() {
    final start = _pos;
    while (_pos < _src.length &&
        (_isDigit(_src[_pos]) || _src[_pos] == '.' || _src[_pos] == ',')) {
      _pos++;
    }
    if (_pos == start) throw _MathExprSyntaxError();
    final numStr = _src.substring(start, _pos).replaceAll(',', '.');
    if ('.'.allMatches(numStr).length > 1) throw _MathExprSyntaxError();
    final value = double.tryParse(numStr);
    if (value == null) throw _MathExprSyntaxError();
    return value;
  }
}

// Hesap sonucunu Türkçe ondalık ayırıcıyla (virgül), gereksiz sıfırlar
// olmadan biçimlendirir: 28 -> "28", 4.5 -> "4,5", 3.3333... -> "3,333333"
// (en fazla 6 ondalık basamak, sondaki sıfırlar kırpılır).
String _formatMathResult(double value) {
  if (value == value.roundToDouble() && value.abs() < 1e15) {
    return value.toInt().toString();
  }
  String s = value.toStringAsFixed(6);
  s = s.replaceFirst(RegExp(r'0+$'), '');
  s = s.replaceFirst(RegExp(r'\.$'), '');
  return s.replaceAll('.', ',');
}

// Her TextEditingController için bir önceki onChanged çağrısında görülen
// metni saklar. dNoteMaybeAutoCalculate'in "kullanıcı '=' işaretini ŞİMDİ mi
// yazdı, yoksa var olan bir sonucu SİLERKEN mi imleç '='in hemen ardına
// geldi" ayrımını yapabilmesi için gerekir (bkz. fonksiyon içindeki not).
// Expando kullanılıyor: controller çöpe gidince kayıt da otomatik silinir.
final Expando<String> _dNoteAutoCalcLastText = Expando<String>(
  'dNoteAutoCalcLastText',
);

// ── "Toplam=" ile üstteki listeyi toplama ───────────────────────────────
// Bir satıra yalnızca aşağıdaki anahtar kelimelerden biri + "=" yazılırsa
// (ör. "toplam=", "Total=", büyük/küçük harf farketmez), normal matematik
// ifadesi aranmaz; bunun yerine o satırın HEMEN ÜSTÜNDEKİ ardışık sayı
// satırları toplanır ve sonuç "=" işaretinin ardına yazılır.
// Örn:
//   100
//   200
//   300
//   toplam=
// ->
//   100
//   200
//   300
//   toplam=600
//
// Satırlar çıplak sayı olmak zorunda değildir: sayının ÖNÜNDE düz metin
// (etiket) bulunan satırlar da toplanır (bkz. [_dNoteIsPlainLabel]). Örn:
//   ekmek 50
//   su: 30
//   toplam=
// ->
//   ekmek 50
//   su: 30
//   toplam=80
//
// DİL KONUSU: Bu kelime listesi, uygulamanın arayüz dilinden (appLanguage)
// BAĞIMSIZ olarak tutulur ve hepsi AYNI ANDA tanınır. Sebebi: not içeriği
// kullanıcının o an serbestçe yazdığı bir metindir, arayüz diliyle aynı
// olmak zorunda değildir (ör. arayüz Türkçe olsa da kullanıcı notuna
// İngilizce "Total=" yazmış olabilir). Aşağıdaki liste kapsayıcı olmaya
// çalışır ama eksiksiz değildir; eksik bir dil/eş anlamlı varsa listeye
// yeni bir satır eklemek yeterlidir.
const List<String> _dNoteCalcTotalKeywords = [
  'toplam', // Türkçe
  'total', // İngilizce, İspanyolca, Portekizce, Fransızca, Rumence
  'summe', 'gesamt', // Almanca
  'totale', // İtalyanca
  'итого', 'сумма', // Rusça
  '合計', '合计', '总计', // Japonca / Çince
  '합계', // Korece
  'कुल', // Hintçe
  'jumlah', // Endonezyaca
  'tổng', // Vietnamca
  'รวม', // Tayca
  'suma', 'razem', // Lehçe
  'totaal', // Felemenkçe
  'i alt', // Danca
  'totalt', 'summa', // İsveççe
  'المجموع', // Arapça
  'סהכ', // İbranice (tırnak işaretleri normalize edildikten sonraki hali)
  'разом', 'сума', // Ukraynaca
  'součet', 'celkem', // Çekçe
  'sum', // Norveççe ve genel kısaltma
  'yhteensä', // Fince
];

// Karşılaştırma öncesi normalize eder: baş/son boşlukları kırpar, küçük
// harfe çevirir ve bazı dillerde farklı biçimlerde yazılabilen tırnak
// işaretlerini (ör. İbranice gershayim) kaldırır.
String _dNoteNormalizeCalcWord(String s) {
  var t = s.trim().toLowerCase();
  t = t.replaceAll('"', '').replaceAll("'", '').replaceAll('״', '');
  return t;
}

bool _dNoteIsTotalKeyword(String raw) {
  final normalized = _dNoteNormalizeCalcWord(raw);
  if (normalized.isEmpty) return false;
  return _dNoteCalcTotalKeywords.any(
    (k) => _dNoteNormalizeCalcWord(k) == normalized,
  );
}

// Satırın TAMAMI (baştan sona) çıplak bir sayıysa (isteğe bağlı birimle,
// ör. "150", "150$" ya da "$150") eşleşir. Birim sembolü hem ÖNEK hem
// SONEK olarak kabul edilir (bkz. DÜZELTME notu, _dNoteTryLineAsListValue).
final RegExp _dNoteBareNumberLineRegex = RegExp(
  r'^(₺|\$|€|£|¥|₽|₹)?(-?[0-9]+(?:[.,][0-9]+)?)(₺|\$|€|£|¥|₽|₹)?$',
);

// Etiketli satır: "ekmek 50", "su: 30₺", "su: $30" gibi, sayıdan ÖNCE düz
// metin (etiket) bulunan satırlar. Etiket ile sayı arasında en az bir
// boşluk ya da ':' olmalı; sayı satırın SONUNDA bulunmalıdır, ama sayının
// hemen önünde/ardında bir birim sembolü (önek veya sonek) olabilir.
// Ayırıcıya '-' dahil edilmez; aksi halde "ekmek -50" gibi satırlarda
// eksi işareti ayırıcı sanılırdı.
final RegExp _dNoteLabeledNumberLineRegex = RegExp(
  r'^(.*?[^\s])[\s:：]+(₺|\$|€|£|¥|₽|₹)?(-?[0-9]+(?:[.,][0-9]+)?)(₺|\$|€|£|¥|₽|₹)?$',
);

// Bir metin parçasının "etiket" sayılabilmesi için en az bir harf içermeli,
// buna karşılık rakam ya da matematik/eşittir karakteri İÇERMEMELİDİR.
// Böylece "36 + 43" veya "2 4" gibi henüz hesaplanmamış ifade satırları
// yanlışlıkla "etiket + sayı" sanılıp toplamaya katılmaz.
bool _dNoteIsPlainLabel(String raw) {
  final label = raw.trim();
  if (label.isEmpty) return false;
  if (RegExp(r'''[0-9=+*/^%()'-]''').hasMatch(label)) return false;
  return RegExp(r'\p{L}', unicode: true).hasMatch(label);
}

// Satırın SONUNDA daha önce hesaplanmış bir "ifade=sonuç" var mı (ör.
// "1500$+200$=1700$" ya da "$1500+$200=$1700" satırındaki "=1700$" /
// "=$1700" kısmı) diye bakar. Birim sembolü hem önek hem sonek olabilir.
final RegExp _dNoteLineEndsWithCalcResultRegex = RegExp(
  r'=(₺|\$|€|£|¥|₽|₹)?(-?[0-9]+(?:[.,][0-9]+)?)(₺|\$|€|£|¥|₽|₹)?$',
);

// Bir liste satırının "toplam="a katkısını bulmaya çalışır: satır ya
// baştan sona çıplak bir sayıysa (bkz. [_dNoteBareNumberLineRegex]) ya da
// zaten hesaplanmış bir "ifade=sonuç" satırıysa (bu durumda yalnızca
// SONUÇ kısmı alınır, ifade tekrar hesaplanmaz) ya da "ekmek 50" gibi
// etiketli bir sayı satırıysa (bkz. [_dNoteLabeledNumberLineRegex] ve
// [_dNoteIsPlainLabel]) bir değer döner. Bunların hiçbiri değilse (boş
// satır, düz metin, henüz "=" ile hesaplanmamış bir ifade vb.) null döner — bu, yukarı doğru taramanın DURDUĞU noktadır.
// DÜZELTME: Birim sembolü sayının ÖNÜNDE ("$150") olduğunda da, ARDINDA
// ("150$") olduğunda da geçerli sayılsın diye üç regex de artık hem önek
// hem sonek grubunu ayrı ayrı yakalıyor. Bu yardımcı sınıf/fonksiyon, o
// iki gruptan (prefix, suffix) tek bir birim + konum bilgisi çıkarır.
// Aynı satırda HEM önek HEM sonek sembolü birden varsa (ör. "$150$" gibi
// anlamsız bir biçim) satır belirsiz sayılır ve null döner.
class _DNoteLineUnitInfo {
  final String? unit;
  final bool isPrefix;
  const _DNoteLineUnitInfo(this.unit, this.isPrefix);
}

_DNoteLineUnitInfo? _dNoteResolveLineUnit(String? prefix, String? suffix) {
  if (prefix != null && suffix != null) return null;
  if (prefix != null) return _DNoteLineUnitInfo(prefix, true);
  if (suffix != null) return _DNoteLineUnitInfo(suffix, false);
  return const _DNoteLineUnitInfo(null, false);
}

_CalcResult? _dNoteTryLineAsListValue(String line) {
  final trimmed = line.trim();
  if (trimmed.isEmpty) return null;
  final calcMatch = _dNoteLineEndsWithCalcResultRegex.firstMatch(trimmed);
  if (calcMatch != null) {
    final value = double.tryParse(calcMatch.group(2)!.replaceAll(',', '.'));
    if (value == null) return null;
    final resolved = _dNoteResolveLineUnit(
      calcMatch.group(1),
      calcMatch.group(3),
    );
    if (resolved == null) return null;
    return _CalcResult(value, resolved.unit, unitIsPrefix: resolved.isPrefix);
  }
  final bareMatch = _dNoteBareNumberLineRegex.firstMatch(trimmed);
  if (bareMatch != null) {
    final value = double.tryParse(bareMatch.group(2)!.replaceAll(',', '.'));
    if (value == null) return null;
    final resolved = _dNoteResolveLineUnit(
      bareMatch.group(1),
      bareMatch.group(3),
    );
    if (resolved == null) return null;
    return _CalcResult(value, resolved.unit, unitIsPrefix: resolved.isPrefix);
  }
  final labeledMatch = _dNoteLabeledNumberLineRegex.firstMatch(trimmed);
  if (labeledMatch != null && _dNoteIsPlainLabel(labeledMatch.group(1)!)) {
    final value = double.tryParse(labeledMatch.group(3)!.replaceAll(',', '.'));
    if (value == null) return null;
    final resolved = _dNoteResolveLineUnit(
      labeledMatch.group(2),
      labeledMatch.group(4),
    );
    if (resolved == null) return null;
    return _CalcResult(value, resolved.unit, unitIsPrefix: resolved.isPrefix);
  }
  return null;
}

// [lineStart] konumunda başlayan bir "toplam=" satırının HEMEN ÜSTÜNDEKİ
// ardışık liste satırlarını toplayıp sonucu (birimiyle birlikte) metin olarak
// döndürür; toplanacak hiçbir değer yoksa null döner.
//
// Bu yardımcı, hem "=" ilk yazıldığında (bkz. [_dNoteAutoSumAboveLines]) hem de
// listedeki bir değer sonradan değiştirildiğinde (bkz.
// [_dNoteMaybeLiveRecalculateTotalBelow]) AYNI mantığın kullanılabilmesi için
// ayrıştırıldı — iki yolun farklı sonuç üretmesi imkânsız olsun diye.
String? _dNoteComputeAboveSumText(String text, int lineStart) {
  final values = <_CalcResult>[];
  int aboveLineEnd = lineStart - 1;
  while (aboveLineEnd > 0) {
    final aboveLineStart = text.lastIndexOf('\n', aboveLineEnd - 1) + 1;
    // Boş satır (start == end) toplamayı durdurur. Bu kontrol aynı zamanda
    // notun ilk satırı boşken oluşabilecek geçersiz substring aralığını da
    // engeller.
    if (aboveLineStart >= aboveLineEnd) break;
    final aboveLine = text.substring(aboveLineStart, aboveLineEnd);
    final value = _dNoteTryLineAsListValue(aboveLine);
    if (value == null) break;
    values.add(value);
    if (aboveLineStart == 0) break;
    aboveLineEnd = aboveLineStart - 1;
  }
  if (values.isEmpty) return null;

  double total = 0;
  String? unit;
  // DÜZELTME: Konum (önek/sonek) artık tutarlılığı bozmuyor — yalnızca
  // SEMBOL (₺, $, ...) farklıysa unitConsistent false olur.
  var unitConsistent = true;
  // Sonuçtaki birimin önek mi sonek mi yazılacağını, birimi ilk taşıyan
  // (yani "Toplam="a en yakın) satırın biçimi belirler.
  bool resultUnitIsPrefix = false;
  for (final v in values) {
    total += v.value;
    if (v.unit != null) {
      if (unit == null) {
        unit = v.unit;
        resultUnitIsPrefix = v.unitIsPrefix;
      } else if (unit != v.unit) {
        unitConsistent = false;
      }
    }
  }
  final resultUnit = unitConsistent ? (unit ?? '') : '';
  return resultUnit.isEmpty
      ? _formatMathResult(total)
      : (resultUnitIsPrefix
            ? resultUnit + _formatMathResult(total)
            : _formatMathResult(total) + resultUnit);
}

// "<toplam kelimesi>=" satırının hemen ÜSTÜNDEKİ ardışık liste satırlarını
// toplar (bkz. [_dNoteTryLineAsListValue]). Yukarı doğru tarama, ilk
// "sayı satırı" OLMAYAN satırda (boş satır, düz metin, henüz hesaplanmamış
// bir ifade vb.) ya da notun başına ulaşınca durur; hiç değer bulunamazsa
// (ör. hemen üstteki satır boşsa) hiçbir şey yapmadan döner. Toplanan
// satırların hepsinde AYNI birim (₺, $, vb.) varsa sonuca o birim de
// eklenir; birimler karışıksa (ör. bir satır "$" bir satır "€") sonuç
// birimsiz, yalnızca sayı olarak yazılır.
void _dNoteAutoSumAboveLines(
  TextEditingController controller,
  String text,
  int cursor,
  int lineStart, {
  void Function(String newText)? onTextChanged,
  List<Map<String, dynamic>> Function()? getSpans,
  void Function(List<Map<String, dynamic>> newSpans)? onSpansChanged,
  int? resultColor,
}) {
  final resultText = _dNoteComputeAboveSumText(text, lineStart);
  if (resultText == null) return;

  final hasSpaceBeforeEquals = cursor >= 2 && text[cursor - 2] == ' ';
  final insertText = hasSpaceBeforeEquals ? ' $resultText' : resultText;
  final newText =
      text.substring(0, cursor) + insertText + text.substring(cursor);
  final newCursor = cursor + insertText.length;
  final resultNumberStart = newCursor - resultText.length;
  final resultNumberEnd = newCursor;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (controller.text != text) return;
    if (getSpans != null && onSpansChanged != null && resultColor != null) {
      var spans = RichTextSpans.shiftForInsert(
        getSpans(),
        cursor,
        insertText.length,
      );
      spans = RichTextSpans.setColor(
        spans,
        newText.length,
        resultNumberStart,
        resultNumberEnd,
        resultColor,
      );
      onSpansChanged(spans);
    }
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursor),
      composing: TextRange.empty,
    );
    _dNoteAutoCalcLastText[controller] = newText;
    onTextChanged?.call(newText);
    // Bu toplam satırı, daha aşağıdaki BAŞKA bir "toplam=" listesinin değeri
    // olabilir ("...=sonuç" biçimindeki satırlar liste değeri sayılır);
    // zinciri aşağı doğru güncelle.
    _dNoteMaybeLiveRecalculateTotalBelow(
      controller,
      newText,
      newCursor,
      onTextChanged: onTextChanged,
      getSpans: getSpans,
      onSpansChanged: onSpansChanged,
      resultColor: resultColor,
    );
  });
}


// Bir not metni alanında kullanıcı tam olarak satırın SONUNA "=" yazdığında
// çağrılır. O satırdaki "=" öncesi ifadeyi hesaplamayı dener; başarılıysa
// controller'ın metnine sonucu ekler ve imleci sonucun ardına taşır, ardından
// (varsa) [onTextChanged] callback'ini güncel metinle çağırır — böylece
// çağıran taraf kendi state'ini (ör. blocks[i]['text']) senkron tutabilir.
// İfade geçersizse (normal metin, örn. "Toplam=") hiçbir şey yapmadan döner.
void dNoteMaybeAutoCalculate(
  TextEditingController controller, {
  void Function(String newText)? onTextChanged,
  // Sonuç sayısını (ör. "=12" içindeki "12") vurgu renginde göstermek
  // isteyen çağıranlar için opsiyonel span desteği. Üçü de sağlanmadıkça
  // (getSpans + onSpansChanged + resultColor) span'lara hiç dokunulmaz —
  // eski davranış (sadece metin ekleme) aynen korunur.
  List<Map<String, dynamic>> Function()? getSpans,
  void Function(List<Map<String, dynamic>> newSpans)? onSpansChanged,
  int? resultColor,
}) {
  final text = controller.text;
  final previousText = _dNoteAutoCalcLastText[controller];
  // Bu çağrı nasıl sonuçlanırsa sonuçlansın, "son görülen metni" hemen
  // güncelle; böylece bir sonraki çağrı her zaman doğru referansla kıyaslar.
  _dNoteAutoCalcLastText[controller] = text;

  final selection = controller.selection;
  if (!selection.isValid || !selection.isCollapsed) return;
  final cursor = selection.end;
  if (cursor <= 0 || cursor > text.length) return;
  if (text[cursor - 1] != '=') {
    // Kullanıcı şu an TAM OLARAK "=" yazmadı — ama daha önce hesaplanmış
    // bir "ifade=sonuç" satırındaki İFADE kısmında bir sayıyı değiştirmiş
    // olabilir (ör. "100+%12=112" satırındaki "100"ü "150" yapmak).
    // Bu durumda sonucu da otomatik güncelle (bkz. aşağıdaki fonksiyon).
    final recalculated = _dNoteMaybeLiveRecalculate(
      controller,
      text,
      cursor,
      onTextChanged: onTextChanged,
      getSpans: getSpans,
      onSpansChanged: onSpansChanged,
      resultColor: resultColor,
    );
    // Satır içi bir "ifade=sonuç" güncellenmediyse (ör. kullanıcı listedeki
    // çıplak bir değeri değiştirdi: "100" -> "150"), bu değişiklik ALTTAKİ bir
    // "toplam=" satırını etkiliyor olabilir. Güncellendiyse zincirleme çağrı
    // zaten _dNoteMaybeLiveRecalculate'in içinden yapılır — burada ikinci kez
    // tetiklemek aynı kareye iki çakışan metin güncellemesi bindirirdi.
    if (!recalculated) {
      _dNoteMaybeLiveRecalculateTotalBelow(
        controller,
        text,
        cursor,
        onTextChanged: onTextChanged,
        getSpans: getSpans,
        onSpansChanged: onSpansChanged,
        resultColor: resultColor,
      );
    }
    return;
  }

  // ÖNEMLİ (silme sırasında sonucun geri gelmesini önler): "imleçten önceki
  // karakter '=' ve satır sonunda" koşulu, kullanıcı "=79" gibi bir sonucu
  // SİLERKEN de (rakamlar tek tek silinip sıra "="e geldiğinde) sağlanır.
  // Bu, gerçek bir yazma değil bir silme (metin KISALMASI) olduğu için,
  // metin bir önceki bilinen haline göre UZAMAMIŞSA hiçbir şey yapma.
  if (previousText != null && text.length <= previousText.length) return;

  // Yalnızca satırın sonunda ("=" işaretinden sonra o satırda başka
  // karakter yoksa) devreye gir; "=" metnin ortasına eklenmişse dokunma.
  final isEndOfLine = cursor == text.length || text[cursor] == '\n';
  if (!isEndOfLine) return;

  // "Toplam=" (ve dillere göre karşılıkları): satırın "=" öncesindeki
  // TÜM içeriği (baştan sona) bir "toplam" anahtar kelimesiyse, normal
  // matematik ifadesi aramak yerine ÜSTTEKİ ardışık liste satırlarını
  // toplama moduna geçilir (bkz. _dNoteAutoSumAboveLines).
  final lineStart = text.lastIndexOf('\n', cursor > 0 ? cursor - 1 : 0) + 1;
  final beforeEqualsOnLine = text.substring(lineStart, cursor - 1);
  if (_dNoteIsTotalKeyword(beforeEqualsOnLine)) {
    _dNoteAutoSumAboveLines(
      controller,
      text,
      cursor,
      lineStart,
      onTextChanged: onTextChanged,
      getSpans: getSpans,
      onSpansChanged: onSpansChanged,
      resultColor: resultColor,
    );
    return;
  }

  // "=" işaretinden geriye doğru, satırın neresinde olursa olsun geçerli
  // bir matematik ifadesi oluşturan en uzun kuyruğu bul. Böylece
  // "Toplam: 2+4=" gibi ifadeden önce düz metin bulunan satırlarda da
  // (yalnızca satırın en başından başlayan ifadelerde değil) yalnızca
  // "2+4" kısmı ifade olarak değerlendirilir. Satır sınırını aşmamak
  // için '\n' karakterinde her zaman durulur. Birim sembolleri (₺ $ € £
  // ¥ ₽ ₹) de ifadenin parçası sayılır ki "100$" gibi bir uç tarama
  // sırasında kesilmesin.
  bool isExprChar(String ch) =>
      ch != '\n' && RegExp(r"[0-9.,+\-*/^'()%\s₺$€£¥₽₹]").hasMatch(ch);
  int exprStart = cursor - 1;
  while (exprStart > 0 && isExprChar(text[exprStart - 1])) {
    exprStart--;
  }

  // ÖNEMLİ (aynı satırda ikinci bir hesabın çalışmamasını önler): Yukarıdaki
  // geriye tarama, aynı satırda daha önce hesaplanmış bir sonucu da (ör.
  // "36+43=79   36+12=" içindeki "79") ifadenin parçası sanıp içine alabilir.
  // O zaman bulunan "79   36+12" aslında aralarında işlem olmayan iki ayrı
  // sayı olduğundan GEÇERSİZ olur ve tüm hesap sessizce iptal edilirdi. Bunun
  // yerine tam ifade geçersizse pes etmek yerine, soldan tek tek daraltarak
  // (en uzundan en kısaya) geçerli bir alt ifade bulana kadar tekrar deniyoruz;
  // böylece önceki sonucun hemen ardından aynı satıra yeni bir hesap daha
  // yazılabiliyor.
  _CalcResult? calc;
  for (int start = exprStart; start < cursor - 1; start++) {
    final candidate = text.substring(start, cursor - 1);
    final value = _MathExpressionEvaluator.tryEvaluateWithUnit(candidate);
    if (value != null) {
      calc = value;
      break;
    }
  }
  if (calc == null) return;

  // Sonuç metnine, ifadede bulunan birim sembolü (varsa) aynı konumda
  // (ifadede sayının önündeyse önde, sonundaysa sonda) eklenir:
  // "100$+%5=" -> sonuç "105$"; "$100+%5=" -> sonuç "$105".
  final formattedNumber = _formatMathResult(calc.value);
  final resultText = calc.unit == null
      ? formattedNumber
      : (calc.unitIsPrefix
          ? '${calc.unit}$formattedNumber'
          : '$formattedNumber${calc.unit}');
  // Kullanıcı ifadeyle "=" arasına boşluk bırakmışsa (ör. "100 + 12 ="),
  // sonuç da bir boşlukla eklenir ("100 + 12 = 112"); boşluk yoksa eskisi
  // gibi doğrudan "=" işaretinin ardına eklenir (ör. "2+4=6").
  final hasSpaceBeforeEquals = cursor >= 2 && text[cursor - 2] == ' ';
  final insertText = hasSpaceBeforeEquals ? ' $resultText' : resultText;
  final newText =
      text.substring(0, cursor) + insertText + text.substring(cursor);
  final newCursor = cursor + insertText.length;
  // Eklenen sonuç metninde yalnızca SAYI (+ varsa birim) kısmının (baştaki
  // isteğe bağlı boşluk HARİÇ) kapladığı aralık — vurgu rengi sadece bu
  // aralığa uygulanacak, boşluğa değil.
  final resultNumberStart = newCursor - resultText.length;
  final resultNumberEnd = newCursor;

  // ÖNEMLİ: controller.value'yu bu onChanged geri çağrısı içinde SENKRON
  // olarak değiştirmek, platform klavyesinin (özellikle Gboard) o an
  // sürmekte olan "composing" (oluşum) bölgesiyle Flutter tarafının
  // senkronunu bozabiliyor: bu yüzden sonuç eklendikten sonra yazılan bir
  // sonraki karakter, IME tarafından hâlâ eski composing bölgesinin
  // devamıymış gibi algılanıp altı çizili gösteriliyordu. Bunu önlemek
  // için asıl metin güncellemesini mevcut kare (frame) tamamlandıktan
  // SONRA uyguluyoruz ve composing aralığını açıkça boşaltıyoruz.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Callback tetiklenene kadar kullanıcı yazmaya devam ettiyse (metin
    // değiştiyse) artık geçersiz bir hesaplamayı uygulama.
    if (controller.text != text) return;
    // ÖNEMLİ: span güncellemesi, controller.value ataması yapılmadan
    // ÖNCE tamamlanmalı — controller.value ataması (aşağıda) senkron
    // olarak notifyListeners() tetikleyip TextField'ı hemen yeniden
    // çizdirir; span'lar o ana kadar güncellenmemişse ilk çizimde sonuç
    // rengi eksik görünür ve ancak BİR SONRAKİ rebuild'de düzelir.
    if (getSpans != null && onSpansChanged != null && resultColor != null) {
      var spans = RichTextSpans.shiftForInsert(
        getSpans(),
        cursor,
        insertText.length,
      );
      spans = RichTextSpans.setColor(
        spans,
        newText.length,
        resultNumberStart,
        resultNumberEnd,
        resultColor,
      );
      onSpansChanged(spans);
    }
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursor),
      composing: TextRange.empty,
    );
    // Programatik olarak eklediğimiz bu metni de "son görülen metin" olarak
    // işaretle; aksi halde bir sonraki onChanged (kullanıcının ekli sonucu
    // silmeye başlaması) bunu hâlâ eski (sonuçsuz) "text" ile kıyaslar ve
    // yanlışlıkla "uzama" sanabilir.
    _dNoteAutoCalcLastText[controller] = newText;
    onTextChanged?.call(newText);
    // Yeni hesaplanan bu satır, altındaki bir "toplam=" listesinin parçası
    // olabilir; o toplamı da güncel tut.
    _dNoteMaybeLiveRecalculateTotalBelow(
      controller,
      newText,
      newCursor,
      onTextChanged: onTextChanged,
      getSpans: getSpans,
      onSpansChanged: onSpansChanged,
      resultColor: resultColor,
    );
  });
}

// Kullanıcı, daha önce dNoteMaybeAutoCalculate tarafından hesaplanmış bir
// "ifade=sonuç" satırındaki İFADE kısmında (yani "=" işaretinden ÖNCESİNDE)
// herhangi bir değişiklik yaptığında (bir sayıyı değiştirme, silme, ekleme)
// çağrılır: ifadeyi imleç konumundan bağımsız olarak yeniden hesaplar ve
// "=" işaretinden sonraki sonucu günceller. Böylece "100+%12=112" satırında
// kullanıcı "100"ü "150" yaptığında sonuç yeniden "=" yazmasına gerek
// kalmadan otomatik olarak "162" olur. Sonuçta bir birim sembolü varsa
// (ör. "100$+%5=105$") yeniden hesaplama sonrasında da korunur.
//
// Kullanıcı doğrudan "=" işaretinden SONRAKİ (yani sonuç) kısmı elle
// düzenliyorsa buraya hiç dokunulmaz — o zaman kullanıcı sonucu bilerek
// kendi eliyle değiştiriyor sayılır.
//
// NOT: Bir satırda birden fazla "ifade=sonuç" art arda varsa (ör.
// "36+43=79   36+12=91"), yalnızca satırın EN SONUNDAKİ "=sonuç" canlı
// olarak güncellenir; dNoteMaybeAutoCalculate'in yeni bir hesabı da hep
// satır sonuna eklemesiyle tutarlı bir sınırlama.
bool _dNoteMaybeLiveRecalculate(
  TextEditingController controller,
  String text,
  int cursor, {
  void Function(String newText)? onTextChanged,
  List<Map<String, dynamic>> Function()? getSpans,
  void Function(List<Map<String, dynamic>> newSpans)? onSpansChanged,
  int? resultColor,
}) {
  // Düzenlenen satırın metin içindeki sınırlarını bul.
  final lineStart = text.lastIndexOf('\n', cursor > 0 ? cursor - 1 : 0) + 1;
  final nextNewline = text.indexOf('\n', cursor);
  final lineEnd = nextNewline == -1 ? text.length : nextNewline;
  if (lineStart > lineEnd || lineEnd > text.length) return false;
  final line = text.substring(lineStart, lineEnd);
  final cursorInLine = cursor - lineStart;

  // Bir satirda BIRDEN FAZLA tamamlanmis hesap olabilir (ust uste eklenmis
  // "ifade=sonuc" bloklari). Bu yuzden yalnizca satirin EN SONUNDAKI sonucu
  // degil, imlecin O AN icinde bulundugu (yani duzenlenmekte olan) hesabin
  // KENDI "=sonuc" kismini bulmamiz gerekir; aksi halde ilk/orta bir hesabin
  // ifadesi degistirildiginde islem yanlislikla EN SONDAKI (ilgisiz) hesaba
  // uygulanip hicbir sey degismis gibi gorunuyordu (o zaten guncel oldugu
  // icin). Bir eslesme yalnizca satir sonunda ya da hemen ardindan bosluk
  // geldiginde GECERLI bir "tamamlanmis sonuc" sayilir - aksi halde iki
  // hesabin rakamlari birbirine karisabilir (ayni mantik dNoteMaybeAutoCalculate
  // icin de gecerlidir). Sondaki ("100$" -> "$" sonda) ya da bastaki
  // ("$100" -> "$" basta) istege bagli birim sembolu de eslesmeye dahil
  // edilir (1. grup: bosluk var mi, 2. grup: varsa bastaki birim, 3. grup:
  // sayinin kendisi, 4. grup: varsa sondaki birim - ikisi ayni anda dolu
  // olamaz, sadece biri kullanilmis olur).
  final resultPattern = RegExp(
    r'=( ?)(₺|\$|€|£|¥|₽|₹)?(-?[0-9]+(?:[.,][0-9]+)?)(₺|\$|€|£|¥|₽|₹)?',
  );
  // Yalnizca satir sonunda ya da hemen ardindan bosluk gelen eslesmeler
  // gercekten "tamamlanmis" (bagimsiz) bir sonuc sayilir.
  final completedResults = resultPattern.allMatches(line).where((m) {
    final end = m.end;
    return end == line.length || line[end] == ' ';
  }).toList();
  if (completedResults.isEmpty) return false;

  // Bu satirdaki hesaplardan imlecin O AN icinde bulundugu (yani su anda
  // duzenlenmekte olan ifadeye ait) ilk "=sonuc"u sec: imlec bir hesabin
  // KENDI sonuc rakamlarinin icindeyse (yani kullanici sonucu elle
  // duzenliyorsa) hicbir sey yapma.
  RegExpMatch? resultMatch;
  for (final m in completedResults) {
    if (cursorInLine <= m.start) {
      resultMatch = m;
      break;
    }
    if (cursorInLine <= m.end) {
      return false;
    }
  }
  if (resultMatch == null) return false;
  final equalsIndexInLine = resultMatch.start;
  final spaceBeforeResult = resultMatch.group(1)!;

  // Değişiklik "=" işaretinden SONRA (sonuç kısmında) olduysa dokunma —
  // yalnızca ifade kısmındaki değişiklikler canlı yeniden hesaplamayı
  // tetikler.
  if (cursorInLine > equalsIndexInLine) return false;

  final oldResultText = (resultMatch.group(2) ?? '') +
      resultMatch.group(3)! +
      (resultMatch.group(4) ?? '');
  final beforeEquals = line.substring(0, equalsIndexInLine);

  // dNoteMaybeAutoCalculate ile BİREBİR AYNI mantık: "=" işaretinden geriye
  // doğru geçerli en uzun matematik ifadesini bul (öncesinde "Toplam: " gibi
  // düz metin olabilir), ardından soldan daraltarak (aynı satırda önceki
  // bir hesabın sonucunu ifadeye dahil etmemek için) geçerli bir alt ifade
  // arar. Birim sembolleri de ifadenin parçası sayılır.
  bool isExprChar(String ch) =>
      RegExp(r"[0-9.,+\-*/^'()%\s₺$€£¥₽₹]").hasMatch(ch);
  int exprStart = beforeEquals.length;
  while (exprStart > 0 && isExprChar(beforeEquals[exprStart - 1])) {
    exprStart--;
  }
  _CalcResult? calc;
  for (int start = exprStart; start < beforeEquals.length; start++) {
    final candidate = beforeEquals.substring(start);
    final value = _MathExpressionEvaluator.tryEvaluateWithUnit(candidate);
    if (value != null) {
      calc = value;
      break;
    }
  }
  if (calc == null) return false;

  final newFormattedNumber = _formatMathResult(calc.value);
  final newResultText = calc.unit == null
      ? newFormattedNumber
      : (calc.unitIsPrefix
          ? '${calc.unit}$newFormattedNumber'
          : '$newFormattedNumber${calc.unit}');
  // Sonuç zaten güncel/aynıysa (ör. bu çağrı, az önce BİZİM yaptığımız
  // programatik güncellemenin tetiklediği yankı onChanged'i ise) hiçbir
  // şey yapma — sonsuz döngüye girmemesi bunu garantiler.
  if (newResultText == oldResultText) return false;

  final resultStartInText =
      lineStart + equalsIndexInLine + 1 + spaceBeforeResult.length;
  final resultEndInText = resultStartInText + oldResultText.length;
  final newText =
      text.substring(0, resultStartInText) +
      newResultText +
      text.substring(resultEndInText);

  // İmleç "=" işaretinden ÖNCE olduğundan (yukarıdaki kontrol) ve yalnızca
  // '='den SONRAKİ kısım değiştiğinden, imlecin mutlak konumu (cursor)
  // AYNEN korunur — dNoteMaybeAutoCalculate'in "yeni sonucun
  // ardına taşı" mantığına burada gerek yok.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (controller.text != text) return;
    // ÖNEMLİ: yukarıdaki insert fonksiyonundaki AYNI sıralama nedeniyle
    // (bkz. dNoteMaybeAutoCalculate içindeki açıklama), span güncellemesi
    // controller.value atamasından ÖNCE yapılır.
    if (getSpans != null && onSpansChanged != null && resultColor != null) {
      // Eski sonuç aralığını kaldırıp yeni (muhtemelen farklı uzunlukta)
      // sonucu aynı noktaya ekle — bu, aradaki uzunluk farkını da diğer
      // span'lara doğru şekilde yansıtır.
      var spans = RichTextSpans.shiftForDelete(
        getSpans(),
        resultStartInText,
        resultEndInText,
      );
      spans = RichTextSpans.shiftForInsert(
        spans,
        resultStartInText,
        newResultText.length,
      );
      spans = RichTextSpans.setColor(
        spans,
        newText.length,
        resultStartInText,
        resultStartInText + newResultText.length,
        resultColor,
      );
      onSpansChanged(spans);
    }
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursor),
      composing: TextRange.empty,
    );
    _dNoteAutoCalcLastText[controller] = newText;
    onTextChanged?.call(newText);
    // Bu satırın sonucu değiştiyse, altındaki bir "toplam=" satırı da artık
    // bayattır; zinciri aşağı doğru güncelle.
    _dNoteMaybeLiveRecalculateTotalBelow(
      controller,
      newText,
      cursor,
      onTextChanged: onTextChanged,
      getSpans: getSpans,
      onSpansChanged: onSpansChanged,
      resultColor: resultColor,
    );
  });
  return true;
}

// Bir "toplam=<sonuç>" satırının TAMAMINI yakalar: 1. grup "=" öncesi (toplam
// kelimesi), 2. grup "=" ile sonuç arasındaki isteğe bağlı boşluk, 3./5. grup
// isteğe bağlı birim (önek ya da sonek), 4. grup sonucun kendisi.
final RegExp _dNoteTotalLineRegex = RegExp(
  r'^([^=\n]*)=( ?)(₺|\$|€|£|¥|₽|₹)?(-?[0-9]+(?:[.,][0-9]+)?)(₺|\$|€|£|¥|₽|₹)?$',
);

// Kullanıcı, daha önce "toplam=" ile hesaplanmış bir listenin DEĞER
// satırlarından birini değiştirdiğinde (ör. "100"ü "150" yapmak, bir satırı
// silmek, araya yeni bir değer eklemek) çağrılır: imlecin bulunduğu satırın
// ALTINDA, aradaki satırlar kesintisiz liste değeri olmak kaydıyla bir
// "toplam=<sonuç>" satırı varsa, o satırın sonucunu yeniden hesaplar.
//
// Böylece satır içi hesaplardaki canlı güncelleme davranışı (bkz.
// [_dNoteMaybeLiveRecalculate]) alt alta listelerde de geçerli olur:
//   ekmek 50
//   su 30
//   toplam=80
// satırlarında "50" -> "70" yazıldığı anda toplam kendiliğinden 100 olur.
//
// Aşağı doğru tarama, liste değeri OLMAYAN ilk satırda durur (bkz.
// [_dNoteTryLineAsListValue]); yani imlecin bulunduğu satır o toplamın
// listesine ait değilse hiçbir şey yapılmaz. İmlecin KENDİ satırı bu kontrole
// dahil değildir: kullanıcı bir değeri silip satırı boşaltmış olabilir ve
// toplamın bu durumda da (artık o satırı saymayarak) güncellenmesi gerekir.
//
// Sonucu değiştirdiyse true döner.
bool _dNoteMaybeLiveRecalculateTotalBelow(
  TextEditingController controller,
  String text,
  int cursor, {
  void Function(String newText)? onTextChanged,
  List<Map<String, dynamic>> Function()? getSpans,
  void Function(List<Map<String, dynamic>> newSpans)? onSpansChanged,
  int? resultColor,
}) {
  if (cursor < 0 || cursor > text.length) return false;
  // İmlecin bulunduğu satırın altında hiç satır yoksa yapacak bir şey yok.
  final nextNewline = text.indexOf('\n', cursor);
  if (nextNewline == -1) return false;

  int scanStart = nextNewline + 1;
  int? totalLineStart;
  RegExpMatch? totalMatch;
  while (scanStart <= text.length) {
    final nl = text.indexOf('\n', scanStart);
    final lineEnd = nl == -1 ? text.length : nl;
    final line = text.substring(scanStart, lineEnd);
    final match = _dNoteTotalLineRegex.firstMatch(line);
    if (match != null && _dNoteIsTotalKeyword(match.group(1)!)) {
      totalLineStart = scanStart;
      totalMatch = match;
      break;
    }
    // Toplam satırına ulaşmadan liste dışı bir satıra rastlandıysa, yapılan
    // değişiklik bu toplamı ilgilendirmiyor demektir.
    if (_dNoteTryLineAsListValue(line) == null) return false;
    if (nl == -1) return false;
    scanStart = nl + 1;
  }
  if (totalMatch == null || totalLineStart == null) return false;

  final newResultText = _dNoteComputeAboveSumText(text, totalLineStart);
  // Toplam satırının üstünde artık hiç değer kalmadıysa (ör. kullanıcı tüm
  // satırları sildi) mevcut sonuca dokunmuyoruz; silmek, kullanıcının elle
  // yazmış olabileceği bir sayıyı da yok edebilirdi.
  if (newResultText == null) return false;

  final spaceBeforeResult = totalMatch.group(2)!;
  final oldResultText =
      (totalMatch.group(3) ?? '') +
      totalMatch.group(4)! +
      (totalMatch.group(5) ?? '');
  // Sonuç zaten güncelse (ya da bu çağrı, az önce bizim yaptığımız programatik
  // güncellemenin yankısıysa) hiçbir şey yapma — sonsuz döngüyü bu önler.
  if (newResultText == oldResultText) return false;

  final resultStartInText =
      totalLineStart +
      totalMatch.group(1)!.length +
      1 +
      spaceBeforeResult.length;
  final resultEndInText = resultStartInText + oldResultText.length;
  final newText =
      text.substring(0, resultStartInText) +
      newResultText +
      text.substring(resultEndInText);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (controller.text != text) return;
    // ÖNEMLİ: span güncellemesi controller.value atamasından ÖNCE yapılır
    // (gerekçe için bkz. dNoteMaybeAutoCalculate içindeki açıklama).
    if (getSpans != null && onSpansChanged != null && resultColor != null) {
      var spans = RichTextSpans.shiftForDelete(
        getSpans(),
        resultStartInText,
        resultEndInText,
      );
      spans = RichTextSpans.shiftForInsert(
        spans,
        resultStartInText,
        newResultText.length,
      );
      spans = RichTextSpans.setColor(
        spans,
        newText.length,
        resultStartInText,
        resultStartInText + newResultText.length,
        resultColor,
      );
      onSpansChanged(spans);
    }
    // Değişiklik her zaman imlecin ALTINDAKİ bir satırda olduğu için imleç
    // konumu aynen korunur; kullanıcının yazma akışı bölünmez.
    final selection = controller.selection;
    var keepCursor = (selection.isValid && selection.isCollapsed)
        ? selection.end
        : cursor;
    if (keepCursor < 0) keepCursor = 0;
    if (keepCursor > newText.length) keepCursor = newText.length;
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: keepCursor),
      composing: TextRange.empty,
    );
    _dNoteAutoCalcLastText[controller] = newText;
    onTextChanged?.call(newText);
    // Zincirleme: bu toplam satırı ("...=sonuç" biçiminde olduğu için) daha
    // aşağıdaki bir başka toplamın değeri olabilir. Her adım kesin olarak
    // AŞAĞI doğru ilerlediğinden özyineleme sonludur.
    _dNoteMaybeLiveRecalculateTotalBelow(
      controller,
      newText,
      resultStartInText,
      onTextChanged: onTextChanged,
      getSpans: getSpans,
      onSpansChanged: onSpansChanged,
      resultColor: resultColor,
    );
  });
  return true;
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

// Not düzenleyicinin üst çubuğundaki (geri, geri al/ileri al, menü) ikon ve
// yazı rengi: koyu temada saf beyaz yerine beyaza yakın bir gri, açık
// temada saf siyah yerine siyaha yakın bir gri kullanılır. Böylece üst bar
// göz alıcı tam kontrast yerine daha yumuşak bir görünüme sahip olur.
Color dNoteEditorAppBarColor(BuildContext context) =>
    dNoteIsDark(context) ? const Color(0xFFE0E0E0) : const Color(0xFF3A3A3A);

// Not listesi ekranının üst çubuğundaki (AppBar) ikon ve başlık rengi.
// dNoteEditorAppBarColor ile aynı mantık (koyu temada beyaza yakın,
// açık temada siyaha yakın nötr gri) ama biraz daha yumuşatılmış: koyu
// temada biraz daha koyu, açık temada biraz daha açık — sadece bu ekranın
// üst çubuğuna özgü, düzenleyici ekranını etkilemez.
Color dNoteListAppBarColor(BuildContext context) =>
    dNoteIsDark(context) ? const Color(0xFFCFCFCF) : const Color(0xFF4A4A4A);

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
// Not düzenleyicisi açıkken, alttaki NoteListScreen bir sebeple yeniden
// build edilirse (ör. bir setState tetiklenirse), o build içindeki
// SystemChrome çağrısının düzenleyicinin ayarladığı gezinme çubuğu rengini
// (açık temada #EDEDED) ezmesini önlemek için kullanılan bayrak. Not
// düzenleyicisi açılırken true, kapanırken false yapılır (bkz.
// note_list_note_dialog_mixin.dart).
final ValueNotifier<bool> dNoteNoteEditorOpen = ValueNotifier<bool>(false);

SystemUiOverlayStyle dNoteSystemBarsStyle(
  BuildContext context, {
  Color? statusBarColor,
  Brightness? statusBarIconBrightnessOverride,
  Color? navigationBarColor,
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
    systemNavigationBarColor: navigationBarColor ??
        (isDark
            ? const Color(0xFF121212)
            : const Color(0xFFF5F5F5)),
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
        // Vurgu rengi (Ayarlar > Tema > Vurgu Rengi) değiştiğinde de temayı
        // anında yeniden kurar. Taban temalar (_dNoteLightTheme /
        // _dNoteDarkTheme) sabit kalır; sadece primaryColor bu renkle
        // ezilir — böylece AppBar başlıkları, switch'ler, butonlar vb.
        // tüm uygulamada aynı anda güncellenir.
        return ValueListenableBuilder<Color>(
          valueListenable: appAccentColor,
          builder: (context, accentColor, _) {
            // Dil tercihi (Sistem/Türkçe/English) — Ayarlar ekranında elle
            // seçilir ve appLanguage.value üzerinden anında uygulanır.
            return ValueListenableBuilder<String>(
              valueListenable: appLanguage,
              builder: (context, lang, _) {
                return MaterialApp(
                  navigatorKey: navigatorKey,
                  title: 'Layout',
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('tr', 'TR'),
                    Locale('en', 'US'),
                    Locale('da', 'DK'),
                    Locale('de', 'DE'),
                    Locale('fr', 'FR'),
                    Locale('it', 'IT'),
                    Locale('es', 'ES'),
                    Locale('pt', 'PT'),
                    Locale('ru', 'RU'),
                    Locale('ja', 'JP'),
                    Locale('zh', 'CN'),
                    Locale('ko', 'KR'),
                    Locale('hi', 'IN'),
                    Locale('id', 'ID'),
                    Locale('vi', 'VN'),
                    Locale('th', 'TH'),
                    Locale('pl', 'PL'),
                    Locale('nl', 'NL'),
                    Locale('sv', 'SE'),
                    Locale('ar', 'SA'),
                    Locale('he', 'IL'),
                    Locale('uk', 'UA'),
                    Locale('ro', 'RO'),
                    Locale('cs', 'CZ'),
                    Locale('no', 'NO'),
                    Locale('fi', 'FI'),
                  ],
                  // 'system' ise locale: null verilir ve aşağıdaki
                  // localeResolutionCallback devreye girer: cihaz dili
                  // supportedLocales içinde varsa o dil seçilir, yoksa
                  // (desteklenmeyen bir dilse) İngilizce'ye düşülür.
                  localeResolutionCallback: (deviceLocale, supportedLocales) {
                    if (deviceLocale != null) {
                      for (final supported in supportedLocales) {
                        if (supported.languageCode ==
                            deviceLocale.languageCode) {
                          return supported;
                        }
                      }
                    }
                    return const Locale('en', 'US');
                  },
                  locale: lang == 'en'
                      ? const Locale('en', 'US')
                      : lang == 'tr'
                          ? const Locale('tr', 'TR')
                          : lang == 'de'
                              ? const Locale('de', 'DE')
                              : lang == 'fr'
                                  ? const Locale('fr', 'FR')
                                  : lang == 'it'
                                      ? const Locale('it', 'IT')
                                      : lang == 'es'
                                          ? const Locale('es', 'ES')
                                          : lang == 'pt'
                                              ? const Locale('pt', 'PT')
                                              : lang == 'ru'
                                                  ? const Locale('ru', 'RU')
                                                  : lang == 'ja'
                                                      ? const Locale('ja', 'JP')
                                                      : lang == 'zh'
                                                          ? const Locale('zh', 'CN')
                                                          : lang == 'ko'
                                                              ? const Locale('ko', 'KR')
                                                              : lang == 'hi'
                                                                  ? const Locale('hi', 'IN')
                                                                  : lang == 'id'
                                                                      ? const Locale('id', 'ID')
                                                                      : lang == 'vi'
                                                                          ? const Locale('vi', 'VN')
                                                                          : lang == 'th'
                                                                              ? const Locale('th', 'TH')
                                                                              : lang == 'pl'
                                                                                  ? const Locale('pl', 'PL')
                                                                                  : lang == 'nl'
                                                                                      ? const Locale('nl', 'NL')
                                                                                      : lang == 'sv'
                                                                                          ? const Locale('sv', 'SE')
                                                                                          : lang == 'ar'
                                                                                              ? const Locale('ar', 'SA')
                                                                                              : lang == 'he'
                                                                                                  ? const Locale('he', 'IL')
                                                                                              : lang == 'uk'
                                                                                                  ? const Locale('uk', 'UA')
                                                                                              : lang == 'ro'
                                                                                                  ? const Locale('ro', 'RO')
                                                                                              : lang == 'cs'
                                                                                                  ? const Locale('cs', 'CZ')
                                                                                              : lang == 'da'
                                                                                                  ? const Locale('da', 'DK')
                                                                                              : lang == 'no'
                                                                                                  ? const Locale('no', 'NO')
                                                                                              : lang == 'fi'
                                                                                                  ? const Locale('fi', 'FI')
                                                                                                  : null,
                  themeMode: mode,
                  theme: _dNoteLightTheme.copyWith(primaryColor: accentColor),
                  darkTheme: _dNoteDarkTheme.copyWith(primaryColor: accentColor),
                  home: const NoteListScreen(),
                );
              },
            );
          },
        );
      },
    );
  }
}

