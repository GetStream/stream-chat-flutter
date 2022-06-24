import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@macro sending_indicator}
@Deprecated("Use 'StreamSendingIndicator' instead")
typedef SendingIndicator = StreamSendingIndicator;

/// {@template sending_indicator}
/// Used to show the sending status of the message
/// {@endtemplate}
class StreamSendingIndicator extends StatelessWidget {
  /// Constructor for creating a [StreamSendingIndicator] widget
  const StreamSendingIndicator({
    super.key,
    required this.message,
    this.isMessageRead = false,
    this.size = 12,
  });

  /// Message for sending indicator
  final Message message;

  /// Flag if message is read
  final bool isMessageRead;

  /// Size for message
  final double? size;

  @override
  Widget build(BuildContext context) {
    if (isMessageRead) {
      return StreamSvgIcon.checkAll(
        size: size,
        color: StreamChatTheme.of(context).colorTheme.accentPrimary,
      );
    }
    if (message.status == MessageSendingStatus.sent) {
      return StreamSvgIcon.check(
        size: size,
        color: IconTheme.of(context).color!.withOpacity(0.5),
      );
    }
    if (message.status == MessageSendingStatus.sending ||
        message.status == MessageSendingStatus.updating) {
      return Icon(
        Icons.access_time,
        size: size,
      );
    }
    return const SizedBox();
  }
}
