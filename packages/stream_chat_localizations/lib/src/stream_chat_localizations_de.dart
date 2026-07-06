// ignore_for_file: lines_longer_than_80_chars

part of 'stream_chat_localizations.dart';

/// The translations for German (`de`).
class StreamChatLocalizationsDe extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for German.
  const StreamChatLocalizationsDe({super.localeName = 'de'});

  @override
  AccessibilityTranslations get accessibility => _AccessibilityTranslationsDe(localeName: localeName);

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
  String get threadLabel => 'Thread';

  @override
  String get onlyVisibleToYouText => 'Nur für dich sichtbar';

  @override
  String threadReplyCountText(int count) => '$count Thread-Antworten';

  @override
  String attachmentsUploadProgressText({
    required int completed,
    required int total,
  }) => 'Hochgeladen $completed von $total ...';

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
  String get emptyMessagesText => 'Noch keine Nachrichten';

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
  String get systemMessageLabel => 'Systemnachricht';

  @override
  String get editedMessageLabel => 'Bearbeitet';

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
  String get writeAMessageLabel => 'Nachricht senden';

  @override
  String get instantCommandsLabel => 'Sofort-Befehle';

  @override
  String get commandUnavailableWhileEditingError => 'Not available while editing';

  @override
  String get commandUnavailableWhileQuotingError => 'Not available while replying';

  @override
  String get commandUnavailableError => 'Command not available';

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
  String fileTypeNotSupportedError(String? extension) {
    if (extension != null) return "'.$extension'-Dateien werden nicht zum Hochladen unterstützt.";
    return 'Dieser Dateityp wird nicht zum Hochladen unterstützt.';
  }

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
  String get addMoreFilesLabel => 'Mehr hinzufügen';

  @override
  String get enablePhotoAndVideoAccessMessage =>
      'Bitte aktivieren Sie den Zugriff auf Ihre Fotos und Videos, damit Sie sie mit Freunden teilen können.';

  @override
  String get allowGalleryAccessMessage => 'Zugang zu Ihrer Galerie gewähren';

  @override
  String get flagMessageLabel => 'Nachricht melden';

  @override
  String get flagMessageQuestion =>
      'Möchten Sie eine Kopie dieser Nachricht an einen Moderator für weitere Untersuchungen senden?';

  @override
  String get flagLabel => 'Melden';

  @override
  String get cancelLabel => 'Abbrechen';

  @override
  String get flagMessageSuccessfulLabel => 'Nachricht gemeldet';

  @override
  String get flagMessageSuccessfulText => 'Die Nachricht wurde an einen Moderator weitergeleitet.';

  @override
  String get deleteLabel => 'Löschen';

  @override
  String get deleteMessageLabel => 'Nachricht löschen';

  @override
  String get deleteMessageQuestion => 'Sind Sie sicher, dass Sie diese Nachricht endgültig löschen wollen?';

  @override
  String get operationCouldNotBeCompletedText => 'Die Operation konnte nicht abgeschlossen werden.';

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

  @override
  String get photosAndVideosLabel => 'Fotos & Videos';

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
      return 'am ${Jiffy.parseFromDateTime(date).MMMd}';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) {
    final atTime = Jiffy.parseFromDateTime(time.toLocal());
    return 'Gesendet ${_getDay(date)} am ${atTime.jm}';
  }

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
  String get sendingFirstMessageLabel =>
      'Wie wäre es, wenn Sie Ihre erste '
      'Nachricht an einen Freund senden würden?';

  @override
  String get startAChatLabel => 'Chat beginnen';

  @override
  String get loadingChannelsError => 'Fehler beim Laden der Kanäle';

  @override
  String get deleteConversationLabel => 'Unterhaltung löschen';

  @override
  String get deleteConversationQuestion => 'Sind Sie sicher, dass Sie diese Unterhaltung löschen wollen?';

  @override
  String get streamChatLabel => 'Unterhaltungen';

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
  String membersCountWithOnlineText({
    required int memberCount,
    required int onlineCount,
  }) {
    final members = membersCountText(memberCount);
    if (onlineCount <= 0) return members;
    return '$members, ${watchersCountText(onlineCount)}';
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
  String get leaveConversationQuestion => 'Sind Sie sicher, dass Sie diese Unterhaltung verlassen wollen?';

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
  }) => '${currentPage + 1} von $totalPages';

  @override
  String get fileText => 'Datei';

  @override
  String get replyToMessageLabel => 'Auf Nachricht antworten';

  @override
  String attachmentLimitExceedError(int limit) => 'Dateigröße überschritten, Grenze: $limit';

  @override
  String slowModeOnLabel(int cooldownTimeOut) => 'Langsamer Modus, warte ${cooldownTimeOut}s\u2026';

  @override
  String get commandUsernameLabel => '@username';

  @override
  String get linkDisabledDetails => 'Das Senden von Links ist in dieser Konversation nicht erlaubt.';

  @override
  String get linkDisabledError => 'Verknüpfungen sind deaktiviert';

  @override
  String get sendMessagePermissionError => 'Sie sind nicht berechtigt Nachrichten zu senden';

  @override
  String get couldNotReadBytesFromFileError => 'Kan bytes niet uit bestand lezen.';

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
  String toggleBlockUnblockUserText({required bool isBlocked}) {
    if (isBlocked) return 'Blockierung aufheben';
    return 'Benutzer blockieren';
  }

  @override
  String get viewLibrary => 'Bibliothek öffnen';

  @override
  String unreadMessagesSeparatorText() => 'Neue Nachrichten';

  @override
  String get enableFileAccessMessage =>
      'Bitte aktivieren Sie den Zugriff auf Dateien, damit Sie sie mit Freunden teilen können.';

  @override
  String get allowFileAccessMessage => 'Zugriff auf Dateien zulassen';

  @override
  String get markAsUnreadLabel => 'Als ungelesen markieren';

  @override
  String unreadCountIndicatorLabel({required int unreadCount}) {
    return '$unreadCount ungelesen';
  }

  @override
  String get markUnreadError =>
      'Fehler beim Markieren der Nachricht als ungelesen. Kann keine älteren'
      ' ungelesenen Nachrichten markieren als die neuesten 100'
      ' Kanalnachrichten.';

  @override
  String createPollLabel({bool isNew = false}) {
    if (isNew) return 'Erstellen einer neuen Umfrage';
    return 'Umfrage erstellen';
  }

  @override
  String questionLabel({bool isPlural = false}) {
    if (isPlural) return 'Fragen';
    return 'Frage';
  }

  @override
  String get askAQuestionLabel => 'Stellen Sie eine Frage';

  @override
  String? pollQuestionValidationError(int length, Range<int> range) {
    final (:min, :max) = range;

    // Check if the question is too short.
    if (min != null && length < min) {
      return 'Die Frage muss mindestens $min Zeichen lang sein';
    }

    // Check if the question is too long.
    if (max != null && length > max) {
      return 'Die Frage darf höchstens $max Zeichen lang sein';
    }

    return null;
  }

  @override
  String optionLabel({bool isPlural = false}) {
    if (isPlural) return 'Optionen';
    return 'Option';
  }

  @override
  String get pollOptionEmptyError => 'Option darf nicht leer sein';

  @override
  String get pollOptionDuplicateError => 'Dies ist bereits eine Option';

  @override
  String get addAnOptionLabel => 'Option hinzufügen';

  @override
  String get multipleAnswersLabel => 'Mehrere Antworten';

  @override
  String get maximumVotesPerPersonLabel => 'Maximale Stimmen pro Person';

  @override
  String? maxVotesPerPersonValidationError(int votes, Range<int> range) {
    final (:min, :max) = range;

    if (min != null && votes < min) {
      return 'Die Stimmenauszählung muss mindestens $min betragen';
    }

    if (max != null && votes > max) {
      return 'Die Stimmenauszählung darf höchstens $max betragen';
    }

    return null;
  }

  @override
  String get anonymousPollLabel => 'Anonyme Umfrage';

  @override
  String get pollOptionsLabel => 'Umfrage-Optionen';

  @override
  String get suggestAnOptionLabel => 'Option vorschlagen';

  @override
  String get enterANewOptionLabel => 'Neue Option eingeben';

  @override
  String get addACommentLabel => 'Kommentar hinzufügen';

  @override
  String get pollCommentsLabel => 'Umfrage-Kommentare';

  @override
  String get updateYourCommentLabel => 'Kommentar aktualisieren';

  @override
  String get enterYourCommentLabel => 'Geben Sie Ihren Kommentar ein';

  @override
  String get endVoteConfirmationTitle => 'Sind Sie sicher, dass Sie die Abstimmung beenden möchten?';

  @override
  String get endVoteConfirmationMessage =>
      'Möchten Sie diese Umfrage jetzt beenden? Danach kann niemand mehr in dieser Umfrage abstimmen.';

  @override
  String get deletePollOptionLabel => 'Option löschen';

  @override
  String get deletePollOptionQuestion => 'Sind Sie sicher, dass Sie diese Option löschen möchten?';

  @override
  String get createLabel => 'Erstellen';

  @override
  String get endLabel => 'Beenden';

  @override
  String pollVotingModeLabel(PollVotingMode votingMode) {
    return votingMode.when(
      disabled: () => 'Abstimmung beendet',
      unique: () => 'Eine auswählen',
      limited: (count) => 'Bis zu $count auswählen',
      all: () => 'Eine oder mehrere auswählen',
    );
  }

  @override
  String seeAllOptionsLabel({int? count}) {
    if (count == null) return 'Alle Optionen anzeigen';
    return 'Alle $count Optionen anzeigen';
  }

  @override
  String get viewCommentsLabel => 'Kommentare anzeigen';

  @override
  String get viewResultsLabel => 'Ergebnisse anzeigen';

  @override
  String get endVoteLabel => 'Abstimmung beenden';

  @override
  String get pollResultsLabel => 'Umfrage-Ergebnisse';

  @override
  String get pollVotesLabel => 'Stimmen';

  @override
  String showAllVotesLabel({int? count}) {
    if (count == null) return 'Alle Stimmen anzeigen';
    return 'Alle $count Stimmen anzeigen';
  }

  @override
  String get viewAllLabel => 'Alle anzeigen';

  @override
  String voteCountLabel({int? count}) => switch (count) {
    null || < 1 => '0 Stimmen',
    1 => '1 Stimme',
    _ => '$count Stimmen',
  };

  @override
  String totalVoteCountLabel({int? count}) => switch (count) {
    null || < 1 => '0 Stimmen insgesamt',
    1 => '1 Stimme insgesamt',
    _ => '$count Stimmen insgesamt',
  };

  @override
  String get noPollVotesLabel => 'Derzeit keine Umfrage-Stimmen';

  @override
  String get loadingPollVotesError => 'Fehler beim Laden der Umfrage-Stimmen';

  @override
  String get repliedToLabel => 'antwortete:';

  @override
  String newThreadsLabel({required int count}) {
    if (count == 1) return '1 neuer Thread';
    return '$count neue Threads';
  }

  @override
  String get loadingLabel => 'Wird geladen...';

  @override
  String get slideToCancelLabel => 'Zum Abbrechen schieben';

  @override
  String get holdToRecordLabel => 'Zum Aufnehmen halten, zum Senden loslassen';

  @override
  String get sendAnywayLabel => 'Trotzdem senden';

  @override
  String get moderatedMessageBlockedText => 'Nachricht wurde durch Moderationsrichtlinien blockiert';

  @override
  String get moderationReviewModalTitle => 'Bist du sicher?';

  @override
  String get moderationReviewModalDescription =>
      '''Bedenke, wie dein Kommentar andere beeinflussen könnte, und achte darauf, unsere Community-Richtlinien einzuhalten.''';

  @override
  String get emptyMessagePreviewText => '';

  @override
  String get voiceRecordingText => 'Sprachaufnahme';

  @override
  String get audioAttachmentText => 'Audio';

  @override
  String get imageAttachmentText => 'Bild';

  @override
  String get videoAttachmentText => 'Video';

  @override
  String get fileAttachmentText => 'Datei';

  @override
  String get linkAttachmentText => 'Link';

  @override
  String filesAttachmentCountText(int count) => count == 1 ? 'Datei' : '$count Dateien';

  @override
  String photosAttachmentCountText(int count) => count == 1 ? 'Foto' : '$count Fotos';

  @override
  String videosAttachmentCountText(int count) => count == 1 ? 'Video' : '$count Videos';

  @override
  String get pollYouVotedText => 'Du hast abgestimmt';

  @override
  String pollSomeoneVotedText(String username) => '$username hat abgestimmt';

  @override
  String get pollYouCreatedText => 'Du hast erstellt';

  @override
  String pollSomeoneCreatedText(String username) => '$username hat erstellt';

  @override
  String get draftLabel => 'Entwurf';

  @override
  String locationLabel({bool isLive = false}) {
    if (isLive) return 'Live-Standort';
    return 'Standort';
  }

  @override
  String get noConversationsYetText => 'Noch keine Unterhaltungen';

  @override
  String get replyToStartThreadText => 'Antworten Sie auf eine Nachricht, um einen Thread zu starten';

  @override
  String get sendMessageToStartConversationText => 'Senden Sie eine Nachricht, um die Unterhaltung zu starten';

  @override
  String get savedForLaterLabel => 'Für später gespeichert';

  @override
  String get repliedToThreadAnnotationLabel => 'Auf einen Thread geantwortet';

  @override
  String get alsoSentInChannelAnnotationLabel => 'Auch im Kanal gesendet';

  @override
  String get viewLabel => 'Anzeigen';

  @override
  String get reminderSetLabel => 'Erinnerung gesetzt';

  @override
  String reminderAtText(String time) => 'Heute um $time';

  @override
  String get createPollPromptLabel => 'Erstelle eine Umfrage und lass alle abstimmen!';

  @override
  String get takePhotoAndShareLabel => 'Foto aufnehmen und teilen';

  @override
  String get takeVideoAndShareLabel => 'Video aufnehmen und teilen';

  @override
  String get openCameraLabel => 'Kamera öffnen';

  @override
  String get selectFilesToShareLabel => 'Dateien zum Teilen auswählen';

  @override
  String get openFilesLabel => 'Dateien öffnen';

  @override
  String get unsupportedAttachmentLabel => 'Nicht unterstützter Anhang';

  @override
  String get confirmLabel => 'BESTÄTIGEN';

  @override
  String get emptyReactionsText => 'Noch keine Reaktionen';

  @override
  String get loadingReactionsError => 'Fehler beim Laden der Reaktionen';

  @override
  String get tapToRemoveReactionLabel => 'Zum Entfernen tippen';

  @override
  String reactionsCountText(int count) => '$count Reaktionen';

  @override
  String get justNowLabel => 'Gerade eben';

  @override
  String replyToUserLabel(String userName) => 'Antwort an $userName';

  @override
  String get multipleAnswersDescription => 'Mehr als eine Option auswählen';

  @override
  String maximumVotesPerPersonDescription([Range<int>? range]) {
    final (:min, :max) = range ?? (min: 2, max: 10);
    return 'Wähle zwischen $min\u2013$max Optionen';
  }

  @override
  String get anonymousPollDescription => 'Verbergen, wer abgestimmt hat';

  @override
  String get suggestAnOptionDescription => 'Anderen erlauben, Optionen hinzuzufügen';

  @override
  String get addACommentDescription => 'Anderen erlauben, Kommentare hinzuzufügen';

  @override
  String get notifyChannelText => 'Benachrichtige alle in diesem Kanal';

  @override
  String get notifyHereText => 'Benachrichtige alle Online-Mitglieder in diesem Kanal';

  @override
  String notifyRoleText(String role) => 'Benachrichtige alle $role-Mitglieder';
}

