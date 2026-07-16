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

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    DBHelper.instance.attachmentsDir().then((d) {
      if (mounted) setState(() => _attachmentsDirPath = d.path);
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

  String _getFormattedDate([DateTime? date]) {
    final now = date ?? DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$day.$month.${now.year} $hour:$minute';
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
      return 'Favoriler';
    } else if (category == '__locked__') {
      return 'Kilitli';
    } else if (category == '__archive__') {
      return 'Arşiv';
    } else if (category == '__trash__') {
      return 'Çöp Kutusu';
    } else if (category == '__reminders__') {
      return 'Hatırlatmalar';
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
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: dNoteCardColor(ctx),
                        title: const Text(
                          'Parola Gerekiyor',
                          style: TextStyle(color: Colors.amber),
                        ),
                        content: Text(
                          'Kategoriyi kilitleyebilmek için önce Ayarlar > Not Şifresi bölümünden bir parola belirlemeniz gerekiyor.',
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
    if (origAttachments is List && origAttachments.isNotEmpty) {
      // Ekli dosyaların kendisi de diskte fiziksel olarak kopyalanır; aksi
      // halde iki not aynı dosyayı paylaşır ve biri kalıcı silinince
      // diğerinin eki de kaybolur.
      duplicate['attachments'] = await DBHelper.instance
          .duplicateAttachmentFiles(
            List<Map<String, dynamic>>.from(
              origAttachments.map((e) => Map<String, dynamic>.from(e as Map)),
            ),
          );
    }

    setState(() => _notes.insert(index + 1, duplicate));
    _saveData();
    _rescheduleNoteReminder(duplicate);
    _showInfoBar('Kopya oluşturuldu');
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
    _showInfoBar('Kopyalandı');
  }

  void _showInfoBar(String message) {
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
              children: [
                const Icon(Icons.check_circle, color: Colors.amber, size: 18),
                const SizedBox(width: 10),
                Text(message, style: TextStyle(color: dNoteTextColor(context))),
              ],
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_snackOverlay!);
    _snackTimer = Timer(const Duration(seconds: 2), _hideDeletedBar);
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
    ).push(MaterialPageRoute(builder: (_) => _SettingsPage(state: this)));
  }

  // Yeni: "Kilitli" klasörüne girmeden önce parola sorar.
  Future<void> _openLockedFolder() async {
    Navigator.pop(context); // drawer'ı önce kapat

    if (!_notePasswordEnabled) {
      // Parola kapalıyken kilitli klasöre girişte parola sorulmaz,
      // ama kullanıcı parola belirlemediği için uyarılır.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Önce Ayarlar > Not Şifresi ile parola belirleyin.'),
          backgroundColor: Colors.red,
        ),
      );
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

  void _showAddMenu() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          24,
          16,
          MediaQuery.of(context).padding.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.text_snippet_outlined,
                color: Colors.amber,
              ),
              title: const Text(
                'Metin Notu',
              ),
              onTap: () {
                Navigator.pop(context);
                _showNoteDialog(type: 'text');
              },
            ),
            ListTile(
              leading: const Icon(Icons.checklist, color: Colors.amber),
              title: const Text(
                'Kontrol Listesi',
              ),
              onTap: () {
                Navigator.pop(context);
                _showNoteDialog(type: 'checklist');
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_outlined, color: Colors.amber),
              title: const Text(
                'Kategori',
              ),
              onTap: () {
                Navigator.pop(context);
                _showAddCategoryDialog();
              },
            ),
          ],
        ),
      ),
    );
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
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: dNoteTextColor(context),
                  fontSize: 14,
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
  }) {
    final hasValidNote = noteIndex >= 0 && noteIndex < _notes.length;
    if (!hasValidNote && onReminderChanged == null) return;
    final isFavorite = hasValidNote && _notes[noteIndex]['isFavorite'] == true;
    final isArchived = hasValidNote && _notes[noteIndex]['isArchived'] == true;
    final isLocked = hasValidNote && _notes[noteIndex]['isLocked'] == true;

    final actions = [
      if (onReminderChanged != null)
        {
          'icon': editorReminder != null
              ? Icons.notifications_active
              : Icons.notifications_none,
          'label': editorReminder != null
              ? 'Hatırlatıcıyı Düzenle'
              : 'Hatırlatıcı',
          'color': Colors.amber,
          'key': 'reminder',
        },
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
        'icon': Icons.label_outline,
        'label': 'Sınıflandır',
        'color': Colors.purple,
        'key': 'classify',
      },
      {
        'icon': Icons.delete_outline,
        'label': 'Sil',
        'color': Colors.red,
        'key': 'delete',
      },
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
                        if (onReminderChanged == null) return;
                        final now = DateTime.now();
                        final initialDate =
                            editorReminder ?? now.add(const Duration(hours: 1));
                        if (editorReminder != null) {
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
                                      color: Colors.amber,
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
                            onReminderChanged(null, null);
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
                          initialRepeat: editorReminderRepeat,
                        );
                        if (result == null) return;
                        onReminderChanged(result.dateTime, result.repeat);
                        return;
                      }

                      if (noteIndex < 0) return;

                      if (key == 'favorite') {
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
                      } else if (key == 'text_size') {
                        _showTextSizeSlider(noteIndex);
                      } else if (key == 'lock') {
                        final currentlyLocked =
                            _notes[noteIndex]['isLocked'] == true;
                        if (currentlyLocked) {
                          setState(() => _notes[noteIndex]['isLocked'] = false);
                          _saveData();
                          _showInfoBar('Kilidi kaldırıldı');
                        } else {
                          if (!_notePasswordEnabled) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Önce Ayarlar > Not Şifresi ile parola belirleyin.',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          setState(() => _notes[noteIndex]['isLocked'] = true);
                          _saveData();
                          _showInfoBar('Not kilitlendi');
                        }
                      } else if (key == 'details') {
                        _showNoteDetails(noteIndex);
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

  void _showNoteDialog({int? index, String type = 'text'}) {
    String noteDate = "";
    String noteType = type;
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

    // Blok listesi değiştiğinde (ekleme/silme/birleştirme) controller ve
    // focus node'ları tamamen yeniden kurar. Metin bloğu olmayan (ek)
    // konumlar için null tutulur.
    void rebuildBlockControllers() {
      for (final c in blockControllers) {
        c?.dispose();
      }
      for (final f in blockFocusNodes) {
        f?.dispose();
      }
      blockControllers = [];
      blockFocusNodes = [];
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
        } else {
          blockControllers.add(null);
          blockFocusNodes.add(null);
        }
      }
    }

    void syncControllersAndFocusNodes() {
      // controller ve focusnode sayısını checkItems ile eşitle
      while (checkControllers.length < checkItems.length) {
        final idx = checkControllers.length;
        checkControllers.add(
          TextEditingController(text: checkItems[idx]['text'] as String? ?? ''),
        );
        checkFocusNodes.add(FocusNode());
      }
      while (checkControllers.length > checkItems.length) {
        checkControllers.removeLast().dispose();
        checkFocusNodes.removeLast().dispose();
      }
    }

    if (index != null) {
      _titleController.text = _notes[index]['title'] ?? '';
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
      blocks = [
        {'type': 'text', 'text': ''},
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
          return StatefulBuilder(
            builder: (context, setModalState) {
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
                  newOnes.add({
                    'id': uniqueId,
                    'fileName': name,
                    'storedName': storedName,
                    'sizeBytes': sizeBytes,
                    'isImage': isImage,
                  });
                }
                if (newOnes.isNotEmpty) {
                  final newIds = newOnes
                      .map((e) => e['id'].toString())
                      .toList();
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

              // Kontrol listesi (checklist) notlarında, ekler ayrı bir
              // liste halinde altta gösterilir; index'e göre kaldırılır.
              void removeAttachment(int i) {
                final att = attachments[i];
                final storedName = att['storedName']?.toString();
                if (storedName != null) {
                  DBHelper.instance.deleteAttachmentFile(storedName);
                }
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Not kaydedildi ✓',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: const Color(0xFF3D3D3D),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.04,
                          left: 60,
                          right: 60,
                        ),
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
                child: Scaffold(
                  backgroundColor: Theme.of(context).cardColor,
                  resizeToAvoidBottomInset: true,
                  appBar: AppBar(
                    backgroundColor: dNoteHeaderColor(context),
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).colorScheme.onSurface,
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Not kaydedildi ✓',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: const Color(0xFF3D3D3D),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.04,
                                left: 60,
                                right: 60,
                              ),
                            ),
                          );
                        }
                        Navigator.pop(context);
                      },
                    ),
                    actions: const [],
                  ),
                  bottomNavigationBar: SafeArea(
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
                              top: BorderSide(color: barColor, width: 3),
                            ),
                          ),
                          child: Row(
                            children: [
                              PopupMenuButton<String>(
                                icon: Icon(
                                  Icons.add,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                onSelected: (value) {
                                  if (value == 'file') {
                                    pickAttachments();
                                  } else if (value == 'image') {
                                    pickImagesFromGallery();
                                  } else if (value == 'camera') {
                                    pickImageFromCamera();
                                  }
                                },
                                itemBuilder: (_) => [
                                  const PopupMenuItem(
                                    value: 'image',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.image_outlined,
                                          color: Colors.blueAccent,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Görsel Ekle',
                                        ),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'camera',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.tealAccent,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Kamera',
                                        ),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'file',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.attach_file,
                                          color: Colors.orange,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Dosya Ekle',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                                                noteDate.isNotEmpty
                                                    ? noteDate
                                                    : _getFormattedDate(
                                                        noteAssignedDate,
                                                      ),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: barColor,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
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
                                  Icons.more_vert,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                onPressed: () => _showNoteActions(
                                  context,
                                  index ?? -1,
                                  false,
                                  editorReminder: noteReminder,
                                  editorReminderRepeat: noteReminderRepeat,
                                  onReminderChanged: (reminder, repeat) {
                                    setModalState(() {
                                      noteReminder = reminder;
                                      noteReminderRepeat = repeat;
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
                  body: GestureDetector(
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
                          decoration: InputDecoration(
                            hintText: 'Başlık',
                            hintStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: dNoteBorderColor(context),
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber),
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
                          ...List.generate(blocks.length, (i) {
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
                            return TextField(
                              key: ValueKey('blk_text_$i'),
                              selectionWidthStyle: ui.BoxWidthStyle.tight,
                              contextMenuBuilder: buildCustomContextMenu,
                              selectionHeightStyle: ui.BoxHeightStyle.max,
                              controller: blockControllers[i],
                              focusNode: blockFocusNodes[i],
                              autofocus: i == 0 && index == null,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                hintText: i == 0
                                    ? 'Notunuzu buraya yazın...'
                                    : null,
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                color: dNoteEffectiveTextColor(context, _textColor),
                                fontSize: index != null
                                    ? ((_notes[index!]['fontSize'] as num?)
                                              ?.toDouble() ??
                                          _globalFontSize)
                                    : _globalFontSize,
                                height: 1.6,
                              ),
                              onChanged: (val) => block['text'] = val,
                              onTap: () => focusedBlockIndex = i,
                            );
                          })
                        else ...[
                          ...checkItems.asMap().entries.map((entry) {
                            final i = entry.key;
                            final item = entry.value;
                            return Row(
                              children: [
                                Checkbox(
                                  value: item['checked'] as bool,
                                  activeColor: Colors.amber,
                                  onChanged: (val) {
                                    setModalState(() {
                                      checkItems[i]['checked'] = val ?? false;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: TextField(
                                    selectionWidthStyle: ui.BoxWidthStyle.tight,
                                    controller: checkControllers[i],
                                    focusNode: checkFocusNodes[i],
                                    autofocus: newlyAddedIndex == i,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    contextMenuBuilder: buildCustomContextMenu,
                                    selectionHeightStyle: ui.BoxHeightStyle.max,
                                    style: TextStyle(
                                      color: dNoteEffectiveTextColor(context, _textColor),
                                      fontSize: 16,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Madde...',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (val) {
                                      checkItems[i]['text'] = val;
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
                                    setModalState(() {
                                      checkItems.removeAt(i);
                                      checkControllers.removeAt(i).dispose();
                                      checkFocusNodes.removeAt(i).dispose();
                                      newlyAddedIndex = null;
                                    });
                                  },
                                ),
                              ],
                            );
                          }),
                          TextButton.icon(
                            onPressed: () {
                              setModalState(() {
                                checkItems.add({'text': '', 'checked': false});
                                checkControllers.add(TextEditingController());
                                checkFocusNodes.add(FocusNode());
                                newlyAddedIndex = checkItems.length - 1;
                              });
                              // Kısa gecikmeyle focus ver (widget build olduktan sonra)
                              Future.microtask(() {
                                checkFocusNodes.last.requestFocus();
                              });
                            },
                            icon: const Icon(Icons.add, color: Colors.amber),
                            label: const Text(
                              'Madde Ekle',
                              style: TextStyle(color: Colors.amber),
                            ),
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
                                      : Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons
                                                    .insert_drive_file_outlined,
                                                color: Colors.amber,
                                                size: 28,
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                (att['fileName'] ?? '')
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
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
                        if (noteReminder != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
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
                                        ? _formatDateTimeTr(noteReminder!)
                                        : '${_formatDateTimeTr(noteReminder!)} · ${_reminderRepeatLabelTr(noteReminderRepeat)}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Builder(
                          builder: (context) {
                            final hasCategory =
                                noteCategory != null &&
                                noteCategory!.isNotEmpty;
                            if (!hasCategory) return const SizedBox.shrink();
                            return OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    dNoteEffectiveTextColor(context, _textColor),
                                side: BorderSide(
                                  color: dNoteBorderColor(context),
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                              ),
                              child: Text(noteCategory!),
                              onPressed: () {
                                if (index != null) {
                                  _showClassifyDialog(
                                    index!,
                                    onChanged: (cat) {
                                      setModalState(() {
                                        noteCategory = cat;
                                      });
                                    },
                                  );
                                } else {
                                  _saveNoteIfValid(index, noteType, checkItems, attachments, blocks, noteReminder, noteAssignedDate, noteReminderRepeat);
                                  if (_notes.isNotEmpty) {
                                    final newIndex = _notes.length - 1;
                                    _showClassifyDialog(
                                      newIndex,
                                      onChanged: (cat) {
                                        setModalState(() {
                                          noteCategory = cat;
                                          index = newIndex;
                                        });
                                      },
                                    );
                                  }
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
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
    );
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
          title: _isSearching
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
          actions: [
            IconButton(
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
                        'Favoriler',
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
                  ListTile(
                    leading: const Icon(
                      Icons.calendar_month,
                      color: Colors.amber,
                    ),
                    title: const Text('Takvim'),
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
                  Container(
                    color: _activeCategory == '__reminders__'
                        ? dNoteHighlight(context)
                        : Colors.transparent,
                    child: ListTile(
                      leading: const Icon(
                        Icons.notifications_active_outlined,
                        color: Colors.amber,
                      ),
                      title: const Text('Hatırlatmalar'),
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
                        'Çöp Kutusu',
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
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text(
                                    'Parola Gerekiyor',
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                  content: const Text(
                                    'Kilitli kategoriye girebilmek için önce Ayarlar > Not Şifresi bölümünden bir parola belirlemeniz gerekiyor.',
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
                      final noteCardColor = _colorfulNotes
                          ? _categoryPalette[(originalIndex < 0
                                        ? 0
                                        : originalIndex) %
                                    _categoryPalette.length]
                                .withValues(alpha: 0.75)
                          : (dNoteIsDark(context)
                                ? const Color(0xFF2D2D2D)
                                : Theme.of(context).cardColor);
                      final fontScale = _previewFontScale(note);
                      final previewImage = _firstImageAttachment(note);

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
                            : () => _showNoteActions(
                                context,
                                originalIndex,
                                false,
                              ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Card(
                            margin: EdgeInsets.zero,
                            color: noteCardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
                                  : () => _openNoteWithPasswordCheck(
                                      originalIndex,
                                    ),
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (previewImage != null &&
                                        _attachmentsDirPath != null) ...[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: SizedBox(
                                          width: 56,
                                          height: 56,
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
                                      ),
                                      const SizedBox(width: 12),
                                    ],
                                    Expanded(
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
                                    if (isChecklist)
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
                                    else
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              ContentBlocks.plainText(
                                                note['content'] as String?,
                                              ),
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
                                        ],
                                      ),
                                    if ((note['category'] ?? '')
                                        .toString()
                                        .isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          note['category'],
                                          style: TextStyle(
                                            color:
                                                (dNoteEffectiveTextColor(context, _textColor))
                                                    .withValues(alpha: 0.7),
                                            fontSize:
                                                (note['fontSize'] as num?)
                                                    ?.toDouble() ??
                                                _globalFontSize,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                    if (_formattedReminderText(note) !=
                                        null) ...[
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            color: Colors.grey,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              _formattedReminderText(note)!,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontStyle: FontStyle.italic,
                                                fontSize:
                                                    ((note['fontSize'] as num?)
                                                                ?.toDouble() ??
                                                            _globalFontSize) -
                                                    3,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
          onPressed: _showAddMenu,
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
    double height = 32.0; // kartın iç padding'i: 16 üst + 16 alt

    if (_firstImageAttachment(note) != null) {
      height += 120.0; // üstteki görsel önizleme yüksekliği
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
    final gridCardColor = _colorfulNotes
        ? _categoryPalette[(originalIndex < 0 ? 0 : originalIndex) %
                  _categoryPalette.length]
              .withValues(alpha: 0.75)
        : (dNoteIsDark(context)
              ? const Color(0xFF2D2D2D)
              : Theme.of(context).cardColor);
    final fontScale = _previewFontScale(note);
    final previewImage = _firstImageAttachment(note);

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
          : () => _showNoteActions(context, originalIndex, false),
      child: Card(
        margin: EdgeInsets.zero,
        color: gridCardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              : () => _openNoteWithPasswordCheck(originalIndex),
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (previewImage != null && _attachmentsDirPath != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: SizedBox(
                        height: 120,
                        width: double.infinity,
                        child: Image.file(
                          File(
                            p.join(
                              _attachmentsDirPath!,
                              previewImage['storedName'].toString(),
                            ),
                          ),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: dNoteSurfaceVariant(context),
                            child: const Icon(
                              Icons.broken_image_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ),
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
                        if ((note['category'] ?? '').toString().isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            note['category'],
                            style: TextStyle(
                              color: (dNoteEffectiveTextColor(context, _textColor))
                                  .withValues(alpha: 0.7),
                              fontSize:
                                  (note['fontSize'] as num?)?.toDouble() ??
                                  _globalFontSize,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                        if (_formattedReminderText(note) != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  _formattedReminderText(note)!,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                    fontSize:
                                        ((note['fontSize'] as num?)
                                                    ?.toDouble() ??
                                                _globalFontSize) -
                                        3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
    return _formatDateTimeTr(dt);
  }
}

