import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/users_bloc.dart';

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
    this.pullToRefresh = true,
    this.groupAlphabetically = false,
    @required this.errorBuilder,
    @required this.emptyBuilder,
    @required this.loadingBuilder,
    @required this.listBuilder,
    this.userListController,
  }) : super(key: key);

  final UserListController userListController;

  /// The builder that will be used in case of error
  final Widget Function(Error error) errorBuilder;

  /// The builder that will be used to build the list
  final Widget Function(BuildContext context, List<ListItem> users) listBuilder;

  /// The builder that will be used for loading
  final WidgetBuilder loadingBuilder;

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
  /// limit: the number of users to return (max is 30)
  /// offset: the offset (max is 1000)
  /// message_limit: how many messages should be included to each channel
  final PaginationParams pagination;

  /// Set it to false to disable the pull-to-refresh widget
  final bool pullToRefresh;

  /// Set it to true to group users by their first character
  ///
  /// defaults to false
  final bool groupAlphabetically;

  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    final usersBloc = UsersBloc.of(context);
    usersBloc.queryUsers(
      filter: widget.filter,
      sort: widget.sort,
      pagination: widget.pagination,
      options: widget.options,
    );

    if (widget.userListController != null) {
      widget.userListController.paginateData = paginateData;
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersBloc = UsersBloc.of(context);

    if (!widget.pullToRefresh) {
      return _buildListView(usersBloc);
    }

    return RefreshIndicator(
      onRefresh: () async {
        return usersBloc.queryUsers(
          filter: widget.filter,
          sort: widget.sort,
          options: widget.options,
          pagination: widget.pagination,
        );
      },
      child: _buildListView(usersBloc),
    );
  }

  bool get isListAlreadySorted =>
      widget.sort?.any((e) => e.field == 'name' && e.direction == 1) ?? false;

  Stream<List<ListItem>> _buildUserStream(
    UsersBlocState usersBlocState,
  ) {
    return usersBlocState.usersStream.map(
      (users) {
        if (widget.groupAlphabetically) {
          var temp = users;
          if (!isListAlreadySorted) {
            temp = users..sort((curr, next) => curr.name.compareTo(next.name));
          }
          final groupedUsers = <String, List<User>>{};
          for (final e in temp) {
            final alphabet = e.name[0]?.toUpperCase();
            groupedUsers[alphabet] = [...groupedUsers[alphabet] ?? [], e];
          }
          final items = <ListItem>[];
          for (final key in groupedUsers.keys) {
            items.add(ListHeaderItem(key));
            items.addAll(groupedUsers[key].map((e) => ListUserItem(e)));
          }
          return items;
        }
        return users.map((e) => ListUserItem(e)).toList();
      },
    );
  }

  StreamBuilder<List<ListItem>> _buildListView(
    UsersBlocState usersBlocState,
  ) {
    return StreamBuilder(
      stream: _buildUserStream(usersBlocState),
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
          return widget.emptyBuilder(context);
        }

        if (items.isEmpty) {
          return widget.emptyBuilder(context);
        }

        return widget.listBuilder(context, items);
      },
    );
  }

  void paginateData() {
    final usersBloc = UsersBloc.of(context);

    usersBloc.queryUsers(
      filter: widget.filter,
      sort: widget.sort,
      pagination: widget.pagination.copyWith(
        offset: usersBloc.users?.length ?? 0,
      ),
      options: widget.options,
    );
  }

  @override
  void didUpdateWidget(UserListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filter?.toString() != oldWidget.filter?.toString() ||
        jsonEncode(widget.sort) != jsonEncode(oldWidget.sort) ||
        widget.pagination?.toJson()?.toString() !=
            oldWidget.pagination?.toJson()?.toString() ||
        widget.options?.toString() != oldWidget.options?.toString()) {
      final usersBloc = UsersBloc.of(context);
      usersBloc.queryUsers(
        filter: widget.filter,
        sort: widget.sort,
        pagination: widget.pagination,
        options: widget.options,
      );
    }
  }
}

abstract class ListItem {
  String get key {
    if (this is ListHeaderItem) {
      final header = (this as ListHeaderItem).heading;
      return 'HEADER-$header';
    }
    if (this is ListUserItem) {
      final user = (this as ListUserItem).user;
      return 'USER-${user.id}';
    }
    return null;
  }

  Widget when({
    @required Widget Function(String heading) headerItem,
    @required Widget Function(User user) userItem,
  }) {
    if (this is ListHeaderItem) {
      return headerItem((this as ListHeaderItem).heading);
    }
    if (this is ListUserItem) {
      return userItem((this as ListUserItem).user);
    }
    return SizedBox();
  }
}

class ListHeaderItem extends ListItem {
  final String heading;

  ListHeaderItem(this.heading);
}

class ListUserItem extends ListItem {
  final User user;

  ListUserItem(this.user);
}

/// Controller used for paginating data in [ChannelListView]
class UserListController {
  VoidCallback paginateData;
}
