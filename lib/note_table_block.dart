part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// NoteTableBlock
// "table" bloğu için düzenleme arayüzü — Notion tarzı, FORMÜLSÜZ basit bir
// satır/sütun tablosu. calc_table'dan farkı: hücreler serbest (ve artık
// zengin) metin tutar (toplam hesaplanmaz).
//
// JSON şeması (bkz. content_blocks.dart):
//   {"type": "table", "rows": [
//       [{"text": "h1", "spans": []}, {"text": "h2", "spans": [...]}],
//       ...
//   ]}
// Her hücre, 'text' bloğuyla AYNI desende {"text":..., "spans":...} tutar
// (bkz. rich_text_spans.dart). Eski notlarda hücre düz bir String'ti —
// content_blocks.dart -> _normalizeTableCell bunu otomatik olarak
// {"text": eskiDeğer, "spans": []} biçimine çevirir, bu widget her zaman
// normalize edilmiş Map hücrelerle çalışır.
//
// BOYUT ARTIK SABİT: tablo "Blok ekle" menüsünden eklenirken
// [NoteTableBlock.pickSize] ile bir ızgara seçici (en fazla 4 sütun x 8
// satır) üzerinden satır/sütun sayısı seçilir ve [newRows] ile üretilir.
// Widget'ın kendisinde ARTIK satır/sütun ekleme-çıkarma kontrolleri
// (kenarlardaki +/x ikonları) YOKTUR — boyut oluşturulduktan sonra
// değiştirilemez.
//
// TÜM BLOĞU SİLME: sağ üstte sabit duran bir çöp kutusu butonu yerine,
// tablonun herhangi bir yerine UZUN BASILDIĞINDA sağ üst köşede küçük bir
// silme ikonu belirir; ikona dokununca [onDelete] çağrılır, ikonun
// dışında bir yere dokununca ikon kaybolur. NOT: bu uzun-basma jesti,
// hücre içindeki TextField'ın kendi metin-seçme uzun-basma jestiyle
// çakışabilir (tablo genelinde uzun basma önceliklidir) — bu, kullanıcı
// tarafından bilinçli olarak kabul edilen bir ödünleşimdir.
//
// NoteDrawingBlock ile AYNI deseni izler: hücre controller'ları widget'ın
// KENDİ state'inde tutulur (dışarıdaki blockTableLabelControllers gibi
// listelere ihtiyaç yok); değişiklik olduğunda [onChanged] ile güncel
// rows verisi dışarı bildirilir, çağıran taraf bunu block['rows']'a yazar.
// Bloğun TAMAMININ kaldırılması ayrı bir [onDelete] callback'iyle yapılır
// (removeDrawingBlockAt ile birebir aynı "komşu metinleri birleştir"
// deseni note_list_note_dialog_mixin.dart tarafında uygulanır).
//
// ZENGİN METİN ARAÇ ÇUBUĞU ENTEGRASYONU (yeni): 'text' bloğu/checklist
// maddesiyle aynı klavye-üstü kalın/italik/vb. araç çubuğunu tablo
// hücrelerinde de çalıştırmak için, bu widget kendi kapalı state'ini
// KORUYARAK dışarıya iki köprü sağlar:
//   - [onCellTextEdited]: bir hücrede yazı değiştiğinde çağrılır; çağıran
//     taraf (note_list_note_dialog_mixin.dart) bunu KENDİ
//     _shiftSpansForTextChange fonksiyonuna yönlendirir — böylece span
//     kaydırma / "önce butona bas sonra yaz" (pending bold/italic/vb.)
//     mantığı metin bloklarıyla BİREBİR AYNI merkezi koddan çalışır, hiç
//     kopyalanmaz.
//   - [onActiveCellChanged]: bir hücre odağı kazandığında o hücrenin
//     RichBlockTextController'ını VE span verisini (referans olarak,
//     üzerine 'spans' yazılınca gerçek veriye işleyecek şekilde) dışarı
//     verir; hücre odağı kaybettiğinde (null, null) ile çağrılır. Çağıran
//     taraf bunları _resolveFocusedFormatController/_resolveFocusedSpansHolder
//     içinde 'table' dalı olarak kullanır — araç çubuğu böylece hangi alan
//     odaklıysa (metin/checklist/tablo hücresi) ayrım yapmadan çalışır.
// Hücre Map referansları (_rows[r][c]) her zaman ÇAĞIRAN TARAFIN
// block['rows'][r][c] ile AYNI nesnedir (bkz. initState — kopyalama
// yalnızca satır/sütun LİSTELERİ için yapılır, hücre Map'leri klonlanmaz);
// bu sayede araç çubuğunun spansHolder['spans'] = ... yazımı doğrudan
// gerçek veriye işler, ayrıca bir eşitleme adımına gerek kalmaz.
// ════════════════════════════════════════════════════════════════════════
class NoteTableBlock extends StatefulWidget {
  const NoteTableBlock({
    super.key,
    required this.rows,
    required this.onChanged,
    required this.onDelete,
    required this.onCellTextEdited,
    required this.onActiveCellChanged,
    this.borderColor,
    this.textColor,
    this.fontFamily,
    this.fontSize = 14,
    this.autofocus = false,
  });

