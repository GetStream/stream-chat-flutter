import 'package:flutter/material.dart';

import '../stream_chat_flutter.dart';
import 'channel_info.dart';
import 'option_list_tile.dart';

class ChannelBottomSheet extends StatefulWidget {
  VoidCallback onViewInfoTap;

  ChannelBottomSheet({this.onViewInfoTap});

  @override
  _ChannelBottomSheetState createState() => _ChannelBottomSheetState();
}

class _ChannelBottomSheetState extends State<ChannelBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var channel = StreamChannel.of(context).channel;

    var members = channel.state.members;

    var userAsMember =
        members.firstWhere((e) => e.user.id == StreamChat.of(context).user.id);
    var isOwner = userAsMember.role == 'owner';

    return Material(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 24.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ChannelName(
              textStyle: TextStyle(
                fontSize: 16.0,
                color: Color(0xff000000),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          ChannelInfo(
            showTypingIndicator: false,
            channel: StreamChannel.of(context).channel,
            textStyle: StreamChatTheme.of(context).channelPreviewTheme.subtitle,
          ),
          SizedBox(
            height: 17.0,
          ),
          if (channel.isDistinct && channel.memberCount == 2)
            Column(
              children: [
                UserAvatar(
                  user: members
                      .firstWhere((e) => e.user.id != userAsMember.user.id)
                      .user,
                  constraints: BoxConstraints(
                    maxHeight: 64.0,
                    maxWidth: 64.0,
                  ),
                  borderRadius: BorderRadius.circular(32.0),
                ),
                SizedBox(
                  height: 6.0,
                ),
                Text(
                  members
                      .firstWhere((e) => e.user.id != userAsMember.user.id)
                      .user
                      .name,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          if (!(channel.isDistinct && channel.memberCount == 2))
            Container(
              height: 94.0,
              alignment: Alignment.center,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: members.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        UserAvatar(
                          user: members[index].user,
                          constraints: BoxConstraints(
                            maxHeight: 64.0,
                            maxWidth: 64.0,
                          ),
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        SizedBox(
                          height: 6.0,
                        ),
                        Text(
                          members[index].user.name,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          SizedBox(
            height: 24.0,
          ),
          OptionListTile(
            leading: StreamSvgIcon.user(
              color: Color(0xff7a7a7a),
            ),
            title: 'View Info',
            onTap: widget.onViewInfoTap,
          ),
          if (!channel.isDistinct)
            OptionListTile(
              leading: StreamSvgIcon.userRemove(
                color: Color(0xff7a7a7a),
              ),
              title: 'Leave Group',
              onTap: () async {
                _showLeaveDialog();
              },
            ),
          if (isOwner)
            OptionListTile(
              leading: StreamSvgIcon.delete(
                color: Colors.red,
              ),
              title: 'Delete Conversation',
              titleColor: Colors.red,
              onTap: () async {
                _showDeleteDialog();
              },
            ),
          OptionListTile(
            leading: StreamSvgIcon.close_small(
              color: Color(0xff7a7a7a),
            ),
            title: 'Cancel',
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() async {
    final res = await showConfirmationDialog(
      context,
      title: 'Delete Conversation',
      okText: 'DELETE',
      question: 'Are you sure you want to delete this conversation?',
      cancelText: 'CANCEL',
      icon: StreamSvgIcon.delete(
        color: Colors.red,
      ),
    );
    var channel = StreamChannel.of(context).channel;
    if (res == true) {
      await channel.delete();
      Navigator.pop(context);
    }
  }

  void _showLeaveDialog() async {
    final res = await showConfirmationDialog(
      context,
      title: 'Leave conversation',
      okText: 'LEAVE',
      question: 'Are you sure you want to leave this conversation?',
      cancelText: 'CANCEL',
      icon: StreamSvgIcon.userRemove(
        color: Colors.red,
      ),
    );
    var channel = StreamChannel.of(context).channel;
    if (res == true) {
      await channel.removeMembers([StreamChat.of(context).user.id]);
      Navigator.pop(context);
    }
  }
}
