part of 'main.dart';

// ignore_for_file: unused_element

mixin NoteListNoteDialogMixin on State<NoteListScreen> {
  // ---- Diğer mixin'lerde tanımlı, burada kullanılan üyeler ----
  Widget _buildAttachmentGrid({ required List<String> ids, required List<Map<String, dynamic>> attachmentsList, required void Function(String id) onRemove, required void Function(Map<String, dynamic> att) onOpen, required String? deletingId, required void Function(String? id) onDeletingIdChanged, });
  Widget _buildDocPreview(Map<String, dynamic> att, String filePath);
  // Çekmecede seçili aktif kategori ('__reminders__' = Hatırlatıcı bölümü).
  // Gerçek tanımı NoteListDataCategoryMixin'de; burada sadece bu mixin'in
  // erişebilmesi için abstract olarak bildiriliyor.
  String get _activeCategory;
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
  bool _saveNoteIfValid( int? index, String noteType, List<Map<String, dynamic>> checkItems, [ List<Map<String, dynamic>> attachments = const [], List<Map<String, dynamic>> blocks = const [], DateTime? reminder, DateTime? assignedDate, String? reminderRepeat, int? bgColor, ]);
  // Not arka plan rengi (noteBgColor), artık _saveNoteIfValid'in son
  // parametresi (bgColor) olarak doğrudan geçirilir (gerçek gövde bu
  // dosyada değil, NoteListActionsMixin'de tanımlı). Notu _notes
  // listesine yazma ve _saveData() ile diske kaydetme işlemleri tek
  // yerde, o fonksiyonun içinde yapılır; aşağıdaki çağrı noktalarında
  // ayrıca elle bgColor yazıp _saveData() çağırmaya gerek yoktur.
  Future<void> _saveData();
  void _showAddAttachmentSheet( BuildContext ctx, { required void Function(String value) onSelected, });
  void _showClassifyDialog(int noteIndex, {void Function(String?)? onChanged});
  Future<void> _showExportSubmenu({ required BuildContext context, required GlobalKey anchorKey, required String title, required String noteType, required List<Map<String, dynamic>> blocks, required List<Map<String, dynamic>> checkItems, required List<Map<String, dynamic>> attachments, double fontSize = 16.0, });
  void _showInfoBar( String message, { IconData icon = Icons.check_circle, String? actionLabel, VoidCallback? onAction, });
  void _showNoteActions( BuildContext ctx, int noteIndex, bool isTrash, { DateTime? editorReminder, String? editorReminderRepeat, void Function(DateTime? reminder, String? repeat)? onReminderChanged, VoidCallback? onDiscard, void Function(String text)? onInsertText, bool showSelectAction = false, });
  Color? get _textColor;
  set _textColor(Color? value);
  TextEditingController get _titleController;
  void dispose();

  // ── DÜZELTME (çökme): text.lastIndexOf('\n', X) çağrısında X negatif
  // olursa (imleç satırın/metnin en başındayken X = cursor - 1 ya da
  // cursor - 2 formülüyle -1'e düşebiliyordu) Dart RangeError fırlatıyordu.
  // lastIndexOf zaten "bulunamadı" durumunda -1 döndürdüğünden, negatif X
  // için de doğrudan -1 döndürülüyor; hemen ardından yapılan "+ 1" bu
  // durumda 0'a (metnin/satırın başına) düşüyor — ki zaten doğrusu bu.
  int _safeLastNewlineIndex(String text, int before) {
    if (before < 0) return -1;
    return text.lastIndexOf('\n', before);
  }

  void _showNoteDialog({
    int? index,
    String type = 'text',
    // Başka bir uygulamadan paylaşılan link/metin buraya gelir; yalnızca
    // yeni not oluştururken (index == null) kullanılır.
    String? initialText,
    // Takvim ekranından "bu güne not ekle" ile açıldığında, notun
    // varsayılan olarak atanacağı gün. Yalnızca yeni not oluştururken
    // (index == null) kullanılır; düzenlemede notun kendi tarihi
    // (satır ~2425'teki yükleme) geçerlidir ve bu değeri ezer.
    DateTime? initialAssignedDate,
  }) {
    // Diyalog KAPANIRKEN "yeni not oluşturma akışıydı mı?" kontrolü için.
    // `index` parametresi diyalog içinde (kategori seçilirken, bkz. aşağıda
    // ~satır 5360) güncellenebildiğinden, bu bilgiyi en başta sabitliyoruz.
    final bool isNewNote = index == null;
    // Hatırlatıcı penceresi bir kez gösterildikten sonra (kullanıcı seçim
    // yapsın ya da iptal etsin), bir SONRAKİ geri basışta artık tekrar
    // sorulmadan normal kaydet+çık akışına devam edilir.
    bool reminderPromptShown = false;
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
    DateTime noteAssignedDate = initialAssignedDate ?? DateTime.now();

    // ── İçerik blokları (metin + araya eklenen fotoğraf/belge grupları) ──
    List<Map<String, dynamic>> blocks = [];
    List<TextEditingController?> blockControllers = [];
    List<FocusNode?> blockFocusNodes = [];
    int focusedBlockIndex = 0;
    // Odaklı blok bir 'checklist' bloğuysa, o blok içindeki HANGİ maddenin
    // odaklı olduğunu tutar (metin bloklarında ve odak yokken -1). Kalın/
    // italik/vb. araç çubuğu, hangi span listesini değiştireceğini bu ikisi
    // (focusedBlockIndex + focusedItemIndex) ile bulur.
    int focusedItemIndex = -1;
    // DÜZELTME (kalın/italik butonuna basıp SONRA yazınca uygulanmıyordu):
    // eskiden _toggleSpanAttribute yalnızca seçili metin varken bir şey
    // yapıyordu; imleç tek noktadaysa (seçim yoksa) sessizce hiçbir şey
    // yapmadan çıkıyordu. Word/Google Docs'taki gibi, seçim yokken butona
    // basmak "bundan sonra yazılacak karakterlere uygula" anlamına
    // gelmeli. Bu iki bayrak o "bekleyen" durumu tutar; _toggleSpanAttribute
    // seçim yokken bunları açıp kapatır, metin bloğunun onChanged'i ise
    // (_shiftSpansForTextChange üzerinden) yeni yazılan karakter aralığına
    // bunları uygular. Odak başka bir bloğa geçtiğinde sıfırlanır (aşağıda
    // ilgili onTap'lerde).
    bool pendingBold = false;
    bool pendingItalic = false;
    bool pendingUnderline = false;
    bool pendingStrikethrough = false;
    bool pendingHighlight = false;
    // Araç çubuğundaki "Liste" butonuna basılınca, ana araç çubuğu satırı
    // yerine madde/numara işareti seçeneklerini içeren bir ALT BAR
    // gösterilir (bkz. aşağıdaki araç çubuğu Row'u). X ikonuna basılınca
    // ya da odak değiştiğinde ana bara geri dönülür.
    bool showListSubToolbar = false;
    // Aynı desen: "Kalın" butonuna basılınca kalın/italik/altı çizili/üzeri
    // çizili seçeneklerini içeren ayrı bir ALT BAR açılır. İki alt bar aynı
    // anda gösterilmez — biri açılırken diğeri kapatılır (bkz. aşağıdaki
    // onPressed'ler).
    bool showStyleSubToolbar = false;
    // Aynı desen: "Yazı Rengi" butonuna basılınca renk seçeneklerini
    // içeren ayrı bir ALT BAR açılır (eskiden bottom sheet içindeydi,
    // artık Liste/Stil alt barlarıyla aynı yerleşimi kullanıyor). Dört alt
    // bardan (Liste/Stil/Renk/Yazı Boyutu) aynı anda yalnızca biri
    // gösterilir.
    bool showColorSubToolbar = false;
    // Aynı desen: "Yazı Boyutu" butonuna basılınca da (eskiden
    // showModalBottomSheet ile ayrı bir sayfa olarak açılıyordu, bkz.
    // showTextPropertiesSheet) artık Liste/Stil/Renk alt barlarıyla aynı
    // yerleşimde, ana araç çubuğu Row'unun yerini alan bir ALT BAR
    // gösterilir. X ikonuna basılınca ya da odak değiştiğinde ana bara
    // geri dönülür.
    bool showFontSizeSubToolbar = false;
    // Boyut/renk/yazı tipi ailesi bold/italic/underline'ın aksine AÇ/KAPA
    // değil DEĞER bazlıdır: null "bekleyen özel bir değer yok" demektir.
    // Seçim yokken bir picker'dan değer seçilirse buraya yazılır ve
    // _shiftSpansForTextChange bir sonraki yazılan karaktere uygular
    // (bkz. yukarıdaki pendingBold açıklaması — aynı "önce butona bas,
    // sonra yaz" akışı).
    double? pendingFontSize;
    int? pendingColor;
    String? pendingFontFamily;
    // Notun arka plan rengi (span/seçimden bağımsız, NOT düzeyinde tek
    // değer). null = varsayılan (kategori/tema rengi). "Yazı Rengi"
    // ikonundan hemen sonraki palet ikonuyla değiştirilir (bkz. aşağıdaki
    // ana araç çubuğu Row'u ve showBgColorSubToolbar alt barı).
    int? noteBgColor;
    bool showBgColorSubToolbar = false;
    void Function(VoidCallback)? requestEditorRebuild;
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

    // (Kaldırıldı) Checklist bloğu özelliği tamamen kaldırıldığı için,
    // burada tanımlı olan checklist madde controller/focus node fabrika
    // fonksiyonları da kaldırıldı.

    // Bir controller'da imleç TEK NOKTADAYKEN (seçim yokken), o konumdaki
    // GERÇEK yazı boyutunu döndürür — yani "buradan yazmaya devam edilirse
    // hangi boyut kullanılırdı" sorusunun cevabı. Kural: imlecin SOLUNDAKİ
    // karakterin boyutuna bakılır (çoğu editörde de yazma davranışı budur);
    // imleç metnin en başındaysa (offset == 0) SAĞINDAKİ ilk karaktere
    // bakılır. Metin tamamen boşsa null (varsayılan) döner.
    // (rebuildBlockControllers'tan ÖNCE tanımlanmalı: Dart'ta yerel
    // fonksiyonlar, kullanıldıkları yerden önce tanımlanmış olmak zorunda.)
    double? _fontSizeAtCollapsedCursor(
      TextEditingController controller,
      List? spans,
    ) {
      final text = controller.text;
      final offset = controller.selection.baseOffset;
      if (offset < 0 || text.isEmpty) return null;
      final int rangeStart;
      final int rangeEnd;
      if (offset > 0) {
        rangeStart = offset - 1;
        rangeEnd = offset;
      } else {
        rangeStart = 0;
        rangeEnd = 1;
      }
      if (rangeEnd > text.length) return null;
      return RichTextSpans.getEffectiveFontSize(
        spans,
        text.length,
        rangeStart,
        rangeEnd,
      );
    }

    // Blok listesi değiştiğinde (ekleme/silme/birleştirme) controller ve
    // focus node'ları tamamen yeniden kurar. Metin bloğu olmayan (ek)
    // konumlar için null tutulur.
    void rebuildBlockControllers() {
      // Not listesi her zaman bir metin bloğuyla bitmelidir.
      if (blocks.isEmpty || blocks.last['type'] != 'text') {
        blocks.add({'type': 'text', 'text': ''});
      }

      // ── Diff tabanlı güncelleme ──────────────────────────────────────────
      // Eski yaklaşım tüm controller/node'ları atıp sıfırdan kuruyordu; bu
      // sırada odaklı node dispose edilince klavye kapanıyordu. Yeni yaklaşım:
      // mevcut blok listesini yeni blok listesiyle karşılaştırır, aynı tip ve
      // konumdaki blokların controller/node'larını KORUR, sadece eklenen veya
      // tip değişen konumlar için yenisini oluşturur. Klavye hiç kapanmaz çünkü
      // odaklı node hiç dispose edilmez — o blok korunur.

      // Eski listeleri sakla.
      final prevControllers        = List<TextEditingController?>.from(blockControllers);
      final prevFocusNodes         = List<FocusNode?>.from(blockFocusNodes);
      final prevItemControllers    = List<List<TextEditingController>?>.from(blockItemControllers);
      final prevItemFocusNodes     = List<List<FocusNode>?>.from(blockItemFocusNodes);
      final prevLabelControllers   = List<List<TextEditingController>?>.from(blockTableLabelControllers);
      final prevValueControllers   = List<List<TextEditingController>?>.from(blockTableValueControllers);
      final prevLabelFocusNodes    = List<List<FocusNode>?>.from(blockTableLabelFocusNodes);
      final prevValueFocusNodes    = List<List<FocusNode>?>.from(blockTableValueFocusNodes);

      // Yeni listeler.
      blockControllers             = [];
      blockFocusNodes              = [];
      blockItemControllers         = [];
      blockItemFocusNodes          = [];
      blockTableLabelControllers   = [];
      blockTableValueControllers   = [];
      blockTableLabelFocusNodes    = [];
      blockTableValueFocusNodes    = [];

      // Kullanılan (korunan) eski node'ları takip et — bunlar dispose edilmez.
      final usedControllers  = <TextEditingController>{};
      final usedFocusNodes   = <FocusNode>{};

      for (int i = 0; i < blocks.length; i++) {
        final type = blocks[i]['type'] as String?;
        final prevType = i < prevControllers.length
            ? (i < prevFocusNodes.length && prevFocusNodes[i] != null
                ? 'text'
                : (i < prevItemFocusNodes.length && prevItemFocusNodes[i] != null
                    ? 'checklist'
                    : (i < prevLabelFocusNodes.length && prevLabelFocusNodes[i] != null
                        ? 'calc_table'
                        : 'other')))
            : null;

        if (type == 'text') {
          // Aynı konumda daha önce de metin bloğu varsa controller'ı koru,
          // sadece metnini güncelle. Focus node'u her zaman koru.
          TextEditingController ctrl;
          FocusNode fn;
          final capturedIndex = i;

          if (prevType == 'text' &&
              i < prevControllers.length &&
              prevControllers[i] != null &&
              i < prevFocusNodes.length &&
              prevFocusNodes[i] != null) {
            // Mevcut controller'ı koru; metnini senkronla.
            ctrl = prevControllers[i]!;
            fn   = prevFocusNodes[i]!;
            usedControllers.add(ctrl);
            usedFocusNodes.add(fn);
            final rawText = (blocks[i]['text'] ?? '').toString();
            final newText = (rawText.isEmpty && blocks.length > 1)
                ? emptyTextSentinel
                : rawText;
            if (ctrl.text != newText) {
              ctrl.text = newText;
            }
          } else {
            // Yeni blok veya tip değişti → yeni controller + node oluştur.
            final rawText = (blocks[i]['text'] ?? '').toString();
            int? lastSyncedOffset;
            String? lastSyncedText;
            ctrl = RichBlockTextController(
              text: (rawText.isEmpty && blocks.length > 1)
                  ? emptyTextSentinel
                  : rawText,
              getSpans: () => RichTextSpans.parse(
                blocks[capturedIndex]['spans'],
              ),
            );
            ctrl.addListener(() {
              final sel = ctrl.selection;
              if (!sel.isValid || !sel.isCollapsed) return;
              final currentText = ctrl.text;
              final sameText = currentText == lastSyncedText;
              final offsetChanged = sel.baseOffset != lastSyncedOffset;
              final hadPrevious = lastSyncedText != null;
              lastSyncedText = currentText;
              lastSyncedOffset = sel.baseOffset;
              if (hadPrevious && sameText && offsetChanged) {
                final newSize = _fontSizeAtCollapsedCursor(
                  ctrl,
                  RichTextSpans.parse(blocks[capturedIndex]['spans']),
                );
                if (pendingFontSize != newSize) {
                  pendingFontSize = newSize;
                  requestEditorRebuild?.call(() {});
                }
              }
            });
            fn = FocusNode();
            fn.addListener(() {
              if (fn.hasFocus) {
                focusedBlockIndex = capturedIndex;
                focusedItemIndex = -1;
                final sel = ctrl.selection;
                if (sel.isValid && sel.isCollapsed) {
                  lastSyncedText = ctrl.text;
                  lastSyncedOffset = sel.baseOffset;
                  pendingFontSize = _fontSizeAtCollapsedCursor(
                    ctrl,
                    RichTextSpans.parse(blocks[capturedIndex]['spans']),
                  );
                }
              }
              requestEditorRebuild?.call(() {});
            });
          }

          blockControllers.add(ctrl);
          blockFocusNodes.add(fn);
          blockItemControllers.add(null);
          blockItemFocusNodes.add(null);
          blockTableLabelControllers.add(null);
          blockTableValueControllers.add(null);
          blockTableLabelFocusNodes.add(null);
          blockTableValueFocusNodes.add(null);

        } else if (type == 'calc_table') {
          final rows = List<Map<String, dynamic>>.from(
            blocks[i]['rows'] ?? const [],
          );

          List<TextEditingController> labelCtrls;
          List<TextEditingController> valueCtrls;
          List<FocusNode> labelFns;
          List<FocusNode> valueFns;

          if (prevType == 'calc_table' &&
              i < prevLabelControllers.length &&
              prevLabelControllers[i] != null) {
            // Aynı konumdaki tablo: mevcut controller/node'ları koru,
            // sayı değiştiyse farkı uygula.
            final oldLabelCtrls = prevLabelControllers[i]!;
            final oldValueCtrls = prevValueControllers[i]!;
            final oldLabelFns   = prevLabelFocusNodes[i]!;
            final oldValueFns   = prevValueFocusNodes[i]!;

            labelCtrls = [];
            valueCtrls = [];
            labelFns   = [];
            valueFns   = [];

            for (int j = 0; j < rows.length; j++) {
              if (j < oldLabelCtrls.length) {
                final lc = oldLabelCtrls[j];
                final vc = oldValueCtrls[j];
                final lf = oldLabelFns[j];
                final vf = oldValueFns[j];
                final labelText = (rows[j]['label'] ?? '').toString();
                final valueText = (rows[j]['value'] ?? '').toString();
                if (lc.text != labelText) lc.text = labelText;
                if (vc.text != valueText) vc.text = valueText;
                labelCtrls.add(lc);
                valueCtrls.add(vc);
                labelFns.add(lf);
                valueFns.add(vf);
                usedControllers..add(lc)..add(vc);
                usedFocusNodes..add(lf)..add(vf);
              } else {
                labelCtrls.add(TextEditingController(text: (rows[j]['label'] ?? '').toString()));
                valueCtrls.add(TextEditingController(text: (rows[j]['value'] ?? '').toString()));
                labelFns.add(FocusNode());
                valueFns.add(FocusNode());
              }
            }
          } else {
            labelCtrls = rows.map((r) => TextEditingController(text: (r['label'] ?? '').toString())).toList();
            valueCtrls = rows.map((r) => TextEditingController(text: (r['value'] ?? '').toString())).toList();
            labelFns   = rows.map((_) => FocusNode()).toList();
            valueFns   = rows.map((_) => FocusNode()).toList();
          }

          blockTableLabelControllers.add(labelCtrls);
          blockTableValueControllers.add(valueCtrls);
          blockTableLabelFocusNodes.add(labelFns);
          blockTableValueFocusNodes.add(valueFns);
          blockControllers.add(null);
          blockFocusNodes.add(null);
          blockItemControllers.add(null);
          blockItemFocusNodes.add(null);

        } else if (type == 'checklist') {
          final items = List<Map<String, dynamic>>.from(
            blocks[i]['items'] ?? const [],
          );
          final capturedBlockIndex = i;

          List<TextEditingController> itemCtrls;
          List<FocusNode> itemFns;

          if (prevType == 'checklist' &&
              i < prevItemControllers.length &&
              prevItemControllers[i] != null) {
            // Aynı konumdaki checklist: mevcut controller/node'ları koru.
            final oldCtrls = prevItemControllers[i]!;
            final oldFns   = prevItemFocusNodes[i]!;

            itemCtrls = [];
            itemFns   = [];

            for (int j = 0; j < items.length; j++) {
              final capturedItemIndex = j;
              if (j < oldCtrls.length) {
                final ctrl = oldCtrls[j];
                final fn   = oldFns[j];
                final newText = (items[j]['text'] ?? '').toString();
                if (ctrl.text != newText) ctrl.text = newText;
                itemCtrls.add(ctrl);
                itemFns.add(fn);
                usedControllers.add(ctrl);
                usedFocusNodes.add(fn);
              } else {
                // Yeni eklenen madde.
                final capturedItem = items[j];
                final ctrl = RichBlockTextController(
                  text: (capturedItem['text'] ?? '').toString(),
                  getSpans: () {
                    if (capturedBlockIndex >= blocks.length) return [];
                    final blk = blocks[capturedBlockIndex];
                    if (blk['type'] != 'checklist') return [];
                    final its = blk['items'] as List?;
                    if (its == null || capturedItemIndex >= its.length) return [];
                    return RichTextSpans.parse((its[capturedItemIndex] as Map)['spans']);
                  },
                );
                final fn = FocusNode();
                fn.addListener(() {
                  if (fn.hasFocus) {
                    focusedBlockIndex = capturedBlockIndex;
                    focusedItemIndex  = capturedItemIndex;
                    requestEditorRebuild?.call(() {});
                  }
                });
                itemCtrls.add(ctrl);
                itemFns.add(fn);
              }
            }
          } else {
            // Yeni checklist bloğu — her şeyi sıfırdan kur.
            itemCtrls = [];
            itemFns   = [];
            for (int j = 0; j < items.length; j++) {
              final capturedItemIndex = j;
              final capturedItem = items[j];
              final ctrl = RichBlockTextController(
                text: (capturedItem['text'] ?? '').toString(),
                getSpans: () {
                  if (capturedBlockIndex >= blocks.length) return [];
                  final blk = blocks[capturedBlockIndex];
                  if (blk['type'] != 'checklist') return [];
                  final its = blk['items'] as List?;
                  if (its == null || capturedItemIndex >= its.length) return [];
                  return RichTextSpans.parse((its[capturedItemIndex] as Map)['spans']);
                },
              );
              final fn = FocusNode();
              fn.addListener(() {
                if (fn.hasFocus) {
                  focusedBlockIndex = capturedBlockIndex;
                  focusedItemIndex  = capturedItemIndex;
                  requestEditorRebuild?.call(() {});
                }
              });
              itemCtrls.add(ctrl);
              itemFns.add(fn);
            }
          }

          blockItemControllers.add(itemCtrls);
          blockItemFocusNodes.add(itemFns);
          blockControllers.add(null);
          blockFocusNodes.add(null);
          blockTableLabelControllers.add(null);
          blockTableValueControllers.add(null);
          blockTableLabelFocusNodes.add(null);
          blockTableValueFocusNodes.add(null);

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

      // Artık kullanılmayan eski controller/node'ları dispose et.
      // Bunlar focus'ta olmayan node'lar olduğundan klavye etkilenmez.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (final c in prevControllers.whereType<TextEditingController>()) {
          if (!usedControllers.contains(c)) c.dispose();
        }
        for (final list in prevItemControllers) {
          if (list == null) continue;
          for (final c in list) {
            if (!usedControllers.contains(c)) c.dispose();
          }
        }
        for (final list in prevLabelControllers) {
          if (list == null) continue;
          for (final c in list) {
            if (!usedControllers.contains(c)) c.dispose();
          }
        }
        for (final list in prevValueControllers) {
          if (list == null) continue;
          for (final c in list) {
            if (!usedControllers.contains(c)) c.dispose();
          }
        }
        for (final f in prevFocusNodes.whereType<FocusNode>()) {
          if (!usedFocusNodes.contains(f)) {
            if (f.hasFocus) f.unfocus();
            f.dispose();
          }
        }
        for (final list in prevItemFocusNodes) {
          if (list == null) continue;
          for (final f in list) {
            if (!usedFocusNodes.contains(f)) {
              if (f.hasFocus) f.unfocus();
              f.dispose();
            }
          }
        }
        for (final list in prevLabelFocusNodes) {
          if (list == null) continue;
          for (final f in list) {
            if (!usedFocusNodes.contains(f)) {
              if (f.hasFocus) f.unfocus();
              f.dispose();
            }
          }
        }
        for (final list in prevValueFocusNodes) {
          if (list == null) continue;
          for (final f in list) {
            if (!usedFocusNodes.contains(f)) {
              if (f.hasFocus) f.unfocus();
              f.dispose();
            }
          }
        }
      });
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

    // Kalın/italik/vb. araç çubuğu ile yazı boyutu/renk/yazı tipi
    // uygulaması, odaktaki alanın bir metin bloğu mu yoksa bir checklist
    // maddesi mi olduğuna göre FARKLI yerlerden controller/span verisi
    // okur. Bu iki yardımcı, o farkı tek bir yerde çözer; _toggleSpanAttribute
    // ve _applyValueAttribute artık hangi tür alanda olduklarını bilmek
    // zorunda değil.
    TextEditingController? _resolveFocusedFormatController() {
      final idx = focusedBlockIndex;
      if (idx < 0 || idx >= blocks.length) return null;
      final type = blocks[idx]['type'];
      if (type == 'text') {
        return blockControllers[idx];
      }
      if (type == 'checklist') {
        final itemIdx = focusedItemIndex;
        final ctrls = blockItemControllers[idx];
        if (ctrls == null || itemIdx < 0 || itemIdx >= ctrls.length) {
          return null;
        }
        return ctrls[itemIdx];
      }
      return null;
    }

    // Span'ların OKUNDUĞU/YAZILDIĞI map: metin bloğu için bloğun kendisi,
    // checklist için odaklı maddenin map'i (referans olarak — burada
    // döndürülen map üzerinde yapılan değişiklik doğrudan
    // blocks[idx]['items'][itemIdx]'a yansır, kopya değildir).
    Map<String, dynamic>? _resolveFocusedSpansHolder() {
      final idx = focusedBlockIndex;
      if (idx < 0 || idx >= blocks.length) return null;
      final block = blocks[idx];
      if (block['type'] == 'text') return block;
      if (block['type'] == 'checklist') {
        final itemIdx = focusedItemIndex;
        final items = block['items'] as List?;
        if (items == null || itemIdx < 0 || itemIdx >= items.length) {
          return null;
        }
        return items[itemIdx] as Map<String, dynamic>;
      }
      return null;
    }

    // ── Aşama 3: seçili metne kalın/italik uygulama ───────────────────────
    // Aşama 4'teki klavye üstü toolbar butonları bu iki fonksiyonu
    // çağıracak. Odaktaki blok bir metin bloğu değilse, controller yoksa
    // ya da seçim boşsa (imleç sadece bir noktadaysa) hiçbir şey yapılmaz
    // — kalın/italik yalnızca SEÇİLİ metne uygulanır, imleç konumuna değil
    // (bu, Word/Google Docs'taki standart davranışla aynıdır).
    void _toggleSpanAttribute(String attr) {
      final controller = _resolveFocusedFormatController();
      if (controller == null) return;
      final sel = controller.selection;
      if (!sel.isValid) return;

      if (sel.isCollapsed) {
        // Seçili metin yok: bu tıklama, imleçten SONRA yazılacak
        // karakterlere uygulanacak biçimlendirmeyi açar/kapatır. Gerçek
        // uygulama, onChanged içinde _shiftSpansForTextChange tarafından
        // yeni eklenen karakter aralığına yapılır (aşağıya bkz.).
        if (attr == 'bold') {
          pendingBold = !pendingBold;
        } else if (attr == 'italic') {
          pendingItalic = !pendingItalic;
        } else if (attr == 'underline') {
          pendingUnderline = !pendingUnderline;
        } else if (attr == 'strikethrough') {
          pendingStrikethrough = !pendingStrikethrough;
        } else {
          pendingHighlight = !pendingHighlight;
        }
        // Araç çubuğundaki ikonun aktif/pasif rengini güncellemek için
        // rebuild tetikle (bkz. format toolbar Builder'ı).
        requestEditorRebuild?.call(() {});
        return;
      }

      final start = sel.start;
      final end = sel.end;
      final textLength = controller.text.length;

      // Diğer tüm biçimlendirme değişikliklerinde olduğu gibi (bkz.
      // yukarıdaki desen), değişiklikten ÖNCE checkpoint alınır ki
      // "Geri Al" bu tek kalın/italik uygulamasını tek adımda geri
      // alabilsin (harf harf değil).
      final spansHolder = _resolveFocusedSpansHolder();
      if (spansHolder == null) return;

      pushUndoCheckpoint();
      final List? currentSpans = spansHolder['spans'] as List?;
      final List? newSpans;
      if (attr == 'bold') {
        newSpans = RichTextSpans.toggleBold(
          currentSpans,
          textLength,
          start,
          end,
        );
      } else if (attr == 'italic') {
        newSpans = RichTextSpans.toggleItalic(
          currentSpans,
          textLength,
          start,
          end,
        );
      } else if (attr == 'underline') {
        newSpans = RichTextSpans.toggleUnderline(
          currentSpans,
          textLength,
          start,
          end,
        );
      } else if (attr == 'strikethrough') {
        newSpans = RichTextSpans.toggleStrikethrough(
          currentSpans,
          textLength,
          start,
          end,
        );
      } else {
        newSpans = RichTextSpans.toggleHighlight(
          currentSpans,
          textLength,
          start,
          end,
        );
      }
      spansHolder['spans'] = newSpans;
      // Not: controller.text ve controller.selection'a dokunmuyoruz —
      // RichBlockTextController zaten çizimi getSpans() üzerinden her
      // seferinde spansHolder['spans']'tan okuyor, bu yüzden seçim de
      // (kullanıcı biçimlendirmenin sonucunu görsün diye) olduğu gibi
      // kalır.
      requestEditorRebuild?.call(() {});
    }

    void toggleBoldForFocusedBlock() => _toggleSpanAttribute('bold');
    void toggleItalicForFocusedBlock() => _toggleSpanAttribute('italic');
    void toggleUnderlineForFocusedBlock() => _toggleSpanAttribute('underline');
    void toggleStrikethroughForFocusedBlock() =>
        _toggleSpanAttribute('strikethrough');
    void toggleHighlightForFocusedBlock() => _toggleSpanAttribute('highlight');

    // ── Araç çubuğu: "Madde İşareti" / "Numara İşareti" butonları ──────────
    // Aşama 5'teki "- "/"* " -> "• " kısayolu yalnızca kullanıcı bunu
    // YAZARKEN tetikleniyordu. Bu iki fonksiyon aynı işaretleri bir
    // dokunuşla, imlecin bulunduğu SATIRIN başına ekler/kaldırır (satır
    // zaten o işaretle başlıyorsa kaldırılır — kalın/italik'teki gibi
    // açma/kapama). Basitlik için yalnızca imlecin o an bulunduğu tek
    // satırı etkiler; çoklu satır seçiminde her satırı ayrı ayrı işlemek
    // span kaydırmasını gereksiz yere karmaşıklaştırırdı.
    //
    // Madde ve numara işareti AYNI SATIRDA asla bir arada bulunmaz: satırda
    // ZATEN öbür türden bir işaret varsa, yeni işaret eklenmeden önce o
    // kaldırılır — yani numaraya basmak maddeyi numaraya, maddeye basmak
    // numarayı maddeye DÖNÜŞTÜRÜR (iki ayrı adım — önce kaldır sonra ekle —
    // DEĞİL, tek bir replaceRange ile). shiftOffsetForMarkerReplace bunu
    // genel bir "[lineStart, lineStart+oldLen) aralığını newMarker ile
    // değiştir" işlemi olarak ele alır; oldLen=0 saf ekleme, newMarker=''
    // saf kaldırma, ikisi de doluysa gerçek bir dönüşüm olur — imleç/seçim
    // kaydırma mantığı üçünde de aynı formülle doğru çalışır.
    const bulletMarker = '• ';
    // DİKKAT: Bu regex '^' ile başlıyor. Dart'ta matchAsPrefix(text, start)
    // çağrısında '^', verilen 'start' konumuna DEĞİL, string'in MUTLAK
    // başına (index 0) bakar — yani lineStart sıfırdan farklıysa (bloğun
    // ilk satırı değilse) numberedLoop.matchAsPrefix(text, lineStart) HİÇBİR
    // ZAMAN eşleşmez. Bu yüzden her yerde satırın kendisini (text yerine
    // text.substring(lineStart)) matchAsPrefix'e veriyoruz — aksi halde
    // "Numara İşareti" butonu ilk satır dışındaki numaralı satırları hiç
    // tanıyamaz (kaldırmak yerine üstüne bir numara daha ekler) ve tek
    // Backspace'te numarayı silme kısayolu ilk satır dışında hiç
    // tetiklenmez (bkz. toggleBulletForFocusedBlock, toggleNumberForFocusedBlock,
    // _maybeHandleNumberBackspace).
    final numberedLoop = RegExp(r'^(\d+)\. ');
    int nextNumberForLine(String text, int lineStart) {
      if (lineStart == 0) return 1;
      final prevLineEnd = lineStart - 1; // '\n' konumu
      final prevLineStart = _safeLastNewlineIndex(text, prevLineEnd - 1) + 1;
      if (prevLineEnd < prevLineStart) return 1;
      final prevLine = text.substring(prevLineStart, prevLineEnd);
      final match = numberedLoop.matchAsPrefix(prevLine);
      if (match != null) {
        final n = int.tryParse(match.group(1)!);
        if (n != null) return n + 1;
      }
      return 1;
    }

    // [lineStart, lineStart+oldLen) aralığını [newMarker] ile değiştirir;
    // spans'ı (varsa silme + varsa ekleme olarak) kaydırır ve yeni metni
    // döndürür. oldLen=0 saf ekleme, newMarker='' saf kaldırma, ikisi de
    // doluysa gerçek bir dönüşüm (madde<->numara) olur.
    String _replaceLineMarker({
      required Map<String, dynamic> holder,
      required String text,
      required int lineStart,
      required int oldLen,
      required String newMarker,
    }) {
      final newLen = newMarker.length;
      final newText = text.replaceRange(
        lineStart,
        lineStart + oldLen,
        newMarker,
      );
      var spans = holder['spans'] as List?;
      if (oldLen > 0) {
        spans = RichTextSpans.shiftForDelete(
          spans,
          lineStart,
          lineStart + oldLen,
        );
      }
      if (newLen > 0) {
        spans = RichTextSpans.shiftForInsert(spans, lineStart, newLen);
      }
      holder['spans'] = spans;
      holder['text'] = newText;
      return newText;
    }

    // İmleç/seçim, [lineStart, lineStart+oldLen) aralığı [newLen] uzunluğunda
    // bir işaretle değiştirildiğinde nereye kayması gerektiğini hesaplar:
    // aralıktan SONRAKİ bir konumdaysa farkla birlikte kayar, aralığın
    // İÇİNDEyse (yalnızca kaldırma/dönüşüm durumunda olabilir) yeni işaretin
    // hemen sonrasına sabitlenir, ÖNCESİNDEyse olduğu yerde kalır.
    int _shiftOffsetForMarkerReplace(
      int offset,
      int lineStart,
      int oldLen,
      int newLen,
    ) {
      // DÜZELTME (işaret yazının sağında kalıyordu): offset == lineStart
      // durumu (imleç tam satır başında, en tipik durum) burada "offset"
      // olarak DEĞİŞMEDEN döndürülüyordu. oldLen == 0 iken (yani işaret
      // sıfırdan ekleniyorken) bu, imlecin yeni eklenen "• "/"N. "
      // işaretinin ÖNÜNDE kalması demekti — kullanıcı bir sonraki harfi
      // yazınca o harf işaretin SOLUNA giriyor, yani işaret yazının
      // sağında kalmış gibi görünüyordu. offset < lineStart (satırdan
      // önceki, etkilenmeyen kısım) ile offset == lineStart (eski
      // işaretin/eklenme noktasının TAM başı, aşağıdaki orta dal ile aynı
      // muameleyi görmesi gereken durum) artık ayrı ele alınıyor.
      if (offset < lineStart) return offset;
      if (offset >= lineStart + oldLen) return offset + (newLen - oldLen);
      return lineStart + newLen;
    }

    void toggleBulletForFocusedBlock() {
      final controller = _resolveFocusedFormatController();
      final holder = _resolveFocusedSpansHolder();
      if (controller == null || holder == null) return;
      final sel = controller.selection;
      if (!sel.isValid) return;

      final text = controller.text;
      final cursor = sel.start.clamp(0, text.length);
      final lineStart = _safeLastNewlineIndex(text, cursor - 1) + 1;

      final hasBullet = text.startsWith(bulletMarker, lineStart);
      final numberMatch =
          hasBullet ? null : numberedLoop.matchAsPrefix(text.substring(lineStart));

      pushUndoCheckpoint();

      final int oldLen;
      final String newMarker;
      if (hasBullet) {
        // Satır zaten madde işaretli -> kaldır.
        oldLen = bulletMarker.length;
        newMarker = '';
      } else if (numberMatch != null) {
        // Satır numaralı -> numarayı kaldırıp yerine madde işareti koy.
        oldLen = numberMatch.group(0)!.length;
        newMarker = bulletMarker;
      } else {
        // Satır hiçbir işarete sahip değil -> başına madde işareti ekle.
        oldLen = 0;
        newMarker = bulletMarker;
      }
      final newLen = newMarker.length;

      final newText = _replaceLineMarker(
        holder: holder,
        text: text,
        lineStart: lineStart,
        oldLen: oldLen,
        newMarker: newMarker,
      );

      final newBase = _shiftOffsetForMarkerReplace(
        sel.baseOffset,
        lineStart,
        oldLen,
        newLen,
      ).clamp(0, newText.length);
      final newExtent = _shiftOffsetForMarkerReplace(
        sel.extentOffset,
        lineStart,
        oldLen,
        newLen,
      ).clamp(0, newText.length);

      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection(baseOffset: newBase, extentOffset: newExtent),
      );
      requestEditorRebuild?.call(() {});
    }

    void toggleNumberForFocusedBlock() {
      final controller = _resolveFocusedFormatController();
      final holder = _resolveFocusedSpansHolder();
      if (controller == null || holder == null) return;
      final sel = controller.selection;
      if (!sel.isValid) return;

      final text = controller.text;
      final cursor = sel.start.clamp(0, text.length);
      final lineStart = _safeLastNewlineIndex(text, cursor - 1) + 1;

      final existingNumberMatch = numberedLoop.matchAsPrefix(text.substring(lineStart));
      final hasBullet = existingNumberMatch == null &&
          text.startsWith(bulletMarker, lineStart);

      pushUndoCheckpoint();

      final int oldLen;
      final String newMarker;
      if (existingNumberMatch != null) {
        // Satır zaten numaralı -> kaldır.
        oldLen = existingNumberMatch.group(0)!.length;
        newMarker = '';
      } else if (hasBullet) {
        // Satır madde işaretli -> madde işaretini kaldırıp yerine numara
        // koy.
        oldLen = bulletMarker.length;
        newMarker = '${nextNumberForLine(text, lineStart)}. ';
      } else {
        // Satır hiçbir işarete sahip değil -> başına numara ekle.
        oldLen = 0;
        newMarker = '${nextNumberForLine(text, lineStart)}. ';
      }
      final newLen = newMarker.length;

      final newText = _replaceLineMarker(
        holder: holder,
        text: text,
        lineStart: lineStart,
        oldLen: oldLen,
        newMarker: newMarker,
      );

      final newBase = _shiftOffsetForMarkerReplace(
        sel.baseOffset,
        lineStart,
        oldLen,
        newLen,
      ).clamp(0, newText.length);
      final newExtent = _shiftOffsetForMarkerReplace(
        sel.extentOffset,
        lineStart,
        oldLen,
        newLen,
      ).clamp(0, newText.length);

      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection(baseOffset: newBase, extentOffset: newExtent),
      );
      requestEditorRebuild?.call(() {});
    }

    // ── Araç çubuğu: "Paragraf Girintisi" butonu ────────────────────────────
    // Madde/numara işaretlerinin aksine bir AÇMA/KAPAMA değil, yalnızca
    // ARTIRMA işlemi: imlecin bulunduğu satırın en başına bir TAB karakteri
    // ekler. Satır zaten "• " veya "N. " gibi bir işaretle başlıyorsa bile
    // tab işaretin ÖNÜNE eklenir (satırın tamamı bir birim olarak içeri
    // kayar) — bu, çoğu düzenleyicideki alışılmış girinti davranışıyla
    // aynıdır. Çoklu satır seçiminde de yalnızca imlecin/seçimin
    // BAŞLANGICININ bulunduğu satır etkilenir (madde/numara butonlarıyla
    // aynı basitleştirme).
    void indentFocusedBlock() {
      final controller = _resolveFocusedFormatController();
      final holder = _resolveFocusedSpansHolder();
      if (controller == null || holder == null) return;
      final sel = controller.selection;
      if (!sel.isValid) return;

      final text = controller.text;
      final cursor = sel.start.clamp(0, text.length);
      final lineStart = _safeLastNewlineIndex(text, cursor - 1) + 1;

      pushUndoCheckpoint();

      const indent = '     '; // 5 boşluk (eskiden tek bir '\t' idi)
      final newText = text.replaceRange(lineStart, lineStart, indent);
      final spans = RichTextSpans.shiftForInsert(
        holder['spans'] as List?,
        lineStart,
        indent.length,
      );
      holder['spans'] = spans;
      holder['text'] = newText;

      final newBase = _shiftOffsetForMarkerReplace(
        sel.baseOffset,
        lineStart,
        0,
        indent.length,
      ).clamp(0, newText.length);
      final newExtent = _shiftOffsetForMarkerReplace(
        sel.extentOffset,
        lineStart,
        0,
        indent.length,
      ).clamp(0, newText.length);

      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection(baseOffset: newBase, extentOffset: newExtent),
      );
      requestEditorRebuild?.call(() {});
    }

    // ── Araç çubuğu: "Link Ekle" butonu ─────────────────────────────────────
    // fontSize/color/fontFamily gibi bir DEĞER (URL) uygulaması olduğundan
    // toggle değil; RichTextSpans.setLink kullanılır (bkz. o dosyadaki
    // setFontSize/setColor ile aynı desen). Kalın/italik'in aksine link,
    // SADECE seçili bir metin varken anlamlıdır (imleç konumuna
    // "bundan sonra yazılacaklar link olsun" şeklinde bir bekleyen mod
    // eklenmedi) — bu yüzden seçim boşsa kullanıcıya önce metin seçmesi
    // gerektiği söylenir. URL, küçük bir diyalogla sorulur; şema
    // ("https://") eksikse otomatik eklenir. Linkin gerçekten tıklanabilir
    // olması (mavi/altı çizili görünüm + tarayıcıda açma) RichBlockText
    // Controller.buildTextSpan tarafında 'link' alanına bakılarak yapılır.
    Future<void> applyLinkForFocusedBlock() async {
      final controller = _resolveFocusedFormatController();
      final holder = _resolveFocusedSpansHolder();
      if (controller == null || holder == null) return;
      final sel = controller.selection;
      if (!sel.isValid || sel.isCollapsed) {
        // NOT: Bu uyarı eskiden düz "const SnackBar" idi ve zemini BEYAZ
        // görünüyordu. Sebep: uygulamanın VARSAYILAN teması KOYU
        // (appThemeMode başlangıç değeri ThemeMode.dark, main.dart) ve bir
        // önceki düzeltme colorScheme.inverseSurface kullanıyordu —
        // Material 3'te bu renk KASITLI olarak ters çalışır: koyu temada
        // inverseSurface AÇIK/BEYAZ olur. Yani o düzeltme koyu temada aynı
        // "beyaz zemin" sorununu yeniden üretiyordu.
        // Bunun yerine, uygulamanın kendi koyu yüzey rengini kullanıyoruz —
        // main.dart'taki cardTheme/dialogTheme ile birebir aynı ton: koyu
        // temada #1E1E1E, açık temada beyaz — yani diğer panellerle/
        // diyaloglarla TUTARLI, tema değişse de asla beklenmedik şekilde
        // "ters dönmeyen" bir zemin.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).cardColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            content: Text(
              'Önce link eklemek istediğiniz metni seçin',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        );
        return;
      }

      final start = sel.start;
      final end = sel.end;
      final textLength = controller.text.length;

      // DÜZENLEME/KALDIRMA (ayrı buton eklemek yerine): seçili aralığın
      // TAMAMI zaten tek bir linke aitse (aralığı uçtan uca kapsayan bir
      // span'in 'link' alanı doluysa), o linki bulup diyalogda hazır
      // doldururuz ve "Linki Kaldır" seçeneği gösteririz. Böylece kullanıcı
      // var olan bir linki düzenlemek/kaldırmak için sadece aynı
      // "Link Ekle" ikonuna tekrar basar.
      String? existingLink;
      for (final s in RichTextSpans.parse(holder['spans'] as List?)) {
        final sStart = (s['start'] as num).toInt().clamp(0, textLength);
        final sEnd = (s['end'] as num).toInt().clamp(0, textLength);
        if (start >= sStart && end <= sEnd && s['link'] != null) {
          existingLink = s['link'] as String;
          break;
        }
      }

      final urlFieldController = TextEditingController(
        text: existingLink ?? '',
      );
      // Sonuç sözleşmesi: null -> vazgeçildi (hiçbir şey yapma), '' (boş
      // string) -> "Linki Kaldır" seçildi ya da alan boşken "Ekle"ye
      // basıldı (her iki durumda da linki kaldırmak kullanıcı niyetiyle
      // tutarlı), aksi halde girilen URL uygulanır.
      final url = await showDialog<String>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(existingLink != null ? 'Linki Düzenle' : 'Link Ekle'),
          content: TextField(
            controller: urlFieldController,
            autofocus: true,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(hintText: 'https://ornek.com'),
            onSubmitted: (v) => Navigator.of(dialogContext).pop(v.trim()),
          ),
          actions: [
            if (existingLink != null)
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(''),
                child: const Text('Linki Kaldır'),
              ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () => Navigator.of(
                dialogContext,
              ).pop(urlFieldController.text.trim()),
              child: const Text('Ekle'),
            ),
          ],
        ),
      );

      if (url == null) return; // Vazgeçildi.

      // Boş URL -> linki kaldır (null ata); doluysa şema yoksa ("ornek.com"
      // gibi) https:// ekle, url_launcher şemasız adresleri açamıyor.
      final normalizedUrl = url.isEmpty
          ? null
          : (url.contains('://') ? url : 'https://$url');

      pushUndoCheckpoint();
      holder['spans'] = RichTextSpans.setLink(
        holder['spans'] as List?,
        textLength,
        start,
        end,
        normalizedUrl,
      );
      requestEditorRebuild?.call(() {});
    }

    // ── Araç çubuğu: "Yatay Çizgi Ekle" butonu ──────────────────────────────
    // Link Ekle ikonunun yanında yer alır. Hesap tablosu/çizim eklemedeki
    // aynı desen: imlecin bulunduğu metin bloğu imleç konumundan ikiye
    // bölünür, arasına sayfayı boydan boya kaplayan bir 'divider' bloğu
    // eklenir (bkz. aşağıda block['type'] == 'divider' render'ı ve
    // removeDividerBlockAt).
    void insertDividerBlock() {
      if (noteType != 'text') return;
      pushUndoCheckpoint();
      // setModalState burada doğrudan görünmez (bu fonksiyon
      // StatefulBuilder'ın builder'ından ÖNCE tanımlı); pushUndoCheckpoint
      // ile aynı desen: builder her çalıştığında güncellenen
      // requestEditorRebuild üzerinden dolaylı olarak çağrılır.
      requestEditorRebuild?.call(() {
        // İmlecin bulunduğu metin bloğunu bul; imleç orada yoksa son metin
        // bloğuna eklenir (checklist/calc_table/drawing ekleme mantığıyla
        // aynı).
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
        final text =
            controller?.text.replaceAll(emptyTextSentinel, '') ??
            (blocks[idx]['text'] ?? '').toString();
        int offset = controller?.selection.baseOffset ?? -1;
        if (offset < 0 || offset > text.length) {
          offset = text.length;
        }
        final leftText = text.substring(0, offset);
        final rightText = text.substring(offset);

        // DÜZELTME (checklist'teki ile aynı sorun): leftText boşsa (imleç
        // metnin en başındaysa), ayrı bir boş metin bloğu bırakmak yerine
        // idx'teki blok doğrudan divider'a dönüştürülür — aksi halde boş
        // TextField kendi satır yüksekliğini kaplayıp divider'ı bir alt
        // satıra itiyormuş gibi gösteriyordu.
        final int dividerIdx;
        if (leftText.isEmpty) {
          blocks[idx] = {'type': 'divider'};
          dividerIdx = idx;
        } else {
          blocks[idx]['text'] = leftText;
          blocks.insert(idx + 1, {'type': 'divider'});
          dividerIdx = idx + 1;
        }
        if (rightText.isNotEmpty) {
          blocks.insert(dividerIdx + 1, {'type': 'text', 'text': rightText});
        }

        rebuildBlockControllers();
        focusedBlockIndex = dividerIdx + 1;
        final newFocusNode = blockFocusNodes[dividerIdx + 1];
        if (newFocusNode != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              newFocusNode.requestFocus();
            });
          });
        }
      });
    }

    // ── Araç çubuğu: "Yapılacaklar Listesi Ekle" butonu ─────────────────────
    // insertDividerBlock ile aynı desen: imlecin bulunduğu metin bloğu
    // imleç konumundan ikiye bölünür, arasına boş bir 'checklist' bloğu
    // eklenir. Blok en az bir boş maddeyle başlar; kullanıcı Enter'a basarak
    // yeni madde ekleyebilir.
    void insertChecklistBlock() {
      if (noteType != 'text') return;
      pushUndoCheckpoint();
      requestEditorRebuild?.call(() {
        int idx = focusedBlockIndex;

        // ── Toggle: odaklı blok zaten 'checklist' ise ──
        // Odaklı maddeyi checklist'ten çıkarıp düz metne dönüştür.
        // Tek madde kaldıysa tüm blok düz metne döner;
        // birden fazla madde varsa sadece odaklı madde çıkarılır,
        // geri kalanlar checklist olarak devam eder.
        if (idx >= 0 &&
            idx < blocks.length &&
            blocks[idx]['type'] == 'checklist') {
          final items = List<Map<String, dynamic>>.from(
            blocks[idx]['items'] ?? const [],
          );
          // Hangi madde odaklı?
          final itemIdx = (focusedItemIndex >= 0 && focusedItemIndex < items.length)
              ? focusedItemIndex
              : 0;
          final removedText = (items[itemIdx]['text'] ?? '').toString();

          if (items.length <= 1) {
            // Tek madde kaldı → tüm blok düz metne dönüşür (eski davranış).
            final prevIsText = idx > 0 && blocks[idx - 1]['type'] == 'text';
            final nextIsText =
                idx < blocks.length - 1 && blocks[idx + 1]['type'] == 'text';
            if (prevIsText && nextIsText) {
              final prevText = (blocks[idx - 1]['text'] ?? '').toString();
              final nextText = (blocks[idx + 1]['text'] ?? '').toString();
              final sep = prevText.isNotEmpty && removedText.isNotEmpty ? '\n' : '';
              final sep2 = (prevText + removedText).isNotEmpty && nextText.isNotEmpty ? '\n' : '';
              blocks[idx - 1]['text'] = prevText + sep + removedText + sep2 + nextText;
              blocks.removeAt(idx + 1);
              blocks.removeAt(idx);
              focusedBlockIndex = idx - 1;
            } else if (prevIsText) {
              final prevText = (blocks[idx - 1]['text'] ?? '').toString();
              final sep = prevText.isNotEmpty && removedText.isNotEmpty ? '\n' : '';
              blocks[idx - 1]['text'] = prevText + sep + removedText;
              blocks.removeAt(idx);
              focusedBlockIndex = idx - 1;
            } else {
              blocks[idx] = {'type': 'text', 'text': removedText};
            }
          } else {
            // Birden fazla madde var → sadece odaklı maddeyi çıkar.
            items.removeAt(itemIdx);
            blocks[idx]['items'] = items;

            // Çıkarılan maddenin metnini:
            // - itemIdx == 0 ise checklist bloğunun önündeki metin bloğuna ekle
            //   (yoksa yeni bir metin bloğu olarak önüne ekle).
            // - itemIdx > 0 ise bir önceki maddenin hemen ardına metin bloğu
            //   olarak araya ekle.
            if (itemIdx == 0) {
              final prevIsText = idx > 0 && blocks[idx - 1]['type'] == 'text';
              if (prevIsText) {
                final prevText = (blocks[idx - 1]['text'] ?? '').toString();
                final sep = prevText.isNotEmpty && removedText.isNotEmpty ? '\n' : '';
                blocks[idx - 1]['text'] = prevText + sep + removedText;
                focusedBlockIndex = idx - 1;
              } else {
                blocks.insert(idx, {'type': 'text', 'text': removedText});
                focusedBlockIndex = idx;
                // checklist bloğu idx+1'e kaydı, focusedItemIndex güncelle
              }
            } else {
              // Maddeyi checklist bloğundan sonra değil, ortasından çıkardık.
              // Bloğu ikiye böl: [0..itemIdx-1] checklist, metin, [itemIdx..son] checklist.
              final upperItems = items.sublist(0, itemIdx);
              final lowerItems = items.sublist(itemIdx);
              blocks[idx]['items'] = upperItems;
              blocks.insert(idx + 1, {'type': 'text', 'text': removedText});
              if (lowerItems.isNotEmpty) {
                blocks.insert(idx + 2, {'type': 'checklist', 'items': lowerItems});
              }
              focusedBlockIndex = idx + 1;
            }
          }

          if (blocks.isEmpty) {
            blocks.add({'type': 'text', 'text': ''});
            focusedBlockIndex = 0;
          }
          rebuildBlockControllers();
          final targetIdx = focusedBlockIndex.clamp(0, blocks.length - 1);
          focusedItemIndex = -1;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              blockFocusNodes[targetIdx]?.requestFocus();
            });
          });
          return;
        }

        // ── Normal akış: odaklı blok bir metin bloğu, checklist ekle ──
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
        final text =
            controller?.text.replaceAll(emptyTextSentinel, '') ??
            (blocks[idx]['text'] ?? '').toString();
        int offset = controller?.selection.baseOffset ?? -1;
        if (offset < 0 || offset > text.length) {
          offset = text.length;
        }

        // İmlecin bulunduğu satırın başını ve sonunu bul.
        // Satır başı: offset'ten geriye doğru ilk '\n'den sonraki konum.
        // Satır sonu: offset'ten ileriye doğru ilk '\n'nin konumu (yoksa
        // metnin sonu). Satır sonu '\n' karakterini içermez; '\n' kendisi
        // üst bloğun sonuna bırakılır ki alt metin bloğu yeni satırla başlamasın.
        final lineStartIdx = _safeLastNewlineIndex(text, offset - 1) + 1;
        final nextNewline = text.indexOf('\n', offset);
        final lineEndIdx = nextNewline == -1 ? text.length : nextNewline;

        // Satırdan önce kalan metin (varsa sondaki '\n' dahil).
        final aboveText = text.substring(0, lineStartIdx);
        // İmlecin bulunduğu satırın metni → checklist'in ilk maddesi olur.
        final currentLineText = text.substring(lineStartIdx, lineEndIdx);
        // Satırdan sonra kalan metin ('\n' sonrasından itibaren).
        final belowText = nextNewline == -1
            ? ''
            : text.substring(nextNewline + 1);

        final finalAboveText = aboveText.endsWith('\n')
            ? aboveText.substring(0, aboveText.length - 1)
            : aboveText;

        // DÜZELTME (checklist bir alt satıra ekleniyordu): finalAboveText
        // boşsa (checklist'e dönüştürülen satır, metin bloğundaki tek/ilk
        // satırsa), eskiden yine de blocks[idx] boş bir metin bloğu olarak
        // listede bırakılıyordu. Her blok kendi widget'ı/kendi boşluğuyla
        // render edildiğinden, bu boş metin bloğu checklist'in ÜSTÜNDE
        // fazladan bir satır gibi görünüyor, checklist de görsel olarak bir
        // alt satıra kaymış gibi duruyordu. Aynısı belowText için de
        // (checklist'in ALTINDA fazladan boş satır) geçerliydi. Şimdi: üst
        // taraf boşsa ayrı blok bırakmak yerine idx'teki bloğun kendisi
        // checklist'e dönüştürülüyor; alt taraf boşsa hiç blok eklenmiyor
        // (rebuildBlockControllers zaten listenin metinle bitmesini
        // garanti ediyor).
        final int checklistIdx;
        if (finalAboveText.isEmpty) {
          blocks[idx] = {
            'type': 'checklist',
            'items': [
              {'text': currentLineText, 'checked': false},
            ],
          };
          checklistIdx = idx;
        } else {
          blocks[idx]['text'] = finalAboveText;
          blocks.insert(idx + 1, {
            'type': 'checklist',
            'items': [
              {'text': currentLineText, 'checked': false},
            ],
          });
          checklistIdx = idx + 1;
        }
        if (belowText.isNotEmpty) {
          blocks.insert(checklistIdx + 1, {'type': 'text', 'text': belowText});
        }

        rebuildBlockControllers();

        // Yeni eklenen checklist bloğunun ilk maddesine odaklan.
        // Çift addPostFrameCallback kullanıyoruz: ilk frame'de
        // rebuildBlockControllers'ın dispose callback'i çalışır,
        // ikinci frame'de requestFocus yapılır — böylece klavye
        // kapanıp açılmaz (titreme olmaz).
        final newItemFocusNodes = blockItemFocusNodes[checklistIdx];
        if (newItemFocusNodes != null && newItemFocusNodes.isNotEmpty) {
          focusedBlockIndex = checklistIdx;
          focusedItemIndex = 0;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (newItemFocusNodes.isNotEmpty) {
                newItemFocusNodes[0].requestFocus();
              }
            });
          });
        }
      });
    }

    // Bu fonksiyon klavyeyi kapatır ve odaklı bloktaki imleci de kaybettirir (unfocus).
    // primaryFocus?.unfocus() kullanılıyor — dosyanın başka yerlerinde
    // (ör. sayfa kapatılırken) aynı desen zaten kullanılıyor. Henüz hiç
    // harf yazılmamış bekleyen (pending) kalın/italik/vb. durumlar da
    // artık odaklanacak bir yer kalmadığından sıfırlanır — odak başka bir
    // bloğa geçtiğinde yapılan sıfırlamayla aynı mantık (bkz. yukarıdaki
    // ilgili onTap'ler).
    void dismissKeyboardForFocusedBlock() {
      pendingBold = false;
      pendingItalic = false;
      pendingUnderline = false;
      pendingStrikethrough = false;
      pendingHighlight = false;
      pendingFontSize = null;
      pendingColor = null;
      pendingFontFamily = null;
      showListSubToolbar = false;
      showStyleSubToolbar = false;
      showColorSubToolbar = false;
      showFontSizeSubToolbar = false;
      showBgColorSubToolbar = false;
      focusedItemIndex = -1;
      FocusManager.instance.primaryFocus?.unfocus();
      requestEditorRebuild?.call(() {});
    }

    // ── Seçili metne yazı boyutu/renk/yazı tipi ailesi uygulama ─────────
    // _toggleSpanAttribute ile aynı iskelet, ama AÇ/KAPA yerine bir
    // picker'dan (boyut listesi/renk paleti/yazı tipi listesi) seçilen
    // DEĞERİ doğrudan atar. value == null verilirse "Varsayılan" seçilmiş
    // demektir: seçili aralıktaki özel değer temizlenir. Odaktaki blok
    // metin bloğu değilse, controller yoksa ya da seçim geçersizse hiçbir
    // şey yapılmaz.
    void _applyValueAttribute(String attr, dynamic value) {
      final controller = _resolveFocusedFormatController();
      if (controller == null) return;
      final sel = controller.selection;
      if (!sel.isValid) return;

      if (sel.isCollapsed) {
        // Seçili metin yok: bu seçim, imleçten SONRA yazılacak karaktere
        // uygulanacak değeri "bekleyen" olarak ayarlar (bkz. pendingBold
        // açıklaması). Gerçek uygulama _shiftSpansForTextChange içinde
        // yapılır.
        if (attr == 'fontSize') {
          pendingFontSize = value as double?;
        } else if (attr == 'color') {
          pendingColor = value as int?;
        } else {
          pendingFontFamily = value as String?;
        }
        requestEditorRebuild?.call(() {});
        return;
      }

      final start = sel.start;
      final end = sel.end;
      final textLength = controller.text.length;

      final spansHolder = _resolveFocusedSpansHolder();
      if (spansHolder == null) return;

      pushUndoCheckpoint();
      final currentSpans = spansHolder['spans'] as List?;
      final List newSpans;
      if (attr == 'fontSize') {
        newSpans = RichTextSpans.setFontSize(
          currentSpans,
          textLength,
          start,
          end,
          value as double?,
        );
      } else if (attr == 'color') {
        newSpans = RichTextSpans.setColor(
          currentSpans,
          textLength,
          start,
          end,
          value as int?,
        );
      } else {
        newSpans = RichTextSpans.setFontFamily(
          currentSpans,
          textLength,
          start,
          end,
          value as String?,
        );
      }
      spansHolder['spans'] = newSpans;
      requestEditorRebuild?.call(() {});
    }

    void setFontSizeForFocusedBlock(double? size) =>
        _applyValueAttribute('fontSize', size);
    void setColorForFocusedBlock(int? color) =>
        _applyValueAttribute('color', color);
    void setFontFamilyForFocusedBlock(String? family) =>
        _applyValueAttribute('fontFamily', family);

    // Not arka plan rengi: Yazı Rengi/Boyutu'nun aksine bir span/seçim
    // özelliği DEĞİLDİR — pushUndoCheckpoint/spansHolder'a gerek yok,
    // doğrudan not düzeyindeki tek değeri günceller.
    void setNoteBgColor(int? color) {
      noteBgColor = color;
      requestEditorRebuild?.call(() {});
    }

    // ── Araç çubuğunda "şu an aktif" yazı boyutunu belirleme ─────────────
    // pendingFontSize yalnızca imleç tek noktadayken (seçim yokken) anlamlı
    // bir "bekleyen" değerdir (bkz. yukarıdaki pendingBold açıklaması).
    // GERÇEK bir seçim varken (start < end) bir boyut uygulandığında bu
    // _applyValueAttribute üzerinden DOĞRUDAN seçili aralığın span'larına
    // yazılır — pendingFontSize hiç değişmez. Bu yüzden Yazı Boyutu
    // ikonunun/çipinin "aktif" gösterimi, gerçek bir seçim olduğunda
    // pendingFontSize yerine seçili aralığın span'larından okunan GERÇEK
    // değeri (RichTextSpans.getEffectiveFontSize) kullanmalıdır. Seçim
    // yoksa (imleç tek noktadaysa) davranış eskisiyle birebir aynıdır:
    // doğrudan pendingFontSize döner.
    double? _effectiveFontSizeForToolbar() {
      final controller = _resolveFocusedFormatController();
      if (controller == null) return pendingFontSize;
      final sel = controller.selection;
      if (!sel.isValid || sel.isCollapsed) return pendingFontSize;

      final holder = _resolveFocusedSpansHolder();
      if (holder == null) return pendingFontSize;

      return RichTextSpans.getEffectiveFontSize(
        holder['spans'] as List?,
        controller.text.length,
        sel.start,
        sel.end,
      );
    }

    // "Varsayılan" çipinin GERÇEKTEN aktif olup olmadığını belirler.
    // _effectiveFontSizeForToolbar() == null tek başına yeterli değil,
    // çünkü hem "gerçekten varsayılan" hem de "karışık seçim" durumunda
    // null dönüyor (bkz. RichTextSpans.getEffectiveFontSizeInfo
    // açıklaması). İmleç tek noktadaysa (seçim yok) zaten karışıklık söz
    // konusu olamaz — pendingFontSize null ise bu direkt gerçek
    // varsayılandır.
    bool _isFontSizeMixedForToolbar() {
      final controller = _resolveFocusedFormatController();
      if (controller == null) return false;
      final sel = controller.selection;
      if (!sel.isValid || sel.isCollapsed) return false;

      final holder = _resolveFocusedSpansHolder();
      if (holder == null) return false;

      final (_, isMixed) = RichTextSpans.getEffectiveFontSizeInfo(
        holder['spans'] as List?,
        controller.text.length,
        sel.start,
        sel.end,
      );
      return isMixed;
    }

    // Renk seçenekleri ve tekil bir renk dairesini çizen widget artık
    // Liste/Stil alt barlarıyla aynı yerleşimde kullanılan "Renk alt barı"
    // tarafından (ana araç çubuğu Row'unun içinde, bkz. showColorSubToolbar)
    // tüketildiği için bottom sheet'in içine değil, burada dış kapsamda
    // tanımlanır. `ctx`, dividerColor'ı okumak için ilgili çağrı yerindeki
    // BuildContext'i alır (bottom sheet açıkken sheet'in context'i, alt
    // barda ise araç çubuğunun context'i).
    const textColorOptions = <(String, int?)>[
      ('Varsayılan', null),
      ('Kırmızı', 0xFFF44336),
      ('Turuncu', 0xFFFF9800),
      ('Sarı', 0xFFFFC107),
      ('Yeşil', 0xFF4CAF50),
      ('Mavi', 0xFF2196F3),
      ('Mor', 0xFF9C27B0),
      ('Gri', 0xFF9E9E9E),
      ('Siyah', 0xFF000000),
    ];

    Widget colorSwatch(BuildContext ctx, String label, int? colorValue) =>
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => setColorForFocusedBlock(colorValue),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorValue != null ? Color(colorValue) : null,
              border: Border.all(
                color: Theme.of(ctx).dividerColor,
                width: colorValue == null ? 1.5 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: colorValue == null
                ? const Icon(Icons.format_color_reset, size: 18)
                : null,
          ),
        );

    // Yazı boyutu seçenekleri ve tekil bir boyut çipini çizen widget:
    // eskiden "Yazı Boyutu" butonuna basılınca showModalBottomSheet ile
    // ayrı bir sayfa açılırdı; artık Liste/Stil/Renk alt barlarıyla AYNI
    // desende, ana araç çubuğu Row'unun yerini alan bir "Yazı Boyutu alt
    // barı" olarak gösteriliyor (bkz. showFontSizeSubToolbar). Boyut
    // seçenekleri dokununca hemen uygulanır, kapatmak için "Kapat" butonu
    // yeterli (Renk alt barındaki colorSwatch ile birebir aynı yerleşim,
    // sadece daire yerine chip kullanılıyor).
    // NOT: Etiket metni artık dördünde de aynı ("Text") — aralarındaki
    // fark yalnızca fontSizeChipLabelStyles'taki punto/kalınlıkla
    // gösteriliyor. Eskiden Türkçe kelimeler (Varsayılan/Başlık/Ana
    // Başlık/Manşet) kullanılıyordu; en uzun etiket ("Ana Başlık") dar
    // çip genişliğine sığmak için previewScale'i alt sınıra (0.4)
    // dayatıyor, bu da yetmeyip "Manşet" gibi etiketlerin bir kısmının
    // (ör. sadece "Man") kırpılmasına yol açıyordu. Kısa ve sabit "Text"
    // etiketiyle bu sorun ortadan kalkıyor.
    final fontSizeOptions = <(String, double?)>[
      ('Text', null),
      ('Text', _globalFontSize + 4),
      ('Text', _globalFontSize + 8),
      ('Text', _globalFontSize + 12),
    ];

    // Her çipin ETİKETİNİN ("Text") kendi önizleme yazı tipi/kalınlığı:
    // kullanıcı çipe bakınca o boyutun/kalınlığın nasıl göründüğünü görsün
    // diye (gerçek uygulanan boyutla karışmasın — bu sadece etiketin
    // görünümü). fontSizeOptions ile aynı sırada, artırarak: 17 ince,
    // 20 kalın, 25 kalın, 31 kalın.
    //
    // DÜZELTME: Eskiden 17/18/21/24 idi — 2., 3. ve 4. çip hepsi zaten
    // kalın olduğundan aralarındaki tek fark 3'er puntoluk küçük artışlardı
    // ve göz ile ayırt edilmesi zordu. Adımlar artık kademeli olarak
    // büyüyor (+3, +5, +6) ki dördü de birbirinden net bir şekilde
    // ayrılsın (Apple Notes'taki Body/Subheading/Heading/Title
    // seçicisindeki gibi).
    //
    // SIĞMA KONTROLÜ: Her çip zaten FittedBox(fit: BoxFit.scaleDown) ile
    // sarılı (bkz. fontSizeChip -> buildFace) — bu, metnin kendi çipinin
    // genişliğine göre GEREKTİĞİ KADAR küçültülüp sığdırılacağını, hiçbir
    // koşulda taşmayacağını garanti eder. Tek risk, tüm çip genişlikleri
    // eşit olduğundan (Row + Expanded flex:1) bir boyutun ihtiyaç duyduğu
    // genişlik çip genişliğini AŞARSa o çipin de aynı genişliğe
    // sıkıştırılıp bir öncekiyle aynı görünmesidir. 31pt kalın "Text"
    // (4 karakter), tam genişlik araç çubuğunda 4 eşit çipe bölündüğünde
    // (dar telefonlarda bile ~80-90dp/çip) rahatça sığacak kadar küçük
    // kalıyor — bu yüzden dördü de kırpılmadan/eşitlenmeden kendi gerçek
    // oranlarında görünür.
    final fontSizeChipLabelStyles = <TextStyle>[
      const TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      const TextStyle(fontSize: 31, fontWeight: FontWeight.bold),
    ];

    // [isActive]: bu çipin boyutu, o an geçerli olan "etkin" boyuta
    // (_effectiveFontSizeForToolbar) eşit mi? true ise çip Kalın/Renk
    // butonlarındaki vurguyla tutarlı bir şekilde (tema rengiyle
    // çerçevelenerek) işaretlenir. "Varsayılan" çipi (size == null) için de
    // artık aynı vurgu uygulanıyor — ama yalnızca GERÇEKTEN varsayılan
    // durumdaysa (_isFontSizeMixedForToolbar() false iken); seçim karışıksa
    // (bir kısmı bir boyutta, diğeri başka/varsayılan) hiçbir çip aktif
    // gösterilmez, çünkü o durumda tekil bir "etkin boyut" yoktur.
    Widget fontSizeChip(
      BuildContext ctx,
      String label,
      double? size, {
      required bool isActive,
      TextStyle? labelStyle,
    }) {
      // Apple Notes'taki "Title/Heading/Subheading/Body" seçicisiyle benzer
      // bir seçici: hiçbir seçenekte dolgu/zemin YOK (Material her zaman
      // transparent) — seçili olan yalnızca AMBER RENKLİ YAZI ile belirtilir;
      // seçili olmayanlar temanın normal metin rengiyle gösterilir. Seçenekler
      // arasında boşluk YOK — bitişik duruyorlar. DÜZELTME: çipler
      // arasındaki ince dikey ayırıcı çizgi (eski showLeftDivider/
      // dividerColor mantığı) kaldırıldı — kullanıcı bu çizgilerin
      // rahatsız edici göründüğünü belirtti, artık çipler arasında hiçbir
      // görsel bölme yok.
      final isDark = Theme.of(ctx).brightness == Brightness.dark;
      final inactiveColor = isDark ? Colors.white : Colors.black87;

      Widget buildFace(bool active) {
        final effectiveStyle = (labelStyle ?? const TextStyle()).copyWith(
          // Artık dolgu (amber zemin) YOK — seçili olan çip, arka planı
          // değiştirmek yerine yazı rengini amber yapar; seçili olmayanlar
          // temanın normal metin rengini kullanır.
          color: active ? Colors.amber : inactiveColor,
        );
        // DÜZELTME (yazının bir kısmı — ör. "Text" -> "Tex" — görünmüyordu):
        // Eskiden buradaki boyut, TextPainter ile ÖNCEDEN tahmin edilip
        // (previewScale) elle hesaplanıyordu. Cihazın gerçek yazı tipi
        // ölçeklendirmesi (ör. "büyük yazı tipi" erişilebilirlik ayarı)
        // TextPainter'ın varsayımından FARKLI olabildiğinden, gerçekte
        // çizilen metin hesaplanandan biraz daha geniş çıkabiliyor; taşan
        // kısım da Row'da sıradaki çipin üstüne çizildiğinden (sonraki
        // widget'lar üstte boyandığından) örtülüp kayboluyordu. FittedBox
        // ise tahmine dayanmaz: gerçek layout anında, mevcut alana göre
        // metni GEREKTİĞİ KADAR küçültür — bu yüzden hiçbir koşulda taşma/
        // kırpılma olmaz, metin her zaman TAM ve okunur şekilde sığar.
        return Material(
          key: ValueKey<bool>(active),
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            // DÜZELTME: Dikey padding eskiden 8dp idi. Toolbar'ın toplam
            // yüksekliği sabit 44dp olduğundan (bkz. showFontSizeSubToolbar
            // Row'unu saran SizedBox(height: 44)), 8+8=16dp padding metne
            // sadece 28dp yükseklik bırakıyordu — 25/31pt kalın "Text"in
            // satır yüksekliği bunu aştığı için FittedBox hepsini aynı
            // 28dp sınırına küçültüp görsel olarak eşitliyordu (farklı
            // punto seçseniz de hepsi aynı görünüyordu). Padding 2dp'ye
            // indirilerek metne ~40dp yükseklik bırakıldı — 31pt kalın
            // "Text" bile bu sınırın içinde kalıp gerçek boyutunda render
            // oluyor, dördü artık birbirinden net şekilde ayrılıyor.
            padding: const EdgeInsets.symmetric(
              horizontal: 2,
              vertical: 2,
            ),
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                label,
                maxLines: 1,
                style: effectiveStyle,
              ),
            ),
          ),
        );
      }


      return SizedBox(
        width: double.infinity,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => setFontSizeForFocusedBlock(size),
          // Seçili durum değişince geçiş animasyonu YOK — yüz doğrudan
          // (kayma/solma olmadan) güncel isActive durumuna göre çizilir.
          child: buildFace(isActive),
        ),
      );
    }


    // ── Aşama 5 (basit yöntem): "- "/"* " kısayolunu "• " madde işaretine
    // çevirir ve Enter'a basılınca bullet modunu bir sonraki satıra taşır.
    // Ayrı bir veri alanı KULLANILMAZ — tamamen düz metin üzerinde çalışan
    // bir kısayoldur; bu yüzden mevcut undo/redo, spans (kalın/italik)
    // mantığı ve plainText()/arama/PDF export hiç etkilenmez (onlar zaten
    // controller'ın .text değerini olduğu gibi okuyor). Aynı desen
    // dNoteMaybeAutoCalculate'in "=" kısayolunda da kullanılıyor: onChanged
    // içinde block['text'] zaten güncellendikten SONRA, controller'ın o anki
    // (kullanıcının az önce yazdığı) değerine bakarak çalışır.
    // (bulletMarker burada YENİDEN tanımlanmıyor — toggleBulletForFocusedBlock
    // ile aynı üst kapsamdaki tanım kullanılıyor.)
    // [block] parametresi eklendi: "- "/"* " -> "• " dönüşümü aynı
    // uzunlukta bir değişim olduğu için span kaydırmaya gerek yok, ama
    // Enter'da bullet işaretinin satır başına EKLENMESİ/KALDIRILMASI tam
    // olarak 2 karakterlik bir kayma yarattığından, o noktadan sonraki
    // bold/italic span'ların start/end değerleri de kaydırılmalı — aksi
    // halde span'lar yanlış karakter aralığını işaretlemeye devam eder
    // (bkz. RichTextSpans.shiftForInsert/shiftForDelete).
    void _maybeHandleBulletShortcut(
      TextEditingController controller,
      Map<String, dynamic> block, {
      required void Function(String newText) onTextChanged,
    }) {
      final sel = controller.selection;
      if (!sel.isValid || !sel.isCollapsed) return;
      final text = controller.text;
      final cursor = sel.baseOffset;
      if (cursor <= 0 || cursor > text.length) return;

      final justTyped = text[cursor - 1];

      // 1) "- " veya "* " -> "• " (yalnızca satırın en başında).
      if (justTyped == ' ') {
        final lineStart = _safeLastNewlineIndex(text, cursor - 2) + 1;
        final segment = text.substring(lineStart, cursor);
        if (segment == '- ' || segment == '* ') {
          // Aynı uzunlukta bir değişim (2 kod birimi -> 2 kod birimi):
          // span'lar kaymaz, kaydırmaya gerek yok.
          final newText = text.replaceRange(lineStart, cursor, bulletMarker);
          final newCursor = lineStart + bulletMarker.length;
          controller.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: newCursor),
          );
          onTextChanged(newText);
        }
        return;
      }

      // 2) Enter: bullet'li satırdan sonra yeni satır da bullet olsun;
      // boş bullet satırında Enter'a basılırsa bullet modundan çıkılsın.
      if (justTyped == '\n') {
        final prevLineStart = _safeLastNewlineIndex(text, cursor - 2) + 1;
        final prevLineEnd = cursor - 1;
        if (prevLineEnd < prevLineStart) return;
        final prevLine = text.substring(prevLineStart, prevLineEnd);
        if (prevLine == bulletMarker) {
          // Boş madde satırında Enter -> bullet modundan çık, işareti
          // önceki (şimdi terk edilen) satırdan kaldır. Bu, [prevLineStart,
          // prevLineEnd) aralığında (2 karakter) bir SİLME işlemidir.
          final newText = text.replaceRange(prevLineStart, prevLineEnd, '');
          final newCursor = cursor - bulletMarker.length;
          block['spans'] = RichTextSpans.shiftForDelete(
            block['spans'] as List?,
            prevLineStart,
            prevLineEnd,
          );
          controller.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(
              offset: newCursor.clamp(0, newText.length),
            ),
          );
          onTextChanged(newText);
        } else if (prevLine.startsWith(bulletMarker) &&
            prevLine.length > bulletMarker.length) {
          // Doldurulmuş bullet satırından sonra Enter -> yeni satır da
          // bullet olarak devam etsin. Bu, [cursor] konumuna bulletMarker
          // uzunluğunda (2 karakter) bir EKLEME işlemidir.
          final newText = text.replaceRange(cursor, cursor, bulletMarker);
          final newCursor = cursor + bulletMarker.length;
          block['spans'] = RichTextSpans.shiftForInsert(
            block['spans'] as List?,
            cursor,
            bulletMarker.length,
          );
          controller.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: newCursor),
          );
          onTextChanged(newText);
        }
      }
    }

    // ── Backspace ile madde işaretini TEK seferde silme ────────────────────
    // Varsayılan TextField davranışı Backspace'te sadece imleçten önceki
    // TEK karakteri siler. "• " işaretinin sonunda (yani imleç boşluktan
    // hemen sonraysa) Backspace'e basıldığında bu, önce yalnızca boşluğu
    // siler ve geriye "•" tek karakteri kalır — kullanıcı işareti tamamen
    // kaldırmak için 2 kere Backspace'e basmak zorunda kalır. Bu fonksiyon,
    // tam olarak bu durumu (bir önceki metinde "• " vardı, şimdi Backspace
    // sonucu "•" tek başına kaldı ve imleç hemen ardında) yakalayıp geriye
    // kalan "•" karakterini de siler; böylece TEK Backspace tüm 2 karakterlik
    // işareti kaldırır. onChanged içinde block['text'] zaten güncellendikten
    // SONRA çağrılır (bkz. _maybeHandleBulletShortcut'taki aynı desen).
    void _maybeHandleBulletBackspace(
      TextEditingController controller,
      Map<String, dynamic> block,
      String oldText, {
      required void Function(String newText) onTextChanged,
    }) {
      final sel = controller.selection;
      if (!sel.isValid || !sel.isCollapsed) return;
      final text = controller.text;
      final cursor = sel.baseOffset;
      if (cursor < 0 || cursor > text.length) return;
      // Tam olarak tek karakter silinmiş olmalı (normal yazma/yapıştırma
      // değil, Backspace/Delete ile bir karakterlik bir silme).
      if (oldText.length != text.length + 1) return;

      const bulletMarker = '• ';
      final lineStart = _safeLastNewlineIndex(text, cursor - 1) + 1;
      if (cursor == lineStart + 1 &&
          oldText.startsWith(bulletMarker, lineStart) &&
          text.startsWith('•', lineStart)) {
        final newText = text.replaceRange(lineStart, lineStart + 1, '');
        block['spans'] = RichTextSpans.shiftForDelete(
          block['spans'] as List?,
          lineStart,
          lineStart + 1,
        );
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: lineStart),
        );
        onTextChanged(newText);
      }
    }

    // ── Enter'da numaralı listenin devamı/çıkışı ────────────────────────────
    // _maybeHandleBulletShortcut'ın Enter dalıyla (2. adım) TAMAMEN AYNI
    // mantık; tek fark, sabit "• " yerine değişken uzunlukta "N. " işareti
    // ile çalışması ve bir sonraki satıra bir ARTAN numara ("N+1. ")
    // eklenmesi. "- "/"* " kısayolundaki gibi bir OTOMATİK DÖNÜŞÜM adımı
    // YOKTUR — kullanıcı zaten "1. " yazdığında metin olduğu gibi görünür,
    // ayrıca bir karaktere çevrilmesi gerekmez; yalnızca Enter'a basılınca
    // numaralamanın devam/çıkış davranışını yönetiriz.
    final numberedLoopShortcut = RegExp(r'^(\d+)\. ');
    void _maybeHandleNumberShortcut(
      TextEditingController controller,
      Map<String, dynamic> block, {
      required void Function(String newText) onTextChanged,
    }) {
      final sel = controller.selection;
      if (!sel.isValid || !sel.isCollapsed) return;
      final text = controller.text;
      final cursor = sel.baseOffset;
      if (cursor <= 0 || cursor > text.length) return;

      final justTyped = text[cursor - 1];
      if (justTyped != '\n') return;

      final prevLineStart = _safeLastNewlineIndex(text, cursor - 2) + 1;
      final prevLineEnd = cursor - 1;
      if (prevLineEnd < prevLineStart) return;
      final prevLine = text.substring(prevLineStart, prevLineEnd);
      final match = numberedLoopShortcut.matchAsPrefix(prevLine);
      if (match == null) return;
      final markerLen = match.group(0)!.length;

      if (prevLine.length == markerLen) {
        // Boş numaralı satırda Enter -> numaralama modundan çık, işareti
        // önceki (şimdi terk edilen) satırdan kaldır.
        final newText = text.replaceRange(prevLineStart, prevLineEnd, '');
        final newCursor = cursor - markerLen;
        block['spans'] = RichTextSpans.shiftForDelete(
          block['spans'] as List?,
          prevLineStart,
          prevLineEnd,
        );
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(
            offset: newCursor.clamp(0, newText.length),
          ),
        );
        onTextChanged(newText);
      } else {
        // Doldurulmuş numaralı satırdan sonra Enter -> yeni satır bir
        // sonraki numarayla devam etsin.
        final currentNumber = int.tryParse(match.group(1) ?? '') ?? 0;
        final nextMarker = '${currentNumber + 1}. ';
        final newText = text.replaceRange(cursor, cursor, nextMarker);
        final newCursor = cursor + nextMarker.length;
        block['spans'] = RichTextSpans.shiftForInsert(
          block['spans'] as List?,
          cursor,
          nextMarker.length,
        );
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newCursor),
        );
        onTextChanged(newText);
      }
    }

    // ── Backspace ile numara işaretini TEK seferde silme ───────────────────
    // _maybeHandleBulletBackspace ile TAMAMEN AYNI amaç; tek fark, işaretin
    // sabit 2 karakter ("• ") değil, değişken uzunlukta "N. " olmasıdır.
    // Kullanıcı Backspace'e bastığında önce yalnızca sondaki boşluk silinir
    // (geriye "N." kalır); bu fonksiyon o durumu yakalayıp kalan "N."
    // kısmını da tek seferde siler.
    void _maybeHandleNumberBackspace(
      TextEditingController controller,
      Map<String, dynamic> block,
      String oldText, {
      required void Function(String newText) onTextChanged,
    }) {
      final sel = controller.selection;
      if (!sel.isValid || !sel.isCollapsed) return;
      final text = controller.text;
      final cursor = sel.baseOffset;
      if (cursor < 0 || cursor > text.length) return;
      if (oldText.length != text.length + 1) return;

      final lineStart = _safeLastNewlineIndex(text, cursor - 1) + 1;
      final oldMatch = numberedLoopShortcut.matchAsPrefix(oldText.substring(lineStart));
      if (oldMatch == null) return;
      final oldMarker = oldMatch.group(0)!;
      final markerWithoutSpace = oldMarker.substring(0, oldMarker.length - 1);
      if (cursor == lineStart + markerWithoutSpace.length &&
          text.startsWith(markerWithoutSpace, lineStart)) {
        // Durum A: Backspace işaretin sonundaki boşluğu sildi (geriye
        // "N." kaldı) -> kalan "N."yi de tek seferde sil.
        final newText = text.replaceRange(
          lineStart,
          lineStart + markerWithoutSpace.length,
          '',
        );
        block['spans'] = RichTextSpans.shiftForDelete(
          block['spans'] as List?,
          lineStart,
          lineStart + markerWithoutSpace.length,
        );
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: lineStart),
        );
        onTextChanged(newText);
        return;
      }

      // Durum B: Kullanıcı imleci doğrudan noktanın hemen ARDINA (boşluktan
      // önce) koyup Backspace'e bastı ve yalnızca "." karakteri silindi.
      // Numara ile noktası aynı işaretin iki parçası olduğundan, nokta tek
      // başına silinince geriye anlamsız/yalnız bir sayı ("N text" gibi)
      // kalmasın diye numarayı (rakamları) da birlikte sileriz.
      final digits = oldMatch.group(1)!;
      final dotIndex = lineStart + digits.length; // oldText'te '.' konumu
      if (cursor == dotIndex &&
          oldText.length > dotIndex &&
          oldText[dotIndex] == '.' &&
          text.startsWith(digits, lineStart)) {
        final newText = text.replaceRange(lineStart, dotIndex, '');
        block['spans'] = RichTextSpans.shiftForDelete(
          block['spans'] as List?,
          lineStart,
          dotIndex,
        );
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: lineStart),
        );
        onTextChanged(newText);
      }
    }

    // ── Madde/numara işaretinden hemen sonraki ilk harfi büyütme ───────
    // TextField'daki textCapitalization: TextCapitalization.sentences
    // yalnızca klavyenin KENDİ cümle-başı sezgisine dayanır; bu sezgi
    // nokta/ünlem/soru işareti gibi noktalama arar. "• " veya "1. " gibi
    // madde işaretleri noktalama olarak tanınmadığından, işaretten hemen
    // sonra yazılan ilk harf küçük kalıyordu (bkz. kullanıcı bildirimi).
    // Burada bunu elle düzeltiyoruz: satır tam olarak bulletMarker veya
    // "N. " işaretiyle başlıyorsa ve az önce yazılan karakter o işaretten
    // hemen sonraki (satırın) İLK harfiyse, büyük harfe çevriliyor.
    // Türkçe 'i' -> 'İ' özel durumu elle eşleniyor (Dart'ın varsayılan
    // toUpperCase()'i bunu 'İ' değil 'I' yapıyor).
    void _maybeCapitalizeFirstListChar(
      TextEditingController controller,
      Map<String, dynamic> block,
    ) {
      final sel = controller.selection;
      if (!sel.isValid || !sel.isCollapsed) return;
      final text = controller.text;
      final cursor = sel.baseOffset;
      if (cursor <= 0 || cursor > text.length) return;

      final justTyped = text[cursor - 1];
      if (!RegExp(r'^[a-zçğıöşü]$').hasMatch(justTyped)) return;

      final lineStart = _safeLastNewlineIndex(text, cursor - 2) + 1;
      final beforeChar = text.substring(lineStart, cursor - 1);
      final isBulletStart = beforeChar == bulletMarker;
      final numberMatch = numberedLoopShortcut.matchAsPrefix(beforeChar);
      final isNumberStart =
          numberMatch != null && numberMatch.group(0) == beforeChar;
      if (!isBulletStart && !isNumberStart) return;

      final upper = justTyped == 'i' ? 'İ' : justTyped.toUpperCase();
      if (upper == justTyped) return;
      final newText = text.replaceRange(cursor - 1, cursor, upper);
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: cursor),
      );
      block['text'] = newText;
    }

    // toggleBold/toggleItalic çağrıldığında ya da "- "/"* " kısayolu veya

    // Enter'da bullet ekleme/kaldırma durumunda spans zaten
    // shiftForInsert/shiftForDelete ile güncelleniyordu. AMA kullanıcının
    // sıradan yazması (harf ekleme/silme, otomatik düzeltme, seçili metni
    // yazarak değiştirme) hiçbir zaman bu kaydırmayı tetiklemiyordu — metin
    // bloğunun onChanged'i doğrudan block['text']'i yeni değere eşitleyip
    // block['spans']'a hiç dokunmuyordu. Sonuç: kalın yapılmış bir kelimenin
    // ortasına bir harf eklendiğinde metin kayıyor ama span'ların
    // start/end'i eski karakter indekslerinde kalıyor, bu yüzden o
    // noktadan sonraki kısım (kelimenin "yarısı") artık yanlış aralığı
    // işaret ettiğinden ince görünüyordu.
    //
    // Çözüm: her onChanged'de eski metin (oldText) ile yeni metni (newText)
    // karşılaştırıp ortak önek/sonek dışında kalan "değişen" aralığı
    // buluyoruz; o aralık eskiden bir şey içeriyorsa shiftForDelete, yeni
    // metinde bir şey içeriyorsa shiftForInsert uyguluyoruz. Bu, tek harf
    // eklemeyi de, silmeyi de, seçili bir kelimeyi başka bir kelimeyle
    // değiştirmeyi (klavyenin otomatik düzeltmesi dahil) de doğru şekilde
    // kapsar.
    // DÜZELTME (kalın/italik/vurgu bir harf koyu bir harf ince şeklinde
    // dönüşümlü çıkıyordu): Bu fonksiyon eskiden değişikliğin METİNDE
    // NEREDE olduğunu, "ortak önek/ortak sonek" (common prefix/suffix)
    // sayarak TAHMİN ediyordu. Bu tahmin, düzenleme noktasının hemen
    // yanındaki karakter kendisiyle aynıysa (ör. bir kelimenin ortasına
    // önceki/sonraki harfle AYNI bir harf eklenmesi, ya da klavyenin
    // otomatik düzeltmesinin bir kelimeyi yeniden yazması) YANLIŞ konumu
    // hesaplayabiliyordu — çünkü algoritma sondan/baştan sayarken tesadüfi
    // eşleşen karakterleri "değişmedi" sanıp gerçek düzenleme sınırını 1+
    // karakter kaydırıyordu. Sonuç: shiftForInsert/shiftForDelete yanlış
    // indekse uygulanıyor, span sınırı gerçek metinden kayıyor; bu da her
    // yeni harfte tekrarlanınca komşu karakterlerin "bir kalın bir ince"
    // görünmesine yol açıyordu (composing-range breakpoint sorunuyla aynı
    // aile, farklı kaynak).
    //
    // ÇÖZÜM: Tahmin etmek yerine Flutter'ın zaten verdiği KESİN bilgiyi
    // kullan — onChanged tetiklendiğinde controller.selection artık YENİ
    // (değişiklik sonrası) imleç konumunu taşır. Eklenen/silinen uzunluk
    // (newText.length - oldText.length) ile bu konumu birleştirince,
    // düzenlemenin nerede olduğu TAHMİN edilmez, hesaplanır. Bu hesap
    // ayrıca oldText/newText üzerinde substring karşılaştırmasıyla
    // DOĞRULANIR; tutmazsa (ör. otomatik düzeltme metnin başka bir yerini
    // de değiştirdiyse, ya da cursorPosition sağlanmadıysa) eski
    // önek/sonek algoritmasına YEDEK olarak düşülür — böylece hiçbir
    // durumda davranış eskisinden daha kötü olmaz.
    void _shiftSpansForTextChange(
      Map<String, dynamic> block,
      String oldText,
      String newText, {
      int? cursorPosition,
    }) {
      if (oldText == newText) return;
      final lengthDelta = newText.length - oldText.length;

      int? editStart;
      int? oldEditEnd; // eski metinde silinen aralığın bittiği yer
      int? newEditEnd; // yeni metinde eklenen aralığın bittiği yer

      // ── ÖNCELİK: gerçek imleç konumundan KESİN hesap ──────────────────
      if (cursorPosition != null &&
          cursorPosition >= 0 &&
          cursorPosition <= newText.length) {
        if (lengthDelta > 0) {
          // Ekleme: eklenen metnin imlecin HEMEN ÖNÜNDE bittiğini varsay.
          final insertStart = cursorPosition - lengthDelta;
          if (insertStart >= 0 &&
              insertStart <= oldText.length &&
              oldText.substring(0, insertStart) ==
                  newText.substring(0, insertStart) &&
              oldText.substring(insertStart) ==
                  newText.substring(cursorPosition)) {
            editStart = insertStart;
            oldEditEnd = insertStart; // eski metinde silinen yok
            newEditEnd = cursorPosition;
          }
        } else if (lengthDelta < 0) {
          // Silme: silinen aralığın imleçte bittiğini varsay.
          final deleteStart = cursorPosition;
          final deleteEnd = cursorPosition - lengthDelta; // -lengthDelta = silinen uzunluk
          if (deleteStart >= 0 &&
              deleteEnd <= oldText.length &&
              oldText.substring(0, deleteStart) ==
                  newText.substring(0, deleteStart) &&
              oldText.substring(deleteEnd) == newText.substring(deleteStart)) {
            editStart = deleteStart;
            oldEditEnd = deleteEnd;
            newEditEnd = deleteStart;
          }
        }
        // lengthDelta == 0 durumunda (aynı uzunlukta seçili metin
        // değişimi) imleç konumundan tek başına kesin bir sonuç
        // çıkarılamaz; aşağıdaki yedeğe düşülür.
      }

      // ── YEDEK: eski ortak-önek/sonek tahmini (cursor bilgisi yoksa ya
      // da yukarıdaki doğrulama tutmadıysa) ───────────────────────────────
      if (editStart == null) {
        final maxPrefix = math.min(oldText.length, newText.length);
        int prefix = 0;
        while (prefix < maxPrefix && oldText[prefix] == newText[prefix]) {
          prefix++;
        }
        final maxSuffix = maxPrefix - prefix;
        int suffix = 0;
        while (suffix < maxSuffix &&
            oldText[oldText.length - 1 - suffix] ==
                newText[newText.length - 1 - suffix]) {
          suffix++;
        }
        editStart = prefix;
        oldEditEnd = oldText.length - suffix;
        newEditEnd = newText.length - suffix;
      }

      final start = editStart;
      final oldEnd = oldEditEnd!;
      final newEnd = newEditEnd!;

      List? spans = block['spans'] as List?;
      if (oldEnd > start) {
        spans = RichTextSpans.shiftForDelete(spans, start, oldEnd);
      }
      if (newEnd > start) {
        spans = RichTextSpans.shiftForInsert(
          spans,
          start,
          newEnd - start,
        );
        // DÜZELTME: "önce kalına/italiğe bas, sonra yaz" akışı — bekleyen
        // (pending) bold/italic açıksa, az önce EKLENEN karakter aralığına
        // (start..newEnd) ilgili biçimi uygula. Bu aralık yeni yazıldığı
        // için henüz kendi span'ı yoktur, bu yüzden toggleBold/toggleItalic
        // burada pratikte doğrudan "aç" gibi davranır.
        if (pendingBold) {
          spans = RichTextSpans.toggleBold(
            spans,
            newText.length,
            start,
            newEnd,
          );
        }
        if (pendingItalic) {
          spans = RichTextSpans.toggleItalic(
            spans,
            newText.length,
            start,
            newEnd,
          );
        }
        if (pendingUnderline) {
          spans = RichTextSpans.toggleUnderline(
            spans,
            newText.length,
            start,
            newEnd,
          );
        }
        if (pendingStrikethrough) {
          spans = RichTextSpans.toggleStrikethrough(
            spans,
            newText.length,
            start,
            newEnd,
          );
        }
        if (pendingHighlight) {
          spans = RichTextSpans.toggleHighlight(
            spans,
            newText.length,
            start,
            newEnd,
          );
        }
        // Aynı "önce butona bas, sonra yaz" akışı yazı boyutu/renk/yazı
        // tipi ailesi için de geçerli — tek fark toggle değil DOĞRUDAN
        // DEĞER ataması olması (bkz. _applyValueAttribute).
        if (pendingFontSize != null) {
          spans = RichTextSpans.setFontSize(
            spans,
            newText.length,
            start,
            newEnd,
            pendingFontSize,
          );
        }
        if (pendingColor != null) {
          spans = RichTextSpans.setColor(
            spans,
            newText.length,
            start,
            newEnd,
            pendingColor,
          );
        }
        if (pendingFontFamily != null) {
          spans = RichTextSpans.setFontFamily(
            spans,
            newText.length,
            start,
            newEnd,
            pendingFontFamily,
          );
        }
      }
      block['spans'] = spans;
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
      // Not arka planı özelliği kaldırıldı: eskiden kaydedilmiş bir
      // bgColor olsa bile artık okunmuyor, notlar her zaman varsayılan
      // (arka plansız) görünümle açılır.
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
              // (Kaldırıldı) Kontrol listesi (checklist) bloğu ekleme
              // özelliği tamamen kaldırıldı — insertChecklistBlock() ve
              // araç çubuğundaki "Kontrol Listesi" butonu silindi.

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

              // Yatay çizgi (divider) bloğunu kaldırır. Çizim/ek/hesap
              // tablosu bloklarını kaldırırken kullanılan aynı desen: komşu
              // iki taraf da metin bloğuysa birleştirilir, değilse blok
              // sadece çıkarılır; blok listesi tamamen boş kalırsa boş bir
              // metin bloğu eklenir.
              void removeDividerBlockAt(int i) {
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
                  case 'divider':
                    return 'Ayırıcı Çizgi';
                  case 'checklist':
                    final items = List<Map<String, dynamic>>.from(
                      b['items'] ?? const [],
                    );
                    return 'Kontrol Listesi (${items.length} madde)';
                  default:
                    final t = (b['text'] ?? '').toString().trim();
                    return t.isEmpty ? '(boş metin)' : t;
                }
              }

              IconData blockPreviewIcon(String type) {
                switch (type) {
                  case 'calc_table':
                    return Icons.calculate;
                  case 'drawing':
                    return Icons.draw;
                  case 'attachments':
                    return Icons.attach_file;
                  case 'divider':
                    return Icons.horizontal_rule;
                  case 'checklist':
                    return Icons.checklist_rounded;
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
                  // Çekmece → Hatırlatıcı bölümünden yeni not eklenirken:
                  // ilk geri basışta notu kaydedip kapatmak yerine, önce
                  // hatırlatıcı seçme penceresini aç. Kullanıcı bir tarih
                  // seçebilir ya da pencereyi iptal edebilir; ikisinde de
                  // reminderPromptShown true olur ve BİR SONRAKİ geri
                  // basışta normal kaydet+çık akışı çalışır.
                  if (isNewNote &&
                      _activeCategory == '__reminders__' &&
                      noteReminder == null &&
                      !reminderPromptShown) {
                    reminderPromptShown = true;
                    _handleReminderRowTap(
                      context: context,
                      currentReminder: null,
                      currentRepeat: null,
                      onChanged: (reminder, repeat) {
                        setModalState(() {
                          noteReminder = reminder;
                          noteReminderRepeat = repeat;
                        });
                      },
                    );
                    return;
                  }
                  final saved = _saveNoteIfValid(index, noteType, checkItems, attachments, blocks, noteReminder, noteAssignedDate, noteReminderRepeat, noteBgColor);
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
                  // Not arka planı (palet) özelliği kaldırıldı: artık
                  // her zaman temanın varsayılan rengi kullanılır.
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
                        // Bkz. PopScope'taki aynı isimli blok: yeni not +
                        // Hatırlatıcı bölümü + henüz hatırlatıcı yoksa,
                        // ilk basışta kapatmak yerine hatırlatıcı seçme
                        // penceresini aç.
                        if (isNewNote &&
                            _activeCategory == '__reminders__' &&
                            noteReminder == null &&
                            !reminderPromptShown) {
                          reminderPromptShown = true;
                          _handleReminderRowTap(
                            context: context,
                            currentReminder: null,
                            currentRepeat: null,
                            onChanged: (reminder, repeat) {
                              setModalState(() {
                                noteReminder = reminder;
                                noteReminderRepeat = repeat;
                              });
                            },
                          );
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
                          noteBgColor,
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
                      // "Not Arka Planı" (palet) seçeneği artık aşağıdaki
                      // üç nokta (PopupMenuButton) menüsünün en üstünde
                      // (bkz. itemBuilder içindeki 'note_bg_color' öğesi);
                      // tıklanınca aynı showBgColorSubToolbar mekanizması
                      // üzerinden alt araç çubuğunda renk kartelası açılır.
                      // Not üzerindeki ek özellikler menüsü: "Hesap Tablosu
                      // Ekle"; ileride aynı ikonun altına yeni seçenekler
                      // eklenebilir. (Checklist ekleme özelliği kaldırıldı.)
                      PopupMenuButton<String>(
                        key: moreMenuButtonKey,
                        icon: Icon(
                          Icons.more_vert,
                          color: dNoteEditorAppBarColor(context),
                        ),
                        onSelected: (value) {
                          if (value == 'calc_table') {
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
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    newLabelFns.first.requestFocus();
                                  });
                                });
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
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    newFocusNode.requestFocus();
                                  });
                                });
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
                          // "Not Arka Planı" (palet) menü öğesi kaldırıldı:
                          // artık notlarda arka plan rengi seçilemiyor.
                          if (noteType == 'text')
                            const PopupMenuItem(
                              value: 'calc_table',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calculate,
                                    color: Colors.amber,
                                    size: 24,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Hesap Tablosu'),
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
                                    size: 24,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Çizim Panosu'),
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
                                    size: 24,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Sırala'),
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
                                  size: 24,
                                ),
                                SizedBox(width: 10),
                                Expanded(child: Text('İçe Aktar (txt)')),
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
                                  size: 24,
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
                                    case 'divider':
                                      return true;
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
                                // Sunum NoteCalcTableBlock widget'ına
                                // taşındı (bkz. note_calc_table_block.dart);
                                // satır ekleme/silme, undo checkpoint ve
                                // controller/focus node yönetimi burada
                                // kalıyor çünkü blocks/blockTable*
                                // listelerine (bu metodun local state'i)
                                // doğrudan erişim gerektiriyor.
                                return NoteCalcTableBlock(
                                  blockIndex: i,
                                  rows: rows,
                                  labelControllers: labelCtrls,
                                  valueControllers: valueCtrls,
                                  labelFocusNodes: labelFns,
                                  valueFocusNodes: valueFns,
                                  fontSize: fontSize,
                                  textColor: _textColor,
                                  onLabelChanged: (j, val) {
                                    noteTextEdited(
                                      'calc_label_${i}_$j',
                                      labelCtrls[j],
                                    );
                                    rows[j]['label'] = val;
                                    block['rows'] = rows;
                                  },
                                  onValueChanged: (j, val) {
                                    noteTextEdited(
                                      'calc_value_${i}_$j',
                                      valueCtrls[j],
                                    );
                                    setModalState(() {
                                      rows[j]['value'] = val;
                                      block['rows'] = rows;
                                    });
                                  },
                                  onSubmitRow: (j) {
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
                                      labelFns.insert(newIndex, FocusNode());
                                      valueFns.insert(newIndex, FocusNode());
                                    });
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      labelFns[j + 1].requestFocus();
                                    });
                                  },
                                  onRemoveRow: (j) {
                                    pushUndoCheckpoint();
                                    final removedFocusNodes = <FocusNode>[];
                                    if (j < labelFns.length) {
                                      removedFocusNodes.add(labelFns[j]);
                                    }
                                    if (j < valueFns.length) {
                                      removedFocusNodes.add(valueFns[j]);
                                    }
                                    for (final f in removedFocusNodes) {
                                      if (f.hasFocus) f.unfocus();
                                    }
                                    bool tableRemoved = false;
                                    setModalState(() {
                                      rows.removeAt(j);
                                      block['rows'] = rows;
                                      if (rows.isEmpty) {
                                        // Son satır da silindi: "Toplam"
                                        // satırıyla birlikte boş bir tablo
                                        // ekranda asılı kalmasın diye hesap
                                        // tablosu bloğunun tamamını
                                        // kaldırıyoruz. Ek/checklist bloğu
                                        // silinirken kullanılanla aynı
                                        // desen: komşu metin blokları varsa
                                        // birleştir, yoksa sadece bloğu
                                        // çıkar; blok listesi tamamen boş
                                        // kalırsa boş bir metin bloğu ekle.
                                        // Controller/focus node dispose'u
                                        // rebuildBlockControllers() güvenli
                                        // şekilde kendisi yapar; burada
                                        // ayrıca dispose ETMİYORUZ (çift
                                        // dispose çökmeye yol açar).
                                        tableRemoved = true;
                                        final prevIsText =
                                            i > 0 &&
                                            blocks[i - 1]['type'] == 'text';
                                        final nextIsText =
                                            i < blocks.length - 1 &&
                                            blocks[i + 1]['type'] == 'text';
                                        if (prevIsText && nextIsText) {
                                          final mergedText =
                                              ((blocks[i - 1]['text'] ?? '')
                                                  .toString()) +
                                              ((blocks[i + 1]['text'] ?? '')
                                                  .toString());
                                          blocks[i - 1]['text'] = mergedText;
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
                                          labelCtrls.removeAt(j).dispose();
                                        }
                                        if (j < valueCtrls.length) {
                                          valueCtrls.removeAt(j).dispose();
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
                                        removedFocusNodes.isNotEmpty) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        for (final f in removedFocusNodes) {
                                          f.dispose();
                                        }
                                      });
                                    }
                                  },
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
                                final fontSize = index != null
                                    ? ((_notes[index!]['fontSize'] as num?)
                                              ?.toDouble() ??
                                          _globalFontSize)
                                    : _globalFontSize;
                                return NoteChecklistBlock(
                                  key: ValueKey('blk_checklist_$i'),
                                  blockIndex: i,
                                  items: items,
                                  controllers: itemCtrls,
                                  focusNodes: itemFns,
                                  fontSize: fontSize,
                                  textColor: _textColor,
                                  onTextChanged: (j, val) {
                                    noteTextEdited(
                                      'checklist_${i}_$j',
                                      itemCtrls[j],
                                    );
                                    final oldText = (items[j]['text'] ?? '').toString();
                                    final cursorPos = itemCtrls[j].selection.baseOffset;
                                    _shiftSpansForTextChange(
                                      items[j],
                                      oldText,
                                      val,
                                      cursorPosition: cursorPos >= 0 ? cursorPos : null,
                                    );
                                    items[j]['text'] = val;
                                    block['items'] = items;
                                  },
                                  onToggle: (j) {
                                    pushUndoCheckpoint();
                                    setModalState(() {
                                      items[j]['checked'] =
                                          !(items[j]['checked'] as bool? ??
                                              false);
                                      block['items'] = items;
                                    });
                                  },
                                  onAddItem: (j) {
                                    pushUndoCheckpoint();
                                    final newIndex = j + 1;
                                    setModalState(() {
                                      items.insert(newIndex, {
                                        'text': '',
                                        'checked': false,
                                      });
                                      block['items'] = items;
                                      final capturedBlockIndex = i;
                                      final capturedItemIndex = newIndex;
                                      final newCtrl = RichBlockTextController(
                                        text: '',
                                        getSpans: () {
                                          if (capturedBlockIndex >= blocks.length) return [];
                                          final blk = blocks[capturedBlockIndex];
                                          if (blk['type'] != 'checklist') return [];
                                          final its = blk['items'] as List?;
                                          if (its == null || capturedItemIndex >= its.length) return [];
                                          return RichTextSpans.parse(
                                            (its[capturedItemIndex] as Map)['spans'],
                                          );
                                        },
                                      );
                                      final newFn = FocusNode();
                                      newFn.addListener(() {
                                        if (newFn.hasFocus) {
                                          focusedBlockIndex = capturedBlockIndex;
                                          focusedItemIndex = capturedItemIndex;
                                          requestEditorRebuild?.call(() {});
                                        }
                                      });
                                      itemCtrls.insert(newIndex, newCtrl);
                                      itemFns.insert(newIndex, newFn);
                                    });
                                    // Çift addPostFrameCallback: ilk frame'de
                                    // setModalState sonrası widget ağacı
                                    // (yeni controller/focus node) kurulur,
                                    // ikinci frame'de requestFocus yapılır —
                                    // böylece klavye (TextInputConnection)
                                    // tam olarak yeniden kurulur ve
                                    // TextCapitalization.sentences ayarı
                                    // (ilk harf büyük göstergesi) doğru
                                    // yansır; tek frame'de bazen klavye
                                    // güncellenmiyordu.
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        if (newIndex < itemFns.length) {
                                          itemFns[newIndex].requestFocus();
                                        }
                                      });
                                    });
                                  },
                                  // Madde boşken Backspace'e basıldığında
                                  // ya da çarpı ikonuna basıldığında
                                  // çağrılır: madde checklist'ten çıkar,
                                  // (varsa) metnini siler ve imleç aynı
                                  // satırda kalacak şekilde boş bir düz
                                  // metin satırına dönüştürür. Madde
                                  // listenin başında/ortasında/sonunda
                                  // olmasına göre checklist bloğu gerekirse
                                  // ikiye bölünür (yalnızca "Liste" araç
                                  // çubuğu toggle'ındaki bölme deseniyle
                                  // aynı yaklaşım, bkz. insertChecklistBlock).
                                  onConvertItemToText: (j) {
                                    pushUndoCheckpoint();
                                    int focusBlockIndex = i;
                                    setModalState(() {
                                      if (j < 0 || j >= items.length) return;
                                      items.removeAt(j);
                                      if (items.isEmpty) {
                                        // Tek maddeydi: checklist bloğunun
                                        // tamamı yerinde boş bir metin
                                        // satırına dönüşür.
                                        blocks[i] = {'type': 'text', 'text': ''};
                                        focusBlockIndex = i;
                                      } else if (j == 0) {
                                        // İlk madde çıkarıldı: checklist'in
                                        // önüne boş bir metin satırı eklenir.
                                        block['items'] = items;
                                        blocks.insert(
                                          i,
                                          {'type': 'text', 'text': ''},
                                        );
                                        focusBlockIndex = i;
                                      } else if (j >= items.length) {
                                        // Son madde çıkarıldı: checklist'in
                                        // ardına boş bir metin satırı eklenir.
                                        block['items'] = items;
                                        blocks.insert(
                                          i + 1,
                                          {'type': 'text', 'text': ''},
                                        );
                                        focusBlockIndex = i + 1;
                                      } else {
                                        // Ortadan çıkarıldı: bloğu ikiye
                                        // böl, arasına boş metin satırı koy.
                                        final upperItems = items.sublist(0, j);
                                        final lowerItems = items.sublist(j);
                                        block['items'] = upperItems;
                                        blocks.insert(
                                          i + 1,
                                          {'type': 'text', 'text': ''},
                                        );
                                        blocks.insert(i + 2, {
                                          'type': 'checklist',
                                          'items': lowerItems,
                                        });
                                        focusBlockIndex = i + 1;
                                      }
                                      if (blocks.isEmpty) {
                                        blocks.add({
                                          'type': 'text',
                                          'text': '',
                                        });
                                        focusBlockIndex = 0;
                                      }
                                      rebuildBlockControllers();
                                    });
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        final idx = focusBlockIndex.clamp(
                                          0,
                                          blockFocusNodes.length - 1,
                                        );
                                        final fn = blockFocusNodes[idx];
                                        if (fn != null) {
                                          fn.requestFocus();
                                          final ctrl = blockControllers[idx];
                                          if (ctrl != null) {
                                            ctrl.selection =
                                                TextSelection.collapsed(
                                              offset: 0,
                                            );
                                          }
                                        }
                                      });
                                    });
                                  },
                                  // Sürükleme tutamacıyla bir madde başka
                                  // bir konuma taşındığında: items,
                                  // controller ve focus node listeleri
                                  // birlikte (senkron kalacak şekilde)
                                  // yeniden sıralanır.
                                  onReorder: (oldIndex, newIndex) {
                                    pushUndoCheckpoint();
                                    setModalState(() {
                                      // ReorderableListView semantiği:
                                      // oldIndex < newIndex ise hedef
                                      // konum, öğe eski listeden
                                      // çıkarılmadan ÖNCEKİ indekse göre
                                      // 1 fazla verilir; düzeltiyoruz.
                                      var target = newIndex;
                                      if (oldIndex < target) target -= 1;
                                      final movedItem = items.removeAt(
                                        oldIndex,
                                      );
                                      items.insert(target, movedItem);
                                      block['items'] = items;
                                      final movedCtrl = itemCtrls.removeAt(
                                        oldIndex,
                                      );
                                      itemCtrls.insert(target, movedCtrl);
                                      final movedFn = itemFns.removeAt(
                                        oldIndex,
                                      );
                                      itemFns.insert(target, movedFn);
                                    });
                                  },
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
                              if (block['type'] == 'divider') {
                                // Sayfayı boydan boya kaplayan yatay çizgi.
                                // Divider genişliği ebeveyninin (blok
                                // sütununun) tamamını kapladığı için ayrıca
                                // bir width ayarına gerek yok. Ek/çizim
                                // bloklarındaki "uzun bas -> sil" deseniyle
                                // aynı şekilde uzun basılınca (onay
                                // istenmeden, Geri Al ile telafi edilebilir)
                                // kaldırılır.
                                //
                                // DÜZELTME: Çizgi rengi eskiden doğrudan
                                // dNoteBorderColor(context) idi — bu paylaşılan
                                // tema rengi (ek kartları/çerçeveler gibi
                                // birçok yerde de kullanıldığından burada
                                // DEĞİŞTİRİLMEDİ) kullanıcıya göre fazla silik
                                // görünüyordu. Bu yüzden sadece BU çizgiye
                                // özel, tema yönüne göre bir ton AÇILAN
                                // (koyu temada beyaza, açık temada siyaha
                                // %25 yaklaştırılan) daha belirgin bir renk
                                // uygulanıyor — dNoteBorderColor'ın diğer
                                // kullanım yerleri (ek kartları vb.) etkilenmez.
                                final isDark =
                                    Theme.of(context).brightness ==
                                    Brightness.dark;
                                final dividerLineColor = Color.lerp(
                                  dNoteBorderColor(context),
                                  isDark ? Colors.white : Colors.black,
                                  0.25,
                                )!;
                                return GestureDetector(
                                  key: ValueKey('blk_divider_$i'),
                                  onLongPress: () => removeDividerBlockAt(i),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Divider(
                                      thickness: 2,
                                      color: dividerLineColor,
                                    ),
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
                                    // Span kaydırma için bu tuş vuruşundan
                                    // ÖNCEKİ metin (henüz üzerine yazılmadan
                                    // önceki hali) gerekiyor.
                                    final oldTextForSpans =
                                        (block['text'] ?? '').toString();
                                    // Bu blok daha önce mantıken boş muydu
                                    // (yalnızca görünmez işaretçi vardı)?
                                    final wasLogicallyEmpty =
                                        oldTextForSpans.isEmpty;
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
                                      // Metin tamamen boşaldığı için eski
                                      // span'ların artık işaret edeceği
                                      // hiçbir karakter kalmadı; temizle.
                                      block['text'] = '';
                                      block['spans'] = [];
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
                                      _shiftSpansForTextChange(
                                        block,
                                        oldTextForSpans,
                                        cleaned,
                                        cursorPosition: newOffset.clamp(
                                          0,
                                          cleaned.length,
                                        ),
                                      );
                                      block['text'] = cleaned;
                                    } else {
                                      _shiftSpansForTextChange(
                                        block,
                                        oldTextForSpans,
                                        val,
                                        cursorPosition:
                                            blockControllers[i]!
                                                .selection
                                                .baseOffset,
                                      );
                                      block['text'] = val;
                                    }
                                    // Aşama 5: "- "/"* " -> "• " kısayolu ve
                                    // Enter'da bullet modunun devamı/çıkışı.
                                    _maybeHandleBulletShortcut(
                                      blockControllers[i]!,
                                      block,
                                      onTextChanged: (newText) {
                                        block['text'] = newText;
                                      },
                                    );
                                    // Backspace, "• " işaretinin boşluğunu
                                    // sildiyse geriye kalan "•" karakterini
                                    // de sil (işaret TEK Backspace'te
                                    // tamamen kalksın).
                                    _maybeHandleBulletBackspace(
                                      blockControllers[i]!,
                                      block,
                                      oldTextForSpans,
                                      onTextChanged: (newText) {
                                        block['text'] = newText;
                                      },
                                    );
                                    // Numaralı liste: Enter'da devam/çıkış
                                    // ve tek Backspace'te işareti tamamen
                                    // silme (bkz. yukarıdaki bullet
                                    // handler'larıyla aynı desen).
                                    _maybeHandleNumberShortcut(
                                      blockControllers[i]!,
                                      block,
                                      onTextChanged: (newText) {
                                        block['text'] = newText;
                                      },
                                    );
                                    _maybeHandleNumberBackspace(
                                      blockControllers[i]!,
                                      block,
                                      oldTextForSpans,
                                      onTextChanged: (newText) {
                                        block['text'] = newText;
                                      },
                                    );
                                    // Madde/numara işaretinden hemen
                                    // sonraki ilk harfi büyütür (bkz.
                                    // fonksiyon tanımındaki not).
                                    _maybeCapitalizeFirstListChar(
                                      blockControllers[i]!,
                                      block,
                                    );
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
                                  onTap: () {
                                    // Odak başka bir bloğa geçiyorsa,
                                    // bekleyen (henüz hiç harf yazılmamış)
                                    // kalın/italik durumu bu yeni blokla
                                    // ilgisiz olduğundan sıfırlanır.
                                    if (focusedBlockIndex != i) {
                                      pendingBold = false;
                                      pendingItalic = false;
                                      pendingUnderline = false;
                                      pendingStrikethrough = false;
                                      pendingHighlight = false;
                                      pendingFontSize = null;
                                      pendingColor = null;
                                      pendingFontFamily = null;
                                      showListSubToolbar = false;
                                      showStyleSubToolbar = false;
                                      showColorSubToolbar = false;
                                      showFontSizeSubToolbar = false;
                                    }
                                    focusedBlockIndex = i;
                                  },
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
                                        // DÜZELTME: Metin bloklarında olduğu
                                        // gibi checklist maddeleri de
                                        // kalın/italik/vb. span destekliyor
                                        // (araç çubuğu _resolveFocusedSpansHolder
                                        // ile buraya da uygulanabiliyor), ama
                                        // bu onChanged eskiden sadece
                                        // checkItems[i]['text']'i güncelleyip
                                        // checkItems[i]['spans']'a hiç
                                        // dokunmuyordu — bir maddeyi kalın
                                        // yaptıktan sonra o maddede yazmaya
                                        // devam edildiğinde span'lar eski
                                        // (kaymış) karakter konumlarında
                                        // kalıyordu. Metin bloklarındakiyle
                                        // AYNI kaydırma burada da uygulanır.
                                        final oldItemText =
                                            (checkItems[i]['text'] ?? '')
                                                .toString();
                                        _shiftSpansForTextChange(
                                          checkItems[i],
                                          oldItemText,
                                          val,
                                          cursorPosition:
                                              checkControllers[i]
                                                  .selection
                                                  .baseOffset,
                                        );
                                        checkItems[i]['text'] = val;
                                      },
                                      onSubmitted: (_) {
                                        // DÜZELTME: Boş bırakılan bir
                                        // satırda Enter'a basılınca artık
                                        // yeni bir madde EKLENMİYOR — bunun
                                        // yerine bu boş madde listeden
                                        // silinip kontrol listesi
                                        // tamamlanmış sayılıyor (klavye
                                        // kapatılıyor). Google Keep/Apple
                                        // Hatırlatıcılar'daki "boş satırda
                                        // Enter = listeyi bitir" deseniyle
                                        // aynı.
                                        final isEmpty = checkControllers[i]
                                            .text
                                            .trim()
                                            .isEmpty;
                                        if (isEmpty) {
                                          pushUndoCheckpoint();
                                          final removedFocusNode =
                                              checkFocusNodes[i];
                                          if (removedFocusNode.hasFocus) {
                                            removedFocusNode.unfocus();
                                          }
                                          setModalState(() {
                                            // Liste tamamen boş kalmasın diye
                                            // en az 1 madde her zaman
                                            // korunur — tek madde varsa ve o
                                            // da boşsa silinmez, sadece
                                            // klavye kapatılır.
                                            if (checkItems.length > 1) {
                                              checkItems.removeAt(i);
                                              checkControllers
                                                  .removeAt(i)
                                                  .dispose();
                                              checkFocusNodes.removeAt(i);
                                            }
                                            newlyAddedIndex = null;
                                          });
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            removedFocusNode.dispose();
                                          });
                                          return;
                                        }
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
                                            _saveNoteIfValid(index, noteType, checkItems, attachments, blocks, noteReminder, noteAssignedDate, noteReminderRepeat, noteBgColor);
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
                      Builder(
                        builder: (context) {
                          // Zengin metin araç çubuğu (kalın/italik): tarih
                          // barının hemen üstünde durması istendiği için
                          // artık bottomNavigationBar yerine body Column'un
                          // bir parçası olarak, tarih barından bir önceki
                          // sırada render ediliyor. Scaffold'un
                          // resizeToAvoidBottomInset:true davranışı body'yi
                          // klavyeyle çakışmayacak şekilde zaten daralttığı
                          // için burada ayrıca klavye yüksekliği kadar
                          // Padding eklemeye gerek kalmadı.
                          final hasFocusedTextBlock =
                              focusedBlockIndex >= 0 &&
                              focusedBlockIndex < blockFocusNodes.length &&
                              blockFocusNodes[focusedBlockIndex]?.hasFocus ==
                                  true;
                          final focusedItemFocusNodes =
                              focusedBlockIndex >= 0 &&
                                  focusedBlockIndex < blockItemFocusNodes.length
                              ? blockItemFocusNodes[focusedBlockIndex]
                              : null;
                          final hasFocusedChecklistItem =
                              focusedItemFocusNodes != null &&
                              focusedItemIndex >= 0 &&
                              focusedItemIndex < focusedItemFocusNodes.length &&
                              focusedItemFocusNodes[focusedItemIndex]
                                  .hasFocus;
                          // showBgColorSubToolbar: "Not Arka Planı" butonu
                          // artık üst barda olduğundan ve klavye kapalıyken
                          // de (herhangi bir metin/kontrol listesi öğesi
                          // odaklanmamışken) tıklanabildiğinden, bu satır
                          // odak şartı olmadan da gösterilebilmeli; aksi
                          // halde renk kartelası hiç görünmezdi.
                          if (!hasFocusedTextBlock &&
                              !hasFocusedChecklistItem &&
                              !showBgColorSubToolbar) {
                            return const SizedBox.shrink();
                          }
                          return Material(
                            elevation: 8,
                            color: Theme.of(context).cardColor,
                            child: SizedBox(
                              height: 44,
                              child: Row(
                                children: showListSubToolbar
                                    ? [
                                        // ── Liste alt barı ──────────────────
                                        // "Liste" butonuna basılınca ana bar
                                        // yerine bu satır gösterilir; madde
                                        // ve numara işareti seçenekleri
                                        // buraya taşınmıştır (bkz. ekran
                                        // görüntüleri). X'e basılınca ana
                                        // bara geri dönülür. Beş ikon Stil alt
                                        // barındakiyle aynı desende: her biri
                                        // Expanded içinde, Spacer ile sola
                                        // yaslı durmak yerine kalan genişliğe
                                        // EŞİT olarak yayılıp (kapat butonu
                                        // hariç) yatayda dengeli dağılıyorlar.
                                        Expanded(
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.format_list_bulleted,
                                            ),
                                            tooltip: 'Madde İşareti',
                                            onPressed:
                                                toggleBulletForFocusedBlock,
                                          ),
                                        ),
                                        Expanded(
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.format_list_numbered,
                                            ),
                                            tooltip: 'Numara İşareti',
                                            onPressed:
                                                toggleNumberForFocusedBlock,
                                          ),
                                        ),
                                        Expanded(
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.format_indent_increase,
                                            ),
                                            tooltip: 'Paragraf Girintisi',
                                            onPressed: indentFocusedBlock,
                                          ),
                                        ),
                                        Expanded(
                                          child: IconButton(
                                            icon: const Icon(Icons.link),
                                            tooltip:
                                                'Link Ekle / Düzenle / Kaldır',
                                            onPressed: applyLinkForFocusedBlock,
                                          ),
                                        ),
                                        Expanded(
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.horizontal_rule,
                                            ),
                                            tooltip: 'Yatay Çizgi Ekle',
                                            onPressed: insertDividerBlock,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          tooltip: 'Kapat',
                                          onPressed: () {
                                            showListSubToolbar = false;
                                            requestEditorRebuild?.call(() {});
                                          },
                                        ),
                                      ]
                                    : showStyleSubToolbar
                                    ? [
                                        // ── Stil alt barı ────────────────────
                                        // "Kalın" butonuna basılınca ana bar
                                        // yerine bu satır gösterilir; kalın/
                                        // italik/altı çizili/üzeri çizili/
                                        // vurgulama seçenekleri buraya
                                        // taşınmıştır. X'e basılınca ana
                                        // bara geri dönülür (Liste alt
                                        // barıyla aynı desen). Beş ikon artık
                                        // her biri Expanded içinde: Spacer ile
                                        // sola yaslı durmak yerine, kalan
                                        // genişliğe EŞİT olarak yayılıp
                                        // (kapat butonu hariç) yatayda dengeli
                                        // dağılıyorlar.
                                        Expanded(
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.format_bold,
                                            ),
                                            tooltip: 'Kalın',
                                            color: pendingBold
                                                ? Colors.amber
                                                : null,
                                            onPressed:
                                                toggleBoldForFocusedBlock,
                                          ),
                                        ),
                                        Expanded(
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.format_italic,
                                            ),
                                            tooltip: 'İtalik',
                                            color: pendingItalic
                                                ? Colors.amber
                                                : null,
                                            onPressed:
                                                toggleItalicForFocusedBlock,
                                          ),
                                        ),
                                        Expanded(
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.format_underlined,
                                            ),
                                            tooltip: 'Altı Çizili',
                                            color: pendingUnderline
                                                ? Colors.amber
                                                : null,
                                            onPressed:
                                                toggleUnderlineForFocusedBlock,
                                          ),
                                        ),
                                        Expanded(
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.format_strikethrough,
                                            ),
                                            tooltip: 'Üzeri Çizili',
                                            color: pendingStrikethrough
                                                ? Colors.amber
                                                : null,
                                            onPressed:
                                                toggleStrikethroughForFocusedBlock,
                                          ),
                                        ),
                                        Expanded(
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.format_color_fill,
                                            ),
                                            tooltip: 'Vurgula',
                                            color: pendingHighlight
                                                ? Colors.amber
                                                : null,
                                            onPressed:
                                                toggleHighlightForFocusedBlock,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          tooltip: 'Kapat',
                                          onPressed: () {
                                            showStyleSubToolbar = false;
                                            requestEditorRebuild?.call(() {});
                                          },
                                        ),
                                      ]
                                    : showColorSubToolbar
                                    ? [
                                        // ── Renk alt barı ────────────────────
                                        // "Yazı Rengi" butonuna basılınca ana
                                        // bar yerine bu satır gösterilir;
                                        // eskiden "Metin Özellikleri" bottom
                                        // sheet'i içindeki renk kartelası
                                        // artık burada, Liste/Stil alt
                                        // barlarıyla aynı desende (yatay
                                        // kayan bir liste + kapat butonu)
                                        // sunuluyor. X'e basılınca ana bara
                                        // geri dönülür.
                                        Expanded(
                                          child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            itemCount: textColorOptions.length,
                                            separatorBuilder: (_, __) =>
                                                const SizedBox(width: 10),
                                            itemBuilder: (_, i) {
                                              final opt = textColorOptions[i];
                                              return Center(
                                                child: colorSwatch(
                                                  context,
                                                  opt.$1,
                                                  opt.$2,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          tooltip: 'Kapat',
                                          onPressed: () {
                                            showColorSubToolbar = false;
                                            requestEditorRebuild?.call(() {});
                                          },
                                        ),
                                      ]
                                    : showFontSizeSubToolbar
                                    ? [
                                        // ── Yazı Boyutu alt barı ─────────────
                                        // "Yazı Boyutu" butonuna basılınca ana
                                        // bar yerine bu satır gösterilir;
                                        // eskiden showModalBottomSheet ile
                                        // ayrı bir sayfa olarak açılan boyut
                                        // seçenekleri artık burada, Liste/
                                        // Stil/Renk alt barlarıyla aynı
                                        // desende (yatay kayan bir liste +
                                        // kapat butonu) sunuluyor. X'e
                                        // basılınca ana bara geri dönülür.
                                        Expanded(
                                          child: Padding(
                                            // NOT: Öncesinde burada "left: 8"
                                            // vardı — bu, ilk çipin ekranın
                                            // en soluna DEĞMEMESİNE (görünür
                                            // bir boşluk bırakmasına) yol
                                            // açıyordu. Kapat (X) butonu da
                                            // zaten kendi constraints'iyle
                                            // (36x36, padding: zero) yeterince
                                            // sıkı olduğundan, chip alanına
                                            // solda ekstra boşluk eklemeye
                                            // gerek yok — kaldırıldı ki metin
                                            // için mümkün olan en geniş alan
                                            // kullanılabilsin.
                                            padding: EdgeInsets.zero,
                                            child: Builder(
                                              builder: (context) {
                                                final effectiveSize =
                                                    _effectiveFontSizeForToolbar();
                                                final isMixed =
                                                    _isFontSizeMixedForToolbar();
                                                // Önce hepsinin aktiflik
                                                // durumu hesaplanıyor ki
                                                // her çip kendi seçili/pasif
                                                // rengini (amber/normal)
                                                // buna göre belirleyebilsin.
                                                final activeFlags = [
                                                  for (final opt
                                                      in fontSizeOptions)
                                                    opt.$2 != null
                                                        ? opt.$2 ==
                                                              effectiveSize
                                                        : (effectiveSize ==
                                                                  null &&
                                                              !isMixed),
                                                ];
                                                // Segmentler EŞİT genişlikte
                                                // (Expanded flex 1). Her
                                                // çipin metni artık kendi
                                                // FittedBox'ıyla (bkz.
                                                // fontSizeChip/buildFace)
                                                // gerçek layout anında
                                                // gerektiği kadar küçültülüp
                                                // sığdırılıyor — burada elle
                                                // TextPainter ile önceden
                                                // ölçek hesaplamaya artık
                                                // gerek yok (bu, cihazın
                                                // gerçek yazı tipi
                                                // ölçeklendirmesiyle
                                                // tutarsızlık yüzünden
                                                // metnin bir kısmının
                                                // görünmemesine yol
                                                // açıyordu).
                                                return Row(
                                                  children: [
                                                    for (
                                                      var i = 0;
                                                      i <
                                                          fontSizeOptions
                                                              .length;
                                                      i++
                                                    )
                                                      Expanded(
                                                        child: fontSizeChip(
                                                          context,
                                                          fontSizeOptions[i]
                                                              .$1,
                                                          fontSizeOptions[i]
                                                              .$2,
                                                          isActive:
                                                              activeFlags[i],
                                                          labelStyle:
                                                              fontSizeChipLabelStyles[i],
                                                        ),
                                                      ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          tooltip: 'Kapat',
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(
                                            minWidth: 36,
                                            minHeight: 36,
                                          ),
                                          onPressed: () {
                                            showFontSizeSubToolbar = false;
                                            requestEditorRebuild?.call(() {});
                                          },
                                        ),
                                      ]
                                    : [
                                  // ── Ana araç çubuğu ──────────────────────
                                  // 6 ikon (Liste, Kalın, Yazı Boyutu, Yazı
                                  // Rengi, Kontrol Listesi, Klavyeyi Gizle)
                                  // alt barlardaki gibi her biri Expanded
                                  // içinde: Spacer ile en sağa yaslı durmak
                                  // yerine (Klavyeyi Gizle dahil) hepsi kalan
                                  // genişliğe EŞİT olarak yayılıp yatayda
                                  // dengeli dağılıyorlar.
                                  Expanded(
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.format_list_bulleted,
                                      ),
                                      tooltip: 'Liste',
                                      onPressed: () {
                                        showListSubToolbar = true;
                                        showStyleSubToolbar = false;
                                        showColorSubToolbar = false;
                                        showFontSizeSubToolbar = false;
                                        showBgColorSubToolbar = false;
                                        requestEditorRebuild?.call(() {});
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.format_bold,
                                        size: 25,
                                      ),
                                      tooltip: 'Kalın',
                                      color:
                                          (pendingBold ||
                                                  pendingItalic ||
                                                  pendingUnderline ||
                                                  pendingStrikethrough ||
                                                  pendingHighlight)
                                              ? Colors.amber
                                              : null,
                                      onPressed: () {
                                        showStyleSubToolbar = true;
                                        showListSubToolbar = false;
                                        showColorSubToolbar = false;
                                        showFontSizeSubToolbar = false;
                                        showBgColorSubToolbar = false;
                                        requestEditorRebuild?.call(() {});
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      icon: const Icon(Icons.text_fields),
                                      tooltip: 'Yazı Boyutu',
                                      // pendingFontSize yerine
                                      // _effectiveFontSizeForToolbar()
                                      // kullanılıyor: seçim yokken davranış
                                      // aynıdır (o da pendingFontSize'a
                                      // düşer), ama gerçek bir metin seçimi
                                      // varken artık seçili aralığın
                                      // span'larından okunan GERÇEK boyuta
                                      // göre vurgulanır (bkz. yukarıdaki
                                      // _effectiveFontSizeForToolbar
                                      // açıklaması).
                                      color:
                                          _effectiveFontSizeForToolbar() !=
                                              null
                                          ? Colors.amber
                                          : null,
                                      onPressed: () {
                                        showFontSizeSubToolbar = true;
                                        showListSubToolbar = false;
                                        showStyleSubToolbar = false;
                                        showColorSubToolbar = false;
                                        showBgColorSubToolbar = false;
                                        requestEditorRebuild?.call(() {});
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.format_color_text,
                                        size: 20,
                                      ),
                                      tooltip: 'Yazı Rengi',
                                      color: pendingColor != null
                                          ? Color(pendingColor!)
                                          : null,
                                      onPressed: () {
                                        showColorSubToolbar = true;
                                        showListSubToolbar = false;
                                        showStyleSubToolbar = false;
                                        showFontSizeSubToolbar = false;
                                        showBgColorSubToolbar = false;
                                        requestEditorRebuild?.call(() {});
                                      },
                                    ),
                                  ),
                                  // "Not Arka Planı" (palet) butonu artık üst
                                  // bardaki geri/ileri al ikonlarının yanında
                                  // (bkz. AppBar actions); burada değil.
                                  Expanded(
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.checklist_rounded,
                                        size: 26,
                                      ),
                                      tooltip: 'Yapılacaklar Listesi Ekle',
                                      onPressed: insertChecklistBlock,
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      icon: const Icon(Icons.keyboard_hide),
                                      tooltip: 'Klavyeyi Gizle',
                                      onPressed:
                                          dismissKeyboardForFocusedBlock,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
