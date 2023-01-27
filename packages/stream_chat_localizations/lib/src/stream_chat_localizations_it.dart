part of 'stream_chat_localizations.dart';

/// The translations for Italian (`it`).
class StreamChatLocalizationsIt extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for Italian.
  const StreamChatLocalizationsIt({super.localeName = 'it'});

  @override
  String get launchUrlError => "Impossibile aprire l'url";

  @override
  String get loadingUsersError => 'Errore durante il carimento degli utenti';

  @override
  String get noUsersLabel => "Non c'é nessun utente al momento";

  @override
  String get noPhotoOrVideoLabel => 'Non ci sono foto o video';

  @override
  String get retryLabel => 'Riprova';

  @override
  String get userLastOnlineText => 'Ultimo accesso';

  @override
  String get userOnlineText => 'Online';

  @override
  String userTypingText(Iterable<User> users) {
    if (users.isEmpty) return '';
    final first = users.first;
    if (users.length == 1) {
      return '${first.name} sta scrivendo';
    }
    return '${first.name} e altri ${users.length - 1} stanno scrivendo';
  }

  @override
  String get threadReplyLabel => 'Rispondi nel thread';

  @override
  String get onlyVisibleToYouText => 'Visible solo a te';

  @override
  String threadReplyCountText(int count) {
    if (count == 1) {
      return '1 risposta al thread';
    }
    return '$count risposte al thread';
  }

  @override
  String attachmentsUploadProgressText({
    required int remaining,
    required int total,
  }) =>
      'Caricamento $remaining/$total ...';

  @override
  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  }) {
    final pinnedByCurrentUser = currentUser.id == pinnedBy.id;
    if (pinnedByCurrentUser) return 'Messo in evidenza da te';
    return 'Messo in evidenza da ${pinnedBy.name}';
  }

  @override
  String get sendMessagePermissionError =>
      "Non hai l'autorizzazione per inviare messaggi";

  @override
  String get emptyMessagesText => "Non c'é nessun messaggio al momento";

  @override
  String get genericErrorText => 'Qualcosa è andato storto';

  @override
  String get loadingMessagesError =>
      'Errore durante il caricamento dei messaggi';

  @override
  String resultCountText(int count) => '$count risultati';

  @override
  String get messageDeletedText => 'Questo messaggio è stato eliminato';

  @override
  String get messageDeletedLabel => 'Messaggio cancellato';

  @override
  String get messageReactionsLabel => 'Reazioni al messaggio';

  @override
  String get emptyChatMessagesText => 'Nessuna conversazione al momento...';

  @override
  String threadSeparatorText(int replyCount) {
    if (replyCount == 1) return '1 risposta';
    return '$replyCount risposte';
  }

  @override
  String get connectedLabel => 'Connesso';

  @override
  String get disconnectedLabel => 'Disconnesso';

  @override
  String get reconnectingLabel => 'Riconnessione in corso...';

  @override
  String get alsoSendAsDirectMessageLabel =>
      'Manda anche come messaggio diretto';

  @override
  String get addACommentOrSendLabel => 'Aggiungi un commento o invia';

  @override
  String get searchGifLabel => 'Cerca una GIF';

  @override
  String get writeAMessageLabel => 'Scrivi un messaggio';

  @override
  String get instantCommandsLabel => 'Commandi istantanei';

  @override
  String fileTooLargeAfterCompressionError(double limitInMB) =>
      'Il file è troppo grande per essere caricato. '
      'Il file eccede il limite di $limitInMB MB. '
      'Abbiamo provato a comprimerlo, ma non è stato abbastanza.';

  @override
  String fileTooLargeError(double limitInMB) => '''
Il file è troppo grande per essere caricato. Il limite è di $limitInMB MB.''';

  @override
  String get couldNotReadBytesFromFileError =>
      'Impossibile leggere i byte dal file.';

  @override
  String get addAFileLabel => 'Aggiungi un file';

  @override
  String get photoFromCameraLabel => 'Immagine dalla fotocamera';

  @override
  String get uploadAFileLabel => 'Carica un file';

  @override
  String get uploadAPhotoLabel => 'Carica una foto';

  @override
  String get uploadAVideoLabel => 'Carica un video';

  @override
  String get videoFromCameraLabel => 'Video dalla fotocamera';

  @override
  String get okLabel => 'Ok';

  @override
  String get somethingWentWrongError => 'Qualcosa è andato storto';

  @override
  String get addMoreFilesLabel => 'Aggiungi altri file';

  @override
  String get enablePhotoAndVideoAccessMessage =>
      "Per favore attiva l'accesso alle foto"
      '\ne ai video cosí potrai condividerli con i tuoi amici.';

  @override
  String get allowGalleryAccessMessage => "Permetti l'accesso alla galleria";

  @override
  String get flagMessageLabel => 'Segnala messaggio';

  @override
  String get flagMessageQuestion => 'Vuoi mandare una copia di questo messaggio'
      '\nad un moderatore?';

  @override
  String get flagLabel => 'SEGNALA';

  @override
  String get cancelLabel => 'ANNULLA';

  @override
  String get flagMessageSuccessfulLabel => 'Messaggio segnalato';

  @override
  String get flagMessageSuccessfulText =>
      'Questo messaggio è stato segnalato ad un moderatore.';

  @override
  String get deleteLabel => 'CANCELLA';

  @override
  String get deleteMessageLabel => 'Cancella messaggio';

  @override
  String get deleteMessageQuestion =>
      'Sei sicuro di voler definitivamente cancellare questo\nmessaggio?';

  @override
  String get operationCouldNotBeCompletedText =>
      'Non è stato possibile completare questa operazione.';

  @override
  String get replyLabel => 'Rispondi';

  @override
  String togglePinUnpinText({required bool pinned}) {
    if (pinned) return 'Rimuovi dagli elementi in evidenza';
    return 'Metti in evidenza';
  }

  @override
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed}) {
    if (isDeleteFailed) return 'Riprova a cancellare il messaggio';
    return 'Cancella il messaggio';
  }

  @override
  String get copyMessageLabel => 'Copia messaggio';

  @override
  String get editMessageLabel => 'Modifica messaggio';

  @override
  String toggleResendOrResendEditedMessage({required bool isUpdateFailed}) {
    if (isUpdateFailed) return 'Riprova modifica messaggio';
    return 'Riprova';
  }

  @override
  String get photosLabel => 'Foto';

  String _getDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'oggi';
    } else if (date == yesterday) {
      return 'ieri';
    } else {
      return 'il ${Jiffy(date).MMMd}';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) =>
      "Inviato ${_getDay(date)} alle ${Jiffy(time.toLocal()).format('HH:mm')}";

  @override
  String get todayLabel => 'Oggi';

  @override
  String get yesterdayLabel => 'Ieri';

  @override
  String get channelIsMutedText => 'Il canale è silenziato';

  @override
  String get noTitleText => 'Nessun titolo';

  @override
  String get letsStartChattingLabel => 'Inizia una conversazione!';

  @override
  String get sendingFirstMessageLabel =>
      'Che ne dici di mandare il tuo primo messaggio ad un amico?';

  @override
  String get startAChatLabel => 'Inizia una conversazione';

  @override
  String get loadingChannelsError => 'Errore durante il caricamento dei canali';

  @override
  String get deleteConversationLabel => 'Elimina conversazione';

  @override
  String get deleteConversationQuestion =>
      'Sei sicuro di voler eliminare questa conversazione?';

  @override
  String get streamChatLabel => 'Stream Chat';

  @override
  String get searchingForNetworkText => 'Cercando una connessione';

  @override
  String get offlineLabel => 'Offline...';

  @override
  String get tryAgainLabel => 'Riprova';

  @override
  String membersCountText(int count) {
    if (count == 1) return '1 membro';
    return '$count membri';
  }

  @override
  String watchersCountText(int count) {
    if (count == 1) return '1 Online';
    return '$count Online';
  }

  @override
  String get viewInfoLabel => 'Vedi info';

  @override
  String get leaveGroupLabel => 'Esci dal gruppo';

  @override
  String get leaveLabel => 'ESCI';

  @override
  String get leaveConversationLabel => 'Esci dalla conversazione';

  @override
  String get leaveConversationQuestion =>
      'Sei sicuro di voler lasciare questa conversazione?';

  @override
  String get showInChatLabel => 'Mostra nella chat';

  @override
  String get saveImageLabel => 'Salva immagine';

  @override
  String get saveVideoLabel => 'Salva video';

  @override
  String get uploadErrorLabel => 'ERRORE DURANTE IL CARICAMENTO';

  @override
  String get giphyLabel => 'Giphy';

  @override
  String get shuffleLabel => 'Shuffle';

  @override
  String get sendLabel => 'Invia';

  @override
  String get withText => 'con';

  @override
  String get inText => 'in';

  @override
  String get youText => 'te';

  @override
  String galleryPaginationText({
    required int currentPage,
    required int totalPages,
  }) =>
      '${currentPage + 1} di $totalPages';

  @override
  String get fileText => 'file';

  @override
  String get replyToMessageLabel => 'Rispondi al messaggio';

  @override
  String attachmentLimitExceedError(int limit) => '''
Attenzione: il limite massimo di $limit file è stato superato.
  ''';

  @override
  String get viewLibrary => 'Vedi la biblioteca';

  @override
  String get slowModeOnLabel => 'Slowmode attiva';

  @override
  String get downloadLabel => 'Scaricamento';

  @override
  String toggleMuteUnmuteUserText({required bool isMuted}) {
    if (isMuted) {
      return "Attiva l'audio dell'utente";
    } else {
      return 'Utente muto';
    }
  }

  @override
  String toggleMuteUnmuteGroupQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'Sei sicuro di voler riattivare questo gruppo?';
    } else {
      return 'Sei sicuro di voler disattivare questo gruppo?';
    }
  }

  @override
  String toggleMuteUnmuteUserQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'Sei sicuro di voler riattivare questo utente?';
    } else {
      return 'Sei sicuro di voler silenziare questo utente?';
    }
  }

  @override
  String toggleMuteUnmuteAction({required bool isMuted}) {
    if (isMuted) {
      return 'RIATTIVATO';
    } else {
      return 'MUTO';
    }
  }

  @override
  String toggleMuteUnmuteGroupText({required bool isMuted}) {
    if (isMuted) {
      return 'Riattiva gruppo';
    } else {
      return 'Gruppo muto';
    }
  }

  @override
  String get linkDisabledDetails =>
      'Non è permesso condividere link in questa convesazione.';

  @override
  String get linkDisabledError => 'I links sono disattivati';

  @override
  String unreadMessagesSeparatorText(int unreadCount) => "Nouveaux messages";

  @override
  String get enableFileAccessMessage => "Per favore attiva l'accesso ai file"
      '\ncosí potrai condividerli con i tuoi amici.';

  @override
  String get allowFileAccessMessage => "Consenti l'accesso ai file";
}
