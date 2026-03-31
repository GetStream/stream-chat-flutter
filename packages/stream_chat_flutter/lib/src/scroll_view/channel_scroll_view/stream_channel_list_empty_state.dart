import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that is used to display the empty state of the channel list.
class StreamChannelListEmptyState extends StatelessWidget {
  /// Creates a new instance of the [StreamChannelListEmptyState].
  const StreamChannelListEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            context.streamIcons.messageBubbles20,
            size: 32,
          ),
          SizedBox(height: context.streamSpacing.sm),
          Text(context.translations.noConversationsYetText),
        ],
      ),
    );
  }
}
