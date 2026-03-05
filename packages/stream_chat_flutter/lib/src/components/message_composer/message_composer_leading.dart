import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
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
    return context.chatComponentBuilder<MessageComposerLeadingProps>()?.call(
          context,
          MessageComposerLeadingProps.from(props),
        ) ??
        _DefaultStreamMessageComposerLeading(props: props);
  }
}

class _DefaultStreamMessageComposerLeading extends StatelessWidget {
  const _DefaultStreamMessageComposerLeading({required this.props});

  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    // 45 degrees = 0.125 turns
    const closedRotation = 0.125;

    return AnimatedOpacity(
      opacity: props.isAudioRecordingFlowActive ? 0.0 : 1.0,
      duration: props.isAudioRecordingFlowActive ? Duration.zero : const Duration(milliseconds: 200),
      curve: Curves.easeInQuint,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
            if (!props.isAudioRecordingFlowActive) ...[
              AnimatedRotation(
                turns: props.isPickerOpen ? closedRotation : 0,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                child: StreamButton.icon(
                  icon: context.streamIcons.plusLarge,
                  style: StreamButtonStyle.secondary,
                  type: StreamButtonType.outline,
                  size: StreamButtonSize.large,
                  isFloating: props.isFloating,
                  onTap: () {
                    props.onAttachmentButtonPressed?.call();
                  },
                ),
              ),
              SizedBox(width: context.streamSpacing.xs),
            ],
          ],
        ),
      ),
    );
  }
}
