import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/reaction_dao.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

import '../../stream_chat_persistence_client_test.dart';

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
    final reactions = List.generate(
      count,
      (index) => Reaction(
        type: 'testType$index',
        createdAt: DateTime.now(),
        userId: userId ?? users[index].id,
        messageId: message.id,
        score: count + 3,
        extraData: {'extra_test_field': 'extraTestData'},
      ),
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
  });

  test('getReactionsByUserId', () async {
    const messageId = 'testMessageId';
    const userId = 'testUserId';
    const otherUserId = 'otherUserid';

    // Should be empty initially
    final reactions = await reactionDao.getReactionsByUserId(messageId, userId);
    expect(reactions, isEmpty);

    // Adding sample reactions from the target user.
    final insertedReactions =
        await _prepareReactionData(messageId, userId: userId);
    expect(insertedReactions, isNotEmpty);

    // Adding sample reactions from other users on the same message.
    final otherInsertedReactions =
        await _prepareReactionData(messageId, userId: otherUserId);
    expect(otherInsertedReactions, isNotEmpty);

    // Fetched reaction length should match the target user's reactions only.
    // Every reaction messageId should match the provided messageId.
    // Every reaction userId should match the provided userId — i.e. reactions
    // from other users on the same message must be filtered out.
    final fetchedReactions =
        await reactionDao.getReactionsByUserId(messageId, userId);
    expect(fetchedReactions.length, insertedReactions.length);
    expect(fetchedReactions.every((it) => it.messageId == messageId), true);
    expect(fetchedReactions.every((it) => it.userId == userId), true);
  });

  test('updateReactions', () async {
    const messageId = 'testMessageId';

    // Preparing test data
    final reactions = await _prepareReactionData(messageId);

    // Modifying one of the reaction and also adding one new
    final copyReaction = reactions.first.copyWith(score: 33);
    final newReaction = Reaction(
      type: 'testType3',
      createdAt: DateTime.now(),
      userId: 'testUserId3',
      messageId: messageId,
      score: 30,
      extraData: {'extra_test_field': 'extraTestData'},
    );

    await reactionDao.updateReactions([copyReaction, newReaction]);

    // Fetched reaction length should be one more than inserted reactions.
    // copyReaction `score` modified field should be 33.
    // Fetched reactions should contain the newReaction.
    final fetchedReactions = await reactionDao.getReactions(messageId);
    expect(fetchedReactions.length, reactions.length + 1);
    expect(
      fetchedReactions
          .firstWhere((it) =>
              it.userId == copyReaction.userId && it.type == copyReaction.type)
          .score,
      33,
    );
    expect(
      fetchedReactions
          .where((it) =>
              it.userId == newReaction.userId && it.type == newReaction.type)
          .isNotEmpty,
      true,
    );
  });

  test('getReactionsForMessages chunks transparently when given >900 ids',
      () async {
    // 1,200 ids exceeds the historical SQLITE_MAX_VARIABLE_NUMBER cap (999)
    // for a single `WHERE messageId IN (?, ?, ...)` statement — the helper
    // must run the SELECT in chunks and merge.
    const cid = 'test:ChunkedReactions';
    const total = 1200;

    final dbUser = User(id: 'testUserId');
    await database.userDao.updateUsers([dbUser]);
    await database.channelDao.updateChannels([ChannelModel(cid: cid)]);

    final baseTime = DateTime.now();
    final messages = List.generate(
      total,
      (i) => Message(
        id: 'cmsg-$i',
        user: dbUser,
        text: 'Hello $i',
        createdAt: baseTime.add(Duration(seconds: i)),
      ),
    );
    await database.messageDao.updateMessages(cid, messages);

    // Seed 1 reaction on every odd-indexed message (600 total) so we can
    // verify both that the chunked query returns rows AND that ids without
    // reactions still appear in the dense map with an empty list.
    final reactions = [
      for (var i = 0; i < total; i++)
        if (i.isOdd)
          Reaction(
            type: 'like',
            messageId: messages[i].id,
            user: dbUser,
            createdAt: baseTime.add(Duration(seconds: i)),
          ),
    ];
    await reactionDao.updateReactions(reactions);

    final ids = messages.map((m) => m.id).toList();
    final grouped = await reactionDao.getReactionsForMessages(ids);

    expect(grouped, hasLength(total),
        reason: 'every input id must be a key (dense-map contract)');
    var withReactions = 0;
    var empty = 0;
    for (var i = 0; i < total; i++) {
      final list = grouped['cmsg-$i'];
      expect(list, isNotNull);
      if (i.isOdd) {
        expect(list, hasLength(1));
        expect(list!.first.messageId, 'cmsg-$i');
        withReactions++;
      } else {
        expect(list, isEmpty);
        empty++;
      }
    }
    expect(withReactions, total ~/ 2);
    expect(empty, total ~/ 2);
  });

  test(
      'getReactions returns empty for a message id with no reactions, '
      'even when reactions exist for other messages', () async {
    // Locks per-id isolation: the upcoming batched `WHERE messageId IN (...)`
    // path must not leak rows across ids when only one is queried.
    const messageWithReactions = 'msg-A';
    const messageWithoutReactions = 'msg-B';

    await _prepareReactionData(messageWithReactions);

    final fetched = await reactionDao.getReactions(messageWithoutReactions);
    expect(fetched, isEmpty);
  });

  group('getReactionsForMessagesByUserId', () {
    test('returns empty map for empty input ids', () async {
      final result = await reactionDao
          .getReactionsForMessagesByUserId(const [], 'someUser');
      expect(result, isEmpty);
    });

    test(
        "returns the given user's reactions per message id; message ids "
        'with no reactions from that user map to an empty list', () async {
      const cid = 'test:Cid';
      const targetUser = 'targetUser';
      const otherUser = 'otherUser';
      const msgWithOwn = 'msg-with-own';
      const msgWithoutOwn = 'msg-without-own';
      const msgUnknown = 'msg-unknown';

      final users = [User(id: targetUser), User(id: otherUser)];
      await database.userDao.updateUsers(users);
      await database.channelDao.updateChannels([ChannelModel(cid: cid)]);
      await database.messageDao.updateMessages(cid, [
        Message(
          id: msgWithOwn,
          user: users.first,
          createdAt: DateTime.now(),
          text: 'a',
        ),
        Message(
          id: msgWithoutOwn,
          user: users.first,
          createdAt: DateTime.now(),
          text: 'b',
        ),
      ]);
      // msgWithOwn: 1 own + 1 other; msgWithoutOwn: only other-user reaction.
      await reactionDao.updateReactions([
        Reaction(
          type: 'like',
          messageId: msgWithOwn,
          userId: targetUser,
          createdAt: DateTime.now(),
        ),
        Reaction(
          type: 'wow',
          messageId: msgWithOwn,
          userId: otherUser,
          createdAt: DateTime.now(),
        ),
        Reaction(
          type: 'love',
          messageId: msgWithoutOwn,
          userId: otherUser,
          createdAt: DateTime.now(),
        ),
      ]);

      final result = await reactionDao.getReactionsForMessagesByUserId(
        const [msgWithOwn, msgWithoutOwn, msgUnknown],
        targetUser,
      );

      expect(result.keys,
          unorderedEquals([msgWithOwn, msgWithoutOwn, msgUnknown]));
      expect(result[msgWithOwn], hasLength(1));
      expect(result[msgWithOwn]!.single.userId, targetUser);
      expect(result[msgWithOwn]!.single.type, 'like');
      expect(result[msgWithoutOwn], isEmpty);
      expect(result[msgUnknown], isEmpty);
    });
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
