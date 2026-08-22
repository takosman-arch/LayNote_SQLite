// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'Lihavointi';

  @override
  String get toolbarItalicTooltip => 'Kursivointi';

  @override
  String get toolbarUnderlineTooltip => 'Alleviivaus';

  @override
  String get toolbarStrikethroughTooltip => 'Yliviivaus';

  @override
  String get toolbarFontSizeTooltip => 'Fonttikoko';

  @override
  String get toolbarColorTooltip => 'Tekstin väri';

  @override
  String get toolbarBulletTooltip => 'Luettelomerkit';

  @override
  String get toolbarNumberTooltip => 'Numeroitu luettelo';

  @override
  String get toolbarIndentTooltip => 'Kappaleen sisennys';

  @override
  String get toolbarLinkTooltip => 'Lisää / muokkaa / poista linkki';

  @override
  String get toolbarDividerTooltip => 'Lisää erotin';

  @override
  String get toolbarChecklistTooltip => 'Lisää tehtävälista';

  @override
  String get linkSelectTextSnackbar =>
      'Valitse ensin teksti, jonka haluat linkittää';

  @override
  String get linkDialogEditTitle => 'Muokkaa linkkiä';

  @override
  String get linkDialogAddTitle => 'Lisää linkki';

  @override
  String get linkDialogRemoveButton => 'Poista linkki';

  @override
  String get linkDialogCancelButton => 'Peruuta';

  @override
  String get linkDialogConfirmButton => 'Lisää';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Kameran käyttöoikeus evätty. Salli se asetuksista tallentaaksesi videota.';

  @override
  String get cameraPermissionRequiredMessage =>
      'Kameran käyttöoikeus vaaditaan videon tallentamiseen.';

  @override
  String get openSettingsButtonLabel => 'Asetukset';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'Skannausta ei voitu aloittaa: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'Tekstintunnistus epäonnistui: $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'Asiakirjasta ei löytynyt luettavaa tekstiä';

  @override
  String get scanResultSheetTitle => 'Miten skannattu asiakirja lisätään?';

  @override
  String get scanResultTextOnlyOption => 'Lisää vain tekstinä';

  @override
  String get scanResultTextAndImageOption => 'Lisää teksti + skannattu kuva';

  @override
  String get scanResultCancelOption => 'Peruuta';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'Mikrofonin käyttöoikeus evätty. Salli se asetuksista tallentaaksesi ääntä.';

  @override
  String get audioPermissionRequiredMessage =>
      'Mikrofonin käyttöoikeus vaaditaan äänen tallentamiseen.';

  @override
  String get voiceRecordingDefaultLabel => 'Ääninauhoite';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'Laskentalista ($count riviä)';
  }

  @override
  String get blockPreviewDrawingLabel => 'Piirros';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count liitettä (kuva/asiakirja)';
  }

  @override
  String get blockPreviewDividerLabel => 'Erotin';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'Tehtävälista ($count kohdetta)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(tyhjä teksti)';

  @override
  String get reorderBlocksSheetTitle => 'Järjestä lohkot uudelleen';

  @override
  String get reorderBlocksMoveUpTooltip => 'Siirrä ylös';

  @override
  String get reorderBlocksMoveDownTooltip => 'Siirrä alas';

  @override
  String get reorderBlocksCloseTooltip => 'Sulje';

  @override
  String get reorderBlocksDescription =>
      'Napauta lohkoa valitaksesi sen ja siirrä sitä ylös-/alas-nuolilla.';

  @override
  String get reorderBlocksMenuItemLabel => 'Järjestä uudelleen';

  @override
  String get txtImportPickerDialogTitle => 'Valitse tuotava TXT-tiedosto';

  @override
  String get txtImportReadFailedMessage => 'TXT-tiedostoa ei voitu lukea';

  @override
  String get txtImportEmptyFileMessage => 'TXT-tiedosto on tyhjä';

  @override
  String get txtImportSuccessMessage => 'TXT tuotu';

  @override
  String get txtImportMenuItemLabel => 'Tuo (txt)';

  @override
  String get exportMenuItemLabel => 'Vie';

  @override
  String get editorUndoTooltip => 'Kumoa';

  @override
  String get editorRedoTooltip => 'Tee uudelleen';

  @override
  String get noteSavedMessage => 'Muistiinpano tallennettu';

  @override
  String get dateAssignPickerHelpText => 'Määritä muistiinpano päivälle';

  @override
  String get dateAssignChangeOption => 'Muuta päivämäärää';

  @override
  String get dateAssignRemoveOption => 'Poista määritys';

  @override
  String get editorSubToolbarCloseTooltip => 'Sulje';

  @override
  String get titleFieldHint => 'Otsikko';

  @override
  String get textBlockHint => 'Kirjoita muistiinpanosi tähän...';

  @override
  String get drawingBoardMenuItemLabel => 'Piirustustaulu';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'Puheentunnistus on käytettävissä vain tekstimuistiinpanoille';

  @override
  String get selectionModeCancelTooltip => 'Peruuta valinta';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return '$count valittu';
  }

  @override
  String get selectionModeDeleteTooltip => 'Poista';

  @override
  String get selectionModeArchiveTooltip => 'Arkistoi';

  @override
  String get selectionModeFolderTooltip => 'Kansio';

  @override
  String get searchFieldHint => 'Hae muistiinpanoja...';

  @override
  String get emptyTrashDialogTitle => 'Tyhjennä roskakori';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'Kaikki poistetut muistiinpanot poistetaan pysyvästi. Oletko varma?';

  @override
  String get emptyTrashDialogCancelButton => 'Peruuta';

  @override
  String get restoreAllMenuItemLabel => 'Palauta kaikki';

  @override
  String get sortMenuTooltip => 'Lajittele muistiinpanot';

  @override
  String get sortMenuAscendingLabel => 'Järjestys: Nouseva (A-Ö)';

  @override
  String get sortMenuDescendingLabel => 'Järjestys: Laskeva (Ö-A)';

  @override
  String get sortMenuByTitleLabel => 'Lajitteluperuste: Otsikko';

  @override
  String get sortMenuByModifiedDateLabel =>
      'Lajitteluperuste: Viimeksi muokattu';

  @override
  String get sortMenuByCreatedDateLabel => 'Lajitteluperuste: Luontipäivä';

  @override
  String get sortMenuByFolderLabel => 'Lajitteluperuste: Kansio';

  @override
  String get viewToggleGridTooltip => 'Ruudukkonäkymä';

  @override
  String get viewToggleListTooltip => 'Luettelonäkymä';

  @override
  String get drawerHeaderSubtitle => 'Henkilökohtainen muistikirjasi';

  @override
  String get drawerNotesSectionHeader => 'MUISTIINPANOT';

  @override
  String get drawerAllNotesLabel => 'Muistiinpanot';

  @override
  String get drawerFavoritesLabel => 'Suosikki';

  @override
  String get drawerAgendaLabel => 'Ajankohtaiset';

  @override
  String get drawerRemindersLabel => 'Muistutus';

  @override
  String get drawerLockedLabel => 'Lukittu';

  @override
  String get drawerTrashLabel => 'Roskakori';

  @override
  String get drawerFoldersSectionHeader => 'KANSIOT';

  @override
  String get drawerExpandLabel => 'Laajenna';

  @override
  String get drawerCollapseLabel => 'Tiivistä';

  @override
  String get drawerAddFolderLabel => 'Lisää kansio';

  @override
  String get drawerAppSectionHeader => 'SOVELLUS';

  @override
  String get drawerCalendarLabel => 'Kalenteri';

  @override
  String get drawerSettingsLabel => 'Asetukset';

  @override
  String get drawerBackupRestoreLabel => 'Varmuuskopiointi ja palautus';

  @override
  String get drawerUpgradeToProLabel => 'Päivitä Pro-versioon';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'Tue kehitystä';

  @override
  String get drawerFeedbackLabel => 'Palaute';

  @override
  String get drawerAboutLabel => 'Tietoja';

  @override
  String get noNotesFoundMessage => 'Muistiinpanoja ei löytynyt.';

  @override
  String get trashRestoreButtonLabel => 'Palauta';

  @override
  String get trashPermanentDeleteButtonLabel => 'Poista pysyvästi';

  @override
  String get tagRenamedInfoMessage => 'Tunnisteen nimi vaihdettu';

  @override
  String get tagDeletedInfoMessage => 'Tunniste poistettu';

  @override
  String get tagOptionsRenameLabel => 'Nimeä uudelleen';

  @override
  String get tagOptionsDeleteLabel => 'Poista';

  @override
  String get renameTagDialogTitle => 'Nimeä tunniste uudelleen';

  @override
  String get renameTagDialogHint => 'Uusi tunnisteen nimi';

  @override
  String get renameTagDialogCancelButton => 'Peruuta';

  @override
  String get renameTagDialogSaveButton => 'Tallenna';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '\"$tag\" poistetaan $affectedCount muistiinpanosta. Jatketaanko?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'Poistetaanko tunniste \"$tag\"?';
  }

  @override
  String get deleteTagDialogTitle => 'Poista tunniste';

  @override
  String get deleteTagDialogCancelButton => 'Peruuta';

  @override
  String get deleteTagDialogConfirmButton => 'Poista';

  @override
  String get tagsSheetTitle => 'Tunnisteet';

  @override
  String get tagsSheetEmptyMessage =>
      'Tällä muistiinpanolla ei ole vielä tunnisteita.';

  @override
  String get tagsSheetInputHint => 'Kirjoita uusi tunniste...';

  @override
  String get tagsSheetSuggestionsLabel => 'Olemassa olevat tunnisteet';

  @override
  String get noteDeletedInfoMessage => 'Muistiinpano poistettu';

  @override
  String get noteDeletedUndoActionLabel => 'Kumoa';

  @override
  String get reminderSetInfoMessage => 'Muistutus asetettu';

  @override
  String get reminderRemovedInfoMessage => 'Muistutus poistettu';

  @override
  String get noteDuplicatedInfoMessage => 'Kopio luotu';

  @override
  String get speechTextAppendedInfoMessage => 'Teksti lisätty muistiinpanoon';

  @override
  String get pdfPreparingInfoMessage => 'Valmistellaan PDF:ää…';

  @override
  String get pdfSavedInfoMessage => 'PDF tallennettu';

  @override
  String get jpgPreparingInfoMessage => 'Valmistellaan JPG:tä…';

  @override
  String get jpgSavedInfoMessage => 'JPG tallennettu';

  @override
  String get jpgFailedInfoMessage => 'JPG:tä ei voitu luoda';

  @override
  String get txtPreparingInfoMessage => 'Valmistellaan TXT:tä…';

  @override
  String get txtSavedInfoMessage => 'TXT tallennettu';

  @override
  String get txtFailedInfoMessage => 'TXT:tä ei voitu luoda';

  @override
  String get exportOpenActionLabel => 'Avaa';

  @override
  String get wrongPasswordInfoMessage => 'Väärä salasana.';

  @override
  String get noteArchivedInfoMessage => 'Muistiinpano arkistoitu';

  @override
  String get noteUnarchivedInfoMessage => 'Poistettu arkistosta';

  @override
  String get noteUnlockedInfoMessage => 'Avattu';

  @override
  String get noteLockedInfoMessage => 'Muistiinpano lukittu';

  @override
  String get notificationUnpinnedInfoMessage => 'Kiinnitys poistettu';

  @override
  String get emptyNotePinBlockedInfoMessage =>
      'Tyhjää muistiinpanoa ei voi kiinnittää.';

  @override
  String get notificationPinnedInfoMessage => 'Kiinnitetty ilmoituspaneeliin';

  @override
  String get noContentToReadInfoMessage => 'Ei luettavaa sisältöä';

  @override
  String get backPressExitInfoMessage =>
      'Paina takaisin-painiketta uudelleen poistuaksesi';

  @override
  String get reminderChannelName => 'Muistiinpanomuistutukset';

  @override
  String get reminderChannelDescription =>
      'Muistiinpanomuistutukset Layout-sovelluksessa';

  @override
  String get pinnedChannelName => 'Kiinnitetyt muistiinpanot';

  @override
  String get pinnedChannelDescription =>
      'Ilmoituspaneeliin kiinnitetyt Layout-muistiinpanot';

  @override
  String get notificationUnpinActionLabel => 'Poista';

  @override
  String get reminderDefaultTitle => 'Muistutus';

  @override
  String get reminderChecklistBodyFallback =>
      'Älä unohda tarkistaa tehtävälistaasi';

  @override
  String get reminderTextBodyFallback => 'Älä unohda tarkistaa muistiinpanoasi';

  @override
  String get pdfSaveDialogTitle => 'Tallenna PDF:nä';

  @override
  String get jpgSaveDialogTitle => 'Tallenna JPG:nä';

  @override
  String get txtSaveDialogTitle => 'Tallenna TXT:nä';

  @override
  String get textSizeSheetTitle => 'Tekstin koko';

  @override
  String get textSizeSamplePreview => 'Näyteteksti';

  @override
  String get textSizeCancelButton => 'Peruuta';

  @override
  String get textSizeApplyButton => 'Käytä';

  @override
  String get createPasswordDialogTitle => 'Luo salasana';

  @override
  String get createPasswordNewPasswordHint => 'Uusi salasana';

  @override
  String get createPasswordConfirmHint => 'Anna salasana uudelleen';

  @override
  String get createPasswordHintQuestionDescription =>
      'Aseta turvakysymys siltä varalta, että unohdat salasanasi (valinnainen).';

  @override
  String get createPasswordHintQuestionHint => 'Valitse turvakysymys';

  @override
  String get createPasswordHintAnswerHint => 'Vastauksesi';

  @override
  String get createPasswordCancelButton => 'Peruuta';

  @override
  String get createPasswordSaveButton => 'Tallenna';

  @override
  String get passwordMismatchMessage => 'Salasanat eivät täsmää!';

  @override
  String get passwordRequiredDialogTitle => 'Salasana vaaditaan';

  @override
  String get passwordRequiredHint => 'Anna salasana';

  @override
  String get forgotPasswordButtonLabel => 'Unohdin salasanani';

  @override
  String get passwordRequiredCancelButton => 'Peruuta';

  @override
  String get passwordRequiredConfirmButton => 'Vahvista';

  @override
  String get securityQuestionDialogTitle => 'Turvakysymys';

  @override
  String get securityQuestionAnswerHint => 'Vastauksesi';

  @override
  String get securityQuestionCancelButton => 'Peruuta';

  @override
  String get securityQuestionConfirmButton => 'Vahvista';

  @override
  String get securityQuestionWrongAnswerMessage =>
      'Väärä vastaus. Yritä uudelleen.';

  @override
  String get revealedPasswordDialogTitle => 'Salasanasi';

  @override
  String get revealedPasswordLabel => 'Muistiinpanon salasanasi:';

  @override
  String get revealedPasswordOkButton => 'OK';

  @override
  String get securityQuestionPetName => 'Mikä on ensimmäisen lemmikkisi nimi?';

  @override
  String get securityQuestionFavoriteTeacher =>
      'Mikä on suosikkiopettajasi nimi?';

  @override
  String get securityQuestionBirthCity => 'Missä kaupungissa synnyit?';

  @override
  String get securityQuestionFavoriteFood => 'Mikä on lempiruokasi?';

  @override
  String get securityQuestionMotherMaidenName => 'Mikä on äitisi tyttönimi?';

  @override
  String get securityQuestionFirstSchool =>
      'Mikä oli ensimmäisen koulusi nimi?';

  @override
  String get securityQuestionFavoriteColor => 'Mikä on lempivärisi?';

  @override
  String get editFolderDialogTitle => 'Muokkaa kansiota';

  @override
  String get newSubfolderDialogTitle => 'Uusi alikansio';

  @override
  String get addFolderDialogTitle => 'Lisää kansio';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'Luodaan kansion \"$parentCategory\" sisään';
  }

  @override
  String get subfolderNameFieldLabel => 'Alikansion nimi';

  @override
  String get folderNameFieldLabel => 'Kansion nimi';

  @override
  String get folderColorLabel => 'Väri';

  @override
  String get folderDialogCancelButton => 'Peruuta';

  @override
  String get folderDialogSaveButton => 'Tallenna';

  @override
  String get folderDialogAddButton => 'Lisää';

  @override
  String get selectFolderSheetTitle => 'Valitse kansio';

  @override
  String get selectFolderAddOptionLabel => 'Lisää kansio';

  @override
  String get removeCurrentFolderLabel => 'Poista nykyinen kansio';

  @override
  String get noteDetailsDialogTitle => 'Tiedot';

  @override
  String get noteDetailsCreatedLabel => 'Luotu';

  @override
  String get noteDetailsModifiedLabel => 'Viimeksi muokattu';

  @override
  String get noteDetailsCharCountLabel => 'Merkkien määrä';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count merkkiä';
  }

  @override
  String get noteDetailsWordCountLabel => 'Sanojen määrä';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count sanaa';
  }

  @override
  String get noteDetailsOkButton => 'OK';

  @override
  String get noteDetailsUnknownDateLabel => 'Tuntematon';

  @override
  String get addAttachmentSheetTitle => 'Lisää';

  @override
  String get addAttachmentImageOption => 'Lisää kuva';

  @override
  String get addAttachmentCameraOption => 'Kamera';

  @override
  String get addAttachmentFileOption => 'Lisää tiedosto';

  @override
  String get addAttachmentVoiceOption => 'Ääninauhoite';

  @override
  String get addAttachmentVideoOption => 'Nauhoita video';

  @override
  String get addAttachmentScanOption => 'Skannaa asiakirja';

  @override
  String get noteActionsSheetTitle => 'Valitse toiminto';

  @override
  String get noteActionReminderLabel => 'Muistutus';

  @override
  String get noteActionEditReminderLabel => 'Muokkaa muistutusta';

  @override
  String get noteActionSpeechToTextLabel => 'Puheentunnistus';

  @override
  String get noteActionArchiveLabel => 'Arkistoi';

  @override
  String get noteActionUnarchiveLabel => 'Poista arkistosta';

  @override
  String get noteActionLockLabel => 'Lukitse';

  @override
  String get noteActionUnlockLabel => 'Avaa lukitus';

  @override
  String get noteActionFavoriteLabel => 'Suosikki';

  @override
  String get noteActionUnfavoriteLabel => 'Poista suosikeista';

  @override
  String get noteActionClassifyLabel => 'Valitse kansio';

  @override
  String get noteActionDeleteLabel => 'Poista';

  @override
  String get noteActionPinToNotificationLabel => 'Kiinnitä ilmoituspaneeliin';

  @override
  String get noteActionUnpinFromNotificationLabel => 'Poista kiinnitys';

  @override
  String get noteActionShareLabel => 'Jaa';

  @override
  String get noteActionDuplicateLabel => 'Luo kopio';

  @override
  String get noteActionCopyContentLabel => 'Kopioi sisältö';

  @override
  String get noteActionTtsLabel => 'Lue ääneen';

  @override
  String get noteActionTextSizeLabel => 'Tekstin koko';

  @override
  String get noteActionDetailsLabel => 'Tiedot';

  @override
  String get noteActionDiscardChangesLabel => 'Hylkää muutokset';

  @override
  String get noteActionSelectLabel => 'Valitse';

  @override
  String get reminderEditOptionLabel => 'Muuta muistutusta';

  @override
  String get reminderRemoveOptionLabel => 'Poista muistutus';

  @override
  String get discardChangesDialogTitle => 'Hylkää muutokset';

  @override
  String get discardChangesDialogMessage =>
      'Tämän muistiinpanon tallentamattomat muutokset menetetään. Haluatko varmasti hylätä ne?';

  @override
  String get discardChangesCancelButton => 'Peruuta';

  @override
  String get discardChangesConfirmButton => 'Hylkää';

  @override
  String get pinnedNotificationDefaultTitle => 'Muistiinpano';

  @override
  String get pdfFailedInfoMessage => 'PDF:n luonti epäonnistui';

  @override
  String get drawingScreenTitle => 'Piirros';

  @override
  String get drawingMinimizeTooltip => 'Pienennä';

  @override
  String get drawingEmptyExportWarningMessage => 'Piirrä ensin jotain';

  @override
  String get drawingEraserPartialModeLabel => 'Osittainen';

  @override
  String get drawingEraserFullModeLabel => 'Täysi';

  @override
  String get drawingClearTooltip => 'Tyhjennä';

  @override
  String get drawingZoomOutTooltip => 'Loitonna';

  @override
  String get drawingZoomInTooltip => 'Lähennä';

  @override
  String get drawingDeleteTooltip => 'Poista';

  @override
  String get drawingEmptyPreviewHint => 'Napauta piirtääksesi';

  @override
  String get settingsPageTitle => 'Asetukset';

  @override
  String get settingsSectionGeneral => 'Yleiset';

  @override
  String get settingsSectionSecurity => 'Turvallisuus';

  @override
  String get settingsSectionTheme => 'Teema';

  @override
  String get settingsSectionPersonalization => 'Mukauttaminen';

  @override
  String get settingsSectionWidget => 'Widget';

  @override
  String get settingsSectionAbout => 'Tietoja';

  @override
  String get settingsHintQuestionPet => 'Mikä on ensimmäisen lemmikkisi nimi?';

  @override
  String get settingsHintQuestionTeacher => 'Mikä on suosikkiopettajasi nimi?';

  @override
  String get settingsHintQuestionBirthCity => 'Missä kaupungissa synnyit?';

  @override
  String get settingsHintQuestionFavoriteFood => 'Mikä on lempiruokasi?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'Mikä on äitisi tyttönimi?';

  @override
  String get settingsHintQuestionFirstSchool => 'Mikä oli ensimmäinen koulusi?';

  @override
  String get settingsHintQuestionFavoriteColor => 'Mikä on lempivärisi?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'Turvakysymys';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'Jos unohdat salasanasi, voit palauttaa sen vastaamalla tähän kysymykseen oikein.';

  @override
  String get settingsSecurityQuestionDropdownHint => 'Valitse turvakysymys';

  @override
  String get settingsSecurityQuestionAnswerHint => 'Vastauksesi';

  @override
  String get settingsSecurityQuestionCancelButton => 'Peruuta';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'Kysymys ja vastaus eivät voi olla tyhjiä!';

  @override
  String get settingsSecurityQuestionSaveButton => 'Tallenna';

  @override
  String get settingsCreatePasswordTitle => 'Luo salasana';

  @override
  String get settingsPasswordRequiredTitle => 'Salasana vaaditaan';

  @override
  String get settingsPasswordEnterHint => 'Anna salasana';

  @override
  String get settingsForgotPasswordButton => 'Unohdin salasanani';

  @override
  String get settingsNewPasswordHint => 'Uusi salasana';

  @override
  String get settingsConfirmPasswordHint => 'Anna salasana uudelleen';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'Aseta turvakysymys siltä varalta, että unohdat salasanasi (valinnainen).';

  @override
  String get settingsPasswordDialogCancelButton => 'Peruuta';

  @override
  String get settingsPasswordMismatchWarning => 'Salasanat eivät täsmää!';

  @override
  String get settingsWrongPasswordWarning => 'Väärä salasana!';

  @override
  String get settingsPasswordSaveButton => 'Tallenna';

  @override
  String get settingsPasswordRemoveButton => 'Poista';

  @override
  String get settingsNotePasswordTitle => 'Muistiinpanon salasana';

  @override
  String get settingsPasswordSetSubtitle => 'Salasana asetettu ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'Salasanaa ei ole asetettu';

  @override
  String get settingsSecurityQuestionTileTitle => 'Turvakysymys';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'Asetettu ✓ — käytetään, jos unohdat salasanasi';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'Ei asetettu — et voi palauttaa salasanaasi, jos se katoaa';

  @override
  String get settingsThemeDialogTitle => 'Valitse teema';

  @override
  String get settingsThemeSystemDefault => 'Järjestelmän oletus';

  @override
  String get settingsThemeLightOption => 'Vaalea teema';

  @override
  String get settingsThemeDarkOption => 'Tumma teema';

  @override
  String get settingsLanguageDialogTitle => 'Valitse kieli';

  @override
  String get settingsLanguageSystemOption => 'Järjestelmä';

  @override
  String get settingsAccentColorDialogTitle => 'Valitse korostusväri';

  @override
  String get settingsThemeChangeTileTitle => 'Vaihda teema';

  @override
  String get settingsThemeLightLabel => 'Vaalea';

  @override
  String get settingsThemeDarkLabel => 'Tumma';

  @override
  String get settingsThemeSystemLabel => 'Järjestelmä';

  @override
  String get settingsLanguageTileTitle => 'Kieli';

  @override
  String get settingsAccentColorTileTitle => 'Korostusväri';

  @override
  String get settingsAccentColorTileSubtitle =>
      'Väri, jota käytetään sovelluspalkissa, painikkeissa ja kytkimissä';

  @override
  String get settingsColorfulNotesTitle => 'Vaihtelevat muistiinpanovärit';

  @override
  String get settingsColorfulNotesSubtitle =>
      'Jokainen muistiinpanokortti saa eri värisävyn.';

  @override
  String get settingsTextColorSheetTitle => 'Tekstin väri';

  @override
  String get settingsTextColorSheetDesc =>
      'Määrittää muistiinpanon sisältötekstin värin.';

  @override
  String get settingsTextColorOkButton => 'OK';

  @override
  String get settingsTextColorTileTitle => 'Tekstin väri';

  @override
  String get settingsTextColorTileSubtitle =>
      'Muistiinpanon sisältötekstin väri.';

  @override
  String get settingsWidgetFontSizeLabel => 'Widgetin fonttikoko';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'Esimerkkiotsikko - $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'Peruuta';

  @override
  String get settingsWidgetFontSizeApplyButton => 'Käytä';

  @override
  String get settingsWidgetOpacityLabel => 'Taustan läpinäkyvyys';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return '$percent% läpinäkyvyys';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'Peruuta';

  @override
  String get settingsWidgetOpacityApplyButton => 'Käytä';

  @override
  String get settingsWidgetDarkModeTitle => 'Tumma widget';

  @override
  String get settingsWidgetDarkModeDesc => 'Tumma väriteema widgetille.';

  @override
  String get settingsAboutVersionTitle => 'Sovelluksen versio';

  @override
  String get settingsFontFamilyTileTitle => 'Fontti';

  @override
  String get settingsFontFamilyDefaultLabel => 'Oletus';

  @override
  String get settingsGlobalFontSizeTileTitle => 'Fonttikoko';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt — käytetään kaikissa muistiinpanoissa.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'Näyteteksti - $size pt';
  }

  @override
  String get settingsGlobalFontSizeApplyToAllLabel =>
      'Käytä olemassa oleviin muistiinpanoihin';

  @override
  String get settingsGlobalFontSizeApplyToAllNote =>
      'Jos muistiinpanolle on asetettu erillinen fonttikoko, tämä asetus ei vaikuta siihen.';

  @override
  String get settingsGlobalFontSizeCancelButton => 'Peruuta';

  @override
  String get settingsGlobalFontSizeApplyButton => 'Käytä';

  @override
  String get settingsPreviewLinesTileTitle => 'Muistiinpanon esikatselurivit';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'Näytä enintään $lines riviä. Jos muistiinpano on lyhyempi, näytetään todellinen rivimäärä.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'Nykyinen: $lines riviä';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'Määrittää esikatseltavien rivien enimmäismäärän. Jos muistiinpanossa on vähemmän rivejä, näytetään todellinen rivimäärä.';

  @override
  String get settingsPreviewLinesCancelButton => 'Peruuta';

  @override
  String get settingsPreviewLinesApplyButton => 'Käytä';

  @override
  String get backupCancelButton => 'Peruuta';

  @override
  String get backupConnectButton => 'Yhdistä';

  @override
  String get backupDisconnectButton => 'Katkaise yhteys';

  @override
  String get backupContinueButton => 'Jatka';

  @override
  String get backupCloseButton => 'Sulje';

  @override
  String get backupShareButton => 'Jaa';

  @override
  String get backupRestoreButton => 'Palauta';

  @override
  String get backupConfigureButton => 'Määritä';

  @override
  String get backupUnknownDateLabel => 'Tuntematon';

  @override
  String get backupProcessingDefaultLabel => 'Käsitellään...';

  @override
  String get backupPermissionRequiredTitle =>
      'Tallennustilan käyttöoikeus vaaditaan';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'Tämä Android-versio vaatii tallennustilan käyttöoikeuden varmuuskopiointia/palautusta varten. Koska käyttöoikeus evättiin pysyvästi, ota se käyttöön manuaalisesti sovelluksen asetuksista.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'Tämä Android-versio vaatii tallennustilan käyttöoikeuden varmuuskopiointia/palautusta varten. Myönnä käyttöoikeus jatkaaksesi.';

  @override
  String get backupGoToSettingsButton => 'Siirry asetuksiin';

  @override
  String get backupRetryButton => 'Yritä uudelleen';

  @override
  String get backupDriveConnectingLabel => 'Yhdistetään Google-tiliin...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Yhdistetty Google Drive -tiliin: $email';
  }

  @override
  String get backupDriveConnectedMessage => 'Yhdistetty Google Drive -tiliin.';

  @override
  String get backupDriveConnectFailedMessage =>
      'Google-tiliin ei voitu yhdistää, tai toiminto peruutettiin.';

  @override
  String get backupDriveDisconnectTitle => 'Katkaise yhteys Google Driveen';

  @override
  String get backupDriveDisconnectBody =>
      'Jos katkaiset yhteyden, manuaaliset tai automaattiset varmuuskopiot Driveen eivät ole mahdollisia. Driveen jo tallennettuja varmuuskopioita ei poisteta — vain pääsy tältä laitteelta poistetaan.';

  @override
  String get backupDriveDisconnectedMessage =>
      'Google Drive -yhteys poistettu.';

  @override
  String get backupDriveRequiredTitle => 'Google-tili vaaditaan';

  @override
  String get backupDriveRequiredBody =>
      'Tämä toiminto vaatii Google-tilin yhdistämisen. Haluatko yhdistää nyt?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: yhdistetty ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: yhdistetty';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: ei yhdistetty';

  @override
  String get backupDriveAuthenticatingLabel => 'Vahvistetaan Google-tiliä...';

  @override
  String get backupDriveNotSignedInMessage =>
      'Et ole yhteydessä Google Driveen. Kirjaudu ensin sisään Google-tilillä.';

  @override
  String get backupDriveUploadingLabel => 'Ladataan varmuuskopiota Driveen...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Lataus Google Driveen ei valmistunut 120 sekunnin kuluessa (ei vastausta palvelimelta). Tarkista yhteytesi ja yritä uudelleen.';

  @override
  String get backupDriveOperationCompletedLabel => 'Valmis';

  @override
  String get backupToDriveActionLabel => 'varmuuskopiointi Driveen';

  @override
  String get backupToDeviceActionLabel => 'varmuuskopiointi';

  @override
  String get backupCreatingLabel => 'Luodaan varmuuskopiota...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'Varmuuskopiota ei voitu luoda: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Lataus Google Driveen epäonnistui: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'Varmuuskopio ladattu onnistuneesti Google Driveen.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'Varmuuskopio luotu: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'Varmuuskopio valmis';

  @override
  String get backupOfferShareBody =>
      'Varmuuskopiotiedostosi on tallennettu laitteellesi. Haluatko jakaa sen nyt (esim. pilvitallennus, sähköposti, toinen laite)?';

  @override
  String get backupShareFileText => 'layout-varmuuskopiotiedosto';

  @override
  String backupShareFailedMessage(String error) {
    return 'Jakamista ei voitu aloittaa: $error';
  }

  @override
  String get backupLargeOperationTitle => 'Suuri varmuuskopio';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'Käsiteltävän datan koko on noin $sizeText. Tämän kokoinen $actionLabel voi kestää hetken laitteestasi riippuen. Älä poistu sovelluksesta sen ollessa käynnissä — haluatko jatkaa?';
  }

  @override
  String get backupRestoreActionLabel => 'palautus';

  @override
  String get backupDriveListingLabel => 'Luetellaan Drive-varmuuskopioita...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'Varmuuskopioita ei voitu luetella: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'Google Drivessa ei ole vielä varmuuskopioita.';

  @override
  String get backupDrivePickTitle => 'Valitse varmuuskopio Drivesta';

  @override
  String get backupDriveDownloadingLabel =>
      'Ladataan varmuuskopiota Drivesta...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Ladataan varmuuskopiota Drivesta... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel =>
      'Tallennetaan tiedostoa laitteelle...';

  @override
  String get backupDriveUnknownBackupFileName => 'tuntematon_varmuuskopio.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Google Drive -tallennustilasi on täynnä. Vapauta tilaa Drivesta ja yritä uudelleen.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'Internetyhteyttä ei voitu muodostaa. Tarkista yhteytesi ja yritä uudelleen.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'Määritettyä varmuuskopiotiedostoa ei löytynyt Drivesta. Se on saatettu poistaa.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Google Drive -toiminnon aikana tapahtui odottamaton virhe: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'Lataus epäonnistui: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'Tiedostoa ei voitu valita: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'Valittuun tiedostoon ei päästy käsiksi.';

  @override
  String get backupCheckingLabel => 'Tarkistetaan varmuuskopiota...';

  @override
  String backupReadFailedMessage(String error) {
    return 'Varmuuskopiotiedostoa ei voitu lukea: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'Palauta varmuuskopio';

  @override
  String get backupPreviewContentsHeader => 'Valitun varmuuskopion sisältö:';

  @override
  String get backupPreviewNoteCountLabel => 'Muistiinpanojen määrä';

  @override
  String get backupPreviewTrashCountLabel => 'Muistiinpanoja roskakorissa';

  @override
  String get backupPreviewCategoryCountLabel => 'Kategorioiden määrä';

  @override
  String get backupPreviewAttachmentLabel => 'Liitteet';

  @override
  String get backupPreviewAttachmentNoneValue => 'Ei mitään';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count tiedostoa ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'Luotu';

  @override
  String get backupEmptyPreviewTitle => 'Tämä varmuuskopio näyttää tyhjältä';

  @override
  String get backupEmptyPreviewBody =>
      'Valitusta tiedostosta ei löytynyt muistiinpanoja, kategorioita tai liitteitä. Jos jatkat, nykyiset tietosi poistetaan silti ja korvataan tällä tyhjällä varmuuskopiolla.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '$count liitettä ei löytynyt varmuuskopiosta';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'Näiden tiedostojen muistiinpanot palautetaan, mutta ilman liitteitä (ne ovat saattaneet puuttua tai olla vioittuneet varmuuskopiota otettaessa): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown ja $remaining muuta';
  }

  @override
  String get backupRestoreConfirmBody =>
      'Tämä KORVAA kaikki nykyiset muistiinpanosi, roskakorin, kategoriat, asetukset ja liitteet yllä olevan varmuuskopion tiedoilla. Nykyiset tietosi menetetään pysyvästi, eikä tätä toimintoa voi peruuttaa.';

  @override
  String get backupRestoringLabel => 'Palautetaan varmuuskopiota...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'Varmuuskopio palautettu. $count liitettä ei kuitenkaan löytynyt varmuuskopiosta, eikä niitä voitu palauttaa. Sovelluksen uudelleenkäynnistystä suositellaan, jotta muutokset tulevat täysin voimaan.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'Varmuuskopio palautettu onnistuneesti. Sovelluksen uudelleenkäynnistystä suositellaan, jotta muutokset tulevat täysin voimaan.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'Palautuksen aikana tapahtui virhe: $error';
  }

  @override
  String get backupScreenTitle => 'Varmuuskopiointi ja palautus';

  @override
  String get backupBlockedExitWarningMessage =>
      'Toiminto on käynnissä, odota sen valmistumista.';

  @override
  String get backupBusyBackTooltip => 'Toiminto käynnissä';

  @override
  String get backupIntroText =>
      'Voit varmuuskopioida muistiinpanosi, kategoriasi, asetuksesi ja liitteesi yhtenä .zip-tiedostona tai palauttaa aiemmin ottamasi varmuuskopion.';

  @override
  String get backupDriveCardTitle => 'Varmuuskopioi Google Driveen';

  @override
  String get backupDriveCardSubtitle =>
      'Luo uusi varmuuskopio ja lataa se suoraan Google Drivesi yksityiselle alueelle.';

  @override
  String get backupDriveCardButtonLabel => 'Varmuuskopioi Driveen';

  @override
  String get backupDeviceCardTitle => 'Varmuuskopioi laitteeseen';

  @override
  String get backupDeviceCardSubtitle =>
      'Tallenna kaikki tietosi yhtenä .zip-tiedostona laitteellesi ja jaa se halutessasi.';

  @override
  String get backupDeviceCardButtonLabel => 'Varmuuskopioi laitteeseen';

  @override
  String get backupHistoryCardTitle => 'Varmuuskopiohistoria';

  @override
  String get backupHistoryCardSubtitle =>
      'Näytä kaikki laitteellesi tallennetut varmuuskopiot päivämäärineen ja kokoineen; voit jakaa, palauttaa tai poistaa ne suoraan täältä.';

  @override
  String get backupHistoryTabDevice => 'Laite';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'Poista varmuuskopio';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'Haluatko varmasti poistaa varmuuskopiotiedoston \"$fileName\" pysyvästi? Tätä toimintoa ei voi peruuttaa.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'Varmuuskopio poistettu.';

  @override
  String get backupHistoryDriveDeleteDialogTitle => 'Poista Drive-varmuuskopio';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'Haluatko varmasti poistaa varmuuskopion \"$fileName\" pysyvästi Google Drivesta? Tätä toimintoa ei voi peruuttaa, eikä tiedostoa siirretä roskakoriin.';
  }

  @override
  String get backupHistoryDriveDeletedMessage =>
      'Drive-varmuuskopio poistettu.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'Poistaminen epäonnistui: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'Tälle laitteelle ei ole vielä tallennettu varmuuskopioita.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'Käytä \"Varmuuskopioi laitteeseen\" luodaksesi ensimmäisen varmuuskopiosi.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'Käytä \"Varmuuskopioi Google Driveen\" luodaksesi ensimmäisen pilvivarmuuskopiosi.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Yhdistä Google-tilisi nähdäksesi Drive-varmuuskopiosi.';

  @override
  String get backupHistoryConnectGoogleButton => 'Yhdistä Google-tilillä';

  @override
  String get backupHistoryDriveConnectedFallback => 'Yhdistetty';

  @override
  String get backupHistoryUnknownErrorFallback => 'Tapahtui tuntematon virhe.';

  @override
  String get backupHistoryDownloadStartingLabel => 'Aloitetaan...';

  @override
  String get backupAutoBackupEnabledLabel =>
      'Automaattinen varmuuskopiointi: päällä';

  @override
  String get backupAutoBackupDisabledLabel =>
      'Automaattinen varmuuskopiointi: pois';

  @override
  String get backupOverlayWarningMessage =>
      'Odota hetki, älä poistu sovelluksesta ennen kuin toiminto on valmis.';

  @override
  String get pdfExportUntitledNoteLabel => 'Nimetön muistiinpano';

  @override
  String get pdfExportDefaultAttachmentName => 'Liite';

  @override
  String get pdfExportDefaultFileName => 'muistiinpano';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'Kuvakaappausta ei voitu ottaa (rajaa ei löytynyt)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'Kuvakaappausdataa ei voitu luoda';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'Kuvaa ei voitu käsitellä (PNG-purku epäonnistui)';

  @override
  String get screenshotCalcTableTotalLabel => 'Yhteensä';

  @override
  String get gundemMenuRemoveFromAgenda => 'Poista ajankohtaisista';

  @override
  String get gundemMenuDeleteNote => 'Poista muistiinpano';

  @override
  String get gundemSectionOverdue => 'Myöhässä';

  @override
  String get gundemSectionToday => 'Tänään';

  @override
  String get gundemSectionTomorrow => 'Huomenna';

  @override
  String get gundemSectionNextWeek => 'Ensi viikolla';

  @override
  String get gundemSectionFurther => 'Myöhemmin';

  @override
  String get gundemWeekdayMonday => 'Maanantai';

  @override
  String get gundemWeekdayTuesday => 'Tiistai';

  @override
  String get gundemWeekdayWednesday => 'Keskiviikko';

  @override
  String get gundemWeekdayThursday => 'Torstai';

  @override
  String get gundemWeekdayFriday => 'Perjantai';

  @override
  String get gundemWeekdaySaturday => 'Lauantai';

  @override
  String get gundemWeekdaySunday => 'Sunnuntai';

  @override
  String get gundemAppBarTitle => 'Ajankohtaiset';

  @override
  String get gundemCalendarTooltip => 'Kalenteri';

  @override
  String get gundemEmptyTitle => 'Ei ajankohtaisia tapahtumia';

  @override
  String get gundemEmptySubtitle =>
      'Muistiinpanot, joissa on muistutus tai päivämäärä, näkyvät täällä.';

  @override
  String get gundemUntitledNote => 'Nimetön muistiinpano';

  @override
  String get gundemRepeatHourly => 'Tunneittain';

  @override
  String get gundemRepeatDaily => 'Päivittäin';

  @override
  String get gundemRepeatWeekly => 'Viikoittain';

  @override
  String get gundemRepeatMonthly => 'Kuukausittain';

  @override
  String get gundemRepeatYearly => 'Vuosittain';

  @override
  String get gundemPreviewCalcTableLabel => '[Laskentalista]';

  @override
  String get gundemPreviewDrawingLabel => '[Piirros]';

  @override
  String get gundemPreviewImageLabel => '[Kuva]';

  @override
  String get gundemMonthShortJan => 'Tammi';

  @override
  String get gundemMonthShortFeb => 'Helmi';

  @override
  String get gundemMonthShortMar => 'Maalis';

  @override
  String get gundemMonthShortApr => 'Huhti';

  @override
  String get gundemMonthShortMay => 'Touko';

  @override
  String get gundemMonthShortJun => 'Kesä';

  @override
  String get gundemMonthShortJul => 'Heinä';

  @override
  String get gundemMonthShortAug => 'Elo';

  @override
  String get gundemMonthShortSep => 'Syys';

  @override
  String get gundemMonthShortOct => 'Loka';

  @override
  String get gundemMonthShortNov => 'Marras';

  @override
  String get gundemMonthShortDec => 'Joulu';

  @override
  String get calendarAppBarTitle => 'Kalenteri';

  @override
  String get calendarTodayButton => 'Tänään';

  @override
  String get calendarLegendNoteLabel => 'Muistiinpano';

  @override
  String get calendarLegendReminderLabel => 'Muistutus';

  @override
  String get calendarTodayBadge => 'Tänään';

  @override
  String get calendarEmptyDayMessage =>
      'Ei muistiinpanoja tai muistutuksia tälle päivälle.';

  @override
  String get calendarReminderHourlyLabel => 'Tunneittain';

  @override
  String get calendarMonthJan => 'Tammikuu';

  @override
  String get calendarMonthFeb => 'Helmikuu';

  @override
  String get calendarMonthMar => 'Maaliskuu';

  @override
  String get calendarMonthApr => 'Huhtikuu';

  @override
  String get calendarMonthMay => 'Toukokuu';

  @override
  String get calendarMonthJun => 'Kesäkuu';

  @override
  String get calendarMonthJul => 'Heinäkuu';

  @override
  String get calendarMonthAug => 'Elokuu';

  @override
  String get calendarMonthSep => 'Syyskuu';

  @override
  String get calendarMonthOct => 'Lokakuu';

  @override
  String get calendarMonthNov => 'Marraskuu';

  @override
  String get calendarMonthDec => 'Joulukuu';

  @override
  String get calendarWeekdayShortMon => 'Ma';

  @override
  String get calendarWeekdayShortTue => 'Ti';

  @override
  String get calendarWeekdayShortWed => 'Ke';

  @override
  String get calendarWeekdayShortThu => 'To';

  @override
  String get calendarWeekdayShortFri => 'Pe';

  @override
  String get calendarWeekdayShortSat => 'La';

  @override
  String get calendarWeekdayShortSun => 'Su';

  @override
  String get calendarWeekdayFullMonday => 'Maanantai';

  @override
  String get calendarWeekdayFullTuesday => 'Tiistai';

  @override
  String get calendarWeekdayFullWednesday => 'Keskiviikko';

  @override
  String get calendarWeekdayFullThursday => 'Torstai';

  @override
  String get calendarWeekdayFullFriday => 'Perjantai';

  @override
  String get calendarWeekdayFullSaturday => 'Lauantai';

  @override
  String get calendarWeekdayFullSunday => 'Sunnuntai';

  @override
  String get wrongPasswordDialogTitle => 'Väärä salasana';

  @override
  String get wrongPasswordDialogMessage => 'Antamasi salasana on väärä.';

  @override
  String get commonOkButton => 'OK';

  @override
  String get unlockCategoryAction => 'Avaa lukitus';

  @override
  String get lockCategoryAction => 'Lukitse';

  @override
  String get categoryUnlockedMessage => 'Avattu';

  @override
  String get categoryLockedMessage => 'Kansio lukittu';

  @override
  String get deleteFolderMenuItemLabel => 'Poista kansio';

  @override
  String get deleteFolderDialogTitle => 'Poista kansio';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'Haluatko varmasti poistaa kansion \"$category\" ja kaikki sen alikansiot? Näiden kansioiden muistiinpanot jäävät luokittelemattomiksi.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'Haluatko varmasti poistaa kansion \"$category\"? Tämän kansion muistiinpanot jäävät luokittelemattomiksi.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'Peruuta';

  @override
  String get deleteFolderDialogConfirmButton => 'Poista';

  @override
  String get editCategoryNameColorMenuItemLabel => 'Muokkaa nimeä / väriä';

  @override
  String get addSubfolderMenuItemLabel => 'Luo alikansio';

  @override
  String get expandSubfoldersMenuItemLabel => 'Laajenna alikansiot';

  @override
  String get collapseSubfoldersMenuItemLabel => 'Tiivistä alikansiot';

  @override
  String saveErrorInfoMessage(String error) {
    return 'Tallennusvirhe: $error';
  }

  @override
  String get welcomeNoteTitle => 'Tervetuloa DNoteen! 🚀';

  @override
  String get welcomeNoteContent => 'Uusia ominaisuuksia lisätty!';

  @override
  String get noteListDateGroupToday => 'Tänään';

  @override
  String get noteListDateGroupYesterday => 'Eilen';

  @override
  String get noteListDateGroupLast7Days => 'Viimeiset 7 päivää';

  @override
  String get noteListDateGroupLast30Days => 'Viimeiset 30 päivää';

  @override
  String get reminderRepeatNoneLabel => 'Ei toistoa';

  @override
  String get voiceRecorderPreparingLabel => 'Valmistellaan…';

  @override
  String get voiceRecorderCancelButton => 'Peruuta';

  @override
  String get voiceRecorderStopAddButton => 'Pysäytä ja lisää';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'Mikrofonin käyttöoikeutta ei myönnetty.';

  @override
  String get speechToTextUnavailableMessage =>
      'Puheentunnistus ei ole käytettävissä tällä laitteella.';

  @override
  String get speechToTextPreparingLabel => 'Valmistellaan…';

  @override
  String get speechToTextListeningLabel => 'Kuunnellaan…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'Ala puhua…';

  @override
  String get speechToTextCancelButton => 'Peruuta';

  @override
  String get speechToTextStopAddButton => 'Pysäytä ja lisää';

  @override
  String get textToSpeechNoContentMessage => 'Ei luettavaa sisältöä.';

  @override
  String get textToSpeechReadErrorMessage => 'Lukemisen aikana tapahtui virhe.';

  @override
  String get textToSpeechUnavailableMessage =>
      'Tekstistä puheeksi -toiminto ei ole käytettävissä tällä laitteella.';

  @override
  String get textToSpeechPreparingLabel => 'Valmistellaan…';

  @override
  String get textToSpeechPausedLabel => 'Keskeytetty';

  @override
  String get textToSpeechFinishedLabel => 'Lukeminen valmis';

  @override
  String get textToSpeechReadingLabel => 'Luetaan…';

  @override
  String get textToSpeechCloseErrorButton => 'Sulje';

  @override
  String get textToSpeechReplayButton => 'Lue uudelleen';

  @override
  String get textToSpeechCloseFinishedButton => 'Sulje';

  @override
  String get textToSpeechPauseButton => 'Keskeytä';

  @override
  String get textToSpeechResumeButton => 'Jatka';

  @override
  String get textToSpeechStopButton => 'Pysäytä';

  @override
  String get textToSpeechSpeedSlow => 'Hidas';

  @override
  String get textToSpeechSpeedNormal => 'Normaali';

  @override
  String get textToSpeechSpeedFast => 'Nopea';

  @override
  String get calendarPickerCancelButton => 'Peruuta';

  @override
  String get calendarPickerConfirmButton => 'Valitse';

  @override
  String get calendarPickerClearButton => 'Tyhjennä';

  @override
  String get reminderPickerDialogTitle => 'Lisää muistutus';

  @override
  String get reminderPickerDateTodayOption => 'Tänään';

  @override
  String get reminderPickerDateTomorrowOption => 'Huomenna';

  @override
  String get reminderPickerDatePickOption => 'Valitse päivämäärä';

  @override
  String get reminderRepeatHourlyLabel => 'Joka tunti';

  @override
  String get reminderRepeatDailyLabel => 'Joka päivä';

  @override
  String get reminderRepeatWeeklyLabel => 'Joka viikko';

  @override
  String get reminderRepeatMonthlyLabel => 'Joka kuukausi';

  @override
  String get reminderRepeatYearlyLabel => 'Joka vuosi';

  @override
  String get reminderPickerCalendarHelpText =>
      'Valitse muistutuksen päivämäärä';

  @override
  String get reminderPickerCancelButton => 'PERUUTA';

  @override
  String get reminderPickerSaveButton => 'TALLENNA';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'Menneisyydessä olevaa aikaa ei voi valita';

  @override
  String calcTableTotalLabel(String amount) {
    return 'Yhteensä: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'Valmistellaan tietoja...';

  @override
  String get backupCreatePackagingNotesLabel =>
      'Pakataan muistiinpanoja ja kategorioita...';

  @override
  String get backupCreateReadingAttachmentsLabel => 'Luetaan liitteitä...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'Luetaan liitteitä... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'Pakataan zip-tiedostoa...';

  @override
  String get backupCreateSavingFileLabel => 'Tallennetaan tiedostoa...';

  @override
  String get backupRestoreValidatingLabel => 'Tarkistetaan varmuuskopiota...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'Varmuuskopio tarkistettu, valmistellaan tietoja...';

  @override
  String get backupRestoreWritingNotesLabel => 'Kirjoitetaan muistiinpanoja...';

  @override
  String get backupRestoreWritingTrashLabel => 'Kirjoitetaan roskakoria...';

  @override
  String get backupRestoreTrashWrittenLabel => 'Roskakori kirjoitettu';

  @override
  String get backupRestoreWritingCategoriesLabel =>
      'Kirjoitetaan kategorioita...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'Kategoriat kirjoitettu';

  @override
  String get backupRestoreWritingSettingsLabel => 'Kirjoitetaan asetuksia...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'Asetukset kirjoitettu';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'Siivotaan vanhoja liitteitä...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'Liitteitä ei löytynyt, viimeistellään...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'Palautetaan liitteitä... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'Valmis';

  @override
  String get backupValidationCorruptedFileMessage =>
      'Tiedosto on vioittunut tai se ei ole kelvollinen varmuuskopiotiedosto.';

  @override
  String get backupValidationMissingDataMessage =>
      'Varmuuskopiotiedostosta ei löytynyt tietoja (backup_data.json puuttuu).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'Varmuuskopiotietoja ei voitu lukea (vioittunut JSON).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'Tämä tiedosto ei ole dnote-sovelluksen varmuuskopio.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'Varmuuskopiotiedoston versiotietoja ei voitu lukea.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'Tämä varmuuskopio on uudemmassa muodossa, jota nykyinen sovellusversio ei tue. Päivitä sovellus.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'Varmuuskopiotiedoston versiotiedot ovat virheelliset.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'Varmuuskopiotiedot eivät ole odotetussa muodossa (notes-kenttä puuttuu).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'Varmuuskopiotiedot eivät ole odotetussa muodossa (trash-kenttä puuttuu).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'Varmuuskopiotiedot eivät ole odotetussa muodossa (kategorialista on virheellinen).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'Varmuuskopiotiedot eivät ole odotetussa muodossa (settings-kenttä on virheellinen).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'Varmuuskopiotiedot eivät ole odotetussa muodossa (muistiinpanotietue on virheellinen).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'Varmuuskopiotiedot eivät ole odotetussa muodossa (löytyi muistiinpanotietue ilman tunnusta).';

  @override
  String get backupValidationFileNotFoundMessage =>
      'Varmuuskopiotiedostoa ei löytynyt.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'Laitteella ei ole tarpeeksi vapaata tallennustilaa. Vapauta tilaa ja yritä uudelleen.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'Tiedoston käyttöoikeus evättiin. Tarkista sovelluksen käyttöoikeudet ja yritä uudelleen.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'Tiedostotoiminnon aikana tapahtui virhe: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'Odottamaton virhe tapahtui: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'Zip-arkistoa ei voitu luoda (ZipEncoder palautti nullin).';

  @override
  String get calcTableMenuItemLabel => 'Laskentalista';

  @override
  String get tagsMenuItemLabel => 'Tunnisteet';

  @override
  String get linkDialogUrlHint => 'https://example.com';

  @override
  String get checklistItemHint => 'Lisää kohde...';

  @override
  String get toolbarHighlightTooltip => 'Korostus';

  @override
  String get toolbarListTooltip => 'Luettelo';

  @override
  String get toolbarHideKeyboardTooltip => 'Piilota näppäimistö';

  @override
  String get autoBackupLocalSuccessMessage =>
      'Paikallinen varmuuskopiointi onnistui.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'Paikallinen varmuuskopiointi epäonnistui: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Drive-varmuuskopiointi ohitettu: Google-tiliä ei ole yhdistetty tai istunto on vanhentunut. Avaa sovellus ja yhdistä uudelleen.';

  @override
  String get autoBackupDriveSuccessMessage =>
      'Drive-varmuuskopiointi onnistui.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Drive-varmuuskopiointi epäonnistui: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'Ei vielä muistiinpanoja';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'Yhteensä: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ Piirros';

  @override
  String get autoBackupSettingsAppBarTitle =>
      'Automaattisen varmuuskopioinnin asetukset';

  @override
  String get autoBackupSettingsMainSwitchTitle =>
      'Ota automaattinen varmuuskopiointi käyttöön';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'Muistiinpanosi varmuuskopioidaan turvallisesti säännöllisesti taustalla.';

  @override
  String get autoBackupSettingsTargetTitle => 'Varmuuskopion kohde';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'Valitse, mihin varmuuskopiot tallennetaan.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'Paikallinen';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'Molemmat';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Yhdistä tilisi ensin käyttääksesi Google Drive -vaihtoehtoja.';

  @override
  String get autoBackupSettingsConnectButton => 'Yhdistä';

  @override
  String get autoBackupSettingsFrequencyTitle => 'Varmuuskopiointitiheys';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'Varmuuskopio otetaan $hours tunnin välein.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 tuntia';

  @override
  String get autoBackupSettingsFrequency12h => '12 tuntia';

  @override
  String get autoBackupSettingsFrequency24h => '24 tuntia (päivittäin)';

  @override
  String get autoBackupSettingsFrequency48h => '48 tuntia (2 päivää)';

  @override
  String get autoBackupSettingsFrequency168h => '168 tuntia (viikoittain)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Käytä vain Wi-Fiä';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'Pilvilataus tapahtuu vain Wi-Fi-yhteydellä mobiilidatasi säästämiseksi.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'Järjestelmän tila';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'Automaattista varmuuskopiointia ei ole vielä suoritettu.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'Viimeksi suoritettu: $date $time ($status)\nViesti: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'Onnistui';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'Epäonnistui';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Google-tiliin ei voitu yhdistää.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'Automaattisen varmuuskopioinnin asetukset päivitetty.';

  @override
  String selectionModeDeletedMessage(int count) {
    return '$count muistiinpanoa poistettu';
  }

  @override
  String get selectionModeArchivedMessage => 'Arkistoitu';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'Valitse kategoria $count muistiinpanolle';
  }

  @override
  String get selectionModeAddCategoryOption => 'Lisää kategoria';

  @override
  String get selectionModeRemoveCategoryOption => 'Poista kategoria';

  @override
  String get calcTableItemHint => 'Kohde...';

  @override
  String get calcTableTotalRowLabel => 'Yhteensä';

  @override
  String get textSelectionMenuShareButton => 'Jaa';

  @override
  String get textSelectionMenuTranslateButton => 'Käännä';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'Jakamista ei voitu aloittaa.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'Käännöstä ei voitu avata.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'Tänään $time';
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
    return 'Viimeisin varmuuskopio: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage =>
      'Varmuuskopiota ei ole vielä otettu.';
}
