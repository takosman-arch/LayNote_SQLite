import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const DNoteApp());
}

class DNoteApp extends StatelessWidget {
  const DNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DNote',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardTheme: const CardThemeData(
          color: Color(0xFF1E1E1E),
        ),
      ),
      home: const NoteListScreen(),
    );
  }
}

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Map<String, dynamic>> _notes = [];
  List<String> _categories = ['Genel'];
  String _activeCategory = 'Tümü';

  String _searchQuery = "";
  bool _isSearching = false;

  String _sortCriteria = "Oluşturulma";
  bool _isAscending = true;
  bool _isListView = true;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesString = prefs.getString('saved_notes_v2');
    final String? catsString = prefs.getString('saved_categories');

    if (catsString != null) {
      final List<dynamic> decoded = jsonDecode(catsString);
      setState(() {
        _categories = decoded.map((e) => e.toString()).toList();
      });
    }

    if (notesString != null) {
      final List<dynamic> decodedList = jsonDecode(notesString);
      setState(() {
        _notes = decodedList.map((item) => Map<String, dynamic>.from(item)).toList();
      });
    } else {
      setState(() {
        _notes = [
          {
            'title': 'DNote\'a Hoş Geldiniz! 🚀',
            'content': 'Yeni özellikler eklendi!',
            'date': '18.06.2026 22:05',
            'createdDate': '2026-06-18 22:05:00',
            'modifiedDate': '2026-06-18 22:05:00',
            'category': 'Genel',
            'color': 'Amber',
            'type': 'text',
          }
        ];
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_notes_v2', jsonEncode(_notes));
    await prefs.setString('saved_categories', jsonEncode(_categories));
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$day.$month.${now.year} $hour:$minute';
  }

  void _showAddMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.text_snippet_outlined, color: Colors.amber),
              title: const Text('Metin Notu', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showNoteDialog(type: 'text');
              },
            ),
            ListTile(
              leading: const Icon(Icons.checklist, color: Colors.amber),
              title: const Text('Kontrol Listesi', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showNoteDialog(type: 'checklist');
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_outlined, color: Colors.amber),
              title: const Text('Kategori', style: TextStyle(color: Colors.white)),
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

  void _showAddCategoryDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Yeni Kategori', style: TextStyle(color: Colors.amber)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Kategori adı',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty && !_categories.contains(name)) {
                setState(() {
                  _categories.add(name);
                });
                _saveData();
              }
              Navigator.pop(context);
            },
            child: const Text('Ekle', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showAssignCategoryDialog(int noteIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Kategori Seç', style: TextStyle(color: Colors.amber)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: _categories.map((cat) {
              final isSelected = _notes[noteIndex]['category'] == cat;
              return ListTile(
                title: Text(cat, style: TextStyle(color: isSelected ? Colors.amber : Colors.white)),
                trailing: isSelected ? const Icon(Icons.check, color: Colors.amber) : null,
                onTap: () {
                  setState(() {
                    _notes[noteIndex]['category'] = cat;
                  });
                  _saveData();
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showNoteDialog({int? index, String type = 'text'}) {
    String noteDate = "";
    String noteType = type;
    List<Map<String, dynamic>> checkItems = [];

    if (index != null) {
      _titleController.text = _notes[index]['title'] ?? '';
      _contentController.text = _notes[index]['content'] ?? '';
      noteDate = _notes[index]['date'] ?? "";
      noteType = _notes[index]['type'] ?? 'text';
      if (noteType == 'checklist') {
        final raw = _notes[index]['checkItems'];
        if (raw != null) {
          checkItems = List<Map<String, dynamic>>.from(
            (raw as List).map((e) => Map<String, dynamic>.from(e)),
          );
        }
      }
    } else {
      _titleController.clear();
      _contentController.clear();
      if (noteType == 'checklist') {
        checkItems = [{'text': '', 'checked': false}];
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text(
                index == null
                    ? (noteType == 'checklist' ? 'Kontrol Listesi' : 'Yeni Not')
                    : 'Düzenle',
                style: const TextStyle(color: Colors.amber),
              ),
              backgroundColor: const Color(0xFF1E1E1E),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Başlık (İsteğe Bağlı)',
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    if (noteType == 'text')
                      TextField(
                        controller: _contentController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Notunuz',
                          labelStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                        ),
                        style: const TextStyle(color: Colors.white),
                      )
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
                                controller: TextEditingController(text: item['text']),
                                style: const TextStyle(color: Colors.white),
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
                              icon: const Icon(Icons.close, color: Colors.grey, size: 18),
                              onPressed: () {
                                setModalState(() {
                                  checkItems.removeAt(i);
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
                          });
                        },
                        icon: const Icon(Icons.add, color: Colors.amber),
                        label: const Text('Madde Ekle', style: TextStyle(color: Colors.amber)),
                      ),
                    ],
                    if (index != null && noteDate.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.grey, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            'Oluşturulma: $noteDate',
                            style: const TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('İptal', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  onPressed: () {
                    final isValid = noteType == 'text'
                        ? _contentController.text.trim().isNotEmpty
                        : checkItems.any((e) => (e['text'] as String).trim().isNotEmpty);

                    if (isValid) {
                      final currentRawTime = DateTime.now().toString();
                      setState(() {
                        if (index == null) {
                          _notes.add({
                            'title': _titleController.text.trim(),
                            'content': noteType == 'text' ? _contentController.text : '',
                            'checkItems': noteType == 'checklist' ? checkItems : [],
                            'date': _getFormattedDate(),
                            'createdDate': currentRawTime,
                            'modifiedDate': currentRawTime,
                            'category': _activeCategory == 'Tümü' ? 'Genel' : _activeCategory,
                            'color': 'Amber',
                            'type': noteType,
                          });
                        } else {
                          _notes[index] = {
                            ..._notes[index],
                            'title': _titleController.text.trim(),
                            'content': noteType == 'text' ? _contentController.text : '',
                            'checkItems': noteType == 'checklist' ? checkItems : [],
                            'date': '${_getFormattedDate()} (Düzenlendi)',
                            'modifiedDate': currentRawTime,
                            'type': noteType,
                          };
                        }
                      });
                      _saveData();
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lütfen içeriği boş bırakmayın! ⚠️')),
                      );
                    }
                  },
                  child: Text(
                    index == null ? 'Kaydet' : 'Güncelle',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredNotes = _notes.where((note) {
      final title = (note['title'] ?? '').toString().toLowerCase();
      final content = (note['content'] ?? '').toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      final matchesSearch = title.contains(query) || content.contains(query);
      final matchesCategory = _activeCategory == 'Tümü' || note['category'] == _activeCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    filteredNotes.sort((a, b) {
      int compareResult = 0;
      switch (_sortCriteria) {
        case "Başlık":
          compareResult = (a['title'] ?? '').toString().compareTo((b['title'] ?? '').toString());
          break;
        case "Kategori":
          compareResult = (a['category'] ?? '').toString().compareTo((b['category'] ?? '').toString());
          break;
        case "Renk":
          compareResult = (a['color'] ?? '').toString().compareTo((b['color'] ?? '').toString());
          break;
        case "Son Düzenleme":
          compareResult = (a['modifiedDate'] ?? '').toString().compareTo((b['modifiedDate'] ?? '').toString());
          break;
        case "Oluşturulma":
        default:
          compareResult = (a['createdDate'] ?? '').toString().compareTo((b['createdDate'] ?? '').toString());
          break;
      }
      return _isAscending ? compareResult : -compareResult;
    });

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Notlarda ara...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 18),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : const Text(
                'DNote',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 24),
              ),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.amber),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.amber),
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
                CheckedPopupMenuItem<String>(
                  value: 'Renk',
                  checked: _sortCriteria == 'Renk',
                  child: const Text('Sırala: Renk'),
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
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF1E1E1E),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF161616)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('DNote Menü', style: TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Seçenekler ve Ayarlar', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.all_inbox, color: Colors.amber),
                title: const Text('Tüm Notlar', style: TextStyle(color: Colors.white)),
                selected: _activeCategory == 'Tümü',
                selectedTileColor: Colors.amber.withOpacity(0.1),
                onTap: () {
                  setState(() => _activeCategory = 'Tümü');
                  Navigator.pop(context);
                },
              ),
              const Divider(color: Colors.grey),
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
                child: Text('KATEGORİLER', style: TextStyle(color: Colors.grey, fontSize: 11)),
              ),
              ..._categories.map((cat) => ListTile(
                leading: const Icon(Icons.folder_outlined, color: Colors.amber),
                title: Text(cat, style: TextStyle(color: _activeCategory == cat ? Colors.amber : Colors.white)),
                selected: _activeCategory == cat,
                selectedTileColor: Colors.amber.withOpacity(0.1),
                onTap: () {
                  setState(() => _activeCategory = cat);
                  Navigator.pop(context);
                },
              )),
              const Divider(color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.settings_outlined, color: Colors.amber),
                title: const Text('Ayarlar', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.amber),
                title: const Text('Hakkında', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: const Color(0xFF161616),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Toplam Not: ${filteredNotes.length}  ($_sortCriteria - ${_isAscending ? "Artan" : "Azalan"})',
                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
                ),
                if (_searchQuery.isNotEmpty)
                  Text(
                    'Bulunan: ${filteredNotes.length}',
                    style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          Expanded(
            child: filteredNotes.isEmpty
                ? const Center(
                    child: Text('Not bulunamadı.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: _isListView
                        ? ListView.builder(
                            itemCount: filteredNotes.length,
                            itemBuilder: (context, index) {
                              final note = filteredNotes[index];
                              final originalIndex = _notes.indexOf(note);
                              final hasTitle = (note['title'] ?? '').toString().isNotEmpty;
                              final isChecklist = note['type'] == 'checklist';

                              return GestureDetector(
                                onLongPress: () => _showAssignCategoryDialog(originalIndex),
                                child: Card(
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: InkWell(
                                    onTap: () => _showNoteDialog(index: originalIndex),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (hasTitle) ...[
                                            Row(
                                              children: [
                                                if (isChecklist)
                                                  const Padding(
                                                    padding: EdgeInsets.only(right: 6),
                                                    child: Icon(Icons.checklist, color: Colors.amber, size: 16),
                                                  ),
                                                Expanded(
                                                  child: Text(
                                                    note['title'],
                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.amber),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                          if (isChecklist)
                                            ...(note['checkItems'] as List? ?? []).take(3).map((item) => Row(
                                              children: [
                                                Icon(
                                                  item['checked'] == true ? Icons.check_box : Icons.check_box_outline_blank,
                                                  color: Colors.amber,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  item['text'] ?? '',
                                                  style: TextStyle(
                                                    color: item['checked'] == true ? Colors.grey : Colors.white70,
                                                    decoration: item['checked'] == true ? TextDecoration.lineThrough : null,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ))
                                          else
                                            Text(
                                              note['content'] ?? '',
                                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: filteredNotes.length,
                            itemBuilder: (context, index) {
                              final note = filteredNotes[index];
                              final originalIndex = _notes.indexOf(note);
                              final hasTitle = (note['title'] ?? '').toString().isNotEmpty;
                              final isChecklist = note['type'] == 'checklist';

                              return GestureDetector(
                                onLongPress: () => _showAssignCategoryDialog(originalIndex),
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: InkWell(
                                    onTap: () => _showNoteDialog(index: originalIndex),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (hasTitle) ...[
                                            Text(
                                              note['title'],
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                          Expanded(
                                            child: isChecklist
                                                ? Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: (note['checkItems'] as List? ?? []).take(4).map<Widget>((item) => Row(
                                                      children: [
                                                        Icon(
                                                          item['checked'] == true ? Icons.check_box : Icons.check_box_outline_blank,
                                                          color: Colors.amber,
                                                          size: 14,
                                                        ),
                                                        const SizedBox(width: 4),
                                                        Expanded(
                                                          child: Text(
                                                            item['text'] ?? '',
                                                            style: TextStyle(
                                                              color: item['checked'] == true ? Colors.grey : Colors.white70,
                                                              decoration: item['checked'] == true ? TextDecoration.lineThrough : null,
                                                              fontSize: 12,
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    )).toList(),
                                                  )
                                                : Text(
                                                    note['content'] ?? '',
                                                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                                                    maxLines: hasTitle ? 4 : 6,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMenu,
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.black, size: 30),
      ),
    );
  }
}
