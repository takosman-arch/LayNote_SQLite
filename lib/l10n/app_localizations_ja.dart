// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get toolbarBoldTooltip => '太字';

  @override
  String get toolbarItalicTooltip => '斜体';

  @override
  String get toolbarUnderlineTooltip => '下線';

  @override
  String get toolbarStrikethroughTooltip => '取り消し線';

  @override
  String get toolbarFontSizeTooltip => '文字サイズ';

  @override
  String get toolbarColorTooltip => '文字色';

  @override
  String get toolbarBulletTooltip => '箇条書きリスト';

  @override
  String get toolbarNumberTooltip => '番号付きリスト';

  @override
  String get toolbarIndentTooltip => '段落インデント';

  @override
  String get toolbarLinkTooltip => 'リンクの追加・編集・削除';

  @override
  String get toolbarDividerTooltip => '区切り線を挿入';

  @override
  String get toolbarChecklistTooltip => 'チェックリストを追加';

  @override
  String get linkSelectTextSnackbar => 'まずリンクにしたいテキストを選択してください';

  @override
  String get linkDialogEditTitle => 'リンクを編集';

  @override
  String get linkDialogAddTitle => 'リンクを追加';

  @override
  String get linkDialogRemoveButton => 'リンクを削除';

  @override
  String get linkDialogCancelButton => 'キャンセル';

  @override
  String get linkDialogConfirmButton => '追加';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'カメラの権限が拒否されています。動画を録画するには設定から許可してください。';

  @override
  String get cameraPermissionRequiredMessage => '動画を録画するにはカメラの権限が必要です。';

  @override
  String get openSettingsButtonLabel => '設定';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'スキャンを開始できませんでした: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return '文字認識に失敗しました: $error';
  }

  @override
  String get ocrNoReadableTextMessage => '文書内に読み取れるテキストが見つかりませんでした';

  @override
  String get scanResultSheetTitle => 'スキャンした文書をどのように追加しますか？';

  @override
  String get scanResultTextOnlyOption => 'テキストのみ追加';

  @override
  String get scanResultTextAndImageOption => 'テキスト＋スキャン画像を追加';

  @override
  String get scanResultCancelOption => 'キャンセル';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'マイクの権限が拒否されています。音声を録音するには設定から許可してください。';

  @override
  String get audioPermissionRequiredMessage => '音声を録音するにはマイクの権限が必要です。';

  @override
  String get voiceRecordingDefaultLabel => 'ボイスレコーディング';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return '計算リスト（$count行）';
  }

  @override
  String blockPreviewTableLabel(int count) {
    return 'テーブル（$count行）';
  }

  @override
  String get blockPreviewDrawingLabel => '図形描画';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '添付ファイル$count件（写真・文書）';
  }

  @override
  String get blockPreviewDividerLabel => '区切り線';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'チェックリスト（$count項目）';
  }

  @override
  String get blockPreviewEmptyTextLabel => '（テキストなし）';

  @override
  String get reorderBlocksSheetTitle => 'ブロックの並べ替え';

  @override
  String get reorderBlocksMoveUpTooltip => '上に移動';

  @override
  String get reorderBlocksMoveDownTooltip => '下に移動';

  @override
  String get reorderBlocksCloseTooltip => '閉じる';

  @override
  String get reorderBlocksDescription => 'ブロックをタップして選択し、上下の矢印で移動してください。';

  @override
  String get reorderBlocksMenuItemLabel => '並べ替え';

  @override
  String get txtImportPickerDialogTitle => 'インポートするTXTファイルを選択';

  @override
  String get txtImportReadFailedMessage => 'TXTファイルを読み込めませんでした';

  @override
  String get txtImportEmptyFileMessage => 'TXTファイルが空です';

  @override
  String get txtImportSuccessMessage => 'TXTをインポートしました';

  @override
  String get txtImportMenuItemLabel => 'インポート（txt）';

  @override
  String get exportMenuItemLabel => 'エクスポート';

  @override
  String get editorUndoTooltip => '元に戻す';

  @override
  String get editorRedoTooltip => 'やり直す';

  @override
  String get noteSavedMessage => 'メモを保存しました';

  @override
  String get dateAssignPickerHelpText => 'メモを日付に割り当て';

  @override
  String get dateAssignChangeOption => '日付を変更';

  @override
  String get dateAssignRemoveOption => '割り当てを解除';

  @override
  String get editorSubToolbarCloseTooltip => '閉じる';

  @override
  String get titleFieldHint => 'タイトル';

  @override
  String get textBlockHint => 'ここにメモを入力してください...';

  @override
  String get drawingBoardMenuItemLabel => 'お絵描きボード';

  @override
  String get voiceToTextTextNotesOnlyMessage => '音声入力はテキストメモでのみ利用できます';

  @override
  String get selectionModeCancelTooltip => '選択を解除';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return '$count件選択中';
  }

  @override
  String get selectionModeDeleteTooltip => '削除';

  @override
  String get selectionModeArchiveTooltip => 'アーカイブ';

  @override
  String get selectionModeFolderTooltip => 'フォルダ';

  @override
  String get searchFieldHint => 'メモを検索...';

  @override
  String get emptyTrashDialogTitle => 'ゴミ箱を空にする';

  @override
  String get emptyTrashDialogConfirmMessage => '削除したメモはすべて完全に削除されます。よろしいですか？';

  @override
  String get emptyTrashDialogCancelButton => 'キャンセル';

  @override
  String get restoreAllMenuItemLabel => 'すべて復元';

  @override
  String get sortMenuTooltip => 'メモを並べ替え';

  @override
  String get sortMenuAscendingLabel => '順序：昇順（A-Z）';

  @override
  String get sortMenuDescendingLabel => '順序：降順（Z-A）';

  @override
  String get sortMenuByTitleLabel => '並べ替え：タイトル';

  @override
  String get sortMenuByModifiedDateLabel => '並べ替え：更新日時';

  @override
  String get sortMenuByCreatedDateLabel => '並べ替え：作成日';

  @override
  String get sortMenuByFolderLabel => '並べ替え：フォルダ';

  @override
  String get viewToggleGridTooltip => 'グリッド表示';

  @override
  String get viewToggleListTooltip => 'リスト表示';

  @override
  String get drawerHeaderSubtitle => 'あなた専用のノート';

  @override
  String get drawerNotesSectionHeader => 'メモ';

  @override
  String get drawerAllNotesLabel => 'メモ';

  @override
  String get drawerFavoritesLabel => 'お気に入り';

  @override
  String get drawerAgendaLabel => '予定';

  @override
  String get drawerRemindersLabel => 'リマインダー';

  @override
  String get drawerLockedLabel => 'ロック済み';

  @override
  String get drawerTrashLabel => 'ゴミ箱';

  @override
  String get drawerFoldersSectionHeader => 'フォルダ';

  @override
  String get drawerExpandLabel => '展開';

  @override
  String get drawerCollapseLabel => '折りたたむ';

  @override
  String get drawerAddFolderLabel => 'フォルダを追加';

  @override
  String get drawerAppSectionHeader => 'アプリ';

  @override
  String get drawerCalendarLabel => 'カレンダー';

  @override
  String get drawerSettingsLabel => '設定';

  @override
  String get drawerBackupRestoreLabel => 'バックアップと復元';

  @override
  String get drawerUpgradeToProLabel => 'Proにアップグレード';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => '開発を応援する';

  @override
  String get drawerFeedbackLabel => 'フィードバック';

  @override
  String get drawerRateAppLabel => 'アプリを評価する';

  @override
  String get drawerAboutLabel => 'アプリについて';

  @override
  String get noNotesFoundMessage => 'メモが見つかりません。';

  @override
  String get trashRestoreButtonLabel => '復元';

  @override
  String get trashPermanentDeleteButtonLabel => '完全に削除';

  @override
  String get tagRenamedInfoMessage => 'タグ名を変更しました';

  @override
  String get tagDeletedInfoMessage => 'タグを削除しました';

  @override
  String get tagOptionsRenameLabel => '名前を変更';

  @override
  String get tagOptionsDeleteLabel => '削除';

  @override
  String get renameTagDialogTitle => 'タグ名を変更';

  @override
  String get renameTagDialogHint => '新しいタグ名';

  @override
  String get renameTagDialogCancelButton => 'キャンセル';

  @override
  String get renameTagDialogSaveButton => '保存';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '「$tag」は$affectedCount件のメモから削除されます。続けますか？';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return '「$tag」タグを削除しますか？';
  }

  @override
  String get deleteTagDialogTitle => 'タグを削除';

  @override
  String get deleteTagDialogCancelButton => 'キャンセル';

  @override
  String get deleteTagDialogConfirmButton => '削除';

  @override
  String get tagsSheetTitle => 'タグ';

  @override
  String get tagsSheetEmptyMessage => 'このメモにはまだタグがありません。';

  @override
  String get tagsSheetInputHint => '新しいタグを入力...';

  @override
  String get tagsSheetSuggestionsLabel => '既存のタグ';

  @override
  String get noteDeletedInfoMessage => 'メモを削除しました';

  @override
  String get noteDeletedUndoActionLabel => '元に戻す';

  @override
  String get reminderSetInfoMessage => 'リマインダーを設定しました';

  @override
  String get reminderRemovedInfoMessage => 'リマインダーを削除しました';

  @override
  String get noteDuplicatedInfoMessage => 'コピーを作成しました';

  @override
  String get speechTextAppendedInfoMessage => 'メモにテキストを追加しました';

  @override
  String get pdfPreparingInfoMessage => 'PDFを準備中…';

  @override
  String get pdfSavedInfoMessage => 'PDFを保存しました';

  @override
  String get pdfPreviewSaveActionLabel => '保存';

  @override
  String get jpgPreparingInfoMessage => 'JPGを準備中…';

  @override
  String get jpgSavedInfoMessage => 'JPGを保存しました';

  @override
  String get jpgFailedInfoMessage => 'JPGを作成できませんでした';

  @override
  String get txtPreparingInfoMessage => 'TXTを準備中…';

  @override
  String get txtSavedInfoMessage => 'TXTを保存しました';

  @override
  String get txtFailedInfoMessage => 'TXTを作成できませんでした';

  @override
  String get exportOpenActionLabel => '開く';

  @override
  String get wrongPasswordInfoMessage => 'パスワードが違います。';

  @override
  String get noteArchivedInfoMessage => 'メモをアーカイブしました';

  @override
  String get noteUnarchivedInfoMessage => 'アーカイブから解除しました';

  @override
  String get noteUnlockedInfoMessage => 'ロックを解除しました';

  @override
  String get noteLockedInfoMessage => 'メモをロックしました';

  @override
  String get notificationUnpinnedInfoMessage => 'ピン留めを解除しました';

  @override
  String get emptyNotePinBlockedInfoMessage => '空のメモはピン留めできません。';

  @override
  String get notificationPinnedInfoMessage => '通知パネルにピン留めしました';

  @override
  String get noContentToReadInfoMessage => '読み上げる内容がありません';

  @override
  String get backPressExitInfoMessage => 'もう一度戻るボタンを押すと終了します';

  @override
  String get reminderChannelName => 'メモのリマインダー';

  @override
  String get reminderChannelDescription => 'Layoutアプリのメモリマインダー';

  @override
  String get pinnedChannelName => 'ピン留めされたメモ';

  @override
  String get pinnedChannelDescription => '通知パネルにピン留めされたLayoutのメモ';

  @override
  String get notificationUnpinActionLabel => '削除';

  @override
  String get reminderDefaultTitle => 'リマインダー';

  @override
  String get reminderChecklistBodyFallback => 'チェックリストの確認を忘れずに';

  @override
  String get reminderTextBodyFallback => 'メモの確認を忘れずに';

  @override
  String get pdfSaveDialogTitle => 'PDFとして保存';

  @override
  String get jpgSaveDialogTitle => 'JPGとして保存';

  @override
  String get txtSaveDialogTitle => 'TXTとして保存';

  @override
  String get textSizeSheetTitle => '文字サイズ';

  @override
  String get textSizeSamplePreview => 'サンプルテキスト';

  @override
  String get textSizeCancelButton => 'キャンセル';

  @override
  String get textSizeApplyButton => '適用';

  @override
  String get createPasswordDialogTitle => 'パスワードを作成';

  @override
  String get createPasswordNewPasswordHint => '新しいパスワード';

  @override
  String get createPasswordConfirmHint => 'パスワードを再入力';

  @override
  String get createPasswordHintQuestionDescription =>
      'パスワードを忘れた場合に備えて秘密の質問を設定します（任意）。';

  @override
  String get createPasswordHintQuestionHint => '秘密の質問を選択';

  @override
  String get createPasswordHintAnswerHint => 'あなたの答え';

  @override
  String get createPasswordCancelButton => 'キャンセル';

  @override
  String get createPasswordSaveButton => '保存';

  @override
  String get passwordMismatchMessage => 'パスワードが一致しません！';

  @override
  String get passwordRequiredDialogTitle => 'パスワードが必要です';

  @override
  String get passwordRequiredHint => 'パスワードを入力';

  @override
  String get forgotPasswordButtonLabel => 'パスワードを忘れた場合';

  @override
  String get passwordRequiredCancelButton => 'キャンセル';

  @override
  String get passwordRequiredConfirmButton => '確認';

  @override
  String get securityQuestionDialogTitle => '秘密の質問';

  @override
  String get securityQuestionAnswerHint => 'あなたの答え';

  @override
  String get securityQuestionCancelButton => 'キャンセル';

  @override
  String get securityQuestionConfirmButton => '確定';

  @override
  String get securityQuestionWrongAnswerMessage => '答えが違います。もう一度お試しください。';

  @override
  String get revealedPasswordDialogTitle => 'あなたのパスワード';

  @override
  String get revealedPasswordLabel => 'メモのパスワード：';

  @override
  String get revealedPasswordOkButton => 'OK';

  @override
  String get securityQuestionPetName => '初めて飼ったペットの名前は？';

  @override
  String get securityQuestionFavoriteTeacher => '好きな先生の名前は？';

  @override
  String get securityQuestionBirthCity => '生まれた都市はどこですか？';

  @override
  String get securityQuestionFavoriteFood => '好きな食べ物は何ですか？';

  @override
  String get securityQuestionMotherMaidenName => '母親の旧姓は何ですか？';

  @override
  String get securityQuestionFirstSchool => '最初に通った学校の名前は？';

  @override
  String get securityQuestionFavoriteColor => '好きな色は何ですか？';

  @override
  String get editFolderDialogTitle => 'フォルダを編集';

  @override
  String get newSubfolderDialogTitle => '新しいサブフォルダ';

  @override
  String get addFolderDialogTitle => 'フォルダを追加';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return '「$parentCategory」の中に作成されます';
  }

  @override
  String get subfolderNameFieldLabel => 'サブフォルダ名';

  @override
  String get folderNameFieldLabel => 'フォルダ名';

  @override
  String get folderColorLabel => '色';

  @override
  String get folderDialogCancelButton => 'キャンセル';

  @override
  String get folderDialogSaveButton => '保存';

  @override
  String get folderDialogAddButton => '追加';

  @override
  String get selectFolderSheetTitle => 'フォルダを選択';

  @override
  String get selectFolderAddOptionLabel => 'フォルダを追加';

  @override
  String get removeCurrentFolderLabel => '現在のフォルダを解除';

  @override
  String get noteDetailsDialogTitle => '詳細';

  @override
  String get noteDetailsCreatedLabel => '作成日';

  @override
  String get noteDetailsModifiedLabel => '更新日';

  @override
  String get noteDetailsCharCountLabel => '文字数';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count文字';
  }

  @override
  String get noteDetailsWordCountLabel => '単語数';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count単語';
  }

  @override
  String get noteDetailsOkButton => 'OK';

  @override
  String get noteDetailsUnknownDateLabel => '不明';

  @override
  String get addAttachmentSheetTitle => '追加';

  @override
  String get addAttachmentImageOption => '画像を追加';

  @override
  String get addAttachmentCameraOption => 'カメラ';

  @override
  String get addAttachmentFileOption => 'ファイルを追加';

  @override
  String get addAttachmentVoiceOption => 'ボイスレコーディング';

  @override
  String get addAttachmentVideoOption => '動画を録画';

  @override
  String get addAttachmentScanOption => '文書をスキャン';

  @override
  String get noteActionsSheetTitle => '操作を選択';

  @override
  String get noteActionReminderLabel => 'リマインダー';

  @override
  String get noteActionEditReminderLabel => 'リマインダーを編集';

  @override
  String get noteActionSpeechToTextLabel => '音声をテキストに変換';

  @override
  String get noteActionArchiveLabel => 'アーカイブ';

  @override
  String get noteActionUnarchiveLabel => 'アーカイブから解除';

  @override
  String get noteActionLockLabel => 'ロック';

  @override
  String get noteActionUnlockLabel => 'ロック解除';

  @override
  String get noteActionFavoriteLabel => 'お気に入り';

  @override
  String get noteActionUnfavoriteLabel => 'お気に入りから解除';

  @override
  String get noteActionClassifyLabel => 'フォルダを選択';

  @override
  String get noteActionDeleteLabel => '削除';

  @override
  String get noteActionPinToNotificationLabel => '通知パネルにピン留め';

  @override
  String get noteActionUnpinFromNotificationLabel => 'ピン留めを解除';

  @override
  String get noteActionShareLabel => '共有';

  @override
  String get noteActionDuplicateLabel => 'コピーを作成';

  @override
  String get noteActionCopyContentLabel => '内容をコピー';

  @override
  String get noteActionTtsLabel => '読み上げ';

  @override
  String get noteActionTextSizeLabel => '文字サイズ';

  @override
  String get noteActionDetailsLabel => '詳細';

  @override
  String get noteActionDiscardChangesLabel => '変更を破棄';

  @override
  String get noteActionSelectLabel => '選択';

  @override
  String get reminderEditOptionLabel => 'リマインダーを変更';

  @override
  String get reminderRemoveOptionLabel => 'リマインダーを削除';

  @override
  String get discardChangesDialogTitle => '変更を破棄';

  @override
  String get discardChangesDialogMessage => 'このメモの未保存の変更は失われます。破棄してもよろしいですか？';

  @override
  String get discardChangesCancelButton => 'キャンセル';

  @override
  String get discardChangesConfirmButton => '破棄';

  @override
  String get pinnedNotificationDefaultTitle => 'メモ';

  @override
  String get pdfFailedInfoMessage => 'PDFの作成に失敗しました';

  @override
  String get drawingScreenTitle => '図形描画';

  @override
  String get drawingMinimizeTooltip => '最小化';

  @override
  String get drawingEmptyExportWarningMessage => 'まず何か描いてください';

  @override
  String get drawingEraserPartialModeLabel => '部分消去';

  @override
  String get drawingEraserFullModeLabel => '全消去';

  @override
  String get drawingClearTooltip => 'クリア';

  @override
  String get drawingZoomOutTooltip => '縮小';

  @override
  String get drawingZoomInTooltip => '拡大';

  @override
  String get drawingDeleteTooltip => '削除';

  @override
  String get drawingEmptyPreviewHint => 'タップして描画';

  @override
  String get settingsPageTitle => '設定';

  @override
  String get settingsSectionGeneral => '一般';

  @override
  String get settingsSectionSecurity => 'セキュリティ';

  @override
  String get settingsSectionTheme => 'テーマ';

  @override
  String get settingsSectionPersonalization => 'パーソナライズ';

  @override
  String get settingsSectionWidget => 'ウィジェット';

  @override
  String get settingsSectionAbout => 'アプリについて';

  @override
  String get settingsHintQuestionPet => '初めて飼ったペットの名前は？';

  @override
  String get settingsHintQuestionTeacher => '好きな先生の名前は？';

  @override
  String get settingsHintQuestionBirthCity => '生まれた都市はどこですか？';

  @override
  String get settingsHintQuestionFavoriteFood => '好きな食べ物は何ですか？';

  @override
  String get settingsHintQuestionMotherMaidenName => '母親の旧姓は何ですか？';

  @override
  String get settingsHintQuestionFirstSchool => '最初に通った学校はどこですか？';

  @override
  String get settingsHintQuestionFavoriteColor => '好きな色は何ですか？';

  @override
  String get settingsSecurityQuestionDialogTitle => '秘密の質問';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'パスワードを忘れた場合、この質問に正しく答えることで復元できます。';

  @override
  String get settingsSecurityQuestionDropdownHint => '秘密の質問を選択';

  @override
  String get settingsSecurityQuestionAnswerHint => 'あなたの答え';

  @override
  String get settingsSecurityQuestionCancelButton => 'キャンセル';

  @override
  String get settingsSecurityQuestionEmptyWarning => '質問と答えは空にできません！';

  @override
  String get settingsSecurityQuestionSaveButton => '保存';

  @override
  String get settingsCreatePasswordTitle => 'パスワードを作成';

  @override
  String get settingsPasswordRequiredTitle => 'パスワードが必要です';

  @override
  String get settingsPasswordEnterHint => 'パスワードを入力';

  @override
  String get settingsForgotPasswordButton => 'パスワードを忘れた場合';

  @override
  String get settingsNewPasswordHint => '新しいパスワード';

  @override
  String get settingsConfirmPasswordHint => 'パスワードを再入力';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'パスワードを忘れた場合に備えて秘密の質問を設定します（任意）。';

  @override
  String get settingsPasswordDialogCancelButton => 'キャンセル';

  @override
  String get settingsPasswordMismatchWarning => 'パスワードが一致しません！';

  @override
  String get settingsWrongPasswordWarning => 'パスワードが違います！';

  @override
  String get settingsPasswordSaveButton => '保存';

  @override
  String get settingsPasswordRemoveButton => '削除';

  @override
  String get settingsNotePasswordTitle => 'メモのパスワード';

  @override
  String get settingsPasswordSetSubtitle => 'パスワード設定済み ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'パスワード未設定';

  @override
  String get settingsSecurityQuestionTileTitle => '秘密の質問';

  @override
  String get settingsSecurityQuestionSetSubtitle => '設定済み ✓ — パスワードを忘れた場合に使用';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      '未設定 — 紛失時にパスワードを復元できません';

  @override
  String get settingsThemeDialogTitle => 'テーマを選択';

  @override
  String get settingsThemeSystemDefault => 'システム標準';

  @override
  String get settingsThemeLightOption => 'ライトテーマ';

  @override
  String get settingsThemeDarkOption => 'ダークテーマ';

  @override
  String get settingsLanguageDialogTitle => '言語を選択';

  @override
  String get settingsLanguageSystemOption => 'システム';

  @override
  String get settingsAccentColorDialogTitle => 'アクセントカラーを選択';

  @override
  String get settingsThemeChangeTileTitle => 'テーマを変更';

  @override
  String get settingsThemeLightLabel => 'ライト';

  @override
  String get settingsThemeDarkLabel => 'ダーク';

  @override
  String get settingsThemeSystemLabel => 'システム';

  @override
  String get settingsLanguageTileTitle => '言語';

  @override
  String get settingsAccentColorTileTitle => 'アクセントカラー';

  @override
  String get settingsAccentColorTileSubtitle => 'アプリバー、ボタン、スイッチに使用する色';

  @override
  String get settingsColorfulNotesTitle => 'メモの色を変える';

  @override
  String get settingsColorfulNotesSubtitle => '各メモカードに異なる色調が適用されます。';

  @override
  String get settingsTextColorSheetTitle => '文字色';

  @override
  String get settingsTextColorSheetDesc => 'メモ本文の文字色を設定します。';

  @override
  String get settingsTextColorOkButton => 'OK';

  @override
  String get settingsTextColorTileTitle => '文字色';

  @override
  String get settingsTextColorTileSubtitle => 'メモ本文の文字色。';

  @override
  String get settingsWidgetFontSizeLabel => 'ウィジェットの文字サイズ';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return '見出しサンプル - ${size}pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'キャンセル';

  @override
  String get settingsWidgetFontSizeApplyButton => '適用';

  @override
  String get settingsWidgetOpacityLabel => '背景の透明度';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return '透明度$percent%';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'キャンセル';

  @override
  String get settingsWidgetOpacityApplyButton => '適用';

  @override
  String get settingsWidgetDarkModeTitle => 'ダークウィジェット';

  @override
  String get settingsWidgetDarkModeDesc => 'ウィジェット用のダークカラースキーム。';

  @override
  String get settingsAboutVersionTitle => 'アプリバージョン';

  @override
  String get settingsAboutVersionLoading => 'バージョンを読み込み中…';

  @override
  String get aboutSectionDeveloper => 'フィードバック';

  @override
  String get aboutDeveloperTitle => '開発者';

  @override
  String get aboutContactTitle => 'お問い合わせ';

  @override
  String get aboutWebsiteTitle => 'ウェブサイト';

  @override
  String get aboutGithubTitle => 'GitHub';

  @override
  String get aboutSectionLegal => '法的情報';

  @override
  String get aboutPrivacyPolicyTitle => 'プライバシーポリシー';

  @override
  String get aboutTermsTitle => '利用規約';

  @override
  String get aboutLicensesTitle => 'オープンソースライセンス';

  @override
  String get aboutSectionSupport => '評価';

  @override
  String get aboutRateAppTitle => 'アプリを評価する';

  @override
  String get aboutLinkOpenError => 'リンクを開けませんでした。';

  @override
  String get settingsFontFamilyTileTitle => 'フォント';

  @override
  String get settingsFontFamilyDefaultLabel => 'デフォルト';

  @override
  String get settingsGlobalFontSizeTileTitle => '文字サイズ';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '${size}pt — 全てのメモに適用されます。';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'サンプルテキスト - ${size}pt';
  }

  @override
  String get settingsGlobalFontSizeCancelButton => 'キャンセル';

  @override
  String get settingsGlobalFontSizeApplyButton => '適用';

  @override
  String get settingsPreviewLinesTileTitle => 'メモのプレビュー行数';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return '最大$lines行まで表示します。メモがそれより短い場合は実際の行数が表示されます。';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return '現在：$lines行';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'プレビューする最大行数を設定します。メモの行数がそれより少ない場合は実際の行数が表示されます。';

  @override
  String get settingsPreviewLinesCancelButton => 'キャンセル';

  @override
  String get settingsPreviewLinesApplyButton => '適用';

  @override
  String get backupCancelButton => 'キャンセル';

  @override
  String get backupConnectButton => '接続';

  @override
  String get backupDisconnectButton => '切断';

  @override
  String get backupContinueButton => '続行';

  @override
  String get backupCloseButton => '閉じる';

  @override
  String get backupShareButton => '共有';

  @override
  String get backupRestoreButton => '復元';

  @override
  String get backupConfigureButton => '設定';

  @override
  String get backupUnknownDateLabel => '不明';

  @override
  String get backupProcessingDefaultLabel => '処理中...';

  @override
  String get backupPermissionRequiredTitle => 'ストレージ権限が必要です';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'このAndroidバージョンではバックアップ・復元にストレージ権限が必要です。権限が完全に拒否されているため、アプリの設定から手動で許可してください。';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'このAndroidバージョンではバックアップ・復元にストレージ権限が必要です。続行するには権限を許可してください。';

  @override
  String get backupGoToSettingsButton => '設定を開く';

  @override
  String get backupRetryButton => '再試行';

  @override
  String get backupDriveConnectingLabel => 'Googleアカウントに接続中...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Googleドライブアカウントに接続しました：$email';
  }

  @override
  String get backupDriveConnectedMessage => 'Googleドライブアカウントに接続しました。';

  @override
  String get backupDriveConnectFailedMessage =>
      'Googleアカウントに接続できなかったか、操作がキャンセルされました。';

  @override
  String get backupDriveDisconnectTitle => 'Googleドライブを切断';

  @override
  String get backupDriveDisconnectBody =>
      '切断すると、手動または自動でのドライブへのバックアップができなくなります。すでにドライブに保存されているバックアップは削除されず、このデバイスからのアクセスのみが解除されます。';

  @override
  String get backupDriveDisconnectedMessage => 'Googleドライブの接続を解除しました。';

  @override
  String get backupDriveRequiredTitle => 'Googleアカウントが必要です';

  @override
  String get backupDriveRequiredBody => 'この操作にはGoogleアカウントへの接続が必要です。今すぐ接続しますか？';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Googleドライブ：接続済み（$email）';
  }

  @override
  String get backupDriveStatusConnected => 'Googleドライブ：接続済み';

  @override
  String get backupDriveStatusDisconnected => 'Googleドライブ：未接続';

  @override
  String get backupDriveAuthenticatingLabel => 'Googleアカウントを確認中...';

  @override
  String get backupDriveNotSignedInMessage =>
      'Googleドライブに接続されていません。まずGoogleアカウントでサインインしてください。';

  @override
  String get backupDriveUploadingLabel => 'バックアップをドライブにアップロード中...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Googleドライブへのアップロードが120秒以内に完了しませんでした（サーバーからの応答なし）。接続を確認してもう一度お試しください。';

  @override
  String get backupDriveOperationCompletedLabel => '完了';

  @override
  String get backupToDriveActionLabel => 'ドライブへのバックアップ';

  @override
  String get backupToDeviceActionLabel => 'バックアップ';

  @override
  String get backupCreatingLabel => 'バックアップを作成中...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'バックアップを作成できませんでした: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Googleドライブへのアップロードに失敗しました: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'バックアップをGoogleドライブに正常にアップロードしました。';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'バックアップを作成しました：$fileName（$size）';
  }

  @override
  String get backupOfferShareTitle => 'バックアップ完了';

  @override
  String get backupOfferShareBody =>
      'バックアップファイルがデバイスに保存されました。今すぐ共有しますか？（クラウドストレージ、メール、他のデバイスなど）';

  @override
  String get backupShareFileText => 'layoutバックアップファイル';

  @override
  String backupShareFailedMessage(String error) {
    return '共有を開始できませんでした: $error';
  }

  @override
  String get backupLargeOperationTitle => '大容量バックアップ';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return '処理するデータは約$sizeTextです。このサイズの$actionLabelはデバイスによって時間がかかる場合があります。処理中はアプリを閉じないでください — 続行しますか？';
  }

  @override
  String get backupRestoreActionLabel => '復元';

  @override
  String get backupDriveListingLabel => 'ドライブのバックアップを取得中...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'バックアップを取得できませんでした: $error';
  }

  @override
  String get backupDriveNoBackupsMessage => 'Googleドライブにバックアップはまだありません。';

  @override
  String get backupDrivePickTitle => 'ドライブからバックアップを選択';

  @override
  String get backupDriveDownloadingLabel => 'ドライブからバックアップをダウンロード中...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'ドライブからバックアップをダウンロード中... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel => 'ファイルをデバイスに保存中...';

  @override
  String get backupDriveUnknownBackupFileName => 'unknown_backup.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Googleドライブの容量が不足しています。ドライブの空き容量を確保してからもう一度お試しください。';

  @override
  String get backupDriveNetworkErrorMessage =>
      'インターネット接続を確立できませんでした。接続を確認してもう一度お試しください。';

  @override
  String get backupDriveBackupNotFoundMessage =>
      '指定されたバックアップファイルがドライブで見つかりませんでした。削除された可能性があります。';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Googleドライブの操作中に予期しないエラーが発生しました: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'ダウンロードに失敗しました: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'ファイルを選択できませんでした: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage => '選択したファイルにアクセスできませんでした。';

  @override
  String get backupCheckingLabel => 'バックアップを確認中...';

  @override
  String backupReadFailedMessage(String error) {
    return 'バックアップファイルを読み込めませんでした: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'バックアップを復元';

  @override
  String get backupPreviewContentsHeader => '選択したバックアップの内容：';

  @override
  String get backupPreviewNoteCountLabel => 'メモ件数';

  @override
  String get backupPreviewTrashCountLabel => 'ゴミ箱内のメモ';

  @override
  String get backupPreviewCategoryCountLabel => 'カテゴリ数';

  @override
  String get backupPreviewAttachmentLabel => '添付ファイル';

  @override
  String get backupPreviewAttachmentNoneValue => 'なし';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count件（$size）';
  }

  @override
  String get backupPreviewCreatedAtLabel => '作成日';

  @override
  String get backupEmptyPreviewTitle => 'このバックアップは空のようです';

  @override
  String get backupEmptyPreviewBody =>
      '選択したファイル内にメモ、カテゴリ、添付ファイルが見つかりませんでした。続行すると、現在のデータは削除され、この空のバックアップに置き換えられます。';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return 'バックアップ内に$count件の添付ファイルが見つかりません';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'これらのファイルを含むメモは、添付ファイルなしで復元されます（バックアップ作成時に欠落または破損していた可能性があります）：$names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown、他$remaining件';
  }

  @override
  String get backupRestoreConfirmBody =>
      'この操作により、現在のメモ、ゴミ箱、カテゴリ、設定、添付ファイルはすべて上記のバックアップデータに置き換えられます。現在のデータは完全に失われ、元に戻すことはできません。';

  @override
  String get backupRestoringLabel => 'バックアップを復元中...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'バックアップを復元しました。ただし$count件の添付ファイルがバックアップ内に見つからず復元できませんでした。変更を完全に反映するにはアプリの再起動をおすすめします。';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'バックアップを正常に復元しました。変更を完全に反映するにはアプリの再起動をおすすめします。';

  @override
  String backupRestoreFailedMessage(String error) {
    return '復元中にエラーが発生しました: $error';
  }

  @override
  String get backupScreenTitle => 'バックアップと復元';

  @override
  String get backupBlockedExitWarningMessage => '処理が進行中です。完了までお待ちください。';

  @override
  String get backupBusyBackTooltip => '処理進行中';

  @override
  String get backupIntroText =>
      'メモ、カテゴリ、設定、添付ファイルを1つのzipファイルとしてバックアップしたり、以前作成したバックアップから復元したりできます。';

  @override
  String get backupDriveCardTitle => 'Googleドライブにバックアップ';

  @override
  String get backupDriveCardSubtitle =>
      '新しいバックアップを作成し、Googleドライブの非公開領域に直接アップロードします。';

  @override
  String get backupDriveCardButtonLabel => 'ドライブにバックアップ';

  @override
  String get backupDeviceCardTitle => 'デバイスにバックアップ';

  @override
  String get backupDeviceCardSubtitle =>
      'すべてのデータを1つのzipファイルとしてデバイスに保存し、必要に応じて共有できます。';

  @override
  String get backupDeviceCardButtonLabel => 'デバイスにバックアップ';

  @override
  String get backupHistoryCardTitle => 'バックアップ履歴';

  @override
  String get backupHistoryCardSubtitle =>
      'デバイスに保存されているすべてのバックアップを日付とサイズとともに確認できます。ここから直接共有・復元・削除ができます。';

  @override
  String get backupHistoryTabDevice => 'デバイス';

  @override
  String get backupHistoryTabDrive => 'Googleドライブ';

  @override
  String get backupHistoryDeleteDialogTitle => 'バックアップを削除';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'バックアップファイル「$fileName」を完全に削除してもよろしいですか？この操作は元に戻せません。';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'バックアップを削除しました。';

  @override
  String get backupHistoryDriveDeleteDialogTitle => 'ドライブのバックアップを削除';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'Googleドライブ上のバックアップ「$fileName」を完全に削除してもよろしいですか？この操作は元に戻せず、ファイルはゴミ箱に移動されません。';
  }

  @override
  String get backupHistoryDriveDeletedMessage => 'ドライブのバックアップを削除しました。';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return '削除できませんでした: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle => 'このデバイスにはまだバックアップが保存されていません。';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      '「デバイスにバックアップ」を使って最初のバックアップを作成してください。';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      '「Googleドライブにバックアップ」を使って最初のクラウドバックアップを作成してください。';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'ドライブのバックアップを表示するにはGoogleアカウントに接続してください。';

  @override
  String get backupHistoryConnectGoogleButton => 'Googleで接続';

  @override
  String get backupHistoryDriveConnectedFallback => '接続済み';

  @override
  String get backupHistoryUnknownErrorFallback => '不明なエラーが発生しました。';

  @override
  String get backupHistoryDownloadStartingLabel => '開始中...';

  @override
  String get backupAutoBackupEnabledLabel => '自動バックアップ：オン';

  @override
  String get backupAutoBackupDisabledLabel => '自動バックアップ：オフ';

  @override
  String get backupOverlayWarningMessage => '処理が完了するまでアプリを閉じずにお待ちください。';

  @override
  String get pdfExportUntitledNoteLabel => '無題のメモ';

  @override
  String get pdfExportDefaultAttachmentName => '添付ファイル';

  @override
  String get pdfExportDefaultFileName => 'note';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'スクリーンショットを取得できませんでした（境界が見つかりません）';

  @override
  String get screenshotExportByteDataNullMessage => 'スクリーンショットデータを生成できませんでした';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      '画像を処理できませんでした（PNGのデコードに失敗）';

  @override
  String get screenshotCalcTableTotalLabel => '合計';

  @override
  String get gundemMenuRemoveFromAgenda => '予定から削除';

  @override
  String get gundemMenuDeleteNote => 'メモを削除';

  @override
  String get gundemSectionOverdue => '期限切れ';

  @override
  String get gundemSectionToday => '今日';

  @override
  String get gundemSectionTomorrow => '明日';

  @override
  String get gundemSectionNextWeek => '来週';

  @override
  String get gundemSectionFurther => 'それ以降';

  @override
  String get gundemWeekdayMonday => '月曜日';

  @override
  String get gundemWeekdayTuesday => '火曜日';

  @override
  String get gundemWeekdayWednesday => '水曜日';

  @override
  String get gundemWeekdayThursday => '木曜日';

  @override
  String get gundemWeekdayFriday => '金曜日';

  @override
  String get gundemWeekdaySaturday => '土曜日';

  @override
  String get gundemWeekdaySunday => '日曜日';

  @override
  String get gundemAppBarTitle => '予定';

  @override
  String get gundemCalendarTooltip => 'カレンダー';

  @override
  String get gundemEmptyTitle => '予定はありません';

  @override
  String get gundemEmptySubtitle => 'リマインダーや日付が割り当てられたメモがここに表示されます。';

  @override
  String get gundemUntitledNote => '無題のメモ';

  @override
  String get gundemRepeatHourly => '毎時';

  @override
  String get gundemRepeatDaily => '毎日';

  @override
  String get gundemRepeatWeekly => '毎週';

  @override
  String get gundemRepeatMonthly => '毎月';

  @override
  String get gundemRepeatYearly => '毎年';

  @override
  String get gundemPreviewCalcTableLabel => '[計算リスト]';

  @override
  String get gundemPreviewDrawingLabel => '[図形描画]';

  @override
  String get gundemPreviewImageLabel => '[画像]';

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
  String get calendarAppBarTitle => 'カレンダー';

  @override
  String get calendarTodayButton => '今日';

  @override
  String get calendarLegendNoteLabel => 'メモ';

  @override
  String get calendarLegendReminderLabel => 'リマインダー';

  @override
  String get calendarTodayBadge => '今日';

  @override
  String get calendarEmptyDayMessage => 'この日にはメモやリマインダーがありません。';

  @override
  String get calendarReminderHourlyLabel => '毎時';

  @override
  String get calendarMonthJan => '1月';

  @override
  String get calendarMonthFeb => '2月';

  @override
  String get calendarMonthMar => '3月';

  @override
  String get calendarMonthApr => '4月';

  @override
  String get calendarMonthMay => '5月';

  @override
  String get calendarMonthJun => '6月';

  @override
  String get calendarMonthJul => '7月';

  @override
  String get calendarMonthAug => '8月';

  @override
  String get calendarMonthSep => '9月';

  @override
  String get calendarMonthOct => '10月';

  @override
  String get calendarMonthNov => '11月';

  @override
  String get calendarMonthDec => '12月';

  @override
  String get calendarWeekdayShortMon => '月';

  @override
  String get calendarWeekdayShortTue => '火';

  @override
  String get calendarWeekdayShortWed => '水';

  @override
  String get calendarWeekdayShortThu => '木';

  @override
  String get calendarWeekdayShortFri => '金';

  @override
  String get calendarWeekdayShortSat => '土';

  @override
  String get calendarWeekdayShortSun => '日';

  @override
  String get calendarWeekdayFullMonday => '月曜日';

  @override
  String get calendarWeekdayFullTuesday => '火曜日';

  @override
  String get calendarWeekdayFullWednesday => '水曜日';

  @override
  String get calendarWeekdayFullThursday => '木曜日';

  @override
  String get calendarWeekdayFullFriday => '金曜日';

  @override
  String get calendarWeekdayFullSaturday => '土曜日';

  @override
  String get calendarWeekdayFullSunday => '日曜日';

  @override
  String get wrongPasswordDialogTitle => 'パスワードが違います';

  @override
  String get wrongPasswordDialogMessage => '入力されたパスワードが正しくありません。';

  @override
  String get commonOkButton => 'OK';

  @override
  String get unlockCategoryAction => 'ロック解除';

  @override
  String get lockCategoryAction => 'ロック';

  @override
  String get categoryUnlockedMessage => 'ロックを解除しました';

  @override
  String get categoryLockedMessage => 'フォルダをロックしました';

  @override
  String get deleteFolderMenuItemLabel => 'フォルダを削除';

  @override
  String get deleteFolderDialogTitle => 'フォルダを削除';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'フォルダ「$category」とそのすべてのサブフォルダを削除してもよろしいですか？これらのフォルダ内のメモは未分類になります。';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'フォルダ「$category」を削除してもよろしいですか？このフォルダ内のメモは未分類になります。';
  }

  @override
  String get deleteFolderDialogCancelButton => 'キャンセル';

  @override
  String get deleteFolderDialogConfirmButton => '削除';

  @override
  String get editCategoryNameColorMenuItemLabel => '名前・色を編集';

  @override
  String get addSubfolderMenuItemLabel => 'サブフォルダを作成';

  @override
  String get expandSubfoldersMenuItemLabel => 'サブフォルダを展開';

  @override
  String get collapseSubfoldersMenuItemLabel => 'サブフォルダを折りたたむ';

  @override
  String saveErrorInfoMessage(String error) {
    return '保存エラー: $error';
  }

  @override
  String get welcomeNoteTitle => 'Layoutへようこそ！🚀';

  @override
  String get welcomeNoteContent => '新機能が追加されました！';

  @override
  String get noteListDateGroupToday => '今日';

  @override
  String get noteListDateGroupYesterday => '昨日';

  @override
  String get noteListDateGroupLast7Days => '過去7日間';

  @override
  String get noteListDateGroupLast30Days => '過去30日間';

  @override
  String get reminderRepeatNoneLabel => '繰り返しなし';

  @override
  String get voiceRecorderPreparingLabel => '準備中…';

  @override
  String get voiceRecorderCancelButton => 'キャンセル';

  @override
  String get voiceRecorderStopAddButton => '停止して追加';

  @override
  String get speechToTextMicPermissionDeniedMessage => 'マイクの権限が許可されていません。';

  @override
  String get speechToTextUnavailableMessage => 'この端末では音声認識を利用できません。';

  @override
  String get speechToTextPreparingLabel => '準備中…';

  @override
  String get speechToTextListeningLabel => '聞き取り中…';

  @override
  String get speechToTextStartSpeakingPlaceholder => '話し始めてください…';

  @override
  String get speechToTextCancelButton => 'キャンセル';

  @override
  String get speechToTextStopAddButton => '停止して追加';

  @override
  String get textToSpeechNoContentMessage => '読み上げる内容がありません。';

  @override
  String get textToSpeechReadErrorMessage => '読み上げ中にエラーが発生しました。';

  @override
  String get textToSpeechUnavailableMessage => 'この端末では読み上げ機能を利用できません。';

  @override
  String get textToSpeechPreparingLabel => '準備中…';

  @override
  String get textToSpeechPausedLabel => '一時停止';

  @override
  String get textToSpeechFinishedLabel => '読み上げが完了しました';

  @override
  String get textToSpeechReadingLabel => '読み上げ中…';

  @override
  String get textToSpeechCloseErrorButton => '閉じる';

  @override
  String get textToSpeechReplayButton => 'もう一度読み上げる';

  @override
  String get textToSpeechCloseFinishedButton => '閉じる';

  @override
  String get textToSpeechPauseButton => '一時停止';

  @override
  String get textToSpeechResumeButton => '再開';

  @override
  String get textToSpeechStopButton => '停止';

  @override
  String get textToSpeechSpeedSlow => '遅い';

  @override
  String get textToSpeechSpeedNormal => '普通';

  @override
  String get textToSpeechSpeedFast => '速い';

  @override
  String get calendarPickerCancelButton => 'キャンセル';

  @override
  String get calendarPickerConfirmButton => '選択';

  @override
  String get calendarPickerClearButton => 'クリア';

  @override
  String get reminderPickerDialogTitle => 'リマインダーを追加';

  @override
  String get reminderPickerDateTodayOption => '今日';

  @override
  String get reminderPickerDateTomorrowOption => '明日';

  @override
  String get reminderPickerDatePickOption => '日付を選択';

  @override
  String get reminderRepeatHourlyLabel => '1時間ごと';

  @override
  String get reminderRepeatDailyLabel => '毎日';

  @override
  String get reminderRepeatWeeklyLabel => '毎週';

  @override
  String get reminderRepeatMonthlyLabel => '毎月';

  @override
  String get reminderRepeatYearlyLabel => '毎年';

  @override
  String get reminderPickerCalendarHelpText => 'リマインダーの日付を選択';

  @override
  String get reminderPickerCancelButton => 'キャンセル';

  @override
  String get reminderPickerSaveButton => '保存';

  @override
  String get reminderPickerPastTimeErrorMessage => '過去の時刻は選択できません';

  @override
  String calcTableTotalLabel(String amount) {
    return '合計: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'データを準備中...';

  @override
  String get backupCreatePackagingNotesLabel => 'メモとカテゴリをまとめています...';

  @override
  String get backupCreateReadingAttachmentsLabel => '添付ファイルを読み込み中...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return '添付ファイルを読み込み中... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'zipファイルを圧縮中...';

  @override
  String get backupCreateSavingFileLabel => 'ファイルを保存中...';

  @override
  String get backupRestoreValidatingLabel => 'バックアップを検証中...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'バックアップを検証しました。データを準備中...';

  @override
  String get backupRestoreWritingNotesLabel => 'メモを書き込み中...';

  @override
  String get backupRestoreWritingTrashLabel => 'ゴミ箱を書き込み中...';

  @override
  String get backupRestoreTrashWrittenLabel => 'ゴミ箱を書き込みました';

  @override
  String get backupRestoreWritingCategoriesLabel => 'カテゴリを書き込み中...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'カテゴリを書き込みました';

  @override
  String get backupRestoreWritingSettingsLabel => '設定を書き込み中...';

  @override
  String get backupRestoreSettingsWrittenLabel => '設定を書き込みました';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel => '古い添付ファイルを削除中...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      '添付ファイルが見つかりません。終了処理中...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return '添付ファイルを復元中... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => '完了';

  @override
  String get backupValidationCorruptedFileMessage =>
      'ファイルが破損しているか、有効なバックアップファイルではありません。';

  @override
  String get backupValidationMissingDataMessage =>
      'バックアップファイル内にデータが見つかりません（backup_data.jsonがありません）。';

  @override
  String get backupValidationInvalidJsonMessage =>
      'バックアップデータを読み込めませんでした（JSONが破損しています）。';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'このファイルはlayoutアプリのバックアップではありません。';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'バックアップファイルのバージョン情報を読み込めませんでした。';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'このバックアップは現在のアプリバージョンがサポートしていない新しい形式です。アプリを更新してください。';

  @override
  String get backupValidationInvalidVersionMessage =>
      'バックアップファイルのバージョン情報が無効です。';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'バックアップデータの形式が正しくありません（notesフィールドがありません）。';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'バックアップデータの形式が正しくありません（trashフィールドがありません）。';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'バックアップデータの形式が正しくありません（カテゴリ一覧が無効です）。';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'バックアップデータの形式が正しくありません（settingsフィールドが無効です）。';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'バックアップデータの形式が正しくありません（無効なメモレコードがあります）。';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'バックアップデータの形式が正しくありません（IDのないメモレコードが見つかりました）。';

  @override
  String get backupValidationFileNotFoundMessage => 'バックアップファイルが見つかりません。';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'デバイスの空き容量が不足しています。空き容量を確保してからもう一度お試しください。';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'ファイルアクセスの権限が拒否されました。アプリの権限設定を確認してもう一度お試しください。';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'ファイル操作中にエラーが発生しました: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return '予期しないエラーが発生しました: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'zipアーカイブを作成できませんでした（ZipEncoderがnullを返しました）。';

  @override
  String get calcTableMenuItemLabel => '計算リスト';

  @override
  String get tableBlockMenuItemLabel => 'テーブル';

  @override
  String get tableSizePickerTitle => 'テーブルサイズを選択';

  @override
  String get tableSizePickerCancel => 'キャンセル';

  @override
  String get tableSizePickerDeleteTooltip => 'テーブルを削除';

  @override
  String get tagsMenuItemLabel => 'タグ';

  @override
  String get linkDialogUrlHint => 'https://example.com';

  @override
  String get checklistItemHint => '項目を追加...';

  @override
  String get toolbarHighlightTooltip => 'マーカー';

  @override
  String get toolbarListTooltip => 'リスト';

  @override
  String get toolbarHideKeyboardTooltip => 'キーボードを隠す';

  @override
  String get autoBackupLocalSuccessMessage => 'ローカルバックアップが完了しました。';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'ローカルバックアップに失敗しました: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'ドライブへのバックアップをスキップしました：Googleアカウントが接続されていないか、セッションの期限が切れています。アプリを開いて再接続してください。';

  @override
  String get autoBackupDriveSuccessMessage => 'ドライブへのバックアップが完了しました。';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'ドライブへのバックアップに失敗しました: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'まだメモがありません';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return '合計: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ 図形描画';

  @override
  String get autoBackupSettingsAppBarTitle => '自動バックアップ設定';

  @override
  String get autoBackupSettingsMainSwitchTitle => '自動バックアップを有効にする';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'バックグラウンドで定期的にメモが安全にバックアップされます。';

  @override
  String get autoBackupSettingsTargetTitle => 'バックアップ先';

  @override
  String get autoBackupSettingsTargetSubtitle => 'バックアップの保存先を選択します。';

  @override
  String get autoBackupSettingsTargetLocalOption => 'ローカル';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Googleドライブ';

  @override
  String get autoBackupSettingsTargetBothOption => '両方';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Googleドライブのオプションを使用するには、まずアカウントを接続してください。';

  @override
  String get autoBackupSettingsConnectButton => '接続';

  @override
  String get autoBackupSettingsFrequencyTitle => 'バックアップ頻度';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return '$hours時間ごとにバックアップが実行されます。';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6時間';

  @override
  String get autoBackupSettingsFrequency12h => '12時間';

  @override
  String get autoBackupSettingsFrequency24h => '24時間（毎日）';

  @override
  String get autoBackupSettingsFrequency48h => '48時間（2日ごと）';

  @override
  String get autoBackupSettingsFrequency168h => '168時間（毎週）';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Wi-Fiのみ使用';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'モバイルデータを保護するため、クラウドへのアップロードはWi-Fi接続時のみ行われます。';

  @override
  String get autoBackupSettingsStatusCardTitle => 'システム状態';

  @override
  String get autoBackupSettingsNeverRunMessage => '自動バックアップはまだ実行されていません。';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return '最終実行: $date $time（$status）\nメッセージ: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => '成功';

  @override
  String get autoBackupSettingsStatusFailedLabel => '失敗';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Googleアカウントに接続できませんでした。';

  @override
  String get autoBackupSettingsSavedSnackbar => '自動バックアップ設定を更新しました。';

  @override
  String selectionModeDeletedMessage(int count) {
    return '$count件のメモを削除しました';
  }

  @override
  String get selectionModeArchivedMessage => 'アーカイブしました';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return '$count件のメモのカテゴリを選択';
  }

  @override
  String get selectionModeAddCategoryOption => 'カテゴリを追加';

  @override
  String get selectionModeRemoveCategoryOption => 'カテゴリを削除';

  @override
  String get calcTableItemHint => '項目...';

  @override
  String get calcTableTotalRowLabel => '合計';

  @override
  String get textSelectionMenuShareButton => '共有';

  @override
  String get textSelectionMenuTranslateButton => '翻訳';

  @override
  String get textSelectionMenuShareFailedSnackbar => '共有を開始できませんでした。';

  @override
  String get textSelectionMenuTranslateFailedSnackbar => '翻訳を開けませんでした。';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return '今日 $time';
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
    return '最終バックアップ: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage => 'まだバックアップが取得されていません。';

  @override
  String get backupFileNameLabel => 'バックアップ';

  @override
  String get tableMenuInsertRowAfter => '行を追加';

  @override
  String get tableMenuDeleteRow => '行を削除';

  @override
  String get tableMenuInsertColumnAfter => '列を追加';

  @override
  String get tableMenuDeleteColumn => '列を削除';

  @override
  String get imageCropToolbarTitle => 'トリミング';

  @override
  String get imageViewerDeleteButtonLabel => '削除';

  @override
  String get imageViewerSaveToGalleryButtonLabel => '保存';

  @override
  String get imageViewerShareButtonLabel => '共有';

  @override
  String get imageViewerGalleryPermissionDeniedMessage =>
      'ギャラリーへのアクセスが許可されていません';

  @override
  String get imageViewerSavedToGalleryMessage => 'アルバムに保存しました';

  @override
  String imageViewerSaveFailedMessage(String error) {
    return '保存できませんでした: $error';
  }

  @override
  String get imageViewerSavingInProgressMessage => '保存中…';

  @override
  String get imageViewerFileNotFoundMessage => 'このファイルは存在しません';
}
