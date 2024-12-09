import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_options_list_view.dart';
import 'package:stream_chat_flutter/src/theme/poll_options_dialog_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template showStreamPollOptionsDialog}
/// Displays an interactive dialog to show all the available options for a poll.
///
/// The dialog allows the user to cast a vote or remove a vote.
/// {@endtemplate}
Future<T?> showStreamPollOptionsDialog<T extends Object?>({
  required BuildContext context,
  required ValueListenable<Message> messageNotifier,
}) {
  final navigator = Navigator.of(context);
  return navigator.push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: messageNotifier,
          builder: (context, message, child) {
            final poll = message.poll;
            if (poll == null) return const SizedBox.shrink();

            final channel = StreamChannel.of(context).channel;

            void onCastVote(PollOption option) {
              channel.castPollVote(message, poll, option);
            }

            void onRemoveVote(PollVote vote) {
              channel.removePollVote(message, poll, vote);
            }

            return StreamPollOptionsDialog(
              poll: poll,
              onCastVote: onCastVote,
              onRemoveVote: onRemoveVote,
            );
          },
        );
      },
    ),
  );
}

/// {@template streamPollOptionsDialog}
/// A dialog that displays all the available options for a poll.
///
/// Provides callbacks when a vote has been cast or removed from the poll.
/// {@endtemplate}
class StreamPollOptionsDialog extends StatelessWidget {
  /// {@macro streamPollOptionsDialog}
  const StreamPollOptionsDialog({
    super.key,
    required this.poll,
    this.onCastVote,
    this.onRemoveVote,
  });

  /// The poll to display the options for.
  final Poll poll;

  /// Callback invoked when the user wants to cast a vote.
  ///
  /// The [PollOption] parameter is the option the user wants to vote for.
  final ValueChanged<PollOption>? onCastVote;

  /// Callback invoked when the user wants to remove a vote.
  ///
  /// The [PollVote] parameter is the vote the user wants to remove.
  final ValueChanged<PollVote>? onRemoveVote;

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollOptionsDialogTheme.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        elevation: theme.appBarElevation,
        backgroundColor: theme.appBarBackgroundColor,
        title: Text(
          context.translations.pollOptionsLabel,
          style: theme.appBarTitleTextStyle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          PollOptionsQuestion(
            question: poll.name,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            decoration: theme.pollOptionsListViewDecoration,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              removeBottom: true,
              child: PollOptionsListView(
                poll: poll,
                onCastVote: onCastVote,
                onRemoveVote: onRemoveVote,
              ),
            ),
          ),
        ].insertBetween(const SizedBox(height: 32)),
      ),
    );
  }
}

/// {@template pollOptionsQuestion}
/// A widget that displays the question of a poll.
/// {@endtemplate}
class PollOptionsQuestion extends StatelessWidget {
  /// {@macro pollOptionsQuestion}
  const PollOptionsQuestion({
    super.key,
    required this.question,
  });

  /// The question of the poll.
  final String question;

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollOptionsDialogTheme.of(context);

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
