import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/back_button.dart';
import 'package:stream_chat_flutter/src/channel_info.dart';
import 'package:stream_chat_flutter/src/channel_name.dart';
import 'package:stream_chat_flutter/src/message_input.dart';
import 'package:stream_chat_flutter/src/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/stream_icons.dart';
import 'package:stream_chat_flutter/src/user_avatar.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import './channel_name.dart';
import 'channel_image.dart';
import 'stream_channel.dart';

class ImageFooter extends StatefulWidget {
  /// Callback to call when pressing the back button.
  /// By default it calls [Navigator.pop]
  final VoidCallback onBackPressed;

  /// Callback to call when the header is tapped.
  final VoidCallback onTitleTap;

  /// Callback to call when the image is tapped.
  final VoidCallback onImageTap;

  final int currentPage;
  final int totalPages;

  final List<String> urls;
  final Message message;

  /// Creates a channel header
  ImageFooter({
    Key key,
    this.onBackPressed,
    this.onTitleTap,
    this.onImageTap,
    this.currentPage = 0,
    this.totalPages = 0,
    this.urls,
    this.message,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  _ImageFooterState createState() => _ImageFooterState();

  @override
  final Size preferredSize;
}

class _ImageFooterState extends State<ImageFooter> {
  Future<QueryUsersResponse> _userQuery;
  bool _userSearchMode = false;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  List<User> _selectedUsers = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _userQuery = _queryUsers(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color:
            StreamChatTheme.of(context).channelTheme.channelHeaderTheme.color,
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                StreamIcons.share_1,
                size: 24.0,
                color: Colors.black,
              ),
              onPressed: () {
                _buildShareModal(context);
              },
            ),
            InkWell(
              onTap: widget.onTitleTap,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '${widget.currentPage + 1} of ${widget.totalPages}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                StreamIcons.grid,
                color: Colors.black,
              ),
              onPressed: () {
                _buildPhotosModal(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosModal(context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.0),
                    topLeft: Radius.circular(16.0),
                  )),
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Photos',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        StreamIcons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, position) {
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: AspectRatio(
                      child: CachedNetworkImage(
                        imageUrl: widget.urls[position],
                        fit: BoxFit.cover,
                      ),
                      aspectRatio: 1.0,
                    ),
                  );
                },
                itemCount: widget.urls.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShareModal(context) {
    final channel = StreamChannel.of(context).channel;

    showDialog(
      context: context,
      builder: (context) {
        return StreamChannel(
          channel: channel,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: StatefulBuilder(builder: (modalContext, modalSetState) {
              return Align(
                alignment: _userSearchMode
                    ? Alignment.topCenter
                    : Alignment.bottomCenter,
                child: Material(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Stack(
                    children: [
                      ListView(
                        children: [
                          if (!_userSearchMode &&
                              MediaQuery.of(context).viewInsets.bottom == 0.0)
                            GestureDetector(
                              child: Container(
                                height:
                                    MediaQuery.of(modalContext).size.height / 2,
                                color: Colors.transparent,
                              ),
                              onTapUp: (val) {
                                Navigator.pop(modalContext);
                              },
                            ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16.0),
                                  topLeft: Radius.circular(16.0),
                                )),
                            child: _buildTextInputSection(modalSetState),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(
                                    _userSearchMode ? 16.0 : 0.0),
                                bottomLeft: Radius.circular(
                                    _userSearchMode ? 16.0 : 0.0),
                              ),
                            ),
                            child: FutureBuilder<QueryUsersResponse>(
                                future: _userQuery,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  var filteredData =
                                      snapshot.data.users.toList();

                                  if (_userSearchMode &&
                                      _searchController.text.length > 0) {
                                    filteredData = snapshot.data.users
                                        .where((element) => element.name
                                            .toLowerCase()
                                            .contains(_searchController.text
                                                .toLowerCase()))
                                        .toList();
                                  }

                                  return GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, position) {
                                      var user = filteredData[position];
                                      var isUserSelected =
                                          _selectedUsers.contains(user);

                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Stack(
                                              children: [
                                                CircleAvatar(
                                                  maxRadius: 32.0,
                                                  child: UserAvatar(
                                                    onTap: (user) {
                                                      if (isUserSelected) {
                                                        _selectedUsers
                                                            .remove(user);
                                                      } else {
                                                        _selectedUsers
                                                            .add(user);
                                                      }
                                                      modalSetState(() {});
                                                    },
                                                    user: user,
                                                    constraints:
                                                        BoxConstraints.tightFor(
                                                      height: isUserSelected
                                                          ? 56
                                                          : 64,
                                                      width: isUserSelected
                                                          ? 56
                                                          : 64,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                user.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2,
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: filteredData.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio: 0.75,
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                      if (!_userSearchMode && _selectedUsers.isEmpty)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: Colors.white,
                            height: 48.0,
                            margin: EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Material(
                              child: InkWell(
                                onTap: () async {
                                  await GallerySaver.saveImage(
                                      widget.urls[widget.currentPage].split('?')[0]);
                                  Navigator.pop(context);
                                },
                                child: SizedBox.expand(
                                  child: Center(
                                    child: Text(
                                      'Save to Photos',
                                      style: TextStyle(
                                        color: StreamChatTheme.of(modalContext)
                                            .accentColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (!_userSearchMode && _selectedUsers.isNotEmpty)
                        _buildShareTextInputSection(modalSetState),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildTextInputSection(modalSetState) {
    if (_userSearchMode) {
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
                  onChanged: (val) {
                    modalSetState(() {});
                  },
                  cursorColor: Colors.black,
                  autofocus: true,
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: Icon(
                      StreamIcons.search,
                      color: Colors.black,
                    ),
                    hintText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide:
                          BorderSide(color: Colors.black.withOpacity(0.08)),
                      gapPadding: 0.0,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide:
                          BorderSide(color: Colors.black.withOpacity(0.08)),
                      gapPadding: 0.0,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              IconButton(
                icon: Icon(StreamIcons.close_circle),
                onPressed: () {
                  modalSetState(() {
                    _userSearchMode = false;
                  });
                  setState(() {});
                },
              )
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: IconButton(
              icon: Icon(
                StreamIcons.search,
                color: Colors.black,
              ),
              iconSize: 24.0,
              onPressed: () {
                modalSetState(() {
                  _userSearchMode = true;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select a Chat to Share',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: IconButton(
              icon: Icon(
                StreamIcons.share,
                color: Colors.black,
              ),
              iconSize: 24.0,
              onPressed: () async {
                var url = widget.urls[widget.currentPage];
                var type = url?.split('?')?.first?.split('.')?.last ?? 'jpg';
                var request = await HttpClient().getUrl(Uri.parse(url));
                var response = await request.close();
                var bytes = await consolidateHttpClientResponseBytes(response);
                await Share.file('File', 'image.$type', bytes, 'image/$type');
              },
            ),
          ),
        ],
      );
    }
  }

  Widget _buildShareTextInputSection(modalSetState) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        height: 56.0,
        child: _loading ? Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        ) : Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: _messageController,
                  onChanged: (val) {
                    modalSetState(() {});
                  },
                  onTap: () {
                    modalSetState(() {});
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    prefixText: '     ',
                    hintText: 'Add a comment',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.16),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.16),
                        )),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                  ),
                ),
              ),
            ),
            AnimatedCrossFade(
              crossFadeState: _messageController.text.isNotEmpty
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: IconTheme(
                data: StreamChatTheme.of(context)
                    .channelTheme
                    .messageInputButtonIconTheme,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        modalSetState(() {
                          _loading = true;
                        });
                        await sendMessage();
                        modalSetState(() {
                          _loading = false;
                        });
                      },
                      child: Transform.rotate(
                        angle: -pi / 2,
                        child: Icon(
                          StreamIcons.send_message,
                          color: StreamChatTheme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              secondChild: IconTheme(
                data: StreamChatTheme.of(context)
                    .channelTheme
                    .messageInputButtonIconTheme,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: InkWell(
                    onTap: () {},
                    child: Icon(
                      StreamIcons.send_message,
                      color: Colors.grey,
                    ),
                  )),
                ),
              ),
              duration: Duration(milliseconds: 300),
              alignment: Alignment.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<QueryUsersResponse> _queryUsers(context) {
    return StreamChat.of(context).client.queryUsers(
      pagination: PaginationParams(
        limit: 25,
      ),
      sort: [
        SortOption(
          'name',
          direction: SortOption.ASC,
        ),
      ],
    );
  }

  /// Sends the current message
  Future sendMessage() async {
    var text = _messageController.text.trim();

    final attachments = widget.message.attachments;

    _messageController.clear();

    final client = StreamChat.of(context).client;

    for (var user in _selectedUsers) {
      var c = client.channel('messaging', extraData: {
        'members': [
          user.id,
          StreamChat.of(context).user.id,
        ],
      });

      await c.create();

      Future sendingFuture;
      Message message;

      message = (Message()).copyWith(
        text: text,
        attachments: attachments,
        mentionedUsers: [],
        showInChannel: false,
      );

      sendingFuture = c.sendMessage(message);

      await sendingFuture;
    }

    _selectedUsers.clear();
    Navigator.pop(context);
  }
}
