// ignore_for_file: lines_longer_than_80_chars

part of 'stream_chat_localizations.dart';

/// The translations for Spanish (`es`).
class StreamChatLocalizationsEs extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for Spanish.
  const StreamChatLocalizationsEs({super.localeName = 'es'});

  @override
  AccessibilityTranslations get accessibility => _AccessibilityTranslationsEs(localeName: localeName);

  @override
  String get launchUrlError => 'No se pudo abrir la url';

  @override
  String get loadingUsersError => 'Error de carga del usuario';

  @override
  String get noUsersLabel => 'No hay usuarios actualmente';

  @override
  String get noPhotoOrVideoLabel => 'No hay fotos ni vídeos';

  @override
  String get retryLabel => 'Inténtelo de nuevo';

  @override
  String get userLastOnlineText => 'Última vez en línea';

  @override
  String get userOnlineText => 'En línea';

  @override
  String userTypingText(Iterable<User> users) {
    if (users.isEmpty) return '';
    final first = users.first;
    if (users.length == 1) {
      return '${first.name} está escribiendo';
    }
    return '${first.name} y ${users.length - 1} están escribiendo';
  }

  @override
  String get threadReplyLabel => 'Responder al hilo de discusión';

  @override
  String get threadLabel => 'Hilo';

  @override
  String get onlyVisibleToYouText => 'Sólo visible para usted';

  @override
  String threadReplyCountText(int count) => '$count respuestas al hilo de discusión';

  @override
  String attachmentsUploadProgressText({
    required int completed,
    required int total,
  }) => 'Subidos $completed de $total ...';

  @override
  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  }) {
    final pinnedByCurrentUser = currentUser.id == pinnedBy.id;
    if (pinnedByCurrentUser) return 'Fijado por ti';
    return 'Fijado por ${pinnedBy.name}';
  }

  @override
  String get sendMessagePermissionError => 'No tienes permiso para enviar mensajes';

  @override
  String get emptyMessagesText => 'Aún no hay mensajes';

  @override
  String get genericErrorText => 'Hubo un problema';

  @override
  String get loadingMessagesError => 'Hubo un error mientras se cargaba el mensaje';

  @override
  String resultCountText(int count) => '$count resultados';

  @override
  String get messageDeletedText => 'Este mensaje ha sido borrado.';

  @override
  String get messageDeletedLabel => 'Mensaje eliminado';

  @override
  String get systemMessageLabel => 'Mensaje del sistema';

  @override
  String get editedMessageLabel => 'Editado';

  @override
  String get messageReactionsLabel => 'Reacciones de los mensajes';

  @override
  String get emptyChatMessagesText => 'Todavía no hay charlas aquí...';

  @override
  String threadSeparatorText(int replyCount) {
    if (replyCount == 1) return '1 respuesta';
    return '$replyCount respuestas';
  }

  @override
  String get connectedLabel => 'Conectado';

  @override
  String get disconnectedLabel => 'Desconectado';

  @override
  String get reconnectingLabel => 'Reconectando...';

  @override
  String get alsoSendAsDirectMessageLabel => 'Enviar también como mensaje directo';

  @override
  String get addACommentOrSendLabel => 'Añadir un comentario o enviar';

  @override
  String get searchGifLabel => 'Búsqueda de GIFs';

  @override
  String get writeAMessageLabel => 'Enviar un mensaje';

  @override
  String get instantCommandsLabel => 'Comandos instantáneos';

  @override
  String get commandUnavailableWhileEditingError => 'Not available while editing';

  @override
  String get commandUnavailableWhileQuotingError => 'Not available while replying';

  @override
  String get commandUnavailableError => 'Command not available';

  @override
  String fileTooLargeAfterCompressionError(double limitInMB) =>
      'El archivo es demasiado grande para descargarlo. '
      'El tamaño máximo del archivo es de $limitInMB MB. '
      'Intentamos comprimirlo, pero no fue suficiente.';

  @override
  String fileTooLargeError(double limitInMB) =>
      'El archivo es demasiado grande para descargarlo. '
      'El límite de tamaño de los archivos es de $limitInMB MB.';

  @override
  String fileTypeNotSupportedError(String? extension) {
    if (extension != null) return "Los archivos '.$extension' no son compatibles para subir.";
    return 'Este tipo de archivo no es compatible para subir.';
  }

  @override
  String get couldNotReadBytesFromFileError => 'No se pudieron leer los bytes del archivo.';

  @override
  String get addAFileLabel => 'Añadir un archivo';

  @override
  String get photoFromCameraLabel => 'Foto de la cámara';

  @override
  String get uploadAFileLabel => 'Transferir un archivo';

  @override
  String get uploadAPhotoLabel => 'Subir una foto';

  @override
  String get uploadAVideoLabel => 'Subir una vídeo';

  @override
  String get videoFromCameraLabel => 'Vídeo de la cámara';

  @override
  String get okLabel => 'Vale';

  @override
  String get somethingWentWrongError => 'Algo ha salido mal';

  @override
  String get addMoreFilesLabel => 'Añadir más';

  @override
  String get enablePhotoAndVideoAccessMessage =>
      'Por favor, permita el acceso a sus fotos y vídeos para que pueda compartirlos con sus amigos.';

  @override
  String get allowGalleryAccessMessage => 'Permitir el acceso a su galería';

  @override
  String get flagMessageLabel => 'Reportar un mensaje';

  @override
  String get flagMessageQuestion =>
      '¿Quiere enviar una copia de este mensaje a un moderador para una mayor investigación?';

  @override
  String get flagLabel => 'Reportar';

  @override
  String get cancelLabel => 'Cancelar';

  @override
  String get flagMessageSuccessfulLabel => 'Mensaje reportado';

  @override
  String get flagMessageSuccessfulText => 'Este mensaje ha sido reportado a un moderador.';

  @override
  String get deleteLabel => 'Borrar';

  @override
  String get deleteMessageLabel => 'Borrar el mensaje';

  @override
  String get deleteMessageQuestion => '¿Estás seguro de que quieres borrar este mensaje de forma permanente?';

  @override
  String get operationCouldNotBeCompletedText => 'La operación no pudo completarse.';

  @override
  String get replyLabel => 'Responder';

  @override
  String togglePinUnpinText({required bool pinned}) {
    if (pinned) return 'Desfijar de la conversación';
    return 'Fijar a la conversación';
  }

  @override
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed}) {
    if (isDeleteFailed) return 'Reintentar borrar el mensaje';
    return 'Borrar el mensaje';
  }

  @override
  String get copyMessageLabel => 'Copiar el mensaje';

  @override
  String get editMessageLabel => 'Editar el mensaje';

  @override
  String toggleResendOrResendEditedMessage({required bool isUpdateFailed}) {
    if (isUpdateFailed) return 'Reenviar el mensaje modificado';
    return 'Reenviar';
  }

  @override
  String get photosLabel => 'Fotos';

  @override
  String get photosAndVideosLabel => 'Fotos y vídeos';

  String _getDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'hoy';
    } else if (date == yesterday) {
      return 'ayer';
    } else {
      return 'el ${Jiffy.parseFromDateTime(date).MMMd}';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) {
    final atTime = Jiffy.parseFromDateTime(time.toLocal());
    return 'Enviado el ${_getDay(date)} a las ${atTime.jm}';
  }

  @override
  String get todayLabel => 'Hoy';

  @override
  String get yesterdayLabel => 'Ayer';

  @override
  String get channelIsMutedText => 'El canal está silenciado';

  @override
  String get noTitleText => 'Sin título';

  @override
  String get letsStartChattingLabel => '¡Empecemos a charlar!';

  @override
  String get sendingFirstMessageLabel => '¿Qué le parece enviar su primer mensaje a un amigo?';

  @override
  String get startAChatLabel => 'Iniciar una conversación';

  @override
  String get loadingChannelsError => 'Error al cargar los canales';

  @override
  String get deleteConversationLabel => 'Borrar la conversación';

  @override
  String get deleteConversationQuestion => '¿Estás seguro de que quieres borrar esta conversación?';

  @override
  String get streamChatLabel => 'Conversaciones';

  @override
  String get searchingForNetworkText => 'Buscando red';

  @override
  String get offlineLabel => 'Sin conexión...';

  @override
  String get tryAgainLabel => 'Inténtelo de nuevo';

  @override
  String membersCountText(int count) {
    if (count == 1) return '1 miembro';
    return '$count miembros';
  }

  @override
  String watchersCountText(int count) {
    if (count == 1) return '1 En línea';
    return '$count En línea';
  }

  @override
  String membersCountWithOnlineText({
    required int memberCount,
    required int onlineCount,
  }) {
    final members = membersCountText(memberCount);
    if (onlineCount <= 0) return members;
    return '$members, ${watchersCountText(onlineCount)}';
  }

  @override
  String get viewInfoLabel => 'Ver información';

  @override
  String get leaveGroupLabel => 'Salir del Grupo';

  @override
  String get leaveLabel => 'SALIR';

  @override
  String get leaveConversationLabel => 'Salir de la conversación';

  @override
  String get leaveConversationQuestion => '¿Estás seguro de que quiere salir de esta conversación?';

  @override
  String get showInChatLabel => 'Mostrar en el chat';

  @override
  String get saveImageLabel => 'Guardar la imagen';

  @override
  String get saveVideoLabel => 'Guardar el vídeo';

  @override
  String get uploadErrorLabel => 'ERROR DE TRANSFERENCIA';

  @override
  String get giphyLabel => 'Giphy';

  @override
  String get shuffleLabel => 'Mezclar';

  @override
  String get sendLabel => 'Enviar';

  @override
  String get withText => 'con';

  @override
  String get inText => 'en';

  @override
  String get youText => 'Usted';

  @override
  String galleryPaginationText({
    required int currentPage,
    required int totalPages,
  }) => '${currentPage + 1} de $totalPages';

  @override
  String get fileText => 'Archivo';

  @override
  String get replyToMessageLabel => 'Responder al Mensaje';

  @override
  String attachmentLimitExceedError(int limit) =>
      '''
No es posible añadir más de $limit archivos adjuntos
  ''';

  @override
  String get viewLibrary => 'Ver Librería';

  @override
  String slowModeOnLabel(int cooldownTimeOut) => 'Modo lento, espera ${cooldownTimeOut}s\u2026';

  @override
  String get commandUsernameLabel => '@username';

  @override
  String get downloadLabel => 'Descargar';

  @override
  String toggleMuteUnmuteUserText({required bool isMuted}) {
    if (isMuted) {
      return 'No silenciar usuario';
    } else {
      return 'Silenciar usuario';
    }
  }

  @override
  String toggleBlockUnblockUserText({required bool isBlocked}) {
    if (isBlocked) return 'Desbloquear usuario';
    return 'Bloquear usuario';
  }

  @override
  String toggleMuteUnmuteGroupQuestion({required bool isMuted}) {
    if (isMuted) {
      return '¿Estás seguro de que quieres activar el sonido de este grupo?';
    } else {
      return '¿Estás seguro de que quieres silenciar a este grupo?';
    }
  }

  @override
  String toggleMuteUnmuteUserQuestion({required bool isMuted}) {
    if (isMuted) {
      return '¿Estás seguro de que quieres activar el sonido de este usuario?';
    } else {
      return '¿Estás seguro de que quieres silenciar a este usuario?';
    }
  }

  @override
  String toggleMuteUnmuteAction({required bool isMuted}) {
    if (isMuted) {
      return 'DESACTIVAR';
    } else {
      return 'SILENCIO';
    }
  }

  @override
  String toggleMuteUnmuteGroupText({required bool isMuted}) {
    if (isMuted) {
      return 'Activar grupo';
    } else {
      return 'Silenciar grupo';
    }
  }

  @override
  String get linkDisabledDetails => 'No se permite enviar enlaces en esta conversación.';

  @override
  String get linkDisabledError => 'Los enlaces están deshabilitados';

  @override
  String unreadMessagesSeparatorText() => 'Nuevos mensajes';

  @override
  String get enableFileAccessMessage => 'Habilite el acceso a los archivos para poder compartirlos con amigos.';

  @override
  String get allowFileAccessMessage => 'Permitir el acceso a los archivos';

  @override
  String get markAsUnreadLabel => 'Marcar como no leído';

  @override
  String unreadCountIndicatorLabel({required int unreadCount}) {
    return '$unreadCount no leídos';
  }

  @override
  String get markUnreadError =>
      'Error al marcar el mensaje como no leído. No se pueden marcar mensajes'
      ' no leídos más antiguos que los últimos 100 mensajes del canal.';

  @override
  String createPollLabel({bool isNew = false}) {
    if (isNew) return 'Crear un nuevo sondeo';
    return 'Crear sondeo';
  }

  @override
  String questionLabel({bool isPlural = false}) {
    if (isPlural) return 'Preguntas';
    return 'Pregunta';
  }

  @override
  String get askAQuestionLabel => 'Hacer una pregunta';

  @override
  String? pollQuestionValidationError(int length, Range<int> range) {
    final (:min, :max) = range;

    // Check if the question is too short.
    if (min != null && length < min) {
      return 'La pregunta debe tener al menos $min caracteres';
    }

    // Check if the question is too long.
    if (max != null && length > max) {
      return 'La pregunta no puede tener más de $max caracteres';
    }

    return null;
  }

  @override
  String optionLabel({bool isPlural = false}) {
    if (isPlural) return 'Opciones';
    return 'Opción';
  }

  @override
  String get pollOptionEmptyError => 'Esta opción no puede estar vacía';

  @override
  String get pollOptionDuplicateError => 'Las opciones no pueden ser iguales';

  @override
  String get addAnOptionLabel => 'Añadir una opción';

  @override
  String get multipleAnswersLabel => 'Respuestas múltiples';

  @override
  String get maximumVotesPerPersonLabel => 'Máximo de votos por persona';

  @override
  String? maxVotesPerPersonValidationError(int votes, Range<int> range) {
    final (:min, :max) = range;

    if (min != null && votes < min) {
      return 'El recuento de votos debe ser al menos $min';
    }

    if (max != null && votes > max) {
      return 'El recuento de votos no puede ser superior a $max';
    }

    return null;
  }

  @override
  String get anonymousPollLabel => 'Encuesta anónima';

  @override
  String get pollOptionsLabel => 'Opciones de la encuesta';

  @override
  String get suggestAnOptionLabel => 'Sugerir una opción';

  @override
  String get enterANewOptionLabel => 'Ingresar una nueva opción';

  @override
  String get addACommentLabel => 'Agregar un comentario';

  @override
  String get pollCommentsLabel => 'Comentarios de la encuesta';

  @override
  String get updateYourCommentLabel => 'Actualizar tu comentario';

  @override
  String get enterYourCommentLabel => 'Ingresa tu comentario';

  @override
  String get endVoteConfirmationTitle => '¿Estás seguro de que quieres finalizar la votación?';

  @override
  String get endVoteConfirmationMessage =>
      '¿Quieres finalizar esta encuesta ahora? Nadie podrá votar en esta encuesta.';

  @override
  String get deletePollOptionLabel => 'Eliminar opción';

  @override
  String get deletePollOptionQuestion => '¿Estás seguro de que quieres eliminar esta opción?';

  @override
  String get createLabel => 'Crear';

  @override
  String get endLabel => 'Finalizar';

  @override
  String pollVotingModeLabel(PollVotingMode votingMode) {
    return votingMode.when(
      disabled: () => 'Votación finalizada',
      unique: () => 'Seleccionar uno',
      limited: (count) => 'Seleccionar hasta $count',
      all: () => 'Seleccionar uno o más',
    );
  }

  @override
  String seeAllOptionsLabel({int? count}) {
    if (count == null) return 'Ver todas las opciones';
    return 'Ver todas las $count opciones';
  }

  @override
  String get viewCommentsLabel => 'Ver comentarios';

  @override
  String get viewResultsLabel => 'Ver resultados';

  @override
  String get endVoteLabel => 'Finalizar votación';

  @override
  String get pollResultsLabel => 'Resultados de la encuesta';

  @override
  String get pollVotesLabel => 'Votos';

  @override
  String showAllVotesLabel({int? count}) {
    if (count == null) return 'Mostrar todos los votos';
    return 'Mostrar todos los $count votos';
  }

  @override
  String get viewAllLabel => 'Ver todo';

  @override
  String voteCountLabel({int? count}) => switch (count) {
    null || < 1 => '0 votos',
    1 => '1 voto',
    _ => '$count votos',
  };

  @override
  String totalVoteCountLabel({int? count}) => switch (count) {
    null || < 1 => '0 votos en total',
    1 => '1 voto en total',
    _ => '$count votos en total',
  };

  @override
  String get noPollVotesLabel => 'No hay votos en la encuesta actualmente';

  @override
  String get loadingPollVotesError => 'Error al cargar los votos de la encuesta';

  @override
  String get repliedToLabel => 'respondido a:';

  @override
  String newThreadsLabel({required int count}) {
    if (count == 1) return '1 nuevo hilo';
    return '$count nuevos hilos';
  }

  @override
  String get loadingLabel => 'Cargando...';

  @override
  String get slideToCancelLabel => 'Desliza para cancelar';

  @override
  String get holdToRecordLabel => 'Mantén pulsado para grabar, suelta para enviar';

  @override
  String get sendAnywayLabel => 'Enviar de todos modos';

  @override
  String get moderatedMessageBlockedText => 'Mensaje bloqueado por políticas de moderación';

  @override
  String get moderationReviewModalTitle => '¿Estás seguro?';

  @override
  String get moderationReviewModalDescription =>
      '''Considera cómo tu comentario podría hacer sentir a los demás y asegúrate de seguir nuestras Directrices de la Comunidad.''';

  @override
  String get emptyMessagePreviewText => '';

  @override
  String get voiceRecordingText => 'Grabación de voz';

  @override
  String get audioAttachmentText => 'Audio';

  @override
  String get imageAttachmentText => 'Imagen';

  @override
  String get videoAttachmentText => 'Video';

  @override
  String get fileAttachmentText => 'Archivo';

  @override
  String get linkAttachmentText => 'Enlace';

  @override
  String filesAttachmentCountText(int count) => count == 1 ? 'Archivo' : '$count archivos';

  @override
  String photosAttachmentCountText(int count) => count == 1 ? 'Foto' : '$count fotos';

  @override
  String videosAttachmentCountText(int count) => count == 1 ? 'Vídeo' : '$count vídeos';

  @override
  String get pollYouVotedText => 'Has votado';

  @override
  String pollSomeoneVotedText(String username) => '$username ha votado';

  @override
  String get pollYouCreatedText => 'Has creado';

  @override
  String pollSomeoneCreatedText(String username) => '$username ha creado';

  @override
  String get draftLabel => 'Borrador';

  @override
  String locationLabel({bool isLive = false}) {
    if (isLive) return 'Ubicación en vivo';
    return 'Ubicación';
  }

  @override
  String get noConversationsYetText => 'Aún no hay conversaciones';

  @override
  String get replyToStartThreadText => 'Responde a un mensaje para iniciar un hilo';

  @override
  String get sendMessageToStartConversationText => 'Envía un mensaje para iniciar la conversación';

  @override
  String get savedForLaterLabel => 'Guardado para después';

  @override
  String get repliedToThreadAnnotationLabel => 'Respondió a un hilo';

  @override
  String get alsoSentInChannelAnnotationLabel => 'También enviado en el canal';

  @override
  String get viewLabel => 'Ver';

  @override
  String get reminderSetLabel => 'Recordatorio establecido';

  @override
  String reminderAtText(String time) => 'Hoy a las $time';

  @override
  String get createPollPromptLabel => '¡Crea una encuesta y deja que todos voten!';

  @override
  String get takePhotoAndShareLabel => 'Toma una foto y comparte';

  @override
  String get takeVideoAndShareLabel => 'Graba un video y comparte';

  @override
  String get openCameraLabel => 'Abrir cámara';

  @override
  String get selectFilesToShareLabel => 'Selecciona archivos para compartir';

  @override
  String get openFilesLabel => 'Abrir archivos';

  @override
  String get unsupportedAttachmentLabel => 'Archivo adjunto no compatible';

  @override
  String get confirmLabel => 'CONFIRMAR';

  @override
  String get emptyReactionsText => 'Aún no hay reacciones';

  @override
  String get loadingReactionsError => 'Error al cargar las reacciones';

  @override
  String get tapToRemoveReactionLabel => 'Toca para eliminar';

  @override
  String reactionsCountText(int count) => '$count reacciones';

  @override
  String get justNowLabel => 'Ahora mismo';

  @override
  String replyToUserLabel(String userName) => 'Responder a $userName';

  @override
  String get multipleAnswersDescription => 'Seleccionar más de una opción';

  @override
  String maximumVotesPerPersonDescription([Range<int>? range]) {
    final (:min, :max) = range ?? (min: 2, max: 10);
    return 'Elige entre $min\u2013$max opciones';
  }

  @override
  String get anonymousPollDescription => 'Ocultar quién votó';

  @override
  String get suggestAnOptionDescription => 'Permitir que otros añadan opciones';

  @override
  String get addACommentDescription => 'Permitir que otros añadan comentarios';

  @override
  String get notifyChannelText => 'Notificar a todos en este canal';

  @override
  String get notifyHereText => 'Notificar a todos los miembros en línea de este canal';

  @override
  String notifyRoleText(String role) => 'Notificar a todos los miembros $role';
}

