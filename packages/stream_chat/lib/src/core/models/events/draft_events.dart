import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../stream_chat.dart';

part 'draft_events.freezed.dart';

/// An event sent when the current user saves a draft.
@freezed
final class DraftUpdatedEvent extends ChatEvent with HasCid, _$DraftUpdatedEvent {
  /// Creates a [DraftUpdatedEvent].
  DraftUpdatedEvent({
    this.cid,
    this.draft,
    this.parentId,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.draftUpdated;

  @override
  final String? cid;

  /// The draft the event concerns.
  @override
  final Draft? draft;

  /// The id of the thread's parent message, when the draft is a thread reply.
  @override
  final String? parentId;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when the current user deletes a draft.
@freezed
final class DraftDeletedEvent extends ChatEvent with HasCid, _$DraftDeletedEvent {
  /// Creates a [DraftDeletedEvent].
  DraftDeletedEvent({
    this.cid,
    this.draft,
    this.parentId,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.draftDeleted;

  @override
  final String? cid;

  /// The draft the event concerns.
  @override
  final Draft? draft;

  /// The id of the thread's parent message, when the draft is a thread reply.
  @override
  final String? parentId;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}
