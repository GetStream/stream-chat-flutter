import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_factory.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamMessageComposerInputHeader extends StatelessWidget {
  const StreamMessageComposerInputHeader({super.key, required this.props});

  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    return StreamMessageComposerFactory.maybeOf(context)?.inputHeader?.call(context, props) ??
        DefaultStreamMessageComposerInputHeader(props: props);
  }
}

class DefaultStreamMessageComposerInputHeader extends StatelessWidget {
  const DefaultStreamMessageComposerInputHeader({super.key, required this.props});

  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    // TODO: implement header for attachments and quoted message
    return const SizedBox.shrink();
  }
}
