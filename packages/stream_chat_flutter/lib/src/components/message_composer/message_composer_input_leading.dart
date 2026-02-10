import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_factory.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamMessageComposerInputLeading extends StatelessWidget {
  const StreamMessageComposerInputLeading({super.key, required this.props});

  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    return StreamMessageComposerFactory.maybeOf(context)?.inputLeading?.call(context, props) ??
        DefaultStreamMessageComposerInputLeading(props: props);
  }
}

class DefaultStreamMessageComposerInputLeading extends StatelessWidget {
  const DefaultStreamMessageComposerInputLeading({super.key, required this.props});

  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    // Doesn't show anything by default
    return const SizedBox.shrink();
  }
}
