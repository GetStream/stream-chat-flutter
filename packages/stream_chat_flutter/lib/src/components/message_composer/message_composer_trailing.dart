import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_factory.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamMessageComposerTrailing extends StatelessWidget {
  const StreamMessageComposerTrailing({super.key, required this.props});

  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    return StreamMessageComposerFactory.maybeOf(context)?.trailing?.call(context, props) ?? const SizedBox.shrink();
  }
}
