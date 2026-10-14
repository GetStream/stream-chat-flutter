import 'package:stream_chat/src/core/models/poll_vote.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/poll_vote', () {
    test('does not send the server translation of the answer back when serialized', () {
      final pollVote = PollVote(
        answerText: 'great',
        answerTextI18n: const {'language': 'en', 'nl_text': 'geweldig'},
      );

      expect(pollVote.toJson(), isNot(contains('answer_text_i18n')));
    });

    group('PollVoteSortField', () {
      test('id orders alphabetically', () {
        expectOrders(
          PollVoteSortField.id,
          createTestPollVote(id: 'a-vote', optionId: 'o'),
          createTestPollVote(id: 'b-vote', optionId: 'o'),
        );
      });

      test('createdAt orders older votes first', () {
        expectOrders(
          PollVoteSortField.createdAt,
          createTestPollVote(optionId: 'o', createdAt: DateTime(2023, 6, 10)),
          createTestPollVote(optionId: 'o', createdAt: DateTime(2023, 6, 15)),
        );
      });

      test('updatedAt orders older votes first', () {
        expectOrders(
          PollVoteSortField.updatedAt,
          createTestPollVote(optionId: 'o', updatedAt: DateTime(2023, 6, 10)),
          createTestPollVote(optionId: 'o', updatedAt: DateTime(2023, 6, 15)),
        );
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
