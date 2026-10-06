import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.MarkReadRequest()));

  test('StreamChatClient.markChannelRead sends the message id and returns the response', () async {
    const request = api.MarkReadRequest(messageId: 'message-id');

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.markRead(type: 'messaging', id: 'general', markReadRequest: request),
    ).thenAnswer((_) async => const Result.success(api.MarkReadResponse(duration: '0.01ms')));
    final client = _client(defaultApi);

    final res = await client.markChannelRead('general', 'messaging', messageId: 'message-id');

    expect(res.getOrNull(), const MarkReadResponse(duration: '0.01ms'));
    verify(() => defaultApi.markRead(type: 'messaging', id: 'general', markReadRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.markChannelRead sends no message id when none is given and returns the response', () async {
    const request = api.MarkReadRequest();

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.markRead(type: 'messaging', id: 'general', markReadRequest: request),
    ).thenAnswer((_) async => const Result.success(api.MarkReadResponse(duration: '0.01ms')));
    final client = _client(defaultApi);

    final res = await client.markChannelRead('general', 'messaging');

    expect(res.getOrNull(), const MarkReadResponse(duration: '0.01ms'));
    verify(() => defaultApi.markRead(type: 'messaging', id: 'general', markReadRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.markChannelRead returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.markRead(
        type: any(named: 'type'),
        id: any(named: 'id'),
        markReadRequest: any(named: 'markReadRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.markChannelRead('general', 'messaging');

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.markThreadRead sends the thread and returns the response', () async {
    const request = api.MarkReadRequest(threadId: 'thread-id');

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.markRead(type: 'messaging', id: 'general', markReadRequest: request),
    ).thenAnswer((_) async => const Result.success(api.MarkReadResponse(duration: '0.01ms')));
    final client = _client(defaultApi);

    final res = await client.markThreadRead('general', 'messaging', 'thread-id');

    expect(res.getOrNull(), const MarkReadResponse(duration: '0.01ms'));
    verify(() => defaultApi.markRead(type: 'messaging', id: 'general', markReadRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.markThreadRead returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.markRead(
        type: any(named: 'type'),
        id: any(named: 'id'),
        markReadRequest: any(named: 'markReadRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.markThreadRead('general', 'messaging', 'thread-id');

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
