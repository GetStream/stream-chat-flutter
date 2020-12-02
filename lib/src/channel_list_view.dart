import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/channels_bloc.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/utils.dart';

import '../stream_chat_flutter.dart';
import 'channel_bottom_sheet.dart';
import 'channel_preview.dart';
import 'stream_channel.dart';
import 'stream_chat.dart';

/// Callback called when tapping on a channel
typedef ChannelTapCallback = void Function(Channel, Widget);

/// Builder used to create a custom [ChannelPreview] from a [Channel]
typedef ChannelPreviewBuilder = Widget Function(BuildContext, Channel);

/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/channel_list_view.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/channel_list_view_paint.png)
///
/// It shows the list of current channels.
///
/// ```dart
/// class ChannelListPage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: ChannelListView(
///         filter: {
///           'members': {
///             '\$in': [StreamChat.of(context).user.id],
///           }
///         },
///         sort: [SortOption('last_message_at')],
///         pagination: PaginationParams(
///           limit: 20,
///         ),
///         channelWidget: ChannelPage(),
///       ),
///     );
///   }
/// }
/// ```
///
///
/// Make sure to have a [StreamChat] ancestor in order to provide the information about the channels.
/// The widget uses a [ListView.custom] to render the list of channels.
///
/// The widget components render the ui based on the first ancestor of type [StreamChatTheme].
/// Modify it to change the widget appearance.
class ChannelListView extends StatefulWidget {
  /// Instantiate a new ChannelListView
  ChannelListView({
    Key key,
    this.filter,
    this.options,
    this.sort,
    this.pagination,
    this.onChannelTap,
    this.onChannelLongPress,
    this.channelWidget,
    this.channelPreviewBuilder,
    this.separatorBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.onImageTap,
    this.onStartChatPressed,
    this.swipeToAction = false,
    this.pullToRefresh = true,
  }) : super(key: key);

  /// The builder that will be used in case of error
  final Widget Function(Error error) errorBuilder;

  /// If true a default swipe to action behaviour will be added to this widget
  final bool swipeToAction;

  /// The builder used when the channel list is empty.
  final WidgetBuilder emptyBuilder;

  /// The query filters to use.
  /// You can query on any of the custom fields you've defined on the [Channel].
  /// You can also filter other built-in channel fields.
  final Map<String, dynamic> filter;

  /// Query channels options.
  ///
  /// state: if true returns the Channel state
  /// watch: if true listen to changes to this Channel in real time.
  final Map<String, dynamic> options;

  /// The sorting used for the channels matching the filters.
  /// Sorting is based on field and direction, multiple sorting options can be provided.
  /// You can sort based on last_updated, last_message_at, updated_at, created_at or member_count.
  /// Direction can be ascending or descending.
  final List<SortOption> sort;

  /// Pagination parameters
  /// limit: the number of channels to return (max is 30)
  /// offset: the offset (max is 1000)
  /// message_limit: how many messages should be included to each channel
  final PaginationParams pagination;

  /// Function called when tapping on a channel
  /// By default it calls [Navigator.push] building a [MaterialPageRoute]
  /// with the widget [channelWidget] as child.
  final ChannelTapCallback onChannelTap;

  /// Function called when long pressing on a channel
  final Function(Channel) onChannelLongPress;

  /// Widget used when opening a channel
  final Widget channelWidget;

  /// Builder used to create a custom channel preview
  final ChannelPreviewBuilder channelPreviewBuilder;

  /// Builder used to create a custom item separator
  final Function(BuildContext, int) separatorBuilder;

  /// The function called when the image is tapped
  final Function(Channel) onImageTap;

  /// Set it to false to disable the pull-to-refresh widget
  final bool pullToRefresh;

  /// Callback used in the default empty list widget
  final VoidCallback onStartChatPressed;

  @override
  _ChannelListViewState createState() => _ChannelListViewState();
}

