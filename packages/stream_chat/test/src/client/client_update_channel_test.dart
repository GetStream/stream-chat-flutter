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
      const {'name': 'General', 'image': 'https://example.com/general.png', 'topic': 'travel'},
      message: systemMessage,
    );

    expectUpdateChannelResponse(res.getOrNull());
    verify(
      () => defaultApi.updateChannel(
        type: 'messaging',
        id: 'general',
        updateChannelRequest: const api.UpdateChannelRequest(
          data: api.ChannelInputRequest(
            custom: {'name': 'General', 'image': 'https://example.com/general.png', 'topic': 'travel'},
          ),
          message: systemMessageRequest,
        ),
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.updateChannel sends members given as user ids as members', () async {
    final request = await _sentData({
      'members': ['mo', 'jo'],
    });

    expect(request.members, const [api.ChannelMemberRequest(userId: 'mo'), api.ChannelMemberRequest(userId: 'jo')]);
    expect(request.custom, isEmpty);
  });

  test('StreamChatClient.updateChannel sends a member map with its role and the rest as its custom data', () async {
    final request = await _sentData({
      'members': [
        {'user_id': 'mo', 'channel_role': 'channel_moderator', 'nickname': 'Mo'},
        {'user_id': 'jo'},
      ],
    });

    expect(request.members, const [
      api.ChannelMemberRequest(userId: 'mo', channelRole: 'channel_moderator', custom: {'nickname': 'Mo'}),
      api.ChannelMemberRequest(userId: 'jo'),
    ]);
  });

  test('StreamChatClient.updateChannel sends the invites as invited members', () async {
    final request = await _sentData({
      'invites': ['mo'],
    });

    expect(request.invites, const [api.ChannelMemberRequest(userId: 'mo')]);
    expect(request.custom, isEmpty);
  });

  test('StreamChatClient.updateChannel sends the team, frozen, disabled and auto translation as fields', () async {
    final request = await _sentData({
      'team': 'blue',
      'frozen': true,
      'disabled': false,
      'auto_translation_enabled': true,
      'auto_translation_language': 'fr',
    });

    expect(
      request,
      const api.ChannelInputRequest(
        team: 'blue',
        frozen: true,
        disabled: false,
        autoTranslationEnabled: true,
        autoTranslationLanguage: 'fr',
        custom: {},
      ),
    );
  });

  test('StreamChatClient.updateChannel sends the config overrides as a field', () async {
    final request = await _sentData({
      'config_overrides': {'replies': false, 'max_message_length': 100},
    });

    expect(request.configOverrides, const api.ConfigOverridesRequest(replies: false, maxMessageLength: 100));
    expect(request.custom, isEmpty);
  });

  test('StreamChatClient.updateChannel sends the filter tags as custom data', () async {
    final request = await _sentData({
      'filter_tags': ['support'],
    });

    expect(request.custom, {
      'filter_tags': ['support'],
    });
  });

  test('StreamChatClient.updateChannel sends an empty map as empty custom data', () async {
    final request = await _sentData(const {});

    expect(request, const api.ChannelInputRequest(custom: {}));
  });

  test('StreamChatClient.updateChannel returns a failure without a request for a value of the wrong type', () async {
    final defaultApi = _defaultApi();
    final client = _client(defaultApi);

    final res = await client.updateChannel('general', 'messaging', const {'frozen': 'yes'});

    expect(res.exceptionOrNull(), isA<StreamClientException>());
    verifyZeroInteractions(defaultApi);
  });

  test(
    'StreamChatClient.updateChannel returns a failure without a request for a member that is not an id or a map',
    () async {
      final defaultApi = _defaultApi();
      final client = _client(defaultApi);

      final res = await client.updateChannel('general', 'messaging', const {
        'members': [42],
      });

      expect(res.exceptionOrNull(), isA<StreamClientException>());
      verifyZeroInteractions(defaultApi);
    },
  );

  test(
    'StreamChatClient.updateChannel returns a failure without a request for a member map without a user id',
    () async {
      final defaultApi = _defaultApi();
      final client = _client(defaultApi);

      final res = await client.updateChannel('general', 'messaging', const {
        'members': [
          {'channel_role': 'channel_moderator'},
        ],
      });

      expect(res.exceptionOrNull(), isA<StreamClientException>());
      verifyZeroInteractions(defaultApi);
    },
  );

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

    final res = await client.updateChannel('general', 'messaging', const {});

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

    final res = await client.updateChannel('general', 'messaging', const {});

    expect(res.exceptionOrNull(), error);
  });
}

// The channel data the update sends for [data].
Future<api.ChannelInputRequest> _sentData(Map<String, Object?> data) async {
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
