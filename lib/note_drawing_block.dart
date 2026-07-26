part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// ÇİZİM BLOĞU (NoteDrawingBlock)
// Not içeriğine gömülü, vektör tabanlı basit bir çizim tuvali. Her el
// hareketi (stroke) renk + kalınlık + nokta listesi olarak saklanır (bkz.
// content_blocks.dart'taki "drawing" blok şeması) ve bir CustomPainter ile
// çizilir. Bu sayede not tekrar açıldığında çizime kaldığı yerden devam
// edilebilir, farklı ekran boyutlarında kalite kaybı olmaz.
//
// Bu widget'ın geri al/ileri al'ı notun genel editHistory'sinden BAĞIMSIZDIR
// (aynı UndoRedoStack sınıfı yeniden kullanılıyor, ama kendi örneği ile).
// Notun genel undo'suna sadece bloğun kendisinin eklenmesi/silinmesi girer;
// tuval üzerindeki tek tek stroke'lar not genelindeki Ctrl+Z'ye karışmaz.
// ════════════════════════════════════════════════════════════════════════

// Kalem için hazır renk paleti. Beyaz ve siyah her iki temada da (koyu/açık
// arka plan) en az bir tanesi görünür kalsın diye bilerek ikisi de var.
const List<Color> kDrawingColorPresets = [
  Color(0xFFFFFFFF),
  Color(0xFF000000),
  Color(0xFFFFC400),
  Color(0xFFFF1744),
  Color(0xFF2979FF),
  Color(0xFF00E676),
];

// Kalem kalınlığı ön ayarları (mantıksal piksel).
const List<double> kDrawingWidthPresets = [2.5, 5.0, 9.0];

// Silginin bir stroke'u "yakaladığı" kabul edilen yarıçap (mantıksal px).
const double _kEraseRadius = 16.0;

// Gömülü (küçük) çizim tuvalinin varsayılan yüksekliği. NoteScreenshotService
// ve PdfExportService, düzenleyicideki görünümle birebir aynı en/boy oranını
// yakalayabilmek için bu sabiti referans alır (bkz. Aşama 3).
const double kDrawingDefaultCanvasHeight = 220.0;

// Tek bir çizim bloğunun (block['strokes']) render + düzenleme mantığını
// kapsar. [strokes] parametresi başlangıç değeri olarak kullanılır; widget
// kendi iç kopyasını tutar ve her tamamlanmış değişiklikte [onChanged] ile
// dışarıya (blocks[i]['strokes']'a yazılmak üzere) bildirir.
class NoteDrawingBlock extends StatefulWidget {
  final List<Map<String, dynamic>> strokes;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;
  final Color borderColor;
  final double canvasHeight;

  // Aşama 3: Tam ekran genişletme. [isFullscreen] true olduğunda araç
  // çubuğunda "genişlet" yerine bu örneğin tam ekran sunumunda olduğunu
  // belirtir (kendi "küçült" kontrolü AppBar'da yaşar, bkz.
  // _openFullscreen). Gömülü (küçük) kullanım bu ikisini hiç vermez.
  final bool isFullscreen;

  // Gömülü (küçük) önizlemede uzun basınca çağrılır: notun ek/fotoğraf
  // kutucuklarındaki (_AttachmentTile) "uzun bas -> sil ikonu çıkar" deseniyle
  // birebir aynı davranış için. null ise (ör. tam ekranda) uzun basma hiçbir
  // şey yapmaz. Tetiklendiğinde çağıran taraf, bloğun tamamını not içeriğinden
  // kaldırmalıdır.
  final VoidCallback? onDelete;

  const NoteDrawingBlock({
    super.key,
    required this.strokes,
    required this.onChanged,
    required this.borderColor,
    this.canvasHeight = kDrawingDefaultCanvasHeight,
    this.isFullscreen = false,
    this.onDelete,
  });

  @override
  State<NoteDrawingBlock> createState() => _NoteDrawingBlockState();
}

