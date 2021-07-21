import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    show User;

abstract class Translations {
  String get launchUrlError;

  String get loadingUsersError;

  String get retryLabel;

  String get noUsersLabel;

  String get userOnlineText;

  String get userLastOnlineText;

  String userTypingText(Iterable<User> users);

  String get threadReplyLabel;

  String get onlyVisibleToYouText;

  String threadReplyCountText(int count);

  String attachmentsUploadProgressText({
    required int remaining,
    required int total,
  });

  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  });

  String get emptyMessagesText;

  String get genericErrorText;

  String get loadingMessagesError;

  String resultCountText(int count);

  String get messageDeletedText;

  String get messageDeletedLabel;

  String get messageReactionsText;

  String get emptyChatMessagesText;

  String threadSeparatorText(int replyCount);

  String get connectedLabel;

  String get disconnectedLabel;

  String get reconnectingLabel;

  String get alsoSendAsDirectMessageLabel;

  String get searchGifLabel;

  String get addACommentOrSendLabel;

  String get writeAMessageLabel;

  String get instantCommandsLabel;

  String fileTooLargeAfterCompressionError(double limitInMB);

  String fileTooLargeError(double limitInMB);

  String emojiMatchingQueryText(String query);

  String get addAFileLabel;

  String get uploadAPhotoLabel;

  String get uploadAVideoLabel;

  String get photoFromCameraLabel;

  String get videoFromCameraLabel;

  String get uploadAFileLabel;

  String get somethingWentWrongLabel;

  String get okLabel;

  String get addMoreFilesLabel;

  String get enablePhotoAndVideoAccessMessage;

  String get allowGalleryAccessMessage;

  String get flagMessageLabel;

  String get flagMessageQuestion;

  String get flagLabel;

  String get cancelLabel;

  String get flagMessageSuccessfulLabel;

  String get flagMessageSuccessfulText;

  String get deleteMessageLabel;

  String get deleteMessageQuestion;

  String get deleteLabel;

  String get operationCouldNotBeCompletedText;

  String get replyLabel;

  String togglePinUnpinText({required bool pinned});

  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed});

  String get copyMessageLabel;

  String get editMessageLabel;

  String toggleResendOrResendEditedMessage({required bool isUpdateFailed});

  String get photosLabel;

  String sentAtText({required DateTime date, required DateTime time});

  String get todayLabel;

  String get yesterdayLabel;

  String get channelIsMutedText;

  String get noTitleText;

  String get letsStartChattingLabel;

  String get sendingFirstMessageLabel;

  String get startAChatLabel;

  String get loadingChannelsError;

  String get deleteConversationLabel;

  String get deleteConversationQuestion;

  String get streamChatLabel;

  String get searchingForNetworkLabel;

  String get offlineLabel;

  String get tryAgainLabel;

  String membersCountText(int count);

  String watchersCountText(int count);

  String get viewInfoLabel;

  String get leaveGroupLabel;

  String get leaveLabel;

  String get leaveConversationLabel;

  String get leaveConversationQuestion;

  String get showInChatLabel;

  String get saveImageLabel;

  String get saveVideoLabel;

  String get uploadErrorLabel;

  String get giphyLabel;

  String get shuffleLabel;

  String get sendLabel;

  String get withText;

  String get inText;

  String get youText;

  String get ofText;

  String get fileText;

  String get replyToMessageLabel;
}

class DefaultTranslations implements Translations {
  const DefaultTranslations._();

  static const instance = DefaultTranslations._();

  @override
  String get launchUrlError => 'Cannot launch the url';

  @override
  String get loadingUsersError => 'Error loading users';

  @override
  String get noUsersLabel => 'There are no users currently';

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
  String get messageReactionsText => 'Message Reactions';

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
  String emojiMatchingQueryText(String query) => 'Emoji matching "$query"';

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
  String get somethingWentWrongLabel => 'Something went wrong';

  @override
  String get addMoreFilesLabel => 'Add more files';

  @override
  String get enablePhotoAndVideoAccessMessage =>
      'Please enable access to your photos'
      '\nand videos so you can share them with friends.';

  @override
  String get allowGalleryAccessMessage => 'Allow access to your gallery';

  @override
  String get flagMessageLabel => 'Flag Message';

  @override
  String get flagMessageQuestion =>
      'Do you want to send a copy of this message to a'
      '\nmoderator for further investigation?';

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
      'Are you sure you want to permanently delete this\nmessage?';

  @override
  String get operationCouldNotBeCompletedText =>
      'The operation couldn\'t be completed.';

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
    final now = Jiffy(DateTime.now());
    final date = Jiffy(dateTime);

    if (date.isSame(now, Units.DAY)) {
      return 'today';
    } else if (now.diff(date, Units.HOUR) < 24) {
      return 'yesterday';
    } else {
      return 'on ${date.MMMd}';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) =>
      'Sent ${_getDay(date)} at ${Jiffy(time.toLocal()).format('HH:mm')}';

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
  String get searchingForNetworkLabel => 'Searching for Network';

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
  String get ofText => 'of';

  @override
  String get fileText => 'File';

  @override
  String get replyToMessageLabel => 'Reply to Message';
}
