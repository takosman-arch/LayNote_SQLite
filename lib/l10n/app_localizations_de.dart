// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'Fett';

  @override
  String get toolbarItalicTooltip => 'Kursiv';

  @override
  String get toolbarUnderlineTooltip => 'Unterstrichen';

  @override
  String get toolbarStrikethroughTooltip => 'Durchgestrichen';

  @override
  String get toolbarFontSizeTooltip => 'Schriftgröße';

  @override
  String get toolbarColorTooltip => 'Textfarbe';

  @override
  String get toolbarBulletTooltip => 'Aufzählungsliste';

  @override
  String get toolbarNumberTooltip => 'Nummerierte Liste';

  @override
  String get toolbarIndentTooltip => 'Absatzeinzug';

  @override
  String get toolbarLinkTooltip => 'Link hinzufügen / bearbeiten / entfernen';

  @override
  String get toolbarDividerTooltip => 'Trennlinie einfügen';

  @override
  String get toolbarChecklistTooltip => 'Checkliste hinzufügen';

  @override
  String get linkSelectTextSnackbar =>
      'Wähle zuerst den Text aus, den du verlinken möchtest';

  @override
  String get linkDialogEditTitle => 'Link bearbeiten';

  @override
  String get linkDialogAddTitle => 'Link hinzufügen';

  @override
  String get linkDialogRemoveButton => 'Link entfernen';

  @override
  String get linkDialogCancelButton => 'Abbrechen';

  @override
  String get linkDialogConfirmButton => 'Hinzufügen';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Kamerazugriff verweigert. Du musst ihn in den Einstellungen erlauben, um ein Video aufzunehmen.';

  @override
  String get cameraPermissionRequiredMessage =>
      'Kamerazugriff ist erforderlich, um ein Video aufzunehmen.';

  @override
  String get openSettingsButtonLabel => 'Einstellungen';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'Scan konnte nicht gestartet werden: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'Texterkennung fehlgeschlagen: $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'Im Dokument wurde kein lesbarer Text gefunden';

  @override
  String get scanResultSheetTitle =>
      'Wie soll das gescannte Dokument hinzugefügt werden?';

  @override
  String get scanResultTextOnlyOption => 'Nur als Text hinzufügen';

  @override
  String get scanResultTextAndImageOption =>
      'Text + gescanntes Bild hinzufügen';

  @override
  String get scanResultCancelOption => 'Abbrechen';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'Mikrofonzugriff verweigert. Du musst ihn in den Einstellungen erlauben, um Audio aufzunehmen.';

  @override
  String get audioPermissionRequiredMessage =>
      'Mikrofonzugriff ist erforderlich, um Audio aufzunehmen.';

  @override
  String get voiceRecordingDefaultLabel => 'Sprachaufnahme';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'Berechnungsliste ($count Zeilen)';
  }

  @override
  String blockPreviewTableLabel(int count) {
    return 'Tabelle ($count Zeilen)';
  }

  @override
  String get blockPreviewDrawingLabel => 'Zeichnung';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count Anhänge (Foto/Dokument)';
  }

  @override
  String get blockPreviewDividerLabel => 'Trennlinie';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'Checkliste ($count Einträge)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(leerer Text)';

  @override
  String get reorderBlocksSheetTitle => 'Blöcke neu anordnen';

  @override
  String get reorderBlocksMoveUpTooltip => 'Nach oben verschieben';

  @override
  String get reorderBlocksMoveDownTooltip => 'Nach unten verschieben';

  @override
  String get reorderBlocksCloseTooltip => 'Schließen';

  @override
  String get reorderBlocksDescription =>
      'Tippe auf einen Block, um ihn auszuwählen, und verwende dann die Pfeile nach oben/unten, um ihn zu verschieben.';

  @override
  String get reorderBlocksMenuItemLabel => 'Neu anordnen';

  @override
  String get txtImportPickerDialogTitle =>
      'Wähle die zu importierende TXT-Datei';

  @override
  String get txtImportReadFailedMessage =>
      'Die TXT-Datei konnte nicht gelesen werden';

  @override
  String get txtImportEmptyFileMessage => 'Die TXT-Datei ist leer';

  @override
  String get txtImportSuccessMessage => 'TXT importiert';

  @override
  String get txtImportMenuItemLabel => 'Importieren (txt)';

  @override
  String get exportMenuItemLabel => 'Exportieren';

  @override
  String get editorUndoTooltip => 'Rückgängig';

  @override
  String get editorRedoTooltip => 'Wiederholen';

  @override
  String get noteSavedMessage => 'Notiz gespeichert';

  @override
  String get dateAssignPickerHelpText => 'Notiz einem Tag zuweisen';

  @override
  String get dateAssignChangeOption => 'Datum ändern';

  @override
  String get dateAssignRemoveOption => 'Zuweisung entfernen';

  @override
  String get editorSubToolbarCloseTooltip => 'Schließen';

  @override
  String get titleFieldHint => 'Titel';

  @override
  String get textBlockHint => 'Schreibe hier deine Notiz...';

  @override
  String get drawingBoardMenuItemLabel => 'Zeichenbrett';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'Sprache-zu-Text ist nur für Textnotizen verfügbar';

  @override
  String get selectionModeCancelTooltip => 'Auswahl abbrechen';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return '$count ausgewählt';
  }

  @override
  String get selectionModeDeleteTooltip => 'Löschen';

  @override
  String get selectionModeArchiveTooltip => 'Archivieren';

  @override
  String get selectionModeFolderTooltip => 'Ordner';

  @override
  String get searchFieldHint => 'Notizen durchsuchen...';

  @override
  String get emptyTrashDialogTitle => 'Papierkorb leeren';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'Alle gelöschten Notizen werden dauerhaft entfernt. Bist du sicher?';

  @override
  String get emptyTrashDialogCancelButton => 'Abbrechen';

  @override
  String get restoreAllMenuItemLabel => 'Alle wiederherstellen';

  @override
  String get sortMenuTooltip => 'Notizen sortieren';

  @override
  String get sortMenuAscendingLabel => 'Reihenfolge: Aufsteigend (A-Z)';

  @override
  String get sortMenuDescendingLabel => 'Reihenfolge: Absteigend (Z-A)';

  @override
  String get sortMenuByTitleLabel => 'Sortieren nach: Titel';

  @override
  String get sortMenuByModifiedDateLabel => 'Sortieren nach: Zuletzt geändert';

  @override
  String get sortMenuByCreatedDateLabel => 'Sortieren nach: Erstellungsdatum';

  @override
  String get sortMenuByFolderLabel => 'Sortieren nach: Ordner';

  @override
  String get viewToggleGridTooltip => 'Rasteransicht';

  @override
  String get viewToggleListTooltip => 'Listenansicht';

  @override
  String get drawerHeaderSubtitle => 'Dein persönliches Notizbuch';

  @override
  String get drawerNotesSectionHeader => 'NOTIZEN';

  @override
  String get drawerAllNotesLabel => 'Notizen';

  @override
  String get drawerFavoritesLabel => 'Favorit';

  @override
  String get drawerAgendaLabel => 'Agenda';

  @override
  String get drawerRemindersLabel => 'Erinnerung';

  @override
  String get drawerLockedLabel => 'Gesperrt';

  @override
  String get drawerTrashLabel => 'Papierkorb';

  @override
  String get drawerFoldersSectionHeader => 'ORDNER';

  @override
  String get drawerExpandLabel => 'Erweitern';

  @override
  String get drawerCollapseLabel => 'Einklappen';

  @override
  String get drawerAddFolderLabel => 'Ordner hinzufügen';

  @override
  String get drawerAppSectionHeader => 'APP';

  @override
  String get drawerCalendarLabel => 'Kalender';

  @override
  String get drawerSettingsLabel => 'Einstellungen';

  @override
  String get drawerBackupRestoreLabel => 'Sichern & Wiederherstellen';

  @override
  String get drawerUpgradeToProLabel => 'Auf Pro upgraden';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'Entwicklung unterstützen';

  @override
  String get drawerFeedbackLabel => 'Feedback';

  @override
  String get drawerRateAppLabel => 'App bewerten';

  @override
  String get drawerAboutLabel => 'Über';

  @override
  String get noNotesFoundMessage => 'Keine Notizen gefunden.';

  @override
  String get trashRestoreButtonLabel => 'Wiederherstellen';

  @override
  String get trashPermanentDeleteButtonLabel => 'Endgültig löschen';

  @override
  String get tagRenamedInfoMessage => 'Tag umbenannt';

  @override
  String get tagDeletedInfoMessage => 'Tag gelöscht';

  @override
  String get tagOptionsRenameLabel => 'Umbenennen';

  @override
  String get tagOptionsDeleteLabel => 'Löschen';

  @override
  String get renameTagDialogTitle => 'Tag umbenennen';

  @override
  String get renameTagDialogHint => 'Neuer Tag-Name';

  @override
  String get renameTagDialogCancelButton => 'Abbrechen';

  @override
  String get renameTagDialogSaveButton => 'Speichern';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '\"$tag\" wird von $affectedCount Notizen entfernt. Fortfahren?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'Tag \"$tag\" löschen?';
  }

  @override
  String get deleteTagDialogTitle => 'Tag löschen';

  @override
  String get deleteTagDialogCancelButton => 'Abbrechen';

  @override
  String get deleteTagDialogConfirmButton => 'Löschen';

  @override
  String get tagsSheetTitle => 'Tags';

  @override
  String get tagsSheetEmptyMessage => 'Diese Notiz hat noch keine Tags.';

  @override
  String get tagsSheetInputHint => 'Neuen Tag eingeben...';

  @override
  String get tagsSheetSuggestionsLabel => 'Vorhandene Tags';

  @override
  String get noteDeletedInfoMessage => 'Notiz gelöscht';

  @override
  String get noteDeletedUndoActionLabel => 'Rückgängig';

  @override
  String get reminderSetInfoMessage => 'Erinnerung gesetzt';

  @override
  String get reminderRemovedInfoMessage => 'Erinnerung entfernt';

  @override
  String get noteDuplicatedInfoMessage => 'Kopie erstellt';

  @override
  String get speechTextAppendedInfoMessage => 'Text zur Notiz hinzugefügt';

  @override
  String get pdfPreparingInfoMessage => 'PDF wird vorbereitet…';

  @override
  String get pdfSavedInfoMessage => 'PDF gespeichert';

  @override
  String get pdfPreviewSaveActionLabel => 'Speichern';

  @override
  String get jpgPreparingInfoMessage => 'JPG wird vorbereitet…';

  @override
  String get jpgSavedInfoMessage => 'JPG gespeichert';

  @override
  String get jpgFailedInfoMessage => 'JPG konnte nicht erstellt werden';

  @override
  String get txtPreparingInfoMessage => 'TXT wird vorbereitet…';

  @override
  String get txtSavedInfoMessage => 'TXT gespeichert';

  @override
  String get txtFailedInfoMessage => 'TXT konnte nicht erstellt werden';

  @override
  String get exportOpenActionLabel => 'Öffnen';

  @override
  String get wrongPasswordInfoMessage => 'Falsches Passwort.';

  @override
  String get noteArchivedInfoMessage => 'Notiz archiviert';

  @override
  String get noteUnarchivedInfoMessage => 'Aus dem Archiv entfernt';

  @override
  String get noteUnlockedInfoMessage => 'Entsperrt';

  @override
  String get noteLockedInfoMessage => 'Notiz gesperrt';

  @override
  String get notificationUnpinnedInfoMessage => 'Nicht mehr angeheftet';

  @override
  String get emptyNotePinBlockedInfoMessage =>
      'Eine leere Notiz kann nicht angeheftet werden.';

  @override
  String get notificationPinnedInfoMessage =>
      'An Benachrichtigungsleiste angeheftet';

  @override
  String get noContentToReadInfoMessage => 'Es gibt keinen Inhalt zum Vorlesen';

  @override
  String get backPressExitInfoMessage => 'Erneut zurück drücken, um zu beenden';

  @override
  String get reminderChannelName => 'Notiz-Erinnerungen';

  @override
  String get reminderChannelDescription =>
      'Notiz-Erinnerungen in der Layout-App';

  @override
  String get pinnedChannelName => 'Angeheftete Notizen';

  @override
  String get pinnedChannelDescription =>
      'Layout-Notizen, die an der Benachrichtigungsleiste angeheftet sind';

  @override
  String get notificationUnpinActionLabel => 'Entfernen';

  @override
  String get reminderDefaultTitle => 'Erinnerung';

  @override
  String get reminderChecklistBodyFallback =>
      'Vergiss nicht, deine Checkliste zu überprüfen';

  @override
  String get reminderTextBodyFallback =>
      'Vergiss nicht, deine Notiz zu überprüfen';

  @override
  String get pdfSaveDialogTitle => 'Als PDF speichern';

  @override
  String get jpgSaveDialogTitle => 'Als JPG speichern';

  @override
  String get txtSaveDialogTitle => 'Als TXT speichern';

  @override
  String get textSizeSheetTitle => 'Textgröße';

  @override
  String get textSizeSamplePreview => 'Beispieltext';

  @override
  String get textSizeCancelButton => 'Abbrechen';

  @override
  String get textSizeApplyButton => 'Anwenden';

  @override
  String get createPasswordDialogTitle => 'Passwort erstellen';

  @override
  String get createPasswordNewPasswordHint => 'Neues Passwort';

  @override
  String get createPasswordConfirmHint => 'Passwort erneut eingeben';

  @override
  String get createPasswordHintQuestionDescription =>
      'Lege eine Sicherheitsfrage fest, falls du dein Passwort vergisst (optional).';

  @override
  String get createPasswordHintQuestionHint => 'Wähle eine Sicherheitsfrage';

  @override
  String get createPasswordHintAnswerHint => 'Deine Antwort';

  @override
  String get createPasswordCancelButton => 'Abbrechen';

  @override
  String get createPasswordSaveButton => 'Speichern';

  @override
  String get passwordMismatchMessage => 'Passwörter stimmen nicht überein!';

  @override
  String get passwordRequiredDialogTitle => 'Passwort erforderlich';

  @override
  String get passwordRequiredHint => 'Passwort eingeben';

  @override
  String get forgotPasswordButtonLabel => 'Passwort vergessen';

  @override
  String get passwordRequiredCancelButton => 'Abbrechen';

  @override
  String get passwordRequiredConfirmButton => 'Bestätigen';

  @override
  String get securityQuestionDialogTitle => 'Sicherheitsfrage';

  @override
  String get securityQuestionAnswerHint => 'Deine Antwort';

  @override
  String get securityQuestionCancelButton => 'Abbrechen';

  @override
  String get securityQuestionConfirmButton => 'Bestätigen';

  @override
  String get securityQuestionWrongAnswerMessage =>
      'Falsche Antwort. Versuche es erneut.';

  @override
  String get revealedPasswordDialogTitle => 'Dein Passwort';

  @override
  String get revealedPasswordLabel => 'Dein Notizpasswort:';

  @override
  String get revealedPasswordOkButton => 'OK';

  @override
  String get securityQuestionPetName => 'Wie hieß dein erstes Haustier?';

  @override
  String get securityQuestionFavoriteTeacher =>
      'Wie heißt dein Lieblingslehrer?';

  @override
  String get securityQuestionBirthCity => 'In welcher Stadt bist du geboren?';

  @override
  String get securityQuestionFavoriteFood => 'Was ist dein Lieblingsessen?';

  @override
  String get securityQuestionMotherMaidenName =>
      'Wie lautet der Mädchenname deiner Mutter?';

  @override
  String get securityQuestionFirstSchool =>
      'Wie hieß die erste Schule, die du besucht hast?';

  @override
  String get securityQuestionFavoriteColor => 'Was ist deine Lieblingsfarbe?';

  @override
  String get editFolderDialogTitle => 'Ordner bearbeiten';

  @override
  String get newSubfolderDialogTitle => 'Neuer Unterordner';

  @override
  String get addFolderDialogTitle => 'Ordner hinzufügen';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'Wird innerhalb von \"$parentCategory\" erstellt';
  }

  @override
  String get subfolderNameFieldLabel => 'Unterordnername';

  @override
  String get folderNameFieldLabel => 'Ordnername';

  @override
  String get folderColorLabel => 'Farbe';

  @override
  String get folderDialogCancelButton => 'Abbrechen';

  @override
  String get folderDialogSaveButton => 'Speichern';

  @override
  String get folderDialogAddButton => 'Hinzufügen';

  @override
  String get selectFolderSheetTitle => 'Ordner auswählen';

  @override
  String get selectFolderAddOptionLabel => 'Ordner hinzufügen';

  @override
  String get removeCurrentFolderLabel => 'Aktuellen Ordner entfernen';

  @override
  String get noteDetailsDialogTitle => 'Details';

  @override
  String get noteDetailsCreatedLabel => 'Erstellt';

  @override
  String get noteDetailsModifiedLabel => 'Zuletzt geändert';

  @override
  String get noteDetailsCharCountLabel => 'Zeichenanzahl';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count Zeichen';
  }

  @override
  String get noteDetailsWordCountLabel => 'Wortanzahl';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count Wörter';
  }

  @override
  String get noteDetailsOkButton => 'OK';

  @override
  String get noteDetailsUnknownDateLabel => 'Unbekannt';

  @override
  String get addAttachmentSheetTitle => 'Hinzufügen';

  @override
  String get addAttachmentImageOption => 'Bild hinzufügen';

  @override
  String get addAttachmentCameraOption => 'Kamera';

  @override
  String get addAttachmentFileOption => 'Datei hinzufügen';

  @override
  String get addAttachmentVoiceOption => 'Sprachaufnahme';

  @override
  String get addAttachmentVideoOption => 'Video aufnehmen';

  @override
  String get addAttachmentScanOption => 'Dokument scannen';

  @override
  String get noteActionsSheetTitle => 'Aktion wählen';

  @override
  String get noteActionReminderLabel => 'Erinnerung';

  @override
  String get noteActionEditReminderLabel => 'Erinnerung bearbeiten';

  @override
  String get noteActionSpeechToTextLabel => 'Sprache zu Text';

  @override
  String get noteActionArchiveLabel => 'Archivieren';

  @override
  String get noteActionUnarchiveLabel => 'Aus Archiv entfernen';

  @override
  String get noteActionLockLabel => 'Sperren';

  @override
  String get noteActionUnlockLabel => 'Entsperren';

  @override
  String get noteActionFavoriteLabel => 'Favorit';

  @override
  String get noteActionUnfavoriteLabel => 'Aus Favoriten entfernen';

  @override
  String get noteActionClassifyLabel => 'Ordner auswählen';

  @override
  String get noteActionDeleteLabel => 'Löschen';

  @override
  String get noteActionPinToNotificationLabel =>
      'An Benachrichtigungsleiste anheften';

  @override
  String get noteActionUnpinFromNotificationLabel => 'Anheftung entfernen';

  @override
  String get noteActionShareLabel => 'Teilen';

  @override
  String get noteActionDuplicateLabel => 'Kopie erstellen';

  @override
  String get noteActionCopyContentLabel => 'Inhalt kopieren';

  @override
  String get noteActionTtsLabel => 'Vorlesen';

  @override
  String get noteActionTextSizeLabel => 'Textgröße';

  @override
  String get noteActionDetailsLabel => 'Details';

  @override
  String get noteActionDiscardChangesLabel => 'Änderungen verwerfen';

  @override
  String get noteActionSelectLabel => 'Auswählen';

  @override
  String get reminderEditOptionLabel => 'Erinnerung ändern';

  @override
  String get reminderRemoveOptionLabel => 'Erinnerung entfernen';

  @override
  String get discardChangesDialogTitle => 'Änderungen verwerfen';

  @override
  String get discardChangesDialogMessage =>
      'Ungespeicherte Änderungen an dieser Notiz gehen verloren. Bist du sicher, dass du sie verwerfen möchtest?';

  @override
  String get discardChangesCancelButton => 'Abbrechen';

  @override
  String get discardChangesConfirmButton => 'Verwerfen';

  @override
  String get pinnedNotificationDefaultTitle => 'Notiz';

  @override
  String get pdfFailedInfoMessage => 'PDF konnte nicht erstellt werden';

  @override
  String get drawingScreenTitle => 'Zeichnung';

  @override
  String get drawingMinimizeTooltip => 'Minimieren';

  @override
  String get drawingEmptyExportWarningMessage => 'Zeichne zuerst etwas';

  @override
  String get drawingEraserPartialModeLabel => 'Teilweise';

  @override
  String get drawingEraserFullModeLabel => 'Vollständig';

  @override
  String get drawingClearTooltip => 'Löschen';

  @override
  String get drawingZoomOutTooltip => 'Verkleinern';

  @override
  String get drawingZoomInTooltip => 'Vergrößern';

  @override
  String get drawingDeleteTooltip => 'Löschen';

  @override
  String get drawingEmptyPreviewHint => 'Zum Zeichnen tippen';

  @override
  String get settingsPageTitle => 'Einstellungen';

  @override
  String get settingsSectionGeneral => 'Allgemein';

  @override
  String get settingsSectionSecurity => 'Sicherheit';

  @override
  String get settingsSectionTheme => 'Design';

  @override
  String get settingsSectionPersonalization => 'Personalisierung';

  @override
  String get settingsSectionWidget => 'Widget';

  @override
  String get settingsSectionAbout => 'Über';

  @override
  String get settingsHintQuestionPet => 'Wie hieß dein erstes Haustier?';

  @override
  String get settingsHintQuestionTeacher => 'Wie heißt dein Lieblingslehrer?';

  @override
  String get settingsHintQuestionBirthCity =>
      'In welcher Stadt bist du geboren?';

  @override
  String get settingsHintQuestionFavoriteFood => 'Was ist dein Lieblingsessen?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'Wie lautet der Mädchenname deiner Mutter?';

  @override
  String get settingsHintQuestionFirstSchool =>
      'Welche Schule hast du zuerst besucht?';

  @override
  String get settingsHintQuestionFavoriteColor =>
      'Was ist deine Lieblingsfarbe?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'Sicherheitsfrage';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'Wenn du dein Passwort vergisst, kannst du es wiederherstellen, indem du diese Frage richtig beantwortest.';

  @override
  String get settingsSecurityQuestionDropdownHint =>
      'Wähle eine Sicherheitsfrage';

  @override
  String get settingsSecurityQuestionAnswerHint => 'Deine Antwort';

  @override
  String get settingsSecurityQuestionCancelButton => 'Abbrechen';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'Frage und Antwort dürfen nicht leer sein!';

  @override
  String get settingsSecurityQuestionSaveButton => 'Speichern';

  @override
  String get settingsCreatePasswordTitle => 'Passwort erstellen';

  @override
  String get settingsPasswordRequiredTitle => 'Passwort erforderlich';

  @override
  String get settingsPasswordEnterHint => 'Passwort eingeben';

  @override
  String get settingsForgotPasswordButton => 'Passwort vergessen';

  @override
  String get settingsNewPasswordHint => 'Neues Passwort';

  @override
  String get settingsConfirmPasswordHint => 'Passwort erneut eingeben';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'Lege eine Sicherheitsfrage fest, falls du dein Passwort vergisst (optional).';

  @override
  String get settingsPasswordDialogCancelButton => 'Abbrechen';

  @override
  String get settingsPasswordMismatchWarning =>
      'Passwörter stimmen nicht überein!';

  @override
  String get settingsWrongPasswordWarning => 'Falsches Passwort!';

  @override
  String get settingsPasswordSaveButton => 'Speichern';

  @override
  String get settingsPasswordRemoveButton => 'Entfernen';

  @override
  String get settingsNotePasswordTitle => 'Notizpasswort';

  @override
  String get settingsPasswordSetSubtitle => 'Passwort festgelegt ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'Kein Passwort festgelegt';

  @override
  String get settingsSecurityQuestionTileTitle => 'Sicherheitsfrage';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'Festgelegt ✓ — wird verwendet, wenn du dein Passwort vergisst';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'Nicht festgelegt — du kannst dein Passwort nicht wiederherstellen, falls du es verlierst';

  @override
  String get settingsThemeDialogTitle => 'Design auswählen';

  @override
  String get settingsThemeSystemDefault => 'Systemstandard';

  @override
  String get settingsThemeLightOption => 'Helles Design';

  @override
  String get settingsThemeDarkOption => 'Dunkles Design';

  @override
  String get settingsLanguageDialogTitle => 'Sprache auswählen';

  @override
  String get settingsLanguageSystemOption => 'System';

  @override
  String get settingsAccentColorDialogTitle => 'Akzentfarbe wählen';

  @override
  String get settingsThemeChangeTileTitle => 'Design ändern';

  @override
  String get settingsThemeLightLabel => 'Hell';

  @override
  String get settingsThemeDarkLabel => 'Dunkel';

  @override
  String get settingsThemeSystemLabel => 'System';

  @override
  String get settingsLanguageTileTitle => 'Sprache';

  @override
  String get settingsAccentColorTileTitle => 'Akzentfarbe';

  @override
  String get settingsAccentColorTileSubtitle =>
      'Farbe für App-Leiste, Buttons und Schalter';

  @override
  String get settingsColorfulNotesTitle => 'Bunte Notizfarben';

  @override
  String get settingsColorfulNotesSubtitle =>
      'Jede Notizkarte erhält einen anderen Farbton.';

  @override
  String get settingsTextColorSheetTitle => 'Textfarbe';

  @override
  String get settingsTextColorSheetDesc =>
      'Legt die Farbe des Notizinhalts fest.';

  @override
  String get settingsTextColorOkButton => 'OK';

  @override
  String get settingsTextColorTileTitle => 'Textfarbe';

  @override
  String get settingsTextColorTileSubtitle => 'Farbe für den Notizinhaltstext.';

  @override
  String get settingsWidgetFontSizeLabel => 'Widget-Schriftgröße';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'Beispielüberschrift - $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'Abbrechen';

  @override
  String get settingsWidgetFontSizeApplyButton => 'Anwenden';

  @override
  String get settingsWidgetOpacityLabel => 'Hintergrundtransparenz';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return '$percent% Transparenz';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'Abbrechen';

  @override
  String get settingsWidgetOpacityApplyButton => 'Anwenden';

  @override
  String get settingsWidgetDarkModeTitle => 'Dunkles Widget';

  @override
  String get settingsWidgetDarkModeDesc => 'Dunkles Farbschema für das Widget.';

  @override
  String get settingsAboutVersionTitle => 'App-Version';

  @override
  String get settingsAboutVersionLoading => 'Version wird geladen…';

  @override
  String get aboutSectionDeveloper => 'Feedback';

  @override
  String get aboutDeveloperTitle => 'Entwickler';

  @override
  String get aboutContactTitle => 'Kontakt';

  @override
  String get aboutWebsiteTitle => 'Website';

  @override
  String get aboutGithubTitle => 'GitHub';

  @override
  String get aboutSectionLegal => 'Rechtliches';

  @override
  String get aboutPrivacyPolicyTitle => 'Datenschutzerklärung';

  @override
  String get aboutTermsTitle => 'Nutzungsbedingungen';

  @override
  String get aboutLicensesTitle => 'Open-Source-Lizenzen';

  @override
  String get aboutSectionSupport => 'Bewerten';

  @override
  String get aboutRateAppTitle => 'App bewerten';

  @override
  String get aboutLinkOpenError => 'Der Link konnte nicht geöffnet werden.';

  @override
  String get settingsFontFamilyTileTitle => 'Schriftart';

  @override
  String get settingsFontFamilyDefaultLabel => 'Standard';

  @override
  String get settingsGlobalFontSizeTileTitle => 'Schriftgröße';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt — für alle Notizen angewendet.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'Beispieltext - $size pt';
  }

  @override
  String get settingsGlobalFontSizeCancelButton => 'Abbrechen';

  @override
  String get settingsGlobalFontSizeApplyButton => 'Anwenden';

  @override
  String get settingsPreviewLinesTileTitle => 'Notizvorschauzeilen';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'Zeigt bis zu $lines Zeilen. Ist die Notiz kürzer, wird die tatsächliche Zeilenanzahl angezeigt.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'Aktuell: $lines Zeilen';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'Legt die maximale Anzahl der Vorschauzeilen fest. Hat die Notiz weniger Zeilen, wird die tatsächliche Anzahl angezeigt.';

  @override
  String get settingsPreviewLinesCancelButton => 'Abbrechen';

  @override
  String get settingsPreviewLinesApplyButton => 'Anwenden';

  @override
  String get backupCancelButton => 'Abbrechen';

  @override
  String get backupConnectButton => 'Verbinden';

  @override
  String get backupDisconnectButton => 'Trennen';

  @override
  String get backupContinueButton => 'Weiter';

  @override
  String get backupCloseButton => 'Schließen';

  @override
  String get backupShareButton => 'Teilen';

  @override
  String get backupRestoreButton => 'Wiederherstellen';

  @override
  String get backupConfigureButton => 'Konfigurieren';

  @override
  String get backupUnknownDateLabel => 'Unbekannt';

  @override
  String get backupProcessingDefaultLabel => 'Wird verarbeitet...';

  @override
  String get backupPermissionRequiredTitle => 'Speicherzugriff erforderlich';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'Diese Android-Version erfordert Speicherzugriff für Sicherung/Wiederherstellung. Da der Zugriff dauerhaft verweigert wurde, aktiviere ihn bitte manuell in den App-Einstellungen.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'Diese Android-Version erfordert Speicherzugriff für Sicherung/Wiederherstellung. Bitte erteile die Berechtigung, um fortzufahren.';

  @override
  String get backupGoToSettingsButton => 'Zu den Einstellungen';

  @override
  String get backupRetryButton => 'Erneut versuchen';

  @override
  String get backupDriveConnectingLabel =>
      'Verbindung mit Google-Konto wird hergestellt...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Mit Google Drive-Konto verbunden: $email';
  }

  @override
  String get backupDriveConnectedMessage => 'Mit Google Drive-Konto verbunden.';

  @override
  String get backupDriveConnectFailedMessage =>
      'Verbindung mit Google-Konto fehlgeschlagen oder Vorgang abgebrochen.';

  @override
  String get backupDriveDisconnectTitle => 'Google Drive trennen';

  @override
  String get backupDriveDisconnectBody =>
      'Wenn du die Verbindung trennst, sind manuelle oder automatische Sicherungen auf Drive nicht mehr möglich. Bereits auf Drive gespeicherte Sicherungen werden nicht gelöscht — nur der Zugriff von diesem Gerät wird entfernt.';

  @override
  String get backupDriveDisconnectedMessage =>
      'Google Drive-Verbindung entfernt.';

  @override
  String get backupDriveRequiredTitle => 'Google-Konto erforderlich';

  @override
  String get backupDriveRequiredBody =>
      'Diese Aktion erfordert, dass du dein Google-Konto verbindest. Möchtest du es jetzt verbinden?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: verbunden ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: verbunden';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: nicht verbunden';

  @override
  String get backupDriveAuthenticatingLabel => 'Google-Konto wird überprüft...';

  @override
  String get backupDriveNotSignedInMessage =>
      'Du bist nicht mit Google Drive verbunden. Bitte melde dich zuerst mit deinem Google-Konto an.';

  @override
  String get backupDriveUploadingLabel =>
      'Sicherung wird zu Drive hochgeladen...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Der Upload zu Google Drive wurde nicht innerhalb von 120 Sekunden abgeschlossen (keine Antwort vom Server). Bitte überprüfe deine Verbindung und versuche es erneut.';

  @override
  String get backupDriveOperationCompletedLabel => 'Abgeschlossen';

  @override
  String get backupToDriveActionLabel => 'Sicherung zu Drive';

  @override
  String get backupToDeviceActionLabel => 'Sicherung';

  @override
  String get backupCreatingLabel => 'Sicherung wird erstellt...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'Sicherung konnte nicht erstellt werden: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Upload zu Google Drive fehlgeschlagen: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'Sicherung erfolgreich zu Google Drive hochgeladen.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'Sicherung erstellt: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'Sicherung bereit';

  @override
  String get backupOfferShareBody =>
      'Deine Sicherungsdatei wurde auf dem Gerät gespeichert. Möchtest du sie jetzt teilen (z. B. Cloud-Speicher, E-Mail, anderes Gerät)?';

  @override
  String get backupShareFileText => 'Layout-Sicherungsdatei';

  @override
  String backupShareFailedMessage(String error) {
    return 'Teilen konnte nicht gestartet werden: $error';
  }

  @override
  String get backupLargeOperationTitle => 'Große Sicherung';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'Die zu verarbeitenden Daten umfassen etwa $sizeText. Eine $actionLabel dieser Größe kann je nach Gerät eine Weile dauern. Verlasse die App während des Vorgangs nicht — möchtest du fortfahren?';
  }

  @override
  String get backupRestoreActionLabel => 'Wiederherstellung';

  @override
  String get backupDriveListingLabel =>
      'Drive-Sicherungen werden aufgelistet...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'Sicherungen konnten nicht aufgelistet werden: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'Es gibt noch keine Sicherungen auf Google Drive.';

  @override
  String get backupDrivePickTitle => 'Sicherung von Drive auswählen';

  @override
  String get backupDriveDownloadingLabel =>
      'Sicherung wird von Drive heruntergeladen...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Sicherung wird von Drive heruntergeladen... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel =>
      'Datei wird auf dem Gerät gespeichert...';

  @override
  String get backupDriveUnknownBackupFileName => 'unbekannte_sicherung.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Dein Google Drive-Speicher ist voll. Bitte gib Speicherplatz auf Drive frei und versuche es erneut.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'Es konnte keine Internetverbindung hergestellt werden. Bitte überprüfe deine Verbindung und versuche es erneut.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'Die angegebene Sicherungsdatei konnte auf Drive nicht gefunden werden. Sie wurde möglicherweise gelöscht.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Bei der Google Drive-Operation ist ein unerwarteter Fehler aufgetreten: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'Download fehlgeschlagen: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'Datei konnte nicht ausgewählt werden: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'Auf die ausgewählte Datei konnte nicht zugegriffen werden.';

  @override
  String get backupCheckingLabel => 'Sicherung wird überprüft...';

  @override
  String backupReadFailedMessage(String error) {
    return 'Sicherungsdatei konnte nicht gelesen werden: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'Sicherung wiederherstellen';

  @override
  String get backupPreviewContentsHeader =>
      'Inhalt der ausgewählten Sicherung:';

  @override
  String get backupPreviewNoteCountLabel => 'Anzahl der Notizen';

  @override
  String get backupPreviewTrashCountLabel => 'Notizen im Papierkorb';

  @override
  String get backupPreviewCategoryCountLabel => 'Anzahl der Kategorien';

  @override
  String get backupPreviewAttachmentLabel => 'Anhänge';

  @override
  String get backupPreviewAttachmentNoneValue => 'Keine';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count Dateien ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'Erstellt am';

  @override
  String get backupEmptyPreviewTitle => 'Diese Sicherung scheint leer zu sein';

  @override
  String get backupEmptyPreviewBody =>
      'In der ausgewählten Datei wurden keine Notizen, Kategorien oder Anhänge gefunden. Wenn du fortfährst, werden deine aktuellen Daten trotzdem gelöscht und durch diese leere Sicherung ersetzt.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '$count Anhänge in der Sicherung nicht gefunden';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'Notizen mit diesen Dateien werden wiederhergestellt, jedoch ohne die Anhänge (sie könnten beim Erstellen der Sicherung gefehlt haben oder beschädigt gewesen sein): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown und $remaining weitere';
  }

  @override
  String get backupRestoreConfirmBody =>
      'Dies ERSETZT alle deine aktuellen Notizen, den Papierkorb, Kategorien, Einstellungen und Anhänge durch die Daten der obigen Sicherung. Deine aktuellen Daten gehen dauerhaft verloren, und diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get backupRestoringLabel => 'Sicherung wird wiederhergestellt...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'Sicherung wiederhergestellt. Allerdings wurden $count Anhänge in der Sicherung nicht gefunden und konnten nicht wiederhergestellt werden. Es wird empfohlen, die App neu zu starten, damit die Änderungen vollständig wirksam werden.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'Sicherung erfolgreich wiederhergestellt. Es wird empfohlen, die App neu zu starten, damit die Änderungen vollständig wirksam werden.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'Beim Wiederherstellen ist ein Fehler aufgetreten: $error';
  }

  @override
  String get backupScreenTitle => 'Sichern & Wiederherstellen';

  @override
  String get backupBlockedExitWarningMessage =>
      'Ein Vorgang läuft, bitte warte, bis er abgeschlossen ist.';

  @override
  String get backupBusyBackTooltip => 'Vorgang läuft';

  @override
  String get backupIntroText =>
      'Du kannst deine Notizen, Kategorien, Einstellungen und Anhänge als einzelne .zip-Datei sichern oder eine zuvor erstellte Sicherung wiederherstellen.';

  @override
  String get backupDriveCardTitle => 'Auf Google Drive sichern';

  @override
  String get backupDriveCardSubtitle =>
      'Erstelle eine neue Sicherung und lade sie direkt in den privaten Bereich deines Google Drive hoch.';

  @override
  String get backupDriveCardButtonLabel => 'Auf Drive sichern';

  @override
  String get backupDeviceCardTitle => 'Auf Gerät sichern';

  @override
  String get backupDeviceCardSubtitle =>
      'Speichere alle deine Daten als einzelne .zip-Datei auf deinem Gerät und teile sie bei Bedarf.';

  @override
  String get backupDeviceCardButtonLabel => 'Auf Gerät sichern';

  @override
  String get backupHistoryCardTitle => 'Sicherungsverlauf';

  @override
  String get backupHistoryCardSubtitle =>
      'Zeige alle auf deinem Gerät gespeicherten Sicherungen mit Datum und Größe an; du kannst sie direkt von hier aus teilen, wiederherstellen oder löschen.';

  @override
  String get backupHistoryTabDevice => 'Gerät';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'Sicherung löschen';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'Bist du sicher, dass du die Sicherungsdatei \"$fileName\" dauerhaft löschen möchtest? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'Sicherung gelöscht.';

  @override
  String get backupHistoryDriveDeleteDialogTitle => 'Drive-Sicherung löschen';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'Bist du sicher, dass du die Sicherung \"$fileName\" dauerhaft von Google Drive löschen möchtest? Diese Aktion kann nicht rückgängig gemacht werden, und die Datei wird nicht in den Papierkorb verschoben.';
  }

  @override
  String get backupHistoryDriveDeletedMessage => 'Drive-Sicherung gelöscht.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'Löschen fehlgeschlagen: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'Auf diesem Gerät sind noch keine Sicherungen gespeichert.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'Verwende \"Auf Gerät sichern\", um deine erste Sicherung zu erstellen.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'Verwende \"Auf Google Drive sichern\", um deine erste Cloud-Sicherung zu erstellen.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Verbinde dein Google-Konto, um deine Drive-Sicherungen zu sehen.';

  @override
  String get backupHistoryConnectGoogleButton => 'Mit Google verbinden';

  @override
  String get backupHistoryDriveConnectedFallback => 'Verbunden';

  @override
  String get backupHistoryUnknownErrorFallback =>
      'Ein unbekannter Fehler ist aufgetreten.';

  @override
  String get backupHistoryDownloadStartingLabel => 'Wird gestartet...';

  @override
  String get backupAutoBackupEnabledLabel => 'Automatische Sicherung: an';

  @override
  String get backupAutoBackupDisabledLabel => 'Automatische Sicherung: aus';

  @override
  String get backupOverlayWarningMessage =>
      'Bitte warte, verlasse die App nicht, bis der Vorgang abgeschlossen ist.';

  @override
  String get pdfExportUntitledNoteLabel => 'Notiz ohne Titel';

  @override
  String get pdfExportDefaultAttachmentName => 'Anhang';

  @override
  String get pdfExportDefaultFileName => 'notiz';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'Screenshot konnte nicht erstellt werden (Begrenzung nicht gefunden)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'Screenshot-Daten konnten nicht generiert werden';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'Bild konnte nicht verarbeitet werden (PNG-Dekodierung fehlgeschlagen)';

  @override
  String get screenshotCalcTableTotalLabel => 'Gesamt';

  @override
  String get gundemMenuRemoveFromAgenda => 'Aus Agenda entfernen';

  @override
  String get gundemMenuDeleteNote => 'Notiz löschen';

  @override
  String get gundemSectionOverdue => 'Überfällig';

  @override
  String get gundemSectionToday => 'Heute';

  @override
  String get gundemSectionTomorrow => 'Morgen';

  @override
  String get gundemSectionNextWeek => 'Nächste Woche';

  @override
  String get gundemSectionFurther => 'Weiter in der Zukunft';

  @override
  String get gundemWeekdayMonday => 'Montag';

  @override
  String get gundemWeekdayTuesday => 'Dienstag';

  @override
  String get gundemWeekdayWednesday => 'Mittwoch';

  @override
  String get gundemWeekdayThursday => 'Donnerstag';

  @override
  String get gundemWeekdayFriday => 'Freitag';

  @override
  String get gundemWeekdaySaturday => 'Samstag';

  @override
  String get gundemWeekdaySunday => 'Sonntag';

  @override
  String get gundemAppBarTitle => 'Agenda';

  @override
  String get gundemCalendarTooltip => 'Kalender';

  @override
  String get gundemEmptyTitle => 'Nichts in deiner Agenda';

  @override
  String get gundemEmptySubtitle =>
      'Notizen mit einer Erinnerung oder einem zugewiesenen Datum erscheinen hier.';

  @override
  String get gundemUntitledNote => 'Notiz ohne Titel';

  @override
  String get gundemRepeatHourly => 'Stündlich';

  @override
  String get gundemRepeatDaily => 'Täglich';

  @override
  String get gundemRepeatWeekly => 'Wöchentlich';

  @override
  String get gundemRepeatMonthly => 'Monatlich';

  @override
  String get gundemRepeatYearly => 'Jährlich';

  @override
  String get gundemPreviewCalcTableLabel => '[Berechnungsliste]';

  @override
  String get gundemPreviewDrawingLabel => '[Zeichnung]';

  @override
  String get gundemPreviewImageLabel => '[Bild]';

  @override
  String get gundemMonthShortJan => 'Jan';

  @override
  String get gundemMonthShortFeb => 'Feb';

  @override
  String get gundemMonthShortMar => 'Mär';

  @override
  String get gundemMonthShortApr => 'Apr';

  @override
  String get gundemMonthShortMay => 'Mai';

  @override
  String get gundemMonthShortJun => 'Jun';

  @override
  String get gundemMonthShortJul => 'Jul';

  @override
  String get gundemMonthShortAug => 'Aug';

  @override
  String get gundemMonthShortSep => 'Sep';

  @override
  String get gundemMonthShortOct => 'Okt';

  @override
  String get gundemMonthShortNov => 'Nov';

  @override
  String get gundemMonthShortDec => 'Dez';

  @override
  String get calendarAppBarTitle => 'Kalender';

  @override
  String get calendarTodayButton => 'Heute';

  @override
  String get calendarLegendNoteLabel => 'Notiz';

  @override
  String get calendarLegendReminderLabel => 'Erinnerung';

  @override
  String get calendarTodayBadge => 'Heute';

  @override
  String get calendarEmptyDayMessage =>
      'Keine Notizen oder Erinnerungen für diesen Tag.';

  @override
  String get calendarReminderHourlyLabel => 'Stündlich';

  @override
  String get calendarMonthJan => 'Januar';

  @override
  String get calendarMonthFeb => 'Februar';

  @override
  String get calendarMonthMar => 'März';

  @override
  String get calendarMonthApr => 'April';

  @override
  String get calendarMonthMay => 'Mai';

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
  String get calendarMonthDec => 'Dezember';

  @override
  String get calendarWeekdayShortMon => 'Mo';

  @override
  String get calendarWeekdayShortTue => 'Di';

  @override
  String get calendarWeekdayShortWed => 'Mi';

  @override
  String get calendarWeekdayShortThu => 'Do';

  @override
  String get calendarWeekdayShortFri => 'Fr';

  @override
  String get calendarWeekdayShortSat => 'Sa';

  @override
  String get calendarWeekdayShortSun => 'So';

  @override
  String get calendarWeekdayFullMonday => 'Montag';

  @override
  String get calendarWeekdayFullTuesday => 'Dienstag';

  @override
  String get calendarWeekdayFullWednesday => 'Mittwoch';

  @override
  String get calendarWeekdayFullThursday => 'Donnerstag';

  @override
  String get calendarWeekdayFullFriday => 'Freitag';

  @override
  String get calendarWeekdayFullSaturday => 'Samstag';

  @override
  String get calendarWeekdayFullSunday => 'Sonntag';

  @override
  String get wrongPasswordDialogTitle => 'Falsches Passwort';

  @override
  String get wrongPasswordDialogMessage =>
      'Das eingegebene Passwort ist falsch.';

  @override
  String get commonOkButton => 'OK';

  @override
  String get unlockCategoryAction => 'Entsperren';

  @override
  String get lockCategoryAction => 'Sperren';

  @override
  String get categoryUnlockedMessage => 'Entsperrt';

  @override
  String get categoryLockedMessage => 'Ordner gesperrt';

  @override
  String get deleteFolderMenuItemLabel => 'Ordner löschen';

  @override
  String get deleteFolderDialogTitle => 'Ordner löschen';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'Bist du sicher, dass du den Ordner \"$category\" und alle seine Unterordner löschen möchtest? Notizen in diesen Ordnern werden unkategorisiert.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'Bist du sicher, dass du den Ordner \"$category\" löschen möchtest? Notizen in diesem Ordner werden unkategorisiert.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'Abbrechen';

  @override
  String get deleteFolderDialogConfirmButton => 'Löschen';

  @override
  String get editCategoryNameColorMenuItemLabel => 'Name / Farbe bearbeiten';

  @override
  String get addSubfolderMenuItemLabel => 'Unterordner erstellen';

  @override
  String get expandSubfoldersMenuItemLabel => 'Unterordner erweitern';

  @override
  String get collapseSubfoldersMenuItemLabel => 'Unterordner einklappen';

  @override
  String saveErrorInfoMessage(String error) {
    return 'Speicherfehler: $error';
  }

  @override
  String get welcomeNoteTitle => 'Willkommen bei Layout! 🚀';

  @override
  String get welcomeNoteContent => 'Neue Funktionen hinzugefügt!';

  @override
  String get noteListDateGroupToday => 'Heute';

  @override
  String get noteListDateGroupYesterday => 'Gestern';

  @override
  String get noteListDateGroupLast7Days => 'Letzte 7 Tage';

  @override
  String get noteListDateGroupLast30Days => 'Letzte 30 Tage';

  @override
  String get reminderRepeatNoneLabel => 'Keine Wiederholung';

  @override
  String get voiceRecorderPreparingLabel => 'Wird vorbereitet…';

  @override
  String get voiceRecorderCancelButton => 'Abbrechen';

  @override
  String get voiceRecorderStopAddButton => 'Stoppen und hinzufügen';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'Mikrofonzugriff wurde nicht erteilt.';

  @override
  String get speechToTextUnavailableMessage =>
      'Spracherkennung ist auf diesem Gerät nicht verfügbar.';

  @override
  String get speechToTextPreparingLabel => 'Wird vorbereitet…';

  @override
  String get speechToTextListeningLabel => 'Hört zu…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'Beginne zu sprechen…';

  @override
  String get speechToTextCancelButton => 'Abbrechen';

  @override
  String get speechToTextStopAddButton => 'Stoppen und hinzufügen';

  @override
  String get textToSpeechNoContentMessage =>
      'Es gibt keinen Inhalt zum Vorlesen.';

  @override
  String get textToSpeechReadErrorMessage =>
      'Beim Vorlesen ist ein Fehler aufgetreten.';

  @override
  String get textToSpeechUnavailableMessage =>
      'Text-zu-Sprache ist auf diesem Gerät nicht verfügbar.';

  @override
  String get textToSpeechPreparingLabel => 'Wird vorbereitet…';

  @override
  String get textToSpeechPausedLabel => 'Pausiert';

  @override
  String get textToSpeechFinishedLabel => 'Vorlesen abgeschlossen';

  @override
  String get textToSpeechReadingLabel => 'Wird vorgelesen…';

  @override
  String get textToSpeechCloseErrorButton => 'Schließen';

  @override
  String get textToSpeechReplayButton => 'Erneut vorlesen';

  @override
  String get textToSpeechCloseFinishedButton => 'Schließen';

  @override
  String get textToSpeechPauseButton => 'Pause';

  @override
  String get textToSpeechResumeButton => 'Fortsetzen';

  @override
  String get textToSpeechStopButton => 'Stopp';

  @override
  String get textToSpeechSpeedSlow => 'Langsam';

  @override
  String get textToSpeechSpeedNormal => 'Normal';

  @override
  String get textToSpeechSpeedFast => 'Schnell';

  @override
  String get calendarPickerCancelButton => 'Abbrechen';

  @override
  String get calendarPickerConfirmButton => 'Auswählen';

  @override
  String get calendarPickerClearButton => 'Löschen';

  @override
  String get reminderPickerDialogTitle => 'Erinnerung hinzufügen';

  @override
  String get reminderPickerDateTodayOption => 'Heute';

  @override
  String get reminderPickerDateTomorrowOption => 'Morgen';

  @override
  String get reminderPickerDatePickOption => 'Datum wählen';

  @override
  String get reminderRepeatHourlyLabel => 'Jede Stunde';

  @override
  String get reminderRepeatDailyLabel => 'Jeden Tag';

  @override
  String get reminderRepeatWeeklyLabel => 'Jede Woche';

  @override
  String get reminderRepeatMonthlyLabel => 'Jeden Monat';

  @override
  String get reminderRepeatYearlyLabel => 'Jedes Jahr';

  @override
  String get reminderPickerCalendarHelpText => 'Erinnerungsdatum auswählen';

  @override
  String get reminderPickerCancelButton => 'ABBRECHEN';

  @override
  String get reminderPickerSaveButton => 'SPEICHERN';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'Eine vergangene Uhrzeit kann nicht ausgewählt werden';

  @override
  String calcTableTotalLabel(String amount) {
    return 'Gesamt: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'Daten werden vorbereitet...';

  @override
  String get backupCreatePackagingNotesLabel =>
      'Notizen und Kategorien werden zusammengestellt...';

  @override
  String get backupCreateReadingAttachmentsLabel => 'Anhänge werden gelesen...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'Anhänge werden gelesen... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'ZIP-Datei wird komprimiert...';

  @override
  String get backupCreateSavingFileLabel => 'Datei wird gespeichert...';

  @override
  String get backupRestoreValidatingLabel => 'Sicherung wird überprüft...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'Sicherung überprüft, Daten werden vorbereitet...';

  @override
  String get backupRestoreWritingNotesLabel => 'Notizen werden geschrieben...';

  @override
  String get backupRestoreWritingTrashLabel => 'Papierkorb wird geschrieben...';

  @override
  String get backupRestoreTrashWrittenLabel => 'Papierkorb geschrieben';

  @override
  String get backupRestoreWritingCategoriesLabel =>
      'Kategorien werden geschrieben...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'Kategorien geschrieben';

  @override
  String get backupRestoreWritingSettingsLabel =>
      'Einstellungen werden geschrieben...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'Einstellungen geschrieben';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'Alte Anhänge werden bereinigt...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'Keine Anhänge gefunden, wird abgeschlossen...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'Anhänge werden wiederhergestellt... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'Abgeschlossen';

  @override
  String get backupValidationCorruptedFileMessage =>
      'Die Datei ist beschädigt oder keine gültige Sicherungsdatei.';

  @override
  String get backupValidationMissingDataMessage =>
      'Keine Daten in der Sicherungsdatei gefunden (backup_data.json fehlt).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'Sicherungsdaten konnten nicht gelesen werden (beschädigtes JSON).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'Diese Datei ist keine Sicherung der layout-App.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'Die Versionsinformationen der Sicherungsdatei konnten nicht gelesen werden.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'Diese Sicherung liegt in einem neueren Format vor, das von der aktuellen App-Version nicht unterstützt wird. Bitte aktualisiere die App.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'Die Versionsinformationen der Sicherungsdatei sind ungültig.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'Die Sicherungsdaten entsprechen nicht dem erwarteten Format (Feld \"notes\" fehlt).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'Die Sicherungsdaten entsprechen nicht dem erwarteten Format (Feld \"trash\" fehlt).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'Die Sicherungsdaten entsprechen nicht dem erwarteten Format (Kategorieliste ist ungültig).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'Die Sicherungsdaten entsprechen nicht dem erwarteten Format (Feld \"settings\" ist ungültig).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'Die Sicherungsdaten entsprechen nicht dem erwarteten Format (ein Notizeintrag ist ungültig).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'Die Sicherungsdaten entsprechen nicht dem erwarteten Format (ein Notizeintrag ohne ID wurde gefunden).';

  @override
  String get backupValidationFileNotFoundMessage =>
      'Sicherungsdatei nicht gefunden.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'Nicht genügend freier Speicherplatz auf dem Gerät. Bitte gib Speicherplatz frei und versuche es erneut.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'Der Dateizugriff wurde verweigert. Bitte überprüfe die App-Berechtigungen und versuche es erneut.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'Bei der Dateioperation ist ein Fehler aufgetreten: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'Ein unerwarteter Fehler ist aufgetreten: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'Das ZIP-Archiv konnte nicht erstellt werden (ZipEncoder gab null zurück).';

  @override
  String get calcTableMenuItemLabel => 'Berechnungsliste';

  @override
  String get tableBlockMenuItemLabel => 'Tabelle';

  @override
  String get tableSizePickerTitle => 'Tabellengröße auswählen';

  @override
  String get tableSizePickerCancel => 'Abbrechen';

  @override
  String get tableSizePickerDeleteTooltip => 'Tabelle löschen';

  @override
  String get tagsMenuItemLabel => 'Tags';

  @override
  String get linkDialogUrlHint => 'https://beispiel.de';

  @override
  String get checklistItemHint => 'Eintrag hinzufügen...';

  @override
  String get toolbarHighlightTooltip => 'Hervorheben';

  @override
  String get toolbarListTooltip => 'Liste';

  @override
  String get toolbarHideKeyboardTooltip => 'Tastatur ausblenden';

  @override
  String get autoBackupLocalSuccessMessage => 'Lokale Sicherung erfolgreich.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'Lokale Sicherung fehlgeschlagen: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Drive-Sicherung übersprungen: Google-Konto ist nicht verbunden oder die Sitzung ist abgelaufen. Bitte öffne die App und verbinde dich erneut.';

  @override
  String get autoBackupDriveSuccessMessage => 'Drive-Sicherung erfolgreich.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Drive-Sicherung fehlgeschlagen: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'Noch keine Notizen';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'Gesamt: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ Zeichnung';

  @override
  String get autoBackupSettingsAppBarTitle =>
      'Einstellungen für automatische Sicherung';

  @override
  String get autoBackupSettingsMainSwitchTitle =>
      'Automatische Sicherung aktivieren';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'Deine Notizen werden regelmäßig sicher im Hintergrund gesichert.';

  @override
  String get autoBackupSettingsTargetTitle => 'Sicherungsziel';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'Wähle, wo Sicherungen gespeichert werden.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'Lokal';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'Beide';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Verbinde zuerst dein Konto, um Google Drive-Optionen zu nutzen.';

  @override
  String get autoBackupSettingsConnectButton => 'Verbinden';

  @override
  String get autoBackupSettingsFrequencyTitle => 'Sicherungshäufigkeit';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'Alle $hours Stunden wird eine Sicherung erstellt.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 Stunden';

  @override
  String get autoBackupSettingsFrequency12h => '12 Stunden';

  @override
  String get autoBackupSettingsFrequency24h => '24 Stunden (täglich)';

  @override
  String get autoBackupSettingsFrequency48h => '48 Stunden (2 Tage)';

  @override
  String get autoBackupSettingsFrequency168h => '168 Stunden (wöchentlich)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Nur WLAN verwenden';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'Der Cloud-Upload erfolgt nur über WLAN, um deine mobilen Daten zu schonen.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'Systemstatus';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'Die automatische Sicherung wurde noch nicht ausgeführt.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'Letzte Ausführung: $date $time ($status)\\nNachricht: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'Erfolgreich';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'Fehlgeschlagen';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Verbindung mit Google-Konto fehlgeschlagen.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'Einstellungen für automatische Sicherung aktualisiert.';

  @override
  String selectionModeDeletedMessage(int count) {
    return '$count Notizen gelöscht';
  }

  @override
  String get selectionModeArchivedMessage => 'Archiviert';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'Kategorie für $count Notizen wählen';
  }

  @override
  String get selectionModeAddCategoryOption => 'Kategorie hinzufügen';

  @override
  String get selectionModeRemoveCategoryOption => 'Kategorie entfernen';

  @override
  String get calcTableItemHint => 'Eintrag...';

  @override
  String get calcTableTotalRowLabel => 'Gesamt';

  @override
  String get textSelectionMenuShareButton => 'Teilen';

  @override
  String get textSelectionMenuTranslateButton => 'Übersetzen';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'Teilen konnte nicht gestartet werden.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'Übersetzung konnte nicht geöffnet werden.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'Heute $time';
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
    return 'Letzte Sicherung: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage =>
      'Es wurde noch keine Sicherung erstellt.';

  @override
  String get backupFileNameLabel => 'Sicherung';

  @override
  String get tableMenuInsertRowAfter => 'Zeile hinzufügen';

  @override
  String get tableMenuDeleteRow => 'Zeile löschen';

  @override
  String get tableMenuInsertColumnAfter => 'Spalte hinzufügen';

  @override
  String get tableMenuDeleteColumn => 'Spalte löschen';

  @override
  String get imageCropToolbarTitle => 'Zuschneiden';

  @override
  String get imageViewerDeleteButtonLabel => 'Löschen';

  @override
  String get imageViewerSaveToGalleryButtonLabel => 'Speichern';

  @override
  String get imageViewerShareButtonLabel => 'Teilen';

  @override
  String get imageViewerGalleryPermissionDeniedMessage =>
      'Kein Zugriff auf die Galerie erteilt';

  @override
  String get imageViewerSavedToGalleryMessage => 'Im Album gespeichert';

  @override
  String imageViewerSaveFailedMessage(String error) {
    return 'Speichern fehlgeschlagen: $error';
  }

  @override
  String get imageViewerSavingInProgressMessage => 'Wird gespeichert…';

  @override
  String get imageViewerFileNotFoundMessage =>
      'Diese Datei ist nicht mehr vorhanden';
}
