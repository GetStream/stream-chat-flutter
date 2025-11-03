// ignore_for_file: lines_longer_than_80_chars

part of 'stream_chat_localizations.dart';

/// The translations for Spanish (`es`).
class StreamChatLocalizationsEs extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for Spanish.
  const StreamChatLocalizationsEs({super.localeName = 'es'});

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
  String get onlyVisibleToYouText => 'Sólo visible para usted';

  @override
  String threadReplyCountText(int count) =>
      '$count respuestas al hilo de discusión';

  @override
  String attachmentsUploadProgressText({
    required int remaining,
    required int total,
  }) =>
      'Transferencia en curso $remaining/$total ...';

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
  String get sendMessagePermissionError =>
      'No tienes permiso para enviar mensajes';

  @override
  String get emptyMessagesText => 'Actualmente no hay mensajes';

  @override
  String get genericErrorText => 'Hubo un problema';

  @override
  String get loadingMessagesError =>
      'Hubo un error mientras se cargaba el mensaje';

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
  String get alsoSendAsDirectMessageLabel =>
      'Enviar también como mensaje directo';

  @override
  String get addACommentOrSendLabel => 'Añadir un comentario o enviar';

  @override
  String get searchGifLabel => 'Búsqueda de GIFs';

  @override
  String get writeAMessageLabel => 'Escribir un mensaje';

  @override
  String get instantCommandsLabel => 'Comandos instantáneos';

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
  String get couldNotReadBytesFromFileError =>
      'No se pudieron leer los bytes del archivo.';

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
  String get addMoreFilesLabel => 'Añadir más archivos';

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
  String get flagLabel => 'REPORTAR';

  @override
  String get cancelLabel => 'CANCELAR';

  @override
  String get flagMessageSuccessfulLabel => 'Mensaje reportado';

  @override
  String get flagMessageSuccessfulText =>
      'Este mensaje ha sido reportado a un moderador.';

  @override
  String get deleteLabel => 'BORRAR';

  @override
  String get deleteMessageLabel => 'Borrar el mensaje';

  @override
  String get deleteMessageQuestion =>
      '¿Estás seguro de que quieres borrar este mensaje de forma permanente?';

  @override
  String get operationCouldNotBeCompletedText =>
      'La operación no pudo completarse.';

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
  String get sendingFirstMessageLabel =>
      '¿Qué le parece enviar su primer mensaje a un amigo?';

  @override
  String get startAChatLabel => 'Iniciar una conversación';

  @override
  String get loadingChannelsError => 'Error al cargar los canales';

  @override
  String get deleteConversationLabel => 'Borrar la conversación';

  @override
  String get deleteConversationQuestion =>
      '¿Estás seguro de que quieres borrar esta conversación?';

  @override
  String get streamChatLabel => 'Stream Chat';

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
  String get viewInfoLabel => 'Ver información';

  @override
  String get leaveGroupLabel => 'Salir del Grupo';

  @override
  String get leaveLabel => 'SALIR';

  @override
  String get leaveConversationLabel => 'Salir de la conversación';

  @override
  String get leaveConversationQuestion =>
      '¿Estás seguro de que quiere salir de esta conversación?';

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
  }) =>
      '${currentPage + 1} de $totalPages';

  @override
  String get fileText => 'Archivo';

  @override
  String get replyToMessageLabel => 'Responder al Mensaje';

  @override
  String attachmentLimitExceedError(int limit) => '''
No es posible añadir más de $limit archivos adjuntos
  ''';

  @override
  String get viewLibrary => 'Ver Librería';

  @override
  String get slowModeOnLabel => 'Modo lento activado';

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
  String get linkDisabledDetails =>
      'No se permite enviar enlaces en esta conversación.';

  @override
  String get linkDisabledError => 'Los enlaces están deshabilitados';

  @override
  String unreadMessagesSeparatorText() => 'Nuevos mensajes';

  @override
  String get enableFileAccessMessage =>
      'Habilite el acceso a los archivos para poder compartirlos con amigos.';

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
  String get questionsLabel => 'Preguntas';

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
  String get endVoteConfirmationText =>
      '¿Estás seguro de que quieres finalizar la votación?';

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
  String showAllVotesLabel({int? count}) {
    if (count == null) return 'Mostrar todos los votos';
    return 'Mostrar todos los $count votos';
  }

  @override
  String voteCountLabel({int? count}) => switch (count) {
        null || < 1 => '0 votos',
        1 => '1 voto',
        _ => '$count votos',
      };

  @override
  String get noPollVotesLabel => 'No hay votos en la encuesta actualmente';

  @override
  String get loadingPollVotesError =>
      'Error al cargar los votos de la encuesta';

  @override
  String get repliedToLabel => 'respondido a:';

  @override
  String newThreadsLabel({required int count}) {
    if (count == 1) return '1 nuevo hilo';
    return '$count nuevos hilos';
  }

  @override
  String get slideToCancelLabel => 'Desliza para cancelar';

  @override
  String get holdToRecordLabel =>
      'Mantén pulsado para grabar, suelta para enviar';

  @override
  String get sendAnywayLabel => 'Enviar de todos modos';

  @override
  String get moderatedMessageBlockedText =>
      'Mensaje bloqueado por políticas de moderación';

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
    if (isLive) return '📍 Ubicación en vivo';
    return '📍 Ubicación';
  }
}
