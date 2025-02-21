import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/user.dart';

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
  })  : assert(
          optionId != null || answerText != null,
          'Either optionId or answerText must be provided',
        ),
        isAnswer = answerText != null,
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Create a new instance from a json
  factory PollVote.fromJson(Map<String, dynamic> json) =>
      _$PollVoteFromJson(json);

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
  }) =>
      PollVote(
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
