import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../stream_chat.dart';

part 'location_events.freezed.dart';

/// An event sent when a message sharing a location is added to a channel.
@freezed
final class LocationSharedEvent extends ChatEvent
    with HasCid, HasUser, HasChannel, HasMessage, HasUnreadCounts, HasChannelCounts, _$LocationSharedEvent {
  /// Creates a [LocationSharedEvent].
  LocationSharedEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    this.channel,
    required this.message,
    this.user,
    this.totalUnreadCount,
    this.unreadChannels,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.locationShared;

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

/// An event sent when a message sharing a static or still-active location is
/// edited, including each move of a live location.
@freezed
final class LocationUpdatedEvent extends ChatEvent
    with HasCid, HasUser, HasMessage, HasChannelCounts, _$LocationUpdatedEvent {
  /// Creates a [LocationUpdatedEvent].
  LocationUpdatedEvent({
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
  String get type => EventType.locationUpdated;

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

/// An event sent when a shared live location stops being updated.
@freezed
final class LocationExpiredEvent extends ChatEvent
    with HasCid, HasUser, HasMessage, HasChannelCounts, _$LocationExpiredEvent {
  /// Creates a [LocationExpiredEvent].
  LocationExpiredEvent({
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
  String get type => EventType.locationExpired;

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
