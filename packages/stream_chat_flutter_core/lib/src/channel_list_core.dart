import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/channels_bloc.dart';
import 'package:stream_chat_flutter_core/src/typedef.dart';

import 'stream_chat_core.dart';

/// [ChannelListCore] is a simplified class that allows fetching a list of channels while exposing UI builders.
/// A [ChannelListController] is used to reload and paginate data.
///
///
/// ```dart
/// class ChannelListPage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: ChannelListCore(
///         filter: {
///           'members': {
///             '\$in': [StreamChat.of(context).user.id],
///           }
///         },
///         sort: [SortOption('last_message_at')],
///         pagination: PaginationParams(
///           limit: 20,
///         ),
///         errorBuilder: (err) {
///           return Center(
///             child: Text('An error has occured'),
///           );
///         },
///         emptyBuilder: (context) {
///           return Center(
///             child: Text('Nothing here...'),
///           );
///         },
///         emptyBuilder: (context) {
///           return Center(
///             child: CircularProgressIndicator(),
///           );
///         },
///         listBuilder: (context, list) {
///           return ChannelPage(list);
///         }
///       ),
///     );
///   }
/// }
/// ```
///
/// Make sure to have a [StreamChatCore] ancestor in order to provide the information about the channels.
class ChannelListCore extends StatefulWidget {
  /// Instantiate a new ChannelListView
  ChannelListCore({
    Key key,
    @required this.errorBuilder,
    @required this.emptyBuilder,
    @required this.loadingBuilder,
    @required this.listBuilder,
    this.filter,
    this.options,
    this.sort,
    this.pagination,
    this.channelListController,
  })  : assert(errorBuilder != null),
        assert(emptyBuilder != null),
        assert(loadingBuilder != null),
        assert(listBuilder != null),
        super(key: key);

  /// A [ChannelListController] allows reloading and pagination.
  /// Use [ChannelListController.loadData] and [ChannelListController.paginateData] respectively for reloading and pagination.
  final ChannelListController channelListController;

  /// The builder that will be used in case of error
  final ErrorBuilder errorBuilder;

  /// The builder that will be used in case of loading
  final WidgetBuilder loadingBuilder;

  /// The builder which is used when list of channels loads
  final Function(BuildContext, List<Channel>) listBuilder;

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

  @override
  _ChannelListCoreState createState() => _ChannelListCoreState();
}

class _ChannelListCoreState extends State<ChannelListCore>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    final channelsBloc = ChannelsBloc.of(context);

    return _buildListView(channelsBloc);
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

          child = widget.emptyBuilder(context);

          if (channels.isNotEmpty) {
            return widget.listBuilder(context, channels);
          }
        }

        return child;
      },
    );
  }

  Widget _buildLoadingWidget() {
    return widget.loadingBuilder(context);
  }

  Widget _buildErrorWidget(
    AsyncSnapshot<List<Channel>> snapshot,
    BuildContext context,
    ChannelsBlocState channelsBlocState,
  ) {
    if (snapshot.error is Error) {
      print((snapshot.error as Error).stackTrace);
    }

    return widget.errorBuilder(context, snapshot.error);
  }

  void loadData() {
    final channelsBloc = ChannelsBloc.of(context);

    channelsBloc.queryChannels(
      filter: widget.filter,
      sortOptions: widget.sort,
      paginationParams: widget.pagination,
      options: widget.options,
    );
  }

  void paginateData() {
    final channelsBloc = ChannelsBloc.of(context);

    channelsBloc.queryChannels(
      filter: widget.filter,
      sortOptions: widget.sort,
      paginationParams: widget.pagination.copyWith(
        offset: channelsBloc.channels?.length ?? 0,
      ),
      options: widget.options,
    );
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

    final client = StreamChatCore.of(context).client;

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

    if (widget.channelListController != null) {
      widget.channelListController.loadData = loadData;
      widget.channelListController.paginateData = paginateData;
    }
  }

  @override
  void didUpdateWidget(ChannelListCore oldWidget) {
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

/// Controller used for loading more data and controlling pagination in [ChannelListCore].
class ChannelListController {
  /// This function calls Stream's servers to load a list of channels. If there is existing data,
  /// calling this function causes a reload.
  VoidCallback loadData;

  /// This function is used to load another page of data. Note, [loadData] should be
  /// used to populate the initial page of data. Calling [paginateData] performs a query
  /// to load subsequent pages.
  VoidCallback paginateData;
}
