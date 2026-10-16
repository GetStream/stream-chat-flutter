import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets('StreamMessageListView shows who is typing in the channel', (tester) async {
    final ada = User(id: 'ada', name: 'Ada');

    await _pumpMessageListView(tester, typingEvents: {ada: _typingEvent(ada)});

    final indicator = tester.widget<StreamMessageListTypingIndicator>(find.byType(StreamMessageListTypingIndicator));
    expect(indicator.users, [ada]);
  });

  testWidgets('StreamMessageListView hides the typing row when nobody is typing', (tester) async {
    await _pumpMessageListView(tester, typingEvents: {});

    expect(find.byType(StreamMessageListTypingIndicator), findsNothing);
  });

  testWidgets('StreamMessageListView hides the typing row once typing stops', (tester) async {
    final ada = User(id: 'ada', name: 'Ada');
    final typingEvents = BehaviorSubject<Map<User, Event>>.seeded({ada: _typingEvent(ada)});
    addTearDown(typingEvents.close);

    await _pumpMessageListView(tester, typingEventsSubject: typingEvents);
    typingEvents.add({});
    await tester.pumpAndSettle();

    expect(find.byType(StreamMessageListTypingIndicator), findsNothing);
  });

  testWidgets('StreamMessageListView ignores users typing in a thread', (tester) async {
    final ada = User(id: 'ada', name: 'Ada');

    await _pumpMessageListView(tester, typingEvents: {ada: _typingEvent(ada, parentId: 'parent')});

    expect(find.byType(StreamMessageListTypingIndicator), findsNothing);
  });

  testWidgets('StreamMessageListView hides the typing row while newer messages are not loaded', (tester) async {
    final ada = User(id: 'ada', name: 'Ada');

    await _pumpMessageListView(tester, typingEvents: {ada: _typingEvent(ada)}, isUpToDate: false);

    expect(find.byType(StreamMessageListTypingIndicator), findsNothing);
  });

  testWidgets('StreamMessageListView hides the typing row when showTypingIndicator is false', (tester) async {
    final ada = User(id: 'ada', name: 'Ada');
    const config = StreamMessageListViewConfiguration(showTypingIndicator: false);

    await _pumpMessageListView(tester, typingEvents: {ada: _typingEvent(ada)}, config: config);

    expect(find.byType(StreamMessageListTypingIndicator), findsNothing);
  });

  testWidgets('StreamMessageListView builds the typing row with builders.typingIndicator', (tester) async {
    final ada = User(id: 'ada', name: 'Ada');
    final builders = StreamMessageListViewBuilders(
      typingIndicator: (context, users) => Text('${users.length} typing'),
    );

    await _pumpMessageListView(tester, typingEvents: {ada: _typingEvent(ada)}, builders: builders);

    expect(find.text('1 typing'), findsOneWidget);
    expect(find.byType(StreamMessageListTypingIndicator), findsNothing);
  });

  testWidgets('StreamMessageListTypingIndicator announces who is typing', (tester) async {
    final handle = tester.ensureSemantics();
    final ada = User(id: 'ada', name: 'Ada');

    await _pumpMessageListView(tester, typingEvents: {ada: _typingEvent(ada)});

    expect(find.bySemanticsLabel('Ada is typing'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('StreamMessageListTypingIndicator announces only who is typing, not the avatar overflow', (tester) async {
    final handle = tester.ensureSemantics();
    final users = [
      for (final name in ['Ada', 'Grace', 'Linus', 'Alan', 'Barbara']) User(id: name, name: name),
    ];

    await _pumpMessageListView(tester, typingEvents: {for (final user in users) user: _typingEvent(user)});

    expect(find.bySemanticsLabel('Ada and 4 more are typing'), findsOneWidget);
    expect(find.bySemanticsLabel('+2'), findsNothing);
    handle.dispose();
  });
}

Event _typingEvent(User user, {String? parentId}) {
  return Event(type: EventType.typingStart, user: user, parentId: parentId);
}

Future<void> _pumpMessageListView(
  WidgetTester tester, {
  Map<User, Event> typingEvents = const {},
  BehaviorSubject<Map<User, Event>>? typingEventsSubject,
  bool isUpToDate = true,
  StreamMessageListViewConfiguration config = const StreamMessageListViewConfiguration(),
  StreamMessageListViewBuilders builders = const StreamMessageListViewBuilders(),
}) async {
  final client = MockClient();
  final clientState = MockClientState();
  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'current-user'));
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(OwnUser(id: 'current-user')));

  final channel = MockChannel();
  final channelState = MockChannelState();
  when(() => channel.client).thenReturn(client);
  when(() => channel.state).thenReturn(channelState);
  when(() => channelState.threadsStream).thenAnswer((_) => const Stream.empty());
  final messages = [
    Message(
      id: 'message',
      text: 'Hi',
      user: User(id: 'grace', name: 'Grace'),
    ),
  ];
  when(() => channelState.messagesStream).thenAnswer((_) => Stream.value(messages));
  when(() => channelState.messages).thenReturn(messages);
  when(() => channelState.isUpToDate).thenReturn(isUpToDate);
  when(() => channelState.isUpToDateStream).thenAnswer((_) => Stream.value(isUpToDate));
  when(() => channelState.unreadCountStream).thenAnswer((_) => Stream.value(0));
  when(() => channelState.readStream).thenAnswer((_) => const Stream.empty());
  when(() => channelState.membersStream).thenAnswer((_) => const Stream.empty());
  when(() => channelState.members).thenReturn([]);
  when(() => channelState.currentUserRead).thenReturn(null);
  when(() => channelState.currentUserReadStream).thenAnswer((_) => const Stream.empty());
  final typingEventsState = typingEventsSubject ?? BehaviorSubject.seeded(typingEvents);
  addTearDown(typingEventsState.close);
  when(() => channelState.typingEvents).thenAnswer((_) => typingEventsState.value);
  when(() => channelState.typingEventsStream).thenAnswer((_) => typingEventsState.stream);

  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: StreamMessageListView(
              config: config,
              builders: builders,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