class _ChannelListViewState extends State<ChannelListView>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final channelsBloc = ChannelsBloc.of(context);

    if (!widget.pullToRefresh) {
      return _buildListView(channelsBloc);
    }

    return RefreshIndicator(
      onRefresh: () async {
        return channelsBloc.queryChannels(
          filter: widget.filter,
          sortOptions: widget.sort,
          paginationParams: widget.pagination,
          options: widget.options,
        );
      },
      child: _buildListView(channelsBloc),
    );
  }

  StreamBuilder<List<Channel>> _buildListView(
    ChannelsBlocState channelsBlocState,
  ) {
    return StreamBuilder<List<Channel>>(
      stream: channelsBlocState.channelsStream,
      builder: (context, snapshot) {
        var child;
        if (snapshot.hasError) {
          child = _buildErrorWidget(
            snapshot,
            context,
            channelsBlocState,
          );
        } else if (!snapshot.hasData) {
          child = _buildLoadingWidget();
        } else {
          final channels = snapshot.data;

          if (channels.isEmpty && widget.emptyBuilder != null) {
            child = widget.emptyBuilder(context);
          }

          if (channels.isEmpty && widget.emptyBuilder == null) {
            child = LayoutBuilder(
              builder: (context, viewportConstraints) {
                return SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Stack(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: viewportConstraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StreamSvgIcon.message(
                                size: 136,
                                color: Color(0xffDBDBDB),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Let’s start chatting!',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 52,
                              ),
                              child: Text(
                                'How about sending your first message to a friend?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff7A7A7A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.onStartChatPressed != null)
                        Positioned(
                          right: 0,
                          left: 0,
                          bottom: 32,
                          child: Center(
                            child: FlatButton(
                              onPressed: widget.onStartChatPressed,
                              child: Text(
                                'Start a chat',
                                style: TextStyle(
                                  color:
                                      StreamChatTheme.of(context).accentColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          }

          if (channels.isNotEmpty) {
            child = ListView.custom(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
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
          }
        }

        return AnimatedSwitcher(
          child: child,
          duration: Duration(milliseconds: 500),
        );
      },
    );
  }

  Widget _buildLoadingWidget() {
    return ListView(
      physics: AlwaysScrollableScrollPhysics(),
      children: List.generate(
        25,
        (i) {
          if (i % 2 != 0) {
            if (widget.separatorBuilder != null) {
              return widget.separatorBuilder(context, i);
            }
            return _separatorBuilder(context, i);
          }
          return _buildLoadingItem();
        },
      ),
    );
  }

  Shimmer _buildLoadingItem() {
    return Shimmer.fromColors(
      baseColor: Color(0xffE5E5E5),
      highlightColor: Color(0xffffffff),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          constraints: BoxConstraints.tightFor(
            height: 40,
            width: 40,
          ),
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11),
            ),
            constraints: BoxConstraints.tightFor(
              height: 16,
              width: 82,
            ),
          ),
        ),
        subtitle: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11),
                ),
                constraints: BoxConstraints.tightFor(
                  height: 16,
                  width: 238,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(11),
              ),
              constraints: BoxConstraints.tightFor(
                height: 16,
                width: 42,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(
    AsyncSnapshot<List<Channel>> snapshot,
    BuildContext context,
    ChannelsBlocState channelsBlocState,
  ) {
    if (snapshot.error is Error) {
      print((snapshot.error as Error).stackTrace);
    }

    if (widget.errorBuilder != null) {
      return widget.errorBuilder(snapshot.error);
    }

    var message = snapshot.error.toString();
    if (snapshot.error is DioError) {
      final dioError = snapshot.error as DioError;
      if (dioError.type == DioErrorType.RESPONSE) {
        message = dioError.message;
      } else {
        message = 'Check your connection and retry';
      }
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 2.0,
                    ),
                    child: Icon(Icons.error_outline),
                  ),
                ),
                TextSpan(text: 'Error loading channels'),
              ],
            ),
            style: Theme.of(context).textTheme.headline6,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
            ),
            child: Text(message),
          ),
          FlatButton(
            onPressed: () {
              channelsBlocState.queryChannels(
                filter: widget.filter,
                sortOptions: widget.sort,
                paginationParams: widget.pagination,
                options: widget.options,
              );
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _itemBuilder(context, int i, List<Channel> channels) {
    if (i % 2 != 0) {
      if (widget.separatorBuilder != null) {
        return widget.separatorBuilder(context, i);
      }
      return _separatorBuilder(context, i);
    }

    i = i ~/ 2;

    final channelsProvider = ChannelsBloc.of(context);
    if (i < channels.length) {
      final channel = channels[i];

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
        key: ValueKey<String>('CHANNEL-${channel.id}'),
        channel: channel,
        child: Builder(
          builder: (context) {
            Widget child;
            if (widget.channelPreviewBuilder != null) {
              child = Stack(
                children: [
                  widget.channelPreviewBuilder(
                    context,
                    channel,
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          onTap(channel, widget.channelWidget);
                        },
                        onLongPress: widget.onChannelLongPress != null
                            ? () {
                                widget.onChannelLongPress(channel);
                              }
                            : null,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              final backgroundColor =
                  Theme.of(context).brightness == Brightness.light
                      ? Color(0xffEBEBEB)
                      : Color(0xff141414);
              child = Slidable(
                enabled: widget.swipeToAction,
                actionPane: SlidableBehindActionPane(),
                actionExtentRatio: 0.12,
                closeOnScroll: true,
                secondaryActions: <Widget>[
                  IconSlideAction(
                    color: backgroundColor,
                    icon: Icons.more_horiz,
                    onTap: () {
                      showModalBottomSheet(
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                        ),
                        context: context,
                        builder: (context) {
                          return StreamChannel(
                            child: ChannelBottomSheet(),
                            channel: channel,
                          );
                        },
                      );
                    },
                  ),
                  IconSlideAction(
                    color: backgroundColor,
                    iconWidget: StreamSvgIcon.mute(),
                    onTap: () async {
                      if (!channel.isMuted) {
                        await channel.mute();
                      } else {
                        await channel.unmute();
                      }
                    },
                  ),
                  if (channel.isGroup && !channel.isDistinct)
                    IconSlideAction(
                      color: backgroundColor,
                      iconWidget: StreamSvgIcon.userRemove(),
                      onTap: () async {
                        final confirm = await showConfirmationDialog(
                          context,
                          'Do you want to leave the group?',
                        );
                        if (confirm == true) {
                          await channel
                              .removeMembers([StreamChat.of(context).user.id]);
                        }
                      },
                    ),
                  if (!channel.isGroup && !channel.isDistinct)
                    IconSlideAction(
                      color: backgroundColor,
                      icon: Icons.delete_outline,
                      onTap: () async {
                        final confirm = await showConfirmationDialog(
                          context,
                          'Do you want to delete the chat?',
                        );
                        if (confirm == true) {
                          await channel
                              .removeMembers([StreamChat.of(context).user.id]);
                        }
                      },
                    ),
                ],
                child: Container(
                  color: StreamChatTheme.of(context).backgroundColor,
                  child: ChannelPreview(
                    onLongPress: widget.onChannelLongPress,
                    channel: channel,
                    onImageTap: widget.onImageTap != null
                        ? () {
                            widget.onImageTap(channel);
                          }
                        : null,
                    onTap: (channel) {
                      onTap(channel, widget.channelWidget);
                    },
                  ),
                ),
              );
            }
            return child;
          },
        ),
      );
    } else {
      return _buildQueryProgressIndicator(context, channelsProvider);
    }
  }

  Widget _buildQueryProgressIndicator(
    context,
    ChannelsBlocState channelsProvider,
  ) {
    return StreamBuilder<bool>(
        stream: channelsProvider.queryChannelsLoading,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
              color: Color(0xffd0021B).withAlpha(26),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text('Error loading channels'),
                ),
              ),
            );
          }
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
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white.withOpacity(0.1)
          : Colors.black.withOpacity(0.1),
    );
  }

  void _listenChannelPagination(ChannelsBlocState channelsProvider) {
    if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset &&
        _scrollController.offset != 0) {
      channelsProvider.queryChannels(
        filter: widget.filter,
        sortOptions: widget.sort,
        paginationParams: widget.pagination.copyWith(
          offset: channelsProvider.channels?.length ?? 0,
        ),
        options: widget.options,
      );
    }
  }

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    final channelsBloc = ChannelsBloc.of(context);
    channelsBloc.queryChannels(
      filter: widget.filter,
      sortOptions: widget.sort,
      paginationParams: widget.pagination,
      options: widget.options,
    );

    _scrollController.addListener(() {
      channelsBloc.queryChannelsLoading.first.then((loading) {
        if (!loading) {
          _listenChannelPagination(channelsBloc);
        }
      });
    });

    final client = StreamChat.of(context).client;

    _subscription = client
        .on(
      EventType.connectionRecovered,
      EventType.notificationAddedToChannel,
      EventType.notificationMessageNew,
      EventType.channelVisible,
    )
        .listen((event) {
      channelsBloc.queryChannels(
        filter: widget.filter,
        sortOptions: widget.sort,
        paginationParams: widget.pagination,
        options: widget.options,
      );
    });
  }

  @override
  void didUpdateWidget(ChannelListView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.filter?.toString() != oldWidget.filter?.toString() ||
        jsonEncode(widget.sort) != jsonEncode(oldWidget.sort) ||
        widget.pagination?.toJson()?.toString() !=
            oldWidget.pagination?.toJson()?.toString() ||
        widget.options?.toString() != oldWidget.options?.toString()) {
      final channelsBloc = ChannelsBloc.of(context);
      channelsBloc.queryChannels(
        filter: widget.filter,
        sortOptions: widget.sort,
        paginationParams: widget.pagination,
        options: widget.options,
      );
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
