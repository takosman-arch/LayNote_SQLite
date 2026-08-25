// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'Aldin';

  @override
  String get toolbarItalicTooltip => 'Cursiv';

  @override
  String get toolbarUnderlineTooltip => 'Subliniat';

  @override
  String get toolbarStrikethroughTooltip => 'Tăiat';

  @override
  String get toolbarFontSizeTooltip => 'Dimensiune font';

  @override
  String get toolbarColorTooltip => 'Culoare text';

  @override
  String get toolbarBulletTooltip => 'Listă cu marcatori';

  @override
  String get toolbarNumberTooltip => 'Listă numerotată';

  @override
  String get toolbarIndentTooltip => 'Indentare paragraf';

  @override
  String get toolbarLinkTooltip => 'Adăugare / Editare / Eliminare link';

  @override
  String get toolbarDividerTooltip => 'Inserare separator';

  @override
  String get toolbarChecklistTooltip => 'Adăugare listă de verificare';

  @override
  String get linkSelectTextSnackbar =>
      'Mai întâi selectați textul pe care doriți să îl asociați';

  @override
  String get linkDialogEditTitle => 'Editare link';

  @override
  String get linkDialogAddTitle => 'Adăugare link';

  @override
  String get linkDialogRemoveButton => 'Eliminare link';

  @override
  String get linkDialogCancelButton => 'Anulare';

  @override
  String get linkDialogConfirmButton => 'Adăugare';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Permisiunea pentru cameră a fost refuzată. Trebuie să o permiteți din setări pentru a înregistra video.';

  @override
  String get cameraPermissionRequiredMessage =>
      'Este necesară permisiunea pentru cameră pentru a înregistra video.';

  @override
  String get openSettingsButtonLabel => 'Setări';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'Scanarea nu a putut fi pornită: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'Recunoașterea textului a eșuat: $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'Nu s-a găsit text lizibil în document';

  @override
  String get scanResultSheetTitle => 'Cum ar trebui adăugat documentul scanat?';

  @override
  String get scanResultTextOnlyOption => 'Adăugare doar ca text';

  @override
  String get scanResultTextAndImageOption => 'Adăugare text + imagine scanată';

  @override
  String get scanResultCancelOption => 'Anulare';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'Permisiunea pentru microfon a fost refuzată. Trebuie să o permiteți din setări pentru a înregistra audio.';

  @override
  String get audioPermissionRequiredMessage =>
      'Este necesară permisiunea pentru microfon pentru a înregistra audio.';

  @override
  String get voiceRecordingDefaultLabel => 'Înregistrare vocală';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'Listă de calcul ($count rânduri)';
  }

  @override
  String get blockPreviewDrawingLabel => 'Desen';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count atașamente (fotografie/document)';
  }

  @override
  String get blockPreviewDividerLabel => 'Separator';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'Listă de verificare ($count elemente)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(text gol)';

  @override
  String get reorderBlocksSheetTitle => 'Reordonare blocuri';

  @override
  String get reorderBlocksMoveUpTooltip => 'Mutare în sus';

  @override
  String get reorderBlocksMoveDownTooltip => 'Mutare în jos';

  @override
  String get reorderBlocksCloseTooltip => 'Închidere';

  @override
  String get reorderBlocksDescription =>
      'Atingeți un bloc pentru a-l selecta, apoi folosiți săgețile sus/jos pentru a-l muta.';

  @override
  String get reorderBlocksMenuItemLabel => 'Reordonare';

  @override
  String get txtImportPickerDialogTitle => 'Selectați fișierul TXT de importat';

  @override
  String get txtImportReadFailedMessage => 'Fișierul TXT nu a putut fi citit';

  @override
  String get txtImportEmptyFileMessage => 'Fișierul TXT este gol';

  @override
  String get txtImportSuccessMessage => 'TXT importat';

  @override
  String get txtImportMenuItemLabel => 'Import (txt)';

  @override
  String get exportMenuItemLabel => 'Export';

  @override
  String get editorUndoTooltip => 'Anulare';

  @override
  String get editorRedoTooltip => 'Refacere';

  @override
  String get noteSavedMessage => 'Notiță salvată';

  @override
  String get dateAssignPickerHelpText => 'Atribuiți notița unei zile';

  @override
  String get dateAssignChangeOption => 'Schimbare dată';

  @override
  String get dateAssignRemoveOption => 'Eliminare atribuire';

  @override
  String get editorSubToolbarCloseTooltip => 'Închidere';

  @override
  String get titleFieldHint => 'Titlu';

  @override
  String get textBlockHint => 'Scrieți notița aici...';

  @override
  String get drawingBoardMenuItemLabel => 'Tablă de desen';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'Conversia voce în text este disponibilă doar pentru notițele text';

  @override
  String get selectionModeCancelTooltip => 'Anulare selecție';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return '$count selectate';
  }

  @override
  String get selectionModeDeleteTooltip => 'Ștergere';

  @override
  String get selectionModeArchiveTooltip => 'Arhivare';

  @override
  String get selectionModeFolderTooltip => 'Folder';

  @override
  String get searchFieldHint => 'Căutare notițe...';

  @override
  String get emptyTrashDialogTitle => 'Golire coș de gunoi';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'Toate notițele șterse vor fi eliminate definitiv. Sigur doriți să continuați?';

  @override
  String get emptyTrashDialogCancelButton => 'Anulare';

  @override
  String get restoreAllMenuItemLabel => 'Restaurare toate';

  @override
  String get sortMenuTooltip => 'Sortare notițe';

  @override
  String get sortMenuAscendingLabel => 'Ordine: Crescătoare (A-Z)';

  @override
  String get sortMenuDescendingLabel => 'Ordine: Descrescătoare (Z-A)';

  @override
  String get sortMenuByTitleLabel => 'Sortare după: Titlu';

  @override
  String get sortMenuByModifiedDateLabel => 'Sortare după: Ultima modificare';

  @override
  String get sortMenuByCreatedDateLabel => 'Sortare după: Data creării';

  @override
  String get sortMenuByFolderLabel => 'Sortare după: Folder';

  @override
  String get viewToggleGridTooltip => 'Vizualizare grilă';

  @override
  String get viewToggleListTooltip => 'Vizualizare listă';

  @override
  String get drawerHeaderSubtitle => 'Carnetul dvs. personal';

  @override
  String get drawerNotesSectionHeader => 'NOTIȚE';

  @override
  String get drawerAllNotesLabel => 'Notițe';

  @override
  String get drawerFavoritesLabel => 'Favorite';

  @override
  String get drawerAgendaLabel => 'Agendă';

  @override
  String get drawerRemindersLabel => 'Memento';

  @override
  String get drawerLockedLabel => 'Blocate';

  @override
  String get drawerTrashLabel => 'Coș de gunoi';

  @override
  String get drawerFoldersSectionHeader => 'FOLDERE';

  @override
  String get drawerExpandLabel => 'Extindere';

  @override
  String get drawerCollapseLabel => 'Restrângere';

  @override
  String get drawerAddFolderLabel => 'Adăugare folder';

  @override
  String get drawerAppSectionHeader => 'APLICAȚIE';

  @override
  String get drawerCalendarLabel => 'Calendar';

  @override
  String get drawerSettingsLabel => 'Setări';

  @override
  String get drawerBackupRestoreLabel => 'Backup și restaurare';

  @override
  String get drawerUpgradeToProLabel => 'Actualizare la Pro';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'Susțineți dezvoltarea';

  @override
  String get drawerFeedbackLabel => 'Feedback';

  @override
  String get drawerAboutLabel => 'Despre';

  @override
  String get noNotesFoundMessage => 'Nu s-au găsit notițe.';

  @override
  String get trashRestoreButtonLabel => 'Restaurare';

  @override
  String get trashPermanentDeleteButtonLabel => 'Ștergere definitivă';

  @override
  String get tagRenamedInfoMessage => 'Etichetă redenumită';

  @override
  String get tagDeletedInfoMessage => 'Etichetă ștearsă';

  @override
  String get tagOptionsRenameLabel => 'Redenumire';

  @override
  String get tagOptionsDeleteLabel => 'Ștergere';

  @override
  String get renameTagDialogTitle => 'Redenumire etichetă';

  @override
  String get renameTagDialogHint => 'Nume nou etichetă';

  @override
  String get renameTagDialogCancelButton => 'Anulare';

  @override
  String get renameTagDialogSaveButton => 'Salvare';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '\"$tag\" va fi eliminată din $affectedCount notițe. Continuați?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'Ștergeți eticheta \"$tag\"?';
  }

  @override
  String get deleteTagDialogTitle => 'Ștergere etichetă';

  @override
  String get deleteTagDialogCancelButton => 'Anulare';

  @override
  String get deleteTagDialogConfirmButton => 'Ștergere';

  @override
  String get tagsSheetTitle => 'Etichete';

  @override
  String get tagsSheetEmptyMessage => 'Această notiță nu are încă etichete.';

  @override
  String get tagsSheetInputHint => 'Scrieți o etichetă nouă...';

  @override
  String get tagsSheetSuggestionsLabel => 'Etichete existente';

  @override
  String get noteDeletedInfoMessage => 'Notiță ștearsă';

  @override
  String get noteDeletedUndoActionLabel => 'Anulare';

  @override
  String get reminderSetInfoMessage => 'Memento setat';

  @override
  String get reminderRemovedInfoMessage => 'Memento eliminat';

  @override
  String get noteDuplicatedInfoMessage => 'Copie creată';

  @override
  String get speechTextAppendedInfoMessage => 'Text adăugat la notiță';

  @override
  String get pdfPreparingInfoMessage => 'Se pregătește PDF-ul…';

  @override
  String get pdfSavedInfoMessage => 'PDF salvat';

  @override
  String get jpgPreparingInfoMessage => 'Se pregătește JPG-ul…';

  @override
  String get jpgSavedInfoMessage => 'JPG salvat';

  @override
  String get jpgFailedInfoMessage => 'JPG-ul nu a putut fi creat';

  @override
  String get txtPreparingInfoMessage => 'Se pregătește TXT-ul…';

  @override
  String get txtSavedInfoMessage => 'TXT salvat';

  @override
  String get txtFailedInfoMessage => 'TXT-ul nu a putut fi creat';

  @override
  String get exportOpenActionLabel => 'Deschidere';

  @override
  String get wrongPasswordInfoMessage => 'Parolă greșită.';

  @override
  String get noteArchivedInfoMessage => 'Notiță arhivată';

  @override
  String get noteUnarchivedInfoMessage => 'Eliminată din arhivă';

  @override
  String get noteUnlockedInfoMessage => 'Deblocată';

  @override
  String get noteLockedInfoMessage => 'Notiță blocată';

  @override
  String get notificationUnpinnedInfoMessage => 'Anulare fixare';

  @override
  String get emptyNotePinBlockedInfoMessage =>
      'O notiță goală nu poate fi fixată.';

  @override
  String get notificationPinnedInfoMessage => 'Fixată în panoul de notificări';

  @override
  String get noContentToReadInfoMessage => 'Nu există conținut de citit';

  @override
  String get backPressExitInfoMessage => 'Apăsați din nou înapoi pentru a ieși';

  @override
  String get reminderChannelName => 'Mementouri notițe';

  @override
  String get reminderChannelDescription =>
      'Mementouri pentru notițe în aplicația Layout';

  @override
  String get pinnedChannelName => 'Notițe fixate';

  @override
  String get pinnedChannelDescription =>
      'Notițe Layout fixate în panoul de notificări';

  @override
  String get notificationUnpinActionLabel => 'Eliminare';

  @override
  String get reminderDefaultTitle => 'Memento';

  @override
  String get reminderChecklistBodyFallback =>
      'Nu uitați să verificați lista de verificare';

  @override
  String get reminderTextBodyFallback => 'Nu uitați să verificați notița';

  @override
  String get pdfSaveDialogTitle => 'Salvare ca PDF';

  @override
  String get jpgSaveDialogTitle => 'Salvare ca JPG';

  @override
  String get txtSaveDialogTitle => 'Salvare ca TXT';

  @override
  String get textSizeSheetTitle => 'Dimensiune text';

  @override
  String get textSizeSamplePreview => 'Text exemplu';

  @override
  String get textSizeCancelButton => 'Anulare';

  @override
  String get textSizeApplyButton => 'Aplicare';

  @override
  String get createPasswordDialogTitle => 'Creare parolă';

  @override
  String get createPasswordNewPasswordHint => 'Parolă nouă';

  @override
  String get createPasswordConfirmHint => 'Reintroduceți parola';

  @override
  String get createPasswordHintQuestionDescription =>
      'Setați o întrebare de securitate în cazul în care uitați parola (opțional).';

  @override
  String get createPasswordHintQuestionHint =>
      'Alegeți o întrebare de securitate';

  @override
  String get createPasswordHintAnswerHint => 'Răspunsul dvs.';

  @override
  String get createPasswordCancelButton => 'Anulare';

  @override
  String get createPasswordSaveButton => 'Salvare';

  @override
  String get passwordMismatchMessage => 'Parolele nu se potrivesc!';

  @override
  String get passwordRequiredDialogTitle => 'Parolă necesară';

  @override
  String get passwordRequiredHint => 'Introduceți parola';

  @override
  String get forgotPasswordButtonLabel => 'Am uitat parola';

  @override
  String get passwordRequiredCancelButton => 'Anulare';

  @override
  String get passwordRequiredConfirmButton => 'Verificare';

  @override
  String get securityQuestionDialogTitle => 'Întrebare de securitate';

  @override
  String get securityQuestionAnswerHint => 'Răspunsul dvs.';

  @override
  String get securityQuestionCancelButton => 'Anulare';

  @override
  String get securityQuestionConfirmButton => 'Confirmare';

  @override
  String get securityQuestionWrongAnswerMessage =>
      'Răspuns greșit. Încercați din nou.';

  @override
  String get revealedPasswordDialogTitle => 'Parola dvs.';

  @override
  String get revealedPasswordLabel => 'Parola notiței dvs.:';

  @override
  String get revealedPasswordOkButton => 'OK';

  @override
  String get securityQuestionPetName =>
      'Care este numele primului dvs. animal de companie?';

  @override
  String get securityQuestionFavoriteTeacher =>
      'Care este numele profesorului dvs. preferat?';

  @override
  String get securityQuestionBirthCity => 'În ce oraș v-ați născut?';

  @override
  String get securityQuestionFavoriteFood =>
      'Care este mâncarea dvs. preferată?';

  @override
  String get securityQuestionMotherMaidenName =>
      'Care este numele de fată al mamei dvs.?';

  @override
  String get securityQuestionFirstSchool =>
      'Care este numele primei școli pe care ați urmat-o?';

  @override
  String get securityQuestionFavoriteColor =>
      'Care este culoarea dvs. preferată?';

  @override
  String get editFolderDialogTitle => 'Editare folder';

  @override
  String get newSubfolderDialogTitle => 'Subfolder nou';

  @override
  String get addFolderDialogTitle => 'Adăugare folder';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'Va fi creat în interiorul \"$parentCategory\"';
  }

  @override
  String get subfolderNameFieldLabel => 'Nume subfolder';

  @override
  String get folderNameFieldLabel => 'Nume folder';

  @override
  String get folderColorLabel => 'Culoare';

  @override
  String get folderDialogCancelButton => 'Anulare';

  @override
  String get folderDialogSaveButton => 'Salvare';

  @override
  String get folderDialogAddButton => 'Adăugare';

  @override
  String get selectFolderSheetTitle => 'Selectare folder';

  @override
  String get selectFolderAddOptionLabel => 'Adăugare folder';

  @override
  String get removeCurrentFolderLabel => 'Eliminare folder curent';

  @override
  String get noteDetailsDialogTitle => 'Detalii';

  @override
  String get noteDetailsCreatedLabel => 'Creată';

  @override
  String get noteDetailsModifiedLabel => 'Ultima modificare';

  @override
  String get noteDetailsCharCountLabel => 'Număr de caractere';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count caractere';
  }

  @override
  String get noteDetailsWordCountLabel => 'Număr de cuvinte';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count cuvinte';
  }

  @override
  String get noteDetailsOkButton => 'OK';

  @override
  String get noteDetailsUnknownDateLabel => 'Necunoscut';

  @override
  String get addAttachmentSheetTitle => 'Adăugare';

  @override
  String get addAttachmentImageOption => 'Adăugare imagine';

  @override
  String get addAttachmentCameraOption => 'Cameră';

  @override
  String get addAttachmentFileOption => 'Adăugare fișier';

  @override
  String get addAttachmentVoiceOption => 'Înregistrare vocală';

  @override
  String get addAttachmentVideoOption => 'Înregistrare video';

  @override
  String get addAttachmentScanOption => 'Scanare document';

  @override
  String get noteActionsSheetTitle => 'Alegeți acțiune';

  @override
  String get noteActionReminderLabel => 'Memento';

  @override
  String get noteActionEditReminderLabel => 'Editare memento';

  @override
  String get noteActionSpeechToTextLabel => 'Voce în text';

  @override
  String get noteActionArchiveLabel => 'Arhivare';

  @override
  String get noteActionUnarchiveLabel => 'Eliminare din arhivă';

  @override
  String get noteActionLockLabel => 'Blocare';

  @override
  String get noteActionUnlockLabel => 'Deblocare';

  @override
  String get noteActionFavoriteLabel => 'Favorite';

  @override
  String get noteActionUnfavoriteLabel => 'Eliminare din favorite';

  @override
  String get noteActionClassifyLabel => 'Selectare folder';

  @override
  String get noteActionDeleteLabel => 'Ștergere';

  @override
  String get noteActionPinToNotificationLabel =>
      'Fixare în panoul de notificări';

  @override
  String get noteActionUnpinFromNotificationLabel => 'Eliminare fixare';

  @override
  String get noteActionShareLabel => 'Distribuire';

  @override
  String get noteActionDuplicateLabel => 'Creare copie';

  @override
  String get noteActionCopyContentLabel => 'Copiere conținut';

  @override
  String get noteActionTtsLabel => 'Citire cu voce tare';

  @override
  String get noteActionTextSizeLabel => 'Dimensiune text';

  @override
  String get noteActionDetailsLabel => 'Detalii';

  @override
  String get noteActionDiscardChangesLabel => 'Anulare modificări';

  @override
  String get noteActionSelectLabel => 'Selectare';

  @override
  String get reminderEditOptionLabel => 'Schimbare memento';

  @override
  String get reminderRemoveOptionLabel => 'Eliminare memento';

  @override
  String get discardChangesDialogTitle => 'Anulare modificări';

  @override
  String get discardChangesDialogMessage =>
      'Modificările nesalvate ale acestei notițe se vor pierde. Sigur doriți să le anulați?';

  @override
  String get discardChangesCancelButton => 'Anulare';

  @override
  String get discardChangesConfirmButton => 'Renunțare';

  @override
  String get pinnedNotificationDefaultTitle => 'Notiță';

  @override
  String get pdfFailedInfoMessage => 'Crearea PDF-ului a eșuat';

  @override
  String get drawingScreenTitle => 'Desen';

  @override
  String get drawingMinimizeTooltip => 'Minimizare';

  @override
  String get drawingEmptyExportWarningMessage => 'Desenați ceva mai întâi';

  @override
  String get drawingEraserPartialModeLabel => 'Parțial';

  @override
  String get drawingEraserFullModeLabel => 'Complet';

  @override
  String get drawingClearTooltip => 'Ștergere';

  @override
  String get drawingZoomOutTooltip => 'Micșorare';

  @override
  String get drawingZoomInTooltip => 'Mărire';

  @override
  String get drawingDeleteTooltip => 'Ștergere';

  @override
  String get drawingEmptyPreviewHint => 'Atingeți pentru a desena';

  @override
  String get settingsPageTitle => 'Setări';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsSectionSecurity => 'Securitate';

  @override
  String get settingsSectionTheme => 'Temă';

  @override
  String get settingsSectionPersonalization => 'Personalizare';

  @override
  String get settingsSectionWidget => 'Widget';

  @override
  String get settingsSectionAbout => 'Despre';

  @override
  String get settingsHintQuestionPet =>
      'Care este numele primului dvs. animal de companie?';

  @override
  String get settingsHintQuestionTeacher =>
      'Care este numele profesorului dvs. preferat?';

  @override
  String get settingsHintQuestionBirthCity => 'În ce oraș v-ați născut?';

  @override
  String get settingsHintQuestionFavoriteFood =>
      'Care este mâncarea dvs. preferată?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'Care este numele de fată al mamei dvs.?';

  @override
  String get settingsHintQuestionFirstSchool =>
      'Care a fost prima școală pe care ați urmat-o?';

  @override
  String get settingsHintQuestionFavoriteColor =>
      'Care este culoarea dvs. preferată?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'Întrebare de securitate';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'Dacă uitați parola, o puteți recupera răspunzând corect la această întrebare.';

  @override
  String get settingsSecurityQuestionDropdownHint =>
      'Alegeți o întrebare de securitate';

  @override
  String get settingsSecurityQuestionAnswerHint => 'Răspunsul dvs.';

  @override
  String get settingsSecurityQuestionCancelButton => 'Anulare';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'Întrebarea și răspunsul nu pot fi goale!';

  @override
  String get settingsSecurityQuestionSaveButton => 'Salvare';

  @override
  String get settingsCreatePasswordTitle => 'Creare parolă';

  @override
  String get settingsPasswordRequiredTitle => 'Parolă necesară';

  @override
  String get settingsPasswordEnterHint => 'Introduceți parola';

  @override
  String get settingsForgotPasswordButton => 'Am uitat parola';

  @override
  String get settingsNewPasswordHint => 'Parolă nouă';

  @override
  String get settingsConfirmPasswordHint => 'Reintroduceți parola';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'Setați o întrebare de securitate în cazul în care uitați parola (opțional).';

  @override
  String get settingsPasswordDialogCancelButton => 'Anulare';

  @override
  String get settingsPasswordMismatchWarning => 'Parolele nu se potrivesc!';

  @override
  String get settingsWrongPasswordWarning => 'Parolă greșită!';

  @override
  String get settingsPasswordSaveButton => 'Salvare';

  @override
  String get settingsPasswordRemoveButton => 'Eliminare';

  @override
  String get settingsNotePasswordTitle => 'Parola notiței';

  @override
  String get settingsPasswordSetSubtitle => 'Parolă setată ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'Parolă nesetată';

  @override
  String get settingsSecurityQuestionTileTitle => 'Întrebare de securitate';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'Setată ✓ — folosită dacă uitați parola';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'Nesetată — nu veți putea recupera parola dacă o pierdeți';

  @override
  String get settingsThemeDialogTitle => 'Selectare temă';

  @override
  String get settingsThemeSystemDefault => 'Implicit sistem';

  @override
  String get settingsThemeLightOption => 'Temă deschisă';

  @override
  String get settingsThemeDarkOption => 'Temă închisă';

  @override
  String get settingsLanguageDialogTitle => 'Selectare limbă';

  @override
  String get settingsLanguageSystemOption => 'Sistem';

  @override
  String get settingsAccentColorDialogTitle => 'Alegere culoare de accent';

  @override
  String get settingsThemeChangeTileTitle => 'Schimbare temă';

  @override
  String get settingsThemeLightLabel => 'Deschisă';

  @override
  String get settingsThemeDarkLabel => 'Închisă';

  @override
  String get settingsThemeSystemLabel => 'Sistem';

  @override
  String get settingsLanguageTileTitle => 'Limbă';

  @override
  String get settingsAccentColorTileTitle => 'Culoare de accent';

  @override
  String get settingsAccentColorTileSubtitle =>
      'Culoare folosită în bara aplicației, butoane și comutatoare';

  @override
  String get settingsColorfulNotesTitle => 'Culori variate pentru notițe';

  @override
  String get settingsColorfulNotesSubtitle =>
      'Fiecare card de notiță primește o nuanță de culoare diferită.';

  @override
  String get settingsTextColorSheetTitle => 'Culoare text';

  @override
  String get settingsTextColorSheetDesc =>
      'Stabilește culoarea textului conținutului notiței.';

  @override
  String get settingsTextColorOkButton => 'OK';

  @override
  String get settingsTextColorTileTitle => 'Culoare text';

  @override
  String get settingsTextColorTileSubtitle =>
      'Culoare pentru textul conținutului notiței.';

  @override
  String get settingsWidgetFontSizeLabel => 'Dimensiune font widget';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'Titlu exemplu - $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'Anulare';

  @override
  String get settingsWidgetFontSizeApplyButton => 'Aplicare';

  @override
  String get settingsWidgetOpacityLabel => 'Transparență fundal';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return 'Transparență $percent%';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'Anulare';

  @override
  String get settingsWidgetOpacityApplyButton => 'Aplicare';

  @override
  String get settingsWidgetDarkModeTitle => 'Widget întunecat';

  @override
  String get settingsWidgetDarkModeDesc =>
      'Schemă de culori întunecată pentru widget.';

  @override
  String get settingsAboutVersionTitle => 'Versiune aplicație';

  @override
  String get settingsFontFamilyTileTitle => 'Font';

  @override
  String get settingsFontFamilyDefaultLabel => 'Implicit';

  @override
  String get settingsGlobalFontSizeTileTitle => 'Dimensiune font';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt — aplicat tuturor notițelor.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'Text exemplu - $size pt';
  }

  @override
  String get settingsGlobalFontSizeApplyToAllLabel =>
      'Aplicare la notițele existente';

  @override
  String get settingsGlobalFontSizeApplyToAllNote =>
      'Dacă o notiță are o dimensiune de font individuală setată, această setare nu o va afecta.';

  @override
  String get settingsGlobalFontSizeCancelButton => 'Anulare';

  @override
  String get settingsGlobalFontSizeApplyButton => 'Aplicare';

  @override
  String get settingsPreviewLinesTileTitle =>
      'Rânduri de previzualizare notiță';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'Se afișează până la $lines rânduri. Dacă notița este mai scurtă, se afișează numărul real de rânduri.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'Curent: $lines rânduri';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'Stabilește numărul maxim de rânduri de previzualizat. Dacă notița are mai puține rânduri, se afișează numărul real de rânduri.';

  @override
  String get settingsPreviewLinesCancelButton => 'Anulare';

  @override
  String get settingsPreviewLinesApplyButton => 'Aplicare';

  @override
  String get backupCancelButton => 'Anulare';

  @override
  String get backupConnectButton => 'Conectare';

  @override
  String get backupDisconnectButton => 'Deconectare';

  @override
  String get backupContinueButton => 'Continuare';

  @override
  String get backupCloseButton => 'Închidere';

  @override
  String get backupShareButton => 'Distribuire';

  @override
  String get backupRestoreButton => 'Restaurare';

  @override
  String get backupConfigureButton => 'Configurare';

  @override
  String get backupUnknownDateLabel => 'Necunoscută';

  @override
  String get backupProcessingDefaultLabel => 'Se procesează...';

  @override
  String get backupPermissionRequiredTitle => 'Permisiune de stocare necesară';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'Această versiune Android necesită permisiune de stocare pentru backup/restaurare. Deoarece permisiunea a fost refuzată definitiv, activați-o manual din setările aplicației.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'Această versiune Android necesită permisiune de stocare pentru backup/restaurare. Acordați permisiunea pentru a continua.';

  @override
  String get backupGoToSettingsButton => 'Mergeți la setări';

  @override
  String get backupRetryButton => 'Reîncercare';

  @override
  String get backupDriveConnectingLabel => 'Se conectează la contul Google...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Conectat la contul Google Drive: $email';
  }

  @override
  String get backupDriveConnectedMessage => 'Conectat la contul Google Drive.';

  @override
  String get backupDriveConnectFailedMessage =>
      'Nu s-a putut conecta la contul Google sau operațiunea a fost anulată.';

  @override
  String get backupDriveDisconnectTitle => 'Deconectare Google Drive';

  @override
  String get backupDriveDisconnectBody =>
      'Dacă vă deconectați, backup-urile manuale sau automate pe Drive nu vor mai fi posibile. Backup-urile deja stocate pe Drive nu vor fi șterse — doar accesul de pe acest dispozitiv va fi eliminat.';

  @override
  String get backupDriveDisconnectedMessage =>
      'Conexiunea la Google Drive a fost eliminată.';

  @override
  String get backupDriveRequiredTitle => 'Cont Google necesar';

  @override
  String get backupDriveRequiredBody =>
      'Această acțiune necesită conectarea contului dvs. Google. Doriți să vă conectați acum?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: conectat ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: conectat';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: neconectat';

  @override
  String get backupDriveAuthenticatingLabel => 'Se verifică contul Google...';

  @override
  String get backupDriveNotSignedInMessage =>
      'Nu sunteți conectat la Google Drive. Conectați-vă mai întâi cu contul dvs. Google.';

  @override
  String get backupDriveUploadingLabel => 'Se încarcă backup-ul pe Drive...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Încărcarea pe Google Drive nu s-a finalizat în 120 de secunde (niciun răspuns de la server). Verificați conexiunea și încercați din nou.';

  @override
  String get backupDriveOperationCompletedLabel => 'Finalizat';

  @override
  String get backupToDriveActionLabel => 'backup pe Drive';

  @override
  String get backupToDeviceActionLabel => 'backup';

  @override
  String get backupCreatingLabel => 'Se creează backup-ul...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'Backup-ul nu a putut fi creat: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Încărcarea pe Google Drive a eșuat: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'Backup încărcat cu succes pe Google Drive.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'Backup creat: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'Backup gata';

  @override
  String get backupOfferShareBody =>
      'Fișierul de backup a fost salvat pe dispozitivul dvs. Doriți să îl distribuiți acum (de ex. stocare cloud, e-mail, alt dispozitiv)?';

  @override
  String get backupShareFileText => 'fișier backup layout';

  @override
  String backupShareFailedMessage(String error) {
    return 'Distribuirea nu a putut fi pornită: $error';
  }

  @override
  String get backupLargeOperationTitle => 'Backup mare';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'Datele de procesat sunt de aproximativ $sizeText. Un $actionLabel de această dimensiune poate dura ceva timp, în funcție de dispozitiv. Nu părăsiți aplicația cât timp este în desfășurare — doriți să continuați?';
  }

  @override
  String get backupRestoreActionLabel => 'restaurare';

  @override
  String get backupDriveListingLabel =>
      'Se listează backup-urile de pe Drive...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'Backup-urile nu au putut fi listate: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'Nu există încă backup-uri pe Google Drive.';

  @override
  String get backupDrivePickTitle => 'Alegeți un backup din Drive';

  @override
  String get backupDriveDownloadingLabel =>
      'Se descarcă backup-ul de pe Drive...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Se descarcă backup-ul de pe Drive... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel =>
      'Se salvează fișierul pe dispozitiv...';

  @override
  String get backupDriveUnknownBackupFileName => 'backup_necunoscut.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Spațiul dvs. de stocare Google Drive este plin. Eliberați spațiu pe Drive și încercați din nou.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'Nu s-a putut stabili o conexiune la internet. Verificați conexiunea și încercați din nou.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'Fișierul de backup specificat nu a putut fi găsit pe Drive. Este posibil să fi fost șters.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'A apărut o eroare neașteptată în timpul operațiunii Google Drive: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'Descărcarea a eșuat: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'Fișierul nu a putut fi selectat: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'Fișierul selectat nu a putut fi accesat.';

  @override
  String get backupCheckingLabel => 'Se verifică backup-ul...';

  @override
  String backupReadFailedMessage(String error) {
    return 'Fișierul de backup nu a putut fi citit: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'Restaurare backup';

  @override
  String get backupPreviewContentsHeader => 'Conținutul backup-ului selectat:';

  @override
  String get backupPreviewNoteCountLabel => 'Număr de notițe';

  @override
  String get backupPreviewTrashCountLabel => 'Notițe în coșul de gunoi';

  @override
  String get backupPreviewCategoryCountLabel => 'Număr de categorii';

  @override
  String get backupPreviewAttachmentLabel => 'Atașamente';

  @override
  String get backupPreviewAttachmentNoneValue => 'Niciunul';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count fișiere ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'Creat la';

  @override
  String get backupEmptyPreviewTitle => 'Acest backup pare gol';

  @override
  String get backupEmptyPreviewBody =>
      'Nu s-au găsit notițe, categorii sau atașamente în fișierul selectat. Dacă continuați, datele dvs. actuale vor fi totuși șterse și înlocuite cu acest backup gol.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '$count atașamente negăsite în backup';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'Notițele cu aceste fișiere vor fi restaurate, dar fără atașamente (este posibil să fi lipsit sau să fi fost corupte la momentul creării backup-ului): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown și încă $remaining';
  }

  @override
  String get backupRestoreConfirmBody =>
      'Această acțiune va ÎNLOCUI toate notițele, coșul de gunoi, categoriile, setările și atașamentele curente cu datele din backup-ul de mai sus. Datele dvs. actuale se vor pierde definitiv, iar această acțiune nu poate fi anulată.';

  @override
  String get backupRestoringLabel => 'Se restaurează backup-ul...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'Backup restaurat. Totuși, $count atașamente nu au fost găsite în backup și nu au putut fi restaurate. Se recomandă repornirea aplicației pentru ca modificările să aibă efect complet.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'Backup restaurat cu succes. Se recomandă repornirea aplicației pentru ca modificările să aibă efect complet.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'A apărut o eroare la restaurare: $error';
  }

  @override
  String get backupScreenTitle => 'Backup și restaurare';

  @override
  String get backupBlockedExitWarningMessage =>
      'O operațiune este în desfășurare, așteptați finalizarea acesteia.';

  @override
  String get backupBusyBackTooltip => 'Operațiune în desfășurare';

  @override
  String get backupIntroText =>
      'Puteți face backup notițelor, categoriilor, setărilor și atașamentelor dvs. într-un singur fișier .zip sau puteți restaura un backup făcut anterior.';

  @override
  String get backupDriveCardTitle => 'Backup pe Google Drive';

  @override
  String get backupDriveCardSubtitle =>
      'Creați un backup nou și încărcați-l direct în zona privată a Google Drive.';

  @override
  String get backupDriveCardButtonLabel => 'Backup pe Drive';

  @override
  String get backupDeviceCardTitle => 'Backup pe dispozitiv';

  @override
  String get backupDeviceCardSubtitle =>
      'Salvați toate datele dvs. într-un singur fișier .zip pe dispozitiv și distribuiți-l dacă doriți.';

  @override
  String get backupDeviceCardButtonLabel => 'Backup pe dispozitiv';

  @override
  String get backupHistoryCardTitle => 'Istoric backup';

  @override
  String get backupHistoryCardSubtitle =>
      'Vizualizați toate backup-urile stocate pe dispozitivul dvs., cu data și dimensiunea lor; le puteți distribui, restaura sau șterge direct de aici.';

  @override
  String get backupHistoryTabDevice => 'Dispozitiv';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'Ștergere backup';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'Sigur doriți să ștergeți definitiv fișierul de backup \"$fileName\"? Această acțiune nu poate fi anulată.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'Backup șters.';

  @override
  String get backupHistoryDriveDeleteDialogTitle =>
      'Ștergere backup de pe Drive';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'Sigur doriți să ștergeți definitiv backup-ul \"$fileName\" de pe Google Drive? Această acțiune nu poate fi anulată, iar fișierul nu va fi mutat în coșul de gunoi.';
  }

  @override
  String get backupHistoryDriveDeletedMessage => 'Backup Drive șters.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'Nu s-a putut șterge: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'Nu există încă backup-uri salvate pe acest dispozitiv.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'Folosiți \"Backup pe dispozitiv\" pentru a crea primul dvs. backup.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'Folosiți \"Backup pe Google Drive\" pentru a crea primul dvs. backup în cloud.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Conectați-vă contul Google pentru a vedea backup-urile de pe Drive.';

  @override
  String get backupHistoryConnectGoogleButton => 'Conectare cu Google';

  @override
  String get backupHistoryDriveConnectedFallback => 'Conectat';

  @override
  String get backupHistoryUnknownErrorFallback =>
      'A apărut o eroare necunoscută.';

  @override
  String get backupHistoryDownloadStartingLabel => 'Se pornește...';

  @override
  String get backupAutoBackupEnabledLabel => 'Backup automat: activat';

  @override
  String get backupAutoBackupDisabledLabel => 'Backup automat: dezactivat';

  @override
  String get backupOverlayWarningMessage =>
      'Așteptați, nu părăsiți aplicația până la finalizarea operațiunii.';

  @override
  String get pdfExportUntitledNoteLabel => 'Notiță fără titlu';

  @override
  String get pdfExportDefaultAttachmentName => 'Atașament';

  @override
  String get pdfExportDefaultFileName => 'notita';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'Captura de ecran nu a putut fi realizată (limita nu a fost găsită)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'Datele capturii de ecran nu au putut fi generate';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'Imaginea nu a putut fi procesată (decodare PNG eșuată)';

  @override
  String get screenshotCalcTableTotalLabel => 'Total';

  @override
  String get gundemMenuRemoveFromAgenda => 'Eliminare din agendă';

  @override
  String get gundemMenuDeleteNote => 'Ștergere notiță';

  @override
  String get gundemSectionOverdue => 'Restante';

  @override
  String get gundemSectionToday => 'Astăzi';

  @override
  String get gundemSectionTomorrow => 'Mâine';

  @override
  String get gundemSectionNextWeek => 'Săptămâna viitoare';

  @override
  String get gundemSectionFurther => 'Mai departe';

  @override
  String get gundemWeekdayMonday => 'Luni';

  @override
  String get gundemWeekdayTuesday => 'Marți';

  @override
  String get gundemWeekdayWednesday => 'Miercuri';

  @override
  String get gundemWeekdayThursday => 'Joi';

  @override
  String get gundemWeekdayFriday => 'Vineri';

  @override
  String get gundemWeekdaySaturday => 'Sâmbătă';

  @override
  String get gundemWeekdaySunday => 'Duminică';

  @override
  String get gundemAppBarTitle => 'Agendă';

  @override
  String get gundemCalendarTooltip => 'Calendar';

  @override
  String get gundemEmptyTitle => 'Nimic în agenda dvs.';

  @override
  String get gundemEmptySubtitle =>
      'Notițele cu un memento sau o dată atribuită vor apărea aici.';

  @override
  String get gundemUntitledNote => 'Notiță fără titlu';

  @override
  String get gundemRepeatHourly => 'Orar';

  @override
  String get gundemRepeatDaily => 'Zilnic';

  @override
  String get gundemRepeatWeekly => 'Săptămânal';

  @override
  String get gundemRepeatMonthly => 'Lunar';

  @override
  String get gundemRepeatYearly => 'Anual';

  @override
  String get gundemPreviewCalcTableLabel => '[Listă de calcul]';

  @override
  String get gundemPreviewDrawingLabel => '[Desen]';

  @override
  String get gundemPreviewImageLabel => '[Imagine]';

  @override
  String get gundemMonthShortJan => 'Ian';

  @override
  String get gundemMonthShortFeb => 'Feb';

  @override
  String get gundemMonthShortMar => 'Mar';

  @override
  String get gundemMonthShortApr => 'Apr';

  @override
  String get gundemMonthShortMay => 'Mai';

  @override
  String get gundemMonthShortJun => 'Iun';

  @override
  String get gundemMonthShortJul => 'Iul';

  @override
  String get gundemMonthShortAug => 'Aug';

  @override
  String get gundemMonthShortSep => 'Sep';

  @override
  String get gundemMonthShortOct => 'Oct';

  @override
  String get gundemMonthShortNov => 'Noi';

  @override
  String get gundemMonthShortDec => 'Dec';

  @override
  String get calendarAppBarTitle => 'Calendar';

  @override
  String get calendarTodayButton => 'Astăzi';

  @override
  String get calendarLegendNoteLabel => 'Notiță';

  @override
  String get calendarLegendReminderLabel => 'Memento';

  @override
  String get calendarTodayBadge => 'Astăzi';

  @override
  String get calendarEmptyDayMessage =>
      'Nicio notiță sau memento pentru această zi.';

  @override
  String get calendarReminderHourlyLabel => 'Orar';

  @override
  String get calendarMonthJan => 'Ianuarie';

  @override
  String get calendarMonthFeb => 'Februarie';

  @override
  String get calendarMonthMar => 'Martie';

  @override
  String get calendarMonthApr => 'Aprilie';

  @override
  String get calendarMonthMay => 'Mai';

  @override
  String get calendarMonthJun => 'Iunie';

  @override
  String get calendarMonthJul => 'Iulie';

  @override
  String get calendarMonthAug => 'August';

  @override
  String get calendarMonthSep => 'Septembrie';

  @override
  String get calendarMonthOct => 'Octombrie';

  @override
  String get calendarMonthNov => 'Noiembrie';

  @override
  String get calendarMonthDec => 'Decembrie';

  @override
  String get calendarWeekdayShortMon => 'Lun';

  @override
  String get calendarWeekdayShortTue => 'Mar';

  @override
  String get calendarWeekdayShortWed => 'Mie';

  @override
  String get calendarWeekdayShortThu => 'Joi';

  @override
  String get calendarWeekdayShortFri => 'Vin';

  @override
  String get calendarWeekdayShortSat => 'Sâm';

  @override
  String get calendarWeekdayShortSun => 'Dum';

  @override
  String get calendarWeekdayFullMonday => 'Luni';

  @override
  String get calendarWeekdayFullTuesday => 'Marți';

  @override
  String get calendarWeekdayFullWednesday => 'Miercuri';

  @override
  String get calendarWeekdayFullThursday => 'Joi';

  @override
  String get calendarWeekdayFullFriday => 'Vineri';

  @override
  String get calendarWeekdayFullSaturday => 'Sâmbătă';

  @override
  String get calendarWeekdayFullSunday => 'Duminică';

  @override
  String get wrongPasswordDialogTitle => 'Parolă greșită';

  @override
  String get wrongPasswordDialogMessage => 'Parola introdusă este incorectă.';

  @override
  String get commonOkButton => 'OK';

  @override
  String get unlockCategoryAction => 'Deblocare';

  @override
  String get lockCategoryAction => 'Blocare';

  @override
  String get categoryUnlockedMessage => 'Deblocat';

  @override
  String get categoryLockedMessage => 'Folder blocat';

  @override
  String get deleteFolderMenuItemLabel => 'Ștergere folder';

  @override
  String get deleteFolderDialogTitle => 'Ștergere folder';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'Sigur doriți să ștergeți folderul \"$category\" și toate subfolderele sale? Notițele din aceste foldere vor deveni neclasificate.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'Sigur doriți să ștergeți folderul \"$category\"? Notițele din acest folder vor deveni neclasificate.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'Anulare';

  @override
  String get deleteFolderDialogConfirmButton => 'Ștergere';

  @override
  String get editCategoryNameColorMenuItemLabel => 'Editare nume / culoare';

  @override
  String get addSubfolderMenuItemLabel => 'Creare subfolder';

  @override
  String get expandSubfoldersMenuItemLabel => 'Extindere subfoldere';

  @override
  String get collapseSubfoldersMenuItemLabel => 'Restrângere subfoldere';

  @override
  String saveErrorInfoMessage(String error) {
    return 'Eroare de salvare: $error';
  }

  @override
  String get welcomeNoteTitle => 'Bine ați venit la Layout! 🚀';

  @override
  String get welcomeNoteContent => 'Funcții noi adăugate!';

  @override
  String get noteListDateGroupToday => 'Astăzi';

  @override
  String get noteListDateGroupYesterday => 'Ieri';

  @override
  String get noteListDateGroupLast7Days => 'Ultimele 7 zile';

  @override
  String get noteListDateGroupLast30Days => 'Ultimele 30 de zile';

  @override
  String get reminderRepeatNoneLabel => 'Fără repetare';

  @override
  String get voiceRecorderPreparingLabel => 'Se pregătește…';

  @override
  String get voiceRecorderCancelButton => 'Anulare';

  @override
  String get voiceRecorderStopAddButton => 'Oprire și adăugare';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'Permisiunea pentru microfon nu a fost acordată.';

  @override
  String get speechToTextUnavailableMessage =>
      'Recunoașterea vocală nu este disponibilă pe acest dispozitiv.';

  @override
  String get speechToTextPreparingLabel => 'Se pregătește…';

  @override
  String get speechToTextListeningLabel => 'Se ascultă…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'Începeți să vorbiți…';

  @override
  String get speechToTextCancelButton => 'Anulare';

  @override
  String get speechToTextStopAddButton => 'Oprire și adăugare';

  @override
  String get textToSpeechNoContentMessage => 'Nu există conținut de citit.';

  @override
  String get textToSpeechReadErrorMessage => 'A apărut o eroare la citire.';

  @override
  String get textToSpeechUnavailableMessage =>
      'Sinteza vocală nu este disponibilă pe acest dispozitiv.';

  @override
  String get textToSpeechPreparingLabel => 'Se pregătește…';

  @override
  String get textToSpeechPausedLabel => 'Pauzat';

  @override
  String get textToSpeechFinishedLabel => 'Citire finalizată';

  @override
  String get textToSpeechReadingLabel => 'Se citește…';

  @override
  String get textToSpeechCloseErrorButton => 'Închidere';

  @override
  String get textToSpeechReplayButton => 'Citire din nou';

  @override
  String get textToSpeechCloseFinishedButton => 'Închidere';

  @override
  String get textToSpeechPauseButton => 'Pauză';

  @override
  String get textToSpeechResumeButton => 'Reluare';

  @override
  String get textToSpeechStopButton => 'Oprire';

  @override
  String get textToSpeechSpeedSlow => 'Lent';

  @override
  String get textToSpeechSpeedNormal => 'Normal';

  @override
  String get textToSpeechSpeedFast => 'Rapid';

  @override
  String get calendarPickerCancelButton => 'Anulare';

  @override
  String get calendarPickerConfirmButton => 'Selectare';

  @override
  String get calendarPickerClearButton => 'Golire';

  @override
  String get reminderPickerDialogTitle => 'Adăugare memento';

  @override
  String get reminderPickerDateTodayOption => 'Astăzi';

  @override
  String get reminderPickerDateTomorrowOption => 'Mâine';

  @override
  String get reminderPickerDatePickOption => 'Alegere dată';

  @override
  String get reminderRepeatHourlyLabel => 'În fiecare oră';

  @override
  String get reminderRepeatDailyLabel => 'În fiecare zi';

  @override
  String get reminderRepeatWeeklyLabel => 'În fiecare săptămână';

  @override
  String get reminderRepeatMonthlyLabel => 'În fiecare lună';

  @override
  String get reminderRepeatYearlyLabel => 'În fiecare an';

  @override
  String get reminderPickerCalendarHelpText => 'Selectați data mementoului';

  @override
  String get reminderPickerCancelButton => 'ANULARE';

  @override
  String get reminderPickerSaveButton => 'SALVARE';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'Nu poate fi selectată o oră din trecut';

  @override
  String calcTableTotalLabel(String amount) {
    return 'Total: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'Se pregătesc datele...';

  @override
  String get backupCreatePackagingNotesLabel =>
      'Se împachetează notițele și categoriile...';

  @override
  String get backupCreateReadingAttachmentsLabel => 'Se citesc atașamentele...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'Se citesc atașamentele... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'Se comprimă fișierul zip...';

  @override
  String get backupCreateSavingFileLabel => 'Se salvează fișierul...';

  @override
  String get backupRestoreValidatingLabel => 'Se validează backup-ul...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'Backup validat, se pregătesc datele...';

  @override
  String get backupRestoreWritingNotesLabel => 'Se scriu notițele...';

  @override
  String get backupRestoreWritingTrashLabel => 'Se scrie coșul de gunoi...';

  @override
  String get backupRestoreTrashWrittenLabel => 'Coș de gunoi scris';

  @override
  String get backupRestoreWritingCategoriesLabel => 'Se scriu categoriile...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'Categorii scrise';

  @override
  String get backupRestoreWritingSettingsLabel => 'Se scriu setările...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'Setări scrise';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'Se curăță atașamentele vechi...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'Niciun atașament găsit, se finalizează...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'Se restaurează atașamentele... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'Finalizat';

  @override
  String get backupValidationCorruptedFileMessage =>
      'Fișierul este corupt sau nu este un fișier de backup valid.';

  @override
  String get backupValidationMissingDataMessage =>
      'Nu s-au găsit date în fișierul de backup (backup_data.json lipsește).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'Datele de backup nu au putut fi citite (JSON corupt).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'Acest fișier nu este un backup din aplicația layout.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'Informațiile despre versiunea fișierului de backup nu au putut fi citite.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'Acest backup are un format mai nou pe care versiunea curentă a aplicației nu îl acceptă. Actualizați aplicația.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'Informațiile despre versiunea fișierului de backup sunt nevalide.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'Datele de backup nu sunt în formatul așteptat (câmpul notes lipsește).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'Datele de backup nu sunt în formatul așteptat (câmpul trash lipsește).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'Datele de backup nu sunt în formatul așteptat (lista de categorii este nevalidă).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'Datele de backup nu sunt în formatul așteptat (câmpul settings este nevalid).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'Datele de backup nu sunt în formatul așteptat (o înregistrare de notiță este nevalidă).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'Datele de backup nu sunt în formatul așteptat (s-a găsit o înregistrare de notiță fără ID).';

  @override
  String get backupValidationFileNotFoundMessage =>
      'Fișierul de backup nu a fost găsit.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'Nu există suficient spațiu de stocare liber pe dispozitiv. Eliberați spațiu și încercați din nou.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'Permisiunea de acces la fișiere a fost refuzată. Verificați permisiunile aplicației și încercați din nou.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'A apărut o eroare în timpul operațiunii cu fișiere: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'A apărut o eroare neașteptată: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'Arhiva zip nu a putut fi creată (ZipEncoder a returnat null).';

  @override
  String get calcTableMenuItemLabel => 'Listă de calcul';

  @override
  String get tagsMenuItemLabel => 'Etichete';

  @override
  String get linkDialogUrlHint => 'https://example.com';

  @override
  String get checklistItemHint => 'Adăugare element...';

  @override
  String get toolbarHighlightTooltip => 'Evidențiere';

  @override
  String get toolbarListTooltip => 'Listă';

  @override
  String get toolbarHideKeyboardTooltip => 'Ascundere tastatură';

  @override
  String get autoBackupLocalSuccessMessage => 'Backup local reușit.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'Backup local eșuat: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Backup Drive omis: contul Google nu este conectat sau sesiunea a expirat. Deschideți aplicația și reconectați-vă.';

  @override
  String get autoBackupDriveSuccessMessage => 'Backup Drive reușit.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Backup Drive eșuat: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'Nicio notiță încă';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'Total: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ Desen';

  @override
  String get autoBackupSettingsAppBarTitle => 'Setări backup automat';

  @override
  String get autoBackupSettingsMainSwitchTitle => 'Activare backup automat';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'Notițele dvs. sunt salvate periodic în siguranță, în fundal.';

  @override
  String get autoBackupSettingsTargetTitle => 'Destinație backup';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'Alegeți unde sunt salvate backup-urile.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'Local';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'Ambele';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Conectați-vă mai întâi contul pentru a folosi opțiunile Google Drive.';

  @override
  String get autoBackupSettingsConnectButton => 'Conectare';

  @override
  String get autoBackupSettingsFrequencyTitle => 'Frecvență backup';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'Se face un backup la fiecare $hours ore.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 ore';

  @override
  String get autoBackupSettingsFrequency12h => '12 ore';

  @override
  String get autoBackupSettingsFrequency24h => '24 ore (zilnic)';

  @override
  String get autoBackupSettingsFrequency48h => '48 ore (2 zile)';

  @override
  String get autoBackupSettingsFrequency168h => '168 ore (săptămânal)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Doar prin Wi-Fi';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'Încărcarea în cloud se face doar prin Wi-Fi pentru a proteja datele mobile.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'Stare sistem';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'Backup-ul automat nu a rulat încă.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'Ultima rulare: $date $time ($status)\nMesaj: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'Reușit';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'Eșuat';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Nu s-a putut conecta la contul Google.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'Setările de backup automat au fost actualizate.';

  @override
  String selectionModeDeletedMessage(int count) {
    return '$count notițe șterse';
  }

  @override
  String get selectionModeArchivedMessage => 'Arhivate';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'Alegeți categoria pentru $count notițe';
  }

  @override
  String get selectionModeAddCategoryOption => 'Adăugare categorie';

  @override
  String get selectionModeRemoveCategoryOption => 'Eliminare categorie';

  @override
  String get calcTableItemHint => 'Element...';

  @override
  String get calcTableTotalRowLabel => 'Total';

  @override
  String get textSelectionMenuShareButton => 'Distribuire';

  @override
  String get textSelectionMenuTranslateButton => 'Traducere';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'Distribuirea nu a putut fi pornită.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'Traducerea nu a putut fi deschisă.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'Astăzi $time';
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
    return 'Ultimul backup: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage =>
      'Nu s-a făcut încă niciun backup.';

  @override
  String get backupFileNameLabel => 'Copie de rezervă';
}