  /// Bloğun mevcut satır/hücre verisi (content_blocks.dart ->
  /// ContentBlocks.parse() çıktısı, zaten List<List<Map<String,dynamic>>>
  /// — her hücre {"text":..., "spans":...} — olarak normalize edilmiş
  /// olmalı). Satır/sütun sayısı bu widget tarafından artık
  /// değiştirilemez; boyut, blok oluşturulurken [pickSize] / [newRows]
  /// ile sabitlenmiş olmalıdır.
  final List<List<Map<String, dynamic>>> rows;

  /// Herhangi bir hücre değiştiğinde GÜNCEL tam rows verisiyle çağrılır.
  /// Çağıran taraf tipik olarak:
  ///   block['rows'] = newRows;
  /// yapar (calc_table'ın onLabelChanged'ı ile aynı hafiflikte — widget
  /// kendi controller'larıyla zaten güncel göründüğünden burada
  /// setModalState ZORUNLU değildir, sadece veri kalıcılığı için gerekir).
  final void Function(List<List<Map<String, dynamic>>> rows) onChanged;

  /// Kullanıcı tabloyu tamamen kaldırmak istediğinde (tabloya uzun
  /// basılınca beliren çöp kutusu ikonuna dokununca) çağrılır. Blok
  /// listesinden çıkarma / komşu metinleri birleştirme mantığı çağıran
  /// tarafta yapılır.
  final VoidCallback onDelete;

  /// Bir hücrenin metni değiştiğinde (her onChanged'de) çağrılır: hücrenin
  /// kendi veri Map'i (spans buraya yazılır), eski metin, yeni metin ve
  /// (varsa) imleç konumu iletilir. Çağıran taraf burada tipik olarak
  /// merkezi _shiftSpansForTextChange fonksiyonunu çalıştırır — bu widget
  /// span kaydırma mantığını KENDİSİ uygulamaz.
  final void Function(
    Map<String, dynamic> cell,
    String oldText,
    String newText,
    int? cursorPosition,
  ) onCellTextEdited;

  /// Bir hücre odağı kazandığında (controller, spansHolder) ile, odağı
  /// kaybettiğinde (null, null) ile çağrılır. Çağıran taraf bunu
  /// paylaşılan kalın/italik araç çubuğunu tablo hücrelerine bağlamak için
  /// kullanır.
  final void Function(
    RichBlockTextController? controller,
    Map<String, dynamic>? spansHolder,
  ) onActiveCellChanged;

  final Color? borderColor;
  final Color? textColor;
  final String? fontFamily;
  final double fontSize;

