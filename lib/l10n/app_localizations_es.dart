// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get toolbarBoldTooltip => 'Negrita';

  @override
  String get toolbarItalicTooltip => 'Cursiva';

  @override
  String get toolbarUnderlineTooltip => 'Subrayado';

  @override
  String get toolbarStrikethroughTooltip => 'Tachado';

  @override
  String get toolbarFontSizeTooltip => 'Tamaño de fuente';

  @override
  String get toolbarColorTooltip => 'Color de texto';

  @override
  String get toolbarBulletTooltip => 'Lista con viñetas';

  @override
  String get toolbarNumberTooltip => 'Lista numerada';

  @override
  String get toolbarIndentTooltip => 'Sangría de párrafo';

  @override
  String get toolbarLinkTooltip => 'Añadir / Editar / Quitar enlace';

  @override
  String get toolbarDividerTooltip => 'Insertar divisor';

  @override
  String get toolbarChecklistTooltip => 'Añadir lista de tareas';

  @override
  String get linkSelectTextSnackbar =>
      'Primero selecciona el texto que quieres enlazar';

  @override
  String get linkDialogEditTitle => 'Editar enlace';

  @override
  String get linkDialogAddTitle => 'Añadir enlace';

  @override
  String get linkDialogRemoveButton => 'Quitar enlace';

  @override
  String get linkDialogCancelButton => 'Cancelar';

  @override
  String get linkDialogConfirmButton => 'Añadir';

  @override
  String get cameraPermissionPermanentlyDeniedMessage =>
      'Permiso de cámara denegado. Debes habilitarlo desde los ajustes para grabar video.';

  @override
  String get cameraPermissionRequiredMessage =>
      'Se necesita permiso de cámara para grabar video.';

  @override
  String get openSettingsButtonLabel => 'Ajustes';

  @override
  String documentScanStartFailedMessage(String error) {
    return 'No se pudo iniciar el escaneo: $error';
  }

  @override
  String ocrRecognitionFailedMessage(String error) {
    return 'Error en el reconocimiento de texto: $error';
  }

  @override
  String get ocrNoReadableTextMessage =>
      'No se encontró texto legible en el documento';

  @override
  String get scanResultSheetTitle =>
      '¿Cómo se debe añadir el documento escaneado?';

  @override
  String get scanResultTextOnlyOption => 'Añadir solo como texto';

  @override
  String get scanResultTextAndImageOption => 'Añadir texto + imagen escaneada';

  @override
  String get scanResultCancelOption => 'Cancelar';

  @override
  String get audioPermissionPermanentlyDeniedMessage =>
      'Permiso de micrófono denegado. Debes habilitarlo desde los ajustes para grabar audio.';

  @override
  String get audioPermissionRequiredMessage =>
      'Se necesita permiso de micrófono para grabar audio.';

  @override
  String get voiceRecordingDefaultLabel => 'Grabación de voz';

  @override
  String blockPreviewCalcTableLabel(int count) {
    return 'Lista de cálculo ($count filas)';
  }

  @override
  String get blockPreviewDrawingLabel => 'Dibujo';

  @override
  String blockPreviewAttachmentsLabel(int count) {
    return '$count adjuntos (foto/documento)';
  }

  @override
  String get blockPreviewDividerLabel => 'Divisor';

  @override
  String blockPreviewChecklistLabel(int count) {
    return 'Lista de tareas ($count elementos)';
  }

  @override
  String get blockPreviewEmptyTextLabel => '(texto vacío)';

  @override
  String get reorderBlocksSheetTitle => 'Reordenar bloques';

  @override
  String get reorderBlocksMoveUpTooltip => 'Mover arriba';

  @override
  String get reorderBlocksMoveDownTooltip => 'Mover abajo';

  @override
  String get reorderBlocksCloseTooltip => 'Cerrar';

  @override
  String get reorderBlocksDescription =>
      'Toca un bloque para seleccionarlo y usa las flechas arriba/abajo para moverlo.';

  @override
  String get reorderBlocksMenuItemLabel => 'Reordenar';

  @override
  String get txtImportPickerDialogTitle =>
      'Selecciona el archivo TXT a importar';

  @override
  String get txtImportReadFailedMessage => 'No se pudo leer el archivo TXT';

  @override
  String get txtImportEmptyFileMessage => 'El archivo TXT está vacío';

  @override
  String get txtImportSuccessMessage => 'TXT importado';

  @override
  String get txtImportMenuItemLabel => 'Importar (txt)';

  @override
  String get exportMenuItemLabel => 'Exportar';

  @override
  String get editorUndoTooltip => 'Deshacer';

  @override
  String get editorRedoTooltip => 'Rehacer';

  @override
  String get noteSavedMessage => 'Nota guardada';

  @override
  String get dateAssignPickerHelpText => 'Asignar nota a un día';

  @override
  String get dateAssignChangeOption => 'Cambiar fecha';

  @override
  String get dateAssignRemoveOption => 'Quitar asignación';

  @override
  String get editorSubToolbarCloseTooltip => 'Cerrar';

  @override
  String get titleFieldHint => 'Título';

  @override
  String get textBlockHint => 'Escribe tu nota aquí...';

  @override
  String get drawingBoardMenuItemLabel => 'Pizarra de dibujo';

  @override
  String get voiceToTextTextNotesOnlyMessage =>
      'La conversión de voz a texto solo está disponible para notas de texto';

  @override
  String get selectionModeCancelTooltip => 'Cancelar selección';

  @override
  String selectionModeSelectedCountTitle(int count) {
    return '$count seleccionados';
  }

  @override
  String get selectionModeDeleteTooltip => 'Eliminar';

  @override
  String get selectionModeArchiveTooltip => 'Archivar';

  @override
  String get selectionModeFolderTooltip => 'Carpeta';

  @override
  String get searchFieldHint => 'Buscar notas...';

  @override
  String get emptyTrashDialogTitle => 'Vaciar papelera';

  @override
  String get emptyTrashDialogConfirmMessage =>
      'Todas las notas eliminadas se quitarán permanentemente. ¿Estás seguro?';

  @override
  String get emptyTrashDialogCancelButton => 'Cancelar';

  @override
  String get restoreAllMenuItemLabel => 'Restaurar todo';

  @override
  String get sortMenuTooltip => 'Ordenar notas';

  @override
  String get sortMenuAscendingLabel => 'Orden: Ascendente (A-Z)';

  @override
  String get sortMenuDescendingLabel => 'Orden: Descendente (Z-A)';

  @override
  String get sortMenuByTitleLabel => 'Ordenar por: Título';

  @override
  String get sortMenuByModifiedDateLabel => 'Ordenar por: Última modificación';

  @override
  String get sortMenuByCreatedDateLabel => 'Ordenar por: Fecha de creación';

  @override
  String get sortMenuByFolderLabel => 'Ordenar por: Carpeta';

  @override
  String get viewToggleGridTooltip => 'Vista de cuadrícula';

  @override
  String get viewToggleListTooltip => 'Vista de lista';

  @override
  String get drawerHeaderSubtitle => 'Tu cuaderno personal';

  @override
  String get drawerNotesSectionHeader => 'NOTAS';

  @override
  String get drawerAllNotesLabel => 'Notas';

  @override
  String get drawerFavoritesLabel => 'Favoritos';

  @override
  String get drawerAgendaLabel => 'Agenda';

  @override
  String get drawerRemindersLabel => 'Recordatorio';

  @override
  String get drawerLockedLabel => 'Bloqueadas';

  @override
  String get drawerTrashLabel => 'Papelera';

  @override
  String get drawerFoldersSectionHeader => 'CARPETAS';

  @override
  String get drawerExpandLabel => 'Expandir';

  @override
  String get drawerCollapseLabel => 'Contraer';

  @override
  String get drawerAddFolderLabel => 'Añadir carpeta';

  @override
  String get drawerAppSectionHeader => 'APLICACIÓN';

  @override
  String get drawerCalendarLabel => 'Calendario';

  @override
  String get drawerSettingsLabel => 'Ajustes';

  @override
  String get drawerBackupRestoreLabel => 'Copia de seguridad y restauración';

  @override
  String get drawerUpgradeToProLabel => 'Actualizar a Pro';

  @override
  String get drawerProBadgeLabel => 'PRO';

  @override
  String get drawerSupportDevelopmentLabel => 'Apoyar el desarrollo';

  @override
  String get drawerFeedbackLabel => 'Comentarios';

  @override
  String get drawerAboutLabel => 'Acerca de';

  @override
  String get noNotesFoundMessage => 'No se encontraron notas.';

  @override
  String get trashRestoreButtonLabel => 'Restaurar';

  @override
  String get trashPermanentDeleteButtonLabel => 'Eliminar permanentemente';

  @override
  String get tagRenamedInfoMessage => 'Etiqueta renombrada';

  @override
  String get tagDeletedInfoMessage => 'Etiqueta eliminada';

  @override
  String get tagOptionsRenameLabel => 'Renombrar';

  @override
  String get tagOptionsDeleteLabel => 'Eliminar';

  @override
  String get renameTagDialogTitle => 'Renombrar etiqueta';

  @override
  String get renameTagDialogHint => 'Nuevo nombre de etiqueta';

  @override
  String get renameTagDialogCancelButton => 'Cancelar';

  @override
  String get renameTagDialogSaveButton => 'Guardar';

  @override
  String deleteTagDialogMessageWithCount(String tag, int affectedCount) {
    return '\"$tag\" se quitará de $affectedCount notas. ¿Continuar?';
  }

  @override
  String deleteTagDialogMessage(String tag) {
    return '¿Eliminar la etiqueta \"$tag\"?';
  }

  @override
  String get deleteTagDialogTitle => 'Eliminar etiqueta';

  @override
  String get deleteTagDialogCancelButton => 'Cancelar';

  @override
  String get deleteTagDialogConfirmButton => 'Eliminar';

  @override
  String get tagsSheetTitle => 'Etiquetas';

  @override
  String get tagsSheetEmptyMessage => 'Esta nota aún no tiene etiquetas.';

  @override
  String get tagsSheetInputHint => 'Escribe una nueva etiqueta...';

  @override
  String get tagsSheetSuggestionsLabel => 'Etiquetas existentes';

  @override
  String get noteDeletedInfoMessage => 'Nota eliminada';

  @override
  String get noteDeletedUndoActionLabel => 'Deshacer';

  @override
  String get reminderSetInfoMessage => 'Recordatorio establecido';

  @override
  String get reminderRemovedInfoMessage => 'Recordatorio eliminado';

  @override
  String get noteDuplicatedInfoMessage => 'Copia creada';

  @override
  String get speechTextAppendedInfoMessage => 'Texto añadido a la nota';

  @override
  String get pdfPreparingInfoMessage => 'Preparando PDF…';

  @override
  String get pdfSavedInfoMessage => 'PDF guardado';

  @override
  String get jpgPreparingInfoMessage => 'Preparando JPG…';

  @override
  String get jpgSavedInfoMessage => 'JPG guardado';

  @override
  String get jpgFailedInfoMessage => 'No se pudo crear el JPG';

  @override
  String get txtPreparingInfoMessage => 'Preparando TXT…';

  @override
  String get txtSavedInfoMessage => 'TXT guardado';

  @override
  String get txtFailedInfoMessage => 'No se pudo crear el TXT';

  @override
  String get exportOpenActionLabel => 'Abrir';

  @override
  String get wrongPasswordInfoMessage => 'Contraseña incorrecta.';

  @override
  String get noteArchivedInfoMessage => 'Nota archivada';

  @override
  String get noteUnarchivedInfoMessage => 'Quitada del archivo';

  @override
  String get noteUnlockedInfoMessage => 'Desbloqueada';

  @override
  String get noteLockedInfoMessage => 'Nota bloqueada';

  @override
  String get notificationUnpinnedInfoMessage => 'Desfijada';

  @override
  String get emptyNotePinBlockedInfoMessage =>
      'Una nota vacía no se puede fijar.';

  @override
  String get notificationPinnedInfoMessage =>
      'Fijada al panel de notificaciones';

  @override
  String get noContentToReadInfoMessage => 'No hay contenido para leer';

  @override
  String get backPressExitInfoMessage => 'Presiona atrás de nuevo para salir';

  @override
  String get reminderChannelName => 'Recordatorios de notas';

  @override
  String get reminderChannelDescription =>
      'Recordatorios de notas en la aplicación Layout';

  @override
  String get pinnedChannelName => 'Notas fijadas';

  @override
  String get pinnedChannelDescription =>
      'Notas de Layout fijadas al panel de notificaciones';

  @override
  String get notificationUnpinActionLabel => 'Quitar';

  @override
  String get reminderDefaultTitle => 'Recordatorio';

  @override
  String get reminderChecklistBodyFallback =>
      'No olvides revisar tu lista de tareas';

  @override
  String get reminderTextBodyFallback => 'No olvides revisar tu nota';

  @override
  String get pdfSaveDialogTitle => 'Guardar como PDF';

  @override
  String get jpgSaveDialogTitle => 'Guardar como JPG';

  @override
  String get txtSaveDialogTitle => 'Guardar como TXT';

  @override
  String get textSizeSheetTitle => 'Tamaño de texto';

  @override
  String get textSizeSamplePreview => 'Texto de ejemplo';

  @override
  String get textSizeCancelButton => 'Cancelar';

  @override
  String get textSizeApplyButton => 'Aplicar';

  @override
  String get createPasswordDialogTitle => 'Crear contraseña';

  @override
  String get createPasswordNewPasswordHint => 'Nueva contraseña';

  @override
  String get createPasswordConfirmHint => 'Vuelve a introducir la contraseña';

  @override
  String get createPasswordHintQuestionDescription =>
      'Establece una pregunta de seguridad por si olvidas tu contraseña (opcional).';

  @override
  String get createPasswordHintQuestionHint =>
      'Elige una pregunta de seguridad';

  @override
  String get createPasswordHintAnswerHint => 'Tu respuesta';

  @override
  String get createPasswordCancelButton => 'Cancelar';

  @override
  String get createPasswordSaveButton => 'Guardar';

  @override
  String get passwordMismatchMessage => '¡Las contraseñas no coinciden!';

  @override
  String get passwordRequiredDialogTitle => 'Contraseña requerida';

  @override
  String get passwordRequiredHint => 'Introduce la contraseña';

  @override
  String get forgotPasswordButtonLabel => 'Olvidé mi contraseña';

  @override
  String get passwordRequiredCancelButton => 'Cancelar';

  @override
  String get passwordRequiredConfirmButton => 'Verificar';

  @override
  String get securityQuestionDialogTitle => 'Pregunta de seguridad';

  @override
  String get securityQuestionAnswerHint => 'Tu respuesta';

  @override
  String get securityQuestionCancelButton => 'Cancelar';

  @override
  String get securityQuestionConfirmButton => 'Confirmar';

  @override
  String get securityQuestionWrongAnswerMessage =>
      'Respuesta incorrecta. Inténtalo de nuevo.';

  @override
  String get revealedPasswordDialogTitle => 'Tu contraseña';

  @override
  String get revealedPasswordLabel => 'La contraseña de tu nota:';

  @override
  String get revealedPasswordOkButton => 'Aceptar';

  @override
  String get securityQuestionPetName => '¿Cómo se llama tu primera mascota?';

  @override
  String get securityQuestionFavoriteTeacher =>
      '¿Cómo se llama tu profesor favorito?';

  @override
  String get securityQuestionBirthCity => '¿En qué ciudad naciste?';

  @override
  String get securityQuestionFavoriteFood => '¿Cuál es tu comida favorita?';

  @override
  String get securityQuestionMotherMaidenName =>
      '¿Cuál es el apellido de soltera de tu madre?';

  @override
  String get securityQuestionFirstSchool =>
      '¿Cómo se llama la primera escuela a la que asististe?';

  @override
  String get securityQuestionFavoriteColor => '¿Cuál es tu color favorito?';

  @override
  String get editFolderDialogTitle => 'Editar carpeta';

  @override
  String get newSubfolderDialogTitle => 'Nueva subcarpeta';

  @override
  String get addFolderDialogTitle => 'Añadir carpeta';

  @override
  String subfolderParentInfoMessage(String parentCategory) {
    return 'Se creará dentro de \"$parentCategory\"';
  }

  @override
  String get subfolderNameFieldLabel => 'Nombre de la subcarpeta';

  @override
  String get folderNameFieldLabel => 'Nombre de la carpeta';

  @override
  String get folderColorLabel => 'Color';

  @override
  String get folderDialogCancelButton => 'Cancelar';

  @override
  String get folderDialogSaveButton => 'Guardar';

  @override
  String get folderDialogAddButton => 'Añadir';

  @override
  String get selectFolderSheetTitle => 'Seleccionar carpeta';

  @override
  String get selectFolderAddOptionLabel => 'Añadir carpeta';

  @override
  String get removeCurrentFolderLabel => 'Quitar carpeta actual';

  @override
  String get noteDetailsDialogTitle => 'Detalles';

  @override
  String get noteDetailsCreatedLabel => 'Creada';

  @override
  String get noteDetailsModifiedLabel => 'Última modificación';

  @override
  String get noteDetailsCharCountLabel => 'Número de caracteres';

  @override
  String noteDetailsCharCountValue(int count) {
    return '$count caracteres';
  }

  @override
  String get noteDetailsWordCountLabel => 'Número de palabras';

  @override
  String noteDetailsWordCountValue(int count) {
    return '$count palabras';
  }

  @override
  String get noteDetailsOkButton => 'Aceptar';

  @override
  String get noteDetailsUnknownDateLabel => 'Desconocida';

  @override
  String get addAttachmentSheetTitle => 'Añadir';

  @override
  String get addAttachmentImageOption => 'Añadir imagen';

  @override
  String get addAttachmentCameraOption => 'Cámara';

  @override
  String get addAttachmentFileOption => 'Añadir archivo';

  @override
  String get addAttachmentVoiceOption => 'Grabación de voz';

  @override
  String get addAttachmentVideoOption => 'Grabar video';

  @override
  String get addAttachmentScanOption => 'Escanear documento';

  @override
  String get noteActionsSheetTitle => 'Elegir acción';

  @override
  String get noteActionReminderLabel => 'Recordatorio';

  @override
  String get noteActionEditReminderLabel => 'Editar recordatorio';

  @override
  String get noteActionSpeechToTextLabel => 'Voz a texto';

  @override
  String get noteActionArchiveLabel => 'Archivar';

  @override
  String get noteActionUnarchiveLabel => 'Quitar del archivo';

  @override
  String get noteActionLockLabel => 'Bloquear';

  @override
  String get noteActionUnlockLabel => 'Desbloquear';

  @override
  String get noteActionFavoriteLabel => 'Favorito';

  @override
  String get noteActionUnfavoriteLabel => 'Quitar de favoritos';

  @override
  String get noteActionClassifyLabel => 'Seleccionar carpeta';

  @override
  String get noteActionDeleteLabel => 'Eliminar';

  @override
  String get noteActionPinToNotificationLabel =>
      'Fijar al panel de notificaciones';

  @override
  String get noteActionUnpinFromNotificationLabel => 'Quitar fijado';

  @override
  String get noteActionShareLabel => 'Compartir';

  @override
  String get noteActionDuplicateLabel => 'Crear copia';

  @override
  String get noteActionCopyContentLabel => 'Copiar contenido';

  @override
  String get noteActionTtsLabel => 'Leer en voz alta';

  @override
  String get noteActionTextSizeLabel => 'Tamaño de texto';

  @override
  String get noteActionDetailsLabel => 'Detalles';

  @override
  String get noteActionDiscardChangesLabel => 'Descartar cambios';

  @override
  String get noteActionSelectLabel => 'Seleccionar';

  @override
  String get reminderEditOptionLabel => 'Cambiar recordatorio';

  @override
  String get reminderRemoveOptionLabel => 'Quitar recordatorio';

  @override
  String get discardChangesDialogTitle => 'Descartar cambios';

  @override
  String get discardChangesDialogMessage =>
      'Los cambios no guardados en esta nota se perderán. ¿Seguro que quieres descartarlos?';

  @override
  String get discardChangesCancelButton => 'Cancelar';

  @override
  String get discardChangesConfirmButton => 'Descartar';

  @override
  String get pinnedNotificationDefaultTitle => 'Nota';

  @override
  String get pdfFailedInfoMessage => 'No se pudo crear el PDF';

  @override
  String get drawingScreenTitle => 'Dibujo';

  @override
  String get drawingMinimizeTooltip => 'Minimizar';

  @override
  String get drawingEmptyExportWarningMessage => 'Dibuja algo primero';

  @override
  String get drawingEraserPartialModeLabel => 'Parcial';

  @override
  String get drawingEraserFullModeLabel => 'Completo';

  @override
  String get drawingClearTooltip => 'Borrar todo';

  @override
  String get drawingZoomOutTooltip => 'Alejar';

  @override
  String get drawingZoomInTooltip => 'Acercar';

  @override
  String get drawingDeleteTooltip => 'Eliminar';

  @override
  String get drawingEmptyPreviewHint => 'Toca para dibujar';

  @override
  String get settingsPageTitle => 'Ajustes';

  @override
  String get settingsSectionSecurity => 'Seguridad';

  @override
  String get settingsSectionTheme => 'Tema';

  @override
  String get settingsSectionPersonalization => 'Personalización';

  @override
  String get settingsSectionWidget => 'Widget';

  @override
  String get settingsSectionAbout => 'Acerca de';

  @override
  String get settingsHintQuestionPet => '¿Cómo se llama tu primera mascota?';

  @override
  String get settingsHintQuestionTeacher =>
      '¿Cómo se llama tu profesor favorito?';

  @override
  String get settingsHintQuestionBirthCity => '¿En qué ciudad naciste?';

  @override
  String get settingsHintQuestionFavoriteFood => '¿Cuál es tu comida favorita?';

  @override
  String get settingsHintQuestionMotherMaidenName =>
      '¿Cuál es el apellido de soltera de tu madre?';

  @override
  String get settingsHintQuestionFirstSchool =>
      '¿Cuál fue la primera escuela a la que asististe?';

  @override
  String get settingsHintQuestionFavoriteColor => '¿Cuál es tu color favorito?';

  @override
  String get settingsSecurityQuestionDialogTitle => 'Pregunta de seguridad';

  @override
  String get settingsSecurityQuestionDialogDesc =>
      'Si olvidas tu contraseña, podrás recuperarla respondiendo correctamente a esta pregunta.';

  @override
  String get settingsSecurityQuestionDropdownHint =>
      'Elige una pregunta de seguridad';

  @override
  String get settingsSecurityQuestionAnswerHint => 'Tu respuesta';

  @override
  String get settingsSecurityQuestionCancelButton => 'Cancelar';

  @override
  String get settingsSecurityQuestionEmptyWarning =>
      '¡La pregunta y la respuesta no pueden estar vacías!';

  @override
  String get settingsSecurityQuestionSaveButton => 'Guardar';

  @override
  String get settingsCreatePasswordTitle => 'Crear contraseña';

  @override
  String get settingsPasswordRequiredTitle => 'Contraseña requerida';

  @override
  String get settingsPasswordEnterHint => 'Introduce la contraseña';

  @override
  String get settingsForgotPasswordButton => 'Olvidé mi contraseña';

  @override
  String get settingsNewPasswordHint => 'Nueva contraseña';

  @override
  String get settingsConfirmPasswordHint => 'Vuelve a introducir la contraseña';

  @override
  String get settingsSecurityQuestionOptionalDesc =>
      'Establece una pregunta de seguridad por si olvidas tu contraseña (opcional).';

  @override
  String get settingsPasswordDialogCancelButton => 'Cancelar';

  @override
  String get settingsPasswordMismatchWarning =>
      '¡Las contraseñas no coinciden!';

  @override
  String get settingsWrongPasswordWarning => '¡Contraseña incorrecta!';

  @override
  String get settingsPasswordSaveButton => 'Guardar';

  @override
  String get settingsPasswordRemoveButton => 'Quitar';

  @override
  String get settingsNotePasswordTitle => 'Contraseña de la nota';

  @override
  String get settingsPasswordSetSubtitle => 'Contraseña establecida ✓';

  @override
  String get settingsPasswordNotSetSubtitle => 'Contraseña no establecida';

  @override
  String get settingsSecurityQuestionTileTitle => 'Pregunta de seguridad';

  @override
  String get settingsSecurityQuestionSetSubtitle =>
      'Establecida ✓ — se usa si olvidas tu contraseña';

  @override
  String get settingsSecurityQuestionNotSetSubtitle =>
      'No establecida — no podrás recuperar tu contraseña si la pierdes';

  @override
  String get settingsThemeDialogTitle => 'Seleccionar tema';

  @override
  String get settingsThemeSystemDefault => 'Predeterminado del sistema';

  @override
  String get settingsThemeLightOption => 'Tema claro';

  @override
  String get settingsThemeDarkOption => 'Tema oscuro';

  @override
  String get settingsLanguageDialogTitle => 'Seleccionar idioma';

  @override
  String get settingsLanguageSystemOption => 'Sistema';

  @override
  String get settingsAccentColorDialogTitle => 'Elegir color de acento';

  @override
  String get settingsThemeChangeTileTitle => 'Cambiar tema';

  @override
  String get settingsThemeLightLabel => 'Claro';

  @override
  String get settingsThemeDarkLabel => 'Oscuro';

  @override
  String get settingsThemeSystemLabel => 'Sistema';

  @override
  String get settingsLanguageTileTitle => 'Idioma';

  @override
  String get settingsAccentColorTileTitle => 'Color de acento';

  @override
  String get settingsAccentColorTileSubtitle =>
      'Color usado en la barra de la aplicación, botones e interruptores';

  @override
  String get settingsColorfulNotesTitle => 'Colores variados en las notas';

  @override
  String get settingsColorfulNotesSubtitle =>
      'Cada tarjeta de nota recibe un tono de color diferente.';

  @override
  String get settingsTextColorSheetTitle => 'Color de texto';

  @override
  String get settingsTextColorSheetDesc =>
      'Define el color del texto del contenido de la nota.';

  @override
  String get settingsTextColorOkButton => 'Aceptar';

  @override
  String get settingsTextColorTileTitle => 'Color de texto';

  @override
  String get settingsTextColorTileSubtitle =>
      'Color del texto del contenido de la nota.';

  @override
  String get settingsWidgetFontSizeLabel => 'Tamaño de fuente del widget';

  @override
  String settingsWidgetFontSizeSample(int size) {
    return 'Título de ejemplo - $size pt';
  }

  @override
  String get settingsWidgetFontSizeCancelButton => 'Cancelar';

  @override
  String get settingsWidgetFontSizeApplyButton => 'Aplicar';

  @override
  String get settingsWidgetOpacityLabel => 'Transparencia del fondo';

  @override
  String settingsWidgetOpacityValue(int percent) {
    return '$percent% de transparencia';
  }

  @override
  String get settingsWidgetOpacityCancelButton => 'Cancelar';

  @override
  String get settingsWidgetOpacityApplyButton => 'Aplicar';

  @override
  String get settingsWidgetDarkModeTitle => 'Widget oscuro';

  @override
  String get settingsWidgetDarkModeDesc =>
      'Esquema de color oscuro para el widget.';

  @override
  String get settingsAboutVersionTitle => 'Versión de la aplicación';

  @override
  String get settingsFontFamilyTileTitle => 'Fuente';

  @override
  String get settingsFontFamilyDefaultLabel => 'Predeterminada';

  @override
  String get settingsGlobalFontSizeTileTitle => 'Tamaño de fuente';

  @override
  String settingsGlobalFontSizeTileSubtitle(int size) {
    return '$size pt — aplicado a todas las notas.';
  }

  @override
  String settingsGlobalFontSizeSamplePreview(int size) {
    return 'Texto de ejemplo - $size pt';
  }

  @override
  String get settingsGlobalFontSizeApplyToAllLabel =>
      'Aplicar a las notas existentes';

  @override
  String get settingsGlobalFontSizeApplyToAllNote =>
      'Si una nota tiene un tamaño de fuente individual establecido, este ajuste no la afectará.';

  @override
  String get settingsGlobalFontSizeCancelButton => 'Cancelar';

  @override
  String get settingsGlobalFontSizeApplyButton => 'Aplicar';

  @override
  String get settingsPreviewLinesTileTitle =>
      'Líneas de vista previa de la nota';

  @override
  String settingsPreviewLinesTileSubtitle(int lines) {
    return 'Mostrar hasta $lines líneas. Si la nota es más corta, se muestra el número real de líneas.';
  }

  @override
  String settingsPreviewLinesCurrentLabel(int lines) {
    return 'Actual: $lines líneas';
  }

  @override
  String get settingsPreviewLinesDescription =>
      'Establece el número máximo de líneas para la vista previa. Si la nota tiene menos líneas, se muestra el número real de líneas.';

  @override
  String get settingsPreviewLinesCancelButton => 'Cancelar';

  @override
  String get settingsPreviewLinesApplyButton => 'Aplicar';

  @override
  String get backupCancelButton => 'Cancelar';

  @override
  String get backupConnectButton => 'Conectar';

  @override
  String get backupDisconnectButton => 'Desconectar';

  @override
  String get backupContinueButton => 'Continuar';

  @override
  String get backupCloseButton => 'Cerrar';

  @override
  String get backupShareButton => 'Compartir';

  @override
  String get backupRestoreButton => 'Restaurar';

  @override
  String get backupConfigureButton => 'Configurar';

  @override
  String get backupUnknownDateLabel => 'Desconocida';

  @override
  String get backupProcessingDefaultLabel => 'Procesando...';

  @override
  String get backupPermissionRequiredTitle =>
      'Se requiere permiso de almacenamiento';

  @override
  String get backupPermissionRequiredBodyPermanent =>
      'Esta versión de Android requiere permiso de almacenamiento para hacer copias de seguridad y restaurar. Como el permiso fue denegado permanentemente, habilítalo manualmente desde los ajustes de la aplicación.';

  @override
  String get backupPermissionRequiredBodyNormal =>
      'Esta versión de Android requiere permiso de almacenamiento para hacer copias de seguridad y restaurar. Concede el permiso para continuar.';

  @override
  String get backupGoToSettingsButton => 'Ir a ajustes';

  @override
  String get backupRetryButton => 'Reintentar';

  @override
  String get backupDriveConnectingLabel =>
      'Conectando con la cuenta de Google...';

  @override
  String backupDriveConnectedWithEmailMessage(String email) {
    return 'Conectado a la cuenta de Google Drive: $email';
  }

  @override
  String get backupDriveConnectedMessage =>
      'Conectado a la cuenta de Google Drive.';

  @override
  String get backupDriveConnectFailedMessage =>
      'No se pudo conectar con la cuenta de Google, o se canceló la operación.';

  @override
  String get backupDriveDisconnectTitle => 'Desconectar Google Drive';

  @override
  String get backupDriveDisconnectBody =>
      'Si te desconectas, no será posible hacer copias de seguridad manuales ni automáticas en Drive. Las copias de seguridad ya almacenadas en Drive no se eliminarán; solo se quitará el acceso desde este dispositivo.';

  @override
  String get backupDriveDisconnectedMessage =>
      'Se quitó la conexión con Google Drive.';

  @override
  String get backupDriveRequiredTitle => 'Se requiere cuenta de Google';

  @override
  String get backupDriveRequiredBody =>
      'Esta acción requiere que conectes tu cuenta de Google. ¿Quieres conectarla ahora?';

  @override
  String backupDriveStatusConnectedWithEmail(String email) {
    return 'Google Drive: conectado ($email)';
  }

  @override
  String get backupDriveStatusConnected => 'Google Drive: conectado';

  @override
  String get backupDriveStatusDisconnected => 'Google Drive: no conectado';

  @override
  String get backupDriveAuthenticatingLabel =>
      'Verificando cuenta de Google...';

  @override
  String get backupDriveNotSignedInMessage =>
      'No estás conectado a Google Drive. Primero inicia sesión con tu cuenta de Google.';

  @override
  String get backupDriveUploadingLabel =>
      'Subiendo copia de seguridad a Drive...';

  @override
  String get backupDriveUploadTimeoutMessage =>
      'La subida a Google Drive no se completó en 120 segundos (sin respuesta del servidor). Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String get backupDriveOperationCompletedLabel => 'Completado';

  @override
  String get backupToDriveActionLabel => 'copia de seguridad en Drive';

  @override
  String get backupToDeviceActionLabel => 'copia de seguridad';

  @override
  String get backupCreatingLabel => 'Creando copia de seguridad...';

  @override
  String backupCreateFailedMessage(String error) {
    return 'No se pudo crear la copia de seguridad: $error';
  }

  @override
  String backupDriveUploadFailedMessage(String error) {
    return 'Error al subir a Google Drive: $error';
  }

  @override
  String get backupDriveUploadSuccessMessage =>
      'Copia de seguridad subida correctamente a Google Drive.';

  @override
  String backupCreatedMessage(String fileName, String size) {
    return 'Copia de seguridad creada: $fileName ($size)';
  }

  @override
  String get backupOfferShareTitle => 'Copia de seguridad lista';

  @override
  String get backupOfferShareBody =>
      'Tu archivo de copia de seguridad se ha guardado en tu dispositivo. ¿Quieres compartirlo ahora (por ejemplo, almacenamiento en la nube, correo electrónico, otro dispositivo)?';

  @override
  String get backupShareFileText => 'archivo de copia de seguridad de layout';

  @override
  String backupShareFailedMessage(String error) {
    return 'No se pudo iniciar el uso compartido: $error';
  }

  @override
  String get backupLargeOperationTitle => 'Copia de seguridad grande';

  @override
  String backupLargeOperationBody(String sizeText, String actionLabel) {
    return 'Los datos a procesar son de aproximadamente $sizeText. Un $actionLabel de este tamaño puede tardar según tu dispositivo. Solo evita salir de la aplicación mientras esté en curso. ¿Quieres continuar?';
  }

  @override
  String get backupRestoreActionLabel => 'restauración';

  @override
  String get backupDriveListingLabel =>
      'Listando copias de seguridad de Drive...';

  @override
  String backupDriveListFailedMessage(String error) {
    return 'No se pudieron listar las copias de seguridad: $error';
  }

  @override
  String get backupDriveNoBackupsMessage =>
      'Todavía no hay copias de seguridad en Google Drive.';

  @override
  String get backupDrivePickTitle => 'Elegir una copia de seguridad de Drive';

  @override
  String get backupDriveDownloadingLabel =>
      'Descargando copia de seguridad de Drive...';

  @override
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total) {
    return 'Descargando copia de seguridad de Drive... ($downloaded / $total)';
  }

  @override
  String get backupDriveSavingToDeviceLabel =>
      'Guardando archivo en el dispositivo...';

  @override
  String get backupDriveUnknownBackupFileName => 'copia_desconocida.zip';

  @override
  String get backupDriveStorageFullMessage =>
      'Tu almacenamiento de Google Drive está lleno. Libera espacio en Drive e inténtalo de nuevo.';

  @override
  String get backupDriveNetworkErrorMessage =>
      'No se pudo establecer conexión a internet. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String get backupDriveBackupNotFoundMessage =>
      'No se pudo encontrar el archivo de copia de seguridad especificado en Drive. Puede que se haya eliminado.';

  @override
  String backupDriveUnknownErrorMessage(String error) {
    return 'Ocurrió un error inesperado durante la operación de Google Drive: $error';
  }

  @override
  String backupDriveDownloadFailedMessage(String error) {
    return 'Error al descargar: $error';
  }

  @override
  String backupPickFileFailedMessage(String error) {
    return 'No se pudo seleccionar el archivo: $error';
  }

  @override
  String get backupPickedFileUnreachableMessage =>
      'No se pudo acceder al archivo seleccionado.';

  @override
  String get backupCheckingLabel => 'Comprobando copia de seguridad...';

  @override
  String backupReadFailedMessage(String error) {
    return 'No se pudo leer el archivo de copia de seguridad: $error';
  }

  @override
  String get backupRestoreConfirmTitle => 'Restaurar copia de seguridad';

  @override
  String get backupPreviewContentsHeader =>
      'Contenido de la copia de seguridad seleccionada:';

  @override
  String get backupPreviewNoteCountLabel => 'Número de notas';

  @override
  String get backupPreviewTrashCountLabel => 'Notas en la papelera';

  @override
  String get backupPreviewCategoryCountLabel => 'Número de carpetas';

  @override
  String get backupPreviewAttachmentLabel => 'Adjuntos';

  @override
  String get backupPreviewAttachmentNoneValue => 'Ninguno';

  @override
  String backupPreviewAttachmentCountValue(int count, String size) {
    return '$count archivos ($size)';
  }

  @override
  String get backupPreviewCreatedAtLabel => 'Creada el';

  @override
  String get backupEmptyPreviewTitle =>
      'Esta copia de seguridad parece estar vacía';

  @override
  String get backupEmptyPreviewBody =>
      'No se encontraron notas, carpetas ni adjuntos en el archivo seleccionado. Si continúas, tus datos actuales igualmente se eliminarán y se reemplazarán por esta copia vacía.';

  @override
  String backupMissingAttachmentsTitle(int count) {
    return '$count adjuntos no encontrados en la copia de seguridad';
  }

  @override
  String backupMissingAttachmentsBody(String names) {
    return 'Las notas con estos archivos se restaurarán, pero sin los adjuntos (pueden haber faltado o estar dañados al hacer la copia de seguridad): $names';
  }

  @override
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining) {
    return '$shown y $remaining más';
  }

  @override
  String get backupRestoreConfirmBody =>
      'Esto REEMPLAZARÁ todas tus notas, papelera, carpetas, ajustes y adjuntos actuales con los datos de la copia de seguridad anterior. Tus datos actuales se perderán permanentemente y esta acción no se puede deshacer.';

  @override
  String get backupRestoringLabel => 'Restaurando copia de seguridad...';

  @override
  String backupRestoreSuccessWithMissingMessage(int count) {
    return 'Copia de seguridad restaurada. Sin embargo, no se encontraron $count adjuntos en la copia de seguridad y no se pudieron restaurar. Se recomienda reiniciar la aplicación para que los cambios surtan efecto por completo.';
  }

  @override
  String get backupRestoreSuccessMessage =>
      'Copia de seguridad restaurada correctamente. Se recomienda reiniciar la aplicación para que los cambios surtan efecto por completo.';

  @override
  String backupRestoreFailedMessage(String error) {
    return 'Ocurrió un error al restaurar: $error';
  }

  @override
  String get backupScreenTitle => 'Copia de seguridad y restauración';

  @override
  String get backupBlockedExitWarningMessage =>
      'Hay una operación en curso, espera a que finalice.';

  @override
  String get backupBusyBackTooltip => 'Operación en curso';

  @override
  String get backupIntroText =>
      'Puedes hacer una copia de seguridad de tus notas, carpetas, ajustes y adjuntos en un único archivo .zip, o restaurar una copia de seguridad que hiciste anteriormente.';

  @override
  String get backupDriveCardTitle => 'Copia de seguridad en Google Drive';

  @override
  String get backupDriveCardSubtitle =>
      'Crea una nueva copia de seguridad y súbela directamente al área privada de tu Google Drive.';

  @override
  String get backupDriveCardButtonLabel => 'Hacer copia de seguridad en Drive';

  @override
  String get backupDeviceCardTitle => 'Copia de seguridad en el dispositivo';

  @override
  String get backupDeviceCardSubtitle =>
      'Guarda todos tus datos en un único archivo .zip en tu dispositivo y compártelo si quieres.';

  @override
  String get backupDeviceCardButtonLabel =>
      'Hacer copia de seguridad en el dispositivo';

  @override
  String get backupHistoryCardTitle => 'Historial de copias de seguridad';

  @override
  String get backupHistoryCardSubtitle =>
      'Consulta todas las copias de seguridad almacenadas en tu dispositivo con su fecha y tamaño; puedes compartirlas, restaurarlas o eliminarlas directamente desde aquí.';

  @override
  String get backupHistoryTabDevice => 'Dispositivo';

  @override
  String get backupHistoryTabDrive => 'Google Drive';

  @override
  String get backupHistoryDeleteDialogTitle => 'Eliminar copia de seguridad';

  @override
  String backupHistoryDeleteDialogBody(String fileName) {
    return '¿Seguro que quieres eliminar permanentemente el archivo de copia de seguridad \"$fileName\"? Esta acción no se puede deshacer.';
  }

  @override
  String get backupHistoryDeviceDeletedMessage =>
      'Copia de seguridad eliminada.';

  @override
  String get backupHistoryDriveDeleteDialogTitle =>
      'Eliminar copia de seguridad de Drive';

  @override
  String backupHistoryDriveDeleteDialogBody(String fileName) {
    return '¿Seguro que quieres eliminar permanentemente la copia de seguridad \"$fileName\" de Google Drive? Esta acción no se puede deshacer y el archivo no se moverá a la papelera.';
  }

  @override
  String get backupHistoryDriveDeletedMessage =>
      'Copia de seguridad de Drive eliminada.';

  @override
  String backupHistoryDriveDeleteFailedMessage(String error) {
    return 'No se pudo eliminar: $error';
  }

  @override
  String get backupHistoryDeviceEmptyTitle =>
      'Todavía no hay copias de seguridad guardadas en este dispositivo.';

  @override
  String get backupHistoryDeviceEmptySubtitle =>
      'Usa \"Hacer copia de seguridad en el dispositivo\" para crear tu primera copia de seguridad.';

  @override
  String get backupHistoryDriveEmptySubtitle =>
      'Usa \"Copia de seguridad en Google Drive\" para crear tu primera copia de seguridad en la nube.';

  @override
  String get backupHistoryDriveSignInPrompt =>
      'Conecta tu cuenta de Google para ver tus copias de seguridad de Drive.';

  @override
  String get backupHistoryConnectGoogleButton => 'Conectar con Google';

  @override
  String get backupHistoryDriveConnectedFallback => 'Conectado';

  @override
  String get backupHistoryUnknownErrorFallback =>
      'Ocurrió un error desconocido.';

  @override
  String get backupHistoryDownloadStartingLabel => 'Iniciando...';

  @override
  String get backupAutoBackupEnabledLabel =>
      'Copia de seguridad automática: activada';

  @override
  String get backupAutoBackupDisabledLabel =>
      'Copia de seguridad automática: desactivada';

  @override
  String get backupOverlayWarningMessage =>
      'Espera, no salgas de la aplicación hasta que la operación termine.';

  @override
  String get pdfExportUntitledNoteLabel => 'Nota sin título';

  @override
  String get pdfExportDefaultAttachmentName => 'Adjunto';

  @override
  String get pdfExportDefaultFileName => 'nota';

  @override
  String get screenshotExportBoundaryNotFoundMessage =>
      'No se pudo capturar la captura de pantalla (límite no encontrado)';

  @override
  String get screenshotExportByteDataNullMessage =>
      'No se pudieron generar los datos de la captura de pantalla';

  @override
  String get screenshotExportPngDecodeFailedMessage =>
      'No se pudo procesar la imagen (error al decodificar el PNG)';

  @override
  String get screenshotCalcTableTotalLabel => 'Total';

  @override
  String get gundemMenuRemoveFromAgenda => 'Quitar de la agenda';

  @override
  String get gundemMenuDeleteNote => 'Eliminar nota';

  @override
  String get gundemSectionOverdue => 'Vencidas';

  @override
  String get gundemSectionToday => 'Hoy';

  @override
  String get gundemSectionTomorrow => 'Mañana';

  @override
  String get gundemSectionNextWeek => 'Próxima semana';

  @override
  String get gundemSectionFurther => 'Más adelante';

  @override
  String get gundemWeekdayMonday => 'Lunes';

  @override
  String get gundemWeekdayTuesday => 'Martes';

  @override
  String get gundemWeekdayWednesday => 'Miércoles';

  @override
  String get gundemWeekdayThursday => 'Jueves';

  @override
  String get gundemWeekdayFriday => 'Viernes';

  @override
  String get gundemWeekdaySaturday => 'Sábado';

  @override
  String get gundemWeekdaySunday => 'Domingo';

  @override
  String get gundemAppBarTitle => 'Agenda';

  @override
  String get gundemCalendarTooltip => 'Calendario';

  @override
  String get gundemEmptyTitle => 'No hay nada en tu agenda';

  @override
  String get gundemEmptySubtitle =>
      'Aquí aparecerán las notas con un recordatorio o una fecha asignada.';

  @override
  String get gundemUntitledNote => 'Nota sin título';

  @override
  String get gundemRepeatHourly => 'Cada hora';

  @override
  String get gundemRepeatDaily => 'Diario';

  @override
  String get gundemRepeatWeekly => 'Semanal';

  @override
  String get gundemRepeatMonthly => 'Mensual';

  @override
  String get gundemRepeatYearly => 'Anual';

  @override
  String get gundemPreviewCalcTableLabel => '[Lista de cálculo]';

  @override
  String get gundemPreviewDrawingLabel => '[Dibujo]';

  @override
  String get gundemPreviewImageLabel => '[Imagen]';

  @override
  String get gundemMonthShortJan => 'ene';

  @override
  String get gundemMonthShortFeb => 'feb';

  @override
  String get gundemMonthShortMar => 'mar';

  @override
  String get gundemMonthShortApr => 'abr';

  @override
  String get gundemMonthShortMay => 'may';

  @override
  String get gundemMonthShortJun => 'jun';

  @override
  String get gundemMonthShortJul => 'jul';

  @override
  String get gundemMonthShortAug => 'ago';

  @override
  String get gundemMonthShortSep => 'sep';

  @override
  String get gundemMonthShortOct => 'oct';

  @override
  String get gundemMonthShortNov => 'nov';

  @override
  String get gundemMonthShortDec => 'dic';

  @override
  String get calendarAppBarTitle => 'Calendario';

  @override
  String get calendarTodayButton => 'Hoy';

  @override
  String get calendarLegendNoteLabel => 'Nota';

  @override
  String get calendarLegendReminderLabel => 'Recordatorio';

  @override
  String get calendarTodayBadge => 'Hoy';

  @override
  String get calendarEmptyDayMessage =>
      'No hay notas ni recordatorios para este día.';

  @override
  String get calendarReminderHourlyLabel => 'Cada hora';

  @override
  String get calendarMonthJan => 'Enero';

  @override
  String get calendarMonthFeb => 'Febrero';

  @override
  String get calendarMonthMar => 'Marzo';

  @override
  String get calendarMonthApr => 'Abril';

  @override
  String get calendarMonthMay => 'Mayo';

  @override
  String get calendarMonthJun => 'Junio';

  @override
  String get calendarMonthJul => 'Julio';

  @override
  String get calendarMonthAug => 'Agosto';

  @override
  String get calendarMonthSep => 'Septiembre';

  @override
  String get calendarMonthOct => 'Octubre';

  @override
  String get calendarMonthNov => 'Noviembre';

  @override
  String get calendarMonthDec => 'Diciembre';

  @override
  String get calendarWeekdayShortMon => 'lun';

  @override
  String get calendarWeekdayShortTue => 'mar';

  @override
  String get calendarWeekdayShortWed => 'mié';

  @override
  String get calendarWeekdayShortThu => 'jue';

  @override
  String get calendarWeekdayShortFri => 'vie';

  @override
  String get calendarWeekdayShortSat => 'sáb';

  @override
  String get calendarWeekdayShortSun => 'dom';

  @override
  String get calendarWeekdayFullMonday => 'Lunes';

  @override
  String get calendarWeekdayFullTuesday => 'Martes';

  @override
  String get calendarWeekdayFullWednesday => 'Miércoles';

  @override
  String get calendarWeekdayFullThursday => 'Jueves';

  @override
  String get calendarWeekdayFullFriday => 'Viernes';

  @override
  String get calendarWeekdayFullSaturday => 'Sábado';

  @override
  String get calendarWeekdayFullSunday => 'Domingo';

  @override
  String get wrongPasswordDialogTitle => 'Contraseña incorrecta';

  @override
  String get wrongPasswordDialogMessage =>
      'La contraseña que introdujiste es incorrecta.';

  @override
  String get commonOkButton => 'Aceptar';

  @override
  String get unlockCategoryAction => 'Desbloquear';

  @override
  String get lockCategoryAction => 'Bloquear';

  @override
  String get categoryUnlockedMessage => 'Desbloqueada';

  @override
  String get categoryLockedMessage => 'Carpeta bloqueada';

  @override
  String get deleteFolderMenuItemLabel => 'Eliminar carpeta';

  @override
  String get deleteFolderDialogTitle => 'Eliminar carpeta';

  @override
  String deleteFolderDialogMessageWithSubfolders(String category) {
    return '¿Seguro que quieres eliminar la carpeta \"$category\" y todas sus subcarpetas? Las notas de estas carpetas quedarán sin categoría.';
  }

  @override
  String deleteFolderDialogMessage(String category) {
    return '¿Seguro que quieres eliminar la carpeta \"$category\"? Las notas de esta carpeta quedarán sin categoría.';
  }

  @override
  String get deleteFolderDialogCancelButton => 'Cancelar';

  @override
  String get deleteFolderDialogConfirmButton => 'Eliminar';

  @override
  String get editCategoryNameColorMenuItemLabel => 'Editar nombre / color';

  @override
  String get addSubfolderMenuItemLabel => 'Crear subcarpeta';

  @override
  String get expandSubfoldersMenuItemLabel => 'Expandir subcarpetas';

  @override
  String get collapseSubfoldersMenuItemLabel => 'Contraer subcarpetas';

  @override
  String saveErrorInfoMessage(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String get welcomeNoteTitle => '¡Bienvenido a DNote! 🚀';

  @override
  String get welcomeNoteContent => '¡Nuevas funciones añadidas!';

  @override
  String get noteListDateGroupToday => 'Hoy';

  @override
  String get noteListDateGroupYesterday => 'Ayer';

  @override
  String get noteListDateGroupLast7Days => 'Últimos 7 días';

  @override
  String get noteListDateGroupLast30Days => 'Últimos 30 días';

  @override
  String get reminderRepeatNoneLabel => 'Sin repetición';

  @override
  String get voiceRecorderPreparingLabel => 'Preparando…';

  @override
  String get voiceRecorderCancelButton => 'Cancelar';

  @override
  String get voiceRecorderStopAddButton => 'Detener y añadir';

  @override
  String get speechToTextMicPermissionDeniedMessage =>
      'No se concedió el permiso de micrófono.';

  @override
  String get speechToTextUnavailableMessage =>
      'El reconocimiento de voz no está disponible en este dispositivo.';

  @override
  String get speechToTextPreparingLabel => 'Preparando…';

  @override
  String get speechToTextListeningLabel => 'Escuchando…';

  @override
  String get speechToTextStartSpeakingPlaceholder => 'Empieza a hablar…';

  @override
  String get speechToTextCancelButton => 'Cancelar';

  @override
  String get speechToTextStopAddButton => 'Detener y añadir';

  @override
  String get textToSpeechNoContentMessage => 'No hay contenido para leer.';

  @override
  String get textToSpeechReadErrorMessage => 'Se produjo un error al leer.';

  @override
  String get textToSpeechUnavailableMessage =>
      'La conversión de texto a voz no está disponible en este dispositivo.';

  @override
  String get textToSpeechPreparingLabel => 'Preparando…';

  @override
  String get textToSpeechPausedLabel => 'Pausado';

  @override
  String get textToSpeechFinishedLabel => 'Lectura completada';

  @override
  String get textToSpeechReadingLabel => 'Leyendo…';

  @override
  String get textToSpeechCloseErrorButton => 'Cerrar';

  @override
  String get textToSpeechReplayButton => 'Leer de nuevo';

  @override
  String get textToSpeechCloseFinishedButton => 'Cerrar';

  @override
  String get textToSpeechPauseButton => 'Pausar';

  @override
  String get textToSpeechResumeButton => 'Reanudar';

  @override
  String get textToSpeechStopButton => 'Detener';

  @override
  String get textToSpeechSpeedSlow => 'Lenta';

  @override
  String get textToSpeechSpeedNormal => 'Normal';

  @override
  String get textToSpeechSpeedFast => 'Rápida';

  @override
  String get calendarPickerCancelButton => 'Cancelar';

  @override
  String get calendarPickerConfirmButton => 'Seleccionar';

  @override
  String get calendarPickerClearButton => 'Borrar';

  @override
  String get reminderPickerDialogTitle => 'Añadir recordatorio';

  @override
  String get reminderPickerDateTodayOption => 'Hoy';

  @override
  String get reminderPickerDateTomorrowOption => 'Mañana';

  @override
  String get reminderPickerDatePickOption => 'Elegir fecha';

  @override
  String get reminderRepeatHourlyLabel => 'Cada hora';

  @override
  String get reminderRepeatDailyLabel => 'Cada día';

  @override
  String get reminderRepeatWeeklyLabel => 'Cada semana';

  @override
  String get reminderRepeatMonthlyLabel => 'Cada mes';

  @override
  String get reminderRepeatYearlyLabel => 'Cada año';

  @override
  String get reminderPickerCalendarHelpText =>
      'Selecciona la fecha del recordatorio';

  @override
  String get reminderPickerCancelButton => 'CANCELAR';

  @override
  String get reminderPickerSaveButton => 'GUARDAR';

  @override
  String get reminderPickerPastTimeErrorMessage =>
      'No se puede seleccionar una hora pasada';

  @override
  String calcTableTotalLabel(String amount) {
    return 'Total: $amount';
  }

  @override
  String get backupCreatePreparingDataLabel => 'Preparando datos...';

  @override
  String get backupCreatePackagingNotesLabel =>
      'Empaquetando notas y carpetas...';

  @override
  String get backupCreateReadingAttachmentsLabel => 'Leyendo adjuntos...';

  @override
  String backupCreateReadingAttachmentsProgressLabel(int current, int total) {
    return 'Leyendo adjuntos... ($current/$total)';
  }

  @override
  String get backupCreateCompressingLabel => 'Comprimiendo archivo zip...';

  @override
  String get backupCreateSavingFileLabel => 'Guardando archivo...';

  @override
  String get backupRestoreValidatingLabel => 'Validando copia de seguridad...';

  @override
  String get backupRestoreValidatedPreparingDataLabel =>
      'Copia de seguridad validada, preparando datos...';

  @override
  String get backupRestoreWritingNotesLabel => 'Escribiendo notas...';

  @override
  String get backupRestoreWritingTrashLabel => 'Escribiendo papelera...';

  @override
  String get backupRestoreTrashWrittenLabel => 'Papelera escrita';

  @override
  String get backupRestoreWritingCategoriesLabel => 'Escribiendo carpetas...';

  @override
  String get backupRestoreCategoriesWrittenLabel => 'Carpetas escritas';

  @override
  String get backupRestoreWritingSettingsLabel => 'Escribiendo ajustes...';

  @override
  String get backupRestoreSettingsWrittenLabel => 'Ajustes escritos';

  @override
  String get backupRestoreCleaningOldAttachmentsLabel =>
      'Limpiando adjuntos antiguos...';

  @override
  String get backupRestoreNoAttachmentsFinishingLabel =>
      'No se encontraron adjuntos, finalizando...';

  @override
  String backupRestoreAttachmentsProgressLabel(int current, int total) {
    return 'Restaurando adjuntos... ($current/$total)';
  }

  @override
  String get backupRestoreCompletedLabel => 'Completado';

  @override
  String get backupValidationCorruptedFileMessage =>
      'El archivo está dañado o no es un archivo de copia de seguridad válido.';

  @override
  String get backupValidationMissingDataMessage =>
      'No se encontraron datos dentro del archivo de copia de seguridad (falta backup_data.json).';

  @override
  String get backupValidationInvalidJsonMessage =>
      'No se pudieron leer los datos de la copia de seguridad (JSON dañado).';

  @override
  String get backupValidationNotDnoteBackupMessage =>
      'Este archivo no es una copia de seguridad de la aplicación dnote.';

  @override
  String get backupValidationVersionUnreadableMessage =>
      'No se pudo leer la información de versión del archivo de copia de seguridad.';

  @override
  String get backupValidationIncompatibleVersionMessage =>
      'Esta copia de seguridad tiene un formato más nuevo que no es compatible con la versión actual de la aplicación. Actualiza la aplicación.';

  @override
  String get backupValidationInvalidVersionMessage =>
      'La información de versión del archivo de copia de seguridad no es válida.';

  @override
  String get backupValidationMissingNotesFieldMessage =>
      'Los datos de la copia de seguridad no tienen el formato esperado (falta el campo de notas).';

  @override
  String get backupValidationMissingTrashFieldMessage =>
      'Los datos de la copia de seguridad no tienen el formato esperado (falta el campo de papelera).';

  @override
  String get backupValidationInvalidCategoriesFieldMessage =>
      'Los datos de la copia de seguridad no tienen el formato esperado (la lista de carpetas no es válida).';

  @override
  String get backupValidationInvalidSettingsFieldMessage =>
      'Los datos de la copia de seguridad no tienen el formato esperado (el campo de ajustes no es válido).';

  @override
  String get backupValidationInvalidNoteRecordMessage =>
      'Los datos de la copia de seguridad no tienen el formato esperado (un registro de nota no es válido).';

  @override
  String get backupValidationMissingNoteIdMessage =>
      'Los datos de la copia de seguridad no tienen el formato esperado (se encontró un registro de nota sin ID).';

  @override
  String get backupValidationFileNotFoundMessage =>
      'No se encontró el archivo de copia de seguridad.';

  @override
  String get backupErrorInsufficientStorageMessage =>
      'No hay suficiente almacenamiento libre en el dispositivo. Libera espacio e inténtalo de nuevo.';

  @override
  String get backupErrorPermissionDeniedMessage =>
      'Se denegó el permiso de acceso a archivos. Comprueba los permisos de la aplicación e inténtalo de nuevo.';

  @override
  String backupErrorFileOperationMessage(String detail) {
    return 'Se produjo un error durante la operación con el archivo: $detail';
  }

  @override
  String backupErrorUnexpectedMessage(String detail) {
    return 'Se produjo un error inesperado: $detail';
  }

  @override
  String get backupErrorZipEncodeFailedMessage =>
      'No se pudo crear el archivo zip (ZipEncoder devolvió null).';

  @override
  String get calcTableMenuItemLabel => 'Lista de cálculo';

  @override
  String get tagsMenuItemLabel => 'Etiquetas';

  @override
  String get linkDialogUrlHint => 'https://ejemplo.com';

  @override
  String get checklistItemHint => 'Añadir elemento...';

  @override
  String get toolbarHighlightTooltip => 'Resaltar';

  @override
  String get toolbarListTooltip => 'Lista';

  @override
  String get toolbarHideKeyboardTooltip => 'Ocultar teclado';

  @override
  String get autoBackupLocalSuccessMessage =>
      'Copia de seguridad local realizada correctamente.';

  @override
  String autoBackupLocalFailedMessage(String detail) {
    return 'Error en la copia de seguridad local: $detail';
  }

  @override
  String get autoBackupDriveSkippedNotConnectedMessage =>
      'Se omitió la copia de seguridad en Drive: la cuenta de Google no está conectada o la sesión ha caducado. Abre la aplicación y vuelve a conectarla.';

  @override
  String get autoBackupDriveSuccessMessage =>
      'Copia de seguridad en Drive realizada correctamente.';

  @override
  String autoBackupDriveFailedMessage(String detail) {
    return 'Error en la copia de seguridad en Drive: $detail';
  }

  @override
  String get noteWidgetNoNotesPlaceholder => 'Aún no hay notas';

  @override
  String noteWidgetPreviewTotalLabel(String total) {
    return 'Total: $total';
  }

  @override
  String get noteWidgetPreviewDrawingLabel => '✏️ Dibujo';

  @override
  String get autoBackupSettingsAppBarTitle =>
      'Ajustes de copia de seguridad automática';

  @override
  String get autoBackupSettingsMainSwitchTitle =>
      'Activar copia de seguridad automática';

  @override
  String get autoBackupSettingsMainSwitchSubtitle =>
      'Tus notas se respaldan de forma segura y periódica en segundo plano.';

  @override
  String get autoBackupSettingsTargetTitle =>
      'Destino de la copia de seguridad';

  @override
  String get autoBackupSettingsTargetSubtitle =>
      'Elige dónde se guardan las copias de seguridad.';

  @override
  String get autoBackupSettingsTargetLocalOption => 'Local';

  @override
  String get autoBackupSettingsTargetDriveOption => 'Google Drive';

  @override
  String get autoBackupSettingsTargetBothOption => 'Ambos';

  @override
  String get autoBackupSettingsDriveNotConnectedNote =>
      'Conecta primero tu cuenta para usar las opciones de Google Drive.';

  @override
  String get autoBackupSettingsConnectButton => 'Conectar';

  @override
  String get autoBackupSettingsFrequencyTitle =>
      'Frecuencia de la copia de seguridad';

  @override
  String autoBackupSettingsFrequencySubtitle(int hours) {
    return 'Se realiza una copia de seguridad cada $hours horas.';
  }

  @override
  String get autoBackupSettingsFrequency6h => '6 horas';

  @override
  String get autoBackupSettingsFrequency12h => '12 horas';

  @override
  String get autoBackupSettingsFrequency24h => '24 horas (diaria)';

  @override
  String get autoBackupSettingsFrequency48h => '48 horas (2 días)';

  @override
  String get autoBackupSettingsFrequency168h => '168 horas (semanal)';

  @override
  String get autoBackupSettingsWifiOnlySwitchTitle => 'Usar solo Wi-Fi';

  @override
  String get autoBackupSettingsWifiOnlySwitchSubtitle =>
      'La subida a la nube solo se realiza por Wi-Fi para proteger tus datos móviles.';

  @override
  String get autoBackupSettingsStatusCardTitle => 'Estado del sistema';

  @override
  String get autoBackupSettingsNeverRunMessage =>
      'La copia de seguridad automática todavía no se ha ejecutado.';

  @override
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  ) {
    return 'Última ejecución: $date $time ($status)\nMensaje: $message';
  }

  @override
  String get autoBackupSettingsStatusSuccessLabel => 'Correcta';

  @override
  String get autoBackupSettingsStatusFailedLabel => 'Fallida';

  @override
  String get autoBackupSettingsDriveConnectFailedSnackbar =>
      'No se pudo conectar con la cuenta de Google.';

  @override
  String get autoBackupSettingsSavedSnackbar =>
      'Se actualizaron los ajustes de copia de seguridad automática.';

  @override
  String selectionModeDeletedMessage(int count) {
    return '$count notas eliminadas';
  }

  @override
  String get selectionModeArchivedMessage => 'Archivada';

  @override
  String selectionModeClassifySheetTitle(int count) {
    return 'Elige una carpeta para $count notas';
  }

  @override
  String get selectionModeAddCategoryOption => 'Añadir carpeta';

  @override
  String get selectionModeRemoveCategoryOption => 'Quitar carpeta';

  @override
  String get calcTableItemHint => 'Elemento...';

  @override
  String get calcTableTotalRowLabel => 'Total';

  @override
  String get textSelectionMenuShareButton => 'Compartir';

  @override
  String get textSelectionMenuTranslateButton => 'Traducir';

  @override
  String get textSelectionMenuShareFailedSnackbar =>
      'No se pudo iniciar el uso compartido.';

  @override
  String get textSelectionMenuTranslateFailedSnackbar =>
      'No se pudo abrir la traducción.';

  @override
  String lastBackupInfoTodayFormat(String time) {
    return 'Hoy $time';
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
    return 'Última copia de seguridad: $date';
  }

  @override
  String get lastBackupInfoNoBackupMessage =>
      'Todavía no se ha realizado ninguna copia de seguridad.';
}
