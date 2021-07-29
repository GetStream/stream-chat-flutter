part of 'stream_chat_localizations.dart';

/// The translations for Spanish (`es`).
class StreamChatLocalizationsEs extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for Spanish.
  const StreamChatLocalizationsEs({String localeName = 'es'})
      : super(localeName: localeName);

  @override
  String get launchUrlError => 'No se puede lanzar la url';

  @override
  String get loadingUsersError => 'Error de carga del usuario';

  @override
  String get noUsersLabel => 'No hay usuarios actualmente';

  @override
  String get retryLabel => 'Inténtalo de nuevo';

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
      '$count Respuestas al hilo de discusión';

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
  String get emptyMessagesText => 'Actualmente no hay mensajes';

  @override
  String get genericErrorText => 'Hubo un problema';

  @override
  String get loadingMessagesError => 'Mensajes de error de carga';

  @override
  String resultCountText(int count) => '$count resultados';

  @override
  String get messageDeletedText => 'Este mensaje ha sido borrado.';

  @override
  String get messageDeletedLabel => 'Mensaje borrado';

  @override
  String get messageReactionsLabel => 'Reacciones a los mensajes';

  @override
  String get emptyChatMessagesText => 'Todavía no hay charlas aquí...';

  @override
  String threadSeparatorText(int replyCount) {
    if (replyCount == 1) return '1 Respuesta';
    return '$replyCount Respuestas';
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
  String get instantCommandsLabel => 'Mandos instantáneos';

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
  String emojiMatchingQueryText(String query) =>
      'Emoji que corresponde a "$query"';

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
      '\ny vídeos para que puedas compartirlos con sus amigos.';

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
  String get replyLabel => 'Respuesta';

  @override
  String togglePinUnpinText({required bool pinned}) {
    if (pinned) return 'Desfijar a la conversación';
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
    return 'Enviar de vuelta';
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
      'Enviado ${_getDay(date)} a ${Jiffy(time.toLocal()).format('HH:mm')}';

  @override
  String get todayLabel => 'Hoy';

  @override
  String get yesterdayLabel => 'Ayer';

  @override
  String get channelIsMutedText => 'El canal está cortado';

  @override
  String get noTitleText => 'Sin título';

  @override
  String get letsStartChattingLabel => '¡Empecemos a charlar!';

  @override
  String get sendingFirstMessageLabel =>
      '¿Qué le parece enviar su primer mensaje a un amigo?';

  @override
  String get startAChatLabel => 'Iniciar una discusión';

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
  String get searchingForNetworkText => 'Búsqueda en la red';

  @override
  String get offlineLabel => 'Sin conexión...';

  @override
  String get tryAgainLabel => 'Inténtalo de nuevo';

  @override
  String membersCountText(int count) {
    if (count == 1) return '1 Membre';
    return '$count Membres';
  }

  @override
  String watchersCountText(int count) {
    if (count == 1) return '1 En línea';
    return '$count En línea';
  }

  @override
  String get viewInfoLabel => 'Ver información';

  @override
  String get leaveGroupLabel => 'Dejar el Grupo';

  @override
  String get leaveLabel => 'DEJAR';

  @override
  String get leaveConversationLabel => 'Dejar la conversación';

  @override
  String get leaveConversationQuestion =>
      '¿Estás seguro de que quieres dejar esta conversación?';

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
  String get ofText => 'de';

  @override
  String get fileText => 'Archivo';

  @override
  String get replyToMessageLabel => 'Responder al Mensaje';
}
