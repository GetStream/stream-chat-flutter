import 'dart:async';
import 'dart:convert';

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

  test('ConnectionManager connects with another token after the server refuses an expired one', () async {
    var loads = 0;
    final server = FakeChatServer()..refusal = connectionErrorFrame();
    final manager = _manager(
      server: server,
      tokenProvider: TokenProvider.dynamic((userId) async {
        loads += 1;
        // The server accepts the token the provider gives after the refused one.
        if (loads == 2) server.refusal = null;
        return testUserToken(userId);
      }),
    );
    addTearDown(manager.dispose);

    await manager.connect(_user());

    expect(manager.connectionId, isNotNull);
    expect(loads, 2);
  });

  test('ConnectionManager reads as connecting while an expired token is replaced', () async {
    var loads = 0;
    final server = FakeChatServer()..refusal = connectionErrorFrame();
    final manager = _manager(
      server: server,
      tokenProvider: TokenProvider.dynamic((userId) async {
        loads += 1;
        if (loads == 2) server.refusal = null;
        return testUserToken(userId);
      }),
    );
    addTearDown(manager.dispose);
    final statuses = <ConnectionStatus>[];
    manager.statusStream.listen(statuses.add);

    await manager.connect(_user());

    expect(statuses, [ConnectionStatus.disconnected, ConnectionStatus.connecting, ConnectionStatus.connected]);
  });

  test('ConnectionManager reports an expired token refused again after asking for another', () async {
    var loads = 0;
    final server = FakeChatServer()..refusal = connectionErrorFrame();
    final manager = _manager(
      server: server,
      tokenProvider: TokenProvider.dynamic((userId) async {
        loads += 1;
        return testUserToken(userId);
      }),
    );
    addTearDown(manager.dispose);

    await expectLater(
      manager.connect(_user()),
      throwsA(isA<StreamApiException>().having((it) => it.isTokenExpired, 'isTokenExpired', isTrue)),
    );

    expect(loads, 2);
    expect(server.sockets, hasLength(2));
  });

  test('ConnectionManager does not ask for another token when the server refuses one for another reason', () async {
    var loads = 0;
    final refusal = connectionErrorFrame(code: StreamErrorCode.tokenSignatureInvalid);
    final server = FakeChatServer()..refusal = refusal;
    final manager = _manager(
      server: server,
      tokenProvider: TokenProvider.dynamic((userId) async {
        loads += 1;
        return testUserToken(userId);
      }),
    );
    addTearDown(manager.dispose);

    await expectLater(manager.connect(_user()), throwsA(isA<StreamApiException>()));

    expect(loads, 1);
    expect(server.sockets, hasLength(1));
  });

  test('ConnectionManager does not ask for another token when loading one fails as expired', () async {
    var loads = 0;
    final server = FakeChatServer();
    final manager = _manager(
      server: server,
      tokenProvider: TokenProvider.dynamic((userId) async {
        loads += 1;
        throw apiException(code: StreamErrorCode.tokenExpired, statusCode: 401);
      }),
    );
    addTearDown(manager.dispose);

    await expectLater(manager.connect(_user()), throwsA(isA<StreamApiException>()));

    expect(loads, 1);
    expect(server.sockets, isEmpty);
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

  test('ConnectionManager authenticates a first connection with the token and the full user details', () async {
    final server = FakeChatServer(user: _user());
    final manager = _manager(server: server);
    addTearDown(manager.dispose);
    final user = OwnUser(id: 'test-user-id', name: 'Test User', language: 'nl', custom: const {'color': 'red'});

    await manager.connect(user, includeUserDetails: true);

    expect(server.authFrames.single, {
      'token': _token.rawValue,
      'products': ['chat'],
      'user_details': {
        'id': 'test-user-id',
        'name': 'Test User',
        'language': 'nl',
        'custom': {'color': 'red'},
      },
    });
  });

  test('ConnectionManager names the user by id alone when their details are not to be sent', () async {
    final server = FakeChatServer(user: _user());
    final manager = _manager(server: server);
    addTearDown(manager.dispose);

    await manager.connect(OwnUser(id: 'test-user-id', name: 'Test User'));

    expect(server.authFrames.single['user_details'], {'id': 'test-user-id'});
  });

  test('ConnectionManager names the user by id alone when it reopens a connection it established', () async {
    final server = FakeChatServer(user: _user());
    final manager = _manager(server: server);
    addTearDown(manager.dispose);

    await manager.connect(OwnUser(id: 'test-user-id', name: 'Test User'), includeUserDetails: true);
    final reconnected = manager.statusStream.skip(1).firstWhere((it) => it == ConnectionStatus.connected);
    server.drop(closeCode: 1006);
    await reconnected;

    expect(server.authFrames.map((it) => it['user_details']), [
      {'id': 'test-user-id', 'name': 'Test User', 'custom': <String, Object?>{}},
      {'id': 'test-user-id'},
    ]);
  });

  test('ConnectionManager sends the full user details again when it retries a refused first connection', () async {
    var loads = 0;
    final server = FakeChatServer(user: _user())..refusal = connectionErrorFrame();
    final manager = _manager(
      server: server,
      tokenProvider: TokenProvider.dynamic((userId) async {
        loads += 1;
        if (loads == 2) server.refusal = null;
        return testUserToken(userId);
      }),
    );
    addTearDown(manager.dispose);

    await manager.connect(OwnUser(id: 'test-user-id', name: 'Test User'), includeUserDetails: true);

    final details = {'id': 'test-user-id', 'name': 'Test User', 'custom': <String, Object?>{}};
    expect(server.authFrames.map((it) => it['user_details']), [details, details]);
  });

  test('ConnectionManager authenticates a retry with the token that replaced the refused one', () async {
    var loads = 0;
    final server = FakeChatServer(user: _user())..refusal = connectionErrorFrame();
    final manager = _manager(
      server: server,
      tokenProvider: TokenProvider.dynamic((userId) async {
        loads += 1;
        if (loads == 2) server.refusal = null;
        return _numberedToken(loads);
      }),
    );
    addTearDown(manager.dispose);

    await manager.connect(_user());

    expect(server.authFrames.map((it) => it['token']), [_numberedToken(1).rawValue, _numberedToken(2).rawValue]);
  });

  test('ConnectionManager authenticates with the token the socket was opened for', () async {
    var loads = 0;
    final server = FakeChatServer(user: _user());
    final manager = _manager(
      server: server,
      tokenProvider: TokenProvider.dynamic((_) async => _numberedToken(loads += 1)),
    );
    addTearDown(manager.dispose);

    await manager.connect(_user());

    expect(server.authFrames.single['token'], _numberedToken(1).rawValue);
  });

  test('ConnectionManager authenticates an anonymous connection with no token and the anonymous id', () async {
    final server = FakeChatServer(user: OwnUser(id: '!anon'));
    final manager = _manager(
      server: server,
      userId: '!anon',
      tokenProvider: TokenProvider.static(UserToken.anonymous()),
    );
    addTearDown(manager.dispose);

    await manager.connect(OwnUser(id: '!anon'), includeUserDetails: true);

    expect(server.authFrames.single, {
      'token': '',
      'products': ['chat'],
      'user_details': {'id': 'anon'},
    });
  });

  test('ConnectionManager opens no socket before the token is loaded', () async {
    final token = Completer<UserToken>();
    final server = FakeChatServer(user: _user());
    final manager = _manager(server: server, tokenProvider: TokenProvider.dynamic((_) => token.future));
    addTearDown(manager.dispose);

    final connecting = manager.connect(_user());
    await pumpEventQueue();

    expect(server.sockets, isEmpty);

    token.complete(_token);
    await connecting;

    expect(server.authFrames.single['token'], _token.rawValue);
  });

  test('ConnectionManager keeps the token out of the address it opens', () async {
    final server = FakeChatServer(user: _user());
    final manager = _manager(server: server);
    addTearDown(manager.dispose);

    await manager.connect(_user());

    final options = server.options.single;
    expect(options.url, isNot(contains(_token.rawValue)));
    expect(options.queryParameters!.values, isNot(contains(_token.rawValue)));
  });

  test('ConnectionManager reports a socket that could not open without the token', () async {
    final manager = _manager(server: FakeChatServer()..handshakeFails = true);
    addTearDown(manager.dispose);

    await expectLater(manager.connect(_user()), throwsA(_exceptionWithout(_token.rawValue)));
  });

  test('ConnectionManager reports a refused connection without the token', () async {
    final refusal = connectionErrorFrame(code: StreamErrorCode.tokenSignatureInvalid);
    final manager = _manager(server: FakeChatServer()..refusal = refusal);
    addTearDown(manager.dispose);

    await expectLater(manager.connect(_user()), throwsA(_exceptionWithout(_token.rawValue)));
  });
}

OwnUser _user() => OwnUser(id: 'test-user-id');

final _token = testUserToken('test-user-id');

// A token for `test-user-id` that differs from every other [number].
UserToken _numberedToken(int number) {
  const header = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9';
  final payload = base64.encode(utf8.encode(json.encode({'user_id': 'test-user-id', 'number': number})));
  return UserToken('$header.$payload.devtoken');
}

// A [StreamException] whose description and cause both leave out [secret].
Matcher _exceptionWithout(String secret) => isA<StreamException>()
    .having((it) => '$it', 'description', isNot(contains(secret)))
    .having((it) => it.message, 'message', isNot(contains(secret)))
    .having((it) => '${it.cause}', 'cause', isNot(contains(secret)));

ConnectionManager _manager({FakeChatServer? server, TokenProvider? tokenProvider, String userId = 'test-user-id'}) {
  return ConnectionManager(
    request: ConnectRequest.forApi(
      'https://chat.stream-io-api.com',
      apiKey: 'test-api-key',
      environment: SystemEnvironmentManager(
        environment: const SystemEnvironment(sdkName: 'stream-chat', sdkIdentifier: 'dart', sdkVersion: '0.0.0'),
      ),
    ),
    tokenManager: TokenManager(
      userId: userId,
      tokenProvider: tokenProvider ?? TokenProvider.static(_token),
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
