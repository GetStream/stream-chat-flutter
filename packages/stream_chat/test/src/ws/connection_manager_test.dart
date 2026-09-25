import 'package:stream_chat/src/ws/connect_request.dart';
import 'package:stream_chat/src/ws/connection_manager.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_core/stream_core.dart' show Disconnected, Initialized, SystemEnvironmentManager;
import 'package:test/test.dart';

import '../utils.dart';
import 'fake_chat_server.dart';

void main() {
  final records = <StreamLogRecord>[];
  setUp(() {
    records.clear();
    StreamLogger.handler = _CapturingHandler(records.add);
    StreamLogger.priority = StreamLogPriority.verbose;
    addTearDown(StreamLogger.reset);
  });

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

  test('ConnectionManager waits on the connection being opened for the same user', () async {
    final manager = _manager();
    addTearDown(manager.dispose);

    final user = _user();
    final first = manager.connect(user);

    // The attempt in flight is the connection this caller asked for, so they are answered with it
    // rather than refused.
    final second = manager.connect(user);

    await expectLater(first, throwsA(isA<StreamChatException>()));
    await expectLater(second, throwsA(isA<StreamChatException>()));

    // One attempt, not two run alongside each other: the second caller waits on the work the first
    // one set off rather than repeating it, so the failure is reported once.
    expect(records.where((it) => it.message.contains('failed')), hasLength(1));
  });

  test('ConnectionManager answers a connect for the user it already has a connection for', () async {
    final manager = _manager(server: FakeChatServer(user: _user()));
    addTearDown(manager.dispose);

    final user = _user();
    final established = await manager.connect(user);

    // The connection being asked for is the one already open, so the caller is answered with the
    // frame that opened it rather than told they should have disconnected first.
    expect(await manager.connect(user), established);
  });

  test('ConnectionManager refuses a connect for another user while one is connected', () async {
    final manager = _manager(server: FakeChatServer(user: _user()));
    addTearDown(manager.dispose);

    await manager.connect(_user());

    // Opening one here would leave the connection in hand unreferenced.
    expect(() => manager.connect(OwnUser(id: 'someone-else')), throwsStateError);
  });

  test('ConnectionManager refuses a second connection while one is being opened for another user', () async {
    final manager = _manager();
    addTearDown(manager.dispose);

    final first = manager.connect(_user());

    // Opening one here would leave the attempt in flight unreferenced, and hand this caller a
    // connection signed in as somebody else.
    expect(() => manager.connect(OwnUser(id: 'someone-else')), throwsStateError);
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

class _CapturingHandler extends StreamLogHandler {
  const _CapturingHandler(this._onRecord);

  final void Function(StreamLogRecord) _onRecord;

  @override
  void handle(StreamLogRecord record) => _onRecord(record);
}
