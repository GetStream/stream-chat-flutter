import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/dao.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

import '../../stream_chat_persistence_client_test.dart';

void main() {
  late PinnedMessageDao pinnedMessageDao;
  late DriftChatDatabase database;

  setUp(() {
    database = testDatabaseProvider('testUserId');
    pinnedMessageDao = database.pinnedMessageDao;
  });

  Future<List<Message>> _prepareTestData(
    String cid, {
    bool quoted = false,
    bool threads = false,
    bool mapAllThreadToFirstMessage = false,
    int count = 3,
  }) async {
    final channels = [ChannelModel(cid: cid)];
    final users = List.generate(count, (index) => User(id: 'testUserId$index'));
    // Strictly monotonic `createdAt` per message so SQL-side pagination
    // filters (`WHERE createdAt < cutoff`, `ORDER BY createdAt ASC`) can't be
    // confused by ties. Drift stores `DateTime` as integer Unix seconds by
    // default, so the offset must be at least 1 second per row — otherwise
    // sub-second offsets all round-trip onto the same second.
    final baseTime = DateTime.now();
    final messages = List.generate(
      count,
      (index) => Message(
        id: 'testMessageId$cid$index',
        type: 'testType',
        user: users[index],
        channelRole: 'channel_member',
        createdAt: baseTime.add(Duration(seconds: index)),
        shadowed: math.Random().nextBool(),
        replyCount: index,
        updatedAt: DateTime.now(),
        extraData: const {'extra_test_field': 'extraTestData'},
        text: 'Dummy text #$index',
        pinned: math.Random().nextBool(),
        pinnedAt: DateTime.now(),
        pinnedBy: User(id: 'testUserId$index'),
        reactionGroups: {
          'testType': ReactionGroup(count: 3, sumScores: 10),
          'testType2': ReactionGroup(count: 5, sumScores: 20),
        },
      ),
    );
    final quotedMessages = List.generate(
      count,
      (index) => Message(
        id: 'testQuotedMessageId$cid$index',
        type: 'testType',
        user: users[index],
        channelRole: 'channel_member',
        createdAt: baseTime.add(Duration(seconds: index)),
        shadowed: math.Random().nextBool(),
        replyCount: index,
        updatedAt: DateTime.now(),
        extraData: const {'extra_test_field': 'extraTestData'},
        text: 'Dummy text #$index',
        quotedMessageId: messages[index].id,
        pinned: math.Random().nextBool(),
        pinnedAt: DateTime.now(),
        pinnedBy: User(id: 'testUserId$index'),
      ),
    );
    final threadMessages = List.generate(
      count,
      (index) => Message(
        id: 'testThreadMessageId$cid$index',
        type: 'testType',
        user: users[index],
        channelRole: 'channel_member',
        parentId:
            mapAllThreadToFirstMessage ? messages[0].id : messages[index].id,
        createdAt: baseTime.add(Duration(seconds: index)),
        shadowed: math.Random().nextBool(),
        replyCount: index,
        updatedAt: DateTime.now(),
        extraData: const {'extra_test_field': 'extraTestData'},
        text: 'Dummy text #$index',
        pinned: math.Random().nextBool(),
        pinnedAt: DateTime.now(),
        pinnedBy: User(id: 'testUserId$index'),
      ),
    );
    final allMessages = [
      ...messages,
      if (quoted) ...quotedMessages,
      if (threads) ...threadMessages
    ];
    final reaction = Reaction(
      type: 'type',
      messageId: allMessages.first.id,
      user: users.first,
    );
    await database.userDao.updateUsers(users);
    await database.channelDao.updateChannels(channels);
    await pinnedMessageDao.updateMessages(cid, allMessages);
    await database.pinnedMessageReactionDao.updateReactions([reaction]);
    return allMessages;
  }

  test('deleteMessageByIds', () async {
    const cid = 'test:Cid';

    // Preparing test data
    final insertedMessages = await _prepareTestData(cid);

    // Fetched message list should match the test message list length
    final messages = await pinnedMessageDao.getMessagesByCid(cid);
    expect(messages.length, insertedMessages.length);

    final firstMessageId = messages.first.id;

    // Fetched reactions list should have one reaction for given message id
    final reactions =
        await database.pinnedMessageReactionDao.getReactions(firstMessageId);
    expect(reactions.length, 1);

    // Deleting 2 messages from DB
    await pinnedMessageDao.deleteMessageByIds(
      [firstMessageId, 'testMessageId${cid}1'],
    );

    // New fetched messages length should 2 less than the
    // previous fetched messages
    final newMessages = await pinnedMessageDao.getMessagesByCid(cid);
    expect(newMessages.length, messages.length - 2);

    // Reaction for the first message should be deleted too
    final newReactions =
        await database.pinnedMessageReactionDao.getReactions(firstMessageId);
    expect(newReactions, isEmpty);
  });

  group('deleteMessageByCids', () {
    const cid1 = 'test:Cid1';
    const cid2 = 'test:Cid2';

    test(
      'should delete all the messages and reactions of first channel',
      () async {
        // Preparing test data
        final cid1InsertedMessages = await _prepareTestData(cid1);
        final cid2InsertedMessages = await _prepareTestData(cid2);

        // Fetched message list should match the test message list length
        final cid1Messages = await pinnedMessageDao.getMessagesByCid(cid1);
        final cid2Messages = await pinnedMessageDao.getMessagesByCid(cid2);
        expect(cid1Messages.length, cid1InsertedMessages.length);
        expect(cid2Messages.length, cid2InsertedMessages.length);

        // Fetched reactions list should have one reaction for given message id
        final cid1firstMessageId = cid1Messages.first.id;
        final cid1Reactions = await database.pinnedMessageReactionDao
            .getReactions(cid1firstMessageId);
        expect(cid1Reactions.length, 1);

        // Deleting all the messages of cid1
        await pinnedMessageDao.deleteMessageByCids([cid1]);

        // Fetched messages length of only cid1 should be empty
        final cid1FetchedMessages =
            await pinnedMessageDao.getMessagesByCid(cid1);
        final cid2FetchedMessages =
            await pinnedMessageDao.getMessagesByCid(cid2);
        expect(cid1FetchedMessages, isEmpty);
        expect(cid2FetchedMessages, isNotEmpty);

        // Reaction for the first message should be deleted too
        final cid1FetchedReactions = await database.pinnedMessageReactionDao
            .getReactions(cid1firstMessageId);
        expect(cid1FetchedReactions, isEmpty);
      },
    );

    test(
      'should delete all the messages and reactions of both channel',
      () async {
        // Preparing test data
        final cid1InsertedMessages = await _prepareTestData(cid1);
        final cid2InsertedMessages = await _prepareTestData(cid2);

        // Fetched message list should match the test message list length
        final cid1Messages = await pinnedMessageDao.getMessagesByCid(cid1);
        final cid2Messages = await pinnedMessageDao.getMessagesByCid(cid2);
        expect(cid1Messages.length, cid1InsertedMessages.length);
        expect(cid2Messages.length, cid2InsertedMessages.length);

        // Fetched reactions list should have one reaction for given message id
        final cid1FirstMessageId = cid1Messages.first.id;
        final cid1Reactions = await database.pinnedMessageReactionDao
            .getReactions(cid1FirstMessageId);
        expect(cid1Reactions.length, 1);
        final cid2FirstMessageId = cid2Messages.first.id;
        final cid2Reactions = await database.pinnedMessageReactionDao
            .getReactions(cid2FirstMessageId);
        expect(cid2Reactions.length, 1);

        // Deleting all the messages of cid1
        await pinnedMessageDao.deleteMessageByCids([cid1, cid2]);

        // Fetched messages length of both cid1 and cid2 should be empty
        final cid1FetchedMessages =
            await pinnedMessageDao.getMessagesByCid(cid1);
        final cid2FetchedMessages =
            await pinnedMessageDao.getMessagesByCid(cid2);
        expect(cid1FetchedMessages, isEmpty);
        expect(cid2FetchedMessages, isEmpty);

        // Reaction for the first message should be deleted too
        final cid1FetchedReactions = await database.pinnedMessageReactionDao
            .getReactions(cid1FirstMessageId);
        expect(cid1FetchedReactions, isEmpty);
        final cid2FetchedReactions = await database.pinnedMessageReactionDao
            .getReactions(cid2FirstMessageId);
        expect(cid2FetchedReactions, isEmpty);
      },
    );
  });

  test('getMessageById', () async {
    const cid = 'test:Cid';
    const id = 'testMessageId${cid}0';

    // Should be null initially
    final message = await pinnedMessageDao.getMessageById(id);
    expect(message, isNull);

    // Adding test message with the cid and id
    final insertedMessages = await _prepareTestData(cid, count: 1);
    expect(insertedMessages.first.id, id);

    // Fetched message id should match the inserted message id
    final fetchedMessage = await pinnedMessageDao.getMessageById(id);
    expect(fetchedMessage, isNotNull);
    expect(fetchedMessage!.id, insertedMessages.first.id);
  });

  test('getThreadMessages', () async {
    const cid = 'test:Cid';

    // Messages should be empty initially
    final messages = await pinnedMessageDao.getThreadMessages(cid);
    expect(messages, isEmpty);

    // Preparing test data
    final insertedMessages = await _prepareTestData(cid, threads: true);
    expect(insertedMessages, isNotEmpty);

    // Should fetch all the thread messages of cid
    final threadMessages = await pinnedMessageDao.getThreadMessages(cid);
    expect(threadMessages, isNotEmpty);
    for (final message in threadMessages) {
      expect(message.parentId, isNotNull);
    }
  });

  test('getThreadMessagesByParentId', () async {
    const cid = 'test:Cid';
    const parentId = 'testMessageId${cid}0';

    // Messages should be empty initially
    final messages =
        await pinnedMessageDao.getThreadMessagesByParentId(parentId);
    expect(messages, isEmpty);

    // Preparing test data
    final insertedMessages = await _prepareTestData(cid, threads: true);
    expect(insertedMessages, isNotEmpty);

    // Should fetch all the thread messages of parentId
    final threadMessages =
        await pinnedMessageDao.getThreadMessagesByParentId(parentId);
    expect(threadMessages.length, 1);
    expect(threadMessages.first.parentId, parentId);
  });

  test('getThreadMessagesByParentId along with pagination', () async {
    const cid = 'test:Cid';
    const parentId = 'testMessageId${cid}0';
    const options = PaginationParams(
      limit: 15,
      lessThan: 'testThreadMessageId${cid}25',
      greaterThanOrEqual: 'testThreadMessageId${cid}5',
    );

    // Messages should be empty initially
    final messages = await pinnedMessageDao.getThreadMessagesByParentId(
      parentId,
      options: options,
    );
    expect(messages, isEmpty);

    // Preparing test data
    final insertedMessages = await _prepareTestData(
      cid,
      threads: true,
      mapAllThreadToFirstMessage: true,
      count: 30,
    );
    expect(insertedMessages, isNotEmpty);

    // Should fetch all the thread messages of parentId and apply the pagination
    final threadMessages = await pinnedMessageDao.getThreadMessagesByParentId(
      parentId,
      options: options,
    );
    expect(threadMessages.length, 15);
    expect(threadMessages.first.parentId, parentId);
  });

  test('getMessagesByCid', () async {
    const cid = 'test:Cid';

    // Should be empty initially
    final messages = await pinnedMessageDao.getMessagesByCid(cid);
    expect(messages, isEmpty);

    // Preparing test data
    final insertedMessages = await _prepareTestData(cid);
    expect(insertedMessages, isNotEmpty);

    // Fetched message should match the inserted messages
    final fetchedMessages = await pinnedMessageDao.getMessagesByCid(cid);
    expect(fetchedMessages.length, insertedMessages.length);
    for (var i = 0; i < fetchedMessages.length; i++) {
      final fetchedMessage = fetchedMessages[i];
      final insertedMessage = insertedMessages[i];
      expect(fetchedMessage.id, insertedMessage.id);
    }
  });

  test('getMessagesByCid along with quotedMessage', () async {
    const cid = 'test:Cid';

    // Should be empty initially
    final messages = await pinnedMessageDao.getMessagesByCid(cid);
    expect(messages, isEmpty);

    // Preparing test data
    final insertedMessages = await _prepareTestData(cid, quoted: true);
    expect(insertedMessages, isNotEmpty);

    // Fetched message should match the inserted messages
    final fetchedMessages = await pinnedMessageDao.getMessagesByCid(cid);
    expect(fetchedMessages.length, insertedMessages.length);
    final quoted = fetchedMessages.where((it) => it.quotedMessage != null);
    expect(quoted.length, insertedMessages.length / 2);
  });

  test('getMessagesByCid along with pagination', () async {
    const cid = 'test:Cid';
    const limit = 15;
    const lessThan = 'testMessageId${cid}25';
    const greaterThan = 'testMessageId${cid}5';
    const pagination = PaginationParams(
      limit: limit,
      lessThan: lessThan,
      greaterThan: greaterThan,
    );

    // Should be empty initially
    final messages = await pinnedMessageDao.getMessagesByCid(
      cid,
      messagePagination: pagination,
    );
    expect(messages, isEmpty);

    // Preparing test data
    final insertedMessages = await _prepareTestData(cid, count: 30);
    expect(insertedMessages, isNotEmpty);

    // Fetched message should match the inserted messages
    final fetchedMessages = await pinnedMessageDao.getMessagesByCid(
      cid,
      messagePagination: pagination,
    );
    expect(fetchedMessages.length, limit);
    expect(fetchedMessages.first.id, 'testMessageId${cid}10');
    expect(fetchedMessages.last.id, 'testMessageId${cid}24');
  });

  group('getMessagesByCid pagination', () {
    const cid = 'test:Cid';

    test('lessThan only trims messages from the end', () async {
      await _prepareTestData(cid, count: 30);

      final fetchedMessages = await pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          limit: 100,
          lessThan: 'testMessageId${cid}25',
        ),
      );

      expect(fetchedMessages.length, 25);
      expect(fetchedMessages.first.id, 'testMessageId${cid}0');
      expect(fetchedMessages.last.id, 'testMessageId${cid}24');
    });

    test('greaterThan only trims messages from the start (exclusive)',
        () async {
      await _prepareTestData(cid, count: 30);

      final fetchedMessages = await pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          limit: 100,
          greaterThan: 'testMessageId${cid}5',
        ),
      );

      expect(fetchedMessages.length, 24);
      expect(fetchedMessages.first.id, 'testMessageId${cid}6');
      expect(fetchedMessages.last.id, 'testMessageId${cid}29');
    });

    test('limit only keeps the last N messages', () async {
      await _prepareTestData(cid, count: 30);

      final fetchedMessages = await pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(limit: 15),
      );

      expect(fetchedMessages.length, 15);
      expect(fetchedMessages.first.id, 'testMessageId${cid}15');
      expect(fetchedMessages.last.id, 'testMessageId${cid}29');
    });

    test('lessThan id not in result set is a no-op', () async {
      await _prepareTestData(cid, count: 30);

      final fetchedMessages = await pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          limit: 100,
          lessThan: 'missing-id',
        ),
      );

      expect(fetchedMessages.length, 30);
      expect(fetchedMessages.first.id, 'testMessageId${cid}0');
      expect(fetchedMessages.last.id, 'testMessageId${cid}29');
    });

    test('greaterThan id not in result set is a no-op', () async {
      await _prepareTestData(cid, count: 30);

      final fetchedMessages = await pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          limit: 100,
          greaterThan: 'missing-id',
        ),
      );

      expect(fetchedMessages.length, 30);
      expect(fetchedMessages.first.id, 'testMessageId${cid}0');
      expect(fetchedMessages.last.id, 'testMessageId${cid}29');
    });

    test('thread-reply id as cursor is a no-op (not visible in channel)',
        () async {
      // `_prepareTestData` inserts thread replies with `parentId` set and
      // `showInChannel` left null — i.e. not visible in the channel query.
      // Passing such an id as a cursor must resolve to a no-op so the main
      // query falls back to returning the full channel slice.
      await _prepareTestData(cid, count: 30, threads: true);

      final fetchedMessages = await pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          limit: 100,
          lessThan: 'testThreadMessageId${cid}5',
        ),
      );

      expect(fetchedMessages.length, 30);
      expect(fetchedMessages.first.id, 'testMessageId${cid}0');
      expect(fetchedMessages.last.id, 'testMessageId${cid}29');
    });

    test('default PaginationParams() applies implicit limit of 10', () async {
      await _prepareTestData(cid, count: 30);

      final fetchedMessages = await pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(),
      );

      expect(fetchedMessages.length, 10);
      expect(fetchedMessages.first.id, 'testMessageId${cid}20');
      expect(fetchedMessages.last.id, 'testMessageId${cid}29');
    });

    test('default limit + lessThan returns last 10 of filtered set', () async {
      await _prepareTestData(cid, count: 30);

      final fetchedMessages = await pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          lessThan: 'testMessageId${cid}25',
        ),
      );

      expect(fetchedMessages.length, 10);
      expect(fetchedMessages.first.id, 'testMessageId${cid}15');
      expect(fetchedMessages.last.id, 'testMessageId${cid}24');
    });

    test('default limit + greaterThan returns first 10 after the pivot',
        () async {
      await _prepareTestData(cid, count: 30);

      final fetchedMessages = await pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          greaterThan: 'testMessageId${cid}5',
        ),
      );

      expect(fetchedMessages.length, 10);
      expect(fetchedMessages.first.id, 'testMessageId${cid}6');
      expect(fetchedMessages.last.id, 'testMessageId${cid}15');
    });

    test('lessThanOrEqual is inclusive of the pivot', () async {
      await _prepareTestData(cid, count: 30);

      final fetchedMessages = await pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          limit: 100,
          lessThanOrEqual: 'testMessageId${cid}25',
        ),
      );

      expect(fetchedMessages.length, 26);
      expect(fetchedMessages.first.id, 'testMessageId${cid}0');
      expect(fetchedMessages.last.id, 'testMessageId${cid}25');
    });

    test('greaterThanOrEqual is inclusive of the pivot', () async {
      await _prepareTestData(cid, count: 30);

      final fetchedMessages = await pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          limit: 100,
          greaterThanOrEqual: 'testMessageId${cid}5',
        ),
      );

      expect(fetchedMessages.length, 25);
      expect(fetchedMessages.first.id, 'testMessageId${cid}5');
      expect(fetchedMessages.last.id, 'testMessageId${cid}29');
    });

    test('default limit + lessThanOrEqual returns the pivot and 9 before',
        () async {
      await _prepareTestData(cid, count: 30);

      final fetchedMessages = await pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          lessThanOrEqual: 'testMessageId${cid}25',
        ),
      );

      expect(fetchedMessages.length, 10);
      expect(fetchedMessages.first.id, 'testMessageId${cid}16');
      expect(fetchedMessages.last.id, 'testMessageId${cid}25');
    });

    test('default limit + greaterThanOrEqual returns the pivot and 9 after',
        () async {
      await _prepareTestData(cid, count: 30);

      final fetchedMessages = await pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          greaterThanOrEqual: 'testMessageId${cid}5',
        ),
      );

      expect(fetchedMessages.length, 10);
      expect(fetchedMessages.first.id, 'testMessageId${cid}5');
      expect(fetchedMessages.last.id, 'testMessageId${cid}14');
    });

    test('cursor with tied createdAt does not skip or duplicate siblings',
        () async {
      // Three messages share an identical `createdAt`. The SQL ORDER BY uses
      // the `(createdAt, id)` tuple, so within the trio the relative order is
      // by id (lexicographic). A cursor at `msg_tieB` must split the trio
      // cleanly: `msg_tieA` lands on the "before" side, `msg_tieC` on the
      // "after" side. A `createdAt`-only WHERE predicate would collapse all
      // three into the cursor's bucket and drop or keep them together.
      final users = [User(id: 'tieUser')];
      await database.userDao.updateUsers(users);
      await database.channelDao.updateChannels([ChannelModel(cid: cid)]);

      final tie = DateTime.now();
      final earlier = tie.subtract(const Duration(seconds: 1));
      final later = tie.add(const Duration(seconds: 1));

      Message m(String id, DateTime t) => Message(
            id: id,
            user: users.first,
            createdAt: t,
            updatedAt: t,
            text: id,
          );

      await pinnedMessageDao.updateMessages(cid, [
        m('msg_pre', earlier),
        m('msg_tieA', tie),
        m('msg_tieB', tie),
        m('msg_tieC', tie),
        m('msg_post', later),
      ]);

      final before = await pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          limit: 100,
          lessThan: 'msg_tieB',
        ),
      );
      expect(before.map((m) => m.id).toList(), ['msg_pre', 'msg_tieA']);

      final after = await pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          limit: 100,
          greaterThan: 'msg_tieB',
        ),
      );
      expect(after.map((m) => m.id).toList(), ['msg_tieC', 'msg_post']);

      final atOrBefore = await pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          limit: 100,
          lessThanOrEqual: 'msg_tieB',
        ),
      );
      expect(
        atOrBefore.map((m) => m.id).toList(),
        ['msg_pre', 'msg_tieA', 'msg_tieB'],
      );

      final atOrAfter = await pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          limit: 100,
          greaterThanOrEqual: 'msg_tieB',
        ),
      );
      expect(
        atOrAfter.map((m) => m.id).toList(),
        ['msg_tieB', 'msg_tieC', 'msg_post'],
      );
    });
  });

  test('updateMessages', () async {
    const cid = 'test:Cid';

    // Preparing test data
    final insertedMessages = await _prepareTestData(cid);
    expect(insertedMessages, isNotEmpty);

    // Modifying one of the message and also adding one new
    final copyMessage = insertedMessages.first.copyWith(showInChannel: false);
    final newMessage = Message(
      id: 'testMessageId${cid}4',
      type: 'testType',
      user: User(id: 'testUserId4'),
      createdAt: DateTime.now(),
      shadowed: math.Random().nextBool(),
      showInChannel: math.Random().nextBool(),
      replyCount: 4,
      updatedAt: DateTime.now(),
      extraData: const {'extra_test_field': 'extraTestData'},
      text: 'Dummy text #4',
      pinned: math.Random().nextBool(),
      pinnedAt: DateTime.now(),
      pinnedBy: User(id: 'testUserId4'),
    );

    await pinnedMessageDao.updateMessages(cid, [copyMessage, newMessage]);

    // Fetched messages length should be one more than inserted message.
    // copyMessage `showInChannel` modified field should be false.
    // Fetched messages should contain the newMessage.
    final fetchedMessages = await pinnedMessageDao.getMessagesByCid(cid);
    expect(fetchedMessages.length, insertedMessages.length + 1);
    expect(
      fetchedMessages.firstWhere((it) => it.id == copyMessage.id).showInChannel,
      false,
    );
    expect(
      fetchedMessages.map((it) => it.id).contains(newMessage.id),
      true,
    );
  });

  // Mirror of the `message_dao_test.dart` "hydration" group, scoped to the
  // pinned-messages table + `pinnedMessageReactionDao`. Locks per-row
  // hydration before the upcoming batched-hydration refactor.
  group('hydration', () {
    const cid = 'test:PinnedHydration';

    Future<void> _seedChannel(String channelCid) async {
      await database.channelDao.updateChannels([ChannelModel(cid: channelCid)]);
    }

    test('getMessageById hydrates multiple latest and own reactions', () async {
      const messageId = 'pmsg-multi-reactions';
      await _seedChannel(cid);

      final dbUser = User(id: 'testUserId');
      final otherUser = User(id: 'otherUser');
      await database.userDao.updateUsers([dbUser, otherUser]);

      await pinnedMessageDao.updateMessages(cid, [
        Message(
          id: messageId,
          user: dbUser,
          text: 'Hello',
          createdAt: DateTime.now(),
        ),
      ]);

      await database.pinnedMessageReactionDao.updateReactions([
        Reaction(
          type: 'like',
          messageId: messageId,
          user: dbUser,
          createdAt: DateTime.now(),
        ),
        Reaction(
          type: 'love',
          messageId: messageId,
          user: dbUser,
          createdAt: DateTime.now().add(const Duration(seconds: 1)),
        ),
        Reaction(
          type: 'wow',
          messageId: messageId,
          user: otherUser,
          createdAt: DateTime.now().add(const Duration(seconds: 2)),
        ),
      ]);

      final fetched = await pinnedMessageDao.getMessageById(messageId);
      expect(fetched, isNotNull);
      expect(fetched!.latestReactions, hasLength(3));
      expect(fetched.ownReactions, hasLength(2));
      expect(
        fetched.ownReactions!.every((r) => r.user?.id == dbUser.id),
        isTrue,
      );
    });

    test('getMessagesByCid hydrates reactions per row independently', () async {
      await _seedChannel(cid);
      final dbUser = User(id: 'testUserId');
      await database.userDao.updateUsers([dbUser]);

      final baseTime = DateTime.now();
      final messages = List.generate(
        5,
        (i) => Message(
          id: 'pmsg-iso-$i',
          user: dbUser,
          text: 'Hello $i',
          createdAt: baseTime.add(Duration(seconds: i)),
        ),
      );
      await pinnedMessageDao.updateMessages(cid, messages);

      final reactions = [
        for (var i = 0; i < messages.length; i++) ...[
          Reaction(
            type: 'like-$i',
            messageId: messages[i].id,
            user: dbUser,
            createdAt: baseTime.add(Duration(seconds: i)),
          ),
          Reaction(
            type: 'love-$i',
            messageId: messages[i].id,
            user: dbUser,
            createdAt: baseTime.add(Duration(seconds: i, milliseconds: 1)),
          ),
        ],
      ];
      await database.pinnedMessageReactionDao.updateReactions(reactions);

      final fetched = await pinnedMessageDao.getMessagesByCid(cid);
      expect(fetched, hasLength(5));
      for (final m in fetched) {
        expect(m.latestReactions, hasLength(2));
        expect(
          m.latestReactions!.map((r) => r.type).toSet(),
          equals({
            'like-${m.id.split('-').last}',
            'love-${m.id.split('-').last}',
          }),
        );
      }
    });

    test('getMessagesByCid hydrates poll with own + other-user votes',
        () async {
      const messageId = 'pmsg-with-poll';
      const pollId = 'ppoll-mixed';
      await _seedChannel(cid);

      final dbUser = User(id: 'testUserId');
      final otherUser = User(id: 'otherUser');
      await database.userDao.updateUsers([dbUser, otherUser]);

      const optionA = PollOption(id: 'p-opt-a', text: 'A');
      const optionB = PollOption(id: 'p-opt-b', text: 'B');

      await database.pollDao.updatePolls([
        Poll(
          id: pollId,
          name: 'Pick one',
          options: const [optionA, optionB],
          createdBy: dbUser,
          createdById: dbUser.id,
        ),
      ]);

      await pinnedMessageDao.updateMessages(cid, [
        Message(
          id: messageId,
          user: dbUser,
          text: 'Vote please',
          createdAt: DateTime.now(),
          pollId: pollId,
        ),
      ]);

      await database.pollVoteDao.updatePollVotes([
        PollVote(
          id: 'pv1',
          pollId: pollId,
          userId: dbUser.id,
          user: dbUser,
          optionId: optionA.id,
          createdAt: DateTime.now(),
        ),
        PollVote(
          id: 'pv2',
          pollId: pollId,
          userId: otherUser.id,
          user: otherUser,
          optionId: optionB.id,
          createdAt: DateTime.now().add(const Duration(seconds: 1)),
        ),
        PollVote(
          id: 'pa1',
          pollId: pollId,
          userId: dbUser.id,
          user: dbUser,
          answerText: 'because',
          createdAt: DateTime.now().add(const Duration(seconds: 2)),
        ),
      ]);

      final fetched = await pinnedMessageDao.getMessagesByCid(cid);
      expect(fetched, hasLength(1));
      final hydratedPoll = fetched.first.poll;
      expect(hydratedPoll, isNotNull);
      expect(hydratedPoll!.id, pollId);
      expect(hydratedPoll.latestAnswers, hasLength(1));
      // 1 own vote + 1 own answer = 2.
      expect(hydratedPoll.ownVotesAndAnswers, hasLength(2));
    });

    test(
        'getMessagesByCid hydrates thread draft when fetchDraft=true; '
        'null when false', () async {
      await _seedChannel(cid);
      final dbUser = User(id: 'testUserId');
      await database.userDao.updateUsers([dbUser]);

      const parentId = 'pmsg-with-draft';
      final parentMessage = Message(
        id: parentId,
        user: dbUser,
        text: 'msg',
        createdAt: DateTime.now(),
      );
      // Pin the message and ALSO insert it into the main `messages` table:
      // `DraftMessages.parentId` is FK-referenced against `Messages.id`, not
      // `PinnedMessages.id`, so a thread draft needs the row in both places.
      await pinnedMessageDao.updateMessages(cid, [parentMessage]);
      await database.messageDao.updateMessages(cid, [parentMessage]);

      await database.draftMessageDao.updateDraftMessages([
        Draft(
          channelCid: cid,
          parentId: parentId,
          createdAt: DateTime.now(),
          message: DraftMessage(
            id: 'pdraft-0',
            text: 'unsent',
            parentId: parentId,
          ),
        ),
      ]);

      final withDraft = await pinnedMessageDao.getMessagesByCid(cid);
      expect(withDraft.first.draft, isNotNull);
      expect(withDraft.first.draft!.parentId, parentId);

      final withoutDraft =
          await pinnedMessageDao.getMessagesByCid(cid, fetchDraft: false);
      expect(withoutDraft.first.draft, isNull);
    });

    test(
        'getMessagesByCid hydrates quoted pinned message with its own '
        'reactions and poll', () async {
      await _seedChannel(cid);
      final dbUser = User(id: 'testUserId');
      await database.userDao.updateUsers([dbUser]);

      const pollId = 'ppoll-on-quoted';
      const quotedMessageId = 'pmsg-quoted';
      const quotingMessageId = 'pmsg-quoting';

      await database.pollDao.updatePolls([
        Poll(
          id: pollId,
          name: 'Quoted poll',
          options: const [
            PollOption(id: 'pq-opt-a', text: 'A'),
            PollOption(id: 'pq-opt-b', text: 'B'),
          ],
          createdBy: dbUser,
          createdById: dbUser.id,
        ),
      ]);

      final baseTime = DateTime.now();
      await pinnedMessageDao.updateMessages(cid, [
        Message(
          id: quotedMessageId,
          user: dbUser,
          text: 'first',
          createdAt: baseTime,
          pollId: pollId,
        ),
        Message(
          id: quotingMessageId,
          user: dbUser,
          text: 'second',
          createdAt: baseTime.add(const Duration(seconds: 1)),
          quotedMessageId: quotedMessageId,
        ),
      ]);

      await database.pinnedMessageReactionDao.updateReactions([
        Reaction(
          type: 'like',
          messageId: quotedMessageId,
          user: dbUser,
          createdAt: baseTime,
        ),
      ]);

      final fetched = await pinnedMessageDao.getMessagesByCid(cid);
      final quoting = fetched.firstWhere((m) => m.id == quotingMessageId);
      expect(quoting.quotedMessage, isNotNull);
      expect(quoting.quotedMessage!.id, quotedMessageId);
      expect(quoting.quotedMessage!.latestReactions, hasLength(1));
      expect(quoting.quotedMessage!.ownReactions, hasLength(1));
      expect(quoting.quotedMessage!.poll, isNotNull);
      expect(quoting.quotedMessage!.poll!.id, pollId);
    });

    test('getMessagesByCid hydrates quotes to a single level only', () async {
      await _seedChannel(cid);
      final dbUser = User(id: 'testUserId');
      await database.userDao.updateUsers([dbUser]);

      final baseTime = DateTime.now();
      await pinnedMessageDao.updateMessages(cid, [
        Message(
          id: 'pC',
          user: dbUser,
          text: 'root',
          createdAt: baseTime,
        ),
        Message(
          id: 'pB',
          user: dbUser,
          text: 'mid',
          createdAt: baseTime.add(const Duration(seconds: 1)),
          quotedMessageId: 'pC',
        ),
        Message(
          id: 'pA',
          user: dbUser,
          text: 'top',
          createdAt: baseTime.add(const Duration(seconds: 2)),
          quotedMessageId: 'pB',
        ),
      ]);

      final fetched = await pinnedMessageDao.getMessagesByCid(cid);
      final top = fetched.firstWhere((m) => m.id == 'pA');
      expect(top.quotedMessage?.id, 'pB');
      expect(top.quotedMessage?.quotedMessage, isNull);
    });

    test(
        'getMessagesByCid does not hydrate drafts for quoted pinned messages, '
        'even when fetchDraft=true', () async {
      await _seedChannel(cid);
      final dbUser = User(id: 'testUserId');
      await database.userDao.updateUsers([dbUser]);

      const quotedId = 'pmsg-quoted-with-draft';
      const quotingId = 'pmsg-quoting-no-draft';

      final baseTime = DateTime.now();
      final quotedMessage = Message(
        id: quotedId,
        user: dbUser,
        text: 'quoted',
        createdAt: baseTime,
      );
      final quotingMessage = Message(
        id: quotingId,
        user: dbUser,
        text: 'quoting',
        createdAt: baseTime.add(const Duration(seconds: 1)),
        quotedMessageId: quotedId,
      );

      await pinnedMessageDao
          .updateMessages(cid, [quotedMessage, quotingMessage]);
      // `DraftMessages.parentId` is FK-referenced against `Messages.id`, not
      // `PinnedMessages.id`, so the parent of the draft needs a row in both.
      await database.messageDao.updateMessages(cid, [quotedMessage]);

      await database.draftMessageDao.updateDraftMessages([
        Draft(
          channelCid: cid,
          parentId: quotedId,
          createdAt: baseTime,
          message: DraftMessage(
            id: 'pdraft-on-quoted',
            text: 'unsent reply to quoted',
            parentId: quotedId,
          ),
        ),
      ]);

      final fetched = await pinnedMessageDao.getMessagesByCid(cid);
      final quoting = fetched.firstWhere((m) => m.id == quotingId);
      expect(quoting.quotedMessage, isNotNull);
      expect(quoting.quotedMessage!.id, quotedId);
      expect(quoting.quotedMessage!.draft, isNull);
    });

    test('getMessagesByCid hydrates reactions under pagination', () async {
      await _seedChannel(cid);
      final dbUser = User(id: 'testUserId');
      await database.userDao.updateUsers([dbUser]);

      final baseTime = DateTime.now();
      final messages = List.generate(
        30,
        (i) => Message(
          id: 'p-msg-$i',
          user: dbUser,
          text: 'msg $i',
          createdAt: baseTime.add(Duration(seconds: i)),
        ),
      );
      await pinnedMessageDao.updateMessages(cid, messages);

      // 2 reactions per message; surviving rows after pagination must still
      // carry their full reaction set.
      final reactions = [
        for (final m in messages) ...[
          Reaction(
            type: 'r1',
            messageId: m.id,
            user: dbUser,
            createdAt: m.createdAt,
          ),
          Reaction(
            type: 'r2',
            messageId: m.id,
            user: dbUser,
            createdAt: m.createdAt.add(const Duration(milliseconds: 1)),
          ),
        ],
      ];
      await database.pinnedMessageReactionDao.updateReactions(reactions);

      final page = await pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          lessThan: 'p-msg-25',
        ),
      );
      expect(page, hasLength(10));
      for (final m in page) {
        expect(m.latestReactions, hasLength(2));
        expect(m.ownReactions, hasLength(2));
        expect(m.latestReactions!.every((r) => r.messageId == m.id), isTrue);
      }
    });
  });

  tearDown(() async {
    await database.disconnect();
  });
}
