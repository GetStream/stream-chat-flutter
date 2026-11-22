import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'channel_update_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.UpdateChannelRequest()));

  test(
    'StreamChatClient.rejectChannelInvite sends the rejection and the message and returns the updated channel',
    () async {
      final defaultApi = _defaultApi();
      final client = _client(defaultApi);

      final res = await client.rejectChannelInvite('general', 'messaging', message: systemMessage);

      expectUpdateChannelResponse(res.getOrNull());
      verify(
        () => defaultApi.updateChannel(
          type: 'messaging',
          id: 'general',
          updateChannelRequest: const api.UpdateChannelRequest(rejectInvite: true, message: systemMessageRequest),
        ),
      ).called(1);
      verifyNoMoreInteractions(defaultApi);
    },
  );

  test('StreamChatClient.rejectChannelInvite returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateChannel(
        type: any(named: 'type'),
        id: any(named: 'id'),
        updateChannelRequest: any(named: 'updateChannelRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.rejectChannelInvite('general', 'messaging');

    expect(res.exceptionOrNull(), error);
  });
}

MockDefaultApi _defaultApi() {
  final defaultApi = MockDefaultApi();
  when(
    () => defaultApi.updateChannel(
      type: any(named: 'type'),
      id: any(named: 'id'),
      updateChannelRequest: any(named: 'updateChannelRequest'),
    ),
  ).thenAnswer((_) async => Result.success(generatedUpdateChannelResponse()));
  return defaultApi;
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
