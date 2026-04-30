import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template showStreamPollResultsSheet}
/// Displays an interactive bottom sheet to show the results of a poll.
///
/// The sheet allows the user to see the results of the poll. The results are
/// displayed in a list of options with the number of votes each option has
/// received and the users who have voted for that option.
///
/// By default, only the first 5 votes are shown for each option. The user can
/// see all the votes for an option by pressing the "View all" footer button.
///
/// The sheet is updated in real-time as new votes are cast.
///
/// {@endtemplate}
Future<T?> showStreamPollResultsSheet<T extends Object?>({
  required BuildContext context,
  required ValueListenable<Message> messageNotifier,
}) {
  return showStreamSheet<T>(
    context: context,
    builder: (_, scrollController) => StreamChannel(
      channel: StreamChannel.of(context).channel,
      child: ValueListenableBuilder(
        valueListenable: messageNotifier,
        builder: (context, message, _) {
          final poll = message.poll;
          if (poll == null) return const Empty();

          void onShowAllVotesPressed(PollOption option) {
            showStreamPollOptionVotesSheet(
              context: context,
              messageNotifier: messageNotifier,
              option: option,
            );
          }

          return StreamPollResultsSheet(
            poll: poll,
            visibleVotesCount: 5,
            scrollController: scrollController,
            onShowAllVotesPressed: onShowAllVotesPressed,
          );
        },
      ),
    ),
  );
}

/// {@template streamPollResultsSheet}
/// A bottom sheet that displays the results of a poll.
///
/// The results are displayed in a list of options with the number of votes each
/// option has received and the users who have voted for that option.
///
/// By default, only the latest votes are shown for each option. The user can
/// see all the votes for an option by pressing the "View all" footer button.
///
/// The sheet is updated in real-time as new votes are cast.
/// {@endtemplate}
class StreamPollResultsSheet extends StatelessWidget {
  /// {@macro streamPollResultsSheet}
  const StreamPollResultsSheet({
    super.key,
    required this.poll,
    this.visibleVotesCount,
    this.scrollController,
    this.onShowAllVotesPressed,
  });

  /// The poll to display the results for.
  final Poll poll;

  /// The number of votes to show for each option.
  final int? visibleVotesCount;

  /// Scroll controller attached to the bottom sheet's scrollable content.
  ///
  /// Typically provided by [DraggableScrollableSheet] so the sheet expands and
  /// collapses in response to the user's scroll gesture.
  final ScrollController? scrollController;

  /// Callback invoked when the "View all" footer button is pressed.
  final ValueSetter<PollOption>? onShowAllVotesPressed;

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollResultsSheetTheme.of(context);
    final defaults = _StreamPollResultsSheetDefaults(context);

    final effectiveTheme = defaults.merge(theme);

    return Column(
      mainAxisSize: .min,
      children: [
        StreamSheetHeader(
          style: effectiveTheme.sheetHeaderStyle,
          title: Text(context.translations.pollResultsLabel),
        ),
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: effectiveTheme.contentPadding,
            children: <Widget>[
              PollResultsQuestion(question: poll.name),
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: PollVotesByOptionListView(
                  poll: poll,
                  visibleVotesCount: visibleVotesCount,
                  onShowAllVotesPressed: onShowAllVotesPressed,
                ),
              ),
              Center(
                child: Text(
                  context.translations.totalVoteCountLabel(count: poll.voteCount),
                  style: effectiveTheme.totalVoteCountTextStyle,
                ),
              ),
            ].insertBetween(SizedBox(height: effectiveTheme.sectionSpacing)),
          ),
        ),
      ],
    );
  }
}

/// {@template pollResultsQuestion}
/// A widget that displays the question of a poll.
///
/// Reads its styling from the ambient [StreamPollResultsSheetTheme].
/// {@endtemplate}
class PollResultsQuestion extends StatelessWidget {
  /// {@macro pollResultsQuestion}
  const PollResultsQuestion({
    super.key,
    required this.question,
  });

  /// The question of the poll.
  final String question;

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollResultsSheetTheme.of(context);
    final defaults = _StreamPollResultsSheetDefaults(context);

