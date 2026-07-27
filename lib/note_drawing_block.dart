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

// Koyu temadayken beyaz kalemle çizilen bir çizgi, açık temaya geçildiğinde
// (tuvalin zemini de açık renge döndüğünde) görünmez hale gelir. main.dart'taki
// dNoteEffectiveTextColor ile birebir aynı mantık: yalnızca tam beyaz
// (0xFFFFFFFF) renkli stroke'lar, o an açık temadaysa siyaha çevrilir; koyu
// temadaki beyaz seçim ve diğer tüm renkler olduğu gibi korunur. Stroke'un
// kendi kayıtlı 'color' değeri DEĞİŞMEZ — bu sadece ekrana basılırken
// uygulanan bir görüntüleme dönüşümüdür, tema tekrar koyuya alınırsa çizgi
// yine beyaz görünür.
Color dNoteEffectiveStrokeColor(bool isDark, Color color) {
  if (!isDark && color.toARGB32() == Colors.white.toARGB32()) {
    return Colors.black;
  }
  return color;
}

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

  // Bloğun ilk oluşturulduğu anda (ör. "Çizim Ekle" menüsünden yeni
  // eklendiğinde) kullanıcı küçük tuvale dokunmadan otomatik olarak tam
  // ekran çizim sayfasının açılmasını sağlar. Yalnızca bu widget'ın
  // State'i İLK KEZ kurulurken (initState) bir defa tetiklenir; sonraki
  // yeniden çizimlerde (rebuild) tekrar açılmaz.
  final bool autoOpenOnce;

  // autoOpenOnce tetiklendikten hemen sonra çağrılır; çağıran taraf
  // (note_list_screen.dart) bunu, aynı indeksteki başka bir çizim
  // bloğunun yanlışlıkla otomatik açılmasını önlemek için kendi geçici
  // izleme değişkenini temizlemekte kullanır.
  final VoidCallback? onAutoOpened;

  const NoteDrawingBlock({
    super.key,
    required this.strokes,
    required this.onChanged,
    required this.borderColor,
    this.canvasHeight = kDrawingDefaultCanvasHeight,
    this.isFullscreen = false,
    this.onDelete,
    this.autoOpenOnce = false,
    this.onAutoOpened,
  });

  @override
  State<NoteDrawingBlock> createState() => _NoteDrawingBlockState();
}

class _NoteDrawingBlockState extends State<NoteDrawingBlock> {
  late List<Map<String, dynamic>> _strokes;
  final UndoRedoStack<List<Map<String, dynamic>>> _history =
      UndoRedoStack<List<Map<String, dynamic>>>(maxDepth: 40);

  bool _eraser = false;

  // Silgi modu: true iken (varsayılan) silgi yarıçapına giren yalnızca
  // TEK TEK NOKTALAR kaldırılır — bir serbest el (freehand) stroke'unun
  // ortasından silinirse, kalan iki parça birbirinden bağımsız iki ayrı
  // stroke'a bölünür ("kısmi/piksel silgi"). false iken (eski davranış,
  // "tam silgi") yarıçapa giren TEK bir nokta bile o stroke'un TAMAMINI
  // siler. Her iki modda da şekil (line/rect/ellipse) stroke'ları
  // yalnızca 2 köşe sakladığından bölünemez; onlar hâlâ bütün olarak
  // silinir (bkz. _eraseAt).
  bool _partialEraser = true;

  Color _color = kDrawingColorPresets.first;
  double _strokeWidth = kDrawingWidthPresets[1];

  // Aktif şekil aracı: null iken serbest el (freehand) çizim yapılır;
  // 'line' / 'rect' / 'ellipse' değerlerinden biriyse, parmak sürüklemesi
  // sadece BAŞLANGIÇ ve ANLIK (bitiş) noktası arasında ilgili şekli
  // önizler ve bırakıldığında o iki nokta 'points' olarak kaydedilir (bkz.
  // _onPointerDown/_onPointerMove/_finishStroke, _DrawingPainter._paintShape).
  // Kalem (pen) seçilince otomatik olarak null'a döner; silgi ile karşılıklı
  // dışlayıcıdır.
  String? _shapeTool;

  // Şekil modunda sürüklemenin BAŞLANGIÇ noktası (ilk pointer-down konumu).
  // _livePoints her zaman [_shapeStartPoint, güncel_konum] şeklinde tutulur.
  Offset? _shapeStartPoint;

  // ── AŞAMA 1.1: Zoom/Pan Altyapısı ─────────────────────────────────────
  // Tuvalin görüntü ölçeği (1.0 = %100) ve kaydırma ofseti (mantıksal
  // piksel, EKRAN koordinat sisteminde). Bu ikisi birlikte tuvale
  // uygulanan bir Transform (Matrix4) oluşturur; _DrawingPainter'ın
  // kendisi hiç değişmez — sadece Transform katmanı sayesinde büyümüş/
  // kaymış GÖRÜNÜR.
  //
  // AŞAMA 3.1 DOĞRULAMASI: Bu alanlar ve tüm zoom/pan mekanizması
  // (pinch, +/− butonları, çift dokunma, silgi yarıçapı ölçekleme)
  // SADECE build()'ın tam ekran dalında kullanılır. Gömülü (küçük)
  // önizleme ayrı bir metottan (_buildEmbeddedPreview) render edilir ve
  // orada ne Listener/pinch algılayıcısı ne de Transform katmanı vardır
  // — dolayısıyla gömülü önizlemede bu alanlar hiç okunmaz/yazılmaz,
  // her zaman 1.0/Offset.zero'da kalır. Ayrıca gömülü önizleme ile tam
  // ekran, AYRI State örnekleridir (bkz. _openFullscreen — yeni bir
  // NoteDrawingBlock, kendi State'iyle push edilir); bu yüzden bir
  // notta bulunan çizim bloğu tam ekranda ne kadar yakınlaştırılırsa
  // yakınlaştırılsın, küçültüldüğünde gömülü önizleme HER ZAMAN %100/
  // kaydırmasız (varsayılan) görünüme döner — zoom/pan durumu kalıcı
  // olarak saklanmaz, sadece o anki tam ekran oturumuna özeldir. Gömülü
  // önizlemede korunan TEK davranış, dokunulunca tam ekranı açmaktır.
  double _scale = 1.0;
  Offset _panOffset = Offset.zero;

  // O anki _scale/_panOffset değerlerinden EKRAN -> TUVAL dönüşüm
  // matrisini üretir. Transform widget'ı bu matrisle tuvali (görsel
  // olarak) taşır/büyütür. Aşama 1.3'te, ekrandan gelen pointer
  // konumlarını gerçek tuval koordinatına çevirmek için bunun TERSİ
  // (Matrix4.invert) kullanılacak.
  Matrix4 get _canvasTransform => Matrix4.identity()
    ..translate(_panOffset.dx, _panOffset.dy)
    ..scale(_scale);

