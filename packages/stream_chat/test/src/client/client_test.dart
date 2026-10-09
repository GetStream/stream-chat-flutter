// ignore_for_file: avoid_redundant_argument_values, lines_longer_than_80_chars, deprecated_member_use_from_same_package

import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/ws/events/events.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../matchers.dart';
import '../mocks.dart';
import '../utils.dart';
import '../ws/fake_chat_server.dart';
import 'poll_fixtures.dart';

void main() {
  group('Fake web-socket connection functions', () {
    const apiKey = 'test-api-key';
    late final fakeChatApi = FakeChatApi();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeUser());
    });

    setUp(() {
      final ws = FakeChatServer();
      client = StreamChatClient(apiKey, defaultApi: FakeDefaultApi(), wsProvider: ws.connect, chatApi: fakeChatApi);
    });

    tearDown(() {
      client.dispose();
    });

    test('`.connectUser` should work fine', () async {
      final user = User(id: 'test-user-id');
      final token = testUserToken(user.id).rawValue;

      expectLater(
        // skipping first seed status -> ConnectionStatus.disconnected
        client.connectionStatusStream.skip(1),
        emitsInOrder([ConnectionStatus.connecting, ConnectionStatus.connected]),
      );

      final res = await client.connectUser(user, token);
      expect(res, isNotNull);
      expect(res, isSameUserAs(user));
    });

    test('`.connectUserWithProvider` should work fine', () async {
      final user = User(id: 'test-user-id');
      Future<UserToken> tokenProvider(String userId) async {
        expect(userId, user.id);
        return testUserToken(userId);
      }

      expectLater(
        // skipping first seed status -> ConnectionStatus.disconnected
        client.connectionStatusStream.skip(1),
        emitsInOrder([ConnectionStatus.connecting, ConnectionStatus.connected]),
      );

      final res = await client.connectUserWithProvider(user, TokenProvider.dynamic(tokenProvider));
      expect(res, isNotNull);
      expect(res, isSameUserAs(user));
    });

    test('`.connectAnonymousUser` should work fine', () async {
      expectLater(
        // skipping first seed status -> ConnectionStatus.disconnected
        client.connectionStatusStream.skip(1),
        emitsInOrder([ConnectionStatus.connecting, ConnectionStatus.connected]),
      );

      final res = await client.connectAnonymousUser();
      expect(res, isNotNull);
    });

    group('`.openConnection`', () {
      test('should throw if state does not contain user', () async {
        expect(client.state.currentUser, isNull);
        await expectLater(
          client.openConnection(),
          throwsA(isA<AssertionError>()),
        );
      });

      test('should answer with the connection already open', () async {
        expect(client.state.currentUser, isNull);

        final connected = await client.connectAnonymousUser();
        // waiting 300ms for `wsConnectionStatusStream` to emit
        await delay(300);

        // The connection being asked for is the one already open, so the caller is answered with
        // it rather than told they should have disconnected first.
        expect(await client.openConnection(), connected);
        expect(client.connectionStatus, ConnectionStatus.connected);
      });

      test('should open connection for closed connection', () async {
        expectLater(
          client.connectionStatusStream.skip(1),
          emitsInOrder([
            // initial connectUser
            ConnectionStatus.connecting,
            ConnectionStatus.connected,
            // close connection
            ConnectionStatus.disconnected,
            // open connection
            ConnectionStatus.connecting,
            ConnectionStatus.connected,
          ]),
        );

        await client.connectAnonymousUser();
        // waiting 300ms for `wsConnectionStatusStream` to emit
        await delay(300);

        client.closeConnection();

        await client.openConnection();
      });
    });
  });

  group('Fake web-socket connection functions failure', () {
    const apiKey = 'test-api-key';
    late final fakeChatApi = FakeChatApi();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeUser());
    });

    setUp(() {
      final ws = FakeChatServer()..handshakeFails = true;
      client = StreamChatClient(apiKey, defaultApi: FakeDefaultApi(), chatApi: fakeChatApi, wsProvider: ws.connect);
    });

    tearDown(() {
      client.dispose();
    });

    test('`.connectUser` should throw if `ws.connect` fails', () async {
      final user = User(id: 'test-user-id');
      final token = testUserToken(user.id).rawValue;

      await expectLater(
        client.connectUser(user, token),
        throwsA(isA<StreamNetworkException>()),
      );
    });

    test(
      '`.connectUserWithProvider` should throw if `ws.connect` fails',
      () async {
        final user = User(id: 'test-user-id');
        Future<UserToken> tokenProvider(String userId) async {
          expect(userId, user.id);
          return testUserToken(userId);
        }

        await expectLater(
          client.connectUserWithProvider(user, TokenProvider.dynamic(tokenProvider)),
          throwsA(isA<StreamNetworkException>()),
        );
      },
    );

    test(
      '`.connectAnonymousUser` should throw if `ws.connect` fails',
      () async {
        await expectLater(
          client.connectAnonymousUser(),
          throwsA(isA<StreamNetworkException>()),
        );
      },
    );
  });

  group('Connect user calls with `connectWebSocket`: false', () {
    const apiKey = 'test-api-key';
    late final fakeChatApi = FakeChatApi();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeUser());
    });

    setUp(() {
      client = StreamChatClient(apiKey, defaultApi: FakeDefaultApi(), chatApi: fakeChatApi);
    });

    tearDown(() {
      client.dispose();
    });

    test('`.connectUser` should succeed without connecting', () async {
      final user = User(id: 'test-user-id');
      final token = testUserToken(user.id).rawValue;

      final res = await client.connectUser(
        user,
        token,
        connectWebSocket: false,
      );
      expect(res, isSameUserAs(user));
      expect(client.connectionStatus, ConnectionStatus.disconnected);
    });

    test(
      '`.connectUserWithProvider` should succeed without connecting',
      () async {
        final user = User(id: 'test-user-id');
        Future<UserToken> tokenProvider(String userId) async {
          expect(userId, user.id);
          return testUserToken(userId);
        }

        final res = await client.connectUserWithProvider(
          user,
          TokenProvider.dynamic(tokenProvider),
          connectWebSocket: false,
        );
        expect(res, isSameUserAs(user));
        expect(client.connectionStatus, ConnectionStatus.disconnected);
      },
    );

    test(
      '`.connectAnonymousUser` should succeed without connecting',
      () async {
        final res = await client.connectAnonymousUser(
          connectWebSocket: false,
        );

        expect(res, isNotNull);
        expect(client.connectionStatus, ConnectionStatus.disconnected);
      },
    );
  });

  group('Fake web-socket connection function with failure and persistence', () {
    const apiKey = 'test-api-key';
    late final fakeChatApi = FakeChatApi();
    late final persistence = MockPersistenceClient();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeUser());
    });

    setUp(() {
      final ws = FakeChatServer()..handshakeFails = true;
      client = StreamChatClient(apiKey, defaultApi: FakeDefaultApi(), chatApi: fakeChatApi, wsProvider: ws.connect)
        ..chatPersistenceClient = persistence;
    });

    tearDown(() {
      client.dispose();
    });

    test(
      '''`.connectUser` should connect successfully if persistence contains event''',
      () async {
        final user = User(id: 'test-user-id');
        final token = testUserToken(user.id).rawValue;

        final event = Event(
          type: EventType.healthCheck,
          connectionId: 'test-connection-id',
          me: OwnUser.fromUser(user),
        );
        when(persistence.getConnectionInfo).thenAnswer((_) async => event);

        final res = await client.connectUser(user, token);
        expect(res, isNotNull);
        expect(res, isSameUserAs(user));

        verify(persistence.getConnectionInfo).called(1);
        verifyNoMoreInteractions(persistence);
      },
    );

    test(
      '''`.connectUserWithProvider` should connect successfully if persistence contains event''',
      () async {
        final user = User(id: 'test-user-id');
        Future<UserToken> tokenProvider(String userId) async {
          expect(userId, user.id);
          return testUserToken(userId);
        }

        final event = Event(
          type: EventType.healthCheck,
          connectionId: 'test-connection-id',
          me: OwnUser.fromUser(user),
        );
        when(persistence.getConnectionInfo).thenAnswer((_) async => event);

        final res = await client.connectUserWithProvider(user, TokenProvider.dynamic(tokenProvider));
        expect(res, isNotNull);
        expect(res, isSameUserAs(user));

        verify(persistence.getConnectionInfo).called(1);
        verifyNoMoreInteractions(persistence);
      },
    );

    test(
      '''`.connectAnonymousUser` should connect successfully if persistence contains event''',
      () async {
        final user = User(id: 'test-user-id');

        when(persistence.getConnectionInfo).thenAnswer(
          (invocation) async => Event(
            type: EventType.healthCheck,
            connectionId: 'test-connection-id',
            me: OwnUser.fromUser(user),
          ),
        );

        final res = await client.connectAnonymousUser();
        expect(res, isNotNull);

        verify(persistence.getConnectionInfo).called(1);
        verifyNoMoreInteractions(persistence);
      },
    );
  });

  group('Client with connected user with persistence', () {
    const apiKey = 'test-api-key';
    late final fakeChatApi = FakeChatApi();
    late final persistence = MockPersistenceClient();

    final user = User(id: 'test-user-id');
    final token = testUserToken(user.id).rawValue;

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeEvent());
      registerFallbackValue(const PaginationParams());
      registerFallbackValue(FakeChannelState());
      registerFallbackValue(const ChannelFilter.raw({}));
    });

    setUp(() async {
      when(() => persistence.updateLastSyncAt(any())).thenAnswer((_) => Future.value());
      when(persistence.getLastSyncAt).thenAnswer((_) async => null);
      // The hello frame reaches the client through the socket now, so connecting stores the
      // connection info before any test has had a chance to stub it.
      when(() => persistence.updateConnectionInfo(any())).thenAnswer((_) => Future.value());
      final ws = FakeChatServer();
      client = StreamChatClient(apiKey, defaultApi: FakeDefaultApi(), chatApi: fakeChatApi, wsProvider: ws.connect)
        ..chatPersistenceClient = persistence;
      await client.connectUser(user, token);
      await delay(300);
      expect(client.persistenceEnabled, isTrue);
      expect(client.connectionStatus, ConnectionStatus.connected);
    });

    tearDown(() async {
      await client.dispose();
    });

    // The store holds the connection the cached state belongs to, and only the hello frame names
    // one — the `/sync` endpoint reads the channel event store, which never holds a health check.
    test('should store the connection the hello frame established', () async {
      final captured = verify(() => persistence.updateConnectionInfo(captureAny())).captured;

      expect(captured, hasLength(1));
      expect(
        captured.single,
        isA<HealthCheckEvent>().having((it) => it.connectionId, 'connectionId', isNotEmpty),
      );
    });

    group('`.sync`', () {
      test(
        'should update lastSync when sync succeeds',
        () async {
          // persistence.updateLastSyncAt might be called
          // when connecting the user.
          // Resetting the logs so we start counting invocations correctly.
          reset(persistence);
          const cids = ['test-cid-1', 'test-cid-2', 'test-cid-3'];
          final lastSyncAt = DateTime.now();
          when(() => fakeChatApi.general.sync(cids, lastSyncAt)).thenAnswer(
            (_) async => SyncResponse()
              ..events = [
                Event(
                  isLocal: false,
                  type: EventType.messageDeleted,
                  message: Message(id: 'test-message-id'),
                ),
              ],
          );

          when(() => persistence.updateLastSyncAt(any())).thenAnswer((_) => Future.value());

          await client.sync(cids: cids, lastSyncAt: lastSyncAt);

          verify(() => persistence.updateLastSyncAt(any())).called(1);
          verify(() => fakeChatApi.general.sync(cids, lastSyncAt)).called(1);
        },
      );

      test(
        'should work fine if persistence contains sync params',
        () async {
          // persistence.updateLastSyncAt might be called
          // when connecting the user.
          // Resetting the logs so we start counting invocations correctly.
          reset(persistence);
          const cids = ['test-cid-1', 'test-cid-2', 'test-cid-3'];
          final lastSyncAt = DateTime.now();

          when(persistence.getChannelCids).thenAnswer((_) async => cids);
          when(persistence.getLastSyncAt).thenAnswer((_) async => lastSyncAt);

          when(() => fakeChatApi.general.sync(cids, lastSyncAt)).thenAnswer(
            (_) async => SyncResponse()
              ..events = [
                Event(
                  isLocal: false,
                  type: EventType.messageDeleted,
                  message: Message(id: 'test-message-id', text: 'Hey!'),
                ),
              ],
          );

          when(() => persistence.updateLastSyncAt(any())).thenAnswer((_) => Future.value());

          await client.sync();

          verify(() => persistence.updateLastSyncAt(any())).called(1);
          verify(() => fakeChatApi.general.sync(cids, lastSyncAt)).called(1);
          verify(persistence.getChannelCids).called(1);
          verify(persistence.getLastSyncAt).called(1);
        },
      );
    });

    group('`.queryChannels`', () {
      test(
        'should emit channels twice if persistence contains some channels',
        () async {
          final persistentChannelStates = List.generate(
            3,
            (index) => ChannelState(
              channel: ChannelModel(cid: 'test-type-$index:test-id-$index'),
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
          ).thenAnswer((_) async => QueryChannelsResponse()..channels = persistentChannelStates);

          final channelStates = List.generate(
            3,
            (index) => ChannelState(
              channel: ChannelModel(cid: 'test-type-$index:test-id-$index'),
            ),
          );

          when(
            () => fakeChatApi.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).thenAnswer(
            (_) async => QueryChannelsResponse()..channels = channelStates,
          );

          when(() => persistence.getChannelThreads(any())).thenAnswer(
            (_) async => <String, List<Message>>{
              for (final channelState in channelStates)
                channelState.channel!.cid: [Message(id: 'test-message-id', text: 'Test message')],
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

          // setUp's `connectUser` schedules debounced persistence writes
          // (1s window) that would otherwise fire during this test's wait
          // and pollute the call counts. Wait past the debounce, then clear.
          await delay(1100);
          clearInteractions(persistence);

          await expectLater(
            client.queryChannels(),
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
          await delay(1500);

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

          verify(
            () => fakeChatApi.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).called(1);

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

      test(
        '''should never rethrow network call if persistence already emitted some channels''',
        () async {
          final persistentChannelStates = List.generate(
            3,
            (index) => ChannelState(
              channel: ChannelModel(cid: 'test-type-$index:test-id-$index'),
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
          ).thenAnswer((_) async => QueryChannelsResponse()..channels = persistentChannelStates);

          when(
            () => fakeChatApi.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).thenThrow(apiException(code: StreamErrorCode.inputError, statusCode: 400));

          when(() => persistence.getChannelThreads(any())).thenAnswer(
            (_) async => <String, List<Message>>{
              for (final channelState in persistentChannelStates)
                channelState.channel!.cid: [Message(id: 'test-message-id', text: 'Test message')],
            },
          );

          when(() => persistence.updateChannelState(any())).thenAnswer((_) async => {});
          when(() => persistence.updateChannelThreads(any(), any())).thenAnswer((_) async => {});

          // setUp's `connectUser` schedules debounced persistence writes
          // (1s window) that would otherwise fire during this test's wait
          // and pollute the call counts. Wait past the debounce, then clear.
          await delay(1100);
          clearInteractions(persistence);

          await expectLater(
            client.queryChannels(),
            emitsInOrder([
              // emits persistent channels
              persistentChannelStates.map(isCorrectChannelFor),
            ]),
          );

          // Wait safely past the 1s debounce on persistence writes
          // (updateChannelState, updateChannelThreads) so all trailing
          // invocations have fired before we verify counts.
          await delay(1500);

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

          verify(
            () => fakeChatApi.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).called(1);

          verify(() => persistence.getChannelThreads(any())).called(persistentChannelStates.length);
          verify(() => persistence.updateChannelState(any())).called(persistentChannelStates.length);
          verify(() => persistence.updateChannelThreads(any(), any())).called(persistentChannelStates.length);
        },
      );

      test(
        'queryChannelsOnline with inline filter persists via saveChannelQueries',
        () async {
          final filter = ChannelFilter.in_(ChannelFilterField.members, const ['test-user-id']);

          final channelStates = List.generate(
            3,
            (i) => ChannelState(channel: ChannelModel(cid: 'test-type-$i:test-id-$i')),
          );

          when(
            () => fakeChatApi.channel.queryChannels(
              filter: filter,
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).thenAnswer(
            (_) async => QueryChannelsResponse()..channels = channelStates,
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

          await delay(1100);
          clearInteractions(persistence);

          await client.queryChannelsOnline(filter: filter);

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

      test(
        'queryChannelsOnline with predefined filter persists via saveChannelQueries with resolved sort',
        () async {
          const filterName = 'sample-app-list';
          const filterValues = {'user_id': 'test-user-id'};
          const sortValues = {'pinned_at': true};

          final channelStates = List.generate(
            3,
            (i) => ChannelState(channel: ChannelModel(cid: 'test-type-$i:test-id-$i')),
          );

          // `Sort` has no value equality, so the verify below has to match on
          // the instance the response carried.
          final resolvedSort = [ChannelSort.desc(ChannelSortField.lastMessageAt)];

          when(
            () => fakeChatApi.channel.queryChannels(
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
          ).thenAnswer(
            (_) async => QueryChannelsResponse()
              ..channels = channelStates
              ..predefinedFilter = PredefinedFilter(
                name: filterName,
                filter: const ChannelFilter.raw({}),
                sort: resolvedSort,
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

          await delay(1100);
          clearInteractions(persistence);

          await client.queryChannelsOnline(
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
              resolvedFilter: const ChannelFilter.raw({}),
              resolvedSort: resolvedSort,
              filterValues: filterValues,
              sortValues: sortValues,
              clearQueryCache: true,
            ),
          ).called(1);
        },
      );

      test('queryChannelsOnline sends a message limit of 25 when none is given', () async {
        when(
          () => fakeChatApi.channel.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: any(named: 'paginationParams'),
          ),
        ).thenAnswer((_) async => QueryChannelsResponse()..channels = const []);
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
        clearInteractions(fakeChatApi.channel);

        await client.queryChannelsOnline();

        verify(
          () => fakeChatApi.channel.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: 25,
            paginationParams: any(named: 'paginationParams'),
          ),
        ).called(1);
      });

      test(
        'queryChannelsOffline with predefined filter reads via queryChannelStates',
        () async {
          const filterName = 'sample-app-list';
          const filterValues = {'user_id': 'test-user-id'};
          const sortValues = {'pinned_at': true};

          final channelStates = List.generate(
            3,
            (i) => ChannelState(channel: ChannelModel(cid: 'test-type-$i:test-id-$i')),
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
          ).thenAnswer((_) async => QueryChannelsResponse()..channels = channelStates);

          when(() => persistence.getChannelThreads(any())).thenAnswer((_) async => <String, List<Message>>{});
          when(() => persistence.updateChannelState(any())).thenAnswer((_) async {});
          when(() => persistence.updateChannelThreads(any(), any())).thenAnswer((_) async {});

          await delay(1100);
          clearInteractions(persistence);

          final channels = await client.queryChannelsOffline(
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

      test(
        'queryChannelsWithResult yields QueryChannelsResult with predefinedFilter=null for inline filter',
        () async {
          final channelStates = List.generate(
            2,
            (i) => ChannelState(channel: ChannelModel(cid: 'test-type-$i:test-id-$i')),
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
          ).thenAnswer((_) async => QueryChannelsResponse()..channels = const []);

          when(
            () => fakeChatApi.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).thenAnswer(
            (_) async => QueryChannelsResponse()..channels = channelStates,
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

          await delay(1100);
          clearInteractions(persistence);

          final results = await client.queryChannelsWithResult().toList();

          // Persistence returned empty, so only the online emission is yielded.
          expect(results, hasLength(1));
          expect(results.single.channels, hasLength(channelStates.length));
          expect(results.single.predefinedFilter, isNull);
        },
      );

      test(
        'queryChannelsWithResult yields QueryChannelsResult with predefinedFilter populated for predefined query',
        () async {
          const filterName = 'sample-app-list';
          const filterValues = {'user_id': 'test-user-id'};
          const sortValues = {'pinned_at': true};

          final channelStates = List.generate(
            2,
            (i) => ChannelState(channel: ChannelModel(cid: 'test-type-$i:test-id-$i')),
          );

          final resolvedSort = [ChannelSort.desc(ChannelSortField.lastMessageAt)];
          const resolvedFilter = ChannelFilter.raw({});
          final expectedPredefinedFilter = PredefinedFilter(
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
          ).thenAnswer((_) async => QueryChannelsResponse()..channels = const []);

          when(
            () => fakeChatApi.channel.queryChannels(
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
          ).thenAnswer(
            (_) async => QueryChannelsResponse()
              ..channels = channelStates
              ..predefinedFilter = expectedPredefinedFilter,
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

          await delay(1100);
          clearInteractions(persistence);

          final results = await client
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

    test('`.disconnectUser` should reset state and user', () async {
      expect(client.state.currentUser, isNotNull);
      expect(client.connectionStatus, ConnectionStatus.connected);

      expectLater(
        // skipping initial connected value
        client.connectionStatusStream.skip(1),
        emitsInOrder([ConnectionStatus.disconnected]),
      );

      await client.disconnectUser(flushChatPersistence: true);

      expect(client.state.currentUser, isNull);
      expect(client.connectionStatus, ConnectionStatus.disconnected);
    });

    test('`.disconnectUser` resets appSettings to the default', () async {
      expect(client.appSettings.name, 'test-app');

      await client.disconnectUser(flushChatPersistence: true);

      expect(client.appSettings, const AppSettings());
    });
  });

  group('Client with connected user without persistence', () {
    const apiKey = 'test-api-key';
    const userId = 'test-user-id';
    late final fakeChatApi = FakeChatApi();
    late final defaultApi = MockDefaultApi();

    final user = User(id: userId);
    final token = testUserToken(user.id).rawValue;

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeEvent());
      registerFallbackValue(FakeMessage());
      registerFallbackValue(FakeDraftMessage());
      registerFallbackValue(FakePollVote());
      registerFallbackValue(const PaginationParams());
      registerFallbackValue(const api.CreatePollRequest(name: 'fallback'));
      registerFallbackValue(const api.UpdatePollRequest(id: 'fallback', name: 'fallback'));
      registerFallbackValue(const api.CreatePollOptionRequest(text: 'fallback'));
      registerFallbackValue(const api.UpdatePollOptionRequest(id: 'fallback', text: 'fallback'));
    });

    setUp(() async {
      // Clear any accumulated interactions from a previous test so that
      // verifyNoMoreInteractions on fakeChatApi.general stays accurate.
      clearInteractions(fakeChatApi.general);

      final ws = FakeChatServer();
      client = StreamChatClient(apiKey, chatApi: fakeChatApi, defaultApi: defaultApi, wsProvider: ws.connect);
      // Stub getApp so the background fetch after connectUser succeeds.
      when(defaultApi.getApp).thenAnswer((_) async => Result.success(fakeGetApplicationResponse()));
      await client.connectUser(user, token);
      await delay(300);
      expect(client.persistenceEnabled, isFalse);
      expect(client.connectionStatus, ConnectionStatus.connected);

      // Cleared after connecting, so the background getApp does not trip the
      // verifyNoMoreInteractions(defaultApi) checks below.
      clearInteractions(defaultApi);
    });

    tearDown(() async {
      await client.dispose();
    });

    group('`.sync`', () {
      test('should work fine', () async {
        const cids = ['test-cid-1', 'test-cid-2', 'test-cid-3'];
        final lastSyncAt = DateTime.now();

        when(() => fakeChatApi.general.sync(cids, lastSyncAt)).thenAnswer(
          (_) async => SyncResponse()
            ..events = [
              Event(
                isLocal: false,
                type: EventType.healthCheck,
                connectionId: 'test-connection-id',
                me: OwnUser.fromUser(user),
              ),
              Event(
                isLocal: false,
                type: EventType.messageDeleted,
                message: Message(id: 'test-message-id'),
              ),
            ],
        );

        await client.sync(cids: cids, lastSyncAt: lastSyncAt);

        verify(() => fakeChatApi.general.sync(cids, lastSyncAt)).called(1);
      });

      test('should return if `cids` is not available', () async {
        expect(client.sync, returnsNormally);
        verifyNever(() => fakeChatApi.general.sync(any(), any()));
      });

      test('should return if `lastSyncAt` is not available', () async {
        expect(() => client.sync(cids: ['test-cid-1']), returnsNormally);
        verifyNever(() => fakeChatApi.general.sync(any(), any()));
      });
    });

    group('`.queryChannels`', () {
      test('should work fine without persistent channels', () async {
        final channelStates = List.generate(
          3,
          (index) => ChannelState(
            channel: ChannelModel(cid: 'test-type-$index:test-id-$index'),
          ),
        );

        when(
          () => fakeChatApi.channel.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: any(named: 'paginationParams'),
          ),
        ).thenAnswer(
          (_) async => QueryChannelsResponse()..channels = channelStates,
        );

        expectLater(
          client.queryChannels(),
          emitsInOrder([channelStates.map(isCorrectChannelFor)]),
        );

        // Hack as `teardown` gets called even
        // before our stream starts emitting data
        await delay(300);

        verify(
          () => fakeChatApi.channel.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: any(named: 'paginationParams'),
          ),
        ).called(1);
      });

      test(
        '''should rethrow if `.queryChannelsOnline` throws and persistence channels are empty''',
        () async {
          when(
            () => fakeChatApi.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).thenThrow(apiException(code: StreamErrorCode.inputError, statusCode: 400));

          expectLater(
            client.queryChannels(),
            emitsError(isA<StreamApiException>()),
          );

          // Hack as `teardown` gets called even
          // before our stream starts emitting data
          await delay(300);

          verify(
            () => fakeChatApi.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).called(1);
        },
      );

      test('queryChannelsOnline omits the message limit when none is given', () async {
        when(
          () => fakeChatApi.channel.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: any(named: 'paginationParams'),
          ),
        ).thenAnswer((_) async => QueryChannelsResponse()..channels = const []);
        clearInteractions(fakeChatApi.channel);

        await client.queryChannelsOnline();

        verify(
          () => fakeChatApi.channel.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: null,
            paginationParams: any(named: 'paginationParams'),
          ),
        ).called(1);
      });

      test(
        'should coalesce concurrent identical calls into a single HTTP request',
        () async {
          // Regression test for a TOCTOU race in the _queryChannelsStreams
          // cache: the cache write previously happened after an offline-await,
          // so N sibling calls in the same event-loop tick all missed the
          // cache and each fired its own queryChannels HTTP request.
          //
          // With the fix, the cache slot is reserved synchronously after the
          // hash check, so concurrent callers find the in-flight future and
          // share its result.
          final channelStates = List.generate(
            3,
            (index) => ChannelState(
              channel: ChannelModel(cid: 'test-type-$index:test-id-$index'),
            ),
          );

          // Slow down the API so all concurrent callers are guaranteed to be
          // in flight at the same time when the cache write happens.
          when(
            () => fakeChatApi.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).thenAnswer((_) async {
            await delay(100);
            return QueryChannelsResponse()..channels = channelStates;
          });

          // Fire 5 identical calls back-to-back in the same tick.
          final results = await Future.wait(
            List.generate(5, (_) => client.queryChannels().toList()),
          );

          // All callers should receive the same channels.
          for (final emitted in results) {
            expect(emitted, hasLength(1));
            expect(emitted.single, channelStates.map(isCorrectChannelFor));
          }

          // But only ONE HTTP request should have been issued.
          verify(
            () => fakeChatApi.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).called(1);
        },
      );

      test(
        'should fire a fresh request once the cached future has settled',
        () async {
          // After the in-flight future completes, the cache slot is freed and
          // the next call must hit the API again — only concurrent callers
          // share the future, not sequential ones.
          final channelStates = List.generate(
            3,
            (index) => ChannelState(
              channel: ChannelModel(cid: 'test-type-$index:test-id-$index'),
            ),
          );

          when(
            () => fakeChatApi.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).thenAnswer(
            (_) async => QueryChannelsResponse()..channels = channelStates,
          );

          await client.queryChannels().toList();
          await client.queryChannels().toList();

          verify(
            () => fakeChatApi.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).called(2);
        },
      );

      test(
        'concurrent calls with different filters do not share the cache',
        () async {
          // The cache is keyed on a hash of the query parameters. Callers
          // with different filters/limits must each fire their own request.
          when(
            () => fakeChatApi.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).thenAnswer((_) async {
            await delay(100);
            return QueryChannelsResponse()..channels = [];
          });

          await Future.wait([
            client.queryChannels(filter: ChannelFilter.in_(ChannelFilterField.cid, const ['a'])).toList(),
            client.queryChannels(filter: ChannelFilter.in_(ChannelFilterField.cid, const ['b'])).toList(),
          ]);

          verify(
            () => fakeChatApi.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).called(2);
        },
      );

      test(
        'concurrent calls share the same error when the request fails',
        () async {
          // If the in-flight HTTP request fails, every concurrent caller
          // awaiting the shared future should see the same error rather than
          // each firing its own retry request.
          when(
            () => fakeChatApi.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).thenAnswer((_) async {
            await delay(100);
            throw apiException(code: StreamErrorCode.inputError, statusCode: 400);
          });

          final errors = await Future.wait(
            List.generate(5, (_) async {
              try {
                await client.queryChannels().toList();
                return null;
              } catch (e) {
                return e;
              }
            }),
          );

          // Every caller surfaces the same error type.
          expect(errors, hasLength(5));
          for (final error in errors) {
            expect(error, isA<StreamApiException>());
          }

          // But only ONE HTTP request was made — the rest piggybacked.
          verify(
            () => fakeChatApi.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).called(1);
        },
      );
    });

    test('`.queryUsers`', () async {
      final users = List.generate(
        3,
        (index) => User(id: 'test-user-id-$index'),
      );

      when(
        () => fakeChatApi.user.queryUsers(
          presence: any(named: 'presence'),
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async => QueryUsersResponse()..users = users);

      expectLater(
        // skipping initial seed event -> {} users
        client.state.usersStream.skip(1),
        emitsInOrder([
          {for (final user in users) user.id: user},
        ]),
      );

      final res = await client.queryUsers();
      expect(res, isNotNull);
      expect(res.users.length, users.length);

      verify(
        () => fakeChatApi.user.queryUsers(
          presence: any(named: 'presence'),
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).called(1);
      verifyNoMoreInteractions(fakeChatApi.user);
    });

    test('`.queryBannedUsers`', () async {
      final bans = List.generate(
        3,
        (index) => BannedUser(
          user: User(id: 'test-user-id-$index'),
          bannedBy: User(id: 'test-user-id-${index + 1}'),
        ),
      );

      const cid = 'message:nice-channel';
      final filter = BannedUserFilter.equal(BannedUserFilterField.channelCid, cid);

      when(
        () => fakeChatApi.moderation.queryBannedUsers(
          filter: filter,
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async => QueryBannedUsersResponse()..bans = bans);

      final res = await client.queryBannedUsers(filter: filter);
      expect(res, isNotNull);
      expect(res.bans.length, bans.length);

      verify(
        () => fakeChatApi.moderation.queryBannedUsers(
          filter: filter,
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).called(1);
      verifyNoMoreInteractions(fakeChatApi.moderation);
    });

    test('`.search`', () async {
      const cid = 'test-type:test-id';
      final filter = ChannelFilter.in_(ChannelFilterField.cid, const [cid]);

      final messages = List.generate(
        3,
        (index) => GetMessageResponse()
          ..channel = ChannelModel(cid: cid)
          ..message = Message(id: 'test-message-id-$index'),
      );

      when(
        () => fakeChatApi.general.searchMessages(
          filter,
          query: any(named: 'query'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
          messageFilters: any(named: 'messageFilters'),
        ),
      ).thenAnswer((_) async => SearchMessagesResponse()..results = messages);

      final res = await client.search(filter);
      expect(res, isNotNull);
      expect(res.results.length, messages.length);

      verify(
        () => fakeChatApi.general.searchMessages(
          filter,
          query: any(named: 'query'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
          messageFilters: any(named: 'messageFilters'),
        ),
      ).called(1);
      verifyNoMoreInteractions(fakeChatApi.general);
    });

    test('`.updateChannel`', () async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      const data = {'name': 'test-channel'};

      when(() => fakeChatApi.channel.updateChannel(channelId, channelType, data)).thenAnswer(
        (invocation) async => UpdateChannelResponse()
          ..channel = ChannelModel(
            id: channelId,
            type: channelType,
            extraData: {...data},
          ),
      );

      final res = await client.updateChannel(channelId, channelType, data);
      expect(res, isNotNull);
      expect(res.channel.cid, '$channelType:$channelId');
      expect(res.channel.extraData['name'], 'test-channel');

      verify(() => fakeChatApi.channel.updateChannel(channelId, channelType, data)).called(1);
      verifyNoMoreInteractions(fakeChatApi.channel);
    });

    test('StreamChatClient.addDevice sends the device and returns a success', () async {
      const id = 'test-device-id';
      const request = api.CreateDeviceRequest(
        id: id,
        pushProvider: api.CreateDeviceRequestPushProvider.firebase,
      );

      when(() => defaultApi.createDevice(createDeviceRequest: request)).thenAnswer(
        (_) async => const Result.success(api.DurationResponse(duration: '0.01ms')),
      );

      final res = await client.addDevice(id, PushProvider.firebase);
      expect(res, const Result<void>.success(null));

      verify(() => defaultApi.createDevice(createDeviceRequest: request)).called(1);
      verifyNoMoreInteractions(defaultApi);
    });

    test('StreamChatClient.addDevice sends a provider without a constant by its wire value', () async {
      const id = 'test-device-id';
      final request = api.CreateDeviceRequest(
        id: id,
        pushProvider: api.CreateDeviceRequestPushProvider.fromJson('onesignal'),
      );

      when(() => defaultApi.createDevice(createDeviceRequest: request)).thenAnswer(
        (_) async => const Result.success(api.DurationResponse(duration: '0.01ms')),
      );

      await client.addDevice(id, const PushProvider('onesignal'));

      verify(() => defaultApi.createDevice(createDeviceRequest: request)).called(1);
      verifyNoMoreInteractions(defaultApi);
    });

    test('StreamChatClient.addDevice sends the push provider name', () async {
      const id = 'test-device-id';
      const pushProviderName = 'my-custom-config';
      const request = api.CreateDeviceRequest(
        id: id,
        pushProvider: api.CreateDeviceRequestPushProvider.firebase,
        pushProviderName: pushProviderName,
      );

      when(() => defaultApi.createDevice(createDeviceRequest: request)).thenAnswer(
        (_) async => const Result.success(api.DurationResponse(duration: '0.01ms')),
      );

      await client.addDevice(id, PushProvider.firebase, pushProviderName: pushProviderName);

      verify(() => defaultApi.createDevice(createDeviceRequest: request)).called(1);
      verifyNoMoreInteractions(defaultApi);
    });

    test('StreamChatClient.addDevice sends an empty provider name as no name', () async {
      const id = 'test-device-id';
      const request = api.CreateDeviceRequest(
        id: id,
        pushProvider: api.CreateDeviceRequestPushProvider.apn,
      );

      when(() => defaultApi.createDevice(createDeviceRequest: request)).thenAnswer(
        (_) async => const Result.success(api.DurationResponse(duration: '0.01ms')),
      );

      await client.addDevice(id, PushProvider.apn, pushProviderName: '');

      verify(() => defaultApi.createDevice(createDeviceRequest: request)).called(1);
      verifyNoMoreInteractions(defaultApi);
    });

    test('StreamChatClient.addDevice returns the failure without throwing', () async {
      const error = StreamClientException(message: 'boom');
      const request = api.CreateDeviceRequest(
        id: 'test-device-id',
        pushProvider: api.CreateDeviceRequestPushProvider.firebase,
      );

      when(() => defaultApi.createDevice(createDeviceRequest: request)).thenAnswer(
        (_) async => const Result.failure(error),
      );

      final res = await client.addDevice('test-device-id', PushProvider.firebase);

      expect(res.exceptionOrNull(), error);
    });

    test('StreamChatClient.getDevices returns the registered devices', () async {
      when(defaultApi.listDevices).thenAnswer(
        (_) async => Result.success(
          api.ListDevicesResponse(
            duration: '0.01ms',
            devices: [
              _generatedDevice(id: 'device-1', pushProvider: 'firebase'),
              _generatedDevice(id: 'device-2', pushProvider: 'apn'),
              _generatedDevice(id: 'device-3', pushProvider: 'huawei'),
            ],
          ),
        ),
      );

      final res = await client.getDevices();
      expect(
        res.getOrNull(),
        const ListDevicesResponse(
          duration: '0.01ms',
          devices: [
            Device(id: 'device-1', pushProvider: PushProvider.firebase),
            Device(id: 'device-2', pushProvider: PushProvider.apn),
            Device(id: 'device-3', pushProvider: PushProvider.huawei),
          ],
        ),
      );

      verify(defaultApi.listDevices).called(1);
      verifyNoMoreInteractions(defaultApi);
    });

    test('StreamChatClient.getDevices returns the failure without throwing', () async {
      const error = StreamClientException(message: 'boom');
      when(defaultApi.listDevices).thenAnswer((_) async => const Result.failure(error));

      final res = await client.getDevices();

      expect(res.exceptionOrNull(), error);
    });

    test('StreamChatClient.removeDevice sends the device id and returns a success', () async {
      const deviceId = 'test-device-id';

      when(() => defaultApi.deleteDevice(id: deviceId)).thenAnswer(
        (_) async => const Result.success(api.DurationResponse(duration: '0.01ms')),
      );

      final res = await client.removeDevice(deviceId);
      expect(res, const Result<void>.success(null));

      verify(() => defaultApi.deleteDevice(id: deviceId)).called(1);
      verifyNoMoreInteractions(defaultApi);
    });

    test('StreamChatClient.removeDevice returns the failure without throwing', () async {
      const error = StreamClientException(message: 'boom');
      when(() => defaultApi.deleteDevice(id: 'test-device-id')).thenAnswer((_) async => const Result.failure(error));

      final res = await client.removeDevice('test-device-id');

      expect(res.exceptionOrNull(), error);
    });

    test('`.setPushPreferences`', () async {
      const pushPreferenceInput = PushPreferenceInput(
        chatLevel: ChatLevel.mentions,
      );

      const channelCid = 'messaging:123';
      const channelPreferenceInput = PushPreferenceInput.channel(
        channelCid: channelCid,
        chatLevel: ChatLevel.mentions,
      );

      const preferences = [pushPreferenceInput, channelPreferenceInput];

      final currentUser = client.state.currentUser;
      when(() => fakeChatApi.pushPreferences.setPushPreferences(preferences)).thenAnswer(
        (_) async => UpsertPushPreferencesResponse()
          ..userPreferences = {
            '${currentUser?.id}': PushPreference(
              chatLevel: pushPreferenceInput.chatLevel,
            ),
          }
          ..userChannelPreferences = {
            '${currentUser?.id}': {
              channelCid: ChannelPushPreference(
                chatLevel: channelPreferenceInput.chatLevel,
              ),
            },
          },
      );

      expect(
        client.eventStream,
        emitsInOrder([
          isA<Event>().having(
            (e) => e.type,
            'push_preference.updated event',
            EventType.pushPreferenceUpdated,
          ),
          isA<Event>().having(
            (e) => e.type,
            'channel.push_preference.updated event',
            EventType.channelPushPreferenceUpdated,
          ),
        ]),
      );

      final res = await client.setPushPreferences(preferences);
      expect(res, isNotNull);

      verify(() => fakeChatApi.pushPreferences.setPushPreferences(preferences)).called(1);
      verifyNoMoreInteractions(fakeChatApi.pushPreferences);
    });

    test('should handle push_preference.updated event', () async {
      final pushPreference = PushPreference(
        chatLevel: ChatLevel.mentions,
        callLevel: CallLevel.all,
        disabledUntil: DateTime.now().add(const Duration(hours: 1)),
      );

      final event = Event(
        type: EventType.pushPreferenceUpdated,
        pushPreference: pushPreference,
      );

      // Initially null
      expect(client.state.currentUser?.pushPreferences, isNull);

      // Trigger the event
      client.handleEvent(event);

      // Wait for the event to get processed
      await Future.delayed(Duration.zero);

      // Should update currentUser.pushPreferences
      final pushPreferences = client.state.currentUser?.pushPreferences;
      expect(pushPreferences, isNotNull);
      expect(pushPreferences?.chatLevel, ChatLevel.mentions);
      expect(pushPreferences?.callLevel, CallLevel.all);
      expect(pushPreferences?.disabledUntil, pushPreference.disabledUntil);
    });

    test('StreamChatClient.listUserGroups sends the pagination arguments and returns the listed groups', () async {
      const limit = 10;
      const idGt = 'cursor-group-id';
      final createdAtGt = DateTime.utc(2024, 6, 15, 12).toLocal();
      const teamId = 'test-team-id';

      when(
        () => defaultApi.listUserGroups(
          limit: limit,
          idGt: idGt,
          createdAtGt: '2024-06-15T12:00:00.000Z',
          teamId: teamId,
        ),
      ).thenAnswer(
        (_) async => Result.success(
          api.ListUserGroupsResponse(
            duration: '0.01ms',
            userGroups: [_generatedUserGroup('group-1'), _generatedUserGroup('group-2')],
          ),
        ),
      );

      final res = await client.listUserGroups(limit: limit, idGt: idGt, createdAtGt: createdAtGt, teamId: teamId);
      expect(
        res.getOrNull(),
        ListUserGroupsResponse(duration: '0.01ms', userGroups: [_userGroup('group-1'), _userGroup('group-2')]),
      );

      verify(
        () => defaultApi.listUserGroups(
          limit: limit,
          idGt: idGt,
          createdAtGt: '2024-06-15T12:00:00.000Z',
          teamId: teamId,
        ),
      ).called(1);
      verifyNoMoreInteractions(defaultApi);
    });

    test('StreamChatClient.listUserGroups returns the failure without throwing', () async {
      const error = StreamClientException(message: 'boom');
      when(() => defaultApi.listUserGroups()).thenAnswer((_) async => const Result.failure(error));

      final res = await client.listUserGroups();

      expect(res.exceptionOrNull(), error);
    });

    test('StreamChatClient.searchUserGroups sends the query and returns the matching groups', () async {
      const query = 'eng';
      const limit = 10;
      const nameGt = 'engineering';
      const idGt = 'cursor-group-id';
      const teamId = 'test-team-id';

      when(
        () => defaultApi.searchUserGroups(query: query, limit: limit, nameGt: nameGt, idGt: idGt, teamId: teamId),
      ).thenAnswer(
        (_) async => Result.success(
          api.SearchUserGroupsResponse(
            duration: '0.01ms',
            userGroups: [_generatedUserGroup('group-1'), _generatedUserGroup('group-2')],
          ),
        ),
      );

      final res = await client.searchUserGroups(query, limit: limit, nameGt: nameGt, idGt: idGt, teamId: teamId);
      expect(
        res.getOrNull(),
        SearchUserGroupsResponse(duration: '0.01ms', userGroups: [_userGroup('group-1'), _userGroup('group-2')]),
      );

      verify(
        () => defaultApi.searchUserGroups(query: query, limit: limit, nameGt: nameGt, idGt: idGt, teamId: teamId),
      ).called(1);
      verifyNoMoreInteractions(defaultApi);
    });

    test('StreamChatClient.searchUserGroups returns the failure without throwing', () async {
      const error = StreamClientException(message: 'boom');
      when(() => defaultApi.searchUserGroups(query: 'eng')).thenAnswer((_) async => const Result.failure(error));

      final res = await client.searchUserGroups('eng');

      expect(res.exceptionOrNull(), error);
    });

    test('StreamChatClient.getUserGroup sends the id and team and returns the group', () async {
      const id = 'test-group-id';
      const teamId = 'test-team-id';

      when(() => defaultApi.getUserGroup(id: id, teamId: teamId)).thenAnswer(
        (_) async => Result.success(
          api.GetUserGroupResponse(
            duration: '0.01ms',
            userGroup: api.UserGroupResponse(
              createdAt: DateTime.utc(2024, 1, 2),
              createdBy: 'test-creator-id',
              description: 'Everyone on call this week',
              id: id,
              members: [
                api.UserGroupMember(
                  appPk: 42,
                  createdAt: DateTime.utc(2024, 5, 6),
                  groupId: id,
                  isAdmin: true,
                  userId: 'test-user-1',
                ),
                api.UserGroupMember(
                  appPk: 42,
                  createdAt: DateTime.utc(2024, 7, 8),
                  groupId: id,
                  isAdmin: false,
                  userId: 'test-user-2',
                ),
              ],
              name: 'on-call',
              teamId: teamId,
              updatedAt: DateTime.utc(2024, 3, 4),
            ),
          ),
        ),
      );

      final res = await client.getUserGroup(id, teamId: teamId);
      expect(
        res.getOrNull(),
        GetUserGroupResponse(
          duration: '0.01ms',
          userGroup: UserGroup(
            createdAt: DateTime.utc(2024, 1, 2),
            createdBy: 'test-creator-id',
            description: 'Everyone on call this week',
            id: id,
            members: [
              UserGroupMember(
                createdAt: DateTime.utc(2024, 5, 6),
                groupId: id,
                isAdmin: true,
                userId: 'test-user-1',
              ),
              UserGroupMember(
                createdAt: DateTime.utc(2024, 7, 8),
                groupId: id,
                isAdmin: false,
                userId: 'test-user-2',
              ),
            ],
            name: 'on-call',
            teamId: teamId,
            updatedAt: DateTime.utc(2024, 3, 4),
          ),
        ),
      );

      verify(() => defaultApi.getUserGroup(id: id, teamId: teamId)).called(1);
      verifyNoMoreInteractions(defaultApi);
    });

    test('StreamChatClient.getUserGroup keeps the members null when the response leaves them out', () async {
      const id = 'test-group-id';
      when(() => defaultApi.getUserGroup(id: id)).thenAnswer(
        (_) async => Result.success(api.GetUserGroupResponse(duration: '0.01ms', userGroup: _generatedUserGroup(id))),
      );

      final res = await client.getUserGroup(id);

      expect(res.getOrNull()!.userGroup!.members, isNull);
    });

    test('StreamChatClient.getUserGroup keeps an empty member list empty', () async {
      const id = 'test-group-id';
      when(() => defaultApi.getUserGroup(id: id)).thenAnswer(
        (_) async => Result.success(
          api.GetUserGroupResponse(
            duration: '0.01ms',
            userGroup: api.UserGroupResponse(
              createdAt: DateTime.utc(2024),
              id: id,
              members: const [],
              name: 'name-$id',
              updatedAt: DateTime.utc(2024),
            ),
          ),
        ),
      );

      final res = await client.getUserGroup(id);

      expect(res.getOrNull()!.userGroup!.members, isEmpty);
    });

    test('StreamChatClient.getUserGroup returns a null group when the response has none', () async {
      const id = 'test-group-id';
      when(() => defaultApi.getUserGroup(id: id)).thenAnswer(
        (_) async => const Result.success(api.GetUserGroupResponse(duration: '0.01ms')),
      );

      final res = await client.getUserGroup(id);

      expect(res, const Result.success(GetUserGroupResponse(duration: '0.01ms')));
    });

    test('StreamChatClient.getUserGroup returns the failure without throwing', () async {
      const error = StreamClientException(message: 'boom');
      when(() => defaultApi.getUserGroup(id: 'test-group-id')).thenAnswer((_) async => const Result.failure(error));

      final res = await client.getUserGroup('test-group-id');

      expect(res.exceptionOrNull(), error);
    });

    test('StreamChatClient.createUserGroup sends the arguments and returns the created group', () async {
      const name = 'Engineering';
      const id = 'test-group-id';
      const description = 'The engineers';
      const teamId = 'test-team-id';
      const memberIds = ['test-user-id'];
      const request = api.CreateUserGroupRequest(
        name: name,
        id: id,
        description: description,
        teamId: teamId,
        memberIds: memberIds,
      );

      when(() => defaultApi.createUserGroup(createUserGroupRequest: request)).thenAnswer(
        (_) async =>
            Result.success(api.CreateUserGroupResponse(duration: '0.01ms', userGroup: _generatedUserGroup(id))),
      );

      final res = await client.createUserGroup(
        name,
        id: id,
        description: description,
        teamId: teamId,
        memberIds: memberIds,
      );
      expect(res.getOrNull(), CreateUserGroupResponse(duration: '0.01ms', userGroup: _userGroup(id)));

      verify(() => defaultApi.createUserGroup(createUserGroupRequest: request)).called(1);
      verifyNoMoreInteractions(defaultApi);
    });

    test('StreamChatClient.createUserGroup returns a null group when the response has none', () async {
      const request = api.CreateUserGroupRequest(name: 'Engineering');
      when(() => defaultApi.createUserGroup(createUserGroupRequest: request)).thenAnswer(
        (_) async => const Result.success(api.CreateUserGroupResponse(duration: '0.01ms')),
      );

      final res = await client.createUserGroup('Engineering');

      expect(res, const Result.success(CreateUserGroupResponse(duration: '0.01ms')));
    });

    test('StreamChatClient.createUserGroup returns the failure without throwing', () async {
      const error = StreamClientException(message: 'boom');
      const request = api.CreateUserGroupRequest(name: 'Engineering');
      when(
        () => defaultApi.createUserGroup(createUserGroupRequest: request),
      ).thenAnswer((_) async => const Result.failure(error));

      final res = await client.createUserGroup('Engineering');

      expect(res.exceptionOrNull(), error);
    });

    test('StreamChatClient.updateUserGroup sends the arguments and returns the updated group', () async {
      const id = 'test-group-id';
      const name = 'Engineering';
      const description = 'The engineers';
      const teamId = 'test-team-id';
      const request = api.UpdateUserGroupRequest(name: name, description: description, teamId: teamId);

      when(() => defaultApi.updateUserGroup(id: id, updateUserGroupRequest: request)).thenAnswer(
        (_) async =>
            Result.success(api.UpdateUserGroupResponse(duration: '0.01ms', userGroup: _generatedUserGroup(id))),
      );

      final res = await client.updateUserGroup(id, name: name, description: description, teamId: teamId);
      expect(res.getOrNull(), UpdateUserGroupResponse(duration: '0.01ms', userGroup: _userGroup(id)));

      verify(() => defaultApi.updateUserGroup(id: id, updateUserGroupRequest: request)).called(1);
      verifyNoMoreInteractions(defaultApi);
    });

    test('StreamChatClient.updateUserGroup returns a null group when the response has none', () async {
      const id = 'test-group-id';
      when(
        () => defaultApi.updateUserGroup(id: id, updateUserGroupRequest: const api.UpdateUserGroupRequest()),
      ).thenAnswer((_) async => const Result.success(api.UpdateUserGroupResponse(duration: '0.01ms')));

      final res = await client.updateUserGroup(id);

      expect(res, const Result.success(UpdateUserGroupResponse(duration: '0.01ms')));
    });

    test('StreamChatClient.updateUserGroup returns the failure without throwing', () async {
      const id = 'test-group-id';
      const error = StreamClientException(message: 'boom');
      when(
        () => defaultApi.updateUserGroup(id: id, updateUserGroupRequest: const api.UpdateUserGroupRequest()),
      ).thenAnswer((_) async => const Result.failure(error));

      final res = await client.updateUserGroup(id);

      expect(res.exceptionOrNull(), error);
    });

    test('StreamChatClient.deleteUserGroup sends the id and team and returns a success', () async {
      const id = 'test-group-id';
      const teamId = 'test-team-id';

      when(
        () => defaultApi.deleteUserGroup(id: id, teamId: teamId),
      ).thenAnswer((_) async => const Result.success(api.DurationResponse(duration: '0.01ms')));

      final res = await client.deleteUserGroup(id, teamId: teamId);
      expect(res, const Result<void>.success(null));

      verify(() => defaultApi.deleteUserGroup(id: id, teamId: teamId)).called(1);
      verifyNoMoreInteractions(defaultApi);
    });

    test('StreamChatClient.deleteUserGroup returns the failure without throwing', () async {
      const error = StreamClientException(message: 'boom');
      when(() => defaultApi.deleteUserGroup(id: 'test-group-id')).thenAnswer((_) async => const Result.failure(error));

      final res = await client.deleteUserGroup('test-group-id');

      expect(res.exceptionOrNull(), error);
    });

    test('StreamChatClient.addUserGroupMembers sends the members and returns the updated group', () async {
      const id = 'test-group-id';
      const memberIds = ['test-user-id'];
      const teamId = 'test-team-id';
      const request = api.AddUserGroupMembersRequest(memberIds: memberIds, asAdmin: true, teamId: teamId);

      when(() => defaultApi.addUserGroupMembers(id: id, addUserGroupMembersRequest: request)).thenAnswer(
        (_) async =>
            Result.success(api.AddUserGroupMembersResponse(duration: '0.01ms', userGroup: _generatedUserGroup(id))),
      );

      final res = await client.addUserGroupMembers(id, memberIds, asAdmin: true, teamId: teamId);
      expect(res.getOrNull(), AddUserGroupMembersResponse(duration: '0.01ms', userGroup: _userGroup(id)));

      verify(() => defaultApi.addUserGroupMembers(id: id, addUserGroupMembersRequest: request)).called(1);
      verifyNoMoreInteractions(defaultApi);
    });

    test('StreamChatClient.addUserGroupMembers returns a null group when the response has none', () async {
      const id = 'test-group-id';
      const request = api.AddUserGroupMembersRequest(memberIds: ['test-user-id']);
      when(() => defaultApi.addUserGroupMembers(id: id, addUserGroupMembersRequest: request)).thenAnswer(
        (_) async => const Result.success(api.AddUserGroupMembersResponse(duration: '0.01ms')),
      );

      final res = await client.addUserGroupMembers(id, const ['test-user-id']);

      expect(res, const Result.success(AddUserGroupMembersResponse(duration: '0.01ms')));
    });

    test('StreamChatClient.addUserGroupMembers returns the failure without throwing', () async {
      const id = 'test-group-id';
      const error = StreamClientException(message: 'boom');
      const request = api.AddUserGroupMembersRequest(memberIds: ['test-user-id']);
      when(
        () => defaultApi.addUserGroupMembers(id: id, addUserGroupMembersRequest: request),
      ).thenAnswer((_) async => const Result.failure(error));

      final res = await client.addUserGroupMembers(id, const ['test-user-id']);

      expect(res.exceptionOrNull(), error);
    });

    test('StreamChatClient.removeUserGroupMembers sends the members and returns the updated group', () async {
      const id = 'test-group-id';
      const memberIds = ['test-user-id'];
      const teamId = 'test-team-id';
      const request = api.RemoveUserGroupMembersRequest(memberIds: memberIds, teamId: teamId);

      when(() => defaultApi.removeUserGroupMembers(id: id, removeUserGroupMembersRequest: request)).thenAnswer(
        (_) async =>
            Result.success(api.RemoveUserGroupMembersResponse(duration: '0.01ms', userGroup: _generatedUserGroup(id))),
      );

      final res = await client.removeUserGroupMembers(id, memberIds, teamId: teamId);
      expect(res.getOrNull(), RemoveUserGroupMembersResponse(duration: '0.01ms', userGroup: _userGroup(id)));

      verify(() => defaultApi.removeUserGroupMembers(id: id, removeUserGroupMembersRequest: request)).called(1);
      verifyNoMoreInteractions(defaultApi);
    });

    test('StreamChatClient.removeUserGroupMembers returns a null group when the response has none', () async {
      const id = 'test-group-id';
      const request = api.RemoveUserGroupMembersRequest(memberIds: ['test-user-id']);
      when(() => defaultApi.removeUserGroupMembers(id: id, removeUserGroupMembersRequest: request)).thenAnswer(
        (_) async => const Result.success(api.RemoveUserGroupMembersResponse(duration: '0.01ms')),
      );

      final res = await client.removeUserGroupMembers(id, const ['test-user-id']);

      expect(res, const Result.success(RemoveUserGroupMembersResponse(duration: '0.01ms')));
    });

    test('StreamChatClient.removeUserGroupMembers returns the failure without throwing', () async {
      const id = 'test-group-id';
      const error = StreamClientException(message: 'boom');
      const request = api.RemoveUserGroupMembersRequest(memberIds: ['test-user-id']);
      when(
        () => defaultApi.removeUserGroupMembers(id: id, removeUserGroupMembersRequest: request),
      ).thenAnswer((_) async => const Result.failure(error));

      final res = await client.removeUserGroupMembers(id, const ['test-user-id']);

      expect(res.exceptionOrNull(), error);
    });

    test('StreamChatClient.searchRoles sends the query and returns the matching roles', () async {
      const query = 'adm';
      const limit = 10;
      const nameGt = 'admin';
      const roleType = RoleType.user;
      const includeGlobalRoles = true;

      when(
        () => defaultApi.searchRoles(
          query: query,
          limit: limit,
          nameGt: nameGt,
          roleType: roleType,
          includeGlobalRoles: includeGlobalRoles,
        ),
      ).thenAnswer(
        (_) async => Result.success(
          api.SearchRolesResponse(
            duration: '0.01ms',
            roles: [
              api.Role(
                name: 'admin',
                custom: false,
                scopes: const ['.app'],
                createdAt: DateTime.utc(2024, 1, 2),
                updatedAt: DateTime.utc(2024, 3, 4),
              ),
              api.Role(
                name: 'admin_lite',
                custom: true,
                scopes: const ['messaging'],
                createdAt: DateTime.utc(2024, 5, 6),
                updatedAt: DateTime.utc(2024, 7, 8),
              ),
            ],
          ),
        ),
      );

      final res = await client.searchRoles(
        query,
        limit: limit,
        nameGt: nameGt,
        roleType: roleType,
        includeGlobalRoles: includeGlobalRoles,
      );
      expect(
        res.getOrNull(),
        SearchRolesResponse(
          duration: '0.01ms',
          roles: [
            Role(
              name: 'admin',
              custom: false,
              scopes: const ['.app'],
              createdAt: DateTime.utc(2024, 1, 2),
              updatedAt: DateTime.utc(2024, 3, 4),
            ),
            Role(
              name: 'admin_lite',
              custom: true,
              scopes: const ['messaging'],
              createdAt: DateTime.utc(2024, 5, 6),
              updatedAt: DateTime.utc(2024, 7, 8),
            ),
          ],
        ),
      );

      verify(
        () => defaultApi.searchRoles(
          query: query,
          limit: limit,
          nameGt: nameGt,
          roleType: roleType,
          includeGlobalRoles: includeGlobalRoles,
        ),
      ).called(1);
      verifyNoMoreInteractions(defaultApi);
    });

    test('StreamChatClient.searchRoles returns the failure without throwing', () async {
      const query = 'adm';
      const error = StreamClientException(message: 'boom');

      when(
        () => defaultApi.searchRoles(query: query),
      ).thenAnswer((_) async => const Result.failure(error));

      final res = await client.searchRoles(query);

      expect(res.exceptionOrNull(), error);
    });

    test('StreamChatClient.searchRoles sends only the query when nothing else is given', () async {
      const query = 'adm';

      when(
        () => defaultApi.searchRoles(query: query),
      ).thenAnswer((_) async => const Result.success(api.SearchRolesResponse(duration: '0.01ms', roles: [])));

      await client.searchRoles(query);

      verify(() => defaultApi.searchRoles(query: query)).called(1);
      verifyNoMoreInteractions(defaultApi);
    });

    test('StreamChatClient.getAppSettings returns the app settings', () async {
      when(defaultApi.getApp).thenAnswer(
        (_) async => const Result.success(
          api.GetApplicationResponse(
            duration: '0.01ms',
            app: api.AppResponseFields(
              id: 42,
              name: 'test-app',
              placement: 'us-east',
              autoTranslationEnabled: true,
              asyncUrlEnrichEnabled: false,
              fileUploadConfig: api.FileUploadConfig(
                sizeLimit: 10485760,
                allowedFileExtensions: ['.csv'],
                blockedFileExtensions: ['.exe'],
                allowedMimeTypes: ['text/csv'],
                blockedMimeTypes: ['application/x-msdownload'],
              ),
              imageUploadConfig: api.FileUploadConfig(
                sizeLimit: 5242880,
                allowedFileExtensions: ['.png'],
                blockedFileExtensions: ['.gif'],
                allowedMimeTypes: ['image/png'],
                blockedMimeTypes: ['image/gif'],
              ),
            ),
          ),
        ),
      );

      final res = await client.getAppSettings();
      expect(
        res.getOrNull(),
        const AppSettingsResponse(
          duration: '0.01ms',
          app: AppSettings(
            name: 'test-app',
            autoTranslationEnabled: true,
            fileUploadConfig: UploadConfig(
              sizeLimit: 10485760,
              allowedFileExtensions: ['.csv'],
              blockedFileExtensions: ['.exe'],
              allowedMimeTypes: ['text/csv'],
              blockedMimeTypes: ['application/x-msdownload'],
            ),
            imageUploadConfig: UploadConfig(
              sizeLimit: 5242880,
              allowedFileExtensions: ['.png'],
              blockedFileExtensions: ['.gif'],
              allowedMimeTypes: ['image/png'],
              blockedMimeTypes: ['image/gif'],
            ),
          ),
        ),
      );

      verify(defaultApi.getApp).called(1);
      verifyNoMoreInteractions(defaultApi);
    });

    test('StreamChatClient.getAppSettings returns the failure without throwing', () async {
      const error = StreamClientException(message: 'boom');
      when(defaultApi.getApp).thenAnswer((_) async => const Result.failure(error));

      final res = await client.getAppSettings();

      expect(res.exceptionOrNull(), error);
    });

    test('StreamChatClient.getAppSettings replaces appSettings on success', () async {
      when(defaultApi.getApp).thenAnswer((_) async => Result.success(fakeGetApplicationResponse(name: 'fresh')));

      await client.getAppSettings();

      expect(client.appSettings.name, 'fresh');
    });

    test('StreamChatClient.getAppSettings keeps appSettings when it fails', () async {
      when(defaultApi.getApp).thenAnswer((_) async => const Result.failure(StreamClientException(message: 'boom')));

      await client.getAppSettings();

      expect(client.appSettings.name, 'test-app');
    });

    test('StreamChatClient.getAppSettings uses the default size limit when none is configured', () async {
      when(defaultApi.getApp).thenAnswer((_) async => Result.success(fakeGetApplicationResponse()));

      final res = await client.getAppSettings();

      expect(res.getOrNull()?.app.fileUploadConfig.sizeLimit, UploadConfig.defaultSizeLimit);
    });

    test('StreamChatClient.createPoll sends the poll settings and returns the created poll', () async {
      when(
        () => defaultApi.createPoll(createPollRequest: any(named: 'createPollRequest')),
      ).thenAnswer((_) async => Result.success(generatedPollResponse));

      final result = await client.createPoll(_newPoll());

      final request = verify(
        () => defaultApi.createPoll(createPollRequest: captureAny(named: 'createPollRequest')),
      ).captured.single;
      expect(
        request,
        const api.CreatePollRequest(
          id: 'poll-id',
          name: 'Lunch?',
          description: 'Pick one',
          options: [
            api.PollOptionInput(text: 'Pizza', custom: {'color': 'red'}),
            api.PollOptionInput(text: 'Sushi', custom: {}),
          ],
          votingVisibility: api.CreatePollRequestVotingVisibility.anonymous,
          enforceUniqueVote: false,
          maxVotesAllowed: 2,
          allowAnswers: true,
          allowUserSuggestedOptions: true,
          isClosed: false,
          custom: {'topic': 'food'},
        ),
      );
      expect(result, Result.success(pollResponse));
    });

    test('StreamChatClient.createPoll returns the failure without throwing', () async {
      when(
        () => defaultApi.createPoll(createPollRequest: any(named: 'createPollRequest')),
      ).thenAnswer((_) async => const Result.failure(pollsApiError));

      final result = await client.createPoll(_newPoll());

      expect(result.exceptionOrNull(), pollsApiError);
    });

    test('StreamChatClient.getPoll sends the poll id and returns the poll', () async {
      when(() => defaultApi.getPoll(pollId: 'poll-id')).thenAnswer((_) async => Result.success(generatedPollResponse));

      final result = await client.getPoll('poll-id');

      expect(result, Result.success(pollResponse));
    });

    test('StreamChatClient.getPoll returns the failure without throwing', () async {
      when(() => defaultApi.getPoll(pollId: 'poll-id')).thenAnswer((_) async => const Result.failure(pollsApiError));

      final result = await client.getPoll('poll-id');

      expect(result.exceptionOrNull(), pollsApiError);
    });

    test(
      "StreamChatClient.getPoll keeps custom fields named like the poll's own fields out of its custom data",
      () async {
        final response = api.PollResponse(
          duration: '4.21ms',
          poll: generatedPoll.copyWith(custom: const {'topic': 'food', 'name': 'custom-name', 'own_votes': 'custom'}),
        );
        when(() => defaultApi.getPoll(pollId: 'poll-id')).thenAnswer((_) async => Result.success(response));

        final result = await client.getPoll('poll-id');

        expect(result.getOrNull()?.poll.extraData, const {'topic': 'food'});
      },
    );

    test('StreamChatClient.getPoll keeps a voting visibility the SDK does not name', () async {
      final response = api.PollResponse(
        duration: '4.21ms',
        poll: generatedPoll.copyWith(votingVisibility: api.PollResponseDataVotingVisibility.fromJson('members_only')),
      );
      when(() => defaultApi.getPoll(pollId: 'poll-id')).thenAnswer((_) async => Result.success(response));

      final result = await client.getPoll('poll-id');

      expect(result.getOrNull()?.poll.votingVisibility, const VotingVisibility('members_only'));
    });

    test('StreamChatClient.getPoll reads a poll that does not say whether it is closed as open', () async {
      final response = api.PollResponse(duration: '4.21ms', poll: generatedPoll.copyWith(isClosed: null));
      when(() => defaultApi.getPoll(pollId: 'poll-id')).thenAnswer((_) async => Result.success(response));

      final result = await client.getPoll('poll-id');

      expect(result.getOrNull()?.poll.isClosed, isFalse);
    });

    test('StreamChatClient.updatePoll sends the poll settings and options and returns the updated poll', () async {
      when(
        () => defaultApi.updatePoll(updatePollRequest: any(named: 'updatePollRequest')),
      ).thenAnswer((_) async => Result.success(generatedPollResponse));

      final result = await client.updatePoll(
        _newPoll().copyWith(
          options: const [
            PollOption(id: 'pizza', text: 'Pizza', extraData: {'color': 'red', 'id': 'pasta'}),
            PollOption(id: 'sushi', text: 'Sushi'),
          ],
          isClosed: true,
        ),
      );

      final request = verify(
        () => defaultApi.updatePoll(updatePollRequest: captureAny(named: 'updatePollRequest')),
      ).captured.single;
      expect(
        request,
        const api.UpdatePollRequest(
          id: 'poll-id',
          name: 'Lunch?',
          description: 'Pick one',
          options: [
            api.PollOptionRequest(id: 'pizza', text: 'Pizza', custom: {'color': 'red'}),
            api.PollOptionRequest(id: 'sushi', text: 'Sushi', custom: {}),
          ],
          votingVisibility: api.UpdatePollRequestVotingVisibility.anonymous,
          enforceUniqueVote: false,
          maxVotesAllowed: 2,
          allowAnswers: true,
          allowUserSuggestedOptions: true,
          isClosed: true,
          custom: {'topic': 'food'},
        ),
      );
      expect(result, Result.success(pollResponse));
    });

    test('StreamChatClient.updatePoll sends an option without an id with an empty id', () async {
      when(
        () => defaultApi.updatePoll(updatePollRequest: any(named: 'updatePollRequest')),
      ).thenAnswer((_) async => Result.success(generatedPollResponse));

      await client.updatePoll(_newPoll().copyWith(options: const [PollOption(text: 'Pizza')]));

      final request =
          verify(
                () => defaultApi.updatePoll(updatePollRequest: captureAny(named: 'updatePollRequest')),
              ).captured.single
              as api.UpdatePollRequest;
      expect(request.options, const [api.PollOptionRequest(id: '', text: 'Pizza', custom: {})]);
    });

    test('StreamChatClient.updatePoll returns the failure without throwing', () async {
      when(
        () => defaultApi.updatePoll(updatePollRequest: any(named: 'updatePollRequest')),
      ).thenAnswer((_) async => const Result.failure(pollsApiError));

      final result = await client.updatePoll(poll);

      expect(result.exceptionOrNull(), pollsApiError);
    });

    test('StreamChatClient.partialUpdatePoll sends the fields to set and unset and returns the updated poll', () async {
      when(
        () => defaultApi.updatePollPartial(
          pollId: 'poll-id',
          updatePollPartialRequest: const api.UpdatePollPartialRequest(
            set: {'name': 'Dinner?'},
            unset: ['description'],
          ),
        ),
      ).thenAnswer((_) async => Result.success(generatedPollResponse));

      final result = await client.partialUpdatePoll('poll-id', set: {'name': 'Dinner?'}, unset: ['description']);

      expect(result, Result.success(pollResponse));
    });

    test('StreamChatClient.partialUpdatePoll returns the failure without throwing', () async {
      when(
        () => defaultApi.updatePollPartial(
          pollId: 'poll-id',
          updatePollPartialRequest: const api.UpdatePollPartialRequest(set: {'name': 'Dinner?'}),
        ),
      ).thenAnswer((_) async => const Result.failure(pollsApiError));

      final result = await client.partialUpdatePoll('poll-id', set: {'name': 'Dinner?'});

      expect(result.exceptionOrNull(), pollsApiError);
    });

    test('StreamChatClient.closePoll marks the poll closed and returns the closed poll', () async {
      when(
        () => defaultApi.updatePollPartial(
          pollId: 'poll-id',
          updatePollPartialRequest: const api.UpdatePollPartialRequest(set: {'is_closed': true}),
        ),
      ).thenAnswer((_) async => Result.success(generatedPollResponse));

      final result = await client.closePoll('poll-id');

      expect(result, Result.success(pollResponse));
    });

    test('StreamChatClient.closePoll returns the failure without throwing', () async {
      when(
        () => defaultApi.updatePollPartial(
          pollId: 'poll-id',
          updatePollPartialRequest: const api.UpdatePollPartialRequest(set: {'is_closed': true}),
        ),
      ).thenAnswer((_) async => const Result.failure(pollsApiError));

      final result = await client.closePoll('poll-id');

      expect(result.exceptionOrNull(), pollsApiError);
    });

    test('StreamChatClient.deletePoll sends the poll id and returns a success', () async {
      when(
        () => defaultApi.deletePoll(pollId: 'poll-id'),
      ).thenAnswer((_) async => const Result.success(api.DurationResponse(duration: '4.21ms')));

      final result = await client.deletePoll('poll-id');

      expect(result, const Result<void>.success(null));
    });

    test('StreamChatClient.deletePoll returns the failure without throwing', () async {
      when(() => defaultApi.deletePoll(pollId: 'poll-id')).thenAnswer((_) async => const Result.failure(pollsApiError));

      final result = await client.deletePoll('poll-id');

      expect(result.exceptionOrNull(), pollsApiError);
    });

    test('StreamChatClient.queryPolls sends the filter, sort and cursor and returns the matching polls', () async {
      when(
        () => defaultApi.queryPolls(
          queryPollsRequest: const api.QueryPollsRequest(
            filter: {
              'is_closed': {r'$eq': true},
            },
            sort: [api.SortParamRequest(field: 'created_at', direction: -1)],
            limit: 10,
            next: 'next-cursor',
          ),
        ),
      ).thenAnswer(
        (_) async => Result.success(
          api.QueryPollsResponse(duration: '4.21ms', polls: [generatedPoll], next: 'after', prev: 'before'),
        ),
      );

      final result = await client.queryPolls(
        filter: Filter.equal(PollFilterField.isClosed, true),
        sort: [PollSort.desc(PollSortField.createdAt)],
        limit: 10,
        next: 'next-cursor',
      );

      expect(
        result,
        Result.success(QueryPollsResponse(duration: '4.21ms', polls: [poll], next: 'after', prev: 'before')),
      );
    });

    test('StreamChatClient.queryPolls sends the previous-page cursor and ten as the default limit', () async {
      when(
        () => defaultApi.queryPolls(queryPollsRequest: const api.QueryPollsRequest(limit: 10, prev: 'prev-cursor')),
      ).thenAnswer((_) async => const Result.success(api.QueryPollsResponse(duration: '4.21ms', polls: [])));

      final result = await client.queryPolls(prev: 'prev-cursor');

      expect(result, const Result.success(QueryPollsResponse(duration: '4.21ms', polls: [])));
    });

    test('StreamChatClient.queryPolls returns the failure without throwing', () async {
      when(
        () => defaultApi.queryPolls(queryPollsRequest: const api.QueryPollsRequest(limit: 10)),
      ).thenAnswer((_) async => const Result.failure(pollsApiError));

      final result = await client.queryPolls();

      expect(result.exceptionOrNull(), pollsApiError);
    });

    test(
      'StreamChatClient.createPollOption sends the option text and custom data and returns the created option',
      () async {
        when(
          () => defaultApi.createPollOption(
            pollId: 'poll-id',
            createPollOptionRequest: const api.CreatePollOptionRequest(text: 'Pizza', custom: {'color': 'red'}),
          ),
        ).thenAnswer((_) async => const Result.success(_generatedPizzaResponse));

        final result = await client.createPollOption(
          'poll-id',
          const PollOption(text: 'Pizza', extraData: {'color': 'red', 'text': 'Pasta'}),
        );

        expect(result, const Result.success(_pizzaResponse));
      },
    );

    test('StreamChatClient.createPollOption returns the failure without throwing', () async {
      when(
        () => defaultApi.createPollOption(
          pollId: 'poll-id',
          createPollOptionRequest: any(named: 'createPollOptionRequest'),
        ),
      ).thenAnswer((_) async => const Result.failure(pollsApiError));

      final result = await client.createPollOption('poll-id', const PollOption(text: 'Pizza'));

      expect(result.exceptionOrNull(), pollsApiError);
    });

    test('StreamChatClient.getPollOption sends the poll and option ids and returns the option', () async {
      when(
        () => defaultApi.getPollOption(pollId: 'poll-id', optionId: 'pizza'),
      ).thenAnswer((_) async => const Result.success(_generatedPizzaResponse));

      final result = await client.getPollOption('poll-id', 'pizza');

      expect(result, const Result.success(_pizzaResponse));
    });

    test('StreamChatClient.getPollOption returns the failure without throwing', () async {
      when(
        () => defaultApi.getPollOption(pollId: 'poll-id', optionId: 'pizza'),
      ).thenAnswer((_) async => const Result.failure(pollsApiError));

      final result = await client.getPollOption('poll-id', 'pizza');

      expect(result.exceptionOrNull(), pollsApiError);
    });

    test(
      "StreamChatClient.getPollOption keeps custom fields named like the option's own fields out of its custom data",
      () async {
        final response = api.PollOptionResponse(
          duration: '4.21ms',
          pollOption: generatedPizza.copyWith(custom: const {'color': 'red', 'text': 'custom-text'}),
        );
        when(
          () => defaultApi.getPollOption(pollId: 'poll-id', optionId: 'pizza'),
        ).thenAnswer((_) async => Result.success(response));

        final result = await client.getPollOption('poll-id', 'pizza');

        expect(result.getOrNull()?.pollOption.extraData, const {'color': 'red'});
      },
    );

    test('StreamChatClient.updatePollOption sends the option and returns the updated option', () async {
      when(
        () => defaultApi.updatePollOption(
          pollId: 'poll-id',
          updatePollOptionRequest: const api.UpdatePollOptionRequest(
            id: 'pizza',
            text: 'Pizza',
            custom: {'color': 'red'},
          ),
        ),
      ).thenAnswer((_) async => const Result.success(_generatedPizzaResponse));

      final result = await client.updatePollOption('poll-id', pizza);

      expect(result, const Result.success(_pizzaResponse));
    });

    test('StreamChatClient.updatePollOption sends an option without an id with an empty id', () async {
      when(
        () => defaultApi.updatePollOption(
          pollId: 'poll-id',
          updatePollOptionRequest: const api.UpdatePollOptionRequest(id: '', text: 'Pizza', custom: {}),
        ),
      ).thenAnswer((_) async => const Result.success(_generatedPizzaResponse));

      final result = await client.updatePollOption('poll-id', const PollOption(text: 'Pizza'));

      expect(result, const Result.success(_pizzaResponse));
    });

    test('StreamChatClient.updatePollOption returns the failure without throwing', () async {
      when(
        () => defaultApi.updatePollOption(
          pollId: 'poll-id',
          updatePollOptionRequest: any(named: 'updatePollOptionRequest'),
        ),
      ).thenAnswer((_) async => const Result.failure(pollsApiError));

      final result = await client.updatePollOption('poll-id', pizza);

      expect(result.exceptionOrNull(), pollsApiError);
    });

    test('StreamChatClient.deletePollOption sends the poll and option ids and returns a success', () async {
      when(
        () => defaultApi.deletePollOption(pollId: 'poll-id', optionId: 'pizza'),
      ).thenAnswer((_) async => const Result.success(api.DurationResponse(duration: '4.21ms')));

      final result = await client.deletePollOption('poll-id', 'pizza');

      expect(result, const Result<void>.success(null));
    });

    test('StreamChatClient.deletePollOption returns the failure without throwing', () async {
      when(
        () => defaultApi.deletePollOption(pollId: 'poll-id', optionId: 'pizza'),
      ).thenAnswer((_) async => const Result.failure(pollsApiError));

      final result = await client.deletePollOption('poll-id', 'pizza');

      expect(result.exceptionOrNull(), pollsApiError);
    });

    test('StreamChatClient.castPollVote sends the selected option and returns the cast vote', () async {
      when(
        () => defaultApi.castPollVote(
          messageId: 'message-id',
          pollId: 'poll-id',
          castPollVoteRequest: const api.CastPollVoteRequest(vote: api.VoteData(optionId: 'pizza')),
        ),
      ).thenAnswer(
        (_) async => Result.success(api.PollVoteResponse(duration: '4.21ms', poll: generatedPoll, vote: generatedVote)),
      );

      final result = await client.castPollVote('message-id', 'poll-id', optionId: 'pizza');

      expect(result, Result.success(PollVoteResponse(duration: '4.21ms', vote: vote)));
    });

    test('StreamChatClient.castPollVote returns the failure without throwing', () async {
      when(
        () => defaultApi.castPollVote(
          messageId: 'message-id',
          pollId: 'poll-id',
          castPollVoteRequest: const api.CastPollVoteRequest(vote: api.VoteData(optionId: 'pizza')),
        ),
      ).thenAnswer((_) async => const Result.failure(pollsApiError));

      final result = await client.castPollVote('message-id', 'poll-id', optionId: 'pizza');

      expect(result.exceptionOrNull(), pollsApiError);
    });

    test('StreamChatClient.castPollVote returns no vote when the response carries none', () async {
      when(
        () => defaultApi.castPollVote(
          messageId: 'message-id',
          pollId: 'poll-id',
          castPollVoteRequest: const api.CastPollVoteRequest(vote: api.VoteData(optionId: 'pizza')),
        ),
      ).thenAnswer((_) async => const Result.success(api.PollVoteResponse(duration: '4.21ms')));

      final result = await client.castPollVote('message-id', 'poll-id', optionId: 'pizza');

      expect(result, const Result.success(PollVoteResponse(duration: '4.21ms')));
    });

    test('StreamChatClient.addPollAnswer sends the answer text and returns the answer', () async {
      when(
        () => defaultApi.castPollVote(
          messageId: 'message-id',
          pollId: 'poll-id',
          castPollVoteRequest: const api.CastPollVoteRequest(vote: api.VoteData(answerText: 'Anything')),
        ),
      ).thenAnswer(
        (_) async =>
            Result.success(api.PollVoteResponse(duration: '4.21ms', poll: generatedPoll, vote: generatedAnswer)),
      );

      final result = await client.addPollAnswer('message-id', 'poll-id', answerText: 'Anything');

      expect(result, Result.success(PollVoteResponse(duration: '4.21ms', vote: answer)));
    });

    test('StreamChatClient.addPollAnswer returns the failure without throwing', () async {
      when(
        () => defaultApi.castPollVote(
          messageId: 'message-id',
          pollId: 'poll-id',
          castPollVoteRequest: const api.CastPollVoteRequest(vote: api.VoteData(answerText: 'Anything')),
        ),
      ).thenAnswer((_) async => const Result.failure(pollsApiError));

      final result = await client.addPollAnswer('message-id', 'poll-id', answerText: 'Anything');

      expect(result.exceptionOrNull(), pollsApiError);
    });

    test('StreamChatClient.removePollVote sends the vote id and returns the removed vote', () async {
      when(
        () => defaultApi.deletePollVote(messageId: 'message-id', pollId: 'poll-id', voteId: 'vote-id'),
      ).thenAnswer(
        (_) async => Result.success(api.PollVoteResponse(duration: '4.21ms', poll: generatedPoll, vote: generatedVote)),
      );

      final result = await client.removePollVote('message-id', 'poll-id', 'vote-id');

      expect(result, Result.success(PollVoteResponse(duration: '4.21ms', vote: vote)));
    });

    test('StreamChatClient.removePollVote returns the failure without throwing', () async {
      when(
        () => defaultApi.deletePollVote(messageId: 'message-id', pollId: 'poll-id', voteId: 'vote-id'),
      ).thenAnswer((_) async => const Result.failure(pollsApiError));

      final result = await client.removePollVote('message-id', 'poll-id', 'vote-id');

      expect(result.exceptionOrNull(), pollsApiError);
    });

    test('StreamChatClient.queryPollVotes sends the filter, sort and cursor and returns the matching votes', () async {
      when(
        () => defaultApi.queryPollVotes(
          pollId: 'poll-id',
          queryPollVotesRequest: const api.QueryPollVotesRequest(
            filter: {
              'is_answer': {r'$eq': true},
            },
            sort: [api.SortParamRequest(field: 'created_at', direction: 1)],
            limit: 25,
            prev: 'prev-cursor',
          ),
        ),
      ).thenAnswer(
        (_) async => Result.success(
          api.PollVotesResponse(duration: '4.21ms', votes: [generatedVote, generatedAnswer], next: 'after', prev: 'x'),
        ),
      );

      final result = await client.queryPollVotes(
        'poll-id',
        filter: Filter.equal(PollVoteFilterField.isAnswer, true),
        sort: [PollVoteSort.asc(PollVoteSortField.createdAt)],
        limit: 25,
        prev: 'prev-cursor',
      );

      expect(
        result,
        Result.success(QueryPollVotesResponse(duration: '4.21ms', votes: [vote, answer], next: 'after', prev: 'x')),
      );
    });

    test('StreamChatClient.queryPollVotes returns the failure without throwing', () async {
      when(
        () => defaultApi.queryPollVotes(
          pollId: 'poll-id',
          queryPollVotesRequest: const api.QueryPollVotesRequest(limit: 10),
        ),
      ).thenAnswer((_) async => const Result.failure(pollsApiError));

      final result = await client.queryPollVotes('poll-id');

      expect(result.exceptionOrNull(), pollsApiError);
    });

    test('StreamChatClient.queryPollVotes sends ten as the default limit', () async {
      when(
        () => defaultApi.queryPollVotes(
          pollId: 'poll-id',
          queryPollVotesRequest: const api.QueryPollVotesRequest(limit: 10),
        ),
      ).thenAnswer((_) async => const Result.success(api.PollVotesResponse(duration: '4.21ms', votes: [])));

      final result = await client.queryPollVotes('poll-id');

      expect(result, const Result.success(QueryPollVotesResponse(duration: '4.21ms', votes: [])));
    });

    group('`.channel`', () {
      test('should return back a new channel instance', () {
        const channelType = 'test-channel-type';
        const channelId = 'test-channel-id';
        const channelData = {'name': 'test-channel-name'};

        final channel = client.channel(
          channelType,
          id: channelId,
          extraData: channelData,
        );

        expect(channel, isNotNull);
        expect(channel.type, channelType);
        expect(channel.id, channelId);
        expect(channel.cid, '$channelType:$channelId');
        expect(channel.extraData, channelData);
      });

      test('should return back in memory channel instance if available', () async {
        const channelType = 'test-channel-type';
        const channelId = 'test-channel-id';
        const channelData = {'name': 'test-channel-name'};
        const channelCid = '$channelType:$channelId';

        final channel = client.channel(
          channelType,
          id: channelId,
          extraData: channelData,
        );

        final channelState = ChannelState(
          channel: ChannelModel(cid: channelCid),
        );

        when(
          () => fakeChatApi.channel.queryChannel(
            channelType,
            channelId: channelId,
            channelData: channelData,
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          ),
        ).thenAnswer((_) async => channelState);

        expectLater(
          client.state.channelsStream.skip(1),
          emitsInOrder([
            {channelCid: isCorrectChannelFor(channelState)},
          ]),
        );

        await channel.watch();

        final newChannel = client.channel(channelType, id: channelId);
        expect(newChannel, channel);

        verify(
          () => fakeChatApi.channel.queryChannel(
            channelType,
            channelId: channelId,
            channelData: channelData,
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          ),
        ).called(1);
      });
    });

    test('`.createChannel`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const channelData = {'name': 'test-channel-name'};
      const channelCid = '$channelType:$channelId';

      final channelState = ChannelState(
        channel: ChannelModel(cid: channelCid, extraData: channelData),
      );

      when(
        () => fakeChatApi.channel.queryChannel(
          channelType,
          channelId: channelId,
          channelData: channelData,
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          messagesPagination: any(named: 'messagesPagination'),
          membersPagination: any(named: 'membersPagination'),
          watchersPagination: any(named: 'watchersPagination'),
        ),
      ).thenAnswer((_) async => channelState);

      final res = await client.createChannel(
        channelType,
        channelId: channelId,
        channelData: channelData,
      );

      expect(res, isNotNull);
      expect(res.channel, isNotNull);
      final channel = res.channel!;
      expect(channel.type, channelType);
      expect(channel.id, channelId);
      expect(channel.cid, '$channelType:$channelId');
      expect(channel.extraData, channelData);

      verify(
        () => fakeChatApi.channel.queryChannel(
          channelType,
          channelId: channelId,
          channelData: channelData,
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          messagesPagination: any(named: 'messagesPagination'),
          membersPagination: any(named: 'membersPagination'),
          watchersPagination: any(named: 'watchersPagination'),
        ),
      ).called(1);
      verifyNoMoreInteractions(fakeChatApi.channel);
    });

    test('`.watchChannel`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const channelData = {'name': 'test-channel-name'};
      const channelCid = '$channelType:$channelId';

      final channelState = ChannelState(
        channel: ChannelModel(cid: channelCid, extraData: channelData),
      );

      when(
        () => fakeChatApi.channel.queryChannel(
          channelType,
          channelId: channelId,
          channelData: channelData,
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          messagesPagination: any(named: 'messagesPagination'),
          membersPagination: any(named: 'membersPagination'),
          watchersPagination: any(named: 'watchersPagination'),
        ),
      ).thenAnswer((_) async => channelState);

      final res = await client.watchChannel(
        channelType,
        channelId: channelId,
        channelData: channelData,
      );

      expect(res, isNotNull);
      expect(res.channel, isNotNull);
      final channel = res.channel!;
      expect(channel.type, channelType);
      expect(channel.id, channelId);
      expect(channel.cid, '$channelType:$channelId');
      expect(channel.extraData, channelData);

      verify(
        () => fakeChatApi.channel.queryChannel(
          channelType,
          channelId: channelId,
          channelData: channelData,
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          messagesPagination: any(named: 'messagesPagination'),
          membersPagination: any(named: 'membersPagination'),
          watchersPagination: any(named: 'watchersPagination'),
        ),
      ).called(1);
      verifyNoMoreInteractions(fakeChatApi.channel);
    });

    test('`.queryChannel`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const channelData = {'name': 'test-channel-name'};
      const channelCid = '$channelType:$channelId';

      final channelState = ChannelState(
        channel: ChannelModel(cid: channelCid, extraData: channelData),
      );

      when(
        () => fakeChatApi.channel.queryChannel(
          channelType,
          channelId: channelId,
          channelData: channelData,
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          messagesPagination: any(named: 'messagesPagination'),
          membersPagination: any(named: 'membersPagination'),
          watchersPagination: any(named: 'watchersPagination'),
        ),
      ).thenAnswer((_) async => channelState);

      final res = await client.queryChannel(
        channelType,
        channelId: channelId,
        channelData: channelData,
      );

      expect(res, isNotNull);
      expect(res.channel, isNotNull);
      final channel = res.channel!;
      expect(channel.type, channelType);
      expect(channel.id, channelId);
      expect(channel.cid, '$channelType:$channelId');
      expect(channel.extraData, channelData);

      verify(
        () => fakeChatApi.channel.queryChannel(
          channelType,
          channelId: channelId,
          channelData: channelData,
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          messagesPagination: any(named: 'messagesPagination'),
          membersPagination: any(named: 'membersPagination'),
          watchersPagination: any(named: 'watchersPagination'),
        ),
      ).called(1);
      verifyNoMoreInteractions(fakeChatApi.channel);
    });

    test('`.queryMembers`', () async {
      const channelType = 'test-channel-type';

      final members = List.generate(
        3,
        (index) => Member(userId: 'test-user-id-$index'),
      );

      when(() => fakeChatApi.general.queryMembers(channelType)).thenAnswer(
        (_) async => QueryMembersResponse()..members = members,
      );

      final res = await client.queryMembers(channelType);
      expect(res, isNotNull);
      expect(res.members.length, members.length);

      verify(() => fakeChatApi.general.queryMembers(channelType)).called(1);
      verifyNoMoreInteractions(fakeChatApi.general);
    });

    test('`.truncateChannel`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';

      when(() => fakeChatApi.channel.truncateChannel(channelId, channelType)).thenAnswer((_) async => EmptyResponse());

      final res = await client.truncateChannel(channelId, channelType);

      expect(res, isNotNull);

      verify(
        () => fakeChatApi.channel.truncateChannel(channelId, channelType),
      ).called(1);
      verifyNoMoreInteractions(fakeChatApi.channel);
    });

    test('`.acceptChannelInvite`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const channelCid = '$channelType:$channelId';

      when(
        () => fakeChatApi.channel.acceptChannelInvite(channelId, channelType),
      ).thenAnswer((_) async => AcceptInviteResponse()..channel = ChannelModel(cid: channelCid));

      final res = await client.acceptChannelInvite(channelId, channelType);
      expect(res, isNotNull);
      expect(res.channel.cid, channelCid);

      verify(() => fakeChatApi.channel.acceptChannelInvite(channelId, channelType)).called(1);
      verifyNoMoreInteractions(fakeChatApi.channel);
    });

    test('`.rejectChannelInvite`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const channelCid = '$channelType:$channelId';

      when(
        () => fakeChatApi.channel.rejectChannelInvite(channelId, channelType),
      ).thenAnswer((_) async => RejectInviteResponse()..channel = ChannelModel(cid: channelCid));

      final res = await client.rejectChannelInvite(channelId, channelType);
      expect(res, isNotNull);
      expect(res.channel.cid, channelCid);

      verify(() => fakeChatApi.channel.rejectChannelInvite(channelId, channelType)).called(1);
      verifyNoMoreInteractions(fakeChatApi.channel);
    });

    test('`.addChannelMembers`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const channelCid = '$channelType:$channelId';

      final members = List.generate(
        3,
        (index) => Member(userId: 'test-user-id-$index'),
      );

      final memberIds = members.map((e) => e.userId!).toList(growable: false);

      when(() => fakeChatApi.channel.addMembers(channelId, channelType, memberIds)).thenAnswer(
        (_) async => AddMembersResponse()
          ..channel = ChannelModel(cid: channelCid)
          ..members = members,
      );

      final res = await client.addChannelMembers(
        channelId,
        channelType,
        memberIds,
      );

      expect(res, isNotNull);
      expect(res.channel.cid, channelCid);
      expect(res.members.length, memberIds.length);

      verify(
        () => fakeChatApi.channel.addMembers(channelId, channelType, memberIds),
      ).called(1);
      verifyNoMoreInteractions(fakeChatApi.channel);
    });

    test('`.addChannelMembers` with hideHistoryBefore', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const channelCid = '$channelType:$channelId';

      final members = List.generate(
        3,
        (index) => Member(userId: 'test-user-id-$index'),
      );

      final memberIds = members.map((e) => e.userId!).toList(growable: false);
      final hideHistoryBefore = DateTime.parse('2024-01-01T00:00:00Z');

      when(
        () => fakeChatApi.channel.addMembers(
          channelId,
          channelType,
          memberIds,
          hideHistoryBefore: hideHistoryBefore,
        ),
      ).thenAnswer(
        (_) async => AddMembersResponse()
          ..channel = ChannelModel(cid: channelCid)
          ..members = members,
      );

      final res = await client.addChannelMembers(
        channelId,
        channelType,
        memberIds,
        hideHistoryBefore: hideHistoryBefore,
      );

      expect(res, isNotNull);
      expect(res.channel.cid, channelCid);
      expect(res.members.length, memberIds.length);

      verify(
        () => fakeChatApi.channel.addMembers(
          channelId,
          channelType,
          memberIds,
          hideHistoryBefore: hideHistoryBefore,
        ),
      ).called(1);
      verifyNoMoreInteractions(fakeChatApi.channel);
    });

    test('`.removeChannelMembers`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const channelCid = '$channelType:$channelId';

      final members = List.generate(
        3,
        (index) => Member(userId: 'test-user-id-$index'),
      );

      final memberIds = members.map((e) => e.userId!).toList(growable: false);

      when(() => fakeChatApi.channel.removeMembers(channelId, channelType, memberIds)).thenAnswer(
        (_) async => RemoveMembersResponse()
          ..channel = ChannelModel(cid: channelCid)
          ..members = members,
      );

      final res = await client.removeChannelMembers(
        channelId,
        channelType,
        memberIds,
      );

      expect(res, isNotNull);
      expect(res.channel.cid, channelCid);
      expect(res.members.length, memberIds.length);

      verify(
        () => fakeChatApi.channel.removeMembers(channelId, channelType, memberIds),
      ).called(1);
      verifyNoMoreInteractions(fakeChatApi.channel);
    });

    test('`.inviteChannelMembers`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const channelCid = '$channelType:$channelId';

      final members = List.generate(
        3,
        (index) => Member(userId: 'test-user-id-$index'),
      );

      final memberIds = members.map((e) => e.userId!).toList(growable: false);

      when(() => fakeChatApi.channel.inviteChannelMembers(channelId, channelType, memberIds)).thenAnswer(
        (_) async => InviteMembersResponse()
          ..channel = ChannelModel(cid: channelCid)
          ..members = members,
      );

      final res = await client.inviteChannelMembers(
        channelId,
        channelType,
        memberIds,
      );

      expect(res, isNotNull);
      expect(res.channel.cid, channelCid);
      expect(res.members.length, memberIds.length);

      verify(() => fakeChatApi.channel.inviteChannelMembers(channelId, channelType, memberIds)).called(1);
      verifyNoMoreInteractions(fakeChatApi.channel);
    });

    test('`.stopChannelWatching`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';

      when(() => fakeChatApi.channel.stopWatching(channelId, channelType)).thenAnswer((_) async => EmptyResponse());

      final res = await client.stopChannelWatching(channelId, channelType);
      expect(res, isNotNull);

      verify(() => fakeChatApi.channel.stopWatching(channelId, channelType)).called(1);
      verifyNoMoreInteractions(fakeChatApi.channel);
    });

    test('`.sendAction`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const messageId = 'test-message-id';
      const formData = {'key': 'value'};

      when(
        () => fakeChatApi.message.sendAction(channelId, channelType, messageId, formData),
      ).thenAnswer((_) async => SendActionResponse());

      final res = await client.sendAction(
        channelId,
        channelType,
        messageId,
        formData,
      );

      expect(res, isNotNull);

      verify(() => fakeChatApi.message.sendAction(channelId, channelType, messageId, formData)).called(1);
      verifyNoMoreInteractions(fakeChatApi.message);
    });

    test('`.getActiveLiveLocations`', () async {
      final locations = [
        Location(
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device-1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        ),
        Location(
          latitude: 34.0522,
          longitude: -118.2437,
          createdByDeviceId: 'device-2',
          endAt: DateTime.now().add(const Duration(hours: 2)),
        ),
      ];

      when(() => fakeChatApi.user.getActiveLiveLocations()).thenAnswer(
        (_) async =>
            GetActiveLiveLocationsResponse() //
              ..activeLiveLocations = locations,
      );

      // Initial state should be empty
      expect(client.state.activeLiveLocations, isEmpty);

      final res = await client.getActiveLiveLocations();

      expect(res, isNotNull);
      expect(res.activeLiveLocations, hasLength(2));
      expect(res.activeLiveLocations, equals(locations));
      expect(client.state.activeLiveLocations, equals(locations));

      verify(() => fakeChatApi.user.getActiveLiveLocations()).called(1);
      verifyNoMoreInteractions(fakeChatApi.user);
    });

    test('`.updateLiveLocation`', () async {
      const messageId = 'test-message-id';
      const createdByDeviceId = 'test-device-id';
      final endAt = DateTime.timestamp().add(const Duration(hours: 1));
      const location = LocationCoordinate(
        latitude: 40.7128,
        longitude: -74.0060,
      );

      final expectedLocation = Location(
        latitude: location.latitude,
        longitude: location.longitude,
        createdByDeviceId: createdByDeviceId,
        endAt: endAt,
      );

      when(
        () => fakeChatApi.user.updateLiveLocation(
          messageId: messageId,
          createdByDeviceId: createdByDeviceId,
          location: location,
          endAt: endAt,
        ),
      ).thenAnswer((_) async => expectedLocation);

      final res = await client.updateLiveLocation(
        messageId: messageId,
        createdByDeviceId: createdByDeviceId,
        location: location,
        endAt: endAt,
      );

      expect(res, isNotNull);
      expect(res, equals(expectedLocation));

      verify(
        () => fakeChatApi.user.updateLiveLocation(
          messageId: messageId,
          createdByDeviceId: createdByDeviceId,
          location: location,
          endAt: endAt,
        ),
      ).called(1);
      verifyNoMoreInteractions(fakeChatApi.user);
    });

    test('`.stopLiveLocation`', () async {
      const messageId = 'test-message-id';
      const createdByDeviceId = 'test-device-id';

      final expectedLocation = Location(
        latitude: 40.7128,
        longitude: -74.0060,
        createdByDeviceId: createdByDeviceId,
        endAt: DateTime.now(), // Should be expired
      );

      when(
        () => fakeChatApi.user.updateLiveLocation(
          messageId: messageId,
          createdByDeviceId: createdByDeviceId,
          endAt: any(named: 'endAt'),
        ),
      ).thenAnswer((_) async => expectedLocation);

      final res = await client.stopLiveLocation(
        messageId: messageId,
        createdByDeviceId: createdByDeviceId,
      );

      expect(res, isNotNull);
      expect(res, equals(expectedLocation));

      verify(
        () => fakeChatApi.user.updateLiveLocation(
          messageId: messageId,
          createdByDeviceId: createdByDeviceId,
          endAt: any(named: 'endAt'),
        ),
      ).called(1);
      verifyNoMoreInteractions(fakeChatApi.user);
    });

    group('Live Location Event Handling', () {
      test('should handle location.shared event', () async {
        final location = Location(
          channelCid: 'test-channel:123',
          messageId: 'message-123',
          userId: userId,
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device-1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final event = Event(
          type: EventType.locationShared,
          cid: 'test-channel:123',
          message: Message(
            id: 'message-123',
            sharedLocation: location,
          ),
        );

        // Initially empty
        expect(client.state.activeLiveLocations, isEmpty);

        // Trigger the event
        client.handleEvent(event);

        // Wait for the event to get processed
        await Future.delayed(Duration.zero);

        // Should add location to active live locations
        final activeLiveLocations = client.state.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations.first.messageId, equals('message-123'));
      });

      test('should handle location.updated event', () async {
        final initialLocation = Location(
          channelCid: 'test-channel:123',
          messageId: 'message-123',
          userId: userId,
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device-1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        // Set initial location
        client.state.activeLiveLocations = [initialLocation];

        final updatedLocation = Location(
          channelCid: 'test-channel:123',
          messageId: 'message-123',
          userId: userId,
          latitude: 40.7500, // Updated latitude
          longitude: -74.1000, // Updated longitude
          createdByDeviceId: 'device-1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final event = Event(
          type: EventType.locationUpdated,
          cid: 'test-channel:123',
          message: Message(
            id: 'message-123',
            sharedLocation: updatedLocation,
          ),
        );

        // Trigger the event
        client.handleEvent(event);

        // Wait for the event to get processed
        await Future.delayed(Duration.zero);

        // Should update the location
        final activeLiveLocations = client.state.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations.first.latitude, equals(40.7500));
        expect(activeLiveLocations.first.longitude, equals(-74.1000));
      });

      test('should handle location.expired event', () async {
        final location = Location(
          channelCid: 'test-channel:123',
          messageId: 'message-123',
          userId: userId,
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device-1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        // Set initial location
        client.state.activeLiveLocations = [location];
        expect(client.state.activeLiveLocations, hasLength(1));

        final expiredLocation = location.copyWith(
          endAt: DateTime.now().subtract(const Duration(hours: 1)),
        );

        final event = Event(
          type: EventType.locationExpired,
          cid: 'test-channel:123',
          message: Message(
            id: 'message-123',
            sharedLocation: expiredLocation,
          ),
        );

        // Trigger the event
        client.handleEvent(event);

        // Wait for the event to get processed
        await Future.delayed(Duration.zero);

        // Should remove the location
        expect(client.state.activeLiveLocations, isEmpty);
      });

      test('should auto-expire an active live location once at endAt', () async {
        final expiredEvents = <Event>[];
        final sub = client.on(EventType.locationExpired).listen(expiredEvents.add);
        addTearDown(sub.cancel);

        // Setting an active location schedules a one-shot expiry timer.
        client.state.activeLiveLocations = [
          Location(
            channelCid: 'test-channel:123',
            messageId: 'message-123',
            userId: userId,
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device-1',
            endAt: DateTime.now().add(const Duration(milliseconds: 800)),
          ),
        ];
        expect(client.state.activeLiveLocations, hasLength(1));

        // Before endAt nothing is emitted and the location stays active.
        await delay(200);
        expect(expiredEvents, isEmpty);
        expect(client.state.activeLiveLocations, hasLength(1));

        // After endAt the timer fires once and the location is removed.
        await delay(900);
        expect(expiredEvents, hasLength(1));
        expect(client.state.activeLiveLocations, isEmpty);

        // The timer is one-shot: no further events are emitted.
        await delay(300);
        expect(expiredEvents, hasLength(1));
      });

      test('should ignore location events for other users', () async {
        final location = Location(
          channelCid: 'test-channel:123',
          messageId: 'message-123',
          userId: 'other-user', // Different user
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device-1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final event = Event(
          type: EventType.locationShared,
          cid: 'test-channel:123',
          message: Message(
            id: 'message-123',
            sharedLocation: location,
          ),
        );

        // Trigger the event
        client.handleEvent(event);

        // Wait for the event to get processed
        await Future.delayed(Duration.zero);

        // Should not add location from other user
        expect(client.state.activeLiveLocations, isEmpty);
      });

      test('should ignore static location events', () async {
        final staticLocation = Location(
          channelCid: 'test-channel:123',
          messageId: 'message-123',
          userId: userId,
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device-1',
          // No endAt means it's static
        );

        final event = Event(
          type: EventType.locationShared,
          cid: 'test-channel:123',
          message: Message(
            id: 'message-123',
            sharedLocation: staticLocation,
          ),
        );

        // Trigger the event
        client.handleEvent(event);

        // Wait for the event to get processed
        await Future.delayed(Duration.zero);

        // Should not add static location
        expect(client.state.activeLiveLocations, isEmpty);
      });

      test('should merge locations with same key', () async {
        final location1 = Location(
          channelCid: 'test-channel:123',
          messageId: 'message-123',
          userId: userId,
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device-1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final location2 = Location(
          channelCid: 'test-channel:123',
          messageId: 'message-456',
          userId: userId,
          latitude: 40.7500,
          longitude: -74.1000,
          createdByDeviceId: 'device-1', // Same device, should merge
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final event1 = Event(
          type: EventType.locationShared,
          cid: 'test-channel:123',
          message: Message(
            id: 'message-123',
            sharedLocation: location1,
          ),
        );

        final event2 = Event(
          type: EventType.locationShared,
          cid: 'test-channel:123',
          message: Message(
            id: 'message-456',
            sharedLocation: location2,
          ),
        );

        // Trigger first event
        client.handleEvent(event1);
        await Future.delayed(Duration.zero);

        final activeLiveLocations = client.state.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations.first.messageId, equals('message-123'));

        // Trigger second event - should merge/update
        client.handleEvent(event2);
        await Future.delayed(Duration.zero);

        final activeLiveLocations2 = client.state.activeLiveLocations;
        expect(activeLiveLocations2, hasLength(1));
        expect(activeLiveLocations2.first.messageId, equals('message-456'));
      });
    });

    test('`.sendEvent`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      final event = Event(type: EventType.any);

      when(
        () => fakeChatApi.channel.sendEvent(
          channelId,
          channelType,
          any(that: isSameEventAs(event)),
        ),
      ).thenAnswer((_) async => EmptyResponse());

      final res = await client.sendEvent(channelId, channelType, event);
      expect(res, isNotNull);

      verify(
        () => fakeChatApi.channel.sendEvent(
          channelId,
          channelType,
          any(that: isSameEventAs(event)),
        ),
      ).called(1);
      verifyNoMoreInteractions(fakeChatApi.channel);
    });

    test('`.sendReaction`', () async {
      const messageId = 'test-message-id';
      const reactionType = 'like';
      const emojiCode = '👍';
      const score = 4;

      final reaction = Reaction(
        type: reactionType,
        messageId: messageId,
        emojiCode: emojiCode,
        score: score,
      );

      when(() => fakeChatApi.message.sendReaction(messageId, reaction)).thenAnswer(
        (_) async => SendReactionResponse()
          ..message = Message(id: messageId)
          ..reaction = reaction,
      );

      final res = await client.sendReaction(messageId, reaction);
      expect(res, isNotNull);
      expect(res.message.id, messageId);
      expect(res.reaction.type, reactionType);
      expect(res.reaction.emojiCode, emojiCode);
      expect(res.reaction.score, score);
      expect(res.reaction.messageId, messageId);

      verify(() => fakeChatApi.message.sendReaction(messageId, reaction)).called(1);
      verifyNoMoreInteractions(fakeChatApi.message);
    });

    test('`.deleteReaction`', () async {
      const messageId = 'test-message-id';
      const reactionType = 'like';

      when(() => fakeChatApi.message.deleteReaction(messageId, reactionType)).thenAnswer((_) async => EmptyResponse());

      final res = await client.deleteReaction(messageId, reactionType);
      expect(res, isNotNull);

      verify(
        () => fakeChatApi.message.deleteReaction(messageId, reactionType),
      ).called(1);
      verifyNoMoreInteractions(fakeChatApi.message);
    });

    test('`.sendMessage`', () async {
      final message = Message(id: 'test-message-id');
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';

      when(
        () => fakeChatApi.message.sendMessage(channelId, channelType, any(that: isSameMessageAs(message))),
      ).thenAnswer((_) async => SendMessageResponse()..message = message);

      final res = await client.sendMessage(message, channelId, channelType);
      expect(res, isNotNull);
      expect(res.message, isSameMessageAs(message));

      verify(
        () => fakeChatApi.message.sendMessage(
          channelId,
          channelType,
          any(that: isSameMessageAs(message)),
        ),
      ).called(1);
      verifyNoMoreInteractions(fakeChatApi.message);
    });

    test('`.getReplies`', () async {
      const parentId = 'test-parent-id';

      final messages = List.generate(
        3,
        (index) => Message(id: 'test-message-id-$index'),
      );

      when(
        () => fakeChatApi.message.getReplies(parentId),
      ).thenAnswer((_) async => QueryRepliesResponse()..messages = messages);

      final res = await client.getReplies(parentId);
      expect(res, isNotNull);
      expect(res.messages.length, messages.length);

      verify(() => fakeChatApi.message.getReplies(parentId)).called(1);
      verifyNoMoreInteractions(fakeChatApi.message);
    });

    test('`.getReactions`', () async {
      const messageId = 'test-parent-id';

      final reactions = List.generate(
        3,
        (index) => Reaction(
          type: 'test-reactions-type-$index',
          messageId: messageId,
        ),
      );

      when(
        () => fakeChatApi.message.getReactions(messageId),
      ).thenAnswer((_) async => QueryReactionsResponse()..reactions = reactions);

      final res = await client.getReactions(messageId);
      expect(res, isNotNull);
      expect(res.reactions.length, reactions.length);
      expect(res.reactions.every((it) => it.messageId == messageId), isTrue);

      verify(() => fakeChatApi.message.getReactions(messageId)).called(1);
      verifyNoMoreInteractions(fakeChatApi.message);
    });

    test('`.queryReactions`', () async {
      const messageId = 'test-message-id';

      final reactions = List.generate(
        3,
        (index) => Reaction(
          type: 'test-reactions-type-$index',
          messageId: messageId,
        ),
      );

      when(
        () => fakeChatApi.message.queryReactions(messageId),
      ).thenAnswer(
        (_) async => QueryReactionsResponse()
          ..reactions = reactions
          ..next = null,
      );

      final res = await client.queryReactions(messageId);
      expect(res, isNotNull);
      expect(res.reactions.length, reactions.length);
      expect(res.reactions.every((it) => it.messageId == messageId), isTrue);

      verify(() => fakeChatApi.message.queryReactions(messageId)).called(1);
      verifyNoMoreInteractions(fakeChatApi.message);
    });

    test('`.updateMessage`', () async {
      final message = Message(id: 'test-message-id', text: 'Hello!');

      when(
        () => fakeChatApi.message.updateMessage(any(that: isSameMessageAs(message))),
      ).thenAnswer((_) async => UpdateMessageResponse()..message = message);

      final res = await client.updateMessage(message);
      expect(res, isNotNull);
      expect(res.message, isSameMessageAs(message));

      verify(
        () => fakeChatApi.message.updateMessage(any(that: isSameMessageAs(message))),
      ).called(1);
      verifyNoMoreInteractions(fakeChatApi.message);
    });

    test('`.deleteMessage`', () async {
      const messageId = 'test-message-id';

      when(() => fakeChatApi.message.deleteMessage(messageId, hard: false)).thenAnswer((_) async => EmptyResponse());

      final res = await client.deleteMessage(messageId);
      expect(res, isNotNull);

      verify(() => fakeChatApi.message.deleteMessage(messageId, hard: false)).called(1);
      verifyNoMoreInteractions(fakeChatApi.message);
    });

    test('`.deleteMessageForMe`', () async {
      const messageId = 'test-message-id';

      when(
        () => fakeChatApi.message.deleteMessage(messageId, deleteForMe: true),
      ).thenAnswer((_) async => EmptyResponse());

      final res = await client.deleteMessageForMe(messageId);
      expect(res, isNotNull);

      verify(() => fakeChatApi.message.deleteMessage(messageId, deleteForMe: true)).called(1);
      verifyNoMoreInteractions(fakeChatApi.message);
    });

    test('`.getMessage`', () async {
      const messageId = 'test-message-id';
      final message = Message(id: messageId);

      when(
        () => fakeChatApi.message.getMessage(messageId),
      ).thenAnswer((_) async => GetMessageResponse()..message = message);

      final res = await client.getMessage(messageId);
      expect(res, isNotNull);
      expect(res.message.id, messageId);

      verify(() => fakeChatApi.message.getMessage(messageId)).called(1);
      verifyNoMoreInteractions(fakeChatApi.message);
    });

    test('`.getMessagesById`', () async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      const messageIds = ['test-message-id'];

      final messages = messageIds.map((id) => Message(id: id)).toList();

      when(
        () => fakeChatApi.message.getMessagesById(channelId, channelType, messageIds),
      ).thenAnswer((_) async => GetMessagesByIdResponse()..messages = messages);

      final res = await client.getMessagesById(
        channelId,
        channelType,
        messageIds,
      );
      expect(res, isNotNull);
      expect(res.messages.length, messageIds.length);

      verify(
        () => fakeChatApi.message.getMessagesById(channelId, channelType, messageIds),
      ).called(1);
      verifyNoMoreInteractions(fakeChatApi.message);
    });

    test('`.translateMessage`', () async {
      const messageId = 'test-message-id';
      const language = 'hi'; // Hindi
      const translatedMessageText = 'नमस्ते';
      final translatedMessage = Message(
        i18n: const {
          language: translatedMessageText,
        },
      );

      when(() => fakeChatApi.message.translateMessage(messageId, language)).thenAnswer(
        (_) async => TranslateMessageResponse()..message = translatedMessage,
      );

      final res = await client.translateMessage(messageId, language);

      expect(res, isNotNull);
      expect(res.message.i18n, translatedMessage.i18n);

      verify(() => fakeChatApi.message.translateMessage(messageId, language)).called(1);
      verifyNoMoreInteractions(fakeChatApi.message);
    });

    test('`.partialUpdateMessage`', () async {
      const messageId = 'test-message-id';
      final message = Message(id: messageId);

      const set = {'text': 'Update Message text'};
      const unset = ['pinExpires'];

      final updateMessageResponse = UpdateMessageResponse()
        ..message = message.copyWith(text: set['text'], pinExpires: null);

      when(
        () => fakeChatApi.message.partialUpdateMessage(
          message.id,
          set: set,
          unset: unset,
        ),
      ).thenAnswer((_) async => updateMessageResponse);

      final res = await client.partialUpdateMessage(
        messageId,
        set: set,
        unset: unset,
      );

      expect(res, isNotNull);
      expect(res.message.id, message.id);
      expect(res.message.id, message.id);
      expect(res.message.text, set['text']);
      expect(res.message.pinExpires, isNull);

      verify(
        () => fakeChatApi.message.partialUpdateMessage(
          message.id,
          set: set,
          unset: unset,
        ),
      ).called(1);
      verifyNoMoreInteractions(fakeChatApi.message);
    });

    group('`.pinMessage`', () {
      test('should work fine without passing timeoutOrExpirationDate', () async {
        const messageId = 'test-message-id';
        final message = Message(id: messageId);

        when(
          () => fakeChatApi.message.partialUpdateMessage(
            messageId,
            set: any(named: 'set'),
            unset: any(named: 'unset'),
          ),
        ).thenAnswer(
          (_) async => UpdateMessageResponse()
            ..message = message.copyWith(
              pinned: true,
              pinExpires: null,
              state: MessageState.sent,
            ),
        );

        final res = await client.pinMessage(messageId);

        expect(res, isNotNull);
        expect(res.message.pinned, isTrue);
        expect(res.message.pinExpires, isNull);

        verify(
          () => fakeChatApi.message.partialUpdateMessage(
            messageId,
            set: any(named: 'set'),
            unset: any(named: 'unset'),
          ),
        ).called(1);
        verifyNoMoreInteractions(fakeChatApi.message);
      });

      test(
        'should work fine if passed timeoutOrExpirationDate as num(seconds)',
        () async {
          const messageId = 'test-message-id';
          final message = Message(id: messageId);
          const timeoutOrExpirationDate = 300; // 300 seconds

          when(
            () => fakeChatApi.message.partialUpdateMessage(
              message.id,
              set: any(named: 'set'),
              unset: any(named: 'unset'),
            ),
          ).thenAnswer(
            (_) async => UpdateMessageResponse()
              ..message = message.copyWith(
                pinned: true,
                pinExpires: DateTime.now().add(
                  const Duration(seconds: timeoutOrExpirationDate),
                ),
                state: MessageState.sent,
              ),
          );

          final res = await client.pinMessage(
            messageId,
            timeoutOrExpirationDate: timeoutOrExpirationDate,
          );

          expect(res, isNotNull);
          expect(res.message.pinned, isTrue);
          expect(res.message.pinExpires, isNotNull);

          verify(
            () => fakeChatApi.message.partialUpdateMessage(
              messageId,
              set: any(named: 'set'),
              unset: any(named: 'unset'),
            ),
          ).called(1);
          verifyNoMoreInteractions(fakeChatApi.message);
        },
      );

      test(
        'should work fine if passed timeoutOrExpirationDate as DateTime',
        () async {
          const messageId = 'test-message-id';
          final message = Message(id: messageId);
          final timeoutOrExpirationDate = DateTime.now().add(const Duration(days: 3)); // 3 days

          when(
            () => fakeChatApi.message.partialUpdateMessage(
              messageId,
              set: any(named: 'set'),
              unset: any(named: 'unset'),
            ),
          ).thenAnswer(
            (_) async => UpdateMessageResponse()
              ..message = message.copyWith(
                pinned: true,
                pinExpires: timeoutOrExpirationDate,
                state: MessageState.sent,
              ),
          );

          final res = await client.pinMessage(
            messageId,
            timeoutOrExpirationDate: timeoutOrExpirationDate,
          );

          expect(res, isNotNull);
          expect(res.message.pinned, isTrue);
          expect(res.message.pinExpires, isNotNull);
          expect(res.message.pinExpires, timeoutOrExpirationDate.toUtc());

          verify(
            () => fakeChatApi.message.partialUpdateMessage(
              messageId,
              set: any(named: 'set'),
              unset: any(named: 'unset'),
            ),
          ).called(1);
          verifyNoMoreInteractions(fakeChatApi.message);
        },
      );

      test(
        'should throw if invalid timeoutOrExpirationDate is passed',
        () async {
          const messageId = 'test-message-id';
          const timeoutOrExpirationDate = 'invalid-value';

          // `pinMessage` validates in an `assert` before its first `await`,
          // so it throws synchronously and the call must stay in a closure.
          await expectLater(
            () => client.pinMessage(
              messageId,
              timeoutOrExpirationDate: timeoutOrExpirationDate,
            ),
            throwsA(isA<ArgumentError>()),
          );
        },
      );
    });

    test('`.unpinMessage`', () async {
      const messageId = 'test-message-id';
      final message = Message(id: messageId, pinned: true);

      when(
        () => fakeChatApi.message.partialUpdateMessage(
          messageId,
          set: {'pinned': false},
        ),
      ).thenAnswer(
        (_) async => UpdateMessageResponse()
          ..message = message.copyWith(
            pinned: false,
            state: MessageState.sent,
          ),
      );

      final res = await client.unpinMessage(messageId);

      expect(res, isNotNull);
      expect(res.message.pinned, isFalse);

      verify(
        () => fakeChatApi.message.partialUpdateMessage(
          messageId,
          set: {'pinned': false},
        ),
      ).called(1);
      verifyNoMoreInteractions(fakeChatApi.message);
    });

    test('StreamChatClient.enrichUrl sends the url and returns the scraped metadata', () async {
      const url = 'https://getstream.io/chat';

      when(() => defaultApi.getOG(url: url)).thenAnswer(
        (_) async => const Result.success(
          api.GetOGResponse(
            duration: '0.01ms',
            custom: {},
            ogScrapeUrl: 'https://getstream.io/chat/',
            assetUrl: 'https://getstream.io/chat/intro.mp4',
            authorLink: 'https://getstream.io',
            authorName: 'Stream',
            imageUrl: 'https://getstream.io/chat/og.png',
            text: 'Build real-time chat in less time.',
            thumbUrl: 'https://getstream.io/chat/og-thumb.png',
            title: 'Chat API & SDKs',
            titleLink: 'https://getstream.io/chat/?utm_source=og',
            type: 'video',
          ),
        ),
      );

      final res = await client.enrichUrl(url);
      expect(
        res.getOrNull(),
        const OGAttachmentResponse(
          duration: '0.01ms',
          ogScrapeUrl: 'https://getstream.io/chat/',
          assetUrl: 'https://getstream.io/chat/intro.mp4',
          authorLink: 'https://getstream.io',
          authorName: 'Stream',
          imageUrl: 'https://getstream.io/chat/og.png',
          text: 'Build real-time chat in less time.',
          thumbUrl: 'https://getstream.io/chat/og-thumb.png',
          title: 'Chat API & SDKs',
          titleLink: 'https://getstream.io/chat/?utm_source=og',
          type: 'video',
        ),
      );

      verify(() => defaultApi.getOG(url: url)).called(1);
      verifyNoMoreInteractions(defaultApi);
    });

    test('StreamChatClient.enrichUrl falls back to the requested url when the response has no scraped url', () async {
      const url = 'https://getstream.io/chat/';
      when(() => defaultApi.getOG(url: url)).thenAnswer(
        (_) async => const Result.success(api.GetOGResponse(duration: '0.01ms', custom: {}, title: 'Chat API & SDKs')),
      );

      final res = await client.enrichUrl(url);

      expect(res.getOrNull()?.ogScrapeUrl, url);
    });

    test('StreamChatClient.enrichUrl returns the failure without throwing', () async {
      const url = 'https://unreachable.example';
      const error = StreamApiException(
        code: StreamErrorCode.inputError,
        message: 'could not find any opengraph data for the given URL',
        statusCode: 400,
      );
      when(() => defaultApi.getOG(url: url)).thenAnswer((_) async => const Result.failure(error));

      final res = await client.enrichUrl(url);

      expect(res.exceptionOrNull(), error);
    });

    test(
      '''setting the `currentUser` should also compute and update the unreadCounts''',
      () {
        final state = client.state;
        final initialUser = OwnUser.fromUser(user);

        expect(state.currentUser, initialUser);
        expect(state.totalUnreadCount, 0);
        expect(state.unreadChannels, 0);

        final updateUser = initialUser.copyWith(
          totalUnreadCount: 33,
          unreadChannels: 33,
        );
        state.currentUser = updateUser;

        expect(state.currentUser, updateUser);
        expect(state.totalUnreadCount, 33);
        expect(state.unreadChannels, 33);
      },
    );
  });

  group('PersistenceConnectionTests', () {
    const apiKey = 'test-api-key';
    late final fakeChatApi = FakeChatApi();

    final user = User(id: 'test-user-id');
    final token = testUserToken(user.id).rawValue;

    late StreamChatClient client;

    setUp(() async {
      final ws = FakeChatServer();
      client = StreamChatClient(apiKey, defaultApi: FakeDefaultApi(), chatApi: fakeChatApi, wsProvider: ws.connect);
      expect(client.persistenceEnabled, isFalse);
    });

    tearDown(() async {
      client.chatPersistenceClient = null;
      expect(client.persistenceEnabled, isFalse);
      await client.dispose();
    });

    test('openPersistenceConnection connects the client to the user', () async {
      client.chatPersistenceClient = MockPersistenceClient();
      await client.openPersistenceConnection(user);
      expect(client.persistenceEnabled, isTrue);
    });

    test(
      '''multiple call to openPersistenceConnection does not throws an error if already connected to the same user''',
      () async {
        client.chatPersistenceClient = MockPersistenceClient();
        await client.openPersistenceConnection(user);
        expect(client.persistenceEnabled, isTrue);

        await expectLater(client.openPersistenceConnection(user), completes);
        await expectLater(client.openPersistenceConnection(user), completes);
        await expectLater(client.openPersistenceConnection(user), completes);
      },
    );

    test(
      '''openPersistenceConnection throws an error if client is already connected to a different user''',
      () async {
        client.chatPersistenceClient = MockPersistenceClient();
        await client.openPersistenceConnection(user);
        expect(client.persistenceEnabled, isTrue);

        await expectLater(
          client.openPersistenceConnection(user.copyWith(id: 'new-id')),
          throwsA(isA<StateError>()),
        );
      },
    );

    test(
      '''openPersistenceConnection throws an error if chatPersistenceClient is not set''',
      () async {
        await expectLater(
          client.openPersistenceConnection(user),
          throwsA(isA<StateError>()),
        );
      },
    );

    test('closePersistenceConnection disconnects the client', () async {
      client.chatPersistenceClient = MockPersistenceClient();
      await client.openPersistenceConnection(user);
      expect(client.persistenceEnabled, isTrue);

      await client.closePersistenceConnection();
      expect(client.persistenceEnabled, isFalse);
    });

    test(
      '''closePersistenceConnection compeletes normally if chatPersistenceClient is not connected''',
      () async {
        client.chatPersistenceClient = MockPersistenceClient();
        expect(client.chatPersistenceClient!.isConnected, isFalse);

        await expectLater(client.closePersistenceConnection(), completes);
      },
    );

    test(
      '''closePersistenceConnection completes normally if chatPersistenceClient is not set''',
      () async {
        expect(client.persistenceEnabled, isFalse);
        await expectLater(client.closePersistenceConnection(), completes);
      },
    );

    test(
      '''connectUser completes normally if the persistence connection is already connected to the same user''',
      () async {
        client.chatPersistenceClient = MockPersistenceClient();
        await client.openPersistenceConnection(user);
        expect(client.persistenceEnabled, isTrue);

        await expectLater(
          client.connectUser(user, token, connectWebSocket: false),
          completes,
        );
      },
    );

    test(
      '''connectUser should throw if the persistence connection if already connected to a different user''',
      () async {
        client.chatPersistenceClient = MockPersistenceClient();
        await client.openPersistenceConnection(user.copyWith(id: 'new-id'));
        expect(client.persistenceEnabled, isTrue);

        await expectLater(
          client.connectUser(user, token, connectWebSocket: false),
          throwsA(isA<StateError>()),
        );
      },
    );

    group('Sync Method Tests', () {
      setUpAll(() {
        registerFallbackValue(const PaginationParams());
        registerFallbackValue(ChannelFilter.equal(ChannelFilterField.cid, ''));
      });

      test(
        'should retrieve data from persistence client and sync successfully',
        () async {
          final cids = ['channel1', 'channel2'];
          final lastSyncAt = DateTime.now().subtract(const Duration(hours: 1));
          final fakeClient = FakePersistenceClient(
            channelCids: cids,
            lastSyncAt: lastSyncAt,
          );

          client.chatPersistenceClient = fakeClient;
          when(() => fakeChatApi.general.sync(cids, lastSyncAt)).thenAnswer(
            (_) async => SyncResponse()..events = [],
          );

          await client.sync();

          verify(() => fakeChatApi.general.sync(cids, lastSyncAt)).called(1);

          final newLastSyncAt = await fakeClient.getLastSyncAt();
          expect(newLastSyncAt?.isAfter(lastSyncAt), isTrue);
        },
      );

      test('should set lastSyncAt on first sync when null', () async {
        final fakeClient = FakePersistenceClient(
          channelCids: ['channel1'],
          lastSyncAt: null,
        );

        client.chatPersistenceClient = fakeClient;

        await client.sync();

        expectLater(fakeClient.getLastSyncAt(), completion(isNotNull));
        verifyNever(() => fakeChatApi.general.sync(any(), any()));
      });

      test('should flush persistence client on 400 error', () async {
        final cids = ['channel1'];
        final lastSyncAt = DateTime.now().subtract(const Duration(hours: 1));
        final fakeClient = FakePersistenceClient(
          channelCids: cids,
          lastSyncAt: lastSyncAt,
        );

        client.chatPersistenceClient = fakeClient;
        // What `/sync` answers when `lastSyncAt` is too old, or the channel
        // list or event count is oversized.
        when(() => fakeChatApi.general.sync(cids, lastSyncAt)).thenThrow(
          apiException(
            code: StreamErrorCode.inputError,
            statusCode: 400,
            message: 'Too many events',
          ),
        );

        await client.sync();

        expect(await fakeClient.getChannelCids(), isEmpty); // Should be flushed

        verify(() => fakeChatApi.general.sync(cids, lastSyncAt)).called(1);
      });

      test(
        '''should replay events and advance lastSyncAt when the payload is within the replay limit''',
        () async {
          final cids = ['channel1'];
          final lastSyncAt = DateTime.now().subtract(const Duration(hours: 1));
          final fakeClient = FakePersistenceClient(
            channelCids: cids,
            lastSyncAt: lastSyncAt,
          );

          client.chatPersistenceClient = fakeClient;
          final events = List.generate(
            10,
            (index) => Event(
              type: EventType.messageNew,
              cid: 'channel1',
              message: Message(id: 'message-$index'),
              createdAt: lastSyncAt.add(Duration(seconds: index + 1)),
            ),
          );
          when(() => fakeChatApi.general.sync(cids, lastSyncAt)).thenAnswer(
            (_) async => SyncResponse()..events = events,
          );

          final replayed = <Event>[];
          final sub = client.on(EventType.messageNew).listen(replayed.add);
          addTearDown(sub.cancel);

          await client.sync();
          await pumpEventQueue();

          verify(() => fakeChatApi.general.sync(cids, lastSyncAt)).called(1);
          // Within the limit, every event is replayed through the event handler.
          expect(replayed, hasLength(events.length));
          // lastSyncAt advances to the newest replayed event date.
          expect(await fakeClient.getLastSyncAt(), events.last.createdAt);
        },
      );

      test(
        '''should refresh the synced channels in place of a payload that exceeds the replay limit''',
        () async {
          final cids = ['channel1'];
          final lastSyncAt = DateTime.now().subtract(const Duration(hours: 1));
          final fakeClient = FakePersistenceClient(
            channelCids: cids,
            lastSyncAt: lastSyncAt,
          );

          client.chatPersistenceClient = fakeClient;
          // 251 events exceeds the internal replay limit of 250.
          final events = List.generate(
            251,
            (index) => Event(
              type: EventType.messageNew,
              cid: 'channel1',
              message: Message(id: 'message-$index'),
              createdAt: lastSyncAt.add(Duration(seconds: index + 1)),
            ),
          );
          when(() => fakeChatApi.general.sync(cids, lastSyncAt)).thenAnswer(
            (_) async => SyncResponse()..events = events,
          );

          when(
            () => fakeChatApi.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            ),
          ).thenAnswer((_) async => QueryChannelsResponse()..channels = []);

          final replayed = <Event>[];
          final sub = client.on(EventType.messageNew).listen(replayed.add);
          addTearDown(sub.cancel);

          // The group shares one api mock, so only count this test's calls.
          clearInteractions(fakeChatApi.channel);

          await client.sync();
          await pumpEventQueue();

          verify(() => fakeChatApi.general.sync(cids, lastSyncAt)).called(1);
          // Replay is skipped; no events are dispatched through the handler.
          expect(replayed, isEmpty);
          // The channels the payload covered are refreshed in its place.
          verify(
            () => fakeChatApi.channel.queryChannels(
              filter: any(named: 'filter', that: isSameFilterAs(ChannelFilter.in_(ChannelFilterField.cid, cids))),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: const PaginationParams(limit: 1),
            ),
          ).called(1);
          // lastSyncAt moves to the newest event in the skipped payload, so
          // that payload is not re-fetched while anything after it still is.
          expect(await fakeClient.getLastSyncAt(), events.last.createdAt);
        },
      );
    });
  });

  group('recoverStateOnReconnect', () {
    const apiKey = 'test-api-key';
    final user = User(id: 'test-user-id');
    final token = testUserToken(user.id).rawValue;

    late FakeChatApi fakeChatApi;
    late FakeChatServer ws;
    late StreamChatClient client;

    setUpAll(() {
      registerFallbackValue(const PaginationParams());
      registerFallbackValue(ChannelFilter.equal(ChannelFilterField.cid, ''));
    });

    setUp(() {
      fakeChatApi = FakeChatApi();
      ws = FakeChatServer();

      // Stub queryChannels for every test — it's the API the recovery path
      // calls when enabled, and a missing stub would surface as an unhandled
      // async error inside the connection-status listener.
      when(
        () => fakeChatApi.channel.queryChannels(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).thenAnswer((_) async => QueryChannelsResponse()..channels = []);
    });

    tearDown(() async {
      await client.dispose();
    });

    // Drives the FakeWebSocket through a connected → disconnected → connected
    // transition so the client's pairwise listener fires the recovery path.
    Future<void> simulateReconnect() async {
      ws.drop();
      await delay(100);
      await client.openConnection();
      await delay(300);
    }

    // Recovery asks about channels most recently active first, so every fixture
    // pins its own recency rather than inheriting the moment it was built.
    // Both dates are set so `lastUpdatedAt` lands on [lastActiveAt] either way.
    Channel channelActiveAt(String cid, DateTime lastActiveAt) {
      final channel = ChannelModel(cid: cid, createdAt: lastActiveAt, lastMessageAt: lastActiveAt);
      return Channel.fromState(client, ChannelState(channel: channel));
    }

    test('should re-query active channels on reconnect when enabled (default)', () async {
      // Setup: connect with default flag, register two channels.
      client = StreamChatClient(apiKey, defaultApi: FakeDefaultApi(), chatApi: fakeChatApi, wsProvider: ws.connect);
      await client.connectUser(user, token);
      await delay(300);

      final now = DateTime.now();
      client.state.addChannels({
        'messaging:c1': channelActiveAt('messaging:c1', now),
        'messaging:c2': channelActiveAt('messaging:c2', now.subtract(const Duration(minutes: 1))),
      });

      // Drop interactions from the initial connect's (empty-channel) recovery
      // so we only count the reconnect call.
      clearInteractions(fakeChatApi.channel);

      await simulateReconnect();

      // The re-query asks for exactly the channels it lists, a page at a time.
      verify(
        () => fakeChatApi.channel.queryChannels(
          filter: any(
            named: 'filter',
            that: isSameFilterAs(ChannelFilter.in_(ChannelFilterField.cid, const ['messaging:c1', 'messaging:c2'])),
          ),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: const PaginationParams(limit: 2),
        ),
      ).called(1);
    });

    test('should skip the re-query on reconnect when disabled', () async {
      client = StreamChatClient(
        apiKey,
        defaultApi: FakeDefaultApi(),
        chatApi: fakeChatApi,
        wsProvider: ws.connect,
        recoverStateOnReconnect: false,
      );
      await client.connectUser(user, token);
      await delay(300);

      final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: 'messaging:c1')));
      client.state.addChannels({'messaging:c1': channel});
      clearInteractions(fakeChatApi.channel);

      await simulateReconnect();

      verifyNever(
        () => fakeChatApi.channel.queryChannels(
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
    });

    test('should still emit `connectionRecovered` when disabled', () async {
      client = StreamChatClient(
        apiKey,
        defaultApi: FakeDefaultApi(),
        chatApi: fakeChatApi,
        wsProvider: ws.connect,
        recoverStateOnReconnect: false,
      );
      await client.connectUser(user, token);
      await delay(300);

      final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: 'messaging:c1')));
      client.state.addChannels({'messaging:c1': channel});

      // Subscribe AFTER the initial connect so the captured event is the
      // one fired by the manual reconnect.
      final recoveredEvents = <Event>[];
      final sub = client.on(EventType.connectionRecovered).listen(recoveredEvents.add);

      await simulateReconnect();
      await sub.cancel();

      expect(recoveredEvents, hasLength(1));
    });

    // Recovery runs inside the client's own connection-status listener, so a
    // failure there has no future for the app to catch. It must be swallowed,
    // and must not stop `connectionRecovered` from firing.
    test('should not surface an error when the re-query fails', () async {
      when(
        () => fakeChatApi.channel.queryChannels(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).thenThrow(StateError('queryChannels needs an active connection. Call `connectUser` first.'));

      client = StreamChatClient(apiKey, defaultApi: FakeDefaultApi(), chatApi: fakeChatApi, wsProvider: ws.connect);
      await client.connectUser(user, token);
      await delay(300);

      final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: 'messaging:c1')));
      client.state.addChannels({'messaging:c1': channel});

      // Subscribe AFTER the initial connect so the captured event is the
      // one fired by the manual reconnect.
      final recoveredEvents = <Event>[];
      final sub = client.on(EventType.connectionRecovered).listen(recoveredEvents.add);

      await simulateReconnect();
      await sub.cancel();

      expect(recoveredEvents, hasLength(1));
    });

    test('should skip the re-query when no active channels are tracked', () async {
      client = StreamChatClient(apiKey, defaultApi: FakeDefaultApi(), chatApi: fakeChatApi, wsProvider: ws.connect);
      await client.connectUser(user, token);
      await delay(300);

      // No channels added — the cids.isNotEmpty guard should short-circuit.
      clearInteractions(fakeChatApi.channel);

      await simulateReconnect();

      verifyNever(
        () => fakeChatApi.channel.queryChannels(
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
    });

    // Skipping event replay leaves the state of the synced channels behind, so
    // the skip refreshes them itself, whatever this flag is set to.
    test('should re-query active channels when the sync skipped event replay', () async {
      client = StreamChatClient(
        apiKey,
        defaultApi: FakeDefaultApi(),
        chatApi: fakeChatApi,
        wsProvider: ws.connect,
        recoverStateOnReconnect: false,
      );
      await client.connectUser(user, token);
      await delay(300);

      const cid = 'messaging:c1';
      final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: cid)));
      client.state.addChannels({cid: channel});

      final lastSyncAt = DateTime.now().subtract(const Duration(hours: 1));
      final persistenceClient = FakePersistenceClient(channelCids: const [cid], lastSyncAt: lastSyncAt);
      client.chatPersistenceClient = persistenceClient;
      await client.openPersistenceConnection(user);
      addTearDown(() => client.chatPersistenceClient = null);

      // 251 events exceeds the internal replay limit of 250.
      final events = List.generate(
        251,
        (index) => Event(
          type: EventType.messageNew,
          cid: cid,
          message: Message(id: 'message-$index'),
          createdAt: lastSyncAt.add(Duration(seconds: index + 1)),
        ),
      );
      when(() => fakeChatApi.general.sync(const [cid], lastSyncAt)).thenAnswer(
        (_) async => SyncResponse()..events = events,
      );

      clearInteractions(fakeChatApi.channel);

      await simulateReconnect();

      verify(
        () => fakeChatApi.channel.queryChannels(
          filter: any(named: 'filter', that: isSameFilterAs(ChannelFilter.in_(ChannelFilterField.cid, const [cid]))),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: const PaginationParams(limit: 1),
        ),
      ).called(1);

      // The pointer lands on the newest event in the skipped payload, not on
      // the wall clock, so anything after it is still fetched next time.
      expect(await persistenceClient.getLastSyncAt(), events.last.createdAt);
    });

    // A failed sync applied nothing and moved nothing, so the configured
    // recovery still runs and the window stays outstanding for the next sync.
    test('should re-query active channels when the sync fails, keeping lastSyncAt', () async {
      client = StreamChatClient(apiKey, defaultApi: FakeDefaultApi(), chatApi: fakeChatApi, wsProvider: ws.connect);
      await client.connectUser(user, token);
      await delay(300);

      const cid = 'messaging:c1';
      final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: cid)));
      client.state.addChannels({cid: channel});

      final lastSyncAt = DateTime.now().subtract(const Duration(hours: 1));
      final persistenceClient = FakePersistenceClient(channelCids: const [cid], lastSyncAt: lastSyncAt);
      client.chatPersistenceClient = persistenceClient;
      await client.openPersistenceConnection(user);
      addTearDown(() => client.chatPersistenceClient = null);

      when(() => fakeChatApi.general.sync(const [cid], lastSyncAt)).thenThrow(
        const StreamApiException(
          code: StreamErrorCode.internalError,
          message: 'Something goes wrong in the system',
          statusCode: 500,
        ),
      );

      clearInteractions(fakeChatApi.channel);

      await simulateReconnect();

      verify(
        () => fakeChatApi.channel.queryChannels(
          filter: any(named: 'filter', that: isSameFilterAs(ChannelFilter.in_(ChannelFilterField.cid, const [cid]))),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: const PaginationParams(limit: 1),
        ),
      ).called(1);

      expect(await persistenceClient.getLastSyncAt(), lastSyncAt);
    });

    // Discarding the payload is only safe once its state has been re-fetched,
    // so a failed refresh keeps the checkpoint and the range is asked for again.
    test('should keep lastSyncAt when the refresh after a skipped replay fails', () async {
      when(
        () => fakeChatApi.channel.queryChannels(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).thenThrow(StateError('queryChannels needs an active connection. Call `connectUser` first.'));

      client = StreamChatClient(
        apiKey,
        defaultApi: FakeDefaultApi(),
        chatApi: fakeChatApi,
        wsProvider: ws.connect,
        recoverStateOnReconnect: false,
      );
      await client.connectUser(user, token);
      await delay(300);

      const cid = 'messaging:c1';
      final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: cid)));
      client.state.addChannels({cid: channel});

      final lastSyncAt = DateTime.now().subtract(const Duration(hours: 1));
      final persistenceClient = FakePersistenceClient(channelCids: const [cid], lastSyncAt: lastSyncAt);
      client.chatPersistenceClient = persistenceClient;
      await client.openPersistenceConnection(user);
      addTearDown(() => client.chatPersistenceClient = null);

      // 251 events exceeds the internal replay limit of 250.
      final events = List.generate(
        251,
        (index) => Event(
          type: EventType.messageNew,
          cid: cid,
          message: Message(id: 'message-$index'),
          createdAt: lastSyncAt.add(Duration(seconds: index + 1)),
        ),
      );
      when(() => fakeChatApi.general.sync(const [cid], lastSyncAt)).thenAnswer(
        (_) async => SyncResponse()..events = events,
      );

      await simulateReconnect();

      expect(await persistenceClient.getLastSyncAt(), lastSyncAt);
    });

    test('should re-query in batches when more channels are active than fit in one page', () async {
      client = StreamChatClient(
        apiKey,
        defaultApi: FakeDefaultApi(),
        chatApi: fakeChatApi,
        wsProvider: ws.connect,
        recoverStateOnReconnect: false,
      );
      await client.connectUser(user, token);
      await delay(300);

      // 31 channels spill over the 30-channel page size into a second request.
      // Listed most recently active first, which is the order recovery uses.
      final now = DateTime.now();
      final cids = List.generate(31, (index) => 'messaging:c$index');
      client.state.addChannels({
        for (final (index, cid) in cids.indexed) cid: channelActiveAt(cid, now.subtract(Duration(minutes: index))),
      });

      final lastSyncAt = DateTime.now().subtract(const Duration(hours: 1));
      client.chatPersistenceClient = FakePersistenceClient(channelCids: cids, lastSyncAt: lastSyncAt);
      await client.openPersistenceConnection(user);
      addTearDown(() => client.chatPersistenceClient = null);

      final events = List.generate(
        251,
        (index) => Event(
          type: EventType.messageNew,
          cid: cids.first,
          message: Message(id: 'message-$index'),
          createdAt: lastSyncAt.add(Duration(seconds: index + 1)),
        ),
      );
      when(() => fakeChatApi.general.sync(cids, lastSyncAt)).thenAnswer(
        (_) async => SyncResponse()..events = events,
      );

      clearInteractions(fakeChatApi.channel);

      await simulateReconnect();

      verify(
        () => fakeChatApi.channel.queryChannels(
          filter: any(
            named: 'filter',
            that: isSameFilterAs(ChannelFilter.in_(ChannelFilterField.cid, cids.take(30).toList())),
          ),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: const PaginationParams(limit: 30),
        ),
      ).called(1);

      verify(
        () => fakeChatApi.channel.queryChannels(
          filter: any(
            named: 'filter',
            that: isSameFilterAs(ChannelFilter.in_(ChannelFilterField.cid, cids.skip(30).toList())),
          ),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: const PaginationParams(limit: 1),
        ),
      ).called(1);
    });

    // Everything keyed off `connectionRecovered` — the list controllers, the
    // retry queue — assumes the recovered state has already been applied when
    // it fires. Emitting it before the catch-up finishes would have them act
    // on state the sync has not written yet.
    test('should finish recovering before `connectionRecovered` fires', () async {
      client = StreamChatClient(apiKey, defaultApi: FakeDefaultApi(), chatApi: fakeChatApi, wsProvider: ws.connect);
      await client.connectUser(user, token);
      await delay(300);

      const cid = 'messaging:c1';
      final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: cid)));
      client.state.addChannels({cid: channel});

      final lastSyncAt = DateTime.now().subtract(const Duration(hours: 1));
      client.chatPersistenceClient = FakePersistenceClient(channelCids: const [cid], lastSyncAt: lastSyncAt);
      await client.openPersistenceConnection(user);
      addTearDown(() => client.chatPersistenceClient = null);

      final calls = <String>[];
      when(() => fakeChatApi.general.sync(const [cid], lastSyncAt)).thenAnswer((_) async {
        calls.add('sync');
        return SyncResponse()..events = [];
      });
      when(
        () => fakeChatApi.channel.queryChannels(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).thenAnswer((_) async {
        calls.add('queryChannels');
        return QueryChannelsResponse()..channels = [];
      });

      final sub = client.on(EventType.connectionRecovered).listen((_) => calls.add('connectionRecovered'));
      addTearDown(sub.cancel);

      await simulateReconnect();
      await pumpEventQueue();

      expect(calls, ['sync', 'queryChannels', 'connectionRecovered']);
    });

    // One page failing says nothing about the others, so the rest are still
    // attempted — the channels that can be refreshed are.
    test('should attempt every page when one of them fails', () async {
      client = StreamChatClient(
        apiKey,
        defaultApi: FakeDefaultApi(),
        chatApi: fakeChatApi,
        wsProvider: ws.connect,
        recoverStateOnReconnect: false,
      );
      await client.connectUser(user, token);
      await delay(300);

      // 31 channels spill over the 30-channel page size into a second request.
      // Listed most recently active first, which is the order recovery uses.
      final now = DateTime.now();
      final cids = List.generate(31, (index) => 'messaging:c$index');
      client.state.addChannels({
        for (final (index, cid) in cids.indexed) cid: channelActiveAt(cid, now.subtract(Duration(minutes: index))),
      });

      final lastSyncAt = DateTime.now().subtract(const Duration(hours: 1));
      final persistenceClient = FakePersistenceClient(channelCids: cids, lastSyncAt: lastSyncAt);
      client.chatPersistenceClient = persistenceClient;
      await client.openPersistenceConnection(user);
      addTearDown(() => client.chatPersistenceClient = null);

      final events = List.generate(
        251,
        (index) => Event(
          type: EventType.messageNew,
          cid: cids.first,
          message: Message(id: 'message-$index'),
          createdAt: lastSyncAt.add(Duration(seconds: index + 1)),
        ),
      );
      when(() => fakeChatApi.general.sync(cids, lastSyncAt)).thenAnswer(
        (_) async => SyncResponse()..events = events,
      );

      // The first page fails, the second one succeeds.
      when(
        () => fakeChatApi.channel.queryChannels(
          filter: any(
            named: 'filter',
            that: isSameFilterAs(ChannelFilter.in_(ChannelFilterField.cid, cids.take(30).toList())),
          ),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).thenThrow(StateError('Failed to query channels'));

      clearInteractions(fakeChatApi.channel);

      await simulateReconnect();

      // Both pages are asked for, even though the first one failed.
      verify(
        () => fakeChatApi.channel.queryChannels(
          filter: any(
            named: 'filter',
            that: isSameFilterAs(ChannelFilter.in_(ChannelFilterField.cid, cids.skip(30).toList())),
          ),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: const PaginationParams(limit: 1),
        ),
      ).called(1);

      // The failure still keeps the checkpoint.
      expect(await persistenceClient.getLastSyncAt(), lastSyncAt);
    });

    test('should respect runtime toggling via the setter', () async {
      client = StreamChatClient(apiKey, defaultApi: FakeDefaultApi(), chatApi: fakeChatApi, wsProvider: ws.connect);
      await client.connectUser(user, token);
      await delay(300);

      final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: 'messaging:c1')));
      client.state.addChannels({'messaging:c1': channel});
      clearInteractions(fakeChatApi.channel);

      // Disable mid-flight → no re-query on reconnect.
      client.recoverStateOnReconnect = false;
      await simulateReconnect();
      verifyNever(
        () => fakeChatApi.channel.queryChannels(
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

      // Re-enable → re-query on the next reconnect.
      client.recoverStateOnReconnect = true;
      await simulateReconnect();
      verify(
        () => fakeChatApi.channel.queryChannels(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).called(1);
    });
  });

  group('dispose during reconnect recovery', () {
    const apiKey = 'test-api-key';
    final user = User(id: 'test-user-id');
    final token = testUserToken(user.id).rawValue;

    late FakeChatApi fakeChatApi;
    late FakeChatServer ws;
    late StreamChatClient client;
    var disposed = false;

    setUpAll(() {
      registerFallbackValue(const PaginationParams());
      registerFallbackValue(ChannelFilter.equal(ChannelFilterField.cid, ''));
    });

    setUp(() {
      fakeChatApi = FakeChatApi();
      ws = FakeChatServer();
      disposed = false;
    });

    // The test disposes the client itself; avoid disposing it a second time.
    tearDown(() async {
      if (!disposed) await client.dispose();
    });

    // Disposing the client while a reconnect is still recovering must complete
    // cleanly: recovery work that finishes after disposal is discarded, never
    // surfacing as an error.
    test('disposing mid-recovery does not surface a late recovery event', () async {
      // Keep the recovery's channel query pending so the client is still
      // mid-recovery at the moment it is disposed.
      final pendingQuery = Completer<QueryChannelsResponse>();
      when(
        () => fakeChatApi.channel.queryChannels(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).thenAnswer((_) => pendingQuery.future);

      client = StreamChatClient(apiKey, defaultApi: FakeDefaultApi(), chatApi: fakeChatApi, wsProvider: ws.connect);
      await client.connectUser(user, token);
      await delay(300);

      // Track a channel so reconnecting triggers channel recovery, which then
      // blocks on the pending query above.
      final channel = Channel.fromState(
        client,
        ChannelState(channel: ChannelModel(cid: 'messaging:c1')),
      );
      client.state.addChannels({'messaging:c1': channel});

      // Drop then restore the connection to start a reconnect recovery.
      ws.drop();
      await delay(100);
      await client.openConnection();
      await delay(100);

      // Dispose while the recovery is still in flight.
      await client.dispose();
      disposed = true;

      // Let the now-orphaned recovery finish. Its trailing work must be
      // discarded silently instead of thrown as an unhandled async error.
      pendingQuery.complete(QueryChannelsResponse()..channels = []);
      await delay(300);

      expect(client.connectionStatus, ConnectionStatus.disconnected);
    });
  });

  group('WS events', () {
    late StreamChatClient client;

    setUp(() async {
      final ws = FakeChatServer();
      client = StreamChatClient('test-api-key', defaultApi: FakeDefaultApi(), wsProvider: ws.connect);

      final user = User(id: 'test-user-id');
      final token = testUserToken(user.id).rawValue;

      await client.connectUser(user, token);
      await delay(300);
      expect(client.connectionStatus, ConnectionStatus.connected);
    });

    tearDown(() async {
      await client.dispose();
    });

    group('User messages deleted event', () {
      test(
        'should broadcast global user.messages.deleted event to all channels',
        () async {
          // Add messages from the user to be deleted
          final bannedUser = User(id: 'banned-user', name: 'Banned User');
          final message1 = Message(
            id: 'msg-1',
            text: 'Message in channel 1',
            user: bannedUser,
          );
          final message2 = Message(
            id: 'msg-2',
            text: 'Message in channel 2',
            user: bannedUser,
          );

          // Setup: Create multiple channels with state
          final channelState1 = ChannelState(
            channel: ChannelModel(id: 'channel-1', type: 'messaging'),
            messages: [message1],
          );
          final channelState2 = ChannelState(
            channel: ChannelModel(id: 'channel-2', type: 'messaging'),
            messages: [message2],
          );

          final channel1 = Channel.fromState(client, channelState1);
          final channel2 = Channel.fromState(client, channelState2);

          // Register channels in client state
          client.state.addChannels({
            'messaging:channel-1': channel1,
            'messaging:channel-2': channel2,
          });

          // Verify initial state
          expect(channel1.state?.messages.length, equals(1));
          expect(channel2.state?.messages.length, equals(1));

          // Simulate global user.messages.deleted event being broadcast to channels
          // (In production, ClientState._listenUserMessagesDeleted does this)
          final event = Event(
            type: EventType.userMessagesDeleted,
            user: bannedUser,
            hardDelete: false,
          );

          client.handleEvent(event);

          // Wait for the events to be processed
          await Future.delayed(Duration.zero);

          // Verify messages are soft deleted in all channels
          final channel1Message = channel1.state?.messages.first;
          expect(channel1Message?.type, equals(MessageType.deleted));
          expect(channel1Message?.state.isDeleted, isTrue);

          final channel2Message = channel2.state?.messages.first;
          expect(channel2Message?.type, equals(MessageType.deleted));
          expect(channel2Message?.state.isDeleted, isTrue);
        },
      );

      test(
        'should broadcast global hard delete to all channels',
        () async {
          // Add messages from the user to be deleted
          final bannedUser = User(id: 'banned-user', name: 'Banned User');
          final otherUser = User(id: 'other-user', name: 'Other User');

          final message1 = Message(
            id: 'msg-1',
            text: 'Message in channel 1',
            user: bannedUser,
          );
          final message2 = Message(
            id: 'msg-2',
            text: 'Message in channel 2',
            user: bannedUser,
          );
          final message3 = Message(
            id: 'msg-3',
            text: 'Safe message',
            user: otherUser,
          );

          // Setup: Create multiple channels with state
          final channelState1 = ChannelState(
            channel: ChannelModel(id: 'channel-1', type: 'messaging'),
            messages: [message1, message3],
          );
          final channelState2 = ChannelState(
            channel: ChannelModel(id: 'channel-2', type: 'messaging'),
            messages: [message2],
          );

          final channel1 = Channel.fromState(client, channelState1);
          final channel2 = Channel.fromState(client, channelState2);

          // Register channels in client state
          client.state.addChannels({
            'messaging:channel-1': channel1,
            'messaging:channel-2': channel2,
          });

          // Verify initial state
          expect(channel1.state?.messages.length, equals(2));
          expect(channel2.state?.messages.length, equals(1));

          // Simulate global user.messages.deleted event being broadcast to channels
          // (In production, ClientState._listenUserMessagesDeleted does this)
          final event = Event(
            type: EventType.userMessagesDeleted,
            user: bannedUser,
            hardDelete: true,
          );

          client.handleEvent(event);

          // Wait for the events to be processed
          await Future.delayed(Duration.zero);

          // Verify banned user's messages are removed from all channels
          expect(channel1.state?.messages.length, equals(1));
          expect(
            channel1.state?.messages.any((m) => m.user?.id == 'banned-user'),
            isFalse,
          );
          expect(channel2.state?.messages.length, equals(0));

          // Verify other user's message is unaffected
          final safeMessage = channel1.state?.messages.firstWhere((m) => m.id == 'msg-3');
          expect(safeMessage?.user?.id, equals('other-user'));
        },
      );
    });
  });

  group('ClientState mutation guards', () {
    const apiKey = 'test-api-key';
    late final fakeChatApi = FakeChatApi();
    late StreamChatClient client;

    setUp(() {
      final ws = FakeChatServer();
      client = StreamChatClient(apiKey, defaultApi: FakeDefaultApi(), wsProvider: ws.connect, chatApi: fakeChatApi);
    });

    tearDown(() {
      client.dispose();
    });

    test('`state.channels` returns an unmodifiable view', () {
      final channel = Channel.fromState(
        client,
        ChannelState(channel: ChannelModel(cid: 'messaging:c1')),
      );
      client.state.addChannels({'messaging:c1': channel});

      expect(client.state.channels, hasLength(1));
      expect(() => client.state.channels.remove('messaging:c1'), throwsUnsupportedError);
      expect(() => client.state.channels.clear(), throwsUnsupportedError);
      expect(() => client.state.channels['messaging:c2'] = channel, throwsUnsupportedError);
    });

    test('`state.users` returns an unmodifiable view', () {
      client.state.updateUser(User(id: 'u1'));

      expect(client.state.users.containsKey('u1'), isTrue);
      expect(() => client.state.users.remove('u1'), throwsUnsupportedError);
      expect(() => client.state.users.clear(), throwsUnsupportedError);
    });

    test('`state.activeLiveLocations` returns an unmodifiable view', () {
      expect(() => client.state.activeLiveLocations.clear(), throwsUnsupportedError);
    });

    test('`removeChannel` emits a fresh map so distinct subscribers see the change', () async {
      final channel = Channel.fromState(
        client,
        ChannelState(channel: ChannelModel(cid: 'messaging:c1')),
      );
      client.state.addChannels({'messaging:c1': channel});

      final received = <Map<String, Channel>>[];
      // Skip the BehaviorSubject's replay of the current value to new subscribers.
      final sub = client.state.channelsStream.distinct().skip(1).listen(received.add);

      client.state.removeChannel('messaging:c1');
      await Future<void>.delayed(Duration.zero);

      expect(received, hasLength(1));
      expect(received.single, isEmpty);

      await sub.cancel();
    });

    test('initial seeded values are unmodifiable (before any write)', () {
      // Fresh client, no mutations yet — subscribers connecting at this point
      // still see unmodifiable seeds.
      expect(() => client.state.channels.clear(), throwsUnsupportedError);
      expect(() => client.state.users.clear(), throwsUnsupportedError);
      expect(() => client.state.activeLiveLocations.clear(), throwsUnsupportedError);
    });

    test('`channelsStream` emits unmodifiable maps', () async {
      final received = <Map<String, Channel>>[];
      final sub = client.state.channelsStream.listen(received.add);

      final channel = Channel.fromState(
        client,
        ChannelState(channel: ChannelModel(cid: 'messaging:c1')),
      );
      client.state.addChannels({'messaging:c1': channel});
      await Future<void>.delayed(Duration.zero);

      // Both the initial seed and the post-write emission must be unmodifiable.
      expect(received, hasLength(greaterThanOrEqualTo(2)));
      for (final emitted in received) {
        expect(emitted.clear, throwsUnsupportedError);
      }

      await sub.cancel();
    });

    test('`usersStream` emits unmodifiable maps', () async {
      final received = <Map<String, User>>[];
      final sub = client.state.usersStream.listen(received.add);

      client.state.updateUser(User(id: 'u1'));
      await Future<void>.delayed(Duration.zero);

      expect(received, hasLength(greaterThanOrEqualTo(2)));
      for (final emitted in received) {
        expect(emitted.clear, throwsUnsupportedError);
      }

      await sub.cancel();
    });

    test('`activeLiveLocationsStream` emits unmodifiable lists', () async {
      final received = <List<Location>>[];
      final sub = client.state.activeLiveLocationsStream.listen(received.add);

      client.state.activeLiveLocations = const [];
      await Future<void>.delayed(Duration.zero);

      expect(received, isNotEmpty);
      for (final emitted in received) {
        expect(emitted.clear, throwsUnsupportedError);
      }

      await sub.cancel();
    });
  });

  group('event resolvers', () {
    // Recovering after an outage replays the events missed over `/sync`, not over the socket, so
    // one carrying a poll has to be reported the same way as one that arrived live.
    test('should report a poll message recovered after an outage as a poll created event', () async {
      final client = StreamChatClient(
        'test-api-key',
        defaultApi: FakeDefaultApi(),
        chatApi: FakeChatApi(),
        wsProvider: FakeChatServer().connect,
      );
      addTearDown(client.dispose);

      final poll = Poll(
        name: 'What is your favorite color?',
        options: const [
          PollOption(text: 'Red'),
          PollOption(text: 'Blue'),
        ],
      );

      final reported = client.on(EventType.pollCreated).first;
      client.handleEvent(Event(type: EventType.messageNew, poll: poll));

      expect((await reported).poll, poll);
    });
  });

  group('reconnecting a connection that dropped', () {
    const apiKey = 'test-api-key';
    final user = User(id: 'test-user-id');
    final token = testUserToken(user.id).rawValue;

    Future<(StreamChatClient, FakeChatServer)> connectedClient() async {
      final server = FakeChatServer(user: OwnUser.fromUser(user));
      final client = StreamChatClient(
        apiKey,
        defaultApi: FakeDefaultApi(),
        chatApi: FakeChatApi(),
        wsProvider: server.connect,
      );
      addTearDown(client.dispose);

      await client.connectUser(user, token);
      return (client, server);
    }

    test('should reopen a dropped connection without being asked to', () async {
      final (client, server) = await connectedClient();

      final reconnected = client.connectionStatusStream
          .skip(1)
          .firstWhere(
            (it) => it == ConnectionStatus.connected,
          );

      server.drop(closeCode: 1006);
      await reconnected;

      expect(server.sockets, hasLength(2));
    });

    test('should report connecting for as long as it keeps reopening', () async {
      final (client, server) = await connectedClient();
      server.handshakeFails = true;

      final reported = <ConnectionStatus>[];
      final listening = client.connectionStatusStream.listen(reported.add);
      addTearDown(listening.cancel);

      server.drop(closeCode: 1006);

      // Long enough for the attempt that follows the drop and the one that follows its failure:
      // the first is immediate and the delay after a single failure is at most two seconds.
      await Future<void>.delayed(const Duration(seconds: 3));

      // Attempts of its own, without being asked.
      expect(server.sockets.length, greaterThan(2));

      // The delay it waits out between them is a state of its own, which an app reads as still
      // on its way back rather than as a connection nothing is opening.
      expect(reported, [ConnectionStatus.connected, ConnectionStatus.connecting]);
    });

    test('should report a first attempt that failed as disconnected', () async {
      final server = FakeChatServer(user: OwnUser.fromUser(user))..handshakeFails = true;
      final client = StreamChatClient(
        apiKey,
        defaultApi: FakeDefaultApi(),
        chatApi: FakeChatApi(),
        wsProvider: server.connect,
      );
      addTearDown(client.dispose);

      await expectLater(client.connectUser(user, token), throwsA(isA<StreamException>()));

      // Closed for a reason worth retrying, and left to the caller who was told it failed.
      // Reported as connecting, nothing would ever move it off that.
      expect(client.connectionStatus, ConnectionStatus.disconnected);

      await Future<void>.delayed(const Duration(seconds: 1));
      expect(server.sockets, hasLength(1));
      expect(client.connectionStatus, ConnectionStatus.disconnected);
    });

    test('should report a drop while reconnection is paused as disconnected', () async {
      final (client, server) = await connectedClient();
      client.pauseReconnect();

      final reported = client.connectionStatusStream.skip(1).first;
      server
        ..handshakeFails = true
        ..drop(closeCode: 1006);

      // Worth retrying, with nothing retrying it until reconnection resumes.
      expect(await reported, ConnectionStatus.disconnected);
      expect(server.sockets, hasLength(1));
    });

    // `connecting` covers two connections a caller cannot tell apart, and opening one is right for
    // only one of them. Driven against a real socket, which is the only thing that distinguishes
    // them; a status alone does not.
    test('should open a connection waiting out a delay rather than wait with it', () async {
      final (client, server) = await connectedClient();
      server
        ..handshakeFails = true
        ..drop(closeCode: 1006);

      await pumpEventQueue();
      expect(client.connectionStatus, ConnectionStatus.connecting);

      // The delay the socket is waiting out was started before the caller asked, so there is no
      // reason to sit through the rest of it.
      server.handshakeFails = false;
      await client.openConnection();

      expect(client.connectionStatus, ConnectionStatus.connected);
    });

    test('should wait on the attempt in flight rather than open a second connection', () async {
      final server = FakeChatServer(user: OwnUser.fromUser(user));
      final client = StreamChatClient(
        apiKey,
        defaultApi: FakeDefaultApi(),
        chatApi: FakeChatApi(),
        wsProvider: server.connect,
      );
      addTearDown(client.dispose);

      // Reported the same way as a connection waiting out a delay, which is what makes asking to
      // open one on a foreground or a network change land here.
      final connecting = client.connectUser(user, token);
      expect(client.connectionStatus, ConnectionStatus.connecting);

      final joined = client.openConnection();

      // The attempt already in flight, answered to both callers. A second socket would leave the
      // first connection unreferenced, and refusing would raise on a path neither can act on.
      expect((await joined).id, user.id);
      expect((await connecting).id, user.id);
      expect(server.sockets, hasLength(1));
    });

    test('should answer a connectUser for the user already connected with that connection', () async {
      final (client, server) = await connectedClient();
      final connected = client.state.currentUser;

      // The connection being asked for is the one already in hand, so the caller is answered with
      // it rather than told they should have disconnected first.
      final again = await client.connectUser(user, token);

      expect(again, connected);
      expect(server.sockets, hasLength(1));
      expect(client.connectionStatus, ConnectionStatus.connected);
    });

    test('should open a connection asked for while the last one was still closing', () async {
      final (client, server) = await connectedClient();

      // Closing and opening without waiting in between, which leaves the socket still closing when
      // the second call arrives.
      client.closeConnection().ignore();
      await client.openConnection();

      expect(client.connectionStatus, ConnectionStatus.connected);
      expect(server.sockets, hasLength(2));
    });

    test('should refuse a connectUser for another user while one is connected', () async {
      final (client, _) = await connectedClient();

      // Signing another user in over this one would leave the connection it has unreferenced.
      await expectLater(
        client.connectUser(User(id: 'someone-else'), testUserToken('someone-else').rawValue),
        throwsA(
          isA<StateError>().having(
            (it) => it.message,
            'message',
            allOf(contains('someone-else'), contains(user.id), contains('disconnectUser')),
          ),
        ),
      );
    });

    test('should answer both callers connecting the same user at once with one connection', () async {
      final defaultApi = MockDefaultApi();
      when(defaultApi.getApp).thenAnswer((_) async => Result.success(fakeGetApplicationResponse()));
      final server = FakeChatServer(user: OwnUser.fromUser(user));
      final client = StreamChatClient(
        apiKey,
        defaultApi: defaultApi,
        chatApi: FakeChatApi(),
        wsProvider: server.connect,
      );
      addTearDown(client.dispose);

      // The second lands while the first is still opening, which is where the status cannot tell a
      // connection being opened from one waiting to be.
      final first = client.connectUser(user, token);
      final second = client.connectUser(user, token);

      expect((await first).id, user.id);
      expect((await second).id, user.id);
      expect(server.sockets, hasLength(1));

      // One sign-in, not two alongside each other: what it does for the user behind the connection
      // is done for the pair rather than once each.
      await pumpEventQueue();
      verify(defaultApi.getApp).called(1);
    });

    test('should leave nobody signed in when connecting a user fails', () async {
      final server = FakeChatServer()..handshakeFails = true;
      final client = StreamChatClient(
        apiKey,
        defaultApi: FakeDefaultApi(),
        chatApi: FakeChatApi(),
        wsProvider: server.connect,
      );
      addTearDown(client.dispose);

      await expectLater(client.connectUser(user, token), throwsA(isA<StreamException>()));

      expect(client.state.currentUser, isNull);
    });

    test('should connect another user after connecting one failed', () async {
      final server = FakeChatServer()..handshakeFails = true;
      final client = StreamChatClient(
        apiKey,
        defaultApi: FakeDefaultApi(),
        chatApi: FakeChatApi(),
        wsProvider: server.connect,
      );
      addTearDown(client.dispose);

      await expectLater(client.connectUser(user, token), throwsA(isA<StreamException>()));

      // A user who never signed in would otherwise have this refused on their behalf, and be
      // named in the refusal as the one who is signed in.
      server.handshakeFails = false;
      final other = User(id: 'someone-else');

      expect((await client.connectUser(other, testUserToken(other.id).rawValue)).id, other.id);
    });

    test('should leave the connected user signed in when reconnecting them fails', () async {
      final (client, server) = await connectedClient();
      final connected = client.state.currentUser;

      // The connection drops and is being retried, which is where asking for one again opens it
      // now rather than waiting out the delay.
      server
        ..handshakeFails = true
        ..drop(closeCode: 1006);
      await pumpEventQueue();

      await expectLater(client.connectUser(user, token), throwsA(isA<StreamException>()));

      // The socket is still retrying on their behalf, so dropping them here would leave it working
      // for a user the client says is not signed in.
      expect(client.state.currentUser, connected);
    });

    test('should stop reopening once the caller closes the connection', () async {
      final (client, server) = await connectedClient();
      server
        ..handshakeFails = true
        ..drop(closeCode: 1006);

      client.closeConnection();

      // Long enough to catch one: the delay after a single failure is at most two seconds.
      final attempts = server.sockets.length;
      await expectLater(
        client.connectionStatusStream
            .skip(1)
            .firstWhere((it) => it == ConnectionStatus.connecting)
            .timeout(
              const Duration(seconds: 3),
            ),
        throwsA(isA<TimeoutException>()),
      );

      expect(server.sockets, hasLength(attempts));
    });
  });

  group('when a user is signed in', () {
    const apiKey = 'test-api-key';
    final user = User(id: 'test-user-id');
    final token = testUserToken(user.id).rawValue;

    // A client with [user] signed in, whose guest exchange for [requested] answers the way a real
    // one does: with an id of the guest's own.
    Future<(StreamChatClient, MockDefaultApi)> signedInClient({required User requested}) async {
      registerFallbackValue(const api.CreateGuestRequest(user: api.UserRequest(id: 'fallback')));

      final defaultApi = MockDefaultApi();
      when(defaultApi.getApp).thenAnswer((_) async => Result.success(fakeGetApplicationResponse()));
      final client = StreamChatClient(
        apiKey,
        defaultApi: defaultApi,
        chatApi: FakeChatApi(),
        wsProvider: FakeChatServer(user: OwnUser.fromUser(user)).connect,
      );
      addTearDown(client.dispose);
      await client.connectUser(user, token);

      final guestId = 'guest-1234-${requested.id}';
      when(() => defaultApi.createGuest(createGuestRequest: any(named: 'createGuestRequest'))).thenAnswer(
        (_) async => Result.success(
          api.CreateGuestResponse(
            duration: '3.20ms',
            accessToken: testUserToken(guestId).rawValue,
            user: api.UserResponse(
              id: guestId,
              role: 'guest',
              language: 'en',
              online: false,
              banned: false,
              teams: const [],
              custom: const {},
              blockedUserIds: const [],
              createdAt: DateTime.utc(2026),
              updatedAt: DateTime.utc(2026),
            ),
          ),
        ),
      );

      return (client, defaultApi);
    }

    test('should refuse a connectGuestUser without asking for a guest', () async {
      final requested = User(id: 'someone-else');
      final (client, defaultApi) = await signedInClient(requested: requested);

      await expectLater(
        client.connectGuestUser(requested, connectWebSocket: false),
        throwsA(
          isA<StateError>().having(
            (it) => it.message,
            'message',
            allOf(contains(requested.id), contains('${user.id} is signed in'), contains('disconnectUser')),
          ),
        ),
      );
      verifyNever(() => defaultApi.createGuest(createGuestRequest: any(named: 'createGuestRequest')));
    });

    test('should refuse a connectGuestUser under the id of the user signed in', () async {
      // The guest would still be another user, so this is refused like any other.
      final requested = User(id: user.id);
      final (client, defaultApi) = await signedInClient(requested: requested);

      await expectLater(
        client.connectGuestUser(requested, connectWebSocket: false),
        throwsA(isA<StateError>().having((it) => it.message, 'message', contains('${user.id} is signed in'))),
      );
      verifyNever(() => defaultApi.createGuest(createGuestRequest: any(named: 'createGuestRequest')));
    });

    test('should leave the signed-in user authenticated after refusing a connectGuestUser', () async {
      final requested = User(id: 'someone-else');
      final (client, _) = await signedInClient(requested: requested);
      await expectLater(client.connectGuestUser(requested, connectWebSocket: false), throwsA(isA<StateError>()));

      // Reopening authenticates with the token the signed-in user connected with.
      await client.closeConnection();
      await client.openConnection();

      expect(client.connectionStatus, ConnectionStatus.connected);
    });
  });

  group('`queryChannels` with `waitForConnect`', () {
    const apiKey = 'test-api-key';
    final user = User(id: 'test-user-id');
    final token = testUserToken(user.id).rawValue;

    setUpAll(() => registerFallbackValue(const PaginationParams()));

    // A client that never connected has nothing to wait for, so the query says so rather than
    // waiting on a connection nobody asked for.
    test('should throw when no connection was ever opened', () async {
      final client = StreamChatClient(
        apiKey,
        defaultApi: FakeDefaultApi(),
        chatApi: FakeChatApi(),
        wsProvider: FakeChatServer().connect,
      );
      addTearDown(client.dispose);

      expect(client.connectionStatus, ConnectionStatus.disconnected);
      await expectLater(client.queryChannels().first, throwsStateError);
    });

    // Whether the channels can be watched is read when the request is sent, not when the query is
    // made, so one that waited for a connection still watches what it loads.
    test('should watch the channels it loads when the connection lands mid-query', () async {
      final fakeChatApi = FakeChatApi();
      final ws = FakeChatServer(user: OwnUser.fromUser(user));
      final client = StreamChatClient(
        apiKey,
        defaultApi: FakeDefaultApi(),
        chatApi: fakeChatApi,
        wsProvider: ws.connect,
      );
      addTearDown(client.dispose);

      when(
        () => fakeChatApi.channel.queryChannels(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).thenAnswer((_) async => QueryChannelsResponse()..channels = []);

      // Not awaited: the query below has to arrive while the attempt is still in flight.
      final connecting = client.connectUser(user, token);
      final queried = client.queryChannels().first;

      await connecting;
      await queried;

      final watched = verify(
        () => fakeChatApi.channel.queryChannels(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: captureAny(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).captured;

      expect(watched.single, isTrue);
    });

    // The wait ends when the attempt settles either way: one that fails has to raise rather than
    // leave the caller waiting on a connection nothing is opening any more.
    test('should throw rather than hang when the connection being opened fails', () async {
      final ws = FakeChatServer()..handshakeFails = true;
      final client = StreamChatClient(
        apiKey,
        defaultApi: FakeDefaultApi(),
        chatApi: FakeChatApi(),
        wsProvider: ws.connect,
      );
      addTearDown(client.dispose);

      // Not awaited: the query below has to arrive while the attempt is still in flight.
      final connecting = client.connectUser(user, token);

      await expectLater(client.queryChannels().first, throwsStateError);
      await expectLater(connecting, throwsA(isA<StreamChatException>()));
    });
  });
}

api.UserGroupResponse _generatedUserGroup(String id) {
  return api.UserGroupResponse(
    createdAt: DateTime.utc(2024),
    id: id,
    name: 'name-$id',
    updatedAt: DateTime.utc(2024),
  );
}

UserGroup _userGroup(String id) {
  return UserGroup(
    createdAt: DateTime.utc(2024),
    id: id,
    name: 'name-$id',
    updatedAt: DateTime.utc(2024),
  );
}

api.DeviceResponse _generatedDevice({required String id, required String pushProvider}) {
  return api.DeviceResponse(id: id, pushProvider: pushProvider, createdAt: DateTime.utc(2024), userId: 'test-user-id');
}

// A poll as a caller builds it: options without ids and the vote summary at its defaults.
Poll _newPoll() => Poll(
  id: 'poll-id',
  name: 'Lunch?',
  description: 'Pick one',
  options: const [
    PollOption(text: 'Pizza', extraData: {'color': 'red', 'text': 'Pasta'}),
    PollOption(text: 'Sushi'),
  ],
  votingVisibility: VotingVisibility.anonymous,
  enforceUniqueVote: false,
  maxVotesAllowed: 2,
  allowAnswers: true,
  allowUserSuggestedOptions: true,
  voteCount: 7,
  // Custom data named like one of the poll's own fields is left out of the requests.
  extraData: const {'topic': 'food', 'name': 'Dinner?'},
);

const _generatedPizzaResponse = api.PollOptionResponse(duration: '4.21ms', pollOption: generatedPizza);

const _pizzaResponse = PollOptionResponse(duration: '4.21ms', pollOption: pizza);
