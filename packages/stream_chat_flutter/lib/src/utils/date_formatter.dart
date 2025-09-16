import 'package:flutter/cupertino.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';

/// Represents a function type that formats a date.
typedef DateFormatter = String Function(
  BuildContext context,
  DateTime date,
);

/// Formats the given [date] as a String.
String formatDate(BuildContext context, DateTime date) {
  if (date.isToday) return Jiffy.parseFromDateTime(date).jm;
  if (date.isYesterday) return context.translations.yesterdayLabel;
  if (date.isWithinAWeek) return Jiffy.parseFromDateTime(date).EEEE;

  return Jiffy.parseFromDateTime(date).yMd;
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
