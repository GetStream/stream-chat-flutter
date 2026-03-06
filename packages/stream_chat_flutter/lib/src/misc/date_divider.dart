import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/timestamp.dart';
import 'package:stream_chat_flutter/src/utils/date_formatter.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamDateDivider}
/// Shows a date divider depending on the date difference
/// {@endtemplate}
class StreamDateDivider extends StatelessWidget {
  /// {@macro streamDateDivider}
  const StreamDateDivider({
    super.key,
    required this.dateTime,
    this.uppercase = false,
    this.formatter,
  });

  /// [DateTime] to display
  final DateTime dateTime;

  /// If text is uppercase
  final bool uppercase;

  /// Custom formatter for the date
  final DateFormatter? formatter;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        decoration: BoxDecoration(
          color: colorScheme.backgroundSurfaceSubtle,
          borderRadius: BorderRadius.circular(8),
        ),
        child: StreamTimestamp(
          date: dateTime.toLocal(),
          style: textTheme.metadataEmphasis.copyWith(color: colorScheme.textSecondary),
          formatter: (context, date) {
            if (formatter case final formatter?) {
              final timestamp = formatter.call(context, date);
              if (uppercase) return timestamp.toUpperCase();
              return timestamp;
            }

            final timestamp = switch (date) {
              _ when date.isToday => context.translations.todayLabel,
              _ when date.isYesterday => context.translations.yesterdayLabel,
              _ when date.isWithinAWeek => Jiffy.parseFromDateTime(date).EEEE,
              _ when date.isWithinAYear => Jiffy.parseFromDateTime(date).MMMd,
              _ => Jiffy.parseFromDateTime(date).yMMMd,
            };

            if (uppercase) return timestamp.toUpperCase();
            return timestamp;
          },
        ),
      ),
    );
  }
}
