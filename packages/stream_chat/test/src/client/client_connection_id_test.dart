import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../utils.dart';
import '../ws/fake_chat_server.dart';

// Every request made over an open connection has to name it, or the API refuses anything that
// watches or reports presence. Nothing else in this package's tests reaches the real interceptor
// chain — they all inject a mocked `chatApi` — so the wiring between the client and its HTTP
// client is only covered here.
void main() {
  setUpAll(() => registerFallbackValue(RequestOptions()));

  late MockHttpClientAdapter adapter;
  late StreamChatClient client;
  late FakeChatServer ws;

  setUp(() {
    adapter = MockHttpClientAdapter();
    when(() => adapter.fetch(any(), any(), any())).thenAnswer(
      (_) async => ResponseBody.fromString('{"channels":[]}', 200, headers: _jsonHeaders),
    );

    ws = FakeChatServer();
    // Faked: the generated client shares this adapter, and its connect-time
    // request would land among the ones captured below.
    client = StreamChatClient(
      'test-api-key',
      defaultApi: FakeDefaultApi(),
      wsProvider: ws.connect,
      httpClientAdapter: adapter,
    );
  });

  tearDown(() => client.dispose());

  test('StreamChatClient names the open connection on the requests it makes', () async {
    final user = User(id: 'test-user-id');
    ws.user = OwnUser.fromUser(user);

    await client.connectUser(user, testUserToken(user.id).rawValue);
    await client.queryChannels(watch: true).first;

    expect(_lastRequest(adapter).queryParameters, containsPair('connection_id', 'fake-connection-id'));
  });

  test('StreamChatClient stops naming a connection once it closes', () async {
    final user = User(id: 'test-user-id');
    ws.user = OwnUser.fromUser(user);

    await client.connectUser(user, testUserToken(user.id).rawValue);
    client.closeConnection();

    // The id is read off the connection for every request, so a closed one names nothing — where
    // a stored id would go on claiming a connection the server has already let go of.
    await client.queryChannels(watch: false, waitForConnect: false).first;

    expect(_lastRequest(adapter).queryParameters, isNot(contains('connection_id')));
  });
}

RequestOptions _lastRequest(MockHttpClientAdapter adapter) {
  final calls = verify(() => adapter.fetch(captureAny(), any(), any())).captured;
  return calls.last as RequestOptions;
}

const _jsonHeaders = {
  Headers.contentTypeHeader: [Headers.jsonContentType],
};

class MockHttpClientAdapter extends Mock implements HttpClientAdapter {}
