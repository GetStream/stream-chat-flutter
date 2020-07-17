import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:stream_chat/stream_chat.dart';

import 'channel_info.dart';
import 'channel_name.dart';
import 'stream_chat.dart';
import 'stream_chat_theme.dart';
import 'user_avatar.dart';

class ChannelBottomSheet extends StatelessWidget {
  const ChannelBottomSheet({
    Key key,
    @required this.channel,
  }) : super(key: key);

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 2.0,
              ),
              child: Center(
                child: ChannelName(
                  channel: channel,
                  textStyle:
                      StreamChatTheme.of(context).channelPreviewTheme.title,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 2.0,
              ),
              child: Center(
                child: ChannelInfo(
                  channel: channel,
                  textStyle:
                      StreamChatTheme.of(context).channelPreviewTheme.subtitle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
              ),
              child: Center(
                child: StreamBuilder<List<Member>>(
                  stream: channel.state.membersStream.map((event) => event
                      .where((m) => m.userId != StreamChat.of(context).user.id)
                      .toList()),
                  initialData: channel.state.members
                      .where((m) => m.userId != StreamChat.of(context).user.id)
                      .toList(),
                  builder: _buildMembers,
                ),
              ),
            ),
            Divider(),
            StreamBuilder<bool>(
                stream: channel.isMutedStream,
                initialData: channel.isMuted,
                builder: (context, snapshot) {
                  return SwitchListTile(
                    onChanged: (bool muted) async {
                      if (muted) {
                        await channel.mute();
                      } else {
                        await channel.unmute();
                      }
                    },
                    value: snapshot.data,
                    title: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 22.0),
                          child: Icon(LineAwesomeIcons.volume_off),
                        ),
                        Text('Mute'),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildMembers(
    BuildContext context,
    AsyncSnapshot<List<Member>> snapshot,
  ) {
    if (snapshot.data.isEmpty) {
      return SizedBox();
    }

    return Container(
      height: 83,
      child: ListView(
        padding: EdgeInsets.only(
          left: (MediaQuery.of(context).size.width / 2) - 48,
        ),
        scrollDirection: Axis.horizontal,
        children: snapshot.data.map((m) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: Column(
              children: <Widget>[
                UserAvatar(
                  showOnlineStatus: true,
                  user: m.user,
                  borderRadius: BorderRadius.circular(32),
                  constraints: BoxConstraints.tight(
                    Size.square(64),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    m.user.name?.split(' ')?.elementAt(0),
                    style: StreamChatTheme.of(context)
                        .channelPreviewTheme
                        .title
                        .copyWith(
                          fontSize: 12,
                        ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
