// ignore_for_file: lines_longer_than_80_chars

part of 'stream_chat_localizations.dart';

/// The translations for Norwegian (`no`).
class StreamChatLocalizationsNo extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for Norwegian.
  const StreamChatLocalizationsNo({super.localeName = 'no'});

  @override
  String get launchUrlError => 'Kan ikke laste inn url';

  @override
  String get loadingUsersError => 'Problem med å laste inn brukere';

  @override
  String get noUsersLabel => 'Det er ingen brukere akkurat nå';

  @override
  String get noPhotoOrVideoLabel => 'Det er ingen bilde eller video';

  @override
  String get retryLabel => 'Prøv igjen';

  @override
  String get userLastOnlineText => 'Sist pålogget';

  @override
  String get userOnlineText => 'Pålogget';

  @override
  String userTypingText(Iterable<User> users) {
    if (users.isEmpty) return '';
    final first = users.first;
    if (users.length == 1) {
      return '${first.name} skriver';
    }
    return '${first.name} og ${users.length - 1} flere skriver';
  }

  @override
  String get threadReplyLabel => 'Svar på tråd';

  @override
  String get threadLabel => 'Tråd';

  @override
  String get onlyVisibleToYouText => 'Kun synlig for deg';

  @override
  String threadReplyCountText(int count) => '$count svar på tråd';

  @override
  String attachmentsUploadProgressText({
    required int completed,
    required int total,
  }) => 'Lastet opp $completed av $total ...';

  @override
  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  }) {
    final pinnedByCurrentUser = currentUser.id == pinnedBy.id;
    if (pinnedByCurrentUser) return 'Festet av deg';
    return 'Festet av ${pinnedBy.name}';
  }

  @override
  String get sendMessagePermissionError => 'Du har ikke tillatelse til å sende meldinger';

  @override
  String get emptyMessagesText => 'Ingen meldinger ennå';

  @override
  String get genericErrorText => 'Noe gikk galt';

  @override
  String get loadingMessagesError => 'Problem med å laste inn meldinger';

  @override
  String resultCountText(int count) => '$count resultater';

  @override
  String get messageDeletedText => 'Denne meldingen er slettet.';

  @override
  String get messageDeletedLabel => 'Melding slettet';

  @override
  String get systemMessageLabel => 'Systemmelding';

  @override
  String get editedMessageLabel => 'Redigert';

  @override
  String get messageReactionsLabel => 'Reaksjoner på melding';

  @override
  String get emptyChatMessagesText => 'Ingen meldinger her enda...';

  @override
  String threadSeparatorText(int replyCount) {
    if (replyCount == 1) return '1 svar';
    return '$replyCount svar';
  }

  @override
  String get connectedLabel => 'Tilkoblet';

  @override
  String get disconnectedLabel => 'Avbrutt';

  @override
  String get reconnectingLabel => 'Prøver å koble til...';

  @override
  String get alsoSendAsDirectMessageLabel => 'Også send som en direktemelding';

  @override
  String get addACommentOrSendLabel => 'Legg til en kommentar eller send';

  @override
  String get searchGifLabel => 'Søk GIFs';

  @override
  String get writeAMessageLabel => 'Send en melding';

  @override
  String get instantCommandsLabel => 'Direkte kommandoer';

  @override
  String fileTooLargeAfterCompressionError(double limitInMB) =>
      'Filen er for stor til å laste opp. '
      'Grensen for filopplasting er $limitInMB MB. '
      'Vi prøvde å komprimere den, men det hjalp ikke.';

  @override
  String fileTooLargeError(double limitInMB) => 'Filen er for stor til å laste opp. Filgrense er $limitInMB MB.';

  @override
  String fileTypeNotSupportedError(String? extension) {
    if (extension != null) return "'.$extension'-filer støttes ikke for opplasting.";
    return 'Denne filtypen støttes ikke for opplasting.';
  }

  @override
  String get addAFileLabel => 'Legg til en fil';

  @override
  String get photoFromCameraLabel => 'Bilde fra kamera';

  @override
  String get uploadAFileLabel => 'Last opp en fil';

  @override
  String get uploadAPhotoLabel => 'Last opp et bilde';

  @override
  String get uploadAVideoLabel => 'Last opp en video';

  @override
  String get videoFromCameraLabel => 'Video fra kamera';

  @override
  String get okLabel => 'OK';

  @override
  String get somethingWentWrongError => 'Noe gikk galt';

  @override
  String get addMoreFilesLabel => 'Legg til flere';

  @override
  String get enablePhotoAndVideoAccessMessage =>
      'Vennligst gi tillatelse til dine bilder og videoer så du kan dele de med dine venner.';

  @override
  String get allowGalleryAccessMessage => 'Tillat tilgang til galleri';

  @override
  String get flagMessageLabel => 'Rapporter melding';

  @override
  String get flagMessageQuestion =>
      'Ønsker du å sende en kopi av denne meldingen til en moderator for videre undersøkelser';

  @override
  String get flagLabel => 'Rapporter';

  @override
  String get cancelLabel => 'Avbryt';

  @override
  String get flagMessageSuccessfulLabel => 'Melding rapportert';

  @override
  String get flagMessageSuccessfulText => 'Meldingen har blitt rapportert til en moderator.';

  @override
  String get deleteLabel => 'Slett';

  @override
  String get deleteMessageLabel => 'Slett melding';

  @override
  String get deleteMessageQuestion => 'Er du sikker på at du ønsker å slette denne meldingen permanent?';

  @override
  String get operationCouldNotBeCompletedText => 'Denne handlingen kunne ikke bli gjennomført.';

  @override
  String get replyLabel => 'Svar';

  @override
  String togglePinUnpinText({required bool pinned}) {
    if (pinned) return 'Løsne fra samtale';
    return 'Fest til samtale';
  }

  @override
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed}) {
    if (isDeleteFailed) return 'Prøv å slett melding på nytt';
    return 'Slett melding';
  }

  @override
  String get copyMessageLabel => 'Kopier melding';

  @override
  String get editMessageLabel => 'Rediger melding';

  @override
  String toggleResendOrResendEditedMessage({required bool isUpdateFailed}) {
    if (isUpdateFailed) return 'Send redigert melding på nytt';
    return 'Send på nytt';
  }

  @override
  String get photosLabel => 'Foto';

  @override
  String get photosAndVideosLabel => 'Foto og video';

  String _getDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'i dag';
    } else if (date == yesterday) {
      return 'i går';
    } else {
      return 'på ${Jiffy.parseFromDateTime(date).MMMd}';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) {
    final atTime = Jiffy.parseFromDateTime(time.toLocal());
    return 'Sent ${_getDay(date)} kl. ${atTime.jm}';
  }

  @override
  String get todayLabel => 'I dag';

  @override
  String get yesterdayLabel => 'I går';

  @override
  String get channelIsMutedText => 'Kanal er dempet';

  @override
  String get noTitleText => 'Ingen tittel';

  @override
  String get letsStartChattingLabel => 'La oss starte å chatte!';

  @override
  String get sendingFirstMessageLabel => 'Hva med å sende din første melding til en venn?';

  @override
  String get startAChatLabel => 'Start en chat';

  @override
  String get loadingChannelsError => 'Problemer med å laste inn kanaler';

  @override
  String get deleteConversationLabel => 'Slett samtale';

  @override
  String get deleteConversationQuestion => 'Er du sikker på at du ønsker å slette denne samtalen?';

  @override
  String get streamChatLabel => 'Samtaler';

  @override
  String get searchingForNetworkText => 'Søker etter nettverk';

  @override
  String get offlineLabel => 'Avlogget...';

  @override
  String get tryAgainLabel => 'Prøv igjen';

  @override
  String membersCountText(int count) {
    if (count == 1) return '1 medlem';
    return '$count medlemmer';
  }

  @override
  String watchersCountText(int count) {
    if (count == 1) return '1 pålogget';
    return '$count pålogget';
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
  String get viewInfoLabel => 'Se info';

  @override
  String get leaveGroupLabel => 'Forlat gruppe';

  @override
  String get leaveLabel => 'FORLAT';

  @override
  String get leaveConversationLabel => 'Forlat samtale';

  @override
  String get leaveConversationQuestion => 'Er du sikker på at du ønsker å forlate denne samtalen?';

  @override
  String get showInChatLabel => 'Se i chat';

  @override
  String get saveImageLabel => 'Lagre bilde';

  @override
  String get saveVideoLabel => 'Lagre video';

  @override
  String get uploadErrorLabel => 'PROBLEM MED OPPLASTNING';

  @override
  String get giphyLabel => 'Giphy';

  @override
  String get shuffleLabel => 'Stokk om';

  @override
  String get sendLabel => 'Send';

  @override
  String get withText => 'med';

  @override
  String get inText => 'i';

  @override
  String get youText => 'Du';

  @override
  String galleryPaginationText({
    required int currentPage,
    required int totalPages,
  }) => '${currentPage + 1} of $totalPages';

  @override
  String get fileText => 'Fil';

  @override
  String get replyToMessageLabel => 'Svar på melding';

  @override
  String attachmentLimitExceedError(int limit) => 'Antall vedlegg oversteget, maks antall: $limit';

  @override
  String slowModeOnLabel(int cooldownTimeOut) => 'Sakte modus, vent ${cooldownTimeOut}s\u2026';

  @override
  String get commandUsernameLabel => '@username';

  @override
  String get linkDisabledDetails => 'Sende lenker er ikke lov i denne samtalen.';

  @override
  String get linkDisabledError => 'Lenker er deaktivert';

  @override
  String get viewLibrary => 'Se bibliotek';

  @override
  String unreadMessagesSeparatorText() => 'Nye meldinger.';

  @override
  String get couldNotReadBytesFromFileError => 'Kunne ikke lese bytes fra filen.';

  @override
  String get downloadLabel => 'Nedlasting';

  @override
  String toggleMuteUnmuteAction({required bool isMuted}) {
    if (isMuted) return 'Slå på lyden for bruker';
    return 'Dempe bruker';
  }

  @override
  String toggleMuteUnmuteGroupQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'Er du sikker på at du vil oppheve ignoreringen av denne gruppen?';
    }
    return 'Er du sikker på at du vil ignorere denne gruppen?';
  }

  @override
  String toggleMuteUnmuteGroupText({required bool isMuted}) {
    if (isMuted) return 'Slå på lyden for gruppe';
    return 'Mute gruppe';
  }

  @override
  String toggleMuteUnmuteUserQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'Er du sikker på at du vil oppheve ignoreringen av denne brukeren?';
    }
    return 'Er du sikker på at du vil ignorere denne brukeren?';
  }

  @override
  String toggleMuteUnmuteUserText({required bool isMuted}) {
    if (isMuted) return 'Opphev lyden av brukeren';
    return 'Dempe brukeren';
  }

  @override
  String toggleBlockUnblockUserText({required bool isBlocked}) {
    if (isBlocked) return 'Opphev blokkering';
    return 'Blokker bruker';
  }

  @override
  String get enableFileAccessMessage => 'Aktiver tilgang til filer slik at du kan dele dem med venner.';

  @override
  String get allowFileAccessMessage => 'Gi tilgang til filer';

  @override
  String get markAsUnreadLabel => 'Merk som ulest';

  @override
  String unreadCountIndicatorLabel({required int unreadCount}) {
    return '$unreadCount uleste';
  }

  @override
  String get markUnreadError =>
      'Feil ved merking av melding som ulest. Kan ikke merke meldinger som'
      ' uleste som er eldre enn de 100 nyeste kanalmeldingene.';

  @override
  String createPollLabel({bool isNew = false}) {
    if (isNew) return 'Opprett en ny avstemning';
    return 'Opprett avstemning';
  }

  @override
  String questionLabel({bool isPlural = false}) => 'Spørsmål';

  @override
  String get askAQuestionLabel => 'Still et spørsmål';

  @override
  String? pollQuestionValidationError(int length, Range<int> range) {
    final (:min, :max) = range;

    // Check if the question is too short.
    if (min != null && length < min) {
      return 'Spørsmålet må være minst $min tegn langt';
    }

    // Check if the question is too long.
    if (max != null && length > max) {
      return 'Spørsmålet må være maksimalt $max tegn langt';
    }

    return null;
  }

  @override
  String optionLabel({bool isPlural = false}) {
    if (isPlural) return 'Alternativer';
    return 'Opsjon';
  }

  @override
  String get pollOptionEmptyError => 'Alternativet kan ikke være tomt';

  @override
  String get pollOptionDuplicateError => 'Dette er allerede et alternativ';

  @override
  String get addAnOptionLabel => 'Legg til et alternativ';

  @override
  String get multipleAnswersLabel => 'Flere svar';

  @override
  String get maximumVotesPerPersonLabel => 'Maksimalt antall stemmer per person';

  @override
  String? maxVotesPerPersonValidationError(int votes, Range<int> range) {
    final (:min, :max) = range;

    if (min != null && votes < min) {
      return 'Stemmetellingen må være minst $min';
    }

    if (max != null && votes > max) {
      return 'Stemmeopptellingen må være på maksimalt $max';
    }

    return null;
  }

  @override
  String get anonymousPollLabel => 'Anonym avstemning';

  @override
  String get pollOptionsLabel => 'Avstemningsalternativer';

  @override
  String get suggestAnOptionLabel => 'Foreslå et alternativ';

  @override
  String get enterANewOptionLabel => 'Skriv inn et nytt alternativ';

  @override
  String get addACommentLabel => 'Legg til en kommentar';

  @override
  String get pollCommentsLabel => 'Kommentarer til avstemningen';

  @override
  String get updateYourCommentLabel => 'Oppdater kommentaren din';

  @override
  String get enterYourCommentLabel => 'Skriv inn kommentaren din';

  @override
  String get endVoteConfirmationTitle => 'Er du sikker på at du vil avslutte avstemningen?';

  @override
  String get endVoteConfirmationMessage =>
      'Vil du avslutte denne avstemningen nå? Ingen vil kunne stemme i denne avstemningen lenger.';

  @override
  String get deletePollOptionLabel => 'Slett alternativ';

  @override
  String get deletePollOptionQuestion => 'Er du sikker på at du vil slette dette alternativet?';

  @override
  String get createLabel => 'Opprett';

  @override
  String get endLabel => 'Avslutt';

  @override
  String pollVotingModeLabel(PollVotingMode votingMode) {
    return votingMode.when(
      disabled: () => 'Avstemning avsluttet',
      unique: () => 'Velg én',
      limited: (count) => 'Velg opptil $count',
      all: () => 'Velg én eller flere',
    );
  }

  @override
  String seeAllOptionsLabel({int? count}) {
    if (count == null) return 'Se alle alternativer';
    return 'Se alle $count alternativer';
  }

  @override
  String get viewCommentsLabel => 'Vis kommentarer';

  @override
  String get viewResultsLabel => 'Vis resultater';

  @override
  String get endVoteLabel => 'Avslutt avstemning';

  @override
  String get pollResultsLabel => 'Resultater for avstemningen';

  @override
  String get pollVotesLabel => 'Stemmer';

  @override
  String showAllVotesLabel({int? count}) {
    if (count == null) return 'Vis alle stemmer';
    return 'Vis alle $count stemmer';
  }

  @override
  String get viewAllLabel => 'Vis alle';

  @override
  String voteCountLabel({int? count}) => switch (count) {
    null || < 1 => '0 stemmer',
    1 => '1 stemme',
    _ => '$count stemmer',
  };

  @override
  String totalVoteCountLabel({int? count}) => switch (count) {
    null || < 1 => '0 stemmer totalt',
    1 => '1 stemme totalt',
    _ => '$count stemmer totalt',
  };

  @override
  String get noPollVotesLabel => 'Det er ingen stemmer for øyeblikket';

  @override
  String get loadingPollVotesError => 'Feil ved lasting av stemmer';

  @override
  String get repliedToLabel => 'svarte på:';

  @override
  String newThreadsLabel({required int count}) {
    if (count == 1) return '1 ny tråd';
    return '$count nye tråder';
  }

  @override
  String get loadingLabel => 'Laster...';

  @override
  String get slideToCancelLabel => 'Gli for å avbryte';

  @override
  String get holdToRecordLabel => 'Hold for å ta opp, slipp for å sende';

  @override
  String get sendAnywayLabel => 'Send likevel';

  @override
  String get moderatedMessageBlockedText => 'Meldingen ble blokkert av modereringsregler';

  @override
  String get moderationReviewModalTitle => 'Er du sikker?';

  @override
  String get moderationReviewModalDescription =>
      '''Tenk på hvordan kommentaren din kan få andre til å føle seg og sørg for å følge retningslinjene for fellesskapet.''';

  @override
  String get emptyMessagePreviewText => '';

  @override
  String get voiceRecordingText => 'Taleopptak';

  @override
  String get audioAttachmentText => 'Lyd';

  @override
  String get imageAttachmentText => 'Bilde';

  @override
  String get videoAttachmentText => 'Video';

  @override
  String get fileAttachmentText => 'Fil';

  @override
  String get linkAttachmentText => 'Lenke';

  @override
  String filesAttachmentCountText(int count) => count == 1 ? 'Fil' : '$count filer';

  @override
  String photosAttachmentCountText(int count) => count == 1 ? 'Bilde' : '$count bilder';

  @override
  String videosAttachmentCountText(int count) => count == 1 ? 'Video' : '$count videoer';

  @override
  String get pollYouVotedText => 'Du stemte';

  @override
  String pollSomeoneVotedText(String username) => '$username stemte';

  @override
  String get pollYouCreatedText => 'Du opprettet';

  @override
  String pollSomeoneCreatedText(String username) => '$username opprettet';

  @override
  String get draftLabel => 'Utkast';

  @override
  String locationLabel({bool isLive = false}) {
    if (isLive) return 'Direkte posisjon';
    return 'Posisjon';
  }

  @override
  String get noConversationsYetText => 'Ingen samtaler ennå';

  @override
  String get replyToStartThreadText => 'Svar på en melding for å starte en tråd';

  @override
  String get sendMessageToStartConversationText => 'Send en melding for å starte samtalen';

  @override
  String get savedForLaterLabel => 'Lagret til senere';

  @override
  String get repliedToThreadAnnotationLabel => 'Svarte i en tråd';

  @override
  String get alsoSentInChannelAnnotationLabel => 'Også sendt i kanalen';

  @override
  String get viewLabel => 'Vis';

  @override
  String get reminderSetLabel => 'Påminnelse satt';

  @override
  String reminderAtText(String time) => 'I dag kl. $time';

  @override
  String get createPollPromptLabel => 'Lag en avstemning og la alle stemme!';

  @override
  String get takePhotoAndShareLabel => 'Ta et bilde og del';

  @override
  String get takeVideoAndShareLabel => 'Ta en video og del';

  @override
  String get openCameraLabel => 'Åpne kamera';

  @override
  String get selectFilesToShareLabel => 'Velg filer å dele';

  @override
  String get openFilesLabel => 'Åpne filer';

  @override
  String get unsupportedAttachmentLabel => 'Vedlegg støttes ikke';

  @override
  String get confirmLabel => 'BEKREFT';

  @override
  String get emptyReactionsText => 'Ingen reaksjoner ennå';

  @override
  String get loadingReactionsError => 'Kunne ikke laste reaksjoner';

  @override
  String get tapToRemoveReactionLabel => 'Trykk for å fjerne';

  @override
  String reactionsCountText(int count) => '$count reaksjoner';

  @override
  String get justNowLabel => 'Akkurat nå';

  @override
  String replyToUserLabel(String userName) => 'Svar til $userName';

  @override
  String get multipleAnswersDescription => 'Velg mer enn ett alternativ';

  @override
  String maximumVotesPerPersonDescription([Range<int>? range]) {
    final (:min, :max) = range ?? (min: 2, max: 10);
    return 'Velg mellom $min\u2013$max alternativer';
  }

  @override
  String get anonymousPollDescription => 'Skjul hvem som stemte';

  @override
  String get suggestAnOptionDescription => 'La andre legge til alternativer';

  @override
  String get addACommentDescription => 'La andre legge til kommentarer';

  @override
  String get notifyChannelText => 'Varsle alle i denne kanalen';

  @override
  String get notifyHereText => 'Varsle alle pålogga medlemmer i denne kanalen';

  @override
  String notifyRoleText(String role) => 'Varsle alle $role-medlemmer';
}
