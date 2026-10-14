import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  final ada = User(id: 'ada', name: 'Ada');
  final grace = User(id: 'grace', name: 'Grace');

  testWidgets('StreamTypingIndicator shows who is typing in the channel', (tester) async {
    final typingEvents = BehaviorSubject.seeded({ada: _typingEvent(ada)});
    addTearDown(typingEvents.close);

    await _pumpIndicator(tester, typingEvents: typingEvents);

    expect(find.text('Ada is typing'), findsOneWidget);
  });

  testWidgets('StreamTypingIndicator summarizes several typing users', (tester) async {
    final typingEvents = BehaviorSubject.seeded({ada: _typingEvent(ada), grace: _typingEvent(grace)});
    addTearDown(typingEvents.close);

    await _pumpIndicator(tester, typingEvents: typingEvents);

    expect(find.text('Ada and 1 more are typing'), findsOneWidget);
  });

  testWidgets('StreamTypingIndicator shows alternativeWidget when nobody is typing', (tester) async {
    final typingEvents = BehaviorSubject.seeded(<User, Event>{});
    addTearDown(typingEvents.close);

    await _pumpIndicator(tester, typingEvents: typingEvents, alternativeWidget: const Text('Last message'));

    expect(find.text('Last message'), findsOneWidget);
  });

  testWidgets('StreamTypingIndicator returns to alternativeWidget once typing stops', (tester) async {
    final typingEvents = BehaviorSubject.seeded({ada: _typingEvent(ada)});
    addTearDown(typingEvents.close);
    await _pumpIndicator(tester, typingEvents: typingEvents, alternativeWidget: const Text('Last message'));

    typingEvents.add({});
    await tester.pumpAndSettle();

    expect(find.text('Ada is typing'), findsNothing);
    expect(find.text('Last message'), findsOneWidget);
  });

  testWidgets('StreamTypingIndicator shows only users typing in the thread of parentId', (tester) async {
    final typingEvents = BehaviorSubject.seeded({
      ada: _typingEvent(ada),
      grace: _typingEvent(grace, parentId: 'parent-id'),
    });
    addTearDown(typingEvents.close);

    await _pumpIndicator(tester, typingEvents: typingEvents, parentId: 'parent-id');

    expect(find.text('Grace is typing'), findsOneWidget);
  });

  testWidgets('StreamTypingIndicator announces who is typing', (tester) async {
    final handle = tester.ensureSemantics();
    final typingEvents = BehaviorSubject.seeded({ada: _typingEvent(ada), grace: _typingEvent(grace)});
    addTearDown(typingEvents.close);

    await _pumpIndicator(tester, typingEvents: typingEvents);

    expect(find.bySemanticsLabel('Ada and 1 more are typing'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('StreamTypingIndicator uses the closest StreamChannel when channel is null', (tester) async {
    final typingEvents = BehaviorSubject.seeded({ada: _typingEvent(ada)});
    addTearDown(typingEvents.close);
    final channel = _channelWith(typingEvents);
    when(() => channel.isMuted).thenReturn(false);
    when(() => channel.isMutedStream).thenAnswer((_) => Stream.value(false));

    await tester.pumpWidget(
      _app(
        StreamChat(
          client: channel.client,
          child: StreamChannel(channel: channel, child: const StreamTypingIndicator()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ada is typing'), findsOneWidget);
  });
}

Event _typingEvent(User user, {String? parentId}) {
  return Event(type: EventType.typingStart, user: user, parentId: parentId);
}

MockChannel _channelWith(BehaviorSubject<Map<User, Event>> typingEvents) {
  final client = MockClient();
  final clientState = MockClientState();
  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'current-user'));

  final channel = MockChannel();
  final channelState = MockChannelState();
  when(() => channel.client).thenReturn(client);
  when(() => channel.state).thenReturn(channelState);
  when(() => channelState.typingEvents).thenAnswer((_) => typingEvents.value);
  when(() => channelState.typingEventsStream).thenAnswer((_) => typingEvents.stream);
  return channel;
}

// Animations off, so the dots hold still and the tree can settle.
Widget _app(Widget child) {
  return MaterialApp(
    home: MediaQuery(
      data: const MediaQueryData(disableAnimations: true),
      child: Scaffold(body: child),
    ),
  );
}

Future<void> _pumpIndicator(
  WidgetTester tester, {
  required BehaviorSubject<Map<User, Event>> typingEvents,
  String? parentId,
  Widget? alternativeWidget,
}) async {
  final indicator = StreamTypingIndicator(
    channel: _channelWith(typingEvents),
    parentId: parentId,
    alternativeWidget: alternativeWidget,
  );

  await tester.pumpWidget(_app(indicator));
  await tester.pumpAndSettle();
}
