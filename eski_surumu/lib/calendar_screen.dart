part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// TAKVİM EKRANI (Aşama 1: Yalnızca takvimin kendisi)
// Aylar arasında sağa/sola kaydırarak (PageView) gezinilebilen, "bugün"ü ve
// seçili günü vurgulayan, modern görünümlü bir aylık takvim. Not/hatırlatıcı
// entegrasyonu bir sonraki aşamalarda bu ekranın üzerine eklenecek.
// ════════════════════════════════════════════════════════════════════════
class CalendarScreen extends StatefulWidget {
  final List<Map<String, dynamic>> notes;

  const CalendarScreen({super.key, required this.notes});

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
  late DateTime _focusedMonth; // o an ekranda görünen ayın 1. günü
  DateTime _selectedDay = DateTime.now();
  final DateTime _today = DateTime.now();

  // 'yyyy-M-d' -> o güne ait not/hatırlatıcı işaretleri.
  Map<String, _DayMarker> _markers = {};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month, 1);
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

  // Notun hatırlatıcısının kurulu olduğu gün (varsa).
  DateTime? _reminderDay(Map<String, dynamic> note) {
    final raw = note['reminderDate']?.toString();
    if (raw == null || raw.isEmpty) return null;
    final dt = DateTime.tryParse(raw);
    if (dt == null) return null;
    return DateTime(dt.year, dt.month, dt.day);
  }

  void _buildMarkers() {
    final map = <String, _DayMarker>{};
    for (final note in widget.notes) {
      if (note['isLocked'] == true) continue;
      final noteDay = _noteDay(note);
      if (noteDay != null) {
        final key = _dayKey(noteDay);
        map[key] = (map[key] ?? const _DayMarker()).copyWith(hasNote: true);
      }
      final remDay = _reminderDay(note);
      if (remDay != null) {
        final key = _dayKey(remDay);
        map[key] =
            (map[key] ?? const _DayMarker()).copyWith(hasReminder: true);
      }
    }
    _markers = map;
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
                  setState(() {
                    _focusedMonth = _monthForIndex(index);
                  });
                },
                itemBuilder: (context, index) {
                  final month = _monthForIndex(index);
                  return _MonthGrid(
                    month: month,
                    today: _today,
                    selectedDay: _selectedDay,
                    markers: _markers,
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
              child: AnimatedSwitcher(
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
                  '${_monthNamesTr[_focusedMonth.month - 1]} ${_focusedMonth.year}',
                  key: ValueKey('${_focusedMonth.year}-${_focusedMonth.month}'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
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
          Text('Not', style: TextStyle(fontSize: 11, color: subtleColor)),
          const SizedBox(width: 14),
          const _MarkerDot(color: Colors.lightBlueAccent),
          const SizedBox(width: 5),
          Text(
            'Hatırlatıcı',
            style: TextStyle(fontSize: 11, color: subtleColor),
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
  // o gün için hatırlatıcısı kurulmuş notlar. Kilitli notlar, uygulamanın
  // geri kalanında olduğu gibi burada da gösterilmez (gizlilik).
  List<Map<String, dynamic>> _notesForSelectedDay() {
    final result = <Map<String, dynamic>>[];
    for (final note in widget.notes) {
      if (note['isLocked'] == true) continue;
      final noteDay = _noteDay(note);
      final remDay = _reminderDay(note);
      final matchesNote = noteDay != null && _isSameDay(noteDay, _selectedDay);
      final matchesReminder =
          remDay != null && _isSameDay(remDay, _selectedDay);
      if (matchesNote || matchesReminder) {
        result.add(note);
      }
    }
    result.sort((a, b) {
      DateTime? timeOf(Map<String, dynamic> n) =>
          DateTime.tryParse((n['reminderDate'] ?? n['createdDate'] ?? '').toString());
      final ad = timeOf(a);
      final bd = timeOf(b);
      if (ad == null || bd == null) return 0;
      return ad.compareTo(bd);
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
                        onTap: () =>
                            Navigator.pop(context, note['id']?.toString()),
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

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final rawTitle = note['title']?.toString().trim() ?? '';
    final hasTitle = rawTitle.isNotEmpty;
    final content = ContentBlocks.plainText(note['content'] as String?)
        .replaceAll('\n', ' ')
        .trim();
    final primaryText = hasTitle ? rawTitle : content;

    String? reminderLabel;
    final remRaw = note['reminderDate']?.toString();
    if (remRaw != null && remRaw.isNotEmpty) {
      final remDt = DateTime.tryParse(remRaw);
      if (remDt != null && _isSameDay(remDt, day)) {
        final hh = remDt.hour.toString().padLeft(2, '0');
        final mm = remDt.minute.toString().padLeft(2, '0');
        reminderLabel = '$hh:$mm';
      }
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 34,
              margin: const EdgeInsets.only(top: 2),
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
                  Text(
                    primaryText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: dNoteTextColor(context),
                    ),
                  ),
                  if (hasTitle && content.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: dNoteTextColor(context).withValues(alpha: 0.55),
                        ),
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
                    const Icon(
                      Icons.notifications,
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
  final ValueChanged<DateTime> onDaySelected;

  const _MonthGrid({
    required this.month,
    required this.today,
    required this.selectedDay,
    required this.markers,
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
          return _DayCellWidget(
            date: cell.date,
            inCurrentMonth: cell.inCurrentMonth,
            isToday: _isSameDay(cell.date, today),
            isSelected: _isSameDay(cell.date, selectedDay),
            hasNote: marker.hasNote,
            hasReminder: marker.hasReminder,
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
