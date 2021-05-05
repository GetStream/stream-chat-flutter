import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Widget for showing an unread indicator
class UnreadIndicator extends StatelessWidget {
  /// Constructor for creating an [UnreadIndicator]
  const UnreadIndicator({
    Key? key,
    this.cid,
  }) : super(key: key);

  /// Channel cid used to retrieve unread count
  final String? cid;

  @override
  Widget build(BuildContext context) {
    final client = StreamChat.of(context).client;
    return IgnorePointer(
      child: StreamBuilder<int?>(
        stream: cid != null
            ? client.state.channels[cid]?.state?.unreadCountStream
            : client.state.totalUnreadCountStream,
        initialData: cid != null
            ? client.state.channels[cid]?.state?.unreadCount
            : client.state.totalUnreadCount,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == 0) {
            return const SizedBox();
          }
          return Material(
            borderRadius: BorderRadius.circular(8),
            color: StreamChatTheme.of(context)
                .channelPreviewTheme
                .unreadCounterColor,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 5,
                right: 5,
                top: 2,
                bottom: 1,
              ),
              child: Center(
                child: Text(
                  '${snapshot.data! > 99 ? '99+' : snapshot.data}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
