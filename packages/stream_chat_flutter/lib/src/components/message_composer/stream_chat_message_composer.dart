import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_header.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_leading.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_trailing.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_leading.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_recording_locked.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_recording_ongoing.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_trailing.dart';
import 'package:stream_chat_flutter/src/message_input/dm_checkbox_list_tile.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// A widget that shows the message composer.
/// Uses the factory to show custom components or the default implementation.
class StreamChatMessageComposer extends StatefulWidget {
  /// Creates a new instance of [StreamChatMessageComposer].
  /// [controller] is the controller for the message composer.
  /// [onSendPressed] is the callback for when the send button is pressed.
  /// [onMicrophonePressed] is the callback for when the microphone button is pressed.
  /// [onAttachmentButtonPressed] is the callback for when the attachment button is pressed.
  /// [focusNode] is the focus node for the message composer.
  /// [currentUserId] is the current user id.
  /// [placeholder] is the placeholder text of the message composer.
  StreamChatMessageComposer({
    super.key,
    StreamMessageInputController? controller,
    required VoidCallback onSendPressed,
    VoidCallback? onAttachmentButtonPressed,
    bool isPickerOpen = false,
    FocusNode? focusNode,
    String? currentUserId,
    String placeholder = '',
    StreamAudioRecorderController? audioRecorderController,
    bool sendVoiceRecordingAutomatically = false,
    AudioRecorderFeedback feedback = const AudioRecorderFeedback(),
    bool canAlsoSendToChannel = false,
    VoidCallback? onQuotedMessageCleared,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    bool autofocus = false,
    bool autocorrect = true,
  }) : props = MessageComposerProps(
         controller: controller,
         isFloating: false,
         message: null,
         onSendPressed: onSendPressed,
         onAttachmentButtonPressed: onAttachmentButtonPressed,
         isPickerOpen: isPickerOpen,
         focusNode: focusNode,
         currentUserId: currentUserId,
         placeholder: placeholder,
         audioRecorderController: audioRecorderController,
         sendVoiceRecordingAutomatically: sendVoiceRecordingAutomatically,
         feedback: feedback,
         canAlsoSendToChannel: canAlsoSendToChannel,
         onQuotedMessageCleared: onQuotedMessageCleared,
         textInputAction: textInputAction,
         keyboardType: keyboardType,
         textCapitalization: textCapitalization,
         autofocus: autofocus,
         autocorrect: autocorrect,
       );

  /// The controller for the message composer.
  StreamMessageInputController? get controller => props.controller;

  /// The properties for the message composer.
  final MessageComposerProps props;

  @override
  State<StreamChatMessageComposer> createState() => _StreamChatMessageComposerState();
}

class _StreamChatMessageComposerState extends State<StreamChatMessageComposer> {
  late StreamMessageInputController _controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(StreamChatMessageComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _disposeController(oldWidget);
      _initController();
    }
  }

  @override
  void dispose() {
    _disposeController(widget);
    super.dispose();
  }

  void _initController() {
    _controller = widget.controller ?? StreamMessageInputController();
  }

  void _disposeController(StreamChatMessageComposer widget) {
    if (widget.controller == null) {
      _controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (context.chatComponentBuilder<MessageComposerProps>()?.call(context, widget.props) case final messageComposer?) {
      return messageComposer;
    }

    final audioRecorderController = widget.props.audioRecorderController;
    if (audioRecorderController == null) {
      return DefaultStreamChatMessageComposer(
        props: widget.props,
        inputController: _controller,
      );
    }

    return ValueListenableBuilder(
      valueListenable: audioRecorderController,
      builder: (context, state, _) {
        final body = switch (state) {
          RecordStateRecordingLocked() => MessageComposerRecordingLocked(
            audioRecorderController: audioRecorderController,
            feedback: widget.props.feedback,
            messageInputController: _controller,
            sendMessageCallback: widget.props.sendVoiceRecordingAutomatically ? widget.props.onSendPressed : null,
            state: state,
          ),
          RecordStateStopped() => MessageComposerRecordingStopped(
            audioRecorderController: audioRecorderController,
            feedback: widget.props.feedback,
            messageInputController: _controller,
            sendMessageCallback: widget.props.sendVoiceRecordingAutomatically ? widget.props.onSendPressed : null,
            recordingState: state,
          ),
          RecordStateRecording() => StreamMessageComposerRecordingOngoing(
            audioRecorderController: audioRecorderController,
          ),
          _ => null,
        };

        final streamSpacing = context.streamSpacing;

        return PortalTarget(
          anchor: Aligned(
            offset: Offset(-streamSpacing.md, -streamSpacing.md),
            target: Alignment.topRight,
            follower: Alignment.bottomRight,
          ),
          visible: state is RecordStateRecording,
          portalFollower: SwipeToLockButton(isLocked: state is RecordStateRecordingLocked),
          child: DefaultStreamChatMessageComposer(
            props: widget.props,
            inputController: _controller,
            audioRecorderState: state,
            body: body,
          ),
        );
      },
    );
  }
}

