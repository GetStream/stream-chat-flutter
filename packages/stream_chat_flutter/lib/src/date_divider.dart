import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

/// {@macro date_divider}
@Deprecated("Use 'StreamDateDivider' instead")
typedef DateDivider = StreamDateDivider;

/// {@template date_divider}
/// It shows a date divider depending on the date difference
/// {@endtemplate}
class StreamDateDivider extends StatelessWidget {
  /// Constructor for creating a [StreamDateDivider]
  const StreamDateDivider({
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
    final now = Jiffy(DateTime.now());

    var dayInfo = createdAt.MMMd;
    if (createdAt.isSame(now, Units.DAY)) {
      dayInfo = context.translations.todayLabel;
    } else if (createdAt.isSame(now.subtract(days: 1), Units.DAY)) {
      dayInfo = context.translations.yesterdayLabel;
    } else if (createdAt.isAfter(now.subtract(days: 7), Units.DAY)) {
      dayInfo = createdAt.EEEE;
    } else if (createdAt.isAfter(now.subtract(years: 1), Units.DAY)) {
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
            color: chatThemeData.colorTheme.barsBg,
          ),
        ),
      ),
    );
  }
}
