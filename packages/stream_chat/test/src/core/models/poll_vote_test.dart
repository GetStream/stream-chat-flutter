import 'package:stream_chat/src/core/models/poll_vote.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('PollVote.isAnswer is true for a vote that carries answer text', () {
    final answer = createTestPollVote(answerText: 'Anything');

    expect(answer.isAnswer, isTrue);
  });

  test('PollVote.isAnswer is false for a vote for an option', () {
    final vote = createTestPollVote(optionId: 'pizza');

    expect(vote.isAnswer, isFalse);
  });

  test('PollVote.copyWith sets a timestamp set to null to the current time', () {
    final vote = createTestPollVote(optionId: 'pizza', createdAt: DateTime.utc(2023), updatedAt: DateTime.utc(2023));
    final before = DateTime.now();

    final copy = vote.copyWith(createdAt: null, updatedAt: null);

    expect(copy.createdAt.isBefore(before), isFalse);
    expect(copy.updatedAt.isBefore(before), isFalse);
  });

  test('PollVoteSortField.id orders alphabetically', () {
    expectOrders(
      PollVoteSortField.id,
      createTestPollVote(id: 'a-vote', optionId: 'o'),
      createTestPollVote(id: 'b-vote', optionId: 'o'),
    );
  });

  test('PollVoteSortField.createdAt orders older votes first', () {
    expectOrders(
      PollVoteSortField.createdAt,
      createTestPollVote(optionId: 'o', createdAt: DateTime(2023, 6, 10)),
      createTestPollVote(optionId: 'o', createdAt: DateTime(2023, 6, 15)),
    );
  });

  test('PollVoteSortField.updatedAt orders older votes first', () {
    expectOrders(
      PollVoteSortField.updatedAt,
      createTestPollVote(optionId: 'o', updatedAt: DateTime(2023, 6, 10)),
      createTestPollVote(optionId: 'o', updatedAt: DateTime(2023, 6, 15)),
    );
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
