part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// NoteFindSession
// Not editörü içi "Bul ve Değiştir" özelliğinin ARAMA MANTIĞI. Bu dosya
// kasıtlı olarak Flutter widget ağacından, dialog mixin'in dev state'inden
// ve hatta hangi alan türünün (başlık/metin bloğu/checklist maddesi/tablo
// hücresi/calc_table satırı) var olduğundan HABERSİZDİR — editörün o anki
// aranabilir alanlarını [NoteFindField] listesi olarak dışarıdan alır
// (fieldsProvider), metin okuma/yazma dahil HER ŞEYİ o alanların kendi
// getText/setText fonksiyonları üzerinden yapar. Bu sayede:
//   - Bu sınıf Flutter'a hiç bağımlı olmadan (VoidCallback hariç) test
//     edilebilir.
//   - Aşama 2'de RichBlockTextController'a geçmiş TÜM alan türleri (blok
//     içi checklist/tablo/calc_table dahil, artık tüm-not checklist türü
//     de) otomatik olarak aranabilir hale gelir — bu dosyanın onları ayrı
//     ayrı bilmesine gerek yoktur.
//
// Gerçek bağlanma (hangi NoteFindField'ların üretileceği, getText/setText'in
// hangi controller'a/veriye işleyeceği) Aşama 6'da note_list_note_dialog_
// mixin.dart içinde kurulacak. Bu aşamada henüz hiçbir UI (NoteFindBar,
// üç nokta menüsü, vb.) YOKTUR.
// ════════════════════════════════════════════════════════════════════════

/// Bir eşleşmenin konumu: hangi alanda ([fieldId]) ve o alanın METNİ
/// içindeki [start, end) karakter aralığında (String.substring kuralıyla
/// aynı — start dahil, end hariç) olduğu.
class NoteFindMatch {
  const NoteFindMatch(this.fieldId, this.start, this.end);
  final String fieldId;
  final int start;
  final int end;
}

/// Editördeki TEK bir aranabilir metin alanını (başlık, bir metin bloğu,
/// bir checklist maddesi, bir tablo hücresi, bir calc_table satırının
/// Kalem/Tutar'ı, tüm-not checklist türünün bir maddesi, vb.) temsil eder.
///
/// [id]: alanın bu Bul oturumu boyunca KARARLI kimliği — ör. 'title',
/// 'block_3', 'checklist_3_item_7', 'table_5_r2_c1', 'calc_5_r3_label'.
/// Bu id, RichBlockTextController'ların getHighlights callback'inin
/// [NoteFindSession.highlightsFor] ile hangi alana bakacağını bulmasında
/// kullanılır (bkz. rich_block_text_controller.dart, Aşama 1) — üreten
/// tarafın (Aşama 6) bu id'yi controller kuruluş noktasındaki id ile
/// BİREBİR aynı üretmesi gerekir.
///
/// [getText]/[setText], gerçek Flutter controller'ına/veri Map'ine nasıl
/// okunup yazılacağını bilmez; bunu üreten taraf (fieldsProvider) belirler
/// — bu sınıf sadece bu iki fonksiyonu çağırır.
///
/// DÜZELTME: [setText] artık sadece nihai metni değil, düzenlenen aralığı
/// da KESİN olarak veriyor — [editStart], [oldEditEnd], [newEditEnd]
/// (anlamları RichTextSpans.shiftForDelete/shiftForInsert'teki start/end
/// ile birebir aynı: start dahil, end hariç). NoteFindSession bu üç değeri
/// zaten match.start/match.end üzerinden kesin olarak bildiğinden (bkz.
/// replaceActive/replaceAll), üreten taraf (fieldsProvider, Aşama 6) span
/// kaydırmasını (findRewriteSpans) artık eski metin/yeni metin üzerinde
/// ortak-önek/sonek TAHMİNİ yaparak değil, doğrudan bu kesin aralıkla
/// yapabilir — bkz. o fonksiyonun BAŞINDAKİ "kesin aralık" notu. setText
/// bu sınıf dışında (find/replace akışı dışında) hiç çağrılmadığından bu
/// üç parametre her zaman doludur, tahmine düşülecek bir yedek dal yoktur.
class NoteFindField {
  const NoteFindField({
    required this.id,
    required this.getText,
    required this.setText,
    this.focusAndSelect,
  });
  final String id;
  final String Function() getText;

