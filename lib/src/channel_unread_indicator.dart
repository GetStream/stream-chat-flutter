import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

class ChannelUnreadIndicator extends StatelessWidget {
  const ChannelUnreadIndicator({
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
