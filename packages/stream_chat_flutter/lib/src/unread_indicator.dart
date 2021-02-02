import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class UnreadIndicator extends StatelessWidget {
  const UnreadIndicator({
    Key key,
    this.cid,
  }) : super(key: key);

  /// Channel cid used to retrieve unread count
  final String cid;

  @override
  Widget build(BuildContext context) {
    final client = StreamChat.of(context).client;
    return StreamBuilder<int>(
      stream: cid != null
          ? client.state.channels[cid].state.unreadCountStream
          : client.state.totalUnreadCountStream,
      initialData: cid != null
          ? client.state.channels[cid].state.unreadCount
          : client.state.totalUnreadCount,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == 0) {
          return SizedBox();
        }
        return Material(
          borderRadius: BorderRadius.circular(8),
          color: StreamChatTheme.of(context)
              .channelPreviewTheme
              .unreadCounterColor,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 5.0,
              right: 5.0,
              top: 2,
              bottom: 1,
            ),
            child: Center(
              child: Text(
                '${snapshot.data}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
