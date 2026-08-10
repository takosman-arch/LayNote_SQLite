part of 'main.dart';

// ignore_for_file: unused_element

mixin NoteListActionsMixin on State<NoteListScreen> {
  // ---- Diğer mixin'lerde tanımlı, burada kullanılan üyeler ----
  String get _activeCategory;
  set _activeCategory(String value);
  List<String> get _categories;
  set _categories(List<String> value);
  Map<String, String> get _categoryColors;
  set _categoryColors(Map<String, String> value);
  List<Color> get _categoryPalette;
  Map<String, String?> get _categoryParents;
  set _categoryParents(Map<String, String?> value);
  Set<String> get _collapsedCategories;
  set _collapsedCategories(Set<String> value);
  List<Map<String, dynamic>> get _deletedNotes;
  set _deletedNotes(List<Map<String, dynamic>> value);
  void _enterSelectionMode(Map<String, dynamic> note);
  Color _getCategoryColor(String? category);
  String _getFormattedDate([DateTime? date]);
  double get _globalFontSize;
  set _globalFontSize(double value);
  DateTime? get _lastBackPressTime;
  set _lastBackPressTime(DateTime? value);
  String get _notePassword;
  set _notePassword(String value);
  bool get _notePasswordEnabled;
  set _notePasswordEnabled(bool value);
  List<Map<String, dynamic>> get _notes;
  set _notes(List<Map<String, dynamic>> value);
  String get _passwordHintAnswer;
  set _passwordHintAnswer(String value);
  String get _passwordHintQuestion;
  set _passwordHintQuestion(String value);
  Future<void> _saveData();
  Future<void> _showNoteDialog({ int? index, String type = 'text', String? initialText, bool openInstantly = false, });
  Future<_ReminderPickResult?> _showReminderPickerDialog({ required BuildContext context, required DateTime initialDateTime, String? initialRepeat, });
  OverlayEntry? get _snackOverlay;
  set _snackOverlay(OverlayEntry? value);
  Timer? get _snackTimer;
  set _snackTimer(Timer? value);
  Color? get _textColor;
  set _textColor(Color? value);
  TextEditingController get _titleController;


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

    _showInfoBar(
      'Not silindi',
      icon: Icons.delete_outline,
      actionLabel: 'Geri Getir',
      onAction: () {
        setState(() {
          _notes.add(deletedNote);
          _deletedNotes.removeWhere((n) => n['id'] == deletedNote['id']);
        });
        _saveData();
      },
    );
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
    Color backgroundColor = const Color(0xFF3D3D3D),
  }) {
    _hideDeletedBar();
    final hasAction = actionLabel != null && onAction != null;
    _snackOverlay = OverlayEntry(
      builder: (ctx) => Positioned(
        // FAB: alt kenardan 16 boşluk + 56 yükseklik = 72. Üstüne 16 daha
        // boşluk bırakarak bildirim, artı butonunu kapatmasın.
        bottom: MediaQuery.of(ctx).padding.bottom + 72 + 16,
        left: 0,
        right: 0,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
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
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('PDF hatası (debug)'),
            content: SingleChildScrollView(
              child: SelectableText('$e\n\n$st'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kapat'),
              ),
            ],
          ),
        );
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
  Future<void> _openNoteWithPasswordCheck(
    int index, {
    bool openInstantly = false,
  }) async {
    if (index < 0 || index >= _notes.length) return;
    // await: bu Future artık editör KAPANANA (Navigator.pop) kadar
    // tamamlanmıyor (bkz. note_list_note_dialog_mixin.dart ->
    // _showNoteDialog, artık push'un Future'ını return ediyor). Önceden
    // burada await/return olmadığından, bu fonksiyonu bekleyen çağıranlar
    // (ör. Gündem ekranının onOpenNote'u) editör açılır açılmaz "bitti"
    // sanıp erken setState çağırıyordu.
    await _showNoteDialog(index: index, openInstantly: openInstantly);
  }

  // ── Ayarlar Sayfası ────────────────────────────────────────
  void _openSettings() {
    Navigator.pop(context); // drawer'ı kapat
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => SettingsPage(state: this as _NoteListScreenState)));
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
      _showInfoBar(
        'Parola yanlış.',
        icon: Icons.lock_outline,
        backgroundColor: Colors.red,
      );
    }
  }

  void _hideDeletedBar() {
    _snackTimer?.cancel();
    _snackOverlay?.remove();
    _snackOverlay = null;
    _snackTimer = null;
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
    // Verilirse, oluşturulacak yeni kategori bu kategorinin altında bir
    // "alt klasör" olarak kaydedilir. Sadece yeni ekleme için geçerlidir
    // (düzenlemede mevcut üst/alt bağlantısı zaten korunur).
    String? parentCategory,
  }) {
    final isEditing = editingCategory != null;
    final isSubfolder =
        parentCategory != null ||
        (isEditing && _categoryParents[editingCategory] != null);
    final controller = TextEditingController(
      text: isEditing ? editingCategory : '',
    );
    Color selectedColor = isEditing
        ? _getCategoryColor(editingCategory)
        : (parentCategory != null
              // Alt klasör oluşturulurken, renk seçme özelliği korunur
              // (kullanıcı dilerse aşağıdan farklı bir renk seçebilir) ama
              // başlangıç rengi üst klasörle aynı olur.
              ? _getCategoryColor(parentCategory)
              : _categoryPalette[_categories.length % _categoryPalette.length]);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: dNoteCardColor(context),
          title: Text(
            isEditing
                ? 'Kategoriyi Düzenle'
                : (isSubfolder ? 'Yeni Alt Klasör' : 'Yeni Kategori'),
            style: const TextStyle(color: Colors.amber),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isEditing && parentCategory != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    '"$parentCategory" içinde oluşturulacak',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              TextField(
                selectionWidthStyle: ui.BoxWidthStyle.tight,
                contextMenuBuilder: buildCustomContextMenu,
                selectionHeightStyle: ui.BoxHeightStyle.max,
                controller: controller,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: isSubfolder ? 'Alt klasör adı' : 'Kategori adı',
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
                      // Bu kategorinin üst/alt klasör bağlantısını yeni
                      // isme taşı: kendisi bir alt klasörse üst kategorisini
                      // koru; bir üst klasörse altındaki alt klasörlerin
                      // ebeveyn referansını güncelle.
                      final oldParent = _categoryParents.remove(
                        editingCategory,
                      );
                      if (oldParent != null) {
                        _categoryParents[name] = oldParent;
                      }
                      for (final entry in _categoryParents.entries.toList()) {
                        if (entry.value == editingCategory) {
                          _categoryParents[entry.key] = name;
                        }
                      }
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
                      if (parentCategory != null) {
                        _categoryParents[name] = parentCategory;
                        // Üst klasör daraltılmışsa (alt klasörleri gizliyse)
                        // yeni oluşturulan alt klasörün görünür olması için
                        // otomatik olarak genişlet.
                        _collapsedCategories.remove(parentCategory);
                      }
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
      builder: (sheetContext) {
        // Tek bir kategori satırını (üst klasör ya da alt klasör) çizen
        // yardımcı fonksiyon. Alt klasörler (isSub) girintili ve daha küçük
        // bir "dallanma" ikonuyla gösterilerek üst klasörün altında
        // hiyerarşik bir görünüm oluşturur.
        Widget buildCategoryTile(String cat, {required bool isSub}) {
          final isSelected = currentCategory == cat;
          final catColor = _getCategoryColor(cat);
          // Görünüm ana menü çekmecesindeki (_buildCategoryDrawerTile)
          // klasör satırlarıyla BİREBİR aynı desende: büyük üst klasör (sol
          // boşluk 16, ikon 24, yazı boyutu varsayılan), girintili küçük
          // alt klasör (sol boşluk 40, ikon 20, yazı boyutu 14). Alt
          // klasörler de artık çekmecedeki gibi aynı folder_outlined
          // ikonunu kullanıyor (eskiden burada ayrı bir "dallanma" oku
          // ikonu vardı). İkon rengi seçili olmayan durumda da
          // SOLUKLAŞTIRILMAZ (drawer'da da yok).
          return ListTile(
            contentPadding: EdgeInsets.only(
              left: isSub ? 40 : 16,
              right: 16,
            ),
            leading: Icon(
              Icons.folder_outlined,
              size: isSub ? 20 : 24,
              color: catColor,
            ),
            title: Text(
              cat,
              style: TextStyle(
                fontSize: isSub ? 14 : null,
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
        }

        return SafeArea(
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
                    children: [
                      // Önce üst seviye (ebeveyni olmayan) klasörler, hemen
                      // ardından da o klasöre ait alt klasörler girintili
                      // olarak listelenir; böylece düz alfabetik liste
                      // yerine klasör/alt klasör hiyerarşisi görünür olur.
                      for (final cat in _categories.where(
                        (c) => _categoryParents[c] == null,
                      )) ...[
                        buildCategoryTile(cat, isSub: false),
                        for (final sub in _categories.where(
                          (c) => _categoryParents[c] == cat,
                        ))
                          buildCategoryTile(sub, isSub: true),
                      ],
                    ],
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
        );
      },
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
        'icon': Icons.delete_outline,
        'label': 'Sil',
        'color': Colors.red,
        'key': 'delete',
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
        'color': Colors.deepPurple,
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
                        final willArchive =
                            !(_notes[noteIndex]['isArchived'] == true);
                        setState(() {
                          _notes[noteIndex]['isArchived'] = willArchive;
                        });
                        _saveData();
                        _showInfoBar(
                          willArchive ? 'Not arşivlendi' : 'Arşivden çıkarıldı',
                          icon: willArchive
                              ? Icons.archive_outlined
                              : Icons.unarchive_outlined,
                        );
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
                            _showInfoBar(
                              'Boş not sabitlenemez.',
                              icon: Icons.push_pin_outlined,
                              backgroundColor: Colors.red,
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
    // Not arka plan rengi (palet ikonundan seçilir, null = varsayılan/
    // kategori rengi). Eskiden bu alan burada değil, çağıran taraftaki
    // (NoteListNoteDialogMixin) üç ayrı kayıt noktasında notu _notes
    // listesine yazdıktan HEMEN SONRA elle _notes[..]['bgColor'] = ...
    // şeklinde işlenip ayrıca _saveData() çağrılıyordu. Artık tek
    // kaynaktan (burada) hem state'e yazılıyor hem de zaten çağrılan
    // _saveData() ile diske kaydediliyor; çağıran tarafta ekstra kayıt
    // adımına gerek kalmadı.
    int? bgColor,
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

        final oldBgColor = _notes[index]['bgColor'] as int?;
        final bgColorChanged = oldBgColor != bgColor;

        final hasChanges =
            newTitle != oldTitle ||
            contentChanged ||
            noteType != oldType ||
            checkItemsChanged ||
            attachmentsChanged ||
            reminderChanged ||
            assignedDateChanged ||
            bgColorChanged;

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
            'bgColor': bgColor,
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
            'assignedDate': assignedDate?.toIso8601String(),
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
            'bgColor': bgColor,
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
        _showInfoBar(
          'Çıkmak için tekrar geri tuşuna basın',
          icon: Icons.arrow_back,
        );
      }
      return false;
    }
    SystemNavigator.pop();
    return true;
  }
}
