import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.UpdateChannelPartialRequest()));

  test(
    'StreamChatClient.updateChannelPartial sends the set and unset fields and returns the updated members',
    () async {
      const request = api.UpdateChannelPartialRequest(set: {'name': 'General'}, unset: ['topic']);

      final defaultApi = MockDefaultApi();
      when(
        () => defaultApi.updateChannelPartial(type: 'messaging', id: 'general', updateChannelPartialRequest: request),
      ).thenAnswer((_) async => Result.success(_updateChannelPartialResponse()));
      final client = _client(defaultApi);

      final res = await client.updateChannelPartial(
        'general',
        'messaging',
        set: const {'name': 'General'},
        unset: const ['topic'],
      );

      expect(res.getOrNull()!.duration, '0.01ms');
      expect(res.getOrNull()!.members, [fakeChannelMember()]);
      verify(
        () => defaultApi.updateChannelPartial(type: 'messaging', id: 'general', updateChannelPartialRequest: request),
      ).called(1);
      verifyNoMoreInteractions(defaultApi);
    },
  );

  test('StreamChatClient.updateChannelPartial returns the channel with every field it models', () async {
    const request = api.UpdateChannelPartialRequest(set: {'name': 'General'});

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateChannelPartial(type: 'messaging', id: 'general', updateChannelPartialRequest: request),
    ).thenAnswer((_) async => Result.success(_updateChannelPartialResponse()));
    final client = _client(defaultApi);

    final res = await client.updateChannelPartial('general', 'messaging', set: const {'name': 'General'});

    final channel = res.getOrNull()!.channel!;
    expect(channel.id, 'general');
    expect(channel.type, 'messaging');
    expect(channel.cid, 'messaging:general');
    expect(channel.ownCapabilities, [ChannelCapability.sendMessage, ChannelCapability.readEvents]);
    expect(channel.createdBy, fakeUser('creator'));
    expect(channel.frozen, isTrue);
    expect(channel.lastMessageAt, DateTime.utc(2026, 3, 4));
    expect(channel.createdAt, DateTime.utc(2026));
    expect(channel.updatedAt, DateTime.utc(2026, 2));
    expect(channel.deletedAt, DateTime.utc(2026, 3));
    expect(channel.memberCount, 2);
    expect(channel.members, [fakeChannelMember()]);
    expect(channel.team, 'blue');
    expect(channel.cooldown, 30);
    expect(channel.disabled, isFalse);
    expect(channel.hidden, isTrue);
    expect(channel.muted, isTrue);
    expect(channel.blocked, isFalse);
    expect(channel.truncatedAt, DateTime.utc(2026, 3, 2));
    expect(channel.truncatedBy, fakeUser('truncator'));
    expect(channel.autoTranslationEnabled, isTrue);
    expect(channel.autoTranslationLanguage, 'fr');
    expect(channel.messageCount, 42);
    expect(channel.filterTags, ['support']);
  });

  test('StreamChatClient.updateChannelPartial returns the channel name and image from its custom data', () async {
    const request = api.UpdateChannelPartialRequest(set: {'name': 'General'});

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateChannelPartial(type: 'messaging', id: 'general', updateChannelPartialRequest: request),
    ).thenAnswer((_) async => Result.success(_updateChannelPartialResponse()));
    final client = _client(defaultApi);

    final res = await client.updateChannelPartial('general', 'messaging', set: const {'name': 'General'});

    final channel = res.getOrNull()!.channel!;
    expect(channel.name, 'General');
    expect(channel.extraData['image'], 'https://example.com/general.png');
  });

  test('StreamChatClient.updateChannelPartial keeps the custom data and the server fields in extraData', () async {
    const request = api.UpdateChannelPartialRequest(set: {'name': 'General'});

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateChannelPartial(type: 'messaging', id: 'general', updateChannelPartialRequest: request),
    ).thenAnswer((_) async => Result.success(_updateChannelPartialResponse()));
    final client = _client(defaultApi);

    final res = await client.updateChannelPartial('general', 'messaging', set: const {'name': 'General'});

    expect(res.getOrNull()!.channel!.extraData, {
      'name': 'General',
      'image': 'https://example.com/general.png',
      'topic': 'anything',
      'disabled': false,
      'hidden': true,
      'muted': true,
      'blocked': false,
      'truncated_at': DateTime.utc(2026, 3, 2).toIso8601String(),
      'truncated_by': fakeUser('truncator').toJson(),
      'auto_translation_enabled': true,
      'auto_translation_language': 'fr',
    });
  });

  test('StreamChatClient.updateChannelPartial drops channel custom data named like a channel field', () async {
    final response = _updateChannelPartialResponse(
      channel: _channelResponse(custom: const {'hidden': 'shadowed', 'cid': 'shadowed'}),
    );
    const request = api.UpdateChannelPartialRequest(set: {'name': 'General'});

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateChannelPartial(type: 'messaging', id: 'general', updateChannelPartialRequest: request),
    ).thenAnswer((_) async => Result.success(response));
    final client = _client(defaultApi);

    final res = await client.updateChannelPartial('general', 'messaging', set: const {'name': 'General'});

    final channel = res.getOrNull()!.channel!;
    expect(channel.hidden, isTrue);
    expect(channel.extraData, isNot(contains('cid')));
  });

  test('StreamChatClient.updateChannelPartial falls back to the defaults for channel fields left out', () async {
    final response = _updateChannelPartialResponse(
      channel: api.ChannelResponse(
        cid: 'messaging:general',
        id: 'general',
        type: 'messaging',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026, 2),
        custom: const {},
        disabled: false,
        frozen: false,
      ),
    );
    const request = api.UpdateChannelPartialRequest(set: {'name': 'General'});

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateChannelPartial(type: 'messaging', id: 'general', updateChannelPartialRequest: request),
    ).thenAnswer((_) async => Result.success(response));
    final client = _client(defaultApi);

    final res = await client.updateChannelPartial('general', 'messaging', set: const {'name': 'General'});

    final channel = res.getOrNull()!.channel!;
    expect(channel.memberCount, 0);
    expect(channel.cooldown, 0);
    expect(channel.config.commands, isEmpty);
    expect(channel.members, isNull);
  });

  test('StreamChatClient.updateChannelPartial returns the channel config with every field it models', () async {
    const request = api.UpdateChannelPartialRequest(set: {'name': 'General'});

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateChannelPartial(type: 'messaging', id: 'general', updateChannelPartialRequest: request),
    ).thenAnswer((_) async => Result.success(_updateChannelPartialResponse()));
    final client = _client(defaultApi);

    final res = await client.updateChannelPartial('general', 'messaging', set: const {'name': 'General'});

    final config = res.getOrNull()!.channel!.config;
    expect(config.automod, 'simple');
    expect(config.commands.single.name, 'giphy');
    expect(config.commands.single.description, 'Post a random gif');
    expect(config.commands.single.args, '[text]');
    expect(config.commands.single.set, CommandSet.fun);
    expect(config.connectEvents, isTrue);
    expect(config.createdAt, DateTime.utc(2025));
    expect(config.updatedAt, DateTime.utc(2025, 2));
    expect(config.maxMessageLength, 5000);
    expect(config.messageRetention, 'infinite');
    expect(config.mutes, isTrue);
    expect(config.reactions, isTrue);
    expect(config.readEvents, isTrue);
    expect(config.replies, isTrue);
    expect(config.search, isTrue);
    expect(config.polls, isTrue);
    expect(config.pushLevel, PushLevel.directMentions);
    expect(config.pushNotifications, isFalse);
    expect(
      config.chatPreferences,
      const ChatPreferences(
        channelMentions: ChatPreferenceLevel.all,
        defaultPreference: ChatPreferenceLevel.none,
        directMentions: ChatPreferenceLevel.all,
        groupMentions: ChatPreferenceLevel.none,
        hereMentions: ChatPreferenceLevel.all,
        roleMentions: ChatPreferenceLevel.none,
        threadReplies: ChatPreferenceLevel.all,
      ),
    );
    expect(config.typingEvents, isTrue);
    expect(config.uploads, isTrue);
    expect(config.urlEnrichment, isTrue);
    expect(config.skipLastMsgUpdateForSystemMsgs, isTrue);
    expect(config.userMessageReminders, isTrue);
    expect(config.markMessagesPending, isTrue);
    expect(config.deliveryEvents, isTrue);
    expect(config.sharedLocations, isTrue);
  });

  test('StreamChatClient.updateChannelPartial returns a null channel when the response has none', () async {
    const response = api.UpdateChannelPartialResponse(duration: '0.01ms', members: []);
    const request = api.UpdateChannelPartialRequest(set: {'name': 'General'});

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateChannelPartial(type: 'messaging', id: 'general', updateChannelPartialRequest: request),
    ).thenAnswer((_) async => const Result.success(response));
    final client = _client(defaultApi);

    final res = await client.updateChannelPartial('general', 'messaging', set: const {'name': 'General'});

    expect(res, const Result.success(UpdateChannelPartialResponse(duration: '0.01ms')));
  });

  test('StreamChatClient.updateChannelPartial returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateChannelPartial(
        type: any(named: 'type'),
        id: any(named: 'id'),
        updateChannelPartialRequest: any(named: 'updateChannelPartialRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.updateChannelPartial('general', 'messaging', set: const {'name': 'General'});

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.enableSlowMode sends the cooldown and returns a success', () async {
    const request = api.UpdateChannelPartialRequest(set: {'cooldown': 30});

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateChannelPartial(type: 'messaging', id: 'general', updateChannelPartialRequest: request),
    ).thenAnswer((_) async => Result.success(_updateChannelPartialResponse()));
    final client = _client(defaultApi);

    final res = await client.enableSlowMode('general', 'messaging', 30);

    expect(res.isSuccess, isTrue);

    verify(
      () => defaultApi.updateChannelPartial(type: 'messaging', id: 'general', updateChannelPartialRequest: request),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.enableSlowMode returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateChannelPartial(
        type: any(named: 'type'),
        id: any(named: 'id'),
        updateChannelPartialRequest: any(named: 'updateChannelPartialRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.enableSlowMode('general', 'messaging', 30);

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.disableSlowMode sends the cooldown set to 0 and returns a success', () async {
    const request = api.UpdateChannelPartialRequest(set: {'cooldown': 0});

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateChannelPartial(type: 'messaging', id: 'general', updateChannelPartialRequest: request),
    ).thenAnswer((_) async => Result.success(_updateChannelPartialResponse()));
    final client = _client(defaultApi);

    final res = await client.disableSlowMode('general', 'messaging');

    expect(res.isSuccess, isTrue);

    verify(
      () => defaultApi.updateChannelPartial(type: 'messaging', id: 'general', updateChannelPartialRequest: request),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.disableSlowMode returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateChannelPartial(
        type: any(named: 'type'),
        id: any(named: 'id'),
        updateChannelPartialRequest: any(named: 'updateChannelPartialRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.disableSlowMode('general', 'messaging');

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}

// A response with every field set.
api.UpdateChannelPartialResponse _updateChannelPartialResponse({
  api.ChannelResponse? channel,
  List<api.ChannelMemberResponse>? members,
}) => api.UpdateChannelPartialResponse(
  channel: channel ?? _channelResponse(),
  duration: '0.01ms',
  members: members ?? [fakeChannelMemberResponse()],
);

// A channel with every field set.
api.ChannelResponse _channelResponse({
  Map<String, Object?> custom = const {
    'name': 'General',
    'image': 'https://example.com/general.png',
    'topic': 'anything',
  },
}) => api.ChannelResponse(
  autoTranslationEnabled: true,
  autoTranslationLanguage: 'fr',
  blocked: false,
  cid: 'messaging:general',
  config: api.ChannelConfigWithInfo(
    allowedFlagReasons: const ['spam'],
    automod: api.ChannelConfigWithInfoAutomod.simple,
    automodBehavior: api.ChannelConfigWithInfoAutomodBehavior.flag,
    blocklist: 'profanity',
    blocklistBehavior: api.ChannelConfigWithInfoBlocklistBehavior.block,
    chatPreferences: const api.ChatPreferences(
      channelMentions: 'all',
      defaultPreference: 'none',
      directMentions: 'all',
      distinctChannelMessages: 'all',
      groupMentions: 'none',
      hereMentions: 'all',
      roleMentions: 'none',
      threadReplies: 'all',
    ),
    commands: [
      api.Command(
        args: '[text]',
        createdAt: DateTime.utc(2025),
        description: 'Post a random gif',
        name: 'giphy',
        set: 'fun_set',
        updatedAt: DateTime.utc(2025, 2),
      ),
    ],
    connectEvents: true,
    countMessages: true,
    createdAt: DateTime.utc(2025),
    customEvents: true,
    deliveryEvents: true,
    grants: const {
      'user': ['read-channel'],
    },
    markMessagesPending: true,
    maxMessageLength: 5000,
    messageRetention: 'infinite',
    mutes: true,
    name: 'messaging',
    partitionSize: 10,
    partitionTtl: '24h',
    polls: true,
    pushLevel: api.ChannelConfigWithInfoPushLevel.directMentions,
    pushNotifications: false,
    quotes: true,
    reactions: true,
    readEvents: true,
    reminders: true,
    replies: true,
    search: true,
    sharedLocations: true,
    skipLastMsgUpdateForSystemMsgs: true,
    typingEvents: true,
    updatedAt: DateTime.utc(2025, 2),
    uploads: true,
    urlEnrichment: true,
    userMessageReminders: true,
  ),
  cooldown: 30,
  createdAt: DateTime.utc(2026),
  createdBy: fakeUserResponse('creator'),
  custom: custom,
  deletedAt: DateTime.utc(2026, 3),
  disabled: false,
  filterTags: const ['support'],
  frozen: true,
  hidden: true,
  hideMessagesBefore: DateTime.utc(2026, 3, 1),
  id: 'general',
  lastMessageAt: DateTime.utc(2026, 3, 4),
  memberCount: 2,
  members: [fakeChannelMemberResponse()],
  messageCount: 42,
  muteExpiresAt: DateTime.utc(2026, 5),
  muted: true,
  ownCapabilities: const [api.ChannelOwnCapability.sendMessage, api.ChannelOwnCapability.readEvents],
  team: 'blue',
  truncatedAt: DateTime.utc(2026, 3, 2),
  truncatedBy: fakeUserResponse('truncator'),
  type: 'messaging',
  updatedAt: DateTime.utc(2026, 2),
);
