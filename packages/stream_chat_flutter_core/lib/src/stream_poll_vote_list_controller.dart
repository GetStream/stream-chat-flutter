import 'dart:async';
import 'dart:math';

import 'package:stream_chat/stream_chat.dart';
import 'paged_value_notifier.dart';

/// The default channel page limit to load.
const defaultPollVotePagedLimit = 10;

const _kDefaultBackendPaginationLimit = 30;

/// A controller for a poll vote list.
///
/// This class lets you perform tasks such as:
/// * Load initial data.
/// * Load more data using [loadMore].
/// * Replace the previously loaded poll votes.
class StreamPollVoteListController extends PagedValueNotifier<String, PollVote> {
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
    List<PollVoteSort>? sort,
    this.limit = defaultPollVotePagedLimit,
  }) : _eventHandler = eventHandler ?? StreamPollVoteEventHandler(),
       _scope = const _AllVotesScope(),
       _activeFilter = filter,
       sort = sort ?? PollVoteSort.defaultSort,
       super(const PagedValue.loading());

  /// Creates a [StreamPollVoteListController] from the passed [value].
  StreamPollVoteListController.fromValue(
    super.value, {
    required this.channel,
    required this.pollId,
    StreamPollVoteEventHandler? eventHandler,
    this.filter,
    List<PollVoteSort>? sort,
    this.limit = defaultPollVotePagedLimit,
  }) : _eventHandler = eventHandler ?? StreamPollVoteEventHandler(),
       _scope = const _AllVotesScope(),
       _activeFilter = filter,
       sort = sort ?? PollVoteSort.defaultSort;

  /// Creates a Stream poll vote list controller that lists only the votes for
  /// the poll option with `optionId`.
  ///
  /// Votes for other options and answers cast while the list is loaded are
  /// ignored, and a vote changed to another option is removed. Setting [filter]
  /// later changes only the query; incoming votes stay limited to this option.
  StreamPollVoteListController.forOption({
    required Channel channel,
    required String pollId,
    required String optionId,
  }) : this._scoped(_OptionVotesScope(optionId), channel: channel, pollId: pollId);

  /// Creates a Stream poll vote list controller that lists only the answers of
  /// the poll.
  ///
  /// Option votes cast while the list is loaded are ignored. Setting [filter]
  /// later changes only the query; incoming votes stay limited to answers.
  StreamPollVoteListController.forAnswers({
    required Channel channel,
    required String pollId,
  }) : this._scoped(const _AnswersScope(), channel: channel, pollId: pollId);

  // Creates a controller that queries and keeps only the votes in [scope],
  // with the default sort, page limit and [StreamPollVoteEventHandler].
  StreamPollVoteListController._scoped(
    _PollVoteListScope scope, {
    required this.channel,
    required this.pollId,
  }) : _eventHandler = StreamPollVoteEventHandler(),
       _scope = scope,
       filter = scope.filter,
       sort = PollVoteSort.defaultSort,
       _activeFilter = scope.filter,
       limit = defaultPollVotePagedLimit,
       super(const PagedValue.loading());

  /// The channel to use for the poll votes list.
  final Channel channel;

  /// The poll id to use for the poll votes list.
  final String pollId;

  /// The poll vote event handlers to use for the poll votes list.
  final StreamPollVoteEventHandler _eventHandler;

  // The votes this list is limited to.
  final _PollVoteListScope _scope;

  /// The query filters to use.
  ///
  /// You can query on any of the custom fields you've defined on the
  /// [PollVote].
  final PollVoteFilter? filter;
  PollVoteFilter? _activeFilter;

  /// The sorting used for the poll votes matching the filters.
  ///
  /// Sorting is based on field and direction, multiple sorting options
  /// can be provided.
  ///
  /// Direction can be ascending or descending.
  ///
  /// Defaults to [PollVoteSort.defaultSort]; pass [PollVoteSort.empty] to leave the ordering
  /// to the API.
  final List<PollVoteSort> sort;
  late List<PollVoteSort> _activeSort = sort;

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
  set filter(PollVoteFilter? value) => _activeFilter = value;

  /// Allows for the change of the query sort used for poll vote queries.
  ///
  /// Use this if you need to support runtime sort changes,
  /// through custom sort UI.
  ///
  /// Note: This will not trigger a new query. make sure to call
  /// [doInitialLoad] after setting a new sort.
  set sort(List<PollVoteSort> value) => _activeSort = value;

  @override
  set value(PagedValue<String, PollVote> newValue) {
    super.value = newValue.maybeMap(
      orElse: () => newValue,
      (success) => success.copyWith(
        items: success.items.sortedWith(_activeSort.compare),
      ),
    );
  }

  @override
  Future<void> doInitialLoad() async {
    final limit = min(
      this.limit * defaultInitialPagedLimitMultiplier,
      _kDefaultBackendPaginationLimit,
    );
    final result = await _queryPollVotes(limit: limit);

    result.fold(
      onSuccess: (response) {
        value = PagedValue(
          items: response.votes,
          nextPageKey: response.next,
        );

        if (disposed) return;
        _subscribeToPollVoteEvents();
      },
      onFailure: (error, _) => value = PagedValue.error(_chatException(error, 'Failed to load poll votes')),
    );
  }

  @override
  Future<void> loadMore(String nextPageKey) async {
    final previousValue = value.asSuccess;

    final result = await _queryPollVotes(limit: limit, next: nextPageKey);

    result.fold(
      onSuccess: (response) {
        final next = response.next;
        value = PagedValue(
          items: previousValue.items + response.votes,
          nextPageKey: next != null && next.isNotEmpty ? next : null,
        );
      },
      onFailure: (error, _) {
        value = previousValue.copyWith(error: _chatException(error, 'Failed to load more poll votes'));
      },
    );
  }

  // Turns anything the channel throws, such as on a channel that is not
  // initialized, into a failure.
  Future<Result<QueryPollVotesResponse>> _queryPollVotes({required int limit, String? next}) async {
    try {
      return await channel.queryPollVotes(pollId, sort: _activeSort, filter: _activeFilter, limit: limit, next: next);
    } catch (error, stackTrace) {
      return Result.failure(error, stackTrace);
    }
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

      if (!_belongsToPoll(event)) return;

      final eventType = event.type;
      if (eventType == EventType.pollVoteCasted || eventType == EventType.pollAnswerCasted) {
        _eventHandler.onPollVoteCasted(event, this);
      } else if (eventType == EventType.pollVoteChanged) {
        _eventHandler.onPollVoteChanged(event, this);
      } else if (eventType == EventType.pollVoteRemoved || eventType == EventType.pollAnswerRemoved) {
        _eventHandler.onPollVoteRemoved(event, this);
      }
    });
  }

  // Whether the vote or answer carried by [event] belongs to [pollId].
  //
  // The subscription receives the events of every poll in [channel], not only the one this controller lists.
  bool _belongsToPoll(Event event) {
    final eventPollId = event.pollVote?.pollId ?? event.poll?.id;
    return eventPollId == pollId;
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
  /// By default, this adds or updates the poll vote. A controller created with
  /// [StreamPollVoteListController.forOption] or
  /// [StreamPollVoteListController.forAnswers] ignores votes for other options or
  /// votes that aren't answers, respectively.
  void onPollVoteCasted(
    Event event,
    StreamPollVoteListController controller,
  ) {
    final pollVote = event.pollVote;
    if (pollVote == null) return;
    if (!controller._scope.includes(pollVote)) return;

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
  /// By default, this adds or updates the poll vote. A controller created with
  /// [StreamPollVoteListController.forOption] or
  /// [StreamPollVoteListController.forAnswers] instead removes a vote that is no
  /// longer for that option or isn't an answer, respectively.
  void onPollVoteChanged(
    Event event,
    StreamPollVoteListController controller,
  ) {
    final pollVote = event.pollVote;
    if (pollVote == null) return;

    if (!controller._scope.includes(pollVote)) {
      _removePollVote(pollVote, controller);
      return;
    }

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

    _removePollVote(pollVote, controller);
  }

  // Removes [pollVote] from the list of [controller], if it's listed.
  void _removePollVote(PollVote pollVote, StreamPollVoteListController controller) {
    final currentPollVotes = controller.currentItems;
    if (!currentPollVotes.any((vote) => vote.id == pollVote.id)) return;

    controller.pollVotes = [...currentPollVotes.where((vote) => vote.id != pollVote.id)];
  }
}

// The votes a [StreamPollVoteListController] is limited to.
sealed class _PollVoteListScope {
  const _PollVoteListScope();

  // The query filter matching the votes in this scope, or null for every vote.
  PollVoteFilter? get filter;

  // Whether [vote] belongs in a list with this scope.
  bool includes(PollVote vote);
}

// Every vote of the poll, including answers.
final class _AllVotesScope extends _PollVoteListScope {
  const _AllVotesScope();

  @override
  PollVoteFilter? get filter => null;

  @override
  bool includes(PollVote vote) => true;
}

// The votes for a single poll option.
final class _OptionVotesScope extends _PollVoteListScope {
  const _OptionVotesScope(this.optionId);

  final String optionId;

  @override
  PollVoteFilter get filter => .equal(PollVoteFilterField.optionId, optionId);

  @override
  bool includes(PollVote vote) => vote.optionId == optionId;
}

// The answers of the poll.
final class _AnswersScope extends _PollVoteListScope {
  const _AnswersScope();

  @override
  PollVoteFilter get filter => .equal(PollVoteFilterField.isAnswer, true);

  @override
  bool includes(PollVote vote) => vote.isAnswer;
}
