import 'dart:async';
import 'dart:math';

import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';

/// The default channel page limit to load.
const defaultMessageSearchPagedLimit = 10;

const _kDefaultBackendPaginationLimit = 30;

/// A controller for a user list.
///
/// This class lets you perform tasks such as:
/// * Load initial data.
/// * Load more data using [loadMore].
/// * Replace the previously loaded users.
class StreamMessageSearchListController
    extends PagedValueNotifier<String, GetMessageResponse> {
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
  StreamMessageSearchListController({
    required this.client,
    required this.filter,
    this.messageFilter,
    this.searchQuery,
    this.sort,
    this.limit = defaultMessageSearchPagedLimit,
  })  : assert(
          messageFilter != null || searchQuery != null,
          'Either messageFilter or searchQuery must be provided',
        ),
        assert(
          messageFilter == null || searchQuery == null,
          'Only one of messageFilter or searchQuery can be provided',
        ),
        _activeFilter = filter,
        _activeMessageFilter = messageFilter,
        _activeSearchQuery = searchQuery,
        _activeSort = sort,
        super(const PagedValue.loading());

  /// Creates a [StreamUserListController] from the passed [value].
  StreamMessageSearchListController.fromValue(
    super.value, {
    required this.client,
    required this.filter,
    this.messageFilter,
    this.searchQuery,
    this.sort,
    this.limit = defaultMessageSearchPagedLimit,
  })  : assert(
          messageFilter != null || searchQuery != null,
          'Either messageFilter or searchQuery must be provided',
        ),
        assert(
          messageFilter == null || searchQuery == null,
          'Only one of messageFilter or searchQuery can be provided',
        ),
        _activeFilter = filter,
        _activeMessageFilter = messageFilter,
        _activeSearchQuery = searchQuery,
        _activeSort = sort;

  /// The client to use for the channels list.
  final StreamChatClient client;

  /// The query filters to use.
  ///
  /// You can query on any of the custom fields you've defined on the [User].
  ///
  /// You can also filter other built-in channel fields.
  final Filter filter;
  Filter _activeFilter;

  /// The message query filters to use.
  ///
  /// You can query on any of the custom fields you've defined on the [Channel].
  ///
  /// You can also filter other built-in channel fields.
  final Filter? messageFilter;
  Filter? _activeMessageFilter;

  /// Message String to search on.
  final String? searchQuery;
  String? _activeSearchQuery;

  /// The sorting used for the users matching the filters.
  ///
  /// Sorting is based on field and direction, multiple sorting options
  /// can be provided.
  ///
  /// Direction can be ascending or descending.
  final List<SortOption>? sort;
  List<SortOption>? _activeSort;

  /// The limit to apply to the user list. The default is set to
  /// [defaultUserPagedLimit].
  final int limit;

  /// Allows for the change of filters used for user queries.
  ///
  /// Use this if you need to support runtime filter changes,
  /// through custom filters UI.
  set filter(Filter value) => _activeFilter = value;

  /// Allows for the change of message filters used for user queries.
  ///
  /// Use this if you need to support runtime filter changes,
  /// through custom filters UI.
  set messageFilter(Filter? value) => _activeMessageFilter = value;

  /// Allows for the change of filters used for user queries.
  ///
  /// Use this if you need to support runtime filter changes,
  /// through custom filters UI.
  set searchQuery(String? value) => _activeSearchQuery = value;

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
      final response = await client.search(
        _activeFilter,
        sort: _activeSort,
        query: _activeSearchQuery,
        messageFilters: _activeMessageFilter,
        paginationParams: PaginationParams(limit: limit),
      );

      final results = response.results;
      final nextKey = response.next;
      value = PagedValue(
        items: results,
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
  Future<void> loadMore(String nextPageKey) async {
    final previousValue = value.asSuccess;

    try {
      final response = await client.search(
        _activeFilter,
        sort: _activeSort,
        query: _activeSearchQuery,
        messageFilters: _activeMessageFilter,
        paginationParams: PaginationParams(limit: limit, next: nextPageKey),
      );

      final results = response.results;
      final previousItems = previousValue.items;
      final newItems = previousItems + results;
      final next = response.next;
      final nextKey = next != null && next.isNotEmpty ? next : null;
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
      _activeMessageFilter = messageFilter;
      _activeSearchQuery = searchQuery;
      _activeSort = sort;
    }
    return super.refresh(resetValue: resetValue);
  }
}
