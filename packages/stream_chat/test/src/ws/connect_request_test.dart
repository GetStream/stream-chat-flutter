import 'package:stream_chat/src/ws/connect_request.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_core/stream_core.dart' show SystemEnvironmentManager;
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  test('ConnectRequest opens against the host the API is served from', () {
    expect(ConnectRequest.endpointFor('https://chat.stream-io-api.com'), 'wss://chat.stream-io-api.com/api/v2/connect');
  });

  test('ConnectRequest stays unencrypted for an unencrypted API', () {
    expect(ConnectRequest.endpointFor('http://localhost:3030'), 'ws://localhost:3030/api/v2/connect');
  });

  test('ConnectRequest keeps an address that already names the socket scheme', () {
    expect(ConnectRequest.endpointFor('wss://chat.stream-io-api.com'), 'wss://chat.stream-io-api.com/api/v2/connect');
    expect(ConnectRequest.endpointFor('ws://localhost:3030'), 'ws://localhost:3030/api/v2/connect');
  });

  test('ConnectRequest refuses an address that names no scheme', () {
    expect(() => ConnectRequest.endpointFor('chat.stream-io-api.com'), throwsFormatException);
    expect(() => ConnectRequest.endpointFor('ftp://chat.stream-io-api.com'), throwsFormatException);
  });

  test('ConnectRequest opens the connection with the app key and how it is authenticated', () {
    final options = _request().build(token: _token());

    expect(options.queryParameters, {
      'api_key': 'test-api-key',
      'stream-auth-type': 'jwt',
      'X-Stream-Client': _environment().userAgent,
    });
  });

  test('ConnectRequest keeps the token out of the address it opens', () {
    final options = _request().build(token: _token());

    expect(options.url, isNot(contains(_token().rawValue)));
    expect(options.queryParameters!.values, isNot(contains(_token().rawValue)));
  });

  test('ConnectRequest opens an anonymous connection as anonymous', () {
    final options = _request().build(token: UserToken.anonymous());

    expect(options.queryParameters, containsPair('stream-auth-type', 'anonymous'));
  });

  test('ConnectRequest authenticates with the token, for chat, naming the user by id', () {
    final request = _request().authenticate(user: _user(), token: _token());

    expect(request.toJson(), {
      'token': _token().rawValue,
      'products': ['chat'],
      'user_details': {'id': 'test-user-id'},
    });
  });

  test('ConnectRequest authenticates with the full user details when asked to', () {
    final user = OwnUser(
      id: 'test-user-id',
      name: 'Test User',
      image: 'https://example.com/avatar.png',
      language: 'nl',
      invisible: true,
      privacySettings: const PrivacySettings(typingIndicators: TypingIndicators(enabled: false)),
      custom: const {'color': 'red', 'score': 7},
    );

    final request = _request().authenticate(user: user, token: _token(), includeUserDetails: true);

    expect(request.toJson()['user_details'], {
      'id': 'test-user-id',
      'name': 'Test User',
      'image': 'https://example.com/avatar.png',
      'language': 'nl',
      'invisible': true,
      'privacy_settings': {
        'typing_indicators': {'enabled': false},
      },
      'custom': {'color': 'red', 'score': 7},
    });
  });

  test('ConnectRequest leaves out custom data named like one of the user details', () {
    final user = OwnUser(
      id: 'test-user-id',
      name: 'Test User',
      custom: const {'name': 'custom', 'privacy_settings': 'custom', 'color': 'red'},
    );

    final request = _request().authenticate(user: user, token: _token(), includeUserDetails: true);

    expect(request.toJson()['user_details'], {
      'id': 'test-user-id',
      'name': 'Test User',
      'custom': {'color': 'red'},
    });
  });

  test('ConnectRequest authenticates an anonymous connection with no token and the anonymous id', () {
    final request = _request().authenticate(
      user: OwnUser(id: '!anon'),
      token: UserToken.anonymous(),
    );

    expect(request.toJson(), {
      'token': '',
      'products': ['chat'],
      'user_details': {'id': 'anon'},
    });
  });

  test('ConnectRequest leaves the token out of how the authenticating message describes itself', () {
    final request = _request().authenticate(user: _user(), token: _token());

    expect('$request', isNot(contains(_token().rawValue)));
  });

  test('ConnectRequest describes the app as it describes itself now', () {
    final environment = _environment();
    final request = ConnectRequest.forApi(
      'https://chat.stream-io-api.com',
      apiKey: 'test-api-key',
      environment: environment,
    );

    final before = request.build(token: _token()).queryParameters!;
    expect(before, containsPair('X-Stream-Client', environment.userAgent));

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

    final after = request.build(token: _token()).queryParameters!;
    expect(after, containsPair('X-Stream-Client', environment.userAgent));
    expect(after['X-Stream-Client'], isNot(before['X-Stream-Client']));
  });

  test('ConnectRequest identifies the SDK to the API', () {
    final environment = _environment();
    final options = ConnectRequest.forApi(
      'https://x.com',
      apiKey: 'k',
      environment: environment,
    ).build(token: _token());

    expect(options.queryParameters, containsPair('X-Stream-Client', environment.userAgent));
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
