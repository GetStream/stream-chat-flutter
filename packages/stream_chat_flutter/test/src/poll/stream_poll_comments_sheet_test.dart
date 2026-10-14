import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

const _pollId = 'poll-a';
const _pizza = PollOption(id: 'option-pizza', text: 'Pizza');

void main() {
  setUpAll(() {
    registerFallbackValue(const PaginationParams());
  });

  testWidgets('does not list a vote cast for an option', (tester) async {
    final ben = User(id: 'ben', name: 'Ben');
    final emit = await _pumpCommentsSheet(tester);

    emit(
      Event(
        type: EventType.pollVoteCasted,
        pollVote: PollVote(id: 'vote-ben', pollId: _pollId, optionId: _pizza.id, user: ben),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ben'), findsNothing);
  });

  testWidgets('lists an answer cast for the poll', (tester) async {
    final ben = User(id: 'ben', name: 'Ben');
    final emit = await _pumpCommentsSheet(tester);

    emit(
      Event(
        type: EventType.pollAnswerCasted,
        pollVote: PollVote(id: 'answer-ben', pollId: _pollId, answerText: 'Pasta!', user: ben),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pasta!'), findsOneWidget);
  });
}

// Pumps the comments sheet with no comments loaded, and returns a function that emits a channel event to the sheet.
Future<void Function(Event event)> _pumpCommentsSheet(WidgetTester tester) async {
  final events = StreamController<Event>.broadcast();
  addTearDown(events.close);

  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel(eventStream: events.stream);
  final channelState = MockChannelState();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'salvatore'));
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(OwnUser(id: 'salvatore')));
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
      ..votes = []
      ..next = null,
  );

  await tester.pumpWidget(
    MaterialApp(
      home: StreamChat(
        client: client,
        child: StreamChannel.value(
          channel: channel,
          child: Scaffold(
            body: StreamPollCommentsSheet(
              poll: Poll(id: _pollId, name: 'Lunch: pizza or sushi?', options: const [_pizza]),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  return events.add;
}
