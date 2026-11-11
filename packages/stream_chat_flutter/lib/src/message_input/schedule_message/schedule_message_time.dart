import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// How far ahead of now a message must be scheduled when the channel config
/// doesn't say.
@internal
const defaultScheduleMinLeadTime = Duration(minutes: 1);

// How far ahead a message can be scheduled when the channel config doesn't
// say.
const _defaultMaxLeadTime = Duration(days: 120);

// Leaves room for this device's clock running ahead.
const _clockSkewBuffer = Duration(minutes: 1);

/// The earliest and latest times a message can be scheduled for under
/// [config], measured from now.
@internal
({DateTime earliest, DateTime latest}) scheduleWindow(ChannelConfig? config) {
  final minLeadTime = config?.scheduledMessagesMinLeadTime ?? defaultScheduleMinLeadTime;
  final maxLeadTime = config?.scheduledMessagesMaxLeadTime ?? _defaultMaxLeadTime;
  final now = clock.now();

  return (
    earliest: now.add(minLeadTime + _clockSkewBuffer),
    latest: now.add(maxLeadTime),
  );
}

/// The config of the channel [cid], or null when the channel isn't loaded.
@internal
ChannelConfig? loadedChannelConfig(StreamChatClient client, String cid) {
  return client.state.channels[cid]?.state?.channelState.channel?.config;
}

/// The preset times offered for scheduling a message, in local time.
///
/// They are tomorrow at 09:00 and 13:00, and the next Monday at 09:00. When
/// tomorrow is Monday, that Monday is the one a week later.
@internal
List<DateTime> schedulePresets() {
  final now = clock.now();

  var daysToMonday = (DateTime.monday - now.weekday) % 7;
  if (daysToMonday <= 1) daysToMonday += 7;

  // Built from calendar fields, so a daylight saving change doesn't move
  // them off the hour.
  return [
    DateTime(now.year, now.month, now.day + 1, 9),
    DateTime(now.year, now.month, now.day + 1, 13),
    DateTime(now.year, now.month, now.day + daysToMonday, 9),
  ];
}

/// The label of a time-zone [offset] from UTC, such as "GMT", "GMT+2" or
/// "GMT+5:30".
@internal
String timeZoneLabel(Duration offset) {
  if (offset == Duration.zero) return 'GMT';

  final sign = offset.isNegative ? '-' : '+';
  final hours = offset.inHours.abs();
  final minutes = offset.inMinutes.remainder(60).abs();

  if (minutes == 0) return 'GMT$sign$hours';
  return 'GMT$sign$hours:${minutes.toString().padLeft(2, '0')}';
}
