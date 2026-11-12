import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

// How soon and how far ahead a message can be scheduled when the channel
// config doesn't say.
const _defaultMinLeadTime = Duration(minutes: 1);
const _defaultMaxLeadTime = Duration(days: 120);

// Leaves room for this device's clock running ahead.
const _clockSkewBuffer = Duration(minutes: 1);

/// The earliest and latest times a message can be scheduled for in a
/// channel, measured from now.
@internal
class ScheduleMessageBounds {
  /// Creates the bounds a channel's [config] sets, measured from now.
  ///
  /// A null [config], or a lead time it leaves unset, takes the default.
  factory ScheduleMessageBounds.fromConfig(ChannelConfig? config) {
    final minLeadTime = config?.scheduledMessagesMinLeadTime ?? _defaultMinLeadTime;
    final maxLeadTime = config?.scheduledMessagesMaxLeadTime ?? _defaultMaxLeadTime;
    final now = clock.now();

    return ScheduleMessageBounds._(
      minLeadTime: minLeadTime,
      earliest: now.add(minLeadTime + _clockSkewBuffer),
      latest: now.add(maxLeadTime),
    );
  }

  const ScheduleMessageBounds._({
    required this.minLeadTime,
    required this.earliest,
    required this.latest,
  });

  /// How far ahead of now a message must be scheduled.
  final Duration minLeadTime;

  /// The earliest time a message can be scheduled for.
  final DateTime earliest;

  /// The latest time a message can be scheduled for.
  final DateTime latest;

  /// Whether [scheduledAt] is sooner than [earliest].
  bool isTooSoon(DateTime scheduledAt) => scheduledAt.isBefore(earliest);

  /// Whether [scheduledAt] is later than [latest].
  bool isTooFar(DateTime scheduledAt) => scheduledAt.isAfter(latest);

  /// Whether [scheduledAt] is within the bounds.
  bool contains(DateTime scheduledAt) => !isTooSoon(scheduledAt) && !isTooFar(scheduledAt);
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
