import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../mocks.dart';

void main() {
  late MockClient client;
  late MockClientState clientState;
  late StreamController<ScheduledMessageListState> states;

  final first = _scheduledMessage('first', text: 'Message from the scheduled list');
  final second = _scheduledMessage('second', text: 'Another scheduled message');

  // Puts [scheduledMessages] in the client state, all loaded unless
  // [hasLoadedAll] is false.
  void stubState(List<ScheduledMessage> scheduledMessages, {bool hasLoadedAll = true}) {
    final state = ScheduledMessageListState(scheduledMessages: scheduledMessages, hasLoadedAll: hasLoadedAll);
    when(() => clientState.scheduledMessageListState).thenReturn(state);
    when(client.loadScheduledMessages).thenAnswer((_) async => state);
  }

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    states = StreamController<ScheduledMessageListState>.broadcast();
    addTearDown(states.close);

    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(OwnUser(id: 'current-user-id'));
    when(() => clientState.channels).thenReturn({});
    when(() => clientState.scheduledMessageListStateStream).thenAnswer((_) => states.stream);
    stubState([first, second]);
  });

  testWidgets('renders a row for each scheduled message in the client state', (tester) async {
    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    expect(find.byType(StreamScheduledMessageListItem), findsNWidgets(2));
    expect(find.textContaining('Message from the scheduled list', findRichText: true), findsOneWidget);
    expect(find.textContaining('Another scheduled message', findRichText: true), findsOneWidget);
  });

  testWidgets('lists only the channel ones without the thread replies when given a channel', (tester) async {
    stubState([
      _scheduledMessage('channel', text: 'In the channel'),
      _scheduledMessage('reply', text: 'In a thread', parentId: 'parent'),
      _scheduledMessage('other', text: 'Elsewhere', cid: 'messaging:other'),
    ]);

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: const StreamScheduledMessageListView(cid: 'messaging:general'),
      ),
    );

    expect(find.byType(StreamScheduledMessageListItem), findsOneWidget);
    expect(find.textContaining('In the channel', findRichText: true), findsOneWidget);
  });

  testWidgets('lists only the replies in the thread when given a thread', (tester) async {
    stubState([
      _scheduledMessage('channel', text: 'In the channel'),
      _scheduledMessage('reply', text: 'In the thread', parentId: 'parent'),
      _scheduledMessage('elsewhere', text: 'In another thread', parentId: 'other-parent'),
    ]);

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: const StreamScheduledMessageListView(cid: 'messaging:general', parentId: 'parent'),
      ),
    );

    expect(find.byType(StreamScheduledMessageListItem), findsOneWidget);
    expect(find.textContaining('In the thread', findRichText: true), findsOneWidget);
  });

  testWidgets('lists only the replies in the thread when given a thread without a channel', (tester) async {
    stubState([
      _scheduledMessage('channel', text: 'In the channel'),
      _scheduledMessage('reply', text: 'In the thread', parentId: 'parent'),
    ]);

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: const StreamScheduledMessageListView(parentId: 'parent'),
      ),
    );

    expect(find.byType(StreamScheduledMessageListItem), findsOneWidget);
    expect(find.textContaining('In the thread', findRichText: true), findsOneWidget);
  });

  testWidgets('follows the scheduled messages as they change', (tester) async {
    stubState([first]);
    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    states.add(ScheduledMessageListState(scheduledMessages: [first, second], hasLoadedAll: true));
    await tester.pump();

    expect(find.byType(StreamScheduledMessageListItem), findsNWidgets(2));
  });

  testWidgets('loads the scheduled messages when they are not all loaded', (tester) async {
    stubState([], hasLoadedAll: false);

    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    verify(client.loadScheduledMessages).called(1);
  });

  testWidgets('does not load the scheduled messages when they are all loaded', (tester) async {
    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    verifyNever(client.loadScheduledMessages);
  });

  testWidgets('shows loading rows while the scheduled messages load', (tester) async {
    final load = Completer<ScheduledMessageListState>();
    stubState([], hasLoadedAll: false);
    when(client.loadScheduledMessages).thenAnswer((_) => load.future);

    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    expect(find.byType(StreamSkeletonLoading), findsOneWidget);
  });

  testWidgets('shows the scheduled messages it already holds while loading', (tester) async {
    final load = Completer<ScheduledMessageListState>();
    stubState([first], hasLoadedAll: false);
    when(client.loadScheduledMessages).thenAnswer((_) => load.future);

    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    expect(find.byType(StreamScheduledMessageListItem), findsOneWidget);
    expect(find.byType(StreamSkeletonLoading), findsNothing);
  });

  testWidgets('says there are none when the list is empty', (tester) async {
    stubState([]);

    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    expect(find.text('No scheduled messages'), findsOneWidget);
  });

  testWidgets('says the scheduled messages could not be loaded', (tester) async {
    stubState([], hasLoadedAll: false);
    when(client.loadScheduledMessages).thenAnswer((_) async => throw const StreamChatError('Boom'));

    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));
    await tester.pump();

    expect(find.text("Couldn't load scheduled messages"), findsOneWidget);
  });

  testWidgets('loads the scheduled messages again when retry is tapped', (tester) async {
    stubState([], hasLoadedAll: false);
    when(client.loadScheduledMessages).thenAnswer((_) async => throw const StreamChatError('Boom'));
    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));
    await tester.pump();

    await tester.tap(find.text('Try Again'));
    await tester.pump();

    verify(client.loadScheduledMessages).called(2);
  });

  testWidgets('calls onScheduledMessageTap with the tapped scheduled message', (tester) async {
    final tapped = <ScheduledMessage>[];
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: StreamScheduledMessageListView(onScheduledMessageTap: tapped.add),
      ),
    );

    await tester.tap(find.byType(StreamScheduledMessageListItem).first);

    expect(tapped, [first]);
  });

  testWidgets('calls onScheduledMessageLongPress with the long-pressed scheduled message', (tester) async {
    final longPressed = <ScheduledMessage>[];
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: StreamScheduledMessageListView(onScheduledMessageLongPress: longPressed.add),
      ),
    );

    await tester.longPress(find.byType(StreamScheduledMessageListItem).last);

    expect(longPressed, [second]);
  });

  testWidgets('honors per-instance itemBuilder override', (tester) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: StreamScheduledMessageListView(
          itemBuilder: (_, __, ___, ____) => const Text('custom-scheduled-row'),
        ),
      ),
    );

    expect(find.text('custom-scheduled-row'), findsNWidgets(2));
  });

  testWidgets('honors global scheduledMessageListItem component builder override', (tester) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        componentBuilders: StreamComponentBuilders(
          extensions: streamChatComponentBuilders(
            scheduledMessageListItem: (_, __) => const Text('global-scheduled-item'),
          ),
        ),
        child: const StreamScheduledMessageListView(),
      ),
    );

    expect(find.text('global-scheduled-item'), findsNWidgets(2));
  });
}

ScheduledMessage _scheduledMessage(
  String id, {
  required String text,
  String cid = 'messaging:general',
  String? parentId,
}) {
  return ScheduledMessage(
    cid: cid,
    channel: ChannelModel(cid: cid, extraData: const {'name': 'General'}),
    user: User(id: 'current-user-id'),
    message: Message(id: id, text: text, parentId: parentId),
    scheduledAt: DateTime(2026, 10, 21, 8),
    status: ScheduledMessageStatus.scheduled,
  );
}

Widget _wrapWithMaterialApp({
  required StreamChatClient client,
  required Widget child,
  StreamComponentBuilders? componentBuilders,
}) {
  return MaterialApp(
    home: StreamChat(
      client: client,
      componentBuilders: componentBuilders,
      configData: StreamChatConfigurationData(),
      connectivityStream: Stream.value([ConnectivityResult.wifi]),
      child: Scaffold(body: child),
    ),
  );
}