class _AccessibilityTranslationsDe extends AccessibilityTranslations {
  const _AccessibilityTranslationsDe({super.localeName = 'de'});

  @override
  String get sendMessageTooltip => 'Nachricht senden';

  @override
  String get saveEditTooltip => 'Bearbeitung speichern';

  @override
  String get sendCommandTooltip => 'Befehl senden';

  @override
  String slowModeTooltip({required int seconds}) {
    if (seconds == 1) return 'Langsamer Modus: 1 Sekunde';
    return 'Langsamer Modus: $seconds Sekunden';
  }

  @override
  String get recordVoiceRecordingLabel => 'Sprachnachricht aufnehmen';

  @override
  String get cancelRecordingTooltip => 'Aufnahme abbrechen';

  @override
  String get stopRecordingTooltip => 'Aufnahme stoppen';

  @override
  String get sendRecordingTooltip => 'Aufnahme senden';

  @override
  String recordingDurationLabel({required Duration duration}) => 'Aufnahmedauer, ${formatDuration(duration)}';

  @override
  String voiceRecordingPreviewPlayLabel({required Duration duration}) =>
      'Sprachaufnahme abspielen, ${formatDuration(duration)}';

  @override
  String voiceRecordingPreviewPauseLabel({required Duration duration}) =>
      'Sprachaufnahme pausieren, ${formatDuration(duration)}';

