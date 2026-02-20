import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_factory.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

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

/// Default implementation of the input trailing of the message composer.
/// Shows the send button or the microphone button based on the state of the message composer.
/// It shows no button when the audio recording flow is locked or stopped.
class DefaultStreamMessageComposerInputTrailing extends StatelessWidget {
  /// Creates a new instance of [DefaultStreamMessageComposerInputTrailing].
  /// [props] contains the properties for the message composer component.
  const DefaultStreamMessageComposerInputTrailing({super.key, required this.props});

  /// The properties for the message composer component.
  final MessageComposerComponentProps props;

  StreamMessageInputController get _controller => props.controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, value, child) {
        final hasText = _controller.text.isNotEmpty;
        var buttonState = StreamMessageComposerInputTrailingState.microphone;
        if (props.isAudioRecordingFlowActive) {
          buttonState = StreamMessageComposerInputTrailingState.voiceRecordingActive;
        }

        if (hasText || _controller.attachments.isNotEmpty) {
          buttonState = StreamMessageComposerInputTrailingState.send;
        }

        return props.isAudioRecordingFlowLocked || props.isAudioRecordingFlowStopped
            ? const SizedBox.shrink()
            : StreamCoreMessageComposerInputTrailing(
                controller: _controller.textFieldController,
                onSendPressed: props.onSendPressed,
                voiceRecordingCallback: props.voiceRecordingCallback,
                buttonState: buttonState,
              );
      },
    );
  }
}
