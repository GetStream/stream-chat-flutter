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
    final messages = List.generate(
      count,
      (index) => Message(
        id: 'testMessageId$cid$index',
        type: 'testType',
        user: users[index],
        createdAt: DateTime.now(),
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
        createdAt: DateTime.now(),
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
        parentId:
            mapAllThreadToFirstMessage ? messages[0].id : messages[index].id,
        createdAt: DateTime.now(),
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
    final newReactions =
        await database.reactionDao.getReactions(firstMessageId);
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
        final cid1Reactions =
            await database.reactionDao.getReactions(cid1firstMessageId);
        expect(cid1Reactions.length, 1);

        // Deleting all the messages of cid1
        await messageDao.deleteMessageByCids([cid1]);

        // Fetched messages length of only cid1 should be empty
        final cid1FetchedMessages = await messageDao.getMessagesByCid(cid1);
        final cid2FetchedMessages = await messageDao.getMessagesByCid(cid2);
        expect(cid1FetchedMessages, isEmpty);
        expect(cid2FetchedMessages, isNotEmpty);

        // Reaction for the first message should be deleted too
        final cid1FetchedReactions =
            await database.reactionDao.getReactions(cid1firstMessageId);
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
        final cid1Reactions =
            await database.reactionDao.getReactions(cid1FirstMessageId);
        expect(cid1Reactions.length, 1);
        final cid2FirstMessageId = cid2Messages.first.id;
        final cid2Reactions =
            await database.reactionDao.getReactions(cid2FirstMessageId);
        expect(cid2Reactions.length, 1);

        // Deleting all the messages of cid1
        await messageDao.deleteMessageByCids([cid1, cid2]);

        // Fetched messages length of both cid1 and cid2 should be empty
        final cid1FetchedMessages = await messageDao.getMessagesByCid(cid1);
        final cid2FetchedMessages = await messageDao.getMessagesByCid(cid2);
        expect(cid1FetchedMessages, isEmpty);
        expect(cid2FetchedMessages, isEmpty);

        // Reaction for the first message should be deleted too
        final cid1FetchedReactions =
            await database.reactionDao.getReactions(cid1FirstMessageId);
        expect(cid1FetchedReactions, isEmpty);
        final cid2FetchedReactions =
            await database.reactionDao.getReactions(cid2FirstMessageId);
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

  test('getThreadMessagesByParentId', () async {
    const cid = 'test:Cid';
    const parentId = 'testMessageId${cid}0';

    // Messages should be empty initially
    final messages = await messageDao.getThreadMessagesByParentId(parentId);
    expect(messages, isEmpty);

    // Preparing test data
    final insertedMessages = await _prepareTestData(cid, threads: true);
    expect(insertedMessages, isNotEmpty);

    // Should fetch all the thread messages of parentId
    final threadMessages =
        await messageDao.getThreadMessagesByParentId(parentId);
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

    // Should fetch all the thread messages of parentId and apply the pagination
    final threadMessages = await messageDao.getThreadMessagesByParentId(
      parentId,
      options: options,
    );
    expect(threadMessages.length, 15);
    expect(threadMessages.first.parentId, parentId);
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
    const greaterThanOrEqual = 'testMessageId${cid}5';
    const pagination = PaginationParams(
      limit: limit,
      lessThan: lessThan,
      greaterThanOrEqual: greaterThanOrEqual,
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
    expect(fetchedMessages.last.id, 'testMessageId${cid}24');
    expect(fetchedMessages.first.id != lessThan, true);
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

  tearDown(() async {
    await database.disconnect();
  });
}
