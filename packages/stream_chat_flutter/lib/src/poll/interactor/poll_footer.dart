import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template pollFooter}
/// A widget used as the footer of a poll.
///
/// Used in [StreamPollInteractor] to display various actions the user can take
/// on the poll.
///
/// See also:
///
///  * [StreamPollInteractorThemeData.primaryActionStyle], for customizing
///    primary action buttons (view results, end vote).
///  * [StreamPollInteractorThemeData.secondaryActionStyle], for customizing
///    secondary action buttons (suggest option, add comment, view comments).
///  * [StreamPollInteractor], the parent widget that uses this footer.
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

  bool get _shouldShowEndPollButton {
    if (poll.isClosed) return false;

    // Only the creator of the poll can end it.
    return poll.createdBy?.id == currentUser.id;
  }

  bool get _shouldShowViewResultsButton {
    // If the poll has no votes, don't show the button.
    return poll.voteCount > 0;
  }

  bool get _shouldShowAddCommentButton {
    if (poll.isClosed || !poll.allowAnswers) return false;

    // If the user has already commented, don't show the button.
    if (poll.ownAnswers.isNotEmpty) return false;

    return true;
  }

  bool get _shouldShowViewCommentsButton {
    // If the poll has no answers, don't show the button.
    return poll.answersCount > 0;
  }

  bool get _shouldShowSuggestionsButton {
    if (poll.isClosed) return false;

    // Only show the button if the poll allows user suggested options.
    return poll.allowUserSuggestedOptions;
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.translations;

    final spacing = context.streamSpacing;

    final showEndPoll = _shouldShowEndPollButton;
    final showViewResults = _shouldShowViewResultsButton;
    final showSuggestions = _shouldShowSuggestionsButton;
    final showAddComment = _shouldShowAddCommentButton;
    final showViewComments = _shouldShowViewCommentsButton;

    if (!showEndPoll && !showViewResults && !showSuggestions && !showAddComment && !showViewComments) {
      return SizedBox(height: spacing.lg);
    }

    return Padding(
      padding: .all(spacing.md),
      child: Column(
        mainAxisSize: .min,
        spacing: spacing.xxxs,
        crossAxisAlignment: .stretch,
        children: <Widget>[
          Column(
            mainAxisSize: .min,
            spacing: spacing.xs,
            crossAxisAlignment: .stretch,
            children: [
              if (showViewResults)
                _PollFooterButton.primary(
                  label: translations.viewResultsLabel,
                  onPressed: onViewResults,
                ),
              if (showEndPoll)
                _PollFooterButton.primary(
                  label: translations.endVoteLabel,
                  onPressed: onEndVote,
                ),
            ],
          ),
          Column(
            mainAxisSize: .min,
            spacing: spacing.xs,
            crossAxisAlignment: .stretch,
            children: [
              if (showSuggestions)
                _PollFooterButton.secondary(
                  label: translations.suggestAnOptionLabel,
                  onPressed: onSuggestOption,
                ),
              if (showAddComment)
                _PollFooterButton.secondary(
                  label: translations.addACommentLabel,
                  onPressed: onAddComment,
                ),
              if (showViewComments)
                _PollFooterButton.secondary(
                  label: translations.viewCommentsLabel,
                  onPressed: onViewComments,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// A button used in [PollFooter].
//
// Renders a [StreamButton] with the appropriate poll interactor theme style
// applied via [StreamButtonTheme].
class _PollFooterButton extends StatelessWidget {
  const _PollFooterButton({
    required this.label,
    required this.type,
    this.onPressed,
  });

  // Creates a primary poll footer button (outline style).
  const _PollFooterButton.primary({
    required String label,
    VoidCallback? onPressed,
  }) : this(label: label, type: .outline, onPressed: onPressed);

  // Creates a secondary poll footer button (ghost style).
  const _PollFooterButton.secondary({
    required String label,
    VoidCallback? onPressed,
  }) : this(label: label, type: .ghost, onPressed: onPressed);

  final String label;
  final StreamButtonType type;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollInteractorTheme.of(context);
    final defaults = _StreamPollFooterDefaults(context);

    final effectivePrimaryActionStyle = theme.primaryActionStyle ?? defaults.primaryActionStyle;
    final effectiveSecondaryActionStyle = theme.secondaryActionStyle ?? defaults.secondaryActionStyle;

    return StreamButtonTheme(
      data: StreamButtonThemeData(
        secondary: StreamButtonTypeStyle(
          outline: effectivePrimaryActionStyle,
          ghost: effectiveSecondaryActionStyle,
        ),
      ),
      child: StreamButton(
        size: .small,
        style: .secondary,
        type: type,
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

// Default values for [StreamPollInteractorThemeData] backed by stream design tokens.
class _StreamPollFooterDefaults extends StreamPollInteractorThemeData {
  _StreamPollFooterDefaults(this._context);

  final BuildContext _context;

  late final _alignment = StreamMessageLayout.messageAlignmentOf(_context);
  late final StreamColorScheme _colorScheme = _context.streamColorScheme;

  @override
  StreamButtonThemeStyle get primaryActionStyle => .from(
    tapTargetSize: .shrinkWrap,
    borderColor: switch (_alignment) {
      .start => _colorScheme.borderStrong,
      .end => _colorScheme.brand.shade300,
    },
  );

  @override
  StreamButtonThemeStyle get secondaryActionStyle => .from(tapTargetSize: .shrinkWrap);
}
