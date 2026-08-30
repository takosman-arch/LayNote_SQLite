// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'बोल्ड';

  @override
  String get toolbarItalicTooltip => 'इटैलिक';

  @override
  String get toolbarUnderlineTooltip => 'अंडरलाइन';

  @override
  String get toolbarStrikethroughTooltip => 'स्ट्राइकथ्रू';

  @override
  String get toolbarFontSizeTooltip => 'फ़ॉन्ट आकार';

  @override
  String get toolbarColorTooltip => 'टेक्स्ट रंग';

  @override
  String get toolbarBulletTooltip => 'बुलेट सूची';

  @override
  String get toolbarNumberTooltip => 'क्रमांकित सूची';

  @override
  String get toolbarIndentTooltip => 'पैराग्राफ इंडेंट';

  @override
  String get toolbarLinkTooltip => 'लिंक जोड़ें / संपादित करें / हटाएं';

  @override
  String get toolbarDividerTooltip => 'विभाजक डालें';

  @override
  String get toolbarChecklistTooltip => 'चेकलिस्ट जोड़ें';

  @override
  String get linkSelectTextSnackbar =>
      'पहले वह टेक्स्ट चुनें जिसे आप लिंक करना चाहते हैं';

  @override
  String get linkDialogEditTitle => 'लिंक संपादित करें';

  @override
  String get linkDialogAddTitle => 'लिंक जोड़ें';

  @override
  String get linkDialogRemoveButton => 'लिंक हटाएं';

  @override
  String get linkDialogCancelButton => 'रद्द करें';

  @override
  String get linkDialogConfirmButton => 'जोड़ें';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'कैमरा अनुमति अस्वीकृत। वीडियो रिकॉर्ड करने के लिए आपको इसे सेटिंग्स से अनुमति देनी होगी।';

  @override
  String get cameraPermissionRequiredMessage =>
      'वीडियो रिकॉर्ड करने के लिए कैमरा अनुमति आवश्यक है।';

  @override
  String get openSettingsButtonLabel => 'सेटिंग्स';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'स्कैन शुरू नहीं किया जा सका: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'टेक्स्ट पहचान विफल: $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'दस्तावेज़ में कोई पठनीय टेक्स्ट नहीं मिला';

  @override
  String get scanResultSheetTitle =>
      'स्कैन किए गए दस्तावेज़ को कैसे जोड़ा जाए?';

  @override
  String get scanResultTextOnlyOption => 'केवल टेक्स्ट के रूप में जोड़ें';

  @override
  String get scanResultTextAndImageOption => 'टेक्स्ट + स्कैन की गई छवि जोड़ें';

  @override
  String get scanResultCancelOption => 'रद्द करें';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'माइक्रोफ़ोन अनुमति अस्वीकृत। ऑडियो रिकॉर्ड करने के लिए आपको इसे सेटिंग्स से अनुमति देनी होगी।';

  @override
  String get audioPermissionRequiredMessage =>
      'ऑडियो रिकॉर्ड करने के लिए माइक्रोफ़ोन अनुमति आवश्यक है।';

  @override
  String get voiceRecordingDefaultLabel => 'वॉइस रिकॉर्डिंग';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'कैलकुलेशन सूची ($count पंक्तियाँ)';
  }

  @override
  String blockPreviewTableLabel(int count) {
    return 'तालिका ($count पंक्तियाँ)';
  }

  @override
  String get blockPreviewDrawingLabel => 'ड्राइंग';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count अटैचमेंट (फोटो/दस्तावेज़)';
  }

  @override
  String get blockPreviewDividerLabel => 'विभाजक';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'चेकलिस्ट ($count आइटम)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(खाली टेक्स्ट)';

  @override
  String get reorderBlocksSheetTitle => 'ब्लॉक फिर से व्यवस्थित करें';

  @override
  String get reorderBlocksMoveUpTooltip => 'ऊपर ले जाएं';

  @override
  String get reorderBlocksMoveDownTooltip => 'नीचे ले जाएं';

  @override
  String get reorderBlocksCloseTooltip => 'बंद करें';

  @override
  String get reorderBlocksDescription =>
      'किसी ब्लॉक को चुनने के लिए टैप करें, फिर उसे स्थानांतरित करने के लिए ऊपर/नीचे तीरों का उपयोग करें।';

  @override
  String get reorderBlocksMenuItemLabel => 'फिर से व्यवस्थित करें';

  @override
  String get txtImportPickerDialogTitle => 'आयात करने के लिए TXT फ़ाइल चुनें';

  @override
  String get txtImportReadFailedMessage => 'TXT फ़ाइल पढ़ी नहीं जा सकी';

  @override
  String get txtImportEmptyFileMessage => 'TXT फ़ाइल खाली है';

  @override
  String get txtImportSuccessMessage => 'TXT आयात किया गया';

  @override
  String get txtImportMenuItemLabel => 'आयात करें (txt)';

  @override
  String get exportMenuItemLabel => 'एक्सपोर्ट';

  @override
  String get editorUndoTooltip => 'पूर्ववत करें';

  @override
  String get editorRedoTooltip => 'फिर से करें';

  @override
  String get noteSavedMessage => 'नोट सहेजा गया';

  @override
  String get dateAssignPickerHelpText => 'नोट को किसी दिन को असाइन करें';

  @override
  String get dateAssignChangeOption => 'तारीख बदलें';

  @override
  String get dateAssignRemoveOption => 'असाइनमेंट हटाएं';

  @override
  String get editorSubToolbarCloseTooltip => 'बंद करें';

  @override
  String get titleFieldHint => 'शीर्षक';

  @override
  String get textBlockHint => 'अपना नोट यहां लिखें...';

  @override
  String get drawingBoardMenuItemLabel => 'ड्राइंग बोर्ड';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'वॉइस-टू-टेक्स्ट केवल टेक्स्ट नोट्स के लिए उपलब्ध है';

  @override
  String get selectionModeCancelTooltip => 'चयन रद्द करें';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return '$count चयनित';
  }

  @override
  String get selectionModeDeleteTooltip => 'हटाएं';

  @override
  String get selectionModeArchiveTooltip => 'संग्रह करें';

  @override
  String get selectionModeFolderTooltip => 'फ़ोल्डर';

  @override
  String get searchFieldHint => 'नोट्स खोजें...';

  @override
  String get emptyTrashDialogTitle => 'ट्रैश खाली करें';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'सभी हटाए गए नोट्स स्थायी रूप से हटा दिए जाएंगे। क्या आप सुनिश्चित हैं?';

  @override
  String get emptyTrashDialogCancelButton => 'रद्द करें';

  @override
  String get restoreAllMenuItemLabel => 'सभी पुनर्स्थापित करें';

  @override
  String get sortMenuTooltip => 'नोट्स क्रमबद्ध करें';

  @override
  String get sortMenuAscendingLabel => 'क्रम: आरोही (A-Z)';

  @override
  String get sortMenuDescendingLabel => 'क्रम: अवरोही (Z-A)';

  @override
  String get sortMenuByTitleLabel => 'इसके अनुसार क्रमबद्ध करें: शीर्षक';

  @override
  String get sortMenuByModifiedDateLabel =>
      'इसके अनुसार क्रमबद्ध करें: अंतिम संशोधन';

  @override
  String get sortMenuByCreatedDateLabel =>
      'इसके अनुसार क्रमबद्ध करें: निर्माण तिथि';

  @override
  String get sortMenuByFolderLabel => 'इसके अनुसार क्रमबद्ध करें: फ़ोल्डर';

  @override
  String get viewToggleGridTooltip => 'ग्रिड दृश्य';

  @override
  String get viewToggleListTooltip => 'सूची दृश्य';

  @override
  String get drawerHeaderSubtitle => 'आपकी व्यक्तिगत नोटबुक';

  @override
  String get drawerNotesSectionHeader => 'नोट्स';

  @override
  String get drawerAllNotesLabel => 'नोट्स';

  @override
  String get drawerFavoritesLabel => 'पसंदीदा';

  @override
  String get drawerAgendaLabel => 'एजेंडा';

  @override
  String get drawerRemindersLabel => 'रिमाइंडर';

  @override
  String get drawerLockedLabel => 'लॉक्ड';

  @override
  String get drawerTrashLabel => 'ट्रैश';

  @override
  String get drawerFoldersSectionHeader => 'फ़ोल्डर';

  @override
  String get drawerExpandLabel => 'विस्तृत करें';

  @override
  String get drawerCollapseLabel => 'संक्षिप्त करें';

  @override
  String get drawerAddFolderLabel => 'फ़ोल्डर जोड़ें';

  @override
  String get drawerAppSectionHeader => 'ऐप';

  @override
  String get drawerCalendarLabel => 'कैलेंडर';

  @override
  String get drawerSettingsLabel => 'सेटिंग्स';

  @override
  String get drawerBackupRestoreLabel => 'बैकअप और पुनर्स्थापना';

  @override
  String get drawerUpgradeToProLabel => 'प्रो में अपग्रेड करें';

  @override
  String get drawerProBadgeLabel => 'प्रो';

  @override
  String get drawerSupportDevelopmentLabel => 'विकास का समर्थन करें';

  @override
  String get drawerFeedbackLabel => 'फीडबैक';

  @override
  String get drawerRateAppLabel => 'ऐप को रेट करें';

  @override
  String get drawerAboutLabel => 'के बारे में';

  @override
  String get noNotesFoundMessage => 'कोई नोट नहीं मिला।';

  @override
  String get trashRestoreButtonLabel => 'पुनर्स्थापित करें';

  @override
  String get trashPermanentDeleteButtonLabel => 'स्थायी रूप से हटाएं';

  @override
  String get tagRenamedInfoMessage => 'टैग का नाम बदला गया';

  @override
  String get tagDeletedInfoMessage => 'टैग हटाया गया';

  @override
  String get tagOptionsRenameLabel => 'नाम बदलें';

  @override
  String get tagOptionsDeleteLabel => 'हटाएं';

  @override
  String get renameTagDialogTitle => 'टैग का नाम बदलें';

  @override
  String get renameTagDialogHint => 'नया टैग नाम';

  @override
  String get renameTagDialogCancelButton => 'रद्द करें';

  @override
  String get renameTagDialogSaveButton => 'सहेजें';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '\"$tag\" को $affectedCount नोट्स से हटा दिया जाएगा। जारी रखें?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return '\"$tag\" टैग हटाएं?';
  }

  @override
  String get deleteTagDialogTitle => 'टैग हटाएं';

  @override
  String get deleteTagDialogCancelButton => 'रद्द करें';

  @override
  String get deleteTagDialogConfirmButton => 'हटाएं';

  @override
  String get tagsSheetTitle => 'टैग';

  @override
  String get tagsSheetEmptyMessage => 'इस नोट पर अभी तक कोई टैग नहीं है।';

  @override
  String get tagsSheetInputHint => 'एक नया टैग लिखें...';

  @override
  String get tagsSheetSuggestionsLabel => 'मौजूदा टैग';

  @override
  String get noteDeletedInfoMessage => 'नोट हटाया गया';

  @override
  String get noteDeletedUndoActionLabel => 'पूर्ववत करें';

  @override
  String get reminderSetInfoMessage => 'रिमाइंडर सेट किया गया';

  @override
  String get reminderRemovedInfoMessage => 'रिमाइंडर हटाया गया';

  @override
  String get noteDuplicatedInfoMessage => 'कॉपी बनाई गई';

  @override
  String get speechTextAppendedInfoMessage => 'नोट में टेक्स्ट जोड़ा गया';

  @override
  String get pdfPreparingInfoMessage => 'PDF तैयार किया जा रहा है…';

  @override
  String get pdfSavedInfoMessage => 'PDF सहेजा गया';

  @override
  String get pdfPreviewSaveActionLabel => 'सहेजें';

  @override
  String get jpgPreparingInfoMessage => 'JPG तैयार किया जा रहा है…';

  @override
  String get jpgSavedInfoMessage => 'JPG सहेजा गया';

  @override
  String get jpgFailedInfoMessage => 'JPG नहीं बनाया जा सका';

  @override
  String get txtPreparingInfoMessage => 'TXT तैयार किया जा रहा है…';

  @override
  String get txtSavedInfoMessage => 'TXT सहेजा गया';

  @override
  String get txtFailedInfoMessage => 'TXT नहीं बनाया जा सका';

  @override
  String get exportOpenActionLabel => 'खोलें';

  @override
  String get wrongPasswordInfoMessage => 'गलत पासवर्ड।';

  @override
  String get noteArchivedInfoMessage => 'नोट संग्रहीत किया गया';

  @override
  String get noteUnarchivedInfoMessage => 'संग्रह से हटाया गया';

  @override
  String get noteUnlockedInfoMessage => 'अनलॉक किया गया';

  @override
  String get noteLockedInfoMessage => 'नोट लॉक किया गया';

  @override
  String get notificationUnpinnedInfoMessage => 'अनपिन किया गया';

  @override
  String get emptyNotePinBlockedInfoMessage =>
      'एक खाली नोट को पिन नहीं किया जा सकता।';

  @override
  String get notificationPinnedInfoMessage => 'सूचना पैनल में पिन किया गया';

  @override
  String get noContentToReadInfoMessage => 'पढ़ने के लिए कोई सामग्री नहीं है';

  @override
  String get backPressExitInfoMessage => 'बाहर निकलने के लिए फिर से बैक दबाएं';

  @override
  String get reminderChannelName => 'नोट रिमाइंडर';

  @override
  String get reminderChannelDescription => 'Layout ऐप में नोट रिमाइंडर';

  @override
  String get pinnedChannelName => 'पिन किए गए नोट्स';

  @override
  String get pinnedChannelDescription =>
      'सूचना पैनल में पिन किए गए Layout नोट्स';

  @override
  String get notificationUnpinActionLabel => 'हटाएं';

  @override
  String get reminderDefaultTitle => 'रिमाइंडर';

  @override
  String get reminderChecklistBodyFallback => 'अपनी चेकलिस्ट जांचना न भूलें';

  @override
  String get reminderTextBodyFallback => 'अपना नोट जांचना न भूलें';

  @override
  String get pdfSaveDialogTitle => 'PDF के रूप में सहेजें';

  @override
  String get jpgSaveDialogTitle => 'JPG के रूप में सहेजें';

  @override
  String get txtSaveDialogTitle => 'TXT के रूप में सहेजें';

  @override
  String get textSizeSheetTitle => 'टेक्स्ट आकार';

  @override
  String get textSizeSamplePreview => 'नमूना टेक्स्ट';

  @override
  String get textSizeCancelButton => 'रद्द करें';

  @override
  String get textSizeApplyButton => 'लागू करें';

  @override
  String get createPasswordDialogTitle => 'पासवर्ड बनाएं';

  @override
  String get createPasswordNewPasswordHint => 'नया पासवर्ड';

  @override
  String get createPasswordConfirmHint => 'पासवर्ड फिर से दर्ज करें';

  @override
  String get createPasswordHintQuestionDescription =>
      'यदि आप अपना पासवर्ड भूल जाएं, तो एक सुरक्षा प्रश्न सेट करें (वैकल्पिक)।';

  @override
  String get createPasswordHintQuestionHint => 'एक सुरक्षा प्रश्न चुनें';

  @override
  String get createPasswordHintAnswerHint => 'आपका उत्तर';

  @override
  String get createPasswordCancelButton => 'रद्द करें';

  @override
  String get createPasswordSaveButton => 'सहेजें';

  @override
  String get passwordMismatchMessage => 'पासवर्ड मेल नहीं खाते!';

  @override
  String get passwordRequiredDialogTitle => 'पासवर्ड आवश्यक है';

  @override
  String get passwordRequiredHint => 'पासवर्ड दर्ज करें';

  @override
  String get forgotPasswordButtonLabel => 'मैं अपना पासवर्ड भूल गया';

  @override
  String get passwordRequiredCancelButton => 'रद्द करें';

  @override
  String get passwordRequiredConfirmButton => 'सत्यापित करें';

  @override
  String get securityQuestionDialogTitle => 'सुरक्षा प्रश्न';

  @override
  String get securityQuestionAnswerHint => 'आपका उत्तर';

  @override
  String get securityQuestionCancelButton => 'रद्द करें';

  @override
  String get securityQuestionConfirmButton => 'पुष्टि करें';

  @override
  String get securityQuestionWrongAnswerMessage =>
      'गलत उत्तर। फिर से प्रयास करें।';

  @override
  String get revealedPasswordDialogTitle => 'आपका पासवर्ड';

  @override
  String get revealedPasswordLabel => 'आपका नोट पासवर्ड:';

  @override
  String get revealedPasswordOkButton => 'ठीक है';

  @override
  String get securityQuestionPetName => 'आपके पहले पालतू जानवर का नाम क्या है?';

  @override
  String get securityQuestionFavoriteTeacher =>
      'आपके पसंदीदा शिक्षक का नाम क्या है?';

  @override
  String get securityQuestionBirthCity => 'आपका जन्म किस शहर में हुआ था?';

  @override
  String get securityQuestionFavoriteFood => 'आपका पसंदीदा भोजन क्या है?';

  @override
  String get securityQuestionMotherMaidenName =>
      'आपकी माँ का मायके का नाम क्या है?';

  @override
  String get securityQuestionFirstSchool =>
      'आपने जिस पहले स्कूल में पढ़ाई की, उसका नाम क्या है?';

  @override
  String get securityQuestionFavoriteColor => 'आपका पसंदीदा रंग क्या है?';

  @override
  String get editFolderDialogTitle => 'फ़ोल्डर संपादित करें';

  @override
  String get newSubfolderDialogTitle => 'नया सबफ़ोल्डर';

  @override
  String get addFolderDialogTitle => 'फ़ोल्डर जोड़ें';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return '\"$parentCategory\" के अंदर बनाया जाएगा';
  }

  @override
  String get subfolderNameFieldLabel => 'सबफ़ोल्डर नाम';

  @override
  String get folderNameFieldLabel => 'फ़ोल्डर नाम';

  @override
  String get folderColorLabel => 'रंग';

  @override
  String get folderDialogCancelButton => 'रद्द करें';

  @override
  String get folderDialogSaveButton => 'सहेजें';

  @override
  String get folderDialogAddButton => 'जोड़ें';

  @override
  String get selectFolderSheetTitle => 'फ़ोल्डर चुनें';

  @override
  String get selectFolderAddOptionLabel => 'फ़ोल्डर जोड़ें';

  @override
  String get removeCurrentFolderLabel => 'वर्तमान फ़ोल्डर हटाएं';

  @override
  String get noteDetailsDialogTitle => 'विवरण';

  @override
  String get noteDetailsCreatedLabel => 'बनाया गया';

  @override
  String get noteDetailsModifiedLabel => 'अंतिम संशोधन';

  @override
  String get noteDetailsCharCountLabel => 'वर्ण संख्या';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count वर्ण';
  }

  @override
  String get noteDetailsWordCountLabel => 'शब्द संख्या';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count शब्द';
  }

  @override
  String get noteDetailsOkButton => 'ठीक है';

  @override
  String get noteDetailsUnknownDateLabel => 'अज्ञात';

  @override
  String get addAttachmentSheetTitle => 'जोड़ें';

  @override
  String get addAttachmentImageOption => 'छवि जोड़ें';

  @override
  String get addAttachmentCameraOption => 'कैमरा';

  @override
  String get addAttachmentFileOption => 'फ़ाइल जोड़ें';

  @override
  String get addAttachmentVoiceOption => 'वॉइस रिकॉर्डिंग';

  @override
  String get addAttachmentVideoOption => 'वीडियो रिकॉर्ड करें';

  @override
  String get addAttachmentScanOption => 'दस्तावेज़ स्कैन करें';

  @override
  String get noteActionsSheetTitle => 'कार्रवाई चुनें';

  @override
  String get noteActionReminderLabel => 'रिमाइंडर';

  @override
  String get noteActionEditReminderLabel => 'रिमाइंडर संपादित करें';

  @override
  String get noteActionSpeechToTextLabel => 'स्पीच टू टेक्स्ट';

  @override
  String get noteActionArchiveLabel => 'संग्रह करें';

  @override
  String get noteActionUnarchiveLabel => 'संग्रह से हटाएं';

  @override
  String get noteActionLockLabel => 'लॉक करें';

  @override
  String get noteActionUnlockLabel => 'अनलॉक करें';

  @override
  String get noteActionFavoriteLabel => 'पसंदीदा';

  @override
  String get noteActionUnfavoriteLabel => 'पसंदीदा से हटाएं';

  @override
  String get noteActionClassifyLabel => 'फ़ोल्डर चुनें';

  @override
  String get noteActionDeleteLabel => 'हटाएं';

  @override
  String get noteActionPinToNotificationLabel => 'सूचना पैनल में पिन करें';

  @override
  String get noteActionUnpinFromNotificationLabel => 'पिन हटाएं';

  @override
  String get noteActionShareLabel => 'साझा करें';

  @override
  String get noteActionDuplicateLabel => 'कॉपी बनाएं';

  @override
  String get noteActionCopyContentLabel => 'सामग्री कॉपी करें';

  @override
  String get noteActionTtsLabel => 'जोर से पढ़ें';

  @override
  String get noteActionTextSizeLabel => 'टेक्स्ट आकार';

  @override
  String get noteActionDetailsLabel => 'विवरण';

  @override
  String get noteActionDiscardChangesLabel => 'परिवर्तन छोड़ें';

  @override
  String get noteActionSelectLabel => 'चुनें';

  @override
  String get reminderEditOptionLabel => 'रिमाइंडर बदलें';

  @override
  String get reminderRemoveOptionLabel => 'रिमाइंडर हटाएं';

  @override
  String get discardChangesDialogTitle => 'परिवर्तन छोड़ें';

  @override
  String get discardChangesDialogMessage =>
      'इस नोट में सहेजे न गए परिवर्तन खो जाएंगे। क्या आप वाकई उन्हें छोड़ना चाहते हैं?';

  @override
  String get discardChangesCancelButton => 'रद्द करें';

  @override
  String get discardChangesConfirmButton => 'छोड़ें';

  @override
  String get pinnedNotificationDefaultTitle => 'नोट';

  @override
  String get pdfFailedInfoMessage => 'PDF बनाने में विफल';

  @override
  String get drawingScreenTitle => 'ड्राइंग';

  @override
  String get drawingMinimizeTooltip => 'छोटा करें';

  @override
  String get drawingEmptyExportWarningMessage => 'पहले कुछ बनाएं';

  @override
  String get drawingEraserPartialModeLabel => 'आंशिक';

  @override
  String get drawingEraserFullModeLabel => 'पूर्ण';

  @override
  String get drawingClearTooltip => 'साफ़ करें';

  @override
  String get drawingZoomOutTooltip => 'ज़ूम आउट';

  @override
  String get drawingZoomInTooltip => 'ज़ूम इन';

  @override
  String get drawingDeleteTooltip => 'हटाएं';

  @override
  String get drawingEmptyPreviewHint => 'बनाने के लिए टैप करें';

  @override
  String get settingsPageTitle => 'सेटिंग्स';

  @override
  String get settingsSectionGeneral => 'सामान्य';

  @override
  String get settingsSectionSecurity => 'सुरक्षा';

  @override
  String get settingsSectionTheme => 'थीम';

  @override
  String get settingsSectionPersonalization => 'वैयक्तिकरण';

  @override
  String get settingsSectionWidget => 'विजेट';

  @override
  String get settingsSectionAbout => 'के बारे में';

  @override
  String get settingsHintQuestionPet => 'आपके पहले पालतू जानवर का नाम क्या है?';

  @override
  String get settingsHintQuestionTeacher =>
      'आपके पसंदीदा शिक्षक का नाम क्या है?';

  @override
  String get settingsHintQuestionBirthCity => 'आपका जन्म किस शहर में हुआ था?';

  @override
  String get settingsHintQuestionFavoriteFood => 'आपका पसंदीदा भोजन क्या है?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'आपकी माँ का मायके का नाम क्या है?';

  @override
  String get settingsHintQuestionFirstSchool =>
      'आपने पहले किस स्कूल में पढ़ाई की थी?';

  @override
  String get settingsHintQuestionFavoriteColor => 'आपका पसंदीदा रंग क्या है?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'सुरक्षा प्रश्न';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'यदि आप अपना पासवर्ड भूल जाते हैं, तो आप इस प्रश्न का सही उत्तर देकर उसे पुनर्प्राप्त कर सकते हैं।';

  @override
  String get settingsSecurityQuestionDropdownHint => 'एक सुरक्षा प्रश्न चुनें';

  @override
  String get settingsSecurityQuestionAnswerHint => 'आपका उत्तर';

  @override
  String get settingsSecurityQuestionCancelButton => 'रद्द करें';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'प्रश्न और उत्तर खाली नहीं हो सकते!';

  @override
  String get settingsSecurityQuestionSaveButton => 'सहेजें';

  @override
  String get settingsCreatePasswordTitle => 'पासवर्ड बनाएं';

  @override
  String get settingsPasswordRequiredTitle => 'पासवर्ड आवश्यक है';

  @override
  String get settingsPasswordEnterHint => 'पासवर्ड दर्ज करें';

  @override
  String get settingsForgotPasswordButton => 'मैं अपना पासवर्ड भूल गया';

  @override
  String get settingsNewPasswordHint => 'नया पासवर्ड';

  @override
  String get settingsConfirmPasswordHint => 'पासवर्ड फिर से दर्ज करें';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'यदि आप अपना पासवर्ड भूल जाएं, तो एक सुरक्षा प्रश्न सेट करें (वैकल्पिक)।';

  @override
  String get settingsPasswordDialogCancelButton => 'रद्द करें';

  @override
  String get settingsPasswordMismatchWarning => 'पासवर्ड मेल नहीं खाते!';

  @override
  String get settingsWrongPasswordWarning => 'गलत पासवर्ड!';

  @override
  String get settingsPasswordSaveButton => 'सहेजें';

  @override
  String get settingsPasswordRemoveButton => 'हटाएं';

  @override
  String get settingsNotePasswordTitle => 'नोट पासवर्ड';

  @override
  String get settingsPasswordSetSubtitle => 'पासवर्ड सेट है ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'पासवर्ड सेट नहीं है';

  @override
  String get settingsSecurityQuestionTileTitle => 'सुरक्षा प्रश्न';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'सेट है ✓ — पासवर्ड भूलने पर उपयोग होता है';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'सेट नहीं है — खो जाने पर आप अपना पासवर्ड पुनर्प्राप्त नहीं कर पाएंगे';

  @override
  String get settingsThemeDialogTitle => 'थीम चुनें';

  @override
  String get settingsThemeSystemDefault => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get settingsThemeLightOption => 'लाइट थीम';

  @override
  String get settingsThemeDarkOption => 'डार्क थीम';

  @override
  String get settingsLanguageDialogTitle => 'भाषा चुनें';

  @override
  String get settingsLanguageSystemOption => 'सिस्टम';

  @override
  String get settingsAccentColorDialogTitle => 'एक्सेंट रंग चुनें';

  @override
  String get settingsThemeChangeTileTitle => 'थीम बदलें';

  @override
  String get settingsThemeLightLabel => 'लाइट';

  @override
  String get settingsThemeDarkLabel => 'डार्क';

  @override
  String get settingsThemeSystemLabel => 'सिस्टम';

  @override
  String get settingsLanguageTileTitle => 'भाषा';

  @override
  String get settingsAccentColorTileTitle => 'एक्सेंट रंग';

  @override
  String get settingsAccentColorTileSubtitle =>
      'ऐप बार, बटन और स्विच में उपयोग होने वाला रंग';

  @override
  String get settingsColorfulNotesTitle => 'विविध नोट रंग';

  @override
  String get settingsColorfulNotesSubtitle =>
      'प्रत्येक नोट कार्ड को एक अलग रंग टोन मिलता है।';

  @override
  String get settingsTextColorSheetTitle => 'टेक्स्ट रंग';

  @override
  String get settingsTextColorSheetDesc =>
      'नोट सामग्री टेक्स्ट का रंग सेट करता है।';

  @override
  String get settingsTextColorOkButton => 'ठीक है';

  @override
  String get settingsTextColorTileTitle => 'टेक्स्ट रंग';

  @override
  String get settingsTextColorTileSubtitle => 'नोट सामग्री टेक्स्ट के लिए रंग।';

  @override
  String get settingsWidgetFontSizeLabel => 'विजेट फ़ॉन्ट आकार';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'नमूना शीर्षक - $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'रद्द करें';

  @override
  String get settingsWidgetFontSizeApplyButton => 'लागू करें';

  @override
  String get settingsWidgetOpacityLabel => 'पृष्ठभूमि पारदर्शिता';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return '$percent% पारदर्शिता';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'रद्द करें';

  @override
  String get settingsWidgetOpacityApplyButton => 'लागू करें';

  @override
  String get settingsWidgetDarkModeTitle => 'डार्क विजेट';

  @override
  String get settingsWidgetDarkModeDesc => 'विजेट के लिए डार्क रंग योजना।';

  @override
  String get settingsAboutVersionTitle => 'ऐप संस्करण';

  @override
  String get settingsAboutVersionLoading => 'संस्करण लोड हो रहा है…';

  @override
  String get aboutSectionDeveloper => 'फ़ीडबैक';

  @override
  String get aboutDeveloperTitle => 'डेवलपर';

  @override
  String get aboutContactTitle => 'संपर्क करें';

  @override
  String get aboutWebsiteTitle => 'वेबसाइट';

  @override
  String get aboutGithubTitle => 'GitHub';

  @override
  String get aboutSectionLegal => 'कानूनी';

  @override
  String get aboutPrivacyPolicyTitle => 'गोपनीयता नीति';

  @override
  String get aboutTermsTitle => 'उपयोग की शर्तें';

  @override
  String get aboutLicensesTitle => 'ओपन सोर्स लाइसेंस';

  @override
  String get aboutSectionSupport => 'रेटिंग';

  @override
  String get aboutRateAppTitle => 'ऐप को रेट करें';

  @override
  String get aboutLinkOpenError => 'लिंक नहीं खोला जा सका.';

  @override
  String get settingsFontFamilyTileTitle => 'फ़ॉन्ट';

  @override
  String get settingsFontFamilyDefaultLabel => 'डिफ़ॉल्ट';

  @override
  String get settingsGlobalFontSizeTileTitle => 'फ़ॉन्ट आकार';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt — सभी नोट्स पर लागू।';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'नमूना टेक्स्ट - $size pt';
  }

  @override
  String get settingsGlobalFontSizeCancelButton => 'रद्द करें';

  @override
  String get settingsGlobalFontSizeApplyButton => 'लागू करें';

  @override
  String get settingsPreviewLinesTileTitle => 'नोट पूर्वावलोकन पंक्तियाँ';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return '$lines पंक्तियों तक दिखाएं। यदि नोट छोटा है, तो वास्तविक पंक्तियों की संख्या दिखाई जाती है।';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'वर्तमान: $lines पंक्तियाँ';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'पूर्वावलोकन के लिए अधिकतम पंक्तियों की संख्या सेट करता है। यदि नोट में कम पंक्तियाँ हैं, तो वास्तविक संख्या दिखाई जाती है।';

  @override
  String get settingsPreviewLinesCancelButton => 'रद्द करें';

  @override
  String get settingsPreviewLinesApplyButton => 'लागू करें';

  @override
  String get backupCancelButton => 'रद्द करें';

  @override
  String get backupConnectButton => 'कनेक्ट करें';

  @override
  String get backupDisconnectButton => 'डिस्कनेक्ट करें';

  @override
  String get backupContinueButton => 'जारी रखें';

  @override
  String get backupCloseButton => 'बंद करें';

  @override
  String get backupShareButton => 'साझा करें';

  @override
  String get backupRestoreButton => 'पुनर्स्थापित करें';

  @override
  String get backupConfigureButton => 'कॉन्फ़िगर करें';

  @override
  String get backupUnknownDateLabel => 'अज्ञात';

  @override
  String get backupProcessingDefaultLabel => 'प्रोसेसिंग हो रही है...';

  @override
  String get backupPermissionRequiredTitle => 'संग्रहण अनुमति आवश्यक है';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'इस Android संस्करण में बैकअप/पुनर्स्थापना के लिए संग्रहण अनुमति आवश्यक है। चूंकि अनुमति स्थायी रूप से अस्वीकृत कर दी गई थी, कृपया इसे ऐप सेटिंग्स से मैन्युअल रूप से सक्षम करें।';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'इस Android संस्करण में बैकअप/पुनर्स्थापना के लिए संग्रहण अनुमति आवश्यक है। जारी रखने के लिए कृपया अनुमति दें।';

  @override
  String get backupGoToSettingsButton => 'सेटिंग्स पर जाएं';

  @override
  String get backupRetryButton => 'फिर से प्रयास करें';

  @override
  String get backupDriveConnectingLabel => 'Google खाते से कनेक्ट हो रहा है...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Google Drive खाते से कनेक्ट हुआ: $email';
  }

  @override
  String get backupDriveConnectedMessage => 'Google Drive खाते से कनेक्ट हुआ।';

  @override
  String get backupDriveConnectFailedMessage =>
      'Google खाते से कनेक्ट नहीं हो सका, या ऑपरेशन रद्द कर दिया गया था।';

  @override
  String get backupDriveDisconnectTitle => 'Google Drive डिस्कनेक्ट करें';

  @override
  String get backupDriveDisconnectBody =>
      'यदि आप डिस्कनेक्ट करते हैं, तो Drive पर मैन्युअल या स्वचालित बैकअप संभव नहीं होंगे। Drive पर पहले से संग्रहीत बैकअप हटाए नहीं जाएंगे — केवल इस डिवाइस से पहुंच हटाई जाएगी।';

  @override
  String get backupDriveDisconnectedMessage =>
      'Google Drive कनेक्शन हटाया गया।';

  @override
  String get backupDriveRequiredTitle => 'Google खाता आवश्यक है';

  @override
  String get backupDriveRequiredBody =>
      'इस कार्रवाई के लिए आपको अपना Google खाता कनेक्ट करना आवश्यक है। क्या आप अभी कनेक्ट करना चाहेंगे?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: कनेक्टेड ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: कनेक्टेड';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: कनेक्टेड नहीं';

  @override
  String get backupDriveAuthenticatingLabel =>
      'Google खाता सत्यापित हो रहा है...';

  @override
  String get backupDriveNotSignedInMessage =>
      'आप Google Drive से कनेक्टेड नहीं हैं। कृपया पहले अपने Google खाते से साइन इन करें।';

  @override
  String get backupDriveUploadingLabel => 'Drive पर बैकअप अपलोड हो रहा है...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Google Drive पर अपलोड 120 सेकंड के भीतर पूरा नहीं हुआ (सर्वर से कोई प्रतिक्रिया नहीं)। कृपया अपना कनेक्शन जांचें और फिर से प्रयास करें।';

  @override
  String get backupDriveOperationCompletedLabel => 'पूर्ण हुआ';

  @override
  String get backupToDriveActionLabel => 'Drive पर बैकअप';

  @override
  String get backupToDeviceActionLabel => 'बैकअप';

  @override
  String get backupCreatingLabel => 'बैकअप बनाया जा रहा है...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'बैकअप नहीं बनाया जा सका: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Google Drive पर अपलोड विफल: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'बैकअप सफलतापूर्वक Google Drive पर अपलोड किया गया।';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'बैकअप बनाया गया: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'बैकअप तैयार है';

  @override
  String get backupOfferShareBody =>
      'आपकी बैकअप फ़ाइल आपके डिवाइस में सहेज दी गई है। क्या आप इसे अभी साझा करना चाहेंगे (जैसे क्लाउड स्टोरेज, ईमेल, कोई अन्य डिवाइस)?';

  @override
  String get backupShareFileText => 'layout बैकअप फ़ाइल';

  @override
  String backupShareFailedMessage(String error) {
    return 'साझा करना शुरू नहीं किया जा सका: $error';
  }

  @override
  String get backupLargeOperationTitle => 'बड़ा बैकअप';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'प्रोसेस किया जाने वाला डेटा लगभग $sizeText है। इस आकार का $actionLabel आपके डिवाइस के आधार पर कुछ समय ले सकता है। बस प्रगति के दौरान ऐप न छोड़ें — क्या आप जारी रखना चाहेंगे?';
  }

  @override
  String get backupRestoreActionLabel => 'पुनर्स्थापना';

  @override
  String get backupDriveListingLabel => 'Drive बैकअप सूचीबद्ध हो रहे हैं...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'बैकअप सूचीबद्ध नहीं किए जा सके: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'Google Drive पर अभी तक कोई बैकअप नहीं है।';

  @override
  String get backupDrivePickTitle => 'Drive से एक बैकअप चुनें';

  @override
  String get backupDriveDownloadingLabel =>
      'Drive से बैकअप डाउनलोड हो रहा है...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Drive से बैकअप डाउनलोड हो रहा है... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel =>
      'फ़ाइल डिवाइस पर सहेजी जा रही है...';

  @override
  String get backupDriveUnknownBackupFileName => 'अज्ञात_बैकअप.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'आपका Google Drive स्टोरेज भर गया है। कृपया Drive पर जगह खाली करें और फिर से प्रयास करें।';

  @override
  String get backupDriveNetworkErrorMessage =>
      'इंटरनेट कनेक्शन स्थापित नहीं हो सका। कृपया अपना कनेक्शन जांचें और फिर से प्रयास करें।';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'निर्दिष्ट बैकअप फ़ाइल Drive पर नहीं मिली। इसे हटाया जा चुका हो सकता है।';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Google Drive कार्रवाई के दौरान एक अप्रत्याशित त्रुटि हुई: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'डाउनलोड विफल: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'फ़ाइल चुनी नहीं जा सकी: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'चुनी गई फ़ाइल तक पहुंचा नहीं जा सका।';

  @override
  String get backupCheckingLabel => 'बैकअप जांचा जा रहा है...';

  @override
  String backupReadFailedMessage(String error) {
    return 'बैकअप फ़ाइल पढ़ी नहीं जा सकी: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'बैकअप पुनर्स्थापित करें';

  @override
  String get backupPreviewContentsHeader => 'चुने गए बैकअप की सामग्री:';

  @override
  String get backupPreviewNoteCountLabel => 'नोट्स की संख्या';

  @override
  String get backupPreviewTrashCountLabel => 'ट्रैश में नोट्स';

  @override
  String get backupPreviewCategoryCountLabel => 'फ़ोल्डरों की संख्या';

  @override
  String get backupPreviewAttachmentLabel => 'अटैचमेंट';

  @override
  String get backupPreviewAttachmentNoneValue => 'कोई नहीं';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count फ़ाइलें ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'बनाया गया';

  @override
  String get backupEmptyPreviewTitle => 'यह बैकअप खाली दिखता है';

  @override
  String get backupEmptyPreviewBody =>
      'चुनी गई फ़ाइल में कोई नोट्स, फ़ोल्डर या अटैचमेंट नहीं मिले। यदि आप जारी रखते हैं, तो आपका मौजूदा डेटा फिर भी हटा दिया जाएगा और इस खाली बैकअप से बदल दिया जाएगा।';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return 'बैकअप में $count अटैचमेंट नहीं मिले';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'इन फ़ाइलों वाले नोट्स पुनर्स्थापित किए जाएंगे, लेकिन अटैचमेंट के बिना (बैकअप लेते समय वे गुम या करप्ट हो सकते थे): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown और $remaining और';
  }

  @override
  String get backupRestoreConfirmBody =>
      'यह आपके सभी मौजूदा नोट्स, ट्रैश, फ़ोल्डर, सेटिंग्स और अटैचमेंट को ऊपर दिए गए बैकअप के डेटा से बदल देगा। आपका मौजूदा डेटा स्थायी रूप से खो जाएगा और यह कार्रवाई पूर्ववत नहीं की जा सकती।';

  @override
  String get backupRestoringLabel => 'बैकअप पुनर्स्थापित किया जा रहा है...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'बैकअप पुनर्स्थापित किया गया। हालांकि, $count अटैचमेंट बैकअप में नहीं मिले और पुनर्स्थापित नहीं किए जा सके। परिवर्तनों को पूरी तरह लागू करने के लिए ऐप को पुनः आरंभ करने की सलाह दी जाती है।';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'बैकअप सफलतापूर्वक पुनर्स्थापित किया गया। परिवर्तनों को पूरी तरह लागू करने के लिए ऐप को पुनः आरंभ करने की सलाह दी जाती है।';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'पुनर्स्थापित करते समय एक त्रुटि हुई: $error';
  }

  @override
  String get backupScreenTitle => 'बैकअप और पुनर्स्थापना';

  @override
  String get backupBlockedExitWarningMessage =>
      'एक कार्रवाई जारी है, कृपया इसके समाप्त होने की प्रतीक्षा करें।';

  @override
  String get backupBusyBackTooltip => 'कार्रवाई जारी है';

  @override
  String get backupIntroText =>
      'आप अपने नोट्स, फ़ोल्डर, सेटिंग्स और अटैचमेंट को एक ही .zip फ़ाइल के रूप में बैकअप कर सकते हैं, या पहले लिया गया बैकअप पुनर्स्थापित कर सकते हैं।';

  @override
  String get backupDriveCardTitle => 'Google Drive पर बैकअप लें';

  @override
  String get backupDriveCardSubtitle =>
      'एक नया बैकअप बनाएं और इसे सीधे अपने Google Drive के निजी क्षेत्र में अपलोड करें।';

  @override
  String get backupDriveCardButtonLabel => 'Drive पर बैकअप लें';

  @override
  String get backupDeviceCardTitle => 'डिवाइस पर बैकअप लें';

  @override
  String get backupDeviceCardSubtitle =>
      'अपने सभी डेटा को एक .zip फ़ाइल के रूप में अपने डिवाइस पर सहेजें और चाहें तो इसे साझा करें।';

  @override
  String get backupDeviceCardButtonLabel => 'डिवाइस पर बैकअप लें';

  @override
  String get backupHistoryCardTitle => 'बैकअप इतिहास';

  @override
  String get backupHistoryCardSubtitle =>
      'अपने डिवाइस पर संग्रहीत सभी बैकअप को उनकी तारीख और आकार के साथ देखें; आप उन्हें यहीं से सीधे साझा, पुनर्स्थापित या हटा सकते हैं।';

  @override
  String get backupHistoryTabDevice => 'डिवाइस';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'बैकअप हटाएं';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'क्या आप वाकई बैकअप फ़ाइल \"$fileName\" को स्थायी रूप से हटाना चाहते हैं? यह कार्रवाई पूर्ववत नहीं की जा सकती।';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'बैकअप हटाया गया।';

  @override
  String get backupHistoryDriveDeleteDialogTitle => 'Drive बैकअप हटाएं';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'क्या आप वाकई Google Drive से बैकअप \"$fileName\" को स्थायी रूप से हटाना चाहते हैं? यह कार्रवाई पूर्ववत नहीं की जा सकती और फ़ाइल ट्रैश में नहीं जाएगी।';
  }

  @override
  String get backupHistoryDriveDeletedMessage => 'Drive बैकअप हटाया गया।';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'हटाया नहीं जा सका: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'इस डिवाइस पर अभी तक कोई बैकअप सहेजा नहीं गया है।';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'अपना पहला बैकअप बनाने के लिए \"डिवाइस पर बैकअप लें\" का उपयोग करें।';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'अपना पहला क्लाउड बैकअप बनाने के लिए \"Google Drive पर बैकअप लें\" का उपयोग करें।';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'अपने Drive बैकअप देखने के लिए अपना Google खाता कनेक्ट करें।';

  @override
  String get backupHistoryConnectGoogleButton => 'Google से कनेक्ट करें';

  @override
  String get backupHistoryDriveConnectedFallback => 'कनेक्टेड';

  @override
  String get backupHistoryUnknownErrorFallback => 'एक अज्ञात त्रुटि हुई।';

  @override
  String get backupHistoryDownloadStartingLabel => 'शुरू हो रहा है...';

  @override
  String get backupAutoBackupEnabledLabel => 'स्वचालित बैकअप: चालू';

  @override
  String get backupAutoBackupDisabledLabel => 'स्वचालित बैकअप: बंद';

  @override
  String get backupOverlayWarningMessage =>
      'कृपया प्रतीक्षा करें, कार्रवाई पूरी होने तक ऐप न छोड़ें।';

  @override
  String get pdfExportUntitledNoteLabel => 'शीर्षक रहित नोट';

  @override
  String get pdfExportDefaultAttachmentName => 'अटैचमेंट';

  @override
  String get pdfExportDefaultFileName => 'नोट';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'स्क्रीनशॉट कैप्चर नहीं किया जा सका (बाउंड्री नहीं मिली)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'स्क्रीनशॉट डेटा जनरेट नहीं किया जा सका';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'छवि प्रोसेस नहीं की जा सकी (PNG डिकोड विफल)';

  @override
  String get screenshotCalcTableTotalLabel => 'कुल';

  @override
  String get gundemMenuRemoveFromAgenda => 'एजेंडा से हटाएं';

  @override
  String get gundemMenuDeleteNote => 'नोट हटाएं';

  @override
  String get gundemSectionOverdue => 'समय सीमा बीत चुकी';

  @override
  String get gundemSectionToday => 'आज';

  @override
  String get gundemSectionTomorrow => 'कल';

  @override
  String get gundemSectionNextWeek => 'अगले सप्ताह';

  @override
  String get gundemSectionFurther => 'और आगे';

  @override
  String get gundemWeekdayMonday => 'सोमवार';

  @override
  String get gundemWeekdayTuesday => 'मंगलवार';

  @override
  String get gundemWeekdayWednesday => 'बुधवार';

  @override
  String get gundemWeekdayThursday => 'गुरुवार';

  @override
  String get gundemWeekdayFriday => 'शुक्रवार';

  @override
  String get gundemWeekdaySaturday => 'शनिवार';

  @override
  String get gundemWeekdaySunday => 'रविवार';

  @override
  String get gundemAppBarTitle => 'एजेंडा';

  @override
  String get gundemCalendarTooltip => 'कैलेंडर';

  @override
  String get gundemEmptyTitle => 'आपके एजेंडे में कुछ नहीं है';

  @override
  String get gundemEmptySubtitle =>
      'रिमाइंडर या असाइन की गई तारीख वाले नोट्स यहां दिखाई देंगे।';

  @override
  String get gundemUntitledNote => 'शीर्षक रहित नोट';

  @override
  String get gundemRepeatHourly => 'प्रति घंटा';

  @override
  String get gundemRepeatDaily => 'प्रतिदिन';

  @override
  String get gundemRepeatWeekly => 'साप्ताहिक';

  @override
  String get gundemRepeatMonthly => 'मासिक';

  @override
  String get gundemRepeatYearly => 'वार्षिक';

  @override
  String get gundemPreviewCalcTableLabel => '[कैलकुलेशन सूची]';

  @override
  String get gundemPreviewDrawingLabel => '[ड्राइंग]';

  @override
  String get gundemPreviewImageLabel => '[छवि]';

  @override
  String get gundemMonthShortJan => 'जन';

  @override
  String get gundemMonthShortFeb => 'फ़र';

  @override
  String get gundemMonthShortMar => 'मार्च';

  @override
  String get gundemMonthShortApr => 'अप्रैल';

  @override
  String get gundemMonthShortMay => 'मई';

  @override
  String get gundemMonthShortJun => 'जून';

  @override
  String get gundemMonthShortJul => 'जुल';

  @override
  String get gundemMonthShortAug => 'अग';

  @override
  String get gundemMonthShortSep => 'सित';

  @override
  String get gundemMonthShortOct => 'अक्तू';

  @override
  String get gundemMonthShortNov => 'नव';

  @override
  String get gundemMonthShortDec => 'दिस';

  @override
  String get calendarAppBarTitle => 'कैलेंडर';

  @override
  String get calendarTodayButton => 'आज';

  @override
  String get calendarLegendNoteLabel => 'नोट';

  @override
  String get calendarLegendReminderLabel => 'रिमाइंडर';

  @override
  String get calendarTodayBadge => 'आज';

  @override
  String get calendarEmptyDayMessage =>
      'इस दिन के लिए कोई नोट्स या रिमाइंडर नहीं हैं।';

  @override
  String get calendarReminderHourlyLabel => 'प्रति घंटा';

  @override
  String get calendarMonthJan => 'जनवरी';

  @override
  String get calendarMonthFeb => 'फ़रवरी';

  @override
  String get calendarMonthMar => 'मार्च';

  @override
  String get calendarMonthApr => 'अप्रैल';

  @override
  String get calendarMonthMay => 'मई';

  @override
  String get calendarMonthJun => 'जून';

  @override
  String get calendarMonthJul => 'जुलाई';

  @override
  String get calendarMonthAug => 'अगस्त';

  @override
  String get calendarMonthSep => 'सितंबर';

  @override
  String get calendarMonthOct => 'अक्तूबर';

  @override
  String get calendarMonthNov => 'नवंबर';

  @override
  String get calendarMonthDec => 'दिसंबर';

  @override
  String get calendarWeekdayShortMon => 'सोम';

  @override
  String get calendarWeekdayShortTue => 'मंगल';

  @override
  String get calendarWeekdayShortWed => 'बुध';

  @override
  String get calendarWeekdayShortThu => 'गुरु';

  @override
  String get calendarWeekdayShortFri => 'शुक्र';

  @override
  String get calendarWeekdayShortSat => 'शनि';

  @override
  String get calendarWeekdayShortSun => 'रवि';

  @override
  String get calendarWeekdayFullMonday => 'सोमवार';

  @override
  String get calendarWeekdayFullTuesday => 'मंगलवार';

  @override
  String get calendarWeekdayFullWednesday => 'बुधवार';

  @override
  String get calendarWeekdayFullThursday => 'गुरुवार';

  @override
  String get calendarWeekdayFullFriday => 'शुक्रवार';

  @override
  String get calendarWeekdayFullSaturday => 'शनिवार';

  @override
  String get calendarWeekdayFullSunday => 'रविवार';

  @override
  String get wrongPasswordDialogTitle => 'गलत पासवर्ड';

  @override
  String get wrongPasswordDialogMessage =>
      'आपके द्वारा दर्ज किया गया पासवर्ड गलत है।';

  @override
  String get commonOkButton => 'ठीक है';

  @override
  String get unlockCategoryAction => 'अनलॉक करें';

  @override
  String get lockCategoryAction => 'लॉक करें';

  @override
  String get categoryUnlockedMessage => 'अनलॉक किया गया';

  @override
  String get categoryLockedMessage => 'फ़ोल्डर लॉक किया गया';

  @override
  String get deleteFolderMenuItemLabel => 'फ़ोल्डर हटाएं';

  @override
  String get deleteFolderDialogTitle => 'फ़ोल्डर हटाएं';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'क्या आप वाकई फ़ोल्डर \"$category\" और इसके सभी सबफ़ोल्डर हटाना चाहते हैं? इन फ़ोल्डरों के नोट्स अवर्गीकृत हो जाएंगे।';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'क्या आप वाकई फ़ोल्डर \"$category\" हटाना चाहते हैं? इस फ़ोल्डर के नोट्स अवर्गीकृत हो जाएंगे।';
  }

  @override
  String get deleteFolderDialogCancelButton => 'रद्द करें';

  @override
  String get deleteFolderDialogConfirmButton => 'हटाएं';

  @override
  String get editCategoryNameColorMenuItemLabel => 'नाम / रंग संपादित करें';

  @override
  String get addSubfolderMenuItemLabel => 'सबफ़ोल्डर बनाएं';

  @override
  String get expandSubfoldersMenuItemLabel => 'सबफ़ोल्डर विस्तृत करें';

  @override
  String get collapseSubfoldersMenuItemLabel => 'सबफ़ोल्डर संक्षिप्त करें';

  @override
  String saveErrorInfoMessage(String error) {
    return 'सहेजने में त्रुटि: $error';
  }

  @override
  String get welcomeNoteTitle => 'Layout में आपका स्वागत है! 🚀';

  @override
  String get welcomeNoteContent => 'नई सुविधाएं जोड़ी गईं!';

  @override
  String get noteListDateGroupToday => 'आज';

  @override
  String get noteListDateGroupYesterday => 'कल';

  @override
  String get noteListDateGroupLast7Days => 'पिछले 7 दिन';

  @override
  String get noteListDateGroupLast30Days => 'पिछले 30 दिन';

  @override
  String get reminderRepeatNoneLabel => 'कोई पुनरावृत्ति नहीं';

  @override
  String get voiceRecorderPreparingLabel => 'तैयार किया जा रहा है…';

  @override
  String get voiceRecorderCancelButton => 'रद्द करें';

  @override
  String get voiceRecorderStopAddButton => 'रोकें और जोड़ें';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'माइक्रोफ़ोन अनुमति नहीं दी गई।';

  @override
  String get speechToTextUnavailableMessage =>
      'इस डिवाइस पर स्पीच पहचान उपलब्ध नहीं है।';

  @override
  String get speechToTextPreparingLabel => 'तैयार किया जा रहा है…';

  @override
  String get speechToTextListeningLabel => 'सुन रहा है…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'बोलना शुरू करें…';

  @override
  String get speechToTextCancelButton => 'रद्द करें';

  @override
  String get speechToTextStopAddButton => 'रोकें और जोड़ें';

  @override
  String get textToSpeechNoContentMessage =>
      'पढ़ने के लिए कोई सामग्री नहीं है।';

  @override
  String get textToSpeechReadErrorMessage => 'पढ़ते समय एक त्रुटि हुई।';

  @override
  String get textToSpeechUnavailableMessage =>
      'इस डिवाइस पर टेक्स्ट-टू-स्पीच उपलब्ध नहीं है।';

  @override
  String get textToSpeechPreparingLabel => 'तैयार किया जा रहा है…';

  @override
  String get textToSpeechPausedLabel => 'रोका गया';

  @override
  String get textToSpeechFinishedLabel => 'पढ़ना पूरा हुआ';

  @override
  String get textToSpeechReadingLabel => 'पढ़ रहा है…';

  @override
  String get textToSpeechCloseErrorButton => 'बंद करें';

  @override
  String get textToSpeechReplayButton => 'फिर से पढ़ें';

  @override
  String get textToSpeechCloseFinishedButton => 'बंद करें';

  @override
  String get textToSpeechPauseButton => 'रोकें';

  @override
  String get textToSpeechResumeButton => 'फिर शुरू करें';

  @override
  String get textToSpeechStopButton => 'रोकें';

  @override
  String get textToSpeechSpeedSlow => 'धीमा';

  @override
  String get textToSpeechSpeedNormal => 'सामान्य';

  @override
  String get textToSpeechSpeedFast => 'तेज़';

  @override
  String get calendarPickerCancelButton => 'रद्द करें';

  @override
  String get calendarPickerConfirmButton => 'चुनें';

  @override
  String get calendarPickerClearButton => 'साफ़ करें';

  @override
  String get reminderPickerDialogTitle => 'रिमाइंडर जोड़ें';

  @override
  String get reminderPickerDateTodayOption => 'आज';

  @override
  String get reminderPickerDateTomorrowOption => 'कल';

  @override
  String get reminderPickerDatePickOption => 'तारीख चुनें';

  @override
  String get reminderRepeatHourlyLabel => 'हर घंटे';

  @override
  String get reminderRepeatDailyLabel => 'हर दिन';

  @override
  String get reminderRepeatWeeklyLabel => 'हर सप्ताह';

  @override
  String get reminderRepeatMonthlyLabel => 'हर महीने';

  @override
  String get reminderRepeatYearlyLabel => 'हर साल';

  @override
  String get reminderPickerCalendarHelpText => 'रिमाइंडर तारीख चुनें';

  @override
  String get reminderPickerCancelButton => 'रद्द करें';

  @override
  String get reminderPickerSaveButton => 'सहेजें';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'बीता हुआ समय नहीं चुना जा सकता';

  @override
  String calcTableTotalLabel(String amount) {
    return 'कुल: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'डेटा तैयार किया जा रहा है...';

  @override
  String get backupCreatePackagingNotesLabel =>
      'नोट्स और फ़ोल्डर पैक किए जा रहे हैं...';

  @override
  String get backupCreateReadingAttachmentsLabel =>
      'अटैचमेंट पढ़े जा रहे हैं...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'अटैचमेंट पढ़े जा रहे हैं... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel =>
      'ज़िप फ़ाइल कंप्रेस की जा रही है...';

  @override
  String get backupCreateSavingFileLabel => 'फ़ाइल सहेजी जा रही है...';

  @override
  String get backupRestoreValidatingLabel => 'बैकअप सत्यापित किया जा रहा है...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'बैकअप सत्यापित हुआ, डेटा तैयार किया जा रहा है...';

  @override
  String get backupRestoreWritingNotesLabel => 'नोट्स लिखे जा रहे हैं...';

  @override
  String get backupRestoreWritingTrashLabel => 'ट्रैश लिखा जा रहा है...';

  @override
  String get backupRestoreTrashWrittenLabel => 'ट्रैश लिखा गया';

  @override
  String get backupRestoreWritingCategoriesLabel =>
      'फ़ोल्डर लिखे जा रहे हैं...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'फ़ोल्डर लिखे गए';

  @override
  String get backupRestoreWritingSettingsLabel => 'सेटिंग्स लिखी जा रही हैं...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'सेटिंग्स लिखी गईं';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'पुराने अटैचमेंट साफ़ किए जा रहे हैं...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'कोई अटैचमेंट नहीं मिला, समाप्त किया जा रहा है...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'अटैचमेंट पुनर्स्थापित किए जा रहे हैं... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'पूर्ण हुआ';

  @override
  String get backupValidationCorruptedFileMessage =>
      'फ़ाइल करप्ट है या एक मान्य बैकअप फ़ाइल नहीं है।';

  @override
  String get backupValidationMissingDataMessage =>
      'बैकअप फ़ाइल के अंदर कोई डेटा नहीं मिला (backup_data.json गायब है)।';

  @override
  String get backupValidationInvalidJsonMessage =>
      'बैकअप डेटा पढ़ा नहीं जा सका (करप्ट JSON)।';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'यह फ़ाइल layout ऐप का बैकअप नहीं है।';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'बैकअप फ़ाइल की वर्शन जानकारी पढ़ी नहीं जा सकी।';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'यह बैकअप एक नए फॉर्मेट में है जिसे मौजूदा ऐप वर्शन सपोर्ट नहीं करता। कृपया ऐप को अपडेट करें।';

  @override
  String get backupValidationInvalidVersionMessage =>
      'बैकअप फ़ाइल की वर्शन जानकारी अमान्य है।';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'बैकअप डेटा अपेक्षित फॉर्मेट में नहीं है (notes फ़ील्ड गायब है)।';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'बैकअप डेटा अपेक्षित फॉर्मेट में नहीं है (trash फ़ील्ड गायब है)।';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'बैकअप डेटा अपेक्षित फॉर्मेट में नहीं है (फ़ोल्डर सूची अमान्य है)।';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'बैकअप डेटा अपेक्षित फॉर्मेट में नहीं है (settings फ़ील्ड अमान्य है)।';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'बैकअप डेटा अपेक्षित फॉर्मेट में नहीं है (एक नोट रिकॉर्ड अमान्य है)।';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'बैकअप डेटा अपेक्षित फॉर्मेट में नहीं है (बिना ID वाला एक नोट रिकॉर्ड मिला)।';

  @override
  String get backupValidationFileNotFoundMessage => 'बैकअप फ़ाइल नहीं मिली।';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'डिवाइस पर पर्याप्त खाली स्टोरेज नहीं है। कृपया जगह खाली करें और फिर से प्रयास करें।';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'फ़ाइल एक्सेस अनुमति अस्वीकृत कर दी गई। कृपया ऐप की अनुमतियां जांचें और फिर से प्रयास करें।';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'फ़ाइल कार्रवाई के दौरान एक त्रुटि हुई: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'एक अप्रत्याशित त्रुटि हुई: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'ज़िप आर्काइव नहीं बनाया जा सका (ZipEncoder ने null लौटाया)।';

  @override
  String get calcTableMenuItemLabel => 'कैलकुलेशन सूची';

  @override
  String get tableBlockMenuItemLabel => 'तालिका';

  @override
  String get tableSizePickerTitle => 'तालिका का आकार चुनें';

  @override
  String get tableSizePickerCancel => 'रद्द करें';

  @override
  String get tableSizePickerDeleteTooltip => 'तालिका हटाएं';

  @override
  String get tagsMenuItemLabel => 'टैग';

  @override
  String get linkDialogUrlHint => 'https://example.com';

  @override
  String get checklistItemHint => 'आइटम जोड़ें...';

  @override
  String get toolbarHighlightTooltip => 'हाइलाइट';

  @override
  String get toolbarListTooltip => 'सूची';

  @override
  String get toolbarHideKeyboardTooltip => 'कीबोर्ड छिपाएं';

  @override
  String get autoBackupLocalSuccessMessage => 'लोकल बैकअप सफल रहा।';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'लोकल बैकअप विफल: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Drive बैकअप छोड़ा गया: Google खाता कनेक्टेड नहीं है या सत्र समाप्त हो चुका है। कृपया ऐप खोलें और फिर से कनेक्ट करें।';

  @override
  String get autoBackupDriveSuccessMessage => 'Drive बैकअप सफल रहा।';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Drive बैकअप विफल: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'अभी तक कोई नोट नहीं';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'कुल: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ ड्राइंग';

  @override
  String get autoBackupSettingsAppBarTitle => 'स्वचालित बैकअप सेटिंग्स';

  @override
  String get autoBackupSettingsMainSwitchTitle => 'स्वचालित बैकअप सक्षम करें';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'आपके नोट्स बैकग्राउंड में समय-समय पर सुरक्षित रूप से बैकअप किए जाते हैं।';

  @override
  String get autoBackupSettingsTargetTitle => 'बैकअप गंतव्य';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'चुनें कि बैकअप कहां सहेजे जाएं।';

  @override
  String get autoBackupSettingsTargetLocalOption => 'लोकल';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'दोनों';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Google Drive विकल्पों का उपयोग करने के लिए पहले अपना खाता कनेक्ट करें।';

  @override
  String get autoBackupSettingsConnectButton => 'कनेक्ट करें';

  @override
  String get autoBackupSettingsFrequencyTitle => 'बैकअप आवृत्ति';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'हर $hours घंटे में एक बैकअप लिया जाता है।';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 घंटे';

  @override
  String get autoBackupSettingsFrequency12h => '12 घंटे';

  @override
  String get autoBackupSettingsFrequency24h => '24 घंटे (प्रतिदिन)';

  @override
  String get autoBackupSettingsFrequency48h => '48 घंटे (2 दिन)';

  @override
  String get autoBackupSettingsFrequency168h => '168 घंटे (साप्ताहिक)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle =>
      'केवल Wi-Fi का उपयोग करें';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'आपके मोबाइल डेटा को बचाने के लिए क्लाउड अपलोड केवल Wi-Fi पर होता है।';

  @override
  String get autoBackupSettingsStatusCardTitle => 'सिस्टम स्थिति';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'स्वचालित बैकअप अभी तक नहीं चला है।';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'अंतिम रन: $date $time ($status)\nसंदेश: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'सफल';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'विफल';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Google खाते से कनेक्ट नहीं हो सका।';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'स्वचालित बैकअप सेटिंग्स अपडेट की गईं।';

  @override
  String selectionModeDeletedMessage(int count) {
    return '$count नोट्स हटाए गए';
  }

  @override
  String get selectionModeArchivedMessage => 'संग्रहीत किया गया';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return '$count नोट्स के लिए फ़ोल्डर चुनें';
  }

  @override
  String get selectionModeAddCategoryOption => 'फ़ोल्डर जोड़ें';

  @override
  String get selectionModeRemoveCategoryOption => 'फ़ोल्डर हटाएं';

  @override
  String get calcTableItemHint => 'आइटम...';

  @override
  String get calcTableTotalRowLabel => 'कुल';

  @override
  String get textSelectionMenuShareButton => 'साझा करें';

  @override
  String get textSelectionMenuTranslateButton => 'अनुवाद करें';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'साझा करना शुरू नहीं किया जा सका।';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'अनुवाद नहीं खोला जा सका।';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'आज $time';
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
    return 'अंतिम बैकअप: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage =>
      'अभी तक कोई बैकअप नहीं लिया गया है।';

  @override
  String get backupFileNameLabel => 'बैकअप';
}