    final effectiveTheme = defaults.merge(theme);

    final questionStyle = effectiveTheme.questionStyle;
    final cardStyle = questionStyle?.cardStyle;

    final spacing = context.streamSpacing;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cardStyle?.backgroundColor,
        borderRadius: cardStyle?.borderRadius,
      ),
      child: Padding(
        padding: cardStyle?.padding ?? EdgeInsets.zero,
        child: Column(
          mainAxisSize: .min,
          spacing: spacing.xxs,
          crossAxisAlignment: .start,
          children: [
            Text(context.translations.questionLabel(), style: questionStyle?.headerTextStyle),
            Text(question, style: questionStyle?.textStyle),
          ],
        ),
      ),
    );
  }
}

/// {@template pollVotesByOptionListView}
/// A list of poll options with the latest votes for each option.
///
/// Displays a button with a callback [onShowAllVotesPressed] to show all votes
/// for an option if there are more votes than the [visibleVotesCount].
///
/// By default, the options are sorted by the number of votes they have
/// received in descending order.
/// {@endtemplate}
class PollVotesByOptionListView extends StatelessWidget {
  /// {@macro pollVotesByOptionListView}
  const PollVotesByOptionListView({
    super.key,
    required this.poll,
    this.visibleVotesCount,
    this.onShowAllVotesPressed,
  });

  /// The poll the options are for.
  final Poll poll;

  /// The number of votes to show for each option.
  ///
  /// If the number of votes for an option is greater than this value, a button
  /// is displayed to show all votes for that option.
  final int? visibleVotesCount;

  /// Callback invoked when the "View all" footer button is pressed.
  final ValueSetter<PollOption>? onShowAllVotesPressed;

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollResultsSheetTheme.of(context);
    final defaults = _StreamPollResultsSheetDefaults(context);

    final effectiveTheme = defaults.merge(theme);

    final pollOptions = poll.options;
    final latestVotesByOption = poll.latestVotesByOption;
    final voteCountsByOption = poll.voteCountsByOption;

    return ListView.separated(
      shrinkWrap: true,
      itemCount: pollOptions.length,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => SizedBox(height: effectiveTheme.optionsItemSpacing),
      itemBuilder: (context, index) {
        final option = pollOptions.elementAt(index);
        final latestPollVotes = latestVotesByOption[option.id] ?? [];
        final pollVotesCount = voteCountsByOption[option.id] ?? 0;

        return PollVotesByOptionItem(
          option: option,
          optionNumber: index + 1,
          pollVotesCount: pollVotesCount,
          latestPollVotes: latestPollVotes,
          visibleVotesCount: visibleVotesCount,
          isOptionWinner: poll.isOptionWithMaximumVotes(option),
          onShowAllVotesPressed: switch (onShowAllVotesPressed) {
            final onShowAllVotesPressed? => () => onShowAllVotesPressed(option),
            _ => null,
          },
        );
      },
    );
  }
}

/// {@template pollVotesByOptionItem}
/// A widget that displays the votes for a single poll option.
///
/// Used by [PollVotesByOptionListView] to render one result card per option.
/// Composes a [PollVotesByOptionHeader] (option number, option text, trailing
/// vote count, and — when [isOptionWinner] is true — a trophy icon) on top of
/// up to [visibleVotesCount] [StreamPollVoteListTile]s. When the option has
/// more votes than are being shown, a divider + "View all" button footer is
/// rendered that invokes [onShowAllVotesPressed].
///
/// Reads its styling from the ambient [StreamPollResultsSheetTheme] via
/// [StreamPollResultsSheetThemeData.optionStyle]:
///
///  * [StreamPollOptionVotesStyle.cardStyle] — card chrome (background,
///    corner radius, inner padding).
///  * The header text styles + winner icon color/size are consumed by the
///    nested [PollVotesByOptionHeader].
///  * [StreamPollOptionVotesStyle.footerDividerColor] +
///    [StreamPollOptionVotesStyle.footerButtonStyle] — applied to the divider
///    and "View all" button shown when `visibleVotesCount < pollVotesCount`.
/// {@endtemplate}
class PollVotesByOptionItem extends StatelessWidget {
  /// {@macro pollVotesByOptionItem}
  const PollVotesByOptionItem({
    super.key,
    required this.option,
    required this.optionNumber,
    required this.latestPollVotes,
    required this.pollVotesCount,
    this.isOptionWinner = false,
    this.visibleVotesCount,
    this.onShowAllVotesPressed,
  });

