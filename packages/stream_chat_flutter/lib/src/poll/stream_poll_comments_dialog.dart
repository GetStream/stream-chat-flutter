import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_add_comment_dialog.dart';
import 'package:stream_chat_flutter/src/scroll_view/poll_vote_scroll_view/stream_poll_vote_list_view.dart';
import 'package:stream_chat_flutter/src/theme/poll_comments_dialog_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template showStreamPollCommentsDialog}
/// Displays an interactive dialog to show all the comments for a poll.
///
/// The comments are paginated and get's loaded as the user scrolls.
///
/// The dialog also allows the user to update their comment.
/// {@endtemplate}
Future<T?> showStreamPollCommentsDialog<T extends Object?>({
  required BuildContext context,
  required ValueListenable<Message> messageNotifier,
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

          final channel = StreamChannel.of(context).channel;

          Future<void> onUpdateComment() async {
            final commentText = await showPollAddCommentDialog(
              context: context,
              // We use the first answer as the initial value because the
              // user can only add one comment per poll.
              initialValue: poll.ownAnswers.firstOrNull?.answerText ?? '',
            );

            if (commentText == null) return;
            channel.addPollAnswer(message, poll, answerText: commentText);
          }

          return StreamPollCommentsDialog(
            poll: poll,
            onUpdateComment: onUpdateComment,
          );
        },
      ),
    ),
  );
}

/// {@template streamPollCommentsDialog}
/// A dialog that displays all the comments for a poll.
///
/// The comments are paginated and get's loaded as the user scrolls.
///
/// Provides a callback to update the user's comment.
/// {@endtemplate}
class StreamPollCommentsDialog extends StatefulWidget {
  /// {@macro streamPollCommentsDialog}
  const StreamPollCommentsDialog({
    super.key,
    required this.poll,
    this.onUpdateComment,
  });

  /// The poll to display the options for.
  final Poll poll;

  /// Callback invoked when the user wants to cast a vote.
  final VoidCallback? onUpdateComment;

  @override
  State<StreamPollCommentsDialog> createState() =>
      _StreamPollCommentsDialogState();
}

class _StreamPollCommentsDialogState extends State<StreamPollCommentsDialog> {
  late StreamPollVoteListController _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(covariant StreamPollCommentsDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.poll.id != widget.poll.id) {
      _controller.dispose(); // Dispose the old controller.
      _initializeController(); // Initialize a new controller.
    }
  }

  void _initializeController() {
    _controller = StreamPollVoteListController(
      pollId: widget.poll.id,
      channel: StreamChannel.of(context).channel,
      filter: Filter.equal('is_answer', true),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollCommentsDialogTheme.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        elevation: theme.appBarElevation,
        backgroundColor: theme.appBarBackgroundColor,
        title: Text(
          context.translations.pollCommentsLabel,
          style: theme.appBarTitleTextStyle,
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _controller.refresh,
        child: StreamPollVoteListView(
          controller: _controller,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, _, __, defaultWidget) {
            return defaultWidget.copyWith(
              showAnswerText: true,
              contentPadding: const EdgeInsets.all(16),
              borderRadius: theme.pollCommentItemBorderRadius,
              tileColor: theme.pollCommentItemBackgroundColor,
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FilledButton.tonal(
            onPressed: widget.onUpdateComment,
            style: theme.updateYourCommentButtonStyle,
            child: Text(switch (widget.poll.ownAnswers.isEmpty) {
              true => context.translations.addACommentLabel,
              false => context.translations.updateYourCommentLabel,
            }),
          ),
        ),
      ),
    );
  }
}
