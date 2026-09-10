// ignore_for_file: avoid_redundant_argument_values, lines_longer_than_80_chars, deprecated_member_use_from_same_package

import 'dart:async';

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

        when(() => api.guest.getGuestUser(any(that: isSameUserAs(user)))).thenAnswer(
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

        when(
          () => api.guest.getGuestUser(any(that: isSameUserAs(user))),
        ).thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

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

      when(() => api.guest.getGuestUser(any(that: isSameUserAs(user)))).thenAnswer(
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

      when(() => api.guest.getGuestUser(any(that: isSameUserAs(user)))).thenAnswer(
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
      client = StreamChatClient(apiKey, chatApi: api, ws: ws)..chatPersistenceClient = persistence;
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
        Future<String> tokenProvider(String userId) async {
          expect(userId, user.id);
          return Token.development(userId).rawValue;
        }

        final event = Event(
          type: EventType.healthCheck,
          connectionId: 'test-connection-id',
          me: OwnUser.fromUser(user),
        );
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
          me: OwnUser.fromUser(user),
        );
        when(persistence.getConnectionInfo).thenAnswer((_) async => event);

        when(() => api.guest.getGuestUser(any(that: isSameUserAs(user)))).thenAnswer(
          (_) async => ConnectGuestUserResponse()
            ..user = user
            ..accessToken = token,
        );

        final res = await client.connectGuestUser(user);
        expect(res, isNotNull);
        expect(res, isSameUserAs(user));

        verify(persistence.getConnectionInfo).called(1);
        verifyNoMoreInteractions(persistence);
        verify(() => api.guest.getGuestUser(any(that: isSameUserAs(user)))).called(1);
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
      registerFallbackValue(const Filter.empty());
    });

    setUp(() async {
      when(() => persistence.updateLastSyncAt(any())).thenAnswer((_) => Future.value());
      when(persistence.getLastSyncAt).thenAnswer((_) async => null);
      final ws = FakeWebSocket();
      client = StreamChatClient(apiKey, chatApi: api, ws: ws)..chatPersistenceClient = persistence;
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
          when(() => api.general.sync(cids, lastSyncAt)).thenAnswer(
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

          when(() => persistence.updateConnectionInfo(any())).thenAnswer((_) => Future.value());
          when(() => persistence.updateLastSyncAt(any())).thenAnswer((_) => Future.value());

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

          when(() => api.general.sync(cids, lastSyncAt)).thenAnswer(
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
                  message: Message(id: 'test-message-id', text: 'Hey!'),
                ),
              ],
          );

          when(() => persistence.updateConnectionInfo(any())).thenAnswer((_) => Future.value());
          when(() => persistence.updateLastSyncAt(any())).thenAnswer((_) => Future.value());

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
          ).thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

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

          verify(() => persistence.getChannelThreads(any())).called(persistentChannelStates.length);
          verify(() => persistence.updateChannelState(any())).called(persistentChannelStates.length);
          verify(() => persistence.updateChannelThreads(any(), any())).called(persistentChannelStates.length);
        },
      );

      test(
        'queryChannelsOnline with inline filter persists via saveChannelQueries',
        () async {
          final filter = Filter.in_('members', const ['test-user-id']);

          final channelStates = List.generate(
            3,
            (i) => ChannelState(channel: ChannelModel(cid: 'test-type-$i:test-id-$i')),
          );

          when(
            () => api.channel.queryChannels(
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

          when(
            () => api.channel.queryChannels(
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
              ..predefinedFilter = const PredefinedFilter(
                name: filterName,
                filter: Filter.empty(),
                sort: [SortOption<ChannelState>.desc('last_message_at')],
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
              resolvedFilter: const Filter.empty(),
              resolvedSort: const [SortOption<ChannelState>.desc('last_message_at')],
              filterValues: filterValues,
              sortValues: sortValues,
              clearQueryCache: true,
            ),
          ).called(1);
        },
      );

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
          ).thenAnswer((_) async => QueryChannelsResponse()..channels = const []);

          when(
            () => api.channel.queryChannels(
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
      // Clear any accumulated interactions from a previous test so that
      // verifyNoMoreInteractions on api.general stays accurate.
      clearInteractions(api.general);

      final ws = FakeWebSocket();
      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
      // Stub getAppSettings so the background fetch after connectUser succeeds.
      when(() => api.general.getAppSettings()).thenAnswer(
        (_) async => GetAppSettingsResponse()..app = const AppSettings(name: 'test'),
      );
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

        when(() => api.general.sync(cids, lastSyncAt)).thenAnswer(
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

    test('`.updateUser`', () async {
      final user = User(
        id: 'test-user-id',
        extraData: const {'name': 'test-user'},
      );

      when(() => api.user.updateUsers([user])).thenAnswer((_) async => UpdateUsersResponse()..users = {user.id: user});

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

      when(() => api.user.partialUpdateUsers([partialUpdateRequest])).thenAnswer(
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

      when(
        () => api.moderation.banUser(userId, options: any(named: 'options')),
      ).thenAnswer((_) async => EmptyResponse());

      final res = await client.banUser(userId);

      expect(res, isNotNull);

      verify(
        () => api.moderation.banUser(userId, options: any(named: 'options')),
      ).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.unbanUser`', () async {
      const userId = 'test-user-id';

      when(
        () => api.moderation.unbanUser(userId, options: any(named: 'options')),
      ).thenAnswer((_) async => EmptyResponse());

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

      when(() => api.user.unblockUser(userId)).thenAnswer((_) async => EmptyResponse());

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
          expect(client.state.currentUser?.blockedUserIds, contains(otherBlockedId));
          expect(client.state.currentUser?.blockedUserIds, isNot(contains(nonBlockedUserId)));
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

      when(() => api.moderation.banUser(userId, options: {'shadow': true})).thenAnswer((_) async => EmptyResponse());

      final res = await client.shadowBan(userId);

      expect(res, isNotNull);

      verify(
        () => api.moderation.banUser(userId, options: {'shadow': true}),
      ).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.removeShadowBan`', () async {
      const userId = 'test-user-id';

      when(() => api.moderation.unbanUser(userId, options: {'shadow': true})).thenAnswer((_) async => EmptyResponse());

      final res = await client.removeShadowBan(userId);

      expect(res, isNotNull);

      verify(
        () => api.moderation.unbanUser(userId, options: {'shadow': true}),
      ).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.muteUser`', () async {
      const userId = 'test-user-id';

      when(() => api.moderation.muteUser(userId)).thenAnswer((_) async => EmptyResponse());

      final res = await client.muteUser(userId);

      expect(res, isNotNull);

      verify(() => api.moderation.muteUser(userId)).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.unmuteUser`', () async {
      const userId = 'test-user-id';

      when(() => api.moderation.unmuteUser(userId)).thenAnswer((_) async => EmptyResponse());

      final res = await client.unmuteUser(userId);

      expect(res, isNotNull);

      verify(() => api.moderation.unmuteUser(userId)).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.flagMessage`', () async {
      const messageId = 'test-message-id';

      when(() => api.moderation.flagMessage(messageId)).thenAnswer((_) async => EmptyResponse());

      final res = await client.flagMessage(messageId);

      expect(res, isNotNull);

      verify(() => api.moderation.flagMessage(messageId)).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.unflagMessage`', () async {
      const messageId = 'test-message-id';

      when(() => api.moderation.unflagMessage(messageId)).thenAnswer((_) async => EmptyResponse());

      final res = await client.unflagMessage(messageId);

      expect(res, isNotNull);

      verify(() => api.moderation.unflagMessage(messageId)).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.flagUser`', () async {
      const userId = 'test-message-id';

      when(() => api.moderation.flagUser(userId)).thenAnswer((_) async => EmptyResponse());

      final res = await client.flagUser(userId);

      expect(res, isNotNull);

      verify(() => api.moderation.flagUser(userId)).called(1);
      verifyNoMoreInteractions(api.moderation);
    });

    test('`.unflagUser`', () async {
      const userId = 'test-message-id';

      when(() => api.moderation.unflagUser(userId)).thenAnswer((_) async => EmptyResponse());

      final res = await client.unflagUser(userId);

      expect(res, isNotNull);

      verify(() => api.moderation.unflagUser(userId)).called(1);
      verifyNoMoreInteractions(api.moderation);
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

      when(() => api.user.getActiveLiveLocations()).thenAnswer(
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

      verify(() => api.user.getActiveLiveLocations()).called(1);
      verifyNoMoreInteractions(api.user);
    });

    test('`.updateLiveLocation`', () async {
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

      when(
        () => api.user.updateLiveLocation(
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
        () => api.user.updateLiveLocation(
          messageId: messageId,
          createdByDeviceId: createdByDeviceId,
          location: location,
          endAt: endAt,
        ),
      ).called(1);
      verifyNoMoreInteractions(api.user);
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
        () => api.user.updateLiveLocation(
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
        () => api.user.updateLiveLocation(
          messageId: messageId,
          createdByDeviceId: createdByDeviceId,
          endAt: any(named: 'endAt'),
        ),
      ).called(1);
      verifyNoMoreInteractions(api.user);
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

    test('`.markAllRead`', () async {
      when(() => api.channel.markAllRead()).thenAnswer((_) async => EmptyResponse());

      final res = await client.markAllRead();
      expect(res, isNotNull);

      verify(() => api.channel.markAllRead()).called(1);
      verifyNoMoreInteractions(api.channel);
    });

    test('`.markChannelsDelivered`', () async {
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

      when(() => api.channel.markChannelsDelivered(deliveries)).thenAnswer((_) async => EmptyResponse());

      final res = await client.markChannelsDelivered(deliveries);
      expect(res, isNotNull);

      verify(() => api.channel.markChannelsDelivered(deliveries)).called(1);
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

      verify(
        () => api.channel.sendEvent(
          channelId,
          channelType,
          any(that: isSameEventAs(event)),
        ),
      ).called(1);
      verifyNoMoreInteractions(api.channel);
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

      when(() => api.message.sendReaction(messageId, reaction)).thenAnswer(
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

      verify(() => api.message.sendReaction(messageId, reaction)).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.deleteReaction`', () async {
      const messageId = 'test-message-id';
      const reactionType = 'like';

      when(() => api.message.deleteReaction(messageId, reactionType)).thenAnswer((_) async => EmptyResponse());

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

      when(
        () => api.message.sendMessage(channelId, channelType, any(that: isSameMessageAs(message))),
      ).thenAnswer((_) async => SendMessageResponse()..message = message);

      final res = await client.sendMessage(message, channelId, channelType);
      expect(res, isNotNull);
      expect(res.message, isSameMessageAs(message));

      verify(
        () => api.message.sendMessage(
          channelId,
          channelType,
          any(that: isSameMessageAs(message)),
        ),
      ).called(1);
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

      verify(
        () => api.message.createDraft(
          channelId,
          channelType,
          any(that: isSameDraftMessageAs(message)),
        ),
      ).called(1);

      verifyNoMoreInteractions(api.message);
    });

    test('`.deleteDraft`', () async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';

      when(() => api.message.deleteDraft(channelId, channelType)).thenAnswer((_) async => EmptyResponse());

      final res = await client.deleteDraft(channelId, channelType);
      expect(res, isNotNull);

      verify(() => api.message.deleteDraft(channelId, channelType));
      verifyNoMoreInteractions(api.message);
    });

    test('`.getDraft`', () async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';

      final message = DraftMessage(id: 'test-message-id', text: 'Hello!');

      when(() => api.message.getDraft(channelId, channelType)).thenAnswer(
        (_) async => GetDraftResponse()
          ..draft = Draft(
            channelCid: '$channelType:$channelId',
            createdAt: DateTime.now(),
            message: message,
          ),
      );

      final res = await client.getDraft(channelId, channelType);

      expect(res, isNotNull);
      expect(res.draft.message, isSameDraftMessageAs(message));

      verify(() => api.message.getDraft(channelId, channelType));
      verifyNoMoreInteractions(api.message);
    });

    test('`.queryDrafts`', () async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';

      final filter = Filter.equal('channel_cid', '$channelType:$channelId');
      final sort = [const SortOption<Draft>.desc('created_at')];
      const pagination = PaginationParams(limit: 20);

      final drafts = [
        Draft(
          channelCid: '$channelType:$channelId',
          createdAt: DateTime.now(),
          message: DraftMessage(id: 'test-message-id', text: 'Hello!'),
        ),
      ];

      when(
        () => api.message.queryDrafts(
          filter: filter,
          sort: sort,
          pagination: pagination,
        ),
      ).thenAnswer((_) async => QueryDraftsResponse()..drafts = drafts);

      final res = await client.queryDrafts(
        filter: filter,
        sort: sort,
        pagination: pagination,
      );

      expect(res, isNotNull);
      expect(res.drafts.length, drafts.length);

      verify(
        () => api.message.queryDrafts(
          filter: filter,
          sort: sort,
          pagination: pagination,
        ),
      ).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.getReplies`', () async {
      const parentId = 'test-parent-id';

      final messages = List.generate(
        3,
        (index) => Message(id: 'test-message-id-$index'),
      );

      when(() => api.message.getReplies(parentId)).thenAnswer((_) async => QueryRepliesResponse()..messages = messages);

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

      when(
        () => api.message.getReactions(messageId),
      ).thenAnswer((_) async => QueryReactionsResponse()..reactions = reactions);

      final res = await client.getReactions(messageId);
      expect(res, isNotNull);
      expect(res.reactions.length, reactions.length);
      expect(res.reactions.every((it) => it.messageId == messageId), isTrue);

      verify(() => api.message.getReactions(messageId)).called(1);
      verifyNoMoreInteractions(api.message);
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
        () => api.message.queryReactions(messageId),
      ).thenAnswer(
        (_) async => QueryReactionsResponse()
          ..reactions = reactions
          ..next = null,
      );

      final res = await client.queryReactions(messageId);
      expect(res, isNotNull);
      expect(res.reactions.length, reactions.length);
      expect(res.reactions.every((it) => it.messageId == messageId), isTrue);

      verify(() => api.message.queryReactions(messageId)).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.updateMessage`', () async {
      final message = Message(id: 'test-message-id', text: 'Hello!');

      when(
        () => api.message.updateMessage(any(that: isSameMessageAs(message))),
      ).thenAnswer((_) async => UpdateMessageResponse()..message = message);

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

      when(() => api.message.deleteMessage(messageId, hard: false)).thenAnswer((_) async => EmptyResponse());

      final res = await client.deleteMessage(messageId);
      expect(res, isNotNull);

      verify(() => api.message.deleteMessage(messageId, hard: false)).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.deleteMessageForMe`', () async {
      const messageId = 'test-message-id';

      when(() => api.message.deleteMessage(messageId, deleteForMe: true)).thenAnswer((_) async => EmptyResponse());

      final res = await client.deleteMessageForMe(messageId);
      expect(res, isNotNull);

      verify(() => api.message.deleteMessage(messageId, deleteForMe: true)).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.getMessage`', () async {
      const messageId = 'test-message-id';
      final message = Message(id: messageId);

      when(() => api.message.getMessage(messageId)).thenAnswer((_) async => GetMessageResponse()..message = message);

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

      when(
        () => api.message.partialUpdateMessage(
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
        () => api.message.partialUpdateMessage(
          message.id,
          set: set,
          unset: unset,
        ),
      ).called(1);
      verifyNoMoreInteractions(api.message);
    });

    group('`.pinMessage`', () {
      test('should work fine without passing timeoutOrExpirationDate', () async {
        const messageId = 'test-message-id';
        final message = Message(id: messageId);

        when(
          () => api.message.partialUpdateMessage(
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
          () => api.message.partialUpdateMessage(
            messageId,
            set: any(named: 'set'),
            unset: any(named: 'unset'),
          ),
        ).called(1);
        verifyNoMoreInteractions(api.message);
      });

      test(
        'should work fine if passed timeoutOrExpirationDate as num(seconds)',
        () async {
          const messageId = 'test-message-id';
          final message = Message(id: messageId);
          const timeoutOrExpirationDate = 300; // 300 seconds

          when(
            () => api.message.partialUpdateMessage(
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
            () => api.message.partialUpdateMessage(
              messageId,
              set: any(named: 'set'),
              unset: any(named: 'unset'),
            ),
          ).called(1);
          verifyNoMoreInteractions(api.message);
        },
      );

      test(
        'should work fine if passed timeoutOrExpirationDate as DateTime',
        () async {
          const messageId = 'test-message-id';
          final message = Message(id: messageId);
          final timeoutOrExpirationDate = DateTime.now().add(const Duration(days: 3)); // 3 days

          when(
            () => api.message.partialUpdateMessage(
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
            () => api.message.partialUpdateMessage(
              messageId,
              set: any(named: 'set'),
              unset: any(named: 'unset'),
            ),
          ).called(1);
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

      when(
        () => api.message.partialUpdateMessage(
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
        () => api.message.partialUpdateMessage(
          messageId,
          set: {'pinned': false},
        ),
      ).called(1);
      verifyNoMoreInteractions(api.message);
    });

    test('`.enrichUrl`', () async {
      const url = 'https://www.techyourchance.com/finite-state-machine-with-unit-tests-real-world-example';

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
      verify(() => api.general.getAppSettings()).called(1);
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

    group('Sync Method Tests', () {
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
          when(() => api.general.sync(cids, lastSyncAt)).thenAnswer(
            (_) async => SyncResponse()..events = [],
          );

          await client.sync();

          verify(() => api.general.sync(cids, lastSyncAt)).called(1);

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
        verifyNever(() => api.general.sync(any(), any()));
      });

      test('should flush persistence client on 400 error', () async {
        final cids = ['channel1'];
        final lastSyncAt = DateTime.now().subtract(const Duration(hours: 1));
        final fakeClient = FakePersistenceClient(
          channelCids: cids,
          lastSyncAt: lastSyncAt,
        );

        client.chatPersistenceClient = fakeClient;
        when(() => api.general.sync(cids, lastSyncAt)).thenThrow(
          StreamChatNetworkError.raw(
            code: 4,
            statusCode: 400,
            message: 'Too many events',
          ),
        );

        await client.sync();

        expect(await fakeClient.getChannelCids(), isEmpty); // Should be flushed

        verify(() => api.general.sync(cids, lastSyncAt)).called(1);
      });
    });
  });
}
