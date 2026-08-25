// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get toolbarBoldTooltip => '굵게';

  @override
  String get toolbarItalicTooltip => '기울임꼴';

  @override
  String get toolbarUnderlineTooltip => '밑줄';

  @override
  String get toolbarStrikethroughTooltip => '취소선';

  @override
  String get toolbarFontSizeTooltip => '글자 크기';

  @override
  String get toolbarColorTooltip => '글자 색상';

  @override
  String get toolbarBulletTooltip => '글머리 기호 목록';

  @override
  String get toolbarNumberTooltip => '번호 매기기 목록';

  @override
  String get toolbarIndentTooltip => '문단 들여쓰기';

  @override
  String get toolbarLinkTooltip => '링크 추가/편집/삭제';

  @override
  String get toolbarDividerTooltip => '구분선 삽입';

  @override
  String get toolbarChecklistTooltip => '체크리스트 추가';

  @override
  String get linkSelectTextSnackbar => '먼저 링크로 연결할 텍스트를 선택하세요';

  @override
  String get linkDialogEditTitle => '링크 편집';

  @override
  String get linkDialogAddTitle => '링크 추가';

  @override
  String get linkDialogRemoveButton => '링크 삭제';

  @override
  String get linkDialogCancelButton => '취소';

  @override
  String get linkDialogConfirmButton => '추가';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      '카메라 권한이 거부되었습니다. 동영상을 녹화하려면 설정에서 권한을 허용해야 합니다.';

  @override
  String get cameraPermissionRequiredMessage => '동영상을 녹화하려면 카메라 권한이 필요합니다.';

  @override
  String get openSettingsButtonLabel => '설정';

  @override
  String documentScanStartFailedMessage(String error) {
    return '스캔을 시작할 수 없습니다: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return '텍스트 인식에 실패했습니다: $error';
  }

  @override
  String get ocrNoReadableTextMessage => '문서에서 읽을 수 있는 텍스트를 찾지 못했습니다';

  @override
  String get scanResultSheetTitle => '스캔한 문서를 어떻게 추가할까요?';

  @override
  String get scanResultTextOnlyOption => '텍스트로만 추가';

  @override
  String get scanResultTextAndImageOption => '텍스트 + 스캔 이미지 추가';

  @override
  String get scanResultCancelOption => '취소';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      '마이크 권한이 거부되었습니다. 오디오를 녹음하려면 설정에서 권한을 허용해야 합니다.';

  @override
  String get audioPermissionRequiredMessage => '오디오를 녹음하려면 마이크 권한이 필요합니다.';

  @override
  String get voiceRecordingDefaultLabel => '음성 녹음';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return '계산 목록 ($count행)';
  }

  @override
  String get blockPreviewDrawingLabel => '그림';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '첨부파일 $count개 (사진/문서)';
  }

  @override
  String get blockPreviewDividerLabel => '구분선';

  @override
  String blockPreviewChecklistLabel(int count) {
    return '체크리스트 ($count개 항목)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(빈 텍스트)';

  @override
  String get reorderBlocksSheetTitle => '블록 순서 변경';

  @override
  String get reorderBlocksMoveUpTooltip => '위로 이동';

  @override
  String get reorderBlocksMoveDownTooltip => '아래로 이동';

  @override
  String get reorderBlocksCloseTooltip => '닫기';

  @override
  String get reorderBlocksDescription => '블록을 선택한 다음 위/아래 화살표로 순서를 옮기세요.';

  @override
  String get reorderBlocksMenuItemLabel => '순서 변경';

  @override
  String get txtImportPickerDialogTitle => '가져올 TXT 파일 선택';

  @override
  String get txtImportReadFailedMessage => 'TXT 파일을 읽을 수 없습니다';

  @override
  String get txtImportEmptyFileMessage => 'TXT 파일이 비어 있습니다';

  @override
  String get txtImportSuccessMessage => 'TXT 파일을 가져왔습니다';

  @override
  String get txtImportMenuItemLabel => '가져오기 (txt)';

  @override
  String get exportMenuItemLabel => '내보내기';

  @override
  String get editorUndoTooltip => '실행 취소';

  @override
  String get editorRedoTooltip => '다시 실행';

  @override
  String get noteSavedMessage => '노트가 저장되었습니다';

  @override
  String get dateAssignPickerHelpText => '노트를 특정 날짜에 지정';

  @override
  String get dateAssignChangeOption => '날짜 변경';

  @override
  String get dateAssignRemoveOption => '지정 해제';

  @override
  String get editorSubToolbarCloseTooltip => '닫기';

  @override
  String get titleFieldHint => '제목';

  @override
  String get textBlockHint => '여기에 노트를 작성하세요...';

  @override
  String get drawingBoardMenuItemLabel => '그림판';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      '음성을 텍스트로 변환하는 기능은 텍스트 노트에서만 사용할 수 있습니다';

  @override
  String get selectionModeCancelTooltip => '선택 취소';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return '$count개 선택됨';
  }

  @override
  String get selectionModeDeleteTooltip => '삭제';

  @override
  String get selectionModeArchiveTooltip => '보관';

  @override
  String get selectionModeFolderTooltip => '폴더';

  @override
  String get searchFieldHint => '노트 검색...';

  @override
  String get emptyTrashDialogTitle => '휴지통 비우기';

  @override
  String get emptyTrashDialogConfirmMessage =>
      '삭제된 모든 노트가 영구적으로 제거됩니다. 계속하시겠습니까?';

  @override
  String get emptyTrashDialogCancelButton => '취소';

  @override
  String get restoreAllMenuItemLabel => '모두 복원';

  @override
  String get sortMenuTooltip => '노트 정렬';

  @override
  String get sortMenuAscendingLabel => '정렬: 오름차순 (A-Z)';

  @override
  String get sortMenuDescendingLabel => '정렬: 내림차순 (Z-A)';

  @override
  String get sortMenuByTitleLabel => '정렬 기준: 제목';

  @override
  String get sortMenuByModifiedDateLabel => '정렬 기준: 마지막 수정일';

  @override
  String get sortMenuByCreatedDateLabel => '정렬 기준: 생성일';

  @override
  String get sortMenuByFolderLabel => '정렬 기준: 폴더';

  @override
  String get viewToggleGridTooltip => '그리드 보기';

  @override
  String get viewToggleListTooltip => '목록 보기';

  @override
  String get drawerHeaderSubtitle => '나만의 개인 노트';

  @override
  String get drawerNotesSectionHeader => '노트';

  @override
  String get drawerAllNotesLabel => '노트';

  @override
  String get drawerFavoritesLabel => '즐겨찾기';

  @override
  String get drawerAgendaLabel => '일정';

  @override
  String get drawerRemindersLabel => '알림';

  @override
  String get drawerLockedLabel => '잠김';

  @override
  String get drawerTrashLabel => '휴지통';

  @override
  String get drawerFoldersSectionHeader => '폴더';

  @override
  String get drawerExpandLabel => '펼치기';

  @override
  String get drawerCollapseLabel => '접기';

  @override
  String get drawerAddFolderLabel => '폴더 추가';

  @override
  String get drawerAppSectionHeader => '앱';

  @override
  String get drawerCalendarLabel => '달력';

  @override
  String get drawerSettingsLabel => '설정';

  @override
  String get drawerBackupRestoreLabel => '백업 및 복원';

  @override
  String get drawerUpgradeToProLabel => 'Pro로 업그레이드';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => '개발 후원하기';

  @override
  String get drawerFeedbackLabel => '피드백';

  @override
  String get drawerAboutLabel => '정보';

  @override
  String get noNotesFoundMessage => '노트를 찾을 수 없습니다.';

  @override
  String get trashRestoreButtonLabel => '복원';

  @override
  String get trashPermanentDeleteButtonLabel => '영구 삭제';

  @override
  String get tagRenamedInfoMessage => '태그 이름이 변경되었습니다';

  @override
  String get tagDeletedInfoMessage => '태그가 삭제되었습니다';

  @override
  String get tagOptionsRenameLabel => '이름 변경';

  @override
  String get tagOptionsDeleteLabel => '삭제';

  @override
  String get renameTagDialogTitle => '태그 이름 변경';

  @override
  String get renameTagDialogHint => '새 태그 이름';

  @override
  String get renameTagDialogCancelButton => '취소';

  @override
  String get renameTagDialogSaveButton => '저장';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '\"$tag\" 태그가 $affectedCount개의 노트에서 제거됩니다. 계속하시겠습니까?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return '\"$tag\" 태그를 삭제하시겠습니까?';
  }

  @override
  String get deleteTagDialogTitle => '태그 삭제';

  @override
  String get deleteTagDialogCancelButton => '취소';

  @override
  String get deleteTagDialogConfirmButton => '삭제';

  @override
  String get tagsSheetTitle => '태그';

  @override
  String get tagsSheetEmptyMessage => '이 노트에는 아직 태그가 없습니다.';

  @override
  String get tagsSheetInputHint => '새 태그 입력...';

  @override
  String get tagsSheetSuggestionsLabel => '기존 태그';

  @override
  String get noteDeletedInfoMessage => '노트가 삭제되었습니다';

  @override
  String get noteDeletedUndoActionLabel => '실행 취소';

  @override
  String get reminderSetInfoMessage => '알림이 설정되었습니다';

  @override
  String get reminderRemovedInfoMessage => '알림이 삭제되었습니다';

  @override
  String get noteDuplicatedInfoMessage => '사본이 생성되었습니다';

  @override
  String get speechTextAppendedInfoMessage => '노트에 텍스트가 추가되었습니다';

  @override
  String get pdfPreparingInfoMessage => 'PDF 준비 중…';

  @override
  String get pdfSavedInfoMessage => 'PDF가 저장되었습니다';

  @override
  String get jpgPreparingInfoMessage => 'JPG 준비 중…';

  @override
  String get jpgSavedInfoMessage => 'JPG가 저장되었습니다';

  @override
  String get jpgFailedInfoMessage => 'JPG를 생성할 수 없습니다';

  @override
  String get txtPreparingInfoMessage => 'TXT 준비 중…';

  @override
  String get txtSavedInfoMessage => 'TXT가 저장되었습니다';

  @override
  String get txtFailedInfoMessage => 'TXT를 생성할 수 없습니다';

  @override
  String get exportOpenActionLabel => '열기';

  @override
  String get wrongPasswordInfoMessage => '비밀번호가 틀렸습니다.';

  @override
  String get noteArchivedInfoMessage => '노트가 보관되었습니다';

  @override
  String get noteUnarchivedInfoMessage => '보관함에서 제거되었습니다';

  @override
  String get noteUnlockedInfoMessage => '잠금이 해제되었습니다';

  @override
  String get noteLockedInfoMessage => '노트가 잠겼습니다';

  @override
  String get notificationUnpinnedInfoMessage => '고정이 해제되었습니다';

  @override
  String get emptyNotePinBlockedInfoMessage => '빈 노트는 고정할 수 없습니다.';

  @override
  String get notificationPinnedInfoMessage => '알림 패널에 고정되었습니다';

  @override
  String get noContentToReadInfoMessage => '읽을 내용이 없습니다';

  @override
  String get backPressExitInfoMessage => '한 번 더 뒤로가기를 누르면 종료됩니다';

  @override
  String get reminderChannelName => '노트 알림';

  @override
  String get reminderChannelDescription => 'Layout 앱의 노트 알림';

  @override
  String get pinnedChannelName => '고정된 노트';

  @override
  String get pinnedChannelDescription => '알림 패널에 고정된 Layout 노트';

  @override
  String get notificationUnpinActionLabel => '제거';

  @override
  String get reminderDefaultTitle => '알림';

  @override
  String get reminderChecklistBodyFallback => '체크리스트를 확인하는 것을 잊지 마세요';

  @override
  String get reminderTextBodyFallback => '노트를 확인하는 것을 잊지 마세요';

  @override
  String get pdfSaveDialogTitle => 'PDF로 저장';

  @override
  String get jpgSaveDialogTitle => 'JPG로 저장';

  @override
  String get txtSaveDialogTitle => 'TXT로 저장';

  @override
  String get textSizeSheetTitle => '글자 크기';

  @override
  String get textSizeSamplePreview => '샘플 텍스트';

  @override
  String get textSizeCancelButton => '취소';

  @override
  String get textSizeApplyButton => '적용';

  @override
  String get createPasswordDialogTitle => '비밀번호 만들기';

  @override
  String get createPasswordNewPasswordHint => '새 비밀번호';

  @override
  String get createPasswordConfirmHint => '비밀번호 다시 입력';

  @override
  String get createPasswordHintQuestionDescription =>
      '비밀번호를 잊어버릴 경우를 대비해 보안 질문을 설정하세요 (선택 사항).';

  @override
  String get createPasswordHintQuestionHint => '보안 질문 선택';

  @override
  String get createPasswordHintAnswerHint => '답변';

  @override
  String get createPasswordCancelButton => '취소';

  @override
  String get createPasswordSaveButton => '저장';

  @override
  String get passwordMismatchMessage => '비밀번호가 일치하지 않습니다!';

  @override
  String get passwordRequiredDialogTitle => '비밀번호 필요';

  @override
  String get passwordRequiredHint => '비밀번호 입력';

  @override
  String get forgotPasswordButtonLabel => '비밀번호를 잊으셨나요';

  @override
  String get passwordRequiredCancelButton => '취소';

  @override
  String get passwordRequiredConfirmButton => '확인';

  @override
  String get securityQuestionDialogTitle => '보안 질문';

  @override
  String get securityQuestionAnswerHint => '답변';

  @override
  String get securityQuestionCancelButton => '취소';

  @override
  String get securityQuestionConfirmButton => '확인';

  @override
  String get securityQuestionWrongAnswerMessage => '답변이 틀렸습니다. 다시 시도하세요.';

  @override
  String get revealedPasswordDialogTitle => '내 비밀번호';

  @override
  String get revealedPasswordLabel => '노트 비밀번호:';

  @override
  String get revealedPasswordOkButton => '확인';

  @override
  String get securityQuestionPetName => '첫 번째 반려동물의 이름은 무엇인가요?';

  @override
  String get securityQuestionFavoriteTeacher => '가장 좋아하는 선생님의 이름은 무엇인가요?';

  @override
  String get securityQuestionBirthCity => '태어난 도시는 어디인가요?';

  @override
  String get securityQuestionFavoriteFood => '가장 좋아하는 음식은 무엇인가요?';

  @override
  String get securityQuestionMotherMaidenName => '어머니의 결혼 전 성함은 무엇인가요?';

  @override
  String get securityQuestionFirstSchool => '처음 다닌 학교의 이름은 무엇인가요?';

  @override
  String get securityQuestionFavoriteColor => '가장 좋아하는 색은 무엇인가요?';

  @override
  String get editFolderDialogTitle => '폴더 편집';

  @override
  String get newSubfolderDialogTitle => '새 하위 폴더';

  @override
  String get addFolderDialogTitle => '폴더 추가';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return '\"$parentCategory\" 안에 생성됩니다';
  }

  @override
  String get subfolderNameFieldLabel => '하위 폴더 이름';

  @override
  String get folderNameFieldLabel => '폴더 이름';

  @override
  String get folderColorLabel => '색상';

  @override
  String get folderDialogCancelButton => '취소';

  @override
  String get folderDialogSaveButton => '저장';

  @override
  String get folderDialogAddButton => '추가';

  @override
  String get selectFolderSheetTitle => '폴더 선택';

  @override
  String get selectFolderAddOptionLabel => '폴더 추가';

  @override
  String get removeCurrentFolderLabel => '현재 폴더 제거';

  @override
  String get noteDetailsDialogTitle => '세부 정보';

  @override
  String get noteDetailsCreatedLabel => '생성일';

  @override
  String get noteDetailsModifiedLabel => '마지막 수정일';

  @override
  String get noteDetailsCharCountLabel => '글자 수';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count자';
  }

  @override
  String get noteDetailsWordCountLabel => '단어 수';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count개 단어';
  }

  @override
  String get noteDetailsOkButton => '확인';

  @override
  String get noteDetailsUnknownDateLabel => '알 수 없음';

  @override
  String get addAttachmentSheetTitle => '추가';

  @override
  String get addAttachmentImageOption => '이미지 추가';

  @override
  String get addAttachmentCameraOption => '카메라';

  @override
  String get addAttachmentFileOption => '파일 추가';

  @override
  String get addAttachmentVoiceOption => '음성 녹음';

  @override
  String get addAttachmentVideoOption => '동영상 녹화';

  @override
  String get addAttachmentScanOption => '문서 스캔';

  @override
  String get noteActionsSheetTitle => '작업 선택';

  @override
  String get noteActionReminderLabel => '알림';

  @override
  String get noteActionEditReminderLabel => '알림 편집';

  @override
  String get noteActionSpeechToTextLabel => '음성을 텍스트로 변환';

  @override
  String get noteActionArchiveLabel => '보관';

  @override
  String get noteActionUnarchiveLabel => '보관함에서 제거';

  @override
  String get noteActionLockLabel => '잠금';

  @override
  String get noteActionUnlockLabel => '잠금 해제';

  @override
  String get noteActionFavoriteLabel => '즐겨찾기';

  @override
  String get noteActionUnfavoriteLabel => '즐겨찾기에서 제거';

  @override
  String get noteActionClassifyLabel => '폴더 선택';

  @override
  String get noteActionDeleteLabel => '삭제';

  @override
  String get noteActionPinToNotificationLabel => '알림 패널에 고정';

  @override
  String get noteActionUnpinFromNotificationLabel => '고정 해제';

  @override
  String get noteActionShareLabel => '공유';

  @override
  String get noteActionDuplicateLabel => '사본 만들기';

  @override
  String get noteActionCopyContentLabel => '내용 복사';

  @override
  String get noteActionTtsLabel => '소리 내어 읽기';

  @override
  String get noteActionTextSizeLabel => '글자 크기';

  @override
  String get noteActionDetailsLabel => '세부 정보';

  @override
  String get noteActionDiscardChangesLabel => '변경 사항 취소';

  @override
  String get noteActionSelectLabel => '선택';

  @override
  String get reminderEditOptionLabel => '알림 변경';

  @override
  String get reminderRemoveOptionLabel => '알림 삭제';

  @override
  String get discardChangesDialogTitle => '변경 사항 취소';

  @override
  String get discardChangesDialogMessage =>
      '이 노트의 저장되지 않은 변경 사항이 사라집니다. 취소하시겠습니까?';

  @override
  String get discardChangesCancelButton => '취소';

  @override
  String get discardChangesConfirmButton => '취소하기';

  @override
  String get pinnedNotificationDefaultTitle => '노트';

  @override
  String get pdfFailedInfoMessage => 'PDF 생성에 실패했습니다';

  @override
  String get drawingScreenTitle => '그림';

  @override
  String get drawingMinimizeTooltip => '최소화';

  @override
  String get drawingEmptyExportWarningMessage => '먼저 그림을 그려주세요';

  @override
  String get drawingEraserPartialModeLabel => '부분';

  @override
  String get drawingEraserFullModeLabel => '전체';

  @override
  String get drawingClearTooltip => '지우기';

  @override
  String get drawingZoomOutTooltip => '축소';

  @override
  String get drawingZoomInTooltip => '확대';

  @override
  String get drawingDeleteTooltip => '삭제';

  @override
  String get drawingEmptyPreviewHint => '탭하여 그리기';

  @override
  String get settingsPageTitle => '설정';

  @override
  String get settingsSectionGeneral => '일반';

  @override
  String get settingsSectionSecurity => '보안';

  @override
  String get settingsSectionTheme => '테마';

  @override
  String get settingsSectionPersonalization => '개인화';

  @override
  String get settingsSectionWidget => '위젯';

  @override
  String get settingsSectionAbout => '정보';

  @override
  String get settingsHintQuestionPet => '첫 번째 반려동물의 이름은 무엇인가요?';

  @override
  String get settingsHintQuestionTeacher => '가장 좋아하는 선생님의 이름은 무엇인가요?';

  @override
  String get settingsHintQuestionBirthCity => '태어난 도시는 어디인가요?';

  @override
  String get settingsHintQuestionFavoriteFood => '가장 좋아하는 음식은 무엇인가요?';

  @override
  String get settingsHintQuestionMotherMaidenName => '어머니의 결혼 전 성함은 무엇인가요?';

  @override
  String get settingsHintQuestionFirstSchool => '처음 다닌 학교는 어디인가요?';

  @override
  String get settingsHintQuestionFavoriteColor => '가장 좋아하는 색은 무엇인가요?';

  @override
  String get settingsSecurityQuestionDialogTitle => '보안 질문';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      '비밀번호를 잊어버린 경우, 이 질문에 올바르게 답하면 비밀번호를 복구할 수 있습니다.';

  @override
  String get settingsSecurityQuestionDropdownHint => '보안 질문 선택';

  @override
  String get settingsSecurityQuestionAnswerHint => '답변';

  @override
  String get settingsSecurityQuestionCancelButton => '취소';

  @override
  String get settingsSecurityQuestionEmptyWarning => '질문과 답변은 비워둘 수 없습니다!';

  @override
  String get settingsSecurityQuestionSaveButton => '저장';

  @override
  String get settingsCreatePasswordTitle => '비밀번호 만들기';

  @override
  String get settingsPasswordRequiredTitle => '비밀번호 필요';

  @override
  String get settingsPasswordEnterHint => '비밀번호 입력';

  @override
  String get settingsForgotPasswordButton => '비밀번호를 잊으셨나요';

  @override
  String get settingsNewPasswordHint => '새 비밀번호';

  @override
  String get settingsConfirmPasswordHint => '비밀번호 다시 입력';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      '비밀번호를 잊어버릴 경우를 대비해 보안 질문을 설정하세요 (선택 사항).';

  @override
  String get settingsPasswordDialogCancelButton => '취소';

  @override
  String get settingsPasswordMismatchWarning => '비밀번호가 일치하지 않습니다!';

  @override
  String get settingsWrongPasswordWarning => '비밀번호가 틀렸습니다!';

  @override
  String get settingsPasswordSaveButton => '저장';

  @override
  String get settingsPasswordRemoveButton => '제거';

  @override
  String get settingsNotePasswordTitle => '노트 비밀번호';

  @override
  String get settingsPasswordSetSubtitle => '비밀번호 설정됨 ✓';

  @override
  String get settingsPasswordNotSetSubtitle => '비밀번호가 설정되지 않음';

  @override
  String get settingsSecurityQuestionTileTitle => '보안 질문';

  @override
  String get settingsSecurityQuestionSetSubtitle => '설정됨 ✓ — 비밀번호를 잊었을 때 사용됩니다';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      '설정되지 않음 — 비밀번호를 분실하면 복구할 수 없습니다';

  @override
  String get settingsThemeDialogTitle => '테마 선택';

  @override
  String get settingsThemeSystemDefault => '시스템 기본값';

  @override
  String get settingsThemeLightOption => '밝은 테마';

  @override
  String get settingsThemeDarkOption => '어두운 테마';

  @override
  String get settingsLanguageDialogTitle => '언어 선택';

  @override
  String get settingsLanguageSystemOption => '시스템';

  @override
  String get settingsAccentColorDialogTitle => '강조 색상 선택';

  @override
  String get settingsThemeChangeTileTitle => '테마 변경';

  @override
  String get settingsThemeLightLabel => '밝게';

  @override
  String get settingsThemeDarkLabel => '어둡게';

  @override
  String get settingsThemeSystemLabel => '시스템';

  @override
  String get settingsLanguageTileTitle => '언어';

  @override
  String get settingsAccentColorTileTitle => '강조 색상';

  @override
  String get settingsAccentColorTileSubtitle => '앱 바, 버튼, 스위치에 사용되는 색상';

  @override
  String get settingsColorfulNotesTitle => '다양한 노트 색상';

  @override
  String get settingsColorfulNotesSubtitle => '각 노트 카드가 서로 다른 색상 톤을 가집니다.';

  @override
  String get settingsTextColorSheetTitle => '글자 색상';

  @override
  String get settingsTextColorSheetDesc => '노트 내용 텍스트의 색상을 설정합니다.';

  @override
  String get settingsTextColorOkButton => '확인';

  @override
  String get settingsTextColorTileTitle => '글자 색상';

  @override
  String get settingsTextColorTileSubtitle => '노트 내용 텍스트의 색상입니다.';

  @override
  String get settingsWidgetFontSizeLabel => '위젯 글자 크기';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return '샘플 제목 - ${size}pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => '취소';

  @override
  String get settingsWidgetFontSizeApplyButton => '적용';

  @override
  String get settingsWidgetOpacityLabel => '배경 투명도';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return '투명도 $percent%';
  }

  @override
  String get settingsWidgetOpacityCancelButton => '취소';

  @override
  String get settingsWidgetOpacityApplyButton => '적용';

  @override
  String get settingsWidgetDarkModeTitle => '어두운 위젯';

  @override
  String get settingsWidgetDarkModeDesc => '위젯에 어두운 색상 구성표를 적용합니다.';

  @override
  String get settingsAboutVersionTitle => '앱 버전';

  @override
  String get settingsFontFamilyTileTitle => '글꼴';

  @override
  String get settingsFontFamilyDefaultLabel => '기본값';

  @override
  String get settingsGlobalFontSizeTileTitle => '글자 크기';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '${size}pt — 모든 노트에 적용됩니다.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return '샘플 텍스트 - ${size}pt';
  }

  @override
  String get settingsGlobalFontSizeApplyToAllLabel => '기존 노트에도 적용';

  @override
  String get settingsGlobalFontSizeApplyToAllNote =>
      '노트에 개별 글자 크기가 설정되어 있으면 이 설정이 적용되지 않습니다.';

  @override
  String get settingsGlobalFontSizeCancelButton => '취소';

  @override
  String get settingsGlobalFontSizeApplyButton => '적용';

  @override
  String get settingsPreviewLinesTileTitle => '노트 미리보기 줄 수';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return '최대 $lines줄까지 표시합니다. 노트가 더 짧으면 실제 줄 수만큼 표시됩니다.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return '현재: $lines줄';
  }

  @override
  String get settingsPreviewLinesDescription =>
      '미리보기에 표시할 최대 줄 수를 설정합니다. 노트의 줄 수가 더 적으면 실제 줄 수만큼 표시됩니다.';

  @override
  String get settingsPreviewLinesCancelButton => '취소';

  @override
  String get settingsPreviewLinesApplyButton => '적용';

  @override
  String get backupCancelButton => '취소';

  @override
  String get backupConnectButton => '연결';

  @override
  String get backupDisconnectButton => '연결 해제';

  @override
  String get backupContinueButton => '계속';

  @override
  String get backupCloseButton => '닫기';

  @override
  String get backupShareButton => '공유';

  @override
  String get backupRestoreButton => '복원';

  @override
  String get backupConfigureButton => '구성';

  @override
  String get backupUnknownDateLabel => '알 수 없음';

  @override
  String get backupProcessingDefaultLabel => '처리 중...';

  @override
  String get backupPermissionRequiredTitle => '저장소 권한 필요';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      '이 안드로이드 버전에서는 백업/복원을 위해 저장소 권한이 필요합니다. 권한이 영구적으로 거부되었으므로 앱 설정에서 직접 활성화해 주세요.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      '이 안드로이드 버전에서는 백업/복원을 위해 저장소 권한이 필요합니다. 계속하려면 권한을 허용해 주세요.';

  @override
  String get backupGoToSettingsButton => '설정으로 이동';

  @override
  String get backupRetryButton => '다시 시도';

  @override
  String get backupDriveConnectingLabel => 'Google 계정에 연결 중...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Google Drive 계정에 연결됨: $email';
  }

  @override
  String get backupDriveConnectedMessage => 'Google Drive 계정에 연결되었습니다.';

  @override
  String get backupDriveConnectFailedMessage =>
      'Google 계정에 연결할 수 없거나 작업이 취소되었습니다.';

  @override
  String get backupDriveDisconnectTitle => 'Google Drive 연결 해제';

  @override
  String get backupDriveDisconnectBody =>
      '연결을 해제하면 Drive로의 수동 또는 자동 백업이 불가능해집니다. Drive에 이미 저장된 백업은 삭제되지 않으며, 이 기기에서의 접근만 제거됩니다.';

  @override
  String get backupDriveDisconnectedMessage => 'Google Drive 연결이 제거되었습니다.';

  @override
  String get backupDriveRequiredTitle => 'Google 계정 필요';

  @override
  String get backupDriveRequiredBody =>
      '이 작업을 수행하려면 Google 계정을 연결해야 합니다. 지금 연결하시겠습니까?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: 연결됨 ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: 연결됨';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: 연결 안 됨';

  @override
  String get backupDriveAuthenticatingLabel => 'Google 계정 확인 중...';

  @override
  String get backupDriveNotSignedInMessage =>
      'Google Drive에 연결되어 있지 않습니다. 먼저 Google 계정으로 로그인해 주세요.';

  @override
  String get backupDriveUploadingLabel => 'Drive에 백업 업로드 중...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Google Drive 업로드가 120초 내에 완료되지 않았습니다 (서버 응답 없음). 연결 상태를 확인하고 다시 시도해 주세요.';

  @override
  String get backupDriveOperationCompletedLabel => '완료됨';

  @override
  String get backupToDriveActionLabel => 'Drive로 백업';

  @override
  String get backupToDeviceActionLabel => '백업';

  @override
  String get backupCreatingLabel => '백업 생성 중...';

  @override
  String backupCreateFailedMessage(String error) {
    return '백업을 생성할 수 없습니다: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Google Drive 업로드에 실패했습니다: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      '백업이 Google Drive에 성공적으로 업로드되었습니다.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return '백업 생성됨: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => '백업 준비 완료';

  @override
  String get backupOfferShareBody =>
      '백업 파일이 기기에 저장되었습니다. 지금 공유하시겠습니까? (예: 클라우드 저장소, 이메일, 다른 기기)';

  @override
  String get backupShareFileText => 'layout 백업 파일';

  @override
  String backupShareFailedMessage(String error) {
    return '공유를 시작할 수 없습니다: $error';
  }

  @override
  String get backupLargeOperationTitle => '대용량 백업';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return '처리할 데이터가 약 $sizeText입니다. 이 정도 크기의 $actionLabel 작업은 기기에 따라 시간이 걸릴 수 있습니다. 작업이 진행되는 동안 앱을 나가지 마세요 — 계속하시겠습니까?';
  }

  @override
  String get backupRestoreActionLabel => '복원';

  @override
  String get backupDriveListingLabel => 'Drive 백업 목록 불러오는 중...';

  @override
  String backupDriveListFailedMessage(String error) {
    return '백업 목록을 불러올 수 없습니다: $error';
  }

  @override
  String get backupDriveNoBackupsMessage => '아직 Google Drive에 백업이 없습니다.';

  @override
  String get backupDrivePickTitle => 'Drive에서 백업 선택';

  @override
  String get backupDriveDownloadingLabel => 'Drive에서 백업 다운로드 중...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Drive에서 백업 다운로드 중... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel => '파일을 기기에 저장 중...';

  @override
  String get backupDriveUnknownBackupFileName => 'unknown_backup.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Google Drive 저장 공간이 가득 찼습니다. Drive에서 공간을 확보한 후 다시 시도해 주세요.';

  @override
  String get backupDriveNetworkErrorMessage =>
      '인터넷 연결을 설정할 수 없습니다. 연결 상태를 확인하고 다시 시도해 주세요.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      '지정한 백업 파일을 Drive에서 찾을 수 없습니다. 삭제되었을 수 있습니다.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Google Drive 작업 중 예기치 않은 오류가 발생했습니다: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return '다운로드에 실패했습니다: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return '파일을 선택할 수 없습니다: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage => '선택한 파일에 접근할 수 없습니다.';

  @override
  String get backupCheckingLabel => '백업 확인 중...';

  @override
  String backupReadFailedMessage(String error) {
    return '백업 파일을 읽을 수 없습니다: $error';
  }

  @override
  String get backupRestoreConfirmTitle => '백업 복원';

  @override
  String get backupPreviewContentsHeader => '선택한 백업의 내용:';

  @override
  String get backupPreviewNoteCountLabel => '노트 수';

  @override
  String get backupPreviewTrashCountLabel => '휴지통의 노트';

  @override
  String get backupPreviewCategoryCountLabel => '카테고리 수';

  @override
  String get backupPreviewAttachmentLabel => '첨부파일';

  @override
  String get backupPreviewAttachmentNoneValue => '없음';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '파일 $count개 ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => '생성일';

  @override
  String get backupEmptyPreviewTitle => '이 백업은 비어 있는 것 같습니다';

  @override
  String get backupEmptyPreviewBody =>
      '선택한 파일에서 노트, 카테고리 또는 첨부파일을 찾을 수 없습니다. 계속하면 현재 데이터가 삭제되고 이 빈 백업으로 교체됩니다.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '백업에서 첨부파일 $count개를 찾을 수 없음';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return '이 파일이 포함된 노트는 복원되지만 첨부파일 없이 복원됩니다 (백업 시점에 파일이 누락되었거나 손상되었을 수 있습니다): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown 외 $remaining개 더';
  }

  @override
  String get backupRestoreConfirmBody =>
      '이 작업은 현재의 모든 노트, 휴지통, 카테고리, 설정, 첨부파일을 위 백업의 데이터로 교체합니다. 현재 데이터는 영구적으로 사라지며 이 작업은 되돌릴 수 없습니다.';

  @override
  String get backupRestoringLabel => '백업 복원 중...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return '백업이 복원되었습니다. 다만 첨부파일 $count개는 백업에서 찾을 수 없어 복원되지 않았습니다. 변경 사항을 완전히 적용하려면 앱을 재시작하는 것을 권장합니다.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      '백업이 성공적으로 복원되었습니다. 변경 사항을 완전히 적용하려면 앱을 재시작하는 것을 권장합니다.';

  @override
  String backupRestoreFailedMessage(String error) {
    return '복원 중 오류가 발생했습니다: $error';
  }

  @override
  String get backupScreenTitle => '백업 및 복원';

  @override
  String get backupBlockedExitWarningMessage => '작업이 진행 중입니다. 완료될 때까지 기다려 주세요.';

  @override
  String get backupBusyBackTooltip => '작업 진행 중';

  @override
  String get backupIntroText =>
      '노트, 카테고리, 설정, 첨부파일을 하나의 .zip 파일로 백업하거나 이전에 만든 백업을 복원할 수 있습니다.';

  @override
  String get backupDriveCardTitle => 'Google Drive에 백업';

  @override
  String get backupDriveCardSubtitle =>
      '새 백업을 만들어 Google Drive의 비공개 영역에 직접 업로드합니다.';

  @override
  String get backupDriveCardButtonLabel => 'Drive에 백업';

  @override
  String get backupDeviceCardTitle => '기기에 백업';

  @override
  String get backupDeviceCardSubtitle =>
      '모든 데이터를 하나의 .zip 파일로 기기에 저장하고 원하는 경우 공유하세요.';

  @override
  String get backupDeviceCardButtonLabel => '기기에 백업';

  @override
  String get backupHistoryCardTitle => '백업 기록';

  @override
  String get backupHistoryCardSubtitle =>
      '기기에 저장된 모든 백업을 날짜와 크기와 함께 확인하세요. 여기서 바로 공유, 복원 또는 삭제할 수 있습니다.';

  @override
  String get backupHistoryTabDevice => '기기';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => '백업 삭제';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return '\"$fileName\" 백업 파일을 영구적으로 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => '백업이 삭제되었습니다.';

  @override
  String get backupHistoryDriveDeleteDialogTitle => 'Drive 백업 삭제';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return '\"$fileName\" 백업을 Google Drive에서 영구적으로 삭제하시겠습니까? 이 작업은 되돌릴 수 없으며 파일이 휴지통으로 이동하지 않습니다.';
  }

  @override
  String get backupHistoryDriveDeletedMessage => 'Drive 백업이 삭제되었습니다.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return '삭제할 수 없습니다: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle => '이 기기에 저장된 백업이 아직 없습니다.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      '\"기기에 백업\"을 사용해 첫 백업을 만들어보세요.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      '\"Google Drive에 백업\"을 사용해 첫 클라우드 백업을 만들어보세요.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Google 계정을 연결하면 Drive 백업을 확인할 수 있습니다.';

  @override
  String get backupHistoryConnectGoogleButton => 'Google로 연결';

  @override
  String get backupHistoryDriveConnectedFallback => '연결됨';

  @override
  String get backupHistoryUnknownErrorFallback => '알 수 없는 오류가 발생했습니다.';

  @override
  String get backupHistoryDownloadStartingLabel => '시작 중...';

  @override
  String get backupAutoBackupEnabledLabel => '자동 백업: 켜짐';

  @override
  String get backupAutoBackupDisabledLabel => '자동 백업: 꺼짐';

  @override
  String get backupOverlayWarningMessage => '작업이 완료될 때까지 앱을 나가지 말고 기다려 주세요.';

  @override
  String get pdfExportUntitledNoteLabel => '제목 없는 노트';

  @override
  String get pdfExportDefaultAttachmentName => '첨부파일';

  @override
  String get pdfExportDefaultFileName => 'note';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      '스크린샷을 캡처할 수 없습니다 (경계를 찾을 수 없음)';

  @override
  String get screenshotExportByteDataNullMessage => '스크린샷 데이터를 생성할 수 없습니다';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      '이미지를 처리할 수 없습니다 (PNG 디코딩 실패)';

  @override
  String get screenshotCalcTableTotalLabel => '합계';

  @override
  String get gundemMenuRemoveFromAgenda => '일정에서 제거';

  @override
  String get gundemMenuDeleteNote => '노트 삭제';

  @override
  String get gundemSectionOverdue => '기한 지남';

  @override
  String get gundemSectionToday => '오늘';

  @override
  String get gundemSectionTomorrow => '내일';

  @override
  String get gundemSectionNextWeek => '다음 주';

  @override
  String get gundemSectionFurther => '그 이후';

  @override
  String get gundemWeekdayMonday => '월요일';

  @override
  String get gundemWeekdayTuesday => '화요일';

  @override
  String get gundemWeekdayWednesday => '수요일';

  @override
  String get gundemWeekdayThursday => '목요일';

  @override
  String get gundemWeekdayFriday => '금요일';

  @override
  String get gundemWeekdaySaturday => '토요일';

  @override
  String get gundemWeekdaySunday => '일요일';

  @override
  String get gundemAppBarTitle => '일정';

  @override
  String get gundemCalendarTooltip => '달력';

  @override
  String get gundemEmptyTitle => '일정에 아무것도 없습니다';

  @override
  String get gundemEmptySubtitle => '알림이나 날짜가 지정된 노트가 여기에 표시됩니다.';

  @override
  String get gundemUntitledNote => '제목 없는 노트';

  @override
  String get gundemRepeatHourly => '매시간';

  @override
  String get gundemRepeatDaily => '매일';

  @override
  String get gundemRepeatWeekly => '매주';

  @override
  String get gundemRepeatMonthly => '매월';

  @override
  String get gundemRepeatYearly => '매년';

  @override
  String get gundemPreviewCalcTableLabel => '[계산 목록]';

  @override
  String get gundemPreviewDrawingLabel => '[그림]';

  @override
  String get gundemPreviewImageLabel => '[이미지]';

  @override
  String get gundemMonthShortJan => '1월';

  @override
  String get gundemMonthShortFeb => '2월';

  @override
  String get gundemMonthShortMar => '3월';

  @override
  String get gundemMonthShortApr => '4월';

  @override
  String get gundemMonthShortMay => '5월';

  @override
  String get gundemMonthShortJun => '6월';

  @override
  String get gundemMonthShortJul => '7월';

  @override
  String get gundemMonthShortAug => '8월';

  @override
  String get gundemMonthShortSep => '9월';

  @override
  String get gundemMonthShortOct => '10월';

  @override
  String get gundemMonthShortNov => '11월';

  @override
  String get gundemMonthShortDec => '12월';

  @override
  String get calendarAppBarTitle => '달력';

  @override
  String get calendarTodayButton => '오늘';

  @override
  String get calendarLegendNoteLabel => '노트';

  @override
  String get calendarLegendReminderLabel => '알림';

  @override
  String get calendarTodayBadge => '오늘';

  @override
  String get calendarEmptyDayMessage => '이 날짜에는 노트나 알림이 없습니다.';

  @override
  String get calendarReminderHourlyLabel => '매시간';

  @override
  String get calendarMonthJan => '1월';

  @override
  String get calendarMonthFeb => '2월';

  @override
  String get calendarMonthMar => '3월';

  @override
  String get calendarMonthApr => '4월';

  @override
  String get calendarMonthMay => '5월';

  @override
  String get calendarMonthJun => '6월';

  @override
  String get calendarMonthJul => '7월';

  @override
  String get calendarMonthAug => '8월';

  @override
  String get calendarMonthSep => '9월';

  @override
  String get calendarMonthOct => '10월';

  @override
  String get calendarMonthNov => '11월';

  @override
  String get calendarMonthDec => '12월';

  @override
  String get calendarWeekdayShortMon => '월';

  @override
  String get calendarWeekdayShortTue => '화';

  @override
  String get calendarWeekdayShortWed => '수';

  @override
  String get calendarWeekdayShortThu => '목';

  @override
  String get calendarWeekdayShortFri => '금';

  @override
  String get calendarWeekdayShortSat => '토';

  @override
  String get calendarWeekdayShortSun => '일';

  @override
  String get calendarWeekdayFullMonday => '월요일';

  @override
  String get calendarWeekdayFullTuesday => '화요일';

  @override
  String get calendarWeekdayFullWednesday => '수요일';

  @override
  String get calendarWeekdayFullThursday => '목요일';

  @override
  String get calendarWeekdayFullFriday => '금요일';

  @override
  String get calendarWeekdayFullSaturday => '토요일';

  @override
  String get calendarWeekdayFullSunday => '일요일';

  @override
  String get wrongPasswordDialogTitle => '잘못된 비밀번호';

  @override
  String get wrongPasswordDialogMessage => '입력한 비밀번호가 올바르지 않습니다.';

  @override
  String get commonOkButton => '확인';

  @override
  String get unlockCategoryAction => '잠금 해제';

  @override
  String get lockCategoryAction => '잠금';

  @override
  String get categoryUnlockedMessage => '잠금이 해제되었습니다';

  @override
  String get categoryLockedMessage => '폴더가 잠겼습니다';

  @override
  String get deleteFolderMenuItemLabel => '폴더 삭제';

  @override
  String get deleteFolderDialogTitle => '폴더 삭제';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return '\"$category\" 폴더와 모든 하위 폴더를 삭제하시겠습니까? 이 폴더의 노트는 분류되지 않은 상태가 됩니다.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return '\"$category\" 폴더를 삭제하시겠습니까? 이 폴더의 노트는 분류되지 않은 상태가 됩니다.';
  }

  @override
  String get deleteFolderDialogCancelButton => '취소';

  @override
  String get deleteFolderDialogConfirmButton => '삭제';

  @override
  String get editCategoryNameColorMenuItemLabel => '이름/색상 편집';

  @override
  String get addSubfolderMenuItemLabel => '하위 폴더 만들기';

  @override
  String get expandSubfoldersMenuItemLabel => '하위 폴더 펼치기';

  @override
  String get collapseSubfoldersMenuItemLabel => '하위 폴더 접기';

  @override
  String saveErrorInfoMessage(String error) {
    return '저장 오류: $error';
  }

  @override
  String get welcomeNoteTitle => 'Layout에 오신 것을 환영합니다! 🚀';

  @override
  String get welcomeNoteContent => '새로운 기능이 추가되었습니다!';

  @override
  String get noteListDateGroupToday => '오늘';

  @override
  String get noteListDateGroupYesterday => '어제';

  @override
  String get noteListDateGroupLast7Days => '최근 7일';

  @override
  String get noteListDateGroupLast30Days => '최근 30일';

  @override
  String get reminderRepeatNoneLabel => '반복 없음';

  @override
  String get voiceRecorderPreparingLabel => '준비 중…';

  @override
  String get voiceRecorderCancelButton => '취소';

  @override
  String get voiceRecorderStopAddButton => '중지하고 추가';

  @override
  String get speechToTextMicPermissionDeniedMessage => '마이크 권한이 허용되지 않았습니다.';

  @override
  String get speechToTextUnavailableMessage => '이 기기에서는 음성 인식을 사용할 수 없습니다.';

  @override
  String get speechToTextPreparingLabel => '준비 중…';

  @override
  String get speechToTextListeningLabel => '듣는 중…';

  @override
  String get speechToTextStartSpeakingPlaceholder => '말하기 시작하세요…';

  @override
  String get speechToTextCancelButton => '취소';

  @override
  String get speechToTextStopAddButton => '중지하고 추가';

  @override
  String get textToSpeechNoContentMessage => '읽을 내용이 없습니다.';

  @override
  String get textToSpeechReadErrorMessage => '읽는 중 오류가 발생했습니다.';

  @override
  String get textToSpeechUnavailableMessage => '이 기기에서는 텍스트 음성 변환을 사용할 수 없습니다.';

  @override
  String get textToSpeechPreparingLabel => '준비 중…';

  @override
  String get textToSpeechPausedLabel => '일시 정지됨';

  @override
  String get textToSpeechFinishedLabel => '읽기 완료';

  @override
  String get textToSpeechReadingLabel => '읽는 중…';

  @override
  String get textToSpeechCloseErrorButton => '닫기';

  @override
  String get textToSpeechReplayButton => '다시 읽기';

  @override
  String get textToSpeechCloseFinishedButton => '닫기';

  @override
  String get textToSpeechPauseButton => '일시 정지';

  @override
  String get textToSpeechResumeButton => '재개';

  @override
  String get textToSpeechStopButton => '중지';

  @override
  String get textToSpeechSpeedSlow => '느리게';

  @override
  String get textToSpeechSpeedNormal => '보통';

  @override
  String get textToSpeechSpeedFast => '빠르게';

  @override
  String get calendarPickerCancelButton => '취소';

  @override
  String get calendarPickerConfirmButton => '선택';

  @override
  String get calendarPickerClearButton => '지우기';

  @override
  String get reminderPickerDialogTitle => '알림 추가';

  @override
  String get reminderPickerDateTodayOption => '오늘';

  @override
  String get reminderPickerDateTomorrowOption => '내일';

  @override
  String get reminderPickerDatePickOption => '날짜 선택';

  @override
  String get reminderRepeatHourlyLabel => '매시간';

  @override
  String get reminderRepeatDailyLabel => '매일';

  @override
  String get reminderRepeatWeeklyLabel => '매주';

  @override
  String get reminderRepeatMonthlyLabel => '매월';

  @override
  String get reminderRepeatYearlyLabel => '매년';

  @override
  String get reminderPickerCalendarHelpText => '알림 날짜 선택';

  @override
  String get reminderPickerCancelButton => '취소';

  @override
  String get reminderPickerSaveButton => '저장';

  @override
  String get reminderPickerPastTimeErrorMessage => '과거 시간은 선택할 수 없습니다';

  @override
  String calcTableTotalLabel(String amount) {
    return '합계: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => '데이터 준비 중...';

  @override
  String get backupCreatePackagingNotesLabel => '노트와 카테고리 패키징 중...';

  @override
  String get backupCreateReadingAttachmentsLabel => '첨부파일 읽는 중...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return '첨부파일 읽는 중... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'zip 파일 압축 중...';

  @override
  String get backupCreateSavingFileLabel => '파일 저장 중...';

  @override
  String get backupRestoreValidatingLabel => '백업 확인 중...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      '백업 확인 완료, 데이터 준비 중...';

  @override
  String get backupRestoreWritingNotesLabel => '노트 쓰는 중...';

  @override
  String get backupRestoreWritingTrashLabel => '휴지통 쓰는 중...';

  @override
  String get backupRestoreTrashWrittenLabel => '휴지통 저장 완료';

  @override
  String get backupRestoreWritingCategoriesLabel => '카테고리 쓰는 중...';

  @override
  String get backupRestoreCategoriesWrittenLabel => '카테고리 저장 완료';

  @override
  String get backupRestoreWritingSettingsLabel => '설정 쓰는 중...';

  @override
  String get backupRestoreSettingsWrittenLabel => '설정 저장 완료';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel => '이전 첨부파일 정리 중...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel => '첨부파일이 없습니다. 마무리 중...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return '첨부파일 복원 중... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => '완료됨';

  @override
  String get backupValidationCorruptedFileMessage =>
      '파일이 손상되었거나 유효한 백업 파일이 아닙니다.';

  @override
  String get backupValidationMissingDataMessage =>
      '백업 파일 안에서 데이터를 찾을 수 없습니다 (backup_data.json이 없음).';

  @override
  String get backupValidationInvalidJsonMessage =>
      '백업 데이터를 읽을 수 없습니다 (손상된 JSON).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      '이 파일은 layout 앱의 백업이 아닙니다.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      '백업 파일의 버전 정보를 읽을 수 없습니다.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      '이 백업은 현재 앱 버전에서 지원하지 않는 최신 형식입니다. 앱을 업데이트해 주세요.';

  @override
  String get backupValidationInvalidVersionMessage =>
      '백업 파일의 버전 정보가 유효하지 않습니다.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      '백업 데이터가 예상된 형식이 아닙니다 (notes 필드가 없음).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      '백업 데이터가 예상된 형식이 아닙니다 (trash 필드가 없음).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      '백업 데이터가 예상된 형식이 아닙니다 (카테고리 목록이 유효하지 않음).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      '백업 데이터가 예상된 형식이 아닙니다 (설정 필드가 유효하지 않음).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      '백업 데이터가 예상된 형식이 아닙니다 (노트 레코드가 유효하지 않음).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      '백업 데이터가 예상된 형식이 아닙니다 (ID가 없는 노트 레코드가 발견됨).';

  @override
  String get backupValidationFileNotFoundMessage => '백업 파일을 찾을 수 없습니다.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      '기기의 여유 저장 공간이 부족합니다. 공간을 확보한 후 다시 시도해 주세요.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      '파일 접근 권한이 거부되었습니다. 앱 권한을 확인하고 다시 시도해 주세요.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return '파일 작업 중 오류가 발생했습니다: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return '예기치 않은 오류가 발생했습니다: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'zip 압축 파일을 생성할 수 없습니다 (ZipEncoder가 null을 반환함).';

  @override
  String get calcTableMenuItemLabel => '계산 목록';

  @override
  String get tagsMenuItemLabel => '태그';

  @override
  String get linkDialogUrlHint => 'https://example.com';

  @override
  String get checklistItemHint => '항목 추가...';

  @override
  String get toolbarHighlightTooltip => '형광펜';

  @override
  String get toolbarListTooltip => '목록';

  @override
  String get toolbarHideKeyboardTooltip => '키보드 숨기기';

  @override
  String get autoBackupLocalSuccessMessage => '로컬 백업이 완료되었습니다.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return '로컬 백업에 실패했습니다: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Drive 백업이 건너뛰어졌습니다: Google 계정이 연결되지 않았거나 세션이 만료되었습니다. 앱을 열어 다시 연결해 주세요.';

  @override
  String get autoBackupDriveSuccessMessage => 'Drive 백업이 완료되었습니다.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Drive 백업에 실패했습니다: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => '아직 노트가 없습니다';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return '합계: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ 그림';

  @override
  String get autoBackupSettingsAppBarTitle => '자동 백업 설정';

  @override
  String get autoBackupSettingsMainSwitchTitle => '자동 백업 사용';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      '노트가 백그라운드에서 주기적으로 안전하게 백업됩니다.';

  @override
  String get autoBackupSettingsTargetTitle => '백업 대상';

  @override
  String get autoBackupSettingsTargetSubtitle => '백업을 저장할 위치를 선택하세요.';

  @override
  String get autoBackupSettingsTargetLocalOption => '로컬';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => '둘 다';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Google Drive 옵션을 사용하려면 먼저 계정을 연결하세요.';

  @override
  String get autoBackupSettingsConnectButton => '연결';

  @override
  String get autoBackupSettingsFrequencyTitle => '백업 주기';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return '$hours시간마다 백업이 생성됩니다.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6시간';

  @override
  String get autoBackupSettingsFrequency12h => '12시간';

  @override
  String get autoBackupSettingsFrequency24h => '24시간 (매일)';

  @override
  String get autoBackupSettingsFrequency48h => '48시간 (2일)';

  @override
  String get autoBackupSettingsFrequency168h => '168시간 (매주)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Wi-Fi에서만 사용';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      '모바일 데이터를 보호하기 위해 클라우드 업로드는 Wi-Fi에서만 이루어집니다.';

  @override
  String get autoBackupSettingsStatusCardTitle => '시스템 상태';

  @override
  String get autoBackupSettingsNeverRunMessage => '자동 백업이 아직 실행되지 않았습니다.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return '마지막 실행: $date $time ($status)\n메시지: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => '성공';

  @override
  String get autoBackupSettingsStatusFailedLabel => '실패';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Google 계정에 연결할 수 없습니다.';

  @override
  String get autoBackupSettingsSavedSnackbar => '자동 백업 설정이 업데이트되었습니다.';

  @override
  String selectionModeDeletedMessage(int count) {
    return '노트 $count개가 삭제되었습니다';
  }

  @override
  String get selectionModeArchivedMessage => '보관되었습니다';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return '노트 $count개의 카테고리 선택';
  }

  @override
  String get selectionModeAddCategoryOption => '카테고리 추가';

  @override
  String get selectionModeRemoveCategoryOption => '카테고리 제거';

  @override
  String get calcTableItemHint => '항목...';

  @override
  String get calcTableTotalRowLabel => '합계';

  @override
  String get textSelectionMenuShareButton => '공유';

  @override
  String get textSelectionMenuTranslateButton => '번역';

  @override
  String get textSelectionMenuShareFailedSnackbar => '공유를 시작할 수 없습니다.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar => '번역을 열 수 없습니다.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return '오늘 $time';
  }

  @override
  String lastBackupInfoDateFormat(
    String day,
    String month,
    int year,
    String time,
  ) {
    return '$year. $month. $day. $time';
  }

  @override
  String lastBackupInfoLabel(String date) {
    return '마지막 백업: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage => '아직 백업이 없습니다.';

  @override
  String get backupFileNameLabel => '백업';
}
