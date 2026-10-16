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
