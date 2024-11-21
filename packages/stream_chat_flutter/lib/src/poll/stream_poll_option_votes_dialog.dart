import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/scroll_view/poll_vote_scroll_view/stream_poll_vote_list_view.dart';
import 'package:stream_chat_flutter/src/theme/poll_creator_theme.dart';
import 'package:stream_chat_flutter/src/theme/poll_option_votes_dialog_theme.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template showStreamPollOptionVotesDialog}
/// Displays an interactive dialog to show all the votes for a poll option.
///
/// The votes are paginated and get's loaded as the user scrolls.
/// {@endtemplate}
Future<T?> showStreamPollOptionVotesDialog<T extends Object?>({
  required BuildContext context,
  required ValueListenable<Message> messageNotifier,
  required PollOption option,
}) {
  final navigator = Navigator.of(context);
  return navigator.push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => ValueListenableBuilder(
        valueListenable: messageNotifier,
        builder: (context, message, child) {
          final poll = message.poll;
          if (poll == null) return const SizedBox.shrink();
          if (option.id == null) return const SizedBox.shrink();

          return StreamPollOptionVotesDialog(
            poll: poll,
            option: option,
            pollVotesCount: poll.voteCountsByOption[option.id],
          );
        },
      ),
    ),
  );
}

/// {@template streamPollOptionVotesDialog}
/// A dialog that displays all the votes for a poll option.
///
/// The votes are paginated and get's loaded as the user scrolls.
/// {@endtemplate}
class StreamPollOptionVotesDialog extends StatefulWidget {
  /// {@macro streamPollOptionVotesDialog}
  const StreamPollOptionVotesDialog({
    super.key,
    required this.poll,
    required this.option,
    required this.pollVotesCount,
  });

  /// The poll for which the votes are being displayed.
  final Poll poll;

  /// The option for which the votes are being displayed.
  final PollOption option;

  /// The total number of votes for the option.
  final int? pollVotesCount;

  @override
  State<StreamPollOptionVotesDialog> createState() =>
      _StreamPollOptionVotesDialogState();
}

class _StreamPollOptionVotesDialogState
    extends State<StreamPollOptionVotesDialog> {
  late StreamPollVoteListController _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(covariant StreamPollOptionVotesDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.poll.id != widget.poll.id ||
        oldWidget.option.id != widget.option.id) {
      _controller.dispose(); // Dispose the old controller.
      _initializeController(); // Initialize a new controller.
    }
  }

  void _initializeController() {
    _controller = StreamPollVoteListController(
      pollId: widget.poll.id,
      channel: StreamChannel.of(context).channel,
      filter: Filter.equal('option_id', widget.option.id!),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollOptionVotesDialogTheme.of(context);

    final isOptionWinner = widget.poll.isOptionWithMaximumVotes(widget.option);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        elevation: theme.appBarElevation,
        backgroundColor: theme.appBarBackgroundColor,
        title: Text(
          widget.option.text,
          maxLines: 2,
          style: theme.appBarTitleTextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isOptionWinner) ...[
                  StreamSvgIcon.award(
                    color: theme.pollOptionWinnerVoteCountTextStyle?.color,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  context.translations.voteCountLabel(
                    count: widget.pollVotesCount,
                  ),
                  style: isOptionWinner
                      ? theme.pollOptionWinnerVoteCountTextStyle
                      : theme.pollOptionVoteCountTextStyle,
                ),
              ],
            ),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: StreamPollVoteListView(
                  controller: _controller,
                  itemBuilder: (context, _, __, defaultWidget) {
                    return defaultWidget.copyWith(
                      contentPadding: const EdgeInsets.all(16),
                      borderRadius: theme.pollOptionVoteItemBorderRadius,
                      tileColor: theme.pollOptionVoteItemBackgroundColor,
                    );
                  },
                ),
              ),
            ),
          ].insertBetween(const SizedBox(height: 16)),
        ),
      ),
    );
  }
}
