import 'package:stream_chat/src/core/models/push_preference.dart';
import 'package:test/test.dart';

void main() {
  group('src/models/push_preference_input', () {
    test('should serialize to json correctly for user-level preferences', () {
      final input = PushPreferenceInput(
        callLevel: CallLevelPushPreference.all,
        chatLevel: ChatLevelPushPreference.mentions,
        disabledUntil: DateTime.parse('2024-12-31T23:59:59Z'),
        removeDisable: true,
      );

      final json = input.toJson();
      expect(json['call_level'], 'all');
      expect(json['chat_level'], 'mentions');
      expect(json['disabled_until'], '2024-12-31T23:59:59.000Z');
      expect(json['remove_disable'], true);
      expect(json['channel_cid'], isNull);
    });

    test('should serialize to json correctly for channel preferences', () {
      final input = PushPreferenceInput.channel(
        channelCid: 'messaging:general',
        chatLevel: ChatLevelPushPreference.none,
        disabledUntil: DateTime.parse('2024-12-31T23:59:59Z'),
      );

      final json = input.toJson();
      expect(json['channel_cid'], 'messaging:general');
      expect(json['chat_level'], 'none');
      expect(json['disabled_until'], '2024-12-31T23:59:59.000Z');
      expect(json['call_level'], isNull);
      expect(json['remove_disable'], isNull);
    });

    test('should include default enum value', () {
      final input = PushPreferenceInput(
        chatLevel: ChatLevelPushPreference.defaultValue,
        callLevel: CallLevelPushPreference.defaultValue,
      );

      final json = input.toJson();
      expect(json['chat_level'], 'default');
      expect(json['call_level'], 'default');
    });
  });

  group('src/models/push_preference', () {
    test('should parse json correctly', () {
      final pushPreference = PushPreference.fromJson(const {
        'call_level': 'all',
        'chat_level': 'mentions',
        'disabled_until': '2024-12-31T23:59:59Z',
      });

      expect(pushPreference.callLevel, CallLevelPushPreference.all);
      expect(pushPreference.chatLevel, ChatLevelPushPreference.mentions);
      expect(
        pushPreference.disabledUntil,
        DateTime.parse('2024-12-31T23:59:59Z'),
      );
    });

    test('should parse default enum values', () {
      final pushPreference = PushPreference.fromJson(const {
        'call_level': 'default',
        'chat_level': 'default',
      });

      expect(pushPreference.callLevel, CallLevelPushPreference.defaultValue);
      expect(pushPreference.chatLevel, ChatLevelPushPreference.defaultValue);
    });
  });

  group('src/models/channel_push_preference', () {
    test('should parse json correctly', () {
      final channelPushPreference = ChannelPushPreference.fromJson(const {
        'chat_level': 'none',
        'disabled_until': '2024-12-31T23:59:59Z',
      });

      expect(channelPushPreference.chatLevel, ChatLevelPushPreference.none);
      expect(
        channelPushPreference.disabledUntil,
        DateTime.parse('2024-12-31T23:59:59Z'),
      );
    });

    test('should create correctly', () {
      final channelPushPreference = ChannelPushPreference(
        chatLevel: ChatLevelPushPreference.all,
        disabledUntil: DateTime.parse('2024-12-31T23:59:59Z'),
      );

      expect(channelPushPreference.chatLevel, ChatLevelPushPreference.all);
      expect(
        channelPushPreference.disabledUntil,
        DateTime.parse('2024-12-31T23:59:59Z'),
      );
    });
  });
}
