import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/creator/stream_poll_creator_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template showStreamPollCreatorDialog}
/// Shows the poll creator dialog based on the screen size.
///
/// The regular dialog is shown on larger screens such as tablets and desktops
/// and a full screen dialog is shown on smaller screens such as mobile phones.
///
/// The [poll] and [config] parameters can be used to provide an initial poll
/// and a configuration to validate the poll.
/// {@endtemplate}
Future<T?> showStreamPollCreatorDialog<T>({
  required BuildContext context,
  Poll? poll,
  PollConfig? config,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = false,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  EdgeInsets padding = const EdgeInsets.all(16),
  TraversalEdgeBehavior? traversalEdgeBehavior,
}) {
  final size = MediaQuery.sizeOf(context);
  final isTabletOrDesktop = size.width > 600;

  final colorTheme = StreamChatTheme.of(context).colorTheme;

  // Open it as a regular dialog on bigger screens such as tablets and desktops.
  if (isTabletOrDesktop) {
    return showDialog(
      context: context,
      barrierColor: barrierColor ?? colorTheme.overlay,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      builder: (context) => StreamPollCreatorDialog(
        poll: poll,
        config: config,
        padding: padding,
      ),
    );
  }

  // Open it as a full screen dialog on smaller screens such as mobile phones.
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  return navigator.push(
    MaterialPageRoute(
      fullscreenDialog: true,
      barrierDismissible: barrierDismissible,
      builder: (context) => StreamPollCreatorFullScreenDialog(
        poll: poll,
        config: config,
        padding: padding,
      ),
    ),
  );
}

/// {@template streamPollCreatorDialog}
/// A dialog that allows users to create a poll.
///
/// The dialog provides a form to create a poll with a question and multiple
/// options.
///
/// This widget is intended to be used on larger screens such as tablets and
/// desktops.
///
/// For smaller screens, consider using [StreamPollCreatorFullScreenDialog].
/// {@endtemplate}
class StreamPollCreatorDialog extends StatefulWidget {
  /// {@macro streamPollCreatorDialog}
  const StreamPollCreatorDialog({
    super.key,
    this.poll,
    this.config,
    this.padding = const EdgeInsets.all(16),
  });

  /// The initial poll to be used in the poll creator.
  final Poll? poll;

  /// The configuration used to validate the poll.
  final PollConfig? config;

  /// The padding around the poll creator.
  final EdgeInsets padding;

  @override
  State<StreamPollCreatorDialog> createState() =>
      _StreamPollCreatorDialogState();
}

class _StreamPollCreatorDialogState extends State<StreamPollCreatorDialog> {
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
    final theme = StreamChatTheme.of(context);
    final pollCreatorTheme = StreamPollCreatorTheme.of(context);

    final actions = [
      TextButton(
        onPressed: Navigator.of(context).pop,
        style: TextButton.styleFrom(
          textStyle: theme.textTheme.headlineBold,
          foregroundColor: theme.colorTheme.accentPrimary,
          disabledForegroundColor: theme.colorTheme.disabled,
        ),
        child: Text(context.translations.cancelLabel.toUpperCase()),
      ),
      ValueListenableBuilder(
        valueListenable: _controller,
        builder: (context, poll, child) {
          final isValid = _controller.validate();
          return TextButton(
            onPressed: isValid
                ? () {
                    final errors = _controller.validateGranularly();
                    if (errors.isNotEmpty) {
                      return;
                    }

                    final sanitizedPoll = _controller.sanitizedPoll;
                    return Navigator.of(context).pop(sanitizedPoll);
                  }
                : null,
            style: TextButton.styleFrom(
              textStyle: theme.textTheme.headlineBold,
              foregroundColor: theme.colorTheme.accentPrimary,
              disabledForegroundColor: theme.colorTheme.disabled,
            ),
            child: Text(context.translations.createLabel.toUpperCase()),
          );
        },
      ),
    ];

    return AlertDialog(
      title: Text(
        context.translations.createPollLabel(),
        style: pollCreatorTheme.appBarTitleStyle,
      ),
      titlePadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actions: actions,
      contentPadding: EdgeInsets.zero,
      actionsPadding: const EdgeInsets.all(8),
      backgroundColor: pollCreatorTheme.backgroundColor,
      content: SizedBox(
        width: 640, // Similar to BottomSheet default width on M3
        child: StreamPollCreatorWidget(
          shrinkWrap: true,
          padding: widget.padding,
          controller: _controller,
        ),
      ),
    );
  }
}

/// {@template streamPollCreatorFullScreenDialog}
/// A page that allows users to create a poll.
///
/// The page provides a form to create a poll with a question and multiple
/// options.
///
/// This widget is intended to be used on smaller screens such as mobile phones.
///
/// For larger screens, consider using [StreamPollCreatorDialog].
/// {@endtemplate}
class StreamPollCreatorFullScreenDialog extends StatefulWidget {
  /// {@macro streamPollCreatorFullScreenDialog}
  const StreamPollCreatorFullScreenDialog({
    super.key,
    this.poll,
    this.config,
    this.padding = const EdgeInsets.all(16),
  });

  /// The initial poll to be used in the poll creator.
  final Poll? poll;

  /// The configuration used to validate the poll.
  final PollConfig? config;

  /// The padding around the poll creator.
  final EdgeInsets padding;

  @override
  State<StreamPollCreatorFullScreenDialog> createState() =>
      _StreamPollCreatorFullScreenDialogState();
}

class _StreamPollCreatorFullScreenDialogState
    extends State<StreamPollCreatorFullScreenDialog> {
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

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        elevation: theme.appBarElevation,
        backgroundColor: theme.appBarBackgroundColor,
        title: Text(
          context.translations.createPollLabel(),
          style: theme.appBarTitleStyle,
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, poll, child) {
              final colorTheme = StreamChatTheme.of(context).colorTheme;

              final isValid = _controller.validate();

              return IconButton(
                color: colorTheme.accentPrimary,
                disabledColor: colorTheme.disabled,
                icon: StreamSvgIcon.send().toIconThemeSvgIcon(),
                onPressed: isValid
                    ? () {
                        final errors = _controller.validateGranularly();
                        if (errors.isNotEmpty) {
                          return;
                        }

                        final sanitizedPoll = _controller.sanitizedPoll;
                        return Navigator.of(context).pop(sanitizedPoll);
                      }
                    : null,
              );
            },
          ),
        ],
      ),
      body: StreamPollCreatorWidget(
        padding: widget.padding,
        controller: _controller,
      ),
    );
  }
}
