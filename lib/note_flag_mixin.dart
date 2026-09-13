part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// BAYRAK (FLAMA) ÖZELLİĞİ
// Not başlığının sağında gösterilen, tıklanınca renk seçtiren küçük bir
// işaret. Renk seçilmemişse boş/dış hatlı, seçilmişse o renkle dolu
// görünür. Şekil TradingView'daki etiket/flama görünümüne benzer: üst
// kenarı düz, alt kenarı içe doğru V şeklinde çentikli (çentik aşağı
// bakar) — Material'ın hazır "flag" ikonundan (direğe takılı bayrak)
// kasıtlı olarak farklıdır.
//
// Veri modelinde bu durum notun 'flagColor' alanında tutulur:
//   null            -> bayrak yok (boş/dış hatlı gösterilir)
//   '#RRGGBB' string -> seçili renk (bkz. _flagPalette)
// Bkz. db_helper.dart (flagColor TEXT sütunu, v13 migration).
// ════════════════════════════════════════════════════════════════════════

mixin NoteFlagMixin on State<NoteListScreen> {
  // Sabit renk paleti. Sırası, seçim panelinde soldan sağa gösterilir.
  static const List<String> _flagPalette = [
    '#F44336', // kırmızı
    '#FF9800', // turuncu
    '#FFEB3B', // sarı
    '#4CAF50', // yeşil
    '#2196F3', // mavi
  ];

  Color _flagColorFromHex(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  // _flagPalette'teki her rengin varsayılan Türkçe adı. Kullanıcı henüz
  // o renge özel bir isim vermediyse (bkz. _flagColorName), seçenek
  // sheet'inin başlığında ('#2196F3' gibi) çıplak hex kodu yerine bu isim
  // gösterilir (kullanıcı isteği). Anahtar karşılaştırması büyük/küçük
  // harf duyarsız yapılır (bkz. toUpperCase) — notlarda eski/farklı
  // kaynaklı hex string'leri küçük harfle kayıtlı olabilir.
  Map<String, String> _defaultFlagColorLabels(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return {
      '#F44336': l10n.flagColorNameRed,
      '#FF9800': l10n.flagColorNameOrange,
      '#FFEB3B': l10n.flagColorNameYellow,
      '#4CAF50': l10n.flagColorNameGreen,
      '#2196F3': l10n.flagColorNameBlue,
    };
  }

  String _defaultFlagColorLabel(BuildContext context, String hex) =>
      _defaultFlagColorLabels(context)[hex.toUpperCase()] ?? hex;

  // Bir bayrak rengine kullanıcının verdiği isim (varsa). Global
  // 'flagColorNames' notifier'ından okunur (bkz. main.dart, db_helper.dart
  // -> getFlagColorNames/setFlagColorName). İsim atanmamışsa null döner.
  String? _flagColorName(String hex) => flagColorNames.value[hex];

  // Başlığın sağına konan flama ikonu. flagColor null ise dış hatlı
  // (sadece kenar çizgisi), doluysa o renkle boyanmış olarak çizilir.
  Widget _buildFlagIcon({
    required String? flagColor,
    double size = 22,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    final hasColor = flagColor != null;
    // İşaretlenmemiş (renksiz) hâldeyken, başlık alanındaki ipucu
    // yazısıyla (titleFieldHint) aynı sabit gri tonu kullanır — temaya
    // göre değişen dNoteBorderColor yerine.
    final color = hasColor ? _flagColorFromHex(flagColor) : Colors.grey;
    final icon = CustomPaint(
      size: Size(size, size),
      // vertical: true -> çentik sağ kenarda değil alt kenarda (aşağı
      // bakar); önizlemedeki rozetle (_buildFlagBadge) aynı yönelim.
      painter: _FlagShapePainter(
        color: color,
        filled: hasColor,
        vertical: true,
      ),
    );
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: tooltip != null ? Tooltip(message: tooltip, child: icon) : icon,
      ),
    );
  }

  // Kart önizlemesinde kartın köşesinde gösterilen küçük, sabit
  // (tıklanamaz) rozet. flagColor null ise hiçbir şey çizmez — çağıran
  // taraf zaten yalnızca dolu olduğunda bu widget'ı eklemeli. Şekil
  // DİKEY çizilir (düz kenar üstte, çentik altta) — düzenleme
  // ekranındaki _buildFlagIcon ile artık aynı yönelim.
  Widget _buildFlagBadge({required String flagColor, double size = 14}) {
    final badge = CustomPaint(
      size: Size(size, size),
      painter: _FlagShapePainter(
        color: _flagColorFromHex(flagColor),
        filled: true,
        vertical: true,
      ),
    );
    // İsim atanmışsa, rozete basılı tutulunca (Tooltip'in dokunmatik
    // cihazlardaki varsayılan tetikleyicisi) ismi gösterir. İsim yoksa
    // Tooltip'i hiç sarmalamıyoruz — boş bir mesajla dokunma hedefi
    // eklememek için.
    final name = _flagColorName(flagColor);
    if (name == null) return badge;
    return Tooltip(message: name, child: badge);
  }

  // Renk seçim panelini açar. Bir renk seçilince ya da "kaldır"a
  // basılınca onColorSelected çağrılır (null = bayrağı kaldır); panel
  // dışına dokunulup iptal edilirse hiçbir şey çağrılmaz.
  //
  // Alttan açılan bir bottom sheet yerine, üç nokta (PopupMenuButton)
  // menüsüyle AYNI mekanizma (showMenu) ve AYNI açılma animasyonuyla
  // (büyüyerek beliren küçük panel) gösterilir. Renk örnekleri artık
  // yuvarlak daire değil, _FlagShapePainter ile çizilen bayrak
  // şeklinde — hem kart rozeti hem üç nokta menüsündeki ikonla tutarlı.
  static const String _flagRemoveSentinel = '__remove_flag__';

  Future<void> _showFlagColorPicker({
    required String? currentColor,
    required ValueChanged<String?> onColorSelected,
  }) async {
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final topOffset = MediaQuery.of(context).padding.top + kToolbarHeight;

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        overlay.size.width - 8,
        topOffset,
        8,
        0,
      ),
      color: dNoteCardColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      items: [
        PopupMenuItem<String>(
          enabled: false,
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.flagColorPickerTitle,
                  style: TextStyle(
                    color: dNoteTextColor(context),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < _flagPalette.length; i++)
                      Builder(builder: (_) {
                        final hex = _flagPalette[i];
                        final color = _flagColorFromHex(hex);
                        final isSelected = currentColor == hex;
                        final isLast = i == _flagPalette.length - 1;
                        return Padding(
                          padding: EdgeInsets.only(right: isLast ? 0 : 8),
                          child: SizedBox(
                            width: 40,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context, hex),
                              child: Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: isSelected
                                      ? Border.all(
                                          color: dNoteTextColor(context),
                                          width: 2,
                                        )
                                      : null,
                                ),
                                child: CustomPaint(
                                  size: const Size(22, 22),
                                  painter: _FlagShapePainter(
                                    color: color,
                                    filled: true,
                                    vertical: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                  ],
                ),
                if (currentColor != null) ...[
                  Divider(color: Theme.of(context).dividerColor, height: 24),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => Navigator.pop(context, _flagRemoveSentinel),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.close, color: Colors.red, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context)!
                                .flagColorRemoveOption,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );

    if (selected == null) return;

    onColorSelected(selected == _flagRemoveSentinel ? null : selected);
  }

  // Bir bayrak rengine basılı tutulunca açılan "Yeniden Adlandır / Sil"
  // seçenek sheet'i — etiket şeridindeki showTagOptionsSheet (bkz.
  // note_tags_sheet.dart) ile AYNI görsel dil ve mekanizma: alttan açılan
  // bir showModalBottomSheet, başlıkta simge + isim/hex, altında iki
  // ListTile. "Sil" seçilince [onDelete] çağrılır — asıl silme (rengi
  // TÜM notlardan kaldırmak, bkz. NoteListBuildMixin._deleteFlagColorInList)
  // burada değil çağıran tarafta yapılır, çünkü bu mixin not listesine
  // (_notes/_deletedNotes) erişemez. "Sil" seçeneği yalnızca renge zaten
  // bir isim atanmışsa gösterilir (atanmamış bir bayrağı silmenin bir
  // anlamı yok).
  Future<void> _showFlagNameOptionsSheet(
    String hex, {
    required VoidCallback onDelete,
  }) async {
    final currentName = _flagColorName(hex);
    await showModalBottomSheet(
      context: context,
      backgroundColor: dNoteCardColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    CustomPaint(
                      size: const Size(18, 18),
                      painter: _FlagShapePainter(
                        color: _flagColorFromHex(hex),
                        filled: true,
                        vertical: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        currentName ?? _defaultFlagColorLabel(sheetCtx, hex),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: dNoteTextColor(sheetCtx),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.edit_outlined,
                  color: dNoteTextColor(sheetCtx),
                ),
                title: Text(
                  AppLocalizations.of(sheetCtx)!.tagOptionsRenameLabel,
                  style: TextStyle(color: dNoteTextColor(sheetCtx)),
                ),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _showFlagNameDialog(hex);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: Text(
                  AppLocalizations.of(sheetCtx)!.tagOptionsDeleteLabel,
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  onDelete();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // Boş isimle kaydetmenin (_showFlagNameDialog) ve NoteListBuildMixin'in
  // bayrağı tamamen silme akışının (bkz. _deleteFlagColorInList — bu
  // fonksiyon abstract bildirim üzerinden buraya erişir) ortak kullandığı
  // yardımcı: rengin ismini hem kalıcı depodan hem global
  // 'flagColorNames' notifier'ından kaldırır.
  Future<void> _removeFlagColorName(String hex) async {
    await DBHelper.instance.setFlagColorName(hex, null);
    final updated = Map<String, String>.from(flagColorNames.value);
    updated.remove(hex);
    flagColorNames.value = updated;
  }

  // Belirli bir bayrak rengine isim atamak/değiştirmek için basit bir
  // metin girişi diyaloğu. flagColorNames global notifier'ını ve kalıcı
  // depoyu (DBHelper -> 'settings' tablosu) birlikte günceller. Artık
  // yalnızca _showFlagNameOptionsSheet'teki "Yeniden Adlandır"
  // seçeneğinden açılır (silme işi ayrı bir seçeneğe taşındı, bkz.
  // yukarısı).
  //
  // Diyaloğun içeriği (_FlagNameDialogContent) ayrı bir StatefulWidget:
  // TextEditingController'ı kendi initState/dispose'unda yönetir. Daha
  // önce controller burada (dialog dışında) oluşturulup showDialog
  // döndükten HEMEN sonra dispose ediliyordu; ama kapanış animasyonu o
  // an hâlâ sürdüğünden TextField bir frame daha eski (disposed)
  // controller'a erişmeye çalışıp "A TextEditingController was used
  // after being disposed" hatası veriyordu. Controller'ın ömrünü
  // dialog'un kendi State'ine bağlamak bu sırayı garantiye alıyor.
  Future<void> _showFlagNameDialog(String hex) async {
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => _FlagNameDialogContent(
        initialName: _flagColorName(hex) ?? '',
        color: _flagColorFromHex(hex),
      ),
    );

    if (result == null || !mounted) return; // Vazgeçildi.

    final trimmed = result.trim();
    if (trimmed.isEmpty) {
      await _removeFlagColorName(hex);
      return;
    }
    await DBHelper.instance.setFlagColorName(hex, trimmed);
    final updated = Map<String, String>.from(flagColorNames.value);
    updated[hex] = trimmed;
    flagColorNames.value = updated;
  }
}

// _showFlagNameDialog için diyalog içeriği. TextEditingController'ı
// kendi yaşam döngüsünde (initState/dispose) yönetir — bkz. yukarıdaki
// açıklama.
class _FlagNameDialogContent extends StatefulWidget {
  const _FlagNameDialogContent({
    required this.initialName,
    required this.color,
  });

  final String initialName;
  final Color color;

  @override
  State<_FlagNameDialogContent> createState() =>
      _FlagNameDialogContentState();
}

class _FlagNameDialogContentState extends State<_FlagNameDialogContent> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPaint(
            size: const Size(18, 18),
            painter: _FlagShapePainter(
              color: widget.color,
              filled: true,
              vertical: true,
            ),
          ),
          const SizedBox(width: 10),
          Text(AppLocalizations.of(context)!.flagNameDialogTitle),
        ],
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 24,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.flagNameDialogHint,
        ),
        onSubmitted: (value) => Navigator.pop(context, value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.flagNameDialogCancelButton),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: Text(AppLocalizations.of(context)!.flagNameDialogSaveButton),
        ),
      ],
    );
  }
}

