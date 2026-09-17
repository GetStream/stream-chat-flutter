import 'package:stream_chat/src/ws/connect_request.dart';
import 'package:stream_chat/src/ws/connection_manager.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_core/stream_core.dart' show SystemEnvironmentManager;
import 'package:test/test.dart';

import '../utils.dart';
import 'fake_chat_server.dart';

void main() {
  test('ConnectionManager names no connection until one is established', () async {
    final manager = _manager();
    addTearDown(manager.dispose);

    expect(manager.connectionId, isNull);
    expect(manager.connectionState.value, isA<Initialized>());
  });

  test('ConnectionManager reports a connection the socket could not open', () async {
    final manager = _manager();
    addTearDown(manager.dispose);

    await expectLater(
      manager.connect(_user()),
      throwsA(isA<StreamChatException>()),
    );

    expect(manager.connectionState.value, isA<Disconnected>());
  });

  test('ConnectionManager presents another token after the server refuses an expired one', () async {
    var loads = 0;
    final server = FakeChatServer()..refusal = connectionErrorFrame();
    final manager = _manager(
      server: server,
      tokenProvider: TokenProvider.dynamic((userId) async {
        loads++;
        return testUserToken(userId);
      }),
    );
    addTearDown(manager.dispose);

    await expectLater(manager.connect(_user()), throwsA(isA<StreamApiException>()));
    expect(loads, 1);

    // The refused token is dropped, so the attempt after it asks the provider for another rather
    // than presenting the one the server just turned down.
    server.refusal = null;
    await manager.connect(_user());

    expect(loads, 2);
  });

  test('ConnectionManager stays closed when the provider has no other token to give', () async {
    final server = FakeChatServer()..refusal = connectionErrorFrame();
    final manager = _manager(server: server);
    addTearDown(manager.dispose);

    await expectLater(manager.connect(_user()), throwsA(isA<StreamApiException>()));

    // A static provider answers with the token that was refused, so another attempt could only be
    // turned down again. The session ends rather than asking forever.
    server.refusal = null;
    await expectLater(manager.connect(_user()), throwsA(isA<StreamAuthenticationException>()));
  });

  test('ConnectionManager refuses a second connection while one is being opened', () async {
    final manager = _manager();
    addTearDown(manager.dispose);

    final user = _user();
    final first = manager.connect(user);

    expect(() => manager.connect(user), throwsStateError);
    await expectLater(first, throwsA(isA<StreamChatException>()));
  });
}

OwnUser _user() => OwnUser(id: 'test-user-id');

ConnectionManager _manager({FakeChatServer? server, TokenProvider? tokenProvider}) {
  return ConnectionManager(
    request: ConnectRequest.forApi(
      'https://chat.stream-io-api.com',
      apiKey: 'test-api-key',
      environment: SystemEnvironmentManager(
        environment: const SystemEnvironment(sdkName: 'stream-chat', sdkIdentifier: 'dart', sdkVersion: '0.0.0'),
      ),
    ),
    tokenManager: TokenManager(
      userId: 'test-user-id',
      tokenProvider: tokenProvider ?? TokenProvider.static(testUserToken('test-user-id')),
    ),
    wsProvider:
        server?.connect ??
        // Never opens: a test about what the connection reports does not need one to succeed.
        (_) => throw const StreamNetworkException(message: 'no socket in this test'),
  );
}