  @override
  String get attachmentPickerTooltip => 'Anhang-Auswahl öffnen';

  @override
  String get attachmentPickerOpenedAnnouncement => 'Anhang-Auswahl geöffnet';

  @override
  String get attachmentPickerClosedAnnouncement => 'Anhang-Auswahl geschlossen';

  @override
  String voiceRecordingAttachmentLabel({Duration? duration}) {
    if (duration == null) return 'Sprachnachricht';
    return 'Sprachnachricht, ${formatDuration(duration)}';
  }

  @override
  String videoAttachmentLabel({String? title}) {
    if (title == null || title.isEmpty) return 'Video';
    return 'Video, $title';
  }

  @override
  String get gifAttachmentLabel => 'GIF';

  @override
  String imageAttachmentLabel({String? title}) {
    if (title == null || title.isEmpty) return 'Foto';
    return 'Foto, $title';
  }

  @override
  String get voiceRecordingPlayTooltip => 'Abspielen';

  @override
  String get voiceRecordingPauseTooltip => 'Pause';

  @override
  String get voiceRecordingLoadingTooltip => 'Wird geladen';

  @override
  String get channelInfoLabel => 'Kanalinformationen';

  @override
  String get messageActionsLabel => 'Nachrichtenaktionen';

  @override
  String galleryImageLabel({DateTime? createdAt}) {
    if (createdAt == null) return 'Foto';
    return 'Foto, ${formatDateTime(createdAt)}';
  }

