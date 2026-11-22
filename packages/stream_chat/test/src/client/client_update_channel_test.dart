import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'channel_update_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.UpdateChannelRequest()));

  test('StreamChatClient.updateChannel sends the data and the message and returns the updated channel', () async {
    final defaultApi = _defaultApi();
    final client = _client(defaultApi);

    final res = await client.updateChannel(
      'general',
      'messaging',
      const UpdateChannelData(custom: {'name': 'General', 'topic': 'travel'}),
      message: systemMessage,
    );

    expectUpdateChannelResponse(res.getOrNull());
    verify(
      () => defaultApi.updateChannel(
        type: 'messaging',
        id: 'general',
        updateChannelRequest: const api.UpdateChannelRequest(
          data: api.ChannelInputRequest(custom: {'name': 'General', 'topic': 'travel'}),
          message: systemMessageRequest,
        ),
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.updateChannel sends every field of the data', () async {
    final request = await _sentData(
      const UpdateChannelData(
        members: [
          ChannelMemberData(userId: 'mo', channelRole: 'channel_moderator', custom: {'nickname': 'Mo'}),
          ChannelMemberData(userId: 'jo'),
        ],
        invites: [ChannelMemberData(userId: 'li')],
        team: 'blue',
        frozen: true,
        disabled: false,
        custom: {'name': 'General'},
      ),
    );

    expect(
      request,
      const api.ChannelInputRequest(
        members: [
          api.ChannelMemberRequest(userId: 'mo', channelRole: 'channel_moderator', custom: {'nickname': 'Mo'}),
          api.ChannelMemberRequest(userId: 'jo'),
        ],
        invites: [api.ChannelMemberRequest(userId: 'li')],
        team: 'blue',
        frozen: true,
        disabled: false,
        custom: {'name': 'General'},
      ),
    );
  });

  test('StreamChatClient.updateChannel returns a null channel when the response has none', () async {
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateChannel(
        type: any(named: 'type'),
        id: any(named: 'id'),
        updateChannelRequest: any(named: 'updateChannelRequest'),
      ),
    ).thenAnswer((_) async => const Result.success(api.UpdateChannelResponse(duration: '0.01ms', members: [])));
    final client = _client(defaultApi);

    final res = await client.updateChannel('general', 'messaging', const UpdateChannelData());

    expect(res, const Result.success(UpdateChannelResponse(duration: '0.01ms', members: [])));
  });

  test('StreamChatClient.updateChannel returns the failure without throwing', () async {
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

    final res = await client.updateChannel('general', 'messaging', const UpdateChannelData());

    expect(res.exceptionOrNull(), error);
  });
}

// The channel data the update sends for [data].
Future<api.ChannelInputRequest> _sentData(UpdateChannelData data) async {
  final defaultApi = _defaultApi();
  final client = _client(defaultApi);

  await client.updateChannel('general', 'messaging', data);

  final request =
      verify(
            () => defaultApi.updateChannel(
              type: 'messaging',
              id: 'general',
              updateChannelRequest: captureAny(named: 'updateChannelRequest'),
            ),
          ).captured.single
          as api.UpdateChannelRequest;
  return request.data!;
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
