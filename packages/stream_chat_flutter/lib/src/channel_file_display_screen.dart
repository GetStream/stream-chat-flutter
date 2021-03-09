import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'attachment/attachment.dart';

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

  /// The builder used when the file list is empty.
  final WidgetBuilder emptyBuilder;

  const ChannelFileDisplayScreen({
    this.sortOptions,
    this.paginationParams,
    this.emptyBuilder,
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
          r'$in': [StreamChannel.of(context).channel.cid]
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
      backgroundColor: StreamChatTheme.of(context).colorTheme.white,
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Files',
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
              width: 24.0,
              height: 24.0,
              child: StreamSvgIcon.left(
                color: StreamChatTheme.of(context).colorTheme.black,
                size: 24.0,
              ),
            ),
          ),
        ),
        backgroundColor: StreamChatTheme.of(context).colorTheme.white,
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
            child: const CircularProgressIndicator(),
          );
        }

        if (snapshot.data.isEmpty) {
          if (widget.emptyBuilder != null) {
            return widget.emptyBuilder(context);
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamSvgIcon.files(
                  size: 136.0,
                  color: StreamChatTheme.of(context).colorTheme.greyGainsboro,
                ),
                SizedBox(height: 16.0),
                Text(
                  'No Files',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: StreamChatTheme.of(context).colorTheme.black,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Files sent in this chat will appear here',
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

        final media = <Attachment, Message>{};

        for (var item in snapshot.data) {
          item.message.attachments.where((e) => e.type == 'file').forEach((e) {
            media[e] = item.message;
          });
        }

        return LazyLoadScrollView(
          onEndOfPage: () => messageSearchBloc.loadMore(
            filter: {
              'cid': {
                r'$in': [StreamChannel.of(context).channel.cid]
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
              return Padding(
                padding: const EdgeInsets.all(1.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FileAttachment(
                    message: media.values.toList()[position],
                    attachment: media.keys.toList()[position],
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
