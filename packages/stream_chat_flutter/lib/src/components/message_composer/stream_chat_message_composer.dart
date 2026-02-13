import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_factory.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_header.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_leading.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_trailing.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_leading.dart';
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
    VoidCallback? onMicrophonePressed,
    VoidCallback? onAttachmentButtonPressed,
    FocusNode? focusNode,
    String? currentUserId,
    String placeholder = '',
  }) : props = MessageComposerProps(
         isFloating: false,
         message: null,
         onSendPressed: onSendPressed,
         onMicrophonePressed: onMicrophonePressed,
         onAttachmentButtonPressed: onAttachmentButtonPressed,
         focusNode: focusNode,
         currentUserId: currentUserId,
         placeholder: placeholder,
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
    final componentProps = MessageComposerComponentProps(
      controller: _controller,
      isFloating: widget.props.isFloating,
      message: widget.props.message,
      currentUserId: widget.props.currentUserId,
      onSendPressed: widget.props.onSendPressed,
      onMicrophonePressed: widget.props.onMicrophonePressed,
      onAttachmentButtonPressed: widget.props.onAttachmentButtonPressed,
      focusNode: widget.props.focusNode,
    );

    return StreamMessageComposerFactory.maybeOf(context)?.messageComposer?.call(context, widget.props) ??
        core.StreamBaseMessageComposer(
          placeholder: widget.props.placeholder,
          controller: _controller.textFieldController,
          isFloating: widget.props.isFloating,
          focusNode: widget.props.focusNode,
          composerLeading: StreamMessageComposerLeading(props: componentProps),
          composerTrailing: StreamMessageComposerTrailing(props: componentProps),
          inputHeader: StreamMessageComposerInputHeader(props: componentProps),
          inputTrailing: StreamMessageComposerInputTrailing(props: componentProps),
          inputLeading: StreamMessageComposerInputLeading(props: componentProps),
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
    this.onMicrophonePressed,
    this.onAttachmentButtonPressed,
    this.focusNode,
    this.currentUserId,
  });

  /// Whether the message composer is floating.
  final bool isFloating;

  /// The message for the message composer.
  final Message? message;

  /// The placeholder text of the message composer.
  final String placeholder;

  /// The callback for when the send button is pressed.
  final VoidCallback onSendPressed;

  /// The callback for when the microphone button is pressed.
  final VoidCallback? onMicrophonePressed;

  /// The callback for when the attachment button is pressed.
  final VoidCallback? onAttachmentButtonPressed;

  /// The focus node for the message composer.
  final FocusNode? focusNode;

  /// The current user id.
  final String? currentUserId;
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
    this.onMicrophonePressed,
    this.onAttachmentButtonPressed,
    this.focusNode,
    this.currentUserId,
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
  final VoidCallback? onMicrophonePressed;

  /// The callback for when the attachment button is pressed.
  final VoidCallback? onAttachmentButtonPressed;

  /// The focus node for the message composer component.
  final FocusNode? focusNode;

  /// The current user id.
  final String? currentUserId;
}
