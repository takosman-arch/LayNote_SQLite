part of 'main.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> _notes = [];
  List<Map<String, dynamic>> _deletedNotes = [];
  List<String> _categories = [];
  Map<String, String> _categoryColors = {};
  Set<String> _lockedCategories = {};
  String _activeCategory = 'Tümü';
  DateTime? _lastBackPressTime;

  // ── Çoklu seçim modu ─────────────────────────────────────────────
  // Bir nota basılı tutup açılan eylem panelinden "Seç" seçilince aktif
  // olur. Aktifken notlara dokunmak açmak yerine seçimi açar/kapatır ve
  // üst panelde arama/sıralama/görünüm butonları yerine toplu eylem
  // butonları (sil, arşiv, kategori) gösterilir.
  bool _isSelectionMode = false;
  Set<String> _selectedNoteKeys = {};

  // Bir notu tekil biçimde tanımlamak için id + oluşturulma tarihi
  // birleşimi kullanılır (liste içinde id tek başına benzersiz olmayabilir).
  String _noteKey(Map<String, dynamic> note) =>
      '${note['id']}_${note['createdDate']}';

  void _enterSelectionMode(Map<String, dynamic> note) {
    setState(() {
      _isSelectionMode = true;
      _selectedNoteKeys = {_noteKey(note)};
    });
  }

  void _toggleNoteSelection(Map<String, dynamic> note) {
    final key = _noteKey(note);
    setState(() {
      if (_selectedNoteKeys.contains(key)) {
        _selectedNoteKeys.remove(key);
        if (_selectedNoteKeys.isEmpty) _isSelectionMode = false;
      } else {
        _selectedNoteKeys.add(key);
      }
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedNoteKeys.clear();
    });
  }

  // Seçili notları çöp kutusuna taşır (tekil silme ile aynı mantık,
  // toplu olarak uygulanır).
  void _deleteSelectedNotes() {
    final selected = _notes
        .where((n) => _selectedNoteKeys.contains(_noteKey(n)))
        .toList();
    if (selected.isEmpty) {
      _exitSelectionMode();
      return;
    }
    for (final note in selected) {
      final noteId = note['id']?.toString();
      if (noteId != null) {
        ReminderService.instance.cancel(noteId);
        if (note['isPinnedToNotification'] == true) {
          ReminderService.instance.unpinFromNotificationPanel(noteId);
        }
      }
    }
    setState(() {
      _notes.removeWhere((n) => _selectedNoteKeys.contains(_noteKey(n)));
      _deletedNotes.addAll(selected);
      _isSelectionMode = false;
      _selectedNoteKeys.clear();
    });
    _saveData();
    _showInfoBar('${selected.length} not silindi', icon: Icons.delete_outline);
  }

  // Seçili notların tümü zaten arşivliyse arşivden çıkarır, aksi halde
  // hepsini arşivler.
  void _archiveSelectedNotes() {
    final selected = _notes
        .where((n) => _selectedNoteKeys.contains(_noteKey(n)))
        .toList();
    if (selected.isEmpty) {
      _exitSelectionMode();
      return;
    }
    final allArchived = selected.every((n) => n['isArchived'] == true);
    setState(() {
      for (final n in selected) {
        n['isArchived'] = !allArchived;
      }
      _isSelectionMode = false;
      _selectedNoteKeys.clear();
    });
    _saveData();
    _showInfoBar(
      allArchived ? 'Arşivden çıkarıldı' : 'Arşivlendi',
      icon: allArchived ? Icons.unarchive_outlined : Icons.archive_outlined,
    );
  }

  // Seçili notların tümüne aynı kategoriyi atar.
  void _showClassifyDialogForSelection() {
    final selectedKeys = Set<String>.from(_selectedNoteKeys);
    if (selectedKeys.isEmpty) {
      _exitSelectionMode();
      return;
    }

    void assignCategory(String? category) {
      setState(() {
        for (final n in _notes) {
          if (selectedKeys.contains(_noteKey(n))) {
            n['category'] = category;
          }
        }
        _isSelectionMode = false;
        _selectedNoteKeys.clear();
      });
      _saveData();
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: dNoteCardColor(context),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dNoteIsDark(sheetContext)
                        ? Colors.grey[700]
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '${selectedKeys.length} not için kategori seç',
                style: TextStyle(
                  color: dNoteTextColor(sheetContext),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.add_circle_outline,
                  color: dNoteTextColor(sheetContext),
                ),
                title: Text(
                  'Kategori Ekle',
                  style: TextStyle(
                    color: dNoteTextColor(sheetContext),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showAddCategoryDialog(
                    onAdded: (name) {
                      assignCategory(name);
                    },
                  );
                },
              ),
              if (_categories.isNotEmpty) ...[
                Divider(color: Theme.of(sheetContext).dividerColor, height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 280),
                  child: ListView(
                    shrinkWrap: true,
                    children: _categories.map((cat) {
                      final catColor = _getCategoryColor(cat);
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.folder_outlined,
                          color: catColor,
                        ),
                        title: Text(
                          cat,
                          style: TextStyle(color: dNoteTextColor(sheetContext)),
                        ),
                        onTap: () {
                          Navigator.pop(sheetContext);
                          assignCategory(cat);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
              Divider(color: Theme.of(sheetContext).dividerColor, height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.label_off_outlined,
                  color: Colors.red,
                ),
                title: const Text(
                  'Kategoriyi Kaldır',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  assignCategory(null);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const List<Color> _categoryPalette = [
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

  Future<void> _loadData() async {
    final db = DBHelper.instance;

    final catData = await db.getCategoriesData();
    final notes = await db.getNotes();
    final deletedNotes = await db.getDeletedNotes();
    final settings = await db.getAllSettings();
    // Veritabanı hiç yazılmamışsa (uygulamanın ilk açılışı) 'never
    // initialized' durumu; bu durumda hoş geldin notu eklenir. Kullanıcı
    // daha sonra tüm notlarını silerse (notes tablosu boş ama initialized
    // işaretli) hoş geldin notu tekrar EKLENMEZ.
    final bool neverInitialized = !settings.containsKey('_initialized');

    setState(() {
      _categories = List<String>.from(catData['categories'] as List);
      _categoryColors = Map<String, String>.from(catData['colors'] as Map);
      _lockedCategories = Set<String>.from(catData['locked'] as Set);

      if (notes.isNotEmpty || !neverInitialized) {
        _notes = notes;
      } else {
        _notes = [
          {
            'id': '2026-06-18 22:05:00',
            'title': 'DNote\'a Hoş Geldiniz! 🚀',
            'content': 'Yeni özellikler eklendi!',
            'date': '18.06.2026 22:05',
            'createdDate': '2026-06-18 22:05:00',
            'modifiedDate': '2026-06-18 22:05:00',
            'category': null,
            'color': 'Amber',
            'type': 'text',
            'isLocked': false,
          },
        ];
      }

      _deletedNotes = deletedNotes;

      _sortCriteria = settings['sort_criteria'] ?? 'Oluşturulma';
      _isAscending = (settings['is_ascending'] ?? 'true') == 'true';
      _isListView = (settings['is_list_view'] ?? 'true') == 'true';
      _activeCategory = 'Tümü'; // Her açılışta Notlar ekranından başlat
      // Güvenlik: uygulama kapanıp açıldığında "Kilitli" klasörü şifre
      // sorulmadan otomatik açılmasın; varsayılan görünüme dön.
      if (_activeCategory == '__locked__') {
        _activeCategory = 'Tümü';
      }

      // Ayarlar
      _notePasswordEnabled =
          (settings['note_password_enabled'] ?? 'false') == 'true';
      _notePassword = settings['note_password'] ?? '';
      _passwordHintQuestion = settings['password_hint_question'] ?? '';
      _passwordHintAnswer = settings['password_hint_answer'] ?? '';
      if (settings.containsKey('theme_mode')) {
        _themeMode = themeModeFromSettingValue(settings['theme_mode']);
      } else {
        // Eski sürümden gelen 'dark_theme' (true/false) ayarını göç ettir.
        _themeMode = (settings['dark_theme'] ?? 'true') == 'true'
            ? ThemeMode.dark
            : ThemeMode.light;
      }
      // Uygulama genelindeki temayı da senkronize et (açılışta main() zaten
      // ayarlamıştı, ama eski 'dark_theme' göçü burada da tutarlı olsun).
      appThemeMode.value = _themeMode;
      _colorfulNotes = (settings['colorful_notes'] ?? 'false') == 'true';
      _fontFamily = settings['font_family'] ?? 'Varsayılan';
      _globalFontSize =
          double.tryParse(settings['global_font_size'] ?? '') ?? 16.0;
      final textColorVal = int.tryParse(settings['text_color'] ?? '');
      _textColor = textColorVal != null ? Color(textColorVal) : null;
      _previewLines = int.tryParse(settings['preview_lines'] ?? '') ?? 3;
      _widgetFontSize =
          double.tryParse(settings['widget_font_size'] ?? '') ?? 14.0;
      _widgetBgOpacity =
          double.tryParse(settings['widget_bg_opacity'] ?? '') ?? 1.0;
      _widgetDark = (settings['widget_dark'] ?? 'true') == 'true';
    });

    // İlk açılışta oluşturulan hoş geldin notunu kalıcı hale getir ve
    // veritabanının artık başlatılmış olduğunu işaretle.
    if (neverInitialized) {
      await db.replaceNotes(_notes);
      await db.setSetting('_initialized', 'true');
    }

    // Sistem tarafından temizlenmiş olabilecek "bildirim paneline
    // sabitlenmiş" not bildirimlerini yeniden göster (bkz. ReminderService
    // .restorePinnedNotes). Ekranı bloklamaması için bekletilmez.
    ReminderService.instance.restorePinnedNotes(_notes);
  }

  Future<void> _saveData() async {
    final db = DBHelper.instance;
    await db.replaceNotes(_notes);
    await db.replaceDeletedNotes(_deletedNotes);
    await db.replaceCategories(_categories, _categoryColors, _lockedCategories);

    await db.setSetting('_initialized', 'true');
    await db.setSetting('sort_criteria', _sortCriteria);
    await db.setSetting('is_ascending', _isAscending.toString());
    await db.setSetting('is_list_view', _isListView.toString());
    await db.setSetting('active_category', _activeCategory);

    // Ayarlar
    await db.setSetting(
      'note_password_enabled',
      _notePasswordEnabled.toString(),
    );
    await db.setSetting('note_password', _notePassword);
    await db.setSetting('password_hint_question', _passwordHintQuestion);
    await db.setSetting('password_hint_answer', _passwordHintAnswer);
    await db.setSetting('theme_mode', themeModeToSettingValue(_themeMode));
    await db.setSetting('colorful_notes', _colorfulNotes.toString());
    await db.setSetting('font_family', _fontFamily);
    await db.setSetting('global_font_size', _globalFontSize.toString());
    await db.setSetting('text_color', _textColor?.toARGB32().toString());
    await db.setSetting('preview_lines', _previewLines.toString());
    await db.setSetting('widget_font_size', _widgetFontSize.toString());
    await db.setSetting('widget_bg_opacity', _widgetBgOpacity.toString());
    await db.setSetting('widget_dark', _widgetDark.toString());
  }

  // Kısa Türkçe tarih biçimi: "Tem 20, 21:17" — alt bardaki ve not
  // altındaki (hatırlatıcı) tarih gösterimlerinde kullanılır.
  static const List<String> _shortMonthNamesTr = [
    'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
    'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara',
  ];

  String _formatDateTimeShortTr(DateTime dt) {
    final month = _shortMonthNamesTr[dt.month - 1];
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$month ${dt.day}, $hour:$minute';
  }

  String _getFormattedDate([DateTime? date]) {
    final now = date ?? DateTime.now();
    return _formatDateTimeShortTr(now);
  }

  int _getCountForCategory(String category) {
    return _notes.where((note) {
      final isArchived = note['isArchived'] == true;
      final isFavorite = note['isFavorite'] == true;
      final isLocked = note['isLocked'] == true;

      if (category == 'Tümü' || category == 'Notlar') {
        return !isArchived && !isLocked;
      } else if (category == '__favorites__') {
        return isFavorite && !isArchived && !isLocked;
      } else if (category == '__locked__') {
        return isLocked && !isArchived;
      } else if (category == '__archive__') {
        return isArchived && !isLocked;
      } else if (category == '__reminders__') {
        return _hasActiveReminder(note) && !isArchived && !isLocked;
      } else {
        return !isArchived && !isLocked && note['category'] == category;
      }
    }).length;
  }

  String _getCategoryDisplayName(String category) {
    if (category == 'Tümü' || category == 'Notlar') {
      return 'Notlar';
    } else if (category == '__favorites__') {
      return 'Favori';
    } else if (category == '__locked__') {
      return 'Kilitli';
    } else if (category == '__archive__') {
      return 'Arşiv';
    } else if (category == '__trash__') {
      return 'Çöp';
    } else if (category == '__reminders__') {
      return 'Hatırlatıcı';
    } else {
      return category;
    }
  }

  void _deleteCategory(String category) {
    setState(() {
      _categories.remove(category);
      _categoryColors.remove(category);
      _lockedCategories.remove(category);
      for (final note in _notes) {
        if (note['category'] == category) {
          note['category'] = null;
        }
      }
      for (final note in _deletedNotes) {
        if (note['category'] == category) {
          note['category'] = null;
        }
      }
      if (_activeCategory == category) {
        _activeCategory = 'Tümü';
      }
    });
    _saveData();
  }

  void _showCategoryOptions(String category) {
    final isLocked = _lockedCategories.contains(category);
    showModalBottomSheet(
      context: context,
      backgroundColor: dNoteCardColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dNoteIsDark(sheetContext)
                        ? Colors.grey[700]
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  category,
                  style: TextStyle(
                    color: dNoteTextColor(sheetContext),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.edit_outlined,
                  color: dNoteTextColor(sheetContext),
                ),
                title: Text(
                  'Adını Düzenle / Renk',
                  style: TextStyle(color: dNoteTextColor(sheetContext)),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showAddCategoryDialog(editingCategory: category);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  isLocked ? Icons.lock_open_outlined : Icons.lock_outline,
                  color: Colors.blueGrey,
                ),
                title: Text(
                  isLocked ? 'Kilidi Kaldır' : 'Kilitle',
                  style: TextStyle(color: dNoteTextColor(sheetContext)),
                ),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  if (!_notePasswordEnabled) {
                    // Parola belirlenmemişse artık "Parola Gerekiyor"
                    // uyarı dialogu yerine doğrudan "Yeni Parola Oluştur"
                    // ekranı açılır; parola belirlenince kategori aynı
                    // işlem içinde kilitlenir.
                    final created = await _showCreatePasswordDialog();
                    if (!mounted || !created) return;
                    setState(() {
                      if (isLocked) {
                        _lockedCategories.remove(category);
                      } else {
                        _lockedCategories.add(category);
                        if (_activeCategory == category) {
                          _activeCategory = 'Tümü';
                        }
                      }
                    });
                    _saveData();
                    _showInfoBar(
                      isLocked ? 'Kilit kaldırıldı' : 'Kategori kilitlendi',
                      icon: isLocked ? Icons.lock_open : Icons.lock,
                    );
                    return;
                  }
                  final ok = await _checkPasswordPrompt();
                  if (!mounted) return;
                  if (ok) {
                    setState(() {
                      if (isLocked) {
                        _lockedCategories.remove(category);
                      } else {
                        _lockedCategories.add(category);
                        if (_activeCategory == category) {
                          _activeCategory = 'Tümü';
                        }
                      }
                    });
                    _saveData();
                    _showInfoBar(
                      isLocked ? 'Kilit kaldırıldı' : 'Kategori kilitlendi',
                      icon: isLocked ? Icons.lock_open : Icons.lock,
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: dNoteCardColor(ctx),
                        title: const Text(
                          'Hatalı Parola',
                          style: TextStyle(color: Colors.red),
                        ),
                        content: Text(
                          'Girdiğiniz parola yanlış.',
                          style: TextStyle(color: dNoteTextColor(ctx)),
                        ),
                        actions: [
                          ElevatedButton(
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
                        ],
                      ),
                    );
                  }
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Kategoriyi Sil',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  showDialog(
                    context: context,
                    builder: (confirmContext) => AlertDialog(
                      backgroundColor: dNoteCardColor(confirmContext),
                      title: const Text(
                        'Kategoriyi Sil',
                        style: TextStyle(color: Colors.amber),
                      ),
                      content: Text(
                        '"$category" kategorisini silmek istediğinize emin misiniz? Bu kategorideki notlar kategorisiz kalacak.',
                        style: TextStyle(color: dNoteTextColor(confirmContext)),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(confirmContext),
                          child: const Text(
                            'İptal',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.pop(confirmContext);
                            _deleteCategory(category);
                          },
                          child: const Text(
                            'Sil',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteNote(int index) {
    final deletedNote = _notes[index];
    final noteId = deletedNote['id']?.toString();
    if (noteId != null) {
      ReminderService.instance.cancel(noteId);
      if (deletedNote['isPinnedToNotification'] == true) {
        ReminderService.instance.unpinFromNotificationPanel(noteId);
      }
    }
    setState(() {
      _notes.removeAt(index);
      _deletedNotes.add(deletedNote);
    });
    _saveData();

    _showDeletedBar(deletedNote);
  }

  // Bir not çöp kutusundan geri yüklendiğinde veya kopyalandığında, hâlâ
  // gelecekte olan bir hatırlatıcısı varsa (ya da tekrarlıysa) bildirimini
  // yeniden planlar.
  void _rescheduleNoteReminder(Map<String, dynamic> note) {
    final noteId = note['id']?.toString();
    final rawReminder = note['reminderDate']?.toString();
    if (noteId == null || rawReminder == null || rawReminder.isEmpty) return;
    final reminder = DateTime.tryParse(rawReminder);
    if (reminder == null) return;
    final repeat = note['reminderRepeat']?.toString();
    final isRepeating = repeat == 'hourly' ||
        repeat == 'daily' ||
        repeat == 'weekly' ||
        repeat == 'monthly' ||
        repeat == 'yearly';
    if (!isRepeating && reminder.isBefore(DateTime.now())) return;
    final title = (note['title'] ?? '').toString();
    final preview = ContentBlocks.plainText(note['content']?.toString());
    ReminderService.instance.schedule(
      noteId: noteId,
      title: title.isEmpty ? 'Hatırlatıcı' : title,
      body: (note['type'] == 'checklist')
          ? 'Kontrol listeni kontrol etmeyi unutma'
          : (preview.isEmpty ? 'Notunu kontrol etmeyi unutma' : preview),
      dateTime: reminder,
      repeat: repeat,
    );
  }

  // Not listesinden (düzenleyici açılmadan) uzun basma menüsüyle bir notun
  // hatırlatıcısını ayarlar/kaldırır ve bildirimi buna göre yeniden planlar.
  void _updateNoteReminder(int index, DateTime? reminder, String? repeat) {
    if (index < 0 || index >= _notes.length) return;
    final note = _notes[index];
    final noteId = (note['id'] ?? DateTime.now().toString()).toString();
    final savedRepeat = reminder != null ? repeat : null;
    setState(() {
      _notes[index] = {
        ...note,
        'reminderDate': reminder?.toIso8601String(),
        'reminderRepeat': savedRepeat,
      };
    });
    _saveData();
    if (reminder != null) {
      final title = (note['title'] ?? '').toString();
      final preview = ContentBlocks.plainText(note['content']?.toString());
      ReminderService.instance.schedule(
        noteId: noteId,
        title: title.isEmpty ? 'Hatırlatıcı' : title,
        body: (note['type'] == 'checklist')
            ? 'Kontrol listeni kontrol etmeyi unutma'
            : (preview.isEmpty ? 'Notunu kontrol etmeyi unutma' : preview),
        dateTime: reminder,
        repeat: savedRepeat,
      );
      _showInfoBar('Hatırlatıcı ayarlandı', icon: Icons.alarm);
    } else {
      ReminderService.instance.cancel(noteId);
      _showInfoBar('Hatırlatıcı kaldırıldı', icon: Icons.alarm_off);
    }
  }

  // Bir notun ekli dosyalarını diskten siler (not kalıcı olarak silinirken
  // çağrılır). Not verisinin kendisine dokunmaz.
  void _cleanupAttachmentFiles(Map<String, dynamic> note) {
    final noteId = note['id']?.toString();
    if (noteId != null) {
      ReminderService.instance.cancel(noteId);
    }
    final atts = note['attachments'];
    if (atts is List) {
      for (final a in atts) {
        final storedName = (a as Map)['storedName']?.toString();
        if (storedName != null) {
          DBHelper.instance.deleteAttachmentFile(storedName);
        }
      }
    }
  }

  Future<void> _duplicateNote(int index) async {
    final original = _notes[index];
    final now = DateTime.now();
    final newRawTime = now.toString();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final formattedDate = '$day.$month.${now.year} $hour:$minute';
    final duplicate = Map<String, dynamic>.from(original);
    duplicate['id'] = newRawTime;
    duplicate['createdDate'] = newRawTime;
    duplicate['modifiedDate'] = newRawTime;
    duplicate['date'] = formattedDate;
    duplicate['assignedDate'] = newRawTime;

    // checkItems ve attachments listeleri orijinalle AYNI referansı
    // paylaşmasın diye derin kopya alınır.
    final origCheckItems = original['checkItems'];
    if (origCheckItems is List) {
      duplicate['checkItems'] = origCheckItems
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }

    final origAttachments = original['attachments'];
    // Eski ek id'sinden yeni (kopyalanmış) ek id'sine eşleme; içerikteki
    // ('content' JSON'ındaki 'attachments' blokları) referanslar bu haritaya
    // göre güncellenir. Bir ekin dosyası kopyalanamamışsa
    // (silinmiş/bozuk vs.) haritada yer almaz ve içerikteki referansı
    // temizlenir — aksi halde kopya notta "var olmayan" bir eke işaret eden
    // kırık bir görsel kutusu kalırdı.
    final idMap = <String, String>{};
    if (origAttachments is List && origAttachments.isNotEmpty) {
      // Ekli dosyaların kendisi de diskte fiziksel olarak kopyalanır; aksi
      // halde iki not aynı dosyayı paylaşır ve biri kalıcı silinince
      // diğerinin eki de kaybolur.
      final duplicatedAttachments = await DBHelper.instance
          .duplicateAttachmentFiles(
            List<Map<String, dynamic>>.from(
              origAttachments.map((e) => Map<String, dynamic>.from(e as Map)),
            ),
          );
      for (final a in duplicatedAttachments) {
        final oldId = a['oldId']?.toString();
        final newId = a['id']?.toString();
        if (oldId != null && newId != null) idMap[oldId] = newId;
        a.remove('oldId');
      }
      duplicate['attachments'] = duplicatedAttachments;
    }

    // Not içeriğinde ('content' alanı) gömülü ek referanslarını (metne
    // gömülü 'attachments' bloklarındaki attachmentId'ler) yukarıdaki
    // eşlemeye göre güncelle. Sadece 'text'
    // tipi notlarda anlamlıdır: 'checklist' notlarında content her zaman
    // boş string olarak tutulur, dokunulursa gereksiz yere JSON blok
    // biçimine çevrilirdi.
    if (original['type'] == 'text' &&
        original['content'] != null &&
        idMap.isNotEmpty) {
      duplicate['content'] = _remapContentAttachmentIds(
        original['content'] as String?,
        idMap,
      );
    }

    setState(() => _notes.insert(index + 1, duplicate));
    _saveData();
    _rescheduleNoteReminder(duplicate);
    _showInfoBar('Kopya oluşturuldu', icon: Icons.copy_all);
  }

  // ContentBlocks'u çözüp, 'attachments' bloklarındaki id listesini verilen
  // eşlemeye (eski id -> yeni id) göre günceller. Eşlemede karşılığı olmayan
  // bir id (örn. dosyası kopyalanamadığı için atlanmış bir ek) referanstan
  // tamamen çıkarılır.
  String _remapContentAttachmentIds(
    String? rawContent,
    Map<String, String> idMap,
  ) {
    final blocks = ContentBlocks.parse(rawContent);
    for (final block in blocks) {
      if (block['type'] == 'attachments') {
        final ids = List<String>.from(block['ids'] ?? const []);
        block['ids'] = ids.where(idMap.containsKey).map((id) => idMap[id]!).toList();
      }
    }
    return ContentBlocks.serialize(blocks);
  }

  // "Sesi Yazıya Çevir" eylemi, not düzenleyicisi açık DEĞİLKEN (kart üzerinde
  // uzun basılarak) seçildiğinde çağrılır: düzenleyicideki imleç konumu gibi
  // bir bağlam olmadığından, çevrilen metin doğrudan notun sonuna eklenir
  // (kontrol listesinde yeni bir madde, serbest metin notunda ise son metin
  // bloğunun sonuna).
  Future<void> _appendSpeechTranscriptToNote(int noteIndex, String text) async {
    if (noteIndex < 0 || noteIndex >= _notes.length) return;
    final note = _notes[noteIndex];
    if (note['type'] == 'checklist') {
      final items = List<Map<String, dynamic>>.from(
        note['checkItems'] ?? const [],
      );
      items.add({'text': text, 'checked': false});
      setState(() {
        note['checkItems'] = items;
        note['modifiedDate'] = DateTime.now().toString();
      });
    } else {
      final blocks = ContentBlocks.parse(note['content']?.toString());
      final lastTextIdx = blocks.lastIndexWhere((b) => b['type'] == 'text');
      if (lastTextIdx == -1) {
        blocks.add({'type': 'text', 'text': text});
      } else {
        final current = (blocks[lastTextIdx]['text'] ?? '').toString();
        final needsNewline =
            current.isNotEmpty && !current.endsWith('\n');
        blocks[lastTextIdx]['text'] =
            current + (needsNewline ? '\n' : '') + text;
      }
      setState(() {
        note['content'] = ContentBlocks.serialize(blocks);
        note['modifiedDate'] = DateTime.now().toString();
      });
    }
    await _saveData();
    if (mounted) {
      _showInfoBar('Metin nota eklendi', icon: Icons.graphic_eq);
    }
  }

  Future<void> _copyNoteContent(int index) async {
    final note = _notes[index];
    final title = (note['title'] ?? '').toString().trim();
    final content = ContentBlocks.plainText(note['content'] as String?);
    final text = [
      if (title.isNotEmpty) title,
      if (content.isNotEmpty) content,
    ].join('\n\n');
    await Clipboard.setData(ClipboardData(text: text));
    // Not: panoya kopyalama işleminde Android zaten kendi sistem
    // bildirimini ("Kopyalandı.") gösteriyor; burada ayrıca bir uygulama
    // içi bildirim gösterilmiyor, aksi halde aynı anda iki bildirim
    // görünürdü.
  }

  // Kısa ömürlü durum bildirimi: ekranın altında, ortalanmış, içeriğe göre
  // daralan bir "toast" kapsülü olarak gösterilir (Android'in kendi sistem
  // bildirimleriyle tutarlı bir görünüm için). `icon`, bildirimi tetikleyen
  // eyleme uygun seçilmelidir (kopyalama, kilit, hatırlatıcı, kaydetme vb.).
  // actionLabel + onAction verilirse (ör. "Aç"), mesajın yanına küçük,
  // vurgulu bir metin düğmesi eklenir; dokununca onAction çalışır ve bar
  // hemen kapanır. Aksiyonlu barlar, kullanıcının dokunmaya vakti olsun
  // diye normalden biraz daha uzun (4 sn) açık kalır.
  void _showInfoBar(
    String message, {
    IconData icon = Icons.check_circle,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _hideDeletedBar();
    final hasAction = actionLabel != null && onAction != null;
    _snackOverlay = OverlayEntry(
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
                        _hideDeletedBar();
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
    Overlay.of(context).insert(_snackOverlay!);
    _snackTimer = Timer(
      Duration(seconds: hasAction ? 4 : 2),
      _hideDeletedBar,
    );
  }

  // Not düzenleyicideki üç nokta menüsünden çağrılır: notu PDF'e dönüştürür
  // ve kullanıcının native "Farklı Kaydet" diyaloğuyla seçtiği konuma
  // doğrudan kaydeder (paylaşım/uygulama seçim ekranı açılmaz). Hem metin
  // notları (bloklar) hem de kontrol listesi notları desteklenir.
  Future<void> _exportNoteAsPdf({
    required String title,
    required String noteType,
    required List<Map<String, dynamic>> blocks,
    required List<Map<String, dynamic>> checkItems,
    required List<Map<String, dynamic>> attachments,
    double fontSize = 16.0,
  }) async {
    debugPrint('[PDF] export başladı, attachments: ${attachments.length}');
    _showInfoBar('PDF hazırlanıyor…', icon: Icons.picture_as_pdf);
    try {
      // Not editöründeki satır kırılmalarıyla (ve görünen yazı boyutuyla)
      // PDF'in birebir aynı görünmesi için, PDF servisine telefonun gerçek
      // ekran genişliğini de veriyoruz. PDF sayfası (A4) telefon ekranından
      // çok daha geniş olduğundan, aynı sayısal fontSize değeri PDF'te
      // hem çok daha küçük görünüyor hem de satır başına çok daha fazla
      // kelime sığdığı için kelime bölünmeleri (word-wrap) editördekiyle
      // uyuşmuyordu.
      final phoneScreenWidth = MediaQuery.of(context).size.width;
      final file = await PdfExportService.exportNoteToPdf(
        title: title,
        noteType: noteType,
        blocks: blocks,
        checkItems: checkItems,
        attachments: attachments,
        fontSize: fontSize,
        phoneScreenWidth: phoneScreenWidth,
      );
      debugPrint('[PDF] dosya oluştu: ${file.path}');

      final bytes = await file.readAsBytes();
      final safeTitle = title.trim().isEmpty ? 'not' : title.trim();

      // bytes: verildiğinde file_picker, Android'de SAF (Storage Access
      // Framework) üzerinden seçilen konuma dosyayı kendisi yazar; bu
      // yüzden savedPath bazı cihazlarda gerçek bir dosya yolu değil,
      // açılamayan bir content URI olabilir. "Aç" aksiyonu bu yüzden
      // savedPath yerine, uygulamanın kendi oluşturduğu ve her zaman
      // doğrudan açılabilen geçici dosyayı (file.path) kullanır.
      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'PDF olarak kaydet',
        fileName: '$safeTitle.pdf',
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        bytes: bytes,
      );

      if (mounted && savedPath != null) {
        _showInfoBar(
          'PDF kaydedildi',
          icon: Icons.check_circle_outline,
          actionLabel: 'Aç',
          onAction: () => OpenFile.open(file.path),
        );
      }
      // savedPath null ise kullanıcı diyaloğu iptal etmiştir; hata değil,
      // bu yüzden herhangi bir bildirim gösterilmez.
    } catch (e, st) {
      debugPrint('[PDF] genel hata: $e\n$st');
      if (mounted) {
        _showInfoBar('PDF oluşturulamadı', icon: Icons.error_outline);
      }
    }
  }

  // Not düzenleyicideki üç nokta menüsünde "Dışa Aktar" öğesine basılınca
  // açılan alt menü. Şimdilik tek seçenek (PDF) içeriyor; ileride yeni dışa
  // aktarma biçimleri eklenirse buraya eklenmesi yeterli olur. Alt menü,
  // anchorKey ile verilen düğmenin (üç nokta ikonunun) hemen altında açılır.
  Future<void> _showExportSubmenu({
    required BuildContext context,
    required GlobalKey anchorKey,
    required String title,
    required String noteType,
    required List<Map<String, dynamic>> blocks,
    required List<Map<String, dynamic>> checkItems,
    required List<Map<String, dynamic>> attachments,
    double fontSize = 16.0,
  }) async {
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
      // Düğmenin konumu (ör. sayfa henüz tam çizilmediyse) alınamazsa
      // ekranın sağ üst köşesine yakın makul bir varsayılana düş.
      position = RelativeRect.fromLTRB(
        overlayBox.size.width - 220,
        kToolbarHeight,
        16,
        0,
      );
    }

    final selected = await showMenu<String>(
      context: context,
      position: position,
      items: const [
        PopupMenuItem(
          value: 'export_pdf',
          child: Row(
            children: [
              Icon(Icons.picture_as_pdf, color: Colors.redAccent, size: 20),
              SizedBox(width: 10),
              Text('PDF'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'export_jpg',
          child: Row(
            children: [
              Icon(Icons.image_outlined, color: Colors.blueAccent, size: 20),
              SizedBox(width: 10),
              Text('JPG'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'export_txt',
          child: Row(
            children: [
              Icon(
                Icons.description_outlined,
                color: Colors.greenAccent,
                size: 20,
              ),
              SizedBox(width: 10),
              Text('TXT'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'export_md',
          child: Row(
            children: [
              Icon(
                Icons.article_outlined,
                color: Colors.deepPurpleAccent,
                size: 20,
              ),
              SizedBox(width: 10),
              Text('MD'),
            ],
          ),
        ),
      ],
    );

    if (selected == 'export_pdf') {
      _exportNoteAsPdf(
        title: title,
        noteType: noteType,
        blocks: blocks,
        checkItems: checkItems,
        attachments: attachments,
        fontSize: fontSize,
      );
    } else if (selected == 'export_jpg') {
      _exportNoteAsJpg(
        context: context,
        title: title,
        noteType: noteType,
        blocks: blocks,
        checkItems: checkItems,
        attachments: attachments,
        fontSize: fontSize,
      );
    } else if (selected == 'export_txt') {
      _exportNoteAsTxt(
        title: title,
        noteType: noteType,
        blocks: blocks,
        checkItems: checkItems,
      );
    } else if (selected == 'export_md') {
      _exportNoteAsMarkdown(
        title: title,
        noteType: noteType,
        blocks: blocks,
        checkItems: checkItems,
      );
    }
  }

  // Not düzenleyicideki üç nokta > Dışa Aktar menüsünden çağrılır. Notu
  // önce mevcut PDF motoruyla sayfalara döker, ardından her sayfayı yüksek
  // çözünürlüklü bir JPG'e render eder ve kullanıcının native "Farklı
  // Kaydet" diyaloğuyla seçtiği konuma doğrudan kaydeder. Not tek sayfaya
  // sığıyorsa tek kaydetme diyaloğu açılır; birden fazla sayfaya
  // yayılıyorsa (nadir durum) her sayfa için ayrı bir kaydetme diyaloğu
  // sırayla açılır — file_picker tek seferde yalnızca bir dosya kaydını
  // güvenilir şekilde yazabildiğinden bu, çoklu dosyayı toplu biçimde
  // (ör. bir klasöre) yazmaktan daha az kırılgandır.
  // Not düzenleyicideki üç nokta > Dışa Aktar menüsünden çağrılır.
  // ESKİ YÖNTEM PDF üzerinden gidiyordu (PDF oluştur → sayfayı fotoğrafla);
  // bu yüzden JPG hep "kağıda basılmış" gibi görünüyordu (beyaz zemin, A4
  // oranı). Artık NoteScreenshotService ile notu doğrudan uygulamanın kendi
  // görünümüyle (koyu/açık tema, gerçek checkbox, telefon genişliği) statik
  // bir widget olarak çizip resme çeviriyoruz — yani gerçek bir ekran
  // görüntüsü almış gibi.
  Future<void> _exportNoteAsJpg({
    required BuildContext context,
    required String title,
    required String noteType,
    required List<Map<String, dynamic>> blocks,
    required List<Map<String, dynamic>> checkItems,
    required List<Map<String, dynamic>> attachments,
    double fontSize = 16.0,
  }) async {
    _showInfoBar('JPG hazırlanıyor…', icon: Icons.image_outlined);
    try {
      final jpgFile = await NoteScreenshotService.exportNoteAsScreenshotJpg(
        context: context,
        title: title,
        noteType: noteType,
        blocks: blocks,
        checkItems: checkItems,
        attachments: attachments,
        fontSize: fontSize,
        textColor: dNoteEffectiveTextColor(context, _textColor),
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

      if (mounted && savedPath != null) {
        _showInfoBar(
          'JPG kaydedildi',
          icon: Icons.check_circle_outline,
          actionLabel: 'Aç',
          onAction: () => OpenFile.open(jpgFile.path),
        );
      }
      // savedPath null ise kullanıcı diyaloğu iptal etmiştir; hata değil.
    } catch (e, st) {
      debugPrint('[JPG] genel hata: $e\n$st');
      if (mounted) {
        _showInfoBar('JPG oluşturulamadı', icon: Icons.error_outline);
      }
    }
  }

  // Not düzenleyicideki üç nokta > Dışa Aktar menüsünden çağrılır. Metin
  // notlarında bloklar düz metne çevrilir (ContentBlocks.plainText, hesap
  // tablosu bloklarını da okunabilir satırlara döker); kontrol listesi
  // notlarında her öğe "[x]"/"[ ]" işaretiyle satır satır yazılır. Başlık
  // (varsa) ilk satıra eklenir.
  Future<void> _exportNoteAsTxt({
    required String title,
    required String noteType,
    required List<Map<String, dynamic>> blocks,
    required List<Map<String, dynamic>> checkItems,
  }) async {
    _showInfoBar('TXT hazırlanıyor…', icon: Icons.description_outlined);
    try {
      final String body;
      if (noteType == 'checklist') {
        body = checkItems
            .map((item) {
              final checked = item['checked'] == true;
              final text = (item['text'] ?? '').toString();
              return '${checked ? '[x]' : '[ ]'} $text';
            })
            .join('\n');
      } else {
        body = ContentBlocks.plainText(ContentBlocks.serialize(blocks));
      }

      final buffer = StringBuffer();
      final trimmedTitle = title.trim();
      if (trimmedTitle.isNotEmpty) {
        buffer.writeln(trimmedTitle);
        buffer.writeln();
      }
      buffer.write(body);

      final tempDir = await getTemporaryDirectory();
      final safeName = trimmedTitle.isEmpty
          ? 'not_${DateTime.now().microsecondsSinceEpoch}'
          : trimmedTitle.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
      final outFile = File(p.join(tempDir.path, '$safeName.txt'));
      await outFile.writeAsString(buffer.toString());

      final bytes = await outFile.readAsBytes();
      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'TXT olarak kaydet',
        fileName: '$safeName.txt',
        type: FileType.custom,
        allowedExtensions: ['txt'],
        bytes: bytes,
      );

      if (mounted && savedPath != null) {
        _showInfoBar(
          'TXT kaydedildi',
          icon: Icons.check_circle_outline,
          actionLabel: 'Aç',
          onAction: () => OpenFile.open(outFile.path),
        );
      }
    } catch (_) {
      if (mounted) {
        _showInfoBar('TXT oluşturulamadı', icon: Icons.error_outline);
      }
    }
  }

  // _exportNoteAsMarkdown içinde metin notlarının bloklarını (serbest metin,
  // kontrol listesi ve hesap tablosu blokları) Markdown sözdizimine çevirir:
  // kontrol listesi blokları "- [ ]"/"- [x]" satırlarına, hesap tablosu
  // blokları ise iki sütunlu bir Markdown tablosuna dönüşür.
  String _blocksToMarkdown(List<Map<String, dynamic>> blocks) {
    final buffer = StringBuffer();
    for (final block in blocks) {
      final type = block['type'];
      if (type == 'text') {
        final text = (block['text'] ?? '').toString();
        if (text.trim().isEmpty) continue;
        buffer.writeln(text);
        buffer.writeln();
      } else if (type == 'checklist') {
        final items = (block['items'] as List?) ?? [];
        for (final item in items) {
          final map = item as Map;
          final checked = map['checked'] == true;
          final itemText = (map['text'] ?? '').toString();
          buffer.writeln('- [${checked ? 'x' : ' '}] $itemText');
        }
        buffer.writeln();
      } else if (type == 'calc_table') {
        final rows = (block['rows'] as List?) ?? [];
        if (rows.isNotEmpty) {
          buffer.writeln('| Etiket | Değer |');
          buffer.writeln('|---|---|');
          for (final row in rows) {
            final map = row as Map;
            final label = (map['label'] ?? '').toString();
            final value = (map['value'] ?? '').toString();
            buffer.writeln('| $label | $value |');
          }
          buffer.writeln();
        }
      }
    }
    return buffer.toString().trim();
  }

  // Not düzenleyicideki üç nokta > Dışa Aktar menüsünden çağrılır. Metin
  // notlarında bloklar _blocksToMarkdown ile Markdown'a çevrilir (kontrol
  // listesi blokları "- [ ]" satırlarına, hesap tablosu blokları gerçek bir
  // Markdown tablosuna dönüşür). Kontrol listesi notlarında her öğe aynı
  // "- [x]"/"- [ ]" biçiminde yazılır. Başlık varsa # başlık satırı olarak
  // eklenir.
  Future<void> _exportNoteAsMarkdown({
    required String title,
    required String noteType,
    required List<Map<String, dynamic>> blocks,
    required List<Map<String, dynamic>> checkItems,
  }) async {
    _showInfoBar('Markdown hazırlanıyor…', icon: Icons.article_outlined);
    try {
      final String body;
      if (noteType == 'checklist') {
        body = checkItems
            .map((item) {
              final checked = item['checked'] == true;
              final text = (item['text'] ?? '').toString();
              return '- [${checked ? 'x' : ' '}] $text';
            })
            .join('\n');
      } else {
        body = _blocksToMarkdown(blocks);
      }

      final buffer = StringBuffer();
      final trimmedTitle = title.trim();
      if (trimmedTitle.isNotEmpty) {
        buffer.writeln('# $trimmedTitle');
        buffer.writeln();
      }
      buffer.write(body);

      final tempDir = await getTemporaryDirectory();
      final safeName = trimmedTitle.isEmpty
          ? 'not_${DateTime.now().microsecondsSinceEpoch}'
          : trimmedTitle.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
      final outFile = File(p.join(tempDir.path, '$safeName.md'));
      await outFile.writeAsString(buffer.toString());

      final bytes = await outFile.readAsBytes();
      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Markdown olarak kaydet',
        fileName: '$safeName.md',
        type: FileType.custom,
        allowedExtensions: ['md'],
        bytes: bytes,
      );

      if (mounted && savedPath != null) {
        _showInfoBar(
          'Markdown kaydedildi',
          icon: Icons.check_circle_outline,
          actionLabel: 'Aç',
          onAction: () => OpenFile.open(outFile.path),
        );
      }
    } catch (_) {
      if (mounted) {
        _showInfoBar('Markdown oluşturulamadı', icon: Icons.error_outline);
      }
    }
  }

  void _showTextSizeSlider(int noteIndex) {
    final currentSize =
        (_notes[noteIndex]['fontSize'] as num?)?.toDouble() ?? _globalFontSize;
    double tempSize = currentSize;
    showModalBottomSheet(
      context: context,
      backgroundColor: dNoteCardColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (context, setSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dNoteIsDark(context)
                        ? Colors.grey[700]
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Metin Boyutu',
                  style: TextStyle(
                    color: dNoteTextColor(context),
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
                          activeTrackColor: Colors.amber,
                          inactiveTrackColor: dNoteBorderColor(context),
                          thumbColor: Colors.amber,
                          overlayColor: Colors.amber.withValues(alpha: 0.2),
                          valueIndicatorColor: Colors.amber,
                          valueIndicatorTextStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Slider(
                          value: tempSize,
                          min: 10,
                          max: 30,
                          divisions: 20,
                          label: '${tempSize.round()}',
                          onChanged: (v) => setSheet(() => tempSize = v),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.text_fields, color: Colors.grey, size: 26),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Örnek metin',
                  style: TextStyle(
                    color: dNoteTextColor(context).withValues(alpha: 0.7),
                    fontSize: tempSize,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(sheetCtx),
                        child: const Text(
                          'İptal',
                          style: TextStyle(color: Colors.grey),
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
                          setState(
                            () => _notes[noteIndex]['fontSize'] = tempSize,
                          );
                          _saveData();
                          Navigator.pop(sheetCtx);
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
  }

  // Yeni: kilitleme (not kilitleme / kilitli klasöre girme) için henüz
  // parola belirlenmemişse, alttaki kırmızı uyarı yerine doğrudan burada
  // gösterilen "Yeni Parola Oluştur" ekranıyla kullanıcı parolasını hemen
  // belirleyebilir. true dönerse parola başarıyla oluşturulup kaydedilmiştir
  // (_notePasswordEnabled otomatik olarak açılır).
  Future<bool> _showCreatePasswordDialog() async {
    final passCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    final completer = Completer<bool>();
    String? errorText;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setDlg) => AlertDialog(
          backgroundColor: dNoteCardColor(ctx2),
          title: const Text(
            'Yeni Parola Oluştur',
            style: TextStyle(color: Colors.amber),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kilitleme özelliğini kullanabilmek için önce bir not parolası belirlemeniz gerekiyor.',
                style: TextStyle(color: dNoteTextColor(ctx2), fontSize: 13),
              ),
              const SizedBox(height: 14),
              TextField(
                selectionWidthStyle: ui.BoxWidthStyle.tight,
                contextMenuBuilder: buildCustomContextMenu,
                selectionHeightStyle: ui.BoxHeightStyle.max,
                controller: passCtrl,
                obscureText: true,
                autofocus: true,
                style: TextStyle(color: dNoteTextColor(ctx2)),
                decoration: InputDecoration(
                  hintText: 'Yeni parola',
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: dNoteBorderColor(ctx2)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                selectionWidthStyle: ui.BoxWidthStyle.tight,
                contextMenuBuilder: buildCustomContextMenu,
                selectionHeightStyle: ui.BoxHeightStyle.max,
                controller: confirmCtrl,
                obscureText: true,
                style: TextStyle(color: dNoteTextColor(ctx2)),
                decoration: InputDecoration(
                  hintText: 'Parolayı doğrula',
                  hintStyle: const TextStyle(color: Colors.grey),
                  errorText: errorText,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: dNoteBorderColor(ctx2)),
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
              onPressed: () {
                Navigator.pop(ctx);
                completer.complete(false);
              },
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                final pass = passCtrl.text;
                if (pass.trim().isEmpty) {
                  setDlg(() => errorText = 'Parola boş olamaz');
                  return;
                }
                if (pass != confirmCtrl.text) {
                  setDlg(() => errorText = 'Parolalar eşleşmiyor');
                  return;
                }
                setState(() {
                  _notePasswordEnabled = true;
                  _notePassword = pass;
                });
                _saveData();
                Navigator.pop(ctx);
                completer.complete(true);
              },
              child: const Text(
                'Kaydet',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );

    return completer.future;
  }

  // Yeni: parola doğrulama dialogu (true dönerse doğru parola girildi)
  Future<bool> _checkPasswordPrompt() async {
    if (!_notePasswordEnabled) return false;
    final ctrl = TextEditingController();
    final completer = Completer<bool>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setDlg) => AlertDialog(
          backgroundColor: dNoteCardColor(ctx2),
          title: const Text(
            'Parola Gerekiyor',
            style: TextStyle(color: Colors.amber),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                selectionWidthStyle: ui.BoxWidthStyle.tight,
                contextMenuBuilder: buildCustomContextMenu,
                selectionHeightStyle: ui.BoxHeightStyle.max,
                controller: ctrl,
                obscureText: true,
                style: TextStyle(color: dNoteTextColor(ctx2)),
                decoration: InputDecoration(
                  hintText: 'Parolayı girin',
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: dNoteBorderColor(ctx2)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
              ),
              if (_passwordHintQuestion.isNotEmpty) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () {
                      Navigator.pop(ctx);
                      completer.complete(false);
                      _showForgotPasswordDialog();
                    },
                    child: const Text(
                      'Şifremi unuttum',
                      style: TextStyle(color: Colors.amber, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                completer.complete(false);
              },
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                final ok = ctrl.text == _notePassword;
                Navigator.pop(ctx);
                completer.complete(ok);
              },
              child: const Text(
                'Doğrula',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );

    return completer.future;
  }

  // Yeni: "Şifremi unuttum" akışı — güvenlik sorusu/cevabı ile şifreyi hatırlatır.
  void _showForgotPasswordDialog() {
    final answerCtrl = TextEditingController();
    String? errorText;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setDlg) => AlertDialog(
          backgroundColor: dNoteCardColor(ctx2),
          title: const Text(
            'Güvenlik Sorusu',
            style: TextStyle(color: Colors.amber),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _passwordHintQuestion,
                style: TextStyle(
                  color: dNoteTextColor(ctx2),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                selectionWidthStyle: ui.BoxWidthStyle.tight,
                contextMenuBuilder: buildCustomContextMenu,
                selectionHeightStyle: ui.BoxHeightStyle.max,
                controller: answerCtrl,
                style: TextStyle(color: dNoteTextColor(ctx2)),
                decoration: InputDecoration(
                  hintText: 'Cevabınız',
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: dNoteBorderColor(ctx2)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                  errorText: errorText,
                ),
                onSubmitted: (_) {},
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
                final correct =
                    answerCtrl.text.trim().toLowerCase() ==
                    _passwordHintAnswer.trim().toLowerCase();
                if (correct) {
                  Navigator.pop(ctx);
                  _showRevealedPasswordDialog();
                } else {
                  setDlg(() => errorText = 'Cevap yanlış. Tekrar deneyin.');
                }
              },
              child: const Text(
                'Onayla',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Yeni: güvenlik sorusu doğrulandıktan sonra şifreyi gösterir.
  void _showRevealedPasswordDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dNoteCardColor(ctx),
        title: const Text('Şifreniz', style: TextStyle(color: Colors.amber)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Not şifreniz:',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: dNoteSurfaceVariant(ctx),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                _notePassword,
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Tamam',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Not: notu doğrudan açar. Kilitli notlar zaten "Kilitli" klasöründe ve
  // o klasöre girişte parola soruluyor; notun kendisinde tekrar parola
  // sorup içeriği gizlemeye gerek yok.
  Future<void> _openNoteWithPasswordCheck(int index) async {
    if (index < 0 || index >= _notes.length) return;
    _showNoteDialog(index: index);
  }

  // ── Ayarlar Sayfası ────────────────────────────────────────
  void _openSettings() {
    Navigator.pop(context); // drawer'ı kapat
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => SettingsPage(state: this)));
  }

  // Yeni: "Kilitli" klasörüne girmeden önce parola sorar.
  Future<void> _openLockedFolder() async {
    Navigator.pop(context); // drawer'ı önce kapat

    if (!_notePasswordEnabled) {
      // Parola belirlenmemişse artık alttan kırmızı uyarı göstermek yerine
      // doğrudan "Yeni Parola Oluştur" ekranı açılır. Parola az önce
      // oluşturulduğu için ayrıca tekrar doğrulama istemeye gerek yok;
      // kullanıcı doğrudan kilitli klasöre girer.
      final created = await _showCreatePasswordDialog();
      if (!mounted || !created) return;
      setState(() => _activeCategory = '__locked__');
      _saveData();
      return;
    }

    final ok = await _checkPasswordPrompt();
    if (!mounted) return;
    if (ok) {
      setState(() => _activeCategory = '__locked__');
      _saveData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parola yanlış.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _hideDeletedBar() {
    _snackTimer?.cancel();
    _snackOverlay?.remove();
    _snackOverlay = null;
    _snackTimer = null;
  }

  void _showDeletedBar(Map<String, dynamic> deletedNote) {
    _hideDeletedBar();

    _snackOverlay = OverlayEntry(
      builder: (ctx) => Positioned(
        bottom: 24,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: dNoteCardColor(context),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Not silindi',
                  style: TextStyle(color: dNoteTextColor(context)),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _notes.add(deletedNote);
                      _deletedNotes.removeWhere(
                        (n) => n['id'] == deletedNote['id'],
                      );
                    });
                    _saveData();
                    _hideDeletedBar();
                  },
                  child: const Text(
                    'Geri Getir',
                    style: TextStyle(color: Colors.amber),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_snackOverlay!);
    _snackTimer = Timer(const Duration(seconds: 2), _hideDeletedBar);
  }

  // İlk harfi Türkçe kurallarına göre büyütür (örn. "istanbul" -> "İstanbul",
  // "iş" -> "İş"). Dart'ın standart toUpperCase() metodu Türkçe'deki
  // noktalı/noktasız I ayrımını bilmediğinden ("i" -> "I" yapar, "İ" değil),
  // ilk harf için özel bir eşleme kullanılır.
  String _capitalizeFirstLetterTr(String text) {
    if (text.isEmpty) return text;
    final firstChar = text[0];
    const Map<String, String> trUpperMap = {
      'i': 'İ',
      'ı': 'I',
      'ö': 'Ö',
      'ü': 'Ü',
      'ş': 'Ş',
      'ç': 'Ç',
      'ğ': 'Ğ',
    };
    final upperFirst = trUpperMap[firstChar] ?? firstChar.toUpperCase();
    return upperFirst + text.substring(1);
  }

  void _showAddCategoryDialog({
    void Function(String)? onAdded,
    String? editingCategory,
  }) {
    final isEditing = editingCategory != null;
    final controller = TextEditingController(
      text: isEditing ? editingCategory : '',
    );
    Color selectedColor = isEditing
        ? _getCategoryColor(editingCategory)
        : _categoryPalette[_categories.length % _categoryPalette.length];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: dNoteCardColor(context),
          title: Text(
            isEditing ? 'Kategoriyi Düzenle' : 'Yeni Kategori',
            style: const TextStyle(color: Colors.amber),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                selectionWidthStyle: ui.BoxWidthStyle.tight,
                contextMenuBuilder: buildCustomContextMenu,
                selectionHeightStyle: ui.BoxHeightStyle.max,
                controller: controller,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Kategori adı',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: dNoteBorderColor(context)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                style: TextStyle(color: dNoteTextColor(context)),
              ),
              const SizedBox(height: 18),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Renk',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _categoryPalette.map((color) {
                  final isSelected =
                      selectedColor.toARGB32() == color.toARGB32();
                  return GestureDetector(
                    onTap: () {
                      setDialogState(() {
                        selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 2.5)
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 18,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                final rawName = controller.text.trim();
                final name = _capitalizeFirstLetterTr(rawName);
                final colorHex = selectedColor.toARGB32().toRadixString(16);
                if (name.isEmpty) {
                  Navigator.pop(context);
                  return;
                }

                if (isEditing) {
                  if (name != editingCategory && _categories.contains(name)) {
                    Navigator.pop(context);
                    return;
                  }
                  setState(() {
                    if (name != editingCategory) {
                      final idx = _categories.indexOf(editingCategory);
                      if (idx != -1) _categories[idx] = name;
                      _categoryColors.remove(editingCategory);
                      for (final note in _notes) {
                        if (note['category'] == editingCategory) {
                          note['category'] = name;
                        }
                      }
                      for (final note in _deletedNotes) {
                        if (note['category'] == editingCategory) {
                          note['category'] = name;
                        }
                      }
                      if (_activeCategory == editingCategory) {
                        _activeCategory = name;
                      }
                    }
                    _categoryColors[name] = colorHex;
                  });
                  _saveData();
                } else {
                  if (!_categories.contains(name)) {
                    setState(() {
                      _categories.add(name);
                      _categoryColors[name] = colorHex;
                    });
                    _saveData();
                  }
                  onAdded?.call(name);
                }
                Navigator.pop(context);
              },
              child: Text(
                isEditing ? 'Kaydet' : 'Ekle',
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

  void _showClassifyDialog(int noteIndex, {void Function(String?)? onChanged}) {
    final currentCategory = _notes[noteIndex]['category'] as String?;

    void assignCategory(String? category) {
      setState(() {
        _notes[noteIndex]['category'] = category;
      });
      _saveData();
      onChanged?.call(category);
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: dNoteCardColor(context),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dNoteIsDark(sheetContext)
                        ? Colors.grey[700]
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Sınıflandır',
                style: TextStyle(
                  color: dNoteTextColor(sheetContext),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.add_circle_outline,
                  color: dNoteTextColor(sheetContext),
                ),
                title: Text(
                  'Kategori Ekle',
                  style: TextStyle(
                    color: dNoteTextColor(sheetContext),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showAddCategoryDialog(
                    onAdded: (name) {
                      assignCategory(name);
                    },
                  );
                },
              ),
              if (_categories.isNotEmpty) ...[
                Divider(color: Theme.of(sheetContext).dividerColor, height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 280),
                  child: ListView(
                    shrinkWrap: true,
                    children: _categories.map((cat) {
                      final isSelected = currentCategory == cat;
                      final catColor = _getCategoryColor(cat);
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.folder_outlined,
                          color: isSelected
                              ? catColor
                              : catColor.withValues(alpha: 0.6),
                        ),
                        title: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected
                                ? catColor
                                : dNoteTextColor(sheetContext),
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_circle, color: catColor)
                            : null,
                        onTap: () {
                          Navigator.pop(sheetContext);
                          assignCategory(cat);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
              if (currentCategory != null && currentCategory.isNotEmpty) ...[
                Divider(color: Theme.of(sheetContext).dividerColor, height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.label_off_outlined,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Mevcut Kategoriyi Kaldır',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    assignCategory(null);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Not ayrıntılarını gösteren dialog
  void _showNoteDetails(int noteIndex) {
    if (noteIndex < 0 || noteIndex >= _notes.length) return;
    final note = _notes[noteIndex];

    String formatDetailDate(String? rawDate) {
      if (rawDate == null || rawDate.isEmpty) return 'Bilinmiyor';
      try {
        final dt = DateTime.parse(rawDate);
        final day = dt.day.toString().padLeft(2, '0');
        final month = dt.month.toString().padLeft(2, '0');
        final hour = dt.hour.toString().padLeft(2, '0');
        final minute = dt.minute.toString().padLeft(2, '0');
        return '$day.$month.${dt.year} $hour:$minute';
      } catch (_) {
        return rawDate;
      }
    }

    final content = ContentBlocks.plainText(note['content'] as String?);
    final charCount = content.length;
    final wordCount = content.isEmpty
        ? 0
        : content.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

    final createdStr = formatDetailDate(note['createdDate'] as String?);
    final modifiedStr = formatDetailDate(note['modifiedDate'] as String?);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dNoteCardColor(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.lightBlueAccent, size: 22),
            const SizedBox(width: 10),
            Text(
              'Ayrıntılar',
              style: TextStyle(
                color: dNoteTextColor(ctx),
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow(
                Icons.calendar_today_outlined,
                Colors.amber,
                'Oluşturulma',
                createdStr,
              ),
              const SizedBox(height: 14),
              _detailRow(
                Icons.edit_calendar_outlined,
                Colors.greenAccent,
                'Son Düzenleme',
                modifiedStr,
              ),
              const SizedBox(height: 14),
              _detailRow(
                Icons.abc_outlined,
                Colors.purpleAccent,
                'Karakter Sayısı',
                '$charCount karakter',
              ),
              const SizedBox(height: 14),
              _detailRow(
                Icons.text_fields_outlined,
                Colors.cyanAccent,
                'Kelime Sayısı',
                '$wordCount kelime',
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Tamam',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(
    IconData icon,
    Color iconColor,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  color: dNoteTextColor(context),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Güncellenmiş: not eylemleri (kilitle/kilidi kaldır dahil)
  // Not düzenleyicisindeki sol alttaki "+" butonuna basınca açılan panel;
  // sağ üstteki üç nokta menüsüyle (_showNoteActions) aynı alttan-panel
  // (bottom sheet) görünümünü kullanır.
  void _showAddAttachmentSheet(
    BuildContext ctx, {
    required void Function(String value) onSelected,
  }) {
    final actions = [
      {
        'icon': Icons.image_outlined,
        'label': 'Görsel Ekle',
        'color': Colors.blueAccent,
        'key': 'image',
      },
      {
        'icon': Icons.camera_alt_outlined,
        'label': 'Kamera',
        'color': Colors.tealAccent,
        'key': 'camera',
      },
      {
        'icon': Icons.attach_file,
        'label': 'Dosya Ekle',
        'color': Colors.orange,
        'key': 'file',
      },
      {
        'icon': Icons.mic,
        'label': 'Ses Kaydı',
        'color': Colors.deepPurpleAccent,
        'key': 'record',
      },
      {
        'icon': Icons.videocam_outlined,
        'label': 'Video Çek',
        'color': Colors.redAccent,
        'key': 'video',
      },
      {
        'icon': Icons.document_scanner_outlined,
        'label': 'Belge Tara',
        'color': Colors.lightGreenAccent,
        'key': 'scan',
      },
    ];

    showModalBottomSheet(
      context: ctx,
      backgroundColor: Theme.of(ctx).cardColor,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Ekle',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.95,
                ),
                itemCount: actions.length,
                itemBuilder: (_, i) {
                  final action = actions[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      onSelected(action['key'] as String);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: dNoteSurfaceVariant(ctx),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            action['icon'] as IconData,
                            color: action['color'] as Color,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          action['label'] as String,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNoteActions(
    BuildContext ctx,
    int noteIndex,
    bool isTrash, {
    // Bu üç parametre yalnızca not düzenleyicisinden çağrıldığında verilir.
    // Henüz kaydedilmemiş (yeni) bir not için de "Hatırlatıcı" eylemi
    // gösterilebilsin diye, hatırlatıcı durumu _notes listesinden değil
    // doğrudan düzenleyicinin yerel state'inden okunur/güncellenir.
    DateTime? editorReminder,
    String? editorReminderRepeat,
    void Function(DateTime? reminder, String? repeat)? onReminderChanged,
    // Yalnızca not düzenleyicisinden çağrıldığında verilir: dolu olduğunda
    // menüye "Değişiklikleri Yok Say" eylemi eklenir ve seçildiğinde bu
    // callback tetiklenir (düzenleyici, kaydetmeden kapanır).
    VoidCallback? onDiscard,
    // Yalnızca not düzenleyicisinden çağrıldığında verilir: dolu olduğunda
    // menüye "Sesi Yazıya Çevir" eylemi eklenir; konuşma tanıma sonucu bu
    // callback ile düzenleyicinin imleç konumundaki metin bloğuna eklenir.
    void Function(String text)? onInsertText,
    // Yalnızca not listesinden (uzun basma) çağrıldığında true verilir:
    // panele en sona "Seç" eylemi eklenir ve seçilince çoklu seçim modu
    // açılır. Not düzenleyicisinden çağrıldığında gösterilmez.
    bool showSelectAction = false,
  }) {
    final hasValidNote = noteIndex >= 0 && noteIndex < _notes.length;
    if (!hasValidNote && onReminderChanged == null && onInsertText == null) {
      return;
    }
    final isFavorite = hasValidNote && _notes[noteIndex]['isFavorite'] == true;
    final isArchived = hasValidNote && _notes[noteIndex]['isArchived'] == true;
    final isLocked = hasValidNote && _notes[noteIndex]['isLocked'] == true;
    final isPinnedToNotification =
        hasValidNote && _notes[noteIndex]['isPinnedToNotification'] == true;

    // Düzenleyiciden çağrıldıysa editorReminder kullanılır; not listesinden
    // (uzun basma) çağrıldıysa mevcut hatırlatıcı doğrudan nottan okunur.
    final existingReminderRaw = hasValidNote
        ? _notes[noteIndex]['reminderDate']?.toString()
        : null;
    final effectiveReminder = onReminderChanged != null
        ? editorReminder
        : (existingReminderRaw != null && existingReminderRaw.isNotEmpty
              ? DateTime.tryParse(existingReminderRaw)
              : null);
    final effectiveReminderRepeat = onReminderChanged != null
        ? editorReminderRepeat
        : (hasValidNote ? _notes[noteIndex]['reminderRepeat']?.toString() : null);

    final reminderAction = {
      'icon': effectiveReminder != null
          ? Icons.notifications_active
          : Icons.notifications_none,
      'label': effectiveReminder != null ? 'Hatırlatıcıyı Düzenle' : 'Hatırlatıcı',
      'color': Colors.blue,
      'key': 'reminder',
    };

    final speechToTextAction = {
      'icon': Icons.graphic_eq,
      'label': 'Sesi Yazıya Çevir',
      'color': Colors.deepPurpleAccent,
      'key': 'speech_to_text',
    };

    final actions = [
      if (!hasValidNote && onReminderChanged != null) reminderAction,
      if (!hasValidNote && onInsertText != null) speechToTextAction,
      if (hasValidNote) ...[
      {
        'icon': isFavorite ? Icons.star : Icons.star_outline,
        'label': isFavorite ? 'Favoriden Çıkar' : 'Favori',
        'color': Colors.amber,
        'key': 'favorite',
      },
      {
        'icon': isLocked ? Icons.lock_open : Icons.lock_outline,
        'label': isLocked ? 'Kilidi Kaldır' : 'Kilitle',
        'color': Colors.blueGrey,
        'key': 'lock',
      },
      {
        'icon': isArchived ? Icons.unarchive_outlined : Icons.archive_outlined,
        'label': isArchived ? 'Arşivden Çıkar' : 'Arşiv',
        'color': Colors.teal,
        'key': 'archive',
      },
      {
        'icon': Icons.folder_outlined,
        'label': 'Sınıflandır',
        'color': Colors.purple,
        'key': 'classify',
      },
      {
        'icon': isPinnedToNotification
            ? Icons.push_pin
            : Icons.push_pin_outlined,
        'label': isPinnedToNotification
            ? 'Sabitlemeyi Kaldır'
            : 'Bildirim Paneline Sabitle',
        'color': Colors.indigo,
        'key': 'pin_notification',
      },
      {
        'icon': Icons.delete_outline,
        'label': 'Sil',
        'color': Colors.red,
        'key': 'delete',
      },
      reminderAction,
      if (onInsertText != null) speechToTextAction,
      {
        'icon': Icons.share_outlined,
        'label': 'Paylaş',
        'color': Colors.blue,
        'key': 'share',
      },
      {
        'icon': Icons.copy_all_outlined,
        'label': 'Kopya Oluştur',
        'color': Colors.green,
        'key': 'duplicate',
      },
      {
        'icon': Icons.content_paste,
        'label': 'İçeriği Kopyala',
        'color': Colors.cyan,
        'key': 'copy_text',
      },
      {
        'icon': Icons.volume_up,
        'label': 'Yüksek Sesle Oku',
        'color': Colors.orange,
        'key': 'tts',
      },
      {
        'icon': Icons.text_fields,
        'label': 'Metin Boyutu',
        'color': Colors.pink,
        'key': 'text_size',
      },
      {
        'icon': Icons.info_outline,
        'label': 'Ayrıntılar',
        'color': Colors.lightBlueAccent,
        'key': 'details',
      },
      ],
      if (onDiscard != null)
        {
          'icon': Icons.close,
          'label': 'Değişiklikleri Yok Say',
          'color': Colors.red,
          'key': 'discard',
        },
      if (showSelectAction && hasValidNote)
        {
          'icon': Icons.check_circle_outline,
          'label': 'Seç',
          'color': Colors.amber,
          'key': 'select',
        },
    ];

    showModalBottomSheet(
      context: ctx,
      backgroundColor: Theme.of(context).cardColor,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Eylem Seç',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.95,
                ),
                itemCount: actions.length,
                itemBuilder: (_, i) {
                  final action = actions[i];
                  return GestureDetector(
                    onTap: () async {
                      final key = action['key'] as String;
                      Navigator.pop(ctx);

                      if (key == 'reminder') {
                        if (onReminderChanged == null && !hasValidNote) return;
                        final now = DateTime.now();
                        final initialDate =
                            effectiveReminder ?? now.add(const Duration(hours: 1));
                        if (effectiveReminder != null) {
                          final sheetAction = await showModalBottomSheet<String>(
                            context: context,
                            backgroundColor: dNoteCardColor(context),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder: (sheetCtx) => SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                      Icons.edit_calendar,
                                      color: Colors.blue,
                                    ),
                                    title: const Text('Hatırlatıcıyı değiştir'),
                                    onTap: () =>
                                        Navigator.pop(sheetCtx, 'edit'),
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.notifications_off,
                                      color: Colors.redAccent,
                                    ),
                                    title: const Text('Hatırlatıcıyı kaldır'),
                                    onTap: () =>
                                        Navigator.pop(sheetCtx, 'remove'),
                                  ),
                                ],
                              ),
                            ),
                          );
                          if (sheetAction == 'remove') {
                            if (onReminderChanged != null) {
                              onReminderChanged(null, null);
                            } else {
                              _updateNoteReminder(noteIndex, null, null);
                            }
                            return;
                          } else if (sheetAction != 'edit') {
                            return;
                          }
                        }
                        if (!context.mounted) return;
                        final result = await _showReminderPickerDialog(
                          context: context,
                          initialDateTime: initialDate.isBefore(now)
                              ? now
                              : initialDate,
                          initialRepeat: effectiveReminderRepeat,
                        );
                        if (result == null) return;
                        if (onReminderChanged != null) {
                          onReminderChanged(result.dateTime, result.repeat);
                        } else {
                          _updateNoteReminder(
                            noteIndex,
                            result.dateTime,
                            result.repeat,
                          );
                        }
                        return;
                      }

                      if (key == 'discard') {
                        if (onDiscard == null) return;
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (dialogCtx) => AlertDialog(
                            title: const Text('Değişiklikleri Yok Say'),
                            content: const Text(
                              'Bu nottaki kaydedilmemiş değişiklikler kaybolacak. Yok saymak istediğinize emin misiniz?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(dialogCtx, false),
                                child: const Text('Vazgeç'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(dialogCtx, true),
                                child: const Text(
                                  'Yok Say',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) onDiscard();
                        return;
                      }

                      if (key == 'speech_to_text') {
                        if (onInsertText == null) return;
                        if (!context.mounted) return;
                        final transcript = await showModalBottomSheet<String>(
                          context: context,
                          backgroundColor: dNoteCardColor(context),
                          barrierColor: Colors.black.withValues(alpha: 0.55),
                          isScrollControlled: true,
                          isDismissible: false,
                          clipBehavior: Clip.antiAlias,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          builder: (_) => const _SpeechToTextSheet(),
                        );
                        if (transcript != null && transcript.trim().isNotEmpty) {
                          onInsertText(transcript.trim());
                        }
                        return;
                      }

                      if (noteIndex < 0) return;

                      if (key == 'select') {
                        _enterSelectionMode(_notes[noteIndex]);
                      } else if (key == 'favorite') {
                        setState(() {
                          _notes[noteIndex]['isFavorite'] =
                              !(_notes[noteIndex]['isFavorite'] == true);
                        });
                        _saveData();
                      } else if (key == 'archive') {
                        setState(() {
                          _notes[noteIndex]['isArchived'] =
                              !(_notes[noteIndex]['isArchived'] == true);
                        });
                        _saveData();
                      } else if (key == 'delete') {
                        _deleteNote(noteIndex);
                      } else if (key == 'classify') {
                        _showClassifyDialog(noteIndex);
                      } else if (key == 'duplicate') {
                        await _duplicateNote(noteIndex);
                      } else if (key == 'share') {
                        final note = _notes[noteIndex];
                        final title = (note['title'] ?? '').toString().trim();
                        final content = ContentBlocks.plainText(
                          note['content'] as String?,
                        );
                        final text = [
                          if (title.isNotEmpty) title,
                          if (content.isNotEmpty) content,
                        ].join('\n\n');
                        if (text.isNotEmpty) {
                          await SharePlus.instance.share(
                            ShareParams(text: text),
                          );
                        }
                      } else if (key == 'copy_text') {
                        _copyNoteContent(noteIndex);
                      } else if (key == 'tts') {
                        _showTextToSpeechSheet(context, noteIndex);
                      } else if (key == 'text_size') {
                        _showTextSizeSlider(noteIndex);
                      } else if (key == 'lock') {
                        final currentlyLocked =
                            _notes[noteIndex]['isLocked'] == true;
                        if (currentlyLocked) {
                          setState(() => _notes[noteIndex]['isLocked'] = false);
                          _saveData();
                          _showInfoBar('Kilidi kaldırıldı', icon: Icons.lock_open);
                        } else {
                          if (!_notePasswordEnabled) {
                            // Parola belirlenmemişse artık alttan kırmızı
                            // uyarı göstermek yerine doğrudan "Yeni Parola
                            // Oluştur" ekranı açılır; parola belirlenince
                            // not aynı işlem içinde kilitlenir.
                            final created = await _showCreatePasswordDialog();
                            if (!mounted || !created) return;
                          }
                          setState(() => _notes[noteIndex]['isLocked'] = true);
                          _saveData();
                          _showInfoBar('Not kilitlendi', icon: Icons.lock);
                        }
                      } else if (key == 'details') {
                        _showNoteDetails(noteIndex);
                      } else if (key == 'pin_notification') {
                        final note = _notes[noteIndex];
                        final currentlyPinned =
                            note['isPinnedToNotification'] == true;
                        final noteId = note['id'].toString();
                        if (currentlyPinned) {
                          setState(
                            () => _notes[noteIndex]['isPinnedToNotification'] =
                                false,
                          );
                          _saveData();
                          await ReminderService.instance
                              .unpinFromNotificationPanel(noteId);
                          _showInfoBar(
                            'Sabitleme kaldırıldı',
                            icon: Icons.push_pin_outlined,
                          );
                        } else {
                          final title = (note['title'] ?? '').toString().trim();
                          final content = ContentBlocks.plainText(
                            note['content'] as String?,
                          );
                          if (title.isEmpty && content.isEmpty) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Boş not sabitlenemez.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          setState(
                            () => _notes[noteIndex]['isPinnedToNotification'] =
                                true,
                          );
                          _saveData();
                          await ReminderService.instance.pinToNotificationPanel(
                            noteId: noteId,
                            title: title.isEmpty ? 'Not' : title,
                            body: content,
                          );
                          _showInfoBar(
                            'Bildirim paneline sabitlendi',
                            icon: Icons.push_pin,
                          );
                        }
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: dNoteSurfaceVariant(context),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            action['icon'] as IconData,
                            color: action['color'] as Color,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          action['label'] as String,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // "Eylem Seç" panelinden "Yüksek Sesle Oku" seçilince çağrılır. Notun
  // başlığı ve düz metin içeriği (ContentBlocks.plainText — checklist ve
  // hesap tablosu blokları da okunabilir metne çevrilerek dahil edilir)
  // birleştirilip _TextToSpeechSheet'e verilir.
  void _showTextToSpeechSheet(BuildContext context, int noteIndex) {
    if (noteIndex < 0 || noteIndex >= _notes.length) return;
    final note = _notes[noteIndex];
    final title = (note['title'] ?? '').toString().trim();
    final content = ContentBlocks.plainText(note['content'] as String?);
    if (title.isEmpty && content.isEmpty) {
      _showInfoBar('Okunacak bir içerik yok', icon: Icons.info_outline);
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: dNoteCardColor(context),
      barrierColor: Colors.black.withValues(alpha: 0.55),
      isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _TextToSpeechSheet(title: title, content: content),
    );
  }

  bool _saveNoteIfValid(
    int? index,
    String noteType,
    List<Map<String, dynamic>> checkItems, [
    List<Map<String, dynamic>> attachments = const [],
    List<Map<String, dynamic>> blocks = const [],
    DateTime? reminder,
    DateTime? assignedDate,
    String? reminderRepeat,
  ]) {
    final isValid =
        (noteType == 'text'
            ? ContentBlocks.hasAnyContent(blocks)
            : checkItems.any((e) => (e['text'] as String).trim().isNotEmpty)) ||
        attachments.isNotEmpty;

    if (isValid) {
      if (index != null) {
        // Mevcut bir not düzenleniyor: gerçekten bir değişiklik olup
        // olmadığını kontrol et. Değişiklik yoksa (not sadece açılıp
        // kapatıldıysa) modifiedDate güncellenmemeli, yoksa not "son
        // düzenleme" sıralamasında haksız yere başa taşınır.
        final newTitle = _capitalizeFirstLetterTr(_titleController.text.trim());
        final newContent = noteType == 'text'
            ? ContentBlocks.serialize(blocks)
            : '';
        final newCheckItems = noteType == 'checklist'
            ? checkItems
            : <Map<String, dynamic>>[];

        final oldTitle = (_notes[index]['title'] ?? '').toString();
        final oldContent = (_notes[index]['content'] ?? '').toString();
        final oldType = (_notes[index]['type'] ?? 'text').toString();
        final oldCheckItemsRaw = _notes[index]['checkItems'];
        final oldCheckItems = oldCheckItemsRaw is List
            ? List<Map<String, dynamic>>.from(
                oldCheckItemsRaw.map((e) => Map<String, dynamic>.from(e)),
              )
            : <Map<String, dynamic>>[];

        final checkItemsChanged =
            newCheckItems.length != oldCheckItems.length ||
            List.generate(newCheckItems.length, (i) {
              final a = newCheckItems[i];
              final b = oldCheckItems[i];
              return a['text'] != b['text'] || a['checked'] != b['checked'];
            }).any((changed) => changed);

        final oldAttachmentsRaw = _notes[index]['attachments'];
        final oldAttachmentIds = oldAttachmentsRaw is List
            ? oldAttachmentsRaw.map((e) => (e as Map)['id']).toList()
            : <dynamic>[];
        final newAttachmentIds = attachments.map((e) => e['id']).toList();
        final attachmentsChanged =
            oldAttachmentIds.length != newAttachmentIds.length ||
            !List.generate(
              newAttachmentIds.length,
              (i) => oldAttachmentIds[i] == newAttachmentIds[i],
            ).every((same) => same);

        final contentChanged = noteType == 'text'
            ? !ContentBlocks.equalsStoredContent(blocks, oldContent)
            : newContent != oldContent;

        final oldReminderRaw = _notes[index]['reminderDate']?.toString();
        final newReminderRaw = reminder?.toIso8601String();
        final oldRepeatRaw = _notes[index]['reminderRepeat']?.toString();
        final newRepeatRaw = reminder != null ? reminderRepeat : null;
        final reminderChanged =
            oldReminderRaw != newReminderRaw || oldRepeatRaw != newRepeatRaw;

        final oldAssignedRaw = _notes[index]['assignedDate']?.toString();
        final newAssignedRaw = assignedDate?.toIso8601String();
        final assignedDateChanged = oldAssignedRaw != newAssignedRaw;

        final hasChanges =
            newTitle != oldTitle ||
            contentChanged ||
            noteType != oldType ||
            checkItemsChanged ||
            attachmentsChanged ||
            reminderChanged ||
            assignedDateChanged;

        if (!hasChanges) return false;

        final currentRawTime = DateTime.now().toString();
        final noteId = (_notes[index]['id'] ?? currentRawTime).toString();
        setState(() {
          _notes[index] = {
            ..._notes[index],
            'title': newTitle,
            'content': newContent,
            'checkItems': newCheckItems,
            'attachments': attachments,
            'modifiedDate': currentRawTime,
            'type': noteType,
            'reminderDate': newReminderRaw,
            'reminderRepeat': newRepeatRaw,
            'assignedDate': newAssignedRaw,
          };
        });
        _saveData();
        if (reminderChanged) {
          if (reminder != null) {
            final preview = ContentBlocks.plainText(newContent);
            ReminderService.instance.schedule(
              noteId: noteId,
              title: newTitle.isEmpty ? 'Hatırlatıcı' : newTitle,
              body: noteType == 'checklist'
                  ? 'Kontrol listeni kontrol etmeyi unutma'
                  : (preview.isEmpty ? 'Notunu kontrol etmeyi unutma' : preview),
              dateTime: reminder,
              repeat: newRepeatRaw,
            );
          } else {
            ReminderService.instance.cancel(noteId);
          }
        }
        return true;
      } else {
        final currentRawTime = DateTime.now().toString();
        final newTitle = _capitalizeFirstLetterTr(_titleController.text.trim());
        final savedRepeat = reminder != null ? reminderRepeat : null;
        setState(() {
          _notes.add({
            'id': currentRawTime,
            'title': newTitle,
            'content': noteType == 'text'
                ? ContentBlocks.serialize(blocks)
                : '',
            'checkItems': noteType == 'checklist' ? checkItems : [],
            'attachments': attachments,
            'date': _getFormattedDate(assignedDate),
            'createdDate': currentRawTime,
            'modifiedDate': currentRawTime,
            'assignedDate': (assignedDate ?? DateTime.now()).toIso8601String(),
            'category':
                (_activeCategory == 'Tümü' ||
                    _activeCategory == '__favorites__' ||
                    _activeCategory == '__locked__' ||
                    _activeCategory == '__archive__' ||
                    _activeCategory == '__trash__' ||
                    _activeCategory == '__reminders__')
                ? null
                : _activeCategory,
            'color': 'Amber',
            'type': noteType,
            'isFavorite': _activeCategory == '__favorites__',
            'isLocked': _activeCategory == '__locked__',
            'isArchived': _activeCategory == '__archive__',
            'reminderDate': reminder?.toIso8601String(),
            'reminderRepeat': savedRepeat,
          });
        });
        _saveData();
        if (reminder != null) {
          final preview = ContentBlocks.plainText(
            noteType == 'text' ? ContentBlocks.serialize(blocks) : '',
          );
          ReminderService.instance.schedule(
            noteId: currentRawTime,
            title: newTitle.isEmpty ? 'Hatırlatıcı' : newTitle,
            body: noteType == 'checklist'
                ? 'Kontrol listeni kontrol etmeyi unutma'
                : (preview.isEmpty ? 'Notunu kontrol etmeyi unutma' : preview),
            dateTime: reminder,
            repeat: savedRepeat,
          );
        }
        return true;
      }
    }
    return false;
  }

  Future<bool> _handleBackPress() async {
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Çıkmak için tekrar geri tuşuna basın',
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF424242),
          ),
        );
      }
      return false;
    }
    SystemNavigator.pop();
    return true;
  }

  // ── Ek (fotoğraf/belge) IZGARASI ────────────────────────────────────────
  // Tek ek varsa tam genişlikte, 2+ ek varsa 2 sütunlu ızgara (grid) olarak
  // gösterilir. Aralarında çok az boşluk bırakılır. Hem not düzenleme
  // ekranındaki metin içi eklerde, hem de kontrol listesi (checklist)
  // eklerinde kullanılır.
  // ── PDF ilk sayfa küçük resmi (thumbnail) ──────────────────────────────
  // Aynı dosya için tekrar tekrar render etmemek için sonuçlar bellekte
  // (uygulama açıkken) önbelleğe alınır.
  static final Map<String, Uint8List> _pdfThumbCache = {};

  Future<Uint8List?> _getPdfThumbnail(String filePath) async {
    if (_pdfThumbCache.containsKey(filePath)) {
      return _pdfThumbCache[filePath];
    }
    PdfDocument? doc;
    PdfPage? page;
    try {
      doc = await PdfDocument.openFile(filePath);
      page = await doc.getPage(1);
      final image = await page.render(
        width: page.width * 1.6,
        height: page.height * 1.6,
        format: PdfPageImageFormat.jpeg,
        backgroundColor: '#FFFFFF',
      );
      if (image != null) {
        _pdfThumbCache[filePath] = image.bytes;
        return image.bytes;
      }
    } catch (_) {
      // PDF açılamadı/bozuk -> yedek (fallback) ikon gösterilecek.
    } finally {
      await page?.close();
      await doc?.close();
    }
    return null;
  }

  // Görsel olmayan eklerin türüne göre önizlemesi: PDF için gerçek ilk
  // sayfa küçük resmi, XLSX/XLS için belirgin yeşil tablo ikonu, diğer
  // dosya türleri için genel amber belge ikonu.
  Widget _buildDocPreview(Map<String, dynamic> att, String filePath) {
    final fileName = (att['fileName'] ?? '').toString();
    final ext = p.extension(fileName).toLowerCase();

    if (ext == '.pdf') {
      return FutureBuilder<Uint8List?>(
        future: _getPdfThumbnail(filePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.memory(snapshot.data!, fit: BoxFit.cover),
                Positioned(
                  left: 4,
                  bottom: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'PDF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return _docFallback(fileName, Icons.picture_as_pdf, Colors.red.shade400);
        },
      );
    }

    if (ext == '.xlsx' || ext == '.xls') {
      return _docFallback(fileName, Icons.table_chart, Colors.green.shade400);
    }

    if (att['isVideo'] == true) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.black87),
          const Center(
            child: Icon(
              Icons.play_circle_fill,
              color: Colors.white,
              size: 34,
            ),
          ),
        ],
      );
    }

    if (att['isAudio'] == true) {
      return _docFallback(
        fileName,
        Icons.mic,
        Colors.deepPurpleAccent,
      );
    }

    return _docFallback(fileName, Icons.insert_drive_file_outlined, Colors.amber);
  }

  Widget _docFallback(String fileName, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(
            fileName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentGrid({
    required List<String> ids,
    required List<Map<String, dynamic>> attachmentsList,
    required void Function(String id) onRemove,
    required void Function(Map<String, dynamic> att) onOpen,
    required String? deletingId,
    required void Function(String? id) onDeletingIdChanged,
  }) {
    final items = ids
        .map(
          (id) => attachmentsList.firstWhere(
            (a) => a['id'] == id,
            orElse: () => <String, dynamic>{},
          ),
        )
        .where((a) => a.isNotEmpty)
        .toList();
    if (items.isEmpty) return const SizedBox.shrink();

    return FutureBuilder<String>(
      future: DBHelper.instance.attachmentsDir().then((d) => d.path),
      builder: (context, snapshot) {
        final dirPath = snapshot.data;
        if (dirPath == null) return const SizedBox.shrink();
        return LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 4.0;
            final singleFull = items.length == 1;
            final itemWidth = singleFull
                ? constraints.maxWidth
                : (constraints.maxWidth - spacing) / 2;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: items.map((att) {
                final isImage = att['isImage'] == true;
                final filePath = p.join(dirPath, att['storedName'].toString());
                final preview = isImage
                    ? Image.file(
                        File(filePath),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey,
                        ),
                      )
                    : _buildDocPreview(att, filePath);
                return _AttachmentTile(
                  width: itemWidth,
                  height: singleFull ? 220 : itemWidth,
                  preview: preview,
                  showDelete: deletingId == att['id'].toString(),
                  onOpen: () => onOpen(att),
                  onRemove: () => onRemove(att['id'].toString()),
                  onLongPress: () => onDeletingIdChanged(att['id'].toString()),
                  onDismissDelete: () => onDeletingIdChanged(null),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  // Uygulama genelinde tek tip görünen takvim popup'ı (buton yazıları ve
  // başlık her yerde aynı olsun diye ortaklaştırıldı). Yalnızca seçilebilir
  // tarih aralığı (firstDate/lastDate) ve başlık (helpText) çağıran yere
  // göre değişir; alarm için "bugünden sonrası", not atama için "her tarih"
  // gibi farklı kısıtlar dışarıdan verilir.
  Future<DateTime?> _pickCalendarDate({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required String helpText,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: helpText,
      cancelText: 'Vazgeç',
      confirmText: 'Seç',
    );
  }

  // Hatırlatıcı ekleme/düzenleme dialogu. Sistemin "Hatırlatıcı ekle"
  // penceresiyle aynı düzeni kullanır: üstte tarih satırı (dokununca
  // Bugün / Yarın / Tarih seç açılır menüsü), altında saat satırı
  // (dokununca doğrudan saat seçici açılır), en altta tekrar satırı
  // (Tekrar yok / Her saat / Her gün / Her hafta / Her ay / Her yıl).
  // Tüm seçimler tek bir dialog içinde yapılır, İPTAL/KAYDET ile kapanır.
  // Not düzenleyicisinde hatırlatıcı ikonu/tarihine dokununca açılan panel;
  // mevcut hatırlatıcıyı düzenleme veya kaldırma seçeneği sunar.
  Future<void> _handleReminderRowTap({
    required BuildContext context,
    required DateTime? currentReminder,
    required String? currentRepeat,
    required void Function(DateTime? reminder, String? repeat) onChanged,
  }) async {
    final now = DateTime.now();
    final initialDate = currentReminder ?? now.add(const Duration(hours: 1));

    if (currentReminder != null) {
      final sheetAction = await showModalBottomSheet<String>(
        context: context,
        backgroundColor: dNoteCardColor(context),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (sheetCtx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_calendar, color: Colors.blue),
                title: const Text('Hatırlatıcıyı değiştir'),
                onTap: () => Navigator.pop(sheetCtx, 'edit'),
              ),
              ListTile(
                leading: const Icon(
                  Icons.notifications_off,
                  color: Colors.redAccent,
                ),
                title: const Text('Hatırlatıcıyı kaldır'),
                onTap: () => Navigator.pop(sheetCtx, 'remove'),
              ),
            ],
          ),
        ),
      );
      if (sheetAction == 'remove') {
        onChanged(null, null);
        return;
      } else if (sheetAction != 'edit') {
        return;
      }
    }

    if (!context.mounted) return;
    final result = await _showReminderPickerDialog(
      context: context,
      initialDateTime: initialDate.isBefore(now) ? now : initialDate,
      initialRepeat: currentRepeat,
    );
    if (result == null) return;
    onChanged(result.dateTime, result.repeat);
  }

  Future<_ReminderPickResult?> _showReminderPickerDialog({
    required BuildContext context,
    required DateTime initialDateTime,
    String? initialRepeat,
  }) {
    DateTime selectedDate = DateTime(
      initialDateTime.year,
      initialDateTime.month,
      initialDateTime.day,
    );
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(initialDateTime);
    String? selectedRepeat = initialRepeat;

    return showDialog<_ReminderPickResult>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDlgState) {
            final subtleColor = dNoteTextColor(context).withValues(alpha: 0.65);
            final dividerColor = dNoteTextColor(context).withValues(alpha: 0.12);

            Widget dropdownRow({
              required IconData icon,
              required String label,
              required List<PopupMenuEntry<String>> items,
              required void Function(String value) onSelected,
            }) {
              return PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                position: PopupMenuPosition.under,
                color: dNoteCardColor(context),
                onSelected: onSelected,
                itemBuilder: (_) => items,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      Icon(icon, size: 22, color: subtleColor),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 16,
                            color: dNoteTextColor(context),
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: subtleColor),
                    ],
                  ),
                ),
              );
            }

            return Dialog(
              backgroundColor: dNoteCardColor(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hatırlatıcı ekle',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: dNoteTextColor(context),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Tarih satırı: Bugün / Yarın / Tarih seç.
                    dropdownRow(
                      icon: Icons.calendar_today_outlined,
                      label: _reminderDateLabelTr(selectedDate),
                      items: const [
                        PopupMenuItem(value: 'today', child: Text('Bugün')),
                        PopupMenuItem(value: 'tomorrow', child: Text('Yarın')),
                        PopupMenuItem(value: 'pick', child: Text('Tarih seç')),
                      ],
                      onSelected: (value) async {
                        final now = DateTime.now();
                        final today = DateTime(now.year, now.month, now.day);
                        if (value == 'today') {
                          setDlgState(() => selectedDate = today);
                        } else if (value == 'tomorrow') {
                          setDlgState(
                            () => selectedDate =
                                today.add(const Duration(days: 1)),
                          );
                        } else if (value == 'pick') {
                          final picked = await _pickCalendarDate(
                            context: context,
                            initialDate: selectedDate.isBefore(today)
                                ? today
                                : selectedDate,
                            firstDate: today,
                            lastDate: now.add(const Duration(days: 3650)),
                            helpText: 'Hatırlatma tarihi seç',
                          );
                          if (picked != null) {
                            setDlgState(
                              () => selectedDate = DateTime(
                                picked.year,
                                picked.month,
                                picked.day,
                              ),
                            );
                          }
                        }
                      },
                    ),
                    Divider(height: 1, color: dividerColor),
                    // Saat satırı: dokununca doğrudan saat seçici açılır.
                    InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null) {
                          setDlgState(() => selectedTime = picked);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 22,
                              color: subtleColor,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                selectedTime.format(context),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: dNoteTextColor(context),
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: subtleColor),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 1, color: dividerColor),
                    // Tekrar satırı: Tekrar yok / Her saat / Her gün /
                    // Her hafta / Her ay / Her yıl.
                    dropdownRow(
                      icon: Icons.repeat,
                      label: _reminderRepeatLabelTr(selectedRepeat),
                      items: const [
                        PopupMenuItem(
                          value: 'none',
                          child: Text('Tekrar yok'),
                        ),
                        PopupMenuItem(
                          value: 'hourly',
                          child: Text('Her saat'),
                        ),
                        PopupMenuItem(value: 'daily', child: Text('Her gün')),
                        PopupMenuItem(
                          value: 'weekly',
                          child: Text('Her hafta'),
                        ),
                        PopupMenuItem(value: 'monthly', child: Text('Her ay')),
                        PopupMenuItem(value: 'yearly', child: Text('Her yıl')),
                      ],
                      onSelected: (value) {
                        setDlgState(
                          () => selectedRepeat = value == 'none'
                              ? null
                              : value,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('İPTAL'),
                        ),
                        TextButton(
                          onPressed: () {
                            final combined = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                            if (selectedRepeat == null &&
                                combined.isBefore(DateTime.now())) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Geçmiş bir zaman seçilemez',
                                  ),
                                ),
                              );
                              return;
                            }
                            Navigator.pop(
                              dialogContext,
                              _ReminderPickResult(combined, selectedRepeat),
                            );
                          },
                          child: const Text(
                            'KAYDET',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showNoteDialog({
    int? index,
    String type = 'text',
    // Başka bir uygulamadan paylaşılan link/metin buraya gelir; yalnızca
    // yeni not oluştururken (index == null) kullanılır.
    String? initialText,
  }) {
    String noteDate = "";
    String noteType = type;
    // Not: TextField'ın onChanged'i tetiklendiğinde Flutter, controller'ın
    // .text değerini YENİ karakterle ÇOKTAN güncellemiş olur. Yani
    // captureSnapshot() doğrudan _titleController.text okursa, checkpoint
    // "değişiklikten önceki" değil "değişiklikten sonraki" başlığı saklar —
    // undo bu yüzden başlıkta hiçbir şeyi geri almıyordu (buton etkin olsa
    // bile). blocks/checkItems'daki metin alanları bu soruna düşmüyor çünkü
    // oradaki 'text' değeri controller'dan bağımsız ayrı bir alan ve
    // pushUndoCheckpoint çağrısından SONRA güncelleniyor. Başlık için de
    // aynı deseni uygulamak üzere ayrı bir model değişkeni tutuyoruz.
    String titleModel = "";
    List<Map<String, dynamic>> checkItems = [];
    List<TextEditingController> checkControllers = [];
    List<FocusNode> checkFocusNodes = [];
    List<Map<String, dynamic>> attachments = [];
    int? newlyAddedIndex; // hangi maddeye autofocus verilecek
    String? noteCategory;
    // Basılı tutulunca sil ikonu gösterilen ekin id'si (aynı anda tek ek).
    String? deletingAttachmentId;
    // Hatırlatıcı: notun bildirim ile hatırlatılacağı tarih/saat (yoksa null).
    DateTime? noteReminder;
    // Hatırlatıcının tekrar sıklığı: null (tek seferlik), 'hourly' (her
    // saat), 'daily' (her gün), 'weekly' (her hafta aynı gün/saat),
    // 'monthly' (her ay aynı gün/saat), 'yearly' (her yıl aynı ay/gün/saat).
    String? noteReminderRepeat;
    // Notun takvimde hangi güne ait sayılacağı (kullanıcı isterse takvimden
    // farklı bir gün seçebilir; seçmezse oluşturulma/mevcut tarih kullanılır).
    DateTime noteAssignedDate = DateTime.now();

    // ── İçerik blokları (metin + araya eklenen fotoğraf/belge grupları) ──
    List<Map<String, dynamic>> blocks = [];
    List<TextEditingController?> blockControllers = [];
    List<FocusNode?> blockFocusNodes = [];
    int focusedBlockIndex = 0;
    // 'checklist' tipindeki bloklar için: her blok indeksine karşılık gelen
    // madde controller/focus node listesi (metin bloklarında null).
    List<List<TextEditingController>?> blockItemControllers = [];
    List<List<FocusNode>?> blockItemFocusNodes = [];
    // 'calc_table' tipindeki bloklar için: her blok indeksine karşılık gelen
    // satır (etiket/tutar) controller ve focus node listeleri.
    List<List<TextEditingController>?> blockTableLabelControllers = [];
    List<List<TextEditingController>?> blockTableValueControllers = [];
    List<List<FocusNode>?> blockTableLabelFocusNodes = [];

    // Blok listesi değiştiğinde (ekleme/silme/birleştirme) controller ve
    // focus node'ları tamamen yeniden kurar. Metin bloğu olmayan (ek)
    // konumlar için null tutulur.
    void rebuildBlockControllers() {
      // Beyaz ekran sorunu (bkz. çarpıya basınca madde/satır silme kodundaki
      // aynı isimli not): eski controller/focus node'lardan biri o an hâlâ
      // odaklıysa (kullanıcı klavyeyle o alana yazıyorsa), onu odaktan
      // çıkarmadan hemen dispose etmek Flutter'ın bir sonraki frame'de
      // dispose edilmiş bir FocusNode'a erişmeye çalışmasına ve ekranın
      // bembeyaz kalmasına yol açabiliyordu. Bu fonksiyon eskiden bloklar
      // her değiştiğinde (ek eklerken, blok birleştirirken, vb.) bu hataya
      // düşüyordu. Çözüm: önce tüm eski odaklı node'ları odaktan çıkar,
      // dispose işlemini bir sonraki frame'e ertele.
      final oldControllers = <TextEditingController>[
        ...blockControllers.whereType<TextEditingController>(),
        for (final list in blockItemControllers)
          if (list != null) ...list,
        for (final list in blockTableLabelControllers)
          if (list != null) ...list,
        for (final list in blockTableValueControllers)
          if (list != null) ...list,
      ];
      final oldFocusNodes = <FocusNode>[
        ...blockFocusNodes.whereType<FocusNode>(),
        for (final list in blockItemFocusNodes)
          if (list != null) ...list,
        for (final list in blockTableLabelFocusNodes)
          if (list != null) ...list,
      ];
      for (final f in oldFocusNodes) {
        if (f.hasFocus) f.unfocus();
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (final c in oldControllers) {
          c.dispose();
        }
        for (final f in oldFocusNodes) {
          f.dispose();
        }
      });
      blockControllers = [];
      blockFocusNodes = [];
      blockItemControllers = [];
      blockItemFocusNodes = [];
      blockTableLabelControllers = [];
      blockTableValueControllers = [];
      blockTableLabelFocusNodes = [];
      for (int i = 0; i < blocks.length; i++) {
        if (blocks[i]['type'] == 'text') {
          final ctrl = TextEditingController(
            text: (blocks[i]['text'] ?? '').toString(),
          );
          final fn = FocusNode();
          final capturedIndex = i;
          fn.addListener(() {
            if (fn.hasFocus) focusedBlockIndex = capturedIndex;
          });
          blockControllers.add(ctrl);
          blockFocusNodes.add(fn);
          blockItemControllers.add(null);
          blockItemFocusNodes.add(null);
          blockTableLabelControllers.add(null);
          blockTableValueControllers.add(null);
          blockTableLabelFocusNodes.add(null);
        } else if (blocks[i]['type'] == 'checklist') {
          final items = List<Map<String, dynamic>>.from(
            blocks[i]['items'] ?? const [],
          );
          blockItemControllers.add(
            items
                .map(
                  (it) => TextEditingController(
                    text: (it['text'] ?? '').toString(),
                  ),
                )
                .toList(),
          );
          blockItemFocusNodes.add(items.map((_) => FocusNode()).toList());
          blockControllers.add(null);
          blockFocusNodes.add(null);
          blockTableLabelControllers.add(null);
          blockTableValueControllers.add(null);
          blockTableLabelFocusNodes.add(null);
        } else if (blocks[i]['type'] == 'calc_table') {
          final rows = List<Map<String, dynamic>>.from(
            blocks[i]['rows'] ?? const [],
          );
          blockTableLabelControllers.add(
            rows
                .map(
                  (r) => TextEditingController(
                    text: (r['label'] ?? '').toString(),
                  ),
                )
                .toList(),
          );
          blockTableValueControllers.add(
            rows
                .map(
                  (r) => TextEditingController(
                    text: (r['value'] ?? '').toString(),
                  ),
                )
                .toList(),
          );
          blockTableLabelFocusNodes.add(rows.map((_) => FocusNode()).toList());
          blockControllers.add(null);
          blockFocusNodes.add(null);
          blockItemControllers.add(null);
          blockItemFocusNodes.add(null);
        } else {
          blockControllers.add(null);
          blockFocusNodes.add(null);
          blockItemControllers.add(null);
          blockItemFocusNodes.add(null);
          blockTableLabelControllers.add(null);
          blockTableValueControllers.add(null);
          blockTableLabelFocusNodes.add(null);
        }
      }
    }

    void syncControllersAndFocusNodes() {
      // Not: Bu fonksiyon sadece checkItems ile aynı uzunlukta yeni bir
      // controller/focus node seti kurar; var olanları KORUMAZ. Eski sürüm
      // sadece uzunluğu eşitliyor, mevcut controller'ların metnini
      // GÜNCELLEMİYORDU — bu yüzden checklist not tipinde bir maddeyi
      // düzenleyip "Geri Al"a basınca sayı değişmediği için hiçbir şey
      // olmuyor, madde eski metnine dönmüyordu (undo çalışmıyormuş gibi
      // görünüyordu). Ayrıca fazlalık node'ları listenin SONUNDAN, odaktan
      // çıkarmadan ve dispose'u ertelemeden anında siliyordu; bu da geri
      // al/ileri al bir maddeyi ortadan kaldırıp listeyi kısaltınca, o an
      // odaklı bir FocusNode dispose edilirse "kullanılan FocusNode dispose
      // edildi" hatasıyla beyaz ekrana yol açabiliyordu (çarpıya basılan
      // maddenin FocusNode'u tam bu şekilde temizleniyordu). Çözüm:
      // rebuildBlockControllers() ile aynı güvenli deseni kullanarak hepsini
      // güncel checkItems'a göre yeniden kur.
      final oldControllers = List<TextEditingController>.from(checkControllers);
      final oldFocusNodes = List<FocusNode>.from(checkFocusNodes);
      for (final f in oldFocusNodes) {
        if (f.hasFocus) f.unfocus();
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (final c in oldControllers) {
          c.dispose();
        }
        for (final f in oldFocusNodes) {
          f.dispose();
        }
      });
      checkControllers = checkItems
          .map((it) => TextEditingController(text: (it['text'] ?? '').toString()))
          .toList();
      checkFocusNodes = checkItems.map((_) => FocusNode()).toList();
    }

    // ── Not düzenleyici için geri al / ileri al (undo/redo) ───────────────
    final editHistory = UndoRedoStack<Map<String, dynamic>>();
    // pushUndoCheckpoint() bu noktada henüz kurulmamış olan StatefulBuilder
    // içindeki setModalState'e doğrudan erişemez (kapsam dışı); bu yüzden
    // builder her çalıştığında bu değişkene atanır ve pushUndoCheckpoint
    // ondan dolaylı olarak rebuild tetikler.
    void Function(VoidCallback)? requestEditorRebuild;
    // Serbest metin girişleri (başlık/blok/madde metni) tuş vuruşu başına
    // değil, kelime sınırlarında (boşluk/noktalama) tek bir checkpoint
    // oluşturur; aksi halde her harf undo geçmişini doldururdu.
    bool pendingTextCheckpoint = false;
    // Açık oturumun hangi alana (başlık, hangi blok/madde/hücre) ait
    // olduğunu tutar. Kullanıcı bir alandan diğerine geçtiğinde (ör.
    // başlıktan gövdeye, ya da bir kontrol listesi maddesinden diğerine)
    // eski oturum "zaman aşımı" beklenmeden hemen kapatılır; aksi halde
    // iki farklı alandaki değişiklikler tek bir "geri al" adımında
    // birleşir ya da ikinci alandaki ilk harf hiç checkpoint açmaz.
    String? pendingTextCheckpointKey;
    Timer? textCheckpointTimer;

    Map<String, dynamic> captureSnapshot() {
      return {
        'title': titleModel,
        'noteType': noteType,
        'blocks': _deepClone(blocks),
        'checkItems': _deepClone(checkItems),
        'attachments': _deepClone(attachments),
        'noteCategory': noteCategory,
        'noteReminder': noteReminder?.toIso8601String(),
        'noteReminderRepeat': noteReminderRepeat,
        'noteAssignedDate': noteAssignedDate.toIso8601String(),
      };
    }

    void applySnapshot(Map<String, dynamic> snap) {
      titleModel = snap['title'] as String? ?? '';
      _titleController.text = titleModel;
      noteType = snap['noteType'] as String? ?? noteType;
      blocks = (_deepClone(snap['blocks']) as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      checkItems = (_deepClone(snap['checkItems']) as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      attachments = (_deepClone(snap['attachments']) as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      noteCategory = snap['noteCategory'] as String?;
      final reminderRaw = snap['noteReminder'] as String?;
      noteReminder = reminderRaw != null
          ? DateTime.tryParse(reminderRaw)
          : null;
      noteReminderRepeat = snap['noteReminderRepeat'] as String?;
      noteAssignedDate =
          DateTime.tryParse(snap['noteAssignedDate'] as String) ??
          DateTime.now();
      rebuildBlockControllers();
      syncControllersAndFocusNodes();
    }

    void pushUndoCheckpoint() {
      editHistory.push(captureSnapshot());
      // Sadece editHistory'yi güncellemek yetmiyor: AppBar'daki "Geri Al"
      // ikonunun rengi/onPressed'i (build anında editHistory.canUndo'ya
      // bakılarak atanıyor) burada bir rebuild tetiklenmezse eskiden kalma
      // (pasif) haliyle kalırdı. Bu yüzden kullanıcı yazı yazdığında undo
      // butonu görünürde tıklamaya tepki vermiyordu. setModalState burada
      // doğrudan görünmez (bu fonksiyon StatefulBuilder'ın builder'ından
      // ÖNCE tanımlı); bunun yerine builder her çalıştığında güncellenen
      // requestEditorRebuild üzerinden dolaylı olarak çağrılır.
      requestEditorRebuild?.call(() {});
    }

    // Bir kelimenin bittiğini varsaydığımız karakterler: boşluk, satır
    // sonu/tab ve temel noktalama işaretleri. Kullanıcı bunlardan birini
    // yazdığında geçerli "geri al" oturumu kapanır; bir sonraki karakterde
    // yeni bir kontrol noktası açılır. Böylece "geri al" tuşu tüm metni
    // değil, son yazılan kelimeyi geri alır.
    bool _isWordBoundaryChar(String ch) {
      return ch == ' ' ||
          ch == '\n' ||
          ch == '\t' ||
          ch == '.' ||
          ch == ',' ||
          ch == '!' ||
          ch == '?' ||
          ch == ';' ||
          ch == ':';
    }

    void noteTextEdited(String sessionKey, TextEditingController controller) {
      // DÜZELTME: Kelime sınırı kontrolü eskiden metnin EN SONUNDAKİ
      // karaktere bakıyordu (newText[newText.length - 1]). Bu, yalnızca
      // imleç metnin sonundayken (satırın sonuna yazarken/silerken) doğru
      // sonuç veriyordu. İmleç metnin ortasındaysa — ör. not içeriği bir
      // "." ile bitiyor ve kullanıcı araya girip bir kelimeyi düzeltiyorsa
      // — kontrol hep o sondaki noktayı buluyor, her tuş vuruşunda "kelime
      // bitti" sanıp oturumu hemen kapatıyordu. Bu da her harfin ayrı bir
      // checkpoint olmasına ve "Geri Al"ın tüm kelime yerine tek harf
      // silmesine yol açıyordu. Artık imlecin O AN bulunduğu yerin hemen
      // solundaki karaktere bakıyoruz; bu, gerçekte yazılan/silinen
      // karakterdir.
      final String text = controller.text;
      int cursor = controller.selection.end;
      if (cursor < 0 || cursor > text.length) cursor = text.length;
      final String? editedChar = cursor > 0 ? text[cursor - 1] : null;

      if (!pendingTextCheckpoint || pendingTextCheckpointKey != sessionKey) {
        // Ya hiç açık oturum yok, ya da kullanıcı başka bir alana geçti:
        // önceki oturumu (varsa) kapatıp bu alan için yeni bir kontrol
        // noktası aç.
        pushUndoCheckpoint();
        pendingTextCheckpoint = true;
        pendingTextCheckpointKey = sessionKey;
      }
      textCheckpointTimer?.cancel();
      if (editedChar != null && _isWordBoundaryChar(editedChar)) {
        // Kelime tamamlandı (boşluk/noktalama yazıldı): oturumu hemen kapat,
        // bir sonraki karakter yeni bir "geri al" kontrol noktası açsın.
        pendingTextCheckpoint = false;
        pendingTextCheckpointKey = null;
        return;
      }
      // Zaman aşımı burada kelime sınırı belirlemek için DEĞİL, yalnızca bir
      // emniyet supabı olarak kullanılıyor: kullanıcı yazmayı gerçekten
      // bırakırsa (örn. alanı terk edip not defterinden çıkarsa) oturum
      // açık kalmasın. Süre kasıtlı olarak uzun tutuluyor; kısa bir yazma
      // molası (düşünme, otomatik düzeltme önerisi vb.) kelimenin ortasında
      // yanlışlıkla yeni bir kontrol noktası açıp o kelimeyi harf harf geri
      // alınabilir hale getirmemeli.
      textCheckpointTimer = Timer(const Duration(milliseconds: 4000), () {
        pendingTextCheckpoint = false;
        pendingTextCheckpointKey = null;
      });
    }

    if (index != null) {
      _titleController.text = _notes[index]['title'] ?? '';
      titleModel = _titleController.text;
      noteDate = _notes[index]['date'] ?? "";
      noteType = _notes[index]['type'] ?? 'text';
      noteCategory = _notes[index]['category'] as String?;
      final rawReminder = _notes[index]['reminderDate'];
      if (rawReminder != null && rawReminder.toString().isNotEmpty) {
        noteReminder = DateTime.tryParse(rawReminder.toString());
        noteReminderRepeat = _notes[index]['reminderRepeat']?.toString();
      }
      final rawAssigned = _notes[index]['assignedDate']?.toString();
      final rawCreated = _notes[index]['createdDate']?.toString();
      noteAssignedDate =
          DateTime.tryParse((rawAssigned != null && rawAssigned.isNotEmpty)
                  ? rawAssigned
                  : (rawCreated ?? '')) ??
              DateTime.now();
      if (noteType == 'checklist') {
        final raw = _notes[index]['checkItems'];
        if (raw != null) {
          checkItems = List<Map<String, dynamic>>.from(
            (raw as List).map((e) => Map<String, dynamic>.from(e)),
          );
        }
      }
      final rawAttachments = _notes[index]['attachments'];
      if (rawAttachments != null) {
        attachments = List<Map<String, dynamic>>.from(
          (rawAttachments as List).map((e) => Map<String, dynamic>.from(e)),
        );
      }
      blocks = ContentBlocks.parse(_notes[index]['content'] as String?);
    } else {
      _titleController.clear();
      titleModel = '';
      blocks = [
        {'type': 'text', 'text': initialText ?? ''},
      ];
      if (noteType == 'checklist') {
        checkItems = [
          {'text': '', 'checked': false},
        ];
        newlyAddedIndex = 0;
      }
    }
    syncControllersAndFocusNodes();
    rebuildBlockControllers();

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          // Bu bayrak, düzenleyici sayfası kapatıldıktan (Navigator.pop)
          // sonra hâlâ devam eden async işlemlerin (dosya/fotoğraf seçme
          // gibi uzun sürebilen işlemler) tamamlandığında artık var olmayan
          // bir setModalState çağırıp çökmesini engeller.
          bool isEditorOpen = true;
          // Sağ üstteki üç nokta menüsündeki "Dışa Aktar" öğesine basılınca
          // açılan alt menüyü, düğmenin tam altında konumlandırabilmek için
          // düğmenin RenderBox'ına erişmeye yarayan sabit anahtar.
          final GlobalKey moreMenuButtonKey = GlobalKey();
          return StatefulBuilder(
            builder: (context, setModalState) {
              requestEditorRebuild = setModalState;
              // Verilen dosya yollarını (path) ekler klasörüne kopyalar,
              // attachments listesine ekler ve (metin notuysa) imlecin
              // bulunduğu yere gömer. pickAttachments / galeri / kamera
              // akışlarının ortak son adımıdır.
              Future<void> addFilesAsAttachments(
                List<Map<String, String>> files,
              ) async {
                if (files.isEmpty) return;
                final dir = await DBHelper.instance.attachmentsDir();
                final newOnes = <Map<String, dynamic>>[];
                for (final f in files) {
                  final srcPath = f['path'];
                  if (srcPath == null || srcPath.isEmpty) continue;
                  final srcFile = File(srcPath);
                  final name = (f['name'] != null && f['name']!.isNotEmpty)
                      ? f['name']!
                      : p.basename(srcPath);
                  final ext = p.extension(name);
                  final uniqueId =
                      '${DateTime.now().microsecondsSinceEpoch}_${newOnes.length}';
                  final storedName = '$uniqueId$ext';
                  int sizeBytes = 0;
                  try {
                    await srcFile.copy(p.join(dir.path, storedName));
                    sizeBytes = await srcFile.length();
                  } catch (_) {
                    continue;
                  }
                  final isImage = const [
                    '.jpg',
                    '.jpeg',
                    '.png',
                    '.gif',
                    '.webp',
                    '.bmp',
                  ].contains(ext.toLowerCase());
                  final isAudio = const [
                    '.m4a',
                    '.aac',
                    '.mp3',
                    '.wav',
                    '.3gp',
                    '.ogg',
                  ].contains(ext.toLowerCase());
                  final isVideo = const [
                    '.mp4',
                    '.mov',
                    '.m4v',
                    '.3gp',
                    '.mkv',
                    '.webm',
                    '.avi',
                  ].contains(ext.toLowerCase());
                  newOnes.add({
                    'id': uniqueId,
                    'fileName': name,
                    'storedName': storedName,
                    'sizeBytes': sizeBytes,
                    'isImage': isImage,
                    'isAudio': isAudio,
                    'isVideo': isVideo,
                  });
                }
                if (newOnes.isNotEmpty) {
                  // Dosyalar kopyalanırken (özellikle galeri/kamera seçimi
                  // uzun sürebildiğinden) kullanıcı düzenleyiciyi kapatmış
                  // olabilir; bu durumda artık geçerli olmayan bir
                  // setModalState çağrısı yapıp çökmeyelim.
                  if (!isEditorOpen) return;
                  final newIds = newOnes
                      .map((e) => e['id'].toString())
                      .toList();
                  pushUndoCheckpoint();
                  setModalState(() {
                    attachments.addAll(newOnes);
                    if (noteType == 'text') {
                      // İmlecin bulunduğu metin bloğunu bul; imleç orada
                      // yoksa son metin bloğuna eklenir.
                      int idx = focusedBlockIndex;
                      if (idx < 0 ||
                          idx >= blocks.length ||
                          blocks[idx]['type'] != 'text') {
                        idx = blocks.lastIndexWhere(
                          (b) => b['type'] == 'text',
                        );
                        if (idx == -1) {
                          blocks.add({'type': 'text', 'text': ''});
                          idx = blocks.length - 1;
                        }
                      }
                      final controller = blockControllers[idx];
                      final text =
                          controller?.text ??
                          (blocks[idx]['text'] ?? '').toString();
                      int offset = controller?.selection.baseOffset ?? -1;
                      if (offset < 0 || offset > text.length) {
                        offset = text.length;
                      }
                      final leftText = text.substring(0, offset);
                      final rightText = text.substring(offset);

                      if (leftText.trim().isEmpty &&
                          idx > 0 &&
                          blocks[idx - 1]['type'] == 'attachments') {
                        // Önceki blok zaten bir ek grubu: yeni ekleri oraya
                        // ekle, bu metin bloğunu (sağ kalan) koru.
                        (blocks[idx - 1]['ids'] as List).addAll(newIds);
                        blocks[idx]['text'] = rightText;
                      } else if (rightText.trim().isEmpty &&
                          idx < blocks.length - 1 &&
                          blocks[idx + 1]['type'] == 'attachments') {
                        // Sonraki blok zaten bir ek grubu: yeni ekleri oraya
                        // ekle, bu metin bloğunu (sol kalan) koru.
                        (blocks[idx + 1]['ids'] as List).addAll(newIds);
                        blocks[idx]['text'] = leftText;
                      } else {
                        blocks[idx]['text'] = leftText;
                        blocks.insert(idx + 1, {
                          'type': 'attachments',
                          'ids': newIds,
                        });
                        blocks.insert(idx + 2, {
                          'type': 'text',
                          'text': rightText,
                        });
                        focusedBlockIndex = idx + 2;
                      }
                      rebuildBlockControllers();
                      // Yeni imleç konumunu (sağ kalan metnin başına) ayarla.
                      final newFocusIdx = focusedBlockIndex.clamp(
                        0,
                        blockControllers.length - 1,
                      );
                      final newCtrl = blockControllers[newFocusIdx];
                      if (newCtrl != null) {
                        newCtrl.selection = TextSelection.collapsed(
                          offset: 0,
                        );
                      }
                    }
                  });
                }
              }

              Future<void> pickAttachments() async {
                final result = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  type: FileType.any,
                );
                if (result == null) return;
                final files = result.files
                    .where((f) => f.path != null)
                    .map((f) => {'path': f.path!, 'name': f.name})
                    .toList();
                await addFilesAsAttachments(files);
              }

              // Telefondaki fotoğraflar arasından (sadece görseller, temel
              // albümler görünümü) birden fazla görsel seçilmesini sağlar.
              Future<void> pickImagesFromGallery() async {
                final picker = ImagePicker();
                final images = await picker.pickMultiImage();
                if (images.isEmpty) return;
                final files = images
                    .map((x) => {'path': x.path, 'name': x.name})
                    .toList();
                await addFilesAsAttachments(files);
              }

              // Telefonun kamerasını açıp çekilen fotoğrafı eklere ekler.
              Future<void> pickImageFromCamera() async {
                final picker = ImagePicker();
                final photo = await picker.pickImage(
                  source: ImageSource.camera,
                );
                if (photo == null) return;
                await addFilesAsAttachments([
                  {'path': photo.path, 'name': photo.name},
                ]);
              }

              // Telefonun kamerasını açıp video çeker; çekilen video diğer
              // ekler gibi ekler klasörüne kopyalanıp nota eklenir.
              Future<void> pickVideoFromCamera() async {
                final status = await Permission.camera.request();
                if (!status.isGranted) {
                  if (context.mounted) {
                    // Kullanıcı izni "bir daha sorma" ile kalıcı olarak
                    // reddetmişse, sistem izin diyaloğu bir daha çıkmaz;
                    // bu durumda mesajı ayrım yaparak uygulama ayarlarına
                    // yönlendiren bir eylem butonu gösteriyoruz.
                    final permanentlyDenied = status.isPermanentlyDenied;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          permanentlyDenied
                              ? 'Kamera izni reddedilmiş. Video çekmek için '
                                  'ayarlardan izin vermen gerekiyor.'
                              : 'Video çekmek için kamera izni gerekiyor.',
                        ),
                        action: permanentlyDenied
                            ? SnackBarAction(
                                label: 'Ayarlar',
                                onPressed: () => openAppSettings(),
                              )
                            : null,
                      ),
                    );
                  }
                  return;
                }
                final picker = ImagePicker();
                final video = await picker.pickVideo(
                  source: ImageSource.camera,
                  maxDuration: const Duration(minutes: 5),
                );
                if (video == null) return;
                await addFilesAsAttachments([
                  {'path': video.path, 'name': video.name},
                ]);
              }

              // "Belge Tara" akışı: kamerayla kenar tespitli belge taraması
              // yapar (cunning_document_scanner), taranan her sayfa üzerinde
              // ML Kit ile metin tanıma (OCR) çalıştırır ve tanınan metni
              // kullanıcının seçimine göre nota ekler. Not türü checklist ise
              // her satır ayrı bir checklist maddesi olur; metin notlarında
              // imlecin bulunduğu yere gömülür (diğer ekleme akışlarıyla aynı
              // desen). Kullanıcı ayrıca taranan görseli ek olarak saklamayı
              // da seçebilir.
              Future<void> scanDocumentToText() async {
                List<String>? scannedPaths;
                try {
                  scannedPaths = await CunningDocumentScanner.getPictures(
                    isGalleryImportAllowed: true,
                  );
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tarama başlatılamadı: $e')),
                    );
                  }
                  return;
                }
                if (scannedPaths == null || scannedPaths.isEmpty) return;
                if (!context.mounted) return;

                // OCR işlemi sürerken kapatılamaz bir yükleniyor göstergesi.
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  ),
                );

                final recognizer = TextRecognizer(
                  script: TextRecognitionScript.latin,
                );
                final pageTexts = <String>[];
                try {
                  for (final path in scannedPaths) {
                    final result = await recognizer.processImage(
                      InputImage.fromFilePath(path),
                    );
                    final pageText = result.text.trim();
                    if (pageText.isNotEmpty) pageTexts.add(pageText);
                  }
                } catch (e) {
                  await recognizer.close();
                  if (context.mounted) {
                    Navigator.of(context, rootNavigator: true).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Metin tanıma başarısız: $e')),
                    );
                  }
                  return;
                }
                await recognizer.close();
                if (context.mounted) {
                  Navigator.of(context, rootNavigator: true).pop();
                }

                final recognizedText = pageTexts.join('\n\n');
                if (recognizedText.trim().isEmpty) {
                  _showInfoBar(
                    'Belgede okunabilir metin bulunamadı',
                    icon: Icons.info_outline,
                  );
                  return;
                }
                if (!context.mounted || !isEditorOpen) return;

                // Kullanıcıya sor: sadece metin mi, metin + taranan görsel mi?
                final choice = await showModalBottomSheet<String>(
                  context: context,
                  backgroundColor: Theme.of(context).cardColor,
                  barrierColor: Colors.black.withValues(alpha: 0.55),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (sheetCtx) => SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey[700],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Taranan belge nasıl eklensin?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.text_snippet_outlined),
                            title: const Text('Sadece metin olarak ekle'),
                            onTap: () => Navigator.pop(sheetCtx, 'text_only'),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.image_outlined),
                            title: const Text(
                              'Metin + taranan görseli ekle',
                            ),
                            onTap: () =>
                                Navigator.pop(sheetCtx, 'text_and_image'),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.close),
                            title: const Text('Vazgeç'),
                            onTap: () => Navigator.pop(sheetCtx, null),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                if (choice == null) return;
                if (!isEditorOpen) return;

                if (noteType == 'checklist') {
                  final lines = recognizedText
                      .split('\n')
                      .map((l) => l.trim())
                      .where((l) => l.isNotEmpty)
                      .toList();
                  if (lines.isEmpty) return;
                  pushUndoCheckpoint();
                  setModalState(() {
                    for (final line in lines) {
                      checkItems.add({'text': line, 'checked': false});
                    }
                  });
                } else {
                  pushUndoCheckpoint();
                  setModalState(() {
                    // İmlecin bulunduğu metin bloğunu bul; imleç orada yoksa
                    // son metin bloğuna, o da yoksa yeni bir metin bloğuna
                    // eklenir (diğer ekleme akışlarındaki aynı desen).
                    int idx = focusedBlockIndex;
                    if (idx < 0 ||
                        idx >= blocks.length ||
                        blocks[idx]['type'] != 'text') {
                      idx = blocks.lastIndexWhere((b) => b['type'] == 'text');
                      if (idx == -1) {
                        blocks.add({'type': 'text', 'text': ''});
                        idx = blocks.length - 1;
                      }
                    }
                    final controller = blockControllers[idx];
                    final current =
                        controller?.text ??
                        (blocks[idx]['text'] ?? '').toString();
                    int offset = controller?.selection.baseOffset ?? -1;
                    if (offset < 0 || offset > current.length) {
                      offset = current.length;
                    }
                    final leftText = current.substring(0, offset);
                    final rightText = current.substring(offset);
                    final needsLeadingNewline =
                        leftText.isNotEmpty && !leftText.endsWith('\n');
                    final insertion =
                        (needsLeadingNewline ? '\n' : '') + recognizedText;
                    final newLeft = leftText + insertion;
                    blocks[idx]['text'] = newLeft + rightText;
                    focusedBlockIndex = idx;
                    rebuildBlockControllers();
                    final newCaretOffset = newLeft.length;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final newIdx = focusedBlockIndex.clamp(
                        0,
                        blockControllers.length - 1,
                      );
                      final newCtrl = blockControllers[newIdx];
                      if (newCtrl != null) {
                        newCtrl.selection = TextSelection.collapsed(
                          offset: newCaretOffset.clamp(0, newCtrl.text.length),
                        );
                      }
                    });
                  });
                }

                if (choice == 'text_and_image') {
                  final files = scannedPaths
                      .map((path) => {'path': path, 'name': p.basename(path)})
                      .toList();
                  await addFilesAsAttachments(files);
                }
              }

              // Mikrofonla ses kaydı alıp notun eklerine ekler. Kayıt
              // sırasında ayrı bir bottom sheet açılır (süre sayacı +
              // durdur/iptal); kayıt bittiğinde dosya, diğer ekler gibi
              // addFilesAsAttachments üzerinden ekler klasörüne kopyalanır.
              Future<void> recordVoiceNote() async {
                final micPermStatus = await Permission.microphone.request();
                if (!micPermStatus.isGranted) {
                  if (context.mounted) {
                    final permanentlyDenied =
                        micPermStatus.isPermanentlyDenied;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          permanentlyDenied
                              ? 'Mikrofon izni reddedilmiş. Ses kaydı için '
                                  'ayarlardan izin vermen gerekiyor.'
                              : 'Ses kaydı için mikrofon izni gerekiyor.',
                        ),
                        action: permanentlyDenied
                            ? SnackBarAction(
                                label: 'Ayarlar',
                                onPressed: () => openAppSettings(),
                              )
                            : null,
                      ),
                    );
                  }
                  return;
                }
                if (!context.mounted) return;
                final recordedPath = await showModalBottomSheet<String?>(
                  context: context,
                  backgroundColor: Theme.of(context).cardColor,
                  barrierColor: Colors.black.withValues(alpha: 0.55),
                  isDismissible: false,
                  enableDrag: false,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder: (_) => const _VoiceRecorderSheet(),
                );
                if (recordedPath == null || recordedPath.isEmpty) return;
                final now = DateTime.now();
                final label =
                    'Ses Kaydı ${now.hour.toString().padLeft(2, '0')}.'
                    '${now.minute.toString().padLeft(2, '0')}.m4a';
                await addFilesAsAttachments([
                  {'path': recordedPath, 'name': label},
                ]);
                // Geçici kayıt dosyası ekler klasörüne kopyalandı; artık
                // orijinaline gerek yok.
                try {
                  await File(recordedPath).delete();
                } catch (_) {}
              }

              // Kontrol listesi (checklist) notlarında, ekler ayrı bir
              // liste halinde altta gösterilir; index'e göre kaldırılır.
              void removeAttachment(int i) {
                final att = attachments[i];
                final storedName = att['storedName']?.toString();
                if (storedName != null) {
                  DBHelper.instance.deleteAttachmentFile(storedName);
                }
                pushUndoCheckpoint();
                setModalState(() {
                  attachments.removeAt(i);
                  deletingAttachmentId = null;
                });
              }

              // Serbest metin notlarında, imlecin bulunduğu yere gömülü
              // eklerden birini kaldırır; ek grubu boşalırsa komşu metin
              // blokları birleştirilir.
              void removeAttachmentById(String id) {
                final gi = attachments.indexWhere((a) => a['id'] == id);
                if (gi != -1) {
                  final storedName = attachments[gi]['storedName']
                      ?.toString();
                  if (storedName != null) {
                    DBHelper.instance.deleteAttachmentFile(storedName);
                  }
                }
                pushUndoCheckpoint();
                setModalState(() {
                  deletingAttachmentId = null;
                  if (gi != -1) attachments.removeAt(gi);
                  for (int i = 0; i < blocks.length; i++) {
                    if (blocks[i]['type'] != 'attachments') continue;
                    final ids = List<String>.from(blocks[i]['ids'] ?? const []);
                    if (!ids.remove(id)) continue;
                    if (ids.isEmpty) {
                      final prevIsText =
                          i > 0 && blocks[i - 1]['type'] == 'text';
                      final nextIsText =
                          i < blocks.length - 1 &&
                          blocks[i + 1]['type'] == 'text';
                      if (prevIsText && nextIsText) {
                        final mergedText =
                            ((blocks[i - 1]['text'] ?? '').toString()) +
                            ((blocks[i + 1]['text'] ?? '').toString());
                        blocks[i - 1]['text'] = mergedText;
                        blocks.removeAt(i + 1);
                        blocks.removeAt(i);
                      } else {
                        blocks.removeAt(i);
                      }
                    } else {
                      blocks[i]['ids'] = ids;
                    }
                    break;
                  }
                  if (blocks.isEmpty) {
                    blocks.add({'type': 'text', 'text': ''});
                  }
                  rebuildBlockControllers();
                });
              }

              // Çizim bloğunun tamamını kaldırır (NoteDrawingBlock'ta uzun
              // basınca çıkan çöp kutusu ikonuyla tetiklenir — ek/fotoğraf
              // kutucuklarındaki "uzun bas -> sil" ile aynı davranış).
              // Ek/hesap tablosu bloklarını kaldırırken kullanılan desenin
              // birebir aynısı: komşu iki taraf da metin bloğuysa
              // birleştirilir, değilse blok sadece çıkarılır; blok listesi
              // tamamen boş kalırsa boş bir metin bloğu eklenir.
              void removeDrawingBlockAt(int i) {
                pushUndoCheckpoint();
                setModalState(() {
                  if (i < 0 || i >= blocks.length) return;
                  final prevIsText =
                      i > 0 && blocks[i - 1]['type'] == 'text';
                  final nextIsText =
                      i < blocks.length - 1 &&
                      blocks[i + 1]['type'] == 'text';
                  if (prevIsText && nextIsText) {
                    final mergedText =
                        ((blocks[i - 1]['text'] ?? '').toString()) +
                        ((blocks[i + 1]['text'] ?? '').toString());
                    blocks[i - 1]['text'] = mergedText;
                    blocks.removeAt(i + 1);
                    blocks.removeAt(i);
                  } else {
                    blocks.removeAt(i);
                  }
                  if (blocks.isEmpty) {
                    blocks.add({'type': 'text', 'text': ''});
                  }
                  rebuildBlockControllers();
                });
              }

              Future<void> openAttachment(Map<String, dynamic> att) async {
                final dir = await DBHelper.instance.attachmentsDir();
                final path = p.join(dir.path, att['storedName'].toString());
                if (att['isImage'] == true) {
                  if (!context.mounted) return;
                  showDialog(
                    context: context,
                    barrierColor: Colors.black.withValues(alpha: 0.9),
                    builder: (dialogCtx) => Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: const EdgeInsets.all(8),
                      child: Stack(
                        children: [
                          InteractiveViewer(
                            child: Image.file(File(path), fit: BoxFit.contain),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(dialogCtx),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (att['isVideo'] == true) {
                  if (!context.mounted) return;
                  showDialog(
                    context: context,
                    barrierColor: Colors.black,
                    builder: (dialogCtx) => _VideoPlayerDialog(path: path),
                  );
                } else if (att['isAudio'] == true) {
                  if (!context.mounted) return;
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Theme.of(context).cardColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder: (_) => _VoicePlayerSheet(
                      path: path,
                      title: (att['fileName'] ?? 'Ses Kaydı').toString(),
                    ),
                  );
                } else {
                  await OpenFile.open(path);
                }
              }

              final catColor = _getCategoryColor(noteCategory);
              final isDark =
                  ThemeData.estimateBrightnessForColor(catColor) ==
                  Brightness.dark;
              SystemChrome.setSystemUIOverlayStyle(
                dNoteSystemBarsStyle(
                  context,
                  statusBarColor: catColor,
                  statusBarIconBrightnessOverride: isDark
                      ? Brightness.light
                      : Brightness.dark,
                ),
              );
              return PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                  if (deletingAttachmentId != null) {
                    setModalState(() => deletingAttachmentId = null);
                    return;
                  }
                  final saved = _saveNoteIfValid(index, noteType, checkItems, attachments, blocks, noteReminder, noteAssignedDate, noteReminderRepeat);
                  SystemChrome.setSystemUIOverlayStyle(
                    dNoteSystemBarsStyle(context),
                  );
                  if (saved) {
                    _showInfoBar('Not kaydedildi', icon: Icons.save);
                  }
                  isEditorOpen = false;
                  // Sayfa kapatılırken hâlâ odaklı bir TextField (ör. hesap
                  // tablosu tutar hücresi) varsa, önce odağı kaldırıp bir
                  // sonraki frame'e kadar bekliyoruz. Aksi halde o alanın
                  // metin seçim araç çubuğu/tanıtıcıları (Overlay girişi)
                  // sayfa Element'leriyle birlikte söküldüğünde hâlâ
                  // bağımlı InheritedWidget referansı taşıyabiliyor ve
                  // "'_dependents.isEmpty': is not true" hatasına yol
                  // açıyordu.
                  FocusManager.instance.primaryFocus?.unfocus();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) Navigator.pop(context);
                  });
                },
                child: Scaffold(
                  backgroundColor: Theme.of(context).cardColor,
                  resizeToAvoidBottomInset: true,
                  appBar: AppBar(
                    backgroundColor: dNoteHeaderColor(context),
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: dNoteEditorAppBarColor(context),
                      ),
                      onPressed: () {
                        if (deletingAttachmentId != null) {
                          setModalState(() => deletingAttachmentId = null);
                          return;
                        }
                        final saved = _saveNoteIfValid(
                          index,
                          noteType,
                          checkItems,
                          attachments,
                          blocks,
                          noteReminder,
                          noteAssignedDate,
                          noteReminderRepeat,
                        );
                        SystemChrome.setSystemUIOverlayStyle(
                          dNoteSystemBarsStyle(context),
                        );
                        if (saved) {
                          _showInfoBar('Not kaydedildi', icon: Icons.save);
                        }
                        isEditorOpen = false;
                        // Bkz. PopScope'taki aynı isimli not: odaklı bir
                        // alan varken hemen pop etmek dependents hatasına
                        // yol açabiliyordu.
                        FocusManager.instance.primaryFocus?.unfocus();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (context.mounted) Navigator.pop(context);
                        });
                      },
                    ),
                    actions: [
                      IconButton(
                        tooltip: 'Geri Al',
                        icon: Icon(
                          Icons.undo,
                          color: editHistory.canUndo
                              ? dNoteEditorAppBarColor(context)
                              : dNoteEditorAppBarColor(
                                  context,
                                ).withValues(alpha: 0.3),
                        ),
                        onPressed: editHistory.canUndo
                            ? () {
                                // Açık bir yazma oturumu varsa kapat: aksi
                                // halde bayrak açık kalır ve undo sonrası
                                // aynı alanda yazılan bir sonraki kelime
                                // için hiç checkpoint açılmaz.
                                pendingTextCheckpoint = false;
                                pendingTextCheckpointKey = null;
                                textCheckpointTimer?.cancel();
                                final restored = editHistory.undo(
                                  captureSnapshot(),
                                );
                                if (restored != null) {
                                  setModalState(
                                    () => applySnapshot(restored),
                                  );
                                }
                              }
                            : null,
                      ),
                      IconButton(
                        tooltip: 'İleri Al',
                        icon: Icon(
                          Icons.redo,
                          color: editHistory.canRedo
                              ? dNoteEditorAppBarColor(context)
                              : dNoteEditorAppBarColor(
                                  context,
                                ).withValues(alpha: 0.3),
                        ),
                        onPressed: editHistory.canRedo
                            ? () {
                                pendingTextCheckpoint = false;
                                pendingTextCheckpointKey = null;
                                textCheckpointTimer?.cancel();
                                final restored = editHistory.redo(
                                  captureSnapshot(),
                                );
                                if (restored != null) {
                                  setModalState(
                                    () => applySnapshot(restored),
                                  );
                                }
                              }
                            : null,
                      ),
                      // Not üzerindeki ek özellikler menüsü: "Kontrol Listesi
                      // Ekle" ve "Hesap Tablosu Ekle"; ileride aynı ikonun
                      // altına yeni seçenekler eklenebilir.
                      PopupMenuButton<String>(
                        key: moreMenuButtonKey,
                        icon: Icon(
                          Icons.more_vert,
                          color: dNoteEditorAppBarColor(context),
                        ),
                        onSelected: (value) {
                          if (value == 'checklist') {
                            if (noteType != 'text') return;
                            pushUndoCheckpoint();
                            setModalState(() {
                              // İmlecin bulunduğu metin bloğunu bul; imleç
                              // orada yoksa son metin bloğuna eklenir.
                              int idx = focusedBlockIndex;
                              if (idx < 0 ||
                                  idx >= blocks.length ||
                                  blocks[idx]['type'] != 'text') {
                                idx = blocks.lastIndexWhere(
                                  (b) => b['type'] == 'text',
                                );
                                if (idx == -1) {
                                  blocks.add({'type': 'text', 'text': ''});
                                  idx = blocks.length - 1;
                                }
                              }
                              final controller = blockControllers[idx];
                              final text =
                                  controller?.text ??
                                  (blocks[idx]['text'] ?? '').toString();
                              int offset =
                                  controller?.selection.baseOffset ?? -1;
                              if (offset < 0 || offset > text.length) {
                                offset = text.length;
                              }
                              final leftText = text.substring(0, offset);
                              final rightText = text.substring(offset);

                              blocks[idx]['text'] = leftText;
                              blocks.insert(idx + 1, {
                                'type': 'checklist',
                                'items': [
                                  {'text': '', 'checked': false},
                                ],
                              });
                              blocks.insert(idx + 2, {
                                'type': 'text',
                                'text': rightText,
                              });

                              rebuildBlockControllers();
                              focusedBlockIndex = idx + 2;
                              final newItemFns = blockItemFocusNodes[idx + 1];
                              if (newItemFns != null &&
                                  newItemFns.isNotEmpty) {
                                Future.microtask(
                                  () => newItemFns.first.requestFocus(),
                                );
                              }
                            });
                          } else if (value == 'calc_table') {
                            if (noteType != 'text') return;
                            pushUndoCheckpoint();
                            setModalState(() {
                              // İmlecin bulunduğu metin bloğunu bul; imleç
                              // orada yoksa son metin bloğuna eklenir.
                              int idx = focusedBlockIndex;
                              if (idx < 0 ||
                                  idx >= blocks.length ||
                                  blocks[idx]['type'] != 'text') {
                                idx = blocks.lastIndexWhere(
                                  (b) => b['type'] == 'text',
                                );
                                if (idx == -1) {
                                  blocks.add({'type': 'text', 'text': ''});
                                  idx = blocks.length - 1;
                                }
                              }
                              final controller = blockControllers[idx];
                              final text =
                                  controller?.text ??
                                  (blocks[idx]['text'] ?? '').toString();
                              int offset =
                                  controller?.selection.baseOffset ?? -1;
                              if (offset < 0 || offset > text.length) {
                                offset = text.length;
                              }
                              final leftText = text.substring(0, offset);
                              final rightText = text.substring(offset);

                              blocks[idx]['text'] = leftText;
                              blocks.insert(idx + 1, {
                                'type': 'calc_table',
                                'rows': [
                                  {'label': '', 'value': ''},
                                  {'label': '', 'value': ''},
                                ],
                              });
                              blocks.insert(idx + 2, {
                                'type': 'text',
                                'text': rightText,
                              });

                              rebuildBlockControllers();
                              focusedBlockIndex = idx + 2;
                              final newLabelFns =
                                  blockTableLabelFocusNodes[idx + 1];
                              if (newLabelFns != null &&
                                  newLabelFns.isNotEmpty) {
                                Future.microtask(
                                  () => newLabelFns.first.requestFocus(),
                                );
                              }
                            });
                          } else if (value == 'drawing') {
                            if (noteType != 'text') return;
                            pushUndoCheckpoint();
                            setModalState(() {
                              // İmlecin bulunduğu metin bloğunu bul; imleç
                              // orada yoksa son metin bloğuna eklenir (bkz.
                              // checklist/calc_table ekleme mantığı).
                              int idx = focusedBlockIndex;
                              if (idx < 0 ||
                                  idx >= blocks.length ||
                                  blocks[idx]['type'] != 'text') {
                                idx = blocks.lastIndexWhere(
                                  (b) => b['type'] == 'text',
                                );
                                if (idx == -1) {
                                  blocks.add({'type': 'text', 'text': ''});
                                  idx = blocks.length - 1;
                                }
                              }
                              final controller = blockControllers[idx];
                              final text =
                                  controller?.text ??
                                  (blocks[idx]['text'] ?? '').toString();
                              int offset =
                                  controller?.selection.baseOffset ?? -1;
                              if (offset < 0 || offset > text.length) {
                                offset = text.length;
                              }
                              final leftText = text.substring(0, offset);
                              final rightText = text.substring(offset);

                              blocks[idx]['text'] = leftText;
                              blocks.insert(idx + 1, {
                                'type': 'drawing',
                                'strokes': [],
                              });
                              blocks.insert(idx + 2, {
                                'type': 'text',
                                'text': rightText,
                              });

                              rebuildBlockControllers();
                              focusedBlockIndex = idx + 2;
                              final newFocusNode = blockFocusNodes[idx + 2];
                              if (newFocusNode != null) {
                                Future.microtask(
                                  () => newFocusNode.requestFocus(),
                                );
                              }
                            });
                          } else if (value == 'export_menu') {
                            // Üstteki menü kapanma animasyonunu tamamlasın
                            // diye alt menüyü bir sonraki mikro görevde
                            // açıyoruz (aynı anda iki menü çakışmasın).
                            Future.microtask(() {
                              // Düzenleyicideki metin boyutuyla birebir
                              // eşleşsin diye aynı hesaplama kullanılıyor:
                              // not kendi fontSize'ını taşıyorsa o, yoksa
                              // Ayarlar > Kişiselleştirme > Metin Boyutu.
                              final effectiveFontSize = index != null
                                  ? ((_notes[index!]['fontSize'] as num?)
                                            ?.toDouble() ??
                                        _globalFontSize)
                                  : _globalFontSize;
                              _showExportSubmenu(
                                context: context,
                                anchorKey: moreMenuButtonKey,
                                title: _titleController.text,
                                noteType: noteType,
                                blocks: blocks,
                                checkItems: checkItems,
                                attachments: attachments,
                                fontSize: effectiveFontSize,
                              );
                            });
                          }
                        },
                        itemBuilder: (_) => [
                          if (noteType == 'text')
                            const PopupMenuItem(
                              value: 'checklist',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.checklist,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Kontrol Listesi Ekle'),
                                ],
                              ),
                            ),
                          if (noteType == 'text')
                            const PopupMenuItem(
                              value: 'calc_table',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calculate,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Hesap Tablosu Ekle'),
                                ],
                              ),
                            ),
                          if (noteType == 'text')
                            const PopupMenuItem(
                              value: 'drawing',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.draw,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Çizim Ekle'),
                                ],
                              ),
                            ),
                          if (noteType == 'text') const PopupMenuDivider(),
                          const PopupMenuItem(
                            value: 'export_menu',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.ios_share,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Expanded(child: Text('Dışa Aktar')),
                                Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (deletingAttachmentId != null) {
                          setModalState(() => deletingAttachmentId = null);
                        }
                      },
                      child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            selectionWidthStyle: ui.BoxWidthStyle.tight,
                            contextMenuBuilder: buildCustomContextMenu,
                            selectionHeightStyle: ui.BoxHeightStyle.max,
                            controller: _titleController,
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (v) {
                              noteTextEdited('title', _titleController);
                              titleModel = v;
                            },
                            decoration: InputDecoration(
                              hintText: 'Başlık',
                              hintStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: dNoteBorderColor(context),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: dNoteBorderColor(context),
                                ),
                              ),
                            ),
                            style: TextStyle(
                              color: dNoteEffectiveTextColor(context, _textColor),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (noteType == 'text')
                            ...(() {
                              // İpucu metni ("Notunuzu buraya yazın...") eskiden
                              // sadece 0. bloğun KENDİ metninin boş olmasına
                              // bakıyordu. Kullanıcı ilk blok olarak boş bir
                              // metin bırakıp asıl yazıyı sonraki bir blokta
                              // (ör. bir ek/checklist/hesap tablosundan sonra
                              // gelen metin bloğunda) yazdığında, notta gerçekte
                              // içerik olduğu halde 0. blok hâlâ boş olduğu için
                              // ipucu ekranda takılı kalıyordu. Artık ipucu,
                              // notun TAMAMINDA (tüm bloklarda) hiç içerik
                              // yoksa gösteriliyor. Diğer bloklardaki onChanged
                              // her tuş vuruşunda setModalState çağırmadığı
                              // için (performans amacıyla), buradaki kontrolü
                              // her tuş vuruşunda GERÇEK ZAMANLI güncellemek
                              // amacıyla mevcut tüm controller'ları birleştirip
                              // AnimatedBuilder ile dinliyoruz — böylece ipucu,
                              // notun herhangi bir yerine yazı yazılır yazılmaz
                              // (tam modal yeniden kurulmasını beklemeden)
                              // kalkıyor.
                              bool noteHasContent() {
                                return blocks.any((b) {
                                  switch (b['type']) {
                                    case 'checklist':
                                      final items =
                                          List<Map<String, dynamic>>.from(
                                            b['items'] ?? const [],
                                          );
                                      return items.any(
                                        (it) =>
                                            (it['text'] ?? '')
                                                .toString()
                                                .isNotEmpty,
                                      );
                                    case 'calc_table':
                                      final rows =
                                          List<Map<String, dynamic>>.from(
                                            b['rows'] ?? const [],
                                          );
                                      return rows.any(
                                        (r) =>
                                            (r['label'] ?? '')
                                                .toString()
                                                .isNotEmpty ||
                                            (r['value'] ?? '')
                                                .toString()
                                                .isNotEmpty,
                                      );
                                    case 'attachments':
                                      final ids = List<String>.from(
                                        b['ids'] ?? const [],
                                      );
                                      return ids.isNotEmpty;
                                    case 'drawing':
                                      final strokes = List.from(
                                        b['strokes'] ?? const [],
                                      );
                                      return strokes.isNotEmpty;
                                    default:
                                      return (b['text'] ?? '')
                                          .toString()
                                          .isNotEmpty;
                                  }
                                });
                              }

                              final List<Listenable> contentListenables = [
                                ...blockControllers.whereType<TextEditingController>(),
                                for (final list in blockItemControllers)
                                  if (list != null) ...list,
                                for (final list in blockTableLabelControllers)
                                  if (list != null) ...list,
                                for (final list in blockTableValueControllers)
                                  if (list != null) ...list,
                              ];
                              final Listenable contentListenable =
                                  Listenable.merge(contentListenables);

                              return List.generate(blocks.length, (i) {
                              final block = blocks[i];
                              if (block['type'] == 'attachments') {
                                final ids = List<String>.from(
                                  block['ids'] ?? const [],
                                );
                                return Padding(
                                  key: ValueKey('blk_att_$i'),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: _buildAttachmentGrid(
                                    ids: ids,
                                    attachmentsList: attachments,
                                    onRemove: removeAttachmentById,
                                    onOpen: openAttachment,
                                    deletingId: deletingAttachmentId,
                                    onDeletingIdChanged: (id) => setModalState(
                                      () => deletingAttachmentId = id,
                                    ),
                                  ),
                                );
                              }
                              if (block['type'] == 'checklist') {
                                final items = List<Map<String, dynamic>>.from(
                                  block['items'] ?? const [],
                                );
                                final itemCtrls =
                                    blockItemControllers[i] ??
                                    <TextEditingController>[];
                                final itemFns =
                                    blockItemFocusNodes[i] ?? <FocusNode>[];
                                return Padding(
                                  key: ValueKey('blk_checklist_$i'),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: ReorderableListView(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    buildDefaultDragHandles: false,
                                    onReorder: (oldIndex, newIndex) {
                                      pushUndoCheckpoint();
                                      setModalState(() {
                                        if (newIndex > oldIndex) newIndex -= 1;
                                        final movedItem = items.removeAt(
                                          oldIndex,
                                        );
                                        items.insert(newIndex, movedItem);
                                        block['items'] = items;
                                        if (oldIndex < itemCtrls.length) {
                                          final movedCtrl = itemCtrls.removeAt(
                                            oldIndex,
                                          );
                                          itemCtrls.insert(newIndex, movedCtrl);
                                        }
                                        if (oldIndex < itemFns.length) {
                                          final movedFn = itemFns.removeAt(
                                            oldIndex,
                                          );
                                          itemFns.insert(newIndex, movedFn);
                                        }
                                      });
                                    },
                                    children: [
                                      for (int j = 0; j < items.length; j++)
                                        Row(
                                          key: ValueKey(items[j]),
                                          children: [
                                            ReorderableDragStartListener(
                                              index: j,
                                              child: const Padding(
                                                padding: EdgeInsets.only(
                                                  right: 4,
                                                ),
                                                child: Icon(
                                                  Icons.drag_indicator,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            Checkbox(
                                              value:
                                                  items[j]['checked']
                                                      as bool? ??
                                                  false,
                                              activeColor: Colors.amber,
                                              onChanged: (val) {
                                                pushUndoCheckpoint();
                                                setModalState(() {
                                                  items[j]['checked'] =
                                                      val ?? false;
                                                  block['items'] = items;
                                                });
                                              },
                                            ),
                                            Expanded(
                                              child: TextField(
                                                selectionWidthStyle:
                                                    ui.BoxWidthStyle.tight,
                                                controller: j < itemCtrls.length
                                                    ? itemCtrls[j]
                                                    : null,
                                                focusNode: j < itemFns.length
                                                    ? itemFns[j]
                                                    : null,
                                                textInputAction:
                                                    TextInputAction.next,
                                                // Enter'a basınca Flutter'ın
                                                // TextInputAction.next için
                                                // uyguladığı VARSAYILAN odak
                                                // değiştirme davranışını devre
                                                // dışı bırakıyoruz; odak
                                                // yönetimini zaten onSubmitted
                                                // içinde biz yapıyoruz. Aksi
                                                // halde klavye önce (yanlış bir
                                                // widget'a odaklanıldığı için)
                                                // kapanıp hemen ardından bizim
                                                // requestFocus() çağrımızla
                                                // tekrar açılıyordu (aşağı
                                                // inip tekrar yukarı çıkma).
                                                onEditingComplete: () {},
                                                textCapitalization:
                                                    TextCapitalization.sentences,
                                                contextMenuBuilder:
                                                    buildCustomContextMenu,
                                                selectionHeightStyle:
                                                    ui.BoxHeightStyle.max,
                                                style: TextStyle(
                                                  color:
                                                      items[j]['checked'] ==
                                                          true
                                                      ? Colors.grey
                                                      : dNoteEffectiveTextColor(
                                                          context,
                                                          _textColor,
                                                        ),
                                                  decoration:
                                                      items[j]['checked'] ==
                                                          true
                                                      ? TextDecoration
                                                            .lineThrough
                                                      : null,
                                                  fontSize: index != null
                                                      ? ((_notes[index!]['fontSize']
                                                                    as num?)
                                                                ?.toDouble() ??
                                                            _globalFontSize)
                                                      : _globalFontSize,
                                                ),
                                                decoration: const InputDecoration(
                                                  hintText: 'Madde...',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                                onChanged: (val) {
                                                  noteTextEdited(
                                                    'blk_checklist_${i}_$j',
                                                    itemCtrls[j],
                                                  );
                                                  items[j]['text'] = val;
                                                  block['items'] = items;
                                                },
                                                onSubmitted: (_) {
                                                  pushUndoCheckpoint();
                                                  setModalState(() {
                                                    final newIndex = j + 1;
                                                    items.insert(newIndex, {
                                                      'text': '',
                                                      'checked': false,
                                                    });
                                                    block['items'] = items;
                                                    itemCtrls.insert(
                                                      newIndex,
                                                      TextEditingController(),
                                                    );
                                                    itemFns.insert(
                                                      newIndex,
                                                      FocusNode(),
                                                    );
                                                  });
                                                  // Not: requestFocus'u
                                                  // Future.microtask yerine
                                                  // addPostFrameCallback ile
                                                  // çağırıyoruz. Microtask, yeni
                                                  // eklenen alanın widget
                                                  // ağacına henüz oturmadığı bir
                                                  // anda çalışabiliyor; bu da
                                                  // klavyenin bir an için
                                                  // odaksız kalıp kapanmasına ve
                                                  // hemen ardından tekrar
                                                  // açılmasına (aşağı inip
                                                  // tekrar yukarı kalkmasına)
                                                  // yol açıyordu.
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback((_) {
                                                    itemFns[j + 1].requestFocus();
                                                  });
                                                },
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.grey,
                                                size: 18,
                                              ),
                                              onPressed: () {
                                                pushUndoCheckpoint();
                                                // Aynı beyaz ekran sorunu:
                                                // odaklı bir FocusNode'u
                                                // önce odaktan çıkarmadan
                                                // dispose etmeyelim.
                                                FocusNode? removedFocusNode;
                                                if (j < itemFns.length) {
                                                  removedFocusNode = itemFns[j];
                                                  if (removedFocusNode
                                                      .hasFocus) {
                                                    removedFocusNode.unfocus();
                                                  }
                                                }
                                                setModalState(() {
                                                  items.removeAt(j);
                                                  block['items'] = items;
                                                  if (j < itemCtrls.length) {
                                                    itemCtrls
                                                        .removeAt(j)
                                                        .dispose();
                                                  }
                                                  if (j < itemFns.length) {
                                                    itemFns.removeAt(j);
                                                  }
                                                });
                                                if (removedFocusNode != null) {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback((_) {
                                                    removedFocusNode!.dispose();
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                );
                              }
                              if (block['type'] == 'calc_table') {
                                final rows = List<Map<String, dynamic>>.from(
                                  block['rows'] ?? const [],
                                );
                                final labelCtrls =
                                    blockTableLabelControllers[i] ??
                                    <TextEditingController>[];
                                final valueCtrls =
                                    blockTableValueControllers[i] ??
                                    <TextEditingController>[];
                                final labelFns =
                                    blockTableLabelFocusNodes[i] ??
                                    <FocusNode>[];
                                final fontSize = index != null
                                    ? ((_notes[index!]['fontSize'] as num?)
                                              ?.toDouble() ??
                                          _globalFontSize)
                                    : _globalFontSize;
                                double total = 0;
                                for (final r in rows) {
                                  total += ContentBlocks.parseCalcValue(
                                    r['value'],
                                  );
                                }
                                return Padding(
                                  key: ValueKey('blk_calctable_$i'),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          for (int j = 0; j < rows.length; j++)
                                            Row(
                                              key: ValueKey(rows[j]),
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                            Expanded(
                                              flex: 3,
                                              child: TextField(
                                                selectionWidthStyle:
                                                    ui.BoxWidthStyle.tight,
                                                controller:
                                                    j < labelCtrls.length
                                                    ? labelCtrls[j]
                                                    : null,
                                                focusNode: j < labelFns.length
                                                    ? labelFns[j]
                                                    : null,
                                                textCapitalization:
                                                    TextCapitalization.sentences,
                                                contextMenuBuilder:
                                                    buildCustomContextMenu,
                                                selectionHeightStyle:
                                                    ui.BoxHeightStyle.max,
                                                style: TextStyle(
                                                  color: dNoteEffectiveTextColor(
                                                    context,
                                                    _textColor,
                                                  ),
                                                  fontSize: fontSize,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Kalem...',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                                onChanged: (val) {
                                                  noteTextEdited(
                                                    'calc_label_${i}_$j',
                                                    labelCtrls[j],
                                                  );
                                                  rows[j]['label'] = val;
                                                  block['rows'] = rows;
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              flex: 2,
                                              child: TextField(
                                                selectionWidthStyle:
                                                    ui.BoxWidthStyle.tight,
                                                controller:
                                                    j < valueCtrls.length
                                                    ? valueCtrls[j]
                                                    : null,
                                                contextMenuBuilder:
                                                    buildCustomContextMenu,
                                                selectionHeightStyle:
                                                    ui.BoxHeightStyle.max,
                                                textAlign: TextAlign.right,
                                                inputFormatters: [
                                                  CalcTableInputFormatter(),
                                                ],
                                                textInputAction:
                                                    TextInputAction.next,
                                                // Bkz. yukarıdaki madde alanı
                                                // için açıklama: Flutter'ın
                                                // TextInputAction.next
                                                // varsayılan odak değiştirme
                                                // davranışı devre dışı
                                                // bırakılıyor, aksi halde
                                                // Enter'a basınca klavye önce
                                                // kapanıp hemen ardından tekrar
                                                // açılıyordu.
                                                onEditingComplete: () {},
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                  decimal: true,
                                                  signed: true,
                                                ),
                                                style: TextStyle(
                                                  color: dNoteEffectiveTextColor(
                                                    context,
                                                    _textColor,
                                                  ),
                                                  fontSize: fontSize,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: '0',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                                onChanged: (val) {
                                                  noteTextEdited(
                                                    'calc_value_${i}_$j',
                                                    valueCtrls[j],
                                                  );
                                                  setModalState(() {
                                                    rows[j]['value'] = val;
                                                    block['rows'] = rows;
                                                  });
                                                },
                                                onSubmitted: (_) {
                                                  pushUndoCheckpoint();
                                                  setModalState(() {
                                                    final newIndex = j + 1;
                                                    rows.insert(newIndex, {
                                                      'label': '',
                                                      'value': '',
                                                    });
                                                    block['rows'] = rows;
                                                    labelCtrls.insert(
                                                      newIndex,
                                                      TextEditingController(),
                                                    );
                                                    valueCtrls.insert(
                                                      newIndex,
                                                      TextEditingController(),
                                                    );
                                                    labelFns.insert(
                                                      newIndex,
                                                      FocusNode(),
                                                    );
                                                  });
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback((_) {
                                                    labelFns[j + 1]
                                                        .requestFocus();
                                                  });
                                                },
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.grey,
                                                size: 18,
                                              ),
                                              onPressed: () {
                                                pushUndoCheckpoint();
                                                FocusNode? removedFocusNode;
                                                if (j < labelFns.length) {
                                                  removedFocusNode = labelFns[j];
                                                  if (removedFocusNode
                                                      .hasFocus) {
                                                    removedFocusNode.unfocus();
                                                  }
                                                }
                                                bool tableRemoved = false;
                                                setModalState(() {
                                                  rows.removeAt(j);
                                                  block['rows'] = rows;
                                                  if (rows.isEmpty) {
                                                    // Son satır da silindi:
                                                    // "Toplam" satırıyla
                                                    // birlikte boş bir tablo
                                                    // ekranda asılı kalmasın
                                                    // diye hesap tablosu
                                                    // bloğunun tamamını
                                                    // kaldırıyoruz. Ek/checklist
                                                    // bloğu silinirken
                                                    // kullanılanla aynı desen:
                                                    // komşu metin blokları
                                                    // varsa birleştir, yoksa
                                                    // sadece bloğu çıkar; blok
                                                    // listesi tamamen boş
                                                    // kalırsa boş bir metin
                                                    // bloğu ekle. Controller/
                                                    // focus node dispose'u
                                                    // rebuildBlockControllers()
                                                    // güvenli şekilde kendisi
                                                    // yapar; burada ayrıca
                                                    // dispose ETMİYORUZ (çift
                                                    // dispose çökmeye yol
                                                    // açar).
                                                    tableRemoved = true;
                                                    final prevIsText =
                                                        i > 0 &&
                                                        blocks[i - 1]['type'] ==
                                                            'text';
                                                    final nextIsText =
                                                        i < blocks.length - 1 &&
                                                        blocks[i + 1]['type'] ==
                                                            'text';
                                                    if (prevIsText &&
                                                        nextIsText) {
                                                      final mergedText =
                                                          ((blocks[i - 1]['text'] ??
                                                                  '')
                                                              .toString()) +
                                                          ((blocks[i + 1]['text'] ??
                                                                  '')
                                                              .toString());
                                                      blocks[i - 1]['text'] =
                                                          mergedText;
                                                      blocks.removeAt(i + 1);
                                                      blocks.removeAt(i);
                                                    } else {
                                                      blocks.removeAt(i);
                                                    }
                                                    if (blocks.isEmpty) {
                                                      blocks.add({
                                                        'type': 'text',
                                                        'text': '',
                                                      });
                                                    }
                                                    rebuildBlockControllers();
                                                  } else {
                                                    if (j < labelCtrls.length) {
                                                      labelCtrls
                                                          .removeAt(j)
                                                          .dispose();
                                                    }
                                                    if (j < valueCtrls.length) {
                                                      valueCtrls
                                                          .removeAt(j)
                                                          .dispose();
                                                    }
                                                    if (j < labelFns.length) {
                                                      labelFns.removeAt(j);
                                                    }
                                                  }
                                                });
                                                if (!tableRemoved &&
                                                    removedFocusNode != null) {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback((_) {
                                                    removedFocusNode!.dispose();
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  Divider(color: dNoteBorderColor(context)),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              'Toplam',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: dNoteEffectiveTextColor(
                                                  context,
                                                  _textColor,
                                                ),
                                                fontSize: fontSize,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              ContentBlocks.formatCalcNumber(
                                                total,
                                              ),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: dNoteEffectiveTextColor(
                                                  context,
                                                  _textColor,
                                                ),
                                                fontSize: fontSize,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 48),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }
                              if (block['type'] == 'drawing') {
                                final strokes =
                                    List<Map<String, dynamic>>.from(
                                  block['strokes'] ?? const [],
                                );
                                return Padding(
                                  key: ValueKey('blk_drawing_$i'),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: NoteDrawingBlock(
                                    strokes: strokes,
                                    borderColor: dNoteBorderColor(context),
                                    onChanged: (newStrokes) {
                                      // Tek tek stroke'lar notun genel
                                      // geri al/ileri al yığınına GİRMEZ
                                      // (bağımsız undo, bkz.
                                      // NoteDrawingBlock); burada sadece
                                      // güncel veriyi blok listesine
                                      // yazıyoruz ki kaydetme sırasında
                                      // (ContentBlocks.serialize) diske
                                      // gitsin.
                                      block['strokes'] = newStrokes;
                                      // "Notunuzu buraya yazın..." ipucu
                                      // metni tüm bloklara bakan
                                      // noteHasContent()'e göre gizleniyor;
                                      // controller'lara dayalı
                                      // contentListenable çizim bloklarını
                                      // dinlemediği için (bkz. yukarıdaki
                                      // AnimatedBuilder), her tamamlanmış
                                      // strok/silgi/temizle sonrası hafif
                                      // bir yeniden çizim tetikliyoruz —
                                      // checklist madde ekleme/kaldırma ile
                                      // aynı granülerlikte (her tuş
                                      // vuruşunda DEĞİL).
                                      requestEditorRebuild?.call(() {});
                                    },
                                    onDelete: () => removeDrawingBlockAt(i),
                                  ),
                                );
                              }
                              Widget buildTextBlockField(bool showHint) {
                                return TextField(
                                  key: ValueKey('blk_text_$i'),
                                  selectionWidthStyle: ui.BoxWidthStyle.tight,
                                  contextMenuBuilder: buildCustomContextMenu,
                                  selectionHeightStyle: ui.BoxHeightStyle.max,
                                  controller: blockControllers[i],
                                  focusNode: blockFocusNodes[i],
                                  autofocus: i == 0 && index == null,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    hintText: showHint
                                        ? 'Notunuzu buraya yazın...'
                                        : null,
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                    color: dNoteEffectiveTextColor(
                                      context,
                                      _textColor,
                                    ),
                                    fontSize: index != null
                                        ? ((_notes[index!]['fontSize'] as num?)
                                                  ?.toDouble() ??
                                              _globalFontSize)
                                        : _globalFontSize,
                                    height: 1.6,
                                  ),
                                  onChanged: (val) {
                                    // NOT: blockControllers, 'checklist'/'calc'
                                    // gibi metin dışı bloklar için null tutar
                                    // (List<TextEditingController?>); ama bu
                                    // dal yalnızca 'text' tipi bloklar için
                                    // çalışıyor ve orada her zaman gerçek bir
                                    // controller oluşturulmuş olur. Bu yüzden
                                    // burada null-olmayan onay (!) güvenlidir.
                                    noteTextEdited(
                                      'block_$i',
                                      blockControllers[i]!,
                                    );
                                    block['text'] = val;
                                    // Kullanıcı satırın sonuna "=" yazdıysa
                                    // (ör. "(2+4)+5*4+2^2-4/2=") ifadeyi
                                    // hesaplayıp sonucu otomatik ekler.
                                    dNoteMaybeAutoCalculate(
                                      blockControllers[i]!,
                                      onTextChanged: (newText) {
                                        block['text'] = newText;
                                      },
                                    );
                                  },
                                  onTap: () => focusedBlockIndex = i,
                                );
                              }

                              if (i == 0) {
                                return AnimatedBuilder(
                                  animation: contentListenable,
                                  builder: (context, _) => buildTextBlockField(
                                    !noteHasContent(),
                                  ),
                                );
                              }
                              return buildTextBlockField(false);
                            });
                          })()
                          else ...[
                            ReorderableListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              buildDefaultDragHandles: false,
                              onReorder: (oldIndex, newIndex) {
                                pushUndoCheckpoint();
                                setModalState(() {
                                  if (newIndex > oldIndex) newIndex -= 1;
                                  final movedItem = checkItems.removeAt(
                                    oldIndex,
                                  );
                                  checkItems.insert(newIndex, movedItem);
                                  final movedCtrl = checkControllers.removeAt(
                                    oldIndex,
                                  );
                                  checkControllers.insert(newIndex, movedCtrl);
                                  final movedFn = checkFocusNodes.removeAt(
                                    oldIndex,
                                  );
                                  checkFocusNodes.insert(newIndex, movedFn);
                                  if (newlyAddedIndex == oldIndex) {
                                    newlyAddedIndex = newIndex;
                                  }
                                });
                              },
                              children: [
                                for (int i = 0; i < checkItems.length; i++)
                                  Row(
                                    key: ValueKey(checkItems[i]),
                                    children: [
                                      ReorderableDragStartListener(
                                        index: i,
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 4),
                                          child: Icon(
                                            Icons.drag_indicator,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      Checkbox(
                                        value:
                                            checkItems[i]['checked']
                                                as bool? ??
                                            false,
                                        activeColor: Colors.amber,
                                        onChanged: (val) {
                                          pushUndoCheckpoint();
                                          setModalState(() {
                                            checkItems[i]['checked'] =
                                                val ?? false;
                                          });
                                        },
                                      ),
                                  Expanded(
                                    child: TextField(
                                      selectionWidthStyle: ui.BoxWidthStyle.tight,
                                      controller: checkControllers[i],
                                      focusNode: checkFocusNodes[i],
                                      autofocus: newlyAddedIndex == i,
                                      textInputAction: TextInputAction.next,
                                      // Bkz. yukarıdaki alanlarla aynı sebep:
                                      // varsayılan "next" odak davranışını
                                      // devre dışı bırakıyoruz.
                                      onEditingComplete: () {},
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      contextMenuBuilder: buildCustomContextMenu,
                                      selectionHeightStyle: ui.BoxHeightStyle.max,
                                      style: TextStyle(
                                        color: dNoteEffectiveTextColor(context, _textColor),
                                        fontSize: index != null
                                            ? ((_notes[index!]['fontSize']
                                                          as num?)
                                                      ?.toDouble() ??
                                                  _globalFontSize)
                                            : _globalFontSize,
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: 'Madde...',
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (val) {
                                        noteTextEdited('checkitem_$i', checkControllers[i]);
                                        checkItems[i]['text'] = val;
                                      },
                                      onSubmitted: (_) {
                                        pushUndoCheckpoint();
                                        setModalState(() {
                                          final newIndex = i + 1;
                                          checkItems.insert(newIndex, {
                                            'text': '',
                                            'checked': false,
                                          });
                                          checkControllers.insert(
                                            newIndex,
                                            TextEditingController(),
                                          );
                                          checkFocusNodes.insert(
                                            newIndex,
                                            FocusNode(),
                                          );
                                          newlyAddedIndex = newIndex;
                                        });
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          checkFocusNodes[i + 1].requestFocus();
                                        });
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      pushUndoCheckpoint();
                                      // Silinecek madde o an odaklıysa (klavye
                                      // ona yazıyorsa), FocusNode'u odaktan
                                      // çıkarmadan hemen dispose etmek Flutter'ın
                                      // bir sonraki frame'de o node'a erişmeye
                                      // çalışmasına ve "kullanılan FocusNode
                                      // dispose edildi" hatasıyla ekranın
                                      // bembeyaz kalmasına yol açabiliyordu.
                                      // Önce odaktan çıkar, dispose'u da bir
                                      // sonraki frame'e ertele.
                                      final removedFocusNode = checkFocusNodes[i];
                                      if (removedFocusNode.hasFocus) {
                                        removedFocusNode.unfocus();
                                      }
                                      setModalState(() {
                                        checkItems.removeAt(i);
                                        checkControllers.removeAt(i).dispose();
                                        checkFocusNodes.removeAt(i);
                                        newlyAddedIndex = null;
                                      });
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        removedFocusNode.dispose();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ],
                          if (noteType != 'text' && attachments.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            FutureBuilder<String>(
                              future: DBHelper.instance.attachmentsDir().then(
                                (d) => d.path,
                              ),
                              builder: (context, snapshot) {
                                final dirPath = snapshot.data;
                                if (dirPath == null) {
                                  return const SizedBox.shrink();
                                }
                                return Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: List.generate(attachments.length, (
                                    i,
                                  ) {
                                    final att = attachments[i];
                                    final isImage = att['isImage'] == true;
                                    final filePath = p.join(
                                      dirPath,
                                      att['storedName'].toString(),
                                    );
                                    final preview = isImage
                                        ? Image.file(
                                            File(filePath),
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(
                                                  Icons.broken_image_outlined,
                                                  color: Colors.grey,
                                                ),
                                          )
                                        : _buildDocPreview(att, filePath);
                                    return _AttachmentTile(
                                      width: isImage ? 84 : 130,
                                      height: 84,
                                      preview: preview,
                                      showDelete:
                                          deletingAttachmentId ==
                                          att['id'].toString(),
                                      onOpen: () => openAttachment(att),
                                      onRemove: () => removeAttachment(i),
                                      onLongPress: () => setModalState(
                                        () => deletingAttachmentId =
                                            att['id'].toString(),
                                      ),
                                      onDismissDelete: () => setModalState(
                                        () => deletingAttachmentId = null,
                                      ),
                                    );
                                  }),
                                );
                              },
                            ),
                          ],
                          const SizedBox(height: 20),
                          Builder(
                            builder: (context) {
                              final hasReminder = noteReminder != null;
                              final hasCategory =
                                  noteCategory != null &&
                                  noteCategory!.isNotEmpty;
                              if (!hasReminder && !hasCategory) {
                                return const SizedBox.shrink();
                              }
                              // Alarm yazısı ve kategori etiketi aynı renk,
                              // boyut ve stili paylaşır; yan yana dururlar
                              // (önce alarm, sonra etiket). Renk: koyu temada
                              // beyaz, açık temada koyu (temanın etkin metin
                              // rengi). İtalik değil.
                              final tagTextStyle = TextStyle(
                                color: dNoteEffectiveTextColor(context, _textColor),
                                fontWeight: FontWeight.normal,
                                fontSize: index != null
                                    ? ((_notes[index!]['fontSize'] as num?)
                                              ?.toDouble() ??
                                          _globalFontSize)
                                    : _globalFontSize,
                              );
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Wrap(
                                  spacing: 12,
                                  runSpacing: 8,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    if (hasReminder)
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () => _handleReminderRowTap(
                                          context: context,
                                          currentReminder: noteReminder,
                                          currentRepeat: noteReminderRepeat,
                                          onChanged: (reminder, repeat) {
                                            pushUndoCheckpoint();
                                            setModalState(() {
                                              noteReminder = reminder;
                                              noteReminderRepeat = repeat;
                                            });
                                          },
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: dNoteBorderColor(context),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                noteReminderRepeat == null
                                                    ? Icons.access_time
                                                    : Icons.repeat,
                                                size: 16,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 6),
                                              Flexible(
                                                child: Text(
                                                  noteReminderRepeat == null
                                                      ? _formatDateTimeShortTr(
                                                          noteReminder!,
                                                        )
                                                      : '${_formatDateTimeShortTr(noteReminder!)} · ${_reminderRepeatLabelTr(noteReminderRepeat)}',
                                                  style: tagTextStyle,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (hasCategory)
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              dNoteEffectiveTextColor(
                                            context,
                                            _textColor,
                                          ),
                                          side: BorderSide(
                                            color: dNoteBorderColor(context),
                                            width: 1,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.folder_outlined,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 6),
                                            Flexible(
                                              child: Text(
                                                noteCategory!,
                                                style: tagTextStyle,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          if (index != null) {
                                            _showClassifyDialog(
                                              index!,
                                              onChanged: (cat) {
                                                pushUndoCheckpoint();
                                                setModalState(() {
                                                  noteCategory = cat;
                                                });
                                              },
                                            );
                                          } else {
                                            _saveNoteIfValid(index, noteType, checkItems, attachments, blocks, noteReminder, noteAssignedDate, noteReminderRepeat);
                                            if (_notes.isNotEmpty) {
                                              final newIndex =
                                                  _notes.length - 1;
                                              _showClassifyDialog(
                                                newIndex,
                                                onChanged: (cat) {
                                                  pushUndoCheckpoint();
                                                  setModalState(() {
                                                    noteCategory = cat;
                                                    index = newIndex;
                                                  });
                                                },
                                              );
                                            }
                                          }
                                        },
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    ),
                      ),
                      SafeArea(
                      child: Builder(
                        builder: (context) {
                          final Color barColor;
                          if (_colorfulNotes && index != null && index! >= 0) {
                            barColor =
                                _categoryPalette[index! % _categoryPalette.length]
                                    .withValues(alpha: 0.75);
                          } else {
                            barColor = _getCategoryColor(noteCategory);
                          }
                          return Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: dNoteHeaderColor(context),
                              border: Border(
                                top: BorderSide(color: barColor, width: 1.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  onPressed: () => _showAddAttachmentSheet(
                                    context,
                                    onSelected: (value) {
                                      if (value == 'file') {
                                        pickAttachments();
                                      } else if (value == 'image') {
                                        pickImagesFromGallery();
                                      } else if (value == 'camera') {
                                        pickImageFromCamera();
                                      } else if (value == 'record') {
                                        recordVoiceNote();
                                      } else if (value == 'video') {
                                        pickVideoFromCamera();
                                      } else if (value == 'scan') {
                                        scanDocumentToText();
                                      }
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () async {
                                          final now = DateTime.now();
                                          final picked = await _pickCalendarDate(
                                            context: context,
                                            initialDate: noteAssignedDate,
                                            firstDate: DateTime(2000, 1, 1),
                                            lastDate: now.add(
                                              const Duration(days: 3650),
                                            ),
                                            helpText: 'Notu bir güne ata',
                                          );
                                          if (picked == null) return;
                                          pushUndoCheckpoint();
                                          setModalState(() {
                                            noteAssignedDate = DateTime(
                                              picked.year,
                                              picked.month,
                                              picked.day,
                                              noteAssignedDate.hour,
                                              noteAssignedDate.minute,
                                            );
                                            noteDate = _getFormattedDate(
                                              noteAssignedDate,
                                            );
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.event,
                                                size: 12,
                                                color: barColor,
                                              ),
                                              const SizedBox(width: 3),
                                              Flexible(
                                                child: Text(
                                                  _getFormattedDate(
                                                    noteAssignedDate,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: barColor,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.more_horiz,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  onPressed: () => _showNoteActions(
                                    context,
                                    index ?? -1,
                                    false,
                                    editorReminder: noteReminder,
                                    editorReminderRepeat: noteReminderRepeat,
                                    onReminderChanged: (reminder, repeat) {
                                      pushUndoCheckpoint();
                                      setModalState(() {
                                        noteReminder = reminder;
                                        noteReminderRepeat = repeat;
                                      });
                                    },
                                    onDiscard: () {
                                      if (deletingAttachmentId != null) {
                                        setModalState(
                                          () => deletingAttachmentId = null,
                                        );
                                        return;
                                      }
                                      SystemChrome.setSystemUIOverlayStyle(
                                        dNoteSystemBarsStyle(context),
                                      );
                                      isEditorOpen = false;
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      });
                                    },
                                    onInsertText: (text) {
                                      if (noteType != 'text') {
                                        _showInfoBar(
                                          'Sesi yazıya çevirme yalnızca metin notlarında kullanılabilir',
                                          icon: Icons.info_outline,
                                        );
                                        return;
                                      }
                                      if (!isEditorOpen) return;
                                      pushUndoCheckpoint();
                                      setModalState(() {
                                        // İmlecin bulunduğu metin bloğunu bul;
                                        // imleç orada yoksa son metin
                                        // bloğuna, o da yoksa yeni bir metin
                                        // bloğuna eklenir (bkz. dosya/görsel
                                        // ekleme akışındaki aynı desen).
                                        int idx = focusedBlockIndex;
                                        if (idx < 0 ||
                                            idx >= blocks.length ||
                                            blocks[idx]['type'] != 'text') {
                                          idx = blocks.lastIndexWhere(
                                            (b) => b['type'] == 'text',
                                          );
                                          if (idx == -1) {
                                            blocks.add({
                                              'type': 'text',
                                              'text': '',
                                            });
                                            idx = blocks.length - 1;
                                          }
                                        }
                                        final controller =
                                            blockControllers[idx];
                                        final current =
                                            controller?.text ??
                                            (blocks[idx]['text'] ?? '')
                                                .toString();
                                        int offset =
                                            controller?.selection.baseOffset ??
                                            -1;
                                        if (offset < 0 ||
                                            offset > current.length) {
                                          offset = current.length;
                                        }
                                        final leftText = current.substring(
                                          0,
                                          offset,
                                        );
                                        final rightText = current.substring(
                                          offset,
                                        );
                                        // Sol tarafta metin varsa ve bir
                                        // boşluk/satır sonuyla bitmiyorsa,
                                        // eklenen metinle birleşmesin diye
                                        // araya boşluk konur.
                                        final needsLeadingSpace =
                                            leftText.isNotEmpty &&
                                            !leftText.endsWith('\n') &&
                                            !leftText.endsWith(' ');
                                        final insertion =
                                            (needsLeadingSpace ? ' ' : '') +
                                            text;
                                        final newLeft = leftText + insertion;
                                        blocks[idx]['text'] = newLeft + rightText;
                                        focusedBlockIndex = idx;
                                        rebuildBlockControllers();
                                        final newCaretOffset = newLeft.length;
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          final newCtrl =
                                              blockControllers[idx];
                                          if (newCtrl != null) {
                                            newCtrl.selection =
                                                TextSelection.collapsed(
                                                  offset: newCaretOffset,
                                                );
                                            blockFocusNodes[idx]
                                                ?.requestFocus();
                                          }
                                        });
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    ).then((_) {
      // Düzenleyici sayfası (geri tuşu, geri kaydırma jesti veya kaydet
      // okuyla) tamamen kapandı: o ana kadar oluşturulan tüm
      // TextEditingController/FocusNode'ları serbest bırak. Odaklı olan
      // varsa önce odaktan çıkar (aksi halde beyaz ekran sorunu).
      for (final f in checkFocusNodes) {
        if (f.hasFocus) f.unfocus();
      }
      for (final f in blockFocusNodes) {
        if (f != null && f.hasFocus) f.unfocus();
      }
      for (final list in blockItemFocusNodes) {
        if (list == null) continue;
        for (final f in list) {
          if (f.hasFocus) f.unfocus();
        }
      }
      for (final list in blockTableLabelFocusNodes) {
        if (list == null) continue;
        for (final f in list) {
          if (f.hasFocus) f.unfocus();
        }
      }
      for (final c in checkControllers) {
        c.dispose();
      }
      for (final f in checkFocusNodes) {
        f.dispose();
      }
      for (final c in blockControllers) {
        c?.dispose();
      }
      for (final f in blockFocusNodes) {
        f?.dispose();
      }
      for (final list in blockItemControllers) {
        if (list != null) {
          for (final c in list) {
            c.dispose();
          }
        }
      }
      for (final list in blockItemFocusNodes) {
        if (list != null) {
          for (final f in list) {
            f.dispose();
          }
        }
      }
      for (final list in blockTableLabelControllers) {
        if (list != null) {
          for (final c in list) {
            c.dispose();
          }
        }
      }
      for (final list in blockTableValueControllers) {
        if (list != null) {
          for (final c in list) {
            c.dispose();
          }
        }
      }
      for (final list in blockTableLabelFocusNodes) {
        if (list != null) {
          for (final f in list) {
            f.dispose();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredNotes;
    SystemChrome.setSystemUIOverlayStyle(dNoteSystemBarsStyle(context));
    bool isTrash = _activeCategory == '__trash__';

    if (isTrash) {
      filteredNotes = _deletedNotes.where((note) {
        final title = (note['title'] ?? '').toString().toLowerCase();
        final content = ContentBlocks.plainText(
          note['content'] as String?,
        ).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || content.contains(query);
      }).toList();
    } else {
      filteredNotes = _notes.where((note) {
        final title = (note['title'] ?? '').toString().toLowerCase();
        final content = ContentBlocks.plainText(
          note['content'] as String?,
        ).toLowerCase();
        final query = _searchQuery.toLowerCase();
        final matchesSearch = title.contains(query) || content.contains(query);
        final isArchived = note['isArchived'] == true;
        final isFavorite = note['isFavorite'] == true;
        final isLocked = note['isLocked'] == true;

        if (_activeCategory == 'Tümü' || _activeCategory == 'Notlar') {
          return matchesSearch && !isArchived && !isLocked;
        } else if (_activeCategory == '__favorites__') {
          return matchesSearch && isFavorite && !isArchived && !isLocked;
        } else if (_activeCategory == '__locked__') {
          return matchesSearch && isLocked && !isArchived;
        } else if (_activeCategory == '__archive__') {
          return matchesSearch && isArchived && !isLocked;
        } else if (_activeCategory == '__reminders__') {
          return matchesSearch &&
              _hasActiveReminder(note) &&
              !isArchived &&
              !isLocked;
        } else {
          return matchesSearch &&
              !isArchived &&
              !isLocked &&
              note['category'] == _activeCategory;
        }
      }).toList();
    }

    if (_activeCategory == '__reminders__') {
      filteredNotes.sort((a, b) {
        final aDate =
            DateTime.tryParse((a['reminderDate'] ?? '').toString()) ??
            DateTime(9999);
        final bDate =
            DateTime.tryParse((b['reminderDate'] ?? '').toString()) ??
            DateTime(9999);
        return aDate.compareTo(bDate);
      });
    } else {
      filteredNotes.sort((a, b) {
        int compareResult = 0;
        switch (_sortCriteria) {
          case "Başlık":
            compareResult = (a['title'] ?? '').toString().compareTo(
              (b['title'] ?? '').toString(),
            );
            break;
          case "Kategori":
            compareResult = (a['category'] ?? '').toString().compareTo(
              (b['category'] ?? '').toString(),
            );
            break;
          case "Renk":
            compareResult = (a['color'] ?? '').toString().compareTo(
              (b['color'] ?? '').toString(),
            );
            break;
          case "Son Düzenleme":
            compareResult = (a['modifiedDate'] ?? '').toString().compareTo(
              (b['modifiedDate'] ?? '').toString(),
            );
            break;
          case "Oluşturulma":
          default:
            compareResult = (a['createdDate'] ?? '').toString().compareTo(
              (b['createdDate'] ?? '').toString(),
            );
            break;
        }
        return _isAscending ? compareResult : -compareResult;
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_scaffoldKey.currentState?.isDrawerOpen == true) {
          _scaffoldKey.currentState?.closeDrawer();
          return;
        }
        if (_isSearching) {
          setState(() {
            _isSearching = false;
            _searchQuery = "";
            _searchController.clear();
          });
          FocusScope.of(context).unfocus();
          return;
        }

        if (_activeCategory != 'Tümü' && _activeCategory != 'Notlar') {
          setState(() {
            _activeCategory = 'Tümü';
          });
          _saveData();
          return;
        }

        await _handleBackPress();
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        drawerEdgeDragWidth: MediaQuery.of(context).size.width,
        // Menü (Drawer) açıldığında Flutter'ın varsayılan siyah yarı saydam
        // scrim'i arka planı koyulaştırıyor. Koyu temada zaten koyu bir zemin
        // üzerine bindiği için fark edilmiyordu; açık temada ise FAB gibi alt
        // bar öğelerini soluklaştırıyordu. Scrim'i kaldırarak her iki temada
        // da tutarlı, koyu temadaki gibi "silikleşmeyen" bir görünüm sağlanır.
        drawerScrimColor: Colors.transparent,
        appBar: AppBar(
          leading: _isSelectionMode
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.amber),
                  tooltip: 'Seçimi İptal Et',
                  onPressed: _exitSelectionMode,
                )
              : null,
          title: _isSelectionMode
              ? Text(
                  '${_selectedNoteKeys.length} seçildi',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    fontSize: 18,
                  ),
                )
              : _isSearching
              ? TextField(
                  selectionWidthStyle: ui.BoxWidthStyle.tight,
                  controller: _searchController,
                  autofocus: true,
                  contextMenuBuilder: buildCustomContextMenu,
                  selectionHeightStyle: ui.BoxHeightStyle.max,
                  decoration: const InputDecoration(
                    hintText: 'Notlarda ara...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: const TextStyle(fontSize: 18),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                )
              : Text(
                  _getCategoryDisplayName(_activeCategory),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    fontSize: 18,
                  ),
                ),
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: Colors.amber),
          actions: _isSelectionMode
              ? [
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.amber),
                    tooltip: 'Sil',
                    onPressed: _deleteSelectedNotes,
                  ),
                  IconButton(
                    icon: const Icon(Icons.archive_outlined, color: Colors.amber),
                    tooltip: 'Arşiv',
                    onPressed: _archiveSelectedNotes,
                  ),
                  IconButton(
                    icon: const Icon(Icons.folder_outlined, color: Colors.amber),
                    tooltip: 'Kategori',
                    onPressed: _showClassifyDialogForSelection,
                  ),
                ]
              : [
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              icon: Icon(
                _isSearching ? Icons.close : Icons.search,
                color: Colors.amber,
              ),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchQuery = "";
                    _searchController.clear();
                  }
                });
              },
            ),
            if (isTrash)
              PopupMenuButton<String>(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                icon: const Icon(Icons.more_vert, color: Colors.amber),
                onSelected: (String choice) {
                  if (choice == 'empty') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'Çöpü Boşalt',
                          style: TextStyle(color: Colors.amber),
                        ),
                        content: const Text(
                          'Tüm silinen notlar kalıcı olarak silinecek. Emin misiniz?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'İptal',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              for (final n in _deletedNotes) {
                                _cleanupAttachmentFiles(n);
                              }
                              setState(() {
                                _deletedNotes.clear();
                              });
                              _saveData();
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Sil',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (choice == 'restore_all') {
                    final restored = List<Map<String, dynamic>>.from(
                      _deletedNotes,
                    );
                    setState(() {
                      for (var n in _deletedNotes) {
                        n['createdDate'] = DateTime.now().toString();
                        n['modifiedDate'] = DateTime.now().toString();
                      }
                      _notes.insertAll(0, _deletedNotes);
                      _deletedNotes.clear();
                    });
                    _saveData();
                    for (final n in restored) {
                      _rescheduleNoteReminder(n);
                    }
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem(
                      value: 'empty',
                      child: Text(
                        'Çöpü Boşalt',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'restore_all',
                      child: Text(
                        'Hepsini Geri Yükle',
                        style: TextStyle(color: Colors.amber),
                      ),
                    ),
                  ];
                },
              )
            else
              PopupMenuButton<String>(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                icon: const Icon(Icons.sort, color: Colors.amber),
                tooltip: 'Notları Sırala',
                onSelected: (String choice) {
                  setState(() {
                    if (choice == "Artan") {
                      _isAscending = true;
                    } else if (choice == "Azalan") {
                      _isAscending = false;
                    } else {
                      _sortCriteria = choice;
                    }
                  });
                  _saveData();
                },
                itemBuilder: (BuildContext context) {
                  return [
                    CheckedPopupMenuItem<String>(
                      value: 'Artan',
                      checked: _isAscending,
                      child: const Text('Düzen: Artan (A-Z)'),
                    ),
                    CheckedPopupMenuItem<String>(
                      value: 'Azalan',
                      checked: !_isAscending,
                      child: const Text('Düzen: Azalan (Z-A)'),
                    ),
                    const PopupMenuDivider(),
                    CheckedPopupMenuItem<String>(
                      value: 'Başlık',
                      checked: _sortCriteria == 'Başlık',
                      child: const Text('Sırala: Başlık'),
                    ),
                    CheckedPopupMenuItem<String>(
                      value: 'Son Düzenleme',
                      checked: _sortCriteria == 'Son Düzenleme',
                      child: const Text('Sırala: Son Düzenleme'),
                    ),
                    CheckedPopupMenuItem<String>(
                      value: 'Oluşturulma',
                      checked: _sortCriteria == 'Oluşturulma',
                      child: const Text('Sırala: Oluşturulma'),
                    ),
                    CheckedPopupMenuItem<String>(
                      value: 'Kategori',
                      checked: _sortCriteria == 'Kategori',
                      child: const Text('Sırala: Kategori'),
                    ),
                  ];
                },
              ),
            IconButton(
              icon: Icon(
                _isListView ? Icons.grid_view : Icons.view_list,
                color: Colors.amber,
              ),
              tooltip: _isListView ? 'Izgara Görünümü' : 'Liste Görünümü',
              onPressed: () {
                setState(() {
                  _isListView = !_isListView;
                });
                _saveData();
              },
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SafeArea(
            top: false,
            child: Container(
              color: Theme.of(context).cardColor,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: dNoteHeaderColor(context)),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'LayNote',
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Kişisel Not Defteriniz',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
                    child: Text(
                      'NOTLAR',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Container(
                    color:
                        (_activeCategory == 'Tümü' ||
                            _activeCategory == 'Notlar')
                        ? dNoteHighlight(context)
                        : Colors.transparent,
                    child: ListTile(
                      leading: const Icon(Icons.notes, color: Colors.amber),
                      title: const Text('Notlar'),
                      trailing: Text(
                        _getCountForCategory('Tümü').toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        setState(() => _activeCategory = 'Tümü');
                        _saveData();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    color: _activeCategory == '__favorites__'
                        ? dNoteHighlight(context)
                        : Colors.transparent,
                    child: ListTile(
                      leading: const Icon(
                        Icons.star_outline,
                        color: Colors.amber,
                      ),
                      title: const Text(
                        'Favori',
                      ),
                      trailing: Text(
                        _getCountForCategory('__favorites__').toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        setState(() => _activeCategory = '__favorites__');
                        _saveData();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    color: _activeCategory == '__reminders__'
                        ? dNoteHighlight(context)
                        : Colors.transparent,
                    child: ListTile(
                      leading: const Icon(
                        Icons.notifications_active_outlined,
                        color: Colors.amber,
                      ),
                      title: const Text('Hatırlatıcı'),
                      trailing: Text(
                        _getCountForCategory('__reminders__').toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        setState(() => _activeCategory = '__reminders__');
                        _saveData();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    color: _activeCategory == '__locked__'
                        ? dNoteHighlight(context)
                        : Colors.transparent,
                    child: ListTile(
                      leading: const Icon(
                        Icons.lock_outline,
                        color: Colors.amber,
                      ),
                      title: const Text(
                        'Kilitli',
                      ),
                      trailing: Text(
                        _getCountForCategory('__locked__').toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () => _openLockedFolder(),
                    ),
                  ),
                  Container(
                    color: _activeCategory == '__archive__'
                        ? dNoteHighlight(context)
                        : Colors.transparent,
                    child: ListTile(
                      leading: const Icon(
                        Icons.archive_outlined,
                        color: Colors.amber,
                      ),
                      title: const Text(
                        'Arşiv',
                      ),
                      trailing: Text(
                        _getCountForCategory('__archive__').toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        setState(() => _activeCategory = '__archive__');
                        _saveData();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    color: _activeCategory == '__trash__'
                        ? dNoteHighlight(context)
                        : Colors.transparent,
                    child: ListTile(
                      leading: const Icon(
                        Icons.delete_outline,
                        color: Colors.amber,
                      ),
                      title: const Text(
                        'Çöp',
                      ),
                      trailing: Text(
                        _deletedNotes.length.toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        setState(() => _activeCategory = '__trash__');
                        _saveData();
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  Divider(
                    color: Theme.of(context).dividerColor,
                    thickness: 1,
                    height: 24,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 4, bottom: 4),
                    child: Text(
                      'KATEGORİLER',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  ..._categories.map((cat) {
                    final catColor = _getCategoryColor(cat);
                    final isCatLocked = _lockedCategories.contains(cat);
                    return Container(
                      color: _activeCategory == cat
                          ? dNoteHighlight(context)
                          : Colors.transparent,
                      child: ListTile(
                        leading: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(Icons.folder_outlined, color: catColor),
                            if (isCatLocked)
                              Positioned(
                                right: -4,
                                bottom: -4,
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.blueGrey[300],
                                  size: 12,
                                ),
                              ),
                          ],
                        ),
                        title: Text(
                          cat,
                          style: TextStyle(
                            color: _activeCategory == cat
                                ? catColor
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        trailing: Text(
                          _getCountForCategory(cat).toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () async {
                          if (isCatLocked) {
                            Navigator.pop(context); // drawer'ı kapat
                            await Future.delayed(
                              const Duration(milliseconds: 350),
                            );
                            if (!mounted) return;
                            if (!_notePasswordEnabled) {
                              // Parola belirlenmemişse artık "Parola
                              // Gerekiyor" uyarı dialogu yerine doğrudan
                              // "Yeni Parola Oluştur" ekranı açılır; parola
                              // belirlenince kullanıcı doğrudan kategoriye
                              // girer.
                              final created = await _showCreatePasswordDialog();
                              if (!mounted || !created) return;
                              setState(() => _activeCategory = cat);
                              _saveData();
                              return;
                            }
                            final ok = await _checkPasswordPrompt();
                            if (!mounted) return;
                            if (ok) {
                              setState(() => _activeCategory = cat);
                              _saveData();
                            } else {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text(
                                    'Hatalı Parola',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: const Text(
                                    'Girdiğiniz parola yanlış.',
                                  ),
                                  actions: [
                                    ElevatedButton(
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
                                  ],
                                ),
                              );
                            }
                          } else {
                            setState(() => _activeCategory = cat);
                            _saveData();
                            Navigator.pop(context);
                          }
                        },
                        onLongPress: () => _showCategoryOptions(cat),
                      ),
                    );
                  }),
                  ListTile(
                    leading: Icon(
                      Icons.add_circle_outline,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    title: const Text(
                      'Kategori Ekle',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showAddCategoryDialog();
                    },
                  ),

                  const Divider(
                    thickness: 1,
                    height: 24,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 4, bottom: 4),
                    child: Text(
                      'UYGULAMA',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.calendar_month,
                      color: Colors.amber,
                    ),
                    title: const Text(
                      'Takvim',
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      final tappedNoteId = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CalendarScreen(
                            notes: List<Map<String, dynamic>>.from(_notes),
                          ),
                        ),
                      );
                      if (!mounted || tappedNoteId == null) return;
                      final index = _notes.indexWhere(
                        (n) => n['id']?.toString() == tappedNoteId,
                      );
                      if (index != -1) {
                        _openNoteWithPasswordCheck(index);
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.settings_outlined,
                      color: Colors.amber,
                    ),
                    title: const Text(
                      'Ayarlar',
                    ),
                    onTap: _openSettings,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.backup_outlined,
                      color: Colors.amber,
                    ),
                    title: const Text(
                      'Yedekle & Geri Yükle',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BackupRestoreScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.workspace_premium_outlined,
                      color: Colors.amber,
                    ),
                    title: const Text(
                      'Pro\'ya Yükselt',
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.volunteer_activism_outlined,
                      color: Colors.amber,
                    ),
                    title: const Text(
                      'Geliştirme Desteği',
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.rate_review_outlined,
                      color: Colors.amber,
                    ),
                    title: const Text(
                      'Geri Bildirim',
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.info_outline,
                      color: Colors.amber,
                    ),
                    title: const Text(
                      'Hakkında',
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (_isSearching) {
              setState(() {
                _isSearching = false;
                _searchQuery = "";
                _searchController.clear();
              });
              FocusScope.of(context).unfocus();
            } else {
              FocusScope.of(context).unfocus();
            }
          },
          child: Padding(
            padding: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: filteredNotes.isEmpty
                ? const Center(
                    child: Text(
                      'Not bulunamadı.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : _isListView
                ? ListView.builder(
                    padding: const EdgeInsets.only(top: 12.0),
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      final originalIndex = isTrash
                          ? _deletedNotes.indexWhere(
                              (n) =>
                                  n['id'] == note['id'] &&
                                  n['createdDate'] == note['createdDate'],
                            )
                          : _notes.indexWhere(
                              (n) =>
                                  n['id'] == note['id'] &&
                                  n['createdDate'] == note['createdDate'],
                            );
                      final hasTitle = (note['title'] ?? '')
                          .toString()
                          .isNotEmpty;
                      final isChecklist = note['type'] == 'checklist';
                      final isFavorite = note['isFavorite'] == true;
                      final isSelected =
                          _isSelectionMode &&
                          _selectedNoteKeys.contains(_noteKey(note));
                      final baseNoteCardColor = _colorfulNotes
                          ? _categoryPalette[(originalIndex < 0
                                        ? 0
                                        : originalIndex) %
                                    _categoryPalette.length]
                                .withValues(alpha: 0.75)
                          : (dNoteIsDark(context)
                                ? const Color(0xFF2D2D2D)
                                : Theme.of(context).cardColor);
                      // Seçili notlar, dokununca beliren parlaklık efektiyle
                      // aynı tonda (amber) sürekli vurgulanır.
                      final noteCardColor = isSelected
                          ? Color.alphaBlend(
                              Colors.amber.withValues(alpha: 0.30),
                              baseNoteCardColor,
                            )
                          : baseNoteCardColor;
                      final fontScale = _previewFontScale(note);
                      final previewImage = _firstImageAttachment(note);
                      final previewDrawingStrokes = previewImage == null
                          ? _firstDrawingStrokes(note)
                          : null;
                      final previewContentText = isChecklist
                          ? ''
                          : ContentBlocks.plainText(
                              note['content'] as String?,
                            );
                      final previewChecklistItems = isChecklist
                          ? (note['checkItems'] as List? ?? [])
                          : const [];
                      final previewReminderText = _formattedReminderText(
                        note,
                      );
                      final previewCategoryText = (note['category'] ?? '')
                          .toString();
                      // Not sadece bir görselden oluşuyorsa (başlık, metin,
                      // kontrol listesi öğesi, hatırlatıcı, kategori veya
                      // yıldız rozeti yoksa) altta boş bir satır bırakmamak
                      // için gövde bölümü (Padding) hiç çizilmez.
                      final previewShowFavoriteAlone =
                          isFavorite && !hasTitle && !isChecklist &&
                          previewContentText.isEmpty;
                      final previewHasBody = hasTitle ||
                          previewChecklistItems.isNotEmpty ||
                          previewContentText.isNotEmpty ||
                          previewReminderText != null ||
                          previewCategoryText.isNotEmpty ||
                          previewShowFavoriteAlone;

                      return GestureDetector(
                        onLongPress: isTrash
                            ? () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Theme.of(context).cardColor,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (_) => SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.amber,
                                            ),
                                            icon: const Icon(
                                              Icons.restore_outlined,
                                              color: Colors.black,
                                            ),
                                            label: const Text(
                                              'Geri Yükle',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            onPressed: () {
                                              final restoredNote =
                                                  _deletedNotes[originalIndex];
                                              setState(() {
                                                _notes.insert(
                                                  0,
                                                  _deletedNotes[originalIndex],
                                                );
                                                _deletedNotes.removeAt(
                                                  originalIndex,
                                                );
                                              });
                                              _saveData();
                                              _rescheduleNoteReminder(
                                                restoredNote,
                                              );
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            icon: const Icon(
                                              Icons.delete_forever,
                                              color: Colors.white,
                                            ),
                                            label: const Text(
                                              'Kalıcı Sil',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              _cleanupAttachmentFiles(_deletedNotes[originalIndex]);
                                            setState(() {
                                              _deletedNotes.removeAt(originalIndex);
                                            });
                                              _saveData();
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            : (_isSelectionMode
                                  ? () => _toggleNoteSelection(note)
                                  : () => _showNoteActions(
                                      context,
                                      originalIndex,
                                      false,
                                      showSelectAction: true,
                                      onInsertText: (text) =>
                                          _appendSpeechTranscriptToNote(
                                            originalIndex,
                                            text,
                                          ),
                                    )),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Card(
                            margin: EdgeInsets.zero,
                            color: noteCardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: isSelected
                                  ? const BorderSide(
                                      color: Colors.amber,
                                      width: 2,
                                    )
                                  : BorderSide.none,
                            ),
                            child: InkWell(
                              onTap: isTrash
                                  ? () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Theme.of(context).cardColor,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                        ),
                                        builder: (_) => SafeArea(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.amber,
                                                      ),
                                                  icon: const Icon(
                                                    Icons.restore_outlined,
                                                    color: Colors.black,
                                                  ),
                                                  label: const Text(
                                                    'Geri Yükle',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    final restoredNote =
                                                        _deletedNotes[originalIndex];
                                                    setState(() {
                                                      _deletedNotes[originalIndex]['createdDate'] =
                                                          DateTime.now()
                                                              .toString();
                                                      _deletedNotes[originalIndex]['modifiedDate'] =
                                                          DateTime.now()
                                                              .toString();
                                                      _notes.insert(
                                                        0,
                                                        _deletedNotes[originalIndex],
                                                      );
                                                      _deletedNotes.removeAt(
                                                        originalIndex,
                                                      );
                                                    });
                                                    _saveData();
                                                    _rescheduleNoteReminder(
                                                      restoredNote,
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                  icon: const Icon(
                                                    Icons.delete_forever,
                                                    color: Colors.white,
                                                  ),
                                                  label: const Text(
                                                    'Kalıcı Sil',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    _cleanupAttachmentFiles(_deletedNotes[originalIndex]);
                                            setState(() {
                                              _deletedNotes.removeAt(originalIndex);
                                            });
                                                    _saveData();
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  : (_isSelectionMode
                                        ? () => _toggleNoteSelection(note)
                                        : () => _openNoteWithPasswordCheck(
                                            originalIndex,
                                          )),
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (previewImage != null &&
                                      _attachmentsDirPath != null)
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: _kGridPreviewAspectRatio,
                                        child: Image.file(
                                          File(
                                            p.join(
                                              _attachmentsDirPath!,
                                              previewImage['storedName']
                                                  .toString(),
                                            ),
                                          ),
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                                color: dNoteSurfaceVariant(
                                                  context,
                                                ),
                                                child: const Icon(
                                                  Icons
                                                      .broken_image_outlined,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                              ),
                                        ),
                                      ),
                                    )
                                  else if (previewDrawingStrokes != null)
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: _kGridPreviewAspectRatio,
                                        child: _gridPreviewDrawingTile(
                                          previewDrawingStrokes,
                                        ),
                                      ),
                                    ),
                                  if (previewHasBody)
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (hasTitle) ...[
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _capitalizeFirstLetterTr(
                                                (note['title'] ?? '')
                                                    .toString(),
                                              ),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18 * fontScale,
                                                color: dNoteEffectiveTextColor(context, _textColor),
                                              ),
                                            ),
                                          ),
                                          if (isFavorite)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 6,
                                              ),
                                              child: Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 18,
                                              ),
                                            ),
                                          if (note['isLocked'] == true)
                                            const Padding(
                                              padding: EdgeInsets.only(left: 6),
                                              child: Icon(
                                                Icons.lock,
                                                color: Colors.grey,
                                                size: 14,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                    if (previewChecklistItems.isNotEmpty)
                                      ...((note['checkItems'] as List? ?? [])
                                          .take(_previewLines)
                                          .map<Widget>(
                                            (item) => Row(
                                              children: [
                                                Icon(
                                                  item['checked'] == true
                                                      ? Icons.check_box
                                                      : Icons
                                                            .check_box_outline_blank,
                                                  color: Colors.amber,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(
                                                    item['text'] ?? '',
                                                    style: TextStyle(
                                                      color:
                                                          item['checked'] ==
                                                              true
                                                          ? Colors.grey
                                                          : (dNoteEffectiveTextColor(context, _textColor)),
                                                      decoration:
                                                          item['checked'] ==
                                                              true
                                                          ? TextDecoration
                                                                .lineThrough
                                                          : null,
                                                      fontSize:
                                                          (note['fontSize']
                                                                  as num?)
                                                              ?.toDouble() ??
                                                          _globalFontSize,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                          .toList())
                                    else if (previewContentText.isNotEmpty ||
                                        previewShowFavoriteAlone)
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              previewContentText,
                                              style: TextStyle(
                                                color: dNoteEffectiveTextColor(context, _textColor),
                                                fontSize:
                                                    (note['fontSize'] as num?)
                                                        ?.toDouble() ??
                                                    _globalFontSize,
                                              ),
                                              maxLines: _previewLines,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (isFavorite && !hasTitle)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 6,
                                              ),
                                              child: Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 18,
                                              ),
                                            ),
                                        ],
                                      ),
                                    if (_formattedReminderText(note) !=
                                        null) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            note['reminderRepeat'] == null
                                                ? Icons.access_time
                                                : Icons.repeat,
                                            color: Colors.grey,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              _formattedReminderText(note)!,
                                              style: TextStyle(
                                                color: dNoteEffectiveTextColor(
                                                  context,
                                                  _textColor,
                                                ),
                                                fontSize:
                                                    (note['fontSize'] as num?)
                                                        ?.toDouble() ??
                                                    _globalFontSize,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if ((note['category'] ?? '')
                                        .toString()
                                        .isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.folder_outlined,
                                              color: Colors.grey,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Flexible(
                                              child: Text(
                                                note['category'],
                                                style: TextStyle(
                                                  color:
                                                      dNoteEffectiveTextColor(
                                                    context,
                                                    _textColor,
                                                  ),
                                                  fontSize:
                                                      (note['fontSize']
                                                              as num?)
                                                          ?.toDouble() ??
                                                      _globalFontSize,
                                                ),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: _buildGridView(
                      filteredNotes: filteredNotes,
                      isTrash: isTrash,
                    ),
                  ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showNoteDialog(type: 'text'),
          backgroundColor: Colors.amber,
          child: const Icon(Icons.add, color: Colors.black, size: 30),
        ),
      ),
    );
  }

  // Izgara görünümü: kart yüksekliği sabit DEĞİLDİR, içerik kadar yer kaplar.
  // Üst sınır: Ayarlar > Not Önizleme Satırı (_previewLines) ile belirlenir.
  // 2 sütunlu "staggered" (Pinterest tarzı) düzen — sütunlar arasında en kısa
  // olana yeni kart eklenerek sütun yükseklikleri dengelenir.
  Widget _buildGridView({
    required List<Map<String, dynamic>> filteredNotes,
    required bool isTrash,
  }) {
    const int crossAxisCount = 2;
    const double spacing = 10;
    const double outerPadding = 0.0; // dış konteyner zaten 16px padding veriyor
    const double cardInnerPadding =
        16.0; // _buildGridNoteCard içindeki Padding değeri

    // Her sütunun gerçek genişliğini hesapla: ekran genişliğinden dış
    // padding'leri ve sütunlar arası boşluğu çıkar, crossAxisCount'a böl.
    final screenWidth = MediaQuery.of(context).size.width;
    final totalSpacing = (outerPadding * 2) + (spacing * (crossAxisCount - 1));
    final columnWidth = (screenWidth - totalSpacing) / crossAxisCount;
    // Kartın iç padding'ini çıkararak metnin gerçekte sarabileceği genişliği bul.
    final cardContentWidth = (columnWidth - (cardInnerPadding * 2)).clamp(
      0.0,
      columnWidth,
    );

    final List<List<Widget>> columnChildren = List.generate(
      crossAxisCount,
      (_) => <Widget>[],
    );
    final List<double> columnHeights = List.filled(crossAxisCount, 0.0);

    for (int index = 0; index < filteredNotes.length; index++) {
      final note = filteredNotes[index];
      final originalIndex = isTrash
          ? _deletedNotes.indexWhere(
              (n) =>
                  n['id'] == note['id'] &&
                  n['createdDate'] == note['createdDate'],
            )
          : _notes.indexWhere(
              (n) =>
                  n['id'] == note['id'] &&
                  n['createdDate'] == note['createdDate'],
            );

      // Kartı, şu anda en kısa olan sütuna ekle (sütun yüksekliklerini dengeler).
      int shortestColumn = 0;
      for (int c = 1; c < crossAxisCount; c++) {
        if (columnHeights[c] < columnHeights[shortestColumn]) {
          shortestColumn = c;
        }
      }

      final estimatedHeight = _estimateNoteHeight(note, cardContentWidth);
      columnHeights[shortestColumn] += estimatedHeight;

      columnChildren[shortestColumn].add(
        Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: SizedBox(
            width: double.infinity,
            child: _buildGridNoteCard(
              note: note,
              originalIndex: originalIndex,
              isTrash: isTrash,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(crossAxisCount, (c) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: c == 0 ? 0 : spacing / 2,
                right: c == crossAxisCount - 1 ? 0 : spacing / 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: columnChildren[c],
              ),
            ),
          );
        }),
      ),
    );
  }

  // Bir notun önizlemede kullanacağı yazı boyutu ölçek katsayısını döndürür.
  // Not kendi özel fontSize'ını taşıyorsa o değer, taşımıyorsa Ayarlar >
  // Kişiselleştirme > Metin Boyutu (_globalFontSize) baz alınır. 16.0
  // varsayılan/temel boyut olduğundan ölçek = seçilen boyut / 16.0 şeklinde
  // hesaplanır; bu sayede mevcut tüm fontSize değerleri (başlık, içerik,
  // checklist) orantılı şekilde büyür/küçülür.
  double _previewFontScale(Map<String, dynamic> note) {
    final noteFontSize =
        (note['fontSize'] as num?)?.toDouble() ?? _globalFontSize;
    return noteFontSize / 16.0;
  }

  // Kart önizlemesinde göstermek üzere, notun eklerinden ilk görseli bulur.
  Map<String, dynamic>? _firstImageAttachment(Map<String, dynamic> note) {
    final atts = note['attachments'];
    if (atts is List) {
      for (final a in atts) {
        if (a is Map &&
            a['isImage'] == true &&
            (a['storedName'] ?? '').toString().isNotEmpty) {
          return Map<String, dynamic>.from(a);
        }
      }
    }
    return null;
  }

  // Kart önizlemesinde göstermek üzere, notun eklerinden ilk `max` görseli
  // sırayla toplar. Birden fazla foto olsa bile önizlemede her zaman tek
  // foto gösterilsin diye varsayılan `max` değeri 1'dir (yan yana iki foto
  // gösterimi kaldırıldı; alttaki "images.length >= 2" dallarına artık hiç
  // girilmez, tek foto dalı her zaman kullanılır).
  List<Map<String, dynamic>> _previewImages(
    Map<String, dynamic> note, {
    int max = 1,
  }) {
    final atts = note['attachments'];
    final result = <Map<String, dynamic>>[];
    if (atts is List) {
      for (final a in atts) {
        if (a is Map &&
            a['isImage'] == true &&
            (a['storedName'] ?? '').toString().isNotEmpty) {
          result.add(Map<String, dynamic>.from(a));
          if (result.length >= max) break;
        }
      }
    }
    return result;
  }

  // Kart önizleme fotoğrafının en/boy oranı: 16:9 (geniş ekran oranı).
  // Kart/satır genişliği ne olursa olsun bu oran sabit kalır.
  static const double _kGridPreviewAspectRatio = 16 / 9;

  // Yazısız (sadece foto/çizim) notlarda, IZGARA (kart) görünümündeki
  // önizleme kare olarak gösterilir — sadece bu özel mod için. Metinli
  // notlardaki üst şerit (16:9) ve liste görünümündeki önizlemeler bundan
  // etkilenmez, aynı kalır.
  static const double _kGridPreviewSquareAspectRatio = 1.0;

  // Bir ek görselini kart önizlemesinde (BoxFit.cover) çizen ortak widget.
  Widget _gridPreviewImageTile(Map<String, dynamic> image) {
    if (_attachmentsDirPath == null) {
      return Container(color: dNoteSurfaceVariant(context));
    }
    return Image.file(
      File(p.join(_attachmentsDirPath!, image['storedName'].toString())),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: dNoteSurfaceVariant(context),
        child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
      ),
    );
  }

  // Kart önizlemesinde göstermek üzere, notun içeriğindeki ilk dolu çizim
  // bloğunun stroke'larını bulur. Sadece görsel eki YOKSA çağrılır (bir not
  // hem fotoğraf hem çizim içeriyorsa önizlemede fotoğraf önceliklidir,
  // tıpkı _firstImageAttachment gibi). Kontrol listesi notlarında blok
  // yapısı kullanılmadığından her zaman null döner.
  List<Map<String, dynamic>>? _firstDrawingStrokes(Map<String, dynamic> note) {
    if (note['type'] == 'checklist') return null;
    final blocks = ContentBlocks.parse(note['content'] as String?);
    for (final b in blocks) {
      if (b['type'] == 'drawing') {
        final strokes = List<Map<String, dynamic>>.from(
          (b['strokes'] as List? ?? const []).map(
            (s) => Map<String, dynamic>.from(s as Map),
          ),
        );
        if (strokes.isNotEmpty) return strokes;
      }
    }
    return null;
  }

  // Bir çizim bloğunu kart önizlemesinde (BoxFit.cover'a benzer şekilde,
  // FittedBox ile) çizen ortak widget. Çizim, düzenleyicideki gerçek tuval
  // boyutuyla (ekran genişliği - 40, kDrawingDefaultCanvasHeight) aynı
  // sabit boyutta çizilip önizleme alanına ölçeklenir — _DrawingPainter,
  // stroke noktalarını ham (ölçeksiz) piksel konumu olarak kullandığından
  // bu, düzenleyicideki görünümle orantıyı koruyan tek yöntemdir (bkz.
  // NoteScreenshotService'teki aynı yaklaşım).
  Widget _gridPreviewDrawingTile(List<Map<String, dynamic>> strokes) {
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = 20.0;
    final originalWidth = screenWidth - (horizontalPadding * 2);
    return Container(
      color: dNoteIsDark(context) ? Colors.black : Colors.white,
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: originalWidth,
          height: kDrawingDefaultCanvasHeight,
          child: CustomPaint(
            painter: _DrawingPainter(
              strokes: strokes,
              livePoints: null,
              liveColor: Colors.transparent,
              liveWidth: 0,
            ),
          ),
        ),
      ),
    );
  }

  // Verilen metnin, belirtilen genişlik ve yazı stiliyle gerçekte kaç satıra
  // SARACAĞINI ölçer (TextPainter ile). Basit "\n sayısı" tahmini, satır
  // kendiliğinden sardığında (özellikle metin boyutu büyütüldüğünde) yanlış
  // sonuç verip sütun dengesini bozduğu için bunun yerine gerçek ölçüm
  // kullanılır.
  int _measureWrappedLineCount(String text, double maxWidth, TextStyle style) {
    if (text.isEmpty) return 0;
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: maxWidth);
    return painter.computeLineMetrics().length;
  }

  // Kartın gerçekte kaç piksel yükseklik kaplayacağını ölçer (sütun
  // dengelemesi için). Önceki sürüm sadece "satır sayısı" topluyordu; bu,
  // başlık/içerik/checklist satırlarının farklı font boyutlarına ve kartın
  // sabit iç boşluklarına (padding, SizedBox aralıkları) duyarsız kalıp
  // sütunlar arasında kümülatif sapmaya yol açıyordu (bazı notların hep
  // aynı sütuna yığılması). Gerçek piksel yüksekliği, kartın
  // _buildGridNoteCard içindeki gerçek yapısıyla (16px iç padding, başlık
  // sonrası 12px boşluk, kategori öncesi 8px boşluk, checklist öğeleri
  // arası 4px boşluk) bire bir eşleşecek şekilde hesaplanır.
  double _estimateNoteHeight(
    Map<String, dynamic> note,
    double cardContentWidth,
  ) {
    final hasTitle = (note['title'] ?? '').toString().isNotEmpty;
    final isChecklist = note['type'] == 'checklist';
    final fontScale = _previewFontScale(note);
    // Kartın gerçek (padding'siz) genişliği; _buildGridView içindeki
    // cardInnerPadding (16.0) değeriyle bire bir eşleşmeli.
    const double cardInnerPadding = 16.0;
    final double columnWidth = cardContentWidth + (cardInnerPadding * 2);
    final images = _previewImages(note);
    // Yazısız (sadece foto) notlarda kart tamamen foto(lar)dan ibarettir;
    // checklist notlarda bu özel mod uygulanmaz (checklist her zaman
    // "yazılı" kabul edilir, mevcut davranış korunur).
    final bool hasText = isChecklist
        ? true
        : ContentBlocks.plainText(note['content'] as String?).isNotEmpty;
    // Fotoğraf yoksa, notun ilk çizim bloğuna bakılır (bkz. _gridPreviewDrawingTile);
    // bir not hem fotoğraf hem çizim içeriyorsa fotoğraf önceliklidir.
    final drawingStrokes = images.isEmpty ? _firstDrawingStrokes(note) : null;
    final bool hasVisual = images.isNotEmpty || drawingStrokes != null;
    final bool photoOnlyMode = !isChecklist && hasVisual && !hasText;

    if (photoOnlyMode) {
      // Kart sadece foto(lar)/çizimden ibaret: iç/dış boşluk, başlık,
      // kategori, hatırlatıcı — hiçbiri yok. Tek foto/çizim -> kare kart.
      // İki foto -> yan yana iki kare (kart oranı 2:1).
      return images.length >= 2
          ? (columnWidth / (_kGridPreviewSquareAspectRatio * 2))
          : (columnWidth / _kGridPreviewSquareAspectRatio);
    }

    double height = 32.0; // kartın iç padding'i: 16 üst + 16 alt

    if (images.isNotEmpty) {
      // Tek foto: 16:9 şerit. İki (veya daha fazla) foto: yan yana iki foto
      // (kart genişliği / (16:9 * 2) yükseklik).
      height += images.length >= 2
          ? (columnWidth / (_kGridPreviewAspectRatio * 2))
          : (columnWidth / _kGridPreviewAspectRatio);
    } else if (drawingStrokes != null) {
      // Fotoğraf yok ama çizim var: tek foto ile aynı 16:9 şerit yüksekliği.
      height += columnWidth / _kGridPreviewAspectRatio;
    }

    if (hasTitle) {
      height += (18 * fontScale) * 1.2; // başlık satırı (tek satır, maxLines:1)
      height += 12.0; // başlık sonrası SizedBox
    }

    if (isChecklist) {
      final items = (note['checkItems'] as List? ?? []);
      final itemCount = items.length.clamp(0, _previewLines);
      // Her checklist öğesi tek satır + altında 4px boşluk.
      height += itemCount * ((12 * fontScale) * 1.3 + 4.0);
    } else {
      final content = ContentBlocks.plainText(note['content'] as String?);
      if (content.isNotEmpty) {
        final noteFontSize =
            (note['fontSize'] as num?)?.toDouble() ?? _globalFontSize;
        final style = TextStyle(fontSize: noteFontSize, height: 1.3);
        int wrapped = 0;
        for (final paragraph in content.split('\n')) {
          wrapped += _measureWrappedLineCount(
            paragraph,
            cardContentWidth,
            style,
          ).clamp(0, 999);
          if (paragraph.isEmpty) wrapped += 1; // boş satır da yer kaplar
        }
        final cappedLines = wrapped.clamp(0, _previewLines);
        height += cappedLines * (noteFontSize * 1.3);
      }
    }

    if ((note['category'] ?? '').toString().isNotEmpty) {
      height += 8.0; // kategori öncesi SizedBox
      height += (11 * fontScale) * 1.2; // kategori satırı
    }

    return height < 1 ? 1 : height;
  }

  // Izgara görünümündeki tek bir not kartı. Yüksekliği içeriğe göre belirlenir;
  // başlık + içerik metni doğal yüksekliğini alır (Expanded YOK), maksimum
  // satır sayısı ayarlardaki _previewLines değeriyle sınırlandırılır.
  Widget _buildGridNoteCard({
    required Map<String, dynamic> note,
    required int originalIndex,
    required bool isTrash,
  }) {
    final hasTitle = (note['title'] ?? '').toString().isNotEmpty;
    final isChecklist = note['type'] == 'checklist';
    final isFavorite = note['isFavorite'] == true;
    final isSelected =
        _isSelectionMode && _selectedNoteKeys.contains(_noteKey(note));
    final baseGridCardColor = _colorfulNotes
        ? _categoryPalette[(originalIndex < 0 ? 0 : originalIndex) %
                  _categoryPalette.length]
              .withValues(alpha: 0.75)
        : (dNoteIsDark(context)
              ? const Color(0xFF2D2D2D)
              : Theme.of(context).cardColor);
    // Seçili notlar, dokununca beliren parlaklık efektiyle aynı tonda
    // (amber) sürekli vurgulanır.
    final gridCardColor = isSelected
        ? Color.alphaBlend(
            Colors.amber.withValues(alpha: 0.30),
            baseGridCardColor,
          )
        : baseGridCardColor;
    final fontScale = _previewFontScale(note);
    final images = _previewImages(note);
    // Yazısız (sadece foto) notlarda kart tamamen foto(lar)dan ibarettir;
    // checklist notlar bu özel modun dışında tutulur.
    final bool hasText = isChecklist
        ? true
        : ContentBlocks.plainText(note['content'] as String?).isNotEmpty;
    // Fotoğraf yoksa notun ilk çizim bloğuna bakılır; fotoğraf her zaman
    // önceliklidir (bkz. _gridPreviewDrawingTile).
    final previewDrawingStrokes =
        images.isEmpty ? _firstDrawingStrokes(note) : null;
    final bool hasVisual = images.isNotEmpty || previewDrawingStrokes != null;
    final bool photoOnlyMode = !isChecklist && hasVisual && !hasText;

    return GestureDetector(
      onLongPress: isTrash
          ? () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Theme.of(context).cardColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                          ),
                          icon: const Icon(
                            Icons.restore_outlined,
                            color: Colors.black,
                          ),
                          label: const Text(
                            'Geri Yükle',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            final restoredNote = _deletedNotes[originalIndex];
                            setState(() {
                              _deletedNotes[originalIndex]['createdDate'] =
                                  DateTime.now().toString();
                              _deletedNotes[originalIndex]['modifiedDate'] =
                                  DateTime.now().toString();
                              _notes.insert(0, _deletedNotes[originalIndex]);
                              _deletedNotes.removeAt(originalIndex);
                            });
                            _saveData();
                            _rescheduleNoteReminder(restoredNote);
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Kalıcı Sil',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            _cleanupAttachmentFiles(_deletedNotes[originalIndex]);
                                            setState(() {
                                              _deletedNotes.removeAt(originalIndex);
                                            });
                            _saveData();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          : (_isSelectionMode
                ? () => _toggleNoteSelection(note)
                : () => _showNoteActions(
                    context,
                    originalIndex,
                    false,
                    showSelectAction: true,
                    onInsertText: (text) =>
                        _appendSpeechTranscriptToNote(originalIndex, text),
                  )),
      child: Card(
        margin: EdgeInsets.zero,
        color: gridCardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? const BorderSide(color: Colors.amber, width: 2)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: isTrash
              ? () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Theme.of(context).cardColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (_) => SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                              ),
                              icon: const Icon(
                                Icons.restore_outlined,
                                color: Colors.black,
                              ),
                              label: const Text(
                                'Geri Yükle',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                final restoredNote =
                                    _deletedNotes[originalIndex];
                                setState(() {
                                  _deletedNotes[originalIndex]['createdDate'] =
                                      DateTime.now().toString();
                                  _deletedNotes[originalIndex]['modifiedDate'] =
                                      DateTime.now().toString();
                                  _notes.insert(
                                    0,
                                    _deletedNotes[originalIndex],
                                  );
                                  _deletedNotes.removeAt(originalIndex);
                                });
                                _saveData();
                                _rescheduleNoteReminder(restoredNote);
                                Navigator.pop(context);
                              },
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Kalıcı Sil',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                _cleanupAttachmentFiles(_deletedNotes[originalIndex]);
                                            setState(() {
                                              _deletedNotes.removeAt(originalIndex);
                                            });
                                _saveData();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              : (_isSelectionMode
                    ? () => _toggleNoteSelection(note)
                    : () => _openNoteWithPasswordCheck(originalIndex)),
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              if (photoOnlyMode)
                // ── Yazısız (sadece foto/çizim) not ────────────────────
                // Kart tamamen foto(lar)/çizimden ibaret: başlık/kategori/
                // hatırlatıcı yok, dış/iç boşluk yok. Bu özel modda önizleme
                // KARE gösterilir (yazılı notlardaki 16:9 şeritten farklı
                // olarak, sadece ızgara/kart görünümünde). Tek foto/çizim ->
                // kare kart. İki foto -> yan yana iki kare (kart oranı 2:1).
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: images.length >= 2
                        ? (_kGridPreviewSquareAspectRatio * 2)
                        : _kGridPreviewSquareAspectRatio,
                    child: images.length >= 2
                        ? Row(
                            children: [
                              Expanded(
                                child: _gridPreviewImageTile(images[0]),
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                child: _gridPreviewImageTile(images[1]),
                              ),
                            ],
                          )
                        : (images.isNotEmpty
                              ? _gridPreviewImageTile(images[0])
                              : _gridPreviewDrawingTile(
                                  previewDrawingStrokes!,
                                )),
                  ),
                )
              else
                Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (images.isNotEmpty && _attachmentsDirPath != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: images.length >= 2
                          ? AspectRatio(
                              // İki foto yan yana -> toplam şerit oranı 32:9.
                              aspectRatio: _kGridPreviewAspectRatio * 2,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _gridPreviewImageTile(images[0]),
                                  ),
                                  const SizedBox(width: 2),
                                  Expanded(
                                    child: _gridPreviewImageTile(images[1]),
                                  ),
                                ],
                              ),
                            )
                          : AspectRatio(
                              aspectRatio: _kGridPreviewAspectRatio,
                              child: _gridPreviewImageTile(images[0]),
                            ),
                    )
                  else if (previewDrawingStrokes != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: AspectRatio(
                        aspectRatio: _kGridPreviewAspectRatio,
                        child: _gridPreviewDrawingTile(previewDrawingStrokes),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasTitle)
                          Text(
                            _capitalizeFirstLetterTr(
                              (note['title'] ?? '').toString(),
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18 * fontScale,
                              color: dNoteEffectiveTextColor(context, _textColor),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            textDirection: TextDirection.ltr,
                          ),
                        if (hasTitle) const SizedBox(height: 12),
                        isChecklist
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: (note['checkItems'] as List? ?? [])
                                    .take(_previewLines)
                                    .map<Widget>(
                                      (item) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        child: Row(
                                          textDirection: TextDirection.ltr,
                                          children: [
                                            Icon(
                                              item['checked'] == true
                                                  ? Icons.check_box
                                                  : Icons
                                                        .check_box_outline_blank,
                                              color: Colors.amber,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                item['text'] ?? '',
                                                style: TextStyle(
                                                  color:
                                                      item['checked'] == true
                                                      ? Colors.grey
                                                      : (dNoteEffectiveTextColor(context, _textColor)),
                                                  decoration:
                                                      item['checked'] == true
                                                      ? TextDecoration
                                                            .lineThrough
                                                      : null,
                                                  fontSize:
                                                      (note['fontSize']
                                                              as num?)
                                                          ?.toDouble() ??
                                                      _globalFontSize,
                                                ),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                                textDirection:
                                                    TextDirection.ltr,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              )
                            : Text(
                                ContentBlocks.plainText(
                                  note['content'] as String?,
                                ),
                                style: TextStyle(
                                  color: dNoteEffectiveTextColor(context, _textColor),
                                  fontSize:
                                      (note['fontSize'] as num?)?.toDouble() ??
                                      _globalFontSize,
                                ),
                                maxLines: _previewLines,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                              ),
                        if (_formattedReminderText(note) != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                note['reminderRepeat'] == null
                                    ? Icons.access_time
                                    : Icons.repeat,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  _formattedReminderText(note)!,
                                  style: TextStyle(
                                    color: dNoteEffectiveTextColor(
                                      context,
                                      _textColor,
                                    ),
                                    fontSize:
                                        (note['fontSize'] as num?)
                                            ?.toDouble() ??
                                        _globalFontSize,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if ((note['category'] ?? '').toString().isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.folder_outlined,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  note['category'],
                                  style: TextStyle(
                                    color: dNoteEffectiveTextColor(
                                      context,
                                      _textColor,
                                    ),
                                    fontSize:
                                        (note['fontSize'] as num?)
                                            ?.toDouble() ??
                                        _globalFontSize,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  textDirection: TextDirection.ltr,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (isFavorite)
                Positioned(
                  top: 8,
                  right: note['isLocked'] == true ? 36 : 8,
                  child: const Icon(Icons.star, color: Colors.amber, size: 18),
                ),
              if (note['isLocked'] == true)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.lock, color: Colors.grey, size: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Notun gelecekte planlanmış bir hatırlatıcısı var mı?
  bool _hasActiveReminder(Map<String, dynamic> note) {
    final raw = note['reminderDate']?.toString();
    if (raw == null || raw.isEmpty) return false;
    final dt = DateTime.tryParse(raw);
    return dt != null && dt.isAfter(DateTime.now());
  }

  // Hatırlatıcı tarihini "gg.aa.yyyy ss:dd" biçiminde döndürür (kartlarda ve
  // not içinde gösterilir); yoksa null döner.
  String? _formattedReminderText(Map<String, dynamic> note) {
    if (!_hasActiveReminder(note)) return null;
    final dt = DateTime.parse(note['reminderDate'].toString());
    return _formatDateTimeShortTr(dt);
  }
}

// ── Ek Dosya Kutucuğu ────────────────────────────────────────────────
// Not içeriğindeki resim/dosya eklerini gösteren ortak kutucuk widget'ı.
// Uzun basınca (onLongPress) silme ikonu belirir (showDelete); silme
// ikonuna basılırsa onRemove, kutucuğun kendisine basılırsa onOpen,
// silme modundayken başka bir yere dokunulursa onDismissDelete çağrılır.
class _AttachmentTile extends StatelessWidget {
  final double width;
  final double height;
  final Widget preview;
  final bool showDelete;
  final VoidCallback onOpen;
  final VoidCallback onRemove;
  final VoidCallback onLongPress;
  final VoidCallback onDismissDelete;

  const _AttachmentTile({
    required this.width,
    required this.height,
    required this.preview,
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
      onLongPress: onLongPress,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: preview,
            ),
            if (showDelete)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: onRemove,
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


// ── Ses Kaydı Sheet'i ────────────────────────────────────────────────
// "+" menüsünden "Ses Kaydı" seçilince açılır. Sheet açılır açılmaz kayda
// otomatik başlar; ortada geçen süreyi ve kırmızı nabız animasyonunu
// gösterir. "Durdur" kaydı bitirip dosya yolunu Navigator.pop ile geri
// döndürür (recordVoiceNote bu yolu attachments'a ekler); "İptal" kaydı
// atıp yarım kalan dosyayı silerek null döner.
class _VoiceRecorderSheet extends StatefulWidget {
  const _VoiceRecorderSheet();

  @override
  State<_VoiceRecorderSheet> createState() => _VoiceRecorderSheetState();
}

class _VoiceRecorderSheetState extends State<_VoiceRecorderSheet> {
  final AudioRecorder _recorder = AudioRecorder();
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _starting = true;
  bool _stopping = false;
  String? _path;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      final dir = await getTemporaryDirectory();
      final path = p.join(
        dir.path,
        'ses_kaydi_${DateTime.now().microsecondsSinceEpoch}.m4a',
      );
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );
      _path = path;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => _elapsed += const Duration(seconds: 1));
      });
    } catch (_) {
      if (mounted) Navigator.pop(context, null);
      return;
    }
    if (mounted) setState(() => _starting = false);
  }

  Future<void> _stop({required bool save}) async {
    if (_stopping) return;
    _stopping = true;
    _timer?.cancel();
    final path = await _recorder.stop();
    if (!mounted) return;
    if (save && path != null) {
      Navigator.pop(context, path);
    } else {
      if (path != null) {
        try {
          await File(path).delete();
        } catch (_) {}
      }
      Navigator.pop(context, null);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  String _formatElapsed(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, __) {
        if (!didPop) _stop(save: false);
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.85, end: 1.0),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                builder: (context, scale, child) => Transform.scale(
                  scale: _starting ? 1.0 : scale,
                  child: child,
                ),
                onEnd: () {},
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mic, color: Colors.white, size: 34),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _starting ? 'Hazırlanıyor…' : _formatElapsed(_elapsed),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: _starting ? null : () => _stop(save: false),
                    icon: const Icon(Icons.close, color: Colors.grey),
                    label: const Text(
                      'İptal',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 16),
                  FilledButton.icon(
                    onPressed: _starting ? null : () => _stop(save: true),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                    icon: const Icon(Icons.stop),
                    label: const Text('Durdur ve Ekle'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sesi Yazıya Çevir Sheet'i ────────────────────────────────────────────
// "Eylem Seç" panelinden "Sesi Yazıya Çevir" seçilince açılır. Sheet
// açılır açılmaz cihazın konuşma tanıma servisini dinlemeye başlar ve
// tanınan kelimeleri anlık olarak ekranda gösterir.
//
// Android'in konuşma tanıyıcısı, konuşmacı birkaç saniye sessiz kaldığında
// kendiliğinden durur (bu, işletim sisteminin bir davranışıdır ve
// speech_to_text paketi bunu değiştiremez). Kullanıcı elle "Durdur ve
// Ekle"/"İptal" demediği sürece, bu durum algılanınca dinleme otomatik
// olarak yeniden başlatılır; böylece uzun cümleler kesilmeden tüm
// konuşma tek bir metinde birikir.
//
// "Durdur ve Ekle" o ana kadar tanınan metni Navigator.pop ile geri
// döndürür (_showNoteActions'daki 'speech_to_text' işleyicisi bu metni
// onInsertText callback'i ile not içeriğine ekler); "İptal" null döner.
class _SpeechToTextSheet extends StatefulWidget {
  const _SpeechToTextSheet();

  @override
  State<_SpeechToTextSheet> createState() => _SpeechToTextSheetState();
}

class _SpeechToTextSheetState extends State<_SpeechToTextSheet> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _finalText = '';
  String _partialText = '';
  bool _starting = true;
  bool _stopping = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final micStatus = await Permission.microphone.request();
    if (!mounted) return;
    if (!micStatus.isGranted) {
      setState(() {
        _starting = false;
        _errorMessage = 'Mikrofon izni verilmedi.';
      });
      return;
    }
    bool available = false;
    try {
      available = await _speech.initialize(onStatus: _onStatus);
    } catch (_) {
      available = false;
    }
    if (!mounted) return;
    if (!available) {
      setState(() {
        _starting = false;
        _errorMessage = 'Bu cihazda ses tanıma özelliği kullanılamıyor.';
      });
      return;
    }
    setState(() => _starting = false);
    _listen();
  }

  // Tanıyıcı sessizlik sonrası kendiliğinden 'notListening'/'done' durumuna
  // geçtiğinde, kullanıcı elle durdurmadıysa dinlemeyi sessizce yeniden
  // başlatır. Geçici hata durumları (ör. kısa bir sessizlik zaman aşımı)
  // burada da aynı yoldan toparlanır; bu yüzden ayrı bir onError
  // dinleyicisi eklemiyoruz.
  void _onStatus(String status) {
    if (!mounted || _stopping || _starting) return;
    if (status == 'done' || status == 'notListening') {
      _listen();
    }
  }

  void _listen() {
    if (_stopping) return;
    _speech.listen(
      onResult: (result) {
        if (!mounted) return;
        setState(() {
          if (result.finalResult) {
            final piece = result.recognizedWords.trim();
            if (piece.isNotEmpty) {
              _finalText = _finalText.isEmpty
                  ? piece
                  : '$_finalText $piece';
            }
            _partialText = '';
          } else {
            _partialText = result.recognizedWords;
          }
        });
      },
      localeId: 'tr_TR',
      listenFor: const Duration(minutes: 5),
      pauseFor: const Duration(seconds: 10),
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: false,
        listenMode: stt.ListenMode.dictation,
      ),
    );
  }

  String get _combinedText => [
    _finalText,
    _partialText,
  ].map((s) => s.trim()).where((s) => s.isNotEmpty).join(' ');

  Future<void> _stop({required bool save}) async {
    if (_stopping) return;
    _stopping = true;
    try {
      await _speech.stop();
    } catch (_) {}
    if (!mounted) return;
    if (save) {
      final combined = _combinedText;
      Navigator.pop(context, combined.isEmpty ? null : combined);
    } else {
      Navigator.pop(context, null);
    }
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _combinedText;
    final hasError = _errorMessage != null;
    final isListening = !_starting && !hasError;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, __) {
        if (!didPop) _stop(save: false);
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.85, end: 1.0),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                builder: (context, scale, child) => Transform.scale(
                  scale: isListening ? scale : 1.0,
                  child: child,
                ),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: hasError ? Colors.grey : Colors.deepPurpleAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    hasError ? Icons.mic_off : Icons.mic,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage ??
                    (_starting ? 'Hazırlanıyor…' : 'Dinleniyor…'),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: hasError ? Colors.redAccent : null,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  minHeight: 90,
                  maxHeight: 180,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: dNoteSurfaceVariant(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Text(
                      displayText.isEmpty
                          ? 'Konuşmaya başlayın…'
                          : displayText,
                      style: TextStyle(
                        fontSize: 15,
                        color: displayText.isEmpty
                            ? Colors.grey
                            : dNoteTextColor(context),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () => _stop(save: false),
                    icon: const Icon(Icons.close, color: Colors.grey),
                    label: const Text(
                      'İptal',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 16),
                  FilledButton.icon(
                    onPressed: displayText.trim().isEmpty
                        ? null
                        : () => _stop(save: true),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text('Durdur ve Ekle'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Yüksek Sesle Oku Sheet'i ─────────────────────────────────────────────
// "Eylem Seç" panelinden "Yüksek Sesle Oku" seçilince açılır. Sheet açılır
// açılmaz notun başlığı + düz metin içeriği cihazın metinden sese (TTS)
// motoruyla okunmaya başlar. Oynat/Duraklat, Durdur ve okuma hızı (Yavaş/
// Normal/Hızlı) kontrolleri sunulur.
//
// Not: Android'in TTS motoru duraklatmayı native olarak desteklemez;
// flutter_tts paketi bunu, duraklatılan noktanın kelime indeksini izleyip
// bir sonraki speak() çağrısında kalan metinden devam ederek çözer — bu
// yüzden "Devam Et" de aynı tam metinle speak() çağırır.
enum _TtsPlaybackState { preparing, playing, paused, finished, error }

class _TextToSpeechSheet extends StatefulWidget {
  final String title;
  final String content;
  const _TextToSpeechSheet({required this.title, required this.content});

  @override
  State<_TextToSpeechSheet> createState() => _TextToSpeechSheetState();
}

class _TextToSpeechSheetState extends State<_TextToSpeechSheet> {
  final FlutterTts _tts = FlutterTts();
  _TtsPlaybackState _state = _TtsPlaybackState.preparing;
  // flutter_tts konuşma hızı 0.0-1.0 aralığında; 0.5 platformun normal
  // okuma hızına karşılık gelir.
  double _speechRate = 0.5;
  String? _errorMessage;

  String get _fullText => [
    widget.title.trim(),
    widget.content.trim(),
  ].where((s) => s.isNotEmpty).join('. ');

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (_fullText.trim().isEmpty) {
      setState(() {
        _state = _TtsPlaybackState.error;
        _errorMessage = 'Okunacak bir içerik yok.';
      });
      return;
    }
    _tts.setCompletionHandler(() {
      if (!mounted) return;
      setState(() => _state = _TtsPlaybackState.finished);
    });
    _tts.setCancelHandler(() {
      if (!mounted || _state == _TtsPlaybackState.paused) return;
      setState(() => _state = _TtsPlaybackState.finished);
    });
    _tts.setErrorHandler((msg) {
      if (!mounted) return;
      setState(() {
        _state = _TtsPlaybackState.error;
        _errorMessage = 'Okuma sırasında bir hata oluştu.';
      });
    });
    try {
      await _tts.setLanguage('tr-TR');
      await _tts.setSpeechRate(_speechRate);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
    } catch (_) {
      // Türkçe dil paketi kurulu değilse cihaz varsayılan dille okumaya
      // devam eder; bu durumda ayrıca hata gösterilmez.
    }
    _play();
  }

  Future<void> _play() async {
    if (!mounted) return;
    setState(() => _state = _TtsPlaybackState.playing);
    try {
      final result = await _tts.speak(_fullText);
      if (result != 1 && mounted) {
        setState(() {
          _state = _TtsPlaybackState.error;
          _errorMessage = 'Bu cihazda sesli okuma özelliği kullanılamıyor.';
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _state = _TtsPlaybackState.error;
        _errorMessage = 'Bu cihazda sesli okuma özelliği kullanılamıyor.';
      });
    }
  }

  Future<void> _pause() async {
    setState(() => _state = _TtsPlaybackState.paused);
    try {
      await _tts.pause();
    } catch (_) {}
  }

  Future<void> _resume() async {
    setState(() => _state = _TtsPlaybackState.playing);
    try {
      await _tts.speak(_fullText);
    } catch (_) {}
  }

  Future<void> _setRate(double rate) async {
    if (_speechRate == rate) return;
    setState(() => _speechRate = rate);
    try {
      await _tts.setSpeechRate(rate);
    } catch (_) {}
  }

  Future<void> _close() async {
    try {
      await _tts.stop();
    } catch (_) {}
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Widget _rateChip(String label, double rate) {
    final selected = _speechRate == rate;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => _setRate(rate),
    );
  }

  Widget _buildButtons() {
    if (_state == _TtsPlaybackState.error) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton(onPressed: _close, child: const Text('Kapat')),
      );
    }
    if (_state == _TtsPlaybackState.finished) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _play,
              icon: const Icon(Icons.replay),
              label: const Text('Tekrar Oku'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              onPressed: _close,
              icon: const Icon(Icons.check),
              label: const Text('Kapat'),
            ),
          ),
        ],
      );
    }
    if (_state == _TtsPlaybackState.preparing) {
      return const SizedBox(height: 48);
    }
    final isPlaying = _state == _TtsPlaybackState.playing;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isPlaying ? _pause : _resume,
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            label: Text(isPlaying ? 'Duraklat' : 'Devam Et'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: _close,
            icon: const Icon(Icons.stop),
            label: const Text('Durdur'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _state == _TtsPlaybackState.error;
    final isPlaying = _state == _TtsPlaybackState.playing;
    final isPaused = _state == _TtsPlaybackState.paused;
    final isPreparing = _state == _TtsPlaybackState.preparing;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, __) {
        if (!didPop) _close();
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.85, end: 1.0),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                builder: (context, scale, child) => Transform.scale(
                  scale: isPlaying ? scale : 1.0,
                  child: child,
                ),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: hasError ? Colors.grey : Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    hasError ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage ??
                    (isPreparing
                        ? 'Hazırlanıyor…'
                        : isPaused
                        ? 'Duraklatıldı'
                        : _state == _TtsPlaybackState.finished
                        ? 'Okuma tamamlandı'
                        : 'Okunuyor…'),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: hasError ? Colors.redAccent : null,
                ),
              ),
              if (!hasError && !isPreparing) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _rateChip('Yavaş', 0.35),
                    const SizedBox(width: 8),
                    _rateChip('Normal', 0.5),
                    const SizedBox(width: 8),
                    _rateChip('Hızlı', 0.75),
                  ],
                ),
              ],
              const SizedBox(height: 18),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Ses Kaydı Oynatıcı Sheet'i ──────────────────────────────────────────
// Ek listesinde bir ses kaydına dokununca açılır. Uygulama içinde (harici
// bir oynatıcıya çıkmadan) oynat/duraklat + ilerleme çubuğu sunar.
class _VoicePlayerSheet extends StatefulWidget {
  final String path;
  final String title;
  const _VoicePlayerSheet({required this.path, required this.title});

  @override
  State<_VoicePlayerSheet> createState() => _VoicePlayerSheetState();
}

class _VoicePlayerSheetState extends State<_VoicePlayerSheet> {
  final AudioPlayer _player = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  StreamSubscription<Duration>? _durSub;
  StreamSubscription<Duration>? _posSub;
  StreamSubscription<PlayerState>? _stateSub;

  @override
  void initState() {
    super.initState();
    _durSub = _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    _posSub = _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
    _stateSub = _player.onPlayerStateChanged.listen((s) {
      if (mounted) setState(() => _isPlaying = s == PlayerState.playing);
    });
    _player.setSourceDeviceFile(widget.path);
  }

  @override
  void dispose() {
    _durSub?.cancel();
    _posSub?.cancel();
    _stateSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.resume();
    }
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final total = _duration.inMilliseconds > 0
        ? _duration.inMilliseconds.toDouble()
        : 1.0;
    final current = _position.inMilliseconds
        .clamp(0, total.toInt())
        .toDouble();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.mic, color: Colors.deepPurpleAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: current,
              max: total,
              activeColor: Colors.amber,
              onChanged: (v) {
                setState(() => _position = Duration(milliseconds: v.toInt()));
              },
              onChangeEnd: (v) {
                _player.seek(Duration(milliseconds: v.toInt()));
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  _formatDuration(_duration),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            IconButton(
              iconSize: 56,
              icon: Icon(
                _isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                color: Colors.amber,
              ),
              onPressed: _togglePlay,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Video Oynatıcı Diyaloğu ──────────────────────────────────────────────
// Ek listesinde bir videoya dokununca açılır: tam ekran, siyah zeminde
// oynat/duraklat (video üzerine dokunarak) ve ilerleme çubuğu sunar.
class _VideoPlayerDialog extends StatefulWidget {
  final String path;
  const _VideoPlayerDialog({required this.path});

  @override
  State<_VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<_VideoPlayerDialog> {
  late final VideoPlayerController _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _ready = true);
        _controller.play();
      });
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: const EdgeInsets.all(8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_ready)
            GestureDetector(
              onTap: _togglePlay,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            )
          else
            const SizedBox(
              height: 120,
              child: Center(
                child: CircularProgressIndicator(color: Colors.amber),
              ),
            ),
          if (_ready && !_controller.value.isPlaying)
            IconButton(
              iconSize: 64,
              icon: const Icon(
                Icons.play_circle_fill,
                color: Colors.white70,
              ),
              onPressed: _togglePlay,
            ),
          if (_ready)
            Positioned(
              left: 12,
              right: 12,
              bottom: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.amber,
                      bufferedColor: Colors.white30,
                      backgroundColor: Colors.white12,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_controller.value.position),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        _formatDuration(_controller.value.duration),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
