part of 'main.dart';

// ignore_for_file: unused_element

// _pickCalendarDate'in showClearOption:true modunda "İptal" (atamayı
// kaldır) butonuna basıldığını işaretlemek için kullanılan sentinel değer.
// Gerçek bir seçili tarih asla bu değere eşit olmayacağı için çağıran
// taraf bunu normal bir tarih seçiminden (ya da Vazgeç'in döndürdüğü
// null'dan) güvenle ayırt edebilir.
final DateTime _clearAssignedDateSentinel = DateTime.utc(1, 1, 1);

mixin NoteListAttachmentMixin on State<NoteListScreen> {

  // ── Ek (fotoğraf/belge) IZGARASI ────────────────────────────────────────
  // Tek ek varsa tam genişlikte, 2+ ek varsa 2 sütunlu ızgara (grid) olarak
  // gösterilir. Aralarında çok az boşluk bırakılır. Hem not düzenleme
  // ekranındaki metin içi eklerde, hem de kontrol listesi (checklist)
  // eklerinde kullanılır.
  // ── PDF ilk sayfa küçük resmi (thumbnail) ──────────────────────────────
  // Aynı dosya için tekrar tekrar render etmemek için sonuçlar bellekte
  // (uygulama açıkken) önbelleğe alınır.
  final Map<String, Uint8List> _pdfThumbCache = {};

  Future<Uint8List?> _getPdfThumbnail(String filePath) async {
    if (_pdfThumbCache.containsKey(filePath)) {
      return _pdfThumbCache[filePath];
    }
    PdfDocument? doc;
    PdfPage? page;
    try {
      doc = await PdfDocument.openFile(filePath);
      page = await doc.getPage(1);
      final image = await page.render(
        width: page.width * 1.6,
        height: page.height * 1.6,
        format: PdfPageImageFormat.jpeg,
        backgroundColor: '#FFFFFF',
      );
      if (image != null) {
        _pdfThumbCache[filePath] = image.bytes;
        return image.bytes;
      }
    } catch (_) {
      // PDF açılamadı/bozuk -> yedek (fallback) ikon gösterilecek.
    } finally {
      await page?.close();
      await doc?.close();
    }
    return null;
  }

  // Görsel olmayan eklerin türüne göre önizlemesi: PDF için gerçek ilk
  // sayfa küçük resmi, XLSX/XLS için belirgin yeşil tablo ikonu, diğer
  // dosya türleri için genel amber belge ikonu.
  Widget _buildDocPreview(Map<String, dynamic> att, String filePath) {
    final fileName = (att['fileName'] ?? '').toString();
    final ext = p.extension(fileName).toLowerCase();

    if (ext == '.pdf') {
      return FutureBuilder<Uint8List?>(
        future: _getPdfThumbnail(filePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.memory(snapshot.data!, fit: BoxFit.cover),
                Positioned(
                  left: 4,
                  bottom: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'PDF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return _docFallback(fileName, Icons.picture_as_pdf, Colors.red.shade400);
        },
      );
    }

    if (ext == '.xlsx' || ext == '.xls') {
      return _docFallback(fileName, Icons.table_chart, Colors.green.shade400);
    }

    if (att['isVideo'] == true) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.black87),
          const Center(
            child: Icon(
              Icons.play_circle_fill,
              color: Colors.white,
              size: 34,
            ),
          ),
        ],
      );
    }

    if (att['isAudio'] == true) {
      return _docFallback(
        fileName,
        Icons.mic,
        Colors.deepPurpleAccent,
      );
    }

    return _docFallback(fileName, Icons.insert_drive_file_outlined, appAccentColor.value);
  }

  Widget _docFallback(String fileName, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(
            fileName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentGrid({
    required List<String> ids,
    required List<Map<String, dynamic>> attachmentsList,
    required void Function(String id) onRemove,
    required void Function(Map<String, dynamic> att) onOpen,
    required String? deletingId,
    required void Function(String? id) onDeletingIdChanged,
  }) {
    final items = ids
        .map(
          (id) => attachmentsList.firstWhere(
            (a) => a['id'] == id,
            orElse: () => <String, dynamic>{},
          ),
        )
        .where((a) => a.isNotEmpty)
        .toList();
    if (items.isEmpty) return const SizedBox.shrink();

    return FutureBuilder<String>(
      future: DBHelper.instance.attachmentsDir().then((d) => d.path),
      builder: (context, snapshot) {
        final dirPath = snapshot.data;
        if (dirPath == null) return const SizedBox.shrink();
        return LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 4.0;
            final singleFull = items.length == 1;
            final itemWidth = singleFull
                ? constraints.maxWidth
                : (constraints.maxWidth - spacing) / 2;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: items.map((att) {
                final isImage = att['isImage'] == true;
                final filePath = p.join(dirPath, att['storedName'].toString());
                final preview = isImage
                    ? Image.file(
                        File(filePath),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey,
                        ),
                      )
                    : _buildDocPreview(att, filePath);
                return _AttachmentTile(
                  width: itemWidth,
                  height: singleFull ? 220 : itemWidth,
                  preview: preview,
                  showDelete: deletingId == att['id'].toString(),
                  onOpen: () => onOpen(att),
                  onRemove: () => onRemove(att['id'].toString()),
                  onLongPress: () => onDeletingIdChanged(att['id'].toString()),
                  onDismissDelete: () => onDeletingIdChanged(null),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  // Uygulama genelinde tek tip görünen takvim popup'ı (buton yazıları ve
  // başlık her yerde aynı olsun diye ortaklaştırıldı). Yalnızca seçilebilir
  // tarih aralığı (firstDate/lastDate) ve başlık (helpText) çağıran yere
  // göre değişir; alarm için "bugünden sonrası", not atama için "her tarih"
  // gibi farklı kısıtlar dışarıdan verilir.
  //
  // showClearOption: true verilirse (yalnızca not atama akışında, zaten
  // atanmış bir tarih varken kullanılır), standart showDatePicker yerine
  // aynı görünümü elle kuran özel bir dialog açılır; bu dialogda "Vazgeç"in
  // SOLUNA "İptal" (atamayı kaldır) butonu eklenir. İptal'a basılırsa
  // dönüş değeri _clearAssignedDateSentinel olur — çağıran taraf bunu
  // normal bir tarih seçiminden ayırt edip atamayı kaldırmalıdır. Vazgeç'e
  // basılırsa (ya da dialog dışına dokunulursa) null döner, hiçbir şey
  // değişmez — bu, showClearOption:false durumundaki mevcut sözleşmeyle
  // birebir aynıdır.
  Future<DateTime?> _pickCalendarDate({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required String helpText,
    bool showClearOption = false,
  }) {
    if (!showClearOption) {
      return showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        helpText: helpText,
        cancelText: AppLocalizations.of(context)!.calendarPickerCancelButton,
        confirmText: AppLocalizations.of(context)!.calendarPickerConfirmButton,
        builder: (context, child) {
          final base = Theme.of(context);
          return Theme(
            data: base.copyWith(
              colorScheme: base.colorScheme.copyWith(
                primary: appAccentColor.value,
              ),
            ),
            child: child!,
          );
        },
      );
    }

    DateTime selected = initialDate;
    return showDialog<DateTime?>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          child: SizedBox(
            width: 328,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      helpText,
                      style: TextStyle(
                        color: dNoteTextColor(dialogContext),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Theme(
                  data: Theme.of(dialogContext).copyWith(
                    colorScheme: Theme.of(dialogContext).colorScheme.copyWith(
                      primary: appAccentColor.value,
                    ),
                  ),
                  child: CalendarDatePicker(
                    initialDate: initialDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    onDateChanged: (d) => selected = d,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(
                          dialogContext,
                          _clearAssignedDateSentinel,
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: appAccentColor.value,
                        ),
                        child: Text(
                          AppLocalizations.of(dialogContext)!.calendarPickerClearButton,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext, null),
                        style: TextButton.styleFrom(
                          foregroundColor: appAccentColor.value,
                        ),
                        child: Text(
                          AppLocalizations.of(dialogContext)!.calendarPickerCancelButton,
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(dialogContext, selected),
                        style: TextButton.styleFrom(
                          foregroundColor: appAccentColor.value,
                        ),
                        child: Text(
                          AppLocalizations.of(dialogContext)!.calendarPickerConfirmButton,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Hatırlatıcı ekleme/düzenleme dialogu. Sistemin "Hatırlatıcı ekle"
  // penceresiyle aynı düzeni kullanır: üstte tarih satırı (dokununca
  // Bugün / Yarın / Tarih seç açılır menüsü), altında saat satırı
  // (dokununca doğrudan saat seçici açılır), en altta tekrar satırı
  // (Tekrar yok / Her saat / Her gün / Her hafta / Her ay / Her yıl).
  // Tüm seçimler tek bir dialog içinde yapılır, İPTAL/KAYDET ile kapanır.
  // Not düzenleyicisinde hatırlatıcı ikonu/tarihine dokununca açılan panel;
  // mevcut hatırlatıcıyı düzenleme veya kaldırma seçeneği sunar.
  Future<void> _handleReminderRowTap({
    required BuildContext context,
    required DateTime? currentReminder,
    required String? currentRepeat,
    required void Function(DateTime? reminder, String? repeat) onChanged,
  }) async {
    final now = DateTime.now();
    final initialDate = currentReminder ?? now.add(const Duration(hours: 1));

    if (currentReminder != null) {
      final sheetAction = await showModalBottomSheet<String>(
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
                leading: const Icon(Icons.edit_calendar, color: Colors.blue),
                title: Text(
                  AppLocalizations.of(sheetCtx)!.reminderEditOptionLabel,
                ),
                onTap: () => Navigator.pop(sheetCtx, 'edit'),
              ),
              ListTile(
                leading: const Icon(
                  Icons.notifications_off,
                  color: Colors.redAccent,
                ),
                title: Text(
                  AppLocalizations.of(sheetCtx)!.reminderRemoveOptionLabel,
                ),
                onTap: () => Navigator.pop(sheetCtx, 'remove'),
              ),
            ],
          ),
        ),
      );
      if (sheetAction == 'remove') {
        onChanged(null, null);
        return;
      } else if (sheetAction != 'edit') {
        return;
      }
    }

    if (!context.mounted) return;
    final result = await _showReminderPickerDialog(
      context: context,
      initialDateTime: initialDate.isBefore(now) ? now : initialDate,
      initialRepeat: currentRepeat,
    );
    if (result == null) return;
    onChanged(result.dateTime, result.repeat);
  }

  Future<_ReminderPickResult?> _showReminderPickerDialog({
    required BuildContext context,
    required DateTime initialDateTime,
    String? initialRepeat,
  }) {
    DateTime selectedDate = DateTime(
      initialDateTime.year,
      initialDateTime.month,
      initialDateTime.day,
    );
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(initialDateTime);
    String? selectedRepeat = initialRepeat;

    return showDialog<_ReminderPickResult>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDlgState) {
            final subtleColor = dNoteTextColor(context).withValues(alpha: 0.65);
            final dividerColor = dNoteTextColor(context).withValues(alpha: 0.12);

            Widget dropdownRow({
              required IconData icon,
              required String label,
              required List<PopupMenuEntry<String>> items,
              required void Function(String value) onSelected,
            }) {
              return PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                position: PopupMenuPosition.under,
                color: dNoteCardColor(context),
                onSelected: onSelected,
                itemBuilder: (_) => items,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      Icon(icon, size: 22, color: subtleColor),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 16,
                            color: dNoteTextColor(context),
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: subtleColor),
                    ],
                  ),
                ),
              );
            }

            return Dialog(
              backgroundColor: dNoteCardColor(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.reminderPickerDialogTitle,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: dNoteTextColor(context),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Tarih satırı: Bugün / Yarın / Tarih seç.
                    dropdownRow(
                      icon: Icons.calendar_today_outlined,
                      label: _reminderDateLabelTr(context, selectedDate),
                      items: [
                        PopupMenuItem(
                          value: 'today',
                          child: Text(
                            AppLocalizations.of(context)!.reminderPickerDateTodayOption,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'tomorrow',
                          child: Text(
                            AppLocalizations.of(context)!.reminderPickerDateTomorrowOption,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'pick',
                          child: Text(
                            AppLocalizations.of(context)!.reminderPickerDatePickOption,
                          ),
                        ),
                      ],
                      onSelected: (value) async {
                        final now = DateTime.now();
                        final today = DateTime(now.year, now.month, now.day);
                        if (value == 'today') {
                          setDlgState(() => selectedDate = today);
                        } else if (value == 'tomorrow') {
                          setDlgState(
                            () => selectedDate =
                                today.add(const Duration(days: 1)),
                          );
                        } else if (value == 'pick') {
                          final picked = await _pickCalendarDate(
                            context: context,
                            initialDate: selectedDate.isBefore(today)
                                ? today
                                : selectedDate,
                            firstDate: today,
                            lastDate: now.add(const Duration(days: 3650)),
                            helpText: AppLocalizations.of(context)!.reminderPickerCalendarHelpText,
                          );
                          if (picked != null) {
                            setDlgState(
                              () => selectedDate = DateTime(
                                picked.year,
                                picked.month,
                                picked.day,
                              ),
                            );
                          }
                        }
                      },
                    ),
                    Divider(height: 1, color: dividerColor),
                    // Saat satırı: dokununca doğrudan saat seçici açılır.
                    InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null) {
                          setDlgState(() => selectedTime = picked);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 22,
                              color: subtleColor,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                selectedTime.format(context),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: dNoteTextColor(context),
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: subtleColor),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 1, color: dividerColor),
                    // Tekrar satırı: Tekrar yok / Her saat / Her gün /
                    // Her hafta / Her ay / Her yıl.
                    dropdownRow(
                      icon: Icons.repeat,
                      label: _reminderRepeatLabelTr(context, selectedRepeat),
                      items: [
                        PopupMenuItem(
                          value: 'none',
                          child: Text(
                            AppLocalizations.of(context)!.reminderRepeatNoneLabel,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'hourly',
                          child: Text(
                            AppLocalizations.of(context)!.reminderRepeatHourlyLabel,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'daily',
                          child: Text(
                            AppLocalizations.of(context)!.reminderRepeatDailyLabel,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'weekly',
                          child: Text(
                            AppLocalizations.of(context)!.reminderRepeatWeeklyLabel,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'monthly',
                          child: Text(
                            AppLocalizations.of(context)!.reminderRepeatMonthlyLabel,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'yearly',
                          child: Text(
                            AppLocalizations.of(context)!.reminderRepeatYearlyLabel,
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        setDlgState(
                          () => selectedRepeat = value == 'none'
                              ? null
                              : value,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(
                            AppLocalizations.of(context)!.reminderPickerCancelButton,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            final combined = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                            if (selectedRepeat == null &&
                                combined.isBefore(DateTime.now())) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(context)!.reminderPickerPastTimeErrorMessage,
                                  ),
                                ),
                              );
                              return;
                            }
                            Navigator.pop(
                              dialogContext,
                              _ReminderPickResult(combined, selectedRepeat),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.reminderPickerSaveButton,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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
}
