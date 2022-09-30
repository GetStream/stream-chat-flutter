import 'dart:async';
import 'dart:math';

import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';

/// The default channel page limit to load.
const defaultMemberPagedLimit = 10;

const _kDefaultBackendPaginationLimit = 30;

/// A controller for a member list.
///
/// This class lets you perform tasks such as:
/// * Load initial data.
/// * Load more data using [loadMore].
/// * Replace the previously loaded members.
class StreamMemberListController extends PagedValueNotifier<int, Member> {
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
    this.sort,
    this.limit = defaultMemberPagedLimit,
  })  : _activeFilter = filter,
        _activeSort = sort,
        super(const PagedValue.loading());

  /// Creates a [StreamMemberListController] from the passed [value].
  StreamMemberListController.fromValue(
    super.value, {
    required this.channel,
    this.filter,
    this.sort,
    this.limit = defaultMemberPagedLimit,
  })  : _activeFilter = filter,
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
  final List<SortOption>? sort;
  List<SortOption>? _activeSort;

  /// The limit to apply to the member list. The default is set to
  /// [defaultMemberPagedLimit].
  final int limit;

  /// Allows for the change of filters used for member queries.
  ///
  /// Use this if you need to support runtime filter changes,
  /// through custom filters UI.
  set filter(Filter? value) => _activeFilter = value;

  /// Allows for the change of the query sort used for member queries.
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
      final memberResponse = await channel.queryMembers(
        filter: _activeFilter,
        sort: _activeSort,
        pagination: PaginationParams(limit: limit),
      );

      final members = memberResponse.members;
      final nextKey = members.length < limit ? null : members.length;
      value = PagedValue(
        items: members.where((it) => it.user != null).toList(),
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
      final memberResponse = await channel.queryMembers(
        filter: _activeFilter,
        sort: _activeSort,
        pagination: PaginationParams(limit: limit, offset: nextPageKey),
      );

      final members = memberResponse.members;
      final previousItems = previousValue.items;
      final newItems = previousItems + members;
      final nextKey = members.length < limit ? null : newItems.length;
      value = PagedValue(
        items: newItems.where((it) => it.user != null).toList(),
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

  /// Replaces the previously loaded members with [members] and updates
  /// the nextPageKey.
  set members(List<Member> members) {
    value = PagedValue(
      items: members,
      nextPageKey: members.length,
    );
  }
}
