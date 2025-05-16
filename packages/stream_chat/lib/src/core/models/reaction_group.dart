import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reaction_group.g.dart';

/// A model class representing a reaction group.
@JsonSerializable()
class ReactionGroup extends Equatable {
  /// Create a new instance of [ReactionGroup].
  ReactionGroup({
    this.count = 0,
    this.sumScores = 0,
    DateTime? firstReactionAt,
    DateTime? lastReactionAt,
  })  : firstReactionAt = firstReactionAt ?? DateTime.timestamp(),
        lastReactionAt = lastReactionAt ?? DateTime.timestamp();

  /// Create a new instance from a json
  factory ReactionGroup.fromJson(Map<String, dynamic> json) =>
      _$ReactionGroupFromJson(json);

  /// The number of users that reacted with this reaction.
  final int count;

  /// The sum of scores of all reactions in this group.
  final int sumScores;

  /// The date of the first reaction in this group.
  final DateTime firstReactionAt;

  /// The date of the last reaction in this group.
  final DateTime lastReactionAt;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ReactionGroupToJson(this);

  /// Creates a copy of [Reaction] with specified attributes overridden.
  ReactionGroup copyWith({
    int? count,
    int? sumScores,
    DateTime? firstReactionAt,
    DateTime? lastReactionAt,
  }) {
    return ReactionGroup(
      count: count ?? this.count,
      sumScores: sumScores ?? this.sumScores,
      firstReactionAt: firstReactionAt ?? this.firstReactionAt,
      lastReactionAt: lastReactionAt ?? this.lastReactionAt,
    );
  }

  @override
  List<Object?> get props => [
        count,
        sumScores,
        firstReactionAt,
        lastReactionAt,
      ];
}
