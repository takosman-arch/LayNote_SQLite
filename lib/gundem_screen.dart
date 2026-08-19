part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// GÜNDEM EKRANI
// İki kaynaktan gelen notları zaman bazlı bölümler altında listeler:
//   Gecikmiş → Bugün → Yarın → (bugünden itibaren ilk 7 günün kalan her
//   günü kendi barında, örn. "Çarşamba") → Gelecek Hafta → Daha İleri
// Hafta sınırları takvim haftası (Pazartesi-Pazar) değil, bugüne göre
// kayan (rolling) bir penceredir: ilk hafta bugün+6'ya kadar, Gelecek
// Hafta day+7..day+13, Daha İleri day+14 ve sonrası.
//
// Satırlarda artık kaynağa göre renkli bir şerit YOK; tüm satırlar aynı
// nötr kart görünümünde. Yalnızca hatırlatıcı kaynaklı satırlarda, saat
// satırın en sağında mavi renkte gösterilir (atanan-tarih satırlarında
// saat gösterilmez).
// Bir notun hem hatırlatıcısı hem de aynı güne denk gelen atanmış tarihi
// varsa, tek satır (hatırlatıcı öncelikli) gösterilir; farklı günlere
// denk geliyorsa iki ayrı satır olarak görünebilir.
//
// Tek-günlük bölümlerde (Bugün/Yarın/[gün adı]) satırda tarih tekrar
// gösterilmez (başlık zaten günü söylüyor); çok-günlük bölümlerde
// (Gecikmiş/Gelecek Hafta/Daha İleri) satırın altında hangi güne ait
// olduğu gösterilir.
//
// Takvim ekranındaki tekrar (repeat) hesaplama mantığı
// (_reminderOccursOnDay / _effectiveReminderOn) burada da kullanılır.
//
// _reminderAgendaDay / _assignedAgendaDay / _gundemNoteCount TOP-LEVEL
// (sınıf dışı) fonksiyonlardır; böylece hem bu ekran hem de çekmece
// menüsündeki sayaç (bkz. note_list_build_mixin.dart) aynı mantığı
// kod tekrarı olmadan paylaşabilir.
// ════════════════════════════════════════════════════════════════════════

bool _gundemIsSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

// Kısa ay isimleri listesi (1 Ocak = index 0). _gundemShortDateLabel
// içindeki tanımla AYNI ARB anahtarlarını kullanır; note_list_note_dialog_
// mixin.dart gibi başka dosyaların da aynı listeyi kod tekrarı olmadan
// kullanabilmesi için üst seviyeye (paylaşılabilir) çıkarıldı.
List<String> _gundemMonthNamesShortTr(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return [
    l10n.gundemMonthShortJan,
    l10n.gundemMonthShortFeb,
    l10n.gundemMonthShortMar,
    l10n.gundemMonthShortApr,
    l10n.gundemMonthShortMay,
    l10n.gundemMonthShortJun,
    l10n.gundemMonthShortJul,
    l10n.gundemMonthShortAug,
    l10n.gundemMonthShortSep,
    l10n.gundemMonthShortOct,
    l10n.gundemMonthShortNov,
    l10n.gundemMonthShortDec,
  ];
}

// Tam gün isimleri listesi (Pazartesi = index 0). build() içindeki
// weekDayFull tanımıyla AYNI ARB anahtarlarını kullanır; aynı paylaşım
// gerekçesiyle üst seviyeye çıkarıldı.
List<String> _gundemWeekDayFullTr(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return [
    l10n.gundemWeekdayMonday,
    l10n.gundemWeekdayTuesday,
    l10n.gundemWeekdayWednesday,
    l10n.gundemWeekdayThursday,
    l10n.gundemWeekdayFriday,
    l10n.gundemWeekdaySaturday,
    l10n.gundemWeekdaySunday,
  ];
}

// "Bugün"/"Yarın" başlıklarının yanında gösterilecek kısa tarih etiketi,
// örn. "9 Ağu". Ay kısaltması AppLocalizations üzerinden lokalize edilir.
String _gundemShortDateLabel(BuildContext context, DateTime d) {
  final l10n = AppLocalizations.of(context)!;
  final monthNamesShort = [
    l10n.gundemMonthShortJan,
    l10n.gundemMonthShortFeb,
    l10n.gundemMonthShortMar,
    l10n.gundemMonthShortApr,
    l10n.gundemMonthShortMay,
    l10n.gundemMonthShortJun,
    l10n.gundemMonthShortJul,
    l10n.gundemMonthShortAug,
    l10n.gundemMonthShortSep,
    l10n.gundemMonthShortOct,
    l10n.gundemMonthShortNov,
    l10n.gundemMonthShortDec,
  ];
  return '${d.day} ${monthNamesShort[d.month - 1]}';
}

