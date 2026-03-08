import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';

/// The default reaction list page limit to load.
const defaultReactionPagedLimit = 25;

const _kDefaultBackendPaginationLimit = 30;

/// {@template streamReactionListController}
/// A controller for managing and displaying a paginated list of reactions.
///
/// The `StreamReactionListController` extends [PagedValueNotifier] to handle
/// paginated data for reactions. It provides functionality for querying
/// reactions and managing filters and sorting.
///
/// This controller uses cursor-based pagination via the `queryReactions` API,
/// which supports filtering by reaction type, user ID, or creation date.
///
/// This controller is typically used in conjunction with UI components
/// to display and interact with a list of reactions for a message.
/// {@endtemplate}
class StreamReactionListController extends PagedValueNotifier<String?, Reaction> {
  /// {@macro streamReactionListController}
  StreamReactionListController({
    required this.client,
    required this.messageId,
    this.filter,
    this.sort,
    this.limit = defaultReactionPagedLimit,
  }) : _activeFilter = filter,
       _activeSort = sort,
       super(const PagedValue.loading());

  /// Creates a [StreamReactionListController] from the passed [value].
  StreamReactionListController.fromValue(
    super.value, {
    required this.client,
    required this.messageId,
    this.filter,
    this.sort,
    this.limit = defaultReactionPagedLimit,
  }) : _activeFilter = filter,
       _activeSort = sort;

  /// The Stream chat client used to query reactions.
  final StreamChatClient client;

  /// The ID of the message whose reactions are being listed.
  final String messageId;

  /// The query filters to use.
  ///
  /// Supported filter fields: `type`, `user_id`, `created_at`.
  final Filter? filter;
  Filter? _activeFilter;

  /// The sorting used for the reactions matching the filters.
  ///
  /// Sorting is based on field and direction. The only backend-supported sort
  /// field is `created_at` (see [ReactionSortKey]).
  ///
  /// Direction can be ascending or descending.
  final SortOrder<Reaction>? sort;
  SortOrder<Reaction>? _activeSort;

  /// The limit to apply to the reaction list.
  ///
  /// The default is set to [defaultReactionPagedLimit].
  final int limit;

  /// Allows for the change of filters used for reaction queries.
  ///
  /// Use this if you need to support runtime filter changes,
  /// such as switching between reaction type tabs.
  ///
  /// Note: This will not trigger a new query. Make sure to call
  /// [doInitialLoad] or [refresh] after setting a new filter.
  set filter(Filter? value) => _activeFilter = value;

  /// Allows for the change of the query sort used for reaction queries.
  ///
  /// Use this if you need to support runtime sort changes,
  /// through custom sort UI.
  ///
  /// Note: This will not trigger a new query. Make sure to call
  /// [doInitialLoad] or [refresh] after setting a new sort.
  set sort(SortOrder<Reaction>? value) => _activeSort = value;

  @override
  set value(PagedValue<String?, Reaction> newValue) {
    super.value = switch (_activeSort) {
      null => newValue,
      final reactionSort => newValue.maybeMap(
        orElse: () => newValue,
        (success) => success.copyWith(
          items: success.items.sorted(reactionSort.compare),
        ),
      ),
    };
  }

  @override
  Future<void> doInitialLoad() async {
    final limit = min(
      this.limit * defaultInitialPagedLimitMultiplier,
      _kDefaultBackendPaginationLimit,
    );
    try {
      final response = await client.queryReactions(
        messageId,
        filter: _activeFilter,
        sort: _activeSort,
        pagination: PaginationParams(limit: limit),
      );

      final reactions = response.reactions;
      final next = response.next;
      final nextKey = next != null && next.isNotEmpty ? next : null;
      value = PagedValue(
        items: reactions,
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
  Future<void> loadMore(String? nextPageKey) async {
    final previousValue = value.asSuccess;

    try {
      final response = await client.queryReactions(
        messageId,
        filter: _activeFilter,
        sort: _activeSort,
        pagination: PaginationParams(limit: limit, next: nextPageKey),
      );

      final reactions = response.reactions;
      final previousItems = previousValue.items;
      final newItems = previousItems + reactions;
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
      _activeSort = sort;
    }
    return super.refresh(resetValue: resetValue);
  }

  /// Replaces the previously loaded reactions with [reactions].
  set reactions(List<Reaction> reactions) {
    if (value.isSuccess) {
      final currentValue = value.asSuccess;
      value = currentValue.copyWith(items: reactions);
    } else {
      value = PagedValue(items: reactions);
    }
  }
}
