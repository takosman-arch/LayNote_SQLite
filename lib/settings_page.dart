part of 'main.dart';

// ═══════════════════════════════════════════════════════════════════
// AYARLAR SAYFASI
// AŞAMA 1: "state" (_NoteListScreenState) erişimi geri getirildi ve
// Güvenlik bölümü (Not Şifresi + Güvenlik Sorusu) eski haliyle eklendi.
// AŞAMA 2: Tema bölümüne "Değişken Not Renkleri" anahtarı eklendi.
// AŞAMA 3: Kişiselleştirme bölümü (Yazı Tipi, Metin Boyutu, Metin Rengi)
// eski haliyle eklendi.
// AŞAMA 4: Not Önizleme Satırı ayarı + pasif Widget bölümü eklendi.
// Tüm aşamalar tamamlandı.
// ═══════════════════════════════════════════════════════════════════

class SettingsPage extends StatefulWidget {
  final _NoteListScreenState state;
  const SettingsPage({super.key, required this.state});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

// Ayarlar > Kişiselleştirme > Yazı Tipi'nde seçilen görünen ismi ('Varsayılan',
// 'Monospace', 'Serif', 'Cursive') Flutter'ın TextStyle.fontFamily alanının
// anladığı gerçek değere çevirir. Top-level (private DEĞİL) olarak
// tanımlanıyor ki note_list_build_mixin.dart ve note_list_note_dialog_mixin.dart
// gibi diğer 'part of main.dart' dosyaları da not metnini çizerken bunu
// çağırabilsin — önceden bu sadece _SettingsPageState içine gömülüydü ve
// SADECE ayarlar ekranındaki önizlemede kullanılıyordu, notlara hiç
// uygulanmıyordu.
// NOT: 'monospace' / 'serif' / 'cursive' gibi jenerik (CSS tarzı) isimler
// Flutter'da otomatik çalışmaz — pubspec.yaml'da o isimle tanımlı bir font
// olmadığı sürece Flutter sessizce varsayılan fonta düşer ve önizlemede
// hiçbir görsel fark oluşmaz. Bu yüzden burada, pubspec.yaml'a eklenen
// gömülü fontların ("DNoteMono", "DNoteSerif", "DNoteCursive") gerçek
// aile isimleri döndürülüyor.
String? dNoteFontFamilyValue(String? name) {
  switch (name) {
    case 'Monospace':
      return 'DNoteMono';
    case 'Serif':
      return 'DNoteSerif';
    case 'Cursive':
      return 'DNoteCursive';
    case 'Sans':
      return 'DNoteSans';
    case 'Sans Alt':
      return 'DNoteSansAlt';
    case 'Geometric':
      return 'DNoteGeometric';
    case 'El Yazısı DE':
      return 'DNoteHandDE';
    case 'El Yazısı US':
      return 'DNoteHandUS';
    case 'Elegant':
      return 'DNoteElegant';
    default:
      return null;
  }
}

class _SettingsPageState extends State<SettingsPage> {
  _NoteListScreenState get s => widget.state;

