import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

// Runs [body] as a [chatClientTest] whose client is backed by a fresh
// [MockPersistenceClient], mirroring the monolith group's setUp: the
// persistence stubs the connect path needs are installed first, then the
// client is connected and persistence is asserted enabled.
void _clientWithPersistenceTest(
  String description, {
  required Future<void> Function(ChatClientTester tester, MockPersistenceClient persistence) body,
}) {
  final persistence = MockPersistenceClient();

  chatClientTest(
    description,
    chatPersistenceClient: persistence,
    connect: (tester) async {
      // The real engine routes the connect health-check through the client,
      // which forwards it to persistence — stub the writes up front.
      when(() => persistence.updateConnectionInfo(any())).thenAnswer((_) => Future.value());
      when(() => persistence.updateLastSyncAt(any())).thenAnswer((_) => Future.value());
      when(persistence.getLastSyncAt).thenAnswer((_) async => null);

      tester.mockSuccessfulAuth(tester.user.id);
      await tester.client.connectUser(tester.user, createTestToken(tester.user.id).rawValue);

      expect(tester.client.persistenceEnabled, isTrue);
      expect(tester.connectionStatus, ConnectionStatus.connected);
    },
    body: (tester) => body(tester, persistence),
  );
}

void main() {
  group('Client with connected user with persistence', () {
    group('`.sync`', () {
      _clientWithPersistenceTest(
        '''should update persistence connectionInfo and lastSync when sync succeeds''',
        body: (tester, persistence) async {
          // persistence.updateLastSyncAt might be called
          // when connecting the user.
          // Resetting the logs so we start counting invocations correctly.
          reset(persistence);
          const cids = ['test-cid-1', 'test-cid-2', 'test-cid-3'];
          final lastSyncAt = DateTime.utc(2021, 3);
          tester.mockApi(
            (api) => api.general.sync(cids, lastSyncAt),
            result: createDefaultSyncResponse(
              events: [
                Event(
                  isLocal: false,
                  type: EventType.healthCheck,
                  connectionId: 'test-connection-id',
                  me: OwnUser.fromUser(tester.user),
                ),
                Event(
                  isLocal: false,
                  type: EventType.messageDeleted,
                  message: Message(id: 'test-message-id'),
                ),
              ],
            ),
          );

          when(() => persistence.updateConnectionInfo(any())).thenAnswer((_) => Future.value());
          when(() => persistence.updateLastSyncAt(any())).thenAnswer((_) => Future.value());

          await tester.client.sync(cids: cids, lastSyncAt: lastSyncAt);

          verify(() => persistence.updateConnectionInfo(any())).called(1);
          verify(() => persistence.updateLastSyncAt(any())).called(1);
          tester.verifyApi((api) => api.general.sync(cids, lastSyncAt));
        },
      );

      _clientWithPersistenceTest(
        'should work fine if persistence contains sync params',
        body: (tester, persistence) async {
          // persistence.updateLastSyncAt might be called
          // when connecting the user.
          // Resetting the logs so we start counting invocations correctly.
          reset(persistence);
          const cids = ['test-cid-1', 'test-cid-2', 'test-cid-3'];
          final lastSyncAt = DateTime.utc(2021, 3);

          when(persistence.getChannelCids).thenAnswer((_) async => cids);
          when(persistence.getLastSyncAt).thenAnswer((_) async => lastSyncAt);

          tester.mockApi(
            (api) => api.general.sync(cids, lastSyncAt),
            result: createDefaultSyncResponse(
              events: [
                Event(
                  isLocal: false,
                  type: EventType.healthCheck,
                  connectionId: 'test-connection-id',
                  me: OwnUser.fromUser(tester.user),
                ),
                Event(
                  isLocal: false,
                  type: EventType.messageDeleted,
                  message: Message(id: 'test-message-id', text: 'Hey!'),
                ),
              ],
            ),
          );

          when(() => persistence.updateConnectionInfo(any())).thenAnswer((_) => Future.value());
          when(() => persistence.updateLastSyncAt(any())).thenAnswer((_) => Future.value());

          await tester.client.sync();

          verify(() => persistence.updateConnectionInfo(any())).called(1);
          verify(() => persistence.updateLastSyncAt(any())).called(1);
          tester.verifyApi((api) => api.general.sync(cids, lastSyncAt));
          verify(persistence.getChannelCids).called(1);
          verify(persistence.getLastSyncAt).called(1);
        },
      );
    });

    group('`.queryChannels`', () {
      _clientWithPersistenceTest(
        'should emit channels twice if persistence contains some channels',
        body: (tester, persistence) async {
          final persistentChannelStates = List.generate(
            3,
            (index) => createDefaultChannelState(
              channel: createDefaultChannelModel(cid: 'test-type-$index:test-id-$index'),
            ),
          );

          when(
            () => persistence.queryChannelStates(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              predefinedFilter: any(named: 'predefinedFilter'),
              filterValues: any(named: 'filterValues'),
              sortValues: any(named: 'sortValues'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).thenAnswer((_) async => createDefaultQueryChannelsResponse(channels: persistentChannelStates));

          final channelStates = List.generate(
            3,
            (index) => createDefaultChannelState(
              channel: createDefaultChannelModel(cid: 'test-type-$index:test-id-$index'),
            ),
          );

          tester.mockApi(
            (api) => api.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
            result: createDefaultQueryChannelsResponse(channels: channelStates),
          );

          when(() => persistence.getChannelThreads(any())).thenAnswer(
            (_) async => <String, List<Message>>{
              for (final channelState in channelStates)
                channelState.channel!.cid: [createDefaultMessage(id: 'test-message-id', text: 'Test message')],
            },
          );

          when(() => persistence.updateChannelState(any())).thenAnswer((_) async {});
          when(() => persistence.updateChannelThreads(any(), any())).thenAnswer((_) async {});
          when(
            () => persistence.saveChannelQueries(
              cids: any(named: 'cids'),
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              predefinedFilter: any(named: 'predefinedFilter'),
              resolvedFilter: any(named: 'resolvedFilter'),
              resolvedSort: any(named: 'resolvedSort'),
              filterValues: any(named: 'filterValues'),
              sortValues: any(named: 'sortValues'),
              clearQueryCache: any(named: 'clearQueryCache'),
            ),
          ).thenAnswer((_) => Future.value());

          // The connect phase's `connectUser` schedules debounced persistence
          // writes (1s window) that would otherwise fire during this test's
          // wait and pollute the call counts. Wait past the debounce, then
          // clear.
          await Future.delayed(const Duration(milliseconds: 1100));
          clearInteractions(persistence);

          await expectLater(
            tester.client.queryChannels(),
            emitsInOrder([
              // emits persistent channels first
              persistentChannelStates.map(isCorrectChannelFor),
              // makes api call and emits network fetched channels
              channelStates.map(isCorrectChannelFor),
            ]),
          );

          // Wait safely past the 1s debounce on persistence writes
          // (updateChannelState, updateChannelThreads) so all trailing
          // invocations have fired before we verify counts.
          await Future.delayed(const Duration(milliseconds: 1500));

          verify(
            () => persistence.queryChannelStates(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              predefinedFilter: any(named: 'predefinedFilter'),
              filterValues: any(named: 'filterValues'),
              sortValues: any(named: 'sortValues'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).called(1);

          tester.verifyApi(
            (api) => api.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          );

          verify(() => persistence.getChannelThreads(any())).called(channelStates.length);
          verify(() => persistence.updateChannelState(any())).called(channelStates.length);
          verify(() => persistence.updateChannelThreads(any(), any())).called(channelStates.length);
          verify(
            () => persistence.saveChannelQueries(
              cids: any(named: 'cids'),
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              predefinedFilter: any(named: 'predefinedFilter'),
              resolvedFilter: any(named: 'resolvedFilter'),
              resolvedSort: any(named: 'resolvedSort'),
              filterValues: any(named: 'filterValues'),
              sortValues: any(named: 'sortValues'),
              clearQueryCache: any(named: 'clearQueryCache'),
            ),
          ).called(1);
        },
      );

      _clientWithPersistenceTest(
        '''should never rethrow network call if persistence already emitted some channels''',
        body: (tester, persistence) async {
          final persistentChannelStates = List.generate(
            3,
            (index) => createDefaultChannelState(
              channel: createDefaultChannelModel(cid: 'test-type-$index:test-id-$index'),
            ),
          );

          when(
            () => persistence.queryChannelStates(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              predefinedFilter: any(named: 'predefinedFilter'),
              filterValues: any(named: 'filterValues'),
              sortValues: any(named: 'sortValues'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).thenAnswer((_) async => createDefaultQueryChannelsResponse(channels: persistentChannelStates));

          tester.mockApiFailure(
            (api) => api.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
            error: createDefaultNetworkError(errorCode: ChatErrorCode.inputError),
          );

          when(() => persistence.getChannelThreads(any())).thenAnswer(
            (_) async => <String, List<Message>>{
              for (final channelState in persistentChannelStates)
                channelState.channel!.cid: [createDefaultMessage(id: 'test-message-id', text: 'Test message')],
            },
          );

          when(() => persistence.updateChannelState(any())).thenAnswer((_) async => {});
          when(() => persistence.updateChannelThreads(any(), any())).thenAnswer((_) async => {});

          // The connect phase's `connectUser` schedules debounced persistence
          // writes (1s window) that would otherwise fire during this test's
          // wait and pollute the call counts. Wait past the debounce, then
          // clear.
          await Future.delayed(const Duration(milliseconds: 1100));
          clearInteractions(persistence);

          await expectLater(
            tester.client.queryChannels(),
            emitsInOrder([
              // emits persistent channels
              persistentChannelStates.map(isCorrectChannelFor),
            ]),
          );

          // Wait safely past the 1s debounce on persistence writes
          // (updateChannelState, updateChannelThreads) so all trailing
          // invocations have fired before we verify counts.
          await Future.delayed(const Duration(milliseconds: 1500));

          verify(
            () => persistence.queryChannelStates(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              predefinedFilter: any(named: 'predefinedFilter'),
              filterValues: any(named: 'filterValues'),
              sortValues: any(named: 'sortValues'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).called(1);

          tester.verifyApi(
            (api) => api.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          );

          verify(() => persistence.getChannelThreads(any())).called(persistentChannelStates.length);
          verify(() => persistence.updateChannelState(any())).called(persistentChannelStates.length);
          verify(() => persistence.updateChannelThreads(any(), any())).called(persistentChannelStates.length);
        },
      );

      _clientWithPersistenceTest(
        'queryChannelsOnline with inline filter persists via saveChannelQueries',
        body: (tester, persistence) async {
          final filter = Filter.in_('members', const ['test-user-id']);

          final channelStates = List.generate(
            3,
            (i) => createDefaultChannelState(
              channel: createDefaultChannelModel(cid: 'test-type-$i:test-id-$i'),
            ),
          );

          tester.mockApi(
            (api) => api.channel.queryChannels(
              filter: filter,
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
            result: createDefaultQueryChannelsResponse(channels: channelStates),
          );

          when(() => persistence.getChannelThreads(any())).thenAnswer((_) async => <String, List<Message>>{});
          when(() => persistence.updateChannelState(any())).thenAnswer((_) async {});
          when(() => persistence.updateChannelThreads(any(), any())).thenAnswer((_) async {});
          when(
            () => persistence.saveChannelQueries(
              cids: any(named: 'cids'),
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              predefinedFilter: any(named: 'predefinedFilter'),
              resolvedFilter: any(named: 'resolvedFilter'),
              resolvedSort: any(named: 'resolvedSort'),
              filterValues: any(named: 'filterValues'),
              sortValues: any(named: 'sortValues'),
              clearQueryCache: any(named: 'clearQueryCache'),
            ),
          ).thenAnswer((_) => Future.value());

          await Future.delayed(const Duration(milliseconds: 1100));
          clearInteractions(persistence);

          await tester.client.queryChannelsOnline(filter: filter);

          // The standard path passes filter (the inline filter) and a null
          // predefinedFilter. resolvedFilter / resolvedSort stay null —
          // they're only meaningful for the predefined-filter path.
          verify(
            () => persistence.saveChannelQueries(
              cids: channelStates.map((s) => s.channel!.cid).toList(),
              filter: filter,
              sort: null,
              predefinedFilter: null,
              resolvedFilter: null,
              resolvedSort: null,
              filterValues: null,
              sortValues: null,
              clearQueryCache: true,
            ),
          ).called(1);
        },
      );

      _clientWithPersistenceTest(
        'queryChannelsOnline with predefined filter persists via saveChannelQueries with resolved sort',
        body: (tester, persistence) async {
          const filterName = 'sample-app-list';
          const filterValues = {'user_id': 'test-user-id'};
          const sortValues = {'pinned_at': true};

          final channelStates = List.generate(
            3,
            (i) => createDefaultChannelState(
              channel: createDefaultChannelModel(cid: 'test-type-$i:test-id-$i'),
            ),
          );

          tester.mockApi(
            (api) => api.channel.queryChannels(
              predefinedFilter: filterName,
              filterValues: filterValues,
              sortValues: sortValues,
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
            result: createDefaultQueryChannelsResponse(
              channels: channelStates,
              predefinedFilter: const PredefinedFilter(
                name: filterName,
                filter: Filter.empty(),
                sort: [SortOption<ChannelState>.desc('last_message_at')],
              ),
            ),
          );

          when(() => persistence.getChannelThreads(any())).thenAnswer((_) async => <String, List<Message>>{});
          when(() => persistence.updateChannelState(any())).thenAnswer((_) async {});
          when(() => persistence.updateChannelThreads(any(), any())).thenAnswer((_) async {});
          when(
            () => persistence.saveChannelQueries(
              cids: any(named: 'cids'),
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              predefinedFilter: any(named: 'predefinedFilter'),
              resolvedFilter: any(named: 'resolvedFilter'),
              resolvedSort: any(named: 'resolvedSort'),
              filterValues: any(named: 'filterValues'),
              sortValues: any(named: 'sortValues'),
              clearQueryCache: any(named: 'clearQueryCache'),
            ),
          ).thenAnswer((_) => Future.value());

          await Future.delayed(const Duration(milliseconds: 1100));
          clearInteractions(persistence);

          await tester.client.queryChannelsOnline(
            predefinedFilter: filterName,
            filterValues: filterValues,
            sortValues: sortValues,
          );

          verify(
            () => persistence.saveChannelQueries(
              cids: channelStates.map((s) => s.channel!.cid).toList(),
              filter: null,
              sort: null,
              predefinedFilter: filterName,
              resolvedFilter: const Filter.empty(),
              resolvedSort: const [SortOption<ChannelState>.desc('last_message_at')],
              filterValues: filterValues,
              sortValues: sortValues,
              clearQueryCache: true,
            ),
          ).called(1);
        },
      );

      _clientWithPersistenceTest(
        'queryChannelsOffline with predefined filter reads via queryChannelStates',
        body: (tester, persistence) async {
          const filterName = 'sample-app-list';
          const filterValues = {'user_id': 'test-user-id'};
          const sortValues = {'pinned_at': true};

          final channelStates = List.generate(
            3,
            (i) => createDefaultChannelState(
              channel: createDefaultChannelModel(cid: 'test-type-$i:test-id-$i'),
            ),
          );

          when(
            () => persistence.queryChannelStates(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              predefinedFilter: filterName,
              filterValues: filterValues,
              sortValues: sortValues,
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).thenAnswer((_) async => createDefaultQueryChannelsResponse(channels: channelStates));

          when(() => persistence.getChannelThreads(any())).thenAnswer((_) async => <String, List<Message>>{});
          when(() => persistence.updateChannelState(any())).thenAnswer((_) async {});
          when(() => persistence.updateChannelThreads(any(), any())).thenAnswer((_) async {});

          await Future.delayed(const Duration(milliseconds: 1100));
          clearInteractions(persistence);

          final channels = await tester.client.queryChannelsOffline(
            predefinedFilter: filterName,
            filterValues: filterValues,
            sortValues: sortValues,
          );

          expect(channels, hasLength(channelStates.length));

          verify(
            () => persistence.queryChannelStates(
              filter: null,
              sort: null,
              predefinedFilter: filterName,
              filterValues: filterValues,
              sortValues: sortValues,
              messageLimit: 25,
              paginationParams: const PaginationParams(),
            ),
          ).called(1);
        },
      );

      _clientWithPersistenceTest(
        'queryChannelsWithResult yields QueryChannelsResult with predefinedFilter=null for inline filter',
        body: (tester, persistence) async {
          final channelStates = List.generate(
            2,
            (i) => createDefaultChannelState(
              channel: createDefaultChannelModel(cid: 'test-type-$i:test-id-$i'),
            ),
          );

          when(
            () => persistence.queryChannelStates(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              predefinedFilter: any(named: 'predefinedFilter'),
              filterValues: any(named: 'filterValues'),
              sortValues: any(named: 'sortValues'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).thenAnswer((_) async => createDefaultQueryChannelsResponse());

          tester.mockApi(
            (api) => api.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
            result: createDefaultQueryChannelsResponse(channels: channelStates),
          );

          when(() => persistence.getChannelThreads(any())).thenAnswer((_) async => <String, List<Message>>{});
          when(() => persistence.updateChannelState(any())).thenAnswer((_) async {});
          when(() => persistence.updateChannelThreads(any(), any())).thenAnswer((_) async {});
          when(
            () => persistence.saveChannelQueries(
              cids: any(named: 'cids'),
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              predefinedFilter: any(named: 'predefinedFilter'),
              resolvedFilter: any(named: 'resolvedFilter'),
              resolvedSort: any(named: 'resolvedSort'),
              filterValues: any(named: 'filterValues'),
              sortValues: any(named: 'sortValues'),
              clearQueryCache: any(named: 'clearQueryCache'),
            ),
          ).thenAnswer((_) => Future.value());

          await Future.delayed(const Duration(milliseconds: 1100));
          clearInteractions(persistence);

          final results = await tester.client.queryChannelsWithResult().toList();

          // Persistence returned empty, so only the online emission is yielded.
          expect(results, hasLength(1));
          expect(results.single.channels, hasLength(channelStates.length));
          expect(results.single.predefinedFilter, isNull);
        },
      );

      _clientWithPersistenceTest(
        'queryChannelsWithResult yields QueryChannelsResult with predefinedFilter populated for predefined query',
        body: (tester, persistence) async {
          const filterName = 'sample-app-list';
          const filterValues = {'user_id': 'test-user-id'};
          const sortValues = {'pinned_at': true};

          final channelStates = List.generate(
            2,
            (i) => createDefaultChannelState(
              channel: createDefaultChannelModel(cid: 'test-type-$i:test-id-$i'),
            ),
          );

          const resolvedSort = [SortOption<ChannelState>.desc('last_message_at')];
          const resolvedFilter = Filter.empty();
          const expectedPredefinedFilter = PredefinedFilter(
            name: filterName,
            filter: resolvedFilter,
            sort: resolvedSort,
          );

          when(
            () => persistence.queryChannelStates(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              predefinedFilter: any(named: 'predefinedFilter'),
              filterValues: any(named: 'filterValues'),
              sortValues: any(named: 'sortValues'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).thenAnswer((_) async => createDefaultQueryChannelsResponse());

          tester.mockApi(
            (api) => api.channel.queryChannels(
              predefinedFilter: filterName,
              filterValues: filterValues,
              sortValues: sortValues,
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
            result: createDefaultQueryChannelsResponse(
              channels: channelStates,
              predefinedFilter: expectedPredefinedFilter,
            ),
          );

          when(() => persistence.getChannelThreads(any())).thenAnswer((_) async => <String, List<Message>>{});
          when(() => persistence.updateChannelState(any())).thenAnswer((_) async {});
          when(() => persistence.updateChannelThreads(any(), any())).thenAnswer((_) async {});
          when(
            () => persistence.saveChannelQueries(
              cids: any(named: 'cids'),
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              predefinedFilter: any(named: 'predefinedFilter'),
              resolvedFilter: any(named: 'resolvedFilter'),
              resolvedSort: any(named: 'resolvedSort'),
              filterValues: any(named: 'filterValues'),
              sortValues: any(named: 'sortValues'),
              clearQueryCache: any(named: 'clearQueryCache'),
            ),
          ).thenAnswer((_) => Future.value());

          await Future.delayed(const Duration(milliseconds: 1100));
          clearInteractions(persistence);

          final results = await tester.client
              .queryChannelsWithResult(
                predefinedFilter: filterName,
                filterValues: filterValues,
                sortValues: sortValues,
              )
              .toList();

          // Persistence returned empty, so only the online emission is yielded.
          expect(results, hasLength(1));
          expect(results.single.channels, hasLength(channelStates.length));
          expect(results.single.predefinedFilter, isNotNull);
          expect(results.single.predefinedFilter!.name, equals(filterName));
          expect(results.single.predefinedFilter!.sort, equals(resolvedSort));
        },
      );
    });

    _clientWithPersistenceTest(
      '`.disconnectUser` should reset state and user',
      body: (tester, persistence) async {
        expect(tester.clientState.currentUser, isNotNull);
        expect(tester.connectionStatus, ConnectionStatus.connected);

        expectLater(
          // skipping initial connected value
          tester.client.wsConnectionStatusStream.skip(1),
          emits(ConnectionStatus.disconnected),
        );

        await tester.client.disconnectUser(flushChatPersistence: true);

        expect(tester.clientState.currentUser, isNull);
        expect(tester.connectionStatus, ConnectionStatus.disconnected);
      },
    );
  });
}
