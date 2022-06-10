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

  /// Create an instance of [StreamChatAnalyticsEvent] from a map
  factory StreamChatAnalyticsEvent.fromJson(Map<String, dynamic> json) =>
      _$StreamChatAnalyticsEventFromJson(json);
}
