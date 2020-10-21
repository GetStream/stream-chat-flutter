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
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: StreamChatTheme.of(context).channelPreviewTheme.unreadCounterColor,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 5.0,
          right: 5.0,
          top: 2,
          bottom: 1,
        ),
        child: Center(
          child: Text(
            '${channel.state.unreadCount}',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
