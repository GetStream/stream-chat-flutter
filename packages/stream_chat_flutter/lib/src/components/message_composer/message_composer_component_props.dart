import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

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
    required this.audioRecorderState,
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

/// Properties for building the leading component of the message composer.
class MessageComposerLeadingProps extends MessageComposerComponentProps {
  const MessageComposerLeadingProps._({
    required super.controller,
    required super.isFloating,
    required super.message,
    required super.onSendPressed,
    required super.voiceRecordingCallback,
    required super.onAttachmentButtonPressed,
    required super.focusNode,
    required super.currentUserId,
    required super.audioRecorderState,
  }) : super();

  /// Creates a new instance of [MessageComposerLeadingProps] from a [MessageComposerComponentProps].
  factory MessageComposerLeadingProps.from(MessageComposerComponentProps props) {
    return MessageComposerLeadingProps._(
      controller: props.controller,
      isFloating: props.isFloating,
      message: props.message,
      onSendPressed: props.onSendPressed,
      voiceRecordingCallback: props.voiceRecordingCallback,
      onAttachmentButtonPressed: props.onAttachmentButtonPressed,
      focusNode: props.focusNode,
      currentUserId: props.currentUserId,
      audioRecorderState: props.audioRecorderState,
    );
  }
}

/// Properties for building the trailing component of the message composer.
class MessageComposerTrailingProps extends MessageComposerComponentProps {
  const MessageComposerTrailingProps._({
    required super.controller,
    required super.isFloating,
    required super.message,
    required super.onSendPressed,
    required super.voiceRecordingCallback,
    required super.onAttachmentButtonPressed,
    required super.focusNode,
    required super.currentUserId,
    required super.audioRecorderState,
  }) : super();

  /// Creates a new instance of [MessageComposerTrailingProps] from a [MessageComposerComponentProps].
  factory MessageComposerTrailingProps.from(MessageComposerComponentProps props) {
    return MessageComposerTrailingProps._(
      controller: props.controller,
      isFloating: props.isFloating,
      message: props.message,
      onSendPressed: props.onSendPressed,
      voiceRecordingCallback: props.voiceRecordingCallback,
      onAttachmentButtonPressed: props.onAttachmentButtonPressed,
      focusNode: props.focusNode,
      currentUserId: props.currentUserId,
      audioRecorderState: props.audioRecorderState,
    );
  }
}

/// Properties for building the input component of the message composer.
class MessageComposerInputProps extends MessageComposerComponentProps {
  const MessageComposerInputProps._({
    required super.controller,
    required super.isFloating,
    required super.message,
    required super.onSendPressed,
    required super.voiceRecordingCallback,
    required super.onAttachmentButtonPressed,
    required super.focusNode,
    required super.currentUserId,
    required super.audioRecorderState,
  }) : super();

  /// Creates a new instance of [MessageComposerInputProps] from a [MessageComposerComponentProps].
  factory MessageComposerInputProps.from(MessageComposerComponentProps props) {
    return MessageComposerInputProps._(
      controller: props.controller,
      isFloating: props.isFloating,
      message: props.message,
      onSendPressed: props.onSendPressed,
      voiceRecordingCallback: props.voiceRecordingCallback,
      onAttachmentButtonPressed: props.onAttachmentButtonPressed,
      focusNode: props.focusNode,
      currentUserId: props.currentUserId,
      audioRecorderState: props.audioRecorderState,
    );
  }
}

/// Properties for building the input leading component of the message composer.
class MessageComposerInputLeadingProps extends MessageComposerComponentProps {
  const MessageComposerInputLeadingProps._({
    required super.controller,
    required super.isFloating,
    required super.message,
    required super.onSendPressed,
    required super.voiceRecordingCallback,
    required super.onAttachmentButtonPressed,
    required super.focusNode,
    required super.currentUserId,
    required super.audioRecorderState,
  }) : super();

  /// Creates a new instance of [MessageComposerInputLeadingProps] from a [MessageComposerComponentProps].
  factory MessageComposerInputLeadingProps.from(MessageComposerComponentProps props) {
    return MessageComposerInputLeadingProps._(
      controller: props.controller,
      isFloating: props.isFloating,
      message: props.message,
      onSendPressed: props.onSendPressed,
      voiceRecordingCallback: props.voiceRecordingCallback,
      onAttachmentButtonPressed: props.onAttachmentButtonPressed,
      focusNode: props.focusNode,
      currentUserId: props.currentUserId,
      audioRecorderState: props.audioRecorderState,
    );
  }
}

/// Properties for building the input header component of the message composer.
class MessageComposerInputHeaderProps extends MessageComposerComponentProps {
  const MessageComposerInputHeaderProps._({
    required super.controller,
    required super.isFloating,
    required super.message,
    required super.onSendPressed,
    required super.voiceRecordingCallback,
    required super.onAttachmentButtonPressed,
    required super.focusNode,
    required super.currentUserId,
    required super.audioRecorderState,
  }) : super();

  /// Creates a new instance of [MessageComposerInputHeaderProps] from a [MessageComposerComponentProps].
  factory MessageComposerInputHeaderProps.from(MessageComposerComponentProps props) {
    return MessageComposerInputHeaderProps._(
      controller: props.controller,
      isFloating: props.isFloating,
      message: props.message,
      onSendPressed: props.onSendPressed,
      voiceRecordingCallback: props.voiceRecordingCallback,
      onAttachmentButtonPressed: props.onAttachmentButtonPressed,
      focusNode: props.focusNode,
      currentUserId: props.currentUserId,
      audioRecorderState: props.audioRecorderState,
    );
  }
}

/// Properties for building the input trailing component of the message composer.
class MessageComposerInputTrailingProps extends MessageComposerComponentProps {
  const MessageComposerInputTrailingProps._({
    required super.controller,
    required super.isFloating,
    required super.message,
    required super.onSendPressed,
    required super.voiceRecordingCallback,
    required super.onAttachmentButtonPressed,
    required super.focusNode,
    required super.currentUserId,
    required super.audioRecorderState,
  }) : super();

  /// Creates a new instance of [MessageComposerInputTrailingProps] from a [MessageComposerComponentProps].
  factory MessageComposerInputTrailingProps.from(MessageComposerComponentProps props) {
    return MessageComposerInputTrailingProps._(
      controller: props.controller,
      isFloating: props.isFloating,
      message: props.message,
      onSendPressed: props.onSendPressed,
      voiceRecordingCallback: props.voiceRecordingCallback,
      onAttachmentButtonPressed: props.onAttachmentButtonPressed,
      focusNode: props.focusNode,
      currentUserId: props.currentUserId,
      audioRecorderState: props.audioRecorderState,
    );
  }
}
