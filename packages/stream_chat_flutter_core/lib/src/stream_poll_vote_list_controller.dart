import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';

/// The default channel page limit to load.
const defaultPollVotePagedLimit = 10;

/// The default sort used for the poll vote list.
const defaultPollVoteListSort = [
  SortOption<PollVote>.asc(PollVoteSortKey.createdAt),
];

const _kDefaultBackendPaginationLimit = 30;

/// A controller for a poll vote list.
///
/// This class lets you perform tasks such as:
/// * Load initial data.
/// * Load more data using [loadMore].
/// * Replace the previously loaded poll votes.
class StreamPollVoteListController
    extends PagedValueNotifier<String, PollVote> {
  /// Creates a Stream poll vote list controller.
  /// * `channel` is the Stream chat channel to use for the poll votes list.
  /// * `pollId` is the poll id to use for the poll votes list.
  /// * `filter` is the query filters to use.
  /// * `sort` is the sorting used for the poll votes matching the filters.
  /// * `limit` is the limit to apply to the poll vote list.
  StreamPollVoteListController({
    required this.channel,
    required this.pollId,
    StreamPollVoteEventHandler? eventHandler,
    this.filter,
    this.sort = defaultPollVoteListSort,
    this.limit = defaultPollVotePagedLimit,
  })  : _eventHandler = eventHandler ?? StreamPollVoteEventHandler(),
        _activeFilter = filter,
        _activeSort = sort,
        super(const PagedValue.loading());

  /// Creates a [StreamPollVoteListController] from the passed [value].
  StreamPollVoteListController.fromValue(
    super.value, {
    required this.channel,
    required this.pollId,
    StreamPollVoteEventHandler? eventHandler,
    this.filter,
    this.sort = defaultPollVoteListSort,
    this.limit = defaultPollVotePagedLimit,
  })  : _eventHandler = eventHandler ?? StreamPollVoteEventHandler(),
        _activeFilter = filter,
        _activeSort = sort;

  /// The channel to use for the poll votes list.
  final Channel channel;

  /// The poll id to use for the poll votes list.
  final String pollId;

  /// The poll vote event handlers to use for the poll votes list.
  final StreamPollVoteEventHandler _eventHandler;

  /// The query filters to use.
  ///
  /// You can query on any of the custom fields you've defined on the
  /// [PollVote].
  final Filter? filter;
  Filter? _activeFilter;

  /// The sorting used for the poll votes matching the filters.
  ///
  /// Sorting is based on field and direction, multiple sorting options
  /// can be provided.
  ///
  /// Direction can be ascending or descending.
  final SortOrder<PollVote>? sort;
  SortOrder<PollVote>? _activeSort;

  /// The limit to apply to the poll vote list. The default is set to
  /// [defaultPollVotePagedLimit].
  final int limit;

  /// Allows for the change of filters used for poll vote queries.
  ///
  /// Use this if you need to support runtime filter changes,
  /// through custom filters UI.
  ///
  /// Note: This will not trigger a new query. make sure to call
  /// [doInitialLoad] after setting a new filter.
  set filter(Filter? value) => _activeFilter = value;

  /// Allows for the change of the query sort used for poll vote queries.
  ///
  /// Use this if you need to support runtime sort changes,
  /// through custom sort UI.
  ///
  /// Note: This will not trigger a new query. make sure to call
  /// [doInitialLoad] after setting a new sort.
  set sort(SortOrder<PollVote>? value) => _activeSort = value;

  @override
  set value(PagedValue<String, PollVote> newValue) {
    super.value = switch (_activeSort) {
      null => newValue,
      final pollVoteSort => newValue.maybeMap(
          orElse: () => newValue,
          (success) => success.copyWith(
            items: success.items.sorted(pollVoteSort.compare),
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
      final response = await channel.queryPollVotes(
        pollId,
        sort: _activeSort,
        filter: _activeFilter,
        pagination: PaginationParams(limit: limit),
      );

      final results = response.votes;
      final nextKey = response.next;
      value = PagedValue(
        items: results,
        nextPageKey: nextKey,
      );

      // start listening to events
      _subscribeToPollVoteEvents();
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
      final response = await channel.queryPollVotes(
        pollId,
        sort: _activeSort,
        filter: _activeFilter,
        pagination: PaginationParams(limit: limit, next: nextPageKey),
      );

      final results = response.votes;
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
      _activeSort = sort;
    }
    return super.refresh(resetValue: resetValue);
  }

  /// Replaces the previously loaded poll votes with the passed [pollVotes].
  set pollVotes(List<PollVote> pollVotes) {
    if (value.isSuccess) {
      final currentValue = value.asSuccess;
      value = currentValue.copyWith(items: pollVotes);
    } else {
      value = PagedValue(items: pollVotes);
    }
  }

  /// Event listener, which can be set in order to listen
  /// [client] web-socket events.
  ///
  /// Return `true` if the event is handled. Return `false` to
  /// allow the event to be handled internally.
  bool Function(Event event)? eventListener;

  StreamSubscription<Event>? _pollVoteListEventSubscription;

  // Subscribes to the poll vote list events.
  void _subscribeToPollVoteEvents() {
    if (_pollVoteListEventSubscription != null) {
      _unsubscribeFromPolVoteListEvents();
    }

    _pollVoteListEventSubscription = channel.on().listen((event) {
      // Only handle the event if the value is in success state.
      if (value.isNotSuccess) return;

      // Returns early if the event is already handled by the listener.
      if (eventListener?.call(event) ?? false) return;

      final eventType = event.type;
      if (eventType == EventType.pollVoteCasted ||
          eventType == EventType.pollAnswerCasted) {
        _eventHandler.onPollVoteCasted(event, this);
      } else if (eventType == EventType.pollVoteChanged) {
        _eventHandler.onPollVoteChanged(event, this);
      } else if (eventType == EventType.pollVoteRemoved ||
          eventType == EventType.pollAnswerRemoved) {
        _eventHandler.onPollVoteRemoved(event, this);
      }
    });
  }

  // Unsubscribes from all poll vote list events.
  void _unsubscribeFromPolVoteListEvents() {
    if (_pollVoteListEventSubscription != null) {
      _pollVoteListEventSubscription!.cancel();
      _pollVoteListEventSubscription = null;
    }
  }

  /// Pauses all subscriptions added to this composite.
  void pauseEventsSubscription([Future<void>? resumeSignal]) {
    _pollVoteListEventSubscription?.pause(resumeSignal);
  }

  /// Resumes all subscriptions added to this composite.
  void resumeEventsSubscription() {
    _pollVoteListEventSubscription?.resume();
  }

  @override
  void dispose() {
    _unsubscribeFromPolVoteListEvents();
    super.dispose();
  }
}

/// Contains handlers that are called from [StreamPollVoteListController] for
/// certain [Event]s.
///
/// This class can be mixed in or extended to create custom overrides.
mixin class StreamPollVoteEventHandler {
  /// Function which gets called for the event
  /// [EventType.pollVoteCasted] and [EventType.pollAnswerCasted].
  ///
  /// This event is fired when a new poll vote is casted in a poll.
  ///
  /// By default, this adds the poll vote and moves it to the top of list.
  void onPollVoteCasted(
    Event event,
    StreamPollVoteListController controller,
  ) {
    final pollVote = event.pollVote;
    if (pollVote == null) return;

    final updatedPollVotes = <String, PollVote>{
      for (final vote in controller.currentItems) vote.id!: vote,
      pollVote.id!: pollVote,
    };

    controller.pollVotes = [...updatedPollVotes.values];
  }

  /// Function which gets called for the event [EventType.pollVoteChanged].
  ///
  /// This event is fired when a poll vote is changed in a poll.
  ///
  /// By default, this updates the poll vote with the event poll vote.
  void onPollVoteChanged(
    Event event,
    StreamPollVoteListController controller,
  ) {
    final pollVote = event.pollVote;
    if (pollVote == null) return;

    final updatedPollVotes = <String, PollVote>{
      for (final vote in controller.currentItems) vote.id!: vote,
      // Update the poll vote if it exists otherwise add it.
      pollVote.id!: pollVote,
    };

    controller.pollVotes = [...updatedPollVotes.values];
  }

  /// Function which gets called for the event [EventType.pollVoteRemoved] and
  /// [EventType.pollAnswerRemoved].
  ///
  /// This event is fired when a poll vote is removed from a poll.
  ///
  /// By default, this removes the poll vote from the list.
  void onPollVoteRemoved(
    Event event,
    StreamPollVoteListController controller,
  ) {
    final pollVote = event.pollVote;
    if (pollVote == null) return;

    final ownVotesAndAnswers = <String, PollVote>{
      for (final vote in controller.currentItems) vote.id!: vote,
    }..remove(pollVote.id);

    controller.pollVotes = [...ownVotesAndAnswers.values];
  }
}
