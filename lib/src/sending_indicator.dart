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
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 1.0,
        ),
        child: CircleAvatar(
          radius: 4,
          backgroundColor: Theme.of(context).accentColor,
          child: Icon(
            Icons.done,
            color: Colors.white,
            size: 4,
          ),
        ),
      );
    }
    if (message.status == MessageSendingStatus.SENDING ||
        message.status == MessageSendingStatus.UPDATING) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 1.0,
        ),
        child: CircleAvatar(
          radius: 4,
          backgroundColor: Colors.grey,
          child: Icon(
            Icons.access_time,
            size: 4,
            color: Colors.white,
          ),
        ),
      );
    }
    if (message.status == MessageSendingStatus.FAILED ||
        message.status == MessageSendingStatus.FAILED_UPDATE ||
        message.status == MessageSendingStatus.FAILED_DELETE) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 1.0,
        ),
        child: CircleAvatar(
          radius: 4,
          backgroundColor: Color(0xffd0021B).withOpacity(.1),
          child: Icon(
            Icons.error_outline,
            size: 4,
            color: Colors.white,
          ),
        ),
      );
    }

    return SizedBox();
  }
}
