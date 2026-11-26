import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../stream_chat.dart';

part 'user_events.freezed.dart';

/// An event sent when a user is updated.
@freezed
final class UserUpdatedEvent extends ChatEvent with HasUser, _$UserUpdatedEvent {
  /// Creates a [UserUpdatedEvent].
  UserUpdatedEvent({
    required this.user,
    this.privacySettings,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.userUpdated;

  @override
  final User user;

  /// The user's privacy settings, when the event carries them.
  @override
  final PrivacySettings? privacySettings;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a user comes online or goes offline.
@freezed
final class UserPresenceChangedEvent extends ChatEvent with HasUser, _$UserPresenceChangedEvent {
  /// Creates a [UserPresenceChangedEvent].
  UserPresenceChangedEvent({
    required this.user,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.userPresenceChanged;

  @override
  final User user;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a user starts watching a channel.
@freezed
final class UserWatchingStartEvent extends ChatEvent with HasCid, HasUser, _$UserWatchingStartEvent {
  /// Creates a [UserWatchingStartEvent].
  UserWatchingStartEvent({
    this.cid,
    this.channelId,
    this.channelType,
    required this.user,
    required this.watcherCount,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.userWatchingStart;

  @override
  final String? cid;

  /// The id of the channel the event belongs to, without its type.
  @override
  final String? channelId;

  /// The type of the channel the event belongs to, such as `messaging`.
  @override
  final String? channelType;

  @override
  final User user;

  /// The number of users watching the channel after the event.
  @override
  final int watcherCount;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a user stops watching a channel.
@freezed
final class UserWatchingStopEvent extends ChatEvent with HasCid, HasUser, _$UserWatchingStopEvent {
  /// Creates a [UserWatchingStopEvent].
  UserWatchingStopEvent({
    this.cid,
    this.channelId,
    this.channelType,
    required this.user,
    required this.watcherCount,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.userWatchingStop;

  @override
  final String? cid;

  /// The id of the channel the event belongs to, without its type.
  @override
  final String? channelId;

  /// The type of the channel the event belongs to, such as `messaging`.
  @override
  final String? channelType;

  @override
  final User user;

  /// The number of users watching the channel after the event.
  @override
  final int watcherCount;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a user is banned.
///
/// Carries no [cid] when the user is banned from the whole app rather than one
/// channel.
@freezed
final class UserBannedEvent extends ChatEvent with HasCid, HasUser, HasChannelCounts, _$UserBannedEvent {
  /// Creates a [UserBannedEvent].
  UserBannedEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.user,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.userBanned;

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
  final User user;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a user is unbanned.
///
/// Carries no [cid] when the user is unbanned from the whole app rather than
/// one channel.
@freezed
final class UserUnbannedEvent extends ChatEvent with HasCid, HasUser, HasChannelCounts, _$UserUnbannedEvent {
  /// Creates a [UserUnbannedEvent].
  UserUnbannedEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.user,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.userUnbanned;

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
  final User user;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when every message of a user is deleted.
///
/// Carries no [cid] when the messages are deleted in every channel.
@freezed
final class UserMessagesDeletedEvent extends ChatEvent
    with HasCid, HasUser, HasChannelCounts, _$UserMessagesDeletedEvent {
  /// Creates a [UserMessagesDeletedEvent].
  UserMessagesDeletedEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.user,
    this.hardDelete,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.userMessagesDeleted;

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
  final User user;

  /// Whether the messages were removed for good rather than marked as deleted.
  @override
  final bool? hardDelete;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}
