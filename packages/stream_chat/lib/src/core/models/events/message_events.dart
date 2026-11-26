import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../stream_chat.dart';

part 'message_events.freezed.dart';

/// An event sent when a message is added to a channel the current user is
/// watching.
///
/// A message sharing a location arrives as a [LocationSharedEvent] instead.
@freezed
final class MessageNewEvent extends ChatEvent
    with HasCid, HasUser, HasChannel, HasMessage, HasUnreadCounts, HasChannelCounts, _$MessageNewEvent {
  /// Creates a [MessageNewEvent].
  MessageNewEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    this.channel,
    required this.message,
    this.user,
    required this.watcherCount,
    this.totalUnreadCount,
    this.unreadChannels,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.messageNew;

  @override
  final String? cid;

  /// The id of the channel the event belongs to, without its type.
  @override
  final String? channelId;

  /// The type of the channel the event belongs to, such as `messaging`.
  @override
  final String? channelType;

  @override
  final int? channelMemberCount;

  @override
  final int? channelMessageCount;

  @override
  final ChannelModel? channel;

  @override
  final Message message;

  @override
  final User? user;

  /// The number of users watching the channel after the event.
  @override
  final int watcherCount;

  @override
  final int? totalUnreadCount;

  @override
  final int? unreadChannels;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a message is edited.
///
/// An edit of a message sharing a location arrives as a [LocationUpdatedEvent]
/// or [LocationExpiredEvent] instead.
@freezed
final class MessageUpdatedEvent extends ChatEvent
    with HasCid, HasUser, HasMessage, HasChannelCounts, _$MessageUpdatedEvent {
  /// Creates a [MessageUpdatedEvent].
  MessageUpdatedEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.message,
    this.user,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.messageUpdated;

  @override
  final String? cid;

  /// The id of the channel the event belongs to, without its type.
  @override
  final String? channelId;

  /// The type of the channel the event belongs to, such as `messaging`.
  @override
  final String? channelType;

  @override
  final int? channelMemberCount;

  @override
  final int? channelMessageCount;

  @override
  final Message message;

  @override
  final User? user;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a message is deleted.
@freezed
final class MessageDeletedEvent extends ChatEvent
    with HasCid, HasUser, HasMessage, HasChannelCounts, _$MessageDeletedEvent {
  /// Creates a [MessageDeletedEvent].
  MessageDeletedEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.message,
    this.user,
    required this.hardDelete,
    this.deletedForMe,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.messageDeleted;

  @override
  final String? cid;

  /// The id of the channel the event belongs to, without its type.
  @override
  final String? channelId;

  /// The type of the channel the event belongs to, such as `messaging`.
  @override
  final String? channelType;

  @override
  final int? channelMemberCount;

  @override
  final int? channelMessageCount;

  @override
  final Message message;

  @override
  final User? user;

  /// Whether the message was removed for good rather than marked as deleted.
  @override
  final bool hardDelete;

  /// Whether the message was deleted only for the current user.
  @override
  final bool? deletedForMe;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a user reads a channel.
@freezed
final class MessageReadEvent extends ChatEvent with HasCid, HasUser, HasChannel, HasChannelCounts, _$MessageReadEvent {
  /// Creates a [MessageReadEvent].
  MessageReadEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    this.channel,
    this.user,
    this.lastReadMessageId,
    this.thread,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.messageRead;

  @override
  final String? cid;

  /// The id of the channel the event belongs to, without its type.
  @override
  final String? channelId;

  /// The type of the channel the event belongs to, such as `messaging`.
  @override
  final String? channelType;

  @override
  final int? channelMemberCount;

  @override
  final int? channelMessageCount;

  @override
  final ChannelModel? channel;

  @override
  final User? user;

  /// The id of the last message the user has read, when known.
  @override
  final String? lastReadMessageId;

  /// The thread the user read, when they read a thread rather than the channel.
  @override
  final Thread? thread;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when messages in a channel are delivered to a user.
@freezed
final class MessageDeliveredEvent extends ChatEvent
    with HasCid, HasUser, HasChannel, HasChannelCounts, _$MessageDeliveredEvent {
  /// Creates a [MessageDeliveredEvent].
  MessageDeliveredEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    this.channel,
    this.user,
    this.lastDeliveredAt,
    this.lastDeliveredMessageId,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.messageDelivered;

  @override
  final String? cid;

  /// The id of the channel the event belongs to, without its type.
  @override
  final String? channelId;

  /// The type of the channel the event belongs to, such as `messaging`.
  @override
  final String? channelType;

  @override
  final int? channelMemberCount;

  @override
  final int? channelMessageCount;

  @override
  final ChannelModel? channel;

  @override
  final User? user;

  /// When the last message was delivered to the user.
  @override
  final DateTime? lastDeliveredAt;

  /// The id of the last message delivered to the user.
  @override
  final String? lastDeliveredMessageId;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}
