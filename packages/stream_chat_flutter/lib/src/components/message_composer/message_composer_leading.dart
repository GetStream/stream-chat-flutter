import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_factory.dart';
import 'package:stream_chat_flutter/src/components/message_composer/stream_chat_message_composer.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// A widget that shows the leading of the message composer.
/// Uses the factory to show custom components or the default implementation.
/// By default this contains a button to add attachments.
class StreamMessageComposerLeading extends StatelessWidget {
  /// Creates a new instance of [StreamMessageComposerLeading].
  /// [props] contains the properties for the message composer component.
  const StreamMessageComposerLeading({super.key, required this.props});

  /// The properties for the message composer component.
  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    return StreamMessageComposerFactory.maybeOf(context)?.leading?.call(context, props) ??
        _DefaultStreamMessageComposerLeading(props: props);
  }
}

class _DefaultStreamMessageComposerLeading extends StatelessWidget {
  const _DefaultStreamMessageComposerLeading({required this.props});

  final MessageComposerComponentProps props;

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
            props.onAttachmentButtonPressed?.call();
          },
        ),
        SizedBox(width: context.streamSpacing.xs),
      ],
    );
  }
}
