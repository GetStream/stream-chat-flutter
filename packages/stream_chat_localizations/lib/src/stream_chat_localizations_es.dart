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
  String get messageDeletedLabel => 'Mensaje borrado';

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
      'Por favor, permita el acceso a sus fotos'
      '\ny vídeos para que pueda compartirlos con sus amigos.';

  @override
  String get allowGalleryAccessMessage => 'Permitir el acceso a su galería';

  @override
  String get flagMessageLabel => 'Reportar un mensaje';

  @override
  String get flagMessageQuestion =>
      '¿Quiere enviar una copia de este mensaje a un'
      '\nmoderador para una mayor investigación?';

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
      '¿Estás seguro de que quieres borrar este\nmensaje de forma permanente?';

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
      return 'el ${Jiffy(date).MMMd}';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) =>
      '''Enviado el ${_getDay(date)} a las ${Jiffy(time.toLocal()).format('HH:mm')}''';

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
  String get enableFileAccessMessage => 'Habilite el acceso a los archivos'
      '\npara poder compartirlos con amigos.';

  @override
  String get allowFileAccessMessage => 'Permitir el acceso a los archivos';
}