  @override
  String galleryVideoLabel({
    DateTime? createdAt,
    Duration? duration,
  }) {
    final parts = <String>[
      'Video',
      if (duration != null) formatDuration(duration),
      if (createdAt != null) formatDateTime(createdAt),
    ];
    return parts.join(', ');
  }

  @override
  String get selectMediaTapHint => 'auswählen';

  @override
  String get deselectMediaTapHint => 'abwählen';

  @override
  String get savePollTooltip => 'Umfrage speichern';

  @override
  String removePollOptionTooltip({String? optionText}) {
    final trimmed = optionText?.trim();
    if (trimmed == null || trimmed.isEmpty) return 'Option entfernen';
    return 'Option entfernen $trimmed';
  }

  @override
  String get recordingStartedAnnouncement =>
      'Aufnahme gestartet. Nach links wischen zum Abbrechen. Nach oben wischen zum Sperren.';

  @override
  String get recordingLockedAnnouncement => 'Aufnahme gesperrt';

  @override
  String get recordingStoppedAnnouncement => 'Aufnahme gestoppt';

  @override
  String get recordingCancelledAnnouncement => 'Aufnahme abgebrochen';

  @override
  String get recordingCompletedAnnouncement => 'Aufnahme abgeschlossen';

  @override
  String get imageAttachmentAddedAnnouncement => 'Foto hinzugefügt';

