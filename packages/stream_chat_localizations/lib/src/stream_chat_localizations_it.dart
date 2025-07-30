// ignore_for_file: lines_longer_than_80_chars

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
  String get messageDeletedLabel => 'Messaggio eliminato';

  @override
  String get systemMessageLabel => 'Messaggio di sistema';

  @override
  String get editedMessageLabel => 'Modificato';

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
      "Per favore attiva l'accesso alle foto e ai video cosí potrai condividerli con i tuoi amici.";

  @override
  String get allowGalleryAccessMessage => "Permetti l'accesso alla galleria";

  @override
  String get flagMessageLabel => 'Segnala messaggio';

  @override
  String get flagMessageQuestion =>
      'Vuoi mandare una copia di questo messaggio ad un moderatore?';

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
      'Sei sicuro di voler definitivamente cancellare questo messaggio?';

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
      return 'il ${Jiffy.parseFromDateTime(date).MMMd}';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) {
    final atTime = Jiffy.parseFromDateTime(time.toLocal());
    return 'Inviato ${_getDay(date)} alle ${atTime.jm}';
  }

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
  String unreadMessagesSeparatorText() => 'Nouveaux messages';

  @override
  String get enableFileAccessMessage =>
      "Per favore attiva l'accesso ai file cosí potrai condividerli con i tuoi amici.";

  @override
  String get allowFileAccessMessage => "Consenti l'accesso ai file";

  @override
  String get markAsUnreadLabel => 'Contrassegna come non letto';

  @override
  String unreadCountIndicatorLabel({required int unreadCount}) {
    return '$unreadCount non letti';
  }

  @override
  String get markUnreadError =>
      'Errore durante la marcatura del messaggio come non letto. Impossibile'
      ' marcare messaggi non letti più vecchi dei più recenti 100 messaggi'
      ' del canale.';

  @override
  String createPollLabel({bool isNew = false}) {
    if (isNew) return 'Crea un nuovo sondaggio';
    return 'Crea sondaggio';
  }

  @override
  String get questionsLabel => 'Domande';

  @override
  String get askAQuestionLabel => 'Fai una domanda';

  @override
  String? pollQuestionValidationError(int length, Range<int> range) {
    final (:min, :max) = range;

    // Check if the question is too short.
    if (min != null && length < min) {
      return 'La domanda deve essere composta da almeno $min caratteri';
    }

    // Check if the question is too long.
    if (max != null && length > max) {
      return 'La domanda deve essere lunga al massimo $max caratteri';
    }

    return null;
  }

  @override
  String optionLabel({bool isPlural = false}) {
    if (isPlural) return 'Opzioni';
    return 'Opzione';
  }

  @override
  String get pollOptionEmptyError => "L'opzione non può essere vuota";

  @override
  String get pollOptionDuplicateError => "Questa è già un'opzione";

  @override
  String get addAnOptionLabel => "Aggiungi un'opzione";

  @override
  String get multipleAnswersLabel => 'Risposte multiple';

  @override
  String get maximumVotesPerPersonLabel => 'Numero massimo di voti per persona';

  @override
  String? maxVotesPerPersonValidationError(int votes, Range<int> range) {
    final (:min, :max) = range;

    if (min != null && votes < min) {
      return 'Il conteggio dei voti deve essere almeno $min';
    }

    if (max != null && votes > max) {
      return 'Il conteggio dei voti deve essere al massimo $max';
    }

    return null;
  }

  @override
  String get anonymousPollLabel => 'Sondaggio anonimo';

  @override
  String get pollOptionsLabel => 'Opzioni del sondaggio';

  @override
  String get suggestAnOptionLabel => "Suggerisci un'opzione";

  @override
  String get enterANewOptionLabel => 'Inserisci una nuova opzione';

  @override
  String get addACommentLabel => 'Aggiungi un commento';

  @override
  String get pollCommentsLabel => 'Commenti del sondaggio';

  @override
  String get updateYourCommentLabel => 'Aggiorna il tuo commento';

  @override
  String get enterYourCommentLabel => 'Inserisci il tuo commento';

  @override
  String get endVoteConfirmationText =>
      'Sei sicuro di voler terminare il voto?';

  @override
  String get createLabel => 'Crea';

  @override
  String get endLabel => 'Fine';

  @override
  String pollVotingModeLabel(PollVotingMode votingMode) {
    return votingMode.when(
      disabled: () => 'Votazione terminata',
      unique: () => 'Seleziona uno',
      limited: (count) => 'Seleziona fino a $count',
      all: () => 'Seleziona uno o più',
    );
  }

  @override
  String seeAllOptionsLabel({int? count}) {
    if (count == null) return 'Vedi tutte le opzioni';
    return 'Vedi tutte le $count opzioni';
  }

  @override
  String get viewCommentsLabel => 'Visualizza commenti';

  @override
  String get viewResultsLabel => 'Visualizza risultati';

  @override
  String get endVoteLabel => 'Termina votazione';

  @override
  String get pollResultsLabel => 'Risultati del sondaggio';

  @override
  String showAllVotesLabel({int? count}) {
    if (count == null) return 'Mostra tutti i voti';
    return 'Mostra tutti i $count voti';
  }

  @override
  String voteCountLabel({int? count}) => switch (count) {
        null || < 1 => '0 voti',
        1 => '1 voto',
        _ => '$count voti',
      };

  @override
  String get noPollVotesLabel => 'Attualmente non ci sono voti nel sondaggio';

  @override
  String get loadingPollVotesError =>
      'Errore durante il caricamento dei voti del sondaggio';

  @override
  String get repliedToLabel => 'risposto a:';

  @override
  String newThreadsLabel({required int count}) {
    if (count == 1) return '1 nuovo thread';
    return '$count nuovi thread';
  }

  @override
  String get slideToCancelLabel => 'Scorri per annullare';

  @override
  String get holdToRecordLabel =>
      'Tieni premuto per registrare, rilascia per inviare';

  @override
  String get sendAnywayLabel => 'Invia comunque';

  @override
  String get moderatedMessageBlockedText =>
      'Messaggio bloccato dalle politiche di moderazione';

  @override
  String get moderationReviewModalTitle => 'Sei sicuro?';

  @override
  String get moderationReviewModalDescription =>
      '''Considera come il tuo commento potrebbe far sentire gli altri e assicurati di seguire le nostre Linee guida della community.''';

  @override
  String get emptyMessagePreviewText => '';

  @override
  String get voiceRecordingText => 'Registrazione vocale';

  @override
  String get audioAttachmentText => 'Audio';

  @override
  String get imageAttachmentText => 'Immagine';

  @override
  String get videoAttachmentText => 'Video';

  @override
  String get pollYouVotedText => 'Hai votato';

  @override
  String pollSomeoneVotedText(String username) => '$username ha votato';

  @override
  String get pollYouCreatedText => 'Hai creato';

  @override
  String pollSomeoneCreatedText(String username) => '$username ha creato';

  @override
  String get draftLabel => 'Bozza';

  @override
  String locationLabel({bool isLive = false}) {
    if (isLive) return '📍 Posizione dal vivo';
    return '📍 Posizione';
  }
}
