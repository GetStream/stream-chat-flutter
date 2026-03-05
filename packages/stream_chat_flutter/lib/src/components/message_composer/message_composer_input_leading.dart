import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that shows the input leading of the message composer.
/// Uses the factory to show custom components, but is empty by default.
class StreamMessageComposerInputLeading extends StatelessWidget {
  /// Creates a new instance of [StreamMessageComposerInputLeading].
  /// [props] contains the properties for the message composer component.
  const StreamMessageComposerInputLeading({super.key, required this.props});

  /// The properties for the message composer component.
  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    return context.chatComponentBuilder<MessageComposerInputLeadingProps>()?.call(
          context,
          MessageComposerInputLeadingProps.from(props),
        ) ??
        const SizedBox.shrink();
  }
}
