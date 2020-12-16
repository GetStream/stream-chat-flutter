import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'channel_info.dart';
import 'channel_name.dart';
import 'stream_chat.dart';
import 'stream_chat_theme.dart';
import 'user_avatar.dart';

class ChannelBottomSheet extends StatelessWidget {
  const ChannelBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
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
                child: StreamChannel(
                  showLoading: false,
                  channel: channel,
                  child: ChannelName(
                    textStyle:
                        StreamChatTheme.of(context).channelPreviewTheme.title,
                  ),
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
            if (channel.isGroup && !channel.isDistinct)
              ListTile(
                leading: StreamSvgIcon.userRemove(
                  size: 24,
                  color: Color(0xff7A7A7A),
                ),
                title: Text(
                  'Leave Group',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  final confirm = await showConfirmationDialog(
                    context,
                    title: 'Leave Group',
                    okText: 'LEAVE',
                    question: 'Are you sure you want to leave this group?',
                    cancelText: 'CANCEL',
                    icon: StreamSvgIcon.userRemove(
                      color: Colors.red,
                    ),
                  );
                  if (confirm == true) {
                    await channel
                        .removeMembers([StreamChat.of(context).user.id]);
                    Navigator.pop(context);
                  }
                },
              ),
            if ([
              'admin',
              'owner',
            ].contains(channel.state.members
                .firstWhere((m) => m.userId == channel.client.state.user.id,
                    orElse: () => null)
                ?.role))
              ListTile(
                leading: StreamSvgIcon.delete(
                  color: Color(0xFFFF3742),
                  size: 24,
                ),
                title: Text(
                  'Delete chat',
                  style: TextStyle(
                    color: Color(0xFFFF3742),
                  ),
                ),
                onTap: () async {
                  final res = await showConfirmationDialog(
                    context,
                    title: 'Delete Conversation',
                    okText: 'DELETE',
                    question:
                        'Are you sure you want to delete this conversation?',
                    cancelText: 'CANCEL',
                    icon: StreamSvgIcon.delete(
                      color: Colors.red,
                    ),
                  );
                  var channel = StreamChannel.of(context).channel;
                  if (res == true) {
                    await channel.delete().then((value) {
                      Navigator.pop(context);
                    });
                  }
                },
              ),
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
