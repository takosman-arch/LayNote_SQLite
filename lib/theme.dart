part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// TEMA (Açık / Koyu / Sistem)
// Uygulama genelinde tema modu bu global ValueNotifier üzerinden yönetilir.
// Ayarlar ekranındaki seçim değiştiğinde appThemeMode.value güncellenir;
// bunu dinleyen DNoteApp, MaterialApp'i otomatik olarak yeniden kurar.
// ════════════════════════════════════════════════════════════════════════
final ValueNotifier<ThemeMode> appThemeMode = ValueNotifier<ThemeMode>(
  ThemeMode.dark,
);

ThemeMode themeModeFromSettingValue(String? value) {
  switch (value) {
    case 'light':
      return ThemeMode.light;
    case 'system':
      return ThemeMode.system;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.dark; // ayar hiç kaydedilmemişse eski davranış korunur
  }
}

// ════════════════════════════════════════════════════════════════════════
// WIDGET YAPILANDIRMA EKRANI İÇİN TEMA BİLGİSİ SENKRONİZASYONU
// appThemeMode SADECE DBHelper (SQLite) üzerinden saklanır; native tarafın
// (NoteWidgetConfigActivity.kt, "not seç" ekranı) SQLite'a erişimi yok,
// yalnızca HomeWidgetPreferences (SharedPreferences) dosyasını okuyabiliyor.
// Widget eklerken açılan not seçim ekranının uygulamanın Açık/Koyu tema
// tercihiyle tutarlı görünebilmesi için, geçerli (efektif) parlaklığı
// burada "is_dark_theme" anahtarıyla o depoya da yazıyoruz. Çağrı yerleri:
// main() (açılışta bir kez) ve appThemeMode üzerine eklenen dinleyici
// (tema Ayarlar'dan değiştirildiğinde) — bkz. main.dart.
//
// 'system' modunda geçerli parlaklık, context'siz olarak
// PlatformDispatcher üzerinden okunur (bu noktada bir widget ağacı henüz
// kurulmamış/kapalı olabilir, context gerektiren MediaQuery kullanılamaz).
// NOT: 'system' modundayken uygulama arka plandayken sistem teması
// değişirse (ör. gece yarısı otomatik koyu tema), bu değer uygulamanın
// bir sonraki açılışına/tema değişikliğine kadar güncellenmez; widget
// ekleme akışı zaten uygulamayı kısaca öne aldığından bu pratikte gözle
// görülür bir sorun yaratmaz.
bool dNoteResolveEffectiveDark(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.dark:
      return true;
    case ThemeMode.light:
      return false;
    case ThemeMode.system:
      return ui.PlatformDispatcher.instance.platformBrightness ==
          Brightness.dark;
  }
}

// Tema moduna göre varsayılan vurgu rengini döndürür: koyu temada Amber,
// açık temada Blue. İlk kurulumda (hiç kayıtlı vurgu rengi yokken) ve
// kullanıcı Ayarlar'dan temayı elle değiştirdiğinde kullanılır. Kullanıcı
// daha sonra Vurgu Rengi seçiciden kendi rengini seçerse, o seçim
// appAccentColor/DB'ye yazılır ve bu varsayılan bir daha devreye girmez
// (yalnızca tema değişimlerinde tekrar tetiklenir).
Color dNoteDefaultAccentColorForThemeMode(ThemeMode mode) {
  return dNoteResolveEffectiveDark(mode) ? Colors.amber : Colors.blue;
}

Future<void> dNoteSyncThemeToWidgetStorage() async {
  try {
    final isDark = dNoteResolveEffectiveDark(appThemeMode.value);
    await HomeWidget.saveWidgetData<bool>('is_dark_theme', isDark);
  } catch (_) {
    // Widget tarafı (Aşama 2) henüz kurulmamışsa veya HomeWidget çağrısı
    // başka bir nedenle başarısız olursa sessizce yutulur; syncFromNotes
    // ve syncAppearanceSettings'teki aynı davranışla tutarlıdır.
  }
}

String themeModeToSettingValue(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return 'light';
    case ThemeMode.system:
      return 'system';
    case ThemeMode.dark:
      return 'dark';
  }
}