/// Properties to build the main message composer component
class MessageComposerProps {
  /// Creates a new instance of [MessageComposerProps].
  /// [isFloating] is whether the message composer is floating.
  /// [message] is the message for the message composer.
  /// [placeholder] is the placeholder text of the message composer.
  /// [onSendPressed] is the callback for when the send button is pressed.
  /// [onMicrophonePressed] is the callback for when the microphone button is pressed.
  /// [onAttachmentButtonPressed] is the callback for when the attachment button is pressed.
  /// [focusNode] is the focus node for the message composer.
  /// [currentUserId] is the current user id.
  const MessageComposerProps({
    this.controller,
    this.isFloating = false,
    this.message,
    this.placeholder = '',
    required this.onSendPressed,
    this.onAttachmentButtonPressed,
    this.isPickerOpen = false,
    this.focusNode,
    this.currentUserId,
    this.audioRecorderController,
    this.sendVoiceRecordingAutomatically = false,
    this.feedback = const AudioRecorderFeedback(),
    this.canAlsoSendToChannel = false,
    this.onQuotedMessageCleared,
    this.textInputAction,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
    this.autofocus = false,
    this.autocorrect = true,
  });

  /// The controller for the message composer.
  final StreamMessageInputController? controller;

  /// Whether the message composer is floating.
  final bool isFloating;

  /// The message for the message composer.
  final Message? message;

  /// The placeholder text of the message composer.
  final String placeholder;

  /// The callback for when the send button is pressed.
  final VoidCallback onSendPressed;

  /// The callback for when the attachment button is pressed.
  final VoidCallback? onAttachmentButtonPressed;

  /// Whether the inline attachment picker is currently open.
  final bool isPickerOpen;

  /// The focus node for the message composer.
  final FocusNode? focusNode;

  /// The current user id.
  final String? currentUserId;

  /// The audio recorder controller.
  final StreamAudioRecorderController? audioRecorderController;

  /// Whether the voice recording should be sent automatically.
  /// If enabled, the voice recording will be sent automatically when the recording is finished.
  /// If disabled, the voice recording will be added as an attachment to the message
  /// and the user will need to send the message manually.
  final bool sendVoiceRecordingAutomatically;

  /// The feedback for the audio recorder.
  final AudioRecorderFeedback feedback;

  /// Whether the user can also send the message as a direct message.
  /// Usually used in threads.
  final bool canAlsoSendToChannel;

  /// Callback for when the quoted message is cleared.
  final VoidCallback? onQuotedMessageCleared;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// The type of keyboard to use for editing the text.
  final TextInputType? keyboardType;

  /// {@macro flutter.widgets.editableText.textCapitalization}
  final TextCapitalization textCapitalization;

  /// Whether the text field should be focused initially.
  final bool autofocus;

  /// Whether to enable autocorrect.
  final bool autocorrect;
}

extension on StreamAudioRecorderController {
  bool get isRecording => value is RecordStateRecording;
  bool get isLocked => isRecording && value is! RecordStateRecordingHold;
}

/// Default implementation of the message composer.
/// Shows the message composer with the default components.
/// Does not include the audio recording flow in the body.
class DefaultStreamChatMessageComposer extends StatelessWidget {
  /// Creates a new instance of [DefaultStreamChatMessageComposer].
  /// [props] contains the properties for the message composer.
  /// [inputController] is the controller for the message input.
  /// [audioRecorderState] is the state of the audio recorder.
  /// [body] is the body of the message composer.
  const DefaultStreamChatMessageComposer({
    super.key,
    required this.props,
    required this.inputController,
    this.audioRecorderState = const RecordStateIdle(),
    this.body,
  });

  /// The properties for the message composer.
  final MessageComposerProps props;

  /// The controller for the message input.
  final StreamMessageInputController inputController;

  /// The state of the audio recorder.
  /// Used for the microphone button state.
  final AudioRecorderState audioRecorderState;

  /// The body of the message composer.
  final Widget? body;

  /// The threshold to lock the recording.
  static const double _lockRecordThreshold = 50;