  /// [newText]: alanın yeni tam metni (eskisi gibi).
  /// [editStart]: düzenlemenin başladığı, eski VE yeni metinde ORTAK olan
  /// karakter indeksi.
  /// [oldEditEnd]: eski metinde silinen aralığın bittiği indeks (silinen
  /// yoksa [editStart] ile aynı).
  /// [newEditEnd]: yeni metinde eklenen aralığın bittiği indeks (eklenen
  /// yoksa [editStart] ile aynı).
  final void Function(
    String newText,
    int editStart,
    int oldEditEnd,
    int newEditEnd,
  ) setText;

  /// Aşama 4: bu alanın FocusNode'una odaklanıp TextSelection'ını
  /// [start, end) aralığına kuran, üreten tarafça (Aşama 6) implemente
  /// edilecek opsiyonel köprü — bkz. checklist/tablo/calc_table hepsinin
  /// artık RichBlockTextController olması sayesinde bu köprünün gövdesi
  /// her alan türünde BİREBİR AYNI iki satır olacak:
  ///   controller.selection = TextSelection(baseOffset: start, extentOffset: end);
  ///   focusNode.requestFocus();
  /// (Tablo hücrelerinde ayrıca mevcut _scrollFocusedCellIntoView zaten
  /// focus'a bağlı olduğundan, requestFocus() otomatik olarak klavye-üstü
  /// kaydırmayı da tetikler.)
  ///
  /// NoteFindSession bunu SADECE kullanıcının doğrudan bir eşleşmeye
  /// GİTMEK istediği anlarda çağırır (İleri/Geri, Değiştir/Tümünü
  /// Değiştir) — [NoteFindSession.setQuery] ÇAĞIRMAZ (bkz. o metodun
  /// dokümanındaki "odak çalınmaz" notu). null bırakılırsa (ör. henüz
  /// odaklanma desteklenmeyen bir alan türü için) o eşleşmeye geçişte
  /// sadece Aşama 1 vurgusu görünür, otomatik odaklanma/kaydırma olmaz.
  final void Function(int start, int end)? focusAndSelect;
}

class NoteFindSession {
  NoteFindSession({
    required this.fieldsProvider,
    required this.requestRebuild,
    required this.pushUndoCheckpoint,
  });

  /// Editörün O ANKİ aranabilir alanlarını döndürür. Her tarama/değiştirme
  /// işleminde YENİDEN çağrılır (bir kere alınıp saklanmaz) — böylece blok
  /// ekleme/silme/sıralama gibi aradan geçen değişikliklerden sonra bile
  /// her zaman GÜNCEL alan listesiyle çalışılır.
  final List<NoteFindField> Function() fieldsProvider;

  /// Aktif eşleşme/sayaç/sorgu değiştiğinde editörün yeniden çizilmesini
  /// tetiklemek için (tipik olarak setModalState). NoteFindSession'ın
  /// kendisi hiçbir State/BuildContext'e bağlı değildir.
  final VoidCallback requestRebuild;

  /// "Değiştir" / "Tümünü Değiştir" öncesi TEK bir undo checkpoint'i
  /// oluşturmak için, editördeki mevcut checkpoint mekanizmasına enjekte
  /// edilir (bkz. NoteFindMatch dokümanındaki "tek undo checkpoint" notu).
  final VoidCallback pushUndoCheckpoint;

  String _query = '';
  String get query => _query;

  List<NoteFindMatch> _matches = const [];
  List<NoteFindMatch> get matches => _matches;

