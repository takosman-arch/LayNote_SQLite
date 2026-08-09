part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// TAKVİM EKRANI (Aşama 1: Yalnızca takvimin kendisi)
// Aylar arasında sağa/sola kaydırarak (PageView) gezinilebilen, "bugün"ü ve
// seçili günü vurgulayan, modern görünümlü bir aylık takvim. Not/hatırlatıcı
// entegrasyonu bir sonraki aşamalarda bu ekranın üzerine eklenecek.
// ════════════════════════════════════════════════════════════════════════
class CalendarScreen extends StatefulWidget {
  final List<Map<String, dynamic>> notes;
  // Not: Bu ekran artık kendini Navigator.pop ile kapatıp sonucu üst
  // ekrana döndürmüyor (bu, not ekranının Takvim'in ÜSTÜNE değil, Takvim
  // zaten yığından çıkmışken üst ekranın (not listesi) üstüne push
  // edilmesine sebep oluyordu — bu yüzden not ekranından geri çıkınca
  // Takvim'e değil, not listesine dönülüyordu). Bunun yerine, tıklanan
  // aksiyon bu callback'ler ile üst ekrana bildirilir; üst ekran not
  // ekranını (Takvim hâlâ yığındayken) Takvim'in üstüne push eder, böylece
  // geri tuşu doğal olarak tekrar Takvim'e döner.
  final void Function(String noteId) onOpenNote;
  final void Function(DateTime date) onNewNote;

