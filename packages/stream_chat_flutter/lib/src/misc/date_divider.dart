import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/custom_theme/unikon_theme.dart';
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
    final createdAt = Jiffy.parseFromDateTime(dateTime);
    final now = Jiffy.parseFromDateTime(DateTime.now());

    var dayInfo = createdAt.MMMd;
    if (createdAt.isSame(now, unit: Unit.day)) {
      dayInfo = context.translations.todayLabel;
    } else if (createdAt.isSame(now.subtract(days: 1), unit: Unit.day)) {
      dayInfo = context.translations.yesterdayLabel;
    } else if (createdAt.isAfter(now.subtract(days: 7), unit: Unit.day)) {
      dayInfo = createdAt.EEEE;
    } else if (createdAt.isAfter(now.subtract(years: 1), unit: Unit.day)) {
      dayInfo = createdAt.MMMd;
    }

    if (uppercase) dayInfo = dayInfo.toUpperCase();

    final chatThemeData = StreamChatTheme.of(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        decoration: BoxDecoration(
          color: UnikonColorTheme.darkGreyColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          dayInfo,
          style: chatThemeData.textTheme.footnote.copyWith(
            color: UnikonColorTheme.greyColor,
          ),
        ),
      ),
    );
  }
}
