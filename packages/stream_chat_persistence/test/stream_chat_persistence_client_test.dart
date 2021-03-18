import 'package:mockito/mockito.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:stream_chat_persistence/src/stream_chat_persistence_client.dart';
import 'package:test/test.dart';
import 'mock_chat_database.dart';
import 'src/utils/date_matcher.dart';

MoorChatDatabase _testDatabaseProvider(String userId, ConnectionMode mode) =>
    MoorChatDatabase.testable(userId);

void main() {
  group('connect', () {
    const userId = 'testUserId';
    test('successfully connects with the Database', () async {
      final client = StreamChatPersistenceClient(logLevel: Level.ALL);
      expect(client.db, isNull);
      await client.connect(userId, databaseProvider: _testDatabaseProvider);
      expect(client.db, isNotNull);
      expect(client.db, isA<MoorChatDatabase>());
      expect(client.db.userId, userId);

      addTearDown(() async {
        await client.disconnect();
      });
    });

    test('throws if already connected', () async {
      final client = StreamChatPersistenceClient(logLevel: Level.ALL);
      expect(client.db, isNull);
      await client.connect(userId, databaseProvider: _testDatabaseProvider);
      expect(client.db, isNotNull);
      expect(client.db, isNotNull);
      expect(client.db, isA<MoorChatDatabase>());
      expect(client.db.userId, userId);
      expect(
        () => client.connect(userId, databaseProvider: _testDatabaseProvider),
        throwsException,
      );

      addTearDown(() async {
        await client.disconnect();
      });
    });
  });

  test('disconnect', () async {
    const userId = 'testUserId';
    final client = StreamChatPersistenceClient(logLevel: Level.ALL);
    await client.connect(userId, databaseProvider: _testDatabaseProvider);
    expect(client.db, isNotNull);
    await client.disconnect(flush: true);
    expect(client.db, isNull);
  });

  group('client functions', () {
    const userId = 'testUserId';
    final mockDatabase = MockChatDatabase();
    MoorChatDatabase _mockDatabaseProvider(_, __) => mockDatabase;
    StreamChatPersistenceClient client;

    setUp(() async {
      client = StreamChatPersistenceClient(logLevel: Level.ALL);
      await client.connect(userId, databaseProvider: _mockDatabaseProvider);
    });

    test('getReplies', () async {
      const parentId = 'testParentId';
      final replies = List.generate(3, (index) => Message(id: 'testId$index'));

      when(mockDatabase.messageDao.getThreadMessagesByParentId(parentId))
          .thenAnswer((_) async => replies);

      final fetchedReplies = await client.getReplies(parentId);
      expect(fetchedReplies.length, replies.length);
      verify(mockDatabase.messageDao.getThreadMessagesByParentId(parentId))
          .called(1);
    });

    test('getConnectionInfo', () async {
      final event = Event(type: 'testEvent');
      when(mockDatabase.connectionEventDao.connectionEvent)
          .thenAnswer((_) async => event);

      final fetchedEvent = await client.getConnectionInfo();
      expect(fetchedEvent.type, event.type);
      verify(mockDatabase.connectionEventDao.connectionEvent).called(1);
    });

    test('getLastSyncAt', () async {
      final lastSync = DateTime.now();
      when(mockDatabase.connectionEventDao.lastSyncAt)
          .thenAnswer((_) async => lastSync);

      final fetchedLastSync = await client.getLastSyncAt();
      expect(fetchedLastSync, isSameDateAs(lastSync));
      verify(mockDatabase.connectionEventDao.lastSyncAt).called(1);
    });

    test('updateConnectionInfo', () async {
      final event = Event(type: 'testEvent');
      when(mockDatabase.connectionEventDao.updateConnectionEvent(event))
          .thenAnswer((_) async {
        return;
      });

      await client.updateConnectionInfo(event);
      verify(mockDatabase.connectionEventDao.updateConnectionEvent(event))
          .called(1);
    });

    test('updateLastSyncAt', () async {
      final lastSync = DateTime.now();
      when(mockDatabase.connectionEventDao.updateLastSyncAt(lastSync))
          .thenAnswer((_) {
        return;
      });

      await client.updateLastSyncAt(lastSync);
      verify(mockDatabase.connectionEventDao.updateLastSyncAt(lastSync))
          .called(1);
    });

    test('getChannelCids', () async {
      final channelCids = List.generate(3, (index) => 'testCid$index');
      when(mockDatabase.channelDao.cids).thenAnswer((_) async => channelCids);

      final fetchedChannelCids = await client.getChannelCids();
      expect(fetchedChannelCids.length, channelCids.length);
      verify(mockDatabase.channelDao.cids).called(1);
    });

    test('getChannelByCid', () async {
      const cid = 'testCid';
      final channelModel = ChannelModel(cid: cid);
      when(mockDatabase.channelDao.getChannelByCid(cid))
          .thenAnswer((_) async => channelModel);

      final fetchedChannelModel = await client.getChannelByCid(cid);
      expect(fetchedChannelModel.cid, channelModel.cid);
      verify(mockDatabase.channelDao.getChannelByCid(cid)).called(1);
    });

    test('getMembersByCid', () async {
      const cid = 'testCid';
      final members = List.generate(3, (index) => Member());
      when(mockDatabase.memberDao.getMembersByCid(cid))
          .thenAnswer((_) async => members);

      final fetchedMembers = await client.getMembersByCid(cid);
      expect(fetchedMembers.length, members.length);
      verify(mockDatabase.memberDao.getMembersByCid(cid)).called(1);
    });

    test('getReadsByCid', () async {
      const cid = 'testCid';
      final reads = List.generate(3, (index) => Read());
      when(mockDatabase.readDao.getReadsByCid(cid))
          .thenAnswer((_) async => reads);

      final fetchedReads = await client.getReadsByCid(cid);
      expect(fetchedReads.length, reads.length);
      verify(mockDatabase.readDao.getReadsByCid(cid)).called(1);
    });

    test('getMessagesByCid', () async {
      const cid = 'testCid';
      final messages = List.generate(3, (index) => Message());
      when(mockDatabase.messageDao.getMessagesByCid(cid))
          .thenAnswer((_) async => messages);

      final fetchedMessages = await client.getMessagesByCid(cid);
      expect(fetchedMessages.length, messages.length);
      verify(mockDatabase.messageDao.getMessagesByCid(cid)).called(1);
    });

    test('getPinnedMessagesByCid', () async {
      const cid = 'testCid';
      final messages = List.generate(3, (index) => Message());
      when(mockDatabase.pinnedMessageDao.getMessagesByCid(cid))
          .thenAnswer((_) async => messages);

      final fetchedMessages = await client.getPinnedMessagesByCid(cid);
      expect(fetchedMessages.length, messages.length);
      verify(mockDatabase.pinnedMessageDao.getMessagesByCid(cid)).called(1);
    });

    test('getChannelStateByCid', () async {
      const cid = 'testCid';
      final messages = List.generate(3, (index) => Message());
      final members = List.generate(3, (index) => Member());
      final reads = List.generate(3, (index) => Read());
      final channel = ChannelModel(cid: cid);

      when(mockDatabase.memberDao.getMembersByCid(cid))
          .thenAnswer((_) async => members);
      when(mockDatabase.readDao.getReadsByCid(cid))
          .thenAnswer((_) async => reads);
      when(mockDatabase.channelDao.getChannelByCid(cid))
          .thenAnswer((_) async => channel);
      when(mockDatabase.messageDao.getMessagesByCid(cid))
          .thenAnswer((_) async => messages);
      when(mockDatabase.pinnedMessageDao.getMessagesByCid(cid))
          .thenAnswer((_) async => messages);

      final fetchedChannelState = await client.getChannelStateByCid(cid);
      expect(fetchedChannelState.messages.length, messages.length);
      expect(fetchedChannelState.pinnedMessages.length, messages.length);
      expect(fetchedChannelState.members.length, members.length);
      expect(fetchedChannelState.read.length, reads.length);
      expect(fetchedChannelState.channel.cid, channel.cid);

      verify(mockDatabase.memberDao.getMembersByCid(cid)).called(1);
      verify(mockDatabase.readDao.getReadsByCid(cid)).called(1);
      verify(mockDatabase.channelDao.getChannelByCid(cid)).called(1);
      verify(mockDatabase.messageDao.getMessagesByCid(cid)).called(1);
      verify(mockDatabase.pinnedMessageDao.getMessagesByCid(cid)).called(1);
    });

    test('getChannelStates', () async {
      const cid = 'testCid';
      final channels = List.generate(3, (index) => ChannelModel(cid: cid));
      final messages = List.generate(3, (index) => Message());
      final members = List.generate(3, (index) => Member());
      final reads = List.generate(3, (index) => Read());
      final channel = ChannelModel(cid: cid);
      final channelStates = channels
          .map(
            (channel) => ChannelState(
              channel: channel,
              messages: messages,
              pinnedMessages: messages,
              members: members,
              read: reads,
            ),
          )
          .toList(growable: false);

      when(mockDatabase.channelQueryDao.getChannels())
          .thenAnswer((_) async => channels);
      when(mockDatabase.memberDao.getMembersByCid(cid))
          .thenAnswer((_) async => members);
      when(mockDatabase.readDao.getReadsByCid(cid))
          .thenAnswer((_) async => reads);
      when(mockDatabase.channelDao.getChannelByCid(cid))
          .thenAnswer((_) async => channel);
      when(mockDatabase.messageDao.getMessagesByCid(cid))
          .thenAnswer((_) async => messages);
      when(mockDatabase.pinnedMessageDao.getMessagesByCid(cid))
          .thenAnswer((_) async => messages);

      final fetchedChannelStates = await client.getChannelStates();
      expect(fetchedChannelStates.length, channelStates.length);

      for (var i = 0; i < fetchedChannelStates.length; i++) {
        final original = channelStates[i];
        final fetched = fetchedChannelStates[i];
        expect(fetched.members.length, original.members.length);
        expect(fetched.messages.length, original.messages.length);
        expect(fetched.pinnedMessages.length, original.pinnedMessages.length);
        expect(fetched.read.length, original.read.length);
        expect(fetched.channel.cid, original.channel.cid);
      }

      verify(mockDatabase.channelQueryDao.getChannels()).called(1);
      verify(mockDatabase.memberDao.getMembersByCid(cid)).called(3);
      verify(mockDatabase.readDao.getReadsByCid(cid)).called(3);
      verify(mockDatabase.channelDao.getChannelByCid(cid)).called(3);
      verify(mockDatabase.messageDao.getMessagesByCid(cid)).called(3);
      verify(mockDatabase.pinnedMessageDao.getMessagesByCid(cid)).called(3);
    });

    test('updateChannelQueries', () async {
      const filter = <String, dynamic>{};
      const cids = <String>[];
      when(mockDatabase.channelQueryDao.updateChannelQueries(filter, cids))
          .thenAnswer((realInvocation) async {
        return;
      });

      await client.updateChannelQueries(filter, cids);
      verify(mockDatabase.channelQueryDao.updateChannelQueries(filter, cids))
          .called(1);
    });

    test('deleteMessageById', () async {
      const messageId = 'testMessageId';
      when(mockDatabase.messageDao.deleteMessageByIds([messageId]))
          .thenAnswer((_) async {
        return;
      });

      await client.deleteMessageById(messageId);
      verify(mockDatabase.messageDao.deleteMessageByIds([messageId])).called(1);
    });

    test('deletePinnedMessageById', () async {
      const messageId = 'testMessageId';
      when(mockDatabase.pinnedMessageDao.deleteMessageByIds([messageId]))
          .thenAnswer((_) async {
        return;
      });

      await client.deletePinnedMessageById(messageId);
      verify(mockDatabase.pinnedMessageDao.deleteMessageByIds([messageId]))
          .called(1);
    });

    test('deleteMessageByIds', () async {
      const messageIds = <String>[];
      when(mockDatabase.messageDao.deleteMessageByIds(messageIds))
          .thenAnswer((_) async {
        return;
      });

      await client.deleteMessageByIds(messageIds);
      verify(mockDatabase.messageDao.deleteMessageByIds(messageIds)).called(1);
    });

    test('deletePinnedMessageByIds', () async {
      const messageIds = <String>[];
      when(mockDatabase.pinnedMessageDao.deleteMessageByIds(messageIds))
          .thenAnswer((_) async {
        return;
      });

      await client.deletePinnedMessageByIds(messageIds);
      verify(mockDatabase.pinnedMessageDao.deleteMessageByIds(messageIds))
          .called(1);
    });

    test('deleteMessageByCid', () async {
      const cid = 'testCid';
      when(mockDatabase.messageDao.deleteMessageByCids([cid]))
          .thenAnswer((_) async {
        return;
      });

      await client.deleteMessageByCid(cid);
      verify(mockDatabase.messageDao.deleteMessageByCids([cid])).called(1);
    });

    test('deletePinnedMessageByCid', () async {
      const cid = 'testCid';
      when(mockDatabase.pinnedMessageDao.deleteMessageByCids([cid]))
          .thenAnswer((_) async {
        return;
      });

      await client.deletePinnedMessageByCid(cid);
      verify(mockDatabase.pinnedMessageDao.deleteMessageByCids([cid]))
          .called(1);
    });

    test('deleteMessageByCids', () async {
      const cids = <String>[];
      when(mockDatabase.messageDao.deleteMessageByCids(cids))
          .thenAnswer((_) async {
        return;
      });

      await client.deleteMessageByCids(cids);
      verify(mockDatabase.messageDao.deleteMessageByCids(cids)).called(1);
    });

    test('deletePinnedMessageByCids', () async {
      const cids = <String>[];
      when(mockDatabase.pinnedMessageDao.deleteMessageByCids(cids))
          .thenAnswer((_) async {
        return;
      });

      await client.deletePinnedMessageByCids(cids);
      verify(mockDatabase.pinnedMessageDao.deleteMessageByCids(cids)).called(1);
    });

    test('deleteChannels', () async {
      const cids = <String>[];
      when(mockDatabase.channelDao.deleteChannelByCids(cids))
          .thenAnswer((_) async {
        return;
      });

      await client.deleteChannels(cids);
      verify(mockDatabase.channelDao.deleteChannelByCids(cids)).called(1);
    });

    test('updateMessages', () async {
      const cid = 'testCid';
      final messages = List.generate(3, (index) => Message());
      when(mockDatabase.messageDao.updateMessages(cid, messages))
          .thenAnswer((_) async {
        return;
      });

      await client.updateMessages(cid, messages);
      verify(mockDatabase.messageDao.updateMessages(cid, messages)).called(1);
    });

    test('updatePinnedMessages', () async {
      const cid = 'testCid';
      final messages = List.generate(3, (index) => Message());
      when(mockDatabase.pinnedMessageDao.updateMessages(cid, messages))
          .thenAnswer((_) async {
        return;
      });

      await client.updatePinnedMessages(cid, messages);
      verify(mockDatabase.pinnedMessageDao.updateMessages(cid, messages))
          .called(1);
    });

    test('getChannelThreads', () async {
      const cid = 'testCid';
      final messages =
          List.generate(3, (index) => Message(parentId: 'testParentId$index'));
      final threads = messages.fold<Map<String, List<Message>>>(
        {},
        (prev, curr) {
          return prev
            ..update(
              curr.parentId,
              (value) => [...value, curr],
              ifAbsent: () => [],
            );
        },
      );
      when(mockDatabase.messageDao.getThreadMessages(cid))
          .thenAnswer((realInvocation) async => messages);

      final fetchedThreads = await client.getChannelThreads(cid);
      expect(fetchedThreads.length, threads.length);
      for (var i = 0; i < fetchedThreads.length; i++) {
        final original = threads.entries.elementAt(i);
        final fetched = fetchedThreads.entries.elementAt(i);
        expect(fetched.key, original.key);
      }

      verify(mockDatabase.messageDao.getThreadMessages(cid)).called(1);
    });

    test('updateChannels', () async {
      final channels = List.generate(3, (index) => ChannelModel());
      when(mockDatabase.channelDao.updateChannels(channels))
          .thenAnswer((_) async {
        return;
      });

      await client.updateChannels(channels);
      verify(mockDatabase.channelDao.updateChannels(channels)).called(1);
    });

    test('updateMembers', () async {
      const cid = 'testCid';
      final members = List.generate(3, (index) => Member());
      when(mockDatabase.memberDao.updateMembers(cid, members))
          .thenAnswer((_) async {
        return;
      });

      await client.updateMembers(cid, members);
      verify(mockDatabase.memberDao.updateMembers(cid, members)).called(1);
    });

    test('updateReads', () async {
      const cid = 'testCid';
      final reads = List.generate(3, (index) => Read());
      when(mockDatabase.readDao.updateReads(cid, reads)).thenAnswer((_) async {
        return;
      });

      await client.updateReads(cid, reads);
      verify(mockDatabase.readDao.updateReads(cid, reads)).called(1);
    });

    test('updateUsers', () async {
      final users = List.generate(3, (index) => User());
      when(mockDatabase.userDao.updateUsers(users)).thenAnswer((_) async {
        return;
      });

      await client.updateUsers(users);
      verify(mockDatabase.userDao.updateUsers(users)).called(1);
    });

    test('updateReactions', () async {
      final reactions = List.generate(3, (index) => Reaction());
      when(mockDatabase.reactionDao.updateReactions(reactions))
          .thenAnswer((_) async {
        return;
      });

      await client.updateReactions(reactions);
      verify(mockDatabase.reactionDao.updateReactions(reactions)).called(1);
    });

    test('deleteReactionsByMessageId', () async {
      final messageIds = <String>[];
      when(mockDatabase.reactionDao.deleteReactionsByMessageIds(messageIds))
          .thenAnswer((_) async {
        return;
      });

      await client.deleteReactionsByMessageId(messageIds);
      verify(mockDatabase.reactionDao.deleteReactionsByMessageIds(messageIds))
          .called(1);
    });

    test('deleteMembersByCids', () async {
      final cids = <String>[];
      when(mockDatabase.memberDao.deleteMemberByCids(cids))
          .thenAnswer((_) async {
        return;
      });

      await client.deleteMembersByCids(cids);
      verify(mockDatabase.memberDao.deleteMemberByCids(cids)).called(1);
    });

    tearDown(() async {
      await client.disconnect(flush: true);
    });
  });
}
