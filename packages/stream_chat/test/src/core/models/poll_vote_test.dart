import 'package:stream_chat/src/core/models/poll_vote.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

void main() {
  group('src/models/poll_vote', () {
    group('ComparableFieldProvider', () {
      test('should return ComparableField for poll_vote.id', () {
        final pollVote = createTestPollVote(
          id: 'test-vote-id',
          optionId: 'option-1',
        );

        final field = pollVote.getComparableField(PollVoteSortKey.id);
        expect(field, isNotNull);
        expect(field!.value, equals('test-vote-id'));
      });

      test('should return ComparableField for poll_vote.createdAt', () {
        final createdAt = DateTime(2023, 6, 15);
        final pollVote = createTestPollVote(
          id: 'test-vote-id',
          optionId: 'option-1',
          createdAt: createdAt,
        );

        final field = pollVote.getComparableField(PollVoteSortKey.createdAt);
        expect(field, isNotNull);
        expect(field!.value, equals(createdAt));
      });

      test('should return ComparableField for poll_vote.updatedAt', () {
        final updatedAt = DateTime(2023, 6, 20);
        final pollVote = createTestPollVote(
          id: 'test-vote-id',
          optionId: 'option-1',
          updatedAt: updatedAt,
        );

        final field = pollVote.getComparableField(PollVoteSortKey.updatedAt);
        expect(field, isNotNull);
        expect(field!.value, equals(updatedAt));
      });

      test('should return ComparableField for poll_vote.answerText', () {
        final pollVote = createTestPollVote(
          id: 'test-vote-id',
          answerText: 'This is my answer',
        );

        final field = pollVote.getComparableField(PollVoteSortKey.answerText);
        expect(field, isNotNull);
        expect(field!.value, equals('This is my answer'));
      });

      test('should return null for non-existent field keys', () {
        final pollVote = createTestPollVote(
          id: 'test-vote-id',
          optionId: 'option-1',
        );

        final field = pollVote.getComparableField('non_existent_key');
        expect(field, isNull);
      });

      test('should compare two poll votes correctly using createdAt', () {
        final recentVote = createTestPollVote(
          id: 'recent',
          optionId: 'option-1',
          createdAt: DateTime(2023, 6, 15),
        );

        final olderVote = createTestPollVote(
          id: 'older',
          optionId: 'option-1',
          createdAt: DateTime(2023, 6, 10),
        );

        final field1 = recentVote.getComparableField(PollVoteSortKey.createdAt);
        final field2 = olderVote.getComparableField(PollVoteSortKey.createdAt);

        // More recent > Less recent
        expect(field1!.compareTo(field2!), greaterThan(0));
        // Less recent < More recent
        expect(field2.compareTo(field1), lessThan(0));
      });

      test('should compare two poll votes correctly using id', () {
        final vote1 = createTestPollVote(
          id: 'abc',
          optionId: 'option-1',
        );

        final vote2 = createTestPollVote(
          id: 'xyz',
          optionId: 'option-1',
        );

        final field1 = vote1.getComparableField(PollVoteSortKey.id);
        final field2 = vote2.getComparableField(PollVoteSortKey.id);

        expect(field1!.compareTo(field2!), lessThan(0)); // abc < xyz
        expect(field2.compareTo(field1), greaterThan(0)); // xyz > abc
      });

      test('should compare two poll votes correctly using answerText', () {
        final vote1 = createTestPollVote(
          id: 'answer1',
          answerText: 'Answer A',
        );

        final vote2 = createTestPollVote(
          id: 'answer2',
          answerText: 'Answer B',
        );

        final field1 = vote1.getComparableField(PollVoteSortKey.answerText);
        final field2 = vote2.getComparableField(PollVoteSortKey.answerText);

        expect(field1!.compareTo(field2!), lessThan(0)); // Answer A < Answer B
        expect(field2.compareTo(field1), greaterThan(0)); // Answer B > Answer A
      });
    });
  });
}

/// Helper function to create a PollVote for testing
PollVote createTestPollVote({
  String? id,
  String? pollId,
  String? optionId,
  String? answerText,
  DateTime? createdAt,
  DateTime? updatedAt,
  String? userId,
  User? user,
}) {
  assert(
    optionId != null || answerText != null,
    'Either optionId or answerText must be provided',
  );

  return PollVote(
    id: id,
    pollId: pollId,
    optionId: optionId,
    answerText: answerText,
    createdAt: createdAt ?? DateTime(2023),
    updatedAt: updatedAt ?? DateTime(2023),
    userId: userId,
    user: user,
  );
}
