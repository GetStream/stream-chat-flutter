import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../stream_chat.dart';

part 'reminder_events.freezed.dart';

/// An event sent when the current user sets a reminder on a message.
@freezed
final class ReminderCreatedEvent extends ChatEvent with HasCid, _$ReminderCreatedEvent {
  /// Creates a [ReminderCreatedEvent].
  ReminderCreatedEvent({
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
  String get type => EventType.reminderCreated;

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

/// An event sent when the current user changes a reminder.
@freezed
final class ReminderUpdatedEvent extends ChatEvent with HasCid, _$ReminderUpdatedEvent {
  /// Creates a [ReminderUpdatedEvent].
  ReminderUpdatedEvent({
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
  String get type => EventType.reminderUpdated;

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

/// An event sent when the current user removes a reminder.
@freezed
final class ReminderDeletedEvent extends ChatEvent with HasCid, _$ReminderDeletedEvent {
  /// Creates a [ReminderDeletedEvent].
  ReminderDeletedEvent({
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
  String get type => EventType.reminderDeleted;

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
