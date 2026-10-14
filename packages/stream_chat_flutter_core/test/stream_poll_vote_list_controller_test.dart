import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/stream_poll_vote_list_controller.dart';

import 'mocks.dart';

const _pollId = 'poll-a';
const _otherPollId = 'poll-b';
const _pizza = 'option-pizza';
const _sushi = 'option-sushi';

void main() {
  setUpAll(() {
    registerFallbackValue(const PaginationParams());
  });

  test('a vote-casted event for another poll leaves the list unchanged',
      () async {
    final existingVote =
        PollVote(id: 'vote-1', pollId: _pollId, optionId: 'option-1');
    final (:controller, :events) =
        await _loadedController(votes: [existingVote]);

    events.add(
      Event(
        type: EventType.pollVoteCasted,
        pollVote:
            PollVote(id: 'vote-2', pollId: _otherPollId, optionId: 'option-2'),
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

  test('an answer-casted event for another poll leaves the list unchanged',
      () async {
    final (:controller, :events) = await _loadedController();

    events.add(
      Event(
        type: EventType.pollAnswerCasted,
        pollVote: PollVote(
            id: 'answer-1', pollId: _otherPollId, answerText: 'Beach!'),
      ),
    );
    await pumpEventQueue();

    expect(controller.currentItems, isEmpty);
  });

  test('a vote-changed event for another poll leaves the list unchanged',
      () async {
    final (:controller, :events) = await _loadedController();

    events.add(
      Event(
        type: EventType.pollVoteChanged,
        pollVote:
            PollVote(id: 'vote-2', pollId: _otherPollId, optionId: 'option-2'),
      ),
    );
    await pumpEventQueue();

    expect(controller.currentItems, isEmpty);
  });

  test('a vote-casted event matching only by its event poll is added',
      () async {
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

  test('a vote-casted event with no poll id leaves the list unchanged',
      () async {
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
        (channel) => StreamPollVoteListController.option(
            channel: channel, pollId: _pollId, optionId: _pizza),
      );

      expect(filter, Filter.equal('option_id', _pizza));
    });

    test('a vote cast for another option leaves the list unchanged', () async {
      final pizzaVote =
          PollVote(id: 'vote-1', pollId: _pollId, optionId: _pizza);
      final (:controller, :events) =
          await _loadedOptionController(_pizza, votes: [pizzaVote]);

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
      final pizzaVote =
          PollVote(id: 'vote-1', pollId: _pollId, optionId: _pizza);

      events.add(Event(type: EventType.pollVoteCasted, pollVote: pizzaVote));
      await pumpEventQueue();

      expect(controller.currentItems, [pizzaVote]);
    });

    test('an answer cast leaves the list unchanged', () async {
      final (:controller, :events) = await _loadedOptionController(_pizza);

      events.add(
        Event(
          type: EventType.pollAnswerCasted,
          pollVote:
              PollVote(id: 'answer-1', pollId: _pollId, answerText: 'Pasta!'),
        ),
      );
      await pumpEventQueue();

      expect(controller.currentItems, isEmpty);
    });

    test('a vote changed away from the scoped option is removed', () async {
      final pizzaVote =
          PollVote(id: 'vote-1', pollId: _pollId, optionId: _pizza);
      final (:controller, :events) =
          await _loadedOptionController(_pizza, votes: [pizzaVote]);

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
      final pizzaVote =
          PollVote(id: 'vote-1', pollId: _pollId, optionId: _pizza);

      events.add(Event(type: EventType.pollVoteChanged, pollVote: pizzaVote));
      await pumpEventQueue();

      expect(controller.currentItems, [pizzaVote]);
    });
  });

  group('when the list is scoped to answers', () {
    test('queries only the answers', () async {
      final filter = await _queriedFilter(
        (channel) => StreamPollVoteListController.answers(
            channel: channel, pollId: _pollId),
      );

      expect(filter, Filter.equal('is_answer', true));
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
      final answer =
          PollVote(id: 'answer-1', pollId: _pollId, answerText: 'Pasta!');

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

  test('a vote changed to another option stays in a whole-poll list, updated',
      () async {
    final pizzaVote = PollVote(id: 'vote-1', pollId: _pollId, optionId: _pizza);
    final (:controller, :events) = await _loadedController(votes: [pizzaVote]);
    final sushiVote = pizzaVote.copyWith(optionId: _sushi);

    events.add(Event(type: EventType.pollVoteChanged, pollVote: sushiVote));
    await pumpEventQueue();

    expect(controller.currentItems, [sushiVote]);
  });
}

// Returns a controller for [_pollId] that has loaded [votes] and listens to
// the returned channel events.
//
// The controller is built by [create], or with the default constructor when
// [create] is omitted.
Future<
    ({
      StreamPollVoteListController controller,
      StreamController<Event> events
    })> _loadedController({
  List<PollVote> votes = const [],
  StreamPollVoteListController Function(Channel channel)? create,
}) async {
  final channel = MockChannel();
  final events = StreamController<Event>.broadcast();
  addTearDown(events.close);

  when(channel.on).thenAnswer((_) => events.stream);
  when(
    () => channel.queryPollVotes(
      _pollId,
      sort: any(named: 'sort'),
      filter: any(named: 'filter'),
      pagination: any(named: 'pagination'),
    ),
  ).thenAnswer(
    (_) async => QueryPollVotesResponse()
      ..votes = votes
      ..next = null,
  );

  final controller = create?.call(channel) ??
      StreamPollVoteListController(channel: channel, pollId: _pollId);
  addTearDown(controller.dispose);
  await controller.doInitialLoad();

  return (controller: controller, events: events);
}

// Returns a controller scoped to [optionId] that has loaded [votes].
Future<
    ({
      StreamPollVoteListController controller,
      StreamController<Event> events
    })> _loadedOptionController(
  String optionId, {
  List<PollVote> votes = const [],
}) {
  return _loadedController(
    votes: votes,
    create: (channel) => StreamPollVoteListController.option(
      channel: channel,
      pollId: _pollId,
      optionId: optionId,
    ),
  );
}

// Returns a controller scoped to the poll's answers that has loaded nothing.
Future<
    ({
      StreamPollVoteListController controller,
      StreamController<Event> events
    })> _loadedAnswersController() {
  return _loadedController(
    create: (channel) => StreamPollVoteListController.answers(
      channel: channel,
      pollId: _pollId,
    ),
  );
}

// Returns the filter the controller built by [create] queries its first page
// with.
Future<Filter?> _queriedFilter(
    StreamPollVoteListController Function(Channel channel) create) async {
  final channel = MockChannel();
  when(channel.on).thenAnswer((_) => const Stream.empty());
  when(
    () => channel.queryPollVotes(
      _pollId,
      sort: any(named: 'sort'),
      filter: any(named: 'filter'),
      pagination: any(named: 'pagination'),
    ),
  ).thenAnswer((_) async => QueryPollVotesResponse()..votes = []);

  final controller = create(channel);
  addTearDown(controller.dispose);
  await controller.doInitialLoad();

  return verify(
    () => channel.queryPollVotes(
      _pollId,
      sort: any(named: 'sort'),
      filter: captureAny(named: 'filter'),
      pagination: any(named: 'pagination'),
    ),
  ).captured.single as Filter?;
}
