// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'Vet';

  @override
  String get toolbarItalicTooltip => 'Cursief';

  @override
  String get toolbarUnderlineTooltip => 'Onderstrepen';

  @override
  String get toolbarStrikethroughTooltip => 'Doorhalen';

  @override
  String get toolbarFontSizeTooltip => 'Lettergrootte';

  @override
  String get toolbarColorTooltip => 'Tekstkleur';

  @override
  String get toolbarBulletTooltip => 'Opsommingslijst';

  @override
  String get toolbarNumberTooltip => 'Genummerde lijst';

  @override
  String get toolbarIndentTooltip => 'Alinea-inspringing';

  @override
  String get toolbarLinkTooltip => 'Link toevoegen/bewerken/verwijderen';

  @override
  String get toolbarDividerTooltip => 'Scheidingslijn invoegen';

  @override
  String get toolbarChecklistTooltip => 'Checklist toevoegen';

  @override
  String get linkSelectTextSnackbar =>
      'Selecteer eerst de tekst die u wilt koppelen';

  @override
  String get linkDialogEditTitle => 'Link bewerken';

  @override
  String get linkDialogAddTitle => 'Link toevoegen';

  @override
  String get linkDialogRemoveButton => 'Link verwijderen';

  @override
  String get linkDialogCancelButton => 'Annuleren';

  @override
  String get linkDialogConfirmButton => 'Toevoegen';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Camera-toestemming geweigerd. U moet dit via de instellingen toestaan om video op te nemen.';

  @override
  String get cameraPermissionRequiredMessage =>
      'Camera-toestemming is vereist om video op te nemen.';

  @override
  String get openSettingsButtonLabel => 'Instellingen';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'Scannen kon niet worden gestart: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'Tekstherkenning mislukt: $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'Er is geen leesbare tekst gevonden in het document';

  @override
  String get scanResultSheetTitle =>
      'Hoe moet het gescande document worden toegevoegd?';

  @override
  String get scanResultTextOnlyOption => 'Alleen als tekst toevoegen';

  @override
  String get scanResultTextAndImageOption =>
      'Tekst + gescande afbeelding toevoegen';

  @override
  String get scanResultCancelOption => 'Annuleren';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'Microfoontoestemming geweigerd. U moet dit via de instellingen toestaan om audio op te nemen.';

  @override
  String get audioPermissionRequiredMessage =>
      'Microfoontoestemming is vereist om audio op te nemen.';

  @override
  String get voiceRecordingDefaultLabel => 'Spraakopname';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'Rekenlijst ($count rijen)';
  }

  @override
  String blockPreviewTableLabel(int count) {
    return 'Tabel ($count rijen)';
  }

  @override
  String get blockPreviewDrawingLabel => 'Tekening';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count bijlagen (foto/document)';
  }

  @override
  String get blockPreviewDividerLabel => 'Scheidingslijn';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'Checklist ($count items)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(lege tekst)';

  @override
  String get reorderBlocksSheetTitle => 'Blokken opnieuw ordenen';

  @override
  String get reorderBlocksMoveUpTooltip => 'Omhoog verplaatsen';

  @override
  String get reorderBlocksMoveDownTooltip => 'Omlaag verplaatsen';

  @override
  String get reorderBlocksCloseTooltip => 'Sluiten';

  @override
  String get reorderBlocksDescription =>
      'Tik op een blok om het te selecteren en gebruik dan de pijlen omhoog/omlaag om het te verplaatsen.';

  @override
  String get reorderBlocksMenuItemLabel => 'Opnieuw ordenen';

  @override
  String get txtImportPickerDialogTitle =>
      'Selecteer het te importeren TXT-bestand';

  @override
  String get txtImportReadFailedMessage =>
      'Het TXT-bestand kon niet worden gelezen';

  @override
  String get txtImportEmptyFileMessage => 'Het TXT-bestand is leeg';

  @override
  String get txtImportSuccessMessage => 'TXT geïmporteerd';

  @override
  String get txtImportMenuItemLabel => 'Importeren (txt)';

  @override
  String get exportMenuItemLabel => 'Exporteren';

  @override
  String get editorUndoTooltip => 'Ongedaan maken';

  @override
  String get editorRedoTooltip => 'Opnieuw uitvoeren';

  @override
  String get noteSavedMessage => 'Notitie opgeslagen';

  @override
  String get dateAssignPickerHelpText => 'Notitie toewijzen aan een dag';

  @override
  String get dateAssignChangeOption => 'Datum wijzigen';

  @override
  String get dateAssignRemoveOption => 'Toewijzing verwijderen';

  @override
  String get editorSubToolbarCloseTooltip => 'Sluiten';

  @override
  String get titleFieldHint => 'Titel';

  @override
  String get textBlockHint => 'Schrijf hier uw notitie...';

  @override
  String get drawingBoardMenuItemLabel => 'Tekenbord';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'Spraak naar tekst is alleen beschikbaar voor tekstnotities';

  @override
  String get selectionModeCancelTooltip => 'Selectie annuleren';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return '$count geselecteerd';
  }

  @override
  String get selectionModeDeleteTooltip => 'Verwijderen';

  @override
  String get selectionModeArchiveTooltip => 'Archiveren';

  @override
  String get selectionModeFolderTooltip => 'Map';

  @override
  String get searchFieldHint => 'Notities zoeken...';

  @override
  String get emptyTrashDialogTitle => 'Prullenbak legen';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'Alle verwijderde notities worden permanent verwijderd. Weet u het zeker?';

  @override
  String get emptyTrashDialogCancelButton => 'Annuleren';

  @override
  String get restoreAllMenuItemLabel => 'Alles herstellen';

  @override
  String get sortMenuTooltip => 'Notities sorteren';

  @override
  String get sortMenuAscendingLabel => 'Volgorde: Oplopend (A-Z)';

  @override
  String get sortMenuDescendingLabel => 'Volgorde: Aflopend (Z-A)';

  @override
  String get sortMenuByTitleLabel => 'Sorteren op: Titel';

  @override
  String get sortMenuByModifiedDateLabel => 'Sorteren op: Laatst gewijzigd';

  @override
  String get sortMenuByCreatedDateLabel => 'Sorteren op: Aanmaakdatum';

  @override
  String get sortMenuByFolderLabel => 'Sorteren op: Map';

  @override
  String get viewToggleGridTooltip => 'Rasterweergave';

  @override
  String get viewToggleListTooltip => 'Lijstweergave';

  @override
  String get drawerHeaderSubtitle => 'Uw persoonlijke notitieboek';

  @override
  String get drawerNotesSectionHeader => 'NOTITIES';

  @override
  String get drawerAllNotesLabel => 'Notities';

  @override
  String get drawerFavoritesLabel => 'Favoriet';

  @override
  String get drawerAgendaLabel => 'Agenda';

  @override
  String get drawerRemindersLabel => 'Herinnering';

  @override
  String get drawerLockedLabel => 'Vergrendeld';

  @override
  String get drawerTrashLabel => 'Prullenbak';

  @override
  String get drawerPlanningSectionHeader => 'PLANNING';

  @override
  String get drawerFoldersSectionHeader => 'MAPPEN';

  @override
  String get drawerExpandLabel => 'Uitvouwen';

  @override
  String get drawerCollapseLabel => 'Samenvouwen';

  @override
  String get drawerAddFolderLabel => 'Map toevoegen';

  @override
  String get drawerAppSectionHeader => 'APP';

  @override
  String get drawerCalendarLabel => 'Kalender';

  @override
  String get drawerSettingsLabel => 'Instellingen';

  @override
  String get drawerBackupRestoreLabel => 'Back-up & Herstel';

  @override
  String get drawerUpgradeToProLabel => 'Upgraden naar Pro';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'Ontwikkeling steunen';

  @override
  String get drawerFeedbackLabel => 'Feedback';

  @override
  String get drawerRateAppLabel => 'Beoordeel de app';

  @override
  String get drawerAboutLabel => 'Over';

  @override
  String get noNotesFoundMessage => 'Geen notities gevonden.';

  @override
  String get trashRestoreButtonLabel => 'Herstellen';

  @override
  String get trashPermanentDeleteButtonLabel => 'Permanent verwijderen';

  @override
  String get tagRenamedInfoMessage => 'Label hernoemd';

  @override
  String get tagDeletedInfoMessage => 'Label verwijderd';

  @override
  String get tagOptionsRenameLabel => 'Hernoemen';

  @override
  String get tagOptionsDeleteLabel => 'Verwijderen';

  @override
  String get renameTagDialogTitle => 'Label hernoemen';

  @override
  String get renameTagDialogHint => 'Nieuwe labelnaam';

  @override
  String get renameTagDialogCancelButton => 'Annuleren';

  @override
  String get renameTagDialogSaveButton => 'Opslaan';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '\"$tag\" wordt verwijderd uit $affectedCount notities. Doorgaan?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'Label \"$tag\" verwijderen?';
  }

  @override
  String get deleteTagDialogTitle => 'Label verwijderen';

  @override
  String get deleteTagDialogCancelButton => 'Annuleren';

  @override
  String get deleteTagDialogConfirmButton => 'Verwijderen';

  @override
  String get tagsSheetTitle => 'Labels';

  @override
  String get tagsSheetEmptyMessage => 'Deze notitie heeft nog geen labels.';

  @override
  String get tagsSheetInputHint => 'Schrijf een nieuw label...';

  @override
  String get tagsSheetSuggestionsLabel => 'Bestaande labels';

  @override
  String get noteDeletedInfoMessage => 'Notitie verwijderd';

  @override
  String get noteDeletedUndoActionLabel => 'Ongedaan maken';

  @override
  String get reminderSetInfoMessage => 'Herinnering ingesteld';

  @override
  String get reminderRemovedInfoMessage => 'Herinnering verwijderd';

  @override
  String get noteDuplicatedInfoMessage => 'Kopie gemaakt';

  @override
  String get speechTextAppendedInfoMessage => 'Tekst toegevoegd aan notitie';

  @override
  String get pdfPreparingInfoMessage => 'PDF wordt voorbereid…';

  @override
  String get pdfSavedInfoMessage => 'PDF opgeslagen';

  @override
  String get pdfPreviewSaveActionLabel => 'Opslaan';

  @override
  String get jpgPreparingInfoMessage => 'JPG wordt voorbereid…';

  @override
  String get jpgSavedInfoMessage => 'JPG opgeslagen';

  @override
  String get jpgFailedInfoMessage => 'JPG kon niet worden gemaakt';

  @override
  String get txtPreparingInfoMessage => 'TXT wordt voorbereid…';

  @override
  String get txtSavedInfoMessage => 'TXT opgeslagen';

  @override
  String get txtFailedInfoMessage => 'TXT kon niet worden gemaakt';

  @override
  String get exportOpenActionLabel => 'Openen';

  @override
  String get wrongPasswordInfoMessage => 'Onjuist wachtwoord.';

  @override
  String get noteArchivedInfoMessage => 'Notitie gearchiveerd';

  @override
  String get noteUnarchivedInfoMessage => 'Verwijderd uit archief';

  @override
  String get noteUnlockedInfoMessage => 'Ontgrendeld';

  @override
  String get noteLockedInfoMessage => 'Notitie vergrendeld';

  @override
  String get notificationUnpinnedInfoMessage => 'Losgemaakt';

  @override
  String get emptyNotePinBlockedInfoMessage =>
      'Een lege notitie kan niet worden vastgezet.';

  @override
  String get notificationPinnedInfoMessage =>
      'Vastgezet in het meldingenpaneel';

  @override
  String get noContentToReadInfoMessage => 'Er is geen inhoud om voor te lezen';

  @override
  String get backPressExitInfoMessage =>
      'Druk nogmaals op terug om af te sluiten';

  @override
  String get reminderChannelName => 'Notitieherinneringen';

  @override
  String get reminderChannelDescription =>
      'Notitieherinneringen in de Layout-app';

  @override
  String get pinnedChannelName => 'Vastgezette notities';

  @override
  String get pinnedChannelDescription =>
      'Layout-notities vastgezet in het meldingenpaneel';

  @override
  String get notificationUnpinActionLabel => 'Verwijderen';

  @override
  String get reminderDefaultTitle => 'Herinnering';

  @override
  String get reminderChecklistBodyFallback =>
      'Vergeet niet uw checklist te bekijken';

  @override
  String get reminderTextBodyFallback => 'Vergeet niet uw notitie te bekijken';

  @override
  String get pdfSaveDialogTitle => 'Opslaan als PDF';

  @override
  String get jpgSaveDialogTitle => 'Opslaan als JPG';

  @override
  String get txtSaveDialogTitle => 'Opslaan als TXT';

  @override
  String get textSizeSheetTitle => 'Tekstgrootte';

  @override
  String get textSizeSamplePreview => 'Voorbeeldtekst';

  @override
  String get textSizeCancelButton => 'Annuleren';

  @override
  String get textSizeApplyButton => 'Toepassen';

  @override
  String get createPasswordDialogTitle => 'Wachtwoord aanmaken';

  @override
  String get createPasswordNewPasswordHint => 'Nieuw wachtwoord';

  @override
  String get createPasswordConfirmHint => 'Wachtwoord opnieuw invoeren';

  @override
  String get createPasswordHintQuestionDescription =>
      'Stel een beveiligingsvraag in voor het geval u uw wachtwoord vergeet (optioneel).';

  @override
  String get createPasswordHintQuestionHint => 'Kies een beveiligingsvraag';

  @override
  String get createPasswordHintAnswerHint => 'Uw antwoord';

  @override
  String get createPasswordCancelButton => 'Annuleren';

  @override
  String get createPasswordSaveButton => 'Opslaan';

  @override
  String get passwordMismatchMessage => 'Wachtwoorden komen niet overeen!';

  @override
  String get passwordRequiredDialogTitle => 'Wachtwoord vereist';

  @override
  String get passwordRequiredHint => 'Voer wachtwoord in';

  @override
  String get forgotPasswordButtonLabel => 'Ik ben mijn wachtwoord vergeten';

  @override
  String get passwordRequiredCancelButton => 'Annuleren';

  @override
  String get passwordRequiredConfirmButton => 'Bevestigen';

  @override
  String get securityQuestionDialogTitle => 'Beveiligingsvraag';

  @override
  String get securityQuestionAnswerHint => 'Uw antwoord';

  @override
  String get securityQuestionCancelButton => 'Annuleren';

  @override
  String get securityQuestionConfirmButton => 'Bevestigen';

  @override
  String get securityQuestionWrongAnswerMessage =>
      'Onjuist antwoord. Probeer het opnieuw.';

  @override
  String get revealedPasswordDialogTitle => 'Uw wachtwoord';

  @override
  String get revealedPasswordLabel => 'Uw notitiewachtwoord:';

  @override
  String get revealedPasswordOkButton => 'OK';

  @override
  String get securityQuestionPetName =>
      'Wat is de naam van uw eerste huisdier?';

  @override
  String get securityQuestionFavoriteTeacher =>
      'Wat is de naam van uw favoriete leraar/lerares?';

  @override
  String get securityQuestionBirthCity => 'In welke stad bent u geboren?';

  @override
  String get securityQuestionFavoriteFood => 'Wat is uw favoriete eten?';

  @override
  String get securityQuestionMotherMaidenName =>
      'Wat is de meisjesnaam van uw moeder?';

  @override
  String get securityQuestionFirstSchool =>
      'Wat is de naam van de eerste school die u bezocht?';

  @override
  String get securityQuestionFavoriteColor => 'Wat is uw favoriete kleur?';

  @override
  String get editFolderDialogTitle => 'Map bewerken';

  @override
  String get newSubfolderDialogTitle => 'Nieuwe submap';

  @override
  String get addFolderDialogTitle => 'Map toevoegen';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'Wordt aangemaakt binnen \"$parentCategory\"';
  }

  @override
  String get subfolderNameFieldLabel => 'Naam van submap';

  @override
  String get folderNameFieldLabel => 'Naam van map';

  @override
  String get folderColorLabel => 'Kleur';

  @override
  String get folderDialogCancelButton => 'Annuleren';

  @override
  String get folderDialogSaveButton => 'Opslaan';

  @override
  String get folderDialogAddButton => 'Toevoegen';

  @override
  String get selectFolderSheetTitle => 'Map selecteren';

  @override
  String get selectFolderAddOptionLabel => 'Map toevoegen';

  @override
  String get removeCurrentFolderLabel => 'Huidige map verwijderen';

  @override
  String get noteDetailsDialogTitle => 'Details';

  @override
  String get noteDetailsCreatedLabel => 'Aangemaakt';

  @override
  String get noteDetailsModifiedLabel => 'Laatst gewijzigd';

  @override
  String get noteDetailsCharCountLabel => 'Aantal tekens';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count tekens';
  }

  @override
  String get noteDetailsWordCountLabel => 'Aantal woorden';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count woorden';
  }

  @override
  String get noteDetailsOkButton => 'OK';

  @override
  String get noteDetailsUnknownDateLabel => 'Onbekend';

  @override
  String get addAttachmentSheetTitle => 'Toevoegen';

  @override
  String get addAttachmentImageOption => 'Afbeelding toevoegen';

  @override
  String get addAttachmentCameraOption => 'Camera';

  @override
  String get addAttachmentFileOption => 'Bestand toevoegen';

  @override
  String get addAttachmentVoiceOption => 'Spraakopname';

  @override
  String get addAttachmentVideoOption => 'Video opnemen';

  @override
  String get addAttachmentScanOption => 'Document scannen';

  @override
  String get noteActionsSheetTitle => 'Actie kiezen';

  @override
  String get noteActionReminderLabel => 'Herinnering';

  @override
  String get noteActionEditReminderLabel => 'Herinnering bewerken';

  @override
  String get noteActionSpeechToTextLabel => 'Spraak naar tekst';

  @override
  String get noteActionArchiveLabel => 'Archiveren';

  @override
  String get noteActionUnarchiveLabel => 'Uit archief verwijderen';

  @override
  String get noteActionLockLabel => 'Vergrendelen';

  @override
  String get noteActionUnlockLabel => 'Ontgrendelen';

  @override
  String get noteActionFavoriteLabel => 'Favoriet';

  @override
  String get noteActionUnfavoriteLabel => 'Uit favorieten verwijderen';

  @override
  String get noteActionClassifyLabel => 'Map selecteren';

  @override
  String get noteActionDeleteLabel => 'Verwijderen';

  @override
  String get noteActionPinToNotificationLabel =>
      'Vastzetten in meldingenpaneel';

  @override
  String get noteActionUnpinFromNotificationLabel => 'Vastzetten opheffen';

  @override
  String get noteActionShareLabel => 'Delen';

  @override
  String get noteActionDuplicateLabel => 'Kopie maken';

  @override
  String get noteActionCopyContentLabel => 'Inhoud kopiëren';

  @override
  String get noteActionTtsLabel => 'Voorlezen';

  @override
  String get noteActionTextSizeLabel => 'Tekstgrootte';

  @override
  String get noteActionDetailsLabel => 'Details';

  @override
  String get noteActionDiscardChangesLabel => 'Wijzigingen verwerpen';

  @override
  String get noteActionSelectLabel => 'Selecteren';

  @override
  String get reminderEditOptionLabel => 'Herinnering wijzigen';

  @override
  String get reminderRemoveOptionLabel => 'Herinnering verwijderen';

  @override
  String get discardChangesDialogTitle => 'Wijzigingen verwerpen';

  @override
  String get discardChangesDialogMessage =>
      'Niet-opgeslagen wijzigingen in deze notitie gaan verloren. Weet u zeker dat u ze wilt verwerpen?';

  @override
  String get discardChangesCancelButton => 'Annuleren';

  @override
  String get discardChangesConfirmButton => 'Verwerpen';

  @override
  String get pinnedNotificationDefaultTitle => 'Notitie';

  @override
  String get pdfFailedInfoMessage => 'PDF maken mislukt';

  @override
  String get drawingScreenTitle => 'Tekening';

  @override
  String get drawingMinimizeTooltip => 'Minimaliseren';

  @override
  String get drawingEmptyExportWarningMessage => 'Teken eerst iets';

  @override
  String get drawingEraserPartialModeLabel => 'Gedeeltelijk';

  @override
  String get drawingEraserFullModeLabel => 'Volledig';

  @override
  String get drawingClearTooltip => 'Wissen';

  @override
  String get drawingZoomOutTooltip => 'Uitzoomen';

  @override
  String get drawingZoomInTooltip => 'Inzoomen';

  @override
  String get drawingDeleteTooltip => 'Verwijderen';

  @override
  String get drawingEmptyPreviewHint => 'Tik om te tekenen';

  @override
  String get settingsPageTitle => 'Instellingen';

  @override
  String get settingsSectionGeneral => 'Algemeen';

  @override
  String get settingsSectionSecurity => 'Beveiliging';

  @override
  String get settingsSectionTheme => 'Thema';

  @override
  String get settingsSectionPersonalization => 'Personalisatie';

  @override
  String get settingsSectionWidget => 'Widget';

  @override
  String get settingsSectionAbout => 'Over';

  @override
  String get settingsHintQuestionPet =>
      'Wat is de naam van uw eerste huisdier?';

  @override
  String get settingsHintQuestionTeacher =>
      'Wat is de naam van uw favoriete leraar/lerares?';

  @override
  String get settingsHintQuestionBirthCity => 'In welke stad bent u geboren?';

  @override
  String get settingsHintQuestionFavoriteFood => 'Wat is uw favoriete eten?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'Wat is de meisjesnaam van uw moeder?';

  @override
  String get settingsHintQuestionFirstSchool =>
      'Wat was de eerste school die u bezocht?';

  @override
  String get settingsHintQuestionFavoriteColor => 'Wat is uw favoriete kleur?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'Beveiligingsvraag';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'Als u uw wachtwoord vergeet, kunt u het herstellen door deze vraag correct te beantwoorden.';

  @override
  String get settingsSecurityQuestionDropdownHint =>
      'Kies een beveiligingsvraag';

  @override
  String get settingsSecurityQuestionAnswerHint => 'Uw antwoord';

  @override
  String get settingsSecurityQuestionCancelButton => 'Annuleren';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'Vraag en antwoord mogen niet leeg zijn!';

  @override
  String get settingsSecurityQuestionSaveButton => 'Opslaan';

  @override
  String get settingsCreatePasswordTitle => 'Wachtwoord aanmaken';

  @override
  String get settingsPasswordRequiredTitle => 'Wachtwoord vereist';

  @override
  String get settingsPasswordEnterHint => 'Voer wachtwoord in';

  @override
  String get settingsForgotPasswordButton => 'Ik ben mijn wachtwoord vergeten';

  @override
  String get settingsNewPasswordHint => 'Nieuw wachtwoord';

  @override
  String get settingsConfirmPasswordHint => 'Wachtwoord opnieuw invoeren';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'Stel een beveiligingsvraag in voor het geval u uw wachtwoord vergeet (optioneel).';

  @override
  String get settingsPasswordDialogCancelButton => 'Annuleren';

  @override
  String get settingsPasswordMismatchWarning =>
      'Wachtwoorden komen niet overeen!';

  @override
  String get settingsWrongPasswordWarning => 'Onjuist wachtwoord!';

  @override
  String get settingsPasswordSaveButton => 'Opslaan';

  @override
  String get settingsPasswordRemoveButton => 'Verwijderen';

  @override
  String get settingsNotePasswordTitle => 'Notitiewachtwoord';

  @override
  String get settingsPasswordSetSubtitle => 'Wachtwoord ingesteld ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'Wachtwoord niet ingesteld';

  @override
  String get settingsSecurityQuestionTileTitle => 'Beveiligingsvraag';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'Ingesteld ✓ — gebruikt als u uw wachtwoord vergeet';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'Niet ingesteld — u kunt uw wachtwoord niet herstellen als u het kwijtraakt';

  @override
  String get settingsThemeDialogTitle => 'Thema selecteren';

  @override
  String get settingsThemeSystemDefault => 'Systeemstandaard';

  @override
  String get settingsThemeLightOption => 'Licht thema';

  @override
  String get settingsThemeDarkOption => 'Donker thema';

  @override
  String get settingsLanguageDialogTitle => 'Taal selecteren';

  @override
  String get settingsLanguageSystemOption => 'Systeem';

  @override
  String get settingsAccentColorDialogTitle => 'Accentkleur kiezen';

  @override
  String get settingsThemeChangeTileTitle => 'Thema wijzigen';

  @override
  String get settingsThemeLightLabel => 'Licht';

  @override
  String get settingsThemeDarkLabel => 'Donker';

  @override
  String get settingsThemeSystemLabel => 'Systeem';

  @override
  String get settingsLanguageTileTitle => 'Taal';

  @override
  String get settingsAccentColorTileTitle => 'Accentkleur';

  @override
  String get settingsAccentColorTileSubtitle =>
      'Kleur gebruikt in de appbalk, knoppen en schakelaars';

  @override
  String get settingsColorfulNotesTitle => 'Gevarieerde notitiekleuren';

  @override
  String get settingsColorfulNotesSubtitle =>
      'Elke notitiekaart krijgt een andere kleurtint.';

  @override
  String get settingsTextColorSheetTitle => 'Tekstkleur';

  @override
  String get settingsTextColorSheetDesc =>
      'Stelt de kleur van de notitietekst in.';

  @override
  String get settingsTextColorOkButton => 'OK';

  @override
  String get settingsTextColorTileTitle => 'Tekstkleur';

  @override
  String get settingsTextColorTileSubtitle => 'Kleur voor de notitietekst.';

  @override
  String get settingsWidgetFontSizeLabel => 'Lettergrootte widget';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'Voorbeeldkop - $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'Annuleren';

  @override
  String get settingsWidgetFontSizeApplyButton => 'Toepassen';

  @override
  String get settingsWidgetOpacityLabel => 'Achtergrondtransparantie';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return '$percent% transparantie';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'Annuleren';

  @override
  String get settingsWidgetOpacityApplyButton => 'Toepassen';

  @override
  String get settingsWidgetDarkModeTitle => 'Donkere widget';

  @override
  String get settingsWidgetDarkModeDesc =>
      'Donker kleurenschema voor de widget.';

  @override
  String get settingsAboutVersionTitle => 'App-versie';

  @override
  String get settingsAboutVersionLoading => 'Versie laden…';

  @override
  String get aboutSectionDeveloper => 'Feedback';

  @override
  String get aboutDeveloperTitle => 'Ontwikkelaar';

  @override
  String get aboutContactTitle => 'Contact';

  @override
  String get aboutWebsiteTitle => 'Website';

  @override
  String get aboutGithubTitle => 'GitHub';

  @override
  String get aboutSectionLegal => 'Juridisch';

  @override
  String get aboutPrivacyPolicyTitle => 'Privacybeleid';

  @override
  String get aboutTermsTitle => 'Gebruiksvoorwaarden';

  @override
  String get aboutLicensesTitle => 'Opensource-licenties';

  @override
  String get aboutSectionSupport => 'Beoordelen';

  @override
  String get aboutRateAppTitle => 'Beoordeel de app';

  @override
  String get aboutLinkOpenError => 'Kan de link niet openen.';

  @override
  String get settingsFontFamilyTileTitle => 'Lettertype';

  @override
  String get settingsFontFamilyDefaultLabel => 'Standaard';

  @override
  String get settingsGlobalFontSizeTileTitle => 'Lettergrootte';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt — toegepast op alle notities.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'Voorbeeldtekst - $size pt';
  }

  @override
  String get settingsGlobalFontSizeCancelButton => 'Annuleren';

  @override
  String get settingsGlobalFontSizeApplyButton => 'Toepassen';

  @override
  String get settingsPreviewLinesTileTitle => 'Voorbeeldregels notitie';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'Toon tot $lines regels. Als de notitie korter is, wordt het werkelijke aantal regels getoond.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'Huidig: $lines regels';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'Stelt het maximale aantal regels voor het voorbeeld in. Als de notitie minder regels heeft, wordt het werkelijke aantal getoond.';

  @override
  String get settingsPreviewLinesCancelButton => 'Annuleren';

  @override
  String get settingsPreviewLinesApplyButton => 'Toepassen';

  @override
  String get backupCancelButton => 'Annuleren';

  @override
  String get backupConnectButton => 'Verbinden';

  @override
  String get backupDisconnectButton => 'Verbinding verbreken';

  @override
  String get backupContinueButton => 'Doorgaan';

  @override
  String get backupCloseButton => 'Sluiten';

  @override
  String get backupShareButton => 'Delen';

  @override
  String get backupRestoreButton => 'Herstellen';

  @override
  String get backupConfigureButton => 'Configureren';

  @override
  String get backupUnknownDateLabel => 'Onbekend';

  @override
  String get backupProcessingDefaultLabel => 'Verwerken...';

  @override
  String get backupPermissionRequiredTitle => 'Opslagtoestemming vereist';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'Deze Android-versie vereist opslagtoestemming voor back-up/herstel. Omdat de toestemming permanent is geweigerd, schakelt u dit handmatig in via de app-instellingen.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'Deze Android-versie vereist opslagtoestemming voor back-up/herstel. Verleen toestemming om door te gaan.';

  @override
  String get backupGoToSettingsButton => 'Naar instellingen';

  @override
  String get backupRetryButton => 'Opnieuw proberen';

  @override
  String get backupDriveConnectingLabel => 'Verbinden met Google-account...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Verbonden met Google Drive-account: $email';
  }

  @override
  String get backupDriveConnectedMessage =>
      'Verbonden met Google Drive-account.';

  @override
  String get backupDriveConnectFailedMessage =>
      'Kon geen verbinding maken met het Google-account, of de bewerking is geannuleerd.';

  @override
  String get backupDriveDisconnectTitle => 'Google Drive loskoppelen';

  @override
  String get backupDriveDisconnectBody =>
      'Als u de verbinding verbreekt, zijn handmatige of automatische back-ups naar Drive niet meer mogelijk. Back-ups die al op Drive staan, worden niet verwijderd — alleen de toegang vanaf dit apparaat wordt verwijderd.';

  @override
  String get backupDriveDisconnectedMessage =>
      'Google Drive-verbinding verwijderd.';

  @override
  String get backupDriveRequiredTitle => 'Google-account vereist';

  @override
  String get backupDriveRequiredBody =>
      'Voor deze actie moet u uw Google-account koppelen. Wilt u nu verbinding maken?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: verbonden ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: verbonden';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: niet verbonden';

  @override
  String get backupDriveAuthenticatingLabel => 'Google-account verifiëren...';

  @override
  String get backupDriveNotSignedInMessage =>
      'U bent niet verbonden met Google Drive. Meld u eerst aan met uw Google-account.';

  @override
  String get backupDriveUploadingLabel =>
      'Back-up wordt geüpload naar Drive...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Uploaden naar Google Drive is niet binnen 120 seconden voltooid (geen reactie van de server). Controleer uw verbinding en probeer het opnieuw.';

  @override
  String get backupDriveOperationCompletedLabel => 'Voltooid';

  @override
  String get backupToDriveActionLabel => 'back-up naar Drive';

  @override
  String get backupToDeviceActionLabel => 'back-up';

  @override
  String get backupCreatingLabel => 'Back-up wordt gemaakt...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'Back-up kon niet worden gemaakt: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Uploaden naar Google Drive mislukt: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'Back-up succesvol geüpload naar Google Drive.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'Back-up gemaakt: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'Back-up klaar';

  @override
  String get backupOfferShareBody =>
      'Uw back-upbestand is opgeslagen op uw apparaat. Wilt u het nu delen (bijv. cloudopslag, e-mail, ander apparaat)?';

  @override
  String get backupShareFileText => 'layout back-upbestand';

  @override
  String backupShareFailedMessage(String error) {
    return 'Delen kon niet worden gestart: $error';
  }

  @override
  String get backupLargeOperationTitle => 'Grote back-up';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'De te verwerken gegevens zijn ongeveer $sizeText. Een $actionLabel van deze omvang kan afhankelijk van uw apparaat even duren. Verlaat de app niet zolang dit bezig is — wilt u doorgaan?';
  }

  @override
  String get backupRestoreActionLabel => 'herstellen';

  @override
  String get backupDriveListingLabel => 'Drive-back-ups worden weergegeven...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'Back-ups konden niet worden weergegeven: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'Er zijn nog geen back-ups op Google Drive.';

  @override
  String get backupDrivePickTitle => 'Kies een back-up van Drive';

  @override
  String get backupDriveDownloadingLabel =>
      'Back-up wordt gedownload van Drive...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Back-up wordt gedownload van Drive... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel =>
      'Bestand wordt opgeslagen op het apparaat...';

  @override
  String get backupDriveUnknownBackupFileName => 'onbekende_back-up.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Uw Google Drive-opslag is vol. Maak ruimte vrij op Drive en probeer het opnieuw.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'Er kon geen internetverbinding tot stand worden gebracht. Controleer uw verbinding en probeer het opnieuw.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'Het opgegeven back-upbestand is niet gevonden op Drive. Het is mogelijk verwijderd.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Er is een onverwachte fout opgetreden tijdens de Google Drive-bewerking: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'Downloaden mislukt: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'Bestand kon niet worden geselecteerd: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'Het geselecteerde bestand is niet toegankelijk.';

  @override
  String get backupCheckingLabel => 'Back-up wordt gecontroleerd...';

  @override
  String backupReadFailedMessage(String error) {
    return 'Back-upbestand kon niet worden gelezen: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'Back-up herstellen';

  @override
  String get backupPreviewContentsHeader =>
      'Inhoud van de geselecteerde back-up:';

  @override
  String get backupPreviewNoteCountLabel => 'Aantal notities';

  @override
  String get backupPreviewTrashCountLabel => 'Notities in prullenbak';

  @override
  String get backupPreviewCategoryCountLabel => 'Aantal categorieën';

  @override
  String get backupPreviewAttachmentLabel => 'Bijlagen';

  @override
  String get backupPreviewAttachmentNoneValue => 'Geen';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count bestanden ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'Aangemaakt op';

  @override
  String get backupEmptyPreviewTitle => 'Deze back-up lijkt leeg';

  @override
  String get backupEmptyPreviewBody =>
      'Er zijn geen notities, categorieën of bijlagen gevonden in het geselecteerde bestand. Als u doorgaat, worden uw huidige gegevens toch verwijderd en vervangen door deze lege back-up.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '$count bijlagen niet gevonden in de back-up';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'Notities met deze bestanden worden hersteld, maar zonder de bijlagen (ze ontbraken mogelijk of waren beschadigd op het moment van de back-up): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown en $remaining meer';
  }

  @override
  String get backupRestoreConfirmBody =>
      'Dit VERVANGT al uw huidige notities, prullenbak, categorieën, instellingen en bijlagen door de gegevens in de bovenstaande back-up. Uw huidige gegevens gaan permanent verloren en deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get backupRestoringLabel => 'Back-up wordt hersteld...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'Back-up hersteld. Echter, $count bijlagen zijn niet gevonden in de back-up en konden niet worden hersteld. Het wordt aanbevolen de app opnieuw te starten zodat de wijzigingen volledig worden toegepast.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'Back-up succesvol hersteld. Het wordt aanbevolen de app opnieuw te starten zodat de wijzigingen volledig worden toegepast.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'Er is een fout opgetreden tijdens het herstellen: $error';
  }

  @override
  String get backupScreenTitle => 'Back-up & Herstel';

  @override
  String get backupBlockedExitWarningMessage =>
      'Er is een bewerking bezig, wacht tot deze is voltooid.';

  @override
  String get backupBusyBackTooltip => 'Bewerking bezig';

  @override
  String get backupIntroText =>
      'U kunt uw notities, categorieën, instellingen en bijlagen back-uppen als één .zip-bestand, of een eerder gemaakte back-up herstellen.';

  @override
  String get backupDriveCardTitle => 'Back-uppen naar Google Drive';

  @override
  String get backupDriveCardSubtitle =>
      'Maak een nieuwe back-up en upload deze rechtstreeks naar het privégedeelte van uw Google Drive.';

  @override
  String get backupDriveCardButtonLabel => 'Back-uppen naar Drive';

  @override
  String get backupDeviceCardTitle => 'Back-uppen naar apparaat';

  @override
  String get backupDeviceCardSubtitle =>
      'Sla al uw gegevens op als één .zip-bestand op uw apparaat en deel het als u wilt.';

  @override
  String get backupDeviceCardButtonLabel => 'Back-uppen naar apparaat';

  @override
  String get backupHistoryCardTitle => 'Back-upgeschiedenis';

  @override
  String get backupHistoryCardSubtitle =>
      'Bekijk alle back-ups die op uw apparaat zijn opgeslagen met hun datum en grootte; u kunt ze hier direct delen, herstellen of verwijderen.';

  @override
  String get backupHistoryTabDevice => 'Apparaat';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'Back-up verwijderen';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'Weet u zeker dat u het back-upbestand \"$fileName\" permanent wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'Back-up verwijderd.';

  @override
  String get backupHistoryDriveDeleteDialogTitle => 'Drive-back-up verwijderen';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'Weet u zeker dat u de back-up \"$fileName\" permanent wilt verwijderen van Google Drive? Deze actie kan niet ongedaan worden gemaakt en het bestand wordt niet naar de prullenbak verplaatst.';
  }

  @override
  String get backupHistoryDriveDeletedMessage => 'Drive-back-up verwijderd.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'Kon niet worden verwijderd: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'Nog geen back-ups opgeslagen op dit apparaat.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'Gebruik \"Back-uppen naar apparaat\" om uw eerste back-up te maken.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'Gebruik \"Back-uppen naar Google Drive\" om uw eerste cloudback-up te maken.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Koppel uw Google-account om uw Drive-back-ups te zien.';

  @override
  String get backupHistoryConnectGoogleButton => 'Verbinden met Google';

  @override
  String get backupHistoryDriveConnectedFallback => 'Verbonden';

  @override
  String get backupHistoryUnknownErrorFallback =>
      'Er is een onbekende fout opgetreden.';

  @override
  String get backupHistoryDownloadStartingLabel => 'Starten...';

  @override
  String get backupAutoBackupEnabledLabel => 'Automatische back-up: aan';

  @override
  String get backupAutoBackupDisabledLabel => 'Automatische back-up: uit';

  @override
  String get backupOverlayWarningMessage =>
      'Even geduld, verlaat de app niet totdat de bewerking is voltooid.';

  @override
  String get pdfExportUntitledNoteLabel => 'Naamloze notitie';

  @override
  String get pdfExportDefaultAttachmentName => 'Bijlage';

  @override
  String get pdfExportDefaultFileName => 'notitie';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'Screenshot kon niet worden gemaakt (grens niet gevonden)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'Screenshotgegevens konden niet worden gegenereerd';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'Afbeelding kon niet worden verwerkt (PNG-decodering mislukt)';

  @override
  String get screenshotCalcTableTotalLabel => 'Totaal';

  @override
  String get gundemMenuRemoveFromAgenda => 'Verwijderen uit agenda';

  @override
  String get gundemMenuDeleteNote => 'Notitie verwijderen';

  @override
  String get gundemSectionOverdue => 'Te laat';

  @override
  String get gundemSectionToday => 'Vandaag';

  @override
  String get gundemSectionTomorrow => 'Morgen';

  @override
  String get gundemSectionNextWeek => 'Volgende week';

  @override
  String get gundemSectionFurther => 'Verder vooruit';

  @override
  String get gundemWeekdayMonday => 'Maandag';

  @override
  String get gundemWeekdayTuesday => 'Dinsdag';

  @override
  String get gundemWeekdayWednesday => 'Woensdag';

  @override
  String get gundemWeekdayThursday => 'Donderdag';

  @override
  String get gundemWeekdayFriday => 'Vrijdag';

  @override
  String get gundemWeekdaySaturday => 'Zaterdag';

  @override
  String get gundemWeekdaySunday => 'Zondag';

  @override
  String get gundemAppBarTitle => 'Agenda';

  @override
  String get gundemCalendarTooltip => 'Kalender';

  @override
  String get gundemEmptyTitle => 'Niets op uw agenda';

  @override
  String get gundemEmptySubtitle =>
      'Notities met een herinnering of toegewezen datum verschijnen hier.';

  @override
  String get gundemUntitledNote => 'Naamloze notitie';

  @override
  String get gundemRepeatHourly => 'Elk uur';

  @override
  String get gundemRepeatDaily => 'Dagelijks';

  @override
  String get gundemRepeatWeekly => 'Wekelijks';

  @override
  String get gundemRepeatMonthly => 'Maandelijks';

  @override
  String get gundemRepeatYearly => 'Jaarlijks';

  @override
  String get gundemPreviewCalcTableLabel => '[Rekenlijst]';

  @override
  String get gundemPreviewDrawingLabel => '[Tekening]';

  @override
  String get gundemPreviewImageLabel => '[Afbeelding]';

  @override
  String get gundemMonthShortJan => 'jan';

  @override
  String get gundemMonthShortFeb => 'feb';

  @override
  String get gundemMonthShortMar => 'mrt';

  @override
  String get gundemMonthShortApr => 'apr';

  @override
  String get gundemMonthShortMay => 'mei';

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
  String get calendarTodayButton => 'Vandaag';

  @override
  String get calendarLegendNoteLabel => 'Notitie';

  @override
  String get calendarLegendReminderLabel => 'Herinnering';

  @override
  String get calendarTodayBadge => 'Vandaag';

  @override
  String get calendarEmptyDayMessage =>
      'Geen notities of herinneringen voor deze dag.';

  @override
  String get calendarReminderHourlyLabel => 'Elk uur';

  @override
  String get calendarMonthJan => 'januari';

  @override
  String get calendarMonthFeb => 'februari';

  @override
  String get calendarMonthMar => 'maart';

  @override
  String get calendarMonthApr => 'april';

  @override
  String get calendarMonthMay => 'mei';

  @override
  String get calendarMonthJun => 'juni';

  @override
  String get calendarMonthJul => 'juli';

  @override
  String get calendarMonthAug => 'augustus';

  @override
  String get calendarMonthSep => 'september';

  @override
  String get calendarMonthOct => 'oktober';

  @override
  String get calendarMonthNov => 'november';

  @override
  String get calendarMonthDec => 'december';

  @override
  String get calendarWeekdayShortMon => 'ma';

  @override
  String get calendarWeekdayShortTue => 'di';

  @override
  String get calendarWeekdayShortWed => 'wo';

  @override
  String get calendarWeekdayShortThu => 'do';

  @override
  String get calendarWeekdayShortFri => 'vr';

  @override
  String get calendarWeekdayShortSat => 'za';

  @override
  String get calendarWeekdayShortSun => 'zo';

  @override
  String get calendarWeekdayFullMonday => 'Maandag';

  @override
  String get calendarWeekdayFullTuesday => 'Dinsdag';

  @override
  String get calendarWeekdayFullWednesday => 'Woensdag';

  @override
  String get calendarWeekdayFullThursday => 'Donderdag';

  @override
  String get calendarWeekdayFullFriday => 'Vrijdag';

  @override
  String get calendarWeekdayFullSaturday => 'Zaterdag';

  @override
  String get calendarWeekdayFullSunday => 'Zondag';

  @override
  String get wrongPasswordDialogTitle => 'Onjuist wachtwoord';

  @override
  String get wrongPasswordDialogMessage =>
      'Het ingevoerde wachtwoord is onjuist.';

  @override
  String get commonOkButton => 'OK';

  @override
  String get unlockCategoryAction => 'Ontgrendelen';

  @override
  String get lockCategoryAction => 'Vergrendelen';

  @override
  String get categoryUnlockedMessage => 'Ontgrendeld';

  @override
  String get categoryLockedMessage => 'Map vergrendeld';

  @override
  String get deleteFolderMenuItemLabel => 'Map verwijderen';

  @override
  String get deleteFolderDialogTitle => 'Map verwijderen';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'Weet u zeker dat u de map \"$category\" en alle submappen wilt verwijderen? Notities in deze mappen worden ongecategoriseerd.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'Weet u zeker dat u de map \"$category\" wilt verwijderen? Notities in deze map worden ongecategoriseerd.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'Annuleren';

  @override
  String get deleteFolderDialogConfirmButton => 'Verwijderen';

  @override
  String get editCategoryNameColorMenuItemLabel => 'Naam/kleur bewerken';

  @override
  String get addSubfolderMenuItemLabel => 'Submap maken';

  @override
  String get expandSubfoldersMenuItemLabel => 'Submappen uitvouwen';

  @override
  String get collapseSubfoldersMenuItemLabel => 'Submappen samenvouwen';

  @override
  String saveErrorInfoMessage(String error) {
    return 'Opslagfout: $error';
  }

  @override
  String get welcomeNoteTitle => 'Welkom bij Layout! 🚀';

  @override
  String get welcomeNoteContent => 'Nieuwe functies toegevoegd!';

  @override
  String get noteListDateGroupToday => 'Vandaag';

  @override
  String get noteListDateGroupYesterday => 'Gisteren';

  @override
  String get noteListDateGroupLast7Days => 'Laatste 7 dagen';

  @override
  String get noteListDateGroupLast30Days => 'Laatste 30 dagen';

  @override
  String get reminderRepeatNoneLabel => 'Geen herhaling';

  @override
  String get voiceRecorderPreparingLabel => 'Voorbereiden…';

  @override
  String get voiceRecorderCancelButton => 'Annuleren';

  @override
  String get voiceRecorderStopAddButton => 'Stoppen en toevoegen';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'Microfoontoestemming is niet verleend.';

  @override
  String get speechToTextUnavailableMessage =>
      'Spraakherkenning is niet beschikbaar op dit apparaat.';

  @override
  String get speechToTextPreparingLabel => 'Voorbereiden…';

  @override
  String get speechToTextListeningLabel => 'Luisteren…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'Begin met spreken…';

  @override
  String get speechToTextCancelButton => 'Annuleren';

  @override
  String get speechToTextStopAddButton => 'Stoppen en toevoegen';

  @override
  String get textToSpeechNoContentMessage =>
      'Er is geen inhoud om voor te lezen.';

  @override
  String get textToSpeechReadErrorMessage =>
      'Er is een fout opgetreden tijdens het voorlezen.';

  @override
  String get textToSpeechUnavailableMessage =>
      'Tekst-naar-spraak is niet beschikbaar op dit apparaat.';

  @override
  String get textToSpeechPreparingLabel => 'Voorbereiden…';

  @override
  String get textToSpeechPausedLabel => 'Gepauzeerd';

  @override
  String get textToSpeechFinishedLabel => 'Voorlezen voltooid';

  @override
  String get textToSpeechReadingLabel => 'Voorlezen…';

  @override
  String get textToSpeechCloseErrorButton => 'Sluiten';

  @override
  String get textToSpeechReplayButton => 'Opnieuw voorlezen';

  @override
  String get textToSpeechCloseFinishedButton => 'Sluiten';

  @override
  String get textToSpeechPauseButton => 'Pauzeren';

  @override
  String get textToSpeechResumeButton => 'Hervatten';

  @override
  String get textToSpeechStopButton => 'Stoppen';

  @override
  String get textToSpeechSpeedSlow => 'Langzaam';

  @override
  String get textToSpeechSpeedNormal => 'Normaal';

  @override
  String get textToSpeechSpeedFast => 'Snel';

  @override
  String get calendarPickerCancelButton => 'Annuleren';

  @override
  String get calendarPickerConfirmButton => 'Selecteren';

  @override
  String get calendarPickerClearButton => 'Wissen';

  @override
  String get reminderPickerDialogTitle => 'Herinnering toevoegen';

  @override
  String get reminderPickerDateTodayOption => 'Vandaag';

  @override
  String get reminderPickerDateTomorrowOption => 'Morgen';

  @override
  String get reminderPickerDatePickOption => 'Datum kiezen';

  @override
  String get reminderRepeatHourlyLabel => 'Elk uur';

  @override
  String get reminderRepeatDailyLabel => 'Elke dag';

  @override
  String get reminderRepeatWeeklyLabel => 'Elke week';

  @override
  String get reminderRepeatMonthlyLabel => 'Elke maand';

  @override
  String get reminderRepeatYearlyLabel => 'Elk jaar';

  @override
  String get reminderPickerCalendarHelpText => 'Selecteer herinneringsdatum';

  @override
  String get reminderPickerCancelButton => 'ANNULEREN';

  @override
  String get reminderPickerSaveButton => 'OPSLAAN';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'Er kan geen tijdstip in het verleden worden geselecteerd';

  @override
  String calcTableTotalLabel(String amount) {
    return 'Totaal: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'Gegevens worden voorbereid...';

  @override
  String get backupCreatePackagingNotesLabel =>
      'Notities en categorieën worden verpakt...';

  @override
  String get backupCreateReadingAttachmentsLabel =>
      'Bijlagen worden gelezen...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'Bijlagen worden gelezen... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel =>
      'Zip-bestand wordt gecomprimeerd...';

  @override
  String get backupCreateSavingFileLabel => 'Bestand wordt opgeslagen...';

  @override
  String get backupRestoreValidatingLabel => 'Back-up wordt gevalideerd...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'Back-up gevalideerd, gegevens worden voorbereid...';

  @override
  String get backupRestoreWritingNotesLabel => 'Notities worden geschreven...';

  @override
  String get backupRestoreWritingTrashLabel => 'Prullenbak wordt geschreven...';

  @override
  String get backupRestoreTrashWrittenLabel => 'Prullenbak geschreven';

  @override
  String get backupRestoreWritingCategoriesLabel =>
      'Categorieën worden geschreven...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'Categorieën geschreven';

  @override
  String get backupRestoreWritingSettingsLabel =>
      'Instellingen worden geschreven...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'Instellingen geschreven';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'Oude bijlagen worden opgeruimd...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'Geen bijlagen gevonden, afronden...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'Bijlagen worden hersteld... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'Voltooid';

  @override
  String get backupValidationCorruptedFileMessage =>
      'Het bestand is beschadigd of geen geldig back-upbestand.';

  @override
  String get backupValidationMissingDataMessage =>
      'Geen gegevens gevonden in het back-upbestand (backup_data.json ontbreekt).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'Back-upgegevens konden niet worden gelezen (beschadigde JSON).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'Dit bestand is geen back-up van de layout-app.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'De versie-informatie van het back-upbestand kon niet worden gelezen.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'Deze back-up heeft een nieuwer formaat dat de huidige app-versie niet ondersteunt. Werk de app bij.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'De versie-informatie van het back-upbestand is ongeldig.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'Back-upgegevens hebben niet het verwachte formaat (notes-veld ontbreekt).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'Back-upgegevens hebben niet het verwachte formaat (trash-veld ontbreekt).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'Back-upgegevens hebben niet het verwachte formaat (categorielijst is ongeldig).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'Back-upgegevens hebben niet het verwachte formaat (instellingenveld is ongeldig).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'Back-upgegevens hebben niet het verwachte formaat (een notitierecord is ongeldig).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'Back-upgegevens hebben niet het verwachte formaat (er is een notitierecord zonder ID gevonden).';

  @override
  String get backupValidationFileNotFoundMessage =>
      'Back-upbestand niet gevonden.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'Onvoldoende vrije opslagruimte op het apparaat. Maak ruimte vrij en probeer het opnieuw.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'Bestandstoegang werd geweigerd. Controleer de app-machtigingen en probeer het opnieuw.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'Er is een fout opgetreden tijdens de bestandsbewerking: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'Er is een onverwachte fout opgetreden: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'Kon het zip-archief niet maken (ZipEncoder gaf null terug).';

  @override
  String get calcTableMenuItemLabel => 'Rekenlijst';

  @override
  String get tableBlockMenuItemLabel => 'Tabel';

  @override
  String get tableSizePickerTitle => 'Tabelgrootte selecteren';

  @override
  String get tableSizePickerCancel => 'Annuleren';

  @override
  String get tableSizePickerDeleteTooltip => 'Tabel verwijderen';

  @override
  String get tagsMenuItemLabel => 'Labels';

  @override
  String get linkDialogUrlHint => 'https://voorbeeld.com';

  @override
  String get checklistItemHint => 'Item toevoegen...';

  @override
  String get toolbarHighlightTooltip => 'Markeren';

  @override
  String get toolbarListTooltip => 'Lijst';

  @override
  String get toolbarHideKeyboardTooltip => 'Toetsenbord verbergen';

  @override
  String get autoBackupLocalSuccessMessage => 'Lokale back-up geslaagd.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'Lokale back-up mislukt: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Drive-back-up overgeslagen: Google-account is niet gekoppeld of de sessie is verlopen. Open de app en maak opnieuw verbinding.';

  @override
  String get autoBackupDriveSuccessMessage => 'Drive-back-up geslaagd.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Drive-back-up mislukt: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'Nog geen notities';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'Totaal: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ Tekening';

  @override
  String get autoBackupSettingsAppBarTitle =>
      'Instellingen automatische back-up';

  @override
  String get autoBackupSettingsMainSwitchTitle =>
      'Automatische back-up inschakelen';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'Uw notities worden periodiek veilig op de achtergrond geback-upt.';

  @override
  String get autoBackupSettingsTargetTitle => 'Back-updoel';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'Kies waar back-ups worden opgeslagen.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'Lokaal';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'Beide';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Koppel eerst uw account om Google Drive-opties te gebruiken.';

  @override
  String get autoBackupSettingsConnectButton => 'Verbinden';

  @override
  String get autoBackupSettingsFrequencyTitle => 'Back-upfrequentie';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'Er wordt elke $hours uur een back-up gemaakt.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 uur';

  @override
  String get autoBackupSettingsFrequency12h => '12 uur';

  @override
  String get autoBackupSettingsFrequency24h => '24 uur (dagelijks)';

  @override
  String get autoBackupSettingsFrequency48h => '48 uur (2 dagen)';

  @override
  String get autoBackupSettingsFrequency168h => '168 uur (wekelijks)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Alleen wifi gebruiken';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'Uploaden naar de cloud gebeurt alleen via wifi om uw mobiele data te sparen.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'Systeemstatus';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'Automatische back-up is nog niet uitgevoerd.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'Laatste uitvoering: $date $time ($status)\nBericht: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'Geslaagd';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'Mislukt';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Kon geen verbinding maken met het Google-account.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'Instellingen voor automatische back-up bijgewerkt.';

  @override
  String selectionModeDeletedMessage(int count) {
    return '$count notities verwijderd';
  }

  @override
  String get selectionModeArchivedMessage => 'Gearchiveerd';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'Kies categorie voor $count notities';
  }

  @override
  String get selectionModeAddCategoryOption => 'Categorie toevoegen';

  @override
  String get selectionModeRemoveCategoryOption => 'Categorie verwijderen';

  @override
  String get calcTableItemHint => 'Item...';

  @override
  String get calcTableTotalRowLabel => 'Totaal';

  @override
  String get textSelectionMenuShareButton => 'Delen';

  @override
  String get textSelectionMenuTranslateButton => 'Vertalen';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'Delen kon niet worden gestart.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'Vertaling kon niet worden geopend.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'Vandaag $time';
  }

  @override
  String lastBackupInfoDateFormat(
    String day,
    String month,
    int year,
    String time,
  ) {
    return '$day-$month-$year $time';
  }

  @override
  String lastBackupInfoLabel(String date) {
    return 'Laatste back-up: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage => 'Er is nog geen back-up gemaakt.';

  @override
  String get backupFileNameLabel => 'Back-up';
}
