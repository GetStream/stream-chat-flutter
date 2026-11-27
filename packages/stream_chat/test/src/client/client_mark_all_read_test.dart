import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.MarkChannelsReadRequest()));

  test('StreamChatClient.markAllRead sends an empty request and returns the response', () async {
    const request = api.MarkChannelsReadRequest();

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.markChannelsRead(markChannelsReadRequest: request),
    ).thenAnswer((_) async => const Result.success(api.MarkReadResponse(duration: '0.01ms')));
    final client = _client(defaultApi);

    final res = await client.markAllRead();

    expect(res.getOrNull(), const MarkReadResponse(duration: '0.01ms'));
    verify(() => defaultApi.markChannelsRead(markChannelsReadRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.markAllRead returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.markChannelsRead(markChannelsReadRequest: any(named: 'markChannelsReadRequest')),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.markAllRead();

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