  const CalendarScreen({
    super.key,
    required this.notes,
    required this.onOpenNote,
    required this.onNewNote,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

// Bir günde not ve/veya hatırlatıcı bulunup bulunmadığını taşıyan basit
// bir işaretleyici. Takvim hücrelerinin altında küçük noktalar olarak
// gösterilir.
class _DayMarker {
  final bool hasNote;
  final bool hasReminder;
  const _DayMarker({this.hasNote = false, this.hasReminder = false});

  _DayMarker copyWith({bool? hasNote, bool? hasReminder}) => _DayMarker(
        hasNote: hasNote ?? this.hasNote,
        hasReminder: hasReminder ?? this.hasReminder,
      );
}

// Bir notun hatırlatıcısının verilen günde (tekrar sıklığı dahil) devreye
// girip girmediğini belirler. Tekrarsız hatırlatıcılarda VE 'hourly'
// (saatlik) tekrarda yalnızca kurulduğu gün eşleşir — saatlik tekrar bir
// güne değil gün İÇİNDEKİ her saate bağlı olduğundan takvimde ileriye dönük
// her günü işaretlemek anlamsız/gürültülü olurdu. Diğer tekrarlarda
// (daily/weekly/monthly/yearly) ilk kurulduğu günden itibaren (geçmişe doğru
// eşleşmez) sıklığa göre her uygun günde eşleşir. Ay/yıl bazlı tekrarlarda,
// hedef gün o ayda yoksa (örn. 31'i kurulmuş ama Şubat'ta 28 gün varsa) o
// ayın son gününe düşürülür — böylece hatırlatıcı hiç görünmeden geçmez.
bool _reminderOccursOnDay(Map<String, dynamic> note, DateTime day) {
  final raw = note['reminderDate']?.toString();
  if (raw == null || raw.isEmpty) return false;
  final base = DateTime.tryParse(raw);
  if (base == null) return false;
  final baseDay = DateTime(base.year, base.month, base.day);
  final target = DateTime(day.year, day.month, day.day);
  if (target.isBefore(baseDay)) return false;

  final repeat = note['reminderRepeat']?.toString();
  switch (repeat) {
    case 'daily':
      return true; // baseDay'den itibaren her gün tetiklenir.
    case 'weekly':
      return target.weekday == baseDay.weekday;
    case 'monthly':
      final daysInTargetMonth = DateTime(target.year, target.month + 1, 0).day;
      final effectiveDay =
          baseDay.day > daysInTargetMonth ? daysInTargetMonth : baseDay.day;
      return target.day == effectiveDay;
    case 'yearly':
      if (target.month != base.month) return false;
      final daysInTargetMonth = DateTime(target.year, target.month + 1, 0).day;
      final effectiveDay =
          baseDay.day > daysInTargetMonth ? daysInTargetMonth : baseDay.day;
      return target.day == effectiveDay;
    // 'hourly' de dahil: takvimde günlük bir tekrar kalıbı olarak temsil
    // edilemeyecek türler ve tekrarsız hatırlatıcılar, yalnızca kurulduğu
    // günde işaretlenir (ileriye dönük her günü boyamaz).
    default:
      return target.isAtSameMomentAs(baseDay);
  }
}

// Belirli bir günde geçerli olan hatırlatıcının o güne özgü saat/dakikasını
// (tekrarda saat, ilk kurulan hatırlatıcıdan miras alınır) döndürür; o günde
// hatırlatıcı devrede değilse null.
DateTime? _effectiveReminderOn(Map<String, dynamic> note, DateTime day) {
  final raw = note['reminderDate']?.toString();
  if (raw == null || raw.isEmpty) return null;
  final base = DateTime.tryParse(raw);
  if (base == null) return null;
  if (!_reminderOccursOnDay(note, day)) return null;
  return DateTime(day.year, day.month, day.day, base.hour, base.minute);
}

class _CalendarScreenState extends State<CalendarScreen> {
  static const List<String> _monthNamesTr = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
  ];
  static const List<String> _weekDayShortTr = [
    'Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz',
  ];
  static const List<String> _weekDayFullTr = [
    'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar',
  ];

  // Ay sayfaları bu merkez indeksten itibaren (bugünün ayı = merkez) hem
  // ileriye hem geriye doğru üretilir; PageView.builder sonsuz gibi davranır.
  static const int _centerIndex = 6000;

  late final PageController _pageController;
  // Ay başlığı (üstteki "Ağustos 2026" yazısı) ValueNotifier ile ayrı
  // tutulur; onPageChanged sürükleme SIRASINDA (parmak henüz kalkmadan)
  // tetiklendiği için, bunu normal setState ile güncellemek tüm ekranı
  // (AppBar, legend, hafta günleri başlığı, PageView ve içindeki tüm ay
  // ızgaraları) sürükleme devam ederken yeniden inşa ediyordu — bu da gün
  // ızgarasında hafif bir zıplama/titreme hissi yaratıyordu. ValueNotifier +
  // ValueListenableBuilder kullanarak yalnızca başlık metni izole şekilde
  // güncellenir, geri kalan hiçbir şey sürükleme sırasında yeniden inşa
  // edilmez.
  late final ValueNotifier<DateTime> _focusedMonthNotifier;
  DateTime _selectedDay = DateTime.now();
  final DateTime _today = DateTime.now();

  // 'yyyy-M-d' -> o güne ait NOT işaretleri (tekrar mantığı yok, tek gün).
  Map<String, _DayMarker> _markers = {};
  // Hatırlatıcısı kurulu (kilitli olmayan) notlar. Tekrarlı hatırlatıcılar
  // sabit bir güne değil bir KURALA bağlı olduğundan (örn. "her gün"),
  // sonsuz kaydırılabilen takvimde önceden bir haritaya sığdırılamaz;
  // bunun yerine her hücre çizilirken _reminderOccursOnDay ile o günde
  // devrede olup olmadığı anlık hesaplanır.
  List<Map<String, dynamic>> _reminderNotes = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonthNotifier = ValueNotifier(DateTime(now.year, now.month, 1));
    _pageController = PageController(initialPage: _centerIndex);
    _buildMarkers();
  }

  static String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';

  // Notun ait olduğu günü belirler: kullanıcı not eklerken/düzenlerken
  // takvimden bir tarih seçmişse (assignedDate) o esas alınır; aksi halde
  // notun "oluşturulma" tarihine (createdDate) düşülür.
  DateTime? _noteDay(Map<String, dynamic> note) {
    final rawAssigned = note['assignedDate']?.toString();
    final raw = (rawAssigned != null && rawAssigned.isNotEmpty)
        ? rawAssigned
        : note['createdDate']?.toString();
    if (raw == null || raw.isEmpty) return null;
    final dt = DateTime.tryParse(raw);
    if (dt == null) return null;
    return DateTime(dt.year, dt.month, dt.day);
  }

  void _buildMarkers() {
    final map = <String, _DayMarker>{};
    final reminders = <Map<String, dynamic>>[];
    for (final note in widget.notes) {
      if (note['isLocked'] == true) continue;
      final noteDay = _noteDay(note);
      // Bir notun "ait olduğu gün" (oluşturma/atama) ile o notun kendi
      // hatırlatıcısının tetiklendiği gün ÇAKIŞIYORSA, aynı tek not için
      // hem sarı hem mavi nokta göstermek gereksiz — sanki o günde iki
      // farklı şey varmış izlenimi veriyordu. Bu durumda yalnızca mavi
      // (hatırlatıcı) noktası bırakılır; sarı katkı bu not için atlanır.
      // Başka bir notun o günü zaten sarı işaretlemiş olması bundan
      // etkilenmez (harita OR mantığıyla dolduğu için).
      final ownReminderSameDay =
          noteDay != null && _reminderOccursOnDay(note, noteDay);
      if (noteDay != null && !ownReminderSameDay) {
        final key = _dayKey(noteDay);
        map[key] = (map[key] ?? const _DayMarker()).copyWith(hasNote: true);
      }
      final raw = note['reminderDate']?.toString();
      if (raw != null && raw.isNotEmpty) {
        reminders.add(note);
      }
    }
    _markers = map;
    _reminderNotes = reminders;
  }

  @override
  void didUpdateWidget(covariant CalendarScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.notes, widget.notes)) {
      _buildMarkers();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusedMonthNotifier.dispose();
    super.dispose();
  }

