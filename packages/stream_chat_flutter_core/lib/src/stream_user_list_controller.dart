import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';
import 'package:stream_chat_flutter_core/src/search_debounce_mixin.dart';
import 'package:stream_chat_flutter_core/src/search_debouncer.dart';

/// The default channel page limit to load.
const defaultUserPagedLimit = 10;

/// The default sort used for the user list.
const defaultUserListSort = [
  SortOption<User>.desc(UserSortKey.createdAt),
];

const _kDefaultBackendPaginationLimit = 30;

/// A controller for a user list.
///
/// This class lets you perform tasks such as:
/// * Load initial data.
/// * Load more data using [loadMore].
/// * Search with a query-length-aware debounce using [search].
/// * Replace the previously loaded users.
class StreamUserListController extends PagedValueNotifier<int, User> with SearchDebounceMixin {
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
    this.sort = defaultUserListSort,
    this.presence = true,
    this.limit = defaultUserPagedLimit,
    @visibleForTesting this.debouncePolicy = const SearchDebouncePolicy(),
  }) : _activeFilter = filter,
       _activeSort = sort,
       super(const PagedValue.loading());

  /// Creates a [StreamUserListController] from the passed [value].
  StreamUserListController.fromValue(
    super.value, {
    required this.client,
    this.filter,
    this.sort = defaultUserListSort,
    this.presence = true,
    this.limit = defaultUserPagedLimit,
    @visibleForTesting this.debouncePolicy = const SearchDebouncePolicy(),
  }) : _activeFilter = filter,
       _activeSort = sort;

  @override
  @visibleForTesting
  final SearchDebouncePolicy debouncePolicy;

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
  final SortOrder<User>? sort;
  SortOrder<User>? _activeSort;

  /// If true you’ll receive user presence updates via the websocket events
  final bool presence;

  /// The limit to apply to the user list. The default is set to
  /// [defaultUserPagedLimit].
  final int limit;

  /// Allows for the change of filters used for user queries.
  ///
  /// Use this if you need to support runtime filter changes,
  /// through custom filters UI.
  ///
  /// Note: This will not trigger a new query. make sure to call
  /// [doInitialLoad] after setting a new filter.
  set filter(Filter? value) => _activeFilter = value;

  /// Allows for the change of the query sort used for user queries.
  ///
  /// Use this if you need to support runtime sort changes,
  /// through custom sort UI.
  ///
  /// Note: This will not trigger a new query. make sure to call
  /// [doInitialLoad] after setting a new sort.
  set sort(SortOrder<User>? value) => _activeSort = value;

  /// Searches users whose name or id matches [query], debounced by its length.
  ///
  /// [query] is matched against the user name and id as an autocomplete filter,
  /// merged with the controller's base [filter]; an empty [query] reloads the
  /// base [filter]. Rapidly superseded searches are dropped, so only the latest
  /// query's results are applied.
  ///
  /// To search on other fields, set [filter] directly and call [doInitialLoad].
  void search(String query) {
    final searchFilter = query.isEmpty
        ? null
        : Filter.or([
            Filter.autoComplete('name', query),
            Filter.autoComplete('id', query),
          ]);
    final filters = [?filter, ?searchFilter];
    _activeFilter = filters.length > 1 ? .and(filters) : filters.firstOrNull;
    debouncedSearch(query.length);
  }

  /// Searches with an explicit [filter], debounced by the search text it holds.
  ///
  /// The [filter] becomes the active filter. When it carries a text-search
  /// operator ([Filter.autoComplete] or [Filter.query]) the reload is debounced
  /// by that text's length; otherwise it reloads immediately. Rapidly
  /// superseded searches are dropped, so only the latest query's results are
  /// applied.
  void searchWithFilter(Filter filter) {
    _activeFilter = filter;
    debouncedSearch(searchQueryLength(filter));
  }

  @override
  set value(PagedValue<int, User> newValue) {
    super.value = switch (_activeSort) {
      null => newValue,
      final userSort => newValue.maybeMap(
        orElse: () => newValue,
        (success) => success.copyWith(
          items: success.items.sorted(userSort.compare),
        ),
      ),
    };
  }

  @override
  Future<void> doInitialLoad() async {
    // A debounced search is already scheduled; let it perform the load instead
    // of firing an extra, un-debounced request.
    if (hasPendingSearch) return;

    final generation = beginLoad();
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

      if (isStale(generation)) return;
      final users = userResponse.users;
      final nextKey = users.length < limit ? null : users.length;
      value = PagedValue(
        items: users,
        nextPageKey: nextKey,
      );
    } on StreamChatError catch (error) {
      if (isStale(generation)) return;
      value = PagedValue.error(error);
    } catch (error) {
      if (isStale(generation)) return;
      final chatError = StreamChatError(error.toString());
      value = PagedValue.error(chatError);
    }
  }

  @override
  Future<void> loadMore(int nextPageKey) async {
    final generation = loadGeneration;
    final previousValue = value.asSuccess;

    try {
      final userResponse = await client.queryUsers(
        filter: _activeFilter,
        sort: _activeSort,
        presence: presence,
        pagination: PaginationParams(limit: limit, offset: nextPageKey),
      );

      // Drop the page if a newer search or clearResults() superseded it, so a
      // stale page cannot repopulate the results.
      if (isStale(generation)) return;
      final users = userResponse.users;
      final previousItems = previousValue.items;
      final newItems = previousItems + users;
      final nextKey = users.length < limit ? null : newItems.length;
      value = PagedValue(
        items: newItems,
        nextPageKey: nextKey,
      );
    } on StreamChatError catch (error) {
      if (isStale(generation)) return;
      value = previousValue.copyWith(error: error);
    } catch (error) {
      if (isStale(generation)) return;
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

  /// Replaces the previously loaded users with the passed [users].
  set users(List<User> users) {
    if (value.isSuccess) {
      final currentValue = value.asSuccess;
      value = currentValue.copyWith(items: users);
    } else {
      value = PagedValue(items: users);
    }
  }
}
