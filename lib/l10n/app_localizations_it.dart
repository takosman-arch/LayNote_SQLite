// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'Grassetto';

  @override
  String get toolbarItalicTooltip => 'Corsivo';

  @override
  String get toolbarUnderlineTooltip => 'Sottolineato';

  @override
  String get toolbarStrikethroughTooltip => 'Barrato';

  @override
  String get toolbarFontSizeTooltip => 'Dimensione carattere';

  @override
  String get toolbarColorTooltip => 'Colore testo';

  @override
  String get toolbarBulletTooltip => 'Elenco puntato';

  @override
  String get toolbarNumberTooltip => 'Elenco numerato';

  @override
  String get toolbarIndentTooltip => 'Rientro paragrafo';

  @override
  String get toolbarLinkTooltip => 'Aggiungi / Modifica / Rimuovi link';

  @override
  String get toolbarDividerTooltip => 'Inserisci divisore';

  @override
  String get toolbarChecklistTooltip => 'Aggiungi lista di controllo';

  @override
  String get linkSelectTextSnackbar =>
      'Seleziona prima il testo a cui vuoi aggiungere il link';

  @override
  String get linkDialogEditTitle => 'Modifica link';

  @override
  String get linkDialogAddTitle => 'Aggiungi link';

  @override
  String get linkDialogRemoveButton => 'Rimuovi link';

  @override
  String get linkDialogCancelButton => 'Annulla';

  @override
  String get linkDialogConfirmButton => 'Aggiungi';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Permesso fotocamera negato. Devi consentirlo dalle impostazioni per registrare un video.';

  @override
  String get cameraPermissionRequiredMessage =>
      'È necessario il permesso della fotocamera per registrare un video.';

  @override
  String get openSettingsButtonLabel => 'Impostazioni';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'Impossibile avviare la scansione: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'Riconoscimento del testo non riuscito: $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'Nessun testo leggibile trovato nel documento';

  @override
  String get scanResultSheetTitle =>
      'Come deve essere aggiunto il documento scansionato?';

  @override
  String get scanResultTextOnlyOption => 'Aggiungi solo come testo';

  @override
  String get scanResultTextAndImageOption =>
      'Aggiungi testo + immagine scansionata';

  @override
  String get scanResultCancelOption => 'Annulla';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'Permesso microfono negato. Devi consentirlo dalle impostazioni per registrare l\'audio.';

  @override
  String get audioPermissionRequiredMessage =>
      'È necessario il permesso del microfono per registrare l\'audio.';

  @override
  String get voiceRecordingDefaultLabel => 'Registrazione vocale';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'Lista di calcolo ($count righe)';
  }

  @override
  String get blockPreviewDrawingLabel => 'Disegno';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count allegati (foto/documento)';
  }

  @override
  String get blockPreviewDividerLabel => 'Divisore';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'Lista di controllo ($count elementi)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(testo vuoto)';

  @override
  String get reorderBlocksSheetTitle => 'Riordina blocchi';

  @override
  String get reorderBlocksMoveUpTooltip => 'Sposta su';

  @override
  String get reorderBlocksMoveDownTooltip => 'Sposta giù';

  @override
  String get reorderBlocksCloseTooltip => 'Chiudi';

  @override
  String get reorderBlocksDescription =>
      'Tocca un blocco per selezionarlo, poi usa le frecce su/giù per spostarlo.';

  @override
  String get reorderBlocksMenuItemLabel => 'Riordina';

  @override
  String get txtImportPickerDialogTitle => 'Seleziona il file TXT da importare';

  @override
  String get txtImportReadFailedMessage => 'Impossibile leggere il file TXT';

  @override
  String get txtImportEmptyFileMessage => 'Il file TXT è vuoto';

  @override
  String get txtImportSuccessMessage => 'TXT importato';

  @override
  String get txtImportMenuItemLabel => 'Importa (txt)';

  @override
  String get exportMenuItemLabel => 'Esporta';

  @override
  String get editorUndoTooltip => 'Annulla';

  @override
  String get editorRedoTooltip => 'Ripeti';

  @override
  String get noteSavedMessage => 'Nota salvata';

  @override
  String get dateAssignPickerHelpText => 'Assegna la nota a un giorno';

  @override
  String get dateAssignChangeOption => 'Cambia data';

  @override
  String get dateAssignRemoveOption => 'Rimuovi assegnazione';

  @override
  String get editorSubToolbarCloseTooltip => 'Chiudi';

  @override
  String get titleFieldHint => 'Titolo';

  @override
  String get textBlockHint => 'Scrivi qui la tua nota...';

  @override
  String get drawingBoardMenuItemLabel => 'Lavagna da disegno';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'La trascrizione vocale è disponibile solo per le note di testo';

  @override
  String get selectionModeCancelTooltip => 'Annulla selezione';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return '$count selezionati';
  }

  @override
  String get selectionModeDeleteTooltip => 'Elimina';

  @override
  String get selectionModeArchiveTooltip => 'Archivia';

  @override
  String get selectionModeFolderTooltip => 'Cartella';

  @override
  String get searchFieldHint => 'Cerca note...';

  @override
  String get emptyTrashDialogTitle => 'Svuota cestino';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'Tutte le note eliminate verranno rimosse definitivamente. Sei sicuro?';

  @override
  String get emptyTrashDialogCancelButton => 'Annulla';

  @override
  String get restoreAllMenuItemLabel => 'Ripristina tutto';

  @override
  String get sortMenuTooltip => 'Ordina note';

  @override
  String get sortMenuAscendingLabel => 'Ordine: crescente (A-Z)';

  @override
  String get sortMenuDescendingLabel => 'Ordine: decrescente (Z-A)';

  @override
  String get sortMenuByTitleLabel => 'Ordina per: titolo';

  @override
  String get sortMenuByModifiedDateLabel => 'Ordina per: ultima modifica';

  @override
  String get sortMenuByCreatedDateLabel => 'Ordina per: data di creazione';

  @override
  String get sortMenuByFolderLabel => 'Ordina per: cartella';

  @override
  String get viewToggleGridTooltip => 'Visualizzazione griglia';

  @override
  String get viewToggleListTooltip => 'Visualizzazione elenco';

  @override
  String get drawerHeaderSubtitle => 'Il tuo taccuino personale';

  @override
  String get drawerNotesSectionHeader => 'NOTE';

  @override
  String get drawerAllNotesLabel => 'Note';

  @override
  String get drawerFavoritesLabel => 'Preferiti';

  @override
  String get drawerAgendaLabel => 'Agenda';

  @override
  String get drawerRemindersLabel => 'Promemoria';

  @override
  String get drawerLockedLabel => 'Bloccate';

  @override
  String get drawerTrashLabel => 'Cestino';

  @override
  String get drawerFoldersSectionHeader => 'CARTELLE';

  @override
  String get drawerExpandLabel => 'Espandi';

  @override
  String get drawerCollapseLabel => 'Comprimi';

  @override
  String get drawerAddFolderLabel => 'Aggiungi cartella';

  @override
  String get drawerAppSectionHeader => 'APP';

  @override
  String get drawerCalendarLabel => 'Calendario';

  @override
  String get drawerSettingsLabel => 'Impostazioni';

  @override
  String get drawerBackupRestoreLabel => 'Backup e ripristino';

  @override
  String get drawerUpgradeToProLabel => 'Passa a Pro';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'Sostieni lo sviluppo';

  @override
  String get drawerFeedbackLabel => 'Feedback';

  @override
  String get drawerAboutLabel => 'Informazioni';

  @override
  String get noNotesFoundMessage => 'Nessuna nota trovata.';

  @override
  String get trashRestoreButtonLabel => 'Ripristina';

  @override
  String get trashPermanentDeleteButtonLabel => 'Elimina definitivamente';

  @override
  String get tagRenamedInfoMessage => 'Tag rinominato';

  @override
  String get tagDeletedInfoMessage => 'Tag eliminato';

  @override
  String get tagOptionsRenameLabel => 'Rinomina';

  @override
  String get tagOptionsDeleteLabel => 'Elimina';

  @override
  String get renameTagDialogTitle => 'Rinomina tag';

  @override
  String get renameTagDialogHint => 'Nuovo nome del tag';

  @override
  String get renameTagDialogCancelButton => 'Annulla';

  @override
  String get renameTagDialogSaveButton => 'Salva';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '\"$tag\" verrà rimosso da $affectedCount note. Continuare?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'Eliminare il tag \"$tag\"?';
  }

  @override
  String get deleteTagDialogTitle => 'Elimina tag';

  @override
  String get deleteTagDialogCancelButton => 'Annulla';

  @override
  String get deleteTagDialogConfirmButton => 'Elimina';

  @override
  String get tagsSheetTitle => 'Tag';

  @override
  String get tagsSheetEmptyMessage =>
      'Nessun tag ancora presente su questa nota.';

  @override
  String get tagsSheetInputHint => 'Scrivi un nuovo tag...';

  @override
  String get tagsSheetSuggestionsLabel => 'Tag esistenti';

  @override
  String get noteDeletedInfoMessage => 'Nota eliminata';

  @override
  String get noteDeletedUndoActionLabel => 'Annulla';

  @override
  String get reminderSetInfoMessage => 'Promemoria impostato';

  @override
  String get reminderRemovedInfoMessage => 'Promemoria rimosso';

  @override
  String get noteDuplicatedInfoMessage => 'Copia creata';

  @override
  String get speechTextAppendedInfoMessage => 'Testo aggiunto alla nota';

  @override
  String get pdfPreparingInfoMessage => 'Preparazione PDF…';

  @override
  String get pdfSavedInfoMessage => 'PDF salvato';

  @override
  String get jpgPreparingInfoMessage => 'Preparazione JPG…';

  @override
  String get jpgSavedInfoMessage => 'JPG salvato';

  @override
  String get jpgFailedInfoMessage => 'Impossibile creare il JPG';

  @override
  String get txtPreparingInfoMessage => 'Preparazione TXT…';

  @override
  String get txtSavedInfoMessage => 'TXT salvato';

  @override
  String get txtFailedInfoMessage => 'Impossibile creare il TXT';

  @override
  String get exportOpenActionLabel => 'Apri';

  @override
  String get wrongPasswordInfoMessage => 'Password errata.';

  @override
  String get noteArchivedInfoMessage => 'Nota archiviata';

  @override
  String get noteUnarchivedInfoMessage => 'Rimossa dall\'archivio';

  @override
  String get noteUnlockedInfoMessage => 'Sbloccata';

  @override
  String get noteLockedInfoMessage => 'Nota bloccata';

  @override
  String get notificationUnpinnedInfoMessage => 'Rimossa dai fissati';

  @override
  String get emptyNotePinBlockedInfoMessage =>
      'Una nota vuota non può essere fissata.';

  @override
  String get notificationPinnedInfoMessage =>
      'Fissata al pannello delle notifiche';

  @override
  String get noContentToReadInfoMessage =>
      'Non c\'è alcun contenuto da leggere';

  @override
  String get backPressExitInfoMessage => 'Premi di nuovo indietro per uscire';

  @override
  String get reminderChannelName => 'Promemoria note';

  @override
  String get reminderChannelDescription =>
      'Promemoria delle note nell\'app Layout';

  @override
  String get pinnedChannelName => 'Note fissate';

  @override
  String get pinnedChannelDescription =>
      'Note di Layout fissate al pannello delle notifiche';

  @override
  String get notificationUnpinActionLabel => 'Rimuovi';

  @override
  String get reminderDefaultTitle => 'Promemoria';

  @override
  String get reminderChecklistBodyFallback =>
      'Non dimenticare di controllare la tua lista di controllo';

  @override
  String get reminderTextBodyFallback =>
      'Non dimenticare di controllare la tua nota';

  @override
  String get pdfSaveDialogTitle => 'Salva come PDF';

  @override
  String get jpgSaveDialogTitle => 'Salva come JPG';

  @override
  String get txtSaveDialogTitle => 'Salva come TXT';

  @override
  String get textSizeSheetTitle => 'Dimensione testo';

  @override
  String get textSizeSamplePreview => 'Testo di esempio';

  @override
  String get textSizeCancelButton => 'Annulla';

  @override
  String get textSizeApplyButton => 'Applica';

  @override
  String get createPasswordDialogTitle => 'Crea password';

  @override
  String get createPasswordNewPasswordHint => 'Nuova password';

  @override
  String get createPasswordConfirmHint => 'Reinserisci password';

  @override
  String get createPasswordHintQuestionDescription =>
      'Imposta una domanda di sicurezza nel caso dimentichi la password (facoltativo).';

  @override
  String get createPasswordHintQuestionHint =>
      'Scegli una domanda di sicurezza';

  @override
  String get createPasswordHintAnswerHint => 'La tua risposta';

  @override
  String get createPasswordCancelButton => 'Annulla';

  @override
  String get createPasswordSaveButton => 'Salva';

  @override
  String get passwordMismatchMessage => 'Le password non coincidono!';

  @override
  String get passwordRequiredDialogTitle => 'Password richiesta';

  @override
  String get passwordRequiredHint => 'Inserisci password';

  @override
  String get forgotPasswordButtonLabel => 'Ho dimenticato la password';

  @override
  String get passwordRequiredCancelButton => 'Annulla';

  @override
  String get passwordRequiredConfirmButton => 'Verifica';

  @override
  String get securityQuestionDialogTitle => 'Domanda di sicurezza';

  @override
  String get securityQuestionAnswerHint => 'La tua risposta';

  @override
  String get securityQuestionCancelButton => 'Annulla';

  @override
  String get securityQuestionConfirmButton => 'Conferma';

  @override
  String get securityQuestionWrongAnswerMessage => 'Risposta errata. Riprova.';

  @override
  String get revealedPasswordDialogTitle => 'La tua password';

  @override
  String get revealedPasswordLabel => 'La password della tua nota:';

  @override
  String get revealedPasswordOkButton => 'OK';

  @override
  String get securityQuestionPetName =>
      'Qual è il nome del tuo primo animale domestico?';

  @override
  String get securityQuestionFavoriteTeacher =>
      'Qual è il nome del tuo insegnante preferito?';

  @override
  String get securityQuestionBirthCity => 'In quale città sei nato/a?';

  @override
  String get securityQuestionFavoriteFood => 'Qual è il tuo cibo preferito?';

  @override
  String get securityQuestionMotherMaidenName =>
      'Qual è il cognome da nubile di tua madre?';

  @override
  String get securityQuestionFirstSchool =>
      'Qual è il nome della prima scuola che hai frequentato?';

  @override
  String get securityQuestionFavoriteColor => 'Qual è il tuo colore preferito?';

  @override
  String get editFolderDialogTitle => 'Modifica cartella';

  @override
  String get newSubfolderDialogTitle => 'Nuova sottocartella';

  @override
  String get addFolderDialogTitle => 'Aggiungi cartella';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'Verrà creata all\'interno di \"$parentCategory\"';
  }

  @override
  String get subfolderNameFieldLabel => 'Nome sottocartella';

  @override
  String get folderNameFieldLabel => 'Nome cartella';

  @override
  String get folderColorLabel => 'Colore';

  @override
  String get folderDialogCancelButton => 'Annulla';

  @override
  String get folderDialogSaveButton => 'Salva';

  @override
  String get folderDialogAddButton => 'Aggiungi';

  @override
  String get selectFolderSheetTitle => 'Seleziona cartella';

  @override
  String get selectFolderAddOptionLabel => 'Aggiungi cartella';

  @override
  String get removeCurrentFolderLabel => 'Rimuovi cartella attuale';

  @override
  String get noteDetailsDialogTitle => 'Dettagli';

  @override
  String get noteDetailsCreatedLabel => 'Creata';

  @override
  String get noteDetailsModifiedLabel => 'Ultima modifica';

  @override
  String get noteDetailsCharCountLabel => 'Numero di caratteri';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count caratteri';
  }

  @override
  String get noteDetailsWordCountLabel => 'Numero di parole';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count parole';
  }

  @override
  String get noteDetailsOkButton => 'OK';

  @override
  String get noteDetailsUnknownDateLabel => 'Sconosciuta';

  @override
  String get addAttachmentSheetTitle => 'Aggiungi';

  @override
  String get addAttachmentImageOption => 'Aggiungi immagine';

  @override
  String get addAttachmentCameraOption => 'Fotocamera';

  @override
  String get addAttachmentFileOption => 'Aggiungi file';

  @override
  String get addAttachmentVoiceOption => 'Registrazione vocale';

  @override
  String get addAttachmentVideoOption => 'Registra video';

  @override
  String get addAttachmentScanOption => 'Scansiona documento';

  @override
  String get noteActionsSheetTitle => 'Scegli un\'azione';

  @override
  String get noteActionReminderLabel => 'Promemoria';

  @override
  String get noteActionEditReminderLabel => 'Modifica promemoria';

  @override
  String get noteActionSpeechToTextLabel => 'Voce in testo';

  @override
  String get noteActionArchiveLabel => 'Archivia';

  @override
  String get noteActionUnarchiveLabel => 'Rimuovi dall\'archivio';

  @override
  String get noteActionLockLabel => 'Blocca';

  @override
  String get noteActionUnlockLabel => 'Sblocca';

  @override
  String get noteActionFavoriteLabel => 'Preferiti';

  @override
  String get noteActionUnfavoriteLabel => 'Rimuovi dai preferiti';

  @override
  String get noteActionClassifyLabel => 'Seleziona cartella';

  @override
  String get noteActionDeleteLabel => 'Elimina';

  @override
  String get noteActionPinToNotificationLabel =>
      'Fissa al pannello delle notifiche';

  @override
  String get noteActionUnpinFromNotificationLabel => 'Rimuovi fissaggio';

  @override
  String get noteActionShareLabel => 'Condividi';

  @override
  String get noteActionDuplicateLabel => 'Crea copia';

  @override
  String get noteActionCopyContentLabel => 'Copia contenuto';

  @override
  String get noteActionTtsLabel => 'Leggi ad alta voce';

  @override
  String get noteActionTextSizeLabel => 'Dimensione testo';

  @override
  String get noteActionDetailsLabel => 'Dettagli';

  @override
  String get noteActionDiscardChangesLabel => 'Annulla modifiche';

  @override
  String get noteActionSelectLabel => 'Seleziona';

  @override
  String get reminderEditOptionLabel => 'Cambia promemoria';

  @override
  String get reminderRemoveOptionLabel => 'Rimuovi promemoria';

  @override
  String get discardChangesDialogTitle => 'Annulla modifiche';

  @override
  String get discardChangesDialogMessage =>
      'Le modifiche non salvate a questa nota andranno perse. Sei sicuro di volerle annullare?';

  @override
  String get discardChangesCancelButton => 'Annulla';

  @override
  String get discardChangesConfirmButton => 'Annulla modifiche';

  @override
  String get pinnedNotificationDefaultTitle => 'Nota';

  @override
  String get pdfFailedInfoMessage => 'Impossibile creare il PDF';

  @override
  String get drawingScreenTitle => 'Disegno';

  @override
  String get drawingMinimizeTooltip => 'Riduci a icona';

  @override
  String get drawingEmptyExportWarningMessage => 'Disegna prima qualcosa';

  @override
  String get drawingEraserPartialModeLabel => 'Parziale';

  @override
  String get drawingEraserFullModeLabel => 'Completo';

  @override
  String get drawingClearTooltip => 'Cancella';

  @override
  String get drawingZoomOutTooltip => 'Riduci zoom';

  @override
  String get drawingZoomInTooltip => 'Aumenta zoom';

  @override
  String get drawingDeleteTooltip => 'Elimina';

  @override
  String get drawingEmptyPreviewHint => 'Tocca per disegnare';

  @override
  String get settingsPageTitle => 'Impostazioni';

  @override
  String get settingsSectionGeneral => 'Generale';

  @override
  String get settingsSectionSecurity => 'Sicurezza';

  @override
  String get settingsSectionTheme => 'Tema';

  @override
  String get settingsSectionPersonalization => 'Personalizzazione';

  @override
  String get settingsSectionWidget => 'Widget';

  @override
  String get settingsSectionAbout => 'Informazioni';

  @override
  String get settingsHintQuestionPet =>
      'Qual è il nome del tuo primo animale domestico?';

  @override
  String get settingsHintQuestionTeacher =>
      'Qual è il nome del tuo insegnante preferito?';

  @override
  String get settingsHintQuestionBirthCity => 'In quale città sei nato/a?';

  @override
  String get settingsHintQuestionFavoriteFood =>
      'Qual è il tuo cibo preferito?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'Qual è il cognome da nubile di tua madre?';

  @override
  String get settingsHintQuestionFirstSchool =>
      'Qual è stata la prima scuola che hai frequentato?';

  @override
  String get settingsHintQuestionFavoriteColor =>
      'Qual è il tuo colore preferito?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'Domanda di sicurezza';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'Se dimentichi la password, potrai recuperarla rispondendo correttamente a questa domanda.';

  @override
  String get settingsSecurityQuestionDropdownHint =>
      'Scegli una domanda di sicurezza';

  @override
  String get settingsSecurityQuestionAnswerHint => 'La tua risposta';

  @override
  String get settingsSecurityQuestionCancelButton => 'Annulla';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'Domanda e risposta non possono essere vuote!';

  @override
  String get settingsSecurityQuestionSaveButton => 'Salva';

  @override
  String get settingsCreatePasswordTitle => 'Crea password';

  @override
  String get settingsPasswordRequiredTitle => 'Password richiesta';

  @override
  String get settingsPasswordEnterHint => 'Inserisci password';

  @override
  String get settingsForgotPasswordButton => 'Ho dimenticato la password';

  @override
  String get settingsNewPasswordHint => 'Nuova password';

  @override
  String get settingsConfirmPasswordHint => 'Reinserisci password';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'Imposta una domanda di sicurezza nel caso dimentichi la password (facoltativo).';

  @override
  String get settingsPasswordDialogCancelButton => 'Annulla';

  @override
  String get settingsPasswordMismatchWarning => 'Le password non coincidono!';

  @override
  String get settingsWrongPasswordWarning => 'Password errata!';

  @override
  String get settingsPasswordSaveButton => 'Salva';

  @override
  String get settingsPasswordRemoveButton => 'Rimuovi';

  @override
  String get settingsNotePasswordTitle => 'Password della nota';

  @override
  String get settingsPasswordSetSubtitle => 'Password impostata ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'Password non impostata';

  @override
  String get settingsSecurityQuestionTileTitle => 'Domanda di sicurezza';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'Impostata ✓ — usata se dimentichi la password';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'Non impostata — non potrai recuperare la password se la perdi';

  @override
  String get settingsThemeDialogTitle => 'Seleziona tema';

  @override
  String get settingsThemeSystemDefault => 'Predefinito di sistema';

  @override
  String get settingsThemeLightOption => 'Tema chiaro';

  @override
  String get settingsThemeDarkOption => 'Tema scuro';

  @override
  String get settingsLanguageDialogTitle => 'Seleziona lingua';

  @override
  String get settingsLanguageSystemOption => 'Sistema';

  @override
  String get settingsAccentColorDialogTitle => 'Scegli colore d\'accento';

  @override
  String get settingsThemeChangeTileTitle => 'Cambia tema';

  @override
  String get settingsThemeLightLabel => 'Chiaro';

  @override
  String get settingsThemeDarkLabel => 'Scuro';

  @override
  String get settingsThemeSystemLabel => 'Sistema';

  @override
  String get settingsLanguageTileTitle => 'Lingua';

  @override
  String get settingsAccentColorTileTitle => 'Colore d\'accento';

  @override
  String get settingsAccentColorTileSubtitle =>
      'Colore usato nella barra dell\'app, nei pulsanti e negli interruttori';

  @override
  String get settingsColorfulNotesTitle => 'Colori vari per le note';

  @override
  String get settingsColorfulNotesSubtitle =>
      'Ogni scheda nota ottiene una tonalità di colore diversa.';

  @override
  String get settingsTextColorSheetTitle => 'Colore testo';

  @override
  String get settingsTextColorSheetDesc =>
      'Imposta il colore del testo del contenuto della nota.';

  @override
  String get settingsTextColorOkButton => 'OK';

  @override
  String get settingsTextColorTileTitle => 'Colore testo';

  @override
  String get settingsTextColorTileSubtitle =>
      'Colore per il testo del contenuto della nota.';

  @override
  String get settingsWidgetFontSizeLabel => 'Dimensione carattere widget';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'Titolo di esempio - $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'Annulla';

  @override
  String get settingsWidgetFontSizeApplyButton => 'Applica';

  @override
  String get settingsWidgetOpacityLabel => 'Trasparenza sfondo';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return '$percent% di trasparenza';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'Annulla';

  @override
  String get settingsWidgetOpacityApplyButton => 'Applica';

  @override
  String get settingsWidgetDarkModeTitle => 'Widget scuro';

  @override
  String get settingsWidgetDarkModeDesc =>
      'Schema di colori scuro per il widget.';

  @override
  String get settingsAboutVersionTitle => 'Versione app';

  @override
  String get settingsAboutVersionLoading => 'Caricamento versione…';

  @override
  String get aboutSectionDeveloper => 'Sviluppatore';

  @override
  String get aboutDeveloperTitle => 'Sviluppatore';

  @override
  String get aboutContactTitle => 'Contatto';

  @override
  String get aboutWebsiteTitle => 'Sito web';

  @override
  String get aboutGithubTitle => 'GitHub';

  @override
  String get aboutSectionLegal => 'Informazioni legali';

  @override
  String get aboutPrivacyPolicyTitle => 'Informativa sulla privacy';

  @override
  String get aboutTermsTitle => 'Termini di utilizzo';

  @override
  String get aboutLicensesTitle => 'Licenze open source';

  @override
  String get aboutSectionSupport => 'Supporto';

  @override
  String get aboutRateAppTitle => 'Valuta l\'app';

  @override
  String get aboutLinkOpenError => 'Impossibile aprire il link.';

  @override
  String get settingsFontFamilyTileTitle => 'Carattere';

  @override
  String get settingsFontFamilyDefaultLabel => 'Predefinito';

  @override
  String get settingsGlobalFontSizeTileTitle => 'Dimensione carattere';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt — applicato a tutte le note.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'Testo di esempio - $size pt';
  }

  @override
  String get settingsGlobalFontSizeApplyToAllLabel =>
      'Applica alle note esistenti';

  @override
  String get settingsGlobalFontSizeApplyToAllNote =>
      'Se una nota ha una dimensione del carattere impostata individualmente, questa impostazione non la influenzerà.';

  @override
  String get settingsGlobalFontSizeCancelButton => 'Annulla';

  @override
  String get settingsGlobalFontSizeApplyButton => 'Applica';

  @override
  String get settingsPreviewLinesTileTitle => 'Righe di anteprima nota';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'Mostra fino a $lines righe. Se la nota è più corta, viene mostrato il numero effettivo di righe.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'Attuale: $lines righe';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'Imposta il numero massimo di righe da visualizzare in anteprima. Se la nota ha meno righe, viene mostrato il numero effettivo di righe.';

  @override
  String get settingsPreviewLinesCancelButton => 'Annulla';

  @override
  String get settingsPreviewLinesApplyButton => 'Applica';

  @override
  String get backupCancelButton => 'Annulla';

  @override
  String get backupConnectButton => 'Connetti';

  @override
  String get backupDisconnectButton => 'Disconnetti';

  @override
  String get backupContinueButton => 'Continua';

  @override
  String get backupCloseButton => 'Chiudi';

  @override
  String get backupShareButton => 'Condividi';

  @override
  String get backupRestoreButton => 'Ripristina';

  @override
  String get backupConfigureButton => 'Configura';

  @override
  String get backupUnknownDateLabel => 'Sconosciuta';

  @override
  String get backupProcessingDefaultLabel => 'Elaborazione...';

  @override
  String get backupPermissionRequiredTitle =>
      'Permesso di archiviazione richiesto';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'Questa versione di Android richiede il permesso di archiviazione per backup/ripristino. Poiché il permesso è stato negato definitivamente, abilitalo manualmente dalle impostazioni dell\'app.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'Questa versione di Android richiede il permesso di archiviazione per backup/ripristino. Concedi il permesso per continuare.';

  @override
  String get backupGoToSettingsButton => 'Vai alle impostazioni';

  @override
  String get backupRetryButton => 'Riprova';

  @override
  String get backupDriveConnectingLabel => 'Connessione all\'account Google...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Connesso all\'account Google Drive: $email';
  }

  @override
  String get backupDriveConnectedMessage =>
      'Connesso all\'account Google Drive.';

  @override
  String get backupDriveConnectFailedMessage =>
      'Impossibile connettersi all\'account Google, oppure l\'operazione è stata annullata.';

  @override
  String get backupDriveDisconnectTitle => 'Disconnetti Google Drive';

  @override
  String get backupDriveDisconnectBody =>
      'Se ti disconnetti, non sarà possibile eseguire backup manuali o automatici su Drive. I backup già archiviati su Drive non verranno eliminati — verrà rimosso solo l\'accesso da questo dispositivo.';

  @override
  String get backupDriveDisconnectedMessage =>
      'Connessione a Google Drive rimossa.';

  @override
  String get backupDriveRequiredTitle => 'Account Google richiesto';

  @override
  String get backupDriveRequiredBody =>
      'Questa azione richiede la connessione del tuo account Google. Vuoi connetterti ora?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: connesso ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: connesso';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: non connesso';

  @override
  String get backupDriveAuthenticatingLabel =>
      'Verifica dell\'account Google...';

  @override
  String get backupDriveNotSignedInMessage =>
      'Non sei connesso a Google Drive. Accedi prima con il tuo account Google.';

  @override
  String get backupDriveUploadingLabel => 'Caricamento del backup su Drive...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Il caricamento su Google Drive non si è completato entro 120 secondi (nessuna risposta dal server). Controlla la connessione e riprova.';

  @override
  String get backupDriveOperationCompletedLabel => 'Completato';

  @override
  String get backupToDriveActionLabel => 'backup su Drive';

  @override
  String get backupToDeviceActionLabel => 'backup';

  @override
  String get backupCreatingLabel => 'Creazione del backup...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'Impossibile creare il backup: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Caricamento su Google Drive non riuscito: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'Backup caricato con successo su Google Drive.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'Backup creato: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'Backup pronto';

  @override
  String get backupOfferShareBody =>
      'Il file di backup è stato salvato sul tuo dispositivo. Vuoi condividerlo ora (ad es. archiviazione cloud, email, un altro dispositivo)?';

  @override
  String get backupShareFileText => 'file di backup di layout';

  @override
  String backupShareFailedMessage(String error) {
    return 'Impossibile avviare la condivisione: $error';
  }

  @override
  String get backupLargeOperationTitle => 'Backup di grandi dimensioni';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'I dati da elaborare sono di circa $sizeText. Un $actionLabel di queste dimensioni potrebbe richiedere del tempo a seconda del tuo dispositivo. Non uscire dall\'app mentre è in corso — vuoi continuare?';
  }

  @override
  String get backupRestoreActionLabel => 'ripristino';

  @override
  String get backupDriveListingLabel => 'Elenco dei backup su Drive...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'Impossibile elencare i backup: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'Non ci sono ancora backup su Google Drive.';

  @override
  String get backupDrivePickTitle => 'Scegli un backup da Drive';

  @override
  String get backupDriveDownloadingLabel => 'Download del backup da Drive...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Download del backup da Drive... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel =>
      'Salvataggio del file sul dispositivo...';

  @override
  String get backupDriveUnknownBackupFileName => 'backup_sconosciuto.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Lo spazio di archiviazione di Google Drive è pieno. Libera spazio su Drive e riprova.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'Impossibile stabilire una connessione Internet. Controlla la connessione e riprova.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'Il file di backup specificato non è stato trovato su Drive. Potrebbe essere stato eliminato.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Si è verificato un errore imprevisto durante l\'operazione di Google Drive: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'Download non riuscito: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'Impossibile selezionare il file: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'Impossibile accedere al file selezionato.';

  @override
  String get backupCheckingLabel => 'Controllo del backup...';

  @override
  String backupReadFailedMessage(String error) {
    return 'Impossibile leggere il file di backup: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'Ripristina backup';

  @override
  String get backupPreviewContentsHeader => 'Contenuto del backup selezionato:';

  @override
  String get backupPreviewNoteCountLabel => 'Numero di note';

  @override
  String get backupPreviewTrashCountLabel => 'Note nel cestino';

  @override
  String get backupPreviewCategoryCountLabel => 'Numero di categorie';

  @override
  String get backupPreviewAttachmentLabel => 'Allegati';

  @override
  String get backupPreviewAttachmentNoneValue => 'Nessuno';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count file ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'Creato il';

  @override
  String get backupEmptyPreviewTitle => 'Questo backup sembra vuoto';

  @override
  String get backupEmptyPreviewBody =>
      'Non sono state trovate note, categorie o allegati nel file selezionato. Se continui, i tuoi dati attuali verranno comunque eliminati e sostituiti con questo backup vuoto.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '$count allegati non trovati nel backup';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'Le note con questi file verranno ripristinate, ma senza gli allegati (potrebbero essere mancanti o danneggiati al momento della creazione del backup): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown e altri $remaining';
  }

  @override
  String get backupRestoreConfirmBody =>
      'Questo SOSTITUIRÀ tutte le tue note attuali, il cestino, le categorie, le impostazioni e gli allegati con i dati del backup sopra indicato. I tuoi dati attuali andranno persi definitivamente e questa azione non può essere annullata.';

  @override
  String get backupRestoringLabel => 'Ripristino del backup...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'Backup ripristinato. Tuttavia, $count allegati non sono stati trovati nel backup e non è stato possibile ripristinarli. Si consiglia di riavviare l\'app affinché le modifiche abbiano pieno effetto.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'Backup ripristinato con successo. Si consiglia di riavviare l\'app affinché le modifiche abbiano pieno effetto.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'Si è verificato un errore durante il ripristino: $error';
  }

  @override
  String get backupScreenTitle => 'Backup e ripristino';

  @override
  String get backupBlockedExitWarningMessage =>
      'Un\'operazione è in corso, attendi il suo completamento.';

  @override
  String get backupBusyBackTooltip => 'Operazione in corso';

  @override
  String get backupIntroText =>
      'Puoi eseguire il backup di note, categorie, impostazioni e allegati come un unico file .zip, oppure ripristinare un backup effettuato in precedenza.';

  @override
  String get backupDriveCardTitle => 'Esegui backup su Google Drive';

  @override
  String get backupDriveCardSubtitle =>
      'Crea un nuovo backup e caricalo direttamente nell\'area privata del tuo Google Drive.';

  @override
  String get backupDriveCardButtonLabel => 'Backup su Drive';

  @override
  String get backupDeviceCardTitle => 'Esegui backup sul dispositivo';

  @override
  String get backupDeviceCardSubtitle =>
      'Salva tutti i tuoi dati come un unico file .zip sul dispositivo e condividilo se lo desideri.';

  @override
  String get backupDeviceCardButtonLabel => 'Backup sul dispositivo';

  @override
  String get backupHistoryCardTitle => 'Cronologia backup';

  @override
  String get backupHistoryCardSubtitle =>
      'Visualizza tutti i backup archiviati sul tuo dispositivo con data e dimensione; puoi condividerli, ripristinarli o eliminarli direttamente da qui.';

  @override
  String get backupHistoryTabDevice => 'Dispositivo';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'Elimina backup';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'Sei sicuro di voler eliminare definitivamente il file di backup \"$fileName\"? Questa azione non può essere annullata.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'Backup eliminato.';

  @override
  String get backupHistoryDriveDeleteDialogTitle => 'Elimina backup da Drive';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'Sei sicuro di voler eliminare definitivamente il backup \"$fileName\" da Google Drive? Questa azione non può essere annullata e il file non verrà spostato nel cestino.';
  }

  @override
  String get backupHistoryDriveDeletedMessage => 'Backup su Drive eliminato.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'Impossibile eliminare: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'Nessun backup ancora salvato su questo dispositivo.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'Usa \"Backup sul dispositivo\" per creare il tuo primo backup.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'Usa \"Backup su Google Drive\" per creare il tuo primo backup cloud.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Connetti il tuo account Google per vedere i backup su Drive.';

  @override
  String get backupHistoryConnectGoogleButton => 'Connetti con Google';

  @override
  String get backupHistoryDriveConnectedFallback => 'Connesso';

  @override
  String get backupHistoryUnknownErrorFallback =>
      'Si è verificato un errore sconosciuto.';

  @override
  String get backupHistoryDownloadStartingLabel => 'Avvio...';

  @override
  String get backupAutoBackupEnabledLabel => 'Backup automatico: attivo';

  @override
  String get backupAutoBackupDisabledLabel => 'Backup automatico: disattivato';

  @override
  String get backupOverlayWarningMessage =>
      'Attendi, non uscire dall\'app finché l\'operazione non è completata.';

  @override
  String get pdfExportUntitledNoteLabel => 'Nota senza titolo';

  @override
  String get pdfExportDefaultAttachmentName => 'Allegato';

  @override
  String get pdfExportDefaultFileName => 'nota';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'Impossibile acquisire lo screenshot (limite non trovato)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'Impossibile generare i dati dello screenshot';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'Impossibile elaborare l\'immagine (decodifica PNG non riuscita)';

  @override
  String get screenshotCalcTableTotalLabel => 'Totale';

  @override
  String get gundemMenuRemoveFromAgenda => 'Rimuovi dall\'agenda';

  @override
  String get gundemMenuDeleteNote => 'Elimina nota';

  @override
  String get gundemSectionOverdue => 'In ritardo';

  @override
  String get gundemSectionToday => 'Oggi';

  @override
  String get gundemSectionTomorrow => 'Domani';

  @override
  String get gundemSectionNextWeek => 'Prossima settimana';

  @override
  String get gundemSectionFurther => 'Più avanti';

  @override
  String get gundemWeekdayMonday => 'Lunedì';

  @override
  String get gundemWeekdayTuesday => 'Martedì';

  @override
  String get gundemWeekdayWednesday => 'Mercoledì';

  @override
  String get gundemWeekdayThursday => 'Giovedì';

  @override
  String get gundemWeekdayFriday => 'Venerdì';

  @override
  String get gundemWeekdaySaturday => 'Sabato';

  @override
  String get gundemWeekdaySunday => 'Domenica';

  @override
  String get gundemAppBarTitle => 'Agenda';

  @override
  String get gundemCalendarTooltip => 'Calendario';

  @override
  String get gundemEmptyTitle => 'Nessun elemento in agenda';

  @override
  String get gundemEmptySubtitle =>
      'Le note con un promemoria o una data assegnata appariranno qui.';

  @override
  String get gundemUntitledNote => 'Nota senza titolo';

  @override
  String get gundemRepeatHourly => 'Ogni ora';

  @override
  String get gundemRepeatDaily => 'Ogni giorno';

  @override
  String get gundemRepeatWeekly => 'Ogni settimana';

  @override
  String get gundemRepeatMonthly => 'Ogni mese';

  @override
  String get gundemRepeatYearly => 'Ogni anno';

  @override
  String get gundemPreviewCalcTableLabel => '[Lista di calcolo]';

  @override
  String get gundemPreviewDrawingLabel => '[Disegno]';

  @override
  String get gundemPreviewImageLabel => '[Immagine]';

  @override
  String get gundemMonthShortJan => 'Gen';

  @override
  String get gundemMonthShortFeb => 'Feb';

  @override
  String get gundemMonthShortMar => 'Mar';

  @override
  String get gundemMonthShortApr => 'Apr';

  @override
  String get gundemMonthShortMay => 'Mag';

  @override
  String get gundemMonthShortJun => 'Giu';

  @override
  String get gundemMonthShortJul => 'Lug';

  @override
  String get gundemMonthShortAug => 'Ago';

  @override
  String get gundemMonthShortSep => 'Set';

  @override
  String get gundemMonthShortOct => 'Ott';

  @override
  String get gundemMonthShortNov => 'Nov';

  @override
  String get gundemMonthShortDec => 'Dic';

  @override
  String get calendarAppBarTitle => 'Calendario';

  @override
  String get calendarTodayButton => 'Oggi';

  @override
  String get calendarLegendNoteLabel => 'Nota';

  @override
  String get calendarLegendReminderLabel => 'Promemoria';

  @override
  String get calendarTodayBadge => 'Oggi';

  @override
  String get calendarEmptyDayMessage =>
      'Nessuna nota o promemoria per questo giorno.';

  @override
  String get calendarReminderHourlyLabel => 'Ogni ora';

  @override
  String get calendarMonthJan => 'Gennaio';

  @override
  String get calendarMonthFeb => 'Febbraio';

  @override
  String get calendarMonthMar => 'Marzo';

  @override
  String get calendarMonthApr => 'Aprile';

  @override
  String get calendarMonthMay => 'Maggio';

  @override
  String get calendarMonthJun => 'Giugno';

  @override
  String get calendarMonthJul => 'Luglio';

  @override
  String get calendarMonthAug => 'Agosto';

  @override
  String get calendarMonthSep => 'Settembre';

  @override
  String get calendarMonthOct => 'Ottobre';

  @override
  String get calendarMonthNov => 'Novembre';

  @override
  String get calendarMonthDec => 'Dicembre';

  @override
  String get calendarWeekdayShortMon => 'Lun';

  @override
  String get calendarWeekdayShortTue => 'Mar';

  @override
  String get calendarWeekdayShortWed => 'Mer';

  @override
  String get calendarWeekdayShortThu => 'Gio';

  @override
  String get calendarWeekdayShortFri => 'Ven';

  @override
  String get calendarWeekdayShortSat => 'Sab';

  @override
  String get calendarWeekdayShortSun => 'Dom';

  @override
  String get calendarWeekdayFullMonday => 'Lunedì';

  @override
  String get calendarWeekdayFullTuesday => 'Martedì';

  @override
  String get calendarWeekdayFullWednesday => 'Mercoledì';

  @override
  String get calendarWeekdayFullThursday => 'Giovedì';

  @override
  String get calendarWeekdayFullFriday => 'Venerdì';

  @override
  String get calendarWeekdayFullSaturday => 'Sabato';

  @override
  String get calendarWeekdayFullSunday => 'Domenica';

  @override
  String get wrongPasswordDialogTitle => 'Password errata';

  @override
  String get wrongPasswordDialogMessage =>
      'La password inserita non è corretta.';

  @override
  String get commonOkButton => 'OK';

  @override
  String get unlockCategoryAction => 'Sblocca';

  @override
  String get lockCategoryAction => 'Blocca';

  @override
  String get categoryUnlockedMessage => 'Sbloccata';

  @override
  String get categoryLockedMessage => 'Cartella bloccata';

  @override
  String get deleteFolderMenuItemLabel => 'Elimina cartella';

  @override
  String get deleteFolderDialogTitle => 'Elimina cartella';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'Sei sicuro di voler eliminare la cartella \"$category\" e tutte le sue sottocartelle? Le note in queste cartelle diventeranno non categorizzate.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'Sei sicuro di voler eliminare la cartella \"$category\"? Le note in questa cartella diventeranno non categorizzate.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'Annulla';

  @override
  String get deleteFolderDialogConfirmButton => 'Elimina';

  @override
  String get editCategoryNameColorMenuItemLabel => 'Modifica nome / colore';

  @override
  String get addSubfolderMenuItemLabel => 'Crea sottocartella';

  @override
  String get expandSubfoldersMenuItemLabel => 'Espandi sottocartelle';

  @override
  String get collapseSubfoldersMenuItemLabel => 'Comprimi sottocartelle';

  @override
  String saveErrorInfoMessage(String error) {
    return 'Errore di salvataggio: $error';
  }

  @override
  String get welcomeNoteTitle => 'Benvenuto su Layout! 🚀';

  @override
  String get welcomeNoteContent => 'Nuove funzionalità aggiunte!';

  @override
  String get noteListDateGroupToday => 'Oggi';

  @override
  String get noteListDateGroupYesterday => 'Ieri';

  @override
  String get noteListDateGroupLast7Days => 'Ultimi 7 giorni';

  @override
  String get noteListDateGroupLast30Days => 'Ultimi 30 giorni';

  @override
  String get reminderRepeatNoneLabel => 'Nessuna ripetizione';

  @override
  String get voiceRecorderPreparingLabel => 'Preparazione…';

  @override
  String get voiceRecorderCancelButton => 'Annulla';

  @override
  String get voiceRecorderStopAddButton => 'Interrompi e aggiungi';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'Il permesso del microfono non è stato concesso.';

  @override
  String get speechToTextUnavailableMessage =>
      'Il riconoscimento vocale non è disponibile su questo dispositivo.';

  @override
  String get speechToTextPreparingLabel => 'Preparazione…';

  @override
  String get speechToTextListeningLabel => 'In ascolto…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'Inizia a parlare…';

  @override
  String get speechToTextCancelButton => 'Annulla';

  @override
  String get speechToTextStopAddButton => 'Interrompi e aggiungi';

  @override
  String get textToSpeechNoContentMessage =>
      'Non c\'è alcun contenuto da leggere.';

  @override
  String get textToSpeechReadErrorMessage =>
      'Si è verificato un errore durante la lettura.';

  @override
  String get textToSpeechUnavailableMessage =>
      'La sintesi vocale non è disponibile su questo dispositivo.';

  @override
  String get textToSpeechPreparingLabel => 'Preparazione…';

  @override
  String get textToSpeechPausedLabel => 'In pausa';

  @override
  String get textToSpeechFinishedLabel => 'Lettura completata';

  @override
  String get textToSpeechReadingLabel => 'Lettura in corso…';

  @override
  String get textToSpeechCloseErrorButton => 'Chiudi';

  @override
  String get textToSpeechReplayButton => 'Leggi di nuovo';

  @override
  String get textToSpeechCloseFinishedButton => 'Chiudi';

  @override
  String get textToSpeechPauseButton => 'Pausa';

  @override
  String get textToSpeechResumeButton => 'Riprendi';

  @override
  String get textToSpeechStopButton => 'Interrompi';

  @override
  String get textToSpeechSpeedSlow => 'Lenta';

  @override
  String get textToSpeechSpeedNormal => 'Normale';

  @override
  String get textToSpeechSpeedFast => 'Veloce';

  @override
  String get calendarPickerCancelButton => 'Annulla';

  @override
  String get calendarPickerConfirmButton => 'Seleziona';

  @override
  String get calendarPickerClearButton => 'Cancella';

  @override
  String get reminderPickerDialogTitle => 'Aggiungi promemoria';

  @override
  String get reminderPickerDateTodayOption => 'Oggi';

  @override
  String get reminderPickerDateTomorrowOption => 'Domani';

  @override
  String get reminderPickerDatePickOption => 'Scegli data';

  @override
  String get reminderRepeatHourlyLabel => 'Ogni ora';

  @override
  String get reminderRepeatDailyLabel => 'Ogni giorno';

  @override
  String get reminderRepeatWeeklyLabel => 'Ogni settimana';

  @override
  String get reminderRepeatMonthlyLabel => 'Ogni mese';

  @override
  String get reminderRepeatYearlyLabel => 'Ogni anno';

  @override
  String get reminderPickerCalendarHelpText =>
      'Seleziona la data del promemoria';

  @override
  String get reminderPickerCancelButton => 'ANNULLA';

  @override
  String get reminderPickerSaveButton => 'SALVA';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'Non è possibile selezionare un orario passato';

  @override
  String calcTableTotalLabel(String amount) {
    return 'Totale: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'Preparazione dei dati...';

  @override
  String get backupCreatePackagingNotesLabel =>
      'Impacchettamento di note e categorie...';

  @override
  String get backupCreateReadingAttachmentsLabel => 'Lettura degli allegati...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'Lettura degli allegati... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'Compressione del file zip...';

  @override
  String get backupCreateSavingFileLabel => 'Salvataggio del file...';

  @override
  String get backupRestoreValidatingLabel => 'Convalida del backup...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'Backup convalidato, preparazione dei dati...';

  @override
  String get backupRestoreWritingNotesLabel => 'Scrittura delle note...';

  @override
  String get backupRestoreWritingTrashLabel => 'Scrittura del cestino...';

  @override
  String get backupRestoreTrashWrittenLabel => 'Cestino scritto';

  @override
  String get backupRestoreWritingCategoriesLabel =>
      'Scrittura delle categorie...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'Categorie scritte';

  @override
  String get backupRestoreWritingSettingsLabel =>
      'Scrittura delle impostazioni...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'Impostazioni scritte';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'Pulizia dei vecchi allegati...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'Nessun allegato trovato, completamento...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'Ripristino degli allegati... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'Completato';

  @override
  String get backupValidationCorruptedFileMessage =>
      'Il file è danneggiato o non è un file di backup valido.';

  @override
  String get backupValidationMissingDataMessage =>
      'Nessun dato trovato all\'interno del file di backup (backup_data.json mancante).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'Impossibile leggere i dati di backup (JSON danneggiato).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'Questo file non è un backup dell\'app layout.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'Impossibile leggere le informazioni sulla versione del file di backup.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'Questo backup è in un formato più recente non supportato dalla versione attuale dell\'app. Aggiorna l\'app.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'Le informazioni sulla versione del file di backup non sono valide.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'I dati di backup non sono nel formato previsto (campo note mancante).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'I dati di backup non sono nel formato previsto (campo cestino mancante).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'I dati di backup non sono nel formato previsto (elenco categorie non valido).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'I dati di backup non sono nel formato previsto (campo impostazioni non valido).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'I dati di backup non sono nel formato previsto (un record di nota non è valido).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'I dati di backup non sono nel formato previsto (è stato trovato un record di nota senza ID).';

  @override
  String get backupValidationFileNotFoundMessage =>
      'File di backup non trovato.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'Spazio di archiviazione insufficiente sul dispositivo. Libera spazio e riprova.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'Il permesso di accesso ai file è stato negato. Controlla i permessi dell\'app e riprova.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'Si è verificato un errore durante l\'operazione sul file: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'Si è verificato un errore imprevisto: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'Impossibile creare l\'archivio zip (ZipEncoder ha restituito null).';

  @override
  String get calcTableMenuItemLabel => 'Lista di calcolo';

  @override
  String get tagsMenuItemLabel => 'Tag';

  @override
  String get linkDialogUrlHint => 'https://example.com';

  @override
  String get checklistItemHint => 'Aggiungi elemento...';

  @override
  String get toolbarHighlightTooltip => 'Evidenzia';

  @override
  String get toolbarListTooltip => 'Elenco';

  @override
  String get toolbarHideKeyboardTooltip => 'Nascondi tastiera';

  @override
  String get autoBackupLocalSuccessMessage => 'Backup locale riuscito.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'Backup locale non riuscito: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Backup su Drive saltato: l\'account Google non è connesso o la sessione è scaduta. Apri l\'app e riconnettiti.';

  @override
  String get autoBackupDriveSuccessMessage => 'Backup su Drive riuscito.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Backup su Drive non riuscito: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'Nessuna nota ancora';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'Totale: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ Disegno';

  @override
  String get autoBackupSettingsAppBarTitle => 'Impostazioni backup automatico';

  @override
  String get autoBackupSettingsMainSwitchTitle => 'Abilita backup automatico';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'Le tue note vengono sottoposte a backup periodico e sicuro in background.';

  @override
  String get autoBackupSettingsTargetTitle => 'Destinazione backup';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'Scegli dove salvare i backup.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'Locale';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'Entrambi';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Connetti prima il tuo account per usare le opzioni di Google Drive.';

  @override
  String get autoBackupSettingsConnectButton => 'Connetti';

  @override
  String get autoBackupSettingsFrequencyTitle => 'Frequenza backup';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'Viene eseguito un backup ogni $hours ore.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 ore';

  @override
  String get autoBackupSettingsFrequency12h => '12 ore';

  @override
  String get autoBackupSettingsFrequency24h => '24 ore (giornaliero)';

  @override
  String get autoBackupSettingsFrequency48h => '48 ore (2 giorni)';

  @override
  String get autoBackupSettingsFrequency168h => '168 ore (settimanale)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Usa solo Wi-Fi';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'Il caricamento sul cloud avviene solo tramite Wi-Fi per proteggere i tuoi dati mobili.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'Stato del sistema';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'Il backup automatico non è ancora stato eseguito.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'Ultima esecuzione: $date $time ($status)\nMessaggio: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'Riuscito';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'Non riuscito';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Impossibile connettersi all\'account Google.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'Impostazioni di backup automatico aggiornate.';

  @override
  String selectionModeDeletedMessage(int count) {
    return '$count note eliminate';
  }

  @override
  String get selectionModeArchivedMessage => 'Archiviata';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'Scegli categoria per $count note';
  }

  @override
  String get selectionModeAddCategoryOption => 'Aggiungi categoria';

  @override
  String get selectionModeRemoveCategoryOption => 'Rimuovi categoria';

  @override
  String get calcTableItemHint => 'Elemento...';

  @override
  String get calcTableTotalRowLabel => 'Totale';

  @override
  String get textSelectionMenuShareButton => 'Condividi';

  @override
  String get textSelectionMenuTranslateButton => 'Traduci';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'Impossibile avviare la condivisione.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'Impossibile aprire la traduzione.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'Oggi $time';
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
    return 'Ultimo backup: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage =>
      'Non è stato ancora effettuato alcun backup.';

  @override
  String get backupFileNameLabel => 'Backup';
}
