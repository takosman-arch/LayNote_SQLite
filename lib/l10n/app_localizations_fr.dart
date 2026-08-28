// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'Gras';

  @override
  String get toolbarItalicTooltip => 'Italique';

  @override
  String get toolbarUnderlineTooltip => 'Souligné';

  @override
  String get toolbarStrikethroughTooltip => 'Barré';

  @override
  String get toolbarFontSizeTooltip => 'Taille du texte';

  @override
  String get toolbarColorTooltip => 'Couleur du texte';

  @override
  String get toolbarBulletTooltip => 'Liste à puces';

  @override
  String get toolbarNumberTooltip => 'Liste numérotée';

  @override
  String get toolbarIndentTooltip => 'Retrait de paragraphe';

  @override
  String get toolbarLinkTooltip => 'Ajouter / Modifier / Supprimer le lien';

  @override
  String get toolbarDividerTooltip => 'Insérer une ligne de séparation';

  @override
  String get toolbarChecklistTooltip => 'Ajouter une liste de contrôle';

  @override
  String get linkSelectTextSnackbar =>
      'Sélectionnez d\'abord le texte auquel ajouter un lien';

  @override
  String get linkDialogEditTitle => 'Modifier le lien';

  @override
  String get linkDialogAddTitle => 'Ajouter un lien';

  @override
  String get linkDialogRemoveButton => 'Supprimer le lien';

  @override
  String get linkDialogCancelButton => 'Annuler';

  @override
  String get linkDialogConfirmButton => 'Ajouter';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'L\'autorisation de la caméra a été refusée. Vous devez l\'autoriser dans les paramètres pour filmer une vidéo.';

  @override
  String get cameraPermissionRequiredMessage =>
      'L\'autorisation de la caméra est requise pour filmer une vidéo.';

  @override
  String get openSettingsButtonLabel => 'Paramètres';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'Le scan n\'a pas pu démarrer : $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'La reconnaissance de texte a échoué : $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'Aucun texte lisible trouvé dans le document';

  @override
  String get scanResultSheetTitle => 'Comment ajouter le document scanné ?';

  @override
  String get scanResultTextOnlyOption => 'Ajouter uniquement le texte';

  @override
  String get scanResultTextAndImageOption =>
      'Ajouter le texte + l\'image scannée';

  @override
  String get scanResultCancelOption => 'Annuler';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'L\'autorisation du microphone a été refusée. Vous devez l\'autoriser dans les paramètres pour enregistrer un son.';

  @override
  String get audioPermissionRequiredMessage =>
      'L\'autorisation du microphone est requise pour enregistrer un son.';

  @override
  String get voiceRecordingDefaultLabel => 'Enregistrement vocal';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'Liste de calcul ($count lignes)';
  }

  @override
  String get blockPreviewDrawingLabel => 'Dessin';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count pièce(s) jointe(s) (photo/document)';
  }

  @override
  String get blockPreviewDividerLabel => 'Ligne de séparation';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'Liste de contrôle ($count éléments)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(texte vide)';

  @override
  String get reorderBlocksSheetTitle => 'Réorganiser les blocs';

  @override
  String get reorderBlocksMoveUpTooltip => 'Monter';

  @override
  String get reorderBlocksMoveDownTooltip => 'Descendre';

  @override
  String get reorderBlocksCloseTooltip => 'Fermer';

  @override
  String get reorderBlocksDescription =>
      'Touchez un bloc pour le sélectionner, puis utilisez les flèches haut/bas pour le déplacer.';

  @override
  String get reorderBlocksMenuItemLabel => 'Réorganiser';

  @override
  String get txtImportPickerDialogTitle =>
      'Sélectionnez le fichier TXT à importer';

  @override
  String get txtImportReadFailedMessage => 'Le fichier TXT n\'a pas pu être lu';

  @override
  String get txtImportEmptyFileMessage => 'Le fichier TXT est vide';

  @override
  String get txtImportSuccessMessage => 'TXT importé';

  @override
  String get txtImportMenuItemLabel => 'Importer (txt)';

  @override
  String get exportMenuItemLabel => 'Exporter';

  @override
  String get editorUndoTooltip => 'Annuler';

  @override
  String get editorRedoTooltip => 'Rétablir';

  @override
  String get noteSavedMessage => 'Note enregistrée';

  @override
  String get dateAssignPickerHelpText => 'Assigner la note à un jour';

  @override
  String get dateAssignChangeOption => 'Changer la date';

  @override
  String get dateAssignRemoveOption => 'Retirer l\'assignation';

  @override
  String get editorSubToolbarCloseTooltip => 'Fermer';

  @override
  String get titleFieldHint => 'Titre';

  @override
  String get textBlockHint => 'Écrivez votre note ici...';

  @override
  String get drawingBoardMenuItemLabel => 'Tableau de dessin';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'La conversion vocale n\'est disponible que pour les notes texte';

  @override
  String get selectionModeCancelTooltip => 'Annuler la sélection';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return '$count sélectionné(s)';
  }

  @override
  String get selectionModeDeleteTooltip => 'Supprimer';

  @override
  String get selectionModeArchiveTooltip => 'Archiver';

  @override
  String get selectionModeFolderTooltip => 'Dossier';

  @override
  String get searchFieldHint => 'Rechercher dans les notes...';

  @override
  String get emptyTrashDialogTitle => 'Vider la corbeille';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'Toutes les notes supprimées seront définitivement effacées. Êtes-vous sûr(e) ?';

  @override
  String get emptyTrashDialogCancelButton => 'Annuler';

  @override
  String get restoreAllMenuItemLabel => 'Tout restaurer';

  @override
  String get sortMenuTooltip => 'Trier les notes';

  @override
  String get sortMenuAscendingLabel => 'Ordre : Croissant (A-Z)';

  @override
  String get sortMenuDescendingLabel => 'Ordre : Décroissant (Z-A)';

  @override
  String get sortMenuByTitleLabel => 'Trier par : Titre';

  @override
  String get sortMenuByModifiedDateLabel => 'Trier par : Dernière modification';

  @override
  String get sortMenuByCreatedDateLabel => 'Trier par : Date de création';

  @override
  String get sortMenuByFolderLabel => 'Trier par : Dossier';

  @override
  String get viewToggleGridTooltip => 'Vue en grille';

  @override
  String get viewToggleListTooltip => 'Vue en liste';

  @override
  String get drawerHeaderSubtitle => 'Votre carnet de notes personnel';

  @override
  String get drawerNotesSectionHeader => 'NOTES';

  @override
  String get drawerAllNotesLabel => 'Notes';

  @override
  String get drawerFavoritesLabel => 'Favoris';

  @override
  String get drawerAgendaLabel => 'Agenda';

  @override
  String get drawerRemindersLabel => 'Rappel';

  @override
  String get drawerLockedLabel => 'Verrouillé';

  @override
  String get drawerTrashLabel => 'Corbeille';

  @override
  String get drawerFoldersSectionHeader => 'DOSSIERS';

  @override
  String get drawerExpandLabel => 'Développer';

  @override
  String get drawerCollapseLabel => 'Réduire';

  @override
  String get drawerAddFolderLabel => 'Ajouter un dossier';

  @override
  String get drawerAppSectionHeader => 'APPLICATION';

  @override
  String get drawerCalendarLabel => 'Calendrier';

  @override
  String get drawerSettingsLabel => 'Paramètres';

  @override
  String get drawerBackupRestoreLabel => 'Sauvegarder et restaurer';

  @override
  String get drawerUpgradeToProLabel => 'Passer à Pro';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'Soutenir le développement';

  @override
  String get drawerFeedbackLabel => 'Retour d\'expérience';

  @override
  String get drawerAboutLabel => 'À propos';

  @override
  String get noNotesFoundMessage => 'Aucune note trouvée.';

  @override
  String get trashRestoreButtonLabel => 'Restaurer';

  @override
  String get trashPermanentDeleteButtonLabel => 'Supprimer définitivement';

  @override
  String get tagRenamedInfoMessage => 'Étiquette renommée';

  @override
  String get tagDeletedInfoMessage => 'Étiquette supprimée';

  @override
  String get tagOptionsRenameLabel => 'Renommer';

  @override
  String get tagOptionsDeleteLabel => 'Supprimer';

  @override
  String get renameTagDialogTitle => 'Renommer l\'étiquette';

  @override
  String get renameTagDialogHint => 'Nouveau nom d\'étiquette';

  @override
  String get renameTagDialogCancelButton => 'Annuler';

  @override
  String get renameTagDialogSaveButton => 'Enregistrer';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return 'L\'étiquette « $tag » sera retirée de $affectedCount notes. Continuer ?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'Supprimer l\'étiquette « $tag » ?';
  }

  @override
  String get deleteTagDialogTitle => 'Supprimer l\'étiquette';

  @override
  String get deleteTagDialogCancelButton => 'Annuler';

  @override
  String get deleteTagDialogConfirmButton => 'Supprimer';

  @override
  String get tagsSheetTitle => 'Étiquettes';

  @override
  String get tagsSheetEmptyMessage =>
      'Cette note n\'a pas encore d\'étiquette.';

  @override
  String get tagsSheetInputHint => 'Écrire une nouvelle étiquette...';

  @override
  String get tagsSheetSuggestionsLabel => 'Étiquettes existantes';

  @override
  String get noteDeletedInfoMessage => 'Note supprimée';

  @override
  String get noteDeletedUndoActionLabel => 'Annuler';

  @override
  String get reminderSetInfoMessage => 'Rappel programmé';

  @override
  String get reminderRemovedInfoMessage => 'Rappel supprimé';

  @override
  String get noteDuplicatedInfoMessage => 'Copie créée';

  @override
  String get speechTextAppendedInfoMessage => 'Texte ajouté à la note';

  @override
  String get pdfPreparingInfoMessage => 'Préparation du PDF…';

  @override
  String get pdfSavedInfoMessage => 'PDF enregistré';

  @override
  String get jpgPreparingInfoMessage => 'Préparation du JPG…';

  @override
  String get jpgSavedInfoMessage => 'JPG enregistré';

  @override
  String get jpgFailedInfoMessage => 'Impossible de créer le JPG';

  @override
  String get txtPreparingInfoMessage => 'Préparation du TXT…';

  @override
  String get txtSavedInfoMessage => 'TXT enregistré';

  @override
  String get txtFailedInfoMessage => 'Impossible de créer le TXT';

  @override
  String get exportOpenActionLabel => 'Ouvrir';

  @override
  String get wrongPasswordInfoMessage => 'Mot de passe incorrect.';

  @override
  String get noteArchivedInfoMessage => 'Note archivée';

  @override
  String get noteUnarchivedInfoMessage => 'Retirée des archives';

  @override
  String get noteUnlockedInfoMessage => 'Déverrouillée';

  @override
  String get noteLockedInfoMessage => 'Note verrouillée';

  @override
  String get notificationUnpinnedInfoMessage => 'Épinglage retiré';

  @override
  String get emptyNotePinBlockedInfoMessage =>
      'Une note vide ne peut pas être épinglée.';

  @override
  String get notificationPinnedInfoMessage =>
      'Épinglée au panneau de notifications';

  @override
  String get noContentToReadInfoMessage => 'Il n\'y a aucun contenu à lire';

  @override
  String get backPressExitInfoMessage =>
      'Appuyez à nouveau sur retour pour quitter';

  @override
  String get reminderChannelName => 'Rappels de notes';

  @override
  String get reminderChannelDescription =>
      'Rappels de notes de l\'application Layout';

  @override
  String get pinnedChannelName => 'Notes épinglées';

  @override
  String get pinnedChannelDescription =>
      'Notes Layout épinglées au panneau de notifications';

  @override
  String get notificationUnpinActionLabel => 'Retirer';

  @override
  String get reminderDefaultTitle => 'Rappel';

  @override
  String get reminderChecklistBodyFallback =>
      'N\'oubliez pas de vérifier votre liste de contrôle';

  @override
  String get reminderTextBodyFallback =>
      'N\'oubliez pas de consulter votre note';

  @override
  String get pdfSaveDialogTitle => 'Enregistrer en PDF';

  @override
  String get jpgSaveDialogTitle => 'Enregistrer en JPG';

  @override
  String get txtSaveDialogTitle => 'Enregistrer en TXT';

  @override
  String get textSizeSheetTitle => 'Taille du texte';

  @override
  String get textSizeSamplePreview => 'Exemple de texte';

  @override
  String get textSizeCancelButton => 'Annuler';

  @override
  String get textSizeApplyButton => 'Appliquer';

  @override
  String get createPasswordDialogTitle => 'Créer un mot de passe';

  @override
  String get createPasswordNewPasswordHint => 'Nouveau mot de passe';

  @override
  String get createPasswordConfirmHint => 'Ressaisissez le mot de passe';

  @override
  String get createPasswordHintQuestionDescription =>
      'Définissez une question de sécurité au cas où vous oublieriez votre mot de passe (facultatif).';

  @override
  String get createPasswordHintQuestionHint =>
      'Choisissez une question de sécurité';

  @override
  String get createPasswordHintAnswerHint => 'Votre réponse';

  @override
  String get createPasswordCancelButton => 'Annuler';

  @override
  String get createPasswordSaveButton => 'Enregistrer';

  @override
  String get passwordMismatchMessage =>
      'Les mots de passe ne correspondent pas !';

  @override
  String get passwordRequiredDialogTitle => 'Mot de passe requis';

  @override
  String get passwordRequiredHint => 'Saisissez le mot de passe';

  @override
  String get forgotPasswordButtonLabel => 'Mot de passe oublié';

  @override
  String get passwordRequiredCancelButton => 'Annuler';

  @override
  String get passwordRequiredConfirmButton => 'Vérifier';

  @override
  String get securityQuestionDialogTitle => 'Question de sécurité';

  @override
  String get securityQuestionAnswerHint => 'Votre réponse';

  @override
  String get securityQuestionCancelButton => 'Annuler';

  @override
  String get securityQuestionConfirmButton => 'Confirmer';

  @override
  String get securityQuestionWrongAnswerMessage =>
      'Réponse incorrecte. Réessayez.';

  @override
  String get revealedPasswordDialogTitle => 'Votre mot de passe';

  @override
  String get revealedPasswordLabel => 'Votre mot de passe de note :';

  @override
  String get revealedPasswordOkButton => 'OK';

  @override
  String get securityQuestionPetName =>
      'Quel est le nom de votre premier animal de compagnie ?';

  @override
  String get securityQuestionFavoriteTeacher =>
      'Quel est le nom de votre professeur préféré ?';

  @override
  String get securityQuestionBirthCity => 'Dans quelle ville êtes-vous né(e) ?';

  @override
  String get securityQuestionFavoriteFood => 'Quel est votre plat préféré ?';

  @override
  String get securityQuestionMotherMaidenName =>
      'Quel est le nom de jeune fille de votre mère ?';

  @override
  String get securityQuestionFirstSchool =>
      'Quel est le nom de votre première école ?';

  @override
  String get securityQuestionFavoriteColor =>
      'Quelle est votre couleur préférée ?';

  @override
  String get editFolderDialogTitle => 'Modifier le dossier';

  @override
  String get newSubfolderDialogTitle => 'Nouveau sous-dossier';

  @override
  String get addFolderDialogTitle => 'Ajouter un dossier';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'Sera créé dans « $parentCategory »';
  }

  @override
  String get subfolderNameFieldLabel => 'Nom du sous-dossier';

  @override
  String get folderNameFieldLabel => 'Nom du dossier';

  @override
  String get folderColorLabel => 'Couleur';

  @override
  String get folderDialogCancelButton => 'Annuler';

  @override
  String get folderDialogSaveButton => 'Enregistrer';

  @override
  String get folderDialogAddButton => 'Ajouter';

  @override
  String get selectFolderSheetTitle => 'Sélectionner un dossier';

  @override
  String get selectFolderAddOptionLabel => 'Ajouter un dossier';

  @override
  String get removeCurrentFolderLabel => 'Retirer le dossier actuel';

  @override
  String get noteDetailsDialogTitle => 'Détails';

  @override
  String get noteDetailsCreatedLabel => 'Créée le';

  @override
  String get noteDetailsModifiedLabel => 'Dernière modification';

  @override
  String get noteDetailsCharCountLabel => 'Nombre de caractères';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count caractères';
  }

  @override
  String get noteDetailsWordCountLabel => 'Nombre de mots';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count mots';
  }

  @override
  String get noteDetailsOkButton => 'OK';

  @override
  String get noteDetailsUnknownDateLabel => 'Inconnu';

  @override
  String get addAttachmentSheetTitle => 'Ajouter';

  @override
  String get addAttachmentImageOption => 'Ajouter une image';

  @override
  String get addAttachmentCameraOption => 'Caméra';

  @override
  String get addAttachmentFileOption => 'Ajouter un fichier';

  @override
  String get addAttachmentVoiceOption => 'Enregistrement vocal';

  @override
  String get addAttachmentVideoOption => 'Filmer une vidéo';

  @override
  String get addAttachmentScanOption => 'Scanner un document';

  @override
  String get noteActionsSheetTitle => 'Choisir une action';

  @override
  String get noteActionReminderLabel => 'Rappel';

  @override
  String get noteActionEditReminderLabel => 'Modifier le rappel';

  @override
  String get noteActionSpeechToTextLabel => 'Convertir la voix en texte';

  @override
  String get noteActionArchiveLabel => 'Archiver';

  @override
  String get noteActionUnarchiveLabel => 'Retirer des archives';

  @override
  String get noteActionLockLabel => 'Verrouiller';

  @override
  String get noteActionUnlockLabel => 'Déverrouiller';

  @override
  String get noteActionFavoriteLabel => 'Favori';

  @override
  String get noteActionUnfavoriteLabel => 'Retirer des favoris';

  @override
  String get noteActionClassifyLabel => 'Sélectionner un dossier';

  @override
  String get noteActionDeleteLabel => 'Supprimer';

  @override
  String get noteActionPinToNotificationLabel =>
      'Épingler au panneau de notifications';

  @override
  String get noteActionUnpinFromNotificationLabel => 'Retirer l\'épinglage';

  @override
  String get noteActionShareLabel => 'Partager';

  @override
  String get noteActionDuplicateLabel => 'Créer une copie';

  @override
  String get noteActionCopyContentLabel => 'Copier le contenu';

  @override
  String get noteActionTtsLabel => 'Lire à voix haute';

  @override
  String get noteActionTextSizeLabel => 'Taille du texte';

  @override
  String get noteActionDetailsLabel => 'Détails';

  @override
  String get noteActionDiscardChangesLabel => 'Ignorer les modifications';

  @override
  String get noteActionSelectLabel => 'Sélectionner';

  @override
  String get reminderEditOptionLabel => 'Modifier le rappel';

  @override
  String get reminderRemoveOptionLabel => 'Supprimer le rappel';

  @override
  String get discardChangesDialogTitle => 'Ignorer les modifications';

  @override
  String get discardChangesDialogMessage =>
      'Les modifications non enregistrées de cette note seront perdues. Voulez-vous vraiment les ignorer ?';

  @override
  String get discardChangesCancelButton => 'Annuler';

  @override
  String get discardChangesConfirmButton => 'Ignorer';

  @override
  String get pinnedNotificationDefaultTitle => 'Note';

  @override
  String get pdfFailedInfoMessage => 'Impossible de créer le PDF';

  @override
  String get drawingScreenTitle => 'Dessin';

  @override
  String get drawingMinimizeTooltip => 'Réduire';

  @override
  String get drawingEmptyExportWarningMessage => 'Faites d\'abord un dessin';

  @override
  String get drawingEraserPartialModeLabel => 'Partiel';

  @override
  String get drawingEraserFullModeLabel => 'Complet';

  @override
  String get drawingClearTooltip => 'Effacer';

  @override
  String get drawingZoomOutTooltip => 'Dézoomer';

  @override
  String get drawingZoomInTooltip => 'Zoomer';

  @override
  String get drawingDeleteTooltip => 'Supprimer';

  @override
  String get drawingEmptyPreviewHint => 'Touchez pour dessiner';

  @override
  String get settingsPageTitle => 'Paramètres';

  @override
  String get settingsSectionGeneral => 'Général';

  @override
  String get settingsSectionSecurity => 'Sécurité';

  @override
  String get settingsSectionTheme => 'Thème';

  @override
  String get settingsSectionPersonalization => 'Personnalisation';

  @override
  String get settingsSectionWidget => 'Widget';

  @override
  String get settingsSectionAbout => 'À propos';

  @override
  String get settingsHintQuestionPet =>
      'Quel est le nom de votre premier animal de compagnie ?';

  @override
  String get settingsHintQuestionTeacher =>
      'Quel est le nom de votre professeur préféré ?';

  @override
  String get settingsHintQuestionBirthCity =>
      'Dans quelle ville êtes-vous né(e) ?';

  @override
  String get settingsHintQuestionFavoriteFood =>
      'Quel est votre plat préféré ?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'Quel est le nom de jeune fille de votre mère ?';

  @override
  String get settingsHintQuestionFirstSchool =>
      'Quelle était votre première école ?';

  @override
  String get settingsHintQuestionFavoriteColor =>
      'Quelle est votre couleur préférée ?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'Question de sécurité';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'Si vous oubliez votre mot de passe, vous pourrez le récupérer en répondant correctement à cette question.';

  @override
  String get settingsSecurityQuestionDropdownHint =>
      'Choisissez une question de sécurité';

  @override
  String get settingsSecurityQuestionAnswerHint => 'Votre réponse';

  @override
  String get settingsSecurityQuestionCancelButton => 'Annuler';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'La question et la réponse ne peuvent pas être vides !';

  @override
  String get settingsSecurityQuestionSaveButton => 'Enregistrer';

  @override
  String get settingsCreatePasswordTitle => 'Créer un mot de passe';

  @override
  String get settingsPasswordRequiredTitle => 'Mot de passe requis';

  @override
  String get settingsPasswordEnterHint => 'Saisissez le mot de passe';

  @override
  String get settingsForgotPasswordButton => 'Mot de passe oublié';

  @override
  String get settingsNewPasswordHint => 'Nouveau mot de passe';

  @override
  String get settingsConfirmPasswordHint => 'Ressaisissez le mot de passe';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'Définissez une question de sécurité au cas où vous oublieriez votre mot de passe (facultatif).';

  @override
  String get settingsPasswordDialogCancelButton => 'Annuler';

  @override
  String get settingsPasswordMismatchWarning =>
      'Les mots de passe ne correspondent pas !';

  @override
  String get settingsWrongPasswordWarning => 'Mot de passe incorrect !';

  @override
  String get settingsPasswordSaveButton => 'Enregistrer';

  @override
  String get settingsPasswordRemoveButton => 'Retirer';

  @override
  String get settingsNotePasswordTitle => 'Mot de passe de la note';

  @override
  String get settingsPasswordSetSubtitle => 'Mot de passe défini ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'Mot de passe non défini';

  @override
  String get settingsSecurityQuestionTileTitle => 'Question de sécurité';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'Définie ✓ — utilisée si vous oubliez votre mot de passe';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'Non définie — vous ne pourrez pas récupérer votre mot de passe si vous le perdez';

  @override
  String get settingsThemeDialogTitle => 'Choisir le thème';

  @override
  String get settingsThemeSystemDefault => 'Paramètre système';

  @override
  String get settingsThemeLightOption => 'Thème clair';

  @override
  String get settingsThemeDarkOption => 'Thème sombre';

  @override
  String get settingsLanguageDialogTitle => 'Choisir la langue';

  @override
  String get settingsLanguageSystemOption => 'Système';

  @override
  String get settingsAccentColorDialogTitle => 'Choisir la couleur d\'accent';

  @override
  String get settingsThemeChangeTileTitle => 'Changer de thème';

  @override
  String get settingsThemeLightLabel => 'Clair';

  @override
  String get settingsThemeDarkLabel => 'Sombre';

  @override
  String get settingsThemeSystemLabel => 'Système';

  @override
  String get settingsLanguageTileTitle => 'Langue';

  @override
  String get settingsAccentColorTileTitle => 'Couleur d\'accent';

  @override
  String get settingsAccentColorTileSubtitle =>
      'Couleur utilisée dans la barre d\'application, les boutons et les interrupteurs';

  @override
  String get settingsColorfulNotesTitle => 'Couleurs de notes variées';

  @override
  String get settingsColorfulNotesSubtitle =>
      'Chaque carte de note prend une teinte différente.';

  @override
  String get settingsTextColorSheetTitle => 'Couleur du texte';

  @override
  String get settingsTextColorSheetDesc =>
      'Définit la couleur du texte du contenu de la note.';

  @override
  String get settingsTextColorOkButton => 'OK';

  @override
  String get settingsTextColorTileTitle => 'Couleur du texte';

  @override
  String get settingsTextColorTileSubtitle =>
      'Couleur du texte du contenu de la note.';

  @override
  String get settingsWidgetFontSizeLabel => 'Taille du texte du widget';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'Exemple de titre - $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'Annuler';

  @override
  String get settingsWidgetFontSizeApplyButton => 'Appliquer';

  @override
  String get settingsWidgetOpacityLabel => 'Transparence de l\'arrière-plan';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return '$percent % de transparence';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'Annuler';

  @override
  String get settingsWidgetOpacityApplyButton => 'Appliquer';

  @override
  String get settingsWidgetDarkModeTitle => 'Widget sombre';

  @override
  String get settingsWidgetDarkModeDesc =>
      'Palette de couleurs sombre pour le widget.';

  @override
  String get settingsAboutVersionTitle => 'Version de l\'application';

  @override
  String get settingsAboutVersionLoading => 'Chargement de la version…';

  @override
  String get aboutSectionDeveloper => 'Commentaires';

  @override
  String get aboutDeveloperTitle => 'Développeur';

  @override
  String get aboutContactTitle => 'Contact';

  @override
  String get aboutWebsiteTitle => 'Site web';

  @override
  String get aboutGithubTitle => 'GitHub';

  @override
  String get aboutSectionLegal => 'Mentions légales';

  @override
  String get aboutPrivacyPolicyTitle => 'Politique de confidentialité';

  @override
  String get aboutTermsTitle => 'Conditions d\'utilisation';

  @override
  String get aboutLicensesTitle => 'Licences open source';

  @override
  String get aboutSectionSupport => 'Évaluer';

  @override
  String get aboutRateAppTitle => 'Évaluer l\'application';

  @override
  String get aboutLinkOpenError => 'Impossible d\'ouvrir le lien.';

  @override
  String get settingsFontFamilyTileTitle => 'Police';

  @override
  String get settingsFontFamilyDefaultLabel => 'Par défaut';

  @override
  String get settingsGlobalFontSizeTileTitle => 'Taille du texte';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt — appliqué à toutes les notes.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'Exemple de texte - $size pt';
  }

  @override
  String get settingsGlobalFontSizeCancelButton => 'Annuler';

  @override
  String get settingsGlobalFontSizeApplyButton => 'Appliquer';

  @override
  String get settingsPreviewLinesTileTitle => 'Lignes d\'aperçu des notes';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'Afficher jusqu\'à $lines lignes. Si la note est plus courte, le nombre réel de lignes est affiché.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'Actuellement : $lines lignes';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'Définit le nombre maximal de lignes à prévisualiser. Si la note a moins de lignes, le nombre réel est affiché.';

  @override
  String get settingsPreviewLinesCancelButton => 'Annuler';

  @override
  String get settingsPreviewLinesApplyButton => 'Appliquer';

  @override
  String get backupCancelButton => 'Annuler';

  @override
  String get backupConnectButton => 'Connecter';

  @override
  String get backupDisconnectButton => 'Déconnecter';

  @override
  String get backupContinueButton => 'Continuer';

  @override
  String get backupCloseButton => 'Fermer';

  @override
  String get backupShareButton => 'Partager';

  @override
  String get backupRestoreButton => 'Restaurer';

  @override
  String get backupConfigureButton => 'Configurer';

  @override
  String get backupUnknownDateLabel => 'Inconnu';

  @override
  String get backupProcessingDefaultLabel => 'Traitement en cours...';

  @override
  String get backupPermissionRequiredTitle =>
      'Autorisation de stockage requise';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'Cette version d\'Android nécessite l\'autorisation de stockage pour la sauvegarde/restauration. Comme l\'autorisation a été définitivement refusée, veuillez l\'activer manuellement dans les paramètres de l\'application.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'Cette version d\'Android nécessite l\'autorisation de stockage pour la sauvegarde/restauration. Veuillez accorder l\'autorisation pour continuer.';

  @override
  String get backupGoToSettingsButton => 'Aller aux paramètres';

  @override
  String get backupRetryButton => 'Réessayer';

  @override
  String get backupDriveConnectingLabel =>
      'Connexion au compte Google en cours...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Connecté au compte Google Drive : $email';
  }

  @override
  String get backupDriveConnectedMessage => 'Connecté au compte Google Drive.';

  @override
  String get backupDriveConnectFailedMessage =>
      'Impossible de se connecter au compte Google, ou l\'opération a été annulée.';

  @override
  String get backupDriveDisconnectTitle => 'Déconnecter Google Drive';

  @override
  String get backupDriveDisconnectBody =>
      'Si vous vous déconnectez, les sauvegardes manuelles ou automatiques vers Drive ne seront plus possibles. Les sauvegardes déjà présentes sur Drive ne seront pas supprimées — seul l\'accès depuis cet appareil sera retiré.';

  @override
  String get backupDriveDisconnectedMessage =>
      'Connexion Google Drive supprimée.';

  @override
  String get backupDriveRequiredTitle => 'Compte Google requis';

  @override
  String get backupDriveRequiredBody =>
      'Cette action nécessite de connecter votre compte Google. Voulez-vous vous connecter maintenant ?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive : connecté ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive : connecté';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive : non connecté';

  @override
  String get backupDriveAuthenticatingLabel =>
      'Vérification du compte Google en cours...';

  @override
  String get backupDriveNotSignedInMessage =>
      'Vous n\'êtes pas connecté(e) à Google Drive. Veuillez d\'abord vous connecter avec votre compte Google.';

  @override
  String get backupDriveUploadingLabel =>
      'Téléversement de la sauvegarde vers Drive...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'Le téléversement vers Google Drive n\'a pas pu se terminer en 120 secondes (aucune réponse du serveur). Veuillez vérifier votre connexion et réessayer.';

  @override
  String get backupDriveOperationCompletedLabel => 'Terminé';

  @override
  String get backupToDriveActionLabel => 'sauvegarde vers Drive';

  @override
  String get backupToDeviceActionLabel => 'sauvegarde';

  @override
  String get backupCreatingLabel => 'Création de la sauvegarde...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'La sauvegarde n\'a pas pu être créée : $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Échec du téléversement vers Google Drive : $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'Sauvegarde téléversée avec succès sur Google Drive.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'Sauvegarde créée : $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'Sauvegarde prête';

  @override
  String get backupOfferShareBody =>
      'Votre fichier de sauvegarde a été enregistré sur votre appareil. Voulez-vous le partager maintenant (par ex. stockage cloud, e-mail, un autre appareil) ?';

  @override
  String get backupShareFileText => 'fichier de sauvegarde layout';

  @override
  String backupShareFailedMessage(String error) {
    return 'Le partage n\'a pas pu démarrer : $error';
  }

  @override
  String get backupLargeOperationTitle => 'Sauvegarde volumineuse';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'La taille des données à traiter est d\'environ $sizeText. Une opération de $actionLabel de cette taille peut prendre un certain temps selon votre appareil. Ne quittez simplement pas l\'application pendant le traitement — voulez-vous continuer ?';
  }

  @override
  String get backupRestoreActionLabel => 'restauration';

  @override
  String get backupDriveListingLabel =>
      'Liste des sauvegardes Drive en cours...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'Impossible de lister les sauvegardes : $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'Il n\'y a pas encore de sauvegarde sur Google Drive.';

  @override
  String get backupDrivePickTitle => 'Choisir une sauvegarde depuis Drive';

  @override
  String get backupDriveDownloadingLabel =>
      'Téléchargement de la sauvegarde depuis Drive...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Téléchargement de la sauvegarde depuis Drive... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel =>
      'Enregistrement du fichier sur l\'appareil...';

  @override
  String get backupDriveUnknownBackupFileName => 'sauvegarde_inconnue.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Votre espace de stockage Google Drive est plein. Veuillez libérer de l\'espace sur Drive et réessayer.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'Impossible d\'établir une connexion Internet. Veuillez vérifier votre connexion et réessayer.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'Le fichier de sauvegarde spécifié est introuvable sur Drive. Il a peut-être été supprimé.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Une erreur inattendue s\'est produite pendant l\'opération Google Drive : $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'Échec du téléchargement : $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'Le fichier n\'a pas pu être sélectionné : $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'Le fichier sélectionné n\'a pas pu être atteint.';

  @override
  String get backupCheckingLabel => 'Vérification de la sauvegarde...';

  @override
  String backupReadFailedMessage(String error) {
    return 'Le fichier de sauvegarde n\'a pas pu être lu : $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'Restaurer la sauvegarde';

  @override
  String get backupPreviewContentsHeader =>
      'Contenu de la sauvegarde sélectionnée :';

  @override
  String get backupPreviewNoteCountLabel => 'Nombre de notes';

  @override
  String get backupPreviewTrashCountLabel => 'Notes dans la corbeille';

  @override
  String get backupPreviewCategoryCountLabel => 'Nombre de catégories';

  @override
  String get backupPreviewAttachmentLabel => 'Pièces jointes';

  @override
  String get backupPreviewAttachmentNoneValue => 'Aucune';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count fichiers ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'Date de création';

  @override
  String get backupEmptyPreviewTitle => 'Cette sauvegarde semble vide';

  @override
  String get backupEmptyPreviewBody =>
      'Aucune note, catégorie ou pièce jointe n\'a été trouvée dans le fichier sélectionné. Si vous continuez, vos données actuelles seront tout de même supprimées et remplacées par cette sauvegarde vide.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '$count pièce(s) jointe(s) introuvable(s) dans la sauvegarde';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'Les notes contenant ces fichiers seront restaurées, mais sans les pièces jointes (elles étaient peut-être manquantes ou corrompues lors de la sauvegarde) : $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown et $remaining de plus';
  }

  @override
  String get backupRestoreConfirmBody =>
      'Cette opération REMPLACERA toutes vos notes, votre corbeille, vos catégories, vos paramètres et vos pièces jointes actuels par les données de la sauvegarde ci-dessus. Vos données actuelles seront définitivement perdues et cette action est irréversible.';

  @override
  String get backupRestoringLabel => 'Restauration de la sauvegarde...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'Sauvegarde restaurée. Cependant, $count pièce(s) jointe(s) n\'ont pas été trouvées dans la sauvegarde et n\'ont pas pu être restaurées. Il est recommandé de redémarrer l\'application pour que les changements soient pleinement pris en compte.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'Sauvegarde restaurée avec succès. Il est recommandé de redémarrer l\'application pour que les changements soient pleinement pris en compte.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'Une erreur s\'est produite lors de la restauration : $error';
  }

  @override
  String get backupScreenTitle => 'Sauvegarder et restaurer';

  @override
  String get backupBlockedExitWarningMessage =>
      'Une opération est en cours, veuillez attendre qu\'elle se termine.';

  @override
  String get backupBusyBackTooltip => 'Opération en cours';

  @override
  String get backupIntroText =>
      'Vous pouvez sauvegarder vos notes, catégories, paramètres et pièces jointes dans un seul fichier .zip, ou restaurer une sauvegarde effectuée précédemment.';

  @override
  String get backupDriveCardTitle => 'Sauvegarder sur Google Drive';

  @override
  String get backupDriveCardSubtitle =>
      'Créez une nouvelle sauvegarde et téléversez-la directement dans l\'espace privé de votre Google Drive.';

  @override
  String get backupDriveCardButtonLabel => 'Sauvegarder sur Drive';

  @override
  String get backupDeviceCardTitle => 'Sauvegarder sur l\'appareil';

  @override
  String get backupDeviceCardSubtitle =>
      'Enregistrez toutes vos données dans un seul fichier .zip sur l\'appareil et partagez-le si vous le souhaitez.';

  @override
  String get backupDeviceCardButtonLabel => 'Sauvegarder sur l\'appareil';

  @override
  String get backupHistoryCardTitle => 'Historique des sauvegardes';

  @override
  String get backupHistoryCardSubtitle =>
      'Consultez toutes les sauvegardes enregistrées sur l\'appareil avec leur date et leur taille ; vous pouvez les partager, les restaurer ou les supprimer directement d\'ici.';

  @override
  String get backupHistoryTabDevice => 'Appareil';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'Supprimer la sauvegarde';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'Voulez-vous vraiment supprimer définitivement le fichier de sauvegarde « $fileName » ? Cette action est irréversible.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage => 'Sauvegarde supprimée.';

  @override
  String get backupHistoryDriveDeleteDialogTitle =>
      'Supprimer la sauvegarde Drive';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'Voulez-vous vraiment supprimer définitivement la sauvegarde « $fileName » de Google Drive ? Cette action est irréversible et le fichier ne sera pas déplacé dans la corbeille.';
  }

  @override
  String get backupHistoryDriveDeletedMessage => 'Sauvegarde Drive supprimée.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'Impossible de supprimer : $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'Aucune sauvegarde enregistrée sur cet appareil pour le moment.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'Utilisez « Sauvegarder sur l\'appareil » pour créer votre première sauvegarde.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'Utilisez « Sauvegarder sur Google Drive » pour créer votre première sauvegarde cloud.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Connectez votre compte Google pour voir vos sauvegardes Drive.';

  @override
  String get backupHistoryConnectGoogleButton => 'Se connecter avec Google';

  @override
  String get backupHistoryDriveConnectedFallback => 'Connecté';

  @override
  String get backupHistoryUnknownErrorFallback =>
      'Une erreur inconnue s\'est produite.';

  @override
  String get backupHistoryDownloadStartingLabel => 'Démarrage...';

  @override
  String get backupAutoBackupEnabledLabel => 'Sauvegarde automatique : activée';

  @override
  String get backupAutoBackupDisabledLabel =>
      'Sauvegarde automatique : désactivée';

  @override
  String get backupOverlayWarningMessage =>
      'Veuillez patienter, ne quittez pas l\'application avant la fin de l\'opération.';

  @override
  String get pdfExportUntitledNoteLabel => 'Note sans titre';

  @override
  String get pdfExportDefaultAttachmentName => 'Pièce jointe';

  @override
  String get pdfExportDefaultFileName => 'note';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'La capture d\'écran n\'a pas pu être prise (limite introuvable)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'Les données de la capture d\'écran n\'ont pas pu être générées';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'L\'image n\'a pas pu être traitée (échec du décodage PNG)';

  @override
  String get screenshotCalcTableTotalLabel => 'Total';

  @override
  String get gundemMenuRemoveFromAgenda => 'Retirer de l\'agenda';

  @override
  String get gundemMenuDeleteNote => 'Supprimer la note';

  @override
  String get gundemSectionOverdue => 'En retard';

  @override
  String get gundemSectionToday => 'Aujourd\'hui';

  @override
  String get gundemSectionTomorrow => 'Demain';

  @override
  String get gundemSectionNextWeek => 'Semaine prochaine';

  @override
  String get gundemSectionFurther => 'Plus tard';

  @override
  String get gundemWeekdayMonday => 'Lundi';

  @override
  String get gundemWeekdayTuesday => 'Mardi';

  @override
  String get gundemWeekdayWednesday => 'Mercredi';

  @override
  String get gundemWeekdayThursday => 'Jeudi';

  @override
  String get gundemWeekdayFriday => 'Vendredi';

  @override
  String get gundemWeekdaySaturday => 'Samedi';

  @override
  String get gundemWeekdaySunday => 'Dimanche';

  @override
  String get gundemAppBarTitle => 'Agenda';

  @override
  String get gundemCalendarTooltip => 'Calendrier';

  @override
  String get gundemEmptyTitle => 'Rien dans votre agenda';

  @override
  String get gundemEmptySubtitle =>
      'Les notes avec un rappel ou une date assignée apparaîtront ici.';

  @override
  String get gundemUntitledNote => 'Note sans titre';

  @override
  String get gundemRepeatHourly => 'Toutes les heures';

  @override
  String get gundemRepeatDaily => 'Tous les jours';

  @override
  String get gundemRepeatWeekly => 'Toutes les semaines';

  @override
  String get gundemRepeatMonthly => 'Tous les mois';

  @override
  String get gundemRepeatYearly => 'Tous les ans';

  @override
  String get gundemPreviewCalcTableLabel => '[Liste de calcul]';

  @override
  String get gundemPreviewDrawingLabel => '[Dessin]';

  @override
  String get gundemPreviewImageLabel => '[Image]';

  @override
  String get gundemMonthShortJan => 'janv.';

  @override
  String get gundemMonthShortFeb => 'févr.';

  @override
  String get gundemMonthShortMar => 'mars';

  @override
  String get gundemMonthShortApr => 'avr.';

  @override
  String get gundemMonthShortMay => 'mai';

  @override
  String get gundemMonthShortJun => 'juin';

  @override
  String get gundemMonthShortJul => 'juil.';

  @override
  String get gundemMonthShortAug => 'août';

  @override
  String get gundemMonthShortSep => 'sept.';

  @override
  String get gundemMonthShortOct => 'oct.';

  @override
  String get gundemMonthShortNov => 'nov.';

  @override
  String get gundemMonthShortDec => 'déc.';

  @override
  String get calendarAppBarTitle => 'Calendrier';

  @override
  String get calendarTodayButton => 'Aujourd\'hui';

  @override
  String get calendarLegendNoteLabel => 'Note';

  @override
  String get calendarLegendReminderLabel => 'Rappel';

  @override
  String get calendarTodayBadge => 'Aujourd\'hui';

  @override
  String get calendarEmptyDayMessage => 'Aucune note ni rappel pour ce jour.';

  @override
  String get calendarReminderHourlyLabel => 'Toutes les heures';

  @override
  String get calendarMonthJan => 'Janvier';

  @override
  String get calendarMonthFeb => 'Février';

  @override
  String get calendarMonthMar => 'Mars';

  @override
  String get calendarMonthApr => 'Avril';

  @override
  String get calendarMonthMay => 'Mai';

  @override
  String get calendarMonthJun => 'Juin';

  @override
  String get calendarMonthJul => 'Juillet';

  @override
  String get calendarMonthAug => 'Août';

  @override
  String get calendarMonthSep => 'Septembre';

  @override
  String get calendarMonthOct => 'Octobre';

  @override
  String get calendarMonthNov => 'Novembre';

  @override
  String get calendarMonthDec => 'Décembre';

  @override
  String get calendarWeekdayShortMon => 'lun.';

  @override
  String get calendarWeekdayShortTue => 'mar.';

  @override
  String get calendarWeekdayShortWed => 'mer.';

  @override
  String get calendarWeekdayShortThu => 'jeu.';

  @override
  String get calendarWeekdayShortFri => 'ven.';

  @override
  String get calendarWeekdayShortSat => 'sam.';

  @override
  String get calendarWeekdayShortSun => 'dim.';

  @override
  String get calendarWeekdayFullMonday => 'Lundi';

  @override
  String get calendarWeekdayFullTuesday => 'Mardi';

  @override
  String get calendarWeekdayFullWednesday => 'Mercredi';

  @override
  String get calendarWeekdayFullThursday => 'Jeudi';

  @override
  String get calendarWeekdayFullFriday => 'Vendredi';

  @override
  String get calendarWeekdayFullSaturday => 'Samedi';

  @override
  String get calendarWeekdayFullSunday => 'Dimanche';

  @override
  String get wrongPasswordDialogTitle => 'Mot de passe incorrect';

  @override
  String get wrongPasswordDialogMessage =>
      'Le mot de passe saisi est incorrect.';

  @override
  String get commonOkButton => 'OK';

  @override
  String get unlockCategoryAction => 'Déverrouiller';

  @override
  String get lockCategoryAction => 'Verrouiller';

  @override
  String get categoryUnlockedMessage => 'Verrou retiré';

  @override
  String get categoryLockedMessage => 'Dossier verrouillé';

  @override
  String get deleteFolderMenuItemLabel => 'Supprimer le dossier';

  @override
  String get deleteFolderDialogTitle => 'Supprimer le dossier';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'Voulez-vous vraiment supprimer le dossier « $category » et tous ses sous-dossiers ? Les notes de ces dossiers deviendront non classées.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'Voulez-vous vraiment supprimer le dossier « $category » ? Les notes de ce dossier deviendront non classées.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'Annuler';

  @override
  String get deleteFolderDialogConfirmButton => 'Supprimer';

  @override
  String get editCategoryNameColorMenuItemLabel =>
      'Modifier le nom / la couleur';

  @override
  String get addSubfolderMenuItemLabel => 'Créer un sous-dossier';

  @override
  String get expandSubfoldersMenuItemLabel => 'Développer les sous-dossiers';

  @override
  String get collapseSubfoldersMenuItemLabel => 'Réduire les sous-dossiers';

  @override
  String saveErrorInfoMessage(String error) {
    return 'Erreur d\'enregistrement : $error';
  }

  @override
  String get welcomeNoteTitle => 'Bienvenue sur Layout ! 🚀';

  @override
  String get welcomeNoteContent =>
      'De nouvelles fonctionnalités ont été ajoutées !';

  @override
  String get noteListDateGroupToday => 'Aujourd\'hui';

  @override
  String get noteListDateGroupYesterday => 'Hier';

  @override
  String get noteListDateGroupLast7Days => '7 derniers jours';

  @override
  String get noteListDateGroupLast30Days => '30 derniers jours';

  @override
  String get reminderRepeatNoneLabel => 'Aucune répétition';

  @override
  String get voiceRecorderPreparingLabel => 'Préparation…';

  @override
  String get voiceRecorderCancelButton => 'Annuler';

  @override
  String get voiceRecorderStopAddButton => 'Arrêter et ajouter';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'L\'autorisation du microphone n\'a pas été accordée.';

  @override
  String get speechToTextUnavailableMessage =>
      'La reconnaissance vocale n\'est pas disponible sur cet appareil.';

  @override
  String get speechToTextPreparingLabel => 'Préparation…';

  @override
  String get speechToTextListeningLabel => 'Écoute en cours…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'Commencez à parler…';

  @override
  String get speechToTextCancelButton => 'Annuler';

  @override
  String get speechToTextStopAddButton => 'Arrêter et ajouter';

  @override
  String get textToSpeechNoContentMessage => 'Il n\'y a aucun contenu à lire.';

  @override
  String get textToSpeechReadErrorMessage =>
      'Une erreur s\'est produite pendant la lecture.';

  @override
  String get textToSpeechUnavailableMessage =>
      'La lecture à voix haute n\'est pas disponible sur cet appareil.';

  @override
  String get textToSpeechPreparingLabel => 'Préparation…';

  @override
  String get textToSpeechPausedLabel => 'En pause';

  @override
  String get textToSpeechFinishedLabel => 'Lecture terminée';

  @override
  String get textToSpeechReadingLabel => 'Lecture en cours…';

  @override
  String get textToSpeechCloseErrorButton => 'Fermer';

  @override
  String get textToSpeechReplayButton => 'Relire';

  @override
  String get textToSpeechCloseFinishedButton => 'Fermer';

  @override
  String get textToSpeechPauseButton => 'Pause';

  @override
  String get textToSpeechResumeButton => 'Reprendre';

  @override
  String get textToSpeechStopButton => 'Arrêter';

  @override
  String get textToSpeechSpeedSlow => 'Lent';

  @override
  String get textToSpeechSpeedNormal => 'Normal';

  @override
  String get textToSpeechSpeedFast => 'Rapide';

  @override
  String get calendarPickerCancelButton => 'Annuler';

  @override
  String get calendarPickerConfirmButton => 'Sélectionner';

  @override
  String get calendarPickerClearButton => 'Effacer';

  @override
  String get reminderPickerDialogTitle => 'Ajouter un rappel';

  @override
  String get reminderPickerDateTodayOption => 'Aujourd\'hui';

  @override
  String get reminderPickerDateTomorrowOption => 'Demain';

  @override
  String get reminderPickerDatePickOption => 'Choisir une date';

  @override
  String get reminderRepeatHourlyLabel => 'Toutes les heures';

  @override
  String get reminderRepeatDailyLabel => 'Tous les jours';

  @override
  String get reminderRepeatWeeklyLabel => 'Toutes les semaines';

  @override
  String get reminderRepeatMonthlyLabel => 'Tous les mois';

  @override
  String get reminderRepeatYearlyLabel => 'Tous les ans';

  @override
  String get reminderPickerCalendarHelpText => 'Choisir la date de rappel';

  @override
  String get reminderPickerCancelButton => 'ANNULER';

  @override
  String get reminderPickerSaveButton => 'ENREGISTRER';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'Une heure passée ne peut pas être sélectionnée';

  @override
  String calcTableTotalLabel(String amount) {
    return 'Total : $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'Préparation des données...';

  @override
  String get backupCreatePackagingNotesLabel =>
      'Empaquetage des notes et catégories...';

  @override
  String get backupCreateReadingAttachmentsLabel =>
      'Lecture des pièces jointes...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'Lecture des pièces jointes... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'Compression du fichier zip...';

  @override
  String get backupCreateSavingFileLabel => 'Enregistrement du fichier...';

  @override
  String get backupRestoreValidatingLabel => 'Validation de la sauvegarde...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'Sauvegarde validée, préparation des données...';

  @override
  String get backupRestoreWritingNotesLabel => 'Écriture des notes...';

  @override
  String get backupRestoreWritingTrashLabel => 'Écriture de la corbeille...';

  @override
  String get backupRestoreTrashWrittenLabel => 'Corbeille écrite';

  @override
  String get backupRestoreWritingCategoriesLabel =>
      'Écriture des catégories...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'Catégories écrites';

  @override
  String get backupRestoreWritingSettingsLabel => 'Écriture des paramètres...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'Paramètres écrits';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'Nettoyage des anciennes pièces jointes...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'Aucune pièce jointe trouvée, finalisation...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'Restauration des pièces jointes... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'Terminé';

  @override
  String get backupValidationCorruptedFileMessage =>
      'Le fichier est corrompu ou n\'est pas un fichier de sauvegarde valide.';

  @override
  String get backupValidationMissingDataMessage =>
      'Aucune donnée trouvée dans le fichier de sauvegarde (backup_data.json manquant).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'Les données de sauvegarde n\'ont pas pu être lues (JSON corrompu).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'Ce fichier n\'est pas une sauvegarde de l\'application layout.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'Les informations de version du fichier de sauvegarde n\'ont pas pu être lues.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'Cette sauvegarde est dans un format plus récent que celui pris en charge par la version actuelle de l\'application. Veuillez mettre à jour l\'application.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'Les informations de version du fichier de sauvegarde sont invalides.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'Les données de sauvegarde ne sont pas au format attendu (champ des notes manquant).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'Les données de sauvegarde ne sont pas au format attendu (champ de la corbeille manquant).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'Les données de sauvegarde ne sont pas au format attendu (liste de catégories invalide).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'Les données de sauvegarde ne sont pas au format attendu (champ des paramètres invalide).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'Les données de sauvegarde ne sont pas au format attendu (un enregistrement de note est invalide).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'Les données de sauvegarde ne sont pas au format attendu (un enregistrement de note sans identifiant a été trouvé).';

  @override
  String get backupValidationFileNotFoundMessage =>
      'Fichier de sauvegarde introuvable.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'Espace de stockage insuffisant sur l\'appareil. Veuillez libérer de l\'espace et réessayer.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'L\'autorisation d\'accès aux fichiers a été refusée. Veuillez vérifier les autorisations de l\'application et réessayer.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'Une erreur s\'est produite lors de l\'opération sur le fichier : $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'Une erreur inattendue s\'est produite : $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'Impossible de créer l\'archive zip (ZipEncoder a retourné null).';

  @override
  String get calcTableMenuItemLabel => 'Liste de calcul';

  @override
  String get tagsMenuItemLabel => 'Étiquettes';

  @override
  String get linkDialogUrlHint => 'https://exemple.com';

  @override
  String get checklistItemHint => 'Ajouter un élément...';

  @override
  String get toolbarHighlightTooltip => 'Surligner';

  @override
  String get toolbarListTooltip => 'Liste';

  @override
  String get toolbarHideKeyboardTooltip => 'Masquer le clavier';

  @override
  String get autoBackupLocalSuccessMessage => 'Sauvegarde locale réussie.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'Échec de la sauvegarde locale : $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Sauvegarde Drive ignorée : le compte Google n\'est pas connecté ou la session a expiré. Veuillez ouvrir l\'application et vous reconnecter.';

  @override
  String get autoBackupDriveSuccessMessage => 'Sauvegarde Drive réussie.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Échec de la sauvegarde Drive : $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'Pas encore de note';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'Total : $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ Dessin';

  @override
  String get autoBackupSettingsAppBarTitle =>
      'Paramètres de sauvegarde automatique';

  @override
  String get autoBackupSettingsMainSwitchTitle =>
      'Activer la sauvegarde automatique';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'Vos notes sont sauvegardées en toute sécurité et périodiquement en arrière-plan.';

  @override
  String get autoBackupSettingsTargetTitle => 'Destination de la sauvegarde';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'Choisissez où les sauvegardes seront enregistrées.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'Local';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'Les deux';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Connectez d\'abord votre compte pour utiliser les options Google Drive.';

  @override
  String get autoBackupSettingsConnectButton => 'Connecter';

  @override
  String get autoBackupSettingsFrequencyTitle => 'Fréquence de sauvegarde';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'Une sauvegarde est effectuée toutes les $hours heures.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 heures';

  @override
  String get autoBackupSettingsFrequency12h => '12 heures';

  @override
  String get autoBackupSettingsFrequency24h => '24 heures (quotidien)';

  @override
  String get autoBackupSettingsFrequency48h => '48 heures (2 jours)';

  @override
  String get autoBackupSettingsFrequency168h => '168 heures (hebdomadaire)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle =>
      'Utiliser uniquement le Wi-Fi';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'Le téléversement cloud n\'a lieu que via le Wi-Fi pour préserver vos données mobiles.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'État du système';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'La sauvegarde automatique ne s\'est pas encore exécutée.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'Dernière exécution : $date $time ($status)\nMessage : $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'Réussie';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'Échouée';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Impossible de se connecter au compte Google.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'Paramètres de sauvegarde automatique mis à jour.';

  @override
  String selectionModeDeletedMessage(int count) {
    return '$count note(s) supprimée(s)';
  }

  @override
  String get selectionModeArchivedMessage => 'Archivée(s)';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'Choisir une catégorie pour $count note(s)';
  }

  @override
  String get selectionModeAddCategoryOption => 'Ajouter une catégorie';

  @override
  String get selectionModeRemoveCategoryOption => 'Retirer la catégorie';

  @override
  String get calcTableItemHint => 'Article...';

  @override
  String get calcTableTotalRowLabel => 'Total';

  @override
  String get textSelectionMenuShareButton => 'Partager';

  @override
  String get textSelectionMenuTranslateButton => 'Traduire';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'Le partage n\'a pas pu démarrer.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'La traduction n\'a pas pu s\'ouvrir.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'Aujourd\'hui $time';
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
    return 'Dernière sauvegarde : $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage =>
      'Aucune sauvegarde n\'a encore été effectuée.';

  @override
  String get backupFileNameLabel => 'Sauvegarde';
}
