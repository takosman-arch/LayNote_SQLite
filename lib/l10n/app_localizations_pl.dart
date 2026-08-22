// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'Pogrubienie';

  @override
  String get toolbarItalicTooltip => 'Kursywa';

  @override
  String get toolbarUnderlineTooltip => 'Podkreślenie';

  @override
  String get toolbarStrikethroughTooltip => 'Przekreślenie';

  @override
  String get toolbarFontSizeTooltip => 'Rozmiar czcionki';

  @override
  String get toolbarColorTooltip => 'Kolor tekstu';

  @override
  String get toolbarBulletTooltip => 'Lista punktowana';

  @override
  String get toolbarNumberTooltip => 'Lista numerowana';

  @override
  String get toolbarIndentTooltip => 'Wcięcie akapitu';

  @override
  String get toolbarLinkTooltip => 'Dodaj / edytuj / usuń link';

  @override
  String get toolbarDividerTooltip => 'Wstaw separator';

  @override
  String get toolbarChecklistTooltip => 'Dodaj listę kontrolną';

  @override
  String get linkSelectTextSnackbar =>
      'Najpierw zaznacz tekst, który chcesz połączyć';

  @override
  String get linkDialogEditTitle => 'Edytuj link';

  @override
  String get linkDialogAddTitle => 'Dodaj link';

  @override
  String get linkDialogRemoveButton => 'Usuń link';

  @override
  String get linkDialogCancelButton => 'Anuluj';

  @override
  String get linkDialogConfirmButton => 'Dodaj';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Odmówiono uprawnień do aparatu. Aby nagrywać wideo, musisz zezwolić na to w ustawieniach.';

  @override
  String get cameraPermissionRequiredMessage =>
      'Aby nagrywać wideo, wymagane jest uprawnienie do aparatu.';

  @override
  String get openSettingsButtonLabel => 'Ustawienia';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'Nie udało się rozpocząć skanowania: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'Rozpoznawanie tekstu nie powiodło się: $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'W dokumencie nie znaleziono czytelnego tekstu';

  @override
  String get scanResultSheetTitle => 'Jak dodać zeskanowany dokument?';

  @override
  String get scanResultTextOnlyOption => 'Dodaj tylko jako tekst';

  @override
  String get scanResultTextAndImageOption => 'Dodaj tekst + zeskanowany obraz';

  @override
  String get scanResultCancelOption => 'Anuluj';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'Odmówiono uprawnień do mikrofonu. Aby nagrywać dźwięk, musisz zezwolić na to w ustawieniach.';

  @override
  String get audioPermissionRequiredMessage =>
      'Aby nagrywać dźwięk, wymagane jest uprawnienie do mikrofonu.';

  @override
  String get voiceRecordingDefaultLabel => 'Nagranie głosowe';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'Lista obliczeniowa ($count wierszy)';
  }

  @override
  String get blockPreviewDrawingLabel => 'Rysunek';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count załączników (zdjęcie/dokument)';
  }

  @override
  String get blockPreviewDividerLabel => 'Separator';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'Lista kontrolna ($count elementów)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(pusty tekst)';

  @override
  String get reorderBlocksSheetTitle => 'Zmień kolejność bloków';

  @override
  String get reorderBlocksMoveUpTooltip => 'Przesuń w górę';

  @override
  String get reorderBlocksMoveDownTooltip => 'Przesuń w dół';

  @override
  String get reorderBlocksCloseTooltip => 'Zamknij';

  @override
  String get reorderBlocksDescription =>
      'Dotknij bloku, aby go zaznaczyć, a następnie użyj strzałek w górę/w dół, aby go przesunąć.';

  @override
  String get reorderBlocksMenuItemLabel => 'Zmień kolejność';

  @override
  String get txtImportPickerDialogTitle => 'Wybierz plik TXT do zaimportowania';

  @override
  String get txtImportReadFailedMessage => 'Nie udało się odczytać pliku TXT';

  @override
  String get txtImportEmptyFileMessage => 'Plik TXT jest pusty';

  @override
  String get txtImportSuccessMessage => 'Zaimportowano TXT';

  @override
  String get txtImportMenuItemLabel => 'Importuj (txt)';

  @override
  String get exportMenuItemLabel => 'Eksportuj';

  @override
  String get editorUndoTooltip => 'Cofnij';

  @override
  String get editorRedoTooltip => 'Ponów';

  @override
  String get noteSavedMessage => 'Notatka zapisana';

  @override
  String get dateAssignPickerHelpText => 'Przypisz notatkę do dnia';

  @override
  String get dateAssignChangeOption => 'Zmień datę';

  @override
  String get dateAssignRemoveOption => 'Usuń przypisanie';

  @override
  String get editorSubToolbarCloseTooltip => 'Zamknij';

  @override
  String get titleFieldHint => 'Tytuł';

  @override
  String get textBlockHint => 'Napisz tutaj swoją notatkę...';

  @override
  String get drawingBoardMenuItemLabel => 'Tablica rysunkowa';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'Zamiana mowy na tekst jest dostępna tylko dla notatek tekstowych';

  @override
  String get selectionModeCancelTooltip => 'Anuluj zaznaczenie';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return 'Zaznaczono: $count';
  }

  @override
  String get selectionModeDeleteTooltip => 'Usuń';

  @override
  String get selectionModeArchiveTooltip => 'Archiwizuj';

  @override
  String get selectionModeFolderTooltip => 'Folder';

  @override
  String get searchFieldHint => 'Szukaj notatek...';

  @override
  String get emptyTrashDialogTitle => 'Opróżnij kosz';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'Wszystkie usunięte notatki zostaną trwale usunięte. Czy na pewno?';

  @override
  String get emptyTrashDialogCancelButton => 'Anuluj';

  @override
  String get restoreAllMenuItemLabel => 'Przywróć wszystko';

  @override
  String get sortMenuTooltip => 'Sortuj notatki';

  @override
  String get sortMenuAscendingLabel => 'Kolejność: rosnąco (A-Z)';

  @override
  String get sortMenuDescendingLabel => 'Kolejność: malejąco (Z-A)';

  @override
  String get sortMenuByTitleLabel => 'Sortuj według: tytułu';

  @override
  String get sortMenuByModifiedDateLabel =>
      'Sortuj według: ostatniej modyfikacji';

  @override
  String get sortMenuByCreatedDateLabel => 'Sortuj według: daty utworzenia';

  @override
  String get sortMenuByFolderLabel => 'Sortuj według: folderu';

  @override
  String get viewToggleGridTooltip => 'Widok siatki';

  @override
  String get viewToggleListTooltip => 'Widok listy';

  @override
  String get drawerHeaderSubtitle => 'Twój osobisty notatnik';

  @override
  String get drawerNotesSectionHeader => 'NOTATKI';

  @override
  String get drawerAllNotesLabel => 'Notatki';

  @override
  String get drawerFavoritesLabel => 'Ulubione';

  @override
  String get drawerAgendaLabel => 'Plan dnia';

  @override
  String get drawerRemindersLabel => 'Przypomnienie';

  @override
  String get drawerLockedLabel => 'Zablokowane';

  @override
  String get drawerTrashLabel => 'Kosz';

  @override
  String get drawerFoldersSectionHeader => 'FOLDERY';

  @override
  String get drawerExpandLabel => 'Rozwiń';

  @override
  String get drawerCollapseLabel => 'Zwiń';

  @override
  String get drawerAddFolderLabel => 'Dodaj folder';

  @override
  String get drawerAppSectionHeader => 'APLIKACJA';

  @override
  String get drawerCalendarLabel => 'Kalendarz';

  @override
  String get drawerSettingsLabel => 'Ustawienia';

  @override
  String get drawerBackupRestoreLabel => 'Kopia zapasowa i przywracanie';

  @override
  String get drawerUpgradeToProLabel => 'Przejdź na Pro';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'Wesprzyj rozwój';

  @override
  String get drawerFeedbackLabel => 'Opinia';

  @override
  String get drawerAboutLabel => 'O aplikacji';

  @override
  String get noNotesFoundMessage => 'Nie znaleziono notatek.';

  @override
  String get trashRestoreButtonLabel => 'Przywróć';

  @override
  String get trashPermanentDeleteButtonLabel => 'Usuń trwale';

  @override
  String get tagRenamedInfoMessage => 'Zmieniono nazwę tagu';

  @override
  String get tagDeletedInfoMessage => 'Tag usunięty';

  @override
  String get tagOptionsRenameLabel => 'Zmień nazwę';

  @override
  String get tagOptionsDeleteLabel => 'Usuń';

  @override
  String get renameTagDialogTitle => 'Zmień nazwę tagu';

  @override
  String get renameTagDialogHint => 'Nowa nazwa tagu';

  @override
  String get renameTagDialogCancelButton => 'Anuluj';

  @override
  String get renameTagDialogSaveButton => 'Zapisz';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return 'Tag „$tag” zostanie usunięty z $affectedCount notatek. Kontynuować?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'Usunąć tag „$tag”?';
  }

  @override
  String get deleteTagDialogTitle => 'Usuń tag';

  @override
  String get deleteTagDialogCancelButton => 'Anuluj';

  @override
  String get deleteTagDialogConfirmButton => 'Usuń';

  @override
  String get tagsSheetTitle => 'Tagi';

  @override
  String get tagsSheetEmptyMessage => 'Ta notatka nie ma jeszcze tagów.';

  @override
  String get tagsSheetInputHint => 'Wpisz nowy tag...';

  @override
  String get tagsSheetSuggestionsLabel => 'Istniejące tagi';

  @override
  String get noteDeletedInfoMessage => 'Notatka usunięta';

  @override
  String get noteDeletedUndoActionLabel => 'Cofnij';

  @override
  String get reminderSetInfoMessage => 'Ustawiono przypomnienie';

  @override
  String get reminderRemovedInfoMessage => 'Usunięto przypomnienie';

  @override
  String get noteDuplicatedInfoMessage => 'Utworzono kopię';

  @override
  String get speechTextAppendedInfoMessage => 'Tekst dodany do notatki';

  @override
  String get pdfPreparingInfoMessage => 'Przygotowywanie PDF…';

  @override
  String get pdfSavedInfoMessage => 'Zapisano PDF';

  @override
  String get jpgPreparingInfoMessage => 'Przygotowywanie JPG…';

  @override
  String get jpgSavedInfoMessage => 'Zapisano JPG';

  @override
  String get jpgFailedInfoMessage => 'Nie udało się utworzyć pliku JPG';

  @override
  String get txtPreparingInfoMessage => 'Przygotowywanie TXT…';

  @override
  String get txtSavedInfoMessage => 'Zapisano TXT';

  @override
  String get txtFailedInfoMessage => 'Nie udało się utworzyć pliku TXT';

  @override
  String get exportOpenActionLabel => 'Otwórz';

  @override
  String get wrongPasswordInfoMessage => 'Nieprawidłowe hasło.';

  @override
  String get noteArchivedInfoMessage => 'Notatka zarchiwizowana';

  @override
  String get noteUnarchivedInfoMessage => 'Usunięto z archiwum';

  @override
  String get noteUnlockedInfoMessage => 'Odblokowano';

  @override
  String get noteLockedInfoMessage => 'Notatka zablokowana';

  @override
  String get notificationUnpinnedInfoMessage => 'Odpięto';

  @override
  String get emptyNotePinBlockedInfoMessage =>
      'Nie można przypiąć pustej notatki.';

  @override
  String get notificationPinnedInfoMessage => 'Przypięto do panelu powiadomień';

  @override
  String get noContentToReadInfoMessage => 'Brak treści do odczytania';

  @override
  String get backPressExitInfoMessage => 'Naciśnij wstecz ponownie, aby wyjść';

  @override
  String get reminderChannelName => 'Przypomnienia o notatkach';

  @override
  String get reminderChannelDescription =>
      'Przypomnienia o notatkach w aplikacji Layout';

  @override
  String get pinnedChannelName => 'Przypięte notatki';

  @override
  String get pinnedChannelDescription =>
      'Notatki Layout przypięte do panelu powiadomień';

  @override
  String get notificationUnpinActionLabel => 'Usuń';

  @override
  String get reminderDefaultTitle => 'Przypomnienie';

  @override
  String get reminderChecklistBodyFallback =>
      'Nie zapomnij sprawdzić swojej listy kontrolnej';

  @override
  String get reminderTextBodyFallback =>
      'Nie zapomnij sprawdzić swojej notatki';

  @override
  String get pdfSaveDialogTitle => 'Zapisz jako PDF';

  @override
  String get jpgSaveDialogTitle => 'Zapisz jako JPG';

  @override
  String get txtSaveDialogTitle => 'Zapisz jako TXT';

  @override
  String get textSizeSheetTitle => 'Rozmiar tekstu';

  @override
  String get textSizeSamplePreview => 'Przykładowy tekst';

  @override
  String get textSizeCancelButton => 'Anuluj';

  @override
  String get textSizeApplyButton => 'Zastosuj';

  @override
  String get createPasswordDialogTitle => 'Utwórz hasło';

  @override
  String get createPasswordNewPasswordHint => 'Nowe hasło';

  @override
  String get createPasswordConfirmHint => 'Powtórz hasło';

  @override
  String get createPasswordHintQuestionDescription =>
      'Ustaw pytanie zabezpieczające na wypadek zapomnienia hasła (opcjonalnie).';

  @override
  String get createPasswordHintQuestionHint =>
      'Wybierz pytanie zabezpieczające';

  @override
  String get createPasswordHintAnswerHint => 'Twoja odpowiedź';

  @override
  String get createPasswordCancelButton => 'Anuluj';

  @override
  String get createPasswordSaveButton => 'Zapisz';

  @override
  String get passwordMismatchMessage => 'Hasła nie są zgodne!';

  @override
  String get passwordRequiredDialogTitle => 'Wymagane hasło';

  @override
  String get passwordRequiredHint => 'Wprowadź hasło';

  @override
  String get forgotPasswordButtonLabel => 'Nie pamiętam hasła';

  @override
  String get passwordRequiredCancelButton => 'Anuluj';

  @override
  String get passwordRequiredConfirmButton => 'Zweryfikuj';

  @override
  String get securityQuestionDialogTitle => 'Pytanie zabezpieczające';

  @override
  String get securityQuestionAnswerHint => 'Twoja odpowiedź';

  @override
  String get securityQuestionCancelButton => 'Anuluj';

  @override
  String get securityQuestionConfirmButton => 'Potwierdź';

  @override
  String get securityQuestionWrongAnswerMessage =>
      'Błędna odpowiedź. Spróbuj ponownie.';

  @override
  String get revealedPasswordDialogTitle => 'Twoje hasło';

  @override
  String get revealedPasswordLabel => 'Hasło do Twojej notatki:';

  @override
  String get revealedPasswordOkButton => 'OK';

  @override
  String get securityQuestionPetName =>
      'Jak nazywa się Twój pierwszy zwierzak?';

  @override
  String get securityQuestionFavoriteTeacher =>
      'Jak nazywa się Twój ulubiony nauczyciel?';

  @override
  String get securityQuestionBirthCity => 'W jakim mieście się urodziłeś/aś?';

  @override
  String get securityQuestionFavoriteFood =>
      'Jakie jest Twoje ulubione jedzenie?';

  @override
  String get securityQuestionMotherMaidenName =>
      'Jakie jest panieńskie nazwisko Twojej matki?';

  @override
  String get securityQuestionFirstSchool =>
      'Jak nazywała się Twoja pierwsza szkoła?';

  @override
  String get securityQuestionFavoriteColor => 'Jaki jest Twój ulubiony kolor?';

  @override
  String get editFolderDialogTitle => 'Edytuj folder';

  @override
  String get newSubfolderDialogTitle => 'Nowy podfolder';

  @override
  String get addFolderDialogTitle => 'Dodaj folder';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'Zostanie utworzony wewnątrz „$parentCategory”';
  }

  @override
  String get subfolderNameFieldLabel => 'Nazwa podfolderu';

  @override
  String get folderNameFieldLabel => 'Nazwa folderu';

  @override
  String get folderColorLabel => 'Kolor';

  @override
  String get folderDialogCancelButton => 'Anuluj';

  @override
  String get folderDialogSaveButton => 'Zapisz';

  @override
  String get folderDialogAddButton => 'Dodaj';

  @override
  String get selectFolderSheetTitle => 'Wybierz folder';

  @override
  String get selectFolderAddOptionLabel => 'Dodaj folder';

  @override
  String get removeCurrentFolderLabel => 'Usuń bieżący folder';

  @override
  String get noteDetailsDialogTitle => 'Szczegóły';

  @override
  String get noteDetailsCreatedLabel => 'Utworzono';

  @override
  String get noteDetailsModifiedLabel => 'Ostatnia modyfikacja';

  @override
  String get noteDetailsCharCountLabel => 'Liczba znaków';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count znaków';
  }

  @override
  String get noteDetailsWordCountLabel => 'Liczba słów';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count słów';
  }

  @override
  String get noteDetailsOkButton => 'OK';

  @override
  String get noteDetailsUnknownDateLabel => 'Nieznana';

  @override
  String get addAttachmentSheetTitle => 'Dodaj';

  @override
  String get addAttachmentImageOption => 'Dodaj zdjęcie';

  @override
  String get addAttachmentCameraOption => 'Aparat';

  @override
  String get addAttachmentFileOption => 'Dodaj plik';

  @override
  String get addAttachmentVoiceOption => 'Nagranie głosowe';

  @override
  String get addAttachmentVideoOption => 'Nagraj wideo';

  @override
  String get addAttachmentScanOption => 'Skanuj dokument';

  @override
  String get noteActionsSheetTitle => 'Wybierz działanie';

  @override
  String get noteActionReminderLabel => 'Przypomnienie';

  @override
  String get noteActionEditReminderLabel => 'Edytuj przypomnienie';

  @override
  String get noteActionSpeechToTextLabel => 'Mowa na tekst';

  @override
  String get noteActionArchiveLabel => 'Archiwizuj';

  @override
  String get noteActionUnarchiveLabel => 'Usuń z archiwum';

  @override
  String get noteActionLockLabel => 'Zablokuj';

  @override
  String get noteActionUnlockLabel => 'Odblokuj';

  @override
  String get noteActionFavoriteLabel => 'Ulubione';

  @override
  String get noteActionUnfavoriteLabel => 'Usuń z ulubionych';

  @override
  String get noteActionClassifyLabel => 'Wybierz folder';

  @override
  String get noteActionDeleteLabel => 'Usuń';

  @override
  String get noteActionPinToNotificationLabel =>
      'Przypnij do panelu powiadomień';

  @override
  String get noteActionUnpinFromNotificationLabel => 'Usuń przypięcie';

  @override
  String get noteActionShareLabel => 'Udostępnij';

  @override
  String get noteActionDuplicateLabel => 'Utwórz kopię';

  @override
  String get noteActionCopyContentLabel => 'Kopiuj treść';

  @override
  String get noteActionTtsLabel => 'Czytaj na głos';

  @override
  String get noteActionTextSizeLabel => 'Rozmiar tekstu';

  @override
  String get noteActionDetailsLabel => 'Szczegóły';

  @override
  String get noteActionDiscardChangesLabel => 'Odrzuć zmiany';

  @override
  String get noteActionSelectLabel => 'Zaznacz';

  @override
  String get reminderEditOptionLabel => 'Zmień przypomnienie';

  @override
  String get reminderRemoveOptionLabel => 'Usuń przypomnienie';

  @override
  String get discardChangesDialogTitle => 'Odrzuć zmiany';

  @override
  String get discardChangesDialogMessage =>
      'Niezapisane zmiany w tej notatce zostaną utracone. Czy na pewno chcesz je odrzucić?';

  @override
  String get discardChangesCancelButton => 'Anuluj';

  @override
  String get discardChangesConfirmButton => 'Odrzuć';

  @override
  String get pinnedNotificationDefaultTitle => 'Notatka';

  @override
  String get pdfFailedInfoMessage => 'Nie udało się utworzyć pliku PDF';

  @override
  String get drawingScreenTitle => 'Rysunek';

  @override
  String get drawingMinimizeTooltip => 'Minimalizuj';

  @override
  String get drawingEmptyExportWarningMessage => 'Najpierw coś narysuj';

  @override
  String get drawingEraserPartialModeLabel => 'Częściowa';

  @override
  String get drawingEraserFullModeLabel => 'Pełna';

  @override
  String get drawingClearTooltip => 'Wyczyść';

  @override
  String get drawingZoomOutTooltip => 'Pomniejsz';

  @override
  String get drawingZoomInTooltip => 'Powiększ';

  @override
  String get drawingDeleteTooltip => 'Usuń';

  @override
  String get drawingEmptyPreviewHint => 'Dotknij, aby rysować';

  @override
  String get settingsPageTitle => 'Ustawienia';

  @override
  String get settingsSectionGeneral => 'Ogólne';

  @override
  String get settingsSectionSecurity => 'Bezpieczeństwo';

  @override
  String get settingsSectionTheme => 'Motyw';

  @override
  String get settingsSectionPersonalization => 'Personalizacja';

  @override
  String get settingsSectionWidget => 'Widżet';

  @override
  String get settingsSectionAbout => 'O aplikacji';

  @override
  String get settingsHintQuestionPet =>
      'Jak nazywa się Twój pierwszy zwierzak?';

  @override
  String get settingsHintQuestionTeacher =>
      'Jak nazywa się Twój ulubiony nauczyciel?';

  @override
  String get settingsHintQuestionBirthCity =>
      'W jakim mieście się urodziłeś/aś?';

  @override
  String get settingsHintQuestionFavoriteFood =>
      'Jakie jest Twoje ulubione jedzenie?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'Jakie jest panieńskie nazwisko Twojej matki?';

  @override
  String get settingsHintQuestionFirstSchool =>
      'Jak nazywała się pierwsza szkoła, do której uczęszczałeś/aś?';

  @override
  String get settingsHintQuestionFavoriteColor =>
      'Jaki jest Twój ulubiony kolor?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'Pytanie zabezpieczające';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'Jeśli zapomnisz hasła, będziesz mógł/mogła je odzyskać, odpowiadając poprawnie na to pytanie.';

  @override
  String get settingsSecurityQuestionDropdownHint =>
      'Wybierz pytanie zabezpieczające';

  @override
  String get settingsSecurityQuestionAnswerHint => 'Twoja odpowiedź';

  @override
  String get settingsSecurityQuestionCancelButton => 'Anuluj';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'Pytanie i odpowiedź nie mogą być puste!';

  @override
  String get settingsSecurityQuestionSaveButton => 'Zapisz';

  @override
  String get settingsCreatePasswordTitle => 'Utwórz hasło';

  @override
  String get settingsPasswordRequiredTitle => 'Wymagane hasło';

  @override
  String get settingsPasswordEnterHint => 'Wprowadź hasło';

  @override
  String get settingsForgotPasswordButton => 'Nie pamiętam hasła';

  @override
  String get settingsNewPasswordHint => 'Nowe hasło';

  @override
  String get settingsConfirmPasswordHint => 'Powtórz hasło';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'Ustaw pytanie zabezpieczające na wypadek zapomnienia hasła (opcjonalnie).';

  @override
  String get settingsPasswordDialogCancelButton => 'Anuluj';

  @override
  String get settingsPasswordMismatchWarning => 'Hasła nie są zgodne!';

  @override
  String get settingsWrongPasswordWarning => 'Nieprawidłowe hasło!';

  @override
  String get settingsPasswordSaveButton => 'Zapisz';

  @override
  String get settingsPasswordRemoveButton => 'Usuń';

  @override
  String get settingsNotePasswordTitle => 'Hasło notatki';

  @override
  String get settingsPasswordSetSubtitle => 'Hasło ustawione ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'Hasło nieustawione';

  @override
  String get settingsSecurityQuestionTileTitle => 'Pytanie zabezpieczające';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'Ustawione ✓ — używane w razie zapomnienia hasła';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'Nieustawione — nie będziesz mógł/mogła odzyskać hasła w razie jego utraty';

  @override
  String get settingsThemeDialogTitle => 'Wybierz motyw';

  @override
  String get settingsThemeSystemDefault => 'Domyślny systemowy';

  @override
  String get settingsThemeLightOption => 'Jasny motyw';

  @override
  String get settingsThemeDarkOption => 'Ciemny motyw';

  @override
  String get settingsLanguageDialogTitle => 'Wybierz język';

  @override
  String get settingsLanguageSystemOption => 'Systemowy';

  @override
  String get settingsAccentColorDialogTitle => 'Wybierz kolor akcentu';

  @override
  String get settingsThemeChangeTileTitle => 'Zmień motyw';

  @override
  String get settingsThemeLightLabel => 'Jasny';

  @override
  String get settingsThemeDarkLabel => 'Ciemny';

  @override
  String get settingsThemeSystemLabel => 'Systemowy';

  @override
  String get settingsLanguageTileTitle => 'Język';

  @override
  String get settingsAccentColorTileTitle => 'Kolor akcentu';

  @override
  String get settingsAccentColorTileSubtitle =>
      'Kolor używany na pasku aplikacji, przyciskach i przełącznikach';

  @override
  String get settingsColorfulNotesTitle => 'Różnorodne kolory notatek';

  @override
  String get settingsColorfulNotesSubtitle =>
      'Każda karta notatki ma inny odcień koloru.';

  @override
  String get settingsTextColorSheetTitle => 'Kolor tekstu';

  @override
  String get settingsTextColorSheetDesc => 'Ustawia kolor treści notatki.';

  @override
  String get settingsTextColorOkButton => 'OK';

  @override
  String get settingsTextColorTileTitle => 'Kolor tekstu';

  @override
  String get settingsTextColorTileSubtitle => 'Kolor treści notatki.';

  @override
  String get settingsWidgetFontSizeLabel => 'Rozmiar czcionki widżetu';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'Przykładowy nagłówek - $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'Anuluj';

  @override
  String get settingsWidgetFontSizeApplyButton => 'Zastosuj';

  @override
  String get settingsWidgetOpacityLabel => 'Przezroczystość tła';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return 'Przezroczystość: $percent%';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'Anuluj';

  @override
  String get settingsWidgetOpacityApplyButton => 'Zastosuj';

  @override
  String get settingsWidgetDarkModeTitle => 'Ciemny widżet';

  @override
  String get settingsWidgetDarkModeDesc => 'Ciemny schemat kolorów widżetu.';

  @override
  String get settingsAboutVersionTitle => 'Wersja aplikacji';

  @override
  String get settingsFontFamilyTileTitle => 'Czcionka';

  @override
  String get settingsFontFamilyDefaultLabel => 'Domyślna';

  @override
  String get settingsGlobalFontSizeTileTitle => 'Rozmiar czcionki';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt — zastosowano do wszystkich notatek.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'Przykładowy tekst - $size pt';
  }

  @override
  String get settingsGlobalFontSizeApplyToAllLabel =>
      'Zastosuj do istniejących notatek';

  @override
  String get settingsGlobalFontSizeApplyToAllNote =>
      'Jeśli notatka ma ustawiony indywidualny rozmiar czcionki, to ustawienie jej nie dotyczy.';

  @override
  String get settingsGlobalFontSizeCancelButton => 'Anuluj';

  @override
  String get settingsGlobalFontSizeApplyButton => 'Zastosuj';

  @override
  String get settingsPreviewLinesTileTitle => 'Liczba linii podglądu notatki';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'Pokaż do $lines linii. Jeśli notatka jest krótsza, wyświetlana jest rzeczywista liczba linii.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'Bieżąca: $lines linii';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'Ustawia maksymalną liczbę linii podglądu. Jeśli notatka ma mniej linii, wyświetlana jest rzeczywista ich liczba.';

  @override
  String get settingsPreviewLinesCancelButton => 'Anuluj';

  @override
  String get settingsPreviewLinesApplyButton => 'Zastosuj';

  @override
  String get backupCancelButton => 'Anuluj';

  @override
  String get backupConnectButton => 'Połącz';

  @override
  String get backupDisconnectButton => 'Rozłącz';

  @override
  String get backupContinueButton => 'Kontynuuj';

  @override
  String get backupCloseButton => 'Zamknij';

  @override
  String get backupShareButton => 'Udostępnij';

  @override
  String get backupRestoreButton => 'Przywróć';

  @override
  String get backupConfigureButton => 'Konfiguruj';

  @override
  String get backupUnknownDateLabel => 'Nieznana';

  @override
  String get backupProcessingDefaultLabel => 'Przetwarzanie...';

  @override
  String get backupPermissionRequiredTitle => 'Wymagane uprawnienie do pamięci';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'Ta wersja Androida wymaga uprawnienia do pamięci dla kopii zapasowej/przywracania. Ponieważ uprawnienie zostało trwale odrzucone, włącz je ręcznie w ustawieniach aplikacji.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'Ta wersja Androida wymaga uprawnienia do pamięci dla kopii zapasowej/przywracania. Przyznaj uprawnienie, aby kontynuować.';

  @override
  String get backupGoToSettingsButton => 'Przejdź do ustawień';

  @override
  String get backupRetryButton => 'Ponów';

  @override
  String get backupDriveConnectingLabel => 'Łączenie z kontem Google...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Połączono z kontem Google Drive: $email';
  }

  @override
  String get backupDriveConnectedMessage => 'Połączono z kontem Google Drive.';

  @override
  String get backupDriveConnectFailedMessage =>
      'Nie udało się połączyć z kontem Google lub operacja została anulowana.';

  @override
  String get backupDriveDisconnectTitle => 'Rozłącz Google Drive';

  @override
  String get backupDriveDisconnectBody =>
      'Po rozłączeniu ręczne i automatyczne kopie zapasowe na Dysku nie będą możliwe. Kopie zapasowe już zapisane na Dysku nie zostaną usunięte — usunięty zostanie tylko dostęp z tego urządzenia.';

  @override
  String get backupDriveDisconnectedMessage =>
      'Połączenie z Google Drive usunięte.';

  @override
  String get backupDriveRequiredTitle => 'Wymagane konto Google';

  @override
  String get backupDriveRequiredBody =>
      'Ta czynność wymaga połączenia konta Google. Czy chcesz połączyć się teraz?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: połączono ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: połączono';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: niepołączono';

  @override
  String get backupDriveAuthenticatingLabel => 'Weryfikacja konta Google...';

  @override
  String get backupDriveNotSignedInMessage =>
      'Nie jesteś połączony/a z Google Drive. Najpierw zaloguj się na konto Google.';

  @override
  String get backupDriveUploadingLabel =>
      'Przesyłanie kopii zapasowej na Dysk...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Przesyłanie na Google Drive nie zakończyło się w ciągu 120 sekund (brak odpowiedzi z serwera). Sprawdź połączenie i spróbuj ponownie.';

  @override
  String get backupDriveOperationCompletedLabel => 'Zakończono';

  @override
  String get backupToDriveActionLabel => 'kopia zapasowa na Dysk';

  @override
  String get backupToDeviceActionLabel => 'kopia zapasowa';

  @override
  String get backupCreatingLabel => 'Tworzenie kopii zapasowej...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'Nie udało się utworzyć kopii zapasowej: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Przesyłanie na Google Drive nie powiodło się: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'Kopia zapasowa pomyślnie przesłana na Google Drive.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'Utworzono kopię zapasową: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'Kopia zapasowa gotowa';

  @override
  String get backupOfferShareBody =>
      'Plik kopii zapasowej został zapisany na Twoim urządzeniu. Czy chcesz go teraz udostępnić (np. w chmurze, e-mailem, na innym urządzeniu)?';

  @override
  String get backupShareFileText => 'plik kopii zapasowej layout';

  @override
  String backupShareFailedMessage(String error) {
    return 'Nie udało się rozpocząć udostępniania: $error';
  }

  @override
  String get backupLargeOperationTitle => 'Duża kopia zapasowa';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'Dane do przetworzenia mają rozmiar około $sizeText. $actionLabel tego rozmiaru może chwilę potrwać, zależnie od urządzenia. Po prostu nie opuszczaj aplikacji podczas trwania operacji — czy chcesz kontynuować?';
  }

  @override
  String get backupRestoreActionLabel => 'przywracanie';

  @override
  String get backupDriveListingLabel =>
      'Wyświetlanie kopii zapasowych z Dysku...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'Nie udało się wyświetlić kopii zapasowych: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'Na Google Drive nie ma jeszcze żadnych kopii zapasowych.';

  @override
  String get backupDrivePickTitle => 'Wybierz kopię zapasową z Dysku';

  @override
  String get backupDriveDownloadingLabel =>
      'Pobieranie kopii zapasowej z Dysku...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Pobieranie kopii zapasowej z Dysku... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel =>
      'Zapisywanie pliku na urządzeniu...';

  @override
  String get backupDriveUnknownBackupFileName => 'nieznana_kopia_zapasowa.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Pamięć Google Drive jest pełna. Zwolnij miejsce na Dysku i spróbuj ponownie.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'Nie udało się nawiązać połączenia internetowego. Sprawdź połączenie i spróbuj ponownie.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'Nie znaleziono podanego pliku kopii zapasowej na Dysku. Mógł zostać usunięty.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Wystąpił nieoczekiwany błąd podczas operacji Google Drive: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'Pobieranie nie powiodło się: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'Nie udało się wybrać pliku: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'Nie udało się uzyskać dostępu do wybranego pliku.';

  @override
  String get backupCheckingLabel => 'Sprawdzanie kopii zapasowej...';

  @override
  String backupReadFailedMessage(String error) {
    return 'Nie udało się odczytać pliku kopii zapasowej: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'Przywróć kopię zapasową';

  @override
  String get backupPreviewContentsHeader =>
      'Zawartość wybranej kopii zapasowej:';

  @override
  String get backupPreviewNoteCountLabel => 'Liczba notatek';

  @override
  String get backupPreviewTrashCountLabel => 'Notatki w koszu';

  @override
  String get backupPreviewCategoryCountLabel => 'Liczba kategorii';

  @override
  String get backupPreviewAttachmentLabel => 'Załączniki';

  @override
  String get backupPreviewAttachmentNoneValue => 'Brak';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count plików ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'Utworzono';

  @override
  String get backupEmptyPreviewTitle => 'Ta kopia zapasowa wygląda na pustą';

  @override
  String get backupEmptyPreviewBody =>
      'W wybranym pliku nie znaleziono żadnych notatek, kategorii ani załączników. Jeśli będziesz kontynuować, Twoje bieżące dane zostaną i tak usunięte i zastąpione tą pustą kopią zapasową.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return 'Nie znaleziono $count załączników w kopii zapasowej';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'Notatki z tymi plikami zostaną przywrócone, ale bez załączników (mogły brakować lub być uszkodzone w momencie tworzenia kopii zapasowej): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown i $remaining więcej';
  }

  @override
  String get backupRestoreConfirmBody =>
      'Spowoduje to ZASTĄPIENIE wszystkich bieżących notatek, kosza, kategorii, ustawień i załączników danymi z powyższej kopii zapasowej. Bieżące dane zostaną trwale utracone, a tej czynności nie można cofnąć.';

  @override
  String get backupRestoringLabel => 'Przywracanie kopii zapasowej...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'Kopia zapasowa przywrócona. Jednak $count załączników nie znaleziono w kopii zapasowej i nie można ich było przywrócić. Zaleca się ponowne uruchomienie aplikacji, aby zmiany w pełni zaczęły obowiązywać.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'Kopia zapasowa przywrócona pomyślnie. Zaleca się ponowne uruchomienie aplikacji, aby zmiany w pełni zaczęły obowiązywać.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'Wystąpił błąd podczas przywracania: $error';
  }

  @override
  String get backupScreenTitle => 'Kopia zapasowa i przywracanie';

  @override
  String get backupBlockedExitWarningMessage =>
      'Trwa operacja, poczekaj na jej zakończenie.';

  @override
  String get backupBusyBackTooltip => 'Operacja w toku';

  @override
  String get backupIntroText =>
      'Możesz utworzyć kopię zapasową swoich notatek, kategorii, ustawień i załączników jako pojedynczy plik .zip lub przywrócić wcześniej utworzoną kopię zapasową.';

  @override
  String get backupDriveCardTitle => 'Utwórz kopię zapasową na Google Drive';

  @override
  String get backupDriveCardSubtitle =>
      'Utwórz nową kopię zapasową i prześlij ją bezpośrednio do prywatnego obszaru Twojego Google Drive.';

  @override
  String get backupDriveCardButtonLabel => 'Kopia zapasowa na Dysk';

  @override
  String get backupDeviceCardTitle => 'Utwórz kopię zapasową na urządzeniu';

  @override
  String get backupDeviceCardSubtitle =>
      'Zapisz wszystkie swoje dane jako pojedynczy plik .zip na urządzeniu i udostępnij go, jeśli chcesz.';

  @override
  String get backupDeviceCardButtonLabel => 'Kopia zapasowa na urządzenie';

  @override
  String get backupHistoryCardTitle => 'Historia kopii zapasowych';

  @override
  String get backupHistoryCardSubtitle =>
      'Wyświetl wszystkie kopie zapasowe zapisane na urządzeniu wraz z ich datą i rozmiarem; możesz je stąd udostępniać, przywracać lub usuwać.';

  @override
  String get backupHistoryTabDevice => 'Urządzenie';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'Usuń kopię zapasową';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'Czy na pewno chcesz trwale usunąć plik kopii zapasowej „$fileName”? Tej czynności nie można cofnąć.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'Kopia zapasowa usunięta.';

  @override
  String get backupHistoryDriveDeleteDialogTitle =>
      'Usuń kopię zapasową z Dysku';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'Czy na pewno chcesz trwale usunąć kopię zapasową „$fileName” z Google Drive? Tej czynności nie można cofnąć, a plik nie zostanie przeniesiony do kosza.';
  }

  @override
  String get backupHistoryDriveDeletedMessage =>
      'Kopia zapasowa na Dysku usunięta.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'Nie udało się usunąć: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'Na tym urządzeniu nie zapisano jeszcze żadnych kopii zapasowych.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'Użyj opcji „Kopia zapasowa na urządzenie”, aby utworzyć pierwszą kopię zapasową.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'Użyj opcji „Kopia zapasowa na Google Drive”, aby utworzyć pierwszą kopię zapasową w chmurze.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Połącz konto Google, aby zobaczyć swoje kopie zapasowe na Dysku.';

  @override
  String get backupHistoryConnectGoogleButton => 'Połącz z Google';

  @override
  String get backupHistoryDriveConnectedFallback => 'Połączono';

  @override
  String get backupHistoryUnknownErrorFallback => 'Wystąpił nieznany błąd.';

  @override
  String get backupHistoryDownloadStartingLabel => 'Rozpoczynanie...';

  @override
  String get backupAutoBackupEnabledLabel =>
      'Automatyczna kopia zapasowa: włączona';

  @override
  String get backupAutoBackupDisabledLabel =>
      'Automatyczna kopia zapasowa: wyłączona';

  @override
  String get backupOverlayWarningMessage =>
      'Poczekaj, nie opuszczaj aplikacji, aż operacja się zakończy.';

  @override
  String get pdfExportUntitledNoteLabel => 'Notatka bez tytułu';

  @override
  String get pdfExportDefaultAttachmentName => 'Załącznik';

  @override
  String get pdfExportDefaultFileName => 'notatka';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'Nie udało się przechwycić zrzutu ekranu (nie znaleziono granicy)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'Nie udało się wygenerować danych zrzutu ekranu';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'Nie udało się przetworzyć obrazu (błąd dekodowania PNG)';

  @override
  String get screenshotCalcTableTotalLabel => 'Suma';

  @override
  String get gundemMenuRemoveFromAgenda => 'Usuń z planu dnia';

  @override
  String get gundemMenuDeleteNote => 'Usuń notatkę';

  @override
  String get gundemSectionOverdue => 'Zaległe';

  @override
  String get gundemSectionToday => 'Dzisiaj';

  @override
  String get gundemSectionTomorrow => 'Jutro';

  @override
  String get gundemSectionNextWeek => 'Przyszły tydzień';

  @override
  String get gundemSectionFurther => 'W dalszej przyszłości';

  @override
  String get gundemWeekdayMonday => 'Poniedziałek';

  @override
  String get gundemWeekdayTuesday => 'Wtorek';

  @override
  String get gundemWeekdayWednesday => 'Środa';

  @override
  String get gundemWeekdayThursday => 'Czwartek';

  @override
  String get gundemWeekdayFriday => 'Piątek';

  @override
  String get gundemWeekdaySaturday => 'Sobota';

  @override
  String get gundemWeekdaySunday => 'Niedziela';

  @override
  String get gundemAppBarTitle => 'Plan dnia';

  @override
  String get gundemCalendarTooltip => 'Kalendarz';

  @override
  String get gundemEmptyTitle => 'Brak wpisów w planie dnia';

  @override
  String get gundemEmptySubtitle =>
      'Tutaj pojawią się notatki z przypomnieniem lub przypisaną datą.';

  @override
  String get gundemUntitledNote => 'Notatka bez tytułu';

  @override
  String get gundemRepeatHourly => 'Co godzinę';

  @override
  String get gundemRepeatDaily => 'Codziennie';

  @override
  String get gundemRepeatWeekly => 'Co tydzień';

  @override
  String get gundemRepeatMonthly => 'Co miesiąc';

  @override
  String get gundemRepeatYearly => 'Co rok';

  @override
  String get gundemPreviewCalcTableLabel => '[Lista obliczeniowa]';

  @override
  String get gundemPreviewDrawingLabel => '[Rysunek]';

  @override
  String get gundemPreviewImageLabel => '[Obraz]';

  @override
  String get gundemMonthShortJan => 'Sty';

  @override
  String get gundemMonthShortFeb => 'Lut';

  @override
  String get gundemMonthShortMar => 'Mar';

  @override
  String get gundemMonthShortApr => 'Kwi';

  @override
  String get gundemMonthShortMay => 'Maj';

  @override
  String get gundemMonthShortJun => 'Cze';

  @override
  String get gundemMonthShortJul => 'Lip';

  @override
  String get gundemMonthShortAug => 'Sie';

  @override
  String get gundemMonthShortSep => 'Wrz';

  @override
  String get gundemMonthShortOct => 'Paź';

  @override
  String get gundemMonthShortNov => 'Lis';

  @override
  String get gundemMonthShortDec => 'Gru';

  @override
  String get calendarAppBarTitle => 'Kalendarz';

  @override
  String get calendarTodayButton => 'Dzisiaj';

  @override
  String get calendarLegendNoteLabel => 'Notatka';

  @override
  String get calendarLegendReminderLabel => 'Przypomnienie';

  @override
  String get calendarTodayBadge => 'Dzisiaj';

  @override
  String get calendarEmptyDayMessage =>
      'Brak notatek ani przypomnień na ten dzień.';

  @override
  String get calendarReminderHourlyLabel => 'Co godzinę';

  @override
  String get calendarMonthJan => 'Styczeń';

  @override
  String get calendarMonthFeb => 'Luty';

  @override
  String get calendarMonthMar => 'Marzec';

  @override
  String get calendarMonthApr => 'Kwiecień';

  @override
  String get calendarMonthMay => 'Maj';

  @override
  String get calendarMonthJun => 'Czerwiec';

  @override
  String get calendarMonthJul => 'Lipiec';

  @override
  String get calendarMonthAug => 'Sierpień';

  @override
  String get calendarMonthSep => 'Wrzesień';

  @override
  String get calendarMonthOct => 'Październik';

  @override
  String get calendarMonthNov => 'Listopad';

  @override
  String get calendarMonthDec => 'Grudzień';

  @override
  String get calendarWeekdayShortMon => 'Pon';

  @override
  String get calendarWeekdayShortTue => 'Wt';

  @override
  String get calendarWeekdayShortWed => 'Śr';

  @override
  String get calendarWeekdayShortThu => 'Czw';

  @override
  String get calendarWeekdayShortFri => 'Pt';

  @override
  String get calendarWeekdayShortSat => 'Sob';

  @override
  String get calendarWeekdayShortSun => 'Nd';

  @override
  String get calendarWeekdayFullMonday => 'Poniedziałek';

  @override
  String get calendarWeekdayFullTuesday => 'Wtorek';

  @override
  String get calendarWeekdayFullWednesday => 'Środa';

  @override
  String get calendarWeekdayFullThursday => 'Czwartek';

  @override
  String get calendarWeekdayFullFriday => 'Piątek';

  @override
  String get calendarWeekdayFullSaturday => 'Sobota';

  @override
  String get calendarWeekdayFullSunday => 'Niedziela';

  @override
  String get wrongPasswordDialogTitle => 'Nieprawidłowe hasło';

  @override
  String get wrongPasswordDialogMessage =>
      'Wprowadzone hasło jest nieprawidłowe.';

  @override
  String get commonOkButton => 'OK';

  @override
  String get unlockCategoryAction => 'Odblokuj';

  @override
  String get lockCategoryAction => 'Zablokuj';

  @override
  String get categoryUnlockedMessage => 'Odblokowano';

  @override
  String get categoryLockedMessage => 'Folder zablokowany';

  @override
  String get deleteFolderMenuItemLabel => 'Usuń folder';

  @override
  String get deleteFolderDialogTitle => 'Usuń folder';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'Czy na pewno chcesz usunąć folder „$category” i wszystkie jego podfoldery? Notatki w tych folderach staną się nieskategoryzowane.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'Czy na pewno chcesz usunąć folder „$category”? Notatki w tym folderze staną się nieskategoryzowane.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'Anuluj';

  @override
  String get deleteFolderDialogConfirmButton => 'Usuń';

  @override
  String get editCategoryNameColorMenuItemLabel => 'Edytuj nazwę / kolor';

  @override
  String get addSubfolderMenuItemLabel => 'Utwórz podfolder';

  @override
  String get expandSubfoldersMenuItemLabel => 'Rozwiń podfoldery';

  @override
  String get collapseSubfoldersMenuItemLabel => 'Zwiń podfoldery';

  @override
  String saveErrorInfoMessage(String error) {
    return 'Błąd zapisu: $error';
  }

  @override
  String get welcomeNoteTitle => 'Witaj w DNote! 🚀';

  @override
  String get welcomeNoteContent => 'Dodano nowe funkcje!';

  @override
  String get noteListDateGroupToday => 'Dzisiaj';

  @override
  String get noteListDateGroupYesterday => 'Wczoraj';

  @override
  String get noteListDateGroupLast7Days => 'Ostatnie 7 dni';

  @override
  String get noteListDateGroupLast30Days => 'Ostatnie 30 dni';

  @override
  String get reminderRepeatNoneLabel => 'Bez powtarzania';

  @override
  String get voiceRecorderPreparingLabel => 'Przygotowywanie…';

  @override
  String get voiceRecorderCancelButton => 'Anuluj';

  @override
  String get voiceRecorderStopAddButton => 'Zatrzymaj i dodaj';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'Nie przyznano uprawnienia do mikrofonu.';

  @override
  String get speechToTextUnavailableMessage =>
      'Rozpoznawanie mowy jest niedostępne na tym urządzeniu.';

  @override
  String get speechToTextPreparingLabel => 'Przygotowywanie…';

  @override
  String get speechToTextListeningLabel => 'Słucham…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'Zacznij mówić…';

  @override
  String get speechToTextCancelButton => 'Anuluj';

  @override
  String get speechToTextStopAddButton => 'Zatrzymaj i dodaj';

  @override
  String get textToSpeechNoContentMessage => 'Brak treści do odczytania.';

  @override
  String get textToSpeechReadErrorMessage => 'Wystąpił błąd podczas odczytu.';

  @override
  String get textToSpeechUnavailableMessage =>
      'Zamiana tekstu na mowę jest niedostępna na tym urządzeniu.';

  @override
  String get textToSpeechPreparingLabel => 'Przygotowywanie…';

  @override
  String get textToSpeechPausedLabel => 'Wstrzymano';

  @override
  String get textToSpeechFinishedLabel => 'Odczyt zakończony';

  @override
  String get textToSpeechReadingLabel => 'Czytanie…';

  @override
  String get textToSpeechCloseErrorButton => 'Zamknij';

  @override
  String get textToSpeechReplayButton => 'Czytaj ponownie';

  @override
  String get textToSpeechCloseFinishedButton => 'Zamknij';

  @override
  String get textToSpeechPauseButton => 'Wstrzymaj';

  @override
  String get textToSpeechResumeButton => 'Wznów';

  @override
  String get textToSpeechStopButton => 'Zatrzymaj';

  @override
  String get textToSpeechSpeedSlow => 'Wolno';

  @override
  String get textToSpeechSpeedNormal => 'Normalnie';

  @override
  String get textToSpeechSpeedFast => 'Szybko';

  @override
  String get calendarPickerCancelButton => 'Anuluj';

  @override
  String get calendarPickerConfirmButton => 'Wybierz';

  @override
  String get calendarPickerClearButton => 'Wyczyść';

  @override
  String get reminderPickerDialogTitle => 'Dodaj przypomnienie';

  @override
  String get reminderPickerDateTodayOption => 'Dzisiaj';

  @override
  String get reminderPickerDateTomorrowOption => 'Jutro';

  @override
  String get reminderPickerDatePickOption => 'Wybierz datę';

  @override
  String get reminderRepeatHourlyLabel => 'Co godzinę';

  @override
  String get reminderRepeatDailyLabel => 'Codziennie';

  @override
  String get reminderRepeatWeeklyLabel => 'Co tydzień';

  @override
  String get reminderRepeatMonthlyLabel => 'Co miesiąc';

  @override
  String get reminderRepeatYearlyLabel => 'Co rok';

  @override
  String get reminderPickerCalendarHelpText => 'Wybierz datę przypomnienia';

  @override
  String get reminderPickerCancelButton => 'ANULUJ';

  @override
  String get reminderPickerSaveButton => 'ZAPISZ';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'Nie można wybrać czasu w przeszłości';

  @override
  String calcTableTotalLabel(String amount) {
    return 'Suma: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'Przygotowywanie danych...';

  @override
  String get backupCreatePackagingNotesLabel =>
      'Pakowanie notatek i kategorii...';

  @override
  String get backupCreateReadingAttachmentsLabel =>
      'Odczytywanie załączników...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'Odczytywanie załączników... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'Kompresowanie pliku zip...';

  @override
  String get backupCreateSavingFileLabel => 'Zapisywanie pliku...';

  @override
  String get backupRestoreValidatingLabel => 'Sprawdzanie kopii zapasowej...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'Kopia zapasowa zweryfikowana, przygotowywanie danych...';

  @override
  String get backupRestoreWritingNotesLabel => 'Zapisywanie notatek...';

  @override
  String get backupRestoreWritingTrashLabel => 'Zapisywanie kosza...';

  @override
  String get backupRestoreTrashWrittenLabel => 'Kosz zapisany';

  @override
  String get backupRestoreWritingCategoriesLabel => 'Zapisywanie kategorii...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'Kategorie zapisane';

  @override
  String get backupRestoreWritingSettingsLabel => 'Zapisywanie ustawień...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'Ustawienia zapisane';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'Czyszczenie starych załączników...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'Nie znaleziono załączników, kończenie...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'Przywracanie załączników... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'Zakończono';

  @override
  String get backupValidationCorruptedFileMessage =>
      'Plik jest uszkodzony lub nie jest prawidłowym plikiem kopii zapasowej.';

  @override
  String get backupValidationMissingDataMessage =>
      'Nie znaleziono danych w pliku kopii zapasowej (brak pliku backup_data.json).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'Nie udało się odczytać danych kopii zapasowej (uszkodzony JSON).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'Ten plik nie jest kopią zapasową z aplikacji dnote.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'Nie udało się odczytać informacji o wersji pliku kopii zapasowej.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'Ta kopia zapasowa jest w nowszym formacie, którego nie obsługuje bieżąca wersja aplikacji. Zaktualizuj aplikację.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'Informacja o wersji pliku kopii zapasowej jest nieprawidłowa.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'Dane kopii zapasowej nie mają oczekiwanego formatu (brak pola notes).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'Dane kopii zapasowej nie mają oczekiwanego formatu (brak pola trash).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'Dane kopii zapasowej nie mają oczekiwanego formatu (lista kategorii jest nieprawidłowa).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'Dane kopii zapasowej nie mają oczekiwanego formatu (pole ustawień jest nieprawidłowe).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'Dane kopii zapasowej nie mają oczekiwanego formatu (rekord notatki jest nieprawidłowy).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'Dane kopii zapasowej nie mają oczekiwanego formatu (znaleziono rekord notatki bez ID).';

  @override
  String get backupValidationFileNotFoundMessage =>
      'Nie znaleziono pliku kopii zapasowej.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'Za mało wolnego miejsca na urządzeniu. Zwolnij miejsce i spróbuj ponownie.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'Odmówiono uprawnienia dostępu do plików. Sprawdź uprawnienia aplikacji i spróbuj ponownie.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'Wystąpił błąd podczas operacji na pliku: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'Wystąpił nieoczekiwany błąd: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'Nie udało się utworzyć archiwum zip (ZipEncoder zwrócił null).';

  @override
  String get calcTableMenuItemLabel => 'Lista obliczeniowa';

  @override
  String get tagsMenuItemLabel => 'Tagi';

  @override
  String get linkDialogUrlHint => 'https://example.com';

  @override
  String get checklistItemHint => 'Dodaj element...';

  @override
  String get toolbarHighlightTooltip => 'Wyróżnienie';

  @override
  String get toolbarListTooltip => 'Lista';

  @override
  String get toolbarHideKeyboardTooltip => 'Ukryj klawiaturę';

  @override
  String get autoBackupLocalSuccessMessage =>
      'Lokalna kopia zapasowa zakończona sukcesem.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'Lokalna kopia zapasowa nie powiodła się: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Pominięto kopię zapasową na Dysku: konto Google nie jest połączone lub sesja wygasła. Otwórz aplikację i połącz się ponownie.';

  @override
  String get autoBackupDriveSuccessMessage =>
      'Kopia zapasowa na Dysku zakończona sukcesem.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Kopia zapasowa na Dysku nie powiodła się: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'Brak notatek';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'Suma: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ Rysunek';

  @override
  String get autoBackupSettingsAppBarTitle =>
      'Ustawienia automatycznej kopii zapasowej';

  @override
  String get autoBackupSettingsMainSwitchTitle =>
      'Włącz automatyczną kopię zapasową';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'Twoje notatki są bezpiecznie tworzone jako kopia zapasowa okresowo w tle.';

  @override
  String get autoBackupSettingsTargetTitle => 'Cel kopii zapasowej';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'Wybierz, gdzie zapisywane są kopie zapasowe.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'Lokalnie';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'Oba';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Najpierw połącz konto, aby korzystać z opcji Google Drive.';

  @override
  String get autoBackupSettingsConnectButton => 'Połącz';

  @override
  String get autoBackupSettingsFrequencyTitle =>
      'Częstotliwość kopii zapasowej';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'Kopia zapasowa jest tworzona co $hours godzin.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 godzin';

  @override
  String get autoBackupSettingsFrequency12h => '12 godzin';

  @override
  String get autoBackupSettingsFrequency24h => '24 godziny (codziennie)';

  @override
  String get autoBackupSettingsFrequency48h => '48 godzin (2 dni)';

  @override
  String get autoBackupSettingsFrequency168h => '168 godzin (co tydzień)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Używaj tylko Wi-Fi';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'Przesyłanie do chmury odbywa się tylko przez Wi-Fi, aby chronić Twoje dane mobilne.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'Stan systemu';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'Automatyczna kopia zapasowa nie została jeszcze uruchomiona.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'Ostatnie uruchomienie: $date $time ($status)\nWiadomość: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'Sukces';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'Niepowodzenie';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Nie udało się połączyć z kontem Google.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'Zaktualizowano ustawienia automatycznej kopii zapasowej.';

  @override
  String selectionModeDeletedMessage(int count) {
    return 'Usunięto $count notatek';
  }

  @override
  String get selectionModeArchivedMessage => 'Zarchiwizowano';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'Wybierz kategorię dla $count notatek';
  }

  @override
  String get selectionModeAddCategoryOption => 'Dodaj kategorię';

  @override
  String get selectionModeRemoveCategoryOption => 'Usuń kategorię';

  @override
  String get calcTableItemHint => 'Element...';

  @override
  String get calcTableTotalRowLabel => 'Suma';

  @override
  String get textSelectionMenuShareButton => 'Udostępnij';

  @override
  String get textSelectionMenuTranslateButton => 'Przetłumacz';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'Nie udało się rozpocząć udostępniania.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'Nie udało się otworzyć tłumaczenia.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'Dzisiaj $time';
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
    return 'Ostatnia kopia zapasowa: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage =>
      'Nie utworzono jeszcze żadnej kopii zapasowej.';

  @override
  String get backupFileNameLabel => 'Kopia zapasowa';
}
