// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'Жирний';

  @override
  String get toolbarItalicTooltip => 'Курсив';

  @override
  String get toolbarUnderlineTooltip => 'Підкреслення';

  @override
  String get toolbarStrikethroughTooltip => 'Закреслення';

  @override
  String get toolbarFontSizeTooltip => 'Розмір шрифту';

  @override
  String get toolbarColorTooltip => 'Колір тексту';

  @override
  String get toolbarBulletTooltip => 'Маркований список';

  @override
  String get toolbarNumberTooltip => 'Нумерований список';

  @override
  String get toolbarIndentTooltip => 'Відступ абзацу';

  @override
  String get toolbarLinkTooltip => 'Додати / редагувати / видалити посилання';

  @override
  String get toolbarDividerTooltip => 'Вставити розділювач';

  @override
  String get toolbarChecklistTooltip => 'Додати список завдань';

  @override
  String get linkSelectTextSnackbar =>
      'Спершу виділіть текст, який хочете зробити посиланням';

  @override
  String get linkDialogEditTitle => 'Редагувати посилання';

  @override
  String get linkDialogAddTitle => 'Додати посилання';

  @override
  String get linkDialogRemoveButton => 'Видалити посилання';

  @override
  String get linkDialogCancelButton => 'Скасувати';

  @override
  String get linkDialogConfirmButton => 'Додати';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Доступ до камери заборонено. Щоб записувати відео, дозвольте доступ у налаштуваннях.';

  @override
  String get cameraPermissionRequiredMessage =>
      'Для запису відео потрібен дозвіл на використання камери.';

  @override
  String get openSettingsButtonLabel => 'Налаштування';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'Не вдалося почати сканування: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'Розпізнавання тексту не вдалося: $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'У документі не знайдено тексту, придатного для розпізнавання';

  @override
  String get scanResultSheetTitle => 'Як додати відсканований документ?';

  @override
  String get scanResultTextOnlyOption => 'Додати лише як текст';

  @override
  String get scanResultTextAndImageOption =>
      'Додати текст + відскановане зображення';

  @override
  String get scanResultCancelOption => 'Скасувати';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'Доступ до мікрофона заборонено. Щоб записувати звук, дозвольте доступ у налаштуваннях.';

  @override
  String get audioPermissionRequiredMessage =>
      'Для запису аудіо потрібен дозвіл на використання мікрофона.';

  @override
  String get voiceRecordingDefaultLabel => 'Голосовий запис';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'Список розрахунків ($count рядків)';
  }

  @override
  String blockPreviewTableLabel(int count) {
    return 'Таблиця ($count рядків)';
  }

  @override
  String get blockPreviewDrawingLabel => 'Малюнок';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count вкладень (фото/документ)';
  }

  @override
  String get blockPreviewDividerLabel => 'Розділювач';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'Список завдань ($count пунктів)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(порожній текст)';

  @override
  String get reorderBlocksSheetTitle => 'Змінити порядок блоків';

  @override
  String get reorderBlocksMoveUpTooltip => 'Перемістити вгору';

  @override
  String get reorderBlocksMoveDownTooltip => 'Перемістити вниз';

  @override
  String get reorderBlocksCloseTooltip => 'Закрити';

  @override
  String get reorderBlocksDescription =>
      'Торкніться блоку, щоб вибрати його, потім використайте стрілки вгору/вниз для переміщення.';

  @override
  String get reorderBlocksMenuItemLabel => 'Змінити порядок';

  @override
  String get txtImportPickerDialogTitle => 'Виберіть TXT-файл для імпорту';

  @override
  String get txtImportReadFailedMessage => 'Не вдалося прочитати TXT-файл';

  @override
  String get txtImportEmptyFileMessage => 'TXT-файл порожній';

  @override
  String get txtImportSuccessMessage => 'TXT імпортовано';

  @override
  String get txtImportMenuItemLabel => 'Імпорт (txt)';

  @override
  String get exportMenuItemLabel => 'Експорт';

  @override
  String get editorUndoTooltip => 'Скасувати';

  @override
  String get editorRedoTooltip => 'Повторити';

  @override
  String get noteSavedMessage => 'Нотатку збережено';

  @override
  String get dateAssignPickerHelpText => 'Призначити нотатку на день';

  @override
  String get dateAssignChangeOption => 'Змінити дату';

  @override
  String get dateAssignRemoveOption => 'Скасувати призначення';

  @override
  String get editorSubToolbarCloseTooltip => 'Закрити';

  @override
  String get titleFieldHint => 'Заголовок';

  @override
  String get textBlockHint => 'Напишіть свою нотатку тут...';

  @override
  String get drawingBoardMenuItemLabel => 'Дошка для малювання';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'Перетворення голосу на текст доступне лише для текстових нотаток';

  @override
  String get selectionModeCancelTooltip => 'Скасувати вибір';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return 'Вибрано: $count';
  }

  @override
  String get selectionModeDeleteTooltip => 'Видалити';

  @override
  String get selectionModeArchiveTooltip => 'Архівувати';

  @override
  String get selectionModeFolderTooltip => 'Папка';

  @override
  String get searchFieldHint => 'Пошук нотаток...';

  @override
  String get emptyTrashDialogTitle => 'Очистити кошик';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'Усі видалені нотатки буде остаточно видалено. Ви впевнені?';

  @override
  String get emptyTrashDialogCancelButton => 'Скасувати';

  @override
  String get restoreAllMenuItemLabel => 'Відновити всі';

  @override
  String get sortMenuTooltip => 'Сортувати нотатки';

  @override
  String get sortMenuAscendingLabel => 'Порядок: за зростанням (А-Я)';

  @override
  String get sortMenuDescendingLabel => 'Порядок: за спаданням (Я-А)';

  @override
  String get sortMenuByTitleLabel => 'Сортувати за: заголовком';

  @override
  String get sortMenuByModifiedDateLabel => 'Сортувати за: датою зміни';

  @override
  String get sortMenuByCreatedDateLabel => 'Сортувати за: датою створення';

  @override
  String get sortMenuByFolderLabel => 'Сортувати за: папкою';

  @override
  String get viewToggleGridTooltip => 'Вигляд сіткою';

  @override
  String get viewToggleListTooltip => 'Вигляд списком';

  @override
  String get drawerHeaderSubtitle => 'Ваш особистий блокнот';

  @override
  String get drawerNotesSectionHeader => 'НОТАТКИ';

  @override
  String get drawerAllNotesLabel => 'Нотатки';

  @override
  String get drawerFavoritesLabel => 'Обране';

  @override
  String get drawerAgendaLabel => 'Порядок денний';

  @override
  String get drawerRemindersLabel => 'Нагадування';

  @override
  String get drawerLockedLabel => 'Заблоковані';

  @override
  String get drawerTrashLabel => 'Кошик';

  @override
  String get drawerFoldersSectionHeader => 'ПАПКИ';

  @override
  String get drawerExpandLabel => 'Розгорнути';

  @override
  String get drawerCollapseLabel => 'Згорнути';

  @override
  String get drawerAddFolderLabel => 'Додати папку';

  @override
  String get drawerAppSectionHeader => 'ДОДАТОК';

  @override
  String get drawerCalendarLabel => 'Календар';

  @override
  String get drawerSettingsLabel => 'Налаштування';

  @override
  String get drawerBackupRestoreLabel => 'Резервне копіювання й відновлення';

  @override
  String get drawerUpgradeToProLabel => 'Оновити до Pro';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'Підтримати розробку';

  @override
  String get drawerFeedbackLabel => 'Зворотний зв\'язок';

  @override
  String get drawerRateAppLabel => 'Оцінити застосунок';

  @override
  String get drawerAboutLabel => 'Про додаток';

  @override
  String get noNotesFoundMessage => 'Нотаток не знайдено.';

  @override
  String get trashRestoreButtonLabel => 'Відновити';

  @override
  String get trashPermanentDeleteButtonLabel => 'Видалити назавжди';

  @override
  String get tagRenamedInfoMessage => 'Тег перейменовано';

  @override
  String get tagDeletedInfoMessage => 'Тег видалено';

  @override
  String get tagOptionsRenameLabel => 'Перейменувати';

  @override
  String get tagOptionsDeleteLabel => 'Видалити';

  @override
  String get renameTagDialogTitle => 'Перейменувати тег';

  @override
  String get renameTagDialogHint => 'Нова назва тегу';

  @override
  String get renameTagDialogCancelButton => 'Скасувати';

  @override
  String get renameTagDialogSaveButton => 'Зберегти';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '«$tag» буде видалено з $affectedCount нотаток. Продовжити?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'Видалити тег «$tag»?';
  }

  @override
  String get deleteTagDialogTitle => 'Видалити тег';

  @override
  String get deleteTagDialogCancelButton => 'Скасувати';

  @override
  String get deleteTagDialogConfirmButton => 'Видалити';

  @override
  String get tagsSheetTitle => 'Теги';

  @override
  String get tagsSheetEmptyMessage => 'У цій нотатці ще немає тегів.';

  @override
  String get tagsSheetInputHint => 'Введіть новий тег...';

  @override
  String get tagsSheetSuggestionsLabel => 'Наявні теги';

  @override
  String get noteDeletedInfoMessage => 'Нотатку видалено';

  @override
  String get noteDeletedUndoActionLabel => 'Скасувати';

  @override
  String get reminderSetInfoMessage => 'Нагадування встановлено';

  @override
  String get reminderRemovedInfoMessage => 'Нагадування видалено';

  @override
  String get noteDuplicatedInfoMessage => 'Копію створено';

  @override
  String get speechTextAppendedInfoMessage => 'Текст додано до нотатки';

  @override
  String get pdfPreparingInfoMessage => 'Підготовка PDF…';

  @override
  String get pdfSavedInfoMessage => 'PDF збережено';

  @override
  String get pdfPreviewSaveActionLabel => 'Зберегти';

  @override
  String get jpgPreparingInfoMessage => 'Підготовка JPG…';

  @override
  String get jpgSavedInfoMessage => 'JPG збережено';

  @override
  String get jpgFailedInfoMessage => 'Не вдалося створити JPG';

  @override
  String get txtPreparingInfoMessage => 'Підготовка TXT…';

  @override
  String get txtSavedInfoMessage => 'TXT збережено';

  @override
  String get txtFailedInfoMessage => 'Не вдалося створити TXT';

  @override
  String get exportOpenActionLabel => 'Відкрити';

  @override
  String get wrongPasswordInfoMessage => 'Неправильний пароль.';

  @override
  String get noteArchivedInfoMessage => 'Нотатку заархівовано';

  @override
  String get noteUnarchivedInfoMessage => 'Видалено з архіву';

  @override
  String get noteUnlockedInfoMessage => 'Розблоковано';

  @override
  String get noteLockedInfoMessage => 'Нотатку заблоковано';

  @override
  String get notificationUnpinnedInfoMessage => 'Відкріплено';

  @override
  String get emptyNotePinBlockedInfoMessage =>
      'Порожню нотатку не можна закріпити.';

  @override
  String get notificationPinnedInfoMessage => 'Закріплено на панелі сповіщень';

  @override
  String get noContentToReadInfoMessage => 'Немає вмісту для читання';

  @override
  String get backPressExitInfoMessage => 'Натисніть «Назад» ще раз, щоб вийти';

  @override
  String get reminderChannelName => 'Нагадування про нотатки';

  @override
  String get reminderChannelDescription =>
      'Нагадування про нотатки в додатку Layout';

  @override
  String get pinnedChannelName => 'Закріплені нотатки';

  @override
  String get pinnedChannelDescription =>
      'Нотатки Layout, закріплені на панелі сповіщень';

  @override
  String get notificationUnpinActionLabel => 'Видалити';

  @override
  String get reminderDefaultTitle => 'Нагадування';

  @override
  String get reminderChecklistBodyFallback =>
      'Не забудьте перевірити свій список завдань';

  @override
  String get reminderTextBodyFallback => 'Не забудьте переглянути свою нотатку';

  @override
  String get pdfSaveDialogTitle => 'Зберегти як PDF';

  @override
  String get jpgSaveDialogTitle => 'Зберегти як JPG';

  @override
  String get txtSaveDialogTitle => 'Зберегти як TXT';

  @override
  String get textSizeSheetTitle => 'Розмір тексту';

  @override
  String get textSizeSamplePreview => 'Приклад тексту';

  @override
  String get textSizeCancelButton => 'Скасувати';

  @override
  String get textSizeApplyButton => 'Застосувати';

  @override
  String get createPasswordDialogTitle => 'Створити пароль';

  @override
  String get createPasswordNewPasswordHint => 'Новий пароль';

  @override
  String get createPasswordConfirmHint => 'Повторіть пароль';

  @override
  String get createPasswordHintQuestionDescription =>
      'Встановіть контрольне запитання на випадок, якщо забудете пароль (необов\'язково).';

  @override
  String get createPasswordHintQuestionHint => 'Виберіть контрольне запитання';

  @override
  String get createPasswordHintAnswerHint => 'Ваша відповідь';

  @override
  String get createPasswordCancelButton => 'Скасувати';

  @override
  String get createPasswordSaveButton => 'Зберегти';

  @override
  String get passwordMismatchMessage => 'Паролі не збігаються!';

  @override
  String get passwordRequiredDialogTitle => 'Потрібен пароль';

  @override
  String get passwordRequiredHint => 'Введіть пароль';

  @override
  String get forgotPasswordButtonLabel => 'Я забув пароль';

  @override
  String get passwordRequiredCancelButton => 'Скасувати';

  @override
  String get passwordRequiredConfirmButton => 'Підтвердити';

  @override
  String get securityQuestionDialogTitle => 'Контрольне запитання';

  @override
  String get securityQuestionAnswerHint => 'Ваша відповідь';

  @override
  String get securityQuestionCancelButton => 'Скасувати';

  @override
  String get securityQuestionConfirmButton => 'Підтвердити';

  @override
  String get securityQuestionWrongAnswerMessage =>
      'Неправильна відповідь. Спробуйте ще раз.';

  @override
  String get revealedPasswordDialogTitle => 'Ваш пароль';

  @override
  String get revealedPasswordLabel => 'Пароль вашої нотатки:';

  @override
  String get revealedPasswordOkButton => 'ОК';

  @override
  String get securityQuestionPetName =>
      'Як звали вашого першого домашнього улюбленця?';

  @override
  String get securityQuestionFavoriteTeacher =>
      'Як звали вашого улюбленого вчителя?';

  @override
  String get securityQuestionBirthCity => 'У якому місті ви народилися?';

  @override
  String get securityQuestionFavoriteFood => 'Яка ваша улюблена страва?';

  @override
  String get securityQuestionMotherMaidenName =>
      'Яке дівоче прізвище вашої матері?';

  @override
  String get securityQuestionFirstSchool =>
      'Як називалася перша школа, яку ви відвідували?';

  @override
  String get securityQuestionFavoriteColor => 'Який ваш улюблений колір?';

  @override
  String get editFolderDialogTitle => 'Редагувати папку';

  @override
  String get newSubfolderDialogTitle => 'Нова підпапка';

  @override
  String get addFolderDialogTitle => 'Додати папку';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'Буде створено всередині «$parentCategory»';
  }

  @override
  String get subfolderNameFieldLabel => 'Назва підпапки';

  @override
  String get folderNameFieldLabel => 'Назва папки';

  @override
  String get folderColorLabel => 'Колір';

  @override
  String get folderDialogCancelButton => 'Скасувати';

  @override
  String get folderDialogSaveButton => 'Зберегти';

  @override
  String get folderDialogAddButton => 'Додати';

  @override
  String get selectFolderSheetTitle => 'Вибрати папку';

  @override
  String get selectFolderAddOptionLabel => 'Додати папку';

  @override
  String get removeCurrentFolderLabel => 'Прибрати з поточної папки';

  @override
  String get noteDetailsDialogTitle => 'Деталі';

  @override
  String get noteDetailsCreatedLabel => 'Створено';

  @override
  String get noteDetailsModifiedLabel => 'Востаннє змінено';

  @override
  String get noteDetailsCharCountLabel => 'Кількість символів';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count символів';
  }

  @override
  String get noteDetailsWordCountLabel => 'Кількість слів';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count слів';
  }

  @override
  String get noteDetailsOkButton => 'ОК';

  @override
  String get noteDetailsUnknownDateLabel => 'Невідомо';

  @override
  String get addAttachmentSheetTitle => 'Додати';

  @override
  String get addAttachmentImageOption => 'Додати зображення';

  @override
  String get addAttachmentCameraOption => 'Камера';

  @override
  String get addAttachmentFileOption => 'Додати файл';

  @override
  String get addAttachmentVoiceOption => 'Голосовий запис';

  @override
  String get addAttachmentVideoOption => 'Записати відео';

  @override
  String get addAttachmentScanOption => 'Сканувати документ';

  @override
  String get noteActionsSheetTitle => 'Виберіть дію';

  @override
  String get noteActionReminderLabel => 'Нагадування';

  @override
  String get noteActionEditReminderLabel => 'Редагувати нагадування';

  @override
  String get noteActionSpeechToTextLabel => 'Голос у текст';

  @override
  String get noteActionArchiveLabel => 'Архівувати';

  @override
  String get noteActionUnarchiveLabel => 'Видалити з архіву';

  @override
  String get noteActionLockLabel => 'Заблокувати';

  @override
  String get noteActionUnlockLabel => 'Розблокувати';

  @override
  String get noteActionFavoriteLabel => 'Додати в обране';

  @override
  String get noteActionUnfavoriteLabel => 'Видалити з обраного';

  @override
  String get noteActionClassifyLabel => 'Вибрати папку';

  @override
  String get noteActionDeleteLabel => 'Видалити';

  @override
  String get noteActionPinToNotificationLabel =>
      'Закріпити на панелі сповіщень';

  @override
  String get noteActionUnpinFromNotificationLabel => 'Відкріпити';

  @override
  String get noteActionShareLabel => 'Поділитися';

  @override
  String get noteActionDuplicateLabel => 'Створити копію';

  @override
  String get noteActionCopyContentLabel => 'Копіювати вміст';

  @override
  String get noteActionTtsLabel => 'Прочитати вголос';

  @override
  String get noteActionTextSizeLabel => 'Розмір тексту';

  @override
  String get noteActionDetailsLabel => 'Деталі';

  @override
  String get noteActionDiscardChangesLabel => 'Скасувати зміни';

  @override
  String get noteActionSelectLabel => 'Вибрати';

  @override
  String get reminderEditOptionLabel => 'Змінити нагадування';

  @override
  String get reminderRemoveOptionLabel => 'Видалити нагадування';

  @override
  String get discardChangesDialogTitle => 'Скасувати зміни';

  @override
  String get discardChangesDialogMessage =>
      'Незбережені зміни в цій нотатці буде втрачено. Ви впевнені, що хочете їх скасувати?';

  @override
  String get discardChangesCancelButton => 'Скасувати';

  @override
  String get discardChangesConfirmButton => 'Скасувати зміни';

  @override
  String get pinnedNotificationDefaultTitle => 'Нотатка';

  @override
  String get pdfFailedInfoMessage => 'Не вдалося створити PDF';

  @override
  String get drawingScreenTitle => 'Малюнок';

  @override
  String get drawingMinimizeTooltip => 'Згорнути';

  @override
  String get drawingEmptyExportWarningMessage => 'Спочатку щось намалюйте';

  @override
  String get drawingEraserPartialModeLabel => 'Частково';

  @override
  String get drawingEraserFullModeLabel => 'Повністю';

  @override
  String get drawingClearTooltip => 'Очистити';

  @override
  String get drawingZoomOutTooltip => 'Зменшити';

  @override
  String get drawingZoomInTooltip => 'Збільшити';

  @override
  String get drawingDeleteTooltip => 'Видалити';

  @override
  String get drawingEmptyPreviewHint => 'Торкніться, щоб малювати';

  @override
  String get settingsPageTitle => 'Налаштування';

  @override
  String get settingsSectionGeneral => 'Загальні';

  @override
  String get settingsSectionSecurity => 'Безпека';

  @override
  String get settingsSectionTheme => 'Тема';

  @override
  String get settingsSectionPersonalization => 'Персоналізація';

  @override
  String get settingsSectionWidget => 'Віджет';

  @override
  String get settingsSectionAbout => 'Про додаток';

  @override
  String get settingsHintQuestionPet =>
      'Як звали вашого першого домашнього улюбленця?';

  @override
  String get settingsHintQuestionTeacher =>
      'Як звали вашого улюбленого вчителя?';

  @override
  String get settingsHintQuestionBirthCity => 'У якому місті ви народилися?';

  @override
  String get settingsHintQuestionFavoriteFood => 'Яка ваша улюблена страва?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'Яке дівоче прізвище вашої матері?';

  @override
  String get settingsHintQuestionFirstSchool =>
      'Яка перша школа, яку ви відвідували?';

  @override
  String get settingsHintQuestionFavoriteColor => 'Який ваш улюблений колір?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'Контрольне запитання';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'Якщо ви забудете пароль, ви зможете відновити його, правильно відповівши на це запитання.';

  @override
  String get settingsSecurityQuestionDropdownHint =>
      'Виберіть контрольне запитання';

  @override
  String get settingsSecurityQuestionAnswerHint => 'Ваша відповідь';

  @override
  String get settingsSecurityQuestionCancelButton => 'Скасувати';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'Запитання та відповідь не можуть бути порожніми!';

  @override
  String get settingsSecurityQuestionSaveButton => 'Зберегти';

  @override
  String get settingsCreatePasswordTitle => 'Створити пароль';

  @override
  String get settingsPasswordRequiredTitle => 'Потрібен пароль';

  @override
  String get settingsPasswordEnterHint => 'Введіть пароль';

  @override
  String get settingsForgotPasswordButton => 'Я забув пароль';

  @override
  String get settingsNewPasswordHint => 'Новий пароль';

  @override
  String get settingsConfirmPasswordHint => 'Повторіть пароль';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'Встановіть контрольне запитання на випадок, якщо забудете пароль (необов\'язково).';

  @override
  String get settingsPasswordDialogCancelButton => 'Скасувати';

  @override
  String get settingsPasswordMismatchWarning => 'Паролі не збігаються!';

  @override
  String get settingsWrongPasswordWarning => 'Неправильний пароль!';

  @override
  String get settingsPasswordSaveButton => 'Зберегти';

  @override
  String get settingsPasswordRemoveButton => 'Видалити';

  @override
  String get settingsNotePasswordTitle => 'Пароль нотатки';

  @override
  String get settingsPasswordSetSubtitle => 'Пароль установлено ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'Пароль не встановлено';

  @override
  String get settingsSecurityQuestionTileTitle => 'Контрольне запитання';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'Встановлено ✓ — використовується, якщо ви забудете пароль';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'Не встановлено — ви не зможете відновити пароль у разі втрати';

  @override
  String get settingsThemeDialogTitle => 'Вибрати тему';

  @override
  String get settingsThemeSystemDefault => 'Системна за замовчуванням';

  @override
  String get settingsThemeLightOption => 'Світла тема';

  @override
  String get settingsThemeDarkOption => 'Темна тема';

  @override
  String get settingsLanguageDialogTitle => 'Вибрати мову';

  @override
  String get settingsLanguageSystemOption => 'Системна';

  @override
  String get settingsAccentColorDialogTitle => 'Вибрати акцентний колір';

  @override
  String get settingsThemeChangeTileTitle => 'Змінити тему';

  @override
  String get settingsThemeLightLabel => 'Світла';

  @override
  String get settingsThemeDarkLabel => 'Темна';

  @override
  String get settingsThemeSystemLabel => 'Системна';

  @override
  String get settingsLanguageTileTitle => 'Мова';

  @override
  String get settingsAccentColorTileTitle => 'Акцентний колір';

  @override
  String get settingsAccentColorTileSubtitle =>
      'Колір, що використовується на панелі додатку, кнопках і перемикачах';

  @override
  String get settingsColorfulNotesTitle => 'Різнокольорові нотатки';

  @override
  String get settingsColorfulNotesSubtitle =>
      'Кожна картка нотатки отримує інший відтінок кольору.';

  @override
  String get settingsTextColorSheetTitle => 'Колір тексту';

  @override
  String get settingsTextColorSheetDesc =>
      'Встановлює колір тексту вмісту нотатки.';

  @override
  String get settingsTextColorOkButton => 'ОК';

  @override
  String get settingsTextColorTileTitle => 'Колір тексту';

  @override
  String get settingsTextColorTileSubtitle =>
      'Колір для тексту вмісту нотатки.';

  @override
  String get settingsWidgetFontSizeLabel => 'Розмір шрифту віджета';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'Приклад заголовка - $size пт';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'Скасувати';

  @override
  String get settingsWidgetFontSizeApplyButton => 'Застосувати';

  @override
  String get settingsWidgetOpacityLabel => 'Прозорість фону';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return 'Прозорість $percent%';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'Скасувати';

  @override
  String get settingsWidgetOpacityApplyButton => 'Застосувати';

  @override
  String get settingsWidgetDarkModeTitle => 'Темний віджет';

  @override
  String get settingsWidgetDarkModeDesc => 'Темна колірна схема для віджета.';

  @override
  String get settingsAboutVersionTitle => 'Версія додатку';

  @override
  String get settingsAboutVersionLoading => 'Завантаження версії…';

  @override
  String get aboutSectionDeveloper => 'Зворотний зв’язок';

  @override
  String get aboutDeveloperTitle => 'Розробник';

  @override
  String get aboutContactTitle => 'Контакти';

  @override
  String get aboutWebsiteTitle => 'Веб-сайт';

  @override
  String get aboutGithubTitle => 'GitHub';

  @override
  String get aboutSectionLegal => 'Юридична інформація';

  @override
  String get aboutPrivacyPolicyTitle => 'Політика конфіденційності';

  @override
  String get aboutTermsTitle => 'Умови використання';

  @override
  String get aboutLicensesTitle => 'Ліцензії відкритого коду';

  @override
  String get aboutSectionSupport => 'Оцінити';

  @override
  String get aboutRateAppTitle => 'Оцінити застосунок';

  @override
  String get aboutLinkOpenError => 'Не вдалося відкрити посилання.';

  @override
  String get settingsFontFamilyTileTitle => 'Шрифт';

  @override
  String get settingsFontFamilyDefaultLabel => 'За замовчуванням';

  @override
  String get settingsGlobalFontSizeTileTitle => 'Розмір шрифту';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size пт — застосовується до всіх нотаток.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'Приклад тексту - $size пт';
  }

  @override
  String get settingsGlobalFontSizeCancelButton => 'Скасувати';

  @override
  String get settingsGlobalFontSizeApplyButton => 'Застосувати';

  @override
  String get settingsPreviewLinesTileTitle =>
      'Рядки попереднього перегляду нотатки';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'Показувати до $lines рядків. Якщо нотатка коротша, показується фактична кількість рядків.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'Поточне значення: $lines рядків';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'Встановлює максимальну кількість рядків для попереднього перегляду. Якщо в нотатці менше рядків, показується фактична кількість.';

  @override
  String get settingsPreviewLinesCancelButton => 'Скасувати';

  @override
  String get settingsPreviewLinesApplyButton => 'Застосувати';

  @override
  String get backupCancelButton => 'Скасувати';

  @override
  String get backupConnectButton => 'Підключити';

  @override
  String get backupDisconnectButton => 'Відключити';

  @override
  String get backupContinueButton => 'Продовжити';

  @override
  String get backupCloseButton => 'Закрити';

  @override
  String get backupShareButton => 'Поділитися';

  @override
  String get backupRestoreButton => 'Відновити';

  @override
  String get backupConfigureButton => 'Налаштувати';

  @override
  String get backupUnknownDateLabel => 'Невідомо';

  @override
  String get backupProcessingDefaultLabel => 'Обробка...';

  @override
  String get backupPermissionRequiredTitle =>
      'Потрібен дозвіл на доступ до сховища';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'Ця версія Android вимагає дозволу на доступ до сховища для резервного копіювання/відновлення. Оскільки дозвіл було остаточно відхилено, увімкніть його вручну в налаштуваннях додатку.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'Ця версія Android вимагає дозволу на доступ до сховища для резервного копіювання/відновлення. Надайте дозвіл, щоб продовжити.';

  @override
  String get backupGoToSettingsButton => 'Перейти до налаштувань';

  @override
  String get backupRetryButton => 'Повторити';

  @override
  String get backupDriveConnectingLabel =>
      'Підключення до облікового запису Google...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Підключено до облікового запису Google Drive: $email';
  }

  @override
  String get backupDriveConnectedMessage =>
      'Підключено до облікового запису Google Drive.';

  @override
  String get backupDriveConnectFailedMessage =>
      'Не вдалося підключитися до облікового запису Google, або операцію скасовано.';

  @override
  String get backupDriveDisconnectTitle => 'Відключити Google Drive';

  @override
  String get backupDriveDisconnectBody =>
      'Якщо ви відключитеся, ручне або автоматичне резервне копіювання на Drive стане неможливим. Резервні копії, вже збережені на Drive, не буде видалено — буде скасовано лише доступ із цього пристрою.';

  @override
  String get backupDriveDisconnectedMessage =>
      'З\'єднання з Google Drive видалено.';

  @override
  String get backupDriveRequiredTitle => 'Потрібен обліковий запис Google';

  @override
  String get backupDriveRequiredBody =>
      'Ця дія вимагає підключення вашого облікового запису Google. Підключити зараз?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: підключено ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: підключено';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: не підключено';

  @override
  String get backupDriveAuthenticatingLabel =>
      'Перевірка облікового запису Google...';

  @override
  String get backupDriveNotSignedInMessage =>
      'Ви не підключені до Google Drive. Спочатку увійдіть у свій обліковий запис Google.';

  @override
  String get backupDriveUploadingLabel =>
      'Завантаження резервної копії на Drive...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Завантаження на Google Drive не завершилося за 120 секунд (немає відповіді від сервера). Перевірте з\'єднання і спробуйте ще раз.';

  @override
  String get backupDriveOperationCompletedLabel => 'Завершено';

  @override
  String get backupToDriveActionLabel => 'резервне копіювання на Drive';

  @override
  String get backupToDeviceActionLabel => 'резервне копіювання';

  @override
  String get backupCreatingLabel => 'Створення резервної копії...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'Не вдалося створити резервну копію: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Завантаження на Google Drive не вдалося: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'Резервну копію успішно завантажено на Google Drive.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'Резервну копію створено: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'Резервна копія готова';

  @override
  String get backupOfferShareBody =>
      'Файл резервної копії збережено на вашому пристрої. Бажаєте поділитися ним зараз (наприклад, у хмарному сховищі, електронною поштою, на іншому пристрої)?';

  @override
  String get backupShareFileText => 'файл резервної копії layout';

  @override
  String backupShareFailedMessage(String error) {
    return 'Не вдалося почати надсилання: $error';
  }

  @override
  String get backupLargeOperationTitle => 'Велика резервна копія';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'Дані, які потрібно обробити, становлять приблизно $sizeText. $actionLabel такого розміру може зайняти деякий час залежно від вашого пристрою. Просто не закривайте додаток, поки триває процес — продовжити?';
  }

  @override
  String get backupRestoreActionLabel => 'відновлення';

  @override
  String get backupDriveListingLabel =>
      'Отримання списку резервних копій Drive...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'Не вдалося отримати список резервних копій: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'На Google Drive ще немає резервних копій.';

  @override
  String get backupDrivePickTitle => 'Виберіть резервну копію з Drive';

  @override
  String get backupDriveDownloadingLabel =>
      'Завантаження резервної копії з Drive...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Завантаження резервної копії з Drive... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel =>
      'Збереження файлу на пристрій...';

  @override
  String get backupDriveUnknownBackupFileName => 'unknown_backup.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Ваше сховище Google Drive заповнене. Звільніть місце на Drive і спробуйте ще раз.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'Не вдалося встановити з\'єднання з інтернетом. Перевірте з\'єднання і спробуйте ще раз.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'Вказаний файл резервної копії не знайдено на Drive. Можливо, його видалено.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Під час операції з Google Drive сталася неочікувана помилка: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'Завантаження не вдалося: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'Не вдалося вибрати файл: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'Немає доступу до вибраного файлу.';

  @override
  String get backupCheckingLabel => 'Перевірка резервної копії...';

  @override
  String backupReadFailedMessage(String error) {
    return 'Не вдалося прочитати файл резервної копії: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'Відновити резервну копію';

  @override
  String get backupPreviewContentsHeader => 'Вміст вибраної резервної копії:';

  @override
  String get backupPreviewNoteCountLabel => 'Кількість нотаток';

  @override
  String get backupPreviewTrashCountLabel => 'Нотатки в кошику';

  @override
  String get backupPreviewCategoryCountLabel => 'Кількість категорій';

  @override
  String get backupPreviewAttachmentLabel => 'Вкладення';

  @override
  String get backupPreviewAttachmentNoneValue => 'Немає';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count файлів ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'Створено';

  @override
  String get backupEmptyPreviewTitle => 'Схоже, ця резервна копія порожня';

  @override
  String get backupEmptyPreviewBody =>
      'У вибраному файлі не знайдено нотаток, категорій чи вкладень. Якщо ви продовжите, ваші поточні дані все одно буде видалено та замінено цією порожньою резервною копією.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '$count вкладень не знайдено в резервній копії';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'Нотатки з цими файлами буде відновлено, але без вкладень (можливо, вони були відсутні або пошкоджені під час створення резервної копії): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown і ще $remaining';
  }

  @override
  String get backupRestoreConfirmBody =>
      'Це ЗАМІНИТЬ усі ваші поточні нотатки, кошик, категорії, налаштування та вкладення даними з наведеної вище резервної копії. Ваші поточні дані буде остаточно втрачено, і цю дію неможливо скасувати.';

  @override
  String get backupRestoringLabel => 'Відновлення резервної копії...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'Резервну копію відновлено. Однак $count вкладень не знайдено в резервній копії, тому їх не вдалося відновити. Рекомендується перезапустити додаток, щоб зміни повністю набули чинності.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'Резервну копію успішно відновлено. Рекомендується перезапустити додаток, щоб зміни повністю набули чинності.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'Під час відновлення сталася помилка: $error';
  }

  @override
  String get backupScreenTitle => 'Резервне копіювання й відновлення';

  @override
  String get backupBlockedExitWarningMessage =>
      'Триває операція, зачекайте на її завершення.';

  @override
  String get backupBusyBackTooltip => 'Триває операція';

  @override
  String get backupIntroText =>
      'Ви можете створити резервну копію своїх нотаток, категорій, налаштувань і вкладень у вигляді одного .zip-файлу або відновити резервну копію, зроблену раніше.';

  @override
  String get backupDriveCardTitle => 'Резервне копіювання на Google Drive';

  @override
  String get backupDriveCardSubtitle =>
      'Створіть нову резервну копію та завантажте її безпосередньо в приватну область вашого Google Drive.';

  @override
  String get backupDriveCardButtonLabel => 'Копіювати на Drive';

  @override
  String get backupDeviceCardTitle => 'Резервне копіювання на пристрій';

  @override
  String get backupDeviceCardSubtitle =>
      'Збережіть усі свої дані у вигляді одного .zip-файлу на пристрій і за бажанням поділіться ним.';

  @override
  String get backupDeviceCardButtonLabel => 'Копіювати на пристрій';

  @override
  String get backupHistoryCardTitle => 'Історія резервного копіювання';

  @override
  String get backupHistoryCardSubtitle =>
      'Переглядайте всі резервні копії, збережені на пристрої, разом із датою та розміром; ви можете поділитися ними, відновити або видалити прямо звідси.';

  @override
  String get backupHistoryTabDevice => 'Пристрій';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'Видалити резервну копію';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'Ви впевнені, що хочете остаточно видалити файл резервної копії «$fileName»? Цю дію неможливо скасувати.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'Резервну копію видалено.';

  @override
  String get backupHistoryDriveDeleteDialogTitle =>
      'Видалити резервну копію з Drive';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'Ви впевнені, що хочете остаточно видалити резервну копію «$fileName» з Google Drive? Цю дію неможливо скасувати, і файл не буде переміщено в кошик.';
  }

  @override
  String get backupHistoryDriveDeletedMessage =>
      'Резервну копію з Drive видалено.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'Не вдалося видалити: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'На цьому пристрої ще немає збережених резервних копій.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'Скористайтеся функцією «Копіювати на пристрій», щоб створити першу резервну копію.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'Скористайтеся функцією «Резервне копіювання на Google Drive», щоб створити першу хмарну резервну копію.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Підключіть свій обліковий запис Google, щоб переглянути резервні копії на Drive.';

  @override
  String get backupHistoryConnectGoogleButton => 'Підключити через Google';

  @override
  String get backupHistoryDriveConnectedFallback => 'Підключено';

  @override
  String get backupHistoryUnknownErrorFallback => 'Сталася невідома помилка.';

  @override
  String get backupHistoryDownloadStartingLabel => 'Починається...';

  @override
  String get backupAutoBackupEnabledLabel =>
      'Автоматичне резервне копіювання: увімкнено';

  @override
  String get backupAutoBackupDisabledLabel =>
      'Автоматичне резервне копіювання: вимкнено';

  @override
  String get backupOverlayWarningMessage =>
      'Зачекайте, не закривайте додаток, поки операція не завершиться.';

  @override
  String get pdfExportUntitledNoteLabel => 'Нотатка без назви';

  @override
  String get pdfExportDefaultAttachmentName => 'Вкладення';

  @override
  String get pdfExportDefaultFileName => 'note';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'Не вдалося зробити знімок екрана (межу не знайдено)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'Не вдалося створити дані знімка екрана';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'Не вдалося обробити зображення (помилка декодування PNG)';

  @override
  String get screenshotCalcTableTotalLabel => 'Разом';

  @override
  String get gundemMenuRemoveFromAgenda => 'Прибрати з порядку денного';

  @override
  String get gundemMenuDeleteNote => 'Видалити нотатку';

  @override
  String get gundemSectionOverdue => 'Прострочено';

  @override
  String get gundemSectionToday => 'Сьогодні';

  @override
  String get gundemSectionTomorrow => 'Завтра';

  @override
  String get gundemSectionNextWeek => 'Наступного тижня';

  @override
  String get gundemSectionFurther => 'Пізніше';

  @override
  String get gundemWeekdayMonday => 'Понеділок';

  @override
  String get gundemWeekdayTuesday => 'Вівторок';

  @override
  String get gundemWeekdayWednesday => 'Середа';

  @override
  String get gundemWeekdayThursday => 'Четвер';

  @override
  String get gundemWeekdayFriday => 'П\'ятниця';

  @override
  String get gundemWeekdaySaturday => 'Субота';

  @override
  String get gundemWeekdaySunday => 'Неділя';

  @override
  String get gundemAppBarTitle => 'Порядок денний';

  @override
  String get gundemCalendarTooltip => 'Календар';

  @override
  String get gundemEmptyTitle => 'У порядку денному нічого немає';

  @override
  String get gundemEmptySubtitle =>
      'Тут з\'являтимуться нотатки з нагадуванням або призначеною датою.';

  @override
  String get gundemUntitledNote => 'Нотатка без назви';

  @override
  String get gundemRepeatHourly => 'Щогодини';

  @override
  String get gundemRepeatDaily => 'Щодня';

  @override
  String get gundemRepeatWeekly => 'Щотижня';

  @override
  String get gundemRepeatMonthly => 'Щомісяця';

  @override
  String get gundemRepeatYearly => 'Щороку';

  @override
  String get gundemPreviewCalcTableLabel => '[Список розрахунків]';

  @override
  String get gundemPreviewDrawingLabel => '[Малюнок]';

  @override
  String get gundemPreviewImageLabel => '[Зображення]';

  @override
  String get gundemMonthShortJan => 'Січ';

  @override
  String get gundemMonthShortFeb => 'Лют';

  @override
  String get gundemMonthShortMar => 'Бер';

  @override
  String get gundemMonthShortApr => 'Кві';

  @override
  String get gundemMonthShortMay => 'Тра';

  @override
  String get gundemMonthShortJun => 'Чер';

  @override
  String get gundemMonthShortJul => 'Лип';

  @override
  String get gundemMonthShortAug => 'Сер';

  @override
  String get gundemMonthShortSep => 'Вер';

  @override
  String get gundemMonthShortOct => 'Жов';

  @override
  String get gundemMonthShortNov => 'Лис';

  @override
  String get gundemMonthShortDec => 'Гру';

  @override
  String get calendarAppBarTitle => 'Календар';

  @override
  String get calendarTodayButton => 'Сьогодні';

  @override
  String get calendarLegendNoteLabel => 'Нотатка';

  @override
  String get calendarLegendReminderLabel => 'Нагадування';

  @override
  String get calendarTodayBadge => 'Сьогодні';

  @override
  String get calendarEmptyDayMessage =>
      'На цей день немає нотаток чи нагадувань.';

  @override
  String get calendarReminderHourlyLabel => 'Щогодини';

  @override
  String get calendarMonthJan => 'Січень';

  @override
  String get calendarMonthFeb => 'Лютий';

  @override
  String get calendarMonthMar => 'Березень';

  @override
  String get calendarMonthApr => 'Квітень';

  @override
  String get calendarMonthMay => 'Травень';

  @override
  String get calendarMonthJun => 'Червень';

  @override
  String get calendarMonthJul => 'Липень';

  @override
  String get calendarMonthAug => 'Серпень';

  @override
  String get calendarMonthSep => 'Вересень';

  @override
  String get calendarMonthOct => 'Жовтень';

  @override
  String get calendarMonthNov => 'Листопад';

  @override
  String get calendarMonthDec => 'Грудень';

  @override
  String get calendarWeekdayShortMon => 'Пн';

  @override
  String get calendarWeekdayShortTue => 'Вт';

  @override
  String get calendarWeekdayShortWed => 'Ср';

  @override
  String get calendarWeekdayShortThu => 'Чт';

  @override
  String get calendarWeekdayShortFri => 'Пт';

  @override
  String get calendarWeekdayShortSat => 'Сб';

  @override
  String get calendarWeekdayShortSun => 'Нд';

  @override
  String get calendarWeekdayFullMonday => 'Понеділок';

  @override
  String get calendarWeekdayFullTuesday => 'Вівторок';

  @override
  String get calendarWeekdayFullWednesday => 'Середа';

  @override
  String get calendarWeekdayFullThursday => 'Четвер';

  @override
  String get calendarWeekdayFullFriday => 'П\'ятниця';

  @override
  String get calendarWeekdayFullSaturday => 'Субота';

  @override
  String get calendarWeekdayFullSunday => 'Неділя';

  @override
  String get wrongPasswordDialogTitle => 'Неправильний пароль';

  @override
  String get wrongPasswordDialogMessage => 'Введений вами пароль неправильний.';

  @override
  String get commonOkButton => 'ОК';

  @override
  String get unlockCategoryAction => 'Розблокувати';

  @override
  String get lockCategoryAction => 'Заблокувати';

  @override
  String get categoryUnlockedMessage => 'Розблоковано';

  @override
  String get categoryLockedMessage => 'Папку заблоковано';

  @override
  String get deleteFolderMenuItemLabel => 'Видалити папку';

  @override
  String get deleteFolderDialogTitle => 'Видалити папку';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'Ви впевнені, що хочете видалити папку «$category» та всі її підпапки? Нотатки в цих папках стануть некатегоризованими.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'Ви впевнені, що хочете видалити папку «$category»? Нотатки в цій папці стануть некатегоризованими.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'Скасувати';

  @override
  String get deleteFolderDialogConfirmButton => 'Видалити';

  @override
  String get editCategoryNameColorMenuItemLabel => 'Редагувати назву / колір';

  @override
  String get addSubfolderMenuItemLabel => 'Створити підпапку';

  @override
  String get expandSubfoldersMenuItemLabel => 'Розгорнути підпапки';

  @override
  String get collapseSubfoldersMenuItemLabel => 'Згорнути підпапки';

  @override
  String saveErrorInfoMessage(String error) {
    return 'Помилка збереження: $error';
  }

  @override
  String get welcomeNoteTitle => 'Ласкаво просимо до Layout! 🚀';

  @override
  String get welcomeNoteContent => 'Додано нові функції!';

  @override
  String get noteListDateGroupToday => 'Сьогодні';

  @override
  String get noteListDateGroupYesterday => 'Учора';

  @override
  String get noteListDateGroupLast7Days => 'Останні 7 днів';

  @override
  String get noteListDateGroupLast30Days => 'Останні 30 днів';

  @override
  String get reminderRepeatNoneLabel => 'Без повторення';

  @override
  String get voiceRecorderPreparingLabel => 'Підготовка…';

  @override
  String get voiceRecorderCancelButton => 'Скасувати';

  @override
  String get voiceRecorderStopAddButton => 'Зупинити й додати';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'Дозвіл на використання мікрофона не надано.';

  @override
  String get speechToTextUnavailableMessage =>
      'Розпізнавання мовлення недоступне на цьому пристрої.';

  @override
  String get speechToTextPreparingLabel => 'Підготовка…';

  @override
  String get speechToTextListeningLabel => 'Слухаю…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'Почніть говорити…';

  @override
  String get speechToTextCancelButton => 'Скасувати';

  @override
  String get speechToTextStopAddButton => 'Зупинити й додати';

  @override
  String get textToSpeechNoContentMessage => 'Немає вмісту для читання.';

  @override
  String get textToSpeechReadErrorMessage => 'Під час читання сталася помилка.';

  @override
  String get textToSpeechUnavailableMessage =>
      'Синтез мовлення недоступний на цьому пристрої.';

  @override
  String get textToSpeechPreparingLabel => 'Підготовка…';

  @override
  String get textToSpeechPausedLabel => 'Призупинено';

  @override
  String get textToSpeechFinishedLabel => 'Читання завершено';

  @override
  String get textToSpeechReadingLabel => 'Читання…';

  @override
  String get textToSpeechCloseErrorButton => 'Закрити';

  @override
  String get textToSpeechReplayButton => 'Прочитати знову';

  @override
  String get textToSpeechCloseFinishedButton => 'Закрити';

  @override
  String get textToSpeechPauseButton => 'Пауза';

  @override
  String get textToSpeechResumeButton => 'Продовжити';

  @override
  String get textToSpeechStopButton => 'Зупинити';

  @override
  String get textToSpeechSpeedSlow => 'Повільно';

  @override
  String get textToSpeechSpeedNormal => 'Звичайно';

  @override
  String get textToSpeechSpeedFast => 'Швидко';

  @override
  String get calendarPickerCancelButton => 'Скасувати';

  @override
  String get calendarPickerConfirmButton => 'Вибрати';

  @override
  String get calendarPickerClearButton => 'Очистити';

  @override
  String get reminderPickerDialogTitle => 'Додати нагадування';

  @override
  String get reminderPickerDateTodayOption => 'Сьогодні';

  @override
  String get reminderPickerDateTomorrowOption => 'Завтра';

  @override
  String get reminderPickerDatePickOption => 'Вибрати дату';

  @override
  String get reminderRepeatHourlyLabel => 'Щогодини';

  @override
  String get reminderRepeatDailyLabel => 'Щодня';

  @override
  String get reminderRepeatWeeklyLabel => 'Щотижня';

  @override
  String get reminderRepeatMonthlyLabel => 'Щомісяця';

  @override
  String get reminderRepeatYearlyLabel => 'Щороку';

  @override
  String get reminderPickerCalendarHelpText => 'Виберіть дату нагадування';

  @override
  String get reminderPickerCancelButton => 'СКАСУВАТИ';

  @override
  String get reminderPickerSaveButton => 'ЗБЕРЕГТИ';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'Не можна вибрати час у минулому';

  @override
  String calcTableTotalLabel(String amount) {
    return 'Разом: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'Підготовка даних...';

  @override
  String get backupCreatePackagingNotesLabel =>
      'Упаковка нотаток і категорій...';

  @override
  String get backupCreateReadingAttachmentsLabel => 'Читання вкладень...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'Читання вкладень... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'Стиснення zip-файлу...';

  @override
  String get backupCreateSavingFileLabel => 'Збереження файлу...';

  @override
  String get backupRestoreValidatingLabel => 'Перевірка резервної копії...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'Резервну копію перевірено, підготовка даних...';

  @override
  String get backupRestoreWritingNotesLabel => 'Запис нотаток...';

  @override
  String get backupRestoreWritingTrashLabel => 'Запис кошика...';

  @override
  String get backupRestoreTrashWrittenLabel => 'Кошик записано';

  @override
  String get backupRestoreWritingCategoriesLabel => 'Запис категорій...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'Категорії записано';

  @override
  String get backupRestoreWritingSettingsLabel => 'Запис налаштувань...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'Налаштування записано';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'Очищення старих вкладень...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'Вкладень не знайдено, завершення...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'Відновлення вкладень... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'Завершено';

  @override
  String get backupValidationCorruptedFileMessage =>
      'Файл пошкоджено або він не є дійсним файлом резервної копії.';

  @override
  String get backupValidationMissingDataMessage =>
      'У файлі резервної копії не знайдено даних (відсутній backup_data.json).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'Не вдалося прочитати дані резервної копії (пошкоджений JSON).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'Цей файл не є резервною копією додатку layout.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'Не вдалося прочитати інформацію про версію файлу резервної копії.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'Ця резервна копія має новіший формат, який не підтримується поточною версією додатку. Оновіть додаток.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'Інформація про версію файлу резервної копії недійсна.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'Дані резервної копії мають неочікуваний формат (відсутнє поле notes).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'Дані резервної копії мають неочікуваний формат (відсутнє поле trash).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'Дані резервної копії мають неочікуваний формат (недійсний список категорій).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'Дані резервної копії мають неочікуваний формат (недійсне поле settings).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'Дані резервної копії мають неочікуваний формат (недійсний запис нотатки).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'Дані резервної копії мають неочікуваний формат (знайдено запис нотатки без ID).';

  @override
  String get backupValidationFileNotFoundMessage =>
      'Файл резервної копії не знайдено.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'Недостатньо вільного місця на пристрої. Звільніть місце і спробуйте ще раз.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'У доступі до файлу відмовлено. Перевірте дозволи додатку і спробуйте ще раз.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'Під час операції з файлом сталася помилка: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'Сталася неочікувана помилка: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'Не вдалося створити zip-архів (ZipEncoder повернув null).';

  @override
  String get calcTableMenuItemLabel => 'Список розрахунків';

  @override
  String get tableBlockMenuItemLabel => 'Таблиця';

  @override
  String get tableSizePickerTitle => 'Виберіть розмір таблиці';

  @override
  String get tableSizePickerCancel => 'Скасувати';

  @override
  String get tableSizePickerDeleteTooltip => 'Видалити таблицю';

  @override
  String get tagsMenuItemLabel => 'Теги';

  @override
  String get linkDialogUrlHint => 'https://example.com';

  @override
  String get checklistItemHint => 'Додати пункт...';

  @override
  String get toolbarHighlightTooltip => 'Виділення';

  @override
  String get toolbarListTooltip => 'Список';

  @override
  String get toolbarHideKeyboardTooltip => 'Сховати клавіатуру';

  @override
  String get autoBackupLocalSuccessMessage =>
      'Локальне резервне копіювання успішне.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'Локальне резервне копіювання не вдалося: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Резервне копіювання на Drive пропущено: обліковий запис Google не підключено, або сеанс закінчився. Відкрийте додаток і підключіться знову.';

  @override
  String get autoBackupDriveSuccessMessage =>
      'Резервне копіювання на Drive успішне.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Резервне копіювання на Drive не вдалося: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'Ще немає нотаток';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'Разом: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ Малюнок';

  @override
  String get autoBackupSettingsAppBarTitle =>
      'Налаштування автоматичного резервного копіювання';

  @override
  String get autoBackupSettingsMainSwitchTitle =>
      'Увімкнути автоматичне резервне копіювання';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'Ваші нотатки періодично й безпечно резервуються у фоновому режимі.';

  @override
  String get autoBackupSettingsTargetTitle => 'Місце резервного копіювання';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'Виберіть, де зберігатимуться резервні копії.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'Локально';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'Обидва';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Спочатку підключіть свій обліковий запис, щоб використовувати параметри Google Drive.';

  @override
  String get autoBackupSettingsConnectButton => 'Підключити';

  @override
  String get autoBackupSettingsFrequencyTitle =>
      'Частота резервного копіювання';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'Резервна копія створюється кожні $hours год.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 годин';

  @override
  String get autoBackupSettingsFrequency12h => '12 годин';

  @override
  String get autoBackupSettingsFrequency24h => '24 години (щодня)';

  @override
  String get autoBackupSettingsFrequency48h => '48 годин (2 дні)';

  @override
  String get autoBackupSettingsFrequency168h => '168 годин (щотижня)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Лише через Wi-Fi';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'Завантаження в хмару відбувається лише через Wi-Fi, щоб заощадити мобільний трафік.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'Стан системи';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'Автоматичне резервне копіювання ще не запускалося.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'Останній запуск: $date $time ($status)\nПовідомлення: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'Успішно';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'Невдало';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Не вдалося підключитися до облікового запису Google.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'Налаштування автоматичного резервного копіювання оновлено.';

  @override
  String selectionModeDeletedMessage(int count) {
    return 'Видалено нотаток: $count';
  }

  @override
  String get selectionModeArchivedMessage => 'Заархівовано';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'Виберіть категорію для $count нотаток';
  }

  @override
  String get selectionModeAddCategoryOption => 'Додати категорію';

  @override
  String get selectionModeRemoveCategoryOption => 'Прибрати категорію';

  @override
  String get calcTableItemHint => 'Пункт...';

  @override
  String get calcTableTotalRowLabel => 'Разом';

  @override
  String get textSelectionMenuShareButton => 'Поділитися';

  @override
  String get textSelectionMenuTranslateButton => 'Перекласти';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'Не вдалося почати надсилання.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'Не вдалося відкрити переклад.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'Сьогодні $time';
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
    return 'Остання резервна копія: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage => 'Резервну копію ще не створено.';

  @override
  String get backupFileNameLabel => 'Резервна копія';

  @override
  String get tableMenuInsertRowAfter => 'Додати рядок';

  @override
  String get tableMenuDeleteRow => 'Видалити рядок';

  @override
  String get tableMenuInsertColumnAfter => 'Додати стовпець';

  @override
  String get tableMenuDeleteColumn => 'Видалити стовпець';

  @override
  String get imageCropToolbarTitle => 'Обрізати';

  @override
  String get imageViewerDeleteButtonLabel => 'Видалити';

  @override
  String get imageViewerSaveToGalleryButtonLabel => 'Зберегти';

  @override
  String get imageViewerShareButtonLabel => 'Поділитися';

  @override
  String get imageViewerGalleryPermissionDeniedMessage =>
      'Доступ до галереї не надано';

  @override
  String get imageViewerSavedToGalleryMessage => 'Збережено в альбом';

  @override
  String imageViewerSaveFailedMessage(String error) {
    return 'Не вдалося зберегти: $error';
  }

  @override
  String get imageViewerSavingInProgressMessage => 'Збереження…';
}
