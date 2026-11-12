// Imports the internal helpers: a widget test can't set the device's time
// zone, and a sheet always opens with its channel's config, so the offsets
// and the defaults below can't be reached through the sheets.
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_input/schedule_message/schedule_message_bounds.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  final now = DateTime(2026, 10, 21, 10);

  test('ScheduleMessageBounds.fromConfig takes the default lead times without a config', () {
    final bounds = withClock(Clock.fixed(now), () => ScheduleMessageBounds.fromConfig(null));

    expect(bounds.minLeadTime, const Duration(minutes: 1));
    expect(bounds.earliest, now.add(const Duration(minutes: 1)));
    expect(bounds.latest, now.add(const Duration(days: 120)));
  });

  test("ScheduleMessageBounds.fromConfig takes the config's lead times", () {
    final config = ChannelConfig(
      scheduledMessagesMinLeadTime: const Duration(hours: 2),
      scheduledMessagesMaxLeadTime: const Duration(days: 7),
    );
    final bounds = withClock(Clock.fixed(now), () => ScheduleMessageBounds.fromConfig(config));

    expect(bounds.minLeadTime, const Duration(hours: 2));
    expect(bounds.earliest, now.add(const Duration(hours: 2)));
    expect(bounds.latest, now.add(const Duration(days: 7)));
  });

  test('timeZoneLabel names UTC GMT', () {
    expect(timeZoneLabel(Duration.zero), 'GMT');
  });

  test('timeZoneLabel names a whole-hour offset with its hours', () {
    expect(timeZoneLabel(const Duration(hours: 2)), 'GMT+2');
  });

  test('timeZoneLabel names a half-hour offset with its minutes', () {
    expect(timeZoneLabel(const Duration(hours: 5, minutes: 30)), 'GMT+5:30');
  });

  test('timeZoneLabel names an offset behind UTC with a minus', () {
    expect(timeZoneLabel(const Duration(hours: -3, minutes: -30)), 'GMT-3:30');
  });
}
