// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'מודגש';

  @override
  String get toolbarItalicTooltip => 'נטוי';

  @override
  String get toolbarUnderlineTooltip => 'קו תחתון';

  @override
  String get toolbarStrikethroughTooltip => 'קו חוצה';

  @override
  String get toolbarFontSizeTooltip => 'גודל גופן';

  @override
  String get toolbarColorTooltip => 'צבע טקסט';

  @override
  String get toolbarBulletTooltip => 'רשימת תבליטים';

  @override
  String get toolbarNumberTooltip => 'רשימה ממוספרת';

  @override
  String get toolbarIndentTooltip => 'הזחת פסקה';

  @override
  String get toolbarLinkTooltip => 'הוספה/עריכה/הסרה של קישור';

  @override
  String get toolbarDividerTooltip => 'הוספת קו מפריד';

  @override
  String get toolbarChecklistTooltip => 'הוספת רשימת משימות';

  @override
  String get linkSelectTextSnackbar => 'בחר קודם את הטקסט שברצונך לקשר';

  @override
  String get linkDialogEditTitle => 'עריכת קישור';

  @override
  String get linkDialogAddTitle => 'הוספת קישור';

  @override
  String get linkDialogRemoveButton => 'הסר קישור';

  @override
  String get linkDialogCancelButton => 'ביטול';

  @override
  String get linkDialogConfirmButton => 'הוסף';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'הרשאת המצלמה נדחתה. יש לאפשר אותה מההגדרות כדי להקליט וידאו.';

  @override
  String get cameraPermissionRequiredMessage =>
      'נדרשת הרשאת מצלמה כדי להקליט וידאו.';

  @override
  String get openSettingsButtonLabel => 'הגדרות';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'לא ניתן היה להתחיל את הסריקה: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'זיהוי הטקסט נכשל: $error';
  }

  @override
  String get ocrNoReadableTextMessage => 'לא נמצא טקסט קריא במסמך';

  @override
  String get scanResultSheetTitle => 'כיצד להוסיף את המסמך הסרוק?';

  @override
  String get scanResultTextOnlyOption => 'הוסף כטקסט בלבד';

  @override
  String get scanResultTextAndImageOption => 'הוסף טקסט + תמונה סרוקה';

  @override
  String get scanResultCancelOption => 'ביטול';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'הרשאת המיקרופון נדחתה. יש לאפשר אותה מההגדרות כדי להקליט שמע.';

  @override
  String get audioPermissionRequiredMessage =>
      'נדרשת הרשאת מיקרופון כדי להקליט שמע.';

  @override
  String get voiceRecordingDefaultLabel => 'הקלטה קולית';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'רשימת חישוב ($count שורות)';
  }

  @override
  String get blockPreviewDrawingLabel => 'ציור';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count קבצים מצורפים (תמונה/מסמך)';
  }

  @override
  String get blockPreviewDividerLabel => 'קו מפריד';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'רשימת משימות ($count פריטים)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(טקסט ריק)';

  @override
  String get reorderBlocksSheetTitle => 'סידור מחדש של הבלוקים';

  @override
  String get reorderBlocksMoveUpTooltip => 'הזז למעלה';

  @override
  String get reorderBlocksMoveDownTooltip => 'הזז למטה';

  @override
  String get reorderBlocksCloseTooltip => 'סגור';

  @override
  String get reorderBlocksDescription =>
      'הקש על בלוק כדי לבחור בו, ולאחר מכן השתמש בחצים למעלה/למטה כדי להזיז אותו.';

  @override
  String get reorderBlocksMenuItemLabel => 'סדר מחדש';

  @override
  String get txtImportPickerDialogTitle => 'בחר את קובץ ה-TXT לייבוא';

  @override
  String get txtImportReadFailedMessage => 'לא ניתן היה לקרוא את קובץ ה-TXT';

  @override
  String get txtImportEmptyFileMessage => 'קובץ ה-TXT ריק';

  @override
  String get txtImportSuccessMessage => 'קובץ ה-TXT יובא';

  @override
  String get txtImportMenuItemLabel => 'ייבוא (txt)';

  @override
  String get exportMenuItemLabel => 'ייצוא';

  @override
  String get editorUndoTooltip => 'בטל';

  @override
  String get editorRedoTooltip => 'בצע שוב';

  @override
  String get noteSavedMessage => 'הפתקית נשמרה';

  @override
  String get dateAssignPickerHelpText => 'שיוך פתקית ליום';

  @override
  String get dateAssignChangeOption => 'שנה תאריך';

  @override
  String get dateAssignRemoveOption => 'הסר שיוך';

  @override
  String get editorSubToolbarCloseTooltip => 'סגור';

  @override
  String get titleFieldHint => 'כותרת';

  @override
  String get textBlockHint => 'כתוב את הפתקית שלך כאן...';

  @override
  String get drawingBoardMenuItemLabel => 'לוח ציור';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'המרת קול לטקסט זמינה רק עבור פתקיות טקסט';

  @override
  String get selectionModeCancelTooltip => 'ביטול בחירה';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return '$count נבחרו';
  }

  @override
  String get selectionModeDeleteTooltip => 'מחק';

  @override
  String get selectionModeArchiveTooltip => 'העבר לארכיון';

  @override
  String get selectionModeFolderTooltip => 'תיקייה';

  @override
  String get searchFieldHint => 'חפש פתקיות...';

  @override
  String get emptyTrashDialogTitle => 'רוקן את האשפה';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'כל הפתקיות שנמחקו יוסרו לצמיתות. האם אתה בטוח?';

  @override
  String get emptyTrashDialogCancelButton => 'ביטול';

  @override
  String get restoreAllMenuItemLabel => 'שחזר הכול';

  @override
  String get sortMenuTooltip => 'מיין פתקיות';

  @override
  String get sortMenuAscendingLabel => 'סדר: עולה (א-ת)';

  @override
  String get sortMenuDescendingLabel => 'סדר: יורד (ת-א)';

  @override
  String get sortMenuByTitleLabel => 'מיין לפי: כותרת';

  @override
  String get sortMenuByModifiedDateLabel => 'מיין לפי: עדכון אחרון';

  @override
  String get sortMenuByCreatedDateLabel => 'מיין לפי: תאריך יצירה';

  @override
  String get sortMenuByFolderLabel => 'מיין לפי: תיקייה';

  @override
  String get viewToggleGridTooltip => 'תצוגת רשת';

  @override
  String get viewToggleListTooltip => 'תצוגת רשימה';

  @override
  String get drawerHeaderSubtitle => 'המחברת האישית שלך';

  @override
  String get drawerNotesSectionHeader => 'פתקיות';

  @override
  String get drawerAllNotesLabel => 'פתקיות';

  @override
  String get drawerFavoritesLabel => 'מועדפים';

  @override
  String get drawerAgendaLabel => 'סדר יום';

  @override
  String get drawerRemindersLabel => 'תזכורת';

  @override
  String get drawerLockedLabel => 'נעול';

  @override
  String get drawerTrashLabel => 'אשפה';

  @override
  String get drawerFoldersSectionHeader => 'תיקיות';

  @override
  String get drawerExpandLabel => 'הרחב';

  @override
  String get drawerCollapseLabel => 'כווץ';

  @override
  String get drawerAddFolderLabel => 'הוסף תיקייה';

  @override
  String get drawerAppSectionHeader => 'אפליקציה';

  @override
  String get drawerCalendarLabel => 'לוח שנה';

  @override
  String get drawerSettingsLabel => 'הגדרות';

  @override
  String get drawerBackupRestoreLabel => 'גיבוי ושחזור';

  @override
  String get drawerUpgradeToProLabel => 'שדרג ל-Pro';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'תמוך בפיתוח';

  @override
  String get drawerFeedbackLabel => 'משוב';

  @override
  String get drawerAboutLabel => 'אודות';

  @override
  String get noNotesFoundMessage => 'לא נמצאו פתקיות.';

  @override
  String get trashRestoreButtonLabel => 'שחזר';

  @override
  String get trashPermanentDeleteButtonLabel => 'מחק לצמיתות';

  @override
  String get tagRenamedInfoMessage => 'שם התג שונה';

  @override
  String get tagDeletedInfoMessage => 'התג נמחק';

  @override
  String get tagOptionsRenameLabel => 'שנה שם';

  @override
  String get tagOptionsDeleteLabel => 'מחק';

  @override
  String get renameTagDialogTitle => 'שינוי שם תג';

  @override
  String get renameTagDialogHint => 'שם תג חדש';

  @override
  String get renameTagDialogCancelButton => 'ביטול';

  @override
  String get renameTagDialogSaveButton => 'שמור';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '\"$tag\" תוסר מ-$affectedCount פתקיות. להמשיך?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'למחוק את התג \"$tag\"?';
  }

  @override
  String get deleteTagDialogTitle => 'מחיקת תג';

  @override
  String get deleteTagDialogCancelButton => 'ביטול';

  @override
  String get deleteTagDialogConfirmButton => 'מחק';

  @override
  String get tagsSheetTitle => 'תגים';

  @override
  String get tagsSheetEmptyMessage => 'אין עדיין תגים בפתקית זו.';

  @override
  String get tagsSheetInputHint => 'כתוב תג חדש...';

  @override
  String get tagsSheetSuggestionsLabel => 'תגים קיימים';

  @override
  String get noteDeletedInfoMessage => 'הפתקית נמחקה';

  @override
  String get noteDeletedUndoActionLabel => 'בטל';

  @override
  String get reminderSetInfoMessage => 'התזכורת הוגדרה';

  @override
  String get reminderRemovedInfoMessage => 'התזכורת הוסרה';

  @override
  String get noteDuplicatedInfoMessage => 'העותק נוצר';

  @override
  String get speechTextAppendedInfoMessage => 'הטקסט נוסף לפתקית';

  @override
  String get pdfPreparingInfoMessage => 'מכין PDF…';

  @override
  String get pdfSavedInfoMessage => 'ה-PDF נשמר';

  @override
  String get jpgPreparingInfoMessage => 'מכין JPG…';

  @override
  String get jpgSavedInfoMessage => 'ה-JPG נשמר';

  @override
  String get jpgFailedInfoMessage => 'לא ניתן היה ליצור JPG';

  @override
  String get txtPreparingInfoMessage => 'מכין TXT…';

  @override
  String get txtSavedInfoMessage => 'ה-TXT נשמר';

  @override
  String get txtFailedInfoMessage => 'לא ניתן היה ליצור TXT';

  @override
  String get exportOpenActionLabel => 'פתח';

  @override
  String get wrongPasswordInfoMessage => 'סיסמה שגויה.';

  @override
  String get noteArchivedInfoMessage => 'הפתקית הועברה לארכיון';

  @override
  String get noteUnarchivedInfoMessage => 'הוסרה מהארכיון';

  @override
  String get noteUnlockedInfoMessage => 'בוטלה הנעילה';

  @override
  String get noteLockedInfoMessage => 'הפתקית ננעלה';

  @override
  String get notificationUnpinnedInfoMessage => 'ביטול נעיצה';

  @override
  String get emptyNotePinBlockedInfoMessage => 'לא ניתן לנעוץ פתקית ריקה.';

  @override
  String get notificationPinnedInfoMessage => 'ננעצה לחלונית ההתראות';

  @override
  String get noContentToReadInfoMessage => 'אין תוכן לקריאה';

  @override
  String get backPressExitInfoMessage => 'לחץ שוב על \'חזור\' כדי לצאת';

  @override
  String get reminderChannelName => 'תזכורות פתקיות';

  @override
  String get reminderChannelDescription => 'תזכורות פתקיות באפליקציית Layout';

  @override
  String get pinnedChannelName => 'פתקיות נעוצות';

  @override
  String get pinnedChannelDescription => 'פתקיות Layout נעוצות לחלונית ההתראות';

  @override
  String get notificationUnpinActionLabel => 'הסר';

  @override
  String get reminderDefaultTitle => 'תזכורת';

  @override
  String get reminderChecklistBodyFallback =>
      'אל תשכח לבדוק את רשימת המשימות שלך';

  @override
  String get reminderTextBodyFallback => 'אל תשכח לבדוק את הפתקית שלך';

  @override
  String get pdfSaveDialogTitle => 'שמור כ-PDF';

  @override
  String get jpgSaveDialogTitle => 'שמור כ-JPG';

  @override
  String get txtSaveDialogTitle => 'שמור כ-TXT';

  @override
  String get textSizeSheetTitle => 'גודל טקסט';

  @override
  String get textSizeSamplePreview => 'טקסט לדוגמה';

  @override
  String get textSizeCancelButton => 'ביטול';

  @override
  String get textSizeApplyButton => 'החל';

  @override
  String get createPasswordDialogTitle => 'יצירת סיסמה';

  @override
  String get createPasswordNewPasswordHint => 'סיסמה חדשה';

  @override
  String get createPasswordConfirmHint => 'הזן סיסמה שוב';

  @override
  String get createPasswordHintQuestionDescription =>
      'הגדר שאלת אבטחה למקרה שתשכח את הסיסמה (אופציונלי).';

  @override
  String get createPasswordHintQuestionHint => 'בחר שאלת אבטחה';

  @override
  String get createPasswordHintAnswerHint => 'התשובה שלך';

  @override
  String get createPasswordCancelButton => 'ביטול';

  @override
  String get createPasswordSaveButton => 'שמור';

  @override
  String get passwordMismatchMessage => 'הסיסמאות אינן תואמות!';

  @override
  String get passwordRequiredDialogTitle => 'נדרשת סיסמה';

  @override
  String get passwordRequiredHint => 'הזן סיסמה';

  @override
  String get forgotPasswordButtonLabel => 'שכחתי את הסיסמה';

  @override
  String get passwordRequiredCancelButton => 'ביטול';

  @override
  String get passwordRequiredConfirmButton => 'אמת';

  @override
  String get securityQuestionDialogTitle => 'שאלת אבטחה';

  @override
  String get securityQuestionAnswerHint => 'התשובה שלך';

  @override
  String get securityQuestionCancelButton => 'ביטול';

  @override
  String get securityQuestionConfirmButton => 'אשר';

  @override
  String get securityQuestionWrongAnswerMessage => 'תשובה שגויה. נסה שוב.';

  @override
  String get revealedPasswordDialogTitle => 'הסיסמה שלך';

  @override
  String get revealedPasswordLabel => 'סיסמת הפתקית שלך:';

  @override
  String get revealedPasswordOkButton => 'אישור';

  @override
  String get securityQuestionPetName => 'מה שם חיית המחמד הראשונה שלך?';

  @override
  String get securityQuestionFavoriteTeacher => 'מה שם המורה האהוב עליך?';

  @override
  String get securityQuestionBirthCity => 'באיזו עיר נולדת?';

  @override
  String get securityQuestionFavoriteFood => 'מהו המאכל האהוב עליך?';

  @override
  String get securityQuestionMotherMaidenName => 'מה שם הנעורים של אמך?';

  @override
  String get securityQuestionFirstSchool => 'מה שם בית הספר הראשון שבו למדת?';

  @override
  String get securityQuestionFavoriteColor => 'מהו הצבע האהוב עליך?';

  @override
  String get editFolderDialogTitle => 'עריכת תיקייה';

  @override
  String get newSubfolderDialogTitle => 'תת-תיקייה חדשה';

  @override
  String get addFolderDialogTitle => 'הוספת תיקייה';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'תיווצר בתוך \"$parentCategory\"';
  }

  @override
  String get subfolderNameFieldLabel => 'שם תת-התיקייה';

  @override
  String get folderNameFieldLabel => 'שם התיקייה';

  @override
  String get folderColorLabel => 'צבע';

  @override
  String get folderDialogCancelButton => 'ביטול';

  @override
  String get folderDialogSaveButton => 'שמור';

  @override
  String get folderDialogAddButton => 'הוסף';

  @override
  String get selectFolderSheetTitle => 'בחירת תיקייה';

  @override
  String get selectFolderAddOptionLabel => 'הוסף תיקייה';

  @override
  String get removeCurrentFolderLabel => 'הסר תיקייה נוכחית';

  @override
  String get noteDetailsDialogTitle => 'פרטים';

  @override
  String get noteDetailsCreatedLabel => 'נוצרה';

  @override
  String get noteDetailsModifiedLabel => 'עדכון אחרון';

  @override
  String get noteDetailsCharCountLabel => 'ספירת תווים';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count תווים';
  }

  @override
  String get noteDetailsWordCountLabel => 'ספירת מילים';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count מילים';
  }

  @override
  String get noteDetailsOkButton => 'אישור';

  @override
  String get noteDetailsUnknownDateLabel => 'לא ידוע';

  @override
  String get addAttachmentSheetTitle => 'הוספה';

  @override
  String get addAttachmentImageOption => 'הוסף תמונה';

  @override
  String get addAttachmentCameraOption => 'מצלמה';

  @override
  String get addAttachmentFileOption => 'הוסף קובץ';

  @override
  String get addAttachmentVoiceOption => 'הקלטה קולית';

  @override
  String get addAttachmentVideoOption => 'הקלט וידאו';

  @override
  String get addAttachmentScanOption => 'סרוק מסמך';

  @override
  String get noteActionsSheetTitle => 'בחר פעולה';

  @override
  String get noteActionReminderLabel => 'תזכורת';

  @override
  String get noteActionEditReminderLabel => 'ערוך תזכורת';

  @override
  String get noteActionSpeechToTextLabel => 'המרת דיבור לטקסט';

  @override
  String get noteActionArchiveLabel => 'העבר לארכיון';

  @override
  String get noteActionUnarchiveLabel => 'הסר מהארכיון';

  @override
  String get noteActionLockLabel => 'נעל';

  @override
  String get noteActionUnlockLabel => 'בטל נעילה';

  @override
  String get noteActionFavoriteLabel => 'הוסף למועדפים';

  @override
  String get noteActionUnfavoriteLabel => 'הסר מהמועדפים';

  @override
  String get noteActionClassifyLabel => 'בחר תיקייה';

  @override
  String get noteActionDeleteLabel => 'מחק';

  @override
  String get noteActionPinToNotificationLabel => 'נעץ לחלונית ההתראות';

  @override
  String get noteActionUnpinFromNotificationLabel => 'הסר נעיצה';

  @override
  String get noteActionShareLabel => 'שתף';

  @override
  String get noteActionDuplicateLabel => 'צור עותק';

  @override
  String get noteActionCopyContentLabel => 'העתק תוכן';

  @override
  String get noteActionTtsLabel => 'הקרא בקול';

  @override
  String get noteActionTextSizeLabel => 'גודל טקסט';

  @override
  String get noteActionDetailsLabel => 'פרטים';

  @override
  String get noteActionDiscardChangesLabel => 'בטל שינויים';

  @override
  String get noteActionSelectLabel => 'בחר';

  @override
  String get reminderEditOptionLabel => 'שנה תזכורת';

  @override
  String get reminderRemoveOptionLabel => 'הסר תזכורת';

  @override
  String get discardChangesDialogTitle => 'ביטול שינויים';

  @override
  String get discardChangesDialogMessage =>
      'שינויים שלא נשמרו בפתקית זו יאבדו. האם אתה בטוח שברצונך לבטל אותם?';

  @override
  String get discardChangesCancelButton => 'ביטול';

  @override
  String get discardChangesConfirmButton => 'בטל שינויים';

  @override
  String get pinnedNotificationDefaultTitle => 'פתקית';

  @override
  String get pdfFailedInfoMessage => 'יצירת ה-PDF נכשלה';

  @override
  String get drawingScreenTitle => 'ציור';

  @override
  String get drawingMinimizeTooltip => 'מזער';

  @override
  String get drawingEmptyExportWarningMessage => 'צייר משהו קודם';

  @override
  String get drawingEraserPartialModeLabel => 'חלקי';

  @override
  String get drawingEraserFullModeLabel => 'מלא';

  @override
  String get drawingClearTooltip => 'נקה';

  @override
  String get drawingZoomOutTooltip => 'הקטן תצוגה';

  @override
  String get drawingZoomInTooltip => 'הגדל תצוגה';

  @override
  String get drawingDeleteTooltip => 'מחק';

  @override
  String get drawingEmptyPreviewHint => 'הקש כדי לצייר';

  @override
  String get settingsPageTitle => 'הגדרות';

  @override
  String get settingsSectionGeneral => 'כללי';

  @override
  String get settingsSectionSecurity => 'אבטחה';

  @override
  String get settingsSectionTheme => 'ערכת נושא';

  @override
  String get settingsSectionPersonalization => 'התאמה אישית';

  @override
  String get settingsSectionWidget => 'ווידג\'ט';

  @override
  String get settingsSectionAbout => 'אודות';

  @override
  String get settingsHintQuestionPet => 'מה שם חיית המחמד הראשונה שלך?';

  @override
  String get settingsHintQuestionTeacher => 'מה שם המורה האהוב עליך?';

  @override
  String get settingsHintQuestionBirthCity => 'באיזו עיר נולדת?';

  @override
  String get settingsHintQuestionFavoriteFood => 'מהו המאכל האהוב עליך?';

  @override
  String get settingsHintQuestionMotherMaidenName => 'מה שם הנעורים של אמך?';

  @override
  String get settingsHintQuestionFirstSchool => 'מהו בית הספר הראשון שבו למדת?';

  @override
  String get settingsHintQuestionFavoriteColor => 'מהו הצבע האהוב עליך?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'שאלת אבטחה';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'אם תשכח את הסיסמה, תוכל לשחזר אותה על ידי מענה נכון על שאלה זו.';

  @override
  String get settingsSecurityQuestionDropdownHint => 'בחר שאלת אבטחה';

  @override
  String get settingsSecurityQuestionAnswerHint => 'התשובה שלך';

  @override
  String get settingsSecurityQuestionCancelButton => 'ביטול';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'השאלה והתשובה לא יכולות להיות ריקות!';

  @override
  String get settingsSecurityQuestionSaveButton => 'שמור';

  @override
  String get settingsCreatePasswordTitle => 'יצירת סיסמה';

  @override
  String get settingsPasswordRequiredTitle => 'נדרשת סיסמה';

  @override
  String get settingsPasswordEnterHint => 'הזן סיסמה';

  @override
  String get settingsForgotPasswordButton => 'שכחתי את הסיסמה';

  @override
  String get settingsNewPasswordHint => 'סיסמה חדשה';

  @override
  String get settingsConfirmPasswordHint => 'הזן סיסמה שוב';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'הגדר שאלת אבטחה למקרה שתשכח את הסיסמה (אופציונלי).';

  @override
  String get settingsPasswordDialogCancelButton => 'ביטול';

  @override
  String get settingsPasswordMismatchWarning => 'הסיסמאות אינן תואמות!';

  @override
  String get settingsWrongPasswordWarning => 'סיסמה שגויה!';

  @override
  String get settingsPasswordSaveButton => 'שמור';

  @override
  String get settingsPasswordRemoveButton => 'הסר';

  @override
  String get settingsNotePasswordTitle => 'סיסמת פתקית';

  @override
  String get settingsPasswordSetSubtitle => 'הסיסמה הוגדרה ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'הסיסמה לא הוגדרה';

  @override
  String get settingsSecurityQuestionTileTitle => 'שאלת אבטחה';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'הוגדרה ✓ — משמשת אם תשכח את הסיסמה';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'לא הוגדרה — לא תוכל לשחזר את הסיסמה אם תאבד';

  @override
  String get settingsThemeDialogTitle => 'בחר ערכת נושא';

  @override
  String get settingsThemeSystemDefault => 'ברירת מחדל של המערכת';

  @override
  String get settingsThemeLightOption => 'ערכת נושא בהירה';

  @override
  String get settingsThemeDarkOption => 'ערכת נושא כהה';

  @override
  String get settingsLanguageDialogTitle => 'בחר שפה';

  @override
  String get settingsLanguageSystemOption => 'מערכת';

  @override
  String get settingsAccentColorDialogTitle => 'בחר צבע הדגשה';

  @override
  String get settingsThemeChangeTileTitle => 'שנה ערכת נושא';

  @override
  String get settingsThemeLightLabel => 'בהיר';

  @override
  String get settingsThemeDarkLabel => 'כהה';

  @override
  String get settingsThemeSystemLabel => 'מערכת';

  @override
  String get settingsLanguageTileTitle => 'שפה';

  @override
  String get settingsAccentColorTileTitle => 'צבע הדגשה';

  @override
  String get settingsAccentColorTileSubtitle =>
      'הצבע המשמש בסרגל העליון, בכפתורים ובמתגים';

  @override
  String get settingsColorfulNotesTitle => 'גווני צבע מגוונים לפתקיות';

  @override
  String get settingsColorfulNotesSubtitle =>
      'כל כרטיס פתקית מקבל גוון צבע שונה.';

  @override
  String get settingsTextColorSheetTitle => 'צבע טקסט';

  @override
  String get settingsTextColorSheetDesc => 'קובע את צבע טקסט תוכן הפתקית.';

  @override
  String get settingsTextColorOkButton => 'אישור';

  @override
  String get settingsTextColorTileTitle => 'צבע טקסט';

  @override
  String get settingsTextColorTileSubtitle => 'צבע לטקסט תוכן הפתקית.';

  @override
  String get settingsWidgetFontSizeLabel => 'גודל גופן הווידג\'ט';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'כותרת לדוגמה - $size נק\'';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'ביטול';

  @override
  String get settingsWidgetFontSizeApplyButton => 'החל';

  @override
  String get settingsWidgetOpacityLabel => 'שקיפות רקע';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return '$percent% שקיפות';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'ביטול';

  @override
  String get settingsWidgetOpacityApplyButton => 'החל';

  @override
  String get settingsWidgetDarkModeTitle => 'ווידג\'ט כהה';

  @override
  String get settingsWidgetDarkModeDesc => 'ערכת צבעים כהה עבור הווידג\'ט.';

  @override
  String get settingsAboutVersionTitle => 'גרסת האפליקציה';

  @override
  String get settingsFontFamilyTileTitle => 'גופן';

  @override
  String get settingsFontFamilyDefaultLabel => 'ברירת מחדל';

  @override
  String get settingsGlobalFontSizeTileTitle => 'גודל גופן';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size נק\' — חל על כל הפתקיות.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'טקסט לדוגמה - $size נק\'';
  }

  @override
  String get settingsGlobalFontSizeApplyToAllLabel => 'החל על פתקיות קיימות';

  @override
  String get settingsGlobalFontSizeApplyToAllNote =>
      'אם לפתקית מוגדר גודל גופן אישי, הגדרה זו לא תשפיע עליה.';

  @override
  String get settingsGlobalFontSizeCancelButton => 'ביטול';

  @override
  String get settingsGlobalFontSizeApplyButton => 'החל';

  @override
  String get settingsPreviewLinesTileTitle => 'שורות תצוגה מקדימה לפתקית';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'הצג עד $lines שורות. אם הפתקית קצרה יותר, יוצג המספר בפועל של השורות.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'נוכחי: $lines שורות';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'קובע את מספר השורות המרבי לתצוגה מקדימה. אם בפתקית פחות שורות, יוצג המספר בפועל.';

  @override
  String get settingsPreviewLinesCancelButton => 'ביטול';

  @override
  String get settingsPreviewLinesApplyButton => 'החל';

  @override
  String get backupCancelButton => 'ביטול';

  @override
  String get backupConnectButton => 'התחבר';

  @override
  String get backupDisconnectButton => 'התנתק';

  @override
  String get backupContinueButton => 'המשך';

  @override
  String get backupCloseButton => 'סגור';

  @override
  String get backupShareButton => 'שתף';

  @override
  String get backupRestoreButton => 'שחזר';

  @override
  String get backupConfigureButton => 'הגדר';

  @override
  String get backupUnknownDateLabel => 'לא ידוע';

  @override
  String get backupProcessingDefaultLabel => 'מעבד...';

  @override
  String get backupPermissionRequiredTitle => 'נדרשת הרשאת אחסון';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'גרסת אנדרואיד זו דורשת הרשאת אחסון לגיבוי/שחזור. מכיוון שההרשאה נדחתה לצמיתות, יש לאפשר אותה ידנית מהגדרות האפליקציה.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'גרסת אנדרואיד זו דורשת הרשאת אחסון לגיבוי/שחזור. יש להעניק הרשאה כדי להמשיך.';

  @override
  String get backupGoToSettingsButton => 'עבור להגדרות';

  @override
  String get backupRetryButton => 'נסה שוב';

  @override
  String get backupDriveConnectingLabel => 'מתחבר לחשבון Google...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'מחובר לחשבון Google Drive: $email';
  }

  @override
  String get backupDriveConnectedMessage => 'מחובר לחשבון Google Drive.';

  @override
  String get backupDriveConnectFailedMessage =>
      'לא ניתן היה להתחבר לחשבון Google, או שהפעולה בוטלה.';

  @override
  String get backupDriveDisconnectTitle => 'ניתוק Google Drive';

  @override
  String get backupDriveDisconnectBody =>
      'אם תנתק, לא יהיה ניתן לבצע גיבויים ידניים או אוטומטיים ל-Drive. גיבויים שכבר נשמרו ב-Drive לא יימחקו — רק הגישה ממכשיר זה תוסר.';

  @override
  String get backupDriveDisconnectedMessage => 'החיבור ל-Google Drive הוסר.';

  @override
  String get backupDriveRequiredTitle => 'נדרש חשבון Google';

  @override
  String get backupDriveRequiredBody =>
      'פעולה זו מחייבת חיבור לחשבון Google שלך. האם ברצונך להתחבר כעת?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: מחובר ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: מחובר';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: לא מחובר';

  @override
  String get backupDriveAuthenticatingLabel => 'מאמת חשבון Google...';

  @override
  String get backupDriveNotSignedInMessage =>
      'אינך מחובר ל-Google Drive. יש להתחבר תחילה עם חשבון Google שלך.';

  @override
  String get backupDriveUploadingLabel => 'מעלה גיבוי ל-Drive...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'ההעלאה ל-Google Drive לא הושלמה תוך 120 שניות (אין תגובה מהשרת). בדוק את החיבור שלך ונסה שוב.';

  @override
  String get backupDriveOperationCompletedLabel => 'הושלם';

  @override
  String get backupToDriveActionLabel => 'גיבוי ל-Drive';

  @override
  String get backupToDeviceActionLabel => 'גיבוי';

  @override
  String get backupCreatingLabel => 'יוצר גיבוי...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'לא ניתן היה ליצור את הגיבוי: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'ההעלאה ל-Google Drive נכשלה: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'הגיבוי הועלה בהצלחה ל-Google Drive.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'הגיבוי נוצר: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'הגיבוי מוכן';

  @override
  String get backupOfferShareBody =>
      'קובץ הגיבוי נשמר במכשיר שלך. האם ברצונך לשתף אותו כעת (למשל אחסון ענן, אימייל, מכשיר אחר)?';

  @override
  String get backupShareFileText => 'קובץ גיבוי של Layout';

  @override
  String backupShareFailedMessage(String error) {
    return 'לא ניתן היה להתחיל את השיתוף: $error';
  }

  @override
  String get backupLargeOperationTitle => 'גיבוי גדול';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'הנתונים לעיבוד הם בגודל של כ-$sizeText. $actionLabel בגודל כזה עשוי לקחת זמן מה בהתאם למכשיר שלך. רק אל תצא מהאפליקציה בזמן שהפעולה מתבצעת — האם ברצונך להמשיך?';
  }

  @override
  String get backupRestoreActionLabel => 'שחזור';

  @override
  String get backupDriveListingLabel => 'טוען רשימת גיבויים מ-Drive...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'לא ניתן היה לטעון את רשימת הגיבויים: $error';
  }

  @override
  String get backupDriveNoBackupsMessage => 'אין עדיין גיבויים ב-Google Drive.';

  @override
  String get backupDrivePickTitle => 'בחר גיבוי מ-Drive';

  @override
  String get backupDriveDownloadingLabel => 'מוריד גיבוי מ-Drive...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'מוריד גיבוי מ-Drive... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel => 'שומר את הקובץ במכשיר...';

  @override
  String get backupDriveUnknownBackupFileName => 'unknown_backup.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'אחסון ה-Google Drive שלך מלא. פנה מקום ב-Drive ונסה שוב.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'לא ניתן היה ליצור חיבור לאינטרנט. בדוק את החיבור שלך ונסה שוב.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'קובץ הגיבוי המבוקש לא נמצא ב-Drive. ייתכן שנמחק.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'אירעה שגיאה בלתי צפויה במהלך פעולת Google Drive: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'ההורדה נכשלה: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'לא ניתן היה לבחור את הקובץ: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'לא ניתן היה לגשת לקובץ שנבחר.';

  @override
  String get backupCheckingLabel => 'בודק את הגיבוי...';

  @override
  String backupReadFailedMessage(String error) {
    return 'לא ניתן היה לקרוא את קובץ הגיבוי: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'שחזור גיבוי';

  @override
  String get backupPreviewContentsHeader => 'תוכן הגיבוי הנבחר:';

  @override
  String get backupPreviewNoteCountLabel => 'מספר פתקיות';

  @override
  String get backupPreviewTrashCountLabel => 'פתקיות באשפה';

  @override
  String get backupPreviewCategoryCountLabel => 'מספר קטגוריות';

  @override
  String get backupPreviewAttachmentLabel => 'קבצים מצורפים';

  @override
  String get backupPreviewAttachmentNoneValue => 'ללא';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count קבצים ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'נוצר בתאריך';

  @override
  String get backupEmptyPreviewTitle => 'נראה שהגיבוי הזה ריק';

  @override
  String get backupEmptyPreviewBody =>
      'לא נמצאו פתקיות, קטגוריות או קבצים מצורפים בקובץ הנבחר. אם תמשיך, הנתונים הנוכחיים שלך עדיין יימחקו ויוחלפו בגיבוי הריק הזה.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '$count קבצים מצורפים לא נמצאו בגיבוי';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'פתקיות עם קבצים אלה ישוחזרו, אך ללא הקבצים המצורפים (ייתכן שהיו חסרים או פגומים בעת ביצוע הגיבוי): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown ועוד $remaining';
  }

  @override
  String get backupRestoreConfirmBody =>
      'פעולה זו תחליף את כל הפתקיות, האשפה, הקטגוריות, ההגדרות והקבצים המצורפים הנוכחיים שלך בנתונים מהגיבוי שלמעלה. הנתונים הנוכחיים שלך יאבדו לצמיתות ולא ניתן לבטל פעולה זו.';

  @override
  String get backupRestoringLabel => 'משחזר גיבוי...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'הגיבוי שוחזר. עם זאת, $count קבצים מצורפים לא נמצאו בגיבוי ולא ניתן היה לשחזר אותם. מומלץ להפעיל מחדש את האפליקציה כדי שהשינויים ייכנסו לתוקף באופן מלא.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'הגיבוי שוחזר בהצלחה. מומלץ להפעיל מחדש את האפליקציה כדי שהשינויים ייכנסו לתוקף באופן מלא.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'אירעה שגיאה בעת השחזור: $error';
  }

  @override
  String get backupScreenTitle => 'גיבוי ושחזור';

  @override
  String get backupBlockedExitWarningMessage =>
      'פעולה מתבצעת כעת, יש להמתין לסיומה.';

  @override
  String get backupBusyBackTooltip => 'פעולה מתבצעת';

  @override
  String get backupIntroText =>
      'תוכל לגבות את הפתקיות, הקטגוריות, ההגדרות והקבצים המצורפים שלך כקובץ ‎.zip אחד, או לשחזר גיבוי שביצעת בעבר.';

  @override
  String get backupDriveCardTitle => 'גיבוי ל-Google Drive';

  @override
  String get backupDriveCardSubtitle =>
      'צור גיבוי חדש והעלה אותו ישירות לאזור הפרטי שלך ב-Google Drive.';

  @override
  String get backupDriveCardButtonLabel => 'גבה ל-Drive';

  @override
  String get backupDeviceCardTitle => 'גיבוי למכשיר';

  @override
  String get backupDeviceCardSubtitle =>
      'שמור את כל הנתונים שלך כקובץ ‎.zip אחד במכשיר שלך ושתף אותו אם תרצה.';

  @override
  String get backupDeviceCardButtonLabel => 'גבה למכשיר';

  @override
  String get backupHistoryCardTitle => 'היסטוריית גיבויים';

  @override
  String get backupHistoryCardSubtitle =>
      'צפה בכל הגיבויים השמורים במכשיר שלך עם התאריך והגודל שלהם; תוכל לשתף, לשחזר או למחוק אותם ישירות מכאן.';

  @override
  String get backupHistoryTabDevice => 'מכשיר';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'מחיקת גיבוי';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'האם אתה בטוח שברצונך למחוק לצמיתות את קובץ הגיבוי \"$fileName\"? לא ניתן לבטל פעולה זו.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'הגיבוי נמחק.';

  @override
  String get backupHistoryDriveDeleteDialogTitle => 'מחיקת גיבוי מ-Drive';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'האם אתה בטוח שברצונך למחוק לצמיתות את הגיבוי \"$fileName\" מ-Google Drive? לא ניתן לבטל פעולה זו והקובץ לא יועבר לאשפה.';
  }

  @override
  String get backupHistoryDriveDeletedMessage => 'גיבוי ה-Drive נמחק.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'לא ניתן היה למחוק: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'אין עדיין גיבויים שמורים במכשיר זה.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'השתמש ב\"גיבוי למכשיר\" כדי ליצור את הגיבוי הראשון שלך.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'השתמש ב\"גיבוי ל-Google Drive\" כדי ליצור את גיבוי הענן הראשון שלך.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'חבר את חשבון Google שלך כדי לראות את גיבויי ה-Drive שלך.';

  @override
  String get backupHistoryConnectGoogleButton => 'התחבר עם Google';

  @override
  String get backupHistoryDriveConnectedFallback => 'מחובר';

  @override
  String get backupHistoryUnknownErrorFallback => 'אירעה שגיאה לא ידועה.';

  @override
  String get backupHistoryDownloadStartingLabel => 'מתחיל...';

  @override
  String get backupAutoBackupEnabledLabel => 'גיבוי אוטומטי: פעיל';

  @override
  String get backupAutoBackupDisabledLabel => 'גיבוי אוטומטי: כבוי';

  @override
  String get backupOverlayWarningMessage =>
      'נא להמתין, אל תצא מהאפליקציה עד לסיום הפעולה.';

  @override
  String get pdfExportUntitledNoteLabel => 'פתקית ללא כותרת';

  @override
  String get pdfExportDefaultAttachmentName => 'קובץ מצורף';

  @override
  String get pdfExportDefaultFileName => 'note';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'לא ניתן היה לצלם מסך (הגבול לא נמצא)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'לא ניתן היה ליצור את נתוני צילום המסך';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'לא ניתן היה לעבד את התמונה (פענוח PNG נכשל)';

  @override
  String get screenshotCalcTableTotalLabel => 'סה\"כ';

  @override
  String get gundemMenuRemoveFromAgenda => 'הסר מסדר היום';

  @override
  String get gundemMenuDeleteNote => 'מחק פתקית';

  @override
  String get gundemSectionOverdue => 'באיחור';

  @override
  String get gundemSectionToday => 'היום';

  @override
  String get gundemSectionTomorrow => 'מחר';

  @override
  String get gundemSectionNextWeek => 'השבוע הבא';

  @override
  String get gundemSectionFurther => 'בהמשך';

  @override
  String get gundemWeekdayMonday => 'יום שני';

  @override
  String get gundemWeekdayTuesday => 'יום שלישי';

  @override
  String get gundemWeekdayWednesday => 'יום רביעי';

  @override
  String get gundemWeekdayThursday => 'יום חמישי';

  @override
  String get gundemWeekdayFriday => 'יום שישי';

  @override
  String get gundemWeekdaySaturday => 'יום שבת';

  @override
  String get gundemWeekdaySunday => 'יום ראשון';

  @override
  String get gundemAppBarTitle => 'סדר יום';

  @override
  String get gundemCalendarTooltip => 'לוח שנה';

  @override
  String get gundemEmptyTitle => 'אין דבר בסדר היום שלך';

  @override
  String get gundemEmptySubtitle =>
      'פתקיות עם תזכורת או תאריך משויך יופיעו כאן.';

  @override
  String get gundemUntitledNote => 'פתקית ללא כותרת';

  @override
  String get gundemRepeatHourly => 'כל שעה';

  @override
  String get gundemRepeatDaily => 'יומי';

  @override
  String get gundemRepeatWeekly => 'שבועי';

  @override
  String get gundemRepeatMonthly => 'חודשי';

  @override
  String get gundemRepeatYearly => 'שנתי';

  @override
  String get gundemPreviewCalcTableLabel => '[רשימת חישוב]';

  @override
  String get gundemPreviewDrawingLabel => '[ציור]';

  @override
  String get gundemPreviewImageLabel => '[תמונה]';

  @override
  String get gundemMonthShortJan => 'ינו׳';

  @override
  String get gundemMonthShortFeb => 'פבר׳';

  @override
  String get gundemMonthShortMar => 'מרץ';

  @override
  String get gundemMonthShortApr => 'אפר׳';

  @override
  String get gundemMonthShortMay => 'מאי';

  @override
  String get gundemMonthShortJun => 'יונ׳';

  @override
  String get gundemMonthShortJul => 'יול׳';

  @override
  String get gundemMonthShortAug => 'אוג׳';

  @override
  String get gundemMonthShortSep => 'ספט׳';

  @override
  String get gundemMonthShortOct => 'אוק׳';

  @override
  String get gundemMonthShortNov => 'נוב׳';

  @override
  String get gundemMonthShortDec => 'דצמ׳';

  @override
  String get calendarAppBarTitle => 'לוח שנה';

  @override
  String get calendarTodayButton => 'היום';

  @override
  String get calendarLegendNoteLabel => 'פתקית';

  @override
  String get calendarLegendReminderLabel => 'תזכורת';

  @override
  String get calendarTodayBadge => 'היום';

  @override
  String get calendarEmptyDayMessage => 'אין פתקיות או תזכורות ליום זה.';

  @override
  String get calendarReminderHourlyLabel => 'כל שעה';

  @override
  String get calendarMonthJan => 'ינואר';

  @override
  String get calendarMonthFeb => 'פברואר';

  @override
  String get calendarMonthMar => 'מרץ';

  @override
  String get calendarMonthApr => 'אפריל';

  @override
  String get calendarMonthMay => 'מאי';

  @override
  String get calendarMonthJun => 'יוני';

  @override
  String get calendarMonthJul => 'יולי';

  @override
  String get calendarMonthAug => 'אוגוסט';

  @override
  String get calendarMonthSep => 'ספטמבר';

  @override
  String get calendarMonthOct => 'אוקטובר';

  @override
  String get calendarMonthNov => 'נובמבר';

  @override
  String get calendarMonthDec => 'דצמבר';

  @override
  String get calendarWeekdayShortMon => 'ב׳';

  @override
  String get calendarWeekdayShortTue => 'ג׳';

  @override
  String get calendarWeekdayShortWed => 'ד׳';

  @override
  String get calendarWeekdayShortThu => 'ה׳';

  @override
  String get calendarWeekdayShortFri => 'ו׳';

  @override
  String get calendarWeekdayShortSat => 'ש׳';

  @override
  String get calendarWeekdayShortSun => 'א׳';

  @override
  String get calendarWeekdayFullMonday => 'יום שני';

  @override
  String get calendarWeekdayFullTuesday => 'יום שלישי';

  @override
  String get calendarWeekdayFullWednesday => 'יום רביעי';

  @override
  String get calendarWeekdayFullThursday => 'יום חמישי';

  @override
  String get calendarWeekdayFullFriday => 'יום שישי';

  @override
  String get calendarWeekdayFullSaturday => 'יום שבת';

  @override
  String get calendarWeekdayFullSunday => 'יום ראשון';

  @override
  String get wrongPasswordDialogTitle => 'סיסמה שגויה';

  @override
  String get wrongPasswordDialogMessage => 'הסיסמה שהזנת שגויה.';

  @override
  String get commonOkButton => 'אישור';

  @override
  String get unlockCategoryAction => 'בטל נעילה';

  @override
  String get lockCategoryAction => 'נעל';

  @override
  String get categoryUnlockedMessage => 'בוטלה הנעילה';

  @override
  String get categoryLockedMessage => 'התיקייה ננעלה';

  @override
  String get deleteFolderMenuItemLabel => 'מחק תיקייה';

  @override
  String get deleteFolderDialogTitle => 'מחיקת תיקייה';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'האם אתה בטוח שברצונך למחוק את התיקייה \"$category\" ואת כל תת-התיקיות שלה? הפתקיות בתיקיות אלה יהפכו ללא מסווגות.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'האם אתה בטוח שברצונך למחוק את התיקייה \"$category\"? הפתקיות בתיקייה זו יהפכו ללא מסווגות.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'ביטול';

  @override
  String get deleteFolderDialogConfirmButton => 'מחק';

  @override
  String get editCategoryNameColorMenuItemLabel => 'ערוך שם / צבע';

  @override
  String get addSubfolderMenuItemLabel => 'צור תת-תיקייה';

  @override
  String get expandSubfoldersMenuItemLabel => 'הרחב תת-תיקיות';

  @override
  String get collapseSubfoldersMenuItemLabel => 'כווץ תת-תיקיות';

  @override
  String saveErrorInfoMessage(String error) {
    return 'שגיאת שמירה: $error';
  }

  @override
  String get welcomeNoteTitle => 'ברוכים הבאים ל-DNote! 🚀';

  @override
  String get welcomeNoteContent => 'נוספו תכונות חדשות!';

  @override
  String get noteListDateGroupToday => 'היום';

  @override
  String get noteListDateGroupYesterday => 'אתמול';

  @override
  String get noteListDateGroupLast7Days => '7 הימים האחרונים';

  @override
  String get noteListDateGroupLast30Days => '30 הימים האחרונים';

  @override
  String get reminderRepeatNoneLabel => 'ללא חזרה';

  @override
  String get voiceRecorderPreparingLabel => 'מכין…';

  @override
  String get voiceRecorderCancelButton => 'ביטול';

  @override
  String get voiceRecorderStopAddButton => 'עצור והוסף';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'הרשאת המיקרופון לא ניתנה.';

  @override
  String get speechToTextUnavailableMessage =>
      'זיהוי דיבור אינו זמין במכשיר זה.';

  @override
  String get speechToTextPreparingLabel => 'מכין…';

  @override
  String get speechToTextListeningLabel => 'מאזין…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'התחל לדבר…';

  @override
  String get speechToTextCancelButton => 'ביטול';

  @override
  String get speechToTextStopAddButton => 'עצור והוסף';

  @override
  String get textToSpeechNoContentMessage => 'אין תוכן לקריאה.';

  @override
  String get textToSpeechReadErrorMessage => 'אירעה שגיאה בעת ההקראה.';

  @override
  String get textToSpeechUnavailableMessage =>
      'המרת טקסט לדיבור אינה זמינה במכשיר זה.';

  @override
  String get textToSpeechPreparingLabel => 'מכין…';

  @override
  String get textToSpeechPausedLabel => 'מושהה';

  @override
  String get textToSpeechFinishedLabel => 'ההקראה הושלמה';

  @override
  String get textToSpeechReadingLabel => 'מקריא…';

  @override
  String get textToSpeechCloseErrorButton => 'סגור';

  @override
  String get textToSpeechReplayButton => 'הקרא שוב';

  @override
  String get textToSpeechCloseFinishedButton => 'סגור';

  @override
  String get textToSpeechPauseButton => 'השהה';

  @override
  String get textToSpeechResumeButton => 'המשך';

  @override
  String get textToSpeechStopButton => 'עצור';

  @override
  String get textToSpeechSpeedSlow => 'איטי';

  @override
  String get textToSpeechSpeedNormal => 'רגיל';

  @override
  String get textToSpeechSpeedFast => 'מהיר';

  @override
  String get calendarPickerCancelButton => 'ביטול';

  @override
  String get calendarPickerConfirmButton => 'בחר';

  @override
  String get calendarPickerClearButton => 'נקה';

  @override
  String get reminderPickerDialogTitle => 'הוסף תזכורת';

  @override
  String get reminderPickerDateTodayOption => 'היום';

  @override
  String get reminderPickerDateTomorrowOption => 'מחר';

  @override
  String get reminderPickerDatePickOption => 'בחר תאריך';

  @override
  String get reminderRepeatHourlyLabel => 'כל שעה';

  @override
  String get reminderRepeatDailyLabel => 'כל יום';

  @override
  String get reminderRepeatWeeklyLabel => 'כל שבוע';

  @override
  String get reminderRepeatMonthlyLabel => 'כל חודש';

  @override
  String get reminderRepeatYearlyLabel => 'כל שנה';

  @override
  String get reminderPickerCalendarHelpText => 'בחר תאריך לתזכורת';

  @override
  String get reminderPickerCancelButton => 'ביטול';

  @override
  String get reminderPickerSaveButton => 'שמור';

  @override
  String get reminderPickerPastTimeErrorMessage => 'לא ניתן לבחור זמן שכבר עבר';

  @override
  String calcTableTotalLabel(String amount) {
    return 'סה\"כ: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'מכין נתונים...';

  @override
  String get backupCreatePackagingNotesLabel => 'אורז פתקיות וקטגוריות...';

  @override
  String get backupCreateReadingAttachmentsLabel => 'קורא קבצים מצורפים...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'קורא קבצים מצורפים... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'דוחס קובץ zip...';

  @override
  String get backupCreateSavingFileLabel => 'שומר קובץ...';

  @override
  String get backupRestoreValidatingLabel => 'מאמת את הגיבוי...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'הגיבוי אומת, מכין נתונים...';

  @override
  String get backupRestoreWritingNotesLabel => 'כותב פתקיות...';

  @override
  String get backupRestoreWritingTrashLabel => 'כותב אשפה...';

  @override
  String get backupRestoreTrashWrittenLabel => 'האשפה נכתבה';

  @override
  String get backupRestoreWritingCategoriesLabel => 'כותב קטגוריות...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'הקטגוריות נכתבו';

  @override
  String get backupRestoreWritingSettingsLabel => 'כותב הגדרות...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'ההגדרות נכתבו';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'מנקה קבצים מצורפים ישנים...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'לא נמצאו קבצים מצורפים, מסיים...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'משחזר קבצים מצורפים... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'הושלם';

  @override
  String get backupValidationCorruptedFileMessage =>
      'הקובץ פגום או שאינו קובץ גיבוי תקין.';

  @override
  String get backupValidationMissingDataMessage =>
      'לא נמצאו נתונים בתוך קובץ הגיבוי (backup_data.json חסר).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'לא ניתן היה לקרוא את נתוני הגיבוי (JSON פגום).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'קובץ זה אינו גיבוי מאפליקציית dnote.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'לא ניתן היה לקרוא את פרטי הגרסה של קובץ הגיבוי.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'גיבוי זה בפורמט חדש יותר שאינו נתמך על ידי גרסת האפליקציה הנוכחית. יש לעדכן את האפליקציה.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'פרטי הגרסה של קובץ הגיבוי אינם תקינים.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'נתוני הגיבוי אינם בפורמט הצפוי (שדה הפתקיות חסר).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'נתוני הגיבוי אינם בפורמט הצפוי (שדה האשפה חסר).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'נתוני הגיבוי אינם בפורמט הצפוי (רשימת הקטגוריות אינה תקינה).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'נתוני הגיבוי אינם בפורמט הצפוי (שדה ההגדרות אינו תקין).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'נתוני הגיבוי אינם בפורמט הצפוי (רשומת פתקית אינה תקינה).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'נתוני הגיבוי אינם בפורמט הצפוי (נמצאה רשומת פתקית ללא מזהה).';

  @override
  String get backupValidationFileNotFoundMessage => 'קובץ הגיבוי לא נמצא.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'אין מספיק שטח פנוי במכשיר. יש לפנות מקום ולנסות שוב.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'הרשאת הגישה לקובץ נדחתה. בדוק את הרשאות האפליקציה ונסה שוב.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'אירעה שגיאה במהלך פעולת הקובץ: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'אירעה שגיאה בלתי צפויה: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'לא ניתן היה ליצור את קובץ ה-zip (ZipEncoder החזיר null).';

  @override
  String get calcTableMenuItemLabel => 'רשימת חישוב';

  @override
  String get tagsMenuItemLabel => 'תגים';

  @override
  String get linkDialogUrlHint => 'https://example.com';

  @override
  String get checklistItemHint => 'הוסף פריט...';

  @override
  String get toolbarHighlightTooltip => 'הדגשה';

  @override
  String get toolbarListTooltip => 'רשימה';

  @override
  String get toolbarHideKeyboardTooltip => 'הסתר מקלדת';

  @override
  String get autoBackupLocalSuccessMessage => 'הגיבוי המקומי הצליח.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'הגיבוי המקומי נכשל: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'גיבוי ה-Drive דולג: חשבון Google אינו מחובר או שפג תוקף ההתחברות. יש לפתוח את האפליקציה ולהתחבר מחדש.';

  @override
  String get autoBackupDriveSuccessMessage => 'הגיבוי ל-Drive הצליח.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'הגיבוי ל-Drive נכשל: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'אין עדיין פתקיות';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'סה\"כ: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ ציור';

  @override
  String get autoBackupSettingsAppBarTitle => 'הגדרות גיבוי אוטומטי';

  @override
  String get autoBackupSettingsMainSwitchTitle => 'אפשר גיבוי אוטומטי';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'הפתקיות שלך מגובות באופן מאובטח מעת לעת ברקע.';

  @override
  String get autoBackupSettingsTargetTitle => 'יעד הגיבוי';

  @override
  String get autoBackupSettingsTargetSubtitle => 'בחר היכן יישמרו הגיבויים.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'מקומי';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'שניהם';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'חבר תחילה את חשבונך כדי להשתמש באפשרויות Google Drive.';

  @override
  String get autoBackupSettingsConnectButton => 'התחבר';

  @override
  String get autoBackupSettingsFrequencyTitle => 'תדירות גיבוי';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'מתבצע גיבוי כל $hours שעות.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 שעות';

  @override
  String get autoBackupSettingsFrequency12h => '12 שעות';

  @override
  String get autoBackupSettingsFrequency24h => '24 שעות (יומי)';

  @override
  String get autoBackupSettingsFrequency48h => '48 שעות (יומיים)';

  @override
  String get autoBackupSettingsFrequency168h => '168 שעות (שבועי)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'השתמש ב-Wi-Fi בלבד';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'ההעלאה לענן מתבצעת רק דרך Wi-Fi כדי לחסוך בנתונים הסלולריים שלך.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'מצב המערכת';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'הגיבוי האוטומטי עדיין לא פעל.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'הרצה אחרונה: $date $time ($status)\\nהודעה: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'הצליח';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'נכשל';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'לא ניתן היה להתחבר לחשבון Google.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'הגדרות הגיבוי האוטומטי עודכנו.';

  @override
  String selectionModeDeletedMessage(int count) {
    return '$count פתקיות נמחקו';
  }

  @override
  String get selectionModeArchivedMessage => 'הועבר לארכיון';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'בחר קטגוריה עבור $count פתקיות';
  }

  @override
  String get selectionModeAddCategoryOption => 'הוסף קטגוריה';

  @override
  String get selectionModeRemoveCategoryOption => 'הסר קטגוריה';

  @override
  String get calcTableItemHint => 'פריט...';

  @override
  String get calcTableTotalRowLabel => 'סה\"כ';

  @override
  String get textSelectionMenuShareButton => 'שתף';

  @override
  String get textSelectionMenuTranslateButton => 'תרגם';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'לא ניתן היה להתחיל את השיתוף.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'לא ניתן היה לפתוח את התרגום.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'היום $time';
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
    return 'גיבוי אחרון: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage => 'עדיין לא בוצע גיבוי.';
}
