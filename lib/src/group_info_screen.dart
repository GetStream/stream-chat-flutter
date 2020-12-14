import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/option_list_tile.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';

import '../stream_chat_flutter.dart';
import 'channel_file_display_screen.dart';
import 'channel_media_display_screen.dart';

class GroupInfoScreen extends StatefulWidget {
  @override
  _GroupInfoScreenState createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  Future _memberQueryFuture;
  TextEditingController _nameController;

  bool _userSearchMode = false;
  TextEditingController _searchController;
  bool _loading = false;
  String _userNameQuery = '';

  Timer _debounce;
  Function modalSetStateCallback;

  void _userNameListener() {
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

    _memberQueryFuture = channel.channel.queryMembers(
      filter: {},
    );
    _nameController = TextEditingController.fromValue(
        TextEditingValue(text: channel.channel.extraData['name']));
    _searchController = TextEditingController()..addListener(_userNameListener);
  }

  @override
  Widget build(BuildContext context) {
    var channel = StreamChannel.of(context);

    return Scaffold(
      backgroundColor: Color(0xffdbdbdb),
      appBar: AppBar(
        elevation: 1.0,
        toolbarHeight: 56.0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: StreamSvgIcon.left(),
          ),
        ),
        leadingWidth: 36.0,
        title: Column(
          children: [
            // TODO: Add member names instead of Demo (if name = null)
            Text(
              channel.channel.extraData['name'] ?? 'Demo',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              height: 3.0,
            ),
            FutureBuilder<QueryMembersResponse>(
                future: _memberQueryFuture,
                builder: (context, snapshot) {
                  return Text(
                    '${channel.channel.memberCount} Members, ${snapshot?.data?.members?.where((e) => e.user.online)?.length ?? 0} Online',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5), fontSize: 12.0),
                  );
                }),
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
                    color: StreamChatTheme.of(context).accentColor),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildMembers(),
          Container(
            height: 8.0,
            color: Color(0xffdbdbdb),
          ),
          _buildNameTile(),
          _buildOptionListTiles(),
        ],
      ),
    );
  }

  Widget _buildMembers() {
    var channel = StreamChannel.of(context);

    return FutureBuilder<QueryMembersResponse>(
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data.members.length,
          itemBuilder: (context, position) {
            return Material(
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
                            user: snapshot.data.members[position].user,
                            constraints:
                                BoxConstraints(maxHeight: 40.0, maxWidth: 40.0),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data.members[position].user.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 1.0,
                              ),
                              Text(
                                _getLastSeen(
                                    snapshot.data.members[position].user),
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.5)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            snapshot.data.members[position].user.id ==
                                    channel.channel.createdBy.id
                                ? 'Owner'
                                : '',
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.5)),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 1.0,
                      color: Color(0xffdbdbdb),
                    ),
                  ],
                ),
              ),
              color: Colors.white,
            );
          },
        );
      },
      future: _memberQueryFuture,
    );
  }

  Widget _buildNameTile() {
    return Material(
      color: Colors.white,
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
                    color: Colors.black.withOpacity(0.5), fontSize: 12.0),
              ),
            ),
            SizedBox(
              width: 9.0,
            ),
            Expanded(
              child: TextField(
                controller: _nameController,
                cursorColor: Colors.black,
                decoration: InputDecoration.collapsed(
                  hintText: 'Add a group name',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
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
        // OptionListTile(
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
                title: 'Mute group',
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
        OptionListTile(
          title: 'Photos & Videos',
          leading: StreamSvgIcon.pictures(
            size: 32.0,
            color: Colors.black.withOpacity(0.5),
          ),
          trailing: StreamSvgIcon.right(),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChannelMediaDisplayScreen()));
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChannelFileDisplayScreen()));
          },
        ),
        OptionListTile(
          title: 'Leave Group',
          leading: StreamSvgIcon.userRemove(
            size: 24.0,
            color: Colors.black.withOpacity(0.5),
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
                            _memberQueryFuture = channel.queryMembers(
                              filter: {},
                            );
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
                              r'$ne': StreamChat.of(context).user.id,
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
                                              color: Colors.grey,
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
                cursorColor: Colors.black,
                autofocus: true,
                decoration: InputDecoration(
                  isDense: true,
                  prefixIconConstraints: BoxConstraints.tight(Size(36.0, 44.0)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 6.0),
                    child: StreamSvgIcon.search(
                      color: Colors.black,
                    ),
                  ),
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide:
                        BorderSide(color: Colors.black.withOpacity(0.08)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide:
                        BorderSide(color: Colors.black.withOpacity(0.08)),
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
                color: Colors.black.withOpacity(0.5),
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

  String _getLastSeen(User user) {
    if (user.online) {
      return 'Online';
    } else {
      return 'Last seen ${Jiffy(user.lastActive).fromNow()}';
    }
  }
}
