import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'message_search_bloc.dart';

/// Callback called when tapping on a user
typedef MessageSearchItemTapCallback = void Function(GetMessageResponse);

/// Builder used to create a custom [ListUserItem] from a [User]
typedef MessageSearchItemBuilder = Widget Function(
    BuildContext, GetMessageResponse);

/// Builder used when [MessageSearchListViewCore] is empty
typedef EmptyMessageSearchBuilder = Widget Function(
    BuildContext context, String searchQuery);

///
/// It shows the list of searched messages.
///
/// ```dart
/// class MessageSearchPage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: MessageSearchListView(
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
///
/// Make sure to have a [MessageSearchBloc] ancestor in order to provide the information about the messages.
/// The widget uses a [ListView.separated] to render the list of messages.
///
/// The widget components render the ui based on the first ancestor of type [StreamChatTheme].
/// Modify it to change the widget appearance.
class MessageSearchListViewCore extends StatefulWidget {
  /// Instantiate a new MessageSearchListView
  const MessageSearchListViewCore({
    Key key,
    this.messageQuery,
    this.filters,
    this.sortOptions,
    this.paginationParams,
    this.messageFilters,
    @required this.emptyBuilder,
    @required this.errorBuilder,
    @required this.loadingBuilder,
    @required this.childBuilder,
    this.messageSearchListController,
  }) : super(key: key);

  final MessageSearchListController messageSearchListController;

  /// Message String to search on
  final String messageQuery;

  /// The query filters to use.
  /// You can query on any of the custom fields you've defined on the [Channel].
  /// You can also filter other built-in channel fields.
  final Map<String, dynamic> filters;

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

  /// The message query filters to use.
  /// You can query on any of the custom fields you've defined on the [Channel].
  /// You can also filter other built-in channel fields.
  final Map<String, dynamic> messageFilters;

  final Widget Function(List<GetMessageResponse>) childBuilder;

  /// The builder used when the channel list is empty.
  final EmptyMessageSearchBuilder emptyBuilder;

  /// The builder that will be used in case of error
  final Widget Function(Error error) errorBuilder;

  final WidgetBuilder loadingBuilder;

  @override
  _MessageSearchListViewCoreState createState() =>
      _MessageSearchListViewCoreState();
}

class _MessageSearchListViewCoreState extends State<MessageSearchListViewCore> {
  @override
  void initState() {
    super.initState();
    final messageSearchBloc = MessageSearchBloc.of(context);
    messageSearchBloc.search(
      filter: widget.filters,
      sort: widget.sortOptions,
      query: widget.messageQuery,
      pagination: widget.paginationParams,
      messageFilter: widget.messageFilters,
    );

    if (widget.messageSearchListController != null) {
      widget.messageSearchListController.paginateData = paginateData;
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageSearchBloc = MessageSearchBloc.of(context);
    return _buildListView(messageSearchBloc);
  }

  Widget _buildListView(MessageSearchBlocState messageSearchBloc) {
    return StreamBuilder<List<GetMessageResponse>>(
      stream: messageSearchBloc.messagesStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          if (snapshot.error is Error) {
            print((snapshot.error as Error).stackTrace);
          }

          return widget.errorBuilder(snapshot.error);
        }

        if (!snapshot.hasData) {
          return widget.loadingBuilder(context);
        }

        final items = snapshot.data;

        if (items.isEmpty) {
          return widget.emptyBuilder(context, widget.messageQuery);
        }

        return widget.childBuilder(snapshot.data);
      },
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
  void didUpdateWidget(MessageSearchListViewCore oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filters?.toString() != oldWidget.filters?.toString() ||
        jsonEncode(widget.sortOptions) != jsonEncode(oldWidget.sortOptions) ||
        widget.paginationParams?.toJson()?.toString() !=
            oldWidget.paginationParams?.toJson()?.toString() ||
        widget.messageQuery?.toString() != oldWidget.messageQuery?.toString() ||
        widget.messageFilters?.toString() !=
            oldWidget.messageFilters?.toString()) {
      final messageSearchBloc = MessageSearchBloc.of(context);
      messageSearchBloc.search(
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
  VoidCallback paginateData;
}
