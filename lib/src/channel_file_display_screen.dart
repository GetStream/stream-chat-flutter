import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/lazy_load_scroll_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelFileDisplayScreen extends StatefulWidget {
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

  ChannelFileDisplayScreen({
    this.sortOptions,
    this.paginationParams,
  });

  @override
  _ChannelFileDisplayScreenState createState() =>
      _ChannelFileDisplayScreenState();
}

class _ChannelFileDisplayScreenState extends State<ChannelFileDisplayScreen> {
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
          r'$in': ['file'],
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
          'Files',
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
                StreamSvgIcon.files(
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
                  'Files sent in this chat will appear here',
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

        Map<Attachment, Message> media = {};

        for (var item in snapshot.data) {
          item.message.attachments.where((e) => e.type == 'file').forEach((e) {
            media[e] = item.message;
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
                r'$in': ['file']
              },
            },
            sort: widget.sortOptions,
            pagination: widget.paginationParams.copyWith(
              offset: messageSearchBloc.messageResponses?.length ?? 0,
            ),
          ),
          child: ListView.builder(
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
                              media.keys.toList()[position],
                            ],
                            message: media.values.toList()[position],
                            sentAt: media.values.toList()[position].createdAt,
                            userName: media.values.toList()[position].user.name,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FileAttachment(
                      attachment: media.keys.toList()[position],
                    ),
                  ),
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
