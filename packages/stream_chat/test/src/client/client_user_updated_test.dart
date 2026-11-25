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
    await pumpEventQueue();

    expect(client.state.currentUser!.privacySettings?.typingIndicators?.enabled, isFalse);
  });

  test('a user.updated event for the current user keeps their blocked user ids', () async {
    final currentUser = OwnUser(id: 'user-id', blockedUserIds: const ['blocked-user-id']);
    final event = Event.fromJson(const {
      'type': EventType.userUpdated,
      'user': {'id': 'user-id', 'name': 'Jane', 'blocked_user_ids': <String>[]},
    });

    final client = _client(currentUser)..handleEvent(event);
    await pumpEventQueue();

    expect(client.state.currentUser!.blockedUserIds, ['blocked-user-id']);
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
