import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template showStreamPollCreatorSheet}
/// Displays an interactive bottom sheet that lets the user create a poll.
///
/// The sheet renders a [StreamSheetHeader] with a close action on the leading
/// side and a confirm action on the trailing side, followed by a
/// [StreamPollCreatorWidget] form for the question, options, and poll
/// configuration.
///
/// The future completes with the sanitized [Poll] when the user confirms the
/// creation, or `null` when the sheet is dismissed.
///
/// The [poll] and [config] parameters can be used to provide an initial poll
/// and a configuration to validate the poll.
/// {@endtemplate}
Future<T?> showStreamPollCreatorSheet<T>({
  required BuildContext context,
  Poll? poll,
  PollConfig? config,
  EdgeInsets padding = const EdgeInsets.all(16),
}) {
  return showStreamSheet<T>(
    context: context,
    builder: (_, scrollController) => StreamPollCreatorSheet(
      poll: poll,
      config: config,
      padding: padding,
      scrollController: scrollController,
    ),
  );
}

/// {@template streamPollCreatorSheet}
/// A bottom sheet that allows users to create a poll.
///
/// The sheet provides a form to create a poll with a question and multiple
/// options, alongside the standard poll configuration toggles (multiple
/// answers, anonymous voting, suggested options, comments).
///
/// Pops the enclosing route with the sanitized [Poll] when the user taps the
/// trailing confirm action. The action is disabled until the form passes
/// validation.
/// {@endtemplate}
class StreamPollCreatorSheet extends StatefulWidget {
  /// {@macro streamPollCreatorSheet}
  const StreamPollCreatorSheet({
    super.key,
    this.poll,
    this.config,
    this.padding = const EdgeInsets.all(16),
    this.scrollController,
  });

  /// The initial poll to be used in the poll creator.
  final Poll? poll;

  /// The configuration used to validate the poll.
  final PollConfig? config;

  /// The padding around the poll creator form.
  final EdgeInsets padding;

  /// Scroll controller attached to the bottom sheet's scrollable content.
  ///
  /// Typically provided by [DraggableScrollableSheet] so the sheet expands and
  /// collapses in response to the user's scroll gesture.
  final ScrollController? scrollController;

  @override
  State<StreamPollCreatorSheet> createState() => _StreamPollCreatorSheetState();
}

class _StreamPollCreatorSheetState extends State<StreamPollCreatorSheet> {
  late final _controller = StreamPollController(
    poll: widget.poll,
    config: widget.config,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollCreatorTheme.of(context);

    return Column(
      mainAxisSize: .min,
      children: [
        StreamSheetHeader(
          style: theme.sheetHeaderStyle,
          title: Text(context.translations.createPollLabel()),
          trailing: ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, poll, child) {
              final isValid = _controller.validate();

              return StreamButton.icon(
                style: .primary,
                type: .solid,
                icon: Icon(context.streamIcons.checkmark),
                onPressed: switch (isValid) {
                  false => null,
                  true => () {
                    final sanitizedPoll = _controller.sanitizedPoll;
                    return Navigator.of(context).pop(sanitizedPoll);
                  },
                },
              );
            },
          ),
        ),
        Expanded(
          child: StreamPollCreatorWidget(
            controller: _controller,
            padding: widget.padding,
            scrollController: widget.scrollController,
          ),
        ),
      ],
    );
  }
}
