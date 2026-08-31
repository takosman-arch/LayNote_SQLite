// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'Bold';

  @override
  String get toolbarItalicTooltip => 'Italic';

  @override
  String get toolbarUnderlineTooltip => 'Underline';

  @override
  String get toolbarStrikethroughTooltip => 'Strikethrough';

  @override
  String get toolbarFontSizeTooltip => 'Font Size';

  @override
  String get toolbarColorTooltip => 'Text Color';

  @override
  String get toolbarBulletTooltip => 'Bullet List';

  @override
  String get toolbarNumberTooltip => 'Numbered List';

  @override
  String get toolbarIndentTooltip => 'Paragraph Indent';

  @override
  String get toolbarLinkTooltip => 'Add / Edit / Remove Link';

  @override
  String get toolbarDividerTooltip => 'Insert Divider';

  @override
  String get toolbarChecklistTooltip => 'Add Checklist';

  @override
  String get linkSelectTextSnackbar => 'Select the text you want to link first';

  @override
  String get linkDialogEditTitle => 'Edit Link';

  @override
  String get linkDialogAddTitle => 'Add Link';

  @override
  String get linkDialogRemoveButton => 'Remove Link';

  @override
  String get linkDialogCancelButton => 'Cancel';

  @override
  String get linkDialogConfirmButton => 'Add';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Camera permission denied. You need to allow it from settings to record video.';

  @override
  String get cameraPermissionRequiredMessage =>
      'Camera permission is required to record video.';

  @override
  String get openSettingsButtonLabel => 'Settings';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'Scan could not be started: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'Text recognition failed: $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'No readable text was found in the document';

  @override
  String get scanResultSheetTitle =>
      'How should the scanned document be added?';

  @override
  String get scanResultTextOnlyOption => 'Add as text only';

  @override
  String get scanResultTextAndImageOption => 'Add text + scanned image';

  @override
  String get scanResultCancelOption => 'Cancel';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'Microphone permission denied. You need to allow it from settings to record audio.';

  @override
  String get audioPermissionRequiredMessage =>
      'Microphone permission is required to record audio.';

  @override
  String get voiceRecordingDefaultLabel => 'Voice Recording';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'Calculation List ($count rows)';
  }

  @override
  String blockPreviewTableLabel(int count) {
    return 'Table ($count rows)';
  }

  @override
  String get blockPreviewDrawingLabel => 'Drawing';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count attachments (photo/document)';
  }

  @override
  String get blockPreviewDividerLabel => 'Divider';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'Checklist ($count items)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(empty text)';

  @override
  String get reorderBlocksSheetTitle => 'Reorder Blocks';

  @override
  String get reorderBlocksMoveUpTooltip => 'Move Up';

  @override
  String get reorderBlocksMoveDownTooltip => 'Move Down';

  @override
  String get reorderBlocksCloseTooltip => 'Close';

  @override
  String get reorderBlocksDescription =>
      'Tap a block to select it, then use the up/down arrows to move it.';

  @override
  String get reorderBlocksMenuItemLabel => 'Reorder';

  @override
  String get txtImportPickerDialogTitle => 'Select the TXT file to import';

  @override
  String get txtImportReadFailedMessage => 'The TXT file could not be read';

  @override
  String get txtImportEmptyFileMessage => 'The TXT file is empty';

  @override
  String get txtImportSuccessMessage => 'TXT imported';

  @override
  String get txtImportMenuItemLabel => 'Import (txt)';

  @override
  String get exportMenuItemLabel => 'Export';

  @override
  String get editorUndoTooltip => 'Undo';

  @override
  String get editorRedoTooltip => 'Redo';

  @override
  String get noteSavedMessage => 'Note saved';

  @override
  String get dateAssignPickerHelpText => 'Assign note to a day';

  @override
  String get dateAssignChangeOption => 'Change date';

  @override
  String get dateAssignRemoveOption => 'Remove assignment';

  @override
  String get editorSubToolbarCloseTooltip => 'Close';

  @override
  String get titleFieldHint => 'Title';

  @override
  String get textBlockHint => 'Write your note here...';

  @override
  String get drawingBoardMenuItemLabel => 'Drawing Board';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'Voice-to-text is only available for text notes';

  @override
  String get selectionModeCancelTooltip => 'Cancel Selection';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return '$count selected';
  }

  @override
  String get selectionModeDeleteTooltip => 'Delete';

  @override
  String get selectionModeArchiveTooltip => 'Archive';

  @override
  String get selectionModeFolderTooltip => 'Folder';

  @override
  String get searchFieldHint => 'Search notes...';

  @override
  String get emptyTrashDialogTitle => 'Empty Trash';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'All deleted notes will be permanently removed. Are you sure?';

  @override
  String get emptyTrashDialogCancelButton => 'Cancel';

  @override
  String get restoreAllMenuItemLabel => 'Restore All';

  @override
  String get sortMenuTooltip => 'Sort Notes';

  @override
  String get sortMenuAscendingLabel => 'Order: Ascending (A-Z)';

  @override
  String get sortMenuDescendingLabel => 'Order: Descending (Z-A)';

  @override
  String get sortMenuByTitleLabel => 'Sort by: Title';

  @override
  String get sortMenuByModifiedDateLabel => 'Sort by: Last Modified';

  @override
  String get sortMenuByCreatedDateLabel => 'Sort by: Date Created';

  @override
  String get sortMenuByFolderLabel => 'Sort by: Folder';

  @override
  String get viewToggleGridTooltip => 'Grid View';

  @override
  String get viewToggleListTooltip => 'List View';

  @override
  String get drawerHeaderSubtitle => 'Your Personal Notebook';

  @override
  String get drawerNotesSectionHeader => 'NOTES';

  @override
  String get drawerAllNotesLabel => 'Notes';

  @override
  String get drawerFavoritesLabel => 'Favorite';

  @override
  String get drawerAgendaLabel => 'Agenda';

  @override
  String get drawerRemindersLabel => 'Reminder';

  @override
  String get drawerLockedLabel => 'Locked';

  @override
  String get drawerTrashLabel => 'Trash';

  @override
  String get drawerFoldersSectionHeader => 'FOLDERS';

  @override
  String get drawerExpandLabel => 'Expand';

  @override
  String get drawerCollapseLabel => 'Collapse';

  @override
  String get drawerAddFolderLabel => 'Add Folder';

  @override
  String get drawerAppSectionHeader => 'APP';

  @override
  String get drawerCalendarLabel => 'Calendar';

  @override
  String get drawerSettingsLabel => 'Settings';

  @override
  String get drawerBackupRestoreLabel => 'Backup & Restore';

  @override
  String get drawerUpgradeToProLabel => 'Upgrade to Pro';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'Support Development';

  @override
  String get drawerFeedbackLabel => 'Feedback';

  @override
  String get drawerRateAppLabel => 'Rate the App';

  @override
  String get drawerAboutLabel => 'About';

  @override
  String get noNotesFoundMessage => 'No notes found.';

  @override
  String get trashRestoreButtonLabel => 'Restore';

  @override
  String get trashPermanentDeleteButtonLabel => 'Delete Permanently';

  @override
  String get tagRenamedInfoMessage => 'Tag renamed';

  @override
  String get tagDeletedInfoMessage => 'Tag deleted';

  @override
  String get tagOptionsRenameLabel => 'Rename';

  @override
  String get tagOptionsDeleteLabel => 'Delete';

  @override
  String get renameTagDialogTitle => 'Rename Tag';

  @override
  String get renameTagDialogHint => 'New tag name';

  @override
  String get renameTagDialogCancelButton => 'Cancel';

  @override
  String get renameTagDialogSaveButton => 'Save';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '\"$tag\" will be removed from $affectedCount notes. Continue?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'Delete the \"$tag\" tag?';
  }

  @override
  String get deleteTagDialogTitle => 'Delete Tag';

  @override
  String get deleteTagDialogCancelButton => 'Cancel';

  @override
  String get deleteTagDialogConfirmButton => 'Delete';

  @override
  String get tagsSheetTitle => 'Tags';

  @override
  String get tagsSheetEmptyMessage => 'No tags on this note yet.';

  @override
  String get tagsSheetInputHint => 'Write a new tag...';

  @override
  String get tagsSheetSuggestionsLabel => 'Existing tags';

  @override
  String get noteDeletedInfoMessage => 'Note deleted';

  @override
  String get noteDeletedUndoActionLabel => 'Undo';

  @override
  String get reminderSetInfoMessage => 'Reminder set';

  @override
  String get reminderRemovedInfoMessage => 'Reminder removed';

  @override
  String get noteDuplicatedInfoMessage => 'Copy created';

  @override
  String get speechTextAppendedInfoMessage => 'Text added to note';

  @override
  String get pdfPreparingInfoMessage => 'Preparing PDF…';

  @override
  String get pdfSavedInfoMessage => 'PDF saved';

  @override
  String get pdfPreviewSaveActionLabel => 'Save';

  @override
  String get jpgPreparingInfoMessage => 'Preparing JPG…';

  @override
  String get jpgSavedInfoMessage => 'JPG saved';

  @override
  String get jpgFailedInfoMessage => 'Could not create JPG';

  @override
  String get txtPreparingInfoMessage => 'Preparing TXT…';

  @override
  String get txtSavedInfoMessage => 'TXT saved';

  @override
  String get txtFailedInfoMessage => 'Could not create TXT';

  @override
  String get exportOpenActionLabel => 'Open';

  @override
  String get wrongPasswordInfoMessage => 'Wrong password.';

  @override
  String get noteArchivedInfoMessage => 'Note archived';

  @override
  String get noteUnarchivedInfoMessage => 'Removed from archive';

  @override
  String get noteUnlockedInfoMessage => 'Unlocked';

  @override
  String get noteLockedInfoMessage => 'Note locked';

  @override
  String get notificationUnpinnedInfoMessage => 'Unpinned';

  @override
  String get emptyNotePinBlockedInfoMessage =>
      'An empty note cannot be pinned.';

  @override
  String get notificationPinnedInfoMessage => 'Pinned to notification panel';

  @override
  String get noContentToReadInfoMessage => 'There is no content to read';

  @override
  String get backPressExitInfoMessage => 'Press back again to exit';

  @override
  String get reminderChannelName => 'Note Reminders';

  @override
  String get reminderChannelDescription => 'Note reminders in the Layout app';

  @override
  String get pinnedChannelName => 'Pinned Notes';

  @override
  String get pinnedChannelDescription =>
      'Layout notes pinned to the notification panel';

  @override
  String get notificationUnpinActionLabel => 'Remove';

  @override
  String get reminderDefaultTitle => 'Reminder';

  @override
  String get reminderChecklistBodyFallback =>
      'Don\'t forget to check your checklist';

  @override
  String get reminderTextBodyFallback => 'Don\'t forget to check your note';

  @override
  String get pdfSaveDialogTitle => 'Save as PDF';

  @override
  String get jpgSaveDialogTitle => 'Save as JPG';

  @override
  String get txtSaveDialogTitle => 'Save as TXT';

  @override
  String get textSizeSheetTitle => 'Text Size';

  @override
  String get textSizeSamplePreview => 'Sample text';

  @override
  String get textSizeCancelButton => 'Cancel';

  @override
  String get textSizeApplyButton => 'Apply';

  @override
  String get createPasswordDialogTitle => 'Create Password';

  @override
  String get createPasswordNewPasswordHint => 'New password';

  @override
  String get createPasswordConfirmHint => 'Re-enter password';

  @override
  String get createPasswordHintQuestionDescription =>
      'Set a security question in case you forget your password (optional).';

  @override
  String get createPasswordHintQuestionHint => 'Choose a security question';

  @override
  String get createPasswordHintAnswerHint => 'Your answer';

  @override
  String get createPasswordCancelButton => 'Cancel';

  @override
  String get createPasswordSaveButton => 'Save';

  @override
  String get passwordMismatchMessage => 'Passwords don\'t match!';

  @override
  String get passwordRequiredDialogTitle => 'Password Required';

  @override
  String get passwordRequiredHint => 'Enter password';

  @override
  String get forgotPasswordButtonLabel => 'Forgot my password';

  @override
  String get passwordRequiredCancelButton => 'Cancel';

  @override
  String get passwordRequiredConfirmButton => 'Verify';

  @override
  String get securityQuestionDialogTitle => 'Security Question';

  @override
  String get securityQuestionAnswerHint => 'Your answer';

  @override
  String get securityQuestionCancelButton => 'Cancel';

  @override
  String get securityQuestionConfirmButton => 'Confirm';

  @override
  String get securityQuestionWrongAnswerMessage => 'Wrong answer. Try again.';

  @override
  String get revealedPasswordDialogTitle => 'Your Password';

  @override
  String get revealedPasswordLabel => 'Your note password:';

  @override
  String get revealedPasswordOkButton => 'OK';

  @override
  String get securityQuestionPetName => 'What is the name of your first pet?';

  @override
  String get securityQuestionFavoriteTeacher =>
      'What is the name of your favorite teacher?';

  @override
  String get securityQuestionBirthCity => 'What city were you born in?';

  @override
  String get securityQuestionFavoriteFood => 'What is your favorite food?';

  @override
  String get securityQuestionMotherMaidenName =>
      'What is your mother\'s maiden name?';

  @override
  String get securityQuestionFirstSchool =>
      'What is the name of the first school you attended?';

  @override
  String get securityQuestionFavoriteColor => 'What is your favorite color?';

  @override
  String get editFolderDialogTitle => 'Edit Folder';

  @override
  String get newSubfolderDialogTitle => 'New Subfolder';

  @override
  String get addFolderDialogTitle => 'Add Folder';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'Will be created inside \"$parentCategory\"';
  }

  @override
  String get subfolderNameFieldLabel => 'Subfolder name';

  @override
  String get folderNameFieldLabel => 'Folder name';

  @override
  String get folderColorLabel => 'Color';

  @override
  String get folderDialogCancelButton => 'Cancel';

  @override
  String get folderDialogSaveButton => 'Save';

  @override
  String get folderDialogAddButton => 'Add';

  @override
  String get selectFolderSheetTitle => 'Select Folder';

  @override
  String get selectFolderAddOptionLabel => 'Add Folder';

  @override
  String get removeCurrentFolderLabel => 'Remove Current Folder';

  @override
  String get noteDetailsDialogTitle => 'Details';

  @override
  String get noteDetailsCreatedLabel => 'Created';

  @override
  String get noteDetailsModifiedLabel => 'Last Modified';

  @override
  String get noteDetailsCharCountLabel => 'Character Count';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count characters';
  }

  @override
  String get noteDetailsWordCountLabel => 'Word Count';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count words';
  }

  @override
  String get noteDetailsOkButton => 'OK';

  @override
  String get noteDetailsUnknownDateLabel => 'Unknown';

  @override
  String get addAttachmentSheetTitle => 'Add';

  @override
  String get addAttachmentImageOption => 'Add Image';

  @override
  String get addAttachmentCameraOption => 'Camera';

  @override
  String get addAttachmentFileOption => 'Add File';

  @override
  String get addAttachmentVoiceOption => 'Voice Recording';

  @override
  String get addAttachmentVideoOption => 'Record Video';

  @override
  String get addAttachmentScanOption => 'Scan Document';

  @override
  String get noteActionsSheetTitle => 'Choose Action';

  @override
  String get noteActionReminderLabel => 'Reminder';

  @override
  String get noteActionEditReminderLabel => 'Edit Reminder';

  @override
  String get noteActionSpeechToTextLabel => 'Speech to Text';

  @override
  String get noteActionArchiveLabel => 'Archive';

  @override
  String get noteActionUnarchiveLabel => 'Remove from Archive';

  @override
  String get noteActionLockLabel => 'Lock';

  @override
  String get noteActionUnlockLabel => 'Unlock';

  @override
  String get noteActionFavoriteLabel => 'Favorite';

  @override
  String get noteActionUnfavoriteLabel => 'Remove from Favorites';

  @override
  String get noteActionClassifyLabel => 'Select Folder';

  @override
  String get noteActionDeleteLabel => 'Delete';

  @override
  String get noteActionPinToNotificationLabel => 'Pin to Notification Panel';

  @override
  String get noteActionUnpinFromNotificationLabel => 'Remove Pin';

  @override
  String get noteActionShareLabel => 'Share';

  @override
  String get noteActionDuplicateLabel => 'Create Copy';

  @override
  String get noteActionCopyContentLabel => 'Copy Content';

  @override
  String get noteActionTtsLabel => 'Read Aloud';

  @override
  String get noteActionTextSizeLabel => 'Text Size';

  @override
  String get noteActionDetailsLabel => 'Details';

  @override
  String get noteActionDiscardChangesLabel => 'Discard Changes';

  @override
  String get noteActionSelectLabel => 'Select';

  @override
  String get reminderEditOptionLabel => 'Change reminder';

  @override
  String get reminderRemoveOptionLabel => 'Remove reminder';

  @override
  String get discardChangesDialogTitle => 'Discard Changes';

  @override
  String get discardChangesDialogMessage =>
      'Unsaved changes to this note will be lost. Are you sure you want to discard them?';

  @override
  String get discardChangesCancelButton => 'Cancel';

  @override
  String get discardChangesConfirmButton => 'Discard';

  @override
  String get pinnedNotificationDefaultTitle => 'Note';

  @override
  String get pdfFailedInfoMessage => 'Failed to create PDF';

  @override
  String get drawingScreenTitle => 'Drawing';

  @override
  String get drawingMinimizeTooltip => 'Minimize';

  @override
  String get drawingEmptyExportWarningMessage => 'Draw something first';

  @override
  String get drawingEraserPartialModeLabel => 'Partial';

  @override
  String get drawingEraserFullModeLabel => 'Full';

  @override
  String get drawingClearTooltip => 'Clear';

  @override
  String get drawingZoomOutTooltip => 'Zoom Out';

  @override
  String get drawingZoomInTooltip => 'Zoom In';

  @override
  String get drawingDeleteTooltip => 'Delete';

  @override
  String get drawingEmptyPreviewHint => 'Tap to draw';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsSectionSecurity => 'Security';

  @override
  String get settingsSectionTheme => 'Theme';

  @override
  String get settingsSectionPersonalization => 'Personalization';

  @override
  String get settingsSectionWidget => 'Widget';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsHintQuestionPet => 'What is the name of your first pet?';

  @override
  String get settingsHintQuestionTeacher =>
      'What is the name of your favorite teacher?';

  @override
  String get settingsHintQuestionBirthCity => 'What city were you born in?';

  @override
  String get settingsHintQuestionFavoriteFood => 'What is your favorite food?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'What is your mother\'s maiden name?';

  @override
  String get settingsHintQuestionFirstSchool =>
      'What was the first school you attended?';

  @override
  String get settingsHintQuestionFavoriteColor =>
      'What is your favorite color?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'Security Question';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'If you forget your password, you can recover it by answering this question correctly.';

  @override
  String get settingsSecurityQuestionDropdownHint =>
      'Choose a security question';

  @override
  String get settingsSecurityQuestionAnswerHint => 'Your answer';

  @override
  String get settingsSecurityQuestionCancelButton => 'Cancel';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'Question and answer cannot be empty!';

  @override
  String get settingsSecurityQuestionSaveButton => 'Save';

  @override
  String get settingsCreatePasswordTitle => 'Create Password';

  @override
  String get settingsPasswordRequiredTitle => 'Password Required';

  @override
  String get settingsPasswordEnterHint => 'Enter password';

  @override
  String get settingsForgotPasswordButton => 'Forgot my password';

  @override
  String get settingsNewPasswordHint => 'New password';

  @override
  String get settingsConfirmPasswordHint => 'Re-enter password';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'Set a security question in case you forget your password (optional).';

  @override
  String get settingsPasswordDialogCancelButton => 'Cancel';

  @override
  String get settingsPasswordMismatchWarning => 'Passwords do not match!';

  @override
  String get settingsWrongPasswordWarning => 'Wrong password!';

  @override
  String get settingsPasswordSaveButton => 'Save';

  @override
  String get settingsPasswordRemoveButton => 'Remove';

  @override
  String get settingsNotePasswordTitle => 'Note Password';

  @override
  String get settingsPasswordSetSubtitle => 'Password set ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'Password not set';

  @override
  String get settingsSecurityQuestionTileTitle => 'Security Question';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'Set ✓ — used if you forget your password';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'Not set — you won\'t be able to recover your password if lost';

  @override
  String get settingsThemeDialogTitle => 'Select Theme';

  @override
  String get settingsThemeSystemDefault => 'System Default';

  @override
  String get settingsThemeLightOption => 'Light Theme';

  @override
  String get settingsThemeDarkOption => 'Dark Theme';

  @override
  String get settingsLanguageDialogTitle => 'Select Language';

  @override
  String get settingsLanguageSystemOption => 'System';

  @override
  String get settingsAccentColorDialogTitle => 'Choose Accent Color';

  @override
  String get settingsThemeChangeTileTitle => 'Change Theme';

  @override
  String get settingsThemeLightLabel => 'Light';

  @override
  String get settingsThemeDarkLabel => 'Dark';

  @override
  String get settingsThemeSystemLabel => 'System';

  @override
  String get settingsLanguageTileTitle => 'Language';

  @override
  String get settingsAccentColorTileTitle => 'Accent Color';

  @override
  String get settingsAccentColorTileSubtitle =>
      'Color used in the app bar, buttons and switches';

  @override
  String get settingsColorfulNotesTitle => 'Varied Note Colors';

  @override
  String get settingsColorfulNotesSubtitle =>
      'Each note card gets a different color tone.';

  @override
  String get settingsTextColorSheetTitle => 'Text Color';

  @override
  String get settingsTextColorSheetDesc =>
      'Sets the color of the note content text.';

  @override
  String get settingsTextColorOkButton => 'OK';

  @override
  String get settingsTextColorTileTitle => 'Text Color';

  @override
  String get settingsTextColorTileSubtitle => 'Color for note content text.';

  @override
  String get settingsWidgetFontSizeLabel => 'Widget Font Size';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'Sample heading - $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'Cancel';

  @override
  String get settingsWidgetFontSizeApplyButton => 'Apply';

  @override
  String get settingsWidgetOpacityLabel => 'Background Transparency';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return '$percent% transparency';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'Cancel';

  @override
  String get settingsWidgetOpacityApplyButton => 'Apply';

  @override
  String get settingsWidgetDarkModeTitle => 'Dark Widget';

  @override
  String get settingsWidgetDarkModeDesc => 'Dark color scheme for the widget.';

  @override
  String get settingsAboutVersionTitle => 'App Version';

  @override
  String get settingsAboutVersionLoading => 'Loading version…';

  @override
  String get aboutSectionDeveloper => 'Feedback';

  @override
  String get aboutDeveloperTitle => 'Developer';

  @override
  String get aboutContactTitle => 'Contact';

  @override
  String get aboutWebsiteTitle => 'Website';

  @override
  String get aboutGithubTitle => 'GitHub';

  @override
  String get aboutSectionLegal => 'Legal';

  @override
  String get aboutPrivacyPolicyTitle => 'Privacy Policy';

  @override
  String get aboutTermsTitle => 'Terms of Use';

  @override
  String get aboutLicensesTitle => 'Open Source Licenses';

  @override
  String get aboutSectionSupport => 'Rate';

  @override
  String get aboutRateAppTitle => 'Rate the App';

  @override
  String get aboutLinkOpenError => 'Couldn\'t open the link.';

  @override
  String get settingsFontFamilyTileTitle => 'Font';

  @override
  String get settingsFontFamilyDefaultLabel => 'Default';

  @override
  String get settingsGlobalFontSizeTileTitle => 'Font Size';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt — applied to all notes.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'Sample text - $size pt';
  }

  @override
  String get settingsGlobalFontSizeCancelButton => 'Cancel';

  @override
  String get settingsGlobalFontSizeApplyButton => 'Apply';

  @override
  String get settingsPreviewLinesTileTitle => 'Note Preview Lines';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'Show up to $lines lines. If the note is shorter, the actual number of lines is shown.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'Current: $lines lines';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'Sets the maximum number of lines to preview. If the note has fewer lines, the actual number of lines is shown.';

  @override
  String get settingsPreviewLinesCancelButton => 'Cancel';

  @override
  String get settingsPreviewLinesApplyButton => 'Apply';

  @override
  String get backupCancelButton => 'Cancel';

  @override
  String get backupConnectButton => 'Connect';

  @override
  String get backupDisconnectButton => 'Disconnect';

  @override
  String get backupContinueButton => 'Continue';

  @override
  String get backupCloseButton => 'Close';

  @override
  String get backupShareButton => 'Share';

  @override
  String get backupRestoreButton => 'Restore';

  @override
  String get backupConfigureButton => 'Configure';

  @override
  String get backupUnknownDateLabel => 'Unknown';

  @override
  String get backupProcessingDefaultLabel => 'Processing...';

  @override
  String get backupPermissionRequiredTitle => 'Storage Permission Required';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'This Android version requires storage permission for backup/restore. Since permission was permanently denied, please enable it manually from the app settings.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'This Android version requires storage permission for backup/restore. Please grant permission to continue.';

  @override
  String get backupGoToSettingsButton => 'Go to Settings';

  @override
  String get backupRetryButton => 'Retry';

  @override
  String get backupDriveConnectingLabel => 'Connecting to Google account...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Connected to Google Drive account: $email';
  }

  @override
  String get backupDriveConnectedMessage =>
      'Connected to Google Drive account.';

  @override
  String get backupDriveConnectFailedMessage =>
      'Could not connect to Google account, or the operation was cancelled.';

  @override
  String get backupDriveDisconnectTitle => 'Disconnect Google Drive';

  @override
  String get backupDriveDisconnectBody =>
      'If you disconnect, manual or automatic backups to Drive won\'t be possible. Backups already stored on Drive won\'t be deleted — only access from this device will be removed.';

  @override
  String get backupDriveDisconnectedMessage =>
      'Google Drive connection removed.';

  @override
  String get backupDriveRequiredTitle => 'Google Account Required';

  @override
  String get backupDriveRequiredBody =>
      'This action requires you to connect your Google account. Would you like to connect now?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: connected ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: connected';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: not connected';

  @override
  String get backupDriveAuthenticatingLabel => 'Verifying Google account...';

  @override
  String get backupDriveNotSignedInMessage =>
      'You are not connected to Google Drive. Please sign in with your Google account first.';

  @override
  String get backupDriveUploadingLabel => 'Uploading backup to Drive...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Upload to Google Drive did not complete within 120 seconds (no response from server). Please check your connection and try again.';

  @override
  String get backupDriveOperationCompletedLabel => 'Completed';

  @override
  String get backupToDriveActionLabel => 'backup to Drive';

  @override
  String get backupToDeviceActionLabel => 'backup';

  @override
  String get backupCreatingLabel => 'Creating backup...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'Backup could not be created: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Upload to Google Drive failed: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'Backup successfully uploaded to Google Drive.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'Backup created: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'Backup Ready';

  @override
  String get backupOfferShareBody =>
      'Your backup file has been saved to your device. Would you like to share it now (e.g. cloud storage, email, another device)?';

  @override
  String get backupShareFileText => 'layout backup file';

  @override
  String backupShareFailedMessage(String error) {
    return 'Sharing could not be started: $error';
  }

  @override
  String get backupLargeOperationTitle => 'Large Backup';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'The data to be processed is approximately $sizeText. A $actionLabel of this size may take a while depending on your device. Just don\'t leave the app while it\'s in progress — would you like to continue?';
  }

  @override
  String get backupRestoreActionLabel => 'restore';

  @override
  String get backupDriveListingLabel => 'Listing Drive backups...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'Backups could not be listed: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'There are no backups on Google Drive yet.';

  @override
  String get backupDrivePickTitle => 'Choose a Backup from Drive';

  @override
  String get backupDriveDownloadingLabel => 'Downloading backup from Drive...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Downloading backup from Drive... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel => 'Saving file to device...';

  @override
  String get backupDriveUnknownBackupFileName => 'unknown_backup.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Your Google Drive storage is full. Please free up space on Drive and try again.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'Could not establish an internet connection. Please check your connection and try again.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'The specified backup file could not be found on Drive. It may have been deleted.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'An unexpected error occurred during the Google Drive operation: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'Download failed: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'File could not be selected: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'The selected file could not be accessed.';

  @override
  String get backupCheckingLabel => 'Checking backup...';

  @override
  String backupReadFailedMessage(String error) {
    return 'Backup file could not be read: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'Restore Backup';

  @override
  String get backupPreviewContentsHeader => 'Contents of the selected backup:';

  @override
  String get backupPreviewNoteCountLabel => 'Note count';

  @override
  String get backupPreviewTrashCountLabel => 'Notes in trash';

  @override
  String get backupPreviewCategoryCountLabel => 'Category count';

  @override
  String get backupPreviewAttachmentLabel => 'Attachments';

  @override
  String get backupPreviewAttachmentNoneValue => 'None';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count files ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'Created on';

  @override
  String get backupEmptyPreviewTitle => 'This backup looks empty';

  @override
  String get backupEmptyPreviewBody =>
      'No notes, categories, or attachments were found in the selected file. If you continue, your current data will still be deleted and replaced with this empty backup.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '$count attachments not found in the backup';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'Notes with these files will be restored, but without the attachments (they may have been missing or corrupted when the backup was taken): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown and $remaining more';
  }

  @override
  String get backupRestoreConfirmBody =>
      'This will REPLACE all your current notes, trash, categories, settings, and attachments with the data in the backup above. Your current data will be permanently lost and this action cannot be undone.';

  @override
  String get backupRestoringLabel => 'Restoring backup...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'Backup restored. However, $count attachments were not found in the backup and could not be restored. Restarting the app is recommended for the changes to fully take effect.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'Backup restored successfully. Restarting the app is recommended for the changes to fully take effect.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'An error occurred while restoring: $error';
  }

  @override
  String get backupScreenTitle => 'Backup & Restore';

  @override
  String get backupBlockedExitWarningMessage =>
      'An operation is in progress, please wait for it to finish.';

  @override
  String get backupBusyBackTooltip => 'Operation in progress';

  @override
  String get backupIntroText =>
      'You can back up your notes, categories, settings, and attachments as a single .zip file, or restore a backup you took earlier.';

  @override
  String get backupDriveCardTitle => 'Back Up to Google Drive';

  @override
  String get backupDriveCardSubtitle =>
      'Create a new backup and upload it directly to the private area of your Google Drive.';

  @override
  String get backupDriveCardButtonLabel => 'Back Up to Drive';

  @override
  String get backupDeviceCardTitle => 'Back Up to Device';

  @override
  String get backupDeviceCardSubtitle =>
      'Save all your data as a single .zip file to your device and share it if you\'d like.';

  @override
  String get backupDeviceCardButtonLabel => 'Back Up to Device';

  @override
  String get backupHistoryCardTitle => 'Backup History';

  @override
  String get backupHistoryCardSubtitle =>
      'View all backups stored on your device with their date and size; you can share, restore, or delete them directly from here.';

  @override
  String get backupHistoryTabDevice => 'Device';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'Delete Backup';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'Are you sure you want to permanently delete the backup file \"$fileName\"? This action cannot be undone.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'Backup deleted.';

  @override
  String get backupHistoryDriveDeleteDialogTitle => 'Delete Drive Backup';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'Are you sure you want to permanently delete the backup \"$fileName\" from Google Drive? This action cannot be undone and the file will not be moved to trash.';
  }

  @override
  String get backupHistoryDriveDeletedMessage => 'Drive backup deleted.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'Could not delete: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'No backups saved on this device yet.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'Use \"Back Up to Device\" to create your first backup.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'Use \"Back Up to Google Drive\" to create your first cloud backup.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Connect your Google account to see your Drive backups.';

  @override
  String get backupHistoryConnectGoogleButton => 'Connect with Google';

  @override
  String get backupHistoryDriveConnectedFallback => 'Connected';

  @override
  String get backupHistoryUnknownErrorFallback => 'An unknown error occurred.';

  @override
  String get backupHistoryDownloadStartingLabel => 'Starting...';

  @override
  String get backupAutoBackupEnabledLabel => 'Automatic Backup: on';

  @override
  String get backupAutoBackupDisabledLabel => 'Automatic Backup: off';

  @override
  String get backupOverlayWarningMessage =>
      'Please wait, don\'t leave the app until the operation completes.';

  @override
  String get pdfExportUntitledNoteLabel => 'Untitled Note';

  @override
  String get pdfExportDefaultAttachmentName => 'Attachment';

  @override
  String get pdfExportDefaultFileName => 'note';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'Screenshot could not be captured (boundary not found)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'Screenshot data could not be generated';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'Image could not be processed (PNG decode failed)';

  @override
  String get screenshotCalcTableTotalLabel => 'Total';

  @override
  String get gundemMenuRemoveFromAgenda => 'Remove from agenda';

  @override
  String get gundemMenuDeleteNote => 'Delete note';

  @override
  String get gundemSectionOverdue => 'Overdue';

  @override
  String get gundemSectionToday => 'Today';

  @override
  String get gundemSectionTomorrow => 'Tomorrow';

  @override
  String get gundemSectionNextWeek => 'Next Week';

  @override
  String get gundemSectionFurther => 'Further Ahead';

  @override
  String get gundemWeekdayMonday => 'Monday';

  @override
  String get gundemWeekdayTuesday => 'Tuesday';

  @override
  String get gundemWeekdayWednesday => 'Wednesday';

  @override
  String get gundemWeekdayThursday => 'Thursday';

  @override
  String get gundemWeekdayFriday => 'Friday';

  @override
  String get gundemWeekdaySaturday => 'Saturday';

  @override
  String get gundemWeekdaySunday => 'Sunday';

  @override
  String get gundemAppBarTitle => 'Agenda';

  @override
  String get gundemCalendarTooltip => 'Calendar';

  @override
  String get gundemEmptyTitle => 'Nothing on your agenda';

  @override
  String get gundemEmptySubtitle =>
      'Notes with a reminder or an assigned date will appear here.';

  @override
  String get gundemUntitledNote => 'Untitled note';

  @override
  String get gundemRepeatHourly => 'Hourly';

  @override
  String get gundemRepeatDaily => 'Daily';

  @override
  String get gundemRepeatWeekly => 'Weekly';

  @override
  String get gundemRepeatMonthly => 'Monthly';

  @override
  String get gundemRepeatYearly => 'Yearly';

  @override
  String get gundemPreviewCalcTableLabel => '[Calculation List]';

  @override
  String get gundemPreviewDrawingLabel => '[Drawing]';

  @override
  String get gundemPreviewImageLabel => '[Image]';

  @override
  String get gundemMonthShortJan => 'Jan';

  @override
  String get gundemMonthShortFeb => 'Feb';

  @override
  String get gundemMonthShortMar => 'Mar';

  @override
  String get gundemMonthShortApr => 'Apr';

  @override
  String get gundemMonthShortMay => 'May';

  @override
  String get gundemMonthShortJun => 'Jun';

  @override
  String get gundemMonthShortJul => 'Jul';

  @override
  String get gundemMonthShortAug => 'Aug';

  @override
  String get gundemMonthShortSep => 'Sep';

  @override
  String get gundemMonthShortOct => 'Oct';

  @override
  String get gundemMonthShortNov => 'Nov';

  @override
  String get gundemMonthShortDec => 'Dec';

  @override
  String get calendarAppBarTitle => 'Calendar';

  @override
  String get calendarTodayButton => 'Today';

  @override
  String get calendarLegendNoteLabel => 'Note';

  @override
  String get calendarLegendReminderLabel => 'Reminder';

  @override
  String get calendarTodayBadge => 'Today';

  @override
  String get calendarEmptyDayMessage => 'No notes or reminders for this day.';

  @override
  String get calendarReminderHourlyLabel => 'Hourly';

  @override
  String get calendarMonthJan => 'January';

  @override
  String get calendarMonthFeb => 'February';

  @override
  String get calendarMonthMar => 'March';

  @override
  String get calendarMonthApr => 'April';

  @override
  String get calendarMonthMay => 'May';

  @override
  String get calendarMonthJun => 'June';

  @override
  String get calendarMonthJul => 'July';

  @override
  String get calendarMonthAug => 'August';

  @override
  String get calendarMonthSep => 'September';

  @override
  String get calendarMonthOct => 'October';

  @override
  String get calendarMonthNov => 'November';

  @override
  String get calendarMonthDec => 'December';

  @override
  String get calendarWeekdayShortMon => 'Mon';

  @override
  String get calendarWeekdayShortTue => 'Tue';

  @override
  String get calendarWeekdayShortWed => 'Wed';

  @override
  String get calendarWeekdayShortThu => 'Thu';

  @override
  String get calendarWeekdayShortFri => 'Fri';

  @override
  String get calendarWeekdayShortSat => 'Sat';

  @override
  String get calendarWeekdayShortSun => 'Sun';

  @override
  String get calendarWeekdayFullMonday => 'Monday';

  @override
  String get calendarWeekdayFullTuesday => 'Tuesday';

  @override
  String get calendarWeekdayFullWednesday => 'Wednesday';

  @override
  String get calendarWeekdayFullThursday => 'Thursday';

  @override
  String get calendarWeekdayFullFriday => 'Friday';

  @override
  String get calendarWeekdayFullSaturday => 'Saturday';

  @override
  String get calendarWeekdayFullSunday => 'Sunday';

  @override
  String get wrongPasswordDialogTitle => 'Wrong Password';

  @override
  String get wrongPasswordDialogMessage =>
      'The password you entered is incorrect.';

  @override
  String get commonOkButton => 'OK';

  @override
  String get unlockCategoryAction => 'Unlock';

  @override
  String get lockCategoryAction => 'Lock';

  @override
  String get categoryUnlockedMessage => 'Unlocked';

  @override
  String get categoryLockedMessage => 'Folder locked';

  @override
  String get deleteFolderMenuItemLabel => 'Delete Folder';

  @override
  String get deleteFolderDialogTitle => 'Delete Folder';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'Are you sure you want to delete the folder \"$category\" and all its subfolders? Notes in these folders will become uncategorized.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'Are you sure you want to delete the folder \"$category\"? Notes in this folder will become uncategorized.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'Cancel';

  @override
  String get deleteFolderDialogConfirmButton => 'Delete';

  @override
  String get editCategoryNameColorMenuItemLabel => 'Edit Name / Color';

  @override
  String get addSubfolderMenuItemLabel => 'Create Subfolder';

  @override
  String get expandSubfoldersMenuItemLabel => 'Expand Subfolders';

  @override
  String get collapseSubfoldersMenuItemLabel => 'Collapse Subfolders';

  @override
  String saveErrorInfoMessage(String error) {
    return 'Save error: $error';
  }

  @override
  String get welcomeNoteTitle => 'Welcome to Layout! 🚀';

  @override
  String get welcomeNoteContent => 'New features added!';

  @override
  String get noteListDateGroupToday => 'Today';

  @override
  String get noteListDateGroupYesterday => 'Yesterday';

  @override
  String get noteListDateGroupLast7Days => 'Last 7 Days';

  @override
  String get noteListDateGroupLast30Days => 'Last 30 Days';

  @override
  String get reminderRepeatNoneLabel => 'No repeat';

  @override
  String get voiceRecorderPreparingLabel => 'Preparing…';

  @override
  String get voiceRecorderCancelButton => 'Cancel';

  @override
  String get voiceRecorderStopAddButton => 'Stop and Add';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'Microphone permission was not granted.';

  @override
  String get speechToTextUnavailableMessage =>
      'Speech recognition is not available on this device.';

  @override
  String get speechToTextPreparingLabel => 'Preparing…';

  @override
  String get speechToTextListeningLabel => 'Listening…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'Start speaking…';

  @override
  String get speechToTextCancelButton => 'Cancel';

  @override
  String get speechToTextStopAddButton => 'Stop and Add';

  @override
  String get textToSpeechNoContentMessage => 'There\'s no content to read.';

  @override
  String get textToSpeechReadErrorMessage => 'An error occurred while reading.';

  @override
  String get textToSpeechUnavailableMessage =>
      'Text-to-speech is not available on this device.';

  @override
  String get textToSpeechPreparingLabel => 'Preparing…';

  @override
  String get textToSpeechPausedLabel => 'Paused';

  @override
  String get textToSpeechFinishedLabel => 'Reading completed';

  @override
  String get textToSpeechReadingLabel => 'Reading…';

  @override
  String get textToSpeechCloseErrorButton => 'Close';

  @override
  String get textToSpeechReplayButton => 'Read Again';

  @override
  String get textToSpeechCloseFinishedButton => 'Close';

  @override
  String get textToSpeechPauseButton => 'Pause';

  @override
  String get textToSpeechResumeButton => 'Resume';

  @override
  String get textToSpeechStopButton => 'Stop';

  @override
  String get textToSpeechSpeedSlow => 'Slow';

  @override
  String get textToSpeechSpeedNormal => 'Normal';

  @override
  String get textToSpeechSpeedFast => 'Fast';

  @override
  String get calendarPickerCancelButton => 'Cancel';

  @override
  String get calendarPickerConfirmButton => 'Select';

  @override
  String get calendarPickerClearButton => 'Clear';

  @override
  String get reminderPickerDialogTitle => 'Add reminder';

  @override
  String get reminderPickerDateTodayOption => 'Today';

  @override
  String get reminderPickerDateTomorrowOption => 'Tomorrow';

  @override
  String get reminderPickerDatePickOption => 'Pick date';

  @override
  String get reminderRepeatHourlyLabel => 'Every hour';

  @override
  String get reminderRepeatDailyLabel => 'Every day';

  @override
  String get reminderRepeatWeeklyLabel => 'Every week';

  @override
  String get reminderRepeatMonthlyLabel => 'Every month';

  @override
  String get reminderRepeatYearlyLabel => 'Every year';

  @override
  String get reminderPickerCalendarHelpText => 'Select reminder date';

  @override
  String get reminderPickerCancelButton => 'CANCEL';

  @override
  String get reminderPickerSaveButton => 'SAVE';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'A past time cannot be selected';

  @override
  String calcTableTotalLabel(String amount) {
    return 'Total: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'Preparing data...';

  @override
  String get backupCreatePackagingNotesLabel =>
      'Packaging notes and categories...';

  @override
  String get backupCreateReadingAttachmentsLabel => 'Reading attachments...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'Reading attachments... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'Compressing zip file...';

  @override
  String get backupCreateSavingFileLabel => 'Saving file...';

  @override
  String get backupRestoreValidatingLabel => 'Validating backup...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'Backup validated, preparing data...';

  @override
  String get backupRestoreWritingNotesLabel => 'Writing notes...';

  @override
  String get backupRestoreWritingTrashLabel => 'Writing trash...';

  @override
  String get backupRestoreTrashWrittenLabel => 'Trash written';

  @override
  String get backupRestoreWritingCategoriesLabel => 'Writing categories...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'Categories written';

  @override
  String get backupRestoreWritingSettingsLabel => 'Writing settings...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'Settings written';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'Cleaning up old attachments...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'No attachments found, finishing...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'Restoring attachments... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'Completed';

  @override
  String get backupValidationCorruptedFileMessage =>
      'The file is corrupted or is not a valid backup file.';

  @override
  String get backupValidationMissingDataMessage =>
      'No data found inside the backup file (backup_data.json is missing).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'Backup data could not be read (corrupted JSON).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'This file is not a backup from the layout app.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'The backup file\'s version information could not be read.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'This backup is in a newer format that the current app version doesn\'t support. Please update the app.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'The backup file\'s version information is invalid.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'Backup data is not in the expected format (notes field is missing).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'Backup data is not in the expected format (trash field is missing).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'Backup data is not in the expected format (category list is invalid).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'Backup data is not in the expected format (settings field is invalid).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'Backup data is not in the expected format (a note record is invalid).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'Backup data is not in the expected format (a note record without an ID was found).';

  @override
  String get backupValidationFileNotFoundMessage => 'Backup file not found.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'Not enough free storage on the device. Please free up space and try again.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'File access permission was denied. Please check the app\'s permissions and try again.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'An error occurred during the file operation: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'An unexpected error occurred: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'Could not create the zip archive (ZipEncoder returned null).';

  @override
  String get calcTableMenuItemLabel => 'Calculation List';

  @override
  String get tableBlockMenuItemLabel => 'Table';

  @override
  String get tableSizePickerTitle => 'Select table size';

  @override
  String get tableSizePickerCancel => 'Cancel';

  @override
  String get tableSizePickerDeleteTooltip => 'Delete table';

  @override
  String get tagsMenuItemLabel => 'Tags';

  @override
  String get linkDialogUrlHint => 'https://example.com';

  @override
  String get checklistItemHint => 'Add item...';

  @override
  String get toolbarHighlightTooltip => 'Highlight';

  @override
  String get toolbarListTooltip => 'List';

  @override
  String get toolbarHideKeyboardTooltip => 'Hide Keyboard';

  @override
  String get autoBackupLocalSuccessMessage => 'Local backup successful.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'Local backup failed: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Drive backup skipped: Google account is not connected or the session has expired. Please open the app and reconnect.';

  @override
  String get autoBackupDriveSuccessMessage => 'Drive backup successful.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Drive backup failed: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'No notes yet';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'Total: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ Drawing';

  @override
  String get autoBackupSettingsAppBarTitle => 'Auto Backup Settings';

  @override
  String get autoBackupSettingsMainSwitchTitle => 'Enable Automatic Backup';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'Your notes are securely backed up periodically in the background.';

  @override
  String get autoBackupSettingsTargetTitle => 'Backup Target';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'Choose where backups are saved.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'Local';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'Both';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Connect your account first to use Google Drive options.';

  @override
  String get autoBackupSettingsConnectButton => 'Connect';

  @override
  String get autoBackupSettingsFrequencyTitle => 'Backup Frequency';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'A backup is taken every $hours hours.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 Hours';

  @override
  String get autoBackupSettingsFrequency12h => '12 Hours';

  @override
  String get autoBackupSettingsFrequency24h => '24 Hours (Daily)';

  @override
  String get autoBackupSettingsFrequency48h => '48 Hours (2 Days)';

  @override
  String get autoBackupSettingsFrequency168h => '168 Hours (Weekly)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Use Wi-Fi Only';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'Cloud upload only happens over Wi-Fi to protect your mobile data.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'System Status';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'Automatic backup hasn\'t run yet.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'Last Run: $date $time ($status)\nMessage: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'Successful';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'Failed';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Could not connect to Google account.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'Automatic backup settings updated.';

  @override
  String selectionModeDeletedMessage(int count) {
    return '$count notes deleted';
  }

  @override
  String get selectionModeArchivedMessage => 'Archived';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'Choose category for $count notes';
  }

  @override
  String get selectionModeAddCategoryOption => 'Add Category';

  @override
  String get selectionModeRemoveCategoryOption => 'Remove Category';

  @override
  String get calcTableItemHint => 'Item...';

  @override
  String get calcTableTotalRowLabel => 'Total';

  @override
  String get textSelectionMenuShareButton => 'Share';

  @override
  String get textSelectionMenuTranslateButton => 'Translate';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'Sharing could not be started.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'Translation could not be opened.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'Today $time';
  }

  @override
  String lastBackupInfoDateFormat(
    String day,
    String month,
    int year,
    String time,
  ) {
    return '$month/$day/$year $time';
  }

  @override
  String lastBackupInfoLabel(String date) {
    return 'Last backup: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage => 'No backup has been taken yet.';

  @override
  String get backupFileNameLabel => 'Backup';

  @override
  String get tableMenuInsertRowAfter => 'Add Row';

  @override
  String get tableMenuDeleteRow => 'Delete Row';

  @override
  String get tableMenuInsertColumnAfter => 'Add Column';

  @override
  String get tableMenuDeleteColumn => 'Delete Column';
}
