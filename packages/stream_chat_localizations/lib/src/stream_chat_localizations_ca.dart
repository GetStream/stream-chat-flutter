// ignore_for_file: lines_longer_than_80_chars

part of 'stream_chat_localizations.dart';

/// The translations for Catalan (`ca`).
class StreamChatLocalizationsCa extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for Catalan.
  const StreamChatLocalizationsCa({super.localeName = 'ca'});

  @override
  String get launchUrlError => "No s'ha pogut obrir l'enllaç";

  @override
  String get loadingUsersError => "Error de càrrega de l'usuari";

  @override
  String get noUsersLabel => 'Actualment no hi ha usuaris';

  @override
  String get noPhotoOrVideoLabel => 'No hi ha fotos ni vídeos';

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
  String get onlyVisibleToYouText => 'Només visible per a tu';

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
      'Hi ha hagut un error mentre carregava el missatge';

  @override
  String resultCountText(int count) => '$count resultats';

  @override
  String get messageDeletedText => 'Aquest missatge ha estat esborrat';

  @override
  String get messageDeletedLabel => 'Missatge eliminat';

  @override
  String get systemMessageLabel => 'Missatge del sistema';

  @override
  String get editedMessageLabel => 'Editat';

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
      'El fitxer és massa gran per descarregar-lo. '
      'La mida màxima del fitxer és de $limitInMB MB. '
      'Hem intentat comprimir-lo, pero no ha estat suficient.';

  @override
  String fileTooLargeError(double limitInMB) =>
      'El fitxer és massa gran per descarregar-lo. '
      'La mida màxima del fitxer és de $limitInMB MB.';

  @override
  String get couldNotReadBytesFromFileError =>
      "No s'han pogut llegir els bytes del fitxer.";

  @override
  String get addAFileLabel => 'Afegeix un fitxer';

  @override
  String get photoFromCameraLabel => 'Foto de la càmera';

  @override
  String get uploadAFileLabel => 'Transferir un fitxer';

  @override
  String get uploadAPhotoLabel => 'Puja una foto';

  @override
  String get uploadAVideoLabel => 'Puja un vídeo';

  @override
  String get videoFromCameraLabel => 'Vídeo de la càmera';

  @override
  String get okLabel => "D'acord";

  @override
  String get somethingWentWrongError => 'Alguna cosa ha anat malament';

  @override
  String get addMoreFilesLabel => 'Afegir més fitxers';

  @override
  String get enablePhotoAndVideoAccessMessage =>
      "Si us plau, permet l'accés a les teves fotos i vídeos per a que puguis compartir-los";

  @override
  String get allowGalleryAccessMessage => "Permet l'accés a la galeria";

  @override
  String get flagMessageLabel => 'Reporta un missatge';

  @override
  String get flagMessageQuestion =>
      "Vols enviar una còpia d'aquest missatge a un moderador per una major investigació?";

  @override
  String get flagLabel => 'REPORTA';

  @override
  String get cancelLabel => 'CANCEL·LA';

  @override
  String get flagMessageSuccessfulLabel => 'Missatge reportat';

  @override
  String get flagMessageSuccessfulText =>
      'Aquest missatge ha estat reportat a un moderador';

  @override
  String get deleteLabel => 'ESBORRA';

  @override
  String get deleteMessageLabel => 'Esborra el missatge';

  @override
  String get deleteMessageQuestion =>
      'Estàs segur que vols esborrar aquest missatge de forma permanent?';

  @override
  String get operationCouldNotBeCompletedText =>
      "L'operació no s'ha pogut completar";

  @override
  String get replyLabel => 'Respondre';

  @override
  String togglePinUnpinText({required bool pinned}) {
    if (pinned) return 'Desfixa de la conversa';
    return 'Fixa a la conversa';
  }

  @override
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed}) {
    if (isDeleteFailed) return 'Reintenta esborrar el missatge';
    return 'Esborra el missatge';
  }

  @override
  String get copyMessageLabel => 'Copia el missatge';

  @override
  String get editMessageLabel => 'Edita el missatge';

  @override
  String toggleResendOrResendEditedMessage({required bool isUpdateFailed}) {
    if (isUpdateFailed) return 'Reenvia el missatge modificat';
    return 'Reenvia';
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
      return 'el ${Jiffy.parseFromDateTime(date).MMMd}';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) {
    final atTime = Jiffy.parseFromDateTime(time.toLocal());
    return 'Enviat el ${_getDay(date)} a les ${atTime.jm}';
  }

  @override
  String get todayLabel => 'Avui';

  @override
  String get yesterdayLabel => 'Ahir';

  @override
  String get channelIsMutedText => 'El canal està silenciat';

  @override
  String get noTitleText => 'Sense títol';

  @override
  String get letsStartChattingLabel => 'Comencem a parlar!';

  @override
  String get sendingFirstMessageLabel =>
      'Què et sembla enviar el teu primer missatge?';

  @override
  String get startAChatLabel => 'Inicia una conversa';

  @override
  String get loadingChannelsError => 'Error al carregar els canals';

  @override
  String get deleteConversationLabel => 'Esborra la conversa';

  @override
  String get deleteConversationQuestion =>
      'Estàs segur que vols esborrar aquesta conversa?';

  @override
  String get streamChatLabel => 'Stream Chat';

  @override
  String get searchingForNetworkText => 'Cercant xarxa';

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
    if (count == 1) return '1 En línia';
    return '$count En línia';
  }

  @override
  String get viewInfoLabel => 'Veure informació';

  @override
  String get leaveGroupLabel => 'Sortir del Grup';

  @override
  String get leaveLabel => 'SURT';

  @override
  String get leaveConversationLabel => 'Surt de la conversa';

  @override
  String get leaveConversationQuestion =>
      "Estàs segur que vols sortir d'aquesta conversa?";

  @override
  String get showInChatLabel => 'Mostra al xat';

  @override
  String get saveImageLabel => 'Guarda la imatge';

  @override
  String get saveVideoLabel => 'Guarda el vídeo';

  @override
  String get uploadErrorLabel => 'ERROR DE TRANSFERÈNCIA';

  @override
  String get giphyLabel => 'Giphy';

  @override
  String get shuffleLabel => 'Remena';

  @override
  String get sendLabel => 'Envia';

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
  String get downloadLabel => 'Descarrega';

  @override
  String toggleMuteUnmuteUserText({required bool isMuted}) {
    if (isMuted) {
      return "Activa so de l'usuari";
    } else {
      return "Silencia l'usuari";
    }
  }

  @override
  String toggleMuteUnmuteGroupQuestion({required bool isMuted}) {
    if (isMuted) {
      return "Estàs segur que vols activar el so d'aquest grup?";
    } else {
      return 'Estàs segur que vols silenciar aquest grup?';
    }
  }

  @override
  String toggleMuteUnmuteUserQuestion({required bool isMuted}) {
    if (isMuted) {
      return "Estàs segur que vols activar el so d'aquest usuari?";
    } else {
      return 'Estàs segur que vols silenciar aquest usuari?';
    }
  }

  @override
  String toggleMuteUnmuteAction({required bool isMuted}) {
    if (isMuted) {
      return 'ACTIVA SO';
    } else {
      return 'SILENCIA';
    }
  }

  @override
  String toggleMuteUnmuteGroupText({required bool isMuted}) {
    if (isMuted) {
      return 'Activa so del grup';
    } else {
      return 'Silencia el grup';
    }
  }

  @override
  String get linkDisabledDetails =>
      'No es permet enviar enllaços a aquesta conversa';

  @override
  String get linkDisabledError => 'Els enllaços estan deshabilitats';

  @override
  String unreadMessagesSeparatorText() => 'Missatges nous';

  @override
  String get enableFileAccessMessage =>
      "Habilita l'accés als fitxers per poder compartir-los amb amics";

  @override
  String get allowFileAccessMessage => "Permet l'accés als fitxers";

  @override
  String get markAsUnreadLabel => 'Marcar com no llegit';

  @override
  String unreadCountIndicatorLabel({required int unreadCount}) {
    return '$unreadCount sense llegir';
  }

  @override
  String get markUnreadError =>
      'Error en marcar el missatge com a no llegit. No es poden marcar'
      ' missatges no llegits més antics que els 100 missatges més recents del'
      ' canal.';

  @override
  String createPollLabel({bool isNew = false}) {
    if (isNew) return 'Crear una enquesta nova';
    return 'Crea enquesta';
  }

  @override
  String get questionsLabel => 'Preguntes';

  @override
  String get askAQuestionLabel => 'Fes una pregunta';

  @override
  String? pollQuestionValidationError(int length, Range<int> range) {
    final (:min, :max) = range;

    // Check if the question is too short.
    if (min != null && length < min) {
      return 'La pregunta ha de tenir com a mínim $min caràcters';
    }

    // Check if the question is too long.
    if (max != null && length > max) {
      return 'La pregunta ha de tenir com a màxim $max caràcters';
    }

    return null;
  }

  @override
  String optionLabel({bool isPlural = false}) {
    if (isPlural) return 'Opcions';
    return 'Opció';
  }

  @override
  String get pollOptionEmptyError => "L'opció no pot estar buida";

  @override
  String get pollOptionDuplicateError => 'Això ja és una opció';

  @override
  String get addAnOptionLabel => 'Afegeix una opció';

  @override
  String get multipleAnswersLabel => 'Respostes múltiples';

  @override
  String get maximumVotesPerPersonLabel => 'Màxim de vots per persona';

  @override
  String? maxVotesPerPersonValidationError(int votes, Range<int> range) {
    final (:min, :max) = range;

    if (min != null && votes < min) {
      return 'El recompte de vots ha de ser com a mínim de $min';
    }

    if (max != null && votes > max) {
      return 'El recompte de vots ha de ser com a màxim de $max';
    }

    return null;
  }

  @override
  String get anonymousPollLabel => 'Votació anònima';

  @override
  String get pollOptionsLabel => 'Opcions de votació';

  @override
  String get suggestAnOptionLabel => 'Suggerir una opció';

  @override
  String get enterANewOptionLabel => 'Introduïu una nova opció';

  @override
  String get addACommentLabel => 'Afegir un comentari';

  @override
  String get pollCommentsLabel => 'Comentaris de la votació';

  @override
  String get updateYourCommentLabel => 'Actualitzar el vostre comentari';

  @override
  String get enterYourCommentLabel => 'Introdueix el teu comentari';

  @override
  String get endVoteConfirmationText =>
      'Estàs segur que vols finalitzar la votació?';

  @override
  String get deletePollOptionLabel => 'Eliminar opció';

  @override
  String get deletePollOptionQuestion =>
      'Estàs segur que vols eliminar aquesta opció?';

  @override
  String get createLabel => 'Crear';

  @override
  String get endLabel => 'Finalitzar';

  @override
  String pollVotingModeLabel(PollVotingMode votingMode) {
    return votingMode.when(
      disabled: () => 'Votació finalitzada',
      unique: () => 'Seleccionar un',
      limited: (count) => 'Seleccionar fins a $count',
      all: () => 'Seleccionar un o més',
    );
  }

  @override
  String seeAllOptionsLabel({int? count}) {
    if (count == null) return 'Veure totes les opcions';
    return 'Veure totes les $count opcions';
  }

  @override
  String get viewCommentsLabel => 'Veure comentaris';

  @override
  String get viewResultsLabel => 'Veure resultats';

  @override
  String get endVoteLabel => 'Finalitzar votació';

  @override
  String get pollResultsLabel => 'Resultats de la votació';

  @override
  String showAllVotesLabel({int? count}) {
    if (count == null) return 'Mostrar tots els vots';
    return 'Mostrar tots els $count vots';
  }

  @override
  String voteCountLabel({int? count}) => switch (count) {
        null || < 1 => '0 vots',
        1 => '1 vot',
        _ => '$count vots',
      };

  @override
  String get noPollVotesLabel => 'No hi ha vots en aquest moment';

  @override
  String get loadingPollVotesError => 'Error en carregar els vots';

  @override
  String get repliedToLabel => 'resposta a:';

  @override
  String newThreadsLabel({required int count}) {
    if (count == 1) return '1 fil nou';
    return '$count fils nous';
  }

  @override
  String get slideToCancelLabel => 'Llisca per cancel·lar';

  @override
  String get holdToRecordLabel =>
      'Mantén premut per gravar, deixa anar per enviar';

  @override
  String get sendAnywayLabel => 'Enviar igualment';

  @override
  String get moderatedMessageBlockedText =>
      'Missatge bloquejat per les polítiques de moderació';

  @override
  String get moderationReviewModalTitle => 'Estàs segur?';

  @override
  String get moderationReviewModalDescription =>
      '''Considera com el teu comentari pot fer sentir als altres i assegura't de seguir les nostres Directrius de la Comunitat.''';

  @override
  String get emptyMessagePreviewText => '';

  @override
  String get voiceRecordingText => 'Enregistrament de veu';

  @override
  String get audioAttachmentText => 'Àudio';

  @override
  String get imageAttachmentText => 'Imatge';

  @override
  String get videoAttachmentText => 'Vídeo';

  @override
  String get pollYouVotedText => 'Has votat';

  @override
  String pollSomeoneVotedText(String username) => '$username ha votat';

  @override
  String get pollYouCreatedText => 'Has creat';

  @override
  String pollSomeoneCreatedText(String username) => '$username ha creat';

  @override
  String get draftLabel => 'Esborrany';

  @override
  String locationLabel({bool isLive = false}) {
    if (isLive) return '📍 Ubicació en directe';
    return '📍 Ubicació';
  }
}
