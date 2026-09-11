import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

// NOTE(migration): the monolith's `.connectAnonymousUser` tests are not
// migrated — the anonymous token's user id cannot pass the fake server's
// connect-URI validation without the TokenManager seam. They stay in
// client_test.dart until the seam lands.
void main() {
  group('Fake web-socket connection functions', () {
    chatClientTest(
      '`.connectUser` should work fine',
      connect: (tester) => tester.mockSuccessfulAuth(tester.user.id),
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
      connect: (tester) => tester.mockSuccessfulAuth(tester.user.id),
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
        connect: (tester) => tester.mockSuccessfulAuth(tester.user.id),
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
        connect: (tester) => tester.mockSuccessfulAuth(tester.user.id),
        body: (tester) async {
          expect(tester.currentUser, isNull);

          // NOTE(migration): the monolith establishes the connection through
          // `.connectAnonymousUser`; the harness connects the regular user
          // instead (see the anonymous carve-out note at the top).
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
        connect: (tester) => tester.mockSuccessfulAuth(tester.user.id),
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

          // NOTE(migration): the monolith establishes the connection through
          // `.connectAnonymousUser`; the harness connects the regular user
          // instead (see the anonymous carve-out note at the top).
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
  });

  group('Connect user calls with `connectWebSocket`: false', () {
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
  });
}
