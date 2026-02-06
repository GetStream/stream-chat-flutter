import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_factory.dart';
import 'package:stream_chat_flutter/src/components/message_composer/stream_chat_message_composer.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

class StreamMessageComposerInputTrailing extends StatelessWidget {
  const StreamMessageComposerInputTrailing({super.key, required this.props});

  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    return StreamMessageComposerFactory.maybeOf(context)?.inputTrailing?.call(context, props) ??
        core.StreamMessageComposerInputTrailing(
          controller: props.controller,
          onSendPressed: props.onSendPressed,
          onMicrophonePressed: props.onMicrophonePressed,
        );
  }
}