  /// Blok yeni eklendiğinde ilk hücreye otomatik odaklanmak için.
  final bool autofocus;

  /// "Blok ekle" menüsünden çağrılacak fabrika: varsayılan 2x2 boş tablo.
  /// Her hücre, 'text' bloğuyla aynı boş {"text":"", "spans":[]} şeklinde
  /// üretilir.
  static List<List<Map<String, dynamic>>> newRows({
    int rows = 2,
    int columns = 2,
  }) {
    return List.generate(
      rows,
      (_) => List.generate(
        columns,
        (_) => <String, dynamic>{
          'text': '',
          'spans': <Map<String, dynamic>>[],
        },
      ),
    );
  }

  /// "Blok ekle" menüsünden çağrılacak asıl giriş noktası: bir ızgara
  /// seçici dialog açar, kullanıcının seçtiği satır/sütun sayısında boş
  /// tablo verisini döner. Kullanıcı vazgeçerse null döner — çağıran
  /// taraf bu durumda bloğu eklememelidir.
  static Future<List<List<Map<String, dynamic>>>?> pickSize(
    BuildContext context,
  ) {
    // DÜZELTME (dialog açılırken "bottom overflowed" hatası): "Tablo
    // Ekle"ye dokunulduğu anda genelde hâlâ odaklı bir metin alanı (başlık/
    // blok) olduğu için klavye açık kalıyordu — showDialog klavyeyi
    // kendiliğinden kapatmıyor. Kullanılabilir dikey alan klavye kadar
    // daraldığından ızgara (özellikle 8 satırlık haliyle) dialog içine
    // sığmıyor ve taşma hatası veriyordu. Dialog açılmadan HEMEN önce
    // mevcut odağı bırakıp klavyeyi kapatıyoruz.
    FocusManager.instance.primaryFocus?.unfocus();
    return showDialog<List<List<Map<String, dynamic>>>>(
      context: context,
      builder: (context) => const _NoteTableSizePickerDialog(),
    );
  }

  @override
  State<NoteTableBlock> createState() => _NoteTableBlockState();
}

class _NoteTableBlockState extends State<NoteTableBlock> {
  /// Çok satırlı/az sütunlu tablolarda hücrelerin okunamayacak kadar
  /// daralmasını önleyen alt sınır. Boyut artık [pickSize] ile en fazla
  /// 4 sütun olacak şekilde seçildirildiğinden bu değerin altına
  /// pratikte hiç inilmez.
  static const double _minCellWidth = 60;

  // NOT: satır/sütun LİSTELERİ burada yeniden oluşturulur (List.from), ama
  // her hücrenin kendisi (Map<String,dynamic>) widget.rows'taki AYNI
  // nesnedir — klonlanmaz. Bu, dışarıdaki paylaşılan araç çubuğunun bir
  // hücrenin spansHolder'ına yazdığı değişikliğin (spansHolder['spans'] =
  // newSpans) doğrudan bu widget'ın da gördüğü veriye işlemesini sağlar;
  // ayrı bir eşitleme/geri-yazma adımına gerek kalmaz.
  late List<List<Map<String, dynamic>>> _rows;
  late List<List<RichBlockTextController>> _controllers;
  late List<List<FocusNode>> _focusNodes;

  /// Şu an odaklı hücrenin (satır, sütun) konumu; hiçbir hücre odaklı
  /// değilse null. Yalnızca [widget.onActiveCellChanged]'i doğru
  /// argümanlarla çağırmak için tutulur — tablo kendi çizimi için buna
  /// ihtiyaç duymaz.
  (int, int)? _activeCell;

  /// Tabloya uzun basılınca true olur, sağ üstte silme ikonu belirir;
  /// ikonun dışına dokununca tekrar false olur.
  bool _showDeleteButton = false;

