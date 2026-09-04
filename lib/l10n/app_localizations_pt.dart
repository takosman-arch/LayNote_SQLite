// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'Negrito';

  @override
  String get toolbarItalicTooltip => 'Itálico';

  @override
  String get toolbarUnderlineTooltip => 'Sublinhado';

  @override
  String get toolbarStrikethroughTooltip => 'Rasurado';

  @override
  String get toolbarFontSizeTooltip => 'Tamanho da Fonte';

  @override
  String get toolbarColorTooltip => 'Cor do Texto';

  @override
  String get toolbarBulletTooltip => 'Lista com Marcadores';

  @override
  String get toolbarNumberTooltip => 'Lista Numerada';

  @override
  String get toolbarIndentTooltip => 'Recuo de Parágrafo';

  @override
  String get toolbarLinkTooltip => 'Adicionar / Editar / Remover Link';

  @override
  String get toolbarDividerTooltip => 'Inserir Divisor';

  @override
  String get toolbarChecklistTooltip => 'Adicionar Lista de Verificação';

  @override
  String get linkSelectTextSnackbar =>
      'Selecione primeiro o texto que deseja vincular';

  @override
  String get linkDialogEditTitle => 'Editar Link';

  @override
  String get linkDialogAddTitle => 'Adicionar Link';

  @override
  String get linkDialogRemoveButton => 'Remover Link';

  @override
  String get linkDialogCancelButton => 'Cancelar';

  @override
  String get linkDialogConfirmButton => 'Adicionar';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Permissão de câmara negada. É necessário permiti-la nas definições para gravar vídeo.';

  @override
  String get cameraPermissionRequiredMessage =>
      'É necessária permissão de câmara para gravar vídeo.';

  @override
  String get openSettingsButtonLabel => 'Definições';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'Não foi possível iniciar a digitalização: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'Falha no reconhecimento de texto: $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'Não foi encontrado texto legível no documento';

  @override
  String get scanResultSheetTitle =>
      'Como deseja adicionar o documento digitalizado?';

  @override
  String get scanResultTextOnlyOption => 'Adicionar apenas como texto';

  @override
  String get scanResultTextAndImageOption =>
      'Adicionar texto + imagem digitalizada';

  @override
  String get scanResultCancelOption => 'Cancelar';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'Permissão de microfone negada. É necessário permiti-la nas definições para gravar áudio.';

  @override
  String get audioPermissionRequiredMessage =>
      'É necessária permissão de microfone para gravar áudio.';

  @override
  String get voiceRecordingDefaultLabel => 'Gravação de Voz';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'Lista de Cálculo ($count linhas)';
  }

  @override
  String blockPreviewTableLabel(int count) {
    return 'Tabela ($count linhas)';
  }

  @override
  String get blockPreviewDrawingLabel => 'Desenho';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count anexos (foto/documento)';
  }

  @override
  String get blockPreviewDividerLabel => 'Divisor';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'Lista de Verificação ($count itens)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(texto vazio)';

  @override
  String get reorderBlocksSheetTitle => 'Reordenar Blocos';

  @override
  String get reorderBlocksMoveUpTooltip => 'Mover para Cima';

  @override
  String get reorderBlocksMoveDownTooltip => 'Mover para Baixo';

  @override
  String get reorderBlocksCloseTooltip => 'Fechar';

  @override
  String get reorderBlocksDescription =>
      'Toque num bloco para selecioná-lo e use as setas para cima/baixo para movê-lo.';

  @override
  String get reorderBlocksMenuItemLabel => 'Reordenar';

  @override
  String get txtImportPickerDialogTitle =>
      'Selecione o ficheiro TXT a importar';

  @override
  String get txtImportReadFailedMessage =>
      'Não foi possível ler o ficheiro TXT';

  @override
  String get txtImportEmptyFileMessage => 'O ficheiro TXT está vazio';

  @override
  String get txtImportSuccessMessage => 'TXT importado';

  @override
  String get txtImportMenuItemLabel => 'Importar (txt)';

  @override
  String get exportMenuItemLabel => 'Exportar';

  @override
  String get editorUndoTooltip => 'Desfazer';

  @override
  String get editorRedoTooltip => 'Refazer';

  @override
  String get noteSavedMessage => 'Nota guardada';

  @override
  String get dateAssignPickerHelpText => 'Atribuir nota a um dia';

  @override
  String get dateAssignChangeOption => 'Alterar data';

  @override
  String get dateAssignRemoveOption => 'Remover atribuição';

  @override
  String get editorSubToolbarCloseTooltip => 'Fechar';

  @override
  String get titleFieldHint => 'Título';

  @override
  String get textBlockHint => 'Escreva a sua nota aqui...';

  @override
  String get drawingBoardMenuItemLabel => 'Quadro de Desenho';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'A conversão de voz em texto só está disponível para notas de texto';

  @override
  String get selectionModeCancelTooltip => 'Cancelar Seleção';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return '$count selecionadas';
  }

  @override
  String get selectionModeDeleteTooltip => 'Eliminar';

  @override
  String get selectionModeArchiveTooltip => 'Arquivar';

  @override
  String get selectionModeFolderTooltip => 'Pasta';

  @override
  String get searchFieldHint => 'Pesquisar notas...';

  @override
  String get emptyTrashDialogTitle => 'Esvaziar Lixo';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'Todas as notas eliminadas serão removidas permanentemente. Tem a certeza?';

  @override
  String get emptyTrashDialogCancelButton => 'Cancelar';

  @override
  String get restoreAllMenuItemLabel => 'Restaurar Tudo';

  @override
  String get sortMenuTooltip => 'Ordenar Notas';

  @override
  String get sortMenuAscendingLabel => 'Ordem: Crescente (A-Z)';

  @override
  String get sortMenuDescendingLabel => 'Ordem: Decrescente (Z-A)';

  @override
  String get sortMenuByTitleLabel => 'Ordenar por: Título';

  @override
  String get sortMenuByModifiedDateLabel => 'Ordenar por: Última Modificação';

  @override
  String get sortMenuByCreatedDateLabel => 'Ordenar por: Data de Criação';

  @override
  String get sortMenuByFolderLabel => 'Ordenar por: Pasta';

  @override
  String get viewToggleGridTooltip => 'Vista em Grelha';

  @override
  String get viewToggleListTooltip => 'Vista em Lista';

  @override
  String get drawerHeaderSubtitle => 'O Seu Caderno Pessoal';

  @override
  String get drawerNotesSectionHeader => 'NOTAS';

  @override
  String get drawerAllNotesLabel => 'Notas';

  @override
  String get drawerFavoritesLabel => 'Favoritas';

  @override
  String get drawerAgendaLabel => 'Agenda';

  @override
  String get drawerRemindersLabel => 'Lembretes';

  @override
  String get drawerLockedLabel => 'Bloqueadas';

  @override
  String get drawerTrashLabel => 'Lixo';

  @override
  String get drawerFoldersSectionHeader => 'PASTAS';

  @override
  String get drawerExpandLabel => 'Expandir';

  @override
  String get drawerCollapseLabel => 'Colapsar';

  @override
  String get drawerAddFolderLabel => 'Adicionar Pasta';

  @override
  String get drawerAppSectionHeader => 'APLICAÇÃO';

  @override
  String get drawerCalendarLabel => 'Calendário';

  @override
  String get drawerSettingsLabel => 'Definições';

  @override
  String get drawerBackupRestoreLabel => 'Cópia de Segurança e Restauro';

  @override
  String get drawerUpgradeToProLabel => 'Atualizar para Pro';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'Apoiar o Desenvolvimento';

  @override
  String get drawerFeedbackLabel => 'Comentários';

  @override
  String get drawerRateAppLabel => 'Avaliar a Aplicação';

  @override
  String get drawerAboutLabel => 'Sobre';

  @override
  String get noNotesFoundMessage => 'Nenhuma nota encontrada.';

  @override
  String get trashRestoreButtonLabel => 'Restaurar';

  @override
  String get trashPermanentDeleteButtonLabel => 'Eliminar Permanentemente';

  @override
  String get tagRenamedInfoMessage => 'Etiqueta renomeada';

  @override
  String get tagDeletedInfoMessage => 'Etiqueta eliminada';

  @override
  String get tagOptionsRenameLabel => 'Renomear';

  @override
  String get tagOptionsDeleteLabel => 'Eliminar';

  @override
  String get renameTagDialogTitle => 'Renomear Etiqueta';

  @override
  String get renameTagDialogHint => 'Novo nome da etiqueta';

  @override
  String get renameTagDialogCancelButton => 'Cancelar';

  @override
  String get renameTagDialogSaveButton => 'Guardar';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '\"$tag\" será removida de $affectedCount notas. Continuar?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return 'Eliminar a etiqueta \"$tag\"?';
  }

  @override
  String get deleteTagDialogTitle => 'Eliminar Etiqueta';

  @override
  String get deleteTagDialogCancelButton => 'Cancelar';

  @override
  String get deleteTagDialogConfirmButton => 'Eliminar';

  @override
  String get tagsSheetTitle => 'Etiquetas';

  @override
  String get tagsSheetEmptyMessage => 'Esta nota ainda não tem etiquetas.';

  @override
  String get tagsSheetInputHint => 'Escreva uma nova etiqueta...';

  @override
  String get tagsSheetSuggestionsLabel => 'Etiquetas existentes';

  @override
  String get noteDeletedInfoMessage => 'Nota eliminada';

  @override
  String get noteDeletedUndoActionLabel => 'Desfazer';

  @override
  String get reminderSetInfoMessage => 'Lembrete definido';

  @override
  String get reminderRemovedInfoMessage => 'Lembrete removido';

  @override
  String get noteDuplicatedInfoMessage => 'Cópia criada';

  @override
  String get speechTextAppendedInfoMessage => 'Texto adicionado à nota';

  @override
  String get pdfPreparingInfoMessage => 'A preparar PDF…';

  @override
  String get pdfSavedInfoMessage => 'PDF guardado';

  @override
  String get pdfPreviewSaveActionLabel => 'Salvar';

  @override
  String get jpgPreparingInfoMessage => 'A preparar JPG…';

  @override
  String get jpgSavedInfoMessage => 'JPG guardado';

  @override
  String get jpgFailedInfoMessage => 'Não foi possível criar o JPG';

  @override
  String get txtPreparingInfoMessage => 'A preparar TXT…';

  @override
  String get txtSavedInfoMessage => 'TXT guardado';

  @override
  String get txtFailedInfoMessage => 'Não foi possível criar o TXT';

  @override
  String get exportOpenActionLabel => 'Abrir';

  @override
  String get wrongPasswordInfoMessage => 'Palavra-passe incorreta.';

  @override
  String get noteArchivedInfoMessage => 'Nota arquivada';

  @override
  String get noteUnarchivedInfoMessage => 'Removida do arquivo';

  @override
  String get noteUnlockedInfoMessage => 'Desbloqueada';

  @override
  String get noteLockedInfoMessage => 'Nota bloqueada';

  @override
  String get notificationUnpinnedInfoMessage => 'Desafixada';

  @override
  String get emptyNotePinBlockedInfoMessage =>
      'Uma nota vazia não pode ser afixada.';

  @override
  String get notificationPinnedInfoMessage =>
      'Afixada no painel de notificações';

  @override
  String get noContentToReadInfoMessage => 'Não há conteúdo para ler';

  @override
  String get backPressExitInfoMessage => 'Prima voltar novamente para sair';

  @override
  String get reminderChannelName => 'Lembretes de Notas';

  @override
  String get reminderChannelDescription =>
      'Lembretes de notas na aplicação Layout';

  @override
  String get pinnedChannelName => 'Notas Afixadas';

  @override
  String get pinnedChannelDescription =>
      'Notas do Layout afixadas no painel de notificações';

  @override
  String get notificationUnpinActionLabel => 'Remover';

  @override
  String get reminderDefaultTitle => 'Lembrete';

  @override
  String get reminderChecklistBodyFallback =>
      'Não se esqueça de verificar a sua lista de verificação';

  @override
  String get reminderTextBodyFallback =>
      'Não se esqueça de verificar a sua nota';

  @override
  String get pdfSaveDialogTitle => 'Guardar como PDF';

  @override
  String get jpgSaveDialogTitle => 'Guardar como JPG';

  @override
  String get txtSaveDialogTitle => 'Guardar como TXT';

  @override
  String get textSizeSheetTitle => 'Tamanho do Texto';

  @override
  String get textSizeSamplePreview => 'Texto de exemplo';

  @override
  String get textSizeCancelButton => 'Cancelar';

  @override
  String get textSizeApplyButton => 'Aplicar';

  @override
  String get createPasswordDialogTitle => 'Criar Palavra-passe';

  @override
  String get createPasswordNewPasswordHint => 'Nova palavra-passe';

  @override
  String get createPasswordConfirmHint => 'Repita a palavra-passe';

  @override
  String get createPasswordHintQuestionDescription =>
      'Defina uma pergunta de segurança para o caso de esquecer a sua palavra-passe (opcional).';

  @override
  String get createPasswordHintQuestionHint =>
      'Escolha uma pergunta de segurança';

  @override
  String get createPasswordHintAnswerHint => 'A sua resposta';

  @override
  String get createPasswordCancelButton => 'Cancelar';

  @override
  String get createPasswordSaveButton => 'Guardar';

  @override
  String get passwordMismatchMessage => 'As palavras-passe não coincidem!';

  @override
  String get passwordRequiredDialogTitle => 'Palavra-passe Necessária';

  @override
  String get passwordRequiredHint => 'Introduza a palavra-passe';

  @override
  String get forgotPasswordButtonLabel => 'Esqueci-me da palavra-passe';

  @override
  String get passwordRequiredCancelButton => 'Cancelar';

  @override
  String get passwordRequiredConfirmButton => 'Verificar';

  @override
  String get securityQuestionDialogTitle => 'Pergunta de Segurança';

  @override
  String get securityQuestionAnswerHint => 'A sua resposta';

  @override
  String get securityQuestionCancelButton => 'Cancelar';

  @override
  String get securityQuestionConfirmButton => 'Confirmar';

  @override
  String get securityQuestionWrongAnswerMessage =>
      'Resposta incorreta. Tente novamente.';

  @override
  String get revealedPasswordDialogTitle => 'A Sua Palavra-passe';

  @override
  String get revealedPasswordLabel => 'A palavra-passe da sua nota:';

  @override
  String get revealedPasswordOkButton => 'OK';

  @override
  String get securityQuestionPetName =>
      'Qual é o nome do seu primeiro animal de estimação?';

  @override
  String get securityQuestionFavoriteTeacher =>
      'Qual é o nome do seu professor favorito?';

  @override
  String get securityQuestionBirthCity => 'Em que cidade nasceu?';

  @override
  String get securityQuestionFavoriteFood => 'Qual é a sua comida favorita?';

  @override
  String get securityQuestionMotherMaidenName =>
      'Qual é o nome de solteira da sua mãe?';

  @override
  String get securityQuestionFirstSchool =>
      'Qual é o nome da primeira escola que frequentou?';

  @override
  String get securityQuestionFavoriteColor => 'Qual é a sua cor favorita?';

  @override
  String get editFolderDialogTitle => 'Editar Pasta';

  @override
  String get newSubfolderDialogTitle => 'Nova Subpasta';

  @override
  String get addFolderDialogTitle => 'Adicionar Pasta';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'Será criada dentro de \"$parentCategory\"';
  }

  @override
  String get subfolderNameFieldLabel => 'Nome da subpasta';

  @override
  String get folderNameFieldLabel => 'Nome da pasta';

  @override
  String get folderColorLabel => 'Cor';

  @override
  String get folderDialogCancelButton => 'Cancelar';

  @override
  String get folderDialogSaveButton => 'Guardar';

  @override
  String get folderDialogAddButton => 'Adicionar';

  @override
  String get selectFolderSheetTitle => 'Selecionar Pasta';

  @override
  String get selectFolderAddOptionLabel => 'Adicionar Pasta';

  @override
  String get removeCurrentFolderLabel => 'Remover Pasta Atual';

  @override
  String get noteDetailsDialogTitle => 'Detalhes';

  @override
  String get noteDetailsCreatedLabel => 'Criada';

  @override
  String get noteDetailsModifiedLabel => 'Última Modificação';

  @override
  String get noteDetailsCharCountLabel => 'Número de Caracteres';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count caracteres';
  }

  @override
  String get noteDetailsWordCountLabel => 'Número de Palavras';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count palavras';
  }

  @override
  String get noteDetailsOkButton => 'OK';

  @override
  String get noteDetailsUnknownDateLabel => 'Desconhecida';

  @override
  String get addAttachmentSheetTitle => 'Adicionar';

  @override
  String get addAttachmentImageOption => 'Adicionar Imagem';

  @override
  String get addAttachmentCameraOption => 'Câmara';

  @override
  String get addAttachmentFileOption => 'Adicionar Ficheiro';

  @override
  String get addAttachmentVoiceOption => 'Gravação de Voz';

  @override
  String get addAttachmentVideoOption => 'Gravar Vídeo';

  @override
  String get addAttachmentScanOption => 'Digitalizar Documento';

  @override
  String get noteActionsSheetTitle => 'Escolher Ação';

  @override
  String get noteActionReminderLabel => 'Lembrete';

  @override
  String get noteActionEditReminderLabel => 'Editar Lembrete';

  @override
  String get noteActionSpeechToTextLabel => 'Voz para Texto';

  @override
  String get noteActionArchiveLabel => 'Arquivar';

  @override
  String get noteActionUnarchiveLabel => 'Remover do Arquivo';

  @override
  String get noteActionLockLabel => 'Bloquear';

  @override
  String get noteActionUnlockLabel => 'Desbloquear';

  @override
  String get noteActionFavoriteLabel => 'Adicionar aos Favoritos';

  @override
  String get noteActionUnfavoriteLabel => 'Remover dos Favoritos';

  @override
  String get noteActionClassifyLabel => 'Selecionar Pasta';

  @override
  String get noteActionDeleteLabel => 'Eliminar';

  @override
  String get noteActionPinToNotificationLabel =>
      'Afixar no Painel de Notificações';

  @override
  String get noteActionUnpinFromNotificationLabel => 'Remover Afixação';

  @override
  String get noteActionShareLabel => 'Partilhar';

  @override
  String get noteActionDuplicateLabel => 'Criar Cópia';

  @override
  String get noteActionCopyContentLabel => 'Copiar Conteúdo';

  @override
  String get noteActionTtsLabel => 'Ler em Voz Alta';

  @override
  String get noteActionTextSizeLabel => 'Tamanho do Texto';

  @override
  String get noteActionDetailsLabel => 'Detalhes';

  @override
  String get noteActionDiscardChangesLabel => 'Descartar Alterações';

  @override
  String get noteActionSelectLabel => 'Selecionar';

  @override
  String get reminderEditOptionLabel => 'Alterar lembrete';

  @override
  String get reminderRemoveOptionLabel => 'Remover lembrete';

  @override
  String get discardChangesDialogTitle => 'Descartar Alterações';

  @override
  String get discardChangesDialogMessage =>
      'As alterações não guardadas nesta nota serão perdidas. Tem a certeza de que deseja descartá-las?';

  @override
  String get discardChangesCancelButton => 'Cancelar';

  @override
  String get discardChangesConfirmButton => 'Descartar';

  @override
  String get pinnedNotificationDefaultTitle => 'Nota';

  @override
  String get pdfFailedInfoMessage => 'Falha ao criar o PDF';

  @override
  String get drawingScreenTitle => 'Desenho';

  @override
  String get drawingMinimizeTooltip => 'Minimizar';

  @override
  String get drawingEmptyExportWarningMessage => 'Desenhe algo primeiro';

  @override
  String get drawingEraserPartialModeLabel => 'Parcial';

  @override
  String get drawingEraserFullModeLabel => 'Total';

  @override
  String get drawingClearTooltip => 'Limpar';

  @override
  String get drawingZoomOutTooltip => 'Diminuir Zoom';

  @override
  String get drawingZoomInTooltip => 'Aumentar Zoom';

  @override
  String get drawingDeleteTooltip => 'Eliminar';

  @override
  String get drawingEmptyPreviewHint => 'Toque para desenhar';

  @override
  String get settingsPageTitle => 'Definições';

  @override
  String get settingsSectionGeneral => 'Geral';

  @override
  String get settingsSectionSecurity => 'Segurança';

  @override
  String get settingsSectionTheme => 'Tema';

  @override
  String get settingsSectionPersonalization => 'Personalização';

  @override
  String get settingsSectionWidget => 'Widget';

  @override
  String get settingsSectionAbout => 'Sobre';

  @override
  String get settingsHintQuestionPet =>
      'Qual é o nome do seu primeiro animal de estimação?';

  @override
  String get settingsHintQuestionTeacher =>
      'Qual é o nome do seu professor favorito?';

  @override
  String get settingsHintQuestionBirthCity => 'Em que cidade nasceu?';

  @override
  String get settingsHintQuestionFavoriteFood =>
      'Qual é a sua comida favorita?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      'Qual é o nome de solteira da sua mãe?';

  @override
  String get settingsHintQuestionFirstSchool =>
      'Qual foi a primeira escola que frequentou?';

  @override
  String get settingsHintQuestionFavoriteColor => 'Qual é a sua cor favorita?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'Pergunta de Segurança';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'Se se esquecer da sua palavra-passe, pode recuperá-la respondendo corretamente a esta pergunta.';

  @override
  String get settingsSecurityQuestionDropdownHint =>
      'Escolha uma pergunta de segurança';

  @override
  String get settingsSecurityQuestionAnswerHint => 'A sua resposta';

  @override
  String get settingsSecurityQuestionCancelButton => 'Cancelar';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      'A pergunta e a resposta não podem estar vazias!';

  @override
  String get settingsSecurityQuestionSaveButton => 'Guardar';

  @override
  String get settingsCreatePasswordTitle => 'Criar Palavra-passe';

  @override
  String get settingsPasswordRequiredTitle => 'Palavra-passe Necessária';

  @override
  String get settingsPasswordEnterHint => 'Introduza a palavra-passe';

  @override
  String get settingsForgotPasswordButton => 'Esqueci-me da palavra-passe';

  @override
  String get settingsNewPasswordHint => 'Nova palavra-passe';

  @override
  String get settingsConfirmPasswordHint => 'Repita a palavra-passe';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'Defina uma pergunta de segurança para o caso de esquecer a sua palavra-passe (opcional).';

  @override
  String get settingsPasswordDialogCancelButton => 'Cancelar';

  @override
  String get settingsPasswordMismatchWarning =>
      'As palavras-passe não coincidem!';

  @override
  String get settingsWrongPasswordWarning => 'Palavra-passe incorreta!';

  @override
  String get settingsPasswordSaveButton => 'Guardar';

  @override
  String get settingsPasswordRemoveButton => 'Remover';

  @override
  String get settingsNotePasswordTitle => 'Palavra-passe da Nota';

  @override
  String get settingsPasswordSetSubtitle => 'Palavra-passe definida ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'Palavra-passe não definida';

  @override
  String get settingsSecurityQuestionTileTitle => 'Pergunta de Segurança';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'Definida ✓ — utilizada se se esquecer da palavra-passe';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'Não definida — não poderá recuperar a sua palavra-passe se a perder';

  @override
  String get settingsThemeDialogTitle => 'Selecionar Tema';

  @override
  String get settingsThemeSystemDefault => 'Predefinição do Sistema';

  @override
  String get settingsThemeLightOption => 'Tema Claro';

  @override
  String get settingsThemeDarkOption => 'Tema Escuro';

  @override
  String get settingsLanguageDialogTitle => 'Selecionar Idioma';

  @override
  String get settingsLanguageSystemOption => 'Sistema';

  @override
  String get settingsAccentColorDialogTitle => 'Escolher Cor de Destaque';

  @override
  String get settingsThemeChangeTileTitle => 'Alterar Tema';

  @override
  String get settingsThemeLightLabel => 'Claro';

  @override
  String get settingsThemeDarkLabel => 'Escuro';

  @override
  String get settingsThemeSystemLabel => 'Sistema';

  @override
  String get settingsLanguageTileTitle => 'Idioma';

  @override
  String get settingsAccentColorTileTitle => 'Cor de Destaque';

  @override
  String get settingsAccentColorTileSubtitle =>
      'Cor utilizada na barra da aplicação, botões e interruptores';

  @override
  String get settingsColorfulNotesTitle => 'Cores Variadas das Notas';

  @override
  String get settingsColorfulNotesSubtitle =>
      'Cada cartão de nota recebe um tom de cor diferente.';

  @override
  String get settingsTextColorSheetTitle => 'Cor do Texto';

  @override
  String get settingsTextColorSheetDesc =>
      'Define a cor do texto do conteúdo da nota.';

  @override
  String get settingsTextColorOkButton => 'OK';

  @override
  String get settingsTextColorTileTitle => 'Cor do Texto';

  @override
  String get settingsTextColorTileSubtitle =>
      'Cor do texto do conteúdo da nota.';

  @override
  String get settingsWidgetFontSizeLabel => 'Tamanho da Fonte do Widget';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'Título de exemplo - $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'Cancelar';

  @override
  String get settingsWidgetFontSizeApplyButton => 'Aplicar';

  @override
  String get settingsWidgetOpacityLabel => 'Transparência do Fundo';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return '$percent% de transparência';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'Cancelar';

  @override
  String get settingsWidgetOpacityApplyButton => 'Aplicar';

  @override
  String get settingsWidgetDarkModeTitle => 'Widget Escuro';

  @override
  String get settingsWidgetDarkModeDesc =>
      'Esquema de cores escuro para o widget.';

  @override
  String get settingsAboutVersionTitle => 'Versão da Aplicação';

  @override
  String get settingsAboutVersionLoading => 'A carregar versão…';

  @override
  String get aboutSectionDeveloper => 'Feedback';

  @override
  String get aboutDeveloperTitle => 'Programador';

  @override
  String get aboutContactTitle => 'Contacto';

  @override
  String get aboutWebsiteTitle => 'Website';

  @override
  String get aboutGithubTitle => 'GitHub';

  @override
  String get aboutSectionLegal => 'Informações legais';

  @override
  String get aboutPrivacyPolicyTitle => 'Política de Privacidade';

  @override
  String get aboutTermsTitle => 'Termos de Utilização';

  @override
  String get aboutLicensesTitle => 'Licenças de Código Aberto';

  @override
  String get aboutSectionSupport => 'Avaliar';

  @override
  String get aboutRateAppTitle => 'Avaliar a Aplicação';

  @override
  String get aboutLinkOpenError => 'Não foi possível abrir o link.';

  @override
  String get settingsFontFamilyTileTitle => 'Fonte';

  @override
  String get settingsFontFamilyDefaultLabel => 'Predefinida';

  @override
  String get settingsGlobalFontSizeTileTitle => 'Tamanho da Fonte';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt — aplicado a todas as notas.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'Texto de exemplo - $size pt';
  }

  @override
  String get settingsGlobalFontSizeCancelButton => 'Cancelar';

  @override
  String get settingsGlobalFontSizeApplyButton => 'Aplicar';

  @override
  String get settingsPreviewLinesTileTitle =>
      'Linhas de Pré-visualização da Nota';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'Mostrar até $lines linhas. Se a nota for mais curta, é mostrado o número real de linhas.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'Atual: $lines linhas';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'Define o número máximo de linhas a pré-visualizar. Se a nota tiver menos linhas, é mostrado o número real de linhas.';

  @override
  String get settingsPreviewLinesCancelButton => 'Cancelar';

  @override
  String get settingsPreviewLinesApplyButton => 'Aplicar';

  @override
  String get backupCancelButton => 'Cancelar';

  @override
  String get backupConnectButton => 'Ligar';

  @override
  String get backupDisconnectButton => 'Desligar';

  @override
  String get backupContinueButton => 'Continuar';

  @override
  String get backupCloseButton => 'Fechar';

  @override
  String get backupShareButton => 'Partilhar';

  @override
  String get backupRestoreButton => 'Restaurar';

  @override
  String get backupConfigureButton => 'Configurar';

  @override
  String get backupUnknownDateLabel => 'Desconhecida';

  @override
  String get backupProcessingDefaultLabel => 'A processar...';

  @override
  String get backupPermissionRequiredTitle =>
      'Permissão de Armazenamento Necessária';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'Esta versão do Android requer permissão de armazenamento para cópia de segurança/restauro. Como a permissão foi negada permanentemente, ative-a manualmente nas definições da aplicação.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'Esta versão do Android requer permissão de armazenamento para cópia de segurança/restauro. Conceda a permissão para continuar.';

  @override
  String get backupGoToSettingsButton => 'Ir para as Definições';

  @override
  String get backupRetryButton => 'Tentar Novamente';

  @override
  String get backupDriveConnectingLabel => 'A ligar à conta Google...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Ligado à conta do Google Drive: $email';
  }

  @override
  String get backupDriveConnectedMessage => 'Ligado à conta do Google Drive.';

  @override
  String get backupDriveConnectFailedMessage =>
      'Não foi possível ligar à conta Google, ou a operação foi cancelada.';

  @override
  String get backupDriveDisconnectTitle => 'Desligar o Google Drive';

  @override
  String get backupDriveDisconnectBody =>
      'Se desligar, não será possível fazer cópias de segurança manuais ou automáticas para o Drive. As cópias de segurança já armazenadas no Drive não serão eliminadas — apenas o acesso a partir deste dispositivo será removido.';

  @override
  String get backupDriveDisconnectedMessage =>
      'Ligação ao Google Drive removida.';

  @override
  String get backupDriveRequiredTitle => 'Conta Google Necessária';

  @override
  String get backupDriveRequiredBody =>
      'Esta ação requer que ligue a sua conta Google. Deseja ligar agora?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: ligado ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: ligado';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: não ligado';

  @override
  String get backupDriveAuthenticatingLabel => 'A verificar a conta Google...';

  @override
  String get backupDriveNotSignedInMessage =>
      'Não está ligado ao Google Drive. Inicie sessão com a sua conta Google primeiro.';

  @override
  String get backupDriveUploadingLabel =>
      'A carregar a cópia de segurança para o Drive...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'O carregamento para o Google Drive não foi concluído em 120 segundos (sem resposta do servidor). Verifique a sua ligação e tente novamente.';

  @override
  String get backupDriveOperationCompletedLabel => 'Concluído';

  @override
  String get backupToDriveActionLabel => 'cópia de segurança para o Drive';

  @override
  String get backupToDeviceActionLabel => 'cópia de segurança';

  @override
  String get backupCreatingLabel => 'A criar cópia de segurança...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'Não foi possível criar a cópia de segurança: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Falha no carregamento para o Google Drive: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'Cópia de segurança carregada com sucesso para o Google Drive.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'Cópia de segurança criada: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'Cópia de Segurança Pronta';

  @override
  String get backupOfferShareBody =>
      'O ficheiro de cópia de segurança foi guardado no seu dispositivo. Deseja partilhá-lo agora (por exemplo, armazenamento na nuvem, e-mail, outro dispositivo)?';

  @override
  String get backupShareFileText => 'ficheiro de cópia de segurança do layout';

  @override
  String backupShareFailedMessage(String error) {
    return 'Não foi possível iniciar a partilha: $error';
  }

  @override
  String get backupLargeOperationTitle => 'Cópia de Segurança Grande';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'Os dados a processar têm aproximadamente $sizeText. Uma $actionLabel deste tamanho pode demorar algum tempo, dependendo do seu dispositivo. Apenas não saia da aplicação enquanto estiver em curso — deseja continuar?';
  }

  @override
  String get backupRestoreActionLabel => 'restauro';

  @override
  String get backupDriveListingLabel =>
      'A listar cópias de segurança do Drive...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'Não foi possível listar as cópias de segurança: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'Ainda não existem cópias de segurança no Google Drive.';

  @override
  String get backupDrivePickTitle => 'Escolher uma Cópia de Segurança do Drive';

  @override
  String get backupDriveDownloadingLabel =>
      'A transferir a cópia de segurança do Drive...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'A transferir a cópia de segurança do Drive... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel =>
      'A guardar o ficheiro no dispositivo...';

  @override
  String get backupDriveUnknownBackupFileName =>
      'copia_seguranca_desconhecida.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'O seu armazenamento do Google Drive está cheio. Liberte espaço no Drive e tente novamente.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'Não foi possível estabelecer uma ligação à Internet. Verifique a sua ligação e tente novamente.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'O ficheiro de cópia de segurança especificado não foi encontrado no Drive. Pode ter sido eliminado.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Ocorreu um erro inesperado durante a operação do Google Drive: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'Falha na transferência: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'Não foi possível selecionar o ficheiro: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'Não foi possível aceder ao ficheiro selecionado.';

  @override
  String get backupCheckingLabel => 'A verificar a cópia de segurança...';

  @override
  String backupReadFailedMessage(String error) {
    return 'Não foi possível ler o ficheiro de cópia de segurança: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'Restaurar Cópia de Segurança';

  @override
  String get backupPreviewContentsHeader =>
      'Conteúdo da cópia de segurança selecionada:';

  @override
  String get backupPreviewNoteCountLabel => 'Número de notas';

  @override
  String get backupPreviewTrashCountLabel => 'Notas no lixo';

  @override
  String get backupPreviewCategoryCountLabel => 'Número de categorias';

  @override
  String get backupPreviewAttachmentLabel => 'Anexos';

  @override
  String get backupPreviewAttachmentNoneValue => 'Nenhum';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count ficheiros ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'Criada em';

  @override
  String get backupEmptyPreviewTitle =>
      'Esta cópia de segurança parece estar vazia';

  @override
  String get backupEmptyPreviewBody =>
      'Não foram encontradas notas, categorias ou anexos no ficheiro selecionado. Se continuar, os seus dados atuais serão eliminados e substituídos por esta cópia de segurança vazia.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '$count anexos não encontrados na cópia de segurança';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'As notas com estes ficheiros serão restauradas, mas sem os anexos (podem estar em falta ou corrompidos no momento em que a cópia de segurança foi feita): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown e mais $remaining';
  }

  @override
  String get backupRestoreConfirmBody =>
      'Isto irá SUBSTITUIR todas as suas notas, lixo, categorias, definições e anexos atuais pelos dados da cópia de segurança acima. Os seus dados atuais serão perdidos permanentemente e esta ação não pode ser desfeita.';

  @override
  String get backupRestoringLabel => 'A restaurar a cópia de segurança...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'Cópia de segurança restaurada. No entanto, $count anexos não foram encontrados na cópia de segurança e não puderam ser restaurados. Recomenda-se reiniciar a aplicação para que as alterações tenham pleno efeito.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'Cópia de segurança restaurada com sucesso. Recomenda-se reiniciar a aplicação para que as alterações tenham pleno efeito.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'Ocorreu um erro ao restaurar: $error';
  }

  @override
  String get backupScreenTitle => 'Cópia de Segurança e Restauro';

  @override
  String get backupBlockedExitWarningMessage =>
      'Uma operação está em curso, aguarde a sua conclusão.';

  @override
  String get backupBusyBackTooltip => 'Operação em curso';

  @override
  String get backupIntroText =>
      'Pode fazer uma cópia de segurança das suas notas, categorias, definições e anexos num único ficheiro .zip, ou restaurar uma cópia de segurança feita anteriormente.';

  @override
  String get backupDriveCardTitle =>
      'Fazer Cópia de Segurança para o Google Drive';

  @override
  String get backupDriveCardSubtitle =>
      'Crie uma nova cópia de segurança e carregue-a diretamente para a área privada do seu Google Drive.';

  @override
  String get backupDriveCardButtonLabel => 'Cópia de Segurança para o Drive';

  @override
  String get backupDeviceCardTitle =>
      'Fazer Cópia de Segurança para o Dispositivo';

  @override
  String get backupDeviceCardSubtitle =>
      'Guarde todos os seus dados num único ficheiro .zip no seu dispositivo e partilhe-o se desejar.';

  @override
  String get backupDeviceCardButtonLabel =>
      'Cópia de Segurança para o Dispositivo';

  @override
  String get backupHistoryCardTitle => 'Histórico de Cópias de Segurança';

  @override
  String get backupHistoryCardSubtitle =>
      'Veja todas as cópias de segurança guardadas no seu dispositivo com a respetiva data e tamanho; pode partilhá-las, restaurá-las ou eliminá-las diretamente aqui.';

  @override
  String get backupHistoryTabDevice => 'Dispositivo';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'Eliminar Cópia de Segurança';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return 'Tem a certeza de que deseja eliminar permanentemente o ficheiro de cópia de segurança \"$fileName\"? Esta ação não pode ser desfeita.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage =>
      'Cópia de segurança eliminada.';

  @override
  String get backupHistoryDriveDeleteDialogTitle =>
      'Eliminar Cópia de Segurança do Drive';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return 'Tem a certeza de que deseja eliminar permanentemente a cópia de segurança \"$fileName\" do Google Drive? Esta ação não pode ser desfeita e o ficheiro não será movido para o lixo.';
  }

  @override
  String get backupHistoryDriveDeletedMessage =>
      'Cópia de segurança do Drive eliminada.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'Não foi possível eliminar: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'Ainda não há cópias de segurança guardadas neste dispositivo.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'Utilize \"Cópia de Segurança para o Dispositivo\" para criar a sua primeira cópia de segurança.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'Utilize \"Cópia de Segurança para o Google Drive\" para criar a sua primeira cópia de segurança na nuvem.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Ligue a sua conta Google para ver as suas cópias de segurança do Drive.';

  @override
  String get backupHistoryConnectGoogleButton => 'Ligar com o Google';

  @override
  String get backupHistoryDriveConnectedFallback => 'Ligado';

  @override
  String get backupHistoryUnknownErrorFallback =>
      'Ocorreu um erro desconhecido.';

  @override
  String get backupHistoryDownloadStartingLabel => 'A iniciar...';

  @override
  String get backupAutoBackupEnabledLabel =>
      'Cópia de Segurança Automática: ativada';

  @override
  String get backupAutoBackupDisabledLabel =>
      'Cópia de Segurança Automática: desativada';

  @override
  String get backupOverlayWarningMessage =>
      'Aguarde, não saia da aplicação até que a operação seja concluída.';

  @override
  String get pdfExportUntitledNoteLabel => 'Nota Sem Título';

  @override
  String get pdfExportDefaultAttachmentName => 'Anexo';

  @override
  String get pdfExportDefaultFileName => 'nota';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'Não foi possível capturar a captura de ecrã (limite não encontrado)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'Não foi possível gerar os dados da captura de ecrã';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'Não foi possível processar a imagem (falha na descodificação PNG)';

  @override
  String get screenshotCalcTableTotalLabel => 'Total';

  @override
  String get gundemMenuRemoveFromAgenda => 'Remover da agenda';

  @override
  String get gundemMenuDeleteNote => 'Eliminar nota';

  @override
  String get gundemSectionOverdue => 'Atrasadas';

  @override
  String get gundemSectionToday => 'Hoje';

  @override
  String get gundemSectionTomorrow => 'Amanhã';

  @override
  String get gundemSectionNextWeek => 'Próxima Semana';

  @override
  String get gundemSectionFurther => 'Mais Adiante';

  @override
  String get gundemWeekdayMonday => 'Segunda-feira';

  @override
  String get gundemWeekdayTuesday => 'Terça-feira';

  @override
  String get gundemWeekdayWednesday => 'Quarta-feira';

  @override
  String get gundemWeekdayThursday => 'Quinta-feira';

  @override
  String get gundemWeekdayFriday => 'Sexta-feira';

  @override
  String get gundemWeekdaySaturday => 'Sábado';

  @override
  String get gundemWeekdaySunday => 'Domingo';

  @override
  String get gundemAppBarTitle => 'Agenda';

  @override
  String get gundemCalendarTooltip => 'Calendário';

  @override
  String get gundemEmptyTitle => 'Nada na sua agenda';

  @override
  String get gundemEmptySubtitle =>
      'As notas com um lembrete ou uma data atribuída aparecerão aqui.';

  @override
  String get gundemUntitledNote => 'Nota sem título';

  @override
  String get gundemRepeatHourly => 'A cada hora';

  @override
  String get gundemRepeatDaily => 'Diariamente';

  @override
  String get gundemRepeatWeekly => 'Semanalmente';

  @override
  String get gundemRepeatMonthly => 'Mensalmente';

  @override
  String get gundemRepeatYearly => 'Anualmente';

  @override
  String get gundemPreviewCalcTableLabel => '[Lista de Cálculo]';

  @override
  String get gundemPreviewDrawingLabel => '[Desenho]';

  @override
  String get gundemPreviewImageLabel => '[Imagem]';

  @override
  String get gundemMonthShortJan => 'Jan';

  @override
  String get gundemMonthShortFeb => 'Fev';

  @override
  String get gundemMonthShortMar => 'Mar';

  @override
  String get gundemMonthShortApr => 'Abr';

  @override
  String get gundemMonthShortMay => 'Mai';

  @override
  String get gundemMonthShortJun => 'Jun';

  @override
  String get gundemMonthShortJul => 'Jul';

  @override
  String get gundemMonthShortAug => 'Ago';

  @override
  String get gundemMonthShortSep => 'Set';

  @override
  String get gundemMonthShortOct => 'Out';

  @override
  String get gundemMonthShortNov => 'Nov';

  @override
  String get gundemMonthShortDec => 'Dez';

  @override
  String get calendarAppBarTitle => 'Calendário';

  @override
  String get calendarTodayButton => 'Hoje';

  @override
  String get calendarLegendNoteLabel => 'Nota';

  @override
  String get calendarLegendReminderLabel => 'Lembrete';

  @override
  String get calendarTodayBadge => 'Hoje';

  @override
  String get calendarEmptyDayMessage => 'Sem notas ou lembretes para este dia.';

  @override
  String get calendarReminderHourlyLabel => 'A cada hora';

  @override
  String get calendarMonthJan => 'Janeiro';

  @override
  String get calendarMonthFeb => 'Fevereiro';

  @override
  String get calendarMonthMar => 'Março';

  @override
  String get calendarMonthApr => 'Abril';

  @override
  String get calendarMonthMay => 'Maio';

  @override
  String get calendarMonthJun => 'Junho';

  @override
  String get calendarMonthJul => 'Julho';

  @override
  String get calendarMonthAug => 'Agosto';

  @override
  String get calendarMonthSep => 'Setembro';

  @override
  String get calendarMonthOct => 'Outubro';

  @override
  String get calendarMonthNov => 'Novembro';

  @override
  String get calendarMonthDec => 'Dezembro';

  @override
  String get calendarWeekdayShortMon => 'Seg';

  @override
  String get calendarWeekdayShortTue => 'Ter';

  @override
  String get calendarWeekdayShortWed => 'Qua';

  @override
  String get calendarWeekdayShortThu => 'Qui';

  @override
  String get calendarWeekdayShortFri => 'Sex';

  @override
  String get calendarWeekdayShortSat => 'Sáb';

  @override
  String get calendarWeekdayShortSun => 'Dom';

  @override
  String get calendarWeekdayFullMonday => 'Segunda-feira';

  @override
  String get calendarWeekdayFullTuesday => 'Terça-feira';

  @override
  String get calendarWeekdayFullWednesday => 'Quarta-feira';

  @override
  String get calendarWeekdayFullThursday => 'Quinta-feira';

  @override
  String get calendarWeekdayFullFriday => 'Sexta-feira';

  @override
  String get calendarWeekdayFullSaturday => 'Sábado';

  @override
  String get calendarWeekdayFullSunday => 'Domingo';

  @override
  String get wrongPasswordDialogTitle => 'Palavra-passe Incorreta';

  @override
  String get wrongPasswordDialogMessage =>
      'A palavra-passe introduzida está incorreta.';

  @override
  String get commonOkButton => 'OK';

  @override
  String get unlockCategoryAction => 'Desbloquear';

  @override
  String get lockCategoryAction => 'Bloquear';

  @override
  String get categoryUnlockedMessage => 'Desbloqueada';

  @override
  String get categoryLockedMessage => 'Pasta bloqueada';

  @override
  String get deleteFolderMenuItemLabel => 'Eliminar Pasta';

  @override
  String get deleteFolderDialogTitle => 'Eliminar Pasta';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return 'Tem a certeza de que deseja eliminar a pasta \"$category\" e todas as suas subpastas? As notas nestas pastas ficarão sem categoria.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return 'Tem a certeza de que deseja eliminar a pasta \"$category\"? As notas nesta pasta ficarão sem categoria.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'Cancelar';

  @override
  String get deleteFolderDialogConfirmButton => 'Eliminar';

  @override
  String get editCategoryNameColorMenuItemLabel => 'Editar Nome / Cor';

  @override
  String get addSubfolderMenuItemLabel => 'Criar Subpasta';

  @override
  String get expandSubfoldersMenuItemLabel => 'Expandir Subpastas';

  @override
  String get collapseSubfoldersMenuItemLabel => 'Colapsar Subpastas';

  @override
  String saveErrorInfoMessage(String error) {
    return 'Erro ao guardar: $error';
  }

  @override
  String get welcomeNoteTitle => 'Bem-vindo ao Layout! 🚀';

  @override
  String get welcomeNoteContent => 'Novas funcionalidades adicionadas!';

  @override
  String get noteListDateGroupToday => 'Hoje';

  @override
  String get noteListDateGroupYesterday => 'Ontem';

  @override
  String get noteListDateGroupLast7Days => 'Últimos 7 Dias';

  @override
  String get noteListDateGroupLast30Days => 'Últimos 30 Dias';

  @override
  String get reminderRepeatNoneLabel => 'Sem repetição';

  @override
  String get voiceRecorderPreparingLabel => 'A preparar…';

  @override
  String get voiceRecorderCancelButton => 'Cancelar';

  @override
  String get voiceRecorderStopAddButton => 'Parar e Adicionar';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'A permissão de microfone não foi concedida.';

  @override
  String get speechToTextUnavailableMessage =>
      'O reconhecimento de voz não está disponível neste dispositivo.';

  @override
  String get speechToTextPreparingLabel => 'A preparar…';

  @override
  String get speechToTextListeningLabel => 'A ouvir…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'Comece a falar…';

  @override
  String get speechToTextCancelButton => 'Cancelar';

  @override
  String get speechToTextStopAddButton => 'Parar e Adicionar';

  @override
  String get textToSpeechNoContentMessage => 'Não há conteúdo para ler.';

  @override
  String get textToSpeechReadErrorMessage =>
      'Ocorreu um erro durante a leitura.';

  @override
  String get textToSpeechUnavailableMessage =>
      'A conversão de texto em voz não está disponível neste dispositivo.';

  @override
  String get textToSpeechPreparingLabel => 'A preparar…';

  @override
  String get textToSpeechPausedLabel => 'Em pausa';

  @override
  String get textToSpeechFinishedLabel => 'Leitura concluída';

  @override
  String get textToSpeechReadingLabel => 'A ler…';

  @override
  String get textToSpeechCloseErrorButton => 'Fechar';

  @override
  String get textToSpeechReplayButton => 'Ler Novamente';

  @override
  String get textToSpeechCloseFinishedButton => 'Fechar';

  @override
  String get textToSpeechPauseButton => 'Pausar';

  @override
  String get textToSpeechResumeButton => 'Retomar';

  @override
  String get textToSpeechStopButton => 'Parar';

  @override
  String get textToSpeechSpeedSlow => 'Lenta';

  @override
  String get textToSpeechSpeedNormal => 'Normal';

  @override
  String get textToSpeechSpeedFast => 'Rápida';

  @override
  String get calendarPickerCancelButton => 'Cancelar';

  @override
  String get calendarPickerConfirmButton => 'Selecionar';

  @override
  String get calendarPickerClearButton => 'Limpar';

  @override
  String get reminderPickerDialogTitle => 'Adicionar lembrete';

  @override
  String get reminderPickerDateTodayOption => 'Hoje';

  @override
  String get reminderPickerDateTomorrowOption => 'Amanhã';

  @override
  String get reminderPickerDatePickOption => 'Escolher data';

  @override
  String get reminderRepeatHourlyLabel => 'A cada hora';

  @override
  String get reminderRepeatDailyLabel => 'Todos os dias';

  @override
  String get reminderRepeatWeeklyLabel => 'Todas as semanas';

  @override
  String get reminderRepeatMonthlyLabel => 'Todos os meses';

  @override
  String get reminderRepeatYearlyLabel => 'Todos os anos';

  @override
  String get reminderPickerCalendarHelpText => 'Selecionar data do lembrete';

  @override
  String get reminderPickerCancelButton => 'CANCELAR';

  @override
  String get reminderPickerSaveButton => 'GUARDAR';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'Não é possível selecionar uma hora passada';

  @override
  String calcTableTotalLabel(String amount) {
    return 'Total: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'A preparar dados...';

  @override
  String get backupCreatePackagingNotesLabel =>
      'A empacotar notas e categorias...';

  @override
  String get backupCreateReadingAttachmentsLabel => 'A ler anexos...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'A ler anexos... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'A comprimir o ficheiro zip...';

  @override
  String get backupCreateSavingFileLabel => 'A guardar o ficheiro...';

  @override
  String get backupRestoreValidatingLabel =>
      'A validar a cópia de segurança...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'Cópia de segurança validada, a preparar dados...';

  @override
  String get backupRestoreWritingNotesLabel => 'A escrever notas...';

  @override
  String get backupRestoreWritingTrashLabel => 'A escrever lixo...';

  @override
  String get backupRestoreTrashWrittenLabel => 'Lixo escrito';

  @override
  String get backupRestoreWritingCategoriesLabel => 'A escrever categorias...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'Categorias escritas';

  @override
  String get backupRestoreWritingSettingsLabel => 'A escrever definições...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'Definições escritas';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'A limpar anexos antigos...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'Nenhum anexo encontrado, a concluir...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'A restaurar anexos... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'Concluído';

  @override
  String get backupValidationCorruptedFileMessage =>
      'O ficheiro está corrompido ou não é um ficheiro de cópia de segurança válido.';

  @override
  String get backupValidationMissingDataMessage =>
      'Não foram encontrados dados dentro do ficheiro de cópia de segurança (backup_data.json está em falta).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'Não foi possível ler os dados da cópia de segurança (JSON corrompido).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'Este ficheiro não é uma cópia de segurança da aplicação layout.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'Não foi possível ler a informação de versão do ficheiro de cópia de segurança.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'Esta cópia de segurança está num formato mais recente que a versão atual da aplicação não suporta. Atualize a aplicação.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'A informação de versão do ficheiro de cópia de segurança é inválida.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'Os dados da cópia de segurança não estão no formato esperado (o campo de notas está em falta).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'Os dados da cópia de segurança não estão no formato esperado (o campo de lixo está em falta).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'Os dados da cópia de segurança não estão no formato esperado (a lista de categorias é inválida).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'Os dados da cópia de segurança não estão no formato esperado (o campo de definições é inválido).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'Os dados da cópia de segurança não estão no formato esperado (um registo de nota é inválido).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'Os dados da cópia de segurança não estão no formato esperado (foi encontrado um registo de nota sem ID).';

  @override
  String get backupValidationFileNotFoundMessage =>
      'Ficheiro de cópia de segurança não encontrado.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'Armazenamento livre insuficiente no dispositivo. Liberte espaço e tente novamente.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'A permissão de acesso a ficheiros foi negada. Verifique as permissões da aplicação e tente novamente.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'Ocorreu um erro durante a operação do ficheiro: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'Ocorreu um erro inesperado: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'Não foi possível criar o arquivo zip (ZipEncoder devolveu nulo).';

  @override
  String get calcTableMenuItemLabel => 'Lista de Cálculo';

  @override
  String get tableBlockMenuItemLabel => 'Tabela';

  @override
  String get tableSizePickerTitle => 'Selecionar tamanho da tabela';

  @override
  String get tableSizePickerCancel => 'Cancelar';

  @override
  String get tableSizePickerDeleteTooltip => 'Excluir tabela';

  @override
  String get tagsMenuItemLabel => 'Etiquetas';

  @override
  String get linkDialogUrlHint => 'https://exemplo.com';

  @override
  String get checklistItemHint => 'Adicionar item...';

  @override
  String get toolbarHighlightTooltip => 'Destacar';

  @override
  String get toolbarListTooltip => 'Lista';

  @override
  String get toolbarHideKeyboardTooltip => 'Ocultar Teclado';

  @override
  String get autoBackupLocalSuccessMessage =>
      'Cópia de segurança local bem-sucedida.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'Falha na cópia de segurança local: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Cópia de segurança do Drive ignorada: a conta Google não está ligada ou a sessão expirou. Abra a aplicação e ligue-se novamente.';

  @override
  String get autoBackupDriveSuccessMessage =>
      'Cópia de segurança do Drive bem-sucedida.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Falha na cópia de segurança do Drive: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'Ainda sem notas';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'Total: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ Desenho';

  @override
  String get autoBackupSettingsAppBarTitle =>
      'Definições de Cópia de Segurança Automática';

  @override
  String get autoBackupSettingsMainSwitchTitle =>
      'Ativar Cópia de Segurança Automática';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'As suas notas são copiadas de forma segura periodicamente em segundo plano.';

  @override
  String get autoBackupSettingsTargetTitle => 'Destino da Cópia de Segurança';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'Escolha onde as cópias de segurança são guardadas.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'Local';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'Ambos';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Ligue primeiro a sua conta para utilizar as opções do Google Drive.';

  @override
  String get autoBackupSettingsConnectButton => 'Ligar';

  @override
  String get autoBackupSettingsFrequencyTitle =>
      'Frequência da Cópia de Segurança';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'É feita uma cópia de segurança a cada $hours horas.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 Horas';

  @override
  String get autoBackupSettingsFrequency12h => '12 Horas';

  @override
  String get autoBackupSettingsFrequency24h => '24 Horas (Diariamente)';

  @override
  String get autoBackupSettingsFrequency48h => '48 Horas (2 Dias)';

  @override
  String get autoBackupSettingsFrequency168h => '168 Horas (Semanalmente)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Utilizar Apenas Wi-Fi';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'O carregamento para a nuvem só acontece através de Wi-Fi para proteger os seus dados móveis.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'Estado do Sistema';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'A cópia de segurança automática ainda não foi executada.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'Última Execução: $date $time ($status)\nMensagem: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'Bem-sucedida';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'Falhou';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'Não foi possível ligar à conta Google.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'Definições de cópia de segurança automática atualizadas.';

  @override
  String selectionModeDeletedMessage(int count) {
    return '$count notas eliminadas';
  }

  @override
  String get selectionModeArchivedMessage => 'Arquivadas';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'Escolher categoria para $count notas';
  }

  @override
  String get selectionModeAddCategoryOption => 'Adicionar Categoria';

  @override
  String get selectionModeRemoveCategoryOption => 'Remover Categoria';

  @override
  String get calcTableItemHint => 'Item...';

  @override
  String get calcTableTotalRowLabel => 'Total';

  @override
  String get textSelectionMenuShareButton => 'Partilhar';

  @override
  String get textSelectionMenuTranslateButton => 'Traduzir';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'Não foi possível iniciar a partilha.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'Não foi possível abrir a tradução.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'Hoje $time';
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
    return 'Última cópia de segurança: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage =>
      'Ainda não foi feita nenhuma cópia de segurança.';

  @override
  String get backupFileNameLabel => 'Cópia de segurança';

  @override
  String get tableMenuInsertRowAfter => 'Adicionar linha';

  @override
  String get tableMenuDeleteRow => 'Excluir linha';

  @override
  String get tableMenuInsertColumnAfter => 'Adicionar coluna';

  @override
  String get tableMenuDeleteColumn => 'Excluir coluna';

  @override
  String get imageCropToolbarTitle => 'Recortar';

  @override
  String get imageViewerDeleteButtonLabel => 'Excluir';

  @override
  String get imageViewerSaveToGalleryButtonLabel => 'Salvar';

  @override
  String get imageViewerShareButtonLabel => 'Compartilhar';

  @override
  String get imageViewerGalleryPermissionDeniedMessage =>
      'Permissão da galeria não concedida';

  @override
  String get imageViewerSavedToGalleryMessage => 'Salvo no álbum';

  @override
  String imageViewerSaveFailedMessage(String error) {
    return 'Não foi possível salvar: $error';
  }

  @override
  String get imageViewerSavingInProgressMessage => 'Salvando…';
}
