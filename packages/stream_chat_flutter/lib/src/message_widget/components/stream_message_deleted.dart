import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_core_flutter/chat.dart' as core;

/// Displays a "Message deleted" indicator inside a message bubble.
///
/// Shown in place of the normal message content when [Message.isDeleted]
/// is true.
///
/// See also:
///
///  * [StreamMessageScaffold], which shows this widget for deleted messages.
class StreamMessageDeleted extends StatelessWidget {
  /// Creates a deleted message widget.
  const StreamMessageDeleted({super.key});

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;

    return core.StreamMessageBubble(
      padding: .symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xs,
      ),
      child: Row(
        spacing: spacing.xxs,
        mainAxisSize: .min,
        children: [
          Icon(icons.noSign, size: 16),
          core.StreamMessageText(padding: .zero, context.translations.messageDeletedLabel),
        ],
      ),
    );
  }
}
