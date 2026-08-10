import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';
import 'package:stream_chat_flutter_core/src/search_debounce_mixin.dart';

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
       super(const PagedValue.loading());

  /// Creates a [StreamMemberListController] from the passed [value].
  StreamMemberListController.fromValue(
    super.value, {
    required this.channel,
    this.filter,
    this.sort = defaultMemberListSort,
    this.limit = defaultMemberPagedLimit,
  }) : _activeFilter = filter,
       _activeSort = sort;

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
  ///
  /// To reload as a search query changes, consider [search], which applies a
  /// query-length-aware debounce and ignores results from superseded queries.
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
  /// merged with the controller's base [filter]; an empty [query] reloads the
  /// base [filter]. Shorter, low-selectivity queries wait longer before hitting
  /// the backend; longer queries use the standard delay. Rapidly superseded
  /// searches are dropped, so only the latest query's results are applied.
  ///
  /// To search on other fields, set [filter] directly and call [doInitialLoad].
  void search(String query) {
    final nameFilter = query.isEmpty ? null : Filter.autoComplete('name', query);
    _activeFilter = switch ((filter, nameFilter)) {
      (final base?, final name?) => Filter.and([base, name]),
      (final base?, _) => base,
      (_, final name?) => name,
      _ => null,
    };
    debouncedSearch(query.length);
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
    // of firing an extra, un-debounced request (e.g. on first view mount).
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

      // Drop the page if a newer search or clearResults() superseded it, so it
      // cannot repopulate results the user has already moved on from.
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
