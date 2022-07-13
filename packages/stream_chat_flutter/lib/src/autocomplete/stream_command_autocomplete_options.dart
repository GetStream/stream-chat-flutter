import 'package:flutter/material.dart';
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
    final _streamChatTheme = StreamChatTheme.of(context);

    final commands = channel.config?.commands.where((it) {
      final normalizedQuery = query.toUpperCase();
      final normalizedName = it.name.toUpperCase();
      return normalizedName.contains(normalizedQuery);
    });

    if (commands == null || commands.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      color: _streamChatTheme.colorTheme.barsBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            dense: true,
            horizontalTitleGap: 0,
            leading: StreamSvgIcon.lightning(
              color: _streamChatTheme.colorTheme.accentPrimary,
              size: 28,
            ),
            title: Text(
              context.translations.instantCommandsLabel,
              style: TextStyle(
                color: _streamChatTheme.colorTheme.textHighEmphasis
                    .withOpacity(0.5),
              ),
            ),
          ),
          const Divider(height: 0),
          LimitedBox(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: commands.length,
              itemBuilder: (context, i) {
                final command = commands.elementAt(i);
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
                        style: _streamChatTheme.textTheme.body.copyWith(
                          color: _streamChatTheme.colorTheme.textLowEmphasis,
                        ),
                      ),
                    ],
                  ),
                  onTap: onCommandSelected == null
                      ? null
                      : () => onCommandSelected!(command),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CommandIcon extends StatelessWidget {
  const _CommandIcon({
    super.key,
    required this.command,
  });

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
