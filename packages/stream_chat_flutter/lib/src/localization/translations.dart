import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/connection_status_builder.dart';
import 'package:stream_chat_flutter/src/message_input.dart';
import 'package:stream_chat_flutter/src/message_list_view.dart';
import 'package:stream_chat_flutter/src/message_search_list_view.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    show User;

/// Translation strings for the stream chat widgets
abstract class Translations {
  /// The error shown when [launchURL] fails
  String get launchUrlError;

  /// The error shown when loading users fails
  String get loadingUsersError;

  /// The label for "retry" button
  String get retryLabel;

  /// The label for showing no users
  String get noUsersLabel;

  /// The text for showing user is online
  String get userOnlineText;

  /// The text for showing the last online of the user
  String get userLastOnlineText;

  /// The text shown when [users] starts typing
  String userTypingText(Iterable<User> users);

  /// The label for "thread reply"
  String get threadReplyLabel;

  /// The text for showing if the message is only visible to you
  String get onlyVisibleToYouText;

  /// The text for showing the thread reply count
  String threadReplyCountText(int count);

  /// The text for showing the attachments upload progress
  String attachmentsUploadProgressText({
    required int remaining,
    required int total,
  });

  /// The text for showing who pinned the message
  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  });

  /// The text for showing there are empty messages
  String get emptyMessagesText;

  /// The text for showing generic error
  String get genericErrorText;

  /// The error shown when loading messages fails
  String get loadingMessagesError;

  /// The text for showing the result count in [MessageSearchListView]
  String resultCountText(int count);

  /// The text for showing the message is deleted
  String get messageDeletedText;

  /// The label for message deleted
  String get messageDeletedLabel;

  /// The label for message reactions
  String get messageReactionsLabel;

  /// The text for showing there are no chats
  String get emptyChatMessagesText;

  /// The text for showing the thread separator in case [MessageListView]
  /// contains a parent message
  String threadSeparatorText(int replyCount);

  /// The label for "connected" in [ConnectionStatusBuilder]
  String get connectedLabel;

  /// The label for "disconnected" in [ConnectionStatusBuilder]
  String get disconnectedLabel;

  /// The label for "reconnecting" in [ConnectionStatusBuilder]
  String get reconnectingLabel;

  /// The label for also send as direct message "checkbox"" in [MessageInput]
  String get alsoSendAsDirectMessageLabel;

  /// The label for search Gif
  String get searchGifLabel;

  /// The label for add a comment or send in case of
  /// attachments inside [MessageInput]
  String get addACommentOrSendLabel;

  /// The label for write a message in [MessageInput]
  String get writeAMessageLabel;

  /// The label for slow mode enabled in [MessageInput]
  String get slowModeOnLabel;

  /// The label for instant commands in [MessageInput]
  String get instantCommandsLabel;

  /// The error shown in case the fi"le is too large even after compression
  /// while uploading via [MessageInput]
  String fileTooLargeAfterCompressionError(double limitInMB);

  /// The error shown in case the file is too large
  /// while uploading via [MessageInput]
  String fileTooLargeError(double limitInMB);

  /// The text for showing the query while searching for emojis
  String emojiMatchingQueryText(String query);

  /// The label for "add a file"
  String get addAFileLabel;

  /// The label for "upload a photo"
  String get uploadAPhotoLabel;

  /// The label for "upload a video"
  String get uploadAVideoLabel;

  /// The label for "photo from camera"
  String get photoFromCameraLabel;

  /// The label for "video from camera"
  String get videoFromCameraLabel;

  /// The label for "upload a file"
  String get uploadAFileLabel;

  /// The error shown when something went wrong
  String get somethingWentWrongError;

  /// The label for "OK"
  String get okLabel;

  /// The label for "add more files"
  String get addMoreFilesLabel;

  /// The message shown for asking photo and video access permission
  String get enablePhotoAndVideoAccessMessage;

  /// The message shown for asking gallery access permission
  String get allowGalleryAccessMessage;

  /// The label for "flag message"
  String get flagMessageLabel;

  /// The question asked while showing flag message dialog
  String get flagMessageQuestion;

  /// The label for "Flag"
  String get flagLabel;

  /// The label for "Cancel"
  String get cancelLabel;

  /// The label for successful message flag
  String get flagMessageSuccessfulLabel;

  /// The text for showing the message if successfully flagged
  String get flagMessageSuccessfulText;

  /// The label for "delete message"
  String get deleteMessageLabel;

  /// The question asked while showing delete message dialog
  String get deleteMessageQuestion;

  /// The label for "Delete"
  String get deleteLabel;

  /// The text for showing the operation could not be completed
  String get operationCouldNotBeCompletedText;

  /// The label for "Reply"
  String get replyLabel;

  /// The text for showing pin/un-pin functionality in [MessageWidget]
  /// based on [pinned]
  String togglePinUnpinText({required bool pinned});

  /// The text for showing delete/retry-delete based on [isDeleteFailed]
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed});

  /// The label for "copy message"
  String get copyMessageLabel;

  /// The label for "edit message"
  String get editMessageLabel;

  /// The text for showing resend/resend-edited message
  /// based on [isUpdateFailed]
  String toggleResendOrResendEditedMessage({required bool isUpdateFailed});

  /// The label for "Photos"
  String get photosLabel;

  /// The text for showing on which [date] and [time] the message was sent
  String sentAtText({required DateTime date, required DateTime time});

  /// The label for "Today"
  String get todayLabel;

  /// The label for "Yesterday"
  String get yesterdayLabel;

  /// The text for showing the channel is muted
  String get channelIsMutedText;

  /// The text for showing there is no title
  String get noTitleText;

  /// The label for "let's start chatting"
  String get letsStartChattingLabel;

  /// The label for sending the first message
  String get sendingFirstMessageLabel;

  /// The label for "start a chat"
  String get startAChatLabel;

  /// The error shown when loading channel fails
  String get loadingChannelsError;

  /// The label for "Delete conversation"
  String get deleteConversationLabel;

  /// The question asked while showing delete conversation dialog
  String get deleteConversationQuestion;

  /// The label for "Stream Chat"
  String get streamChatLabel;

  /// The text for showing searching for network
  String get searchingForNetworkText;

  /// The label for "Offline"
  String get offlineLabel;

  /// The label for "Try again"
  String get tryAgainLabel;

  /// The text for showing the members count based on [count]
  String membersCountText(int count);

  /// The text for showing the watchers count based on [count]
  String watchersCountText(int count);

  /// The label for "View Info"
  String get viewInfoLabel;

  /// The label for "Leave Group"
  String get leaveGroupLabel;

  /// The label for "Leave"
  String get leaveLabel;

  /// The label for "Leave conversation"
  String get leaveConversationLabel;

  /// The question asked while showing leave conversation dialog
  String get leaveConversationQuestion;

  /// The label for "Show in chat"
  String get showInChatLabel;

  /// The label for "Save Image"
  String get saveImageLabel;

  /// The label for "Save Video"
  String get saveVideoLabel;

  /// The label for "Upload Error"
  String get uploadErrorLabel;

  /// The label for "Giphy"
  String get giphyLabel;

  /// The label for "Shuffle"
  String get shuffleLabel;

  /// The label for "Send"
  String get sendLabel;

  /// The label for "With"
  String get withText;

  /// The text shown for "In"
  String get inText;

  /// The text shown for "You"
  String get youText;

  /// Gallery footer pagination text
  String galleryPaginationText(
      {required int currentPage, required int totalPages});

  /// The text shown for "File"
  String get fileText;

  /// The label for "Reply to message"
  String get replyToMessageLabel;
}

/// Default implementation of Translation strings for the stream chat widgets
class DefaultTranslations implements Translations {
  const DefaultTranslations._();

  /// Singleton instance of [DefaultTranslations]
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
  String get somethingWentWrongError => 'Something went wrong';

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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'today';
    } else if (date == yesterday) {
      return 'yesterday';
    } else {
      return 'on ${Jiffy(date).MMMd}';
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
  String galleryPaginationText(
          {required int currentPage, required int totalPages}) =>
      '${currentPage + 1} of $totalPages';

  @override
  String get fileText => 'File';

  @override
  String get replyToMessageLabel => 'Reply to Message';

  @override
  String get slowModeOnLabel => 'Slow mode ON';
}
