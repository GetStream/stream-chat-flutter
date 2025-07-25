import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/mapper/reaction_mapper.dart';

import '../utils/date_matcher.dart';

void main() {
  test('toReaction should map the entity into Reaction', () {
    final user = User(id: 'testUserId');
    final message = Message(id: 'testMessageId');
    final now = DateTime.now();
    final entity = ReactionEntity(
      userId: user.id,
      messageId: message.id,
      type: 'haha',
      score: 33,
      emojiCode: '😂',
      createdAt: now,
      updatedAt: now.add(const Duration(minutes: 5)),
      extraData: {'extra_test_data': 'extraData'},
    );

    final reaction = entity.toReaction(user: user);
    expect(reaction, isA<Reaction>());
    expect(reaction.userId, entity.userId);
    expect(reaction.messageId, entity.messageId);
    expect(reaction.type, entity.type);
    expect(reaction.score, entity.score);
    expect(reaction.emojiCode, entity.emojiCode);
    expect(reaction.createdAt, isSameDateAs(entity.createdAt));
    expect(reaction.updatedAt, isSameDateAs(entity.updatedAt));
    expect(reaction.extraData, entity.extraData);
  });

  test('toEntity should map reaction into ReactionEntity', () {
    final user = User(id: 'testUserId');
    final message = Message(id: 'testMessageId');
    final now = DateTime.now();
    final reaction = Reaction(
      userId: user.id,
      messageId: message.id,
      type: 'haha',
      score: 33,
      emojiCode: '😂',
      createdAt: now,
      updatedAt: now.add(const Duration(minutes: 5)),
      extraData: const {'extra_test_data': 'extraData'},
    );

    final entity = reaction.toEntity();
    expect(entity, isA<ReactionEntity>());
    expect(entity.userId, reaction.userId);
    expect(entity.messageId, reaction.messageId);
    expect(entity.type, reaction.type);
    expect(entity.score, reaction.score);
    expect(entity.emojiCode, reaction.emojiCode);
    expect(entity.createdAt, isSameDateAs(reaction.createdAt));
    expect(entity.updatedAt, isSameDateAs(reaction.updatedAt));
    expect(entity.extraData, reaction.extraData);
  });
}
