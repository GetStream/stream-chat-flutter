import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Fills the channel pane while no channel is open.
class ChannelPlaceholderPage extends StatelessWidget {
  const ChannelPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final colorScheme = context.streamColorScheme;

    return StreamScaffold(
      backgroundColor: colorScheme.backgroundApp,
      body: Center(
        child: StreamScrollViewEmptyWidget(
          emptyIcon: Icon(icons.messageBubblesLarge),
          emptyTitle: const Text('Select a chat'),
        ),
      ),
    );
  }
}
