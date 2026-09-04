// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian (`no`).
class AppLocalizationsNo extends AppLocalizations {
  AppLocalizationsNo([String locale = 'no']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'Fet';

  @override
  String get toolbarItalicTooltip => 'Kursiv';

  @override
  String get toolbarUnderlineTooltip => 'Understrek';

  @override
  String get toolbarStrikethroughTooltip => 'Gjennomstreking';

  @override
  String get toolbarFontSizeTooltip => 'Skriftstørrelse';

  @override
  String get toolbarColorTooltip => 'Tekstfarge';

  @override
  String get toolbarBulletTooltip => 'Punktliste';

  @override
  String get toolbarNumberTooltip => 'Nummerert liste';

  @override
  String get toolbarIndentTooltip => 'Avsnittsinnrykk';

  @override
  String get toolbarLinkTooltip => 'Legg til / rediger / fjern lenke';

  @override
  String get toolbarDividerTooltip => 'Sett inn skillelinje';

  @override
  String get toolbarChecklistTooltip => 'Legg til sjekkliste';

  @override
  String get linkSelectTextSnackbar => 'Velg teksten du vil lenke først';

  @override
  String get linkDialogEditTitle => 'Rediger lenke';

  @override
  String get linkDialogAddTitle => 'Legg til lenke';

  @override
  String get linkDialogRemoveButton => 'Fjern lenke';

  @override
  String get linkDialogCancelButton => 'Avbryt';

  @override
  String get linkDialogConfirmButton => 'Legg til';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Kameratilgang ble avslått. Du må tillate det fra innstillingene for å spille inn video.';

  @override
  String get cameraPermissionRequiredMessage =>
      'Kameratilgang er nødvendig for å spille inn video.';

  @override
  String get openSettingsButtonLabel => 'Innstillinger';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'Skanning kunne ikke startes: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'Tekstgjenkjenning mislyktes: $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'Ingen lesbar tekst ble funnet i dokumentet';

  @override
  String get scanResultSheetTitle =>
      'Hvordan skal det skannede dokumentet legges til?';

  @override
  String get scanResultTextOnlyOption => 'Legg til bare som tekst';

  @override
  String get scanResultTextAndImageOption => 'Legg til tekst + skannet bilde';

  @override
  String get scanResultCancelOption => 'Avbryt';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'Mikrofontilgang ble avslått. Du må tillate det fra innstillingene for å ta opp lyd.';

  @override
  String get audioPermissionRequiredMessage =>
      'Mikrofontilgang er nødvendig for å ta opp lyd.';

  @override
  String get voiceRecordingDefaultLabel => 'Lydopptak';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'Beregningsliste ($count rader)';
  }

  @override
  String blockPreviewTableLabel(int count) {
    return 'Tabell ($count rader)';
  }

