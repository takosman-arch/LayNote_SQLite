// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'غامق';

  @override
  String get toolbarItalicTooltip => 'مائل';

  @override
  String get toolbarUnderlineTooltip => 'تسطير';

  @override
  String get toolbarStrikethroughTooltip => 'يتوسطه خط';

  @override
  String get toolbarFontSizeTooltip => 'حجم الخط';

  @override
  String get toolbarColorTooltip => 'لون النص';

  @override
  String get toolbarBulletTooltip => 'قائمة نقطية';

  @override
  String get toolbarNumberTooltip => 'قائمة مرقمة';

  @override
  String get toolbarIndentTooltip => 'إزاحة الفقرة';

  @override
  String get toolbarLinkTooltip => 'إضافة / تعديل / إزالة رابط';

  @override
  String get toolbarDividerTooltip => 'إدراج فاصل';

  @override
  String get toolbarChecklistTooltip => 'إضافة قائمة مهام';

  @override
  String get linkSelectTextSnackbar => 'حدد النص الذي تريد ربطه أولاً';

  @override
  String get linkDialogEditTitle => 'تعديل الرابط';

  @override
  String get linkDialogAddTitle => 'إضافة رابط';

  @override
  String get linkDialogRemoveButton => 'إزالة الرابط';

  @override
  String get linkDialogCancelButton => 'إلغاء';

  @override
  String get linkDialogConfirmButton => 'إضافة';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'تم رفض إذن الكاميرا. يجب السماح به من الإعدادات لتسجيل الفيديو.';

  @override
  String get cameraPermissionRequiredMessage =>
      'إذن الكاميرا مطلوب لتسجيل الفيديو.';

  @override
  String get openSettingsButtonLabel => 'الإعدادات';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'تعذر بدء المسح: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'فشل التعرف على النص: $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'لم يتم العثور على نص قابل للقراءة في المستند';

  @override
  String get scanResultSheetTitle => 'كيف تريد إضافة المستند الممسوح؟';

  @override
  String get scanResultTextOnlyOption => 'إضافة كنص فقط';

  @override
  String get scanResultTextAndImageOption => 'إضافة النص + الصورة الممسوحة';

  @override
  String get scanResultCancelOption => 'إلغاء';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'تم رفض إذن الميكروفون. يجب السماح به من الإعدادات لتسجيل الصوت.';

  @override
  String get audioPermissionRequiredMessage =>
      'إذن الميكروفون مطلوب لتسجيل الصوت.';

  @override
  String get voiceRecordingDefaultLabel => 'تسجيل صوتي';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'قائمة حسابية ($count صفوف)';
  }

  @override
  String blockPreviewTableLabel(int count) {
    return 'جدول ($count صفوف)';
  }

  @override
  String get blockPreviewDrawingLabel => 'رسم';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count مرفقات (صورة/مستند)';
  }

  @override
  String get blockPreviewDividerLabel => 'فاصل';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'قائمة مهام ($count عناصر)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(نص فارغ)';

  @override
  String get reorderBlocksSheetTitle => 'إعادة ترتيب العناصر';

  @override
  String get reorderBlocksMoveUpTooltip => 'تحريك لأعلى';

  @override
  String get reorderBlocksMoveDownTooltip => 'تحريك لأسفل';

  @override
  String get reorderBlocksCloseTooltip => 'إغلاق';

  @override
  String get reorderBlocksDescription =>
      'اضغط على عنصر لتحديده، ثم استخدم سهمي الأعلى/الأسفل لتحريكه.';

  @override
  String get reorderBlocksMenuItemLabel => 'إعادة ترتيب';

  @override
  String get txtImportPickerDialogTitle => 'اختر ملف TXT لاستيراده';

  @override
  String get txtImportReadFailedMessage => 'تعذر قراءة ملف TXT';

  @override
  String get txtImportEmptyFileMessage => 'ملف TXT فارغ';

  @override
  String get txtImportSuccessMessage => 'تم استيراد TXT';

  @override
  String get txtImportMenuItemLabel => 'استيراد (txt)';

  @override
  String get exportMenuItemLabel => 'تصدير';

  @override
  String get editorUndoTooltip => 'تراجع';

  @override
  String get editorRedoTooltip => 'إعادة';

  @override
  String get noteSavedMessage => 'تم حفظ الملاحظة';

  @override
  String get dateAssignPickerHelpText => 'تعيين الملاحظة ليوم معين';

  @override
  String get dateAssignChangeOption => 'تغيير التاريخ';

  @override
  String get dateAssignRemoveOption => 'إزالة التعيين';

  @override
  String get editorSubToolbarCloseTooltip => 'إغلاق';

  @override
  String get titleFieldHint => 'العنوان';

  @override
  String get textBlockHint => 'اكتب ملاحظتك هنا...';

  @override
  String get drawingBoardMenuItemLabel => 'لوحة الرسم';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'التحويل من الصوت إلى النص متاح فقط للملاحظات النصية';

  @override
  String get selectionModeCancelTooltip => 'إلغاء التحديد';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return 'تم تحديد $count';
  }

  @override
  String get selectionModeDeleteTooltip => 'حذف';

  @override
  String get selectionModeArchiveTooltip => 'أرشفة';

  @override
  String get selectionModeFolderTooltip => 'مجلد';

  @override
  String get searchFieldHint => 'بحث في الملاحظات...';

  @override
  String get emptyTrashDialogTitle => 'إفراغ سلة المهملات';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'سيتم حذف جميع الملاحظات المحذوفة نهائيًا. هل أنت متأكد؟';

  @override
  String get emptyTrashDialogCancelButton => 'إلغاء';

  @override
  String get restoreAllMenuItemLabel => 'استعادة الكل';

  @override
  String get sortMenuTooltip => 'ترتيب الملاحظات';

  @override
  String get sortMenuAscendingLabel => 'الترتيب: تصاعدي (أ-ي)';

  @override
  String get sortMenuDescendingLabel => 'الترتيب: تنازلي (ي-أ)';

  @override
  String get sortMenuByTitleLabel => 'ترتيب حسب: العنوان';

  @override
  String get sortMenuByModifiedDateLabel => 'ترتيب حسب: آخر تعديل';

  @override
  String get sortMenuByCreatedDateLabel => 'ترتيب حسب: تاريخ الإنشاء';

  @override
  String get sortMenuByFolderLabel => 'ترتيب حسب: المجلد';

  @override
  String get viewToggleGridTooltip => 'عرض شبكي';

  @override
  String get viewToggleListTooltip => 'عرض قائمة';

  @override
  String get drawerHeaderSubtitle => 'دفترك الشخصي';

  @override
  String get drawerNotesSectionHeader => 'الملاحظات';

  @override
  String get drawerAllNotesLabel => 'الملاحظات';

  @override
  String get drawerFavoritesLabel => 'المفضلة';

  @override
  String get drawerAgendaLabel => 'الأجندة';

  @override
  String get drawerRemindersLabel => 'التذكير';

  @override
  String get drawerLockedLabel => 'مقفلة';

  @override
  String get drawerTrashLabel => 'سلة المهملات';

  @override
  String get drawerPlanningSectionHeader => 'التخطيط';

  @override
  String get drawerFoldersSectionHeader => 'المجلدات';

  @override
  String get drawerExpandLabel => 'توسيع';

  @override
  String get drawerCollapseLabel => 'طي';

  @override
  String get drawerAddFolderLabel => 'إضافة مجلد';

  @override
  String get drawerAppSectionHeader => 'التطبيق';

  @override
  String get drawerCalendarLabel => 'التقويم';

  @override
  String get drawerSettingsLabel => 'الإعدادات';

  @override
  String get drawerBackupRestoreLabel => 'النسخ الاحتياطي والاستعادة';

  @override
  String get drawerUpgradeToProLabel => 'الترقية إلى Pro';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'دعم التطوير';

  @override
  String get drawerFeedbackLabel => 'ملاحظات وآراء';

  @override
  String get drawerRateAppLabel => 'قيّم التطبيق';

  @override
  String get drawerAboutLabel => 'حول التطبيق';

  @override
  String get noNotesFoundMessage => 'لم يتم العثور على ملاحظات.';

  @override
  String get trashRestoreButtonLabel => 'استعادة';

  @override
  String get trashPermanentDeleteButtonLabel => 'حذف نهائي';

  @override
  String get tagRenamedInfoMessage => 'تمت إعادة تسمية الوسم';

  @override
  String get tagDeletedInfoMessage => 'تم حذف الوسم';

  @override
  String get tagOptionsRenameLabel => 'إعادة تسمية';

  @override
  String get tagOptionsDeleteLabel => 'حذف';

  @override
  String get renameTagDialogTitle => 'إعادة تسمية الوسم';

  @override
  String get renameTagDialogHint => 'اسم الوسم الجديد';

  @override
  String get renameTagDialogCancelButton => 'إلغاء';

  @override
  String get renameTagDialogSaveButton => 'حفظ';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return 'سيتم إزالة \"$tag\" من $affectedCount ملاحظة. هل تريد المتابعة؟';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'هل تريد حذف الوسم \"$tag\"؟';
  }

  @override
  String get deleteTagDialogTitle => 'حذف الوسم';

  @override
  String get deleteTagDialogCancelButton => 'إلغاء';

  @override
  String get deleteTagDialogConfirmButton => 'حذف';

  @override
  String get tagsSheetTitle => 'الوسوم';

  @override
  String get tagsSheetEmptyMessage => 'لا توجد وسوم على هذه الملاحظة بعد.';

  @override
  String get tagsSheetInputHint => 'اكتب وسمًا جديدًا...';

  @override
  String get tagsSheetSuggestionsLabel => 'الوسوم الحالية';

  @override
  String get noteDeletedInfoMessage => 'تم حذف الملاحظة';

  @override
  String get noteDeletedUndoActionLabel => 'تراجع';

  @override
  String get reminderSetInfoMessage => 'تم تعيين التذكير';

  @override
  String get reminderRemovedInfoMessage => 'تمت إزالة التذكير';

  @override
  String get noteDuplicatedInfoMessage => 'تم إنشاء نسخة';

  @override
  String get speechTextAppendedInfoMessage => 'تمت إضافة النص إلى الملاحظة';

  @override
  String get pdfPreparingInfoMessage => 'جارٍ تجهيز PDF…';

  @override
  String get pdfSavedInfoMessage => 'تم حفظ PDF';

  @override
  String get pdfPreviewSaveActionLabel => 'حفظ';

  @override
  String get jpgPreparingInfoMessage => 'جارٍ تجهيز JPG…';

  @override
  String get jpgSavedInfoMessage => 'تم حفظ JPG';

  @override
  String get jpgFailedInfoMessage => 'تعذر إنشاء JPG';

  @override
  String get txtPreparingInfoMessage => 'جارٍ تجهيز TXT…';

  @override
  String get txtSavedInfoMessage => 'تم حفظ TXT';

  @override
  String get txtFailedInfoMessage => 'تعذر إنشاء TXT';

  @override
  String get exportOpenActionLabel => 'فتح';

  @override
  String get wrongPasswordInfoMessage => 'كلمة المرور خاطئة.';

  @override
  String get noteArchivedInfoMessage => 'تمت أرشفة الملاحظة';

  @override
  String get noteUnarchivedInfoMessage => 'تمت الإزالة من الأرشيف';

  @override
  String get noteUnlockedInfoMessage => 'تم إلغاء القفل';

  @override
  String get noteLockedInfoMessage => 'تم قفل الملاحظة';

  @override
  String get notificationUnpinnedInfoMessage => 'تم إلغاء التثبيت';

  @override
  String get emptyNotePinBlockedInfoMessage => 'لا يمكن تثبيت ملاحظة فارغة.';

  @override
  String get notificationPinnedInfoMessage => 'تم التثبيت في لوحة الإشعارات';

  @override
  String get noContentToReadInfoMessage => 'لا يوجد محتوى لقراءته';

  @override
  String get backPressExitInfoMessage => 'اضغط رجوع مرة أخرى للخروج';

  @override
  String get reminderChannelName => 'تذكيرات الملاحظات';

  @override
  String get reminderChannelDescription => 'تذكيرات الملاحظات في تطبيق Layout';

  @override
  String get pinnedChannelName => 'الملاحظات المثبتة';

  @override
  String get pinnedChannelDescription =>
      'ملاحظات Layout المثبتة في لوحة الإشعارات';

  @override
  String get notificationUnpinActionLabel => 'إزالة';

  @override
  String get reminderDefaultTitle => 'تذكير';

  @override
  String get reminderChecklistBodyFallback => 'لا تنسَ مراجعة قائمة مهامك';

  @override
  String get reminderTextBodyFallback => 'لا تنسَ مراجعة ملاحظتك';

  @override
  String get pdfSaveDialogTitle => 'حفظ كملف PDF';

  @override
  String get jpgSaveDialogTitle => 'حفظ كملف JPG';

  @override
  String get txtSaveDialogTitle => 'حفظ كملف TXT';

  @override
  String get textSizeSheetTitle => 'حجم النص';

  @override
  String get textSizeSamplePreview => 'نص تجريبي';

  @override
  String get textSizeCancelButton => 'إلغاء';

  @override
  String get textSizeApplyButton => 'تطبيق';

  @override
  String get createPasswordDialogTitle => 'إنشاء كلمة مرور';

  @override
  String get createPasswordNewPasswordHint => 'كلمة مرور جديدة';

  @override
  String get createPasswordConfirmHint => 'إعادة إدخال كلمة المرور';

  @override
  String get createPasswordHintQuestionDescription =>
      'عيّن سؤال أمان في حال نسيت كلمة المرور (اختياري).';

  @override
  String get createPasswordHintQuestionHint => 'اختر سؤال أمان';

  @override
  String get createPasswordHintAnswerHint => 'إجابتك';

  @override
  String get createPasswordCancelButton => 'إلغاء';

  @override
  String get createPasswordSaveButton => 'حفظ';

  @override
  String get passwordMismatchMessage => 'كلمتا المرور غير متطابقتين!';

  @override
  String get passwordRequiredDialogTitle => 'كلمة المرور مطلوبة';

  @override
  String get passwordRequiredHint => 'أدخل كلمة المرور';

  @override
  String get forgotPasswordButtonLabel => 'نسيت كلمة المرور';

  @override
  String get passwordRequiredCancelButton => 'إلغاء';

  @override
  String get passwordRequiredConfirmButton => 'تحقق';

  @override
  String get securityQuestionDialogTitle => 'سؤال الأمان';

  @override
  String get securityQuestionAnswerHint => 'إجابتك';

  @override
  String get securityQuestionCancelButton => 'إلغاء';

  @override
  String get securityQuestionConfirmButton => 'تأكيد';

  @override
  String get securityQuestionWrongAnswerMessage =>
      'إجابة خاطئة. حاول مرة أخرى.';

  @override
  String get revealedPasswordDialogTitle => 'كلمة المرور الخاصة بك';

  @override
  String get revealedPasswordLabel => 'كلمة مرور ملاحظتك:';

  @override
  String get revealedPasswordOkButton => 'موافق';

  @override
  String get securityQuestionPetName => 'ما اسم حيوانك الأليف الأول؟';

  @override
  String get securityQuestionFavoriteTeacher => 'ما اسم معلمك المفضل؟';

  @override
  String get securityQuestionBirthCity => 'في أي مدينة وُلدت؟';

  @override
  String get securityQuestionFavoriteFood => 'ما هو طعامك المفضل؟';

  @override
  String get securityQuestionMotherMaidenName =>
      'ما هو اسم عائلة والدتك قبل الزواج؟';

  @override
  String get securityQuestionFirstSchool => 'ما اسم أول مدرسة التحقت بها؟';

  @override
  String get securityQuestionFavoriteColor => 'ما هو لونك المفضل؟';

  @override
  String get editFolderDialogTitle => 'تعديل المجلد';

  @override
  String get newSubfolderDialogTitle => 'مجلد فرعي جديد';

  @override
  String get addFolderDialogTitle => 'إضافة مجلد';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'سيتم إنشاؤه داخل \"$parentCategory\"';
  }

  @override
  String get subfolderNameFieldLabel => 'اسم المجلد الفرعي';

  @override
  String get folderNameFieldLabel => 'اسم المجلد';

  @override
  String get folderColorLabel => 'اللون';

  @override
  String get folderDialogCancelButton => 'إلغاء';

  @override
  String get folderDialogSaveButton => 'حفظ';

  @override
  String get folderDialogAddButton => 'إضافة';

  @override
  String get selectFolderSheetTitle => 'اختيار مجلد';

  @override
  String get selectFolderAddOptionLabel => 'إضافة مجلد';

  @override
  String get removeCurrentFolderLabel => 'إزالة المجلد الحالي';

  @override
  String get noteDetailsDialogTitle => 'التفاصيل';

  @override
  String get noteDetailsCreatedLabel => 'تاريخ الإنشاء';

  @override
  String get noteDetailsModifiedLabel => 'آخر تعديل';

  @override
  String get noteDetailsCharCountLabel => 'عدد الأحرف';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count حرفًا';
  }

  @override
  String get noteDetailsWordCountLabel => 'عدد الكلمات';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count كلمة';
  }

  @override
  String get noteDetailsOkButton => 'موافق';

  @override
  String get noteDetailsUnknownDateLabel => 'غير معروف';

  @override
  String get addAttachmentSheetTitle => 'إضافة';

  @override
  String get addAttachmentImageOption => 'إضافة صورة';

  @override
  String get addAttachmentCameraOption => 'الكاميرا';

  @override
  String get addAttachmentFileOption => 'إضافة ملف';

  @override
  String get addAttachmentVoiceOption => 'تسجيل صوتي';

  @override
  String get addAttachmentVideoOption => 'تسجيل فيديو';

  @override
  String get addAttachmentScanOption => 'مسح مستند';

  @override
  String get noteActionsSheetTitle => 'اختر إجراءً';

  @override
  String get noteActionReminderLabel => 'تذكير';

  @override
  String get noteActionEditReminderLabel => 'تعديل التذكير';

  @override
  String get noteActionSpeechToTextLabel => 'تحويل الكلام إلى نص';

  @override
  String get noteActionArchiveLabel => 'أرشفة';

  @override
  String get noteActionUnarchiveLabel => 'إزالة من الأرشيف';

  @override
  String get noteActionLockLabel => 'قفل';

  @override
  String get noteActionUnlockLabel => 'إلغاء القفل';

  @override
  String get noteActionFavoriteLabel => 'إضافة إلى المفضلة';

  @override
  String get noteActionUnfavoriteLabel => 'إزالة من المفضلة';

  @override
  String get noteActionClassifyLabel => 'اختيار مجلد';

  @override
  String get noteActionDeleteLabel => 'حذف';

  @override
  String get noteActionPinToNotificationLabel => 'تثبيت في لوحة الإشعارات';

  @override
  String get noteActionUnpinFromNotificationLabel => 'إزالة التثبيت';

  @override
  String get noteActionShareLabel => 'مشاركة';

  @override
  String get noteActionDuplicateLabel => 'إنشاء نسخة';

  @override
  String get noteActionCopyContentLabel => 'نسخ المحتوى';

  @override
  String get noteActionTtsLabel => 'قراءة بصوت عالٍ';

  @override
  String get noteActionTextSizeLabel => 'حجم النص';

  @override
  String get noteActionDetailsLabel => 'التفاصيل';

  @override
  String get noteActionDiscardChangesLabel => 'تجاهل التغييرات';

  @override
  String get noteActionSelectLabel => 'تحديد';

  @override
  String get reminderEditOptionLabel => 'تغيير التذكير';

  @override
  String get reminderRemoveOptionLabel => 'إزالة التذكير';

  @override
  String get discardChangesDialogTitle => 'تجاهل التغييرات';

  @override
  String get discardChangesDialogMessage =>
      'ستُفقد التغييرات غير المحفوظة في هذه الملاحظة. هل أنت متأكد أنك تريد تجاهلها؟';

  @override
  String get discardChangesCancelButton => 'إلغاء';

  @override
  String get discardChangesConfirmButton => 'تجاهل';

  @override
  String get pinnedNotificationDefaultTitle => 'ملاحظة';

  @override
  String get pdfFailedInfoMessage => 'فشل إنشاء PDF';

  @override
  String get drawingScreenTitle => 'رسم';

  @override
  String get drawingMinimizeTooltip => 'تصغير';

  @override
  String get drawingEmptyExportWarningMessage => 'ارسم شيئًا أولاً';

  @override
  String get drawingEraserPartialModeLabel => 'جزئي';

  @override
  String get drawingEraserFullModeLabel => 'كامل';

  @override
  String get drawingClearTooltip => 'مسح';

  @override
  String get drawingZoomOutTooltip => 'تصغير التكبير';

  @override
  String get drawingZoomInTooltip => 'تكبير';

  @override
  String get drawingDeleteTooltip => 'حذف';

  @override
  String get drawingEmptyPreviewHint => 'اضغط للرسم';

  @override
  String get settingsPageTitle => 'الإعدادات';

  @override
  String get settingsSectionGeneral => 'عام';

  @override
  String get settingsSectionSecurity => 'الأمان';

  @override
  String get settingsSectionTheme => 'المظهر';

  @override
  String get settingsSectionPersonalization => 'التخصيص';

  @override
  String get settingsSectionWidget => 'الودجت';

  @override
  String get settingsSectionAbout => 'حول التطبيق';

  @override
  String get settingsHintQuestionPet => 'ما اسم حيوانك الأليف الأول؟';

  @override
  String get settingsHintQuestionTeacher => 'ما اسم معلمك المفضل؟';

  @override
  String get settingsHintQuestionBirthCity => 'في أي مدينة وُلدت؟';

  @override
  String get settingsHintQuestionFavoriteFood => 'ما هو طعامك المفضل؟';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'ما هو اسم عائلة والدتك قبل الزواج؟';

  @override
  String get settingsHintQuestionFirstSchool => 'ما هي أول مدرسة التحقت بها؟';

  @override
  String get settingsHintQuestionFavoriteColor => 'ما هو لونك المفضل؟';

  @override
  String get settingsSecurityQuestionDialogTitle => 'سؤال الأمان';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'إذا نسيت كلمة المرور، يمكنك استعادتها بالإجابة الصحيحة على هذا السؤال.';

  @override
  String get settingsSecurityQuestionDropdownHint => 'اختر سؤال أمان';

  @override
  String get settingsSecurityQuestionAnswerHint => 'إجابتك';

  @override
  String get settingsSecurityQuestionCancelButton => 'إلغاء';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'لا يمكن ترك السؤال والإجابة فارغين!';

  @override
  String get settingsSecurityQuestionSaveButton => 'حفظ';

  @override
  String get settingsCreatePasswordTitle => 'إنشاء كلمة مرور';

  @override
  String get settingsPasswordRequiredTitle => 'كلمة المرور مطلوبة';

  @override
  String get settingsPasswordEnterHint => 'أدخل كلمة المرور';

  @override
  String get settingsForgotPasswordButton => 'نسيت كلمة المرور';

  @override
  String get settingsNewPasswordHint => 'كلمة مرور جديدة';

  @override
  String get settingsConfirmPasswordHint => 'إعادة إدخال كلمة المرور';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'عيّن سؤال أمان في حال نسيت كلمة المرور (اختياري).';

  @override
  String get settingsPasswordDialogCancelButton => 'إلغاء';

  @override
  String get settingsPasswordMismatchWarning => 'كلمتا المرور غير متطابقتين!';

  @override
  String get settingsWrongPasswordWarning => 'كلمة المرور خاطئة!';

  @override
  String get settingsPasswordSaveButton => 'حفظ';

  @override
  String get settingsPasswordRemoveButton => 'إزالة';

  @override
  String get settingsNotePasswordTitle => 'كلمة مرور الملاحظة';

  @override
  String get settingsPasswordSetSubtitle => 'تم تعيين كلمة المرور ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'لم يتم تعيين كلمة مرور';

  @override
  String get settingsSecurityQuestionTileTitle => 'سؤال الأمان';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'تم التعيين ✓ — يُستخدم في حال نسيان كلمة المرور';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'غير معيّن — لن تتمكن من استعادة كلمة المرور في حال فقدانها';

  @override
  String get settingsThemeDialogTitle => 'اختيار المظهر';

  @override
  String get settingsThemeSystemDefault => 'افتراضي النظام';

  @override
  String get settingsThemeLightOption => 'المظهر الفاتح';

  @override
  String get settingsThemeDarkOption => 'المظهر الداكن';

  @override
  String get settingsLanguageDialogTitle => 'اختيار اللغة';

  @override
  String get settingsLanguageSystemOption => 'النظام';

  @override
  String get settingsAccentColorDialogTitle => 'اختيار لون التمييز';

  @override
  String get settingsThemeChangeTileTitle => 'تغيير المظهر';

  @override
  String get settingsThemeLightLabel => 'فاتح';

  @override
  String get settingsThemeDarkLabel => 'داكن';

  @override
  String get settingsThemeSystemLabel => 'النظام';

  @override
  String get settingsLanguageTileTitle => 'اللغة';

  @override
  String get settingsAccentColorTileTitle => 'لون التمييز';

  @override
  String get settingsAccentColorTileSubtitle =>
      'اللون المستخدم في شريط التطبيق والأزرار والمفاتيح';

  @override
  String get settingsColorfulNotesTitle => 'ألوان متنوعة للملاحظات';

  @override
  String get settingsColorfulNotesSubtitle =>
      'تحصل كل بطاقة ملاحظة على درجة لون مختلفة.';

  @override
  String get settingsTextColorSheetTitle => 'لون النص';

  @override
  String get settingsTextColorSheetDesc => 'يحدد لون نص محتوى الملاحظة.';

  @override
  String get settingsTextColorOkButton => 'موافق';

  @override
  String get settingsTextColorTileTitle => 'لون النص';

  @override
  String get settingsTextColorTileSubtitle => 'لون نص محتوى الملاحظة.';

  @override
  String get settingsWidgetFontSizeLabel => 'حجم خط الودجت';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'عنوان تجريبي - $size نقطة';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'إلغاء';

  @override
  String get settingsWidgetFontSizeApplyButton => 'تطبيق';

  @override
  String get settingsWidgetOpacityLabel => 'شفافية الخلفية';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return 'شفافية $percent٪';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'إلغاء';

  @override
  String get settingsWidgetOpacityApplyButton => 'تطبيق';

  @override
  String get settingsWidgetDarkModeTitle => 'ودجت داكن';

  @override
  String get settingsWidgetDarkModeDesc => 'نظام ألوان داكن للودجت.';

  @override
  String get settingsAboutVersionTitle => 'إصدار التطبيق';

  @override
  String get settingsAboutVersionLoading => 'جارٍ تحميل الإصدار…';

  @override
  String get aboutSectionDeveloper => 'ملاحظات';

  @override
  String get aboutDeveloperTitle => 'المطوّر';

  @override
  String get aboutContactTitle => 'التواصل';

  @override
  String get aboutWebsiteTitle => 'الموقع الإلكتروني';

  @override
  String get aboutGithubTitle => 'GitHub';

  @override
  String get aboutSectionLegal => 'قانوني';

  @override
  String get aboutPrivacyPolicyTitle => 'سياسة الخصوصية';

  @override
  String get aboutTermsTitle => 'شروط الاستخدام';

  @override
  String get aboutLicensesTitle => 'تراخيص المصادر المفتوحة';

  @override
  String get aboutSectionSupport => 'تقييم';

  @override
  String get aboutRateAppTitle => 'قيّم التطبيق';

  @override
  String get aboutLinkOpenError => 'تعذّر فتح الرابط.';

  @override
  String get settingsFontFamilyTileTitle => 'الخط';

  @override
  String get settingsFontFamilyDefaultLabel => 'افتراضي';

  @override
  String get settingsGlobalFontSizeTileTitle => 'حجم الخط';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size نقطة — مطبق على جميع الملاحظات.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'نص تجريبي - $size نقطة';
  }

  @override
  String get settingsGlobalFontSizeCancelButton => 'إلغاء';

  @override
  String get settingsGlobalFontSizeApplyButton => 'تطبيق';

  @override
  String get settingsPreviewLinesTileTitle => 'أسطر معاينة الملاحظة';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'عرض حتى $lines سطرًا. إذا كانت الملاحظة أقصر، يُعرض العدد الفعلي للأسطر.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'الحالي: $lines سطرًا';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'يحدد الحد الأقصى لعدد أسطر المعاينة. إذا كانت الملاحظة تحتوي على أسطر أقل، يُعرض العدد الفعلي.';

  @override
  String get settingsPreviewLinesCancelButton => 'إلغاء';

  @override
  String get settingsPreviewLinesApplyButton => 'تطبيق';

  @override
  String get backupCancelButton => 'إلغاء';

  @override
  String get backupConnectButton => 'اتصال';

  @override
  String get backupDisconnectButton => 'قطع الاتصال';

  @override
  String get backupContinueButton => 'متابعة';

  @override
  String get backupCloseButton => 'إغلاق';

  @override
  String get backupShareButton => 'مشاركة';

  @override
  String get backupRestoreButton => 'استعادة';

  @override
  String get backupConfigureButton => 'تهيئة';

  @override
  String get backupUnknownDateLabel => 'غير معروف';

  @override
  String get backupProcessingDefaultLabel => 'جارٍ المعالجة...';

  @override
  String get backupPermissionRequiredTitle => 'إذن التخزين مطلوب';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'يتطلب إصدار أندرويد هذا إذن التخزين للنسخ الاحتياطي/الاستعادة. بما أن الإذن رُفض بشكل دائم، يرجى تفعيله يدويًا من إعدادات التطبيق.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'يتطلب إصدار أندرويد هذا إذن التخزين للنسخ الاحتياطي/الاستعادة. يرجى منح الإذن للمتابعة.';

  @override
  String get backupGoToSettingsButton => 'الذهاب إلى الإعدادات';

  @override
  String get backupRetryButton => 'إعادة المحاولة';

  @override
  String get backupDriveConnectingLabel => 'جارٍ الاتصال بحساب Google...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'تم الاتصال بحساب Google Drive: $email';
  }

  @override
  String get backupDriveConnectedMessage => 'تم الاتصال بحساب Google Drive.';

  @override
  String get backupDriveConnectFailedMessage =>
      'تعذر الاتصال بحساب Google، أو تم إلغاء العملية.';

  @override
  String get backupDriveDisconnectTitle => 'قطع الاتصال بـ Google Drive';

  @override
  String get backupDriveDisconnectBody =>
      'في حال قطع الاتصال، لن تتمكن من إجراء نسخ احتياطية يدوية أو تلقائية إلى Drive. النسخ الاحتياطية المخزنة بالفعل على Drive لن تُحذف — ستتم إزالة الوصول من هذا الجهاز فقط.';

  @override
  String get backupDriveDisconnectedMessage =>
      'تمت إزالة الاتصال بـ Google Drive.';

  @override
  String get backupDriveRequiredTitle => 'حساب Google مطلوب';

  @override
  String get backupDriveRequiredBody =>
      'يتطلب هذا الإجراء ربط حساب Google الخاص بك. هل تريد الاتصال الآن؟';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: متصل ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: متصل';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: غير متصل';

  @override
  String get backupDriveAuthenticatingLabel => 'جارٍ التحقق من حساب Google...';

  @override
  String get backupDriveNotSignedInMessage =>
      'أنت غير متصل بـ Google Drive. يرجى تسجيل الدخول بحساب Google أولاً.';

  @override
  String get backupDriveUploadingLabel =>
      'جارٍ رفع النسخة الاحتياطية إلى Drive...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'لم يكتمل الرفع إلى Google Drive خلال 120 ثانية (لا يوجد رد من الخادم). يرجى التحقق من اتصالك والمحاولة مرة أخرى.';

  @override
  String get backupDriveOperationCompletedLabel => 'اكتمل';

  @override
  String get backupToDriveActionLabel => 'النسخ الاحتياطي إلى Drive';

  @override
  String get backupToDeviceActionLabel => 'النسخ الاحتياطي';

  @override
  String get backupCreatingLabel => 'جارٍ إنشاء النسخة الاحتياطية...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'تعذر إنشاء النسخة الاحتياطية: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'فشل الرفع إلى Google Drive: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'تم رفع النسخة الاحتياطية بنجاح إلى Google Drive.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'تم إنشاء النسخة الاحتياطية: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'النسخة الاحتياطية جاهزة';

  @override
  String get backupOfferShareBody =>
      'تم حفظ ملف النسخة الاحتياطية على جهازك. هل تريد مشاركته الآن (مثل التخزين السحابي أو البريد الإلكتروني أو جهاز آخر)؟';

  @override
  String get backupShareFileText => 'ملف نسخة احتياطية من layout';

  @override
  String backupShareFailedMessage(String error) {
    return 'تعذر بدء المشاركة: $error';
  }

  @override
  String get backupLargeOperationTitle => 'نسخة احتياطية كبيرة';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'حجم البيانات المراد معالجتها حوالي $sizeText. قد تستغرق عملية $actionLabel بهذا الحجم بعض الوقت حسب جهازك. فقط لا تغادر التطبيق أثناء التقدم — هل تريد المتابعة؟';
  }

  @override
  String get backupRestoreActionLabel => 'الاستعادة';

  @override
  String get backupDriveListingLabel =>
      'جارٍ سرد النسخ الاحتياطية على Drive...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'تعذر سرد النسخ الاحتياطية: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'لا توجد نسخ احتياطية على Google Drive بعد.';

  @override
  String get backupDrivePickTitle => 'اختر نسخة احتياطية من Drive';

  @override
  String get backupDriveDownloadingLabel =>
      'جارٍ تنزيل النسخة الاحتياطية من Drive...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'جارٍ تنزيل النسخة الاحتياطية من Drive... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel => 'جارٍ حفظ الملف على الجهاز...';

  @override
  String get backupDriveUnknownBackupFileName => 'unknown_backup.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'مساحة تخزين Google Drive ممتلئة. يرجى تحرير مساحة على Drive والمحاولة مرة أخرى.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'تعذر إنشاء اتصال بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'تعذر العثور على ملف النسخة الاحتياطية المحدد على Drive. ربما تم حذفه.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'حدث خطأ غير متوقع أثناء عملية Google Drive: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'فشل التنزيل: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'تعذر اختيار الملف: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'تعذر الوصول إلى الملف المحدد.';

  @override
  String get backupCheckingLabel => 'جارٍ فحص النسخة الاحتياطية...';

  @override
  String backupReadFailedMessage(String error) {
    return 'تعذر قراءة ملف النسخة الاحتياطية: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'استعادة النسخة الاحتياطية';

  @override
  String get backupPreviewContentsHeader =>
      'محتويات النسخة الاحتياطية المحددة:';

  @override
  String get backupPreviewNoteCountLabel => 'عدد الملاحظات';

  @override
  String get backupPreviewTrashCountLabel => 'الملاحظات في سلة المهملات';

  @override
  String get backupPreviewCategoryCountLabel => 'عدد الفئات';

  @override
  String get backupPreviewAttachmentLabel => 'المرفقات';

  @override
  String get backupPreviewAttachmentNoneValue => 'لا يوجد';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count ملفات ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'تاريخ الإنشاء';

  @override
  String get backupEmptyPreviewTitle => 'تبدو هذه النسخة الاحتياطية فارغة';

  @override
  String get backupEmptyPreviewBody =>
      'لم يتم العثور على ملاحظات أو فئات أو مرفقات في الملف المحدد. إذا تابعت، ستُحذف بياناتك الحالية وتُستبدل بهذه النسخة الاحتياطية الفارغة.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '$count مرفقات غير موجودة في النسخة الاحتياطية';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'سيتم استعادة الملاحظات التي تحتوي على هذه الملفات، ولكن بدون المرفقات (قد تكون مفقودة أو تالفة وقت أخذ النسخة الاحتياطية): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown و$remaining أخرى';
  }

  @override
  String get backupRestoreConfirmBody =>
      'سيؤدي هذا إلى استبدال جميع ملاحظاتك الحالية وسلة المهملات والفئات والإعدادات والمرفقات بالبيانات الموجودة في النسخة الاحتياطية أعلاه. ستُفقد بياناتك الحالية نهائيًا ولا يمكن التراجع عن هذا الإجراء.';

  @override
  String get backupRestoringLabel => 'جارٍ استعادة النسخة الاحتياطية...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'تمت استعادة النسخة الاحتياطية. مع ذلك، لم يتم العثور على $count مرفقات في النسخة الاحتياطية ولم يتم استعادتها. يُنصح بإعادة تشغيل التطبيق لتفعيل التغييرات بالكامل.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'تمت استعادة النسخة الاحتياطية بنجاح. يُنصح بإعادة تشغيل التطبيق لتفعيل التغييرات بالكامل.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'حدث خطأ أثناء الاستعادة: $error';
  }

  @override
  String get backupScreenTitle => 'النسخ الاحتياطي والاستعادة';

  @override
  String get backupBlockedExitWarningMessage =>
      'هناك عملية قيد التنفيذ، يرجى الانتظار حتى تنتهي.';

  @override
  String get backupBusyBackTooltip => 'العملية قيد التنفيذ';

  @override
  String get backupIntroText =>
      'يمكنك نسخ ملاحظاتك وفئاتك وإعداداتك ومرفقاتك احتياطيًا كملف .zip واحد، أو استعادة نسخة احتياطية أخذتها سابقًا.';

  @override
  String get backupDriveCardTitle => 'نسخ احتياطي إلى Google Drive';

  @override
  String get backupDriveCardSubtitle =>
      'أنشئ نسخة احتياطية جديدة وارفعها مباشرة إلى المنطقة الخاصة في Google Drive الخاص بك.';

  @override
  String get backupDriveCardButtonLabel => 'نسخ احتياطي إلى Drive';

  @override
  String get backupDeviceCardTitle => 'نسخ احتياطي إلى الجهاز';

  @override
  String get backupDeviceCardSubtitle =>
      'احفظ جميع بياناتك كملف .zip واحد على جهازك وشاركه إذا أردت.';

  @override
  String get backupDeviceCardButtonLabel => 'نسخ احتياطي إلى الجهاز';

  @override
  String get backupHistoryCardTitle => 'سجل النسخ الاحتياطي';

  @override
  String get backupHistoryCardSubtitle =>
      'اعرض جميع النسخ الاحتياطية المخزنة على جهازك مع تاريخها وحجمها؛ يمكنك مشاركتها أو استعادتها أو حذفها مباشرة من هنا.';

  @override
  String get backupHistoryTabDevice => 'الجهاز';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'حذف النسخة الاحتياطية';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'هل أنت متأكد أنك تريد حذف ملف النسخة الاحتياطية \"$fileName\" نهائيًا؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'تم حذف النسخة الاحتياطية.';

  @override
  String get backupHistoryDriveDeleteDialogTitle => 'حذف نسخة Drive الاحتياطية';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'هل أنت متأكد أنك تريد حذف النسخة الاحتياطية \"$fileName\" نهائيًا من Google Drive؟ لا يمكن التراجع عن هذا الإجراء ولن يُنقل الملف إلى سلة المهملات.';
  }

  @override
  String get backupHistoryDriveDeletedMessage =>
      'تم حذف نسخة Drive الاحتياطية.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'تعذر الحذف: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'لا توجد نسخ احتياطية محفوظة على هذا الجهاز بعد.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'استخدم \"نسخ احتياطي إلى الجهاز\" لإنشاء أول نسخة احتياطية لك.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'استخدم \"نسخ احتياطي إلى Google Drive\" لإنشاء أول نسخة احتياطية سحابية لك.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'اربط حساب Google الخاص بك لرؤية نسخ Drive الاحتياطية.';

  @override
  String get backupHistoryConnectGoogleButton => 'الاتصال بـ Google';

  @override
  String get backupHistoryDriveConnectedFallback => 'متصل';

  @override
  String get backupHistoryUnknownErrorFallback => 'حدث خطأ غير معروف.';

  @override
  String get backupHistoryDownloadStartingLabel => 'جارٍ البدء...';

  @override
  String get backupAutoBackupEnabledLabel => 'النسخ الاحتياطي التلقائي: مفعّل';

  @override
  String get backupAutoBackupDisabledLabel => 'النسخ الاحتياطي التلقائي: معطّل';

  @override
  String get backupOverlayWarningMessage =>
      'يرجى الانتظار، لا تغادر التطبيق حتى تكتمل العملية.';

  @override
  String get pdfExportUntitledNoteLabel => 'ملاحظة بلا عنوان';

  @override
  String get pdfExportDefaultAttachmentName => 'مرفق';

  @override
  String get pdfExportDefaultFileName => 'ملاحظة';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'تعذر التقاط لقطة الشاشة (لم يتم العثور على الحدود)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'تعذر إنشاء بيانات لقطة الشاشة';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'تعذرت معالجة الصورة (فشل فك ترميز PNG)';

  @override
  String get screenshotCalcTableTotalLabel => 'الإجمالي';

  @override
  String get gundemMenuRemoveFromAgenda => 'إزالة من الأجندة';

  @override
  String get gundemMenuDeleteNote => 'حذف الملاحظة';

  @override
  String get gundemSectionOverdue => 'متأخر';

  @override
  String get gundemSectionToday => 'اليوم';

  @override
  String get gundemSectionTomorrow => 'غدًا';

  @override
  String get gundemSectionNextWeek => 'الأسبوع القادم';

  @override
  String get gundemSectionFurther => 'لاحقًا';

  @override
  String get gundemWeekdayMonday => 'الاثنين';

  @override
  String get gundemWeekdayTuesday => 'الثلاثاء';

  @override
  String get gundemWeekdayWednesday => 'الأربعاء';

  @override
  String get gundemWeekdayThursday => 'الخميس';

  @override
  String get gundemWeekdayFriday => 'الجمعة';

  @override
  String get gundemWeekdaySaturday => 'السبت';

  @override
  String get gundemWeekdaySunday => 'الأحد';

  @override
  String get gundemAppBarTitle => 'الأجندة';

  @override
  String get gundemCalendarTooltip => 'التقويم';

  @override
  String get gundemEmptyTitle => 'لا يوجد شيء في أجندتك';

  @override
  String get gundemEmptySubtitle =>
      'ستظهر هنا الملاحظات التي تحتوي على تذكير أو تاريخ محدد.';

  @override
  String get gundemUntitledNote => 'ملاحظة بلا عنوان';

  @override
  String get gundemRepeatHourly => 'كل ساعة';

  @override
  String get gundemRepeatDaily => 'يوميًا';

  @override
  String get gundemRepeatWeekly => 'أسبوعيًا';

  @override
  String get gundemRepeatMonthly => 'شهريًا';

  @override
  String get gundemRepeatYearly => 'سنويًا';

  @override
  String get gundemPreviewCalcTableLabel => '[قائمة حسابية]';

  @override
  String get gundemPreviewDrawingLabel => '[رسم]';

  @override
  String get gundemPreviewImageLabel => '[صورة]';

  @override
  String get gundemMonthShortJan => 'ينا';

  @override
  String get gundemMonthShortFeb => 'فبر';

  @override
  String get gundemMonthShortMar => 'مار';

  @override
  String get gundemMonthShortApr => 'أبر';

  @override
  String get gundemMonthShortMay => 'ماي';

  @override
  String get gundemMonthShortJun => 'يون';

  @override
  String get gundemMonthShortJul => 'يول';

  @override
  String get gundemMonthShortAug => 'أغس';

  @override
  String get gundemMonthShortSep => 'سبت';

  @override
  String get gundemMonthShortOct => 'أكت';

  @override
  String get gundemMonthShortNov => 'نوف';

  @override
  String get gundemMonthShortDec => 'ديس';

  @override
  String get calendarAppBarTitle => 'التقويم';

  @override
  String get calendarTodayButton => 'اليوم';

  @override
  String get calendarLegendNoteLabel => 'ملاحظة';

  @override
  String get calendarLegendReminderLabel => 'تذكير';

  @override
  String get calendarTodayBadge => 'اليوم';

  @override
  String get calendarEmptyDayMessage =>
      'لا توجد ملاحظات أو تذكيرات لهذا اليوم.';

  @override
  String get calendarReminderHourlyLabel => 'كل ساعة';

  @override
  String get calendarMonthJan => 'يناير';

  @override
  String get calendarMonthFeb => 'فبراير';

  @override
  String get calendarMonthMar => 'مارس';

  @override
  String get calendarMonthApr => 'أبريل';

  @override
  String get calendarMonthMay => 'مايو';

  @override
  String get calendarMonthJun => 'يونيو';

  @override
  String get calendarMonthJul => 'يوليو';

  @override
  String get calendarMonthAug => 'أغسطس';

  @override
  String get calendarMonthSep => 'سبتمبر';

  @override
  String get calendarMonthOct => 'أكتوبر';

  @override
  String get calendarMonthNov => 'نوفمبر';

  @override
  String get calendarMonthDec => 'ديسمبر';

  @override
  String get calendarWeekdayShortMon => 'اثن';

  @override
  String get calendarWeekdayShortTue => 'ثلا';

  @override
  String get calendarWeekdayShortWed => 'أرب';

  @override
  String get calendarWeekdayShortThu => 'خمي';

  @override
  String get calendarWeekdayShortFri => 'جمع';

  @override
  String get calendarWeekdayShortSat => 'سبت';

  @override
  String get calendarWeekdayShortSun => 'أحد';

  @override
  String get calendarWeekdayFullMonday => 'الاثنين';

  @override
  String get calendarWeekdayFullTuesday => 'الثلاثاء';

  @override
  String get calendarWeekdayFullWednesday => 'الأربعاء';

  @override
  String get calendarWeekdayFullThursday => 'الخميس';

  @override
  String get calendarWeekdayFullFriday => 'الجمعة';

  @override
  String get calendarWeekdayFullSaturday => 'السبت';

  @override
  String get calendarWeekdayFullSunday => 'الأحد';

  @override
  String get wrongPasswordDialogTitle => 'كلمة مرور خاطئة';

  @override
  String get wrongPasswordDialogMessage =>
      'كلمة المرور التي أدخلتها غير صحيحة.';

  @override
  String get commonOkButton => 'موافق';

  @override
  String get unlockCategoryAction => 'إلغاء القفل';

  @override
  String get lockCategoryAction => 'قفل';

  @override
  String get categoryUnlockedMessage => 'تم إلغاء القفل';

  @override
  String get categoryLockedMessage => 'تم قفل المجلد';

  @override
  String get deleteFolderMenuItemLabel => 'حذف المجلد';

  @override
  String get deleteFolderDialogTitle => 'حذف المجلد';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'هل أنت متأكد أنك تريد حذف المجلد \"$category\" وجميع مجلداته الفرعية؟ ستصبح الملاحظات في هذه المجلدات غير مصنّفة.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'هل أنت متأكد أنك تريد حذف المجلد \"$category\"؟ ستصبح الملاحظات في هذا المجلد غير مصنّفة.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'إلغاء';

  @override
  String get deleteFolderDialogConfirmButton => 'حذف';

  @override
  String get editCategoryNameColorMenuItemLabel => 'تعديل الاسم / اللون';

  @override
  String get addSubfolderMenuItemLabel => 'إنشاء مجلد فرعي';

  @override
  String get expandSubfoldersMenuItemLabel => 'توسيع المجلدات الفرعية';

  @override
  String get collapseSubfoldersMenuItemLabel => 'طي المجلدات الفرعية';

  @override
  String saveErrorInfoMessage(String error) {
    return 'خطأ في الحفظ: $error';
  }

  @override
  String get welcomeNoteTitle => 'مرحبًا بك في Layout! 🚀';

  @override
  String get welcomeNoteContent => 'تمت إضافة ميزات جديدة!';

  @override
  String get noteListDateGroupToday => 'اليوم';

  @override
  String get noteListDateGroupYesterday => 'أمس';

  @override
  String get noteListDateGroupLast7Days => 'آخر 7 أيام';

  @override
  String get noteListDateGroupLast30Days => 'آخر 30 يومًا';

  @override
  String get reminderRepeatNoneLabel => 'بلا تكرار';

  @override
  String get voiceRecorderPreparingLabel => 'جارٍ التجهيز…';

  @override
  String get voiceRecorderCancelButton => 'إلغاء';

  @override
  String get voiceRecorderStopAddButton => 'إيقاف وإضافة';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'لم يتم منح إذن الميكروفون.';

  @override
  String get speechToTextUnavailableMessage =>
      'التعرف على الكلام غير متاح على هذا الجهاز.';

  @override
  String get speechToTextPreparingLabel => 'جارٍ التجهيز…';

  @override
  String get speechToTextListeningLabel => 'جارٍ الاستماع…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'ابدأ الحديث…';

  @override
  String get speechToTextCancelButton => 'إلغاء';

  @override
  String get speechToTextStopAddButton => 'إيقاف وإضافة';

  @override
  String get textToSpeechNoContentMessage => 'لا يوجد محتوى لقراءته.';

  @override
  String get textToSpeechReadErrorMessage => 'حدث خطأ أثناء القراءة.';

  @override
  String get textToSpeechUnavailableMessage =>
      'تحويل النص إلى كلام غير متاح على هذا الجهاز.';

  @override
  String get textToSpeechPreparingLabel => 'جارٍ التجهيز…';

  @override
  String get textToSpeechPausedLabel => 'متوقف مؤقتًا';

  @override
  String get textToSpeechFinishedLabel => 'اكتملت القراءة';

  @override
  String get textToSpeechReadingLabel => 'جارٍ القراءة…';

  @override
  String get textToSpeechCloseErrorButton => 'إغلاق';

  @override
  String get textToSpeechReplayButton => 'إعادة القراءة';

  @override
  String get textToSpeechCloseFinishedButton => 'إغلاق';

  @override
  String get textToSpeechPauseButton => 'إيقاف مؤقت';

  @override
  String get textToSpeechResumeButton => 'استئناف';

  @override
  String get textToSpeechStopButton => 'إيقاف';

  @override
  String get textToSpeechSpeedSlow => 'بطيء';

  @override
  String get textToSpeechSpeedNormal => 'عادي';

  @override
  String get textToSpeechSpeedFast => 'سريع';

  @override
  String get calendarPickerCancelButton => 'إلغاء';

  @override
  String get calendarPickerConfirmButton => 'اختيار';

  @override
  String get calendarPickerClearButton => 'مسح';

  @override
  String get reminderPickerDialogTitle => 'إضافة تذكير';

  @override
  String get reminderPickerDateTodayOption => 'اليوم';

  @override
  String get reminderPickerDateTomorrowOption => 'غدًا';

  @override
  String get reminderPickerDatePickOption => 'اختيار تاريخ';

  @override
  String get reminderRepeatHourlyLabel => 'كل ساعة';

  @override
  String get reminderRepeatDailyLabel => 'كل يوم';

  @override
  String get reminderRepeatWeeklyLabel => 'كل أسبوع';

  @override
  String get reminderRepeatMonthlyLabel => 'كل شهر';

  @override
  String get reminderRepeatYearlyLabel => 'كل سنة';

  @override
  String get reminderPickerCalendarHelpText => 'اختر تاريخ التذكير';

  @override
  String get reminderPickerCancelButton => 'إلغاء';

  @override
  String get reminderPickerSaveButton => 'حفظ';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'لا يمكن اختيار وقت في الماضي';

  @override
  String calcTableTotalLabel(String amount) {
    return 'الإجمالي: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'جارٍ تجهيز البيانات...';

  @override
  String get backupCreatePackagingNotesLabel =>
      'جارٍ تجميع الملاحظات والفئات...';

  @override
  String get backupCreateReadingAttachmentsLabel => 'جارٍ قراءة المرفقات...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'جارٍ قراءة المرفقات... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'جارٍ ضغط ملف zip...';

  @override
  String get backupCreateSavingFileLabel => 'جارٍ حفظ الملف...';

  @override
  String get backupRestoreValidatingLabel =>
      'جارٍ التحقق من النسخة الاحتياطية...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'تم التحقق من النسخة الاحتياطية، جارٍ تجهيز البيانات...';

  @override
  String get backupRestoreWritingNotesLabel => 'جارٍ كتابة الملاحظات...';

  @override
  String get backupRestoreWritingTrashLabel => 'جارٍ كتابة سلة المهملات...';

  @override
  String get backupRestoreTrashWrittenLabel => 'تمت كتابة سلة المهملات';

  @override
  String get backupRestoreWritingCategoriesLabel => 'جارٍ كتابة الفئات...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'تمت كتابة الفئات';

  @override
  String get backupRestoreWritingSettingsLabel => 'جارٍ كتابة الإعدادات...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'تمت كتابة الإعدادات';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'جارٍ تنظيف المرفقات القديمة...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'لم يتم العثور على مرفقات، جارٍ الإنهاء...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'جارٍ استعادة المرفقات... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'اكتمل';

  @override
  String get backupValidationCorruptedFileMessage =>
      'الملف تالف أو ليس ملف نسخة احتياطية صالحًا.';

  @override
  String get backupValidationMissingDataMessage =>
      'لم يتم العثور على بيانات داخل ملف النسخة الاحتياطية (backup_data.json مفقود).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'تعذرت قراءة بيانات النسخة الاحتياطية (JSON تالف).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'هذا الملف ليس نسخة احتياطية من تطبيق layout.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'تعذرت قراءة معلومات إصدار ملف النسخة الاحتياطية.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'هذه النسخة الاحتياطية بتنسيق أحدث لا يدعمه إصدار التطبيق الحالي. يرجى تحديث التطبيق.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'معلومات إصدار ملف النسخة الاحتياطية غير صالحة.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'بيانات النسخة الاحتياطية ليست بالتنسيق المتوقع (حقل الملاحظات مفقود).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'بيانات النسخة الاحتياطية ليست بالتنسيق المتوقع (حقل سلة المهملات مفقود).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'بيانات النسخة الاحتياطية ليست بالتنسيق المتوقع (قائمة الفئات غير صالحة).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'بيانات النسخة الاحتياطية ليست بالتنسيق المتوقع (حقل الإعدادات غير صالح).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'بيانات النسخة الاحتياطية ليست بالتنسيق المتوقع (سجل ملاحظة غير صالح).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'بيانات النسخة الاحتياطية ليست بالتنسيق المتوقع (تم العثور على سجل ملاحظة بدون معرّف).';

  @override
  String get backupValidationFileNotFoundMessage =>
      'ملف النسخة الاحتياطية غير موجود.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'لا توجد مساحة تخزين كافية على الجهاز. يرجى تحرير مساحة والمحاولة مرة أخرى.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'تم رفض إذن الوصول إلى الملفات. يرجى التحقق من أذونات التطبيق والمحاولة مرة أخرى.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'حدث خطأ أثناء عملية الملف: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'حدث خطأ غير متوقع: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'تعذر إنشاء أرشيف zip (أعاد ZipEncoder قيمة null).';

  @override
  String get calcTableMenuItemLabel => 'قائمة حسابية';

  @override
  String get tableBlockMenuItemLabel => 'جدول';

  @override
  String get tableSizePickerTitle => 'اختر حجم الجدول';

  @override
  String get tableSizePickerCancel => 'إلغاء';

  @override
  String get tableSizePickerDeleteTooltip => 'حذف الجدول';

  @override
  String get tagsMenuItemLabel => 'الوسوم';

  @override
  String get linkDialogUrlHint => 'https://example.com';

  @override
  String get checklistItemHint => 'إضافة عنصر...';

  @override
  String get toolbarHighlightTooltip => 'تمييز';

  @override
  String get toolbarListTooltip => 'قائمة';

  @override
  String get toolbarHideKeyboardTooltip => 'إخفاء لوحة المفاتيح';

  @override
  String get autoBackupLocalSuccessMessage => 'نجح النسخ الاحتياطي المحلي.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'فشل النسخ الاحتياطي المحلي: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'تم تخطي النسخ الاحتياطي إلى Drive: حساب Google غير متصل أو انتهت صلاحية الجلسة. يرجى فتح التطبيق وإعادة الاتصال.';

  @override
  String get autoBackupDriveSuccessMessage => 'نجح النسخ الاحتياطي إلى Drive.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'فشل النسخ الاحتياطي إلى Drive: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'لا توجد ملاحظات بعد';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'الإجمالي: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ رسم';

  @override
  String get autoBackupSettingsAppBarTitle =>
      'إعدادات النسخ الاحتياطي التلقائي';

  @override
  String get autoBackupSettingsMainSwitchTitle =>
      'تفعيل النسخ الاحتياطي التلقائي';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'يتم نسخ ملاحظاتك احتياطيًا بأمان بشكل دوري في الخلفية.';

  @override
  String get autoBackupSettingsTargetTitle => 'وجهة النسخ الاحتياطي';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'اختر مكان حفظ النسخ الاحتياطية.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'محلي';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'كلاهما';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'اربط حسابك أولاً لاستخدام خيارات Google Drive.';

  @override
  String get autoBackupSettingsConnectButton => 'اتصال';

  @override
  String get autoBackupSettingsFrequencyTitle => 'تكرار النسخ الاحتياطي';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'يتم أخذ نسخة احتياطية كل $hours ساعة.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 ساعات';

  @override
  String get autoBackupSettingsFrequency12h => '12 ساعة';

  @override
  String get autoBackupSettingsFrequency24h => '24 ساعة (يوميًا)';

  @override
  String get autoBackupSettingsFrequency48h => '48 ساعة (يومان)';

  @override
  String get autoBackupSettingsFrequency168h => '168 ساعة (أسبوعيًا)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'استخدام Wi-Fi فقط';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'يتم الرفع السحابي عبر Wi-Fi فقط لحماية بيانات الجوال الخاصة بك.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'حالة النظام';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'لم يتم تشغيل النسخ الاحتياطي التلقائي بعد.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'آخر تشغيل: $date $time ($status)\nالرسالة: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'ناجح';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'فاشل';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'تعذر الاتصال بحساب Google.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'تم تحديث إعدادات النسخ الاحتياطي التلقائي.';

  @override
  String selectionModeDeletedMessage(int count) {
    return 'تم حذف $count ملاحظة';
  }

  @override
  String get selectionModeArchivedMessage => 'تمت الأرشفة';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'اختر فئة لـ $count ملاحظة';
  }

  @override
  String get selectionModeAddCategoryOption => 'إضافة فئة';

  @override
  String get selectionModeRemoveCategoryOption => 'إزالة الفئة';

  @override
  String get calcTableItemHint => 'عنصر...';

  @override
  String get calcTableTotalRowLabel => 'الإجمالي';

  @override
  String get textSelectionMenuShareButton => 'مشاركة';

  @override
  String get textSelectionMenuTranslateButton => 'ترجمة';

  @override
  String get textSelectionMenuShareFailedSnackbar => 'تعذر بدء المشاركة.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar => 'تعذر فتح الترجمة.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'اليوم $time';
  }

  @override
  String lastBackupInfoDateFormat(
    String day,
    String month,
    int year,
    String time,
  ) {
    return '$day/$month/$year $time';
  }

  @override
  String lastBackupInfoLabel(String date) {
    return 'آخر نسخة احتياطية: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage =>
      'لم يتم أخذ أي نسخة احتياطية بعد.';

  @override
  String get backupFileNameLabel => 'نسخة احتياطية';
}