  // ── AŞAMA 2.2: Zoom Sınırları, Pan Sınırlaması, Çift Dokunma ──────────
  // Ürün gereksinimi: zoom %100 ile %400 arasında kalmalı — tuval kendi
  // doğal (viewport'u birebir kaplayan) boyutundan asla daha küçük
  // gösterilemez; kullanıcı yalnızca yakınlaşabilir (zoom in), %100'ün
  // altına inemez. Bu sabit tek merkezi nokta olduğu için pinch, +/−
  // butonları ve çift dokunmayla sıfırlama dahil tüm zoom giriş
  // noktaları otomatik olarak bu sınıra uyar (bkz. _applyTransform,
  // _zoomBy, _updatePinchGesture).
  static const double kMinDrawingZoom = 1.0;
  static const double kMaxDrawingZoom = 4.0;

  // Tuval, viewport'tan (görünüm alanından) tamamen kayıp boşluğa
  // düşmesin diye [pan]'ı [scale] için izin verilen aralığa sıkıştırır.
  // Mantık: tuval, scale=1/pan=0 iken viewport'u BİREBİR kaplar (bkz.
  // build()'daki SizedBox/LayoutBuilder — kDrawingDefaultCanvasHeight ve
  // genişlik viewport ile eşleşir). Bu yüzden "içerik boyutu" ~
  // viewport * scale kabul edilebilir: içerik viewport'tan küçük/eşitse
  // (scale <= 1) pan sıfırlanır (ortalanmış durur); büyükse pan, kenarlarda
  // boşluk bırakmayacak [viewport - içerik, 0] aralığına sıkıştırılır.
  Offset _clampPanOffset(Offset pan, double scale) {
    final viewport = _viewportSize;
    if (viewport == null) return pan;
    double clampAxis(double p, double viewportExtent) {
      final contentExtent = viewportExtent * scale;
      if (contentExtent <= viewportExtent) return 0.0;
      final minPan = viewportExtent - contentExtent;
      return p.clamp(minPan, 0.0);
    }
    return Offset(
      clampAxis(pan.dx, viewport.width),
      clampAxis(pan.dy, viewport.height),
    );
  }

  // Zoom/pan'ı değiştiren TÜM yerlerin (pinch, +/− butonları, çift
  // dokunmayla sıfırlama) tek geçtiği ortak nokta: ölçeği %50–%400
  // aralığına, kaydırmayı da o ölçek için izin verilen sınıra sıkıştırıp
  // state'i günceller. Böylece sınır mantığı tek bir yerde yaşar.
  void _applyTransform(double scale, Offset pan) {
    final clampedScale = scale.clamp(kMinDrawingZoom, kMaxDrawingZoom);
    final clampedPan = _clampPanOffset(pan, clampedScale);
    setState(() {
      _scale = clampedScale;
      _panOffset = clampedPan;
    });
  }

  void _resetZoom() {
    if (_scale == 1.0 && _panOffset == Offset.zero) return;
    _applyTransform(1.0, Offset.zero);
  }

  // Çift dokunmayı KENDİMİZ tespit ediyoruz (ayrı bir GestureDetector
  // eklemek yerine): ayrı bir tanıyıcı eklemek, aynı ham pointer
  // olaylarını Listener'la yarışa sokar ve normal tek-dokunuşla "nokta"
  // (dot) bırakma özelliğiyle çakışır. Bunun yerine _onPointerUp'ta her
  // "dokunma" (küçük hareketli tek-parmak hareketi) için son dokunmanın
  // zamanı/konumu saklanır; kısa süre + yakın mesafede ikinci bir dokunma
  // gelirse çift dokunma sayılır.
  DateTime? _lastTapUpTime;
  Offset? _lastTapUpScreenPos;
  // Aktif tek-parmak hareketinin BAŞLADIĞI ekran konumu; kalkışta bu
  // konumla karşılaştırılıp hareketin bir "sürükleme" mi yoksa yerinde
  // bir "dokunma" mı olduğu anlaşılır (bkz. _onPointerUp).
  Offset? _tapDownScreenPos;
  static const Duration _kDoubleTapMaxInterval = Duration(milliseconds: 300);
  static const double _kDoubleTapMaxDistance = 24.0;
  static const double _kTapMoveThreshold = 6.0;

  // Çift dokunmanın kalem/şekil modunda bıraktığı iki "değersiz" (nokta ya
  // da sıfır-boyutlu şekil) stroke'u geriye doğru kaldırır — kullanıcı
  // zoom'u sıfırlamak istemiştir, tuvale yanlışlıkla iki iz bırakmak
  // istememiştir.
  void _removeTrailingNegligibleStrokes(int count) {
    var removed = 0;
    while (removed < count && _strokes.isNotEmpty) {
      final last = _strokes.last;
      final pts = (last['points'] as List?) ?? const [];
      final isDot = pts.length <= 1;
      final isZeroSizeShape = pts.length == 2 &&
          (pts[0] as List)[0] == (pts[1] as List)[0] &&
          (pts[0] as List)[1] == (pts[1] as List)[1];
      if (!isDot && !isZeroSizeShape) break;
      _strokes.removeLast();
      removed++;
    }
    if (removed > 0) {
      setState(() {});
      widget.onChanged(_cloneStrokes(_strokes));
    }
  }

  // ── AŞAMA 2.1: Zoom Butonları ve Yüzde Göstergesi ─────────────────────
  // Tuval görünüm alanının (viewport) en son ölçülen boyutu; +/− butonları
  // basıldığında zoom'un EKRANIN ORTASINI odak noktası alması için
  // kullanılır (bkz. build() içindeki LayoutBuilder ve _zoomBy).
  Size? _viewportSize;

  // Her buton tıklamasında ölçeğin çarpılacağı/bölüneceği sabit adım.
  static const double _kZoomButtonStep = 1.25;

  // Ölçeği [factor] ile çarpar; odak noktası (viewport'un ortası) sabit
  // kalacak şekilde kaydırmayı da günceller — aynı pinch-zoom matematiği
  // (bkz. _updatePinchGesture), tek farkla: parmak hareketi yerine sabit
  // bir ekran noktası (viewport ortası) kullanılır.
  void _zoomBy(double factor) {
    final viewport = _viewportSize;
    final focal = viewport != null
        ? Offset(viewport.width / 2, viewport.height / 2)
        : Offset.zero;
    final oldScale = _scale;
    final newScale = (oldScale * factor).clamp(
      kMinDrawingZoom,
      kMaxDrawingZoom,
    );
    if (newScale == oldScale) return;
    final newPan = focal - (focal - _panOffset) * (newScale / oldScale);
    _applyTransform(newScale, newPan);
  }

