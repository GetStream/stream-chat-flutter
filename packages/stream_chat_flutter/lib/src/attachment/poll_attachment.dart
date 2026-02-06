import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_add_comment_dialog.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_end_vote_dialog.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_suggest_option_dialog.dart';
import 'package:stream_chat_flutter/src/poll/interactor/stream_poll_interactor.dart';
import 'package:stream_chat_flutter/src/poll/stream_poll_comments_dialog.dart';
import 'package:stream_chat_flutter/src/poll/stream_poll_options_dialog.dart';
import 'package:stream_chat_flutter/src/poll/stream_poll_results_dialog.dart';
import 'package:stream_chat_flutter/src/stream_chat.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

const _maxVisibleOptionCount = 10;

/// {@template pollMessage}
/// A widget that displays a message poll attachment in a [StreamMessageWidget].
/// {@endtemplate}
class PollAttachment extends StatefulWidget {
  /// {@macro pollMessage}
  const PollAttachment({
    super.key,
    required this.message,
    this.shape,
    this.constraints = const BoxConstraints(),
  });

  /// The message with the poll to display.
  final Message message;

  /// The shape of the poll attachment.
  final ShapeBorder? shape;

  /// The constraints to apply to the poll attachment widget.
  final BoxConstraints constraints;

  @override
  State<PollAttachment> createState() => _PollAttachmentState();
}

class _PollAttachmentState extends State<PollAttachment> {
  late final _messageNotifier = ValueNotifier(widget.message);

  @override
  void didUpdateWidget(covariant PollAttachment oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message != widget.message) {
      // If the message changes, schedule an update for the next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _messageNotifier.value = widget.message;
      });
    }
  }

  @override
  void dispose() {
    _messageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    final shape =
        widget.shape ??
        RoundedRectangleBorder(
          side: BorderSide(
            color: theme.colorTheme.borders,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: BorderRadius.circular(14),
        );

    return ValueListenableBuilder(
      valueListenable: _messageNotifier,
      builder: (context, message, child) {
        final poll = message.poll;
        if (poll == null) return const Empty();

        final currentUser = StreamChat.of(context).currentUser;
        if (currentUser == null) return const Empty();

        final channel = StreamChannel.of(context).channel;

        Future<void> onEndVote() async {
          final confirm = await showPollEndVoteDialog(context: context);
          if (confirm == null || !confirm) return;

          channel.closePoll(poll).ignore();
        }

        Future<void> onAddComment() async {
          final commentText = await showPollAddCommentDialog(
            context: context,
            // We use the first answer as the initial value because the user
            // can only add one comment per poll.
            initialValue: poll.ownAnswers.firstOrNull?.answerText ?? '',
          );

          if (commentText == null) return;
          channel.addPollAnswer(message, poll, answerText: commentText);
        }

        Future<void> onSuggestOption() async {
          final optionText = await showPollSuggestOptionDialog(
            context: context,
          );

          if (optionText == null) return;
          channel.createPollOption(poll, PollOption(text: optionText));
        }

        return Container(
          constraints: widget.constraints,
          decoration: ShapeDecoration(shape: shape),
          child: StreamPollInteractor(
            poll: poll,
            currentUser: currentUser,
            visibleOptionCount: _maxVisibleOptionCount,
            onEndVote: onEndVote,
            onCastVote: (option) => channel.castPollVote(message, poll, option),
            onRemoveVote: (vote) => channel.removePollVote(message, poll, vote),
            onAddComment: onAddComment,
            onSuggestOption: onSuggestOption,
            // We need to pass the notifier here instead of the poll because the
            // options dialog will have no way to update the poll itself.
            onViewComments: () => showStreamPollCommentsDialog(
              context: context,
              messageNotifier: _messageNotifier,
            ),
            onSeeMoreOptions: () => showStreamPollOptionsDialog(
              context: context,
              messageNotifier: _messageNotifier,
            ),
            onViewResults: () => showStreamPollResultsDialog(
              context: context,
              messageNotifier: _messageNotifier,
            ),
          ),
        );
      },
    );
  }
}
