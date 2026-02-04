import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/components/message_composer/stream_chat_message_composer.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

class StreamChatMessageComposerLeading extends StatelessWidget {
  const StreamChatMessageComposerLeading({super.key, required this.data});

  final MessageData? data;

  static StreamComponentBuilder<MessageComposerComponentProps<MessageData>> get factory =>
      (context, props) => StreamChatMessageComposerLeading(data: props.messageData);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StreamButton.icon(
          icon: context.streamIcons.plusLarge,
          style: StreamButtonStyle.secondary,
          type: StreamButtonType.outline,
          size: StreamButtonSize.large,
          onTap: () {
            // TODO: Implement attachment picker
          },
        ),
      ],
    );
  }
}
