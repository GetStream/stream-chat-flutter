import 'package:freezed_annotation/freezed_annotation.dart';

import '../../db/data_serializable.dart';

part 'reaction_group.freezed.dart';
part 'reaction_group.g.dart';

/// The reactions of one type on a message, counted and scored together.
@Freezed(copyWith: false)
// TODO(openapi-migration): remove in group 10
@DataSerializable()
class ReactionGroup with _$ReactionGroup {
  /// Creates a new [ReactionGroup].
  ///
  /// [firstReactionAt] and [lastReactionAt] default to now.
  ReactionGroup({
    this.count = 0,
    this.sumScores = 0,
    DateTime? firstReactionAt,
    DateTime? lastReactionAt,
  }) : firstReactionAt = firstReactionAt ?? DateTime.timestamp(),
       lastReactionAt = lastReactionAt ?? DateTime.timestamp();

  /// Creates a [ReactionGroup] from the offline-database format written by [toData].
  ///
  /// It is not a codec for API payloads.
  factory ReactionGroup.fromData(Map<String, dynamic> json) => _$ReactionGroupFromJson(json);

  /// The number of users that reacted with this reaction.
  @override
  final int count;

  /// The sum of scores of all reactions in this group.
  @override
  final int sumScores;

  /// The date of the first reaction in this group.
  @override
  final DateTime firstReactionAt;

  /// The date of the last reaction in this group.
  @override
  final DateTime lastReactionAt;

  /// Serializes this group to the format `stream_chat_persistence` stores.
  ///
  /// It is not a codec for API payloads.
  Map<String, dynamic> toData() => _$ReactionGroupToJson(this);

  /// Creates a copy of this group with the given fields replaced.
  ///
  /// A field passed as null keeps its current value.
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
}

/// A group of comparators for sorting [ReactionGroup]s.
final class ReactionSorting {
  /// Sorts [ReactionGroup]s by the sum of their scores.
  static int byScore(ReactionGroup a, ReactionGroup b) {
    return a.sumScores.compareTo(b.sumScores);
  }

  /// Sorts [ReactionGroup]s by the count of reactions.
  static int byCount(ReactionGroup a, ReactionGroup b) {
    return a.count.compareTo(b.count);
  }

  /// Sorts [ReactionGroup]s by the date of their first reaction.
  static int byFirstReactionAt(ReactionGroup a, ReactionGroup b) {
    return a.firstReactionAt.compareTo(b.firstReactionAt);
  }

  /// Sorts [ReactionGroup]s by the date of their last reaction.
  static int byLastReactionAt(ReactionGroup a, ReactionGroup b) {
    return a.lastReactionAt.compareTo(b.lastReactionAt);
  }
}
