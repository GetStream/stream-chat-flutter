import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'mocks.dart';

const _pollId = 'poll-a';
const _otherPollId = 'poll-b';
const _pizza = 'option-pizza';
const _sushi = 'option-sushi';

void main() {
  test('StreamPollVoteListController.doInitialLoad loads the first page of votes', () async {
    final channel = _channelAnswering([
      Result.success(_page([_vote('v1'), _vote('v2')], next: 'cursor')),
    ]);
    final controller = _controller(channel);

    await controller.doInitialLoad();

    expect(controller.value, PagedValue<String, PollVote>(items: [_vote('v1'), _vote('v2')], nextPageKey: 'cursor'));
  });

  test('StreamPollVoteListController.doInitialLoad asks for three pages at once', () async {
    final channel = _channelAnswering([Result.success(_page([]))]);
    final controller = _controller(channel);

    await controller.doInitialLoad();

    verify(
      () => channel.queryPollVotes(
        'poll-id',
        filter: any(named: 'filter'),
        sort: any(named: 'sort'),
        limit: 30,
      ),
    );
  });

  test('StreamPollVoteListController.doInitialLoad turns a failure into the error state', () async {
    const error = StreamClientException(message: 'boom');
    final channel = _channelAnswering([const Result.failure(error)]);
    final controller = _controller(channel);

    await controller.doInitialLoad();

    expect(controller.value, const PagedValue<String, PollVote>.error(error));
  });

  test('StreamPollVoteListController.doInitialLoad turns an error the channel throws into the error state', () async {
    final channel = MockChannel();
    final thrown = StateError('Channel is not initialized');
    when(
      () => channel.queryPollVotes(
        any(),
        filter: any(named: 'filter'),
        sort: any(named: 'sort'),
        limit: any(named: 'limit'),
        next: any(named: 'next'),
        prev: any(named: 'prev'),
      ),
    ).thenThrow(thrown);
    final controller = _controller(channel);

    await controller.doInitialLoad();

    final error = controller.value.mapOrNull(null, error: (it) => it.error);
    expect(error, isA<StreamClientException>().having((it) => it.cause, 'cause', thrown));
  });

  test('StreamPollVoteListController.loadMore appends the next page of votes', () async {
    final channel = _channelAnswering([
      Result.success(_page([_vote('v1')], next: 'cursor')),
      Result.success(_page([_vote('v2')])),
    ]);
    final controller = _controller(channel);
    await controller.doInitialLoad();

    await controller.loadMore('cursor');

    expect(controller.value, PagedValue<String, PollVote>(items: [_vote('v1'), _vote('v2')]));
  });

  test('StreamPollVoteListController.loadMore asks for a page of ten after the given cursor', () async {
    final channel = _channelAnswering([
      Result.success(_page([_vote('v1')], next: 'cursor')),
      Result.success(_page([])),
    ]);
    final controller = _controller(channel);
    await controller.doInitialLoad();

    await controller.loadMore('cursor');

    verify(
      () => channel.queryPollVotes(
        'poll-id',
        filter: any(named: 'filter'),
        sort: any(named: 'sort'),
        limit: 10,
        next: 'cursor',
      ),
    );
  });

  test('StreamPollVoteListController.loadMore keeps the loaded votes and records a failure', () async {
    const error = StreamClientException(message: 'boom');
    final channel = _channelAnswering([
      Result.success(_page([_vote('v1')], next: 'cursor')),
      const Result.failure(error),
    ]);
    final controller = _controller(channel);
    await controller.doInitialLoad();

    await controller.loadMore('cursor');

    expect(controller.value, PagedValue<String, PollVote>(items: [_vote('v1')], nextPageKey: 'cursor', error: error));
  });

  test('StreamPollVoteListController.loadMore records an error the channel throws', () async {
    final channel = _channelAnswering([
      Result.success(_page([_vote('v1')], next: 'cursor')),
    ]);
    final controller = _controller(channel);
    await controller.doInitialLoad();
    final thrown = StateError('Channel is not initialized');
    when(
      () => channel.queryPollVotes(
        any(),
        filter: any(named: 'filter'),
        sort: any(named: 'sort'),
        limit: any(named: 'limit'),
        next: any(named: 'next'),
        prev: any(named: 'prev'),
      ),
    ).thenThrow(thrown);

    await controller.loadMore('cursor');

    expect(controller.value.asSuccess.error, isA<StreamClientException>().having((it) => it.cause, 'cause', thrown));
  });

  test('a vote-casted event for another poll leaves the list unchanged', () async {
    final existingVote = PollVote(id: 'vote-1', pollId: _pollId, optionId: 'option-1');
    final (:controller, :events) = await _loadedController(votes: [existingVote]);

    events.add(
      Event(
        type: EventType.pollVoteCasted,
        pollVote: PollVote(id: 'vote-2', pollId: _otherPollId, optionId: 'option-2'),
      ),
    );
    await pumpEventQueue();

    expect(controller.currentItems, [existingVote]);
  });

  test('a vote-casted event for the same poll adds the vote', () async {
    final (:controller, :events) = await _loadedController();
    final vote = PollVote(id: 'vote-1', pollId: _pollId, optionId: 'option-1');

    events.add(Event(type: EventType.pollVoteCasted, pollVote: vote));
    await pumpEventQueue();

    expect(controller.currentItems, [vote]);
  });

  test('an answer-casted event for another poll leaves the list unchanged', () async {
    final (:controller, :events) = await _loadedController();

    events.add(
      Event(
        type: EventType.pollAnswerCasted,
        pollVote: PollVote(id: 'answer-1', pollId: _otherPollId, answerText: 'Beach!'),
      ),
    );
    await pumpEventQueue();

    expect(controller.currentItems, isEmpty);
  });

  test('a vote-changed event for another poll leaves the list unchanged', () async {
    final (:controller, :events) = await _loadedController();

    events.add(
      Event(
        type: EventType.pollVoteChanged,
        pollVote: PollVote(id: 'vote-2', pollId: _otherPollId, optionId: 'option-2'),
      ),
    );
    await pumpEventQueue();

    expect(controller.currentItems, isEmpty);
  });

  test('a vote-casted event without a vote poll id is added when the event poll matches', () async {
    final (:controller, :events) = await _loadedController();
    final vote = PollVote(id: 'vote-1', optionId: 'option-1');

    events.add(
      Event(
        type: EventType.pollVoteCasted,
        poll: Poll(id: _pollId, name: 'Lunch', options: const []),
        pollVote: vote,
      ),
    );
    await pumpEventQueue();

    expect(controller.currentItems, [vote]);
  });

  test('a vote-casted event with no poll id leaves the list unchanged', () async {
    final (:controller, :events) = await _loadedController();

    events.add(
      Event(
        type: EventType.pollVoteCasted,
        pollVote: PollVote(id: 'vote-2', optionId: 'option-2'),
      ),
    );
    await pumpEventQueue();

    expect(controller.currentItems, isEmpty);
  });

  group('when the list is scoped to an option', () {
    test('queries only the votes for the scoped option', () async {
      final filter = await _queriedFilter(
        (channel) => StreamPollVoteListController.forOption(channel: channel, pollId: _pollId, optionId: _pizza),
      );

      expect(filter?.toJson(), PollVoteFilter.equal(PollVoteFilterField.optionId, _pizza).toJson());
    });

    test('a vote cast for another option leaves the list unchanged', () async {
      final pizzaVote = PollVote(id: 'vote-1', pollId: _pollId, optionId: _pizza);
      final (:controller, :events) = await _loadedOptionController(_pizza, votes: [pizzaVote]);

      events.add(
        Event(
          type: EventType.pollVoteCasted,
          pollVote: PollVote(id: 'vote-2', pollId: _pollId, optionId: _sushi),
        ),
      );
      await pumpEventQueue();

      expect(controller.currentItems, [pizzaVote]);
    });

    test('a vote cast for the scoped option is added', () async {
      final (:controller, :events) = await _loadedOptionController(_pizza);
      final pizzaVote = PollVote(id: 'vote-1', pollId: _pollId, optionId: _pizza);

      events.add(Event(type: EventType.pollVoteCasted, pollVote: pizzaVote));
      await pumpEventQueue();

      expect(controller.currentItems, [pizzaVote]);
    });

    test('an answer cast leaves the list unchanged', () async {
      final (:controller, :events) = await _loadedOptionController(_pizza);

      events.add(
        Event(
          type: EventType.pollAnswerCasted,
          pollVote: PollVote(id: 'answer-1', pollId: _pollId, answerText: 'Pasta!'),
        ),
      );
      await pumpEventQueue();

      expect(controller.currentItems, isEmpty);
    });

    test('a vote changed away from the scoped option is removed', () async {
      final pizzaVote = PollVote(id: 'vote-1', pollId: _pollId, optionId: _pizza);
      final (:controller, :events) = await _loadedOptionController(_pizza, votes: [pizzaVote]);

      events.add(
        Event(
          type: EventType.pollVoteChanged,
          pollVote: pizzaVote.copyWith(optionId: _sushi),
        ),
      );
      await pumpEventQueue();

      expect(controller.currentItems, isEmpty);
    });

    test('a vote changed to the scoped option is added', () async {
      final (:controller, :events) = await _loadedOptionController(_pizza);
      final pizzaVote = PollVote(id: 'vote-1', pollId: _pollId, optionId: _pizza);

      events.add(Event(type: EventType.pollVoteChanged, pollVote: pizzaVote));
      await pumpEventQueue();

      expect(controller.currentItems, [pizzaVote]);
    });
  });

  group('when the list is scoped to answers', () {
    test('queries only the answers', () async {
      final filter = await _queriedFilter(
        (channel) => StreamPollVoteListController.forAnswers(channel: channel, pollId: _pollId),
      );

      expect(filter?.toJson(), PollVoteFilter.equal(PollVoteFilterField.isAnswer, true).toJson());
    });

    test('a vote cast for an option leaves the list unchanged', () async {
      final (:controller, :events) = await _loadedAnswersController();

      events.add(
        Event(
          type: EventType.pollVoteCasted,
          pollVote: PollVote(id: 'vote-1', pollId: _pollId, optionId: _pizza),
        ),
      );
      await pumpEventQueue();

      expect(controller.currentItems, isEmpty);
    });

    test('an answer cast is added', () async {
      final (:controller, :events) = await _loadedAnswersController();
      final answer = PollVote(id: 'answer-1', pollId: _pollId, answerText: 'Pasta!');

      events.add(Event(type: EventType.pollAnswerCasted, pollVote: answer));
      await pumpEventQueue();

      expect(controller.currentItems, [answer]);
    });

    test('a changed option vote leaves the list unchanged', () async {
      final (:controller, :events) = await _loadedAnswersController();

      events.add(
        Event(
          type: EventType.pollVoteChanged,
          pollVote: PollVote(id: 'vote-1', pollId: _pollId, optionId: _pizza),
        ),
      );
      await pumpEventQueue();

      expect(controller.currentItems, isEmpty);
    });
  });

  test('a removed vote is removed from a whole-poll list', () async {
    final pizzaVote = PollVote(id: 'vote-1', pollId: _pollId, optionId: _pizza);
    final (:controller, :events) = await _loadedController(votes: [pizzaVote]);

    events.add(Event(type: EventType.pollVoteRemoved, pollVote: pizzaVote));
    await pumpEventQueue();

    expect(controller.currentItems, isEmpty);
  });

  test('a vote changed to another option stays in a whole-poll list, updated', () async {
    final pizzaVote = PollVote(id: 'vote-1', pollId: _pollId, optionId: _pizza);
    final (:controller, :events) = await _loadedController(votes: [pizzaVote]);
    final sushiVote = pizzaVote.copyWith(optionId: _sushi);

    events.add(Event(type: EventType.pollVoteChanged, pollVote: sushiVote));
    await pumpEventQueue();

    expect(controller.currentItems, [sushiVote]);
  });
}

