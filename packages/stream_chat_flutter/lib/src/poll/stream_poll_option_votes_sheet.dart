import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/poll/stream_poll_results_sheet.dart';
import 'package:stream_chat_flutter/src/scroll_view/poll_vote_scroll_view/stream_poll_vote_list_view.dart';
import 'package:stream_chat_flutter/src/theme/poll_card_style.dart';
import 'package:stream_chat_flutter/src/theme/poll_option_votes_sheet_theme.dart';
import 'package:stream_chat_flutter/src/theme/poll_option_votes_style.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart';

/// {@template showStreamPollOptionVotesSheet}
/// Displays an interactive bottom sheet to show all the votes for a poll
/// option.
///
/// The votes are paginated and get's loaded as the user scrolls.
/// {@endtemplate}
Future<T?> showStreamPollOptionVotesSheet<T extends Object?>({
  required BuildContext context,
  required ValueListenable<Message> messageNotifier,
  required PollOption option,
}) {
  return showStreamSheet<T>(
    context: context,
    builder: (_, scrollController) => StreamChannel.value(
      channel: StreamChannel.of(context).channel,
      child: ValueListenableBuilder(
        valueListenable: messageNotifier,
        builder: (context, message, _) {
          final poll = message.poll;
          if (poll == null) return const Empty();
          if (option.id == null) return const Empty();

          return StreamPollOptionVotesSheet(
            poll: poll,
            option: option,
            scrollController: scrollController,
          );
        },
      ),
    ),
  );
}

/// {@template streamPollOptionVotesSheet}
/// A bottom sheet that displays all the votes for a poll option.
///
/// The votes are paginated and get's loaded as the user scrolls.
/// {@endtemplate}
class StreamPollOptionVotesSheet extends StatefulWidget {
  /// {@macro streamPollOptionVotesSheet}
  const StreamPollOptionVotesSheet({
    super.key,
    required this.poll,
    required this.option,
    this.scrollController,
  });

  /// The poll for which the votes are being displayed.
  final Poll poll;

  /// The option for which the votes are being displayed.
  final PollOption option;

  /// Scroll controller attached to the bottom sheet's scrollable content.
  ///
  /// Typically provided by [DraggableScrollableSheet] so the sheet expands and
  /// collapses in response to the user's scroll gesture.
  final ScrollController? scrollController;

  @override
  State<StreamPollOptionVotesSheet> createState() => _StreamPollOptionVotesSheetState();
}

class _StreamPollOptionVotesSheetState extends State<StreamPollOptionVotesSheet> {
  late StreamPollVoteListController _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(covariant StreamPollOptionVotesSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.poll.id != widget.poll.id || oldWidget.option.id != widget.option.id) {
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
    final theme = StreamPollOptionVotesSheetTheme.of(context);
    final defaults = _StreamPollOptionVotesSheetDefaults(context);

    final effectiveTheme = defaults.merge(theme);

    final optionStyle = effectiveTheme.optionStyle;
    final cardStyle = optionStyle?.cardStyle;

    final spacing = context.streamSpacing;

    final isOptionWinner = widget.poll.isOptionWithMaximumVotes(widget.option);
    final pollVotesCount = widget.poll.voteCountFor(widget.option);
    final optionIndex = widget.poll.options.indexWhere((it) => it.id == widget.option.id);
    final optionNumber = optionIndex >= 0 ? optionIndex + 1 : 1;

    return Column(
      children: [
        StreamSheetHeader(
          style: effectiveTheme.sheetHeaderStyle,
          title: Text(context.translations.pollVotesLabel),
        ),
        Flexible(
          child: Padding(
            padding: effectiveTheme.contentPadding ?? EdgeInsets.zero,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: cardStyle?.backgroundColor,
                borderRadius: cardStyle?.borderRadius,
              ),
              child: Padding(
                padding: cardStyle?.padding ?? EdgeInsets.zero,
                child: Column(
                  mainAxisSize: .min,
                  spacing: spacing.md,
                  crossAxisAlignment: .stretch,
                  children: <Widget>[
                    PollVotesByOptionHeader(
                      option: widget.option,
                      optionNumber: optionNumber,
                      pollVotesCount: pollVotesCount,
                      isOptionWinner: isOptionWinner,
                      optionStyle: optionStyle,
                    ),
                    Flexible(
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        removeBottom: true,
                        child: RefreshIndicator.adaptive(
                          onRefresh: _controller.refresh,
                          child: StreamPollVoteListView(
                            shrinkWrap: true,
                            controller: _controller,
                            scrollController: widget.scrollController,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Default values for [StreamPollOptionVotesSheetThemeData] backed by stream
// design tokens.
class _StreamPollOptionVotesSheetDefaults extends StreamPollOptionVotesSheetThemeData {
  _StreamPollOptionVotesSheetDefaults(this._context);

  final BuildContext _context;

  late final _spacing = _context.streamSpacing;
  late final _radius = _context.streamRadius;
  late final _colorScheme = _context.streamColorScheme;
  late final _textTheme = _context.streamTextTheme;

  @override
  Color get backgroundColor => _colorScheme.backgroundApp;

  @override
  EdgeInsetsGeometry get contentPadding => EdgeInsets.all(_spacing.md);

  @override
  StreamPollOptionVotesStyle get optionStyle => StreamPollOptionVotesStyle(
    cardStyle: StreamPollCardStyle(
      backgroundColor: _colorScheme.backgroundSurfaceCard,
      borderRadius: BorderRadius.all(_radius.lg),
      padding: EdgeInsets.all(_spacing.md),
    ),
    numberTextStyle: _textTheme.headingXs.copyWith(color: _colorScheme.textTertiary),
    textStyle: _textTheme.headingMd.copyWith(color: _colorScheme.textPrimary),
    voteCountTextStyle: _textTheme.bodyEmphasis.copyWith(color: _colorScheme.textPrimary),
    winnerIconColor: _colorScheme.textSecondary,
    winnerIconSize: 20,
  );
}
