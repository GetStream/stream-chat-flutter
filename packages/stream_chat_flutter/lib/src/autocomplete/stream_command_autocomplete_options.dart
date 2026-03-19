import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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

    final streamChatTheme = StreamChatTheme.of(context);
    final colorTheme = streamChatTheme.colorTheme;
    final textTheme = streamChatTheme.textTheme;

    final (elevation, margin, shape) = switch (style) {
      AutocompleteOptionsStyle.fixed => (
        0.0,
        EdgeInsets.zero,
        const RoundedRectangleBorder() as ShapeBorder,
      ),
      AutocompleteOptionsStyle.floating => (
        4.0,
        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            )
            as ShapeBorder,
      ),
    };

    return StreamAutocompleteOptions<Command>(
      options: commands,
      elevation: elevation,
      margin: margin,
      shape: shape,
      headerBuilder: (context) {
        return ListTile(
          dense: true,
          horizontalTitleGap: 0,
          leading: Icon(
            context.streamIcons.thunder,
            color: colorTheme.accentPrimary,
            size: 28,
          ),
          title: Text(
            context.translations.instantCommandsLabel,
            style: textTheme.body.copyWith(
              color: colorTheme.textLowEmphasis,
            ),
          ),
        );
      },
      optionBuilder: (context, command) {
        return ListTile(
          dense: true,
          horizontalTitleGap: 8,
          leading: _CommandIcon(command: command),
          title: Row(
            children: [
              Text(
                command.name.sentenceCase,
                style: textTheme.bodyBold.copyWith(
                  color: colorTheme.textHighEmphasis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '/${command.name} ${command.args}',
                style: textTheme.body.copyWith(
                  color: colorTheme.textLowEmphasis,
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

class _CommandIcon extends StatelessWidget {
  const _CommandIcon({required this.command});

  final Command command;

  @override
  Widget build(BuildContext context) {
    final colorTheme = StreamChatTheme.of(context).colorTheme;
    switch (command.name) {
      case 'giphy':
        return const StreamSvgIcon(size: 20, icon: StreamSvgIcons.giphy);
      case 'imgur':
        return const StreamSvgIcon(size: 20, icon: StreamSvgIcons.imgur);
      case 'ban':
        return Icon(context.streamIcons.peopleRemove, size: 20, color: colorTheme.textHighEmphasis);
      case 'flag':
        return Icon(context.streamIcons.flag2, size: 20, color: colorTheme.textHighEmphasis);
      case 'mute':
        return Icon(context.streamIcons.mute, size: 20, color: colorTheme.textHighEmphasis);
      case 'unban':
        return Icon(context.streamIcons.peopleAdd, size: 20, color: colorTheme.textHighEmphasis);
      case 'unmute':
        return Icon(context.streamIcons.volumeFull, size: 20, color: colorTheme.textHighEmphasis);
      default:
        return Icon(context.streamIcons.thunder, size: 20, color: colorTheme.textHighEmphasis);
    }
  }
}