  @override
  String get blockPreviewDrawingLabel => 'Tegning';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count vedlegg (bilde/dokument)';
  }

  @override
  String get blockPreviewDividerLabel => 'Skillelinje';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'Sjekkliste ($count elementer)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(tom tekst)';

  @override
  String get reorderBlocksSheetTitle => 'Endre rekkefølge på blokker';

  @override
  String get reorderBlocksMoveUpTooltip => 'Flytt opp';

  @override
  String get reorderBlocksMoveDownTooltip => 'Flytt ned';

  @override
  String get reorderBlocksCloseTooltip => 'Lukk';

  @override
  String get reorderBlocksDescription =>
      'Trykk på en blokk for å velge den, og bruk deretter pilene opp/ned for å flytte den.';

  @override
  String get reorderBlocksMenuItemLabel => 'Endre rekkefølge';

  @override
  String get txtImportPickerDialogTitle => 'Velg TXT-filen som skal importeres';

  @override
  String get txtImportReadFailedMessage => 'TXT-filen kunne ikke leses';

  @override
  String get txtImportEmptyFileMessage => 'TXT-filen er tom';

  @override
  String get txtImportSuccessMessage => 'TXT importert';

  @override
  String get txtImportMenuItemLabel => 'Importer (txt)';

  @override
  String get exportMenuItemLabel => 'Eksporter';

  @override
  String get editorUndoTooltip => 'Angre';

  @override
  String get editorRedoTooltip => 'Gjør om';

  @override
  String get noteSavedMessage => 'Notat lagret';

  @override
  String get dateAssignPickerHelpText => 'Tildel notat til en dag';

  @override
  String get dateAssignChangeOption => 'Endre dato';

  @override
  String get dateAssignRemoveOption => 'Fjern tildeling';

  @override
  String get editorSubToolbarCloseTooltip => 'Lukk';

  @override
  String get titleFieldHint => 'Tittel';

  @override
  String get textBlockHint => 'Skriv notatet ditt her...';

  @override
  String get drawingBoardMenuItemLabel => 'Tegnebrett';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'Tale til tekst er bare tilgjengelig for tekstnotater';

  @override
  String get selectionModeCancelTooltip => 'Avbryt valg';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return '$count valgt';
  }

  @override
  String get selectionModeDeleteTooltip => 'Slett';

  @override
  String get selectionModeArchiveTooltip => 'Arkiver';

  @override
  String get selectionModeFolderTooltip => 'Mappe';

  @override
  String get searchFieldHint => 'Søk i notater...';

  @override
  String get emptyTrashDialogTitle => 'Tøm papirkurv';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'Alle slettede notater vil bli fjernet permanent. Er du sikker?';

  @override
  String get emptyTrashDialogCancelButton => 'Avbryt';

  @override
  String get restoreAllMenuItemLabel => 'Gjenopprett alle';

  @override
  String get sortMenuTooltip => 'Sorter notater';

  @override
  String get sortMenuAscendingLabel => 'Rekkefølge: Stigende (A-Å)';

  @override
  String get sortMenuDescendingLabel => 'Rekkefølge: Synkende (Å-A)';

  @override
  String get sortMenuByTitleLabel => 'Sorter etter: Tittel';

  @override
  String get sortMenuByModifiedDateLabel => 'Sorter etter: Sist endret';

  @override
  String get sortMenuByCreatedDateLabel => 'Sorter etter: Opprettelsesdato';

  @override
  String get sortMenuByFolderLabel => 'Sorter etter: Mappe';

  @override
  String get viewToggleGridTooltip => 'Rutenettvisning';

  @override
  String get viewToggleListTooltip => 'Listevisning';

  @override
  String get drawerHeaderSubtitle => 'Din personlige notatbok';

  @override
  String get drawerNotesSectionHeader => 'NOTATER';

  @override
  String get drawerAllNotesLabel => 'Notater';

  @override
  String get drawerFavoritesLabel => 'Favoritt';

  @override
  String get drawerAgendaLabel => 'Agenda';

  @override
  String get drawerRemindersLabel => 'Påminnelse';

  @override
  String get drawerLockedLabel => 'Låst';

  @override
  String get drawerTrashLabel => 'Papirkurv';

  @override
  String get drawerFoldersSectionHeader => 'MAPPER';

  @override
  String get drawerExpandLabel => 'Utvid';

  @override
  String get drawerCollapseLabel => 'Skjul';

  @override
  String get drawerAddFolderLabel => 'Legg til mappe';

  @override
  String get drawerAppSectionHeader => 'APP';

  @override
  String get drawerCalendarLabel => 'Kalender';

  @override
  String get drawerSettingsLabel => 'Innstillinger';

  @override
  String get drawerBackupRestoreLabel => 'Sikkerhetskopi og gjenoppretting';

  @override
  String get drawerUpgradeToProLabel => 'Oppgrader til Pro';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'Støtt utviklingen';

  @override
  String get drawerFeedbackLabel => 'Tilbakemelding';

  @override
  String get drawerRateAppLabel => 'Vurder appen';

  @override
  String get drawerAboutLabel => 'Om';

  @override
  String get noNotesFoundMessage => 'Ingen notater funnet.';

  @override
  String get trashRestoreButtonLabel => 'Gjenopprett';

  @override
  String get trashPermanentDeleteButtonLabel => 'Slett permanent';

  @override
  String get tagRenamedInfoMessage => 'Emneknagg omdøpt';

  @override
  String get tagDeletedInfoMessage => 'Emneknagg slettet';

  @override
  String get tagOptionsRenameLabel => 'Endre navn';

  @override
  String get tagOptionsDeleteLabel => 'Slett';

  @override
  String get renameTagDialogTitle => 'Endre navn på emneknagg';

  @override
  String get renameTagDialogHint => 'Nytt navn på emneknagg';

  @override
  String get renameTagDialogCancelButton => 'Avbryt';

  @override
  String get renameTagDialogSaveButton => 'Lagre';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '\"$tag\" vil bli fjernet fra $affectedCount notater. Fortsette?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'Slette emneknaggen \"$tag\"?';
  }

  @override
  String get deleteTagDialogTitle => 'Slett emneknagg';

  @override
  String get deleteTagDialogCancelButton => 'Avbryt';

  @override
  String get deleteTagDialogConfirmButton => 'Slett';

  @override
  String get tagsSheetTitle => 'Emneknagger';

  @override
  String get tagsSheetEmptyMessage =>
      'Ingen emneknagger på dette notatet ennå.';

  @override
  String get tagsSheetInputHint => 'Skriv en ny emneknagg...';

  @override
  String get tagsSheetSuggestionsLabel => 'Eksisterende emneknagger';

  @override
  String get noteDeletedInfoMessage => 'Notat slettet';

  @override
  String get noteDeletedUndoActionLabel => 'Angre';

  @override
  String get reminderSetInfoMessage => 'Påminnelse satt';

  @override
  String get reminderRemovedInfoMessage => 'Påminnelse fjernet';

  @override
  String get noteDuplicatedInfoMessage => 'Kopi opprettet';

  @override
  String get speechTextAppendedInfoMessage => 'Tekst lagt til i notat';

  @override
  String get pdfPreparingInfoMessage => 'Forbereder PDF…';

  @override
  String get pdfSavedInfoMessage => 'PDF lagret';

  @override
  String get pdfPreviewSaveActionLabel => 'Lagre';

  @override
  String get jpgPreparingInfoMessage => 'Forbereder JPG…';

  @override
  String get jpgSavedInfoMessage => 'JPG lagret';

  @override
  String get jpgFailedInfoMessage => 'Kunne ikke opprette JPG';

  @override
  String get txtPreparingInfoMessage => 'Forbereder TXT…';

  @override
  String get txtSavedInfoMessage => 'TXT lagret';

  @override
  String get txtFailedInfoMessage => 'Kunne ikke opprette TXT';

  @override
  String get exportOpenActionLabel => 'Åpne';

  @override
  String get wrongPasswordInfoMessage => 'Feil passord.';

  @override
  String get noteArchivedInfoMessage => 'Notat arkivert';

  @override
  String get noteUnarchivedInfoMessage => 'Fjernet fra arkiv';

  @override
  String get noteUnlockedInfoMessage => 'Låst opp';

  @override
  String get noteLockedInfoMessage => 'Notat låst';

  @override
  String get notificationUnpinnedInfoMessage => 'Frigjort';

  @override
  String get emptyNotePinBlockedInfoMessage => 'Et tomt notat kan ikke festes.';

  @override
  String get notificationPinnedInfoMessage => 'Festet til varslingspanelet';

  @override
  String get noContentToReadInfoMessage => 'Det er ikke noe innhold å lese';

  @override
  String get backPressExitInfoMessage => 'Trykk tilbake igjen for å avslutte';

  @override
  String get reminderChannelName => 'Notatpåminnelser';

  @override
  String get reminderChannelDescription => 'Notatpåminnelser i Layout-appen';

  @override
  String get pinnedChannelName => 'Festede notater';

  @override
  String get pinnedChannelDescription =>
      'Layout-notater festet til varslingspanelet';

  @override
  String get notificationUnpinActionLabel => 'Fjern';

  @override
  String get reminderDefaultTitle => 'Påminnelse';

  @override
  String get reminderChecklistBodyFallback =>
      'Ikke glem å sjekke sjekklisten din';

  @override
  String get reminderTextBodyFallback => 'Ikke glem å sjekke notatet ditt';

  @override
  String get pdfSaveDialogTitle => 'Lagre som PDF';

  @override
  String get jpgSaveDialogTitle => 'Lagre som JPG';

  @override
  String get txtSaveDialogTitle => 'Lagre som TXT';

  @override
  String get textSizeSheetTitle => 'Tekststørrelse';

  @override
  String get textSizeSamplePreview => 'Eksempeltekst';

  @override
  String get textSizeCancelButton => 'Avbryt';

  @override
  String get textSizeApplyButton => 'Bruk';

  @override
  String get createPasswordDialogTitle => 'Opprett passord';

  @override
  String get createPasswordNewPasswordHint => 'Nytt passord';

  @override
  String get createPasswordConfirmHint => 'Skriv inn passordet på nytt';

  @override
  String get createPasswordHintQuestionDescription =>
      'Angi et sikkerhetsspørsmål i tilfelle du glemmer passordet (valgfritt).';

  @override
  String get createPasswordHintQuestionHint => 'Velg et sikkerhetsspørsmål';

  @override
  String get createPasswordHintAnswerHint => 'Ditt svar';

  @override
  String get createPasswordCancelButton => 'Avbryt';

  @override
  String get createPasswordSaveButton => 'Lagre';

  @override
  String get passwordMismatchMessage => 'Passordene stemmer ikke overens!';

  @override
  String get passwordRequiredDialogTitle => 'Passord kreves';

  @override
  String get passwordRequiredHint => 'Skriv inn passord';

  @override
  String get forgotPasswordButtonLabel => 'Glemt passordet';

  @override
  String get passwordRequiredCancelButton => 'Avbryt';

  @override
  String get passwordRequiredConfirmButton => 'Bekreft';

  @override
  String get securityQuestionDialogTitle => 'Sikkerhetsspørsmål';

  @override
  String get securityQuestionAnswerHint => 'Ditt svar';

  @override
  String get securityQuestionCancelButton => 'Avbryt';

  @override
  String get securityQuestionConfirmButton => 'Bekreft';

  @override
  String get securityQuestionWrongAnswerMessage => 'Feil svar. Prøv igjen.';

  @override
  String get revealedPasswordDialogTitle => 'Ditt passord';

  @override
  String get revealedPasswordLabel => 'Passordet til notatet ditt:';

  @override
  String get revealedPasswordOkButton => 'OK';

  @override
  String get securityQuestionPetName => 'Hva heter ditt første kjæledyr?';

  @override
  String get securityQuestionFavoriteTeacher => 'Hva heter din favorittlærer?';

  @override
  String get securityQuestionBirthCity => 'Hvilken by ble du født i?';

  @override
  String get securityQuestionFavoriteFood => 'Hva er favorittmaten din?';

  @override
  String get securityQuestionMotherMaidenName => 'Hva er morens pikenavn?';

  @override
  String get securityQuestionFirstSchool =>
      'Hva heter den første skolen du gikk på?';

  @override
  String get securityQuestionFavoriteColor => 'Hva er favorittfargen din?';

  @override
  String get editFolderDialogTitle => 'Rediger mappe';

  @override
  String get newSubfolderDialogTitle => 'Ny undermappe';

  @override
  String get addFolderDialogTitle => 'Legg til mappe';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'Vil bli opprettet inne i \"$parentCategory\"';
  }

  @override
  String get subfolderNameFieldLabel => 'Navn på undermappe';

  @override
  String get folderNameFieldLabel => 'Mappenavn';

  @override
  String get folderColorLabel => 'Farge';

  @override
  String get folderDialogCancelButton => 'Avbryt';

  @override
  String get folderDialogSaveButton => 'Lagre';

  @override
  String get folderDialogAddButton => 'Legg til';

  @override
  String get selectFolderSheetTitle => 'Velg mappe';

  @override
  String get selectFolderAddOptionLabel => 'Legg til mappe';

  @override
  String get removeCurrentFolderLabel => 'Fjern gjeldende mappe';

  @override
  String get noteDetailsDialogTitle => 'Detaljer';

  @override
  String get noteDetailsCreatedLabel => 'Opprettet';

  @override
  String get noteDetailsModifiedLabel => 'Sist endret';

  @override
  String get noteDetailsCharCountLabel => 'Antall tegn';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count tegn';
  }

  @override
  String get noteDetailsWordCountLabel => 'Antall ord';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count ord';
  }

  @override
  String get noteDetailsOkButton => 'OK';

  @override
  String get noteDetailsUnknownDateLabel => 'Ukjent';

  @override
  String get addAttachmentSheetTitle => 'Legg til';

  @override
  String get addAttachmentImageOption => 'Legg til bilde';

  @override
  String get addAttachmentCameraOption => 'Kamera';

  @override
  String get addAttachmentFileOption => 'Legg til fil';

  @override
  String get addAttachmentVoiceOption => 'Lydopptak';

  @override
  String get addAttachmentVideoOption => 'Spill inn video';

  @override
  String get addAttachmentScanOption => 'Skann dokument';

  @override
  String get noteActionsSheetTitle => 'Velg handling';

  @override
  String get noteActionReminderLabel => 'Påminnelse';

  @override
  String get noteActionEditReminderLabel => 'Rediger påminnelse';

  @override
  String get noteActionSpeechToTextLabel => 'Tale til tekst';

  @override
  String get noteActionArchiveLabel => 'Arkiver';

  @override
  String get noteActionUnarchiveLabel => 'Fjern fra arkiv';

  @override
  String get noteActionLockLabel => 'Lås';

  @override
  String get noteActionUnlockLabel => 'Lås opp';

  @override
  String get noteActionFavoriteLabel => 'Favoritt';

  @override
  String get noteActionUnfavoriteLabel => 'Fjern fra favoritter';

  @override
  String get noteActionClassifyLabel => 'Velg mappe';

  @override
  String get noteActionDeleteLabel => 'Slett';

  @override
  String get noteActionPinToNotificationLabel => 'Fest til varslingspanel';

  @override
  String get noteActionUnpinFromNotificationLabel => 'Fjern feste';

  @override
  String get noteActionShareLabel => 'Del';

  @override
  String get noteActionDuplicateLabel => 'Opprett kopi';

  @override
  String get noteActionCopyContentLabel => 'Kopier innhold';

  @override
  String get noteActionTtsLabel => 'Les høyt';

  @override
  String get noteActionTextSizeLabel => 'Tekststørrelse';

  @override
  String get noteActionDetailsLabel => 'Detaljer';

  @override
  String get noteActionDiscardChangesLabel => 'Forkast endringer';

  @override
  String get noteActionSelectLabel => 'Velg';

  @override
  String get reminderEditOptionLabel => 'Endre påminnelse';

  @override
  String get reminderRemoveOptionLabel => 'Fjern påminnelse';

  @override
  String get discardChangesDialogTitle => 'Forkast endringer';

  @override
  String get discardChangesDialogMessage =>
      'Ulagrede endringer i dette notatet vil gå tapt. Er du sikker på at du vil forkaste dem?';

  @override
  String get discardChangesCancelButton => 'Avbryt';

  @override
  String get discardChangesConfirmButton => 'Forkast';

  @override
  String get pinnedNotificationDefaultTitle => 'Notat';

  @override
  String get pdfFailedInfoMessage => 'Kunne ikke opprette PDF';

  @override
  String get drawingScreenTitle => 'Tegning';

  @override
  String get drawingMinimizeTooltip => 'Minimer';

  @override
  String get drawingEmptyExportWarningMessage => 'Tegn noe først';

  @override
  String get drawingEraserPartialModeLabel => 'Delvis';

  @override
  String get drawingEraserFullModeLabel => 'Full';

  @override
  String get drawingClearTooltip => 'Tøm';

  @override
  String get drawingZoomOutTooltip => 'Zoom ut';

  @override
  String get drawingZoomInTooltip => 'Zoom inn';

  @override
  String get drawingDeleteTooltip => 'Slett';

  @override
  String get drawingEmptyPreviewHint => 'Trykk for å tegne';

  @override
  String get settingsPageTitle => 'Innstillinger';

  @override
  String get settingsSectionGeneral => 'Generelt';

  @override
  String get settingsSectionSecurity => 'Sikkerhet';

  @override
  String get settingsSectionTheme => 'Tema';

  @override
  String get settingsSectionPersonalization => 'Personalisering';

  @override
  String get settingsSectionWidget => 'Widget';

  @override
  String get settingsSectionAbout => 'Om';

  @override
  String get settingsHintQuestionPet => 'Hva heter ditt første kjæledyr?';

  @override
  String get settingsHintQuestionTeacher => 'Hva heter din favorittlærer?';

  @override
  String get settingsHintQuestionBirthCity => 'Hvilken by ble du født i?';

  @override
  String get settingsHintQuestionFavoriteFood => 'Hva er favorittmaten din?';

  @override
  String get settingsHintQuestionMotherMaidenName => 'Hva er morens pikenavn?';

  @override
  String get settingsHintQuestionFirstSchool =>
      'Hva var den første skolen du gikk på?';

  @override
  String get settingsHintQuestionFavoriteColor => 'Hva er favorittfargen din?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'Sikkerhetsspørsmål';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'Hvis du glemmer passordet, kan du gjenopprette det ved å svare riktig på dette spørsmålet.';

  @override
  String get settingsSecurityQuestionDropdownHint =>
      'Velg et sikkerhetsspørsmål';

  @override
  String get settingsSecurityQuestionAnswerHint => 'Ditt svar';

  @override
  String get settingsSecurityQuestionCancelButton => 'Avbryt';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'Spørsmål og svar kan ikke være tomme!';

  @override
  String get settingsSecurityQuestionSaveButton => 'Lagre';

  @override
  String get settingsCreatePasswordTitle => 'Opprett passord';

  @override
  String get settingsPasswordRequiredTitle => 'Passord kreves';

  @override
  String get settingsPasswordEnterHint => 'Skriv inn passord';

  @override
  String get settingsForgotPasswordButton => 'Glemt passordet';

  @override
  String get settingsNewPasswordHint => 'Nytt passord';

  @override
  String get settingsConfirmPasswordHint => 'Skriv inn passordet på nytt';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'Angi et sikkerhetsspørsmål i tilfelle du glemmer passordet (valgfritt).';

  @override
  String get settingsPasswordDialogCancelButton => 'Avbryt';

  @override
  String get settingsPasswordMismatchWarning =>
      'Passordene stemmer ikke overens!';

  @override
  String get settingsWrongPasswordWarning => 'Feil passord!';

  @override
  String get settingsPasswordSaveButton => 'Lagre';

  @override
  String get settingsPasswordRemoveButton => 'Fjern';

  @override
  String get settingsNotePasswordTitle => 'Notatpassord';

  @override
  String get settingsPasswordSetSubtitle => 'Passord angitt ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'Passord ikke angitt';

  @override
  String get settingsSecurityQuestionTileTitle => 'Sikkerhetsspørsmål';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'Angitt ✓ — brukes hvis du glemmer passordet';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'Ikke angitt — du vil ikke kunne gjenopprette passordet hvis det går tapt';

  @override
  String get settingsThemeDialogTitle => 'Velg tema';

  @override
  String get settingsThemeSystemDefault => 'Systemstandard';

  @override
  String get settingsThemeLightOption => 'Lyst tema';

  @override
  String get settingsThemeDarkOption => 'Mørkt tema';

  @override
  String get settingsLanguageDialogTitle => 'Velg språk';

  @override
  String get settingsLanguageSystemOption => 'System';

  @override
  String get settingsAccentColorDialogTitle => 'Velg aksentfarge';

  @override
  String get settingsThemeChangeTileTitle => 'Bytt tema';

  @override
  String get settingsThemeLightLabel => 'Lyst';

  @override
  String get settingsThemeDarkLabel => 'Mørkt';

  @override
  String get settingsThemeSystemLabel => 'System';

  @override
  String get settingsLanguageTileTitle => 'Språk';

  @override
  String get settingsAccentColorTileTitle => 'Aksentfarge';

  @override
  String get settingsAccentColorTileSubtitle =>
      'Farge brukt i topplinjen, knapper og brytere';

  @override
  String get settingsColorfulNotesTitle => 'Varierte notatfarger';

  @override
  String get settingsColorfulNotesSubtitle =>
      'Hvert notatkort får en annen fargetone.';

  @override
  String get settingsTextColorSheetTitle => 'Tekstfarge';

  @override
  String get settingsTextColorSheetDesc =>
      'Angir fargen på notatinnholdets tekst.';

  @override
  String get settingsTextColorOkButton => 'OK';

  @override
  String get settingsTextColorTileTitle => 'Tekstfarge';

  @override
  String get settingsTextColorTileSubtitle =>
      'Farge for notatinnholdets tekst.';

  @override
  String get settingsWidgetFontSizeLabel => 'Skriftstørrelse for widget';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'Eksempeloverskrift - $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'Avbryt';

  @override
  String get settingsWidgetFontSizeApplyButton => 'Bruk';

  @override
  String get settingsWidgetOpacityLabel => 'Bakgrunnsgjennomsiktighet';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return '$percent% gjennomsiktighet';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'Avbryt';

  @override
  String get settingsWidgetOpacityApplyButton => 'Bruk';

  @override
  String get settingsWidgetDarkModeTitle => 'Mørk widget';

  @override
  String get settingsWidgetDarkModeDesc => 'Mørkt fargeskjema for widgeten.';

  @override
  String get settingsAboutVersionTitle => 'Appversjon';

  @override
  String get settingsAboutVersionLoading => 'Laster versjon…';

  @override
  String get aboutSectionDeveloper => 'Tilbakemelding';

  @override
  String get aboutDeveloperTitle => 'Utvikler';

  @override
  String get aboutContactTitle => 'Kontakt';

  @override
  String get aboutWebsiteTitle => 'Nettsted';

  @override
  String get aboutGithubTitle => 'GitHub';

  @override
  String get aboutSectionLegal => 'Juridisk';

  @override
  String get aboutPrivacyPolicyTitle => 'Personvernerklæring';

  @override
  String get aboutTermsTitle => 'Bruksvilkår';

  @override
  String get aboutLicensesTitle => 'Åpen kildekode-lisenser';

  @override
  String get aboutSectionSupport => 'Vurder';

  @override
  String get aboutRateAppTitle => 'Vurder appen';

  @override
  String get aboutLinkOpenError => 'Kunne ikke åpne lenken.';

  @override
  String get settingsFontFamilyTileTitle => 'Skrift';

  @override
  String get settingsFontFamilyDefaultLabel => 'Standard';

  @override
  String get settingsGlobalFontSizeTileTitle => 'Skriftstørrelse';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt — brukes på alle notater.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'Eksempeltekst - $size pt';
  }

  @override
  String get settingsGlobalFontSizeCancelButton => 'Avbryt';

  @override
  String get settingsGlobalFontSizeApplyButton => 'Bruk';

  @override
  String get settingsPreviewLinesTileTitle =>
      'Forhåndsvisningslinjer for notat';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'Vis opptil $lines linjer. Hvis notatet er kortere, vises det faktiske antallet linjer.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'Nåværende: $lines linjer';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'Angir maksimalt antall linjer å forhåndsvise. Hvis notatet har færre linjer, vises det faktiske antallet linjer.';

  @override
  String get settingsPreviewLinesCancelButton => 'Avbryt';

  @override
  String get settingsPreviewLinesApplyButton => 'Bruk';

  @override
  String get backupCancelButton => 'Avbryt';

  @override
  String get backupConnectButton => 'Koble til';

  @override
  String get backupDisconnectButton => 'Koble fra';

  @override
  String get backupContinueButton => 'Fortsett';

  @override
  String get backupCloseButton => 'Lukk';

  @override
  String get backupShareButton => 'Del';

  @override
  String get backupRestoreButton => 'Gjenopprett';

  @override
  String get backupConfigureButton => 'Konfigurer';

  @override
  String get backupUnknownDateLabel => 'Ukjent';

  @override
  String get backupProcessingDefaultLabel => 'Behandler…';

  @override
  String get backupPermissionRequiredTitle => 'Lagringstillatelse kreves';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'Denne Android-versjonen krever lagringstillatelse for sikkerhetskopiering/gjenoppretting. Siden tillatelsen ble avslått permanent, må du aktivere den manuelt fra appinnstillingene.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'Denne Android-versjonen krever lagringstillatelse for sikkerhetskopiering/gjenoppretting. Gi tillatelse for å fortsette.';

  @override
  String get backupGoToSettingsButton => 'Gå til innstillinger';

  @override
  String get backupRetryButton => 'Prøv igjen';

  @override
  String get backupDriveConnectingLabel => 'Kobler til Google-konto…';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Koblet til Google Disk-konto: $email';
  }

  @override
  String get backupDriveConnectedMessage => 'Koblet til Google Disk-konto.';

  @override
  String get backupDriveConnectFailedMessage =>
      'Kunne ikke koble til Google-konto, eller handlingen ble avbrutt.';

  @override
  String get backupDriveDisconnectTitle => 'Koble fra Google Disk';

  @override
  String get backupDriveDisconnectBody =>
      'Hvis du kobler fra, vil ikke manuelle eller automatiske sikkerhetskopier til Disk være mulig. Sikkerhetskopier som allerede er lagret på Disk, blir ikke slettet — bare tilgangen fra denne enheten fjernes.';

  @override
  String get backupDriveDisconnectedMessage =>
      'Google Disk-tilkoblingen er fjernet.';

  @override
  String get backupDriveRequiredTitle => 'Google-konto kreves';

  @override
  String get backupDriveRequiredBody =>
      'Denne handlingen krever at du kobler til Google-kontoen din. Vil du koble til nå?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Disk: tilkoblet ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Disk: tilkoblet';

  @override
  String get backupDriveStatusDisconnected => 'Google Disk: ikke tilkoblet';

  @override
  String get backupDriveAuthenticatingLabel => 'Bekrefter Google-konto…';

  @override
  String get backupDriveNotSignedInMessage =>
      'Du er ikke koblet til Google Disk. Logg inn med Google-kontoen din først.';

  @override
  String get backupDriveUploadingLabel => 'Laster opp sikkerhetskopi til Disk…';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Opplasting til Google Disk ble ikke fullført innen 120 sekunder (ingen respons fra serveren). Kontroller tilkoblingen din og prøv igjen.';

  @override
  String get backupDriveOperationCompletedLabel => 'Fullført';

  @override
  String get backupToDriveActionLabel => 'sikkerhetskopiering til Disk';

  @override
  String get backupToDeviceActionLabel => 'sikkerhetskopiering';

  @override
  String get backupCreatingLabel => 'Oppretter sikkerhetskopi…';

  @override
  String backupCreateFailedMessage(String error) {
    return 'Sikkerhetskopi kunne ikke opprettes: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Opplasting til Google Disk mislyktes: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'Sikkerhetskopien ble lastet opp til Google Disk.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'Sikkerhetskopi opprettet: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'Sikkerhetskopi klar';

  @override
  String get backupOfferShareBody =>
      'Sikkerhetskopifilen din er lagret på enheten. Vil du dele den nå (f.eks. skylagring, e-post, en annen enhet)?';

  @override
  String get backupShareFileText => 'layout sikkerhetskopifil';

  @override
  String backupShareFailedMessage(String error) {
    return 'Deling kunne ikke startes: $error';
  }

  @override
  String get backupLargeOperationTitle => 'Stor sikkerhetskopi';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'Dataene som skal behandles er omtrent $sizeText. En $actionLabel av denne størrelsen kan ta en stund avhengig av enheten din. Bare ikke forlat appen mens den pågår — vil du fortsette?';
  }

  @override
  String get backupRestoreActionLabel => 'gjenoppretting';

  @override
  String get backupDriveListingLabel => 'Lister sikkerhetskopier på Disk…';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'Sikkerhetskopier kunne ikke listes: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'Det finnes ingen sikkerhetskopier på Google Disk ennå.';

  @override
  String get backupDrivePickTitle => 'Velg en sikkerhetskopi fra Disk';

  @override
  String get backupDriveDownloadingLabel =>
      'Laster ned sikkerhetskopi fra Disk…';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Laster ned sikkerhetskopi fra Disk… ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel => 'Lagrer fil til enhet…';

  @override
  String get backupDriveUnknownBackupFileName => 'ukjent_sikkerhetskopi.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Google Disk-lagringen din er full. Frigjør plass på Disk og prøv igjen.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'Kunne ikke opprette en internettforbindelse. Kontroller tilkoblingen din og prøv igjen.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'Den angitte sikkerhetskopifilen ble ikke funnet på Disk. Den kan ha blitt slettet.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'En uventet feil oppstod under Google Disk-operasjonen: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'Nedlasting mislyktes: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'Filen kunne ikke velges: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'Den valgte filen kunne ikke nås.';

  @override
  String get backupCheckingLabel => 'Kontrollerer sikkerhetskopi…';

  @override
  String backupReadFailedMessage(String error) {
    return 'Sikkerhetskopifilen kunne ikke leses: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'Gjenopprett sikkerhetskopi';

  @override
  String get backupPreviewContentsHeader =>
      'Innhold i den valgte sikkerhetskopien:';

  @override
  String get backupPreviewNoteCountLabel => 'Antall notater';

  @override
  String get backupPreviewTrashCountLabel => 'Notater i papirkurven';

  @override
  String get backupPreviewCategoryCountLabel => 'Antall kategorier';

  @override
  String get backupPreviewAttachmentLabel => 'Vedlegg';

  @override
  String get backupPreviewAttachmentNoneValue => 'Ingen';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count filer ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'Opprettet';

  @override
  String get backupEmptyPreviewTitle => 'Denne sikkerhetskopien ser tom ut';

  @override
  String get backupEmptyPreviewBody =>
      'Ingen notater, kategorier eller vedlegg ble funnet i den valgte filen. Hvis du fortsetter, vil de nåværende dataene dine likevel bli slettet og erstattet med denne tomme sikkerhetskopien.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '$count vedlegg ble ikke funnet i sikkerhetskopien';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'Notater med disse filene vil bli gjenopprettet, men uten vedleggene (de kan ha manglet eller vært skadet da sikkerhetskopien ble tatt): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown og $remaining til';
  }

  @override
  String get backupRestoreConfirmBody =>
      'Dette vil ERSTATTE alle dine nåværende notater, papirkurv, kategorier, innstillinger og vedlegg med dataene i sikkerhetskopien ovenfor. De nåværende dataene dine vil gå permanent tapt, og denne handlingen kan ikke angres.';

  @override
  String get backupRestoringLabel => 'Gjenoppretter sikkerhetskopi…';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'Sikkerhetskopi gjenopprettet. Imidlertid ble $count vedlegg ikke funnet i sikkerhetskopien og kunne ikke gjenopprettes. Det anbefales å starte appen på nytt for at endringene skal tre fullt i kraft.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'Sikkerhetskopien ble gjenopprettet. Det anbefales å starte appen på nytt for at endringene skal tre fullt i kraft.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'Det oppstod en feil under gjenoppretting: $error';
  }

  @override
  String get backupScreenTitle => 'Sikkerhetskopi og gjenoppretting';

  @override
  String get backupBlockedExitWarningMessage =>
      'En operasjon pågår, vennligst vent til den er fullført.';

  @override
  String get backupBusyBackTooltip => 'Operasjon pågår';

  @override
  String get backupIntroText =>
      'Du kan sikkerhetskopiere notatene, kategoriene, innstillingene og vedleggene dine som én enkelt .zip-fil, eller gjenopprette en sikkerhetskopi du tok tidligere.';

  @override
  String get backupDriveCardTitle => 'Sikkerhetskopier til Google Disk';

  @override
  String get backupDriveCardSubtitle =>
      'Opprett en ny sikkerhetskopi og last den opp direkte til det private området på Google Disk.';

  @override
  String get backupDriveCardButtonLabel => 'Sikkerhetskopier til Disk';

  @override
  String get backupDeviceCardTitle => 'Sikkerhetskopier til enhet';

  @override
  String get backupDeviceCardSubtitle =>
      'Lagre alle dataene dine som én enkelt .zip-fil på enheten din, og del den om du ønsker.';

  @override
  String get backupDeviceCardButtonLabel => 'Sikkerhetskopier til enhet';

  @override
  String get backupHistoryCardTitle => 'Sikkerhetskopihistorikk';

  @override
  String get backupHistoryCardSubtitle =>
      'Se alle sikkerhetskopier lagret på enheten din med dato og størrelse; du kan dele, gjenopprette eller slette dem direkte herfra.';

  @override
  String get backupHistoryTabDevice => 'Enhet';

  @override
  String get backupHistoryTabDrive => 'Google Disk';

  @override
  String get backupHistoryDeleteDialogTitle => 'Slett sikkerhetskopi';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'Er du sikker på at du vil slette sikkerhetskopifilen \"$fileName\" permanent? Denne handlingen kan ikke angres.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'Sikkerhetskopi slettet.';

  @override
  String get backupHistoryDriveDeleteDialogTitle =>
      'Slett sikkerhetskopi på Disk';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'Er du sikker på at du vil slette sikkerhetskopien \"$fileName\" fra Google Disk permanent? Denne handlingen kan ikke angres, og filen vil ikke bli flyttet til papirkurven.';
  }

  @override
  String get backupHistoryDriveDeletedMessage =>
      'Sikkerhetskopi på Disk slettet.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'Kunne ikke slette: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'Ingen sikkerhetskopier lagret på denne enheten ennå.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'Bruk \"Sikkerhetskopier til enhet\" for å opprette din første sikkerhetskopi.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'Bruk \"Sikkerhetskopier til Google Disk\" for å opprette din første skysikkerhetskopi.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Koble til Google-kontoen din for å se sikkerhetskopiene dine på Disk.';

  @override
  String get backupHistoryConnectGoogleButton => 'Koble til med Google';

  @override
  String get backupHistoryDriveConnectedFallback => 'Tilkoblet';

  @override
  String get backupHistoryUnknownErrorFallback => 'En ukjent feil oppstod.';

  @override
  String get backupHistoryDownloadStartingLabel => 'Starter…';

  @override
  String get backupAutoBackupEnabledLabel =>
      'Automatisk sikkerhetskopiering: på';

  @override
  String get backupAutoBackupDisabledLabel =>
      'Automatisk sikkerhetskopiering: av';

  @override
  String get backupOverlayWarningMessage =>
      'Vennligst vent, ikke forlat appen før operasjonen er fullført.';

  @override
  String get pdfExportUntitledNoteLabel => 'Notat uten tittel';

  @override
  String get pdfExportDefaultAttachmentName => 'Vedlegg';

  @override
  String get pdfExportDefaultFileName => 'notat';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'Skjermbilde kunne ikke tas (grense ikke funnet)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'Skjermbildedata kunne ikke genereres';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'Bildet kunne ikke behandles (PNG-dekoding mislyktes)';

  @override
  String get screenshotCalcTableTotalLabel => 'Totalt';

  @override
  String get gundemMenuRemoveFromAgenda => 'Fjern fra agenda';

  @override
  String get gundemMenuDeleteNote => 'Slett notat';

  @override
  String get gundemSectionOverdue => 'Forfalt';

  @override
  String get gundemSectionToday => 'I dag';

  @override
  String get gundemSectionTomorrow => 'I morgen';

  @override
  String get gundemSectionNextWeek => 'Neste uke';

  @override
  String get gundemSectionFurther => 'Lenger fram';

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
  String get gundemAppBarTitle => 'Agenda';

  @override
  String get gundemCalendarTooltip => 'Kalender';

  @override
  String get gundemEmptyTitle => 'Ingenting på agendaen';

  @override
  String get gundemEmptySubtitle =>
      'Notater med en påminnelse eller tildelt dato vises her.';

  @override
  String get gundemUntitledNote => 'Notat uten tittel';

  @override
  String get gundemRepeatHourly => 'Hver time';

  @override
  String get gundemRepeatDaily => 'Daglig';

  @override
  String get gundemRepeatWeekly => 'Ukentlig';

  @override
  String get gundemRepeatMonthly => 'Månedlig';

  @override
  String get gundemRepeatYearly => 'Årlig';

  @override
  String get gundemPreviewCalcTableLabel => '[Beregningsliste]';

  @override
  String get gundemPreviewDrawingLabel => '[Tegning]';

  @override
  String get gundemPreviewImageLabel => '[Bilde]';

  @override
  String get gundemMonthShortJan => 'jan.';

  @override
  String get gundemMonthShortFeb => 'feb.';

  @override
  String get gundemMonthShortMar => 'mar.';

  @override
  String get gundemMonthShortApr => 'apr.';

  @override
  String get gundemMonthShortMay => 'mai';

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
  String get gundemMonthShortDec => 'des.';

  @override
  String get calendarAppBarTitle => 'Kalender';

  @override
  String get calendarTodayButton => 'I dag';

  @override
  String get calendarLegendNoteLabel => 'Notat';

  @override
  String get calendarLegendReminderLabel => 'Påminnelse';

  @override
  String get calendarTodayBadge => 'I dag';

  @override
  String get calendarEmptyDayMessage =>
      'Ingen notater eller påminnelser for denne dagen.';

  @override
  String get calendarReminderHourlyLabel => 'Hver time';

  @override
  String get calendarMonthJan => 'januar';

  @override
  String get calendarMonthFeb => 'februar';

  @override
  String get calendarMonthMar => 'mars';

  @override
  String get calendarMonthApr => 'april';

  @override
  String get calendarMonthMay => 'mai';

  @override
  String get calendarMonthJun => 'juni';

  @override
  String get calendarMonthJul => 'juli';

  @override
  String get calendarMonthAug => 'august';

  @override
  String get calendarMonthSep => 'september';

  @override
  String get calendarMonthOct => 'oktober';

  @override
  String get calendarMonthNov => 'november';

  @override
  String get calendarMonthDec => 'desember';

  @override
  String get calendarWeekdayShortMon => 'man.';

  @override
  String get calendarWeekdayShortTue => 'tir.';

  @override
  String get calendarWeekdayShortWed => 'ons.';

  @override
  String get calendarWeekdayShortThu => 'tor.';

  @override
  String get calendarWeekdayShortFri => 'fre.';

  @override
  String get calendarWeekdayShortSat => 'lør.';

  @override
  String get calendarWeekdayShortSun => 'søn.';

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
  String get wrongPasswordDialogTitle => 'Feil passord';

  @override
  String get wrongPasswordDialogMessage => 'Passordet du skrev inn er feil.';

  @override
  String get commonOkButton => 'OK';

  @override
  String get unlockCategoryAction => 'Lås opp';

  @override
  String get lockCategoryAction => 'Lås';

  @override
  String get categoryUnlockedMessage => 'Låst opp';

  @override
  String get categoryLockedMessage => 'Mappe låst';

  @override
  String get deleteFolderMenuItemLabel => 'Slett mappe';

  @override
  String get deleteFolderDialogTitle => 'Slett mappe';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'Er du sikker på at du vil slette mappen \"$category\" og alle undermapper? Notater i disse mappene vil bli ukategorisert.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'Er du sikker på at du vil slette mappen \"$category\"? Notater i denne mappen vil bli ukategorisert.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'Avbryt';

  @override
  String get deleteFolderDialogConfirmButton => 'Slett';

  @override
  String get editCategoryNameColorMenuItemLabel => 'Rediger navn/farge';

  @override
  String get addSubfolderMenuItemLabel => 'Opprett undermappe';

  @override
  String get expandSubfoldersMenuItemLabel => 'Utvid undermapper';

  @override
  String get collapseSubfoldersMenuItemLabel => 'Skjul undermapper';

  @override
  String saveErrorInfoMessage(String error) {
    return 'Lagringsfeil: $error';
  }

  @override
  String get welcomeNoteTitle => 'Velkommen til Layout! 🚀';

  @override
  String get welcomeNoteContent => 'Nye funksjoner er lagt til!';

  @override
  String get noteListDateGroupToday => 'I dag';

  @override
  String get noteListDateGroupYesterday => 'I går';

  @override
  String get noteListDateGroupLast7Days => 'Siste 7 dager';

  @override
  String get noteListDateGroupLast30Days => 'Siste 30 dager';

  @override
  String get reminderRepeatNoneLabel => 'Ingen gjentakelse';

  @override
  String get voiceRecorderPreparingLabel => 'Forbereder…';

  @override
  String get voiceRecorderCancelButton => 'Avbryt';

  @override
  String get voiceRecorderStopAddButton => 'Stopp og legg til';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'Mikrofontilgang ble ikke gitt.';

  @override
  String get speechToTextUnavailableMessage =>
      'Talegjenkjenning er ikke tilgjengelig på denne enheten.';

  @override
  String get speechToTextPreparingLabel => 'Forbereder…';

  @override
  String get speechToTextListeningLabel => 'Lytter…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'Begynn å snakke…';

  @override
  String get speechToTextCancelButton => 'Avbryt';

  @override
  String get speechToTextStopAddButton => 'Stopp og legg til';

  @override
  String get textToSpeechNoContentMessage => 'Det er ikke noe innhold å lese.';

  @override
  String get textToSpeechReadErrorMessage =>
      'Det oppstod en feil under opplesing.';

  @override
  String get textToSpeechUnavailableMessage =>
      'Tekst til tale er ikke tilgjengelig på denne enheten.';

  @override
  String get textToSpeechPreparingLabel => 'Forbereder…';

  @override
  String get textToSpeechPausedLabel => 'Pauset';

  @override
  String get textToSpeechFinishedLabel => 'Opplesing fullført';

  @override
  String get textToSpeechReadingLabel => 'Leser…';

  @override
  String get textToSpeechCloseErrorButton => 'Lukk';

  @override
  String get textToSpeechReplayButton => 'Les på nytt';

  @override
  String get textToSpeechCloseFinishedButton => 'Lukk';

  @override
  String get textToSpeechPauseButton => 'Pause';

  @override
  String get textToSpeechResumeButton => 'Fortsett';

  @override
  String get textToSpeechStopButton => 'Stopp';

  @override
  String get textToSpeechSpeedSlow => 'Sakte';

  @override
  String get textToSpeechSpeedNormal => 'Normal';

  @override
  String get textToSpeechSpeedFast => 'Rask';

  @override
  String get calendarPickerCancelButton => 'Avbryt';

  @override
  String get calendarPickerConfirmButton => 'Velg';

  @override
  String get calendarPickerClearButton => 'Tøm';

  @override
  String get reminderPickerDialogTitle => 'Legg til påminnelse';

  @override
  String get reminderPickerDateTodayOption => 'I dag';

  @override
  String get reminderPickerDateTomorrowOption => 'I morgen';

  @override
  String get reminderPickerDatePickOption => 'Velg dato';

  @override
  String get reminderRepeatHourlyLabel => 'Hver time';

  @override
  String get reminderRepeatDailyLabel => 'Hver dag';

  @override
  String get reminderRepeatWeeklyLabel => 'Hver uke';

  @override
  String get reminderRepeatMonthlyLabel => 'Hver måned';

  @override
  String get reminderRepeatYearlyLabel => 'Hvert år';

  @override
  String get reminderPickerCalendarHelpText => 'Velg påminnelsesdato';

  @override
  String get reminderPickerCancelButton => 'AVBRYT';

  @override
  String get reminderPickerSaveButton => 'LAGRE';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'Et tidspunkt i fortiden kan ikke velges';

  @override
  String calcTableTotalLabel(String amount) {
    return 'Totalt: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'Forbereder data…';

  @override
  String get backupCreatePackagingNotesLabel => 'Pakker notater og kategorier…';

  @override
  String get backupCreateReadingAttachmentsLabel => 'Leser vedlegg…';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'Leser vedlegg… ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'Komprimerer zip-fil…';

  @override
  String get backupCreateSavingFileLabel => 'Lagrer fil…';

  @override
  String get backupRestoreValidatingLabel => 'Validerer sikkerhetskopi…';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'Sikkerhetskopi validert, forbereder data…';

  @override
  String get backupRestoreWritingNotesLabel => 'Skriver notater…';

  @override
  String get backupRestoreWritingTrashLabel => 'Skriver papirkurv…';

  @override
  String get backupRestoreTrashWrittenLabel => 'Papirkurv skrevet';

  @override
  String get backupRestoreWritingCategoriesLabel => 'Skriver kategorier…';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'Kategorier skrevet';

  @override
  String get backupRestoreWritingSettingsLabel => 'Skriver innstillinger…';

  @override
  String get backupRestoreSettingsWrittenLabel => 'Innstillinger skrevet';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'Rydder opp gamle vedlegg…';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'Ingen vedlegg funnet, fullfører…';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'Gjenoppretter vedlegg… ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'Fullført';

  @override
  String get backupValidationCorruptedFileMessage =>
      'Filen er skadet eller er ikke en gyldig sikkerhetskopifil.';

  @override
  String get backupValidationMissingDataMessage =>
      'Ingen data ble funnet i sikkerhetskopifilen (backup_data.json mangler).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'Sikkerhetskopidataene kunne ikke leses (skadet JSON).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'Denne filen er ikke en sikkerhetskopi fra layout-appen.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'Versjonsinformasjonen til sikkerhetskopifilen kunne ikke leses.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'Denne sikkerhetskopien er i et nyere format som den nåværende appversjonen ikke støtter. Vennligst oppdater appen.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'Versjonsinformasjonen til sikkerhetskopifilen er ugyldig.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'Sikkerhetskopidataene er ikke i forventet format (notes-feltet mangler).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'Sikkerhetskopidataene er ikke i forventet format (trash-feltet mangler).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'Sikkerhetskopidataene er ikke i forventet format (kategorilisten er ugyldig).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'Sikkerhetskopidataene er ikke i forventet format (settings-feltet er ugyldig).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'Sikkerhetskopidataene er ikke i forventet format (en notatpost er ugyldig).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'Sikkerhetskopidataene er ikke i forventet format (en notatpost uten ID ble funnet).';

  @override
  String get backupValidationFileNotFoundMessage =>
      'Sikkerhetskopifil ikke funnet.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'Ikke nok ledig lagringsplass på enheten. Frigjør plass og prøv igjen.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'Filtilgangstillatelse ble avslått. Kontroller appens tillatelser og prøv igjen.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'Det oppstod en feil under filoperasjonen: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'En uventet feil oppstod: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'Kunne ikke opprette zip-arkivet (ZipEncoder returnerte null).';

  @override
  String get calcTableMenuItemLabel => 'Beregningsliste';

  @override
  String get tableBlockMenuItemLabel => 'Tabell';

  @override
  String get tableSizePickerTitle => 'Velg tabellstørrelse';

  @override
  String get tableSizePickerCancel => 'Avbryt';

  @override
  String get tableSizePickerDeleteTooltip => 'Slett tabell';

  @override
  String get tagsMenuItemLabel => 'Emneknagger';

  @override
  String get linkDialogUrlHint => 'https://eksempel.com';

  @override
  String get checklistItemHint => 'Legg til element…';

  @override
  String get toolbarHighlightTooltip => 'Uthev';

  @override
  String get toolbarListTooltip => 'Liste';

  @override
  String get toolbarHideKeyboardTooltip => 'Skjul tastatur';

  @override
  String get autoBackupLocalSuccessMessage => 'Lokal sikkerhetskopi vellykket.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'Lokal sikkerhetskopi mislyktes: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Sikkerhetskopiering til Disk hoppet over: Google-kontoen er ikke tilkoblet, eller økten har utløpt. Åpne appen og koble til på nytt.';

  @override
  String get autoBackupDriveSuccessMessage =>
      'Sikkerhetskopiering til Disk vellykket.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Sikkerhetskopiering til Disk mislyktes: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'Ingen notater ennå';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'Totalt: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ Tegning';

  @override
  String get autoBackupSettingsAppBarTitle =>
      'Innstillinger for automatisk sikkerhetskopiering';

  @override
  String get autoBackupSettingsMainSwitchTitle =>
      'Aktiver automatisk sikkerhetskopiering';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'Notatene dine sikkerhetskopieres jevnlig og trygt i bakgrunnen.';

  @override
  String get autoBackupSettingsTargetTitle => 'Sikkerhetskopimål';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'Velg hvor sikkerhetskopier lagres.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'Lokalt';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Disk';

  @override
  String get autoBackupSettingsTargetBothOption => 'Begge';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Koble til kontoen din først for å bruke Google Disk-alternativene.';

  @override
  String get autoBackupSettingsConnectButton => 'Koble til';

  @override
  String get autoBackupSettingsFrequencyTitle => 'Sikkerhetskopieringsfrekvens';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'En sikkerhetskopi tas hver $hours. time.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 timer';

  @override
  String get autoBackupSettingsFrequency12h => '12 timer';

  @override
  String get autoBackupSettingsFrequency24h => '24 timer (daglig)';

  @override
  String get autoBackupSettingsFrequency48h => '48 timer (2 dager)';

  @override
  String get autoBackupSettingsFrequency168h => '168 timer (ukentlig)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Bruk kun Wi-Fi';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'Skyopplasting skjer bare over Wi-Fi for å spare mobildataforbruket ditt.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'Systemstatus';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'Automatisk sikkerhetskopiering har ikke kjørt ennå.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'Siste kjøring: $date $time ($status)\nMelding: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'Vellykket';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'Mislyktes';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Kunne ikke koble til Google-konto.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'Innstillinger for automatisk sikkerhetskopiering oppdatert.';

  @override
  String selectionModeDeletedMessage(int count) {
    return '$count notater slettet';
  }

  @override
  String get selectionModeArchivedMessage => 'Arkivert';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'Velg kategori for $count notater';
  }

  @override
  String get selectionModeAddCategoryOption => 'Legg til kategori';

  @override
  String get selectionModeRemoveCategoryOption => 'Fjern kategori';

  @override
  String get calcTableItemHint => 'Element…';

  @override
  String get calcTableTotalRowLabel => 'Totalt';

  @override
  String get textSelectionMenuShareButton => 'Del';

  @override
  String get textSelectionMenuTranslateButton => 'Oversett';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'Deling kunne ikke startes.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'Oversettelse kunne ikke åpnes.';

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
    return 'Siste sikkerhetskopi: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage =>
      'Ingen sikkerhetskopi er tatt ennå.';

  @override
  String get backupFileNameLabel => 'Sikkerhetskopi';

  @override
  String get tableMenuInsertRowAfter => 'Legg til rad';

  @override
  String get tableMenuDeleteRow => 'Slett rad';

  @override
  String get tableMenuInsertColumnAfter => 'Legg til kolonne';

  @override
  String get tableMenuDeleteColumn => 'Slett kolonne';

  @override
  String get imageCropToolbarTitle => 'Beskjær';

  @override
  String get imageViewerDeleteButtonLabel => 'Slett';

  @override
  String get imageViewerSaveToGalleryButtonLabel => 'Lagre';

  @override
  String get imageViewerShareButtonLabel => 'Del';

  @override
  String get imageViewerGalleryPermissionDeniedMessage =>
      'Galleritilgang ble ikke gitt';

  @override
  String get imageViewerSavedToGalleryMessage => 'Lagret i album';

  @override
  String imageViewerSaveFailedMessage(String error) {
    return 'Kunne ikke lagre: $error';
  }

  @override
  String get imageViewerSavingInProgressMessage => 'Lagrer…';

  @override
  String get imageViewerFileNotFoundMessage => 'Denne filen finnes ikke lenger';
}
