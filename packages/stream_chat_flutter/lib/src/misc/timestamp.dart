import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamTimestamp}
/// Represents a timestamp, that's used primarily for showing the time of a
/// message.
///
/// This widget uses the [formatDate] function to format the date to a String.
/// {@endtemplate}
class StreamTimestamp extends StatelessWidget {
  /// {@macro streamTimestamp}
  const StreamTimestamp({
    super.key,
    required this.date,
    DateFormatter? formatter,
    this.style,
    this.textAlign,
    this.textDirection,
    this.semanticsLabel,
  }) : formatter = formatter ?? formatDate;

  /// The date to show in the timestamp.
  final DateTime date;

  /// The formatter that's used to format the date to a String.
  final DateFormatter formatter;

  /// The style to apply to the text.
  final TextStyle? style;

  /// The alignment of the text.
  final TextAlign? textAlign;

  /// The direction of the text.
  final TextDirection? textDirection;

  /// Screen-reader label for the timestamp.
  ///
  /// When null (the default), a bucketed natural-language phrasing is used
  /// via [AccessibilityTranslations.formatRecentDateTime], so screen readers
  /// get a clear time reference even when the visible text is abbreviated
  /// (`"2h"`, `"Sat"`, `"1/15"`). When non-null, the given string is used
  /// verbatim.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final a11y = context.translations.accessibility;
    final semanticsLabel = this.semanticsLabel ?? a11y.formatRecentDateTime(date);

    return Text(
      formatter(context, date),
      maxLines: 1,
      style: style,
      textAlign: textAlign,
      textDirection: textDirection,
      overflow: TextOverflow.ellipsis,
      semanticsLabel: semanticsLabel,
    );
  }
}
