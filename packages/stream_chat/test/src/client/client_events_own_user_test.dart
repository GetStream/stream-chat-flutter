import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';
import 'event_fixtures.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.SendEventRequest(event: api.EventRequest(type: 'any'))));

  test(
    'StreamChatClient.sendEvent maps a notification.mutes_updated event onto a NotificationMutesUpdatedEvent',
    () async {
      final event = await _sentEvent<NotificationMutesUpdatedEvent>(
        api.NotificationMutesUpdatedEvent(
          createdAt: eventCreatedAt,
          custom: eventCustom,
          me: _generatedMe,
          receivedAt: eventReceivedAt,
          type: EventType.notificationMutesUpdated,
        ),
      );

      expect(
        event,
        NotificationMutesUpdatedEvent(
          me: _expectedMeProfile,
          createdAt: eventCreatedAt,
          custom: eventCustom,
          isLocal: false,
        ),
      );
    },
  );

  test(
    'StreamChatClient.sendEvent maps a notification.channel_mutes_updated event onto a '
    'NotificationChannelMutesUpdatedEvent',
    () async {
      final event = await _sentEvent<NotificationChannelMutesUpdatedEvent>(
        api.NotificationChannelMutesUpdatedEvent(
          createdAt: eventCreatedAt,
          custom: eventCustom,
          me: _generatedMe,
          receivedAt: eventReceivedAt,
          type: EventType.notificationChannelMutesUpdated,
        ),
      );

      expect(
        event,
        NotificationChannelMutesUpdatedEvent(
          me: _expectedMeProfile,
          createdAt: eventCreatedAt,
          custom: eventCustom,
          isLocal: false,
        ),
      );
    },
  );

  test('StreamChatClient.sendEvent maps the update time of the current user', () async {
    final me = await _sentMe();

    expect(me.updatedAt, DateTime.utc(2024, 2, 5));
  });

  test('StreamChatClient.sendEvent maps the devices of the current user', () async {
    final me = await _sentMe();

    expect(me.devices, const [Device(id: 'device-token', pushProvider: PushProvider.firebase)]);
  });

  test('StreamChatClient.sendEvent maps a mute of the current user', () async {
    final me = await _sentMe();

    expect(
      me.mutes.first,
      isA<Mute>()
          .having((it) => it.user, 'user', fakeUser('me'))
          .having((it) => it.target, 'target', fakeUser('muted'))
          .having((it) => it.createdAt, 'createdAt', DateTime.utc(2026, 4, 1))
          .having((it) => it.updatedAt, 'updatedAt', DateTime.utc(2026, 4, 2))
          .having((it) => it.expires, 'expires', DateTime.utc(2026, 5, 1)),
    );
  });

  test('StreamChatClient.sendEvent leaves out a mute of the current user that names no target', () async {
    final me = await _sentMe();

    expect(me.mutes.map((it) => it.target.id), ['muted']);
  });

  test('StreamChatClient.sendEvent maps a channel mute of the current user', () async {
    final me = await _sentMe();

    expect(
      me.channelMutes.first,
      isA<ChannelMute>()
          .having((it) => it.user, 'user', fakeUser('me'))
          .having((it) => it.channel.cid, 'channel.cid', 'messaging:general')
          .having((it) => it.createdAt, 'createdAt', DateTime.utc(2026, 4, 3))
          .having((it) => it.updatedAt, 'updatedAt', DateTime.utc(2026, 4, 4))
          .having((it) => it.expires, 'expires', DateTime.utc(2026, 5, 2)),
    );
  });

  test('StreamChatClient.sendEvent leaves out a channel mute of the current user that names no channel', () async {
    final me = await _sentMe();

    expect(me.channelMutes.map((it) => it.channel.cid), ['messaging:general']);
  });

  test('StreamChatClient.sendEvent maps the unread counts of the current user', () async {
    final me = await _sentMe();

    expect((me.totalUnreadCount, me.unreadChannels, me.unreadThreads), (11, 5, 2));
  });

  test('StreamChatClient.sendEvent maps the push preferences of the current user with their schedule', () async {
    final me = await _sentMe();

    expect(
      me.pushPreferences,
      PushPreference(
        chatLevel: ChatLevel.mentions,
        chatPreferences: const ChatPreferences(
          channelMentions: ChatPreferenceLevel.all,
          defaultPreference: ChatPreferenceLevel.none,
          directMentions: ChatPreferenceLevel('direct'),
          groupMentions: ChatPreferenceLevel('group'),
          hereMentions: ChatPreferenceLevel('here'),
          roleMentions: ChatPreferenceLevel('role'),
          threadReplies: ChatPreferenceLevel('replies'),
        ),
        disabledUntil: DateTime.utc(2026, 6),
        schedule: const PushSchedule(
          timezone: 'Europe/Sofia',
          quietHours: [
            QuietHoursRule(start: '22:00', end: '08:00', days: [QuietHoursDay.monday, QuietHoursDay('sat')]),
          ],
        ),
      ),
    );
  });

  test('StreamChatClient.sendEvent maps the privacy settings of the current user', () async {
    final me = await _sentMe();

    expect(me.privacySettings, expectedEventPrivacySettings);
  });
}

