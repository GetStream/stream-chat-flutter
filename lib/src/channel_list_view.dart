import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

import '../stream_chat_flutter.dart';
import 'channel_preview.dart';
import 'stream_channel.dart';
import 'stream_chat.dart';

typedef ChannelTapCallback = void Function(Channel, Widget);
typedef ChannelPreviewBuilder = Widget Function(BuildContext, Channel);

class ChannelListView extends StatefulWidget {
  ChannelListView({
    Key key,
    this.filter,
    this.options,
    this.sort,
    this.pagination,
    this.onChannelTap,
    this.channelWidget,
    this.channelPreviewBuilder,
  }) : super(key: key);

  final Map<String, dynamic> filter;
  final Map<String, dynamic> options;
  final List<SortOption> sort;
  final PaginationParams pagination;
  final ScrollController _scrollController = ScrollController();
  final ChannelTapCallback onChannelTap;
  final Widget channelWidget;
  final ChannelPreviewBuilder channelPreviewBuilder;

  @override
  _ChannelListViewState createState() => _ChannelListViewState();
}

class _ChannelListViewState extends State<ChannelListView> {
  @override
  Widget build(BuildContext context) {
    final streamChat = StreamChat.of(context);
    return RefreshIndicator(
      onRefresh: () async {
        streamChat.clearChannels();
        return streamChat.queryChannels(
          filter: widget.filter,
          sortOptions: widget.sort,
          paginationParams: widget.pagination,
          options: widget.options,
        );
      },
      child: StreamBuilder<List<Channel>>(
          stream: streamChat.channelsStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              print((snapshot.error as Error).stackTrace);
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            final channels = snapshot.data;
            return ListView.custom(
              physics: AlwaysScrollableScrollPhysics(),
              controller: widget._scrollController,
              childrenDelegate: SliverChildBuilderDelegate(
                (context, i) {
                  return _itemBuilder(context, i, channels);
                },
                childCount: (channels.length * 2) + 1,
                findChildIndexCallback: (key) {
                  final ValueKey<String> valueKey = key;
                  final index = channels.indexWhere(
                      (channel) => 'CHANNEL-${channel.id}' == valueKey.value);
                  return index != -1 ? (index * 2) : null;
                },
              ),
            );
          }),
    );
  }

  Widget _itemBuilder(context, int i, List<Channel> channels) {
    if (i % 2 != 0) {
      return _separatorBuilder(context, i);
    }

    i = i ~/ 2;

    final streamChat = StreamChat.of(context);
    if (i < channels.length) {
      final channel = channels[i];

      final channelClient = streamChat.client.channelClients[channel.id];

      ChannelTapCallback onTap;
      if (widget.onChannelTap != null) {
        onTap = widget.onChannelTap;
      } else {
        onTap = (client, _) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return StreamChannel(
                  child: widget.channelWidget,
                  channel: client,
                );
              },
            ),
          );
        };
      }

      return StreamChannel(
        key: ValueKey<String>('CHANNEL-${channelClient.id}'),
        channel: channelClient,
        child: StreamBuilder<DateTime>(
          initialData: channelClient.updatedAt,
          stream: channelClient.updatedAtStream,
          builder: (context, snapshot) {
            Widget child;
            if (widget.channelPreviewBuilder != null) {
              child = Stack(
                children: [
                  widget.channelPreviewBuilder(
                    context,
                    channelClient,
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          onTap(channelClient, widget.channelWidget);
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else {
              child = ChannelPreview(
                channel: channelClient,
                onTap: (channelClient) {
                  onTap(channelClient, widget.channelWidget);
                },
              );
            }
            return child;
          },
        ),
      );
    } else {
      return _buildQueryProgressIndicator(context, streamChat);
    }
  }

  Widget _buildQueryProgressIndicator(context, StreamChatState streamChat) {
    return StreamBuilder<bool>(
        stream: streamChat.queryChannelsLoading,
        initialData: false,
        builder: (context, snapshot) {
          return Container(
            height: 100,
            padding: EdgeInsets.all(32),
            child: Center(
              child: snapshot.data ? CircularProgressIndicator() : Container(),
            ),
          );
        });
  }

  Widget _separatorBuilder(context, i) {
    return Container(
      height: 1,
      color: Colors.black.withOpacity(0.1),
      margin: EdgeInsets.symmetric(horizontal: 16),
    );
  }

  void _listenChannelPagination(StreamChatState streamChat) {
    if (widget._scrollController.position.maxScrollExtent ==
        widget._scrollController.position.pixels) {
      streamChat.queryChannels(
        filter: widget.filter,
        sortOptions: widget.sort,
        paginationParams: widget.pagination.copyWith(
          offset: streamChat.channels.length,
        ),
        options: widget.options,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    final streamChat = StreamChat.of(context);
    streamChat.queryChannels(
      filter: widget.filter,
      sortOptions: widget.sort,
      paginationParams: widget.pagination,
      options: widget.options,
    );

    widget._scrollController.addListener(() {
      _listenChannelPagination(streamChat);
    });
  }
}
