import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Widget used to create a poll.
class StreamPollCreator extends StatelessWidget {
  /// Creates a [StreamPollCreator] widget.
  const StreamPollCreator({
    super.key,
    this.poll,
    this.config,
    this.onPollCreated,
  });

  /// The initial poll to be used in the poll creator.
  final Poll? poll;

  /// The configuration used to validate the poll.
  final PollConfig? config;

  /// Callback called when a poll is created.
  final ValueSetter<Poll?>? onPollCreated;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    Future<void> _openCreatePollFlow() async {
      final result = await showStreamPollCreatorDialog(
        context: context,
        poll: poll,
        config: config,
      );

      onPollCreated?.call(result);
    }

    return OptionDrawer(
      child: EndOfFrameCallbackWidget(
        child: StreamSvgIcon.polls(
          size: 180,
          color: theme.colorTheme.disabled,
        ),
        onEndOfFrame: (_) => _openCreatePollFlow(),
        errorBuilder: (context, error, stacktrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamSvgIcon.polls(
                size: 240,
                color: theme.colorTheme.disabled,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _openCreatePollFlow,
                child: Text(
                  context.translations.createPollLabel(isNew: true),
                  style: theme.textTheme.bodyBold.copyWith(
                    color: theme.colorTheme.accentPrimary,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
