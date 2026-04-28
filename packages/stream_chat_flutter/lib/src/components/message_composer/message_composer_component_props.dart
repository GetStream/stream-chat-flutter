import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// Properties to build any of the sub-components.
/// These properties are all the same, so features such as 'add attachment',
/// can be added to any of the sub-components.
class MessageComposerComponentProps {
  /// Creates a new instance of [MessageComposerComponentProps].
  const MessageComposerComponentProps({
    required this.controller,
    this.isFloating = false,
    this.message,
    required this.onSendPressed,
    this.voiceRecordingCallback,
    this.onAttachmentButtonPressed,
    this.isPickerOpen = false,
    this.focusNode,
    this.currentUserId,
    required this.audioRecorderState,
    this.onQuotedMessageCleared,
    this.canAlsoSendToChannel = false,
    this.textInputAction,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
    this.autofocus = false,
    this.autocorrect = true,
    this.audioRecorderController,
    this.voiceRecordingFeedback = const AudioRecorderFeedback(),
    this.sendVoiceRecordingAutomatically = false,
    this.placeholder = '',
  });

  /// The controller for the message composer component.
  final StreamMessageComposerController controller;

  /// Whether the message composer is floating.
  final bool isFloating;

  /// The message for the message composer component.
  final Message? message;

  /// The callback for when the send button is pressed.
  final VoidCallback onSendPressed;

  /// The callback for voice recording interactions.
  final core.VoiceRecordingCallback? voiceRecordingCallback;

  /// The callback for when the attachment button is pressed.
  final VoidCallback? onAttachmentButtonPressed;

  /// Whether the inline attachment picker is currently open.
  final bool isPickerOpen;

  /// The focus node for the message composer component.
  final FocusNode? focusNode;

  /// The current user id.
  final String? currentUserId;

  /// The current state of the audio recorder.
  final AudioRecorderState audioRecorderState;

  /// Callback for when the quoted message is cleared.
  final VoidCallback? onQuotedMessageCleared;

  /// Show "also send to channel" checkbox in threads.
  final bool canAlsoSendToChannel;

  /// Keyboard action button type.
  final TextInputAction? textInputAction;

  /// Keyboard type.
  final TextInputType? keyboardType;

  /// Text capitalisation mode.
  final TextCapitalization textCapitalization;

  /// Auto-focus the text field.
  final bool autofocus;

  /// Enable autocorrect.
  final bool autocorrect;

  /// The audio recorder controller, present when voice recording is enabled.
  final StreamAudioRecorderController? audioRecorderController;

  /// Haptic/audio feedback for voice-recording interactions.
  final AudioRecorderFeedback voiceRecordingFeedback;

  /// Whether to automatically send voice recordings after finishing.
  final bool sendVoiceRecordingAutomatically;

  /// Placeholder text shown in the input field when empty.
  final String placeholder;

  /// Whether the audio recording flow is active.
  bool get isAudioRecordingFlowActive => audioRecorderState is RecordStateRecording || isAudioRecordingFlowStopped;

  /// Whether the audio recording flow is locked.
  bool get isAudioRecordingFlowLocked => audioRecorderState is RecordStateRecordingLocked;

  /// Whether the audio recording flow is stopped.
  bool get isAudioRecordingFlowStopped => audioRecorderState is RecordStateStopped;
}

// ---------------------------------------------------------------------------
// Specialised subclasses — thin wrappers used to route props to the correct
// factory in StreamComponentFactory.
// ---------------------------------------------------------------------------

/// Properties for building the leading component of the message composer.
class MessageComposerLeadingProps extends MessageComposerComponentProps {
  // ignore: prefer_const_constructors_in_immutables
  MessageComposerLeadingProps._({required super.controller, required super.onSendPressed, required super.audioRecorderState, super.isFloating, super.message, super.voiceRecordingCallback, super.onAttachmentButtonPressed, super.isPickerOpen, super.focusNode, super.currentUserId, super.onQuotedMessageCleared, super.canAlsoSendToChannel, super.textInputAction, super.keyboardType, super.textCapitalization, super.autofocus, super.autocorrect, super.audioRecorderController, super.voiceRecordingFeedback, super.sendVoiceRecordingAutomatically, super.placeholder});

  /// Creates a [MessageComposerLeadingProps] from [props].
  factory MessageComposerLeadingProps.from(MessageComposerComponentProps props) =>
      MessageComposerLeadingProps._(
        controller: props.controller,
        isFloating: props.isFloating,
        message: props.message,
        onSendPressed: props.onSendPressed,
        voiceRecordingCallback: props.voiceRecordingCallback,
        onAttachmentButtonPressed: props.onAttachmentButtonPressed,
        isPickerOpen: props.isPickerOpen,
        focusNode: props.focusNode,
        currentUserId: props.currentUserId,
        audioRecorderState: props.audioRecorderState,
        onQuotedMessageCleared: props.onQuotedMessageCleared,
        canAlsoSendToChannel: props.canAlsoSendToChannel,
        textInputAction: props.textInputAction,
        keyboardType: props.keyboardType,
        textCapitalization: props.textCapitalization,
        autofocus: props.autofocus,
        autocorrect: props.autocorrect,
        audioRecorderController: props.audioRecorderController,
        voiceRecordingFeedback: props.voiceRecordingFeedback,
        sendVoiceRecordingAutomatically: props.sendVoiceRecordingAutomatically,
        placeholder: props.placeholder,
      );
}

