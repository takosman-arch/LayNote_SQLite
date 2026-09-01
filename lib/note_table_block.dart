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

// ════════════════════════════════════════════════════════════════════════
// AŞAMA 3: satır/sütun ekle-sil popup menüsündeki 4 seçeneği temsil eder.
// Aşama 4'te bu seçimler _NoteTableBlockState içindeki Aşama 1 veri
// mutasyon metodlarına (_insertRowAfter/_deleteRow/_insertColumnAfter/
// _deleteColumn) bağlanacak; bu aşamada yalnızca menünün kendisi ve
// etkin/pasif kuralları kuruluyor.
// ════════════════════════════════════════════════════════════════════════
enum _TableRowColMenuAction {
  insertRowAfter,
  deleteRow,
  insertColumnAfter,
  deleteColumn,
}

// ════════════════════════════════════════════════════════════════════════
// _RowColMenuGrid
// Satır/sütun üç-nokta menüsünü klasik alt alta 4 satırlık liste yerine
// 2x2 bir ızgara olarak gösterir:
//   [Satır Ekle]  [Sütun Ekle]
//   [Satır Sil]   [Sütun Sil]
// showMenu()'nün beklediği PopupMenuEntry<T> arayüzünü uygular, ama
// PopupMenuItem'in "tüm satıra dokununca TEK bir value ile kapan" davranışı
// burada işimize yaramaz (dört farklı aksiyon aynı "satır" içinde yan yana
// durmalı). Bunun yerine kendi InkWell'lerimizle DOĞRUDAN
// Navigator.of(context).pop(action) çağırıyoruz — PopupMenuItem'in
// içeride yaptığı da tam olarak budur, biz sadece 4 ayrı dokunma alanı
// için tekrarlıyoruz.
// ════════════════════════════════════════════════════════════════════════
class _RowColMenuGrid extends PopupMenuEntry<_TableRowColMenuAction> {
  const _RowColMenuGrid({
    required this.insertRowLabel,
    required this.deleteRowLabel,
    required this.insertColumnLabel,
    required this.deleteColumnLabel,
    required this.canInsertRow,
    required this.canDeleteRow,
    required this.canInsertColumn,
    required this.canDeleteColumn,
  });

  final String insertRowLabel;
  final String deleteRowLabel;
  final String insertColumnLabel;
  final String deleteColumnLabel;
  final bool canInsertRow;
  final bool canDeleteRow;
  final bool canInsertColumn;
  final bool canDeleteColumn;

  // İki satır x standart menü satırı yüksekliği (kMinInteractiveDimension
  // ~48) + aradaki ince ayraç çizgisi.
  static const double _cellHeight = 48;

  @override
  double get height => _cellHeight * 2 + 1;

  @override
  bool represents(_TableRowColMenuAction? value) => false;

  @override
  State<_RowColMenuGrid> createState() => _RowColMenuGridState();
}

class _RowColMenuGridState extends State<_RowColMenuGrid> {
  // DÜZELTME (popup gereğinden geniş görünüyordu): eskiden her hücre
  // sabit 132px genişlikteydi — "Satır Ekle" gibi kısa metinlerin
  // etrafında gereksiz boşluk bırakıyordu. Artık Table widget'ı
  // kullanılıyor: her sütunun genişliği IntrinsicColumnWidth ile o
  // sütundaki EN UZUN metne göre otomatik hesaplanıyor (ör. "Sütun
  // Ekle"), böylece popup içeriğe göre daralıp genişliyor. Table ayrıca
  // (Row+Expanded'ın aksine) showMenu()'nün IntrinsicWidth ölçümüyle
  // sorunsuz çalışıyor.
  Widget _cell({
    required String label,
    required bool enabled,
    required _TableRowColMenuAction action,
  }) {
    final disabledColor = Theme.of(context).disabledColor;
    return InkWell(
      onTap: enabled
          ? () => Navigator.of(context).pop<_TableRowColMenuAction>(action)
          : null,
      child: Container(
        height: _RowColMenuGrid._cellHeight,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: enabled ? null : disabledColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // DÜZELTME (ayraç görünmüyordu): Theme.of(context).dividerColor
    // buradaki gibi doğrudan kullanıldığında Flutter'ın varsayılan koyu
    // temasında ~%14 opaklıkta beyaz (Colors.white24) gibi çok düşük
    // kontrastlı bir renk oluyor; showMenu()'nün ürettiği (Material 3'te
    // hafif yükseltilmiş/daha açık tonlu) popup arka planı üzerinde bu
    // neredeyse hiç seçilmiyordu. Tablo çizgilerinde (bkz. yukarıdaki
    // effectiveBorderColor) uygulanan aynı çözüm burada da kullanılıyor:
    // dividerColor, temanın parlaklığına göre siyaha/beyaza belirgin
    // şekilde yaklaştırılıyor — popup'ın gerçek arka plan tonu ne olursa
    // olsun çizgi görünür kalır.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = Color.lerp(
      Theme.of(context).dividerColor,
      isDark ? Colors.white : Colors.black,
      0.35,
    )!;
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      // DÜZELTME (ayraç isteği): eskiden her satırın kendi (o satırla
      // sınırlı, kısa) VerticalDivider'ı vardı ve aradaki yatay Divider
      // bunu ikiye bölüyordu — sonuç, "Satır" bölümüyle "Sütun" bölümünü
      // TEK bir çizgiyle değil, aradan kesilmiş iki kısa çizgiyle
      // ayırıyordu. TableBorder.verticalInside, sütunlar arasına TABLONUN
      // TAMAMI boyunca (boydan boya) TEK bir dikey çizgi çizer;
      // horizontalInside de Ekle/Sil satırları arasına ince bir yatay
      // çizgi ekler.
      border: TableBorder(
        verticalInside: BorderSide(color: dividerColor, width: 1),
        horizontalInside: BorderSide(color: dividerColor, width: 1),
      ),
      children: [
        TableRow(
          children: [
            _cell(
              label: widget.insertRowLabel,
              enabled: widget.canInsertRow,
              action: _TableRowColMenuAction.insertRowAfter,
            ),
            _cell(
              label: widget.insertColumnLabel,
              enabled: widget.canInsertColumn,
              action: _TableRowColMenuAction.insertColumnAfter,
            ),
          ],
        ),
        TableRow(
          children: [
            _cell(
              label: widget.deleteRowLabel,
              enabled: widget.canDeleteRow,
              action: _TableRowColMenuAction.deleteRow,
            ),
            _cell(
              label: widget.deleteColumnLabel,
              enabled: widget.canDeleteColumn,
              action: _TableRowColMenuAction.deleteColumn,
            ),
          ],
        ),
      ],
    );
  }
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

