import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/poll/stream_poll_option_votes_dialog.dart';
import 'package:stream_chat_flutter/src/scroll_view/poll_vote_scroll_view/stream_poll_vote_list_tile.dart';
import 'package:stream_chat_flutter/src/theme/poll_results_dialog_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template showStreamPollResultsDialog}
/// Displays an interactive dialog to show the results of a poll.
///
/// The dialog allows the user to see the results of the poll. The results are
/// displayed in a list of options with the number of votes each option has
/// received and the users who have voted for that option.
///
/// By default, only the first 5 votes are shown for each option. The user can
/// see all the votes for an option by pressing the "Show all votes" button.
///
/// The dialog is updated in real-time as new votes are cast.
///
/// {@endtemplate}
Future<T?> showStreamPollResultsDialog<T extends Object?>({
  required BuildContext context,
  required ValueListenable<Message> messageNotifier,
}) {
  final navigator = Navigator.of(context);
  return navigator.push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => StreamChannel(
        channel: StreamChannel.of(context).channel,
        child: ValueListenableBuilder(
          valueListenable: messageNotifier,
          builder: (context, message, child) {
            final poll = message.poll;
            if (poll == null) return const Empty();

            void onShowAllVotesPressed(PollOption option) {
              showStreamPollOptionVotesDialog(
                context: context,
                messageNotifier: messageNotifier,
                option: option,
              );
            }

            return StreamPollResultsDialog(
              poll: poll,
              visibleVotesCount: 5,
              onShowAllVotesPressed: onShowAllVotesPressed,
            );
          },
        ),
      ),
    ),
  );
}

/// {@template streamPollResultsDialog}
/// A dialog that displays the results of a poll.
///
/// The results are displayed in a list of options with the number of votes each
/// option has received and the users who have voted for that option.
///
/// By default, only the latest votes are shown for each option. The user can
/// see all the votes for an option by pressing the "Show all votes" button.
///
/// The dialog is updated in real-time as new votes are cast.
/// {@endtemplate}
class StreamPollResultsDialog extends StatelessWidget {
  /// {@macro streamPollResultsDialog}
  const StreamPollResultsDialog({
    super.key,
    required this.poll,
    this.visibleVotesCount,
    this.onShowAllVotesPressed,
  });

  /// The poll to display the results for.
  final Poll poll;

  /// The number of votes to show for each option.
  final int? visibleVotesCount;

  /// Callback invoked when the "Show all votes" button is pressed.
  final ValueSetter<PollOption>? onShowAllVotesPressed;

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollResultsDialogTheme.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        elevation: theme.appBarElevation,
        backgroundColor: theme.appBarBackgroundColor,
        title: Text(
          context.translations.pollResultsLabel,
          style: theme.appBarTitleTextStyle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          PollResultsQuestion(question: poll.name),
          PollVotesByOptionListView(
            poll: poll,
            visibleVotesCount: visibleVotesCount,
            onShowAllVotesPressed: onShowAllVotesPressed,
          ),
        ].insertBetween(const SizedBox(height: 32)),
      ),
    );
  }
}

/// {@template pollResultsQuestion}
/// A widget that displays the question of a poll.
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
    final theme = StreamPollResultsDialogTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: theme.pollTitleDecoration,
      constraints: const BoxConstraints(
        minHeight: 56,
        minWidth: double.infinity,
      ),
      child: Text(
        question,
        style: theme.pollTitleTextStyle,
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
/// By default, The options are sorted by the number of votes they have
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

  /// Callback invoked when the "Show all votes" button is pressed.
  final ValueSetter<PollOption>? onShowAllVotesPressed;

  @override
  Widget build(BuildContext context) {
    final latestVotesByOption = poll.latestVotesByOption;
    final voteCountsByOption = poll.voteCountsByOption;
    final pollOptions = poll.options.sorted((a, b) {
      final optionAVoteCounts = voteCountsByOption[a.id] ?? 0;
      final optionBVoteCounts = voteCountsByOption[b.id] ?? 0;
      return optionBVoteCounts.compareTo(optionAVoteCounts);
    });

    return ListView.separated(
      shrinkWrap: true,
      itemCount: pollOptions.length,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final option = pollOptions.elementAt(index);
        final latestPollVotes = latestVotesByOption[option.id] ?? [];
        final pollVotesCount = voteCountsByOption[option.id] ?? 0;

        return PollVotesByOptionItem(
          option: option,
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
/// A widget that displays the votes for a poll option.
///
/// The widget is used in [PollVotesByOptionListView] to display the votes for
/// each option in a poll.
///
/// Displays a award icon next to the option if [isOptionWinner] is true.
/// {@endtemplate}
class PollVotesByOptionItem extends StatelessWidget {
  /// {@macro pollVotesByOptionItem}
  const PollVotesByOptionItem({
    super.key,
    required this.option,
    required this.latestPollVotes,
    required this.pollVotesCount,
    this.isOptionWinner = false,
    this.visibleVotesCount,
    this.onShowAllVotesPressed,
  });

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

  /// Callback invoked when the "Show all votes" button is pressed.
  final VoidCallback? onShowAllVotesPressed;

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollResultsDialogTheme.of(context);

    final votes = switch (visibleVotesCount) {
      final visibleVotesCount? => latestPollVotes.take(visibleVotesCount),
      _ => latestPollVotes,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      decoration: isOptionWinner
          ? theme.pollOptionsWinnerDecoration
          : theme.pollOptionsDecoration,
      child: Column(
        spacing: 16,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Text(
                  option.text,
                  style: isOptionWinner
                      ? theme.pollOptionsWinnerTextStyle
                      : theme.pollOptionsTextStyle,
                ),
              ),
              const SizedBox(width: 8),
              if (isOptionWinner) ...[
                StreamSvgIcon(
                  icon: StreamSvgIcons.award,
                  color: theme.pollOptionsWinnerVoteCountTextStyle?.color,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                context.translations.voteCountLabel(count: pollVotesCount),
                style: isOptionWinner
                    ? theme.pollOptionsWinnerVoteCountTextStyle
                    : theme.pollOptionsVoteCountTextStyle,
              ),
            ],
          ),
          if (votes.isNotEmpty)
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: votes.length,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final pollVote = votes.elementAt(index);
                  return StreamPollVoteListTile(
                    pollVote: pollVote,
                    contentPadding: const EdgeInsets.symmetric(vertical: 6),
                  );
                },
              ),
            ),
          if (votes.length < latestPollVotes.length)
            TextButton(
              onPressed: onShowAllVotesPressed,
              style: theme.pollOptionsShowAllVotesButtonStyle,
              child: Text(
                context.translations.showAllVotesLabel(count: pollVotesCount),
              ),
            ),
        ],
      ),
    );
  }
}
