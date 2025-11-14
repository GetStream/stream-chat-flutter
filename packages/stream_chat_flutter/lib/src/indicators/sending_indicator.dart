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
    this.isMessageDelivered = false,
    this.size = 12,
  });

  /// The message whose sending status is to be shown.
  final Message message;

  /// Whether the message is read by the recipient.
  final bool isMessageRead;

  /// Whether the message is delivered to the recipient.
  final bool isMessageDelivered;

  /// The size of the indicator icon.
  final double? size;

  @override
  Widget build(BuildContext context) {
    final streamChatTheme = StreamChatTheme.of(context);
    final colorTheme = streamChatTheme.colorTheme;

    if (isMessageRead) {
      return StreamSvgIcon(
        size: size,
        icon: StreamSvgIcons.checkAll,
        color: colorTheme.accentPrimary,
      );
    }

    if (isMessageDelivered) {
      return StreamSvgIcon(
        size: size,
        icon: StreamSvgIcons.checkAll,
        color: colorTheme.textLowEmphasis,
      );
    }

    if (message.state.isCompleted) {
      return StreamSvgIcon(
        size: size,
        icon: StreamSvgIcons.check,
        color: colorTheme.textLowEmphasis,
      );
    }

    if (message.state.isOutgoing) {
      return StreamSvgIcon(
        size: size,
        icon: StreamSvgIcons.time,
        color: colorTheme.textLowEmphasis,
      );
    }

    return const Empty();
  }
}
