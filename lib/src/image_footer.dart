import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/back_button.dart';
import 'package:stream_chat_flutter/src/channel_info.dart';
import 'package:stream_chat_flutter/src/channel_name.dart';
import 'package:stream_chat_flutter/src/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/stream_icons.dart';
import 'package:stream_chat_flutter/src/user_avatar.dart';

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

  /// Creates a channel header
  ImageFooter({
    Key key,
    this.onBackPressed,
    this.onTitleTap,
    this.onImageTap,
    this.currentPage = 0,
    this.totalPages = 0,
    this.urls,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  _ImageFooterState createState() => _ImageFooterState();

  @override
  final Size preferredSize;
}

class _ImageFooterState extends State<ImageFooter> {
  Future<QueryUsersResponse> _userQuery;

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
                StreamIcons.share,
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

    return AppBar(
      brightness: Theme.of(context).brightness,
      elevation: 1,
      leading: IconButton(
        icon: Icon(StreamIcons.share),
        onPressed: widget.onBackPressed,
      ),
      backgroundColor:
          StreamChatTheme.of(context).channelTheme.channelHeaderTheme.color,
      actions: <Widget>[
        IconButton(
          icon: Icon(StreamIcons.grid),
          onPressed: () {},
        ),
      ],
      centerTitle: true,
      title: InkWell(
        onTap: widget.onTitleTap,
        child: Container(
          height: widget.preferredSize.height,
          width: widget.preferredSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Demo name',
                style: StreamChatTheme.of(context)
                    .channelTheme
                    .channelHeaderTheme
                    .title,
              ),
              Text(
                '1 of 1',
                style: StreamChatTheme.of(context).channelPreviewTheme.subtitle,
              ),
            ],
          ),
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
                    topRight: Radius.circular(8.0),
                    topLeft: Radius.circular(8.0),
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              child: Row(
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
                      onPressed: () {},
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
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: FutureBuilder<QueryUsersResponse>(
                    future: _userQuery,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, position) {
                          var user = snapshot.data.users[position];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    UserAvatar(
                                      onTap: (user) {},
                                      user: user,
                                      constraints: BoxConstraints.tightFor(
                                        height: 64,
                                        width: 64,
                                      ),
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    user.name,
                                    style: Theme.of(context).textTheme.subtitle2,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: snapshot.data.users.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 0.75,
                        ),
                      );
                    }),
              ),
            ),
          ],
        );
      },
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
}
