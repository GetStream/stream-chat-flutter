import 'package:flutter/material.dart';
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
  });

  /// [DateTime] to display
  final DateTime dateTime;

  /// If text is uppercase
  final bool uppercase;

  @override
  Widget build(BuildContext context) {
    final createdAt = dateTime;
    final now = DateTime.now();

    var dayInfo = createdAt.format(pattern: 'MMMd');
    if (createdAt.isSame(now, unit: Unit.day)) {
      dayInfo = context.translations.todayLabel;
    } else if (createdAt.isSame(now.remove(days: 1), unit: Unit.day)) {
      dayInfo = context.translations.yesterdayLabel;
    } else if (createdAt.isAfterDate(now.remove(days: 7), unit: Unit.day)) {
      dayInfo = createdAt.format(pattern: 'EEEE');
    } else if (createdAt.isAfterDate(now.remove(years: 1), unit: Unit.day)) {
      dayInfo = createdAt.format(pattern: 'MMMd');
    }

    if (uppercase) dayInfo = dayInfo.toUpperCase();

    final chatThemeData = StreamChatTheme.of(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        decoration: BoxDecoration(
          color: chatThemeData.colorTheme.overlayDark,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          dayInfo,
          style: chatThemeData.textTheme.footnote.copyWith(
            color: chatThemeData.colorTheme.barsBg,
          ),
        ),
      ),
    );
  }
}
