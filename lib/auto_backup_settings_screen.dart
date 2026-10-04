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
  DateTime? _lastRunAt;
  String? _lastRunMessage;
  bool? _lastRunSuccess;

  // Google Drive bağlantı durumu. Segment butonlarındaki "Google Drive" ve
  // "Her İkisi" seçeneklerinin aktif/pasif olmasını belirler.
  bool _driveConnected = false;
  bool _driveConnecting = false;

  // Bulut yedekleme Pro'ya özeldir. Pro değilse Drive/Her İkisi segmentleri
  // kilitli kalır ve "Bağlan" butonu yerine yükseltme yönlendirmesi çıkar.
  bool _isPro = false;

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
      _lastRunSuccess = lastStatus == 'success';
      _lastRunAt = lastRun;
      _lastRunMessage = lastMessage;
    }

    // Pro durumu (ön planda appIsPro güvenilir; main() içinde runApp'ten
    // önce DB'deki is_pro değeriyle doldurulur).
    final isPro = appIsPro.value;

    // Google Drive bağlantısını kontrol et. isSignedIn anlık (senkron)
    // durumu yansıtır ama uygulama yeni açıldıysa henüz güncellenmemiş
    // olabilir; bu yüzden gerekirse sessiz girişi de deneriz.
    // Pro değilse Drive zaten kullanılamayacağı için gereksiz Google
    // isteği yapılmaz.
    var driveConnected = false;
    if (isPro) {
      driveConnected = GoogleDriveHelper.instance.isSignedIn;
      if (!driveConnected) {
        driveConnected = await GoogleDriveHelper.instance.trySilentSignIn();
      }
    }

    // Kayıtlı hedef Drive/Her İkisi ama kullanıcı Pro değil ya da bağlantı
    // yoksa (ör. oturum kapatılmış/token geçersiz), kullanıcının
    // soluk/tıklanamaz bir segmentte "seçili" görünmesini önlemek için
    // hedefi Yerel'e çekip kaydediyoruz. Pro için bu, arka plan
    // görevindeki düşürmenin ayarlar ekranı tarafıdır; ayrıca periyodik
    // görevin ağ kısıtı da yeni hedefe göre yeniden kurulur.
    var effectiveTarget = target;
    if ((!isPro || !driveConnected) && target != AutoBackupTarget.local) {
      effectiveTarget = AutoBackupTarget.local;
      await _backupService.setTarget(effectiveTarget);
      await _backupService.rescheduleFromSavedSettings();
    }

    setState(() {
      _isEnabled = enabled;
      _target = effectiveTarget;
      _frequencyHours = frequency;
      _wifiOnly = wifiOnly;
      _driveConnected = driveConnected;
      _isPro = isPro;
      _isLoading = false;
    });
  }

  // Pro yükseltme ekranını açar; dönüşte (satın alma yapılmış olabilir)
  // ayarlar yeniden yüklenir, böylece segmentler açılır. Hedef otomatik
  // seçilmez, kullanıcı elle tekrar seçer.
  Future<void> _openProUpgrade() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProUpgradeScreen()),
    );
    if (!mounted) return;
    await _loadSettings();
  }

  Future<void> _connectGoogleDrive() async {
    if (!_isPro) return;
    setState(() => _driveConnecting = true);
    final success = await GoogleDriveHelper.instance.signIn();
    if (!mounted) return;
    setState(() {
      _driveConnected = success;
      _driveConnecting = false;
    });
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.autoBackupSettingsDriveConnectFailedSnackbar),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
      SnackBar(
        content: Text(AppLocalizations.of(context)!.autoBackupSettingsSavedSnackbar),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    );
  }

  String _buildLastRunInfoText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_lastRunAt == null) {
      return l10n.autoBackupSettingsNeverRunMessage;
    }
    final date = '${_lastRunAt!.day}.${_lastRunAt!.month}.${_lastRunAt!.year}';
    final time = '${_lastRunAt!.hour.toString().padLeft(2, '0')}:${_lastRunAt!.minute.toString().padLeft(2, '0')}';
    final status = _lastRunSuccess == true
        ? l10n.autoBackupSettingsStatusSuccessLabel
        : l10n.autoBackupSettingsStatusFailedLabel;
    return l10n.autoBackupSettingsLastRunInfo(date, time, status, _lastRunMessage ?? '');
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
        title: Text(AppLocalizations.of(context)!.autoBackupSettingsAppBarTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Ana Açma/Kapatma Anahtarı
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.autoBackupSettingsMainSwitchTitle),
            subtitle: Text(AppLocalizations.of(context)!.autoBackupSettingsMainSwitchSubtitle),
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
              title: Text(AppLocalizations.of(context)!.autoBackupSettingsTargetTitle),
              subtitle: Text(AppLocalizations.of(context)!.autoBackupSettingsTargetSubtitle),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SegmentedButton<AutoBackupTarget>(
                segments: [
                  ButtonSegment(
                    value: AutoBackupTarget.local,
                    label: Text(AppLocalizations.of(context)!.autoBackupSettingsTargetLocalOption),
                  ),
                  ButtonSegment(
                    value: AutoBackupTarget.drive,
                    label: Text(AppLocalizations.of(context)!.autoBackupSettingsTargetDriveOption),
                    enabled: _isPro && _driveConnected,
                  ),
                  ButtonSegment(
                    value: AutoBackupTarget.both,
                    label: Text(AppLocalizations.of(context)!.autoBackupSettingsTargetBothOption),
                    enabled: _isPro && _driveConnected,
                  ),
                ],
                selected: {_target},
                onSelectionChanged: (Set<AutoBackupTarget> selection) {
                  setState(() => _target = selection.first);
                  _saveAndReschedule();
                },
              ),
            ),

            // Pro değilse: Drive seçeneklerinin neden kilitli olduğunu
            // açıklayan not ve yükseltme ekranına götüren buton.
            if (!_isPro)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.autoBackupSettingsDriveProNote,
                        style: TextStyle(
                          fontSize: 12,
                          color: dNoteTextColor(context).withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: _openProUpgrade,
                      child: Text(AppLocalizations.of(context)!.autoBackupSettingsUpgradeButton),
                    ),
                  ],
                ),
              ),

            // Pro ama Drive bağlı değilse: neden pasif olduğunu açıklayan
            // kısa not ve bağlanmayı tetikleyen buton.
            if (_isPro && !_driveConnected)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.autoBackupSettingsDriveNotConnectedNote,
                        style: TextStyle(
                          fontSize: 12,
                          color: dNoteTextColor(context).withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _driveConnecting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : TextButton(
                            onPressed: _connectGoogleDrive,
                            child: Text(AppLocalizations.of(context)!.autoBackupSettingsConnectButton),
                          ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // 3. Yedekleme Sıklığı (Frekans)
            ListTile(
              title: Text(AppLocalizations.of(context)!.autoBackupSettingsFrequencyTitle),
              subtitle: Text(
                AppLocalizations.of(context)!.autoBackupSettingsFrequencySubtitle(_frequencyHours),
              ),
              trailing: DropdownButton<int>(
                value: _frequencyHours,
                items: [
                  DropdownMenuItem(value: 6, child: Text(AppLocalizations.of(context)!.autoBackupSettingsFrequency6h)),
                  DropdownMenuItem(value: 12, child: Text(AppLocalizations.of(context)!.autoBackupSettingsFrequency12h)),
                  DropdownMenuItem(value: 24, child: Text(AppLocalizations.of(context)!.autoBackupSettingsFrequency24h)),
                  DropdownMenuItem(value: 48, child: Text(AppLocalizations.of(context)!.autoBackupSettingsFrequency48h)),
                  DropdownMenuItem(value: 168, child: Text(AppLocalizations.of(context)!.autoBackupSettingsFrequency168h)),
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
                title: Text(AppLocalizations.of(context)!.autoBackupSettingsWifiOnlySwitchTitle),
                subtitle: Text(AppLocalizations.of(context)!.autoBackupSettingsWifiOnlySwitchSubtitle),
                value: _wifiOnly,
                onChanged: (val) {
                  setState(() => _wifiOnly = val);
                  _saveAndReschedule();
                },
              ),
            const Divider(),
          ],

          // 5. Durum Raporlama Paneli
          // AŞAMA: kart artık dNoteIsDark(context)'e göre koyu/açık tema
          // uyumlu renkler kullanıyor. Önceden sabit Colors.grey.shade100 /
          // green.shade50 / red.shade50 kullanıldığı için koyu temada bile
          // panel her zaman beyaza yakın görünüyordu; artık nötr durumda
          // dNoteCardColor(context) (uygulamanın standart kart rengi),
          // başarı/hata durumlarında ise koyu temaya özel, düşük opaklıklı
          // yeşil/kırmızı tonlar kullanılıyor.
          Builder(
            builder: (context) {
              final isDark = dNoteIsDark(context);
              final Color cardColor = _lastRunSuccess == null
                  ? dNoteCardColor(context)
                  : (_lastRunSuccess!
                      ? (isDark
                          ? Colors.green.shade900.withValues(alpha: 0.25)
                          : Colors.green.shade50)
                      : (isDark
                          ? Colors.red.shade900.withValues(alpha: 0.25)
                          : Colors.red.shade50));
              final Color titleColor = _lastRunSuccess == null
                  ? dNoteTextColor(context)
                  : (_lastRunSuccess!
                      ? (isDark ? Colors.green.shade300 : Colors.green.shade900)
                      : (isDark ? Colors.red.shade300 : Colors.red.shade900));
              final Color bodyColor = _lastRunSuccess == null
                  ? dNoteTextColor(context).withValues(alpha: 0.7)
                  : (_lastRunSuccess!
                      ? (isDark ? Colors.green.shade200 : Colors.green.shade800)
                      : (isDark ? Colors.red.shade200 : Colors.red.shade800));

              return Card(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.autoBackupSettingsStatusCardTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _buildLastRunInfoText(context),
                        style: TextStyle(color: bodyColor),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}