import 'package:flutter/material.dart';

import '../stream_chat_flutter.dart';
import 'channel_info.dart';
import 'option_list_tile.dart';

class ChannelActionsModal extends StatefulWidget {
  VoidCallback onViewInfoTap;

  ChannelActionsModal({this.onViewInfoTap});

  @override
  _ChannelActionsModalState createState() => _ChannelActionsModalState();
}

class _ChannelActionsModalState extends State<ChannelActionsModal> {
  @override
  Widget build(BuildContext context) {
    var channel = StreamChannel.of(context).channel;

    return Material(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: FutureBuilder<QueryMembersResponse>(
        future: StreamChannel.of(context).channel.queryMembers(
          filter: {},
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: 100.0,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          var userAsMember = snapshot.data.members
              .firstWhere((e) => e.user.id == StreamChat.of(context).user.id);
          var isOwner = userAsMember.role == 'owner';

          return Column(
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
                textStyle:
                    StreamChatTheme.of(context).channelPreviewTheme.subtitle,
              ),
              SizedBox(
                height: 17.0,
              ),
              if (channel.isDistinct && channel.memberCount == 2)
                Column(
                  children: [
                    UserAvatar(
                      user: snapshot.data.members
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
                      snapshot.data.members
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
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.members.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            UserAvatar(
                              user: snapshot.data.members[index].user,
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
                              snapshot.data.members[index].user.name,
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
                height: 24,
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
                    var channel = StreamChannel.of(context).channel;

                    await channel
                        .removeMembers([StreamChat.of(context).user.id]);
                    Navigator.pop(context);
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
                    var channel = StreamChannel.of(context).channel;

                    await channel.delete();
                    Navigator.pop(context);
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
          );
        },
      ),
    );
  }
}
