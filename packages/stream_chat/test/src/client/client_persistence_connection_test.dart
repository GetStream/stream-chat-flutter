import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

// Runs [body] as a [chatClientTest] whose client is backed by a fresh
// [MockPersistenceClient] and whose WebSocket transport fails to connect,
// mirroring the monolith group's setUp: the connect attempt fails with a
// retriable error, so the client falls back to the persisted connection info.
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

// Runs [body] as a [chatClientTest] that never opens the socket, mirroring
// the monolith group's setUp/tearDown: persistence starts disabled and the
// persistence client is detached (and asserted disabled) after the body.
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

void main() {
  group('Fake web-socket connection function with failure and persistence', () {
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
  });

  group('PersistenceConnectionTests', () {
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
    });
  });
}
