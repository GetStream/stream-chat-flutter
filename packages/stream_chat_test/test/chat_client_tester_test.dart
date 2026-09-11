import 'dart:convert';

import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

void main() {
  group('connection', () {
    chatClientTest(
      'connects with the default lifecycle',
      body: (tester) async {
        expect(tester.connectionStatus, ConnectionStatus.connected);
        expect(tester.currentUser?.id, tester.user.id);

        // The connect URI carries the credentials chat authenticates with.
        final uri = tester.connectUris.single;
        expect(uri.queryParameters['api_key'], 'test-api-key');
        expect(uri.queryParameters['authorization'], isNotEmpty);

        final payload = jsonDecode(uri.queryParameters['json']!) as Map<String, dynamic>;
        expect(payload['user_id'], tester.user.id);
        expect(payload['user_token'], uri.queryParameters['authorization']);
      },
    );

    chatClientTest(
      'echoes the configured user back as the connected user',
      user: User(id: 'darth_vader', name: 'Darth Vader', role: 'admin'),
      body: (tester) async {
        expect(tester.currentUser?.id, 'darth_vader');
        expect(tester.currentUser?.name, 'Darth Vader');
        expect(tester.currentUser?.role, 'admin');
      },
    );

    chatClientTest(
      'connects through a token provider',
      tokenProvider: (userId) async => createTestToken(userId).rawValue,
      body: (tester) async {
        expect(tester.connectionStatus, ConnectionStatus.connected);
        expect(tester.currentUser?.id, tester.user.id);
      },
    );

    chatClientTest(
      'fails to connect when authentication is rejected',
      connect: (tester) => tester.mockFailedAuth(errorCode: 43),
      body: (tester) async {
        final token = createTestToken(tester.user.id);

        await expectLater(
          tester.client.connectUser(tester.user, token.rawValue),
          throwsA(isA<StreamWebSocketError>()),
        );

        expect(tester.connectionStatus, ConnectionStatus.disconnected);
      },
    );

    chatClientTest(
      'rejects a connection attempt for a different user',
      connect: (tester) => tester.mockSuccessfulAuth(User(id: 'darth_vader')),
      body: (tester) async {
        final token = createTestToken(tester.user.id);

        await expectLater(
          tester.client.connectUser(tester.user, token.rawValue),
          throwsA(isA<StreamWebSocketError>()),
        );
      },
    );

    // NOTE(hack): pins a known harness limitation — the token argument passed
    // to `connectUser` never reaches the connect URI, because the injected
    // WebSocket reads its own pre-loaded TokenManager (the client's is
    // private), so the connection succeeds where a real backend would reject
    // it. This test starts failing the moment the harness gains token
    // fidelity — flip it to expect rejection then. See README "Token
    // handling".
    chatClientTest(
      'KNOWN LIMITATION: accepts a connectUser token minted for another user',
      connect: (tester) => tester.mockSuccessfulAuth(),
      body: (tester) async {
        final wrongToken = createTestToken('darth_vader');

        final ownUser = await tester.client.connectUser(tester.user, wrongToken.rawValue);

        expect(ownUser.id, tester.user.id);
        expect(tester.connectionStatus, ConnectionStatus.connected);
      },
    );

    chatClientTest(
      'fails to connect when the transport errors',
      connect: (tester) => tester.mockConnectionError(),
      body: (tester) async {
        final token = createTestToken(tester.user.id);

        await expectLater(
          tester.client.connectUser(tester.user, token.rawValue),
          throwsA(isA<StreamWebSocketError>()),
        );
      },
    );

    chatClientTest(
      'does not open a socket when connect is overridden to skip it',
      connect: (_) {},
      body: (tester) async {
        expect(tester.connectUris, isEmpty);
        expect(tester.connectionStatus, ConnectionStatus.disconnected);
      },
    );

    chatClientTest(
      'throws when emitting an event without a connection',
      connect: (_) {},
      body: (tester) async {
        await expectLater(
          tester.emitEvent(createDefaultEvent()),
          throwsStateError,
        );
      },
    );
  });

  group('api mocking', () {
    chatClientTest(
      'stubs and verifies API calls with exact arguments',
      body: (tester) async {
        final message = createDefaultMessage(id: 'message-id');
        tester.mockApi(
          (api) => api.message.getMessage('message-id'),
          result: createDefaultGetMessageResponse(message: message),
        );

        final response = await tester.client.getMessage('message-id');

        expect(response.message.id, 'message-id');
        tester
          ..verifyApi((api) => api.message.getMessage('message-id'))
          ..verifyNeverCalled((api) => api.message.getMessage('other-id'));
      },
    );

    chatClientTest(
      'captures API call arguments',
      body: (tester) async {
        tester.mockApi(
          (api) => api.message.getMessage(any()),
          result: createDefaultGetMessageResponse(),
        );

        await tester.client.getMessage('captured-id');

        final captured = tester.captureApi(
          (api) => api.message.getMessage(captureAny()),
        );
        expect(captured.single, 'captured-id');
      },
    );

    chatClientTest(
      'propagates stubbed API failures',
      body: (tester) async {
        tester.mockApiFailure((api) => api.message.getMessage('missing'));

        await expectLater(
          tester.client.getMessage('missing'),
          throwsA(isA<StreamChatNetworkError>()),
        );
      },
    );
  });

  group('events', () {
    chatClientTest(
      'delivers emitted events through the real frame decoder',
      body: (tester) async {
        final eventReceived = expectLater(
          tester.events,
          emits(isA<Event>().having((event) => event.type, 'type', EventType.messageNew)),
        );

        await tester.emitEvent(
          createDefaultEvent(type: EventType.messageNew, cid: 'messaging:test-channel'),
        );

        await eventReceived;
      },
    );
  });
}
