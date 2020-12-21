import 'package:emojis/emojis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Detail screen for a 1:1 chat correspondence
class ChatInfoScreen extends StatefulWidget {
  /// User in consideration
  final User user;

  const ChatInfoScreen({Key key, this.user}) : super(key: key);

  @override
  _ChatInfoScreenState createState() => _ChatInfoScreenState();
}

class _ChatInfoScreenState extends State<ChatInfoScreen> {
  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    return Scaffold(
      backgroundColor: Color(0xFFe6e6e6),
      body: ListView(
        children: [
          _buildUserHeader(),
          SizedBox(
            height: 8.0,
          ),
          _buildOptionListTiles(),
          SizedBox(
            height: 8.0,
          ),
          if ([
            'admin',
            'owner',
          ].contains(channel.state.members
              .firstWhere((m) => m.userId == channel.client.state.user.id,
                  orElse: () => null)
              ?.role))
            _buildDeleteListTile(),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: UserAvatar(
                    user: widget.user,
                    constraints: BoxConstraints(
                      maxWidth: 72.0,
                      maxHeight: 72.0,
                    ),
                    borderRadius: BorderRadius.circular(36.0),
                    showOnlineStatus: false,
                  ),
                ),
                //SizedBox(height: 4.0),
                Text(
                  widget.user.name,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 7.0),
                _buildConnectedTitleState(),
                SizedBox(height: 15.0),
                OptionListTile(
                  title: '@${widget.user.id}',
                  trailing: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      widget.user.name,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.5), fontSize: 16.0),
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
            Positioned(
              top: 21,
              left: 16,
              child: InkWell(
                child: StreamSvgIcon.left(),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionListTiles() {
    var channel = StreamChannel.of(context);

    return Column(
      children: [
        // _OptionListTile(
        //   title: 'Notifications',
        //   leading: StreamSvgIcon.Icon_notification(
        //     size: 24.0,
        //     color: Colors.black.withOpacity(0.5),
        //   ),
        //   trailing: CupertinoSwitch(
        //     value: true,
        //     onChanged: (val) {},
        //   ),
        //   onTap: () {},
        // ),
        StreamBuilder<bool>(
            stream: StreamChannel.of(context).channel.isMutedStream,
            builder: (context, snapshot) {
              return OptionListTile(
                title: 'Mute user',
                leading: StreamSvgIcon.mute(
                  size: 23.0,
                  color: Colors.black.withOpacity(0.5),
                ),
                trailing: snapshot.data == null
                    ? CircularProgressIndicator()
                    : CupertinoSwitch(
                        value: snapshot.data,
                        onChanged: (val) {
                          if (snapshot.data) {
                            channel.channel.unmute();
                          } else {
                            channel.channel.mute();
                          }
                        },
                      ),
                onTap: () {},
              );
            }),
        // _OptionListTile(
        //   title: 'Block User',
        //   leading: StreamSvgIcon.Icon_user_delete(
        //     size: 24.0,
        //     color: Colors.black.withOpacity(0.5),
        //   ),
        //   trailing: CupertinoSwitch(
        //     value: widget.user.banned,
        //     onChanged: (val) {
        //       if (widget.user.banned) {
        //         channel.channel.shadowBan(widget.user.id, {});
        //       } else {
        //         channel.channel.unbanUser(widget.user.id);
        //       }
        //     },
        //   ),
        //   onTap: () {},
        // ),
        OptionListTile(
          title: 'Photos & Videos',
          leading: StreamSvgIcon.pictures(
            size: 32.0,
            color: Colors.black.withOpacity(0.5),
          ),
          trailing: StreamSvgIcon.right(),
          onTap: () {
            final channel = StreamChannel.of(context).channel;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StreamChannel(
                  channel: channel,
                  child: MessageSearchBloc(
                    child: ChannelMediaDisplayScreen(
                      sortOptions: [
                        SortOption(
                          'created_at',
                          direction: SortOption.ASC,
                        ),
                      ],
                      paginationParams: PaginationParams(limit: 20),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        OptionListTile(
          title: 'Files',
          leading: StreamSvgIcon.files(
            size: 32.0,
            color: Colors.black.withOpacity(0.5),
          ),
          trailing: StreamSvgIcon.right(),
          onTap: () {
            final channel = StreamChannel.of(context).channel;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StreamChannel(
                  channel: channel,
                  child: MessageSearchBloc(
                    child: ChannelFileDisplayScreen(
                      sortOptions: [
                        SortOption(
                          'created_at',
                          direction: SortOption.ASC,
                        ),
                      ],
                      paginationParams: PaginationParams(limit: 20),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        OptionListTile(
          title: 'Shared groups',
          leading: StreamSvgIcon.Icon_group(
            size: 24.0,
            color: Colors.black.withOpacity(0.5),
          ),
          trailing: StreamSvgIcon.right(),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => _SharedGroupsScreen(
                        StreamChat.of(context).user, widget.user)));
          },
        ),
      ],
    );
  }

  Widget _buildDeleteListTile() {
    return OptionListTile(
      title: 'Delete',
      leading: StreamSvgIcon.delete(
        color: Colors.red,
        size: 24.0,
      ),
      onTap: () {
        _showDeleteDialog();
      },
      titleColor: Colors.red,
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
      await channel.delete().then((value) {
        Navigator.pop(context);
      });
    }
  }

  Widget _buildConnectedTitleState() {
    var alternativeWidget;

    final otherMember = widget.user;

    if (otherMember != null) {
      if (otherMember.online) {
        alternativeWidget = Text(
          'Online',
          style: TextStyle(color: Colors.black.withOpacity(0.5)),
        );
      } else {
        alternativeWidget = Text(
          'Last seen ${Jiffy(otherMember.lastActive).fromNow()}',
          style: TextStyle(color: Colors.black.withOpacity(0.5)),
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.user.online)
          Material(
            type: MaterialType.circle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              constraints: BoxConstraints.tightFor(
                width: 28,
                height: 12,
              ),
              child: Material(
                shape: CircleBorder(),
                color: Color(0xff20E070),
              ),
            ),
            color: Colors.white,
          ),
        alternativeWidget,
      ],
    );
  }
}

class _SharedGroupsScreen extends StatefulWidget {
  final User mainUser;
  final User otherUser;

  _SharedGroupsScreen(this.mainUser, this.otherUser);

  @override
  __SharedGroupsScreenState createState() => __SharedGroupsScreenState();
}

class __SharedGroupsScreenState extends State<_SharedGroupsScreen> {
  @override
  Widget build(BuildContext context) {
    var chat = StreamChat.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Shared Groups',
          style: TextStyle(color: Colors.black, fontSize: 16.0),
        ),
        leading: Center(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              child: StreamSvgIcon.left(
                color: Colors.black,
                size: 24.0,
              ),
              width: 24.0,
              height: 24.0,
            ),
          ),
        ),
        backgroundColor: StreamChatTheme.of(context).primaryColor,
      ),
      body: StreamBuilder<List<Channel>>(
        stream: chat.client.queryChannels(
          filter: {
            r'$and': [
              {
                'members': {
                  r'$in': [widget.otherUser.id],
                },
              },
              {
                'members': {
                  r'$in': [widget.mainUser.id],
                },
              }
            ],
          },
        ),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, position) {
              return StreamChannel(
                channel: snapshot.data[position],
                child: _buildListTile(snapshot.data[position]),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildListTile(Channel channel) {
    var extraData = channel.extraData;
    var members = channel.state.members;

    var textStyle = TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold);

    return Container(
      height: 64.0,
      child: LayoutBuilder(builder: (context, constraints) {
        String title;
        if (extraData['name'] == null) {
          final otherMembers = members.where(
              (member) => member.userId != StreamChat.of(context).user.id);
          if (otherMembers.isNotEmpty) {
            final maxWidth = constraints.maxWidth;
            final maxChars = maxWidth / textStyle.fontSize;
            var currentChars = 0;
            final currentMembers = <Member>[];
            otherMembers.forEach((element) {
              final newLength = currentChars + element.user.name.length;
              if (newLength < maxChars) {
                currentChars = newLength;
                currentMembers.add(element);
              }
            });

            final exceedingMembers =
                otherMembers.length - currentMembers.length;
            title =
                '${currentMembers.map((e) => e.user.name).join(', ')} ${exceedingMembers > 0 ? '+ $exceedingMembers' : ''}';
          } else {
            title = 'No title';
          }
        } else {
          title = extraData['name'];
        }

        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChannelImage(
                      channel: channel,
                      constraints:
                          BoxConstraints(maxWidth: 40.0, maxHeight: 40.0),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    title,
                    style: textStyle,
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${channel.memberCount} members',
                      style: TextStyle(color: Colors.black.withOpacity(0.5)),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 1.0,
              color: Color(0xffe6e6e6),
            ),
          ],
        );
      }),
    );
  }
}