  int _activeIndex = -1;
  int get activeIndex => _activeIndex;
  int get matchCount => _matches.length;

  /// O an aktif eşleşme (yoksa null). Sayaç arayüzü "3/8" gibi 1-bazlı
  /// göstermek isterse activeIndex + 1 kullanmalıdır.
  NoteFindMatch? get activeMatch =>
      (_activeIndex >= 0 && _activeIndex < _matches.length)
          ? _matches[_activeIndex]
          : null;

  // ── Tarama ────────────────────────────────────────────────────────────

  /// Sorguyu günceller, tüm alanları yeniden tarar, ilk eşleşmeyi aktif
  /// yapar (yoksa activeIndex = -1) ve rebuild tetikler. Sorgu boşsa hiç
  /// eşleşme üretilmez (arama kutusu boşken editörde hiçbir vurgu
  /// görünmemesi gerekir).
  ///
  /// DÜZELTME/KASITLI TASARIM (odak ÇALINMAZ): bu metot [NoteFindField.
  /// focusAndSelect]'i ÇAĞIRMAZ. Kullanıcı arama kutusuna yazarken bu
  /// setQuery her tuş vuruşunda tetiklenecek (bkz. Aşama 5'teki canlı
  /// arama kutusu); eğer burada içerik alanına requestFocus() çağrılsaydı,
  /// arama kutusunun kendi FocusNode'u HEMEN odağı kaybederdi — kullanıcı
  /// ikinci harfi yazmaya devam ettiğinde bu karakter artık arama kutusuna
  /// değil, o an odaklanmış İÇERİK alanına gider (notun metnini bozar).
  /// Bu yüzden odaklanma/kaydırma SADECE kullanıcının açıkça "bir
  /// eşleşmeye GİT" dediği anlarda (next/previous/replaceActive/
  /// replaceAll) tetiklenir; setQuery yalnızca vurgu katmanını (Aşama 1)
  /// günceller, arama kutusundaki klavye odağına hiç dokunmaz.
  void setQuery(String query) {
    _query = query;
    _rescan();
    _activeIndex = _matches.isEmpty ? -1 : 0;
    requestRebuild();
  }

  void _rescan() {
    if (_query.isEmpty) {
      _matches = const [];
      return;
    }
    // Büyük/küçük harf duyarsız arama — Google Docs/Gmail'deki varsayılan
    // davranışla tutarlı; ayrı bir "Büyük/Küçük Harf Duyarlı" seçeneği
    // planda yer almadığından eklenmedi.
    final needle = _query.toLowerCase();
    final result = <NoteFindMatch>[];
    for (final field in fieldsProvider()) {
      final haystack = field.getText().toLowerCase();
      int from = 0;
      while (true) {
        final idx = haystack.indexOf(needle, from);
        if (idx == -1) break;
        result.add(NoteFindMatch(field.id, idx, idx + needle.length));
        // Örtüşmeyen eşleşmeler: bir sonraki taramaya bu eşleşmenin
        // BİTİMİNDEN devam edilir (idx + 1'den değil).
        from = idx + needle.length;
      }
    }
    _matches = result;
  }

  // ── Gezinme (İleri/Geri) ─────────────────────────────────────────────
  // Bu ikisi (ve aşağıdaki replaceActive/replaceAll) KULLANICININ AÇIKÇA
  // "bir eşleşmeye git" dediği anlardır — setQuery'nin aksine, aktif
  // eşleşme değiştiğinde ilgili alana odaklan/kaydır (Aşama 4).

  void next() {
    if (_matches.isEmpty) return;
    _activeIndex = (_activeIndex + 1) % _matches.length;
    requestRebuild();
    _focusActiveMatch();
  }

  void previous() {
    if (_matches.isEmpty) return;
    _activeIndex = (_activeIndex - 1 + _matches.length) % _matches.length;
    requestRebuild();
    _focusActiveMatch();
  }

