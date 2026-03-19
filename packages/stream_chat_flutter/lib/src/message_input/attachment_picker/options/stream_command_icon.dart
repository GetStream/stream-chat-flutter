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
    const size = 20.0;
    final color = context.streamColorScheme.textSecondary;

    return IconTheme.merge(
      data: IconThemeData(size: size, color: color),
      child: switch (command.name) {
        'giphy' => const StreamSvgIcon(size: size, icon: StreamSvgIcons.giphy),
        'imgur' => const StreamSvgIcon(size: size, icon: StreamSvgIcons.imgur),
        'ban' => Icon(context.streamIcons.peopleRemove),
        'flag' => Icon(context.streamIcons.flag2),
        'mute' => Icon(context.streamIcons.mute),
        'unban' => Icon(context.streamIcons.peopleAdd),
        'unmute' => Icon(context.streamIcons.volumeFull),
        _ => Icon(context.streamIcons.thunder),
      },
    );
  }
}
