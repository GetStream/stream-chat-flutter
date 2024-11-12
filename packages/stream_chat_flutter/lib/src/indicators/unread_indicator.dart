import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamUnreadIndicator}
/// Shows an unread indicator for a message.
/// {@endtemplate}
class StreamUnreadIndicator extends StatelessWidget {
  /// {@macro streamUnreadIndicator}
  const StreamUnreadIndicator({
    super.key,
    this.cid,
  });

  /// Channel cid used to retrieve unread count
  final String? cid;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final client = StreamChat.of(context).client;
    return IgnorePointer(
      child: BetterStreamBuilder<int>(
        stream: cid != null
            ? client.state.channels[cid]?.state?.unreadCountStream
            : client.state.totalUnreadCountStream,
        initialData: cid != null
            ? client.state.channels[cid]?.state?.unreadCount
            : client.state.totalUnreadCount,
        builder: (context, unreadCount) {
          if (unreadCount == 0) return const SizedBox.shrink();

          return Badge(
            textColor: Colors.white,
            textStyle: theme.textTheme.footnoteBold,
            backgroundColor: theme.channelPreviewTheme.unreadCounterColor,
            label: Text(
              switch (unreadCount) {
                > 99 => '99+',
                _ => '$unreadCount',
              },
            ),
          );
        },
      ),
    );
  }
}
