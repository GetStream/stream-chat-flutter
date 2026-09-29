import 'package:flutter/material.dart';

import '../../stream_chat_flutter.dart';
import '../message_widget/message_status_labels.dart';
import '../misc/empty_widget.dart';

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
    final status = MessageDeliveryStatus.of(
      message,
      isMessageRead: isMessageRead,
      isMessageDelivered: isMessageDelivered,
    );

    // A failed send is shown as an error badge on the bubble rather than a
    // footer tick, so it has no icon of its own here.
    final icon = switch (status) {
      .read || .delivered => context.streamIcons.checks,
      .sent => context.streamIcons.checkmark,
      .sending => context.streamIcons.clock,
      .failed || .none => null,
    };

    if (icon == null) return const Empty();

    final colorScheme = context.streamColorScheme;

    return Icon(
      icon,
      size: size,
      color:
          color ??
          switch (status) {
            .read => colorScheme.accentPrimary,
            _ => colorScheme.textSecondary,
          },
      // Derived from the same resolved status as the icon, so the two cannot
      // describe different states.
      semanticLabel: status.label(context.translations),
    );
  }
}
