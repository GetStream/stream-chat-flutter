import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_factory.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_header.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_leading.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_trailing.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_leading.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_trailing.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

class StreamChatMessageComposer extends StatefulWidget {
  StreamChatMessageComposer({
    super.key,
    this.controller,
    required VoidCallback onSendPressed,
    VoidCallback? onMicrophonePressed,
    FocusNode? focusNode,
  }) : props = MessageComposerProps(
         isFloating: false,
         message: null,
         onSendPressed: onSendPressed,
         onMicrophonePressed: onMicrophonePressed,
         focusNode: focusNode,
       );

  final StreamMessageInputController? controller;
  final MessageComposerProps props;

  @override
  State<StreamChatMessageComposer> createState() => _StreamChatMessageComposerState();
}

class _StreamChatMessageComposerState extends State<StreamChatMessageComposer> {
  late MessageTextFieldController _controller;

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
    _controller = widget.controller?.textFieldController ?? MessageTextFieldController();
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
      onSendPressed: widget.props.onSendPressed,
      onMicrophonePressed: widget.props.onMicrophonePressed,
    );

    return StreamMessageComposerFactory.maybeOf(context)?.messageComposer?.call(context, widget.props) ??
        core.StreamBaseMessageComposer(
          controller: _controller,
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
  const MessageComposerProps({
    this.isFloating = false,
    this.message,
    required this.onSendPressed,
    this.onMicrophonePressed,
    this.focusNode,
  });

  final bool isFloating;
  final Message? message;
  final VoidCallback onSendPressed;
  final VoidCallback? onMicrophonePressed;
  final FocusNode? focusNode;
}

/// Properties to build any of the sub-components.
/// These properties are all the same, so features such as 'add attachment',
/// can be added to any of the sub-components.
class MessageComposerComponentProps {
  const MessageComposerComponentProps({
    required this.controller,
    this.isFloating = false,
    this.message,
    required this.onSendPressed,
    this.onMicrophonePressed,
  });

  final MessageTextFieldController controller;
  final bool isFloating;
  final Message? message;
  final VoidCallback onSendPressed;
  final VoidCallback? onMicrophonePressed;
}