  /// The 1-based position of this option within the poll.
  ///
  /// Rendered as the section header (e.g. `Option 1`, `Option 2`).
  final int optionNumber;

  /// The option to display the votes for.
  final PollOption option;

  /// The available latest votes for the option.
  final List<PollVote> latestPollVotes;

  /// The total number of votes for the option.
  final int pollVotesCount;

  /// Whether the option is the winner of the poll.
  final bool isOptionWinner;

  /// The number of votes to show for the option.
  ///
  /// If this is less than the [pollVotesCount] a button is displayed to show
  /// all votes for the option.
  final int? visibleVotesCount;

  /// Callback invoked when the "View all" footer button is pressed.
  final VoidCallback? onShowAllVotesPressed;

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollResultsSheetTheme.of(context);
    final defaults = _StreamPollResultsSheetDefaults(context);

    final effectiveTheme = defaults.merge(theme);

    final optionStyle = effectiveTheme.optionStyle;
    final cardStyle = optionStyle?.cardStyle;

    final spacing = context.streamSpacing;

    final votes = switch (visibleVotesCount) {
      final visibleVotesCount? => latestPollVotes.take(visibleVotesCount),
      _ => latestPollVotes,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cardStyle?.backgroundColor,
        borderRadius: cardStyle?.borderRadius,
      ),
      child: Column(
        mainAxisSize: .min,
        children: [
          Padding(
            padding: cardStyle?.padding ?? .zero,
            child: Column(
              spacing: spacing.md,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                PollVotesByOptionHeader(
                  option: option,
                  optionNumber: optionNumber,
                  pollVotesCount: pollVotesCount,
                  isOptionWinner: isOptionWinner,
                  optionStyle: optionStyle,
                ),
                if (votes.isNotEmpty)
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: votes.length,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => SizedBox(height: spacing.md),
                      itemBuilder: (context, index) {
                        final pollVote = votes.elementAt(index);
                        return StreamPollVoteListTile(pollVote: pollVote);
                      },
                    ),
                  ),
              ],
            ),
          ),
          if (votes.length < latestPollVotes.length) ...[
            Divider(height: 1, color: optionStyle?.footerDividerColor),
            StreamButton(
              size: .small,
              type: .ghost,
              style: .secondary,
              onPressed: onShowAllVotesPressed,
              themeStyle: optionStyle?.footerButtonStyle,
              child: Text(context.translations.viewAllLabel),
            ),
          ],
        ],
      ),
    );
  }
}

/// {@template pollVotesByOptionHeader}
/// Renders the header strip of a per-option result card inside
/// [PollVotesByOptionItem].
///
/// Composes the `"Option N"` label, the option body text, the trailing vote
/// count, and — when [isOptionWinner] is true — the trophy icon next to the
/// vote count.
///
/// By default, reads its styling (text styles, winner icon color + size)
/// from the ambient [StreamPollResultsSheetTheme] via
/// [StreamPollResultsSheetThemeData.optionStyle]. Callers embedding this
/// header outside the results sheet (e.g. [StreamPollOptionVotesSheet])
/// can pass an explicit [optionStyle] to inject their own resolved style.
/// {@endtemplate}
class PollVotesByOptionHeader extends StatelessWidget {
  /// {@macro pollVotesByOptionHeader}
  const PollVotesByOptionHeader({
    super.key,
    required this.option,
    required this.optionNumber,
    required this.pollVotesCount,
    this.isOptionWinner = false,
    this.optionStyle,
  });

  /// The option this header describes.
  final PollOption option;

  /// The 1-based position of this option within the poll, shown as the
  /// `"Option N"` label.
  final int optionNumber;

  /// The total number of votes for [option], rendered as the trailing vote
  /// count (e.g. `"12 votes"`).
  final int pollVotesCount;

