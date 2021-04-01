import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'user_item.dart';

/// Callback called when tapping on a user
typedef UserTapCallback = void Function(User, Widget);

/// Builder used to create a custom [ListUserItem] from a [User]
typedef UserItemBuilder = Widget Function(BuildContext, User, bool);

///
/// It shows the list of current users.
///
/// ```dart
/// class UsersListPage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: UsersListView(
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
/// Make sure to have a [UsersBloc] ancestor in order to provide the information about the users.
/// The widget uses a [ListView.separated], [GridView.builder] to render the list, grid of channels.
///
/// The widget components render the ui based on the first ancestor of type [StreamChatTheme].
/// Modify it to change the widget appearance.
class UserListView extends StatefulWidget {
  /// Instantiate a new UserListView
  const UserListView({
    Key key,
    this.filter,
    this.options,
    this.sort,
    this.pagination,
    this.onUserTap,
    this.onUserLongPress,
    this.userWidget,
    this.userItemBuilder,
    this.separatorBuilder,
    this.onImageTap,
    this.selectedUsers,
    this.pullToRefresh = true,
    this.groupAlphabetically = false,
    this.crossAxisCount = 1,
    this.errorBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
    this.listBuilder,
  })  : assert(
          crossAxisCount == 1 || groupAlphabetically == false,
          'Cannot group alphabetically when crossAxisCount > 1',
        ),
        super(key: key);

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
  /// limit: the number of users to return (max is 30)
  /// offset: the offset (max is 1000)
  /// message_limit: how many messages should be included to each channel
  final PaginationParams pagination;

  /// Function called when tapping on a channel
  /// By default it calls [Navigator.push] building a [MaterialPageRoute]
  /// with the widget [userWidget] as child.
  final UserTapCallback onUserTap;

  /// Function called when long pressing on a channel
  final Function(User) onUserLongPress;

  /// Widget used when opening a channel
  final Widget userWidget;

  /// Builder used to create a custom user preview
  final UserItemBuilder userItemBuilder;

  /// Builder used to create a custom item separator
  final Function(BuildContext, int) separatorBuilder;

  /// The function called when the image is tapped
  final Function(User) onImageTap;

  /// Set it to false to disable the pull-to-refresh widget
  final bool pullToRefresh;

  /// Sets a blue trailing checkMark in [ListUserItem] for all the [selectedUsers]
  final Set<User> selectedUsers;

  /// Set it to true to group users by their first character
  ///
  /// defaults to false
  final bool groupAlphabetically;

  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The builder that will be used in case of error
  final Widget Function(Error error) errorBuilder;

  /// The builder that will be used to build the list
  final Widget Function(BuildContext context, List<ListItem> users) listBuilder;

  /// The builder that will be used for loading
  final WidgetBuilder loadingBuilder;

  /// The builder used when the channel list is empty.
  final WidgetBuilder emptyBuilder;

  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView>
    with WidgetsBindingObserver {
  bool get _isListView => widget.crossAxisCount == 1;

  final UserListController _userListController = UserListController();

  @override
  Widget build(BuildContext context) {
    var child = UserListCore(
      errorBuilder: widget.errorBuilder ??
          (err) {
            return _buildError(err);
          },
      emptyBuilder: widget.emptyBuilder ??
          (context) {
            return _buildEmpty();
          },
      loadingBuilder: widget.loadingBuilder ??
          (context) {
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
      listBuilder: widget.listBuilder ??
          (context, list) {
            return _buildListView(list);
          },
      pagination: widget.pagination,
      options: widget.options,
      sort: widget.sort,
      filter: widget.filter,
      groupAlphabetically: widget.groupAlphabetically,
      userListController: _userListController,
    );

    if (!widget.pullToRefresh) {
      return child;
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          _userListController.loadData();
        },
        child: child,
      );
    }
  }

  bool get isListAlreadySorted =>
      widget.sort?.any((e) => e.field == 'name' && e.direction == 1) ?? false;

  Widget _buildError(Error error) {
    print((error).stackTrace);

    var message = error.toString();
    if (error is DioError) {
      final dioError = error as DioError;
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
              _userListController.loadData();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return LayoutBuilder(
      builder: (context, viewportConstraints) {
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Center(
              child: Text('There are no users currently'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(
    List<ListItem> items,
  ) {
    final child = _isListView
        ? ListView.separated(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: items.isNotEmpty ? items.length + 1 : items.length,
            separatorBuilder: (_, index) {
              if (widget.separatorBuilder != null) {
                return widget.separatorBuilder(context, index);
              }
              return _separatorBuilder(context, index);
            },
            itemBuilder: (context, index) {
              return _listItemBuilder(context, index, items);
            },
          )
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
            ),
            itemCount: items.isNotEmpty ? items.length + 1 : items.length,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _gridItemBuilder(context, index, items);
            },
          );

    return LazyLoadScrollView(
      onEndOfPage: () async {
        return _userListController.paginateData();
      },
      child: child,
    );
  }

  Widget _listItemBuilder(BuildContext context, int i, List<ListItem> items) {
    final usersProvider = UsersBloc.of(context);
    if (i < items.length) {
      final item = items[i];
      return item.when(
        headerItem: (header) {
          return Container(
            key: ValueKey<String>('HEADER-$header'),
            color:
                StreamChatTheme.of(context).colorTheme.black.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
              child: Text(
                header,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.5,
                  color: StreamChatTheme.of(context).colorTheme.grey,
                ),
              ),
            ),
          );
        },
        userItem: (user) {
          final selected = widget.selectedUsers?.contains(user) ?? false;
          return Container(
            key: ValueKey<String>('USER-${user.id}'),
            child: widget.userItemBuilder != null
                ? widget.userItemBuilder(context, user, selected)
                : UserItem(
                    user: user,
                    onTap: (user) => widget.onUserTap(user, widget.userWidget),
                    onLongPress: widget.onUserLongPress,
                    onImageTap: widget.onImageTap,
                    selected: selected,
                  ),
          );
        },
      );
    } else {
      return _buildQueryProgressIndicator(context, usersProvider);
    }
  }

  Widget _gridItemBuilder(BuildContext context, int i, List<ListItem> items) {
    final usersProvider = UsersBloc.of(context);
    if (i < items.length) {
      final item = items[i];
      return item.when(
        headerItem: (_) => Offstage(),
        userItem: (user) {
          final selected = widget.selectedUsers?.contains(user) ?? false;
          return Container(
            key: ValueKey<String>('USER-${user.id}'),
            child: widget.userItemBuilder != null
                ? widget.userItemBuilder(context, user, selected)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UserAvatar(
                        user: user,
                        borderRadius: BorderRadius.circular(32),
                        selected: selected,
                        constraints: BoxConstraints.tightFor(
                          height: 64,
                          width: 64,
                        ),
                        onlineIndicatorConstraints: BoxConstraints.tightFor(
                          height: 12,
                          width: 12,
                        ),
                        onTap: (user) =>
                            widget.onUserTap(user, widget.userWidget),
                        onLongPress: widget.onUserLongPress,
                      ),
                      SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          user.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      );
    } else {
      return _buildQueryProgressIndicator(context, usersProvider);
    }
  }

  Widget _buildQueryProgressIndicator(context, UsersBlocState usersProvider) {
    return StreamBuilder<bool>(
        stream: usersProvider.queryUsersLoading,
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
                  child: Text('Error loading users'),
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
      color: StreamChatTheme.of(context).colorTheme.greyWhisper,
    );
  }
}
