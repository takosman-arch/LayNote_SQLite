import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Not Uygulaması',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NoteListScreen(),
    );
  }
}

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });
}

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final List<Note> _notes = [
    Note(
      id: '1',
      title: 'Fikirler',
      content: 'Yeni mobil uygulama projesi için arayüz tasarımlarını incele.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Note(
      id: '2',
      title: 'Alışveriş Listesi',
      content: 'Süt, yumurta, kahve ve yüksek proteinli atıştırmalıklar.',
      createdAt: DateTime.now(),
    ),
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // Not Ekleme veya Güncelleme Fonksiyonu
  void _saveNote(Note? existingNote) {
    if (_titleController.text.trim().isEmpty && _contentController.text.trim().isEmpty) {
      return;
    }

    final inputTitle = _titleController.text.trim().isEmpty ? 'Başlıksız Not' : _titleController.text.trim();
    final inputContent = _contentController.text.trim();

    setState(() {
      if (existingNote == null) {
        // Yeni Not Ekleme
        _notes.add(
          Note(
            id: DateTime.now().toString(),
            title: inputTitle,
            content: inputContent,
            createdAt: DateTime.now(),
          ),
        );
      } else {
        // Mevcut Notu Düzenleme (Tarihi güncellemeden sadece içeriği değiştiriyoruz)
        final index = _notes.indexWhere((note) => note.id == existingNote.id);
        if (index != -1) {
          _notes[index] = Note(
            id: existingNote.id,
            title: inputTitle,
            content: inputContent,
            createdAt: existingNote.createdAt, // İlk oluşturulma tarihini koruyoruz
          );
        }
      }
    });

    _titleController.clear();
    _contentController.clear();
    Navigator.of(context).pop();
  }

  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((note) => note.id == id);
    });
  }

  // Ortak Form Paneli (existingNote null ise Ekleme, dolu ise Düzenleme modunda çalışır)
  void _showNoteFormBottomSheet(Note? note) {
    if (note != null) {
      _titleController.text = note.title;
      _contentController.text = note.content;
    } else {
      _titleController.clear();
      _contentController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                note == null ? 'Yeni Not Ekle' : 'Notu Düzenle',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Başlık',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _contentController,
                maxLines: 6, // İçeriği daha rahat okuyup yazmak için alanı büyüttük
                decoration: const InputDecoration(
                  labelText: 'İçerik',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _saveNote(note),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(note == null ? 'Kaydet' : 'Değişiklikleri Uygula'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Notları her zaman oluşturulma tarihine göre en yeni en üstte olacak şekilde sıralı tutuyoruz
    final sortedNotes = List<Note>.from(_notes)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notlarım'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: sortedNotes.isEmpty
          ? const Center(
              child: Text(
                'Henüz not eklenmemiş.\nEklemek için + butonuna basabilirsin.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: sortedNotes.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final note = sortedNotes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 2,
                  child: ListTile(
                    // Nota tıklandığında düzenleme panelini açıyoruz
                    onTap: () => _showNoteFormBottomSheet(note),
                    title: Text(
                      note.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.content,
                            maxLines: 2, // Ana ekranda taşma yapmaması için 2 satırla sınırladık
                            overflow: TextOverflow.ellipsis, // Uzun yazılarda üç nokta koyar
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${note.createdAt.hour.toString().padLeft(2, '0')}:${note.createdAt.minute.toString().padLeft(2, '0')} - ${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () => _deleteNote(note.id),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteFormBottomSheet(null), // Yeni not için null gönderiyoruz
        tooltip: 'Not Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}