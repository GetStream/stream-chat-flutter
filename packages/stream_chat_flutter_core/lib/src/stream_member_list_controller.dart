import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';
import 'package:stream_chat_flutter_core/src/search_debounce_mixin.dart';
import 'package:stream_chat_flutter_core/src/search_debouncer.dart';

/// The default channel page limit to load.
const defaultMemberPagedLimit = 10;

/// The default sort used for the member list.
const defaultMemberListSort = [
  SortOption<Member>.asc(MemberSortKey.createdAt),
];

const _kDefaultBackendPaginationLimit = 30;

/// A controller for a member list.
///
/// This class lets you perform tasks such as:
/// * Load initial data.
/// * Load more data using [loadMore].
/// * Search with a query-length-aware debounce using [search].
/// * Replace the previously loaded members.
class StreamMemberListController extends PagedValueNotifier<int, Member> with SearchDebounceMixin {
  /// Creates a Stream member list controller.
  ///
  /// * `client` is the Stream chat client to use for the channels list.
  ///
  /// * `filter` is the query filters to use.
  ///
  /// * `sort` is the sorting used for the members matching the filters.
  ///
  /// * `limit` is the limit to apply to the member list.
  StreamMemberListController({
    required this.channel,
    this.filter,
    this.sort = defaultMemberListSort,
    this.limit = defaultMemberPagedLimit,
  }) : _activeFilter = filter,
       _activeSort = sort,
       debouncePolicy = const SearchDebouncePolicy(),
       super(const PagedValue.loading());

  /// Creates a [StreamMemberListController] from the passed [value].
  StreamMemberListController.fromValue(
    super.value, {
    required this.channel,
    this.filter,
    this.sort = defaultMemberListSort,
    this.limit = defaultMemberPagedLimit,
  }) : _activeFilter = filter,
       _activeSort = sort,
       debouncePolicy = const SearchDebouncePolicy();

  @override
  @protected
  final SearchDebouncePolicy debouncePolicy;

  /// The client to use for the channels list.
  final Channel channel;

  /// The query filters to use.
  ///
  /// You can query on any of the custom fields you've defined on the [Member].
  ///
  /// You can also filter other built-in channel fields.
  final Filter? filter;
  Filter? _activeFilter;

  /// The sorting used for the members matching the filters.
  ///
  /// Sorting is based on field and direction, multiple sorting options
  /// can be provided.
  ///
  /// Direction can be ascending or descending.
  final SortOrder<Member>? sort;
  SortOrder<Member>? _activeSort;

  /// The limit to apply to the member list. The default is set to
  /// [defaultMemberPagedLimit].
  final int limit;

  /// Allows for the change of filters used for member queries.
  ///
  /// Use this if you need to support runtime filter changes,
  /// through custom filters UI.
  ///
  /// Note: This will not trigger a new query. make sure to call
  /// [doInitialLoad] after setting a new filter.
  set filter(Filter? value) => _activeFilter = value;

  /// Allows for the change of the query sort used for member queries.
  ///
  /// Use this if you need to support runtime sort changes,
  /// through custom sort UI.
  ///
  /// Note: This will not trigger a new query. make sure to call
  /// [doInitialLoad] after setting a new sort.
  set sort(SortOrder<Member>? value) => _activeSort = value;

  /// Searches members whose name matches [query], debounced by its length.
  ///
  /// [query] is matched against the member name as an autocomplete filter,
  /// which replaces the controller's base [filter] for the duration of the
  /// search; a blank [query] restores it. Rapidly superseded searches are
  /// dropped, so only the latest query's results are applied.
  ///
  /// To search on other fields, or to keep the base [filter] applied while
  /// searching, use [searchWithFilter].
  void search(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return searchWithFilter(filter);

    searchWithFilter(Filter.autoComplete('name', trimmed));
  }

  /// Searches with the given [filter], debounced by the search text it holds.
  ///
  /// The [filter] becomes the active filter; a null [filter] matches all. When
  /// it carries a text-search operator ([Filter.autoComplete] or [Filter.query])
  /// the reload is debounced by that text's length; otherwise it reloads
  /// immediately. Rapidly superseded searches are dropped, so only the latest
  /// query's results are applied.
  void searchWithFilter(Filter? filter) {
    _activeFilter = filter;
    debouncedSearch(searchQueryLength(filter));
  }

  @override
  set value(PagedValue<int, Member> newValue) {
    super.value = switch (_activeSort) {
      null => newValue,
      final memberSort => newValue.maybeMap(
        orElse: () => newValue,
        (success) => success.copyWith(
          items: success.items.sorted(memberSort.compare),
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
      final memberResponse = await channel.queryMembers(
        filter: _activeFilter,
        sort: _activeSort,
        pagination: PaginationParams(limit: limit),
      );

      if (isStale(generation)) return;
      final members = memberResponse.members;
      final nextKey = members.length < limit ? null : members.length;
      value = PagedValue(
        items: members.where((it) => it.user != null).toList(),
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
      final memberResponse = await channel.queryMembers(
        filter: _activeFilter,
        sort: _activeSort,
        pagination: PaginationParams(limit: limit, offset: nextPageKey),
      );

      // Drop the page if a newer search or clearResults() superseded it, so a
      // stale page cannot repopulate the results.
      if (isStale(generation)) return;
      final members = memberResponse.members;
      final previousItems = previousValue.items;
      final newItems = previousItems + members;
      final nextKey = members.length < limit ? null : newItems.length;
      value = PagedValue(
        items: newItems.where((it) => it.user != null).toList(),
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

  /// Replaces the previously loaded members with [members] and updates
  /// the nextPageKey.
  set members(List<Member> members) {
    value = PagedValue(
      items: members,
      nextPageKey: members.length,
    );
  }
}
