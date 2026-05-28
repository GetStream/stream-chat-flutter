import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/reaction_dao.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

import '../../stream_chat_persistence_client_test.dart';
import '../utils/date_matcher.dart';

void main() {
  late ReactionDao reactionDao;
  late DriftChatDatabase database;

  setUp(() {
    database = testDatabaseProvider('testUserId');
    reactionDao = database.reactionDao;
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
    await database.messageDao.updateMessages(cid, [message]);
    await reactionDao.updateReactions(reactions);

    return reactions;
  }

  test('getReactions', () async {
    const messageId = 'testMessageId';

    // Should be empty initially
    final reactions = await reactionDao.getReactions(messageId);
    expect(reactions, isEmpty);

    // Adding sample reactions
    final insertedReactions = await _prepareReactionData(messageId);
    expect(insertedReactions, isNotEmpty);

    // Fetched reaction length should match inserted reactions length.
    // Every reaction messageId should match the provided messageId.
    final fetchedReactions = await reactionDao.getReactions(messageId);
    expect(fetchedReactions.length, insertedReactions.length);
    expect(fetchedReactions.every((it) => it.messageId == messageId), true);

    // Verify score and emojiCode are preserved
    for (var i = 0; i < fetchedReactions.length; i++) {
      final inserted = insertedReactions[i];
      final fetched = fetchedReactions[i];
      expect(fetched.score, inserted.score);
      expect(fetched.emojiCode, inserted.emojiCode);
    }
  });

  test('getReactionsByUserId', () async {
    const messageId = 'testMessageId';
    const userId = 'testUserId';

    // Should be empty initially
    final reactions = await reactionDao.getReactionsByUserId(messageId, userId);
    expect(reactions, isEmpty);

    // Adding sample reactions
    final insertedReactions = await _prepareReactionData(messageId, userId: userId);
    expect(insertedReactions, isNotEmpty);

    // Fetched reaction length should match inserted reactions length.
    // Every reaction messageId should match the provided messageId.
    // Every reaction userId should match the provided userId.
    final fetchedReactions = await reactionDao.getReactionsByUserId(messageId, userId);
    expect(fetchedReactions.length, insertedReactions.length);
    expect(fetchedReactions.every((it) => it.messageId == messageId), true);
    expect(fetchedReactions.every((it) => it.userId == userId), true);

    // Verify score and emojiCode are preserved
    for (var i = 0; i < fetchedReactions.length; i++) {
      final inserted = insertedReactions[i];
      final fetched = fetchedReactions[i];
      expect(fetched.score, inserted.score);
      expect(fetched.emojiCode, inserted.emojiCode);
    }
  });

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

    await reactionDao.updateReactions([copyReaction, newReaction]);

    // Fetched reaction length should be one more than inserted reactions.
    // copyReaction modified fields should match
    // Fetched reactions should contain the newReaction.
    final fetchedReactions = await reactionDao.getReactions(messageId);
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

  group('deleteReactionsByMessageIds', () {
    const messageId1 = 'testMessageId1';
    const messageId2 = 'testMessageId2';
    test('should delete all the reactions of first message', () async {
      // Preparing test data
      final insertedReactions1 = await _prepareReactionData(messageId1);
      final insertedReactions2 = await _prepareReactionData(messageId2);

      // Fetched reaction list length should match
      // the inserted reactions list length
      final reactions1 = await reactionDao.getReactions(messageId1);
      final reactions2 = await reactionDao.getReactions(messageId2);
      expect(reactions1.length, insertedReactions1.length);
      expect(reactions2.length, insertedReactions2.length);

      // Deleting all the reactions of messageId1
      await reactionDao.deleteReactionsByMessageIds([messageId1]);

      // Fetched reactions length of only messageId1 should be empty
      final fetchedReactions1 = await reactionDao.getReactions(messageId1);
      final fetchedReactions2 = await reactionDao.getReactions(messageId2);
      expect(fetchedReactions1, isEmpty);
      expect(fetchedReactions2, isNotEmpty);
    });

    test('should delete all the reactions of both message', () async {
      // Preparing test data
      final insertedReactions1 = await _prepareReactionData(messageId1);
      final insertedReactions2 = await _prepareReactionData(messageId2);

      // Fetched reaction list length should match
      // the inserted reactions list length
      final reactions1 = await reactionDao.getReactions(messageId1);
      final reactions2 = await reactionDao.getReactions(messageId2);
      expect(reactions1.length, insertedReactions1.length);
      expect(reactions2.length, insertedReactions2.length);

      // Deleting all the reactions of messageId1 and messageId2
      await reactionDao.deleteReactionsByMessageIds([messageId1, messageId2]);

      // Fetched reactions length of both messages should be empty
      final fetchedReactions1 = await reactionDao.getReactions(messageId1);
      final fetchedReactions2 = await reactionDao.getReactions(messageId2);
      expect(fetchedReactions1, isEmpty);
      expect(fetchedReactions2, isEmpty);
    });
  });

  tearDown(() async {
    await database.disconnect();
  });
}