  DateTime _monthForIndex(int index) {
    final diff = index - _centerIndex;
    final now = DateTime.now();
    return DateTime(now.year, now.month + diff, 1);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _goToToday() {
    setState(() {
      _selectedDay = DateTime.now();
    });
    final now = DateTime.now();
    _focusedMonthNotifier.value = DateTime(now.year, now.month, 1);
    _pageController.animateToPage(
      _centerIndex,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.amber),
        title: const Text(
          'Takvim',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.amber,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _goToToday,
            child: const Text(
              'Bugün',
              style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildMonthHeader(),
            _buildLegend(context),
            const SizedBox(height: 4),
            _buildWeekDayHeader(context),
            const SizedBox(height: 4),
            Expanded(
              flex: 6,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  _focusedMonthNotifier.value = _monthForIndex(index);
                },
                itemBuilder: (context, index) {
                  final month = _monthForIndex(index);
                  return _MonthGrid(
                    month: month,
                    today: _today,
                    selectedDay: _selectedDay,
                    markers: _markers,
                    reminderNotes: _reminderNotes,
                    onDaySelected: (day) {
                      setState(() {
                        _selectedDay = day;
                      });
                    },
                  );
                },
              ),
            ),
            Expanded(
              flex: 5,
              child: _buildSelectedDayNotesPanel(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () => widget.onNewNote(_selectedDay),
        child: const Icon(Icons.add, color: Colors.black, size: 30),
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.amber),
            onPressed: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
          ),
          Expanded(
            child: Center(
              child: ValueListenableBuilder<DateTime>(
                valueListenable: _focusedMonthNotifier,
                builder: (context, focusedMonth, _) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                    child: Text(
                      '${_monthNamesTr[focusedMonth.month - 1]} ${focusedMonth.year}',
                      key: ValueKey('${focusedMonth.year}-${focusedMonth.month}'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.amber),
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    final subtleColor = dNoteTextColor(context).withValues(alpha: 0.55);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _MarkerDot(color: Colors.amber),
          const SizedBox(width: 5),
          Text('Not', style: TextStyle(fontSize: 12, color: subtleColor)),
          const SizedBox(width: 14),
          const _MarkerDot(color: Colors.lightBlueAccent),
          const SizedBox(width: 5),
          Text(
            'Hatırlatıcı',
            style: TextStyle(fontSize: 12, color: subtleColor),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDayHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(7, (i) {
          final isSunday = i == 6;
          return Expanded(
            child: Center(
              child: Text(
                _weekDayShortTr[i],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSunday
                      ? Colors.redAccent.withValues(alpha: 0.85)
                      : dNoteTextColor(context).withValues(alpha: 0.55),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Seçili güne ait notları döndürür: o gün oluşturulmuş notlar VE/VEYA
  // o gün için hatırlatıcısı DEVREDE olan notlar (tekrarlı hatırlatıcılarda
  // bu, ilk kurulan gün değil, kurala göre bugün de eşleşen herhangi bir
  // gün olabilir). Kilitli notlar, uygulamanın geri kalanında olduğu gibi
  // burada da gösterilmez (gizlilik).
  List<Map<String, dynamic>> _notesForSelectedDay() {
    final result = <Map<String, dynamic>>[];
    for (final note in widget.notes) {
      if (note['isLocked'] == true) continue;
      final noteDay = _noteDay(note);
      final matchesNote = noteDay != null && _isSameDay(noteDay, _selectedDay);
      final matchesReminder = _reminderOccursOnDay(note, _selectedDay);
      if (matchesNote || matchesReminder) {
        result.add(note);
      }
    }
    result.sort((a, b) {
      // Tekrarlı bir hatırlatıcı bugün eşleşiyorsa, sıralamada notun ilk
      // kurulduğu (muhtemelen geçmiş) tarihi değil, BUGÜNKÜ saatini esas
      // alırız; yoksa oluşturulma tarihine düşülür.
      DateTime timeOf(Map<String, dynamic> n) =>
          _effectiveReminderOn(n, _selectedDay) ??
          DateTime.tryParse((n['createdDate'] ?? '').toString()) ??
          _selectedDay;
      return timeOf(a).compareTo(timeOf(b));
    });
    return result;
  }

  Widget _buildSelectedDayNotesPanel(BuildContext context) {
    final label =
        '${_selectedDay.day} ${_monthNamesTr[_selectedDay.month - 1]} ${_selectedDay.year}, '
        '${_weekDayFullTr[_selectedDay.weekday - 1]}';
    final isToday = _isSameDay(_selectedDay, _today);
    final dayNotes = _notesForSelectedDay();

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      decoration: BoxDecoration(
        color: dNoteCardColor(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: dNoteBorderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.event_note,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: dNoteTextColor(context),
                        ),
                      ),
                      if (isToday)
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Text(
                            'Bugün',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (dayNotes.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: dNoteSurfaceVariant(context),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${dayNotes.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: dNoteTextColor(context),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: dNoteBorderColor(context)),
          Expanded(
            child: dayNotes.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Bu güne ait not veya hatırlatıcı yok.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: dNoteTextColor(context).withValues(alpha: 0.5),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: dayNotes.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: dNoteBorderColor(context),
                    ),
                    itemBuilder: (context, i) {
                      final note = dayNotes[i];
                      return _DayNoteTile(
                        note: note,
                        day: _selectedDay,
                        onTap: () {
                          final id = note['id']?.toString();
                          if (id != null) widget.onOpenNote(id);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Seçili günün not/hatırlatıcı listesindeki tek bir satır ─────────────
class _DayNoteTile extends StatelessWidget {
  final Map<String, dynamic> note;
  final DateTime day;
  final VoidCallback onTap;

  const _DayNoteTile({
    required this.note,
    required this.day,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final rawTitle = note['title']?.toString().trim() ?? '';
    final hasTitle = rawTitle.isNotEmpty;
    final content = ContentBlocks.plainText(note['content'] as String?)
        .replaceAll('\n', ' ')
        .trim();
    final primaryText = hasTitle ? rawTitle : content;

    String? reminderLabel;
    bool isRepeatingOccurrence = false;
    final effectiveReminder = _effectiveReminderOn(note, day);
    if (effectiveReminder != null) {
      final repeat = note['reminderRepeat']?.toString();
      isRepeatingOccurrence = repeat != null && repeat.isNotEmpty;
      if (repeat == 'hourly') {
        // Saatlik tekrarda tek bir saat göstermek yanıltıcı olur (o gün
        // boyunca her saat başı tetiklenir); sabit saat yerine bunu belirtiriz.
        reminderLabel = 'Her saat';
      } else {
        final hh = effectiveReminder.hour.toString().padLeft(2, '0');
        final mm = effectiveReminder.minute.toString().padLeft(2, '0');
        reminderLabel = '$hh:$mm';
      }
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 4,
              height: 34,
              decoration: BoxDecoration(
                color: reminderLabel != null
                    ? Colors.lightBlueAccent
                    : Colors.amber,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: dNoteTextColor(context),
                      ),
                      children: [
                        TextSpan(
                          text: primaryText,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (hasTitle && content.isNotEmpty)
                          TextSpan(
                            text: ' - $content',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: dNoteTextColor(context).withValues(alpha: 0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (reminderLabel != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isRepeatingOccurrence
                          ? Icons.repeat
                          : Icons.notifications,
                      size: 12,
                      color: Colors.lightBlueAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      reminderLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Bir ayın takvim ızgarası (önceki/sonraki aydan taşan günler soluk) ──
class _MonthGrid extends StatelessWidget {
  final DateTime month; // ayın 1. günü
  final DateTime today;
  final DateTime selectedDay;
  final Map<String, _DayMarker> markers;
  // Hatırlatıcısı kurulu notlar; her hücrede _reminderOccursOnDay ile
  // tekrar kuralına göre devrede olup olmadığı kontrol edilir.
  final List<Map<String, dynamic>> reminderNotes;
  final ValueChanged<DateTime> onDaySelected;

  const _MonthGrid({
    required this.month,
    required this.today,
    required this.selectedDay,
    required this.markers,
    required this.reminderNotes,
    required this.onDaySelected,
  });

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final firstWeekday = month.weekday; // Pazartesi=1 ... Pazar=7
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final prevMonthLastDay = DateTime(month.year, month.month, 0).day;

    final leading = firstWeekday - 1; // hafta Pazartesi ile başlar
    final totalCells = ((leading + daysInMonth) / 7).ceil() * 7;

    final cellDates = <_CalDay>[];
    for (int i = 0; i < totalCells; i++) {
      final dayNum = i - leading + 1;
      if (dayNum < 1) {
        final prevMonth = month.month == 1 ? 12 : month.month - 1;
        final prevYear = month.month == 1 ? month.year - 1 : month.year;
        cellDates.add(
          _CalDay(
            DateTime(prevYear, prevMonth, prevMonthLastDay + dayNum),
            false,
          ),
        );
      } else if (dayNum > daysInMonth) {
        final nextMonth = month.month == 12 ? 1 : month.month + 1;
        final nextYear = month.month == 12 ? month.year + 1 : month.year;
        cellDates.add(
          _CalDay(DateTime(nextYear, nextMonth, dayNum - daysInMonth), false),
        );
      } else {
        cellDates.add(_CalDay(DateTime(month.year, month.month, dayNum), true));
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 0.82,
        ),
        itemCount: cellDates.length,
        itemBuilder: (context, index) {
          final cell = cellDates[index];
          final marker =
              markers[_CalendarScreenState._dayKey(cell.date)] ??
                  const _DayMarker();
          final hasReminder = reminderNotes.any(
            (n) => _reminderOccursOnDay(n, cell.date),
          );
          return _DayCellWidget(
            date: cell.date,
            inCurrentMonth: cell.inCurrentMonth,
            isToday: _isSameDay(cell.date, today),
            isSelected: _isSameDay(cell.date, selectedDay),
            hasNote: marker.hasNote,
            hasReminder: hasReminder,
            onTap: () => onDaySelected(cell.date),
          );
        },
      ),
    );
  }
}

class _CalDay {
  final DateTime date;
  final bool inCurrentMonth;
  const _CalDay(this.date, this.inCurrentMonth);
}

// ── Takvimdeki tek bir gün hücresi ───────────────────────────────────────
class _DayCellWidget extends StatelessWidget {
  final DateTime date;
  final bool inCurrentMonth;
  final bool isToday;
  final bool isSelected;
  final bool hasNote;
  final bool hasReminder;
  final VoidCallback onTap;

  const _DayCellWidget({
    required this.date,
    required this.inCurrentMonth,
    required this.isToday,
    required this.isSelected,
    required this.hasNote,
    required this.hasReminder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSunday = date.weekday == DateTime.sunday;

    Color textColor;
    if (isSelected) {
      textColor = Colors.black;
    } else if (!inCurrentMonth) {
      textColor = dNoteTextColor(context).withValues(alpha: 0.25);
    } else if (isSunday) {
      textColor = Colors.redAccent.withValues(alpha: 0.85);
    } else {
      textColor = dNoteTextColor(context);
    }

    // İşaretleyici noktaları: amber = not var, açık mavi = hatırlatıcı var.
    // Seçili günde daire zaten amber olduğu için nokta rengi kontrastlı
    // (koyu) tutulur; diğer durumlarda normal renkler kullanılır.
    final dots = <Widget>[];
    if (hasNote) {
      dots.add(_MarkerDot(color: isSelected ? Colors.black87 : Colors.amber));
    }
    if (hasReminder) {
      if (dots.isNotEmpty) dots.add(const SizedBox(width: 3));
      dots.add(
        _MarkerDot(
          color: isSelected ? Colors.black54 : Colors.lightBlueAccent,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(3),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isSelected ? Colors.amber : Colors.transparent,
                shape: BoxShape.circle,
                border: (isToday && !isSelected)
                    ? Border.all(color: Colors.amber, width: 1.6)
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                '${date.day}',
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: (isToday || isSelected)
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(height: 3),
            SizedBox(
              height: 5,
              child: dots.isEmpty
                  ? null
                  : Row(mainAxisSize: MainAxisSize.min, children: dots),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Gün hücresinin altında görünen küçük renkli işaretleyici nokta ──────
class _MarkerDot extends StatelessWidget {
  final Color color;
  const _MarkerDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