  // ── Şifre ipucu soruları (sabit liste) ──────────────────────────────
  List<String> _hintQuestions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      l10n.settingsHintQuestionPet,
      l10n.settingsHintQuestionTeacher,
      l10n.settingsHintQuestionBirthCity,
      l10n.settingsHintQuestionFavoriteFood,
      l10n.settingsHintQuestionMotherMaidenName,
      l10n.settingsHintQuestionFirstSchool,
      l10n.settingsHintQuestionFavoriteColor,
    ];
  }

  // ─────────────────────────────────────────────────────────────────
  // ORTAK GÖRSEL YARDIMCILAR (eski tasarımla birebir)
  // ─────────────────────────────────────────────────────────────────
  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 6),
    child: Text(
      title.toUpperCase(),
      style: TextStyle(
        color: Theme.of(context).primaryColor,
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

  // ── Yazı tipi seçici ──────────────────────────────────────────────
  List<String> _fonts(BuildContext context) => [
    AppLocalizations.of(context)!.settingsFontFamilyDefaultLabel,
    'Sans',
    'Serif',
    'Cursive',
    'Elegant',
    'Sans Alt',
    'Geometric',
    'Monospace',
    'El Yazısı DE',
    'El Yazısı US',
  ];

  static String? _fontFamilyValue(String name) => dNoteFontFamilyValue(name);

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

  // ── Widget: Metin Boyutu seçici ─────────────────────────────────────
  void _showWidgetFontSizeSheet() {
    // Daha önce kaydedilmiş (veya varsayılan 14.0) değer yeni slider
    // aralığının (16-30) dışında kalabilir; Slider'a aralık dışı bir
    // value verilmesi assertion hatasına yol açar, bu yüzden sıkıştırılır.
    double tempSize = s._widgetFontSize.clamp(16, 30);
    showModalBottomSheet(
      context: context,
      backgroundColor: dNoteCardColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
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
                  AppLocalizations.of(context)!.settingsWidgetFontSizeLabel,
                  style: TextStyle(
                    color: dNoteTextColor(ctx),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.text_fields, color: Colors.grey, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Theme.of(context).primaryColor,
                          inactiveTrackColor: dNoteSurfaceVariant(ctx),
                          thumbColor: Theme.of(context).primaryColor,
                          overlayColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                          valueIndicatorColor: Theme.of(context).primaryColor,
                          valueIndicatorTextStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Slider(
                          value: tempSize,
                          min: 16,
                          max: 30,
                          divisions: 14,
                          label: '${tempSize.round()}',
                          onChanged: (v) => setSheet(() => tempSize = v),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.text_fields, color: Colors.grey, size: 24),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  AppLocalizations.of(context)!.settingsWidgetFontSizeSample(tempSize.round()),
                  style: TextStyle(
                    color: dNoteTextColor(ctx).withValues(alpha: 0.7),
                    fontSize: tempSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          AppLocalizations.of(context)!.settingsWidgetFontSizeCancelButton,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          s.setState(() => s._widgetFontSize = tempSize);
                          setState(() {});
                          s._saveData();
                          NoteWidgetService.instance.syncAppearanceSettings(
                            fontSize: s._widgetFontSize,
                            bgOpacity: s._widgetBgOpacity,
                            dark: s._widgetDark,
                          );
                          Navigator.pop(ctx);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.settingsWidgetFontSizeApplyButton,
                          style: const TextStyle(
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
  }

  // ── Widget: Arka Plan Saydamlığı seçici ─────────────────────────────
  void _showWidgetOpacitySheet() {
    double tempOpacity = s._widgetBgOpacity;
    showModalBottomSheet(
      context: context,
      backgroundColor: dNoteCardColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
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
                  AppLocalizations.of(context)!.settingsWidgetOpacityLabel,
                  style: TextStyle(
                    color: dNoteTextColor(ctx),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.opacity, color: Colors.grey, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Theme.of(context).primaryColor,
                          inactiveTrackColor: dNoteSurfaceVariant(ctx),
                          thumbColor: Theme.of(context).primaryColor,
                          overlayColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                          valueIndicatorColor: Theme.of(context).primaryColor,
                          valueIndicatorTextStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Slider(
                          value: tempOpacity,
                          min: 0.0,
                          max: 1.0,
                          divisions: 16,
                          label: '%${(tempOpacity * 100).round()}',
                          onChanged: (v) => setSheet(() => tempOpacity = v),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.opacity, color: Colors.grey, size: 24),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  AppLocalizations.of(context)!.settingsWidgetOpacityValue((tempOpacity * 100).round()),
                  style: TextStyle(
                    color: dNoteTextColor(ctx).withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          AppLocalizations.of(context)!.settingsWidgetOpacityCancelButton,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          s.setState(() => s._widgetBgOpacity = tempOpacity);
                          setState(() {});
                          s._saveData();
                          NoteWidgetService.instance.syncAppearanceSettings(
                            fontSize: s._widgetFontSize,
                            bgOpacity: s._widgetBgOpacity,
                            dark: s._widgetDark,
                          );
                          Navigator.pop(ctx);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.settingsWidgetOpacityApplyButton,
                          style: const TextStyle(
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
  }

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
                  AppLocalizations.of(context)!.settingsTextColorSheetTitle,
                  style: TextStyle(
                    color: dNoteTextColor(ctx),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.settingsTextColorSheetDesc,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
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
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Colors.black87],
                        stops: [0.5, 0.5],
                      ),
                      onTap: () {
                        s.setState(() => s._textColor = null);
                        setSheet(() {});
                        s._saveData();
                      },
                      child: Text(
                        'A',
                        style: TextStyle(
                          color: s._textColor == null
                              ? Theme.of(context).primaryColor
                              : Colors.grey[500],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
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
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      AppLocalizations.of(context)!.settingsTextColorOkButton,
                      style: const TextStyle(
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
  // GÜVENLİK: Not Şifresi + Güvenlik Sorusu
  // ─────────────────────────────────────────────────────────────────
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
          title: Text(
            AppLocalizations.of(context)!.settingsSecurityQuestionDialogTitle,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.settingsSecurityQuestionDialogDesc,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: selectedQuestion,
                isExpanded: true,
                dropdownColor: dNoteSurfaceVariant(ctx),
                style: TextStyle(color: dNoteTextColor(ctx), fontSize: 14),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.settingsSecurityQuestionDropdownHint,
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                items: _hintQuestions(context)
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
                  hintText: AppLocalizations.of(context)!.settingsSecurityQuestionAnswerHint,
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                AppLocalizations.of(context)!.settingsSecurityQuestionCancelButton,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
              onPressed: () {
                if (selectedQuestion == null ||
                    answerCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.settingsSecurityQuestionEmptyWarning),
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
              child: Text(
                AppLocalizations.of(context)!.settingsSecurityQuestionSaveButton,
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
            isNew
                ? AppLocalizations.of(context)!.settingsCreatePasswordTitle
                : AppLocalizations.of(context)!.settingsPasswordRequiredTitle,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isNew) ...[
                  TextField(
                    selectionWidthStyle: ui.BoxWidthStyle.tight,
                    contextMenuBuilder: buildCustomContextMenu,
                    selectionHeightStyle: ui.BoxHeightStyle.max,
                    controller: ctrl1,
                    obscureText: obscure1,
                    style: TextStyle(color: dNoteTextColor(ctx)),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.settingsPasswordEnterHint,
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
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
                  if (s._passwordHintQuestion.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () {
                          Navigator.pop(ctx);
                          s._showForgotPasswordDialog();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.settingsForgotPasswordButton,
                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ]
                else ...[
                  TextField(
                    selectionWidthStyle: ui.BoxWidthStyle.tight,
                    contextMenuBuilder: buildCustomContextMenu,
                    selectionHeightStyle: ui.BoxHeightStyle.max,
                    controller: ctrl1,
                    obscureText: obscure1,
                    style: TextStyle(color: dNoteTextColor(ctx)),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.settingsNewPasswordHint,
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
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
                      hintText: AppLocalizations.of(context)!.settingsConfirmPasswordHint,
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
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
                  Text(
                    AppLocalizations.of(context)!.settingsSecurityQuestionOptionalDesc,
                    style: TextStyle(color: dNoteTextColor(ctx), fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: selectedHintQuestion,
                    isExpanded: true,
                    dropdownColor: dNoteSurfaceVariant(ctx),
                    style: TextStyle(color: dNoteTextColor(ctx), fontSize: 14),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.settingsSecurityQuestionDropdownHint,
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    items: _hintQuestions(context)
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
                      hintText: AppLocalizations.of(context)!.settingsSecurityQuestionAnswerHint,
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dNoteBorderColor(ctx)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                AppLocalizations.of(context)!.settingsPasswordDialogCancelButton,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
              onPressed: () {
                if (isNew) {
                  if (ctrl1.text.isEmpty) return;
                  if (ctrl1.text != ctrl2.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.settingsPasswordMismatchWarning),
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
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.settingsWrongPasswordWarning),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text(
                isNew
                    ? AppLocalizations.of(context)!.settingsPasswordSaveButton
                    : AppLocalizations.of(context)!.settingsPasswordRemoveButton,
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

  // ─────────────────────────────────────────────────────────────────
  // TEMA (Sistem / Açık / Koyu) — mevcut diyalog korunuyor, ama artık
  // s._themeMode üzerinden s._saveData() ile kaydediyor. Böylece not
  // düzenleme gibi başka bir _saveData() çağrısı, kaydedilmemiş
  // (state'te güncellenmemiş) eski tema değerini geri yazıp temayı
  // sıfırlamıyor (önceki sürümdeki senkronizasyon hatası giderildi).
  // ─────────────────────────────────────────────────────────────────
  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setDlg) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.settingsThemeDialogTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(AppLocalizations.of(context)!.settingsThemeSystemDefault),
                  value: ThemeMode.system,
                  groupValue: s._themeMode,
                  onChanged: (val) => _updateTheme(ctx, val, setDlg),
                ),
                RadioListTile<ThemeMode>(
                  title: Text(AppLocalizations.of(context)!.settingsThemeLightOption),
                  value: ThemeMode.light,
                  groupValue: s._themeMode,
                  onChanged: (val) => _updateTheme(ctx, val, setDlg),
                ),
                RadioListTile<ThemeMode>(
                  title: Text(AppLocalizations.of(context)!.settingsThemeDarkOption),
                  value: ThemeMode.dark,
                  groupValue: s._themeMode,
                  onChanged: (val) => _updateTheme(ctx, val, setDlg),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // [dialogSetState]: diyaloğun kendi StatefulBuilder'ının setState'i.
  // s._themeMode değiştiği anda (henüz _saveData beklenirken) radio
  // seçimi diyalog içinde de hemen güncellensin diye çağrılır — aksi
  // halde disk yazma bitene kadar (Navigator.pop'a kadar) eski seçili
  // radio görünmeye devam ederdi.
  void _updateTheme(
    BuildContext context,
    ThemeMode? mode,
    void Function(void Function()) dialogSetState,
  ) async {
    if (mode == null) return;
    s.setState(() => s._themeMode = mode);
    dialogSetState(() {});
    appThemeMode.value = mode;
    await s._saveData();
    setState(() {});
    if (context.mounted) Navigator.pop(context);
  }

  // ─────────────────────────────────────────────────────────────────
  // DİL (Sistem / Türkçe / English) — Tema diyaloğuyla birebir aynı kalıp.
  // Gerçek kaynak appLanguage notifier'ıdır (bkz. theme.dart);
  // s._appLanguage yalnızca bu ekrandaki seçili durumu göstermek için
  // tutulur (note_list_lifecycle_mixin.dart).
  // ─────────────────────────────────────────────────────────────────
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setDlg) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.settingsLanguageDialogTitle),
            content: SizedBox(
              width: double.maxFinite,
              // Dil sayısı arttıkça listenin tamamı ekrana sığmayabilir.
              // Column + mainAxisSize.min, AlertDialog'un yükseklik sınırını
              // aşarak "BOTTOM OVERFLOWED" hatasına yol açıyordu. ListView +
              // shrinkWrap, dialog'un kendi maksimum yükseklik kısıtı
              // içinde (ekranın belli bir oranı) otomatik olarak scrollable
              // hale gelmesini sağlar; taşma yerine kaydırma olur.
              child: ListView(
                shrinkWrap: true,
                children: [
                  // "Sistem" seçeneği bir dil değil, davranış tercihi
                  // olduğu için alfabetik sıralamanın dışında tutulup
                  // her zaman en üstte gösterilir.
                  RadioListTile<String>(
                    title: Text(
                      AppLocalizations.of(context)!.settingsLanguageSystemOption,
                      style: const TextStyle(fontSize: 16),
                    ),
                    value: 'system',
                    groupValue: s._appLanguage,
                    onChanged: (val) => _updateLanguage(ctx, val, setDlg),
                    dense: true,
                  ),
                  // ── Diller: alfabetik sırayla ────────────────────────
                  // Aşağıdaki liste kasıtlı olarak sırasız tutulur; sıralama
                  // build sırasında otomatik yapılır (koda göre değil,
                  // görünen isme göre, Dart'ın varsayılan codepoint
                  // karşılaştırmasıyla). Bu sayede yeni bir dil eklemek
                  // için listeye tek satır eklemek yeterlidir — sıralamayı
                  // elle güncellemeye gerek kalmaz, her zaman bu kurala
                  // (alfabetik sıra) otomatik uyar.
                  ...(() {
                    final entries = <MapEntry<String, String>>[
                      const MapEntry('tr', 'Türkçe'),
                      const MapEntry('en', 'English'),
                      const MapEntry('de', 'Deutsch'),
                      const MapEntry('fr', 'Français'),
                      const MapEntry('it', 'Italiano'),
                      const MapEntry('es', 'Español'),
                      const MapEntry('pt', 'Português'),
                      const MapEntry('ru', 'Русский'),
                      const MapEntry('ja', '日本語'),
                      const MapEntry('zh', '中文'),
                      const MapEntry('ko', '한국어'),
                      const MapEntry('hi', 'हिन्दी'),
                      const MapEntry('id', 'Bahasa Indonesia'),
                      const MapEntry('vi', 'Tiếng Việt'),
                      const MapEntry('th', 'ไทย'),
                      const MapEntry('pl', 'Polski'),
                      const MapEntry('nl', 'Nederlands'),
                      const MapEntry('sv', 'Svenska'),
                      const MapEntry('ar', 'العربية'),
                      const MapEntry('he', 'עברית'),
                      const MapEntry('uk', 'Українська'),
                      const MapEntry('ro', 'Română'),
                      const MapEntry('cs', 'Čeština'),
                      const MapEntry('da', 'Dansk'),
                      const MapEntry('no', 'Norsk'),
                      const MapEntry('fi', 'Suomi'),
                      // Yeni dil eklerken buraya bir satır eklemek yeterli;
                      // aşağıdaki sort otomatik doğru sıraya koyar.
                    ]..sort((a, b) => a.value.compareTo(b.value));
                    return entries.map(
                      (e) => RadioListTile<String>(
                        title: Text(
                          e.value,
                          style: const TextStyle(fontSize: 16),
                        ),
                        value: e.key,
                        groupValue: s._appLanguage,
                        onChanged: (val) => _updateLanguage(ctx, val, setDlg),
                        dense: true,
                      ),
                    );
                  })(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // [dialogSetState]: bkz. _updateTheme'deki aynı isimli parametrenin
  // açıklaması — seçili radio, kaydetme beklenirken bile diyalog içinde
  // hemen güncellensin diye.
  void _updateLanguage(
    BuildContext context,
    String? lang,
    void Function(void Function()) dialogSetState,
  ) async {
    if (lang == null) return;
    s.setState(() => s._appLanguage = lang);
    dialogSetState(() {});
    appLanguage.value = lang;
    await s._saveData();
    setState(() {});
    if (context.mounted) Navigator.pop(context);
  }

  // ─────────────────────────────────────────────────────────────────
  // VURGU RENGİ — "Tema Değiştir" ile aynı diyalog/kayıt kalıbı, ama
  // ThemeMode yerine hazır bir renk paletinden seçim yapılıyor. Gerçek
  // kaynak appAccentColor notifier'ıdır (bkz. theme.dart); s._accentColor
  // yalnızca bu ekrandaki seçili durumu göstermek için tutulur.
  // ─────────────────────────────────────────────────────────────────
  static const List<Color> _accentColorPalette = [
    Colors.amber,
    Colors.deepOrange,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
  ];

  void _showAccentColorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setDlg) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.settingsAccentColorDialogTitle),
            content: SizedBox(
              width: double.maxFinite,
              child: Wrap(
                spacing: 14,
                runSpacing: 14,
                children: _accentColorPalette.map((color) {
                  final bool selected =
                      color.toARGB32() == s._accentColor.toARGB32();
                  return GestureDetector(
                    onTap: () => _updateAccentColor(ctx, color, setDlg),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: selected
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.6),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: selected
                          ? const Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 20,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  // [dialogSetState]: bkz. _updateTheme'deki aynı isimli parametrenin
  // açıklaması — seçili renk halkası/tik işareti, kaydetme beklenirken
  // bile diyalog içinde hemen güncellensin diye.
  void _updateAccentColor(
    BuildContext context,
    Color color,
    void Function(void Function()) dialogSetState,
  ) async {
    s.setState(() => s._accentColor = color);
    dialogSetState(() {});
    appAccentColor.value = color;
    await s._saveData();
    setState(() {});
    if (context.mounted) Navigator.pop(context);
  }

  // ─────────────────────────────────────────────────────────────────
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
        title: Text(
          AppLocalizations.of(context)!.settingsPageTitle,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            // ── 1. GENEL ─────────────────────────────────────────────────
            // Dil, görsel/renk bir tercih olmadığı (Tema bölümündeki
            // diğer ayarların aksine) davranışsal bir ayar olduğu için
            // artık kendi bölümünde; ayrıca en üstte olması, kullanıcıların
            // genelde ilk aradığı ayarlardan biri olmasıyla da örtüşüyor.
            _sectionHeader(AppLocalizations.of(context)!.settingsSectionGeneral),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: dNoteCardColor(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _settingTile(
                    icon: Icons.language_outlined,
                    iconColor: Colors.tealAccent,
                    title: AppLocalizations.of(context)!.settingsLanguageTileTitle,
                    subtitle: switch (s._appLanguage) {
                      'tr' => 'Türkçe',
                      'en' => 'English',
                      'de' => 'Deutsch',
                      'fr' => 'Français',
                      'it' => 'Italiano',
                      'es' => 'Español',
                      'pt' => 'Português',
                      'ru' => 'Русский',
                      'ja' => '日本語',
                      'zh' => '中文',
                      'ko' => '한국어',
                      'hi' => 'हिन्दी',
                      'id' => 'Bahasa Indonesia',
                      'vi' => 'Tiếng Việt',
                      'th' => 'ไทย',
                      'pl' => 'Polski',
                      'nl' => 'Nederlands',
                      'sv' => 'Svenska',
                      'ar' => 'العربية',
                      'he' => 'עברית',
                      'uk' => 'Українська',
                      'ro' => 'Română',
                      'cs' => 'Čeština',
                      'da' => 'Dansk',
                      'no' => 'Norsk',
                      'fi' => 'Suomi',
                      _ => AppLocalizations.of(context)!.settingsLanguageSystemOption,
                    },
                    trailing: null,
                    onTap: () => _showLanguageDialog(context),
                  ),
                ],
              ),
            ),

            // ── 2. GÜVENLİK ─────────────────────────────────────────────
            _sectionHeader(AppLocalizations.of(context)!.settingsSectionSecurity),
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
                    title: AppLocalizations.of(context)!.settingsNotePasswordTitle,
                    subtitle: s._notePasswordEnabled
                        ? AppLocalizations.of(context)!.settingsPasswordSetSubtitle
                        : AppLocalizations.of(context)!.settingsPasswordNotSetSubtitle,
                    trailing: Switch(
                      value: s._notePasswordEnabled,
                      activeThumbColor: Theme.of(context).primaryColor,
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
                      title: AppLocalizations.of(context)!.settingsSecurityQuestionTileTitle,
                      subtitle: s._passwordHintQuestion.isNotEmpty
                          ? AppLocalizations.of(context)!.settingsSecurityQuestionSetSubtitle
                          : AppLocalizations.of(context)!.settingsSecurityQuestionNotSetSubtitle,
                      trailing: null,
                      onTap: () => _showHintQuestionDialog(),
                    ),
                  ],
                ],
              ),
            ),

            // ── 3. TEMA ──────────────────────────────────────────────────
            _sectionHeader(AppLocalizations.of(context)!.settingsSectionTheme),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: dNoteCardColor(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _settingTile(
                    icon: Icons.palette_outlined,
                    iconColor: Colors.indigoAccent,
                    title: AppLocalizations.of(context)!.settingsThemeChangeTileTitle,
                    subtitle: switch (s._themeMode) {
                      ThemeMode.light => AppLocalizations.of(context)!.settingsThemeLightLabel,
                      ThemeMode.dark => AppLocalizations.of(context)!.settingsThemeDarkLabel,
                      ThemeMode.system => AppLocalizations.of(context)!.settingsThemeSystemLabel,
                    },
                    trailing: null,
                    onTap: () => _showThemeDialog(context),
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    height: 1,
                    indent: 56,
                  ),
                  _settingTile(
                    icon: Icons.color_lens_outlined,
                    iconColor: dNoteResolveAccentColor(
                      s._accentColor,
                      Theme.of(context).brightness == Brightness.dark,
                    ),
                    title: AppLocalizations.of(context)!.settingsAccentColorTileTitle,
                    subtitle: AppLocalizations.of(context)!.settingsAccentColorTileSubtitle,
                    trailing: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: dNoteResolveAccentColor(
                          s._accentColor,
                          Theme.of(context).brightness == Brightness.dark,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    onTap: () => _showAccentColorDialog(context),
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    height: 1,
                    indent: 56,
                  ),
                  _settingTile(
                    icon: Icons.color_lens_outlined,
                    iconColor: Colors.orangeAccent,
                    title: AppLocalizations.of(context)!.settingsColorfulNotesTitle,
                    subtitle: AppLocalizations.of(context)!.settingsColorfulNotesSubtitle,
                    trailing: Switch(
                      value: s._colorfulNotes,
                      activeThumbColor: Theme.of(context).primaryColor,
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

            // ── 4. KİŞİSELLEŞTİRME ──────────────────────────────────────
            _sectionHeader(AppLocalizations.of(context)!.settingsSectionPersonalization),
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
                    title: AppLocalizations.of(context)!.settingsFontFamilyTileTitle,
                    subtitle: s._fontFamily,
                    trailing: null,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: dNoteCardColor(context),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        // Font listesi 10 öğeye çıktığı için (6 yeni font
                        // eklendi) sabit yükseklikli Column artık küçük
                        // ekranlarda taşabilir. isScrollControlled + ekran
                        // yüksekliğine oranlı bir üst sınır ile liste
                        // kendi içinde kaydırılabilir hale getirildi.
                        isScrollControlled: true,
                        builder: (_) => SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.7,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.settingsFontFamilyTileTitle,
                                    style: TextStyle(
                                      color: dNoteTextColor(context),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Flexible(
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: _fonts(context)
                                          .map(
                                            (f) => ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              title: Text(
                                                f,
                                                style: TextStyle(
                                                  color: s._fontFamily == f
                                                      ? Theme.of(context).primaryColor
                                                      : dNoteTextColor(context),
                                                  fontFamily: _fontFamilyValue(f),
                                                ),
                                              ),
                                              trailing: s._fontFamily == f
                                                  ? Icon(
                                                      Icons.check_circle,
                                                      color: Theme.of(context).primaryColor,
                                                    )
                                                  : null,
                                              onTap: () {
                                                s.setState(() => s._fontFamily = f);
                                                setState(() {});
                                                s._saveData();
                                                Navigator.pop(context);
                                              },
                                            ),
                                          )
                                          .toList(),
                                    ),
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
                  // Metin boyutu
                  _settingTile(
                    icon: Icons.text_fields,
                    iconColor: Colors.pinkAccent,
                    title: AppLocalizations.of(context)!.settingsGlobalFontSizeTileTitle,
                    subtitle: AppLocalizations.of(context)!.settingsGlobalFontSizeTileSubtitle(
                      s._globalFontSize.round(),
                    ),
                    trailing: null,
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
                                    AppLocalizations.of(context)!.settingsGlobalFontSizeTileTitle,
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
                                                activeTrackColor: Theme.of(context).primaryColor,
                                                inactiveTrackColor:
                                                    dNoteSurfaceVariant(ctx),
                                                thumbColor: Theme.of(context).primaryColor,
                                                overlayColor: Theme.of(context).primaryColor
                                                    .withValues(alpha: 0.2),
                                                valueIndicatorColor:
                                                    Theme.of(context).primaryColor,
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
                                    AppLocalizations.of(context)!.settingsGlobalFontSizeSamplePreview(
                                      tempSize.round(),
                                    ),
                                    style: TextStyle(
                                      color: dNoteTextColor(
                                        ctx,
                                      ).withValues(alpha: 0.7),
                                      fontSize: tempSize,
                                      fontFamily: dNoteFontFamilyValue(
                                        s._fontFamily,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: applyToAll,
                                        activeColor: Theme.of(context).primaryColor,
                                        onChanged: (v) => setSheet(
                                          () => applyToAll = v ?? false,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)!.settingsGlobalFontSizeApplyToAllLabel,
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                      bottom: 16,
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.settingsGlobalFontSizeApplyToAllNote,
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
                                          child: Text(
                                            AppLocalizations.of(context)!.settingsGlobalFontSizeCancelButton,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context).primaryColor,
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
                                          child: Text(
                                            AppLocalizations.of(context)!.settingsGlobalFontSizeApplyButton,
                                            style: const TextStyle(
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
                    title: AppLocalizations.of(context)!.settingsTextColorTileTitle,
                    subtitle: AppLocalizations.of(context)!.settingsTextColorTileSubtitle,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: dNoteEffectiveTextColor(context, s._textColor),
                            border: Border.all(color: Colors.grey[600]!),
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
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
                    iconColor: Theme.of(context).primaryColor,
                    title: AppLocalizations.of(context)!.settingsPreviewLinesTileTitle,
                    subtitle: AppLocalizations.of(context)!.settingsPreviewLinesTileSubtitle(
                      s._previewLines,
                    ),
                    trailing: null,
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
                                    AppLocalizations.of(context)!.settingsPreviewLinesTileTitle,
                                    style: TextStyle(
                                      color: dNoteTextColor(ctx),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    AppLocalizations.of(context)!.settingsPreviewLinesCurrentLabel(
                                      tempLines,
                                    ),
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Theme.of(context).primaryColor,
                                      inactiveTrackColor: dNoteSurfaceVariant(
                                        ctx,
                                      ),
                                      thumbColor: Theme.of(context).primaryColor,
                                      overlayColor: Theme.of(context).primaryColor.withValues(
                                        alpha: 0.2,
                                      ),
                                      valueIndicatorColor: Theme.of(context).primaryColor,
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
                                      AppLocalizations.of(context)!.settingsPreviewLinesDescription,
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
                                          child: Text(
                                            AppLocalizations.of(context)!.settingsPreviewLinesCancelButton,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context).primaryColor,
                                          ),
                                          onPressed: () {
                                            s.setState(
                                              () => s._previewLines = tempLines,
                                            );
                                            setState(() {});
                                            s._saveData();
                                            Navigator.pop(ctx);
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!.settingsPreviewLinesApplyButton,
                                            style: const TextStyle(
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

            // NOT: Yedekleme bölümü buradan kaldırıldı. Manuel yedekle/geri
            // yükle, yedek geçmişi ve otomatik yedekleme ayarları artık tek
            // bir yerde toplanıyor: çekmece menüsündeki "Yedekle & Geri
            // Yükle" girişi (BackupRestoreScreen). Bkz.
            // note_list_build_mixin.dart ve backup_restore_screen.dart.

            // ── 5. WİDGET ────────────────────────────────────────────────
            _sectionHeader(AppLocalizations.of(context)!.settingsSectionWidget),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: dNoteCardColor(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _settingTile(
                    icon: Icons.text_fields,
                    iconColor: Colors.cyanAccent,
                    title: AppLocalizations.of(context)!.settingsWidgetFontSizeLabel,
                    subtitle: '${s._widgetFontSize.round()} pt',
                    trailing: null,
                    onTap: _showWidgetFontSizeSheet,
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    height: 1,
                    indent: 56,
                  ),
                  _settingTile(
                    icon: Icons.opacity,
                    iconColor: Colors.lightBlueAccent,
                    title: AppLocalizations.of(context)!.settingsWidgetOpacityLabel,
                    subtitle: '%${(s._widgetBgOpacity * 100).round()}',
                    trailing: null,
                    onTap: _showWidgetOpacitySheet,
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    height: 1,
                    indent: 56,
                  ),
                  _settingTile(
                    icon: Icons.dark_mode_outlined,
                    iconColor: Colors.deepPurpleAccent,
                    title: AppLocalizations.of(context)!.settingsWidgetDarkModeTitle,
                    subtitle: AppLocalizations.of(context)!.settingsWidgetDarkModeDesc,
                    trailing: Switch(
                      value: s._widgetDark,
                      activeThumbColor: Theme.of(context).primaryColor,
                      onChanged: (v) {
                        s.setState(() => s._widgetDark = v);
                        setState(() {});
                        s._saveData();
                        NoteWidgetService.instance.syncAppearanceSettings(
                          fontSize: s._widgetFontSize,
                          bgOpacity: s._widgetBgOpacity,
                          dark: s._widgetDark,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ── 6. UYGULAMA HAKKINDA ─────────────────────────────────────
            _sectionHeader(AppLocalizations.of(context)!.settingsSectionAbout),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: dNoteCardColor(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _settingTile(
                    icon: Icons.info_outline,
                    iconColor: Colors.grey,
                    title: AppLocalizations.of(context)!.settingsAboutVersionTitle,
                    subtitle: 'v1.0.0',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ── Metin Rengi seçicideki tek bir renk dairesi ───────────────────────────
// `color` verilmezse ve `gradient` de verilmezse boş kalır. `gradient`
// verilirse (Varsayılan seçeneği) daire, iç içe kare bir child widget
// yerine DOĞRUDAN kendi BoxDecoration'ına gradyanı uygular — bu sayede
// dairesel kırpma (clip) ile kare bir child'ı birleştirmeye gerek kalmaz
// ve kenarlarda kırpmadan kaynaklanan boşluk/uyumsuzluk oluşmaz.
class _TextColorSwatch extends StatelessWidget {
  final Color? color;
  final Gradient? gradient;
  final bool selected;
  final VoidCallback onTap;
  final Widget? child;

  const _TextColorSwatch({
    this.color,
    this.gradient,
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
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: gradient == null ? color : null,
          gradient: gradient,
          border: Border.all(
            color: selected ? Theme.of(context).primaryColor : Colors.grey[500]!,
            width: selected ? 2.5 : 1,
          ),
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}
