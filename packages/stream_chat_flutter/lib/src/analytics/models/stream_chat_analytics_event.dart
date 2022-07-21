import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_chat_flutter/src/analytics/enums/analytics_enums.dart';

part 'stream_chat_analytics_event.freezed.dart';

part 'stream_chat_analytics_event.g.dart';

@freezed

/// A union class that defines all the analytics events triggered
/// by Stream Chat SDK
class StreamChatAnalyticsEvent with _$StreamChatAnalyticsEvent {
  /// This event is triggered when StreamChannelListView
  /// loads for the first time
  const factory StreamChatAnalyticsEvent.channelListView() =
      StreamChannelListViewEventModel;

  /// This event is triggered when a user clicks on a specific channel tile
  /// in the StreamChannelListView
  const factory StreamChatAnalyticsEvent.channelListTileClick({
    /// The id of the channel that was clicked
    required String channelId,

    /// The number of unread messages at the moment
    required int unreadMessageCount,
  }) = StreamChannelListTileClickEventModel;

  /// This event is triggered when a user clicks on the avatar in a specific
  /// channel tile in StreamChannelListView
  const factory StreamChatAnalyticsEvent.channelListTileAvatarClick({
    /// The id of the channel that was clicked
    required String channelId,

    /// The number of unread messages at the moment
    required int unreadMessageCount,
  }) = StreamChannelListTileAvatarClickEventModel;

  /// This event is triggered when StreamMessageInput is brought into focus
  const factory StreamChatAnalyticsEvent.messageInputFocus() =
      StreamMessageInputFocusEventModel;

  /// This event is triggered when a user starts typing in
  /// StreamMessageInput first time after it is brought into focus
  const factory StreamChatAnalyticsEvent.messageInputTypingStarted() =
      StreamMessageInputTypingStartedEventModel;

  /// This event is triggered when the send button
  /// is clicked in StreamMessageInput
  const factory StreamChatAnalyticsEvent.messageInputSendButtonClick({
    /// Does the message being sent have text?
    required bool hasText,

    /// Does the message being sent have attachments?
    required bool hasAttachments,

    /// Does the message being sent have user mentions?
    required bool hasMentions,

    /// Does the message being sent have custom commands?
    required bool hasCustomCommands,
  }) = StreamMessageInputSendButtonClickEventModel;

  /// This event is triggered when the attachment button is clicked in
  /// StreamMessageInput
  const factory StreamChatAnalyticsEvent.messageInputAttachmentButtonClick() =
      StreamMessageInputAttachmentButtonClickEventModel;

  /// This event is triggered when the coammand button is clicked in
  /// StreamMessageInput
  const factory StreamChatAnalyticsEvent.messageInputCommandButtonClick() =
      StreamMessageInputCommandButtonClickEventModel;

  /// This event is triggered when a specific attachment action is clicked in
  /// StreamMessageInput
  const factory StreamChatAnalyticsEvent.messageInputAttachmentActionClick({
    required StreamMessageInputAttachmentActionType targetActionType,
  }) = StreamMessageInputAttachmentActionClickEventModel;

  /// This event is triggered the back button is pressed on a channel header
  const factory StreamChatAnalyticsEvent.channelHeaderBackButtonClick({
    /// id of the channel on which back button was pressed
    required String channelId,

    /// the number of unread messages visible on the back button when
    /// it was pressed
    required int unreadMessageCount,
  }) = StreamChannelHeaderBackButtonClickEventModel;

  /// This event is triggered the avatar is pressed on a channel header
  const factory StreamChatAnalyticsEvent.channelHeaderAvatarClick({
    /// id of the channel
    required String channelId,
  }) = StreamChannelHeaderAvatarClickEventModel;

  /// This event is triggered the first time a message list is loaded
  const factory StreamChatAnalyticsEvent.messageListView({
    /// id of the channel
    required String channelId,
  }) = StreamMessageListViewEventModel;

  /// This event is triggered when the scrollToBottom button is clicked
  /// in the message listview
  const factory StreamChatAnalyticsEvent.messageListScrollToBottomClick({
    /// id of the channel
    required String channelId,
  }) = StreamMessageListScrollToBottomClickEventModel;

  /// This event is triggered when a user mention is clicked
  const factory StreamChatAnalyticsEvent.messageMentionClick({
    /// id of the channel
    required String channelId,

    /// id of the message
    required String messageId,

    /// id of the mentioned user
    required String mentionedUserId,

    /// id of the message to which this message is a direct reply
    String? quotedMessageId,

    /// id of the parent message in this thread
    String? parentMessageId,
  }) = StreamMessageMentionClickEventModel;

  /// This event is triggered when a URL in a message is clicked
  const factory StreamChatAnalyticsEvent.messageUrlClick({
    /// id of the channel
    required String channelId,

    /// id of the message
    required String messageId,

    /// id of the message to which this message is a direct reply
    String? quotedMessageId,

    /// id of the parent message in this thread
    String? parentMessageId,
  }) = StreamMessageUrlClickEventModel;

