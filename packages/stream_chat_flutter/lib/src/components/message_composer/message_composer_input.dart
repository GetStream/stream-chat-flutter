import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_header.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_leading.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_trailing.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_recording_locked.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_recording_ongoing.dart';
import 'package:stream_chat_flutter/src/message_input/dm_checkbox_list_tile.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// A widget that shows the input area of the message composer.
/// Uses the factory to show custom components or the default implementation.
/// By default this contains the text field, attachments preview, and recording UI.
class StreamMessageComposerInput extends StatelessWidget {
  /// Creates a new instance of [StreamMessageComposerInput].
  const StreamMessageComposerInput({super.key, required this.props});

  /// The properties for the message composer component.
  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    return context.chatComponentBuilder<MessageComposerInputProps>()?.call(
          context,
          MessageComposerInputProps.from(props),
        ) ??
        DefaultStreamMessageComposerInput(props: props);
  }
}

/// Default implementation of the input area of the message composer.
///
/// Renders [core.StreamMessageComposerInput] with all chat-specific sub-components
/// wired in. The [inputBody] switches based on [MessageComposerComponentProps.audioRecorderState]:
///
/// - [RecordStateRecordingLocked] → [MessageComposerRecordingLocked]
/// - [RecordStateStopped] → [MessageComposerRecordingStopped]
/// - [RecordStateRecording] → [StreamMessageComposerRecordingOngoing]
/// - otherwise → the default text field with optional "also send to channel" checkbox.
///
/// This class is exported publicly so that consumers who partially customise
/// the composer through [StreamComponentFactory] can reuse it as a building
/// block (for example, wrapping it with additional decoration while keeping
/// the default text-field and recording UI unchanged).
class DefaultStreamMessageComposerInput extends StatelessWidget {
  /// Creates a new instance of [DefaultStreamMessageComposerInput].
  const DefaultStreamMessageComposerInput({super.key, required this.props});

  /// The properties for the message composer component.
  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    return core.StreamMessageComposerInput(
      controller: props.controller.textFieldController,
      placeholder: props.placeholder,
      isFloating: props.isFloating,
      focusNode: props.focusNode,
      inputHeader: StreamMessageComposerInputHeader(props: props),
      inputLeading: StreamMessageComposerInputLeading(props: props),
      inputTrailing: StreamMessageComposerInputTrailing(props: props),
      inputBody: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final audioController = props.audioRecorderController;
    if (audioController == null) return _buildDefaultBody(context);

    return switch (props.audioRecorderState) {
      RecordStateRecordingLocked() => MessageComposerRecordingLocked(
        audioRecorderController: audioController,
        feedback: props.voiceRecordingFeedback,
        messageComposerController: props.controller,
        sendMessageCallback: props.sendVoiceRecordingAutomatically ? props.onSendPressed : null,
        state: props.audioRecorderState as RecordStateRecordingLocked,
      ),
      RecordStateStopped() => MessageComposerRecordingStopped(
        audioRecorderController: audioController,
        feedback: props.voiceRecordingFeedback,
        messageComposerController: props.controller,
        sendMessageCallback: props.sendVoiceRecordingAutomatically ? props.onSendPressed : null,
        recordingState: props.audioRecorderState as RecordStateStopped,
      ),
      RecordStateRecording() => StreamMessageComposerRecordingOngoing(
        audioRecorderController: audioController,
      ),
      _ => _buildDefaultBody(context),
    };
  }

  Widget _buildDefaultBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        core.StreamMessageComposerInputField(
          controller: props.controller.textFieldController,
          placeholder: props.placeholder,
          focusNode: props.focusNode,
          command: props.controller.message.command?.toUpperCase(),
          onDismissCommand: props.controller.clearCommand,
          textInputAction: props.textInputAction,
          keyboardType: props.keyboardType,
          textCapitalization: props.textCapitalization,
          autofocus: props.autofocus,
          autocorrect: props.autocorrect,
        ),
        if (props.canAlsoSendToChannel)
          DmCheckboxListTile(
            value: props.controller.showInChannel,
            contentPadding: EdgeInsets.only(
              right: context.streamSpacing.md,
              left: context.streamSpacing.md,
              bottom: context.streamSpacing.md - 8,
            ),
            onChanged: (value) => props.controller.showInChannel = value,
          ),
      ],
    );
  }
}
