part of 'main.dart';

class AutoBackupSettingsScreen extends StatefulWidget {
  const AutoBackupSettingsScreen({super.key});

  @override
  State<AutoBackupSettingsScreen> createState() => _AutoBackupSettingsScreenState();
}

class _AutoBackupSettingsScreenState extends State<AutoBackupSettingsScreen> {
  final _backupService = AutoBackupService.instance;

  bool _isEnabled = false;
  AutoBackupTarget _target = AutoBackupTarget.local;
  int _frequencyHours = 24;
  bool _wifiOnly = true;

  bool _isLoading = true;
  String _lastRunInfo = 'Henüz otomatik yedekleme çalışmadı.';
  bool? _lastRunSuccess;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    
    final enabled = await _backupService.isEnabled();
    final target = await _backupService.getTarget();
    final frequency = await _backupService.getFrequencyHours();
    final wifiOnly = await _backupService.getWifiOnly();

    // Son çalışma bilgilerini yükle
    final lastRun = await _backupService.getLastRunAt();
    final lastStatus = await _backupService.getLastStatus();
    final lastMessage = await _backupService.getLastMessage();

    if (lastRun != null) {
      final statusText = lastStatus == 'success' ? 'Başarılı' : 'Hatalı';
      _lastRunSuccess = lastStatus == 'success';
      _lastRunInfo = 'Son Çalışma: ${lastRun.day}.${lastRun.month}.${lastRun.year} ${lastRun.hour.toString().padLeft(2, '0')}:${lastRun.minute.toString().padLeft(2, '0')} ($statusText)\nMesaj: $lastMessage';
    }

    setState(() {
      _isEnabled = enabled;
      _target = target;
      _frequencyHours = frequency;
      _wifiOnly = wifiOnly;
      _isLoading = false;
    });
  }

  Future<void> _saveAndReschedule() async {
    // Ayarları servise kaydet
    await _backupService.setEnabled(_isEnabled);
    await _backupService.setTarget(_target);
    await _backupService.setFrequencyHours(_frequencyHours);
    await _backupService.setWifiOnly(_wifiOnly);

    // Workmanager görevini yeni ayarlara göre güncelle veya iptal et
    await _backupService.rescheduleFromSavedSettings();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Otomatik yedekleme ayarları güncellendi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Otomatik Yedekleme Ayarları'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Ana Açma/Kapatma Anahtarı
          SwitchListTile(
            title: const Text('Otomatik Yedeklemeyi Aktif Et'),
            subtitle: const Text('Notlarınız arka planda periyodik olarak güvenle yedeklenir.'),
            value: _isEnabled,
            onChanged: (val) {
              setState(() => _isEnabled = val);
              _saveAndReschedule();
            },
          ),
          const Divider(),

          // Eğer servis aktifse diğer ayarları göster
          if (_isEnabled) ...[
            // 2. Yedekleme Hedefi Seçimi
            ListTile(
              title: const Text('Yedekleme Hedefi'),
              subtitle: const Text('Yedeklerin nereye kaydedileceğini seçin.'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SegmentedButton<AutoBackupTarget>(
                segments: const [
                  ButtonSegment(value: AutoBackupTarget.local, label: Text('Yerel')),
                  ButtonSegment(value: AutoBackupTarget.drive, label: Text('Google Drive')),
                  ButtonSegment(value: AutoBackupTarget.both, label: Text('Her İkisi')),
                ],
                selected: {_target},
                onSelectionChanged: (Set<AutoBackupTarget> selection) {
                  setState(() => _target = selection.first);
                  _saveAndReschedule();
                },
              ),
            ),
            const SizedBox(height: 16),

            // 3. Yedekleme Sıklığı (Frekans)
            ListTile(
              title: const Text('Yedekleme Sıklığı'),
              subtitle: Text('Her $_frequencyHours saatte bir yedek alınır.'),
              trailing: DropdownButton<int>(
                value: _frequencyHours,
                items: const [
                  DropdownMenuItem(value: 6, child: Text('6 Saat')),
                  DropdownMenuItem(value: 12, child: Text('12 Saat')),
                  DropdownMenuItem(value: 24, child: Text('24 Saat (Günlük)')),
                  DropdownMenuItem(value: 48, child: Text('48 Saat (2 Gün)')),
                  DropdownMenuItem(value: 168, child: Text('168 Saat (Haftalık)')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _frequencyHours = val);
                    _saveAndReschedule();
                  }
                },
              ),
            ),

            // 4. Sadece Wi-Fi Kontrolü (Eğer Drive veya Her İkisi seçiliyse anlamlı)
            if (_target != AutoBackupTarget.local)
              SwitchListTile(
                title: const Text('Sadece Wi-Fi Kullan'),
                subtitle: const Text('Bulut yüklemesi yalnızca Wi-Fi bağlıyken yapılır mobil veriniz korunur.'),
                value: _wifiOnly,
                onChanged: (val) {
                  setState(() => _wifiOnly = val);
                  _saveAndReschedule();
                },
              ),
            const Divider(),
          ],

          // 5. Durum Raporlama Paneli
          Card(
            color: _lastRunSuccess == null
                ? Colors.grey.shade100
                : (_lastRunSuccess! ? Colors.green.shade50 : Colors.red.shade50),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sistem Durumu',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _lastRunSuccess == null
                          ? Colors.black87
                          : (_lastRunSuccess! ? Colors.green.shade900 : Colors.red.shade900),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _lastRunInfo,
                    style: TextStyle(
                      color: _lastRunSuccess == null
                          ? Colors.black54
                          : (_lastRunSuccess! ? Colors.green.shade800 : Colors.red.shade800),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}