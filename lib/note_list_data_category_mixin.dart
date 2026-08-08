part of 'main.dart';

// ignore_for_file: unused_element

mixin NoteListDataCategoryMixin on State<NoteListScreen> {
  // ---- Diğer mixin'lerde tanımlı, burada kullanılan üyeler ----
  String get _activeCategory;
  set _activeCategory(String value);
  List<String> get _categories;
  set _categories(List<String> value);
  Map<String, String> get _categoryColors;
  set _categoryColors(Map<String, String> value);
  Map<String, String?> get _categoryParents;
  set _categoryParents(Map<String, String?> value);
  Future<bool> _checkPasswordPrompt();
  Set<String> get _collapsedCategories;
  set _collapsedCategories(Set<String> value);
  bool get _colorfulNotes;
  set _colorfulNotes(bool value);
  List<Map<String, dynamic>> get _deletedNotes;
  set _deletedNotes(List<Map<String, dynamic>> value);
  String get _fontFamily;
  set _fontFamily(String value);
  Color _getCategoryColor(String? category);
  double get _globalFontSize;
  set _globalFontSize(double value);
  bool _hasActiveReminder(Map<String, dynamic> note);
  bool get _isAscending;
  set _isAscending(bool value);
  bool get _isListView;
  set _isListView(bool value);
  Set<String> get _lockedCategories;
  set _lockedCategories(Set<String> value);
  String get _notePassword;
  set _notePassword(String value);
  bool get _notePasswordEnabled;
  set _notePasswordEnabled(bool value);
  List<Map<String, dynamic>> get _notes;
  set _notes(List<Map<String, dynamic>> value);
  void _openNoteByIdFromNotification(String noteId);
  String get _passwordHintAnswer;
  set _passwordHintAnswer(String value);
  String get _passwordHintQuestion;
  set _passwordHintQuestion(String value);
  int get _previewLines;
  set _previewLines(int value);
  void _showAddCategoryDialog({ void Function(String)? onAdded, String? editingCategory, String? parentCategory, });
  Future<bool> _showCreatePasswordDialog();
  void _showInfoBar( String message, { IconData icon = Icons.check_circle, String? actionLabel, VoidCallback? onAction, });
  String get _sortCriteria;
  set _sortCriteria(String value);
  Color? get _textColor;
  set _textColor(Color? value);
  ThemeMode get _themeMode;
  set _themeMode(ThemeMode value);
  double get _widgetBgOpacity;
  set _widgetBgOpacity(double value);
  bool get _widgetDark;
  set _widgetDark(bool value);
  double get _widgetFontSize;
  set _widgetFontSize(double value);


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
      _categoryParents = Map<String, String?>.from(
        catData['parents'] as Map? ?? {},
      );
      // Kategori çekmecesindeki daraltılmış (alt klasörleri gizli)
      // kategorilerin listesi. Önceden hiç kaydedilmiyordu; bu yüzden
      // kullanıcının daralt/genişlet tercihi uygulama kapatılıp açılınca
      // sıfırlanıyordu.
      final collapsedRaw = settings['collapsed_categories'] ?? '';
      _collapsedCategories = collapsedRaw.isEmpty
          ? <String>{}
          : collapsedRaw.split('\u0001').toSet();

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

    // Kayıtlı widget görünüm ayarlarını (yazı boyutu, saydamlık, koyu/açık
    // tema) native tarafa da yansıt; böylece ör. bir yedekten geri
    // yükledikten sonra widget, uygulamayı hiç açmadan eski (varsayılan)
    // görünümde kalmaz.
    unawaited(NoteWidgetService.instance.syncAppearanceSettings(
      fontSize: _widgetFontSize,
      bgOpacity: _widgetBgOpacity,
      dark: _widgetDark,
    ));

    // DÜZELTME (2026-08-08): syncFromNotes eskiden SADECE _saveData()
    // içinde (yani bir not düzenlenip kaydedildiğinde) tetikleniyordu.
    // Bu yüzden widget önizleme mantığı (ör. checklist/hesap tablosu
    // biçimlendirmesi) güncellendiğinde, ÖNCEDEN oluşturulmuş ve o
    // tarihten sonra hiç düzenlenmemiş notlar widget'ta hâlâ eski
    // (bayat) SharedPreferences verisini gösteriyordu — kullanıcı notu
    // tekrar açıp kaydetmeden bu düzelmiyordu. Uygulama her açıldığında
    // da senkronize ederek widget'ın her zaman güncel not listesini ve
    // güncel önizleme mantığını yansıtması sağlanıyor.
    unawaited(NoteWidgetService.instance.syncFromNotes(_notes));

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

    // Uygulama tamamen kapalıyken bir DNote bildirimine (hatırlatıcı veya
    // bildirim paneline sabitlenmiş not) dokunularak açılmışsa, o notu
    // doğrudan aç.
    final launchNoteId = await ReminderService.instance.getLaunchNoteId();
    if (launchNoteId != null) {
      _openNoteByIdFromNotification(launchNoteId);
    }
  }

  Future<void> _saveData() async {
    final db = DBHelper.instance;
    await db.replaceNotes(_notes);
    await db.replaceDeletedNotes(_deletedNotes);
    await db.replaceCategories(
      _categories,
      _categoryColors,
      _lockedCategories,
      _categoryParents,
    );

    await db.setSetting('_initialized', 'true');
    await db.setSetting('sort_criteria', _sortCriteria);
    await db.setSetting('is_ascending', _isAscending.toString());
    await db.setSetting('is_list_view', _isListView.toString());
    await db.setSetting('active_category', _activeCategory);
    // Kategori çekmecesindeki daralt/genişlet durumu; '\u0001' karakteri
    // kategori adlarında geçmesi son derece olası olmadığı için ayraç
    // olarak kullanılıyor.
    await db.setSetting(
      'collapsed_categories',
      _collapsedCategories.join('\u0001'),
    );

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

    // Ana ekran widget'ını her kayıtta güncel not listesiyle senkronize et.
    // Native taraf (Aşama 2) henüz kurulmadıysa NoteWidgetService bu
    // çağrıyı içeride sessizce yutar; burada ekstra try/catch gerekmez.
    unawaited(NoteWidgetService.instance.syncFromNotes(_notes));
  }

  // Kısa Türkçe tarih biçimi: "Tem 20, 21:17" — alt bardaki ve not
  // altındaki (hatırlatıcı) tarih gösterimlerinde kullanılır.
  final List<String> _shortMonthNamesTr = [
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

  // Liste görünümünde not kartlarının üstünde gösterilen tarih grubu
  // başlıkları (iOS Notlar uygulamasındaki gibi): "Bugün", "Dün",
  // "Son 7 Gün", "Son 30 Gün", ardından ay adı (aynı yıl içinde) veya
  // "Ay Yıl" (önceki yıllar için).
  final List<String> _fullMonthNamesTr = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
  ];

  String _dateGroupLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff <= 0) return 'Bugün';
    if (diff == 1) return 'Dün';
    if (diff < 7) return 'Son 7 Gün';
    if (diff < 30) return 'Son 30 Gün';
    if (date.year == now.year) return _fullMonthNamesTr[date.month - 1];
    return '${_fullMonthNamesTr[date.month - 1]} ${date.year}';
  }

  // Not listesini, ekranda gösterildiği sırayla, aralarına tarih grubu
  // başlıkları (String) serpiştirilmiş şekilde döndürür. Ardışık notlar
  // aynı gruba düşüyorsa başlık yalnızca bir kez eklenir; bu yüzden bu
  // yalnızca notlar tarihe göre sıralıyken (Son Düzenleme / Oluşturulma)
  // anlamlıdır.
  List<dynamic> _buildDateGroupedItems(List<Map<String, dynamic>> notes) {
    final List<dynamic> result = [];
    String? lastLabel;
    for (final note in notes) {
      final rawDate =
          (note['modifiedDate'] ?? note['createdDate'] ?? '').toString();
      final date = DateTime.tryParse(rawDate);
      if (date != null) {
        final label = _dateGroupLabel(date);
        if (label != lastLabel) {
          result.add(label);
          lastLabel = label;
        }
      }
      result.add(note);
    }
    return result;
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

  // Bir notun klasör etiketinde gösterilecek metni oluşturur. Kategori bir
  // alt klasörse (yani _categoryParents içinde bir üst klasörü varsa)
  // "Üst klasör / Alt klasör" biçiminde döndürülür; değilse sadece klasör
  // adının kendisi döndürülür.
  String _folderTagLabel(String category) {
    final parent = _categoryParents[category];
    if (parent != null && parent.isNotEmpty) {
      return '$parent / $category';
    }
    return category;
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

  // Bir kategorinin (klasör/alt klasör) kilitli sayılıp sayılmayacağını
  // belirler. Kategori doğrudan kilitliyse ya da bir alt klasörse ve ait
  // olduğu üst klasör kilitliyse true döner; yani üst klasör kilitlendiğinde
  // altındaki tüm alt klasörler de otomatik olarak kilitlenmiş sayılır.
  bool _isCategoryEffectivelyLocked(String category) {
    if (_lockedCategories.contains(category)) return true;
    final parent = _categoryParents[category];
    if (parent != null && _lockedCategories.contains(parent)) return true;
    return false;
  }

  // Çekmecedeki (drawer) tek bir kategori/alt klasör satırını oluşturur.
  // [isSubfolder] true verilirse satır girintili ve biraz daha küçük
  // gösterilir (üst klasörünün altında bir alt klasör olduğunu belirtmek
  // için).
  Widget _buildCategoryDrawerTile(String cat, {bool isSubfolder = false}) {
    final catColor = _getCategoryColor(cat);
    final isCatLocked = _isCategoryEffectivelyLocked(cat);
    return Container(
      color: _activeCategory == cat
          ? dNoteHighlight(context)
          : Colors.transparent,
      child: ListTile(
        contentPadding: EdgeInsets.only(
          left: isSubfolder ? 40 : 16,
          right: 16,
        ),
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.folder_outlined,
              color: catColor,
              size: isSubfolder ? 20 : 24,
            ),
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
            fontSize: isSubfolder ? 14 : null,
            color: _activeCategory == cat
                ? catColor
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        trailing: Text(
          _getCountForCategory(cat).toString(),
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
        onTap: () async {
          if (isCatLocked) {
            Navigator.pop(context); // drawer'ı kapat
            await Future.delayed(const Duration(milliseconds: 350));
            if (!mounted) return;
            if (!_notePasswordEnabled) {
              // Parola belirlenmemişse artık "Parola Gerekiyor" uyarı
              // dialogu yerine doğrudan "Yeni Parola Oluştur" ekranı
              // açılır; parola belirlenince kullanıcı doğrudan kategoriye
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
                  content: const Text('Girdiğiniz parola yanlış.'),
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
  }

  void _deleteCategory(String category) {
    setState(() {
      // Silinen kategori bir üst klasörse, altındaki alt klasörler de
      // (sahipsiz kalmasınlar diye) birlikte silinir.
      final childCategories = _categoryParents.entries
          .where((e) => e.value == category)
          .map((e) => e.key)
          .toList();
      final allToRemove = {category, ...childCategories};

      for (final cat in allToRemove) {
        _categories.remove(cat);
        _categoryColors.remove(cat);
        _lockedCategories.remove(cat);
        _categoryParents.remove(cat);
        _collapsedCategories.remove(cat);
      }
      for (final note in _notes) {
        if (allToRemove.contains(note['category'])) {
          note['category'] = null;
        }
      }
      for (final note in _deletedNotes) {
        if (allToRemove.contains(note['category'])) {
          note['category'] = null;
        }
      }
      if (allToRemove.contains(_activeCategory)) {
        _activeCategory = 'Tümü';
      }
    });
    _saveData();
  }

  void _showCategoryOptions(String category) {
    final isLocked = _lockedCategories.contains(category);
    // Kategori bir alt klasörse ve üst klasörü zaten kilitliyse, bu alt
    // klasör üst klasörden kilidi otomatik devralır. Böyle bir durumda
    // alt klasörü ayrıca kendi başına kilitleme seçeneği gösterilmez;
    // aksi halde alt klasör hem üst klasörden hem de kendi kilidinden
    // olmak üzere "iki defa" kilitlenmiş sayılır ve üst klasörün kilidi
    // kaldırıldığında alt klasör hâlâ (kendi kilidiyle) kilitli kalırdı.
    final parentCat = _categoryParents[category];
    final isParentLocked =
        parentCat != null && _lockedCategories.contains(parentCat);
    final isCatCollapsed = _collapsedCategories.contains(category);
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
              if (!isParentLocked)
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
              // Alt klasör oluşturma seçeneği yalnızca üst seviye
              // kategorilerde gösterilir; şu an yalnızca 1 seviye derinlik
              // desteklendiği için bir alt klasörün kendi alt klasörü
              // oluşturulamaz.
              if (_categoryParents[category] == null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.create_new_folder_outlined,
                    color: Colors.amber,
                  ),
                  title: Text(
                    'Alt Klasör Oluştur',
                    style: TextStyle(color: dNoteTextColor(sheetContext)),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showAddCategoryDialog(parentCategory: category);
                  },
                ),
              // Bu kategorinin alt klasörleri varsa, yalnızca bu kategoriye
              // ait alt klasörleri daraltıp genişletme seçeneği burada
              // sunulur; diğer kategorileri etkilemez.
              if (_categories.any((c) => _categoryParents[c] == category))
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    isCatCollapsed ? Icons.unfold_more : Icons.unfold_less,
                    color: Colors.amber,
                  ),
                  title: Text(
                    isCatCollapsed
                        ? 'Alt Klasörleri Genişlet'
                        : 'Alt Klasörleri Daralt',
                    style: TextStyle(color: dNoteTextColor(sheetContext)),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    setState(() {
                      if (isCatCollapsed) {
                        _collapsedCategories.remove(category);
                      } else {
                        _collapsedCategories.add(category);
                      }
                    });
                    _saveData();
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
                        _categoryParents[category] == null &&
                                _categories.any(
                                  (c) => _categoryParents[c] == category,
                                )
                            ? '"$category" klasörünü ve içindeki tüm alt klasörleri silmek istediğinize emin misiniz? Bu klasörlerdeki notlar kategorisiz kalacak.'
                            : '"$category" kategorisini silmek istediğinize emin misiniz? Bu kategorideki notlar kategorisiz kalacak.',
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
}