  /// Basılı tutma algılama: [Listener] ile ham pointer olaylarını
  /// izliyoruz (GestureDetector.onLongPress DEĞİL) çünkü hücrelerdeki
  /// TextField'ların kendi "metin seç" uzun-basma jesti, jest arenasında
  /// (gesture arena) çoğunlukla bizim onLongPress'imizi eziyor — yani
  /// parmak bir TextField'ın üzerindeyken bizim uzun-basmamız hemen hiç
  /// tetiklenmiyordu. Listener, kim arenayı kazanırsa kazansın ham
  /// pointer down/move/up olaylarını HER ZAMAN görür, bu yüzden güvenilir
  /// çalışır. Ayrıca varsayılan ~500ms yerine daha hızlı tetiklenmesi
  /// için 350ms kullanıyoruz.
  static const Duration _holdDuration = Duration(milliseconds: 350);

  /// Parmak/imleç bu mesafeden (px) fazla hareket ederse basılı tutma
  /// iptal edilir (kaydırma/sürükleme ile karışmasın diye).
  static const double _holdMoveTolerance = 12;

  Timer? _holdTimer;
  Offset? _holdStartPosition;

  @override
  void initState() {
    super.initState();
    // ÖNEMLİ: List<Map<String,dynamic>>.from(r) yalnızca satır LİSTESİNİ
    // kopyalar; içindeki hücre Map referansları widget.rows ile AYNI kalır
    // (bkz. sınıf başındaki _rows açıklaması).
    _rows = widget.rows.map((r) => List<Map<String, dynamic>>.from(r)).toList();
    _rebuildControllers();

    if (widget.autofocus) {
      // Bu blok, boyut seçici dialog (pickSize) KAPANDIKTAN hemen sonra
      // ekleniyor. Sorun: dialog'un kapanma (exit) animasyonu bittiğinde
      // Flutter, dialog açılmadan ÖNCE odaklı olan eski metin alanına
      // odağı OTOMATİK OLARAK GERİ VERİYOR — bu geri verme, aşağıdaki
      // normal TextField.autofocus'tan daha GEÇ gerçekleştiği için onu
      // eziyor ve imleç "dışarıda" (eski metin bloğunda) kalıyor.
      // Çözüm: ilk kare bittikten sonra, dialog'un kapanma animasyon
      // süresinden (~200ms) daha uzun bir gecikmeyle odağı tekrar
      // ZORLA ilk hücreye veriyoruz.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 260), () {
          if (!mounted) return;
          if (_focusNodes.isNotEmpty && _focusNodes[0].isNotEmpty) {
            _focusNodes[0][0].requestFocus();
          }
        });
      });
    }
  }

  void _rebuildControllers() {
    _controllers = List.generate(
      _rows.length,
      (r) => List.generate(
        _rows[r].length,
        (c) => RichBlockTextController(
          text: (_rows[r][c]['text'] ?? '').toString(),
          getSpans: () => RichTextSpans.parse(_rows[r][c]['spans']),
        ),
      ),
    );
    _focusNodes = List.generate(
      _rows.length,
      (r) => List.generate(_rows[r].length, (c) {
        final node = FocusNode();
        // Bir hücre odağı kazandığında/kaybettiğinde paylaşılan kalın/
        // italik araç çubuğunun bunu görebilmesi için dışarı bildirilir
        // (bkz. sınıf başındaki [onActiveCellChanged] açıklaması).
        node.addListener(() {
          if (node.hasFocus) {
            _activeCell = (r, c);
            widget.onActiveCellChanged(_controllers[r][c], _rows[r][c]);
          } else if (_activeCell == (r, c)) {
            // Yalnızca kaybeden hücre HALEN "aktif" sayılan hücreyse
            // sıfırla — aksi halde, odak aynı tablo içinde bir hücreden
            // diğerine geçerken (kayıp olayı kazanç olayından SONRA
            // gelirse) az önce doğru şekilde ayarlanmış yeni aktif hücreyi
            // yanlışlıkla null'a çekebilirdi.
            _activeCell = null;
            widget.onActiveCellChanged(null, null);
          }
        });
        return node;
      }),
    );
  }

  /// [widget.rows]'un DIŞARIDAN (undo/redo, not değiştirme vb.) değiştiğini
  /// tespit eder. Normal yazma akışında (_onCellChanged -> onChanged ->
  /// block['rows'] = newRows) hücre Map nesneleri hep AYNI referanstır (bkz.
  /// sınıf başındaki açıklama); bu yüzden object identity karşılaştırması,
  /// gerçek bir dış değişikliği (ör. applySnapshot'ın _deepClone ile
  /// ürettiği tamamen YENİ Map nesneleri) normal kendi-tetiklediğimiz
  /// rebuild'den ayırt etmek için güvenilir ve ucuz bir yöntemdir.
  bool _sameCellIdentities(
    List<List<Map<String, dynamic>>> a,
    List<List<Map<String, dynamic>>> b,
  ) {
    if (a.length != b.length) return false;
    for (int r = 0; r < a.length; r++) {
      if (a[r].length != b[r].length) return false;
      for (int c = 0; c < a[r].length; c++) {
        if (!identical(a[r][c], b[r][c])) return false;
      }
    }
    return true;
  }

  @override
  void didUpdateWidget(covariant NoteTableBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    // DÜZELTME: widget key'i sabit (blk_table_$i) olduğundan Flutter
    // undo/redo sonrası bu State'i yeniden KURMUYOR, sadece widget'ı
    // güncelliyor. Bu override olmadan _rows/_controllers hep initState
    // anındaki eski veriyle kalıyor, dışarıdaki block['rows'] gerçekten
    // eski haline dönse bile ekrandaki hücreler HİÇ güncellenmiyordu —
    // "tablo içinde undo/redo çalışmıyor" sorununun kök nedeni buydu.
    if (!_sameCellIdentities(oldWidget.rows, widget.rows)) {
      _activeCell = null;
      _disposeControllers();
      _rows =
          widget.rows.map((r) => List<Map<String, dynamic>>.from(r)).toList();
      _rebuildControllers();

      // DÜZELTME (asıl istenen davranış: "imleç sildiği/değiştirdiği
      // kutuda kalacak"): "son odaklanılan hücre" tahmini güvenilir değil
      // — hem yanlış hücreye odaklanabiliyor hem de bazen hiçbirine
      // odaklanmayıp imleci tablo dışına kaçırıyordu. Doğrusu: TAHMİN
      // ETMEK yerine eski (oldWidget.rows) ve yeni (_rows) veriyi hücre
      // hücre KARŞILAŞTIRIP metni GERÇEKTEN değişen hücreyi bulmak ve
      // imleci doğrudan ORAYA koymaktır — undo/redo hangi hücreyi
      // etkilediyse imleç tam olarak o hücrede kalır. Tablo bu undo/redo
      // adımından hiç etkilenmediyse (değişiklik başka bir blokta
      // olduysa) hiçbir hücre farklı çıkmaz ve odağa dokunulmaz.
      final changedCell = _findChangedCell(oldWidget.rows, _rows);
      if (changedCell != null) {
        final (row, col) = changedCell;
        // DÜZELTME ("setState() or markNeedsBuild() called during
        // build"): odak talebi buradan senkron çağrılırsa, çağıran
        // tarafın (note_list_note_dialog_mixin.dart) FocusNode listener
        // üzerinden tetiklediği requestEditorRebuild -> StatefulBuilder.
        // setState çağrısı TAM OLARAK bu widget ağacı build EDİLİRKEN
        // tetiklenmiş oluyordu (didUpdateWidget, Element.update sırasında
        // -yani build fazının ortasında- çalışır) ve Flutter bunu kırmızı
        // ekranla reddediyordu. Aynı dosyadaki initState/autofocus
        // bloğunun kullandığı desenle aynı şekilde, odak talebini geçerli
        // build tamamlandıktan SONRAKİ frame'e erteliyoruz.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          // İmleci metnin sonuna koy ki undo sonrası geri gelen
          // (muhtemelen daha kısa/farklı) metnin ortasında geçersiz bir
          // imleç konumunda kalınmasın.
          final controller = _controllers[row][col];
          controller.selection = TextSelection.collapsed(
            offset: controller.text.length,
          );
          _focusNodes[row][col].requestFocus();
          // FocusNode listener zaten widget.onActiveCellChanged'i doğru
          // argümanlarla çağıracak (bkz. _rebuildControllers), burada
          // ayrıca çağırmaya gerek yok.
        });
      }
      // changedCell == null: bu undo/redo bu tabloyu hiç etkilemedi —
      // odağa DOKUNULMUYOR, imleç undo'nun asıl etkilediği yerde kalır.
    }
  }

  /// [oldRows] (undo/redo ÖNCESİ) ile [newRows] (SONRASI) verisini hücre
  /// hücre karşılaştırır, metni değişen İLK hücrenin (satır, sütun)
  /// konumunu döner. Hiçbir hücre değişmediyse null döner — bu, bu
  /// undo/redo adımının bu tabloyu hiç etkilemediği anlamına gelir.
  (int, int)? _findChangedCell(
    List<List<Map<String, dynamic>>> oldRows,
    List<List<Map<String, dynamic>>> newRows,
  ) {
    final rowCount =
        oldRows.length < newRows.length ? oldRows.length : newRows.length;
    for (int r = 0; r < rowCount; r++) {
      final colCount = oldRows[r].length < newRows[r].length
          ? oldRows[r].length
          : newRows[r].length;
      for (int c = 0; c < colCount; c++) {
        final oldText = (oldRows[r][c]['text'] ?? '').toString();
        final newText = (newRows[r][c]['text'] ?? '').toString();
        if (oldText != newText) return (r, c);
      }
    }
    return null;
  }

  void _disposeControllers() {
    for (final row in _controllers) {
      for (final c in row) {
        c.dispose();
      }
    }
    for (final row in _focusNodes) {
      for (final f in row) {
        f.dispose();
      }
    }
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    // Bu blok kaldırılırken/dispose edilirken, hâlâ bu tablonun bir
    // hücresini "aktif" olarak gösteren dış duruma sahipsek temizle —
    // aksi halde çağıran taraf artık var olmayan bir controller'a
    // referans tutmaya devam edebilir.
    if (_activeCell != null) {
      widget.onActiveCellChanged(null, null);
    }
    _disposeControllers();
    super.dispose();
  }

  void _notifyChanged() {
    widget.onChanged(
      _rows.map((r) => List<Map<String, dynamic>>.from(r)).toList(),
    );
  }

  void _onCellChanged(int r, int c, String value) {
    final cell = _rows[r][c];
    final oldText = (cell['text'] ?? '').toString();
    if (oldText != value) {
      // Span kaydırma / "önce butona bas sonra yaz" (pending bold/italic/
      // vb.) mantığı burada UYGULANMAZ — çağıran tarafın merkezi
      // _shiftSpansForTextChange fonksiyonuna yönlendirilir (bkz. sınıf
      // başındaki [onCellTextEdited] açıklaması), böylece metin
      // bloklarıyla birebir aynı davranış tek bir yerden gelir.
      final cursor = _controllers[r][c].selection.baseOffset;
      widget.onCellTextEdited(cell, oldText, value, cursor >= 0 ? cursor : null);
    }
    cell['text'] = value;
    _notifyChanged();
  }

  void _onHoldPointerDown(PointerDownEvent event) {
    _holdStartPosition = event.position;
    _holdTimer?.cancel();
    _holdTimer = Timer(_holdDuration, () {
      if (!mounted) return;
      setState(() => _showDeleteButton = true);
    });
  }

  void _onHoldPointerMove(PointerMoveEvent event) {
    final start = _holdStartPosition;
    if (start == null) return;
    if ((event.position - start).distance > _holdMoveTolerance) {
      _holdTimer?.cancel();
      _holdTimer = null;
    }
  }

  void _onHoldPointerUp(PointerEvent event) {
    _holdTimer?.cancel();
    _holdTimer = null;
    _holdStartPosition = null;
  }

  @override
  Widget build(BuildContext context) {
    final colCount = _rows.isEmpty ? 0 : _rows[0].length;
    final effectiveBorderColor = widget.borderColor ?? dNoteBorderColor(context);
    final effectiveTextColor = dNoteEffectiveTextColor(context, widget.textColor);
    final cellTextStyle = TextStyle(
      fontSize: widget.fontSize,
      color: effectiveTextColor,
      fontFamily: widget.fontFamily,
    );

    final tableBody = LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        final cellWidth = colCount > 0
            ? (availableWidth / colCount).clamp(_minCellWidth, double.infinity)
            : availableWidth;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NOT: Row crossAxisAlignment.stretch kullanıyor; bu satır
            // dikeyde sınırsız yükseklik veren bir üst bağlamda (blok
            // listesi/scrollable) render edildiğinde stretch hücrelere
            // sonsuz yükseklik kısıtı dayatıp "BoxConstraints forces an
            // infinite height" hatasına yol açıyordu. IntrinsicHeight,
            // Row'un gerçek (sonlu) yüksekliğini hesaplayarak bu sorunu
            // çözer.
            for (int r = 0; r < _rows.length; r++)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int c = 0; c < _rows[r].length; c++)
                      Container(
                        width: cellWidth,
                        decoration: BoxDecoration(
                          border: Border.all(color: effectiveBorderColor),
                        ),
                        child: TextField(
                          controller: _controllers[r][c],
                          focusNode: _focusNodes[r][c],
                          autofocus: widget.autofocus && r == 0 && c == 0,
                          style: cellTextStyle,
                          minLines: 1,
                          maxLines: 4,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                          ),
                          onChanged: (v) => _onCellChanged(r, c, v),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: _onHoldPointerDown,
            onPointerMove: _onHoldPointerMove,
            onPointerUp: _onHoldPointerUp,
            onPointerCancel: _onHoldPointerUp,
            child: tableBody,
          ),
          if (_showDeleteButton) ...[
            // Silme ikonunun dışına dokununca ikonu gizleyen, tüm bloğu
            // kaplayan görünmez katman. Bu katman gösterilirken hücre
            // düzenlemesi bilerek engellenir — önce dışarı dokunup
            // ikonu kapatmak gerekir.
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _showDeleteButton = false),
                child: const SizedBox.expand(),
              ),
            ),
            Positioned(
              top: -8,
              right: -8,
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 18,
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                    shape: const CircleBorder(),
                  ),
                  icon: const Icon(Icons.delete_outline),
                  tooltip: AppLocalizations.of(context)!
                      .tableSizePickerDeleteTooltip,
                  onPressed: widget.onDelete,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
