import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'channel_update_fixtures.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.TruncateChannelRequest()));

  test(
    'StreamChatClient.truncateChannel sends the message, skip push and date and returns the truncated channel',
    () async {
      final defaultApi = MockDefaultApi();
      when(
        () => defaultApi.truncateChannel(
          type: any(named: 'type'),
          id: any(named: 'id'),
          truncateChannelRequest: any(named: 'truncateChannelRequest'),
        ),
      ).thenAnswer(
        (_) async => Result.success(
          api.TruncateChannelResponse(
            duration: '0.01ms',
            channel: generatedUpdateChannelResponse().channel,
            message: generatedLeafMessage('system-id'),
          ),
        ),
      );
      final client = _client(defaultApi);

      final res = await client.truncateChannel(
        'general',
        'messaging',
        message: systemMessage,
        skipPush: true,
        truncatedAt: DateTime.utc(2026, 3),
      );

      final response = res.getOrNull()!;
      expect(response.duration, '0.01ms');
      expect(response.channel!.cid, 'messaging:general');
      expect(response.message, expectedLeafMessage('system-id'));
      verify(
        () => defaultApi.truncateChannel(
          type: 'messaging',
          id: 'general',
          truncateChannelRequest: api.TruncateChannelRequest(
            message: systemMessageRequest,
            skipPush: true,
            truncatedAt: DateTime.utc(2026, 3),
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(defaultApi);
    },
  );

  test('StreamChatClient.truncateChannel sends nothing but the channel when given nothing else', () async {
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.truncateChannel(
        type: any(named: 'type'),
        id: any(named: 'id'),
        truncateChannelRequest: any(named: 'truncateChannelRequest'),
      ),
    ).thenAnswer((_) async => const Result.success(api.TruncateChannelResponse(duration: '0.01ms')));
    final client = _client(defaultApi);

    final res = await client.truncateChannel('general', 'messaging');

    expect(res, const Result.success(TruncateChannelResponse(duration: '0.01ms')));
    verify(
      () => defaultApi.truncateChannel(
        type: 'messaging',
        id: 'general',
        truncateChannelRequest: const api.TruncateChannelRequest(),
      ),
    ).called(1);
  });

  test('StreamChatClient.truncateChannel returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.truncateChannel(
        type: any(named: 'type'),
        id: any(named: 'id'),
        truncateChannelRequest: any(named: 'truncateChannelRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.truncateChannel('general', 'messaging');

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
