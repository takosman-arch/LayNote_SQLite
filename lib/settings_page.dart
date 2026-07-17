part of 'main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: [
          // ── TEMA VE GÖRÜNÜM AYARLARI ──────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Tema Değiştir'),
            subtitle: const Text('Uygulama görünümünü özelleştirin'),
            trailing: ValueListenableBuilder<ThemeMode>(
              valueListenable: appThemeMode,
              builder: (context, mode, _) {
                String modeText = 'Sistem';
                if (mode == ThemeMode.light) modeText = 'Açık';
                if (mode == ThemeMode.dark) modeText = 'Koyu';
                return Text(modeText, style: const TextStyle(fontWeight: FontWeight.bold));
              },
            ),
            onTap: () => _showThemeDialog(context),
          ),
          const Divider(),

          // ── YEDEKLEME VE BULUT AYARLARI ───────────────────────────────────
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: const Text('Manuel Yedekle ve Yükle'),
            subtitle: const Text('Notları el ile cihaz hafızasına yedekleyin veya geri yükleyin'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BackupRestoreScreen(),
                ),
              );
            },
          ),
          
          // Aşama 6.10: Yeni eklenen Otomatik Yedekleme Ayarları Butonu
          ListTile(
            leading: const Icon(Icons.cloud_sync_outlined),
            title: const Text('Otomatik Yedekleme Ayarları'),
            subtitle: const Text('Arka plan yedekleme sıklığı ve bulut hedefleri'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AutoBackupSettingsScreen(),
                ),
              );
            },
          ),
          const Divider(),

          // ── UYGULAMA HAKKINDA ─────────────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Uygulama Sürümü'),
            subtitle: const Text('v1.0.0'),
            onTap: null,
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tema Seçin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: const Text('Sistem Varsayılanı'),
                value: ThemeMode.system,
                groupValue: appThemeMode.value,
                onChanged: (val) => _updateTheme(context, val),
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Açık Tema'),
                value: ThemeMode.light,
                groupValue: appThemeMode.value,
                onChanged: (val) => _updateTheme(context, val),
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Koyu Tema'),
                value: ThemeMode.dark,
                groupValue: appThemeMode.value,
                onChanged: (val) => _updateTheme(context, val),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateTheme(BuildContext context, ThemeMode? mode) async {
    if (mode == null) return;
    appThemeMode.value = mode;
    
    // Yeni temayı veritabanına kaydet
    String settingValue = 'system';
    if (mode == ThemeMode.light) settingValue = 'light';
    if (mode == ThemeMode.dark) settingValue = 'dark';
    await DBHelper.instance.setSetting('theme_mode', settingValue);

    if (context.mounted) Navigator.pop(context);
  }
}