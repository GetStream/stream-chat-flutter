// ignore_for_file: avoid_redundant_argument_values

import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/dao.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

import '../../stream_chat_persistence_client_test.dart';

void main() {
  late MessageDao messageDao;
  late DriftChatDatabase database;

  setUp(() {
    database = testDatabaseProvider('testUserId');
    messageDao = database.messageDao;
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
        text: 'Hello #$index',
        pinned: math.Random().nextBool(),
        pinnedAt: DateTime.now(),
        pinnedBy: User(id: 'testUserId$index'),
        reactionGroups: {
          'testType': ReactionGroup(count: 3, sumScores: 10),
          'testType2': ReactionGroup(count: 5, sumScores: 20),
        },
        i18n: {
          'en_text': 'Hello #$index',
          'hi_text': 'नमस्ते #$index',
          'language': 'en',
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
        text: 'Hello #$index',
        quotedMessageId: messages[index].id,
        pinned: math.Random().nextBool(),
        pinnedAt: DateTime.now(),
        pinnedBy: User(id: 'testUserId$index'),
        i18n: {
          'en_text': 'Hello #$index',
          'hi_text': 'नमस्ते #$index',
          'language': 'en',
        },
      ),
    );
    final threadMessages = List.generate(
      count,
      (index) => Message(
        id: 'testThreadMessageId$cid$index',
        type: 'testType',
        user: users[index],
        channelRole: 'channel_member',
        parentId: mapAllThreadToFirstMessage ? messages[0].id : messages[index].id,
        createdAt: baseTime.add(Duration(seconds: index)),
        shadowed: math.Random().nextBool(),
        replyCount: index,
        updatedAt: DateTime.now(),
        extraData: const {'extra_test_field': 'extraTestData'},
        text: 'Hello #$index',
        pinned: math.Random().nextBool(),
        pinnedAt: DateTime.now(),
        pinnedBy: User(id: 'testUserId$index'),
        i18n: {
          'en_text': 'Hello #$index',
          'hi_text': 'नमस्ते #$index',
          'language': 'en',
        },
      ),
    );
    final allMessages = [...messages, if (quoted) ...quotedMessages, if (threads) ...threadMessages];
    final reaction = Reaction(
      type: 'type',
      messageId: allMessages.first.id,
      user: users.first,
    );
    await database.userDao.updateUsers(users);
    await database.channelDao.updateChannels(channels);
    await messageDao.updateMessages(cid, allMessages);
    await database.reactionDao.updateReactions([reaction]);
    return allMessages;
  }

  test('deleteMessageByIds', () async {
    const cid = 'test:Cid';

    // Preparing test data
    final insertedMessages = await _prepareTestData(cid);

    // Fetched message list should match the test message list length
    final messages = await messageDao.getMessagesByCid(cid);
    expect(messages.length, insertedMessages.length);

    final firstMessageId = messages.first.id;

    // Fetched reactions list should have one reaction for given message id
    final reactions = await database.reactionDao.getReactions(firstMessageId);
    expect(reactions.length, 1);

    // Deleting 2 messages from DB
    await messageDao.deleteMessageByIds(
      [firstMessageId, 'testMessageId${cid}1'],
    );

    // New fetched messages length should 2 less than the
    // previous fetched messages
    final newMessages = await messageDao.getMessagesByCid(cid);
    expect(newMessages.length, messages.length - 2);

    // Reaction for the first message should be deleted too
    final newReactions = await database.reactionDao.getReactions(firstMessageId);
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
        final cid1Messages = await messageDao.getMessagesByCid(cid1);
        final cid2Messages = await messageDao.getMessagesByCid(cid2);
        expect(cid1Messages.length, cid1InsertedMessages.length);
        expect(cid2Messages.length, cid2InsertedMessages.length);

        // Fetched reactions list should have one reaction for given message id
        final cid1firstMessageId = cid1Messages.first.id;
        final cid1Reactions = await database.reactionDao.getReactions(cid1firstMessageId);
        expect(cid1Reactions.length, 1);

        // Deleting all the messages of cid1
        await messageDao.deleteMessageByCids([cid1]);

        // Fetched messages length of only cid1 should be empty
        final cid1FetchedMessages = await messageDao.getMessagesByCid(cid1);
        final cid2FetchedMessages = await messageDao.getMessagesByCid(cid2);
        expect(cid1FetchedMessages, isEmpty);
        expect(cid2FetchedMessages, isNotEmpty);

        // Reaction for the first message should be deleted too
        final cid1FetchedReactions = await database.reactionDao.getReactions(cid1firstMessageId);
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
        final cid1Messages = await messageDao.getMessagesByCid(cid1);
        final cid2Messages = await messageDao.getMessagesByCid(cid2);
        expect(cid1Messages.length, cid1InsertedMessages.length);
        expect(cid2Messages.length, cid2InsertedMessages.length);

        // Fetched reactions list should have one reaction for given message id
        final cid1FirstMessageId = cid1Messages.first.id;
        final cid1Reactions = await database.reactionDao.getReactions(cid1FirstMessageId);
        expect(cid1Reactions.length, 1);
        final cid2FirstMessageId = cid2Messages.first.id;
        final cid2Reactions = await database.reactionDao.getReactions(cid2FirstMessageId);
        expect(cid2Reactions.length, 1);

        // Deleting all the messages of cid1
        await messageDao.deleteMessageByCids([cid1, cid2]);

        // Fetched messages length of both cid1 and cid2 should be empty
        final cid1FetchedMessages = await messageDao.getMessagesByCid(cid1);
        final cid2FetchedMessages = await messageDao.getMessagesByCid(cid2);
        expect(cid1FetchedMessages, isEmpty);
        expect(cid2FetchedMessages, isEmpty);

        // Reaction for the first message should be deleted too
        final cid1FetchedReactions = await database.reactionDao.getReactions(cid1FirstMessageId);
        expect(cid1FetchedReactions, isEmpty);
        final cid2FetchedReactions = await database.reactionDao.getReactions(cid2FirstMessageId);
        expect(cid2FetchedReactions, isEmpty);
      },
    );
  });

  test('getMessageById', () async {
    const cid = 'test:Cid';
    const id = 'testMessageId${cid}0';

    // Should be null initially
    final message = await messageDao.getMessageById(id);
    expect(message, isNull);

    // Adding test message with the cid and id
    final insertedMessages = await _prepareTestData(cid, count: 1);
    expect(insertedMessages.first.id, id);

    // Fetched message id should match the inserted message id
    final fetchedMessage = await messageDao.getMessageById(id);
    expect(fetchedMessage, isNotNull);
    expect(fetchedMessage!.id, insertedMessages.first.id);
  });

  test('getThreadMessages', () async {
    const cid = 'test:Cid';

    // Messages should be empty initially
    final messages = await messageDao.getThreadMessages(cid);
    expect(messages, isEmpty);

    // Preparing test data
    final insertedMessages = await _prepareTestData(cid, threads: true);
    expect(insertedMessages, isNotEmpty);

    // Should fetch all the thread messages of cid
    final threadMessages = await messageDao.getThreadMessages(cid);
    expect(threadMessages, isNotEmpty);
    for (final message in threadMessages) {
      expect(message.parentId, isNotNull);
    }
  });

  group('getThreadMessagesByParentId', () {
    const cid = 'test:Cid';
    const parentId = 'testMessageId${cid}0';
    String threadId(int i) => 'testThreadMessageId$cid$i';

    test('getThreadMessagesByParentId', () async {
      // Messages should be empty initially
      final messages = await messageDao.getThreadMessagesByParentId(parentId);
      expect(messages, isEmpty);

      // Preparing test data
      final insertedMessages = await _prepareTestData(cid, threads: true);
      expect(insertedMessages, isNotEmpty);

      // Should fetch all the thread messages of parentId
      final threadMessages = await messageDao.getThreadMessagesByParentId(parentId);
      expect(threadMessages.length, 1);
      expect(threadMessages.first.parentId, parentId);
    });

    test('getThreadMessagesByParentId along with pagination', () async {
      const options = PaginationParams(
        limit: 15,
        lessThan: 'testThreadMessageId${cid}25',
        greaterThan: 'testThreadMessageId${cid}5',
      );

      // Messages should be empty initially
      final messages = await messageDao.getThreadMessagesByParentId(
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

      // Should fetch all the thread messages of parentId and apply the
      // pagination.
      final threadMessages = await messageDao.getThreadMessagesByParentId(
        parentId,
        options: options,
      );
      expect(threadMessages.length, 15);
      expect(threadMessages.first.parentId, parentId);
      // lessThan is set → backward pagination → DESC + LIMIT then reverse.
      // Filter: id6..id24. Take 15 closest to id25 → id10..id24.
      expect(threadMessages.first.id, 'testThreadMessageId${cid}10');
      expect(threadMessages.last.id, 'testThreadMessageId${cid}24');
    });

    test('limit only returns the latest N replies', () async {
      await _prepareTestData(
        cid,
        threads: true,
        mapAllThreadToFirstMessage: true,
        count: 30,
      );

      final replies = await messageDao.getThreadMessagesByParentId(
        parentId,
        options: const PaginationParams(limit: 5),
      );

      // No cursor → backward pagination → DESC + LIMIT then reversed. The
      // result is the newest 5 replies (the tail of the thread), in ASC
      // order: id25..id29.
      expect(replies.length, 5);
      expect(replies.first.id, threadId(25));
      expect(replies.last.id, threadId(29));
    });

    test('lessThan only excludes the cursor', () async {
      await _prepareTestData(
        cid,
        threads: true,
        mapAllThreadToFirstMessage: true,
        count: 30,
      );

      final replies = await messageDao.getThreadMessagesByParentId(
        parentId,
        options: PaginationParams(limit: 5, lessThan: threadId(25)),
      );

      // Strictly before id25 → id0..id24. Backward pagination keeps the 5
      // closest to the cursor → id20..id24.
      expect(replies.length, 5);
      expect(replies.first.id, threadId(20));
      expect(replies.last.id, threadId(24));
    });

    test('lessThanOrEqual only includes the cursor', () async {
      await _prepareTestData(
        cid,
        threads: true,
        mapAllThreadToFirstMessage: true,
        count: 30,
      );

      final replies = await messageDao.getThreadMessagesByParentId(
        parentId,
        options: PaginationParams(limit: 5, lessThanOrEqual: threadId(25)),
      );

      // Up to and including id25 → id0..id25. Backward pagination keeps the
      // 5 closest to the cursor → id21..id25.
      expect(replies.length, 5);
      expect(replies.first.id, threadId(21));
      expect(replies.last.id, threadId(25));
    });

    test('greaterThan only excludes the cursor', () async {
      await _prepareTestData(
        cid,
        threads: true,
        mapAllThreadToFirstMessage: true,
        count: 30,
      );

      final replies = await messageDao.getThreadMessagesByParentId(
        parentId,
        options: PaginationParams(limit: 5, greaterThan: threadId(5)),
      );

      // Strictly after id5 → id6..id29, capped to 5 → id6..id10.
      expect(replies.length, 5);
      expect(replies.first.id, threadId(6));
      expect(replies.last.id, threadId(10));
    });

    test('greaterThanOrEqual only includes the cursor', () async {
      await _prepareTestData(
        cid,
        threads: true,
        mapAllThreadToFirstMessage: true,
        count: 30,
      );

      final replies = await messageDao.getThreadMessagesByParentId(
        parentId,
        options: PaginationParams(limit: 5, greaterThanOrEqual: threadId(5)),
      );

      // From id5 onwards → id5..id29, capped to 5 → id5..id9.
      expect(replies.length, 5);
      expect(replies.first.id, threadId(5));
      expect(replies.last.id, threadId(9));
    });

    test('lessThan id not in result set is a no-op', () async {
      await _prepareTestData(
        cid,
        threads: true,
        mapAllThreadToFirstMessage: true,
        count: 30,
      );

      final replies = await messageDao.getThreadMessagesByParentId(
        parentId,
        options: const PaginationParams(
          limit: 100,
          lessThan: 'missing-id',
        ),
      );

      expect(replies.length, 30);
      expect(replies.first.id, threadId(0));
      expect(replies.last.id, threadId(29));
    });

    test('greaterThan id not in result set is a no-op', () async {
      await _prepareTestData(
        cid,
        threads: true,
        mapAllThreadToFirstMessage: true,
        count: 30,
      );

      final replies = await messageDao.getThreadMessagesByParentId(
        parentId,
        options: const PaginationParams(
          limit: 100,
          greaterThan: 'missing-id',
        ),
      );

      expect(replies.length, 30);
      expect(replies.first.id, threadId(0));
      expect(replies.last.id, threadId(29));
    });

    test('channel-message id as cursor is a no-op (not a thread reply)', () async {
      // `_prepareTestData` inserts channel messages with `parentId = null` and
      // thread replies with `parentId` set. The thread lookup requires
      // `parentId.equals(parentId)`, so passing a channel-message id must
      // resolve to a no-op so the main query falls back to returning the full
      // thread.
      await _prepareTestData(
        cid,
        threads: true,
        mapAllThreadToFirstMessage: true,
        count: 30,
      );

      final replies = await messageDao.getThreadMessagesByParentId(
        parentId,
        options: const PaginationParams(
          limit: 100,
          lessThan: 'testMessageId${cid}5',
        ),
      );

      expect(replies.length, 30);
      expect(replies.first.id, threadId(0));
      expect(replies.last.id, threadId(29));
    });

    test('default PaginationParams() applies implicit limit of 10', () async {
      await _prepareTestData(
        cid,
        threads: true,
        mapAllThreadToFirstMessage: true,
        count: 30,
      );

      final replies = await messageDao.getThreadMessagesByParentId(
        parentId,
        options: const PaginationParams(),
      );

      expect(replies.length, 10);
      expect(replies.first.id, threadId(20));
      expect(replies.last.id, threadId(29));
    });

    test('default limit + lessThan returns last 10 of filtered set', () async {
      await _prepareTestData(
        cid,
        threads: true,
        mapAllThreadToFirstMessage: true,
        count: 30,
      );

      final replies = await messageDao.getThreadMessagesByParentId(
        parentId,
        options: PaginationParams(lessThan: threadId(25)),
      );

      expect(replies.length, 10);
      expect(replies.first.id, threadId(15));
      expect(replies.last.id, threadId(24));
    });

    test('default limit + greaterThan returns first 10 after the pivot', () async {
      await _prepareTestData(
        cid,
        threads: true,
        mapAllThreadToFirstMessage: true,
        count: 30,
      );

      final replies = await messageDao.getThreadMessagesByParentId(
        parentId,
        options: PaginationParams(greaterThan: threadId(5)),
      );

      expect(replies.length, 10);
      expect(replies.first.id, threadId(6));
      expect(replies.last.id, threadId(15));
    });

    test('default limit + lessThanOrEqual returns the pivot and 9 before', () async {
      await _prepareTestData(
        cid,
        threads: true,
        mapAllThreadToFirstMessage: true,
        count: 30,
      );

      final replies = await messageDao.getThreadMessagesByParentId(
        parentId,
        options: PaginationParams(lessThanOrEqual: threadId(25)),
      );

      expect(replies.length, 10);
      expect(replies.first.id, threadId(16));
      expect(replies.last.id, threadId(25));
    });

    test('default limit + greaterThanOrEqual returns the pivot and 9 after', () async {
      await _prepareTestData(
        cid,
        threads: true,
        mapAllThreadToFirstMessage: true,
        count: 30,
      );

      final replies = await messageDao.getThreadMessagesByParentId(
        parentId,
        options: PaginationParams(greaterThanOrEqual: threadId(5)),
      );

      expect(replies.length, 10);
      expect(replies.first.id, threadId(5));
      expect(replies.last.id, threadId(14));
    });

    test('cursor with tied createdAt does not skip or duplicate siblings', () async {
      // Three replies share an identical `createdAt`. The SQL ORDER BY uses
      // the `(createdAt, id)` tuple, so within the trio the relative order is
      // by id (lexicographic). A cursor at `reply_tieB` must split the trio
      // cleanly: `reply_tieA` lands on the "before" side, `reply_tieC` on the
      // "after" side. A `createdAt`-only WHERE predicate would collapse all
      // three into the cursor's bucket and drop or keep them together.
      final users = [User(id: 'tieUser')];
      await database.userDao.updateUsers(users);
      await database.channelDao.updateChannels([ChannelModel(cid: cid)]);

      final tie = DateTime.now();
      final earlier = tie.subtract(const Duration(seconds: 1));
      final later = tie.add(const Duration(seconds: 1));

      Message parent() => Message(
        id: parentId,
        user: users.first,
        createdAt: earlier,
        updatedAt: earlier,
        text: parentId,
      );

      Message reply(String id, DateTime t) => Message(
        id: id,
        user: users.first,
        parentId: parentId,
        createdAt: t,
        updatedAt: t,
        text: id,
      );

      await messageDao.updateMessages(cid, [
        parent(),
        reply('reply_pre', earlier),
        reply('reply_tieA', tie),
        reply('reply_tieB', tie),
        reply('reply_tieC', tie),
        reply('reply_post', later),
      ]);

      final before = await messageDao.getThreadMessagesByParentId(
        parentId,
        options: const PaginationParams(limit: 100, lessThan: 'reply_tieB'),
      );
      expect(before.map((m) => m.id).toList(), ['reply_pre', 'reply_tieA']);

      final after = await messageDao.getThreadMessagesByParentId(
        parentId,
        options: const PaginationParams(limit: 100, greaterThan: 'reply_tieB'),
      );
      expect(after.map((m) => m.id).toList(), ['reply_tieC', 'reply_post']);

      final atOrBefore = await messageDao.getThreadMessagesByParentId(
        parentId,
        options: const PaginationParams(
          limit: 100,
          lessThanOrEqual: 'reply_tieB',
        ),
      );
      expect(
        atOrBefore.map((m) => m.id).toList(),
        ['reply_pre', 'reply_tieA', 'reply_tieB'],
      );

      final atOrAfter = await messageDao.getThreadMessagesByParentId(
        parentId,
        options: const PaginationParams(
          limit: 100,
          greaterThanOrEqual: 'reply_tieB',
        ),
      );
      expect(
        atOrAfter.map((m) => m.id).toList(),
        ['reply_tieB', 'reply_tieC', 'reply_post'],
      );
    });
  });

  test('getMessagesByCid', () async {
    const cid = 'test:Cid';

    // Should be empty initially
    final messages = await messageDao.getMessagesByCid(cid);
    expect(messages, isEmpty);

    // Preparing test data
    final insertedMessages = await _prepareTestData(cid);
    expect(insertedMessages, isNotEmpty);

    // Fetched message should match the inserted messages
    final fetchedMessages = await messageDao.getMessagesByCid(cid);
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
    final messages = await messageDao.getMessagesByCid(cid);
    expect(messages, isEmpty);

    // Preparing test data
    final insertedMessages = await _prepareTestData(cid, quoted: true);
    expect(insertedMessages, isNotEmpty);

    // Fetched message should match the inserted messages
    final fetchedMessages = await messageDao.getMessagesByCid(cid);
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
    final messages = await messageDao.getMessagesByCid(
      cid,
      messagePagination: pagination,
    );
    expect(messages, isEmpty);

    // Preparing test data
    final insertedMessages = await _prepareTestData(cid, count: 30);
    expect(insertedMessages, isNotEmpty);

    // Fetched message should match the inserted messages
    final fetchedMessages = await messageDao.getMessagesByCid(
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

      final fetchedMessages = await messageDao.getMessagesByCid(
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

    test('greaterThan only trims messages from the start (exclusive)', () async {
      await _prepareTestData(cid, count: 30);

      final fetchedMessages = await messageDao.getMessagesByCid(
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

      final fetchedMessages = await messageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(limit: 15),
      );

      expect(fetchedMessages.length, 15);
      expect(fetchedMessages.first.id, 'testMessageId${cid}15');
      expect(fetchedMessages.last.id, 'testMessageId${cid}29');
    });

    test('lessThan id not in result set is a no-op', () async {
      await _prepareTestData(cid, count: 30);

      final fetchedMessages = await messageDao.getMessagesByCid(
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

      final fetchedMessages = await messageDao.getMessagesByCid(
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

    test('thread-reply id as cursor is a no-op (not visible in channel)', () async {
      // `_prepareTestData` inserts thread replies with `parentId` set and
      // `showInChannel` left null — i.e. not visible in the channel query.
      // Passing such an id as a cursor must resolve to a no-op so the main
      // query falls back to returning the full channel slice.
      await _prepareTestData(cid, count: 30, threads: true);

      final fetchedMessages = await messageDao.getMessagesByCid(
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

      final fetchedMessages = await messageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(),
      );

      expect(fetchedMessages.length, 10);
      expect(fetchedMessages.first.id, 'testMessageId${cid}20');
      expect(fetchedMessages.last.id, 'testMessageId${cid}29');
    });

    test('default limit + lessThan returns last 10 of filtered set', () async {
      await _prepareTestData(cid, count: 30);

      final fetchedMessages = await messageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          lessThan: 'testMessageId${cid}25',
        ),
      );

      expect(fetchedMessages.length, 10);
      expect(fetchedMessages.first.id, 'testMessageId${cid}15');
      expect(fetchedMessages.last.id, 'testMessageId${cid}24');
    });

    test('default limit + greaterThan returns first 10 after the pivot', () async {
      await _prepareTestData(cid, count: 30);

      final fetchedMessages = await messageDao.getMessagesByCid(
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

      final fetchedMessages = await messageDao.getMessagesByCid(
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

      final fetchedMessages = await messageDao.getMessagesByCid(
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

    test('default limit + lessThanOrEqual returns the pivot and 9 before', () async {
      await _prepareTestData(cid, count: 30);

      final fetchedMessages = await messageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          lessThanOrEqual: 'testMessageId${cid}25',
        ),
      );

      expect(fetchedMessages.length, 10);
      expect(fetchedMessages.first.id, 'testMessageId${cid}16');
      expect(fetchedMessages.last.id, 'testMessageId${cid}25');
    });

    test('default limit + greaterThanOrEqual returns the pivot and 9 after', () async {
      await _prepareTestData(cid, count: 30);

      final fetchedMessages = await messageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          greaterThanOrEqual: 'testMessageId${cid}5',
        ),
      );

      expect(fetchedMessages.length, 10);
      expect(fetchedMessages.first.id, 'testMessageId${cid}5');
      expect(fetchedMessages.last.id, 'testMessageId${cid}14');
    });

    test('cursor with tied createdAt does not skip or duplicate siblings', () async {
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

      await messageDao.updateMessages(cid, [
        m('msg_pre', earlier),
        m('msg_tieA', tie),
        m('msg_tieB', tie),
        m('msg_tieC', tie),
        m('msg_post', later),
      ]);

      final before = await messageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          limit: 100,
          lessThan: 'msg_tieB',
        ),
      );
      expect(before.map((m) => m.id).toList(), ['msg_pre', 'msg_tieA']);

      final after = await messageDao.getMessagesByCid(
        cid,
        messagePagination: const PaginationParams(
          limit: 100,
          greaterThan: 'msg_tieB',
        ),
      );
      expect(after.map((m) => m.id).toList(), ['msg_tieC', 'msg_post']);

      final atOrBefore = await messageDao.getMessagesByCid(
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

      final atOrAfter = await messageDao.getMessagesByCid(
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

    await messageDao.updateMessages(cid, [copyMessage, newMessage]);

    // Fetched messages length should be one more than inserted message.
    // copyMessage `showInChannel` modified field should be false.
    // Fetched messages should contain the newMessage.
    final fetchedMessages = await messageDao.getMessagesByCid(cid);
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

  // Covers message enrichment logic
  group('hydration', () {
    const cid = 'test:Hydration';

    Future<void> _seedChannel(String channelCid) async {
      await database.channelDao.updateChannels([ChannelModel(cid: channelCid)]);
    }

    test('getMessageById hydrates multiple latest and own reactions', () async {
      const messageId = 'msg-multi-reactions';
      await _seedChannel(cid);

      final dbUser = User(id: 'testUserId');
      final otherUser = User(id: 'otherUser');
      await database.userDao.updateUsers([dbUser, otherUser]);

      await messageDao.updateMessages(cid, [
        Message(
          id: messageId,
          user: dbUser,
          text: 'Hello',
          createdAt: DateTime.now(),
        ),
      ]);

      // 2 reactions by the DB user, 1 by another user.
      await database.reactionDao.updateReactions([
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

      final fetched = await messageDao.getMessageById(messageId);
      expect(fetched, isNotNull);
      expect(fetched!.latestReactions, hasLength(3));
      expect(fetched.ownReactions, hasLength(2));
      expect(
        fetched.ownReactions!.every((r) => r.user?.id == dbUser.id),
        isTrue,
      );
      expect(
        fetched.latestReactions!.map((r) => r.type).toSet(),
        equals({'like', 'love', 'wow'}),
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
          id: 'msg-iso-$i',
          user: dbUser,
          text: 'Hello $i',
          createdAt: baseTime.add(Duration(seconds: i)),
        ),
      );
      await messageDao.updateMessages(cid, messages);

      // 2 reactions per message, distinct types per-row.
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
      await database.reactionDao.updateReactions(reactions);

      final fetched = await messageDao.getMessagesByCid(cid);
      expect(fetched, hasLength(5));
      for (final m in fetched) {
        expect(m.latestReactions, hasLength(2));
        // Reactions must belong to this message only — no cross-contamination
        // between rows when batched-hydration replaces the per-row queries.
        expect(
          m.latestReactions!.map((r) => r.type).toSet(),
          equals({'like-${m.id.split('-').last}', 'love-${m.id.split('-').last}'}),
        );
      }
    });

    test('getMessagesByCid hydrates poll with own + other-user votes', () async {
      const messageId = 'msg-with-poll';
      const pollId = 'poll-mixed';
      await _seedChannel(cid);

      final dbUser = User(id: 'testUserId');
      final otherUser = User(id: 'otherUser');
      await database.userDao.updateUsers([dbUser, otherUser]);

      const optionA = PollOption(id: 'opt-a', text: 'A');
      const optionB = PollOption(id: 'opt-b', text: 'B');

      final poll = Poll(
        id: pollId,
        name: 'Pick one',
        options: const [optionA, optionB],
        createdBy: dbUser,
        createdById: dbUser.id,
      );
      await database.pollDao.updatePolls([poll]);

      await messageDao.updateMessages(cid, [
        Message(
          id: messageId,
          user: dbUser,
          text: 'Vote please',
          createdAt: DateTime.now(),
          pollId: pollId,
        ),
      ]);

      // 2 own votes (one per option), 2 other-user votes, 1 own answer.
      await database.pollVoteDao.updatePollVotes([
        PollVote(
          id: 'v1',
          pollId: pollId,
          userId: dbUser.id,
          user: dbUser,
          optionId: optionA.id,
          createdAt: DateTime.now(),
        ),
        PollVote(
          id: 'v2',
          pollId: pollId,
          userId: dbUser.id,
          user: dbUser,
          optionId: optionB.id,
          createdAt: DateTime.now().add(const Duration(seconds: 1)),
        ),
        PollVote(
          id: 'v3',
          pollId: pollId,
          userId: otherUser.id,
          user: otherUser,
          optionId: optionA.id,
          createdAt: DateTime.now().add(const Duration(seconds: 2)),
        ),
        PollVote(
          id: 'v4',
          pollId: pollId,
          userId: otherUser.id,
          user: otherUser,
          optionId: optionB.id,
          createdAt: DateTime.now().add(const Duration(seconds: 3)),
        ),
        PollVote(
          id: 'a1',
          pollId: pollId,
          userId: dbUser.id,
          user: dbUser,
          answerText: 'because',
          createdAt: DateTime.now().add(const Duration(seconds: 4)),
        ),
      ]);

      final fetched = await messageDao.getMessagesByCid(cid);
      expect(fetched, hasLength(1));
      final hydratedPoll = fetched.first.poll;
      expect(hydratedPoll, isNotNull);
      expect(hydratedPoll!.id, pollId);
      expect(hydratedPoll.latestVotesByOption[optionA.id], hasLength(2));
      expect(hydratedPoll.latestVotesByOption[optionB.id], hasLength(2));
      expect(hydratedPoll.latestAnswers, hasLength(1));
      // Own votes + own answer => 3 total in ownVotesAndAnswers.
      expect(hydratedPoll.ownVotesAndAnswers, hasLength(3));
      expect(
        hydratedPoll.ownVotesAndAnswers.every((v) => v.userId == dbUser.id),
        isTrue,
      );
    });

    test('getMessagesByCid hydrates thread draft when fetchDraft=true; '
        'null when false', () async {
      // `fetchDraft` attaches a thread draft (parentId == message.id) to its
      // parent message, not the channel-level draft. See changelog entry for
      // 9.15.0.
      await _seedChannel(cid);
      final dbUser = User(id: 'testUserId');
      await database.userDao.updateUsers([dbUser]);

      const parentId = 'msg-with-draft';
      await messageDao.updateMessages(cid, [
        Message(
          id: parentId,
          user: dbUser,
          text: 'msg',
          createdAt: DateTime.now(),
        ),
      ]);

      await database.draftMessageDao.updateDraftMessages([
        Draft(
          channelCid: cid,
          parentId: parentId,
          createdAt: DateTime.now(),
          message: DraftMessage(
            id: 'draft-0',
            text: 'unsent',
            parentId: parentId,
          ),
        ),
      ]);

      final withDraft = await messageDao.getMessagesByCid(cid);
      expect(withDraft.first.draft, isNotNull);
      expect(withDraft.first.draft!.message.text, 'unsent');
      expect(withDraft.first.draft!.parentId, parentId);

      final withoutDraft = await messageDao.getMessagesByCid(cid, fetchDraft: false);
      expect(withoutDraft.first.draft, isNull);
    });

    test('getMessagesByCid hydrates quoted message with its own reactions '
        'and poll', () async {
      await _seedChannel(cid);

      final dbUser = User(id: 'testUserId');
      await database.userDao.updateUsers([dbUser]);

      const pollId = 'poll-on-quoted';
      const quotedMessageId = 'msg-quoted';
      const quotingMessageId = 'msg-quoting';

      final poll = Poll(
        id: pollId,
        name: 'Quoted poll',
        options: const [
          PollOption(id: 'q-opt-a', text: 'A'),
          PollOption(id: 'q-opt-b', text: 'B'),
        ],
        createdBy: dbUser,
        createdById: dbUser.id,
      );
      await database.pollDao.updatePolls([poll]);

      final baseTime = DateTime.now();
      await messageDao.updateMessages(cid, [
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

      await database.reactionDao.updateReactions([
        Reaction(
          type: 'like',
          messageId: quotedMessageId,
          user: dbUser,
          createdAt: baseTime,
        ),
      ]);

      final fetched = await messageDao.getMessagesByCid(cid);
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
      await messageDao.updateMessages(cid, [
        Message(
          id: 'C',
          user: dbUser,
          text: 'root',
          createdAt: baseTime,
        ),
        Message(
          id: 'B',
          user: dbUser,
          text: 'mid',
          createdAt: baseTime.add(const Duration(seconds: 1)),
          quotedMessageId: 'C',
        ),
        Message(
          id: 'A',
          user: dbUser,
          text: 'top',
          createdAt: baseTime.add(const Duration(seconds: 2)),
          quotedMessageId: 'B',
        ),
      ]);

      final fetched = await messageDao.getMessagesByCid(cid);
      final top = fetched.firstWhere((m) => m.id == 'A');
      expect(top.quotedMessage?.id, 'B');
      expect(top.quotedMessage?.quotedMessage, isNull);
    });

    test('getMessagesByCid does not hydrate drafts for quoted messages, '
        'even when fetchDraft=true', () async {
      await _seedChannel(cid);
      final dbUser = User(id: 'testUserId');
      await database.userDao.updateUsers([dbUser]);

      const quotedId = 'msg-quoted-with-draft';
      const quotingId = 'msg-quoting-no-draft';

      final baseTime = DateTime.now();
      await messageDao.updateMessages(cid, [
        Message(
          id: quotedId,
          user: dbUser,
          text: 'quoted',
          createdAt: baseTime,
        ),
        Message(
          id: quotingId,
          user: dbUser,
          text: 'quoting',
          createdAt: baseTime.add(const Duration(seconds: 1)),
          quotedMessageId: quotedId,
        ),
      ]);

      await database.draftMessageDao.updateDraftMessages([
        Draft(
          channelCid: cid,
          parentId: quotedId,
          createdAt: baseTime,
          message: DraftMessage(
            id: 'draft-on-quoted',
            text: 'unsent reply to quoted',
            parentId: quotedId,
          ),
        ),
      ]);

      final fetched = await messageDao.getMessagesByCid(cid);
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
      await messageDao.updateMessages(cid, messages);

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
      await database.reactionDao.updateReactions(reactions);

      final page = await messageDao.getMessagesByCid(
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

    test('getMessageById hydrates sharedLocation when fetchSharedLocation=true; '
        'null when false', () async {
      await _seedChannel(cid);
      final dbUser = User(id: 'testUserId');
      await database.userDao.updateUsers([dbUser]);

      const messageId = 'msg-with-location';
      await messageDao.updateMessages(cid, [
        Message(
          id: messageId,
          user: dbUser,
          text: 'pin drop',
          createdAt: DateTime.now(),
        ),
      ]);

      await database.locationDao.updateLocations([
        Location(
          channelCid: cid,
          messageId: messageId,
          userId: dbUser.id,
          latitude: 37.7749,
          longitude: -122.4194,
          createdByDeviceId: 'device-A',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ]);

      final withLocation = await messageDao.getMessageById(messageId);
      expect(withLocation, isNotNull);
      expect(withLocation!.sharedLocation, isNotNull);
      expect(withLocation.sharedLocation!.messageId, messageId);
      expect(withLocation.sharedLocation!.latitude, 37.7749);
      expect(withLocation.sharedLocation!.longitude, -122.4194);
      expect(withLocation.sharedLocation!.createdByDeviceId, 'device-A');

      final withoutLocation = await messageDao.getMessageById(
        messageId,
        fetchSharedLocation: false,
      );
      expect(withoutLocation, isNotNull);
      expect(withoutLocation!.sharedLocation, isNull);
    });

    test('getMessagesByCid hydrates sharedLocation per row independently; '
        'absent locations remain null', () async {
      await _seedChannel(cid);
      final dbUser = User(id: 'testUserId');
      await database.userDao.updateUsers([dbUser]);

      final baseTime = DateTime.now();
      final messages = List.generate(
        4,
        (i) => Message(
          id: 'loc-msg-$i',
          user: dbUser,
          text: 'msg $i',
          createdAt: baseTime.add(Duration(seconds: i)),
        ),
      );
      await messageDao.updateMessages(cid, messages);

      // Locations only on messages 1 and 3; messages 0 and 2 have none.
      await database.locationDao.updateLocations([
        Location(
          channelCid: cid,
          messageId: messages[1].id,
          userId: dbUser.id,
          latitude: 10,
          longitude: 20,
          createdAt: baseTime,
          updatedAt: baseTime,
        ),
        Location(
          channelCid: cid,
          messageId: messages[3].id,
          userId: dbUser.id,
          latitude: 30,
          longitude: 40,
          endAt: baseTime.add(const Duration(hours: 1)),
          createdAt: baseTime,
          updatedAt: baseTime,
        ),
      ]);

      final fetched = await messageDao.getMessagesByCid(cid);
      expect(fetched, hasLength(4));
      final byId = {for (final m in fetched) m.id: m};

      expect(byId['loc-msg-0']!.sharedLocation, isNull);
      expect(byId['loc-msg-1']!.sharedLocation, isNotNull);
      expect(byId['loc-msg-1']!.sharedLocation!.latitude, 10);
      expect(byId['loc-msg-1']!.sharedLocation!.longitude, 20);
      expect(byId['loc-msg-1']!.sharedLocation!.isLive, isFalse);
      expect(byId['loc-msg-2']!.sharedLocation, isNull);
      expect(byId['loc-msg-3']!.sharedLocation, isNotNull);
      expect(byId['loc-msg-3']!.sharedLocation!.latitude, 30);
      expect(byId['loc-msg-3']!.sharedLocation!.isLive, isTrue);

      final withoutLocations = await messageDao.getMessagesByCid(
        cid,
        fetchSharedLocation: false,
      );
      expect(
        withoutLocations.every((m) => m.sharedLocation == null),
        isTrue,
      );
    });

    test('getMessagesByCid hydrates sharedLocation for quoted message even '
        'when fetchSharedLocation=false on the parent', () async {
      await _seedChannel(cid);
      final dbUser = User(id: 'testUserId');
      await database.userDao.updateUsers([dbUser]);

      const quotedId = 'msg-quoted-loc';
      const quotingId = 'msg-quoting-no-loc';
      final baseTime = DateTime.now();
      await messageDao.updateMessages(cid, [
        Message(
          id: quotedId,
          user: dbUser,
          text: 'here I am',
          createdAt: baseTime,
        ),
        Message(
          id: quotingId,
          user: dbUser,
          text: 'see above',
          createdAt: baseTime.add(const Duration(seconds: 1)),
          quotedMessageId: quotedId,
        ),
      ]);

      await database.locationDao.updateLocations([
        Location(
          channelCid: cid,
          messageId: quotedId,
          userId: dbUser.id,
          latitude: 1,
          longitude: 2,
          createdAt: baseTime,
          updatedAt: baseTime,
        ),
      ]);

      // Parent caller opts out of locations, but the quoted message should
      // still carry its own shared location.
      final fetched = await messageDao.getMessagesByCid(
        cid,
        fetchSharedLocation: false,
      );
      final quoting = fetched.firstWhere((m) => m.id == quotingId);
      expect(quoting.sharedLocation, isNull);
      expect(quoting.quotedMessage, isNotNull);
      expect(quoting.quotedMessage!.sharedLocation, isNotNull);
      expect(quoting.quotedMessage!.sharedLocation!.latitude, 1);
      expect(quoting.quotedMessage!.sharedLocation!.longitude, 2);
    });
  });

  group('deleteMessagesByUser', () {
    const cid1 = 'test:Cid1';
    const cid2 = 'test:Cid2';
    const userId = 'testUserId0';

    test('hard deletes user messages in specific channel', () async {
      // Preparing test data for two channels
      await _prepareTestData(cid1);
      await _prepareTestData(cid2);

      // Verify messages exist in both channels
      final cid1Messages = await messageDao.getMessagesByCid(cid1);
      final cid2Messages = await messageDao.getMessagesByCid(cid2);
      expect(cid1Messages, isNotEmpty);
      expect(cid2Messages, isNotEmpty);

      // Count messages from the specific user in cid1
      final cid1UserMessages = cid1Messages.where((m) => m.user?.id == userId).length;
      expect(cid1UserMessages, greaterThan(0));

      // Hard delete messages from user in cid1 only
      await messageDao.deleteMessagesByUser(
        cid: cid1,
        userId: userId,
        hardDelete: true,
      );

      // Verify user's messages are deleted from cid1
      final cid1MessagesAfter = await messageDao.getMessagesByCid(cid1);
      final cid1UserMessagesAfter = cid1MessagesAfter.where((m) => m.user?.id == userId).length;
      expect(cid1UserMessagesAfter, 0);

      // Verify other users' messages in cid1 are not affected
      expect(cid1MessagesAfter.length, cid1Messages.length - cid1UserMessages);

      // Verify messages in cid2 are not affected
      final cid2MessagesAfter = await messageDao.getMessagesByCid(cid2);
      expect(cid2MessagesAfter.length, cid2Messages.length);
    });

    test('soft deletes user messages in specific channel', () async {
      // Preparing test data
      await _prepareTestData(cid1);

      final cid1Messages = await messageDao.getMessagesByCid(cid1);
      final cid1UserMessages = cid1Messages.where((m) => m.user?.id == userId).toList();
      expect(cid1UserMessages, isNotEmpty);

      // Verify messages are not deleted initially
      for (final message in cid1UserMessages) {
        expect(message.type, isNot('deleted'));
        expect(message.deletedAt, isNull);
      }

      // Soft delete messages from user
      final deletedAt = DateTime.now();
      await messageDao.deleteMessagesByUser(
        cid: cid1,
        userId: userId,
        hardDelete: false,
        deletedAt: deletedAt,
      );

      // Verify messages are marked as deleted
      final cid1MessagesAfter = await messageDao.getMessagesByCid(cid1);
      final cid1UserMessagesAfter = cid1MessagesAfter.where((m) => m.user?.id == userId).toList();

      // Messages should still exist in DB
      expect(cid1UserMessagesAfter.length, cid1UserMessages.length);

      // But they should be marked as deleted
      for (final message in cid1UserMessagesAfter) {
        expect(message.type, 'deleted');
        expect(message.deletedAt, isNotNull);
      }

      // Other users' messages should not be affected
      final otherUserMessages = cid1MessagesAfter.where((m) => m.user?.id != userId).toList();
      for (final message in otherUserMessages) {
        expect(message.type, isNot('deleted'));
      }
    });

    test('hard deletes user messages across all channels when cid is null', () async {
      // Preparing test data for multiple channels
      await _prepareTestData(cid1);
      await _prepareTestData(cid2);

      final cid1Messages = await messageDao.getMessagesByCid(cid1);
      final cid2Messages = await messageDao.getMessagesByCid(cid2);

      final cid1UserMessages = cid1Messages.where((m) => m.user?.id == userId).length;
      final cid2UserMessages = cid2Messages.where((m) => m.user?.id == userId).length;

      expect(cid1UserMessages, greaterThan(0));
      expect(cid2UserMessages, greaterThan(0));

      // Hard delete all messages from user across all channels
      await messageDao.deleteMessagesByUser(
        userId: userId,
        hardDelete: true,
      );

      // Verify user's messages are deleted from both channels
      final cid1MessagesAfter = await messageDao.getMessagesByCid(cid1);
      final cid2MessagesAfter = await messageDao.getMessagesByCid(cid2);

      expect(cid1MessagesAfter.where((m) => m.user?.id == userId).length, 0);
      expect(cid2MessagesAfter.where((m) => m.user?.id == userId).length, 0);

      // Verify other messages are preserved
      expect(
        cid1MessagesAfter.length,
        cid1Messages.length - cid1UserMessages,
      );
      expect(
        cid2MessagesAfter.length,
        cid2Messages.length - cid2UserMessages,
      );
    });

    test('soft deletes user messages across all channels when cid is null', () async {
      // Preparing test data for multiple channels
      await _prepareTestData(cid1);
      await _prepareTestData(cid2);

      final cid1Messages = await messageDao.getMessagesByCid(cid1);
      final cid2Messages = await messageDao.getMessagesByCid(cid2);

      final cid1UserMessages = cid1Messages.where((m) => m.user?.id == userId).length;
      final cid2UserMessages = cid2Messages.where((m) => m.user?.id == userId).length;

      // Soft delete all messages from user across all channels
      await messageDao.deleteMessagesByUser(
        userId: userId,
        hardDelete: false,
      );

      // Verify user's messages are marked as deleted in both channels
      final cid1MessagesAfter = await messageDao.getMessagesByCid(cid1);
      final cid2MessagesAfter = await messageDao.getMessagesByCid(cid2);

      final cid1UserMessagesAfter = cid1MessagesAfter.where((m) => m.user?.id == userId).toList();
      final cid2UserMessagesAfter = cid2MessagesAfter.where((m) => m.user?.id == userId).toList();

      // Messages should still exist
      expect(cid1UserMessagesAfter.length, cid1UserMessages);
      expect(cid2UserMessagesAfter.length, cid2UserMessages);

      // All user messages should be marked as deleted
      for (final message in [...cid1UserMessagesAfter, ...cid2UserMessagesAfter]) {
        expect(message.type, 'deleted');
        expect(message.deletedAt, isNotNull);
      }
    });

    test('handles thread messages correctly', () async {
      // Preparing test data with threads
      await _prepareTestData(cid1, threads: true);

      final cid1ThreadMessages = await messageDao.getThreadMessages(cid1);

      final userThreadMessages = cid1ThreadMessages.where((m) => m.user?.id == userId).length;
      expect(userThreadMessages, greaterThan(0));

      // Hard delete all messages from user
      await messageDao.deleteMessagesByUser(
        cid: cid1,
        userId: userId,
        hardDelete: true,
      );

      // Verify thread messages from user are also deleted
      final cid1ThreadMessagesAfter = await messageDao.getThreadMessages(cid1);
      final userThreadMessagesAfter = cid1ThreadMessagesAfter.where((m) => m.user?.id == userId).length;
      expect(userThreadMessagesAfter, 0);
    });
  });

  tearDown(() async {
    await database.disconnect();
  });
}
