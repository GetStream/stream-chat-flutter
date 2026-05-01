import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_options_list_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template showStreamPollOptionsSheet}
/// Displays an interactive bottom sheet to show all the available options for
/// a poll.
///
/// The bottom sheet allows the user to cast a vote or remove a vote.
/// {@endtemplate}
Future<T?> showStreamPollOptionsSheet<T extends Object?>({
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

          void onCastVote(PollOption option) {
            channel.castPollVote(message, poll, option);
          }

          void onRemoveVote(PollVote vote) {
            channel.removePollVote(message, poll, vote);
          }

          return StreamPollOptionsSheet(
            poll: poll,
            scrollController: scrollController,
            onCastVote: onCastVote,
            onRemoveVote: onRemoveVote,
          );
        },
      ),
    ),
  );
}

/// {@template streamPollOptionsSheet}
/// A bottom sheet that displays all the available options for a poll.
///
/// Provides callbacks when a vote has been cast or removed from the poll.
/// {@endtemplate}
class StreamPollOptionsSheet extends StatelessWidget {
  /// {@macro streamPollOptionsSheet}
  const StreamPollOptionsSheet({
    super.key,
    required this.poll,
    this.scrollController,
    this.onCastVote,
    this.onRemoveVote,
  });

  /// The poll to display the options for.
  final Poll poll;

  /// Scroll controller attached to the bottom sheet's scrollable content.
  ///
  /// Typically provided by [DraggableScrollableSheet] so the sheet expands and
  /// collapses in response to the user's scroll gesture.
  final ScrollController? scrollController;

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
    final theme = StreamPollOptionsSheetTheme.of(context);
    final defaults = _StreamPollOptionsSheetDefaults(context);

    final effectiveTheme = defaults.merge(theme);

    final optionsCardStyle = effectiveTheme.optionsCardStyle;

    return Column(
      mainAxisSize: .min,
      children: [
        StreamSheetHeader(
          style: effectiveTheme.sheetHeaderStyle,
          title: Text(context.translations.pollOptionsLabel),
        ),
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: effectiveTheme.contentPadding,
            children: <Widget>[
              PollOptionsQuestion(question: poll.name),
              Material(
                color: optionsCardStyle?.backgroundColor,
                borderRadius: optionsCardStyle?.borderRadius,
                child: Padding(
                  padding: optionsCardStyle?.padding ?? EdgeInsets.zero,
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    removeBottom: true,
                    child: PollOptionsListView(
                      poll: poll,
                      padding: .zero,
                      onCastVote: onCastVote,
                      onRemoveVote: onRemoveVote,
                      optionStyle: effectiveTheme.optionStyle,
                      spacing: effectiveTheme.optionsItemSpacing,
                    ),
                  ),
                ),
              ),
            ].insertBetween(SizedBox(height: effectiveTheme.sectionSpacing)),
          ),
        ),
      ],
    );
  }
}

/// {@template pollOptionsQuestion}
/// A widget that displays the question of a poll.
///
/// Reads its styling from the ambient [StreamPollOptionsSheetTheme].
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
    final theme = StreamPollOptionsSheetTheme.of(context);
    final defaults = _StreamPollOptionsSheetDefaults(context);

    final effectiveTheme = defaults.merge(theme);

    final questionStyle = effectiveTheme.questionStyle;
    final cardStyle = questionStyle?.cardStyle;

    final spacing = context.streamSpacing;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cardStyle?.backgroundColor,
        borderRadius: cardStyle?.borderRadius,
      ),
      child: Padding(
        padding: cardStyle?.padding ?? EdgeInsets.zero,
        child: Column(
          mainAxisSize: .min,
          spacing: spacing.xxs,
          crossAxisAlignment: .start,
          children: [
            Text(context.translations.questionLabel(), style: questionStyle?.headerTextStyle),
            Text(question, style: questionStyle?.textStyle),
          ],
        ),
      ),
    );
  }
}

// Default values for [StreamPollOptionsSheetThemeData] backed by stream
// design tokens.
class _StreamPollOptionsSheetDefaults extends StreamPollOptionsSheetThemeData {
  _StreamPollOptionsSheetDefaults(this._context);

  final BuildContext _context;

  late final _spacing = _context.streamSpacing;
  late final _radius = _context.streamRadius;
  late final _colorScheme = _context.streamColorScheme;
  late final _textTheme = _context.streamTextTheme;

  @override
  Color get backgroundColor => _colorScheme.backgroundApp;

  @override
  EdgeInsetsGeometry get contentPadding => .all(_spacing.md);

  @override
  double get sectionSpacing => _spacing.xxl;

  @override
  StreamPollQuestionStyle get questionStyle => StreamPollQuestionStyle(
    cardStyle: StreamPollCardStyle(
      backgroundColor: _colorScheme.backgroundSurfaceCard,
      borderRadius: BorderRadius.all(_radius.lg),
      padding: EdgeInsets.all(_spacing.md),
    ),
    headerTextStyle: _textTheme.headingXs.copyWith(color: _colorScheme.textTertiary),
    textStyle: _textTheme.headingMd.copyWith(color: _colorScheme.textPrimary),
  );

  @override
  StreamPollCardStyle get optionsCardStyle => StreamPollCardStyle(
    backgroundColor: _colorScheme.backgroundSurfaceCard,
    borderRadius: BorderRadius.all(_radius.lg),
    padding: EdgeInsets.symmetric(vertical: _spacing.md, horizontal: _spacing.xs),
  );

  @override
  double get optionsItemSpacing => _spacing.xs;
}
