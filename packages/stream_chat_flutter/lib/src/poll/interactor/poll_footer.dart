import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/poll_interactor_theme.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template pollFooter}
/// A widget used as the footer of a poll.
///
/// Used in [StreamPollInteractor] to display various actions the user can take
/// on the poll.
/// {@endtemplate}
class PollFooter extends StatelessWidget {
  /// {@macro pollFooter}
  const PollFooter({
    super.key,
    required this.poll,
    required this.currentUser,
    this.visibleOptionCount,
    this.onEndVote,
    this.onAddComment,
    this.onViewComments,
    this.onViewResults,
    this.onSuggestOption,
    this.onSeeMoreOptions,
  });

  /// The poll the footer is for.
  final Poll poll;

  /// The current user interacting with the poll.
  final User currentUser;

  /// The number of visible options in the poll.
  ///
  /// Used to determine if the user can see more options button.
  final int? visibleOptionCount;

  /// Callback invoked when the user wants to end the voting.
  ///
  /// This is only available if the [currentUser] is the creator of the poll.
  final VoidCallback? onEndVote;

  /// Callback invoked when the user wants to add a comment.
  ///
  /// This is only available if the poll is not closed and allows answers.
  final VoidCallback? onAddComment;

  /// Callback invoked when the user wants to view all the comments.
  ///
  /// This is only available if the poll is not closed and has answers.
  final VoidCallback? onViewComments;

  /// Callback invoked when the user wants to view the poll results.
  final VoidCallback? onViewResults;

  /// Callback invoked when the user wants to suggest an option.
  ///
  /// This is only available if the poll is not closed and allows user
  /// suggested options.
  final VoidCallback? onSuggestOption;

  /// Callback invoked when the user wants to see more options.
  ///
  /// This is only available if the poll has more options than the
  /// [visibleOptionCount].
  final VoidCallback? onSeeMoreOptions;

  bool get _shouldShowEndPollButton {
    if (poll.isClosed) return false;

    // Only the creator of the poll can end it.
    return poll.createdBy?.id == currentUser.id;
  }

  bool get _shouldShowAddCommentButton {
    if (poll.isClosed || !poll.allowAnswers) return false;
    if (poll.votingVisibility == VotingVisibility.anonymous) return true;

    // If the user has already commented, don't show the button.
    if (poll.ownAnswers.isNotEmpty) return false;

    return true;
  }

  bool get _shouldShowViewCommentsButton {
    if (poll.isClosed) return false;

    // If the poll has no answers, don't show the button.
    return poll.answersCount > 0;
  }

  bool get _shouldShowSuggestionsButton {
    if (poll.isClosed) return false;

    // Only show the button if the poll allows user suggested options.
    return poll.allowUserSuggestedOptions;
  }

  bool get _shouldEnableViewResultsButton {
    // Disable the button if the poll haven't got any votes yet.
    if (poll.voteCount < 1) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.translations;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (visibleOptionCount case final count?
            when count < poll.options.length)
          PollFooterButton(
            title: translations.seeAllOptionsLabel(count: poll.options.length),
            onPressed: onSeeMoreOptions,
          ),
        if (_shouldShowSuggestionsButton)
          PollFooterButton(
            title: translations.suggestAnOptionLabel,
            onPressed: onSuggestOption,
          ),
        if (_shouldShowAddCommentButton)
          PollFooterButton(
            title: translations.addACommentLabel,
            onPressed: onAddComment,
          ),
        if (_shouldShowViewCommentsButton)
          PollFooterButton(
            title: translations.viewCommentsLabel,
            onPressed: onViewComments,
          ),
        PollFooterButton(
          title: translations.viewResultsLabel,
          onPressed: _shouldEnableViewResultsButton ? onViewResults : null,
        ),
        if (_shouldShowEndPollButton)
          PollFooterButton(
            title: translations.endVoteLabel,
            onPressed: onEndVote,
          ),
      ].insertBetween(const SizedBox(height: 2)),
    );
  }
}

/// {@template pollFooterButton}
/// A button used in [PollFooter].
///
/// Displays the title and invokes the [onPressed] callback when pressed.
/// {@endtemplate}
class PollFooterButton extends StatelessWidget {
  /// {@macro pollFooterButton}
  const PollFooterButton({
    super.key,
    required this.title,
    this.onPressed,
  });

  /// The title of the button.
  final String title;

  /// Callback invoked when the button is pressed.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollInteractorTheme.of(context);

    return TextButton(
      onPressed: onPressed,
      // Consume long press to avoid the parent long press.
      onLongPress: onPressed != null ? () {} : null,
      style: theme.pollActionButtonStyle,
      child: Text(title),
    );
  }
}
