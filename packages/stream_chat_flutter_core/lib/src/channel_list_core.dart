import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/channels_bloc.dart';
import 'package:stream_chat_flutter_core/src/stream_chat_core.dart';
import 'package:stream_chat_flutter_core/src/typedef.dart';

/// [ChannelListCore] is a simplified class that allows fetching a list of
/// channels while exposing UI builders.
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
/// Make sure to have a [StreamChatCore] ancestor in order to provide the
/// information about the channels.
class ChannelListCore extends StatefulWidget {
  /// Instantiate a new ChannelListView
  const ChannelListCore({
    Key? key,
    required this.errorBuilder,
    required this.emptyBuilder,
    required this.loadingBuilder,
    required this.listBuilder,
    this.filter,
    this.options,
    this.sort,
    this.pagination = const PaginationParams(
      limit: 25,
    ),
    this.channelListController,
  })  : assert(
          errorBuilder != null,
          'Parameter errorBuilder should not be null',
        ),
        assert(
          emptyBuilder != null,
          'Parameter emptyBuilder should not be null',
        ),
        assert(
          loadingBuilder != null,
          'Parameter loadingBuilder should not be null',
        ),
        assert(
          listBuilder != null,
          'Parameter listBuilder should not be null',
        ),
        super(key: key);

  /// A [ChannelListController] allows reloading and pagination.
  /// Use [ChannelListController.loadData] and
  /// [ChannelListController.paginateData] respectively for reloading and
  /// pagination.
  final ChannelListController? channelListController;

  /// The builder that will be used in case of error
  final ErrorBuilder errorBuilder;

  /// The builder that will be used in case of loading
  final WidgetBuilder loadingBuilder;

  /// The builder which is used when list of channels loads
  final Function(BuildContext, List<Channel?>) listBuilder;

  /// The builder used when the channel list is empty.
  final WidgetBuilder emptyBuilder;

  /// The query filters to use.
  /// You can query on any of the custom fields you've defined on the [Channel].
  /// You can also filter other built-in channel fields.
  final Map<String, dynamic>? filter;

  /// Query channels options.
  ///
  /// state: if true returns the Channel state
  /// watch: if true listen to changes to this Channel in real time.
  final Map<String, dynamic>? options;

  /// The sorting used for the channels matching the filters.
  /// Sorting is based on field and direction, multiple sorting options can be
  /// provided.
  /// You can sort based on last_updated, last_message_at, updated_at, created
  /// _at or member_count. Direction can be ascending or descending.
  final List<SortOption<ChannelModel>>? sort;

  /// Pagination parameters
  /// limit: the number of channels to return (max is 30)
  /// offset: the offset (max is 1000)
  /// message_limit: how many messages should be included to each channel
  final PaginationParams pagination;

  @override
  ChannelListCoreState createState() => ChannelListCoreState();
}

/// The current state of the [ChannelListCore].
class ChannelListCoreState extends State<ChannelListCore> {
  @override
  Widget build(BuildContext context) {
    final channelsBloc = ChannelsBloc.of(context);

    return _buildListView(channelsBloc);
  }

  StreamBuilder<List<Channel?>> _buildListView(
    ChannelsBlocState channelsBlocState,
  ) =>
      StreamBuilder<List<Channel?>>(
        stream: channelsBlocState.channelsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return widget.errorBuilder(context, snapshot.error);
          }
          if (!snapshot.hasData) {
            return widget.loadingBuilder(context);
          }
          final channels = snapshot.data!;
          if (channels.isEmpty) {
            return widget.emptyBuilder(context);
          }
          return widget.listBuilder(context, channels);
        },
      );

  /// Fetches initial channels and updates the widget
  Future<void> loadData() {
    final channelsBloc = ChannelsBloc.of(context);
    return channelsBloc.queryChannels(
      filter: widget.filter,
      sortOptions: widget.sort,
      paginationParams: widget.pagination,
      options: widget.options,
    );
  }

  /// Fetches more channels with updated pagination and updates the widget
  Future<void> paginateData() {
    final channelsBloc = ChannelsBloc.of(context);
    return channelsBloc.queryChannels(
      filter: widget.filter,
      sortOptions: widget.sort,
      paginationParams: widget.pagination.copyWith(
        offset: channelsBloc.channels?.length ?? 0,
      ),
      options: widget.options,
    );
  }

  late StreamSubscription<Event> _subscription;

  @override
  void initState() {
    super.initState();
    loadData();
    final client = StreamChatCore.of(context).client;
    _subscription = client
        .on(
          EventType.connectionRecovered,
          EventType.notificationAddedToChannel,
          EventType.notificationMessageNew,
          EventType.channelVisible,
        )
        .listen((event) => loadData());

    if (widget.channelListController != null) {
      widget.channelListController!.loadData = loadData;
      widget.channelListController!.paginateData = paginateData;
    }
  }

  @override
  void didUpdateWidget(ChannelListCore oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.filter?.toString() != oldWidget.filter?.toString() ||
        jsonEncode(widget.sort) != jsonEncode(oldWidget.sort) ||
        widget.options?.toString() != oldWidget.options?.toString() ||
        widget.pagination?.toJson()?.toString() !=
            oldWidget.pagination?.toJson()?.toString()) {
      loadData();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Controller used for loading more data and controlling pagination in
/// [ChannelListCore].
class ChannelListController {
  /// This function calls Stream's servers to load a list of channels.
  /// If there is existing data, calling this function causes a reload.
  AsyncCallback? loadData;

  /// This function is used to load another page of data. Note, [loadData]
  /// should be used to populate the initial page of data. Calling
  /// [paginateData] performs a query to load subsequent pages.
  AsyncCallback? paginateData;
}
