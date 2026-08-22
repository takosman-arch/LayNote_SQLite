// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'Fed';

  @override
  String get toolbarItalicTooltip => 'Kursiv';

  @override
  String get toolbarUnderlineTooltip => 'Understreget';

  @override
  String get toolbarStrikethroughTooltip => 'Gennemstreget';

  @override
  String get toolbarFontSizeTooltip => 'Skriftstørrelse';

  @override
  String get toolbarColorTooltip => 'Tekstfarve';

  @override
  String get toolbarBulletTooltip => 'Punktliste';

  @override
  String get toolbarNumberTooltip => 'Nummereret liste';

  @override
  String get toolbarIndentTooltip => 'Afsnitsindrykning';

  @override
  String get toolbarLinkTooltip => 'Tilføj / Rediger / Fjern link';

  @override
  String get toolbarDividerTooltip => 'Indsæt skillelinje';

  @override
  String get toolbarChecklistTooltip => 'Tilføj tjekliste';

  @override
  String get linkSelectTextSnackbar => 'Vælg først den tekst, du vil linke';

  @override
  String get linkDialogEditTitle => 'Rediger link';

  @override
  String get linkDialogAddTitle => 'Tilføj link';

  @override
  String get linkDialogRemoveButton => 'Fjern link';

  @override
  String get linkDialogCancelButton => 'Annuller';

  @override
  String get linkDialogConfirmButton => 'Tilføj';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Kameratilladelse nægtet. Du skal give tilladelse i indstillingerne for at optage video.';

  @override
  String get cameraPermissionRequiredMessage =>
      'Kameratilladelse er påkrævet for at optage video.';

  @override
  String get openSettingsButtonLabel => 'Indstillinger';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'Scanning kunne ikke startes: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'Tekstgenkendelse mislykkedes: $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'Der blev ikke fundet læsbar tekst i dokumentet';

  @override
  String get scanResultSheetTitle =>
      'Hvordan skal det scannede dokument tilføjes?';

  @override
  String get scanResultTextOnlyOption => 'Tilføj kun som tekst';

  @override
  String get scanResultTextAndImageOption => 'Tilføj tekst + scannet billede';

  @override
  String get scanResultCancelOption => 'Annuller';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'Mikrofontilladelse nægtet. Du skal give tilladelse i indstillingerne for at optage lyd.';

  @override
  String get audioPermissionRequiredMessage =>
      'Mikrofontilladelse er påkrævet for at optage lyd.';

  @override
  String get voiceRecordingDefaultLabel => 'Lydoptagelse';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'Regneliste ($count rækker)';
  }

  @override
  String get blockPreviewDrawingLabel => 'Tegning';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count vedhæftninger (foto/dokument)';
  }

  @override
  String get blockPreviewDividerLabel => 'Skillelinje';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'Tjekliste ($count punkter)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(tom tekst)';

  @override
  String get reorderBlocksSheetTitle => 'Omorganiser blokke';

  @override
  String get reorderBlocksMoveUpTooltip => 'Flyt op';

  @override
  String get reorderBlocksMoveDownTooltip => 'Flyt ned';

  @override
  String get reorderBlocksCloseTooltip => 'Luk';

  @override
  String get reorderBlocksDescription =>
      'Tryk på en blok for at vælge den, brug derefter op/ned-pilene til at flytte den.';

  @override
  String get reorderBlocksMenuItemLabel => 'Omorganiser';

  @override
  String get txtImportPickerDialogTitle =>
      'Vælg TXT-filen, der skal importeres';

  @override
  String get txtImportReadFailedMessage => 'TXT-filen kunne ikke læses';

  @override
  String get txtImportEmptyFileMessage => 'TXT-filen er tom';

  @override
  String get txtImportSuccessMessage => 'TXT importeret';

  @override
  String get txtImportMenuItemLabel => 'Importer (txt)';

  @override
  String get exportMenuItemLabel => 'Eksporter';

  @override
  String get editorUndoTooltip => 'Fortryd';

  @override
  String get editorRedoTooltip => 'Gentag';

  @override
  String get noteSavedMessage => 'Note gemt';

  @override
  String get dateAssignPickerHelpText => 'Tildel note til en dag';

  @override
  String get dateAssignChangeOption => 'Skift dato';

  @override
  String get dateAssignRemoveOption => 'Fjern tildeling';

  @override
  String get editorSubToolbarCloseTooltip => 'Luk';

  @override
  String get titleFieldHint => 'Titel';

  @override
  String get textBlockHint => 'Skriv din note her...';

  @override
  String get drawingBoardMenuItemLabel => 'Tegnetavle';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'Tale-til-tekst er kun tilgængeligt for tekstnoter';

  @override
  String get selectionModeCancelTooltip => 'Annuller valg';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return '$count valgt';
  }

  @override
  String get selectionModeDeleteTooltip => 'Slet';

  @override
  String get selectionModeArchiveTooltip => 'Arkiver';

  @override
  String get selectionModeFolderTooltip => 'Mappe';

  @override
  String get searchFieldHint => 'Søg i noter...';

  @override
  String get emptyTrashDialogTitle => 'Tøm papirkurv';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'Alle slettede noter fjernes permanent. Er du sikker?';

  @override
  String get emptyTrashDialogCancelButton => 'Annuller';

  @override
  String get restoreAllMenuItemLabel => 'Gendan alle';

  @override
  String get sortMenuTooltip => 'Sorter noter';

  @override
  String get sortMenuAscendingLabel => 'Rækkefølge: Stigende (A-Å)';

  @override
  String get sortMenuDescendingLabel => 'Rækkefølge: Faldende (Å-A)';

  @override
  String get sortMenuByTitleLabel => 'Sorter efter: Titel';

  @override
  String get sortMenuByModifiedDateLabel => 'Sorter efter: Sidst ændret';

  @override
  String get sortMenuByCreatedDateLabel => 'Sorter efter: Oprettelsesdato';

  @override
  String get sortMenuByFolderLabel => 'Sorter efter: Mappe';

  @override
  String get viewToggleGridTooltip => 'Gittervisning';

  @override
  String get viewToggleListTooltip => 'Listevisning';

  @override
  String get drawerHeaderSubtitle => 'Din personlige notesbog';

  @override
  String get drawerNotesSectionHeader => 'NOTER';

  @override
  String get drawerAllNotesLabel => 'Noter';

  @override
  String get drawerFavoritesLabel => 'Favorit';

  @override
  String get drawerAgendaLabel => 'Dagsorden';

  @override
  String get drawerRemindersLabel => 'Påmindelse';

  @override
  String get drawerLockedLabel => 'Låst';

  @override
  String get drawerTrashLabel => 'Papirkurv';

  @override
  String get drawerFoldersSectionHeader => 'MAPPER';

  @override
  String get drawerExpandLabel => 'Udvid';

  @override
  String get drawerCollapseLabel => 'Skjul';

  @override
  String get drawerAddFolderLabel => 'Tilføj mappe';

  @override
  String get drawerAppSectionHeader => 'APP';

  @override
  String get drawerCalendarLabel => 'Kalender';

  @override
  String get drawerSettingsLabel => 'Indstillinger';

  @override
  String get drawerBackupRestoreLabel => 'Sikkerhedskopi & gendannelse';

  @override
  String get drawerUpgradeToProLabel => 'Opgrader til Pro';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'Støt udviklingen';

  @override
  String get drawerFeedbackLabel => 'Feedback';

  @override
  String get drawerAboutLabel => 'Om';

  @override
  String get noNotesFoundMessage => 'Ingen noter fundet.';

  @override
  String get trashRestoreButtonLabel => 'Gendan';

  @override
  String get trashPermanentDeleteButtonLabel => 'Slet permanent';

  @override
  String get tagRenamedInfoMessage => 'Tag omdøbt';

  @override
  String get tagDeletedInfoMessage => 'Tag slettet';

  @override
  String get tagOptionsRenameLabel => 'Omdøb';

  @override
  String get tagOptionsDeleteLabel => 'Slet';

  @override
  String get renameTagDialogTitle => 'Omdøb tag';

  @override
  String get renameTagDialogHint => 'Nyt tagnavn';

  @override
  String get renameTagDialogCancelButton => 'Annuller';

  @override
  String get renameTagDialogSaveButton => 'Gem';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '\"$tag\" fjernes fra $affectedCount noter. Fortsæt?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'Slet tagget \"$tag\"?';
  }

  @override
  String get deleteTagDialogTitle => 'Slet tag';

  @override
  String get deleteTagDialogCancelButton => 'Annuller';

  @override
  String get deleteTagDialogConfirmButton => 'Slet';

  @override
  String get tagsSheetTitle => 'Tags';

  @override
  String get tagsSheetEmptyMessage => 'Ingen tags på denne note endnu.';

  @override
  String get tagsSheetInputHint => 'Skriv et nyt tag...';

  @override
  String get tagsSheetSuggestionsLabel => 'Eksisterende tags';

  @override
  String get noteDeletedInfoMessage => 'Note slettet';

  @override
  String get noteDeletedUndoActionLabel => 'Fortryd';

  @override
  String get reminderSetInfoMessage => 'Påmindelse indstillet';

  @override
  String get reminderRemovedInfoMessage => 'Påmindelse fjernet';

  @override
  String get noteDuplicatedInfoMessage => 'Kopi oprettet';

  @override
  String get speechTextAppendedInfoMessage => 'Tekst tilføjet til note';

  @override
  String get pdfPreparingInfoMessage => 'Forbereder PDF…';

  @override
  String get pdfSavedInfoMessage => 'PDF gemt';

  @override
  String get jpgPreparingInfoMessage => 'Forbereder JPG…';

  @override
  String get jpgSavedInfoMessage => 'JPG gemt';

  @override
  String get jpgFailedInfoMessage => 'Kunne ikke oprette JPG';

  @override
  String get txtPreparingInfoMessage => 'Forbereder TXT…';

  @override
  String get txtSavedInfoMessage => 'TXT gemt';

  @override
  String get txtFailedInfoMessage => 'Kunne ikke oprette TXT';

  @override
  String get exportOpenActionLabel => 'Åbn';

  @override
  String get wrongPasswordInfoMessage => 'Forkert adgangskode.';

  @override
  String get noteArchivedInfoMessage => 'Note arkiveret';

  @override
  String get noteUnarchivedInfoMessage => 'Fjernet fra arkiv';

  @override
  String get noteUnlockedInfoMessage => 'Låst op';

  @override
  String get noteLockedInfoMessage => 'Note låst';

  @override
  String get notificationUnpinnedInfoMessage => 'Frigjort';

  @override
  String get emptyNotePinBlockedInfoMessage =>
      'En tom note kan ikke fastgøres.';

  @override
  String get notificationPinnedInfoMessage =>
      'Fastgjort til notifikationspanelet';

  @override
  String get noContentToReadInfoMessage => 'Der er intet indhold at læse op';

  @override
  String get backPressExitInfoMessage => 'Tryk tilbage igen for at afslutte';

  @override
  String get reminderChannelName => 'Notepåmindelser';

  @override
  String get reminderChannelDescription => 'Notepåmindelser i Layout-appen';

  @override
  String get pinnedChannelName => 'Fastgjorte noter';

  @override
  String get pinnedChannelDescription =>
      'Layout-noter fastgjort til notifikationspanelet';

  @override
  String get notificationUnpinActionLabel => 'Fjern';

  @override
  String get reminderDefaultTitle => 'Påmindelse';

  @override
  String get reminderChecklistBodyFallback =>
      'Glem ikke at tjekke din tjekliste';

  @override
  String get reminderTextBodyFallback => 'Glem ikke at tjekke din note';

  @override
  String get pdfSaveDialogTitle => 'Gem som PDF';

  @override
  String get jpgSaveDialogTitle => 'Gem som JPG';

  @override
  String get txtSaveDialogTitle => 'Gem som TXT';

  @override
  String get textSizeSheetTitle => 'Tekststørrelse';

  @override
  String get textSizeSamplePreview => 'Eksempeltekst';

  @override
  String get textSizeCancelButton => 'Annuller';

  @override
  String get textSizeApplyButton => 'Anvend';

  @override
  String get createPasswordDialogTitle => 'Opret adgangskode';

  @override
  String get createPasswordNewPasswordHint => 'Ny adgangskode';

  @override
  String get createPasswordConfirmHint => 'Gentag adgangskode';

  @override
  String get createPasswordHintQuestionDescription =>
      'Angiv et sikkerhedsspørgsmål i tilfælde af, at du glemmer din adgangskode (valgfrit).';

  @override
  String get createPasswordHintQuestionHint => 'Vælg et sikkerhedsspørgsmål';

  @override
  String get createPasswordHintAnswerHint => 'Dit svar';

  @override
  String get createPasswordCancelButton => 'Annuller';

  @override
  String get createPasswordSaveButton => 'Gem';

  @override
  String get passwordMismatchMessage => 'Adgangskoderne stemmer ikke overens!';

  @override
  String get passwordRequiredDialogTitle => 'Adgangskode påkrævet';

  @override
  String get passwordRequiredHint => 'Indtast adgangskode';

  @override
  String get forgotPasswordButtonLabel => 'Glemt adgangskode';

  @override
  String get passwordRequiredCancelButton => 'Annuller';

  @override
  String get passwordRequiredConfirmButton => 'Bekræft';

  @override
  String get securityQuestionDialogTitle => 'Sikkerhedsspørgsmål';

  @override
  String get securityQuestionAnswerHint => 'Dit svar';

  @override
  String get securityQuestionCancelButton => 'Annuller';

  @override
  String get securityQuestionConfirmButton => 'Bekræft';

  @override
  String get securityQuestionWrongAnswerMessage => 'Forkert svar. Prøv igen.';

  @override
  String get revealedPasswordDialogTitle => 'Din adgangskode';

  @override
  String get revealedPasswordLabel => 'Din notes adgangskode:';

  @override
  String get revealedPasswordOkButton => 'OK';

  @override
  String get securityQuestionPetName => 'Hvad hedder dit første kæledyr?';

  @override
  String get securityQuestionFavoriteTeacher =>
      'Hvad hedder din yndlingslærer?';

  @override
  String get securityQuestionBirthCity => 'Hvilken by er du født i?';

  @override
  String get securityQuestionFavoriteFood => 'Hvad er din yndlingsmad?';

  @override
  String get securityQuestionMotherMaidenName => 'Hvad er din mors pigenavn?';

  @override
  String get securityQuestionFirstSchool =>
      'Hvad hed den første skole, du gik på?';

  @override
  String get securityQuestionFavoriteColor => 'Hvad er din yndlingsfarve?';

  @override
  String get editFolderDialogTitle => 'Rediger mappe';

  @override
  String get newSubfolderDialogTitle => 'Ny undermappe';

  @override
  String get addFolderDialogTitle => 'Tilføj mappe';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'Oprettes i \"$parentCategory\"';
  }

  @override
  String get subfolderNameFieldLabel => 'Undermappenavn';

  @override
  String get folderNameFieldLabel => 'Mappenavn';

  @override
  String get folderColorLabel => 'Farve';

  @override
  String get folderDialogCancelButton => 'Annuller';

  @override
  String get folderDialogSaveButton => 'Gem';

  @override
  String get folderDialogAddButton => 'Tilføj';

  @override
  String get selectFolderSheetTitle => 'Vælg mappe';

  @override
  String get selectFolderAddOptionLabel => 'Tilføj mappe';

  @override
  String get removeCurrentFolderLabel => 'Fjern nuværende mappe';

  @override
  String get noteDetailsDialogTitle => 'Detaljer';

  @override
  String get noteDetailsCreatedLabel => 'Oprettet';

  @override
  String get noteDetailsModifiedLabel => 'Sidst ændret';

  @override
  String get noteDetailsCharCountLabel => 'Antal tegn';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count tegn';
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
  String get noteDetailsUnknownDateLabel => 'Ukendt';

  @override
  String get addAttachmentSheetTitle => 'Tilføj';

  @override
  String get addAttachmentImageOption => 'Tilføj billede';

  @override
  String get addAttachmentCameraOption => 'Kamera';

  @override
  String get addAttachmentFileOption => 'Tilføj fil';

  @override
  String get addAttachmentVoiceOption => 'Lydoptagelse';

  @override
  String get addAttachmentVideoOption => 'Optag video';

  @override
  String get addAttachmentScanOption => 'Scan dokument';

  @override
  String get noteActionsSheetTitle => 'Vælg handling';

  @override
  String get noteActionReminderLabel => 'Påmindelse';

  @override
  String get noteActionEditReminderLabel => 'Rediger påmindelse';

  @override
  String get noteActionSpeechToTextLabel => 'Tale til tekst';

  @override
  String get noteActionArchiveLabel => 'Arkiver';

  @override
  String get noteActionUnarchiveLabel => 'Fjern fra arkiv';

  @override
  String get noteActionLockLabel => 'Lås';

  @override
  String get noteActionUnlockLabel => 'Lås op';

  @override
  String get noteActionFavoriteLabel => 'Favorit';

  @override
  String get noteActionUnfavoriteLabel => 'Fjern fra favoritter';

  @override
  String get noteActionClassifyLabel => 'Vælg mappe';

  @override
  String get noteActionDeleteLabel => 'Slet';

  @override
  String get noteActionPinToNotificationLabel =>
      'Fastgør til notifikationspanel';

  @override
  String get noteActionUnpinFromNotificationLabel => 'Fjern fastgøring';

  @override
  String get noteActionShareLabel => 'Del';

  @override
  String get noteActionDuplicateLabel => 'Opret kopi';

  @override
  String get noteActionCopyContentLabel => 'Kopier indhold';

  @override
  String get noteActionTtsLabel => 'Læs højt';

  @override
  String get noteActionTextSizeLabel => 'Tekststørrelse';

  @override
  String get noteActionDetailsLabel => 'Detaljer';

  @override
  String get noteActionDiscardChangesLabel => 'Forkast ændringer';

  @override
  String get noteActionSelectLabel => 'Vælg';

  @override
  String get reminderEditOptionLabel => 'Skift påmindelse';

  @override
  String get reminderRemoveOptionLabel => 'Fjern påmindelse';

  @override
  String get discardChangesDialogTitle => 'Forkast ændringer';

  @override
  String get discardChangesDialogMessage =>
      'Ugemte ændringer i denne note går tabt. Er du sikker på, at du vil forkaste dem?';

  @override
  String get discardChangesCancelButton => 'Annuller';

  @override
  String get discardChangesConfirmButton => 'Forkast';

  @override
  String get pinnedNotificationDefaultTitle => 'Note';

  @override
  String get pdfFailedInfoMessage => 'Kunne ikke oprette PDF';

  @override
  String get drawingScreenTitle => 'Tegning';

  @override
  String get drawingMinimizeTooltip => 'Minimer';

  @override
  String get drawingEmptyExportWarningMessage => 'Tegn noget først';

  @override
  String get drawingEraserPartialModeLabel => 'Delvis';

  @override
  String get drawingEraserFullModeLabel => 'Fuld';

  @override
  String get drawingClearTooltip => 'Ryd';

  @override
  String get drawingZoomOutTooltip => 'Zoom ud';

  @override
  String get drawingZoomInTooltip => 'Zoom ind';

  @override
  String get drawingDeleteTooltip => 'Slet';

  @override
  String get drawingEmptyPreviewHint => 'Tryk for at tegne';

  @override
  String get settingsPageTitle => 'Indstillinger';

  @override
  String get settingsSectionGeneral => 'Generelt';

  @override
  String get settingsSectionSecurity => 'Sikkerhed';

  @override
  String get settingsSectionTheme => 'Tema';

  @override
  String get settingsSectionPersonalization => 'Personalisering';

  @override
  String get settingsSectionWidget => 'Widget';

  @override
  String get settingsSectionAbout => 'Om';

  @override
  String get settingsHintQuestionPet => 'Hvad hedder dit første kæledyr?';

  @override
  String get settingsHintQuestionTeacher => 'Hvad hedder din yndlingslærer?';

  @override
  String get settingsHintQuestionBirthCity => 'Hvilken by er du født i?';

  @override
  String get settingsHintQuestionFavoriteFood => 'Hvad er din yndlingsmad?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'Hvad er din mors pigenavn?';

  @override
  String get settingsHintQuestionFirstSchool =>
      'Hvad var den første skole, du gik på?';

  @override
  String get settingsHintQuestionFavoriteColor => 'Hvad er din yndlingsfarve?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'Sikkerhedsspørgsmål';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'Hvis du glemmer din adgangskode, kan du gendanne den ved at besvare dette spørgsmål korrekt.';

  @override
  String get settingsSecurityQuestionDropdownHint =>
      'Vælg et sikkerhedsspørgsmål';

  @override
  String get settingsSecurityQuestionAnswerHint => 'Dit svar';

  @override
  String get settingsSecurityQuestionCancelButton => 'Annuller';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'Spørgsmål og svar må ikke være tomme!';

  @override
  String get settingsSecurityQuestionSaveButton => 'Gem';

  @override
  String get settingsCreatePasswordTitle => 'Opret adgangskode';

  @override
  String get settingsPasswordRequiredTitle => 'Adgangskode påkrævet';

  @override
  String get settingsPasswordEnterHint => 'Indtast adgangskode';

  @override
  String get settingsForgotPasswordButton => 'Glemt adgangskode';

  @override
  String get settingsNewPasswordHint => 'Ny adgangskode';

  @override
  String get settingsConfirmPasswordHint => 'Gentag adgangskode';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'Angiv et sikkerhedsspørgsmål i tilfælde af, at du glemmer din adgangskode (valgfrit).';

  @override
  String get settingsPasswordDialogCancelButton => 'Annuller';

  @override
  String get settingsPasswordMismatchWarning =>
      'Adgangskoderne stemmer ikke overens!';

  @override
  String get settingsWrongPasswordWarning => 'Forkert adgangskode!';

  @override
  String get settingsPasswordSaveButton => 'Gem';

  @override
  String get settingsPasswordRemoveButton => 'Fjern';

  @override
  String get settingsNotePasswordTitle => 'Noteadgangskode';

  @override
  String get settingsPasswordSetSubtitle => 'Adgangskode angivet ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'Adgangskode ikke angivet';

  @override
  String get settingsSecurityQuestionTileTitle => 'Sikkerhedsspørgsmål';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'Angivet ✓ — bruges, hvis du glemmer din adgangskode';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'Ikke angivet — du vil ikke kunne gendanne din adgangskode, hvis den mistes';

  @override
  String get settingsThemeDialogTitle => 'Vælg tema';

  @override
  String get settingsThemeSystemDefault => 'Systemstandard';

  @override
  String get settingsThemeLightOption => 'Lyst tema';

  @override
  String get settingsThemeDarkOption => 'Mørkt tema';

  @override
  String get settingsLanguageDialogTitle => 'Vælg sprog';

  @override
  String get settingsLanguageSystemOption => 'System';

  @override
  String get settingsAccentColorDialogTitle => 'Vælg accentfarve';

  @override
  String get settingsThemeChangeTileTitle => 'Skift tema';

  @override
  String get settingsThemeLightLabel => 'Lyst';

  @override
  String get settingsThemeDarkLabel => 'Mørkt';

  @override
  String get settingsThemeSystemLabel => 'System';

  @override
  String get settingsLanguageTileTitle => 'Sprog';

  @override
  String get settingsAccentColorTileTitle => 'Accentfarve';

  @override
  String get settingsAccentColorTileSubtitle =>
      'Farve brugt i app-bjælken, knapper og kontakter';

  @override
  String get settingsColorfulNotesTitle => 'Varierede notefarver';

  @override
  String get settingsColorfulNotesSubtitle =>
      'Hvert notekort får en anden farvetone.';

  @override
  String get settingsTextColorSheetTitle => 'Tekstfarve';

  @override
  String get settingsTextColorSheetDesc =>
      'Angiver farven på noteindholdets tekst.';

  @override
  String get settingsTextColorOkButton => 'OK';

  @override
  String get settingsTextColorTileTitle => 'Tekstfarve';

  @override
  String get settingsTextColorTileSubtitle => 'Farve til noteindholdets tekst.';

  @override
  String get settingsWidgetFontSizeLabel => 'Widgetskriftstørrelse';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'Eksempeloverskrift - $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'Annuller';

  @override
  String get settingsWidgetFontSizeApplyButton => 'Anvend';

  @override
  String get settingsWidgetOpacityLabel => 'Baggrundsgennemsigtighed';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return '$percent% gennemsigtighed';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'Annuller';

  @override
  String get settingsWidgetOpacityApplyButton => 'Anvend';

  @override
  String get settingsWidgetDarkModeTitle => 'Mørk widget';

  @override
  String get settingsWidgetDarkModeDesc => 'Mørkt farveskema til widgetten.';

  @override
  String get settingsAboutVersionTitle => 'App-version';

  @override
  String get settingsFontFamilyTileTitle => 'Skrifttype';

  @override
  String get settingsFontFamilyDefaultLabel => 'Standard';

  @override
  String get settingsGlobalFontSizeTileTitle => 'Skriftstørrelse';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt — anvendes på alle noter.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'Eksempeltekst - $size pt';
  }

  @override
  String get settingsGlobalFontSizeApplyToAllLabel =>
      'Anvend på eksisterende noter';

  @override
  String get settingsGlobalFontSizeApplyToAllNote =>
      'Hvis en note har en individuel skriftstørrelse angivet, påvirker denne indstilling den ikke.';

  @override
  String get settingsGlobalFontSizeCancelButton => 'Annuller';

  @override
  String get settingsGlobalFontSizeApplyButton => 'Anvend';

  @override
  String get settingsPreviewLinesTileTitle => 'Antal forhåndsvisningslinjer';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'Vis op til $lines linjer. Hvis noten er kortere, vises det faktiske antal linjer.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'Nuværende: $lines linjer';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'Angiver det maksimale antal linjer, der vises i forhåndsvisningen. Hvis noten har færre linjer, vises det faktiske antal linjer.';

  @override
  String get settingsPreviewLinesCancelButton => 'Annuller';

  @override
  String get settingsPreviewLinesApplyButton => 'Anvend';

  @override
  String get backupCancelButton => 'Annuller';

  @override
  String get backupConnectButton => 'Forbind';

  @override
  String get backupDisconnectButton => 'Afbryd forbindelse';

  @override
  String get backupContinueButton => 'Fortsæt';

  @override
  String get backupCloseButton => 'Luk';

  @override
  String get backupShareButton => 'Del';

  @override
  String get backupRestoreButton => 'Gendan';

  @override
  String get backupConfigureButton => 'Konfigurer';

  @override
  String get backupUnknownDateLabel => 'Ukendt';

  @override
  String get backupProcessingDefaultLabel => 'Behandler...';

  @override
  String get backupPermissionRequiredTitle => 'Lagringstilladelse påkrævet';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'Denne Android-version kræver lagringstilladelse til sikkerhedskopiering/gendannelse. Da tilladelsen blev nægtet permanent, skal du aktivere den manuelt i appens indstillinger.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'Denne Android-version kræver lagringstilladelse til sikkerhedskopiering/gendannelse. Giv venligst tilladelse for at fortsætte.';

  @override
  String get backupGoToSettingsButton => 'Gå til indstillinger';

  @override
  String get backupRetryButton => 'Prøv igen';

  @override
  String get backupDriveConnectingLabel => 'Forbinder til Google-konto...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Forbundet til Google Drive-konto: $email';
  }

  @override
  String get backupDriveConnectedMessage => 'Forbundet til Google Drive-konto.';

  @override
  String get backupDriveConnectFailedMessage =>
      'Kunne ikke forbinde til Google-konto, eller handlingen blev annulleret.';

  @override
  String get backupDriveDisconnectTitle => 'Afbryd Google Drive';

  @override
  String get backupDriveDisconnectBody =>
      'Hvis du afbryder forbindelsen, kan manuelle eller automatiske sikkerhedskopier til Drive ikke foretages. Sikkerhedskopier, der allerede er gemt på Drive, slettes ikke — kun adgangen fra denne enhed fjernes.';

  @override
  String get backupDriveDisconnectedMessage =>
      'Google Drive-forbindelse fjernet.';

  @override
  String get backupDriveRequiredTitle => 'Google-konto påkrævet';

  @override
  String get backupDriveRequiredBody =>
      'Denne handling kræver, at du forbinder din Google-konto. Vil du forbinde nu?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: forbundet ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: forbundet';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: ikke forbundet';

  @override
  String get backupDriveAuthenticatingLabel => 'Bekræfter Google-konto...';

  @override
  String get backupDriveNotSignedInMessage =>
      'Du er ikke forbundet til Google Drive. Log venligst ind med din Google-konto først.';

  @override
  String get backupDriveUploadingLabel =>
      'Uploader sikkerhedskopi til Drive...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Upload til Google Drive blev ikke fuldført inden for 120 sekunder (intet svar fra serveren). Kontroller din forbindelse, og prøv igen.';

  @override
  String get backupDriveOperationCompletedLabel => 'Fuldført';

  @override
  String get backupToDriveActionLabel => 'sikkerhedskopiering til Drive';

  @override
  String get backupToDeviceActionLabel => 'sikkerhedskopiering';

  @override
  String get backupCreatingLabel => 'Opretter sikkerhedskopi...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'Sikkerhedskopi kunne ikke oprettes: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Upload til Google Drive mislykkedes: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'Sikkerhedskopi uploadet til Google Drive.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'Sikkerhedskopi oprettet: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'Sikkerhedskopi klar';

  @override
  String get backupOfferShareBody =>
      'Din sikkerhedskopifil er blevet gemt på din enhed. Vil du dele den nu (f.eks. cloud-lagring, e-mail, en anden enhed)?';

  @override
  String get backupShareFileText => 'layout sikkerhedskopifil';

  @override
  String backupShareFailedMessage(String error) {
    return 'Deling kunne ikke startes: $error';
  }

  @override
  String get backupLargeOperationTitle => 'Stor sikkerhedskopi';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'De data, der skal behandles, er cirka $sizeText. En $actionLabel af denne størrelse kan tage et stykke tid afhængigt af din enhed. Forlad blot ikke appen, mens den er i gang — vil du fortsætte?';
  }

  @override
  String get backupRestoreActionLabel => 'gendannelse';

  @override
  String get backupDriveListingLabel => 'Lister Drive-sikkerhedskopier...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'Sikkerhedskopier kunne ikke listes: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'Der er endnu ingen sikkerhedskopier på Google Drive.';

  @override
  String get backupDrivePickTitle => 'Vælg en sikkerhedskopi fra Drive';

  @override
  String get backupDriveDownloadingLabel =>
      'Downloader sikkerhedskopi fra Drive...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Downloader sikkerhedskopi fra Drive... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel => 'Gemmer fil på enheden...';

  @override
  String get backupDriveUnknownBackupFileName => 'ukendt_sikkerhedskopi.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Din Google Drive-lagerplads er fuld. Frigør venligst plads på Drive, og prøv igen.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'Der kunne ikke oprettes internetforbindelse. Kontroller din forbindelse, og prøv igen.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'Den angivne sikkerhedskopifil kunne ikke findes på Drive. Den kan være blevet slettet.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Der opstod en uventet fejl under Google Drive-handlingen: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'Download mislykkedes: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'Filen kunne ikke vælges: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'Den valgte fil kunne ikke tilgås.';

  @override
  String get backupCheckingLabel => 'Kontrollerer sikkerhedskopi...';

  @override
  String backupReadFailedMessage(String error) {
    return 'Sikkerhedskopifilen kunne ikke læses: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'Gendan sikkerhedskopi';

  @override
  String get backupPreviewContentsHeader =>
      'Indhold af den valgte sikkerhedskopi:';

  @override
  String get backupPreviewNoteCountLabel => 'Antal noter';

  @override
  String get backupPreviewTrashCountLabel => 'Noter i papirkurv';

  @override
  String get backupPreviewCategoryCountLabel => 'Antal kategorier';

  @override
  String get backupPreviewAttachmentLabel => 'Vedhæftninger';

  @override
  String get backupPreviewAttachmentNoneValue => 'Ingen';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count filer ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'Oprettet den';

  @override
  String get backupEmptyPreviewTitle => 'Denne sikkerhedskopi ser tom ud';

  @override
  String get backupEmptyPreviewBody =>
      'Der blev ikke fundet nogen noter, kategorier eller vedhæftninger i den valgte fil. Hvis du fortsætter, vil dine nuværende data stadig blive slettet og erstattet med denne tomme sikkerhedskopi.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '$count vedhæftninger blev ikke fundet i sikkerhedskopien';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'Noter med disse filer gendannes, men uden vedhæftningerne (de kan have manglet eller været beskadiget, da sikkerhedskopien blev taget): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown og $remaining mere';
  }

  @override
  String get backupRestoreConfirmBody =>
      'Dette vil ERSTATTE alle dine nuværende noter, papirkurv, kategorier, indstillinger og vedhæftninger med dataene i sikkerhedskopien ovenfor. Dine nuværende data går permanent tabt, og denne handling kan ikke fortrydes.';

  @override
  String get backupRestoringLabel => 'Gendanner sikkerhedskopi...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'Sikkerhedskopi gendannet. Dog blev $count vedhæftninger ikke fundet i sikkerhedskopien og kunne ikke gendannes. Det anbefales at genstarte appen, for at ændringerne træder fuldt ud i kraft.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'Sikkerhedskopi gendannet. Det anbefales at genstarte appen, for at ændringerne træder fuldt ud i kraft.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'Der opstod en fejl under gendannelsen: $error';
  }

  @override
  String get backupScreenTitle => 'Sikkerhedskopi & gendannelse';

  @override
  String get backupBlockedExitWarningMessage =>
      'En handling er i gang, vent venligst på, at den bliver færdig.';

  @override
  String get backupBusyBackTooltip => 'Handling i gang';

  @override
  String get backupIntroText =>
      'Du kan sikkerhedskopiere dine noter, kategorier, indstillinger og vedhæftninger som en enkelt .zip-fil eller gendanne en tidligere sikkerhedskopi.';

  @override
  String get backupDriveCardTitle => 'Sikkerhedskopier til Google Drive';

  @override
  String get backupDriveCardSubtitle =>
      'Opret en ny sikkerhedskopi, og upload den direkte til det private område på din Google Drive.';

  @override
  String get backupDriveCardButtonLabel => 'Sikkerhedskopier til Drive';

  @override
  String get backupDeviceCardTitle => 'Sikkerhedskopier til enhed';

  @override
  String get backupDeviceCardSubtitle =>
      'Gem alle dine data som en enkelt .zip-fil på din enhed, og del den, hvis du ønsker det.';

  @override
  String get backupDeviceCardButtonLabel => 'Sikkerhedskopier til enhed';

  @override
  String get backupHistoryCardTitle => 'Sikkerhedskopihistorik';

  @override
  String get backupHistoryCardSubtitle =>
      'Se alle sikkerhedskopier gemt på din enhed med dato og størrelse; du kan dele, gendanne eller slette dem direkte herfra.';

  @override
  String get backupHistoryTabDevice => 'Enhed';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'Slet sikkerhedskopi';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'Er du sikker på, at du vil slette sikkerhedskopifilen \"$fileName\" permanent? Denne handling kan ikke fortrydes.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'Sikkerhedskopi slettet.';

  @override
  String get backupHistoryDriveDeleteDialogTitle => 'Slet Drive-sikkerhedskopi';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'Er du sikker på, at du vil slette sikkerhedskopien \"$fileName\" permanent fra Google Drive? Denne handling kan ikke fortrydes, og filen flyttes ikke til papirkurven.';
  }

  @override
  String get backupHistoryDriveDeletedMessage =>
      'Drive-sikkerhedskopi slettet.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'Kunne ikke slette: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'Ingen sikkerhedskopier gemt på denne enhed endnu.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'Brug \"Sikkerhedskopier til enhed\" for at oprette din første sikkerhedskopi.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'Brug \"Sikkerhedskopier til Google Drive\" for at oprette din første cloud-sikkerhedskopi.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Forbind din Google-konto for at se dine Drive-sikkerhedskopier.';

  @override
  String get backupHistoryConnectGoogleButton => 'Forbind med Google';

  @override
  String get backupHistoryDriveConnectedFallback => 'Forbundet';

  @override
  String get backupHistoryUnknownErrorFallback => 'Der opstod en ukendt fejl.';

  @override
  String get backupHistoryDownloadStartingLabel => 'Starter...';

  @override
  String get backupAutoBackupEnabledLabel =>
      'Automatisk sikkerhedskopiering: til';

  @override
  String get backupAutoBackupDisabledLabel =>
      'Automatisk sikkerhedskopiering: fra';

  @override
  String get backupOverlayWarningMessage =>
      'Vent venligst, forlad ikke appen, før handlingen er fuldført.';

  @override
  String get pdfExportUntitledNoteLabel => 'Unavngiven note';

  @override
  String get pdfExportDefaultAttachmentName => 'Vedhæftning';

  @override
  String get pdfExportDefaultFileName => 'note';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'Skærmbillede kunne ikke tages (grænse ikke fundet)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'Skærmbilledata kunne ikke genereres';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'Billedet kunne ikke behandles (PNG-afkodning mislykkedes)';

  @override
  String get screenshotCalcTableTotalLabel => 'Total';

  @override
  String get gundemMenuRemoveFromAgenda => 'Fjern fra dagsorden';

  @override
  String get gundemMenuDeleteNote => 'Slet note';

  @override
  String get gundemSectionOverdue => 'Overskredet';

  @override
  String get gundemSectionToday => 'I dag';

  @override
  String get gundemSectionTomorrow => 'I morgen';

  @override
  String get gundemSectionNextWeek => 'Næste uge';

  @override
  String get gundemSectionFurther => 'Længere frem';

  @override
  String get gundemWeekdayMonday => 'Mandag';

  @override
  String get gundemWeekdayTuesday => 'Tirsdag';

  @override
  String get gundemWeekdayWednesday => 'Onsdag';

  @override
  String get gundemWeekdayThursday => 'Torsdag';

  @override
  String get gundemWeekdayFriday => 'Fredag';

  @override
  String get gundemWeekdaySaturday => 'Lørdag';

  @override
  String get gundemWeekdaySunday => 'Søndag';

  @override
  String get gundemAppBarTitle => 'Dagsorden';

  @override
  String get gundemCalendarTooltip => 'Kalender';

  @override
  String get gundemEmptyTitle => 'Intet på din dagsorden';

  @override
  String get gundemEmptySubtitle =>
      'Noter med en påmindelse eller en tildelt dato vises her.';

  @override
  String get gundemUntitledNote => 'Unavngiven note';

  @override
  String get gundemRepeatHourly => 'Hver time';

  @override
  String get gundemRepeatDaily => 'Dagligt';

  @override
  String get gundemRepeatWeekly => 'Ugentligt';

  @override
  String get gundemRepeatMonthly => 'Månedligt';

  @override
  String get gundemRepeatYearly => 'Årligt';

  @override
  String get gundemPreviewCalcTableLabel => '[Regneliste]';

  @override
  String get gundemPreviewDrawingLabel => '[Tegning]';

  @override
  String get gundemPreviewImageLabel => '[Billede]';

  @override
  String get gundemMonthShortJan => 'jan.';

  @override
  String get gundemMonthShortFeb => 'feb.';

  @override
  String get gundemMonthShortMar => 'mar.';

  @override
  String get gundemMonthShortApr => 'apr.';

  @override
  String get gundemMonthShortMay => 'maj';

  @override
  String get gundemMonthShortJun => 'jun.';

  @override
  String get gundemMonthShortJul => 'jul.';

  @override
  String get gundemMonthShortAug => 'aug.';

  @override
  String get gundemMonthShortSep => 'sep.';

  @override
  String get gundemMonthShortOct => 'okt.';

  @override
  String get gundemMonthShortNov => 'nov.';

  @override
  String get gundemMonthShortDec => 'dec.';

  @override
  String get calendarAppBarTitle => 'Kalender';

  @override
  String get calendarTodayButton => 'I dag';

  @override
  String get calendarLegendNoteLabel => 'Note';

  @override
  String get calendarLegendReminderLabel => 'Påmindelse';

  @override
  String get calendarTodayBadge => 'I dag';

  @override
  String get calendarEmptyDayMessage =>
      'Ingen noter eller påmindelser for denne dag.';

  @override
  String get calendarReminderHourlyLabel => 'Hver time';

  @override
  String get calendarMonthJan => 'Januar';

  @override
  String get calendarMonthFeb => 'Februar';

  @override
  String get calendarMonthMar => 'Marts';

  @override
  String get calendarMonthApr => 'April';

  @override
  String get calendarMonthMay => 'Maj';

  @override
  String get calendarMonthJun => 'Juni';

  @override
  String get calendarMonthJul => 'Juli';

  @override
  String get calendarMonthAug => 'August';

  @override
  String get calendarMonthSep => 'September';

  @override
  String get calendarMonthOct => 'Oktober';

  @override
  String get calendarMonthNov => 'November';

  @override
  String get calendarMonthDec => 'December';

  @override
  String get calendarWeekdayShortMon => 'Man';

  @override
  String get calendarWeekdayShortTue => 'Tir';

  @override
  String get calendarWeekdayShortWed => 'Ons';

  @override
  String get calendarWeekdayShortThu => 'Tor';

  @override
  String get calendarWeekdayShortFri => 'Fre';

  @override
  String get calendarWeekdayShortSat => 'Lør';

  @override
  String get calendarWeekdayShortSun => 'Søn';

  @override
  String get calendarWeekdayFullMonday => 'Mandag';

  @override
  String get calendarWeekdayFullTuesday => 'Tirsdag';

  @override
  String get calendarWeekdayFullWednesday => 'Onsdag';

  @override
  String get calendarWeekdayFullThursday => 'Torsdag';

  @override
  String get calendarWeekdayFullFriday => 'Fredag';

  @override
  String get calendarWeekdayFullSaturday => 'Lørdag';

  @override
  String get calendarWeekdayFullSunday => 'Søndag';

  @override
  String get wrongPasswordDialogTitle => 'Forkert adgangskode';

  @override
  String get wrongPasswordDialogMessage =>
      'Den indtastede adgangskode er forkert.';

  @override
  String get commonOkButton => 'OK';

  @override
  String get unlockCategoryAction => 'Lås op';

  @override
  String get lockCategoryAction => 'Lås';

  @override
  String get categoryUnlockedMessage => 'Låst op';

  @override
  String get categoryLockedMessage => 'Mappe låst';

  @override
  String get deleteFolderMenuItemLabel => 'Slet mappe';

  @override
  String get deleteFolderDialogTitle => 'Slet mappe';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'Er du sikker på, at du vil slette mappen \"$category\" og alle dens undermapper? Noter i disse mapper bliver ukategoriserede.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'Er du sikker på, at du vil slette mappen \"$category\"? Noter i denne mappe bliver ukategoriserede.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'Annuller';

  @override
  String get deleteFolderDialogConfirmButton => 'Slet';

  @override
  String get editCategoryNameColorMenuItemLabel => 'Rediger navn/farve';

  @override
  String get addSubfolderMenuItemLabel => 'Opret undermappe';

  @override
  String get expandSubfoldersMenuItemLabel => 'Udvid undermapper';

  @override
  String get collapseSubfoldersMenuItemLabel => 'Skjul undermapper';

  @override
  String saveErrorInfoMessage(String error) {
    return 'Fejl ved gemning: $error';
  }

  @override
  String get welcomeNoteTitle => 'Velkommen til DNote! 🚀';

  @override
  String get welcomeNoteContent => 'Nye funktioner tilføjet!';

  @override
  String get noteListDateGroupToday => 'I dag';

  @override
  String get noteListDateGroupYesterday => 'I går';

  @override
  String get noteListDateGroupLast7Days => 'Sidste 7 dage';

  @override
  String get noteListDateGroupLast30Days => 'Sidste 30 dage';

  @override
  String get reminderRepeatNoneLabel => 'Ingen gentagelse';

  @override
  String get voiceRecorderPreparingLabel => 'Forbereder…';

  @override
  String get voiceRecorderCancelButton => 'Annuller';

  @override
  String get voiceRecorderStopAddButton => 'Stop og tilføj';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'Mikrofontilladelse blev ikke givet.';

  @override
  String get speechToTextUnavailableMessage =>
      'Talegenkendelse er ikke tilgængelig på denne enhed.';

  @override
  String get speechToTextPreparingLabel => 'Forbereder…';

  @override
  String get speechToTextListeningLabel => 'Lytter…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'Begynd at tale…';

  @override
  String get speechToTextCancelButton => 'Annuller';

  @override
  String get speechToTextStopAddButton => 'Stop og tilføj';

  @override
  String get textToSpeechNoContentMessage => 'Der er intet indhold at læse op.';

  @override
  String get textToSpeechReadErrorMessage =>
      'Der opstod en fejl under oplæsningen.';

  @override
  String get textToSpeechUnavailableMessage =>
      'Tekst-til-tale er ikke tilgængeligt på denne enhed.';

  @override
  String get textToSpeechPreparingLabel => 'Forbereder…';

  @override
  String get textToSpeechPausedLabel => 'Sat på pause';

  @override
  String get textToSpeechFinishedLabel => 'Oplæsning fuldført';

  @override
  String get textToSpeechReadingLabel => 'Læser op…';

  @override
  String get textToSpeechCloseErrorButton => 'Luk';

  @override
  String get textToSpeechReplayButton => 'Læs igen';

  @override
  String get textToSpeechCloseFinishedButton => 'Luk';

  @override
  String get textToSpeechPauseButton => 'Pause';

  @override
  String get textToSpeechResumeButton => 'Genoptag';

  @override
  String get textToSpeechStopButton => 'Stop';

  @override
  String get textToSpeechSpeedSlow => 'Langsom';

  @override
  String get textToSpeechSpeedNormal => 'Normal';

  @override
  String get textToSpeechSpeedFast => 'Hurtig';

  @override
  String get calendarPickerCancelButton => 'Annuller';

  @override
  String get calendarPickerConfirmButton => 'Vælg';

  @override
  String get calendarPickerClearButton => 'Ryd';

  @override
  String get reminderPickerDialogTitle => 'Tilføj påmindelse';

  @override
  String get reminderPickerDateTodayOption => 'I dag';

  @override
  String get reminderPickerDateTomorrowOption => 'I morgen';

  @override
  String get reminderPickerDatePickOption => 'Vælg dato';

  @override
  String get reminderRepeatHourlyLabel => 'Hver time';

  @override
  String get reminderRepeatDailyLabel => 'Hver dag';

  @override
  String get reminderRepeatWeeklyLabel => 'Hver uge';

  @override
  String get reminderRepeatMonthlyLabel => 'Hver måned';

  @override
  String get reminderRepeatYearlyLabel => 'Hvert år';

  @override
  String get reminderPickerCalendarHelpText => 'Vælg påmindelsesdato';

  @override
  String get reminderPickerCancelButton => 'ANNULLER';

  @override
  String get reminderPickerSaveButton => 'GEM';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'Et tidspunkt i fortiden kan ikke vælges';

  @override
  String calcTableTotalLabel(String amount) {
    return 'Total: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'Forbereder data...';

  @override
  String get backupCreatePackagingNotesLabel => 'Pakker noter og kategorier...';

  @override
  String get backupCreateReadingAttachmentsLabel => 'Læser vedhæftninger...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'Læser vedhæftninger... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'Komprimerer zip-fil...';

  @override
  String get backupCreateSavingFileLabel => 'Gemmer fil...';

  @override
  String get backupRestoreValidatingLabel => 'Validerer sikkerhedskopi...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'Sikkerhedskopi valideret, forbereder data...';

  @override
  String get backupRestoreWritingNotesLabel => 'Skriver noter...';

  @override
  String get backupRestoreWritingTrashLabel => 'Skriver papirkurv...';

  @override
  String get backupRestoreTrashWrittenLabel => 'Papirkurv skrevet';

  @override
  String get backupRestoreWritingCategoriesLabel => 'Skriver kategorier...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'Kategorier skrevet';

  @override
  String get backupRestoreWritingSettingsLabel => 'Skriver indstillinger...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'Indstillinger skrevet';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'Rydder gamle vedhæftninger...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'Ingen vedhæftninger fundet, afslutter...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'Gendanner vedhæftninger... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'Fuldført';

  @override
  String get backupValidationCorruptedFileMessage =>
      'Filen er beskadiget eller er ikke en gyldig sikkerhedskopifil.';

  @override
  String get backupValidationMissingDataMessage =>
      'Der blev ikke fundet data i sikkerhedskopifilen (backup_data.json mangler).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'Sikkerhedskopidata kunne ikke læses (beskadiget JSON).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'Denne fil er ikke en sikkerhedskopi fra dnote-appen.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'Sikkerhedskopifilens versionsoplysninger kunne ikke læses.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'Denne sikkerhedskopi er i et nyere format, som den nuværende appversion ikke understøtter. Opdater venligst appen.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'Sikkerhedskopifilens versionsoplysninger er ugyldige.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'Sikkerhedskopidata har ikke det forventede format (notes-feltet mangler).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'Sikkerhedskopidata har ikke det forventede format (trash-feltet mangler).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'Sikkerhedskopidata har ikke det forventede format (kategoriliste er ugyldig).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'Sikkerhedskopidata har ikke det forventede format (settings-feltet er ugyldigt).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'Sikkerhedskopidata har ikke det forventede format (en noteregistrering er ugyldig).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'Sikkerhedskopidata har ikke det forventede format (en noteregistrering uden ID blev fundet).';

  @override
  String get backupValidationFileNotFoundMessage =>
      'Sikkerhedskopifil ikke fundet.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'Ikke nok ledig lagerplads på enheden. Frigør venligst plads, og prøv igen.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'Filadgangstilladelse blev nægtet. Kontroller appens tilladelser, og prøv igen.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'Der opstod en fejl under filhandlingen: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'Der opstod en uventet fejl: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'Kunne ikke oprette zip-arkivet (ZipEncoder returnerede null).';

  @override
  String get calcTableMenuItemLabel => 'Regneliste';

  @override
  String get tagsMenuItemLabel => 'Tags';

  @override
  String get linkDialogUrlHint => 'https://example.com';

  @override
  String get checklistItemHint => 'Tilføj punkt...';

  @override
  String get toolbarHighlightTooltip => 'Fremhæv';

  @override
  String get toolbarListTooltip => 'Liste';

  @override
  String get toolbarHideKeyboardTooltip => 'Skjul tastatur';

  @override
  String get autoBackupLocalSuccessMessage =>
      'Lokal sikkerhedskopiering gennemført.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'Lokal sikkerhedskopiering mislykkedes: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Drive-sikkerhedskopiering sprunget over: Google-konto er ikke forbundet, eller sessionen er udløbet. Åbn appen, og forbind igen.';

  @override
  String get autoBackupDriveSuccessMessage =>
      'Drive-sikkerhedskopiering gennemført.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Drive-sikkerhedskopiering mislykkedes: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'Ingen noter endnu';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'Total: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ Tegning';

  @override
  String get autoBackupSettingsAppBarTitle =>
      'Indstillinger for automatisk sikkerhedskopiering';

  @override
  String get autoBackupSettingsMainSwitchTitle =>
      'Aktiver automatisk sikkerhedskopiering';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'Dine noter sikkerhedskopieres regelmæssigt og sikkert i baggrunden.';

  @override
  String get autoBackupSettingsTargetTitle => 'Sikkerhedskopimål';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'Vælg, hvor sikkerhedskopier gemmes.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'Lokalt';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'Begge';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Forbind din konto først for at bruge Google Drive-indstillinger.';

  @override
  String get autoBackupSettingsConnectButton => 'Forbind';

  @override
  String get autoBackupSettingsFrequencyTitle => 'Sikkerhedskopieringsfrekvens';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'Der tages en sikkerhedskopi hver $hours. time';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 timer';

  @override
  String get autoBackupSettingsFrequency12h => '12 timer';

  @override
  String get autoBackupSettingsFrequency24h => '24 timer (dagligt)';

  @override
  String get autoBackupSettingsFrequency48h => '48 timer (2 dage)';

  @override
  String get autoBackupSettingsFrequency168h => '168 timer (ugentligt)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Brug kun Wi-Fi';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'Cloud-upload sker kun via Wi-Fi for at beskytte dine mobildata.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'Systemstatus';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'Automatisk sikkerhedskopiering er endnu ikke kørt.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'Sidste kørsel: $date $time ($status)\nBesked: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'Vellykket';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'Mislykkedes';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Kunne ikke forbinde til Google-konto.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'Indstillinger for automatisk sikkerhedskopiering opdateret.';

  @override
  String selectionModeDeletedMessage(int count) {
    return '$count noter slettet';
  }

  @override
  String get selectionModeArchivedMessage => 'Arkiveret';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'Vælg kategori til $count noter';
  }

  @override
  String get selectionModeAddCategoryOption => 'Tilføj kategori';

  @override
  String get selectionModeRemoveCategoryOption => 'Fjern kategori';

  @override
  String get calcTableItemHint => 'Vare...';

  @override
  String get calcTableTotalRowLabel => 'Total';

  @override
  String get textSelectionMenuShareButton => 'Del';

  @override
  String get textSelectionMenuTranslateButton => 'Oversæt';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'Deling kunne ikke startes.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'Oversættelse kunne ikke åbnes.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'I dag $time';
  }

  @override
  String lastBackupInfoDateFormat(
    String day,
    String month,
    int year,
    String time,
  ) {
    return '$day.$month.$year $time';
  }

  @override
  String lastBackupInfoLabel(String date) {
    return 'Seneste sikkerhedskopi: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage =>
      'Der er endnu ikke taget en sikkerhedskopi.';
}
