import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/options/stream_command_icon.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Caps the card height so a long command list scrolls internally
// instead of pushing the composer / header off the screen.
const _kMaxHeight = 208.0;

/// {@template commands_overlay}
/// Overlay for displaying commands that can be used
/// to interact with the channel.
/// {@endtemplate}
class StreamCommandAutocompleteOptions extends StatelessWidget {
  /// Constructor for creating a [StreamCommandAutocompleteOptions]
  const StreamCommandAutocompleteOptions({
    required this.query,
    required this.channel,
    this.onCommandSelected,
    this.style = AutocompleteOptionsStyle.fixed,
    super.key,
  });

  /// Query for searching commands.
  final String query;

  /// The channel to search for users.
  final Channel channel;

  /// Callback called when a command is selected.
  final ValueSetter<Command>? onCommandSelected;

  /// The visual style of the autocomplete options overlay.
  ///
  /// Defaults to [AutocompleteOptionsStyle.fixed].
  final AutocompleteOptionsStyle style;

  @override
  Widget build(BuildContext context) {
    final commands = channel.config?.commands.where((it) {
      final normalizedQuery = query.toUpperCase();
      final normalizedName = it.name.toUpperCase();
      return normalizedName.contains(normalizedQuery);
    });

    if (commands == null || commands.isEmpty) return const Empty();

    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    final (:elevation, :margin, :shape) = style.resolve(colorScheme.borderDefault);

    return StreamAutocompleteOptions<Command>(
      options: commands,
      maxHeight: _kMaxHeight,
      elevation: elevation,
      margin: margin,
      shape: shape,
      headerBuilder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: context.streamSpacing.sm,
            right: context.streamSpacing.sm,
            top: context.streamSpacing.md,
            bottom: context.streamSpacing.xs,
          ),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              context.translations.instantCommandsLabel,
              style: textTheme.headingXs.copyWith(color: colorScheme.textTertiary),
            ),
          ),
        );
      },
      optionBuilder: (context, command) {
        return ListTile(
          dense: true,
          horizontalTitleGap: context.streamSpacing.sm,
          leading: StreamCommandIcon(command: command),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                command.name.sentenceCase,
                style: textTheme.bodyDefault,
              ),
              SizedBox(height: context.streamSpacing.xxs),
              Text(
                command.description,
                style: textTheme.captionDefault.copyWith(
                  color: colorScheme.textTertiary,
                ),
              ),
            ],
          ),
          onTap: onCommandSelected == null ? null : () => onCommandSelected!(command),
        );
      },
    );
  }
}
