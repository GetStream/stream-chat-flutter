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
    // Formatted once and reused by both the visible label and the
    // announcement. [StreamTimestamp] has no ticker, so `date` cannot change
    // under the closure.
    final label = _formatDate(context, localDate);

    // A date divider separates the list by day, so it doubles as a landmark:
    // marking it a header lets a screen reader jump from day to day instead of
    // swiping through every message in between. `container: true` makes the
    // divider its own node rather than merging upward into the list.
    return Semantics(
      header: true,
      container: true,
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
              // A screen-reader label is allowed to be more explicit than the
              // text it describes, and here it has to be: the visible label
              // abbreviates to "Wednesday" or "Aug 26", neither of which says
              // which Wednesday or which year. It must not pick up
              // [StreamTimestamp]'s default either — `formatRecentDateTime`
              // would announce "Yesterday at 1:06 PM" and invent a clock time
              // the divider never shows. So: the full date, never abbreviated,
              // never uppercased (some screen readers spell that out).
              semanticsLabel: _formatDateForSemantics(context, localDate),
              formatter: (context, date) => uppercase ? label.toUpperCase() : label,
            ),
          ),
        ),
      ),
    );
  }

  // The announced date: the relative day where there is one, always paired
  // with the full date behind it — "Today, 26 August 2026", "26 August 2026".
  //
  // A caller's [formatter] is deliberately not consulted. It exists to fit a
  // date into the divider's width, and the abbreviations it produces are the
  // problem being solved here.
  String _formatDateForSemantics(BuildContext context, DateTime date) {
    final fullDate = Jiffy.parseFromDateTime(date).yMMMMd;

    final relativeDay = switch (date) {
      _ when date.isToday => context.translations.todayLabel,
      _ when date.isYesterday => context.translations.yesterdayLabel,
      _ => null,
    };

    return switch (relativeDay) {
      final day? => '$day, $fullDate',
      null => fullDate,
    };
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
