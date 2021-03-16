import 'dart:math' as math;

import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/dao.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:test/test.dart';

void main() {
  PinnedMessageDao pinnedMessageDao;
  MoorChatDatabase database;

  setUp(() {
    database = MoorChatDatabase.testable('testUserId');
    pinnedMessageDao = database.pinnedMessageDao;
  });

  Future<List<Message>> _prepareTestData(
    String cid, {
    bool threads = false,
    int count = 3,
  }) async {
    final messages = List.generate(
      count,
      (index) => Message(
        id: 'testMessageId$cid$index',
        type: 'testType',
        user: User(id: 'testUserId$index'),
        createdAt: DateTime.now(),
        shadowed: math.Random().nextBool(),
        showInChannel: math.Random().nextBool(),
        replyCount: index,
        updatedAt: DateTime.now(),
        extraData: {'extra_test_field': 'extraTestData'},
        text: 'Dummy text #$index',
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
        user: User(id: 'testUserId$index'),
        parentId: messages[index].id,
        createdAt: DateTime.now(),
        shadowed: math.Random().nextBool(),
        showInChannel: math.Random().nextBool(),
        replyCount: index,
        updatedAt: DateTime.now(),
        extraData: {'extra_test_field': 'extraTestData'},
        text: 'Dummy text #$index',
        pinned: math.Random().nextBool(),
        pinnedAt: DateTime.now(),
        pinnedBy: User(id: 'testUserId$index'),
      ),
    );
    final allMessages = [...messages, if (threads) ...threadMessages];
    await pinnedMessageDao.updateMessages(cid, allMessages);
    return allMessages;
  }

  test('deleteMessageByIds', () async {
    const cid = 'testCid';

    // Preparing test data
    final insertedMessages = await _prepareTestData(cid);

    // Fetched message list should match the test message list length
    final messages = await pinnedMessageDao.getMessagesByCid(cid);
    expect(messages.length, insertedMessages.length);

    // Deleting 2 messages from DB
    await pinnedMessageDao.deleteMessageByIds(
      ['testMessageId${cid}0', 'testMessageId${cid}1'],
    );

    // New fetched messages length should 2 less than the
    // previous fetched messages
    final newMessages = await pinnedMessageDao.getMessagesByCid(cid);
    expect(newMessages.length, messages.length - 2);
  });

  group('deleteMessageByCids', () {
    const cid1 = 'testCid1';
    const cid2 = 'testCid2';

    test('should delete all the messages of first channel', () async {
      // Preparing test data
      final cid1InsertedMessages = await _prepareTestData(cid1);
      final cid2InsertedMessages = await _prepareTestData(cid2);

      // Fetched message list should match the test message list length
      final cid1Messages = await pinnedMessageDao.getMessagesByCid(cid1);
      final cid2Messages = await pinnedMessageDao.getMessagesByCid(cid2);
      expect(cid1Messages.length, cid1InsertedMessages.length);
      expect(cid2Messages.length, cid2InsertedMessages.length);

      // Deleting all the messages of cid1
      await pinnedMessageDao.deleteMessageByCids([cid1]);

      // Fetched messages length of only cid1 should be empty
      final cid1FetchedMessages = await pinnedMessageDao.getMessagesByCid(cid1);
      final cid2FetchedMessages = await pinnedMessageDao.getMessagesByCid(cid2);
      expect(cid1FetchedMessages, isEmpty);
      expect(cid2FetchedMessages, isNotEmpty);
    });

    test('should delete all the messages of both channel', () async {
      // Preparing test data
      final cid1InsertedMessages = await _prepareTestData(cid1);
      final cid2InsertedMessages = await _prepareTestData(cid2);

      // Fetched message list should match the test message list length
      final cid1Messages = await pinnedMessageDao.getMessagesByCid(cid1);
      final cid2Messages = await pinnedMessageDao.getMessagesByCid(cid2);
      expect(cid1Messages.length, cid1InsertedMessages.length);
      expect(cid2Messages.length, cid2InsertedMessages.length);

      // Deleting all the messages of cid1
      await pinnedMessageDao.deleteMessageByCids([cid1, cid2]);

      // Fetched messages length of both cid1 and cid2 should be empty
      final cid1FetchedMessages = await pinnedMessageDao.getMessagesByCid(cid1);
      final cid2FetchedMessages = await pinnedMessageDao.getMessagesByCid(cid2);
      expect(cid1FetchedMessages, isEmpty);
      expect(cid2FetchedMessages, isEmpty);
    });
  });

  test('getMessageById', () async {
    const cid = 'testCid';
    const id = 'testMessageId${cid}0';

    // Should be null initially
    final message = await pinnedMessageDao.getMessageById(id);
    expect(message, isNull);

    // Adding test message with the cid and id
    final insertedMessages = await _prepareTestData(cid, count: 1);
    expect(insertedMessages.first.id, id);

    // Fetched message id should match the inserted message id
    final fetchedMessage = await pinnedMessageDao.getMessageById(id);
    expect(fetchedMessage.id, insertedMessages.first.id);
  });

  test('getThreadMessages', () async {
    const cid = 'testCid';

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
    const cid = 'testCid';
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

  test('getMessagesByCid', () async {
    const cid = 'testCid';

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

  test('updateMessages', () async {
    const cid = 'testCid';

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
      extraData: {'extra_test_field': 'extraTestData'},
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
      fetchedMessages.map((it) => it.id).contains('testMessageId${cid}4'),
      true,
    );
  });

  tearDown(() async {
    await database.disconnect();
  });
}
