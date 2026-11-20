import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.MarkUnreadRequest()));

  test('StreamChatClient.markChannelUnread sends the message id and returns a success', () async {
    const request = api.MarkUnreadRequest(messageId: 'message-id');

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.markUnread(type: 'messaging', id: 'general', markUnreadRequest: request),
    ).thenAnswer((_) async => const Result.success(api.DurationResponse(duration: '0.01ms')));
    final client = _client(defaultApi);

    final res = await client.markChannelUnread('general', 'messaging', 'message-id');

    expect(res, const Result<void>.success(null));
    verify(() => defaultApi.markUnread(type: 'messaging', id: 'general', markUnreadRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.markChannelUnread returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.markUnread(
        type: any(named: 'type'),
        id: any(named: 'id'),
        markUnreadRequest: any(named: 'markUnreadRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.markChannelUnread('general', 'messaging', 'message-id');

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.markChannelUnreadByTimestamp sends the timestamp and returns a success', () async {
    final timestamp = DateTime.utc(2024, 1, 2, 3, 4, 5);
    final request = api.MarkUnreadRequest(messageTimestamp: timestamp);

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.markUnread(type: 'messaging', id: 'general', markUnreadRequest: request),
    ).thenAnswer((_) async => const Result.success(api.DurationResponse(duration: '0.01ms')));
    final client = _client(defaultApi);

    final res = await client.markChannelUnreadByTimestamp('general', 'messaging', timestamp);

    expect(res, const Result<void>.success(null));
    verify(() => defaultApi.markUnread(type: 'messaging', id: 'general', markUnreadRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.markChannelUnreadByTimestamp returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.markUnread(
        type: any(named: 'type'),
        id: any(named: 'id'),
        markUnreadRequest: any(named: 'markUnreadRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.markChannelUnreadByTimestamp('general', 'messaging', DateTime.utc(2024));

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.markThreadUnread sends the thread and returns a success', () async {
    const request = api.MarkUnreadRequest(threadId: 'thread-id');

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.markUnread(type: 'messaging', id: 'general', markUnreadRequest: request),
    ).thenAnswer((_) async => const Result.success(api.DurationResponse(duration: '0.01ms')));
    final client = _client(defaultApi);

    final res = await client.markThreadUnread('general', 'messaging', 'thread-id');

    expect(res, const Result<void>.success(null));
    verify(() => defaultApi.markUnread(type: 'messaging', id: 'general', markUnreadRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.markThreadUnread returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.markUnread(
        type: any(named: 'type'),
        id: any(named: 'id'),
        markUnreadRequest: any(named: 'markUnreadRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.markThreadUnread('general', 'messaging', 'thread-id');

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
