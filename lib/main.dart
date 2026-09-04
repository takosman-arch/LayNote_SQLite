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
// Üs (kuvvet) işareti için hem "^" hem de "'" kabul edilir; bazı
// klavyelerde "^" yazmak zahmetli olduğundan kullanıcı tırnak işaretiyle
// de (ör. "2'2") üs alabilir.
//
// Not: Bu yalnızca sözdizimsel olarak geçerli bir matematik ifadesiyse
// devreye girer (yalnızca rakam, boşluk, ondalık ayırıcı ve + - * / ^ '
// ( ) karakterleri). Harf içeren normal cümlelerde ("Toplam=" gibi) veya
// "=" satırın ortasına eklendiğinde hiçbir şey yapmaz; kullanıcının
// yazdığı "=" olduğu gibi kalır.

class _MathExprSyntaxError implements Exception {}

class _MathExpressionEvaluator {
  final String _src;
  int _pos = 0;
  _MathExpressionEvaluator._(this._src);

  /// [raw] geçerli bir matematik ifadesiyse sonucu döndürür; değilse
  /// (harf içeriyorsa, dengesiz parantez varsa, sıfıra bölme vb.) null
  /// döner — bu durumda çağıran taraf hiçbir şey yapmamalıdır.
  static double? tryEvaluate(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    // Sadece rakam / boşluk / ondalık ayırıcı (. veya ,) / dört işlem /
    // üs (^ veya ') / parantez içeriyorsa bir hesap ifadesi say.
    if (!RegExp(r"^[0-9\s.,+\-*/^'()]+$").hasMatch(trimmed)) return null;
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
      final rhs = _parseTerm();
      value = op == '+' ? value + rhs : value - rhs;
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
    if (_pos < _src.length && (_src[_pos] == '+' || _src[_pos] == '-')) {
      final op = _src[_pos];
      _pos++;
      final value = _parseUnary();
      return op == '-' ? -value : value;
    }
    return _parseAtom();
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

// Bir not metni alanında kullanıcı tam olarak satırın SONUNA "=" yazdığında
// çağrılır. O satırdaki "=" öncesi ifadeyi hesaplamayı dener; başarılıysa
// controller'ın metnine sonucu ekler ve imleci sonucun ardına taşır, ardından
// (varsa) [onTextChanged] callback'ini güncel metinle çağırır — böylece
// çağıran taraf kendi state'ini (ör. blocks[i]['text']) senkron tutabilir.
// İfade geçersizse (normal metin, örn. "Toplam=") hiçbir şey yapmadan döner.
void dNoteMaybeAutoCalculate(
  TextEditingController controller, {
  void Function(String newText)? onTextChanged,
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
  if (text[cursor - 1] != '=') return;

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

  // "=" işaretinden geriye doğru, satırın neresinde olursa olsun geçerli
  // bir matematik ifadesi oluşturan en uzun kuyruğu bul. Böylece
  // "Toplam: 2+4=" gibi ifadeden önce düz metin bulunan satırlarda da
  // (yalnızca satırın en başından başlayan ifadelerde değil) yalnızca
  // "2+4" kısmı ifade olarak değerlendirilir. Satır sınırını aşmamak
  // için '\n' karakterinde her zaman durulur.
  bool isExprChar(String ch) =>
      ch != '\n' && RegExp(r"[0-9.,+\-*/^'()\s]").hasMatch(ch);
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
  double? result;
  for (int start = exprStart; start < cursor - 1; start++) {
    final candidate = text.substring(start, cursor - 1);
    final value = _MathExpressionEvaluator.tryEvaluate(candidate);
    if (value != null) {
      result = value;
      break;
    }
  }
  if (result == null) return;

  final resultText = _formatMathResult(result);
  // Kullanıcı isteği: "=" ile sonuç arasına boşluk konmasın, sonuç
  // doğrudan "=" işaretinin ardına eklensin (ör. "2+4=6").
  final newText =
      text.substring(0, cursor) + resultText + text.substring(cursor);
  final newCursor = cursor + resultText.length;

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
  });
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

