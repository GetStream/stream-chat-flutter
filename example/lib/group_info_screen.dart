import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/option_list_tile.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'chat_info_screen.dart';
import 'main.dart';

class GroupInfoScreen extends StatefulWidget {
  @override
  _GroupInfoScreenState createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  TextEditingController _nameController;

  TextEditingController _searchController;
  String _userNameQuery = '';

  Timer _debounce;
  Function modalSetStateCallback;

  final FocusNode _focusNode = FocusNode();

  int groupMemberListLength;

  void _userNameListener() {
    if (_searchController.text == _userNameQuery) {
      return;
    }
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted && modalSetStateCallback != null) {
        modalSetStateCallback(() {
          _userNameQuery = _searchController.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    var channel = StreamChannel.of(context);
    _nameController = TextEditingController.fromValue(
        TextEditingValue(text: channel.channel.extraData['name'] ?? ''));
    _searchController = TextEditingController()..addListener(_userNameListener);

    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var channel = StreamChannel.of(context);

    return StreamBuilder<List<Member>>(
        stream: channel.channel.state.membersStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              color: StreamChatTheme.of(context).colorTheme.greyGainsboro,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor:
                StreamChatTheme.of(context).colorTheme.greyGainsboro,
            appBar: AppBar(
              elevation: 1.0,
              toolbarHeight: 56.0,
              backgroundColor: StreamChatTheme.of(context).colorTheme.white,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: StreamSvgIcon.left(
                    color: StreamChatTheme.of(context).colorTheme.black,
                  ),
                ),
              ),
              leadingWidth: 36.0,
              title: Column(
                children: [
                  StreamBuilder<ChannelState>(
                      stream: channel.channelStateStream,
                      builder: (context, state) {
                        return Text(
                          _getChannelName(
                              2 * MediaQuery.of(context).size.width / 3,
                              members: snapshot.data,
                              extraData: state.data.channel.extraData,
                              maxFontSize: 16.0),
                          style: TextStyle(
                            color: StreamChatTheme.of(context).colorTheme.black,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }),
                  SizedBox(
                    height: 3.0,
                  ),
                  Text(
                    '${channel.channel.memberCount} Members, ${snapshot?.data?.where((e) => e.user.online)?.length ?? 0} Online',
                    style: TextStyle(
                      color: StreamChatTheme.of(context)
                          .colorTheme
                          .black
                          .withOpacity(0.5),
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              actions: [
                StreamNeumorphicButton(
                  child: InkWell(
                    onTap: () {
                      _buildAddUserModal(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamSvgIcon.userAdd(
                          color: StreamChatTheme.of(context)
                              .colorTheme
                              .accentBlue),
                    ),
                  ),
                ),
              ],
            ),
            body: ListView(
              children: [
                _buildMembers(snapshot.data),
                Container(
                  height: 8.0,
                  color: StreamChatTheme.of(context).colorTheme.greyGainsboro,
                ),
                _buildNameTile(),
                _buildOptionListTiles(),
              ],
            ),
          );
        });
  }

  Widget _buildMembers(List<Member> members) {
    groupMemberListLength ??= members.length > 6 ? 6 : members.length;

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: groupMemberListLength,
          itemBuilder: (context, position) {
            return Material(
              child: InkWell(
                onTap: () {
                  var userMember = members.firstWhere(
                      (e) => e.user.id == StreamChat.of(context).user.id);
                  _showUserInfoModal(
                      members[position].user, userMember.role == 'owner');
                },
                child: Container(
                  height: 65.0,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 12.0),
                            child: UserAvatar(
                              user: members[position].user,
                              constraints: BoxConstraints(
                                  maxHeight: 40.0, maxWidth: 40.0),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  members[position].user.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 1.0,
                                ),
                                Text(
                                  _getLastSeen(members[position].user),
                                  style: TextStyle(
                                      color: StreamChatTheme.of(context)
                                          .colorTheme
                                          .black
                                          .withOpacity(0.5)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              members[position].role == 'owner' ? 'Owner' : '',
                              style: TextStyle(
                                  color: StreamChatTheme.of(context)
                                      .colorTheme
                                      .black
                                      .withOpacity(0.5)),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 1.0,
                        color: StreamChatTheme.of(context)
                            .colorTheme
                            .greyGainsboro,
                      ),
                    ],
                  ),
                ),
              ),
              color: StreamChatTheme.of(context).colorTheme.whiteSnow,
            );
          },
        ),
        if (groupMemberListLength != members.length)
          InkWell(
            onTap: () {
              setState(() {
                groupMemberListLength = members.length;
              });
            },
            child: Material(
              color: StreamChatTheme.of(context).colorTheme.whiteSnow,
              child: Container(
                height: 65.0,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 21.0, vertical: 12.0),
                            child: StreamSvgIcon.down(
                              color:
                                  StreamChatTheme.of(context).colorTheme.white,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${members.length - groupMemberListLength} more',
                                  style: TextStyle(
                                      color: StreamChatTheme.of(context)
                                          .colorTheme
                                          .grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1.0,
                      color:
                          StreamChatTheme.of(context).colorTheme.greyGainsboro,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNameTile() {
    var channel = StreamChannel.of(context).channel;
    var channelName = channel.extraData['name'] ?? '';

    return Material(
      color: StreamChatTheme.of(context).colorTheme.whiteSnow,
      child: Container(
        height: 56.0,
        alignment: Alignment.center,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'NAME',
                style: TextStyle(
                    color: StreamChatTheme.of(context)
                        .colorTheme
                        .black
                        .withOpacity(0.5),
                    fontSize: 12.0),
              ),
            ),
            SizedBox(
              width: 9.0,
            ),
            Expanded(
              child: TextField(
                focusNode: _focusNode,
                controller: _nameController,
                cursorColor: StreamChatTheme.of(context).colorTheme.black,
                decoration: InputDecoration.collapsed(
                  hintText: 'Add a group name',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: StreamChatTheme.of(context)
                        .colorTheme
                        .black
                        .withOpacity(0.5),
                  ),
                ),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  height: 0.82,
                ),
              ),
            ),
            if ((channelName == null) ||
                (channelName != _nameController.text.trim()))
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    child: StreamSvgIcon.close_small(),
                    onTap: () {
                      setState(() {
                        _nameController.text =
                            _getChannelName(MediaQuery.of(context).size.width);
                        _focusNode.unfocus();
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 8.0),
                    child: InkWell(
                      child: StreamSvgIcon.check(
                        color:
                            StreamChatTheme.of(context).colorTheme.accentBlue,
                        size: 24.0,
                      ),
                      onTap: () {
                        StreamChannel.of(context).channel.update({
                          'name': _nameController.text.trim(),
                        }).catchError((err) {
                          setState(() {
                            _nameController.text = channelName;
                            _focusNode.unfocus();
                          });
                        });
                      },
                    ),
                  ),
                ],
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
        // OptionListTile(
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
                separatorColor:
                    StreamChatTheme.of(context).colorTheme.greyGainsboro,
                title: 'Mute group',
                leading: StreamSvgIcon.mute(
                  size: 23.0,
                  color: StreamChatTheme.of(context)
                      .colorTheme
                      .black
                      .withOpacity(0.5),
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
        OptionListTile(
          tileColor: StreamChatTheme.of(context).colorTheme.whiteSnow,
          separatorColor: StreamChatTheme.of(context).colorTheme.greyGainsboro,
          title: 'Photos & Videos',
          leading: StreamSvgIcon.pictures(
            size: 32.0,
            color:
                StreamChatTheme.of(context).colorTheme.black.withOpacity(0.5),
          ),
          trailing: StreamSvgIcon.right(),
          onTap: () {
            var channel = StreamChannel.of(context).channel;

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
          tileColor: StreamChatTheme.of(context).colorTheme.whiteSnow,
          separatorColor: StreamChatTheme.of(context).colorTheme.greyGainsboro,
          title: 'Files',
          leading: StreamSvgIcon.files(
            size: 32.0,
            color:
                StreamChatTheme.of(context).colorTheme.black.withOpacity(0.5),
          ),
          trailing: StreamSvgIcon.right(),
          onTap: () {
            var channel = StreamChannel.of(context).channel;

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
        if (!channel.channel.isDistinct)
          OptionListTile(
            tileColor: StreamChatTheme.of(context).colorTheme.whiteSnow,
            separatorColor:
                StreamChatTheme.of(context).colorTheme.greyGainsboro,
            title: 'Leave Group',
            leading: StreamSvgIcon.userRemove(
              size: 24.0,
              color:
                  StreamChatTheme.of(context).colorTheme.black.withOpacity(0.5),
            ),
            trailing: Container(
              height: 24.0,
              width: 24.0,
            ),
            onTap: () async {
              await channel.channel
                  .removeMembers([StreamChat.of(context).user.id]);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }

  void _buildAddUserModal(context) {
    var channel = StreamChannel.of(context).channel;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, modalSetState) {
          modalSetStateCallback = modalSetState;
          return Padding(
            padding: EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
            child: Material(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Scaffold(
                body: UsersBloc(
                  child: Column(
                    children: [
                      _buildTextInputSection(modalSetState),
                      Expanded(
                        child: UserListView(
                          selectedUsers: {},
                          onUserTap: (user, _) async {
                            _searchController.clear();

                            await channel.addMembers([user.id]);
                            Navigator.pop(context);
                            setState(() {});
                          },
                          crossAxisCount: 4,
                          pagination: PaginationParams(
                            limit: 25,
                          ),
                          filter: {
                            if (_searchController.text.isNotEmpty)
                              'name': {
                                r'$autocomplete': _userNameQuery,
                              },
                            'id': {
                              r'$nin': [
                                StreamChat.of(context).user.id,
                                ...channel.state.members.map((e) => e.userId),
                              ],
                            },
                          },
                          sort: [
                            SortOption(
                              'name',
                              direction: 1,
                            ),
                          ],
                          emptyBuilder: (_) {
                            return LayoutBuilder(
                              builder: (context, viewportConstraints) {
                                return SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: viewportConstraints.maxHeight,
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(24),
                                            child: StreamSvgIcon.search(
                                              size: 96,
                                              color: StreamChatTheme.of(context)
                                                  .colorTheme
                                                  .grey,
                                            ),
                                          ),
                                          Text(
                                              'No user matches these keywords...'),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildTextInputSection(modalSetState) {
    return Column(
      children: [
        SizedBox(
          height: 16.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                cursorColor: StreamChatTheme.of(context).colorTheme.black,
                autofocus: true,
                decoration: InputDecoration(
                  isDense: true,
                  prefixIconConstraints: BoxConstraints.tight(Size(36.0, 44.0)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 6.0),
                    child: StreamSvgIcon.search(
                      color: StreamChatTheme.of(context).colorTheme.black,
                    ),
                  ),
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                        color: StreamChatTheme.of(context)
                            .colorTheme
                            .black
                            .withOpacity(0.08)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                        color: StreamChatTheme.of(context)
                            .colorTheme
                            .black
                            .withOpacity(0.08)),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            IconButton(
              icon: StreamSvgIcon.close_small(
                color: StreamChatTheme.of(context)
                    .colorTheme
                    .black
                    .withOpacity(0.5),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ],
    );
  }

  void _showUserInfoModal(User user, bool isUserAdmin) {
    var channel = StreamChannel.of(context).channel;

    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      builder: (context) {
        return StreamChannel(
          channel: channel,
          child: Material(
            color: StreamChatTheme.of(context).colorTheme.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 24.0,
                ),
                Center(
                  child: Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                _buildConnectedTitleState(user),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: UserAvatar(
                      user: user,
                      constraints: BoxConstraints(
                        maxHeight: 64.0,
                        minHeight: 64.0,
                      ),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
                if (StreamChat.of(context).user.id != user.id)
                  _buildModalListTile(
                    context,
                    StreamSvgIcon.user(
                      color: StreamChatTheme.of(context).colorTheme.grey,
                      size: 24.0,
                    ),
                    'View info',
                    () async {
                      var client = StreamChat.of(context).client;

                      var c = client.channel('messaging', extraData: {
                        'members': [
                          user.id,
                          StreamChat.of(context).user.id,
                        ],
                      });

                      await c.watch();

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StreamChannel(
                            channel: c,
                            child: ChatInfoScreen(
                              user: user,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                _buildModalListTile(
                  context,
                  StreamSvgIcon.message(
                    color: StreamChatTheme.of(context).colorTheme.grey,
                    size: 24.0,
                  ),
                  'Message',
                  () async {
                    var client = StreamChat.of(context).client;

                    var c = client.channel('messaging', extraData: {
                      'members': [
                        user.id,
                        StreamChat.of(context).user.id,
                      ],
                    });

                    await c.watch();

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StreamChannel(
                          channel: c,
                          child: ChannelPage(),
                        ),
                      ),
                    );
                  },
                ),
                if (!channel.isDistinct &&
                    StreamChat.of(context).user.id != user.id &&
                    isUserAdmin)
                  _buildModalListTile(
                      context,
                      StreamSvgIcon.Icon_user_settings(
                        color: StreamChatTheme.of(context).colorTheme.grey,
                        size: 24.0,
                      ),
                      'Make Owner', () {
                    // TODO: I have no clue how to make someone an owner
                  }),
                if (!channel.isDistinct &&
                    StreamChat.of(context).user.id != user.id &&
                    isUserAdmin)
                  _buildModalListTile(
                      context,
                      StreamSvgIcon.userRemove(
                        color: StreamChatTheme.of(context).colorTheme.accentRed,
                        size: 24.0,
                      ),
                      'Remove From Group', () async {
                    await channel.removeMembers([user.id]);
                    Navigator.pop(context);
                  }, color: StreamChatTheme.of(context).colorTheme.accentRed),
                _buildModalListTile(
                    context,
                    StreamSvgIcon.close_small(
                      color: StreamChatTheme.of(context).colorTheme.grey,
                      size: 24.0,
                    ),
                    'Cancel', () {
                  Navigator.pop(context);
                }),
              ],
            ),
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
    );
  }

  void _showRemoveUserModal(User user) {}

  Widget _buildConnectedTitleState(User user) {
    var alternativeWidget;

    final otherMember = user;

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
        if (user.online)
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
            color: StreamChatTheme.of(context).colorTheme.white,
          ),
        alternativeWidget,
      ],
    );
  }

  Widget _buildModalListTile(
      BuildContext context, Widget leading, String title, VoidCallback onTap,
      {Color color}) {
    color ??= StreamChatTheme.of(context).colorTheme.black;

    return Material(
      color: StreamChatTheme.of(context).colorTheme.white,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              height: 1.0,
              color: StreamChatTheme.of(context).colorTheme.greyGainsboro,
            ),
            Container(
              height: 64.0,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: leading,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style:
                          TextStyle(color: color, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getChannelName(double width,
      {List<Member> members, Map extraData, double maxFontSize}) {
    String title;
    var client = StreamChat.of(context);
    if (extraData['name'] == null) {
      final otherMembers =
          members.where((member) => member.user.id != client.user.id);
      if (otherMembers.isNotEmpty) {
        final maxWidth = width;
        final maxChars = maxWidth / maxFontSize;
        var currentChars = 0;
        final currentMembers = <Member>[];
        otherMembers.forEach((element) {
          final newLength = currentChars + element.user.name.length;
          if (newLength < maxChars) {
            currentChars = newLength;
            currentMembers.add(element);
          }
        });

        final exceedingMembers = otherMembers.length - currentMembers.length;
        title =
            '${currentMembers.map((e) => e.user.name).join(', ')} ${exceedingMembers > 0 ? '+ $exceedingMembers' : ''}';
      } else {
        title = 'No title';
      }
    } else {
      title = extraData['name'];
    }
    return title;
  }

  String _getLastSeen(User user) {
    if (user.online) {
      return 'Online';
    } else {
      return 'Last seen ${Jiffy(user.lastActive).fromNow()}';
    }
  }
}