class _AccessibilityTranslationsEs extends AccessibilityTranslations {
  const _AccessibilityTranslationsEs({super.localeName = 'es'});

  @override
  String get sendMessageTooltip => 'Enviar mensaje';

  @override
  String get saveEditTooltip => 'Guardar edición';

  @override
  String get sendCommandTooltip => 'Enviar comando';

  @override
  String slowModeTooltip({required int seconds}) {
    if (seconds == 1) return 'Modo lento: 1 segundo';
    return 'Modo lento: $seconds segundos';
  }

  @override
  String get recordVoiceRecordingLabel => 'Grabar mensaje de voz';

  @override
  String get cancelRecordingTooltip => 'Cancelar grabación';

  @override
  String get stopRecordingTooltip => 'Detener grabación';

  @override
  String get sendRecordingTooltip => 'Enviar grabación';

  @override
  String recordingDurationLabel({required Duration duration}) => 'Duración de grabación, ${formatDuration(duration)}';

  @override
  String voiceRecordingPreviewPlayLabel({required Duration duration}) =>
      'Reproducir grabación de voz, ${formatDuration(duration)}';

  @override
  String voiceRecordingPreviewPauseLabel({required Duration duration}) =>
      'Pausar grabación de voz, ${formatDuration(duration)}';

  @override
  String get attachmentPickerTooltip => 'Abrir selector de archivos adjuntos';