  @override
  String get imageAttachmentRemovedAnnouncement => 'Foto entfernt';

  @override
  String get videoAttachmentAddedAnnouncement => 'Video hinzugefügt';

  @override
  String get videoAttachmentRemovedAnnouncement => 'Video entfernt';

  @override
  String get gifAttachmentAddedAnnouncement => 'GIF hinzugefügt';

  @override
  String get gifAttachmentRemovedAnnouncement => 'GIF entfernt';

  @override
  String get fileAttachmentAddedAnnouncement => 'Datei hinzugefügt';

  @override
  String get fileAttachmentRemovedAnnouncement => 'Datei entfernt';

  @override
  String get voiceRecordingAttachmentAddedAnnouncement => 'Sprachnachricht hinzugefügt';

  @override
  String get voiceRecordingAttachmentRemovedAnnouncement => 'Sprachnachricht entfernt';

  @override
  String get attachmentAddedAnnouncement => 'Anhang hinzugefügt';

  @override
  String get attachmentRemovedAnnouncement => 'Anhang entfernt';

  @override
  String attachmentsAddedAnnouncement({required int count}) {
    if (count == 1) return '1 Anhang hinzugefügt';
    return '$count Anhänge hinzugefügt';
  }

  @override
  String attachmentsRemovedAnnouncement({required int count}) {
    if (count == 1) return '1 Anhang entfernt';
    return '$count Anhänge entfernt';
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
      if (hours > 0) Intl.plural(hours, one: '$hours Stunde', other: '$hours Stunden', locale: 'de'),
      if (minutes > 0) Intl.plural(minutes, one: '$minutes Minute', other: '$minutes Minuten', locale: 'de'),
      if (seconds > 0 || (hours == 0 && minutes == 0))
        Intl.plural(seconds, one: '$seconds Sekunde', other: '$seconds Sekunden', locale: 'de'),
    ];
    return parts.join(', ');
  }
}
