part of 'main.dart';

// ignore_for_file: unused_element

mixin NoteListLifecycleMixin on State<NoteListScreen> {
  // ---- Diğer mixin'lerde tanımlı, burada kullanılan üyeler ----
  Map<String, String> get _categoryColors;
  set _categoryColors(Map<String, String> value);
  Future<void> _loadData();
  List<Map<String, dynamic>> get _notes;
  set _notes(List<Map<String, dynamic>> value);
  Future<void> _openNoteWithPasswordCheck(int index);
  Future<void> _saveData();
  void _showNoteDialog({ int? index, String type = 'text', String? initialText, });


  final List<Color> _categoryPalette = [
    Color(0xFFFFD600), // Canlı sarı
    Color(0xFFFF6D00), // Turuncu
    Color(0xFFFF1744), // Kırmızı
    Color(0xFFFF4081), // Pembe
    Color(0xFFD500F9), // Mor
    Color(0xFF651FFF), // Derin mor
    Color(0xFF2979FF), // Mavi
    Color(0xFF00B0FF), // Açık mavi
    Color(0xFF00E5FF), // Turkuaz
    Color(0xFF00E676), // Yeşil
    Color(0xFFB2FF59), // Açık yeşil
    Color(0xFF69F0AE), // Nane yeşili
  ];

  Color _getCategoryColor(String? category) {
    if (category == null || category.isEmpty) return Colors.amber;
    final hex = _categoryColors[category];
    if (hex != null) {
      return Color(int.parse(hex, radix: 16));
    }
    return Colors.amber;
  }

  // Undo/redo checkpoint'leri için Map/List/ilkel değerlerden oluşan bir
  // veri ağacının derin kopyasını çıkarır (blocks, checkItems, attachments
  // gibi UI nesnesi barındırmayan not içeriği alanları için kullanılır).
  dynamic _deepClone(dynamic value) {
    if (value is Map) {
      // ÖNEMLİ: value burada 'dynamic' tipinde olduğu için (parametre
      // dynamic value), Dart .map() çağrısını statik tip bilgisi olmadan
      // dinamik olarak çözüyor ve callback'in K/V tiplerini de 'dynamic'e
      // düşürüyor — orijinal harita gerçekte Map<String, dynamic> olsa
      // bile klon her zaman Map<dynamic, dynamic> (çalışma zamanı tipi
      // '_Map<dynamic, dynamic>') oluyordu. Bu da undo/redo sonrası
      // checklist/hesap tablosu bloklarında rebuildBlockControllers'ın
      // yaptığı List<Map<String, dynamic>>.from(...) çağrısının "type
      // '_Map<dynamic, dynamic>' is not a subtype of type
      // 'Map<String, dynamic>'" hatasıyla çökmesine yol açıyordu (düz
      // metin blokları bu kod yoluna hiç girmediği için fark edilmiyordu).
      // Çözüm: .map()'e açıkça <String, dynamic> tip argümanı vererek
      // klonun her zaman doğru tipte üretilmesini garanti ediyoruz.
      return value.map<String, dynamic>(
        (k, v) => MapEntry(k as String, _deepClone(v)),
      );
    }
    if (value is List) {
      return value.map(_deepClone).toList();
    }
    return value;
  }

  String _searchQuery = "";
  bool _isSearching = false;

  String _sortCriteria = "Oluşturulma";
  bool _isAscending = true;
  bool _isListView = true;

  // ── Ayarlar ──────────────────────────────────────────────
  // Güvenlik
  bool _notePasswordEnabled = false;
  String _notePassword = '';
  String _passwordHintQuestion = '';
  String _passwordHintAnswer = '';

  // Tema (Açık / Koyu / Sistem) — gerçek kaynak appThemeMode notifier'ıdır,
  // burada sadece Ayarlar ekranındaki seçili seçeneği göstermek için tutulur.
  ThemeMode _themeMode = ThemeMode.dark;
  bool _colorfulNotes = false;

  // Kişiselleştirme
  String _fontFamily = 'Varsayılan';
  double _globalFontSize = 16.0;
  // null == "Varsayılan": temaya göre otomatik (koyu temada beyaz, açık
  // temada koyu gri). Kullanıcı Metin Rengi seçiciden bir renk seçerse bu
  // alan o rengi tutar ve tema değişse bile sabit kalır.
  Color? _textColor;
  int _previewLines = 3;

  // Widget
  double _widgetFontSize = 14.0;
  double _widgetBgOpacity = 1.0;
  bool _widgetDark = true;
  // ─────────────────────────────────────────────────────────

  OverlayEntry? _snackOverlay;
  Timer? _snackTimer;
  // Not kartlarında görsel önizleme gösterebilmek için eklerin fiziksel
  // klasör yolu; uygulama açılışında bir kez okunup önbelleğe alınır.
  String? _attachmentsDirPath;
  // Başka bir uygulamadan "Paylaş" ile gönderilen metin/bağlantıları
  // yakalamak için kullanılan akış aboneliği (bkz. _initShareListener).
  StreamSubscription<List<SharedMediaFile>>? _shareIntentSub;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    DBHelper.instance.attachmentsDir().then((d) {
      if (mounted) setState(() => _attachmentsDirPath = d.path);
    });
    _initShareListener();
    // Uygulama açıkken (arka planda veya ön planda) bir DNote bildirimine
    // (hatırlatıcı veya bildirim paneline sabitlenmiş not) dokunulduğunda
    // ilgili notu aç. Soğuk başlangıç durumu _loadData() içinde ayrıca ele
    // alınıyor (bkz. ReminderService.getLaunchNoteId).
    ReminderService.instance.onNotificationTapped = _openNoteByIdFromNotification;
    // Bildirim paneline sabitlenmiş bir notun bildirimindeki "Kaldır"
    // aksiyonuna, uygulama süreci canlıyken (ön planda veya arka planda)
    // dokunulduğunda tetiklenir. Süreç tamamen kapalıyken aynı aksiyon
    // doğrudan ReminderService içindeki arka plan işleyicisi tarafından ele
    // alınır (bkz. reminder_service.dart).
    ReminderService.instance.onUnpinRequested =
        _handleUnpinRequestedFromNotification;
  }

  // Bildirimdeki "Kaldır" aksiyonuna dokunulunca çağrılır. Bildirimin
  // kendisi zaten sistem tarafından otomatik kapatılmıştır; burada yalnızca
  // notun sabitleme bayrağını kapatıp veritabanına yazarak listeyi
  // senkronize ederiz. Not artık listede yoksa (ör. arada silinmişse)
  // sessizce hiçbir şey yapılmaz.
  void _handleUnpinRequestedFromNotification(String noteId) {
    final index = _notes.indexWhere((n) => n['id']?.toString() == noteId);
    if (index == -1 || _notes[index]['isPinnedToNotification'] != true) {
      return;
    }
    setState(() => _notes[index]['isPinnedToNotification'] = false);
    _saveData();
  }

  // Bir bildirime dokunularak (payload = notun id'si) ilgili notu açar.
  // Not bulunamazsa (ör. o arada silinmişse) sessizce hiçbir şey yapmaz.
  void _openNoteByIdFromNotification(String noteId) {
    final index = _notes.indexWhere((n) => n['id']?.toString() == noteId);
    if (index == -1) return;
    // Widget ağacı henüz tam hazır olmayabilir (özellikle soğuk
    // başlangıçta); bir sonraki frame'e ertelenir.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _openNoteWithPasswordCheck(index);
    });
  }

  @override
  void dispose() {
    // Bekleyen "Not silindi" zamanlayıcısı, State dispose edildikten sonra
    // ateşlenirse _hideDeletedBar() dispose edilmiş bir context/overlay'e
    // erişmeye çalışırdı; bu yüzden burada iptal ediliyor. Aynı şekilde
    // _titleController ve _searchController da hiç dispose edilmiyordu.
    _snackTimer?.cancel();
    _snackOverlay?.remove();
    _shareIntentSub?.cancel();
    _titleController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ── Başka uygulamalardan paylaşılan link/metni yakalama ───────────────
  // Kullanıcı bir tarayıcıdan veya başka bir uygulamadan "Paylaş" menüsünden
  // DNote'u seçtiğinde, gelen metin (genellikle bir link) burada yakalanır
  // ve yeni not oluşturma ekranı bu metinle önceden doldurulmuş olarak
  // açılır. İki senaryo ele alınır:
  //   1) Uygulama zaten açıkken paylaşım yapılırsa -> getMediaStream()
  //   2) Uygulama paylaşımla birlikte ilk kez (kapalıyken) açılırsa
  //      -> getInitialMedia()
  void _initShareListener() {
    _shareIntentSub = ReceiveSharingIntent.instance.getMediaStream().listen(
      (files) {
        _handleSharedMedia(files);
        ReceiveSharingIntent.instance.reset();
      },
      onError: (Object _) {},
    );
    ReceiveSharingIntent.instance.getInitialMedia().then((files) {
      if (files.isNotEmpty) {
        _handleSharedMedia(files);
        ReceiveSharingIntent.instance.reset();
      }
    });
  }

  // Paylaşılan dosya listesinden metin/bağlantı içeriğini çıkarır ve yeni
  // not oluşturma dialogunu bu içerikle açar. Şimdilik yalnızca metin/URL
  // türü ele alınıyor; resim/dosya paylaşımı ileride attachments listesine
  // eklenerek genişletilebilir.
  void _handleSharedMedia(List<SharedMediaFile> files) {
    if (files.isEmpty) return;
    final textFile = files.firstWhere(
      (f) => f.type == SharedMediaType.text || f.type == SharedMediaType.url,
      orElse: () => files.first,
    );
    if (textFile.type != SharedMediaType.text &&
        textFile.type != SharedMediaType.url) {
      return;
    }
    final sharedText = textFile.path.trim();
    if (sharedText.isEmpty) return;
    // Widget ağacı henüz tam çizilmemiş olabileceğinden bir sonraki
    // frame'e ertelenir (özellikle soğuk başlangıçta önemlidir).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showNoteDialog(type: 'text', initialText: sharedText);
    });
  }
}