  @override
  String get attachmentPickerOpenHint => 'toca dos veces para abrir el selector de archivos adjuntos';

  @override
  String get attachmentPickerCloseHint => 'toca dos veces para cerrar el selector de archivos adjuntos';

  @override
  String get attachmentPickerOpenTapHint => 'abrir selector de archivos adjuntos';

  @override
  String get attachmentPickerCloseTapHint => 'cerrar selector de archivos adjuntos';

  @override
  String get attachmentPickerOpenedAnnouncement => 'Selector de archivos adjuntos abierto';

  @override
  String get attachmentPickerClosedAnnouncement => 'Selector de archivos adjuntos cerrado';

  @override
  String voiceRecordingAttachmentLabel({Duration? duration}) {
    if (duration == null) return 'Mensaje de voz';
    return 'Mensaje de voz, ${formatDuration(duration)}';
  }

  @override
  String videoAttachmentLabel({String? title}) {
    if (title == null || title.isEmpty) return 'Vídeo';
    return 'Vídeo, $title';
  }

  @override
  String get gifAttachmentLabel => 'GIF';

  @override
  String imageAttachmentLabel({String? title}) {
    if (title == null || title.isEmpty) return 'Foto';
    return 'Foto, $title';
  }

  @override
  String get voiceRecordingPlayTooltip => 'Reproducir';

