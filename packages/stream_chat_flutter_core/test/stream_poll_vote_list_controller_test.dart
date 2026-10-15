import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/stream_poll_vote_list_controller.dart';

import 'mocks.dart';

const _pollId = 'poll-a';
const _otherPollId = 'poll-b';

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
}

// Returns a controller for [_pollId] that has loaded [votes] and listens to
// the returned channel events.
Future<
    ({
      StreamPollVoteListController controller,
      StreamController<Event> events
    })> _loadedController({
  List<PollVote> votes = const [],
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

  final controller =
      StreamPollVoteListController(channel: channel, pollId: _pollId);
  addTearDown(controller.dispose);
  await controller.doInitialLoad();

  return (controller: controller, events: events);
}
