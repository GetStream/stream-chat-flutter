import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  test('a user.updated event for the current user replaces their privacy settings', () async {
    final currentUser = OwnUser(
      id: 'user-id',
      privacySettings: const PrivacySettings(typingIndicators: TypingIndicators(enabled: true)),
    );
    final event = Event.fromJson(const {
      'type': EventType.userUpdated,
      'user': {
        'id': 'user-id',
        'privacy_settings': {
          'typing_indicators': {'enabled': false},
        },
      },
    });

    final client = _client(currentUser)..handleEvent(event);
    await Future<void>.delayed(Duration.zero);

    expect(client.state.currentUser!.privacySettings?.typingIndicators?.enabled, isFalse);
  });

  test('a user.updated event for the current user keeps the fields only an own user has', () async {
    final currentUser = OwnUser(
      id: 'user-id',
      unreadCount: 3,
      totalUnreadCountByTeam: const {'team-1': 3},
      latestHiddenChannels: const ['messaging:hidden'],
    );
    final event = Event.fromJson(const {
      'type': EventType.userUpdated,
      'user': {'id': 'user-id', 'name': 'Renamed'},
    });

    final client = _client(currentUser)..handleEvent(event);
    await Future<void>.delayed(Duration.zero);

    final updatedUser = client.state.currentUser!;
    expect(updatedUser.name, 'Renamed');
    expect(updatedUser.unreadCount, 3);
    expect(updatedUser.totalUnreadCountByTeam, {'team-1': 3});
    expect(updatedUser.latestHiddenChannels, ['messaging:hidden']);
  });
}

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
