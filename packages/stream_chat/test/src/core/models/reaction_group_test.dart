import 'package:stream_chat/src/core/models/reaction_group.dart';
import 'package:test/test.dart';

void main() {
  group('ReactionGroup', () {
    final firstReactionAtDate = DateTime.utc(2023, 10, 26, 10);
    final lastReactionAtDate = DateTime.utc(2023, 10, 26, 12);

    const count = 10;
    const sumScores = 50;

    test('constructor sets provided values', () {
      final reactionGroup = ReactionGroup(
        count: count,
        sumScores: sumScores,
        firstReactionAt: firstReactionAtDate,
        lastReactionAt: lastReactionAtDate,
      );
      expect(reactionGroup.count, count);
      expect(reactionGroup.sumScores, sumScores);
      expect(reactionGroup.firstReactionAt, firstReactionAtDate);
      expect(reactionGroup.lastReactionAt, lastReactionAtDate);
    });

    test('fromJson creates correct object', () {
      final json = {
        'count': count,
        'sum_scores': sumScores,
        'first_reaction_at': firstReactionAtDate.toIso8601String(),
        'last_reaction_at': lastReactionAtDate.toIso8601String(),
      };
      final reactionGroup = ReactionGroup.fromJson(json);
      expect(reactionGroup.count, count);
      expect(reactionGroup.sumScores, sumScores);
      expect(reactionGroup.firstReactionAt, firstReactionAtDate);
      expect(reactionGroup.lastReactionAt, lastReactionAtDate);
    });

    test('copyWith creates a new object with updated values', () {
      final reactionGroup = ReactionGroup(
        count: count,
        sumScores: sumScores,
        firstReactionAt: firstReactionAtDate,
        lastReactionAt: lastReactionAtDate,
      );

      final copiedGroup = reactionGroup.copyWith(
        count: 20,
        sumScores: 100,
      );

      expect(copiedGroup.count, 20);
      expect(copiedGroup.sumScores, 100);
      expect(copiedGroup.firstReactionAt, firstReactionAtDate);
      expect(copiedGroup.lastReactionAt, lastReactionAtDate);

      final newFirstAt = DateTime.utc(2023, 11);
      final newLastAt = DateTime.utc(2023, 11, 2);
      final copiedGroup2 = reactionGroup.copyWith(
        firstReactionAt: newFirstAt,
        lastReactionAt: newLastAt,
      );
      expect(copiedGroup2.count, count);
      expect(copiedGroup2.sumScores, sumScores);
      expect(copiedGroup2.firstReactionAt, newFirstAt);
      expect(copiedGroup2.lastReactionAt, newLastAt);
    });

    test('copyWith uses existing values if not provided', () {
      final reactionGroup = ReactionGroup(
        count: count,
        sumScores: sumScores,
        firstReactionAt: firstReactionAtDate,
        lastReactionAt: lastReactionAtDate,
      );

      final copiedGroup = reactionGroup.copyWith();

      expect(copiedGroup.count, count);
      expect(copiedGroup.sumScores, sumScores);
      expect(copiedGroup.firstReactionAt, firstReactionAtDate);
      expect(copiedGroup.lastReactionAt, lastReactionAtDate);
    });

    test('props returns correct list of properties', () {
      final reactionGroup = ReactionGroup(
        count: count,
        sumScores: sumScores,
        firstReactionAt: firstReactionAtDate,
        lastReactionAt: lastReactionAtDate,
      );
      expect(reactionGroup.props, [
        count,
        sumScores,
        firstReactionAtDate,
        lastReactionAtDate,
      ]);
    });

    test('equality works correctly', () {
      final reactionGroup1 = ReactionGroup(
        count: count,
        sumScores: sumScores,
        firstReactionAt: firstReactionAtDate,
        lastReactionAt: lastReactionAtDate,
      );
      final reactionGroup2 = ReactionGroup(
        count: count,
        sumScores: sumScores,
        firstReactionAt: firstReactionAtDate,
        lastReactionAt: lastReactionAtDate,
      );
      final reactionGroup3 = ReactionGroup(
        count: count + 1, // different count
        sumScores: sumScores,
        firstReactionAt: firstReactionAtDate,
        lastReactionAt: lastReactionAtDate,
      );
      final reactionGroup4 = ReactionGroup();

      expect(reactionGroup1 == reactionGroup2, isTrue);
      expect(reactionGroup1 == reactionGroup3, isFalse);
      expect(reactionGroup1 == reactionGroup4, isFalse);
    });
  });
}
