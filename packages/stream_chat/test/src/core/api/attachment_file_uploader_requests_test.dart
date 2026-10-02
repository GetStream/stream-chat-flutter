import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../fakes.dart';
import '../../utils.dart';
import '../../ws/fake_chat_server.dart';

void main() {
  setUpAll(() => registerFallbackValue(RequestOptions()));

  test('StreamChatClient.sendImage posts the image to the channel it is given', () async {
    final adapter = _adapterAnswering('{"duration":"1ms","file":"image-url"}');
    final client = await _connectedClient(adapter);

    final result = await client.sendImage(_file(), 'general', 'messaging');

    expect(result.getOrNull()?.fileUrl, 'image-url');
    final request = _lastRequest(adapter);
    expect(request.method, 'POST');
    expect(request.path, '/api/v2/chat/channels/messaging/general/image');
    expect((request.data as FormData).files.single.key, 'file');
  });

  test('StreamChatClient.removeFile deletes the file at the url it is given', () async {
    final adapter = _adapterAnswering('{"duration":"1ms"}');
    final client = await _connectedClient(adapter);

    final result = await client.removeFile('file-url');

    expect(result.isSuccess, isTrue);
    final request = _lastRequest(adapter);
    expect(request.method, 'DELETE');
    expect(request.path, '/api/v2/uploads/file');
    expect(request.queryParameters, containsPair('url', 'file-url'));
  });

  test('StreamChatClient.sendFile answers a canceled upload with a cancellation', () async {
    final adapter = _adapterAnswering('{"duration":"1ms","file":"file-url"}');
    final client = await _connectedClient(adapter);
    final cancelToken = CancelToken()..cancel();

    final result = await client.sendFile(
      _file(),
      'general',
      'messaging',
      cancelToken: cancelToken,
    );

    expect(
      result.exceptionOrNull(),
      isA<StreamNetworkException>().having((it) => it.isCancelled, 'isCancelled', isTrue),
    );
  });
}

Future<StreamChatClient> _connectedClient(HttpClientAdapter adapter) async {
  final user = User(id: 'test-user-id');
  final ws = FakeChatServer()..user = OwnUser.fromUser(user);
  final client = StreamChatClient(
    'test-api-key',
    chatApi: FakeChatApi(),
    defaultApi: FakeDefaultApi(),
    wsProvider: ws.connect,
    httpClientAdapter: adapter,
  );
  addTearDown(client.dispose);

  await client.connectUser(user, testUserToken(user.id).rawValue);
  return client;
}

MockHttpClientAdapter _adapterAnswering(String body) {
  final adapter = MockHttpClientAdapter();
  when(() => adapter.fetch(any(), any(), any())).thenAnswer(
    (_) async => ResponseBody.fromString(body, 201, headers: _jsonHeaders),
  );
  return adapter;
}

RequestOptions _lastRequest(MockHttpClientAdapter adapter) {
  final calls = verify(() => adapter.fetch(captureAny(), any(), any())).captured;
  return calls.last as RequestOptions;
}

AttachmentFile _file() {
  final bytes = Uint8List.fromList([1, 2, 3]);
  return AttachmentFile(size: bytes.length, bytes: bytes, name: 'photo.jpg');
}

const _jsonHeaders = {
  Headers.contentTypeHeader: [Headers.jsonContentType],
};

class MockHttpClientAdapter extends Mock implements HttpClientAdapter {}
