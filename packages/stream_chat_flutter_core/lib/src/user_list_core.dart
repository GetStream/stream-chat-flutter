import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

///
/// [UserListCore] is a simplified class that allows fetching users while
/// exposing UI builders.
/// A [UserListController] is used to load and paginate data.
///
/// ```dart
/// class UsersListPage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: UsersListCore(
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
///           return UsersPage(list);
///         }
///       ),
///     );
///   }
/// }
/// ```
///
/// [UsersBloc] must be the ancestor of this widget. This is necessary since
/// [UserListCore] depends on functionality contained within [UsersBloc].
///
/// The parameters [listBuilder], [loadingBuilder], [emptyBuilder] and
/// [errorBuilder] must all be supplied and not null.
@Deprecated('''
UserListCore is deprecated and will be removed in the next 
major version. Use StreamUserListController instead to create your custom list.
More details here https://getstream.io/chat/docs/sdk/flutter/stream_chat_flutter_core/stream_user_list_controller
''')
class UserListCore extends StatefulWidget {
  /// Instantiate a new [UserListCore]
  const UserListCore({
    required this.errorBuilder,
    required this.emptyBuilder,
    required this.loadingBuilder,
    required this.listBuilder,
    Key? key,
    this.filter = const Filter.empty(),
    this.sort,
    this.presence,
    this.groupAlphabetically = false,
    this.userListController,
    this.limit = 30,
  }) : super(key: key);

  /// A [UserListController] allows reloading and pagination.
  /// Use [UserListController.loadData] and [UserListController.paginateData]
  /// respectively for reloading and pagination.
  final UserListController? userListController;

  /// The builder that will be used in case of error
  final ErrorBuilder errorBuilder;

  /// The builder that will be used to build the list
  final Widget Function(BuildContext context, List<ListItem> users) listBuilder;

  /// The builder that will be used for loading
  final WidgetBuilder loadingBuilder;

  /// The builder used when the channel list is empty.
  final WidgetBuilder emptyBuilder;

  /// The query filters to use.
  /// You can query on any of the custom fields you've defined on the [Channel].
  /// You can also filter other built-in channel fields.
  final Filter filter;

  /// The sorting used for the channels matching the filters.
  /// Sorting is based on field and direction, multiple sorting options can be
  /// provided. You can sort based on last_updated, last_message_at, updated_at,
  /// created_at or member_count. Direction can be ascending or descending.
  final List<SortOption>? sort;

  /// If true you’ll receive user presence updates via the websocket events
  final bool? presence;

  /// The amount of users requested per API call.
  final int limit;

  /// Set it to true to group users by their first character
  ///
  /// defaults to false
  final bool groupAlphabetically;

  @override
  UserListCoreState createState() => UserListCoreState();
}

/// The current state of the [UserListCore].
class UserListCoreState extends State<UserListCore>
    with WidgetsBindingObserver {
  UsersBlocState? _usersBloc;

  @override
  void didChangeDependencies() {
    final newUsersBloc = UsersBloc.of(context);
    if (newUsersBloc != _usersBloc) {
      _usersBloc = newUsersBloc;
      loadData();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  void _setupController() {
    if (widget.userListController != null) {
      widget.userListController!.loadData = loadData;
      widget.userListController!.paginateData = paginateData;
    }
  }

  @override
  Widget build(BuildContext context) => _buildListView();

  bool get _isListAlreadySorted =>
      widget.sort?.any((e) => e.field == 'name' && e.direction == 1) ?? false;

  Stream<List<ListItem>> _buildUserStream() => _usersBloc!.usersStream.map(
        (users) {
          if (widget.groupAlphabetically) {
            var temp = users;
            if (!_isListAlreadySorted) {
              temp = users
                ..sort((curr, next) => curr.name.compareTo(next.name));
            }
            final groupedUsers = <String, List<User>>{};
            for (final e in temp) {
              final alphabet = e.name[0].toUpperCase();
              groupedUsers[alphabet] = [...groupedUsers[alphabet] ?? [], e];
            }
            final items = <ListItem>[];
            for (final key in groupedUsers.keys) {
              items
                ..add(ListHeaderItem(key))
                ..addAll(groupedUsers[key]!.map((e) => ListUserItem(e)));
            }
            return items;
          }
          return users.map((e) => ListUserItem(e)).toList();
        },
      );

  BetterStreamBuilder<List<ListItem>> _buildListView() => BetterStreamBuilder(
        stream: _buildUserStream(),
        errorBuilder: widget.errorBuilder,
        noDataBuilder: widget.loadingBuilder,
        builder: (context, items) {
          if (items.isEmpty) {
            return widget.emptyBuilder(context);
          }
          return widget.listBuilder(context, items);
        },
      );

  /// Fetches initial users and updates the widget
  Future<void> loadData() => _usersBloc!.queryUsers(
        filter: widget.filter,
        sort: widget.sort,
        presence: widget.presence,
        pagination: PaginationParams(limit: widget.limit),
      );

  /// Fetches more users with updated pagination and updates the widget
  Future<void> paginateData() => _usersBloc!.queryUsers(
        filter: widget.filter,
        sort: widget.sort,
        presence: widget.presence,
        pagination: PaginationParams(
          limit: widget.limit,
          offset: _usersBloc!.users?.length ?? 0,
        ),
      );

  @override
  void didUpdateWidget(UserListCore oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (jsonEncode(widget.filter) != jsonEncode(oldWidget.filter) ||
        jsonEncode(widget.sort) != jsonEncode(oldWidget.sort) ||
        widget.presence != oldWidget.presence ||
        widget.limit != oldWidget.limit) {
      loadData();
    }

    if (widget.userListController != oldWidget.userListController) {
      _setupController();
    }
  }
}

/// Represents an item in a the user stream list.
/// Header items are prefixed with the key `HEADER` While users are prefixed
/// with `USER`.
abstract class ListItem {
  /// Unique key per list item
  String? get key {
    if (this is ListHeaderItem) {
      final header = (this as ListHeaderItem).heading;
      return 'HEADER-${header.toLowerCase()}';
    }
    if (this is ListUserItem) {
      final user = (this as ListUserItem).user;
      return 'USER-${user.id}';
    }
    return null;
  }

  /// Helper function to build widget based on ListItem type
  // ignore: missing_return
  Widget when({
    required Widget Function(String heading) headerItem,
    required Widget Function(User user) userItem,
  }) {
    if (this is ListHeaderItem) {
      return headerItem((this as ListHeaderItem).heading);
    }
    if (this is ListUserItem) {
      return userItem((this as ListUserItem).user);
    }
    return Container();
  }
}

/// Header Item
class ListHeaderItem extends ListItem {
  /// Constructs a new [ListHeaderItem]
  ListHeaderItem(this.heading);

  /// Heading used to build the item.
  final String heading;
}

/// User Item
class ListUserItem extends ListItem {
  /// Constructs a new [ListUserItem]
  ListUserItem(this.user);

  /// [User] used to build the item.
  final User user;
}

/// Controller used for paginating data in [ChannelListView]
class UserListController {
  /// Call this function to reload data
  AsyncCallback? loadData;

  /// Call this function to load further data
  AsyncCallback? paginateData;
}