  // ── Aşama 4: aktif eşleşmeye odaklanma/kaydırma ─────────────────────────
  // İlgili alanın focusAndSelect'i sağlanmışsa çağrılır (bkz. NoteFindField
  // dokümanı). requestRebuild()'DEN SONRA çağrılır ki Aşama 1 vurgusu ve
  // odaklanma aynı frame'de tutarlı görünsün; pratikte requestFocus()'un
  // kendisi widget ağacının zaten kurulu olmasını gerektirmez (bu
  // diyalogdaki tüm alanlar lazy-build edilen bir liste değil, doğrudan
  // Column/ReorderableListView içinde kurulu olduğundan güvenlidir).
  void _focusActiveMatch() {
    final match = activeMatch;
    if (match == null) return;
    final field = _findField(match.fieldId);
    field?.focusAndSelect?.call(match.start, match.end);
  }

  // ── Değiştirme ────────────────────────────────────────────────────────

  /// O an aktif olan eşleşmeyi [replacement] ile değiştirir. Aktif eşleşme
  /// yoksa hiçbir şey yapmaz.
  ///
  /// Değiştirmeden önce TEK bir undo checkpoint'i oluşturulur, ardından
  /// ilgili alan YENİDEN yazılır ve TÜM alanlar YENİDEN TARANIR (metin
  /// uzunluğu değiştiğinden eski aralıklar geçersiz olabilir). Aktif
  /// indeks numarası KORUNUR (0'a clamp'lenerek) — matches[] her zaman
  /// "alan sırası, sonra alan içi konum" sırasına göre tutulduğundan, bu,
  /// değiştirilen eşleşmenin listeden çıkmasıyla o SAYISAL indekse kayan
  /// bir SONRAKİ eşleşmeyi otomatik olarak aktif bırakır — masaüstü
  /// Bul&Değiştir araçlarındaki "değiştir ve bir sonrakine geç" hissini
  /// ayrıca bir "sıradaki eşleşmeyi bul" adımına gerek kalmadan verir.
  void replaceActive(String replacement) {
    final match = activeMatch;
    if (match == null) return;
    final field = _findField(match.fieldId);
    if (field == null) return;

    pushUndoCheckpoint();
    final text = field.getText();
    final newText = text.substring(0, match.start) +
        replacement +
        text.substring(match.end);
    // match.start/match.end zaten bu değişikliğin KESİN aralığı — üreten
    // taraf artık bunu eski/yeni metni diff'leyerek yeniden TAHMİN etmek
    // zorunda değil (bkz. NoteFindField.setText dokümanı).
    field.setText(
      newText,
      match.start,
      match.end,
      match.start + replacement.length,
    );

    _rescan();
    _activeIndex =
        _matches.isEmpty ? -1 : _activeIndex.clamp(0, _matches.length - 1);
    requestRebuild();
    _focusActiveMatch();
  }

