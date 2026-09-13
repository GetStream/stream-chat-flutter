import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_core/stream_core.dart' show Sort, SortField;

import 'user.dart';

part 'poll_vote.g.dart';

/// {@template streamPollVote}
/// A model class representing a poll vote.
/// {@endtemplate}
@JsonSerializable()
class PollVote extends Equatable {
  /// {@macro streamPollVote}
  PollVote({
    this.id,
    this.pollId,
    this.optionId,
    this.answerText,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.userId,
    this.user,
  }) : assert(
         optionId != null || answerText != null,
         'Either optionId or answerText must be provided',
       ),
       isAnswer = answerText != null,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// Create a new instance from a json
  factory PollVote.fromJson(Map<String, dynamic> json) => _$PollVoteFromJson(json);

  /// The unique identifier of the poll vote.
  @JsonKey(includeIfNull: false)
  final String? id;

  /// The unique identifier of the option selected in the poll.
  @JsonKey(includeIfNull: false)
  final String? optionId;

  /// The text of the answer provided in the poll.
  @JsonKey(includeIfNull: false)
  final String? answerText;

  /// If true, the vote is an answer.
  @JsonKey(includeToJson: false)
  final bool isAnswer;

  /// The unique identifier of the poll the vote belongs to.
  @JsonKey(includeToJson: false)
  final String? pollId;

  /// The date when the poll vote was created.
  @JsonKey(includeToJson: false)
  final DateTime createdAt;

  /// The date when the poll vote was last updated.
  @JsonKey(includeToJson: false)
  final DateTime updatedAt;

  /// The unique identifier of the user who voted.
  @JsonKey(includeToJson: false)
  final String? userId;

  /// The user who casted the vote.
  @JsonKey(includeToJson: false)
  final User? user;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$PollVoteToJson(this);

  /// Creates a copy of [PollVote] with specified attributes overridden.
  PollVote copyWith({
    String? id,
    String? pollId,
    String? optionId,
    String? answerText,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    User? user,
  }) => PollVote(
    id: id ?? this.id,
    pollId: pollId ?? this.pollId,
    optionId: optionId ?? this.optionId,
    answerText: answerText ?? this.answerText,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    userId: userId ?? this.userId,
    user: user ?? this.user,
  );

  @override
  List<Object?> get props => [
    id,
    pollId,
    optionId,
    isAnswer,
    answerText,
    createdAt,
    updatedAt,
    userId,
    user,
  ];
}

/// Represents a sorting operation for poll votes.
///
/// The API sorts on one field at a time: `id`, `createdAt` or `updatedAt`.
/// Anything else is rejected.
///
/// See [PollVoteSortField] for the fields that can be sorted on.
class PollVoteSort extends Sort<PollVote> {
  /// Sorts by [field], smallest first.
  const PollVoteSort.asc(
    PollVoteSortField super.field, {
    super.nullOrdering,
  }) : super.asc();

  /// Sorts by [field], largest first.
  const PollVoteSort.desc(
    PollVoteSortField super.field, {
    super.nullOrdering,
  }) : super.desc();

  /// An empty sort, which leaves the ordering to the API.
  ///
  /// Pass this where a sort is expected but none is wanted: a query carries
  /// no sort term, and a poll-vote list is left in the order it arrived in.
  static const List<PollVoteSort> empty = [];

  /// The ordering the API applies to a poll-vote query when none is given.
  ///
  /// Sorts by when the vote was cast, oldest first.
  static final List<PollVoteSort> defaultSort = [
    PollVoteSort.asc(PollVoteSortField.createdAt),
  ];
}

/// Represents a field that poll-vote queries can be sorted on.
class PollVoteSortField extends SortField<PollVote> {
  /// Creates a poll-vote sort field named [remote] on the wire, reading its
  /// value off an instance with `localValue`.
  ///
  /// Prefer the fields this class declares — they are the ones the API accepts.
  /// This is for a field the SDK has not modelled yet.
  PollVoteSortField(super.remote, super.localValue);

  /// Sorts poll votes by their ID.
  static final id = PollVoteSortField(
    'id',
    (it) => it.id,
  );

  /// Sorts poll votes by their creation date.
  ///
  /// This is the default sort field (in ascending order).
  static final createdAt = PollVoteSortField(
    'created_at',
    (it) => it.createdAt,
  );

  /// Sorts poll votes by their last update date.
  static final updatedAt = PollVoteSortField(
    'updated_at',
    (it) => it.updatedAt,
  );
}
