import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

/// It shows a date divider depending on the date difference
class DateDivider extends StatelessWidget {
  /// Constructor for creating a [DateDivider]
  const DateDivider({
    Key? key,
    required this.dateTime,
    this.uppercase = false,
  }) : super(key: key);

  /// [DateTime] to display
  final DateTime dateTime;

  /// If text is uppercase
  final bool uppercase;

  @override
  Widget build(BuildContext context) {
    final createdAt = Jiffy(dateTime);
    final now = DateTime.now();

    String dayInfo;
    if (Jiffy(createdAt).isSame(now, Units.DAY)) {
      dayInfo = 'Today';
    } else if (Jiffy(createdAt)
        .isSame(now.subtract(const Duration(days: 1)), Units.DAY)) {
      dayInfo = 'Yesterday';
    } else if (Jiffy(createdAt).isAfter(
      now.subtract(const Duration(days: 7)),
      Units.DAY,
    )) {
      dayInfo = createdAt.EEEE;
    } else if (Jiffy(createdAt).isAfter(
      Jiffy(now).subtract(years: 1),
      Units.DAY,
    )) {
      dayInfo = createdAt.MMMd;
    } else {
      dayInfo = createdAt.MMMd;
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
            color: chatThemeData.colorTheme.white,
          ),
        ),
      ),
    );
  }
}
