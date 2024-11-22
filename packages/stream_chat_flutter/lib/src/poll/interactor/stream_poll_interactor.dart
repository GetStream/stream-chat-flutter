import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_footer.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_header.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_options_list_view.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template streamPollInteractor}
/// A widget that allows users to interact with a poll.
///
/// The widget provides various callbacks to interact with the poll.
/// - [onCastVote] is called when the user wants to cast a vote.
/// - [onRemoveVote] is called when the user wants to remove a vote.
/// - [onEndVote] is called when the user wants to end the voting.
/// - [onAddComment] is called when the user wants to add a comment.
/// - [onViewComments] is called when the user wants to view all the comments.
/// - [onViewResults] is called when the user wants to view the poll results.
/// - [onSuggestOption] is called when the user wants to suggest an option.
/// - [onSeeMoreOptions] is called when the user wants to see more options.
///
/// The widget also provides a [visibleOptionCount] parameter to control the
/// number of visible options in the poll. If null, all options will be visible.
/// {@endtemplate}
class StreamPollInteractor extends StatelessWidget {
  /// {@macro streamPollInteractor}
  const StreamPollInteractor({
    super.key,
    required this.poll,
    required this.currentUser,
    this.padding = const EdgeInsets.symmetric(
      vertical: 12,
      horizontal: 10,
    ),
    this.visibleOptionCount,
    this.onCastVote,
    this.onRemoveVote,
    this.onEndVote,
    this.onAddComment,
    this.onViewComments,
    this.onViewResults,
    this.onSuggestOption,
    this.onSeeMoreOptions,
  });

  /// The poll to interact with.
  final Poll poll;

  /// The current user interacting with the poll.
  final User currentUser;

  /// The padding to apply to the interactor.
  final EdgeInsetsGeometry padding;

  /// The number of visible options in the poll.
  ///
  /// If null, all options will be visible.
  final int? visibleOptionCount;

  /// Callback invoked when the user wants to cast a vote.
  ///
  /// The [PollOption] parameter is the option the user wants to vote for.
  final ValueChanged<PollOption>? onCastVote;

  /// Callback invoked when the user wants to remove a vote.
  ///
  /// The [PollVote] parameter is the vote the user wants to remove.
  final ValueChanged<PollVote>? onRemoveVote;

  /// Callback invoked when the user wants to end the voting.
  ///
  /// This is only invoked if the [currentUser] is the creator of the poll.
  final VoidCallback? onEndVote;

  /// Callback invoked when the user wants to add a comment.
  ///
  /// This is only invoked if the poll allows adding answers.
  final VoidCallback? onAddComment;

  /// Callback invoked when the user wants to view all the comments.
  ///
  /// This is only invoked if the poll contains answers.
  final VoidCallback? onViewComments;

  /// Callback invoked when the user wants to view the poll results.
  final VoidCallback? onViewResults;

  /// Callback invoked when the user wants to suggest an option.
  ///
  /// This is only invoked if the poll allows user suggested options.
  final VoidCallback? onSuggestOption;

  /// Callback invoked when the user wants to see more options.
  ///
  /// This is only invoked if the poll has more options than
  /// [visibleOptionCount].
  final VoidCallback? onSeeMoreOptions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PollHeader(poll: poll),
          MediaQuery.removePadding(
            context: context,
            // Workaround for the bottom padding issue.
            // Link: https://github.com/flutter/flutter/issues/156149
            removeTop: true,
            removeBottom: true,
            child: PollOptionsListView(
              poll: poll,
              showProgressBar: true,
              visibleOptionCount: visibleOptionCount,
              onCastVote: onCastVote,
              onRemoveVote: onRemoveVote,
            ),
          ),
          PollFooter(
            poll: poll,
            currentUser: currentUser,
            visibleOptionCount: visibleOptionCount,
            onEndVote: onEndVote,
            onAddComment: onAddComment,
            onViewComments: onViewComments,
            onViewResults: onViewResults,
            onSuggestOption: onSuggestOption,
            onSeeMoreOptions: onSeeMoreOptions,
          ),
        ].insertBetween(const SizedBox(height: 8)),
      ),
    );
  }
}
