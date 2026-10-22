import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'channel_update_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.UpdateChannelRequest()));

  test(
    'StreamChatClient.inviteChannelMembers sends the invited users and the message and returns the updated channel',
    () async {
      final defaultApi = _defaultApi();
      final client = _client(defaultApi);

      final res = await client.inviteChannelMembers(
        'general',
        'messaging',
        const [ChannelMemberData(userId: 'mo', channelRole: 'channel_moderator'), ChannelMemberData(userId: 'jo')],
        message: systemMessage,
      );

      expectUpdateChannelResponse(res.getOrNull());
      verify(
        () => defaultApi.updateChannel(
          type: 'messaging',
          id: 'general',
          updateChannelRequest: const api.UpdateChannelRequest(
            invites: [
              api.ChannelMemberRequest(userId: 'mo', channelRole: 'channel_moderator'),
              api.ChannelMemberRequest(userId: 'jo'),
            ],
            message: systemMessageRequest,
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(defaultApi);
    },
  );

  test('StreamChatClient.inviteChannelMembers returns the failure without throwing', () async {
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

    final res = await client.inviteChannelMembers('general', 'messaging', const [ChannelMemberData(userId: 'mo')]);

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
