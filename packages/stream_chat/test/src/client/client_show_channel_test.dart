import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  test('StreamChatClient.showChannel sends the channel and returns the response', () async {
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.showChannel(type: 'messaging', id: 'general'),
    ).thenAnswer((_) async => const Result.success(api.ShowChannelResponse(duration: '0.01ms')));
    final client = _client(defaultApi);

    final res = await client.showChannel('general', 'messaging');

    expect(res.getOrNull(), const ShowChannelResponse(duration: '0.01ms'));
    verify(() => defaultApi.showChannel(type: 'messaging', id: 'general')).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.showChannel returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.showChannel(
        type: any(named: 'type'),
        id: any(named: 'id'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.showChannel('general', 'messaging');

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
