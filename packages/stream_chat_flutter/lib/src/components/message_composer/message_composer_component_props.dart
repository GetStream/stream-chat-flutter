import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Callback object that wires long-press gesture events from the voice-recording
/// button through to the audio-recorder controller.
class VoiceRecordingCallback {
  /// Creates a [VoiceRecordingCallback].
  VoiceRecordingCallback({
    required this.onLongPressStart,
    required this.onLongPressCancel,
    required this.onLongPressEnd,
    this.onLongPressMoveUpdate,
  });

  /// Called when the long-press gesture starts.
  final VoidCallback onLongPressStart;

  /// Called when the long-press gesture is cancelled before it registers.
  final VoidCallback onLongPressCancel;

  /// Called when the long-press gesture ends.
  final GestureLongPressEndCallback onLongPressEnd;

  /// Called when the pointer moves during a long-press gesture.
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;
}

/// Properties to build any of the sub-components.
/// These properties are all the same, so features such as 'add attachment',
/// can be added to any of the sub-components.
class MessageComposerComponentProps {
  /// Creates a new instance of [MessageComposerComponentProps].
  /// [controller] is the controller for the message composer component.
  /// [isFloating] is whether the message composer is floating.
  /// [onSendPressed] is the callback for when the send button is pressed.
  /// [onMicrophonePressed] is the callback for when the microphone button is pressed.
  /// [onAttachmentButtonPressed] is the callback for when the attachment button is pressed.
  /// [focusNode] is the focus node for the message composer component.
  /// [currentUserId] is the current user id.
  const MessageComposerComponentProps({
    required this.controller,
    this.isFloating = false,
    required this.onSendPressed,
    this.voiceRecordingCallback,
    this.onAttachmentButtonPressed,
    this.isPickerOpen = false,
    this.focusNode,
    this.currentUserId,
    required this.audioRecorderState,
    this.onQuotedMessageCleared,
  });

  /// The controller for the message composer component.
  final StreamMessageComposerController controller;

  /// Whether the message composer is floating.
  final bool isFloating;

  /// The callback for when the send button is pressed.
  final VoidCallback onSendPressed;

  /// The callback for when the microphone button is pressed.
  final VoiceRecordingCallback? voiceRecordingCallback;

  /// The callback for when the attachment button is pressed.
  final VoidCallback? onAttachmentButtonPressed;

  /// Whether the inline attachment picker is currently open.
  final bool isPickerOpen;

  /// The focus node for the message composer component.
  final FocusNode? focusNode;

  /// The current user id.
  final String? currentUserId;

  /// Whether the audio recording flow is active.
  final AudioRecorderState audioRecorderState;

  /// Callback for when the quoted message is cleared.
  final VoidCallback? onQuotedMessageCleared;

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
    required super.onSendPressed,
    required super.voiceRecordingCallback,
    required super.onAttachmentButtonPressed,
    required super.isPickerOpen,
    required super.focusNode,
    required super.currentUserId,
    required super.audioRecorderState,
    required super.onQuotedMessageCleared,
  }) : super();

  /// Creates a new instance of [MessageComposerLeadingProps] from a [MessageComposerComponentProps].
  factory MessageComposerLeadingProps.from(MessageComposerComponentProps props) {
    return MessageComposerLeadingProps._(
      controller: props.controller,
      isFloating: props.isFloating,
      onSendPressed: props.onSendPressed,
      voiceRecordingCallback: props.voiceRecordingCallback,
      onAttachmentButtonPressed: props.onAttachmentButtonPressed,
      isPickerOpen: props.isPickerOpen,
      focusNode: props.focusNode,
      currentUserId: props.currentUserId,
      audioRecorderState: props.audioRecorderState,
      onQuotedMessageCleared: props.onQuotedMessageCleared,
    );
  }
}

/// Properties for building the trailing component of the message composer.
class MessageComposerTrailingProps extends MessageComposerComponentProps {
  const MessageComposerTrailingProps._({
    required super.controller,
    required super.isFloating,
    required super.onSendPressed,
    required super.voiceRecordingCallback,
    required super.onAttachmentButtonPressed,
    required super.isPickerOpen,
    required super.focusNode,
    required super.currentUserId,
    required super.audioRecorderState,
    required super.onQuotedMessageCleared,
  }) : super();

  /// Creates a new instance of [MessageComposerTrailingProps] from a [MessageComposerComponentProps].
  factory MessageComposerTrailingProps.from(MessageComposerComponentProps props) {
    return MessageComposerTrailingProps._(
      controller: props.controller,
      isFloating: props.isFloating,
      onSendPressed: props.onSendPressed,
      voiceRecordingCallback: props.voiceRecordingCallback,
      onAttachmentButtonPressed: props.onAttachmentButtonPressed,
      isPickerOpen: props.isPickerOpen,
      focusNode: props.focusNode,
      currentUserId: props.currentUserId,
      audioRecorderState: props.audioRecorderState,
      onQuotedMessageCleared: props.onQuotedMessageCleared,
    );
  }
}

