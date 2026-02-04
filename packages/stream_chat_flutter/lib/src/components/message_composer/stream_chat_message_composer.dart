import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/components/message_composer/stream_chat_message_composer_leading.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

class StreamChatMessageComposer extends StatelessWidget {
  const StreamChatMessageComposer({super.key});

  static final defaultFactory = StreamMessageComposerFactory<MessageData>(
    leading: StreamChatMessageComposerLeading.factory,
  );

  @override
  Widget build(BuildContext context) {
    return StreamMessageComposer();
  }
}

class StreamChatMessageData extends MessageData {}