// The current user a notification.mutes_updated event the client returns
// carries, for [_generatedMe].
Future<OwnUser> _sentMe() async {
  final event = await _sentEvent<NotificationMutesUpdatedEvent>(
    api.NotificationMutesUpdatedEvent(
      createdAt: eventCreatedAt,
      custom: eventCustom,
      me: _generatedMe,
      type: EventType.notificationMutesUpdated,
    ),
  );
  return event.me;
}

// The current user with every field set, and a mute and a channel mute each
// missing what they concern.
final _generatedMe = api.OwnUserResponse(
  avgResponseTime: 45,
  banned: true,
  blockedUserIds: const ['blocked-id'],
  channelMutes: [
    api.ChannelMute(
      channel: generatedChannel,
      createdAt: DateTime.utc(2026, 4, 3),
      expires: DateTime.utc(2026, 5, 2),
      updatedAt: DateTime.utc(2026, 4, 4),
      user: fakeUserResponse('me'),
    ),
    api.ChannelMute(
      createdAt: DateTime.utc(2026, 4, 5),
      updatedAt: DateTime.utc(2026, 4, 6),
      user: fakeUserResponse('me'),
    ),
  ],
  createdAt: DateTime.utc(2024, 2, 1),
  custom: const {'theme': 'dark'},
  deactivatedAt: DateTime.utc(2024, 2, 2),
  deletedAt: DateTime.utc(2024, 2, 3),
  devices: [
    api.DeviceResponse(
      createdAt: DateTime.utc(2026, 1, 1),
      disabled: false,
      disabledReason: 'none',
      hardwareId: 'hardware-id',
      id: 'device-token',
      pushProvider: api.PushProviderName.firebase,
      pushProviderName: 'fcm-config',
      userId: 'me',
      voip: false,
    ),
  ],
  id: 'me',
  image: 'https://example.com/me.png',
  invisible: true,
  language: 'de',
  lastActive: DateTime.utc(2024, 2, 4),
  latestHiddenChannels: const ['messaging:hidden'],
  mutes: [
    api.UserMuteResponse(
      createdAt: DateTime.utc(2026, 4, 1),
      expires: DateTime.utc(2026, 5, 1),
      target: fakeUserResponse('muted'),
      updatedAt: DateTime.utc(2026, 4, 2),
      user: fakeUserResponse('me'),
    ),
    api.UserMuteResponse(
      createdAt: DateTime.utc(2026, 4, 7),
      updatedAt: DateTime.utc(2026, 4, 8),
      user: fakeUserResponse('me'),
    ),
  ],
  name: 'Me',
  online: true,
  privacySettings: generatedEventPrivacySettings,
  pushPreferences: api.PushPreferencesResponse(
    chatLevel: 'mentions',
    chatPreferences: const api.ChatPreferencesResponse(
      channelMentions: 'all',
      defaultPreference: 'none',
      directMentions: 'direct',
      groupMentions: 'group',
      hereMentions: 'here',
      roleMentions: 'role',
      threadReplies: 'replies',
    ),
    disabledUntil: DateTime.utc(2026, 6),
    schedule: const api.PushScheduleResponse(
      quietHours: [
        api.QuietHoursRuleResponse(days: ['mon', 'sat'], end: '08:00', start: '22:00'),
      ],
      timezone: 'Europe/Sofia',
    ),
  ),
  role: 'admin',
  teams: const ['red'],
  teamsRole: const {'red': 'member'},
  totalUnreadCount: 11,
  totalUnreadCountByTeam: const {'red': 4},
  unreadChannels: 5,
  unreadCount: 13,
  unreadThreads: 2,
  updatedAt: DateTime.utc(2024, 2, 5),
);

// The profile [_generatedMe] maps to; a current user compares by its profile
// only.
final _expectedMeProfile = OwnUser(
  id: 'me',
  role: 'admin',
  name: 'Me',
  image: 'https://example.com/me.png',
  createdAt: DateTime.utc(2024, 2, 1),
  updatedAt: DateTime.utc(2024, 2, 5),
  lastActive: DateTime.utc(2024, 2, 4),
  online: true,
  banned: true,
  teams: const ['red'],
  language: 'de',
  invisible: true,
  teamsRole: const {'red': 'member'},
  avgResponseTime: 45,
  custom: const {'theme': 'dark'},
  deactivatedAt: DateTime.utc(2024, 2, 2),
  deletedAt: DateTime.utc(2024, 2, 3),
  blockedUserIds: const ['blocked-id'],
);

// The event the client returns for a sent event the server answers with
// [event], checked to be a [T].
Future<T> _sentEvent<T extends ChatEvent>(api.WSEvent event) async {
  final defaultApi = MockDefaultApi();
  when(
    () => defaultApi.sendEvent(
      type: any(named: 'type'),
      id: any(named: 'id'),
      sendEventRequest: any(named: 'sendEventRequest'),
    ),
  ).thenAnswer((_) async => Result.success(api.EventResponse(duration: '0.01ms', event: event)));
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);

  final res = await client.sendEvent('general', 'messaging', type: event.type);

  final mapped = res.getOrNull()?.event;
  expect(mapped, isA<T>());
  return mapped! as T;
}
