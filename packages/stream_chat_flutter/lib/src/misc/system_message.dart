import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamSystemMessage}
/// {@endtemplate}
class StreamSystemMessage extends StatelessWidget {
  /// {@macro streamSystemMessage}
  const StreamSystemMessage({
    super.key,
    required this.message,
    this.onMessageTap,
  });

  /// The message to display.
  final Message message;

  /// The action to perform when tapping on the message.
  final void Function(Message)? onMessageTap;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final message = this.message.replaceMentions(linkify: false);

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
