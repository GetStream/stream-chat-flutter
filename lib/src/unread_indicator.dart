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
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: CircleAvatar(
        backgroundColor:
            StreamChatTheme.of(context).channelPreviewTheme.unreadCounterColor,
        radius: 8,
        child: Text(
          '${channel.state.unreadCount}',
          style: TextStyle(
            fontSize: 11,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
