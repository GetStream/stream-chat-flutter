import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
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
  final OnMessageTap? onMessageTap;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final message = this.message.replaceMentions(linkify: false);

    final messageText = message.text;
    if (messageText == null) return const Empty();

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: switch (onMessageTap) {
          final onTap? => () => onTap(message),
          _ => null,
        },
        child: Text(
          messageText,
          softWrap: true,
          textAlign: TextAlign.center,
          style: theme.textTheme.captionBold.copyWith(
            color: theme.colorTheme.textLowEmphasis,
          ),
        ),
      ),
    );
  }
}
