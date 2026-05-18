import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// {@template streamDateDivider}
/// A widget that displays a date label as a centered pill-shaped container.
///
/// [StreamDateDivider] renders a formatted date string (e.g. "Today",
/// "Yesterday", "Mon, Jun 2") used to visually separate messages by day in a
/// [StreamMessageListView].
///
/// {@tool snippet}
///
/// Display a date divider with default styling:
///
/// ```dart
/// StreamDateDivider(
///   dateTime: DateTime.now(),
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// Customise the appearance per-instance:
///
/// ```dart
/// StreamDateDivider(
///   dateTime: DateTime.now(),
///   uppercase: true,
///   backgroundColor: Colors.amber.shade50,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamMessageListView], which hosts date dividers in the chat list.
///  * [StreamSystemMessage], which displays system messages with a similar
///    pill style.
/// {@endtemplate}
class StreamDateDivider extends StatelessWidget {
  /// Creates a date divider widget.
  ///
  /// The [dateTime] is required. All other parameters are optional.
  const StreamDateDivider({
    super.key,
    required this.dateTime,
    this.uppercase = false,
    this.formatter,
    this.margin,
    this.contentPadding,
    this.textStyle,
    this.backgroundColor,
    this.borderRadius,
  });

  /// The date to display.
  final DateTime dateTime;

  /// Whether the formatted date text should be uppercased.
  ///
  /// Defaults to `false`.
  final bool uppercase;

  /// Custom formatter for the date.
  ///
  /// When non-null, overrides the default date formatting logic.
  final DateFormatter? formatter;

  /// Outer margin around the pill container.
  ///
  /// When non-null, takes precedence over the theme default.
  ///
  /// When null (the default), uses vertical [core.StreamSpacing.xs].
  final EdgeInsetsGeometry? margin;

  /// Inner padding inside the pill container.
  ///
  /// When non-null, takes precedence over the theme default.
  ///
  /// When null (the default), uses horizontal [core.StreamSpacing.xs] and
  /// vertical [core.StreamSpacing.xxs].
  final EdgeInsetsGeometry? contentPadding;

  /// Text style for the date label.
  ///
  /// When non-null, takes precedence over the theme default.
  ///
  /// When null (the default), uses [core.StreamTextTheme.metadataEmphasis]
  /// with [core.StreamColorScheme.textSecondary] as the text color.
  final TextStyle? textStyle;

  /// Background color of the pill container.
  ///
  /// When non-null, takes precedence over the theme default.
  ///
  /// When null (the default), uses
  /// [core.StreamColorScheme.backgroundSurfaceSubtle].
  final Color? backgroundColor;

  /// Border radius of the pill container.
  ///
  /// When non-null, takes precedence over the theme default.
  ///
  /// When null (the default), uses [core.StreamRadius.max].
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = context.streamRadius;
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    final effectiveMargin = margin ?? .symmetric(vertical: spacing.xs);
    final effectiveContentPadding = contentPadding ?? .symmetric(horizontal: spacing.xs, vertical: spacing.xxs);
    final effectiveTextStyle = textStyle ?? textTheme.metadataEmphasis.copyWith(color: colorScheme.textSecondary);
    final effectiveBackgroundColor = backgroundColor ?? colorScheme.backgroundSurfaceSubtle;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.all(radius.max);

    return Center(
      child: Container(
        margin: effectiveMargin,
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: effectiveBorderRadius,
        ),
        child: Padding(
          padding: effectiveContentPadding,
          child: StreamTimestamp(
            date: dateTime.toLocal(),
            style: effectiveTextStyle,
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
      ),
    );
  }
}
