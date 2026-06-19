import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/options/stream_command_icon.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Caps the card height so a long command list scrolls internally
// instead of pushing the composer / header off the screen.
const _kMaxHeight = 208.0;

/// Predicate returning the [CommandUnavailableReason] for [command] in the
/// current composer context, or `null` if the command is available.
///
/// Modeled on [FormFieldValidator]: returning `null` means "ok", returning a
/// non-null value carries the reason for the failure so callers can act on
/// it (e.g. surface an explanation).
typedef CommandValidator = CommandUnavailableReason? Function(Command command);

/// {@template commands_overlay}
/// Overlay for displaying commands that can be used
/// to interact with the channel.
/// {@endtemplate}
class StreamCommandAutocompleteOptions extends StatelessWidget {
  /// Constructor for creating a [StreamCommandAutocompleteOptions]
  const StreamCommandAutocompleteOptions({
    super.key,
    required this.query,
    required this.channel,
    this.commandValidator,
    this.onCommandSelected,
    this.style = .fixed,
  });

  /// Query for searching commands.
  final String query;

  /// The channel to search for users.
  final Channel channel;

  /// Resolves whether a command is available in the current composer state.
  ///
  /// Returns `null` when the command is enabled and selectable. A non-null
  /// [CommandUnavailableReason] marks the row as dimmed; the row is still
  /// tappable so [onCommandSelected] can decide what to do.
  ///
  /// When `null`, all commands are treated as enabled.
  final CommandValidator? commandValidator;

  /// Called when the user taps a command row.
  ///
  /// Fires for every row, including ones [commandValidator] flagged as disabled.
  /// Re-run the commandValidator inside the callback to branch on availability
  /// (e.g. activate the command vs. surface a snackbar explaining why it
  /// can't be activated).
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
        final reason = commandValidator?.call(command);
        final tile = ListTile(
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

        if (reason == null) return tile;
        return Opacity(opacity: 0.38, child: tile);
      },
    );
  }
}
