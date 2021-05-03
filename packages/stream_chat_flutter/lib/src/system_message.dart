import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// It shows a date divider depending on the date difference
class SystemMessage extends StatelessWidget {
  /// This message
  final Message message;

  /// The function called when tapping on the message when the message is not failed
  final void Function(Message)? onMessageTap;

  const SystemMessage({
    Key? key,
    required this.message,
    this.onMessageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (onMessageTap != null) {
          onMessageTap!(message);
        }
      },
      child: Text(
        message.text!,
        textAlign: TextAlign.center,
        softWrap: true,
        style: theme.textTheme.captionBold.copyWith(
          color: theme.colorTheme.grey,
        ),
      ),
    );
  }
}
