import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../stream_chat.dart';

part 'member_events.freezed.dart';

/// An event sent when a member is added to a channel.
@freezed
final class MemberAddedEvent extends ChatEvent with HasCid, HasUser, HasChannel, HasChannelCounts, _$MemberAddedEvent {
  /// Creates a [MemberAddedEvent].
  MemberAddedEvent({
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
  String get type => EventType.memberAdded;

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

/// An event sent when a member is removed from a channel.
@freezed
final class MemberRemovedEvent extends ChatEvent
    with HasCid, HasUser, HasChannel, HasChannelCounts, _$MemberRemovedEvent {
  /// Creates a [MemberRemovedEvent].
  MemberRemovedEvent({
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
  String get type => EventType.memberRemoved;

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

/// An event sent when a channel member is updated.
@freezed
final class MemberUpdatedEvent extends ChatEvent
    with HasCid, HasUser, HasChannel, HasChannelCounts, _$MemberUpdatedEvent {
  /// Creates a [MemberUpdatedEvent].
  MemberUpdatedEvent({
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
  String get type => EventType.memberUpdated;

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
