import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../stream_chat.dart';

part 'ai_indicator_events.freezed.dart';

/// An event sent when an AI assistant reports what it is doing.
@freezed
final class AIIndicatorUpdateEvent extends ChatEvent with HasCid, HasUser, _$AIIndicatorUpdateEvent {
  /// Creates an [AIIndicatorUpdateEvent].
  AIIndicatorUpdateEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.user,
    required this.aiState,
    this.aiMessage,
    required this.messageId,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.aiIndicatorUpdate;

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

  /// What the AI assistant is doing.
  @override
  final AITypingState aiState;

  /// A message the AI assistant shows with its state, such as what it is
  /// looking up.
  @override
  final String? aiMessage;

  /// The id of the message the AI assistant is working on.
  @override
  final String messageId;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when an AI assistant stops working on its answer.
@freezed
final class AIIndicatorStopEvent extends ChatEvent with HasCid, HasUser, _$AIIndicatorStopEvent {
  /// Creates an [AIIndicatorStopEvent].
  AIIndicatorStopEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.user,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.aiIndicatorStop;

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

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when the state an AI assistant reported is cleared.
@freezed
final class AIIndicatorClearEvent extends ChatEvent with HasCid, HasUser, _$AIIndicatorClearEvent {
  /// Creates an [AIIndicatorClearEvent].
  AIIndicatorClearEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.user,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.aiIndicatorClear;

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

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}
