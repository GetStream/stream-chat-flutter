import 'package:flutter/material.dart';
import 'package:stream_core_flutter/chat.dart' as core;

import '../../stream_chat_flutter.dart';

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

    final localDate = dateTime.toLocal();

    return MergeSemantics(
      // A date divider separates the list by day, so it doubles as a landmark:
      // marking it a header lets a screen reader jump from day to day instead
      // of swiping through every message in between.
      child: Semantics(
        header: true,
        child: Center(
          child: Container(
            margin: effectiveMargin,
            decoration: BoxDecoration(
              color: effectiveBackgroundColor,
              borderRadius: effectiveBorderRadius,
            ),
            child: Padding(
              padding: effectiveContentPadding,
              child: StreamTimestamp(
                date: localDate,
                style: effectiveTextStyle,
                // The divider shows a date, never a clock time. Left to its
                // default, [StreamTimestamp] would announce
                // `formatRecentDateTime`'s "Yesterday at 1:06 PM" and invent a
                // time that is nowhere on screen. Announce the date as shown —
                // but never uppercased, which some screen readers spell out.
                semanticsLabel: _formatDate(context, localDate),
                formatter: (context, date) {
                  final timestamp = _formatDate(context, date);
                  if (uppercase) return timestamp.toUpperCase();
                  return timestamp;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // The visible date label: the caller's [formatter] when given, otherwise a
  // relative-day phrasing that degrades to an absolute date.
  String _formatDate(BuildContext context, DateTime date) {
    if (formatter case final formatter?) return formatter.call(context, date);

    return switch (date) {
      _ when date.isToday => context.translations.todayLabel,
      _ when date.isYesterday => context.translations.yesterdayLabel,
      _ when date.isWithinLastWeek => Jiffy.parseFromDateTime(date).EEEE,
      _ when date.isInSameYear => Jiffy.parseFromDateTime(date).MMMd,
      _ => Jiffy.parseFromDateTime(date).yMMMd,
    };
  }
}
