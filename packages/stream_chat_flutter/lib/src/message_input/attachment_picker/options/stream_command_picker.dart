import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/options/stream_command_icon.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Widget shown in the attachment picker for browsing and selecting commands.
class StreamCommandPicker extends StatelessWidget {
  /// Creates a [StreamCommandPicker] widget.
  const StreamCommandPicker({
    super.key,
    this.onCommandSelected,
  });

  /// Callback called when a command is selected.
  final ValueSetter<Command>? onCommandSelected;

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    final commands = channel.config?.commands ?? const [];

    final spacing = context.streamSpacing;

    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    return OptionDrawer(
      margin: EdgeInsets.zero,
      child: Material(
        type: .transparency,
        child: Column(
          spacing: spacing.md,
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: .symmetric(horizontal: spacing.md),
              child: Text(context.translations.instantCommandsLabel, style: textTheme.headingSm),
            ),
            Expanded(
              child: ListView.builder(
                padding: .symmetric(horizontal: spacing.xxs, vertical: spacing.xxxs),
                itemCount: commands.length,
                itemBuilder: (context, index) {
                  final command = commands[index];
                  return InkWell(
                    onTap: onCommandSelected == null ? null : () => onCommandSelected!(command),
                    child: Padding(
                      padding: .symmetric(horizontal: spacing.sm, vertical: spacing.xs),
                      child: Row(
                        spacing: spacing.sm,
                        children: [
                          StreamCommandIcon(command: command),
                          Text(
                            command.name.sentenceCase,
                            style: textTheme.bodyEmphasis.copyWith(color: colorScheme.textPrimary),
                          ),
                          Expanded(
                            child: Text(
                              '/${command.name} ${command.args}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyDefault.copyWith(color: colorScheme.textTertiary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
