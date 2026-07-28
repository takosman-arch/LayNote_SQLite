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

