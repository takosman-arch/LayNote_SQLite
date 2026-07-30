part of 'main.dart';

// ignore_for_file: unused_element

mixin NoteListNoteDialogMixin on State<NoteListScreen> {
  // ---- Diğer mixin'lerde tanımlı, burada kullanılan üyeler ----
  Widget _buildAttachmentGrid({ required List<String> ids, required List<Map<String, dynamic>> attachmentsList, required void Function(String id) onRemove, required void Function(Map<String, dynamic> att) onOpen, required String? deletingId, required void Function(String? id) onDeletingIdChanged, });
  Widget _buildDocPreview(Map<String, dynamic> att, String filePath);
  List<Color> get _categoryPalette;
  bool get _colorfulNotes;
  set _colorfulNotes(bool value);
  dynamic _deepClone(dynamic value);
  String _folderTagLabel(String category);
  String _formatDateTimeShortTr(DateTime dt);
  Color _getCategoryColor(String? category);
  String _getFormattedDate([DateTime? date]);
  double get _globalFontSize;
  set _globalFontSize(double value);
  Future<void> _handleReminderRowTap({ required BuildContext context, required DateTime? currentReminder, required String? currentRepeat, required void Function(DateTime? reminder, String? repeat) onChanged, });
  List<Map<String, dynamic>> get _notes;
  set _notes(List<Map<String, dynamic>> value);
  Future<DateTime?> _pickCalendarDate({ required BuildContext context, required DateTime initialDate, required DateTime firstDate, required DateTime lastDate, required String helpText, });
  bool _saveNoteIfValid( int? index, String noteType, List<Map<String, dynamic>> checkItems, [ List<Map<String, dynamic>> attachments = const [], List<Map<String, dynamic>> blocks = const [], DateTime? reminder, DateTime? assignedDate, String? reminderRepeat, ]);
  void _showAddAttachmentSheet( BuildContext ctx, { required void Function(String value) onSelected, });
  void _showClassifyDialog(int noteIndex, {void Function(String?)? onChanged});
  Future<void> _showExportSubmenu({ required BuildContext context, required GlobalKey anchorKey, required String title, required String noteType, required List<Map<String, dynamic>> blocks, required List<Map<String, dynamic>> checkItems, required List<Map<String, dynamic>> attachments, double fontSize = 16.0, });
  void _showInfoBar( String message, { IconData icon = Icons.check_circle, String? actionLabel, VoidCallback? onAction, });
  void _showNoteActions( BuildContext ctx, int noteIndex, bool isTrash, { DateTime? editorReminder, String? editorReminderRepeat, void Function(DateTime? reminder, String? repeat)? onReminderChanged, VoidCallback? onDiscard, void Function(String text)? onInsertText, bool showSelectAction = false, });
  Color? get _textColor;
  set _textColor(Color? value);
  TextEditingController get _titleController;
  void dispose();


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
    // "Çizim Ekle" ile yeni eklenen çizim bloğunun tam ekran çizim
    // sayfasını otomatik açması gerektiğini işaretlemek için kullanılır
    // (bkz. NoteDrawingBlock.autoOpenOnce). Yalnızca eklendiği anda bir
    // sonraki widget kurulumunda bir kez tüketilir, sonra null'a döner.
    int? autoOpenDrawingBlockIndex;
    // 'checklist' tipindeki bloklar için: her blok indeksine karşılık gelen
    // madde controller/focus node listesi (metin bloklarında null).
    List<List<TextEditingController>?> blockItemControllers = [];
    List<List<FocusNode>?> blockItemFocusNodes = [];
    // 'calc_table' tipindeki bloklar için: her blok indeksine karşılık gelen
    // satır (etiket/tutar) controller ve focus node listeleri.
    List<List<TextEditingController>?> blockTableLabelControllers = [];
    List<List<TextEditingController>?> blockTableValueControllers = [];
    List<List<FocusNode>?> blockTableLabelFocusNodes = [];
    List<List<FocusNode>?> blockTableValueFocusNodes = [];

    // Boş bir metin bloğunun TextField'ında görünmeyen (sıfır genişlikli)
    // bir "işaretçi" karakteri. Bazı klavyeler (özellikle Android'de bazı
    // sanal klavyeler) alan TAMAMEN boşken Geri (Backspace) tuşuna
    // basıldığında hiçbir olay/karakter değişikliği bildirmiyor (silinecek
    // bir şey olmadığı için); bu yüzden "boş satırı sil" özelliği önceden
    // bu klavyelerde hiç tetiklenmiyordu. Çözüm: mantıken boş olan metin
    // bloklarının controller'ına görünmez bu tek karakteri koyuyoruz, böylece
    // Backspace her zaman GERÇEK bir "1 karakter -> 0 karakter" silme olayı
    // oluyor ve onChanged her klavyede güvenilir şekilde tetikleniyor (bkz.
    // aşağıdaki metin bloğu onChanged'i).
    const emptyTextSentinel = '\u200B';

    // Blok listesi değiştiğinde (ekleme/silme/birleştirme) controller ve
    // focus node'ları tamamen yeniden kurar. Metin bloğu olmayan (ek)
    // konumlar için null tutulur.
    void rebuildBlockControllers() {
      // Not listesi her zaman bir metin bloğuyla bitmelidir: aksi halde
      // (ör. "Blokları Sırala" ile bir blok en sona taşındığında ya da en
      // sondaki boş satır Backspace ile silindiğinde) notun altına
      // dokunup yazı ekleyebileceğimiz bir alan kalmaz. Böyle bir durum
      // oluşmuşsa sona boş bir metin bloğu ekleriz.
      if (blocks.isEmpty || blocks.last['type'] != 'text') {
        blocks.add({'type': 'text', 'text': ''});
      }
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
        for (final list in blockTableValueFocusNodes)
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
      blockTableValueFocusNodes = [];
      for (int i = 0; i < blocks.length; i++) {
        if (blocks[i]['type'] == 'text') {
          final rawText = (blocks[i]['text'] ?? '').toString();
          final ctrl = TextEditingController(
            text: (rawText.isEmpty && blocks.length > 1)
                ? emptyTextSentinel
                : rawText,
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
          blockTableValueFocusNodes.add(null);
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
          blockTableValueFocusNodes.add(null);
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
          blockTableValueFocusNodes.add(rows.map((_) => FocusNode()).toList());
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
          blockTableValueFocusNodes.add(null);
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
                          controller?.text.replaceAll(emptyTextSentinel, '') ??
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
                        controller?.text.replaceAll(emptyTextSentinel, '') ??
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

              // BOŞ bir metin bloğunda (ör. notun en başındaki boş satır)
              // imleç konumu 0'dayken Geri (Backspace) tuşuna basılınca
              // çağrılır. Normalde TextField'ın kendi silme davranışı bu
              // durumda hiçbir şey yapmaz (silinecek karakter yok), bu yüzden
              // böyle boş bloklar hiç kaldırılamıyordu. Bu fonksiyon o boş
              // bloğu tamamen kaldırır ve imleci mantıklı bir yere taşır:
              // - Önceki blok metinse, imleç onun sonuna gider (sanki o
              //   satır gerçekten silinmiş gibi).
              // - Önceki blok metin değilse (ek/liste/tablo/çizim) ama
              //   silinen satırdan SONRA bir metin bloğu varsa, imleç onun
              //   başına gider.
              // - Notta bu tek blok kalıyorsa hiçbir şey yapılmaz (son blok
              //   asla silinmez, aksi halde yazılacak alan kalmaz).
              void removeEmptyTextBlockAndRefocus(int idx) {
                if (blocks.length <= 1) return;
                if (idx < 0 || idx >= blocks.length) return;
                if (blocks[idx]['type'] != 'text') return;
                pushUndoCheckpoint();
                setModalState(() {
                  blocks.removeAt(idx);
                  int newFocusIdx;
                  int caretOffset = 0;
                  if (idx > 0 && blocks[idx - 1]['type'] == 'text') {
                    newFocusIdx = idx - 1;
                    caretOffset = (blocks[idx - 1]['text'] ?? '')
                        .toString()
                        .length;
                  } else if (idx < blocks.length &&
                      blocks[idx]['type'] == 'text') {
                    newFocusIdx = idx;
                    caretOffset = 0;
                  } else {
                    newFocusIdx = idx.clamp(0, blocks.length - 1);
                    caretOffset = 0;
                  }
                  rebuildBlockControllers();
                  focusedBlockIndex = newFocusIdx;
                  final targetIdx = newFocusIdx;
                  final targetOffset = caretOffset;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (targetIdx >= 0 &&
                        targetIdx < blockControllers.length &&
                        blockControllers[targetIdx] != null &&
                        targetIdx < blockFocusNodes.length &&
                        blockFocusNodes[targetIdx] != null) {
                      blockFocusNodes[targetIdx]!.requestFocus();
                      final c = blockControllers[targetIdx]!;
                      c.selection = TextSelection.collapsed(
                        offset: targetOffset.clamp(0, c.text.length),
                      );
                    }
                  });
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

              // ── Blokların sırasını değiştirme: sağ üstteki üç nokta
              // menüsündeki "Blokları Sırala" seçeneğiyle açılan alt menü.
              // Kullanıcı önce taşımak istediği bloğa dokunup seçer, sonra
              // yukarı/aşağı ok düğmeleriyle o bloğu listede istediği yere
              // kaydırır. Sürükle-bırak yerine bu yöntem seçildi çünkü
              // bloklar (çizim, hesap tablosu, ek grubu gibi) kendi
              // içlerinde de dokunma/sürükleme hareketleri barındırıyor;
              // ayrı bir "seç -> taşı" alt menüsü bu çakışmayı önlüyor.
              String blockPreviewText(Map<String, dynamic> b) {
                switch (b['type']) {
                  case 'checklist':
                    final items = List<Map<String, dynamic>>.from(
                      b['items'] ?? const [],
                    );
                    final texts = items
                        .map((it) => (it['text'] ?? '').toString().trim())
                        .where((t) => t.isNotEmpty)
                        .toList();
                    return texts.isEmpty ? 'Kontrol Listesi' : texts.join(', ');
                  case 'calc_table':
                    final rows = List<Map<String, dynamic>>.from(
                      b['rows'] ?? const [],
                    );
                    return 'Hesap Tablosu (${rows.length} satır)';
                  case 'drawing':
                    return 'Çizim';
                  case 'attachments':
                    final ids = List.from(b['ids'] ?? const []);
                    return '${ids.length} ek (fotoğraf/belge)';
                  default:
                    final t = (b['text'] ?? '').toString().trim();
                    return t.isEmpty ? '(boş metin)' : t;
                }
              }

              IconData blockPreviewIcon(String type) {
                switch (type) {
                  case 'checklist':
                    return Icons.checklist;
                  case 'calc_table':
                    return Icons.calculate;
                  case 'drawing':
                    return Icons.draw;
                  case 'attachments':
                    return Icons.attach_file;
                  default:
                    return Icons.notes;
                }
              }

              // Boş bir metin bloğu mu (ör. iki blok arasındaki boş satır)?
              bool isEmptyTextBlock(Map<String, dynamic> b) =>
                  b['type'] == 'text' &&
                  (b['text'] ?? '').toString().trim().isEmpty;

              // Blokları, aralarındaki boş satırları yutan gruplara ayırır:
              // her grup, kendinden önce gelen ardışık boş satır(lar) +
              // tam olarak bir "görünür" (boş olmayan) blok içerir. Sondaki
              // boş satırlar (arkasında görünür blok yoksa) bir önceki gruba
              // eklenir. Böylece "Blokları Sırala" listesinde boş satırlar
              // ayrı satır olarak görünmez, ama bir blok taşınırken ona
              // bitişik boş satır(lar) da onunla birlikte taşınır.
              List<List<int>> computeBlockGroups() {
                final groups = <List<int>>[];
                var pending = <int>[];
                for (int idx = 0; idx < blocks.length; idx++) {
                  pending.add(idx);
                  if (!isEmptyTextBlock(blocks[idx])) {
                    groups.add(pending);
                    pending = [];
                  }
                }
                if (pending.isNotEmpty) {
                  if (groups.isNotEmpty) {
                    groups.last.addAll(pending);
                  } else {
                    groups.add(pending);
                  }
                }
                return groups;
              }

              // ── Blokların sırasını değiştirme: sağ üstteki üç nokta
              // menüsündeki "Blokları Sırala" seçeneğiyle açılan alt menü.
              // Kullanıcı önce taşımak istediği bloğa dokunup seçer, sonra
              // yukarı/aşağı ok düğmeleriyle o bloğu listede istediği yere
              // kaydırır. Sürükle-bırak yerine bu yöntem seçildi çünkü
              // bloklar (çizim, hesap tablosu, ek grubu gibi) kendi
              // içlerinde de dokunma/sürükleme hareketleri barındırıyor;
              // ayrı bir "seç -> taşı" alt menüsü bu çakışmayı önlüyor.
              void showBlockReorderSheet() {
                // Seçili GRUP indeksi (blocks listesindeki değil,
                // computeBlockGroups() sonucundaki indeks). Ana
                // düzenleyicinin `blocks` listesini doğrudan (referansla)
                // kullanır, böylece taşıma anında ana ekran da güncel kalır.
                int? selected;
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Theme.of(context).cardColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (sheetCtx) {
                    return StatefulBuilder(
                      builder: (sheetCtx, setSheetState) {
                        final groups = computeBlockGroups();

                        // Bir grubun önizlemede gösterilecek "görünür"
                        // bloğunu bulur (grup içindeki son boş-olmayan
                        // blok); tüm grup boşsa (yalnızca not tamamen boş
                        // satırlardan ibaretse görülebilir) son bloğa döner.
                        int anchorIndexOf(List<int> group) {
                          for (final idx in group.reversed) {
                            if (!isEmptyTextBlock(blocks[idx])) return idx;
                          }
                          return group.last;
                        }

                        void moveSelected(int delta) {
                          if (selected == null) return;
                          final from = selected!;
                          final to = from + delta;
                          if (to < 0 || to >= groups.length) return;
                          pushUndoCheckpoint();
                          setModalState(() {
                            final earlierGroup =
                                groups[math.min(from, to)];
                            final laterGroup = groups[math.max(from, to)];
                            final start = earlierGroup.first;
                            final earlierBlocks = earlierGroup
                                .map((i) => blocks[i])
                                .toList();
                            final laterBlocks = laterGroup
                                .map((i) => blocks[i])
                                .toList();
                            // İki bitişik grubun yerini değiştir; aralarında
                            // (varsa) grubun kendi içindeki boş satırlar da
                            // taşınan blokla birlikte gelir.
                            final combined = [...laterBlocks, ...earlierBlocks];
                            blocks.removeRange(
                              start,
                              start + earlierGroup.length + laterGroup.length,
                            );
                            blocks.insertAll(start, combined);
                            rebuildBlockControllers();
                          });
                          setSheetState(() => selected = to);
                        }

                        return SafeArea(
                          top: false,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(sheetCtx).size.height * 0.75,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    16,
                                    8,
                                    8,
                                  ),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'Blokları Sırala',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.amber,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        tooltip: 'Yukarı Taşı',
                                        icon: Icon(
                                          Icons.keyboard_arrow_up,
                                          color:
                                              selected != null && selected! > 0
                                              ? Colors.amber
                                              : Colors.grey,
                                        ),
                                        onPressed:
                                            selected != null && selected! > 0
                                            ? () => moveSelected(-1)
                                            : null,
                                      ),
                                      IconButton(
                                        tooltip: 'Aşağı Taşı',
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color:
                                              selected != null &&
                                                  selected! <
                                                      groups.length - 1
                                              ? Colors.amber
                                              : Colors.grey,
                                        ),
                                        onPressed:
                                            selected != null &&
                                                selected! < groups.length - 1
                                            ? () => moveSelected(1)
                                            : null,
                                      ),
                                      IconButton(
                                        tooltip: 'Kapat',
                                        icon: const Icon(Icons.close),
                                        onPressed: () =>
                                            Navigator.pop(sheetCtx),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                                  child: Text(
                                    'Taşımak istediğiniz bloğa dokunup seçin, '
                                    'sonra yukarı/aşağı ok ile taşıyın.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const Divider(height: 1),
                                Flexible(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    itemCount: groups.length,
                                    itemBuilder: (context, i) {
                                      final b = blocks[anchorIndexOf(groups[i])];
                                      final isSelected = selected == i;
                                      return Material(
                                        color: isSelected
                                            ? Colors.amber.withValues(
                                                alpha: 0.15,
                                              )
                                            : Colors.transparent,
                                        child: ListTile(
                                          leading: Icon(
                                            blockPreviewIcon(
                                              (b['type'] ?? 'text').toString(),
                                            ),
                                            color: Colors.amber,
                                          ),
                                          title: Text(
                                            blockPreviewText(b),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          trailing: isSelected
                                              ? const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.amber,
                                                )
                                              : null,
                                          onTap: () => setSheetState(
                                            () =>
                                                selected = isSelected ? null : i,
                                          ),
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
                );
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
                                  controller?.text.replaceAll(emptyTextSentinel, '') ??
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
                                  controller?.text.replaceAll(emptyTextSentinel, '') ??
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
                                  controller?.text.replaceAll(emptyTextSentinel, '') ??
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
                              autoOpenDrawingBlockIndex = idx + 1;
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
                          } else if (value == 'reorder_blocks') {
                            showBlockReorderSheet();
                          } else if (value == 'import_txt') {
                            // Üç nokta menüsünde "İçe Aktar (TXT)" öğesine
                            // basılınca çağrılır. Kullanıcıya bir .txt
                            // dosyası seçtirir; içeriği metin notlarında
                            // imlecin bulunduğu bloğa (OCR "sadece metin
                            // ekle" akışıyla birebir aynı desen), kontrol
                            // listesi notlarında ise her satırı ayrı bir
                            // öğe olarak ekler.
                            Future.microtask(() async {
                              String txtContent;
                              try {
                                final result = await FilePicker.platform
                                    .pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['txt'],
                                      dialogTitle:
                                          'İçe aktarılacak TXT dosyasını seç',
                                    );
                                final pickedPath = result?.files.single.path;
                                if (pickedPath == null) return;
                                if (!isEditorOpen) return;

                                final pickedFile = File(pickedPath);
                                try {
                                  txtContent = await pickedFile.readAsString();
                                } catch (_) {
                                  // UTF-8 olmayan (ör. Windows/ANSI) txt
                                  // dosyalarında düşülecek yedek çözüm.
                                  txtContent = latin1.decode(
                                    await pickedFile.readAsBytes(),
                                  );
                                }
                                txtContent = txtContent
                                    .replaceAll('\r\n', '\n')
                                    .trim();
                              } catch (_) {
                                if (mounted) {
                                  _showInfoBar(
                                    'TXT dosyası okunamadı',
                                    icon: Icons.error_outline,
                                  );
                                }
                                return;
                              }

                              if (txtContent.isEmpty) {
                                if (mounted) {
                                  _showInfoBar(
                                    'TXT dosyası boş',
                                    icon: Icons.error_outline,
                                  );
                                }
                                return;
                              }
                              if (!isEditorOpen) return;

                              if (noteType == 'checklist') {
                                final lines = txtContent
                                    .split('\n')
                                    .map((l) => l.trim())
                                    .where((l) => l.isNotEmpty)
                                    .toList();
                                if (lines.isEmpty) return;
                                pushUndoCheckpoint();
                                setModalState(() {
                                  for (final line in lines) {
                                    checkItems.add({
                                      'text': line,
                                      'checked': false,
                                    });
                                  }
                                });
                              } else {
                                pushUndoCheckpoint();
                                setModalState(() {
                                  // İmlecin bulunduğu metin bloğunu bul;
                                  // imleç orada yoksa son metin bloğuna, o da
                                  // yoksa yeni bir metin bloğuna eklenir
                                  // (diğer ekleme akışlarındaki aynı desen).
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
                                  final current =
                                      controller?.text.replaceAll(emptyTextSentinel, '') ??
                                      (blocks[idx]['text'] ?? '').toString();
                                  int offset =
                                      controller?.selection.baseOffset ?? -1;
                                  if (offset < 0 || offset > current.length) {
                                    offset = current.length;
                                  }
                                  final leftText = current.substring(
                                    0,
                                    offset,
                                  );
                                  final rightText = current.substring(offset);
                                  final needsLeadingNewline =
                                      leftText.isNotEmpty &&
                                      !leftText.endsWith('\n');
                                  final insertion =
                                      (needsLeadingNewline ? '\n' : '') +
                                      txtContent;
                                  final newLeft = leftText + insertion;
                                  blocks[idx]['text'] = newLeft + rightText;
                                  focusedBlockIndex = idx;
                                  rebuildBlockControllers();
                                  final newCaretOffset = newLeft.length;
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    final newIdx = focusedBlockIndex.clamp(
                                      0,
                                      blockControllers.length - 1,
                                    );
                                    final newCtrl = blockControllers[newIdx];
                                    if (newCtrl != null) {
                                      newCtrl.selection =
                                          TextSelection.collapsed(
                                            offset: newCaretOffset.clamp(
                                              0,
                                              newCtrl.text.length,
                                            ),
                                          );
                                    }
                                  });
                                });
                              }

                              if (mounted) {
                                _showInfoBar(
                                  'TXT içe aktarıldı',
                                  icon: Icons.check_circle_outline,
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
                          if (noteType == 'text' && blocks.length > 1)
                            const PopupMenuItem(
                              value: 'reorder_blocks',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.swap_vert,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Blokları Sırala'),
                                ],
                              ),
                            ),
                          if (noteType == 'text') const PopupMenuDivider(),
                          const PopupMenuItem(
                            value: 'import_txt',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.upload_file,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Expanded(child: Text('İçe Aktar (TXT)')),
                              ],
                            ),
                          ),
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
                                final valueFns =
                                    blockTableValueFocusNodes[i] ??
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
                                                textInputAction:
                                                    TextInputAction.next,
                                                // Bkz. aşağıdaki tutar alanı
                                                // için açıklama: Flutter'ın
                                                // TextInputAction.next
                                                // varsayılan odak değiştirme
                                                // davranışı devre dışı
                                                // bırakılıyor, aksi halde
                                                // Enter'a basınca klavye önce
                                                // kapanıp hemen ardından tekrar
                                                // açılıyordu.
                                                onEditingComplete: () {},
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
                                                onSubmitted: (_) {
                                                  if (j < valueFns.length) {
                                                    valueFns[j]
                                                        .requestFocus();
                                                  }
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
                                                focusNode: j < valueFns.length
                                                    ? valueFns[j]
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
                                                    valueFns.insert(
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
                                                final removedFocusNodes =
                                                    <FocusNode>[];
                                                if (j < labelFns.length) {
                                                  removedFocusNodes
                                                      .add(labelFns[j]);
                                                }
                                                if (j < valueFns.length) {
                                                  removedFocusNodes
                                                      .add(valueFns[j]);
                                                }
                                                for (final f
                                                    in removedFocusNodes) {
                                                  if (f.hasFocus) f.unfocus();
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
                                                    if (j < valueFns.length) {
                                                      valueFns.removeAt(j);
                                                    }
                                                  }
                                                });
                                                if (!tableRemoved &&
                                                    removedFocusNodes
                                                        .isNotEmpty) {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback((_) {
                                                    for (final f
                                                        in removedFocusNodes) {
                                                      f.dispose();
                                                    }
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
                                    autoOpenOnce:
                                        i == autoOpenDrawingBlockIndex,
                                    onAutoOpened: () =>
                                        autoOpenDrawingBlockIndex = null,
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
                                return Focus(
                                  onKeyEvent: (node, event) {
                                    // Yalnızca boş bir blokta, imleç en
                                    // başındayken Backspace'e basılırsa
                                    // devreye girer (bkz.
                                    // removeEmptyTextBlockAndRefocus). Diğer
                                    // tüm tuşlar/durumlar TextField'ın
                                    // normal davranışına bırakılır.
                                    if (event is! KeyDownEvent &&
                                        event is! KeyRepeatEvent) {
                                      return KeyEventResult.ignored;
                                    }
                                    if (event.logicalKey !=
                                        LogicalKeyboardKey.backspace) {
                                      return KeyEventResult.ignored;
                                    }
                                    final ctrl = blockControllers[i];
                                    if (ctrl == null ||
                                        ctrl.text.isNotEmpty) {
                                      return KeyEventResult.ignored;
                                    }
                                    final sel = ctrl.selection;
                                    if (!sel.isValid ||
                                        !sel.isCollapsed ||
                                        sel.baseOffset != 0) {
                                      return KeyEventResult.ignored;
                                    }
                                    if (blocks.length <= 1) {
                                      return KeyEventResult.ignored;
                                    }
                                    removeEmptyTextBlockAndRefocus(i);
                                    return KeyEventResult.handled;
                                  },
                                  child: TextField(
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
                                    // Bu blok daha önce mantıken boş muydu
                                    // (yalnızca görünmez işaretçi vardı)?
                                    final wasLogicallyEmpty =
                                        (block['text'] ?? '')
                                            .toString()
                                            .isEmpty;
                                    if (val.isEmpty) {
                                      if (wasLogicallyEmpty) {
                                        // Kullanıcı, boş bloktaki görünmez
                                        // işaretçiyi de sildi: bu artık
                                        // gerçek bir "1 karakter -> 0
                                        // karakter" silme olayı olduğundan
                                        // (yukarıdaki emptyTextSentinel
                                        // notuna bkz.) tüm klavyelerde
                                        // güvenilir şekilde buraya düşer.
                                        // Boş satırı sil isteği olarak ele
                                        // al.
                                        if (blocks.length > 1) {
                                          removeEmptyTextBlockAndRefocus(i);
                                        }
                                        return;
                                      }
                                      // Kullanıcı gerçek metni (ör. tümünü
                                      // seçip sildi) temizledi; blok kalsın,
                                      // sadece boşalt. Görünmez işaretçiyi
                                      // geri koyarak bir sonraki Backspace'in
                                      // yine algılanabilir olmasını sağla.
                                      block['text'] = '';
                                      blockControllers[i]!.value =
                                          const TextEditingValue(
                                        text: emptyTextSentinel,
                                        selection: TextSelection.collapsed(
                                          offset: emptyTextSentinel.length,
                                        ),
                                      );
                                      return;
                                    }
                                    final sentinelIndex =
                                        val.indexOf(emptyTextSentinel);
                                    if (sentinelIndex != -1) {
                                      // Kullanıcı gerçek yazmaya başladı:
                                      // görünmez işaretçiyi controller'ın
                                      // GÜNCEL değerinden de temizle; aksi
                                      // halde aşağıdaki otomatik hesaplama
                                      // gibi ham metni okuyan özellikler
                                      // görünmeyen karakteri de görür.
                                      final cleaned = val.replaceRange(
                                        sentinelIndex,
                                        sentinelIndex + 1,
                                        '',
                                      );
                                      final rawOffset = blockControllers[i]!
                                          .selection
                                          .baseOffset;
                                      final newOffset = rawOffset > sentinelIndex
                                          ? rawOffset - 1
                                          : rawOffset;
                                      blockControllers[i]!.value =
                                          TextEditingValue(
                                        text: cleaned,
                                        selection: TextSelection.collapsed(
                                          offset: newOffset.clamp(
                                            0,
                                            cleaned.length,
                                          ),
                                        ),
                                      );
                                      block['text'] = cleaned;
                                    } else {
                                      block['text'] = val;
                                    }
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
                                  ),
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
                                                _folderTagLabel(noteCategory!),
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
                                            controller?.text.replaceAll(emptyTextSentinel, '') ??
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
      for (final list in blockTableValueFocusNodes) {
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
      for (final list in blockTableValueFocusNodes) {
        if (list != null) {
          for (final f in list) {
            f.dispose();
          }
        }
      }
    });
  }
}
