import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  final ada = User(id: 'ada', name: 'Ada');
  final grace = User(id: 'grace', name: 'Grace');

  testWidgets('StreamTypingUsersBuilder passes the users typing in the channel', (tester) async {
    final typingEvents = BehaviorSubject.seeded({ada: _typingEvent(ada)});
    addTearDown(typingEvents.close);

    final builds = await _pumpBuilder(tester, typingEvents: typingEvents);

    expect(builds.last, [ada]);
  });

  testWidgets('StreamTypingUsersBuilder passes an empty list when nobody is typing', (tester) async {
    final typingEvents = BehaviorSubject.seeded(<User, Event>{});
    addTearDown(typingEvents.close);

    final builds = await _pumpBuilder(tester, typingEvents: typingEvents);

    expect(builds.last, isEmpty);
  });

  testWidgets('StreamTypingUsersBuilder leaves out users typing in a thread', (tester) async {
    final typingEvents = BehaviorSubject.seeded({
      ada: _typingEvent(ada),
      grace: _typingEvent(grace, parentId: 'parent-id'),
    });
    addTearDown(typingEvents.close);

    final builds = await _pumpBuilder(tester, typingEvents: typingEvents);

    expect(builds.last, [ada]);
  });

  testWidgets('StreamTypingUsersBuilder passes only users typing in the thread of parentId', (tester) async {
    final typingEvents = BehaviorSubject.seeded({
      ada: _typingEvent(ada),
      grace: _typingEvent(grace, parentId: 'parent-id'),
    });
    addTearDown(typingEvents.close);

    final builds = await _pumpBuilder(tester, typingEvents: typingEvents, parentId: 'parent-id');

    expect(builds.last, [grace]);
  });

  testWidgets('StreamTypingUsersBuilder rebuilds when the users typing change', (tester) async {
    final typingEvents = BehaviorSubject.seeded({ada: _typingEvent(ada)});
    addTearDown(typingEvents.close);
    final builds = await _pumpBuilder(tester, typingEvents: typingEvents);

    typingEvents.add({ada: _typingEvent(ada), grace: _typingEvent(grace)});
    await tester.pumpAndSettle();

    expect(builds.last, [ada, grace]);
  });

  testWidgets('StreamTypingUsersBuilder does not rebuild when the same users keep typing', (tester) async {
    final typingEvents = BehaviorSubject.seeded({ada: _typingEvent(ada)});
    addTearDown(typingEvents.close);
    final builds = await _pumpBuilder(tester, typingEvents: typingEvents);
    final buildCount = builds.length;

    typingEvents.add({ada: _typingEvent(ada)});
    await tester.pumpAndSettle();

    expect(builds, hasLength(buildCount));
  });

  testWidgets('StreamTypingUsersBuilder uses the given channel without a StreamChannel', (tester) async {
    final typingEvents = BehaviorSubject.seeded({ada: _typingEvent(ada)});
    addTearDown(typingEvents.close);
    final channel = _channelWith(typingEvents);
    final builds = <List<User>>[];

    await tester.pumpWidget(
      MaterialApp(
        home: StreamTypingUsersBuilder(
          channel: channel,
          builder: (context, users) {
            builds.add(users);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(builds.last, [ada]);
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

// Pumps the builder under a [StreamChannel], returning every list it was
// built with.
Future<List<List<User>>> _pumpBuilder(
  WidgetTester tester, {
  required BehaviorSubject<Map<User, Event>> typingEvents,
  String? parentId,
}) async {
  final channel = _channelWith(typingEvents);
  when(() => channel.isMuted).thenReturn(false);
  when(() => channel.isMutedStream).thenAnswer((_) => Stream.value(false));
  final builds = <List<User>>[];

  await tester.pumpWidget(
    MaterialApp(
      home: StreamChat(
        client: channel.client,
        child: StreamChannel(
          channel: channel,
          child: StreamTypingUsersBuilder(
            parentId: parentId,
            builder: (context, users) {
              builds.add(users);
              return const SizedBox();
            },
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  return builds;
}
