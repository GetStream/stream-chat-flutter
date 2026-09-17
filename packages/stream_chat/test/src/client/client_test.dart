// LEGACY CARVE-OUT: these tests intentionally stay on a hand-rolled fake
// WebSocket instead of the `stream_chat_test` BDD harness:
//
// - The `.connectAnonymousUser` tests: the anonymous token's user id cannot
//   pass the fake server's connect-URI validation without a TokenManager seam.
// - The reconnect-recovery tests: the harness exposes no seam to drop and
//   restore the underlying connection mid-test.
//
// Revisit once the TokenManager seam lands in the harness.

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/src/ws/websocket.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

// The unread counts are derived from the current user, so assigning a new
// one has to republish them.

void main() {
  group('Fake web-socket connection functions', () {
    const apiKey = 'test-api-key';
    late final api = FakeChatApi();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(_FakeUser());
    });

    setUp(() {
      final ws = _FakeWebSocket();
      client = StreamChatClient(apiKey, ws: ws, chatApi: api);
    });

    tearDown(() {
      client.dispose();
    });

    chatClientTest(
      '`.connectUser` should work fine',
      connect: (tester) => tester.mockSuccessfulAuth(),
      body: (tester) async {
        final user = tester.user;
        final token = createTestToken(user.id).rawValue;

        final statusEmitted = expectLater(
          // skipping first seed status -> ConnectionStatus.disconnected
          tester.client.wsConnectionStatusStream.skip(1),
          emitsInOrder([
            ConnectionStatus.connecting,
            ConnectionStatus.connected,
          ]),
        );

        final res = await tester.client.connectUser(user, token);
        expect(res, isNotNull);
        expect(res, isSameUserAs(user));

        await statusEmitted;
      },
    );

    chatClientTest(
      '`.connectUserWithProvider` should work fine',
      connect: (tester) => tester.mockSuccessfulAuth(),
      body: (tester) async {
        final user = tester.user;
        Future<String> tokenProvider(String userId) async {
          expect(userId, user.id);
          return createTestToken(userId).rawValue;
        }

        final statusEmitted = expectLater(
          // skipping first seed status -> ConnectionStatus.disconnected
          tester.client.wsConnectionStatusStream.skip(1),
          emitsInOrder([
            ConnectionStatus.connecting,
            ConnectionStatus.connected,
          ]),
        );

        final res = await tester.client.connectUserWithProvider(user, tokenProvider);
        expect(res, isNotNull);
        expect(res, isSameUserAs(user));

        await statusEmitted;
      },
    );

    group('`.connectGuestUser`', () {
      chatClientTest(
        'should work fine',
        connect: (tester) => tester.mockSuccessfulAuth(),
        body: (tester) async {
          final user = tester.user;
          final token = createTestToken(user.id).rawValue;

          tester.mockApi(
            (api) => api.guest.getGuestUser(any(that: isSameUserAs(user))),
            result: createDefaultConnectGuestUserResponse(user: user, accessToken: token),
          );

          final statusEmitted = expectLater(
            // skipping first seed status -> ConnectionStatus.disconnected
            tester.client.wsConnectionStatusStream.skip(1),
            emitsInOrder([
              ConnectionStatus.connecting,
              ConnectionStatus.connected,
            ]),
          );

          final res = await tester.client.connectGuestUser(user);
          expect(res, isNotNull);
          expect(res, isSameUserAs(user));

          tester.verifyApi(
            (api) => api.guest.getGuestUser(any(that: isSameUserAs(user))),
          );

          await statusEmitted;
        },
      );

      chatClientTest(
        'should throw if `.getGuestUser` fails',
        connect: (_) {},
        body: (tester) async {
          final user = tester.user;

          tester.mockApiFailure(
            (api) => api.guest.getGuestUser(any(that: isSameUserAs(user))),
            error: createDefaultNetworkError(errorCode: ChatErrorCode.inputError),
          );

          final statusEmitted = expectLater(
            tester.client.wsConnectionStatusStream,
            emitsInOrder([
              // only emits the seed -> disconnected status
              // as the call never reaches `ws.connect`
              ConnectionStatus.disconnected,
            ]),
          );

          await expectLater(
            tester.client.connectGuestUser(user),
            throwsA(isA<StreamChatNetworkError>()),
          );

          tester.verifyApi(
            (api) => api.guest.getGuestUser(any(that: isSameUserAs(user))),
          );

          await statusEmitted;
        },
      );
    });

    test('`.connectAnonymousUser` should work fine', () async {
      expectLater(
        // skipping first seed status -> ConnectionStatus.disconnected
        client.wsConnectionStatusStream.skip(1),
        emitsInOrder([
          ConnectionStatus.connecting,
          ConnectionStatus.connected,
        ]),
      );

      final res = await client.connectAnonymousUser();
      expect(res, isNotNull);
    });

    group('`.openConnection`', () {
      chatClientTest(
        'should throw if state does not contain user',
        connect: (_) {},
        body: (tester) async {
          expect(tester.currentUser, isNull);
          await expectLater(
            tester.client.openConnection(),
            throwsA(isA<AssertionError>()),
          );
        },
      );

      chatClientTest(
        'should throw if connection is already available',
        connect: (tester) => tester.mockSuccessfulAuth(),
        body: (tester) async {
          expect(tester.currentUser, isNull);

          // The anonymous connect path is unavailable here, so the
          // connection is opened with the regular user instead.
          final token = createTestToken(tester.user.id).rawValue;
          await tester.client.connectUser(tester.user, token);

          await expectLater(
            tester.client.openConnection(),
            throwsA(
              isA<StreamChatError>().having(
                (error) => error.message,
                'message',
                contains('Connection already available for'),
              ),
            ),
          );
        },
      );

      chatClientTest(
        'should open connection for closed connection',
        connect: (tester) => tester.mockSuccessfulAuth(),
        body: (tester) async {
          final statusEmitted = expectLater(
            tester.client.wsConnectionStatusStream.skip(1),
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

          // The anonymous connect path is unavailable here, so the
          // connection is opened with the regular user instead.
          final token = createTestToken(tester.user.id).rawValue;
          await tester.client.connectUser(tester.user, token);

          tester.client.closeConnection();

          await tester.client.openConnection();

          await statusEmitted;
        },
      );
    });
  });

  group('Fake web-socket connection functions failure', () {
    const apiKey = 'test-api-key';
    late final api = FakeChatApi();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(_FakeUser());
    });

    setUp(() {
      final ws = _FakeWebSocketWithConnectionError();
      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
    });

    tearDown(() {
      client.dispose();
    });

    chatClientTest(
      '`.connectUser` should throw if `ws.connect` fails',
      connect: (tester) => tester.mockConnectionError(),
      body: (tester) async {
        final user = tester.user;
        final token = createTestToken(user.id).rawValue;

        await expectLater(
          tester.client.connectUser(user, token),
          throwsA(isA<StreamWebSocketError>()),
        );
      },
    );

    chatClientTest(
      '`.connectUserWithProvider` should throw if `ws.connect` fails',
      connect: (tester) => tester.mockConnectionError(),
      body: (tester) async {
        final user = tester.user;
        Future<String> tokenProvider(String userId) async {
          expect(userId, user.id);
          return createTestToken(userId).rawValue;
        }

        await expectLater(
          tester.client.connectUserWithProvider(user, tokenProvider),
          throwsA(isA<StreamWebSocketError>()),
        );
      },
    );

    chatClientTest(
      '`.connectGuestUser` should throw if `ws.connect` fails',
      connect: (tester) => tester.mockConnectionError(),
      body: (tester) async {
        final user = tester.user;
        final token = createTestToken(user.id).rawValue;

        tester.mockApi(
          (api) => api.guest.getGuestUser(any(that: isSameUserAs(user))),
          result: createDefaultConnectGuestUserResponse(user: user, accessToken: token),
        );

        await expectLater(
          tester.client.connectGuestUser(user),
          throwsA(isA<StreamWebSocketError>()),
        );

        tester.verifyApi(
          (api) => api.guest.getGuestUser(any(that: isSameUserAs(user))),
        );
      },
    );

    test(
      '`.connectAnonymousUser` should throw if `ws.connect` fails',
      () async {
        try {
          await client.connectAnonymousUser();
        } catch (e) {
          expect(e, isA<StreamWebSocketError>());
        }
      },
    );
  });

  group('Connect user calls with `connectWebSocket`: false', () {
    const apiKey = 'test-api-key';
    late final api = FakeChatApi();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(_FakeUser());
    });

    setUp(() {
      client = StreamChatClient(apiKey, chatApi: api);
    });

    tearDown(() {
      client.dispose();
    });

    chatClientTest(
      '`.connectUser` should succeed without connecting',
      connect: (_) {},
      body: (tester) async {
        final user = tester.user;
        final token = createTestToken(user.id).rawValue;

        final res = await tester.client.connectUser(
          user,
          token,
          connectWebSocket: false,
        );
        expect(res, isSameUserAs(user));
        expect(tester.connectionStatus, ConnectionStatus.disconnected);
      },
    );

    chatClientTest(
      '`.connectUserWithProvider` should succeed without connecting',
      connect: (_) {},
      body: (tester) async {
        final user = tester.user;
        Future<String> tokenProvider(String userId) async {
          expect(userId, user.id);
          return createTestToken(userId).rawValue;
        }

        final res = await tester.client.connectUserWithProvider(
          user,
          tokenProvider,
          connectWebSocket: false,
        );
        expect(res, isSameUserAs(user));
        expect(tester.connectionStatus, ConnectionStatus.disconnected);
      },
    );

    chatClientTest(
      '`.connectGuestUser` should succeed without connecting',
      connect: (_) {},
      body: (tester) async {
        final user = tester.user;
        final token = createTestToken(user.id).rawValue;

        tester.mockApi(
          (api) => api.guest.getGuestUser(any(that: isSameUserAs(user))),
          result: createDefaultConnectGuestUserResponse(user: user, accessToken: token),
        );

        final res = await tester.client.connectGuestUser(
          user,
          connectWebSocket: false,
        );

        expect(res, isSameUserAs(user));
        expect(tester.connectionStatus, ConnectionStatus.disconnected);
        tester.verifyApi(
          (api) => api.guest.getGuestUser(any(that: isSameUserAs(user))),
        );
      },
    );

    test(
      '`.connectAnonymousUser` should succeed without connecting',
      () async {
        final res = await client.connectAnonymousUser(
          connectWebSocket: false,
        );

        expect(res, isNotNull);
        expect(client.wsConnectionStatus, ConnectionStatus.disconnected);
      },
    );
  });

  group('Fake web-socket connection function with failure and persistence', () {
    // Runs [body] as a [chatClientTest] whose client is backed by a fresh
    // [MockPersistenceClient] and whose WebSocket transport fails to connect: the
    // connect attempt fails with a retriable error, so the client falls back to
    // the persisted connection info.
    void _failedConnectionWithPersistenceTest(
      String description, {
      required Future<void> Function(ChatClientTester tester, MockPersistenceClient persistence) body,
    }) {
      final persistence = MockPersistenceClient();

      chatClientTest(
        description,
        chatPersistenceClient: persistence,
        connect: (tester) => tester.mockConnectionError(),
        body: (tester) => body(tester, persistence),
      );
    }

    const apiKey = 'test-api-key';
    late final api = FakeChatApi();
    late final persistence = MockPersistenceClient();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(_FakeUser());
    });

    setUp(() {
      final ws = _FakeWebSocketWithConnectionError();
      client = StreamChatClient(apiKey, chatApi: api, ws: ws)..chatPersistenceClient = persistence;
    });

    tearDown(() {
      client.dispose();
    });

    _failedConnectionWithPersistenceTest(
      '`.connectUser` should connect successfully if persistence contains event',
      body: (tester, persistence) async {
        final user = tester.user;

        final event = Event(
          type: EventType.healthCheck,
          connectionId: 'test-connection-id',
          me: OwnUser.fromUser(user),
        );
        when(persistence.getConnectionInfo).thenAnswer((_) async => event);

        final res = await tester.client.connectUser(user, createTestToken(user.id).rawValue);
        expect(res, isNotNull);
        expect(res, isSameUserAs(user));

        verify(persistence.getConnectionInfo).called(1);
        verifyNoMoreInteractions(persistence);
      },
    );

    _failedConnectionWithPersistenceTest(
      '`.connectUserWithProvider` should connect successfully if persistence contains event',
      body: (tester, persistence) async {
        final user = tester.user;
        Future<String> tokenProvider(String userId) async {
          expect(userId, user.id);
          return createTestToken(userId).rawValue;
        }

        final event = Event(
          type: EventType.healthCheck,
          connectionId: 'test-connection-id',
          me: OwnUser.fromUser(user),
        );
        when(persistence.getConnectionInfo).thenAnswer((_) async => event);

        final res = await tester.client.connectUserWithProvider(user, tokenProvider);
        expect(res, isNotNull);
        expect(res, isSameUserAs(user));

        verify(persistence.getConnectionInfo).called(1);
        verifyNoMoreInteractions(persistence);
      },
    );

    _failedConnectionWithPersistenceTest(
      '`.connectGuestUser` should connect successfully if persistence contains event',
      body: (tester, persistence) async {
        final user = tester.user;

        final event = Event(
          type: EventType.healthCheck,
          connectionId: 'test-connection-id',
          me: OwnUser.fromUser(user),
        );
        when(persistence.getConnectionInfo).thenAnswer((_) async => event);

        tester.mockApi(
          (api) => api.guest.getGuestUser(any(that: isSameUserAs(user))),
          result: createDefaultConnectGuestUserResponse(user: user),
        );

        final res = await tester.client.connectGuestUser(user);
        expect(res, isNotNull);
        expect(res, isSameUserAs(user));

        verify(persistence.getConnectionInfo).called(1);
        verifyNoMoreInteractions(persistence);
        tester
          ..verifyApi((api) => api.guest.getGuestUser(any(that: isSameUserAs(user))))
          ..verifyNoMoreApiInteractions((api) => api.guest);
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
    // Runs [body] as a [chatClientTest] whose client is backed by a fresh
    // [MockPersistenceClient]: the persistence stubs the connect path needs are
    // installed first, then the client is connected and persistence is asserted
    // enabled.
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

          tester.mockSuccessfulAuth();
          await tester.client.connectUser(tester.user, createTestToken(tester.user.id).rawValue);

          expect(tester.client.persistenceEnabled, isTrue);
          expect(tester.connectionStatus, ConnectionStatus.connected);
        },
        body: (tester) => body(tester, persistence),
      );
    }

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

  group('Client with connected user without persistence', () {
    const _channelData = {'name': 'test-channel-name'};

    group('`.sync`', () {
      chatClientTest(
        'should work fine',
        body: (tester) async {
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

          await tester.client.sync(cids: cids, lastSyncAt: lastSyncAt);

          tester.verifyApi((api) => api.general.sync(cids, lastSyncAt));
        },
      );

      chatClientTest(
        'should return if `cids` is not available',
        body: (tester) async {
          await expectLater(tester.client.sync(), completes);
          tester.verifyNeverCalled((api) => api.general.sync(any(), any()));
        },
      );

      chatClientTest(
        'should return if `lastSyncAt` is not available',
        body: (tester) async {
          await expectLater(tester.client.sync(cids: ['test-cid-1']), completes);
          tester.verifyNeverCalled((api) => api.general.sync(any(), any()));
        },
      );
    });

    group('`.queryChannels`', () {
      chatClientTest(
        'should work fine without persistent channels',
        body: (tester) async {
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

          await expectLater(
            tester.client.queryChannels(),
            emitsInOrder([channelStates.map(isCorrectChannelFor)]),
          );

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
        },
      );

      chatClientTest(
        '''should rethrow if `.queryChannelsOnline` throws and persistence channels are empty''',
        body: (tester) async {
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

          await expectLater(
            tester.client.queryChannels(),
            emitsError(isA<StreamChatNetworkError>()),
          );

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
        },
      );

      chatClientTest(
        'should coalesce concurrent identical calls into a single HTTP request',
        body: (tester) async {
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
            (index) => createDefaultChannelState(
              channel: createDefaultChannelModel(cid: 'test-type-$index:test-id-$index'),
            ),
          );

          // Slow down the API so all concurrent callers are guaranteed to be
          // in flight at the same time when the cache write happens.
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
            delay: const Duration(milliseconds: 100),
          );

          // Fire 5 identical calls back-to-back in the same tick.
          final results = await Future.wait(
            List.generate(5, (_) => tester.client.queryChannels().toList()),
          );

          // All callers should receive the same channels.
          for (final emitted in results) {
            expect(emitted, hasLength(1));
            expect(emitted.single, channelStates.map(isCorrectChannelFor));
          }

          // But only ONE HTTP request should have been issued.
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
        },
      );

      chatClientTest(
        'should fire a fresh request once the cached future has settled',
        body: (tester) async {
          // After the in-flight future completes, the cache slot is freed and
          // the next call must hit the API again — only concurrent callers
          // share the future, not sequential ones.
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

          await tester.client.queryChannels().toList();
          await tester.client.queryChannels().toList();

          tester.verifyApiCalled(
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
            times: 2,
          );
        },
      );

      chatClientTest(
        'concurrent calls with different filters do not share the cache',
        body: (tester) async {
          // The cache is keyed on a hash of the query parameters. Callers
          // with different filters/limits must each fire their own request.
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
            result: createDefaultQueryChannelsResponse(),
            delay: const Duration(milliseconds: 100),
          );

          await Future.wait([
            tester.client.queryChannels(filter: Filter.in_('cid', const ['a'])).toList(),
            tester.client.queryChannels(filter: Filter.in_('cid', const ['b'])).toList(),
          ]);

          tester.verifyApiCalled(
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
            times: 2,
          );
        },
      );

      chatClientTest(
        'concurrent calls share the same error when the request fails',
        body: (tester) async {
          // If the in-flight HTTP request fails, every concurrent caller
          // awaiting the shared future should see the same error rather than
          // each firing its own retry request.
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
            delay: const Duration(milliseconds: 100),
          );

          final errors = await Future.wait(
            List.generate(5, (_) async {
              try {
                await tester.client.queryChannels().toList();
                return null;
              } catch (e) {
                return e;
              }
            }),
          );

          // Every caller surfaces the same error type.
          expect(errors, hasLength(5));
          for (final error in errors) {
            expect(error, isA<StreamChatNetworkError>());
          }

          // But only ONE HTTP request was made — the rest piggybacked.
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
        },
      );
    });

    chatClientTest(
      '`.queryUsers`',
      body: (tester) async {
        final users = List.generate(
          3,
          (index) => User(id: 'test-user-id-$index'),
        );

        tester.mockApi(
          (api) => api.user.queryUsers(presence: true),
          result: QueryUsersResponse()..users = users,
        );

        final usersEmitted = expectLater(
          // skipping initial seed event -> {} users
          tester.clientState.usersStream.skip(1),
          emitsInOrder([
            {for (final user in users) user.id: user},
          ]),
        );

        final res = await tester.client.queryUsers();
        expect(res, isNotNull);
        expect(res.users.length, users.length);

        await usersEmitted;

        tester
          ..verifyApi((api) => api.user.queryUsers(presence: true))
          ..verifyNoMoreApiInteractions((api) => api.user);
      },
    );

    chatClientTest(
      '`.queryBannedUsers`',
      body: (tester) async {
        final bans = List.generate(
          3,
          (index) => BannedUser(
            user: User(id: 'test-user-id-$index'),
            bannedBy: User(id: 'test-user-id-${index + 1}'),
          ),
        );

        const cid = 'message:nice-channel';
        final filter = Filter.equal('channel_cid', cid);

        tester.mockApi(
          (api) => api.moderation.queryBannedUsers(filter: filter),
          result: QueryBannedUsersResponse()..bans = bans,
        );

        final res = await tester.client.queryBannedUsers(filter: filter);
        expect(res, isNotNull);
        expect(res.bans.length, bans.length);

        tester
          ..verifyApi((api) => api.moderation.queryBannedUsers(filter: filter))
          ..verifyNoMoreApiInteractions((api) => api.moderation);
      },
    );

    chatClientTest(
      '`.search`',
      body: (tester) async {
        const cid = 'test-type:test-id';
        final filter = Filter.in_('cid', const [cid]);

        final messages = List.generate(
          3,
          (index) => createDefaultGetMessageResponse(
            channel: ChannelModel(cid: cid),
            message: Message(id: 'test-message-id-$index'),
          ),
        );

        tester.mockApi(
          (api) => api.general.searchMessages(filter),
          result: createDefaultSearchMessagesResponse(results: messages),
        );

        final res = await tester.client.search(filter);
        expect(res, isNotNull);
        expect(res.results.length, messages.length);

        tester
          ..verifyApi((api) => api.general.searchMessages(filter))
          ..verifyApi((api) => api.general.getAppSettings())
          ..verifyNoMoreApiInteractions((api) => api.general);
      },
    );

    chatClientTest(
      '`.sendFile`',
      body: (tester) async {
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';
        final file = AttachmentFile(size: 33, path: 'test-file-path');

        const fileUrl = 'test-file-url';

        tester.mockApi(
          (api) => api.fileUploader.sendFile(file, channelId, channelType),
          result: SendFileResponse()..file = fileUrl,
        );

        final res = await tester.client.sendFile(file, channelId, channelType);
        expect(res, isNotNull);
        expect(res.file, fileUrl);

        tester
          ..verifyApi((api) => api.fileUploader.sendFile(file, channelId, channelType))
          ..verifyNoMoreApiInteractions((api) => api.fileUploader);
      },
    );

    chatClientTest(
      '`.sendImage`',
      body: (tester) async {
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';
        final image = AttachmentFile(size: 33, path: 'test-image-path');

        const fileUrl = 'test-image-url';

        tester.mockApi(
          (api) => api.fileUploader.sendImage(image, channelId, channelType),
          result: SendImageResponse()..file = fileUrl,
        );

        final res = await tester.client.sendImage(image, channelId, channelType);
        expect(res, isNotNull);
        expect(res.file, fileUrl);

        tester
          ..verifyApi((api) => api.fileUploader.sendImage(image, channelId, channelType))
          ..verifyNoMoreApiInteractions((api) => api.fileUploader);
      },
    );

    chatClientTest(
      '`.deleteFile`',
      body: (tester) async {
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';
        const fileUrl = 'test-file-url';

        tester.mockApi(
          (api) => api.fileUploader.deleteFile(fileUrl, channelId, channelType),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.deleteFile(fileUrl, channelId, channelType);
        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.fileUploader.deleteFile(fileUrl, channelId, channelType))
          ..verifyNoMoreApiInteractions((api) => api.fileUploader);
      },
    );

    chatClientTest(
      '`.deleteImage`',
      body: (tester) async {
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';
        const imageUrl = 'test-image-url';

        tester.mockApi(
          (api) => api.fileUploader.deleteImage(imageUrl, channelId, channelType),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.deleteImage(imageUrl, channelId, channelType);
        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.fileUploader.deleteImage(imageUrl, channelId, channelType))
          ..verifyNoMoreApiInteractions((api) => api.fileUploader);
      },
    );

    chatClientTest(
      '`.uploadImage`',
      body: (tester) async {
        final image = AttachmentFile(size: 33, path: 'test-image-path');
        const fileUrl = 'test-image-url';

        tester.mockApi(
          (api) => api.fileUploader.uploadImage(image),
          result: UploadImageResponse()..file = fileUrl,
        );

        final res = await tester.client.uploadImage(image);
        expect(res, isNotNull);
        expect(res.file, fileUrl);

        tester
          ..verifyApi((api) => api.fileUploader.uploadImage(image))
          ..verifyNoMoreApiInteractions((api) => api.fileUploader);
      },
    );

    chatClientTest(
      '`.uploadFile`',
      body: (tester) async {
        final file = AttachmentFile(size: 33, path: 'test-file-path');
        const fileUrl = 'test-file-url';

        tester.mockApi(
          (api) => api.fileUploader.uploadFile(file),
          result: UploadFileResponse()..file = fileUrl,
        );

        final res = await tester.client.uploadFile(file);
        expect(res, isNotNull);
        expect(res.file, fileUrl);

        tester
          ..verifyApi((api) => api.fileUploader.uploadFile(file))
          ..verifyNoMoreApiInteractions((api) => api.fileUploader);
      },
    );

    chatClientTest(
      '`.removeImage`',
      body: (tester) async {
        const imageUrl = 'test-image-url';

        tester.mockApi(
          (api) => api.fileUploader.removeImage(imageUrl),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.removeImage(imageUrl);
        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.fileUploader.removeImage(imageUrl))
          ..verifyNoMoreApiInteractions((api) => api.fileUploader);
      },
    );

    chatClientTest(
      '`.removeFile`',
      body: (tester) async {
        const fileUrl = 'test-file-url';

        tester.mockApi(
          (api) => api.fileUploader.removeFile(fileUrl),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.removeFile(fileUrl);
        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.fileUploader.removeFile(fileUrl))
          ..verifyNoMoreApiInteractions((api) => api.fileUploader);
      },
    );

    chatClientTest(
      '`.updateChannel`',
      body: (tester) async {
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';
        const data = {'name': 'test-channel'};

        tester.mockApi(
          (api) => api.channel.updateChannel(channelId, channelType, data),
          result: UpdateChannelResponse()
            ..channel = ChannelModel(
              id: channelId,
              type: channelType,
              extraData: {...data},
            ),
        );

        final res = await tester.client.updateChannel(channelId, channelType, data);
        expect(res, isNotNull);
        expect(res.channel.cid, '$channelType:$channelId');
        expect(res.channel.extraData['name'], 'test-channel');

        tester
          ..verifyApi((api) => api.channel.updateChannel(channelId, channelType, data))
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.updateChannelPartial`',
      body: (tester) async {
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';
        const set = {
          'name': 'Stream Team',
          'profile_image': 'test-profile-image',
        };
        const unset = ['tag', 'last_name'];

        tester.mockApi(
          (api) => api.channel.updateChannelPartial(channelId, channelType, set: set, unset: unset),
          result: createDefaultPartialUpdateChannelResponse(
            channel: ChannelModel(
              id: channelId,
              type: channelType,
              extraData: {...set},
            ),
          ),
        );

        final res = await tester.client.updateChannelPartial(
          channelId,
          channelType,
          set: set,
          unset: unset,
        );
        expect(res, isNotNull);
        expect(res.channel.cid, '$channelType:$channelId');
        expect(res.channel.extraData, set);

        tester
          ..verifyApi((api) => api.channel.updateChannelPartial(channelId, channelType, set: set, unset: unset))
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.addDevice should work`',
      body: (tester) async {
        const id = 'test-device-id';
        const provider = PushProvider.firebase;

        tester.mockApi(
          (api) => api.device.addDevice(id, provider),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.addDevice(id, provider);
        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.device.addDevice(id, provider))
          ..verifyNoMoreApiInteractions((api) => api.device);
      },
    );

    chatClientTest(
      '`.addDevice should work with pushProviderName`',
      body: (tester) async {
        const id = 'test-device-id';
        const provider = PushProvider.firebase;
        const pushProviderName = 'my-custom-config';

        tester.mockApi(
          (api) => api.device.addDevice(
            id,
            provider,
            pushProviderName: pushProviderName,
          ),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.addDevice(
          id,
          provider,
          pushProviderName: pushProviderName,
        );
        expect(res, isNotNull);

        tester
          ..verifyApi(
            (api) => api.device.addDevice(
              id,
              provider,
              pushProviderName: pushProviderName,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.device);
      },
    );

    chatClientTest(
      '`.getDevices`',
      body: (tester) async {
        final devices = List.generate(
          3,
          (index) => Device(
            id: 'test-device-id-$index',
            pushProvider: PushProvider.firebase.name,
          ),
        );

        tester.mockApi(
          (api) => api.device.getDevices(),
          result: ListDevicesResponse()..devices = devices,
        );

        final res = await tester.client.getDevices();
        expect(res, isNotNull);
        expect(res.devices.length, devices.length);

        tester
          ..verifyApi((api) => api.device.getDevices())
          ..verifyNoMoreApiInteractions((api) => api.device);
      },
    );

    chatClientTest(
      '`.removeDevice`',
      body: (tester) async {
        const deviceId = 'test-device-id';

        tester.mockApi(
          (api) => api.device.removeDevice(deviceId),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.removeDevice(deviceId);
        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.device.removeDevice(deviceId))
          ..verifyNoMoreApiInteractions((api) => api.device);
      },
    );

    chatClientTest(
      '`.setPushPreferences`',
      body: (tester) async {
        const pushPreferenceInput = PushPreferenceInput(
          chatLevel: ChatLevel.mentions,
        );

        const channelCid = 'messaging:123';
        const channelPreferenceInput = PushPreferenceInput.channel(
          channelCid: channelCid,
          chatLevel: ChatLevel.mentions,
        );

        const preferences = [pushPreferenceInput, channelPreferenceInput];

        final currentUser = tester.currentUser;
        tester.mockApi(
          (api) => api.device.setPushPreferences(preferences),
          result: UpsertPushPreferencesResponse()
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
          tester.events,
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

        final res = await tester.client.setPushPreferences(preferences);
        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.device.setPushPreferences(preferences))
          ..verifyNoMoreApiInteractions((api) => api.device);
      },
    );

    chatClientTest(
      'should handle push_preference.updated event',
      body: (tester) async {
        final pushPreference = PushPreference(
          chatLevel: ChatLevel.mentions,
          callLevel: CallLevel.all,
          disabledUntil: DateTime.utc(2021, 3),
        );

        final event = createDefaultEvent(
          type: EventType.pushPreferenceUpdated,
          pushPreference: pushPreference,
        );

        // Initially null
        expect(tester.currentUser?.pushPreferences, isNull);

        // Trigger the event
        await tester.emitEvent(event);

        // Should update currentUser.pushPreferences
        final pushPreferences = tester.currentUser?.pushPreferences;
        expect(pushPreferences, isNotNull);
        expect(pushPreferences?.chatLevel, ChatLevel.mentions);
        expect(pushPreferences?.callLevel, CallLevel.all);
        expect(pushPreferences?.disabledUntil, pushPreference.disabledUntil);
      },
    );

    chatClientTest(
      '`.listUserGroups`',
      body: (tester) async {
        const limit = 10;
        const idGt = 'cursor-group-id';
        final createdAtGt = DateTime.utc(2024, 6, 15, 12);
        const teamId = 'test-team-id';

        tester.mockApi(
          (api) => api.userGroups.listUserGroups(
            limit: limit,
            idGt: idGt,
            createdAtGt: createdAtGt,
            teamId: teamId,
          ),
          result: ListUserGroupsResponse()..userGroups = const [],
        );

        final res = await tester.client.listUserGroups(
          limit: limit,
          idGt: idGt,
          createdAtGt: createdAtGt,
          teamId: teamId,
        );
        expect(res, isNotNull);

        tester
          ..verifyApi(
            (api) => api.userGroups.listUserGroups(
              limit: limit,
              idGt: idGt,
              createdAtGt: createdAtGt,
              teamId: teamId,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.userGroups);
      },
    );

    chatClientTest(
      '`.searchUserGroups`',
      body: (tester) async {
        const query = 'eng';
        const limit = 10;
        const nameGt = 'engineering';
        const idGt = 'cursor-group-id';
        const teamId = 'test-team-id';

        tester.mockApi(
          (api) => api.userGroups.searchUserGroups(
            query,
            limit: limit,
            nameGt: nameGt,
            idGt: idGt,
            teamId: teamId,
          ),
          result: SearchUserGroupsResponse()..userGroups = const [],
        );

        final res = await tester.client.searchUserGroups(
          query,
          limit: limit,
          nameGt: nameGt,
          idGt: idGt,
          teamId: teamId,
        );
        expect(res, isNotNull);

        tester
          ..verifyApi(
            (api) => api.userGroups.searchUserGroups(
              query,
              limit: limit,
              nameGt: nameGt,
              idGt: idGt,
              teamId: teamId,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.userGroups);
      },
    );

    chatClientTest(
      '`.getUserGroup`',
      body: (tester) async {
        const id = 'test-group-id';
        const teamId = 'test-team-id';

        tester.mockApi(
          (api) => api.userGroups.getUserGroup(id, teamId: teamId),
          result: GetUserGroupResponse()
            ..userGroup = UserGroup(
              id: id,
              name: 'test-group-name',
              createdAt: DateTime.utc(2024, 1, 1),
              updatedAt: DateTime.utc(2024, 1, 2),
            ),
        );

        final res = await tester.client.getUserGroup(id, teamId: teamId);
        expect(res, isNotNull);
        expect(res.userGroup.id, id);

        tester
          ..verifyApi((api) => api.userGroups.getUserGroup(id, teamId: teamId))
          ..verifyNoMoreApiInteractions((api) => api.userGroups);
      },
    );

    chatClientTest(
      '`.createUserGroup`',
      body: (tester) async {
        const name = 'Engineering';
        const id = 'eng';
        const description = 'Engineering team';
        const teamId = 'test-team-id';
        const memberIds = ['user-1', 'user-2'];

        tester.mockApi(
          (api) => api.userGroups.createUserGroup(
            name,
            id: id,
            description: description,
            teamId: teamId,
            memberIds: memberIds,
          ),
          result: CreateUserGroupResponse()
            ..userGroup = UserGroup(
              id: id,
              name: name,
              description: description,
              teamId: teamId,
              createdAt: DateTime.utc(2024, 1, 1),
              updatedAt: DateTime.utc(2024, 1, 2),
            ),
        );

        final res = await tester.client.createUserGroup(
          name,
          id: id,
          description: description,
          teamId: teamId,
          memberIds: memberIds,
        );
        expect(res, isNotNull);
        expect(res.userGroup.id, id);

        tester
          ..verifyApi(
            (api) => api.userGroups.createUserGroup(
              name,
              id: id,
              description: description,
              teamId: teamId,
              memberIds: memberIds,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.userGroups);
      },
    );

    chatClientTest(
      '`.updateUserGroup`',
      body: (tester) async {
        const id = 'test-group-id';
        const name = 'New Name';
        const description = 'New description';
        const teamId = 'test-team-id';

        tester.mockApi(
          (api) => api.userGroups.updateUserGroup(
            id,
            name: name,
            description: description,
            teamId: teamId,
          ),
          result: UpdateUserGroupResponse()
            ..userGroup = UserGroup(
              id: id,
              name: name,
              description: description,
              teamId: teamId,
              createdAt: DateTime.utc(2024, 1, 1),
              updatedAt: DateTime.utc(2024, 1, 2),
            ),
        );

        final res = await tester.client.updateUserGroup(
          id,
          name: name,
          description: description,
          teamId: teamId,
        );
        expect(res, isNotNull);
        expect(res.userGroup.name, name);

        tester
          ..verifyApi(
            (api) => api.userGroups.updateUserGroup(
              id,
              name: name,
              description: description,
              teamId: teamId,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.userGroups);
      },
    );

    chatClientTest(
      '`.deleteUserGroup`',
      body: (tester) async {
        const id = 'test-group-id';
        const teamId = 'test-team-id';

        tester.mockApi(
          (api) => api.userGroups.deleteUserGroup(id, teamId: teamId),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.deleteUserGroup(id, teamId: teamId);
        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.userGroups.deleteUserGroup(id, teamId: teamId))
          ..verifyNoMoreApiInteractions((api) => api.userGroups);
      },
    );

    chatClientTest(
      '`.addUserGroupMembers`',
      body: (tester) async {
        const id = 'test-group-id';
        const memberIds = ['user-1', 'user-2'];
        const asAdmin = true;
        const teamId = 'test-team-id';

        tester.mockApi(
          (api) => api.userGroups.addUserGroupMembers(
            id,
            memberIds,
            asAdmin: asAdmin,
            teamId: teamId,
          ),
          result: AddUserGroupMembersResponse()
            ..userGroup = UserGroup(
              id: id,
              name: 'test-group-name',
              createdAt: DateTime.utc(2024, 1, 1),
              updatedAt: DateTime.utc(2024, 1, 2),
            ),
        );

        final res = await tester.client.addUserGroupMembers(
          id,
          memberIds,
          asAdmin: asAdmin,
          teamId: teamId,
        );
        expect(res, isNotNull);

        tester
          ..verifyApi(
            (api) => api.userGroups.addUserGroupMembers(
              id,
              memberIds,
              asAdmin: asAdmin,
              teamId: teamId,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.userGroups);
      },
    );

    chatClientTest(
      '`.removeUserGroupMembers`',
      body: (tester) async {
        const id = 'test-group-id';
        const memberIds = ['user-1', 'user-2'];
        const teamId = 'test-team-id';

        tester.mockApi(
          (api) => api.userGroups.removeUserGroupMembers(
            id,
            memberIds,
            teamId: teamId,
          ),
          result: RemoveUserGroupMembersResponse()
            ..userGroup = UserGroup(
              id: id,
              name: 'test-group-name',
              createdAt: DateTime.utc(2024, 1, 1),
              updatedAt: DateTime.utc(2024, 1, 2),
            ),
        );

        final res = await tester.client.removeUserGroupMembers(
          id,
          memberIds,
          teamId: teamId,
        );
        expect(res, isNotNull);

        tester
          ..verifyApi(
            (api) => api.userGroups.removeUserGroupMembers(
              id,
              memberIds,
              teamId: teamId,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.userGroups);
      },
    );

    chatClientTest(
      '`.searchRoles`',
      body: (tester) async {
        const query = 'adm';
        const limit = 10;
        const nameGt = 'admin';
        const roleType = RoleType.user;
        const includeGlobalRoles = true;

        tester.mockApi(
          (api) => api.roles.searchRoles(
            query,
            limit: limit,
            nameGt: nameGt,
            roleType: roleType,
            includeGlobalRoles: includeGlobalRoles,
          ),
          result: SearchRolesResponse()..roles = const [],
        );

        final res = await tester.client.searchRoles(
          query,
          limit: limit,
          nameGt: nameGt,
          roleType: roleType,
          includeGlobalRoles: includeGlobalRoles,
        );
        expect(res, isNotNull);

        tester
          ..verifyApi(
            (api) => api.roles.searchRoles(
              query,
              limit: limit,
              nameGt: nameGt,
              roleType: roleType,
              includeGlobalRoles: includeGlobalRoles,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.roles);
      },
    );

    chatClientTest(
      '`.devToken`',
      body: (tester) async {
        const userId = 'test-user-id';

        final token = tester.client.devToken(userId);

        expect(token, isNotNull);
        expect(token.userId, userId);
        expect(token.authType, AuthType.jwt);
      },
    );

    group('`.channel`', () {
      chatClientTest(
        'should return back a new channel instance',
        body: (tester) {
          final channel = tester.client.channel(
            _channelType,
            id: _channelId,
            extraData: _channelData,
          );

          expect(channel, isNotNull);
          expect(channel.type, _channelType);
          expect(channel.id, _channelId);
          expect(channel.cid, _channelCid);
          expect(channel.extraData, _channelData);
        },
      );

      chatClientTest(
        'should return back in memory channel instance if available',
        body: (tester) async {
          final channel = tester.client.channel(
            _channelType,
            id: _channelId,
            extraData: _channelData,
          );

          final channelState = createDefaultChannelState(
            channel: createDefaultChannelModel(cid: _channelCid),
          );

          tester.mockApi(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: _channelData,
              state: true,
              watch: true,
              presence: false,
            ),
            result: channelState,
          );

          final channelsEmission = expectLater(
            tester.clientState.channelsStream.skip(1),
            emitsInOrder([
              {_channelCid: isCorrectChannelFor(channelState)},
            ]),
          );

          await channel.watch();
          await channelsEmission;

          final newChannel = tester.client.channel(_channelType, id: _channelId);
          expect(newChannel, channel);

          tester.verifyApi(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: _channelData,
              state: true,
              watch: true,
              presence: false,
            ),
          );
        },
      );
    });

    chatClientTest(
      '`.createChannel`',
      body: (tester) async {
        final channelState = createDefaultChannelState(
          channel: createDefaultChannelModel(cid: _channelCid, extraData: _channelData),
        );

        tester.mockApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: _channelData,
            state: false,
          ),
          result: channelState,
        );

        final res = await tester.client.createChannel(
          _channelType,
          channelId: _channelId,
          channelData: _channelData,
        );

        expect(res, isNotNull);
        expect(res.channel, isNotNull);
        final channel = res.channel!;
        expect(channel.type, _channelType);
        expect(channel.id, _channelId);
        expect(channel.cid, _channelCid);
        expect(channel.extraData, _channelData);

        tester
          ..verifyApi(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: _channelData,
              state: false,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.watchChannel`',
      body: (tester) async {
        final channelState = createDefaultChannelState(
          channel: createDefaultChannelModel(cid: _channelCid, extraData: _channelData),
        );

        tester.mockApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: _channelData,
            watch: true,
          ),
          result: channelState,
        );

        final res = await tester.client.watchChannel(
          _channelType,
          channelId: _channelId,
          channelData: _channelData,
        );

        expect(res, isNotNull);
        expect(res.channel, isNotNull);
        final channel = res.channel!;
        expect(channel.type, _channelType);
        expect(channel.id, _channelId);
        expect(channel.cid, _channelCid);
        expect(channel.extraData, _channelData);

        tester
          ..verifyApi(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: _channelData,
              watch: true,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.queryChannel`',
      body: (tester) async {
        final channelState = createDefaultChannelState(
          channel: createDefaultChannelModel(cid: _channelCid, extraData: _channelData),
        );

        tester.mockApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: _channelData,
          ),
          result: channelState,
        );

        final res = await tester.client.queryChannel(
          _channelType,
          channelId: _channelId,
          channelData: _channelData,
        );

        expect(res, isNotNull);
        expect(res.channel, isNotNull);
        final channel = res.channel!;
        expect(channel.type, _channelType);
        expect(channel.id, _channelId);
        expect(channel.cid, _channelCid);
        expect(channel.extraData, _channelData);

        tester
          ..verifyApi(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: _channelData,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.queryMembers`',
      body: (tester) async {
        final members = List.generate(
          3,
          (index) => Member(userId: 'test-user-id-$index'),
        );

        tester.mockApi(
          (api) => api.general.queryMembers(_channelType),
          result: QueryMembersResponse()..members = members,
        );

        final res = await tester.client.queryMembers(_channelType);
        expect(res, isNotNull);
        expect(res.members.length, members.length);

        tester
          ..verifyApi((api) => api.general.queryMembers(_channelType))
          ..verifyApi((api) => api.general.getAppSettings())
          ..verifyNoMoreApiInteractions((api) => api.general);
      },
    );

    chatClientTest(
      '`.hideChannel`',
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.hideChannel(_channelId, _channelType),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.hideChannel(_channelId, _channelType);

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.channel.hideChannel(_channelId, _channelType))
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.showChannel`',
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.showChannel(_channelId, _channelType),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.showChannel(_channelId, _channelType);

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.channel.showChannel(_channelId, _channelType))
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.deleteChannel`',
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.deleteChannel(_channelId, _channelType),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.deleteChannel(_channelId, _channelType);

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.channel.deleteChannel(_channelId, _channelType))
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.truncateChannel`',
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.truncateChannel(_channelId, _channelType),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.truncateChannel(_channelId, _channelType);

        expect(res, isNotNull);

        tester
          ..verifyApi(
            (api) => api.channel.truncateChannel(_channelId, _channelType),
          )
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.muteChannel`',
      body: (tester) async {
        tester.mockApi(
          (api) => api.moderation.muteChannel(_channelCid),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.muteChannel(_channelCid);

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.moderation.muteChannel(_channelCid))
          ..verifyNoMoreApiInteractions((api) => api.moderation);
      },
    );

    chatClientTest(
      '`.unmuteChannel`',
      body: (tester) async {
        tester.mockApi(
          (api) => api.moderation.unmuteChannel(_channelCid),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.unmuteChannel(_channelCid);

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.moderation.unmuteChannel(_channelCid))
          ..verifyNoMoreApiInteractions((api) => api.moderation);
      },
    );

    chatClientTest(
      '`.partialMemberUpdate with userId`',
      body: (tester) async {
        const otherUserId = 'test-other-user-id';
        const set = {'pinned': true};
        const unset = ['pinned'];

        tester.mockApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            set: set,
            unset: unset,
          ),
          result: createDefaultPartialUpdateMemberResponse(
            channelMember: Member(userId: otherUserId),
          ),
        );

        final res = await tester.client.partialMemberUpdate(
          channelId: _channelId,
          channelType: _channelType,
          set: set,
          unset: unset,
        );

        expect(res, isNotNull);
        expect(res.channelMember.userId, otherUserId);

        tester
          ..verifyApi(
            (api) => api.channel.updateMemberPartial(
              channelId: _channelId,
              channelType: _channelType,
              set: set,
              unset: unset,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.partialMemberUpdate with current user`',
      body: (tester) async {
        const set = {'pinned': true};
        const unset = ['pinned'];

        tester.mockApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            set: set,
            unset: unset,
          ),
          result: createDefaultPartialUpdateMemberResponse(
            channelMember: Member(userId: tester.user.id),
          ),
        );

        final res = await tester.client.partialMemberUpdate(
          channelId: _channelId,
          channelType: _channelType,
          set: set,
          unset: unset,
        );

        expect(res, isNotNull);
        expect(res.channelMember.userId, tester.user.id);
        tester
          ..verifyApi(
            (api) => api.channel.updateMemberPartial(
              channelId: _channelId,
              channelType: _channelType,
              set: set,
              unset: unset,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.pinChannel`',
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            set: const MemberUpdatePayload(pinned: true).toJson(),
          ),
          result: createDefaultPartialUpdateMemberResponse(
            channelMember: Member(userId: tester.user.id, pinnedAt: DateTime.utc(2021, 3)),
          ),
        );

        final res = await tester.client.pinChannel(
          channelId: _channelId,
          channelType: _channelType,
        );

        expect(res, isNotNull);

        tester
          ..verifyApi(
            (api) => api.channel.updateMemberPartial(
              channelId: _channelId,
              channelType: _channelType,
              set: const MemberUpdatePayload(pinned: true).toJson(),
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.unpinChannel`',
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            unset: [MemberUpdateType.pinned.name],
          ),
          result: createDefaultPartialUpdateMemberResponse(
            channelMember: Member(userId: tester.user.id, pinnedAt: DateTime.utc(2021, 3)),
          ),
        );

        final res = await tester.client.unpinChannel(
          channelId: _channelId,
          channelType: _channelType,
        );

        expect(res, isNotNull);

        tester
          ..verifyApi(
            (api) => api.channel.updateMemberPartial(
              channelId: _channelId,
              channelType: _channelType,
              unset: [MemberUpdateType.pinned.name],
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.archiveChannel`',
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            set: const MemberUpdatePayload(archived: true).toJson(),
          ),
          result: createDefaultPartialUpdateMemberResponse(
            channelMember: Member(userId: tester.user.id, archivedAt: DateTime.utc(2021, 3)),
          ),
        );

        final res = await tester.client.archiveChannel(
          channelId: _channelId,
          channelType: _channelType,
        );

        expect(res, isNotNull);

        tester
          ..verifyApi(
            (api) => api.channel.updateMemberPartial(
              channelId: _channelId,
              channelType: _channelType,
              set: const MemberUpdatePayload(archived: true).toJson(),
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.unarchiveChannel`',
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            unset: [MemberUpdateType.archived.name],
          ),
          result: createDefaultPartialUpdateMemberResponse(
            channelMember: Member(userId: tester.user.id, pinnedAt: DateTime.utc(2021, 3)),
          ),
        );

        final res = await tester.client.unarchiveChannel(
          channelId: _channelId,
          channelType: _channelType,
        );

        expect(res, isNotNull);

        tester
          ..verifyApi(
            (api) => api.channel.updateMemberPartial(
              channelId: _channelId,
              channelType: _channelType,
              unset: [MemberUpdateType.archived.name],
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.acceptChannelInvite`',
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.acceptChannelInvite(_channelId, _channelType),
          result: AcceptInviteResponse()..channel = createDefaultChannelModel(cid: _channelCid),
        );

        final res = await tester.client.acceptChannelInvite(_channelId, _channelType);
        expect(res, isNotNull);
        expect(res.channel.cid, _channelCid);

        tester
          ..verifyApi((api) => api.channel.acceptChannelInvite(_channelId, _channelType))
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.rejectChannelInvite`',
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.rejectChannelInvite(_channelId, _channelType),
          result: RejectInviteResponse()..channel = createDefaultChannelModel(cid: _channelCid),
        );

        final res = await tester.client.rejectChannelInvite(_channelId, _channelType);
        expect(res, isNotNull);
        expect(res.channel.cid, _channelCid);

        tester
          ..verifyApi((api) => api.channel.rejectChannelInvite(_channelId, _channelType))
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.addChannelMembers`',
      body: (tester) async {
        final members = List.generate(
          3,
          (index) => Member(userId: 'test-user-id-$index'),
        );

        final memberIds = members.map((e) => e.userId!).toList(growable: false);

        tester.mockApi(
          (api) => api.channel.addMembers(_channelId, _channelType, memberIds),
          result: createDefaultAddMembersResponse(
            channel: createDefaultChannelModel(cid: _channelCid),
            members: members,
          ),
        );

        final res = await tester.client.addChannelMembers(
          _channelId,
          _channelType,
          memberIds,
        );

        expect(res, isNotNull);
        expect(res.channel.cid, _channelCid);
        expect(res.members.length, memberIds.length);

        tester
          ..verifyApi(
            (api) => api.channel.addMembers(_channelId, _channelType, memberIds),
          )
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.addChannelMembers` with hideHistoryBefore',
      body: (tester) async {
        final members = List.generate(
          3,
          (index) => Member(userId: 'test-user-id-$index'),
        );

        final memberIds = members.map((e) => e.userId!).toList(growable: false);
        final hideHistoryBefore = DateTime.parse('2024-01-01T00:00:00Z');

        tester.mockApi(
          (api) => api.channel.addMembers(
            _channelId,
            _channelType,
            memberIds,
            hideHistoryBefore: hideHistoryBefore,
          ),
          result: createDefaultAddMembersResponse(
            channel: createDefaultChannelModel(cid: _channelCid),
            members: members,
          ),
        );

        final res = await tester.client.addChannelMembers(
          _channelId,
          _channelType,
          memberIds,
          hideHistoryBefore: hideHistoryBefore,
        );

        expect(res, isNotNull);
        expect(res.channel.cid, _channelCid);
        expect(res.members.length, memberIds.length);

        tester
          ..verifyApi(
            (api) => api.channel.addMembers(
              _channelId,
              _channelType,
              memberIds,
              hideHistoryBefore: hideHistoryBefore,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.removeChannelMembers`',
      body: (tester) async {
        final members = List.generate(
          3,
          (index) => Member(userId: 'test-user-id-$index'),
        );

        final memberIds = members.map((e) => e.userId!).toList(growable: false);

        tester.mockApi(
          (api) => api.channel.removeMembers(_channelId, _channelType, memberIds),
          result: RemoveMembersResponse()
            ..channel = createDefaultChannelModel(cid: _channelCid)
            ..members = members,
        );

        final res = await tester.client.removeChannelMembers(
          _channelId,
          _channelType,
          memberIds,
        );

        expect(res, isNotNull);
        expect(res.channel.cid, _channelCid);
        expect(res.members.length, memberIds.length);

        tester
          ..verifyApi(
            (api) => api.channel.removeMembers(_channelId, _channelType, memberIds),
          )
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.inviteChannelMembers`',
      body: (tester) async {
        final members = List.generate(
          3,
          (index) => Member(userId: 'test-user-id-$index'),
        );

        final memberIds = members.map((e) => e.userId!).toList(growable: false);

        tester.mockApi(
          (api) => api.channel.inviteChannelMembers(_channelId, _channelType, memberIds),
          result: InviteMembersResponse()
            ..channel = createDefaultChannelModel(cid: _channelCid)
            ..members = members,
        );

        final res = await tester.client.inviteChannelMembers(
          _channelId,
          _channelType,
          memberIds,
        );

        expect(res, isNotNull);
        expect(res.channel.cid, _channelCid);
        expect(res.members.length, memberIds.length);

        tester
          ..verifyApi((api) => api.channel.inviteChannelMembers(_channelId, _channelType, memberIds))
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.stopChannelWatching`',
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.stopWatching(_channelId, _channelType),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.stopChannelWatching(_channelId, _channelType);
        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.channel.stopWatching(_channelId, _channelType))
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.sendAction`',
      body: (tester) async {
        const messageId = 'test-message-id';
        const formData = {'key': 'value'};

        tester.mockApi(
          (api) => api.message.sendAction(_channelId, _channelType, messageId, formData),
          result: createDefaultSendActionResponse(),
        );

        final res = await tester.client.sendAction(
          _channelId,
          _channelType,
          messageId,
          formData,
        );

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.message.sendAction(_channelId, _channelType, messageId, formData))
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      '`.markChannelRead`',
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.markRead(_channelId, _channelType),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.markChannelRead(_channelId, _channelType);

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.channel.markRead(_channelId, _channelType))
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.markChannelUnread`',
      body: (tester) async {
        const messageId = 'test-message-id';

        tester.mockApi(
          (api) => api.channel.markUnread(_channelId, _channelType, messageId),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.markChannelUnread(
          _channelId,
          _channelType,
          messageId,
        );

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.channel.markUnread(_channelId, _channelType, messageId))
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.markChannelUnreadByTimestamp`',
      body: (tester) async {
        final timestamp = DateTime.parse('2024-01-01T00:00:00Z');

        tester.mockApi(
          (api) => api.channel.markUnreadByTimestamp(
            _channelId,
            _channelType,
            timestamp,
          ),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.markChannelUnreadByTimestamp(
          _channelId,
          _channelType,
          timestamp,
        );

        expect(res, isNotNull);

        tester
          ..verifyApi(
            (api) => api.channel.markUnreadByTimestamp(
              _channelId,
              _channelType,
              timestamp,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.createPoll`',
      body: (tester) async {
        final poll = createDefaultPoll();

        tester.mockApi(
          (api) => api.polls.createPoll(poll),
          result: CreatePollResponse()..poll = poll,
        );

        final res = await tester.client.createPoll(poll);
        expect(res, isNotNull);
        expect(res.poll, poll);

        tester
          ..verifyApi((api) => api.polls.createPoll(poll))
          ..verifyNoMoreApiInteractions((api) => api.polls);
      },
    );

    chatClientTest(
      '`.getPoll`',
      body: (tester) async {
        const pollId = 'test-poll-id';
        final poll = createDefaultPoll(id: pollId);

        tester.mockApi(
          (api) => api.polls.getPoll(pollId),
          result: GetPollResponse()..poll = poll,
        );

        final res = await tester.client.getPoll(pollId);
        expect(res, isNotNull);
        expect(res.poll, poll);

        tester
          ..verifyApi((api) => api.polls.getPoll(pollId))
          ..verifyNoMoreApiInteractions((api) => api.polls);
      },
    );

    chatClientTest(
      '`.updatePoll`',
      body: (tester) async {
        final poll = createDefaultPoll(id: 'test-poll-id');

        tester.mockApi(
          (api) => api.polls.updatePoll(poll),
          result: createDefaultUpdatePollResponse(poll: poll),
        );

        final res = await tester.client.updatePoll(poll);
        expect(res, isNotNull);
        expect(res.poll, poll);

        tester
          ..verifyApi((api) => api.polls.updatePoll(poll))
          ..verifyNoMoreApiInteractions((api) => api.polls);
      },
    );

    chatClientTest(
      '`.partialUpdatePoll`',
      body: (tester) async {
        const pollId = 'test-poll-id';
        final set = {'name': 'What is your favorite color?'};
        final unset = <String>[];

        final poll = createDefaultPoll(id: pollId, name: set['name']!);

        tester.mockApi(
          (api) => api.polls.partialUpdatePoll(pollId, set: set, unset: unset),
          result: createDefaultUpdatePollResponse(poll: poll),
        );

        final res = await tester.client.partialUpdatePoll(pollId, set: set, unset: unset);
        expect(res, isNotNull);
        expect(res.poll.id, pollId);
        expect(res.poll.name, set['name']);

        tester
          ..verifyApi((api) => api.polls.partialUpdatePoll(pollId, set: set, unset: unset))
          ..verifyNoMoreApiInteractions((api) => api.polls);
      },
    );

    chatClientTest(
      '`.deletePoll`',
      body: (tester) async {
        const pollId = 'test-poll-id';

        tester.mockApi(
          (api) => api.polls.deletePoll(pollId),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.deletePoll(pollId);
        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.polls.deletePoll(pollId))
          ..verifyNoMoreApiInteractions((api) => api.polls);
      },
    );

    chatClientTest(
      '`.closePoll`',
      body: (tester) async {
        const pollId = 'test-poll-id';

        tester.mockApi(
          (api) => api.polls.partialUpdatePoll(pollId, set: {'is_closed': true}),
          result: createDefaultUpdatePollResponse(),
        );

        final res = await tester.client.closePoll(pollId);
        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.polls.partialUpdatePoll(pollId, set: {'is_closed': true}))
          ..verifyNoMoreApiInteractions((api) => api.polls);
      },
    );

    chatClientTest(
      '`.createPollOption`',
      body: (tester) async {
        const pollId = 'test-poll-id';
        final option = createDefaultPollOption();

        tester.mockApi(
          (api) => api.polls.createPollOption(pollId, option),
          result: CreatePollOptionResponse()..pollOption = option,
        );

        final res = await tester.client.createPollOption(pollId, option);
        expect(res, isNotNull);
        expect(res.pollOption, option);

        tester
          ..verifyApi((api) => api.polls.createPollOption(pollId, option))
          ..verifyNoMoreApiInteractions((api) => api.polls);
      },
    );

    chatClientTest(
      '`.getPollOption`',
      body: (tester) async {
        const pollId = 'test-poll-id';
        const optionId = 'test-option-id';
        final option = createDefaultPollOption(id: optionId);

        tester.mockApi(
          (api) => api.polls.getPollOption(pollId, optionId),
          result: GetPollOptionResponse()..pollOption = option,
        );

        final res = await tester.client.getPollOption(pollId, optionId);
        expect(res, isNotNull);
        expect(res.pollOption, option);

        tester
          ..verifyApi((api) => api.polls.getPollOption(pollId, optionId))
          ..verifyNoMoreApiInteractions((api) => api.polls);
      },
    );

    chatClientTest(
      '`.updatePollOption`',
      body: (tester) async {
        const pollId = 'test-poll-id';
        final option = createDefaultPollOption(id: 'test-option-id');

        tester.mockApi(
          (api) => api.polls.updatePollOption(pollId, option),
          result: UpdatePollOptionResponse()..pollOption = option,
        );

        final res = await tester.client.updatePollOption(pollId, option);
        expect(res, isNotNull);
        expect(res.pollOption, option);

        tester
          ..verifyApi((api) => api.polls.updatePollOption(pollId, option))
          ..verifyNoMoreApiInteractions((api) => api.polls);
      },
    );

    chatClientTest(
      '`.deletePollOption`',
      body: (tester) async {
        const pollId = 'test-poll-id';
        const optionId = 'test-option-id';

        tester.mockApi(
          (api) => api.polls.deletePollOption(pollId, optionId),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.deletePollOption(pollId, optionId);
        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.polls.deletePollOption(pollId, optionId))
          ..verifyNoMoreApiInteractions((api) => api.polls);
      },
    );

    chatClientTest(
      '`.castPollVote`',
      body: (tester) async {
        const messageId = 'test-message-id';
        const pollId = 'test-poll-id';
        const optionId = 'test-option-id';
        final vote = createDefaultPollVote(optionId: optionId);

        // Custom matcher to check if the Vote object has the specified id
        Matcher matchesVoteOption(String expected) => predicate<PollVote>(
          (vote) => vote.optionId == expected,
          'Vote with option $expected',
        );

        tester.mockApi(
          (api) => api.polls.castPollVote(messageId, pollId, any(that: matchesVoteOption(optionId))),
          result: createDefaultCastPollVoteResponse(vote: vote),
        );

        final res = await tester.client.castPollVote(messageId, pollId, optionId: optionId);
        expect(res, isNotNull);
        expect(res.vote, vote);

        tester
          ..verifyApi((api) => api.polls.castPollVote(messageId, pollId, any(that: matchesVoteOption(optionId))))
          ..verifyNoMoreApiInteractions((api) => api.polls);
      },
    );

    chatClientTest(
      '`.addPollAnswer`',
      body: (tester) async {
        const messageId = 'test-message-id';
        const pollId = 'test-poll-id';
        const answerText = 'Red';
        final vote = createDefaultPollVote(answerText: answerText);

        // Custom matcher to check if the Vote object has the specified id
        Matcher matchesVoteAnswer(String expected) => predicate<PollVote>(
          (vote) => vote.answerText == expected,
          'Vote with answer $expected',
        );

        tester.mockApi(
          (api) => api.polls.castPollVote(messageId, pollId, any(that: matchesVoteAnswer(answerText))),
          result: createDefaultCastPollVoteResponse(vote: vote),
        );

        final res = await tester.client.addPollAnswer(messageId, pollId, answerText: answerText);
        expect(res, isNotNull);
        expect(res.vote, vote);

        tester
          ..verifyApi((api) => api.polls.castPollVote(messageId, pollId, any(that: matchesVoteAnswer(answerText))))
          ..verifyNoMoreApiInteractions((api) => api.polls);
      },
    );

    chatClientTest(
      '`.removePollVote`',
      body: (tester) async {
        const messageId = 'test-message-id';
        const pollId = 'test-poll-id';
        const voteId = 'test-vote-id';

        tester.mockApi(
          (api) => api.polls.removePollVote(messageId, pollId, voteId),
          result: RemovePollVoteResponse(),
        );

        final res = await tester.client.removePollVote(messageId, pollId, voteId);
        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.polls.removePollVote(messageId, pollId, voteId))
          ..verifyNoMoreApiInteractions((api) => api.polls);
      },
    );

    chatClientTest(
      '`.queryPolls`',
      body: (tester) async {
        final filter = Filter.in_('id', const ['test-poll-id']);
        final sort = [const SortOption<Poll>.desc('created_at')];
        const pagination = PaginationParams(limit: 20);

        final polls = List.generate(
          pagination.limit,
          (index) => createDefaultPoll(id: 'test-poll-id-$index'),
        );

        tester.mockApi(
          (api) => api.polls.queryPolls(
            filter: filter,
            sort: sort,
            pagination: pagination,
          ),
          result: QueryPollsResponse()..polls = polls,
        );

        final res = await tester.client.queryPolls(
          filter: filter,
          sort: sort,
          pagination: pagination,
        );
        expect(res, isNotNull);
        expect(res.polls.length, polls.length);

        tester
          ..verifyApi(
            (api) => api.polls.queryPolls(
              filter: filter,
              sort: sort,
              pagination: pagination,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.polls);
      },
    );

    chatClientTest(
      '`.queryPollVotes`',
      body: (tester) async {
        const pollId = 'test-poll-id';
        final filter = Filter.in_('id', const ['test-vote-id']);
        final sort = [const SortOption<PollVote>.desc('created_at')];
        const pagination = PaginationParams(limit: 20);

        final votes = List.generate(
          pagination.limit,
          (index) => createDefaultPollVote(id: 'test-vote-id-$index', answerText: 'Red'),
        );

        tester.mockApi(
          (api) => api.polls.queryPollVotes(
            pollId,
            filter: filter,
            sort: sort,
            pagination: pagination,
          ),
          result: QueryPollVotesResponse()..votes = votes,
        );

        final res = await tester.client.queryPollVotes(
          pollId,
          filter: filter,
          sort: sort,
          pagination: pagination,
        );
        expect(res, isNotNull);
        expect(res.votes.length, votes.length);

        tester
          ..verifyApi(
            (api) => api.polls.queryPollVotes(
              pollId,
              filter: filter,
              sort: sort,
              pagination: pagination,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.polls);
      },
    );

    chatClientTest(
      '`.updateUser`',
      body: (tester) async {
        final user = User(
          id: 'test-user-id',
          extraData: const {'name': 'test-user'},
        );

        tester.mockApi(
          (api) => api.user.updateUsers([user]),
          result: createDefaultUpdateUsersResponse(users: {user.id: user}),
        );

        final res = await tester.client.updateUser(user);

        expect(res, isNotNull);
        expect(res.users, {user.id: user});

        tester
          ..verifyApi((api) => api.user.updateUsers([user]))
          ..verifyNoMoreApiInteractions((api) => api.user);
      },
    );

    chatClientTest(
      '`.partialUpdateUser`',
      body: (tester) async {
        const userId = 'test-user-id';

        final set = {'color': 'yellow'};
        final unset = <String>[];

        final partialUpdateRequest = PartialUpdateUserRequest(
          id: userId,
          set: set,
          unset: unset,
        );

        final updatedUser = User(
          id: userId,
          extraData: {'color': set['color']},
        );

        tester.mockApi(
          (api) => api.user.partialUpdateUsers([partialUpdateRequest]),
          result: createDefaultUpdateUsersResponse(users: {updatedUser.id: updatedUser}),
        );

        final res = await tester.client.partialUpdateUser(
          userId,
          set: set,
          unset: unset,
        );

        expect(res, isNotNull);
        expect(res.users, {updatedUser.id: updatedUser});

        tester
          ..verifyApi((api) => api.user.partialUpdateUsers([partialUpdateRequest]))
          ..verifyNoMoreApiInteractions((api) => api.user);
      },
    );

    chatClientTest(
      '`.banUser`',
      body: (tester) async {
        const userId = 'test-user-id';

        tester.mockApi(
          (api) => api.moderation.banUser(userId, options: any(named: 'options')),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.banUser(userId);

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.moderation.banUser(userId, options: any(named: 'options')))
          ..verifyNoMoreApiInteractions((api) => api.moderation);
      },
    );

    chatClientTest(
      '`.unbanUser`',
      body: (tester) async {
        const userId = 'test-user-id';

        tester.mockApi(
          (api) => api.moderation.unbanUser(userId, options: any(named: 'options')),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.unbanUser(userId);

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.moderation.unbanUser(userId, options: any(named: 'options')))
          ..verifyNoMoreApiInteractions((api) => api.moderation);
      },
    );

    chatClientTest(
      '`.blockUser`',
      body: (tester) async {
        const userId = 'test-user-id';

        tester.mockApi(
          (api) => api.user.blockUser(userId),
          result: UserBlockResponse.fromJson({
            'blocked_by_user_id': 'deven',
            'blocked_user_id': 'jaap',
            'created_at': '2024-10-01 12:45:23.456',
          }),
        );

        final res = await tester.client.blockUser(userId);

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.user.blockUser(userId))
          ..verifyNoMoreApiInteractions((api) => api.user);
      },
    );

    chatClientTest(
      '`.unblockUser`',
      body: (tester) async {
        const userId = 'test-user-id';

        tester.mockApi(
          (api) => api.user.unblockUser(userId),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.unblockUser(userId);

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.user.unblockUser(userId))
          ..verifyNoMoreApiInteractions((api) => api.user);
      },
    );

    chatClientTest(
      '`.queryBlockedUsers`',
      body: (tester) async {
        final users = List.generate(
          3,
          (index) => User(id: 'test-user-id-$index'),
        );

        tester.mockApi(
          (api) => api.user.queryBlockedUsers(),
          result: createDefaultBlockedUsersResponse(
            blocks: [
              UserBlock(user: users[0], blockedUser: users[1]),
              UserBlock(user: users[0], blockedUser: users[2]),
            ],
          ),
        );

        final res = await tester.client.queryBlockedUsers();
        expect(res, isNotNull);
        expect(res.blocks.length, 2);

        tester
          ..verifyApi((api) => api.user.queryBlockedUsers())
          ..verifyNoMoreApiInteractions((api) => api.user);
      },
    );

    group('Block user state management', () {
      chatClientTest(
        'blockUser should update blockedUserIds on client state',
        body: (tester) async {
          final testUser = OwnUser(id: 'test-user');
          const userId = 'blocked-user-id';

          // Verify initial state
          expect(tester.currentUser?.blockedUserIds, isEmpty);

          tester.mockApi(
            (api) => api.user.blockUser(userId),
            result: createDefaultUserBlockResponse(
              blockedUserId: userId,
              blockedByUserId: testUser.id,
            ),
          );

          await tester.client.blockUser(userId);

          // Verify - should now include the blocked user ID
          expect(tester.currentUser?.blockedUserIds, contains(userId));
          tester
            ..verifyApi((api) => api.user.blockUser(userId))
            ..verifyNoMoreApiInteractions((api) => api.user);
        },
      );

      chatClientTest(
        'blockUser should not duplicate existing blocked user IDs',
        body: (tester) async {
          const userId = 'blocked-user-id';
          tester.clientState.blockedUserIds = const [userId];

          // Verify the user is already in the blocked list
          expect(tester.currentUser?.blockedUserIds, contains(userId));

          tester.mockApi(
            (api) => api.user.blockUser(userId),
            result: createDefaultUserBlockResponse(
              blockedUserId: userId,
              blockedByUserId: tester.currentUser!.id,
            ),
          );

          await tester.client.blockUser(userId);

          // Verify - should still have only one entry
          expect(tester.currentUser?.blockedUserIds, contains(userId));
          expect(tester.currentUser?.blockedUserIds.length, 1);
          tester
            ..verifyApi((api) => api.user.blockUser(userId))
            ..verifyNoMoreApiInteractions((api) => api.user);
        },
      );

      chatClientTest(
        'unblockUser should remove user from blockedUserIds',
        body: (tester) async {
          const blockedUserId = 'blocked-user-id';
          const otherBlockedId = 'other-blocked-id';
          tester.clientState.blockedUserIds = const [blockedUserId, otherBlockedId];

          // Verify initial state includes both blocked IDs
          expect(
            tester.currentUser?.blockedUserIds,
            containsAll([blockedUserId, otherBlockedId]),
          );

          tester.mockApi(
            (api) => api.user.unblockUser(blockedUserId),
            result: createDefaultEmptyResponse(),
          );

          await tester.client.unblockUser(blockedUserId);

          // Verify - blockedUserId should be removed
          expect(
            tester.currentUser?.blockedUserIds,
            contains(otherBlockedId),
          );

          expect(
            tester.currentUser?.blockedUserIds,
            isNot(contains(blockedUserId)),
          );

          tester
            ..verifyApi((api) => api.user.unblockUser(blockedUserId))
            ..verifyNoMoreApiInteractions((api) => api.user);
        },
      );

      chatClientTest(
        'unblockUser should be resilient if user ID not in blocked list',
        body: (tester) async {
          const nonBlockedUserId = 'not-in-list';
          const otherBlockedId = 'other-blocked-id';
          tester.clientState.blockedUserIds = const [otherBlockedId];

          // Verify initial state
          expect(
            tester.currentUser?.blockedUserIds,
            contains(otherBlockedId),
          );

          expect(
            tester.currentUser?.blockedUserIds,
            isNot(contains(nonBlockedUserId)),
          );

          tester.mockApi(
            (api) => api.user.unblockUser(nonBlockedUserId),
            result: createDefaultEmptyResponse(),
          );

          await tester.client.unblockUser(nonBlockedUserId);

          // Verify - should remain unchanged
          expect(tester.currentUser?.blockedUserIds, contains(otherBlockedId));
          expect(tester.currentUser?.blockedUserIds, isNot(contains(nonBlockedUserId)));
          tester
            ..verifyApi((api) => api.user.unblockUser(nonBlockedUserId))
            ..verifyNoMoreApiInteractions((api) => api.user);
        },
      );

      chatClientTest(
        'queryBlockedUsers should update client state with blockedUserIds',
        body: (tester) async {
          const blockedId1 = 'blocked-1';
          const blockedId2 = 'blocked-2';

          // Verify initial state
          expect(tester.currentUser?.blockedUserIds, isEmpty);

          // Create mock users
          final user = tester.user;
          final blockedUser1 = User(id: 'blocked-user-1');
          final blockedUser2 = User(id: 'blocked-user-2');

          // Mock the queryBlockedUsers API call
          tester.mockApi(
            (api) => api.user.queryBlockedUsers(),
            result: createDefaultBlockedUsersResponse(
              blocks: [
                UserBlock(
                  user: user,
                  userId: user.id,
                  blockedUser: blockedUser1,
                  blockedUserId: blockedId1,
                ),
                UserBlock(
                  user: user,
                  userId: user.id,
                  blockedUser: blockedUser2,
                  blockedUserId: blockedId2,
                ),
              ],
            ),
          );

          await tester.client.queryBlockedUsers();

          // Verify - should now include both blocked IDs
          expect(
            tester.currentUser?.blockedUserIds,
            containsAll([blockedId1, blockedId2]),
          );

          tester
            ..verifyApi((api) => api.user.queryBlockedUsers())
            ..verifyNoMoreApiInteractions((api) => api.user);
        },
      );
    });

    chatClientTest(
      '`.getUnreadCount`',
      body: (tester) async {
        tester.mockApi(
          (api) => api.user.getUnreadCount(),
          result: createDefaultGetUnreadCountResponse(
            totalUnreadCount: 42,
            totalUnreadThreadsCount: 8,
            channels: [
              UnreadCountsChannel(
                channelId: 'messaging:test-channel-1',
                unreadCount: 10,
                lastRead: DateTime.utc(2021, 3),
              ),
              UnreadCountsChannel(
                channelId: 'messaging:test-channel-2',
                unreadCount: 15,
                lastRead: DateTime.utc(2021, 3),
              ),
            ],
            threads: [
              UnreadCountsThread(
                unreadCount: 3,
                lastRead: DateTime.utc(2021, 3),
                lastReadMessageId: 'message-1',
                parentMessageId: 'parent-message-1',
              ),
              UnreadCountsThread(
                unreadCount: 5,
                lastRead: DateTime.utc(2021, 3),
                lastReadMessageId: 'message-2',
                parentMessageId: 'parent-message-2',
              ),
            ],
          ),
        );

        final res = await tester.client.getUnreadCount();

        expect(res, isNotNull);
        expect(res.totalUnreadCount, 42);
        expect(res.totalUnreadThreadsCount, 8);

        tester
          ..verifyApi((api) => api.user.getUnreadCount())
          ..verifyNoMoreApiInteractions((api) => api.user);
      },
    );

    chatClientTest(
      '`.getUnreadCount` should also update user unread count as a side effect',
      body: (tester) async {
        tester.mockApi(
          (api) => api.user.getUnreadCount(),
          result: createDefaultGetUnreadCountResponse(
            totalUnreadCount: 25,
            totalUnreadThreadsCount: 2,
            channels: [
              UnreadCountsChannel(
                channelId: 'messaging:test-channel-1',
                unreadCount: 10,
                lastRead: DateTime.utc(2021, 3),
              ),
              UnreadCountsChannel(
                channelId: 'messaging:test-channel-2',
                unreadCount: 15,
                lastRead: DateTime.utc(2021, 3),
              ),
            ],
            threads: [
              UnreadCountsThread(
                unreadCount: 3,
                lastRead: DateTime.utc(2021, 3),
                lastReadMessageId: 'message-1',
                parentMessageId: 'parent-message-1',
              ),
              UnreadCountsThread(
                unreadCount: 5,
                lastRead: DateTime.utc(2021, 3),
                lastReadMessageId: 'message-2',
                parentMessageId: 'parent-message-2',
              ),
            ],
          ),
        );

        tester.client.getUnreadCount().ignore();

        // Wait for the local side effect event to be processed
        await Future.delayed(Duration.zero);

        expect(tester.currentUser?.totalUnreadCount, 25);
        expect(tester.currentUser?.unreadChannels, 2); // channels.length
        expect(tester.currentUser?.unreadThreads, 2); // threads.length

        tester
          ..verifyApi((api) => api.user.getUnreadCount())
          ..verifyNoMoreApiInteractions((api) => api.user);
      },
    );

    chatClientTest(
      '`.shadowBan`',
      body: (tester) async {
        const userId = 'test-user-id';

        tester.mockApi(
          (api) => api.moderation.banUser(userId, options: {'shadow': true}),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.shadowBan(userId);

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.moderation.banUser(userId, options: {'shadow': true}))
          ..verifyNoMoreApiInteractions((api) => api.moderation);
      },
    );

    chatClientTest(
      '`.removeShadowBan`',
      body: (tester) async {
        const userId = 'test-user-id';

        tester.mockApi(
          (api) => api.moderation.unbanUser(userId, options: {'shadow': true}),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.removeShadowBan(userId);

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.moderation.unbanUser(userId, options: {'shadow': true}))
          ..verifyNoMoreApiInteractions((api) => api.moderation);
      },
    );

    chatClientTest(
      '`.muteUser`',
      body: (tester) async {
        const userId = 'test-user-id';

        tester.mockApi(
          (api) => api.moderation.muteUser(userId),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.muteUser(userId);

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.moderation.muteUser(userId))
          ..verifyNoMoreApiInteractions((api) => api.moderation);
      },
    );

    chatClientTest(
      '`.unmuteUser`',
      body: (tester) async {
        const userId = 'test-user-id';

        tester.mockApi(
          (api) => api.moderation.unmuteUser(userId),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.unmuteUser(userId);

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.moderation.unmuteUser(userId))
          ..verifyNoMoreApiInteractions((api) => api.moderation);
      },
    );

    chatClientTest(
      '`.flagMessage`',
      body: (tester) async {
        const messageId = 'test-message-id';

        tester.mockApi(
          (api) => api.moderation.flagMessage(messageId),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.flagMessage(messageId);

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.moderation.flagMessage(messageId))
          ..verifyNoMoreApiInteractions((api) => api.moderation);
      },
    );

    chatClientTest(
      '`.unflagMessage`',
      body: (tester) async {
        const messageId = 'test-message-id';

        tester.mockApi(
          (api) => api.moderation.unflagMessage(messageId),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.unflagMessage(messageId);

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.moderation.unflagMessage(messageId))
          ..verifyNoMoreApiInteractions((api) => api.moderation);
      },
    );

    chatClientTest(
      '`.flagUser`',
      body: (tester) async {
        const userId = 'test-message-id';

        tester.mockApi(
          (api) => api.moderation.flagUser(userId),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.flagUser(userId);

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.moderation.flagUser(userId))
          ..verifyNoMoreApiInteractions((api) => api.moderation);
      },
    );

    chatClientTest(
      '`.unflagUser`',
      body: (tester) async {
        const userId = 'test-message-id';

        tester.mockApi(
          (api) => api.moderation.unflagUser(userId),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.unflagUser(userId);

        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.moderation.unflagUser(userId))
          ..verifyNoMoreApiInteractions((api) => api.moderation);
      },
    );

    chatClientTest(
      '`.getActiveLiveLocations`',
      body: (tester) async {
        final locations = [
          Location(
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device-1',
            endAt: DateTime.timestamp().add(const Duration(hours: 1)),
          ),
          Location(
            latitude: 34.0522,
            longitude: -118.2437,
            createdByDeviceId: 'device-2',
            endAt: DateTime.timestamp().add(const Duration(hours: 2)),
          ),
        ];

        tester.mockApi(
          (api) => api.user.getActiveLiveLocations(),
          result: GetActiveLiveLocationsResponse()..activeLiveLocations = locations,
        );

        // Initial state should be empty
        expect(tester.clientState.activeLiveLocations, isEmpty);

        final res = await tester.client.getActiveLiveLocations();

        expect(res, isNotNull);
        expect(res.activeLiveLocations, hasLength(2));
        expect(res.activeLiveLocations, equals(locations));
        expect(tester.clientState.activeLiveLocations, equals(locations));

        tester
          ..verifyApi((api) => api.user.getActiveLiveLocations())
          ..verifyNoMoreApiInteractions((api) => api.user);
      },
    );

    chatClientTest(
      '`.updateLiveLocation`',
      body: (tester) async {
        const messageId = 'test-message-id';
        const createdByDeviceId = 'test-device-id';
        final endAt = DateTime.timestamp().add(const Duration(hours: 1));
        const location = LocationCoordinates(
          latitude: 40.7128,
          longitude: -74.0060,
        );

        final expectedLocation = Location(
          latitude: location.latitude,
          longitude: location.longitude,
          createdByDeviceId: createdByDeviceId,
          endAt: endAt,
        );

        tester.mockApi(
          (api) => api.user.updateLiveLocation(
            messageId: messageId,
            createdByDeviceId: createdByDeviceId,
            location: location,
            endAt: endAt,
          ),
          result: expectedLocation,
        );

        final res = await tester.client.updateLiveLocation(
          messageId: messageId,
          createdByDeviceId: createdByDeviceId,
          location: location,
          endAt: endAt,
        );

        expect(res, isNotNull);
        expect(res, equals(expectedLocation));

        tester
          ..verifyApi(
            (api) => api.user.updateLiveLocation(
              messageId: messageId,
              createdByDeviceId: createdByDeviceId,
              location: location,
              endAt: endAt,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.user);
      },
    );

    chatClientTest(
      '`.stopLiveLocation`',
      body: (tester) async {
        const messageId = 'test-message-id';
        const createdByDeviceId = 'test-device-id';

        final expectedLocation = Location(
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: createdByDeviceId,
          endAt: DateTime.timestamp(), // Should be expired
        );

        tester.mockApi(
          (api) => api.user.updateLiveLocation(
            messageId: messageId,
            createdByDeviceId: createdByDeviceId,
            endAt: any(named: 'endAt'),
          ),
          result: expectedLocation,
        );

        final res = await tester.client.stopLiveLocation(
          messageId: messageId,
          createdByDeviceId: createdByDeviceId,
        );

        expect(res, isNotNull);
        expect(res, equals(expectedLocation));

        tester
          ..verifyApi(
            (api) => api.user.updateLiveLocation(
              messageId: messageId,
              createdByDeviceId: createdByDeviceId,
              endAt: any(named: 'endAt'),
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.user);
      },
    );

    group('Live Location Event Handling', () {
      chatClientTest(
        'should handle location.shared event',
        body: (tester) async {
          final location = Location(
            channelCid: 'test-channel:123',
            messageId: 'message-123',
            userId: tester.currentUser!.id,
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device-1',
            endAt: DateTime.timestamp().add(const Duration(hours: 1)),
          );

          final event = createDefaultEvent(
            type: EventType.locationShared,
            cid: 'test-channel:123',
            message: Message(
              id: 'message-123',
              sharedLocation: location,
            ),
          );

          // Initially empty
          expect(tester.clientState.activeLiveLocations, isEmpty);

          // Trigger the event
          await tester.emitEvent(event);

          // Should add location to active live locations
          final activeLiveLocations = tester.clientState.activeLiveLocations;
          expect(activeLiveLocations, hasLength(1));
          expect(activeLiveLocations.first.messageId, equals('message-123'));
        },
      );

      chatClientTest(
        'should handle location.updated event',
        body: (tester) async {
          final initialLocation = Location(
            channelCid: 'test-channel:123',
            messageId: 'message-123',
            userId: tester.currentUser!.id,
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device-1',
            endAt: DateTime.timestamp().add(const Duration(hours: 1)),
          );

          // Set initial location
          tester.clientState.activeLiveLocations = [initialLocation];

          final updatedLocation = Location(
            channelCid: 'test-channel:123',
            messageId: 'message-123',
            userId: tester.currentUser!.id,
            latitude: 40.7500, // Updated latitude
            longitude: -74.1000, // Updated longitude
            createdByDeviceId: 'device-1',
            endAt: DateTime.timestamp().add(const Duration(hours: 1)),
          );

          final event = createDefaultEvent(
            type: EventType.locationUpdated,
            cid: 'test-channel:123',
            message: Message(
              id: 'message-123',
              sharedLocation: updatedLocation,
            ),
          );

          // Trigger the event
          await tester.emitEvent(event);

          // Should update the location
          final activeLiveLocations = tester.clientState.activeLiveLocations;
          expect(activeLiveLocations, hasLength(1));
          expect(activeLiveLocations.first.latitude, equals(40.7500));
          expect(activeLiveLocations.first.longitude, equals(-74.1000));
        },
      );

      chatClientTest(
        'should handle location.expired event',
        body: (tester) async {
          final location = Location(
            channelCid: 'test-channel:123',
            messageId: 'message-123',
            userId: tester.currentUser!.id,
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device-1',
            endAt: DateTime.timestamp().add(const Duration(hours: 1)),
          );

          // Set initial location
          tester.clientState.activeLiveLocations = [location];
          expect(tester.clientState.activeLiveLocations, hasLength(1));

          final expiredLocation = location.copyWith(
            endAt: DateTime.timestamp().subtract(const Duration(hours: 1)),
          );

          final event = createDefaultEvent(
            type: EventType.locationExpired,
            cid: 'test-channel:123',
            message: Message(
              id: 'message-123',
              sharedLocation: expiredLocation,
            ),
          );

          // Trigger the event
          await tester.emitEvent(event);

          // Should remove the location
          expect(tester.clientState.activeLiveLocations, isEmpty);
        },
      );

      chatClientTest(
        'should auto-expire an active live location once at endAt',
        body: (tester) async {
          final expiredEvents = <Event>[];
          final sub = tester.client.on(EventType.locationExpired).listen(expiredEvents.add);
          addTearDown(sub.cancel);

          // Setting an active location schedules a one-shot expiry timer.
          tester.clientState.activeLiveLocations = [
            Location(
              channelCid: 'test-channel:123',
              messageId: 'message-123',
              userId: tester.currentUser!.id,
              latitude: 40.7128,
              longitude: -74.0060,
              createdByDeviceId: 'device-1',
              endAt: DateTime.timestamp().add(const Duration(milliseconds: 800)),
            ),
          ];
          expect(tester.clientState.activeLiveLocations, hasLength(1));

          // Before endAt nothing is emitted and the location stays active.
          await Future.delayed(const Duration(milliseconds: 200));
          expect(expiredEvents, isEmpty);
          expect(tester.clientState.activeLiveLocations, hasLength(1));

          // After endAt the timer fires once and the location is removed.
          await Future.delayed(const Duration(milliseconds: 900));
          expect(expiredEvents, hasLength(1));
          expect(tester.clientState.activeLiveLocations, isEmpty);

          // The timer is one-shot: no further events are emitted.
          await Future.delayed(const Duration(milliseconds: 300));
          expect(expiredEvents, hasLength(1));
        },
      );

      chatClientTest(
        'should ignore location events for other users',
        body: (tester) async {
          final location = Location(
            channelCid: 'test-channel:123',
            messageId: 'message-123',
            userId: 'other-user', // Different user
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device-1',
            endAt: DateTime.timestamp().add(const Duration(hours: 1)),
          );

          final event = createDefaultEvent(
            type: EventType.locationShared,
            cid: 'test-channel:123',
            message: Message(
              id: 'message-123',
              sharedLocation: location,
            ),
          );

          // Trigger the event
          await tester.emitEvent(event);

          // Should not add location from other user
          expect(tester.clientState.activeLiveLocations, isEmpty);
        },
      );

      chatClientTest(
        'should ignore static location events',
        body: (tester) async {
          final staticLocation = Location(
            channelCid: 'test-channel:123',
            messageId: 'message-123',
            userId: tester.currentUser!.id,
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device-1',
            // No endAt means it's static
          );

          final event = createDefaultEvent(
            type: EventType.locationShared,
            cid: 'test-channel:123',
            message: Message(
              id: 'message-123',
              sharedLocation: staticLocation,
            ),
          );

          // Trigger the event
          await tester.emitEvent(event);

          // Should not add static location
          expect(tester.clientState.activeLiveLocations, isEmpty);
        },
      );

      chatClientTest(
        'should merge locations with same key',
        body: (tester) async {
          final location1 = Location(
            channelCid: 'test-channel:123',
            messageId: 'message-123',
            userId: tester.currentUser!.id,
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device-1',
            endAt: DateTime.timestamp().add(const Duration(hours: 1)),
          );

          final location2 = Location(
            channelCid: 'test-channel:123',
            messageId: 'message-456',
            userId: tester.currentUser!.id,
            latitude: 40.7500,
            longitude: -74.1000,
            createdByDeviceId: 'device-1', // Same device, should merge
            endAt: DateTime.timestamp().add(const Duration(hours: 1)),
          );

          final event1 = createDefaultEvent(
            type: EventType.locationShared,
            cid: 'test-channel:123',
            message: Message(
              id: 'message-123',
              sharedLocation: location1,
            ),
          );

          final event2 = createDefaultEvent(
            type: EventType.locationShared,
            cid: 'test-channel:123',
            message: Message(
              id: 'message-456',
              sharedLocation: location2,
            ),
          );

          // Trigger first event
          await tester.emitEvent(event1);

          final activeLiveLocations = tester.clientState.activeLiveLocations;
          expect(activeLiveLocations, hasLength(1));
          expect(activeLiveLocations.first.messageId, equals('message-123'));

          // Trigger second event - should merge/update
          await tester.emitEvent(event2);

          final activeLiveLocations2 = tester.clientState.activeLiveLocations;
          expect(activeLiveLocations2, hasLength(1));
          expect(activeLiveLocations2.first.messageId, equals('message-456'));
        },
      );
    });

    chatClientTest(
      '`.markAllRead`',
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.markAllRead(),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.markAllRead();
        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.channel.markAllRead())
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.markChannelsDelivered`',
      body: (tester) async {
        final deliveries = [
          const MessageDelivery(
            channelCid: 'messaging:test-channel-1',
            messageId: 'test-message-id-1',
          ),
          const MessageDelivery(
            channelCid: 'messaging:test-channel-2',
            messageId: 'test-message-id-2',
          ),
        ];

        tester.mockApi(
          (api) => api.channel.markChannelsDelivered(deliveries),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.markChannelsDelivered(deliveries);
        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.channel.markChannelsDelivered(deliveries))
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.sendEvent`',
      body: (tester) async {
        const channelType = 'test-channel-type';
        const channelId = 'test-channel-id';
        final event = Event(type: EventType.any);

        tester.mockApi(
          (api) => api.channel.sendEvent(channelId, channelType, event),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.sendEvent(channelId, channelType, event);
        expect(res, isNotNull);

        tester
          ..verifyApi(
            (api) => api.channel.sendEvent(channelId, channelType, event),
          )
          ..verifyNoMoreApiInteractions((api) => api.channel);
      },
    );

    chatClientTest(
      '`.sendReaction`',
      body: (tester) async {
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

        tester.mockApi(
          (api) => api.message.sendReaction(messageId, reaction),
          result: createDefaultSendReactionResponse(
            message: Message(id: messageId),
            reaction: reaction,
          ),
        );

        final res = await tester.client.sendReaction(messageId, reaction);
        expect(res, isNotNull);
        expect(res.message.id, messageId);
        expect(res.reaction.type, reactionType);
        expect(res.reaction.emojiCode, emojiCode);
        expect(res.reaction.score, score);
        expect(res.reaction.messageId, messageId);

        tester
          ..verifyApi((api) => api.message.sendReaction(messageId, reaction))
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      '`.deleteReaction`',
      body: (tester) async {
        const messageId = 'test-message-id';
        const reactionType = 'like';

        tester.mockApi(
          (api) => api.message.deleteReaction(messageId, reactionType),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.deleteReaction(messageId, reactionType);
        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.message.deleteReaction(messageId, reactionType))
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      '`.sendMessage`',
      body: (tester) async {
        final message = Message(id: 'test-message-id');
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';

        tester.mockApi(
          (api) => api.message.sendMessage(channelId, channelType, any(that: isSameMessageAs(message))),
          result: createDefaultSendMessageResponse(message: message),
        );

        final res = await tester.client.sendMessage(message, channelId, channelType);
        expect(res, isNotNull);
        expect(res.message, isSameMessageAs(message));

        tester
          ..verifyApi(
            (api) => api.message.sendMessage(
              channelId,
              channelType,
              any(that: isSameMessageAs(message)),
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      '`.createDraft`',
      body: (tester) async {
        final message = DraftMessage(id: 'test-message-id', text: 'Hello!');
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';

        tester.mockApi(
          (api) => api.message.createDraft(
            channelId,
            channelType,
            any(that: isSameDraftMessageAs(message)),
          ),
          result: createDefaultCreateDraftResponse(
            draft: createDefaultDraft(
              channelCid: '$channelType:$channelId',
              message: message,
            ),
          ),
        );

        final res = await tester.client.createDraft(
          message,
          channelId,
          channelType,
        );

        expect(res, isNotNull);
        expect(res.draft.message, isSameDraftMessageAs(message));

        tester
          ..verifyApi(
            (api) => api.message.createDraft(
              channelId,
              channelType,
              any(that: isSameDraftMessageAs(message)),
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      '`.deleteDraft`',
      body: (tester) async {
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';

        tester.mockApi(
          (api) => api.message.deleteDraft(channelId, channelType),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.deleteDraft(channelId, channelType);
        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.message.deleteDraft(channelId, channelType))
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      '`.getDraft`',
      body: (tester) async {
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';

        final message = DraftMessage(id: 'test-message-id', text: 'Hello!');

        tester.mockApi(
          (api) => api.message.getDraft(channelId, channelType),
          result: createDefaultGetDraftResponse(
            draft: createDefaultDraft(
              channelCid: '$channelType:$channelId',
              message: message,
            ),
          ),
        );

        final res = await tester.client.getDraft(channelId, channelType);

        expect(res, isNotNull);
        expect(res.draft.message, isSameDraftMessageAs(message));

        tester
          ..verifyApi((api) => api.message.getDraft(channelId, channelType))
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      '`.queryDrafts`',
      body: (tester) async {
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';

        final filter = Filter.equal('channel_cid', '$channelType:$channelId');
        final sort = [const SortOption<Draft>.desc('created_at')];
        const pagination = PaginationParams(limit: 20);

        final drafts = [
          createDefaultDraft(
            channelCid: '$channelType:$channelId',
            message: DraftMessage(id: 'test-message-id', text: 'Hello!'),
          ),
        ];

        tester.mockApi(
          (api) => api.message.queryDrafts(
            filter: filter,
            sort: sort,
            pagination: pagination,
          ),
          result: QueryDraftsResponse()..drafts = drafts,
        );

        final res = await tester.client.queryDrafts(
          filter: filter,
          sort: sort,
          pagination: pagination,
        );

        expect(res, isNotNull);
        expect(res.drafts.length, drafts.length);

        tester
          ..verifyApi(
            (api) => api.message.queryDrafts(
              filter: filter,
              sort: sort,
              pagination: pagination,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      '`.getReplies`',
      body: (tester) async {
        const parentId = 'test-parent-id';

        final messages = List.generate(
          3,
          (index) => Message(id: 'test-message-id-$index'),
        );

        tester.mockApi(
          (api) => api.message.getReplies(parentId),
          result: createDefaultQueryRepliesResponse(messages: messages),
        );

        final res = await tester.client.getReplies(parentId);
        expect(res, isNotNull);
        expect(res.messages.length, messages.length);

        tester
          ..verifyApi((api) => api.message.getReplies(parentId))
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      '`.getReactions`',
      body: (tester) async {
        const messageId = 'test-parent-id';

        final reactions = List.generate(
          3,
          (index) => Reaction(
            type: 'test-reactions-type-$index',
            messageId: messageId,
          ),
        );

        tester.mockApi(
          (api) => api.message.getReactions(messageId),
          result: createDefaultQueryReactionsResponse(reactions: reactions),
        );

        final res = await tester.client.getReactions(messageId);
        expect(res, isNotNull);
        expect(res.reactions.length, reactions.length);
        expect(res.reactions.every((it) => it.messageId == messageId), isTrue);

        tester
          ..verifyApi((api) => api.message.getReactions(messageId))
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      '`.queryReactions`',
      body: (tester) async {
        const messageId = 'test-message-id';

        final reactions = List.generate(
          3,
          (index) => Reaction(
            type: 'test-reactions-type-$index',
            messageId: messageId,
          ),
        );

        tester.mockApi(
          (api) => api.message.queryReactions(messageId),
          result: createDefaultQueryReactionsResponse(reactions: reactions),
        );

        final res = await tester.client.queryReactions(messageId);
        expect(res, isNotNull);
        expect(res.reactions.length, reactions.length);
        expect(res.reactions.every((it) => it.messageId == messageId), isTrue);

        tester
          ..verifyApi((api) => api.message.queryReactions(messageId))
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      '`.updateMessage`',
      body: (tester) async {
        final message = Message(id: 'test-message-id', text: 'Hello!');

        tester.mockApi(
          (api) => api.message.updateMessage(any(that: isSameMessageAs(message))),
          result: createDefaultUpdateMessageResponse(message: message),
        );

        final res = await tester.client.updateMessage(message);
        expect(res, isNotNull);
        expect(res.message, isSameMessageAs(message));

        tester
          ..verifyApi(
            (api) => api.message.updateMessage(any(that: isSameMessageAs(message))),
          )
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      '`.deleteMessage`',
      body: (tester) async {
        const messageId = 'test-message-id';

        tester.mockApi(
          (api) => api.message.deleteMessage(messageId, hard: false),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.deleteMessage(messageId);
        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.message.deleteMessage(messageId, hard: false))
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      '`.deleteMessageForMe`',
      body: (tester) async {
        const messageId = 'test-message-id';

        tester.mockApi(
          (api) => api.message.deleteMessage(messageId, deleteForMe: true),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.client.deleteMessageForMe(messageId);
        expect(res, isNotNull);

        tester
          ..verifyApi((api) => api.message.deleteMessage(messageId, deleteForMe: true))
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      '`.getMessage`',
      body: (tester) async {
        const messageId = 'test-message-id';
        final message = Message(id: messageId);

        tester.mockApi(
          (api) => api.message.getMessage(messageId),
          result: createDefaultGetMessageResponse(message: message),
        );

        final res = await tester.client.getMessage(messageId);
        expect(res, isNotNull);
        expect(res.message.id, messageId);

        tester
          ..verifyApi((api) => api.message.getMessage(messageId))
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      '`.getMessagesById`',
      body: (tester) async {
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';
        const messageIds = ['test-message-id'];

        final messages = messageIds.map((id) => Message(id: id)).toList();

        tester.mockApi(
          (api) => api.message.getMessagesById(channelId, channelType, messageIds),
          result: createDefaultGetMessagesByIdResponse(messages: messages),
        );

        final res = await tester.client.getMessagesById(
          channelId,
          channelType,
          messageIds,
        );
        expect(res, isNotNull);
        expect(res.messages.length, messageIds.length);

        tester
          ..verifyApi(
            (api) => api.message.getMessagesById(channelId, channelType, messageIds),
          )
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      '`.translateMessage`',
      body: (tester) async {
        const messageId = 'test-message-id';
        const language = 'hi'; // Hindi
        const translatedMessageText = 'नमस्ते';
        final translatedMessage = Message(
          i18n: const {
            language: translatedMessageText,
          },
        );

        tester.mockApi(
          (api) => api.message.translateMessage(messageId, language),
          result: createDefaultTranslateMessageResponse(message: translatedMessage),
        );

        final res = await tester.client.translateMessage(messageId, language);

        expect(res, isNotNull);
        expect(res.message.i18n, translatedMessage.i18n);

        tester
          ..verifyApi((api) => api.message.translateMessage(messageId, language))
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      '`.partialUpdateMessage`',
      body: (tester) async {
        const messageId = 'test-message-id';
        final message = Message(id: messageId);

        const set = {'text': 'Update Message text'};
        const unset = ['pinExpires'];

        final updateMessageResponse = createDefaultUpdateMessageResponse(
          message: message.copyWith(text: set['text'], pinExpires: null),
        );

        tester.mockApi(
          (api) => api.message.partialUpdateMessage(
            message.id,
            set: set,
            unset: unset,
          ),
          result: updateMessageResponse,
        );

        final res = await tester.client.partialUpdateMessage(
          messageId,
          set: set,
          unset: unset,
        );

        expect(res, isNotNull);
        expect(res.message.id, message.id);
        expect(res.message.id, message.id);
        expect(res.message.text, set['text']);
        expect(res.message.pinExpires, isNull);

        tester
          ..verifyApi(
            (api) => api.message.partialUpdateMessage(
              message.id,
              set: set,
              unset: unset,
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    group('`.pinMessage`', () {
      ChannelState Function(ChannelState) _seedChannel() {
        return (_) => createDefaultChannelState(
          channel: createDefaultChannelModel(
            cid: _channelCid,
            config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
            ownCapabilities: [ChannelCapability.readEvents],
          ),
        );
      }

      chatClientTest(
        'should work fine without passing timeoutOrExpirationDate',
        body: (tester) async {
          const messageId = 'test-message-id';
          final message = Message(id: messageId);

          tester.mockApi(
            (api) => api.message.partialUpdateMessage(
              messageId,
              set: {'pinned': true, 'pin_expires': null},
            ),
            result: createDefaultUpdateMessageResponse(
              message: message.copyWith(
                pinned: true,
                pinExpires: null,
                state: MessageState.sent,
              ),
            ),
          );

          final res = await tester.client.pinMessage(messageId);

          expect(res, isNotNull);
          expect(res.message.pinned, isTrue);
          expect(res.message.pinExpires, isNull);

          tester
            ..verifyApi(
              (api) => api.message.partialUpdateMessage(
                messageId,
                set: {'pinned': true, 'pin_expires': null},
              ),
            )
            ..verifyNoMoreApiInteractions((api) => api.message);
        },
      );

      chatClientTest(
        'should work fine if passed timeoutOrExpirationDate as num(seconds)',
        body: (tester) async {
          const messageId = 'test-message-id';
          final message = Message(id: messageId);
          const timeoutOrExpirationDate = 300; // 300 seconds

          // The client computes `pin_expires` from the current time, so the
          // stub cannot match the exact `set` map.
          tester.mockApi(
            (api) => api.message.partialUpdateMessage(
              message.id,
              set: any(named: 'set'),
            ),
            result: createDefaultUpdateMessageResponse(
              message: message.copyWith(
                pinned: true,
                pinExpires: DateTime.utc(2021, 3).add(
                  const Duration(seconds: timeoutOrExpirationDate),
                ),
                state: MessageState.sent,
              ),
            ),
          );

          final res = await tester.client.pinMessage(
            messageId,
            timeoutOrExpirationDate: timeoutOrExpirationDate,
          );

          expect(res, isNotNull);
          expect(res.message.pinned, isTrue);
          expect(res.message.pinExpires, isNotNull);

          tester
            ..verifyApi(
              (api) => api.message.partialUpdateMessage(
                messageId,
                set: any(named: 'set'),
              ),
            )
            ..verifyNoMoreApiInteractions((api) => api.message);
        },
      );

      chatClientTest(
        'should work fine if passed timeoutOrExpirationDate as DateTime',
        body: (tester) async {
          const messageId = 'test-message-id';
          final message = Message(id: messageId);
          final timeoutOrExpirationDate = DateTime.utc(2021, 3).add(const Duration(days: 3)); // 3 days

          tester.mockApi(
            (api) => api.message.partialUpdateMessage(
              messageId,
              set: {
                'pinned': true,
                'pin_expires': timeoutOrExpirationDate.toUtc().toIso8601String(),
              },
            ),
            result: createDefaultUpdateMessageResponse(
              message: message.copyWith(
                pinned: true,
                pinExpires: timeoutOrExpirationDate,
                state: MessageState.sent,
              ),
            ),
          );

          final res = await tester.client.pinMessage(
            messageId,
            timeoutOrExpirationDate: timeoutOrExpirationDate,
          );

          expect(res, isNotNull);
          expect(res.message.pinned, isTrue);
          expect(res.message.pinExpires, isNotNull);
          expect(res.message.pinExpires, timeoutOrExpirationDate.toUtc());

          tester
            ..verifyApi(
              (api) => api.message.partialUpdateMessage(
                messageId,
                set: {
                  'pinned': true,
                  'pin_expires': timeoutOrExpirationDate.toUtc().toIso8601String(),
                },
              ),
            )
            ..verifyNoMoreApiInteractions((api) => api.message);
        },
      );

      channelTest(
        'should throw if invalid timeoutOrExpirationDate is passed',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(id: 'test-message-id');
          const timeoutOrExpirationDate = 'invalid-value';

          try {
            await tester.channel.pinMessage(
              message,
              timeoutOrExpirationDate: timeoutOrExpirationDate,
            );
          } catch (e) {
            expect(e, isA<ArgumentError>());
          }
        },
      );
    });

    chatClientTest(
      '`.unpinMessage`',
      body: (tester) async {
        const messageId = 'test-message-id';
        final message = Message(id: messageId, pinned: true);

        tester.mockApi(
          (api) => api.message.partialUpdateMessage(
            messageId,
            set: {'pinned': false},
          ),
          result: createDefaultUpdateMessageResponse(
            message: message.copyWith(
              pinned: false,
              state: MessageState.sent,
            ),
          ),
        );

        final res = await tester.client.unpinMessage(messageId);

        expect(res, isNotNull);
        expect(res.message.pinned, isFalse);

        tester
          ..verifyApi(
            (api) => api.message.partialUpdateMessage(
              messageId,
              set: {'pinned': false},
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      '`.enrichUrl`',
      body: (tester) async {
        const url = 'https://www.techyourchance.com/finite-state-machine-with-unit-tests-real-world-example';

        tester.mockApi(
          (api) => api.general.enrichUrl(url),
          result: OGAttachmentResponse()
            ..type = 'image'
            ..ogScrapeUrl = url
            ..authorName = 'TechYourChance'
            ..title = 'Finite State Machine with Unit Tests: Real World Example',
        );

        final res = await tester.client.enrichUrl(url);

        expect(res, isNotNull);
        expect(res.type, 'image');
        expect(res.ogScrapeUrl, url);
        expect(res.authorName, 'TechYourChance');
        expect(
          res.title,
          'Finite State Machine with Unit Tests: Real World Example',
        );

        tester
          ..verifyApi((api) => api.general.enrichUrl(url))
          ..verifyApi((api) => api.general.getAppSettings())
          ..verifyNoMoreApiInteractions((api) => api.general);
      },
    );

    // The unread counts are derived from the current user, so assigning a new
    // one has to republish them.
    chatClientTest(
      '''setting the `currentUser` should also compute and update the unreadCounts''',
      body: (tester) async {
        final state = tester.clientState;
        // Derived from the harness user rather than read back out of the state,
        // so this still asserts that connecting produced the expected user.
        final initialUser = OwnUser.fromUser(tester.user);

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
    // Runs [body] as a [chatClientTest] that never opens the socket: persistence
    // starts disabled, and the persistence client is detached and asserted
    // disabled again after the body.
    void _persistenceConnectionTest(
      String description, {
      required Future<void> Function(ChatClientTester tester) body,
    }) {
      chatClientTest(
        description,
        connect: (_) {},
        setUp: (tester) => expect(tester.client.persistenceEnabled, isFalse),
        body: body,
        tearDown: (tester) {
          tester.client.chatPersistenceClient = null;
          expect(tester.client.persistenceEnabled, isFalse);
        },
      );
    }

    _persistenceConnectionTest(
      'openPersistenceConnection connects the client to the user',
      body: (tester) async {
        tester.client.chatPersistenceClient = MockPersistenceClient();
        await tester.client.openPersistenceConnection(tester.user);
        expect(tester.client.persistenceEnabled, isTrue);
      },
    );

    _persistenceConnectionTest(
      '''multiple call to openPersistenceConnection does not throws an error if already connected to the same user''',
      body: (tester) async {
        tester.client.chatPersistenceClient = MockPersistenceClient();
        await tester.client.openPersistenceConnection(tester.user);
        expect(tester.client.persistenceEnabled, isTrue);

        await expectLater(tester.client.openPersistenceConnection(tester.user), completes);
        await expectLater(tester.client.openPersistenceConnection(tester.user), completes);
        await expectLater(tester.client.openPersistenceConnection(tester.user), completes);
      },
    );

    _persistenceConnectionTest(
      '''openPersistenceConnection throws an error if client is already connected to a different user''',
      body: (tester) async {
        tester.client.chatPersistenceClient = MockPersistenceClient();
        await tester.client.openPersistenceConnection(tester.user);
        expect(tester.client.persistenceEnabled, isTrue);

        await expectLater(
          tester.client.openPersistenceConnection(tester.user.copyWith(id: 'new-id')),
          throwsA(const TypeMatcher<StreamChatError>()),
        );
      },
    );

    _persistenceConnectionTest(
      '''openPersistenceConnection throws an error if chatPersistenceClient is not set''',
      body: (tester) async {
        await expectLater(
          tester.client.openPersistenceConnection(tester.user),
          throwsA(const TypeMatcher<StreamChatError>()),
        );
      },
    );

    _persistenceConnectionTest(
      'closePersistenceConnection disconnects the client',
      body: (tester) async {
        tester.client.chatPersistenceClient = MockPersistenceClient();
        await tester.client.openPersistenceConnection(tester.user);
        expect(tester.client.persistenceEnabled, isTrue);

        await tester.client.closePersistenceConnection();
        expect(tester.client.persistenceEnabled, isFalse);
      },
    );

    _persistenceConnectionTest(
      '''closePersistenceConnection compeletes normally if chatPersistenceClient is not connected''',
      body: (tester) async {
        tester.client.chatPersistenceClient = MockPersistenceClient();
        expect(tester.client.chatPersistenceClient!.isConnected, isFalse);

        await expectLater(tester.client.closePersistenceConnection(), completes);
      },
    );

    _persistenceConnectionTest(
      '''closePersistenceConnection completes normally if chatPersistenceClient is not set''',
      body: (tester) async {
        expect(tester.client.persistenceEnabled, isFalse);
        await expectLater(tester.client.closePersistenceConnection(), completes);
      },
    );

    _persistenceConnectionTest(
      '''connectUser completes normally if the persistence connection is already connected to the same user''',
      body: (tester) async {
        tester.client.chatPersistenceClient = MockPersistenceClient();
        await tester.client.openPersistenceConnection(tester.user);
        expect(tester.client.persistenceEnabled, isTrue);

        await expectLater(
          tester.client.connectUser(
            tester.user,
            createTestToken(tester.user.id).rawValue,
            connectWebSocket: false,
          ),
          completes,
        );
      },
    );

    _persistenceConnectionTest(
      '''connectUser should throw if the persistence connection if already connected to a different user''',
      body: (tester) async {
        tester.client.chatPersistenceClient = MockPersistenceClient();
        await tester.client.openPersistenceConnection(tester.user.copyWith(id: 'new-id'));
        expect(tester.client.persistenceEnabled, isTrue);

        await expectLater(
          tester.client.connectUser(
            tester.user,
            createTestToken(tester.user.id).rawValue,
            connectWebSocket: false,
          ),
          throwsA(const TypeMatcher<StreamChatError>()),
        );
      },
    );

    group('Sync Method Tests', () {
      setUpAll(() {
        // fallback values
        registerFallbackValue(<String>[]);
        registerFallbackValue(DateTime(0));
        registerFallbackValue(const PaginationParams());
        registerFallbackValue(Filter.equal('cid', ''));
      });

      _persistenceConnectionTest(
        'should retrieve data from persistence client and sync successfully',
        body: (tester) async {
          final cids = ['channel1', 'channel2'];
          final lastSyncAt = DateTime.utc(2021, 3);
          final fakeClient = FakePersistenceClient(
            channelCids: cids,
            lastSyncAt: lastSyncAt,
          );

          tester.client.chatPersistenceClient = fakeClient;
          tester.mockApi(
            (api) => api.general.sync(cids, lastSyncAt),
            result: createDefaultSyncResponse(),
          );

          await tester.client.sync();

          tester.verifyApi((api) => api.general.sync(cids, lastSyncAt));

          final newLastSyncAt = await fakeClient.getLastSyncAt();
          expect(newLastSyncAt?.isAfter(lastSyncAt), isTrue);
        },
      );

      _persistenceConnectionTest(
        'should set lastSyncAt on first sync when null',
        body: (tester) async {
          final fakeClient = FakePersistenceClient(
            channelCids: ['channel1'],
            lastSyncAt: null,
          );

          tester.client.chatPersistenceClient = fakeClient;

          await tester.client.sync();

          expectLater(fakeClient.getLastSyncAt(), completion(isNotNull));
          tester.verifyNeverCalled((api) => api.general.sync(any(), any()));
        },
      );

      _persistenceConnectionTest(
        'should flush persistence client on 400 error',
        body: (tester) async {
          final cids = ['channel1'];
          final lastSyncAt = DateTime.utc(2021, 3);
          final fakeClient = FakePersistenceClient(
            channelCids: cids,
            lastSyncAt: lastSyncAt,
          );

          tester.client.chatPersistenceClient = fakeClient;
          tester.mockApiFailure(
            (api) => api.general.sync(cids, lastSyncAt),
            error: StreamChatNetworkError.raw(
              code: 4,
              statusCode: 400,
              message: 'Too many events',
            ),
          );

          await tester.client.sync();

          expect(await fakeClient.getChannelCids(), isEmpty); // Should be flushed

          tester.verifyApi((api) => api.general.sync(cids, lastSyncAt));
        },
      );

      _persistenceConnectionTest(
        '''should replay events and advance lastSyncAt when the payload is within the replay limit''',
        body: (tester) async {
          final cids = ['channel1'];
          final lastSyncAt = DateTime.timestamp().subtract(const Duration(hours: 1));
          final fakeClient = FakePersistenceClient(
            channelCids: cids,
            lastSyncAt: lastSyncAt,
          );

          tester.client.chatPersistenceClient = fakeClient;
          final events = List.generate(
            10,
            (index) => Event(
              type: EventType.messageNew,
              cid: 'channel1',
              message: Message(id: 'message-$index'),
              createdAt: lastSyncAt.add(Duration(seconds: index + 1)),
            ),
          );
          tester.mockApi(
            (api) => api.general.sync(cids, lastSyncAt),
            result: SyncResponse()..events = events,
          );

          final replayed = <Event>[];
          final sub = tester.client.on(EventType.messageNew).listen(replayed.add);
          addTearDown(sub.cancel);

          await tester.client.sync();
          await pumpEventQueue();

          tester.verifyApi((api) => api.general.sync(cids, lastSyncAt));
          // Within the limit, every event is replayed through the event handler.
          expect(replayed, hasLength(events.length));
          // lastSyncAt advances to the newest replayed event date.
          expect(await fakeClient.getLastSyncAt(), events.last.createdAt);
        },
      );

      _persistenceConnectionTest(
        '''should refresh the synced channels in place of a payload that exceeds the replay limit''',
        body: (tester) async {
          final cids = ['channel1'];
          final lastSyncAt = DateTime.timestamp().subtract(const Duration(hours: 1));
          final fakeClient = FakePersistenceClient(
            channelCids: cids,
            lastSyncAt: lastSyncAt,
          );

          tester.client.chatPersistenceClient = fakeClient;
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
          tester
            ..mockApi(
              (api) => api.general.sync(cids, lastSyncAt),
              result: SyncResponse()..events = events,
            )
            ..mockApi(
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
              result: QueryChannelsResponse()..channels = [],
            );

          final replayed = <Event>[];
          final sub = tester.client.on(EventType.messageNew).listen(replayed.add);
          addTearDown(sub.cancel);

          await tester.client.sync();
          await pumpEventQueue();

          tester.verifyApi((api) => api.general.sync(cids, lastSyncAt));
          // Replay is skipped; no events are dispatched through the handler.
          expect(replayed, isEmpty);
          // The channels the payload covered are refreshed in its place.
          tester.verifyApi(
            (api) => api.channel.queryChannels(
              filter: Filter.in_('cid', cids),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: const PaginationParams(limit: 1),
            ),
          );
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
    final token = Token.development(user.id).rawValue;

    late FakeChatApi api;
    late _FakeWebSocket ws;
    late StreamChatClient client;

    setUpAll(() {
      registerFallbackValue(const PaginationParams());
      registerFallbackValue(Filter.equal('cid', ''));
    });

    setUp(() {
      api = FakeChatApi();
      ws = _FakeWebSocket();

      // Stub queryChannels for every test — it's the API the recovery path
      // calls when enabled, and a missing stub would surface as an unhandled
      // async error inside the connection-status listener.
      when(
        () => api.channel.queryChannels(
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

    // Drives the _FakeWebSocket through a connected → disconnected → connected
    // transition so the client's pairwise listener fires the recovery path.
    Future<void> simulateReconnect() async {
      ws.connectionStatus = ConnectionStatus.disconnected;
      await delay(100);
      ws.connectionStatus = ConnectionStatus.connected;
      await delay(300);
    }

    // Recovery runs inside the client's own connection-status listener, so a
    // failure there has no future for the app to catch. It must be swallowed,
    // and must not stop `connectionRecovered` from firing.

    // Recovery asks about channels most recently active first, so every fixture
    // pins its own recency rather than inheriting the moment it was built.
    // Both dates are set so `lastUpdatedAt` lands on [lastActiveAt] either way.
    Channel channelActiveAt(String cid, DateTime lastActiveAt) {
      final channel = ChannelModel(cid: cid, createdAt: lastActiveAt, lastMessageAt: lastActiveAt);
      return Channel.fromState(client, ChannelState(channel: channel));
    }

    test('should re-query active channels on reconnect when enabled (default)', () async {
      // Setup: connect with default flag, register two channels.
      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
      await client.connectUser(user, token);
      await delay(300);

      final now = DateTime.now();
      client.state.addChannels({
        'messaging:c1': channelActiveAt('messaging:c1', now),
        'messaging:c2': channelActiveAt('messaging:c2', now.subtract(const Duration(minutes: 1))),
      });

      // Drop interactions from the initial connect's (empty-channel) recovery
      // so we only count the reconnect call.
      clearInteractions(api.channel);

      await simulateReconnect();

      // The re-query asks for exactly the channels it lists, a page at a time.
      verify(
        () => api.channel.queryChannels(
          filter: Filter.in_('cid', const ['messaging:c1', 'messaging:c2']),
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
      client = StreamChatClient(apiKey, chatApi: api, ws: ws, recoverStateOnReconnect: false);
      await client.connectUser(user, token);
      await delay(300);

      final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: 'messaging:c1')));
      client.state.addChannels({'messaging:c1': channel});
      clearInteractions(api.channel);

      await simulateReconnect();

      verifyNever(
        () => api.channel.queryChannels(
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
      client = StreamChatClient(apiKey, chatApi: api, ws: ws, recoverStateOnReconnect: false);
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
        () => api.channel.queryChannels(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).thenThrow(const StreamChatError('You cannot use queryChannels without an active connection.'));

      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
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
      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
      await client.connectUser(user, token);
      await delay(300);

      // No channels added — the cids.isNotEmpty guard should short-circuit.
      clearInteractions(api.channel);

      await simulateReconnect();

      verifyNever(
        () => api.channel.queryChannels(
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
      client = StreamChatClient(apiKey, chatApi: api, ws: ws, recoverStateOnReconnect: false);
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
      when(() => api.general.sync(const [cid], lastSyncAt)).thenAnswer(
        (_) async => SyncResponse()..events = events,
      );

      clearInteractions(api.channel);

      await simulateReconnect();

      verify(
        () => api.channel.queryChannels(
          filter: Filter.in_('cid', const [cid]),
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
      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
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

      when(() => api.general.sync(const [cid], lastSyncAt)).thenThrow(
        StreamChatNetworkError(ChatErrorCode.internalSystemError),
      );

      clearInteractions(api.channel);

      await simulateReconnect();

      verify(
        () => api.channel.queryChannels(
          filter: Filter.in_('cid', const [cid]),
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
        () => api.channel.queryChannels(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).thenThrow(const StreamChatError('You cannot use queryChannels without an active connection.'));

      client = StreamChatClient(apiKey, chatApi: api, ws: ws, recoverStateOnReconnect: false);
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
      when(() => api.general.sync(const [cid], lastSyncAt)).thenAnswer(
        (_) async => SyncResponse()..events = events,
      );

      await simulateReconnect();

      expect(await persistenceClient.getLastSyncAt(), lastSyncAt);
    });

    test('should re-query in batches when more channels are active than fit in one page', () async {
      client = StreamChatClient(apiKey, chatApi: api, ws: ws, recoverStateOnReconnect: false);
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
      when(() => api.general.sync(cids, lastSyncAt)).thenAnswer(
        (_) async => SyncResponse()..events = events,
      );

      clearInteractions(api.channel);

      await simulateReconnect();

      verify(
        () => api.channel.queryChannels(
          filter: Filter.in_('cid', cids.take(30).toList()),
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
        () => api.channel.queryChannels(
          filter: Filter.in_('cid', cids.skip(30).toList()),
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
      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
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
      when(() => api.general.sync(const [cid], lastSyncAt)).thenAnswer((_) async {
        calls.add('sync');
        return SyncResponse()..events = [];
      });
      when(
        () => api.channel.queryChannels(
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
      client = StreamChatClient(apiKey, chatApi: api, ws: ws, recoverStateOnReconnect: false);
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
      when(() => api.general.sync(cids, lastSyncAt)).thenAnswer(
        (_) async => SyncResponse()..events = events,
      );

      // The first page fails, the second one succeeds.
      when(
        () => api.channel.queryChannels(
          filter: Filter.in_('cid', cids.take(30).toList()),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).thenThrow(const StreamChatError('Failed to query channels'));

      clearInteractions(api.channel);

      await simulateReconnect();

      // Both pages are asked for, even though the first one failed.
      verify(
        () => api.channel.queryChannels(
          filter: Filter.in_('cid', cids.skip(30).toList()),
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
      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
      await client.connectUser(user, token);
      await delay(300);

      final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: 'messaging:c1')));
      client.state.addChannels({'messaging:c1': channel});
      clearInteractions(api.channel);

      // Disable mid-flight → no re-query on reconnect.
      client.recoverStateOnReconnect = false;
      await simulateReconnect();
      verifyNever(
        () => api.channel.queryChannels(
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
        () => api.channel.queryChannels(
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
    final token = Token.development(user.id).rawValue;

    late FakeChatApi api;
    late _FakeWebSocket ws;
    late StreamChatClient client;
    var disposed = false;

    setUpAll(() {
      registerFallbackValue(const PaginationParams());
      registerFallbackValue(Filter.equal('cid', ''));
    });

    setUp(() {
      api = FakeChatApi();
      ws = _FakeWebSocket();
      disposed = false;
    });

    // The test disposes the client itself; avoid disposing it a second time.
    tearDown(() async {
      if (!disposed) await client.dispose();
    });

    // Disposing the client while a reconnect is still recovering must complete
    // cleanly: recovery work that finishes after disposal is discarded, never
    // surfacing as an error.

    // Disposing the client while a reconnect is still recovering must complete
    // cleanly: recovery work that finishes after disposal is discarded, never
    // surfacing as an error.
    test('disposing mid-recovery does not surface a late recovery event', () async {
      // Keep the recovery's channel query pending so the client is still
      // mid-recovery at the moment it is disposed.
      final pendingQuery = Completer<QueryChannelsResponse>();
      when(
        () => api.channel.queryChannels(
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

      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
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
      ws.connectionStatus = ConnectionStatus.disconnected;
      await delay(100);
      ws.connectionStatus = ConnectionStatus.connected;
      await delay(100);

      // Dispose while the recovery is still in flight.
      await client.dispose();
      disposed = true;

      // Let the now-orphaned recovery finish. Its trailing work must be
      // discarded silently instead of thrown as an unhandled async error.
      pendingQuery.complete(QueryChannelsResponse()..channels = []);
      await delay(300);

      expect(client.wsConnectionStatus, ConnectionStatus.disconnected);
    });
  });

  group('WS events', () {
    group('User messages deleted event', () {
      chatClientTest(
        'should broadcast global user.messages.deleted event to all channels',
        body: (tester) async {
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
          final channelState1 = createDefaultChannelState(
            channel: createDefaultChannelModel(cid: 'messaging:channel-1'),
            messages: [message1],
          );
          final channelState2 = createDefaultChannelState(
            channel: createDefaultChannelModel(cid: 'messaging:channel-2'),
            messages: [message2],
          );

          final channel1 = Channel.fromState(tester.client, channelState1);
          final channel2 = Channel.fromState(tester.client, channelState2);

          // Register channels in client state
          tester.clientState.addChannels({
            'messaging:channel-1': channel1,
            'messaging:channel-2': channel2,
          });

          // Verify initial state
          expect(channel1.state?.messages.length, equals(1));
          expect(channel2.state?.messages.length, equals(1));

          // Emit a global (cid-less) user.messages.deleted event;
          // ClientState rebroadcasts it to every registered channel.
          final event = createDefaultEvent(
            type: EventType.userMessagesDeleted,
            user: bannedUser,
            hardDelete: false,
          );

          await tester.emitEvent(event);

          // Verify messages are soft deleted in all channels
          final channel1Message = channel1.state?.messages.first;
          expect(channel1Message?.type, equals(MessageType.deleted));
          expect(channel1Message?.state.isDeleted, isTrue);

          final channel2Message = channel2.state?.messages.first;
          expect(channel2Message?.type, equals(MessageType.deleted));
          expect(channel2Message?.state.isDeleted, isTrue);
        },
      );

      chatClientTest(
        'should broadcast global hard delete to all channels',
        body: (tester) async {
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
          final channelState1 = createDefaultChannelState(
            channel: createDefaultChannelModel(cid: 'messaging:channel-1'),
            messages: [message1, message3],
          );
          final channelState2 = createDefaultChannelState(
            channel: createDefaultChannelModel(cid: 'messaging:channel-2'),
            messages: [message2],
          );

          final channel1 = Channel.fromState(tester.client, channelState1);
          final channel2 = Channel.fromState(tester.client, channelState2);

          // Register channels in client state
          tester.clientState.addChannels({
            'messaging:channel-1': channel1,
            'messaging:channel-2': channel2,
          });

          // Verify initial state
          expect(channel1.state?.messages.length, equals(2));
          expect(channel2.state?.messages.length, equals(1));

          // Emit a global (cid-less) user.messages.deleted event;
          // ClientState rebroadcasts it to every registered channel.
          final event = createDefaultEvent(
            type: EventType.userMessagesDeleted,
            user: bannedUser,
            hardDelete: true,
          );

          await tester.emitEvent(event);

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
    // The guards hold on a client that was never connected, so these skip
    // the connect phase.

    // The guards hold on a client that was never connected, so these skip
    // the connect phase.
    chatClientTest(
      '`state.channels` returns an unmodifiable view',
      connect: (_) {},
      body: (tester) async {
        final channel = Channel.fromState(
          tester.client,
          createDefaultChannelState(channel: createDefaultChannelModel(cid: 'messaging:c1')),
        );
        tester.clientState.addChannels({'messaging:c1': channel});

        expect(tester.clientState.channels, hasLength(1));
        expect(() => tester.clientState.channels.remove('messaging:c1'), throwsUnsupportedError);
        expect(() => tester.clientState.channels.clear(), throwsUnsupportedError);
        expect(() => tester.clientState.channels['messaging:c2'] = channel, throwsUnsupportedError);
      },
    );

    chatClientTest(
      '`state.users` returns an unmodifiable view',
      connect: (_) {},
      body: (tester) async {
        tester.clientState.updateUser(User(id: 'u1'));

        expect(tester.clientState.users.containsKey('u1'), isTrue);
        expect(() => tester.clientState.users.remove('u1'), throwsUnsupportedError);
        expect(() => tester.clientState.users.clear(), throwsUnsupportedError);
      },
    );

    chatClientTest(
      '`state.activeLiveLocations` returns an unmodifiable view',
      connect: (_) {},
      body: (tester) async {
        expect(() => tester.clientState.activeLiveLocations.clear(), throwsUnsupportedError);
      },
    );

    chatClientTest(
      '`removeChannel` emits a fresh map so distinct subscribers see the change',
      connect: (_) {},
      body: (tester) async {
        final channel = Channel.fromState(
          tester.client,
          createDefaultChannelState(channel: createDefaultChannelModel(cid: 'messaging:c1')),
        );
        tester.clientState.addChannels({'messaging:c1': channel});

        final received = <Map<String, Channel>>[];
        // Skip the BehaviorSubject's replay of the current value to new subscribers.
        final sub = tester.clientState.channelsStream.distinct().skip(1).listen(received.add);

        tester.clientState.removeChannel('messaging:c1');
        await Future<void>.delayed(Duration.zero);

        expect(received, hasLength(1));
        expect(received.single, isEmpty);

        await sub.cancel();
      },
    );

    chatClientTest(
      'initial seeded values are unmodifiable (before any write)',
      connect: (_) {},
      body: (tester) async {
        // Fresh client, no mutations yet — subscribers connecting at this point
        // still see unmodifiable seeds.
        expect(() => tester.clientState.channels.clear(), throwsUnsupportedError);
        expect(() => tester.clientState.users.clear(), throwsUnsupportedError);
        expect(() => tester.clientState.activeLiveLocations.clear(), throwsUnsupportedError);
      },
    );

    chatClientTest(
      '`channelsStream` emits unmodifiable maps',
      connect: (_) {},
      body: (tester) async {
        final received = <Map<String, Channel>>[];
        final sub = tester.clientState.channelsStream.listen(received.add);

        final channel = Channel.fromState(
          tester.client,
          createDefaultChannelState(channel: createDefaultChannelModel(cid: 'messaging:c1')),
        );
        tester.clientState.addChannels({'messaging:c1': channel});
        await Future<void>.delayed(Duration.zero);

        // Both the initial seed and the post-write emission must be unmodifiable.
        expect(received, hasLength(greaterThanOrEqualTo(2)));
        for (final emitted in received) {
          expect(emitted.clear, throwsUnsupportedError);
        }

        await sub.cancel();
      },
    );

    chatClientTest(
      '`usersStream` emits unmodifiable maps',
      connect: (_) {},
      body: (tester) async {
        final received = <Map<String, User>>[];
        final sub = tester.clientState.usersStream.listen(received.add);

        tester.clientState.updateUser(User(id: 'u1'));
        await Future<void>.delayed(Duration.zero);

        expect(received, hasLength(greaterThanOrEqualTo(2)));
        for (final emitted in received) {
          expect(emitted.clear, throwsUnsupportedError);
        }

        await sub.cancel();
      },
    );

    chatClientTest(
      '`activeLiveLocationsStream` emits unmodifiable lists',
      connect: (_) {},
      body: (tester) async {
        final received = <List<Location>>[];
        final sub = tester.clientState.activeLiveLocationsStream.listen(received.add);

        tester.clientState.activeLiveLocations = const [];
        await Future<void>.delayed(Duration.zero);

        expect(received, isNotEmpty);
        for (final emitted in received) {
          expect(emitted.clear, throwsUnsupportedError);
        }

        await sub.cancel();
      },
    );
  });

  group('default REST wiring', () {
    setUpAll(() => registerFallbackValue(RequestOptions()));

    test('builds a REST stack carrying the api key and user credentials', () async {
      const apiKey = 'test-api-key';
      final adapter = _MockHttpClientAdapter();

      when(() => adapter.fetch(any(), any(), any())).thenAnswer(
        (_) async => ResponseBody.fromString(
          '{"app":{}}',
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
      );

      final client = StreamChatClient(apiKey, httpClientAdapter: adapter);
      addTearDown(client.dispose);

      final user = User(id: 'test-user-id');
      final token = Token.development(user.id);

      // Connecting without a socket still loads the app settings, which is the
      // request captured below.
      await client.connectUser(user, token.rawValue, connectWebSocket: false);
      await pumpEventQueue();

      final captured = verify(() => adapter.fetch(captureAny(), any(), any())).captured;
      final options = captured.first as RequestOptions;

      expect(options.queryParameters['api_key'], apiKey);
      expect(options.queryParameters['user_id'], user.id);
      expect(options.headers['Authorization'], token.rawValue);
      expect(options.headers['stream-auth-type'], token.authType.name);
    });
  });
}

class _MockHttpClientAdapter extends Mock implements HttpClientAdapter {}

class _FakeUser extends Fake implements User {}

class _FakeWebSocket extends Fake implements WebSocket {
  late final _connectionStatusController = BehaviorSubject.seeded(
    ConnectionStatus.disconnected,
  );

  set connectionStatus(ConnectionStatus value) {
    _connectionStatusController.add(value);
  }

  @override
  ConnectionStatus get connectionStatus => _connectionStatusController.value;

  @override
  Stream<ConnectionStatus> get connectionStatusStream => _connectionStatusController.stream;

  @override
  Completer<Event>? connectionCompleter;

  @override
  Future<Event> connect(
    User user, {
    bool? includeUserDetails = true,
  }) async {
    connectionStatus = ConnectionStatus.connecting;
    final event = Event(
      type: EventType.healthCheck,
      connectionId: 'fake-connection-id',
      me: OwnUser.fromUser(user),
    );
    connectionCompleter = Completer()..complete(event);
    connectionStatus = ConnectionStatus.connected;
    return connectionCompleter!.future;
  }

  @override
  void disconnect() {
    connectionStatus = ConnectionStatus.disconnected;
    connectionCompleter = null;
  }

  @override
  Future<void> dispose() async {
    await _connectionStatusController.close();
  }
}

class _FakeWebSocketWithConnectionError extends Fake implements WebSocket {
  late final _connectionStatusController = BehaviorSubject.seeded(
    ConnectionStatus.disconnected,
  );

  set connectionStatus(ConnectionStatus value) {
    _connectionStatusController.add(value);
  }

  @override
  ConnectionStatus get connectionStatus => _connectionStatusController.value;

  @override
  Stream<ConnectionStatus> get connectionStatusStream => _connectionStatusController.stream;

  @override
  Completer<Event>? connectionCompleter;

  @override
  Future<Event> connect(
    User user, {
    bool? includeUserDetails = true,
  }) async {
    connectionStatus = ConnectionStatus.connecting;
    const error = StreamWebSocketError('Error Connecting');
    connectionCompleter = Completer()..completeError(error);
    return connectionCompleter!.future;
  }

  @override
  void disconnect() {
    connectionStatus = ConnectionStatus.disconnected;
    connectionCompleter = null;
  }

  @override
  Future<void> dispose() async {
    await _connectionStatusController.close();
  }
}

// Top level util function to delay the code execution
Future delay(num milliseconds) => Future.delayed(Duration(milliseconds: milliseconds.toInt()));
