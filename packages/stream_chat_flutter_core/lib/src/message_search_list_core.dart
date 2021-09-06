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
///               messageQuery: _messageFilter,
///               filters: _channelsFilter,
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
  MessageSearchListCore({
    Key? key,
    required this.emptyBuilder,
    required this.errorBuilder,
    required this.loadingBuilder,
    required this.childBuilder,
    required this.filters,
    this.messageQuery,
    this.sortOptions,
    this.paginationParams,
    this.messageFilters,
    this.messageSearchListController,
  })  : assert(
          messageQuery != null || messageFilters != null,
          'Provide at least `query` or `messageFilters`',
        ),
        assert(
          messageQuery == null || messageFilters == null,
          "Can't provide both `query` and `messageFilters` at the same time",
        ),
        assert(
          paginationParams?.offset == null ||
              paginationParams?.offset == 0 ||
              sortOptions == null,
          'Cannot specify `offset` with `sortOptions` parameter',
        ),
        super(key: key);

  /// A [MessageSearchListController] allows reloading and pagination.
  /// Use [MessageSearchListController.loadData] and
  /// [MessageSearchListController.paginateData] respectively for reloading and
  /// pagination.
  final MessageSearchListController? messageSearchListController;

  /// Message String to search on
  final String? messageQuery;

  /// The query filters to use.
  /// You can query on any of the custom fields you've defined on the [Channel].
  /// You can also filter other built-in channel fields.
  final Filter filters;

  /// The sorting used for the channels matching the filters.
  /// Sorting is based on field and direction, multiple sorting options can be
  /// provided.
  /// You can sort based on last_updated, last_message_at, updated_at, created_
  /// at or member_count. Direction can be ascending or descending.
  final List<SortOption>? sortOptions;

  /// Pagination parameters
  /// limit: the number of messages to return (max is 30)
  /// offset: the offset (max is 1000)
  final PaginationParams? paginationParams;

  /// The message query filters to use.
  /// You can query on any of the custom fields you've defined on the [Channel].
  /// You can also filter other built-in channel fields.
  final Filter? messageFilters;

  /// The builder that is used when the search messages are fetched
  final Widget Function(List<GetMessageResponse>) childBuilder;

  /// The builder used when the channel list is empty.
  final WidgetBuilder emptyBuilder;

  /// The builder that will be used in case of error
  final ErrorBuilder errorBuilder;

  /// The builder that will be used in case of loading
  final WidgetBuilder loadingBuilder;

  @override
  MessageSearchListCoreState createState() => MessageSearchListCoreState();
}

/// The current state of the [MessageSearchListCore].
class MessageSearchListCoreState extends State<MessageSearchListCore> {
  MessageSearchBlocState? _messageSearchBloc;

  @override
  void didChangeDependencies() {
    final newMessageSearchBloc = MessageSearchBloc.of(context);

    if (newMessageSearchBloc != _messageSearchBloc) {
      _messageSearchBloc = newMessageSearchBloc;
      loadData();
    }

    super.didChangeDependencies();
  }

  void _setupController() {
    if (widget.messageSearchListController != null) {
      widget.messageSearchListController!.loadData = loadData;
      widget.messageSearchListController!.paginateData = paginateData;
    }
  }

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  @override
  Widget build(BuildContext context) => _buildListView(_messageSearchBloc!);

  Widget _buildListView(MessageSearchBlocState messageSearchBloc) =>
      StreamBuilder<List<GetMessageResponse>>(
        stream: messageSearchBloc.messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return widget.errorBuilder(context, snapshot.error!);
          }
          if (!snapshot.hasData) {
            return widget.loadingBuilder(context);
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return widget.emptyBuilder(context);
          }
          return widget.childBuilder(items);
        },
      );

  /// Fetches initial messages and updates the widget
  Future<void> loadData() => _messageSearchBloc!.search(
        filter: widget.filters,
        sort: widget.sortOptions,
        query: widget.messageQuery,
        pagination: widget.paginationParams,
        messageFilter: widget.messageFilters,
      );

  /// Fetches more messages with updated pagination and updates the widget
  Future<void> paginateData() {
    PaginationParams? pagination;
    if (widget.sortOptions != null) {
      pagination = widget.paginationParams?.copyWith(
        next: _messageSearchBloc?.nextId,
      );
    } else {
      pagination = widget.paginationParams?.copyWith(
        offset: _messageSearchBloc?.messageResponses?.length,
      );
    }
    return _messageSearchBloc!.search(
      filter: widget.filters,
      sort: widget.sortOptions,
      pagination: pagination,
      query: widget.messageQuery,
      messageFilter: widget.messageFilters,
    );
  }

  @override
  void didUpdateWidget(MessageSearchListCore oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filters.toString() != oldWidget.filters.toString() ||
        jsonEncode(widget.sortOptions) != jsonEncode(oldWidget.sortOptions) ||
        widget.messageQuery?.toString() != oldWidget.messageQuery?.toString() ||
        widget.messageFilters?.toString() !=
            oldWidget.messageFilters?.toString() ||
        widget.paginationParams?.toJson().toString() !=
            oldWidget.paginationParams?.toJson().toString()) {
      loadData();
    }

    if (widget.messageSearchListController !=
        oldWidget.messageSearchListController) {
      _setupController();
    }
  }
}

/// Controller used for paginating data in [ChannelListView]
class MessageSearchListController {
  /// Call this function to reload data
  AsyncCallback? loadData;

  /// Call this function to load further data
  AsyncCallback? paginateData;
}
