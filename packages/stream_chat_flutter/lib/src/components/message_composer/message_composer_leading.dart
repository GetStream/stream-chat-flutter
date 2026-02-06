import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_factory.dart';
import 'package:stream_chat_flutter/src/components/message_composer/stream_chat_message_composer.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

class StreamMessageComposerLeading extends StatelessWidget {
  const StreamMessageComposerLeading({super.key, required this.props});
  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    return StreamMessageComposerFactory.maybeOf(context)?.leading?.call(context, props) ??
        DefaultStreamMessageComposerLeading(props: props);
  }
}

class DefaultStreamMessageComposerLeading extends StatelessWidget {
  const DefaultStreamMessageComposerLeading({super.key, required this.props});

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
            // TODO: Implement attachment picker
          },
        ),
        SizedBox(width: context.streamSpacing.xs),
      ],
    );
  }
}
