// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'Kalın';

  @override
  String get toolbarItalicTooltip => 'İtalik';

  @override
  String get toolbarUnderlineTooltip => 'Altı Çizili';

  @override
  String get toolbarStrikethroughTooltip => 'Üzeri Çizili';

  @override
  String get toolbarFontSizeTooltip => 'Yazı Boyutu';

  @override
  String get toolbarColorTooltip => 'Yazı Rengi';

  @override
  String get toolbarBulletTooltip => 'Madde İşareti';

  @override
  String get toolbarNumberTooltip => 'Numara İşareti';

  @override
  String get toolbarIndentTooltip => 'Paragraf Girintisi';

  @override
  String get toolbarLinkTooltip => 'Link Ekle / Düzenle / Kaldır';

  @override
  String get toolbarDividerTooltip => 'Yatay Çizgi Ekle';

  @override
  String get toolbarChecklistTooltip => 'Yapılacaklar Listesi Ekle';

  @override
  String get linkSelectTextSnackbar =>
      'Önce link eklemek istediğiniz metni seçin';

  @override
  String get linkDialogEditTitle => 'Linki Düzenle';

  @override
  String get linkDialogAddTitle => 'Link Ekle';

  @override
  String get linkDialogRemoveButton => 'Linki Kaldır';

  @override
  String get linkDialogCancelButton => 'Vazgeç';

  @override
  String get linkDialogConfirmButton => 'Ekle';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Kamera izni reddedilmiş. Video çekmek için ayarlardan izin vermen gerekiyor.';

  @override
  String get cameraPermissionRequiredMessage =>
      'Video çekmek için kamera izni gerekiyor.';

  @override
  String get openSettingsButtonLabel => 'Ayarlar';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'Tarama başlatılamadı: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'Metin tanıma başarısız: $error';
  }

  @override
  String get ocrNoReadableTextMessage => 'Belgede okunabilir metin bulunamadı';

  @override
  String get scanResultSheetTitle => 'Taranan belge nasıl eklensin?';

  @override
  String get scanResultTextOnlyOption => 'Sadece metin olarak ekle';

  @override
  String get scanResultTextAndImageOption => 'Metin + taranan görseli ekle';

  @override
  String get scanResultCancelOption => 'Vazgeç';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'Mikrofon izni reddedilmiş. Ses kaydı için ayarlardan izin vermen gerekiyor.';

  @override
  String get audioPermissionRequiredMessage =>
      'Ses kaydı için mikrofon izni gerekiyor.';

  @override
  String get voiceRecordingDefaultLabel => 'Ses Kaydı';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'Hesap Listesi ($count satır)';
  }

  @override
  String get blockPreviewDrawingLabel => 'Çizim';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count ek (fotoğraf/belge)';
  }

  @override
  String get blockPreviewDividerLabel => 'Ayırıcı Çizgi';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'Kontrol Listesi ($count madde)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(boş metin)';

  @override
  String get reorderBlocksSheetTitle => 'Blokları Sırala';

  @override
  String get reorderBlocksMoveUpTooltip => 'Yukarı Taşı';

  @override
  String get reorderBlocksMoveDownTooltip => 'Aşağı Taşı';

  @override
  String get reorderBlocksCloseTooltip => 'Kapat';

  @override
  String get reorderBlocksDescription =>
      'Taşımak istediğiniz bloğa dokunup seçin, sonra yukarı/aşağı ok ile taşıyın.';

  @override
  String get reorderBlocksMenuItemLabel => 'Sırala';

  @override
  String get txtImportPickerDialogTitle => 'İçe aktarılacak TXT dosyasını seç';

  @override
  String get txtImportReadFailedMessage => 'TXT dosyası okunamadı';

  @override
  String get txtImportEmptyFileMessage => 'TXT dosyası boş';

  @override
  String get txtImportSuccessMessage => 'TXT içe aktarıldı';

  @override
  String get txtImportMenuItemLabel => 'İçe Aktar (txt)';

  @override
  String get exportMenuItemLabel => 'Dışa Aktar';

  @override
  String get editorUndoTooltip => 'Geri Al';

  @override
  String get editorRedoTooltip => 'İleri Al';

  @override
  String get noteSavedMessage => 'Not kaydedildi';

  @override
  String get dateAssignPickerHelpText => 'Notu bir güne ata';

  @override
  String get dateAssignChangeOption => 'Tarihi değiştir';

  @override
  String get dateAssignRemoveOption => 'Atamayı kaldır';

  @override
  String get editorSubToolbarCloseTooltip => 'Kapat';

  @override
  String get titleFieldHint => 'Başlık';

  @override
  String get textBlockHint => 'Notunuzu buraya yazın...';

  @override
  String get drawingBoardMenuItemLabel => 'Çizim Panosu';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'Sesi yazıya çevirme yalnızca metin notlarında kullanılabilir';

  @override
  String get selectionModeCancelTooltip => 'Seçimi İptal Et';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return '$count seçildi';
  }

  @override
  String get selectionModeDeleteTooltip => 'Sil';

  @override
  String get selectionModeArchiveTooltip => 'Arşiv';

  @override
  String get selectionModeFolderTooltip => 'Klasör';

  @override
  String get searchFieldHint => 'Notlarda ara...';

  @override
  String get emptyTrashDialogTitle => 'Çöpü Boşalt';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'Tüm silinen notlar kalıcı olarak silinecek. Emin misiniz?';

  @override
  String get emptyTrashDialogCancelButton => 'İptal';

  @override
  String get restoreAllMenuItemLabel => 'Hepsini Geri Yükle';

  @override
  String get sortMenuTooltip => 'Notları Sırala';

  @override
  String get sortMenuAscendingLabel => 'Düzen: Artan (A-Z)';

  @override
  String get sortMenuDescendingLabel => 'Düzen: Azalan (Z-A)';

  @override
  String get sortMenuByTitleLabel => 'Sırala: Başlık';

  @override
  String get sortMenuByModifiedDateLabel => 'Sırala: Son Düzenleme';

  @override
  String get sortMenuByCreatedDateLabel => 'Sırala: Oluşturulma';

  @override
  String get sortMenuByFolderLabel => 'Sırala: Klasör';

  @override
  String get viewToggleGridTooltip => 'Izgara Görünümü';

  @override
  String get viewToggleListTooltip => 'Liste Görünümü';

  @override
  String get drawerHeaderSubtitle => 'Kişisel Not Defteriniz';

  @override
  String get drawerNotesSectionHeader => 'NOTLAR';

  @override
  String get drawerAllNotesLabel => 'Notlar';

  @override
  String get drawerFavoritesLabel => 'Favori';

  @override
  String get drawerAgendaLabel => 'Ajanda';

  @override
  String get drawerRemindersLabel => 'Hatırlatıcı';

  @override
  String get drawerLockedLabel => 'Kilitli';

  @override
  String get drawerTrashLabel => 'Çöp';

  @override
  String get drawerFoldersSectionHeader => 'KLASÖRLER';

  @override
  String get drawerExpandLabel => 'Genişlet';

  @override
  String get drawerCollapseLabel => 'Daralt';

  @override
  String get drawerAddFolderLabel => 'Klasör Ekle';

  @override
  String get drawerAppSectionHeader => 'UYGULAMA';

  @override
  String get drawerCalendarLabel => 'Takvim';

  @override
  String get drawerSettingsLabel => 'Ayarlar';

  @override
  String get drawerBackupRestoreLabel => 'Yedekle & Geri Yükle';

  @override
  String get drawerUpgradeToProLabel => 'Pro\'ya Yükselt';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'Geliştirme Desteği';

  @override
  String get drawerFeedbackLabel => 'Geri Bildirim';

  @override
  String get drawerAboutLabel => 'Hakkında';

  @override
  String get noNotesFoundMessage => 'Not bulunamadı.';

  @override
  String get trashRestoreButtonLabel => 'Geri Yükle';

  @override
  String get trashPermanentDeleteButtonLabel => 'Kalıcı Sil';

  @override
  String get tagRenamedInfoMessage => 'Etiket yeniden adlandırıldı';

  @override
  String get tagDeletedInfoMessage => 'Etiket silindi';

  @override
  String get tagOptionsRenameLabel => 'Yeniden Adlandır';

  @override
  String get tagOptionsDeleteLabel => 'Sil';

  @override
  String get renameTagDialogTitle => 'Etiketi Yeniden Adlandır';

  @override
  String get renameTagDialogHint => 'Yeni etiket adı';

  @override
  String get renameTagDialogCancelButton => 'İptal';

  @override
  String get renameTagDialogSaveButton => 'Kaydet';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '\"$tag\" etiketi $affectedCount nottan kaldırılacak. Devam edilsin mi?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return '\"$tag\" etiketi silinsin mi?';
  }

  @override
  String get deleteTagDialogTitle => 'Etiketi Sil';

  @override
  String get deleteTagDialogCancelButton => 'İptal';

  @override
  String get deleteTagDialogConfirmButton => 'Sil';

  @override
  String get tagsSheetTitle => 'Etiketler';

  @override
  String get tagsSheetEmptyMessage => 'Bu notta henüz etiket yok.';

  @override
  String get tagsSheetInputHint => 'Yeni etiket yaz...';

  @override
  String get tagsSheetSuggestionsLabel => 'Mevcut etiketler';

  @override
  String get noteDeletedInfoMessage => 'Not silindi';

  @override
  String get noteDeletedUndoActionLabel => 'Geri Getir';

  @override
  String get reminderSetInfoMessage => 'Hatırlatıcı ayarlandı';

  @override
  String get reminderRemovedInfoMessage => 'Hatırlatıcı kaldırıldı';

  @override
  String get noteDuplicatedInfoMessage => 'Kopya oluşturuldu';

  @override
  String get speechTextAppendedInfoMessage => 'Metin nota eklendi';

  @override
  String get pdfPreparingInfoMessage => 'PDF hazırlanıyor…';

  @override
  String get pdfSavedInfoMessage => 'PDF kaydedildi';

  @override
  String get jpgPreparingInfoMessage => 'JPG hazırlanıyor…';

  @override
  String get jpgSavedInfoMessage => 'JPG kaydedildi';

  @override
  String get jpgFailedInfoMessage => 'JPG oluşturulamadı';

  @override
  String get txtPreparingInfoMessage => 'TXT hazırlanıyor…';

  @override
  String get txtSavedInfoMessage => 'TXT kaydedildi';

  @override
  String get txtFailedInfoMessage => 'TXT oluşturulamadı';

  @override
  String get exportOpenActionLabel => 'Aç';

  @override
  String get wrongPasswordInfoMessage => 'Parola yanlış.';

  @override
  String get noteArchivedInfoMessage => 'Not arşivlendi';

  @override
  String get noteUnarchivedInfoMessage => 'Arşivden çıkarıldı';

  @override
  String get noteUnlockedInfoMessage => 'Kilidi kaldırıldı';

  @override
  String get noteLockedInfoMessage => 'Not kilitlendi';

  @override
  String get notificationUnpinnedInfoMessage => 'Sabitleme kaldırıldı';

  @override
  String get emptyNotePinBlockedInfoMessage => 'Boş not sabitlenemez.';

  @override
  String get notificationPinnedInfoMessage => 'Bildirim paneline sabitlendi';

  @override
  String get noContentToReadInfoMessage => 'Okunacak bir içerik yok';

  @override
  String get backPressExitInfoMessage => 'Çıkmak için tekrar geri tuşuna basın';

  @override
  String get reminderChannelName => 'Not Hatırlatıcıları';

  @override
  String get reminderChannelDescription =>
      'Layout uygulamasındaki not hatırlatıcıları';

  @override
  String get pinnedChannelName => 'Sabitlenmiş Notlar';

  @override
  String get pinnedChannelDescription =>
      'Bildirim paneline sabitlenen Layout notları';

  @override
  String get notificationUnpinActionLabel => 'Kaldır';

  @override
  String get reminderDefaultTitle => 'Hatırlatıcı';

  @override
  String get reminderChecklistBodyFallback =>
      'Kontrol listeni kontrol etmeyi unutma';

  @override
  String get reminderTextBodyFallback => 'Notunu kontrol etmeyi unutma';

  @override
  String get pdfSaveDialogTitle => 'PDF olarak kaydet';

  @override
  String get jpgSaveDialogTitle => 'JPG olarak kaydet';

  @override
  String get txtSaveDialogTitle => 'TXT olarak kaydet';

  @override
  String get textSizeSheetTitle => 'Metin Boyutu';

  @override
  String get textSizeSamplePreview => 'Örnek metin';

  @override
  String get textSizeCancelButton => 'İptal';

  @override
  String get textSizeApplyButton => 'Uygula';

  @override
  String get createPasswordDialogTitle => 'Şifre Oluştur';

  @override
  String get createPasswordNewPasswordHint => 'Yeni şifre';

  @override
  String get createPasswordConfirmHint => 'Şifreyi tekrar gir';

  @override
  String get createPasswordHintQuestionDescription =>
      'Şifrenizi unutursanız diye bir güvenlik sorusu belirleyin (zorunlu değildir).';

  @override
  String get createPasswordHintQuestionHint => 'Güvenlik sorusu seçin';

  @override
  String get createPasswordHintAnswerHint => 'Cevabınız';

  @override
  String get createPasswordCancelButton => 'İptal';

  @override
  String get createPasswordSaveButton => 'Kaydet';

  @override
  String get passwordMismatchMessage => 'Şifreler eşleşmiyor!';

  @override
  String get passwordRequiredDialogTitle => 'Şifre Gerekiyor';

  @override
  String get passwordRequiredHint => 'Şifreyi girin';

  @override
  String get forgotPasswordButtonLabel => 'Şifremi unuttum';

  @override
  String get passwordRequiredCancelButton => 'İptal';

  @override
  String get passwordRequiredConfirmButton => 'Doğrula';

  @override
  String get securityQuestionDialogTitle => 'Güvenlik Sorusu';

  @override
  String get securityQuestionAnswerHint => 'Cevabınız';

  @override
  String get securityQuestionCancelButton => 'İptal';

  @override
  String get securityQuestionConfirmButton => 'Onayla';

  @override
  String get securityQuestionWrongAnswerMessage =>
      'Cevap yanlış. Tekrar deneyin.';

  @override
  String get revealedPasswordDialogTitle => 'Şifreniz';

  @override
  String get revealedPasswordLabel => 'Not şifreniz:';

  @override
  String get revealedPasswordOkButton => 'Tamam';

  @override
  String get securityQuestionPetName => 'İlk evcil hayvanınızın adı nedir?';

  @override
  String get securityQuestionFavoriteTeacher =>
      'En sevdiğiniz öğretmeninizin adı nedir?';

  @override
  String get securityQuestionBirthCity => 'Doğduğunuz şehir nedir?';

  @override
  String get securityQuestionFavoriteFood => 'En sevdiğiniz yemek nedir?';

  @override
  String get securityQuestionMotherMaidenName =>
      'Annenizin kızlık soyadı nedir?';

  @override
  String get securityQuestionFirstSchool => 'İlk okuduğunuz okulun adı nedir?';

  @override
  String get securityQuestionFavoriteColor => 'En sevdiğiniz renk nedir?';

  @override
  String get editFolderDialogTitle => 'Klasörü Düzenle';

  @override
  String get newSubfolderDialogTitle => 'Yeni Alt Klasör';

  @override
  String get addFolderDialogTitle => 'Klasör Ekle';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return '\"$parentCategory\" içinde oluşturulacak';
  }

  @override
  String get subfolderNameFieldLabel => 'Alt klasör adı';

  @override
  String get folderNameFieldLabel => 'Klasör adı';

  @override
  String get folderColorLabel => 'Renk';

  @override
  String get folderDialogCancelButton => 'İptal';

  @override
  String get folderDialogSaveButton => 'Kaydet';

  @override
  String get folderDialogAddButton => 'Ekle';

  @override
  String get selectFolderSheetTitle => 'Klasör Seç';

  @override
  String get selectFolderAddOptionLabel => 'Klasör Ekle';

  @override
  String get removeCurrentFolderLabel => 'Mevcut Klasörü Kaldır';

  @override
  String get noteDetailsDialogTitle => 'Ayrıntılar';

  @override
  String get noteDetailsCreatedLabel => 'Oluşturulma';

  @override
  String get noteDetailsModifiedLabel => 'Son Düzenleme';

  @override
  String get noteDetailsCharCountLabel => 'Karakter Sayısı';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count karakter';
  }

  @override
  String get noteDetailsWordCountLabel => 'Kelime Sayısı';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count kelime';
  }

  @override
  String get noteDetailsOkButton => 'Tamam';

  @override
  String get noteDetailsUnknownDateLabel => 'Bilinmiyor';

  @override
  String get addAttachmentSheetTitle => 'Ekle';

  @override
  String get addAttachmentImageOption => 'Görsel Ekle';

  @override
  String get addAttachmentCameraOption => 'Kamera';

  @override
  String get addAttachmentFileOption => 'Dosya Ekle';

  @override
  String get addAttachmentVoiceOption => 'Ses Kaydı';

  @override
  String get addAttachmentVideoOption => 'Video Çek';

  @override
  String get addAttachmentScanOption => 'Belge Tara';

  @override
  String get noteActionsSheetTitle => 'Eylem Seç';

  @override
  String get noteActionReminderLabel => 'Hatırlatıcı';

  @override
  String get noteActionEditReminderLabel => 'Hatırlatıcıyı Düzenle';

  @override
  String get noteActionSpeechToTextLabel => 'Sesi Yazıya Çevir';

  @override
  String get noteActionArchiveLabel => 'Arşiv';

  @override
  String get noteActionUnarchiveLabel => 'Arşivden Çıkar';

  @override
  String get noteActionLockLabel => 'Kilitle';

  @override
  String get noteActionUnlockLabel => 'Kilidi Kaldır';

  @override
  String get noteActionFavoriteLabel => 'Favori';

  @override
  String get noteActionUnfavoriteLabel => 'Favoriden Çıkar';

  @override
  String get noteActionClassifyLabel => 'Klasör Seç';

  @override
  String get noteActionDeleteLabel => 'Sil';

  @override
  String get noteActionPinToNotificationLabel => 'Bildirim Paneline Sabitle';

  @override
  String get noteActionUnpinFromNotificationLabel => 'Sabitlemeyi Kaldır';

  @override
  String get noteActionShareLabel => 'Paylaş';

  @override
  String get noteActionDuplicateLabel => 'Kopya Oluştur';

  @override
  String get noteActionCopyContentLabel => 'İçeriği Kopyala';

  @override
  String get noteActionTtsLabel => 'Yüksek Sesle Oku';

  @override
  String get noteActionTextSizeLabel => 'Metin Boyutu';

  @override
  String get noteActionDetailsLabel => 'Ayrıntılar';

  @override
  String get noteActionDiscardChangesLabel => 'Değişiklikleri Yok Say';

  @override
  String get noteActionSelectLabel => 'Seç';

  @override
  String get reminderEditOptionLabel => 'Hatırlatıcıyı değiştir';

  @override
  String get reminderRemoveOptionLabel => 'Hatırlatıcıyı kaldır';

  @override
  String get discardChangesDialogTitle => 'Değişiklikleri Yok Say';

  @override
  String get discardChangesDialogMessage =>
      'Bu nottaki kaydedilmemiş değişiklikler kaybolacak. Yok saymak istediğinize emin misiniz?';

  @override
  String get discardChangesCancelButton => 'Vazgeç';

  @override
  String get discardChangesConfirmButton => 'Yok Say';

  @override
  String get pinnedNotificationDefaultTitle => 'Not';

  @override
  String get pdfFailedInfoMessage => 'PDF oluşturulamadı';

  @override
  String get drawingScreenTitle => 'Çizim';

  @override
  String get drawingMinimizeTooltip => 'Küçült';

  @override
  String get drawingEmptyExportWarningMessage => 'Önce bir çizim yapın';

  @override
  String get drawingEraserPartialModeLabel => 'Kısmi';

  @override
  String get drawingEraserFullModeLabel => 'Tam';

  @override
  String get drawingClearTooltip => 'Temizle';

  @override
  String get drawingZoomOutTooltip => 'Uzaklaştır';

  @override
  String get drawingZoomInTooltip => 'Yakınlaştır';

  @override
  String get drawingDeleteTooltip => 'Sil';

  @override
  String get drawingEmptyPreviewHint => 'Çizmek için dokunun';

  @override
  String get settingsPageTitle => 'Ayarlar';

  @override
  String get settingsSectionGeneral => 'Genel';

  @override
  String get settingsSectionSecurity => 'Güvenlik';

  @override
  String get settingsSectionTheme => 'Tema';

  @override
  String get settingsSectionPersonalization => 'Kişiselleştirme';

  @override
  String get settingsSectionWidget => 'Widget';

  @override
  String get settingsSectionAbout => 'Hakkında';

  @override
  String get settingsHintQuestionPet => 'İlk evcil hayvanınızın adı nedir?';

  @override
  String get settingsHintQuestionTeacher =>
      'En sevdiğiniz öğretmeninizin adı nedir?';

  @override
  String get settingsHintQuestionBirthCity => 'Doğduğunuz şehir nedir?';

  @override
  String get settingsHintQuestionFavoriteFood => 'En sevdiğiniz yemek nedir?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'Annenizin kızlık soyadı nedir?';

  @override
  String get settingsHintQuestionFirstSchool =>
      'İlk okuduğunuz okulun adı nedir?';

  @override
  String get settingsHintQuestionFavoriteColor => 'En sevdiğiniz renk nedir?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'Güvenlik Sorusu';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'Şifrenizi unutursanız, bu soruyu doğru cevaplayarak şifrenizi hatırlayabilirsiniz.';

  @override
  String get settingsSecurityQuestionDropdownHint => 'Güvenlik sorusu seçin';

  @override
  String get settingsSecurityQuestionAnswerHint => 'Cevabınız';

  @override
  String get settingsSecurityQuestionCancelButton => 'İptal';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'Soru ve cevap boş olamaz!';

  @override
  String get settingsSecurityQuestionSaveButton => 'Kaydet';

  @override
  String get settingsCreatePasswordTitle => 'Şifre Oluştur';

  @override
  String get settingsPasswordRequiredTitle => 'Şifre Gerekiyor';

  @override
  String get settingsPasswordEnterHint => 'Şifreyi girin';

  @override
  String get settingsForgotPasswordButton => 'Şifremi unuttum';

  @override
  String get settingsNewPasswordHint => 'Yeni şifre';

  @override
  String get settingsConfirmPasswordHint => 'Şifreyi tekrar gir';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'Şifrenizi unutursanız diye bir güvenlik sorusu belirleyin (zorunlu değildir).';

  @override
  String get settingsPasswordDialogCancelButton => 'İptal';

  @override
  String get settingsPasswordMismatchWarning => 'Şifreler eşleşmiyor!';

  @override
  String get settingsWrongPasswordWarning => 'Yanlış şifre!';

  @override
  String get settingsPasswordSaveButton => 'Kaydet';

  @override
  String get settingsPasswordRemoveButton => 'Kaldır';

  @override
  String get settingsNotePasswordTitle => 'Not Şifresi';

  @override
  String get settingsPasswordSetSubtitle => 'Şifre ayarlandı ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'Şifre ayarlanmadı';

  @override
  String get settingsSecurityQuestionTileTitle => 'Güvenlik Sorusu';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'Belirlendi ✓ — şifreyi unutursanız kullanılır';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'Belirlenmedi — şifrenizi kaybederseniz kurtaramazsınız';

  @override
  String get settingsThemeDialogTitle => 'Tema Seçin';

  @override
  String get settingsThemeSystemDefault => 'Sistem Varsayılanı';

  @override
  String get settingsThemeLightOption => 'Açık Tema';

  @override
  String get settingsThemeDarkOption => 'Koyu Tema';

  @override
  String get settingsLanguageDialogTitle => 'Dil Seçin';

  @override
  String get settingsLanguageSystemOption => 'Sistem';

  @override
  String get settingsAccentColorDialogTitle => 'Vurgu Rengini Seçin';

  @override
  String get settingsThemeChangeTileTitle => 'Tema Değiştir';

  @override
  String get settingsThemeLightLabel => 'Açık';

  @override
  String get settingsThemeDarkLabel => 'Koyu';

  @override
  String get settingsThemeSystemLabel => 'Sistem';

  @override
  String get settingsLanguageTileTitle => 'Dil';

  @override
  String get settingsAccentColorTileTitle => 'Vurgu Rengi';

  @override
  String get settingsAccentColorTileSubtitle =>
      'AppBar, buton ve anahtarlarda kullanılan renk';

  @override
  String get settingsColorfulNotesTitle => 'Değişken Not Renkleri';

  @override
  String get settingsColorfulNotesSubtitle =>
      'Her not kartı farklı renk tonu alır.';

  @override
  String get settingsTextColorSheetTitle => 'Yazı Rengi';

  @override
  String get settingsTextColorSheetDesc =>
      'Not içerik metninin rengini belirler.';

  @override
  String get settingsTextColorOkButton => 'Tamam';

  @override
  String get settingsTextColorTileTitle => 'Yazı Rengi';

  @override
  String get settingsTextColorTileSubtitle => 'Not içerik metni için renk.';

  @override
  String get settingsWidgetFontSizeLabel => 'Widget Yazı Boyutu';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'Örnek başlık - $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'İptal';

  @override
  String get settingsWidgetFontSizeApplyButton => 'Uygula';

  @override
  String get settingsWidgetOpacityLabel => 'Arka Plan Saydamlığı';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return '%$percent saydamlık';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'İptal';

  @override
  String get settingsWidgetOpacityApplyButton => 'Uygula';

  @override
  String get settingsWidgetDarkModeTitle => 'Koyu Widget';

  @override
  String get settingsWidgetDarkModeDesc => 'Widget için koyu renk şeması.';

  @override
  String get settingsAboutVersionTitle => 'Uygulama Sürümü';

  @override
  String get settingsFontFamilyTileTitle => 'Yazı Tipi';

  @override
  String get settingsFontFamilyDefaultLabel => 'Varsayılan';

  @override
  String get settingsGlobalFontSizeTileTitle => 'Yazı Boyutu';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt — tüm notlara uygulanır.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'Örnek metin - $size pt';
  }

  @override
  String get settingsGlobalFontSizeApplyToAllLabel => 'Mevcut notlara uygula';

  @override
  String get settingsGlobalFontSizeApplyToAllNote =>
      'Bireysel not boyutu ayarı varsa bu ayar o notları etkilemez.';

  @override
  String get settingsGlobalFontSizeCancelButton => 'İptal';

  @override
  String get settingsGlobalFontSizeApplyButton => 'Uygula';

  @override
  String get settingsPreviewLinesTileTitle => 'Not Önizleme Satırı';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'En fazla $lines satır göster. Not daha kısaysa gerçek satır sayısı görünür.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'Şu an: $lines satır';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'Maksimum önizlenecek satır sayısını belirler. Not daha az satıra sahipse gerçek satır sayısı gösterilir.';

  @override
  String get settingsPreviewLinesCancelButton => 'İptal';

  @override
  String get settingsPreviewLinesApplyButton => 'Uygula';

  @override
  String get backupCancelButton => 'Vazgeç';

  @override
  String get backupConnectButton => 'Bağlan';

  @override
  String get backupDisconnectButton => 'Bağlantıyı Kes';

  @override
  String get backupContinueButton => 'Devam Et';

  @override
  String get backupCloseButton => 'Kapat';

  @override
  String get backupShareButton => 'Paylaş';

  @override
  String get backupRestoreButton => 'Geri Yükle';

  @override
  String get backupConfigureButton => 'Ayarla';

  @override
  String get backupUnknownDateLabel => 'Bilinmiyor';

  @override
  String get backupProcessingDefaultLabel => 'İşleniyor...';

  @override
  String get backupPermissionRequiredTitle => 'Depolama İzni Gerekli';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'Bu Android sürümünde yedekleme/geri yükleme için depolama izni gereklidir. İzin kalıcı olarak reddedildiğinden, lütfen uygulama ayarlarından izni elle etkinleştirin.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'Bu Android sürümünde yedekleme/geri yükleme için depolama izni gereklidir. Devam edebilmek için lütfen izni verin.';

  @override
  String get backupGoToSettingsButton => 'Ayarlara Git';

  @override
  String get backupRetryButton => 'Tekrar Dene';

  @override
  String get backupDriveConnectingLabel => 'Google hesabına bağlanılıyor...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Google Drive hesabına bağlanıldı: $email';
  }

  @override
  String get backupDriveConnectedMessage => 'Google Drive hesabına bağlanıldı.';

  @override
  String get backupDriveConnectFailedMessage =>
      'Google hesabına bağlanılamadı veya işlem iptal edildi.';

  @override
  String get backupDriveDisconnectTitle => 'Google Drive Bağlantısını Kes';

  @override
  String get backupDriveDisconnectBody =>
      'Bağlantı kesilirse Drive\'a manuel veya otomatik yedekleme yapılamaz. Drive\'da halihazırda duran yedekleriniz silinmez, yalnızca bu cihazdan erişim kaldırılır.';

  @override
  String get backupDriveDisconnectedMessage =>
      'Google Drive bağlantısı kesildi.';

  @override
  String get backupDriveRequiredTitle => 'Google Hesabı Gerekli';

  @override
  String get backupDriveRequiredBody =>
      'Bu işlem için Google hesabınızla bağlanmanız gerekiyor. Şimdi bağlanmak ister misiniz?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: bağlı ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: bağlı';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: bağlı değil';

  @override
  String get backupDriveAuthenticatingLabel => 'Google hesabı doğrulanıyor...';

  @override
  String get backupDriveNotSignedInMessage =>
      'Google Drive\'a bağlı değilsiniz. Lütfen önce Google hesabınızla giriş yapın.';

  @override
  String get backupDriveUploadingLabel => 'Yedek Drive\'a yükleniyor...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Google Drive\'a yükleme 120 saniye içinde tamamlanamadı (sunucudan yanıt gelmedi). Lütfen bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get backupDriveOperationCompletedLabel => 'Tamamlandı';

  @override
  String get backupToDriveActionLabel => 'Drive\'a yedekleme';

  @override
  String get backupToDeviceActionLabel => 'yedekleme';

  @override
  String get backupCreatingLabel => 'Yedek oluşturuluyor...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'Yedek oluşturulamadı: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Google Drive\'a yükleme başarısız: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'Yedek Google Drive\'a başarıyla yüklendi.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'Yedek oluşturuldu: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'Yedek Hazır';

  @override
  String get backupOfferShareBody =>
      'Yedek dosyanız cihazınıza kaydedildi. Dosyayı şimdi paylaşmak (örn. bulut depolama, e-posta, başka bir cihaz) ister misiniz?';

  @override
  String get backupShareFileText => 'layout yedek dosyası';

  @override
  String backupShareFailedMessage(String error) {
    return 'Paylaşım başlatılamadı: $error';
  }

  @override
  String get backupLargeOperationTitle => 'Büyük Yedek';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'İşlenecek veri boyutu yaklaşık $sizeText. Bu boyuttaki bir $actionLabel işlemi cihazınıza bağlı olarak biraz zaman alabilir. İşlem sürerken uygulamadan çıkmamanız yeterlidir, devam etmek ister misiniz?';
  }

  @override
  String get backupRestoreActionLabel => 'geri yükleme';

  @override
  String get backupDriveListingLabel => 'Drive yedekleri listeleniyor...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'Yedekler listelenemedi: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'Google Drive\'da henüz bir yedek bulunmuyor.';

  @override
  String get backupDrivePickTitle => 'Drive\'dan Yedek Seç';

  @override
  String get backupDriveDownloadingLabel => 'Yedek Drive\'dan indiriliyor...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Yedek Drive\'dan indiriliyor... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel => 'Dosya cihaza kaydediliyor...';

  @override
  String get backupDriveUnknownBackupFileName => 'bilinmeyen_yedek.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Google Drive depolama alanınız dolu. Lütfen Drive\'da yer açıp tekrar deneyin.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'İnternet bağlantısı sağlanamadı. Lütfen bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'Belirtilen yedek dosyası Drive\'da bulunamadı. Silinmiş olabilir.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Google Drive işlemi sırasında beklenmeyen bir hata oluştu: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'İndirme başarısız: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'Dosya seçilemedi: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'Seçilen dosyaya erişilemedi.';

  @override
  String get backupCheckingLabel => 'Yedek kontrol ediliyor...';

  @override
  String backupReadFailedMessage(String error) {
    return 'Yedek dosyası okunamadı: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'Yedeği Geri Yükle';

  @override
  String get backupPreviewContentsHeader => 'Seçilen yedeğin içeriği:';

  @override
  String get backupPreviewNoteCountLabel => 'Not sayısı';

  @override
  String get backupPreviewTrashCountLabel => 'Çöp kutusundaki not';

  @override
  String get backupPreviewCategoryCountLabel => 'Kategori sayısı';

  @override
  String get backupPreviewAttachmentLabel => 'Ek dosya';

  @override
  String get backupPreviewAttachmentNoneValue => 'Yok';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count dosya ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'Oluşturulma tarihi';

  @override
  String get backupEmptyPreviewTitle => 'Bu yedek boş görünüyor';

  @override
  String get backupEmptyPreviewBody =>
      'Seçilen dosyada not, kategori veya ek dosya bulunamadı. Yine de devam ederseniz mevcut verileriniz silinip yerine bu boş yedek yazılır.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '$count ek dosya yedekte bulunamadı';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'Bu dosyalara sahip notlar geri yüklenecek, ancak ek dosyalar olmadan (yedek alınırken eksik ya da bozuk kalmış olabilirler): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown ve $remaining tane daha';
  }

  @override
  String get backupRestoreConfirmBody =>
      'Bu işlem; mevcut tüm notlarınızın, çöp kutunuzun, kategorilerinizin, ayarlarınızın ve eklerinizin YERİNE yukarıdaki yedekteki verileri yazacaktır. Mevcut veriler kalıcı olarak kaybolur ve bu işlem geri alınamaz.';

  @override
  String get backupRestoringLabel => 'Yedek geri yükleniyor...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'Yedek geri yüklendi. Ancak $count ek dosya yedekte bulunamadığı için geri yüklenemedi. Değişikliklerin tam yansıması için uygulamayı yeniden başlatmanız önerilir.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'Yedek başarıyla geri yüklendi. Değişikliklerin tam olarak yansıması için uygulamayı yeniden başlatmanız önerilir.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'Geri yükleme sırasında hata oluştu: $error';
  }

  @override
  String get backupScreenTitle => 'Yedekle & Geri Yükle';

  @override
  String get backupBlockedExitWarningMessage =>
      'İşlem sürüyor, lütfen tamamlanmasını bekleyin.';

  @override
  String get backupBusyBackTooltip => 'İşlem sürüyor';

  @override
  String get backupIntroText =>
      'Notlarınızı, kategorilerinizi, ayarlarınızı ve eklerinizi tek bir .zip dosyası olarak yedekleyebilir veya daha önce aldığınız bir yedeği geri yükleyebilirsiniz.';

  @override
  String get backupDriveCardTitle => 'Google Drive\'a Yedekle';

  @override
  String get backupDriveCardSubtitle =>
      'Yeni bir yedek oluşturup doğrudan Google Drive\'ınızın gizli alanına yükleyin.';

  @override
  String get backupDriveCardButtonLabel => 'Drive\'a Yedekle';

  @override
  String get backupDeviceCardTitle => 'Cihaza Yedekle';

  @override
  String get backupDeviceCardSubtitle =>
      'Tüm verilerinizi tek bir .zip dosyası olarak cihaza kaydedin ve isterseniz paylaşın.';

  @override
  String get backupDeviceCardButtonLabel => 'Cihaza Yedekle';

  @override
  String get backupHistoryCardTitle => 'Yedek Geçmişi';

  @override
  String get backupHistoryCardSubtitle =>
      'Cihazda kayıtlı tüm yedekleri tarih ve boyutlarıyla görüntüleyin; buradan doğrudan paylaşabilir, geri yükleyebilir veya silebilirsiniz.';

  @override
  String get backupHistoryTabDevice => 'Cihaz';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'Yedeği Sil';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return '\"$fileName\" adlı yedek dosyasını kalıcı olarak silmek istediğinize emin misiniz? Bu işlem geri alınamaz.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'Yedek silindi.';

  @override
  String get backupHistoryDriveDeleteDialogTitle => 'Drive Yedeğini Sil';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return '\"$fileName\" adlı yedeği Google Drive\'dan kalıcı olarak silmek istediğinize emin misiniz? Bu işlem geri alınamaz ve dosya çöp kutusuna taşınmaz.';
  }

  @override
  String get backupHistoryDriveDeletedMessage => 'Drive yedeği silindi.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'Silinemedi: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'Henüz cihazda kayıtlı bir yedek yok.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      '\"Yedek Oluştur\" ile ilk yedeğinizi alabilirsiniz.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      '\"Google Drive\'a Yedekle\" ile ilk bulut yedeğinizi oluşturabilirsiniz.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Drive yedeklerinizi görmek için Google hesabınızla bağlanın.';

  @override
  String get backupHistoryConnectGoogleButton => 'Google ile Bağlan';

  @override
  String get backupHistoryDriveConnectedFallback => 'Bağlı';

  @override
  String get backupHistoryUnknownErrorFallback => 'Bilinmeyen bir hata oluştu.';

  @override
  String get backupHistoryDownloadStartingLabel => 'Başlıyor...';

  @override
  String get backupAutoBackupEnabledLabel => 'Otomatik Yedekleme: açık';

  @override
  String get backupAutoBackupDisabledLabel => 'Otomatik Yedekleme: kapalı';

  @override
  String get backupOverlayWarningMessage =>
      'Lütfen bekleyin, işlem tamamlanmadan uygulamadan çıkmayın.';

  @override
  String get pdfExportUntitledNoteLabel => 'Başlıksız Not';

  @override
  String get pdfExportDefaultAttachmentName => 'Ek dosya';

  @override
  String get pdfExportDefaultFileName => 'not';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'Ekran görüntüsü alınamadı (boundary bulunamadı)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'Ekran görüntüsü verisi oluşturulamadı';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'Görüntü işlenemedi (PNG çözümlenemedi)';

  @override
  String get screenshotCalcTableTotalLabel => 'Toplam';

  @override
  String get gundemMenuRemoveFromAgenda => 'Gündemden kaldır';

  @override
  String get gundemMenuDeleteNote => 'Notu sil';

  @override
  String get gundemSectionOverdue => 'Gecikmiş';

  @override
  String get gundemSectionToday => 'Bugün';

  @override
  String get gundemSectionTomorrow => 'Yarın';

  @override
  String get gundemSectionNextWeek => 'Gelecek Hafta';

  @override
  String get gundemSectionFurther => 'Daha İleri';

  @override
  String get gundemWeekdayMonday => 'Pazartesi';

  @override
  String get gundemWeekdayTuesday => 'Salı';

  @override
  String get gundemWeekdayWednesday => 'Çarşamba';

  @override
  String get gundemWeekdayThursday => 'Perşembe';

  @override
  String get gundemWeekdayFriday => 'Cuma';

  @override
  String get gundemWeekdaySaturday => 'Cumartesi';

  @override
  String get gundemWeekdaySunday => 'Pazar';

  @override
  String get gundemAppBarTitle => 'Ajanda';

  @override
  String get gundemCalendarTooltip => 'Takvim';

  @override
  String get gundemEmptyTitle => 'Ajandanda bir şey yok';

  @override
  String get gundemEmptySubtitle =>
      'Hatırlatıcı eklediğin veya tarih atadığın notlar burada listelenir.';

  @override
  String get gundemUntitledNote => 'Adsız not';

  @override
  String get gundemRepeatHourly => 'Her saat';

  @override
  String get gundemRepeatDaily => 'Her gün';

  @override
  String get gundemRepeatWeekly => 'Her hafta';

  @override
  String get gundemRepeatMonthly => 'Her ay';

  @override
  String get gundemRepeatYearly => 'Her yıl';

  @override
  String get gundemPreviewCalcTableLabel => '[Hesap Listesi]';

  @override
  String get gundemPreviewDrawingLabel => '[Çizim]';

  @override
  String get gundemPreviewImageLabel => '[Görsel]';

  @override
  String get gundemMonthShortJan => 'Oca';

  @override
  String get gundemMonthShortFeb => 'Şub';

  @override
  String get gundemMonthShortMar => 'Mar';

  @override
  String get gundemMonthShortApr => 'Nis';

  @override
  String get gundemMonthShortMay => 'May';

  @override
  String get gundemMonthShortJun => 'Haz';

  @override
  String get gundemMonthShortJul => 'Tem';

  @override
  String get gundemMonthShortAug => 'Ağu';

  @override
  String get gundemMonthShortSep => 'Eyl';

  @override
  String get gundemMonthShortOct => 'Eki';

  @override
  String get gundemMonthShortNov => 'Kas';

  @override
  String get gundemMonthShortDec => 'Ara';

  @override
  String get calendarAppBarTitle => 'Takvim';

  @override
  String get calendarTodayButton => 'Bugün';

  @override
  String get calendarLegendNoteLabel => 'Not';

  @override
  String get calendarLegendReminderLabel => 'Hatırlatıcı';

  @override
  String get calendarTodayBadge => 'Bugün';

  @override
  String get calendarEmptyDayMessage => 'Bu güne ait not veya hatırlatıcı yok.';

  @override
  String get calendarReminderHourlyLabel => 'Her saat';

  @override
  String get calendarMonthJan => 'Ocak';

  @override
  String get calendarMonthFeb => 'Şubat';

  @override
  String get calendarMonthMar => 'Mart';

  @override
  String get calendarMonthApr => 'Nisan';

  @override
  String get calendarMonthMay => 'Mayıs';

  @override
  String get calendarMonthJun => 'Haziran';

  @override
  String get calendarMonthJul => 'Temmuz';

  @override
  String get calendarMonthAug => 'Ağustos';

  @override
  String get calendarMonthSep => 'Eylül';

  @override
  String get calendarMonthOct => 'Ekim';

  @override
  String get calendarMonthNov => 'Kasım';

  @override
  String get calendarMonthDec => 'Aralık';

  @override
  String get calendarWeekdayShortMon => 'Pzt';

  @override
  String get calendarWeekdayShortTue => 'Sal';

  @override
  String get calendarWeekdayShortWed => 'Çar';

  @override
  String get calendarWeekdayShortThu => 'Per';

  @override
  String get calendarWeekdayShortFri => 'Cum';

  @override
  String get calendarWeekdayShortSat => 'Cmt';

  @override
  String get calendarWeekdayShortSun => 'Paz';

  @override
  String get calendarWeekdayFullMonday => 'Pazartesi';

  @override
  String get calendarWeekdayFullTuesday => 'Salı';

  @override
  String get calendarWeekdayFullWednesday => 'Çarşamba';

  @override
  String get calendarWeekdayFullThursday => 'Perşembe';

  @override
  String get calendarWeekdayFullFriday => 'Cuma';

  @override
  String get calendarWeekdayFullSaturday => 'Cumartesi';

  @override
  String get calendarWeekdayFullSunday => 'Pazar';

  @override
  String get wrongPasswordDialogTitle => 'Hatalı Parola';

  @override
  String get wrongPasswordDialogMessage => 'Girdiğiniz parola yanlış.';

  @override
  String get commonOkButton => 'Tamam';

  @override
  String get unlockCategoryAction => 'Kilidi Kaldır';

  @override
  String get lockCategoryAction => 'Kilitle';

  @override
  String get categoryUnlockedMessage => 'Kilit kaldırıldı';

  @override
  String get categoryLockedMessage => 'Klasör kilitlendi';

  @override
  String get deleteFolderMenuItemLabel => 'Klasörü Sil';

  @override
  String get deleteFolderDialogTitle => 'Klasörü Sil';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return '\"$category\" klasörünü ve içindeki tüm alt klasörleri silmek istediğinize emin misiniz? Bu klasörlerdeki notlar klasörsüz kalacak.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return '\"$category\" klasörünü silmek istediğinize emin misiniz? Bu klasördeki notlar klasörsüz kalacak.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'İptal';

  @override
  String get deleteFolderDialogConfirmButton => 'Sil';

  @override
  String get editCategoryNameColorMenuItemLabel => 'Adını Düzenle / Renk';

  @override
  String get addSubfolderMenuItemLabel => 'Alt Klasör Oluştur';

  @override
  String get expandSubfoldersMenuItemLabel => 'Alt Klasörleri Genişlet';

  @override
  String get collapseSubfoldersMenuItemLabel => 'Alt Klasörleri Daralt';

  @override
  String saveErrorInfoMessage(String error) {
    return 'Kayıt hatası: $error';
  }

  @override
  String get welcomeNoteTitle => 'Layout\'a Hoş Geldiniz! 🚀';

  @override
  String get welcomeNoteContent => 'Yeni özellikler eklendi!';

  @override
  String get noteListDateGroupToday => 'Bugün';

  @override
  String get noteListDateGroupYesterday => 'Dün';

  @override
  String get noteListDateGroupLast7Days => 'Son 7 Gün';

  @override
  String get noteListDateGroupLast30Days => 'Son 30 Gün';

  @override
  String get reminderRepeatNoneLabel => 'Tekrar yok';

  @override
  String get voiceRecorderPreparingLabel => 'Hazırlanıyor…';

  @override
  String get voiceRecorderCancelButton => 'İptal';

  @override
  String get voiceRecorderStopAddButton => 'Durdur ve Ekle';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'Mikrofon izni verilmedi.';

  @override
  String get speechToTextUnavailableMessage =>
      'Bu cihazda ses tanıma özelliği kullanılamıyor.';

  @override
  String get speechToTextPreparingLabel => 'Hazırlanıyor…';

  @override
  String get speechToTextListeningLabel => 'Dinleniyor…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'Konuşmaya başlayın…';

  @override
  String get speechToTextCancelButton => 'İptal';

  @override
  String get speechToTextStopAddButton => 'Durdur ve Ekle';

  @override
  String get textToSpeechNoContentMessage => 'Okunacak bir içerik yok.';

  @override
  String get textToSpeechReadErrorMessage => 'Okuma sırasında bir hata oluştu.';

  @override
  String get textToSpeechUnavailableMessage =>
      'Bu cihazda sesli okuma özelliği kullanılamıyor.';

  @override
  String get textToSpeechPreparingLabel => 'Hazırlanıyor…';

  @override
  String get textToSpeechPausedLabel => 'Duraklatıldı';

  @override
  String get textToSpeechFinishedLabel => 'Okuma tamamlandı';

  @override
  String get textToSpeechReadingLabel => 'Okunuyor…';

  @override
  String get textToSpeechCloseErrorButton => 'Kapat';

  @override
  String get textToSpeechReplayButton => 'Tekrar Oku';

  @override
  String get textToSpeechCloseFinishedButton => 'Kapat';

  @override
  String get textToSpeechPauseButton => 'Duraklat';

  @override
  String get textToSpeechResumeButton => 'Devam Et';

  @override
  String get textToSpeechStopButton => 'Durdur';

  @override
  String get textToSpeechSpeedSlow => 'Yavaş';

  @override
  String get textToSpeechSpeedNormal => 'Normal';

  @override
  String get textToSpeechSpeedFast => 'Hızlı';

  @override
  String get calendarPickerCancelButton => 'Vazgeç';

  @override
  String get calendarPickerConfirmButton => 'Seç';

  @override
  String get calendarPickerClearButton => 'İptal';

  @override
  String get reminderPickerDialogTitle => 'Hatırlatıcı ekle';

  @override
  String get reminderPickerDateTodayOption => 'Bugün';

  @override
  String get reminderPickerDateTomorrowOption => 'Yarın';

  @override
  String get reminderPickerDatePickOption => 'Tarih seç';

  @override
  String get reminderRepeatHourlyLabel => 'Her saat';

  @override
  String get reminderRepeatDailyLabel => 'Her gün';

  @override
  String get reminderRepeatWeeklyLabel => 'Her hafta';

  @override
  String get reminderRepeatMonthlyLabel => 'Her ay';

  @override
  String get reminderRepeatYearlyLabel => 'Her yıl';

  @override
  String get reminderPickerCalendarHelpText => 'Hatırlatma tarihi seç';

  @override
  String get reminderPickerCancelButton => 'İPTAL';

  @override
  String get reminderPickerSaveButton => 'KAYDET';

  @override
  String get reminderPickerPastTimeErrorMessage => 'Geçmiş bir zaman seçilemez';

  @override
  String calcTableTotalLabel(String amount) {
    return 'Toplam: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'Veriler hazırlanıyor...';

  @override
  String get backupCreatePackagingNotesLabel =>
      'Notlar ve kategoriler paketleniyor...';

  @override
  String get backupCreateReadingAttachmentsLabel => 'Ek dosyalar okunuyor...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'Ek dosyalar okunuyor... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'Zip dosyası sıkıştırılıyor...';

  @override
  String get backupCreateSavingFileLabel => 'Dosya kaydediliyor...';

  @override
  String get backupRestoreValidatingLabel => 'Yedek doğrulanıyor...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'Yedek doğrulandı, veriler hazırlanıyor...';

  @override
  String get backupRestoreWritingNotesLabel => 'Notlar yazılıyor...';

  @override
  String get backupRestoreWritingTrashLabel => 'Çöp kutusu yazılıyor...';

  @override
  String get backupRestoreTrashWrittenLabel => 'Çöp kutusu yazıldı';

  @override
  String get backupRestoreWritingCategoriesLabel => 'Kategoriler yazılıyor...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'Kategoriler yazıldı';

  @override
  String get backupRestoreWritingSettingsLabel => 'Ayarlar yazılıyor...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'Ayarlar yazıldı';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'Eski ek dosyalar temizleniyor...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'Ek dosya bulunmuyor, tamamlanıyor...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'Ekler geri yükleniyor... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'Tamamlandı';

  @override
  String get backupValidationCorruptedFileMessage =>
      'Dosya bozuk veya geçerli bir yedek dosyası değil.';

  @override
  String get backupValidationMissingDataMessage =>
      'Yedek dosyası içinde veri bulunamadı (backup_data.json eksik).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'Yedek verisi okunamadı (bozuk JSON).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'Bu dosya layout uygulamasına ait bir yedek değil.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'Yedek dosyasının sürüm bilgisi okunamadı.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'Bu yedek, uygulamanın şu anki sürümünün desteklemediği daha yeni bir formatta. Lütfen uygulamayı güncelleyin.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'Yedek dosyasının sürüm bilgisi geçersiz.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'Yedek verisi beklenen formatta değil (notlar alanı eksik).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'Yedek verisi beklenen formatta değil (çöp kutusu alanı eksik).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'Yedek verisi beklenen formatta değil (kategori listesi geçersiz).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'Yedek verisi beklenen formatta değil (ayarlar alanı geçersiz).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'Yedek verisi beklenen formatta değil (bir not kaydı geçersiz).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'Yedek verisi beklenen formatta değil (kimliksiz bir not kaydı bulundu).';

  @override
  String get backupValidationFileNotFoundMessage => 'Yedek dosyası bulunamadı.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'Cihazda yeterli boş depolama alanı yok. Lütfen yer açıp tekrar deneyin.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'Dosya erişim izni reddedildi. Lütfen uygulama izinlerini kontrol edip tekrar deneyin.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'Dosya işlemi sırasında bir hata oluştu: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'Beklenmeyen bir hata oluştu: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'Zip arşivi oluşturulamadı (ZipEncoder null döndürdü).';

  @override
  String get calcTableMenuItemLabel => 'Hesap Listesi';

  @override
  String get tagsMenuItemLabel => 'Etiketler';

  @override
  String get linkDialogUrlHint => 'https://ornek.com';

  @override
  String get checklistItemHint => 'Madde ekle...';

  @override
  String get toolbarHighlightTooltip => 'Vurgula';

  @override
  String get toolbarListTooltip => 'Liste';

  @override
  String get toolbarHideKeyboardTooltip => 'Klavyeyi Gizle';

  @override
  String get autoBackupLocalSuccessMessage => 'Yerel yedekleme başarılı.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'Yerel yedekleme başarısız: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Drive yedeklemesi atlandı: Google hesabı bağlı değil veya oturum süresi dolmuş. Lütfen uygulamayı açıp tekrar bağlanın.';

  @override
  String get autoBackupDriveSuccessMessage => 'Drive yedeklemesi başarılı.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Drive yedeklemesi başarısız: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'Henüz not yok';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'Toplam: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ Çizim';

  @override
  String get autoBackupSettingsAppBarTitle => 'Otomatik Yedekleme Ayarları';

  @override
  String get autoBackupSettingsMainSwitchTitle =>
      'Otomatik Yedeklemeyi Aktif Et';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'Notlarınız arka planda periyodik olarak güvenle yedeklenir.';

  @override
  String get autoBackupSettingsTargetTitle => 'Yedekleme Hedefi';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'Yedeklerin nereye kaydedileceğini seçin.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'Yerel';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'Her İkisi';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Google Drive seçeneklerini kullanmak için önce hesabınızı bağlayın.';

  @override
  String get autoBackupSettingsConnectButton => 'Bağlan';

  @override
  String get autoBackupSettingsFrequencyTitle => 'Yedekleme Sıklığı';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'Her $hours saatte bir yedek alınır.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 Saat';

  @override
  String get autoBackupSettingsFrequency12h => '12 Saat';

  @override
  String get autoBackupSettingsFrequency24h => '24 Saat (Günlük)';

  @override
  String get autoBackupSettingsFrequency48h => '48 Saat (2 Gün)';

  @override
  String get autoBackupSettingsFrequency168h => '168 Saat (Haftalık)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Sadece Wi-Fi Kullan';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'Bulut yüklemesi yalnızca Wi-Fi bağlıyken yapılır mobil veriniz korunur.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'Sistem Durumu';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'Henüz otomatik yedekleme çalışmadı.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'Son Çalışma: $date $time ($status)\nMesaj: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'Başarılı';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'Hatalı';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Google hesabına bağlanılamadı.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'Otomatik yedekleme ayarları güncellendi.';

  @override
  String selectionModeDeletedMessage(int count) {
    return '$count not silindi';
  }

  @override
  String get selectionModeArchivedMessage => 'Arşivlendi';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return '$count not için kategori seç';
  }

  @override
  String get selectionModeAddCategoryOption => 'Kategori Ekle';

  @override
  String get selectionModeRemoveCategoryOption => 'Kategoriyi Kaldır';

  @override
  String get calcTableItemHint => 'Kalem...';

  @override
  String get calcTableTotalRowLabel => 'Toplam';

  @override
  String get textSelectionMenuShareButton => 'Paylaş';

  @override
  String get textSelectionMenuTranslateButton => 'Çevir';

  @override
  String get textSelectionMenuShareFailedSnackbar => 'Paylaşım başlatılamadı.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar => 'Çeviri açılamadı.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'Bugün $time';
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
    return 'Son yedekleme: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage => 'Henüz hiç yedek alınmadı.';

  @override
  String get backupFileNameLabel => 'Yedek';
}