class _NoteDrawingBlockState extends State<NoteDrawingBlock> {
  late List<Map<String, dynamic>> _strokes;
  final UndoRedoStack<List<Map<String, dynamic>>> _history =
      UndoRedoStack<List<Map<String, dynamic>>>(maxDepth: 40);

  bool _eraser = false;
  Color _color = kDrawingColorPresets.first;
  double _strokeWidth = kDrawingWidthPresets[1];

  // Gömülü (küçük) önizlemede uzun basınca true olur; _AttachmentTile'daki
  // showDelete ile aynı rol: true iken tuvalin üstünde silme ikonu belirir,
  // tuvale (ikon dışında) dokunmak tam ekranı açmak yerine bunu kapatır.
  bool _showDeleteOverlay = false;

  // O an parmakla sürüklenmekte olan, henüz _strokes'a eklenmemiş nokta
  // listesi (canlı önizleme için).
  List<Offset>? _livePoints;

  // Dışa aktarma sırasında gösterilen "hazırlanıyor/kaydedildi" bildirimi;
  // note_list_screen.dart'taki _showInfoBar ile birebir aynı balon
  // (kapsül) görünümü — bkz. _showExportInfoBar.
  OverlayEntry? _exportBarOverlay;
  Timer? _exportBarTimer;

  @override
  void initState() {
    super.initState();
    _strokes = _cloneStrokes(widget.strokes);
  }

  @override
  void dispose() {
    _exportBarTimer?.cancel();
    _exportBarOverlay?.remove();
    super.dispose();
  }

  // note_list_screen.dart'taki _showInfoBar ile aynı balon (kapsül) tarzı
  // bildirim; ekranın altında ortalanmış, yuvarlak köşeli, koyu renkli bir
  // toast olarak gösterilir. Çizim dışa aktarma akışının, notu dışa
  // aktarırken çıkan bildirimle birebir aynı görünmesi için eklendi.
  void _showExportInfoBar(
    BuildContext context,
    String message, {
    IconData icon = Icons.check_circle,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _hideExportInfoBar();
    final hasAction = actionLabel != null && onAction != null;
    _exportBarOverlay = OverlayEntry(
      builder: (ctx) => Positioned(
        bottom: MediaQuery.of(ctx).padding.bottom + 24,
        left: 0,
        right: 0,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF3D3D3D),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (hasAction) ...[
                    const SizedBox(width: 14),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _hideExportInfoBar();
                        onAction();
                      },
                      child: Text(
                        actionLabel,
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_exportBarOverlay!);
    _exportBarTimer = Timer(
      Duration(seconds: hasAction ? 4 : 2),
      _hideExportInfoBar,
    );
  }

  void _hideExportInfoBar() {
    _exportBarTimer?.cancel();
    _exportBarOverlay?.remove();
    _exportBarOverlay = null;
    _exportBarTimer = null;
  }

  // Aşama 3: Tam ekran görünümde çizilenler [widget.onChanged] üzerinden
  // doğrudan blocks[i]['strokes']'a yazılıyor; bu widget (küçük gömülü
  // tuval) aynı anahtarla (ValueKey) ayakta kaldığı için Flutter yeni bir
  // State kurmaz, sadece bu metodu çağırır. Böylece kullanıcı tam ekrandan
  // çıkıp küçük tuvale döndüğünde, orada çizilenler burada da görünür.
  @override
  void didUpdateWidget(covariant NoteDrawingBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.strokes, widget.strokes)) {
      _strokes = _cloneStrokes(widget.strokes);
    }
  }

  // AppBar'daki dışa aktar aksiyonu, tam ekran tuvalin GÜNCEL (henüz
  // widget.onChanged ile dışarı yansımamış olabilecek) stroke'larını bu
  // getter üzerinden okur (bkz. _openFullscreen'deki canvasKey).
  List<Map<String, dynamic>> get currentStrokesSnapshot =>
      _cloneStrokes(_strokes);

