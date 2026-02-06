import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/comparable_field.dart';
import 'package:stream_chat/src/core/models/poll_option.dart';
import 'package:stream_chat/src/core/models/poll_vote.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/util/serializer.dart';
import 'package:uuid/uuid.dart';

part 'poll.g.dart';

class _NullConst {
  const _NullConst();
}

const _nullConst = _NullConst();

/// {@template streamVotingVisibility}
/// Represents the visibility of the voting process.
/// {@endtemplate}
enum VotingVisibility {
  /// The voting process is anonymous.
  @JsonValue('anonymous')
  anonymous,

  /// The voting process is public.
  @JsonValue('public')
  public,
}

/// {@template streamPoll}
/// A model class representing a poll.
/// {@endtemplate}
@JsonSerializable()
class Poll extends Equatable implements ComparableFieldProvider {
  /// {@macro streamPoll}
  Poll({
    String? id,
    required this.name,
    this.description,
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

  /// Create a new instance from a json
  factory Poll.fromJson(Map<String, dynamic> json) =>
      _$PollFromJson(Serializer.moveToExtraDataFromRoot(json, topLevelFields));

  /// The unique identifier of the poll.
  final String id;

  /// The name of the poll.
  final String name;

  /// The description of the poll.
  final String? description;

  /// The list of options available for the poll.
  final List<PollOption> options;

  /// Represents the visibility of the voting process.
  ///
  /// Defaults to [VotingVisibility.public].
  final VotingVisibility votingVisibility;

  /// If true, only unique votes are allowed.
  ///
  /// Defaults to false.
  final bool enforceUniqueVote;

  /// The maximum number of votes allowed per user.
  final int? maxVotesAllowed;

  /// If true, users can suggest their own options.
  ///
  /// Defaults to false.
  final bool allowUserSuggestedOptions;

  /// If true, users can provide their own answers/comments.
  ///
  /// Defaults to false.
  final bool allowAnswers;

  /// Indicates if the poll is closed.
  final bool isClosed;

  /// The total number of answers received by the poll.
  @JsonKey(includeToJson: false)
  final int answersCount;

  /// Map of vote counts by option.
  @JsonKey(includeToJson: false)
  final Map<String, int> voteCountsByOption;

  /// Map of latest votes by option.
  @JsonKey(includeToJson: false)
  final Map<String, List<PollVote>> latestVotesByOption;

  /// List of votes received by the poll.
  ///
  /// Note: This does not include the answers provided by the users,
  /// see [latestAnswers] for that.
  late final latestVotes = [...latestVotesByOption.values.flattened];

  /// List of latest answers received by the poll.
  @JsonKey(includeToJson: false)
  final List<PollVote> latestAnswers;

  /// List of votes casted by the current user.
  ///
  /// Contains both votes and answers.
  @JsonKey(name: 'own_votes', includeToJson: false)
  final List<PollVote> ownVotesAndAnswers;

  /// The total number of votes received by the poll.
  @JsonKey(includeToJson: false)
  final int voteCount;

  /// List of votes casted by the current user.
  ///
  /// Note: This does not include the answers provided by the user,
  /// see [ownAnswers] for that.
  late final ownVotes = [...ownVotesAndAnswers.where((it) => !it.isAnswer)];

  /// List of answers provided by the current user.
  ///
  /// Note: This does not include the votes casted by the user,
  /// see [ownVotes] for that.
  late final ownAnswers = [...ownVotesAndAnswers.where((it) => it.isAnswer)];

  /// The id of the user who created the poll.
  @JsonKey(includeToJson: false)
  final String? createdById;

  /// The user who created the poll.
  @JsonKey(includeToJson: false)
  final User? createdBy;

  /// The date when the poll was created.
  @JsonKey(includeToJson: false)
  final DateTime createdAt;

  /// The date when the poll was last updated.
  @JsonKey(includeToJson: false)
  final DateTime updatedAt;

  /// Map of custom poll extraData
  final Map<String, Object?> extraData;

  /// Serialize to json
  Map<String, dynamic> toJson() => Serializer.moveFromExtraDataToRoot(_$PollToJson(this));

  /// Creates a copy of [Poll] with specified attributes overridden.
  Poll copyWith({
    String? id,
    String? name,
    String? description,
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
    description: description ?? this.description,
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

  /// Known top level fields.
  ///
  /// Useful for [Serializer] methods.
  static const topLevelFields = [
    'id',
    'name',
    'description',
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

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    options,
    votingVisibility,
    enforceUniqueVote,
    maxVotesAllowed,
    allowUserSuggestedOptions,
    allowAnswers,
    isClosed,
    voteCountsByOption,
    ownVotesAndAnswers,
    voteCount,
    answersCount,
    latestVotesByOption,
    latestAnswers,
    createdById,
    createdBy,
    createdAt,
    updatedAt,
  ];

  @override
  ComparableField? getComparableField(String sortKey) {
    final value = switch (sortKey) {
      PollSortKey.id => id,
      PollSortKey.name => name,
      PollSortKey.createdAt => createdAt,
      PollSortKey.updatedAt => updatedAt,
      PollSortKey.isClosed => isClosed,
      _ => extraData[sortKey],
    };

    return ComparableField.fromValue(value);
  }
}

/// Extension type representing sortable fields for [Poll].
///
/// This type provides type-safe keys that can be used for sorting polls
/// in queries. Each constant represents a field that can be sorted on.
extension type const PollSortKey(String key) implements String {
  /// Sort polls by their unique ID.
  static const id = PollSortKey('id');

  /// Sort polls by their name.
  static const name = PollSortKey('name');

  /// Sort polls by their creation date.
  ///
  /// This is the default sort field (in ascending order).
  static const createdAt = PollSortKey('created_at');

  /// Sort polls by their last update date.
  static const updatedAt = PollSortKey('updated_at');

  /// Sort polls by whether they are closed or not.
  ///
  /// Closed polls will appear first when sorting in ascending order.
  static const isClosed = PollSortKey('is_closed');
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