// Bir notun hatırlatıcısının "gündemdeki günü"nü belirler:
// - Tekrarsız hatırlatıcılarda doğrudan kurulu tarihin günüdür (geçmişte
//   olsa bile döner; bu sayede "gecikmiş" bölümüne düşebilir).
// - Tekrarlı hatırlatıcılarda bugünden (veya kurulduğu günden, hangisi
//   daha ilerideyse) itibaren ileri doğru taranarak kuralın devreye
//   girdiği en yakın gün bulunur. 'hourly' tekrar yalnızca kurulduğu
//   günde eşleşir (bkz. calendar_screen.dart -> _reminderOccursOnDay).
DateTime? _reminderAgendaDay(Map<String, dynamic> note) {
  final raw = note['reminderDate']?.toString();
  if (raw == null || raw.isEmpty) return null;
  final base = DateTime.tryParse(raw);
  if (base == null) return null;
  final baseDay = DateTime(base.year, base.month, base.day);

  final repeat = note['reminderRepeat']?.toString();
  if (repeat == null || repeat.isEmpty) {
    return baseDay;
  }

  final today = DateTime.now();
  final todayDay = DateTime(today.year, today.month, today.day);
  final searchStart = todayDay.isBefore(baseDay) ? baseDay : todayDay;
  for (int i = 0; i < 400; i++) {
    final candidate = searchStart.add(Duration(days: i));
    if (_reminderOccursOnDay(note, candidate)) return candidate;
  }
  return null;
}

// Alt bardan (takvimden) atanan tarihin günü. Zaman bilgisi yok sayılır,
// sadece gün esas alınır.
DateTime? _assignedAgendaDay(Map<String, dynamic> note) {
  final raw = note['assignedDate']?.toString();
  if (raw == null || raw.isEmpty) return null;
  final dt = DateTime.tryParse(raw);
  if (dt == null) return null;
  return DateTime(dt.year, dt.month, dt.day);
}

// Çekmece menüsündeki "Gündem" satırının yanında gösterilecek sayı:
// Gündem'de en az bir satırla temsil edilen (hatırlatıcılı VEYA atanmış
// tarihli, kilitli/arşivlenmemiş) DİSTİNCT not sayısı.
int _gundemNoteCount(List<Map<String, dynamic>> notes) {
  var count = 0;
  for (final note in notes) {
    if (note['isLocked'] == true || note['isArchived'] == true) continue;
    if (_reminderAgendaDay(note) != null || _assignedAgendaDay(note) != null) {
      count++;
    }
  }
  return count;
}

// Tek bir gündem satırını temsil eder: hangi nota ait olduğu, hangi güne
// düştüğü ve kaynağının hatırlatıcı mı yoksa atanan tarih mi olduğu.
class _AgendaEntry {
  final Map<String, dynamic> note;
  final DateTime day;
  final bool isAssigned;
  const _AgendaEntry({
    required this.note,
    required this.day,
    required this.isAssigned,
  });
}

// Tek bir zaman bölümü (Gecikmiş / Bugün / Yarın / [gün adı] /
// Gelecek Hafta / Daha İleri) ve o bölüme ait satırlar.
class _AgendaSection {
  final String title;
  final IconData icon;
  final Color headerColor;
  final bool showFullDate;
  final List<_AgendaEntry> entries;
  // Yalnızca "Bugün" ve "Yarın" bölümlerinde doldurulur (örn. "9 Ağu");
  // başlığın yanında, aynı yazı stiliyle gösterilir. Diğer bölümlerde
  // (gün adları, Gelecek Hafta, Daha İleri, Gecikmiş) null kalır — onlarda
  // tarih zaten satırların altında gösteriliyor.
  final String? dateLabel;
  _AgendaSection({
    required this.title,
    required this.icon,
    required this.headerColor,
    required this.showFullDate,
    required this.entries,
    this.dateLabel,
  });
}

class GundemScreen extends StatefulWidget {
  final List<Map<String, dynamic>> notes;

  // Ayarlar > Kişiselleştirme > Metin Boyutu ile aynı değer. Not kartlarında
  // kullanılan başlık/içerik yazı boyutlarıyla birebir aynı ölçeklemeyi
  // burada da uygulayabilmek için (bkz. NoteListBuildMixin._previewFontScale)
  // dışarıdan geçiriliyor.
  final double globalFontSize;

  // Ayarlar > Kişiselleştirme > Yazı Tipi ile aynı değer (dNoteFontFamilyValue
  // ile dönüştürülmüş hâli). Not kartlarındaki yazı tipiyle birebir aynı
  // fontu Gündem satırlarında da uygulayabilmek için dışarıdan geçiriliyor.
  // null ise sistem varsayılan fontu kullanılır ('Varsayılan').
  final String? fontFamily;

