import 'package:dio/dio.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

// Every other client test injects a `chatApi`, so nothing exercises the
// constructor's default REST stack. This pins it: a client built without one
// has to reach the network through a real `StreamChatApi` / `StreamHttpClient`
// carrying the api key and the connected user's credentials.
void main() {
  setUpAll(() => registerFallbackValue(RequestOptions()));

  test('builds a REST stack carrying the api key and user credentials', () async {
    const apiKey = 'test-api-key';
    final adapter = _MockHttpClientAdapter();

    when(() => adapter.fetch(any(), any(), any())).thenAnswer(
      (_) async => ResponseBody.fromString(
        '{"app":{}}',
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    );

    final client = StreamChatClient(apiKey, httpClientAdapter: adapter);
    addTearDown(client.dispose);

    final user = User(id: 'test-user-id');
    final token = Token.development(user.id);

    // Connecting without a socket still loads the app settings, which is the
    // request captured below.
    await client.connectUser(user, token.rawValue, connectWebSocket: false);
    await pumpEventQueue();

    final captured = verify(() => adapter.fetch(captureAny(), any(), any())).captured;
    final options = captured.first as RequestOptions;

    expect(options.queryParameters['api_key'], apiKey);
    expect(options.queryParameters['user_id'], user.id);
    expect(options.headers['Authorization'], token.rawValue);
    expect(options.headers['stream-auth-type'], token.authType.name);
  });
}

class _MockHttpClientAdapter extends Mock implements HttpClientAdapter {}
