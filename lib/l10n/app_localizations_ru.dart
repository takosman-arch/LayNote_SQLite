// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'Жирный';

  @override
  String get toolbarItalicTooltip => 'Курсив';

  @override
  String get toolbarUnderlineTooltip => 'Подчёркнутый';

  @override
  String get toolbarStrikethroughTooltip => 'Зачёркнутый';

  @override
  String get toolbarFontSizeTooltip => 'Размер шрифта';

  @override
  String get toolbarColorTooltip => 'Цвет текста';

  @override
  String get toolbarBulletTooltip => 'Маркированный список';

  @override
  String get toolbarNumberTooltip => 'Нумерованный список';

  @override
  String get toolbarIndentTooltip => 'Отступ абзаца';

  @override
  String get toolbarLinkTooltip => 'Добавить / изменить / удалить ссылку';

  @override
  String get toolbarDividerTooltip => 'Вставить разделитель';

  @override
  String get toolbarChecklistTooltip => 'Добавить чек-лист';

  @override
  String get linkSelectTextSnackbar =>
      'Сначала выделите текст, который хотите связать';

  @override
  String get linkDialogEditTitle => 'Изменить ссылку';

  @override
  String get linkDialogAddTitle => 'Добавить ссылку';

  @override
  String get linkDialogRemoveButton => 'Удалить ссылку';

  @override
  String get linkDialogCancelButton => 'Отмена';

  @override
  String get linkDialogConfirmButton => 'Добавить';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Доступ к камере запрещён. Разрешите его в настройках, чтобы записывать видео.';

  @override
  String get cameraPermissionRequiredMessage =>
      'Для записи видео требуется доступ к камере.';

  @override
  String get openSettingsButtonLabel => 'Настройки';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'Не удалось начать сканирование: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'Не удалось распознать текст: $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'В документе не найден распознаваемый текст';

  @override
  String get scanResultSheetTitle => 'Как добавить отсканированный документ?';

  @override
  String get scanResultTextOnlyOption => 'Добавить только текст';

  @override
  String get scanResultTextAndImageOption => 'Добавить текст и изображение';

  @override
  String get scanResultCancelOption => 'Отмена';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'Доступ к микрофону запрещён. Разрешите его в настройках, чтобы записывать звук.';

  @override
  String get audioPermissionRequiredMessage =>
      'Для записи звука требуется доступ к микрофону.';

  @override
  String get voiceRecordingDefaultLabel => 'Голосовая запись';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'Список вычислений ($count строк)';
  }

  @override
  String get blockPreviewDrawingLabel => 'Рисунок';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return 'Вложений: $count (фото/документ)';
  }

  @override
  String get blockPreviewDividerLabel => 'Разделитель';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'Чек-лист ($count пунктов)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(пустой текст)';

  @override
  String get reorderBlocksSheetTitle => 'Изменить порядок блоков';

  @override
  String get reorderBlocksMoveUpTooltip => 'Переместить вверх';

  @override
  String get reorderBlocksMoveDownTooltip => 'Переместить вниз';

  @override
  String get reorderBlocksCloseTooltip => 'Закрыть';

  @override
  String get reorderBlocksDescription =>
      'Нажмите на блок, чтобы выбрать его, затем используйте стрелки вверх/вниз для перемещения.';

  @override
  String get reorderBlocksMenuItemLabel => 'Изменить порядок';

  @override
  String get txtImportPickerDialogTitle => 'Выберите TXT-файл для импорта';

  @override
  String get txtImportReadFailedMessage => 'Не удалось прочитать TXT-файл';

  @override
  String get txtImportEmptyFileMessage => 'TXT-файл пуст';

  @override
  String get txtImportSuccessMessage => 'TXT импортирован';

  @override
  String get txtImportMenuItemLabel => 'Импорт (txt)';

  @override
  String get exportMenuItemLabel => 'Экспорт';

  @override
  String get editorUndoTooltip => 'Отменить';

  @override
  String get editorRedoTooltip => 'Повторить';

  @override
  String get noteSavedMessage => 'Заметка сохранена';

  @override
  String get dateAssignPickerHelpText => 'Назначить заметку на день';

  @override
  String get dateAssignChangeOption => 'Изменить дату';

  @override
  String get dateAssignRemoveOption => 'Убрать назначение';

  @override
  String get editorSubToolbarCloseTooltip => 'Закрыть';

  @override
  String get titleFieldHint => 'Заголовок';

  @override
  String get textBlockHint => 'Напишите здесь свою заметку...';

  @override
  String get drawingBoardMenuItemLabel => 'Доска для рисования';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'Голосовой ввод доступен только для текстовых заметок';

  @override
  String get selectionModeCancelTooltip => 'Отменить выбор';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return 'Выбрано: $count';
  }

  @override
  String get selectionModeDeleteTooltip => 'Удалить';

  @override
  String get selectionModeArchiveTooltip => 'Архивировать';

  @override
  String get selectionModeFolderTooltip => 'Папка';

  @override
  String get searchFieldHint => 'Поиск заметок...';

  @override
  String get emptyTrashDialogTitle => 'Очистить корзину';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'Все удалённые заметки будут удалены безвозвратно. Вы уверены?';

  @override
  String get emptyTrashDialogCancelButton => 'Отмена';

  @override
  String get restoreAllMenuItemLabel => 'Восстановить все';

  @override
  String get sortMenuTooltip => 'Сортировка заметок';

  @override
  String get sortMenuAscendingLabel => 'Порядок: по возрастанию (А-Я)';

  @override
  String get sortMenuDescendingLabel => 'Порядок: по убыванию (Я-А)';

  @override
  String get sortMenuByTitleLabel => 'Сортировать по: заголовку';

  @override
  String get sortMenuByModifiedDateLabel => 'Сортировать по: дате изменения';

  @override
  String get sortMenuByCreatedDateLabel => 'Сортировать по: дате создания';

  @override
  String get sortMenuByFolderLabel => 'Сортировать по: папке';

  @override
  String get viewToggleGridTooltip => 'Вид сеткой';

  @override
  String get viewToggleListTooltip => 'Вид списком';

  @override
  String get drawerHeaderSubtitle => 'Ваш личный блокнот';

  @override
  String get drawerNotesSectionHeader => 'ЗАМЕТКИ';

  @override
  String get drawerAllNotesLabel => 'Заметки';

  @override
  String get drawerFavoritesLabel => 'Избранное';

  @override
  String get drawerAgendaLabel => 'Повестка';

  @override
  String get drawerRemindersLabel => 'Напоминание';

  @override
  String get drawerLockedLabel => 'Заблокировано';

  @override
  String get drawerTrashLabel => 'Корзина';

  @override
  String get drawerFoldersSectionHeader => 'ПАПКИ';

  @override
  String get drawerExpandLabel => 'Развернуть';

  @override
  String get drawerCollapseLabel => 'Свернуть';

  @override
  String get drawerAddFolderLabel => 'Добавить папку';

  @override
  String get drawerAppSectionHeader => 'ПРИЛОЖЕНИЕ';

  @override
  String get drawerCalendarLabel => 'Календарь';

  @override
  String get drawerSettingsLabel => 'Настройки';

  @override
  String get drawerBackupRestoreLabel =>
      'Резервное копирование и восстановление';

  @override
  String get drawerUpgradeToProLabel => 'Перейти на Pro';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'Поддержать разработку';

  @override
  String get drawerFeedbackLabel => 'Обратная связь';

  @override
  String get drawerAboutLabel => 'О приложении';

  @override
  String get noNotesFoundMessage => 'Заметки не найдены.';

  @override
  String get trashRestoreButtonLabel => 'Восстановить';

  @override
  String get trashPermanentDeleteButtonLabel => 'Удалить навсегда';

  @override
  String get tagRenamedInfoMessage => 'Тег переименован';

  @override
  String get tagDeletedInfoMessage => 'Тег удалён';

  @override
  String get tagOptionsRenameLabel => 'Переименовать';

  @override
  String get tagOptionsDeleteLabel => 'Удалить';

  @override
  String get renameTagDialogTitle => 'Переименовать тег';

  @override
  String get renameTagDialogHint => 'Новое название тега';

  @override
  String get renameTagDialogCancelButton => 'Отмена';

  @override
  String get renameTagDialogSaveButton => 'Сохранить';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return 'Тег «$tag» будет удалён из $affectedCount заметок. Продолжить?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'Удалить тег «$tag»?';
  }

  @override
  String get deleteTagDialogTitle => 'Удалить тег';

  @override
  String get deleteTagDialogCancelButton => 'Отмена';

  @override
  String get deleteTagDialogConfirmButton => 'Удалить';

  @override
  String get tagsSheetTitle => 'Теги';

  @override
  String get tagsSheetEmptyMessage => 'На этой заметке пока нет тегов.';

  @override
  String get tagsSheetInputHint => 'Введите новый тег...';

  @override
  String get tagsSheetSuggestionsLabel => 'Существующие теги';

  @override
  String get noteDeletedInfoMessage => 'Заметка удалена';

  @override
  String get noteDeletedUndoActionLabel => 'Отменить';

  @override
  String get reminderSetInfoMessage => 'Напоминание установлено';

  @override
  String get reminderRemovedInfoMessage => 'Напоминание удалено';

  @override
  String get noteDuplicatedInfoMessage => 'Копия создана';

  @override
  String get speechTextAppendedInfoMessage => 'Текст добавлен в заметку';

  @override
  String get pdfPreparingInfoMessage => 'Подготовка PDF…';

  @override
  String get pdfSavedInfoMessage => 'PDF сохранён';

  @override
  String get jpgPreparingInfoMessage => 'Подготовка JPG…';

  @override
  String get jpgSavedInfoMessage => 'JPG сохранён';

  @override
  String get jpgFailedInfoMessage => 'Не удалось создать JPG';

  @override
  String get txtPreparingInfoMessage => 'Подготовка TXT…';

  @override
  String get txtSavedInfoMessage => 'TXT сохранён';

  @override
  String get txtFailedInfoMessage => 'Не удалось создать TXT';

  @override
  String get exportOpenActionLabel => 'Открыть';

  @override
  String get wrongPasswordInfoMessage => 'Неверный пароль.';

  @override
  String get noteArchivedInfoMessage => 'Заметка архивирована';

  @override
  String get noteUnarchivedInfoMessage => 'Убрано из архива';

  @override
  String get noteUnlockedInfoMessage => 'Разблокировано';

  @override
  String get noteLockedInfoMessage => 'Заметка заблокирована';

  @override
  String get notificationUnpinnedInfoMessage => 'Откреплено';

  @override
  String get emptyNotePinBlockedInfoMessage =>
      'Пустую заметку нельзя закрепить.';

  @override
  String get notificationPinnedInfoMessage =>
      'Закреплено на панели уведомлений';

  @override
  String get noContentToReadInfoMessage => 'Нет содержимого для чтения';

  @override
  String get backPressExitInfoMessage => 'Нажмите «Назад» ещё раз для выхода';

  @override
  String get reminderChannelName => 'Напоминания о заметках';

  @override
  String get reminderChannelDescription =>
      'Напоминания о заметках в приложении Layout';

  @override
  String get pinnedChannelName => 'Закреплённые заметки';

  @override
  String get pinnedChannelDescription =>
      'Заметки Layout, закреплённые на панели уведомлений';

  @override
  String get notificationUnpinActionLabel => 'Убрать';

  @override
  String get reminderDefaultTitle => 'Напоминание';

  @override
  String get reminderChecklistBodyFallback =>
      'Не забудьте проверить свой чек-лист';

  @override
  String get reminderTextBodyFallback => 'Не забудьте проверить свою заметку';

  @override
  String get pdfSaveDialogTitle => 'Сохранить как PDF';

  @override
  String get jpgSaveDialogTitle => 'Сохранить как JPG';

  @override
  String get txtSaveDialogTitle => 'Сохранить как TXT';

  @override
  String get textSizeSheetTitle => 'Размер текста';

  @override
  String get textSizeSamplePreview => 'Пример текста';

  @override
  String get textSizeCancelButton => 'Отмена';

  @override
  String get textSizeApplyButton => 'Применить';

  @override
  String get createPasswordDialogTitle => 'Создать пароль';

  @override
  String get createPasswordNewPasswordHint => 'Новый пароль';

  @override
  String get createPasswordConfirmHint => 'Повторите пароль';

  @override
  String get createPasswordHintQuestionDescription =>
      'Задайте контрольный вопрос на случай, если забудете пароль (необязательно).';

  @override
  String get createPasswordHintQuestionHint => 'Выберите контрольный вопрос';

  @override
  String get createPasswordHintAnswerHint => 'Ваш ответ';

  @override
  String get createPasswordCancelButton => 'Отмена';

  @override
  String get createPasswordSaveButton => 'Сохранить';

  @override
  String get passwordMismatchMessage => 'Пароли не совпадают!';

  @override
  String get passwordRequiredDialogTitle => 'Требуется пароль';

  @override
  String get passwordRequiredHint => 'Введите пароль';

  @override
  String get forgotPasswordButtonLabel => 'Забыли пароль';

  @override
  String get passwordRequiredCancelButton => 'Отмена';

  @override
  String get passwordRequiredConfirmButton => 'Подтвердить';

  @override
  String get securityQuestionDialogTitle => 'Контрольный вопрос';

  @override
  String get securityQuestionAnswerHint => 'Ваш ответ';

  @override
  String get securityQuestionCancelButton => 'Отмена';

  @override
  String get securityQuestionConfirmButton => 'Подтвердить';

  @override
  String get securityQuestionWrongAnswerMessage =>
      'Неверный ответ. Попробуйте снова.';

  @override
  String get revealedPasswordDialogTitle => 'Ваш пароль';

  @override
  String get revealedPasswordLabel => 'Пароль вашей заметки:';

  @override
  String get revealedPasswordOkButton => 'ОК';

  @override
  String get securityQuestionPetName => 'Как звали вашего первого питомца?';

  @override
  String get securityQuestionFavoriteTeacher =>
      'Как зовут вашего любимого учителя?';

  @override
  String get securityQuestionBirthCity => 'В каком городе вы родились?';

  @override
  String get securityQuestionFavoriteFood => 'Какая ваша любимая еда?';

  @override
  String get securityQuestionMotherMaidenName =>
      'Какая девичья фамилия вашей матери?';

  @override
  String get securityQuestionFirstSchool =>
      'Как называется первая школа, в которой вы учились?';

  @override
  String get securityQuestionFavoriteColor => 'Какой ваш любимый цвет?';

  @override
  String get editFolderDialogTitle => 'Изменить папку';

  @override
  String get newSubfolderDialogTitle => 'Новая подпапка';

  @override
  String get addFolderDialogTitle => 'Добавить папку';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'Будет создана внутри «$parentCategory»';
  }

  @override
  String get subfolderNameFieldLabel => 'Название подпапки';

  @override
  String get folderNameFieldLabel => 'Название папки';

  @override
  String get folderColorLabel => 'Цвет';

  @override
  String get folderDialogCancelButton => 'Отмена';

  @override
  String get folderDialogSaveButton => 'Сохранить';

  @override
  String get folderDialogAddButton => 'Добавить';

  @override
  String get selectFolderSheetTitle => 'Выберите папку';

  @override
  String get selectFolderAddOptionLabel => 'Добавить папку';

  @override
  String get removeCurrentFolderLabel => 'Убрать текущую папку';

  @override
  String get noteDetailsDialogTitle => 'Сведения';

  @override
  String get noteDetailsCreatedLabel => 'Создано';

  @override
  String get noteDetailsModifiedLabel => 'Последнее изменение';

  @override
  String get noteDetailsCharCountLabel => 'Количество символов';

  @override
  String noteDetailsCharCountValue(int count) {
    return 'Символов: $count';
  }

  @override
  String get noteDetailsWordCountLabel => 'Количество слов';

  @override
  String noteDetailsWordCountValue(int count) {
    return 'Слов: $count';
  }

  @override
  String get noteDetailsOkButton => 'ОК';

  @override
  String get noteDetailsUnknownDateLabel => 'Неизвестно';

  @override
  String get addAttachmentSheetTitle => 'Добавить';

  @override
  String get addAttachmentImageOption => 'Добавить изображение';

  @override
  String get addAttachmentCameraOption => 'Камера';

  @override
  String get addAttachmentFileOption => 'Добавить файл';

  @override
  String get addAttachmentVoiceOption => 'Голосовая запись';

  @override
  String get addAttachmentVideoOption => 'Записать видео';

  @override
  String get addAttachmentScanOption => 'Сканировать документ';

  @override
  String get noteActionsSheetTitle => 'Выберите действие';

  @override
  String get noteActionReminderLabel => 'Напоминание';

  @override
  String get noteActionEditReminderLabel => 'Изменить напоминание';

  @override
  String get noteActionSpeechToTextLabel => 'Речь в текст';

  @override
  String get noteActionArchiveLabel => 'Архивировать';

  @override
  String get noteActionUnarchiveLabel => 'Убрать из архива';

  @override
  String get noteActionLockLabel => 'Заблокировать';

  @override
  String get noteActionUnlockLabel => 'Разблокировать';

  @override
  String get noteActionFavoriteLabel => 'В избранное';

  @override
  String get noteActionUnfavoriteLabel => 'Убрать из избранного';

  @override
  String get noteActionClassifyLabel => 'Выбрать папку';

  @override
  String get noteActionDeleteLabel => 'Удалить';

  @override
  String get noteActionPinToNotificationLabel =>
      'Закрепить на панели уведомлений';

  @override
  String get noteActionUnpinFromNotificationLabel => 'Убрать закрепление';

  @override
  String get noteActionShareLabel => 'Поделиться';

  @override
  String get noteActionDuplicateLabel => 'Создать копию';

  @override
  String get noteActionCopyContentLabel => 'Копировать содержимое';

  @override
  String get noteActionTtsLabel => 'Прочитать вслух';

  @override
  String get noteActionTextSizeLabel => 'Размер текста';

  @override
  String get noteActionDetailsLabel => 'Сведения';

  @override
  String get noteActionDiscardChangesLabel => 'Отменить изменения';

  @override
  String get noteActionSelectLabel => 'Выбрать';

  @override
  String get reminderEditOptionLabel => 'Изменить напоминание';

  @override
  String get reminderRemoveOptionLabel => 'Удалить напоминание';

  @override
  String get discardChangesDialogTitle => 'Отменить изменения';

  @override
  String get discardChangesDialogMessage =>
      'Несохранённые изменения в этой заметке будут потеряны. Вы уверены, что хотите отменить их?';

  @override
  String get discardChangesCancelButton => 'Отмена';

  @override
  String get discardChangesConfirmButton => 'Отменить';

  @override
  String get pinnedNotificationDefaultTitle => 'Заметка';

  @override
  String get pdfFailedInfoMessage => 'Не удалось создать PDF';

  @override
  String get drawingScreenTitle => 'Рисунок';

  @override
  String get drawingMinimizeTooltip => 'Свернуть';

  @override
  String get drawingEmptyExportWarningMessage => 'Сначала нарисуйте что-нибудь';

  @override
  String get drawingEraserPartialModeLabel => 'Частично';

  @override
  String get drawingEraserFullModeLabel => 'Полностью';

  @override
  String get drawingClearTooltip => 'Очистить';

  @override
  String get drawingZoomOutTooltip => 'Уменьшить масштаб';

  @override
  String get drawingZoomInTooltip => 'Увеличить масштаб';

  @override
  String get drawingDeleteTooltip => 'Удалить';

  @override
  String get drawingEmptyPreviewHint => 'Нажмите, чтобы рисовать';

  @override
  String get settingsPageTitle => 'Настройки';

  @override
  String get settingsSectionGeneral => 'Общие';

  @override
  String get settingsSectionSecurity => 'Безопасность';

  @override
  String get settingsSectionTheme => 'Тема';

  @override
  String get settingsSectionPersonalization => 'Персонализация';

  @override
  String get settingsSectionWidget => 'Виджет';

  @override
  String get settingsSectionAbout => 'О приложении';

  @override
  String get settingsHintQuestionPet => 'Как звали вашего первого питомца?';

  @override
  String get settingsHintQuestionTeacher =>
      'Как зовут вашего любимого учителя?';

  @override
  String get settingsHintQuestionBirthCity => 'В каком городе вы родились?';

  @override
  String get settingsHintQuestionFavoriteFood => 'Какая ваша любимая еда?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'Какая девичья фамилия вашей матери?';

  @override
  String get settingsHintQuestionFirstSchool =>
      'В какой школе вы учились первой?';

  @override
  String get settingsHintQuestionFavoriteColor => 'Какой ваш любимый цвет?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'Контрольный вопрос';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'Если вы забудете пароль, вы сможете восстановить его, правильно ответив на этот вопрос.';

  @override
  String get settingsSecurityQuestionDropdownHint =>
      'Выберите контрольный вопрос';

  @override
  String get settingsSecurityQuestionAnswerHint => 'Ваш ответ';

  @override
  String get settingsSecurityQuestionCancelButton => 'Отмена';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'Вопрос и ответ не могут быть пустыми!';

  @override
  String get settingsSecurityQuestionSaveButton => 'Сохранить';

  @override
  String get settingsCreatePasswordTitle => 'Создать пароль';

  @override
  String get settingsPasswordRequiredTitle => 'Требуется пароль';

  @override
  String get settingsPasswordEnterHint => 'Введите пароль';

  @override
  String get settingsForgotPasswordButton => 'Забыли пароль';

  @override
  String get settingsNewPasswordHint => 'Новый пароль';

  @override
  String get settingsConfirmPasswordHint => 'Повторите пароль';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'Задайте контрольный вопрос на случай, если забудете пароль (необязательно).';

  @override
  String get settingsPasswordDialogCancelButton => 'Отмена';

  @override
  String get settingsPasswordMismatchWarning => 'Пароли не совпадают!';

  @override
  String get settingsWrongPasswordWarning => 'Неверный пароль!';

  @override
  String get settingsPasswordSaveButton => 'Сохранить';

  @override
  String get settingsPasswordRemoveButton => 'Удалить';

  @override
  String get settingsNotePasswordTitle => 'Пароль заметки';

  @override
  String get settingsPasswordSetSubtitle => 'Пароль установлен ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'Пароль не установлен';

  @override
  String get settingsSecurityQuestionTileTitle => 'Контрольный вопрос';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'Установлен ✓ — используется, если вы забудете пароль';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'Не установлен — вы не сможете восстановить пароль в случае потери';

  @override
  String get settingsThemeDialogTitle => 'Выберите тему';

  @override
  String get settingsThemeSystemDefault => 'Системная по умолчанию';

  @override
  String get settingsThemeLightOption => 'Светлая тема';

  @override
  String get settingsThemeDarkOption => 'Тёмная тема';

  @override
  String get settingsLanguageDialogTitle => 'Выберите язык';

  @override
  String get settingsLanguageSystemOption => 'Системный';

  @override
  String get settingsAccentColorDialogTitle => 'Выберите акцентный цвет';

  @override
  String get settingsThemeChangeTileTitle => 'Изменить тему';

  @override
  String get settingsThemeLightLabel => 'Светлая';

  @override
  String get settingsThemeDarkLabel => 'Тёмная';

  @override
  String get settingsThemeSystemLabel => 'Системная';

  @override
  String get settingsLanguageTileTitle => 'Язык';

  @override
  String get settingsAccentColorTileTitle => 'Акцентный цвет';

  @override
  String get settingsAccentColorTileSubtitle =>
      'Цвет, используемый на панели приложения, кнопках и переключателях';

  @override
  String get settingsColorfulNotesTitle => 'Разные цвета заметок';

  @override
  String get settingsColorfulNotesSubtitle =>
      'Каждая карточка заметки получает свой цветовой оттенок.';

  @override
  String get settingsTextColorSheetTitle => 'Цвет текста';

  @override
  String get settingsTextColorSheetDesc =>
      'Задаёт цвет текста содержимого заметки.';

  @override
  String get settingsTextColorOkButton => 'ОК';

  @override
  String get settingsTextColorTileTitle => 'Цвет текста';

  @override
  String get settingsTextColorTileSubtitle =>
      'Цвет текста содержимого заметки.';

  @override
  String get settingsWidgetFontSizeLabel => 'Размер шрифта виджета';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'Пример заголовка — $size пт';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'Отмена';

  @override
  String get settingsWidgetFontSizeApplyButton => 'Применить';

  @override
  String get settingsWidgetOpacityLabel => 'Прозрачность фона';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return 'Прозрачность $percent%';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'Отмена';

  @override
  String get settingsWidgetOpacityApplyButton => 'Применить';

  @override
  String get settingsWidgetDarkModeTitle => 'Тёмный виджет';

  @override
  String get settingsWidgetDarkModeDesc => 'Тёмная цветовая схема для виджета.';

  @override
  String get settingsAboutVersionTitle => 'Версия приложения';

  @override
  String get settingsAboutVersionLoading => 'Загрузка версии…';

  @override
  String get aboutSectionDeveloper => 'Обратная связь';

  @override
  String get aboutDeveloperTitle => 'Разработчик';

  @override
  String get aboutContactTitle => 'Контакты';

  @override
  String get aboutWebsiteTitle => 'Веб-сайт';

  @override
  String get aboutGithubTitle => 'GitHub';

  @override
  String get aboutSectionLegal => 'Правовая информация';

  @override
  String get aboutPrivacyPolicyTitle => 'Политика конфиденциальности';

  @override
  String get aboutTermsTitle => 'Условия использования';

  @override
  String get aboutLicensesTitle => 'Лицензии с открытым исходным кодом';

  @override
  String get aboutSectionSupport => 'Оценить';

  @override
  String get aboutRateAppTitle => 'Оценить приложение';

  @override
  String get aboutLinkOpenError => 'Не удалось открыть ссылку.';

  @override
  String get settingsFontFamilyTileTitle => 'Шрифт';

  @override
  String get settingsFontFamilyDefaultLabel => 'По умолчанию';

  @override
  String get settingsGlobalFontSizeTileTitle => 'Размер шрифта';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size пт — применяется ко всем заметкам.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'Пример текста — $size пт';
  }

  @override
  String get settingsGlobalFontSizeCancelButton => 'Отмена';

  @override
  String get settingsGlobalFontSizeApplyButton => 'Применить';

  @override
  String get settingsPreviewLinesTileTitle => 'Строки предпросмотра заметки';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'Показывать до $lines строк. Если заметка короче, отображается фактическое число строк.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'Текущее значение: $lines строк';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'Задаёт максимальное количество строк для предпросмотра. Если в заметке строк меньше, отображается фактическое число.';

  @override
  String get settingsPreviewLinesCancelButton => 'Отмена';

  @override
  String get settingsPreviewLinesApplyButton => 'Применить';

  @override
  String get backupCancelButton => 'Отмена';

  @override
  String get backupConnectButton => 'Подключить';

  @override
  String get backupDisconnectButton => 'Отключить';

  @override
  String get backupContinueButton => 'Продолжить';

  @override
  String get backupCloseButton => 'Закрыть';

  @override
  String get backupShareButton => 'Поделиться';

  @override
  String get backupRestoreButton => 'Восстановить';

  @override
  String get backupConfigureButton => 'Настроить';

  @override
  String get backupUnknownDateLabel => 'Неизвестно';

  @override
  String get backupProcessingDefaultLabel => 'Обработка...';

  @override
  String get backupPermissionRequiredTitle => 'Требуется доступ к хранилищу';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'Эта версия Android требует доступ к хранилищу для резервного копирования/восстановления. Поскольку доступ был отклонён навсегда, включите его вручную в настройках приложения.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'Эта версия Android требует доступ к хранилищу для резервного копирования/восстановления. Пожалуйста, предоставьте доступ, чтобы продолжить.';

  @override
  String get backupGoToSettingsButton => 'Перейти в настройки';

  @override
  String get backupRetryButton => 'Повторить';

  @override
  String get backupDriveConnectingLabel => 'Подключение к аккаунту Google...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Подключено к аккаунту Google Drive: $email';
  }

  @override
  String get backupDriveConnectedMessage =>
      'Подключено к аккаунту Google Drive.';

  @override
  String get backupDriveConnectFailedMessage =>
      'Не удалось подключиться к аккаунту Google, или операция была отменена.';

  @override
  String get backupDriveDisconnectTitle => 'Отключить Google Drive';

  @override
  String get backupDriveDisconnectBody =>
      'Если вы отключитесь, ручное или автоматическое резервное копирование на Drive станет недоступно. Уже сохранённые на Drive резервные копии не будут удалены — будет удалён только доступ с этого устройства.';

  @override
  String get backupDriveDisconnectedMessage =>
      'Подключение к Google Drive удалено.';

  @override
  String get backupDriveRequiredTitle => 'Требуется аккаунт Google';

  @override
  String get backupDriveRequiredBody =>
      'Для этого действия требуется подключить ваш аккаунт Google. Подключить сейчас?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: подключено ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: подключено';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: не подключено';

  @override
  String get backupDriveAuthenticatingLabel => 'Проверка аккаунта Google...';

  @override
  String get backupDriveNotSignedInMessage =>
      'Вы не подключены к Google Drive. Пожалуйста, сначала войдите в свой аккаунт Google.';

  @override
  String get backupDriveUploadingLabel =>
      'Загрузка резервной копии на Drive...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Загрузка в Google Drive не завершилась в течение 120 секунд (нет ответа от сервера). Проверьте подключение и попробуйте снова.';

  @override
  String get backupDriveOperationCompletedLabel => 'Завершено';

  @override
  String get backupToDriveActionLabel => 'резервное копирование на Drive';

  @override
  String get backupToDeviceActionLabel => 'резервное копирование';

  @override
  String get backupCreatingLabel => 'Создание резервной копии...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'Не удалось создать резервную копию: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Не удалось загрузить в Google Drive: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'Резервная копия успешно загружена в Google Drive.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'Резервная копия создана: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'Резервная копия готова';

  @override
  String get backupOfferShareBody =>
      'Файл резервной копии сохранён на вашем устройстве. Поделиться им сейчас (например, через облачное хранилище, почту, другое устройство)?';

  @override
  String get backupShareFileText => 'файл резервной копии layout';

  @override
  String backupShareFailedMessage(String error) {
    return 'Не удалось начать отправку: $error';
  }

  @override
  String get backupLargeOperationTitle => 'Большая резервная копия';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'Объём обрабатываемых данных составляет примерно $sizeText. $actionLabel такого размера может занять некоторое время в зависимости от вашего устройства. Просто не покидайте приложение, пока идёт процесс — продолжить?';
  }

  @override
  String get backupRestoreActionLabel => 'восстановление';

  @override
  String get backupDriveListingLabel =>
      'Получение списка резервных копий на Drive...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'Не удалось получить список резервных копий: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'На Google Drive пока нет резервных копий.';

  @override
  String get backupDrivePickTitle => 'Выберите резервную копию из Drive';

  @override
  String get backupDriveDownloadingLabel =>
      'Загрузка резервной копии с Drive...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Загрузка резервной копии с Drive... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel =>
      'Сохранение файла на устройство...';

  @override
  String get backupDriveUnknownBackupFileName => 'unknown_backup.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Хранилище Google Drive заполнено. Освободите место на Drive и попробуйте снова.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'Не удалось установить подключение к интернету. Проверьте подключение и попробуйте снова.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'Указанный файл резервной копии не найден на Drive. Возможно, он был удалён.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Во время операции с Google Drive произошла непредвиденная ошибка: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'Не удалось загрузить: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'Не удалось выбрать файл: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'Не удалось получить доступ к выбранному файлу.';

  @override
  String get backupCheckingLabel => 'Проверка резервной копии...';

  @override
  String backupReadFailedMessage(String error) {
    return 'Не удалось прочитать файл резервной копии: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'Восстановить резервную копию';

  @override
  String get backupPreviewContentsHeader =>
      'Содержимое выбранной резервной копии:';

  @override
  String get backupPreviewNoteCountLabel => 'Количество заметок';

  @override
  String get backupPreviewTrashCountLabel => 'Заметок в корзине';

  @override
  String get backupPreviewCategoryCountLabel => 'Количество категорий';

  @override
  String get backupPreviewAttachmentLabel => 'Вложения';

  @override
  String get backupPreviewAttachmentNoneValue => 'Нет';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return 'Файлов: $count ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'Дата создания';

  @override
  String get backupEmptyPreviewTitle => 'Эта резервная копия выглядит пустой';

  @override
  String get backupEmptyPreviewBody =>
      'В выбранном файле не найдено заметок, категорий или вложений. Если вы продолжите, текущие данные всё равно будут удалены и заменены этой пустой резервной копией.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '$count вложений не найдено в резервной копии';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'Заметки с этими файлами будут восстановлены, но без вложений (возможно, они отсутствовали или были повреждены на момент создания резервной копии): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown и ещё $remaining';
  }

  @override
  String get backupRestoreConfirmBody =>
      'Это ЗАМЕНИТ все ваши текущие заметки, корзину, категории, настройки и вложения данными из указанной выше резервной копии. Ваши текущие данные будут безвозвратно утеряны, и это действие нельзя отменить.';

  @override
  String get backupRestoringLabel => 'Восстановление резервной копии...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'Резервная копия восстановлена. Однако $count вложений не найдено в резервной копии и не может быть восстановлено. Рекомендуется перезапустить приложение, чтобы изменения вступили в силу полностью.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'Резервная копия успешно восстановлена. Рекомендуется перезапустить приложение, чтобы изменения вступили в силу полностью.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'Произошла ошибка при восстановлении: $error';
  }

  @override
  String get backupScreenTitle => 'Резервное копирование и восстановление';

  @override
  String get backupBlockedExitWarningMessage =>
      'Выполняется операция, пожалуйста, дождитесь её завершения.';

  @override
  String get backupBusyBackTooltip => 'Выполняется операция';

  @override
  String get backupIntroText =>
      'Вы можете сохранить резервную копию своих заметок, категорий, настроек и вложений в виде единого файла .zip или восстановить ранее созданную резервную копию.';

  @override
  String get backupDriveCardTitle => 'Резервное копирование в Google Drive';

  @override
  String get backupDriveCardSubtitle =>
      'Создайте новую резервную копию и загрузите её напрямую в приватную область вашего Google Drive.';

  @override
  String get backupDriveCardButtonLabel => 'Копировать на Drive';

  @override
  String get backupDeviceCardTitle => 'Резервное копирование на устройство';

  @override
  String get backupDeviceCardSubtitle =>
      'Сохраните все свои данные в виде единого файла .zip на устройство и при желании поделитесь им.';

  @override
  String get backupDeviceCardButtonLabel => 'Копировать на устройство';

  @override
  String get backupHistoryCardTitle => 'История резервных копий';

  @override
  String get backupHistoryCardSubtitle =>
      'Просмотрите все резервные копии, хранящиеся на вашем устройстве, с датой и размером; отсюда же можно поделиться, восстановить или удалить их.';

  @override
  String get backupHistoryTabDevice => 'Устройство';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'Удалить резервную копию';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'Вы уверены, что хотите безвозвратно удалить файл резервной копии «$fileName»? Это действие нельзя отменить.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'Резервная копия удалена.';

  @override
  String get backupHistoryDriveDeleteDialogTitle =>
      'Удалить резервную копию с Drive';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'Вы уверены, что хотите безвозвратно удалить резервную копию «$fileName» с Google Drive? Это действие нельзя отменить, и файл не будет перемещён в корзину.';
  }

  @override
  String get backupHistoryDriveDeletedMessage =>
      'Резервная копия на Drive удалена.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'Не удалось удалить: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'На этом устройстве пока нет сохранённых резервных копий.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'Используйте «Резервное копирование на устройство», чтобы создать первую резервную копию.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'Используйте «Резервное копирование в Google Drive», чтобы создать первую облачную резервную копию.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Подключите аккаунт Google, чтобы увидеть резервные копии на Drive.';

  @override
  String get backupHistoryConnectGoogleButton => 'Подключить через Google';

  @override
  String get backupHistoryDriveConnectedFallback => 'Подключено';

  @override
  String get backupHistoryUnknownErrorFallback =>
      'Произошла неизвестная ошибка.';

  @override
  String get backupHistoryDownloadStartingLabel => 'Запуск...';

  @override
  String get backupAutoBackupEnabledLabel =>
      'Автоматическое резервное копирование: вкл.';

  @override
  String get backupAutoBackupDisabledLabel =>
      'Автоматическое резервное копирование: выкл.';

  @override
  String get backupOverlayWarningMessage =>
      'Пожалуйста, подождите, не покидайте приложение до завершения операции.';

  @override
  String get pdfExportUntitledNoteLabel => 'Заметка без названия';

  @override
  String get pdfExportDefaultAttachmentName => 'Вложение';

  @override
  String get pdfExportDefaultFileName => 'заметка';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'Не удалось сделать снимок экрана (граница не найдена)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'Не удалось сформировать данные снимка экрана';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'Не удалось обработать изображение (ошибка декодирования PNG)';

  @override
  String get screenshotCalcTableTotalLabel => 'Итого';

  @override
  String get gundemMenuRemoveFromAgenda => 'Удалить из повестки';

  @override
  String get gundemMenuDeleteNote => 'Удалить заметку';

  @override
  String get gundemSectionOverdue => 'Просрочено';

  @override
  String get gundemSectionToday => 'Сегодня';

  @override
  String get gundemSectionTomorrow => 'Завтра';

  @override
  String get gundemSectionNextWeek => 'На следующей неделе';

  @override
  String get gundemSectionFurther => 'Позже';

  @override
  String get gundemWeekdayMonday => 'Понедельник';

  @override
  String get gundemWeekdayTuesday => 'Вторник';

  @override
  String get gundemWeekdayWednesday => 'Среда';

  @override
  String get gundemWeekdayThursday => 'Четверг';

  @override
  String get gundemWeekdayFriday => 'Пятница';

  @override
  String get gundemWeekdaySaturday => 'Суббота';

  @override
  String get gundemWeekdaySunday => 'Воскресенье';

  @override
  String get gundemAppBarTitle => 'Повестка';

  @override
  String get gundemCalendarTooltip => 'Календарь';

  @override
  String get gundemEmptyTitle => 'В повестке пока ничего нет';

  @override
  String get gundemEmptySubtitle =>
      'Здесь будут отображаться заметки с напоминанием или назначенной датой.';

  @override
  String get gundemUntitledNote => 'Заметка без названия';

  @override
  String get gundemRepeatHourly => 'Ежечасно';

  @override
  String get gundemRepeatDaily => 'Ежедневно';

  @override
  String get gundemRepeatWeekly => 'Еженедельно';

  @override
  String get gundemRepeatMonthly => 'Ежемесячно';

  @override
  String get gundemRepeatYearly => 'Ежегодно';

  @override
  String get gundemPreviewCalcTableLabel => '[Список вычислений]';

  @override
  String get gundemPreviewDrawingLabel => '[Рисунок]';

  @override
  String get gundemPreviewImageLabel => '[Изображение]';

  @override
  String get gundemMonthShortJan => 'Янв';

  @override
  String get gundemMonthShortFeb => 'Фев';

  @override
  String get gundemMonthShortMar => 'Мар';

  @override
  String get gundemMonthShortApr => 'Апр';

  @override
  String get gundemMonthShortMay => 'Май';

  @override
  String get gundemMonthShortJun => 'Июн';

  @override
  String get gundemMonthShortJul => 'Июл';

  @override
  String get gundemMonthShortAug => 'Авг';

  @override
  String get gundemMonthShortSep => 'Сен';

  @override
  String get gundemMonthShortOct => 'Окт';

  @override
  String get gundemMonthShortNov => 'Ноя';

  @override
  String get gundemMonthShortDec => 'Дек';

  @override
  String get calendarAppBarTitle => 'Календарь';

  @override
  String get calendarTodayButton => 'Сегодня';

  @override
  String get calendarLegendNoteLabel => 'Заметка';

  @override
  String get calendarLegendReminderLabel => 'Напоминание';

  @override
  String get calendarTodayBadge => 'Сегодня';

  @override
  String get calendarEmptyDayMessage =>
      'На этот день нет заметок или напоминаний.';

  @override
  String get calendarReminderHourlyLabel => 'Ежечасно';

  @override
  String get calendarMonthJan => 'Январь';

  @override
  String get calendarMonthFeb => 'Февраль';

  @override
  String get calendarMonthMar => 'Март';

  @override
  String get calendarMonthApr => 'Апрель';

  @override
  String get calendarMonthMay => 'Май';

  @override
  String get calendarMonthJun => 'Июнь';

  @override
  String get calendarMonthJul => 'Июль';

  @override
  String get calendarMonthAug => 'Август';

  @override
  String get calendarMonthSep => 'Сентябрь';

  @override
  String get calendarMonthOct => 'Октябрь';

  @override
  String get calendarMonthNov => 'Ноябрь';

  @override
  String get calendarMonthDec => 'Декабрь';

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
  String get calendarWeekdayShortSun => 'Вс';

  @override
  String get calendarWeekdayFullMonday => 'Понедельник';

  @override
  String get calendarWeekdayFullTuesday => 'Вторник';

  @override
  String get calendarWeekdayFullWednesday => 'Среда';

  @override
  String get calendarWeekdayFullThursday => 'Четверг';

  @override
  String get calendarWeekdayFullFriday => 'Пятница';

  @override
  String get calendarWeekdayFullSaturday => 'Суббота';

  @override
  String get calendarWeekdayFullSunday => 'Воскресенье';

  @override
  String get wrongPasswordDialogTitle => 'Неверный пароль';

  @override
  String get wrongPasswordDialogMessage => 'Введённый пароль неверен.';

  @override
  String get commonOkButton => 'ОК';

  @override
  String get unlockCategoryAction => 'Разблокировать';

  @override
  String get lockCategoryAction => 'Заблокировать';

  @override
  String get categoryUnlockedMessage => 'Разблокировано';

  @override
  String get categoryLockedMessage => 'Папка заблокирована';

  @override
  String get deleteFolderMenuItemLabel => 'Удалить папку';

  @override
  String get deleteFolderDialogTitle => 'Удалить папку';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'Вы уверены, что хотите удалить папку «$category» и все её подпапки? Заметки в этих папках станут неотсортированными.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'Вы уверены, что хотите удалить папку «$category»? Заметки в этой папке станут неотсортированными.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'Отмена';

  @override
  String get deleteFolderDialogConfirmButton => 'Удалить';

  @override
  String get editCategoryNameColorMenuItemLabel => 'Изменить название/цвет';

  @override
  String get addSubfolderMenuItemLabel => 'Создать подпапку';

  @override
  String get expandSubfoldersMenuItemLabel => 'Развернуть подпапки';

  @override
  String get collapseSubfoldersMenuItemLabel => 'Свернуть подпапки';

  @override
  String saveErrorInfoMessage(String error) {
    return 'Ошибка сохранения: $error';
  }

  @override
  String get welcomeNoteTitle => 'Добро пожаловать в Layout! 🚀';

  @override
  String get welcomeNoteContent => 'Добавлены новые функции!';

  @override
  String get noteListDateGroupToday => 'Сегодня';

  @override
  String get noteListDateGroupYesterday => 'Вчера';

  @override
  String get noteListDateGroupLast7Days => 'Последние 7 дней';

  @override
  String get noteListDateGroupLast30Days => 'Последние 30 дней';

  @override
  String get reminderRepeatNoneLabel => 'Без повтора';

  @override
  String get voiceRecorderPreparingLabel => 'Подготовка…';

  @override
  String get voiceRecorderCancelButton => 'Отмена';

  @override
  String get voiceRecorderStopAddButton => 'Остановить и добавить';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'Доступ к микрофону не предоставлен.';

  @override
  String get speechToTextUnavailableMessage =>
      'Распознавание речи недоступно на этом устройстве.';

  @override
  String get speechToTextPreparingLabel => 'Подготовка…';

  @override
  String get speechToTextListeningLabel => 'Слушаю…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'Начните говорить…';

  @override
  String get speechToTextCancelButton => 'Отмена';

  @override
  String get speechToTextStopAddButton => 'Остановить и добавить';

  @override
  String get textToSpeechNoContentMessage => 'Нет содержимого для чтения.';

  @override
  String get textToSpeechReadErrorMessage => 'Произошла ошибка при чтении.';

  @override
  String get textToSpeechUnavailableMessage =>
      'Озвучивание текста недоступно на этом устройстве.';

  @override
  String get textToSpeechPreparingLabel => 'Подготовка…';

  @override
  String get textToSpeechPausedLabel => 'Приостановлено';

  @override
  String get textToSpeechFinishedLabel => 'Чтение завершено';

  @override
  String get textToSpeechReadingLabel => 'Чтение…';

  @override
  String get textToSpeechCloseErrorButton => 'Закрыть';

  @override
  String get textToSpeechReplayButton => 'Прочитать снова';

  @override
  String get textToSpeechCloseFinishedButton => 'Закрыть';

  @override
  String get textToSpeechPauseButton => 'Пауза';

  @override
  String get textToSpeechResumeButton => 'Продолжить';

  @override
  String get textToSpeechStopButton => 'Стоп';

  @override
  String get textToSpeechSpeedSlow => 'Медленно';

  @override
  String get textToSpeechSpeedNormal => 'Обычно';

  @override
  String get textToSpeechSpeedFast => 'Быстро';

  @override
  String get calendarPickerCancelButton => 'Отмена';

  @override
  String get calendarPickerConfirmButton => 'Выбрать';

  @override
  String get calendarPickerClearButton => 'Очистить';

  @override
  String get reminderPickerDialogTitle => 'Добавить напоминание';

  @override
  String get reminderPickerDateTodayOption => 'Сегодня';

  @override
  String get reminderPickerDateTomorrowOption => 'Завтра';

  @override
  String get reminderPickerDatePickOption => 'Выбрать дату';

  @override
  String get reminderRepeatHourlyLabel => 'Каждый час';

  @override
  String get reminderRepeatDailyLabel => 'Каждый день';

  @override
  String get reminderRepeatWeeklyLabel => 'Каждую неделю';

  @override
  String get reminderRepeatMonthlyLabel => 'Каждый месяц';

  @override
  String get reminderRepeatYearlyLabel => 'Каждый год';

  @override
  String get reminderPickerCalendarHelpText => 'Выберите дату напоминания';

  @override
  String get reminderPickerCancelButton => 'ОТМЕНА';

  @override
  String get reminderPickerSaveButton => 'СОХРАНИТЬ';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'Нельзя выбрать прошедшее время';

  @override
  String calcTableTotalLabel(String amount) {
    return 'Итого: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'Подготовка данных...';

  @override
  String get backupCreatePackagingNotesLabel =>
      'Упаковка заметок и категорий...';

  @override
  String get backupCreateReadingAttachmentsLabel => 'Чтение вложений...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'Чтение вложений... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'Сжатие zip-файла...';

  @override
  String get backupCreateSavingFileLabel => 'Сохранение файла...';

  @override
  String get backupRestoreValidatingLabel => 'Проверка резервной копии...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'Резервная копия проверена, подготовка данных...';

  @override
  String get backupRestoreWritingNotesLabel => 'Запись заметок...';

  @override
  String get backupRestoreWritingTrashLabel => 'Запись корзины...';

  @override
  String get backupRestoreTrashWrittenLabel => 'Корзина записана';

  @override
  String get backupRestoreWritingCategoriesLabel => 'Запись категорий...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'Категории записаны';

  @override
  String get backupRestoreWritingSettingsLabel => 'Запись настроек...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'Настройки записаны';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'Очистка старых вложений...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'Вложения не найдены, завершение...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'Восстановление вложений... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'Завершено';

  @override
  String get backupValidationCorruptedFileMessage =>
      'Файл повреждён или не является корректным файлом резервной копии.';

  @override
  String get backupValidationMissingDataMessage =>
      'Внутри файла резервной копии не найдены данные (отсутствует backup_data.json).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'Не удалось прочитать данные резервной копии (повреждённый JSON).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'Этот файл не является резервной копией приложения layout.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'Не удалось прочитать информацию о версии файла резервной копии.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'Эта резервная копия имеет более новый формат, который не поддерживается текущей версией приложения. Пожалуйста, обновите приложение.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'Информация о версии файла резервной копии недействительна.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'Данные резервной копии не соответствуют ожидаемому формату (отсутствует поле заметок).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'Данные резервной копии не соответствуют ожидаемому формату (отсутствует поле корзины).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'Данные резервной копии не соответствуют ожидаемому формату (список категорий недействителен).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'Данные резервной копии не соответствуют ожидаемому формату (поле настроек недействительно).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'Данные резервной копии не соответствуют ожидаемому формату (запись заметки недействительна).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'Данные резервной копии не соответствуют ожидаемому формату (найдена запись заметки без ID).';

  @override
  String get backupValidationFileNotFoundMessage =>
      'Файл резервной копии не найден.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'На устройстве недостаточно свободного места. Освободите место и попробуйте снова.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'В доступе к файлу отказано. Проверьте разрешения приложения и попробуйте снова.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'Произошла ошибка при операции с файлом: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'Произошла непредвиденная ошибка: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'Не удалось создать zip-архив (ZipEncoder вернул null).';

  @override
  String get calcTableMenuItemLabel => 'Список вычислений';

  @override
  String get tagsMenuItemLabel => 'Теги';

  @override
  String get linkDialogUrlHint => 'https://example.com';

  @override
  String get checklistItemHint => 'Добавить пункт...';

  @override
  String get toolbarHighlightTooltip => 'Выделение';

  @override
  String get toolbarListTooltip => 'Список';

  @override
  String get toolbarHideKeyboardTooltip => 'Скрыть клавиатуру';

  @override
  String get autoBackupLocalSuccessMessage =>
      'Локальное резервное копирование выполнено успешно.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'Локальное резервное копирование не удалось: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Резервное копирование на Drive пропущено: аккаунт Google не подключён или сеанс истёк. Пожалуйста, откройте приложение и переподключитесь.';

  @override
  String get autoBackupDriveSuccessMessage =>
      'Резервное копирование на Drive выполнено успешно.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Резервное копирование на Drive не удалось: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'Заметок пока нет';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'Итого: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ Рисунок';

  @override
  String get autoBackupSettingsAppBarTitle =>
      'Настройки автоматического резервного копирования';

  @override
  String get autoBackupSettingsMainSwitchTitle =>
      'Включить автоматическое резервное копирование';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'Ваши заметки периодически надёжно копируются в фоновом режиме.';

  @override
  String get autoBackupSettingsTargetTitle => 'Место резервного копирования';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'Выберите, куда сохранять резервные копии.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'Локально';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'Оба варианта';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Сначала подключите аккаунт, чтобы использовать параметры Google Drive.';

  @override
  String get autoBackupSettingsConnectButton => 'Подключить';

  @override
  String get autoBackupSettingsFrequencyTitle =>
      'Частота резервного копирования';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'Резервная копия создаётся каждые $hours ч.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 часов';

  @override
  String get autoBackupSettingsFrequency12h => '12 часов';

  @override
  String get autoBackupSettingsFrequency24h => '24 часа (ежедневно)';

  @override
  String get autoBackupSettingsFrequency48h => '48 часов (2 дня)';

  @override
  String get autoBackupSettingsFrequency168h => '168 часов (еженедельно)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Только через Wi-Fi';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'Загрузка в облако выполняется только через Wi-Fi для экономии мобильного трафика.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'Статус системы';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'Автоматическое резервное копирование ещё не выполнялось.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'Последний запуск: $date $time ($status)\nСообщение: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'Успешно';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'Не удалось';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Не удалось подключиться к аккаунту Google.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'Настройки автоматического резервного копирования обновлены.';

  @override
  String selectionModeDeletedMessage(int count) {
    return 'Удалено заметок: $count';
  }

  @override
  String get selectionModeArchivedMessage => 'Архивировано';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'Выберите категорию для $count заметок';
  }

  @override
  String get selectionModeAddCategoryOption => 'Добавить категорию';

  @override
  String get selectionModeRemoveCategoryOption => 'Удалить категорию';

  @override
  String get calcTableItemHint => 'Позиция...';

  @override
  String get calcTableTotalRowLabel => 'Итого';

  @override
  String get textSelectionMenuShareButton => 'Поделиться';

  @override
  String get textSelectionMenuTranslateButton => 'Перевести';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'Не удалось начать отправку.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'Не удалось открыть перевод.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'Сегодня $time';
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
    return 'Последняя резервная копия: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage =>
      'Резервная копия ещё не создавалась.';

  @override
  String get backupFileNameLabel => 'Резервная копия';
}
