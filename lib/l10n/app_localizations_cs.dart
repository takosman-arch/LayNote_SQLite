// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'Tučné';

  @override
  String get toolbarItalicTooltip => 'Kurzíva';

  @override
  String get toolbarUnderlineTooltip => 'Podtržení';

  @override
  String get toolbarStrikethroughTooltip => 'Přeškrtnutí';

  @override
  String get toolbarFontSizeTooltip => 'Velikost písma';

  @override
  String get toolbarColorTooltip => 'Barva textu';

  @override
  String get toolbarBulletTooltip => 'Odrážky';

  @override
  String get toolbarNumberTooltip => 'Číslovaný seznam';

  @override
  String get toolbarIndentTooltip => 'Odsazení odstavce';

  @override
  String get toolbarLinkTooltip => 'Přidat / upravit / odebrat odkaz';

  @override
  String get toolbarDividerTooltip => 'Vložit oddělovač';

  @override
  String get toolbarChecklistTooltip => 'Přidat seznam úkolů';

  @override
  String get linkSelectTextSnackbar =>
      'Nejprve vyberte text, který chcete propojit';

  @override
  String get linkDialogEditTitle => 'Upravit odkaz';

  @override
  String get linkDialogAddTitle => 'Přidat odkaz';

  @override
  String get linkDialogRemoveButton => 'Odebrat odkaz';

  @override
  String get linkDialogCancelButton => 'Zrušit';

  @override
  String get linkDialogConfirmButton => 'Přidat';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Přístup ke kameře byl zamítnut. Pro nahrávání videa jej musíte povolit v nastavení.';

  @override
  String get cameraPermissionRequiredMessage =>
      'Pro nahrávání videa je vyžadováno povolení kamery.';

  @override
  String get openSettingsButtonLabel => 'Nastavení';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'Skenování se nepodařilo spustit: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'Rozpoznání textu se nezdařilo: $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'V dokumentu nebyl nalezen žádný čitelný text';

  @override
  String get scanResultSheetTitle => 'Jak se má naskenovaný dokument přidat?';

  @override
  String get scanResultTextOnlyOption => 'Přidat pouze jako text';

  @override
  String get scanResultTextAndImageOption =>
      'Přidat text + naskenovaný obrázek';

  @override
  String get scanResultCancelOption => 'Zrušit';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'Přístup k mikrofonu byl zamítnut. Pro nahrávání zvuku jej musíte povolit v nastavení.';

  @override
  String get audioPermissionRequiredMessage =>
      'Pro nahrávání zvuku je vyžadováno povolení mikrofonu.';

  @override
  String get voiceRecordingDefaultLabel => 'Hlasová nahrávka';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'Výpočtový seznam ($count řádků)';
  }

  @override
  String get blockPreviewDrawingLabel => 'Kresba';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count příloh (fotka/dokument)';
  }

  @override
  String get blockPreviewDividerLabel => 'Oddělovač';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'Seznam úkolů ($count položek)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(prázdný text)';

  @override
  String get reorderBlocksSheetTitle => 'Přeuspořádat bloky';

  @override
  String get reorderBlocksMoveUpTooltip => 'Posunout nahoru';

  @override
  String get reorderBlocksMoveDownTooltip => 'Posunout dolů';

  @override
  String get reorderBlocksCloseTooltip => 'Zavřít';

  @override
  String get reorderBlocksDescription =>
      'Klepnutím na blok jej vyberte a poté jej přesuňte pomocí šipek nahoru/dolů.';

  @override
  String get reorderBlocksMenuItemLabel => 'Přeuspořádat';

  @override
  String get txtImportPickerDialogTitle => 'Vyberte soubor TXT k importu';

  @override
  String get txtImportReadFailedMessage => 'Soubor TXT se nepodařilo přečíst';

  @override
  String get txtImportEmptyFileMessage => 'Soubor TXT je prázdný';

  @override
  String get txtImportSuccessMessage => 'TXT importován';

  @override
  String get txtImportMenuItemLabel => 'Import (txt)';

  @override
  String get exportMenuItemLabel => 'Export';

  @override
  String get editorUndoTooltip => 'Zpět';

  @override
  String get editorRedoTooltip => 'Znovu';

  @override
  String get noteSavedMessage => 'Poznámka uložena';

  @override
  String get dateAssignPickerHelpText => 'Přiřadit poznámku ke dni';

  @override
  String get dateAssignChangeOption => 'Změnit datum';

  @override
  String get dateAssignRemoveOption => 'Odebrat přiřazení';

  @override
  String get editorSubToolbarCloseTooltip => 'Zavřít';

  @override
  String get titleFieldHint => 'Název';

  @override
  String get textBlockHint => 'Napište sem svou poznámku...';

  @override
  String get drawingBoardMenuItemLabel => 'Kreslicí plocha';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'Převod hlasu na text je dostupný pouze pro textové poznámky';

  @override
  String get selectionModeCancelTooltip => 'Zrušit výběr';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return 'Vybráno: $count';
  }

  @override
  String get selectionModeDeleteTooltip => 'Smazat';

  @override
  String get selectionModeArchiveTooltip => 'Archivovat';

  @override
  String get selectionModeFolderTooltip => 'Složka';

  @override
  String get searchFieldHint => 'Hledat poznámky...';

  @override
  String get emptyTrashDialogTitle => 'Vyprázdnit koš';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'Všechny smazané poznámky budou trvale odstraněny. Opravdu chcete pokračovat?';

  @override
  String get emptyTrashDialogCancelButton => 'Zrušit';

  @override
  String get restoreAllMenuItemLabel => 'Obnovit vše';

  @override
  String get sortMenuTooltip => 'Seřadit poznámky';

  @override
  String get sortMenuAscendingLabel => 'Pořadí: Vzestupně (A-Z)';

  @override
  String get sortMenuDescendingLabel => 'Pořadí: Sestupně (Z-A)';

  @override
  String get sortMenuByTitleLabel => 'Řadit podle: Název';

  @override
  String get sortMenuByModifiedDateLabel => 'Řadit podle: Poslední úpravy';

  @override
  String get sortMenuByCreatedDateLabel => 'Řadit podle: Datum vytvoření';

  @override
  String get sortMenuByFolderLabel => 'Řadit podle: Složka';

  @override
  String get viewToggleGridTooltip => 'Zobrazení mřížky';

  @override
  String get viewToggleListTooltip => 'Zobrazení seznamu';

  @override
  String get drawerHeaderSubtitle => 'Váš osobní zápisník';

  @override
  String get drawerNotesSectionHeader => 'POZNÁMKY';

  @override
  String get drawerAllNotesLabel => 'Poznámky';

  @override
  String get drawerFavoritesLabel => 'Oblíbené';

  @override
  String get drawerAgendaLabel => 'Agenda';

  @override
  String get drawerRemindersLabel => 'Připomínky';

  @override
  String get drawerLockedLabel => 'Uzamčené';

  @override
  String get drawerTrashLabel => 'Koš';

  @override
  String get drawerFoldersSectionHeader => 'SLOŽKY';

  @override
  String get drawerExpandLabel => 'Rozbalit';

  @override
  String get drawerCollapseLabel => 'Sbalit';

  @override
  String get drawerAddFolderLabel => 'Přidat složku';

  @override
  String get drawerAppSectionHeader => 'APLIKACE';

  @override
  String get drawerCalendarLabel => 'Kalendář';

  @override
  String get drawerSettingsLabel => 'Nastavení';

  @override
  String get drawerBackupRestoreLabel => 'Zálohování a obnovení';

  @override
  String get drawerUpgradeToProLabel => 'Přejít na Pro';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'Podpořit vývoj';

  @override
  String get drawerFeedbackLabel => 'Zpětná vazba';

  @override
  String get drawerAboutLabel => 'O aplikaci';

  @override
  String get noNotesFoundMessage => 'Nebyly nalezeny žádné poznámky.';

  @override
  String get trashRestoreButtonLabel => 'Obnovit';

  @override
  String get trashPermanentDeleteButtonLabel => 'Trvale smazat';

  @override
  String get tagRenamedInfoMessage => 'Štítek přejmenován';

  @override
  String get tagDeletedInfoMessage => 'Štítek smazán';

  @override
  String get tagOptionsRenameLabel => 'Přejmenovat';

  @override
  String get tagOptionsDeleteLabel => 'Smazat';

  @override
  String get renameTagDialogTitle => 'Přejmenovat štítek';

  @override
  String get renameTagDialogHint => 'Nový název štítku';

  @override
  String get renameTagDialogCancelButton => 'Zrušit';

  @override
  String get renameTagDialogSaveButton => 'Uložit';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '„$tag“ bude odebrán z $affectedCount poznámek. Pokračovat?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'Smazat štítek „$tag“?';
  }

  @override
  String get deleteTagDialogTitle => 'Smazat štítek';

  @override
  String get deleteTagDialogCancelButton => 'Zrušit';

  @override
  String get deleteTagDialogConfirmButton => 'Smazat';

  @override
  String get tagsSheetTitle => 'Štítky';

  @override
  String get tagsSheetEmptyMessage => 'Tato poznámka zatím nemá žádné štítky.';

  @override
  String get tagsSheetInputHint => 'Napište nový štítek...';

  @override
  String get tagsSheetSuggestionsLabel => 'Existující štítky';

  @override
  String get noteDeletedInfoMessage => 'Poznámka smazána';

  @override
  String get noteDeletedUndoActionLabel => 'Zpět';

  @override
  String get reminderSetInfoMessage => 'Připomínka nastavena';

  @override
  String get reminderRemovedInfoMessage => 'Připomínka odebrána';

  @override
  String get noteDuplicatedInfoMessage => 'Kopie vytvořena';

  @override
  String get speechTextAppendedInfoMessage => 'Text přidán do poznámky';

  @override
  String get pdfPreparingInfoMessage => 'Připravuje se PDF…';

  @override
  String get pdfSavedInfoMessage => 'PDF uloženo';

  @override
  String get jpgPreparingInfoMessage => 'Připravuje se JPG…';

  @override
  String get jpgSavedInfoMessage => 'JPG uloženo';

  @override
  String get jpgFailedInfoMessage => 'Soubor JPG se nepodařilo vytvořit';

  @override
  String get txtPreparingInfoMessage => 'Připravuje se TXT…';

  @override
  String get txtSavedInfoMessage => 'TXT uloženo';

  @override
  String get txtFailedInfoMessage => 'Soubor TXT se nepodařilo vytvořit';

  @override
  String get exportOpenActionLabel => 'Otevřít';

  @override
  String get wrongPasswordInfoMessage => 'Nesprávné heslo.';

  @override
  String get noteArchivedInfoMessage => 'Poznámka archivována';

  @override
  String get noteUnarchivedInfoMessage => 'Odebráno z archivu';

  @override
  String get noteUnlockedInfoMessage => 'Odemčeno';

  @override
  String get noteLockedInfoMessage => 'Poznámka uzamčena';

  @override
  String get notificationUnpinnedInfoMessage => 'Odepnuto';

  @override
  String get emptyNotePinBlockedInfoMessage =>
      'Prázdnou poznámku nelze připnout.';

  @override
  String get notificationPinnedInfoMessage => 'Připnuto na panel oznámení';

  @override
  String get noContentToReadInfoMessage => 'Není zde žádný obsah ke čtení';

  @override
  String get backPressExitInfoMessage =>
      'Pro ukončení stiskněte znovu tlačítko zpět';

  @override
  String get reminderChannelName => 'Připomínky poznámek';

  @override
  String get reminderChannelDescription =>
      'Připomínky poznámek v aplikaci Layout';

  @override
  String get pinnedChannelName => 'Připnuté poznámky';

  @override
  String get pinnedChannelDescription =>
      'Poznámky aplikace Layout připnuté na panelu oznámení';

  @override
  String get notificationUnpinActionLabel => 'Odebrat';

  @override
  String get reminderDefaultTitle => 'Připomínka';

  @override
  String get reminderChecklistBodyFallback =>
      'Nezapomeňte zkontrolovat svůj seznam úkolů';

  @override
  String get reminderTextBodyFallback =>
      'Nezapomeňte zkontrolovat svou poznámku';

  @override
  String get pdfSaveDialogTitle => 'Uložit jako PDF';

  @override
  String get jpgSaveDialogTitle => 'Uložit jako JPG';

  @override
  String get txtSaveDialogTitle => 'Uložit jako TXT';

  @override
  String get textSizeSheetTitle => 'Velikost textu';

  @override
  String get textSizeSamplePreview => 'Ukázkový text';

  @override
  String get textSizeCancelButton => 'Zrušit';

  @override
  String get textSizeApplyButton => 'Použít';

  @override
  String get createPasswordDialogTitle => 'Vytvořit heslo';

  @override
  String get createPasswordNewPasswordHint => 'Nové heslo';

  @override
  String get createPasswordConfirmHint => 'Zadejte heslo znovu';

  @override
  String get createPasswordHintQuestionDescription =>
      'Nastavte bezpečnostní otázku pro případ, že zapomenete heslo (volitelné).';

  @override
  String get createPasswordHintQuestionHint => 'Vyberte bezpečnostní otázku';

  @override
  String get createPasswordHintAnswerHint => 'Vaše odpověď';

  @override
  String get createPasswordCancelButton => 'Zrušit';

  @override
  String get createPasswordSaveButton => 'Uložit';

  @override
  String get passwordMismatchMessage => 'Hesla se neshodují!';

  @override
  String get passwordRequiredDialogTitle => 'Je vyžadováno heslo';

  @override
  String get passwordRequiredHint => 'Zadejte heslo';

  @override
  String get forgotPasswordButtonLabel => 'Zapomněl(a) jsem heslo';

  @override
  String get passwordRequiredCancelButton => 'Zrušit';

  @override
  String get passwordRequiredConfirmButton => 'Ověřit';

  @override
  String get securityQuestionDialogTitle => 'Bezpečnostní otázka';

  @override
  String get securityQuestionAnswerHint => 'Vaše odpověď';

  @override
  String get securityQuestionCancelButton => 'Zrušit';

  @override
  String get securityQuestionConfirmButton => 'Potvrdit';

  @override
  String get securityQuestionWrongAnswerMessage =>
      'Nesprávná odpověď. Zkuste to znovu.';

  @override
  String get revealedPasswordDialogTitle => 'Vaše heslo';

  @override
  String get revealedPasswordLabel => 'Heslo vaší poznámky:';

  @override
  String get revealedPasswordOkButton => 'OK';

  @override
  String get securityQuestionPetName =>
      'Jak se jmenoval váš první domácí mazlíček?';

  @override
  String get securityQuestionFavoriteTeacher =>
      'Jak se jmenoval váš oblíbený učitel?';

  @override
  String get securityQuestionBirthCity => 'Ve kterém městě jste se narodil(a)?';

  @override
  String get securityQuestionFavoriteFood => 'Jaké je vaše oblíbené jídlo?';

  @override
  String get securityQuestionMotherMaidenName =>
      'Jaké je rodné příjmení vaší matky?';

  @override
  String get securityQuestionFirstSchool =>
      'Jak se jmenovala první škola, kterou jste navštěvoval(a)?';

  @override
  String get securityQuestionFavoriteColor => 'Jaká je vaše oblíbená barva?';

  @override
  String get editFolderDialogTitle => 'Upravit složku';

  @override
  String get newSubfolderDialogTitle => 'Nová podsložka';

  @override
  String get addFolderDialogTitle => 'Přidat složku';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'Bude vytvořena uvnitř „$parentCategory“';
  }

  @override
  String get subfolderNameFieldLabel => 'Název podsložky';

  @override
  String get folderNameFieldLabel => 'Název složky';

  @override
  String get folderColorLabel => 'Barva';

  @override
  String get folderDialogCancelButton => 'Zrušit';

  @override
  String get folderDialogSaveButton => 'Uložit';

  @override
  String get folderDialogAddButton => 'Přidat';

  @override
  String get selectFolderSheetTitle => 'Vybrat složku';

  @override
  String get selectFolderAddOptionLabel => 'Přidat složku';

  @override
  String get removeCurrentFolderLabel => 'Odebrat aktuální složku';

  @override
  String get noteDetailsDialogTitle => 'Podrobnosti';

  @override
  String get noteDetailsCreatedLabel => 'Vytvořeno';

  @override
  String get noteDetailsModifiedLabel => 'Poslední úprava';

  @override
  String get noteDetailsCharCountLabel => 'Počet znaků';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count znaků';
  }

  @override
  String get noteDetailsWordCountLabel => 'Počet slov';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count slov';
  }

  @override
  String get noteDetailsOkButton => 'OK';

  @override
  String get noteDetailsUnknownDateLabel => 'Neznámé';

  @override
  String get addAttachmentSheetTitle => 'Přidat';

  @override
  String get addAttachmentImageOption => 'Přidat obrázek';

  @override
  String get addAttachmentCameraOption => 'Fotoaparát';

  @override
  String get addAttachmentFileOption => 'Přidat soubor';

  @override
  String get addAttachmentVoiceOption => 'Hlasová nahrávka';

  @override
  String get addAttachmentVideoOption => 'Nahrát video';

  @override
  String get addAttachmentScanOption => 'Skenovat dokument';

  @override
  String get noteActionsSheetTitle => 'Vyberte akci';

  @override
  String get noteActionReminderLabel => 'Připomínka';

  @override
  String get noteActionEditReminderLabel => 'Upravit připomínku';

  @override
  String get noteActionSpeechToTextLabel => 'Řeč na text';

  @override
  String get noteActionArchiveLabel => 'Archivovat';

  @override
  String get noteActionUnarchiveLabel => 'Odebrat z archivu';

  @override
  String get noteActionLockLabel => 'Uzamknout';

  @override
  String get noteActionUnlockLabel => 'Odemknout';

  @override
  String get noteActionFavoriteLabel => 'Oblíbené';

  @override
  String get noteActionUnfavoriteLabel => 'Odebrat z oblíbených';

  @override
  String get noteActionClassifyLabel => 'Vybrat složku';

  @override
  String get noteActionDeleteLabel => 'Smazat';

  @override
  String get noteActionPinToNotificationLabel => 'Připnout na panel oznámení';

  @override
  String get noteActionUnpinFromNotificationLabel => 'Odepnout';

  @override
  String get noteActionShareLabel => 'Sdílet';

  @override
  String get noteActionDuplicateLabel => 'Vytvořit kopii';

  @override
  String get noteActionCopyContentLabel => 'Kopírovat obsah';

  @override
  String get noteActionTtsLabel => 'Přečíst nahlas';

  @override
  String get noteActionTextSizeLabel => 'Velikost textu';

  @override
  String get noteActionDetailsLabel => 'Podrobnosti';

  @override
  String get noteActionDiscardChangesLabel => 'Zahodit změny';

  @override
  String get noteActionSelectLabel => 'Vybrat';

  @override
  String get reminderEditOptionLabel => 'Změnit připomínku';

  @override
  String get reminderRemoveOptionLabel => 'Odebrat připomínku';

  @override
  String get discardChangesDialogTitle => 'Zahodit změny';

  @override
  String get discardChangesDialogMessage =>
      'Neuložené změny v této poznámce budou ztraceny. Opravdu je chcete zahodit?';

  @override
  String get discardChangesCancelButton => 'Zrušit';

  @override
  String get discardChangesConfirmButton => 'Zahodit';

  @override
  String get pinnedNotificationDefaultTitle => 'Poznámka';

  @override
  String get pdfFailedInfoMessage => 'Soubor PDF se nepodařilo vytvořit';

  @override
  String get drawingScreenTitle => 'Kresba';

  @override
  String get drawingMinimizeTooltip => 'Minimalizovat';

  @override
  String get drawingEmptyExportWarningMessage => 'Nejprve něco nakreslete';

  @override
  String get drawingEraserPartialModeLabel => 'Částečná';

  @override
  String get drawingEraserFullModeLabel => 'Úplná';

  @override
  String get drawingClearTooltip => 'Vymazat';

  @override
  String get drawingZoomOutTooltip => 'Oddálit';

  @override
  String get drawingZoomInTooltip => 'Přiblížit';

  @override
  String get drawingDeleteTooltip => 'Smazat';

  @override
  String get drawingEmptyPreviewHint => 'Klepnutím kreslete';

  @override
  String get settingsPageTitle => 'Nastavení';

  @override
  String get settingsSectionGeneral => 'Obecné';

  @override
  String get settingsSectionSecurity => 'Zabezpečení';

  @override
  String get settingsSectionTheme => 'Motiv';

  @override
  String get settingsSectionPersonalization => 'Přizpůsobení';

  @override
  String get settingsSectionWidget => 'Widget';

  @override
  String get settingsSectionAbout => 'O aplikaci';

  @override
  String get settingsHintQuestionPet =>
      'Jak se jmenoval váš první domácí mazlíček?';

  @override
  String get settingsHintQuestionTeacher =>
      'Jak se jmenoval váš oblíbený učitel?';

  @override
  String get settingsHintQuestionBirthCity =>
      'Ve kterém městě jste se narodil(a)?';

  @override
  String get settingsHintQuestionFavoriteFood => 'Jaké je vaše oblíbené jídlo?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'Jaké je rodné příjmení vaší matky?';

  @override
  String get settingsHintQuestionFirstSchool =>
      'Jaká byla první škola, kterou jste navštěvoval(a)?';

  @override
  String get settingsHintQuestionFavoriteColor =>
      'Jaká je vaše oblíbená barva?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'Bezpečnostní otázka';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'Pokud zapomenete heslo, můžete je obnovit správnou odpovědí na tuto otázku.';

  @override
  String get settingsSecurityQuestionDropdownHint =>
      'Vyberte bezpečnostní otázku';

  @override
  String get settingsSecurityQuestionAnswerHint => 'Vaše odpověď';

  @override
  String get settingsSecurityQuestionCancelButton => 'Zrušit';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'Otázka a odpověď nesmí být prázdné!';

  @override
  String get settingsSecurityQuestionSaveButton => 'Uložit';

  @override
  String get settingsCreatePasswordTitle => 'Vytvořit heslo';

  @override
  String get settingsPasswordRequiredTitle => 'Je vyžadováno heslo';

  @override
  String get settingsPasswordEnterHint => 'Zadejte heslo';

  @override
  String get settingsForgotPasswordButton => 'Zapomněl(a) jsem heslo';

  @override
  String get settingsNewPasswordHint => 'Nové heslo';

  @override
  String get settingsConfirmPasswordHint => 'Zadejte heslo znovu';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'Nastavte bezpečnostní otázku pro případ, že zapomenete heslo (volitelné).';

  @override
  String get settingsPasswordDialogCancelButton => 'Zrušit';

  @override
  String get settingsPasswordMismatchWarning => 'Hesla se neshodují!';

  @override
  String get settingsWrongPasswordWarning => 'Nesprávné heslo!';

  @override
  String get settingsPasswordSaveButton => 'Uložit';

  @override
  String get settingsPasswordRemoveButton => 'Odebrat';

  @override
  String get settingsNotePasswordTitle => 'Heslo poznámky';

  @override
  String get settingsPasswordSetSubtitle => 'Heslo nastaveno ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'Heslo není nastaveno';

  @override
  String get settingsSecurityQuestionTileTitle => 'Bezpečnostní otázka';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'Nastaveno ✓ — použije se, pokud zapomenete heslo';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'Nenastaveno — pokud heslo ztratíte, nebudete jej moci obnovit';

  @override
  String get settingsThemeDialogTitle => 'Vybrat motiv';

  @override
  String get settingsThemeSystemDefault => 'Výchozí systémový';

  @override
  String get settingsThemeLightOption => 'Světlý motiv';

  @override
  String get settingsThemeDarkOption => 'Tmavý motiv';

  @override
  String get settingsLanguageDialogTitle => 'Vybrat jazyk';

  @override
  String get settingsLanguageSystemOption => 'Systémový';

  @override
  String get settingsAccentColorDialogTitle => 'Vybrat zvýrazňující barvu';

  @override
  String get settingsThemeChangeTileTitle => 'Změnit motiv';

  @override
  String get settingsThemeLightLabel => 'Světlý';

  @override
  String get settingsThemeDarkLabel => 'Tmavý';

  @override
  String get settingsThemeSystemLabel => 'Systémový';

  @override
  String get settingsLanguageTileTitle => 'Jazyk';

  @override
  String get settingsAccentColorTileTitle => 'Zvýrazňující barva';

  @override
  String get settingsAccentColorTileSubtitle =>
      'Barva použitá na horní liště, tlačítkách a přepínačích';

  @override
  String get settingsColorfulNotesTitle => 'Různobarevné poznámky';

  @override
  String get settingsColorfulNotesSubtitle =>
      'Každá karta poznámky získá jiný barevný odstín.';

  @override
  String get settingsTextColorSheetTitle => 'Barva textu';

  @override
  String get settingsTextColorSheetDesc =>
      'Nastaví barvu textu obsahu poznámky.';

  @override
  String get settingsTextColorOkButton => 'OK';

  @override
  String get settingsTextColorTileTitle => 'Barva textu';

  @override
  String get settingsTextColorTileSubtitle => 'Barva textu obsahu poznámky.';

  @override
  String get settingsWidgetFontSizeLabel => 'Velikost písma widgetu';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'Ukázkový nadpis – $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'Zrušit';

  @override
  String get settingsWidgetFontSizeApplyButton => 'Použít';

  @override
  String get settingsWidgetOpacityLabel => 'Průhlednost pozadí';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return 'Průhlednost $percent %';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'Zrušit';

  @override
  String get settingsWidgetOpacityApplyButton => 'Použít';

  @override
  String get settingsWidgetDarkModeTitle => 'Tmavý widget';

  @override
  String get settingsWidgetDarkModeDesc => 'Tmavé barevné schéma pro widget.';

  @override
  String get settingsAboutVersionTitle => 'Verze aplikace';

  @override
  String get settingsAboutVersionLoading => 'Načítání verze…';

  @override
  String get aboutSectionDeveloper => 'Zpětná vazba';

  @override
  String get aboutDeveloperTitle => 'Vývojář';

  @override
  String get aboutContactTitle => 'Kontakt';

  @override
  String get aboutWebsiteTitle => 'Web';

  @override
  String get aboutGithubTitle => 'GitHub';

  @override
  String get aboutSectionLegal => 'Právní informace';

  @override
  String get aboutPrivacyPolicyTitle => 'Zásady ochrany osobních údajů';

  @override
  String get aboutTermsTitle => 'Podmínky použití';

  @override
  String get aboutLicensesTitle => 'Licence open source';

  @override
  String get aboutSectionSupport => 'Hodnocení';

  @override
  String get aboutRateAppTitle => 'Ohodnotit aplikaci';

  @override
  String get aboutLinkOpenError => 'Odkaz se nepodařilo otevřít.';

  @override
  String get settingsFontFamilyTileTitle => 'Písmo';

  @override
  String get settingsFontFamilyDefaultLabel => 'Výchozí';

  @override
  String get settingsGlobalFontSizeTileTitle => 'Velikost písma';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt — použito na všechny poznámky.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'Ukázkový text – $size pt';
  }

  @override
  String get settingsGlobalFontSizeCancelButton => 'Zrušit';

  @override
  String get settingsGlobalFontSizeApplyButton => 'Použít';

  @override
  String get settingsPreviewLinesTileTitle => 'Řádky náhledu poznámky';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'Zobrazit až $lines řádků. Pokud je poznámka kratší, zobrazí se skutečný počet řádků.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'Aktuálně: $lines řádků';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'Nastaví maximální počet řádků v náhledu. Pokud má poznámka méně řádků, zobrazí se skutečný počet.';

  @override
  String get settingsPreviewLinesCancelButton => 'Zrušit';

  @override
  String get settingsPreviewLinesApplyButton => 'Použít';

  @override
  String get backupCancelButton => 'Zrušit';

  @override
  String get backupConnectButton => 'Připojit';

  @override
  String get backupDisconnectButton => 'Odpojit';

  @override
  String get backupContinueButton => 'Pokračovat';

  @override
  String get backupCloseButton => 'Zavřít';

  @override
  String get backupShareButton => 'Sdílet';

  @override
  String get backupRestoreButton => 'Obnovit';

  @override
  String get backupConfigureButton => 'Nastavit';

  @override
  String get backupUnknownDateLabel => 'Neznámé';

  @override
  String get backupProcessingDefaultLabel => 'Zpracovává se...';

  @override
  String get backupPermissionRequiredTitle =>
      'Je vyžadováno oprávnění k úložišti';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'Tato verze Androidu vyžaduje pro zálohování/obnovení oprávnění k úložišti. Protože bylo oprávnění trvale zamítnuto, povolte je ručně v nastavení aplikace.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'Tato verze Androidu vyžaduje pro zálohování/obnovení oprávnění k úložišti. Pro pokračování udělte oprávnění.';

  @override
  String get backupGoToSettingsButton => 'Přejít do nastavení';

  @override
  String get backupRetryButton => 'Zkusit znovu';

  @override
  String get backupDriveConnectingLabel => 'Připojování k účtu Google...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Připojeno k účtu Google Disk: $email';
  }

  @override
  String get backupDriveConnectedMessage => 'Připojeno k účtu Google Disk.';

  @override
  String get backupDriveConnectFailedMessage =>
      'Nepodařilo se připojit k účtu Google nebo byla operace zrušena.';

  @override
  String get backupDriveDisconnectTitle => 'Odpojit Google Disk';

  @override
  String get backupDriveDisconnectBody =>
      'Pokud se odpojíte, nebude možné ruční ani automatické zálohování na Disk. Zálohy již uložené na Disku nebudou smazány – odebere se pouze přístup z tohoto zařízení.';

  @override
  String get backupDriveDisconnectedMessage =>
      'Připojení ke Google Disku bylo odebráno.';

  @override
  String get backupDriveRequiredTitle => 'Je vyžadován účet Google';

  @override
  String get backupDriveRequiredBody =>
      'Tato akce vyžaduje připojení účtu Google. Chcete se připojit nyní?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Disk: připojeno ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Disk: připojeno';

  @override
  String get backupDriveStatusDisconnected => 'Google Disk: nepřipojeno';

  @override
  String get backupDriveAuthenticatingLabel => 'Ověřování účtu Google...';

  @override
  String get backupDriveNotSignedInMessage =>
      'Nejste připojeni ke Google Disku. Nejprve se prosím přihlaste ke svému účtu Google.';

  @override
  String get backupDriveUploadingLabel => 'Nahrávání zálohy na Disk...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Nahrávání na Google Disk se nedokončilo do 120 sekund (žádná odpověď ze serveru). Zkontrolujte připojení a zkuste to znovu.';

  @override
  String get backupDriveOperationCompletedLabel => 'Dokončeno';

  @override
  String get backupToDriveActionLabel => 'zálohu na Disk';

  @override
  String get backupToDeviceActionLabel => 'zálohu';

  @override
  String get backupCreatingLabel => 'Vytváření zálohy...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'Zálohu se nepodařilo vytvořit: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Nahrání na Google Disk se nezdařilo: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'Záloha byla úspěšně nahrána na Google Disk.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'Záloha vytvořena: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'Záloha je připravena';

  @override
  String get backupOfferShareBody =>
      'Soubor zálohy byl uložen do vašeho zařízení. Chcete jej nyní sdílet (např. do cloudového úložiště, e-mailem, na jiné zařízení)?';

  @override
  String get backupShareFileText => 'soubor zálohy Layout';

  @override
  String backupShareFailedMessage(String error) {
    return 'Sdílení se nepodařilo spustit: $error';
  }

  @override
  String get backupLargeOperationTitle => 'Velká záloha';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'Zpracovávaná data mají přibližně $sizeText. $actionLabel takové velikosti může chvíli trvat v závislosti na zařízení. Během zpracování neopouštějte aplikaci – chcete pokračovat?';
  }

  @override
  String get backupRestoreActionLabel => 'obnovení';

  @override
  String get backupDriveListingLabel => 'Načítání záloh z Disku...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'Zálohy se nepodařilo načíst: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'Na Google Disku zatím nejsou žádné zálohy.';

  @override
  String get backupDrivePickTitle => 'Vyberte zálohu z Disku';

  @override
  String get backupDriveDownloadingLabel => 'Stahování zálohy z Disku...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Stahování zálohy z Disku... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel =>
      'Ukládání souboru do zařízení...';

  @override
  String get backupDriveUnknownBackupFileName => 'neznama_zaloha.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Vaše úložiště Google Disk je plné. Uvolněte místo na Disku a zkuste to znovu.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'Nepodařilo se navázat internetové připojení. Zkontrolujte připojení a zkuste to znovu.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'Zadaný soubor zálohy se na Disku nepodařilo najít. Možná byl smazán.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Během operace s Google Diskem došlo k neočekávané chybě: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'Stahování se nezdařilo: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'Soubor se nepodařilo vybrat: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'K vybranému souboru se nepodařilo získat přístup.';

  @override
  String get backupCheckingLabel => 'Kontrola zálohy...';

  @override
  String backupReadFailedMessage(String error) {
    return 'Soubor zálohy se nepodařilo přečíst: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'Obnovit zálohu';

  @override
  String get backupPreviewContentsHeader => 'Obsah vybrané zálohy:';

  @override
  String get backupPreviewNoteCountLabel => 'Počet poznámek';

  @override
  String get backupPreviewTrashCountLabel => 'Poznámky v koši';

  @override
  String get backupPreviewCategoryCountLabel => 'Počet složek';

  @override
  String get backupPreviewAttachmentLabel => 'Přílohy';

  @override
  String get backupPreviewAttachmentNoneValue => 'Žádné';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count souborů ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'Vytvořeno dne';

  @override
  String get backupEmptyPreviewTitle => 'Tato záloha vypadá prázdně';

  @override
  String get backupEmptyPreviewBody =>
      'Ve vybraném souboru nebyly nalezeny žádné poznámky, složky ani přílohy. Pokud budete pokračovat, vaše aktuální data budou přesto smazána a nahrazena touto prázdnou zálohou.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return 'V záloze nebylo nalezeno $count příloh';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'Poznámky s těmito soubory budou obnoveny, ale bez příloh (mohly chybět nebo být poškozené v době vytvoření zálohy): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown a dalších $remaining';
  }

  @override
  String get backupRestoreConfirmBody =>
      'Tímto NAHRADÍTE všechny své aktuální poznámky, koš, složky, nastavení a přílohy daty z výše uvedené zálohy. Vaše aktuální data budou trvale ztracena a tuto akci nelze vrátit zpět.';

  @override
  String get backupRestoringLabel => 'Obnovování zálohy...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'Záloha byla obnovena. Nicméně $count příloh nebylo v záloze nalezeno a nepodařilo se je obnovit. Pro plné projevení změn se doporučuje aplikaci restartovat.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'Záloha byla úspěšně obnovena. Pro plné projevení změn se doporučuje aplikaci restartovat.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'Při obnovování došlo k chybě: $error';
  }

  @override
  String get backupScreenTitle => 'Zálohování a obnovení';

  @override
  String get backupBlockedExitWarningMessage =>
      'Probíhá operace, počkejte prosím na její dokončení.';

  @override
  String get backupBusyBackTooltip => 'Probíhá operace';

  @override
  String get backupIntroText =>
      'Své poznámky, složky, nastavení a přílohy můžete zálohovat jako jeden soubor .zip nebo obnovit dříve vytvořenou zálohu.';

  @override
  String get backupDriveCardTitle => 'Zálohovat na Google Disk';

  @override
  String get backupDriveCardSubtitle =>
      'Vytvořte novou zálohu a nahrajte ji přímo do soukromé oblasti svého Google Disku.';

  @override
  String get backupDriveCardButtonLabel => 'Zálohovat na Disk';

  @override
  String get backupDeviceCardTitle => 'Zálohovat do zařízení';

  @override
  String get backupDeviceCardSubtitle =>
      'Uložte všechna svá data jako jeden soubor .zip do zařízení a případně je sdílejte.';

  @override
  String get backupDeviceCardButtonLabel => 'Zálohovat do zařízení';

  @override
  String get backupHistoryCardTitle => 'Historie záloh';

  @override
  String get backupHistoryCardSubtitle =>
      'Zobrazte všechny zálohy uložené v zařízení s jejich datem a velikostí; můžete je přímo odsud sdílet, obnovit nebo smazat.';

  @override
  String get backupHistoryTabDevice => 'Zařízení';

  @override
  String get backupHistoryTabDrive => 'Google Disk';

  @override
  String get backupHistoryDeleteDialogTitle => 'Smazat zálohu';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'Opravdu chcete trvale smazat soubor zálohy „$fileName“? Tuto akci nelze vrátit zpět.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'Záloha smazána.';

  @override
  String get backupHistoryDriveDeleteDialogTitle => 'Smazat zálohu z Disku';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'Opravdu chcete trvale smazat zálohu „$fileName“ z Google Disku? Tuto akci nelze vrátit zpět a soubor nebude přesunut do koše.';
  }

  @override
  String get backupHistoryDriveDeletedMessage => 'Záloha z Disku smazána.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'Nepodařilo se smazat: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'Na tomto zařízení zatím nejsou uloženy žádné zálohy.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'Pomocí možnosti „Zálohovat do zařízení“ vytvořte svou první zálohu.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'Pomocí možnosti „Zálohovat na Google Disk“ vytvořte svou první cloudovou zálohu.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Připojte svůj účet Google, abyste viděli zálohy na Disku.';

  @override
  String get backupHistoryConnectGoogleButton => 'Připojit přes Google';

  @override
  String get backupHistoryDriveConnectedFallback => 'Připojeno';

  @override
  String get backupHistoryUnknownErrorFallback => 'Došlo k neznámé chybě.';

  @override
  String get backupHistoryDownloadStartingLabel => 'Spouštění...';

  @override
  String get backupAutoBackupEnabledLabel => 'Automatická záloha: zapnuta';

  @override
  String get backupAutoBackupDisabledLabel => 'Automatická záloha: vypnuta';

  @override
  String get backupOverlayWarningMessage =>
      'Počkejte prosím, neopouštějte aplikaci, dokud operace neskončí.';

  @override
  String get pdfExportUntitledNoteLabel => 'Poznámka bez názvu';

  @override
  String get pdfExportDefaultAttachmentName => 'Příloha';

  @override
  String get pdfExportDefaultFileName => 'poznamka';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'Snímek obrazovky se nepodařilo zachytit (hranice nenalezena)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'Data snímku obrazovky se nepodařilo vygenerovat';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'Obrázek se nepodařilo zpracovat (dekódování PNG selhalo)';

  @override
  String get screenshotCalcTableTotalLabel => 'Celkem';

  @override
  String get gundemMenuRemoveFromAgenda => 'Odebrat z agendy';

  @override
  String get gundemMenuDeleteNote => 'Smazat poznámku';

  @override
  String get gundemSectionOverdue => 'Po termínu';

  @override
  String get gundemSectionToday => 'Dnes';

  @override
  String get gundemSectionTomorrow => 'Zítra';

  @override
  String get gundemSectionNextWeek => 'Příští týden';

  @override
  String get gundemSectionFurther => 'Později';

  @override
  String get gundemWeekdayMonday => 'Pondělí';

  @override
  String get gundemWeekdayTuesday => 'Úterý';

  @override
  String get gundemWeekdayWednesday => 'Středa';

  @override
  String get gundemWeekdayThursday => 'Čtvrtek';

  @override
  String get gundemWeekdayFriday => 'Pátek';

  @override
  String get gundemWeekdaySaturday => 'Sobota';

  @override
  String get gundemWeekdaySunday => 'Neděle';

  @override
  String get gundemAppBarTitle => 'Agenda';

  @override
  String get gundemCalendarTooltip => 'Kalendář';

  @override
  String get gundemEmptyTitle => 'Ve vaší agendě nic není';

  @override
  String get gundemEmptySubtitle =>
      'Zde se zobrazí poznámky s připomínkou nebo přiřazeným datem.';

  @override
  String get gundemUntitledNote => 'Poznámka bez názvu';

  @override
  String get gundemRepeatHourly => 'Každou hodinu';

  @override
  String get gundemRepeatDaily => 'Denně';

  @override
  String get gundemRepeatWeekly => 'Týdně';

  @override
  String get gundemRepeatMonthly => 'Měsíčně';

  @override
  String get gundemRepeatYearly => 'Ročně';

  @override
  String get gundemPreviewCalcTableLabel => '[Výpočtový seznam]';

  @override
  String get gundemPreviewDrawingLabel => '[Kresba]';

  @override
  String get gundemPreviewImageLabel => '[Obrázek]';

  @override
  String get gundemMonthShortJan => 'led';

  @override
  String get gundemMonthShortFeb => 'úno';

  @override
  String get gundemMonthShortMar => 'bře';

  @override
  String get gundemMonthShortApr => 'dub';

  @override
  String get gundemMonthShortMay => 'kvě';

  @override
  String get gundemMonthShortJun => 'čvn';

  @override
  String get gundemMonthShortJul => 'čvc';

  @override
  String get gundemMonthShortAug => 'srp';

  @override
  String get gundemMonthShortSep => 'zář';

  @override
  String get gundemMonthShortOct => 'říj';

  @override
  String get gundemMonthShortNov => 'lis';

  @override
  String get gundemMonthShortDec => 'pro';

  @override
  String get calendarAppBarTitle => 'Kalendář';

  @override
  String get calendarTodayButton => 'Dnes';

  @override
  String get calendarLegendNoteLabel => 'Poznámka';

  @override
  String get calendarLegendReminderLabel => 'Připomínka';

  @override
  String get calendarTodayBadge => 'Dnes';

  @override
  String get calendarEmptyDayMessage =>
      'Pro tento den nejsou žádné poznámky ani připomínky.';

  @override
  String get calendarReminderHourlyLabel => 'Každou hodinu';

  @override
  String get calendarMonthJan => 'Leden';

  @override
  String get calendarMonthFeb => 'Únor';

  @override
  String get calendarMonthMar => 'Březen';

  @override
  String get calendarMonthApr => 'Duben';

  @override
  String get calendarMonthMay => 'Květen';

  @override
  String get calendarMonthJun => 'Červen';

  @override
  String get calendarMonthJul => 'Červenec';

  @override
  String get calendarMonthAug => 'Srpen';

  @override
  String get calendarMonthSep => 'Září';

  @override
  String get calendarMonthOct => 'Říjen';

  @override
  String get calendarMonthNov => 'Listopad';

  @override
  String get calendarMonthDec => 'Prosinec';

  @override
  String get calendarWeekdayShortMon => 'Po';

  @override
  String get calendarWeekdayShortTue => 'Út';

  @override
  String get calendarWeekdayShortWed => 'St';

  @override
  String get calendarWeekdayShortThu => 'Čt';

  @override
  String get calendarWeekdayShortFri => 'Pá';

  @override
  String get calendarWeekdayShortSat => 'So';

  @override
  String get calendarWeekdayShortSun => 'Ne';

  @override
  String get calendarWeekdayFullMonday => 'Pondělí';

  @override
  String get calendarWeekdayFullTuesday => 'Úterý';

  @override
  String get calendarWeekdayFullWednesday => 'Středa';

  @override
  String get calendarWeekdayFullThursday => 'Čtvrtek';

  @override
  String get calendarWeekdayFullFriday => 'Pátek';

  @override
  String get calendarWeekdayFullSaturday => 'Sobota';

  @override
  String get calendarWeekdayFullSunday => 'Neděle';

  @override
  String get wrongPasswordDialogTitle => 'Nesprávné heslo';

  @override
  String get wrongPasswordDialogMessage => 'Zadané heslo je nesprávné.';

  @override
  String get commonOkButton => 'OK';

  @override
  String get unlockCategoryAction => 'Odemknout';

  @override
  String get lockCategoryAction => 'Uzamknout';

  @override
  String get categoryUnlockedMessage => 'Odemčeno';

  @override
  String get categoryLockedMessage => 'Složka uzamčena';

  @override
  String get deleteFolderMenuItemLabel => 'Smazat složku';

  @override
  String get deleteFolderDialogTitle => 'Smazat složku';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'Opravdu chcete smazat složku „$category“ a všechny její podsložky? Poznámky v těchto složkách zůstanou nezařazené.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'Opravdu chcete smazat složku „$category“? Poznámky v této složce zůstanou nezařazené.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'Zrušit';

  @override
  String get deleteFolderDialogConfirmButton => 'Smazat';

  @override
  String get editCategoryNameColorMenuItemLabel => 'Upravit název / barvu';

  @override
  String get addSubfolderMenuItemLabel => 'Vytvořit podsložku';

  @override
  String get expandSubfoldersMenuItemLabel => 'Rozbalit podsložky';

  @override
  String get collapseSubfoldersMenuItemLabel => 'Sbalit podsložky';

  @override
  String saveErrorInfoMessage(String error) {
    return 'Chyba při ukládání: $error';
  }

  @override
  String get welcomeNoteTitle => 'Vítejte v Layout! 🚀';

  @override
  String get welcomeNoteContent => 'Byly přidány nové funkce!';

  @override
  String get noteListDateGroupToday => 'Dnes';

  @override
  String get noteListDateGroupYesterday => 'Včera';

  @override
  String get noteListDateGroupLast7Days => 'Posledních 7 dní';

  @override
  String get noteListDateGroupLast30Days => 'Posledních 30 dní';

  @override
  String get reminderRepeatNoneLabel => 'Bez opakování';

  @override
  String get voiceRecorderPreparingLabel => 'Připravuje se…';

  @override
  String get voiceRecorderCancelButton => 'Zrušit';

  @override
  String get voiceRecorderStopAddButton => 'Zastavit a přidat';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'Oprávnění k mikrofonu nebylo uděleno.';

  @override
  String get speechToTextUnavailableMessage =>
      'Rozpoznávání řeči není v tomto zařízení k dispozici.';

  @override
  String get speechToTextPreparingLabel => 'Připravuje se…';

  @override
  String get speechToTextListeningLabel => 'Naslouchá se…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'Začněte mluvit…';

  @override
  String get speechToTextCancelButton => 'Zrušit';

  @override
  String get speechToTextStopAddButton => 'Zastavit a přidat';

  @override
  String get textToSpeechNoContentMessage => 'Není zde žádný obsah ke čtení.';

  @override
  String get textToSpeechReadErrorMessage => 'Při čtení došlo k chybě.';

  @override
  String get textToSpeechUnavailableMessage =>
      'Převod textu na řeč není v tomto zařízení k dispozici.';

  @override
  String get textToSpeechPreparingLabel => 'Připravuje se…';

  @override
  String get textToSpeechPausedLabel => 'Pozastaveno';

  @override
  String get textToSpeechFinishedLabel => 'Čtení dokončeno';

  @override
  String get textToSpeechReadingLabel => 'Čte se…';

  @override
  String get textToSpeechCloseErrorButton => 'Zavřít';

  @override
  String get textToSpeechReplayButton => 'Přečíst znovu';

  @override
  String get textToSpeechCloseFinishedButton => 'Zavřít';

  @override
  String get textToSpeechPauseButton => 'Pozastavit';

  @override
  String get textToSpeechResumeButton => 'Pokračovat';

  @override
  String get textToSpeechStopButton => 'Zastavit';

  @override
  String get textToSpeechSpeedSlow => 'Pomalé';

  @override
  String get textToSpeechSpeedNormal => 'Normální';

  @override
  String get textToSpeechSpeedFast => 'Rychlé';

  @override
  String get calendarPickerCancelButton => 'Zrušit';

  @override
  String get calendarPickerConfirmButton => 'Vybrat';

  @override
  String get calendarPickerClearButton => 'Vymazat';

  @override
  String get reminderPickerDialogTitle => 'Přidat připomínku';

  @override
  String get reminderPickerDateTodayOption => 'Dnes';

  @override
  String get reminderPickerDateTomorrowOption => 'Zítra';

  @override
  String get reminderPickerDatePickOption => 'Vybrat datum';

  @override
  String get reminderRepeatHourlyLabel => 'Každou hodinu';

  @override
  String get reminderRepeatDailyLabel => 'Každý den';

  @override
  String get reminderRepeatWeeklyLabel => 'Každý týden';

  @override
  String get reminderRepeatMonthlyLabel => 'Každý měsíc';

  @override
  String get reminderRepeatYearlyLabel => 'Každý rok';

  @override
  String get reminderPickerCalendarHelpText => 'Vyberte datum připomínky';

  @override
  String get reminderPickerCancelButton => 'ZRUŠIT';

  @override
  String get reminderPickerSaveButton => 'ULOŽIT';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'Nelze vybrat čas v minulosti';

  @override
  String calcTableTotalLabel(String amount) {
    return 'Celkem: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'Příprava dat...';

  @override
  String get backupCreatePackagingNotesLabel => 'Balení poznámek a složek...';

  @override
  String get backupCreateReadingAttachmentsLabel => 'Čtení příloh...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'Čtení příloh... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'Komprimace souboru zip...';

  @override
  String get backupCreateSavingFileLabel => 'Ukládání souboru...';

  @override
  String get backupRestoreValidatingLabel => 'Ověřování zálohy...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'Záloha ověřena, příprava dat...';

  @override
  String get backupRestoreWritingNotesLabel => 'Zapisování poznámek...';

  @override
  String get backupRestoreWritingTrashLabel => 'Zapisování koše...';

  @override
  String get backupRestoreTrashWrittenLabel => 'Koš zapsán';

  @override
  String get backupRestoreWritingCategoriesLabel => 'Zapisování složek...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'Složky zapsány';

  @override
  String get backupRestoreWritingSettingsLabel => 'Zapisování nastavení...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'Nastavení zapsáno';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'Čištění starých příloh...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'Nebyly nalezeny žádné přílohy, dokončování...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'Obnovování příloh... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'Dokončeno';

  @override
  String get backupValidationCorruptedFileMessage =>
      'Soubor je poškozený nebo se nejedná o platný soubor zálohy.';

  @override
  String get backupValidationMissingDataMessage =>
      'V souboru zálohy nebyla nalezena žádná data (chybí backup_data.json).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'Data zálohy se nepodařilo přečíst (poškozený JSON).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'Tento soubor není zálohou z aplikace layout.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'Informace o verzi souboru zálohy se nepodařilo přečíst.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'Tato záloha je v novějším formátu, který aktuální verze aplikace nepodporuje. Aktualizujte prosím aplikaci.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'Informace o verzi souboru zálohy je neplatná.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'Data zálohy nemají očekávaný formát (chybí pole poznámek).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'Data zálohy nemají očekávaný formát (chybí pole koše).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'Data zálohy nemají očekávaný formát (seznam složek je neplatný).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'Data zálohy nemají očekávaný formát (pole nastavení je neplatné).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'Data zálohy nemají očekávaný formát (záznam poznámky je neplatný).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'Data zálohy nemají očekávaný formát (byl nalezen záznam poznámky bez ID).';

  @override
  String get backupValidationFileNotFoundMessage =>
      'Soubor zálohy nebyl nalezen.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'Na zařízení není dostatek volného místa. Uvolněte místo a zkuste to znovu.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'Přístup k souboru byl zamítnut. Zkontrolujte oprávnění aplikace a zkuste to znovu.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'Při operaci se souborem došlo k chybě: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'Došlo k neočekávané chybě: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'Nepodařilo se vytvořit archiv zip (ZipEncoder vrátil null).';

  @override
  String get calcTableMenuItemLabel => 'Výpočtový seznam';

  @override
  String get tagsMenuItemLabel => 'Štítky';

  @override
  String get linkDialogUrlHint => 'https://example.com';

  @override
  String get checklistItemHint => 'Přidat položku...';

  @override
  String get toolbarHighlightTooltip => 'Zvýraznění';

  @override
  String get toolbarListTooltip => 'Seznam';

  @override
  String get toolbarHideKeyboardTooltip => 'Skrýt klávesnici';

  @override
  String get autoBackupLocalSuccessMessage => 'Místní záloha byla úspěšná.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'Místní záloha selhala: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Záloha na Disk přeskočena: účet Google není připojen nebo relace vypršela. Otevřete aplikaci a připojte se znovu.';

  @override
  String get autoBackupDriveSuccessMessage => 'Záloha na Disk byla úspěšná.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Záloha na Disk selhala: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'Zatím žádné poznámky';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'Celkem: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ Kresba';

  @override
  String get autoBackupSettingsAppBarTitle => 'Nastavení automatické zálohy';

  @override
  String get autoBackupSettingsMainSwitchTitle => 'Povolit automatickou zálohu';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'Vaše poznámky jsou pravidelně bezpečně zálohovány na pozadí.';

  @override
  String get autoBackupSettingsTargetTitle => 'Cíl zálohy';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'Vyberte, kam se budou zálohy ukládat.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'Místní';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Disk';

  @override
  String get autoBackupSettingsTargetBothOption => 'Obojí';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Chcete-li použít možnosti Google Disku, nejprve připojte svůj účet.';

  @override
  String get autoBackupSettingsConnectButton => 'Připojit';

  @override
  String get autoBackupSettingsFrequencyTitle => 'Frekvence zálohování';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'Záloha se vytváří každých $hours hodin.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 hodin';

  @override
  String get autoBackupSettingsFrequency12h => '12 hodin';

  @override
  String get autoBackupSettingsFrequency24h => '24 hodin (denně)';

  @override
  String get autoBackupSettingsFrequency48h => '48 hodin (2 dny)';

  @override
  String get autoBackupSettingsFrequency168h => '168 hodin (týdně)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Použít pouze Wi-Fi';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'Nahrávání do cloudu probíhá pouze přes Wi-Fi, aby se ušetřila mobilní data.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'Stav systému';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'Automatická záloha zatím neproběhla.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'Poslední spuštění: $date $time ($status)\nZpráva: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'Úspěšné';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'Neúspěšné';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Nepodařilo se připojit k účtu Google.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'Nastavení automatické zálohy bylo aktualizováno.';

  @override
  String selectionModeDeletedMessage(int count) {
    return 'Smazáno poznámek: $count';
  }

  @override
  String get selectionModeArchivedMessage => 'Archivováno';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'Vyberte složku pro $count poznámek';
  }

  @override
  String get selectionModeAddCategoryOption => 'Přidat složku';

  @override
  String get selectionModeRemoveCategoryOption => 'Odebrat složku';

  @override
  String get calcTableItemHint => 'Položka...';

  @override
  String get calcTableTotalRowLabel => 'Celkem';

  @override
  String get textSelectionMenuShareButton => 'Sdílet';

  @override
  String get textSelectionMenuTranslateButton => 'Přeložit';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'Sdílení se nepodařilo spustit.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'Překlad se nepodařilo otevřít.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'Dnes $time';
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
    return 'Poslední záloha: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage =>
      'Zatím nebyla vytvořena žádná záloha.';

  @override
  String get backupFileNameLabel => 'Záloha';
}
