import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'channel_update_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.UpdateChannelRequest()));

  test(
    'StreamChatClient.addChannelMembers sends the added users and the message and returns the updated channel',
    () async {
      final defaultApi = _defaultApi();
      final client = _client(defaultApi);

      final res = await client.addChannelMembers('general', 'messaging', ['mo', 'jo'], message: systemMessage);

      expectUpdateChannelResponse(res.getOrNull());
      verify(
        () => defaultApi.updateChannel(
          type: 'messaging',
          id: 'general',
          updateChannelRequest: const api.UpdateChannelRequest(
            addMembers: [
              api.ChannelMemberRequest(userId: 'mo'),
              api.ChannelMemberRequest(userId: 'jo'),
            ],
            message: systemMessageRequest,
            hideHistory: false,
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(defaultApi);
    },
  );

  test('StreamChatClient.addChannelMembers sends hiding the history when asked to', () async {
    final defaultApi = _defaultApi();
    final client = _client(defaultApi);

    await client.addChannelMembers('general', 'messaging', ['mo'], hideHistory: true);

    verify(
      () => defaultApi.updateChannel(
        type: 'messaging',
        id: 'general',
        updateChannelRequest: const api.UpdateChannelRequest(
          addMembers: [api.ChannelMemberRequest(userId: 'mo')],
          hideHistory: true,
        ),
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test(
    'StreamChatClient.addChannelMembers sends the date to hide the history before instead of hiding all of it',
    () async {
      final defaultApi = _defaultApi();
      final client = _client(defaultApi);

      await client.addChannelMembers(
        'general',
        'messaging',
        ['mo'],
        hideHistory: true,
        hideHistoryBefore: DateTime.utc(2026, 3),
      );

      verify(
        () => defaultApi.updateChannel(
          type: 'messaging',
          id: 'general',
          updateChannelRequest: api.UpdateChannelRequest(
            addMembers: const [api.ChannelMemberRequest(userId: 'mo')],
            hideHistoryBefore: DateTime.utc(2026, 3),
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(defaultApi);
    },
  );

  test('StreamChatClient.addChannelMembers returns the failure without throwing', () async {
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

    final res = await client.addChannelMembers('general', 'messaging', ['mo']);

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
