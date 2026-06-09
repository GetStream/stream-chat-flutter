import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

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
    final icons = context.streamIcons;
    final colorScheme = context.streamColorScheme;

    return IconTheme.merge(
      data: IconThemeData(size: 20, color: colorScheme.textSecondary),
      child: switch (command.name) {
        'giphy' => SvgIcon(icons.giphy),
        'imgur' => SvgIcon(icons.imgur),
        'ban' => Icon(icons.userRemove),
        'flag' => Icon(icons.flag),
        'mute' => Icon(icons.mute),
        'unban' => Icon(icons.userAdd),
        'unmute' => Icon(icons.audio),
        _ => Icon(icons.bolt),
      },
    );
  }
}
