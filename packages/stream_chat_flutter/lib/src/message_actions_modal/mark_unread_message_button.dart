import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template markUnreadMessageButton}
/// Allows a user to mark message (and all messages onwards) as unread.
///
/// Used by [MessageActionsModal]. Should not be used by itself.
/// {@endtemplate}
class MarkUnreadMessageButton extends StatelessWidget {
  /// {@macro markUnreadMessageButton}
  const MarkUnreadMessageButton({
    super.key,
    required this.onTap,
  });

  /// The callback to perform when the button is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final streamChatThemeData = StreamChatTheme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        child: Row(
          children: [
            StreamSvgIcon(
              icon: StreamSvgIcons.messageUnread,
              color: streamChatThemeData.primaryIconTheme.color,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              context.translations.markAsUnreadLabel,
              style: streamChatThemeData.textTheme.body,
            ),
          ],
        ),
      ),
    );
  }
}
