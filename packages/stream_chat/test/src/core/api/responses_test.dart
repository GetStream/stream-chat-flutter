import 'dart:convert';

import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

void main() {
  group('src/api/responses', () {
    test('EmptyResponse', () {
      const jsonExample = '''{"file": "file-url","duration":"0.35ms"}''';
      final response = EmptyResponse.fromJson(json.decode(jsonExample));
      expect(response.duration, isA<String>());
    });

    test('UpsertPushPreferencesResponse', () {
      const jsonExample = '''
      {
        "user_preferences": {
          "user1": {
            "chat_level": "mentions",
            "call_level": "all",
            "disabled_until": "2024-12-31T23:59:59Z"
          },
          "user2": {
            "chat_level": "none"
          },
          "user3": null
        },
        "user_channel_preferences": {
          "user1": {
            "channel1": {
              "chat_level": "all",
              "disabled_until": "2024-12-31T23:59:59Z"
            },
            "channel2": {
              "chat_level": "none"
            }
          },
          "user2": {
            "channel3": {
              "chat_level": "mentions"
            }
          }
        }
      }
      ''';
      final response = UpsertPushPreferencesResponse.fromJson(
        json.decode(jsonExample),
      );

      expect(response.userPreferences, isA<Map<String, PushPreference>>());
      // user3 had a `null` value in the response (no user-global prefs were
      // touched by the upsert) — should be filtered outs.
      expect(response.userPreferences, hasLength(2));
      expect(response.userPreferences.containsKey('user3'), isFalse);

      // Test user1 preferences
      final user1Prefs = response.userPreferences['user1']!;
      expect(user1Prefs.chatLevel, ChatLevel.mentions);
      expect(user1Prefs.callLevel, CallLevel.all);
      expect(user1Prefs.disabledUntil, DateTime.parse('2024-12-31T23:59:59Z'));

      // Test user2 preferences
      final user2Prefs = response.userPreferences['user2']!;
      expect(user2Prefs.chatLevel, ChatLevel.none);

      expect(
        response.userChannelPreferences,
        isA<Map<String, Map<String, ChannelPushPreference>>>(),
      );
      expect(response.userChannelPreferences, hasLength(2));

      // Test user1 channel preferences
      final user1ChannelPrefs = response.userChannelPreferences['user1']!;
      expect(user1ChannelPrefs, hasLength(2));

      final channel1Prefs = user1ChannelPrefs['channel1']!;
      expect(channel1Prefs.chatLevel, ChatLevel.all);
      expect(channel1Prefs.disabledUntil, DateTime.parse('2024-12-31T23:59:59Z'));

      final channel2Prefs = user1ChannelPrefs['channel2']!;
      expect(channel2Prefs.chatLevel, ChatLevel.none);

      // Test user2 channel preferences
      final user2ChannelPrefs = response.userChannelPreferences['user2']!;
      expect(user2ChannelPrefs, hasLength(1));

      final channel3Prefs = user2ChannelPrefs['channel3']!;
      expect(channel3Prefs.chatLevel, ChatLevel.mentions);
    });
  });
}
