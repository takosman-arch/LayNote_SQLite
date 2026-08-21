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
Color accentColorFromSettingValue(String? value) {
  if (value == null || value.isEmpty) return Colors.amber;
  final argb = int.tryParse(value);
  if (argb == null) return Colors.amber;
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