// _NoteTableSizePickerDialog
// "Blok ekle" menüsünden tablo seçildiğinde açılan ızgara seçici. Excel/
// Word'deki "Insert Table" ızgarasıyla aynı mantık: en fazla 4 sütun x 8
// satırlık bir ızgara gösterilir.
//
// ÖNEMLİ (dokunmatik ekran düzeltmesi): önceki sürümde her hücrenin
// vurgulanması ayrı bir MouseRegion(onEnter: ...) ile yapılıyordu — bu
// SADECE fare hover'ında tetiklenir, dokunmatik ekranda HİÇ çalışmaz.
// Sonuç: telefonda parmak ekrana değer değmez, önizleme hiç gösterilmeden
// dokunulan hücre anında seçiliyordu ("seçilmiyor" hissi + yanlış boyut).
// Artık TEK bir GestureDetector tüm ızgarayı kaplıyor:
//   - parmak/imleç ızgara üzerinde basılı tutulup gezdirilirken
//     (onPanDown / onPanUpdate) canlı önizleme güncellenir,
//   - parmak kaldırılınca (onPanEnd) o anki vurgulanan boyut onaylanır,
//   - sürüklemeden tek dokunuşta da (onTapUp) dokunulan hücre doğrudan
//     seçilir.
// Izgara ayrıca Wrap yerine açık (deterministik) Row/Column ile
// kuruluyor; böylece satır başına düşen hücre sayısı asla genişlik
// hesabına bağlı belirsizlik yüzünden kaymaz — her zaman TAM 4 sütun x
// 8 satır render edilir.
// ════════════════════════════════════════════════════════════════════════
class _NoteTableSizePickerDialog extends StatefulWidget {
  const _NoteTableSizePickerDialog();

