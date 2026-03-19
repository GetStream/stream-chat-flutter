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

    final textTheme = StreamChatTheme.of(context).textTheme;
    final colorTheme = StreamChatTheme.of(context).colorTheme;
    final spacing = context.streamSpacing;

    return OptionDrawer(
      margin: EdgeInsets.zero,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing.md),
        child: Text(
          context.translations.instantCommandsLabel,
          style: textTheme.headlineBold,
        ),
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: commands.length,
        itemBuilder: (context, index) {
          final command = commands[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onCommandSelected == null ? null : () => onCommandSelected!(command),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.sm, vertical: spacing.xs),
                child: Row(
                  spacing: spacing.sm,
                  children: [
                    StreamCommandIcon(command: command),
                    Text(
                      command.name.sentenceCase,
                      style: textTheme.bodyBold.copyWith(
                        color: colorTheme.textHighEmphasis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        command.args,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.body.copyWith(
                          color: colorTheme.textLowEmphasis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
