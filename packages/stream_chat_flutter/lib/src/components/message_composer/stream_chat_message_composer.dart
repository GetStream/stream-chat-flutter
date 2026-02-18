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
    this.sendVoiceRecordingAutomatically = false,
  }) : props = MessageComposerProps(
         isFloating: false,
         message: null,
         onSendPressed: onSendPressed,
         onAttachmentButtonPressed: onAttachmentButtonPressed,
         focusNode: focusNode,
         currentUserId: currentUserId,
         placeholder: placeholder,
         audioRecorderController: audioRecorderController,
       );

  /// The controller for the message composer.
  final StreamMessageInputController? controller;

  /// The properties for the message composer.
  final MessageComposerProps props;

  /// Whether the voice recording should be sent automatically.
  /// If enabled, the voice recording will be sent automatically when the recording is finished.
  /// If disabled, the voice recording will be added as an attachment to the message
  /// and the user will need to send the message manually.
  final bool sendVoiceRecordingAutomatically;

  @override
  State<StreamChatMessageComposer> createState() => _StreamChatMessageComposerState();
}

class _StreamChatMessageComposerState extends State<StreamChatMessageComposer> {
  late StreamMessageInputController _controller;
  final AudioRecorderFeedback feedback = const AudioRecorderFeedback();

  /// The threshold to lock the recording.
  final double lockRecordThreshold = 50;

  /// The threshold to cancel the recording.
  final double cancelRecordThreshold = 75;

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
    final voiceRecordingCallback = createVoiceRecordingCallback();

    MessageComposerComponentProps componentProps({required AudioRecorderState audioRecorderState}) =>
        MessageComposerComponentProps(
          controller: _controller,
          isFloating: widget.props.isFloating,
          message: widget.props.message,
          currentUserId: widget.props.currentUserId,
          onSendPressed: widget.props.onSendPressed,
          voiceRecordingCallback: voiceRecordingCallback,
          onAttachmentButtonPressed: widget.props.onAttachmentButtonPressed,
          audioRecorderState: audioRecorderState,
          focusNode: widget.props.focusNode,
        );

    Widget createComposer({
      Widget? body,
      AudioRecorderState audioRecorderState = const RecordStateIdle(),
    }) =>
        StreamMessageComposerFactory.maybeOf(context)?.messageComposer?.call(context, widget.props) ??
        core.StreamBaseMessageComposer(
          placeholder: widget.props.placeholder,
          controller: _controller.textFieldController,
          isFloating: widget.props.isFloating,
          focusNode: widget.props.focusNode,
          composerLeading: StreamMessageComposerLeading(props: componentProps(audioRecorderState: audioRecorderState)),
          composerTrailing: StreamMessageComposerTrailing(
            props: componentProps(audioRecorderState: audioRecorderState),
          ),
          inputHeader: StreamMessageComposerInputHeader(props: componentProps(audioRecorderState: audioRecorderState)),
          inputTrailing: StreamMessageComposerInputTrailing(
            props: componentProps(audioRecorderState: audioRecorderState),
          ),
          inputLeading: StreamMessageComposerInputLeading(
            props: componentProps(audioRecorderState: audioRecorderState),
          ),
          inputBody: body,
        );

    if (widget.props.audioRecorderController case final controller?) {
      return ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, state, _) {
          final body = switch (state) {
            RecordStateRecordingLocked() || RecordStateStopped() => MessageComposerRecordingLocked(
              audioRecorderController: controller,
              feedback: feedback,
              messageInputController: _controller,
              sendMessageCallback: widget.sendVoiceRecordingAutomatically ? widget.props.onSendPressed : null,
            ),
            RecordStateRecording() => StreamMessageComposerRecordingOngoing(audioRecorderController: controller),
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
            child: createComposer(body: body, audioRecorderState: state),
          );
        },
      );
    }

    return createComposer();
  }

  core.VoiceRecordingCallback? createVoiceRecordingCallback() {
    if (widget.props.audioRecorderController case final controller?) {
      return core.VoiceRecordingCallback(
        onLongPressStart: () async {
          // Return if the recording is already started.
          if (controller.isRecording) return;

          await feedback.onRecordStart(context);
          return controller.startRecord();
        },
        onLongPressEnd: (_) async {
          // Return if the recording not yet started or already locked.
          if (!controller.isRecording || controller.isLocked) return;

          await feedback.onRecordFinish(context);
          final audio = await controller.finishRecord();
          if (audio != null) {
            _controller.addAttachment(audio);
          }

          // Once the recording is finished, cancel the recorder.
          controller.cancelRecord(discardTrack: false);

          // Send the message if the user has enabled the option to
          // send the voice recording automatically.
          if (widget.sendVoiceRecordingAutomatically) {
            return widget.props.onSendPressed.call();
          }
        },
        onLongPressCancel: () async {
          // Return if the recording is already started.
          if (controller.isRecording) return;

          // Notify the parent that the recorder is canceled before it starts.
          await feedback.onRecordStartCancel(context);
          // Show a message to the user to hold to record.
          controller.showInfo(
            context.translations.holdToRecordLabel,
          );
        },
        onLongPressMoveUpdate: (details) async {
          // Return if the recording not yet started or already locked.
          if (!controller.isRecording || controller.isLocked) return;
          final dragOffset = details.offsetFromOrigin;

          // Lock recording if the drag offset is greater than the threshold.
          if (dragOffset.dy <= -lockRecordThreshold) {
            await feedback.onRecordLock(context);
            return controller.lockRecord();
          }
          // Cancel recording if the drag offset is greater than the threshold.
          if (dragOffset.dx <= -cancelRecordThreshold) {
            await feedback.onRecordCancel(context);
            return controller.cancelRecord();
          }

          // Update the drag offset.
          return controller.dragRecord(dragOffset);
        },
      );
    }
    return null;
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
