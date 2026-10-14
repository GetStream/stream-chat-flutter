import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

const _pollId = 'poll-a';
const _pizza = PollOption(id: 'option-pizza', text: 'Pizza');
const _sushi = PollOption(id: 'option-sushi', text: 'Sushi');

void main() {
  setUpAll(() {
    registerFallbackValue(const PaginationParams());
  });

  testWidgets('does not list a vote cast for another option', (tester) async {
    final ben = User(id: 'ben', name: 'Ben');
    final emit = await _pumpOptionVotesDialog(tester, option: _pizza);

    emit(Event(type: EventType.pollVoteCasted, pollVote: _voteBy(ben, _sushi)));
    await tester.pumpAndSettle();

    expect(find.text('Ben'), findsNothing);
  });

  testWidgets('stops listing a vote changed to another option', (tester) async {
    final pizzaVote = _voteBy(User(id: 'ben', name: 'Ben'), _pizza);
    final emit = await _pumpOptionVotesDialog(tester,
        option: _pizza, votes: [pizzaVote]);
    expect(find.text('Ben'), findsOneWidget);

    emit(
      Event(
        type: EventType.pollVoteChanged,
        pollVote: pizzaVote.copyWith(optionId: _sushi.id),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ben'), findsNothing);
  });
}

PollVote _voteBy(User user, PollOption option) {
  return PollVote(
      id: 'vote-${user.id}', pollId: _pollId, optionId: option.id, user: user);
}

// Pumps the votes dialog for [option] with [votes] already loaded, and returns
// a function that emits a channel event to the dialog.
Future<void Function(Event event)> _pumpOptionVotesDialog(
  WidgetTester tester, {
  required PollOption option,
  List<PollVote> votes = const [],
}) async {
  final events = StreamController<Event>.broadcast();
  addTearDown(events.close);

  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel();
  final channelState = MockChannelState();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'salvatore'));
  when(() => clientState.currentUserStream)
      .thenAnswer((_) => Stream.value(OwnUser(id: 'salvatore')));
  when(channel.on).thenAnswer((_) => events.stream);
  when(() => channel.client).thenReturn(client);
  when(() => channel.state).thenReturn(channelState);
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

  await tester.pumpWidget(
    MaterialApp(
      home: StreamChat(
        client: client,
        child: StreamChannel.value(
          channel: channel,
          child: Scaffold(
            body: StreamPollOptionVotesDialog(
              poll: Poll(
                  id: _pollId,
                  name: 'Lunch: pizza or sushi?',
                  options: const [_pizza, _sushi]),
              option: option,
              pollVotesCount: null,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  return events.add;
}
