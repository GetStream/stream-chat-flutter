import 'package:flutter/cupertino.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';

/// Represents a function type that formats a date.
typedef DateFormatter = String Function(BuildContext context, DateTime date);

/// Formats the given [date] as a String.
String formatDate(BuildContext context, DateTime date) {
  if (date.isToday) return Jiffy.parseFromDateTime(date).jm;
  if (date.isYesterday) return context.translations.yesterdayLabel;
  if (date.isWithinAWeek) return Jiffy.parseFromDateTime(date).EEEE;

  return Jiffy.parseFromDateTime(date).yMd;
}

/// Output examples:
/// - `Just now`
/// - `Today at 9:41`
/// - `Yesterday at 9:41`
/// - `Saturday at 9:41`
/// - `Jan 1st at 9:41`
String formatRecentDateTime(
  BuildContext context,
  DateTime date, {
  DateTime? referenceDate,
}) {
  final localDate = date.toLocal();
  final now = (referenceDate ?? DateTime.now()).toLocal();
  final difference = now.difference(localDate).abs();

  if (difference < const Duration(minutes: 1)) return 'Just now';

  final jiffyDate = Jiffy.parseFromDateTime(localDate);
  final time = jiffyDate.format(pattern: 'H:mm');

  if (_isSameDay(localDate, now)) {
    return '${context.translations.todayLabel} at $time';
  }

  final yesterday = now.subtract(const Duration(days: 1));
  if (_isSameDay(localDate, yesterday)) {
    return '${context.translations.yesterdayLabel} at $time';
  }

  if (_isWithinPreviousWeek(localDate, now)) {
    return '${jiffyDate.EEEE} at $time';
  }

  return '${jiffyDate.format(pattern: 'MMM do')} at $time';
}

bool _isSameDay(DateTime a, DateTime b) {
  final jiffyA = Jiffy.parseFromDateTime(a);
  final jiffyB = Jiffy.parseFromDateTime(b);
  return jiffyA.isSame(jiffyB, unit: Unit.day);
}

bool _isWithinPreviousWeek(DateTime date, DateTime referenceDate) {
  final jiffyDate = Jiffy.parseFromDateTime(date);
  final jiffyReference = Jiffy.parseFromDateTime(referenceDate);
  return jiffyDate.isAfter(jiffyReference.subtract(days: 7), unit: Unit.day);
}

/// Extension on [DateTime] to provide common date comparison utilities.
extension DateTimeComparisonUtils on DateTime {
  /// Returns true if the date is today.
  bool get isToday {
    final jiffyDate = Jiffy.parseFromDateTime(this);
    final jiffyNow = Jiffy.parseFromDateTime(DateTime.now());

    return jiffyDate.isSame(jiffyNow, unit: Unit.day);
  }

  /// Returns true if the date was yesterday.
  bool get isYesterday {
    final jiffyDate = Jiffy.parseFromDateTime(this);
    final jiffyNow = Jiffy.parseFromDateTime(DateTime.now());

    return jiffyDate.isSame(jiffyNow.subtract(days: 1), unit: Unit.day);
  }

  /// Returns true if the date is within the last 7 days.
  bool get isWithinAWeek {
    final jiffyDate = Jiffy.parseFromDateTime(this);
    final jiffyNow = Jiffy.parseFromDateTime(DateTime.now());

    return jiffyDate.isAfter(jiffyNow.subtract(days: 7), unit: Unit.day);
  }

  /// Returns true if the date is within the current year.
  bool get isWithinAYear => year == DateTime.now().year;
}