  // Notu doğrudan açan callback. Verilirse, nota tıklandığında Gündem
  // KENDİNİ KAPATMADAN bu callback çağrılır (asıl not ekranı, çağıranın
  // kendi Navigator context'i üzerinden açılır ve Gündem'in ÜZERİNE
  // biner). Böylece not ekranından geri dönüldüğünde Gündem otomatik
  // olarak yeniden görünür. Verilmezse geriye dönük uyumluluk için eski
  // davranışa (Gündem kendini kapatıp sonucu çağırana Navigator.pop ile
  // iletme) geri düşülür.
  //
  // Future döner: not ekranından geri dönüldüğünde (kaydet/vazgeç fark
  // etmeksizin) Gündem bu Future'ı bekleyip kendi setState'ini tetikler;
  // aksi halde not üzerinde yapılan değişiklikler Gündem'e yansımaz (bkz.
  // _openNote).
  final Future<void> Function(Map<String, dynamic> note)? onOpenNote;

  // Gündemdeki bir satıra basılı tutulunca çıkan menüden "Gündemden
  // kaldır" seçilirse çağrılır. isAssigned true ise satır atanan tarihten,
  // false ise hatırlatıcıdan geliyordu — hangi alanın temizleneceğini
  // belirlemek için kullanılır. Verilmezse, not üzerinde ilgili tarih
  // alanı doğrudan bu ekranda (kalıcı olmadan, yalnızca görünüm için)
  // temizlenir.
  final void Function(Map<String, dynamic> note, bool isAssigned)?
      onRemoveFromAgenda;

  // Aynı menüden "Notu sil" seçilirse çağrılır. Verilmezse, not yalnızca
  // bu ekranın kendi listesinden (kalıcı olmadan) çıkarılır.
  final void Function(Map<String, dynamic> note)? onDeleteNote;

  // Üst bardaki takvim ikonuna basılınca çağrılır (context, Takvim ekranını
  // push edebilmek için verilir). Verilmezse ikon gösterilmez.
  final void Function(BuildContext context)? onOpenCalendar;

  const GundemScreen({
    super.key,
    required this.notes,
    this.globalFontSize = 16.0,
    this.fontFamily,
    this.onOpenNote,
    this.onRemoveFromAgenda,
    this.onDeleteNote,
    this.onOpenCalendar,
  });

  @override
  State<GundemScreen> createState() => _GundemScreenState();
}

class _GundemScreenState extends State<GundemScreen> {
  // "Gecikmiş" bölümü gecikmiş not varsa en üstte KAPALI bir bar olarak
  // durur (sadece başlık görünür); kullanıcı bara dokununca içindeki
  // notlar açılır/kapanır. Gecikmiş not yoksa bar hiç gösterilmez.
  bool _overdueExpanded = false;

  DateTime _reminderTimeOf(Map<String, dynamic> note, DateTime agendaDay) {
    return _effectiveReminderOn(note, agendaDay) ??
        DateTime.tryParse(note['reminderDate']?.toString() ?? '') ??
        agendaDay;
  }

  DateTime _timeOf(_AgendaEntry e) => e.isAssigned
      ? (DateTime.tryParse(e.note['assignedDate']?.toString() ?? '') ?? e.day)
      : _reminderTimeOf(e.note, e.day);

  // Bir gündem satırına tıklandığında notu açar. onOpenNote sağlanmışsa
  // Gündem KAPANMADAN callback çağrılır; not ekranı Gündem'in üzerine
  // açılır ve geri dönüldüğünde Gündem otomatik olarak tekrar görünür.
  // Sağlanmamışsa eski davranışa (Gündem kendini kapatıp sonucu çağırana
  // iletme) geri düşülür.
  Future<void> _openNote(
    BuildContext context,
    Map<String, dynamic> note,
  ) async {
    final callback = widget.onOpenNote;
    if (callback != null) {
      // Not ekranı Gündem'in üzerine açılıyor; kullanıcı geri dönene kadar
      // bu Future tamamlanmaz. Döndüğünde not üzerinde değişiklik yapılmış
      // olabileceğinden (widget.notes ile aynı Map referansı paylaşıldığı
      // için veri zaten güncel), Gündem'in yalnızca kendi build'ini
      // yenilemesi yeterlidir.
      await callback(note);
      if (mounted) setState(() {});
    } else {
      Navigator.pop(context, {
        'action': 'open',
        'id': note['id']?.toString(),
      });
    }
  }

