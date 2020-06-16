import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Used to show the sending status of the message
class SendingIndicator extends StatelessWidget {
  final Message message;

  const SendingIndicator({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.status == MessageSendingStatus.SENT || message.status == null) {
      return Icon(
        Icons.done,
        size: 8,
      );
    }
    if (message.status == MessageSendingStatus.SENDING ||
        message.status == MessageSendingStatus.UPDATING) {
      return Icon(
        Icons.access_time,
        size: 8,
      );
    }
    if (message.status == MessageSendingStatus.FAILED ||
        message.status == MessageSendingStatus.FAILED_UPDATE ||
        message.status == MessageSendingStatus.FAILED_DELETE) {
      return Icon(
        Icons.error_outline,
        size: 8,
      );
    }

    return SizedBox();
  }
}
