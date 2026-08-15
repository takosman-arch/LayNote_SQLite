part of 'main.dart';

// ignore_for_file: unused_element

mixin NoteListBuildMixin on State<NoteListScreen> {
  // Arama modundaki etiket şeridinin hangi notlardan beslenceğini belirler.
  // Ana `build` içindeki kategori filtreleme dallarıyla (bkz. aşağıdaki
  // `filteredNotes` hesaplaması) aynı mantığı, arama sorgusu olmadan
  // uygular — amaç sadece "bu bölümde hangi etiketler var" sorusunu
  // yanıtlamak. "Tümü"/"Notlar" bölümünde kasıtlı olarak filtre uygulanmaz
  // (arşiv/kilitli dahil tüm notlardaki etiketler önerilir); diğer
  // bölümlerde (Favoriler, Kilitli, Arşiv, Hatırlatıcılar, klasörler) o
  // bölümde fiilen görünen notlarla sınırlanır.
  List<Map<String, dynamic>> _notesForActiveTagScope(bool isTrash) {
    if (isTrash) return _deletedNotes;
    if (_activeCategory == 'Tümü' || _activeCategory == 'Notlar') {
      return _notes;
    }
    return _notes.where((note) {
      final isArchived = note['isArchived'] == true;
      final isFavorite = note['isFavorite'] == true;
      final isLocked = note['isLocked'] == true;
      if (_activeCategory == '__favorites__') {
        return isFavorite && !isArchived && !isLocked;
      } else if (_activeCategory == '__locked__') {
        return isLocked && !isArchived;
      } else if (_activeCategory == '__archive__') {
        return isArchived && !isLocked;
      } else if (_activeCategory == '__reminders__') {
        return _hasActiveReminder(note) && !isArchived && !isLocked;
      } else {
        return !isArchived && !isLocked && note['category'] == _activeCategory;
      }
    }).toList();
  }

  // ---- Diğer mixin'lerde tanımlı, burada kullanılan üyeler ----
  String get _activeCategory;
  set _activeCategory(String value);
  Future<void> _appendSpeechTranscriptToNote(int noteIndex, String text);
  void _archiveSelectedNotes();
  String? get _attachmentsDirPath;
  set _attachmentsDirPath(String? value);
  Widget _buildCategoryDrawerTile(String cat, {bool isSubfolder = false});
  List<dynamic> _buildDateGroupedItems(List<Map<String, dynamic>> notes);
  String _capitalizeFirstLetterTr(String text);
  List<String> get _categories;
  set _categories(List<String> value);
  List<Color> get _categoryPalette;
  Map<String, String?> get _categoryParents;
  set _categoryParents(Map<String, String?> value);
  void _cleanupAttachmentFiles(Map<String, dynamic> note);
  Set<String> get _collapsedCategories;
  set _collapsedCategories(Set<String> value);
  bool get _colorfulNotes;
  set _colorfulNotes(bool value);
  void _deleteSelectedNotes();
  List<Map<String, dynamic>> get _deletedNotes;
  set _deletedNotes(List<Map<String, dynamic>> value);
  void _exitSelectionMode();
  String _folderTagLabel(String category);
  String _formatDateTimeShortTr(DateTime dt);
  Color _getCategoryColor(String? category);
  String _getCategoryDisplayName(String category);
  int _getCountForCategory(String category);
  String get _fontFamily;
  double get _globalFontSize;
  set _globalFontSize(double value);
  Future<bool> _handleBackPress();
  bool get _isAscending;
  set _isAscending(bool value);
  bool get _isListView;
  set _isListView(bool value);
  bool get _isSearching;
  set _isSearching(bool value);
  bool get _isSelectionMode;
  set _isSelectionMode(bool value);
  String _noteKey(Map<String, dynamic> note);
  List<Map<String, dynamic>> get _notes;
  set _notes(List<Map<String, dynamic>> value);
  Future<void> _openLockedFolder();
  Future<void> _openNoteWithPasswordCheck(int index, {bool openInstantly = false});
  void _openSettings();
  int get _previewLines;
  set _previewLines(int value);
  void _rescheduleNoteReminder(Map<String, dynamic> note);
  Future<void> _saveData();
  GlobalKey<ScaffoldState> get _scaffoldKey;
  TextEditingController get _searchController;
  String get _searchQuery;
  set _searchQuery(String value);
  Set<String> get _selectedNoteKeys;
  set _selectedNoteKeys(Set<String> value);
  void _showAddCategoryDialog({ void Function(String)? onAdded, String? editingCategory, String? parentCategory, });
  void _showClassifyDialogForSelection();
  // note_list_actions_mixin.dart -> _showInfoBar: etiket yeniden
  // adlandırma/silme sonrası kısa bilgi barı göstermek için burada da
  // kullanılıyor (bkz. _handleTagLongPress ve altındaki yardımcılar).
  void _showInfoBar(
    String message, {
    IconData icon,
    String? actionLabel,
    VoidCallback? onAction,
    Color backgroundColor,
  });
  void _showNoteActions( BuildContext ctx, int noteIndex, bool isTrash, { DateTime? editorReminder, String? editorReminderRepeat, void Function(DateTime? reminder, String? repeat)? onReminderChanged, VoidCallback? onDiscard, void Function(String text)? onInsertText, void Function(String? category)? onCategoryChanged, bool showSelectAction = false, });
  Future<void> _showNoteDialog({ int? index, String type = 'text', String? initialText, DateTime? initialAssignedDate, bool openInstantly = false, });
  String get _sortCriteria;
  set _sortCriteria(String value);
  Color? get _textColor;
  set _textColor(Color? value);
  void _toggleNoteSelection(Map<String, dynamic> note);


  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredNotes;
    SystemChrome.setSystemUIOverlayStyle(dNoteSystemBarsStyle(context));
    bool isTrash = _activeCategory == '__trash__';
    // Arama modundaki etiket şeridi için: aktif bölümde (Tümü/Notlar,
    // Favoriler, klasör, vb.) hangi etiketlerin bulunduğu build başında bir
    // kez hesaplanır. Liste boşsa aşağıda `bottom` tamamen null bırakılır —
    // sadece içeriği boş bir widget döndürmek yeterli değil, çünkü
    // PreferredSize'ın yüksekliği (44) her durumda ayrılan alanı belirler;
    // bu da etiket olmasa bile boş bir şeridin açılmasına yol açardı.
    final tagStripTags = collectAllKnownTags(
      _notesForActiveTagScope(isTrash),
    );

    if (isTrash) {
      filteredNotes = _deletedNotes.where((note) {
        final title = (note['title'] ?? '').toString().toLowerCase();
        final content = ContentBlocks.plainText(
          note['content'] as String?,
        ).toLowerCase();
        final query = _searchQuery.toLowerCase();
        // Etiketler de arama kapsamına dahil: notun etiketlerinden biri
        // sorguyu içeriyorsa da not sonuçta gösterilir (başlık/içerik ile
        // aynı mantık — kısmi eşleşme yeterli).
        final tagsRaw = note['tags'];
        final matchesTags = tagsRaw is List &&
            tagsRaw.any((t) => t.toString().toLowerCase().contains(query));
        return title.contains(query) || content.contains(query) || matchesTags;
      }).toList();
    } else {
      filteredNotes = _notes.where((note) {
        final title = (note['title'] ?? '').toString().toLowerCase();
        final content = ContentBlocks.plainText(
          note['content'] as String?,
        ).toLowerCase();
        final query = _searchQuery.toLowerCase();
        final tagsRaw = note['tags'];
        final matchesTags = tagsRaw is List &&
            tagsRaw.any((t) => t.toString().toLowerCase().contains(query));
        final matchesSearch =
            title.contains(query) || content.contains(query) || matchesTags;
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

    final bool showDateGroups =
        _isListView &&
        !isTrash &&
        _activeCategory != '__reminders__' &&
        (_sortCriteria == 'Son Düzenleme' || _sortCriteria == 'Oluşturulma');
    final List<dynamic> listItems = showDateGroups
        ? _buildDateGroupedItems(filteredNotes)
        : filteredNotes;

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
                  icon: Icon(Icons.close, color: appAccentColor.value),
                  tooltip: 'Seçimi İptal Et',
                  onPressed: _exitSelectionMode,
                )
              : null,
          title: _isSelectionMode
              ? Text(
                  '${_selectedNoteKeys.length} seçildi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: appAccentColor.value,
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: appAccentColor.value,
                    fontSize: 18,
                  ),
                ),
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: IconThemeData(color: appAccentColor.value),
          actions: _isSelectionMode
              ? [
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    tooltip: 'Sil',
                    onPressed: _deleteSelectedNotes,
                  ),
                  IconButton(
                    icon: Icon(Icons.archive_outlined, color: appAccentColor.value),
                    tooltip: 'Arşiv',
                    onPressed: _archiveSelectedNotes,
                  ),
                  IconButton(
                    icon: Icon(Icons.folder_outlined, color: appAccentColor.value),
                    tooltip: 'Klasör',
                    onPressed: _showClassifyDialogForSelection,
                  ),
                ]
              : [
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              icon: Icon(
                _isSearching ? Icons.close : Icons.search,
                color: appAccentColor.value,
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
                icon: Icon(Icons.more_vert, color: appAccentColor.value),
                onSelected: (String choice) {
                  if (choice == 'empty') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'Çöpü Boşalt',
                          style: TextStyle(color: appAccentColor.value),
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
                    PopupMenuItem(
                      value: 'restore_all',
                      child: Text(
                        'Hepsini Geri Yükle',
                        style: TextStyle(color: appAccentColor.value),
                      ),
                    ),
                  ];
                },
              )
            else
              PopupMenuButton<String>(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                icon: Icon(Icons.sort, color: appAccentColor.value),
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
                      child: const Text('Sırala: Klasör'),
                    ),
                  ];
                },
              ),
            IconButton(
              icon: Icon(
                _isListView ? Icons.grid_view : Icons.view_list,
                color: appAccentColor.value,
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
          // NOT: Etiket şeridi artık AppBar'ın `bottom` alanında değil,
          // body'nin en üstünde (bkz. aşağıdaki `_TagFilterStrip` kullanımı)
          // gösteriliyor. Sebebi: AppBar'ın kendi yüksekliği (preferredSize)
          // build başına sabit bir değerdir ve Flutter bunu kare kare
          // animasyonlamaz; `bottom` null'dan bir widget'a geçtiğinde alan
          // aniden 44px büyüyordu, içerideki kayma/solma animasyonu da bu
          // sabit kutunun içinde neredeyse fark edilmiyordu. Body içindeki
          // `AnimatedSize` ise gerçek bir yükseklik animasyonu sağladığı
          // için şerit gerçekten yukarıdan kayarak/büyüyerek açılıyor.
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'LayNote',
                          style: TextStyle(
                            color: appAccentColor.value,
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
                      leading: Icon(Icons.notes, color: appAccentColor.value),
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
                      leading: Icon(
                        Icons.star_outline,
                        color: appAccentColor.value,
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
                  ListTile(
                    leading: Icon(
                      Icons.event_note_outlined,
                      color: appAccentColor.value,
                    ),
                    title: const Text('Gündem'),
                    trailing: Text(
                      _gundemNoteCount(_notes).toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => _buildGundemScreen()),
                      );
                    },
                  ),
                  Container(
                    color: _activeCategory == '__reminders__'
                        ? dNoteHighlight(context)
                        : Colors.transparent,
                    child: ListTile(
                      leading: Icon(
                        Icons.notifications_active_outlined,
                        color: appAccentColor.value,
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
                      leading: Icon(
                        Icons.lock_outline,
                        color: appAccentColor.value,
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
                      leading: Icon(
                        Icons.archive_outlined,
                        color: appAccentColor.value,
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
                      leading: Icon(
                        Icons.delete_outline,
                        color: appAccentColor.value,
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
                  Builder(
                    builder: (context) {
                      // Alt klasörü olan üst kategorilerin listesi.
                      final parentsWithChildren = _categories
                          .where((cat) => _categoryParents[cat] == null)
                          .where(
                            (cat) => _categories.any(
                              (c) => _categoryParents[c] == cat,
                            ),
                          )
                          .toList();
                      final hasAnySubfolder = parentsWithChildren.isNotEmpty;
                      // Hepsi zaten daraltılmışsa başlıktaki yazı
                      // "Genişlet" olur; aksi halde "Daralt" gösterilir.
                      final allCollapsed =
                          hasAnySubfolder &&
                          parentsWithChildren.every(
                            (cat) => _collapsedCategories.contains(cat),
                          );
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 4,
                          bottom: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'KLASÖRLER',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                                letterSpacing: 1.2,
                              ),
                            ),
                            if (hasAnySubfolder)
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  setState(() {
                                    if (allCollapsed) {
                                      // Hepsini genişlet.
                                      _collapsedCategories.removeAll(
                                        parentsWithChildren,
                                      );
                                    } else {
                                      // Hepsini daralt.
                                      _collapsedCategories.addAll(
                                        parentsWithChildren,
                                      );
                                    }
                                  });
                                  // DÜZELTME: Genişlet/daralt durumu
                                  // kaydedilmediği için uygulamadan çıkıp
                                  // girince unutuluyordu — diğer tüm
                                  // durum değişikliklerinde olduğu gibi
                                  // burada da kalıcı hale getiriliyor.
                                  _saveData();
                                },
                                child: Text(
                                  allCollapsed ? 'Genişlet' : 'Daralt',
                                  style: TextStyle(
                                    color: appAccentColor.value,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Üst seviye kategoriler, hemen altlarında (varsa) girintili
                  // olarak kendi alt klasörleriyle birlikte listelenir. Her
                  // üst kategorinin alt klasörlerini gösterip gizlemesi
                  // kendi bağımsız daralt/genişlet durumuna bağlıdır.
                  ..._categories
                      .where((cat) => _categoryParents[cat] == null)
                      .expand((cat) {
                        final children = _categories
                            .where((c) => _categoryParents[c] == cat)
                            .toList();
                        final isCollapsed = _collapsedCategories.contains(
                          cat,
                        );
                        return [
                          _buildCategoryDrawerTile(cat),
                          if (!isCollapsed)
                            ...children.map(
                              (child) => _buildCategoryDrawerTile(
                                child,
                                isSubfolder: true,
                              ),
                            ),
                        ];
                      }),
                  ListTile(
                    leading: Icon(
                      Icons.add_circle_outline,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    title: const Text(
                      'Klasör Ekle',
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
                    leading: Icon(
                      Icons.calendar_month,
                      color: appAccentColor.value,
                    ),
                    title: const Text(
                      'Takvim',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => _buildCalendarScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings_outlined,
                      color: appAccentColor.value,
                    ),
                    title: const Text(
                      'Ayarlar',
                    ),
                    onTap: _openSettings,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.backup_outlined,
                      color: appAccentColor.value,
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
                    leading: Icon(
                      Icons.workspace_premium_outlined,
                      color: appAccentColor.value,
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
                        color: appAccentColor.value,
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
                    leading: Icon(
                      Icons.volunteer_activism_outlined,
                      color: appAccentColor.value,
                    ),
                    title: const Text(
                      'Geliştirme Desteği',
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.rate_review_outlined,
                      color: appAccentColor.value,
                    ),
                    title: const Text(
                      'Geri Bildirim',
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: appAccentColor.value,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Arama modundayken listenin üstünde, o an aktif olan
                // bölümdeki (Tümü/Notlar, Favoriler, bir klasör, vb.)
                // notlara ait etiketleri yan yana (yatay kaydırmalı)
                // listeleyen bir şerit gösterilir. Bir etikete dokunmak,
                // arama kutusuna o etiketi yazmışçasına filtreler; aynı
                // etikete tekrar dokunmak filtreyi kaldırır. Hiç etiket
                // yoksa (ör. Arşiv'de) şerit hiç yer kaplamaz.
                //
                // `AnimatedSize` gerçek bir yükseklik animasyonu sağladığı
                // için şerit, alanı olmayan bir AppBar altlığı yerine
                // burada gerçekten yukarıdan büyüyerek/kayarak açılıyor.
                //
                // Üstteki boşluk (12), aşağıdaki not listesinin/ızgaranın
                // zaten sahip olduğu top:12 padding'iyle eşleşecek şekilde
                // seçildi — böylece şeridin üstündeki ve altındaki boşluk
                // eşit oluyor (altta ayrıca kendi payı eklenmiyor, listenin
                // mevcut üst boşluğuna güveniliyor).
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: (_isSearching && tagStripTags.isNotEmpty)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: _TagFilterStrip(
                            allTags: tagStripTags,
                            searchQuery: _searchQuery,
                            textColor: _textColor,
                            onTagSelected: (tag, selected) {
                              setState(() {
                                _searchQuery = selected ? tag : "";
                                _searchController.text = _searchQuery;
                              });
                            },
                            onTagLongPress: (tag) =>
                                _handleTagLongPress(tag, isTrash),
                          ),
                        )
                      : const SizedBox(width: double.infinity, height: 0),
                ),
                Expanded(
                  child: filteredNotes.isEmpty
                ? const Center(
                    child: Text(
                      'Not bulunamadı.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : _isListView
                ? ListView.builder(
                    padding: EdgeInsets.only(
                      top: (_isSearching && tagStripTags.isNotEmpty)
                          ? 0.0
                          : 12.0,
                    ),
                    itemCount: listItems.length,
                    itemBuilder: (context, index) {
                      final listItem = listItems[index];
                      if (listItem is String) {
                        // İlk öğe bir tarih başlığıysa (ör. "Bugün"), üstteki
                        // ListView padding'i (12) ile bu başlığın kendi üst
                        // boşluğu (18) üst üste binip gereksiz büyük bir boşluk
                        // oluşturuyordu (Izgara görünümünde böyle bir başlık
                        // olmadığından bu fazlalık orada yoktu). Sadece en
                        // baştaki başlık için üst boşluğu küçültüyoruz; sonraki
                        // gruplar arasındaki ayraç boşluğu aynı kalıyor.
                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                            14,
                            index == 0 ? 4 : 18,
                            14,
                            6,
                          ),
                          child: Text(
                            listItem,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: dNoteIsDark(context)
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                            ),
                          ),
                        );
                      }
                      final note = listItem as Map<String, dynamic>;
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
                      // Not arka planı (palet) özelliği kaldırıldı: kart
                      // rengi artık her zaman colorfulNotes/kategori rengi
                      // mantığıyla belirlenir, kaydedilmiş eski bgColor
                      // değeri olsa bile dikkate alınmaz.
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
                              appAccentColor.value.withValues(alpha: 0.30),
                              baseNoteCardColor,
                            )
                          : baseNoteCardColor;
                      final fontScale = _previewFontScale(note);
                      final previewImage = _firstImageAttachment(note);
                      final previewDrawingStrokes = previewImage == null
                          ? _firstDrawingStrokes(note)
                          : null;
                      // Eski (legacy) checklist notları ve yeni blok tabanlı
                      // checklist içeren notlar için karışık önizleme kullanılır.
                      final _noteBlocks = ContentBlocks.parse(note['content'] as String?);
                      final _hasChecklistBlock = _noteBlocks.any((b) => b['type'] == 'checklist');
                      final showMixedPreview = isChecklist || _hasChecklistBlock;
                      // previewContentText, ContentBlocks.plainText() ile
                      // BİREBİR AYNI metni üretir (metin karakterleri hiç
                      // değişmedi) — previewContentSpans ise o metindeki
                      // kalın/italik/renk/link/vurgu aralıklarını taşır,
                      // aşağıda RichText + buildStaticTextSpan ile çizilsin
                      // diye eklendi.
                      final previewTextData = showMixedPreview
                          ? const ('', <Map<String, dynamic>>[])
                          : ContentBlocks.previewTextWithSpans(
                              note['content'] as String?,
                            );
                      final previewContentText = previewTextData.$1;
                      final previewContentSpans = previewTextData.$2;
                      final previewChecklistItems = showMixedPreview
                          ? _previewLineItems(note)
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
                                              backgroundColor: appAccentColor.value,
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
                                  ? BorderSide(
                                      color: appAccentColor.value,
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
                                                            appAccentColor.value,
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
                                            child: RichText(
                                              // Aşama 5: bkz. grid karttaki
                                              // aynı isimli açıklama —
                                              // maxLines/overflow eskiden de
                                              // yoktu, davranış değişmedi.
                                              text: buildStaticTextSpan(
                                                _capitalizeFirstLetterTr(
                                                  (note['title'] ?? '')
                                                      .toString(),
                                                ),
                                                note['titleSpans'] as List?,
                                                TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  // Başlık, notun kendi (veya
                                                  // Ayarlar > Metin Boyutu'ndan
                                                  // gelen) yazı boyutunun 2
                                                  // birim fazlası. fontScale =
                                                  // noteFontSize/16 olduğundan
                                                  // noteFontSize = 16*fontScale.
                                                  fontSize: (16 * fontScale) + 2,
                                                  color: dNoteEffectiveTextColor(context, _textColor),
                                                  fontFamily: dNoteFontFamilyValue(_fontFamily),
                                                ),
                                                isDark: dNoteIsDark(context),
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
                                                color: appAccentColor.value,
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
                                      ...(previewChecklistItems
                                          .take(_previewLines)
                                          .map<Widget>((item) {
                                            final isItemChecklist =
                                                item['checklist'] == true;
                                            final isChecked =
                                                item['checked'] == true;
                                            final textWidget = Text(
                                              (item['text'] ?? '').toString(),
                                              style: TextStyle(
                                                color:
                                                    isItemChecklist &&
                                                        isChecked
                                                    ? dNoteEffectiveTextColor(context, _textColor)
                                                          ?.withOpacity(0.5)
                                                    : (dNoteEffectiveTextColor(context, _textColor)),
                                                decoration:
                                                    isItemChecklist &&
                                                        isChecked
                                                    ? TextDecoration
                                                          .lineThrough
                                                    : null,
                                                decorationColor:
                                                    isItemChecklist &&
                                                        isChecked
                                                    ? Colors.grey[700]
                                                    : null,
                                                decorationStyle:
                                                    TextDecorationStyle.solid,
                                                fontSize:
                                                    (note['fontSize'] as num?)
                                                        ?.toDouble() ??
                                                    _globalFontSize,
                                                fontFamily: dNoteFontFamilyValue(_fontFamily),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            );
                                            if (!isItemChecklist) {
                                              return textWidget;
                                            }
                                            return Row(
                                              children: [
                                                Icon(
                                                  isChecked
                                                      ? Icons.check_box_rounded
                                                      : Icons
                                                            .check_box_outline_blank_rounded,
                                                  color: appAccentColor.value,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 6),
                                                Expanded(child: textWidget),
                                              ],
                                            );
                                          })
                                          .toList())
                                    else if (previewContentText.isNotEmpty ||
                                        previewShowFavoriteAlone)
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text.rich(
                                              // DÜZELTME: RichText, Text'in
                                              // aksine çevredeki
                                              // DefaultTextStyle'ı (ve metin
                                              // ölçekleme ayarlarını)
                                              // otomatik miras almıyor —
                                              // bu yüzden önceki Text(...)
                                              // widget'ının GÖRÜNÜMÜNÜ birebir
                                              // korumak için RichText yerine
                                              // Text.rich kullanılıyor
                                              // (Text.rich, Text ile aynı
                                              // DefaultTextStyle birleştirme
                                              // mantığını kullanır). TextStyle/
                                              // maxLines/overflow öncekiyle
                                              // birebir aynı korunuyor,
                                              // sadece kalın/italik/renk/
                                              // link/vurgu artık görünüyor.
                                              buildStaticTextSpan(
                                                previewContentText,
                                                previewContentSpans,
                                                TextStyle(
                                                  color: dNoteEffectiveTextColor(context, _textColor),
                                                  fontSize:
                                                      (note['fontSize'] as num?)
                                                          ?.toDouble() ??
                                                      _globalFontSize,
                                                  fontFamily: dNoteFontFamilyValue(_fontFamily),
                                                ),
                                                isDark: dNoteIsDark(context),
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
                                                color: appAccentColor.value,
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
                                                ? Icons.notifications
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
                                                    ((note['fontSize'] as num?)
                                                        ?.toDouble() ??
                                                    _globalFontSize) -
                                                    1,
                                                fontFamily: dNoteFontFamilyValue(
                                                  _fontFamily,
                                                ),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if (_showsGundemBadge(note)) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.today_outlined,
                                            color: Colors.grey,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              _gundemBadgeDateLabel(note)!,
                                              style: TextStyle(
                                                color: dNoteEffectiveTextColor(
                                                  context,
                                                  _textColor,
                                                ),
                                                fontSize:
                                                    ((note['fontSize'] as num?)
                                                        ?.toDouble() ??
                                                    _globalFontSize) -
                                                    1,
                                                fontFamily: dNoteFontFamilyValue(
                                                  _fontFamily,
                                                ),
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
                                                _folderTagLabel(
                                                  note['category'] as String,
                                                ),
                                                style: TextStyle(
                                                  color:
                                                      dNoteEffectiveTextColor(
                                                    context,
                                                    _textColor,
                                                  ),
                                                  fontSize:
                                                      ((note['fontSize']
                                                              as num?)
                                                          ?.toDouble() ??
                                                      _globalFontSize) -
                                                      1,
                                                  fontFamily:
                                                      dNoteFontFamilyValue(
                                                    _fontFamily,
                                                  ),
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
                                    _buildNoteTagChips(note),
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
                    padding: EdgeInsets.only(
                      top: (_isSearching && tagStripTags.isNotEmpty)
                          ? 0.0
                          : 12.0,
                    ),
                    child: _buildGridView(
                      filteredNotes: filteredNotes,
                      isTrash: isTrash,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showNoteDialog(type: 'text'),
          backgroundColor: appAccentColor.value,
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
  final double _kGridPreviewAspectRatio = 16 / 9;

  // Yazısız (sadece foto/çizim) notlarda, IZGARA (kart) görünümündeki
  // önizleme kare olarak gösterilir — sadece bu özel mod için. Metinli
  // notlardaki üst şerit (16:9) ve liste görünümündeki önizlemeler bundan
  // etkilenmez, aynı kalır.
  final double _kGridPreviewSquareAspectRatio = 1.0;

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

  // Kart önizlemesinde gösterilecek satır listesi. Hem eski (tüm not tek
  // checklist) hem de yeni blok tabanlı checklist içeren notlar için ortak
  // biçimde ({'checklist': bool, 'text': String, 'checked': bool}) döner;
  // böylece liste ve ızgara görünümündeki önizleme kodu aynı veriyi
  // kullanabilir.
  List<Map<String, dynamic>> _previewLineItems(Map<String, dynamic> note) {
    if (note['type'] == 'checklist') {
      return (note['checkItems'] as List? ?? [])
          .map<Map<String, dynamic>>(
            (it) => {
              'checklist': true,
              'text': (it['text'] ?? '').toString(),
              'checked': it['checked'] == true,
            },
          )
          .toList();
    }
    return ContentBlocks.previewLines(note['content'] as String?);
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
    final _estimateBlocks = ContentBlocks.parse(note['content'] as String?);
    final _estimateHasChecklistBlock = _estimateBlocks.any((b) => b['type'] == 'checklist');
    final bool isMixedChecklist = isChecklist || _estimateHasChecklistBlock;
    final fontScale = _previewFontScale(note);
    // Kartın gerçek (padding'siz) genişliği; _buildGridView içindeki
    // cardInnerPadding (16.0) değeriyle bire bir eşleşmeli.
    const double cardInnerPadding = 16.0;
    final double columnWidth = cardContentWidth + (cardInnerPadding * 2);
    final images = _previewImages(note);
    // Yazısız (sadece foto) notlarda kart tamamen foto(lar)dan ibarettir;
    // checklist notlarda bu özel mod uygulanmaz (checklist her zaman
    // "yazılı" kabul edilir, mevcut davranış korunur).
    final bool hasText = isMixedChecklist
        ? true
        : ContentBlocks.plainText(note['content'] as String?).isNotEmpty;
    // Fotoğraf yoksa, notun ilk çizim bloğuna bakılır (bkz. _gridPreviewDrawingTile);
    // bir not hem fotoğraf hem çizim içeriyorsa fotoğraf önceliklidir.
    final drawingStrokes = images.isEmpty ? _firstDrawingStrokes(note) : null;
    final bool hasVisual = images.isNotEmpty || drawingStrokes != null;
    final bool photoOnlyMode = !isMixedChecklist && hasVisual && !hasText;

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
      height += ((16 * fontScale) + 2) * 1.2; // başlık satırı (tek satır, maxLines:1)
      height += 12.0; // başlık sonrası SizedBox
    }

    if (isMixedChecklist) {
      final items = _previewLineItems(note);
      final itemCount = items.length.clamp(0, _previewLines);
      // Her önizleme satırı (checklist maddesi ya da metin satırı) tek
      // satır + altında 4px boşluk.
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
    // Not arka planı (palet) özelliği kaldırıldı: bkz. liste görünümündeki
    // aynı isimli açıklama.
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
            appAccentColor.value.withValues(alpha: 0.30),
            baseGridCardColor,
          )
        : baseGridCardColor;
    final fontScale = _previewFontScale(note);
    final images = _previewImages(note);
    final _noteBlocks = ContentBlocks.parse(note['content'] as String?);
    final _hasChecklistBlock = _noteBlocks.any((b) => b['type'] == 'checklist');
    final showMixedPreview = isChecklist || _hasChecklistBlock;
    // Gövde önizlemesinin metni ve (kalın/italik/renk/link/vurgu) span'ları
    // — metin karakterleri ContentBlocks.plainText() ile birebir aynı,
    // tek fark RichText ile çizilebilmesi için span bilgisinin de burada
    // taşınması. showMixedPreview true iken (checklist notlar) bu alan
    // kullanılmıyor, boş bırakılıyor.
    final previewTextData = showMixedPreview
        ? const ('', <Map<String, dynamic>>[])
        : ContentBlocks.previewTextWithSpans(note['content'] as String?);
    final previewContentText = previewTextData.$1;
    final previewContentSpans = previewTextData.$2;
    // Yazısız (sadece foto) notlarda kart tamamen foto(lar)dan ibarettir;
    // checklist notlar bu özel modun dışında tutulur.
    final bool hasText = showMixedPreview ? true : previewContentText.isNotEmpty;
    // Fotoğraf yoksa notun ilk çizim bloğuna bakılır; fotoğraf her zaman
    // önceliklidir (bkz. _gridPreviewDrawingTile).
    final previewDrawingStrokes =
        images.isEmpty ? _firstDrawingStrokes(note) : null;
    final bool hasVisual = images.isNotEmpty || previewDrawingStrokes != null;
    final bool photoOnlyMode = !showMixedPreview && hasVisual && !hasText;

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
                            backgroundColor: appAccentColor.value,
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
              ? BorderSide(color: appAccentColor.value, width: 2)
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
                                backgroundColor: appAccentColor.value,
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
                          RichText(
                            // Aşama 5: başlık artık kalın/italik/vurgu/link
                            // vb. span'larıyla birlikte çiziliyor (bkz.
                            // buildStaticTextSpan, rich_block_text_controller.dart).
                            // maxLines/overflow/textAlign/textDirection
                            // öncekiyle birebir aynı korunuyor.
                            text: buildStaticTextSpan(
                              _capitalizeFirstLetterTr(
                                (note['title'] ?? '').toString(),
                              ),
                              note['titleSpans'] as List?,
                              TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: (16 * fontScale) + 2,
                                color: dNoteEffectiveTextColor(context, _textColor),
                                fontFamily: dNoteFontFamilyValue(_fontFamily),
                              ),
                              isDark: dNoteIsDark(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            textDirection: TextDirection.ltr,
                          ),
                        if (hasTitle) const SizedBox(height: 12),
                        showMixedPreview
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _previewLineItems(note)
                                    .take(_previewLines)
                                    .map<Widget>((item) {
                                      final isItemChecklist =
                                          item['checklist'] == true;
                                      final isChecked =
                                          item['checked'] == true;
                                      final textWidget = Text(
                                        (item['text'] ?? '').toString(),
                                        style: TextStyle(
                                          color: isItemChecklist && isChecked
                                              ? dNoteEffectiveTextColor(context, _textColor)?.withOpacity(0.5)
                                              : (dNoteEffectiveTextColor(context, _textColor)),
                                          decoration:
                                              isItemChecklist && isChecked
                                              ? TextDecoration.lineThrough
                                              : null,
                                          decorationColor:
                                              isItemChecklist && isChecked
                                              ? Colors.grey[700]
                                              : null,
                                          decorationStyle:
                                              TextDecorationStyle.solid,
                                          fontSize:
                                              (note['fontSize'] as num?)
                                                  ?.toDouble() ??
                                              _globalFontSize,
                                          fontFamily: dNoteFontFamilyValue(_fontFamily),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        textDirection: TextDirection.ltr,
                                      );
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        child: !isItemChecklist
                                            ? textWidget
                                            : Row(
                                                textDirection:
                                                    TextDirection.ltr,
                                                children: [
                                                  Icon(
                                                    isChecked
                                                        ? Icons.check_box_rounded
                                                        : Icons
                                                              .check_box_outline_blank_rounded,
                                                    color: appAccentColor.value,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(child: textWidget),
                                                ],
                                              ),
                                      );
                                    })
                                    .toList(),
                              )
                            : Text.rich(
                                // DÜZELTME: RichText, DefaultTextStyle'ı
                                // otomatik miras almadığından, önceki
                                // Text(...) widget'ının görünümünü birebir
                                // korumak için Text.rich kullanılıyor (bkz.
                                // liste görünümündeki aynı isimli açıklama).
                                // TextStyle/maxLines/overflow/textAlign/
                                // textDirection öncekiyle birebir aynı
                                // korunuyor.
                                buildStaticTextSpan(
                                  previewContentText,
                                  previewContentSpans,
                                  TextStyle(
                                    color: dNoteEffectiveTextColor(context, _textColor),
                                    fontSize:
                                        (note['fontSize'] as num?)?.toDouble() ??
                                        _globalFontSize,
                                    fontFamily: dNoteFontFamilyValue(_fontFamily),
                                  ),
                                  isDark: dNoteIsDark(context),
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
                                    ? Icons.notifications
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
                                        ((note['fontSize'] as num?)
                                            ?.toDouble() ??
                                        _globalFontSize) -
                                        1,
                                    fontFamily: dNoteFontFamilyValue(
                                      _fontFamily,
                                    ),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (_showsGundemBadge(note)) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.today_outlined,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  _gundemBadgeDateLabel(note)!,
                                  style: TextStyle(
                                    color: dNoteEffectiveTextColor(
                                      context,
                                      _textColor,
                                    ),
                                    fontSize:
                                        ((note['fontSize'] as num?)
                                            ?.toDouble() ??
                                        _globalFontSize) -
                                        1,
                                    fontFamily: dNoteFontFamilyValue(
                                      _fontFamily,
                                    ),
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
                                  _folderTagLabel(
                                    note['category'] as String,
                                  ),
                                  style: TextStyle(
                                    color: dNoteEffectiveTextColor(
                                      context,
                                      _textColor,
                                    ),
                                    fontSize:
                                        ((note['fontSize'] as num?)
                                            ?.toDouble() ??
                                        _globalFontSize) -
                                        1,
                                    fontFamily: dNoteFontFamilyValue(
                                      _fontFamily,
                                    ),
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
                        _buildNoteTagChips(note),
                      ],
                    ),
                  ),
                ],
              ),
              if (isFavorite)
                Positioned(
                  top: 8,
                  right: note['isLocked'] == true ? 36 : 8,
                  child: Icon(Icons.star, color: appAccentColor.value, size: 18),
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

  // Not kartında (liste/ızgara görünümü) kategori etiketinin altında
  // gösterilen etiket önizlemesi. Reminder/gündem/klasör rozetleriyle
  // birebir aynı stil: küçük gri ikon + tek satır metin (taşarsa "...").
  // Notun 'tags' listesi boşsa/yoksa boş bir widget (SizedBox.shrink())
  // döner ki çağıran taraf koşulsuz ekleyebilsin.
  Widget _buildNoteTagChips(Map<String, dynamic> note) {
    final rawTags = note['tags'];
    if (rawTags is! List || rawTags.isEmpty) return const SizedBox.shrink();
    final tags = rawTags.map((e) => e.toString()).toList();

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sell_outlined,
            color: Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              tags.join(', '),
              style: TextStyle(
                color: dNoteEffectiveTextColor(context, _textColor),
                fontSize:
                    ((note['fontSize'] as num?)?.toDouble() ??
                        _globalFontSize) -
                    1,
                fontFamily: dNoteFontFamilyValue(_fontFamily),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // [oldTag]'ı, [target] listesindeki (çöp kutusu ya da aktif notlar) TÜM
  // notlarda kullanıcının gireceği yeni isimle değiştirir. Bir notta hem
  // eski etiket hem de (büyük/küçük harf duyarsız) yeni isimle eşleşen
  // başka bir etiket zaten varsa, kopya oluşmasın diye eski olan silinir
  // (yeni adında zaten var demektir) — bkz. note_tags_sheet.dart içindeki
  // addTag'in aynı çakışma mantığı. Vazgeçilirse ya da isim değişmediyse
  // null, başarıyla değiştirildiyse yeni ismi döner — çağıran taraf
  // (ör. showNoteTagsSheet'in onRenameTagGlobally'si) bu dönüş değerini
  // kendi yerel state'ini güncellemek için kullanır.
  Future<String?> _renameTagInList(
    String oldTag,
    List<Map<String, dynamic>> target,
  ) async {
    final newTag = await showRenameTagDialog(context, oldTag);
    if (newTag == null || newTag.isEmpty || newTag == oldTag) return null;

    setState(() {
      for (var i = 0; i < target.length; i++) {
        final rawTags = target[i]['tags'];
        if (rawTags is! List) continue;
        final tags = rawTags.map((e) => e.toString()).toList();
        final idx = tags.indexWhere(
          (t) => t.toLowerCase() == oldTag.toLowerCase(),
        );
        if (idx == -1) continue;
        final duplicateIdx = tags.indexWhere(
          (t) => t.toLowerCase() == newTag.toLowerCase(),
        );
        if (duplicateIdx != -1 && duplicateIdx != idx) {
          tags.removeAt(idx);
        } else {
          tags[idx] = newTag;
        }
        target[i] = {...target[i], 'tags': tags};
      }
      if (_searchQuery == oldTag) _searchQuery = newTag;
    });
    _saveData();
    _showInfoBar('Etiket yeniden adlandırıldı', icon: Icons.edit_outlined);
    return newTag;
  }

  // [tag]'ı, [target] listesindeki (çöp kutusu ya da aktif notlar) tüm
  // notlardan siler. Etiket en az bir notta kullanılıyorsa önce kaç
  // nottan kaldırılacağını belirten bir onay diyaloğu gösterilir.
  // Silme gerçekleştiyse true, vazgeçildiyse false döner.
  Future<bool> _deleteTagInList(
    String tag,
    List<Map<String, dynamic>> target,
  ) async {
    final affectedCount = countNotesWithTag(target, tag);

    final confirmed = affectedCount > 0
        ? await showDeleteTagConfirmDialog(
            context,
            tag: tag,
            affectedCount: affectedCount,
          )
        : true;
    if (!confirmed) return false;

    setState(() {
      for (var i = 0; i < target.length; i++) {
        final rawTags = target[i]['tags'];
        if (rawTags is! List) continue;
        final tags = rawTags.map((e) => e.toString()).toList();
        final idx = tags.indexWhere(
          (t) => t.toLowerCase() == tag.toLowerCase(),
        );
        if (idx == -1) continue;
        tags.removeAt(idx);
        target[i] = {...target[i], 'tags': tags};
      }
      if (_searchQuery == tag) {
        _searchQuery = "";
        _searchController.text = "";
      }
    });
    _saveData();
    _showInfoBar('Etiket silindi', icon: Icons.delete_outline);
    return true;
  }

  // Etiket şeridinde (arama modu) bir etikete basılı tutulunca çağrılır.
  // "Yeniden Adlandır / Sil" seçeneklerini gösterir; [isTrash] true ise
  // işlem çöp kutusundaki notlar üzerinde, değilse aktif not listesi
  // üzerinde uygulanır — şerit zaten hangi listeden besleniyorsa
  // (bkz. _notesForActiveTagScope) o kapsamla tutarlı kalması için.
  void _handleTagLongPress(String tag, bool isTrash) {
    showTagOptionsSheet(
      context,
      tag: tag,
      onRename: () => _renameTagEverywhere(tag, isTrash),
      onDelete: () => _deleteTagWithConfirmation(tag, isTrash),
    );
  }

  Future<void> _renameTagEverywhere(String oldTag, bool isTrash) async {
    await _renameTagInList(oldTag, isTrash ? _deletedNotes : _notes);
  }

  Future<void> _deleteTagWithConfirmation(String tag, bool isTrash) async {
    await _deleteTagInList(tag, isTrash ? _deletedNotes : _notes);
  }

  // Not düzenleme diyaloğundaki "Etiketler" sheet'i (showNoteTagsSheet)
  // için: o sheet her zaman aktif (çöp kutusu olmayan) notlar üzerinde
  // çalışır, bu yüzden isTrash parametresi almadan doğrudan _notes'u
  // hedefler. Sheet, bu iki metodu sırasıyla onRenameTagGlobally ve
  // onDeleteTagGlobally callback'leri olarak alır.
  Future<String?> _renameTagGlobally(String oldTag) =>
      _renameTagInList(oldTag, _notes);

  Future<bool> _deleteTagGlobally(String tag) =>
      _deleteTagInList(tag, _notes);

  // Notun gelecekte planlanmış bir hatırlatıcısı var mı?
  bool _hasActiveReminder(Map<String, dynamic> note) {
    final raw = note['reminderDate']?.toString();
    if (raw == null || raw.isEmpty) return false;
    final dt = DateTime.tryParse(raw);
    return dt != null && dt.isAfter(DateTime.now());
  }

  // Hatırlatıcı tarihini "gg.aa.yyyy ss:dd" biçiminde döndürür (kartlarda ve
  // not içinde gösterilir); yoksa null döner.
  // Hatırlatıcı rozeti (saat/ikon) zaten gösterilmiyorsa VE not, Gündem
  // ekranında bir satırla temsil ediliyorsa (hatırlatıcı VEYA atanmış
  // tarih üzerinden — bkz. gundem_screen.dart -> _gundemNoteCount ile
  // aynı mantık) true döner. Hatırlatıcı rozeti zaten varsa (kullanıcının
  // isteği üzerine) ayrıca gündem rozeti gösterilmez.
  bool _showsGundemBadge(Map<String, dynamic> note) {
    if (_formattedReminderText(note) != null) return false;
    if (note['isLocked'] == true || note['isArchived'] == true) return false;
    return _reminderAgendaDay(note) != null || _assignedAgendaDay(note) != null;
  }

  // Gündem rozetinin yanında gösterilecek tarih metni, "Ağu 9, Pazar"
  // biçiminde (bkz. gundem_screen.dart -> _gundemMonthNamesShortTr /
  // _gundemWeekDayFullTr, aynı top-level listeler burada da kullanılıyor).
  // _showsGundemBadge true dönmüyorsa null döner.
  String? _gundemBadgeDateLabel(Map<String, dynamic> note) {
    final day = _reminderAgendaDay(note) ?? _assignedAgendaDay(note);
    if (day == null) return null;
    return '${_gundemMonthNamesShortTr[day.month - 1]} ${day.day}, ${_gundemWeekDayFullTr[day.weekday - 1]}';
  }

  String? _formattedReminderText(Map<String, dynamic> note) {
    if (!_hasActiveReminder(note)) return null;
    final dt = DateTime.parse(note['reminderDate'].toString());
    return _formatDateTimeShortTr(dt);
  }

  // Gündem ekranını tüm callback'leriyle birlikte kurar. Hem çekmece
  // menüsündeki "Gündem" satırından hem de Takvim ekranının üst barındaki
  // gündem ikonundan (onOpenGundem) çağrılır; böylece iki ekran arasında
  // gidiş-geliş için kod tekrarı yapılmaz.
  Widget _buildGundemScreen() {
    return GundemScreen(
      // ÖNEMLİ: kopya değil, _notes'un KENDİSİ veriliyor. Not düzenlenince
      // kaydetme kodu _notes[index]'i YENİ bir Map ile değiştiriyor (bkz.
      // note_list_actions_mixin.dart); Gündem ayrı bir kopya tutsaydı bu
      // değişikliği hiç göremezdi. Aynı referans paylaşıldığı için
      // Gündem'in kendi setState'i (onOpenNote'un await'i tamamlanınca)
      // artık güncel veriyi yeniden çizer.
      notes: _notes,
      globalFontSize: _globalFontSize,
      fontFamily: dNoteFontFamilyValue(_fontFamily),
      onOpenNote: (note) async {
        final tappedNoteId = note['id']?.toString();
        if (tappedNoteId == null) return;
        final index = _notes.indexWhere(
          (n) => n['id']?.toString() == tappedNoteId,
        );
        if (index != -1) {
          // Gündem, bu Future tamamlanana (yani not ekranından geri
          // dönülene) kadar bekleyip ardından kendi görünümünü yeniliyor.
          await _openNoteWithPasswordCheck(index);
        }
      },
      onRemoveFromAgenda: (note, isAssigned) {
        setState(() {
          if (isAssigned) {
            note.remove('assignedDate');
          } else {
            note.remove('reminderDate');
            note.remove('reminderRepeat');
          }
        });
        _rescheduleNoteReminder(note);
        _saveData();
      },
      onDeleteNote: (note) {
        final key = _noteKey(note);
        setState(() {
          _selectedNoteKeys = {key};
        });
        _deleteSelectedNotes();
      },
      // Üst bardaki takvim ikonu: Gündem'in üzerine Takvim'i push eder.
      onOpenCalendar: (ctx) {
        Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => _buildCalendarScreen()),
        );
      },
    );
  }

  // Takvim ekranını tüm callback'leriyle birlikte kurar. Hem çekmece
  // menüsündeki "Takvim" satırından hem de Gündem ekranının üst barındaki
  // takvim ikonundan (onOpenCalendar) çağrılır.
  Widget _buildCalendarScreen() {
    return CalendarScreen(
      // Gündem'deki aynı düzeltme: kopya değil, _notes'un kendisi. Not
      // kaydedildiğinde _notes[index] YENİ bir Map ile değiştiriliyor;
      // Takvim ayrı bir kopya tutsaydı bu değişikliği göremezdi.
      notes: _notes,
      fontFamily: dNoteFontFamilyValue(_fontFamily),
      onNewNote: (date) async {
        await _showNoteDialog(
          type: 'text',
          initialAssignedDate: date,
        );
      },
      onOpenNote: (noteId) async {
        final index = _notes.indexWhere(
          (n) => n['id']?.toString() == noteId,
        );
        if (index != -1) {
          await _openNoteWithPasswordCheck(index);
        }
      },
      // Üst bardaki gündem ikonu: Takvim'in üzerine Gündem'i push eder.
      onOpenGundem: (ctx) {
        Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => _buildGundemScreen()),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
// Arama modunda üst barın altında beliren etiket şeridi. `Builder` her
// _isSearching değişiminde bu widget'ı sıfırdan (yeni bir instance olarak)
// oluşturduğundan, initState'te başlattığımız giriş animasyonu her açılışta
// tekrar çalışır: şerit hafifçe yukarıdan kayarak ve belirerek iner. Kapanış
// ayrıca animasyonlu değildir (üst bar zaten anında geri daralıyor); istenen
// sadece açılışın yumuşatılmasıydı.
// ════════════════════════════════════════════════════════════════════════
class _TagFilterStrip extends StatefulWidget {
  const _TagFilterStrip({
    required this.allTags,
    required this.searchQuery,
    required this.textColor,
    required this.onTagSelected,
    required this.onTagLongPress,
  });

  final List<String> allTags;
  final String searchQuery;
  final Color? textColor;
  final void Function(String tag, bool selected) onTagSelected;
  // Bir etikete basılı tutulunca (yeniden adlandır/sil seçenekleri için)
  // çağrılır — bkz. NoteListBuildMixin._handleTagLongPress.
  final void Function(String tag) onTagLongPress;

  @override
  State<_TagFilterStrip> createState() => _TagFilterStripState();
}

class _TagFilterStripState extends State<_TagFilterStrip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.25),
      end: Offset.zero,
    ).animate(curved);
    _fade = curved;
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in widget.allTags)
                // GestureDetector, ChoiceChip'in kendi onSelected'ını
                // (tap) engellemeden üstüne basılı tutma (long press)
                // algılamak için sarmalayıcı olarak eklendi — chip'in
                // normal tıklama/seçim davranışı aynen çalışmaya devam
                // eder, sadece uzun basışta ek olarak yeniden
                // adlandır/sil sheet'i açılır.
                GestureDetector(
                  onLongPress: () => widget.onTagLongPress(tag),
                  child: ChoiceChip(
                    label: Text(tag),
                    selected: widget.searchQuery == tag,
                    onSelected: (selected) =>
                        widget.onTagSelected(tag, selected),
                    selectedColor: appAccentColor.value.withOpacity(0.3),
                    backgroundColor: Colors.grey.withOpacity(0.15),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    labelStyle: TextStyle(
                      color: dNoteEffectiveTextColor(
                        context,
                        widget.textColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
