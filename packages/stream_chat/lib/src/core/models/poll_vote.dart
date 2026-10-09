import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_core/stream_core.dart' show Filter, FilterField, Sort, SortField;

import 'user.dart';

part 'poll_vote.freezed.dart';

/// A user's vote for an option of a poll, or their free-form answer to it.
///
/// A vote carries an [optionId] and an answer carries [answerText]; [isAnswer]
/// tells the two apart.
@Freezed(copyWith: false)
class PollVote with _$PollVote {
  /// Creates a new [PollVote].
  ///
  /// Either [optionId] or [answerText] must be given. [createdAt] and
  /// [updatedAt] default to the current time.
  PollVote({
    this.id,
    this.pollId,
    this.optionId,
    this.answerText,
    this.answerTextI18n,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.userId,
    this.user,
  }) : assert(
         optionId != null || answerText != null,
         'Either optionId or answerText must be provided',
       ),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// The unique identifier of this vote, or null before it is cast.
  @override
  final String? id;

  /// The unique identifier of the poll this vote belongs to.
  @override
  final String? pollId;

  /// The unique identifier of the option this vote selects.
  ///
  /// An answer selects no option.
  @override
  final String? optionId;

  /// The text of this answer, or null for a vote.
  @override
  final String? answerText;

  /// The translations of [answerText], keyed as `<language>_text`, plus the
  /// `language` [answerText] was written in.
  ///
  /// Filled in by the server when the answer is added to a poll in a channel
  /// with automatic translation enabled.
  @override
  final Map<String, String>? answerTextI18n;

  /// The date this vote was cast.
  @override
  final DateTime createdAt;

  /// The date this vote was last changed.
  @override
  final DateTime updatedAt;

  /// The unique identifier of the user who cast this vote.
  ///
  /// Null on someone else's vote in an anonymous poll.
  @override
  final String? userId;

  /// The user who cast this vote.
  ///
  /// Null on someone else's vote in an anonymous poll.
  @override
  final User? user;

  /// Creates a copy of [PollVote] with specified attributes overridden.
  PollVote copyWith({
    String? id,
    String? pollId,
    String? optionId,
    String? answerText,
    Map<String, String>? answerTextI18n,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    User? user,
  }) => PollVote(
    id: id ?? this.id,
    pollId: pollId ?? this.pollId,
    optionId: optionId ?? this.optionId,
    answerText: answerText ?? this.answerText,
    answerTextI18n: answerTextI18n ?? this.answerTextI18n,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    userId: userId ?? this.userId,
    user: user ?? this.user,
  );

  /// Whether this is a free-form answer rather than a vote for an option.
  bool get isAnswer => answerText != null;
}

/// A filter for a poll vote query.
///
/// See [PollVoteFilterField] for the fields that can be filtered on.
///
/// ```dart
/// final filter = PollVoteFilter.equal(PollVoteFilterField.isAnswer, true);
/// ```
typedef PollVoteFilter = Filter<PollVote>;

/// Represents a field that poll vote queries can be filtered on.
class PollVoteFilterField extends FilterField<PollVote> {
  /// Creates a poll vote filter field named [remote] in queries, reading its
  /// value off an instance with [value].
  PollVoteFilterField(super.remote, super.value);

  /// Filters poll votes by their id.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final id = PollVoteFilterField(
    'id',
    (it) => it.id,
  );

  /// Filters poll votes by the id of the poll they belong to.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final pollId = PollVoteFilterField(
    'poll_id',
    (it) => it.pollId,
  );

  /// Filters poll votes by the id of the option they select.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$exists`
  static final optionId = PollVoteFilterField(
    'option_id',
    (it) => it.optionId,
  );

  /// Filters poll votes by the id of the user who cast them.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final userId = PollVoteFilterField(
    'user_id',
    (it) => it.userId,
  );

  /// Filters poll votes by whether they are an answer rather than a vote.
  ///
  /// **Supported operators:** `$eq`
  static final isAnswer = PollVoteFilterField(
    'is_answer',
    (it) => it.isAnswer,
  );

  /// Filters poll votes by their creation date.
  ///
  /// **Supported operators:** `$eq`, `$gt`, `$gte`, `$lt`, `$lte`
  static final createdAt = PollVoteFilterField(
    'created_at',
    (it) => it.createdAt,
  );

  /// Filters poll votes by their last update date.
  ///
  /// **Supported operators:** `$eq`, `$gt`, `$gte`, `$lt`, `$lte`
  static final updatedAt = PollVoteFilterField(
    'updated_at',
    (it) => it.updatedAt,
  );
}

/// Represents a sorting operation for poll votes.
///
/// The API sorts on one field at a time: `id`, `createdAt` or `updatedAt`.
/// Anything else is rejected.
///
/// See [PollVoteSortField] for the fields that can be sorted on.
///
/// ```dart
/// final sort = [PollVoteSort.desc(PollVoteSortField.createdAt)];
/// ```
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

  /// An empty sort: the query carries no sort term, and a list keeps the
  /// order it arrived in.
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
  /// Creates a field named [remote] in queries, reading its value off an
  /// instance with `localValue`.
  ///
  /// For a name the SDK has not modelled; prefer the fields declared here.
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
