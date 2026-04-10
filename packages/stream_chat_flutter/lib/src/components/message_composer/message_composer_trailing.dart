import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that shows the trailing of the message composer.
/// Uses the factory to show custom components or the default implementation.
/// By default this area is empty.
class StreamMessageComposerTrailing extends StatelessWidget {
  /// Creates a new instance of [StreamMessageComposerTrailing].
  /// [props] contains the properties for the message composer component.
  const StreamMessageComposerTrailing({super.key, required this.props});

  /// The properties for the message composer component.
  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    return context.chatComponentBuilder<MessageComposerTrailingProps>()?.call(
          context,
          MessageComposerTrailingProps.from(props),
        ) ??
        const SizedBox.shrink();
  }
}
