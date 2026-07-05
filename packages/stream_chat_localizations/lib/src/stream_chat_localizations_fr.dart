// ignore_for_file: lines_longer_than_80_chars

part of 'stream_chat_localizations.dart';

/// The translations for French (`fr`).
class StreamChatLocalizationsFr extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for French.
  const StreamChatLocalizationsFr({super.localeName = 'fr'});

  @override
  AccessibilityTranslations get accessibility => const _AccessibilityTranslationsFr();

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
  String get threadLabel => 'Fil de discussion';

  @override
  String get onlyVisibleToYouText => 'Seulement visible par vous';

  @override
  String threadReplyCountText(int count) => '$count Réponses au fil de discussion';

  @override
  String attachmentsUploadProgressText({
    required int completed,
    required int total,
  }) => 'Téléversés $completed sur $total ...';

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
  String get emptyMessagesText => 'Aucun message pour le moment';

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
  String get writeAMessageLabel => 'Envoyer un message';

  @override
  String get instantCommandsLabel => 'Commandes instantanées';

  @override
  String get commandUnavailableWhileEditingError => 'Not available while editing';

  @override
  String get commandUnavailableWhileQuotingError => 'Not available while replying';

  @override
  String get commandUnavailableError => 'Command not available';

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
  String fileTypeNotSupportedError(String? extension) {
    if (extension != null) return "Les fichiers '.$extension' ne sont pas pris en charge pour le téléchargement.";
    return "Ce type de fichier n'est pas pris en charge pour le téléchargement.";
  }

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
  String get addMoreFilesLabel => 'Ajouter plus';

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
  String get flagLabel => 'Signaler';

  @override
  String get cancelLabel => 'Annuler';

  @override
  String get flagMessageSuccessfulLabel => 'Message signalé';

  @override
  String get flagMessageSuccessfulText => 'Ce message a été signalé à un modérateur.';

  @override
  String get deleteLabel => 'Supprimer';

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

  @override
  String get photosAndVideosLabel => 'Photos et vidéos';

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
  String get streamChatLabel => 'Conversations';

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
  String membersCountWithOnlineText({
    required int memberCount,
    required int onlineCount,
  }) {
    final members = membersCountText(memberCount);
    if (onlineCount <= 0) return members;
    return '$members, ${watchersCountText(onlineCount)}';
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
  String slowModeOnLabel(int cooldownTimeOut) => 'Mode lent, attendez ${cooldownTimeOut}s\u2026';

  @override
  String get commandUsernameLabel => '@username';

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
  String toggleBlockUnblockUserText({required bool isBlocked}) {
    if (isBlocked) return "Débloquer l'utilisateur";
    return "Bloquer l'utilisateur";
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
  String questionLabel({bool isPlural = false}) {
    if (isPlural) return 'Questions';
    return 'Question';
  }

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
  String get endVoteConfirmationTitle => 'Êtes-vous sûr de vouloir terminer le vote?';

  @override
  String get endVoteConfirmationMessage =>
      'Voulez-vous terminer ce sondage maintenant ? Plus personne ne pourra voter dans ce sondage.';

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
  String get pollVotesLabel => 'Votes';

  @override
  String showAllVotesLabel({int? count}) {
    if (count == null) return 'Afficher tous les votes';
    return 'Afficher tous les $count votes';
  }

  @override
  String get viewAllLabel => 'Voir tout';

  @override
  String voteCountLabel({int? count}) => switch (count) {
    null || < 1 => '0 vote',
    1 => '1 vote',
    _ => '$count votes',
  };

  @override
  String totalVoteCountLabel({int? count}) => switch (count) {
    null || < 1 => '0 vote au total',
    1 => '1 vote au total',
    _ => '$count votes au total',
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
  String get loadingLabel => 'Chargement...';

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
  String get fileAttachmentText => 'Fichier';

  @override
  String get linkAttachmentText => 'Lien';

  @override
  String filesAttachmentCountText(int count) => count == 1 ? 'Fichier' : '$count fichiers';

  @override
  String photosAttachmentCountText(int count) => count == 1 ? 'Photo' : '$count photos';

  @override
  String videosAttachmentCountText(int count) => count == 1 ? 'Vidéo' : '$count vidéos';

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
    if (isLive) return 'Position en direct';
    return 'Position';
  }

  @override
  String get noConversationsYetText => 'Pas encore de conversations';

  @override
  String get replyToStartThreadText => 'Répondez à un message pour démarrer un fil';

  @override
  String get sendMessageToStartConversationText => 'Envoyez un message pour démarrer la conversation';

  @override
  String get savedForLaterLabel => 'Enregistré pour plus tard';

  @override
  String get repliedToThreadAnnotationLabel => 'A répondu à un fil';

  @override
  String get alsoSentInChannelAnnotationLabel => 'Également envoyé dans le canal';

  @override
  String get viewLabel => 'Voir';

  @override
  String get reminderSetLabel => 'Rappel défini';

  @override
  String reminderAtText(String time) => "Aujourd'hui à $time";

  @override
  String get createPollPromptLabel => 'Créez un sondage et laissez tout le monde voter !';

  @override
  String get takePhotoAndShareLabel => 'Prendre une photo et partager';

  @override
  String get takeVideoAndShareLabel => 'Prendre une vidéo et partager';

  @override
  String get openCameraLabel => 'Ouvrir la caméra';

  @override
  String get selectFilesToShareLabel => 'Sélectionnez des fichiers à partager';

  @override
  String get openFilesLabel => 'Ouvrir des fichiers';

  @override
  String get unsupportedAttachmentLabel => 'Pièce jointe non prise en charge';

  @override
  String get confirmLabel => 'CONFIRMER';

  @override
  String get emptyReactionsText => 'Pas encore de réactions';

  @override
  String get loadingReactionsError => 'Erreur lors du chargement des réactions';

  @override
  String get tapToRemoveReactionLabel => 'Appuyer pour supprimer';

  @override
  String reactionsCountText(int count) => '$count Réactions';

  @override
  String get justNowLabel => "À l'instant";

  @override
  String replyToUserLabel(String userName) => 'Répondre à $userName';

  @override
  String get multipleAnswersDescription => "Sélectionner plus d'une option";

  @override
  String maximumVotesPerPersonDescription([Range<int>? range]) {
    final (:min, :max) = range ?? (min: 2, max: 10);
    return 'Choisir entre $min et $max options';
  }

  @override
  String get anonymousPollDescription => 'Masquer qui a voté';

  @override
  String get suggestAnOptionDescription => 'Laisser les autres ajouter des options';

  @override
  String get addACommentDescription => "Permettre aux autres d'ajouter des commentaires";

  @override
  String get notifyChannelText => 'Notifier tout le monde dans ce canal';

  @override
  String get notifyHereText => 'Notifier tous les membres en ligne de ce canal';

  @override
  String notifyRoleText(String role) => 'Notifier tous les membres $role';
}

class _AccessibilityTranslationsFr implements AccessibilityTranslations {
  const _AccessibilityTranslationsFr();

  @override
  String get localeName => 'fr';

  @override
  String get sendMessageTooltip => 'Envoyer le message';

  @override
  String get saveEditTooltip => 'Enregistrer la modification';

  @override
  String get sendCommandTooltip => 'Envoyer la commande';

  @override
  String slowModeTooltip({required int seconds}) {
    if (seconds == 1) return 'Mode lent : 1 seconde';
    return 'Mode lent : $seconds secondes';
  }

  @override
  String get recordVoiceRecordingLabel => 'Enregistrer un message vocal';

  @override
  String get cancelRecordingTooltip => "Annuler l'enregistrement";

  @override
  String get stopRecordingTooltip => "Arrêter l'enregistrement";

  @override
  String get sendRecordingTooltip => "Envoyer l'enregistrement";

  @override
  String recordingDurationLabel({required Duration duration}) => "Durée d'enregistrement, ${formatDuration(duration)}";

  @override
  String voiceRecordingPreviewPlayLabel({required Duration duration}) =>
      "Lire l'enregistrement vocal, ${formatDuration(duration)}";

  @override
  String voiceRecordingPreviewPauseLabel({required Duration duration}) =>
      "Mettre en pause l'enregistrement vocal, ${formatDuration(duration)}";

  @override
  String get attachmentPickerTooltip => 'Ouvrir le sélecteur de pièces jointes';

  @override
  String get attachmentPickerOpenedAnnouncement => 'Sélecteur de pièces jointes ouvert';

  @override
  String get attachmentPickerClosedAnnouncement => 'Sélecteur de pièces jointes fermé';

  @override
  String voiceRecordingAttachmentLabel({Duration? duration}) {
    if (duration == null) return 'Message vocal';
    return 'Message vocal, ${formatDuration(duration)}';
  }

  @override
  String videoAttachmentLabel({String? title}) {
    if (title == null || title.isEmpty) return 'Vidéo';
    return 'Vidéo, $title';
  }

  @override
  String get gifAttachmentLabel => 'GIF';

  @override
  String imageAttachmentLabel({String? title}) {
    if (title == null || title.isEmpty) return 'Photo';
    return 'Photo, $title';
  }

  @override
  String get voiceRecordingPlayTooltip => 'Lire';

  @override
  String get voiceRecordingPauseTooltip => 'Pause';

  @override
  String get voiceRecordingLoadingTooltip => 'Chargement';

  @override
  String get channelInfoLabel => 'Informations sur le canal';

  @override
  String get messageActionsLabel => 'Actions du message';

  @override
  String galleryImageLabel({DateTime? createdAt}) {
    if (createdAt == null) return 'Photo';
    return 'Photo, ${formatDateTime(createdAt)}';
  }

  @override
  String galleryVideoLabel({
    DateTime? createdAt,
    Duration? duration,
  }) {
    final parts = <String>[
      'Vidéo',
      if (duration != null) formatDuration(duration),
      if (createdAt != null) formatDateTime(createdAt),
    ];
    return parts.join(', ');
  }

  @override
  String get selectMediaTapHint => 'sélectionner';

  @override
  String get deselectMediaTapHint => 'désélectionner';

  @override
  String get savePollTooltip => 'Enregistrer le sondage';

  @override
  String removePollOptionTooltip({String? optionText}) {
    final trimmed = optionText?.trim();
    if (trimmed == null || trimmed.isEmpty) return "Supprimer l'option";
    return "Supprimer l'option $trimmed";
  }

  @override
  String get recordingStartedAnnouncement =>
      'Enregistrement commencé. Glissez vers la gauche pour annuler. Glissez vers le haut pour verrouiller.';

  @override
  String get recordingLockedAnnouncement => 'Enregistrement verrouillé';

  @override
  String get recordingStoppedAnnouncement => 'Enregistrement arrêté';

  @override
  String get recordingCancelledAnnouncement => 'Enregistrement annulé';

  @override
  String get recordingCompletedAnnouncement => 'Enregistrement terminé';

  @override
  String get imageAttachmentAddedAnnouncement => 'Photo ajoutée';

  @override
  String get imageAttachmentRemovedAnnouncement => 'Photo supprimée';

  @override
  String get videoAttachmentAddedAnnouncement => 'Vidéo ajoutée';

  @override
  String get videoAttachmentRemovedAnnouncement => 'Vidéo supprimée';

  @override
  String get gifAttachmentAddedAnnouncement => 'GIF ajouté';

  @override
  String get gifAttachmentRemovedAnnouncement => 'GIF supprimé';

  @override
  String get fileAttachmentAddedAnnouncement => 'Fichier ajouté';

  @override
  String get fileAttachmentRemovedAnnouncement => 'Fichier supprimé';

  @override
  String get voiceRecordingAttachmentAddedAnnouncement => 'Message vocal ajouté';

  @override
  String get voiceRecordingAttachmentRemovedAnnouncement => 'Message vocal supprimé';

  @override
  String get attachmentAddedAnnouncement => 'Pièce jointe ajoutée';

  @override
  String get attachmentRemovedAnnouncement => 'Pièce jointe supprimée';

  @override
  String attachmentsAddedAnnouncement({required int count}) {
    if (count == 1) return '1 pièce jointe ajoutée';
    return '$count pièces jointes ajoutées';
  }

  @override
  String attachmentsRemovedAnnouncement({required int count}) {
    if (count == 1) return '1 pièce jointe supprimée';
    return '$count pièces jointes supprimées';
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
      if (hours > 0) Intl.plural(hours, one: '$hours heure', other: '$hours heures', locale: 'fr'),
      if (minutes > 0) Intl.plural(minutes, one: '$minutes minute', other: '$minutes minutes', locale: 'fr'),
      if (seconds > 0 || (hours == 0 && minutes == 0))
        Intl.plural(seconds, one: '$seconds seconde', other: '$seconds secondes', locale: 'fr'),
    ];
    return parts.join(', ');
  }
}
