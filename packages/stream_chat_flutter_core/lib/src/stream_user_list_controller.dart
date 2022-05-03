import 'dart:async';
import 'dart:math';

import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';

/// The default channel page limit to load.
const defaultUserPagedLimit = 10;

const _kDefaultBackendPaginationLimit = 30;

/// A controller for a user list.
///
/// This class lets you perform tasks such as:
/// * Load initial data.
/// * Load more data using [loadMore].
/// * Replace the previously loaded users.
class StreamUserListController extends PagedValueNotifier<int, User> {
  /// Creates a Stream user list controller.
  ///
  /// * `client` is the Stream chat client to use for the channels list.
  ///
  /// * `filter` is the query filters to use.
  ///
  /// * `sort` is the sorting used for the users matching the filters.
  ///
  /// * `presence` sets whether you'll receive user presence updates via the
  /// websocket events.
  ///
  /// * `limit` is the limit to apply to the user list.
  StreamUserListController({
    required this.client,
    this.filter,
    this.sort,
    this.presence = true,
    this.limit = defaultUserPagedLimit,
  })  : _activeFilter = filter,
        _activeSort = sort,
        super(const PagedValue.loading());

  /// Creates a [StreamUserListController] from the passed [value].
  StreamUserListController.fromValue(
    PagedValue<int, User> value, {
    required this.client,
    this.filter,
    this.sort,
    this.presence = true,
    this.limit = defaultUserPagedLimit,
  })  : _activeFilter = filter,
        _activeSort = sort,
        super(value);

  /// The client to use for the channels list.
  final StreamChatClient client;

  /// The query filters to use.
  ///
  /// You can query on any of the custom fields you've defined on the [User].
  ///
  /// You can also filter other built-in channel fields.
  final Filter? filter;
  Filter? _activeFilter;

  /// The sorting used for the users matching the filters.
  ///
  /// Sorting is based on field and direction, multiple sorting options
  /// can be provided.
  ///
  /// Direction can be ascending or descending.
  final List<SortOption>? sort;
  List<SortOption>? _activeSort;

  /// If true you’ll receive user presence updates via the websocket events
  final bool presence;

  /// The limit to apply to the user list. The default is set to
  /// [defaultUserPagedLimit].
  final int limit;

  /// Allows for the change of filters used for user queries.
  ///
  /// Use this if you need to support runtime filter changes,
  /// through custom filters UI.
  set filter(Filter? value) => _activeFilter = value;

  /// Allows for the change of the query sort used for user queries.
  ///
  /// Use this if you need to support runtime sort changes,
  /// through custom sort UI.
  set sort(List<SortOption>? value) => _activeSort = value;

  @override
  Future<void> doInitialLoad() async {
    final limit = min(
      this.limit * defaultInitialPagedLimitMultiplier,
      _kDefaultBackendPaginationLimit,
    );
    try {
      final userResponse = await client.queryUsers(
        filter: _activeFilter,
        sort: _activeSort,
        presence: presence,
        pagination: PaginationParams(limit: limit),
      );

      final users = userResponse.users;
      final nextKey = users.length < limit ? null : users.length;
      value = PagedValue(
        items: users,
        nextPageKey: nextKey,
      );
    } on StreamChatError catch (error) {
      value = PagedValue.error(error);
    } catch (error) {
      final chatError = StreamChatError(error.toString());
      value = PagedValue.error(chatError);
    }
  }

  @override
  Future<void> loadMore(int nextPageKey) async {
    final previousValue = value.asSuccess;

    try {
      final userResponse = await client.queryUsers(
        filter: _activeFilter,
        sort: _activeSort,
        presence: presence,
        pagination: PaginationParams(limit: limit, offset: nextPageKey),
      );

      final users = userResponse.users;
      final previousItems = previousValue.items;
      final newItems = previousItems + users;
      final nextKey = users.length < limit ? null : newItems.length;
      value = PagedValue(
        items: newItems,
        nextPageKey: nextKey,
      );
    } on StreamChatError catch (error) {
      value = previousValue.copyWith(error: error);
    } catch (error) {
      final chatError = StreamChatError(error.toString());
      value = previousValue.copyWith(error: chatError);
    }
  }

  @override
  Future<void> refresh({bool resetValue = true}) {
    if (resetValue) {
      _activeFilter = filter;
      _activeSort = sort;
    }
    return super.refresh(resetValue: resetValue);
  }

  /// Replaces the previously loaded users with [users] and updates
  /// the nextPageKey.
  set users(List<User> users) {
    value = PagedValue(
      items: users,
      nextPageKey: users.length,
    );
  }
}
