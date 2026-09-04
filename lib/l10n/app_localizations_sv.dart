// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'Fet';

  @override
  String get toolbarItalicTooltip => 'Kursiv';

  @override
  String get toolbarUnderlineTooltip => 'Understruken';

  @override
  String get toolbarStrikethroughTooltip => 'Genomstruken';

  @override
  String get toolbarFontSizeTooltip => 'Textstorlek';

  @override
  String get toolbarColorTooltip => 'Textfärg';

  @override
  String get toolbarBulletTooltip => 'Punktlista';

  @override
  String get toolbarNumberTooltip => 'Numrerad lista';

  @override
  String get toolbarIndentTooltip => 'Styckeindrag';

  @override
  String get toolbarLinkTooltip => 'Lägg till/redigera/ta bort länk';

  @override
  String get toolbarDividerTooltip => 'Infoga avdelare';

  @override
  String get toolbarChecklistTooltip => 'Lägg till checklista';

  @override
  String get linkSelectTextSnackbar => 'Markera texten du vill länka först';

  @override
  String get linkDialogEditTitle => 'Redigera länk';

  @override
  String get linkDialogAddTitle => 'Lägg till länk';

  @override
  String get linkDialogRemoveButton => 'Ta bort länk';

  @override
  String get linkDialogCancelButton => 'Avbryt';

  @override
  String get linkDialogConfirmButton => 'Lägg till';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Kameraåtkomst nekad. Du måste tillåta det i inställningarna för att spela in video.';

  @override
  String get cameraPermissionRequiredMessage =>
      'Kameraåtkomst krävs för att spela in video.';

  @override
  String get openSettingsButtonLabel => 'Inställningar';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'Skanningen kunde inte startas: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'Textigenkänning misslyckades: $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'Ingen läsbar text hittades i dokumentet';

  @override
  String get scanResultSheetTitle =>
      'Hur ska det skannade dokumentet läggas till?';

  @override
  String get scanResultTextOnlyOption => 'Lägg till som endast text';

  @override
  String get scanResultTextAndImageOption => 'Lägg till text + skannad bild';

  @override
  String get scanResultCancelOption => 'Avbryt';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'Mikrofonåtkomst nekad. Du måste tillåta det i inställningarna för att spela in ljud.';

  @override
  String get audioPermissionRequiredMessage =>
      'Mikrofonåtkomst krävs för att spela in ljud.';

  @override
  String get voiceRecordingDefaultLabel => 'Röstinspelning';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'Beräkningslista ($count rader)';
  }

  @override
  String blockPreviewTableLabel(int count) {
    return 'Tabell ($count rader)';
  }

  @override
  String get blockPreviewDrawingLabel => 'Teckning';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count bilagor (foto/dokument)';
  }

  @override
  String get blockPreviewDividerLabel => 'Avdelare';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'Checklista ($count objekt)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(tom text)';

  @override
  String get reorderBlocksSheetTitle => 'Ändra ordning på block';

  @override
  String get reorderBlocksMoveUpTooltip => 'Flytta upp';

  @override
  String get reorderBlocksMoveDownTooltip => 'Flytta ner';

  @override
  String get reorderBlocksCloseTooltip => 'Stäng';

  @override
  String get reorderBlocksDescription =>
      'Tryck på ett block för att markera det, använd sedan pilarna upp/ner för att flytta det.';

  @override
  String get reorderBlocksMenuItemLabel => 'Ändra ordning';

  @override
  String get txtImportPickerDialogTitle => 'Välj TXT-filen som ska importeras';

  @override
  String get txtImportReadFailedMessage => 'TXT-filen kunde inte läsas';

  @override
  String get txtImportEmptyFileMessage => 'TXT-filen är tom';

  @override
  String get txtImportSuccessMessage => 'TXT importerad';

  @override
  String get txtImportMenuItemLabel => 'Importera (txt)';

  @override
  String get exportMenuItemLabel => 'Exportera';

  @override
  String get editorUndoTooltip => 'Ångra';

  @override
  String get editorRedoTooltip => 'Gör om';

  @override
  String get noteSavedMessage => 'Anteckning sparad';

  @override
  String get dateAssignPickerHelpText => 'Tilldela anteckning till en dag';

  @override
  String get dateAssignChangeOption => 'Ändra datum';

  @override
  String get dateAssignRemoveOption => 'Ta bort tilldelning';

  @override
  String get editorSubToolbarCloseTooltip => 'Stäng';

  @override
  String get titleFieldHint => 'Titel';

  @override
  String get textBlockHint => 'Skriv din anteckning här...';

  @override
  String get drawingBoardMenuItemLabel => 'Ritbord';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'Tal till text är endast tillgängligt för textanteckningar';

  @override
  String get selectionModeCancelTooltip => 'Avbryt markering';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return '$count markerade';
  }

  @override
  String get selectionModeDeleteTooltip => 'Ta bort';

  @override
  String get selectionModeArchiveTooltip => 'Arkivera';

  @override
  String get selectionModeFolderTooltip => 'Mapp';

  @override
  String get searchFieldHint => 'Sök anteckningar...';

  @override
  String get emptyTrashDialogTitle => 'Töm papperskorgen';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'Alla raderade anteckningar tas bort permanent. Är du säker?';

  @override
  String get emptyTrashDialogCancelButton => 'Avbryt';

  @override
  String get restoreAllMenuItemLabel => 'Återställ alla';

  @override
  String get sortMenuTooltip => 'Sortera anteckningar';

  @override
  String get sortMenuAscendingLabel => 'Ordning: Stigande (A-Ö)';

  @override
  String get sortMenuDescendingLabel => 'Ordning: Fallande (Ö-A)';

  @override
  String get sortMenuByTitleLabel => 'Sortera efter: Titel';

  @override
  String get sortMenuByModifiedDateLabel => 'Sortera efter: Senast ändrad';

  @override
  String get sortMenuByCreatedDateLabel => 'Sortera efter: Skapandedatum';

  @override
  String get sortMenuByFolderLabel => 'Sortera efter: Mapp';

  @override
  String get viewToggleGridTooltip => 'Rutnätsvy';

  @override
  String get viewToggleListTooltip => 'Listvy';

  @override
  String get drawerHeaderSubtitle => 'Din personliga anteckningsbok';

  @override
  String get drawerNotesSectionHeader => 'ANTECKNINGAR';

  @override
  String get drawerAllNotesLabel => 'Anteckningar';

  @override
  String get drawerFavoritesLabel => 'Favorit';

  @override
  String get drawerAgendaLabel => 'Agenda';

  @override
  String get drawerRemindersLabel => 'Påminnelse';

  @override
  String get drawerLockedLabel => 'Låst';

  @override
  String get drawerTrashLabel => 'Papperskorg';

  @override
  String get drawerFoldersSectionHeader => 'MAPPAR';

  @override
  String get drawerExpandLabel => 'Expandera';

  @override
  String get drawerCollapseLabel => 'Fäll ihop';

  @override
  String get drawerAddFolderLabel => 'Lägg till mapp';

  @override
  String get drawerAppSectionHeader => 'APP';

  @override
  String get drawerCalendarLabel => 'Kalender';

  @override
  String get drawerSettingsLabel => 'Inställningar';

  @override
  String get drawerBackupRestoreLabel => 'Säkerhetskopiering & återställning';

  @override
  String get drawerUpgradeToProLabel => 'Uppgradera till Pro';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'Stöd utvecklingen';

  @override
  String get drawerFeedbackLabel => 'Feedback';

  @override
  String get drawerRateAppLabel => 'Betygsätt appen';

  @override
  String get drawerAboutLabel => 'Om';

  @override
  String get noNotesFoundMessage => 'Inga anteckningar hittades.';

  @override
  String get trashRestoreButtonLabel => 'Återställ';

  @override
  String get trashPermanentDeleteButtonLabel => 'Ta bort permanent';

  @override
  String get tagRenamedInfoMessage => 'Taggen omdöpt';

  @override
  String get tagDeletedInfoMessage => 'Taggen borttagen';

  @override
  String get tagOptionsRenameLabel => 'Byt namn';

  @override
  String get tagOptionsDeleteLabel => 'Ta bort';

  @override
  String get renameTagDialogTitle => 'Byt namn på tagg';

  @override
  String get renameTagDialogHint => 'Nytt taggnamn';

  @override
  String get renameTagDialogCancelButton => 'Avbryt';

  @override
  String get renameTagDialogSaveButton => 'Spara';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '\"$tag\" tas bort från $affectedCount anteckningar. Fortsätta?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'Ta bort taggen \"$tag\"?';
  }

  @override
  String get deleteTagDialogTitle => 'Ta bort tagg';

  @override
  String get deleteTagDialogCancelButton => 'Avbryt';

  @override
  String get deleteTagDialogConfirmButton => 'Ta bort';

  @override
  String get tagsSheetTitle => 'Taggar';

  @override
  String get tagsSheetEmptyMessage => 'Inga taggar på denna anteckning ännu.';

  @override
  String get tagsSheetInputHint => 'Skriv en ny tagg...';

  @override
  String get tagsSheetSuggestionsLabel => 'Befintliga taggar';

  @override
  String get noteDeletedInfoMessage => 'Anteckning borttagen';

  @override
  String get noteDeletedUndoActionLabel => 'Ångra';

  @override
  String get reminderSetInfoMessage => 'Påminnelse inställd';

  @override
  String get reminderRemovedInfoMessage => 'Påminnelse borttagen';

  @override
  String get noteDuplicatedInfoMessage => 'Kopia skapad';

  @override
  String get speechTextAppendedInfoMessage => 'Text tillagd i anteckning';

  @override
  String get pdfPreparingInfoMessage => 'Förbereder PDF…';

  @override
  String get pdfSavedInfoMessage => 'PDF sparad';

  @override
  String get pdfPreviewSaveActionLabel => 'Spara';

  @override
  String get jpgPreparingInfoMessage => 'Förbereder JPG…';

  @override
  String get jpgSavedInfoMessage => 'JPG sparad';

  @override
  String get jpgFailedInfoMessage => 'Kunde inte skapa JPG';

  @override
  String get txtPreparingInfoMessage => 'Förbereder TXT…';

  @override
  String get txtSavedInfoMessage => 'TXT sparad';

  @override
  String get txtFailedInfoMessage => 'Kunde inte skapa TXT';

  @override
  String get exportOpenActionLabel => 'Öppna';

  @override
  String get wrongPasswordInfoMessage => 'Fel lösenord.';

  @override
  String get noteArchivedInfoMessage => 'Anteckning arkiverad';

  @override
  String get noteUnarchivedInfoMessage => 'Borttagen från arkivet';

  @override
  String get noteUnlockedInfoMessage => 'Upplåst';

  @override
  String get noteLockedInfoMessage => 'Anteckning låst';

  @override
  String get notificationUnpinnedInfoMessage => 'Nålen borttagen';

  @override
  String get emptyNotePinBlockedInfoMessage =>
      'En tom anteckning kan inte nålas fast.';

  @override
  String get notificationPinnedInfoMessage => 'Fastnålad i aviseringspanelen';

  @override
  String get noContentToReadInfoMessage => 'Det finns inget innehåll att läsa';

  @override
  String get backPressExitInfoMessage => 'Tryck tillbaka igen för att avsluta';

  @override
  String get reminderChannelName => 'Anteckningspåminnelser';

  @override
  String get reminderChannelDescription =>
      'Anteckningspåminnelser i appen Layout';

  @override
  String get pinnedChannelName => 'Fastnålade anteckningar';

  @override
  String get pinnedChannelDescription =>
      'Layout-anteckningar fastnålade i aviseringspanelen';

  @override
  String get notificationUnpinActionLabel => 'Ta bort';

  @override
  String get reminderDefaultTitle => 'Påminnelse';

  @override
  String get reminderChecklistBodyFallback =>
      'Glöm inte att kontrollera din checklista';

  @override
  String get reminderTextBodyFallback =>
      'Glöm inte att kontrollera din anteckning';

  @override
  String get pdfSaveDialogTitle => 'Spara som PDF';

  @override
  String get jpgSaveDialogTitle => 'Spara som JPG';

  @override
  String get txtSaveDialogTitle => 'Spara som TXT';

  @override
  String get textSizeSheetTitle => 'Textstorlek';

  @override
  String get textSizeSamplePreview => 'Exempeltext';

  @override
  String get textSizeCancelButton => 'Avbryt';

  @override
  String get textSizeApplyButton => 'Verkställ';

  @override
  String get createPasswordDialogTitle => 'Skapa lösenord';

  @override
  String get createPasswordNewPasswordHint => 'Nytt lösenord';

  @override
  String get createPasswordConfirmHint => 'Ange lösenord igen';

  @override
  String get createPasswordHintQuestionDescription =>
      'Ställ in en säkerhetsfråga i fall du glömmer ditt lösenord (valfritt).';

  @override
  String get createPasswordHintQuestionHint => 'Välj en säkerhetsfråga';

  @override
  String get createPasswordHintAnswerHint => 'Ditt svar';

  @override
  String get createPasswordCancelButton => 'Avbryt';

  @override
  String get createPasswordSaveButton => 'Spara';

  @override
  String get passwordMismatchMessage => 'Lösenorden matchar inte!';

  @override
  String get passwordRequiredDialogTitle => 'Lösenord krävs';

  @override
  String get passwordRequiredHint => 'Ange lösenord';

  @override
  String get forgotPasswordButtonLabel => 'Jag har glömt mitt lösenord';

  @override
  String get passwordRequiredCancelButton => 'Avbryt';

  @override
  String get passwordRequiredConfirmButton => 'Verifiera';

  @override
  String get securityQuestionDialogTitle => 'Säkerhetsfråga';

  @override
  String get securityQuestionAnswerHint => 'Ditt svar';

  @override
  String get securityQuestionCancelButton => 'Avbryt';

  @override
  String get securityQuestionConfirmButton => 'Bekräfta';

  @override
  String get securityQuestionWrongAnswerMessage => 'Fel svar. Försök igen.';

  @override
  String get revealedPasswordDialogTitle => 'Ditt lösenord';

  @override
  String get revealedPasswordLabel => 'Ditt anteckningslösenord:';

  @override
  String get revealedPasswordOkButton => 'OK';

  @override
  String get securityQuestionPetName => 'Vad heter ditt första husdjur?';

  @override
  String get securityQuestionFavoriteTeacher => 'Vad heter din favoritlärare?';

  @override
  String get securityQuestionBirthCity => 'I vilken stad är du född?';

  @override
  String get securityQuestionFavoriteFood => 'Vad är din favoritmat?';

  @override
  String get securityQuestionMotherMaidenName => 'Vad är din mors flicknamn?';

  @override
  String get securityQuestionFirstSchool =>
      'Vad heter den första skolan du gick i?';

  @override
  String get securityQuestionFavoriteColor => 'Vad är din favoritfärg?';

  @override
  String get editFolderDialogTitle => 'Redigera mapp';

  @override
  String get newSubfolderDialogTitle => 'Ny undermapp';

  @override
  String get addFolderDialogTitle => 'Lägg till mapp';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'Skapas inuti \"$parentCategory\"';
  }

  @override
  String get subfolderNameFieldLabel => 'Undermappens namn';

  @override
  String get folderNameFieldLabel => 'Mappnamn';

  @override
  String get folderColorLabel => 'Färg';

  @override
  String get folderDialogCancelButton => 'Avbryt';

  @override
  String get folderDialogSaveButton => 'Spara';

  @override
  String get folderDialogAddButton => 'Lägg till';

  @override
  String get selectFolderSheetTitle => 'Välj mapp';

  @override
  String get selectFolderAddOptionLabel => 'Lägg till mapp';

  @override
  String get removeCurrentFolderLabel => 'Ta bort nuvarande mapp';

  @override
  String get noteDetailsDialogTitle => 'Detaljer';

  @override
  String get noteDetailsCreatedLabel => 'Skapad';

  @override
  String get noteDetailsModifiedLabel => 'Senast ändrad';

  @override
  String get noteDetailsCharCountLabel => 'Antal tecken';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count tecken';
  }

  @override
  String get noteDetailsWordCountLabel => 'Antal ord';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count ord';
  }

  @override
  String get noteDetailsOkButton => 'OK';

  @override
  String get noteDetailsUnknownDateLabel => 'Okänt';

  @override
  String get addAttachmentSheetTitle => 'Lägg till';

  @override
  String get addAttachmentImageOption => 'Lägg till bild';

  @override
  String get addAttachmentCameraOption => 'Kamera';

  @override
  String get addAttachmentFileOption => 'Lägg till fil';

  @override
  String get addAttachmentVoiceOption => 'Röstinspelning';

  @override
  String get addAttachmentVideoOption => 'Spela in video';

  @override
  String get addAttachmentScanOption => 'Skanna dokument';

  @override
  String get noteActionsSheetTitle => 'Välj åtgärd';

  @override
  String get noteActionReminderLabel => 'Påminnelse';

  @override
  String get noteActionEditReminderLabel => 'Redigera påminnelse';

  @override
  String get noteActionSpeechToTextLabel => 'Tal till text';

  @override
  String get noteActionArchiveLabel => 'Arkivera';

  @override
  String get noteActionUnarchiveLabel => 'Ta bort från arkivet';

  @override
  String get noteActionLockLabel => 'Lås';

  @override
  String get noteActionUnlockLabel => 'Lås upp';

  @override
  String get noteActionFavoriteLabel => 'Favorit';

  @override
  String get noteActionUnfavoriteLabel => 'Ta bort från favoriter';

  @override
  String get noteActionClassifyLabel => 'Välj mapp';

  @override
  String get noteActionDeleteLabel => 'Ta bort';

  @override
  String get noteActionPinToNotificationLabel =>
      'Nåla fast i aviseringspanelen';

  @override
  String get noteActionUnpinFromNotificationLabel => 'Ta bort nål';

  @override
  String get noteActionShareLabel => 'Dela';

  @override
  String get noteActionDuplicateLabel => 'Skapa kopia';

  @override
  String get noteActionCopyContentLabel => 'Kopiera innehåll';

  @override
  String get noteActionTtsLabel => 'Läs upp';

  @override
  String get noteActionTextSizeLabel => 'Textstorlek';

  @override
  String get noteActionDetailsLabel => 'Detaljer';

  @override
  String get noteActionDiscardChangesLabel => 'Förkasta ändringar';

  @override
  String get noteActionSelectLabel => 'Markera';

  @override
  String get reminderEditOptionLabel => 'Ändra påminnelse';

  @override
  String get reminderRemoveOptionLabel => 'Ta bort påminnelse';

  @override
  String get discardChangesDialogTitle => 'Förkasta ändringar';

  @override
  String get discardChangesDialogMessage =>
      'Osparade ändringar i denna anteckning går förlorade. Är du säker på att du vill förkasta dem?';

  @override
  String get discardChangesCancelButton => 'Avbryt';

  @override
  String get discardChangesConfirmButton => 'Förkasta';

  @override
  String get pinnedNotificationDefaultTitle => 'Anteckning';

  @override
  String get pdfFailedInfoMessage => 'Det gick inte att skapa PDF';

  @override
  String get drawingScreenTitle => 'Teckning';

  @override
  String get drawingMinimizeTooltip => 'Minimera';

  @override
  String get drawingEmptyExportWarningMessage => 'Rita något först';

  @override
  String get drawingEraserPartialModeLabel => 'Delvis';

  @override
  String get drawingEraserFullModeLabel => 'Helt';

  @override
  String get drawingClearTooltip => 'Rensa';

  @override
  String get drawingZoomOutTooltip => 'Zooma ut';

  @override
  String get drawingZoomInTooltip => 'Zooma in';

  @override
  String get drawingDeleteTooltip => 'Ta bort';

  @override
  String get drawingEmptyPreviewHint => 'Tryck för att rita';

  @override
  String get settingsPageTitle => 'Inställningar';

  @override
  String get settingsSectionGeneral => 'Allmänt';

  @override
  String get settingsSectionSecurity => 'Säkerhet';

  @override
  String get settingsSectionTheme => 'Tema';

  @override
  String get settingsSectionPersonalization => 'Anpassning';

  @override
  String get settingsSectionWidget => 'Widget';

  @override
  String get settingsSectionAbout => 'Om';

  @override
  String get settingsHintQuestionPet => 'Vad heter ditt första husdjur?';

  @override
  String get settingsHintQuestionTeacher => 'Vad heter din favoritlärare?';

  @override
  String get settingsHintQuestionBirthCity => 'I vilken stad är du född?';

  @override
  String get settingsHintQuestionFavoriteFood => 'Vad är din favoritmat?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'Vad är din mors flicknamn?';

  @override
  String get settingsHintQuestionFirstSchool =>
      'Vilken var den första skolan du gick i?';

  @override
  String get settingsHintQuestionFavoriteColor => 'Vad är din favoritfärg?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'Säkerhetsfråga';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'Om du glömmer ditt lösenord kan du återställa det genom att svara rätt på denna fråga.';

  @override
  String get settingsSecurityQuestionDropdownHint => 'Välj en säkerhetsfråga';

  @override
  String get settingsSecurityQuestionAnswerHint => 'Ditt svar';

  @override
  String get settingsSecurityQuestionCancelButton => 'Avbryt';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'Fråga och svar kan inte vara tomma!';

  @override
  String get settingsSecurityQuestionSaveButton => 'Spara';

  @override
  String get settingsCreatePasswordTitle => 'Skapa lösenord';

  @override
  String get settingsPasswordRequiredTitle => 'Lösenord krävs';

  @override
  String get settingsPasswordEnterHint => 'Ange lösenord';

  @override
  String get settingsForgotPasswordButton => 'Jag har glömt mitt lösenord';

  @override
  String get settingsNewPasswordHint => 'Nytt lösenord';

  @override
  String get settingsConfirmPasswordHint => 'Ange lösenord igen';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'Ställ in en säkerhetsfråga i fall du glömmer ditt lösenord (valfritt).';

  @override
  String get settingsPasswordDialogCancelButton => 'Avbryt';

  @override
  String get settingsPasswordMismatchWarning => 'Lösenorden matchar inte!';

  @override
  String get settingsWrongPasswordWarning => 'Fel lösenord!';

  @override
  String get settingsPasswordSaveButton => 'Spara';

  @override
  String get settingsPasswordRemoveButton => 'Ta bort';

  @override
  String get settingsNotePasswordTitle => 'Anteckningslösenord';

  @override
  String get settingsPasswordSetSubtitle => 'Lösenord inställt ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'Inget lösenord inställt';

  @override
  String get settingsSecurityQuestionTileTitle => 'Säkerhetsfråga';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'Inställd ✓ — används om du glömmer ditt lösenord';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'Ej inställd — du kommer inte kunna återställa ditt lösenord om det tappas bort';

  @override
  String get settingsThemeDialogTitle => 'Välj tema';

  @override
  String get settingsThemeSystemDefault => 'Systemstandard';

  @override
  String get settingsThemeLightOption => 'Ljust tema';

  @override
  String get settingsThemeDarkOption => 'Mörkt tema';

  @override
  String get settingsLanguageDialogTitle => 'Välj språk';

  @override
  String get settingsLanguageSystemOption => 'System';

  @override
  String get settingsAccentColorDialogTitle => 'Välj accentfärg';

  @override
  String get settingsThemeChangeTileTitle => 'Byt tema';

  @override
  String get settingsThemeLightLabel => 'Ljust';

  @override
  String get settingsThemeDarkLabel => 'Mörkt';

  @override
  String get settingsThemeSystemLabel => 'System';

  @override
  String get settingsLanguageTileTitle => 'Språk';

  @override
  String get settingsAccentColorTileTitle => 'Accentfärg';

  @override
  String get settingsAccentColorTileSubtitle =>
      'Färg som används i appfältet, knappar och brytare';

  @override
  String get settingsColorfulNotesTitle => 'Varierade anteckningsfärger';

  @override
  String get settingsColorfulNotesSubtitle =>
      'Varje anteckningskort får en annan färgton.';

  @override
  String get settingsTextColorSheetTitle => 'Textfärg';

  @override
  String get settingsTextColorSheetDesc =>
      'Ställer in färgen på anteckningens textinnehåll.';

  @override
  String get settingsTextColorOkButton => 'OK';

  @override
  String get settingsTextColorTileTitle => 'Textfärg';

  @override
  String get settingsTextColorTileSubtitle =>
      'Färg för anteckningens textinnehåll.';

  @override
  String get settingsWidgetFontSizeLabel => 'Widgetens textstorlek';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'Exempelrubrik - $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'Avbryt';

  @override
  String get settingsWidgetFontSizeApplyButton => 'Verkställ';

  @override
  String get settingsWidgetOpacityLabel => 'Bakgrundens genomskinlighet';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return '$percent% genomskinlighet';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'Avbryt';

  @override
  String get settingsWidgetOpacityApplyButton => 'Verkställ';

  @override
  String get settingsWidgetDarkModeTitle => 'Mörk widget';

  @override
  String get settingsWidgetDarkModeDesc => 'Mörkt färgschema för widgeten.';

  @override
  String get settingsAboutVersionTitle => 'Appversion';

  @override
  String get settingsAboutVersionLoading => 'Läser in version…';

  @override
  String get aboutSectionDeveloper => 'Feedback';

  @override
  String get aboutDeveloperTitle => 'Utvecklare';

  @override
  String get aboutContactTitle => 'Kontakt';

  @override
  String get aboutWebsiteTitle => 'Webbplats';

  @override
  String get aboutGithubTitle => 'GitHub';

  @override
  String get aboutSectionLegal => 'Juridiskt';

  @override
  String get aboutPrivacyPolicyTitle => 'Integritetspolicy';

  @override
  String get aboutTermsTitle => 'Användarvillkor';

  @override
  String get aboutLicensesTitle => 'Licenser med öppen källkod';

  @override
  String get aboutSectionSupport => 'Betygsätt';

  @override
  String get aboutRateAppTitle => 'Betygsätt appen';

  @override
  String get aboutLinkOpenError => 'Kunde inte öppna länken.';

  @override
  String get settingsFontFamilyTileTitle => 'Typsnitt';

  @override
  String get settingsFontFamilyDefaultLabel => 'Standard';

  @override
  String get settingsGlobalFontSizeTileTitle => 'Textstorlek';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt — tillämpas på alla anteckningar.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'Exempeltext - $size pt';
  }

  @override
  String get settingsGlobalFontSizeCancelButton => 'Avbryt';

  @override
  String get settingsGlobalFontSizeApplyButton => 'Verkställ';

  @override
  String get settingsPreviewLinesTileTitle => 'Förhandsvisningsrader';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'Visa upp till $lines rader. Om anteckningen är kortare visas det faktiska antalet rader.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'Nuvarande: $lines rader';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'Ställer in det maximala antalet rader att förhandsvisa. Om anteckningen har färre rader visas det faktiska antalet.';

  @override
  String get settingsPreviewLinesCancelButton => 'Avbryt';

  @override
  String get settingsPreviewLinesApplyButton => 'Verkställ';

  @override
  String get backupCancelButton => 'Avbryt';

  @override
  String get backupConnectButton => 'Anslut';

  @override
  String get backupDisconnectButton => 'Koppla från';

  @override
  String get backupContinueButton => 'Fortsätt';

  @override
  String get backupCloseButton => 'Stäng';

  @override
  String get backupShareButton => 'Dela';

  @override
  String get backupRestoreButton => 'Återställ';

  @override
  String get backupConfigureButton => 'Konfigurera';

  @override
  String get backupUnknownDateLabel => 'Okänt';

  @override
  String get backupProcessingDefaultLabel => 'Bearbetar...';

  @override
  String get backupPermissionRequiredTitle => 'Lagringsbehörighet krävs';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'Denna Android-version kräver lagringsbehörighet för säkerhetskopiering/återställning. Eftersom behörigheten permanent nekades, vänligen aktivera den manuellt i appinställningarna.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'Denna Android-version kräver lagringsbehörighet för säkerhetskopiering/återställning. Vänligen ge behörighet för att fortsätta.';

  @override
  String get backupGoToSettingsButton => 'Gå till inställningar';

  @override
  String get backupRetryButton => 'Försök igen';

  @override
  String get backupDriveConnectingLabel => 'Ansluter till Google-konto...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Ansluten till Google Drive-konto: $email';
  }

  @override
  String get backupDriveConnectedMessage => 'Ansluten till Google Drive-konto.';

  @override
  String get backupDriveConnectFailedMessage =>
      'Det gick inte att ansluta till Google-kontot, eller så avbröts åtgärden.';

  @override
  String get backupDriveDisconnectTitle => 'Koppla från Google Drive';

  @override
  String get backupDriveDisconnectBody =>
      'Om du kopplar från går det inte att göra manuella eller automatiska säkerhetskopior till Drive. Säkerhetskopior som redan finns på Drive kommer inte att tas bort — endast åtkomsten från denna enhet tas bort.';

  @override
  String get backupDriveDisconnectedMessage =>
      'Google Drive-anslutningen har tagits bort.';

  @override
  String get backupDriveRequiredTitle => 'Google-konto krävs';

  @override
  String get backupDriveRequiredBody =>
      'Denna åtgärd kräver att du ansluter ditt Google-konto. Vill du ansluta nu?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: ansluten ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: ansluten';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: inte ansluten';

  @override
  String get backupDriveAuthenticatingLabel => 'Verifierar Google-konto...';

  @override
  String get backupDriveNotSignedInMessage =>
      'Du är inte ansluten till Google Drive. Vänligen logga in med ditt Google-konto först.';

  @override
  String get backupDriveUploadingLabel =>
      'Laddar upp säkerhetskopia till Drive...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Uppladdningen till Google Drive slutfördes inte inom 120 sekunder (inget svar från servern). Kontrollera din anslutning och försök igen.';

  @override
  String get backupDriveOperationCompletedLabel => 'Slutförd';

  @override
  String get backupToDriveActionLabel => 'säkerhetskopiering till Drive';

  @override
  String get backupToDeviceActionLabel => 'säkerhetskopiering';

  @override
  String get backupCreatingLabel => 'Skapar säkerhetskopia...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'Säkerhetskopian kunde inte skapas: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Uppladdning till Google Drive misslyckades: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'Säkerhetskopian har laddats upp till Google Drive.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'Säkerhetskopia skapad: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'Säkerhetskopia redo';

  @override
  String get backupOfferShareBody =>
      'Din säkerhetskopieringsfil har sparats på din enhet. Vill du dela den nu (t.ex. molnlagring, e-post, en annan enhet)?';

  @override
  String get backupShareFileText => 'layout säkerhetskopieringsfil';

  @override
  String backupShareFailedMessage(String error) {
    return 'Delningen kunde inte startas: $error';
  }

  @override
  String get backupLargeOperationTitle => 'Stor säkerhetskopia';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'Data som ska bearbetas är cirka $sizeText. En $actionLabel av denna storlek kan ta ett tag beroende på din enhet. Lämna bara inte appen medan det pågår — vill du fortsätta?';
  }

  @override
  String get backupRestoreActionLabel => 'återställning';

  @override
  String get backupDriveListingLabel => 'Listar Drive-säkerhetskopior...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'Säkerhetskopiorna kunde inte listas: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'Det finns inga säkerhetskopior på Google Drive än.';

  @override
  String get backupDrivePickTitle => 'Välj en säkerhetskopia från Drive';

  @override
  String get backupDriveDownloadingLabel =>
      'Laddar ner säkerhetskopia från Drive...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Laddar ner säkerhetskopia från Drive... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel => 'Sparar filen på enheten...';

  @override
  String get backupDriveUnknownBackupFileName => 'unknown_backup.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Din lagring på Google Drive är full. Frigör utrymme på Drive och försök igen.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'Det gick inte att upprätta en internetanslutning. Kontrollera din anslutning och försök igen.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'Den angivna säkerhetskopian kunde inte hittas på Drive. Den kan ha tagits bort.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Ett oväntat fel uppstod under Google Drive-åtgärden: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'Nedladdningen misslyckades: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'Filen kunde inte väljas: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'Den valda filen kunde inte nås.';

  @override
  String get backupCheckingLabel => 'Kontrollerar säkerhetskopia...';

  @override
  String backupReadFailedMessage(String error) {
    return 'Säkerhetskopian kunde inte läsas: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'Återställ säkerhetskopia';

  @override
  String get backupPreviewContentsHeader =>
      'Innehåll i den valda säkerhetskopian:';

  @override
  String get backupPreviewNoteCountLabel => 'Antal anteckningar';

  @override
  String get backupPreviewTrashCountLabel => 'Anteckningar i papperskorgen';

  @override
  String get backupPreviewCategoryCountLabel => 'Antal kategorier';

  @override
  String get backupPreviewAttachmentLabel => 'Bilagor';

  @override
  String get backupPreviewAttachmentNoneValue => 'Inga';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count filer ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'Skapad';

  @override
  String get backupEmptyPreviewTitle => 'Denna säkerhetskopia verkar vara tom';

  @override
  String get backupEmptyPreviewBody =>
      'Inga anteckningar, kategorier eller bilagor hittades i den valda filen. Om du fortsätter kommer din nuvarande data ändå att raderas och ersättas med denna tomma säkerhetskopia.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '$count bilagor hittades inte i säkerhetskopian';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'Anteckningar med dessa filer kommer att återställas, men utan bilagorna (de kan ha saknats eller varit skadade när säkerhetskopian togs): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown och $remaining till';
  }

  @override
  String get backupRestoreConfirmBody =>
      'Detta kommer att ERSÄTTA alla dina nuvarande anteckningar, papperskorg, kategorier, inställningar och bilagor med data från säkerhetskopian ovan. Din nuvarande data går permanent förlorad och denna åtgärd kan inte ångras.';

  @override
  String get backupRestoringLabel => 'Återställer säkerhetskopia...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'Säkerhetskopian återställd. Dock hittades inte $count bilagor i säkerhetskopian och kunde inte återställas. Det rekommenderas att starta om appen för att ändringarna ska få full effekt.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'Säkerhetskopian återställdes. Det rekommenderas att starta om appen för att ändringarna ska få full effekt.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'Ett fel uppstod vid återställning: $error';
  }

  @override
  String get backupScreenTitle => 'Säkerhetskopiering & återställning';

  @override
  String get backupBlockedExitWarningMessage =>
      'En åtgärd pågår, vänta tills den är klar.';

  @override
  String get backupBusyBackTooltip => 'Åtgärd pågår';

  @override
  String get backupIntroText =>
      'Du kan säkerhetskopiera dina anteckningar, kategorier, inställningar och bilagor som en enda .zip-fil, eller återställa en säkerhetskopia du tog tidigare.';

  @override
  String get backupDriveCardTitle => 'Säkerhetskopiera till Google Drive';

  @override
  String get backupDriveCardSubtitle =>
      'Skapa en ny säkerhetskopia och ladda upp den direkt till det privata området på din Google Drive.';

  @override
  String get backupDriveCardButtonLabel => 'Säkerhetskopiera till Drive';

  @override
  String get backupDeviceCardTitle => 'Säkerhetskopiera till enhet';

  @override
  String get backupDeviceCardSubtitle =>
      'Spara all din data som en enda .zip-fil på din enhet och dela den om du vill.';

  @override
  String get backupDeviceCardButtonLabel => 'Säkerhetskopiera till enhet';

  @override
  String get backupHistoryCardTitle => 'Säkerhetskopieringshistorik';

  @override
  String get backupHistoryCardSubtitle =>
      'Visa alla säkerhetskopior som lagras på din enhet med datum och storlek; du kan dela, återställa eller ta bort dem direkt härifrån.';

  @override
  String get backupHistoryTabDevice => 'Enhet';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'Ta bort säkerhetskopia';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'Är du säker på att du vill ta bort säkerhetskopieringsfilen \"$fileName\" permanent? Denna åtgärd kan inte ångras.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'Säkerhetskopian borttagen.';

  @override
  String get backupHistoryDriveDeleteDialogTitle =>
      'Ta bort Drive-säkerhetskopia';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'Är du säker på att du vill ta bort säkerhetskopian \"$fileName\" permanent från Google Drive? Denna åtgärd kan inte ångras och filen flyttas inte till papperskorgen.';
  }

  @override
  String get backupHistoryDriveDeletedMessage =>
      'Drive-säkerhetskopian borttagen.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'Kunde inte ta bort: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'Inga säkerhetskopior sparade på denna enhet än.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'Använd \"Säkerhetskopiera till enhet\" för att skapa din första säkerhetskopia.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'Använd \"Säkerhetskopiera till Google Drive\" för att skapa din första molnsäkerhetskopia.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Anslut ditt Google-konto för att se dina Drive-säkerhetskopior.';

  @override
  String get backupHistoryConnectGoogleButton => 'Anslut med Google';

  @override
  String get backupHistoryDriveConnectedFallback => 'Ansluten';

  @override
  String get backupHistoryUnknownErrorFallback => 'Ett okänt fel uppstod.';

  @override
  String get backupHistoryDownloadStartingLabel => 'Startar...';

  @override
  String get backupAutoBackupEnabledLabel =>
      'Automatisk säkerhetskopiering: på';

  @override
  String get backupAutoBackupDisabledLabel =>
      'Automatisk säkerhetskopiering: av';

  @override
  String get backupOverlayWarningMessage =>
      'Vänta, lämna inte appen förrän åtgärden är klar.';

  @override
  String get pdfExportUntitledNoteLabel => 'Namnlös anteckning';

  @override
  String get pdfExportDefaultAttachmentName => 'Bilaga';

  @override
  String get pdfExportDefaultFileName => 'anteckning';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'Skärmbilden kunde inte tas (gräns hittades inte)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'Skärmbildsdata kunde inte genereras';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'Bilden kunde inte bearbetas (PNG-avkodning misslyckades)';

  @override
  String get screenshotCalcTableTotalLabel => 'Totalt';

  @override
  String get gundemMenuRemoveFromAgenda => 'Ta bort från agenda';

  @override
  String get gundemMenuDeleteNote => 'Ta bort anteckning';

  @override
  String get gundemSectionOverdue => 'Försenad';

  @override
  String get gundemSectionToday => 'Idag';

  @override
  String get gundemSectionTomorrow => 'Imorgon';

  @override
  String get gundemSectionNextWeek => 'Nästa vecka';

  @override
  String get gundemSectionFurther => 'Längre fram';

  @override
  String get gundemWeekdayMonday => 'Måndag';

  @override
  String get gundemWeekdayTuesday => 'Tisdag';

  @override
  String get gundemWeekdayWednesday => 'Onsdag';

  @override
  String get gundemWeekdayThursday => 'Torsdag';

  @override
  String get gundemWeekdayFriday => 'Fredag';

  @override
  String get gundemWeekdaySaturday => 'Lördag';

  @override
  String get gundemWeekdaySunday => 'Söndag';

  @override
  String get gundemAppBarTitle => 'Agenda';

  @override
  String get gundemCalendarTooltip => 'Kalender';

  @override
  String get gundemEmptyTitle => 'Inget i din agenda';

  @override
  String get gundemEmptySubtitle =>
      'Anteckningar med en påminnelse eller ett tilldelat datum visas här.';

  @override
  String get gundemUntitledNote => 'Namnlös anteckning';

  @override
  String get gundemRepeatHourly => 'Varje timme';

  @override
  String get gundemRepeatDaily => 'Dagligen';

  @override
  String get gundemRepeatWeekly => 'Veckovis';

  @override
  String get gundemRepeatMonthly => 'Månadsvis';

  @override
  String get gundemRepeatYearly => 'Årligen';

  @override
  String get gundemPreviewCalcTableLabel => '[Beräkningslista]';

  @override
  String get gundemPreviewDrawingLabel => '[Teckning]';

  @override
  String get gundemPreviewImageLabel => '[Bild]';

  @override
  String get gundemMonthShortJan => 'jan';

  @override
  String get gundemMonthShortFeb => 'feb';

  @override
  String get gundemMonthShortMar => 'mar';

  @override
  String get gundemMonthShortApr => 'apr';

  @override
  String get gundemMonthShortMay => 'maj';

  @override
  String get gundemMonthShortJun => 'jun';

  @override
  String get gundemMonthShortJul => 'jul';

  @override
  String get gundemMonthShortAug => 'aug';

  @override
  String get gundemMonthShortSep => 'sep';

  @override
  String get gundemMonthShortOct => 'okt';

  @override
  String get gundemMonthShortNov => 'nov';

  @override
  String get gundemMonthShortDec => 'dec';

  @override
  String get calendarAppBarTitle => 'Kalender';

  @override
  String get calendarTodayButton => 'Idag';

  @override
  String get calendarLegendNoteLabel => 'Anteckning';

  @override
  String get calendarLegendReminderLabel => 'Påminnelse';

  @override
  String get calendarTodayBadge => 'Idag';

  @override
  String get calendarEmptyDayMessage =>
      'Inga anteckningar eller påminnelser för denna dag.';

  @override
  String get calendarReminderHourlyLabel => 'Varje timme';

  @override
  String get calendarMonthJan => 'januari';

  @override
  String get calendarMonthFeb => 'februari';

  @override
  String get calendarMonthMar => 'mars';

  @override
  String get calendarMonthApr => 'april';

  @override
  String get calendarMonthMay => 'maj';

  @override
  String get calendarMonthJun => 'juni';

  @override
  String get calendarMonthJul => 'juli';

  @override
  String get calendarMonthAug => 'augusti';

  @override
  String get calendarMonthSep => 'september';

  @override
  String get calendarMonthOct => 'oktober';

  @override
  String get calendarMonthNov => 'november';

  @override
  String get calendarMonthDec => 'december';

  @override
  String get calendarWeekdayShortMon => 'mån';

  @override
  String get calendarWeekdayShortTue => 'tis';

  @override
  String get calendarWeekdayShortWed => 'ons';

  @override
  String get calendarWeekdayShortThu => 'tors';

  @override
  String get calendarWeekdayShortFri => 'fre';

  @override
  String get calendarWeekdayShortSat => 'lör';

  @override
  String get calendarWeekdayShortSun => 'sön';

  @override
  String get calendarWeekdayFullMonday => 'Måndag';

  @override
  String get calendarWeekdayFullTuesday => 'Tisdag';

  @override
  String get calendarWeekdayFullWednesday => 'Onsdag';

  @override
  String get calendarWeekdayFullThursday => 'Torsdag';

  @override
  String get calendarWeekdayFullFriday => 'Fredag';

  @override
  String get calendarWeekdayFullSaturday => 'Lördag';

  @override
  String get calendarWeekdayFullSunday => 'Söndag';

  @override
  String get wrongPasswordDialogTitle => 'Fel lösenord';

  @override
  String get wrongPasswordDialogMessage => 'Lösenordet du angav är felaktigt.';

  @override
  String get commonOkButton => 'OK';

  @override
  String get unlockCategoryAction => 'Lås upp';

  @override
  String get lockCategoryAction => 'Lås';

  @override
  String get categoryUnlockedMessage => 'Upplåst';

  @override
  String get categoryLockedMessage => 'Mappen låst';

  @override
  String get deleteFolderMenuItemLabel => 'Ta bort mapp';

  @override
  String get deleteFolderDialogTitle => 'Ta bort mapp';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'Är du säker på att du vill ta bort mappen \"$category\" och alla dess undermappar? Anteckningar i dessa mappar blir okategoriserade.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'Är du säker på att du vill ta bort mappen \"$category\"? Anteckningar i denna mapp blir okategoriserade.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'Avbryt';

  @override
  String get deleteFolderDialogConfirmButton => 'Ta bort';

  @override
  String get editCategoryNameColorMenuItemLabel => 'Redigera namn/färg';

  @override
  String get addSubfolderMenuItemLabel => 'Skapa undermapp';

  @override
  String get expandSubfoldersMenuItemLabel => 'Expandera undermappar';

  @override
  String get collapseSubfoldersMenuItemLabel => 'Fäll ihop undermappar';

  @override
  String saveErrorInfoMessage(String error) {
    return 'Sparfel: $error';
  }

  @override
  String get welcomeNoteTitle => 'Välkommen till Layout! 🚀';

  @override
  String get welcomeNoteContent => 'Nya funktioner har lagts till!';

  @override
  String get noteListDateGroupToday => 'Idag';

  @override
  String get noteListDateGroupYesterday => 'Igår';

  @override
  String get noteListDateGroupLast7Days => 'Senaste 7 dagarna';

  @override
  String get noteListDateGroupLast30Days => 'Senaste 30 dagarna';

  @override
  String get reminderRepeatNoneLabel => 'Ingen upprepning';

  @override
  String get voiceRecorderPreparingLabel => 'Förbereder…';

  @override
  String get voiceRecorderCancelButton => 'Avbryt';

  @override
  String get voiceRecorderStopAddButton => 'Stoppa och lägg till';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'Mikrofonåtkomst gavs inte.';

  @override
  String get speechToTextUnavailableMessage =>
      'Taligenkänning är inte tillgängligt på denna enhet.';

  @override
  String get speechToTextPreparingLabel => 'Förbereder…';

  @override
  String get speechToTextListeningLabel => 'Lyssnar…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'Börja tala…';

  @override
  String get speechToTextCancelButton => 'Avbryt';

  @override
  String get speechToTextStopAddButton => 'Stoppa och lägg till';

  @override
  String get textToSpeechNoContentMessage =>
      'Det finns inget innehåll att läsa.';

  @override
  String get textToSpeechReadErrorMessage => 'Ett fel uppstod vid uppläsning.';

  @override
  String get textToSpeechUnavailableMessage =>
      'Text-till-tal är inte tillgängligt på denna enhet.';

  @override
  String get textToSpeechPreparingLabel => 'Förbereder…';

  @override
  String get textToSpeechPausedLabel => 'Pausad';

  @override
  String get textToSpeechFinishedLabel => 'Uppläsning klar';

  @override
  String get textToSpeechReadingLabel => 'Läser upp…';

  @override
  String get textToSpeechCloseErrorButton => 'Stäng';

  @override
  String get textToSpeechReplayButton => 'Läs igen';

  @override
  String get textToSpeechCloseFinishedButton => 'Stäng';

  @override
  String get textToSpeechPauseButton => 'Pausa';

  @override
  String get textToSpeechResumeButton => 'Återuppta';

  @override
  String get textToSpeechStopButton => 'Stoppa';

  @override
  String get textToSpeechSpeedSlow => 'Långsam';

  @override
  String get textToSpeechSpeedNormal => 'Normal';

  @override
  String get textToSpeechSpeedFast => 'Snabb';

  @override
  String get calendarPickerCancelButton => 'Avbryt';

  @override
  String get calendarPickerConfirmButton => 'Välj';

  @override
  String get calendarPickerClearButton => 'Rensa';

  @override
  String get reminderPickerDialogTitle => 'Lägg till påminnelse';

  @override
  String get reminderPickerDateTodayOption => 'Idag';

  @override
  String get reminderPickerDateTomorrowOption => 'Imorgon';

  @override
  String get reminderPickerDatePickOption => 'Välj datum';

  @override
  String get reminderRepeatHourlyLabel => 'Varje timme';

  @override
  String get reminderRepeatDailyLabel => 'Varje dag';

  @override
  String get reminderRepeatWeeklyLabel => 'Varje vecka';

  @override
  String get reminderRepeatMonthlyLabel => 'Varje månad';

  @override
  String get reminderRepeatYearlyLabel => 'Varje år';

  @override
  String get reminderPickerCalendarHelpText => 'Välj påminnelsedatum';

  @override
  String get reminderPickerCancelButton => 'AVBRYT';

  @override
  String get reminderPickerSaveButton => 'SPARA';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'En tidpunkt i det förflutna kan inte väljas';

  @override
  String calcTableTotalLabel(String amount) {
    return 'Totalt: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'Förbereder data...';

  @override
  String get backupCreatePackagingNotesLabel =>
      'Paketerar anteckningar och kategorier...';

  @override
  String get backupCreateReadingAttachmentsLabel => 'Läser bilagor...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'Läser bilagor... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'Komprimerar zip-fil...';

  @override
  String get backupCreateSavingFileLabel => 'Sparar fil...';

  @override
  String get backupRestoreValidatingLabel => 'Validerar säkerhetskopia...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'Säkerhetskopian validerad, förbereder data...';

  @override
  String get backupRestoreWritingNotesLabel => 'Skriver anteckningar...';

  @override
  String get backupRestoreWritingTrashLabel => 'Skriver papperskorg...';

  @override
  String get backupRestoreTrashWrittenLabel => 'Papperskorg skriven';

  @override
  String get backupRestoreWritingCategoriesLabel => 'Skriver kategorier...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'Kategorier skrivna';

  @override
  String get backupRestoreWritingSettingsLabel => 'Skriver inställningar...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'Inställningar skrivna';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'Rensar gamla bilagor...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'Inga bilagor hittades, avslutar...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'Återställer bilagor... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'Slutförd';

  @override
  String get backupValidationCorruptedFileMessage =>
      'Filen är skadad eller är inte en giltig säkerhetskopieringsfil.';

  @override
  String get backupValidationMissingDataMessage =>
      'Ingen data hittades i säkerhetskopieringsfilen (backup_data.json saknas).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'Säkerhetskopieringsdata kunde inte läsas (skadad JSON).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'Denna fil är inte en säkerhetskopia från layout-appen.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'Säkerhetskopieringsfilens versionsinformation kunde inte läsas.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'Denna säkerhetskopia är i ett nyare format som den nuvarande appversionen inte stöder. Vänligen uppdatera appen.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'Säkerhetskopieringsfilens versionsinformation är ogiltig.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'Säkerhetskopieringsdata är inte i förväntat format (fältet för anteckningar saknas).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'Säkerhetskopieringsdata är inte i förväntat format (fältet för papperskorgen saknas).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'Säkerhetskopieringsdata är inte i förväntat format (kategorilistan är ogiltig).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'Säkerhetskopieringsdata är inte i förväntat format (inställningsfältet är ogiltigt).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'Säkerhetskopieringsdata är inte i förväntat format (en anteckningspost är ogiltig).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'Säkerhetskopieringsdata är inte i förväntat format (en anteckningspost utan ID hittades).';

  @override
  String get backupValidationFileNotFoundMessage =>
      'Säkerhetskopieringsfilen hittades inte.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'Inte tillräckligt med ledigt lagringsutrymme på enheten. Frigör utrymme och försök igen.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'Filåtkomstbehörighet nekades. Kontrollera appens behörigheter och försök igen.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'Ett fel uppstod under filåtgärden: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'Ett oväntat fel uppstod: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'Kunde inte skapa zip-arkivet (ZipEncoder returnerade null).';

  @override
  String get calcTableMenuItemLabel => 'Beräkningslista';

  @override
  String get tableBlockMenuItemLabel => 'Tabell';

  @override
  String get tableSizePickerTitle => 'Välj tabellstorlek';

  @override
  String get tableSizePickerCancel => 'Avbryt';

  @override
  String get tableSizePickerDeleteTooltip => 'Ta bort tabell';

  @override
  String get tagsMenuItemLabel => 'Taggar';

  @override
  String get linkDialogUrlHint => 'https://example.com';

  @override
  String get checklistItemHint => 'Lägg till objekt...';

  @override
  String get toolbarHighlightTooltip => 'Markering';

  @override
  String get toolbarListTooltip => 'Lista';

  @override
  String get toolbarHideKeyboardTooltip => 'Dölj tangentbord';

  @override
  String get autoBackupLocalSuccessMessage =>
      'Lokal säkerhetskopiering lyckades.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'Lokal säkerhetskopiering misslyckades: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Drive-säkerhetskopiering hoppades över: Google-kontot är inte anslutet eller sessionen har gått ut. Öppna appen och återanslut.';

  @override
  String get autoBackupDriveSuccessMessage =>
      'Drive-säkerhetskopiering lyckades.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Drive-säkerhetskopiering misslyckades: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'Inga anteckningar ännu';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'Totalt: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ Teckning';

  @override
  String get autoBackupSettingsAppBarTitle =>
      'Inställningar för automatisk säkerhetskopiering';

  @override
  String get autoBackupSettingsMainSwitchTitle =>
      'Aktivera automatisk säkerhetskopiering';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'Dina anteckningar säkerhetskopieras säkert periodvis i bakgrunden.';

  @override
  String get autoBackupSettingsTargetTitle => 'Säkerhetskopieringsmål';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'Välj var säkerhetskopior sparas.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'Lokalt';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'Båda';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Anslut ditt konto först för att använda Google Drive-alternativ.';

  @override
  String get autoBackupSettingsConnectButton => 'Anslut';

  @override
  String get autoBackupSettingsFrequencyTitle => 'Säkerhetskopieringsfrekvens';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'En säkerhetskopia tas var $hours:e timme.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 timmar';

  @override
  String get autoBackupSettingsFrequency12h => '12 timmar';

  @override
  String get autoBackupSettingsFrequency24h => '24 timmar (dagligen)';

  @override
  String get autoBackupSettingsFrequency48h => '48 timmar (2 dagar)';

  @override
  String get autoBackupSettingsFrequency168h => '168 timmar (veckovis)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Använd endast Wi-Fi';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'Molnuppladdning sker endast via Wi-Fi för att skydda din mobildata.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'Systemstatus';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'Automatisk säkerhetskopiering har inte körts än.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'Senaste körning: $date $time ($status)\nMeddelande: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'Lyckades';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'Misslyckades';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Det gick inte att ansluta till Google-kontot.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'Inställningarna för automatisk säkerhetskopiering har uppdaterats.';

  @override
  String selectionModeDeletedMessage(int count) {
    return '$count anteckningar borttagna';
  }

  @override
  String get selectionModeArchivedMessage => 'Arkiverad';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'Välj kategori för $count anteckningar';
  }

  @override
  String get selectionModeAddCategoryOption => 'Lägg till kategori';

  @override
  String get selectionModeRemoveCategoryOption => 'Ta bort kategori';

  @override
  String get calcTableItemHint => 'Objekt...';

  @override
  String get calcTableTotalRowLabel => 'Totalt';

  @override
  String get textSelectionMenuShareButton => 'Dela';

  @override
  String get textSelectionMenuTranslateButton => 'Översätt';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'Delningen kunde inte startas.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'Översättningen kunde inte öppnas.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'Idag $time';
  }

  @override
  String lastBackupInfoDateFormat(
    String day,
    String month,
    int year,
    String time,
  ) {
    return '$month/$day/$year $time';
  }

  @override
  String lastBackupInfoLabel(String date) {
    return 'Senaste säkerhetskopia: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage =>
      'Ingen säkerhetskopia har tagits ännu.';

  @override
  String get backupFileNameLabel => 'Säkerhetskopia';

  @override
  String get tableMenuInsertRowAfter => 'Lägg till rad';

  @override
  String get tableMenuDeleteRow => 'Ta bort rad';

  @override
  String get tableMenuInsertColumnAfter => 'Lägg till kolumn';

  @override
  String get tableMenuDeleteColumn => 'Ta bort kolumn';

  @override
  String get imageCropToolbarTitle => 'Beskär';

  @override
  String get imageViewerDeleteButtonLabel => 'Ta bort';

  @override
  String get imageViewerSaveToGalleryButtonLabel => 'Spara';

  @override
  String get imageViewerShareButtonLabel => 'Dela';

  @override
  String get imageViewerGalleryPermissionDeniedMessage =>
      'Åtkomst till galleriet nekades';

  @override
  String get imageViewerSavedToGalleryMessage => 'Sparad i albumet';

  @override
  String imageViewerSaveFailedMessage(String error) {
    return 'Det gick inte att spara: $error';
  }

  @override
  String get imageViewerSavingInProgressMessage => 'Sparar…';
}
