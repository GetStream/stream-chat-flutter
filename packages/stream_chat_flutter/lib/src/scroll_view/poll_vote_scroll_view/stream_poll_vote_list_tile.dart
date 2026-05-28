import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamPollVoteListTile}
/// A widget that displays a poll vote in a list tile.
///
/// Used in [StreamPollVoteListView] as a list tile for each poll vote.
/// {@endtemplate}
class StreamPollVoteListTile extends StatelessWidget {
  /// {@macro streamPollVoteListTile}
  const StreamPollVoteListTile({
    super.key,
    required this.pollVote,
    this.showAnswerText = false,
    this.onTap,
    this.onLongPress,
    this.tileColor,
    this.borderRadius,
    this.contentPadding,
  });

  /// The poll vote to display the tile for.
  final PollVote pollVote;

  /// Whether to show the answer text.
  final bool showAnswerText;

  /// Called when the user taps this list tile.
  final GestureTapCallback? onTap;

  /// Called when the user long-presses on this list tile.
  final GestureLongPressCallback? onLongPress;

  /// Defines the background color of the tile.
  final Color? tileColor;

  /// The tile's border radius.
  final BorderRadiusGeometry? borderRadius;

  /// The tile's internal padding.
  final EdgeInsetsGeometry? contentPadding;

  /// Creates a copy of this tile but with the given fields replaced with
  /// the new values.
  StreamPollVoteListTile copyWith({
    Key? key,
    PollVote? pollVote,
    bool? showAnswerText,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
    Color? tileColor,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? contentPadding,
  }) => StreamPollVoteListTile(
    key: key ?? this.key,
    pollVote: pollVote ?? this.pollVote,
    showAnswerText: showAnswerText ?? this.showAnswerText,
    onTap: onTap ?? this.onTap,
    onLongPress: onLongPress ?? this.onLongPress,
    tileColor: tileColor ?? this.tileColor,
    borderRadius: borderRadius ?? this.borderRadius,
    contentPadding: contentPadding ?? this.contentPadding,
  );

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: contentPadding,
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          spacing: spacing.xs,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (pollVote.answerText case final answerText? when showAnswerText) ...[
              Text(
                answerText,
                style: textTheme.bodyDefault.copyWith(color: colorScheme.textPrimary),
              ),
            ],
            Row(
              spacing: spacing.sm,
              children: [
                if (pollVote.user case final user?) ...[
                  StreamUserAvatar(
                    size: .md,
                    user: user,
                    showOnlineIndicator: false,
                  ),
                  Expanded(
                    child: Text(
                      user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyDefault.copyWith(color: colorScheme.textPrimary),
                    ),
                  ),
                ],
                PollVoteUpdatedAt(
                  dateTime: pollVote.updatedAt.toLocal(),
                  textStyle: textTheme.bodyDefault.copyWith(color: colorScheme.textTertiary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// {@template pollVoteUpdatedAt}
/// A widget that displays the last updated time of a poll vote.
/// {@endtemplate}
class PollVoteUpdatedAt extends StatelessWidget {
  /// {@macro pollVoteUpdatedAt}
  const PollVoteUpdatedAt({
    super.key,
    required this.dateTime,
    this.textStyle,
  });

  /// The date and time when the poll vote was last updated.
  final DateTime dateTime;

  /// The text style to use for the timestamp.
  ///
  /// If null, defaults to the theme's body text style with low emphasis color.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return StreamTimestamp(
      date: dateTime,
      style: textStyle,
      formatter: (context, date) {
        if (date.isToday) return context.translations.todayLabel;
        if (date.isYesterday) return context.translations.yesterdayLabel;
        if (date.isWithinLastWeek) return Jiffy.parseFromDateTime(date).EEEE;
        if (date.isInSameYear) return Jiffy.parseFromDateTime(date).MMMd;

        return Jiffy.parseFromDateTime(date).yMMMd;
      },
    );
  }
}
