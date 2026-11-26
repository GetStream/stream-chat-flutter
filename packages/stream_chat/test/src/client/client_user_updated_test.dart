import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  test('a user.updated event for the current user applies the profile it carries', () async {
    final client = _client(_currentUser())..handleEvent(UserUpdatedEvent(user: _updatedUser, isLocal: false));
    await Future<void>.delayed(Duration.zero);

    final user = client.state.currentUser!;
    expect(user.name, 'New Name');
    expect(user.image, 'https://example.com/new.png');
    expect(user.role, 'admin');
    expect(user.teams, ['blue']);
    expect(user.teamsRole, {'blue': 'admin'});
    expect(user.language, 'nl');
    expect(user.invisible, isTrue);
    expect(user.banned, isTrue);
    expect(user.online, isTrue);
    expect(user.lastActive, DateTime.utc(2026, 11, 25, 12));
    expect(user.createdAt, DateTime.utc(2026));
    expect(user.updatedAt, DateTime.utc(2026, 11, 25, 12, 30));
    expect(user.avgResponseTime, 42);
    expect(user.deactivatedAt, DateTime.utc(2026, 11, 25, 13));
    expect(user.deletedAt, DateTime.utc(2026, 11, 25, 14));
    expect(user.custom, {'color': 'blue'});
  });

  test('a user.updated event for the current user replaces their privacy settings', () async {
    const privacy = PrivacySettings(typingIndicators: TypingIndicators(enabled: false));
    final client = _client(_currentUser())
      ..handleEvent(UserUpdatedEvent(user: _updatedUser, privacySettings: privacy, isLocal: false));
    await Future<void>.delayed(Duration.zero);

    expect(client.state.currentUser!.privacySettings?.typingIndicators?.enabled, isFalse);
  });

  test('a user.updated event for the current user keeps what only the current user has', () async {
    final current = _currentUser();
    final client = _client(current)..handleEvent(UserUpdatedEvent(user: _updatedUser, isLocal: false));
    await Future<void>.delayed(Duration.zero);

    final user = client.state.currentUser!;
    expect(user.devices, current.devices);
    expect(user.mutes, current.mutes);
    expect(user.channelMutes, current.channelMutes);
    expect(user.totalUnreadCount, 3);
    expect(user.unreadChannels, 2);
    expect(user.unreadThreads, 1);
    expect(user.pushPreferences, current.pushPreferences);
  });

  test('a user.updated event for the current user keeps their blocked users, shadow ban and ban expiry', () async {
    final client = _client(_currentUser())..handleEvent(UserUpdatedEvent(user: _updatedUser, isLocal: false));
    await Future<void>.delayed(Duration.zero);

    final user = client.state.currentUser!;
    expect(user.blockedUserIds, ['blocked-id']);
    expect(user.shadowBanned, isTrue);
    expect(user.banExpires, DateTime.utc(2027));
  });

  test('a user.updated event for another user leaves the current user as they were', () async {
    final current = _currentUser();
    final client = _client(current)
      ..handleEvent(
        UserUpdatedEvent(
          user: User(id: 'other-id', name: 'Other'),
          isLocal: false,
        ),
      );
    await Future<void>.delayed(Duration.zero);

    expect(client.state.currentUser!.name, 'Old Name');
  });
}

OwnUser _currentUser() => OwnUser(
  id: 'user-id',
  name: 'Old Name',
  blockedUserIds: const ['blocked-id'],
  shadowBanned: true,
  banExpires: DateTime.utc(2027),
  devices: const [Device(id: 'device-id', pushProvider: PushProvider.firebase)],
  mutes: [
    Mute(
      user: User(id: 'user-id'),
      target: User(id: 'muted-id'),
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    ),
  ],
  channelMutes: [
    ChannelMute(
      user: User(id: 'user-id'),
      channel: ChannelModel(cid: 'messaging:muted'),
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    ),
  ],
  totalUnreadCount: 3,
  unreadChannels: 2,
  unreadThreads: 1,
  pushPreferences: const PushPreference(chatLevel: ChatLevel.mentions),
  privacySettings: const PrivacySettings(typingIndicators: TypingIndicators(enabled: true)),
);

final _updatedUser = User(
  id: 'user-id',
  name: 'New Name',
  image: 'https://example.com/new.png',
  role: 'admin',
  teams: const ['blue'],
  teamsRole: const {'blue': 'admin'},
  language: 'nl',
  invisible: true,
  banned: true,
  online: true,
  lastActive: DateTime.utc(2026, 11, 25, 12),
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026, 11, 25, 12, 30),
  avgResponseTime: 42,
  deactivatedAt: DateTime.utc(2026, 11, 25, 13),
  deletedAt: DateTime.utc(2026, 11, 25, 14),
  custom: const {'color': 'blue'},
);

// A client whose state follows its events for [currentUser], with no
// connection.
StreamChatClient _client(OwnUser currentUser) {
  final client = StreamChatClient('test-api-key', defaultApi: MockDefaultApi());
  addTearDown(client.dispose);
  client.state
    ..currentUser = currentUser
    ..subscribeToEvents();
  return client;
}
