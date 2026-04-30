import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/components/avatar/stream_user_avatar.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/misc/timestamp.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_add_comment_dialog.dart';
import 'package:stream_chat_flutter/src/scroll_view/poll_vote_scroll_view/stream_poll_vote_list_view.dart';
import 'package:stream_chat_flutter/src/theme/poll_card_style.dart';
import 'package:stream_chat_flutter/src/theme/poll_comments_sheet_theme.dart';
import 'package:stream_chat_flutter/src/theme/poll_option_votes_style.dart';
import 'package:stream_chat_flutter/src/utils/date_formatter.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// {@template showStreamPollCommentsSheet}
/// Displays an interactive bottom sheet to show all the comments for a poll.
///
/// The comments are paginated and get's loaded as the user scrolls.
///
/// The sheet also allows the user to update their comment.
/// {@endtemplate}
Future<T?> showStreamPollCommentsSheet<T extends Object?>({
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

          return StreamPollCommentsSheet(
            poll: poll,
            scrollController: scrollController,
            onUpdateComment: onUpdateComment,
          );
        },
      ),
    ),
  );
}

/// {@template streamPollCommentsSheet}
/// A bottom sheet that displays all the comments for a poll.
///
/// The comments are paginated and get's loaded as the user scrolls.
///
/// Provides a callback to update the user's comment.
/// {@endtemplate}
class StreamPollCommentsSheet extends StatefulWidget {
  /// {@macro streamPollCommentsSheet}
  const StreamPollCommentsSheet({
    super.key,
    required this.poll,
    this.scrollController,
    this.onUpdateComment,
  });

  /// The poll to display the comments for.
  final Poll poll;

  /// Scroll controller attached to the bottom sheet's scrollable content.
  ///
  /// Typically provided by [DraggableScrollableSheet] so the sheet expands and
  /// collapses in response to the user's scroll gesture.
  final ScrollController? scrollController;

  /// Callback invoked when the user wants to add or update their comment.
  final VoidCallback? onUpdateComment;

  @override
  State<StreamPollCommentsSheet> createState() => _StreamPollCommentsSheetState();
}

class _StreamPollCommentsSheetState extends State<StreamPollCommentsSheet> {
  late StreamPollVoteListController _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(covariant StreamPollCommentsSheet oldWidget) {
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

  bool get _shouldShowAddCommentButton {
    if (widget.poll.isClosed || !widget.poll.allowAnswers) return false;

    // If the user has already commented, don't show the button.
    if (widget.poll.ownAnswers.isNotEmpty) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollCommentsSheetTheme.of(context);
    final defaults = _StreamPollCommentsSheetDefaults(context);

    final effectiveTheme = defaults.merge(theme);

    final commentStyle = effectiveTheme.commentStyle;
    final itemSpacing = effectiveTheme.itemSpacing ?? 0;

    return Column(
      mainAxisSize: .min,
      children: [
        StreamSheetHeader(
          style: effectiveTheme.sheetHeaderStyle,
          title: Text(context.translations.pollCommentsLabel),
          trailing: switch (_shouldShowAddCommentButton) {
            true => StreamButton.icon(
              style: .primary,
              type: .solid,
              icon: Icon(context.streamIcons.edit),
              onPressed: widget.onUpdateComment,
            ),
            false => null,
          },
        ),
        Expanded(
          child: RefreshIndicator.adaptive(
            onRefresh: _controller.refresh,
            child: StreamPollVoteListView(
              controller: _controller,
              scrollController: widget.scrollController,
              padding: effectiveTheme.contentPadding,
              separatorBuilder: (_, __, ___) => SizedBox(height: itemSpacing),
              itemBuilder: (context, comments, index, _) {
                final comment = comments[index];

                return _PollCommentCard(
                  poll: widget.poll,
                  comment: comment,
                  style: commentStyle,
                  onUpdateComment: widget.onUpdateComment,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// Renders a single comment as a card inside [StreamPollCommentsSheet]'s
// paginated list.
class _PollCommentCard extends StatelessWidget {
  const _PollCommentCard({
    required this.poll,
    required this.comment,
    required this.style,
    this.onUpdateComment,
  });

  final Poll poll;
  final PollVote comment;
  final StreamPollOptionVotesStyle? style;
  final VoidCallback? onUpdateComment;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    final cardStyle = style?.cardStyle;

    final currentUser = StreamChatCore.maybeOf(context)?.currentUser;
    final isCurrentUser = switch (comment.user) {
      final user? => user.id == currentUser?.id,
      _ => false,
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
              spacing: spacing.xs,
              crossAxisAlignment: .start,
              children: [
                if (comment.answerText case final answerText?)
                  Text(
                    answerText,
                    style: textTheme.bodyDefault.copyWith(color: colorScheme.textPrimary),
                  ),
                Row(
                  spacing: spacing.xs,
                  children: [
                    if (comment.user case final user?) ...[
                      StreamUserAvatar(
                        size: .sm,
                        user: user,
                        showOnlineIndicator: false,
                      ),
                      Flexible(
                        child: Text(
                          user.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.captionEmphasis.copyWith(color: colorScheme.textPrimary),
                        ),
                      ),
                    ],
                    StreamTimestamp(
                      date: comment.updatedAt.toLocal(),
                      formatter: formatRecentDateTime,
                      style: textTheme.captionDefault.copyWith(color: colorScheme.textTertiary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isCurrentUser && !poll.isClosed) ...[
            Divider(height: 1, color: style?.footerDividerColor),
            StreamButton(
              size: .small,
              type: .ghost,
              style: .secondary,
              onPressed: onUpdateComment,
              themeStyle: style?.footerButtonStyle,
              child: Text(context.translations.updateYourCommentLabel),
            ),
          ],
        ],
      ),
    );
  }
}

// Default values for [StreamPollCommentsSheetThemeData] backed by stream
// design tokens.
class _StreamPollCommentsSheetDefaults extends StreamPollCommentsSheetThemeData {
  _StreamPollCommentsSheetDefaults(this._context);

  final BuildContext _context;

  late final _spacing = _context.streamSpacing;
  late final _radius = _context.streamRadius;
  late final _colorScheme = _context.streamColorScheme;

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
  double get itemSpacing => _spacing.md;

  @override
  StreamPollOptionVotesStyle get commentStyle => StreamPollOptionVotesStyle(
    cardStyle: StreamPollCardStyle(
      backgroundColor: _colorScheme.backgroundSurfaceCard,
      borderRadius: BorderRadius.all(_radius.lg),
      padding: EdgeInsets.all(_spacing.md),
    ),
    footerDividerColor: _colorScheme.borderDefault,
  );
}
