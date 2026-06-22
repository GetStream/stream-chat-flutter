import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_recording_locked.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_recording_ongoing.dart';
import 'package:stream_chat_flutter/src/message_input/dm_checkbox_list_tile.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that shows the center content of the message composer input area.
/// Uses the factory to show custom components or the default implementation.
/// By default shows the text field and an optional "also send to channel"
/// checkbox, or the appropriate audio recording UI when recording is active.
class StreamMessageComposerInputCenter extends StatelessWidget {
  /// Creates a new instance of [StreamMessageComposerInputCenter].
  /// [props] contains the full input properties including text field
  /// configuration and audio recording settings.
  const StreamMessageComposerInputCenter({super.key, required this.props});

  /// The properties for the message composer input center.
  final MessageComposerInputCenterProps props;

  @override
  Widget build(BuildContext context) {
    return context.chatComponentBuilder<MessageComposerInputCenterProps>()?.call(context, props) ??
        DefaultStreamMessageComposerInputCenter(props: props);
  }
}

/// Default implementation of the center content of the message composer input.
///
/// Shows the appropriate audio recording UI when a recording state is active,
/// or the text input field (and an optional "also send to channel" checkbox)
/// when idle.
class DefaultStreamMessageComposerInputCenter extends StatelessWidget {
  /// Creates a new instance of [DefaultStreamMessageComposerInputCenter].
  const DefaultStreamMessageComposerInputCenter({super.key, required this.props});

  /// The properties for the message composer input center.
  final MessageComposerInputCenterProps props;

  @override
  Widget build(BuildContext context) {
    final recorder = props.audioRecorderController;
    if (recorder != null) {
      final sendMessageCallback = props.sendVoiceRecordingAutomatically ? props.onSendPressed : null;
      final audioState = props.audioRecorderState;

      final recordingBody = switch (audioState) {
        RecordStateRecordingLocked() => MessageComposerRecordingLocked(
          audioRecorderController: recorder,
          feedback: props.feedback,
          messageComposerController: props.controller,
          sendMessageCallback: sendMessageCallback,
          state: audioState,
        ),
        RecordStateStopped() => MessageComposerRecordingStopped(
          audioRecorderController: recorder,
          feedback: props.feedback,
          messageComposerController: props.controller,
          sendMessageCallback: sendMessageCallback,
          recordingState: audioState,
        ),
        RecordStateRecording() => StreamMessageComposerRecordingOngoing(
          audioRecorderController: recorder,
        ),
        _ => null,
      };

      if (recordingBody != null) return recordingBody;
    }

    final controller = props.controller;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamMessageComposerInputField(
          controller: controller.textFieldController,
          placeholder: props.placeholder,
          focusNode: props.focusNode,
          command: controller.message.command?.toUpperCase(),
          onDismissCommand: controller.clearCommand,
          textInputAction: props.textInputAction,
          keyboardType: props.keyboardType,
          textCapitalization: props.textCapitalization,
          autofocus: props.autofocus,
          autocorrect: props.autocorrect,
          enabled: !props.isSlowModeActive,
        ),
        if (props.canAlsoSendToChannel)
          DmCheckboxListTile(
            value: controller.showInChannel,
            // height of list tile is 34px, height of checkbox is 16px, so we need to subtract 8px to make the spacing correct.
            contentPadding: EdgeInsets.only(
              right: context.streamSpacing.md,
              left: context.streamSpacing.md,
              bottom: context.streamSpacing.md - 8,
            ),
            onChanged: props.isSlowModeActive ? null : (value) => controller.showInChannel = value,
          ),
      ],
    );
  }
}
