// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'Tebal';

  @override
  String get toolbarItalicTooltip => 'Miring';

  @override
  String get toolbarUnderlineTooltip => 'Garis Bawah';

  @override
  String get toolbarStrikethroughTooltip => 'Coret';

  @override
  String get toolbarFontSizeTooltip => 'Ukuran Font';

  @override
  String get toolbarColorTooltip => 'Warna Teks';

  @override
  String get toolbarBulletTooltip => 'Daftar Poin';

  @override
  String get toolbarNumberTooltip => 'Daftar Bernomor';

  @override
  String get toolbarIndentTooltip => 'Indentasi Paragraf';

  @override
  String get toolbarLinkTooltip => 'Tambah / Edit / Hapus Tautan';

  @override
  String get toolbarDividerTooltip => 'Sisipkan Pembatas';

  @override
  String get toolbarChecklistTooltip => 'Tambah Daftar Periksa';

  @override
  String get linkSelectTextSnackbar => 'Pilih dulu teks yang ingin ditautkan';

  @override
  String get linkDialogEditTitle => 'Edit Tautan';

  @override
  String get linkDialogAddTitle => 'Tambah Tautan';

  @override
  String get linkDialogRemoveButton => 'Hapus Tautan';

  @override
  String get linkDialogCancelButton => 'Batal';

  @override
  String get linkDialogConfirmButton => 'Tambah';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Izin kamera ditolak. Anda perlu mengizinkannya dari pengaturan untuk merekam video.';

  @override
  String get cameraPermissionRequiredMessage =>
      'Izin kamera diperlukan untuk merekam video.';

  @override
  String get openSettingsButtonLabel => 'Pengaturan';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'Pemindaian tidak dapat dimulai: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'Pengenalan teks gagal: $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'Tidak ditemukan teks yang dapat dibaca pada dokumen';

  @override
  String get scanResultSheetTitle =>
      'Bagaimana dokumen yang dipindai akan ditambahkan?';

  @override
  String get scanResultTextOnlyOption => 'Tambahkan sebagai teks saja';

  @override
  String get scanResultTextAndImageOption =>
      'Tambahkan teks + gambar hasil pindai';

  @override
  String get scanResultCancelOption => 'Batal';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'Izin mikrofon ditolak. Anda perlu mengizinkannya dari pengaturan untuk merekam audio.';

  @override
  String get audioPermissionRequiredMessage =>
      'Izin mikrofon diperlukan untuk merekam audio.';

  @override
  String get voiceRecordingDefaultLabel => 'Rekaman Suara';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'Daftar Perhitungan ($count baris)';
  }

  @override
  String get blockPreviewDrawingLabel => 'Gambar';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count lampiran (foto/dokumen)';
  }

  @override
  String get blockPreviewDividerLabel => 'Pembatas';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'Daftar Periksa ($count item)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(teks kosong)';

  @override
  String get reorderBlocksSheetTitle => 'Urutkan Ulang Blok';

  @override
  String get reorderBlocksMoveUpTooltip => 'Pindah ke Atas';

  @override
  String get reorderBlocksMoveDownTooltip => 'Pindah ke Bawah';

  @override
  String get reorderBlocksCloseTooltip => 'Tutup';

  @override
  String get reorderBlocksDescription =>
      'Ketuk sebuah blok untuk memilihnya, lalu gunakan panah atas/bawah untuk memindahkannya.';

  @override
  String get reorderBlocksMenuItemLabel => 'Urutkan Ulang';

  @override
  String get txtImportPickerDialogTitle => 'Pilih file TXT yang akan diimpor';

  @override
  String get txtImportReadFailedMessage => 'File TXT tidak dapat dibaca';

  @override
  String get txtImportEmptyFileMessage => 'File TXT kosong';

  @override
  String get txtImportSuccessMessage => 'TXT berhasil diimpor';

  @override
  String get txtImportMenuItemLabel => 'Impor (txt)';

  @override
  String get exportMenuItemLabel => 'Ekspor';

  @override
  String get editorUndoTooltip => 'Urungkan';

  @override
  String get editorRedoTooltip => 'Ulangi';

  @override
  String get noteSavedMessage => 'Catatan disimpan';

  @override
  String get dateAssignPickerHelpText => 'Tetapkan catatan ke suatu hari';

  @override
  String get dateAssignChangeOption => 'Ubah tanggal';

  @override
  String get dateAssignRemoveOption => 'Hapus penetapan';

  @override
  String get editorSubToolbarCloseTooltip => 'Tutup';

  @override
  String get titleFieldHint => 'Judul';

  @override
  String get textBlockHint => 'Tulis catatan Anda di sini...';

  @override
  String get drawingBoardMenuItemLabel => 'Papan Gambar';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'Ucapan ke teks hanya tersedia untuk catatan teks';

  @override
  String get selectionModeCancelTooltip => 'Batalkan Pemilihan';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return '$count dipilih';
  }

  @override
  String get selectionModeDeleteTooltip => 'Hapus';

  @override
  String get selectionModeArchiveTooltip => 'Arsipkan';

  @override
  String get selectionModeFolderTooltip => 'Folder';

  @override
  String get searchFieldHint => 'Cari catatan...';

  @override
  String get emptyTrashDialogTitle => 'Kosongkan Sampah';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'Semua catatan yang dihapus akan dihapus permanen. Anda yakin?';

  @override
  String get emptyTrashDialogCancelButton => 'Batal';

  @override
  String get restoreAllMenuItemLabel => 'Pulihkan Semua';

  @override
  String get sortMenuTooltip => 'Urutkan Catatan';

  @override
  String get sortMenuAscendingLabel => 'Urutan: Naik (A-Z)';

  @override
  String get sortMenuDescendingLabel => 'Urutan: Turun (Z-A)';

  @override
  String get sortMenuByTitleLabel => 'Urutkan berdasarkan: Judul';

  @override
  String get sortMenuByModifiedDateLabel =>
      'Urutkan berdasarkan: Terakhir Diubah';

  @override
  String get sortMenuByCreatedDateLabel =>
      'Urutkan berdasarkan: Tanggal Dibuat';

  @override
  String get sortMenuByFolderLabel => 'Urutkan berdasarkan: Folder';

  @override
  String get viewToggleGridTooltip => 'Tampilan Kisi';

  @override
  String get viewToggleListTooltip => 'Tampilan Daftar';

  @override
  String get drawerHeaderSubtitle => 'Buku Catatan Pribadi Anda';

  @override
  String get drawerNotesSectionHeader => 'CATATAN';

  @override
  String get drawerAllNotesLabel => 'Catatan';

  @override
  String get drawerFavoritesLabel => 'Favorit';

  @override
  String get drawerAgendaLabel => 'Agenda';

  @override
  String get drawerRemindersLabel => 'Pengingat';

  @override
  String get drawerLockedLabel => 'Terkunci';

  @override
  String get drawerTrashLabel => 'Sampah';

  @override
  String get drawerFoldersSectionHeader => 'FOLDER';

  @override
  String get drawerExpandLabel => 'Perluas';

  @override
  String get drawerCollapseLabel => 'Ciutkan';

  @override
  String get drawerAddFolderLabel => 'Tambah Folder';

  @override
  String get drawerAppSectionHeader => 'APLIKASI';

  @override
  String get drawerCalendarLabel => 'Kalender';

  @override
  String get drawerSettingsLabel => 'Pengaturan';

  @override
  String get drawerBackupRestoreLabel => 'Cadangkan & Pulihkan';

  @override
  String get drawerUpgradeToProLabel => 'Tingkatkan ke Pro';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'Dukung Pengembangan';

  @override
  String get drawerFeedbackLabel => 'Masukan';

  @override
  String get drawerAboutLabel => 'Tentang';

  @override
  String get noNotesFoundMessage => 'Tidak ada catatan ditemukan.';

  @override
  String get trashRestoreButtonLabel => 'Pulihkan';

  @override
  String get trashPermanentDeleteButtonLabel => 'Hapus Permanen';

  @override
  String get tagRenamedInfoMessage => 'Tag diganti nama';

  @override
  String get tagDeletedInfoMessage => 'Tag dihapus';

  @override
  String get tagOptionsRenameLabel => 'Ganti Nama';

  @override
  String get tagOptionsDeleteLabel => 'Hapus';

  @override
  String get renameTagDialogTitle => 'Ganti Nama Tag';

  @override
  String get renameTagDialogHint => 'Nama tag baru';

  @override
  String get renameTagDialogCancelButton => 'Batal';

  @override
  String get renameTagDialogSaveButton => 'Simpan';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '\"$tag\" akan dihapus dari $affectedCount catatan. Lanjutkan?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'Hapus tag \"$tag\"?';
  }

  @override
  String get deleteTagDialogTitle => 'Hapus Tag';

  @override
  String get deleteTagDialogCancelButton => 'Batal';

  @override
  String get deleteTagDialogConfirmButton => 'Hapus';

  @override
  String get tagsSheetTitle => 'Tag';

  @override
  String get tagsSheetEmptyMessage => 'Belum ada tag pada catatan ini.';

  @override
  String get tagsSheetInputHint => 'Tulis tag baru...';

  @override
  String get tagsSheetSuggestionsLabel => 'Tag yang sudah ada';

  @override
  String get noteDeletedInfoMessage => 'Catatan dihapus';

  @override
  String get noteDeletedUndoActionLabel => 'Urungkan';

  @override
  String get reminderSetInfoMessage => 'Pengingat diatur';

  @override
  String get reminderRemovedInfoMessage => 'Pengingat dihapus';

  @override
  String get noteDuplicatedInfoMessage => 'Salinan dibuat';

  @override
  String get speechTextAppendedInfoMessage => 'Teks ditambahkan ke catatan';

  @override
  String get pdfPreparingInfoMessage => 'Menyiapkan PDF…';

  @override
  String get pdfSavedInfoMessage => 'PDF disimpan';

  @override
  String get jpgPreparingInfoMessage => 'Menyiapkan JPG…';

  @override
  String get jpgSavedInfoMessage => 'JPG disimpan';

  @override
  String get jpgFailedInfoMessage => 'Gagal membuat JPG';

  @override
  String get txtPreparingInfoMessage => 'Menyiapkan TXT…';

  @override
  String get txtSavedInfoMessage => 'TXT disimpan';

  @override
  String get txtFailedInfoMessage => 'Gagal membuat TXT';

  @override
  String get exportOpenActionLabel => 'Buka';

  @override
  String get wrongPasswordInfoMessage => 'Kata sandi salah.';

  @override
  String get noteArchivedInfoMessage => 'Catatan diarsipkan';

  @override
  String get noteUnarchivedInfoMessage => 'Dikeluarkan dari arsip';

  @override
  String get noteUnlockedInfoMessage => 'Dibuka kuncinya';

  @override
  String get noteLockedInfoMessage => 'Catatan dikunci';

  @override
  String get notificationUnpinnedInfoMessage => 'Lepas pin';

  @override
  String get emptyNotePinBlockedInfoMessage =>
      'Catatan kosong tidak dapat disematkan.';

  @override
  String get notificationPinnedInfoMessage => 'Disematkan ke panel notifikasi';

  @override
  String get noContentToReadInfoMessage => 'Tidak ada konten untuk dibacakan';

  @override
  String get backPressExitInfoMessage =>
      'Tekan kembali sekali lagi untuk keluar';

  @override
  String get reminderChannelName => 'Pengingat Catatan';

  @override
  String get reminderChannelDescription =>
      'Pengingat catatan di aplikasi Layout';

  @override
  String get pinnedChannelName => 'Catatan yang Disematkan';

  @override
  String get pinnedChannelDescription =>
      'Catatan Layout yang disematkan ke panel notifikasi';

  @override
  String get notificationUnpinActionLabel => 'Hapus';

  @override
  String get reminderDefaultTitle => 'Pengingat';

  @override
  String get reminderChecklistBodyFallback =>
      'Jangan lupa periksa daftar periksa Anda';

  @override
  String get reminderTextBodyFallback => 'Jangan lupa periksa catatan Anda';

  @override
  String get pdfSaveDialogTitle => 'Simpan sebagai PDF';

  @override
  String get jpgSaveDialogTitle => 'Simpan sebagai JPG';

  @override
  String get txtSaveDialogTitle => 'Simpan sebagai TXT';

  @override
  String get textSizeSheetTitle => 'Ukuran Teks';

  @override
  String get textSizeSamplePreview => 'Contoh teks';

  @override
  String get textSizeCancelButton => 'Batal';

  @override
  String get textSizeApplyButton => 'Terapkan';

  @override
  String get createPasswordDialogTitle => 'Buat Kata Sandi';

  @override
  String get createPasswordNewPasswordHint => 'Kata sandi baru';

  @override
  String get createPasswordConfirmHint => 'Masukkan ulang kata sandi';

  @override
  String get createPasswordHintQuestionDescription =>
      'Atur pertanyaan keamanan untuk berjaga-jaga jika Anda lupa kata sandi (opsional).';

  @override
  String get createPasswordHintQuestionHint => 'Pilih pertanyaan keamanan';

  @override
  String get createPasswordHintAnswerHint => 'Jawaban Anda';

  @override
  String get createPasswordCancelButton => 'Batal';

  @override
  String get createPasswordSaveButton => 'Simpan';

  @override
  String get passwordMismatchMessage => 'Kata sandi tidak cocok!';

  @override
  String get passwordRequiredDialogTitle => 'Kata Sandi Diperlukan';

  @override
  String get passwordRequiredHint => 'Masukkan kata sandi';

  @override
  String get forgotPasswordButtonLabel => 'Lupa kata sandi saya';

  @override
  String get passwordRequiredCancelButton => 'Batal';

  @override
  String get passwordRequiredConfirmButton => 'Verifikasi';

  @override
  String get securityQuestionDialogTitle => 'Pertanyaan Keamanan';

  @override
  String get securityQuestionAnswerHint => 'Jawaban Anda';

  @override
  String get securityQuestionCancelButton => 'Batal';

  @override
  String get securityQuestionConfirmButton => 'Konfirmasi';

  @override
  String get securityQuestionWrongAnswerMessage => 'Jawaban salah. Coba lagi.';

  @override
  String get revealedPasswordDialogTitle => 'Kata Sandi Anda';

  @override
  String get revealedPasswordLabel => 'Kata sandi catatan Anda:';

  @override
  String get revealedPasswordOkButton => 'OK';

  @override
  String get securityQuestionPetName =>
      'Siapa nama hewan peliharaan pertama Anda?';

  @override
  String get securityQuestionFavoriteTeacher => 'Siapa nama guru favorit Anda?';

  @override
  String get securityQuestionBirthCity => 'Di kota mana Anda lahir?';

  @override
  String get securityQuestionFavoriteFood => 'Apa makanan favorit Anda?';

  @override
  String get securityQuestionMotherMaidenName => 'Siapa nama gadis ibu Anda?';

  @override
  String get securityQuestionFirstSchool =>
      'Apa nama sekolah pertama yang Anda ikuti?';

  @override
  String get securityQuestionFavoriteColor => 'Apa warna favorit Anda?';

  @override
  String get editFolderDialogTitle => 'Edit Folder';

  @override
  String get newSubfolderDialogTitle => 'Subfolder Baru';

  @override
  String get addFolderDialogTitle => 'Tambah Folder';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'Akan dibuat di dalam \"$parentCategory\"';
  }

  @override
  String get subfolderNameFieldLabel => 'Nama subfolder';

  @override
  String get folderNameFieldLabel => 'Nama folder';

  @override
  String get folderColorLabel => 'Warna';

  @override
  String get folderDialogCancelButton => 'Batal';

  @override
  String get folderDialogSaveButton => 'Simpan';

  @override
  String get folderDialogAddButton => 'Tambah';

  @override
  String get selectFolderSheetTitle => 'Pilih Folder';

  @override
  String get selectFolderAddOptionLabel => 'Tambah Folder';

  @override
  String get removeCurrentFolderLabel => 'Hapus Folder Saat Ini';

  @override
  String get noteDetailsDialogTitle => 'Detail';

  @override
  String get noteDetailsCreatedLabel => 'Dibuat';

  @override
  String get noteDetailsModifiedLabel => 'Terakhir Diubah';

  @override
  String get noteDetailsCharCountLabel => 'Jumlah Karakter';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count karakter';
  }

  @override
  String get noteDetailsWordCountLabel => 'Jumlah Kata';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count kata';
  }

  @override
  String get noteDetailsOkButton => 'OK';

  @override
  String get noteDetailsUnknownDateLabel => 'Tidak diketahui';

  @override
  String get addAttachmentSheetTitle => 'Tambah';

  @override
  String get addAttachmentImageOption => 'Tambah Gambar';

  @override
  String get addAttachmentCameraOption => 'Kamera';

  @override
  String get addAttachmentFileOption => 'Tambah File';

  @override
  String get addAttachmentVoiceOption => 'Rekaman Suara';

  @override
  String get addAttachmentVideoOption => 'Rekam Video';

  @override
  String get addAttachmentScanOption => 'Pindai Dokumen';

  @override
  String get noteActionsSheetTitle => 'Pilih Tindakan';

  @override
  String get noteActionReminderLabel => 'Pengingat';

  @override
  String get noteActionEditReminderLabel => 'Edit Pengingat';

  @override
  String get noteActionSpeechToTextLabel => 'Ucapan ke Teks';

  @override
  String get noteActionArchiveLabel => 'Arsipkan';

  @override
  String get noteActionUnarchiveLabel => 'Keluarkan dari Arsip';

  @override
  String get noteActionLockLabel => 'Kunci';

  @override
  String get noteActionUnlockLabel => 'Buka Kunci';

  @override
  String get noteActionFavoriteLabel => 'Favorit';

  @override
  String get noteActionUnfavoriteLabel => 'Hapus dari Favorit';

  @override
  String get noteActionClassifyLabel => 'Pilih Folder';

  @override
  String get noteActionDeleteLabel => 'Hapus';

  @override
  String get noteActionPinToNotificationLabel => 'Sematkan ke Panel Notifikasi';

  @override
  String get noteActionUnpinFromNotificationLabel => 'Lepas Sematan';

  @override
  String get noteActionShareLabel => 'Bagikan';

  @override
  String get noteActionDuplicateLabel => 'Buat Salinan';

  @override
  String get noteActionCopyContentLabel => 'Salin Konten';

  @override
  String get noteActionTtsLabel => 'Bacakan';

  @override
  String get noteActionTextSizeLabel => 'Ukuran Teks';

  @override
  String get noteActionDetailsLabel => 'Detail';

  @override
  String get noteActionDiscardChangesLabel => 'Buang Perubahan';

  @override
  String get noteActionSelectLabel => 'Pilih';

  @override
  String get reminderEditOptionLabel => 'Ubah pengingat';

  @override
  String get reminderRemoveOptionLabel => 'Hapus pengingat';

  @override
  String get discardChangesDialogTitle => 'Buang Perubahan';

  @override
  String get discardChangesDialogMessage =>
      'Perubahan yang belum disimpan pada catatan ini akan hilang. Anda yakin ingin membuangnya?';

  @override
  String get discardChangesCancelButton => 'Batal';

  @override
  String get discardChangesConfirmButton => 'Buang';

  @override
  String get pinnedNotificationDefaultTitle => 'Catatan';

  @override
  String get pdfFailedInfoMessage => 'Gagal membuat PDF';

  @override
  String get drawingScreenTitle => 'Gambar';

  @override
  String get drawingMinimizeTooltip => 'Kecilkan';

  @override
  String get drawingEmptyExportWarningMessage =>
      'Gambar sesuatu terlebih dahulu';

  @override
  String get drawingEraserPartialModeLabel => 'Sebagian';

  @override
  String get drawingEraserFullModeLabel => 'Penuh';

  @override
  String get drawingClearTooltip => 'Bersihkan';

  @override
  String get drawingZoomOutTooltip => 'Perkecil';

  @override
  String get drawingZoomInTooltip => 'Perbesar';

  @override
  String get drawingDeleteTooltip => 'Hapus';

  @override
  String get drawingEmptyPreviewHint => 'Ketuk untuk menggambar';

  @override
  String get settingsPageTitle => 'Pengaturan';

  @override
  String get settingsSectionGeneral => 'Umum';

  @override
  String get settingsSectionSecurity => 'Keamanan';

  @override
  String get settingsSectionTheme => 'Tema';

  @override
  String get settingsSectionPersonalization => 'Personalisasi';

  @override
  String get settingsSectionWidget => 'Widget';

  @override
  String get settingsSectionAbout => 'Tentang';

  @override
  String get settingsHintQuestionPet =>
      'Siapa nama hewan peliharaan pertama Anda?';

  @override
  String get settingsHintQuestionTeacher => 'Siapa nama guru favorit Anda?';

  @override
  String get settingsHintQuestionBirthCity => 'Di kota mana Anda lahir?';

  @override
  String get settingsHintQuestionFavoriteFood => 'Apa makanan favorit Anda?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'Siapa nama gadis ibu Anda?';

  @override
  String get settingsHintQuestionFirstSchool =>
      'Apa sekolah pertama yang Anda ikuti?';

  @override
  String get settingsHintQuestionFavoriteColor => 'Apa warna favorit Anda?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'Pertanyaan Keamanan';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'Jika Anda lupa kata sandi, Anda dapat memulihkannya dengan menjawab pertanyaan ini dengan benar.';

  @override
  String get settingsSecurityQuestionDropdownHint =>
      'Pilih pertanyaan keamanan';

  @override
  String get settingsSecurityQuestionAnswerHint => 'Jawaban Anda';

  @override
  String get settingsSecurityQuestionCancelButton => 'Batal';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'Pertanyaan dan jawaban tidak boleh kosong!';

  @override
  String get settingsSecurityQuestionSaveButton => 'Simpan';

  @override
  String get settingsCreatePasswordTitle => 'Buat Kata Sandi';

  @override
  String get settingsPasswordRequiredTitle => 'Kata Sandi Diperlukan';

  @override
  String get settingsPasswordEnterHint => 'Masukkan kata sandi';

  @override
  String get settingsForgotPasswordButton => 'Lupa kata sandi saya';

  @override
  String get settingsNewPasswordHint => 'Kata sandi baru';

  @override
  String get settingsConfirmPasswordHint => 'Masukkan ulang kata sandi';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'Atur pertanyaan keamanan untuk berjaga-jaga jika Anda lupa kata sandi (opsional).';

  @override
  String get settingsPasswordDialogCancelButton => 'Batal';

  @override
  String get settingsPasswordMismatchWarning => 'Kata sandi tidak cocok!';

  @override
  String get settingsWrongPasswordWarning => 'Kata sandi salah!';

  @override
  String get settingsPasswordSaveButton => 'Simpan';

  @override
  String get settingsPasswordRemoveButton => 'Hapus';

  @override
  String get settingsNotePasswordTitle => 'Kata Sandi Catatan';

  @override
  String get settingsPasswordSetSubtitle => 'Kata sandi diatur ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'Kata sandi belum diatur';

  @override
  String get settingsSecurityQuestionTileTitle => 'Pertanyaan Keamanan';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'Diatur ✓ — digunakan jika Anda lupa kata sandi';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'Belum diatur — Anda tidak akan bisa memulihkan kata sandi jika hilang';

  @override
  String get settingsThemeDialogTitle => 'Pilih Tema';

  @override
  String get settingsThemeSystemDefault => 'Default Sistem';

  @override
  String get settingsThemeLightOption => 'Tema Terang';

  @override
  String get settingsThemeDarkOption => 'Tema Gelap';

  @override
  String get settingsLanguageDialogTitle => 'Pilih Bahasa';

  @override
  String get settingsLanguageSystemOption => 'Sistem';

  @override
  String get settingsAccentColorDialogTitle => 'Pilih Warna Aksen';

  @override
  String get settingsThemeChangeTileTitle => 'Ubah Tema';

  @override
  String get settingsThemeLightLabel => 'Terang';

  @override
  String get settingsThemeDarkLabel => 'Gelap';

  @override
  String get settingsThemeSystemLabel => 'Sistem';

  @override
  String get settingsLanguageTileTitle => 'Bahasa';

  @override
  String get settingsAccentColorTileTitle => 'Warna Aksen';

  @override
  String get settingsAccentColorTileSubtitle =>
      'Warna yang digunakan pada bilah aplikasi, tombol, dan sakelar';

  @override
  String get settingsColorfulNotesTitle => 'Warna Catatan Beragam';

  @override
  String get settingsColorfulNotesSubtitle =>
      'Setiap kartu catatan mendapat corak warna yang berbeda.';

  @override
  String get settingsTextColorSheetTitle => 'Warna Teks';

  @override
  String get settingsTextColorSheetDesc =>
      'Menetapkan warna teks konten catatan.';

  @override
  String get settingsTextColorOkButton => 'OK';

  @override
  String get settingsTextColorTileTitle => 'Warna Teks';

  @override
  String get settingsTextColorTileSubtitle =>
      'Warna untuk teks konten catatan.';

  @override
  String get settingsWidgetFontSizeLabel => 'Ukuran Font Widget';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'Contoh judul - $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'Batal';

  @override
  String get settingsWidgetFontSizeApplyButton => 'Terapkan';

  @override
  String get settingsWidgetOpacityLabel => 'Transparansi Latar Belakang';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return 'Transparansi $percent%';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'Batal';

  @override
  String get settingsWidgetOpacityApplyButton => 'Terapkan';

  @override
  String get settingsWidgetDarkModeTitle => 'Widget Gelap';

  @override
  String get settingsWidgetDarkModeDesc => 'Skema warna gelap untuk widget.';

  @override
  String get settingsAboutVersionTitle => 'Versi Aplikasi';

  @override
  String get settingsFontFamilyTileTitle => 'Font';

  @override
  String get settingsFontFamilyDefaultLabel => 'Default';

  @override
  String get settingsGlobalFontSizeTileTitle => 'Ukuran Font';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt — diterapkan ke semua catatan.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'Contoh teks - $size pt';
  }

  @override
  String get settingsGlobalFontSizeApplyToAllLabel =>
      'Terapkan ke catatan yang ada';

  @override
  String get settingsGlobalFontSizeApplyToAllNote =>
      'Jika sebuah catatan memiliki ukuran font tersendiri, pengaturan ini tidak akan memengaruhinya.';

  @override
  String get settingsGlobalFontSizeCancelButton => 'Batal';

  @override
  String get settingsGlobalFontSizeApplyButton => 'Terapkan';

  @override
  String get settingsPreviewLinesTileTitle => 'Baris Pratinjau Catatan';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'Tampilkan hingga $lines baris. Jika catatan lebih pendek, jumlah baris sebenarnya yang ditampilkan.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'Saat ini: $lines baris';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'Menetapkan jumlah maksimum baris untuk pratinjau. Jika catatan memiliki lebih sedikit baris, jumlah baris sebenarnya yang ditampilkan.';

  @override
  String get settingsPreviewLinesCancelButton => 'Batal';

  @override
  String get settingsPreviewLinesApplyButton => 'Terapkan';

  @override
  String get backupCancelButton => 'Batal';

  @override
  String get backupConnectButton => 'Hubungkan';

  @override
  String get backupDisconnectButton => 'Putuskan';

  @override
  String get backupContinueButton => 'Lanjutkan';

  @override
  String get backupCloseButton => 'Tutup';

  @override
  String get backupShareButton => 'Bagikan';

  @override
  String get backupRestoreButton => 'Pulihkan';

  @override
  String get backupConfigureButton => 'Konfigurasi';

  @override
  String get backupUnknownDateLabel => 'Tidak diketahui';

  @override
  String get backupProcessingDefaultLabel => 'Memproses...';

  @override
  String get backupPermissionRequiredTitle => 'Izin Penyimpanan Diperlukan';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'Versi Android ini memerlukan izin penyimpanan untuk cadangkan/pulihkan. Karena izin ditolak secara permanen, silakan aktifkan secara manual dari pengaturan aplikasi.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'Versi Android ini memerlukan izin penyimpanan untuk cadangkan/pulihkan. Silakan berikan izin untuk melanjutkan.';

  @override
  String get backupGoToSettingsButton => 'Buka Pengaturan';

  @override
  String get backupRetryButton => 'Coba Lagi';

  @override
  String get backupDriveConnectingLabel => 'Menghubungkan ke akun Google...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Terhubung ke akun Google Drive: $email';
  }

  @override
  String get backupDriveConnectedMessage => 'Terhubung ke akun Google Drive.';

  @override
  String get backupDriveConnectFailedMessage =>
      'Tidak dapat terhubung ke akun Google, atau operasi dibatalkan.';

  @override
  String get backupDriveDisconnectTitle => 'Putuskan Google Drive';

  @override
  String get backupDriveDisconnectBody =>
      'Jika Anda memutuskan sambungan, cadangan manual atau otomatis ke Drive tidak akan mungkin dilakukan. Cadangan yang sudah tersimpan di Drive tidak akan dihapus — hanya akses dari perangkat ini yang akan dihapus.';

  @override
  String get backupDriveDisconnectedMessage => 'Koneksi Google Drive dihapus.';

  @override
  String get backupDriveRequiredTitle => 'Akun Google Diperlukan';

  @override
  String get backupDriveRequiredBody =>
      'Tindakan ini mengharuskan Anda menghubungkan akun Google. Ingin menghubungkan sekarang?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: terhubung ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: terhubung';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: tidak terhubung';

  @override
  String get backupDriveAuthenticatingLabel => 'Memverifikasi akun Google...';

  @override
  String get backupDriveNotSignedInMessage =>
      'Anda belum terhubung ke Google Drive. Silakan masuk dengan akun Google Anda terlebih dahulu.';

  @override
  String get backupDriveUploadingLabel => 'Mengunggah cadangan ke Drive...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Unggah ke Google Drive tidak selesai dalam 120 detik (tidak ada respons dari server). Periksa koneksi Anda dan coba lagi.';

  @override
  String get backupDriveOperationCompletedLabel => 'Selesai';

  @override
  String get backupToDriveActionLabel => 'cadangkan ke Drive';

  @override
  String get backupToDeviceActionLabel => 'cadangkan';

  @override
  String get backupCreatingLabel => 'Membuat cadangan...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'Cadangan tidak dapat dibuat: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Unggah ke Google Drive gagal: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'Cadangan berhasil diunggah ke Google Drive.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'Cadangan dibuat: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'Cadangan Siap';

  @override
  String get backupOfferShareBody =>
      'File cadangan Anda telah disimpan ke perangkat Anda. Ingin membagikannya sekarang (mis. penyimpanan cloud, email, perangkat lain)?';

  @override
  String get backupShareFileText => 'file cadangan layout';

  @override
  String backupShareFailedMessage(String error) {
    return 'Berbagi tidak dapat dimulai: $error';
  }

  @override
  String get backupLargeOperationTitle => 'Cadangan Besar';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'Data yang akan diproses berukuran sekitar $sizeText. $actionLabel dengan ukuran ini mungkin memerlukan waktu tergantung perangkat Anda. Jangan tinggalkan aplikasi selama proses berlangsung — ingin melanjutkan?';
  }

  @override
  String get backupRestoreActionLabel => 'pemulihan';

  @override
  String get backupDriveListingLabel => 'Membuat daftar cadangan Drive...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'Cadangan tidak dapat didaftar: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'Belum ada cadangan di Google Drive.';

  @override
  String get backupDrivePickTitle => 'Pilih Cadangan dari Drive';

  @override
  String get backupDriveDownloadingLabel => 'Mengunduh cadangan dari Drive...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Mengunduh cadangan dari Drive... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel => 'Menyimpan file ke perangkat...';

  @override
  String get backupDriveUnknownBackupFileName => 'unknown_backup.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Penyimpanan Google Drive Anda penuh. Silakan kosongkan ruang di Drive dan coba lagi.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'Tidak dapat membuat koneksi internet. Periksa koneksi Anda dan coba lagi.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'File cadangan yang ditentukan tidak ditemukan di Drive. Mungkin telah dihapus.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Terjadi kesalahan tak terduga selama operasi Google Drive: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'Pengunduhan gagal: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'File tidak dapat dipilih: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'File yang dipilih tidak dapat diakses.';

  @override
  String get backupCheckingLabel => 'Memeriksa cadangan...';

  @override
  String backupReadFailedMessage(String error) {
    return 'File cadangan tidak dapat dibaca: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'Pulihkan Cadangan';

  @override
  String get backupPreviewContentsHeader => 'Isi cadangan yang dipilih:';

  @override
  String get backupPreviewNoteCountLabel => 'Jumlah catatan';

  @override
  String get backupPreviewTrashCountLabel => 'Catatan di sampah';

  @override
  String get backupPreviewCategoryCountLabel => 'Jumlah kategori';

  @override
  String get backupPreviewAttachmentLabel => 'Lampiran';

  @override
  String get backupPreviewAttachmentNoneValue => 'Tidak ada';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count file ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'Dibuat pada';

  @override
  String get backupEmptyPreviewTitle => 'Cadangan ini tampak kosong';

  @override
  String get backupEmptyPreviewBody =>
      'Tidak ditemukan catatan, kategori, atau lampiran di file yang dipilih. Jika Anda melanjutkan, data Anda saat ini tetap akan dihapus dan diganti dengan cadangan kosong ini.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '$count lampiran tidak ditemukan dalam cadangan';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'Catatan dengan file ini akan dipulihkan, tetapi tanpa lampirannya (mungkin hilang atau rusak saat cadangan dibuat): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown dan $remaining lainnya';
  }

  @override
  String get backupRestoreConfirmBody =>
      'Ini akan MENGGANTI semua catatan, sampah, kategori, pengaturan, dan lampiran Anda saat ini dengan data dari cadangan di atas. Data Anda saat ini akan hilang secara permanen dan tindakan ini tidak dapat dibatalkan.';

  @override
  String get backupRestoringLabel => 'Memulihkan cadangan...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'Cadangan berhasil dipulihkan. Namun, $count lampiran tidak ditemukan dalam cadangan dan tidak dapat dipulihkan. Disarankan untuk memulai ulang aplikasi agar perubahan berlaku sepenuhnya.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'Cadangan berhasil dipulihkan. Disarankan untuk memulai ulang aplikasi agar perubahan berlaku sepenuhnya.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'Terjadi kesalahan saat memulihkan: $error';
  }

  @override
  String get backupScreenTitle => 'Cadangkan & Pulihkan';

  @override
  String get backupBlockedExitWarningMessage =>
      'Sebuah operasi sedang berlangsung, mohon tunggu hingga selesai.';

  @override
  String get backupBusyBackTooltip => 'Operasi sedang berlangsung';

  @override
  String get backupIntroText =>
      'Anda dapat mencadangkan catatan, kategori, pengaturan, dan lampiran Anda sebagai satu file .zip, atau memulihkan cadangan yang Anda buat sebelumnya.';

  @override
  String get backupDriveCardTitle => 'Cadangkan ke Google Drive';

  @override
  String get backupDriveCardSubtitle =>
      'Buat cadangan baru dan unggah langsung ke area privat Google Drive Anda.';

  @override
  String get backupDriveCardButtonLabel => 'Cadangkan ke Drive';

  @override
  String get backupDeviceCardTitle => 'Cadangkan ke Perangkat';

  @override
  String get backupDeviceCardSubtitle =>
      'Simpan semua data Anda sebagai satu file .zip ke perangkat Anda dan bagikan jika Anda mau.';

  @override
  String get backupDeviceCardButtonLabel => 'Cadangkan ke Perangkat';

  @override
  String get backupHistoryCardTitle => 'Riwayat Cadangan';

  @override
  String get backupHistoryCardSubtitle =>
      'Lihat semua cadangan yang tersimpan di perangkat Anda beserta tanggal dan ukurannya; Anda dapat membagikan, memulihkan, atau menghapusnya langsung dari sini.';

  @override
  String get backupHistoryTabDevice => 'Perangkat';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'Hapus Cadangan';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'Anda yakin ingin menghapus permanen file cadangan \"$fileName\"? Tindakan ini tidak dapat dibatalkan.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'Cadangan dihapus.';

  @override
  String get backupHistoryDriveDeleteDialogTitle => 'Hapus Cadangan Drive';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'Anda yakin ingin menghapus permanen cadangan \"$fileName\" dari Google Drive? Tindakan ini tidak dapat dibatalkan dan file tidak akan dipindahkan ke sampah.';
  }

  @override
  String get backupHistoryDriveDeletedMessage => 'Cadangan Drive dihapus.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'Tidak dapat menghapus: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'Belum ada cadangan tersimpan di perangkat ini.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'Gunakan \"Cadangkan ke Perangkat\" untuk membuat cadangan pertama Anda.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'Gunakan \"Cadangkan ke Google Drive\" untuk membuat cadangan cloud pertama Anda.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Hubungkan akun Google Anda untuk melihat cadangan Drive Anda.';

  @override
  String get backupHistoryConnectGoogleButton => 'Hubungkan dengan Google';

  @override
  String get backupHistoryDriveConnectedFallback => 'Terhubung';

  @override
  String get backupHistoryUnknownErrorFallback =>
      'Terjadi kesalahan yang tidak diketahui.';

  @override
  String get backupHistoryDownloadStartingLabel => 'Memulai...';

  @override
  String get backupAutoBackupEnabledLabel => 'Cadangan Otomatis: aktif';

  @override
  String get backupAutoBackupDisabledLabel => 'Cadangan Otomatis: nonaktif';

  @override
  String get backupOverlayWarningMessage =>
      'Mohon tunggu, jangan tinggalkan aplikasi hingga operasi selesai.';

  @override
  String get pdfExportUntitledNoteLabel => 'Catatan Tanpa Judul';

  @override
  String get pdfExportDefaultAttachmentName => 'Lampiran';

  @override
  String get pdfExportDefaultFileName => 'catatan';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'Tangkapan layar tidak dapat diambil (batas tidak ditemukan)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'Data tangkapan layar tidak dapat dibuat';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'Gambar tidak dapat diproses (dekode PNG gagal)';

  @override
  String get screenshotCalcTableTotalLabel => 'Total';

  @override
  String get gundemMenuRemoveFromAgenda => 'Hapus dari agenda';

  @override
  String get gundemMenuDeleteNote => 'Hapus catatan';

  @override
  String get gundemSectionOverdue => 'Terlambat';

  @override
  String get gundemSectionToday => 'Hari Ini';

  @override
  String get gundemSectionTomorrow => 'Besok';

  @override
  String get gundemSectionNextWeek => 'Minggu Depan';

  @override
  String get gundemSectionFurther => 'Selanjutnya';

  @override
  String get gundemWeekdayMonday => 'Senin';

  @override
  String get gundemWeekdayTuesday => 'Selasa';

  @override
  String get gundemWeekdayWednesday => 'Rabu';

  @override
  String get gundemWeekdayThursday => 'Kamis';

  @override
  String get gundemWeekdayFriday => 'Jumat';

  @override
  String get gundemWeekdaySaturday => 'Sabtu';

  @override
  String get gundemWeekdaySunday => 'Minggu';

  @override
  String get gundemAppBarTitle => 'Agenda';

  @override
  String get gundemCalendarTooltip => 'Kalender';

  @override
  String get gundemEmptyTitle => 'Tidak ada agenda';

  @override
  String get gundemEmptySubtitle =>
      'Catatan dengan pengingat atau tanggal yang ditetapkan akan muncul di sini.';

  @override
  String get gundemUntitledNote => 'Catatan tanpa judul';

  @override
  String get gundemRepeatHourly => 'Setiap Jam';

  @override
  String get gundemRepeatDaily => 'Harian';

  @override
  String get gundemRepeatWeekly => 'Mingguan';

  @override
  String get gundemRepeatMonthly => 'Bulanan';

  @override
  String get gundemRepeatYearly => 'Tahunan';

  @override
  String get gundemPreviewCalcTableLabel => '[Daftar Perhitungan]';

  @override
  String get gundemPreviewDrawingLabel => '[Gambar]';

  @override
  String get gundemPreviewImageLabel => '[Gambar]';

  @override
  String get gundemMonthShortJan => 'Jan';

  @override
  String get gundemMonthShortFeb => 'Feb';

  @override
  String get gundemMonthShortMar => 'Mar';

  @override
  String get gundemMonthShortApr => 'Apr';

  @override
  String get gundemMonthShortMay => 'Mei';

  @override
  String get gundemMonthShortJun => 'Jun';

  @override
  String get gundemMonthShortJul => 'Jul';

  @override
  String get gundemMonthShortAug => 'Agu';

  @override
  String get gundemMonthShortSep => 'Sep';

  @override
  String get gundemMonthShortOct => 'Okt';

  @override
  String get gundemMonthShortNov => 'Nov';

  @override
  String get gundemMonthShortDec => 'Des';

  @override
  String get calendarAppBarTitle => 'Kalender';

  @override
  String get calendarTodayButton => 'Hari Ini';

  @override
  String get calendarLegendNoteLabel => 'Catatan';

  @override
  String get calendarLegendReminderLabel => 'Pengingat';

  @override
  String get calendarTodayBadge => 'Hari Ini';

  @override
  String get calendarEmptyDayMessage =>
      'Tidak ada catatan atau pengingat untuk hari ini.';

  @override
  String get calendarReminderHourlyLabel => 'Setiap Jam';

  @override
  String get calendarMonthJan => 'Januari';

  @override
  String get calendarMonthFeb => 'Februari';

  @override
  String get calendarMonthMar => 'Maret';

  @override
  String get calendarMonthApr => 'April';

  @override
  String get calendarMonthMay => 'Mei';

  @override
  String get calendarMonthJun => 'Juni';

  @override
  String get calendarMonthJul => 'Juli';

  @override
  String get calendarMonthAug => 'Agustus';

  @override
  String get calendarMonthSep => 'September';

  @override
  String get calendarMonthOct => 'Oktober';

  @override
  String get calendarMonthNov => 'November';

  @override
  String get calendarMonthDec => 'Desember';

  @override
  String get calendarWeekdayShortMon => 'Sen';

  @override
  String get calendarWeekdayShortTue => 'Sel';

  @override
  String get calendarWeekdayShortWed => 'Rab';

  @override
  String get calendarWeekdayShortThu => 'Kam';

  @override
  String get calendarWeekdayShortFri => 'Jum';

  @override
  String get calendarWeekdayShortSat => 'Sab';

  @override
  String get calendarWeekdayShortSun => 'Min';

  @override
  String get calendarWeekdayFullMonday => 'Senin';

  @override
  String get calendarWeekdayFullTuesday => 'Selasa';

  @override
  String get calendarWeekdayFullWednesday => 'Rabu';

  @override
  String get calendarWeekdayFullThursday => 'Kamis';

  @override
  String get calendarWeekdayFullFriday => 'Jumat';

  @override
  String get calendarWeekdayFullSaturday => 'Sabtu';

  @override
  String get calendarWeekdayFullSunday => 'Minggu';

  @override
  String get wrongPasswordDialogTitle => 'Kata Sandi Salah';

  @override
  String get wrongPasswordDialogMessage =>
      'Kata sandi yang Anda masukkan salah.';

  @override
  String get commonOkButton => 'OK';

  @override
  String get unlockCategoryAction => 'Buka Kunci';

  @override
  String get lockCategoryAction => 'Kunci';

  @override
  String get categoryUnlockedMessage => 'Dibuka kuncinya';

  @override
  String get categoryLockedMessage => 'Folder dikunci';

  @override
  String get deleteFolderMenuItemLabel => 'Hapus Folder';

  @override
  String get deleteFolderDialogTitle => 'Hapus Folder';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'Anda yakin ingin menghapus folder \"$category\" beserta semua subfoldernya? Catatan dalam folder ini akan menjadi tidak berkategori.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'Anda yakin ingin menghapus folder \"$category\"? Catatan dalam folder ini akan menjadi tidak berkategori.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'Batal';

  @override
  String get deleteFolderDialogConfirmButton => 'Hapus';

  @override
  String get editCategoryNameColorMenuItemLabel => 'Edit Nama / Warna';

  @override
  String get addSubfolderMenuItemLabel => 'Buat Subfolder';

  @override
  String get expandSubfoldersMenuItemLabel => 'Perluas Subfolder';

  @override
  String get collapseSubfoldersMenuItemLabel => 'Ciutkan Subfolder';

  @override
  String saveErrorInfoMessage(String error) {
    return 'Kesalahan penyimpanan: $error';
  }

  @override
  String get welcomeNoteTitle => 'Selamat Datang di DNote! 🚀';

  @override
  String get welcomeNoteContent => 'Fitur baru telah ditambahkan!';

  @override
  String get noteListDateGroupToday => 'Hari Ini';

  @override
  String get noteListDateGroupYesterday => 'Kemarin';

  @override
  String get noteListDateGroupLast7Days => '7 Hari Terakhir';

  @override
  String get noteListDateGroupLast30Days => '30 Hari Terakhir';

  @override
  String get reminderRepeatNoneLabel => 'Tidak berulang';

  @override
  String get voiceRecorderPreparingLabel => 'Menyiapkan…';

  @override
  String get voiceRecorderCancelButton => 'Batal';

  @override
  String get voiceRecorderStopAddButton => 'Berhenti dan Tambahkan';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'Izin mikrofon tidak diberikan.';

  @override
  String get speechToTextUnavailableMessage =>
      'Pengenalan suara tidak tersedia di perangkat ini.';

  @override
  String get speechToTextPreparingLabel => 'Menyiapkan…';

  @override
  String get speechToTextListeningLabel => 'Mendengarkan…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'Mulai berbicara…';

  @override
  String get speechToTextCancelButton => 'Batal';

  @override
  String get speechToTextStopAddButton => 'Berhenti dan Tambahkan';

  @override
  String get textToSpeechNoContentMessage =>
      'Tidak ada konten untuk dibacakan.';

  @override
  String get textToSpeechReadErrorMessage =>
      'Terjadi kesalahan saat membacakan.';

  @override
  String get textToSpeechUnavailableMessage =>
      'Text-to-speech tidak tersedia di perangkat ini.';

  @override
  String get textToSpeechPreparingLabel => 'Menyiapkan…';

  @override
  String get textToSpeechPausedLabel => 'Dijeda';

  @override
  String get textToSpeechFinishedLabel => 'Pembacaan selesai';

  @override
  String get textToSpeechReadingLabel => 'Membaca…';

  @override
  String get textToSpeechCloseErrorButton => 'Tutup';

  @override
  String get textToSpeechReplayButton => 'Baca Lagi';

  @override
  String get textToSpeechCloseFinishedButton => 'Tutup';

  @override
  String get textToSpeechPauseButton => 'Jeda';

  @override
  String get textToSpeechResumeButton => 'Lanjutkan';

  @override
  String get textToSpeechStopButton => 'Berhenti';

  @override
  String get textToSpeechSpeedSlow => 'Lambat';

  @override
  String get textToSpeechSpeedNormal => 'Normal';

  @override
  String get textToSpeechSpeedFast => 'Cepat';

  @override
  String get calendarPickerCancelButton => 'Batal';

  @override
  String get calendarPickerConfirmButton => 'Pilih';

  @override
  String get calendarPickerClearButton => 'Hapus';

  @override
  String get reminderPickerDialogTitle => 'Tambah pengingat';

  @override
  String get reminderPickerDateTodayOption => 'Hari Ini';

  @override
  String get reminderPickerDateTomorrowOption => 'Besok';

  @override
  String get reminderPickerDatePickOption => 'Pilih tanggal';

  @override
  String get reminderRepeatHourlyLabel => 'Setiap jam';

  @override
  String get reminderRepeatDailyLabel => 'Setiap hari';

  @override
  String get reminderRepeatWeeklyLabel => 'Setiap minggu';

  @override
  String get reminderRepeatMonthlyLabel => 'Setiap bulan';

  @override
  String get reminderRepeatYearlyLabel => 'Setiap tahun';

  @override
  String get reminderPickerCalendarHelpText => 'Pilih tanggal pengingat';

  @override
  String get reminderPickerCancelButton => 'BATAL';

  @override
  String get reminderPickerSaveButton => 'SIMPAN';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'Waktu yang telah lewat tidak dapat dipilih';

  @override
  String calcTableTotalLabel(String amount) {
    return 'Total: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'Menyiapkan data...';

  @override
  String get backupCreatePackagingNotesLabel =>
      'Mengemas catatan dan kategori...';

  @override
  String get backupCreateReadingAttachmentsLabel => 'Membaca lampiran...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'Membaca lampiran... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'Mengompresi file zip...';

  @override
  String get backupCreateSavingFileLabel => 'Menyimpan file...';

  @override
  String get backupRestoreValidatingLabel => 'Memvalidasi cadangan...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'Cadangan tervalidasi, menyiapkan data...';

  @override
  String get backupRestoreWritingNotesLabel => 'Menulis catatan...';

  @override
  String get backupRestoreWritingTrashLabel => 'Menulis sampah...';

  @override
  String get backupRestoreTrashWrittenLabel => 'Sampah tertulis';

  @override
  String get backupRestoreWritingCategoriesLabel => 'Menulis kategori...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'Kategori tertulis';

  @override
  String get backupRestoreWritingSettingsLabel => 'Menulis pengaturan...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'Pengaturan tertulis';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'Membersihkan lampiran lama...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'Tidak ditemukan lampiran, menyelesaikan...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'Memulihkan lampiran... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'Selesai';

  @override
  String get backupValidationCorruptedFileMessage =>
      'File rusak atau bukan file cadangan yang valid.';

  @override
  String get backupValidationMissingDataMessage =>
      'Tidak ditemukan data di dalam file cadangan (backup_data.json tidak ada).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'Data cadangan tidak dapat dibaca (JSON rusak).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'File ini bukan cadangan dari aplikasi dnote.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'Informasi versi file cadangan tidak dapat dibaca.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'Cadangan ini dalam format yang lebih baru yang tidak didukung oleh versi aplikasi saat ini. Silakan perbarui aplikasi.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'Informasi versi file cadangan tidak valid.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'Data cadangan tidak dalam format yang diharapkan (kolom catatan tidak ada).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'Data cadangan tidak dalam format yang diharapkan (kolom sampah tidak ada).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'Data cadangan tidak dalam format yang diharapkan (daftar kategori tidak valid).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'Data cadangan tidak dalam format yang diharapkan (kolom pengaturan tidak valid).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'Data cadangan tidak dalam format yang diharapkan (sebuah data catatan tidak valid).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'Data cadangan tidak dalam format yang diharapkan (ditemukan data catatan tanpa ID).';

  @override
  String get backupValidationFileNotFoundMessage =>
      'File cadangan tidak ditemukan.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'Ruang penyimpanan perangkat tidak cukup. Silakan kosongkan ruang dan coba lagi.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'Izin akses file ditolak. Silakan periksa izin aplikasi dan coba lagi.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'Terjadi kesalahan saat operasi file: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'Terjadi kesalahan tak terduga: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'Tidak dapat membuat arsip zip (ZipEncoder mengembalikan null).';

  @override
  String get calcTableMenuItemLabel => 'Daftar Perhitungan';

  @override
  String get tagsMenuItemLabel => 'Tag';

  @override
  String get linkDialogUrlHint => 'https://contoh.com';

  @override
  String get checklistItemHint => 'Tambah item...';

  @override
  String get toolbarHighlightTooltip => 'Sorot';

  @override
  String get toolbarListTooltip => 'Daftar';

  @override
  String get toolbarHideKeyboardTooltip => 'Sembunyikan Keyboard';

  @override
  String get autoBackupLocalSuccessMessage => 'Cadangan lokal berhasil.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'Cadangan lokal gagal: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Cadangan Drive dilewati: akun Google tidak terhubung atau sesi telah berakhir. Silakan buka aplikasi dan hubungkan kembali.';

  @override
  String get autoBackupDriveSuccessMessage => 'Cadangan Drive berhasil.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Cadangan Drive gagal: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'Belum ada catatan';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'Total: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ Gambar';

  @override
  String get autoBackupSettingsAppBarTitle => 'Pengaturan Cadangan Otomatis';

  @override
  String get autoBackupSettingsMainSwitchTitle => 'Aktifkan Cadangan Otomatis';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'Catatan Anda dicadangkan secara aman secara berkala di latar belakang.';

  @override
  String get autoBackupSettingsTargetTitle => 'Target Cadangan';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'Pilih tempat penyimpanan cadangan.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'Lokal';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'Keduanya';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Hubungkan akun Anda terlebih dahulu untuk menggunakan opsi Google Drive.';

  @override
  String get autoBackupSettingsConnectButton => 'Hubungkan';

  @override
  String get autoBackupSettingsFrequencyTitle => 'Frekuensi Cadangan';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'Cadangan dibuat setiap $hours jam.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 Jam';

  @override
  String get autoBackupSettingsFrequency12h => '12 Jam';

  @override
  String get autoBackupSettingsFrequency24h => '24 Jam (Harian)';

  @override
  String get autoBackupSettingsFrequency48h => '48 Jam (2 Hari)';

  @override
  String get autoBackupSettingsFrequency168h => '168 Jam (Mingguan)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Gunakan Wi-Fi Saja';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'Unggahan cloud hanya terjadi melalui Wi-Fi untuk melindungi data seluler Anda.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'Status Sistem';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'Cadangan otomatis belum pernah berjalan.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'Terakhir Dijalankan: $date $time ($status)\nPesan: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'Berhasil';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'Gagal';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Tidak dapat terhubung ke akun Google.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'Pengaturan cadangan otomatis diperbarui.';

  @override
  String selectionModeDeletedMessage(int count) {
    return '$count catatan dihapus';
  }

  @override
  String get selectionModeArchivedMessage => 'Diarsipkan';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'Pilih kategori untuk $count catatan';
  }

  @override
  String get selectionModeAddCategoryOption => 'Tambah Kategori';

  @override
  String get selectionModeRemoveCategoryOption => 'Hapus Kategori';

  @override
  String get calcTableItemHint => 'Item...';

  @override
  String get calcTableTotalRowLabel => 'Total';

  @override
  String get textSelectionMenuShareButton => 'Bagikan';

  @override
  String get textSelectionMenuTranslateButton => 'Terjemahkan';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'Berbagi tidak dapat dimulai.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'Terjemahan tidak dapat dibuka.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'Hari Ini $time';
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
    return 'Cadangan terakhir: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage => 'Belum ada cadangan yang dibuat.';

  @override
  String get backupFileNameLabel => 'Cadangan';
}
