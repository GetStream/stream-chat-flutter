import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../stream_chat.dart';

part 'typing_events.freezed.dart';

/// An event sent when a user starts typing.
@freezed
final class TypingStartEvent extends ChatEvent with HasCid, HasUser, _$TypingStartEvent {
  /// Creates a [TypingStartEvent].
  TypingStartEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.user,
    this.parentId,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.typingStart;

  @override
  final String? cid;

  /// The id of the channel the event belongs to, without its type.
  @override
  final String? channelId;

  /// The type of the channel the event belongs to, such as `messaging`.
  @override
  final String? channelType;

  @override
  final User? user;

  /// The id of the thread's parent message, when the user is typing in a
  /// thread.
  @override
  final String? parentId;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a user stops typing.
@freezed
final class TypingStopEvent extends ChatEvent with HasCid, HasUser, _$TypingStopEvent {
  /// Creates a [TypingStopEvent].
  TypingStopEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.user,
    this.parentId,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.typingStop;

  @override
  final String? cid;

  /// The id of the channel the event belongs to, without its type.
  @override
  final String? channelId;

  /// The type of the channel the event belongs to, such as `messaging`.
  @override
  final String? channelType;

  @override
  final User? user;

  /// The id of the thread's parent message, when the user is typing in a
  /// thread.
  @override
  final String? parentId;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}
