import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

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
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    Future<void> _openCreatePollFlow() async {
      final result = await showStreamPollCreatorDialog(
        context: context,
        poll: poll,
        config: config,
      );

      return onPollCreated?.call(result);
    }

    return OptionDrawer(
      child: EndOfFrameCallbackWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              size: 32,
              context.streamIcons.chart5,
              color: colorScheme.textTertiary,
            ),
            SizedBox(height: spacing.xs),
            Text(
              'Create a poll and let everyone vote!',
              style: textTheme.bodyDefault.copyWith(color: colorScheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.md),
            StreamButton(
              type: .outline,
              style: .secondary,
              onTap: _openCreatePollFlow,
              label: context.translations.createPollLabel(),
            ),
          ],
        ),
        onEndOfFrame: (_) => _openCreatePollFlow(),
        errorBuilder: (context, error, stacktrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                size: 32,
                context.streamIcons.chart5,
                color: colorScheme.textTertiary,
              ),
              SizedBox(height: spacing.md),
              StreamButton(
                type: .outline,
                style: .secondary,
                onTap: _openCreatePollFlow,
                label: context.translations.createPollLabel(isNew: true),
              ),
            ],
          );
        },
      ),
    );
  }
}
