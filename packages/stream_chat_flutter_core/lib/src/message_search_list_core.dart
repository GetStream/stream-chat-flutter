import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/better_stream_builder.dart';
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
///         messageQuery: _messageFilter,
///         filters: _channelsFilter,
///         limit: 20,
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
@Deprecated('''
MessageSearchListCore is deprecated and will be removed in the next 
major version. Use StreamMessageSearchListController instead to create your custom list.
More details here https://getstream.io/chat/docs/sdk/flutter/stream_chat_flutter_core/stream_message_search_list_controller
''')
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
    @Deprecated(
      "'pagination' is deprecated and shouldn't be used. "
      "This property is no longer used, Please use 'limit' instead",
    )
        this.paginationParams,
    this.messageFilters,
    this.messageSearchListController,
    int? limit,
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
        limit = limit ?? paginationParams?.limit ?? 30,
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
  @Deprecated(
    "'pagination' is deprecated and shouldn't be used. "
    "This property is no longer used, Please use 'limit' instead",
  )
  final PaginationParams? paginationParams;

  /// The amount of messages requested per API call.
  final int limit;

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
      BetterStreamBuilder<List<GetMessageResponse>>(
        stream: messageSearchBloc.messagesStream,
        errorBuilder: widget.errorBuilder,
        noDataBuilder: widget.loadingBuilder,
        builder: (context, items) {
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
        messageFilter: widget.messageFilters,
        pagination: PaginationParams(limit: widget.limit),
      );

  /// Fetches more messages with updated pagination and updates the widget
  Future<void> paginateData() {
    var pagination = PaginationParams(limit: widget.limit);
    if (widget.sortOptions != null) {
      pagination = pagination.copyWith(
        next: _messageSearchBloc?.nextId,
      );
    } else {
      pagination = pagination.copyWith(
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
    if (jsonEncode(widget.filters) != jsonEncode(oldWidget.filters) ||
        jsonEncode(widget.sortOptions) != jsonEncode(oldWidget.sortOptions) ||
        widget.messageQuery != oldWidget.messageQuery ||
        jsonEncode(widget.messageFilters) !=
            jsonEncode(oldWidget.messageFilters) ||
        widget.limit != oldWidget.limit) {
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