  void _zoomIn() => _zoomBy(_kZoomButtonStep);
  void _zoomOut() => _zoomBy(1 / _kZoomButtonStep);



  // Gömülü (küçük) önizlemede uzun basınca true olur; _AttachmentTile'daki
  // showDelete ile aynı rol: true iken tuvalin üstünde silme ikonu belirir,
  // tuvale (ikon dışında) dokunmak tam ekranı açmak yerine bunu kapatır.
  bool _showDeleteOverlay = false;

  // O an parmakla sürüklenmekte olan, henüz _strokes'a eklenmemiş nokta
  // listesi (canlı önizleme için).
  List<Offset>? _livePoints;

  // O an çizimi/silmeyi yürüten TEK parmağın pointer id'si. İki (veya daha
  // fazla) parmakla aynı anda dokunulduğunda, Listener HER parmak için ayrı
  // PointerDownEvent/PointerMoveEvent gönderiyor. Bu id takip edilmeden
  // ikinci parmağın olayları da aynı _livePoints listesine karışıyor ve
  // iki farklı konum arasında zıplayan bir zikzak -> ekranda "çok kalın"
  // görünen bir stroke oluşuyordu. Artık yalnızca ilk değen parmak kabul
  // ediliyor; o parmak kalkana kadar diğer tüm parmaklar yok sayılıyor.
  int? _activePointerId;

  // Dışa aktarma sırasında gösterilen "hazırlanıyor/kaydedildi" bildirimi;
  // note_list_screen.dart'taki _showInfoBar ile birebir aynı balon
  // (kapsül) görünümü — bkz. _showExportInfoBar.
  OverlayEntry? _exportBarOverlay;
  Timer? _exportBarTimer;

