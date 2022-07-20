import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/autocomplete/stream_autocomplete.dart';
import 'package:stream_chat_flutter/src/misc/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';

import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

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
    super.key,
  });

  /// Query for searching commands.
  final String query;

  /// The channel to search for users.
  final Channel channel;

  /// Callback called when a command is selected.
  final ValueSetter<Command>? onCommandSelected;

  @override
  Widget build(BuildContext context) {
    final commands = channel.config?.commands.where((it) {
      final normalizedQuery = query.toUpperCase();
      final normalizedName = it.name.toUpperCase();
      return normalizedName.contains(normalizedQuery);
    });

    if (commands == null || commands.isEmpty) return const SizedBox.shrink();

    final streamChatTheme = StreamChatTheme.of(context);
    final colorTheme = streamChatTheme.colorTheme;
    final textTheme = streamChatTheme.textTheme;

    return StreamAutocompleteOptions<Command>(
      options: commands,
      headerBuilder: (context) {
        return ListTile(
          dense: true,
          horizontalTitleGap: 0,
          leading: StreamSvgIcon.lightning(
            color: colorTheme.accentPrimary,
            size: 28,
          ),
          title: Text(
            context.translations.instantCommandsLabel,
            style: TextStyle(
              color: colorTheme.textHighEmphasis.withOpacity(0.5),
            ),
          ),
        );
      },
      optionBuilder: (context, command) {
        return ListTile(
          dense: true,
          horizontalTitleGap: 0,
          leading: _CommandIcon(command: command),
          title: Row(
            children: [
              Text(
                command.name.capitalize(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
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
          onTap: onCommandSelected == null
              ? null
              : () => onCommandSelected!(command),
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
    final _streamChatTheme = StreamChatTheme.of(context);
    switch (command.name) {
      case 'giphy':
        return CircleAvatar(
          radius: 12,
          child: StreamSvgIcon.giphyIcon(
            size: 24,
          ),
        );
      case 'ban':
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: StreamSvgIcon.iconUserDelete(
            size: 16,
            color: Colors.white,
          ),
        );
      case 'flag':
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: StreamSvgIcon.flag(
            size: 14,
            color: Colors.white,
          ),
        );
      case 'imgur':
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: ClipOval(
            child: StreamSvgIcon.imgur(
              size: 24,
            ),
          ),
        );
      case 'mute':
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: StreamSvgIcon.mute(
            size: 16,
            color: Colors.white,
          ),
        );
      case 'unban':
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: StreamSvgIcon.userAdd(
            size: 16,
            color: Colors.white,
          ),
        );
      case 'unmute':
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: StreamSvgIcon.volumeUp(
            size: 16,
            color: Colors.white,
          ),
        );
      default:
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: StreamSvgIcon.lightning(
            size: 16,
            color: Colors.white,
          ),
        );
    }
  }
}
