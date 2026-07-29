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
    await database.messageDao.bulkUpdateMessages({
      cid: [message],
    });
    await reactionDao.updateReactions(reactions);

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

    await reactionDao.updateReactions([copyReaction, newReaction]);

    // Fetched reaction length should be one more than inserted reactions.
    // copyReaction modified fields should match
    // Fetched reactions should contain the newReaction.
    final fetchedReactions = (await reactionDao.getReactionsForMessages(
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

  test('getReactionsForMessages chunks transparently when given >900 ids', () async {
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
    await database.messageDao.bulkUpdateMessages({cid: messages});

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

    expect(grouped, hasLength(total), reason: 'every input id must be a key (dense-map contract)');
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

  test('getReactionsForMessages returns empty list for a message id with no '
      'reactions, even when reactions exist for other messages', () async {
    // Locks per-id isolation: the batched `WHERE messageId IN (...)`
    // path must not leak rows across ids.
    const messageWithReactions = 'msg-A';
    const messageWithoutReactions = 'msg-B';

    await _prepareReactionData(messageWithReactions);

    final fetched = await reactionDao.getReactionsForMessages(
      const [messageWithoutReactions],
    );
    expect(fetched[messageWithoutReactions], isEmpty);
  });

  group('getReactionsForMessagesByUserId', () {
    test('returns empty map for empty input ids', () async {
      final result = await reactionDao.getReactionsForMessagesByUserId(const [], 'someUser');
      expect(result, isEmpty);
    });

    test("returns the given user's reactions per message id; message ids "
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
      await database.messageDao.bulkUpdateMessages({
        cid: [
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
        ],
      });
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

      expect(result.keys, unorderedEquals([msgWithOwn, msgWithoutOwn, msgUnknown]));
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
      final reactions = await reactionDao.getReactionsForMessages(
        [messageId1, messageId2],
      );
      expect(reactions[messageId1]!.length, insertedReactions1.length);
      expect(reactions[messageId2]!.length, insertedReactions2.length);

      // Deleting all the reactions of messageId1
      await reactionDao.deleteReactionsByMessageIds([messageId1]);

      // Fetched reactions length of only messageId1 should be empty
      final fetched = await reactionDao.getReactionsForMessages(
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
      final reactions = await reactionDao.getReactionsForMessages(
        [messageId1, messageId2],
      );
      expect(reactions[messageId1]!.length, insertedReactions1.length);
      expect(reactions[messageId2]!.length, insertedReactions2.length);

      // Deleting all the reactions of messageId1 and messageId2
      await reactionDao.deleteReactionsByMessageIds([messageId1, messageId2]);

      // Fetched reactions length of both messages should be empty
      final fetched = await reactionDao.getReactionsForMessages(
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