  /// DÜZELTME (Geri Al sonrası imleç tablo dışında kalıyordu — devamı):
  /// [_activeCell] bir hücre odağı kaybettiğinde HEMEN null'a düşüyor.
  /// Sorun şu ki AppBar'daki Geri Al/İleri Al IKON BUTONUNA dokunmak
  /// zaten KENDİSİ (dokunma anında) odaklı hücrenin klavye odağını
  /// kaybetmesine yol açıyor — yani [applySnapshot]/[didUpdateWidget]
  /// çalıştığında [_activeCell] ÇOKTAN null olmuş oluyor, dolayısıyla
  /// "Geri Al'dan önce neredeydim" bilgisi kaybolmuş oluyordu. Bu alan
  /// AYNI bilgiyi tutar ama SADECE bir hücre odağı KAZANDIĞINDA güncellenir,
  /// odağı KAYBETTİĞİNDE asla sıfırlanmaz — bu sayede "kullanıcının en son
  /// gerçekten üzerinde işlem yaptığı hücre" bilgisi, ara odak kayıplarına
  /// (menü açma, Geri Al butonuna dokunma vb.) rağmen hayatta kalır.
  (int, int)? _lastKnownActiveCell;

  /// DÜZELTME (satır/sütun ekleyince "değişen hücre bir yerde, imleç
  /// başka yerde" hatası): [_sameCellIdentities] en başta a.length !=
  /// b.length kontrolü yapıyor — ama satır/sütun EKLEME-SİLME de
  /// uzunluğu değiştiriyor. Yani _insertRowAfter/_deleteRow/
  /// _insertColumnAfter/_deleteColumn kendi widget.onChanged'i
  /// üzerinden parent'ı rebuild edip AYNI widget'a yeni (satır/sütun
  /// sayısı değişmiş) bir widget.rows geri gönderdiğinde,
  /// didUpdateWidget bunu YANLIŞLIKLA "dışarıdan (undo/redo) geldi"
  /// sanıyor: _rows'u sıfırdan kurup controller'ları İKİNCİ KEZ dispose
  /// edip yeniden kuruyor, ÜSTELİK bayat [_lastKnownActiveCell]'e göre
  /// KENDİ odak kararını veriyor — bu da mutasyon metodunun zaten
  /// planladığı [_focusCellAfterMutation] çağrısıyla YARIŞA giriyor;
  /// frame sıralamasına göre kazanan değişiyor. Bu bayrak, dört
  /// mutasyon metodundan biri _notifyChanged() çağırmadan HEMEN önce
  /// true yapılır; didUpdateWidget başında true bulunursa TÜM
  /// dış-değişiklik senkronizasyonu (ve onunla gelen ikinci odak kararı)
  /// tamamen atlanır — çünkü _rows/_controllers zaten mutasyon metodu
  /// tarafından doğru şekilde güncellenmiş, odak da zaten doğru hücreye
  /// planlanmıştır.
  bool _suppressNextExternalSync = false;

  /// [onSubmitted] içinde bir sonraki odak hedefinin AYNI satırda olduğu
  /// (yatay geçiş) önceden bilindiğinde true yapılır; bu durumda hedef
  /// hücrenin FocusNode dinleyicisi gereksiz bir Scrollable.ensureVisible
  /// çağrısını atlar. _activeCell'e bakarak "aynı satır mı" sonucunu
  /// çıkarmak GÜVENİLMEZDİ: Flutter genelde eski hücrenin odağı kaybetme
  /// olayını yeni hücrenin odağı kazanma olayından ÖNCE tetikliyor, bu da
  /// yeni hücrenin dinleyicisi çalıştığında _activeCell'in çoktan null'a
  /// çekilmiş olmasına ve "farklı satır" sanılıp gereksiz yere yine
  /// kaydırma yapılmasına yol açıyordu. Bunun yerine hedefin aynı satırda
  /// olup olmadığını [onSubmitted] içinde KESİN olarak biliyoruz; bunu
  /// burada bir bayrakla taşıyoruz.
  bool _suppressNextAutoScroll = false;

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

  /// Klavye-üstü zengin metin araç çubuğunun (kalın/italik/vb.) sabit
  /// yüksekliği (bkz. note_list_note_dialog_mixin.dart ->
  /// `SizedBox(height: 44)`). Bu bar klavyenin KENDİSİ değildir, ayrı bir
  /// widget olarak klavyenin üstüne oturur — dolayısıyla
  /// MediaQuery.viewInsets.bottom bu barın yüksekliğini HİÇ bilmez.
  /// [_scrollFocusedCellIntoView] bu payı manuel olarak eklemezse, hücre
  /// tam klavyenin üstüne (araç çubuğunun ARKASINA/ALTINA) hizalanır ve
  /// görünürde yazma konumundan "biraz aşağıda" kalır.
  static const double _keyboardToolbarHeight = 44;