  @override
  String get voiceRecordingPauseTooltip => 'Pausa';

  @override
  String get voiceRecordingLoadingTooltip => 'Cargando';

  @override
  String get channelInfoLabel => 'Información del canal';

  @override
  String get messageActionsLabel => 'Acciones del mensaje';

  @override
  String galleryImageLabel({DateTime? createdAt}) {
    if (createdAt == null) return 'Foto';
    return 'Foto, ${formatDateTime(createdAt)}';
  }

  @override
  String galleryVideoLabel({
    DateTime? createdAt,
    Duration? duration,
  }) {
    final parts = <String>[
      'Vídeo',
      if (duration != null) formatDuration(duration),
      if (createdAt != null) formatDateTime(createdAt),
    ];
    return parts.join(', ');
  }

  @override
  String get selectMediaTapHint => 'seleccionar';

  @override
  String get deselectMediaTapHint => 'deseleccionar';

  @override
  String get savePollTooltip => 'Guardar encuesta';

  @override
  String removePollOptionTooltip({String? optionText}) {
    final trimmed = optionText?.trim();
    if (trimmed == null || trimmed.isEmpty) return 'Eliminar opción';
    return 'Eliminar opción $trimmed';
  }

  @override
  String get recordingStartedAnnouncement =>
      'Grabación iniciada. Desliza a la izquierda para cancelar. Desliza hacia arriba para bloquear.';

