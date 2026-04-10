import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';
import 'package:stream_chat_flutter_core/src/stream_draft_list_event_handler.dart';

/// The default channel page limit to load.
const defaultDraftPagedLimit = 10;

/// The default sort used for the draft list.
const defaultDraftListSort = [
  SortOption<Draft>.desc(DraftSortKey.createdAt),
];

const _kDefaultBackendPaginationLimit = 30;

/// {@template streamDraftListController}
/// A controller for managing and displaying a paginated list of drafts.
///
/// The `StreamDraftListController` extends [PagedValueNotifier] to handle
/// paginated data for drafts. It provides functionality for querying drafts,
/// handling events, and managing filters and sorting.
///
/// This controller is typically used in conjunction with UI components
/// to display and interact with a list of drafts.
/// {@endtemplate}
class StreamDraftListController extends PagedValueNotifier<String, Draft> {
  /// {@macro streamThreadListController}
  StreamDraftListController({
    required this.client,
    StreamDraftListEventHandler? eventHandler,
    this.filter,
    this.sort = defaultDraftListSort,
    this.limit = defaultDraftPagedLimit,
  }) : _activeFilter = filter,
       _activeSort = sort,
       _eventHandler = eventHandler ?? StreamDraftListEventHandler(),
       super(const PagedValue.loading());

  /// Creates a [StreamThreadListController] from the passed [value].
  StreamDraftListController.fromValue(
    super.value, {
    required this.client,
    StreamDraftListEventHandler? eventHandler,
    this.filter,
    this.sort = defaultDraftListSort,
    this.limit = defaultDraftPagedLimit,
  }) : _activeFilter = filter,
       _activeSort = sort,
       _eventHandler = eventHandler ?? StreamDraftListEventHandler();

  /// The Stream client used to perform the queries.
  final StreamChatClient client;

  /// The channel event handlers to use for the draft list.
  final StreamDraftListEventHandler _eventHandler;

  /// The query filters to use.
  ///
  /// You can query on any of the custom fields you've defined on the
  /// [Draft].
  final Filter? filter;
  Filter? _activeFilter;

  /// The sorting used for the drafts matching the filters.
  ///
  /// Sorting is based on field and direction, multiple sorting options
  /// can be provided.
  ///
  /// Direction can be ascending or descending.
  final SortOrder<Draft>? sort;
  SortOrder<Draft>? _activeSort;

  /// The limit to apply to the poll vote list. The default is set to
  /// [defaultPollVotePagedLimit].
  final int limit;

  /// Allows for the change of filters used for poll vote queries.
  ///
  /// Use this if you need to support runtime filter changes,
  /// through custom filters UI.
  set filter(Filter? value) => _activeFilter = value;

  /// Allows for the change of the query sort used for poll vote queries.
  ///
  /// Use this if you need to support runtime sort changes,
  /// through custom sort UI.
  set sort(SortOrder<Draft>? value) => _activeSort = value;

  @override
  set value(PagedValue<String, Draft> newValue) {
    super.value = switch (_activeSort) {
      null => newValue,
      final draftSort => newValue.maybeMap(
        orElse: () => newValue,
        (success) => success.copyWith(
          items: success.items.sorted(draftSort.compare),
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
      final response = await client.queryDrafts(
        sort: _activeSort,
        filter: _activeFilter,
        pagination: PaginationParams(limit: limit),
      );

      final results = response.drafts;
      final nextKey = response.next;
      value = PagedValue(
        items: results,
        nextPageKey: nextKey,
      );
      // Start listening to events
      _subscribeToDraftListEvents();
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
      final response = await client.queryDrafts(
        sort: _activeSort,
        filter: _activeFilter,
        pagination: PaginationParams(limit: limit, next: nextPageKey),
      );

      final results = response.drafts;
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

  /// Event listener, which can be set in order to listen
  /// [client] web-socket events.
  ///
  /// Return `true` if the event is handled. Return `false` to
  /// allow the event to be handled internally.
  bool Function(Event event)? eventListener;

  StreamSubscription<Event>? _draftEventSubscription;

  // Subscribes to the draft list events.
  void _subscribeToDraftListEvents() {
    if (_draftEventSubscription != null) {
      _unsubscribeFromDraftListEvents();
    }

    _draftEventSubscription = client.on().listen((event) {
      // Only handle the event if the value is in success state.
      if (value.isNotSuccess) return;

      // Returns early if the event is already handled by the listener.
      if (eventListener?.call(event) ?? false) return;

      final handlerFunc = switch (event.type) {
        EventType.draftUpdated => _eventHandler.onDraftUpdated,
        EventType.draftDeleted => _eventHandler.onDraftDeleted,
        EventType.connectionRecovered => _eventHandler.onConnectionRecovered,
        _ => null,
      };

      return handlerFunc?.call(event, this);
    });
  }

  @override
  Future<void> refresh({bool resetValue = true}) {
    if (resetValue) {
      _activeFilter = filter;
      _activeSort = sort;
    }
    return super.refresh(resetValue: resetValue);
  }

  /// Replaces the previously loaded drafts with the passed [drafts].
  set drafts(List<Draft> drafts) {
    if (value.isSuccess) {
      final currentValue = value.asSuccess;
      value = currentValue.copyWith(items: drafts);
    } else {
      value = PagedValue(items: drafts);
    }
  }

  /// Updates the given [draft] in the list.
  ///
  /// Returns `true` if the thread is updated successfully. Otherwise, `false`.
  bool updateDraft(Draft draft) {
    final currentDrafts = [
      ...currentItems.merge(
        [draft],
        key: (draft) {
          var predicate = draft.channelCid;
          if (draft.parentId case final parentId?) {
            predicate += parentId;
          }

          return predicate;
        },
        update: (original, updated) => updated,
      ),
    ];

    drafts = currentDrafts;
    return true;
  }

  /// Deletes the draft with the given [channelCid] and optional [parentId]
  /// from the list.
  ///
  /// Returns `true` if the draft is deleted successfully. Otherwise, `false`.
  bool deleteDraft(Draft draft) {
    final currentDrafts = [...currentItems];
    final removeIndex = currentDrafts.indexWhere(
      (it) {
        var predicate = it.channelCid == draft.channelCid;
        if (draft.parentId case final parentId?) {
          predicate &= it.parentId == parentId;
        }

        return predicate;
      },
    );

    if (removeIndex < 0) return false;
    currentDrafts.removeAt(removeIndex);

    drafts = currentDrafts;
    return true;
  }

  // Unsubscribes from all draft list events.
  void _unsubscribeFromDraftListEvents() {
    if (_draftEventSubscription != null) {
      _draftEventSubscription!.cancel();
      _draftEventSubscription = null;
    }
  }

  /// Pauses all subscriptions added to this composite.
  void pauseEventsSubscription([Future<void>? resumeSignal]) {
    _draftEventSubscription?.pause(resumeSignal);
  }

  /// Resumes all subscriptions added to this composite.
  void resumeEventsSubscription() {
    _draftEventSubscription?.resume();
  }

  @override
  void dispose() {
    _unsubscribeFromDraftListEvents();
    super.dispose();
  }
}
