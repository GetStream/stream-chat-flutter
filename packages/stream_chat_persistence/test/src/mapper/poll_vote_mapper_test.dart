import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/mapper/poll_vote_mapper.dart';

import '../utils/date_matcher.dart';

void main() {
  test('toPollVote should map entity into PollVote', () {
    final currentUser = User(id: 'curr-user', name: 'Current User');
    final entity = PollVoteEntity(
      id: 'poll-vote-1',
      pollId: 'poll-1',
      optionId: 'option-1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: currentUser.id,
    );
    final pollVote = entity.toPollVote(user: currentUser);

    expect(pollVote, isA<PollVote>());
    expect(pollVote.id, entity.id);
    expect(pollVote.pollId, entity.pollId);
    expect(pollVote.optionId, entity.optionId);
    expect(pollVote.answerText, entity.answerText);
    expect(pollVote.createdAt, isSameDateAs(entity.createdAt));
    expect(pollVote.updatedAt, isSameDateAs(entity.updatedAt));
    expect(pollVote.userId, entity.userId);
  });

  test('toEntity should map pollVote into PollVote', () {
    final currentUser = User(id: 'curr-user', name: 'Current User');
    final pollVote = PollVote(
      id: 'poll-vote-1',
      pollId: 'poll-1',
      optionId: 'option-1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: currentUser.id,
      user: currentUser,
    );
    final entity = pollVote.toEntity();
    expect(entity, isA<PollVoteEntity>());
    expect(entity.id, pollVote.id);
    expect(entity.pollId, pollVote.pollId);
    expect(entity.optionId, pollVote.optionId);
    expect(entity.answerText, pollVote.answerText);
    expect(entity.createdAt, isSameDateAs(pollVote.createdAt));
    expect(entity.updatedAt, isSameDateAs(pollVote.updatedAt));
    expect(entity.userId, pollVote.userId);
  });
}
