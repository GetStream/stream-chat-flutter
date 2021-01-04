import 'package:emojis/emojis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'main.dart';
import 'routes/routes.dart';

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
      backgroundColor: StreamChatTheme.of(context).colorTheme.whiteSnow,
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
      color: StreamChatTheme.of(context).colorTheme.whiteSnow,
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
                  tileColor: StreamChatTheme.of(context).colorTheme.whiteSnow,
                  trailing: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      widget.user.name,
                      style: TextStyle(
                          color: StreamChatTheme.of(context)
                              .colorTheme
                              .black
                              .withOpacity(0.5),
                          fontSize: 16.0),
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
                child: StreamSvgIcon.left(
                  color: StreamChatTheme.of(context).colorTheme.black,
                ),
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
        //     color: StreamChatTheme.of(context).colorTheme.black.withOpacity(0.5),
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
                tileColor: StreamChatTheme.of(context).colorTheme.whiteSnow,
                title: 'Mute user',
                titleTextStyle: StreamChatTheme.of(context).textTheme.body,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: StreamSvgIcon.mute(
                    size: 24.0,
                    color: StreamChatTheme.of(context)
                        .colorTheme
                        .black
                        .withOpacity(0.5),
                  ),
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
        //     color: StreamChatTheme.of(context).colorTheme.black.withOpacity(0.5),
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
          tileColor: StreamChatTheme.of(context).colorTheme.whiteSnow,
          titleTextStyle: StreamChatTheme.of(context).textTheme.body,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: StreamSvgIcon.pictures(
              size: 32.0,
              color:
                  StreamChatTheme.of(context).colorTheme.black.withOpacity(0.5),
            ),
          ),
          trailing: StreamSvgIcon.right(
            color: StreamChatTheme.of(context).colorTheme.grey,
          ),
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
                      onShowMessage: (m, c) async {
                        final client = StreamChat.of(context).client;
                        final message = m;
                        final channel = client.channel(
                          c.type,
                          id: c.id,
                        );
                        if (channel.state == null) {
                          await channel.watch();
                        }
                        Navigator.pushNamed(
                          context,
                          Routes.CHANNEL_PAGE,
                          arguments: ChannelPageArgs(
                            channel: channel,
                            initialMessage: message,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        OptionListTile(
          title: 'Files',
          tileColor: StreamChatTheme.of(context).colorTheme.whiteSnow,
          titleTextStyle: StreamChatTheme.of(context).textTheme.body,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: StreamSvgIcon.files(
              size: 32.0,
              color:
                  StreamChatTheme.of(context).colorTheme.black.withOpacity(0.5),
            ),
          ),
          trailing: StreamSvgIcon.right(
            color: StreamChatTheme.of(context).colorTheme.grey,
          ),
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
          tileColor: StreamChatTheme.of(context).colorTheme.whiteSnow,
          titleTextStyle: StreamChatTheme.of(context).textTheme.body,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: StreamSvgIcon.Icon_group(
              size: 24.0,
              color:
                  StreamChatTheme.of(context).colorTheme.black.withOpacity(0.5),
            ),
          ),
          trailing: StreamSvgIcon.right(
            color: StreamChatTheme.of(context).colorTheme.grey,
          ),
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
      title: 'Delete Conversation',
      tileColor: StreamChatTheme.of(context).colorTheme.whiteSnow,
      titleTextStyle: StreamChatTheme.of(context).textTheme.body.copyWith(
            color: StreamChatTheme.of(context).colorTheme.accentRed,
          ),
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: StreamSvgIcon.delete(
          color: StreamChatTheme.of(context).colorTheme.accentRed,
          size: 24.0,
        ),
      ),
      onTap: () {
        _showDeleteDialog();
      },
      titleColor: StreamChatTheme.of(context).colorTheme.accentRed,
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
        color: StreamChatTheme.of(context).colorTheme.accentRed,
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
          style: TextStyle(
              color: StreamChatTheme.of(context)
                  .colorTheme
                  .black
                  .withOpacity(0.5)),
        );
      } else {
        alternativeWidget = Text(
          'Last seen ${Jiffy(otherMember.lastActive).fromNow()}',
          style: TextStyle(
              color: StreamChatTheme.of(context)
                  .colorTheme
                  .black
                  .withOpacity(0.5)),
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
                color: StreamChatTheme.of(context).colorTheme.accentGreen,
              ),
            ),
            color: StreamChatTheme.of(context).colorTheme.white,
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
      backgroundColor: StreamChatTheme.of(context).colorTheme.whiteSnow,
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Shared Groups',
          style: TextStyle(
              color: StreamChatTheme.of(context).colorTheme.black,
              fontSize: 16.0),
        ),
        leading: Center(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              child: StreamSvgIcon.left(
                color: StreamChatTheme.of(context).colorTheme.black,
                size: 24.0,
              ),
              width: 24.0,
              height: 24.0,
            ),
          ),
        ),
        backgroundColor: StreamChatTheme.of(context).colorTheme.white,
      ),
      body: FutureBuilder<List<Channel>>(
        future: chat.client.queryChannels(
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
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamSvgIcon.message(
                    size: 136.0,
                    color: StreamChatTheme.of(context).colorTheme.greyGainsboro,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'No Shared Groups',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: StreamChatTheme.of(context).colorTheme.black,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Group shared with User will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: StreamChatTheme.of(context)
                          .colorTheme
                          .black
                          .withOpacity(0.5),
                    ),
                  ),
                ],
              ),
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
                      style: TextStyle(
                          color: StreamChatTheme.of(context)
                              .colorTheme
                              .black
                              .withOpacity(0.5)),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 1.0,
              color:
                  StreamChatTheme.of(context).colorTheme.black.withOpacity(.08),
            ),
          ],
        );
      }),
    );
  }
}