PollVote _vote(String id) => PollVote(
  id: id,
  pollId: 'poll-id',
  optionId: 'pizza',
  createdAt: DateTime.utc(2024),
  updatedAt: DateTime.utc(2024),
);

QueryPollVotesResponse _page(List<PollVote> votes, {String? next}) =>
    QueryPollVotesResponse(duration: '4.21ms', votes: votes, next: next);

// A channel whose vote queries answer [results] in order.
MockChannel _channelAnswering(List<Result<QueryPollVotesResponse>> results) {
  final channel = MockChannel();
  final pending = [...results];
  when(
    () => channel.queryPollVotes(
      any(),
      filter: any(named: 'filter'),
      sort: any(named: 'sort'),
      limit: any(named: 'limit'),
      next: any(named: 'next'),
      prev: any(named: 'prev'),
    ),
  ).thenAnswer((_) async => pending.removeAt(0));
  when(channel.on).thenAnswer((_) => const Stream.empty());
  return channel;
}

StreamPollVoteListController _controller(Channel channel) {
  final controller = StreamPollVoteListController(channel: channel, pollId: 'poll-id');
  addTearDown(controller.dispose);
  return controller;
}

// Returns a controller for [_pollId] that has loaded [votes] and listens to the returned channel events.
//
// The controller is built by [create], or with the default constructor when [create] is omitted.
Future<({StreamPollVoteListController controller, StreamController<Event> events})> _loadedController({
  List<PollVote> votes = const [],
  StreamPollVoteListController Function(Channel channel)? create,
}) async {
  final channel = _channelAnswering([Result.success(_page(votes))]);
  final events = StreamController<Event>.broadcast();
  addTearDown(events.close);
  when(channel.on).thenAnswer((_) => events.stream);

  final controller = create?.call(channel) ?? StreamPollVoteListController(channel: channel, pollId: _pollId);
  addTearDown(controller.dispose);
  await controller.doInitialLoad();

  return (controller: controller, events: events);
}

