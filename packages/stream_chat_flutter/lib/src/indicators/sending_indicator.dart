import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamSendingIndicator}
/// Shows the sending status of a message.
/// {@endtemplate}
class StreamSendingIndicator extends StatelessWidget {
  /// {@macro streamSendingIndicator}
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
      return StreamSvgIcon(
        size: size,
        icon: StreamSvgIcons.checkAll,
        color: StreamChatTheme.of(context).colorTheme.accentPrimary,
      );
    }
    if (message.state.isCompleted) {
      return StreamSvgIcon(
        size: size,
        icon: StreamSvgIcons.check,
        color: StreamChatTheme.of(context).colorTheme.textLowEmphasis,
      );
    }
    if (message.state.isOutgoing) {
      return StreamSvgIcon(
        size: size,
        icon: StreamSvgIcons.time,
        color: StreamChatTheme.of(context).colorTheme.textLowEmphasis,
      );
    }
    return const Empty();
  }
}
