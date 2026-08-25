// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'Đậm';

  @override
  String get toolbarItalicTooltip => 'Nghiêng';

  @override
  String get toolbarUnderlineTooltip => 'Gạch chân';

  @override
  String get toolbarStrikethroughTooltip => 'Gạch ngang';

  @override
  String get toolbarFontSizeTooltip => 'Cỡ chữ';

  @override
  String get toolbarColorTooltip => 'Màu chữ';

  @override
  String get toolbarBulletTooltip => 'Danh sách gạch đầu dòng';

  @override
  String get toolbarNumberTooltip => 'Danh sách đánh số';

  @override
  String get toolbarIndentTooltip => 'Thụt lề đoạn văn';

  @override
  String get toolbarLinkTooltip => 'Thêm / Sửa / Xóa liên kết';

  @override
  String get toolbarDividerTooltip => 'Chèn đường phân cách';

  @override
  String get toolbarChecklistTooltip => 'Thêm danh sách việc cần làm';

  @override
  String get linkSelectTextSnackbar =>
      'Trước tiên hãy chọn văn bản bạn muốn liên kết';

  @override
  String get linkDialogEditTitle => 'Sửa liên kết';

  @override
  String get linkDialogAddTitle => 'Thêm liên kết';

  @override
  String get linkDialogRemoveButton => 'Xóa liên kết';

  @override
  String get linkDialogCancelButton => 'Hủy';

  @override
  String get linkDialogConfirmButton => 'Thêm';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Quyền truy cập máy ảnh bị từ chối. Bạn cần cho phép trong cài đặt để quay video.';

  @override
  String get cameraPermissionRequiredMessage =>
      'Cần có quyền truy cập máy ảnh để quay video.';

  @override
  String get openSettingsButtonLabel => 'Cài đặt';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'Không thể bắt đầu quét: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'Nhận dạng văn bản thất bại: $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'Không tìm thấy văn bản có thể đọc được trong tài liệu';

  @override
  String get scanResultSheetTitle => 'Thêm tài liệu đã quét như thế nào?';

  @override
  String get scanResultTextOnlyOption => 'Chỉ thêm dưới dạng văn bản';

  @override
  String get scanResultTextAndImageOption => 'Thêm văn bản + ảnh đã quét';

  @override
  String get scanResultCancelOption => 'Hủy';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'Quyền truy cập micrô bị từ chối. Bạn cần cho phép trong cài đặt để ghi âm.';

  @override
  String get audioPermissionRequiredMessage =>
      'Cần có quyền truy cập micrô để ghi âm.';

  @override
  String get voiceRecordingDefaultLabel => 'Ghi âm giọng nói';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'Bảng tính ($count dòng)';
  }

  @override
  String get blockPreviewDrawingLabel => 'Bản vẽ';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count tệp đính kèm (ảnh/tài liệu)';
  }

  @override
  String get blockPreviewDividerLabel => 'Đường phân cách';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'Danh sách việc cần làm ($count mục)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(văn bản trống)';

  @override
  String get reorderBlocksSheetTitle => 'Sắp xếp lại khối';

  @override
  String get reorderBlocksMoveUpTooltip => 'Di chuyển lên';

  @override
  String get reorderBlocksMoveDownTooltip => 'Di chuyển xuống';

  @override
  String get reorderBlocksCloseTooltip => 'Đóng';

  @override
  String get reorderBlocksDescription =>
      'Chạm vào một khối để chọn, sau đó dùng mũi tên lên/xuống để di chuyển.';

  @override
  String get reorderBlocksMenuItemLabel => 'Sắp xếp lại';

  @override
  String get txtImportPickerDialogTitle => 'Chọn tệp TXT để nhập';

  @override
  String get txtImportReadFailedMessage => 'Không thể đọc tệp TXT';

  @override
  String get txtImportEmptyFileMessage => 'Tệp TXT trống';

  @override
  String get txtImportSuccessMessage => 'Đã nhập TXT';

  @override
  String get txtImportMenuItemLabel => 'Nhập (txt)';

  @override
  String get exportMenuItemLabel => 'Xuất';

  @override
  String get editorUndoTooltip => 'Hoàn tác';

  @override
  String get editorRedoTooltip => 'Làm lại';

  @override
  String get noteSavedMessage => 'Đã lưu ghi chú';

  @override
  String get dateAssignPickerHelpText => 'Gán ghi chú cho một ngày';

  @override
  String get dateAssignChangeOption => 'Đổi ngày';

  @override
  String get dateAssignRemoveOption => 'Bỏ gán';

  @override
  String get editorSubToolbarCloseTooltip => 'Đóng';

  @override
  String get titleFieldHint => 'Tiêu đề';

  @override
  String get textBlockHint => 'Viết ghi chú của bạn ở đây...';

  @override
  String get drawingBoardMenuItemLabel => 'Bảng vẽ';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'Chuyển giọng nói thành văn bản chỉ khả dụng cho ghi chú văn bản';

  @override
  String get selectionModeCancelTooltip => 'Hủy chọn';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return 'Đã chọn $count';
  }

  @override
  String get selectionModeDeleteTooltip => 'Xóa';

  @override
  String get selectionModeArchiveTooltip => 'Lưu trữ';

  @override
  String get selectionModeFolderTooltip => 'Thư mục';

  @override
  String get searchFieldHint => 'Tìm kiếm ghi chú...';

  @override
  String get emptyTrashDialogTitle => 'Dọn sạch thùng rác';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'Tất cả ghi chú đã xóa sẽ bị xóa vĩnh viễn. Bạn có chắc chắn không?';

  @override
  String get emptyTrashDialogCancelButton => 'Hủy';

  @override
  String get restoreAllMenuItemLabel => 'Khôi phục tất cả';

  @override
  String get sortMenuTooltip => 'Sắp xếp ghi chú';

  @override
  String get sortMenuAscendingLabel => 'Thứ tự: Tăng dần (A-Z)';

  @override
  String get sortMenuDescendingLabel => 'Thứ tự: Giảm dần (Z-A)';

  @override
  String get sortMenuByTitleLabel => 'Sắp xếp theo: Tiêu đề';

  @override
  String get sortMenuByModifiedDateLabel => 'Sắp xếp theo: Sửa đổi gần nhất';

  @override
  String get sortMenuByCreatedDateLabel => 'Sắp xếp theo: Ngày tạo';

  @override
  String get sortMenuByFolderLabel => 'Sắp xếp theo: Thư mục';

  @override
  String get viewToggleGridTooltip => 'Xem dạng lưới';

  @override
  String get viewToggleListTooltip => 'Xem dạng danh sách';

  @override
  String get drawerHeaderSubtitle => 'Sổ tay cá nhân của bạn';

  @override
  String get drawerNotesSectionHeader => 'GHI CHÚ';

  @override
  String get drawerAllNotesLabel => 'Ghi chú';

  @override
  String get drawerFavoritesLabel => 'Yêu thích';

  @override
  String get drawerAgendaLabel => 'Lịch trình';

  @override
  String get drawerRemindersLabel => 'Nhắc nhở';

  @override
  String get drawerLockedLabel => 'Đã khóa';

  @override
  String get drawerTrashLabel => 'Thùng rác';

  @override
  String get drawerFoldersSectionHeader => 'THƯ MỤC';

  @override
  String get drawerExpandLabel => 'Mở rộng';

  @override
  String get drawerCollapseLabel => 'Thu gọn';

  @override
  String get drawerAddFolderLabel => 'Thêm thư mục';

  @override
  String get drawerAppSectionHeader => 'ỨNG DỤNG';

  @override
  String get drawerCalendarLabel => 'Lịch';

  @override
  String get drawerSettingsLabel => 'Cài đặt';

  @override
  String get drawerBackupRestoreLabel => 'Sao lưu & Khôi phục';

  @override
  String get drawerUpgradeToProLabel => 'Nâng cấp lên Pro';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'Ủng hộ phát triển';

  @override
  String get drawerFeedbackLabel => 'Phản hồi';

  @override
  String get drawerAboutLabel => 'Giới thiệu';

  @override
  String get noNotesFoundMessage => 'Không tìm thấy ghi chú nào.';

  @override
  String get trashRestoreButtonLabel => 'Khôi phục';

  @override
  String get trashPermanentDeleteButtonLabel => 'Xóa vĩnh viễn';

  @override
  String get tagRenamedInfoMessage => 'Đã đổi tên thẻ';

  @override
  String get tagDeletedInfoMessage => 'Đã xóa thẻ';

  @override
  String get tagOptionsRenameLabel => 'Đổi tên';

  @override
  String get tagOptionsDeleteLabel => 'Xóa';

  @override
  String get renameTagDialogTitle => 'Đổi tên thẻ';

  @override
  String get renameTagDialogHint => 'Tên thẻ mới';

  @override
  String get renameTagDialogCancelButton => 'Hủy';

  @override
  String get renameTagDialogSaveButton => 'Lưu';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '\"$tag\" sẽ bị xóa khỏi $affectedCount ghi chú. Tiếp tục?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'Xóa thẻ \"$tag\"?';
  }

  @override
  String get deleteTagDialogTitle => 'Xóa thẻ';

  @override
  String get deleteTagDialogCancelButton => 'Hủy';

  @override
  String get deleteTagDialogConfirmButton => 'Xóa';

  @override
  String get tagsSheetTitle => 'Thẻ';

  @override
  String get tagsSheetEmptyMessage => 'Ghi chú này chưa có thẻ nào.';

  @override
  String get tagsSheetInputHint => 'Nhập thẻ mới...';

  @override
  String get tagsSheetSuggestionsLabel => 'Thẻ hiện có';

  @override
  String get noteDeletedInfoMessage => 'Đã xóa ghi chú';

  @override
  String get noteDeletedUndoActionLabel => 'Hoàn tác';

  @override
  String get reminderSetInfoMessage => 'Đã đặt nhắc nhở';

  @override
  String get reminderRemovedInfoMessage => 'Đã xóa nhắc nhở';

  @override
  String get noteDuplicatedInfoMessage => 'Đã tạo bản sao';

  @override
  String get speechTextAppendedInfoMessage => 'Đã thêm văn bản vào ghi chú';

  @override
  String get pdfPreparingInfoMessage => 'Đang chuẩn bị PDF…';

  @override
  String get pdfSavedInfoMessage => 'Đã lưu PDF';

  @override
  String get jpgPreparingInfoMessage => 'Đang chuẩn bị JPG…';

  @override
  String get jpgSavedInfoMessage => 'Đã lưu JPG';

  @override
  String get jpgFailedInfoMessage => 'Không thể tạo JPG';

  @override
  String get txtPreparingInfoMessage => 'Đang chuẩn bị TXT…';

  @override
  String get txtSavedInfoMessage => 'Đã lưu TXT';

  @override
  String get txtFailedInfoMessage => 'Không thể tạo TXT';

  @override
  String get exportOpenActionLabel => 'Mở';

  @override
  String get wrongPasswordInfoMessage => 'Sai mật khẩu.';

  @override
  String get noteArchivedInfoMessage => 'Đã lưu trữ ghi chú';

  @override
  String get noteUnarchivedInfoMessage => 'Đã bỏ khỏi lưu trữ';

  @override
  String get noteUnlockedInfoMessage => 'Đã mở khóa';

  @override
  String get noteLockedInfoMessage => 'Đã khóa ghi chú';

  @override
  String get notificationUnpinnedInfoMessage => 'Đã bỏ ghim';

  @override
  String get emptyNotePinBlockedInfoMessage => 'Không thể ghim ghi chú trống.';

  @override
  String get notificationPinnedInfoMessage => 'Đã ghim vào bảng thông báo';

  @override
  String get noContentToReadInfoMessage => 'Không có nội dung để đọc';

  @override
  String get backPressExitInfoMessage => 'Nhấn lại để thoát';

  @override
  String get reminderChannelName => 'Nhắc nhở ghi chú';

  @override
  String get reminderChannelDescription =>
      'Nhắc nhở ghi chú trong ứng dụng Layout';

  @override
  String get pinnedChannelName => 'Ghi chú đã ghim';

  @override
  String get pinnedChannelDescription =>
      'Ghi chú Layout được ghim vào bảng thông báo';

  @override
  String get notificationUnpinActionLabel => 'Xóa';

  @override
  String get reminderDefaultTitle => 'Nhắc nhở';

  @override
  String get reminderChecklistBodyFallback =>
      'Đừng quên kiểm tra danh sách việc cần làm của bạn';

  @override
  String get reminderTextBodyFallback => 'Đừng quên kiểm tra ghi chú của bạn';

  @override
  String get pdfSaveDialogTitle => 'Lưu dưới dạng PDF';

  @override
  String get jpgSaveDialogTitle => 'Lưu dưới dạng JPG';

  @override
  String get txtSaveDialogTitle => 'Lưu dưới dạng TXT';

  @override
  String get textSizeSheetTitle => 'Cỡ chữ';

  @override
  String get textSizeSamplePreview => 'Văn bản mẫu';

  @override
  String get textSizeCancelButton => 'Hủy';

  @override
  String get textSizeApplyButton => 'Áp dụng';

  @override
  String get createPasswordDialogTitle => 'Tạo mật khẩu';

  @override
  String get createPasswordNewPasswordHint => 'Mật khẩu mới';

  @override
  String get createPasswordConfirmHint => 'Nhập lại mật khẩu';

  @override
  String get createPasswordHintQuestionDescription =>
      'Đặt câu hỏi bảo mật phòng khi bạn quên mật khẩu (không bắt buộc).';

  @override
  String get createPasswordHintQuestionHint => 'Chọn câu hỏi bảo mật';

  @override
  String get createPasswordHintAnswerHint => 'Câu trả lời của bạn';

  @override
  String get createPasswordCancelButton => 'Hủy';

  @override
  String get createPasswordSaveButton => 'Lưu';

  @override
  String get passwordMismatchMessage => 'Mật khẩu không khớp!';

  @override
  String get passwordRequiredDialogTitle => 'Yêu cầu mật khẩu';

  @override
  String get passwordRequiredHint => 'Nhập mật khẩu';

  @override
  String get forgotPasswordButtonLabel => 'Tôi quên mật khẩu';

  @override
  String get passwordRequiredCancelButton => 'Hủy';

  @override
  String get passwordRequiredConfirmButton => 'Xác minh';

  @override
  String get securityQuestionDialogTitle => 'Câu hỏi bảo mật';

  @override
  String get securityQuestionAnswerHint => 'Câu trả lời của bạn';

  @override
  String get securityQuestionCancelButton => 'Hủy';

  @override
  String get securityQuestionConfirmButton => 'Xác nhận';

  @override
  String get securityQuestionWrongAnswerMessage =>
      'Câu trả lời sai. Hãy thử lại.';

  @override
  String get revealedPasswordDialogTitle => 'Mật khẩu của bạn';

  @override
  String get revealedPasswordLabel => 'Mật khẩu ghi chú của bạn:';

  @override
  String get revealedPasswordOkButton => 'OK';

  @override
  String get securityQuestionPetName =>
      'Tên con vật nuôi đầu tiên của bạn là gì?';

  @override
  String get securityQuestionFavoriteTeacher =>
      'Tên giáo viên yêu thích của bạn là gì?';

  @override
  String get securityQuestionBirthCity => 'Bạn sinh ra ở thành phố nào?';

  @override
  String get securityQuestionFavoriteFood => 'Món ăn yêu thích của bạn là gì?';

  @override
  String get securityQuestionMotherMaidenName =>
      'Họ thời con gái của mẹ bạn là gì?';

  @override
  String get securityQuestionFirstSchool =>
      'Tên trường học đầu tiên bạn theo học là gì?';

  @override
  String get securityQuestionFavoriteColor =>
      'Màu sắc yêu thích của bạn là gì?';

  @override
  String get editFolderDialogTitle => 'Sửa thư mục';

  @override
  String get newSubfolderDialogTitle => 'Thư mục con mới';

  @override
  String get addFolderDialogTitle => 'Thêm thư mục';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'Sẽ được tạo bên trong \"$parentCategory\"';
  }

  @override
  String get subfolderNameFieldLabel => 'Tên thư mục con';

  @override
  String get folderNameFieldLabel => 'Tên thư mục';

  @override
  String get folderColorLabel => 'Màu';

  @override
  String get folderDialogCancelButton => 'Hủy';

  @override
  String get folderDialogSaveButton => 'Lưu';

  @override
  String get folderDialogAddButton => 'Thêm';

  @override
  String get selectFolderSheetTitle => 'Chọn thư mục';

  @override
  String get selectFolderAddOptionLabel => 'Thêm thư mục';

  @override
  String get removeCurrentFolderLabel => 'Bỏ thư mục hiện tại';

  @override
  String get noteDetailsDialogTitle => 'Chi tiết';

  @override
  String get noteDetailsCreatedLabel => 'Đã tạo';

  @override
  String get noteDetailsModifiedLabel => 'Sửa đổi gần nhất';

  @override
  String get noteDetailsCharCountLabel => 'Số ký tự';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count ký tự';
  }

  @override
  String get noteDetailsWordCountLabel => 'Số từ';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count từ';
  }

  @override
  String get noteDetailsOkButton => 'OK';

  @override
  String get noteDetailsUnknownDateLabel => 'Không xác định';

  @override
  String get addAttachmentSheetTitle => 'Thêm';

  @override
  String get addAttachmentImageOption => 'Thêm ảnh';

  @override
  String get addAttachmentCameraOption => 'Máy ảnh';

  @override
  String get addAttachmentFileOption => 'Thêm tệp';

  @override
  String get addAttachmentVoiceOption => 'Ghi âm giọng nói';

  @override
  String get addAttachmentVideoOption => 'Quay video';

  @override
  String get addAttachmentScanOption => 'Quét tài liệu';

  @override
  String get noteActionsSheetTitle => 'Chọn hành động';

  @override
  String get noteActionReminderLabel => 'Nhắc nhở';

  @override
  String get noteActionEditReminderLabel => 'Sửa nhắc nhở';

  @override
  String get noteActionSpeechToTextLabel => 'Giọng nói thành văn bản';

  @override
  String get noteActionArchiveLabel => 'Lưu trữ';

  @override
  String get noteActionUnarchiveLabel => 'Bỏ khỏi lưu trữ';

  @override
  String get noteActionLockLabel => 'Khóa';

  @override
  String get noteActionUnlockLabel => 'Mở khóa';

  @override
  String get noteActionFavoriteLabel => 'Yêu thích';

  @override
  String get noteActionUnfavoriteLabel => 'Bỏ khỏi yêu thích';

  @override
  String get noteActionClassifyLabel => 'Chọn thư mục';

  @override
  String get noteActionDeleteLabel => 'Xóa';

  @override
  String get noteActionPinToNotificationLabel => 'Ghim vào bảng thông báo';

  @override
  String get noteActionUnpinFromNotificationLabel => 'Bỏ ghim';

  @override
  String get noteActionShareLabel => 'Chia sẻ';

  @override
  String get noteActionDuplicateLabel => 'Tạo bản sao';

  @override
  String get noteActionCopyContentLabel => 'Sao chép nội dung';

  @override
  String get noteActionTtsLabel => 'Đọc to';

  @override
  String get noteActionTextSizeLabel => 'Cỡ chữ';

  @override
  String get noteActionDetailsLabel => 'Chi tiết';

  @override
  String get noteActionDiscardChangesLabel => 'Hủy thay đổi';

  @override
  String get noteActionSelectLabel => 'Chọn';

  @override
  String get reminderEditOptionLabel => 'Đổi nhắc nhở';

  @override
  String get reminderRemoveOptionLabel => 'Xóa nhắc nhở';

  @override
  String get discardChangesDialogTitle => 'Hủy thay đổi';

  @override
  String get discardChangesDialogMessage =>
      'Các thay đổi chưa lưu của ghi chú này sẽ bị mất. Bạn có chắc chắn muốn hủy không?';

  @override
  String get discardChangesCancelButton => 'Hủy';

  @override
  String get discardChangesConfirmButton => 'Hủy bỏ';

  @override
  String get pinnedNotificationDefaultTitle => 'Ghi chú';

  @override
  String get pdfFailedInfoMessage => 'Không thể tạo PDF';

  @override
  String get drawingScreenTitle => 'Bản vẽ';

  @override
  String get drawingMinimizeTooltip => 'Thu nhỏ';

  @override
  String get drawingEmptyExportWarningMessage => 'Hãy vẽ gì đó trước';

  @override
  String get drawingEraserPartialModeLabel => 'Một phần';

  @override
  String get drawingEraserFullModeLabel => 'Toàn bộ';

  @override
  String get drawingClearTooltip => 'Xóa hết';

  @override
  String get drawingZoomOutTooltip => 'Thu nhỏ';

  @override
  String get drawingZoomInTooltip => 'Phóng to';

  @override
  String get drawingDeleteTooltip => 'Xóa';

  @override
  String get drawingEmptyPreviewHint => 'Chạm để vẽ';

  @override
  String get settingsPageTitle => 'Cài đặt';

  @override
  String get settingsSectionGeneral => 'Chung';

  @override
  String get settingsSectionSecurity => 'Bảo mật';

  @override
  String get settingsSectionTheme => 'Giao diện';

  @override
  String get settingsSectionPersonalization => 'Cá nhân hóa';

  @override
  String get settingsSectionWidget => 'Widget';

  @override
  String get settingsSectionAbout => 'Giới thiệu';

  @override
  String get settingsHintQuestionPet =>
      'Tên con vật nuôi đầu tiên của bạn là gì?';

  @override
  String get settingsHintQuestionTeacher =>
      'Tên giáo viên yêu thích của bạn là gì?';

  @override
  String get settingsHintQuestionBirthCity => 'Bạn sinh ra ở thành phố nào?';

  @override
  String get settingsHintQuestionFavoriteFood =>
      'Món ăn yêu thích của bạn là gì?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'Họ thời con gái của mẹ bạn là gì?';

  @override
  String get settingsHintQuestionFirstSchool =>
      'Trường học đầu tiên bạn theo học là gì?';

  @override
  String get settingsHintQuestionFavoriteColor =>
      'Màu sắc yêu thích của bạn là gì?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'Câu hỏi bảo mật';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'Nếu quên mật khẩu, bạn có thể khôi phục bằng cách trả lời đúng câu hỏi này.';

  @override
  String get settingsSecurityQuestionDropdownHint => 'Chọn câu hỏi bảo mật';

  @override
  String get settingsSecurityQuestionAnswerHint => 'Câu trả lời của bạn';

  @override
  String get settingsSecurityQuestionCancelButton => 'Hủy';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'Câu hỏi và câu trả lời không được để trống!';

  @override
  String get settingsSecurityQuestionSaveButton => 'Lưu';

  @override
  String get settingsCreatePasswordTitle => 'Tạo mật khẩu';

  @override
  String get settingsPasswordRequiredTitle => 'Yêu cầu mật khẩu';

  @override
  String get settingsPasswordEnterHint => 'Nhập mật khẩu';

  @override
  String get settingsForgotPasswordButton => 'Tôi quên mật khẩu';

  @override
  String get settingsNewPasswordHint => 'Mật khẩu mới';

  @override
  String get settingsConfirmPasswordHint => 'Nhập lại mật khẩu';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'Đặt câu hỏi bảo mật phòng khi bạn quên mật khẩu (không bắt buộc).';

  @override
  String get settingsPasswordDialogCancelButton => 'Hủy';

  @override
  String get settingsPasswordMismatchWarning => 'Mật khẩu không khớp!';

  @override
  String get settingsWrongPasswordWarning => 'Sai mật khẩu!';

  @override
  String get settingsPasswordSaveButton => 'Lưu';

  @override
  String get settingsPasswordRemoveButton => 'Xóa';

  @override
  String get settingsNotePasswordTitle => 'Mật khẩu ghi chú';

  @override
  String get settingsPasswordSetSubtitle => 'Đã đặt mật khẩu ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'Chưa đặt mật khẩu';

  @override
  String get settingsSecurityQuestionTileTitle => 'Câu hỏi bảo mật';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'Đã đặt ✓ — dùng khi bạn quên mật khẩu';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'Chưa đặt — bạn sẽ không thể khôi phục mật khẩu nếu bị mất';

  @override
  String get settingsThemeDialogTitle => 'Chọn giao diện';

  @override
  String get settingsThemeSystemDefault => 'Theo hệ thống';

  @override
  String get settingsThemeLightOption => 'Giao diện sáng';

  @override
  String get settingsThemeDarkOption => 'Giao diện tối';

  @override
  String get settingsLanguageDialogTitle => 'Chọn ngôn ngữ';

  @override
  String get settingsLanguageSystemOption => 'Hệ thống';

  @override
  String get settingsAccentColorDialogTitle => 'Chọn màu nhấn';

  @override
  String get settingsThemeChangeTileTitle => 'Đổi giao diện';

  @override
  String get settingsThemeLightLabel => 'Sáng';

  @override
  String get settingsThemeDarkLabel => 'Tối';

  @override
  String get settingsThemeSystemLabel => 'Hệ thống';

  @override
  String get settingsLanguageTileTitle => 'Ngôn ngữ';

  @override
  String get settingsAccentColorTileTitle => 'Màu nhấn';

  @override
  String get settingsAccentColorTileSubtitle =>
      'Màu dùng cho thanh ứng dụng, nút bấm và công tắc';

  @override
  String get settingsColorfulNotesTitle => 'Màu ghi chú đa dạng';

  @override
  String get settingsColorfulNotesSubtitle =>
      'Mỗi thẻ ghi chú có một tông màu khác nhau.';

  @override
  String get settingsTextColorSheetTitle => 'Màu chữ';

  @override
  String get settingsTextColorSheetDesc =>
      'Đặt màu cho nội dung văn bản của ghi chú.';

  @override
  String get settingsTextColorOkButton => 'OK';

  @override
  String get settingsTextColorTileTitle => 'Màu chữ';

  @override
  String get settingsTextColorTileSubtitle =>
      'Màu cho nội dung văn bản ghi chú.';

  @override
  String get settingsWidgetFontSizeLabel => 'Cỡ chữ widget';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'Tiêu đề mẫu - $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'Hủy';

  @override
  String get settingsWidgetFontSizeApplyButton => 'Áp dụng';

  @override
  String get settingsWidgetOpacityLabel => 'Độ trong suốt nền';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return 'Độ trong suốt $percent%';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'Hủy';

  @override
  String get settingsWidgetOpacityApplyButton => 'Áp dụng';

  @override
  String get settingsWidgetDarkModeTitle => 'Widget tối';

  @override
  String get settingsWidgetDarkModeDesc => 'Bảng màu tối cho widget.';

  @override
  String get settingsAboutVersionTitle => 'Phiên bản ứng dụng';

  @override
  String get settingsFontFamilyTileTitle => 'Phông chữ';

  @override
  String get settingsFontFamilyDefaultLabel => 'Mặc định';

  @override
  String get settingsGlobalFontSizeTileTitle => 'Cỡ chữ';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt — áp dụng cho tất cả ghi chú.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'Văn bản mẫu - $size pt';
  }

  @override
  String get settingsGlobalFontSizeApplyToAllLabel =>
      'Áp dụng cho ghi chú hiện có';

  @override
  String get settingsGlobalFontSizeApplyToAllNote =>
      'Nếu một ghi chú đã đặt cỡ chữ riêng, cài đặt này sẽ không ảnh hưởng đến nó.';

  @override
  String get settingsGlobalFontSizeCancelButton => 'Hủy';

  @override
  String get settingsGlobalFontSizeApplyButton => 'Áp dụng';

  @override
  String get settingsPreviewLinesTileTitle => 'Số dòng xem trước ghi chú';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'Hiển thị tối đa $lines dòng. Nếu ghi chú ngắn hơn, số dòng thực tế sẽ được hiển thị.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'Hiện tại: $lines dòng';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'Đặt số dòng tối đa để xem trước. Nếu ghi chú có ít dòng hơn, số dòng thực tế sẽ được hiển thị.';

  @override
  String get settingsPreviewLinesCancelButton => 'Hủy';

  @override
  String get settingsPreviewLinesApplyButton => 'Áp dụng';

  @override
  String get backupCancelButton => 'Hủy';

  @override
  String get backupConnectButton => 'Kết nối';

  @override
  String get backupDisconnectButton => 'Ngắt kết nối';

  @override
  String get backupContinueButton => 'Tiếp tục';

  @override
  String get backupCloseButton => 'Đóng';

  @override
  String get backupShareButton => 'Chia sẻ';

  @override
  String get backupRestoreButton => 'Khôi phục';

  @override
  String get backupConfigureButton => 'Cấu hình';

  @override
  String get backupUnknownDateLabel => 'Không xác định';

  @override
  String get backupProcessingDefaultLabel => 'Đang xử lý...';

  @override
  String get backupPermissionRequiredTitle => 'Yêu cầu quyền lưu trữ';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'Phiên bản Android này yêu cầu quyền lưu trữ để sao lưu/khôi phục. Do quyền đã bị từ chối vĩnh viễn, vui lòng bật thủ công trong cài đặt ứng dụng.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'Phiên bản Android này yêu cầu quyền lưu trữ để sao lưu/khôi phục. Vui lòng cấp quyền để tiếp tục.';

  @override
  String get backupGoToSettingsButton => 'Đi tới cài đặt';

  @override
  String get backupRetryButton => 'Thử lại';

  @override
  String get backupDriveConnectingLabel =>
      'Đang kết nối với tài khoản Google...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Đã kết nối với tài khoản Google Drive: $email';
  }

  @override
  String get backupDriveConnectedMessage =>
      'Đã kết nối với tài khoản Google Drive.';

  @override
  String get backupDriveConnectFailedMessage =>
      'Không thể kết nối với tài khoản Google, hoặc thao tác đã bị hủy.';

  @override
  String get backupDriveDisconnectTitle => 'Ngắt kết nối Google Drive';

  @override
  String get backupDriveDisconnectBody =>
      'Nếu ngắt kết nối, bạn sẽ không thể sao lưu thủ công hoặc tự động lên Drive nữa. Các bản sao lưu đã có trên Drive sẽ không bị xóa — chỉ quyền truy cập từ thiết bị này sẽ bị gỡ bỏ.';

  @override
  String get backupDriveDisconnectedMessage => 'Đã gỡ kết nối Google Drive.';

  @override
  String get backupDriveRequiredTitle => 'Yêu cầu tài khoản Google';

  @override
  String get backupDriveRequiredBody =>
      'Thao tác này yêu cầu bạn kết nối tài khoản Google. Bạn có muốn kết nối ngay bây giờ không?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: đã kết nối ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: đã kết nối';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: chưa kết nối';

  @override
  String get backupDriveAuthenticatingLabel =>
      'Đang xác minh tài khoản Google...';

  @override
  String get backupDriveNotSignedInMessage =>
      'Bạn chưa kết nối với Google Drive. Vui lòng đăng nhập bằng tài khoản Google trước.';

  @override
  String get backupDriveUploadingLabel => 'Đang tải bản sao lưu lên Drive...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Tải lên Google Drive không hoàn tất trong 120 giây (không có phản hồi từ máy chủ). Vui lòng kiểm tra kết nối và thử lại.';

  @override
  String get backupDriveOperationCompletedLabel => 'Hoàn tất';

  @override
  String get backupToDriveActionLabel => 'sao lưu lên Drive';

  @override
  String get backupToDeviceActionLabel => 'sao lưu';

  @override
  String get backupCreatingLabel => 'Đang tạo bản sao lưu...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'Không thể tạo bản sao lưu: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Tải lên Google Drive thất bại: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'Đã tải bản sao lưu lên Google Drive thành công.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'Đã tạo bản sao lưu: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'Bản sao lưu đã sẵn sàng';

  @override
  String get backupOfferShareBody =>
      'Tệp sao lưu của bạn đã được lưu vào thiết bị. Bạn có muốn chia sẻ ngay bây giờ không (ví dụ: lưu trữ đám mây, email, thiết bị khác)?';

  @override
  String get backupShareFileText => 'tệp sao lưu layout';

  @override
  String backupShareFailedMessage(String error) {
    return 'Không thể bắt đầu chia sẻ: $error';
  }

  @override
  String get backupLargeOperationTitle => 'Sao lưu lớn';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'Dữ liệu cần xử lý có kích thước khoảng $sizeText. Thao tác $actionLabel với kích thước này có thể mất một chút thời gian tùy thiết bị. Chỉ cần không thoát ứng dụng trong khi xử lý — bạn có muốn tiếp tục không?';
  }

  @override
  String get backupRestoreActionLabel => 'khôi phục';

  @override
  String get backupDriveListingLabel =>
      'Đang liệt kê các bản sao lưu trên Drive...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'Không thể liệt kê các bản sao lưu: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'Chưa có bản sao lưu nào trên Google Drive.';

  @override
  String get backupDrivePickTitle => 'Chọn bản sao lưu từ Drive';

  @override
  String get backupDriveDownloadingLabel => 'Đang tải bản sao lưu từ Drive...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Đang tải bản sao lưu từ Drive... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel => 'Đang lưu tệp vào thiết bị...';

  @override
  String get backupDriveUnknownBackupFileName => 'unknown_backup.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Dung lượng lưu trữ Google Drive của bạn đã đầy. Vui lòng giải phóng dung lượng trên Drive và thử lại.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'Không thể thiết lập kết nối internet. Vui lòng kiểm tra kết nối và thử lại.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'Không tìm thấy tệp sao lưu được chỉ định trên Drive. Có thể tệp đã bị xóa.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Đã xảy ra lỗi không mong muốn trong thao tác Google Drive: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'Tải xuống thất bại: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'Không thể chọn tệp: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'Không thể truy cập tệp đã chọn.';

  @override
  String get backupCheckingLabel => 'Đang kiểm tra bản sao lưu...';

  @override
  String backupReadFailedMessage(String error) {
    return 'Không thể đọc tệp sao lưu: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'Khôi phục bản sao lưu';

  @override
  String get backupPreviewContentsHeader => 'Nội dung của bản sao lưu đã chọn:';

  @override
  String get backupPreviewNoteCountLabel => 'Số lượng ghi chú';

  @override
  String get backupPreviewTrashCountLabel => 'Ghi chú trong thùng rác';

  @override
  String get backupPreviewCategoryCountLabel => 'Số lượng danh mục';

  @override
  String get backupPreviewAttachmentLabel => 'Tệp đính kèm';

  @override
  String get backupPreviewAttachmentNoneValue => 'Không có';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count tệp ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'Được tạo vào';

  @override
  String get backupEmptyPreviewTitle => 'Bản sao lưu này có vẻ trống';

  @override
  String get backupEmptyPreviewBody =>
      'Không tìm thấy ghi chú, danh mục hoặc tệp đính kèm nào trong tệp đã chọn. Nếu tiếp tục, dữ liệu hiện tại của bạn vẫn sẽ bị xóa và thay thế bằng bản sao lưu trống này.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '$count tệp đính kèm không tìm thấy trong bản sao lưu';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'Các ghi chú có những tệp này sẽ được khôi phục, nhưng không có tệp đính kèm (có thể chúng đã bị thiếu hoặc hỏng khi sao lưu): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown và $remaining tệp khác';
  }

  @override
  String get backupRestoreConfirmBody =>
      'Thao tác này sẽ THAY THẾ tất cả ghi chú, thùng rác, danh mục, cài đặt và tệp đính kèm hiện tại bằng dữ liệu trong bản sao lưu ở trên. Dữ liệu hiện tại của bạn sẽ bị mất vĩnh viễn và không thể hoàn tác.';

  @override
  String get backupRestoringLabel => 'Đang khôi phục bản sao lưu...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'Đã khôi phục bản sao lưu. Tuy nhiên, $count tệp đính kèm không tìm thấy trong bản sao lưu và không thể khôi phục. Nên khởi động lại ứng dụng để các thay đổi có hiệu lực đầy đủ.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'Đã khôi phục bản sao lưu thành công. Nên khởi động lại ứng dụng để các thay đổi có hiệu lực đầy đủ.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'Đã xảy ra lỗi khi khôi phục: $error';
  }

  @override
  String get backupScreenTitle => 'Sao lưu & Khôi phục';

  @override
  String get backupBlockedExitWarningMessage =>
      'Một thao tác đang diễn ra, vui lòng đợi cho đến khi hoàn tất.';

  @override
  String get backupBusyBackTooltip => 'Thao tác đang diễn ra';

  @override
  String get backupIntroText =>
      'Bạn có thể sao lưu ghi chú, danh mục, cài đặt và tệp đính kèm thành một tệp .zip duy nhất, hoặc khôi phục bản sao lưu đã thực hiện trước đó.';

  @override
  String get backupDriveCardTitle => 'Sao lưu lên Google Drive';

  @override
  String get backupDriveCardSubtitle =>
      'Tạo bản sao lưu mới và tải trực tiếp lên khu vực riêng tư trên Google Drive của bạn.';

  @override
  String get backupDriveCardButtonLabel => 'Sao lưu lên Drive';

  @override
  String get backupDeviceCardTitle => 'Sao lưu vào thiết bị';

  @override
  String get backupDeviceCardSubtitle =>
      'Lưu toàn bộ dữ liệu của bạn thành một tệp .zip duy nhất vào thiết bị và chia sẻ nếu bạn muốn.';

  @override
  String get backupDeviceCardButtonLabel => 'Sao lưu vào thiết bị';

  @override
  String get backupHistoryCardTitle => 'Lịch sử sao lưu';

  @override
  String get backupHistoryCardSubtitle =>
      'Xem tất cả các bản sao lưu được lưu trên thiết bị cùng ngày tháng và kích thước; bạn có thể chia sẻ, khôi phục hoặc xóa trực tiếp tại đây.';

  @override
  String get backupHistoryTabDevice => 'Thiết bị';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'Xóa bản sao lưu';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'Bạn có chắc chắn muốn xóa vĩnh viễn tệp sao lưu \"$fileName\" không? Hành động này không thể hoàn tác.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'Đã xóa bản sao lưu.';

  @override
  String get backupHistoryDriveDeleteDialogTitle =>
      'Xóa bản sao lưu trên Drive';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'Bạn có chắc chắn muốn xóa vĩnh viễn bản sao lưu \"$fileName\" khỏi Google Drive không? Hành động này không thể hoàn tác và tệp sẽ không được chuyển vào thùng rác.';
  }

  @override
  String get backupHistoryDriveDeletedMessage =>
      'Đã xóa bản sao lưu trên Drive.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'Không thể xóa: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'Chưa có bản sao lưu nào được lưu trên thiết bị này.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'Sử dụng \"Sao lưu vào thiết bị\" để tạo bản sao lưu đầu tiên của bạn.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'Sử dụng \"Sao lưu lên Google Drive\" để tạo bản sao lưu đám mây đầu tiên của bạn.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Kết nối tài khoản Google để xem các bản sao lưu trên Drive của bạn.';

  @override
  String get backupHistoryConnectGoogleButton => 'Kết nối với Google';

  @override
  String get backupHistoryDriveConnectedFallback => 'Đã kết nối';

  @override
  String get backupHistoryUnknownErrorFallback =>
      'Đã xảy ra lỗi không xác định.';

  @override
  String get backupHistoryDownloadStartingLabel => 'Đang bắt đầu...';

  @override
  String get backupAutoBackupEnabledLabel => 'Sao lưu tự động: bật';

  @override
  String get backupAutoBackupDisabledLabel => 'Sao lưu tự động: tắt';

  @override
  String get backupOverlayWarningMessage =>
      'Vui lòng chờ, không thoát ứng dụng cho đến khi thao tác hoàn tất.';

  @override
  String get pdfExportUntitledNoteLabel => 'Ghi chú chưa đặt tên';

  @override
  String get pdfExportDefaultAttachmentName => 'Tệp đính kèm';

  @override
  String get pdfExportDefaultFileName => 'ghi_chu';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'Không thể chụp ảnh màn hình (không tìm thấy ranh giới)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'Không thể tạo dữ liệu ảnh chụp màn hình';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'Không thể xử lý hình ảnh (giải mã PNG thất bại)';

  @override
  String get screenshotCalcTableTotalLabel => 'Tổng';

  @override
  String get gundemMenuRemoveFromAgenda => 'Bỏ khỏi lịch trình';

  @override
  String get gundemMenuDeleteNote => 'Xóa ghi chú';

  @override
  String get gundemSectionOverdue => 'Quá hạn';

  @override
  String get gundemSectionToday => 'Hôm nay';

  @override
  String get gundemSectionTomorrow => 'Ngày mai';

  @override
  String get gundemSectionNextWeek => 'Tuần sau';

  @override
  String get gundemSectionFurther => 'Sắp tới';

  @override
  String get gundemWeekdayMonday => 'Thứ Hai';

  @override
  String get gundemWeekdayTuesday => 'Thứ Ba';

  @override
  String get gundemWeekdayWednesday => 'Thứ Tư';

  @override
  String get gundemWeekdayThursday => 'Thứ Năm';

  @override
  String get gundemWeekdayFriday => 'Thứ Sáu';

  @override
  String get gundemWeekdaySaturday => 'Thứ Bảy';

  @override
  String get gundemWeekdaySunday => 'Chủ Nhật';

  @override
  String get gundemAppBarTitle => 'Lịch trình';

  @override
  String get gundemCalendarTooltip => 'Lịch';

  @override
  String get gundemEmptyTitle => 'Không có gì trong lịch trình của bạn';

  @override
  String get gundemEmptySubtitle =>
      'Các ghi chú có nhắc nhở hoặc ngày được gán sẽ hiển thị ở đây.';

  @override
  String get gundemUntitledNote => 'Ghi chú chưa đặt tên';

  @override
  String get gundemRepeatHourly => 'Hàng giờ';

  @override
  String get gundemRepeatDaily => 'Hàng ngày';

  @override
  String get gundemRepeatWeekly => 'Hàng tuần';

  @override
  String get gundemRepeatMonthly => 'Hàng tháng';

  @override
  String get gundemRepeatYearly => 'Hàng năm';

  @override
  String get gundemPreviewCalcTableLabel => '[Bảng tính]';

  @override
  String get gundemPreviewDrawingLabel => '[Bản vẽ]';

  @override
  String get gundemPreviewImageLabel => '[Hình ảnh]';

  @override
  String get gundemMonthShortJan => 'Th1';

  @override
  String get gundemMonthShortFeb => 'Th2';

  @override
  String get gundemMonthShortMar => 'Th3';

  @override
  String get gundemMonthShortApr => 'Th4';

  @override
  String get gundemMonthShortMay => 'Th5';

  @override
  String get gundemMonthShortJun => 'Th6';

  @override
  String get gundemMonthShortJul => 'Th7';

  @override
  String get gundemMonthShortAug => 'Th8';

  @override
  String get gundemMonthShortSep => 'Th9';

  @override
  String get gundemMonthShortOct => 'Th10';

  @override
  String get gundemMonthShortNov => 'Th11';

  @override
  String get gundemMonthShortDec => 'Th12';

  @override
  String get calendarAppBarTitle => 'Lịch';

  @override
  String get calendarTodayButton => 'Hôm nay';

  @override
  String get calendarLegendNoteLabel => 'Ghi chú';

  @override
  String get calendarLegendReminderLabel => 'Nhắc nhở';

  @override
  String get calendarTodayBadge => 'Hôm nay';

  @override
  String get calendarEmptyDayMessage =>
      'Không có ghi chú hoặc nhắc nhở nào cho ngày này.';

  @override
  String get calendarReminderHourlyLabel => 'Hàng giờ';

  @override
  String get calendarMonthJan => 'Tháng 1';

  @override
  String get calendarMonthFeb => 'Tháng 2';

  @override
  String get calendarMonthMar => 'Tháng 3';

  @override
  String get calendarMonthApr => 'Tháng 4';

  @override
  String get calendarMonthMay => 'Tháng 5';

  @override
  String get calendarMonthJun => 'Tháng 6';

  @override
  String get calendarMonthJul => 'Tháng 7';

  @override
  String get calendarMonthAug => 'Tháng 8';

  @override
  String get calendarMonthSep => 'Tháng 9';

  @override
  String get calendarMonthOct => 'Tháng 10';

  @override
  String get calendarMonthNov => 'Tháng 11';

  @override
  String get calendarMonthDec => 'Tháng 12';

  @override
  String get calendarWeekdayShortMon => 'T2';

  @override
  String get calendarWeekdayShortTue => 'T3';

  @override
  String get calendarWeekdayShortWed => 'T4';

  @override
  String get calendarWeekdayShortThu => 'T5';

  @override
  String get calendarWeekdayShortFri => 'T6';

  @override
  String get calendarWeekdayShortSat => 'T7';

  @override
  String get calendarWeekdayShortSun => 'CN';

  @override
  String get calendarWeekdayFullMonday => 'Thứ Hai';

  @override
  String get calendarWeekdayFullTuesday => 'Thứ Ba';

  @override
  String get calendarWeekdayFullWednesday => 'Thứ Tư';

  @override
  String get calendarWeekdayFullThursday => 'Thứ Năm';

  @override
  String get calendarWeekdayFullFriday => 'Thứ Sáu';

  @override
  String get calendarWeekdayFullSaturday => 'Thứ Bảy';

  @override
  String get calendarWeekdayFullSunday => 'Chủ Nhật';

  @override
  String get wrongPasswordDialogTitle => 'Sai mật khẩu';

  @override
  String get wrongPasswordDialogMessage => 'Mật khẩu bạn nhập không đúng.';

  @override
  String get commonOkButton => 'OK';

  @override
  String get unlockCategoryAction => 'Mở khóa';

  @override
  String get lockCategoryAction => 'Khóa';

  @override
  String get categoryUnlockedMessage => 'Đã mở khóa';

  @override
  String get categoryLockedMessage => 'Đã khóa thư mục';

  @override
  String get deleteFolderMenuItemLabel => 'Xóa thư mục';

  @override
  String get deleteFolderDialogTitle => 'Xóa thư mục';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'Bạn có chắc chắn muốn xóa thư mục \"$category\" và tất cả thư mục con của nó không? Các ghi chú trong những thư mục này sẽ trở thành chưa phân loại.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'Bạn có chắc chắn muốn xóa thư mục \"$category\" không? Các ghi chú trong thư mục này sẽ trở thành chưa phân loại.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'Hủy';

  @override
  String get deleteFolderDialogConfirmButton => 'Xóa';

  @override
  String get editCategoryNameColorMenuItemLabel => 'Sửa tên / màu';

  @override
  String get addSubfolderMenuItemLabel => 'Tạo thư mục con';

  @override
  String get expandSubfoldersMenuItemLabel => 'Mở rộng thư mục con';

  @override
  String get collapseSubfoldersMenuItemLabel => 'Thu gọn thư mục con';

  @override
  String saveErrorInfoMessage(String error) {
    return 'Lỗi lưu: $error';
  }

  @override
  String get welcomeNoteTitle => 'Chào mừng đến với Layout! 🚀';

  @override
  String get welcomeNoteContent => 'Đã thêm tính năng mới!';

  @override
  String get noteListDateGroupToday => 'Hôm nay';

  @override
  String get noteListDateGroupYesterday => 'Hôm qua';

  @override
  String get noteListDateGroupLast7Days => '7 ngày qua';

  @override
  String get noteListDateGroupLast30Days => '30 ngày qua';

  @override
  String get reminderRepeatNoneLabel => 'Không lặp lại';

  @override
  String get voiceRecorderPreparingLabel => 'Đang chuẩn bị…';

  @override
  String get voiceRecorderCancelButton => 'Hủy';

  @override
  String get voiceRecorderStopAddButton => 'Dừng và thêm';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'Quyền truy cập micrô chưa được cấp.';

  @override
  String get speechToTextUnavailableMessage =>
      'Nhận dạng giọng nói không khả dụng trên thiết bị này.';

  @override
  String get speechToTextPreparingLabel => 'Đang chuẩn bị…';

  @override
  String get speechToTextListeningLabel => 'Đang nghe…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'Bắt đầu nói…';

  @override
  String get speechToTextCancelButton => 'Hủy';

  @override
  String get speechToTextStopAddButton => 'Dừng và thêm';

  @override
  String get textToSpeechNoContentMessage => 'Không có nội dung để đọc.';

  @override
  String get textToSpeechReadErrorMessage => 'Đã xảy ra lỗi khi đọc.';

  @override
  String get textToSpeechUnavailableMessage =>
      'Chuyển văn bản thành giọng nói không khả dụng trên thiết bị này.';

  @override
  String get textToSpeechPreparingLabel => 'Đang chuẩn bị…';

  @override
  String get textToSpeechPausedLabel => 'Đã tạm dừng';

  @override
  String get textToSpeechFinishedLabel => 'Đọc xong';

  @override
  String get textToSpeechReadingLabel => 'Đang đọc…';

  @override
  String get textToSpeechCloseErrorButton => 'Đóng';

  @override
  String get textToSpeechReplayButton => 'Đọc lại';

  @override
  String get textToSpeechCloseFinishedButton => 'Đóng';

  @override
  String get textToSpeechPauseButton => 'Tạm dừng';

  @override
  String get textToSpeechResumeButton => 'Tiếp tục';

  @override
  String get textToSpeechStopButton => 'Dừng';

  @override
  String get textToSpeechSpeedSlow => 'Chậm';

  @override
  String get textToSpeechSpeedNormal => 'Bình thường';

  @override
  String get textToSpeechSpeedFast => 'Nhanh';

  @override
  String get calendarPickerCancelButton => 'Hủy';

  @override
  String get calendarPickerConfirmButton => 'Chọn';

  @override
  String get calendarPickerClearButton => 'Xóa';

  @override
  String get reminderPickerDialogTitle => 'Thêm nhắc nhở';

  @override
  String get reminderPickerDateTodayOption => 'Hôm nay';

  @override
  String get reminderPickerDateTomorrowOption => 'Ngày mai';

  @override
  String get reminderPickerDatePickOption => 'Chọn ngày';

  @override
  String get reminderRepeatHourlyLabel => 'Mỗi giờ';

  @override
  String get reminderRepeatDailyLabel => 'Mỗi ngày';

  @override
  String get reminderRepeatWeeklyLabel => 'Mỗi tuần';

  @override
  String get reminderRepeatMonthlyLabel => 'Mỗi tháng';

  @override
  String get reminderRepeatYearlyLabel => 'Mỗi năm';

  @override
  String get reminderPickerCalendarHelpText => 'Chọn ngày nhắc nhở';

  @override
  String get reminderPickerCancelButton => 'HỦY';

  @override
  String get reminderPickerSaveButton => 'LƯU';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'Không thể chọn thời gian trong quá khứ';

  @override
  String calcTableTotalLabel(String amount) {
    return 'Tổng: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'Đang chuẩn bị dữ liệu...';

  @override
  String get backupCreatePackagingNotesLabel =>
      'Đang đóng gói ghi chú và danh mục...';

  @override
  String get backupCreateReadingAttachmentsLabel => 'Đang đọc tệp đính kèm...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'Đang đọc tệp đính kèm... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'Đang nén tệp zip...';

  @override
  String get backupCreateSavingFileLabel => 'Đang lưu tệp...';

  @override
  String get backupRestoreValidatingLabel => 'Đang xác thực bản sao lưu...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'Đã xác thực bản sao lưu, đang chuẩn bị dữ liệu...';

  @override
  String get backupRestoreWritingNotesLabel => 'Đang ghi ghi chú...';

  @override
  String get backupRestoreWritingTrashLabel => 'Đang ghi thùng rác...';

  @override
  String get backupRestoreTrashWrittenLabel => 'Đã ghi thùng rác';

  @override
  String get backupRestoreWritingCategoriesLabel => 'Đang ghi danh mục...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'Đã ghi danh mục';

  @override
  String get backupRestoreWritingSettingsLabel => 'Đang ghi cài đặt...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'Đã ghi cài đặt';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'Đang dọn dẹp tệp đính kèm cũ...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'Không tìm thấy tệp đính kèm, đang hoàn tất...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'Đang khôi phục tệp đính kèm... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'Hoàn tất';

  @override
  String get backupValidationCorruptedFileMessage =>
      'Tệp bị hỏng hoặc không phải là tệp sao lưu hợp lệ.';

  @override
  String get backupValidationMissingDataMessage =>
      'Không tìm thấy dữ liệu bên trong tệp sao lưu (thiếu backup_data.json).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'Không thể đọc dữ liệu sao lưu (JSON bị hỏng).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'Tệp này không phải là bản sao lưu từ ứng dụng layout.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'Không thể đọc thông tin phiên bản của tệp sao lưu.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'Bản sao lưu này có định dạng mới hơn mà phiên bản ứng dụng hiện tại không hỗ trợ. Vui lòng cập nhật ứng dụng.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'Thông tin phiên bản của tệp sao lưu không hợp lệ.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'Dữ liệu sao lưu không đúng định dạng mong đợi (thiếu trường notes).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'Dữ liệu sao lưu không đúng định dạng mong đợi (thiếu trường trash).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'Dữ liệu sao lưu không đúng định dạng mong đợi (danh sách danh mục không hợp lệ).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'Dữ liệu sao lưu không đúng định dạng mong đợi (trường settings không hợp lệ).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'Dữ liệu sao lưu không đúng định dạng mong đợi (một bản ghi ghi chú không hợp lệ).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'Dữ liệu sao lưu không đúng định dạng mong đợi (tìm thấy một bản ghi ghi chú không có ID).';

  @override
  String get backupValidationFileNotFoundMessage =>
      'Không tìm thấy tệp sao lưu.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'Không đủ dung lượng trống trên thiết bị. Vui lòng giải phóng dung lượng và thử lại.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'Quyền truy cập tệp đã bị từ chối. Vui lòng kiểm tra quyền của ứng dụng và thử lại.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'Đã xảy ra lỗi trong thao tác tệp: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'Đã xảy ra lỗi không mong muốn: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'Không thể tạo tệp zip (ZipEncoder trả về null).';

  @override
  String get calcTableMenuItemLabel => 'Bảng tính';

  @override
  String get tagsMenuItemLabel => 'Thẻ';

  @override
  String get linkDialogUrlHint => 'https://example.com';

  @override
  String get checklistItemHint => 'Thêm mục...';

  @override
  String get toolbarHighlightTooltip => 'Tô sáng';

  @override
  String get toolbarListTooltip => 'Danh sách';

  @override
  String get toolbarHideKeyboardTooltip => 'Ẩn bàn phím';

  @override
  String get autoBackupLocalSuccessMessage => 'Sao lưu cục bộ thành công.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'Sao lưu cục bộ thất bại: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Bỏ qua sao lưu Drive: tài khoản Google chưa được kết nối hoặc phiên đã hết hạn. Vui lòng mở ứng dụng và kết nối lại.';

  @override
  String get autoBackupDriveSuccessMessage => 'Sao lưu lên Drive thành công.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Sao lưu lên Drive thất bại: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'Chưa có ghi chú nào';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'Tổng: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ Bản vẽ';

  @override
  String get autoBackupSettingsAppBarTitle => 'Cài đặt sao lưu tự động';

  @override
  String get autoBackupSettingsMainSwitchTitle => 'Bật sao lưu tự động';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'Ghi chú của bạn được sao lưu định kỳ và an toàn trong nền.';

  @override
  String get autoBackupSettingsTargetTitle => 'Đích sao lưu';

  @override
  String get autoBackupSettingsTargetSubtitle => 'Chọn nơi lưu bản sao lưu.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'Cục bộ';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'Cả hai';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Kết nối tài khoản trước để sử dụng các tùy chọn Google Drive.';

  @override
  String get autoBackupSettingsConnectButton => 'Kết nối';

  @override
  String get autoBackupSettingsFrequencyTitle => 'Tần suất sao lưu';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'Sao lưu được thực hiện mỗi $hours giờ.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 giờ';

  @override
  String get autoBackupSettingsFrequency12h => '12 giờ';

  @override
  String get autoBackupSettingsFrequency24h => '24 giờ (Hàng ngày)';

  @override
  String get autoBackupSettingsFrequency48h => '48 giờ (2 ngày)';

  @override
  String get autoBackupSettingsFrequency168h => '168 giờ (Hàng tuần)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Chỉ dùng Wi-Fi';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'Chỉ tải lên đám mây qua Wi-Fi để bảo vệ dữ liệu di động của bạn.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'Trạng thái hệ thống';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'Sao lưu tự động chưa từng chạy.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'Lần chạy gần nhất: $date $time ($status)\\nThông báo: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'Thành công';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'Thất bại';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Không thể kết nối với tài khoản Google.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'Đã cập nhật cài đặt sao lưu tự động.';

  @override
  String selectionModeDeletedMessage(int count) {
    return 'Đã xóa $count ghi chú';
  }

  @override
  String get selectionModeArchivedMessage => 'Đã lưu trữ';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'Chọn danh mục cho $count ghi chú';
  }

  @override
  String get selectionModeAddCategoryOption => 'Thêm danh mục';

  @override
  String get selectionModeRemoveCategoryOption => 'Bỏ danh mục';

  @override
  String get calcTableItemHint => 'Mục...';

  @override
  String get calcTableTotalRowLabel => 'Tổng';

  @override
  String get textSelectionMenuShareButton => 'Chia sẻ';

  @override
  String get textSelectionMenuTranslateButton => 'Dịch';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'Không thể bắt đầu chia sẻ.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'Không thể mở bản dịch.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'Hôm nay $time';
  }

  @override
  String lastBackupInfoDateFormat(
    String day,
    String month,
    int year,
    String time,
  ) {
    return '$day/$month/$year $time';
  }

  @override
  String lastBackupInfoLabel(String date) {
    return 'Sao lưu gần nhất: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage =>
      'Chưa có bản sao lưu nào được thực hiện.';

  @override
  String get backupFileNameLabel => 'Sao lưu';
}
