import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../stream_chat.dart';

part 'channel_events.freezed.dart';

/// An event sent when a channel is updated.
@freezed
final class ChannelUpdatedEvent extends ChatEvent
    with HasCid, HasUser, HasChannel, HasMessage, HasChannelCounts, _$ChannelUpdatedEvent {
  /// Creates a [ChannelUpdatedEvent].
  ChannelUpdatedEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.channel,
    this.user,
    this.message,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.channelUpdated;

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
  final User? user;

  @override
  final Message? message;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a channel the current user is watching is deleted.
@freezed
final class ChannelDeletedEvent extends ChatEvent
    with HasCid, HasUser, HasChannel, HasChannelCounts, _$ChannelDeletedEvent {
  /// Creates a [ChannelDeletedEvent].
  ChannelDeletedEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.channel,
    this.user,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.channelDeleted;

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
  final User? user;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a channel the current user is watching is truncated.
@freezed
final class ChannelTruncatedEvent extends ChatEvent
    with HasCid, HasUser, HasChannel, HasMessage, HasChannelCounts, _$ChannelTruncatedEvent {
  /// Creates a [ChannelTruncatedEvent].
  ChannelTruncatedEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.channel,
    this.user,
    this.message,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.channelTruncated;

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
  final User? user;

  @override
  final Message? message;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when the current user hides a channel.
@freezed
final class ChannelHiddenEvent extends ChatEvent
    with HasCid, HasUser, HasChannel, HasChannelCounts, _$ChannelHiddenEvent {
  /// Creates a [ChannelHiddenEvent].
  ChannelHiddenEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.channel,
    this.user,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.channelHidden;

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
  final User? user;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a channel the current user hid is shown again.
@freezed
final class ChannelVisibleEvent extends ChatEvent
    with HasCid, HasUser, HasChannel, HasChannelCounts, _$ChannelVisibleEvent {
  /// Creates a [ChannelVisibleEvent].
  ChannelVisibleEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.channel,
    this.user,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.channelVisible;

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
  final User? user;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}