  @override
  void initState() {
    super.initState();
    _strokes = _cloneStrokes(widget.strokes);
    if (widget.autoOpenOnce) {
      // Widget henüz tam çizilmeden Navigator.push çağırmak sorun
      // yaratabileceğinden (context henüz hazır olmayabilir), bir sonraki
      // frame'e ertelenir — checklist/metin bloklarındaki diğer
      // "requestFocus" ertelemeleriyle aynı desen.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _openFullscreen();
        widget.onAutoOpened?.call();
      });
    }
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
  //
  // AŞAMA 3.2 DOĞRULAMASI: _strokes HER ZAMAN sabit tuval koordinat
  // sisteminde tutulur (bkz. Aşama 1.3 — _screenToCanvas). _scale ve
  // _panOffset yalnızca EKRANDA nasıl GÖRÜNDÜĞÜNÜ belirleyen bir görüntü
  // katmanıdır, stroke verisinin bir parçası DEĞİLDİR. Dolayısıyla bu
  // getter'ın döndürdüğü liste — kullanıcı dışa aktarma anında hangi
  // zoom/pan seviyesinde olursa olsun — HER ZAMAN orijinal 1:1
  // koordinatlardadır; PDF/JPG dışa aktarma zoom/pan'dan etkilenmez.
  List<Map<String, dynamic>> get currentStrokesSnapshot =>
      _cloneStrokes(_strokes);

  List<Map<String, dynamic>> _cloneStrokes(List<Map<String, dynamic>> src) {
    return src.map((s) {
      return {
        'color': s['color'],
        'width': s['width'],
        // Eski (fosforlu kalem eklenmeden önce) kaydedilmiş stroke'larda bu
        // alanlar yoktur; varsayılanlar (tam opak, normal karışım) o
        // stroke'ların önceki görünümünü birebir korur.
        'opacity': s['opacity'] ?? 1.0,
        'blend': s['blend'] ?? 'normal',
        // Şekil aracı eklenmeden önce kaydedilmiş stroke'larda bu alan
        // yoktur; yokluğu 'freehand' (serbest el) anlamına gelir — mevcut
        // tüm eski çizimler değişmeden aynı şekilde render edilmeye devam
        // eder (bkz. _DrawingPainter.paint).
        'shape': s['shape'] ?? 'freehand',
        'points': (s['points'] as List? ?? const [])
            .map((p) => [(p as List)[0], p[1]])
            .toList(),
      };
    }).toList();
  }

  // Silgi için bir stroke'un "yakalanabilir" noktalarını döner. Serbest el
  // (freehand) stroke'larda bu doğrudan kayıtlı 'points' listesidir. Şekil
  // araçlarıyla (line/rect/ellipse) çizilen stroke'lar sadece 2 nokta
  // (başlangıç/bitiş köşesi) sakladığından, sadece o iki köşeye çok yakın
  // dokunulduğunda silinebilir olurlardı; bunun yerine şeklin ÇEVRESİ
  // boyunca örnek noktalar üretilir ki kullanıcı çizginin/kenarın herhangi
  // bir yerine dokununca da silebilsin.
  List<Offset> _eraseHitPoints(Map<String, dynamic> s) {
    final rawPts = (s['points'] as List? ?? const []);
    final shape = s['shape'] as String? ?? 'freehand';
    if (shape == 'freehand' || rawPts.length < 2) {
      return rawPts
          .map((p) => Offset(
                ((p as List)[0] as num).toDouble(),
                (p[1] as num).toDouble(),
              ))
          .toList();
    }
    final p0 = Offset(
      (rawPts.first[0] as num).toDouble(),
      (rawPts.first[1] as num).toDouble(),
    );
    final p1 = Offset(
      (rawPts.last[0] as num).toDouble(),
      (rawPts.last[1] as num).toDouble(),
    );
    const samples = 24;
    final out = <Offset>[];
    switch (shape) {
      case 'line':
        for (int i = 0; i <= samples; i++) {
          out.add(Offset.lerp(p0, p1, i / samples)!);
        }
        break;
      case 'rect':
        final rect = Rect.fromPoints(p0, p1);
        final corners = [
          rect.topLeft,
          rect.topRight,
          rect.bottomRight,
          rect.bottomLeft,
          rect.topLeft,
        ];
        for (int c = 0; c < 4; c++) {
          for (int i = 0; i < samples; i++) {
            out.add(Offset.lerp(corners[c], corners[c + 1], i / samples)!);
          }
        }
        break;
      case 'ellipse':
        final rect = Rect.fromPoints(p0, p1);
        final cx = rect.center.dx;
        final cy = rect.center.dy;
        final rx = rect.width / 2;
        final ry = rect.height / 2;
        for (int i = 0; i < samples; i++) {
          final a = (i / samples) * 2 * math.pi;
          out.add(Offset(cx + rx * math.cos(a), cy + ry * math.sin(a)));
        }
        break;
    }
    return out;
  }

  // ── AŞAMA 2.3: Zoom'a Duyarlı Silgi Yarıçapı ──────────────────────────
  // _kEraseRadius, TUVAL (canvas) koordinat biriminde sabit bir değerdir.
  // Silme noktası (pos) de Aşama 1.3'ten beri tuval koordinatında geldiği
  // için, sabit _kEraseRadius kullanılsaydı: yakınlaştırınca (_scale > 1)
  // aynı tuval-yarıçapı EKRANDA daha büyük bir alana denk gelir (parmak
  // olduğundan kalın bir "fırça" gibi silmeye başlar), uzaklaştırınca
  // (_scale < 1) ekranda çok küçük kalır (isabet ettirmek zorlaşır).
  // Silginin EKRANDAKİ (fiziksel parmak dokunuşuyla eşleşen) boyutu HER
  // zoom seviyesinde aynı kalsın diye, tuval-koordinatındaki etkin yarıçap
  // ters orantılı ölçeklenir: yakınlaştıkça (parmak tuvalin daha küçük bir
  // bölgesini kapladığından) etkin yarıçap küçülür -> silgi daha hassas
  // çalışır; uzaklaştıkça büyür -> silgi yine parmağın altını yakalar.
  double get _effectiveEraseRadius => _kEraseRadius / _scale;

  // Bir noktanın silgi yarıçapı içinde olup olmadığını kontrol eder.
  bool _withinEraseRadius(Offset p, Offset pos) {
    final dx = p.dx - pos.dx;
    final dy = p.dy - pos.dy;
    final r = _effectiveEraseRadius;
    return dx * dx + dy * dy <= r * r;
  }

  void _eraseAt(Offset pos) {
    if (!_partialEraser) {
      // Eski ("tam silgi") davranış: yarıçapa giren herhangi bir nokta,
      // stroke'un TAMAMINI siler.
      final before = _strokes.length;
      _strokes.removeWhere((s) {
        final pts = _eraseHitPoints(s);
        for (final p in pts) {
          if (_withinEraseRadius(p, pos)) return true;
        }
        return false;
      });
      if (_strokes.length != before) setState(() {});
      return;
    }

    // Kısmi ("piksel") silgi: her serbest el stroke'unun kendi 'points'
    // listesi tek tek taranır; silgi yarıçapına giren noktalar listeden
    // çıkarılır. Bu, aradan bir "delik" açar — kalan noktalar birbirine
    // bitişik iki ayrı parçaya (segmente) bölünmüşse, her parça KENDİ
    // BAŞINA yeni bir stroke olarak saklanır (aynı renk/kalınlık/opaklık
    // ile). Şekil araçlarıyla (line/rect/ellipse) çizilmiş stroke'lar
    // sadece 2 köşe sakladığından bu şekilde bölünemez; onlar için hâlâ
    // eski "tüm şekli sil" davranışı uygulanır.
    bool changed = false;
    final result = <Map<String, dynamic>>[];
    for (final s in _strokes) {
      final shape = s['shape'] as String? ?? 'freehand';
      if (shape != 'freehand') {
        final pts = _eraseHitPoints(s);
        final hit = pts.any((p) => _withinEraseRadius(p, pos));
        if (hit) {
          changed = true;
        } else {
          result.add(s);
        }
        continue;
      }

      final rawPts = (s['points'] as List? ?? const []);
      final segments = <List<List<double>>>[];
      List<List<double>>? current;
      for (final p in rawPts) {
        final px = ((p as List)[0] as num).toDouble();
        final py = (p[1] as num).toDouble();
        if (_withinEraseRadius(Offset(px, py), pos)) {
          changed = true;
          if (current != null) {
            segments.add(current);
            current = null;
          }
        } else {
          (current ??= <List<double>>[]).add([px, py]);
        }
      }
      if (current != null) segments.add(current);

      if (segments.isEmpty) {
        // Stroke'un tüm noktaları silindi.
        continue;
      }
      for (final seg in segments) {
        if (seg.length == rawPts.length) {
          // Hiçbir nokta değişmedi (tek parça, orijinaliyle aynı uzunlukta).
          result.add(s);
        } else {
          result.add({...s, 'points': seg});
        }
      }
    }
    if (changed) {
      _strokes
        ..clear()
        ..addAll(result);
      setState(() {});
    }
  }

  // ── AŞAMA 1.2: İki Parmak Pan/Zoom Ayrıştırması ───────────────────────
  // Tek-parmak çizim/silgi/şekil akışı ile iki-parmak pan/zoom (pinch)
  // jesti, ekrana değen parmak SAYISINA göre yönlendirilir; ikisi asla
  // aynı anda aktif olmaz. Mantık:
  //  • 1 parmak  -> eskisi gibi çizim/silgi/şekil.
  //  • 2 parmak  -> önce (varsa) süregelen tek-parmak hareketi SONLANDIRILIR
  //                 (commit edilir: stroke kaydedilir / silgi değişikliği
  //                 kalıcı hale gelir), sonra pan/zoom moduna geçilir.
  //  • 3+ parmak -> yok sayılır, mevcut pan/zoom jesti bozulmadan sürer.
  // Bu, tek-parmakla çizerken yanlışlıkla değen ikinci bir parmağın
  // ilk parmağın hareketini tuvalde kaydırma/büyütme sanmasını önler:
  // kullanıcı BİLEREK iki parmağını birden koymadıkça pan/zoom başlamaz.

  // O an ekrana değen TÜM parmakların (pointer id -> EKRAN koordinatındaki
  // konum) eşlemesi. Tek-parmak çiziminde de güncel tutulur; sadece
  // pan/zoom kararı için parmak SAYISINA bakılır.
  final Map<int, Offset> _activePointers = {};

  // İki-parmak pan/zoom jesti sürerken null DEĞİLDİR; jestin
  // BAŞLANGICINDAKİ ölçek/kaydırma/odak-noktası/parmak-arası-mesafe
  // değerlerini tutar. Aşama 2.2'de min/max zoom sınırı da buraya
  // eklenecek.
  double? _pinchStartScale;
  Offset? _pinchStartPan;
  Offset? _pinchStartFocalPoint;
  double? _pinchStartDistance;

  // Tek parmakla süregelen bir çizim/silgi/şekil hareketi varsa onu
  // olduğu gibi SONLANDIRIR (ör. ikinci parmak değince): yarım kalmış bir
  // stroke kaybolmaz, o ana kadar çizilen kaydedilir. Böylece kullanıcı
  // "çiz sonra pan/zoom'a geç" akışında hiçbir şey kaybetmez.
  // İkinci parmak devreye girdiğinde, süregelen tek-parmak hareketinin
  // GERÇEK bir sürükleme mi yoksa parmağın henüz hiç hareket etmemiş,
  // sadece ilk değdiği nokta mı olduğunu ayırt eder. Kullanıcı iki
  // parmağını (hemen hemen) aynı anda tuvale koyduğunda, İLK parmağın
  // pointer-down'ı bu ayrımdan önce zaten "tek parmakla çizim" akışını
  // başlatmış oluyordu (bkz. _onPointerDown): ikinci parmak değer değmez
  // bu, hiç sürüklenmeden commit ediliyor ve tuvale istenmeyen bir NOKTA
  // bırakıyordu — kullanıcının her yakınlaştırma (pinch) denemesinde
  // gördüğü sorun buydu. Eşik, dokunma/sürükleme ayrımında kullanılan
  // _kTapMoveThreshold ile aynıdır.
  bool _isNegligibleLiveMovement() {
    final pts = _livePoints;
    if (pts == null || pts.isEmpty) return true;
    if (pts.length == 1) return true;
    return (pts.last - pts.first).distance <= _kTapMoveThreshold;
  }

  void _finishOrCommitActiveSingleFingerGesture() {
    if (_activePointerId == null) return;
    _activePointerId = null;
    _tapDownScreenPos = null;
    // İkinci parmağın devreye girmesi bir "dokunma" değil, pan/zoom'a
    // geçiştir; çift-dokunma sayacını da sıfırlıyoruz ki daha sonraki
    // masum bir tek dokunma buna yanlışlıkla eklenmesin.
    _lastTapUpTime = null;
    _lastTapUpScreenPos = null;
    if (_eraser) {
      widget.onChanged(_cloneStrokes(_strokes));
    } else if (_isNegligibleLiveMovement()) {
      // Henüz gerçek bir sürükleme olmadan ikinci parmak geldi: kullanıcı
      // muhtemelen doğrudan iki parmakla yakınlaştırmaya başlamıştır.
      // Bekleyen canlı noktayı SESSİZCE iptal ediyoruz — commit etmiyoruz,
      // tuvale istenmeyen bir nokta/stroke eklenmiyor ve boş bir geri al
      // adımı da oluşmuyor (çünkü _history.push artık _finishStroke()
      // içinde, sadece gerçekten commit edilirse atılıyor).
      _livePoints = null;
      _shapeStartPoint = null;
      setState(() {});
    } else {
      _finishStroke();
    }
  }

  // Parmaklar jestin BAŞINDA birbirine çok yakınsa (ör. sadece kaydırmak
  // isteyip parmakları yan yana koyan bir kullanıcı), _pinchStartDistance
  // çok küçük bir değer olur. Ölçek oranı (currentDistance/_pinchStartDistance)
  // bu durumda paydası küçük bir bölme olduğundan, sürüklerken oluşan en
  // ufak bir el titremesi bile orantısız büyük bir ölçek/pan sıçramasına
  // yol açar — kaydırma sırasında "aniden yanlış yöne zıplama" hissi
  // burada da oluşabilir. Payda bu taban değerin altına düşmeyecek şekilde
  // sınırlanarak bu aşırı duyarlılık engellenir.
  static const double _kMinPinchBaselineDistance = 24.0;

  void _startPinchGesture() {
    final positions = _activePointers.values.toList();
    if (positions.length < 2) return;
    final p0 = positions[0];
    final p1 = positions[1];
    _pinchStartFocalPoint = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
    _pinchStartDistance = (p0 - p1).distance;
    _pinchStartScale = _scale;
    _pinchStartPan = _panOffset;
  }

  // Parmaklar arası mesafe değişimine göre ölçeği, odak noktası (iki
  // parmağın orta noktası) sabit kalacak şekilde de kaydırmayı günceller
  // — standart "pinch to zoom" matematiği: dönüşüm sırası pan sonra scale
  // olduğundan (bkz. _canvasTransform: translate -> scale), odak
  // noktasındaki tuval koordinatı jest boyunca DEĞİŞMEMELİDİR.
  void _updatePinchGesture() {
    final positions = _activePointers.values.toList();
    if (positions.length < 2) return;
    if (_pinchStartDistance == null ||
        _pinchStartDistance == 0 ||
        _pinchStartScale == null ||
        _pinchStartPan == null ||
        _pinchStartFocalPoint == null) {
      return;
    }
    final p0 = positions[0];
    final p1 = positions[1];
    final currentDistance = (p0 - p1).distance;
    final currentFocal = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
    final safeStartDistance = _pinchStartDistance! < _kMinPinchBaselineDistance
        ? _kMinPinchBaselineDistance
        : _pinchStartDistance!;
    final rawScale = _pinchStartScale! * (currentDistance / safeStartDistance);
    final newScale = rawScale.clamp(kMinDrawingZoom, kMaxDrawingZoom);
    final newPan = currentFocal -
        (_pinchStartFocalPoint! - _pinchStartPan!) *
            (newScale / _pinchStartScale!);
    _applyTransform(newScale, newPan);
  }

  // ── AŞAMA 1.3: Ekran -> Tuval Koordinat Dönüşümü ──────────────────────
  // _canvasTransform, tuvali GÖRSEL olarak ekranda taşıyıp büyütüyor
  // (translate sonra scale). Bir parmağın ekrandaki (event.localPosition)
  // konumu, hangi tuval noktasına denk geldiğini bulmak için bu
  // dönüşümün TERSİ uygulanır. Böylece stroke'lar HER ZAMAN sabit
  // (zoom/pan'dan bağımsız) tuval koordinat sisteminde kaydedilir —
  // hangi zoom seviyesinde çizilirse çizilsin veri tutarlı kalır ve
  // dışa aktarma (PDF/JPG, bkz. NoteDrawingRenderer) hep aynı 1:1
  // koordinatları görür.
  Offset _screenToCanvas(Offset screenPos) {
    final inverse = Matrix4.inverted(_canvasTransform);
    return MatrixUtils.transformPoint(inverse, screenPos);
  }

  void _endPinchGestureIfDone() {
    if (_activePointers.length >= 2) return;
    _pinchStartScale = null;
    _pinchStartPan = null;
    _pinchStartFocalPoint = null;
    _pinchStartDistance = null;
  }

  void _onPointerDown(PointerDownEvent event) {
    if (_activePointers.length >= 2 &&
        !_activePointers.containsKey(event.pointer)) {
      // Üçüncü ve sonraki parmaklar (ör. ekrana değen avuç içi) haritaya
      // HİÇ eklenmez: eklenirse, bu parmak kalkıp ilk iki parmaktan biri
      // hâlâ basılıyken _activePointers'ın sırası değişir ve süregelen
      // pinch jesti YANLIŞ bir parmak çiftinin konumlarını taban alarak
      // aniden zıplar/yanlış köşeden büyür. Bu yüzden pan/zoom jesti,
      // BAŞLADIĞI ilk iki parmağın konumlarıyla bozulmadan devam eder.
      return;
    }
    _activePointers[event.pointer] = event.localPosition;

    if (_activePointers.length == 2) {
      // Tam olarak ikinci parmak şimdi değdi: tek-parmak hareketi varsa
      // önce sonlandır, sonra pan/zoom moduna geç.
      _finishOrCommitActiveSingleFingerGesture();
      _startPinchGesture();
      return;
    }

    // Tam olarak TEK parmak: mevcut çizim/silgi/şekil akışı (davranış
    // Aşama 1.1 öncesiyle birebir aynı).
    if (_activePointerId != null) return;
    _activePointerId = event.pointer;
    _tapDownScreenPos = event.localPosition;

    final pos = _screenToCanvas(event.localPosition);
    if (_eraser) {
      // Silgi anında mevcut durumu değiştirir, bu yüzden geri al kaydı
      // hemen (silme başlamadan önce) atılır.
      _history.push(_cloneStrokes(_strokes));
      _eraseAt(pos);
    } else if (_shapeTool != null) {
      // Şekil modu: sadece başlangıç noktasını sakla; canlı önizleme her
      // zaman [başlangıç, güncel_konum] olarak tutulur (bkz. _onPointerMove).
      // NOT: geri al kaydı BURADA atılmıyor — henüz hiçbir stroke
      // eklenmedi. Kayıt, gerçekten bir stroke eklendiğinde _finishStroke()
      // içinde atılır (bkz. orada ve _finishOrCommitActiveSingleFingerGesture
      // içindeki not: ikinci parmak pinch başlatırsa buradaki başlangıç
      // noktası hiç commit edilmeyebilir, o durumda gereksiz bir geri al
      // adımı da eklenmemiş olur).
      _shapeStartPoint = pos;
      _livePoints = [pos, pos];
      setState(() {});
    } else {
      // AYNI NOT: geri al kaydı burada değil, _finishStroke()'ta atılır.
      _livePoints = [pos];
      setState(() {});
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_activePointers.containsKey(event.pointer)) {
      _activePointers[event.pointer] = event.localPosition;
    }

    if (_pinchStartScale != null && _activePointers.length >= 2) {
      _updatePinchGesture();
      return;
    }

    // Aktif olmayan (ör. ilk parmaktan sonra değen ikinci) parmağın hareket
    // olaylarını yok say — yalnızca çizimi başlatan parmak izlenir.
    if (event.pointer != _activePointerId) return;
    final pos = _screenToCanvas(event.localPosition);
    if (_eraser) {
      _eraseAt(pos);
    } else if (_shapeTool != null) {
      if (_shapeStartPoint != null) {
        setState(() => _livePoints = [_shapeStartPoint!, pos]);
      }
    } else if (_livePoints != null) {
      setState(() => _livePoints!.add(pos));
    }
  }

  void _finishStroke() {
    if (_livePoints != null && _livePoints!.isNotEmpty) {
      // Yeni stroke eklenmeden HEMEN önce geri al kaydı atılır (eskiden
      // parmak tuvale ilk değdiği anda atılıyordu — bkz. _onPointerDown'daki
      // güncellenmiş not). Böylece gerçekten bir şey çizilmeyen (ör. pinch
      // başlatan) hareketler geri al yığınında boş adım bırakmaz.
      _history.push(_cloneStrokes(_strokes));
      _strokes.add({
        'color': _color.toARGB32(),
        'width': _strokeWidth,
        'opacity': 1.0,
        'blend': 'normal',
        'shape': _shapeTool ?? 'freehand',
        'points': _livePoints!.map((o) => [o.dx, o.dy]).toList(),
      });
    }
    _livePoints = null;
    _shapeStartPoint = null;
    setState(() {});
    widget.onChanged(_cloneStrokes(_strokes));
  }

  void _onPointerUp(PointerUpEvent event) {
    _activePointers.remove(event.pointer);

    if (_pinchStartScale != null) {
      // İki parmaktan biri kalktı: pan/zoom jesti burada biter. Kalan tek
      // parmak (varsa) OTOMATİK çizime devam ETMEZ — kullanıcı çizmek
      // için parmağını kaldırıp yeniden dokunmalı; aksi halde pinch'in
      // son anındaki kayma yanlışlıkla bir çizgi gibi algılanabilir.
      _endPinchGestureIfDone();
      return;
    }

    // Aktif parmak dışındaki (ör. iki parmakla dokunulmuşken ikinci
    // parmağın kalkması) olaylar yok sayılır; aktif çizim etkilenmez.
    if (event.pointer != _activePointerId) return;
    _activePointerId = null;

    final downPos = _tapDownScreenPos;
    final upPos = event.localPosition;
    _tapDownScreenPos = null;
    final wasTap =
        downPos != null && (upPos - downPos).distance <= _kTapMoveThreshold;

    if (_eraser) {
      widget.onChanged(_cloneStrokes(_strokes));
    } else {
      _finishStroke();
    }

    if (!wasTap) {
      // Bir sürükleme (çizgi/silme) oldu, dokunma değil: çift dokunma
      // sayacı sıfırlanır ki sürükleme + sonraki dokunma yanlışlıkla
      // çift dokunma sayılmasın.
      _lastTapUpTime = null;
      _lastTapUpScreenPos = null;
      return;
    }

    final now = DateTime.now();
    final isDoubleTap = _lastTapUpTime != null &&
        now.difference(_lastTapUpTime!) <= _kDoubleTapMaxInterval &&
        _lastTapUpScreenPos != null &&
        (upPos - _lastTapUpScreenPos!).distance <= _kDoubleTapMaxDistance;

    if (isDoubleTap) {
      _lastTapUpTime = null;
      _lastTapUpScreenPos = null;
      if (!_eraser) {
        _removeTrailingNegligibleStrokes(2);
      }
      _resetZoom();
    } else {
      _lastTapUpTime = now;
      _lastTapUpScreenPos = upPos;
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _activePointers.remove(event.pointer);

    if (_pinchStartScale != null) {
      _endPinchGestureIfDone();
      return;
    }

    if (event.pointer != _activePointerId) return;
    _activePointerId = null;
    _tapDownScreenPos = null;
    if (!_eraser) {
      _livePoints = null;
      _shapeStartPoint = null;
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
    // Paletteki topun GÖSTERİLEN rengi ile tuvale gerçekte çizilecek renk
    // birbirini tutsun diye burada da dNoteEffectiveStrokeColor uygulanır.
    // Örn. açık temada "beyaz" preset artık siyah bir top olarak görünür,
    // çünkü ona basılıp çizim yapıldığında zaten siyah çıkacaktır (bkz.
    // _DrawingPainter.paint). Tıklama/seçim karşılaştırması ise HAM (c)
    // değer üzerinden yapılmaya devam eder; sadece görünüm değişir.
    final displayColor = dNoteEffectiveStrokeColor(dNoteIsDark(context), c);
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
          color: displayColor,
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
      onTap: () => setState(() {
        _eraser = true;
        _shapeTool = null;
      }),
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

  // Silgi modunu ("Kısmi" <-> "Tam") değiştiren küçük anahtar. Yalnızca
  // silgi aracı seçiliyken (bkz. _eraser) araç çubuğunda görünür — diğer
  // araçlar seçiliyken bir anlamı olmadığından build() içinde koşullu
  // eklenir. Kısmi modda silgi yalnızca dokunulan noktaları kaldırır
  // (piksel bazlı); tam modda ise dokunulan stroke'un tamamını siler
  // (eski davranış). Bkz. _eraseAt.
  Widget _eraserModeToggleButton() {
    final label = _partialEraser ? 'Kısmi' : 'Tam';
    final icon = _partialEraser ? Icons.auto_fix_high : Icons.delete_sweep;
    return InkWell(
      onTap: () => setState(() => _partialEraser = !_partialEraser),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: Colors.amber),
            const SizedBox(width: 3),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.amber),
            ),
          ],
        ),
      ),
    );
  }

  // Şekil araçları (düz çizgi / dikdörtgen / elips) için ortak buton.
  // Seçilince silgi kapanır; kalemin renk+kalınlık ayarları aynen
  // kullanılmaya devam eder (sadece nokta toplama biçimi değişir,
  // bkz. _onPointerDown/_onPointerMove).
  Widget _shapeToolButton({required IconData icon, required String shape}) {
    return _toolButton(
      icon: icon,
      selected: !_eraser && _shapeTool == shape,
      onTap: () => setState(() {
        _eraser = false;
        _shapeTool = shape;
      }),
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
    // bırakma riski ortadan kalkıyor. AŞAMA 3.1: aynı ayrım zoom/pan için
    // de geçerlidir — pinch, +/− butonları, çift dokunmayla sıfırlama ve
    // zoom'a duyarlı silgi, aşağıdaki tam ekran dalının DIŞINA hiç
    // sızmaz (bkz. _scale alanının başındaki not).
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                // AŞAMA 2.1: +/− zoom butonlarının odak noktası olarak
                // kullanacağı tuval GÖRÜNÜM alanının (viewport) o anki
                // boyutu. setState ÇAĞRILMAZ — sadece bir sonraki buton
                // tıklamasında okunacak bir alan güncellenir, build
                // döngüsüne ekstra bir rebuild eklemez.
                _viewportSize = constraints.biggest;
                return ClipRect(
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: _onPointerDown,
                onPointerMove: _onPointerMove,
                onPointerUp: _onPointerUp,
                onPointerCancel: _onPointerCancel,
                // AŞAMA 1.1: Tuval, _canvasTransform (_scale/_panOffset)
                // ile sarmalanır. Listener BİLEREK bu Transform'un
                // DIŞINDA kalır: pointer olayları hâlâ ekran (widget)
                // koordinatında gelir, tuval koordinatına çevirme işi
                // Aşama 1.3'te ayrıca yapılacak. Şu an _scale=1.0 ve
                // _panOffset=Offset.zero olduğundan bu katman kimlik
                // (identity) dönüşümdür — görünürde hiçbir şey değişmez.
                child: Transform(
                  transform: _canvasTransform,
                  child: CustomPaint(
                    painter: _DrawingPainter(
                      strokes: _strokes,
                      livePoints: _livePoints,
                      liveColor: _color,
                      liveWidth: _strokeWidth,
                      liveOpacity: 1.0,
                      liveBlend: 'normal',
                      liveShape: _shapeTool ?? 'freehand',
                      isDark: dNoteIsDark(context),
                    ),
                    size: Size.infinite,
                  ),
                ),
              ),
                );
              },
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
                    selected: !_eraser && _shapeTool == null,
                    onTap: () => setState(() {
                      _eraser = false;
                      _shapeTool = null;
                    }),
                  ),
                  _eraserToolButton(),
                  if (_eraser) _eraserModeToggleButton(),
                  _divider(),
                  _shapeToolButton(icon: Icons.horizontal_rule, shape: 'line'),
                  _shapeToolButton(
                    icon: Icons.crop_square_outlined,
                    shape: 'rect',
                  ),
                  _shapeToolButton(
                    icon: Icons.circle_outlined,
                    shape: 'ellipse',
                  ),
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
                  _divider(),
                  IconButton(
                    tooltip: 'Uzaklaştır',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.zoom_out,
                      size: 20,
                      color: Colors.grey,
                    ),
                    onPressed: _zoomOut,
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${(_scale * 100).round()}%',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Yakınlaştır',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.zoom_in,
                      size: 20,
                      color: Colors.grey,
                    ),
                    onPressed: _zoomIn,
                  ),
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
                      isDark: dNoteIsDark(context),
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

  // O an sürüklenmekte olan (henüz strokes'a eklenmemiş) canlı önizlemenin
  // opaklığı ve karışım modu. Fosforlu kalem aracı kaldırıldığından artık
  // her zaman 1.0 / 'normal' olarak gelir; alanlar yalnızca daha önce
  // kaydedilmiş fosforlu-kalem stroke'larının (s['opacity']/s['blend'])
  // doğru render edilmeye devam etmesi için painter'da tutulur (bkz. paint).
  // Varsayılanlar, bu alanları vermeyen eski çağrı yerlerini (ör.
  // salt-önizleme kullanımları) etkilemez.
  final double liveOpacity;
  final String liveBlend;

  // O an sürüklenmekte olan canlı önizlemenin şekli: 'freehand' (varsayılan,
  // noktaları birleştiren serbest çizgi) veya 'line'/'rect'/'ellipse'
  // (yalnızca livePoints'in ilk ve son noktası arasındaki geometrik şekil).
  // Şekil araçları modunda livePoints her zaman [başlangıç, güncel_konum]
  // şeklinde 2 elemanlıdır (bkz. _NoteDrawingBlockState._onPointerMove).
  final String liveShape;

  // O an aktif olan tema koyu mu? true değilse (açık temada) saf beyaz
  // renkli stroke'lar dNoteEffectiveStrokeColor ile siyaha çevrilerek
  // çizilir (bkz. yukarıdaki fonksiyon açıklaması). Varsayılan true:
  // bu alanı vermeyen (henüz güncellenmemiş) çağrı yerleri eskisi gibi
  // davranmaya devam eder.
  final bool isDark;

  _DrawingPainter({
    required this.strokes,
    required this.livePoints,
    required this.liveColor,
    required this.liveWidth,
    this.liveOpacity = 1.0,
    this.liveBlend = 'normal',
    this.liveShape = 'freehand',
    this.isDark = true,
  });

  void _paintStroke(
    Canvas canvas,
    List<Offset> points,
    Color color,
    double strokeWidth, {
    double opacity = 1.0,
    BlendMode blendMode = BlendMode.srcOver,
  }) {
    if (points.isEmpty) return;
    final paint = Paint()
      ..color = color.withValues(alpha: color.a * opacity)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..blendMode = blendMode
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

  // Düz çizgi / dikdörtgen / elips çizer. [p0]/[p1], stroke'un kayıtlı
  // (veya sürüklenmekte olan) 'points' listesinin sırasıyla ilk ve son
  // noktasıdır — mevcut nokta tabanlı ('points': [[x,y], ...]) şemayla tam
  // uyumlu, sadece serbest el çiziminde olduğu gibi ARADAKİ noktalar değil,
  // bu iki köşe kullanılır.
  void _paintShape(
    Canvas canvas,
    String shape,
    Offset p0,
    Offset p1,
    Color color,
    double strokeWidth, {
    double opacity = 1.0,
    BlendMode blendMode = BlendMode.srcOver,
  }) {
    final paint = Paint()
      ..color = color.withValues(alpha: color.a * opacity)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..blendMode = blendMode
      ..style = PaintingStyle.stroke;
    switch (shape) {
      case 'line':
        canvas.drawLine(p0, p1, paint);
        break;
      case 'rect':
        canvas.drawRect(Rect.fromPoints(p0, p1), paint);
        break;
      case 'ellipse':
        canvas.drawOval(Rect.fromPoints(p0, p1), paint);
        break;
    }
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
      final rawColor = Color((s['color'] as num?)?.toInt() ?? 0xFFFFFFFF);
      final color = dNoteEffectiveStrokeColor(isDark, rawColor);
      final strokeWidth = (s['width'] as num?)?.toDouble() ?? 3.0;
      final opacity = (s['opacity'] as num?)?.toDouble() ?? 1.0;
      final blend = s['blend'] as String? ?? 'normal';
      final blendMode =
          blend == 'multiply' ? BlendMode.multiply : BlendMode.srcOver;
      final shape = s['shape'] as String? ?? 'freehand';
      if (shape == 'freehand') {
        _paintStroke(
          canvas,
          pts,
          color,
          strokeWidth,
          opacity: opacity,
          blendMode: blendMode,
        );
      } else if (pts.length >= 2) {
        _paintShape(
          canvas,
          shape,
          pts.first,
          pts.last,
          color,
          strokeWidth,
          opacity: opacity,
          blendMode: blendMode,
        );
      }
    }
    if (livePoints != null) {
      final liveBlendMode =
          liveBlend == 'multiply' ? BlendMode.multiply : BlendMode.srcOver;
      final effectiveLiveColor = dNoteEffectiveStrokeColor(isDark, liveColor);
      if (liveShape == 'freehand') {
        _paintStroke(
          canvas,
          livePoints!,
          effectiveLiveColor,
          liveWidth,
          opacity: liveOpacity,
          blendMode: liveBlendMode,
        );
      } else if (livePoints!.length >= 2) {
        _paintShape(
          canvas,
          liveShape,
          livePoints!.first,
          livePoints!.last,
          effectiveLiveColor,
          liveWidth,
          opacity: liveOpacity,
          blendMode: liveBlendMode,
        );
      }
    }
  }

  // isDark değiştiğinde (tema değişince) de yeniden boyanması gerektiğinden,
  // basitlik için zaten her frame'de yeniden çiziyoruz (strokes listesi
  // genelde küçük kalır; performans sorun olursa ileride önbelleğe alınabilir).
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
//
// AŞAMA 3.2 DOĞRULAMASI: Bu sınıf, çağıran tarafın (bkz. yukarıdaki
// currentStrokesSnapshot) verdiği strokes listesiyle KENDİ _DrawingPainter
// örneğini oluşturur ve KENDİ Canvas'ına (recorder üzerinden) doğrudan
// çizer — widget ağacındaki _NoteDrawingBlockState'in _scale/_panOffset/
// _canvasTransform alanlarına HİÇ erişimi yoktur, onlardan tamamen
// bağımsız çalışır (aşağıdaki paint çağrısında hiçbir Transform
// uygulanmaz). Dolayısıyla PDF/JPG dışa aktarma, kullanıcı dışa
// aktardığı anda tuval hangi zoom/pan seviyesinde görünüyor olursa
// olsun, HER ZAMAN stroke'ların kayıtlı 1:1 tuval koordinatlarıyla
// render edilir.
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

  // requiredCanvasHeight ile birebir aynı mantık, yatay eksen için.
  // ÖNEMLİ: gömülü (küçük) tuval, not editörünün içerik genişliğini
  // (kenar boşluklu) kullanırken; tam ekran çizim modu KENAR BOŞLUKSUZ
  // (bkz. _openFullscreen — SafeArea dışında hiçbir padding yok), yani
  // ekranın tam genişliğini kullanır. Kullanıcı tam ekranda çizdiğinde
  // stroke'lar, dışa aktarmada varsayılan olarak geçilen (daha dar)
  // phoneContentWidth değerinden daha geniş bir X aralığına yayılabilir.
  // Sabit bir genişlikle render edilirse bu değeri aşan sağ taraftaki
  // stroke'lar PNG'nin dışında kalıp görünmez olurdu (kırpılma). Bu
  // yüzden dışa aktarmadan önce gerçek çizilmiş içeriğin yatay kapsamına
  // göre gereken genişliği hesaplıyoruz; içerik [minWidth]'ten dar ise
  // yine de en az [minWidth] döner.
  static double requiredCanvasWidth(
    List<Map<String, dynamic>> strokes, {
    required double minWidth,
  }) {
    double maxX = 0;
    for (final s in strokes) {
      final strokeWidth = (s['width'] as num?)?.toDouble() ?? 0;
      final points = (s['points'] as List? ?? const []);
      for (final pt in points) {
        final x = (pt[0] as num).toDouble() + strokeWidth / 2;
        if (x > maxX) maxX = x;
      }
    }
    final needed = maxX + 16; // sağ kenara küçük bir pay
    return needed > minWidth ? needed : minWidth;
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