  /// TÜM eşleşmeleri [replacement] ile değiştirir — TEK bir undo
  /// checkpoint'i ile (kullanıcı bunu TEK bir "geri al" adımıyla geri
  /// alabilsin diye; her eşleşme ayrı bir checkpoint OLUŞTURMAZ).
  ///
  /// Aynı alan içindeki eşleşmeler SONDAN BAŞA doğru uygulanır — aksi
  /// halde bir eşleşmeyi değiştirmek, aynı alandaki SONRAKİ eşleşmelerin
  /// karakter aralıklarını kaydırıp yanlış yere yazmaya yol açardı.
  /// Farklı alanlar birbirinden bağımsız olduğundan aralarındaki sıra
  /// önemli değildir.
  ///
  /// DÜZELTME: aynı alanda birden fazla eşleşme olduğunda artık TEK bir
  /// birleşik metin üretip setText'i BİR KEZ çağırmıyoruz — bu, üreten
  /// tarafın span kaydırmasını yalnızca "ilk eşleşmenin başı" ile "son
  /// eşleşmenin sonu" arasını KABACA tek bir düzenleme sayarak yapmasına
  /// zorluyordu (aradaki biçimlendirme sınırları bulanıklaşıyordu — bkz.
  /// eski NoteFindField.setText dokümanındaki not). Bunun yerine her
  /// eşleşme için (yine sondan başa) AYRI bir setText çağrısı yapılır;
  /// her çağrı kendi match.start/match.end'ini KESİN aralık olarak taşır,
  /// böylece span kaydırması her eşleşmede de replaceActive ile birebir
  /// aynı hassasiyette olur.
  void replaceAll(String replacement) {
    if (_matches.isEmpty) return;
    pushUndoCheckpoint();

    final byField = <String, List<NoteFindMatch>>{};
    for (final m in _matches) {
      (byField[m.fieldId] ??= <NoteFindMatch>[]).add(m);
    }
    for (final entry in byField.entries) {
      final field = _findField(entry.key);
      if (field == null) continue;
      final fieldMatches = entry.value
        ..sort((a, b) => b.start.compareTo(a.start));
      for (final m in fieldMatches) {
        // Her adımda metin YENİDEN okunuyor — bir önceki setText çağrısı
        // alttaki veriyi (block['text']/item['text']/vb.) senkron olarak
        // güncellediğinden, bu her zaman en güncel hali yansıtır.
        final text = field.getText();
        final newText =
            text.substring(0, m.start) + replacement + text.substring(m.end);
        field.setText(newText, m.start, m.end, m.start + replacement.length);
      }
    }

    _rescan();
    _activeIndex = _matches.isEmpty ? -1 : 0;
    requestRebuild();
    _focusActiveMatch();
  }

  NoteFindField? _findField(String id) {
    for (final f in fieldsProvider()) {
      if (f.id == id) return f;
    }
    return null;
  }

  // ── Aşama 1 köprüsü: bir alanın o anki vurgu durumu ─────────────────────

  /// RichBlockTextController'ların (checklist/tablo/calc_table/tüm-not
  /// checklist dahil TÜM alan türlerinde AYNI şekilde) getHighlights
  /// callback'i olarak kullanılmak üzere tasarlandı (bkz.
  /// rich_block_text_controller.dart -> TextHighlightSnapshot). Aşama
  /// 6'da her kuruluş noktasına
  ///   getHighlights: () => findSession.highlightsFor('<o alanın id'si>')
  /// şeklinde bağlanacak. "Bul" modu kapalıyken/sorgu boşken _matches boş
  /// olduğundan bu her zaman ucuz bir işlemdir.
  TextHighlightSnapshot highlightsFor(String fieldId) {
    if (_matches.isEmpty) return TextHighlightSnapshot.empty;
    TextHighlightRange? active;
    final passive = <TextHighlightRange>[];
    for (int i = 0; i < _matches.length; i++) {
      final m = _matches[i];
      if (m.fieldId != fieldId) continue;
      final range = TextHighlightRange(m.start, m.end);
      if (i == _activeIndex) {
        active = range;
      } else {
        passive.add(range);
      }
    }
    if (active == null && passive.isEmpty) return TextHighlightSnapshot.empty;
    return TextHighlightSnapshot(activeRange: active, passiveRanges: passive);
  }

  /// "Bul" modu kapatılırken çağrılır: sorgu/eşleşmeler temizlenir ki
  /// highlightsFor() her alan için boş dönsün (vurgular editörden kalkar).
  /// NoteFindSession'ın dispose edilmesi gereken bir kaynağı (controller/
  /// stream/vb.) olmadığından ayrı bir dispose() metodu yoktur — çağıran
  /// taraf "Bul" modunu kapatırken sadece bunu çağırması yeterlidir.
  void clear() {
    _query = '';
    _matches = const [];
    _activeIndex = -1;
    requestRebuild();
  }
}
