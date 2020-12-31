import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Used to show the sending status of the message
class SendingIndicator extends StatelessWidget {
  final Message message;
  final bool isMessageRead;
  final double size;

  const SendingIndicator({
    Key key,
    this.message,
    this.isMessageRead = false,
    this.size = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isMessageRead) {
      return Icon(
        Icons.done_all_rounded,
        size: size,
        color: StreamChatTheme.of(context).accentColor,
      );
    }
    if (message.status == MessageSendingStatus.SENT || message.status == null) {
      return Icon(
        Icons.done,
        size: size,
        color: IconTheme.of(context).color.withOpacity(0.5),
      );
    }
    if (message.status == MessageSendingStatus.SENDING ||
        message.status == MessageSendingStatus.UPDATING) {
      return Icon(
        Icons.access_time,
        size: size,
      );
    }
    return SizedBox();
  }
}
