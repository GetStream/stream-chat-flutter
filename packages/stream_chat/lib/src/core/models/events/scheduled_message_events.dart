import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../stream_chat.dart';

part 'scheduled_message_events.freezed.dart';

/// An event sent when the current user schedules a message.
@freezed
final class ScheduledMessageCreatedEvent extends ChatEvent with HasCid, HasUser, _$ScheduledMessageCreatedEvent {
  /// Creates a [ScheduledMessageCreatedEvent].
  ScheduledMessageCreatedEvent({
    this.cid,
    this.scheduledMessage,
    required this.user,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.scheduledMessageCreated;

  @override
  final String? cid;

  /// The scheduled message the event concerns.
  @override
  final ScheduledMessage? scheduledMessage;

  @override
  final User user;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when the current user changes a scheduled message.
@freezed
final class ScheduledMessageUpdatedEvent extends ChatEvent with HasCid, HasUser, _$ScheduledMessageUpdatedEvent {
  /// Creates a [ScheduledMessageUpdatedEvent].
  ScheduledMessageUpdatedEvent({
    this.cid,
    this.scheduledMessage,
    required this.user,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.scheduledMessageUpdated;

  @override
  final String? cid;

  /// The scheduled message the event concerns.
  @override
  final ScheduledMessage? scheduledMessage;

  @override
  final User user;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when the current user cancels a scheduled message.
@freezed
final class ScheduledMessageDeletedEvent extends ChatEvent with HasCid, HasUser, _$ScheduledMessageDeletedEvent {
  /// Creates a [ScheduledMessageDeletedEvent].
  ScheduledMessageDeletedEvent({
    this.cid,
    this.scheduledMessage,
    required this.user,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.scheduledMessageDeleted;

  @override
  final String? cid;

  /// The scheduled message the event concerns.
  @override
  final ScheduledMessage? scheduledMessage;

  @override
  final User user;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a scheduled message could not be sent.
@freezed
final class ScheduledMessageFailedEvent extends ChatEvent with HasCid, HasUser, _$ScheduledMessageFailedEvent {
  /// Creates a [ScheduledMessageFailedEvent].
  ScheduledMessageFailedEvent({
    this.cid,
    this.scheduledMessage,
    required this.user,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.scheduledMessageFailed;

  @override
  final String? cid;

  /// The scheduled message the event concerns.
  @override
  final ScheduledMessage? scheduledMessage;

  @override
  final User user;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a scheduled message is sent.
@freezed
final class ScheduledMessageSentEvent extends ChatEvent with HasCid, HasUser, _$ScheduledMessageSentEvent {
  /// Creates a [ScheduledMessageSentEvent].
  ScheduledMessageSentEvent({
    this.cid,
    this.scheduledMessage,
    required this.user,
    this.messageId,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.scheduledMessageSent;

  @override
  final String? cid;

  /// The scheduled message the event concerns.
  @override
  final ScheduledMessage? scheduledMessage;

  @override
  final User user;

  /// The id of the message that was sent, when it is known.
  @override
  final String? messageId;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}