  /// Odaklanan hücreyi klavyenin (VE üstündeki araç çubuğunun) üstünde
  /// görünür tutar. Sabit bir gecikme yerine, MediaQuery.viewInsets.bottom
  /// değeri art arda İKİ karede AYNI kalana kadar (yani klavye animasyonu
  /// gerçekten bitene kadar) her kareyi kontrol eder; ancak o zaman
  /// kaydırma hedefi hesaplanır. Böylece animasyon süresi cihazdan cihaza
  /// değişse bile doğru anda kaydırma yapılır — ne erken (hücre henüz
  /// "görünür" sanılıp atlanmaz) ne geç (zaten görünürken gereksiz
  /// kaydırma yapılmaz).
  ///
  /// DÜZELTME (imleç hücreye gelince TEK hareketle yazma konumuna
  /// gelsin): eskiden burada Scrollable.ensureVisible(alignment: 1.0)
  /// kullanılıyordu — bu, hücreyi klavyenin (yalnızca) üstüne, araç
  /// çubuğu payı OLMADAN hizalıyordu; sonuç, hücrenin araç çubuğunun
  /// arkasında/altında kalması ve kullanıcının bunu ancak yazmaya
  /// başladığında (rastgele bir sonraki rebuild'de) fark etmesiydi —
  /// "iki ayrı hareket" hissi buradan geliyordu. Artık hedef offset
  /// RenderAbstractViewport.getOffsetToReveal ile TEK SEFERDE manuel
  /// hesaplanıyor ve üzerine [_keyboardToolbarHeight] payı ekleniyor;
  /// tek bir animateTo çağrısıyla doğrudan nihai (araç çubuğunun da
  /// üstünde kalan) konuma gidiliyor.
  void _scrollFocusedCellIntoView(
    FocusNode node, {
    double? lastBottomInset,
    int attemptsLeft = 30,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !node.hasFocus) return;
      final currentBottomInset = MediaQuery.of(context).viewInsets.bottom;
      final stabilized = lastBottomInset != null &&
          (currentBottomInset - lastBottomInset).abs() < 0.5;
      if (stabilized || attemptsLeft <= 0) {
        final cellContext = node.context;
        final renderObject = cellContext?.findRenderObject();
        if (cellContext != null && renderObject != null) {
          final scrollable = Scrollable.maybeOf(cellContext);
          final viewport = RenderAbstractViewport.maybeOf(renderObject);
          if (scrollable != null && viewport != null) {
            final position = scrollable.position;
            // alignment: 1.0 ile aynı hesap (hücreyi viewport'un tam
            // altına hizalayan offset), + araç çubuğu payı.
            final revealOffset =
                viewport.getOffsetToReveal(renderObject, 1.0).offset;
            final targetOffset =
                (revealOffset + _keyboardToolbarHeight).clamp(
              position.minScrollExtent,
              position.maxScrollExtent,
            );
            position.animateTo(
              targetOffset,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          } else {
            // Beklenmedik yapı (Scrollable/viewport bulunamadı) —
            // eski davranışa geri düş, en azından hücre klavyenin
            // üstünde kalsın.
            Scrollable.ensureVisible(
              cellContext,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              alignment: 1.0,
            );
          }
        }
        return;
      }
      _scrollFocusedCellIntoView(
        node,
        lastBottomInset: currentBottomInset,
        attemptsLeft: attemptsLeft - 1,
      );
    });
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
            // DÜZELTME (Aşama 2 — üç nokta ikonu): _activeCell artık
            // sadece dahili bir bayrak değil, build() içinde "bu hücrede
            // üç nokta ikonu görünsün mü?" kararını da veriyor. Bu yüzden
            // atama setState içine alınıyor ki hücre odağı
            // kazandığında/kaybettiğinde ikon görünürlüğü yeniden
            // çizilsin. Geri kalan yan etkiler (onActiveCellChanged,
            // otomatik kaydırma) rebuild'e ihtiyaç duymadığından setState
            // dışında bırakıldı.
            setState(() => _activeCell = (r, c));
            _lastKnownActiveCell = (r, c);
            widget.onActiveCellChanged(_controllers[r][c], _rows[r][c]);
            // DÜZELTME (Enter ile alt satıra geçince klavyenin arkasında
            // kalma): Sabit bir gecikme (ör. 300ms) İŞE YARAMADI çünkü
            // klavye açılma animasyonu kare kare (MediaQuery.viewInsets.
            // bottom kademeli artarak) ilerliyor ve süresi cihaza/duruma
            // göre değişebiliyor — sabit süre bazen animasyon bitmeden
            // (kaydırma hesaplanıp hücre "zaten görünür" sanılıyor, sonra
            // klavye üzerine biniyor), bazen gereksiz yere sonra çalışıp
            // zaten görünür hücreyi kaydırıyordu. Çözüm: sabit süre
            // beklemek yerine viewInsets.bottom'un kare kare STABİLİZE
            // OLMASINI (art arda iki karede aynı kalmasını) bekliyoruz —
            // bkz. _scrollFocusedCellIntoView.
            //
            // DÜZELTME 2 (Enter ile sağdaki hücreye geçince ekranın
            // "aşağı kayıp sonra yukarı zıplaması"): Scrollable.ensureVisible
            // varsayılan olarak "explicit" hizalama politikasıyla çalışır —
            // yani hücre zaten tam görünür olsa BİLE her çağrıldığında
            // viewport'u alignment: 1.0'a göre YENİDEN hizalar. Aynı
            // satırda yan hücreye geçerken dikey konum HİÇ değişmediği
            // için bu zorlamalı yeniden hizalama gereksizdi ve her Enter'da
            // küçük bir aşağı kaymaya (ardından yazarken düzelmeye) yol
            // açıyordu. [onSubmitted] hedefin aynı satırda olduğunu zaten
            // bildiğinde [_suppressNextAutoScroll]'u true yapar; burada da
            // bu durumda kaydırmayı tamamen atlıyoruz.
            if (_suppressNextAutoScroll) {
              _suppressNextAutoScroll = false;
            } else {
              _scrollFocusedCellIntoView(node);
            }
          } else if (_activeCell == (r, c)) {
            // Yalnızca kaybeden hücre HALEN "aktif" sayılan hücreyse
            // sıfırla — aksi halde, odak aynı tablo içinde bir hücreden
            // diğerine geçerken (kayıp olayı kazanç olayından SONRA
            // gelirse) az önce doğru şekilde ayarlanmış yeni aktif hücreyi
            // yanlışlıkla null'a çekebilirdi.
            setState(() => _activeCell = null);
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

  /// AŞAMA 4 (uç durum düzeltmesi): [a] ve [b] AYNI satır sayısına ve HER
  /// satırda aynı sütun sayısına sahip mi? _findChangedCell'in
  /// "aynı pozisyondaki (r, c) hücrenin metni değişti mi" karşılaştırması,
  /// yalnızca tablo BOYUTU (satır/sütun sayısı) değişmediğinde anlamlıdır
  /// — yani gerçek "metin-only" undo/redo senaryosunda. Satır/sütun
  /// EKLEME-SİLME sonrası (bu widget'ın kendi _insertRowAfter/_deleteRow/
  /// _insertColumnAfter/_deleteColumn'u tetiklediği didUpdateWidget
  /// döngüsünde) tüm sonraki hücreler indekste KAYDIĞI için pozisyon
  /// bazlı karşılaştırma, hiç düzenlenmemiş hücreleri "değişmiş" sanıp
  /// odağı YANLIŞ bir hücreye taşıyabilir — bu da satır/sütun
  /// mutasyonlarının kendi (Aşama 4 _focusCellAfterMutation) odak
  /// talebiyle çakışıp onu ezebilirdi. Bu yüzden şekil değiştiğinde
  /// _findChangedCell HİÇ çağrılmaz; odak tamamen mutasyonu tetikleyen
  /// tarafın (satır/sütun menüsü ya da başka bir çağıran) sorumluluğuna
  /// bırakılır.
  bool _sameShape(
    List<List<Map<String, dynamic>>> a,
    List<List<Map<String, dynamic>>> b,
  ) {
    if (a.length != b.length) return false;
    for (int r = 0; r < a.length; r++) {
      if (a[r].length != b[r].length) return false;
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
    // DÜZELTME (yeni sorun: "satır ekleyip Geri Al'a basınca imleç tablo
    // dışına çıkıyor"): satır/sütun EKLEME-SİLME sonrası uygulamanın kendi
    // Geri Al/İleri Al (undo/redo) özelliği tüm notun eski bir anlık
    // görüntüsünü geri yükleyince, bu tabloya AYNI ŞEKİLDE farklı satır/
    // sütun sayısına sahip YENİ bir widget.rows geliyor. Az aşağıdaki
    // _sameShape kontrolü bu durumda true DEĞİL olduğundan (bkz. o
    // kontrolün dokümantasyonu) _findChangedCell hiç çağrılmıyordu ve
    // odak tamamen dokunulmadan bırakılıyordu — sonuç: hiçbir hücre
    // yeniden odaklanmadığı için imleç görünürde tablo dışına
    // "kayboluyordu". Çözüm: [_activeCell] DEĞİL, [_lastKnownActiveCell]
    // kullanıyoruz — çünkü AppBar'daki Geri Al ikonuna dokunmanın
    // KENDİSİ zaten hücrenin odağını kaybettirip [_activeCell]'i null'a
    // düşürüyor, bu yüzden _activeCell bu noktada güvenilmezdi.
    // [_lastKnownActiveCell] odak kaybında sıfırlanmadığından "Geri
    // Al'dan hemen önce gerçekten üzerinde işlem yapılan hücre" bilgisini
    // hâlâ taşır; şekil değiştiği için TAM olarak aynı hücreye dönmek
    // anlamsız olsa da (o hücre artık olmayabilir), konumunu YENİ
    // sınırlara kırpıp en yakın makul hücreye odağı geri veriyoruz.
    //
    // DÜZELTME: bu tur, _insertRowAfter/_deleteRow/_insertColumnAfter/
    // _deleteColumn'un KENDİ tetiklediği bir echo ise (bkz.
    // [_suppressNextExternalSync] dokümantasyonu), _rows/_controllers
    // ZATEN doğru ve odak ZATEN [_focusCellAfterMutation] tarafından
    // doğru hücreye planlanmış demektir — aşağıdaki tüm senkronizasyon
    // ve İKİNCİ odak kararı burada tamamen atlanır.
    if (_suppressNextExternalSync) {
      _suppressNextExternalSync = false;
      return;
    }
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
      //
      // AŞAMA 4 DÜZELTMESİ: bu pozisyon bazlı karşılaştırma yalnızca
      // ŞEKİL (satır/sütun sayısı) AYNIYSA güvenlidir (bkz. _sameShape
      // dokümantasyonu). Şekil farklıysa (satır/sütun ekleme-silme sonrası
      // didUpdateWidget'ın kendisi tetiklendiğinde) hiç çağrılmaz — odak,
      // mutasyonu başlatan tarafın kendi mantığına (_focusCellAfterMutation)
      // bırakılır — YA DA (yeni) bu undo/redo ile geldiyse, aşağıdaki
      // "şekil değişti" dalına düşer.
      final sameShape = _sameShape(oldWidget.rows, _rows);
      final changedCell = sameShape ? _findChangedCell(oldWidget.rows, _rows) : null;
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
          // DÜZELTME (normal yazı yazarken Geri Al'a basınca ekran "bir
          // aşağı bir yukarı kayıyordu"): [_scrollFocusedCellIntoView]
          // Scrollable.ensureVisible'ı alignment: 1.0 (viewport'un ALT
          // KENARINA hizala) ile çağırıyor — bu, hücre zaten tam
          // görünürken BİLE onu zorla yeniden hizalar (bkz. dosyanın
          // başındaki "DÜZELTME 2" notu, Enter ile yan hücreye geçerken
          // aynı sorun). Undo sırasında kullanıcı zaten az önce o
          // hücrede yazı yazıyordu — hücre neredeyse her zaman ZATEN
          // görünür durumda, dolayısıyla bu zorlamalı hizalama gereksiz
          // bir sıçramaya yol açıyordu. Enter/yatay-geçiş yolunda
          // kullanılan AYNI bastırma bayrağını burada da kullanıyoruz.
          _suppressNextAutoScroll = true;
          _focusNodes[row][col].requestFocus();
          // FocusNode listener zaten widget.onActiveCellChanged'i doğru
          // argümanlarla çağıracak (bkz. _rebuildControllers), burada
          // ayrıca çağırmaya gerek yok.
        });
      } else if (!sameShape &&
          _lastKnownActiveCell != null &&
          _rows.isNotEmpty) {
        // YENİ DÜZELTME: satır/sütun ekleme-silme bir undo/redo ile geri
        // alındı/yinelendi (şekil değişti, bu yüzden hücre-hücre metin
        // karşılaştırması anlamlı değil). Geri Al'dan HEMEN önce
        // GERÇEKTEN odaklı olan (satır, sütun) konumunu ([_lastKnownActiveCell])
        // YENİ tablo sınırlarına kırpıp o hücreye odağı geri veriyoruz —
        // böylece imleç tamamen tablo dışına düşmüyor, en azından "son
        // bulunduğu yere yakın" bir hücrede kalıyor.
        final (prevRow, prevCol) = _lastKnownActiveCell!;
        final targetRow =
            prevRow < 0 ? 0 : (prevRow >= _rows.length ? _rows.length - 1 : prevRow);
        final rowLen = _rows[targetRow].length;
        final targetCol =
            prevCol < 0 ? 0 : (prevCol >= rowLen ? rowLen - 1 : prevCol);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final controller = _controllers[targetRow][targetCol];
          controller.selection = TextSelection.collapsed(
            offset: controller.text.length,
          );
          // Aynı gerekçeyle (bkz. yukarıdaki changedCell dalındaki
          // açıklama) burada da zorlamalı yeniden hizalamayı bastırıyoruz.
          _suppressNextAutoScroll = true;
          _focusNodes[targetRow][targetCol].requestFocus();
        });
      }
      // changedCell == null && sameShape: bu undo/redo bu tabloyu hiç
      // etkilemedi (değişiklik başka bir blokta olduysa) — odağa
      // DOKUNULMUYOR, imleç mutasyonu tetikleyen tarafın bıraktığı yerde
      // kalır.
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

  // ──────────────────────────────────────────────────────────────────────
  // AŞAMA 1: Satır/sütun ekleme-silme — saf veri mutasyonları.
  // Bu dört metod yalnızca _rows'u değiştirir; hiçbir UI/menü mantığı
  // içermez (bkz. Aşama 2/3). Her biri sonunda:
  //   1) _rebuildControllers() — yeni satır/sütun sayısına göre
  //      controller/FocusNode ızgarasını YENİDEN kurar (eskiler dispose
  //      edilip yenileri oluşturulur, tıpkı didUpdateWidget'taki
  //      undo/redo akışında olduğu gibi).
  //   2) _notifyChanged() — güncel _rows'u dışarıya bildirir
  //      (çağıran taraf block['rows'] = ... yapar).
  // çağırır. Aktif hücre (_activeCell) ekleme/silme sonrası artık geçersiz
  // olabileceğinden (ör. silinen satır/sütun aktif hücreyi içeriyorsa,
  // ya da controller'lar zaten yeniden kurulduğundan) temizlenir; Aşama 4
  // bu noktada gerekirse yeni bir hücreye odağı açıkça geri verecek.
  // ──────────────────────────────────────────────────────────────────────

  /// Yeni boş bir hücre — 'text' bloğu ve [NoteTableBlock.newRows] ile
  /// aynı desende: {"text": "", "spans": []}.
  Map<String, dynamic> _newEmptyCell() => <String, dynamic>{
        'text': '',
        'spans': <Map<String, dynamic>>[],
      };

  /// [afterRow] indeksli satırın ALTINA, mevcut sütun sayısı kadar boş
  /// hücreden oluşan yeni bir satır ekler. Tablo boşsa (satır yoksa)
  /// hiçbir şey yapmaz (bu durumda zaten UI'dan çağrılmamalı).
  void _insertRowAfter(int afterRow) {
    if (_rows.isEmpty) return;
    final colCount = _rows[0].length;
    final newRow = List.generate(colCount, (_) => _newEmptyCell());
    setState(() {
      _rows.insert(afterRow + 1, newRow);
      _activeCell = null;
    });
    widget.onActiveCellChanged(null, null);
    _disposeControllers();
    _rebuildControllers();
    _suppressNextExternalSync = true;
    _notifyChanged();
  }

  /// [row] indeksindeki satırı tamamen kaldırır. Tabloyu 0 satıra
  /// düşürmemek için tek satır kaldıysa (_rows.length <= 1) hiçbir şey
  /// yapmaz — çağıran taraf (Aşama 3'teki menü) bu durumda "Satır Sil"
  /// seçeneğini zaten pasif göstermeli, bu kontrol burada bir güvenlik
  /// ağı olarak tekrarlanır.
  void _deleteRow(int row) {
    if (_rows.length <= 1) return;
    if (row < 0 || row >= _rows.length) return;
    setState(() {
      _rows.removeAt(row);
      _activeCell = null;
    });
    widget.onActiveCellChanged(null, null);
    _disposeControllers();
    _rebuildControllers();
    _suppressNextExternalSync = true;
    _notifyChanged();
  }

  /// [afterCol] indeksli sütunun SAĞINA, HER satıra bir boş hücre ekleyerek
  /// yeni bir sütun ekler. Üst sınır (mevcut ızgara seçicideki _maxCols=4
  /// ile tutarlı) burada DENETLENMEZ — Aşama 3'teki menü zaten sütun
  /// sayısı 4'e ulaştığında "Sütun Ekle"yi pasif gösterecek; bu metod saf
  /// bir veri mutasyonu olarak sınırsız kalır.
  void _insertColumnAfter(int afterCol) {
    if (_rows.isEmpty) return;
    setState(() {
      for (final row in _rows) {
        row.insert(afterCol + 1, _newEmptyCell());
      }
      _activeCell = null;
    });
    widget.onActiveCellChanged(null, null);
    _disposeControllers();
    _rebuildControllers();
    _suppressNextExternalSync = true;
    _notifyChanged();
  }

  /// [col] indeksindeki sütunu HER satırdan kaldırır. Tabloyu 0 sütuna
  /// düşürmemek için tek sütun kaldıysa (_rows[0].length <= 1) hiçbir şey
  /// yapmaz.
  void _deleteColumn(int col) {
    if (_rows.isEmpty || _rows[0].length <= 1) return;
    if (col < 0 || col >= _rows[0].length) return;
    setState(() {
      for (final row in _rows) {
        row.removeAt(col);
      }
      _activeCell = null;
    });
    widget.onActiveCellChanged(null, null);
    _disposeControllers();
    _rebuildControllers();
    _suppressNextExternalSync = true;
    _notifyChanged();
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

  // ──────────────────────────────────────────────────────────────────────
  // AŞAMA 3: satır/sütun ekle-sil popup menüsü — etkin/pasif kuralları.
  // Bu metodlar SAF birer sorgu; hiçbir veriyi değiştirmezler (mutasyon
  // Aşama 1'deki _insertRowAfter/_deleteRow/_insertColumnAfter/
  // _deleteColumn'da, bağlama ise Aşama 4'te yapılıyor).
  // ──────────────────────────────────────────────────────────────────────

  /// "Satır Sil" seçeneği yalnızca birden fazla satır varken etkindir —
  /// tabloyu 0 satıra düşürmemek için.
  bool get _canDeleteRow => _rows.length > 1;

  /// "Sütun Sil" seçeneği yalnızca birden fazla sütun varken etkindir.
  bool get _canDeleteColumn => _rows.isNotEmpty && _rows[0].length > 1;

  /// "Sütun Ekle" seçeneği, tablo oluşturma ızgarasındaki üst sınırla
  /// (_NoteTableSizePickerDialogState._maxCols = 4) tutarlı olacak şekilde,
  /// sütun sayısı bu sınıra ulaştığında pasif olur. Aynı dosyadaki tek
  /// gerçek kaynaktan ("single source of truth") okunuyor, sınır burada
  /// TEKRAR tanımlanmıyor.
  bool get _canInsertColumn =>
      _rows.isEmpty ||
      _rows[0].length < _NoteTableSizePickerDialogState._maxCols;

  /// "Satır Ekle" için üst sınır yok — her zaman etkin (mevcut ızgara
  /// seçicideki 8 satır yalnızca ilk oluşturmadaki öneriydi, burada
  /// geçerli değil).
  bool get _canInsertRow => true;

  /// Menüdeki metinler artık .arb dosyalarındaki tableMenuInsertRowAfter /
  /// tableMenuDeleteRow / tableMenuInsertColumnAfter / tableMenuDeleteColumn
  /// anahtarlarından geliyor (önceden burada sabit Türkçe metinler
  /// kullanılıyordu — popup diğer dillerde de Türkçe görünüyordu).
  String _menuActionLabel(_TableRowColMenuAction action) {
    final l10n = AppLocalizations.of(context)!;
    switch (action) {
      case _TableRowColMenuAction.insertRowAfter:
        return l10n.tableMenuInsertRowAfter;
      case _TableRowColMenuAction.deleteRow:
        return l10n.tableMenuDeleteRow;
      case _TableRowColMenuAction.insertColumnAfter:
        return l10n.tableMenuInsertColumnAfter;
      case _TableRowColMenuAction.deleteColumn:
        return l10n.tableMenuDeleteColumn;
    }
  }

  /// Satırın (r) veya sütunun (c) — hangi hücreden açıldığına bağlı —
  /// 4 seçenekli menü ızgarasının içeriği artık [_openRowColMenu] içinde
  /// doğrudan kuruluyor (showGeneralDialog + Align geçişiyle birlikte);
  /// bu yardımcı, showMenu()'ye özgü PopupMenuEntry listesi üretiyordu ve
  /// artık gerekmiyor.

  /// AŞAMA 4 (odak yönetimi): satır/sütun ekleme-silme sonrası
  /// [_rebuildControllers] TÜM hücreler için YENİ FocusNode/controller
  /// nesneleri kurduğundan (eskiler _disposeControllers ile atılır), eski
  /// odağı "taşımak" mümkün değildir — imleci [row]/[col] konumundaki
  /// TAZE hücreye açıkça geri vermemiz gerekir. Bunu, mevcut initState/
  /// didUpdateWidget'taki desenle AYNI şekilde bir sonraki frame'e
  /// erteliyoruz (build sırasında senkron odak talebi "setState called
  /// during build" hatasına yol açabilir). [row]/[col], çağıran tarafça
  /// mutasyon SONRASI geçerli _rows sınırlarına göre ÖNCEDEN kırpılmış
  /// (clamp edilmiş) olmalıdır; burada yalnızca ekstra bir güvenlik
  /// kontrolü olarak sınır dışıysa sessizce hiçbir şey yapılmaz.
  void _focusCellAfterMutation(int row, int col) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (row < 0 || row >= _focusNodes.length) return;
      if (col < 0 || col >= _focusNodes[row].length) return;
      // İmleci metnin sonuna koy — undo/redo odak mantığındaki (bkz.
      // didUpdateWidget) aynı gerekçeyle: yeni eklenen hücre zaten boş
      // olduğundan bu pratikte offset 0 ile aynı sonucu verir, ama
      // silme sonrası komşu hücreye düşüldüğünde (o hücrenin metni dolu
      // olabilir) imlecin metnin ORTASINDA geçersiz bir konumda
      // kalmamasını garanti eder.
      final controller = _controllers[row][col];
      controller.selection = TextSelection.collapsed(
        offset: controller.text.length,
      );
      _focusNodes[row][col].requestFocus();
      // FocusNode listener zaten widget.onActiveCellChanged'i ve
      // _activeCell güncellemesini (dolayısıyla üç nokta ikonunun yeni
      // hücrede belirmesini) kendiliğinden tetikleyecek — burada ayrıca
      // çağırmaya gerek yok.
    });
  }

  /// Menüden bir seçenek seçildiğinde çağrılır. [r]/[c], menünün hangi
  /// hücreden açıldığını belirtir (üç nokta ikonu yalnızca aktif
  /// hücrede göründüğünden, bu her zaman "menü açılırken odaklı olan
  /// hücre" ile aynıdır). Aşama 1'deki saf veri mutasyonlarını çağırır
  /// ve ardından mutasyon sonrası MANTIKLI bir hücreye odağı taşır:
  ///   - Satır Ekle  → yeni satır (r+1) içinde AYNI sütun (c).
  ///   - Sütun Ekle  → yeni sütun (c+1) içinde AYNI satır (r).
  ///   - Satır Sil   → silinen satırın YERİNE gelen satır (ya da tablo
  ///     kısaldıysa artık son satır olan satır), AYNI sütun (sütun
  ///     sayısı da azaldıysa kırpılmış).
  ///   - Sütun Sil   → silinen sütunun YERİNE gelen sütun (ya da artık
  ///     son sütun), AYNI satır.
  /// "Sil" aksiyonları için _canDeleteRow/_canDeleteColumn burada TEKRAR
  /// kontrol edilir — menüde zaten pasif gösterilseler de (bkz. Aşama 3),
  /// bu ikinci kontrol tabloyu yanlışlıkla 0 satır/sütuna düşürecek bir
  /// çağrıya karşı bir güvenlik ağıdır (ör. menü açıkken tablo başka bir
  /// yoldan -undo/redo- değişmiş olabilir).
  void _onRowColMenuSelected(_TableRowColMenuAction action, int r, int c) {
    switch (action) {
      case _TableRowColMenuAction.insertRowAfter:
        _insertRowAfter(r);
        _focusCellAfterMutation(r + 1, c);
        break;

      case _TableRowColMenuAction.deleteRow:
        if (!_canDeleteRow) return;
        _deleteRow(r);
        if (_rows.isEmpty) return; // Teorik güvenlik ağı; pratikte oluşmaz.
        final targetRow = r < _rows.length ? r : _rows.length - 1;
        final targetCol =
            c < _rows[targetRow].length ? c : _rows[targetRow].length - 1;
        _focusCellAfterMutation(targetRow, targetCol);
        break;

      case _TableRowColMenuAction.insertColumnAfter:
        _insertColumnAfter(c);
        _focusCellAfterMutation(r, c + 1);
        break;

      case _TableRowColMenuAction.deleteColumn:
        if (!_canDeleteColumn) return;
        _deleteColumn(c);
        if (_rows.isEmpty || _rows[0].isEmpty) return; // Güvenlik ağı.
        final targetCol = c < _rows[0].length ? c : _rows[0].length - 1;
        _focusCellAfterMutation(r, targetCol);
        break;
    }
  }

  /// DÜZELTME (üç nokta menüsü sessizce hiç açılmıyordu — kök neden
  /// analizi için bkz. proje notları): PopupMenuButton kendi (dahili)
  /// State'ine sahiptir ve menü kapanırken onSelected'ı çağırmadan ÖNCE
  /// KENDİ mounted durumunu kontrol eder. Bu ikon [_activeCell] koşuluna
  /// bağlı olarak ağaçta durduğundan, menü açılır açılmaz arkadaki
  /// TextField odağı kaybediyor (overlay öne çıkınca) → FocusNode
  /// listener'ımız _activeCell = null yapıyor → bu widget rebuild oluyor
  /// → PopupMenuButton ağaçtan kaldırılıp DISPOSE ediliyor →
  /// PopupMenuButton'ın kendi mounted kontrolü false dönüyor → onSelected
  /// SESSİZCE hiç çağrılmıyor (hata da fırlamıyor, çünkü bu kontrol
  /// PopupMenuButton'ın kendi kodunda `if (!mounted) return;` şeklinde
  /// bilerek yutuluyor).
  ///
  /// ÇÖZÜM: PopupMenuButton'a hiç güvenmiyoruz. Menüyü [showMenu] ile
  /// ELLE açıyoruz; bunun sonucunu işleyen kod _NoteTableBlockState'in
  /// (yani BU widget'ın) kendi mounted durumuna bağlı — o da yalnızca
  /// hücrenin (satırın/sütunun) kendisi tablo dışına gerçekten
  /// kaldırıldığında false olur, ikon geçici olarak gizlendiğinde DEĞİL.
  /// Konum bilgisi de ikonun kendi context'i üzerinden DEĞİL, dokunma
  /// olayının globalPosition'ından alınıyor — böylece ikonun alttaki
  /// GestureDetector'ı disposed olsa bile showMenu çağrısının kendisi
  /// zaten yapılmış ve bağımsız bir Future döndürmüş oluyor.
  void _openRowColMenu(Offset globalPosition, int r, int c) {
    final overlayBox =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    // DÜZELTME (popup HİÇBİR ZAMAN gerçekten ortalanmıyordu): showMenu()'nün
    // 'position' (RelativeRect) parametresi, Flutter'ın kendi
    // _PopupMenuRouteLayout.getPositionForChild mantığı gereği menünün bir
    // KENARINI verilen noktaya hizalayıp DİĞER yöne doğru büyütür — asla bir
    // noktanın ortasına yerleştirmez. x koordinatını ekran genişliğinin
    // yarısına ayarlamak bile bu yüzden işe yaramıyordu: menünün SAĞ kenarı
    // o noktaya hizalanıp SOLA doğru büyüyordu, yani popup her zaman ekranın
    // sol yarısında kalmaya devam ediyordu. showMenu() API'siyle gerçek bir
    // "ortalama" yapmak mümkün değil.
    //
    // ÇÖZÜM: showMenu()'yü tamamen bırakıp kendi overlay'imizi kuruyoruz —
    // showGeneralDialog + Align(alignment: Alignment(0, ...)). Align, çocuğun
    // genişliği ne olursa olsun onu GERÇEKTEN yatayda ortalar (x=0 yatay
    // ortayı ifade eder); dikey konum ise dokunulan noktaya yakın kalması
    // için ekran yüksekliğine oranlanıp -1..1 aralığına eşleniyor.
    // Menünün rengi/gölgesi/köşe yuvarlaklığı, showMenu()'nün otomatik
    // uyguladığı görünümle aynı kalsın diye PopupMenuThemeData'dan elle
    // okunuyor.
    final screenHeight = overlayBox.size.height;
    final verticalAlignment =
        ((globalPosition.dy / screenHeight) * 2 - 1).clamp(-1.0, 1.0);
    final popupMenuTheme = PopupMenuTheme.of(context);

    showGeneralDialog<_TableRowColMenuAction>(
      context: context,
      barrierLabel: 'tableRowColMenu',
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 120),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return SafeArea(
          child: Align(
            alignment: Alignment(0, verticalAlignment),
            child: Material(
              color: popupMenuTheme.color ??
                  Theme.of(context).colorScheme.surface,
              elevation: popupMenuTheme.elevation ?? 8,
              shadowColor: popupMenuTheme.shadowColor,
              surfaceTintColor: popupMenuTheme.surfaceTintColor,
              shape: popupMenuTheme.shape ??
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
              clipBehavior: Clip.antiAlias,
              child: IntrinsicWidth(
                child: _RowColMenuGrid(
                  insertRowLabel:
                      _menuActionLabel(_TableRowColMenuAction.insertRowAfter),
                  deleteRowLabel:
                      _menuActionLabel(_TableRowColMenuAction.deleteRow),
                  insertColumnLabel: _menuActionLabel(
                      _TableRowColMenuAction.insertColumnAfter),
                  deleteColumnLabel:
                      _menuActionLabel(_TableRowColMenuAction.deleteColumn),
                  canInsertRow: _canInsertRow,
                  canDeleteRow: _canDeleteRow,
                  canInsertColumn: _canInsertColumn,
                  canDeleteColumn: _canDeleteColumn,
                ),
              ),
            ),
          ),
        );
      },
    ).then((action) {
      // KRİTİK: burada _NoteTableBlockState.mounted kontrol ediliyor —
      // ikonu barındıran alt ağacın değil. Menü açılırken _activeCell
      // zaten null'a düşmüş (ve ikon ağaçtan kaldırılmış) olabilir, ama
      // bu State hücre var olduğu sürece ayakta kalmaya devam eder.
      if (!mounted) return;
      if (action != null) _onRowColMenuSelected(action, r, c);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colCount = _rows.isEmpty ? 0 : _rows[0].length;
    // DÜZELTME (ayraç bloğuyla tutarlılık): tablo çizgileri eskiden
    // doğrudan dNoteBorderColor(context) kullanıyordu — bu paylaşılan
    // tema rengi ayraç (divider) bloğu için de silik bulunmuş ve orada
    // koyu temada beyaza, açık temada siyaha %25 yaklaştırılan bir
    // düzeltme uygulanmıştı (bkz. note_list_note_dialog_mixin.dart ->
    // block['type'] == 'divider'). Aynı belirginliği tablo çizgilerine de
    // vermek için BURADA da aynı karışım uygulanıyor — YALNIZCA
    // widget.borderColor dışarıdan verilmediğinde (override edilmediğinde)
    // devreye girer; dışarıdan açıkça bir renk verilmişse ona dokunulmaz.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBorderColor = widget.borderColor ??
        Color.lerp(
          dNoteBorderColor(context),
          isDark ? Colors.white : Colors.black,
          0.1,
        )!;
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
                      // AŞAMA 2 (üç nokta ikonu): hücre artık tek başına
                      // bir Container değil, bir Stack — asıl hücre
                      // (Container+TextField, non-positioned çocuk olarak
                      // Stack'in boyutunu belirler) ve üzerine bindirilen,
                      // yalnızca bu hücre aktifken (_activeCell == (r, c))
                      // görünen Icons.more_vert ikonu. Silme ikonundaki
                      // Positioned deseniyle tutarlı olarak clipBehavior:
                      // Clip.none kullanılıyor ki ikon hücre sağ kenarının
                      // hafif dışına taşabilsin. Menü bağlantısı (onPressed)
                      // Aşama 3'te eklenecek — şimdilik boş.
                      Stack(
                        clipBehavior: Clip.none,
                        // DÜZELTME (bir hücredeki yazı aşağı doğru
                        // büyüyünce DİĞER hücrelerin dikey çizgileri
                        // aşağı uzamıyordu): Stack'in varsayılan
                        // davranışı (StackFit.loose) üst Row'dan gelen
                        // TIGHT yükseklik kısıtını (crossAxisAlignment.
                        // stretch + IntrinsicHeight ile satırın en uzun
                        // hücresine göre belirlenen yükseklik) kendi
                        // non-positioned çocuğuna (bordürlü Container)
                        // GEÇİRMİYORDU — Stack'in KENDİSİ doğru
                        // yükseklikte oluyordu ama içindeki Container
                        // sadece TextField'ının doğal (kısa) yüksekliği
                        // kadar çiziliyordu, bu da kısa hücrelerin sol/
                        // sağ çizgilerinin satırın altına kadar
                        // uzamamasına yol açıyordu. StackFit.passthrough,
                        // gelen kısıtı non-positioned çocuğa OLDUĞU GİBİ
                        // iletir (Positioned olan ⋮ ikonunu etkilemez),
                        // böylece Container satırın tam yüksekliğini
                        // doldurur.
                        fit: StackFit.passthrough,
                        children: [
                      Container(
                        width: cellWidth,
                        decoration: BoxDecoration(
                          // DÜZELTME (iç/dış çizgi kalınlığı eşitsizliği):
                          // Border.all() her hücreye TÜM kenarlarında sınır
                          // çiziyordu; komşu iki hücrenin bitişik kenarları
                          // üst üste bindiğinden iç çizgiler (iki kat) dış
                          // çizgilerin (tek kat) yaklaşık iki katı kalın
                          // görünüyordu. Çözüm: her hücre yalnızca üst VE
                          // sol kenarını çizer; sağ kenarı sadece SON
                          // sütundaki, alt kenarı sadece SON satırdaki
                          // hücreler çizer. Böylece paylaşılan her çizgi
                          // (iç ya da dış fark etmeksizin) tam olarak BİR
                          // hücre tarafından ve tek katman olarak çizilir —
                          // tüm çizgiler eşit kalınlıkta görünür.
                          border: Border(
                            top: BorderSide(
                              color: effectiveBorderColor,
                              width: 2,
                            ),
                            left: BorderSide(
                              color: effectiveBorderColor,
                              width: 2,
                            ),
                            right: c == _rows[r].length - 1
                                ? BorderSide(
                                    color: effectiveBorderColor,
                                    width: 2,
                                  )
                                : BorderSide.none,
                            bottom: r == _rows.length - 1
                                ? BorderSide(
                                    color: effectiveBorderColor,
                                    width: 2,
                                  )
                                : BorderSide.none,
                          ),
                        ),
                        child: TextField(
                          controller: _controllers[r][c],
                          focusNode: _focusNodes[r][c],
                          autofocus: widget.autofocus && r == 0 && c == 0,
                          style: cellTextStyle,
                          minLines: 1,
                          maxLines: 4,
                          textInputAction: TextInputAction.next,
                          // DÜZELTME: Enter'a basılınca önce AYNI satırdaki
                          // sağdaki hücreye geçilir; satırın son hücresine
                          // gelindiğinde ise bir alt satırın ilk (en
                          // soldaki) hücresine geçilir (klasik satır-sonu
                          // sarma davranışı). Varsayılan
                          // FocusScope.nextFocus() yerine hedef hücreyi
                          // kendimiz hesaplıyoruz ki davranış öngörülebilir
                          // olsun ve odaklanan hücre klavyenin üstünde
                          // görünür kalsın (_scrollFocusedCellIntoView).
                          // Son satırın son hücresindeysek klavyeyi kapatıp
                          // odağı bırakırız.
                          onEditingComplete: () {},
                          onSubmitted: (_) {
                            final rowLen = _rows[r].length;
                            FocusNode? targetNode;
                            final sameRow = c + 1 < rowLen;
                            if (sameRow) {
                              // Aynı satırda sağdaki hücreye geç.
                              targetNode = _focusNodes[r][c + 1];
                            } else if (r + 1 < _rows.length &&
                                _rows[r + 1].isNotEmpty) {
                              // Satır bittiyse alt satırın ilk hücresine geç.
                              targetNode = _focusNodes[r + 1][0];
                            }
                            // Hedef AYNI satırdaysa dikey konum değişmez,
                            // dolayısıyla hedefin FocusNode dinleyicisinin
                            // gereksiz bir Scrollable.ensureVisible çağrısı
                            // yapmasını (aşağı kayıp sonra yukarı zıplama
                            // etkisine yol açan zorlamalı hizalamayı)
                            // önceden bastırıyoruz.
                            _suppressNextAutoScroll = sameRow;
                            if (targetNode != null) {
                              FocusScope.of(context).requestFocus(targetNode);
                            } else {
                              _suppressNextAutoScroll = false;
                              _focusNodes[r][c].unfocus();
                            }
                          },
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
                      if (_activeCell == (r, c))
                        Positioned(
                          top: 0,
                          bottom: 0,
                          // DÜZELTME (dokunma kolaylığı): ikon sağdaki
                          // tablo dış çizgisine değecek kadar dışarı
                          // taşıyordu (right: -8). Birkaç ince ayardan
                          // sonra right: -9 ile hafifçe sağa alındı.
                          right: -9,
                          child: Center(
                            child: Material(
                              color: Colors.transparent,
                              // DÜZELTME: PopupMenuButton yerine elle
                              // showMenu() çağıran bir GestureDetector.
                              // Kök neden ve gerekçe için bkz.
                              // [_openRowColMenu] üzerindeki açıklama —
                              // özetle: PopupMenuButton'ın kendi
                              // (odağa bağlı, dispose'a açık) yaşam
                              // döngüsüne güvenmek onSelected'ın SESSİZCE
                              // hiç çağrılmamasına yol açıyordu.
                              // DÜZELTME (dokunma kolaylığı): eski 24x24
                              // dairesel arka plan + 16px ikon parmakla
                              // dokunmak için çok küçüktü ve rengi
                              // (effectiveBorderColor, ince çizgi rengi)
                              // arka planda neredeyse kayboluyordu.
                              // Dokunma alanı 32x32'ye büyütüldü, ikon
                              // 20px'e çıkarıldı ve rengi temanın birincil
                              // rengine (daha belirgin) çevrildi.
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTapDown: (details) => _openRowColMenu(
                                  details.globalPosition,
                                  r,
                                  c,
                                ),
                                child: SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: Icon(
                                    Icons.more_vert,
                                    size: 20,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.75),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ],
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