/// Properties for building the trailing component of the message composer.
class MessageComposerTrailingProps extends MessageComposerComponentProps {
  // ignore: prefer_const_constructors_in_immutables
  MessageComposerTrailingProps._({required super.controller, required super.onSendPressed, required super.audioRecorderState, super.isFloating, super.message, super.voiceRecordingCallback, super.onAttachmentButtonPressed, super.isPickerOpen, super.focusNode, super.currentUserId, super.onQuotedMessageCleared, super.canAlsoSendToChannel, super.textInputAction, super.keyboardType, super.textCapitalization, super.autofocus, super.autocorrect, super.audioRecorderController, super.voiceRecordingFeedback, super.sendVoiceRecordingAutomatically, super.placeholder});

  /// Creates a [MessageComposerTrailingProps] from [props].
  factory MessageComposerTrailingProps.from(MessageComposerComponentProps props) =>
      MessageComposerTrailingProps._(
        controller: props.controller,
        isFloating: props.isFloating,
        message: props.message,
        onSendPressed: props.onSendPressed,
        voiceRecordingCallback: props.voiceRecordingCallback,
        onAttachmentButtonPressed: props.onAttachmentButtonPressed,
        isPickerOpen: props.isPickerOpen,
        focusNode: props.focusNode,
        currentUserId: props.currentUserId,
        audioRecorderState: props.audioRecorderState,
        onQuotedMessageCleared: props.onQuotedMessageCleared,
        canAlsoSendToChannel: props.canAlsoSendToChannel,
        textInputAction: props.textInputAction,
        keyboardType: props.keyboardType,
        textCapitalization: props.textCapitalization,
        autofocus: props.autofocus,
        autocorrect: props.autocorrect,
        audioRecorderController: props.audioRecorderController,
        voiceRecordingFeedback: props.voiceRecordingFeedback,
        sendVoiceRecordingAutomatically: props.sendVoiceRecordingAutomatically,
        placeholder: props.placeholder,
      );
}

/// Properties for building the input component of the message composer.
class MessageComposerInputProps extends MessageComposerComponentProps {
  // ignore: prefer_const_constructors_in_immutables
  MessageComposerInputProps._({required super.controller, required super.onSendPressed, required super.audioRecorderState, super.isFloating, super.message, super.voiceRecordingCallback, super.onAttachmentButtonPressed, super.isPickerOpen, super.focusNode, super.currentUserId, super.onQuotedMessageCleared, super.canAlsoSendToChannel, super.textInputAction, super.keyboardType, super.textCapitalization, super.autofocus, super.autocorrect, super.audioRecorderController, super.voiceRecordingFeedback, super.sendVoiceRecordingAutomatically, super.placeholder});

  /// Creates a [MessageComposerInputProps] from [props].
  factory MessageComposerInputProps.from(MessageComposerComponentProps props) =>
      MessageComposerInputProps._(
        controller: props.controller,
        isFloating: props.isFloating,
        message: props.message,
        onSendPressed: props.onSendPressed,
        voiceRecordingCallback: props.voiceRecordingCallback,
        onAttachmentButtonPressed: props.onAttachmentButtonPressed,
        isPickerOpen: props.isPickerOpen,
        focusNode: props.focusNode,
        currentUserId: props.currentUserId,
        audioRecorderState: props.audioRecorderState,
        onQuotedMessageCleared: props.onQuotedMessageCleared,
        canAlsoSendToChannel: props.canAlsoSendToChannel,
        textInputAction: props.textInputAction,
        keyboardType: props.keyboardType,
        textCapitalization: props.textCapitalization,
        autofocus: props.autofocus,
        autocorrect: props.autocorrect,
        audioRecorderController: props.audioRecorderController,
        voiceRecordingFeedback: props.voiceRecordingFeedback,
        sendVoiceRecordingAutomatically: props.sendVoiceRecordingAutomatically,
        placeholder: props.placeholder,
      );
}

/// Properties for building the input leading component of the message composer.
class MessageComposerInputLeadingProps extends MessageComposerComponentProps {
  // ignore: prefer_const_constructors_in_immutables
  MessageComposerInputLeadingProps._({required super.controller, required super.onSendPressed, required super.audioRecorderState, super.isFloating, super.message, super.voiceRecordingCallback, super.onAttachmentButtonPressed, super.isPickerOpen, super.focusNode, super.currentUserId, super.onQuotedMessageCleared, super.canAlsoSendToChannel, super.textInputAction, super.keyboardType, super.textCapitalization, super.autofocus, super.autocorrect, super.audioRecorderController, super.voiceRecordingFeedback, super.sendVoiceRecordingAutomatically, super.placeholder});

