import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/components/stream_chat_component_builders.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_add_comment_dialog.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_end_vote_dialog.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_suggest_option_dialog.dart';
import 'package:stream_chat_flutter/src/poll/interactor/stream_poll_interactor.dart';
import 'package:stream_chat_flutter/src/poll/stream_poll_comments_sheet.dart';
import 'package:stream_chat_flutter/src/poll/stream_poll_options_sheet.dart';
import 'package:stream_chat_flutter/src/poll/stream_poll_results_sheet.dart';
import 'package:stream_chat_flutter/src/stream_chat.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart';

/// An interactive poll attachment with voting and results.
///
/// [StreamPollAttachment] presents an interactive poll, supporting
/// voting, comments, and results viewing.
///
/// {@tool snippet}
///
/// Basic usage:
///
/// ```dart
/// StreamPollAttachment(
///   message: message,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamPollAttachmentProps], which configures this widget.
///  * [DefaultStreamPollAttachment], the default implementation.
class StreamPollAttachment extends StatelessWidget {
  /// Creates a [StreamPollAttachment].
  StreamPollAttachment({
    super.key,
    required Message message,
    BoxConstraints? constraints,
  }) : props = .new(
         message: message,
         constraints: constraints,
       );

  /// The properties that configure this attachment.
  final StreamPollAttachmentProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamPollAttachmentProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamPollAttachment(props: props);
  }
}

/// Properties for configuring a [StreamPollAttachment].
///
/// This class holds all the configuration options for a poll attachment,
/// allowing them to be passed through the [StreamComponentFactory].
///
/// See also:
///
///  * [StreamPollAttachment], which uses these properties.
///  * [DefaultStreamPollAttachment], the default implementation.
class StreamPollAttachmentProps {
  /// Creates properties for a poll attachment.
  const StreamPollAttachmentProps({
    required this.message,
    this.constraints,
  });

  /// The message containing the poll.
  final Message message;

  /// The constraints to use when displaying the poll.
  final BoxConstraints? constraints;
}

const _maxVisibleOptionCount = 5;
const _kDefaultConstraints = BoxConstraints(maxWidth: 270);

/// The default implementation of [StreamPollAttachment].
///
/// Renders an interactive poll with voting and result controls.
///
/// See also:
///
///  * [StreamPollAttachment], the public API widget.
///  * [StreamPollAttachmentProps], which configures this widget.
class DefaultStreamPollAttachment extends StatefulWidget {
  /// Creates a default Stream poll attachment.
  const DefaultStreamPollAttachment({
    super.key,
    required this.props,
  });

  /// The properties that configure this attachment.
  final StreamPollAttachmentProps props;

  @override
  State<DefaultStreamPollAttachment> createState() => _DefaultStreamPollAttachmentState();
}

class _DefaultStreamPollAttachmentState extends State<DefaultStreamPollAttachment> {
  late final _messageNotifier = ValueNotifier(widget.props.message);

  @override
  void didUpdateWidget(covariant DefaultStreamPollAttachment oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.props.message != widget.props.message) {
      // If the message changes, schedule an update for the next frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _messageNotifier.value = widget.props.message;
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

        final constraints = widget.props.constraints ?? _kDefaultConstraints;

        return ConstrainedBox(
          constraints: constraints,
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
            onViewComments: () => showStreamPollCommentsSheet(
              context: context,
              messageNotifier: _messageNotifier,
            ),
            onSeeMoreOptions: () => showStreamPollOptionsSheet(
              context: context,
              messageNotifier: _messageNotifier,
            ),
            onViewResults: () => showStreamPollResultsSheet(
              context: context,
              messageNotifier: _messageNotifier,
            ),
          ),
        );
      },
    );
  }
}
