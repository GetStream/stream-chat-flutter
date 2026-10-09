import 'dart:convert';

import 'package:stream_chat/src/ws/connect_request.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_core/stream_core.dart' show SystemEnvironmentManager, WebSocketOptions;
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  test('ConnectRequest opens against the host the API is served from', () {
    expect(ConnectRequest.endpointFor('https://chat.stream-io-api.com'), 'wss://chat.stream-io-api.com/connect');
  });

  test('ConnectRequest stays unencrypted for an unencrypted API', () {
    expect(ConnectRequest.endpointFor('http://localhost:3030'), 'ws://localhost:3030/connect');
  });

  test('ConnectRequest keeps an address that already names the socket scheme', () {
    expect(ConnectRequest.endpointFor('wss://chat.stream-io-api.com'), 'wss://chat.stream-io-api.com/connect');
    expect(ConnectRequest.endpointFor('ws://localhost:3030'), 'ws://localhost:3030/connect');
  });

  test('ConnectRequest refuses an address that names no scheme', () {
    expect(() => ConnectRequest.endpointFor('chat.stream-io-api.com'), throwsFormatException);
    expect(() => ConnectRequest.endpointFor('ftp://chat.stream-io-api.com'), throwsFormatException);
  });

  test('ConnectRequest presents the credentials the API reads a connection off', () {
    final options = _request().build(user: _user(), token: _token());

    // `GetAuthTokenFromRequest` takes the header first and this second; a socket handshake has no
    // way to set one on the web, so the query string is what a connection is authorized by.
    expect(options.queryParameters, containsPair('authorization', _token().rawValue));
    expect(options.queryParameters, containsPair('stream-auth-type', 'jwt'));
    expect(options.queryParameters, containsPair('api_key', 'test-api-key'));
  });

  test('ConnectRequest names the user without repeating the credential', () {
    final options = _request().build(user: _user(), token: _token());

    // Not `user_token`: the API never reads one out of the payload, and it would put the
    // credential in the URL twice.
    expect(_payload(options), {
      'user_id': 'test-user-id',
      'user_details': {'id': 'test-user-id'},
      'server_determines_connection_id': true,
    });
  });

  test('ConnectRequest sends the user details only when asked to', () {
    final options = _request().build(user: _user(), token: _token(), includeUserDetails: true);

    expect(
      _payload(options)['user_details'],
      isA<Map<String, Object?>>().having((it) => it['name'], 'name', 'Test User'),
    );
  });

  test('ConnectRequest describes the app as it describes itself now', () {
    final environment = _environment();
    final request = ConnectRequest.forApi(
      'https://chat.stream-io-api.com',
      apiKey: 'test-api-key',
      environment: environment,
    );

    final before = request.build(user: _user(), token: _token()).queryParameters!;
    expect(before, containsPair('X-Stream-Client', jsonEncode(environment.userAgent)));

    // An app can describe itself differently part-way through a session, and the connection it
    // opens after that should say so.
    environment.updateEnvironment(
      const SystemEnvironment(
        sdkName: 'stream-chat',
        sdkIdentifier: 'dart',
        sdkVersion: '0.0.0',
        appName: 'renamed',
        appVersion: '2.0.0',
      ),
    );

    final after = request.build(user: _user(), token: _token()).queryParameters!;
    expect(after, containsPair('X-Stream-Client', jsonEncode(environment.userAgent)));
    expect(after['X-Stream-Client'], isNot(before['X-Stream-Client']));
  });

  test('ConnectRequest identifies the SDK to the API', () {
    final environment = _environment();
    final options = ConnectRequest.forApi(
      'https://x.com',
      apiKey: 'k',
      environment: environment,
    ).build(user: _user(), token: _token());

    expect(options.queryParameters, containsPair('X-Stream-Client', jsonEncode(environment.userAgent)));
  });
}

OwnUser _user() => OwnUser(id: 'test-user-id', name: 'Test User');

UserToken _token() => testUserToken('test-user-id');

ConnectRequest _request() => ConnectRequest.forApi(
  'https://chat.stream-io-api.com',
  apiKey: 'test-api-key',
  environment: _environment(),
);

SystemEnvironmentManager _environment() => SystemEnvironmentManager(
  environment: const SystemEnvironment(sdkName: 'stream-chat', sdkIdentifier: 'dart', sdkVersion: '0.0.0'),
);

Map<String, Object?> _payload(WebSocketOptions options) {
  final json = options.queryParameters!['json']! as String;
  return jsonDecode(json) as Map<String, Object?>;
}
