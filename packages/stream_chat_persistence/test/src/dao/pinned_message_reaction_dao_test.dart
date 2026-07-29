import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/pinned_message_reaction_dao.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

import '../../stream_chat_persistence_client_test.dart';
import '../utils/date_matcher.dart';

void main() {
  late PinnedMessageReactionDao pinnedMessageReactionDao;
  late DriftChatDatabase database;

  setUp(() {
    database = testDatabaseProvider('testUserId');
    pinnedMessageReactionDao = database.pinnedMessageReactionDao;
  });

  Future<List<Reaction>> _prepareReactionData(
    String messageId, {
    String? userId,
    int count = 3,
  }) async {
    const cid = 'test:Cid';
    final channels = [ChannelModel(cid: cid)];
    final users = List.generate(count, (index) => User(id: 'testUserId$index'));
    final message = Message(
      id: messageId,
      type: 'testType',
      user: users.first,
      createdAt: DateTime.now(),
      shadowed: math.Random().nextBool(),
      showInChannel: math.Random().nextBool(),
      replyCount: 3,
      updatedAt: DateTime.now(),
      extraData: const {'extra_test_field': 'extraTestData'},
      text: 'Dummy text',
      pinned: math.Random().nextBool(),
      pinnedAt: DateTime.now(),
      pinnedBy: users.first,
    );

    final now = DateTime.now();
    final reactions = List.generate(
      count,
      (index) {
        final createdAt = now.add(Duration(minutes: index));
        return Reaction(
          type: 'testType$index',
          createdAt: createdAt,
          updatedAt: createdAt.add(const Duration(minutes: 5)),
          userId: userId ?? users[index].id,
          messageId: message.id,
          score: count + 3,
          emojiCode: '😂$index',
          extraData: const {'extra_test_field': 'extraTestData'},
        );
      },
    );

    await database.userDao.updateUsers(users);
    await database.channelDao.updateChannels(channels);
    await database.pinnedMessageDao.bulkUpdateMessages({
      cid: [message],
    });
    await pinnedMessageReactionDao.updateReactions(reactions);

    return reactions;
  }

  test('updateReactions', () async {
    const messageId = 'testMessageId';

    // Preparing test data
    final reactions = await _prepareReactionData(messageId);

    // Modifying one of the reaction and also adding one new
    final now = DateTime.now();
    final copyReaction = reactions.first.copyWith(
      score: 33,
      emojiCode: '🎉',
      updatedAt: now,
    );
    final newReaction = Reaction(
      type: 'testType3',
      createdAt: now,
      updatedAt: now.add(const Duration(minutes: 5)),
      userId: 'testUserId3',
      messageId: messageId,
      score: 30,
      emojiCode: '🎈',
      extraData: const {'extra_test_field': 'extraTestData'},
    );

    await pinnedMessageReactionDao.updateReactions([copyReaction, newReaction]);

    // Fetched reaction length should be one more than inserted reactions.
    // copyReaction modified fields should match
    // Fetched reactions should contain the newReaction.
    final fetchedReactions = (await pinnedMessageReactionDao.getReactionsForMessages(
      [messageId],
    ))[messageId]!;
    expect(fetchedReactions.length, reactions.length + 1);

    final fetchedCopyReaction = fetchedReactions.firstWhere(
      (it) => it.userId == copyReaction.userId && it.type == copyReaction.type,
    );
    expect(fetchedCopyReaction.score, 33);
    expect(fetchedCopyReaction.emojiCode, '🎉');
    expect(fetchedCopyReaction.updatedAt, isSameDateAs(now));

    final fetchedNewReaction = fetchedReactions.firstWhere(
      (it) => it.userId == newReaction.userId && it.type == newReaction.type,
    );
    expect(fetchedNewReaction.emojiCode, '🎈');
    expect(
      fetchedNewReaction.updatedAt,
      isSameDateAs(now.add(const Duration(minutes: 5))),
    );
  });

  test('getReactionsForMessages returns empty list for a message id with no '
      'reactions, even when reactions exist for other messages', () async {
    const messageWithReactions = 'pmsg-A';
    const messageWithoutReactions = 'pmsg-B';

    await _prepareReactionData(messageWithReactions);

    final fetched = await pinnedMessageReactionDao.getReactionsForMessages(
      const [messageWithoutReactions],
    );
    expect(fetched[messageWithoutReactions], isEmpty);
  });

  group('deleteReactionsByMessageIds', () {
    const messageId1 = 'testMessageId1';
    const messageId2 = 'testMessageId2';
    test('should delete all the reactions of first message', () async {
      // Preparing test data
      final insertedReactions1 = await _prepareReactionData(messageId1);
      final insertedReactions2 = await _prepareReactionData(messageId2);

      // Fetched reaction list length should match
      // the inserted reactions list length
      final reactions = await pinnedMessageReactionDao.getReactionsForMessages(
        [messageId1, messageId2],
      );
      expect(reactions[messageId1]!.length, insertedReactions1.length);
      expect(reactions[messageId2]!.length, insertedReactions2.length);

      // Deleting all the reactions of messageId1
      await pinnedMessageReactionDao.deleteReactionsByMessageIds([messageId1]);

      // Fetched reactions length of only messageId1 should be empty
      final fetched = await pinnedMessageReactionDao.getReactionsForMessages(
        [messageId1, messageId2],
      );
      expect(fetched[messageId1], isEmpty);
      expect(fetched[messageId2], isNotEmpty);
    });

    test('should delete all the reactions of both message', () async {
      // Preparing test data
      final insertedReactions1 = await _prepareReactionData(messageId1);
      final insertedReactions2 = await _prepareReactionData(messageId2);

      // Fetched reaction list length should match
      // the inserted reactions list length
      final reactions = await pinnedMessageReactionDao.getReactionsForMessages(
        [messageId1, messageId2],
      );
      expect(reactions[messageId1]!.length, insertedReactions1.length);
      expect(reactions[messageId2]!.length, insertedReactions2.length);

      // Deleting all the reactions of messageId1 and messageId2
      await pinnedMessageReactionDao.deleteReactionsByMessageIds(
        [messageId1, messageId2],
      );

      // Fetched reactions length of both messages should be empty
      final fetched = await pinnedMessageReactionDao.getReactionsForMessages(
        [messageId1, messageId2],
      );
      expect(fetched[messageId1], isEmpty);
      expect(fetched[messageId2], isEmpty);
    });
  });

  tearDown(() async {
    await database.disconnect();
  });
}
