import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

class UnreadIndicator extends StatelessWidget {
  const UnreadIndicator({
    Key key,
    @required this.channel,
  }) : super(key: key);

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: channel.state.unreadCountStream,
        initialData: channel.state.unreadCount,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == 0) {
            return SizedBox();
          }
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              backgroundColor: StreamChatTheme.of(context)
                  .channelPreviewTheme
                  .unreadCounterColor,
              radius: 6,
              child: Text(
                '${snapshot.data}',
                style: TextStyle(fontSize: 8),
              ),
            ),
          );
        });
  }
}
