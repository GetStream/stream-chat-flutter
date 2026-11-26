import '../../core/models/events/chat_event.dart';
import '../../core/models/events/location_events.dart';
import '../../core/models/events/message_events.dart';
import '../../core/models/events/notification_events.dart';
import '../../core/models/events/poll_events.dart';
import '../../core/models/location.dart';

/// Resolves casted or changed poll votes that are answers into
/// [PollAnswerCastedEvent]s for easier downstream state handling.
///
/// Returns `null` when [event] is not a casted or changed answer.
ChatEvent? pollAnswerCastedResolver(ChatEvent event) => switch (event) {
  PollVoteCastedEvent(:final cid, :final messageId, :final poll, :final pollVote, :final createdAt, :final custom)
      when pollVote.isAnswer == true =>
    PollAnswerCastedEvent(
      cid: cid,
      messageId: messageId,
      poll: poll,
      pollVote: pollVote,
      createdAt: createdAt,
      custom: custom,
      isLocal: event.isLocal,
    ),
  PollVoteChangedEvent(:final cid, :final messageId, :final poll, :final pollVote, :final createdAt, :final custom)
      when pollVote.isAnswer == true =>
    PollAnswerCastedEvent(
      cid: cid,
      messageId: messageId,
      poll: poll,
      pollVote: pollVote,
      createdAt: createdAt,
      custom: custom,
      isLocal: event.isLocal,
    ),
  _ => null,
};

/// Resolves removed poll votes that are answers into
/// [PollAnswerRemovedEvent]s for easier downstream state handling.
///
/// Returns `null` when [event] is not a removed answer.
ChatEvent? pollAnswerRemovedResolver(ChatEvent event) => switch (event) {
  PollVoteRemovedEvent(:final cid, :final messageId, :final poll, :final pollVote, :final createdAt, :final custom)
      when pollVote.isAnswer == true =>
    PollAnswerRemovedEvent(
      cid: cid,
      messageId: messageId,
      poll: poll,
      pollVote: pollVote,
      createdAt: createdAt,
      custom: custom,
      isLocal: event.isLocal,
    ),
  _ => null,
};

/// Resolves new messages sharing a location into [LocationSharedEvent]s for
/// easier downstream state handling.
///
/// Returns `null` when [event] is not a new message sharing a location.
ChatEvent? locationSharedResolver(ChatEvent event) => switch (event) {
  MessageNewEvent(:final message) when message.sharedLocation != null => LocationSharedEvent(
    cid: event.cid,
    channelId: event.channelId,
    channelType: event.channelType,
    channelMemberCount: event.channelMemberCount,
    channelMessageCount: event.channelMessageCount,
    channel: event.channel,
    message: message,
    user: event.user,
    totalUnreadCount: event.totalUnreadCount,
    unreadChannels: event.unreadChannels,
    createdAt: event.createdAt,
    custom: event.custom,
    isLocal: event.isLocal,
  ),
  NotificationMessageNewEvent(:final message) when message.sharedLocation != null => LocationSharedEvent(
    cid: event.cid,
    channelId: event.channelId,
    channelType: event.channelType,
    channelMemberCount: event.channelMemberCount,
    channelMessageCount: event.channelMessageCount,
    channel: event.channel,
    message: message,
    totalUnreadCount: event.totalUnreadCount,
    unreadChannels: event.unreadChannels,
    createdAt: event.createdAt,
    custom: event.custom,
    isLocal: event.isLocal,
  ),
  _ => null,
};

/// Resolves edits of a message sharing a static or still-active location into
/// [LocationUpdatedEvent]s for easier downstream state handling.
///
/// Returns `null` when [event] is not such an edit.
ChatEvent? locationUpdatedResolver(ChatEvent event) => switch (event) {
  MessageUpdatedEvent(:final message) when _isActive(message.sharedLocation) => LocationUpdatedEvent(
    cid: event.cid,
    channelId: event.channelId,
    channelType: event.channelType,
    channelMemberCount: event.channelMemberCount,
    channelMessageCount: event.channelMessageCount,
    message: message,
    user: event.user,
    createdAt: event.createdAt,
    custom: event.custom,
    isLocal: event.isLocal,
  ),
  _ => null,
};

/// Resolves edits of a message sharing an expired live location into
/// [LocationExpiredEvent]s for easier downstream state handling.
///
/// Returns `null` when [event] is not such an edit.
ChatEvent? locationExpiredResolver(ChatEvent event) => switch (event) {
  MessageUpdatedEvent(:final message) when _isExpired(message.sharedLocation) => LocationExpiredEvent(
    cid: event.cid,
    channelId: event.channelId,
    channelType: event.channelType,
    channelMemberCount: event.channelMemberCount,
    channelMessageCount: event.channelMessageCount,
    message: message,
    user: event.user,
    createdAt: event.createdAt,
    custom: event.custom,
    isLocal: event.isLocal,
  ),
  _ => null,
};

// Whether [location] is static, or live and not expired yet.
bool _isActive(Location? location) {
  if (location == null) return false;
  return !(location.isLive && location.isExpired);
}

// Whether [location] is live and has expired.
bool _isExpired(Location? location) {
  if (location == null) return false;
  return !(location.isStatic || location.isActive);
}
