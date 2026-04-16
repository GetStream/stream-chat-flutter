import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that is used to display the empty state of the message list.
class StreamMessageListEmptyState extends StatelessWidget {
  /// Creates a new instance of the [StreamMessageListEmptyState].
  const StreamMessageListEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            context.streamIcons.messageBubbleLarge,
            size: 32,
          ),
          SizedBox(height: context.streamSpacing.sm),
          Text(context.translations.sendMessageToStartConversationText),
        ],
      ),
    );
  }
}
