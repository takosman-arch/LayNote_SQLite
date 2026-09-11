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
    return CustomPaint(
      size: Size(size, size),
      painter: _FlagShapePainter(
        color: _flagColorFromHex(flagColor),
        filled: true,
        vertical: true,
      ),
    );
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
                const SizedBox(height: 14),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < _flagPalette.length; i++)
                      Builder(builder: (_) {
                        final hex = _flagPalette[i];
                        final color = _flagColorFromHex(hex);
                        final isSelected = currentColor == hex;
                        final isLast = i == _flagPalette.length - 1;
                        return Padding(
                          padding: EdgeInsets.only(right: isLast ? 0 : 12),
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
