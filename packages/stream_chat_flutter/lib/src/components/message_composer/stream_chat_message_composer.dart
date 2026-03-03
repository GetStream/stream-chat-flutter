import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_factory.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_header.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_leading.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_trailing.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_leading.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_recording_locked.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_recording_ongoing.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_trailing.dart';
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
    this.controller,
    required VoidCallback onSendPressed,
    VoidCallback? onAttachmentButtonPressed,
    FocusNode? focusNode,
    String? currentUserId,
    String placeholder = '',
    StreamAudioRecorderController? audioRecorderController,
    bool sendVoiceRecordingAutomatically = false,
    AudioRecorderFeedback feedback = const AudioRecorderFeedback(),
  }) : props = MessageComposerProps(
         isFloating: false,
         message: null,
         onSendPressed: onSendPressed,
         onAttachmentButtonPressed: onAttachmentButtonPressed,
         focusNode: focusNode,
         currentUserId: currentUserId,
         placeholder: placeholder,
         audioRecorderController: audioRecorderController,
         sendVoiceRecordingAutomatically: sendVoiceRecordingAutomatically,
         feedback: feedback,
       );

  /// The controller for the message composer.
  final StreamMessageInputController? controller;

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
    if (StreamMessageComposerFactory.maybeOf(context)?.messageComposer case final messageComposerFactory?) {
      return messageComposerFactory(context, widget.props);
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
    this.isFloating = false,
    this.message,
    this.placeholder = '',
    required this.onSendPressed,
    this.onAttachmentButtonPressed,
    this.focusNode,
    this.currentUserId,
    this.audioRecorderController,
    this.sendVoiceRecordingAutomatically = false,
    this.feedback = const AudioRecorderFeedback(),
  });

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
}

/// Properties to build any of the sub-components.
/// These properties are all the same, so features such as 'add attachment',
/// can be added to any of the sub-components.
class MessageComposerComponentProps {
  /// Creates a new instance of [MessageComposerComponentProps].
  /// [controller] is the controller for the message composer component.
  /// [isFloating] is whether the message composer is floating.
  /// [message] is the message for the message composer component.
  /// [onSendPressed] is the callback for when the send button is pressed.
  /// [onMicrophonePressed] is the callback for when the microphone button is pressed.
  /// [onAttachmentButtonPressed] is the callback for when the attachment button is pressed.
  /// [focusNode] is the focus node for the message composer component.
  /// [currentUserId] is the current user id.
  const MessageComposerComponentProps({
    required this.controller,
    this.isFloating = false,
    this.message,
    required this.onSendPressed,
    this.voiceRecordingCallback,
    this.onAttachmentButtonPressed,
    this.focusNode,
    this.currentUserId,
    this.audioRecorderState = const RecordStateIdle(),
  });

  /// The controller for the message composer component.
  final StreamMessageInputController controller;

  /// Whether the message composer is floating.
  final bool isFloating;

  /// The message for the message composer component.
  final Message? message;

  /// The callback for when the send button is pressed.
  final VoidCallback onSendPressed;

  /// The callback for when the microphone button is pressed.
  final core.VoiceRecordingCallback? voiceRecordingCallback;

  /// The callback for when the attachment button is pressed.
  final VoidCallback? onAttachmentButtonPressed;

  /// The focus node for the message composer component.
  final FocusNode? focusNode;

  /// The current user id.
  final String? currentUserId;

  /// Whether the audio recording flow is active.
  final AudioRecorderState audioRecorderState;

  /// Whether the audio recording flow is active.
  bool get isAudioRecordingFlowActive => audioRecorderState is RecordStateRecording || isAudioRecordingFlowStopped;

  /// Whether the audio recording flow is locked.
  bool get isAudioRecordingFlowLocked => audioRecorderState is RecordStateRecordingLocked;

  /// Whether the audio recording flow is stopped.
  bool get isAudioRecordingFlowStopped => audioRecorderState is RecordStateStopped;
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
      audioRecorderState: audioRecorderState,
      focusNode: props.focusNode,
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
      inputBody: body,
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
