import 'package:clock/clock.dart';
import 'package:flutter/cupertino.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';

/// Represents a function type that formats a date.
typedef DateFormatter = String Function(BuildContext context, DateTime date);

/// Returns a short label for [date] — time of day if today, weekday name
/// if within the last week, otherwise the numeric date.
///
/// Output examples:
/// - `9:41 PM`
/// - `Yesterday`
/// - `Saturday`
/// - `3/15/2025`
String formatDate(BuildContext context, DateTime date) {
  if (date.isToday) return Jiffy.parseFromDateTime(date).jm;
  if (date.isYesterday) return context.translations.yesterdayLabel;
  if (date.isWithinLastWeek) return Jiffy.parseFromDateTime(date).EEEE;

  return Jiffy.parseFromDateTime(date).yMd;
}

/// Returns a relative label for [date] paired with the time of day.
///
/// Output examples:
/// - `Just now`
/// - `Today at 9:41`
/// - `Yesterday at 9:41`
/// - `Saturday at 9:41`
/// - `Jan 1st at 9:41`
String formatRecentDateTime(BuildContext context, DateTime date) {
  if (date.isWithinLastMinute) return context.translations.justNowLabel;

  final localDate = date.toLocal();
  final jiffyDate = Jiffy.parseFromDateTime(localDate);
  final time = jiffyDate.format(pattern: 'H:mm');

  if (localDate.isToday) return '${context.translations.todayLabel} at $time';
  if (localDate.isYesterday) return '${context.translations.yesterdayLabel} at $time';
  if (localDate.isWithinLastWeek) return '${jiffyDate.EEEE} at $time';
  return '${jiffyDate.format(pattern: 'MMM do')} at $time';
}

/// Granularity for [DateTimeComparisonUtils.isSame], from coarsest to
/// finest.
enum DateTimeUnit {
  /// Year.
  year,

  /// Year and month.
  month,

  /// Year, month, and day.
  day,

  /// Year, month, day, and hour.
  hour,

  /// Year, month, day, hour, and minute.
  minute,

  /// Year, month, day, hour, minute, and second.
  second,

  /// All fields down to millisecond precision.
  millisecond,

  /// All fields down to microsecond precision.
  microsecond,
}

/// Date-comparison utilities on [DateTime].
///
/// All `is*`-against-now getters anchor on the user's local time —
/// `.toLocal()` is applied to [this] where it would affect the answer.
/// They also read "now" through `package:clock`, so tests can pin time
/// deterministically via `withClock(Clock.fixed(...))`.
///
/// [isSame] does field-level comparison without normalising timezones;
/// callers mixing UTC and local `DateTime`s should `.toLocal()` both
/// sides first.
extension DateTimeComparisonUtils on DateTime {
  /// Returns true if [this] falls on today's calendar day.
  bool get isToday => toLocal().isSame(clock.now(), unit: .day);

  /// Returns true if [this] fell on yesterday's calendar day.
  bool get isYesterday => toLocal().isSame(clock.now().subtract(const Duration(days: 1)), unit: .day);

  /// Returns true if [this] is within 1 minute of now in either direction.
  ///
  /// Used for the "Just now" UX bucket. Tolerates clock skew — a date up
  /// to 1 minute in the future also returns true.
  bool get isWithinLastMinute => clock.now().difference(toLocal()).abs() < const Duration(minutes: 1);

  /// Returns true if [this] is in the last week — today and the 6 days
  /// before today. Future dates return false.
  ///
  /// The 6-day window (not 7) avoids weekday-label collision: a date
  /// exactly 7 days ago shares today's weekday, which would be ambiguous
  /// as a label.
  bool get isWithinLastWeek {
    final local = toLocal();
    final now = clock.now();

    final startBucket = DateTime(now.year, now.month, now.day - 6);
    return !local.isBefore(startBucket) && !local.isAfter(now);
  }

  /// Returns true if [this] falls in the same calendar year as today.
  ///
  /// Same-calendar-year, not a sliding 365-day window — Dec 31 and the
  /// following Jan 1 are *not* in the same year by this check.
  bool get isInSameYear => toLocal().year == clock.now().year;

  /// Returns true if [this] and [other] share the same value down to the
  /// given [unit] granularity — e.g. `unit: .day` matches anything on the
  /// same calendar day, `unit: .minute` matches the same `H:mm` label.
  ///
  /// Compares fields directly and does **not** normalise timezones. If
  /// [this] and [other] may be in different timezones, call `.toLocal()`
  /// on both before passing them in.
  bool isSame(DateTime other, {required DateTimeUnit unit}) {
    if (year != other.year) return false;
    if (unit == .year) return true;
    if (month != other.month) return false;
    if (unit == .month) return true;
    if (day != other.day) return false;
    if (unit == .day) return true;
    if (hour != other.hour) return false;
    if (unit == .hour) return true;
    if (minute != other.minute) return false;
    if (unit == .minute) return true;
    if (second != other.second) return false;
    if (unit == .second) return true;
    if (millisecond != other.millisecond) return false;
    if (unit == .millisecond) return true;
    return microsecond == other.microsecond;
  }
}
