import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_factory.dart';
import 'package:stream_chat_flutter/src/components/message_composer/stream_chat_message_composer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// A widget that shows the input trailing of the message composer.
/// Uses the factory to show custom components or the default implementation.
/// By default it shows the send button and the microphone button.
class StreamMessageComposerInputTrailing extends StatelessWidget {
  /// Creates a new instance of [StreamMessageComposerInputTrailing].
  /// [props] contains the properties for the message composer component.
  const StreamMessageComposerInputTrailing({super.key, required this.props});

  /// The properties for the message composer component.
  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    return StreamMessageComposerFactory.maybeOf(context)?.inputTrailing?.call(context, props) ??
        DefaultStreamMessageComposerInputTrailing(props: props);
  }
}

class DefaultStreamMessageComposerInputTrailing extends StatelessWidget {
  const DefaultStreamMessageComposerInputTrailing({super.key, required this.props});

  /// The properties for the message composer component.
  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      anchor: const Aligned(
        offset: Offset(4, -16),
        target: Alignment.bottomRight,
        follower: Alignment.bottomRight,
      ),
      visible: false,
      portalFollower: SwipeToLockButton(isLocked: props.audioRecorderState is RecordStateRecordingLocked),
      child: props.isAudioRecordingFlowLocked || props.isAudioRecordingFlowStopped
          ? const SizedBox.shrink()
          : core.StreamMessageComposerInputTrailing(
              controller: props.controller.textFieldController,
              onSendPressed: props.onSendPressed,
              voiceRecordingCallback: props.voiceRecordingCallback,
              isRecording: props.isAudioRecordingFlowActive,
            ),
    );
  }
}
