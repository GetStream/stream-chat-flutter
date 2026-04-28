import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    return context.chatComponentBuilder<MessageComposerInputTrailingProps>()?.call(
          context,
          MessageComposerInputTrailingProps.from(props),
        ) ??
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

  StreamMessageComposerController get _controller => props.controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, value, child) {
        final hasText = _controller.text.trim().isNotEmpty;
        final hasContent = hasText || _controller.attachments.isNotEmpty;
        final isEditing = _controller.isEditing;
        final hasCommand = _controller.message.command != null;
        var buttonState = StreamMessageComposerInputTrailingState.microphone;
        if (props.isAudioRecordingFlowActive) {
          buttonState = StreamMessageComposerInputTrailingState.voiceRecordingActive;
        }

        if (isEditing) {
          buttonState = StreamMessageComposerInputTrailingState.edit;
        } else if (hasCommand) {
          buttonState = StreamMessageComposerInputTrailingState.command;
        } else if (hasContent) {
          buttonState = StreamMessageComposerInputTrailingState.send;
        }

        final isEnabled = (!isEditing && !hasCommand) || hasContent;

        return props.isAudioRecordingFlowLocked || props.isAudioRecordingFlowStopped
            ? const SizedBox.shrink()
            : StreamCoreMessageComposerInputTrailing(
                controller: _controller.textFieldController,
                onSendPressed: isEnabled ? props.onSendPressed : null,
                voiceRecordingCallback: props.voiceRecordingCallback,
                buttonState: buttonState,
              );
      },
    );
  }
}
