import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/poll_option.dart';
import 'package:stream_chat/src/core/models/poll_vote.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/util/serializer.dart';
import 'package:uuid/uuid.dart';

part 'poll.g.dart';

/// {@template streamVotingVisibility}
/// Represents the visibility of the voting process.
/// {@endtemplate}
enum VotingVisibility {
  /// The voting process is anonymous.
  anonymous,

  /// The voting process is public.
  public,
}

/// {@template streamPoll}
/// A model class representing a poll.
/// {@endtemplate}
@JsonSerializable()
class Poll extends Equatable {
  /// {@macro streamPoll}
  Poll({
    String? id,
    required this.name,
    this.description,
    required this.options,
    this.votingVisibility = VotingVisibility.public,
    this.enforceUniqueVote = false,
    this.maxVotesAllowed,
    this.allowAnswers = false,
    this.latestAnswers = const [],
    this.answersCount = 0,
    this.allowUserSuggestedOptions = false,
    this.isClosed = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.voteCountsByOption = const {},
    this.votes = const [],
    this.voteCount = 0,
    this.latestVotesByOption = const {},
    this.createdById,
    this.createdBy,
    this.ownVotes = const [],
    this.extraData = const {},
  })  : id = id ?? const Uuid().v4(),
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

  /// Map of vote counts by option.
  @JsonKey(includeToJson: false)
  final Map<String, int> voteCountsByOption;

  /// List of votes received by the poll.
  @JsonKey(includeToJson: false)
  final List<PollVote> votes;

  /// List of votes casted by the current user.
  @JsonKey(includeToJson: false)
  final List<PollVote> ownVotes;

  /// The total number of votes received by the poll.
  @JsonKey(includeToJson: false)
  final int voteCount;

  /// The total number of answers received by the poll.
  @JsonKey(includeToJson: false)
  final int answersCount;

  /// Map of latest votes by option.
  @JsonKey(includeToJson: false)
  final Map<String, List<PollVote>> latestVotesByOption;

  /// List of latest answers received by the poll.
  @JsonKey(includeToJson: false)
  final List<PollVote> latestAnswers;

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
  Map<String, dynamic> toJson() =>
      Serializer.moveFromExtraDataToRoot(_$PollToJson(this));

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
        votes,
        ownVotes,
        voteCount,
        answersCount,
        latestVotesByOption,
        latestAnswers,
        createdById,
        createdBy,
        createdAt,
        updatedAt,
      ];
}
