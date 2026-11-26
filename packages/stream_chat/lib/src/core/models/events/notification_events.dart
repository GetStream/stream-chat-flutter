import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../stream_chat.dart';

part 'notification_events.freezed.dart';

/// An event sent when the current user is added to a channel.
@freezed
final class NotificationAddedToChannelEvent extends ChatEvent
    with HasCid, HasChannel, HasUnreadCounts, HasChannelCounts, _$NotificationAddedToChannelEvent {
  /// Creates a [NotificationAddedToChannelEvent].
  NotificationAddedToChannelEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.channel,
    required this.member,
    this.totalUnreadCount,
    this.unreadChannels,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.notificationAddedToChannel;

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
  final ChannelModel channel;

  /// The channel membership the event concerns.
  @override
  final Member member;

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

/// An event sent when the current user is removed from a channel.
@freezed
final class NotificationRemovedFromChannelEvent extends ChatEvent
    with HasCid, HasUser, HasChannel, HasChannelCounts, _$NotificationRemovedFromChannelEvent {
  /// Creates a [NotificationRemovedFromChannelEvent].
  NotificationRemovedFromChannelEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.channel,
    required this.member,
    this.user,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.notificationRemovedFromChannel;

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
  final ChannelModel channel;

  /// The channel membership the event concerns.
  @override
  final Member member;

  @override
  final User? user;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when the current user is invited to a channel.
@freezed
final class NotificationInvitedEvent extends ChatEvent
    with HasCid, HasUser, HasChannel, HasChannelCounts, _$NotificationInvitedEvent {
  /// Creates a [NotificationInvitedEvent].
  NotificationInvitedEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.channel,
    required this.member,
    this.user,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.notificationInvited;

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
  final ChannelModel channel;

  /// The channel membership the event concerns.
  @override
  final Member member;

  @override
  final User? user;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when an invitation to a channel is accepted.
@freezed
final class NotificationInviteAcceptedEvent extends ChatEvent
    with HasCid, HasUser, HasChannel, HasChannelCounts, _$NotificationInviteAcceptedEvent {
  /// Creates a [NotificationInviteAcceptedEvent].
  NotificationInviteAcceptedEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.channel,
    required this.member,
    this.user,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.notificationInviteAccepted;

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
  final ChannelModel channel;

  /// The channel membership the event concerns.
  @override
  final Member member;

  @override
  final User? user;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a channel the current user is a member of is deleted.
@freezed
final class NotificationChannelDeletedEvent extends ChatEvent
    with HasCid, HasChannel, HasUnreadCounts, HasChannelCounts, _$NotificationChannelDeletedEvent {
  /// Creates a [NotificationChannelDeletedEvent].
  NotificationChannelDeletedEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.channel,
    this.totalUnreadCount,
    this.unreadChannels,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.notificationChannelDeleted;

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
  final ChannelModel channel;

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

/// An event sent when a channel the current user is a member of is truncated.
@freezed
final class NotificationChannelTruncatedEvent extends ChatEvent
    with HasCid, HasChannel, HasMessage, HasUnreadCounts, HasChannelCounts, _$NotificationChannelTruncatedEvent {
  /// Creates a [NotificationChannelTruncatedEvent].
  NotificationChannelTruncatedEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.channel,
    this.message,
    this.totalUnreadCount,
    this.unreadChannels,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.notificationChannelTruncated;

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
  final ChannelModel channel;

  @override
  final Message? message;

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

/// An event sent when the current user mutes or unmutes another user.
@freezed
final class NotificationMutesUpdatedEvent extends ChatEvent with HasOwnUser, _$NotificationMutesUpdatedEvent {
  /// Creates a [NotificationMutesUpdatedEvent].
  NotificationMutesUpdatedEvent({
    required this.me,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.notificationMutesUpdated;

  @override
  final OwnUser me;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when the current user mutes or unmutes a channel.
@freezed
final class NotificationChannelMutesUpdatedEvent extends ChatEvent
    with HasOwnUser, _$NotificationChannelMutesUpdatedEvent {
  /// Creates a [NotificationChannelMutesUpdatedEvent].
  NotificationChannelMutesUpdatedEvent({
    required this.me,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.notificationChannelMutesUpdated;

  @override
  final OwnUser me;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when the current user reads a channel, a thread or all
/// channels.
///
/// Carries no [cid] when every channel was marked read.
@freezed
final class NotificationMarkReadEvent extends ChatEvent
    with
        HasCid,
        HasUser,
        HasChannel,
        HasUnreadCounts,
        HasUnreadThreadCount,
        HasChannelCounts,
        _$NotificationMarkReadEvent {
  /// Creates a [NotificationMarkReadEvent].
  NotificationMarkReadEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    this.channel,
    this.user,
    this.lastReadMessageId,
    this.thread,
    required this.totalUnreadCount,
    required this.unreadChannels,
    this.unreadThreadMessages,
    this.unreadThreads,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.notificationMarkRead;

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

  /// The thread that was read, when a thread rather than the channel was read.
  @override
  final Thread? thread;

  @override
  final int totalUnreadCount;

  @override
  final int unreadChannels;

  /// The number of unread replies across the current user's threads after the
  /// event.
  @override
  final int? unreadThreadMessages;

  @override
  final int? unreadThreads;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when the current user marks a channel or a thread unread.
@freezed
final class NotificationMarkUnreadEvent extends ChatEvent
    with
        HasCid,
        HasUser,
        HasChannel,
        HasUnreadCounts,
        HasUnreadThreadCount,
        HasChannelCounts,
        _$NotificationMarkUnreadEvent {
  /// Creates a [NotificationMarkUnreadEvent].
  NotificationMarkUnreadEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    this.channel,
    this.user,
    this.threadId,
    this.lastReadAt,
    this.lastReadMessageId,
    this.totalUnreadCount,
    this.unreadChannels,
    this.unreadMessages,
    this.unreadThreadMessages,
    this.unreadThreads,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.notificationMarkUnread;

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

  /// The id of the thread's parent message, when a thread rather than the
  /// channel was marked unread.
  @override
  final String? threadId;

  /// When the user last read the channel, as it is after the event.
  @override
  final DateTime? lastReadAt;

  /// The id of the last message the user has read, when known.
  @override
  final String? lastReadMessageId;

  @override
  final int? totalUnreadCount;

  @override
  final int? unreadChannels;

  /// The number of messages the user has unread in the channel after the event.
  @override
  final int? unreadMessages;

  /// The number of unread replies across the current user's threads after the
  /// event.
  @override
  final int? unreadThreadMessages;

  @override
  final int? unreadThreads;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a message is added to a channel the current user is a
/// member of but not watching.
///
/// A message sharing a location arrives as a [LocationSharedEvent] instead.
@freezed
final class NotificationMessageNewEvent extends ChatEvent
    with HasCid, HasChannel, HasMessage, HasUnreadCounts, HasChannelCounts, _$NotificationMessageNewEvent {
  /// Creates a [NotificationMessageNewEvent].
  NotificationMessageNewEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.channel,
    required this.message,
    required this.watcherCount,
    this.totalUnreadCount,
    this.unreadChannels,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.notificationMessageNew;

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
  final ChannelModel channel;

  @override
  final Message message;

  /// The number of users watching the channel, which is not reliable for this
  /// event and usually 0.
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

/// An event sent when a reply is added to a thread the current user takes part
/// in.
@freezed
final class NotificationThreadMessageNewEvent extends ChatEvent
    with HasCid, HasChannel, HasMessage, HasUnreadThreadCount, HasChannelCounts, _$NotificationThreadMessageNewEvent {
  /// Creates a [NotificationThreadMessageNewEvent].
  NotificationThreadMessageNewEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.channel,
    required this.message,
    required this.watcherCount,
    this.unreadThreadMessages,
    this.unreadThreads,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.notificationThreadMessageNew;

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
  final ChannelModel channel;

  @override
  final Message message;

  /// The number of users watching the channel after the event.
  @override
  final int watcherCount;

  /// The number of unread replies across the current user's threads after the
  /// event.
  @override
  final int? unreadThreadMessages;

  @override
  final int? unreadThreads;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a reminder the current user set is due.
@freezed
final class NotificationReminderDueEvent extends ChatEvent with HasCid, _$NotificationReminderDueEvent {
  /// Creates a [NotificationReminderDueEvent].
  NotificationReminderDueEvent({
    required this.cid,
    required this.messageId,
    this.parentId,
    required this.reminder,
    required this.userId,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.notificationReminderDue;

  @override
  final String cid;

  /// The id of the message the reminder is set on.
  @override
  final String messageId;

  /// The id of the thread's parent message, when the message is a thread reply.
  @override
  final String? parentId;

  /// The reminder the event concerns.
  @override
  final MessageReminder reminder;

  /// The id of the user the reminder belongs to.
  @override
  final String userId;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}
