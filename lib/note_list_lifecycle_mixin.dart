part of 'main.dart';

// ignore_for_file: unused_element

mixin NoteListLifecycleMixin on State<NoteListScreen>, WidgetsBindingObserver {
  // ---- Diğer mixin'lerde tanımlı, burada kullanılan üyeler ----
  Map<String, String> get _categoryColors;
  set _categoryColors(Map<String, String> value);
  Future<void> _loadData();
  List<Map<String, dynamic>> get _notes;
  set _notes(List<Map<String, dynamic>> value);
  Future<void> _openNoteWithPasswordCheck(int index, {bool openInstantly = false});
  Future<void> _saveData();
  Future<void> _showNoteDialog({ int? index, String type = 'text', String? initialText, });


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
    if (category == null || category.isEmpty) return appAccentColor.value;
    final hex = _categoryColors[category];
    if (hex != null) {
      return Color(int.parse(hex, radix: 16));
    }
    return appAccentColor.value;
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

  String _sortCriteria = "Son Düzenleme";
  bool _isAscending = false;
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
  // Dil (Sistem / Türkçe / English) — gerçek kaynak appLanguage notifier'ıdır,
  // burada sadece Ayarlar ekranındaki seçili seçeneği göstermek için tutulur.
  String _appLanguage = 'system';
  bool _colorfulNotes = false;
  // Vurgu Rengi — gerçek kaynak appAccentColor notifier'ıdır, burada sadece
  // Ayarlar ekranındaki seçili rengi göstermek için tutulur (bkz. theme.dart).
  Color _accentColor = Colors.amber;

  // Kişiselleştirme
  String _fontFamily = 'Varsayılan';
  double _globalFontSize = 16.0;
  // null == "Varsayılan": temaya göre otomatik (koyu temada beyaz, açık
  // temada koyu gri). Kullanıcı Metin Rengi seçiciden bir renk seçerse bu
  // alan o rengi tutar ve tema değişse bile sabit kalır.
  Color? _textColor;
  int _previewLines = 3;
  // Not düzenleme/görüntüleme ekranındaki metin bloklarının satır aralığı
  // çarpanı (TextStyle.height). Önceden bu değer sabit 1.6 olarak
  // kodlanmıştı (bkz. note_list_note_dialog_mixin.dart, buildTextBlockField);
  // varsayılan olarak aynı görünümü korumak için başlangıç değeri de 1.6.
  double _noteLineHeight = 1.6;

  // Widget
  double _widgetFontSize = 22.0;
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
  // Ana ekran widget'ına, uygulama açıkken (ön/arka plan) tıklanınca gelen
  // URI'leri yakalamak için kullanılan akış aboneliği (bkz.
  // _initWidgetClickListener). Soğuk başlangıç durumu ayrıca initState
  // içinde HomeWidget.initiallyLaunchedFromHomeWidget() ile ele alınır.
  StreamSubscription<Uri?>? _widgetClickSub;

  // Aşama 2: _titleController artık düz TextEditingController değil,
  // RichBlockTextController — gövde bloklarındaki controller'larla aynı
  // desende.
  // NOT: RichBlockTextController'ın 'text' parametresi için varsayılan
  // değeri (muhtemelen '') doğrulayamadım — gövde bloklarındaki her
  // kullanımda text: açıkça veriliyordu. Eğer text: zorunluysa
  // aşağıdaki satıra text: '' eklemek gerekir.
  late final RichBlockTextController _titleController =
      RichBlockTextController(getSpans: () => _titleSpans);
  // Aşama 3 revizyonu: span'lar artık düz bir List alanında değil, TEK
  // 'spans' anahtarlı bir Map içinde tutuluyor — birebir gövde
  // bloklarındaki desen (block['spans']). Sebep: _resolveFocusedSpansHolder()
  // başlık odaktayken bir Map<String, dynamic> döndürmeli ki
  // _toggleSpanAttribute/_applyValueAttribute içindeki merkezi
  // 'spansHolder['spans'] = newSpans' yazımı GERÇEK veriye işlesin —
  // düz bir List'i bu şekilde "referansla döndürüp içini değiştirmek"
  // mümkün değil, bu yüzden holder'ın kendisi artık Map.
  // _titleSpans getter/setter'ı (Aşama 1'den beri actions_mixin'in ve
  // dialog_mixin'in captureSnapshot/applySnapshot'ının kullandığı arayüz)
  // AYNEN korunuyor — bu Map'in üstünde ince bir List görünümü sağlıyor,
  // o yüzden bu iki dosyada BAŞKA HİÇBİR DEĞİŞİKLİK gerekmedi.
  Map<String, dynamic> _titleSpansHolder = {
    'spans': <Map<String, dynamic>>[],
  };
  List<Map<String, dynamic>> get _titleSpans =>
      ((_titleSpansHolder['spans'] as List?) ?? const [])
          .cast<Map<String, dynamic>>();
  set _titleSpans(List<Map<String, dynamic>> value) =>
      _titleSpansHolder['spans'] = value;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Uygulama arka plan/ön plan geçişlerini yakalamak için (bkz. aşağıdaki
    // didChangeAppLifecycleState). _NoteListScreenState artık
    // WidgetsBindingObserver ile mixin edildi (note_list_screen.dart).
    WidgetsBinding.instance.addObserver(this);
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
    _initWidgetClickListener();
    // BUG DÜZELTMESİ: bir yedek geri yüklendiğinde (cihazdan veya Google
    // Drive'dan) veritabanı güncelleniyordu ama bu ekranın bellekteki
    // _notes/_categories listeleri tazelenmiyordu — kullanıcı uygulamayı
    // kapatıp açana kadar geri yüklenen notları göremiyordu. BackupHelper,
    // restoreBackup() başarıyla bittiğinde bu callback'i tetikler.
    BackupHelper.instance.onRestoreCompleted = () {
      if (mounted) _loadData();
    };
  }

  // ── Ana ekran widget'ına tıklanınca ilgili notu açma ───────────────────
  // Widget'a tıklanınca native taraf (NoteWidgetReceiverV2.kt / NoteWidget.kt)
  // uygulamayı "dnote://note?id=..." biçiminde bir URI ile açar. "Yeni Not
  // Ekle" ikon widget'ı (NewNoteWidgetReceiver.kt) ise "dnote://newnote"
  // biçiminde, id taşımayan ayrı bir URI ile açar (bkz. aşağıdaki
  // _handleWidgetLaunchUri'deki host ayrımı). Bu URI'ler iki farklı yoldan
  // Dart'a ulaşabilir:
  //   1) Uygulama tamamen kapalıyken widget'a tıklanırsa (soğuk başlangıç)
  //      -> HomeWidget.initiallyLaunchedFromHomeWidget()
  //   2) Uygulama zaten açıkken (ön/arka planda) widget'a tıklanırsa
  //      -> HomeWidget.widgetClicked akışı
  void _initWidgetClickListener() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_handleWidgetLaunchUri);
    _widgetClickSub = HomeWidget.widgetClicked.listen(_handleWidgetLaunchUri);
  }

  // Widget URI'sini host'a göre iki dala ayırır:
  //   - "dnote://newnote" -> boş bir not oluşturma dialogunu açar (bkz.
  //     NewNoteWidgetReceiver.kt).
  //   - "dnote://note?id=..." (veya id'siz "dnote://note") -> mevcut
  //     davranış: id'ye göre _notes içinde arar, bulursa notu açar. Not
  //     bulunamazsa (ör. o arada silinmişse) sessizce hiçbir şey yapmaz.
  void _handleWidgetLaunchUri(Uri? uri) {
    if (uri == null) return;

    if (uri.host == 'newnote') {
      // Widget ağacı henüz tam hazır olmayabilir (özellikle soğuk
      // başlangıçta); bir sonraki frame'e ertelenir.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showNoteDialog(type: 'text');
      });
      return;
    }

    final noteId = uri.queryParameters['id'];
    if (noteId == null || noteId.isEmpty) return;
    final index = _notes.indexWhere((n) => n['id']?.toString() == noteId);
    if (index == -1) return;
    // Widget ağacı henüz tam hazır olmayabilir (özellikle soğuk
    // başlangıçta); bir sonraki frame'e ertelenir.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // openInstantly: true -> widget'tan tıklanınca not editörü 300ms'lik
      // açılış animasyonu olmadan anında açılır (bkz.
      // NoteListNoteDialogMixin._showNoteDialog). Bildirimden açılışta
      // (_openNoteByIdFromNotification) bu bayrak KASITLI olarak
      // verilmiyor; orası eskisi gibi animasyonlu kalır.
      _openNoteWithPasswordCheck(index, openInstantly: true);
    });
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
    _widgetClickSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    BackupHelper.instance.onRestoreCompleted = null;
    _titleController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ── Arka plan/ön plan geçişlerini yakalama ─────────────────────────────
  // Soğuk açılışta main.dart -> _initBackgroundServices() zaten
  // AutoBackupService.checkAndRunIfDue()'yu çağırıyor. Ancak kullanıcı
  // uygulamayı hiç tam kapatmadan (cold start olmadan) günlerce arka
  // planda tutabilir — bu durumda main() bir daha çalışmaz, ve eğer
  // WorkManager görevi bu sırada bir OEM tarafından sessizce
  // öldürülmüşse otomatik yedekleme fiilen hiç tetiklenmez. Bu yüzden
  // uygulama her ön plana (resumed) döndüğünde de aynı "yakalama"
  // kontrolünü tekrarlıyoruz. checkAndRunIfDue() zaten ucuz bir kontrol
  // (son yedek zamanına bakıp süre dolmadıysa hemen çıkıyor), o yüzden
  // her resume'da çağrılması sorun teşkil etmez.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(AutoBackupService.instance.checkAndRunIfDue());
    }
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
