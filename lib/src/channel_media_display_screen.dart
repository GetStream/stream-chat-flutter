import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/lazy_load_scroll_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

class ChannelMediaDisplayScreen extends StatefulWidget {
  /// The sorting used for the channels matching the filters.
  /// Sorting is based on field and direction, multiple sorting options can be provided.
  /// You can sort based on last_updated, last_message_at, updated_at, created_at or member_count.
  /// Direction can be ascending or descending.
  final List<SortOption> sortOptions;

  /// Pagination parameters
  /// limit: the number of users to return (max is 30)
  /// offset: the offset (max is 1000)
  /// message_limit: how many messages should be included to each channel
  final PaginationParams paginationParams;

  ChannelMediaDisplayScreen({this.sortOptions, this.paginationParams});

  @override
  _ChannelMediaDisplayScreenState createState() =>
      _ChannelMediaDisplayScreenState();
}

class _ChannelMediaDisplayScreenState extends State<ChannelMediaDisplayScreen> {
  @override
  void initState() {
    super.initState();
    final messageSearchBloc = MessageSearchBloc.of(context);
    messageSearchBloc.search(
      filter: {
        'cid': {
          r'$in': ['messaging:${StreamChannel.of(context).channel.id}']
        }
      },
      messageFilter: {
        'attachments.type': {
          r'$in': ['image', 'video']
        },
      },
      sort: widget.sortOptions,
      pagination: widget.paginationParams,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Photos & Videos',
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
      body: _buildMediaGrid(),
    );
  }

  Widget _buildMediaGrid() {
    final messageSearchBloc = MessageSearchBloc.of(context);

    return StreamBuilder<List<GetMessageResponse>>(
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: StreamChatTheme.of(context).accentColor,
            ),
          );
        }

        if (snapshot.data.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamSvgIcon.pictures(
                  size: 136.0,
                  color: Color(0xffdbdbdb),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  'No Media',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xff000000),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  'Photos or video sent in this chat will \nappear here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xff000000).withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
        }

        List<_AssetPackage> media = [];

        for (var item in snapshot.data) {
          item.message.attachments
              .where((e) => e.type == 'image' || e.type == 'video')
              .forEach((e) {
            VideoPlayerController controller;
            if (e.type == 'video') {
              controller = VideoPlayerController.network(e.assetUrl);
              controller.initialize();
            }
            media.add(_AssetPackage(e, item.message, controller));
          });
        }

        return LazyLoadScrollView(
          onEndOfPage: () => messageSearchBloc.search(
            filter: {
              'cid': {
                r'$in': ['messaging:${StreamChannel.of(context).channel.id}']
              }
            },
            messageFilter: {
              'attachments.type': {
                r'$in': ['image', 'video']
              },
            },
            sort: widget.sortOptions,
            pagination: widget.paginationParams.copyWith(
              offset: messageSearchBloc.messageResponses?.length ?? 0,
            ),
          ),
          child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, position) {
              var channel = StreamChannel.of(context).channel;

              return Padding(
                padding: const EdgeInsets.all(1.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StreamChannel(
                          channel: channel,
                          child: FullScreenMedia(
                            mediaAttachments: [
                              media[position].attachment,
                            ],
                            message: media[position].message,
                            sentAt: media[position].message.createdAt,
                            userName: media[position].message.user.name,
                          ),
                        ),
                      ),
                    );
                  },
                  child: media[position].attachment.type == 'image'
                      ? ImageAttachment(
                          attachment: media[position].attachment,
                          message: media[position].message,
                          size: Size(
                            MediaQuery.of(context).size.width * 0.8,
                            MediaQuery.of(context).size.height * 0.3,
                          ),
                        )
                      : VideoPlayer(media[position].videoPlayer),
                ),
              );
            },
            itemCount: media.length,
          ),
        );
      },
      stream: messageSearchBloc.messagesStream,
    );
  }
}

class _AssetPackage {
  Attachment attachment;
  Message message;
  VideoPlayerController videoPlayer;

  _AssetPackage(this.attachment, this.message, this.videoPlayer);
}
