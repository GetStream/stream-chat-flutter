import 'package:stream_chat/src/core/models/chat_preferences.dart';
import 'package:test/test.dart';

void main() {
  group('src/models/chat_preference_level', () {
    test('constants resolve to expected wire strings', () {
      expect(ChatPreferenceLevel.all, 'all');
      expect(ChatPreferenceLevel.none, 'none');
    });
  });

  group('src/models/chat_preferences', () {
    test('should serialize to json correctly', () {
      const prefs = ChatPreferences(
        channelMentions: ChatPreferenceLevel.none,
        defaultPreference: ChatPreferenceLevel.all,
        directMentions: ChatPreferenceLevel.all,
        groupMentions: ChatPreferenceLevel.none,
        hereMentions: ChatPreferenceLevel.all,
        roleMentions: ChatPreferenceLevel.none,
        threadReplies: ChatPreferenceLevel.all,
      );

      expect(prefs.toJson(), <String, dynamic>{
        'channel_mentions': 'none',
        'default_preference': 'all',
        'direct_mentions': 'all',
        'group_mentions': 'none',
        'here_mentions': 'all',
        'role_mentions': 'none',
        'thread_replies': 'all',
      });
    });

    test('should omit unset fields when serializing', () {
      const prefs = ChatPreferences(
        directMentions: ChatPreferenceLevel.all,
      );

      expect(prefs.toJson(), <String, dynamic>{
        'direct_mentions': 'all',
      });
    });

    test('should parse json correctly', () {
      final prefs = ChatPreferences.fromJson(const {
        'default_preference': 'all',
        'direct_mentions': 'none',
      });

      expect(prefs.defaultPreference, ChatPreferenceLevel.all);
      expect(prefs.directMentions, ChatPreferenceLevel.none);
      expect(prefs.channelMentions, isNull);
      expect(prefs.groupMentions, isNull);
      expect(prefs.hereMentions, isNull);
      expect(prefs.roleMentions, isNull);
      expect(prefs.threadReplies, isNull);
    });
  });
}
