part of 'stream_chat_localizations.dart';

/// The translations for Catalan (`ca`).
class StreamChatLocalizationsCa extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for Catalan.
  const StreamChatLocalizationsCa({super.localeName = 'ca'});

  @override
  String get launchUrlError => "No s'ha pogut obrir la url";

  @override
  String get loadingUsersError => "Error de càrrega de l'usuari";

  @override
  String get noUsersLabel => 'Actualment no hi ha usuaris';

  @override
  String get retryLabel => 'Torna-ho a provar';

  @override
  String get userLastOnlineText => 'Última vegada en línia';

  @override
  String get userOnlineText => 'En línia';

  @override
  String userTypingText(Iterable<User> users) {
    if (users.isEmpty) return '';
    final first = users.first;
    if (users.length == 1) {
      return '${first.name} està escrivint';
    }
    return '${first.name} y ${users.length - 1} estan escrivint';
  }

  @override
  String get threadReplyLabel => 'Respon al fil';

  @override
  String get onlyVisibleToYouText => 'Només visible per vostè';

  @override
  String threadReplyCountText(int count) => '$count respostes al fil';

  @override
  String attachmentsUploadProgressText({
    required int remaining,
    required int total,
  }) =>
      'Transferència en curs $remaining/$total ...';

  @override
  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  }) {
    final pinnedByCurrentUser = currentUser.id == pinnedBy.id;
    if (pinnedByCurrentUser) return 'Fixat per tu';
    return 'Fixat per ${pinnedBy.name}';
  }

  @override
  String get sendMessagePermissionError =>
      'No tens permís per enviar missatges';

  @override
  String get emptyMessagesText => 'Actualment no hi ha missatges';

  @override
  String get genericErrorText => 'Hi ha hagut un problema';

  @override
  String get loadingMessagesError =>
      'Hi ha hagut un error mentres carregava el missatge';

  @override
  String resultCountText(int count) => '$count resultats';

  @override
  String get messageDeletedText => 'Aquest missatge ha estat esborrat.';

  @override
  String get messageDeletedLabel => 'Missatge esborrat';

  @override
  String get messageReactionsLabel => 'Reaccions dels missatges';

  @override
  String get emptyChatMessagesText => 'Encara no hi ha missatges...';

  @override
  String threadSeparatorText(int replyCount) {
    if (replyCount == 1) return '1 resposta';
    return '$replyCount respostes';
  }

  @override
  String get connectedLabel => 'Connectat';

  @override
  String get disconnectedLabel => 'Desconnectat';

  @override
  String get reconnectingLabel => 'Reconnectant...';

  @override
  String get alsoSendAsDirectMessageLabel =>
      'Enviar també com a missatge directe';

  @override
  String get addACommentOrSendLabel => 'Afegir un comentari o enviar';

  @override
  String get searchGifLabel => 'Cerca de GIFs';

  @override
  String get writeAMessageLabel => 'Escriure un missatge';

  @override
  String get instantCommandsLabel => 'Commandes instantànies';

  @override
  String fileTooLargeAfterCompressionError(double limitInMB) =>
      'El fitxer és massa gran descargar-lo. '
      'La mida màxima del fitxer és de $limitInMB MB. '
      'Hem intentat comprimir-lo, pero ha estat suficient.';

  @override
  String fileTooLargeError(double limitInMB) =>
      'El fitxer és massa gran per descargar-lo. '
      'El límit de mida dels fitxers és de $limitInMB MB.';

  @override
  String get couldNotReadBytesFromFileError =>
      "No s'han pogut llegir els bytes del fitxer.";

  @override
  String get addAFileLabel => 'Afegir un fitxer';

  @override
  String get photoFromCameraLabel => 'Foto de la càmera';

  @override
  String get uploadAFileLabel => 'Transferir un fitxer';

  @override
  String get uploadAPhotoLabel => 'Pujar una foto';

  @override
  String get uploadAVideoLabel => 'Pujar un vídeo';

  @override
  String get videoFromCameraLabel => 'Vídeo de la càmera';

  @override
  String get okLabel => 'Vale';

  @override
  String get somethingWentWrongError => 'Alguna cosa ha anat malament';

  @override
  String get addMoreFilesLabel => 'Afegir més fitxers';

  @override
  String get enablePhotoAndVideoAccessMessage =>
      "Si us plau, permeti l'accés a les seves fotos"
      '\ni vídeos per a que pugui compartir-los.';

  @override
  String get allowGalleryAccessMessage => "Permetre l'accés a la galeria";

  @override
  String get flagMessageLabel => 'Reportar un missatge';

  @override
  String get flagMessageQuestion =>
      "¿Vol enviar una còpia d'aquest missatge a un"
      '\nmoderador per una major investigació?';

  @override
  String get flagLabel => 'REPORTAR';

  @override
  String get cancelLabel => 'CANCELAR';

  @override
  String get flagMessageSuccessfulLabel => 'Missatge reportat';

  @override
  String get flagMessageSuccessfulText =>
      'Aquest missatge ha estat reportat a un moderador.';

  @override
  String get deleteLabel => 'ESBORRAR';

  @override
  String get deleteMessageLabel => 'Esborrar el missatge';

  @override
  String get deleteMessageQuestion =>
      '¿Estàs segur de que vols esborrar aquest\nmissatge de forma permanent?';

  @override
  String get operationCouldNotBeCompletedText =>
      "L'operació no s'ha pogut completar.";

  @override
  String get replyLabel => 'Respondre';

  @override
  String togglePinUnpinText({required bool pinned}) {
    if (pinned) return 'Desfixar de la conversa';
    return 'Fixar a la conversa';
  }

  @override
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed}) {
    if (isDeleteFailed) return 'Reintentar esborrar el misssatge';
    return 'Esborrar el misssatge';
  }

  @override
  String get copyMessageLabel => 'Copiar el misssatge';

  @override
  String get editMessageLabel => 'Editar el misssatge';

  @override
  String toggleResendOrResendEditedMessage({required bool isUpdateFailed}) {
    if (isUpdateFailed) return 'Reenviar el missatge modificat';
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
      return 'avui';
    } else if (date == yesterday) {
      return 'ahir';
    } else {
      return 'el ${Jiffy(date).MMMd}';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) =>
      '''Enviat el ${_getDay(date)} a les ${Jiffy(time.toLocal()).format('HH:mm')}''';

  @override
  String get todayLabel => 'Avui';

  @override
  String get yesterdayLabel => 'Ahir';

  @override
  String get channelIsMutedText => 'El canal està silenciat';

  @override
  String get noTitleText => 'Sense títol';

  @override
  String get letsStartChattingLabel => '¡Comencem a parlar!';

  @override
  String get sendingFirstMessageLabel =>
      'Qué li sembla enviar el seu primer missatge a un amic?';

  @override
  String get startAChatLabel => 'Iniciar una conversa';

  @override
  String get loadingChannelsError => 'Error al carregar els canals';

  @override
  String get deleteConversationLabel => 'Esborrar la conversa';

  @override
  String get deleteConversationQuestion =>
      'Estàs segur de que vols esborrar aquesta conversa?';

  @override
  String get streamChatLabel => 'Stream Chat';

  @override
  String get searchingForNetworkText => 'Buscant xarxa';

  @override
  String get offlineLabel => 'Sense connexió...';

  @override
  String get tryAgainLabel => 'Torna-ho a provar';

  @override
  String membersCountText(int count) {
    if (count == 1) return '1 membre';
    return '$count membres';
  }

  @override
  String watchersCountText(int count) {
    if (count == 1) return '1 En línea';
    return '$count En línea';
  }

  @override
  String get viewInfoLabel => 'Veure informació';

  @override
  String get leaveGroupLabel => 'Sortir del Grup';

  @override
  String get leaveLabel => 'SORTIR';

  @override
  String get leaveConversationLabel => 'Sortir de la conversa';

  @override
  String get leaveConversationQuestion =>
      "Estàs segur de que vol sortir d'aquesta conversa?";

  @override
  String get showInChatLabel => 'Mostrar al chat';

  @override
  String get saveImageLabel => 'Guardar la imatge';

  @override
  String get saveVideoLabel => 'Guardar el vídeo';

  @override
  String get uploadErrorLabel => 'ERROR DE TRANSFERENCIA';

  @override
  String get giphyLabel => 'Giphy';

  @override
  String get shuffleLabel => 'Remenar';

  @override
  String get sendLabel => 'Enviar';

  @override
  String get withText => 'amb';

  @override
  String get inText => 'a';

  @override
  String get youText => 'Vostè';

  @override
  String galleryPaginationText({
    required int currentPage,
    required int totalPages,
  }) =>
      '${currentPage + 1} de $totalPages';

  @override
  String get fileText => 'Fitxer';

  @override
  String get replyToMessageLabel => 'Respondre al missatge';

  @override
  String attachmentLimitExceedError(int limit) =>
      'No és possible afegir més de $limit fitxers adjunts';

  @override
  String get viewLibrary => 'Veure llibreria';

  @override
  String get slowModeOnLabel => 'Mode lent activat';

  @override
  String get downloadLabel => 'Descarregar';

  @override
  String toggleMuteUnmuteUserText({required bool isMuted}) {
    if (isMuted) {
      return "Activar so de l'usuari";
    } else {
      return 'Silenciar usuari';
    }
  }

  @override
  String toggleMuteUnmuteGroupQuestion({required bool isMuted}) {
    if (isMuted) {
      return "Estàs segur de que vols activar el so d'aquest grup?";
    } else {
      return 'Estàs segur de que vols silenciar aquest grup?';
    }
  }

  @override
  String toggleMuteUnmuteUserQuestion({required bool isMuted}) {
    if (isMuted) {
      return "Estàs segur de que vols activar el so d'aquest usuari";
    } else {
      return 'Estàs seguro de que vols silenciar aquest usuari?';
    }
  }

  @override
  String toggleMuteUnmuteAction({required bool isMuted}) {
    if (isMuted) {
      return 'ACTIVAR SO';
    } else {
      return 'SILENCIAR';
    }
  }

  @override
  String toggleMuteUnmuteGroupText({required bool isMuted}) {
    if (isMuted) {
      return 'Activar so del grup';
    } else {
      return 'Silenciar grup';
    }
  }

  @override
  String get linkDisabledDetails =>
      'No es permet enviar enllaços a aquesta conversa.';

  @override
  String get linkDisabledError => 'Els enllaços estan deshabilitats';

  @override
  String unreadMessagesSeparatorText(int unreadCount) {
    if (unreadCount == 1) {
      return '1 missatge no llegit';
    }
    return '$unreadCount missatges no llegits';
  }

  @override
  String get enableFileAccessMessage => "Habiliti l'accés als fitxers"
      '\nper poder compartir-los amb amics.';

  @override
  String get allowFileAccessMessage => "Permetre l'accés als fitxers";
}
