import 'package:stream_chat/src/core/models/chat_preferences.dart';
import 'package:stream_chat/src/core/models/push_preference.dart';
import 'package:test/test.dart';

void main() {
  group('src/models/push_preference_input', () {
    test('should serialize to json correctly for user-level preferences', () {
      final input = PushPreferenceInput(
        callLevel: CallLevel.all,
        chatLevel: ChatLevel.directMentions,
        disabledUntil: DateTime.parse('2024-12-31T23:59:59Z'),
        removeDisable: true,
      );

      final json = input.toJson();
      expect(json['call_level'], 'all');
      expect(json['chat_level'], 'direct_mentions');
      expect(json['disabled_until'], '2024-12-31T23:59:59.000Z');
      expect(json['remove_disable'], true);
      expect(json['channel_cid'], isNull);
    });

    test('should serialize a quiet-hours schedule', () {
      const input = PushPreferenceInput(
        schedule: PushSchedule(
          timezone: 'Europe/Amsterdam',
          quietHours: [
            QuietHoursRule(start: '22:00', end: '07:00', days: [QuietHoursDay.friday]),
            QuietHoursRule(start: '00:00', end: '24:00'),
          ],
        ),
      );

      expect(input.toJson(), {
        'schedule': {
          'timezone': 'Europe/Amsterdam',
          'quiet_hours': [
            {
              'start': '22:00',
              'end': '07:00',
              'days': ['fri'],
            },
            {'start': '00:00', 'end': '24:00', 'days': <String>[]},
          ],
        },
      });
    });

    test('should serialize removing the schedule', () {
      const input = PushPreferenceInput(removeSchedule: true);

      expect(input.toJson(), {'remove_schedule': true});
    });

    test('should serialize to json correctly for channel preferences', () {
      final input = PushPreferenceInput.channel(
        channelCid: 'messaging:general',
        chatLevel: ChatLevel.none,
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
      const input = PushPreferenceInput(
        chatLevel: ChatLevel.defaultValue,
        callLevel: CallLevel.defaultValue,
      );

      final json = input.toJson();
      expect(json['chat_level'], 'default');
      expect(json['call_level'], 'default');
    });

    test('should serialize chatPreferences for user-level preferences', () {
      const input = PushPreferenceInput(
        chatPreferences: ChatPreferences(
          defaultPreference: .all,
          directMentions: .none,
          threadReplies: .all,
        ),
      );

      final json = input.toJson();
      expect(json['chat_preferences'], <String, dynamic>{
        'default_preference': 'all',
        'direct_mentions': 'none',
        'thread_replies': 'all',
      });
      expect(json['chat_level'], isNull);
    });

    test('should serialize chatPreferences for channel preferences', () {
      const input = PushPreferenceInput.channel(
        channelCid: 'messaging:general',
        chatPreferences: ChatPreferences(
          channelMentions: .none,
        ),
      );

      final json = input.toJson();
      expect(json['channel_cid'], 'messaging:general');
      expect(json['chat_preferences'], <String, dynamic>{
        'channel_mentions': 'none',
      });
      expect(json['chat_level'], isNull);
    });
  });

  group('src/models/push_preference', () {
    test('should parse json correctly', () {
      final pushPreference = PushPreference.fromJson(const {
        'call_level': 'all',
        'chat_level': 'direct_mentions',
        'disabled_until': '2024-12-31T23:59:59Z',
      });

      expect(pushPreference.callLevel, CallLevel.all);
      expect(pushPreference.chatLevel, ChatLevel.directMentions);
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

      expect(pushPreference.callLevel, CallLevel.defaultValue);
      expect(pushPreference.chatLevel, ChatLevel.defaultValue);
    });

    test('should parse chatPreferences', () {
      final pushPreference = PushPreference.fromJson(const {
        'chat_preferences': {
          'default_preference': 'all',
          'direct_mentions': 'none',
          'role_mentions': 'all',
        },
      });

      expect(pushPreference.chatLevel, isNull);
      expect(
        pushPreference.chatPreferences?.defaultPreference,
        ChatPreferenceLevel.all,
      );
      expect(
        pushPreference.chatPreferences?.directMentions,
        ChatPreferenceLevel.none,
      );
      expect(
        pushPreference.chatPreferences?.roleMentions,
        ChatPreferenceLevel.all,
      );
      expect(pushPreference.chatPreferences?.groupMentions, isNull);
    });

    test('should parse a quiet-hours schedule', () {
      final pushPreference = PushPreference.fromJson(const {
        'schedule': {
          'timezone': 'Europe/Amsterdam',
          'quiet_hours': [
            {
              'start': '22:00',
              'end': '07:00',
              'days': ['sat', 'sun'],
            },
            {'start': '12:00', 'end': '13:00'},
          ],
        },
      });

      expect(
        pushPreference,
        const PushPreference(
          schedule: PushSchedule(
            timezone: 'Europe/Amsterdam',
            quietHours: [
              QuietHoursRule(
                start: '22:00',
                end: '07:00',
                days: [QuietHoursDay.saturday, QuietHoursDay.sunday],
              ),
              QuietHoursRule(start: '12:00', end: '13:00'),
            ],
          ),
        ),
      );
    });

    test('should read back the schedule it writes', () {
      const pushPreference = PushPreference(
        schedule: PushSchedule(
          timezone: 'Europe/Amsterdam',
          quietHours: [
            QuietHoursRule(start: '22:00', end: '07:00', days: [QuietHoursDay.friday]),
          ],
        ),
      );

      expect(PushPreference.fromJson(pushPreference.toJson()), pushPreference);
    });

    group('equality with quiet hours', () {
      const rule = QuietHoursRule(start: '22:00', end: '07:00', days: [QuietHoursDay.friday]);
      const preference = PushPreference(
        schedule: PushSchedule(timezone: 'Europe/Amsterdam', quietHours: [rule]),
      );

      test('differs from a preference without a schedule', () {
        expect(preference, isNot(const PushPreference()));
      });

      test('differs from a schedule in another time zone', () {
        expect(
          preference,
          isNot(
            const PushPreference(
              schedule: PushSchedule(timezone: 'UTC', quietHours: [rule]),
            ),
          ),
        );
      });

      test('differs from a rule on other days', () {
        expect(
          preference,
          isNot(
            const PushPreference(
              schedule: PushSchedule(
                timezone: 'Europe/Amsterdam',
                quietHours: [QuietHoursRule(start: '22:00', end: '07:00')],
              ),
            ),
          ),
        );
      });
    });
  });

  group('src/models/channel_push_preference', () {
    test('should parse json correctly', () {
      final channelPushPreference = ChannelPushPreference.fromJson(const {
        'chat_level': 'none',
        'disabled_until': '2024-12-31T23:59:59Z',
      });

      expect(channelPushPreference.chatLevel, ChatLevel.none);
      expect(
        channelPushPreference.disabledUntil,
        DateTime.parse('2024-12-31T23:59:59Z'),
      );
    });

    test('should create correctly', () {
      final channelPushPreference = ChannelPushPreference(
        chatLevel: ChatLevel.all,
        disabledUntil: DateTime.parse('2024-12-31T23:59:59Z'),
      );

      expect(channelPushPreference.chatLevel, ChatLevel.all);
      expect(
        channelPushPreference.disabledUntil,
        DateTime.parse('2024-12-31T23:59:59Z'),
      );
    });

    test('should parse chatPreferences', () {
      final channelPushPreference = ChannelPushPreference.fromJson(const {
        'chat_preferences': {
          'here_mentions': 'all',
          'channel_mentions': 'none',
        },
      });

      expect(channelPushPreference.chatLevel, isNull);
      expect(
        channelPushPreference.chatPreferences?.hereMentions,
        ChatPreferenceLevel.all,
      );
      expect(
        channelPushPreference.chatPreferences?.channelMentions,
        ChatPreferenceLevel.none,
      );
    });
  });
}