  /// Whether [option] is the current winner of the poll.
  ///
  /// When true, a trophy icon is rendered next to the vote count.
  final bool isOptionWinner;

  /// Explicit per-option style used to paint this header.
  ///
  /// When null, the style is resolved from the ambient
  /// [StreamPollResultsSheetTheme]. Sheets that embed this header but
  /// consume a different ambient theme (e.g. [StreamPollOptionVotesSheet])
  /// pass in their own resolved style so the header matches the owning
  /// sheet's theme.
  final StreamPollOptionVotesStyle? optionStyle;

  @override
  Widget build(BuildContext context) {
    final StreamPollOptionVotesStyle? style;
    if (optionStyle != null) {
      style = optionStyle;
    } else {
      final theme = StreamPollResultsSheetTheme.of(context);
      final defaults = _StreamPollResultsSheetDefaults(context);
      style = defaults.merge(theme).optionStyle;
    }

    final spacing = context.streamSpacing;

    return Column(
      mainAxisSize: .min,
      spacing: spacing.xxs,
      crossAxisAlignment: .start,
      children: [
        Text(
          '${context.translations.optionLabel()} $optionNumber',
          style: style?.numberTextStyle,
        ),
        Row(
          mainAxisSize: .min,
          spacing: spacing.md,
          children: [
            Expanded(
              child: Text(
                option.text,
                style: style?.textStyle,
              ),
            ),
            Row(
              mainAxisSize: .min,
              spacing: spacing.xs,
              children: [
                if (isOptionWinner) ...[
                  Icon(
                    context.streamIcons.trophy,
                    size: style?.winnerIconSize,
                    color: style?.winnerIconColor,
                  ),
                ],
                Text(
                  context.translations.voteCountLabel(count: pollVotesCount),
                  style: style?.voteCountTextStyle,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// Default values for [StreamPollResultsSheetThemeData] backed by stream
// design tokens.
class _StreamPollResultsSheetDefaults extends StreamPollResultsSheetThemeData {
  _StreamPollResultsSheetDefaults(this._context);

  final BuildContext _context;

  late final _spacing = _context.streamSpacing;
  late final _radius = _context.streamRadius;
  late final _colorScheme = _context.streamColorScheme;
  late final _textTheme = _context.streamTextTheme;

  @override
  Color get backgroundColor => _colorScheme.backgroundApp;

  @override
  EdgeInsetsGeometry get contentPadding => .directional(
    start: _spacing.md,
    end: _spacing.md,
    top: _spacing.md,
    bottom: _spacing.xxxl,
  );

  @override
  double get sectionSpacing => _spacing.xxl;

  @override
  double get optionsItemSpacing => _spacing.md;

  @override
  StreamPollQuestionStyle get questionStyle => StreamPollQuestionStyle(
    cardStyle: StreamPollCardStyle(
      backgroundColor: _colorScheme.backgroundSurfaceCard,
      borderRadius: BorderRadius.all(_radius.lg),
      padding: EdgeInsets.all(_spacing.md),
    ),
    headerTextStyle: _textTheme.headingXs.copyWith(color: _colorScheme.textTertiary),
    textStyle: _textTheme.headingMd.copyWith(color: _colorScheme.textPrimary),
  );

  @override
  StreamPollOptionVotesStyle get optionStyle => StreamPollOptionVotesStyle(
    cardStyle: StreamPollCardStyle(
      backgroundColor: _colorScheme.backgroundSurfaceCard,
      borderRadius: BorderRadius.all(_radius.lg),
      padding: EdgeInsets.all(_spacing.md),
    ),
    numberTextStyle: _textTheme.headingXs.copyWith(color: _colorScheme.textTertiary),
    textStyle: _textTheme.headingMd.copyWith(color: _colorScheme.textPrimary),
    voteCountTextStyle: _textTheme.bodyEmphasis.copyWith(color: _colorScheme.textPrimary),
    winnerIconColor: _colorScheme.textSecondary,
    winnerIconSize: 20,
    footerDividerColor: _colorScheme.borderDefault,
  );

  @override
  TextStyle get totalVoteCountTextStyle => _textTheme.bodyDefault.copyWith(color: _colorScheme.textPrimary);
}
