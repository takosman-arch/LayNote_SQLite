// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'ตัวหนา';

  @override
  String get toolbarItalicTooltip => 'ตัวเอียง';

  @override
  String get toolbarUnderlineTooltip => 'ขีดเส้นใต้';

  @override
  String get toolbarStrikethroughTooltip => 'ขีดฆ่า';

  @override
  String get toolbarFontSizeTooltip => 'ขนาดตัวอักษร';

  @override
  String get toolbarColorTooltip => 'สีตัวอักษร';

  @override
  String get toolbarBulletTooltip => 'รายการหัวข้อย่อย';

  @override
  String get toolbarNumberTooltip => 'รายการลำดับเลข';

  @override
  String get toolbarIndentTooltip => 'ย่อหน้า';

  @override
  String get toolbarLinkTooltip => 'เพิ่ม/แก้ไข/ลบลิงก์';

  @override
  String get toolbarDividerTooltip => 'แทรกเส้นแบ่ง';

  @override
  String get toolbarChecklistTooltip => 'เพิ่มรายการตรวจสอบ';

  @override
  String get linkSelectTextSnackbar =>
      'กรุณาเลือกข้อความที่ต้องการใส่ลิงก์ก่อน';

  @override
  String get linkDialogEditTitle => 'แก้ไขลิงก์';

  @override
  String get linkDialogAddTitle => 'เพิ่มลิงก์';

  @override
  String get linkDialogRemoveButton => 'ลบลิงก์';

  @override
  String get linkDialogCancelButton => 'ยกเลิก';

  @override
  String get linkDialogConfirmButton => 'เพิ่ม';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'การเข้าถึงกล้องถูกปฏิเสธ คุณต้องอนุญาตจากการตั้งค่าเพื่อบันทึกวิดีโอ';

  @override
  String get cameraPermissionRequiredMessage =>
      'จำเป็นต้องได้รับสิทธิ์เข้าถึงกล้องเพื่อบันทึกวิดีโอ';

  @override
  String get openSettingsButtonLabel => 'การตั้งค่า';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'ไม่สามารถเริ่มการสแกนได้: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'การรู้จำข้อความล้มเหลว: $error';
  }

  @override
  String get ocrNoReadableTextMessage => 'ไม่พบข้อความที่อ่านได้ในเอกสาร';

  @override
  String get scanResultSheetTitle => 'ต้องการเพิ่มเอกสารที่สแกนอย่างไร?';

  @override
  String get scanResultTextOnlyOption => 'เพิ่มเป็นข้อความเท่านั้น';

  @override
  String get scanResultTextAndImageOption => 'เพิ่มข้อความ + ภาพที่สแกน';

  @override
  String get scanResultCancelOption => 'ยกเลิก';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'การเข้าถึงไมโครโฟนถูกปฏิเสธ คุณต้องอนุญาตจากการตั้งค่าเพื่อบันทึกเสียง';

  @override
  String get audioPermissionRequiredMessage =>
      'จำเป็นต้องได้รับสิทธิ์เข้าถึงไมโครโฟนเพื่อบันทึกเสียง';

  @override
  String get voiceRecordingDefaultLabel => 'การบันทึกเสียง';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'รายการคำนวณ ($count แถว)';
  }

  @override
  String get blockPreviewDrawingLabel => 'ภาพวาด';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return 'ไฟล์แนบ $count รายการ (รูปภาพ/เอกสาร)';
  }

  @override
  String get blockPreviewDividerLabel => 'เส้นแบ่ง';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'รายการตรวจสอบ ($count รายการ)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(ข้อความว่าง)';

  @override
  String get reorderBlocksSheetTitle => 'จัดเรียงบล็อกใหม่';

  @override
  String get reorderBlocksMoveUpTooltip => 'เลื่อนขึ้น';

  @override
  String get reorderBlocksMoveDownTooltip => 'เลื่อนลง';

  @override
  String get reorderBlocksCloseTooltip => 'ปิด';

  @override
  String get reorderBlocksDescription =>
      'แตะบล็อกเพื่อเลือก จากนั้นใช้ลูกศรขึ้น/ลงเพื่อย้าย';

  @override
  String get reorderBlocksMenuItemLabel => 'จัดเรียงใหม่';

  @override
  String get txtImportPickerDialogTitle => 'เลือกไฟล์ TXT ที่ต้องการนำเข้า';

  @override
  String get txtImportReadFailedMessage => 'ไม่สามารถอ่านไฟล์ TXT ได้';

  @override
  String get txtImportEmptyFileMessage => 'ไฟล์ TXT ว่างเปล่า';

  @override
  String get txtImportSuccessMessage => 'นำเข้าไฟล์ TXT แล้ว';

  @override
  String get txtImportMenuItemLabel => 'นำเข้า (txt)';

  @override
  String get exportMenuItemLabel => 'ส่งออก';

  @override
  String get editorUndoTooltip => 'เลิกทำ';

  @override
  String get editorRedoTooltip => 'ทำซ้ำ';

  @override
  String get noteSavedMessage => 'บันทึกโน้ตแล้ว';

  @override
  String get dateAssignPickerHelpText => 'กำหนดโน้ตให้กับวัน';

  @override
  String get dateAssignChangeOption => 'เปลี่ยนวันที่';

  @override
  String get dateAssignRemoveOption => 'ยกเลิกการกำหนด';

  @override
  String get editorSubToolbarCloseTooltip => 'ปิด';

  @override
  String get titleFieldHint => 'ชื่อเรื่อง';

  @override
  String get textBlockHint => 'เขียนโน้ตของคุณที่นี่...';

  @override
  String get drawingBoardMenuItemLabel => 'กระดานวาดภาพ';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'การแปลงเสียงเป็นข้อความใช้ได้เฉพาะกับโน้ตข้อความเท่านั้น';

  @override
  String get selectionModeCancelTooltip => 'ยกเลิกการเลือก';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return 'เลือกแล้ว $count รายการ';
  }

  @override
  String get selectionModeDeleteTooltip => 'ลบ';

  @override
  String get selectionModeArchiveTooltip => 'เก็บถาวร';

  @override
  String get selectionModeFolderTooltip => 'โฟลเดอร์';

  @override
  String get searchFieldHint => 'ค้นหาโน้ต...';

  @override
  String get emptyTrashDialogTitle => 'ล้างถังขยะ';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'โน้ตที่ถูกลบทั้งหมดจะถูกลบอย่างถาวร คุณแน่ใจหรือไม่?';

  @override
  String get emptyTrashDialogCancelButton => 'ยกเลิก';

  @override
  String get restoreAllMenuItemLabel => 'กู้คืนทั้งหมด';

  @override
  String get sortMenuTooltip => 'จัดเรียงโน้ต';

  @override
  String get sortMenuAscendingLabel => 'ลำดับ: จากน้อยไปมาก (A-Z)';

  @override
  String get sortMenuDescendingLabel => 'ลำดับ: จากมากไปน้อย (Z-A)';

  @override
  String get sortMenuByTitleLabel => 'จัดเรียงตาม: ชื่อเรื่อง';

  @override
  String get sortMenuByModifiedDateLabel => 'จัดเรียงตาม: แก้ไขล่าสุด';

  @override
  String get sortMenuByCreatedDateLabel => 'จัดเรียงตาม: วันที่สร้าง';

  @override
  String get sortMenuByFolderLabel => 'จัดเรียงตาม: โฟลเดอร์';

  @override
  String get viewToggleGridTooltip => 'มุมมองตาราง';

  @override
  String get viewToggleListTooltip => 'มุมมองรายการ';

  @override
  String get drawerHeaderSubtitle => 'สมุดบันทึกส่วนตัวของคุณ';

  @override
  String get drawerNotesSectionHeader => 'โน้ต';

  @override
  String get drawerAllNotesLabel => 'โน้ต';

  @override
  String get drawerFavoritesLabel => 'รายการโปรด';

  @override
  String get drawerAgendaLabel => 'กำหนดการ';

  @override
  String get drawerRemindersLabel => 'การแจ้งเตือน';

  @override
  String get drawerLockedLabel => 'ล็อกไว้';

  @override
  String get drawerTrashLabel => 'ถังขยะ';

  @override
  String get drawerFoldersSectionHeader => 'โฟลเดอร์';

  @override
  String get drawerExpandLabel => 'ขยาย';

  @override
  String get drawerCollapseLabel => 'ย่อ';

  @override
  String get drawerAddFolderLabel => 'เพิ่มโฟลเดอร์';

  @override
  String get drawerAppSectionHeader => 'แอป';

  @override
  String get drawerCalendarLabel => 'ปฏิทิน';

  @override
  String get drawerSettingsLabel => 'การตั้งค่า';

  @override
  String get drawerBackupRestoreLabel => 'สำรองข้อมูลและกู้คืน';

  @override
  String get drawerUpgradeToProLabel => 'อัปเกรดเป็น Pro';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'สนับสนุนการพัฒนา';

  @override
  String get drawerFeedbackLabel => 'ความคิดเห็น';

  @override
  String get drawerAboutLabel => 'เกี่ยวกับ';

  @override
  String get noNotesFoundMessage => 'ไม่พบโน้ต';

  @override
  String get trashRestoreButtonLabel => 'กู้คืน';

  @override
  String get trashPermanentDeleteButtonLabel => 'ลบอย่างถาวร';

  @override
  String get tagRenamedInfoMessage => 'เปลี่ยนชื่อแท็กแล้ว';

  @override
  String get tagDeletedInfoMessage => 'ลบแท็กแล้ว';

  @override
  String get tagOptionsRenameLabel => 'เปลี่ยนชื่อ';

  @override
  String get tagOptionsDeleteLabel => 'ลบ';

  @override
  String get renameTagDialogTitle => 'เปลี่ยนชื่อแท็ก';

  @override
  String get renameTagDialogHint => 'ชื่อแท็กใหม่';

  @override
  String get renameTagDialogCancelButton => 'ยกเลิก';

  @override
  String get renameTagDialogSaveButton => 'บันทึก';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '\"$tag\" จะถูกลบออกจากโน้ต $affectedCount รายการ ดำเนินการต่อหรือไม่?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'ลบแท็ก \"$tag\" หรือไม่?';
  }

  @override
  String get deleteTagDialogTitle => 'ลบแท็ก';

  @override
  String get deleteTagDialogCancelButton => 'ยกเลิก';

  @override
  String get deleteTagDialogConfirmButton => 'ลบ';

  @override
  String get tagsSheetTitle => 'แท็ก';

  @override
  String get tagsSheetEmptyMessage => 'โน้ตนี้ยังไม่มีแท็ก';

  @override
  String get tagsSheetInputHint => 'พิมพ์แท็กใหม่...';

  @override
  String get tagsSheetSuggestionsLabel => 'แท็กที่มีอยู่';

  @override
  String get noteDeletedInfoMessage => 'ลบโน้ตแล้ว';

  @override
  String get noteDeletedUndoActionLabel => 'เลิกทำ';

  @override
  String get reminderSetInfoMessage => 'ตั้งการแจ้งเตือนแล้ว';

  @override
  String get reminderRemovedInfoMessage => 'ลบการแจ้งเตือนแล้ว';

  @override
  String get noteDuplicatedInfoMessage => 'สร้างสำเนาแล้ว';

  @override
  String get speechTextAppendedInfoMessage => 'เพิ่มข้อความลงในโน้ตแล้ว';

  @override
  String get pdfPreparingInfoMessage => 'กำลังเตรียม PDF…';

  @override
  String get pdfSavedInfoMessage => 'บันทึก PDF แล้ว';

  @override
  String get jpgPreparingInfoMessage => 'กำลังเตรียม JPG…';

  @override
  String get jpgSavedInfoMessage => 'บันทึก JPG แล้ว';

  @override
  String get jpgFailedInfoMessage => 'ไม่สามารถสร้าง JPG ได้';

  @override
  String get txtPreparingInfoMessage => 'กำลังเตรียม TXT…';

  @override
  String get txtSavedInfoMessage => 'บันทึก TXT แล้ว';

  @override
  String get txtFailedInfoMessage => 'ไม่สามารถสร้าง TXT ได้';

  @override
  String get exportOpenActionLabel => 'เปิด';

  @override
  String get wrongPasswordInfoMessage => 'รหัสผ่านไม่ถูกต้อง';

  @override
  String get noteArchivedInfoMessage => 'เก็บโน้ตเข้าคลังแล้ว';

  @override
  String get noteUnarchivedInfoMessage => 'นำออกจากคลังแล้ว';

  @override
  String get noteUnlockedInfoMessage => 'ปลดล็อกแล้ว';

  @override
  String get noteLockedInfoMessage => 'ล็อกโน้ตแล้ว';

  @override
  String get notificationUnpinnedInfoMessage => 'ยกเลิกการปักหมุดแล้ว';

  @override
  String get emptyNotePinBlockedInfoMessage =>
      'ไม่สามารถปักหมุดโน้ตที่ว่างเปล่าได้';

  @override
  String get notificationPinnedInfoMessage => 'ปักหมุดไปยังแผงการแจ้งเตือนแล้ว';

  @override
  String get noContentToReadInfoMessage => 'ไม่มีเนื้อหาให้อ่าน';

  @override
  String get backPressExitInfoMessage => 'กดย้อนกลับอีกครั้งเพื่อออก';

  @override
  String get reminderChannelName => 'การแจ้งเตือนโน้ต';

  @override
  String get reminderChannelDescription => 'การแจ้งเตือนโน้ตในแอป Layout';

  @override
  String get pinnedChannelName => 'โน้ตที่ปักหมุด';

  @override
  String get pinnedChannelDescription =>
      'โน้ต Layout ที่ปักหมุดไว้ในแผงการแจ้งเตือน';

  @override
  String get notificationUnpinActionLabel => 'ลบ';

  @override
  String get reminderDefaultTitle => 'การแจ้งเตือน';

  @override
  String get reminderChecklistBodyFallback =>
      'อย่าลืมตรวจสอบรายการตรวจสอบของคุณ';

  @override
  String get reminderTextBodyFallback => 'อย่าลืมตรวจสอบโน้ตของคุณ';

  @override
  String get pdfSaveDialogTitle => 'บันทึกเป็น PDF';

  @override
  String get jpgSaveDialogTitle => 'บันทึกเป็น JPG';

  @override
  String get txtSaveDialogTitle => 'บันทึกเป็น TXT';

  @override
  String get textSizeSheetTitle => 'ขนาดตัวอักษร';

  @override
  String get textSizeSamplePreview => 'ข้อความตัวอย่าง';

  @override
  String get textSizeCancelButton => 'ยกเลิก';

  @override
  String get textSizeApplyButton => 'ใช้';

  @override
  String get createPasswordDialogTitle => 'สร้างรหัสผ่าน';

  @override
  String get createPasswordNewPasswordHint => 'รหัสผ่านใหม่';

  @override
  String get createPasswordConfirmHint => 'ป้อนรหัสผ่านอีกครั้ง';

  @override
  String get createPasswordHintQuestionDescription =>
      'ตั้งคำถามเพื่อความปลอดภัยไว้ในกรณีที่ลืมรหัสผ่าน (ไม่บังคับ)';

  @override
  String get createPasswordHintQuestionHint => 'เลือกคำถามเพื่อความปลอดภัย';

  @override
  String get createPasswordHintAnswerHint => 'คำตอบของคุณ';

  @override
  String get createPasswordCancelButton => 'ยกเลิก';

  @override
  String get createPasswordSaveButton => 'บันทึก';

  @override
  String get passwordMismatchMessage => 'รหัสผ่านไม่ตรงกัน!';

  @override
  String get passwordRequiredDialogTitle => 'ต้องใช้รหัสผ่าน';

  @override
  String get passwordRequiredHint => 'ป้อนรหัสผ่าน';

  @override
  String get forgotPasswordButtonLabel => 'ลืมรหัสผ่าน';

  @override
  String get passwordRequiredCancelButton => 'ยกเลิก';

  @override
  String get passwordRequiredConfirmButton => 'ยืนยัน';

  @override
  String get securityQuestionDialogTitle => 'คำถามเพื่อความปลอดภัย';

  @override
  String get securityQuestionAnswerHint => 'คำตอบของคุณ';

  @override
  String get securityQuestionCancelButton => 'ยกเลิก';

  @override
  String get securityQuestionConfirmButton => 'ยืนยัน';

  @override
  String get securityQuestionWrongAnswerMessage =>
      'คำตอบไม่ถูกต้อง ลองอีกครั้ง';

  @override
  String get revealedPasswordDialogTitle => 'รหัสผ่านของคุณ';

  @override
  String get revealedPasswordLabel => 'รหัสผ่านโน้ตของคุณ:';

  @override
  String get revealedPasswordOkButton => 'ตกลง';

  @override
  String get securityQuestionPetName => 'สัตว์เลี้ยงตัวแรกของคุณชื่ออะไร?';

  @override
  String get securityQuestionFavoriteTeacher => 'ครูคนโปรดของคุณชื่ออะไร?';

  @override
  String get securityQuestionBirthCity => 'คุณเกิดที่เมืองอะไร?';

  @override
  String get securityQuestionFavoriteFood => 'อาหารโปรดของคุณคืออะไร?';

  @override
  String get securityQuestionMotherMaidenName => 'นามสกุลเดิมของแม่คุณคืออะไร?';

  @override
  String get securityQuestionFirstSchool =>
      'โรงเรียนแรกที่คุณเข้าเรียนชื่ออะไร?';

  @override
  String get securityQuestionFavoriteColor => 'สีโปรดของคุณคืออะไร?';

  @override
  String get editFolderDialogTitle => 'แก้ไขโฟลเดอร์';

  @override
  String get newSubfolderDialogTitle => 'โฟลเดอร์ย่อยใหม่';

  @override
  String get addFolderDialogTitle => 'เพิ่มโฟลเดอร์';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'จะถูกสร้างขึ้นภายใน \"$parentCategory\"';
  }

  @override
  String get subfolderNameFieldLabel => 'ชื่อโฟลเดอร์ย่อย';

  @override
  String get folderNameFieldLabel => 'ชื่อโฟลเดอร์';

  @override
  String get folderColorLabel => 'สี';

  @override
  String get folderDialogCancelButton => 'ยกเลิก';

  @override
  String get folderDialogSaveButton => 'บันทึก';

  @override
  String get folderDialogAddButton => 'เพิ่ม';

  @override
  String get selectFolderSheetTitle => 'เลือกโฟลเดอร์';

  @override
  String get selectFolderAddOptionLabel => 'เพิ่มโฟลเดอร์';

  @override
  String get removeCurrentFolderLabel => 'ลบโฟลเดอร์ปัจจุบัน';

  @override
  String get noteDetailsDialogTitle => 'รายละเอียด';

  @override
  String get noteDetailsCreatedLabel => 'สร้างเมื่อ';

  @override
  String get noteDetailsModifiedLabel => 'แก้ไขล่าสุด';

  @override
  String get noteDetailsCharCountLabel => 'จำนวนตัวอักษร';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count ตัวอักษร';
  }

  @override
  String get noteDetailsWordCountLabel => 'จำนวนคำ';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count คำ';
  }

  @override
  String get noteDetailsOkButton => 'ตกลง';

  @override
  String get noteDetailsUnknownDateLabel => 'ไม่ทราบ';

  @override
  String get addAttachmentSheetTitle => 'เพิ่ม';

  @override
  String get addAttachmentImageOption => 'เพิ่มรูปภาพ';

  @override
  String get addAttachmentCameraOption => 'กล้อง';

  @override
  String get addAttachmentFileOption => 'เพิ่มไฟล์';

  @override
  String get addAttachmentVoiceOption => 'การบันทึกเสียง';

  @override
  String get addAttachmentVideoOption => 'บันทึกวิดีโอ';

  @override
  String get addAttachmentScanOption => 'สแกนเอกสาร';

  @override
  String get noteActionsSheetTitle => 'เลือกการกระทำ';

  @override
  String get noteActionReminderLabel => 'การแจ้งเตือน';

  @override
  String get noteActionEditReminderLabel => 'แก้ไขการแจ้งเตือน';

  @override
  String get noteActionSpeechToTextLabel => 'เสียงเป็นข้อความ';

  @override
  String get noteActionArchiveLabel => 'เก็บถาวร';

  @override
  String get noteActionUnarchiveLabel => 'นำออกจากคลัง';

  @override
  String get noteActionLockLabel => 'ล็อก';

  @override
  String get noteActionUnlockLabel => 'ปลดล็อก';

  @override
  String get noteActionFavoriteLabel => 'รายการโปรด';

  @override
  String get noteActionUnfavoriteLabel => 'นำออกจากรายการโปรด';

  @override
  String get noteActionClassifyLabel => 'เลือกโฟลเดอร์';

  @override
  String get noteActionDeleteLabel => 'ลบ';

  @override
  String get noteActionPinToNotificationLabel => 'ปักหมุดไปยังแผงการแจ้งเตือน';

  @override
  String get noteActionUnpinFromNotificationLabel => 'ยกเลิกการปักหมุด';

  @override
  String get noteActionShareLabel => 'แชร์';

  @override
  String get noteActionDuplicateLabel => 'สร้างสำเนา';

  @override
  String get noteActionCopyContentLabel => 'คัดลอกเนื้อหา';

  @override
  String get noteActionTtsLabel => 'อ่านออกเสียง';

  @override
  String get noteActionTextSizeLabel => 'ขนาดตัวอักษร';

  @override
  String get noteActionDetailsLabel => 'รายละเอียด';

  @override
  String get noteActionDiscardChangesLabel => 'ยกเลิกการเปลี่ยนแปลง';

  @override
  String get noteActionSelectLabel => 'เลือก';

  @override
  String get reminderEditOptionLabel => 'เปลี่ยนการแจ้งเตือน';

  @override
  String get reminderRemoveOptionLabel => 'ลบการแจ้งเตือน';

  @override
  String get discardChangesDialogTitle => 'ยกเลิกการเปลี่ยนแปลง';

  @override
  String get discardChangesDialogMessage =>
      'การเปลี่ยนแปลงที่ยังไม่ได้บันทึกในโน้ตนี้จะสูญหาย คุณแน่ใจหรือไม่ว่าต้องการยกเลิก?';

  @override
  String get discardChangesCancelButton => 'ยกเลิก';

  @override
  String get discardChangesConfirmButton => 'ละทิ้ง';

  @override
  String get pinnedNotificationDefaultTitle => 'โน้ต';

  @override
  String get pdfFailedInfoMessage => 'ไม่สามารถสร้าง PDF ได้';

  @override
  String get drawingScreenTitle => 'ภาพวาด';

  @override
  String get drawingMinimizeTooltip => 'ย่อ';

  @override
  String get drawingEmptyExportWarningMessage => 'กรุณาวาดอะไรบางอย่างก่อน';

  @override
  String get drawingEraserPartialModeLabel => 'บางส่วน';

  @override
  String get drawingEraserFullModeLabel => 'ทั้งหมด';

  @override
  String get drawingClearTooltip => 'ล้าง';

  @override
  String get drawingZoomOutTooltip => 'ซูมออก';

  @override
  String get drawingZoomInTooltip => 'ซูมเข้า';

  @override
  String get drawingDeleteTooltip => 'ลบ';

  @override
  String get drawingEmptyPreviewHint => 'แตะเพื่อวาด';

  @override
  String get settingsPageTitle => 'การตั้งค่า';

  @override
  String get settingsSectionGeneral => 'ทั่วไป';

  @override
  String get settingsSectionSecurity => 'ความปลอดภัย';

  @override
  String get settingsSectionTheme => 'ธีม';

  @override
  String get settingsSectionPersonalization => 'การปรับแต่ง';

  @override
  String get settingsSectionWidget => 'วิดเจ็ต';

  @override
  String get settingsSectionAbout => 'เกี่ยวกับ';

  @override
  String get settingsHintQuestionPet => 'สัตว์เลี้ยงตัวแรกของคุณชื่ออะไร?';

  @override
  String get settingsHintQuestionTeacher => 'ครูคนโปรดของคุณชื่ออะไร?';

  @override
  String get settingsHintQuestionBirthCity => 'คุณเกิดที่เมืองอะไร?';

  @override
  String get settingsHintQuestionFavoriteFood => 'อาหารโปรดของคุณคืออะไร?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'นามสกุลเดิมของแม่คุณคืออะไร?';

  @override
  String get settingsHintQuestionFirstSchool =>
      'โรงเรียนแรกที่คุณเข้าเรียนคือโรงเรียนอะไร?';

  @override
  String get settingsHintQuestionFavoriteColor => 'สีโปรดของคุณคืออะไร?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'คำถามเพื่อความปลอดภัย';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'หากคุณลืมรหัสผ่าน คุณสามารถกู้คืนได้โดยการตอบคำถามนี้ให้ถูกต้อง';

  @override
  String get settingsSecurityQuestionDropdownHint =>
      'เลือกคำถามเพื่อความปลอดภัย';

  @override
  String get settingsSecurityQuestionAnswerHint => 'คำตอบของคุณ';

  @override
  String get settingsSecurityQuestionCancelButton => 'ยกเลิก';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'คำถามและคำตอบต้องไม่ว่างเปล่า!';

  @override
  String get settingsSecurityQuestionSaveButton => 'บันทึก';

  @override
  String get settingsCreatePasswordTitle => 'สร้างรหัสผ่าน';

  @override
  String get settingsPasswordRequiredTitle => 'ต้องใช้รหัสผ่าน';

  @override
  String get settingsPasswordEnterHint => 'ป้อนรหัสผ่าน';

  @override
  String get settingsForgotPasswordButton => 'ลืมรหัสผ่าน';

  @override
  String get settingsNewPasswordHint => 'รหัสผ่านใหม่';

  @override
  String get settingsConfirmPasswordHint => 'ป้อนรหัสผ่านอีกครั้ง';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'ตั้งคำถามเพื่อความปลอดภัยไว้ในกรณีที่ลืมรหัสผ่าน (ไม่บังคับ)';

  @override
  String get settingsPasswordDialogCancelButton => 'ยกเลิก';

  @override
  String get settingsPasswordMismatchWarning => 'รหัสผ่านไม่ตรงกัน!';

  @override
  String get settingsWrongPasswordWarning => 'รหัสผ่านไม่ถูกต้อง!';

  @override
  String get settingsPasswordSaveButton => 'บันทึก';

  @override
  String get settingsPasswordRemoveButton => 'ลบ';

  @override
  String get settingsNotePasswordTitle => 'รหัสผ่านโน้ต';

  @override
  String get settingsPasswordSetSubtitle => 'ตั้งรหัสผ่านแล้ว ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'ยังไม่ได้ตั้งรหัสผ่าน';

  @override
  String get settingsSecurityQuestionTileTitle => 'คำถามเพื่อความปลอดภัย';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'ตั้งค่าแล้ว ✓ — ใช้ในกรณีที่คุณลืมรหัสผ่าน';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'ยังไม่ได้ตั้งค่า — คุณจะไม่สามารถกู้คืนรหัสผ่านได้หากลืม';

  @override
  String get settingsThemeDialogTitle => 'เลือกธีม';

  @override
  String get settingsThemeSystemDefault => 'ค่าเริ่มต้นของระบบ';

  @override
  String get settingsThemeLightOption => 'ธีมสว่าง';

  @override
  String get settingsThemeDarkOption => 'ธีมมืด';

  @override
  String get settingsLanguageDialogTitle => 'เลือกภาษา';

  @override
  String get settingsLanguageSystemOption => 'ระบบ';

  @override
  String get settingsAccentColorDialogTitle => 'เลือกสีเน้น';

  @override
  String get settingsThemeChangeTileTitle => 'เปลี่ยนธีม';

  @override
  String get settingsThemeLightLabel => 'สว่าง';

  @override
  String get settingsThemeDarkLabel => 'มืด';

  @override
  String get settingsThemeSystemLabel => 'ระบบ';

  @override
  String get settingsLanguageTileTitle => 'ภาษา';

  @override
  String get settingsAccentColorTileTitle => 'สีเน้น';

  @override
  String get settingsAccentColorTileSubtitle =>
      'สีที่ใช้ในแถบแอป ปุ่ม และสวิตช์';

  @override
  String get settingsColorfulNotesTitle => 'สีโน้ตหลากหลาย';

  @override
  String get settingsColorfulNotesSubtitle =>
      'การ์ดโน้ตแต่ละใบจะได้รับโทนสีที่แตกต่างกัน';

  @override
  String get settingsTextColorSheetTitle => 'สีตัวอักษร';

  @override
  String get settingsTextColorSheetDesc => 'กำหนดสีของข้อความเนื้อหาโน้ต';

  @override
  String get settingsTextColorOkButton => 'ตกลง';

  @override
  String get settingsTextColorTileTitle => 'สีตัวอักษร';

  @override
  String get settingsTextColorTileSubtitle => 'สีสำหรับข้อความเนื้อหาโน้ต';

  @override
  String get settingsWidgetFontSizeLabel => 'ขนาดตัวอักษรวิดเจ็ต';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'หัวข้อตัวอย่าง - $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'ยกเลิก';

  @override
  String get settingsWidgetFontSizeApplyButton => 'ใช้';

  @override
  String get settingsWidgetOpacityLabel => 'ความโปร่งใสพื้นหลัง';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return 'ความโปร่งใส $percent%';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'ยกเลิก';

  @override
  String get settingsWidgetOpacityApplyButton => 'ใช้';

  @override
  String get settingsWidgetDarkModeTitle => 'วิดเจ็ตมืด';

  @override
  String get settingsWidgetDarkModeDesc => 'โทนสีมืดสำหรับวิดเจ็ต';

  @override
  String get settingsAboutVersionTitle => 'เวอร์ชันแอป';

  @override
  String get settingsFontFamilyTileTitle => 'แบบอักษร';

  @override
  String get settingsFontFamilyDefaultLabel => 'ค่าเริ่มต้น';

  @override
  String get settingsGlobalFontSizeTileTitle => 'ขนาดตัวอักษร';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt — ใช้กับโน้ตทั้งหมด';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'ข้อความตัวอย่าง - $size pt';
  }

  @override
  String get settingsGlobalFontSizeApplyToAllLabel => 'ใช้กับโน้ตที่มีอยู่';

  @override
  String get settingsGlobalFontSizeApplyToAllNote =>
      'หากโน้ตมีการตั้งค่าขนาดตัวอักษรเฉพาะไว้ การตั้งค่านี้จะไม่มีผลกับโน้ตนั้น';

  @override
  String get settingsGlobalFontSizeCancelButton => 'ยกเลิก';

  @override
  String get settingsGlobalFontSizeApplyButton => 'ใช้';

  @override
  String get settingsPreviewLinesTileTitle => 'จำนวนบรรทัดตัวอย่างโน้ต';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'แสดงสูงสุด $lines บรรทัด หากโน้ตสั้นกว่านั้น จะแสดงจำนวนบรรทัดจริง';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'ปัจจุบัน: $lines บรรทัด';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'กำหนดจำนวนบรรทัดสูงสุดที่แสดงตัวอย่าง หากโน้ตมีจำนวนบรรทัดน้อยกว่า จะแสดงจำนวนบรรทัดจริง';

  @override
  String get settingsPreviewLinesCancelButton => 'ยกเลิก';

  @override
  String get settingsPreviewLinesApplyButton => 'ใช้';

  @override
  String get backupCancelButton => 'ยกเลิก';

  @override
  String get backupConnectButton => 'เชื่อมต่อ';

  @override
  String get backupDisconnectButton => 'ยกเลิกการเชื่อมต่อ';

  @override
  String get backupContinueButton => 'ดำเนินการต่อ';

  @override
  String get backupCloseButton => 'ปิด';

  @override
  String get backupShareButton => 'แชร์';

  @override
  String get backupRestoreButton => 'กู้คืน';

  @override
  String get backupConfigureButton => 'กำหนดค่า';

  @override
  String get backupUnknownDateLabel => 'ไม่ทราบ';

  @override
  String get backupProcessingDefaultLabel => 'กำลังประมวลผล...';

  @override
  String get backupPermissionRequiredTitle =>
      'ต้องได้รับสิทธิ์เข้าถึงพื้นที่จัดเก็บ';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'Android เวอร์ชันนี้ต้องการสิทธิ์เข้าถึงพื้นที่จัดเก็บสำหรับการสำรอง/กู้คืนข้อมูล เนื่องจากสิทธิ์ถูกปฏิเสธถาวร กรุณาเปิดใช้งานด้วยตนเองจากการตั้งค่าแอป';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'Android เวอร์ชันนี้ต้องการสิทธิ์เข้าถึงพื้นที่จัดเก็บสำหรับการสำรอง/กู้คืนข้อมูล กรุณาอนุญาตเพื่อดำเนินการต่อ';

  @override
  String get backupGoToSettingsButton => 'ไปที่การตั้งค่า';

  @override
  String get backupRetryButton => 'ลองใหม่';

  @override
  String get backupDriveConnectingLabel => 'กำลังเชื่อมต่อกับบัญชี Google...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'เชื่อมต่อกับบัญชี Google Drive แล้ว: $email';
  }

  @override
  String get backupDriveConnectedMessage =>
      'เชื่อมต่อกับบัญชี Google Drive แล้ว';

  @override
  String get backupDriveConnectFailedMessage =>
      'ไม่สามารถเชื่อมต่อกับบัญชี Google ได้ หรือการดำเนินการถูกยกเลิก';

  @override
  String get backupDriveDisconnectTitle => 'ยกเลิกการเชื่อมต่อ Google Drive';

  @override
  String get backupDriveDisconnectBody =>
      'หากยกเลิกการเชื่อมต่อ จะไม่สามารถสำรองข้อมูลไปยัง Drive ได้ทั้งแบบอัตโนมัติหรือด้วยตนเอง ข้อมูลสำรองที่มีอยู่บน Drive แล้วจะไม่ถูกลบ — เพียงแต่จะลบการเข้าถึงจากอุปกรณ์นี้เท่านั้น';

  @override
  String get backupDriveDisconnectedMessage =>
      'ลบการเชื่อมต่อ Google Drive แล้ว';

  @override
  String get backupDriveRequiredTitle => 'ต้องมีบัญชี Google';

  @override
  String get backupDriveRequiredBody =>
      'การดำเนินการนี้ต้องเชื่อมต่อบัญชี Google ของคุณ ต้องการเชื่อมต่อตอนนี้หรือไม่?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: เชื่อมต่อแล้ว ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: เชื่อมต่อแล้ว';

  @override
  String get backupDriveStatusDisconnected =>
      'Google Drive: ยังไม่ได้เชื่อมต่อ';

  @override
  String get backupDriveAuthenticatingLabel => 'กำลังตรวจสอบบัญชี Google...';

  @override
  String get backupDriveNotSignedInMessage =>
      'คุณยังไม่ได้เชื่อมต่อกับ Google Drive กรุณาเข้าสู่ระบบด้วยบัญชี Google ของคุณก่อน';

  @override
  String get backupDriveUploadingLabel =>
      'กำลังอัปโหลดข้อมูลสำรองไปยัง Drive...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'การอัปโหลดไปยัง Google Drive ไม่เสร็จสมบูรณ์ภายใน 120 วินาที (ไม่มีการตอบสนองจากเซิร์ฟเวอร์) กรุณาตรวจสอบการเชื่อมต่อของคุณแล้วลองอีกครั้ง';

  @override
  String get backupDriveOperationCompletedLabel => 'เสร็จสมบูรณ์';

  @override
  String get backupToDriveActionLabel => 'สำรองข้อมูลไปยัง Drive';

  @override
  String get backupToDeviceActionLabel => 'สำรองข้อมูล';

  @override
  String get backupCreatingLabel => 'กำลังสร้างข้อมูลสำรอง...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'ไม่สามารถสร้างข้อมูลสำรองได้: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'การอัปโหลดไปยัง Google Drive ล้มเหลว: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'อัปโหลดข้อมูลสำรองไปยัง Google Drive สำเร็จแล้ว';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'สร้างข้อมูลสำรองแล้ว: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'ข้อมูลสำรองพร้อมแล้ว';

  @override
  String get backupOfferShareBody =>
      'ไฟล์สำรองข้อมูลของคุณถูกบันทึกลงในอุปกรณ์แล้ว ต้องการแชร์ตอนนี้หรือไม่ (เช่น พื้นที่จัดเก็บบนคลาวด์ อีเมล หรืออุปกรณ์อื่น)?';

  @override
  String get backupShareFileText => 'ไฟล์สำรองข้อมูล layout';

  @override
  String backupShareFailedMessage(String error) {
    return 'ไม่สามารถเริ่มการแชร์ได้: $error';
  }

  @override
  String get backupLargeOperationTitle => 'ข้อมูลสำรองขนาดใหญ่';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'ข้อมูลที่จะประมวลผลมีขนาดประมาณ $sizeText การ$actionLabelขนาดนี้อาจใช้เวลาสักครู่ขึ้นอยู่กับอุปกรณ์ของคุณ เพียงอย่าออกจากแอประหว่างดำเนินการ — ต้องการดำเนินการต่อหรือไม่?';
  }

  @override
  String get backupRestoreActionLabel => 'กู้คืนข้อมูล';

  @override
  String get backupDriveListingLabel => 'กำลังแสดงรายการข้อมูลสำรองบน Drive...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'ไม่สามารถแสดงรายการข้อมูลสำรองได้: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'ยังไม่มีข้อมูลสำรองบน Google Drive';

  @override
  String get backupDrivePickTitle => 'เลือกข้อมูลสำรองจาก Drive';

  @override
  String get backupDriveDownloadingLabel =>
      'กำลังดาวน์โหลดข้อมูลสำรองจาก Drive...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'กำลังดาวน์โหลดข้อมูลสำรองจาก Drive... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel => 'กำลังบันทึกไฟล์ลงในอุปกรณ์...';

  @override
  String get backupDriveUnknownBackupFileName => 'unknown_backup.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'พื้นที่จัดเก็บ Google Drive ของคุณเต็ม กรุณาเพิ่มพื้นที่ว่างบน Drive แล้วลองอีกครั้ง';

  @override
  String get backupDriveNetworkErrorMessage =>
      'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อของคุณแล้วลองอีกครั้ง';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'ไม่พบไฟล์สำรองข้อมูลที่ระบุบน Drive อาจถูกลบไปแล้ว';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'เกิดข้อผิดพลาดที่ไม่คาดคิดระหว่างการดำเนินการกับ Google Drive: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'การดาวน์โหลดล้มเหลว: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'ไม่สามารถเลือกไฟล์ได้: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'ไม่สามารถเข้าถึงไฟล์ที่เลือกได้';

  @override
  String get backupCheckingLabel => 'กำลังตรวจสอบข้อมูลสำรอง...';

  @override
  String backupReadFailedMessage(String error) {
    return 'ไม่สามารถอ่านไฟล์สำรองข้อมูลได้: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'กู้คืนข้อมูลสำรอง';

  @override
  String get backupPreviewContentsHeader => 'เนื้อหาของข้อมูลสำรองที่เลือก:';

  @override
  String get backupPreviewNoteCountLabel => 'จำนวนโน้ต';

  @override
  String get backupPreviewTrashCountLabel => 'โน้ตในถังขยะ';

  @override
  String get backupPreviewCategoryCountLabel => 'จำนวนหมวดหมู่';

  @override
  String get backupPreviewAttachmentLabel => 'ไฟล์แนบ';

  @override
  String get backupPreviewAttachmentNoneValue => 'ไม่มี';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count ไฟล์ ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'สร้างเมื่อ';

  @override
  String get backupEmptyPreviewTitle => 'ข้อมูลสำรองนี้ดูเหมือนจะว่างเปล่า';

  @override
  String get backupEmptyPreviewBody =>
      'ไม่พบโน้ต หมวดหมู่ หรือไฟล์แนบในไฟล์ที่เลือก หากดำเนินการต่อ ข้อมูลปัจจุบันของคุณจะยังคงถูกลบและแทนที่ด้วยข้อมูลสำรองที่ว่างเปล่านี้';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return 'ไม่พบไฟล์แนบ $count รายการในข้อมูลสำรอง';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'โน้ตที่มีไฟล์เหล่านี้จะถูกกู้คืน แต่ไม่มีไฟล์แนบ (อาจสูญหายหรือเสียหายในขณะที่ทำการสำรองข้อมูล): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown และอีก $remaining รายการ';
  }

  @override
  String get backupRestoreConfirmBody =>
      'การดำเนินการนี้จะแทนที่โน้ต ถังขยะ หมวดหมู่ การตั้งค่า และไฟล์แนบทั้งหมดที่คุณมีอยู่ ด้วยข้อมูลในไฟล์สำรองข้างต้น ข้อมูลปัจจุบันของคุณจะสูญหายอย่างถาวรและไม่สามารถย้อนกลับได้';

  @override
  String get backupRestoringLabel => 'กำลังกู้คืนข้อมูลสำรอง...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'กู้คืนข้อมูลสำรองแล้ว อย่างไรก็ตาม ไม่พบไฟล์แนบ $count รายการในข้อมูลสำรองและไม่สามารถกู้คืนได้ ขอแนะนำให้รีสตาร์ทแอปเพื่อให้การเปลี่ยนแปลงมีผลอย่างสมบูรณ์';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'กู้คืนข้อมูลสำรองสำเร็จแล้ว ขอแนะนำให้รีสตาร์ทแอปเพื่อให้การเปลี่ยนแปลงมีผลอย่างสมบูรณ์';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'เกิดข้อผิดพลาดขณะกู้คืนข้อมูล: $error';
  }

  @override
  String get backupScreenTitle => 'สำรองข้อมูลและกู้คืน';

  @override
  String get backupBlockedExitWarningMessage =>
      'กำลังดำเนินการอยู่ กรุณารอจนกว่าจะเสร็จสิ้น';

  @override
  String get backupBusyBackTooltip => 'กำลังดำเนินการ';

  @override
  String get backupIntroText =>
      'คุณสามารถสำรองโน้ต หมวดหมู่ การตั้งค่า และไฟล์แนบเป็นไฟล์ .zip ไฟล์เดียว หรือกู้คืนข้อมูลสำรองที่เคยทำไว้ก่อนหน้านี้';

  @override
  String get backupDriveCardTitle => 'สำรองข้อมูลไปยัง Google Drive';

  @override
  String get backupDriveCardSubtitle =>
      'สร้างข้อมูลสำรองใหม่และอัปโหลดไปยังพื้นที่ส่วนตัวใน Google Drive ของคุณโดยตรง';

  @override
  String get backupDriveCardButtonLabel => 'สำรองไปยัง Drive';

  @override
  String get backupDeviceCardTitle => 'สำรองไปยังอุปกรณ์';

  @override
  String get backupDeviceCardSubtitle =>
      'บันทึกข้อมูลทั้งหมดของคุณเป็นไฟล์ .zip ไฟล์เดียวลงในอุปกรณ์ และแชร์ได้หากต้องการ';

  @override
  String get backupDeviceCardButtonLabel => 'สำรองไปยังอุปกรณ์';

  @override
  String get backupHistoryCardTitle => 'ประวัติการสำรองข้อมูล';

  @override
  String get backupHistoryCardSubtitle =>
      'ดูข้อมูลสำรองทั้งหมดที่จัดเก็บบนอุปกรณ์ของคุณพร้อมวันที่และขนาด คุณสามารถแชร์ กู้คืน หรือลบได้โดยตรงจากที่นี่';

  @override
  String get backupHistoryTabDevice => 'อุปกรณ์';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'ลบข้อมูลสำรอง';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'คุณแน่ใจหรือไม่ว่าต้องการลบไฟล์สำรองข้อมูล \"$fileName\" อย่างถาวร? การดำเนินการนี้ไม่สามารถย้อนกลับได้';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'ลบข้อมูลสำรองแล้ว';

  @override
  String get backupHistoryDriveDeleteDialogTitle => 'ลบข้อมูลสำรองบน Drive';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'คุณแน่ใจหรือไม่ว่าต้องการลบข้อมูลสำรอง \"$fileName\" จาก Google Drive อย่างถาวร? การดำเนินการนี้ไม่สามารถย้อนกลับได้ และไฟล์จะไม่ถูกย้ายไปยังถังขยะ';
  }

  @override
  String get backupHistoryDriveDeletedMessage => 'ลบข้อมูลสำรองบน Drive แล้ว';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'ไม่สามารถลบได้: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'ยังไม่มีข้อมูลสำรองที่บันทึกไว้บนอุปกรณ์นี้';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'ใช้ \"สำรองไปยังอุปกรณ์\" เพื่อสร้างข้อมูลสำรองแรกของคุณ';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'ใช้ \"สำรองข้อมูลไปยัง Google Drive\" เพื่อสร้างข้อมูลสำรองบนคลาวด์แรกของคุณ';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'เชื่อมต่อบัญชี Google ของคุณเพื่อดูข้อมูลสำรองบน Drive';

  @override
  String get backupHistoryConnectGoogleButton => 'เชื่อมต่อด้วย Google';

  @override
  String get backupHistoryDriveConnectedFallback => 'เชื่อมต่อแล้ว';

  @override
  String get backupHistoryUnknownErrorFallback =>
      'เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ';

  @override
  String get backupHistoryDownloadStartingLabel => 'กำลังเริ่ม...';

  @override
  String get backupAutoBackupEnabledLabel => 'การสำรองข้อมูลอัตโนมัติ: เปิด';

  @override
  String get backupAutoBackupDisabledLabel => 'การสำรองข้อมูลอัตโนมัติ: ปิด';

  @override
  String get backupOverlayWarningMessage =>
      'กรุณารอสักครู่ อย่าออกจากแอปจนกว่าการดำเนินการจะเสร็จสิ้น';

  @override
  String get pdfExportUntitledNoteLabel => 'โน้ตไม่มีชื่อ';

  @override
  String get pdfExportDefaultAttachmentName => 'ไฟล์แนบ';

  @override
  String get pdfExportDefaultFileName => 'โน้ต';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'ไม่สามารถจับภาพหน้าจอได้ (ไม่พบขอบเขต)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'ไม่สามารถสร้างข้อมูลภาพหน้าจอได้';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'ไม่สามารถประมวลผลภาพได้ (การถอดรหัส PNG ล้มเหลว)';

  @override
  String get screenshotCalcTableTotalLabel => 'รวม';

  @override
  String get gundemMenuRemoveFromAgenda => 'ลบออกจากกำหนดการ';

  @override
  String get gundemMenuDeleteNote => 'ลบโน้ต';

  @override
  String get gundemSectionOverdue => 'เลยกำหนด';

  @override
  String get gundemSectionToday => 'วันนี้';

  @override
  String get gundemSectionTomorrow => 'พรุ่งนี้';

  @override
  String get gundemSectionNextWeek => 'สัปดาห์หน้า';

  @override
  String get gundemSectionFurther => 'ในอนาคต';

  @override
  String get gundemWeekdayMonday => 'วันจันทร์';

  @override
  String get gundemWeekdayTuesday => 'วันอังคาร';

  @override
  String get gundemWeekdayWednesday => 'วันพุธ';

  @override
  String get gundemWeekdayThursday => 'วันพฤหัสบดี';

  @override
  String get gundemWeekdayFriday => 'วันศุกร์';

  @override
  String get gundemWeekdaySaturday => 'วันเสาร์';

  @override
  String get gundemWeekdaySunday => 'วันอาทิตย์';

  @override
  String get gundemAppBarTitle => 'กำหนดการ';

  @override
  String get gundemCalendarTooltip => 'ปฏิทิน';

  @override
  String get gundemEmptyTitle => 'ไม่มีรายการในกำหนดการของคุณ';

  @override
  String get gundemEmptySubtitle =>
      'โน้ตที่มีการแจ้งเตือนหรือกำหนดวันที่จะปรากฏที่นี่';

  @override
  String get gundemUntitledNote => 'โน้ตไม่มีชื่อ';

  @override
  String get gundemRepeatHourly => 'รายชั่วโมง';

  @override
  String get gundemRepeatDaily => 'รายวัน';

  @override
  String get gundemRepeatWeekly => 'รายสัปดาห์';

  @override
  String get gundemRepeatMonthly => 'รายเดือน';

  @override
  String get gundemRepeatYearly => 'รายปี';

  @override
  String get gundemPreviewCalcTableLabel => '[รายการคำนวณ]';

  @override
  String get gundemPreviewDrawingLabel => '[ภาพวาด]';

  @override
  String get gundemPreviewImageLabel => '[รูปภาพ]';

  @override
  String get gundemMonthShortJan => 'ม.ค.';

  @override
  String get gundemMonthShortFeb => 'ก.พ.';

  @override
  String get gundemMonthShortMar => 'มี.ค.';

  @override
  String get gundemMonthShortApr => 'เม.ย.';

  @override
  String get gundemMonthShortMay => 'พ.ค.';

  @override
  String get gundemMonthShortJun => 'มิ.ย.';

  @override
  String get gundemMonthShortJul => 'ก.ค.';

  @override
  String get gundemMonthShortAug => 'ส.ค.';

  @override
  String get gundemMonthShortSep => 'ก.ย.';

  @override
  String get gundemMonthShortOct => 'ต.ค.';

  @override
  String get gundemMonthShortNov => 'พ.ย.';

  @override
  String get gundemMonthShortDec => 'ธ.ค.';

  @override
  String get calendarAppBarTitle => 'ปฏิทิน';

  @override
  String get calendarTodayButton => 'วันนี้';

  @override
  String get calendarLegendNoteLabel => 'โน้ต';

  @override
  String get calendarLegendReminderLabel => 'การแจ้งเตือน';

  @override
  String get calendarTodayBadge => 'วันนี้';

  @override
  String get calendarEmptyDayMessage => 'ไม่มีโน้ตหรือการแจ้งเตือนสำหรับวันนี้';

  @override
  String get calendarReminderHourlyLabel => 'รายชั่วโมง';

  @override
  String get calendarMonthJan => 'มกราคม';

  @override
  String get calendarMonthFeb => 'กุมภาพันธ์';

  @override
  String get calendarMonthMar => 'มีนาคม';

  @override
  String get calendarMonthApr => 'เมษายน';

  @override
  String get calendarMonthMay => 'พฤษภาคม';

  @override
  String get calendarMonthJun => 'มิถุนายน';

  @override
  String get calendarMonthJul => 'กรกฎาคม';

  @override
  String get calendarMonthAug => 'สิงหาคม';

  @override
  String get calendarMonthSep => 'กันยายน';

  @override
  String get calendarMonthOct => 'ตุลาคม';

  @override
  String get calendarMonthNov => 'พฤศจิกายน';

  @override
  String get calendarMonthDec => 'ธันวาคม';

  @override
  String get calendarWeekdayShortMon => 'จ.';

  @override
  String get calendarWeekdayShortTue => 'อ.';

  @override
  String get calendarWeekdayShortWed => 'พ.';

  @override
  String get calendarWeekdayShortThu => 'พฤ.';

  @override
  String get calendarWeekdayShortFri => 'ศ.';

  @override
  String get calendarWeekdayShortSat => 'ส.';

  @override
  String get calendarWeekdayShortSun => 'อา.';

  @override
  String get calendarWeekdayFullMonday => 'วันจันทร์';

  @override
  String get calendarWeekdayFullTuesday => 'วันอังคาร';

  @override
  String get calendarWeekdayFullWednesday => 'วันพุธ';

  @override
  String get calendarWeekdayFullThursday => 'วันพฤหัสบดี';

  @override
  String get calendarWeekdayFullFriday => 'วันศุกร์';

  @override
  String get calendarWeekdayFullSaturday => 'วันเสาร์';

  @override
  String get calendarWeekdayFullSunday => 'วันอาทิตย์';

  @override
  String get wrongPasswordDialogTitle => 'รหัสผ่านไม่ถูกต้อง';

  @override
  String get wrongPasswordDialogMessage => 'รหัสผ่านที่คุณป้อนไม่ถูกต้อง';

  @override
  String get commonOkButton => 'ตกลง';

  @override
  String get unlockCategoryAction => 'ปลดล็อก';

  @override
  String get lockCategoryAction => 'ล็อก';

  @override
  String get categoryUnlockedMessage => 'ปลดล็อกแล้ว';

  @override
  String get categoryLockedMessage => 'ล็อกโฟลเดอร์แล้ว';

  @override
  String get deleteFolderMenuItemLabel => 'ลบโฟลเดอร์';

  @override
  String get deleteFolderDialogTitle => 'ลบโฟลเดอร์';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'คุณแน่ใจหรือไม่ว่าต้องการลบโฟลเดอร์ \"$category\" และโฟลเดอร์ย่อยทั้งหมด? โน้ตในโฟลเดอร์เหล่านี้จะไม่มีหมวดหมู่';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'คุณแน่ใจหรือไม่ว่าต้องการลบโฟลเดอร์ \"$category\"? โน้ตในโฟลเดอร์นี้จะไม่มีหมวดหมู่';
  }

  @override
  String get deleteFolderDialogCancelButton => 'ยกเลิก';

  @override
  String get deleteFolderDialogConfirmButton => 'ลบ';

  @override
  String get editCategoryNameColorMenuItemLabel => 'แก้ไขชื่อ/สี';

  @override
  String get addSubfolderMenuItemLabel => 'สร้างโฟลเดอร์ย่อย';

  @override
  String get expandSubfoldersMenuItemLabel => 'ขยายโฟลเดอร์ย่อย';

  @override
  String get collapseSubfoldersMenuItemLabel => 'ย่อโฟลเดอร์ย่อย';

  @override
  String saveErrorInfoMessage(String error) {
    return 'ข้อผิดพลาดในการบันทึก: $error';
  }

  @override
  String get welcomeNoteTitle => 'ยินดีต้อนรับสู่ DNote! 🚀';

  @override
  String get welcomeNoteContent => 'เพิ่มฟีเจอร์ใหม่แล้ว!';

  @override
  String get noteListDateGroupToday => 'วันนี้';

  @override
  String get noteListDateGroupYesterday => 'เมื่อวาน';

  @override
  String get noteListDateGroupLast7Days => '7 วันที่ผ่านมา';

  @override
  String get noteListDateGroupLast30Days => '30 วันที่ผ่านมา';

  @override
  String get reminderRepeatNoneLabel => 'ไม่ทำซ้ำ';

  @override
  String get voiceRecorderPreparingLabel => 'กำลังเตรียม…';

  @override
  String get voiceRecorderCancelButton => 'ยกเลิก';

  @override
  String get voiceRecorderStopAddButton => 'หยุดและเพิ่ม';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'ไม่ได้รับสิทธิ์เข้าถึงไมโครโฟน';

  @override
  String get speechToTextUnavailableMessage =>
      'การรู้จำเสียงไม่พร้อมใช้งานบนอุปกรณ์นี้';

  @override
  String get speechToTextPreparingLabel => 'กำลังเตรียม…';

  @override
  String get speechToTextListeningLabel => 'กำลังฟัง…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'เริ่มพูด…';

  @override
  String get speechToTextCancelButton => 'ยกเลิก';

  @override
  String get speechToTextStopAddButton => 'หยุดและเพิ่ม';

  @override
  String get textToSpeechNoContentMessage => 'ไม่มีเนื้อหาให้อ่าน';

  @override
  String get textToSpeechReadErrorMessage => 'เกิดข้อผิดพลาดขณะอ่าน';

  @override
  String get textToSpeechUnavailableMessage =>
      'ระบบแปลงข้อความเป็นเสียงไม่พร้อมใช้งานบนอุปกรณ์นี้';

  @override
  String get textToSpeechPreparingLabel => 'กำลังเตรียม…';

  @override
  String get textToSpeechPausedLabel => 'หยุดชั่วคราว';

  @override
  String get textToSpeechFinishedLabel => 'อ่านเสร็จสิ้น';

  @override
  String get textToSpeechReadingLabel => 'กำลังอ่าน…';

  @override
  String get textToSpeechCloseErrorButton => 'ปิด';

  @override
  String get textToSpeechReplayButton => 'อ่านอีกครั้ง';

  @override
  String get textToSpeechCloseFinishedButton => 'ปิด';

  @override
  String get textToSpeechPauseButton => 'หยุดชั่วคราว';

  @override
  String get textToSpeechResumeButton => 'ดำเนินการต่อ';

  @override
  String get textToSpeechStopButton => 'หยุด';

  @override
  String get textToSpeechSpeedSlow => 'ช้า';

  @override
  String get textToSpeechSpeedNormal => 'ปกติ';

  @override
  String get textToSpeechSpeedFast => 'เร็ว';

  @override
  String get calendarPickerCancelButton => 'ยกเลิก';

  @override
  String get calendarPickerConfirmButton => 'เลือก';

  @override
  String get calendarPickerClearButton => 'ล้าง';

  @override
  String get reminderPickerDialogTitle => 'เพิ่มการแจ้งเตือน';

  @override
  String get reminderPickerDateTodayOption => 'วันนี้';

  @override
  String get reminderPickerDateTomorrowOption => 'พรุ่งนี้';

  @override
  String get reminderPickerDatePickOption => 'เลือกวันที่';

  @override
  String get reminderRepeatHourlyLabel => 'ทุกชั่วโมง';

  @override
  String get reminderRepeatDailyLabel => 'ทุกวัน';

  @override
  String get reminderRepeatWeeklyLabel => 'ทุกสัปดาห์';

  @override
  String get reminderRepeatMonthlyLabel => 'ทุกเดือน';

  @override
  String get reminderRepeatYearlyLabel => 'ทุกปี';

  @override
  String get reminderPickerCalendarHelpText => 'เลือกวันที่แจ้งเตือน';

  @override
  String get reminderPickerCancelButton => 'ยกเลิก';

  @override
  String get reminderPickerSaveButton => 'บันทึก';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'ไม่สามารถเลือกเวลาที่ผ่านมาแล้วได้';

  @override
  String calcTableTotalLabel(String amount) {
    return 'รวม: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'กำลังเตรียมข้อมูล...';

  @override
  String get backupCreatePackagingNotesLabel => 'กำลังบรรจุโน้ตและหมวดหมู่...';

  @override
  String get backupCreateReadingAttachmentsLabel => 'กำลังอ่านไฟล์แนบ...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'กำลังอ่านไฟล์แนบ... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'กำลังบีบอัดไฟล์ zip...';

  @override
  String get backupCreateSavingFileLabel => 'กำลังบันทึกไฟล์...';

  @override
  String get backupRestoreValidatingLabel => 'กำลังตรวจสอบข้อมูลสำรอง...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'ตรวจสอบข้อมูลสำรองแล้ว กำลังเตรียมข้อมูล...';

  @override
  String get backupRestoreWritingNotesLabel => 'กำลังเขียนโน้ต...';

  @override
  String get backupRestoreWritingTrashLabel => 'กำลังเขียนถังขยะ...';

  @override
  String get backupRestoreTrashWrittenLabel => 'เขียนถังขยะแล้ว';

  @override
  String get backupRestoreWritingCategoriesLabel => 'กำลังเขียนหมวดหมู่...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'เขียนหมวดหมู่แล้ว';

  @override
  String get backupRestoreWritingSettingsLabel => 'กำลังเขียนการตั้งค่า...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'เขียนการตั้งค่าแล้ว';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'กำลังล้างไฟล์แนบเก่า...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'ไม่พบไฟล์แนบ กำลังเสร็จสิ้น...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'กำลังกู้คืนไฟล์แนบ... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'เสร็จสมบูรณ์';

  @override
  String get backupValidationCorruptedFileMessage =>
      'ไฟล์เสียหายหรือไม่ใช่ไฟล์สำรองข้อมูลที่ถูกต้อง';

  @override
  String get backupValidationMissingDataMessage =>
      'ไม่พบข้อมูลภายในไฟล์สำรองข้อมูล (ไม่มีไฟล์ backup_data.json)';

  @override
  String get backupValidationInvalidJsonMessage =>
      'ไม่สามารถอ่านข้อมูลสำรองได้ (JSON เสียหาย)';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'ไฟล์นี้ไม่ใช่ข้อมูลสำรองจากแอป dnote';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'ไม่สามารถอ่านข้อมูลเวอร์ชันของไฟล์สำรองข้อมูลได้';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'ข้อมูลสำรองนี้อยู่ในรูปแบบใหม่ที่แอปเวอร์ชันปัจจุบันไม่รองรับ กรุณาอัปเดตแอป';

  @override
  String get backupValidationInvalidVersionMessage =>
      'ข้อมูลเวอร์ชันของไฟล์สำรองข้อมูลไม่ถูกต้อง';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'ข้อมูลสำรองไม่อยู่ในรูปแบบที่คาดไว้ (ไม่มีฟิลด์โน้ต)';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'ข้อมูลสำรองไม่อยู่ในรูปแบบที่คาดไว้ (ไม่มีฟิลด์ถังขยะ)';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'ข้อมูลสำรองไม่อยู่ในรูปแบบที่คาดไว้ (รายการหมวดหมู่ไม่ถูกต้อง)';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'ข้อมูลสำรองไม่อยู่ในรูปแบบที่คาดไว้ (ฟิลด์การตั้งค่าไม่ถูกต้อง)';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'ข้อมูลสำรองไม่อยู่ในรูปแบบที่คาดไว้ (ข้อมูลโน้ตรายการหนึ่งไม่ถูกต้อง)';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'ข้อมูลสำรองไม่อยู่ในรูปแบบที่คาดไว้ (พบข้อมูลโน้ตที่ไม่มี ID)';

  @override
  String get backupValidationFileNotFoundMessage => 'ไม่พบไฟล์สำรองข้อมูล';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'พื้นที่จัดเก็บว่างบนอุปกรณ์ไม่เพียงพอ กรุณาเพิ่มพื้นที่ว่างแล้วลองอีกครั้ง';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'การเข้าถึงไฟล์ถูกปฏิเสธ กรุณาตรวจสอบสิทธิ์ของแอปแล้วลองอีกครั้ง';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'เกิดข้อผิดพลาดระหว่างการดำเนินการไฟล์: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'เกิดข้อผิดพลาดที่ไม่คาดคิด: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'ไม่สามารถสร้างไฟล์ zip ได้ (ZipEncoder ส่งค่า null กลับมา)';

  @override
  String get calcTableMenuItemLabel => 'รายการคำนวณ';

  @override
  String get tagsMenuItemLabel => 'แท็ก';

  @override
  String get linkDialogUrlHint => 'https://example.com';

  @override
  String get checklistItemHint => 'เพิ่มรายการ...';

  @override
  String get toolbarHighlightTooltip => 'ไฮไลต์';

  @override
  String get toolbarListTooltip => 'รายการ';

  @override
  String get toolbarHideKeyboardTooltip => 'ซ่อนแป้นพิมพ์';

  @override
  String get autoBackupLocalSuccessMessage => 'สำรองข้อมูลในเครื่องสำเร็จ';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'สำรองข้อมูลในเครื่องล้มเหลว: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'ข้ามการสำรองข้อมูลไปยัง Drive: บัญชี Google ยังไม่ได้เชื่อมต่อหรือเซสชันหมดอายุ กรุณาเปิดแอปและเชื่อมต่อใหม่';

  @override
  String get autoBackupDriveSuccessMessage => 'สำรองข้อมูลไปยัง Drive สำเร็จ';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'สำรองข้อมูลไปยัง Drive ล้มเหลว: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'ยังไม่มีโน้ต';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'รวม: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ ภาพวาด';

  @override
  String get autoBackupSettingsAppBarTitle => 'การตั้งค่าสำรองข้อมูลอัตโนมัติ';

  @override
  String get autoBackupSettingsMainSwitchTitle =>
      'เปิดใช้งานการสำรองข้อมูลอัตโนมัติ';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'โน้ตของคุณจะถูกสำรองข้อมูลอย่างปลอดภัยเป็นระยะในเบื้องหลัง';

  @override
  String get autoBackupSettingsTargetTitle => 'เป้าหมายการสำรองข้อมูล';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'เลือกตำแหน่งที่จะบันทึกข้อมูลสำรอง';

  @override
  String get autoBackupSettingsTargetLocalOption => 'ในเครื่อง';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'ทั้งสองอย่าง';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'เชื่อมต่อบัญชีของคุณก่อนเพื่อใช้ตัวเลือก Google Drive';

  @override
  String get autoBackupSettingsConnectButton => 'เชื่อมต่อ';

  @override
  String get autoBackupSettingsFrequencyTitle => 'ความถี่ในการสำรองข้อมูล';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'ทำการสำรองข้อมูลทุก $hours ชั่วโมง';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 ชั่วโมง';

  @override
  String get autoBackupSettingsFrequency12h => '12 ชั่วโมง';

  @override
  String get autoBackupSettingsFrequency24h => '24 ชั่วโมง (รายวัน)';

  @override
  String get autoBackupSettingsFrequency48h => '48 ชั่วโมง (2 วัน)';

  @override
  String get autoBackupSettingsFrequency168h => '168 ชั่วโมง (รายสัปดาห์)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'ใช้ Wi-Fi เท่านั้น';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'การอัปโหลดขึ้นคลาวด์จะเกิดขึ้นผ่าน Wi-Fi เท่านั้นเพื่อประหยัดอินเทอร์เน็ตมือถือของคุณ';

  @override
  String get autoBackupSettingsStatusCardTitle => 'สถานะระบบ';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'การสำรองข้อมูลอัตโนมัติยังไม่เคยทำงาน';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'ทำงานล่าสุด: $date $time ($status)\\nข้อความ: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'สำเร็จ';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'ล้มเหลว';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'ไม่สามารถเชื่อมต่อกับบัญชี Google ได้';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'อัปเดตการตั้งค่าสำรองข้อมูลอัตโนมัติแล้ว';

  @override
  String selectionModeDeletedMessage(int count) {
    return 'ลบโน้ตแล้ว $count รายการ';
  }

  @override
  String get selectionModeArchivedMessage => 'เก็บถาวรแล้ว';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'เลือกหมวดหมู่สำหรับโน้ต $count รายการ';
  }

  @override
  String get selectionModeAddCategoryOption => 'เพิ่มหมวดหมู่';

  @override
  String get selectionModeRemoveCategoryOption => 'ลบหมวดหมู่';

  @override
  String get calcTableItemHint => 'รายการ...';

  @override
  String get calcTableTotalRowLabel => 'รวม';

  @override
  String get textSelectionMenuShareButton => 'แชร์';

  @override
  String get textSelectionMenuTranslateButton => 'แปล';

  @override
  String get textSelectionMenuShareFailedSnackbar => 'ไม่สามารถเริ่มการแชร์ได้';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'ไม่สามารถเปิดการแปลได้';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'วันนี้ $time';
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
    return 'สำรองข้อมูลล่าสุด: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage => 'ยังไม่เคยมีการสำรองข้อมูล';
}
