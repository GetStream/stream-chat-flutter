import 'package:clock/clock.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../../utils/extensions.dart';

// How soon and how far ahead a message can be scheduled when the channel
// config doesn't say.
const _defaultMinLeadTime = Duration(minutes: 1);
const _defaultMaxLeadTime = Duration(days: 120);

// Leaves room for this device's clock running ahead.
const _clockSkewBuffer = Duration(minutes: 1);

/// The earliest and latest times a message can be scheduled for in a
/// channel, measured from now.
class ScheduleMessageBounds {
  /// Creates the bounds of [channel], measured from now.
  factory ScheduleMessageBounds.of(Channel channel) {
    final config = channel.config;
    final minLeadTime = config?.scheduledMessagesMinLeadTime ?? _defaultMinLeadTime;
    final maxLeadTime = config?.scheduledMessagesMaxLeadTime ?? _defaultMaxLeadTime;
    final now = clock.now();

    return ScheduleMessageBounds._(
      earliest: now.add(minLeadTime + _clockSkewBuffer),
      latest: now.add(maxLeadTime),
    );
  }

  const ScheduleMessageBounds._({
    required this.earliest,
    required this.latest,
  });

  /// The earliest time a message can be scheduled for.
  final DateTime earliest;

  /// The latest time a message can be scheduled for.
  final DateTime latest;

  /// Whether [scheduledAt] is sooner than [earliest].
  bool isTooSoon(DateTime scheduledAt) => scheduledAt.isBefore(earliest);

  /// Whether [scheduledAt] is later than [latest].
  bool isTooFar(DateTime scheduledAt) => scheduledAt.isAfter(latest);

  /// Whether [scheduledAt] is within the bounds.
  bool contains(DateTime scheduledAt) {
    return !isTooSoon(scheduledAt) && !isTooFar(scheduledAt);
  }
}

/// The preset times offered for scheduling a message, in local time.
///
/// They are tomorrow at 09:00 and 13:00, and the next Monday at 09:00. When
/// tomorrow is Monday, that Monday is the one a week later.
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

/// Whether [scheduledAt] falls on the day after today, in local time.
bool isTomorrow(DateTime scheduledAt) {
  final now = clock.now();
  final tomorrow = DateTime(now.year, now.month, now.day + 1);
  final local = scheduledAt.toLocal();

  return local.year == tomorrow.year && local.month == tomorrow.month && local.day == tomorrow.day;
}

/// Whether [channel] holds as many pending scheduled messages as its config
/// allows.
///
/// Messages that failed don't count toward the limit.
bool isScheduleLimitReached(Channel channel) {
  final limit = channel.config?.scheduledMessagesMaxPerChannel;
  if (limit == null) return false;

  final scheduledMessages = channel.client.state.scheduledMessages;
  final pending = scheduledMessages.where((it) {
    if (it.cid != channel.cid) return false;
    return switch (it.status) {
      .scheduled || .sending || .preparingToSchedule => true,
      _ => false,
    };
  });

  return pending.length >= limit;
}

/// The name of [channel], for a label such as "Message to Maya".
///
/// A channel without a name of its own is named after its other members.
String? scheduleChannelName(Channel channel) {
  // A loaded channel keeps its members on its state, not on its model.
  final state = channel.state;
  final model = state?.channelState.channel?.copyWith(members: state.members);

  return model?.formatName(currentUser: channel.client.state.currentUser);
}

/// The label of a time-zone [offset] from UTC, such as "GMT", "GMT+2" or
/// "GMT+5:30".
String timeZoneLabel(Duration offset) {
  if (offset == Duration.zero) return 'GMT';

  final sign = offset.isNegative ? '-' : '+';
  final hours = offset.inHours.abs();
  final minutes = offset.inMinutes.remainder(60).abs();

  if (minutes == 0) return 'GMT$sign$hours';
  return 'GMT$sign$hours:${minutes.toString().padLeft(2, '0')}';
}
