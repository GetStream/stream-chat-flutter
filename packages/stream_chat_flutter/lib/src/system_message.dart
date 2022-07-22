import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@macro system_message}
@Deprecated("Use 'StreamSystemMessage' instead")
typedef SystemMessage = StreamSystemMessage;

/// {@template system_message}
/// It shows a widget for the message with a system message type.
/// {@endtemplate}
class StreamSystemMessage extends StatelessWidget {
  /// Constructor for creating a [StreamSystemMessage]
  const StreamSystemMessage({
    super.key,
    required this.message,
    this.onMessageTap,
  });

  /// This message
  final Message message;

  /// The function called when tapping on the message
  /// when the message is not failed
  // TODO: Convert it to a simple OnTap instead.
  final void Function(Message)? onMessageTap;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final message = this.message.replaceMentions();

    final messageText = message.text;
    if (messageText == null) return const SizedBox.shrink();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onMessageTap == null ? null : () => onMessageTap!(message),
      child: Text(
        messageText,
        textAlign: TextAlign.center,
        softWrap: true,
        style: theme.textTheme.captionBold.copyWith(
          color: theme.colorTheme.textLowEmphasis,
        ),
      ),
    );
  }
}