// TradingView tarzı flama/etiket şekli. Dikey modda (vertical=true —
// hem düzenleme ekranındaki başlık ikonu hem kart önizlemesindeki
// rozet bunu kullanır): üst kenarı düz, alt kenarı içe doğru V
// şeklinde çentikli (çentik aşağı bakar). Yatay modda (vertical=false,
// artık kullanılmıyor ama referans için duruyor): sol kenarı çentikli,
// sağ kenarı düz — dikey olanın 90° döndürülmüş hali. filled=false
// iken yalnızca kenar çizgisi (boş/seçilmemiş hâl), filled=true iken
// içi dolu (seçili hâl) çizilir.
class _FlagShapePainter extends CustomPainter {
  final Color color;
  final bool filled;
  final bool vertical;

  _FlagShapePainter({
    required this.color,
    required this.filled,
    this.vertical = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final Path path;
    if (vertical) {
      final notch = h * 0.32;
      path = Path()
        ..moveTo(0, 0)
        ..lineTo(w, 0)
        ..lineTo(w, h)
        ..lineTo(w / 2, h - notch)
        ..lineTo(0, h)
        ..close();
    } else {
      final notch = w * 0.32;
      path = Path()
        ..moveTo(w, 0)
        ..lineTo(0, 0)
        ..lineTo(notch, h / 2)
        ..lineTo(0, h)
        ..lineTo(w, h)
        ..close();
    }

    final paint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FlagShapePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.filled != filled ||
      oldDelegate.vertical != vertical;
}
