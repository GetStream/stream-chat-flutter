part of 'stream_chat_localizations.dart';

/// The translations for German (`de`).
class StreamChatLocalizationsDe extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for German.
  const StreamChatLocalizationsDe({super.localeName = 'de'});

  @override
  String get launchUrlError => 'Die Url kann nicht geöffnet werden';

  @override
  String get loadingUsersError => 'Fehler beim Laden von Usern';

  @override
  String get noUsersLabel => 'Derzeit gibt es keine User';

  @override
  String get noPhotoOrVideoLabel => 'Es gibt kein Foto oder Video';

  @override
  String get retryLabel => 'Erneut versuchen';

  @override
  String get userLastOnlineText => 'Zuletzt online';

  @override
  String get userOnlineText => 'Online';

  @override
  String userTypingText(Iterable<User> users) {
    if (users.isEmpty) return '';
    final first = users.first;
    if (users.length == 1) {
      return '${first.name} tippt';
    }
    return '${first.name} und ${users.length - 1} weitere tippen';
  }

  @override
  String get threadReplyLabel => 'Thread-Antwort';

  @override
  String get onlyVisibleToYouText => 'Nur für dich sichtbar';

  @override
  String threadReplyCountText(int count) => '$count Thread-Antworten';

  @override
  String attachmentsUploadProgressText({
    required int remaining,
    required int total,
  }) =>
      'Hochladen $remaining/$total ...';

  @override
  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  }) {
    final pinnedByCurrentUser = currentUser.id == pinnedBy.id;
    if (pinnedByCurrentUser) return 'Angeheftet von Dir';
    return 'Angeheftet von ${pinnedBy.name}';
  }

  @override
  String get emptyMessagesText => 'Derzeit sind keine Nachrichten vorhanden';

  @override
  String get genericErrorText => 'Etwas ist schief gelaufen';

  @override
  String get loadingMessagesError => 'Fehler beim Laden der Nachrichten';

  @override
  String resultCountText(int count) => '$count Ergebnisse';

  @override
  String get messageDeletedText => 'Diese Nachricht ist gelöscht.';

  @override
  String get messageDeletedLabel => 'Nachricht gelöscht';

  @override
  String get messageReactionsLabel => 'Nachricht-Reaktionen';

  @override
  String get emptyChatMessagesText => 'Noch keine Nachrichten hier...';

  @override
  String threadSeparatorText(int replyCount) {
    if (replyCount == 1) return '1 Antwort';
    return '$replyCount Antworten';
  }

  @override
  String get connectedLabel => 'Verbunden';

  @override
  String get disconnectedLabel => 'Getrennt';

  @override
  String get reconnectingLabel => 'Verbindung wird wiederhergestellt...';

  @override
  String get alsoSendAsDirectMessageLabel => 'Auch als Direktnachricht senden';

  @override
  String get addACommentOrSendLabel => 'Kommentar hinzufügen oder senden';

  @override
  String get searchGifLabel => 'GIFs suchen';

  @override
  String get writeAMessageLabel => 'Nachricht schreiben';

  @override
  String get instantCommandsLabel => 'Sofort-Befehle';

  @override
  String fileTooLargeAfterCompressionError(double limitInMB) =>
      'Die Datei ist zu groß zum Hochladen. '
      'Die maximale Dateigröße beträgt $limitInMB MB. '
      'Wir haben versucht, sie zu komprimieren, aber das war nicht genug.';

  @override
  String fileTooLargeError(double limitInMB) =>
      'Die Datei ist zu groß zum Hochladen. '
      'Die Dateigröße ist begrenzt auf $limitInMB MB.';

  @override
  String get addAFileLabel => 'Datei hinzufügen';

  @override
  String get photoFromCameraLabel => 'Foto von der Kamera';

  @override
  String get uploadAFileLabel => 'Datei hochladen';

  @override
  String get uploadAPhotoLabel => 'Foto hochladen';

  @override
  String get uploadAVideoLabel => 'Video hochladen';

  @override
  String get videoFromCameraLabel => 'Video von der Kamera';

  @override
  String get okLabel => 'OK';

  @override
  String get somethingWentWrongError => 'Etwas ist schief gelaufen';

  @override
  String get addMoreFilesLabel => 'Weitere Dateien hinzufügen';

  @override
  String get enablePhotoAndVideoAccessMessage =>
      'Bitte aktivieren Sie den Zugriff auf Ihre Fotos'
      '\nund Videos, damit Sie sie mit Freunden teilen können.';

  @override
  String get allowGalleryAccessMessage => 'Zugang zu Ihrer Galerie gewähren';

  @override
  String get flagMessageLabel => 'Nachricht melden';

  @override
  String get flagMessageQuestion =>
      'Möchten Sie eine Kopie dieser Nachricht an einen'
      '\nModerator für weitere Untersuchungen senden?';

  @override
  String get flagLabel => 'MELDEN';

  @override
  String get cancelLabel => 'ABBRECHEN';

  @override
  String get flagMessageSuccessfulLabel => 'Nachricht gemeldet';

  @override
  String get flagMessageSuccessfulText =>
      'Die Nachricht wurde an einen Moderator weitergeleitet.';

  @override
  String get deleteLabel => 'LÖSCHEN';

  @override
  String get deleteMessageLabel => 'Nachricht löschen';

  @override
  String get deleteMessageQuestion =>
      'Sind Sie sicher, dass Sie diese Nachricht endgültig löschen wollen?';

  @override
  String get operationCouldNotBeCompletedText =>
      'Die Operation konnte nicht abgeschlossen werden.';

  @override
  String get replyLabel => 'Antwort';

  @override
  String togglePinUnpinText({required bool pinned}) {
    if (pinned) return 'Aus der Unterhaltung lösen';
    return 'Anheften an die Unterhaltung';
  }

  @override
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed}) {
    if (isDeleteFailed) return 'Löschen der Nachricht wiederholen';
    return 'Nachricht löschen';
  }

  @override
  String get copyMessageLabel => 'Nachricht kopieren';

  @override
  String get editMessageLabel => 'Nachricht bearbeiten';

  @override
  String toggleResendOrResendEditedMessage({required bool isUpdateFailed}) {
    if (isUpdateFailed) return 'Bearbeitete Nachricht erneut senden';
    return 'Erneut senden';
  }

  @override
  String get photosLabel => 'Fotos';

  String _getDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'Heute';
    } else if (date == yesterday) {
      return 'Gestern';
    } else {
      return 'am ${Jiffy(date).MMMd}';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) =>
      'Gesendet ${_getDay(date)} am ${Jiffy(time.toLocal()).format('HH:mm')}';

  @override
  String get todayLabel => 'Heute';

  @override
  String get yesterdayLabel => 'Gestern';

  @override
  String get channelIsMutedText => 'Kanal ist stummgeschaltet';

  @override
  String get noTitleText => 'Kein Titel';

  @override
  String get letsStartChattingLabel => 'Lass uns anfangen zu chatten!';

  @override
  String get sendingFirstMessageLabel => 'Wie wäre es, wenn Sie Ihre erste '
      'Nachricht an einen Freund senden würden?';

  @override
  String get startAChatLabel => 'Chat beginnen';

  @override
  String get loadingChannelsError => 'Fehler beim Laden der Kanäle';

  @override
  String get deleteConversationLabel => 'Unterhaltung löschen';

  @override
  String get deleteConversationQuestion =>
      'Sind Sie sicher, dass Sie diese Unterhaltung löschen wollen?';

  @override
  String get streamChatLabel => 'Stream Chat';

  @override
  String get searchingForNetworkText => 'Netzwerk wird gesucht';

  @override
  String get offlineLabel => 'Offline...';

  @override
  String get tryAgainLabel => 'Erneut versuchen';

  @override
  String membersCountText(int count) {
    if (count == 1) return '1 Mitglied';
    return '$count Mitglieder';
  }

  @override
  String watchersCountText(int count) {
    return '$count Online';
  }

  @override
  String get viewInfoLabel => 'Infos anzeigen';

  @override
  String get leaveGroupLabel => 'Gruppe verlassen';

  @override
  String get leaveLabel => 'VERLASSEN';

  @override
  String get leaveConversationLabel => 'Unterhaltung verlassen';

  @override
  String get leaveConversationQuestion =>
      'Sind Sie sicher, dass Sie diese Unterhaltung verlassen wollen?';

  @override
  String get showInChatLabel => 'Im Chat anzeigen';

  @override
  String get saveImageLabel => 'Bild speichern';

  @override
  String get saveVideoLabel => 'Video speichern';

  @override
  String get uploadErrorLabel => 'UPLOAD-FEHLER';

  @override
  String get giphyLabel => 'Giphy';

  @override
  String get shuffleLabel => 'Mischen';

  @override
  String get sendLabel => 'Senden';

  @override
  String get withText => 'mit';

  @override
  String get inText => 'in';

  @override
  String get youText => 'Du';

  @override
  String galleryPaginationText({
    required int currentPage,
    required int totalPages,
  }) =>
      '${currentPage + 1} von $totalPages';

  @override
  String get fileText => 'Datei';

  @override
  String get replyToMessageLabel => 'Auf Nachricht antworten';

  @override
  String attachmentLimitExceedError(int limit) =>
      'Dateigröße überschritten, Grenze: $limit';

  @override
  String get slowModeOnLabel => 'Langsamer Modus: EIN';

  @override
  String get linkDisabledDetails =>
      'Das Senden von Links ist in dieser Konversation nicht erlaubt.';

  @override
  String get linkDisabledError => 'Verknüpfungen sind deaktiviert';

  @override
  String get sendMessagePermissionError =>
      'Sie sind nicht berechtigt Nachrichten zu senden';

  @override
  String get couldNotReadBytesFromFileError =>
      'Kan bytes niet uit bestand lezen.';

  @override
  String get downloadLabel => 'Downloaden';

  @override
  String toggleMuteUnmuteAction({required bool isMuted}) {
    if (isMuted) {
      return 'UNMUTE';
    } else {
      return 'STOM';
    }
  }

  @override
  String toggleMuteUnmuteGroupQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'Weet je zeker dat je het dempen van deze groep wilt opheffen?';
    } else {
      return 'Weet je zeker dat je deze groep wilt dempen?';
    }
  }

  @override
  String toggleMuteUnmuteGroupText({required bool isMuted}) {
    if (isMuted) {
      return 'Dempen groep opheffen';
    } else {
      return 'Groep dempen';
    }
  }

  @override
  String toggleMuteUnmuteUserQuestion({required bool isMuted}) {
    if (isMuted) {
      return '''Weet je zeker dat je het dempen van deze gebruiker wilt opheffen?''';
    } else {
      return 'Weet u zeker dat u deze gebruiker wilt dempen?';
    }
  }

  @override
  String toggleMuteUnmuteUserText({required bool isMuted}) {
    return 'Gebruiker dempen';
  }

  @override
  String get viewLibrary => 'Bibliothek öffnen';

  @override
  String unreadMessagesSeparatorText(int unreadCount) => 'Neue Nachrichten';

  @override
  String get enableFileAccessMessage =>
      'Bitte aktivieren Sie den Zugriff auf Dateien,'
      '\ndamit Sie sie mit Freunden teilen können.';

  @override
  String get allowFileAccessMessage => 'Zugriff auf Dateien zulassen';
}