  /// The threshold to cancel the recording.
  static const double _cancelRecordThreshold = 75;

  @override
  Widget build(BuildContext context) {
    final componentProps = MessageComposerComponentProps(
      controller: inputController,
      isFloating: props.isFloating,
      message: props.message,
      currentUserId: props.currentUserId,
      onSendPressed: props.onSendPressed,
      voiceRecordingCallback: _createVoiceRecordingCallback(context),
      onAttachmentButtonPressed: props.onAttachmentButtonPressed,
      isPickerOpen: props.isPickerOpen,
      audioRecorderState: audioRecorderState,
      focusNode: props.focusNode,
      onQuotedMessageCleared: props.onQuotedMessageCleared,
    );

    return core.StreamCoreMessageComposer(
      placeholder: props.placeholder,
      controller: inputController.textFieldController,
      isFloating: props.isFloating,
      focusNode: props.focusNode,
      composerLeading: StreamMessageComposerLeading(props: componentProps),
      composerTrailing: StreamMessageComposerTrailing(
        props: componentProps,
      ),
      inputHeader: StreamMessageComposerInputHeader(props: componentProps),
      inputTrailing: StreamMessageComposerInputTrailing(
        props: componentProps,
      ),
      inputLeading: StreamMessageComposerInputLeading(
        props: componentProps,
      ),
      inputBody:
          body ??
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              core.StreamMessageComposerInputField(
                controller: inputController.textFieldController,
                placeholder: props.placeholder,
                focusNode: props.focusNode,
                command: inputController.message.command?.toUpperCase(),
                onDismissCommand: inputController.clear,
                textInputAction: props.textInputAction,
                keyboardType: props.keyboardType,
                textCapitalization: props.textCapitalization,
                autofocus: props.autofocus,
                autocorrect: props.autocorrect,
              ),
              if (props.canAlsoSendToChannel)
                DmCheckboxListTile(
                  value: props.controller?.showInChannel ?? false,
                  // height of list tile is 34px, height of checkbox is 16px, so we need to subtract 8px to make the spacing correct.
                  contentPadding: EdgeInsets.only(
                    right: context.streamSpacing.md,
                    left: context.streamSpacing.md,
                    bottom: context.streamSpacing.md - 8,
                  ),
                  onChanged: (value) => props.controller?.showInChannel = value,
                ),
            ],
          ),
    );
  }

  core.VoiceRecordingCallback? _createVoiceRecordingCallback(BuildContext context) {
    if (props.audioRecorderController case final audioRecorderController?) {
      return core.VoiceRecordingCallback(
        onLongPressStart: () async {
          // Return if the recording is already started.
          if (audioRecorderController.isRecording) return;

          await props.feedback.onRecordStart(context);
          return audioRecorderController.startRecord();
        },
        onLongPressEnd: (_) async {
          // Return if the recording not yet started or already locked.
          if (!audioRecorderController.isRecording || audioRecorderController.isLocked) return;

          await props.feedback.onRecordFinish(context);
          final audio = await audioRecorderController.finishRecord();
          if (audio != null) {
            inputController.addAttachment(audio);
          }

          // Once the recording is finished, cancel the recorder.
          audioRecorderController.cancelRecord(discardTrack: false);

          // Send the message if the user has enabled the option to
          // send the voice recording automatically.
          if (props.sendVoiceRecordingAutomatically) {
            return props.onSendPressed.call();
          }
        },
        onLongPressCancel: () async {
          // Return if the recording is already started.
          if (audioRecorderController.isRecording) return;

          // Notify the parent that the recorder is canceled before it starts.
          await props.feedback.onRecordStartCancel(context);
          // Show a message to the user to hold to record.
          audioRecorderController.showInfo(
            context.translations.holdToRecordLabel,
          );
        },
        onLongPressMoveUpdate: (details) async {
          // Return if the recording not yet started or already locked.
          if (!audioRecorderController.isRecording || audioRecorderController.isLocked) return;
          final dragOffset = details.offsetFromOrigin;

          // Lock recording if the drag offset is greater than the threshold.
          if (dragOffset.dy <= -_lockRecordThreshold) {
            await props.feedback.onRecordLock(context);
            return audioRecorderController.lockRecord();
          }
          // Cancel recording if the drag offset is greater than the threshold.
          if (dragOffset.dx <= -_cancelRecordThreshold) {
            await props.feedback.onRecordCancel(context);
            return audioRecorderController.cancelRecord();
          }

          // Update the drag offset.
          return audioRecorderController.dragRecord(dragOffset);
        },
      );
    }
    return null;
  }
}
