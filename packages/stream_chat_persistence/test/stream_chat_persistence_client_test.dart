import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/stream_chat_persistence_client.dart';

import 'mock_chat_database.dart';
import 'src/utils/date_matcher.dart';

DriftChatDatabase testDatabaseProvider(String userId, [ConnectionMode? mode]) =>
    DriftChatDatabase(userId, NativeDatabase.memory());

void main() {
  group('connect', () {
    const userId = 'testUserId';
    test('successfully connects with the Database', () async {
      final client = StreamChatPersistenceClient(logLevel: Level.ALL);
      expect(client.isConnected, false);
      await client.connect(userId, databaseProvider: testDatabaseProvider);
      expect(client.isConnected, true);
      expect(client.db, isA<DriftChatDatabase>());
      expect(client.userId, userId);

      addTearDown(() async {
        await client.disconnect();
      });
    });

    test('throws if already connected', () async {
      final client = StreamChatPersistenceClient(logLevel: Level.ALL);
      expect(client.isConnected, false);
      await client.connect(userId, databaseProvider: testDatabaseProvider);
      expect(client.isConnected, true);
      expect(client.db, isA<DriftChatDatabase>());
      expect(client.userId, userId);
      expect(
        () => client.connect(userId, databaseProvider: testDatabaseProvider),
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
    await client.connect(userId, databaseProvider: testDatabaseProvider);
    expect(client.isConnected, true);
    await client.disconnect(flush: true);
    expect(client.isConnected, false);
  });

  test('flush', () async {
    const userId = 'testUserId';
    final client = StreamChatPersistenceClient(logLevel: Level.ALL);

    await client.connect(userId, databaseProvider: testDatabaseProvider);
    addTearDown(() async => client.disconnect());

    final connectionEvent = Event(
      type: EventType.healthCheck,
      createdAt: DateTime.timestamp(),
      me: OwnUser(id: userId, name: 'Test User'),
    );

    await client.updateConnectionInfo(connectionEvent);

    // Add some test data
    final testDate = DateTime.now();
    await client.updateLastSyncAt(testDate);

    // Verify data exists
    final lastSyncAtBeforeFlush = await client.getLastSyncAt();
    expect(lastSyncAtBeforeFlush, isNotNull);

    // Flush the database
    await client.flush();

    // Verify data is cleared
    final lastSyncAtAfterFlush = await client.getLastSyncAt();
    expect(lastSyncAtAfterFlush, isNull);
  });

  test('client function throws stateError if db is not yet connected', () {
    final client = StreamChatPersistenceClient(logLevel: Level.ALL);
    expect(
      // Running a function that requires db connection.
      () => client.getReplies('testParentId'),
      throwsA(isA<StateError>()),
    );
  });

  group('client functions', () {
    const userId = 'testUserId';
    final mockDatabase = MockChatDatabase();
    DriftChatDatabase _mockDatabaseProvider(_, __) => mockDatabase;
    late StreamChatPersistenceClient client;

    setUpAll(() {
      registerFallbackValue(<String>[]);
    });

    setUp(() async {
      client = StreamChatPersistenceClient(logLevel: Level.ALL);
      await client.connect(userId, databaseProvider: _mockDatabaseProvider);
    });

    tearDown(() async {
      await client.disconnect();
    });

    test('getReplies', () async {
      const parentId = 'testParentId';
      final replies = List.generate(3, (index) => Message(id: 'testId$index'));

      when(() => mockDatabase.messageDao.getThreadMessagesByParentId(parentId))
          .thenAnswer((_) async => replies);

      final fetchedReplies = await client.getReplies(parentId);
      expect(fetchedReplies.length, replies.length);
      verify(() =>
              mockDatabase.messageDao.getThreadMessagesByParentId(parentId))
          .called(1);
    });

    test('getConnectionInfo', () async {
      final event = Event();
      when(() => mockDatabase.connectionEventDao.connectionEvent)
          .thenAnswer((_) async => event);

      final fetchedEvent = await client.getConnectionInfo();
      expect(fetchedEvent, isNotNull);
      expect(fetchedEvent!.type, event.type);
      verify(() => mockDatabase.connectionEventDao.connectionEvent).called(1);
    });

    test('getLastSyncAt', () async {
      final lastSync = DateTime.now();
      when(() => mockDatabase.connectionEventDao.lastSyncAt)
          .thenAnswer((_) async => lastSync);

      final fetchedLastSync = await client.getLastSyncAt();
      expect(fetchedLastSync, isSameDateAs(lastSync));
      verify(() => mockDatabase.connectionEventDao.lastSyncAt).called(1);
    });

    test('updateConnectionInfo', () async {
      final event = Event();
      when(() => mockDatabase.connectionEventDao.updateConnectionEvent(event))
          .thenAnswer((_) async => 1);

      await client.updateConnectionInfo(event);
      verify(() => mockDatabase.connectionEventDao.updateConnectionEvent(event))
          .called(1);
    });

    test('updateLastSyncAt', () async {
      final lastSync = DateTime.now();
      when(() => mockDatabase.connectionEventDao.updateLastSyncAt(lastSync))
          .thenAnswer((_) async => 1);

      await client.updateLastSyncAt(lastSync);
      verify(() => mockDatabase.connectionEventDao.updateLastSyncAt(lastSync))
          .called(1);
    });

    test('getChannelCids', () async {
      final channelCids = List.generate(3, (index) => 'testCid$index');
      when(() => mockDatabase.channelDao.cids)
          .thenAnswer((_) async => channelCids);

      final fetchedChannelCids = await client.getChannelCids();
      expect(fetchedChannelCids.length, channelCids.length);
      verify(() => mockDatabase.channelDao.cids).called(1);
    });

    test('getChannelByCid', () async {
      const cid = 'testType:testId';
      final channelModel = ChannelModel(cid: cid);
      when(() => mockDatabase.channelDao.getChannelByCid(cid))
          .thenAnswer((_) async => channelModel);

      final fetchedChannelModel = await client.getChannelByCid(cid);
      expect(fetchedChannelModel, isNotNull);
      expect(fetchedChannelModel!.cid, channelModel.cid);
      verify(() => mockDatabase.channelDao.getChannelByCid(cid)).called(1);
    });

    test('getMembersByCid', () async {
      const cid = 'testCid';
      final members = List.generate(3, (index) => Member());
      when(() => mockDatabase.memberDao.getMembersByCid(cid))
          .thenAnswer((_) async => members);

      final fetchedMembers = await client.getMembersByCid(cid);
      expect(fetchedMembers.length, members.length);
      verify(() => mockDatabase.memberDao.getMembersByCid(cid)).called(1);
    });

    test('getReadsByCid', () async {
      const cid = 'testCid';
      final reads = List.generate(
        3,
        (index) => Read(
          user: User(id: 'testUserId$index'),
          lastRead: DateTime.now(),
          lastReadMessageId: 'lastMessageId$index',
        ),
      );
      when(() => mockDatabase.readDao.getReadsByCid(cid))
          .thenAnswer((_) async => reads);

      final fetchedReads = await client.getReadsByCid(cid);
      expect(fetchedReads.length, reads.length);
      verify(() => mockDatabase.readDao.getReadsByCid(cid)).called(1);
    });

    test('getMessagesByCid', () async {
      const cid = 'testCid';
      final messages = List.generate(3, (index) => Message());
      when(() => mockDatabase.messageDao.getMessagesByCid(cid))
          .thenAnswer((_) async => messages);

      final fetchedMessages = await client.getMessagesByCid(cid);
      expect(fetchedMessages.length, messages.length);
      verify(() => mockDatabase.messageDao.getMessagesByCid(cid)).called(1);
    });

    test('getPinnedMessagesByCid', () async {
      const cid = 'testCid';
      final messages = List.generate(3, (index) => Message());
      when(() => mockDatabase.pinnedMessageDao.getMessagesByCid(cid))
          .thenAnswer((_) async => messages);

      final fetchedMessages = await client.getPinnedMessagesByCid(cid);
      expect(fetchedMessages.length, messages.length);
      verify(() => mockDatabase.pinnedMessageDao.getMessagesByCid(cid))
          .called(1);
    });

    test('getChannelStateByCid', () async {
      const cid = 'testType:testId';
      final messages = List.generate(3, (index) => Message());
      final members = List.generate(3, (index) => Member());
      final reads = List.generate(
        3,
        (index) => Read(
          user: User(id: 'testUserId$index'),
          lastRead: DateTime.now(),
          lastReadMessageId: 'lastMessageId$index',
        ),
      );
      final channel = ChannelModel(cid: cid);
      final draft = Draft(
        channelCid: cid,
        createdAt: DateTime.now(),
        message: DraftMessage(
          id: 'testDraftId',
          text: 'Test draft message',
        ),
      );

      when(() => mockDatabase.draftMessageDao.getDraftMessageByCid(cid))
          .thenAnswer((_) async => draft);

      when(() => mockDatabase.memberDao.getMembersByCid(cid))
          .thenAnswer((_) async => members);
      when(() => mockDatabase.readDao.getReadsByCid(cid))
          .thenAnswer((_) async => reads);
      when(() => mockDatabase.channelDao.getChannelByCid(cid))
          .thenAnswer((_) async => channel);
      when(() => mockDatabase.messageDao.getMessagesByCid(cid))
          .thenAnswer((_) async => messages);
      when(() => mockDatabase.pinnedMessageDao.getMessagesByCid(cid))
          .thenAnswer((_) async => messages);
      when(() => mockDatabase.draftMessageDao.getDraftMessageByCid(cid))
          .thenAnswer((_) async => draft);

      final fetchedChannelState = await client.getChannelStateByCid(cid);
      expect(fetchedChannelState.messages?.length, messages.length);
      expect(fetchedChannelState.pinnedMessages?.length, messages.length);
      expect(fetchedChannelState.members?.length, members.length);
      expect(fetchedChannelState.read?.length, reads.length);
      expect(fetchedChannelState.channel!.cid, channel.cid);
      expect(fetchedChannelState.draft?.message.id, draft.message.id);

      verify(() => mockDatabase.memberDao.getMembersByCid(cid)).called(1);
      verify(() => mockDatabase.readDao.getReadsByCid(cid)).called(1);
      verify(() => mockDatabase.channelDao.getChannelByCid(cid)).called(1);
      verify(() => mockDatabase.messageDao.getMessagesByCid(cid)).called(1);
      verify(() => mockDatabase.pinnedMessageDao.getMessagesByCid(cid))
          .called(1);
      verify(() => mockDatabase.draftMessageDao.getDraftMessageByCid(cid))
          .called(1);
    });

    group('getChannelStates', () {
      test('forwards filter, attaches memberships, sorts and paginates',
          () async {
        // Three channel models with distinct cids so sort + pagination are
        // observable in which cid gets hydrated.
        final c0 = ChannelModel(cid: 'messaging:c0');
        final c1 = ChannelModel(cid: 'messaging:c1');
        final c2 = ChannelModel(cid: 'messaging:c2');
        final channels = [c0, c1, c2];
        const cids = ['messaging:c0', 'messaging:c1', 'messaging:c2'];

        const currentUserId = 'test-user-id';
        final filter = Filter.in_('members', const [currentUserId]);

        // pinnedAt values chosen so descending order is [c1, c2, c0]. With
        // offset 1 / limit 1 the only paged cid is c2.
        final baseDate = DateTime.utc(2025);
        final memberships = <String, Member>{
          'messaging:c0': Member(
            userId: currentUserId,
            pinnedAt: baseDate.add(const Duration(days: 1)),
          ),
          'messaging:c1': Member(
            userId: currentUserId,
            pinnedAt: baseDate.add(const Duration(days: 3)),
          ),
          'messaging:c2': Member(
            userId: currentUserId,
            pinnedAt: baseDate.add(const Duration(days: 2)),
          ),
        };

        when(() => mockDatabase.channelQueryDao.getChannels(filter: filter))
            .thenAnswer((_) async => channels);
        // Lists compare by identity in Dart, so use any() matchers and verify
        // the captured args afterwards.
        when(() =>
                mockDatabase.memberDao.getMembershipsForChannels(any(), any()))
            .thenAnswer((_) async => memberships);

        // Only c2 should be hydrated — stub every per-cid DAO call.
        const pagedCid = 'messaging:c2';
        final messages = List.generate(3, (i) => Message());
        final members = List.generate(3, (i) => Member());
        final reads = List.generate(
          3,
          (i) => Read(
            user: User(id: 'testUserId$i'),
            lastRead: DateTime.now(),
            lastReadMessageId: 'lastMessageId$i',
          ),
        );
        when(() => mockDatabase.channelDao.getChannelByCid(pagedCid))
            .thenAnswer((_) async => c2);
        when(() => mockDatabase.memberDao.getMembersByCid(pagedCid))
            .thenAnswer((_) async => members);
        when(() => mockDatabase.readDao.getReadsByCid(pagedCid))
            .thenAnswer((_) async => reads);
        when(() => mockDatabase.messageDao.getMessagesByCid(pagedCid))
            .thenAnswer((_) async => messages);
        when(() => mockDatabase.pinnedMessageDao.getMessagesByCid(pagedCid))
            .thenAnswer((_) async => messages);
        when(() => mockDatabase.draftMessageDao.getDraftMessageByCid(pagedCid))
            .thenAnswer((_) async => null);

        final result = await client.getChannelStates(
          filter: filter,
          channelStateSort: const [
            SortOption<ChannelState>.desc(ChannelSortKey.pinnedAt),
          ],
          paginationParams: const PaginationParams(offset: 1, limit: 1),
        );

        // Sort + offset + limit applied: only c2 is returned.
        expect(result, hasLength(1));
        expect(result.single.channel!.cid, pagedCid);

        // Filter forwarded to the channels query.
        verify(() => mockDatabase.channelQueryDao.getChannels(filter: filter))
            .called(1);

        // Memberships batched in a single query for all cids + connected user.
        final capturedMembershipArgs = verify(() => mockDatabase.memberDao
            .getMembershipsForChannels(captureAny(), captureAny())).captured;
        expect(capturedMembershipArgs, hasLength(2));
        expect(capturedMembershipArgs.first, equals(cids));
        expect(capturedMembershipArgs.last, equals(currentUserId));

        // Only the paged cid was hydrated — c0 and c1 were skipped.
        verify(() => mockDatabase.channelDao.getChannelByCid(pagedCid))
            .called(1);
        verifyNever(
            () => mockDatabase.channelDao.getChannelByCid('messaging:c0'));
        verifyNever(
            () => mockDatabase.channelDao.getChannelByCid('messaging:c1'));
      });

      test('returns empty list and skips hydration when no channels match',
          () async {
        final filter = Filter.in_('members', const ['unknown_user']);

        when(() => mockDatabase.channelQueryDao.getChannels(filter: filter))
            .thenAnswer((_) async => <ChannelModel>[]);

        final result = await client.getChannelStates(filter: filter);

        expect(result, isEmpty);
        verify(() => mockDatabase.channelQueryDao.getChannels(filter: filter))
            .called(1);
        // No channels → no per-cid hydration calls at all.
        verifyNever(() => mockDatabase.channelDao.getChannelByCid(any()));
      });

      test('clamps offset above total to an empty page', () async {
        // Unique cid prefix so verifyNever doesn't collide with calls from
        // earlier tests in the same group (mocktail records across tests).
        final channels = List.generate(
          3,
          (i) => ChannelModel(cid: 'messaging:clamp_$i'),
        );

        when(() => mockDatabase.channelQueryDao.getChannels())
            .thenAnswer((_) async => channels);

        final result = await client.getChannelStates(
          paginationParams: const PaginationParams(offset: 100),
        );

        expect(result, isEmpty);
        for (var i = 0; i < 3; i++) {
          verifyNever(
            () => mockDatabase.channelDao.getChannelByCid('messaging:clamp_$i'),
          );
        }
      });
    });

    test('updateChannelQueries', () async {
      final filter = Filter.in_('members', const ['testUserId']);
      const cids = <String>[];
      when(() =>
              mockDatabase.channelQueryDao.updateChannelQueries(filter, cids))
          .thenAnswer((_) => Future.value());

      await client.updateChannelQueries(filter, cids);
      verify(() =>
              mockDatabase.channelQueryDao.updateChannelQueries(filter, cids))
          .called(1);
    });

    test('updateChannelQueriesByPredefinedFilter forwards all args to dao',
        () async {
      const filterName = 'sample-app-list';
      const filterValues = {'user_id': 'testUserId'};
      const sortValues = {'pinned_at': true};
      const cids = <String>['messaging:c0'];
      final filter = Filter.equal('type', 'messaging');
      const sort = <SortOption<ChannelState>>[
        SortOption<ChannelState>.desc(ChannelSortKey.lastMessageAt),
      ];

      when(
        () =>
            mockDatabase.channelQueryDao.updateChannelQueriesByPredefinedFilter(
          filterName,
          cids,
          filter: filter,
          sort: sort,
          filterValues: filterValues,
          sortValues: sortValues,
          clearQueryCache: true,
        ),
      ).thenAnswer((_) => Future.value());

      await client.updateChannelQueriesByPredefinedFilter(
        filterName,
        cids,
        filter: filter,
        sort: sort,
        filterValues: filterValues,
        sortValues: sortValues,
        clearQueryCache: true,
      );

      verify(
        () =>
            mockDatabase.channelQueryDao.updateChannelQueriesByPredefinedFilter(
          filterName,
          cids,
          filter: filter,
          sort: sort,
          filterValues: filterValues,
          sortValues: sortValues,
          clearQueryCache: true,
        ),
      ).called(1);
    });

    test(
        'getChannelStatesByPredefinedFilter applies persisted sort and paginates',
        () async {
      const filterName = 'sample-app-list';
      const filterValues = {'user_id': 'test-user-id'};
      const sortValues = {'pinned_at': true};
      const currentUserId = 'test-user-id';

      // Three channel models with distinct cids so sort + pagination are
      // observable in which cid gets hydrated.
      final c0 = ChannelModel(cid: 'messaging:p0');
      final c1 = ChannelModel(cid: 'messaging:p1');
      final c2 = ChannelModel(cid: 'messaging:p2');
      final channels = [c0, c1, c2];
      const cids = ['messaging:p0', 'messaging:p1', 'messaging:p2'];

      // Persisted sort uses `pinnedAt` so membership preload kicks in.
      const persistedSort = <SortOption<ChannelState>>[
        SortOption<ChannelState>.desc(ChannelSortKey.pinnedAt),
      ];

      // pinnedAt values chosen so descending order is [p1, p2, p0]. With
      // offset 1 / limit 1 the only paged cid is p2.
      final baseDate = DateTime.utc(2025);
      final memberships = <String, Member>{
        'messaging:p0': Member(
          userId: currentUserId,
          pinnedAt: baseDate.add(const Duration(days: 1)),
        ),
        'messaging:p1': Member(
          userId: currentUserId,
          pinnedAt: baseDate.add(const Duration(days: 3)),
        ),
        'messaging:p2': Member(
          userId: currentUserId,
          pinnedAt: baseDate.add(const Duration(days: 2)),
        ),
      };

      final persistedFilter = Filter.equal('type', 'messaging');

      when(
        () => mockDatabase.channelQueryDao.getChannelsAndSpecByPredefinedFilter(
          filterName,
          filterValues: filterValues,
          sortValues: sortValues,
        ),
      ).thenAnswer((_) async => (channels, persistedFilter, persistedSort));
      when(() => mockDatabase.memberDao.getMembershipsForChannels(any(), any()))
          .thenAnswer((_) async => memberships);

      // Only p2 should be hydrated — stub every per-cid DAO call.
      const pagedCid = 'messaging:p2';
      final messages = List.generate(3, (i) => Message());
      final members = List.generate(3, (i) => Member());
      final reads = List.generate(
        3,
        (i) => Read(
          user: User(id: 'testUserId$i'),
          lastRead: DateTime.now(),
          lastReadMessageId: 'lastMessageId$i',
        ),
      );
      when(() => mockDatabase.channelDao.getChannelByCid(pagedCid))
          .thenAnswer((_) async => c2);
      when(() => mockDatabase.memberDao.getMembersByCid(pagedCid))
          .thenAnswer((_) async => members);
      when(() => mockDatabase.readDao.getReadsByCid(pagedCid))
          .thenAnswer((_) async => reads);
      when(() => mockDatabase.messageDao.getMessagesByCid(pagedCid))
          .thenAnswer((_) async => messages);
      when(() => mockDatabase.pinnedMessageDao.getMessagesByCid(pagedCid))
          .thenAnswer((_) async => messages);
      when(() => mockDatabase.draftMessageDao.getDraftMessageByCid(pagedCid))
          .thenAnswer((_) async => null);

      final result = await client.getChannelStatesByPredefinedFilter(
        filterName: filterName,
        filterValues: filterValues,
        sortValues: sortValues,
        paginationParams: const PaginationParams(offset: 1, limit: 1),
      );

      // Persisted sort + offset + limit applied: only p2 is returned.
      expect(result.channels, hasLength(1));
      expect(result.channels.single.channel!.cid, pagedCid);

      // Persisted predefined-filter spec surfaced on the response.
      expect(result.predefinedFilter, isNotNull);
      expect(result.predefinedFilter!.name, filterName);
      expect(
          result.predefinedFilter!.filter.toJson(), persistedFilter.toJson());
      expect(result.predefinedFilter!.sort, persistedSort);

      // DAO called with the predefined keys.
      verify(
        () => mockDatabase.channelQueryDao.getChannelsAndSpecByPredefinedFilter(
          filterName,
          filterValues: filterValues,
          sortValues: sortValues,
        ),
      ).called(1);

      // Memberships batched in a single query for all cids + connected user.
      final capturedMembershipArgs = verify(
        () => mockDatabase.memberDao
            .getMembershipsForChannels(captureAny(), captureAny()),
      ).captured;
      expect(capturedMembershipArgs, hasLength(2));
      expect(capturedMembershipArgs.first, equals(cids));
      expect(capturedMembershipArgs.last, equals(currentUserId));

      // Only the paged cid was hydrated — p0 and p1 were skipped.
      verify(() => mockDatabase.channelDao.getChannelByCid(pagedCid)).called(1);
      verifyNever(
          () => mockDatabase.channelDao.getChannelByCid('messaging:p0'));
      verifyNever(
          () => mockDatabase.channelDao.getChannelByCid('messaging:p1'));
    });

    test('deleteMessageById', () async {
      const messageId = 'testMessageId';
      when(() => mockDatabase.messageDao.deleteMessageByIds([messageId]))
          .thenAnswer((_) async => 1);

      await client.deleteMessageById(messageId);
      verify(() => mockDatabase.messageDao.deleteMessageByIds([messageId]))
          .called(1);
    });

    test('deletePinnedMessageById', () async {
      const messageId = 'testMessageId';
      when(() => mockDatabase.pinnedMessageDao.deleteMessageByIds([messageId]))
          .thenAnswer((_) async => 1);

      await client.deletePinnedMessageById(messageId);
      verify(() =>
              mockDatabase.pinnedMessageDao.deleteMessageByIds([messageId]))
          .called(1);
    });

    test('deleteMessageByIds', () async {
      const messageIds = <String>[];
      when(() => mockDatabase.messageDao.deleteMessageByIds(messageIds))
          .thenAnswer((_) async => 1);

      await client.deleteMessageByIds(messageIds);
      verify(() => mockDatabase.messageDao.deleteMessageByIds(messageIds))
          .called(1);
    });

    test('deletePinnedMessageByIds', () async {
      const messageIds = <String>[];
      when(() => mockDatabase.pinnedMessageDao.deleteMessageByIds(messageIds))
          .thenAnswer((_) async => 1);

      await client.deletePinnedMessageByIds(messageIds);
      verify(() => mockDatabase.pinnedMessageDao.deleteMessageByIds(messageIds))
          .called(1);
    });

    test('deleteMessageByCid', () async {
      const cid = 'testCid';
      when(() => mockDatabase.messageDao.deleteMessageByCids([cid]))
          .thenAnswer((_) async => 1);

      await client.deleteMessageByCid(cid);
      verify(() => mockDatabase.messageDao.deleteMessageByCids([cid]))
          .called(1);
    });

    test('deletePinnedMessageByCid', () async {
      const cid = 'testCid';
      when(() => mockDatabase.pinnedMessageDao.deleteMessageByCids([cid]))
          .thenAnswer((_) async => 1);

      await client.deletePinnedMessageByCid(cid);
      verify(() => mockDatabase.pinnedMessageDao.deleteMessageByCids([cid]))
          .called(1);
    });

    test('deleteMessageByCids', () async {
      const cids = <String>[];
      when(() => mockDatabase.messageDao.deleteMessageByCids(cids))
          .thenAnswer((_) async => 1);

      await client.deleteMessageByCids(cids);
      verify(() => mockDatabase.messageDao.deleteMessageByCids(cids)).called(1);
    });

    test('deletePinnedMessageByCids', () async {
      const cids = <String>[];
      when(() => mockDatabase.pinnedMessageDao.deleteMessageByCids(cids))
          .thenAnswer((_) async => 1);

      await client.deletePinnedMessageByCids(cids);
      verify(() => mockDatabase.pinnedMessageDao.deleteMessageByCids(cids))
          .called(1);
    });

    test('deleteChannels', () async {
      const cids = <String>[];
      when(() => mockDatabase.channelDao.deleteChannelByCids(cids))
          .thenAnswer((_) async => 1);

      await client.deleteChannels(cids);
      verify(() => mockDatabase.channelDao.deleteChannelByCids(cids)).called(1);
    });

    test('updateMessages', () async {
      const cid = 'testCid';
      final messages = List.generate(3, (index) => Message());

      when(() => mockDatabase.messageDao.bulkUpdateMessages({cid: messages}))
          .thenAnswer((_) => Future.value());

      await client.updateMessages(cid, messages);
      verify(() => mockDatabase.messageDao.bulkUpdateMessages({cid: messages}))
          .called(1);
    });

    test('updatePinnedMessages', () async {
      const cid = 'testCid';
      final messages = List.generate(3, (index) => Message());
      when(
        () => mockDatabase.pinnedMessageDao.bulkUpdateMessages({cid: messages}),
      ).thenAnswer((_) => Future.value());

      await client.updatePinnedMessages(cid, messages);
      verify(
        () => mockDatabase.pinnedMessageDao.bulkUpdateMessages({cid: messages}),
      ).called(1);
    });

    test('getChannelThreads', () async {
      const cid = 'testCid';
      final messages =
          List.generate(3, (index) => Message(parentId: 'testParentId$index'));
      final threads = messages.fold<Map<String, List<Message>>>(
        {},
        (prev, curr) => prev
          ..update(
            curr.parentId!,
            (value) => [...value, curr],
            ifAbsent: () => [],
          ),
      );
      when(() => mockDatabase.messageDao.getThreadMessages(cid))
          .thenAnswer((realInvocation) async => messages);

      final fetchedThreads = await client.getChannelThreads(cid);
      expect(fetchedThreads.length, threads.length);
      for (var i = 0; i < fetchedThreads.length; i++) {
        final original = threads.entries.elementAt(i);
        final fetched = fetchedThreads.entries.elementAt(i);
        expect(fetched.key, original.key);
      }

      verify(() => mockDatabase.messageDao.getThreadMessages(cid)).called(1);
    });

    test('updateChannels', () async {
      const cid = 'testType:testId';
      final channels = List.generate(3, (index) => ChannelModel(cid: cid));
      when(() => mockDatabase.channelDao.updateChannels(channels))
          .thenAnswer((_) => Future.value());

      await client.updateChannels(channels);
      verify(() => mockDatabase.channelDao.updateChannels(channels)).called(1);
    });

    test('updatePolls', () async {
      const name = 'testPollName';
      final options = List.generate(3, (index) => PollOption(text: '$index'));
      final polls =
          List.generate(3, (index) => Poll(name: name, options: options));
      when(() => mockDatabase.pollDao.updatePolls(polls))
          .thenAnswer((_) => Future.value());

      await client.updatePolls(polls);
      verify(() => mockDatabase.pollDao.updatePolls(polls)).called(1);
    });

    test('deletePollsByIds', () async {
      final pollIds = <String>['testPollId'];
      when(() => mockDatabase.pollDao.deletePollsByIds(pollIds))
          .thenAnswer((_) => Future.value());

      await client.deletePollsByIds(pollIds);
      verify(() => mockDatabase.pollDao.deletePollsByIds(pollIds)).called(1);
    });

    test('updatePollVotes', () async {
      final pollVotes = List.generate(
          3, (index) => PollVote(id: '$index', optionId: 'testOptionId$index'));
      when(() => mockDatabase.pollVoteDao.updatePollVotes(pollVotes))
          .thenAnswer((_) => Future.value());

      await client.updatePollVotes(pollVotes);
      verify(() => mockDatabase.pollVoteDao.updatePollVotes(pollVotes))
          .called(1);
    });

    test('deletePollVotesByPollIds', () async {
      final pollIds = <String>['testPollId'];
      when(() => mockDatabase.pollVoteDao.deletePollVotesByPollIds(pollIds))
          .thenAnswer((_) => Future.value());

      await client.deletePollVotesByPollIds(pollIds);
      verify(() => mockDatabase.pollVoteDao.deletePollVotesByPollIds(pollIds))
          .called(1);
    });

    test('updateMembers', () async {
      const cid = 'testCid';
      final members = List.generate(3, (index) => Member());
      when(() => mockDatabase.memberDao.bulkUpdateMembers({cid: members}))
          .thenAnswer((_) => Future.value());

      await client.updateMembers(cid, members);
      verify(() => mockDatabase.memberDao.bulkUpdateMembers({cid: members}))
          .called(1);
    });

    test('updateReads', () async {
      const cid = 'testCid';
      final reads = List.generate(
        3,
        (index) => Read(
          user: User(id: 'testUserId$index'),
          lastRead: DateTime.now(),
          lastReadMessageId: 'lastMessageId$index',
        ),
      );
      when(() => mockDatabase.readDao.bulkUpdateReads({cid: reads}))
          .thenAnswer((_) => Future.value());

      await client.updateReads(cid, reads);
      verify(() => mockDatabase.readDao.bulkUpdateReads({cid: reads}))
          .called(1);
    });

    test('updateUsers', () async {
      final users = List.generate(3, (index) => User(id: 'testUserId$index'));
      when(() => mockDatabase.userDao.updateUsers(users))
          .thenAnswer((_) => Future.value());

      await client.updateUsers(users);
      verify(() => mockDatabase.userDao.updateUsers(users)).called(1);
    });

    test('updateReactions', () async {
      final reactions = List.generate(
        3,
        (index) => Reaction(type: 'testType$index'),
      );
      when(() => mockDatabase.reactionDao.updateReactions(reactions))
          .thenAnswer((_) => Future.value());

      await client.updateReactions(reactions);
      verify(() => mockDatabase.reactionDao.updateReactions(reactions))
          .called(1);
    });

    test('updatePinnedMessageReactions', () async {
      final reactions = List.generate(
        3,
        (index) => Reaction(type: 'testType$index'),
      );
      when(() =>
              mockDatabase.pinnedMessageReactionDao.updateReactions(reactions))
          .thenAnswer((_) => Future.value());

      await client.updatePinnedMessageReactions(reactions);
      verify(() =>
              mockDatabase.pinnedMessageReactionDao.updateReactions(reactions))
          .called(1);
    });

    test('deleteReactionsByMessageId', () async {
      final messageIds = <String>[];
      when(() =>
              mockDatabase.reactionDao.deleteReactionsByMessageIds(messageIds))
          .thenAnswer((_) => Future.value());

      await client.deleteReactionsByMessageId(messageIds);
      verify(() =>
              mockDatabase.reactionDao.deleteReactionsByMessageIds(messageIds))
          .called(1);
    });

    test('deletePinnedMessageReactionsByMessageId', () async {
      final messageIds = <String>[];
      when(() => mockDatabase.pinnedMessageReactionDao
              .deleteReactionsByMessageIds(messageIds))
          .thenAnswer((_) => Future.value());

      await client.deletePinnedMessageReactionsByMessageId(messageIds);
      verify(() => mockDatabase.pinnedMessageReactionDao
          .deleteReactionsByMessageIds(messageIds)).called(1);
    });

    test('deleteMembersByCids', () async {
      final cids = <String>[];
      when(() => mockDatabase.memberDao.deleteMemberByCids(cids))
          .thenAnswer((_) => Future.value());

      await client.deleteMembersByCids(cids);
      verify(() => mockDatabase.memberDao.deleteMemberByCids(cids)).called(1);
    });

    test('deleteDraftMessagesByCids', () async {
      final cids = <String>[];
      when(() => mockDatabase.draftMessageDao.deleteDraftMessagesByCids(cids))
          .thenAnswer((_) => Future.value());

      await client.deleteDraftMessagesByCids(cids);
      verify(() => mockDatabase.draftMessageDao.deleteDraftMessagesByCids(cids))
          .called(1);
    });

    test('getDraftMessageByCid', () async {
      const cid = 'testCid';
      const parentId = 'testParentId';
      final draft = Draft(
        channelCid: cid,
        parentId: parentId,
        createdAt: DateTime.now(),
        message: DraftMessage(
          id: 'testDraftId',
          text: 'Test draft message',
        ),
      );

      when(() => mockDatabase.draftMessageDao.getDraftMessageByCid(cid))
          .thenAnswer((_) async => draft);

      final fetchedDraft = await client.getDraftMessageByCid(cid);
      expect(fetchedDraft, isNotNull);
      expect(fetchedDraft!.channelCid, cid);
      expect(fetchedDraft.message.id, draft.message.id);
      expect(fetchedDraft.message.text, draft.message.text);
      verify(() => mockDatabase.draftMessageDao.getDraftMessageByCid(cid))
          .called(1);
    });

    test('updateDraftMessages', () async {
      final drafts = List.generate(
        3,
        (index) => Draft(
          channelCid: 'testCid',
          createdAt: DateTime.now(),
          message: DraftMessage(
            id: 'testDraftId$index',
            text: 'Test draft message $index',
          ),
        ),
      );

      when(() => mockDatabase.draftMessageDao.updateDraftMessages(drafts))
          .thenAnswer((_) async {});

      await client.updateDraftMessages(drafts);
      verify(() => mockDatabase.draftMessageDao.updateDraftMessages(drafts))
          .called(1);
    });

    test('deleteDraftMessageByCid', () async {
      const cid = 'testCid';
      const parentId = 'testParentId';

      when(() => mockDatabase.draftMessageDao.deleteDraftMessageByCid(cid,
          parentId: parentId)).thenAnswer((_) async {});

      await client.deleteDraftMessageByCid(cid, parentId: parentId);
      verify(() => mockDatabase.draftMessageDao
          .deleteDraftMessageByCid(cid, parentId: parentId)).called(1);
    });

    tearDown(() async {
      await client.disconnect(flush: true);
    });
  });
}
