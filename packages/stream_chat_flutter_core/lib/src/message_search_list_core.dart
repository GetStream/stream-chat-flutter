import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/message_search_bloc.dart';
import 'package:stream_chat_flutter_core/src/typedef.dart';

///
/// [MessageSearchListCore] is a simplified class that allows searching for
///  messages across channels while exposing UI builders.
///  A [MessageSearchListController] is used to load and paginate data.
///
/// ```dart
/// class MessageSearchPage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: MessageSearchListCore(
///               messageQuery: _channelQuery,
///               filters: {
///                 'members': {
///                   r'$in': [user.id]
///                 }
///               },
///               paginationParams: PaginationParams(limit: 20),
///       ),
///     );
///   }
/// }
/// ```
///
/// Make sure to have a [MessageSearchBloc] ancestor in order to provide the
/// information about the messages.
/// The widget uses a [ListView.separated] to render the list of messages.
///
class MessageSearchListCore extends StatefulWidget {
  /// Instantiate a new [MessageSearchListView].
  /// The following parameters must be supplied and not null:
  /// * [emptyBuilder]
  /// * [errorBuilder]
  /// * [loadingBuilder]
  /// * [childBuilder]
  const MessageSearchListCore({
    Key key,
    @required this.emptyBuilder,
    @required this.errorBuilder,
    @required this.loadingBuilder,
    @required this.childBuilder,
    this.messageQuery,
    this.filters,
    this.sortOptions,
    this.paginationParams,
    this.messageFilters,
    this.messageSearchListController,
  })  : assert(emptyBuilder != null, 'emptyBuilder should not be null'),
        assert(errorBuilder != null, 'errorBuilder should not be null'),
        assert(loadingBuilder != null, 'loadingBuilder should not be null'),
        assert(childBuilder != null, 'childBuilder should not be null'),
        super(key: key);

  /// A [MessageSearchListController] allows reloading and pagination.
  /// Use [MessageSearchListController.loadData] and
  /// [MessageSearchListController.paginateData] respectively for reloading and
  /// pagination.
  final MessageSearchListController messageSearchListController;

  /// Message String to search on
  final String messageQuery;

  /// The query filters to use.
  /// You can query on any of the custom fields you've defined on the [Channel].
  /// You can also filter other built-in channel fields.
  final Map<String, dynamic> filters;

  /// The sorting used for the channels matching the filters.
  /// Sorting is based on field and direction, multiple sorting options can be
  /// provided.
  /// You can sort based on last_updated, last_message_at, updated_at, created_
  /// at or member_count. Direction can be ascending or descending.
  final List<SortOption> sortOptions;

  /// Pagination parameters
  /// limit: the number of users to return (max is 30)
  /// offset: the offset (max is 1000)
  /// message_limit: how many messages should be included to each channel
  final PaginationParams paginationParams;

  /// The message query filters to use.
  /// You can query on any of the custom fields you've defined on the [Channel].
  /// You can also filter other built-in channel fields.
  final Map<String, dynamic> messageFilters;

  /// The builder that is used when the search messages are fetched
  final Widget Function(List<GetMessageResponse>) childBuilder;

  /// The builder used when the channel list is empty.
  final WidgetBuilder emptyBuilder;

  /// The builder that will be used in case of error
  final ErrorBuilder errorBuilder;

  /// The builder that will be used in case of loading
  final WidgetBuilder loadingBuilder;

  @override
  _MessageSearchListCoreState createState() => _MessageSearchListCoreState();
}

class _MessageSearchListCoreState extends State<MessageSearchListCore> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MessageSearchBloc.of(context).search(
      filter: widget.filters,
      sort: widget.sortOptions,
      query: widget.messageQuery,
      pagination: widget.paginationParams,
      messageFilter: widget.messageFilters,
    );

    if (widget.messageSearchListController != null) {
      widget.messageSearchListController.loadData = loadData;
      widget.messageSearchListController.paginateData = paginateData;
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageSearchBloc = MessageSearchBloc.of(context);
    return _buildListView(messageSearchBloc);
  }

  Widget _buildListView(MessageSearchBlocState messageSearchBloc) =>
      StreamBuilder<List<GetMessageResponse>>(
        stream: messageSearchBloc.messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            if (snapshot.error is Error) {
              print((snapshot.error as Error).stackTrace);
            }

            return widget.errorBuilder(context, snapshot.error);
          }

          if (!snapshot.hasData) {
            return widget.loadingBuilder(context);
          }

          final items = snapshot.data;

          if (items.isEmpty) {
            return widget.emptyBuilder(context);
          }

          return widget.childBuilder(snapshot.data);
        },
      );

  void loadData() {
    MessageSearchBloc.of(context).search(
      filter: widget.filters,
      sort: widget.sortOptions,
      query: widget.messageQuery,
      pagination: widget.paginationParams,
      messageFilter: widget.messageFilters,
    );
  }

  void paginateData() {
    final messageSearchBloc = MessageSearchBloc.of(context);

    messageSearchBloc.loadMore(
      filter: widget.filters,
      sort: widget.sortOptions,
      pagination: widget.paginationParams.copyWith(
        offset: messageSearchBloc.messageResponses?.length ?? 0,
      ),
      query: widget.messageQuery,
      messageFilter: widget.messageFilters,
    );
  }

  @override
  void didUpdateWidget(MessageSearchListCore oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filters?.toString() != oldWidget.filters?.toString() ||
        jsonEncode(widget.sortOptions) != jsonEncode(oldWidget.sortOptions) ||
        widget.paginationParams?.toJson()?.toString() !=
            oldWidget.paginationParams?.toJson()?.toString() ||
        widget.messageQuery?.toString() != oldWidget.messageQuery?.toString() ||
        widget.messageFilters?.toString() !=
            oldWidget.messageFilters?.toString()) {
      MessageSearchBloc.of(context).search(
        filter: widget.filters,
        sort: widget.sortOptions,
        query: widget.messageQuery,
        pagination: widget.paginationParams,
        messageFilter: widget.messageFilters,
      );
    }
  }
}

/// Controller used for paginating data in [ChannelListView]
class MessageSearchListController {
  /// Call this function to reload data
  VoidCallback loadData;

  /// Call this function to load further data
  VoidCallback paginateData;
}
