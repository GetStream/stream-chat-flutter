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
    final trailingProps = MessageComposerInputTrailingProps.from(props);

    return context.chatComponentBuilder<MessageComposerInputTrailingProps>()?.call(context, trailingProps) ??
        DefaultStreamMessageComposerInputTrailing(props: trailingProps);
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
        if (props.isAudioRecordingFlowLocked || props.isAudioRecordingFlowStopped) {
          return const SizedBox.shrink();
        }

        if (_controller.isSlowModeActive) {
          return _SlowModeCountdownButton(
            key: _slowModeKey,
            cooldownTimeOut: _controller.cooldownTimeOut,
          );
        }

        final hasText = _controller.text.trim().isNotEmpty;
        final hasContent = hasText || _controller.attachments.isNotEmpty;
        final isEditing = _controller.isEditing;
        final hasCommand = _controller.message.command != null;
        var buttonState = _ButtonState.microphone;
        if (props.isAudioRecordingFlowActive) {
          buttonState = _ButtonState.voiceRecordingActive;
        }

        if (isEditing) {
          buttonState = _ButtonState.edit;
        } else if (hasCommand) {
          buttonState = _ButtonState.command;
        } else if (hasContent) {
          buttonState = _ButtonState.send;
        }

        final isEnabled = (!isEditing && !hasCommand) || hasContent;

        final voiceRecordingCallback = props.voiceRecordingCallback;
        if (buttonState == _ButtonState.send ||
            buttonState == _ButtonState.edit ||
            buttonState == _ButtonState.command ||
            voiceRecordingCallback == null) {
          return StreamButton.icon(
            key: _sendKey,
            icon: Icon(
              buttonState == _ButtonState.edit || buttonState == _ButtonState.command
                  ? context.streamIcons.checkmark
                  : context.streamIcons.send,
            ),
            size: StreamButtonSize.small,
            onPressed: isEnabled ? props.onSendPressed : null,
          );
        }

        return _VoiceRecordingButton(
          voiceRecordingCallback: voiceRecordingCallback,
          isRecording: buttonState == _ButtonState.voiceRecordingActive,
        );
      },
    );
  }
}

enum _ButtonState {
  send,
  edit,
  command,
  microphone,
  voiceRecordingActive,
}

class _SlowModeCountdownButton extends StatelessWidget {
  const _SlowModeCountdownButton({super.key, required this.cooldownTimeOut});

  final int cooldownTimeOut;

  @override
  Widget build(BuildContext context) {
    return StreamButton.icon(
      icon: Text('$cooldownTimeOut'),
      style: StreamButtonStyle.secondary,
      size: StreamButtonSize.small,
      onPressed: null,
    );
  }
}

class _VoiceRecordingButton extends StatelessWidget {
  const _VoiceRecordingButton({
    required this.voiceRecordingCallback,
    required this.isRecording,
  });

  final VoiceRecordingCallback voiceRecordingCallback;
  final bool isRecording;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _microphoneKey,
      onLongPress: voiceRecordingCallback.onLongPressStart,
      onLongPressCancel: voiceRecordingCallback.onLongPressCancel,
      onLongPressEnd: voiceRecordingCallback.onLongPressEnd,
      onLongPressMoveUpdate: voiceRecordingCallback.onLongPressMoveUpdate,
      behavior: HitTestBehavior.translucent,
      child: StreamButtonTheme(
        data: StreamButtonThemeData(
          secondary: StreamButtonTypeStyle(
            ghost: StreamButtonThemeStyle(
              backgroundColor: isRecording
                  ? WidgetStateProperty.all(
                      context.streamColorScheme.backgroundPressed,
                    )
                  : null,
            ),
          ),
        ),
        child: StreamButton.icon(
          icon: Icon(context.streamIcons.voice),
          type: StreamButtonType.ghost,
          style: StreamButtonStyle.secondary,
          size: StreamButtonSize.small,
          onPressed: () {},
        ),
      ),
    );
  }
}

final _sendKey = UniqueKey();
final _microphoneKey = UniqueKey();
final _slowModeKey = UniqueKey();
