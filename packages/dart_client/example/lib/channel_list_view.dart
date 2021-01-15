import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

import 'channel_preview.dart';
import 'stream_channel.dart';
import 'stream_chat.dart';

typedef ChannelTapCallback = void Function(Channel, Widget);

class ChannelListView extends StatefulWidget {
  ChannelListView({
    Key key,
    this.filter,
    this.options,
    this.sort,
    this.pagination,
    this.onChannelTap,
    this.channelWidget,
    this.channelPreview,
  })  : assert(channelWidget != null || onChannelTap != null),
        super(key: key);

  final Map<String, dynamic> filter;
  final Map<String, dynamic> options;
  final List<SortOption> sort;
  final PaginationParams pagination;
  final ScrollController _scrollController = ScrollController();
  final ChannelTapCallback onChannelTap;
  final Widget channelWidget;
  final Widget channelPreview;

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
          stream: streamChat.client.state.channelsStream,
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

            final channelsStates = snapshot.data;
            return ListView.custom(
              physics: AlwaysScrollableScrollPhysics(),
              controller: widget._scrollController,
              childrenDelegate: SliverChildBuilderDelegate(
                (context, i) {
                  return _itemBuilder(context, i, channelsStates);
                },
                childCount: (channelsStates.length * 2) + 1,
                findChildIndexCallback: (key) {
                  final ValueKey<String> valueKey = key;
                  final index = channelsStates
                      .indexWhere((cs) => 'CHANNEL-${cs.id}' == valueKey.value);
                  return index != -1 ? (index * 2) : null;
                },
              ),
            );
          }),
    );
  }

  Widget _itemBuilder(context, int i, List<Channel> channelsStates) {
    if (i % 2 != 0) {
      return _separatorBuilder(context, i);
    }

    i = i ~/ 2;

    final streamChat = StreamChat.of(context);
    if (i < channelsStates.length) {
      final channelState = channelsStates[i];

      final channelClient = streamChat.client.state.channels
          .firstWhere((c) => c.cid == channelState.cid);

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
                  channelClient: client,
                );
              },
            ),
          );
        };
      }

      Widget child;
      if (widget.channelPreview != null) {
        child = Stack(
          children: [
            widget.channelPreview,
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
          onTap: (channelClient) {
            onTap(channelClient, widget.channelWidget);
          },
        );
      }

      return StreamChannel(
        key: ValueKey<String>('CHANNEL-${channelClient?.id}'),
        child: child,
        channelClient: channelClient,
      );
    } else {
      return _buildQueryProgressIndicator(context, streamChat);
    }
  }

  Widget _buildQueryProgressIndicator(context, StreamChat streamChat) {
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

  void _listenChannelPagination(StreamChat streamChat) {
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
