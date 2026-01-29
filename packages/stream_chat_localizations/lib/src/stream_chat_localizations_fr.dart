// ignore_for_file: lines_longer_than_80_chars

part of 'stream_chat_localizations.dart';

/// The translations for French (`fr`).
class StreamChatLocalizationsFr extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for French.
  const StreamChatLocalizationsFr({super.localeName = 'fr'});

  @override
  String get launchUrlError => "Impossible de lancer l'url";

  @override
  String get loadingUsersError => 'Erreur de chargement des utilisateurs';

  @override
  String get noUsersLabel => "Il n'y a pas d'utilisateurs actuellement";

  @override
  String get noPhotoOrVideoLabel => "Il n'y a ni photo ni vidéo";

  @override
  String get retryLabel => 'Réessayer';

  @override
  String get userLastOnlineText => 'Dernière fois en ligne';

  @override
  String get userOnlineText => 'En ligne';

  @override
  String userTypingText(Iterable<User> users) {
    if (users.isEmpty) return '';
    final first = users.first;
    if (users.length == 1) {
      return "${first.name} est en train d'écrire";
    }
    return "${first.name} et ${users.length - 1} sont entrain d'écrire";
  }

  @override
  String get threadReplyLabel => 'Réponse au fil de discussion';

  @override
  String get onlyVisibleToYouText => 'Seulement visible par vous';

  @override
  String threadReplyCountText(int count) => '$count Réponses au fil de discussion';

  @override
  String attachmentsUploadProgressText({
    required int remaining,
    required int total,
  }) => 'Transfert en cours $remaining/$total ...';

  @override
  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  }) {
    final pinnedByCurrentUser = currentUser.id == pinnedBy.id;
    if (pinnedByCurrentUser) return 'Épinglé par vous';
    return 'Épinglé par ${pinnedBy.name}';
  }

  @override
  String get sendMessagePermissionError => "Vous n'êtes pas autorisé à envoyer des messages";

  @override
  String get emptyMessagesText => "Il n'y a pas de messages actuellement";

  @override
  String get genericErrorText => 'Il y a eu un problème';

  @override
  String get loadingMessagesError => 'Erreur de chargement des messages';

  @override
  String resultCountText(int count) => '$count résultats';

  @override
  String get messageDeletedText => 'Ce message a été supprimé.';

  @override
  String get messageDeletedLabel => 'Message supprimé';

  @override
  String get systemMessageLabel => 'Message système';

  @override
  String get editedMessageLabel => 'Modifié';

  @override
  String get messageReactionsLabel => 'Réactions aux messages';

  @override
  String get emptyChatMessagesText => 'Pas encore de chats ici...';

  @override
  String threadSeparatorText(int replyCount) {
    if (replyCount == 1) return '1 Réponse';
    return '$replyCount Replies';
  }

  @override
  String get connectedLabel => 'Connecté';

  @override
  String get disconnectedLabel => 'Déconnecté';

  @override
  String get reconnectingLabel => 'Reconnexion...';

  @override
  String get alsoSendAsDirectMessageLabel => 'Envoyer aussi comme message direct';

  @override
  String get addACommentOrSendLabel => 'Ajouter un commentaire ou envoyer';

  @override
  String get searchGifLabel => 'Recherche de GIFs';

  @override
  String get writeAMessageLabel => 'Écrire un message';

  @override
  String get instantCommandsLabel => 'Commandes instantanées';

  @override
  String fileTooLargeAfterCompressionError(double limitInMB) =>
      'Le fichier est trop volumineux pour être téléchargé. '
      'La taille maximale des fichiers est de $limitInMB Mo. '
      "Nous avons essayé de le compresser, mais ce n'était pas suffisant.";

  @override
  String fileTooLargeError(double limitInMB) =>
      'Le fichier est trop volumineux pour être téléchargé. '
      'La taille limite du fichier est de $limitInMB Mo.';

  @override
  String get couldNotReadBytesFromFileError => 'Impossible de lire les octets du fichier.';

  @override
  String get addAFileLabel => 'Ajouter un fichier';

  @override
  String get photoFromCameraLabel => "Photo de l'appareil photo";

  @override
  String get uploadAFileLabel => 'Transférer un fichier';

  @override
  String get uploadAPhotoLabel => 'Transférer une photo';

  @override
  String get uploadAVideoLabel => 'Transférer une vidéo';

  @override
  String get videoFromCameraLabel => 'Vidéo depuis la camera';

  @override
  String get okLabel => 'OK';

  @override
  String get somethingWentWrongError => 'Quelque chose a mal tourné';

  @override
  String get addMoreFilesLabel => "Ajouter d'autres fichiers";

  @override
  String get enablePhotoAndVideoAccessMessage =>
      "Veuillez autoriser l'accès à vos photos et vidéos afin de pouvoir les partager avec vos amis.";

  @override
  String get allowGalleryAccessMessage => "Autoriser l'accès à votre galerie";

  @override
  String get flagMessageLabel => 'Signaler un message';

  @override
  String get flagMessageQuestion =>
      'Voulez-vous envoyer une copie de ce message à un modérateur pour une enquête plus approfondie ?';

  @override
  String get flagLabel => 'SIGNALER';

  @override
  String get cancelLabel => 'ANNULER';

  @override
  String get flagMessageSuccessfulLabel => 'Message signalé';

  @override
  String get flagMessageSuccessfulText => 'Ce message a été signalé à un modérateur.';

  @override
  String get deleteLabel => 'SUPPRIMER';

  @override
  String get deleteMessageLabel => 'Supprimer le message';

  @override
  String get deleteMessageQuestion => 'Êtes-vous sûr de vouloir supprimer définitivement ce message ?';

  @override
  String get operationCouldNotBeCompletedText => "L'opération n'a pas pu être terminée.";

  @override
  String get replyLabel => 'Répondre';

  @override
  String togglePinUnpinText({required bool pinned}) {
    if (pinned) return 'Décrocher de la conversation';
    return 'Épingler à la conversation';
  }

  @override
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed}) {
    if (isDeleteFailed) return 'Retenter de supprimer le message';
    return 'Supprimer le message';
  }

  @override
  String get copyMessageLabel => 'Copier le message';

  @override
  String get editMessageLabel => 'Modifier le message';

  @override
  String toggleResendOrResendEditedMessage({required bool isUpdateFailed}) {
    if (isUpdateFailed) return 'Renvoyer le message modifié';
    return 'Renvoyer';
  }

  @override
  String get photosLabel => 'Photos';

  String _getDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return "aujourd'hui";
    } else if (date == yesterday) {
      return 'hier';
    } else {
      return 'le ${Jiffy.parseFromDateTime(date).MMMd}';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) {
    final atTime = Jiffy.parseFromDateTime(time.toLocal());
    return 'Envoyé ${_getDay(date)} à ${atTime.jm}';
  }

  @override
  String get todayLabel => "Aujourd'hui";

  @override
  String get yesterdayLabel => 'Hier';

  @override
  String get channelIsMutedText => 'Le canal est coupé';

  @override
  String get noTitleText => 'Aucun titre';

  @override
  String get letsStartChattingLabel => 'Commençons à discuter !';

  @override
  String get sendingFirstMessageLabel => "Que diriez-vous d'envoyer votre premier message à un ami ?";

  @override
  String get startAChatLabel => 'Commencer une discussion';

  @override
  String get loadingChannelsError => 'Erreur lors du chargement des canaux';

  @override
  String get deleteConversationLabel => 'Supprimer la conversation';

  @override
  String get deleteConversationQuestion => 'Vous êtes sûr de vouloir supprimer cette conversation ?';

  @override
  String get streamChatLabel => 'Stream Chat';

  @override
  String get searchingForNetworkText => 'Recherche de réseau';

  @override
  String get offlineLabel => 'Hors ligne...';

  @override
  String get tryAgainLabel => 'Essayer à nouveau';

  @override
  String membersCountText(int count) {
    if (count == 1) return '1 Membre';
    return '$count Membres';
  }

  @override
  String watchersCountText(int count) {
    if (count == 1) return '1 En ligne';
    return '$count En ligne';
  }

  @override
  String get viewInfoLabel => 'Voir les informations';

  @override
  String get leaveGroupLabel => 'Quitter le Groupe';

  @override
  String get leaveLabel => 'QUITTER';

  @override
  String get leaveConversationLabel => 'Quitter la conversation';

  @override
  String get leaveConversationQuestion => 'Etes-vous sûr de vouloir quitter cette conversation ?';

  @override
  String get showInChatLabel => 'Montrer dans la Discussion';

  @override
  String get saveImageLabel => "Sauvegarder l'image";

  @override
  String get saveVideoLabel => 'Sauvegarder la vidéo';

  @override
  String get uploadErrorLabel => 'ERREUR DE TRANSFERT';

  @override
  String get giphyLabel => 'Giphy';

  @override
  String get shuffleLabel => 'Mélanger';

  @override
  String get sendLabel => 'Envoyer';

  @override
  String get withText => 'avec';

  @override
  String get inText => 'dans';

  @override
  String get youText => 'Vous';

  @override
  String galleryPaginationText({
    required int currentPage,
    required int totalPages,
  }) => '${currentPage + 1} de $totalPages';

  @override
  String get fileText => 'Fichier';

  @override
  String get replyToMessageLabel => 'Répondre au Message';

  @override
  String attachmentLimitExceedError(int limit) =>
      '''
Limite de pièces jointes dépassée : il n'est pas possible d'ajouter plus de $limit pièces jointes
  ''';

  @override
  String get viewLibrary => 'Voir la bibliothèque';

  @override
  String get slowModeOnLabel => 'Mode lent activé';

  @override
  String get downloadLabel => 'Télécharger';

  @override
  String toggleMuteUnmuteUserText({required bool isMuted}) {
    if (isMuted) {
      return "Réactiver l'utilisateur";
    } else {
      return 'Utilisateur muet';
    }
  }

  @override
  String toggleMuteUnmuteGroupQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'Voulez-vous vraiment réactiver le son de ce groupe ?';
    } else {
      return '¿Estás seguro de que quieres silenciar a este grupo?';
    }
  }

  @override
  String toggleMuteUnmuteUserQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'Voulez-vous vraiment réactiver le son de cet utilisateur ?';
    } else {
      return 'Voulez-vous vraiment désactiver cet utilisateur ?';
    }
  }

  @override
  String toggleMuteUnmuteAction({required bool isMuted}) {
    if (isMuted) {
      return 'RÉACTIVER LE MUET';
    } else {
      return 'MUET';
    }
  }

  @override
  String toggleMuteUnmuteGroupText({required bool isMuted}) {
    if (isMuted) {
      return 'Activer le groupe';
    } else {
      return 'Groupe muet';
    }
  }

  @override
  String get linkDisabledDetails => "L'envoi de liens n'est pas autorisé dans cette conversation.";

  @override
  String get linkDisabledError => 'Les liens sont désactivés';

  @override
  String unreadMessagesSeparatorText() => 'Nouveaux messages';

  @override
  String get enableFileAccessMessage =>
      "Veuillez autoriser l'accès aux fichiers afin de pouvoir les partager avec des amis.";

  @override
  String get allowFileAccessMessage => "Autoriser l'accès aux fichiers";

  @override
  String get markAsUnreadLabel => 'Marquer comme non lu';

  @override
  String unreadCountIndicatorLabel({required int unreadCount}) {
    return '$unreadCount non lus';
  }

  @override
  String get markUnreadError =>
      'Erreur lors de la marque du message comme non lu. Impossible de marquer'
      ' des messages non lus plus anciens que les 100 derniers messages'
      ' du canal.';

  @override
  String createPollLabel({bool isNew = false}) {
    if (isNew) return 'Créer un sondage';
    return 'Créer sondage';
  }

  @override
  String get questionsLabel => 'Questions';

  @override
  String get askAQuestionLabel => 'Poser une question';

  @override
  String? pollQuestionValidationError(int length, Range<int> range) {
    final (:min, :max) = range;

    // Check if the question is too short.
    if (min != null && length < min) {
      return 'La question doit comporter au moins $min caractères';
    }

    // Check if the question is too long.
    if (max != null && length > max) {
      return 'La question doit comporter au plus $max caractères';
    }

    return null;
  }

  @override
  String optionLabel({bool isPlural = false}) {
    if (isPlural) return 'Options';
    return 'Option';
  }

  @override
  String get pollOptionEmptyError => 'L’option ne peut pas être vide';

  @override
  String get pollOptionDuplicateError => 'C’est déjà une option';

  @override
  String get addAnOptionLabel => 'Ajouter une option';

  @override
  String get multipleAnswersLabel => 'Réponses multiples';

  @override
  String get maximumVotesPerPersonLabel => 'Nombre maximum de votes par personne';

  @override
  String? maxVotesPerPersonValidationError(int votes, Range<int> range) {
    final (:min, :max) = range;

    if (min != null && votes < min) {
      return 'Le décompte des votes doit être d’au moins $min';
    }

    if (max != null && votes > max) {
      return 'Le décompte des votes doit être d’au plus $max';
    }

    return null;
  }

  @override
  String get anonymousPollLabel => 'Sondage anonyme';

  @override
  String get pollOptionsLabel => 'Options du sondage';

  @override
  String get suggestAnOptionLabel => 'Suggérer une option';

  @override
  String get enterANewOptionLabel => 'Saisir une nouvelle option';

  @override
  String get addACommentLabel => 'Ajouter un commentaire';

  @override
  String get pollCommentsLabel => 'Commentaires du sondage';

  @override
  String get updateYourCommentLabel => 'Mettre à jour votre commentaire';

  @override
  String get enterYourCommentLabel => 'Entrez votre commentaire';

  @override
  String get endVoteConfirmationText => 'Êtes-vous sûr de vouloir terminer le vote?';

  @override
  String get deletePollOptionLabel => "Supprimer l'option";

  @override
  String get deletePollOptionQuestion => 'Êtes-vous sûr de vouloir supprimer cette option ?';

  @override
  String get createLabel => 'Créer';

  @override
  String get endLabel => 'Terminer';

  @override
  String pollVotingModeLabel(PollVotingMode votingMode) {
    return votingMode.when(
      disabled: () => 'Vote terminé',
      unique: () => 'Sélectionner un',
      limited: (count) => "Sélectionner jusqu'à $count",
      all: () => 'Sélectionner un ou plusieurs',
    );
  }

  @override
  String seeAllOptionsLabel({int? count}) {
    if (count == null) return 'Voir toutes les options';
    return 'Voir toutes les $count options';
  }

  @override
  String get viewCommentsLabel => 'Voir les commentaires';

  @override
  String get viewResultsLabel => 'Voir les résultats';

  @override
  String get endVoteLabel => 'Terminer le vote';

  @override
  String get pollResultsLabel => 'Résultats du sondage';

  @override
  String showAllVotesLabel({int? count}) {
    if (count == null) return 'Afficher tous les votes';
    return 'Afficher tous les $count votes';
  }

  @override
  String voteCountLabel({int? count}) => switch (count) {
    null || < 1 => '0 vote',
    1 => '1 vote',
    _ => '$count votes',
  };

  @override
  String get noPollVotesLabel => "Il n'y a pas de votes de sondage actuellement";

  @override
  String get loadingPollVotesError => 'Erreur de chargement des votes du sondage';

  @override
  String get repliedToLabel => 'répondu à:';

  @override
  String newThreadsLabel({required int count}) {
    if (count == 1) return '1 Nouveau fil';
    return '$count Nouveaux fils';
  }

  @override
  String get slideToCancelLabel => 'Glissez pour annuler';

  @override
  String get holdToRecordLabel => 'Maintenez pour enregistrer, relâchez pour envoyer';

  @override
  String get sendAnywayLabel => 'Envoyer quand même';

  @override
  String get moderatedMessageBlockedText => 'Message bloqué par les politiques de modération';

  @override
  String get moderationReviewModalTitle => 'Êtes-vous sûr ?';

  @override
  String get moderationReviewModalDescription =>
      '''Réfléchissez à la façon dont votre commentaire pourrait affecter les autres et assurez-vous de respecter nos directives communautaires.''';

  @override
  String get emptyMessagePreviewText => '';

  @override
  String get voiceRecordingText => 'Enregistrement vocal';

  @override
  String get audioAttachmentText => 'Audio';

  @override
  String get imageAttachmentText => 'Image';

  @override
  String get videoAttachmentText => 'Vidéo';

  @override
  String get pollYouVotedText => 'Vous avez voté';

  @override
  String pollSomeoneVotedText(String username) => '$username a voté';

  @override
  String get pollYouCreatedText => 'Vous avez créé';

  @override
  String pollSomeoneCreatedText(String username) => '$username a créé';

  @override
  String get draftLabel => 'Brouillon';

  @override
  String locationLabel({bool isLive = false}) {
    if (isLive) return '📍 Position en direct';
    return '📍 Position';
  }
}
