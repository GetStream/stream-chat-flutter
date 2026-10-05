import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_core/stream_core.dart'
    show Filter, FilterField, Standard, Sort, SortField, normalizeStringForSort;
import 'package:uuid/uuid.dart';

import 'poll_option.dart';
import 'poll_vote.dart';
import 'user.dart';
import 'voting_visibility.dart';

part 'poll.freezed.dart';

class _NullConst {
  const _NullConst();
}

const _nullConst = _NullConst();

/// A question with a set of options that the members of a channel vote on.
///
/// A poll is sent in a message. Besides its settings it carries a summary of
/// the votes so far: the counts per option, the latest votes and answers, and
/// the votes of the current user.
@Freezed(copyWith: false)
class Poll with _$Poll {
  /// Creates a new [Poll].
  ///
  /// An [id] is generated when omitted, and [createdAt] and [updatedAt]
  /// default to the current time.
  Poll({
    String? id,
    required this.name,
    this.nameI18n,
    this.description,
    this.descriptionI18n,
    required this.options,
    this.votingVisibility = VotingVisibility.public,
    this.enforceUniqueVote = true,
    this.maxVotesAllowed,
    this.allowAnswers = false,
    this.latestAnswers = const [],
    this.answersCount = 0,
    this.allowUserSuggestedOptions = false,
    this.isClosed = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.voteCountsByOption = const {},
    this.voteCount = 0,
    this.latestVotesByOption = const {},
    this.createdById,
    this.createdBy,
    this.ownVotesAndAnswers = const [],
    this.extraData = const {},
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// The unique identifier of this poll.
  @override
  final String id;

  /// The question this poll asks.
  @override
  final String name;

  /// The translations of [name], keyed as `<language>_text`, plus the
  /// `language` [name] was written in.
  ///
  /// Filled in by the server when the poll is sent to a channel with
  /// automatic translation enabled.
  @override
  final Map<String, String>? nameI18n;

  /// A longer explanation of the question.
  @override
  final String? description;

  /// The translations of [description], in the same shape as [nameI18n].
  @override
  final Map<String, String>? descriptionI18n;

  /// The options that can be voted for.
  @override
  final List<PollOption> options;

  /// Who can see which option each user voted for.
  ///
  /// Defaults to [VotingVisibility.public].
  @override
  final VotingVisibility votingVisibility;

  /// Whether each user may vote for one option only.
  ///
  /// Voting for another option replaces the previous vote. Defaults to true.
  @override
  final bool enforceUniqueVote;

  /// The maximum number of options each user may vote for, or null for no
  /// limit.
  @override
  final int? maxVotesAllowed;

  /// Whether users may add their own options to this poll.
  ///
  /// Defaults to false.
  @override
  final bool allowUserSuggestedOptions;

  /// Whether users may leave a free-form answer.
  ///
  /// Defaults to false.
  @override
  final bool allowAnswers;

  /// Whether this poll no longer accepts votes.
  @override
  final bool isClosed;

  /// The total number of answers left on this poll.
  @override
  final int answersCount;

  /// The number of votes each option received, keyed by option id.
  @override
  final Map<String, int> voteCountsByOption;

  /// The most recent votes for each option, keyed by option id.
  ///
  /// Empty for an anonymous poll.
  @override
  final Map<String, List<PollVote>> latestVotesByOption;

  /// The most recent votes across all options.
  ///
  /// Answers are not included; see [latestAnswers] for those.
  @override
  late final List<PollVote> latestVotes = [...latestVotesByOption.values.flattened];

  /// The most recent answers left on this poll.
  @override
  final List<PollVote> latestAnswers;

  /// The votes and answers of the current user.
  @override
  final List<PollVote> ownVotesAndAnswers;

  /// The total number of votes cast on this poll.
  @override
  final int voteCount;

  /// The votes of the current user.
  ///
  /// Answers are not included; see [ownAnswers] for those.
  @override
  late final List<PollVote> ownVotes = [...ownVotesAndAnswers.where((it) => !it.isAnswer)];

  /// The answers of the current user.
  ///
  /// Votes are not included; see [ownVotes] for those.
  @override
  late final List<PollVote> ownAnswers = [...ownVotesAndAnswers.where((it) => it.isAnswer)];

  /// The unique identifier of the user who created this poll.
  @override
  final String? createdById;

  /// The user who created this poll.
  @override
  final User? createdBy;

  /// The date this poll was created.
  @override
  final DateTime createdAt;

  /// The date this poll was last changed.
  @override
  final DateTime updatedAt;

  /// Custom data attached to this poll.
  @override
  final Map<String, Object?> extraData;

  /// Creates a copy of [Poll] with specified attributes overridden.
  Poll copyWith({
    String? id,
    String? name,
    Map<String, String>? nameI18n,
    String? description,
    Map<String, String>? descriptionI18n,
    List<PollOption>? options,
    VotingVisibility? votingVisibility,
    bool? enforceUniqueVote,
    Object? maxVotesAllowed = _nullConst,
    bool? allowUserSuggestedOptions,
    bool? allowAnswers,
    bool? isClosed,
    Map<String, int>? voteCountsByOption,
    List<PollVote>? ownVotesAndAnswers,
    int? voteCount,
    int? answersCount,
    Map<String, List<PollVote>>? latestVotesByOption,
    List<PollVote>? latestAnswers,
    String? createdById,
    User? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, Object?>? extraData,
  }) => Poll(
    id: id ?? this.id,
    name: name ?? this.name,
    nameI18n: nameI18n ?? this.nameI18n,
    description: description ?? this.description,
    descriptionI18n: descriptionI18n ?? this.descriptionI18n,
    options: options ?? this.options,
    votingVisibility: votingVisibility ?? this.votingVisibility,
    enforceUniqueVote: enforceUniqueVote ?? this.enforceUniqueVote,
    maxVotesAllowed: maxVotesAllowed == _nullConst ? this.maxVotesAllowed : maxVotesAllowed as int?,
    allowUserSuggestedOptions: allowUserSuggestedOptions ?? this.allowUserSuggestedOptions,
    allowAnswers: allowAnswers ?? this.allowAnswers,
    isClosed: isClosed ?? this.isClosed,
    voteCountsByOption: voteCountsByOption ?? this.voteCountsByOption,
    ownVotesAndAnswers: ownVotesAndAnswers ?? this.ownVotesAndAnswers,
    voteCount: voteCount ?? this.voteCount,
    answersCount: answersCount ?? this.answersCount,
    latestVotesByOption: latestVotesByOption ?? this.latestVotesByOption,
    latestAnswers: latestAnswers ?? this.latestAnswers,
    createdById: createdById ?? this.createdById,
    createdBy: createdBy ?? this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    extraData: extraData ?? this.extraData,
  );

  /// This poll with the translations of [oldPoll] filled in where this one
  /// has none.
  ///
  /// A translation is kept only for unchanged text, so a renamed poll or
  /// option never carries the translation of its old text. Returns this poll
  /// as is when [oldPoll] is `null` or a different poll.
  @internal
  Poll withTranslationsOf(Poll? oldPoll) {
    if (oldPoll == null || oldPoll.id != id) return this;

    final oldOptions = {for (final option in oldPoll.options) option.id: option};

    return copyWith(
      nameI18n: nameI18n ?? (name == oldPoll.name ? oldPoll.nameI18n : null),
      descriptionI18n: descriptionI18n ?? (description == oldPoll.description ? oldPoll.descriptionI18n : null),
      options: [
        for (final option in options)
          switch (oldOptions[option.id]) {
            final old? when option.textI18n == null && option.text == old.text => option.copyWith(
              textI18n: old.textI18n,
            ),
            _ => option,
          },
      ],
    );
  }

  /// The keys a poll carries besides its custom data.
  static const topLevelFields = [
    'id',
    'name',
    'name_i18n',
    'description',
    'description_i18n',
    'options',
    'voting_visibility',
    'enforce_unique_vote',
    'max_votes_allowed',
    'allow_user_suggested_options',
    'allow_answers',
    'is_closed',
    'created_at',
    'updated_at',
    'vote_counts_by_option',
    'votes',
    'own_votes',
    'vote_count',
    'answers_count',
    'latest_votes_by_option',
    'latest_answers',
    'created_by_id',
    'created_by',
  ];
}

/// A filter for a poll query.
///
/// See [PollFilterField] for the fields that can be filtered on.
///
/// ```dart
/// final filter = PollFilter.equal(PollFilterField.isClosed, false);
/// ```
typedef PollFilter = Filter<Poll>;

/// Represents a field that poll queries can be filtered on.
class PollFilterField extends FilterField<Poll> {
  /// Creates a poll filter field named [remote] in queries, reading its value
  /// off an instance with [value].
  PollFilterField(super.remote, super.value);

  /// Creates a field the SDK does not model, read from [Poll.extraData].
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`,
  /// `$exists`, `$contains`, `$q`, `$autocomplete`
  factory PollFilterField.custom(String remote) {
    return PollFilterField(remote, (it) => it.extraData[remote]);
  }

  /// Filters polls by their id.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final id = PollFilterField(
    'id',
    (it) => it.id,
  );

  /// Filters polls by their name.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final name = PollFilterField(
    'name',
    (it) => it.name,
  );

  /// Filters polls by the id of the user who created them.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final createdById = PollFilterField(
    'created_by_id',
    (it) => it.createdById,
  );

  /// Filters polls by whether they are closed to further voting.
  ///
  /// **Supported operators:** `$eq`
  static final isClosed = PollFilterField(
    'is_closed',
    (it) => it.isClosed,
  );

  /// Filters polls by how many votes each user may cast.
  ///
  /// **Supported operators:** `$eq`, `$gt`, `$gte`, `$lt`, `$lte`
  static final maxVotesAllowed = PollFilterField(
    'max_votes_allowed',
    (it) => it.maxVotesAllowed,
  );

  /// Filters polls by whether they accept free-form answers.
  ///
  /// **Supported operators:** `$eq`
  static final allowAnswers = PollFilterField(
    'allow_answers',
    (it) => it.allowAnswers,
  );

  /// Filters polls by whether users may add their own options.
  ///
  /// **Supported operators:** `$eq`
  static final allowUserSuggestedOptions = PollFilterField(
    'allow_user_suggested_options',
    (it) => it.allowUserSuggestedOptions,
  );

  /// Filters polls by whether their votes are public or anonymous.
  ///
  /// **Supported operators:** `$eq`
  static final votingVisibility = PollFilterField(
    'voting_visibility',
    (it) => it.votingVisibility.rawType,
  );

  /// Filters polls by their creation date.
  ///
  /// **Supported operators:** `$eq`, `$gt`, `$gte`, `$lt`, `$lte`
  static final createdAt = PollFilterField(
    'created_at',
    (it) => it.createdAt,
  );

  /// Filters polls by their last update date.
  ///
  /// **Supported operators:** `$eq`, `$gt`, `$gte`, `$lt`, `$lte`
  static final updatedAt = PollFilterField(
    'updated_at',
    (it) => it.updatedAt,
  );
}

/// Represents a sorting operation for polls.
///
/// The API sorts on one field at a time: `id`, `name`, `createdAt`,
/// `updatedAt` or `isClosed`. Anything else is rejected.
///
/// See [PollSortField] for the fields that can be sorted on.
///
/// ```dart
/// final sort = [PollSort.desc(PollSortField.createdAt)];
/// ```
class PollSort extends Sort<Poll> {
  /// Sorts by [field], smallest first.
  const PollSort.asc(
    PollSortField super.field, {
    super.nullOrdering,
  }) : super.asc();

  /// Sorts by [field], largest first.
  const PollSort.desc(
    PollSortField super.field, {
    super.nullOrdering,
  }) : super.desc();

  /// An empty sort: the query carries no sort term, and a list keeps the
  /// order it arrived in.
  static const List<PollSort> empty = [];

  /// The ordering the API applies to a poll query when none is given.
  ///
  /// Sorts by when the poll was created, oldest first.
  static final List<PollSort> defaultSort = [
    PollSort.asc(PollSortField.createdAt),
  ];
}

/// Represents a field that poll queries can be sorted on.
class PollSortField extends SortField<Poll> {
  /// Creates a field named [remote] in queries, reading its value off an
  /// instance with `localValue`.
  ///
  /// For a name the SDK has not modelled; prefer the fields declared here.
  PollSortField(super.remote, super.localValue);

  /// Sorts polls by their unique ID.
  static final id = PollSortField(
    'id',
    (it) => it.id,
  );

  /// Sorts polls by their name.
  ///
  /// Compared with case, diacritics and ligatures folded away, so a list
  /// sorted locally matches the order a query returns.
  static final name = PollSortField(
    'name',
    (it) => it.name.let(normalizeStringForSort),
  );

  /// Sorts polls by their creation date.
  ///
  /// This is the default sort field (in ascending order).
  static final createdAt = PollSortField(
    'created_at',
    (it) => it.createdAt,
  );

  /// Sorts polls by their last update date.
  static final updatedAt = PollSortField(
    'updated_at',
    (it) => it.updatedAt,
  );

  /// Sorts polls by whether they are closed or not.
  ///
  /// Closed polls will appear first when sorting in ascending order.
  static final isClosed = PollSortField(
    'is_closed',
    (it) => it.isClosed,
  );
}

/// Helper extension for [Poll] model.
extension PollX on Poll {
  /// The value of the option with the most votes.
  int get currentMaximumVoteCount => voteCountsByOption.values.maxOrNull ?? 0;

  /// Whether the poll is already closed and the provided option is the one,
  /// and **the only one** with the most votes.
  bool isOptionWinner(PollOption option) => isClosed && isOptionWithMostVotes(option);

  /// Whether the poll is already closed and the provided option is one of that
  /// has the most votes.
  bool isOptionOneOfTheWinners(PollOption option) => isClosed && isOptionWithMaximumVotes(option);

  /// Whether the provided option is the one, and **the only one** with the most
  /// votes.
  bool isOptionWithMostVotes(PollOption option) {
    final optionsWithMostVotes = {
      for (final entry in voteCountsByOption.entries)
        if (entry.value == currentMaximumVoteCount) entry.key: entry.value,
    };

    return optionsWithMostVotes.length == 1 && optionsWithMostVotes[option.id] != null;
  }

  /// Whether the provided option is one of that has the most votes.
  bool isOptionWithMaximumVotes(PollOption option) {
    final optionsWithMostVotes = {
      for (final entry in voteCountsByOption.entries)
        if (entry.value == currentMaximumVoteCount) entry.key: entry.value,
    };

    return optionsWithMostVotes[option.id] != null;
  }

  /// The vote count for the given option.
  int voteCountFor(PollOption option) => voteCountsByOption[option.id] ?? 0;

  /// The ratio of the votes for the given option in comparison with the number
  /// of total votes.
  double voteRatioFor(PollOption option) {
    if (currentMaximumVoteCount == 0) return 0;

    final optionVoteCount = voteCountFor(option);
    return optionVoteCount / currentMaximumVoteCount;
  }

  /// Returns the vote of the current user for the given option in case the user
  /// has voted.
  PollVote? currentUserVoteFor(PollOption option) =>
      ownVotesAndAnswers.firstWhereOrNull((it) => it.optionId == option.id);

  /// Returns a Boolean value indicating whether the current user has voted the
  /// given option.
  bool hasCurrentUserVotedFor(PollOption option) => ownVotesAndAnswers.any((it) => it.optionId == option.id);
}
