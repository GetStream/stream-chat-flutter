import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

void main() {
  test('reads the scheduled message limits', () {
    final config = ChannelConfig.fromJson({
      'scheduled_messages_max_per_channel': 10,
      'scheduled_messages_max_per_user': 100,
      'scheduled_messages_min_lead_time_seconds': 60,
      'scheduled_messages_max_lead_time_seconds': const Duration(days: 120).inSeconds,
    });

    expect(config.scheduledMessagesMaxPerChannel, 10);
    expect(config.scheduledMessagesMaxPerUser, 100);
    expect(config.scheduledMessagesMinLeadTime, const Duration(minutes: 1));
    expect(config.scheduledMessagesMaxLeadTime, const Duration(days: 120));
  });

  test('has no scheduled message limits when none are given', () {
    final config = ChannelConfig.fromJson({});

    expect(config.scheduledMessagesMaxPerChannel, isNull);
    expect(config.scheduledMessagesMaxPerUser, isNull);
    expect(config.scheduledMessagesMinLeadTime, isNull);
    expect(config.scheduledMessagesMaxLeadTime, isNull);
  });

  test('writes the scheduled message lead times as seconds', () {
    final json = ChannelConfig(
      scheduledMessagesMinLeadTime: const Duration(minutes: 1),
      scheduledMessagesMaxLeadTime: const Duration(days: 120),
    ).toJson();

    expect(json['scheduled_messages_min_lead_time_seconds'], 60);
    expect(json['scheduled_messages_max_lead_time_seconds'], const Duration(days: 120).inSeconds);
  });
}
