import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template unreadMessagesSeparator}
/// {@endtemplate}
class UnreadMessagesSeparator extends StatelessWidget {
  /// {@macro unreadMessagesSeparator}
  const UnreadMessagesSeparator({
    super.key,
    required this.unreadCount,
  });

  /// Number of unread messages.
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: StreamChatTheme.of(context).colorTheme.bgGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            context.translations.unreadMessagesSeparatorText(
              unreadCount,
            ),
            textAlign: TextAlign.center,
            style: StreamChannelHeaderTheme.of(context).subtitleStyle,
          ),
        ),
      ),
    );
  }
}