  @override
  String get recordingLockedAnnouncement => 'Grabación bloqueada';

  @override
  String get recordingStoppedAnnouncement => 'Grabación detenida';

  @override
  String get recordingCancelledAnnouncement => 'Grabación cancelada';

  @override
  String get recordingCompletedAnnouncement => 'Grabación completada';

  @override
  String get imageAttachmentAddedAnnouncement => 'Foto añadida';

  @override
  String get imageAttachmentRemovedAnnouncement => 'Foto eliminada';

  @override
  String get videoAttachmentAddedAnnouncement => 'Vídeo añadido';

  @override
  String get videoAttachmentRemovedAnnouncement => 'Vídeo eliminado';

  @override
  String get gifAttachmentAddedAnnouncement => 'GIF añadido';

  @override
  String get gifAttachmentRemovedAnnouncement => 'GIF eliminado';

  @override
  String get fileAttachmentAddedAnnouncement => 'Archivo añadido';

  @override
  String get fileAttachmentRemovedAnnouncement => 'Archivo eliminado';

  @override
  String get voiceRecordingAttachmentAddedAnnouncement => 'Mensaje de voz añadido';

  @override
  String get voiceRecordingAttachmentRemovedAnnouncement => 'Mensaje de voz eliminado';

  @override
  String get attachmentAddedAnnouncement => 'Archivo adjunto añadido';

  @override
  String get attachmentRemovedAnnouncement => 'Archivo adjunto eliminado';

  @override
  String attachmentsAddedAnnouncement({required int count}) {
    if (count == 1) return '1 archivo adjunto añadido';
    return '$count archivos adjuntos añadidos';
  }

  @override
  String attachmentsRemovedAnnouncement({required int count}) {
    if (count == 1) return '1 archivo adjunto eliminado';
    return '$count archivos adjuntos eliminados';
  }

  @override
  String formatDateTime(DateTime dateTime) {
    final jiffy = Jiffy.parseFromDateTime(dateTime);
    return '${jiffy.EEEE}, ${jiffy.yMMMMd}, ${jiffy.jm}';
  }

  @override
  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final parts = <String>[
      if (hours > 0) Intl.plural(hours, one: '$hours hora', other: '$hours horas', locale: localeName),
      if (minutes > 0) Intl.plural(minutes, one: '$minutes minuto', other: '$minutes minutos', locale: localeName),
      if (seconds > 0 || (hours == 0 && minutes == 0))
        Intl.plural(seconds, one: '$seconds segundo', other: '$seconds segundos', locale: localeName),
    ];
    return parts.join(', ');
  }
}
