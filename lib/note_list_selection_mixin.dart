part of 'main.dart';

// ignore_for_file: unused_element

mixin NoteListSelectionMixin on State<NoteListScreen> {
  // ---- Diğer mixin'lerde tanımlı, burada kullanılan üyeler ----
  Color _getCategoryColor(String? category);
  Future<void> _saveData();
  void _showAddCategoryDialog({ void Function(String)? onAdded, String? editingCategory, String? parentCategory, });
  void _showInfoBar( String message, { IconData icon = Icons.check_circle, String? actionLabel, VoidCallback? onAction, });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> _notes = [];
  List<Map<String, dynamic>> _deletedNotes = [];
  List<String> _categories = [];
  Map<String, String> _categoryColors = {};
  Set<String> _lockedCategories = {};
  // Alt klasör desteği: bir kategori adını, ait olduğu üst kategorinin
  // adına eşler. Bir kategori bu haritada yoksa (veya değeri null'sa) üst
  // seviyededir. Şu an yalnızca 1 seviye derinlik destekleniyor; yani bir
  // alt klasörün kendi alt klasörü olamaz.
  Map<String, String?> _categoryParents = {};
  // Alt klasörleri çekmecede gizlenmiş üst kategorilerin adlarını tutar.
  // Her üst kategori kendi bağımsız daralt/genişlet durumuna sahiptir.
  Set<String> _collapsedCategories = {};
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
}
