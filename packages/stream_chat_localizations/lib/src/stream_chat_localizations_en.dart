part of 'stream_chat_localizations.dart';

/// The translations for English (`en`).
class StreamChatLocalizationsEn extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for English.
  const StreamChatLocalizationsEn({super.localeName = 'en'});

  @override
  String get launchUrlError => 'Cannot launch the url';

  @override
  String get loadingUsersError => 'Error loading users';

  @override
  String get noUsersLabel => 'There are no users currently';

  @override
  String get noPhotoOrVideoLabel => 'There is no photo or video';

  @override
  String get retryLabel => 'Retry';

  @override
  String get userLastOnlineText => 'Last online';

  @override
  String get userOnlineText => 'Online';

  @override
  String userTypingText(Iterable<User> users) {
    if (users.isEmpty) return '';
    final first = users.first;
    if (users.length == 1) {
      return '${first.name} is typing';
    }
    return '${first.name} and ${users.length - 1} more are typing';
  }

  @override
  String get threadReplyLabel => 'Thread Reply';

  @override
  String get onlyVisibleToYouText => 'Only visible to you';

  @override
  String threadReplyCountText(int count) => '$count Thread Replies';

  @override
  String attachmentsUploadProgressText({
    required int remaining,
    required int total,
  }) =>
      'Uploading $remaining/$total ...';

  @override
  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  }) {
    final pinnedByCurrentUser = currentUser.id == pinnedBy.id;
    if (pinnedByCurrentUser) return 'Pinned by You';
    return 'Pinned by ${pinnedBy.name}';
  }

  @override
  String get sendMessagePermissionError =>
      "You don't have permission to send messages";

  @override
  String get emptyMessagesText => 'There are no messages currently';

  @override
  String get genericErrorText => 'Something went wrong';

  @override
  String get loadingMessagesError => 'Error loading messages';

  @override
  String resultCountText(int count) => '$count results';

  @override
  String get messageDeletedText => 'This message is deleted.';

  @override
  String get messageDeletedLabel => 'Message deleted';

  @override
  String get systemMessageLabel => 'System Message';

  @override
  String get editedMessageLabel => 'Edited';

  @override
  String get messageReactionsLabel => 'Message Reactions';

  @override
  String get emptyChatMessagesText => 'No chats here yet...';

  @override
  String threadSeparatorText(int replyCount) {
    if (replyCount == 1) return '1 Reply';
    return '$replyCount Replies';
  }

  @override
  String get connectedLabel => 'Connected';

  @override
  String get disconnectedLabel => 'Disconnected';

  @override
  String get reconnectingLabel => 'Reconnecting...';

  @override
  String get alsoSendAsDirectMessageLabel => 'Also send as direct message';

  @override
  String get addACommentOrSendLabel => 'Add a comment or send';

  @override
  String get searchGifLabel => 'Search GIFs';

  @override
  String get writeAMessageLabel => 'Write a message';

  @override
  String get instantCommandsLabel => 'Instant Commands';

  @override
  String fileTooLargeAfterCompressionError(double limitInMB) =>
      'The file is too large to upload. '
      'The file size limit is $limitInMB MB. '
      'We tried compressing it, but it was not enough.';

  @override
  String fileTooLargeError(double limitInMB) =>
      'The file is too large to upload. The file size limit is $limitInMB MB.';

  @override
  String get couldNotReadBytesFromFileError =>
      'Could not read bytes from file.';

  @override
  String get addAFileLabel => 'Add a file';

  @override
  String get photoFromCameraLabel => 'Photo from camera';

  @override
  String get uploadAFileLabel => 'Upload a file';

  @override
  String get uploadAPhotoLabel => 'Upload a photo';

  @override
  String get uploadAVideoLabel => 'Upload a video';

  @override
  String get videoFromCameraLabel => 'Video from camera';

  @override
  String get okLabel => 'OK';

  @override
  String get somethingWentWrongError => 'Something went wrong';

  @override
  String get addMoreFilesLabel => 'Add more files';

  @override
  String get enablePhotoAndVideoAccessMessage =>
      'Please enable access to your photos and videos so you can share them with friends.';

  @override
  String get allowGalleryAccessMessage => 'Allow access to your gallery';

  @override
  String get flagMessageLabel => 'Flag Message';

  @override
  String get flagMessageQuestion =>
      'Do you want to send a copy of this message to a moderator for further investigation?';

  @override
  String get flagLabel => 'FLAG';

  @override
  String get cancelLabel => 'CANCEL';

  @override
  String get flagMessageSuccessfulLabel => 'Message flagged';

  @override
  String get flagMessageSuccessfulText =>
      'The message has been reported to a moderator.';

  @override
  String get deleteLabel => 'DELETE';

  @override
  String get deleteMessageLabel => 'Delete Message';

  @override
  String get deleteMessageQuestion =>
      'Are you sure you want to permanently delete this message?';

  @override
  String get operationCouldNotBeCompletedText =>
      "The operation couldn't be completed.";

  @override
  String get replyLabel => 'Reply';

  @override
  String togglePinUnpinText({required bool pinned}) {
    if (pinned) return 'Unpin from Conversation';
    return 'Pin to Conversation';
  }

  @override
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed}) {
    if (isDeleteFailed) return 'Retry Deleting Message';
    return 'Delete Message';
  }

  @override
  String get copyMessageLabel => 'Copy Message';

  @override
  String get editMessageLabel => 'Edit Message';

  @override
  String toggleResendOrResendEditedMessage({required bool isUpdateFailed}) {
    if (isUpdateFailed) return 'Resend Edited Message';
    return 'Resend';
  }

  @override
  String get photosLabel => 'Photos';

  String _getDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'today';
    } else if (date == yesterday) {
      return 'yesterday';
    } else {
      return 'on ${Jiffy.parseFromDateTime(date).MMMd}';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) {
    final atTime = Jiffy.parseFromDateTime(time.toLocal());
    return 'Sent ${_getDay(date)} at ${atTime.jm}';
  }

  @override
  String get todayLabel => 'Today';

  @override
  String get yesterdayLabel => 'Yesterday';

  @override
  String get channelIsMutedText => 'Channel is muted';

  @override
  String get noTitleText => 'No title';

  @override
  String get letsStartChattingLabel => 'Let’s start chatting!';

  @override
  String get sendingFirstMessageLabel =>
      'How about sending your first message to a friend?';

  @override
  String get startAChatLabel => 'Start a chat';

  @override
  String get loadingChannelsError => 'Error loading channels';

  @override
  String get deleteConversationLabel => 'Delete Conversation';

  @override
  String get deleteConversationQuestion =>
      'Are you sure you want to delete this conversation?';

  @override
  String get streamChatLabel => 'Stream Chat';

  @override
  String get searchingForNetworkText => 'Searching for Network';

  @override
  String get offlineLabel => 'Offline...';

  @override
  String get tryAgainLabel => 'Try Again';

  @override
  String membersCountText(int count) {
    if (count == 1) return '1 Member';
    return '$count Members';
  }

  @override
  String watchersCountText(int count) {
    if (count == 1) return '1 Online';
    return '$count Online';
  }

  @override
  String get viewInfoLabel => 'View Info';

  @override
  String get leaveGroupLabel => 'Leave Group';

  @override
  String get leaveLabel => 'LEAVE';

  @override
  String get leaveConversationLabel => 'Leave conversation';

  @override
  String get leaveConversationQuestion =>
      'Are you sure you want to leave this conversation?';

  @override
  String get showInChatLabel => 'Show in Chat';

  @override
  String get saveImageLabel => 'Save Image';

  @override
  String get saveVideoLabel => 'Save Video';

  @override
  String get uploadErrorLabel => 'UPLOAD ERROR';

  @override
  String get giphyLabel => 'Giphy';

  @override
  String get shuffleLabel => 'Shuffle';

  @override
  String get sendLabel => 'Send';

  @override
  String get withText => 'with';

  @override
  String get inText => 'in';

  @override
  String get youText => 'You';

  @override
  String galleryPaginationText({
    required int currentPage,
    required int totalPages,
  }) =>
      '${currentPage + 1} of $totalPages';

  @override
  String get fileText => 'File';

  @override
  String get replyToMessageLabel => 'Reply to Message';

  @override
  String attachmentLimitExceedError(int limit) =>
      'Attachment limit exceeded, limit: $limit';

  @override
  String get slowModeOnLabel => 'Slow mode ON';

  @override
  String get downloadLabel => 'Download';

  @override
  String toggleMuteUnmuteUserText({required bool isMuted}) {
    if (isMuted) {
      return 'Unmute User';
    } else {
      return 'Mute User';
    }
  }

  @override
  String toggleMuteUnmuteGroupQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'Are you sure you want to unmute this group?';
    } else {
      return 'Are you sure you want to mute this group?';
    }
  }

  @override
  String toggleMuteUnmuteUserQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'Are you sure you want to unmute this user?';
    } else {
      return 'Are you sure you want to mute this user?';
    }
  }

  @override
  String toggleMuteUnmuteAction({required bool isMuted}) {
    if (isMuted) {
      return 'UNMUTE';
    } else {
      return 'MUTE';
    }
  }

  @override
  String toggleMuteUnmuteGroupText({required bool isMuted}) {
    if (isMuted) {
      return 'Unmute Group';
    } else {
      return 'Mute Group';
    }
  }

  @override
  String get linkDisabledDetails =>
      'Sending links is not allowed in this conversation.';

  @override
  String get linkDisabledError => 'Links are disabled';

  @override
  String get viewLibrary => 'View library';

  @override
  String unreadMessagesSeparatorText() => 'New messages';

  @override
  String get enableFileAccessMessage =>
      'Please enable access to files so you can share them with friends.';

  @override
  String get allowFileAccessMessage => 'Allow access to files';

  @override
  String get markAsUnreadLabel => 'Mark as Unread';

  @override
  String unreadCountIndicatorLabel({required int unreadCount}) {
    return '$unreadCount unread';
  }

  @override
  String get markUnreadError =>
      'Error marking message unread. Cannot mark unread messages older'
      ' than the newest 100 channel messages.';

  @override
  String createPollLabel({bool isNew = false}) {
    if (isNew) return 'Create a new poll';
    return 'Create Poll';
  }

  @override
  String get questionsLabel => 'Questions';

  @override
  String get askAQuestionLabel => 'Ask a question';

  @override
  String? pollQuestionValidationError(int length, Range<int> range) {
    final (:min, :max) = range;

    // Check if the question is too short.
    if (min != null && length < min) {
      return 'Question must be at least $min characters long';
    }

    // Check if the question is too long.
    if (max != null && length > max) {
      return 'Question must be at most $max characters long';
    }

    return null;
  }

  @override
  String optionLabel({bool isPlural = false}) {
    if (isPlural) return 'Options';
    return 'Option';
  }

  @override
  String get pollOptionEmptyError => 'Option cannot be empty';

  @override
  String get pollOptionDuplicateError => 'This is already an option';

  @override
  String get addAnOptionLabel => 'Add an option';

  @override
  String get multipleAnswersLabel => 'Multiple answers';

  @override
  String get maximumVotesPerPersonLabel => 'Maximum votes per person';

  @override
  String? maxVotesPerPersonValidationError(int votes, Range<int> range) {
    final (:min, :max) = range;

    if (min != null && votes < min) {
      return 'Vote count must be at least $min';
    }

    if (max != null && votes > max) {
      return 'Vote count must be at most $max';
    }

    return null;
  }

  @override
  String get anonymousPollLabel => 'Anonymous poll';

  @override
  String get pollOptionsLabel => 'Poll Options';

  @override
  String get suggestAnOptionLabel => 'Suggest an option';

  @override
  String get enterANewOptionLabel => 'Enter a new option';

  @override
  String get addACommentLabel => 'Add a comment';

  @override
  String get pollCommentsLabel => 'Poll Comments';

  @override
  String get updateYourCommentLabel => 'Update your comment';

  @override
  String get enterYourCommentLabel => 'Enter your comment';

  @override
  String get endVoteConfirmationText =>
      'Are you sure you want to end the vote?';

  @override
  String get createLabel => 'Create';

  @override
  String get endLabel => 'End';

  @override
  String pollVotingModeLabel(PollVotingMode votingMode) {
    return votingMode.when(
      disabled: () => 'Vote ended',
      unique: () => 'Select one',
      limited: (count) => 'Select up to $count',
      all: () => 'Select one or more',
    );
  }

  @override
  String seeAllOptionsLabel({int? count}) {
    if (count == null) return 'See all options';
    return 'See all $count options';
  }

  @override
  String get viewCommentsLabel => 'View Comments';

  @override
  String get viewResultsLabel => 'View Results';

  @override
  String get endVoteLabel => 'End Vote';

  @override
  String get pollResultsLabel => 'Poll Results';

  @override
  String showAllVotesLabel({int? count}) {
    if (count == null) return 'Show all votes';
    return 'Show all $count votes';
  }

  @override
  String voteCountLabel({int? count}) => switch (count) {
        null || < 1 => '0 votes',
        1 => '1 vote',
        _ => '$count votes',
      };

  @override
  String get noPollVotesLabel => 'There are no poll votes currently';

  @override
  String get loadingPollVotesError => 'Error loading poll votes';

  @override
  String get repliedToLabel => 'replied to:';

  @override
  String newThreadsLabel({required int count}) {
    if (count == 1) return '1 new thread';
    return '$count new threads';
  }

  @override
  String get slideToCancelLabel => 'Slide to cancel';

  @override
  String get holdToRecordLabel => 'Hold to record, release to send.';

  @override
  String get sendAnywayLabel => 'Send Anyway';

  @override
  String get moderatedMessageBlockedText =>
      'Message was blocked by moderation policies';

  @override
  String get moderationReviewModalTitle => 'Are you sure?';

  @override
  String get moderationReviewModalDescription =>
      '''Consider how your comment might make others feel and be sure to follow our Community Guidelines.''';

  @override
  String get emptyMessagePreviewText => '';

  @override
  String get voiceRecordingText => 'Voice Recording';

  @override
  String get audioAttachmentText => 'Audio';

  @override
  String get imageAttachmentText => 'Image';

  @override
  String get videoAttachmentText => 'Video';

  @override
  String get pollYouVotedText => 'You voted';

  @override
  String pollSomeoneVotedText(String username) => '$username voted';

  @override
  String get pollYouCreatedText => 'You created';

  @override
  String pollSomeoneCreatedText(String username) => '$username created';

  @override
  String get draftLabel => 'Draft';
}