/// Properties for building the input container component of the message composer.
class MessageComposerInputProps extends MessageComposerComponentProps {
  const MessageComposerInputProps._({
    required super.controller,
    required super.isFloating,
    required super.onSendPressed,
    required super.voiceRecordingCallback,
    required super.onAttachmentButtonPressed,
    required super.isPickerOpen,
    required super.focusNode,
    required super.currentUserId,
    required super.audioRecorderState,
    required super.onQuotedMessageCleared,
    this.placeholder,
    this.textInputAction,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
    this.autofocus = false,
    this.autocorrect = true,
    this.canAlsoSendToChannel = false,
    this.audioRecorderController,
    this.feedback = const AudioRecorderFeedback(),
    this.sendVoiceRecordingAutomatically = false,
  }) : super();

  /// Creates a new instance of [MessageComposerInputProps] from a
  /// [MessageComposerComponentProps] and named input-level configuration values.
  factory MessageComposerInputProps.from(
    MessageComposerComponentProps props, {
    String? placeholder,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    bool autofocus = false,
    bool autocorrect = true,
    bool canAlsoSendToChannel = false,
    StreamAudioRecorderController? audioRecorderController,
    AudioRecorderFeedback feedback = const AudioRecorderFeedback(),
    bool sendVoiceRecordingAutomatically = false,
  }) {
    return MessageComposerInputProps._(
      controller: props.controller,
      isFloating: props.isFloating,
      onSendPressed: props.onSendPressed,
      voiceRecordingCallback: props.voiceRecordingCallback,
      onAttachmentButtonPressed: props.onAttachmentButtonPressed,
      isPickerOpen: props.isPickerOpen,
      focusNode: props.focusNode,
      currentUserId: props.currentUserId,
      audioRecorderState: props.audioRecorderState,
      onQuotedMessageCleared: props.onQuotedMessageCleared,
      placeholder: placeholder,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      autofocus: autofocus,
      autocorrect: autocorrect,
      canAlsoSendToChannel: canAlsoSendToChannel,
      audioRecorderController: audioRecorderController,
      feedback: feedback,
      sendVoiceRecordingAutomatically: sendVoiceRecordingAutomatically,
    );
  }

  /// The placeholder text shown inside the input field when it is empty.
  final String? placeholder;

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

  /// Whether to show the "also send to channel" checkbox.
  final bool canAlsoSendToChannel;

  /// The audio recorder controller.
  final StreamAudioRecorderController? audioRecorderController;

  /// The feedback handler for voice recording interactions.
  final AudioRecorderFeedback feedback;

  /// Whether to send the voice recording automatically when recording stops.
  final bool sendVoiceRecordingAutomatically;
}

/// Properties for building the center content of the message composer input.
class MessageComposerInputCenterProps extends MessageComposerComponentProps {
  const MessageComposerInputCenterProps._({
    required super.controller,
    required super.isFloating,
    required super.onSendPressed,
    required super.voiceRecordingCallback,
    required super.onAttachmentButtonPressed,
    required super.isPickerOpen,
    required super.focusNode,
    required super.currentUserId,
    required super.audioRecorderState,
    required super.onQuotedMessageCleared,
    this.placeholder,
    this.textInputAction,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
    this.autofocus = false,
    this.autocorrect = true,
    this.canAlsoSendToChannel = false,
    this.audioRecorderController,
    this.feedback = const AudioRecorderFeedback(),
    this.sendVoiceRecordingAutomatically = false,
  }) : super();

  /// Creates a new instance of [MessageComposerInputCenterProps] from a
  /// [MessageComposerInputProps], forwarding all base and input-level fields.
  factory MessageComposerInputCenterProps.from(MessageComposerInputProps inputProps) {
    return MessageComposerInputCenterProps._(
      controller: inputProps.controller,
      isFloating: inputProps.isFloating,
      onSendPressed: inputProps.onSendPressed,
      voiceRecordingCallback: inputProps.voiceRecordingCallback,
      onAttachmentButtonPressed: inputProps.onAttachmentButtonPressed,
      isPickerOpen: inputProps.isPickerOpen,
      focusNode: inputProps.focusNode,
      currentUserId: inputProps.currentUserId,
      audioRecorderState: inputProps.audioRecorderState,
      onQuotedMessageCleared: inputProps.onQuotedMessageCleared,
      placeholder: inputProps.placeholder,
      textInputAction: inputProps.textInputAction,
      keyboardType: inputProps.keyboardType,
      textCapitalization: inputProps.textCapitalization,
      autofocus: inputProps.autofocus,
      autocorrect: inputProps.autocorrect,
      canAlsoSendToChannel: inputProps.canAlsoSendToChannel,
      audioRecorderController: inputProps.audioRecorderController,
      feedback: inputProps.feedback,
      sendVoiceRecordingAutomatically: inputProps.sendVoiceRecordingAutomatically,
    );
  }

