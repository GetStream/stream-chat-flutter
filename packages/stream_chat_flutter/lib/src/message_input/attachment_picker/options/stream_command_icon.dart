import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// An icon widget for a chat command.
///
/// Displays a 20px icon matching the given [command] name.
class StreamCommandIcon extends StatelessWidget {
  /// Creates a [StreamCommandIcon].
  const StreamCommandIcon({super.key, required this.command});

  /// The command whose icon is displayed.
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
