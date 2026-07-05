import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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

        if (props.isSlowModeActive) {
          return _SlowModeCountdownButton(
            key: _slowModeKey,
            cooldownTimeOut: props.cooldownTimeOut!,
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
        if (buttonState == .send || buttonState == .edit || buttonState == .command || voiceRecordingCallback == null) {
          final a11y = context.translations.accessibility;
          return StreamButton.icon(
            key: _sendKey,
            icon: switch (buttonState) {
              .edit || .command => Icon(context.streamIcons.checkmark),
              _ => Icon(context.streamIcons.send),
            },
            size: StreamButtonSize.small,
            tooltip: switch (buttonState) {
              .edit => a11y.saveEditTooltip,
              .command => a11y.sendCommandTooltip,
              _ => a11y.sendMessageTooltip,
            },
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
    final a11y = context.translations.accessibility;
    return StreamButton.icon(
      icon: Text('$cooldownTimeOut'),
      tooltip: a11y.slowModeTooltip(seconds: cooldownTimeOut),
      style: StreamButtonStyle.secondary,
      size: StreamButtonSize.small,
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
    final microphoneButton = GestureDetector(
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
          onPressed: voiceRecordingCallback.onLongPressCancel,
        ),
      ),
    );

    final a11y = context.translations.accessibility;
    return Semantics(
      button: true,
      container: true,
      excludeSemantics: true,
      label: a11y.recordVoiceRecordingLabel,
      onLongPressHint: a11y.recordVoiceRecordingLabel,
      onTap: voiceRecordingCallback.onLongPressCancel,
      onLongPress: voiceRecordingCallback.onLongPressStart,
      child: microphoneButton,
    );
  }
}

const _sendKey = ValueKey('send_key');
const _microphoneKey = ValueKey('microphone_key');
const _slowModeKey = ValueKey('slow_mode_key');