  @override
  State<_NoteTableSizePickerDialog> createState() =>
      _NoteTableSizePickerDialogState();
}

class _NoteTableSizePickerDialogState
    extends State<_NoteTableSizePickerDialog> {
  static const int _maxCols = 4;
  static const int _maxRows = 8;
  static const double _cellSize = 32;
  static const double _cellGap = 4;
  static const double _cellExtent = _cellSize + _cellGap;

  // Vurgulanan boyut. Başlangıçta 2x2 (eski varsayılan tablo boyutuyla
  // tutarlı) vurgulanır.
  int _hoverCols = 2;
  int _hoverRows = 2;

  void _updateFromLocalPosition(Offset local) {
    final col = (local.dx / _cellExtent).floor() + 1;
    final row = (local.dy / _cellExtent).floor() + 1;
    setState(() {
      _hoverCols = col.clamp(1, _maxCols);
      _hoverRows = row.clamp(1, _maxRows);
    });
  }

  void _confirm() {
    Navigator.of(context).pop(
      NoteTableBlock.newRows(rows: _hoverRows, columns: _hoverCols),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gridWidth = _maxCols * _cellSize + (_maxCols - 1) * _cellGap;
    final gridHeight = _maxRows * _cellSize + (_maxRows - 1) * _cellGap;

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.tableSizePickerTitle),
      content: SizedBox(
        width: gridWidth,
        child: SingleChildScrollView(
          // DÜZELTME (geçici "bottom overflowed" hatası): unfocus() ile
          // showDialog arasında klavyenin native tarafta kapanma
          // animasyonu hâlâ sürerken (viewInsets.bottom henüz 0'a
          // inmemişken) dialog birkaç frame boyunca daralmış bir
          // yükseklikle build ediliyordu. İçeriği kaydırılabilir yapmak,
          // bu geçici daralmada taşma HATASI yerine sorunsuz bir kaydırma
          // oluşmasını sağlar; klavye tamamen kapanınca zaten tüm içerik
          // sığar ve kaydırma gerekmez.
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$_hoverCols x $_hoverRows',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onPanDown: (d) => _updateFromLocalPosition(d.localPosition),
                onPanUpdate: (d) => _updateFromLocalPosition(d.localPosition),
                onPanEnd: (_) => _confirm(),
                onTapUp: (d) {
                  _updateFromLocalPosition(d.localPosition);
                  _confirm();
                },
                child: SizedBox(
                  width: gridWidth,
                  height: gridHeight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int r = 1; r <= _maxRows; r++)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: r == _maxRows ? 0 : _cellGap,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (int c = 1; c <= _maxCols; c++)
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: c == _maxCols ? 0 : _cellGap,
                                  ),
                                  child: Container(
                                    width: _cellSize,
                                    height: _cellSize,
                                    decoration: BoxDecoration(
                                      color:
                                          (r <= _hoverRows && c <= _hoverCols)
                                              ? appAccentColor.value
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .surfaceVariant,
                                      border: Border.all(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: appAccentColor.value),
          child: Text(AppLocalizations.of(context)!.tableSizePickerCancel),
        ),
      ],
    );
  }
}