  /// The placeholder text shown inside the input field when it is empty.
  final String? placeholder;

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

  /// Whether to show the "also send to channel" checkbox.
  final bool canAlsoSendToChannel;

  /// The audio recorder controller.
  final StreamAudioRecorderController? audioRecorderController;

  /// The feedback handler for voice recording interactions.
  final AudioRecorderFeedback feedback;

  /// Whether to send the voice recording automatically when recording stops.
  final bool sendVoiceRecordingAutomatically;
}

/// Properties for building the input leading component of the message composer.
class MessageComposerInputLeadingProps extends MessageComposerComponentProps {
  const MessageComposerInputLeadingProps._({
    required super.controller,
    required super.isFloating,
    required super.onSendPressed,
    required super.voiceRecordingCallback,
    required super.onAttachmentButtonPressed,
    required super.isPickerOpen,
    required super.focusNode,
    required super.currentUserId,
    required super.audioRecorderState,
    required super.onQuotedMessageCleared,
  }) : super();

  /// Creates a new instance of [MessageComposerInputLeadingProps] from a [MessageComposerComponentProps].
  factory MessageComposerInputLeadingProps.from(MessageComposerComponentProps props) {
    return MessageComposerInputLeadingProps._(
      controller: props.controller,
      isFloating: props.isFloating,
      onSendPressed: props.onSendPressed,
      voiceRecordingCallback: props.voiceRecordingCallback,
      onAttachmentButtonPressed: props.onAttachmentButtonPressed,
      isPickerOpen: props.isPickerOpen,
      focusNode: props.focusNode,
      currentUserId: props.currentUserId,
      audioRecorderState: props.audioRecorderState,
      onQuotedMessageCleared: props.onQuotedMessageCleared,
    );
  }
}

/// Properties for building the input header component of the message composer.
class MessageComposerInputHeaderProps extends MessageComposerComponentProps {
  const MessageComposerInputHeaderProps._({
    required super.controller,
    required super.isFloating,
    required super.onSendPressed,
    required super.voiceRecordingCallback,
    required super.onAttachmentButtonPressed,
    required super.isPickerOpen,
    required super.focusNode,
    required super.currentUserId,
    required super.audioRecorderState,
    required super.onQuotedMessageCleared,
  }) : super();

  /// Creates a new instance of [MessageComposerInputHeaderProps] from a [MessageComposerComponentProps].
  factory MessageComposerInputHeaderProps.from(MessageComposerComponentProps props) {
    return MessageComposerInputHeaderProps._(
      controller: props.controller,
      isFloating: props.isFloating,
      onSendPressed: props.onSendPressed,
      voiceRecordingCallback: props.voiceRecordingCallback,
      onAttachmentButtonPressed: props.onAttachmentButtonPressed,
      isPickerOpen: props.isPickerOpen,
      focusNode: props.focusNode,
      currentUserId: props.currentUserId,
      audioRecorderState: props.audioRecorderState,
      onQuotedMessageCleared: props.onQuotedMessageCleared,
    );
  }
}

/// Properties for building the input trailing component of the message composer.
class MessageComposerInputTrailingProps extends MessageComposerComponentProps {
  const MessageComposerInputTrailingProps._({
    required super.controller,
    required super.isFloating,
    required super.onSendPressed,
    required super.voiceRecordingCallback,
    required super.onAttachmentButtonPressed,
    required super.isPickerOpen,
    required super.focusNode,
    required super.currentUserId,
    required super.audioRecorderState,
    required super.onQuotedMessageCleared,
  }) : super();

  /// Creates a new instance of [MessageComposerInputTrailingProps] from a [MessageComposerComponentProps].
  factory MessageComposerInputTrailingProps.from(MessageComposerComponentProps props) {
    return MessageComposerInputTrailingProps._(
      controller: props.controller,
      isFloating: props.isFloating,
      onSendPressed: props.onSendPressed,
      voiceRecordingCallback: props.voiceRecordingCallback,
      onAttachmentButtonPressed: props.onAttachmentButtonPressed,
      isPickerOpen: props.isPickerOpen,
      focusNode: props.focusNode,
      currentUserId: props.currentUserId,
      audioRecorderState: props.audioRecorderState,
      onQuotedMessageCleared: props.onQuotedMessageCleared,
    );
  }
}
