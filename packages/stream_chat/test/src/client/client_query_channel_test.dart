import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.ChannelGetOrCreateRequest()));

  test(
    'StreamChatClient.queryChannel sends the channel, its data and the pages and returns the channel state',
    () async {
      final defaultApi = _defaultApi();
      final client = _client(defaultApi);

      final res = await client.queryChannel(
        'messaging',
        channelId: 'general',
        channelData: const {
          'name': 'General',
          'members': ['mo', 'jo'],
        },
        watch: true,
        presence: true,
        messagesPagination: PaginationParams(
          limit: 25,
          offset: 5,
          idAround: 'around-id',
          greaterThan: 'gt-id',
          greaterThanOrEqual: 'gte-id',
          lessThan: 'lt-id',
          lessThanOrEqual: 'lte-id',
          createdAtAfter: DateTime.utc(2026),
          createdAtAfterOrEqual: DateTime.utc(2026, 2),
          createdAtAround: DateTime.utc(2026, 3),
          createdAtBefore: DateTime.utc(2026, 4),
          createdAtBeforeOrEqual: DateTime.utc(2026, 5),
        ),
        membersPagination: const PaginationParams(limit: 30, offset: 60, lessThan: 'ignored'),
        watchersPagination: const PaginationParams(limit: 5),
      );

      expect(res.getOrNull()!.duration, '0.01ms');
      expect(res.getOrNull()!.channelState.channel!.cid, 'messaging:general');
      verify(
        () => defaultApi.getOrCreateChannel(
          type: 'messaging',
          id: 'general',
          channelGetOrCreateRequest: api.ChannelGetOrCreateRequest(
            data: const api.ChannelInput(
              members: [
                api.ChannelMemberRequest(userId: 'mo'),
                api.ChannelMemberRequest(userId: 'jo'),
              ],
              custom: {'name': 'General'},
            ),
            state: true,
            watch: true,
            presence: true,
            messages: api.MessagePaginationParams(
              limit: 25,
              idAround: 'around-id',
              idGt: 'gt-id',
              idGte: 'gte-id',
              idLt: 'lt-id',
              idLte: 'lte-id',
              createdAtAfter: DateTime.utc(2026),
              createdAtAfterOrEqual: DateTime.utc(2026, 2),
              createdAtAround: DateTime.utc(2026, 3),
              createdAtBefore: DateTime.utc(2026, 4),
              createdAtBeforeOrEqual: DateTime.utc(2026, 5),
            ),
            members: const api.PaginationParams(limit: 30, offset: 60),
            watchers: const api.PaginationParams(limit: 5),
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(defaultApi);
    },
  );

  test('StreamChatClient.queryChannel sends a channel without an id as the one its members identify', () async {
    final defaultApi = _defaultApi();
    final client = _client(defaultApi);

    await client.queryChannel(
      'messaging',
      channelData: const {
        'members': ['mo', 'jo'],
      },
    );

    verify(
      () => defaultApi.getOrCreateDistinctChannel(
        type: 'messaging',
        channelGetOrCreateRequest: const api.ChannelGetOrCreateRequest(
          data: api.ChannelInput(
            members: [
              api.ChannelMemberRequest(userId: 'mo'),
              api.ChannelMemberRequest(userId: 'jo'),
            ],
            custom: {},
          ),
          state: true,
          watch: false,
          presence: false,
        ),
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test(
    'StreamChatClient.queryChannel sends the invites, team, flags and settings of a new channel as fields',
    () async {
      final defaultApi = _defaultApi();
      final client = _client(defaultApi);

      await client.queryChannel(
        'messaging',
        channelId: 'general',
        channelData: const {
          'invites': ['mo'],
          'team': 'blue',
          'frozen': true,
          'disabled': false,
          'auto_translation_enabled': true,
          'auto_translation_language': 'fr',
          'filter_tags': ['support'],
          'config_overrides': {'replies': false},
        },
      );

      final request =
          verify(
                () => defaultApi.getOrCreateChannel(
                  type: 'messaging',
                  id: 'general',
                  channelGetOrCreateRequest: captureAny(named: 'channelGetOrCreateRequest'),
                ),
              ).captured.single
              as api.ChannelGetOrCreateRequest;
      expect(
        request.data,
        const api.ChannelInput(
          invites: [api.ChannelMemberRequest(userId: 'mo')],
          team: 'blue',
          frozen: true,
          disabled: false,
          autoTranslationEnabled: true,
          autoTranslationLanguage: 'fr',
          filterTags: ['support'],
          configOverrides: api.ChannelConfigOverrides(replies: false),
          custom: {},
        ),
      );
    },
  );

  test('StreamChatClient.queryChannel returns a failure without a request for a value of the wrong type', () async {
    final defaultApi = _defaultApi();
    final client = _client(defaultApi);

    final res = await client.queryChannel('messaging', channelId: 'general', channelData: const {'team': 7});

    expect(res.exceptionOrNull(), isA<StreamClientException>());
    verifyZeroInteractions(defaultApi);
  });

  test('StreamChatClient.queryChannel returns the channel state with every field it models', () async {
    final defaultApi = _defaultApi();
    final client = _client(defaultApi);

    final res = await client.queryChannel('messaging', channelId: 'general');

    final channelState = res.getOrNull()!.channelState;
    expect(channelState.channel!.cid, 'messaging:general');
    expect(channelState.messages, [expectedLeafMessage('message-1')]);
    expect(channelState.pinnedMessages, [expectedLeafMessage('pinned-1')]);
    expect(channelState.members, [fakeChannelMember()]);
    expect(channelState.membership, fakeChannelMember());
    expect(channelState.watcherCount, 3);
    expect(channelState.watchers, [fakeUser('watcher')]);
    expect(channelState.read, [
      Read(
        lastRead: DateTime.utc(2026, 1, 2),
        user: fakeUser('reader'),
        lastReadMessageId: 'message-1',
        unreadMessages: 4,
        lastDeliveredAt: DateTime.utc(2026, 1, 3),
        lastDeliveredMessageId: 'message-1',
      ),
    ]);
    expect(channelState.draft!.channelCid, 'messaging:general');
    expect(channelState.draft!.message.id, 'draft-id');
    expect(channelState.pendingMessages, [expectedLeafMessage('pending-1')]);
    expect(
      channelState.pushPreferences,
      ChannelPushPreference(
        chatLevel: ChatLevel.mentions,
        chatPreferences: const ChatPreferences(directMentions: ChatPreferenceLevel.all),
        disabledUntil: DateTime.utc(2026, 6),
      ),
    );
    expect(channelState.activeLiveLocations!.single.messageId, 'message-id');
    expect(channelState.activeLiveLocations!.single.latitude, 1.5);
  });

  test('StreamChatClient.queryChannel reads a channel state without pending messages as having none', () async {
    final defaultApi = _defaultApi(
      response: _channelStateResponse(
        pendingMessages: [const api.PendingMessageResponse()],
      ),
    );
    final client = _client(defaultApi);

    final res = await client.queryChannel('messaging', channelId: 'general');

    expect(res.getOrNull()!.channelState.pendingMessages, isNull);
  });

  test('StreamChatClient.queryChannel reads a zero last message date as none', () async {
    final defaultApi = _defaultApi(
      response: _channelStateResponse(
        channel: generatedChannel.copyWith(lastMessageAt: DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true)),
      ),
    );
    final client = _client(defaultApi);

    final res = await client.queryChannel('messaging', channelId: 'general');

    expect(res.getOrNull()!.channelState.channel!.lastMessageAt, isNull);
  });

  test('StreamChatClient.queryChannel returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.getOrCreateChannel(
        type: any(named: 'type'),
        id: any(named: 'id'),
        channelGetOrCreateRequest: any(named: 'channelGetOrCreateRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.queryChannel('messaging', channelId: 'general');

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.watchChannel sends watching the channel and returns the channel state', () async {
    final defaultApi = _defaultApi();
    final client = _client(defaultApi);

    final res = await client.watchChannel('messaging', channelId: 'general');

    expect(res.getOrNull()!.channelState.channel!.cid, 'messaging:general');
    verify(
      () => defaultApi.getOrCreateChannel(
        type: 'messaging',
        id: 'general',
        channelGetOrCreateRequest: const api.ChannelGetOrCreateRequest(state: true, watch: true, presence: false),
      ),
    ).called(1);
  });

  test('StreamChatClient.createChannel sends the channel without its state and returns the channel', () async {
    final defaultApi = _defaultApi();
    final client = _client(defaultApi);

    final res = await client.createChannel('messaging', channelId: 'general', channelData: const {'name': 'General'});

    expect(res.getOrNull()!.channelState.channel!.cid, 'messaging:general');
    verify(
      () => defaultApi.getOrCreateChannel(
        type: 'messaging',
        id: 'general',
        channelGetOrCreateRequest: const api.ChannelGetOrCreateRequest(
          data: api.ChannelInput(custom: {'name': 'General'}),
          state: false,
          watch: false,
          presence: false,
        ),
      ),
    ).called(1);
  });
}

// A channel state with every field set.
api.ChannelStateResponse _channelStateResponse({
  api.ChannelResponse? channel,
  List<api.PendingMessageResponse>? pendingMessages,
}) => api.ChannelStateResponse(
  duration: '0.01ms',
  channel: channel ?? generatedChannel,
  messages: [generatedLeafMessage('message-1')],
  pinnedMessages: [generatedLeafMessage('pinned-1')],
  members: [fakeChannelMemberResponse()],
  membership: fakeChannelMemberResponse(),
  watcherCount: 3,
  watchers: [fakeUserResponse('watcher')],
  read: [
    api.ReadStateResponse(
      lastRead: DateTime.utc(2026, 1, 2),
      user: fakeUserResponse('reader'),
      lastReadMessageId: 'message-1',
      unreadMessages: 4,
      lastDeliveredAt: DateTime.utc(2026, 1, 3),
      lastDeliveredMessageId: 'message-1',
    ),
  ],
  draft: generatedDraft,
  pendingMessages:
      pendingMessages ??
      [
        api.PendingMessageResponse(message: generatedLeafMessage('pending-1')),
        const api.PendingMessageResponse(),
      ],
  pushPreferences: api.ChannelPushPreferencesResponse(
    chatLevel: 'mentions',
    chatPreferences: const api.ChatPreferencesResponse(directMentions: 'all'),
    disabledUntil: DateTime.utc(2026, 6),
  ),
  activeLiveLocations: [
    api.SharedLocationResponseData(
      channelCid: 'messaging:general',
      createdAt: DateTime.utc(2026, 1, 9),
      createdByDeviceId: 'device-id',
      latitude: 1.5,
      longitude: 2.5,
      messageId: 'message-id',
      updatedAt: DateTime.utc(2026, 1, 9, 12),
      userId: 'sender',
    ),
  ],
  threads: const [],
  hidden: false,
  hideMessagesBefore: DateTime.utc(2026),
);

MockDefaultApi _defaultApi({api.ChannelStateResponse? response}) {
  final defaultApi = MockDefaultApi();
  when(
    () => defaultApi.getOrCreateChannel(
      type: any(named: 'type'),
      id: any(named: 'id'),
      channelGetOrCreateRequest: any(named: 'channelGetOrCreateRequest'),
    ),
  ).thenAnswer((_) async => Result.success(response ?? _channelStateResponse()));
  when(
    () => defaultApi.getOrCreateDistinctChannel(
      type: any(named: 'type'),
      channelGetOrCreateRequest: any(named: 'channelGetOrCreateRequest'),
    ),
  ).thenAnswer((_) async => Result.success(response ?? _channelStateResponse()));
  return defaultApi;
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
