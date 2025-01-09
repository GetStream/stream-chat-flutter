import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/date_formatter.dart';

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
    this.formatter = formatDate,
    this.style,
    this.textAlign,
    this.textDirection,
  });

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

  @override
  Widget build(BuildContext context) {
    return Text(
      formatter(context, date),
      maxLines: 1,
      style: style,
      textAlign: textAlign,
      textDirection: textDirection,
      overflow: TextOverflow.ellipsis,
    );
  }
}