  List<Map<String, dynamic>> _cloneStrokes(List<Map<String, dynamic>> src) {
    return src.map((s) {
      return {
        'color': s['color'],
        'width': s['width'],
        'points': (s['points'] as List? ?? const [])
            .map((p) => [(p as List)[0], p[1]])
            .toList(),
      };
    }).toList();
  }

  void _eraseAt(Offset pos) {
    final before = _strokes.length;
    _strokes.removeWhere((s) {
      final pts = (s['points'] as List? ?? const []);
      for (final p in pts) {
        final dx = (p[0] as num).toDouble() - pos.dx;
        final dy = (p[1] as num).toDouble() - pos.dy;
        if (dx * dx + dy * dy <= _kEraseRadius * _kEraseRadius) return true;
      }
      return false;
    });
    if (_strokes.length != before) setState(() {});
  }

  void _onPointerDown(PointerDownEvent event) {
    // Yeni bir hareket (stroke ekleme ya da silme) başlamadan ÖNCE mevcut
    // durumu geri alma yığınına kaydediyoruz; böylece her tam sürükleme
    // hareketi tek bir "geri al" adımı oluyor.
    _history.push(_cloneStrokes(_strokes));
    final pos = event.localPosition;
    if (_eraser) {
      _eraseAt(pos);
    } else {
      _livePoints = [pos];
      setState(() {});
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    final pos = event.localPosition;
    if (_eraser) {
      _eraseAt(pos);
    } else if (_livePoints != null) {
      setState(() => _livePoints!.add(pos));
    }
  }

  void _finishStroke() {
    if (_livePoints != null && _livePoints!.isNotEmpty) {
      _strokes.add({
        'color': _color.toARGB32(),
        'width': _strokeWidth,
        'points': _livePoints!.map((o) => [o.dx, o.dy]).toList(),
      });
    }
    _livePoints = null;
    setState(() {});
    widget.onChanged(_cloneStrokes(_strokes));
  }

  void _onPointerUp(PointerUpEvent event) {
    if (_eraser) {
      widget.onChanged(_cloneStrokes(_strokes));
    } else {
      _finishStroke();
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (!_eraser) {
      _livePoints = null;
      setState(() {});
    }
  }

  void _undo() {
    final restored = _history.undo(_cloneStrokes(_strokes));
    if (restored == null) return;
    setState(() => _strokes = restored);
    widget.onChanged(_cloneStrokes(_strokes));
  }

  void _redo() {
    final restored = _history.redo(_cloneStrokes(_strokes));
    if (restored == null) return;
    setState(() => _strokes = restored);
    widget.onChanged(_cloneStrokes(_strokes));
  }

  void _clear() {
    if (_strokes.isEmpty) return;
    _history.push(_cloneStrokes(_strokes));
    setState(() => _strokes = []);
    widget.onChanged(_cloneStrokes(_strokes));
  }

  // Aşama 3: Aynı veriyle çalışan, daha büyük bir tuval için tam ekran
  // sayfası açar. Yeni sayfadaki NoteDrawingBlock BAĞIMSIZ bir State'e
  // (dolayısıyla kendi undo/redo yığınına) sahiptir; ama [onChanged]
  // doğrudan bu widget'ın kendi onChanged'ine (yani blocks[i]['strokes']'a)
  // yazdığından, tam ekranda yapılan her değişiklik anında not editörüne
  // yansır — küçük tuval, aynı ValueKey sayesinde (didUpdateWidget) tam
  // ekrandan dönüldüğünde güncel veriyi otomatik yakalar.
  void _openFullscreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (routeContext) {
          final media = MediaQuery.of(routeContext);
          // AppBar + alt araç çubuğu için kabaca yer bırakıp geri kalanı
          // tuvale ayırıyoruz; çok küçük ekranlarda makul bir tabana
          // (200) düşülüyor.
          final reserved = kToolbarHeight + media.padding.top + media.padding.bottom + 90;
          final bigHeight = math.max(200.0, media.size.height - reserved);
          // Tam ekrandaki gerçek (aktif düzenlenen) çizim tuvali, kendi
          // BAĞIMSIZ State'i içinde tutulur (bkz. sınıf başındaki not).
          // AppBar'daki dışa aktar aksiyonu bu yüzden bir GlobalKey ile o
          // State'e (canvasKey.currentState) erişip güncel stroke'ları okur;
          // dışarıdaki (küçük önizleme) _strokes henüz güncellenmemiş olabilir.
          final canvasKey = GlobalKey<_NoteDrawingBlockState>();
          final exportButtonKey = GlobalKey();
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                tooltip: 'Küçült',
                icon: const Icon(Icons.close_fullscreen),
                onPressed: () => Navigator.of(routeContext).pop(),
              ),
              title: const Text('Çizim'),
              actions: [
                IconButton(
                  key: exportButtonKey,
                  tooltip: 'Dışa Aktar',
                  icon: Icon(
                    Icons.ios_share,
                    // Koyu temada beyaz, açık temada siyah: her iki temada
                    // da AppBar zemini üzerinde net görünür kalsın diye.
                    color: dNoteIsDark(routeContext)
                        ? Colors.white
                        : Colors.black,
                  ),
                  onPressed: () => _showDrawingExportMenu(
                    context: routeContext,
                    anchorKey: exportButtonKey,
                    canvasKey: canvasKey,
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: NoteDrawingBlock(
                key: canvasKey,
                strokes: _strokes,
                borderColor: widget.borderColor,
                canvasHeight: bigHeight,
                isFullscreen: true,
                onChanged: widget.onChanged,
              ),
            ),
          );
        },
      ),
    );
  }

  // Dışa aktar ikonuna basılınca ikonun hemen altında açılan, PDF/JPG
  // seçeneklerini gösteren alt menü (bkz. note_list_screen.dart'taki
  // _showExportSubmenu ile aynı konumlandırma deseni).
  Future<void> _showDrawingExportMenu({
    required BuildContext context,
    required GlobalKey anchorKey,
    required GlobalKey<_NoteDrawingBlockState> canvasKey,
  }) async {
    final strokes = canvasKey.currentState?.currentStrokesSnapshot ??
        const <Map<String, dynamic>>[];
    if (strokes.isEmpty) {
      _showExportInfoBar(context, 'Önce bir çizim yapın', icon: Icons.info_outline);
      return;
    }

    final overlayBox =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final anchorBox =
        anchorKey.currentContext?.findRenderObject() as RenderBox?;

    RelativeRect position;
    if (anchorBox != null) {
      final topLeft = anchorBox.localToGlobal(
        Offset(0, anchorBox.size.height),
        ancestor: overlayBox,
      );
      final bottomRight = anchorBox.localToGlobal(
        anchorBox.size.bottomRight(Offset.zero),
        ancestor: overlayBox,
      );
      position = RelativeRect.fromLTRB(
        topLeft.dx,
        topLeft.dy,
        overlayBox.size.width - bottomRight.dx,
        0,
      );
    } else {
      position = RelativeRect.fromLTRB(
        overlayBox.size.width - 160,
        kToolbarHeight,
        8,
        0,
      );
    }

    final selected = await showMenu<String>(
      context: context,
      position: position,
      items: const [
        PopupMenuItem(
          value: 'pdf',
          child: Row(
            children: [
              Icon(Icons.picture_as_pdf, color: Colors.redAccent, size: 20),
              SizedBox(width: 10),
              Text('PDF'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'jpg',
          child: Row(
            children: [
              Icon(Icons.image_outlined, color: Colors.blueAccent, size: 20),
              SizedBox(width: 10),
              Text('JPG'),
            ],
          ),
        ),
      ],
    );

    if (!context.mounted) return;
    if (selected == 'pdf') {
      await _exportDrawingAsPdf(context: context, strokes: strokes);
    } else if (selected == 'jpg') {
      await _exportDrawingAsJpg(context: context, strokes: strokes);
    }
  }

  // Çizimi tek başına (notun geri kalanı olmadan) PDF'e dönüştürüp
  // kullanıcının native "Farklı Kaydet" diyaloğuyla seçtiği konuma yazar.
  // Aynı PdfExportService, çizimi tek "drawing" bloklu bir not gibi işler.
  Future<void> _exportDrawingAsPdf({
    required BuildContext context,
    required List<Map<String, dynamic>> strokes,
  }) async {
    _showExportInfoBar(context, 'PDF hazırlanıyor…', icon: Icons.picture_as_pdf);
    try {
      final phoneScreenWidth = MediaQuery.of(context).size.width;
      final file = await PdfExportService.exportNoteToPdf(
        title: 'Çizim',
        noteType: 'text',
        blocks: [
          {'type': 'drawing', 'strokes': strokes},
        ],
        checkItems: const [],
        attachments: const [],
        phoneScreenWidth: phoneScreenWidth,
      );
      final bytes = await file.readAsBytes();
      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'PDF olarak kaydet',
        fileName: 'cizim_${DateTime.now().millisecondsSinceEpoch}.pdf',
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        bytes: bytes,
      );
      if (!context.mounted) return;
      if (savedPath != null) {
        _showExportInfoBar(
          context,
          'PDF kaydedildi',
          icon: Icons.picture_as_pdf,
          actionLabel: 'Aç',
          onAction: () => OpenFile.open(file.path),
        );
      }
      // savedPath null ise kullanıcı diyaloğu iptal etmiştir; hata değil.
    } catch (e, st) {
      debugPrint('[Çizim PDF] hata: $e\n$st');
      if (context.mounted) {
        _showExportInfoBar(
          context,
          'PDF oluşturulamadı',
          icon: Icons.error_outline,
        );
      }
    }
  }

  // Çizimi tek başına, uygulamanın kendi görünümüyle (koyu/açık tema)
  // JPG'e dönüştürüp kullanıcının native "Farklı Kaydet" diyaloğuyla
  // seçtiği konuma yazar. Aynı NoteScreenshotService, çizimi tek "drawing"
  // bloklu bir not gibi işler.
  Future<void> _exportDrawingAsJpg({
    required BuildContext context,
    required List<Map<String, dynamic>> strokes,
  }) async {
    _showExportInfoBar(context, 'JPG hazırlanıyor…', icon: Icons.image_outlined);
    try {
      final jpgFile = await NoteScreenshotService.exportNoteAsScreenshotJpg(
        context: context,
        title: 'Çizim',
        noteType: 'text',
        blocks: [
          {'type': 'drawing', 'strokes': strokes},
        ],
        checkItems: const [],
        attachments: const [],
        fontSize: 16.0,
        textColor: dNoteEffectiveTextColor(context, null),
        borderColor: dNoteBorderColor(context),
        backgroundColor: Theme.of(context).cardColor,
      );
      final bytes = await jpgFile.readAsBytes();
      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'JPG olarak kaydet',
        fileName: p.basename(jpgFile.path),
        type: FileType.custom,
        allowedExtensions: ['jpg'],
        bytes: bytes,
      );
      if (!context.mounted) return;
      if (savedPath != null) {
        _showExportInfoBar(
          context,
          'JPG kaydedildi',
          icon: Icons.image_outlined,
          actionLabel: 'Aç',
          onAction: () => OpenFile.open(jpgFile.path),
        );
      }
      // savedPath null ise kullanıcı diyaloğu iptal etmiştir; hata değil.
    } catch (e, st) {
      debugPrint('[Çizim JPG] hata: $e\n$st');
      if (context.mounted) {
        _showExportInfoBar(
          context,
          'JPG oluşturulamadı',
          icon: Icons.error_outline,
        );
      }
    }
  }

  Widget _toolButton({
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: selected ? Colors.amber.withValues(alpha: 0.18) : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 20,
          color: selected ? Colors.amber : Colors.grey,
        ),
      ),
    );
  }

  Widget _colorDot(Color c) {
    final selected = !_eraser && c.toARGB32() == _color.toARGB32();
    return InkWell(
      onTap: () => setState(() {
        _color = c;
        _eraser = false;
      }),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: c,
          border: Border.all(
            color: selected ? Colors.amber : widget.borderColor,
            width: selected ? 2 : 1,
          ),
        ),
      ),
    );
  }

  Widget _widthDot(double w) {
    final selected = !_eraser && w == _strokeWidth;
    final size = 8.0 + (w / kDrawingWidthPresets.last) * 10.0;
    return InkWell(
      onTap: () => setState(() {
        _strokeWidth = w;
        _eraser = false;
      }),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 26,
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? Colors.amber : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? Colors.amber : Colors.grey,
          ),
        ),
      ),
    );
  }

  // Icons.ink_eraser (Material Symbols) her Flutter sürümünde mevcut
  // olmayabildiği için (derleme hatası riski), silgiyi klasik pembe silgi
  // bloğuna benzer basit şekillerle KENDİMİZ çiziyoruz — hiçbir icon font
  // sürümüne bağımlı değil.
  Widget _eraserToolButton() {
    final selected = _eraser;
    return InkWell(
      onTap: () => setState(() => _eraser = true),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: selected ? Colors.amber.withValues(alpha: 0.18) : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: SizedBox(
          width: 20,
          height: 20,
          child: Center(
            child: Transform.rotate(
              angle: -0.5,
              child: Container(
                width: 17,
                height: 11,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    color: selected ? Colors.amber : Colors.grey,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: selected
                            ? Colors.amber.withValues(alpha: 0.35)
                            : Colors.grey.withValues(alpha: 0.35),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: selected
                            ? Colors.amber.withValues(alpha: 0.85)
                            : Colors.grey.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 22,
        color: widget.borderColor,
        margin: const EdgeInsets.symmetric(horizontal: 6),
      );

  @override
  Widget build(BuildContext context) {
    // Not editörüne gömülü (küçük) örnekte artık doğrudan çizim yapılamaz;
    // kullanıcı sadece dokunarak tam ekran çizim sayfasını açar ve tüm
    // kalem/silgi/renk/kalınlık/geri-al araçları yalnızca orada görünür.
    // Böylece notu kaydırırken/okurken yanlışlıkla tuvale dokunup çizgi
    // bırakma riski ortadan kalkıyor.
    if (!widget.isFullscreen) {
      return _buildEmbeddedPreview();
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: widget.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: widget.canvasHeight,
            width: double.infinity,
            // ClipRect ÖNEMLİ: SizedBox tek başına sadece hit-test alanını
            // sınırlar, boyanan içeriği kırpmaz. Kırpma olmadan tuvalin alt
            // kenarına yakın çizilen bir çizgi kutunun dışına, bir sonraki
            // sırada duran araç çubuğunun (paletin) arkasına taşıp orada
            // görünmeye devam ediyordu. ClipRect, tuvalin tam paletin
            // başladığı yerde kesin biçimde bitmesini sağlıyor.
            child: ClipRect(
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: _onPointerDown,
                onPointerMove: _onPointerMove,
                onPointerUp: _onPointerUp,
                onPointerCancel: _onPointerCancel,
                child: CustomPaint(
                  painter: _DrawingPainter(
                    strokes: _strokes,
                    livePoints: _livePoints,
                    liveColor: _color,
                    liveWidth: _strokeWidth,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          Container(height: 1, color: widget.borderColor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _toolButton(
                    icon: Icons.edit,
                    selected: !_eraser,
                    onTap: () => setState(() => _eraser = false),
                  ),
                  _eraserToolButton(),
                  _divider(),
                  IconButton(
                    tooltip: 'Geri Al',
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.undo,
                      size: 20,
                      color: _history.canUndo ? Colors.amber : Colors.grey,
                    ),
                    onPressed: _history.canUndo ? _undo : null,
                  ),
                  IconButton(
                    tooltip: 'İleri Al',
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.redo,
                      size: 20,
                      color: _history.canRedo ? Colors.amber : Colors.grey,
                    ),
                    onPressed: _history.canRedo ? _redo : null,
                  ),
                  IconButton(
                    tooltip: 'Temizle',
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: _strokes.isEmpty
                          ? Colors.grey
                          : Colors.redAccent,
                    ),
                    onPressed: _strokes.isEmpty ? null : _clear,
                  ),
                  _divider(),
                  for (final c in kDrawingColorPresets) _colorDot(c),
                  _divider(),
                  for (final w in kDrawingWidthPresets) _widthDot(w),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Gömülü (küçük) önizleme: sadece mevcut çizimi gösterir, parmak
  // hareketlerine tepki vermez (Listener yok). Dokunulduğunda tam ekran
  // çizim sayfası açılır (bkz. _openFullscreen). Boşken ortada "Çizmek için
  // dokunun" ipucu, doluyken sağ altta küçük bir "genişlet" rozeti
  // gösterilir. Uzun basınca (widget.onDelete verilmişse), notun ek/
  // fotoğraf kutucuklarındaki (_AttachmentTile) "uzun bas -> sil ikonu
  // çıkar" deseniyle birebir aynı şekilde, tuvalin üstünde yarı saydam bir
  // katman ve ortasında çöp kutusu ikonu belirir; ikona basılırsa bloğun
  // tamamı kaldırılır, katmanın başka bir yerine dokunulursa sadece
  // kapanır (tam ekran açılmaz).
  Widget _buildEmbeddedPreview() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: widget.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: _showDeleteOverlay
              ? () => setState(() => _showDeleteOverlay = false)
              : _openFullscreen,
          onLongPress: widget.onDelete == null
              ? null
              : () => setState(() => _showDeleteOverlay = true),
          child: SizedBox(
            height: widget.canvasHeight,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _DrawingPainter(
                      strokes: _strokes,
                      livePoints: null,
                      liveColor: Colors.transparent,
                      liveWidth: 0,
                    ),
                  ),
                ),
                if (_showDeleteOverlay)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.45),
                      child: Center(
                        child: IconButton(
                          tooltip: 'Sil',
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: widget.onDelete,
                        ),
                      ),
                    ),
                  )
                else if (_strokes.isEmpty)
                  Positioned.fill(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            color: widget.borderColor,
                            size: 22,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Çizmek için dokunun',
                            style: TextStyle(
                              color: widget.borderColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Positioned(
                    right: 6,
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.open_in_full,
                        color: Colors.white,
                        size: 14,
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
}

class _DrawingPainter extends CustomPainter {
  final List<Map<String, dynamic>> strokes;
  final List<Offset>? livePoints;
  final Color liveColor;
  final double liveWidth;

  _DrawingPainter({
    required this.strokes,
    required this.livePoints,
    required this.liveColor,
    required this.liveWidth,
  });

  void _paintStroke(
    Canvas canvas,
    List<Offset> points,
    Color color,
    double strokeWidth,
  ) {
    if (points.isEmpty) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    if (points.length == 1) {
      // Tek dokunuşla nokta bırakma: küçük bir daire çizerek görünür kılıyoruz.
      canvas.drawCircle(points.first, strokeWidth / 2, paint..style = PaintingStyle.fill);
      return;
    }
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in strokes) {
      final pts = (s['points'] as List? ?? const [])
          .map(
            (p) => Offset(
              ((p as List)[0] as num).toDouble(),
              (p[1] as num).toDouble(),
            ),
          )
          .toList();
      final color = Color((s['color'] as num?)?.toInt() ?? 0xFFFFFFFF);
      final strokeWidth = (s['width'] as num?)?.toDouble() ?? 3.0;
      _paintStroke(canvas, pts, color, strokeWidth);
    }
    if (livePoints != null) {
      _paintStroke(canvas, livePoints!, liveColor, liveWidth);
    }
  }

  // Basitlik için her frame'de yeniden çiziyoruz (strokes listesi genelde
  // küçük kalır; performans sorun olursa ileride önbelleğe alınabilir).
  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}

// ════════════════════════════════════════════════════════════════════════
// PDF DIŞA AKTARMA İÇİN RASTERİZASYON (NoteDrawingRenderer)
// PdfExportService, "pdf" paketinin kendi düşük seviyeli çizim API'sini
// (PdfGraphics) kullanmak yerine bu yardımcıyı çağırır. Sebep: pdf
// paketinin koordinat sistemi Flutter Canvas'ından farklıdır ve doğrudan
// stroke noktalarını oraya aktarmak ayna/ters görüntü riski taşır. Bunun
// yerine, ekranda ve ekran görüntüsünde kullanılan AYNI _DrawingPainter'ı
// dart:ui üzerinden ekran dışı (offscreen) bir PNG'ye çiziyoruz; PDF'e bu
// PNG bir resim eki gibi gömülüyor. Böylece üç çıktı (uygulama içi
// önizleme, JPG ekran görüntüsü, PDF) birebir aynı görünür.
class NoteDrawingRenderer {
  // Tam ekran çizim modunda tuval, gömülü önizlemeden (sabit
  // kDrawingDefaultCanvasHeight = 220) çok daha uzun olabilir (bkz.
  // _openFullscreen'deki bigHeight). Dışa aktarma (PDF/JPG) sabit 220
  // yükseklikle render edilirse, bu değeri aşan alt kısımdaki stroke'lar
  // kırpılıp kayboluyordu. Bu yüzden dışa aktarmadan önce, gerçekte
  // çizilmiş içeriğin dikey kapsamına (en alttaki noktanın Y'si + kalem
  // kalınlığının yarısı) göre gereken yüksekliği hesaplıyoruz; içerik
  // 220'den kısaysa yine de en az 220 döner (boş/az çizimli tuval küçük
  // görünmesin diye).
  static double requiredCanvasHeight(
    List<Map<String, dynamic>> strokes, {
    double minHeight = kDrawingDefaultCanvasHeight,
  }) {
    double maxY = 0;
    for (final s in strokes) {
      final strokeWidth = (s['width'] as num?)?.toDouble() ?? 0;
      final points = (s['points'] as List? ?? const []);
      for (final pt in points) {
        final y = (pt[1] as num).toDouble() + strokeWidth / 2;
        if (y > maxY) maxY = y;
      }
    }
    final needed = maxY + 16; // alt kenara küçük bir pay
    return needed > minHeight ? needed : minHeight;
  }

  static Future<Uint8List?> renderStrokesToPng(
    List<Map<String, dynamic>> strokes, {
    required double width,
    double height = kDrawingDefaultCanvasHeight,
    double pixelRatio = 2.5,
    // PDF sayfası her zaman beyaz olduğu için beyaz kalemle çizilen izler
    // orada görünmez kalır. true verilirse, sadece tam beyaz (0xFFFFFFFF)
    // renkli stroke'lar siyaha çevrilir; diğer renkler ve zaten siyah olan
    // izler olduğu gibi kalır. Düzenleyicideki (koyu tuval) görünümü
    // etkilemez, sadece PDF'e gömülecek PNG için kullanılır.
    bool mapWhiteToBlack = false,
  }) async {
    if (strokes.isEmpty) return null;
    final effectiveStrokes = mapWhiteToBlack
        ? strokes.map((s) {
            final colorValue = s['color'];
            if (colorValue is int && colorValue == 0xFFFFFFFF) {
              return {...s, 'color': 0xFF000000};
            }
            return s;
          }).toList()
        : strokes;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.scale(pixelRatio);
    _DrawingPainter(
      strokes: effectiveStrokes,
      livePoints: null,
      liveColor: Colors.transparent,
      liveWidth: 0,
    ).paint(canvas, Size(width, height));
    final picture = recorder.endRecording();
    ui.Image? image;
    try {
      image = await picture.toImage(
        (width * pixelRatio).round(),
        (height * pixelRatio).round(),
      );
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } finally {
      image?.dispose();
    }
  }
}
