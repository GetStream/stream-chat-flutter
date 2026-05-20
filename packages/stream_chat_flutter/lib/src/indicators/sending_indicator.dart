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
    this.size,
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
    final colorScheme = context.streamColorScheme;

    if (isMessageRead) {
      return Icon(
        context.streamIcons.checks,
        size: size,
        color: colorScheme.accentPrimary,
      );
    }

    if (isMessageDelivered) {
      return Icon(
        context.streamIcons.checks,
        size: size,
        color: colorScheme.textSecondary,
      );
    }

    if (message.state.isCompleted) {
      return Icon(
        context.streamIcons.checkmark,
        size: size,
        color: colorScheme.textSecondary,
      );
    }

    if (message.state.isOutgoing) {
      return Icon(
        context.streamIcons.clock,
        size: size,
        color: colorScheme.textSecondary,
      );
    }

    return const Empty();
  }
}
