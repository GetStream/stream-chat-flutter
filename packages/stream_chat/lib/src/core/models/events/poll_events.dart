import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../stream_chat.dart';

part 'poll_events.freezed.dart';

/// An event sent when a poll is updated.
@freezed
final class PollUpdatedEvent extends ChatEvent with HasCid, _$PollUpdatedEvent {
  /// Creates a [PollUpdatedEvent].
  PollUpdatedEvent({
    this.cid,
    this.messageId,
    required this.poll,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.pollUpdated;

  @override
  final String? cid;

  /// The id of the message the poll is attached to.
  @override
  final String? messageId;

  /// The poll as it is after the event.
  @override
  final Poll poll;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a poll is closed.
@freezed
final class PollClosedEvent extends ChatEvent with HasCid, _$PollClosedEvent {
  /// Creates a [PollClosedEvent].
  PollClosedEvent({
    this.cid,
    this.messageId,
    required this.poll,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.pollClosed;

  @override
  final String? cid;

  /// The id of the message the poll is attached to.
  @override
  final String? messageId;

  /// The poll as it is after the event.
  @override
  final Poll poll;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a poll is deleted.
@freezed
final class PollDeletedEvent extends ChatEvent with HasCid, _$PollDeletedEvent {
  /// Creates a [PollDeletedEvent].
  PollDeletedEvent({
    this.cid,
    this.messageId,
    required this.poll,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.pollDeleted;

  @override
  final String? cid;

  /// The id of the message the poll is attached to.
  @override
  final String? messageId;

  /// The poll as it is after the event.
  @override
  final Poll poll;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a vote is cast on a poll.
///
/// A vote that is an answer arrives as a [PollAnswerCastedEvent] instead.
@freezed
final class PollVoteCastedEvent extends ChatEvent with HasCid, HasPollVote, _$PollVoteCastedEvent {
  /// Creates a [PollVoteCastedEvent].
  PollVoteCastedEvent({
    this.cid,
    this.messageId,
    required this.poll,
    required this.pollVote,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.pollVoteCasted;

  @override
  final String? cid;

  /// The id of the message the poll is attached to.
  @override
  final String? messageId;

  @override
  final Poll poll;

  @override
  final PollVote pollVote;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a vote on a poll is changed.
///
/// A vote that is an answer arrives as a [PollAnswerCastedEvent] instead.
@freezed
final class PollVoteChangedEvent extends ChatEvent with HasCid, HasPollVote, _$PollVoteChangedEvent {
  /// Creates a [PollVoteChangedEvent].
  PollVoteChangedEvent({
    this.cid,
    this.messageId,
    required this.poll,
    required this.pollVote,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.pollVoteChanged;

  @override
  final String? cid;

  /// The id of the message the poll is attached to.
  @override
  final String? messageId;

  @override
  final Poll poll;

  @override
  final PollVote pollVote;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when a vote is removed from a poll.
///
/// A vote that is an answer arrives as a [PollAnswerRemovedEvent] instead.
@freezed
final class PollVoteRemovedEvent extends ChatEvent with HasCid, HasPollVote, _$PollVoteRemovedEvent {
  /// Creates a [PollVoteRemovedEvent].
  PollVoteRemovedEvent({
    this.cid,
    this.messageId,
    required this.poll,
    required this.pollVote,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.pollVoteRemoved;

  @override
  final String? cid;

  /// The id of the message the poll is attached to.
  @override
  final String? messageId;

  @override
  final Poll poll;

  @override
  final PollVote pollVote;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when an answer is added to a poll or changed.
@freezed
final class PollAnswerCastedEvent extends ChatEvent with HasCid, HasPollVote, _$PollAnswerCastedEvent {
  /// Creates a [PollAnswerCastedEvent].
  PollAnswerCastedEvent({
    this.cid,
    this.messageId,
    required this.poll,
    required this.pollVote,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.pollAnswerCasted;

  @override
  final String? cid;

  /// The id of the message the poll is attached to.
  @override
  final String? messageId;

  @override
  final Poll poll;

  @override
  final PollVote pollVote;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event sent when an answer is removed from a poll.
@freezed
final class PollAnswerRemovedEvent extends ChatEvent with HasCid, HasPollVote, _$PollAnswerRemovedEvent {
  /// Creates a [PollAnswerRemovedEvent].
  PollAnswerRemovedEvent({
    this.cid,
    this.messageId,
    required this.poll,
    required this.pollVote,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.pollAnswerRemoved;

  @override
  final String? cid;

  /// The id of the message the poll is attached to.
  @override
  final String? messageId;

  @override
  final Poll poll;

  @override
  final PollVote pollVote;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}