// ════════════════════════════════════════════════════════════════════════
// DİL TERCİHİ (Ayarlar > Dil: Sistem / Türkçe / English)
// Değerleri 'system' | 'tr' | 'en'. Varsayılan 'system' — cihaz dili
// desteklenen bir dilse onu, değilse main.dart'taki AppLocalizations
// fallback'ini (tr) kullanır. Ayarlar ekranındaki seçim değiştiğinde
// appLanguage.value güncellenir; bunu dinleyen DNoteApp, MaterialApp'in
// locale: parametresini otomatik olarak yeniden kurar. Aynı ayar,
// arka planda auto_backup_service.dart -> _resolveL10n() tarafından da
// (DBHelper üzerinden) okunur; böylece ön plan ve arka plan hep aynı
// dili kullanır.
// ════════════════════════════════════════════════════════════════════════
final ValueNotifier<String> appLanguage = ValueNotifier<String>('system');

// ════════════════════════════════════════════════════════════════════════
// VURGU RENGİ (Ayarlar > Tema > Vurgu Rengi)
// Uygulama genelinde "primary" rengi (AppBar başlıkları, switch'ler,
// butonlar, seçili öğeler vb.) bu global ValueNotifier üzerinden yönetilir.
// Ayarlar ekranındaki seçim değiştiğinde appAccentColor.value güncellenir;
// bunu dinleyen DNoteApp, MaterialApp'in temasını otomatik olarak yeniden
// kurar. Varsayılan değer, uygulamanın önceki sabit rengiyle (Colors.amber)
// birebir aynıdır — böylece hiç ayar kaydedilmemiş kullanıcılarda görünüm
// değişmez.
// ════════════════════════════════════════════════════════════════════════
final ValueNotifier<Color> appAccentColor = ValueNotifier<Color>(
  Colors.amber,
);

// DB'de rengi Color.toARGB32() sonucunun String'e çevrilmiş hâli olarak
// saklıyoruz (bkz. NoteListDataCategoryMixin._saveData / _loadData).
// Bu, projede _textColor için zaten kullanılan yöntemle birebir aynıdır.
Color accentColorFromSettingValue(String? value, {Color fallback = Colors.amber}) {
  if (value == null || value.isEmpty) return fallback;
  final argb = int.tryParse(value);
  if (argb == null) return fallback;
  return Color(argb);
}

String accentColorToSettingValue(Color color) {
  return color.toARGB32().toString();
}

// Ayarlar ekranında (Vurgu Rengi satırı ve önizleme dairesi) gösterilecek
// rengi döndürür. Şimdilik seçili vurgu rengi, açık/koyu tema fark etmeksizin
// olduğu gibi kullanılır (palet zaten her iki temada da okunaklı renklerden
// oluşuyor); isDark parametresi ileride tema bazlı bir ayarlama gerekirse
// diye çağrı imzasında tutuluyor.
Color dNoteResolveAccentColor(Color accentColor, bool isDark) {
  return accentColor;
}

// ════════════════════════════════════════════════════════════════════════
// TARİH BİÇİMİ (Ayarlar > Dil ile senkron)
// AŞAMA 1: Bu bölüm SADECE gün/ay/yıl bileşenlerinin gösterim SIRASINI ve
// ayracını belirler — ay/gün isimlerinin kendisini (ör. "Ocak"/"January")
// ÜRETMEZ. O isimler hâlâ her ekranın kendi ARB anahtarlarından (örn.
// calendar_screen.dart -> calendarMonthJan, gundem_screen.dart ->
// gundemMonthShortJan) geliyor ve öyle kalmaya devam ediyor; bu sayede bu
// katman, farklı ekranlardaki farklı ay-ismi kaynaklarıyla (tam/kısa)
// çakışmadan ortak kullanılabiliyor.
//
// Karar mantığı: dil, kaç tarih düzeninden birine eşlenir:
//   dmy -> "9 Ağustos 2026"      (varsayılan; tr ve listedeki çoğu dil)
//   mdy -> "August 9, 2026"      (en)
//   ymd -> "2026年8月9日" tarzı    (ja, zh, ko — sıra için; ay/gün arasına
//                                  ayraç eklenmez, tam biçim gerekirse
//                                  Aşama 3'te bu diller için ayrıca
//                                  gözden geçirilecek)
// Yeni bir dil eklendiğinde buraya satır eklenmezse otomatik olarak "dmy"
// (mevcut/eski davranış) kullanılır — bu yüzden varsayılan asla kırılmaz.
// ════════════════════════════════════════════════════════════════════════
enum DNoteDateOrder { dmy, mdy, ymd }

