import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/info_tile.dart';
import 'package:stream_chat_flutter/src/message_search_item.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../stream_chat_flutter.dart';

/// Callback called when tapping on a user
typedef MessageSearchItemTapCallback = void Function(GetMessageResponse);

/// Builder used to create a custom [ListUserItem] from a [User]
typedef MessageSearchItemBuilder = Widget Function(
    BuildContext, GetMessageResponse);

/// Builder used when [MessageSearchListView] is empty
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
class MessageSearchListView extends StatefulWidget {
  /// Instantiate a new MessageSearchListView
  const MessageSearchListView({
    Key key,
    this.messageQuery,
    this.filters,
    this.sortOptions,
    this.paginationParams,
    this.messageFilters,
    this.separatorBuilder,
    this.itemBuilder,
    this.onItemTap,
    this.showResultCount = true,
    this.pullToRefresh = true,
    this.showErrorTile = false,
    this.emptyBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.childBuilder,
  }) : super(key: key);

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

  /// Builder used to create a custom item preview
  final MessageSearchItemBuilder itemBuilder;

  /// Function called when tapping on a [MessageSearchItem]
  final MessageSearchItemTapCallback onItemTap;

  /// Builder used to create a custom item separator
  final IndexedWidgetBuilder separatorBuilder;

  /// Set it to false to hide total results text
  final bool showResultCount;

  /// Set it to false to disable the pull-to-refresh widget
  final bool pullToRefresh;

  final bool showErrorTile;

  /// The builder that is used when the search messages are fetched
  final Widget Function(List<GetMessageResponse>) childBuilder;

  /// The builder used when the channel list is empty.
  final WidgetBuilder emptyBuilder;

  /// The builder that will be used in case of error
  final ErrorBuilder errorBuilder;

  /// The builder that will be used in case of loading
  final WidgetBuilder loadingBuilder;

  @override
  _MessageSearchListViewState createState() => _MessageSearchListViewState();
}

class _MessageSearchListViewState extends State<MessageSearchListView> {
  final MessageSearchListController _messageSearchListController =
      MessageSearchListController();

  @override
  Widget build(BuildContext context) {
    return MessageSearchListCore(
      filters: widget.filters,
      sortOptions: widget.sortOptions,
      messageQuery: widget.messageQuery,
      paginationParams: widget.paginationParams,
      messageFilters: widget.messageFilters,
      messageSearchListController: _messageSearchListController,
      emptyBuilder: widget.emptyBuilder ?? (context) {
        return LayoutBuilder(
          builder: (context, viewportConstraints) {
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Center(
                  child: Text('There are no messages currently'),
                ),
              ),
            );
          },
        );
      },
      errorBuilder: widget.emptyBuilder ?? (BuildContext context, dynamic error) {
        if (error is Error) {
          print((error).stackTrace);
        }

        var message = error.toString();
        if (error is DioError) {
          if (error.type == DioErrorType.RESPONSE) {
            message = error.message;
          } else {
            message = 'Check your connection and retry';
          }
        }
        return InfoTile(
          showMessage: widget.showErrorTile,
          tileAnchor: Alignment.topCenter,
          childAnchor: Alignment.topCenter,
          message: 'An error occurred.',
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: Icon(Icons.error_outline),
                        ),
                      ),
                      TextSpan(text: 'Error loading messages'),
                    ],
                  ),
                  style: Theme.of(context).textTheme.headline6,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(message),
                ),
                RaisedButton(
                  onPressed: () {
                    _messageSearchListController.loadData();
                  },
                  child: Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
      loadingBuilder: widget.loadingBuilder ?? (context) {
        return LayoutBuilder(
          builder: (context, viewportConstraints) {
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
        );
      },
      childBuilder: widget.childBuilder ?? (list) {
        return _buildListView(list);
      },
    );
  }

  Widget _separatorBuilder(BuildContext context, int index) {
    return Container(
      height: 1,
      color: StreamChatTheme.of(context).colorTheme.greyWhisper,
    );
  }

  Widget _listItemBuilder(
      BuildContext context, GetMessageResponse getMessageResponse) {
    if (widget.itemBuilder != null) {
      return widget.itemBuilder(context, getMessageResponse);
    }
    return MessageSearchItem(
      getMessageResponse: getMessageResponse,
      onTap: () => widget.onItemTap(getMessageResponse),
    );
  }

  Widget _buildQueryProgressIndicator(context) {
    final messageSearchBloc = MessageSearchBloc.of(context);

    return StreamBuilder<bool>(
        stream: messageSearchBloc.queryMessagesLoading,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
              color: StreamChatTheme.of(context)
                  .colorTheme
                  .accentRed
                  .withOpacity(.2),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text('Error loading messages'),
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

  Widget _buildListView(List<GetMessageResponse> data) {
    final items = data;

    Widget child = ListView.separated(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: items.isNotEmpty ? items.length + 1 : items.length,
      separatorBuilder: (_, index) {
        if (widget.separatorBuilder != null) {
          return widget.separatorBuilder(context, index);
        }
        return _separatorBuilder(context, index);
      },
      itemBuilder: (context, index) {
        if (index < items.length) {
          return _listItemBuilder(context, items[index]);
        }
        return _buildQueryProgressIndicator(context);
      },
    );
    if (widget.pullToRefresh) {
      child = RefreshIndicator(
        onRefresh: () async {
          _messageSearchListController.loadData();
        },
        child: child,
      );
    }

    child = LazyLoadScrollView(
      onEndOfPage: () async {
        return _messageSearchListController.paginateData();
      },
      child: child,
    );

    if (widget.showResultCount) {
      child = Column(
        children: [
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              gradient: StreamChatTheme.of(context).colorTheme.bgGradient,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              child: Text(
                '${items.length} results',
                style: TextStyle(
                  color: StreamChatTheme.of(context).colorTheme.grey,
                ),
              ),
            ),
          ),
          Expanded(child: child),
        ],
      );
    }
    return child;
  }
}