  // Gündemdeki bir satıra basılı tutulunca çıkan menü: "Gündemden kaldır"
  // (yalnızca bu satırın kaynağı olan tarih/hatırlatıcıyı temizler, not
  // kalır) veya "Notu sil" (notun tamamını siler). Kalıcı veri değişikliği
  // dışarıdan sağlanan onRemoveFromAgenda/onDeleteNote callback'leri
  // üzerinden yapılır; sağlanmazsa yalnızca bu ekranın görünümünde
  // (kalıcı olmadan) uygulanır.
  Future<void> _showAgendaTileMenu(
    BuildContext context,
    Map<String, dynamic> note,
    bool isAssigned,
  ) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: dNoteCardColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.event_busy, color: Colors.blueGrey),
              title: Text(AppLocalizations.of(context)!.gundemMenuRemoveFromAgenda),
              onTap: () => Navigator.pop(sheetCtx, 'remove'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: Text(AppLocalizations.of(context)!.gundemMenuDeleteNote),
              onTap: () => Navigator.pop(sheetCtx, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (!context.mounted || action == null) return;

    if (action == 'remove') {
      final callback = widget.onRemoveFromAgenda;
      // Not: callback verilmişse bile widget.notes ile parent'ın listesi
      // aynı Map referanslarını paylaşır, dolayısıyla callback içindeki
      // alan temizliği burada da görünür olur. Eksik olan tek şey Gündem'in
      // bunu görmesi için kendi setState'ini çağırması.
      setState(() {
        if (callback != null) {
          callback(note, isAssigned);
        } else {
          if (isAssigned) {
            note.remove('assignedDate');
          } else {
            note.remove('reminderDate');
            note.remove('reminderRepeat');
          }
        }
      });
    } else if (action == 'delete') {
      final callback = widget.onDeleteNote;
      // callback verilmiş olsa bile widget.notes AYRI bir liste (Gündem
      // açılırken alınan bir kopya); parent kendi listesinden silse de bu
      // listeden otomatik düşmez. Bu yüzden burada HER ZAMAN kendi
      // listesinden de çıkarıyoruz.
      setState(() {
        if (callback != null) callback(note);
        widget.notes.removeWhere(
          (n) => n['id']?.toString() == note['id']?.toString(),
        );
      });
    }
  }

  // Tüm notları tarayıp gündem satırlarını (_AgendaEntry) üretir, ardından
  // bunları zaman bazlı bölümlere (_AgendaSection) ayırır. Bölüm sırası:
  // Gecikmiş, Bugün, Yarın, bugünden itibaren ilk 7 günün kalan her günü
  // (ayrı ayrı, örn. "Salı"), Gelecek Hafta (day+7..day+13), Daha İleri.
  // Hafta sınırları takvim haftası (Pazartesi-Pazar) değil, bugüne göre
  // kayan (rolling) bir penceredir.
  List<_AgendaSection> _buildSections() {
    final today = DateTime.now();
    final todayDay = DateTime(today.year, today.month, today.day);
    final tomorrow = todayDay.add(const Duration(days: 1));


    // "İlk hafta": bugünden itibaren kayan (rolling) 7 günlük pencere
    // (bugün + sonraki 6 gün) — takvim haftası (Pazartesi-Pazar) değil.
    // Bu pencerenin son günü firstWeekEnd; Gelecek Hafta bölümü bunu
    // takip eden 7 günü (day+7 .. day+13) kapsar.
    final firstWeekEnd = todayDay.add(const Duration(days: 6));
    final nextWeekStart = todayDay.add(const Duration(days: 7));
    final nextWeekEnd = todayDay.add(const Duration(days: 13));

    // Bu haftanın kalan günleri (yarından sonra, ilk haftanın sonuna kadar)
    // için sırayla anahtar/gün listesi. firstWeekEnd, tomorrow'dan önce ya
    // da aynıysa boş kalır.
    final restOfWeekDays = <DateTime>[];
    var cursor = tomorrow.add(const Duration(days: 1));
    while (!cursor.isAfter(firstWeekEnd)) {
      restOfWeekDays.add(cursor);
      cursor = cursor.add(const Duration(days: 1));
    }

    // Her bölüm için boş bir _AgendaEntry listesi hazırla (sıra önemli).
    final overdueEntries = <_AgendaEntry>[];
    final todayEntries = <_AgendaEntry>[];
    final tomorrowEntries = <_AgendaEntry>[];
    final restOfWeekEntries = {
      for (final d in restOfWeekDays) d: <_AgendaEntry>[],
    };
    final nextWeekEntries = <_AgendaEntry>[];
    final furtherEntries = <_AgendaEntry>[];

    void addEntry(_AgendaEntry entry) {
      final day = entry.day;
      if (day.isBefore(todayDay)) {
        overdueEntries.add(entry);
      } else if (_gundemIsSameDay(day, todayDay)) {
        todayEntries.add(entry);
      } else if (_gundemIsSameDay(day, tomorrow)) {
        tomorrowEntries.add(entry);
      } else if (!day.isAfter(firstWeekEnd)) {
        restOfWeekEntries[day]?.add(entry);
      } else if (!day.isBefore(nextWeekStart) && !day.isAfter(nextWeekEnd)) {
        nextWeekEntries.add(entry);
      } else {
        furtherEntries.add(entry);
      }
    }

    for (final note in widget.notes) {
      if (note['isLocked'] == true || note['isArchived'] == true) continue;

      final reminderDay = _reminderAgendaDay(note);
      if (reminderDay != null) {
        addEntry(_AgendaEntry(note: note, day: reminderDay, isAssigned: false));
      }

      final assignedDay = _assignedAgendaDay(note);
      if (assignedDay != null) {
        // Aynı not, aynı gün için zaten hatırlatıcı satırıyla temsil
        // ediliyorsa, aynı notu iki kez göstermemek için atanan-tarih
        // satırı atlanır.
        final ownReminderSameDay =
            reminderDay != null && _gundemIsSameDay(assignedDay, reminderDay);
        if (!ownReminderSameDay) {
          addEntry(_AgendaEntry(note: note, day: assignedDay, isAssigned: true));
        }
      }
    }

    void sortEntries(List<_AgendaEntry> list) =>
        list.sort((a, b) => _timeOf(a).compareTo(_timeOf(b)));

    sortEntries(overdueEntries);
    sortEntries(todayEntries);
    sortEntries(tomorrowEntries);
    for (final list in restOfWeekEntries.values) {
      sortEntries(list);
    }
    sortEntries(nextWeekEntries);
    sortEntries(furtherEntries);

    final l10n = AppLocalizations.of(context)!;
    final weekDayFull = [
      l10n.gundemWeekdayMonday,
      l10n.gundemWeekdayTuesday,
      l10n.gundemWeekdayWednesday,
      l10n.gundemWeekdayThursday,
      l10n.gundemWeekdayFriday,
      l10n.gundemWeekdaySaturday,
      l10n.gundemWeekdaySunday,
    ];

    final futureColor = Colors.grey;
    final sections = <_AgendaSection>[
      _AgendaSection(
        title: l10n.gundemSectionOverdue,
        icon: Icons.error_outline,
        headerColor: Colors.redAccent,
        showFullDate: true,
        entries: _lastThree(overdueEntries),
      ),
      _AgendaSection(
        title: l10n.gundemSectionToday,
        icon: Icons.today_outlined,
        headerColor: Colors.green,
        showFullDate: false,
        entries: todayEntries,
        dateLabel: _gundemShortDateLabel(context, todayDay),
      ),
      _AgendaSection(
        title: l10n.gundemSectionTomorrow,
        icon: Icons.wb_twilight,
        headerColor: futureColor,
        showFullDate: false,
        entries: tomorrowEntries,
        dateLabel: _gundemShortDateLabel(context, tomorrow),
      ),
      for (final d in restOfWeekDays)
        _AgendaSection(
          title: weekDayFull[d.weekday - 1],
          icon: Icons.calendar_today_outlined,
          headerColor: futureColor,
          showFullDate: false,
          entries: restOfWeekEntries[d]!,
          dateLabel: _gundemShortDateLabel(context, d),
        ),
      _AgendaSection(
        title: l10n.gundemSectionNextWeek,
        icon: Icons.date_range_outlined,
        headerColor: futureColor,
        showFullDate: true,
        entries: nextWeekEntries,
      ),
      _AgendaSection(
        title: l10n.gundemSectionFurther,
        icon: Icons.more_horiz,
        headerColor: futureColor,
        showFullDate: true,
        entries: furtherEntries,
      ),
    ];

    // Boş bölümleri (satırı olmayan) gösterme.
    return sections.where((s) => s.entries.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sections = _buildSections();
    final overdueSection =
        sections.where((s) => s.title == l10n.gundemSectionOverdue).isEmpty
        ? null
        : sections.firstWhere((s) => s.title == l10n.gundemSectionOverdue);
    final restSections =
        sections.where((s) => s.title != l10n.gundemSectionOverdue).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: appAccentColor.value),
        title: Text(
          l10n.gundemAppBarTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: appAccentColor.value,
            fontSize: 18,
          ),
        ),
        actions: [
          if (widget.onOpenCalendar != null)
            IconButton(
              icon: const Icon(Icons.calendar_month),
              tooltip: l10n.gundemCalendarTooltip,
              onPressed: () => widget.onOpenCalendar!(context),
            ),
        ],
      ),
      body: SafeArea(
        child: sections.isEmpty
            ? _buildEmptyState(context)
            : CustomScrollView(
                slivers: [
                  if (overdueSection != null)
                    SliverToBoxAdapter(
                      child: _buildOverdueCollapsedBar(context, overdueSection),
                    ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            _buildSection(context, restSections[index]),
                        childCount: restSections.length,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // "Gecikmiş" bölümünü en üstte, kapalı bir başlık satırı olarak gösterir
  // (yalnızca ikon + başlık görünür, sayı YOK). Diğer bölüm başlıklarıyla
  // aynı genişlik/hizada durur (kutu/çerçeve yok); dokunulduğunda altındaki
  // notlar açılır/kapanır (_overdueExpanded). Açılıp kapanma yalnızca
  // yükseklik olarak animasyonludur, opaklık/yanıp sönme efekti yoktur.
  Widget _buildOverdueCollapsedBar(BuildContext context, _AgendaSection section) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => setState(() => _overdueExpanded = !_overdueExpanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 6, 4, 8),
              child: Row(
                children: [
                  Icon(section.icon, size: 16, color: section.headerColor),
                  const SizedBox(width: 6),
                  Text(
                    section.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: section.headerColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _overdueExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: dNoteTextColor(context).withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: !_overdueExpanded
                ? const SizedBox(width: double.infinity)
                : Column(
                    children: section.entries
                        .map(
                          (entry) => _AgendaTile(
                            note: entry.note,
                            agendaDay: entry.day,
                            isAssigned: entry.isAssigned,
                            showFullDate: section.showFullDate,
                            globalFontSize: widget.globalFontSize,
                            fontFamily: widget.fontFamily,
                            onTap: (ctx) => _openNote(ctx, entry.note),
                            onLongPress: (ctx) => _showAgendaTileMenu(
                              ctx,
                              entry.note,
                              entry.isAssigned,
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_available_outlined,
              size: 56,
              color: dNoteTextColor(context).withValues(alpha: 0.35),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.gundemEmptyTitle,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: dNoteTextColor(context).withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context)!.gundemEmptySubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: dNoteTextColor(context).withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, _AgendaSection section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 6, 4, 8),
            child: Row(
              children: [
                Icon(section.icon, size: 16, color: section.headerColor),
                const SizedBox(width: 6),
                Text(
                  section.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: section.headerColor,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${section.entries.length}',
                  style: TextStyle(
                    fontSize: 15,
                    color: dNoteTextColor(context).withValues(alpha: 0.4),
                  ),
                ),
                if (section.dateLabel != null) ...[
                  const Spacer(),
                  Text(
                    section.dateLabel!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: section.headerColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
          ...section.entries.map(
            (entry) => _AgendaTile(
              note: entry.note,
              agendaDay: entry.day,
              isAssigned: entry.isAssigned,
              showFullDate: section.showFullDate,
              globalFontSize: widget.globalFontSize,
              fontFamily: widget.fontFamily,
              onTap: (ctx) => _openNote(ctx, entry.note),
              onLongPress: (ctx) => _showAgendaTileMenu(
                ctx,
                entry.note,
                entry.isAssigned,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // En fazla son 3 eleman (bugüne en yakın olan 3 tanesi) döner; liste
  // zaten en eskiden en yeniye sıralı olduğu için son 3 eleman alınır.
  List<_AgendaEntry> _lastThree(List<_AgendaEntry> entries) {
    if (entries.length <= 3) return entries;
    return entries.sublist(entries.length - 3);
  }
}

// note['content'] alanı çoğu notta düz JSON blok dizisi olarak saklanır
// (örn. [{"type":"text","text":"..."}] veya [{"type":"checklist",...}]).
// Başlık boşken bu alanı doğrudan ekrana basmak yerine, bloklardan okunabilir
// bir önizleme metni üretir. content JSON değilse (eski/düz metin notlar)
// olduğu gibi döner.
String _gundemPreviewFromContent(BuildContext context, String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return '';
  final l10n = AppLocalizations.of(context)!;
  try {
    final decoded = jsonDecode(trimmed);
    if (decoded is! List) return trimmed;

    final buffer = StringBuffer();
    void addPart(String part) {
      final p = part.trim();
      if (p.isEmpty) return;
      if (buffer.isNotEmpty) buffer.write(' ');
      buffer.write(p);
    }

    for (final block in decoded) {
      if (block is! Map) continue;
      switch (block['type']?.toString()) {
        case 'text':
          addPart(block['text']?.toString() ?? '');
          break;
        case 'checklist':
          final items = block['items'];
          if (items is List) {
            for (final item in items) {
              if (item is Map) addPart(item['text']?.toString() ?? '');
            }
          }
          break;
        case 'calc_table':
          addPart(l10n.gundemPreviewCalcTableLabel);
          break;
        case 'drawing':
          addPart(l10n.gundemPreviewDrawingLabel);
          break;
        case 'image':
          addPart(l10n.gundemPreviewImageLabel);
          break;
        default:
          break;
      }
      if (buffer.length > 120) break;
    }
    return buffer.toString();
  } catch (_) {
    // Geçerli JSON değil → zaten düz metin, olduğu gibi kullan.
    return trimmed;
  }
}

// _gundemPreviewFromContent() ile BİREBİR AYNI algoritmayı izleyen, ama
// ayrıca 'text' bloklarının span'larını (offset'lenmiş olarak) da
// döndüren yardımcı. Gündem satırında başlık yerine içerik önizlemesi
// gösterildiğinde (notun başlığı yoksa) kalın/italik/renk/link/vurgu
// biçimlendirmesinin de görünebilmesi için eklendi.
//
// ÖNEMLİ: _gundemPreviewFromContent() KENDİSİ DEĞİŞTİRİLMEDİ. Buradaki
// metin üretimi onunla TAMAMEN aynı adımları (aynı ' ' ile birleştirme,
// her parçanın ayrı ayrı trim edilmesi, 120 karakter sonrası kesme)
// izler — aksi halde span'ların start/end'i ekranda gösterilen metinle
// uyuşmaz. Yalnızca 'text' tipi bloklar span taşıyabilir (checklist
// öğeleri, hesap tablosu/çizim/görsel yer tutucuları hiç span
// taşımıyor), dolayısıyla span kaydırma sadece o bloklar için yapılır.
(String, List<Map<String, dynamic>>) _gundemPreviewWithSpans(
  BuildContext context,
  String raw,
) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return ('', const []);
  final l10n = AppLocalizations.of(context)!;
  try {
    final decoded = jsonDecode(trimmed);
    if (decoded is! List) return (trimmed, const []);

    final buffer = StringBuffer();
    final spans = <Map<String, dynamic>>[];
    int offset = 0;

    void addPart(String part, [List<Map<String, dynamic>>? blockSpans]) {
      // _gundemPreviewFromContent'teki part.trim() ile aynı: baştan/sondan
      // atılan boşluk kadar, o bloğa ait span'ların start/end'i de
      // kaydırılmalı/kırpılmalı.
      final leadingTrim = part.length - part.trimLeft().length;
      final p = part.trim();
      if (p.isEmpty) return;
      if (buffer.isNotEmpty) {
        buffer.write(' ');
        offset += 1;
      }
      if (blockSpans != null) {
        for (final s in blockSpans) {
          var sStart = (s['start'] as int) - leadingTrim;
          var sEnd = (s['end'] as int) - leadingTrim;
          if (sStart < 0) sStart = 0;
          if (sStart > p.length) sStart = p.length;
          if (sEnd < 0) sEnd = 0;
          if (sEnd > p.length) sEnd = p.length;
          if (sStart >= sEnd) continue;
          final shifted = Map<String, dynamic>.from(s);
          shifted['start'] = sStart + offset;
          shifted['end'] = sEnd + offset;
          spans.add(shifted);
        }
      }
      buffer.write(p);
      offset += p.length;
    }

    for (final block in decoded) {
      if (block is! Map) continue;
      switch (block['type']?.toString()) {
        case 'text':
          addPart(
            block['text']?.toString() ?? '',
            RichTextSpans.parse(block['spans']),
          );
          break;
        case 'checklist':
          final items = block['items'];
          if (items is List) {
            for (final item in items) {
              if (item is Map) addPart(item['text']?.toString() ?? '');
            }
          }
          break;
        case 'calc_table':
          addPart(l10n.gundemPreviewCalcTableLabel);
          break;
        case 'drawing':
          addPart(l10n.gundemPreviewDrawingLabel);
          break;
        case 'image':
          addPart(l10n.gundemPreviewImageLabel);
          break;
        default:
          break;
      }
      if (buffer.length > 120) break;
    }
    return (buffer.toString(), spans);
  } catch (_) {
    return (trimmed, const []);
  }
}

// ── Gündemdeki tek bir not satırı ────────────────────────────────────────
class _AgendaTile extends StatelessWidget {
  final Map<String, dynamic> note;
  final DateTime agendaDay;
  final bool isAssigned;
  final bool showFullDate;
  final double globalFontSize;
  final String? fontFamily;
  final void Function(BuildContext context) onTap;
  final void Function(BuildContext context)? onLongPress;

  const _AgendaTile({
    required this.note,
    required this.agendaDay,
    required this.isAssigned,
    required this.showFullDate,
    required this.globalFontSize,
    this.fontFamily,
    required this.onTap,
    this.onLongPress,
  });

  static Map<String, String> _repeatLabels(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return {
      'hourly': l10n.gundemRepeatHourly,
      'daily': l10n.gundemRepeatDaily,
      'weekly': l10n.gundemRepeatWeekly,
      'monthly': l10n.gundemRepeatMonthly,
      'yearly': l10n.gundemRepeatYearly,
    };
  }

  @override
  Widget build(BuildContext context) {
    final hasRealTitle = note['title']?.toString().trim().isNotEmpty ?? false;
    // title: ekranda gösterilecek metin (değişmedi). titleRenderSpans: o
    // metnin kalın/italik/renk/link/vurgu aralıkları — notun kendi başlığı
    // gösteriliyorsa 'titleSpans', içerik önizlemesi gösteriliyorsa
    // _gundemPreviewWithSpans'ten gelen (offset'lenmiş) span'lar kullanılır.
    final String title;
    final List<Map<String, dynamic>> titleRenderSpans;
    if (hasRealTitle) {
      title = note['title'].toString();
      titleRenderSpans = RichTextSpans.parse(note['titleSpans'] as List?);
    } else {
      final preview = _gundemPreviewWithSpans(
        context,
        note['content']?.toString() ?? '',
      );
      if (preview.$1.isNotEmpty) {
        title = preview.$1;
        titleRenderSpans = preview.$2;
      } else {
        title = AppLocalizations.of(context)!.gundemUntitledNote;
        titleRenderSpans = const [];
      }
    }

    // Notun kendi fontSize'ı varsa o, yoksa Ayarlar > Kişiselleştirme >
    // Metin Boyutu (globalFontSize) esas alınır. Başlık ile içerik önizlemesi
    // aynı boyutta gösterilir; başlıklı notlarda yalnızca kalınlık (bold)
    // farkı vardır.
    final noteFontSize =
        (note['fontSize'] as num?)?.toDouble() ?? globalFontSize;
    // Gündemde başlık, ayarlı/nota özel yazı boyutunun 1 birim eksiği
    // olarak gösterilir (bkz. kart önizleme: +2, editör: +2 — gündem
    // kasıtlı olarak daha düşük tutuluyor).
    final titleFontSize = noteFontSize - 1;
    final titleFontWeight = FontWeight.w500;

    // Zaman/tekrar bilgisi yalnızca hatırlatıcı kaynaklı satırlarda
    // anlamlıdır; atanan-tarih satırlarında saat gösterilmez.
    final effective = isAssigned ? null : _effectiveReminderOn(note, agendaDay);
    final timeLabel = effective != null
        ? '${effective.hour.toString().padLeft(2, '0')}:${effective.minute.toString().padLeft(2, '0')}'
        : '';
    final repeat = isAssigned ? null : note['reminderRepeat']?.toString();
    final repeatLabel = (repeat != null && repeat.isNotEmpty)
        ? _repeatLabels(context)[repeat]
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: dNoteCardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dNoteBorderColor(context)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onTap(context),
          onLongPress: onLongPress == null ? null : () => onLongPress!(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: ConstrainedBox(
              // Eskiden bu yükseklik, kaldırılan renkli şeridin (Container
              // width:3 height:34) satır içinde durması sayesinde
              // sağlanıyordu. Şerit kalktığı için satırın eski yüksekliğini
              // korumak amacıyla aynı minimum yükseklik burada veriliyor.
              constraints: const BoxConstraints(minHeight: 34),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          // DÜZELTME (bkz. note_list_build_mixin.dart'taki
                          // aynı isimli not): RichText, DefaultTextStyle'ı
                          // otomatik miras almadığından burada da Text.rich
                          // kullanılıyor — TextStyle/maxLines/overflow
                          // öncekiyle birebir aynı korunuyor, sadece
                          // kalın/italik/renk/link/vurgu artık görünüyor.
                          buildStaticTextSpan(
                            title,
                            titleRenderSpans,
                            TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: titleFontWeight,
                              color: dNoteTextColor(context),
                              fontFamily: fontFamily,
                            ),
                            isDark: dNoteIsDark(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (repeatLabel != null) ...[
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(
                                Icons.repeat,
                                size: 11,
                                color: dNoteTextColor(context)
                                    .withValues(alpha: 0.5),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                repeatLabel,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: dNoteTextColor(context)
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (timeLabel.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.notifications,
                      size: 13,
                      color: Colors.lightBlueAccent,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      timeLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ],
                  const SizedBox(width: 6),
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: dNoteTextColor(context).withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