// Returns a controller scoped to [optionId] that has loaded [votes].
Future<({StreamPollVoteListController controller, StreamController<Event> events})> _loadedOptionController(
  String optionId, {
  List<PollVote> votes = const [],
}) {
  return _loadedController(
    votes: votes,
    create: (channel) => StreamPollVoteListController.forOption(
      channel: channel,
      pollId: _pollId,
      optionId: optionId,
    ),
  );
}

// Returns a controller scoped to the poll's answers that has loaded nothing.
Future<({StreamPollVoteListController controller, StreamController<Event> events})> _loadedAnswersController() {
  return _loadedController(
    create: (channel) => StreamPollVoteListController.forAnswers(
      channel: channel,
      pollId: _pollId,
    ),
  );
}

// Returns the filter the controller built by [create] queries its first page with.
Future<PollVoteFilter?> _queriedFilter(StreamPollVoteListController Function(Channel channel) create) async {
  final channel = _channelAnswering([Result.success(_page([]))]);

  final controller = create(channel);
  addTearDown(controller.dispose);
  await controller.doInitialLoad();

  return verify(
        () => channel.queryPollVotes(
          _pollId,
          filter: captureAny(named: 'filter'),
          sort: any(named: 'sort'),
          limit: any(named: 'limit'),
          next: any(named: 'next'),
          prev: any(named: 'prev'),
        ),
      ).captured.single
      as PollVoteFilter?;
}
