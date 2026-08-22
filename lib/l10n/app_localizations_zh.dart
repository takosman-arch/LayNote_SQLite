// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get toolbarBoldTooltip => '加粗';

  @override
  String get toolbarItalicTooltip => '斜体';

  @override
  String get toolbarUnderlineTooltip => '下划线';

  @override
  String get toolbarStrikethroughTooltip => '删除线';

  @override
  String get toolbarFontSizeTooltip => '字号';

  @override
  String get toolbarColorTooltip => '文字颜色';

  @override
  String get toolbarBulletTooltip => '项目符号列表';

  @override
  String get toolbarNumberTooltip => '编号列表';

  @override
  String get toolbarIndentTooltip => '段落缩进';

  @override
  String get toolbarLinkTooltip => '添加/编辑/删除链接';

  @override
  String get toolbarDividerTooltip => '插入分割线';

  @override
  String get toolbarChecklistTooltip => '添加清单';

  @override
  String get linkSelectTextSnackbar => '请先选择要添加链接的文本';

  @override
  String get linkDialogEditTitle => '编辑链接';

  @override
  String get linkDialogAddTitle => '添加链接';

  @override
  String get linkDialogRemoveButton => '移除链接';

  @override
  String get linkDialogCancelButton => '取消';

  @override
  String get linkDialogConfirmButton => '添加';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      '相机权限被拒绝。请在设置中允许相机权限以录制视频。';

  @override
  String get cameraPermissionRequiredMessage => '录制视频需要相机权限。';

  @override
  String get openSettingsButtonLabel => '设置';

  @override
  String documentScanStartFailedMessage(String error) {
    return '无法开始扫描：$error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return '文字识别失败：$error';
  }

  @override
  String get ocrNoReadableTextMessage => '在文档中未找到可识别的文字';

  @override
  String get scanResultSheetTitle => '扫描的文档应如何添加？';

  @override
  String get scanResultTextOnlyOption => '仅添加文字';

  @override
  String get scanResultTextAndImageOption => '添加文字+扫描图像';

  @override
  String get scanResultCancelOption => '取消';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      '麦克风权限被拒绝。请在设置中允许麦克风权限以录制音频。';

  @override
  String get audioPermissionRequiredMessage => '录制音频需要麦克风权限。';

  @override
  String get voiceRecordingDefaultLabel => '语音录制';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return '计算列表（$count 行）';
  }

  @override
  String get blockPreviewDrawingLabel => '绘图';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count 个附件（照片/文档）';
  }

  @override
  String get blockPreviewDividerLabel => '分割线';

  @override
  String blockPreviewChecklistLabel(int count) {
    return '清单（$count 项）';
  }

  @override
  String get blockPreviewEmptyTextLabel => '（空文本）';

  @override
  String get reorderBlocksSheetTitle => '重新排序模块';

  @override
  String get reorderBlocksMoveUpTooltip => '上移';

  @override
  String get reorderBlocksMoveDownTooltip => '下移';

  @override
  String get reorderBlocksCloseTooltip => '关闭';

  @override
  String get reorderBlocksDescription => '点按一个模块以选中它，然后使用上下箭头移动它。';

  @override
  String get reorderBlocksMenuItemLabel => '重新排序';

  @override
  String get txtImportPickerDialogTitle => '选择要导入的 TXT 文件';

  @override
  String get txtImportReadFailedMessage => '无法读取该 TXT 文件';

  @override
  String get txtImportEmptyFileMessage => 'TXT 文件为空';

  @override
  String get txtImportSuccessMessage => 'TXT 已导入';

  @override
  String get txtImportMenuItemLabel => '导入（txt）';

  @override
  String get exportMenuItemLabel => '导出';

  @override
  String get editorUndoTooltip => '撤销';

  @override
  String get editorRedoTooltip => '重做';

  @override
  String get noteSavedMessage => '笔记已保存';

  @override
  String get dateAssignPickerHelpText => '将笔记分配到某一天';

  @override
  String get dateAssignChangeOption => '更改日期';

  @override
  String get dateAssignRemoveOption => '移除分配';

  @override
  String get editorSubToolbarCloseTooltip => '关闭';

  @override
  String get titleFieldHint => '标题';

  @override
  String get textBlockHint => '在此处写下你的笔记……';

  @override
  String get drawingBoardMenuItemLabel => '画板';

  @override
  String get voiceToTextTextNotesOnlyMessage => '语音转文字仅适用于文本笔记';

  @override
  String get selectionModeCancelTooltip => '取消选择';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return '已选择 $count 项';
  }

  @override
  String get selectionModeDeleteTooltip => '删除';

  @override
  String get selectionModeArchiveTooltip => '归档';

  @override
  String get selectionModeFolderTooltip => '文件夹';

  @override
  String get searchFieldHint => '搜索笔记……';

  @override
  String get emptyTrashDialogTitle => '清空回收站';

  @override
  String get emptyTrashDialogConfirmMessage => '所有已删除的笔记将被永久移除。确定要继续吗？';

  @override
  String get emptyTrashDialogCancelButton => '取消';

  @override
  String get restoreAllMenuItemLabel => '全部恢复';

  @override
  String get sortMenuTooltip => '排序笔记';

  @override
  String get sortMenuAscendingLabel => '顺序：升序（A-Z）';

  @override
  String get sortMenuDescendingLabel => '顺序：降序（Z-A）';

  @override
  String get sortMenuByTitleLabel => '排序方式：标题';

  @override
  String get sortMenuByModifiedDateLabel => '排序方式：最后修改时间';

  @override
  String get sortMenuByCreatedDateLabel => '排序方式：创建日期';

  @override
  String get sortMenuByFolderLabel => '排序方式：文件夹';

  @override
  String get viewToggleGridTooltip => '网格视图';

  @override
  String get viewToggleListTooltip => '列表视图';

  @override
  String get drawerHeaderSubtitle => '你的个人笔记本';

  @override
  String get drawerNotesSectionHeader => '笔记';

  @override
  String get drawerAllNotesLabel => '笔记';

  @override
  String get drawerFavoritesLabel => '收藏';

  @override
  String get drawerAgendaLabel => '日程';

  @override
  String get drawerRemindersLabel => '提醒';

  @override
  String get drawerLockedLabel => '已锁定';

  @override
  String get drawerTrashLabel => '回收站';

  @override
  String get drawerFoldersSectionHeader => '文件夹';

  @override
  String get drawerExpandLabel => '展开';

  @override
  String get drawerCollapseLabel => '收起';

  @override
  String get drawerAddFolderLabel => '添加文件夹';

  @override
  String get drawerAppSectionHeader => '应用';

  @override
  String get drawerCalendarLabel => '日历';

  @override
  String get drawerSettingsLabel => '设置';

  @override
  String get drawerBackupRestoreLabel => '备份与恢复';

  @override
  String get drawerUpgradeToProLabel => '升级到专业版';

  @override
  String get drawerProBadgeLabel => '专业版';

  @override
  String get drawerSupportDevelopmentLabel => '支持开发';

  @override
  String get drawerFeedbackLabel => '反馈';

  @override
  String get drawerAboutLabel => '关于';

  @override
  String get noNotesFoundMessage => '未找到笔记。';

  @override
  String get trashRestoreButtonLabel => '恢复';

  @override
  String get trashPermanentDeleteButtonLabel => '永久删除';

  @override
  String get tagRenamedInfoMessage => '标签已重命名';

  @override
  String get tagDeletedInfoMessage => '标签已删除';

  @override
  String get tagOptionsRenameLabel => '重命名';

  @override
  String get tagOptionsDeleteLabel => '删除';

  @override
  String get renameTagDialogTitle => '重命名标签';

  @override
  String get renameTagDialogHint => '新标签名称';

  @override
  String get renameTagDialogCancelButton => '取消';

  @override
  String get renameTagDialogSaveButton => '保存';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '“$tag”将从 $affectedCount 条笔记中移除。是否继续？';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return '删除“$tag”标签？';
  }

  @override
  String get deleteTagDialogTitle => '删除标签';

  @override
  String get deleteTagDialogCancelButton => '取消';

  @override
  String get deleteTagDialogConfirmButton => '删除';

  @override
  String get tagsSheetTitle => '标签';

  @override
  String get tagsSheetEmptyMessage => '此笔记还没有标签。';

  @override
  String get tagsSheetInputHint => '输入新标签……';

  @override
  String get tagsSheetSuggestionsLabel => '已有标签';

  @override
  String get noteDeletedInfoMessage => '笔记已删除';

  @override
  String get noteDeletedUndoActionLabel => '撤销';

  @override
  String get reminderSetInfoMessage => '提醒已设置';

  @override
  String get reminderRemovedInfoMessage => '提醒已移除';

  @override
  String get noteDuplicatedInfoMessage => '已创建副本';

  @override
  String get speechTextAppendedInfoMessage => '文字已添加到笔记';

  @override
  String get pdfPreparingInfoMessage => '正在准备 PDF…';

  @override
  String get pdfSavedInfoMessage => 'PDF 已保存';

  @override
  String get jpgPreparingInfoMessage => '正在准备 JPG…';

  @override
  String get jpgSavedInfoMessage => 'JPG 已保存';

  @override
  String get jpgFailedInfoMessage => '无法创建 JPG';

  @override
  String get txtPreparingInfoMessage => '正在准备 TXT…';

  @override
  String get txtSavedInfoMessage => 'TXT 已保存';

  @override
  String get txtFailedInfoMessage => '无法创建 TXT';

  @override
  String get exportOpenActionLabel => '打开';

  @override
  String get wrongPasswordInfoMessage => '密码错误。';

  @override
  String get noteArchivedInfoMessage => '笔记已归档';

  @override
  String get noteUnarchivedInfoMessage => '已从归档中移除';

  @override
  String get noteUnlockedInfoMessage => '已解锁';

  @override
  String get noteLockedInfoMessage => '笔记已锁定';

  @override
  String get notificationUnpinnedInfoMessage => '已取消置顶';

  @override
  String get emptyNotePinBlockedInfoMessage => '空笔记无法置顶。';

  @override
  String get notificationPinnedInfoMessage => '已置顶到通知栏';

  @override
  String get noContentToReadInfoMessage => '没有可朗读的内容';

  @override
  String get backPressExitInfoMessage => '再次按返回键退出';

  @override
  String get reminderChannelName => '笔记提醒';

  @override
  String get reminderChannelDescription => 'Layout 应用中的笔记提醒';

  @override
  String get pinnedChannelName => '置顶笔记';

  @override
  String get pinnedChannelDescription => '置顶在通知栏中的 Layout 笔记';

  @override
  String get notificationUnpinActionLabel => '移除';

  @override
  String get reminderDefaultTitle => '提醒';

  @override
  String get reminderChecklistBodyFallback => '别忘了查看你的清单';

  @override
  String get reminderTextBodyFallback => '别忘了查看你的笔记';

  @override
  String get pdfSaveDialogTitle => '保存为 PDF';

  @override
  String get jpgSaveDialogTitle => '保存为 JPG';

  @override
  String get txtSaveDialogTitle => '保存为 TXT';

  @override
  String get textSizeSheetTitle => '文字大小';

  @override
  String get textSizeSamplePreview => '示例文字';

  @override
  String get textSizeCancelButton => '取消';

  @override
  String get textSizeApplyButton => '应用';

  @override
  String get createPasswordDialogTitle => '创建密码';

  @override
  String get createPasswordNewPasswordHint => '新密码';

  @override
  String get createPasswordConfirmHint => '再次输入密码';

  @override
  String get createPasswordHintQuestionDescription =>
      '设置一个安全问题，以便在忘记密码时使用（可选）。';

  @override
  String get createPasswordHintQuestionHint => '选择一个安全问题';

  @override
  String get createPasswordHintAnswerHint => '你的答案';

  @override
  String get createPasswordCancelButton => '取消';

  @override
  String get createPasswordSaveButton => '保存';

  @override
  String get passwordMismatchMessage => '两次输入的密码不一致！';

  @override
  String get passwordRequiredDialogTitle => '需要密码';

  @override
  String get passwordRequiredHint => '输入密码';

  @override
  String get forgotPasswordButtonLabel => '忘记密码';

  @override
  String get passwordRequiredCancelButton => '取消';

  @override
  String get passwordRequiredConfirmButton => '验证';

  @override
  String get securityQuestionDialogTitle => '安全问题';

  @override
  String get securityQuestionAnswerHint => '你的答案';

  @override
  String get securityQuestionCancelButton => '取消';

  @override
  String get securityQuestionConfirmButton => '确认';

  @override
  String get securityQuestionWrongAnswerMessage => '答案错误，请重试。';

  @override
  String get revealedPasswordDialogTitle => '你的密码';

  @override
  String get revealedPasswordLabel => '你的笔记密码：';

  @override
  String get revealedPasswordOkButton => '确定';

  @override
  String get securityQuestionPetName => '你第一只宠物的名字是什么？';

  @override
  String get securityQuestionFavoriteTeacher => '你最喜欢的老师叫什么名字？';

  @override
  String get securityQuestionBirthCity => '你出生在哪个城市？';

  @override
  String get securityQuestionFavoriteFood => '你最喜欢的食物是什么？';

  @override
  String get securityQuestionMotherMaidenName => '你母亲的娘家姓是什么？';

  @override
  String get securityQuestionFirstSchool => '你就读的第一所学校叫什么名字？';

  @override
  String get securityQuestionFavoriteColor => '你最喜欢的颜色是什么？';

  @override
  String get editFolderDialogTitle => '编辑文件夹';

  @override
  String get newSubfolderDialogTitle => '新建子文件夹';

  @override
  String get addFolderDialogTitle => '添加文件夹';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return '将在“$parentCategory”内创建';
  }

  @override
  String get subfolderNameFieldLabel => '子文件夹名称';

  @override
  String get folderNameFieldLabel => '文件夹名称';

  @override
  String get folderColorLabel => '颜色';

  @override
  String get folderDialogCancelButton => '取消';

  @override
  String get folderDialogSaveButton => '保存';

  @override
  String get folderDialogAddButton => '添加';

  @override
  String get selectFolderSheetTitle => '选择文件夹';

  @override
  String get selectFolderAddOptionLabel => '添加文件夹';

  @override
  String get removeCurrentFolderLabel => '移除当前文件夹';

  @override
  String get noteDetailsDialogTitle => '详情';

  @override
  String get noteDetailsCreatedLabel => '创建时间';

  @override
  String get noteDetailsModifiedLabel => '最后修改时间';

  @override
  String get noteDetailsCharCountLabel => '字符数';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count 个字符';
  }

  @override
  String get noteDetailsWordCountLabel => '字数';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count 个字';
  }

  @override
  String get noteDetailsOkButton => '确定';

  @override
  String get noteDetailsUnknownDateLabel => '未知';

  @override
  String get addAttachmentSheetTitle => '添加';

  @override
  String get addAttachmentImageOption => '添加图片';

  @override
  String get addAttachmentCameraOption => '相机';

  @override
  String get addAttachmentFileOption => '添加文件';

  @override
  String get addAttachmentVoiceOption => '语音录制';

  @override
  String get addAttachmentVideoOption => '录制视频';

  @override
  String get addAttachmentScanOption => '扫描文档';

  @override
  String get noteActionsSheetTitle => '选择操作';

  @override
  String get noteActionReminderLabel => '提醒';

  @override
  String get noteActionEditReminderLabel => '编辑提醒';

  @override
  String get noteActionSpeechToTextLabel => '语音转文字';

  @override
  String get noteActionArchiveLabel => '归档';

  @override
  String get noteActionUnarchiveLabel => '从归档中移除';

  @override
  String get noteActionLockLabel => '锁定';

  @override
  String get noteActionUnlockLabel => '解锁';

  @override
  String get noteActionFavoriteLabel => '收藏';

  @override
  String get noteActionUnfavoriteLabel => '取消收藏';

  @override
  String get noteActionClassifyLabel => '选择文件夹';

  @override
  String get noteActionDeleteLabel => '删除';

  @override
  String get noteActionPinToNotificationLabel => '置顶到通知栏';

  @override
  String get noteActionUnpinFromNotificationLabel => '取消置顶';

  @override
  String get noteActionShareLabel => '分享';

  @override
  String get noteActionDuplicateLabel => '创建副本';

  @override
  String get noteActionCopyContentLabel => '复制内容';

  @override
  String get noteActionTtsLabel => '朗读';

  @override
  String get noteActionTextSizeLabel => '文字大小';

  @override
  String get noteActionDetailsLabel => '详情';

  @override
  String get noteActionDiscardChangesLabel => '放弃更改';

  @override
  String get noteActionSelectLabel => '选择';

  @override
  String get reminderEditOptionLabel => '更改提醒';

  @override
  String get reminderRemoveOptionLabel => '移除提醒';

  @override
  String get discardChangesDialogTitle => '放弃更改';

  @override
  String get discardChangesDialogMessage => '此笔记的未保存更改将会丢失。确定要放弃吗？';

  @override
  String get discardChangesCancelButton => '取消';

  @override
  String get discardChangesConfirmButton => '放弃';

  @override
  String get pinnedNotificationDefaultTitle => '笔记';

  @override
  String get pdfFailedInfoMessage => '创建 PDF 失败';

  @override
  String get drawingScreenTitle => '绘图';

  @override
  String get drawingMinimizeTooltip => '最小化';

  @override
  String get drawingEmptyExportWarningMessage => '请先画点什么';

  @override
  String get drawingEraserPartialModeLabel => '部分擦除';

  @override
  String get drawingEraserFullModeLabel => '整体擦除';

  @override
  String get drawingClearTooltip => '清空';

  @override
  String get drawingZoomOutTooltip => '缩小';

  @override
  String get drawingZoomInTooltip => '放大';

  @override
  String get drawingDeleteTooltip => '删除';

  @override
  String get drawingEmptyPreviewHint => '点按以绘图';

  @override
  String get settingsPageTitle => '设置';

  @override
  String get settingsSectionGeneral => '通用';

  @override
  String get settingsSectionSecurity => '安全';

  @override
  String get settingsSectionTheme => '主题';

  @override
  String get settingsSectionPersonalization => '个性化';

  @override
  String get settingsSectionWidget => '小组件';

  @override
  String get settingsSectionAbout => '关于';

  @override
  String get settingsHintQuestionPet => '你第一只宠物的名字是什么？';

  @override
  String get settingsHintQuestionTeacher => '你最喜欢的老师叫什么名字？';

  @override
  String get settingsHintQuestionBirthCity => '你出生在哪个城市？';

  @override
  String get settingsHintQuestionFavoriteFood => '你最喜欢的食物是什么？';

  @override
  String get settingsHintQuestionMotherMaidenName => '你母亲的娘家姓是什么？';

  @override
  String get settingsHintQuestionFirstSchool => '你就读的第一所学校是什么？';

  @override
  String get settingsHintQuestionFavoriteColor => '你最喜欢的颜色是什么？';

  @override
  String get settingsSecurityQuestionDialogTitle => '安全问题';

  @override
  String get settingsSecurityQuestionDialogDesc => '如果你忘记了密码，可以通过正确回答此问题来找回。';

  @override
  String get settingsSecurityQuestionDropdownHint => '选择一个安全问题';

  @override
  String get settingsSecurityQuestionAnswerHint => '你的答案';

  @override
  String get settingsSecurityQuestionCancelButton => '取消';

  @override
  String get settingsSecurityQuestionEmptyWarning => '问题和答案不能为空！';

  @override
  String get settingsSecurityQuestionSaveButton => '保存';

  @override
  String get settingsCreatePasswordTitle => '创建密码';

  @override
  String get settingsPasswordRequiredTitle => '需要密码';

  @override
  String get settingsPasswordEnterHint => '输入密码';

  @override
  String get settingsForgotPasswordButton => '忘记密码';

  @override
  String get settingsNewPasswordHint => '新密码';

  @override
  String get settingsConfirmPasswordHint => '再次输入密码';

  @override
  String get settingsSecurityQuestionOptionalDesc => '设置一个安全问题，以便在忘记密码时使用（可选）。';

  @override
  String get settingsPasswordDialogCancelButton => '取消';

  @override
  String get settingsPasswordMismatchWarning => '两次输入的密码不一致！';

  @override
  String get settingsWrongPasswordWarning => '密码错误！';

  @override
  String get settingsPasswordSaveButton => '保存';

  @override
  String get settingsPasswordRemoveButton => '移除';

  @override
  String get settingsNotePasswordTitle => '笔记密码';

  @override
  String get settingsPasswordSetSubtitle => '密码已设置 ✓';

  @override
  String get settingsPasswordNotSetSubtitle => '未设置密码';

  @override
  String get settingsSecurityQuestionTileTitle => '安全问题';

  @override
  String get settingsSecurityQuestionSetSubtitle => '已设置 ✓ —— 用于忘记密码时找回';

  @override
  String get settingsSecurityQuestionNotSetSubtitle => '未设置 —— 密码丢失后将无法找回';

  @override
  String get settingsThemeDialogTitle => '选择主题';

  @override
  String get settingsThemeSystemDefault => '跟随系统';

  @override
  String get settingsThemeLightOption => '浅色主题';

  @override
  String get settingsThemeDarkOption => '深色主题';

  @override
  String get settingsLanguageDialogTitle => '选择语言';

  @override
  String get settingsLanguageSystemOption => '跟随系统';

  @override
  String get settingsAccentColorDialogTitle => '选择强调色';

  @override
  String get settingsThemeChangeTileTitle => '更改主题';

  @override
  String get settingsThemeLightLabel => '浅色';

  @override
  String get settingsThemeDarkLabel => '深色';

  @override
  String get settingsThemeSystemLabel => '跟随系统';

  @override
  String get settingsLanguageTileTitle => '语言';

  @override
  String get settingsAccentColorTileTitle => '强调色';

  @override
  String get settingsAccentColorTileSubtitle => '用于应用栏、按钮和开关的颜色';

  @override
  String get settingsColorfulNotesTitle => '笔记多彩配色';

  @override
  String get settingsColorfulNotesSubtitle => '每张笔记卡片会显示不同的颜色。';

  @override
  String get settingsTextColorSheetTitle => '文字颜色';

  @override
  String get settingsTextColorSheetDesc => '设置笔记内容文字的颜色。';

  @override
  String get settingsTextColorOkButton => '确定';

  @override
  String get settingsTextColorTileTitle => '文字颜色';

  @override
  String get settingsTextColorTileSubtitle => '笔记内容文字的颜色。';

  @override
  String get settingsWidgetFontSizeLabel => '小组件字号';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return '示例标题 - $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => '取消';

  @override
  String get settingsWidgetFontSizeApplyButton => '应用';

  @override
  String get settingsWidgetOpacityLabel => '背景透明度';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return '透明度 $percent%';
  }

  @override
  String get settingsWidgetOpacityCancelButton => '取消';

  @override
  String get settingsWidgetOpacityApplyButton => '应用';

  @override
  String get settingsWidgetDarkModeTitle => '深色小组件';

  @override
  String get settingsWidgetDarkModeDesc => '小组件使用深色配色方案。';

  @override
  String get settingsAboutVersionTitle => '应用版本';

  @override
  String get settingsFontFamilyTileTitle => '字体';

  @override
  String get settingsFontFamilyDefaultLabel => '默认';

  @override
  String get settingsGlobalFontSizeTileTitle => '字号';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt —— 应用于所有笔记。';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return '示例文字 - $size pt';
  }

  @override
  String get settingsGlobalFontSizeApplyToAllLabel => '应用到现有笔记';

  @override
  String get settingsGlobalFontSizeApplyToAllNote => '如果某条笔记已单独设置字号，此设置将不会影响它。';

  @override
  String get settingsGlobalFontSizeCancelButton => '取消';

  @override
  String get settingsGlobalFontSizeApplyButton => '应用';

  @override
  String get settingsPreviewLinesTileTitle => '笔记预览行数';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return '最多显示 $lines 行。如果笔记更短，则显示实际行数。';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return '当前：$lines 行';
  }

  @override
  String get settingsPreviewLinesDescription => '设置预览的最大行数。如果笔记的行数更少，则显示实际行数。';

  @override
  String get settingsPreviewLinesCancelButton => '取消';

  @override
  String get settingsPreviewLinesApplyButton => '应用';

  @override
  String get backupCancelButton => '取消';

  @override
  String get backupConnectButton => '连接';

  @override
  String get backupDisconnectButton => '断开连接';

  @override
  String get backupContinueButton => '继续';

  @override
  String get backupCloseButton => '关闭';

  @override
  String get backupShareButton => '分享';

  @override
  String get backupRestoreButton => '恢复';

  @override
  String get backupConfigureButton => '配置';

  @override
  String get backupUnknownDateLabel => '未知';

  @override
  String get backupProcessingDefaultLabel => '处理中……';

  @override
  String get backupPermissionRequiredTitle => '需要存储权限';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      '此 Android 版本需要存储权限才能进行备份/恢复。由于权限被永久拒绝，请在应用设置中手动开启。';

  @override
  String get backupPermissionRequiredBodyNormal =>
      '此 Android 版本需要存储权限才能进行备份/恢复。请授予权限以继续。';

  @override
  String get backupGoToSettingsButton => '前往设置';

  @override
  String get backupRetryButton => '重试';

  @override
  String get backupDriveConnectingLabel => '正在连接 Google 账号……';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return '已连接到 Google Drive 账号：$email';
  }

  @override
  String get backupDriveConnectedMessage => '已连接到 Google Drive 账号。';

  @override
  String get backupDriveConnectFailedMessage => '无法连接到 Google 账号，或操作已取消。';

  @override
  String get backupDriveDisconnectTitle => '断开 Google Drive 连接';

  @override
  String get backupDriveDisconnectBody =>
      '断开连接后，将无法手动或自动备份到 Drive。已存储在 Drive 上的备份不会被删除，只会移除本设备的访问权限。';

  @override
  String get backupDriveDisconnectedMessage => '已移除 Google Drive 连接。';

  @override
  String get backupDriveRequiredTitle => '需要 Google 账号';

  @override
  String get backupDriveRequiredBody => '此操作需要连接你的 Google 账号。是否立即连接？';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive：已连接（$email）';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive：已连接';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive：未连接';

  @override
  String get backupDriveAuthenticatingLabel => '正在验证 Google 账号……';

  @override
  String get backupDriveNotSignedInMessage =>
      '你尚未连接 Google Drive。请先使用你的 Google 账号登录。';

  @override
  String get backupDriveUploadingLabel => '正在上传备份到 Drive……';

  @override
  String get backupDriveUploadTimeoutMessage =>
      '上传到 Google Drive 未能在 120 秒内完成（服务器无响应）。请检查你的网络连接后重试。';

  @override
  String get backupDriveOperationCompletedLabel => '已完成';

  @override
  String get backupToDriveActionLabel => '备份到 Drive';

  @override
  String get backupToDeviceActionLabel => '备份';

  @override
  String get backupCreatingLabel => '正在创建备份……';

  @override
  String backupCreateFailedMessage(String error) {
    return '无法创建备份：$error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return '上传到 Google Drive 失败：$error';
  }

  @override
  String get backupDriveUploadSuccessMessage => '备份已成功上传到 Google Drive。';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return '备份已创建：$fileName（$size）';
  }

  @override
  String get backupOfferShareTitle => '备份已就绪';

  @override
  String get backupOfferShareBody => '备份文件已保存到你的设备。是否现在分享（例如云存储、邮件或其他设备）？';

  @override
  String get backupShareFileText => 'layout 备份文件';

  @override
  String backupShareFailedMessage(String error) {
    return '无法开始分享：$error';
  }

  @override
  String get backupLargeOperationTitle => '大型备份';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return '待处理的数据约为 $sizeText。根据设备性能，此规模的$actionLabel可能需要一些时间。请在操作进行时不要离开应用——是否继续？';
  }

  @override
  String get backupRestoreActionLabel => '恢复';

  @override
  String get backupDriveListingLabel => '正在列出 Drive 上的备份……';

  @override
  String backupDriveListFailedMessage(String error) {
    return '无法列出备份：$error';
  }

  @override
  String get backupDriveNoBackupsMessage => 'Google Drive 上还没有备份。';

  @override
  String get backupDrivePickTitle => '从 Drive 选择一个备份';

  @override
  String get backupDriveDownloadingLabel => '正在从 Drive 下载备份……';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return '正在从 Drive 下载备份……（$downloaded / $total）';
  }

  @override
  String get backupDriveSavingToDeviceLabel => '正在将文件保存到设备……';

  @override
  String get backupDriveUnknownBackupFileName => 'unknown_backup.zip';

  @override
  String get backupDriveStorageFullMessage =>
      '你的 Google Drive 存储空间已满。请清理 Drive 空间后重试。';

  @override
  String get backupDriveNetworkErrorMessage => '无法建立网络连接。请检查你的连接后重试。';

  @override
  String get backupDriveBackupNotFoundMessage => '在 Drive 上找不到指定的备份文件，它可能已被删除。';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Google Drive 操作过程中发生意外错误：$error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return '下载失败：$error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return '无法选择文件：$error';
  }

  @override
  String get backupPickedFileUnreachableMessage => '无法访问所选文件。';

  @override
  String get backupCheckingLabel => '正在检查备份……';

  @override
  String backupReadFailedMessage(String error) {
    return '无法读取备份文件：$error';
  }

  @override
  String get backupRestoreConfirmTitle => '恢复备份';

  @override
  String get backupPreviewContentsHeader => '所选备份的内容：';

  @override
  String get backupPreviewNoteCountLabel => '笔记数量';

  @override
  String get backupPreviewTrashCountLabel => '回收站中的笔记';

  @override
  String get backupPreviewCategoryCountLabel => '分类数量';

  @override
  String get backupPreviewAttachmentLabel => '附件';

  @override
  String get backupPreviewAttachmentNoneValue => '无';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count 个文件（$size）';
  }

  @override
  String get backupPreviewCreatedAtLabel => '创建于';

  @override
  String get backupEmptyPreviewTitle => '此备份似乎是空的';

  @override
  String get backupEmptyPreviewBody =>
      '在所选文件中未找到任何笔记、分类或附件。如果继续，你当前的数据仍将被删除并替换为此空备份。';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '备份中未找到 $count 个附件';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return '包含这些文件的笔记将被恢复，但不含附件（这些附件在备份时可能已丢失或损坏）：$names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown 以及另外 $remaining 个';
  }

  @override
  String get backupRestoreConfirmBody =>
      '此操作将用上方备份中的数据替换你当前的所有笔记、回收站、分类、设置和附件。你当前的数据将被永久丢失，且此操作无法撤销。';

  @override
  String get backupRestoringLabel => '正在恢复备份……';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return '备份已恢复。不过，有 $count 个附件在备份中未找到，无法恢复。建议重启应用以使更改完全生效。';
  }

  @override
  String get backupRestoreSuccessMessage => '备份已成功恢复。建议重启应用以使更改完全生效。';

  @override
  String backupRestoreFailedMessage(String error) {
    return '恢复时发生错误：$error';
  }

  @override
  String get backupScreenTitle => '备份与恢复';

  @override
  String get backupBlockedExitWarningMessage => '操作正在进行中，请等待其完成。';

  @override
  String get backupBusyBackTooltip => '操作进行中';

  @override
  String get backupIntroText => '你可以将笔记、分类、设置和附件备份为一个 .zip 文件，也可以恢复之前创建的备份。';

  @override
  String get backupDriveCardTitle => '备份到 Google Drive';

  @override
  String get backupDriveCardSubtitle => '创建新备份，并直接上传到你的 Google Drive 私密区域。';

  @override
  String get backupDriveCardButtonLabel => '备份到 Drive';

  @override
  String get backupDeviceCardTitle => '备份到设备';

  @override
  String get backupDeviceCardSubtitle => '将所有数据保存为一个 .zip 文件到你的设备，并可随时分享。';

  @override
  String get backupDeviceCardButtonLabel => '备份到设备';

  @override
  String get backupHistoryCardTitle => '备份历史';

  @override
  String get backupHistoryCardSubtitle =>
      '查看设备上存储的所有备份及其日期和大小；你可以直接在此分享、恢复或删除它们。';

  @override
  String get backupHistoryTabDevice => '设备';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => '删除备份';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return '确定要永久删除备份文件“$fileName”吗？此操作无法撤销。';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => '备份已删除。';

  @override
  String get backupHistoryDriveDeleteDialogTitle => '删除 Drive 备份';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return '确定要从 Google Drive 永久删除备份“$fileName”吗？此操作无法撤销，且文件不会被移到回收站。';
  }

  @override
  String get backupHistoryDriveDeletedMessage => 'Drive 备份已删除。';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return '无法删除：$error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle => '此设备上尚未保存任何备份。';

  @override
  String get backupHistoryDeviceEmptySubtitle => '使用“备份到设备”创建你的第一个备份。';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      '使用“备份到 Google Drive”创建你的第一个云备份。';

  @override
  String get backupHistoryDriveSignInPrompt => '连接你的 Google 账号以查看 Drive 备份。';

  @override
  String get backupHistoryConnectGoogleButton => '使用 Google 连接';

  @override
  String get backupHistoryDriveConnectedFallback => '已连接';

  @override
  String get backupHistoryUnknownErrorFallback => '发生了未知错误。';

  @override
  String get backupHistoryDownloadStartingLabel => '正在开始……';

  @override
  String get backupAutoBackupEnabledLabel => '自动备份：开启';

  @override
  String get backupAutoBackupDisabledLabel => '自动备份：关闭';

  @override
  String get backupOverlayWarningMessage => '请稍候，操作完成前请勿离开应用。';

  @override
  String get pdfExportUntitledNoteLabel => '无标题笔记';

  @override
  String get pdfExportDefaultAttachmentName => '附件';

  @override
  String get pdfExportDefaultFileName => 'note';

  @override
  String get screenshotExportBoundaryNotFoundMessage => '无法截图（未找到边界）';

  @override
  String get screenshotExportByteDataNullMessage => '无法生成截图数据';

  @override
  String get screenshotExportPngDecodeFailedMessage => '无法处理图像（PNG 解码失败）';

  @override
  String get screenshotCalcTableTotalLabel => '合计';

  @override
  String get gundemMenuRemoveFromAgenda => '从日程中移除';

  @override
  String get gundemMenuDeleteNote => '删除笔记';

  @override
  String get gundemSectionOverdue => '已逾期';

  @override
  String get gundemSectionToday => '今天';

  @override
  String get gundemSectionTomorrow => '明天';

  @override
  String get gundemSectionNextWeek => '下周';

  @override
  String get gundemSectionFurther => '更远的未来';

  @override
  String get gundemWeekdayMonday => '星期一';

  @override
  String get gundemWeekdayTuesday => '星期二';

  @override
  String get gundemWeekdayWednesday => '星期三';

  @override
  String get gundemWeekdayThursday => '星期四';

  @override
  String get gundemWeekdayFriday => '星期五';

  @override
  String get gundemWeekdaySaturday => '星期六';

  @override
  String get gundemWeekdaySunday => '星期日';

  @override
  String get gundemAppBarTitle => '日程';

  @override
  String get gundemCalendarTooltip => '日历';

  @override
  String get gundemEmptyTitle => '日程中没有内容';

  @override
  String get gundemEmptySubtitle => '带有提醒或指定日期的笔记会显示在这里。';

  @override
  String get gundemUntitledNote => '无标题笔记';

  @override
  String get gundemRepeatHourly => '每小时';

  @override
  String get gundemRepeatDaily => '每天';

  @override
  String get gundemRepeatWeekly => '每周';

  @override
  String get gundemRepeatMonthly => '每月';

  @override
  String get gundemRepeatYearly => '每年';

  @override
  String get gundemPreviewCalcTableLabel => '[计算列表]';

  @override
  String get gundemPreviewDrawingLabel => '[绘图]';

  @override
  String get gundemPreviewImageLabel => '[图片]';

  @override
  String get gundemMonthShortJan => '1月';

  @override
  String get gundemMonthShortFeb => '2月';

  @override
  String get gundemMonthShortMar => '3月';

  @override
  String get gundemMonthShortApr => '4月';

  @override
  String get gundemMonthShortMay => '5月';

  @override
  String get gundemMonthShortJun => '6月';

  @override
  String get gundemMonthShortJul => '7月';

  @override
  String get gundemMonthShortAug => '8月';

  @override
  String get gundemMonthShortSep => '9月';

  @override
  String get gundemMonthShortOct => '10月';

  @override
  String get gundemMonthShortNov => '11月';

  @override
  String get gundemMonthShortDec => '12月';

  @override
  String get calendarAppBarTitle => '日历';

  @override
  String get calendarTodayButton => '今天';

  @override
  String get calendarLegendNoteLabel => '笔记';

  @override
  String get calendarLegendReminderLabel => '提醒';

  @override
  String get calendarTodayBadge => '今天';

  @override
  String get calendarEmptyDayMessage => '这一天没有笔记或提醒。';

  @override
  String get calendarReminderHourlyLabel => '每小时';

  @override
  String get calendarMonthJan => '一月';

  @override
  String get calendarMonthFeb => '二月';

  @override
  String get calendarMonthMar => '三月';

  @override
  String get calendarMonthApr => '四月';

  @override
  String get calendarMonthMay => '五月';

  @override
  String get calendarMonthJun => '六月';

  @override
  String get calendarMonthJul => '七月';

  @override
  String get calendarMonthAug => '八月';

  @override
  String get calendarMonthSep => '九月';

  @override
  String get calendarMonthOct => '十月';

  @override
  String get calendarMonthNov => '十一月';

  @override
  String get calendarMonthDec => '十二月';

  @override
  String get calendarWeekdayShortMon => '一';

  @override
  String get calendarWeekdayShortTue => '二';

  @override
  String get calendarWeekdayShortWed => '三';

  @override
  String get calendarWeekdayShortThu => '四';

  @override
  String get calendarWeekdayShortFri => '五';

  @override
  String get calendarWeekdayShortSat => '六';

  @override
  String get calendarWeekdayShortSun => '日';

  @override
  String get calendarWeekdayFullMonday => '星期一';

  @override
  String get calendarWeekdayFullTuesday => '星期二';

  @override
  String get calendarWeekdayFullWednesday => '星期三';

  @override
  String get calendarWeekdayFullThursday => '星期四';

  @override
  String get calendarWeekdayFullFriday => '星期五';

  @override
  String get calendarWeekdayFullSaturday => '星期六';

  @override
  String get calendarWeekdayFullSunday => '星期日';

  @override
  String get wrongPasswordDialogTitle => '密码错误';

  @override
  String get wrongPasswordDialogMessage => '你输入的密码不正确。';

  @override
  String get commonOkButton => '确定';

  @override
  String get unlockCategoryAction => '解锁';

  @override
  String get lockCategoryAction => '锁定';

  @override
  String get categoryUnlockedMessage => '已解锁';

  @override
  String get categoryLockedMessage => '文件夹已锁定';

  @override
  String get deleteFolderMenuItemLabel => '删除文件夹';

  @override
  String get deleteFolderDialogTitle => '删除文件夹';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return '确定要删除文件夹“$category”及其所有子文件夹吗？这些文件夹中的笔记将变为未分类。';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return '确定要删除文件夹“$category”吗？此文件夹中的笔记将变为未分类。';
  }

  @override
  String get deleteFolderDialogCancelButton => '取消';

  @override
  String get deleteFolderDialogConfirmButton => '删除';

  @override
  String get editCategoryNameColorMenuItemLabel => '编辑名称/颜色';

  @override
  String get addSubfolderMenuItemLabel => '创建子文件夹';

  @override
  String get expandSubfoldersMenuItemLabel => '展开子文件夹';

  @override
  String get collapseSubfoldersMenuItemLabel => '收起子文件夹';

  @override
  String saveErrorInfoMessage(String error) {
    return '保存出错：$error';
  }

  @override
  String get welcomeNoteTitle => '欢迎使用 DNote！🚀';

  @override
  String get welcomeNoteContent => '新增了一些功能！';

  @override
  String get noteListDateGroupToday => '今天';

  @override
  String get noteListDateGroupYesterday => '昨天';

  @override
  String get noteListDateGroupLast7Days => '最近 7 天';

  @override
  String get noteListDateGroupLast30Days => '最近 30 天';

  @override
  String get reminderRepeatNoneLabel => '不重复';

  @override
  String get voiceRecorderPreparingLabel => '正在准备……';

  @override
  String get voiceRecorderCancelButton => '取消';

  @override
  String get voiceRecorderStopAddButton => '停止并添加';

  @override
  String get speechToTextMicPermissionDeniedMessage => '未获得麦克风权限。';

  @override
  String get speechToTextUnavailableMessage => '此设备不支持语音识别。';

  @override
  String get speechToTextPreparingLabel => '正在准备……';

  @override
  String get speechToTextListeningLabel => '正在聆听……';

  @override
  String get speechToTextStartSpeakingPlaceholder => '开始说话……';

  @override
  String get speechToTextCancelButton => '取消';

  @override
  String get speechToTextStopAddButton => '停止并添加';

  @override
  String get textToSpeechNoContentMessage => '没有可朗读的内容。';

  @override
  String get textToSpeechReadErrorMessage => '朗读时发生错误。';

  @override
  String get textToSpeechUnavailableMessage => '此设备不支持文字转语音。';

  @override
  String get textToSpeechPreparingLabel => '正在准备……';

  @override
  String get textToSpeechPausedLabel => '已暂停';

  @override
  String get textToSpeechFinishedLabel => '朗读完成';

  @override
  String get textToSpeechReadingLabel => '正在朗读……';

  @override
  String get textToSpeechCloseErrorButton => '关闭';

  @override
  String get textToSpeechReplayButton => '重新朗读';

  @override
  String get textToSpeechCloseFinishedButton => '关闭';

  @override
  String get textToSpeechPauseButton => '暂停';

  @override
  String get textToSpeechResumeButton => '继续';

  @override
  String get textToSpeechStopButton => '停止';

  @override
  String get textToSpeechSpeedSlow => '慢速';

  @override
  String get textToSpeechSpeedNormal => '正常';

  @override
  String get textToSpeechSpeedFast => '快速';

  @override
  String get calendarPickerCancelButton => '取消';

  @override
  String get calendarPickerConfirmButton => '选择';

  @override
  String get calendarPickerClearButton => '清除';

  @override
  String get reminderPickerDialogTitle => '添加提醒';

  @override
  String get reminderPickerDateTodayOption => '今天';

  @override
  String get reminderPickerDateTomorrowOption => '明天';

  @override
  String get reminderPickerDatePickOption => '选择日期';

  @override
  String get reminderRepeatHourlyLabel => '每小时';

  @override
  String get reminderRepeatDailyLabel => '每天';

  @override
  String get reminderRepeatWeeklyLabel => '每周';

  @override
  String get reminderRepeatMonthlyLabel => '每月';

  @override
  String get reminderRepeatYearlyLabel => '每年';

  @override
  String get reminderPickerCalendarHelpText => '选择提醒日期';

  @override
  String get reminderPickerCancelButton => '取消';

  @override
  String get reminderPickerSaveButton => '保存';

  @override
  String get reminderPickerPastTimeErrorMessage => '无法选择过去的时间';

  @override
  String calcTableTotalLabel(String amount) {
    return '合计：$amount';
  }

  @override
  String get backupCreatePreparingDataLabel => '正在准备数据……';

  @override
  String get backupCreatePackagingNotesLabel => '正在打包笔记和分类……';

  @override
  String get backupCreateReadingAttachmentsLabel => '正在读取附件……';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return '正在读取附件……（$current/$total）';
  }

  @override
  String get backupCreateCompressingLabel => '正在压缩 zip 文件……';

  @override
  String get backupCreateSavingFileLabel => '正在保存文件……';

  @override
  String get backupRestoreValidatingLabel => '正在验证备份……';

  @override
  String get backupRestoreValidatedPreparingDataLabel => '备份已验证，正在准备数据……';

  @override
  String get backupRestoreWritingNotesLabel => '正在写入笔记……';

  @override
  String get backupRestoreWritingTrashLabel => '正在写入回收站……';

  @override
  String get backupRestoreTrashWrittenLabel => '回收站已写入';

  @override
  String get backupRestoreWritingCategoriesLabel => '正在写入分类……';

  @override
  String get backupRestoreCategoriesWrittenLabel => '分类已写入';

  @override
  String get backupRestoreWritingSettingsLabel => '正在写入设置……';

  @override
  String get backupRestoreSettingsWrittenLabel => '设置已写入';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel => '正在清理旧附件……';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel => '未找到附件，正在完成……';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return '正在恢复附件……（$current/$total）';
  }

  @override
  String get backupRestoreCompletedLabel => '已完成';

  @override
  String get backupValidationCorruptedFileMessage => '该文件已损坏或不是有效的备份文件。';

  @override
  String get backupValidationMissingDataMessage =>
      '备份文件内未找到数据（缺少 backup_data.json）。';

  @override
  String get backupValidationInvalidJsonMessage => '无法读取备份数据（JSON 已损坏）。';

  @override
  String get backupValidationNotDnoteBackupMessage => '该文件不是来自 dnote 应用的备份。';

  @override
  String get backupValidationVersionUnreadableMessage => '无法读取备份文件的版本信息。';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      '此备份的格式较新，当前应用版本不支持。请更新应用。';

  @override
  String get backupValidationInvalidVersionMessage => '备份文件的版本信息无效。';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      '备份数据格式不符合预期（缺少 notes 字段）。';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      '备份数据格式不符合预期（缺少 trash 字段）。';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      '备份数据格式不符合预期（分类列表无效）。';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      '备份数据格式不符合预期（settings 字段无效）。';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      '备份数据格式不符合预期（存在无效的笔记记录）。';

  @override
  String get backupValidationMissingNoteIdMessage =>
      '备份数据格式不符合预期（存在没有 ID 的笔记记录）。';

  @override
  String get backupValidationFileNotFoundMessage => '未找到备份文件。';

  @override
  String get backupErrorInsufficientStorageMessage => '设备可用存储空间不足。请清理空间后重试。';

  @override
  String get backupErrorPermissionDeniedMessage => '文件访问权限被拒绝。请检查应用权限后重试。';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return '文件操作过程中发生错误：$detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return '发生了意外错误：$detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      '无法创建 zip 压缩包（ZipEncoder 返回了 null）。';

  @override
  String get calcTableMenuItemLabel => '计算列表';

  @override
  String get tagsMenuItemLabel => '标签';

  @override
  String get linkDialogUrlHint => 'https://example.com';

  @override
  String get checklistItemHint => '添加项目……';

  @override
  String get toolbarHighlightTooltip => '高亮';

  @override
  String get toolbarListTooltip => '列表';

  @override
  String get toolbarHideKeyboardTooltip => '隐藏键盘';

  @override
  String get autoBackupLocalSuccessMessage => '本地备份成功。';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return '本地备份失败：$detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      '已跳过 Drive 备份：Google 账号未连接或会话已过期。请打开应用重新连接。';

  @override
  String get autoBackupDriveSuccessMessage => 'Drive 备份成功。';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Drive 备份失败：$detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => '还没有笔记';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return '共计：$total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ 绘图';

  @override
  String get autoBackupSettingsAppBarTitle => '自动备份设置';

  @override
  String get autoBackupSettingsMainSwitchTitle => '启用自动备份';

  @override
  String get autoBackupSettingsMainSwitchSubtitle => '你的笔记会在后台定期安全备份。';

  @override
  String get autoBackupSettingsTargetTitle => '备份目标';

  @override
  String get autoBackupSettingsTargetSubtitle => '选择备份的保存位置。';

  @override
  String get autoBackupSettingsTargetLocalOption => '本地';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => '两者都要';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      '请先连接你的账号以使用 Google Drive 选项。';

  @override
  String get autoBackupSettingsConnectButton => '连接';

  @override
  String get autoBackupSettingsFrequencyTitle => '备份频率';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return '每 $hours 小时进行一次备份。';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 小时';

  @override
  String get autoBackupSettingsFrequency12h => '12 小时';

  @override
  String get autoBackupSettingsFrequency24h => '24 小时（每天）';

  @override
  String get autoBackupSettingsFrequency48h => '48 小时（2 天）';

  @override
  String get autoBackupSettingsFrequency168h => '168 小时（每周）';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => '仅使用 Wi-Fi';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      '仅在 Wi-Fi 下进行云端上传，以节省你的移动数据流量。';

  @override
  String get autoBackupSettingsStatusCardTitle => '系统状态';

  @override
  String get autoBackupSettingsNeverRunMessage => '自动备份尚未运行过。';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return '上次运行：$date $time（$status）\n消息：$message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => '成功';

  @override
  String get autoBackupSettingsStatusFailedLabel => '失败';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar => '无法连接到 Google 账号。';

  @override
  String get autoBackupSettingsSavedSnackbar => '自动备份设置已更新。';

  @override
  String selectionModeDeletedMessage(int count) {
    return '已删除 $count 条笔记';
  }

  @override
  String get selectionModeArchivedMessage => '已归档';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return '为 $count 条笔记选择分类';
  }

  @override
  String get selectionModeAddCategoryOption => '添加分类';

  @override
  String get selectionModeRemoveCategoryOption => '移除分类';

  @override
  String get calcTableItemHint => '项目……';

  @override
  String get calcTableTotalRowLabel => '合计';

  @override
  String get textSelectionMenuShareButton => '分享';

  @override
  String get textSelectionMenuTranslateButton => '翻译';

  @override
  String get textSelectionMenuShareFailedSnackbar => '无法开始分享。';

  @override
  String get textSelectionMenuTranslateFailedSnackbar => '无法打开翻译。';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return '今天 $time';
  }

  @override
  String lastBackupInfoDateFormat(
    String day,
    String month,
    int year,
    String time,
  ) {
    return '$year/$month/$day $time';
  }

  @override
  String lastBackupInfoLabel(String date) {
    return '上次备份：$date';
  }

  @override
  String get lastBackupInfoNoBackupMessage => '尚未进行过备份。';

  @override
  String get backupFileNameLabel => '备份';
}
