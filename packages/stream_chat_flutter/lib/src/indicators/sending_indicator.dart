import 'package:material_ui/material_ui.dart';
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
    this.color,
  });

  /// The message whose sending status is to be shown.
  final Message message;

  /// Whether the message is read by the recipient.
  final bool isMessageRead;

  /// Whether the message is delivered to the recipient.
  final bool isMessageDelivered;

  /// The size of the indicator icon.
  final double? size;

  /// The color of the indicator icon.
  ///
  /// When null, read messages use `StreamColorScheme.accentPrimary` and every
  /// other state uses `StreamColorScheme.textSecondary`.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final a11y = context.translations.accessibility;

    if (isMessageRead) {
      return Icon(
        context.streamIcons.checks,
        size: size,
        color: color ?? colorScheme.accentPrimary,
        semanticLabel: a11y.messageReadStatusLabel,
      );
    }

    if (isMessageDelivered) {
      return Icon(
        context.streamIcons.checks,
        size: size,
        color: color ?? colorScheme.textSecondary,
        semanticLabel: a11y.messageDeliveredStatusLabel,
      );
    }

    if (message.state.isCompleted) {
      return Icon(
        context.streamIcons.checkmark,
        size: size,
        color: color ?? colorScheme.textSecondary,
        semanticLabel: a11y.messageSentStatusLabel,
      );
    }

    if (message.state.isOutgoing) {
      return Icon(
        context.streamIcons.clock,
        size: size,
        color: color ?? colorScheme.textSecondary,
        semanticLabel: a11y.messageSendingStatusLabel,
      );
    }

    return const Empty();
  }
}
