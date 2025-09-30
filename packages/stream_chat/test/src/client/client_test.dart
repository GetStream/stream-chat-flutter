import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/http/token.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../matchers.dart';
import '../mocks.dart';
import '../utils.dart';

void main() {
  group('Fake web-socket connection functions', () {
    const apiKey = 'test-api-key';
    late final api = FakeChatApi();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeUser());
    });

    setUp(() {
      final ws = FakeWebSocket();
      client = StreamChatClient(apiKey, ws: ws, chatApi: api);
    });

    tearDown(() {
      client.dispose();
    });

    test('`.connectUser` should work fine', () async {
      final user = User(id: 'test-user-id');
      final token = Token.development(user.id).rawValue;

      expectLater(
        // skipping first seed status -> ConnectionStatus.disconnected
        client.wsConnectionStatusStream.skip(1),
        emitsInOrder([
          ConnectionStatus.connecting,
          ConnectionStatus.connected,
        ]),
      );

      final res = await client.connectUser(user, token);
      expect(res, isNotNull);
      expect(res, isSameUserAs(user));
    });

    test('`.connectUserWithProvider` should work fine', () async {
      final user = User(id: 'test-user-id');
      Future<String> tokenProvider(String userId) async {
        expect(userId, user.id);
        return Token.development(userId).rawValue;
      }

      expectLater(
        // skipping first seed status -> ConnectionStatus.disconnected
        client.wsConnectionStatusStream.skip(1),
        emitsInOrder([
          ConnectionStatus.connecting,
          ConnectionStatus.connected,
        ]),
      );

      final res = await client.connectUserWithProvider(user, tokenProvider);
      expect(res, isNotNull);
      expect(res, isSameUserAs(user));
    });

    group('`.connectGuestUser`', () {
      test('should work fine', () async {
        final user = User(id: 'test-user-id');
        final token = Token.development(user.id).rawValue;

        when(() => api.guest.getGuestUser(any(that: isSameUserAs(user))))
            .thenAnswer(
          (_) async => ConnectGuestUserResponse()
            ..user = user
            ..accessToken = token,
        );

        expectLater(
          // skipping first seed status -> ConnectionStatus.disconnected
          client.wsConnectionStatusStream.skip(1),
          emitsInOrder([
            ConnectionStatus.connecting,
            ConnectionStatus.connected,
          ]),
        );

        final res = await client.connectGuestUser(user);
        expect(res, isNotNull);
        expect(res, isSameUserAs(user));

        verify(
          () => api.guest.getGuestUser(any(that: isSameUserAs(user))),
        ).called(1);
      });

      test('should throw if `.getGuestUser` fails', () async {
        final user = User(id: 'test-user-id');

        when(() => api.guest.getGuestUser(any(that: isSameUserAs(user))))
            .thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

        expectLater(
          client.wsConnectionStatusStream,
          emitsInOrder([
            // only emits the seed -> disconnected status
            // as the call never reaches `ws.connect`
            ConnectionStatus.disconnected,
          ]),
        );

        try {
          await client.connectGuestUser(user);
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());
        }

        verify(
          () => api.guest.getGuestUser(any(that: isSameUserAs(user))),
        ).called(1);
      });
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
      test('should throw if state does not contain user', () async {
        expect(client.state.currentUser, isNull);
        try {
          await client.openConnection();
        } catch (e) {
          expect(e, isA<AssertionError>());
        }
      });

      test('should throw if connection is already available', () async {
        expect(client.state.currentUser, isNull);
        try {
          await client.connectAnonymousUser();
          // waiting 300ms for `wsConnectionStatusStream` to emit
          await delay(300);

          await client.openConnection();
        } catch (e) {
          expect(e, isA<StreamChatError>());
          final err = e as StreamChatError;
          expect(
            err.message.contains('Connection already available for'),
            isTrue,
          );
        }
      });

      test('should open connection for closed connection', () async {
        expectLater(
          client.wsConnectionStatusStream.skip(1),
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
    late final api = FakeChatApi();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeUser());
    });

    setUp(() {
      final ws = FakeWebSocketWithConnectionError();
      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
    });

    tearDown(() {
      client.dispose();
    });

    test('`.connectUser` should throw if `ws.connect` fails', () async {
      final user = User(id: 'test-user-id');
      final token = Token.development(user.id).rawValue;

      try {
        await client.connectUser(user, token);
      } catch (e) {
        expect(e, isA<StreamWebSocketError>());
      }
    });

    test(
      '`.connectUserWithProvider` should throw if `ws.connect` fails',
      () async {
        final user = User(id: 'test-user-id');
        Future<String> tokenProvider(String userId) async {
          expect(userId, user.id);
          return Token.development(userId).rawValue;
        }

        try {
          await client.connectUserWithProvider(user, tokenProvider);
        } catch (e) {
          expect(e, isA<StreamWebSocketError>());
        }
      },
    );

    test('`.connectGuestUser` should throw if `ws.connect` fails', () async {
      final user = User(id: 'test-user-id');
      final token = Token.development(user.id).rawValue;

      when(() => api.guest.getGuestUser(any(that: isSameUserAs(user))))
          .thenAnswer(
        (_) async => ConnectGuestUserResponse()
          ..user = user
          ..accessToken = token,
      );

      try {
        await client.connectGuestUser(user);
      } catch (e) {
        expect(e, isA<StreamWebSocketError>());
      }
      verify(
        () => api.guest.getGuestUser(any(that: isSameUserAs(user))),
      ).called(1);
    });

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
      registerFallbackValue(FakeUser());
    });

    setUp(() {
      client = StreamChatClient(apiKey, chatApi: api);
    });

    tearDown(() {
      client.dispose();
    });

    test('`.connectUser` should succeed without connecting', () async {
      final user = User(id: 'test-user-id');
      final token = Token.development(user.id).rawValue;

      final res = await client.connectUser(
        user,
        token,
        connectWebSocket: false,
      );
      expect(res, isSameUserAs(user));
      expect(client.wsConnectionStatus, ConnectionStatus.disconnected);
    });

    test(
      '`.connectUserWithProvider` should succeed without connecting',
      () async {
        final user = User(id: 'test-user-id');
        Future<String> tokenProvider(String userId) async {
          expect(userId, user.id);
          return Token.development(userId).rawValue;
        }

        final res = await client.connectUserWithProvider(
          user,
          tokenProvider,
          connectWebSocket: false,
        );
        expect(res, isSameUserAs(user));
        expect(client.wsConnectionStatus, ConnectionStatus.disconnected);
      },
    );

    test('`.connectGuestUser` should succeed without connecting', () async {
      final user = User(id: 'test-user-id');
      final token = Token.development(user.id).rawValue;

      when(() => api.guest.getGuestUser(any(that: isSameUserAs(user))))
          .thenAnswer(
        (_) async => ConnectGuestUserResponse()
          ..user = user
          ..accessToken = token,
      );

      final res = await client.connectGuestUser(
        user,
        connectWebSocket: false,
      );

      expect(res, isSameUserAs(user));
      expect(client.wsConnectionStatus, ConnectionStatus.disconnected);
      verify(
        () => api.guest.getGuestUser(any(that: isSameUserAs(user))),
      ).called(1);
    });

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
    const apiKey = 'test-api-key';
    late final api = FakeChatApi();
    late final persistence = MockPersistenceClient();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeUser());
    });

    setUp(() {
      final ws = FakeWebSocketWithConnectionError();
      client = StreamChatClient(apiKey, chatApi: api, ws: ws)
        ..chatPersistenceClient = persistence;
    });

    tearDown(() {
      client.dispose();
    });

    test(
      '''`.connectUser` should connect successfully if persistence contains event''',
      () async {
        final user = User(id: 'test-user-id');
        final token = Token.development(user.id).rawValue;

        final event = Event(
            type: EventType.healthCheck,
            connectionId: 'test-connection-id',
            me: OwnUser.fromUser(user));
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
        Future<String> tokenProvider(String userId) async {
          expect(userId, user.id);
          return Token.development(userId).rawValue;
        }

        final event = Event(
            type: EventType.healthCheck,
            connectionId: 'test-connection-id',
            me: OwnUser.fromUser(user));
        when(persistence.getConnectionInfo).thenAnswer((_) async => event);

        final res = await client.connectUserWithProvider(user, tokenProvider);
        expect(res, isNotNull);
        expect(res, isSameUserAs(user));

        verify(persistence.getConnectionInfo).called(1);
        verifyNoMoreInteractions(persistence);
      },
    );

    test(
      '''`.connectGuestUser` should connect successfully if persistence contains event''',
      () async {
        final user = User(id: 'test-user-id');
        final token = Token.development(user.id).rawValue;

        final event = Event(
            type: EventType.healthCheck,
            connectionId: 'test-connection-id',
            me: OwnUser.fromUser(user));
        when(persistence.getConnectionInfo).thenAnswer((_) async => event);

        when(() => api.guest.getGuestUser(any(that: isSameUserAs(user))))
            .thenAnswer(
          (_) async => ConnectGuestUserResponse()
            ..user = user
            ..accessToken = token,
        );

        final res = await client.connectGuestUser(user);
        expect(res, isNotNull);
        expect(res, isSameUserAs(user));

        verify(persistence.getConnectionInfo).called(1);
        verifyNoMoreInteractions(persistence);
        verify(() => api.guest.getGuestUser(any(that: isSameUserAs(user))))
            .called(1);
        verifyNoMoreInteractions(api.guest);
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
    late final api = FakeChatApi();
    late final persistence = MockPersistenceClient();

    final user = User(id: 'test-user-id');
    final token = Token.development(user.id).rawValue;

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeEvent());
      registerFallbackValue(const PaginationParams());
      registerFallbackValue(FakeChannelState());
    });

    setUp(() async {
      when(() => persistence.updateLastSyncAt(any()))
          .thenAnswer((_) => Future.value());
      when(persistence.getLastSyncAt).thenAnswer((_) async => null);
      final ws = FakeWebSocket();
      client = StreamChatClient(apiKey, chatApi: api, ws: ws)
        ..chatPersistenceClient = persistence;
      await client.connectUser(user, token);
      await delay(300);
      expect(client.persistenceEnabled, isTrue);
      expect(client.wsConnectionStatus, ConnectionStatus.connected);
    });

    tearDown(() async {
      await client.dispose();
    });

    group('`.sync`', () {
      test(
        '''should update persistence connectionInfo and lastSync when sync succeeds''',
        () async {
          // persistence.updateLastSyncAt might be called
          // when connecting the user.
          // Resetting the logs so we start counting invocations correctly.
          reset(persistence);
          const cids = ['test-cid-1', 'test-cid-2', 'test-cid-3'];
          final lastSyncAt = DateTime.now();
          when(() => api.general.sync(cids, lastSyncAt))
              .thenAnswer((_) async => SyncResponse()
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
                ]);

          when(() => persistence.updateConnectionInfo(any()))
              .thenAnswer((_) => Future.value());
          when(() => persistence.updateLastSyncAt(any()))
              .thenAnswer((_) => Future.value());

          await client.sync(cids: cids, lastSyncAt: lastSyncAt);

          verify(() => persistence.updateConnectionInfo(any())).called(1);
          verify(() => persistence.updateLastSyncAt(any())).called(1);
          verify(() => api.general.sync(cids, lastSyncAt)).called(1);
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

          when(() => api.general.sync(cids, lastSyncAt))
              .thenAnswer((_) async => SyncResponse()
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
                    message: Message(id: 'test-message-id', text: 'Hey!'),
                  ),
                ]);

          when(() => persistence.updateConnectionInfo(any()))
              .thenAnswer((_) => Future.value());
          when(() => persistence.updateLastSyncAt(any()))
              .thenAnswer((_) => Future.value());

          await client.sync();

          verify(() => persistence.updateConnectionInfo(any())).called(1);
          verify(() => persistence.updateLastSyncAt(any())).called(1);
          verify(() => api.general.sync(cids, lastSyncAt)).called(1);
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

          when(() => persistence.getChannelStates(
                filter: any(named: 'filter'),
                channelStateSort: any(named: 'channelStateSort'),
                paginationParams: any(named: 'paginationParams'),
              )).thenAnswer((_) async => persistentChannelStates);

          final channelStates = List.generate(
            3,
            (index) => ChannelState(
              channel: ChannelModel(cid: 'test-type-$index:test-id-$index'),
            ),
          );

          when(() => api.channel.queryChannels(
                filter: any(named: 'filter'),
                sort: any(named: 'sort'),
                state: any(named: 'state'),
                watch: any(named: 'watch'),
                presence: any(named: 'presence'),
                memberLimit: any(named: 'memberLimit'),
                messageLimit: any(named: 'messageLimit'),
                paginationParams: any(named: 'paginationParams'),
              )).thenAnswer(
            (_) async => QueryChannelsResponse()..channels = channelStates,
          );

          when(() => persistence.getChannelThreads(any())).thenAnswer(
            (_) async => <String, List<Message>>{
              for (final channelState in channelStates)
                channelState.channel!.cid: [
                  Message(id: 'test-message-id', text: 'Test message')
                ],
            },
          );

          when(() => persistence.updateChannelState(any()))
              .thenAnswer((_) async {});
          when(() => persistence.updateChannelThreads(any(), any()))
              .thenAnswer((_) async {});
          when(() => persistence.updateChannelQueries(any(), any(),
                  clearQueryCache: any(named: 'clearQueryCache')))
              .thenAnswer((_) => Future.value());

          expectLater(
            client.queryChannels(),
            emitsInOrder([
              // emits persistent channels first
              persistentChannelStates.map(isCorrectChannelFor),
              // makes api call and emits network fetched channels
              channelStates.map(isCorrectChannelFor),
            ]),
          );

          // Hack as `teardown` gets called even
          // before our stream starts emitting data
          await delay(1050);

          verify(() => persistence.getChannelStates(
                filter: any(named: 'filter'),
                channelStateSort: any(named: 'channelStateSort'),
                paginationParams: any(named: 'paginationParams'),
              )).called(1);

          verify(() => api.channel.queryChannels(
                filter: any(named: 'filter'),
                sort: any(named: 'sort'),
                state: any(named: 'state'),
                watch: any(named: 'watch'),
                presence: any(named: 'presence'),
                memberLimit: any(named: 'memberLimit'),
                messageLimit: any(named: 'messageLimit'),
                paginationParams: any(named: 'paginationParams'),
              )).called(1);

          verify(() => persistence.getChannelThreads(any()))
              .called(channelStates.length);
          verify(() => persistence.updateChannelState(any()))
              .called(channelStates.length);
          verify(() => persistence.updateChannelThreads(any(), any()))
              .called(channelStates.length);
          verify(() => persistence.updateChannelQueries(any(), any(),
              clearQueryCache: any(named: 'clearQueryCache'))).called(1);
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

          when(() => persistence.getChannelStates(
                filter: any(named: 'filter'),
                channelStateSort: any(named: 'channelStateSort'),
                paginationParams: any(named: 'paginationParams'),
              )).thenAnswer((_) async => persistentChannelStates);

          when(() => api.channel.queryChannels(
                filter: any(named: 'filter'),
                sort: any(named: 'sort'),
                state: any(named: 'state'),
                watch: any(named: 'watch'),
                presence: any(named: 'presence'),
                memberLimit: any(named: 'memberLimit'),
                messageLimit: any(named: 'messageLimit'),
                paginationParams: any(named: 'paginationParams'),
              )).thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

          when(() => persistence.getChannelThreads(any())).thenAnswer(
            (_) async => <String, List<Message>>{
              for (final channelState in persistentChannelStates)
                channelState.channel!.cid: [
                  Message(id: 'test-message-id', text: 'Test message')
                ],
            },
          );

          when(() => persistence.updateChannelState(any()))
              .thenAnswer((_) async => {});
          when(() => persistence.updateChannelThreads(any(), any()))
              .thenAnswer((_) async => {});

          expectLater(
            client.queryChannels(),
            emitsInOrder([
              // emits persistent channels
              persistentChannelStates.map(isCorrectChannelFor),
            ]),
          );

          // Hack as `teardown` gets called even
          // before our stream starts emitting data
          await delay(1050);

          verify(() => persistence.getChannelStates(
                filter: any(named: 'filter'),
                channelStateSort: any(named: 'channelStateSort'),
                paginationParams: any(named: 'paginationParams'),
              )).called(1);

          verify(() => api.channel.queryChannels(
                filter: any(named: 'filter'),
                sort: any(named: 'sort'),
                state: any(named: 'state'),
                watch: any(named: 'watch'),
                presence: any(named: 'presence'),
                memberLimit: any(named: 'memberLimit'),
                messageLimit: any(named: 'messageLimit'),
                paginationParams: any(named: 'paginationParams'),
              )).called(1);

          verify(() => persistence.getChannelThreads(any()))
              .called(persistentChannelStates.length);
          verify(() => persistence.updateChannelState(any()))
              .called(persistentChannelStates.length);
          verify(() => persistence.updateChannelThreads(any(), any()))
              .called(persistentChannelStates.length);
        },
      );
    });

    test('`.disconnectUser` should reset state and user', () async {
      expect(client.state.currentUser, isNotNull);
      expect(client.wsConnectionStatus, ConnectionStatus.connected);

      expectLater(
        // skipping initial connected value
        client.wsConnectionStatusStream.skip(1),
        emits(ConnectionStatus.disconnected),
      );

      await client.disconnectUser(flushChatPersistence: true);

      expect(client.state.currentUser, isNull);
      expect(client.wsConnectionStatus, ConnectionStatus.disconnected);
    });
  });

  group('Client with connected user without persistence', () {
    const apiKey = 'test-api-key';
    const userId = 'test-user-id';
    late final api = FakeChatApi();

    final user = User(id: userId);
    final token = Token.development(user.id).rawValue;

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeEvent());
      registerFallbackValue(FakeMessage());
      registerFallbackValue(FakeDraftMessage());
      registerFallbackValue(FakePollVote());
      registerFallbackValue(const PaginationParams());
    });

    setUp(() async {
      final ws = FakeWebSocket();
      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
      await client.connectUser(user, token);
      await delay(300);
      expect(client.persistenceEnabled, isFalse);
      expect(client.wsConnectionStatus, ConnectionStatus.connected);
    });

    tearDown(() async {
      await client.dispose();
    });

    group('`.sync`', () {
      test('should work fine', () async {
        const cids = ['test-cid-1', 'test-cid-2', 'test-cid-3'];
        final lastSyncAt = DateTime.now();

        when(() => api.general.sync(cids, lastSyncAt))
            .thenAnswer((_) async => SyncResponse()
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
              ]);

        await client.sync(cids: cids, lastSyncAt: lastSyncAt);

        verify(() => api.general.sync(cids, lastSyncAt)).called(1);
      });

      test('should return if `cids` is not available', () async {
        expect(client.sync, returnsNormally);
        verifyNever(() => api.general.sync(any(), any()));
      });

      test('should return if `lastSyncAt` is not available', () async {
        expect(() => client.sync(cids: ['test-cid-1']), returnsNormally);
        verifyNever(() => api.general.sync(any(), any()));
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

        when(() => api.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            )).thenAnswer(
          (_) async => QueryChannelsResponse()..channels = channelStates,
        );

        expectLater(
          client.queryChannels(),
          emitsInOrder([channelStates.map(isCorrectChannelFor)]),
        );

        // Hack as `teardown` gets called even
        // before our stream starts emitting data
        await delay(300);

        verify(() => api.channel.queryChannels(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              memberLimit: any(named: 'memberLimit'),
              messageLimit: any(named: 'messageLimit'),
              paginationParams: any(named: 'paginationParams'),
            )).called(1);
      });

      test(
        '''should rethrow if `.queryChannelsOnline` throws and persistence channels are empty''',
        () async {
          when(() => api.channel.queryChannels(
                filter: any(named: 'filter'),
                sort: any(named: 'sort'),
                state: any(named: 'state'),
                watch: any(named: 'watch'),
                presence: any(named: 'presence'),
                memberLimit: any(named: 'memberLimit'),
                messageLimit: any(named: 'messageLimit'),
                paginationParams: any(named: 'paginationParams'),
              )).thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

          expectLater(
            client.queryChannels(),
            emitsError(isA<StreamChatNetworkError>()),
          );

          // Hack as `teardown` gets called even
          // before our stream starts emitting data
          await delay(300);

          verify(() => api.channel.queryChannels(
                filter: any(named: 'filter'),
                sort: any(named: 'sort'),
                state: any(named: 'state'),
                watch: any(named: 'watch'),
                presence: any(named: 'presence'),
                memberLimit: any(named: 'memberLimit'),
                messageLimit: any(named: 'messageLimit'),
                paginationParams: any(named: 'paginationParams'),
              )).called(1);
        },
      );
    });

    test('`.queryUsers`', () async {
      final users = List.generate(
        3,
        (index) => User(id: 'test-user-id-$index'),
      );

      when(() => api.user.queryUsers(
            presence: any(named: 'presence'),
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          )).thenAnswer((_) async => QueryUsersResponse()..users = users);

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

      verify(() => api.user.queryUsers(
            presence: any(named: 'presence'),
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          )).called(1);
      verifyNoMoreInteractions(api.user);
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
      final filter = Filter.equal('channel_cid', cid);

      when(() => api.moderation.queryBannedUsers(
            filter: filter,
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          )).thenAnswer((_) async => QueryBannedUsersResponse()..bans = bans);

      final res = await client.queryBannedUsers(filter: filter);
      expect(res, isNotNull);
      expect(res.bans.length, bans.length);

      verify(() => api.moderation.queryBannedUsers(
            filter: filter,
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          )).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.search`', () async {
      const cid = 'test-type:test-id';
      final filter = Filter.in_('cid', const [cid]);

      final messages = List.generate(
        3,
        (index) => GetMessageResponse()
          ..channel = ChannelModel(cid: cid)
          ..message = Message(id: 'test-message-id-$index'),
      );

      when(() => api.general.searchMessages(filter,
              query: any(named: 'query'),
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
              messageFilters: any(named: 'messageFilters')))
          .thenAnswer(
              (_) async => SearchMessagesResponse()..results = messages);

      final res = await client.search(filter);
      expect(res, isNotNull);
      expect(res.results.length, messages.length);

      verify(() => api.general.searchMessages(filter,
          query: any(named: 'query'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
          messageFilters: any(named: 'messageFilters'))).called(1);
      verifyNoMoreInteractions(api.general);
    });

    test('`.sendFile`', () async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      final file = AttachmentFile(size: 33, path: 'test-file-path');

      const fileUrl = 'test-file-url';

      when(() => api.fileUploader.sendFile(file, channelId, channelType))
          .thenAnswer((_) async => SendFileResponse()..file = fileUrl);

      final res = await client.sendFile(file, channelId, channelType);
      expect(res, isNotNull);
      expect(res.file, fileUrl);

      verify(() => api.fileUploader.sendFile(file, channelId, channelType))
          .called(1);
      verifyNoMoreInteractions(api.fileUploader);
    });

    test('`.sendImage`', () async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      final image = AttachmentFile(size: 33, path: 'test-image-path');

      const fileUrl = 'test-image-url';

      when(() => api.fileUploader.sendImage(image, channelId, channelType))
          .thenAnswer((_) async => SendImageResponse()..file = fileUrl);

      final res = await client.sendImage(image, channelId, channelType);
      expect(res, isNotNull);
      expect(res.file, fileUrl);

      verify(() => api.fileUploader.sendImage(image, channelId, channelType))
          .called(1);
      verifyNoMoreInteractions(api.fileUploader);
    });

    test('`.deleteFile`', () async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      const fileUrl = 'test-file-url';

      when(() => api.fileUploader.deleteFile(fileUrl, channelId, channelType))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.deleteFile(fileUrl, channelId, channelType);
      expect(res, isNotNull);

      verify(() => api.fileUploader.deleteFile(fileUrl, channelId, channelType))
          .called(1);
      verifyNoMoreInteractions(api.fileUploader);
    });

    test('`.deleteImage`', () async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      const imageUrl = 'test-image-url';

      when(() => api.fileUploader.deleteImage(imageUrl, channelId, channelType))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.deleteImage(imageUrl, channelId, channelType);
      expect(res, isNotNull);

      verify(
        () => api.fileUploader.deleteImage(imageUrl, channelId, channelType),
      ).called(1);
      verifyNoMoreInteractions(api.fileUploader);
    });

    test('`.updateChannel`', () async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      const data = {'name': 'test-channel'};

      when(() => api.channel.updateChannel(channelId, channelType, data))
          .thenAnswer((invocation) async => UpdateChannelResponse()
            ..channel = ChannelModel(
              id: channelId,
              type: channelType,
              extraData: {...data},
            ));

      final res = await client.updateChannel(channelId, channelType, data);
      expect(res, isNotNull);
      expect(res.channel.cid, '$channelType:$channelId');
      expect(res.channel.extraData['name'], 'test-channel');

      verify(() => api.channel.updateChannel(channelId, channelType, data))
          .called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.updateChannelPartial`', () async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      const set = {
        'name': 'Stream Team',
        'profile_image': 'test-profile-image',
      };
      const unset = ['tag', 'last_name'];

      when(() => api.channel.updateChannelPartial(channelId, channelType,
              set: set, unset: unset))
          .thenAnswer((invocation) async => PartialUpdateChannelResponse()
            ..channel = ChannelModel(
              id: channelId,
              type: channelType,
              extraData: {...set},
            ));

      final res = await client.updateChannelPartial(
        channelId,
        channelType,
        set: set,
        unset: unset,
      );
      expect(res, isNotNull);
      expect(res.channel.cid, '$channelType:$channelId');
      expect(res.channel.extraData, set);

      verify(() => api.channel.updateChannelPartial(channelId, channelType,
          set: set, unset: unset)).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.addDevice should work`', () async {
      const id = 'test-device-id';
      const provider = PushProvider.firebase;

      when(() => api.device.addDevice(id, provider))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.addDevice(id, provider);
      expect(res, isNotNull);

      verify(() => api.device.addDevice(id, provider)).called(1);
      verifyNoMoreInteractions(api.device);
    });

    test('`.addDevice should work with pushProviderName`', () async {
      const id = 'test-device-id';
      const provider = PushProvider.firebase;
      const pushProviderName = 'my-custom-config';

      when(
        () => api.device.addDevice(
          id,
          provider,
          pushProviderName: pushProviderName,
        ),
      ).thenAnswer((_) async => EmptyResponse());

      final res = await client.addDevice(
        id,
        provider,
        pushProviderName: pushProviderName,
      );
      expect(res, isNotNull);

      verify(() => api.device.addDevice(
            id,
            provider,
            pushProviderName: pushProviderName,
          )).called(1);
      verifyNoMoreInteractions(api.device);
    });

    test('`.getDevices`', () async {
      final devices = List.generate(
        3,
        (index) => Device(
          id: 'test-device-id-$index',
          pushProvider: PushProvider.firebase.name,
        ),
      );

      when(() => api.device.getDevices())
          .thenAnswer((_) async => ListDevicesResponse()..devices = devices);

      final res = await client.getDevices();
      expect(res, isNotNull);
      expect(res.devices.length, devices.length);

      verify(() => api.device.getDevices()).called(1);
      verifyNoMoreInteractions(api.device);
    });

    test('`.removeDevice`', () async {
      const deviceId = 'test-device-id';

      when(() => api.device.removeDevice(deviceId))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.removeDevice(deviceId);
      expect(res, isNotNull);

      verify(() => api.device.removeDevice(deviceId)).called(1);
      verifyNoMoreInteractions(api.device);
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
      when(() => api.device.setPushPreferences(preferences)).thenAnswer(
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

      verify(() => api.device.setPushPreferences(preferences)).called(1);
      verifyNoMoreInteractions(api.device);
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

    test('`.devToken`', () async {
      const userId = 'test-user-id';

      final token = client.devToken(userId);

      expect(token, isNotNull);
      expect(token.userId, userId);
      expect(token.authType, AuthType.jwt);
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

      test('should return back in memory channel instance if available',
          () async {
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

        when(() => api.channel.queryChannel(
              channelType,
              channelId: channelId,
              channelData: channelData,
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              messagesPagination: any(named: 'messagesPagination'),
              membersPagination: any(named: 'membersPagination'),
              watchersPagination: any(named: 'watchersPagination'),
            )).thenAnswer((_) async => channelState);

        expectLater(
          client.state.channelsStream.skip(1),
          emitsInOrder([
            {channelCid: isCorrectChannelFor(channelState)}
          ]),
        );

        await channel.watch();

        final newChannel = client.channel(channelType, id: channelId);
        expect(newChannel, channel);

        verify(() => api.channel.queryChannel(
              channelType,
              channelId: channelId,
              channelData: channelData,
              state: any(named: 'state'),
              watch: any(named: 'watch'),
              presence: any(named: 'presence'),
              messagesPagination: any(named: 'messagesPagination'),
              membersPagination: any(named: 'membersPagination'),
              watchersPagination: any(named: 'watchersPagination'),
            )).called(1);
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

      when(() => api.channel.queryChannel(
            channelType,
            channelId: channelId,
            channelData: channelData,
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          )).thenAnswer((_) async => channelState);

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

      verify(() => api.channel.queryChannel(
            channelType,
            channelId: channelId,
            channelData: channelData,
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          )).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.watchChannel`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const channelData = {'name': 'test-channel-name'};
      const channelCid = '$channelType:$channelId';

      final channelState = ChannelState(
        channel: ChannelModel(cid: channelCid, extraData: channelData),
      );

      when(() => api.channel.queryChannel(
            channelType,
            channelId: channelId,
            channelData: channelData,
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          )).thenAnswer((_) async => channelState);

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

      verify(() => api.channel.queryChannel(
            channelType,
            channelId: channelId,
            channelData: channelData,
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          )).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.queryChannel`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const channelData = {'name': 'test-channel-name'};
      const channelCid = '$channelType:$channelId';

      final channelState = ChannelState(
        channel: ChannelModel(cid: channelCid, extraData: channelData),
      );

      when(() => api.channel.queryChannel(
            channelType,
            channelId: channelId,
            channelData: channelData,
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          )).thenAnswer((_) async => channelState);

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

      verify(() => api.channel.queryChannel(
            channelType,
            channelId: channelId,
            channelData: channelData,
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          )).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.queryMembers`', () async {
      const channelType = 'test-channel-type';

      final members = List.generate(
        3,
        (index) => Member(userId: 'test-user-id-$index'),
      );

      when(() => api.general.queryMembers(channelType)).thenAnswer(
        (_) async => QueryMembersResponse()..members = members,
      );

      final res = await client.queryMembers(channelType);
      expect(res, isNotNull);
      expect(res.members.length, members.length);

      verify(() => api.general.queryMembers(channelType)).called(1);
      verifyNoMoreInteractions(api.general);
    });

    test('`.hideChannel`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';

      when(() => api.channel.hideChannel(channelId, channelType))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.hideChannel(channelId, channelType);

      expect(res, isNotNull);

      verify(() => api.channel.hideChannel(channelId, channelType)).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.showChannel`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';

      when(() => api.channel.showChannel(channelId, channelType))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.showChannel(channelId, channelType);

      expect(res, isNotNull);

      verify(() => api.channel.showChannel(channelId, channelType)).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.deleteChannel`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';

      when(() => api.channel.deleteChannel(channelId, channelType))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.deleteChannel(channelId, channelType);

      expect(res, isNotNull);

      verify(() => api.channel.deleteChannel(channelId, channelType)).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.truncateChannel`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';

      when(() => api.channel.truncateChannel(channelId, channelType))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.truncateChannel(channelId, channelType);

      expect(res, isNotNull);

      verify(
        () => api.channel.truncateChannel(channelId, channelType),
      ).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.muteChannel`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const channelCid = '$channelType:$channelId';

      when(() => api.moderation.muteChannel(channelCid))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.muteChannel(channelCid);

      expect(res, isNotNull);

      verify(() => api.moderation.muteChannel(channelCid)).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.unmuteChannel`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const channelCid = '$channelType:$channelId';

      when(() => api.moderation.unmuteChannel(channelCid))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.unmuteChannel(channelCid);

      expect(res, isNotNull);

      verify(() => api.moderation.unmuteChannel(channelCid)).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.partialMemberUpdate with userId`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const otherUserId = 'test-other-user-id';
      const set = {'pinned': true};
      const unset = ['pinned'];

      when(() => api.channel.updateMemberPartial(
            channelId: channelId,
            channelType: channelType,
            set: set,
            unset: unset,
          )).thenAnswer((_) async => FakePartialUpdateMemberResponse(
            channelMember: Member(userId: otherUserId),
          ));

      final res = await client.partialMemberUpdate(
        channelId: channelId,
        channelType: channelType,
        set: set,
        unset: unset,
      );

      expect(res, isNotNull);
      expect(res.channelMember.userId, otherUserId);

      verify(() => api.channel.updateMemberPartial(
            channelId: channelId,
            channelType: channelType,
            set: set,
            unset: unset,
          )).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.partialMemberUpdate with current user`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const set = {'pinned': true};
      const unset = ['pinned'];

      when(() => api.channel.updateMemberPartial(
            channelId: channelId,
            channelType: channelType,
            set: set,
            unset: unset,
          )).thenAnswer((_) async => FakePartialUpdateMemberResponse(
            channelMember: Member(userId: userId),
          ));

      final res = await client.partialMemberUpdate(
        channelId: channelId,
        channelType: channelType,
        set: set,
        unset: unset,
      );

      expect(res, isNotNull);
      expect(res.channelMember.userId, userId);
      verify(() => api.channel.updateMemberPartial(
            channelId: channelId,
            channelType: channelType,
            set: set,
            unset: unset,
          )).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.pinChannel`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';

      when(() => api.channel.updateMemberPartial(
            channelId: channelId,
            channelType: channelType,
            set: const MemberUpdatePayload(pinned: true).toJson(),
          )).thenAnswer((_) async => FakePartialUpdateMemberResponse(
            channelMember: Member(userId: userId, pinnedAt: DateTime.now()),
          ));

      final res = await client.pinChannel(
        channelId: channelId,
        channelType: channelType,
      );

      expect(res, isNotNull);

      verify(() => api.channel.updateMemberPartial(
            channelId: channelId,
            channelType: channelType,
            set: const MemberUpdatePayload(pinned: true).toJson(),
          )).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.unpinChannel`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';

      when(() => api.channel.updateMemberPartial(
            channelId: channelId,
            channelType: channelType,
            unset: [MemberUpdateType.pinned.name],
          )).thenAnswer((_) async => FakePartialUpdateMemberResponse(
            channelMember: Member(userId: userId, pinnedAt: DateTime.now()),
          ));

      final res = await client.unpinChannel(
        channelId: channelId,
        channelType: channelType,
      );

      expect(res, isNotNull);

      verify(() => api.channel.updateMemberPartial(
            channelId: channelId,
            channelType: channelType,
            unset: [MemberUpdateType.pinned.name],
          )).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.archiveChannel`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';

      when(() => api.channel.updateMemberPartial(
            channelId: channelId,
            channelType: channelType,
            set: const MemberUpdatePayload(archived: true).toJson(),
          )).thenAnswer((_) async => FakePartialUpdateMemberResponse(
            channelMember: Member(userId: userId, archivedAt: DateTime.now()),
          ));

      final res = await client.archiveChannel(
        channelId: channelId,
        channelType: channelType,
      );

      expect(res, isNotNull);

      verify(() => api.channel.updateMemberPartial(
            channelId: channelId,
            channelType: channelType,
            set: const MemberUpdatePayload(archived: true).toJson(),
          )).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.unarchiveChannel`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';

      when(() => api.channel.updateMemberPartial(
            channelId: channelId,
            channelType: channelType,
            unset: [MemberUpdateType.archived.name],
          )).thenAnswer((_) async => FakePartialUpdateMemberResponse(
            channelMember: Member(userId: userId, pinnedAt: DateTime.now()),
          ));

      final res = await client.unarchiveChannel(
        channelId: channelId,
        channelType: channelType,
      );

      expect(res, isNotNull);

      verify(() => api.channel.updateMemberPartial(
            channelId: channelId,
            channelType: channelType,
            unset: [MemberUpdateType.archived.name],
          )).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.acceptChannelInvite`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const channelCid = '$channelType:$channelId';

      when(() => api.channel.acceptChannelInvite(channelId, channelType))
          .thenAnswer((_) async =>
              AcceptInviteResponse()..channel = ChannelModel(cid: channelCid));

      final res = await client.acceptChannelInvite(channelId, channelType);
      expect(res, isNotNull);
      expect(res.channel.cid, channelCid);

      verify(() => api.channel.acceptChannelInvite(channelId, channelType))
          .called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.rejectChannelInvite`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const channelCid = '$channelType:$channelId';

      when(() => api.channel.rejectChannelInvite(channelId, channelType))
          .thenAnswer((_) async =>
              RejectInviteResponse()..channel = ChannelModel(cid: channelCid));

      final res = await client.rejectChannelInvite(channelId, channelType);
      expect(res, isNotNull);
      expect(res.channel.cid, channelCid);

      verify(() => api.channel.rejectChannelInvite(channelId, channelType))
          .called(1);
      verifyNoMoreInteractions(api.channel);
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

      when(() => api.channel.addMembers(channelId, channelType, memberIds))
          .thenAnswer((_) async => AddMembersResponse()
            ..channel = ChannelModel(cid: channelCid)
            ..members = members);

      final res = await client.addChannelMembers(
        channelId,
        channelType,
        memberIds,
      );

      expect(res, isNotNull);
      expect(res.channel.cid, channelCid);
      expect(res.members.length, memberIds.length);

      verify(
        () => api.channel.addMembers(channelId, channelType, memberIds),
      ).called(1);
      verifyNoMoreInteractions(api.channel);
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

      when(() => api.channel.removeMembers(channelId, channelType, memberIds))
          .thenAnswer((_) async => RemoveMembersResponse()
            ..channel = ChannelModel(cid: channelCid)
            ..members = members);

      final res = await client.removeChannelMembers(
        channelId,
        channelType,
        memberIds,
      );

      expect(res, isNotNull);
      expect(res.channel.cid, channelCid);
      expect(res.members.length, memberIds.length);

      verify(
        () => api.channel.removeMembers(channelId, channelType, memberIds),
      ).called(1);
      verifyNoMoreInteractions(api.channel);
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

      when(() => api.channel
              .inviteChannelMembers(channelId, channelType, memberIds))
          .thenAnswer((_) async => InviteMembersResponse()
            ..channel = ChannelModel(cid: channelCid)
            ..members = members);

      final res = await client.inviteChannelMembers(
        channelId,
        channelType,
        memberIds,
      );

      expect(res, isNotNull);
      expect(res.channel.cid, channelCid);
      expect(res.members.length, memberIds.length);

      verify(() => api.channel
          .inviteChannelMembers(channelId, channelType, memberIds)).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.stopChannelWatching`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';

      when(() => api.channel.stopWatching(channelId, channelType))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.stopChannelWatching(channelId, channelType);
      expect(res, isNotNull);

      verify(() => api.channel.stopWatching(channelId, channelType)).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.sendAction`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const messageId = 'test-message-id';
      const formData = {'key': 'value'};

      when(() => api.message
              .sendAction(channelId, channelType, messageId, formData))
          .thenAnswer((_) async => SendActionResponse());

      final res = await client.sendAction(
        channelId,
        channelType,
        messageId,
        formData,
      );

      expect(res, isNotNull);

      verify(() => api.message
          .sendAction(channelId, channelType, messageId, formData)).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.markChannelRead`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';

      when(() => api.channel.markRead(channelId, channelType))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.markChannelRead(channelId, channelType);

      expect(res, isNotNull);

      verify(() => api.channel.markRead(channelId, channelType)).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.markChannelUnread`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      const messageId = 'test-message-id';

      when(() => api.channel.markUnread(channelId, channelType, messageId))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.markChannelUnread(
        channelId,
        channelType,
        messageId,
      );

      expect(res, isNotNull);

      verify(() => api.channel.markUnread(channelId, channelType, messageId))
          .called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.createPoll`', () async {
      final poll = Poll(
        name: 'What is your favorite color?',
        options: const [
          PollOption(text: 'Red'),
          PollOption(text: 'Blue'),
        ],
      );

      when(() => api.polls.createPoll(poll)).thenAnswer(
        (_) async => CreatePollResponse()..poll = poll,
      );

      final res = await client.createPoll(poll);
      expect(res, isNotNull);
      expect(res.poll, poll);

      verify(() => api.polls.createPoll(poll)).called(1);
      verifyNoMoreInteractions(api.polls);
    });

    test('`.getPoll`', () async {
      const pollId = 'test-poll-id';
      final poll = Poll(
        id: pollId,
        name: 'What is your favorite color?',
        options: const [
          PollOption(text: 'Red'),
          PollOption(text: 'Blue'),
        ],
      );

      when(() => api.polls.getPoll(pollId)).thenAnswer(
        (_) async => GetPollResponse()..poll = poll,
      );

      final res = await client.getPoll(pollId);
      expect(res, isNotNull);
      expect(res.poll, poll);

      verify(() => api.polls.getPoll(pollId)).called(1);
      verifyNoMoreInteractions(api.polls);
    });

    test('`.updatePoll`', () async {
      final poll = Poll(
        id: 'test-poll-id',
        name: 'What is your favorite color?',
        options: const [
          PollOption(text: 'Red'),
          PollOption(text: 'Blue'),
        ],
      );

      when(() => api.polls.updatePoll(poll)).thenAnswer(
        (_) async => UpdatePollResponse()..poll = poll,
      );

      final res = await client.updatePoll(poll);
      expect(res, isNotNull);
      expect(res.poll, poll);

      verify(() => api.polls.updatePoll(poll)).called(1);
      verifyNoMoreInteractions(api.polls);
    });

    test('`.partialUpdatePoll`', () async {
      const pollId = 'test-poll-id';
      final set = {'name': 'What is your favorite color?'};
      final unset = <String>[];

      final poll = Poll(
        id: pollId,
        name: set['name']!,
        options: const [
          PollOption(text: 'Red'),
          PollOption(text: 'Blue'),
        ],
      );

      when(() => api.polls.partialUpdatePoll(pollId, set: set, unset: unset))
          .thenAnswer((_) async => UpdatePollResponse()..poll = poll);

      final res =
          await client.partialUpdatePoll(pollId, set: set, unset: unset);
      expect(res, isNotNull);
      expect(res.poll.id, pollId);
      expect(res.poll.name, set['name']);

      verify(() => api.polls.partialUpdatePoll(pollId, set: set, unset: unset))
          .called(1);
      verifyNoMoreInteractions(api.polls);
    });

    test('`.deletePoll`', () async {
      const pollId = 'test-poll-id';

      when(() => api.polls.deletePoll(pollId))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.deletePoll(pollId);
      expect(res, isNotNull);

      verify(() => api.polls.deletePoll(pollId)).called(1);
      verifyNoMoreInteractions(api.polls);
    });

    test('`.closePoll`', () async {
      const pollId = 'test-poll-id';

      when(() => api.polls.partialUpdatePoll(pollId, set: {'is_closed': true}))
          .thenAnswer((_) async => UpdatePollResponse());

      final res = await client.closePoll(pollId);
      expect(res, isNotNull);

      verify(() =>
              api.polls.partialUpdatePoll(pollId, set: {'is_closed': true}))
          .called(1);
      verifyNoMoreInteractions(api.polls);
    });

    test('`.createPollOption`', () async {
      const pollId = 'test-poll-id';
      const option = PollOption(text: 'Red');

      when(() => api.polls.createPollOption(pollId, option)).thenAnswer(
          (_) async => CreatePollOptionResponse()..pollOption = option);

      final res = await client.createPollOption(pollId, option);
      expect(res, isNotNull);
      expect(res.pollOption, option);

      verify(() => api.polls.createPollOption(pollId, option)).called(1);
      verifyNoMoreInteractions(api.polls);
    });

    test('`.getPollOption`', () async {
      const pollId = 'test-poll-id';
      const optionId = 'test-option-id';
      const option = PollOption(id: optionId, text: 'Red');

      when(() => api.polls.getPollOption(pollId, optionId)).thenAnswer(
          (_) async => GetPollOptionResponse()..pollOption = option);

      final res = await client.getPollOption(pollId, optionId);
      expect(res, isNotNull);
      expect(res.pollOption, option);

      verify(() => api.polls.getPollOption(pollId, optionId)).called(1);
      verifyNoMoreInteractions(api.polls);
    });

    test('`.updatePollOption`', () async {
      const pollId = 'test-poll-id';
      const option = PollOption(id: 'test-option-id', text: 'Red');

      when(() => api.polls.updatePollOption(pollId, option)).thenAnswer(
          (_) async => UpdatePollOptionResponse()..pollOption = option);

      final res = await client.updatePollOption(pollId, option);
      expect(res, isNotNull);
      expect(res.pollOption, option);

      verify(() => api.polls.updatePollOption(pollId, option)).called(1);
      verifyNoMoreInteractions(api.polls);
    });

    test('`.deletePollOption`', () async {
      const pollId = 'test-poll-id';
      const optionId = 'test-option-id';

      when(() => api.polls.deletePollOption(pollId, optionId))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.deletePollOption(pollId, optionId);
      expect(res, isNotNull);

      verify(() => api.polls.deletePollOption(pollId, optionId)).called(1);
      verifyNoMoreInteractions(api.polls);
    });

    test('`.castPollVote`', () async {
      const messageId = 'test-message-id';
      const pollId = 'test-poll-id';
      const optionId = 'test-option-id';
      final vote = PollVote(optionId: optionId);

      // Custom matcher to check if the Vote object has the specified id
      Matcher matchesVoteOption(String expected) => predicate<PollVote>(
            (vote) => vote.optionId == expected,
            'Vote with option $expected',
          );

      when(() => api.polls.castPollVote(
              messageId, pollId, any(that: matchesVoteOption(optionId))))
          .thenAnswer((_) async => CastPollVoteResponse()..vote = vote);

      final res =
          await client.castPollVote(messageId, pollId, optionId: optionId);
      expect(res, isNotNull);
      expect(res.vote, vote);

      verify(() => api.polls.castPollVote(
          messageId, pollId, any(that: matchesVoteOption(optionId)))).called(1);
      verifyNoMoreInteractions(api.polls);
    });

    test('`.addPollAnswer`', () async {
      const messageId = 'test-message-id';
      const pollId = 'test-poll-id';
      const answerText = 'Red';
      final vote = PollVote(answerText: answerText);

      // Custom matcher to check if the Vote object has the specified id
      Matcher matchesVoteAnswer(String expected) => predicate<PollVote>(
            (vote) => vote.answerText == expected,
            'Vote with answer $expected',
          );

      when(() => api.polls.castPollVote(
              messageId, pollId, any(that: matchesVoteAnswer(answerText))))
          .thenAnswer((_) async => CastPollVoteResponse()..vote = vote);

      final res =
          await client.addPollAnswer(messageId, pollId, answerText: answerText);
      expect(res, isNotNull);
      expect(res.vote, vote);

      verify(() => api.polls.castPollVote(
              messageId, pollId, any(that: matchesVoteAnswer(answerText))))
          .called(1);
      verifyNoMoreInteractions(api.polls);
    });

    test('`.removePollVote`', () async {
      const messageId = 'test-message-id';
      const pollId = 'test-poll-id';
      const voteId = 'test-vote-id';

      when(() => api.polls.removePollVote(messageId, pollId, voteId))
          .thenAnswer((_) async => RemovePollVoteResponse());

      final res = await client.removePollVote(messageId, pollId, voteId);
      expect(res, isNotNull);

      verify(() => api.polls.removePollVote(messageId, pollId, voteId))
          .called(1);
      verifyNoMoreInteractions(api.polls);
    });

    test('`.queryPolls`', () async {
      final filter = Filter.in_('id', const ['test-poll-id']);
      final sort = [const SortOption<Poll>.desc('created_at')];
      const pagination = PaginationParams(limit: 20);

      final polls = List.generate(
        pagination.limit,
        (index) => Poll(
          id: 'test-poll-id-$index',
          name: 'What is your favorite color?',
          options: const [
            PollOption(text: 'Red'),
            PollOption(text: 'Blue'),
          ],
        ),
      );

      when(() => api.polls.queryPolls(
            filter: filter,
            sort: sort,
            pagination: pagination,
          )).thenAnswer(
        (_) async => QueryPollsResponse()..polls = polls,
      );

      final res = await client.queryPolls(
        filter: filter,
        sort: sort,
        pagination: pagination,
      );
      expect(res, isNotNull);
      expect(res.polls.length, polls.length);

      verify(() => api.polls.queryPolls(
            filter: filter,
            sort: sort,
            pagination: pagination,
          )).called(1);
      verifyNoMoreInteractions(api.polls);
    });

    test('`.queryPollVotes`', () async {
      const pollId = 'test-poll-id';
      final filter = Filter.in_('id', const ['test-vote-id']);
      final sort = [const SortOption<PollVote>.desc('created_at')];
      const pagination = PaginationParams(limit: 20);

      final votes = List.generate(
        pagination.limit,
        (index) => PollVote(id: 'test-vote-id-$index', answerText: 'Red'),
      );

      when(() => api.polls.queryPollVotes(
            pollId,
            filter: filter,
            sort: sort,
            pagination: pagination,
          )).thenAnswer(
        (_) async => QueryPollVotesResponse()..votes = votes,
      );

      final res = await client.queryPollVotes(
        pollId,
        filter: filter,
        sort: sort,
        pagination: pagination,
      );
      expect(res, isNotNull);
      expect(res.votes.length, votes.length);

      verify(() => api.polls.queryPollVotes(
            pollId,
            filter: filter,
            sort: sort,
            pagination: pagination,
          )).called(1);
      verifyNoMoreInteractions(api.polls);
    });

    test('`.updateUser`', () async {
      final user = User(
        id: 'test-user-id',
        extraData: const {'name': 'test-user'},
      );

      when(() => api.user.updateUsers([user])).thenAnswer(
          (_) async => UpdateUsersResponse()..users = {user.id: user});

      final res = await client.updateUser(user);

      expect(res, isNotNull);
      expect(res.users, {user.id: user});

      verify(() => api.user.updateUsers([user])).called(1);
      verifyNoMoreInteractions(api.user);
    });

    test('`.partialUpdateUser`', () async {
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

      when(() => api.user.partialUpdateUsers([partialUpdateRequest]))
          .thenAnswer(
        (_) async => UpdateUsersResponse()
          ..users = {
            updatedUser.id: updatedUser,
          },
      );

      final res = await client.partialUpdateUser(
        userId,
        set: set,
        unset: unset,
      );

      expect(res, isNotNull);
      expect(res.users, {updatedUser.id: updatedUser});

      verify(
        () => api.user.partialUpdateUsers([partialUpdateRequest]),
      ).called(1);
      verifyNoMoreInteractions(api.user);
    });

    test('`.banUser`', () async {
      const userId = 'test-user-id';

      when(() => api.moderation.banUser(userId, options: any(named: 'options')))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.banUser(userId);

      expect(res, isNotNull);

      verify(
        () => api.moderation.banUser(userId, options: any(named: 'options')),
      ).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.unbanUser`', () async {
      const userId = 'test-user-id';

      when(() =>
              api.moderation.unbanUser(userId, options: any(named: 'options')))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.unbanUser(userId);

      expect(res, isNotNull);

      verify(
        () => api.moderation.unbanUser(userId, options: any(named: 'options')),
      ).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.blockUser`', () async {
      const userId = 'test-user-id';

      when(() => api.user.blockUser(userId)).thenAnswer(
        (_) async => UserBlockResponse.fromJson({
          'blocked_by_user_id': 'deven',
          'blocked_user_id': 'jaap',
          'created_at': '2024-10-01 12:45:23.456',
        }),
      );

      final res = await client.blockUser(userId);

      expect(res, isNotNull);

      verify(
        () => api.user.blockUser(userId),
      ).called(1);
      verifyNoMoreInteractions(api.user);
    });

    test('`.unblockUser`', () async {
      const userId = 'test-user-id';

      when(() => api.user.unblockUser(userId))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.unblockUser(userId);

      expect(res, isNotNull);

      verify(
        () => api.user.unblockUser(userId),
      ).called(1);
      verifyNoMoreInteractions(api.user);
    });

    test('`.queryBlockedUsers`', () async {
      final users = List.generate(
        3,
        (index) => User(id: 'test-user-id-$index'),
      );

      when(() => api.user.queryBlockedUsers()).thenAnswer(
        (_) async => BlockedUsersResponse()
          ..blocks = [
            UserBlock(user: users[0], blockedUser: users[1]),
            UserBlock(user: users[0], blockedUser: users[2]),
          ],
      );

      final res = await client.queryBlockedUsers();
      expect(res, isNotNull);
      expect(res.blocks.length, 2);

      verify(() => api.user.queryBlockedUsers()).called(1);
      verifyNoMoreInteractions(api.user);
    });

    group('Block user state management', () {
      test('blockUser should update blockedUserIds on client state', () async {
        final testUser = OwnUser(id: 'test-user');
        const userId = 'blocked-user-id';

        // Verify initial state
        expect(client.state.currentUser?.blockedUserIds, isEmpty);

        when(() => api.user.blockUser(userId)).thenAnswer(
          (_) async => UserBlockResponse()
            ..blockedUserId = userId
            ..blockedByUserId = testUser.id
            ..createdAt = DateTime.now(),
        );

        await client.blockUser(userId);

        // Verify - should now include the blocked user ID
        expect(client.state.currentUser?.blockedUserIds, contains(userId));
        verify(() => api.user.blockUser(userId)).called(1);
        verifyNoMoreInteractions(api.user);
      });

      test(
        'blockUser should not duplicate existing blocked user IDs',
        () async {
          const userId = 'blocked-user-id';
          client.state.blockedUserIds = const [userId];

          // Verify the user is already in the blocked list
          expect(client.state.currentUser?.blockedUserIds, contains(userId));

          when(() => api.user.blockUser(userId)).thenAnswer(
            (_) async => UserBlockResponse()
              ..blockedUserId = userId
              ..blockedByUserId = client.state.currentUser!.id
              ..createdAt = DateTime.now(),
          );

          await client.blockUser(userId);

          // Verify - should still have only one entry
          expect(client.state.currentUser?.blockedUserIds, contains(userId));
          expect(client.state.currentUser?.blockedUserIds.length, 1);
          verify(() => api.user.blockUser(userId)).called(1);
          verifyNoMoreInteractions(api.user);
        },
      );

      test('unblockUser should remove user from blockedUserIds', () async {
        const blockedUserId = 'blocked-user-id';
        const otherBlockedId = 'other-blocked-id';
        client.state.blockedUserIds = const [blockedUserId, otherBlockedId];

        // Verify initial state includes both blocked IDs
        expect(
          client.state.currentUser?.blockedUserIds,
          containsAll([blockedUserId, otherBlockedId]),
        );

        when(() => api.user.unblockUser(blockedUserId)).thenAnswer(
          (_) async => EmptyResponse(),
        );

        await client.unblockUser(blockedUserId);

        // Verify - blockedUserId should be removed
        expect(
          client.state.currentUser?.blockedUserIds,
          contains(otherBlockedId),
        );

        expect(
          client.state.currentUser?.blockedUserIds,
          isNot(contains(blockedUserId)),
        );

        verify(() => api.user.unblockUser(blockedUserId)).called(1);
        verifyNoMoreInteractions(api.user);
      });

      test(
        'unblockUser should be resilient if user ID not in blocked list',
        () async {
          const nonBlockedUserId = 'not-in-list';
          const otherBlockedId = 'other-blocked-id';
          client.state.blockedUserIds = const [otherBlockedId];

          // Verify initial state
          expect(
            client.state.currentUser?.blockedUserIds,
            contains(otherBlockedId),
          );

          expect(
            client.state.currentUser?.blockedUserIds,
            isNot(contains(nonBlockedUserId)),
          );

          when(() => api.user.unblockUser(nonBlockedUserId)).thenAnswer(
            (_) async => EmptyResponse(),
          );

          await client.unblockUser(nonBlockedUserId);

          // Verify - should remain unchanged
          expect(client.state.currentUser?.blockedUserIds,
              contains(otherBlockedId));
          expect(client.state.currentUser?.blockedUserIds,
              isNot(contains(nonBlockedUserId)));
          verify(() => api.user.unblockUser(nonBlockedUserId)).called(1);
          verifyNoMoreInteractions(api.user);
        },
      );

      test(
        'queryBlockedUsers should update client state with blockedUserIds',
        () async {
          const blockedId1 = 'blocked-1';
          const blockedId2 = 'blocked-2';

          // Verify initial state
          expect(client.state.currentUser?.blockedUserIds, isEmpty);

          // Create mock users
          final blockedUser1 = User(id: 'blocked-user-1');
          final blockedUser2 = User(id: 'blocked-user-2');

          // Mock the queryBlockedUsers API call
          when(() => api.user.queryBlockedUsers()).thenAnswer(
            (_) async => BlockedUsersResponse()
              ..blocks = [
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
          );

          await client.queryBlockedUsers();

          // Verify - should now include both blocked IDs
          expect(
            client.state.currentUser?.blockedUserIds,
            containsAll([blockedId1, blockedId2]),
          );

          verify(() => api.user.queryBlockedUsers()).called(1);
          verifyNoMoreInteractions(api.user);
        },
      );
    });

    test('`.getUnreadCount`', () async {
      when(() => api.user.getUnreadCount()).thenAnswer(
        (_) async => GetUnreadCountResponse()
          ..totalUnreadCount = 42
          ..totalUnreadThreadsCount = 8
          ..channelType = []
          ..channels = [
            UnreadCountsChannel(
              channelId: 'messaging:test-channel-1',
              unreadCount: 10,
              lastRead: DateTime.now(),
            ),
            UnreadCountsChannel(
              channelId: 'messaging:test-channel-2',
              unreadCount: 15,
              lastRead: DateTime.now(),
            ),
          ]
          ..threads = [
            UnreadCountsThread(
              unreadCount: 3,
              lastRead: DateTime.now(),
              lastReadMessageId: 'message-1',
              parentMessageId: 'parent-message-1',
            ),
            UnreadCountsThread(
              unreadCount: 5,
              lastRead: DateTime.now(),
              lastReadMessageId: 'message-2',
              parentMessageId: 'parent-message-2',
            ),
          ],
      );

      final res = await client.getUnreadCount();

      expect(res, isNotNull);
      expect(res.totalUnreadCount, 42);
      expect(res.totalUnreadThreadsCount, 8);

      verify(() => api.user.getUnreadCount()).called(1);
      verifyNoMoreInteractions(api.user);
    });

    test(
      '`.getUnreadCount` should also update user unread count as a side effect',
      () async {
        when(() => api.user.getUnreadCount()).thenAnswer(
          (_) async => GetUnreadCountResponse()
            ..totalUnreadCount = 25
            ..totalUnreadThreadsCount = 2
            ..channelType = []
            ..channels = [
              UnreadCountsChannel(
                channelId: 'messaging:test-channel-1',
                unreadCount: 10,
                lastRead: DateTime.now(),
              ),
              UnreadCountsChannel(
                channelId: 'messaging:test-channel-2',
                unreadCount: 15,
                lastRead: DateTime.now(),
              ),
            ]
            ..threads = [
              UnreadCountsThread(
                unreadCount: 3,
                lastRead: DateTime.now(),
                lastReadMessageId: 'message-1',
                parentMessageId: 'parent-message-1',
              ),
              UnreadCountsThread(
                unreadCount: 5,
                lastRead: DateTime.now(),
                lastReadMessageId: 'message-2',
                parentMessageId: 'parent-message-2',
              ),
            ],
        );

        client.getUnreadCount().ignore();

        // Wait for the local side effect event to be processed
        await Future.delayed(Duration.zero);

        expect(client.state.currentUser?.totalUnreadCount, 25);
        expect(client.state.currentUser?.unreadChannels, 2); // channels.length
        expect(client.state.currentUser?.unreadThreads, 2); // threads.length

        verify(() => api.user.getUnreadCount()).called(1);
        verifyNoMoreInteractions(api.user);
      },
    );

    test('`.shadowBan`', () async {
      const userId = 'test-user-id';

      when(() => api.moderation.banUser(userId, options: {'shadow': true}))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.shadowBan(userId);

      expect(res, isNotNull);

      verify(
        () => api.moderation.banUser(userId, options: {'shadow': true}),
      ).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.removeShadowBan`', () async {
      const userId = 'test-user-id';

      when(() => api.moderation.unbanUser(userId, options: {'shadow': true}))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.removeShadowBan(userId);

      expect(res, isNotNull);

      verify(
        () => api.moderation.unbanUser(userId, options: {'shadow': true}),
      ).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.muteUser`', () async {
      const userId = 'test-user-id';

      when(() => api.moderation.muteUser(userId))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.muteUser(userId);

      expect(res, isNotNull);

      verify(() => api.moderation.muteUser(userId)).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.unmuteUser`', () async {
      const userId = 'test-user-id';

      when(() => api.moderation.unmuteUser(userId))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.unmuteUser(userId);

      expect(res, isNotNull);

      verify(() => api.moderation.unmuteUser(userId)).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.flagMessage`', () async {
      const messageId = 'test-message-id';

      when(() => api.moderation.flagMessage(messageId))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.flagMessage(messageId);

      expect(res, isNotNull);

      verify(() => api.moderation.flagMessage(messageId)).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.unflagMessage`', () async {
      const messageId = 'test-message-id';

      when(() => api.moderation.unflagMessage(messageId))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.unflagMessage(messageId);

      expect(res, isNotNull);

      verify(() => api.moderation.unflagMessage(messageId)).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.flagUser`', () async {
      const userId = 'test-message-id';

      when(() => api.moderation.flagUser(userId))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.flagUser(userId);

      expect(res, isNotNull);

      verify(() => api.moderation.flagUser(userId)).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.unflagUser`', () async {
      const userId = 'test-message-id';

      when(() => api.moderation.unflagUser(userId))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.unflagUser(userId);

      expect(res, isNotNull);

      verify(() => api.moderation.unflagUser(userId)).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.markAllRead`', () async {
      when(() => api.channel.markAllRead())
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.markAllRead();
      expect(res, isNotNull);

      verify(() => api.channel.markAllRead()).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.sendEvent`', () async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      final event = Event(type: EventType.any);

      when(
        () => api.channel.sendEvent(
          channelId,
          channelType,
          any(that: isSameEventAs(event)),
        ),
      ).thenAnswer((_) async => EmptyResponse());

      final res = await client.sendEvent(channelId, channelType, event);
      expect(res, isNotNull);

      verify(() => api.channel.sendEvent(
            channelId,
            channelType,
            any(that: isSameEventAs(event)),
          )).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    group('`.sendReaction`', () {
      test('`.sendReaction with default params`', () async {
        const messageId = 'test-message-id';
        const reactionType = 'like';
        const extraData = {'score': 1};

        when(() => api.message.sendReaction(
              messageId,
              reactionType,
              extraData: extraData,
            )).thenAnswer((_) async => SendReactionResponse()
          ..message = Message(id: messageId)
          ..reaction = Reaction(type: reactionType, messageId: messageId));

        final res = await client.sendReaction(messageId, reactionType);
        expect(res, isNotNull);
        expect(res.message.id, messageId);
        expect(res.reaction.type, reactionType);
        expect(res.reaction.messageId, messageId);

        verify(() => api.message.sendReaction(
              messageId,
              reactionType,
              extraData: extraData,
            )).called(1);
        verifyNoMoreInteractions(api.message);
      });

      test('`.sendReaction with score`', () async {
        const messageId = 'test-message-id';
        const reactionType = 'like';
        const score = 3;
        const extraData = {'score': score};

        when(() => api.message.sendReaction(
              messageId,
              reactionType,
              extraData: extraData,
            )).thenAnswer((_) async => SendReactionResponse()
          ..message = Message(id: messageId)
          ..reaction = Reaction(
            type: reactionType,
            messageId: messageId,
            score: score,
          ));

        final res = await client.sendReaction(
          messageId,
          reactionType,
          score: score,
        );
        expect(res, isNotNull);
        expect(res.message.id, messageId);
        expect(res.reaction.type, reactionType);
        expect(res.reaction.messageId, messageId);
        expect(res.reaction.score, score);

        verify(() => api.message.sendReaction(
              messageId,
              reactionType,
              extraData: extraData,
            )).called(1);
        verifyNoMoreInteractions(api.message);
      });

      test('`.sendReaction with score passed in extradata also`', () async {
        const messageId = 'test-message-id';
        const reactionType = 'like';
        const score = 3;
        const extraDataScore = 5;
        const extraData = {'score': extraDataScore};

        when(() => api.message.sendReaction(
              messageId,
              reactionType,
              extraData: extraData,
            )).thenAnswer((_) async => SendReactionResponse()
          ..message = Message(id: messageId)
          ..reaction = Reaction(
            type: reactionType,
            messageId: messageId,
            score: extraDataScore,
          ));

        final res = await client.sendReaction(
          messageId,
          reactionType,
          score: score,
          extraData: extraData,
        );
        expect(res, isNotNull);
        expect(res.message.id, messageId);
        expect(res.reaction.type, reactionType);
        expect(res.reaction.messageId, messageId);
        expect(res.reaction.score, extraDataScore);

        verify(() => api.message.sendReaction(
              messageId,
              reactionType,
              extraData: extraData,
            )).called(1);
        verifyNoMoreInteractions(api.message);
      });
    });

    test('`.deleteReaction`', () async {
      const messageId = 'test-message-id';
      const reactionType = 'like';

      when(() => api.message.deleteReaction(messageId, reactionType))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.deleteReaction(messageId, reactionType);
      expect(res, isNotNull);

      verify(
        () => api.message.deleteReaction(messageId, reactionType),
      ).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.sendMessage`', () async {
      final message = Message(id: 'test-message-id');
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';

      when(() => api.message.sendMessage(
              channelId, channelType, any(that: isSameMessageAs(message))))
          .thenAnswer((_) async => SendMessageResponse()..message = message);

      final res = await client.sendMessage(message, channelId, channelType);
      expect(res, isNotNull);
      expect(res.message, isSameMessageAs(message));

      verify(() => api.message.sendMessage(
            channelId,
            channelType,
            any(that: isSameMessageAs(message)),
          )).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.createDraft`', () async {
      final message = DraftMessage(id: 'test-message-id', text: 'Hello!');
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';

      when(
        () => api.message.createDraft(
          channelId,
          channelType,
          any(that: isSameDraftMessageAs(message)),
        ),
      ).thenAnswer(
        (_) async => CreateDraftResponse()
          ..draft = Draft(
            channelCid: '$channelType:$channelId',
            createdAt: DateTime.now(),
            message: message,
          ),
      );

      final res = await client.createDraft(
        message,
        channelId,
        channelType,
      );

      expect(res, isNotNull);
      expect(res.draft.message, isSameDraftMessageAs(message));

      verify(() => api.message.createDraft(
            channelId,
            channelType,
            any(that: isSameDraftMessageAs(message)),
          )).called(1);

      verifyNoMoreInteractions(api.message);
    });

    test('`.deleteDraft`', () async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';

      when(() => api.message.deleteDraft(channelId, channelType))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.deleteDraft(channelId, channelType);
      expect(res, isNotNull);

      verify(() => api.message.deleteDraft(channelId, channelType));
      verifyNoMoreInteractions(api.message);
    });

    test('`.getDraft`', () async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';

      final message = DraftMessage(id: 'test-message-id', text: 'Hello!');

      when(() => api.message.getDraft(channelId, channelType))
          .thenAnswer((_) async => GetDraftResponse()
            ..draft = Draft(
              channelCid: '$channelType:$channelId',
              createdAt: DateTime.now(),
              message: message,
            ));

      final res = await client.getDraft(channelId, channelType);

      expect(res, isNotNull);
      expect(res.draft.message, isSameDraftMessageAs(message));

      verify(() => api.message.getDraft(channelId, channelType));
      verifyNoMoreInteractions(api.message);
    });

    test('`.queryDrafts`', () async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';

      final drafts = [
        Draft(
          channelCid: '$channelType:$channelId',
          createdAt: DateTime.now(),
          message: DraftMessage(id: 'test-message-id', text: 'Hello!'),
        )
      ];

      when(() => api.message.queryDrafts())
          .thenAnswer((_) async => QueryDraftsResponse()..drafts = drafts);

      final res = await client.queryDrafts();

      expect(res, isNotNull);
      expect(res.drafts.length, drafts.length);

      verify(() => api.message.queryDrafts()).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.getReplies`', () async {
      const parentId = 'test-parent-id';

      final messages = List.generate(
        3,
        (index) => Message(id: 'test-message-id-$index'),
      );

      when(() => api.message.getReplies(parentId))
          .thenAnswer((_) async => QueryRepliesResponse()..messages = messages);

      final res = await client.getReplies(parentId);
      expect(res, isNotNull);
      expect(res.messages.length, messages.length);

      verify(() => api.message.getReplies(parentId)).called(1);
      verifyNoMoreInteractions(api.message);
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

      when(() => api.message.getReactions(messageId)).thenAnswer(
          (_) async => QueryReactionsResponse()..reactions = reactions);

      final res = await client.getReactions(messageId);
      expect(res, isNotNull);
      expect(res.reactions.length, reactions.length);
      expect(res.reactions.every((it) => it.messageId == messageId), isTrue);

      verify(() => api.message.getReactions(messageId)).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.updateMessage`', () async {
      final message = Message(id: 'test-message-id', text: 'Hello!');

      when(() => api.message.updateMessage(any(that: isSameMessageAs(message))))
          .thenAnswer((_) async => UpdateMessageResponse()..message = message);

      final res = await client.updateMessage(message);
      expect(res, isNotNull);
      expect(res.message, isSameMessageAs(message));

      verify(
        () => api.message.updateMessage(any(that: isSameMessageAs(message))),
      ).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.deleteMessage`', () async {
      const messageId = 'test-message-id';

      when(() => api.message.deleteMessage(messageId, hard: false))
          .thenAnswer((_) async => EmptyResponse());

      final res = await client.deleteMessage(messageId);
      expect(res, isNotNull);

      verify(() => api.message.deleteMessage(messageId, hard: false)).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.getMessage`', () async {
      const messageId = 'test-message-id';
      final message = Message(id: messageId);

      when(() => api.message.getMessage(messageId))
          .thenAnswer((_) async => GetMessageResponse()..message = message);

      final res = await client.getMessage(messageId);
      expect(res, isNotNull);
      expect(res.message.id, messageId);

      verify(() => api.message.getMessage(messageId)).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.getMessagesById`', () async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      const messageIds = ['test-message-id'];

      final messages = messageIds.map((id) => Message(id: id)).toList();

      when(
        () => api.message.getMessagesById(channelId, channelType, messageIds),
      ).thenAnswer((_) async => GetMessagesByIdResponse()..messages = messages);

      final res = await client.getMessagesById(
        channelId,
        channelType,
        messageIds,
      );
      expect(res, isNotNull);
      expect(res.messages.length, messageIds.length);

      verify(
        () => api.message.getMessagesById(channelId, channelType, messageIds),
      ).called(1);
      verifyNoMoreInteractions(api.message);
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

      when(() => api.message.translateMessage(messageId, language)).thenAnswer(
        (_) async => TranslateMessageResponse()..message = translatedMessage,
      );

      final res = await client.translateMessage(messageId, language);

      expect(res, isNotNull);
      expect(res.message.i18n, translatedMessage.i18n);

      verify(() => api.message.translateMessage(messageId, language)).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.partialUpdateMessage`', () async {
      const messageId = 'test-message-id';
      final message = Message(id: messageId);

      const set = {'text': 'Update Message text'};
      const unset = ['pinExpires'];

      final updateMessageResponse = UpdateMessageResponse()
        ..message = message.copyWith(text: set['text'], pinExpires: null);

      when(() => api.message.partialUpdateMessage(
            message.id,
            set: set,
            unset: unset,
          )).thenAnswer((_) async => updateMessageResponse);

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

      verify(() => api.message.partialUpdateMessage(
            message.id,
            set: set,
            unset: unset,
          )).called(1);
      verifyNoMoreInteractions(api.message);
    });

    group('`.pinMessage`', () {
      test('should work fine without passing timeoutOrExpirationDate',
          () async {
        const messageId = 'test-message-id';
        final message = Message(id: messageId);

        when(() => api.message.partialUpdateMessage(
              messageId,
              set: any(named: 'set'),
              unset: any(named: 'unset'),
            )).thenAnswer((_) async => UpdateMessageResponse()
          ..message = message.copyWith(
            pinned: true,
            pinExpires: null,
            state: MessageState.sent,
          ));

        final res = await client.pinMessage(messageId);

        expect(res, isNotNull);
        expect(res.message.pinned, isTrue);
        expect(res.message.pinExpires, isNull);

        verify(() => api.message.partialUpdateMessage(
              messageId,
              set: any(named: 'set'),
              unset: any(named: 'unset'),
            )).called(1);
        verifyNoMoreInteractions(api.message);
      });

      test(
        'should work fine if passed timeoutOrExpirationDate as num(seconds)',
        () async {
          const messageId = 'test-message-id';
          final message = Message(id: messageId);
          const timeoutOrExpirationDate = 300; // 300 seconds

          when(() => api.message.partialUpdateMessage(
                message.id,
                set: any(named: 'set'),
                unset: any(named: 'unset'),
              )).thenAnswer((_) async => UpdateMessageResponse()
            ..message = message.copyWith(
              pinned: true,
              pinExpires: DateTime.now().add(
                const Duration(seconds: timeoutOrExpirationDate),
              ),
              state: MessageState.sent,
            ));

          final res = await client.pinMessage(
            messageId,
            timeoutOrExpirationDate: timeoutOrExpirationDate,
          );

          expect(res, isNotNull);
          expect(res.message.pinned, isTrue);
          expect(res.message.pinExpires, isNotNull);

          verify(() => api.message.partialUpdateMessage(
                messageId,
                set: any(named: 'set'),
                unset: any(named: 'unset'),
              )).called(1);
          verifyNoMoreInteractions(api.message);
        },
      );

      test(
        'should work fine if passed timeoutOrExpirationDate as DateTime',
        () async {
          const messageId = 'test-message-id';
          final message = Message(id: messageId);
          final timeoutOrExpirationDate =
              DateTime.now().add(const Duration(days: 3)); // 3 days

          when(() => api.message.partialUpdateMessage(
                messageId,
                set: any(named: 'set'),
                unset: any(named: 'unset'),
              )).thenAnswer((_) async => UpdateMessageResponse()
            ..message = message.copyWith(
              pinned: true,
              pinExpires: timeoutOrExpirationDate,
              state: MessageState.sent,
            ));

          final res = await client.pinMessage(
            messageId,
            timeoutOrExpirationDate: timeoutOrExpirationDate,
          );

          expect(res, isNotNull);
          expect(res.message.pinned, isTrue);
          expect(res.message.pinExpires, isNotNull);
          expect(res.message.pinExpires, timeoutOrExpirationDate.toUtc());

          verify(() => api.message.partialUpdateMessage(
                messageId,
                set: any(named: 'set'),
                unset: any(named: 'unset'),
              )).called(1);
          verifyNoMoreInteractions(api.message);
        },
      );

      test(
        'should throw if invalid timeoutOrExpirationDate is passed',
        () async {
          const messageId = 'test-message-id';
          const timeoutOrExpirationDate = 'invalid-value';

          try {
            await client.pinMessage(
              messageId,
              timeoutOrExpirationDate: timeoutOrExpirationDate,
            );
          } catch (e) {
            expect(e, isA<ArgumentError>());
          }
        },
      );
    });

    test('`.unpinMessage`', () async {
      const messageId = 'test-message-id';
      final message = Message(id: messageId, pinned: true);

      when(() => api.message.partialUpdateMessage(
            messageId,
            set: {'pinned': false},
          )).thenAnswer((_) async => UpdateMessageResponse()
        ..message = message.copyWith(
          pinned: false,
          state: MessageState.sent,
        ));

      final res = await client.unpinMessage(messageId);

      expect(res, isNotNull);
      expect(res.message.pinned, isFalse);

      verify(() => api.message.partialUpdateMessage(
            messageId,
            set: {'pinned': false},
          )).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.enrichUrl`', () async {
      const url =
          'https://www.techyourchance.com/finite-state-machine-with-unit-tests-real-world-example';

      when(() => api.general.enrichUrl(url)).thenAnswer(
        (_) async => OGAttachmentResponse()
          ..type = 'image'
          ..ogScrapeUrl = url
          ..authorName = 'TechYourChance'
          ..title = 'Finite State Machine with Unit Tests: Real World Example',
      );

      final res = await client.enrichUrl(url);

      expect(res, isNotNull);
      expect(res.type, 'image');
      expect(res.ogScrapeUrl, url);
      expect(res.authorName, 'TechYourChance');
      expect(
        res.title,
        'Finite State Machine with Unit Tests: Real World Example',
      );

      verify(() => api.general.enrichUrl(url)).called(1);
      verifyNoMoreInteractions(api.general);
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
    late final api = FakeChatApi();

    final user = User(id: 'test-user-id');
    final token = Token.development(user.id).rawValue;

    late StreamChatClient client;

    setUp(() async {
      final ws = FakeWebSocket();
      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
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
          throwsA(const TypeMatcher<StreamChatError>()),
        );
      },
    );

    test(
      '''openPersistenceConnection throws an error if chatPersistenceClient is not set''',
      () async {
        await expectLater(
          client.openPersistenceConnection(user),
          throwsA(const TypeMatcher<StreamChatError>()),
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
          throwsA(const TypeMatcher<StreamChatError>()),
        );
      },
    );
  });
}