  /// This event is triggered when the actions that can be taken on a message
  /// are accessed
  const factory StreamChatAnalyticsEvent.messageActionsTrigger({
    /// id of the channel
    required String channelId,

    /// id of the message
    required String messageId,

    /// id of the message to which this message is a direct reply
    String? quotedMessageId,

    /// id of the parent message in this thread
    String? parentMessageId,
  }) = StreamMessageActionsTriggerEventModel;

  /// This event is triggered when a reaction is selected for a message
  const factory StreamChatAnalyticsEvent.messageReactionClick({
    /// id of the channel
    required String channelId,

    /// id of the message
    required String messageId,

    /// id of the message to which this message is a direct reply
    String? quotedMessageId,

    /// id of the parent message in this thread
    String? parentMessageId,

    /// the type of reaction that was selected
    required String reactionType,
  }) = StreamMessageReactionClickEventModel;

  /// This event is triggered when a specific type of action
  /// is selected for a message
  const factory StreamChatAnalyticsEvent.messageActionClick({
    /// id of the channel
    required String channelId,

    /// id of the message
    required String messageId,

    /// id of the message to which this message is a direct reply
    String? quotedMessageId,

    /// id of the parent message in this thread
    String? parentMessageId,

    /// the type of action that was selected
    required StreamMessageActionType actionType,
  }) = StreamMessageActionClickEventModel;

  /// This event is triggered when an attachment in a message is clicked
  const factory StreamChatAnalyticsEvent.messageAttachmentClick({
    /// id of the channel
    required String channelId,

    /// id of the message
    required String messageId,

    /// id of the message to which this message is a direct reply
    String? quotedMessageId,

    /// id of the parent message in this thread
    String? parentMessageId,

    /// the id of the attachment
    required String attachmentId,

    /// the type of the attachment
    required String attachmentType,
  }) = StreamMessageAttachmentClickEventModel;

  /// This event is triggered when an attachment is opened in full screen
  const factory StreamChatAnalyticsEvent.attachmentFullScreenView({
    /// id of the channel
    required String channelId,

    /// id of the message
    required String messageId,

    /// the id of the attachment
    required String attachmentId,

    /// the type of the attachment
    required String attachmentType,
  }) = StreamAttachmentFullScreenViewEventModel;

  /// This event is triggered when an attachment is opened in full screen
  /// and the share button is clicked
  const factory StreamChatAnalyticsEvent.attachmentFullScreenShareButtonClick({
    /// id of the channel
    required String channelId,

    /// id of the message
    required String messageId,

    /// the id of the attachment
    required String attachmentId,

    /// the type of the attachment
    required String attachmentType,
  }) = StreamAttachmentFullScreenShareButtonClickEventModel;

  /// This event is triggered when an attachment is opened in full screen
  /// and the grid button is clicked
  const factory StreamChatAnalyticsEvent.attachmentFullScreenGridButtonClick({
    /// id of the channel
    required String channelId,

    /// id of the message
    required String messageId,

    /// the id of the attachment
    required String attachmentId,

    /// the type of the attachment
    required String attachmentType,
  }) = StreamAttachmentFullScreenGridButtonClickEventModel;

  /// This event is triggered when an attachment is opened in full screen
  /// and the close button is clicked
  const factory StreamChatAnalyticsEvent.attachmentFullScreenCloseButtonClick({
    /// id of the channel
    required String channelId,

    /// id of the message
    required String messageId,

    /// the id of the attachment
    required String attachmentId,

    /// the type of the attachment
    required String attachmentType,
  }) = StreamAttachmentFullScreenCloseButtonClickEventModel;

  /// This event is triggered when an attachment is opened in full screen
  /// and the actions menu is clicked
  const factory StreamChatAnalyticsEvent.attachmentFullScreenActionsMenuClick({
    /// id of the channel
    required String channelId,

    /// id of the message
    required String messageId,

    /// the id of the attachment
    required String attachmentId,

    /// the type of the attachment
    required String attachmentType,
  }) = StreamAttachmentFullScreenActionsMenuClickEventModel;

  /// This event is triggered when an attachment is opened in full screen
  /// and an action menu item is clicked
  const factory StreamChatAnalyticsEvent.attachmentFullScreenActionItemClick({
    /// id of the channel
    required String channelId,

    /// id of the message
    required String messageId,

    /// the id of the attachment
    required String attachmentId,

    /// the type of the attachment
    required String attachmentType,

    /// the type of action that was selected
    required StreamAttachmentFullScreenActionType actionType,
  }) = StreamAttachmentFullScreenActionItemClickEventModel;

  /// Create an instance of [StreamChatAnalyticsEvent] from a map
  factory StreamChatAnalyticsEvent.fromJson(Map<String, dynamic> json) =>
      _$StreamChatAnalyticsEventFromJson(json);
}