DNoteDateOrder dNoteDateOrderForLanguageCode(String languageCode) {
  switch (languageCode) {
    case 'en':
      return DNoteDateOrder.mdy;
    case 'ja':
    case 'zh':
    case 'ko':
      return DNoteDateOrder.ymd;
    default:
      return DNoteDateOrder.dmy;
  }
}

// 'system' dil modunda gerçek dili context üzerinden (Localizations.localeOf)
// okuyoruz — bu, AppLocalizations'ın zaten çözümlediği/fallback uyguladığı
// locale ile birebir aynı kaynak; appLanguage.value'yu (ör. 'system' string'ini)
// tekrar çözümlemeye çalışıp AppLocalizations'ın fallback mantığından
// (desteklenmeyen cihaz dilinde tr'ye düşme) sapma riskini ortadan kaldırır.
DNoteDateOrder dNoteDateOrderForContext(BuildContext context) {
  return dNoteDateOrderForLanguageCode(Localizations.localeOf(context).languageCode);
}

// Tam tarih (gün + ay ismi + yıl), dile göre doğru sırada birleştirir.
// `day`/`year` çağıran taraftan hazır string olarak gelir (örn. '9', '2026');
// `month` de çağıran ekranın kendi ARB kaynağından ürettiği ay ismidir
// (tam veya kısa fark etmez — bu fonksiyon sadece sırayı belirler).
String dNoteFormatDateParts(
  BuildContext context, {
  required String day,
  required String month,
  required String year,
}) {
  switch (dNoteDateOrderForContext(context)) {
    case DNoteDateOrder.mdy:
      return '$month $day, $year';
    case DNoteDateOrder.ymd:
      return '$year $month $day';
    case DNoteDateOrder.dmy:
      return '$day $month $year';
  }
}

// Kısa tarih (yıl olmadan gün + ay), gündem ekranındaki "9 Ağu" / "Aug 9"
// tarzı etiketler için. ymd düzeninde de yıl zaten yok, bu yüzden mdy
// dışındaki tüm düzenler için gün-ay sırası kullanılır.
String dNoteFormatShortDateParts(
  BuildContext context, {
  required String day,
  required String month,
}) {
  return dNoteDateOrderForContext(context) == DNoteDateOrder.mdy
      ? '$month $day'
      : '$day $month';
}

// Gün olmadan sadece ay + yıl (takvim başlığı, örn. "Ağustos 2026" /
// "August 2026" / "2026年8月"). dmy ve mdy'de sıra aynıdır (ay sonra yıl);
// yalnızca ymd'de yıl öne alınır.
String dNoteFormatMonthYearParts(
  BuildContext context, {
  required String month,
  required String year,
}) {
  return dNoteDateOrderForContext(context) == DNoteDateOrder.ymd
      ? '$year $month'
      : '$month $year';
}

// Sayısal tarih (ay İSMİ değil, ay NUMARASI) — ör. yedek listesi gibi
// kompakt satırlarda "09.08.2026" / "08/09/2026" / "2026.08.09". Ay adı
// üretmediği için ARB'ye bağlı değil; `day`/`month` çağıran taraftan
// zaten iki haneli (padLeft) string olarak gelir.
// Ayraç, dile göre değişen yaygın yazım kuralını izler: mdy (en) için
// '/', diğer tüm sıralar (dmy, ymd) için '.'.
String dNoteFormatNumericDateParts(
  BuildContext context, {
  required String day,
  required String month,
  required String year,
}) {
  switch (dNoteDateOrderForContext(context)) {
    case DNoteDateOrder.mdy:
      return '$month/$day/$year';
    case DNoteDateOrder.ymd:
      return '$year.$month.$day';
    case DNoteDateOrder.dmy:
      return '$day.$month.$year';
  }
}

