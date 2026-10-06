import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.HideChannelRequest()));

  test('StreamChatClient.hideChannel sends the history kept by default and returns the response', () async {
    const request = api.HideChannelRequest(clearHistory: false);

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.hideChannel(type: 'messaging', id: 'general', hideChannelRequest: request),
    ).thenAnswer((_) async => const Result.success(api.HideChannelResponse(duration: '0.01ms')));
    final client = _client(defaultApi);

    final res = await client.hideChannel('general', 'messaging');

    expect(res.getOrNull(), const HideChannelResponse(duration: '0.01ms'));
    verify(() => defaultApi.hideChannel(type: 'messaging', id: 'general', hideChannelRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.hideChannel sends the history cleared and returns the response', () async {
    const request = api.HideChannelRequest(clearHistory: true);

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.hideChannel(type: 'messaging', id: 'general', hideChannelRequest: request),
    ).thenAnswer((_) async => const Result.success(api.HideChannelResponse(duration: '0.01ms')));
    final client = _client(defaultApi);

    final res = await client.hideChannel('general', 'messaging', clearHistory: true);

    expect(res.getOrNull(), const HideChannelResponse(duration: '0.01ms'));
    verify(() => defaultApi.hideChannel(type: 'messaging', id: 'general', hideChannelRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.hideChannel returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.hideChannel(
        type: any(named: 'type'),
        id: any(named: 'id'),
        hideChannelRequest: any(named: 'hideChannelRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.hideChannel('general', 'messaging');

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
