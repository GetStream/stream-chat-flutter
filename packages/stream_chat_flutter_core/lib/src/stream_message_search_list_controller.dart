import 'dart:async';
import 'dart:math';

import 'package:stream_chat/stream_chat.dart' hide Success;
import 'paged_value_notifier.dart';
import 'search_debounce_mixin.dart';
import 'search_debouncer.dart';

/// The default channel page limit to load.
const defaultMessageSearchPagedLimit = 10;

const _kDefaultBackendPaginationLimit = 30;

/// A controller for a message search list.
///
/// This class lets you perform tasks such as:
/// * Load initial data.
/// * Load more data using [loadMore].
/// * Search with a query-length-aware debounce using [search].
/// * Replace the previously loaded results.
class StreamMessageSearchListController extends PagedValueNotifier<String, SearchMessageResult>
    with SearchDebounceMixin {
  /// Creates a Stream message search list controller.
  ///
  /// * `client` is the Stream chat client to use for the message search.
  ///
  /// * `filter` is the channel query filters to use.
  ///
  /// * `sort` is the sorting used for the messages matching the filters.
  ///
  /// * `limit` is the limit to apply to the message search.
  StreamMessageSearchListController({
    required this.client,
    required this.filter,
    this.messageFilter,
    this.searchQuery,
    this.sort,
    this.limit = defaultMessageSearchPagedLimit,
  }) : assert(
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

  /// Creates a [StreamMessageSearchListController] from the passed [value].
  StreamMessageSearchListController.fromValue(
    super.value, {
    required this.client,
    required this.filter,
    this.messageFilter,
    this.searchQuery,
    this.sort,
    this.limit = defaultMessageSearchPagedLimit,
  }) : assert(
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

  /// The client to use for the message search.
  final StreamChatClient client;

  /// The channel query filters to use.
  ///
  /// You can query on any of the custom fields you've defined on the [Channel].
  ///
  /// You can also filter other built-in channel fields.
  final ChannelFilter filter;
  ChannelFilter _activeFilter;

  /// The message query filters to use.
  ///
  /// You can query on any of the custom fields you've defined on the [Message].
  ///
  /// You can also filter other built-in message fields.
  final MessageSearchFilter? messageFilter;
  MessageSearchFilter? _activeMessageFilter;

  /// Message String to search on.
  final String? searchQuery;
  String? _activeSearchQuery;

  /// The sorting used for the messages matching the filters.
  ///
  /// Sorting is based on field and direction, multiple sorting options
  /// can be provided.
  ///
  /// Direction can be ascending or descending.
  final List<MessageSearchSort>? sort;
  List<MessageSearchSort>? _activeSort;

  /// The limit to apply to the message search. The default is set to
  /// [defaultMessageSearchPagedLimit].
  final int limit;

  /// Allows for the change of filters used for message search queries.
  ///
  /// Use this if you need to support runtime filter changes,
  /// through custom filters UI.
  ///
  /// Note: This will not trigger a new query. make sure to call
  /// [doInitialLoad] after setting a new filter.
  set filter(ChannelFilter value) => _activeFilter = value;

  /// Allows for the change of message filters used for message search queries.
  ///
  /// Use this if you need to support runtime filter changes,
  /// through custom filters UI.
  ///
  /// Note: This will not trigger a new query. make sure to call
  /// [doInitialLoad] after setting a new filter.
  set messageFilter(MessageSearchFilter? value) => _activeMessageFilter = value;

  /// Allows for the change of filters used for message search queries.
  ///
  /// Use this if you need to support runtime filter changes,
  /// through custom filters UI.
  ///
  /// Note: This will not trigger a new query. make sure to call
  /// [doInitialLoad] after setting a new filter.
  set searchQuery(String? value) => _activeSearchQuery = value;

  /// Allows for the change of the query sort used for message search queries.
  ///
  /// Use this if you need to support runtime sort changes,
  /// through custom sort UI.
  ///
  /// Note: This will not trigger a new query. make sure to call
  /// [doInitialLoad] after setting a new sort.
  set sort(List<MessageSearchSort>? value) => _activeSort = value;

  /// Searches messages whose text matches [query], debounced by its length.
  ///
  /// [query] is matched against the message text as an autocomplete filter. A
  /// blank [query] clears the results instead of querying, since the backend
  /// rejects empty message searches. Rapidly superseded searches are dropped,
  /// so only the latest query's results are applied.
  ///
  /// To search on other message fields, use [searchWithFilter].
  void search(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return clearResults();

    final searchFilter = MessageSearchFilter.autoComplete(MessageSearchFilterField.text, trimmed);

    return searchWithFilter(searchFilter);
  }

  /// Searches with an explicit message [filter], debounced by the search text
  /// it holds.
  ///
  /// The [filter] becomes the active message filter, clearing any active search
  /// query. When it carries a text-search operator ([Filter.autoComplete] or
  /// [Filter.query]) the reload is debounced by that text's length; otherwise
  /// it reloads immediately. Rapidly superseded searches are dropped, so only
  /// the latest query's results are applied.
  void searchWithFilter(MessageSearchFilter filter) {
    _activeMessageFilter = filter;
    _activeSearchQuery = null;
    debouncedSearch(searchQueryLength(filter));
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
    final result = await client.search(
      _activeFilter,
      sort: _activeSort,
      query: _activeSearchQuery,
      messageFilters: _activeMessageFilter,
      limit: limit,
    );

    if (isStale(generation)) return;
    result.fold(
      onSuccess: (response) => value = PagedValue(items: response.results, nextPageKey: response.next),
      onFailure: (error, _) {
        value = PagedValue.error(_chatException(error, 'Failed to load message search results'));
      },
    );
  }

  @override
  Future<void> loadMore(String nextPageKey) async {
    final generation = loadGeneration;
    final previousValue = value.asSuccess;

    final result = await client.search(
      _activeFilter,
      sort: _activeSort,
      query: _activeSearchQuery,
      messageFilters: _activeMessageFilter,
      limit: limit,
      next: nextPageKey,
    );

    // Drop the page if a newer search or clearResults() superseded it, so a
    // stale page cannot repopulate the results.
    if (isStale(generation)) return;
    result.fold(
      onSuccess: (response) {
        final next = response.next;
        value = PagedValue(
          items: previousValue.items + response.results,
          nextPageKey: next != null && next.isNotEmpty ? next : null,
        );
      },
      onFailure: (error, _) {
        value = previousValue.copyWith(error: _chatException(error, 'Failed to load more message search results'));
      },
    );
  }

  StreamChatException _chatException(Object error, String message) => switch (error) {
    final StreamChatException error => error,
    _ => StreamClientException(message: message, cause: error),
  };

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