  /// Creates a [MessageComposerInputLeadingProps] from [props].
  factory MessageComposerInputLeadingProps.from(MessageComposerComponentProps props) =>
      MessageComposerInputLeadingProps._(
        controller: props.controller,
        isFloating: props.isFloating,
        message: props.message,
        onSendPressed: props.onSendPressed,
        voiceRecordingCallback: props.voiceRecordingCallback,
        onAttachmentButtonPressed: props.onAttachmentButtonPressed,
        isPickerOpen: props.isPickerOpen,
        focusNode: props.focusNode,
        currentUserId: props.currentUserId,
        audioRecorderState: props.audioRecorderState,
        onQuotedMessageCleared: props.onQuotedMessageCleared,
        canAlsoSendToChannel: props.canAlsoSendToChannel,
        textInputAction: props.textInputAction,
        keyboardType: props.keyboardType,
        textCapitalization: props.textCapitalization,
        autofocus: props.autofocus,
        autocorrect: props.autocorrect,
        audioRecorderController: props.audioRecorderController,
        voiceRecordingFeedback: props.voiceRecordingFeedback,
        sendVoiceRecordingAutomatically: props.sendVoiceRecordingAutomatically,
        placeholder: props.placeholder,
      );
}

/// Properties for building the input header component of the message composer.
class MessageComposerInputHeaderProps extends MessageComposerComponentProps {
  // ignore: prefer_const_constructors_in_immutables
  MessageComposerInputHeaderProps._({required super.controller, required super.onSendPressed, required super.audioRecorderState, super.isFloating, super.message, super.voiceRecordingCallback, super.onAttachmentButtonPressed, super.isPickerOpen, super.focusNode, super.currentUserId, super.onQuotedMessageCleared, super.canAlsoSendToChannel, super.textInputAction, super.keyboardType, super.textCapitalization, super.autofocus, super.autocorrect, super.audioRecorderController, super.voiceRecordingFeedback, super.sendVoiceRecordingAutomatically, super.placeholder});

  /// Creates a [MessageComposerInputHeaderProps] from [props].
  factory MessageComposerInputHeaderProps.from(MessageComposerComponentProps props) =>
      MessageComposerInputHeaderProps._(
        controller: props.controller,
        isFloating: props.isFloating,
        message: props.message,
        onSendPressed: props.onSendPressed,
        voiceRecordingCallback: props.voiceRecordingCallback,
        onAttachmentButtonPressed: props.onAttachmentButtonPressed,
        isPickerOpen: props.isPickerOpen,
        focusNode: props.focusNode,
        currentUserId: props.currentUserId,
        audioRecorderState: props.audioRecorderState,
        onQuotedMessageCleared: props.onQuotedMessageCleared,
        canAlsoSendToChannel: props.canAlsoSendToChannel,
        textInputAction: props.textInputAction,
        keyboardType: props.keyboardType,
        textCapitalization: props.textCapitalization,
        autofocus: props.autofocus,
        autocorrect: props.autocorrect,
        audioRecorderController: props.audioRecorderController,
        voiceRecordingFeedback: props.voiceRecordingFeedback,
        sendVoiceRecordingAutomatically: props.sendVoiceRecordingAutomatically,
        placeholder: props.placeholder,
      );
}

/// Properties for building the input trailing component of the message composer.
class MessageComposerInputTrailingProps extends MessageComposerComponentProps {
  // ignore: prefer_const_constructors_in_immutables
  MessageComposerInputTrailingProps._({required super.controller, required super.onSendPressed, required super.audioRecorderState, super.isFloating, super.message, super.voiceRecordingCallback, super.onAttachmentButtonPressed, super.isPickerOpen, super.focusNode, super.currentUserId, super.onQuotedMessageCleared, super.canAlsoSendToChannel, super.textInputAction, super.keyboardType, super.textCapitalization, super.autofocus, super.autocorrect, super.audioRecorderController, super.voiceRecordingFeedback, super.sendVoiceRecordingAutomatically, super.placeholder});

  /// Creates a [MessageComposerInputTrailingProps] from [props].
  factory MessageComposerInputTrailingProps.from(MessageComposerComponentProps props) =>
      MessageComposerInputTrailingProps._(
        controller: props.controller,
        isFloating: props.isFloating,
        message: props.message,
        onSendPressed: props.onSendPressed,
        voiceRecordingCallback: props.voiceRecordingCallback,
        onAttachmentButtonPressed: props.onAttachmentButtonPressed,
        isPickerOpen: props.isPickerOpen,
        focusNode: props.focusNode,
        currentUserId: props.currentUserId,
        audioRecorderState: props.audioRecorderState,
        onQuotedMessageCleared: props.onQuotedMessageCleared,
        canAlsoSendToChannel: props.canAlsoSendToChannel,
        textInputAction: props.textInputAction,
        keyboardType: props.keyboardType,
        textCapitalization: props.textCapitalization,
        autofocus: props.autofocus,
        autocorrect: props.autocorrect,
        audioRecorderController: props.audioRecorderController,
        voiceRecordingFeedback: props.voiceRecordingFeedback,
        sendVoiceRecordingAutomatically: props.sendVoiceRecordingAutomatically,
        placeholder: props.placeholder,
      );
}
