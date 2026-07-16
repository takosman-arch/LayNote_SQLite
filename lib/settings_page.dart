part of 'main.dart';

// ═══════════════════════════════════════════════════════════════════
// AYARLAR SAYFASI
// ═══════════════════════════════════════════════════════════════════

class _SettingsPage extends StatefulWidget {
  final _NoteListScreenState state;
  const _SettingsPage({required this.state});

  @override
  State<_SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<_SettingsPage> {
  _NoteListScreenState get s => widget.state;

  // ── Şifre ipucu soruları (sabit liste) ──────────────────────────────
  static const List<String> _hintQuestions = [
    'İlk evcil hayvanınızın adı nedir?',
    'En sevdiğiniz öğretmeninizin adı nedir?',
    'Doğduğunuz şehir nedir?',
    'En sevdiğiniz yemek nedir?',
    'Annenizin kızlık soyadı nedir?',
    'İlk okuduğunuz okulun adı nedir?',
    'En sevdiğiniz renk nedir?',
  ];

  // ── Görünüm (Açık/Koyu/Sistem) seçim diyaloğu ────────────────────────
  void _showThemeModeDialog() {
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDlg) {
          Widget option(ThemeMode mode, String label, IconData icon) {
            final selected = s._themeMode == mode;
            return ListTile(
              leading: Icon(
                icon,
                color: selected ? Colors.amber : Colors.grey,
              ),
              title: Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.amber : dNoteTextColor(ctx),
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: selected
                  ? const Icon(Icons.check, color: Colors.amber)
                  : null,
              onTap: () {
                s.setState(() => s._themeMode = mode);
                appThemeMode.value = mode;
                setState(() {});
                s._saveData();
                Navigator.pop(ctx);
              },
            );
          }

          return AlertDialog(
            backgroundColor: dNoteCardColor(ctx),
            title: const Text('Görünüm', style: TextStyle(color: Colors.amber)),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                option(ThemeMode.light, 'Açık', Icons.light_mode_outlined),
                option(ThemeMode.dark, 'Koyu', Icons.dark_mode_outlined),
                option(
                  ThemeMode.system,
                  'Sistem Varsayılanı',
                  Icons.smartphone_outlined,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Güvenlik sorusu düzenleme diyaloğu ──────────────────────────────
  void _showHintQuestionDialog() {
    String? selectedQuestion = s._passwordHintQuestion.isNotEmpty
        ? s._passwordHintQuestion
        : null;
    final answerCtrl = TextEditingController(text: s._passwordHintAnswer);

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          backgroundColor: dNoteCardColor(ctx),
          title: const Text(
            'Güvenlik Sorusu',
            style: TextStyle(color: Colors.amber),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Şifrenizi unutursanız, bu soruyu doğru cevaplayarak şifrenizi hatırlayabilirsiniz.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: selectedQuestion,
                dropdownColor: dNoteSurfaceVariant(ctx),
                style: TextStyle(color: dNoteTextColor(ctx), fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Güvenlik sorusu seçin',
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                items: _hintQuestions
                    .map(
                      (q) => DropdownMenuItem(
                        value: q,
                        child: Text(q, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setDlg(() => selectedQuestion = val),
              ),
              const SizedBox(height: 12),
              TextField(
                selectionWidthStyle: ui.BoxWidthStyle.tight,
                contextMenuBuilder: buildCustomContextMenu,
                selectionHeightStyle: ui.BoxHeightStyle.max,
                controller: answerCtrl,
                style: TextStyle(color: dNoteTextColor(ctx)),
                decoration: InputDecoration(
                  hintText: 'Cevabınız',
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                if (selectedQuestion == null ||
                    answerCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Soru ve cevap boş olamaz!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                s.setState(() {
                  s._passwordHintQuestion = selectedQuestion!;
                  s._passwordHintAnswer = answerCtrl.text.trim();
                });
                s._saveData();
                Navigator.pop(ctx);
                setState(() {});
              },
              child: const Text(
                'Kaydet',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Şifre diyaloğu ────────────────────────────────────────────────
  void _showPasswordDialog({required bool isNew}) {
    final ctrl1 = TextEditingController();
    final ctrl2 = TextEditingController();
    final hintAnswerCtrl = TextEditingController();
    bool obscure1 = true;
    bool obscure2 = true;
    String? selectedHintQuestion = s._passwordHintQuestion.isNotEmpty
        ? s._passwordHintQuestion
        : null;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          backgroundColor: dNoteCardColor(ctx),
          title: Text(
            isNew ? 'Şifre Oluştur' : 'Mevcut Şifreyi Gir',
            style: const TextStyle(color: Colors.amber),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isNew)
                  TextField(
                    selectionWidthStyle: ui.BoxWidthStyle.tight,
                    contextMenuBuilder: buildCustomContextMenu,
                    selectionHeightStyle: ui.BoxHeightStyle.max,
                    controller: ctrl1,
                    obscureText: obscure1,
                    style: TextStyle(color: dNoteTextColor(ctx)),
                    decoration: InputDecoration(
                      hintText: 'Mevcut şifre',
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure1 ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () => setDlg(() => obscure1 = !obscure1),
                      ),
                    ),
                  )
                else ...[
                  TextField(
                    selectionWidthStyle: ui.BoxWidthStyle.tight,
                    contextMenuBuilder: buildCustomContextMenu,
                    selectionHeightStyle: ui.BoxHeightStyle.max,
                    controller: ctrl1,
                    obscureText: obscure1,
                    style: TextStyle(color: dNoteTextColor(ctx)),
                    decoration: InputDecoration(
                      hintText: 'Yeni şifre',
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure1 ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () => setDlg(() => obscure1 = !obscure1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    selectionWidthStyle: ui.BoxWidthStyle.tight,
                    contextMenuBuilder: buildCustomContextMenu,
                    selectionHeightStyle: ui.BoxHeightStyle.max,
                    controller: ctrl2,
                    obscureText: obscure2,
                    style: TextStyle(color: dNoteTextColor(ctx)),
                    decoration: InputDecoration(
                      hintText: 'Şifreyi tekrar gir',
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure2 ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () => setDlg(() => obscure2 = !obscure2),
                      ),
                    ),
                  ),
                  Divider(color: Theme.of(ctx).dividerColor, height: 28),
                  const Text(
                    'Şifrenizi unutursanız diye bir güvenlik sorusu belirleyin.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: selectedHintQuestion,
                    dropdownColor: dNoteSurfaceVariant(ctx),
                    style: TextStyle(color: dNoteTextColor(ctx), fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Güvenlik sorusu seçin',
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                    ),
                    items: _hintQuestions
                        .map(
                          (q) => DropdownMenuItem(
                            value: q,
                            child: Text(q, overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                    onChanged: (val) =>
                        setDlg(() => selectedHintQuestion = val),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    selectionWidthStyle: ui.BoxWidthStyle.tight,
                    contextMenuBuilder: buildCustomContextMenu,
                    selectionHeightStyle: ui.BoxHeightStyle.max,
                    controller: hintAnswerCtrl,
                    style: TextStyle(color: dNoteTextColor(ctx)),
                    decoration: InputDecoration(
                      hintText: 'Cevabınız',
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Bu alan zorunlu değildir ama şiddetle önerilir.',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                if (isNew) {
                  if (ctrl1.text.isEmpty) return;
                  if (ctrl1.text != ctrl2.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Şifreler eşleşmiyor!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  s.setState(() {
                    s._notePassword = ctrl1.text;
                    s._notePasswordEnabled = true;
                    s._passwordHintQuestion = selectedHintQuestion ?? '';
                    s._passwordHintAnswer = hintAnswerCtrl.text.trim();
                  });
                  s._saveData();
                  Navigator.pop(ctx);
                  setState(() {});
                } else {
                  // Disable: verify old password
                  if (ctrl1.text == s._notePassword) {
                    s.setState(() {
                      s._notePasswordEnabled = false;
                      s._notePassword = '';
                      s._passwordHintQuestion = '';
                      s._passwordHintAnswer = '';
                    });
                    s._saveData();
                    Navigator.pop(ctx);
                    setState(() {});
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Yanlış şifre!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text(
                isNew ? 'Kaydet' : 'Kaldır',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Yazı tipi seçici ──────────────────────────────────────────────
  static const List<String> _fonts = [
    'Varsayılan',
    'Monospace',
    'Serif',
    'Cursive',
  ];

  static String? _fontFamilyValue(String name) {
    switch (name) {
      case 'Monospace':
        return 'monospace';
      case 'Serif':
        return 'serif';
      case 'Cursive':
        return 'cursive';
      default:
        return null;
    }
  }

  // ── Metin rengi seçici ────────────────────────────────────────────
  static const List<Color> _textPalette = [
    Colors.white,
    Color(0xFFE0E0E0),
    Color(0xFFBDBDBD),
    Colors.amber,
    Colors.cyanAccent,
    Colors.greenAccent,
    Colors.pinkAccent,
    Colors.lightBlueAccent,
    Colors.orangeAccent,
  ];

  void _showTextColorPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: dNoteCardColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(
                    bottom: 16,
                    left: 120,
                    right: 120,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'Metin Rengi',
                  style: TextStyle(
                    color: dNoteTextColor(ctx),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Not içerik metninin rengini belirler.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    // "Varsayılan": özel bir renk seçilmemiş, metin rengi
                    // temaya göre otomatik belirlenir (koyu temada beyaz,
                    // açık temada koyu gri).
                    _TextColorSwatch(
                      selected: s._textColor == null,
                      onTap: () {
                        s.setState(() => s._textColor = null);
                        setSheet(() {});
                        s._saveData();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white, Colors.black87],
                            stops: [0.5, 0.5],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'A',
                          style: TextStyle(
                            color: s._textColor == null
                                ? Colors.amber
                                : Colors.grey[500],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    ..._textPalette.map((c) {
                      final selected = s._textColor == c;
                      return _TextColorSwatch(
                        selected: selected,
                        color: c,
                        onTap: () {
                          s.setState(() => s._textColor = c);
                          setSheet(() {});
                          s._saveData();
                        },
                        child: selected
                            ? Icon(
                                Icons.check,
                                color: c == Colors.white
                                    ? Colors.black
                                    : Colors.black87,
                                size: 20,
                              )
                            : null,
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text(
                      'Tamam',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 6),
    child: Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Colors.amber,
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.4,
      ),
    ),
  );

  Widget _settingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) => ListTile(
    leading: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: iconColor, size: 20),
    ),
    title: Text(
      title,
      style: TextStyle(color: dNoteTextColor(context), fontSize: 14),
    ),
    subtitle: subtitle != null
        ? Text(
            subtitle,
            style: TextStyle(color: Colors.grey[500], fontSize: 11),
          )
        : null,
    trailing: trailing,
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: dNoteCardColor(context),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: dNoteTextColor(context)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ayarlar',
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            // ── 1. GÜVENLİK ─────────────────────────────────────────────
            _sectionHeader('Güvenlik'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: dNoteCardColor(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _settingTile(
                    icon: Icons.lock_outline,
                    iconColor: Colors.blueAccent,
                    title: 'Not Şifresi',
                    subtitle: s._notePasswordEnabled
                        ? 'Şifre ayarlandı ✓'
                        : 'Şifre ayarlanmadı',
                    trailing: Switch(
                      value: s._notePasswordEnabled,
                      activeThumbColor: Colors.amber,
                      onChanged: (val) {
                        if (val) {
                          _showPasswordDialog(isNew: true);
                        } else {
                          if (s._notePassword.isEmpty) {
                            s.setState(() => s._notePasswordEnabled = false);
                            s._saveData();
                            setState(() {});
                          } else {
                            _showPasswordDialog(isNew: false);
                          }
                        }
                      },
                    ),
                  ),
                  if (s._notePasswordEnabled) ...[
                    Divider(
                      color: Theme.of(context).dividerColor,
                      height: 1,
                      indent: 56,
                    ),
                    _settingTile(
                      icon: Icons.help_outline,
                      iconColor: Colors.orangeAccent,
                      title: 'Güvenlik Sorusu',
                      subtitle: s._passwordHintQuestion.isNotEmpty
                          ? 'Belirlendi ✓ — şifreyi unutursanız kullanılır'
                          : 'Belirlenmedi — şifrenizi kaybederseniz kurtaramazsınız',
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onTap: () => _showHintQuestionDialog(),
                    ),
                  ],
                ],
              ),
            ),

            // ── 2. TEMA ──────────────────────────────────────────────────
            _sectionHeader('Tema'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: dNoteCardColor(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _settingTile(
                    icon: Icons.dark_mode_outlined,
                    iconColor: Colors.indigoAccent,
                    title: 'Görünüm',
                    subtitle: switch (s._themeMode) {
                      ThemeMode.light => 'Açık',
                      ThemeMode.dark => 'Koyu',
                      ThemeMode.system => 'Sistem Varsayılanı',
                    },
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: () => _showThemeModeDialog(),
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    height: 1,
                    indent: 56,
                  ),
                  _settingTile(
                    icon: Icons.palette_outlined,
                    iconColor: Colors.orangeAccent,
                    title: 'Değişken Not Renkleri',
                    subtitle: 'Her not kartı farklı renk tonu alır.',
                    trailing: Switch(
                      value: s._colorfulNotes,
                      activeThumbColor: Colors.amber,
                      onChanged: (val) {
                        s.setState(() => s._colorfulNotes = val);
                        setState(() {});
                        s._saveData();
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ── 3. KİŞİSELLEŞTİRME ──────────────────────────────────────
            _sectionHeader('Kişiselleştirme'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: dNoteCardColor(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  // Yazı tipi
                  _settingTile(
                    icon: Icons.font_download_outlined,
                    iconColor: Colors.tealAccent,
                    title: 'Yazı Tipi',
                    subtitle: s._fontFamily,
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: dNoteCardColor(context),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) => SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Yazı Tipi',
                                  style: TextStyle(
                                    color: dNoteTextColor(context),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ..._fonts.map(
                                  (f) => ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      f,
                                      style: TextStyle(
                                        color: s._fontFamily == f
                                            ? Colors.amber
                                            : dNoteTextColor(context),
                                        fontFamily: _fontFamilyValue(f),
                                      ),
                                    ),
                                    trailing: s._fontFamily == f
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: Colors.amber,
                                          )
                                        : null,
                                    onTap: () {
                                      s.setState(() => s._fontFamily = f);
                                      setState(() {});
                                      s._saveData();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    height: 1,
                    indent: 56,
                  ),
                  // Metin boyutu
                  _settingTile(
                    icon: Icons.text_fields,
                    iconColor: Colors.pinkAccent,
                    title: 'Metin Boyutu',
                    subtitle:
                        '${s._globalFontSize.round()} pt — tüm notlara uygulanır.',
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      double tempSize = s._globalFontSize;
                      bool applyToAll = false;
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: dNoteCardColor(context),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        isScrollControlled: true,
                        builder: (_) => StatefulBuilder(
                          builder: (ctx, setSheet) => SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                16,
                                24,
                                24,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[500],
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Metin Boyutu',
                                    style: TextStyle(
                                      color: dNoteTextColor(ctx),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.text_fields,
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: SliderTheme(
                                          data: SliderTheme.of(context)
                                              .copyWith(
                                                activeTrackColor: Colors.amber,
                                                inactiveTrackColor:
                                                    dNoteSurfaceVariant(ctx),
                                                thumbColor: Colors.amber,
                                                overlayColor: Colors.amber
                                                    .withValues(alpha: 0.2),
                                                valueIndicatorColor:
                                                    Colors.amber,
                                                valueIndicatorTextStyle:
                                                    const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                          child: Slider(
                                            value: tempSize,
                                            min: 10,
                                            max: 30,
                                            divisions: 20,
                                            label: '${tempSize.round()}',
                                            onChanged: (v) =>
                                                setSheet(() => tempSize = v),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.text_fields,
                                        color: Colors.grey,
                                        size: 26,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Örnek metin - ${tempSize.round()} pt',
                                    style: TextStyle(
                                      color: dNoteTextColor(
                                        ctx,
                                      ).withValues(alpha: 0.7),
                                      fontSize: tempSize,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: applyToAll,
                                        activeColor: Colors.amber,
                                        onChanged: (v) => setSheet(
                                          () => applyToAll = v ?? false,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Mevcut notlara uygula',
                                          style: TextStyle(
                                            color: dNoteTextColor(
                                              ctx,
                                            ).withValues(alpha: 0.7),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      left: 12,
                                      bottom: 16,
                                    ),
                                    child: Text(
                                      'Bireysel not boyutu ayarı varsa bu ayar o notları etkilemez.',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: const Text(
                                            'İptal',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.amber,
                                          ),
                                          onPressed: () {
                                            s.setState(() {
                                              s._globalFontSize = tempSize;
                                              if (applyToAll) {
                                                for (final note in s._notes) {
                                                  note['fontSize'] = tempSize;
                                                }
                                              }
                                            });
                                            setState(() {});
                                            s._saveData();
                                            Navigator.pop(ctx);
                                          },
                                          child: const Text(
                                            'Uygula',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    height: 1,
                    indent: 56,
                  ),
                  // Metin rengi
                  _settingTile(
                    icon: Icons.format_color_text,
                    iconColor: Colors.lightBlueAccent,
                    title: 'Metin Rengi',
                    subtitle: 'Not içerik metni için renk.',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: dNoteEffectiveTextColor(context, s._textColor),
                            border: Border.all(color: Colors.grey[600]!),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                    onTap: _showTextColorPicker,
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    height: 1,
                    indent: 56,
                  ),
                  // Not önizleme satırı
                  _settingTile(
                    icon: Icons.wrap_text,
                    iconColor: Colors.amberAccent,
                    title: 'Not Önizleme Satırı',
                    subtitle:
                        'En fazla ${s._previewLines} satır göster. Not daha kısaysa gerçek satır sayısı görünür.',
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      int tempLines = s._previewLines;
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: dNoteCardColor(context),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) => StatefulBuilder(
                          builder: (ctx, setSheet) => SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                16,
                                24,
                                24,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[500],
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Not Önizleme Satırı',
                                    style: TextStyle(
                                      color: dNoteTextColor(ctx),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Şu an: $tempLines satır',
                                    style: const TextStyle(
                                      color: Colors.amber,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Colors.amber,
                                      inactiveTrackColor: dNoteSurfaceVariant(
                                        ctx,
                                      ),
                                      thumbColor: Colors.amber,
                                      overlayColor: Colors.amber.withValues(
                                        alpha: 0.2,
                                      ),
                                      valueIndicatorColor: Colors.amber,
                                      valueIndicatorTextStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    child: Slider(
                                      value: tempLines.toDouble(),
                                      min: 1,
                                      max: 10,
                                      divisions: 9,
                                      label: '$tempLines',
                                      onChanged: (v) =>
                                          setSheet(() => tempLines = v.round()),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16,
                                    ),
                                    child: Text(
                                      'Maksimum önizlenecek satır sayısını belirler. Not daha az satıra sahipse gerçek satır sayısı gösterilir.',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 11,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: const Text(
                                            'İptal',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.amber,
                                          ),
                                          onPressed: () {
                                            s.setState(
                                              () => s._previewLines = tempLines,
                                            );
                                            setState(() {});
                                            s._saveData();
                                            Navigator.pop(ctx);
                                          },
                                          child: const Text(
                                            'Uygula',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ── 4. WİDGET ────────────────────────────────────────────────
            _sectionHeader('Widget'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: dNoteCardColor(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  // Bilgi kutusu
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.08),
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.amber, size: 18),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Widget ayarları yakında aktif olacak.',
                            style: TextStyle(color: Colors.amber, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Opacity(
                    opacity: 0.45,
                    child: Column(
                      children: [
                        _settingTile(
                          icon: Icons.text_fields,
                          iconColor: Colors.cyanAccent,
                          title: 'Widget Metin Boyutu',
                          subtitle: '${s._widgetFontSize.round()} pt',
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).dividerColor,
                          height: 1,
                          indent: 56,
                        ),
                        _settingTile(
                          icon: Icons.opacity,
                          iconColor: Colors.lightBlueAccent,
                          title: 'Arka Plan Saydamlığı',
                          subtitle: '%${(s._widgetBgOpacity * 100).round()}',
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).dividerColor,
                          height: 1,
                          indent: 56,
                        ),
                        _settingTile(
                          icon: Icons.dark_mode_outlined,
                          iconColor: Colors.deepPurpleAccent,
                          title: 'Koyu Widget',
                          subtitle: 'Widget için koyu renk şeması.',
                          trailing: Switch(
                            value: s._widgetDark,
                            activeThumbColor: Colors.amber,
                            onChanged: null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Ek dosya kutucuğu: basılı tutunca sil ikonu gösterir ────────────────
// Sil ikonunun görünürlüğü dışarıdan (showDelete) kontrol edilir; böylece
// liste içindeki bir öğe silindiğinde, kalan öğelerin durumu widget'ların
// yeniden kullanılmasından (state reuse) etkilenmez.
// ── Metin Rengi seçicideki tek bir renk karesi ───────────────────────────
// `color` verilmezse (Varsayılan seçeneği) kare tamamen `child` tarafından
// çizilir; verilirse düz bir renk karesi olur.
class _TextColorSwatch extends StatelessWidget {
  final Color? color;
  final bool selected;
  final VoidCallback onTap;
  final Widget? child;

  const _TextColorSwatch({
    this.color,
    required this.selected,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: selected ? Colors.amber : Colors.grey[500]!,
            width: selected ? 2.5 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  final Widget preview;
  final double width;
  final double height;
  final bool showDelete;
  final VoidCallback onOpen;
  final VoidCallback onRemove;
  final VoidCallback onLongPress;
  final VoidCallback onDismissDelete;

  const _AttachmentTile({
    required this.preview,
    required this.width,
    required this.height,
    required this.showDelete,
    required this.onOpen,
    required this.onRemove,
    required this.onLongPress,
    required this.onDismissDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showDelete ? onDismissDelete : onOpen,
      onLongPress: showDelete ? null : onLongPress,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: dNoteSurfaceVariant(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: dNoteBorderColor(context)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(child: preview),
            if (showDelete)
              Positioned.fill(
                child: Container(color: Colors.black54),
              ),
            if (showDelete)
              Center(
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

