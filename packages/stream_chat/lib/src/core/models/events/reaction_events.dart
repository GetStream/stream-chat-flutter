import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../stream_chat.dart';

part 'reaction_events.freezed.dart';

/// An event sent when a reaction is added to a message.
@freezed
final class ReactionNewEvent extends ChatEvent
    with HasCid, HasUser, HasChannel, HasMessage, HasChannelCounts, _$ReactionNewEvent {
  /// Creates a [ReactionNewEvent].
  ReactionNewEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.channel,
    this.message,
    this.reaction,
    this.user,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.reactionNew;

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

  /// The reaction the event concerns.
  @override
  final Reaction? reaction;

  @override
  final User? user;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a reaction replaces another one on a message.
@freezed
final class ReactionUpdatedEvent extends ChatEvent
    with HasCid, HasUser, HasChannel, HasMessage, HasChannelCounts, _$ReactionUpdatedEvent {
  /// Creates a [ReactionUpdatedEvent].
  ReactionUpdatedEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.channel,
    required this.message,
    this.reaction,
    this.user,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.reactionUpdated;

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

  /// The reaction the event concerns.
  @override
  final Reaction? reaction;

  @override
  final User? user;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a reaction is removed from a message.
@freezed
final class ReactionDeletedEvent extends ChatEvent
    with HasCid, HasUser, HasChannel, HasMessage, HasChannelCounts, _$ReactionDeletedEvent {
  /// Creates a [ReactionDeletedEvent].
  ReactionDeletedEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.channelMemberCount,
    this.channelMessageCount,
    required this.channel,
    this.message,
    this.reaction,
    this.user,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.reactionDeleted;

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

  /// The reaction the event concerns.
  @override
  final Reaction? reaction;

  @override
  final User? user;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}
