import 'dart:async';
import 'dart:math';

import 'package:stream_chat/stream_chat.dart' hide Success;
import 'paged_value_notifier.dart';

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
  final ReactionFilter? filter;
  ReactionFilter? _activeFilter;

  /// The sorting used for the reactions matching the filters.
  ///
  /// Sorting is based on field and direction. The only backend-supported sort
  /// field is `created_at` (see [ReactionSortField]).
  ///
  /// Direction can be ascending or descending.
  final List<ReactionSort>? sort;
  List<ReactionSort>? _activeSort;

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
  set filter(ReactionFilter? value) => _activeFilter = value;

  /// Allows for the change of the query sort used for reaction queries.
  ///
  /// Use this if you need to support runtime sort changes,
  /// through custom sort UI.
  ///
  /// Note: This will not trigger a new query. Make sure to call
  /// [doInitialLoad] or [refresh] after setting a new sort.
  set sort(List<ReactionSort>? value) => _activeSort = value;

  @override
  set value(PagedValue<String?, Reaction> newValue) {
    super.value = switch (_activeSort) {
      null => newValue,
      final reactionSort => newValue.maybeMap(
        orElse: () => newValue,
        (success) => success.copyWith(
          items: success.items.sortedWith(reactionSort.compare),
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
    final result = await client.queryReactions(
      messageId,
      filter: _activeFilter,
      sort: _activeSort,
      limit: limit,
    );

    result.fold(
      onSuccess: (response) {
        final next = response.next;
        value = PagedValue(
          items: response.reactions,
          nextPageKey: next != null && next.isNotEmpty ? next : null,
        );
      },
      onFailure: (error, _) => value = PagedValue.error(_chatException(error, 'Failed to load reactions')),
    );
  }

  @override
  Future<void> loadMore(String? nextPageKey) async {
    final previousValue = value.asSuccess;

    final result = await client.queryReactions(
      messageId,
      filter: _activeFilter,
      sort: _activeSort,
      limit: limit,
      next: nextPageKey,
    );

    result.fold(
      onSuccess: (response) {
        final next = response.next;
        value = PagedValue(
          items: previousValue.items + response.reactions,
          nextPageKey: next != null && next.isNotEmpty ? next : null,
        );
      },
      onFailure: (error, _) {
        value = previousValue.copyWith(error: _chatException(error, 'Failed to load more reactions'));
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
