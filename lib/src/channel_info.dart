import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelInfo extends StatelessWidget {
  final Channel channel;

  /// The style of the text displayed
  final TextStyle textStyle;

  const ChannelInfo({
    Key key,
    @required this.channel,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (channel.memberCount > 2) {
      return Text(
        '${channel.memberCount} Members, ${channel.state.watcherCount} Online',
        style: StreamChatTheme.of(context)
            .channelTheme
            .channelHeaderTheme
            .lastMessageAt,
      );
    } else {
      return StreamBuilder<List<Member>>(
        stream: channel.state.membersStream,
        initialData: channel.state.members,
        builder: (context, snapshot) {
          final otherMember = snapshot.data.firstWhere(
            (element) => element.userId != StreamChat.of(context).user.id,
            orElse: () => null,
          );

          if (otherMember == null) {
            return SizedBox();
          }

          if (otherMember.user.online) {
            return Text(
              'Online',
              style: StreamChatTheme.of(context)
                  .channelTheme
                  .channelHeaderTheme
                  .lastMessageAt,
            );
          }

          return Text(
            'Last seen ${Jiffy(otherMember.user.lastActive).fromNow()}',
            style: textStyle,
          );
        },
      );
    }
  }
}
