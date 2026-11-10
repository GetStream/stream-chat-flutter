import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  late MockClient client;
  late MockClientState clientState;
  late StreamController<List<ScheduledMessage>> clientMessages;

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    clientMessages = StreamController<List<ScheduledMessage>>.broadcast();
    addTearDown(clientMessages.close);

    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(OwnUser(id: 'current-user-id'));
    when(() => clientState.channels).thenReturn({});
    _stubClient(client, clientState, clientMessages, [_first(), _second()]);
  });

  testWidgets("StreamScheduledMessageListView lists every channel's scheduled messages without a channel", (
    tester,
  ) async {
    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    expect(find.byType(StreamScheduledMessageListItem), findsNWidgets(2));
    expect(find.textContaining('Message from the scheduled list', findRichText: true), findsOneWidget);
    expect(find.textContaining('Another scheduled message', findRichText: true), findsOneWidget);
  });

  testWidgets("StreamScheduledMessageListView lists the channel's own scheduled messages when given a channel", (
    tester,
  ) async {
    final channel = _channel(scheduledMessages: [_scheduledMessage('channel', text: 'In the channel')]);

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: StreamScheduledMessageListView(channel: channel),
      ),
    );

    expect(find.byType(StreamScheduledMessageListItem), findsOneWidget);
    expect(find.textContaining('In the channel', findRichText: true), findsOneWidget);
  });

  testWidgets("StreamScheduledMessageListView lists a thread's scheduled replies when given a thread", (tester) async {
    final channel = _channel(
      scheduledMessages: [_scheduledMessage('channel', text: 'In the channel')],
      threadReplies: [_scheduledMessage('reply', text: 'In the thread', parentId: 'parent')],
    );

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: StreamScheduledMessageListView(channel: channel, parentId: 'parent'),
      ),
    );

    expect(find.byType(StreamScheduledMessageListItem), findsOneWidget);
    expect(find.textContaining('In the thread', findRichText: true), findsOneWidget);
  });

  test('StreamScheduledMessageListView asserts that a thread has a channel', () {
    expect(
      () => StreamScheduledMessageListView(parentId: 'parent'),
      throwsA(isA<AssertionError>()),
    );
  });

  testWidgets('StreamScheduledMessageListView follows the scheduled messages as they change', (tester) async {
    _stubClient(client, clientState, clientMessages, [_first()]);
    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    clientMessages.add([_first(), _second()]);
    await tester.pump();

    expect(find.byType(StreamScheduledMessageListItem), findsNWidgets(2));
  });

  testWidgets('StreamScheduledMessageListView loads the scheduled messages when they are not all loaded', (
    tester,
  ) async {
    _stubClient(client, clientState, clientMessages, [], hasLoadedAll: false);

    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    verify(client.loadScheduledMessages).called(1);
  });

  testWidgets('StreamScheduledMessageListView does not load the scheduled messages when they are all loaded', (
    tester,
  ) async {
    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    verifyNever(client.loadScheduledMessages);
  });

  testWidgets('StreamScheduledMessageListView shows loading rows while the scheduled messages load', (tester) async {
    final load = Completer<ScheduledMessageListState>();
    _stubClient(client, clientState, clientMessages, [], hasLoadedAll: false);
    when(client.loadScheduledMessages).thenAnswer((_) => load.future);

    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    expect(find.byType(StreamSkeletonLoading), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListView shows the scheduled messages it already holds while loading', (
    tester,
  ) async {
    final load = Completer<ScheduledMessageListState>();
    _stubClient(client, clientState, clientMessages, [_first()], hasLoadedAll: false);
    when(client.loadScheduledMessages).thenAnswer((_) => load.future);

    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    expect(find.byType(StreamScheduledMessageListItem), findsOneWidget);
    expect(find.byType(StreamSkeletonLoading), findsNothing);
  });

  testWidgets('StreamScheduledMessageListView says there are none when the list is empty', (tester) async {
    _stubClient(client, clientState, clientMessages, []);

    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    expect(find.text('No scheduled messages'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListView says there are none once a load finds nothing', (tester) async {
    _stubClient(client, clientState, clientMessages, [], hasLoadedAll: false);

    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));
    await tester.pump();

    expect(find.text('No scheduled messages'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListView says the scheduled messages could not be loaded', (tester) async {
    _stubClient(client, clientState, clientMessages, [], hasLoadedAll: false);
    when(client.loadScheduledMessages).thenAnswer((_) async => throw const StreamChatError('Boom'));

    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));
    await tester.pump();

    expect(find.text('Error loading scheduled messages'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListView hands errorBuilder a StreamChatError for any failure', (tester) async {
    _stubClient(client, clientState, clientMessages, [], hasLoadedAll: false);
    when(client.loadScheduledMessages).thenAnswer((_) async => throw StateError('Boom'));

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: StreamScheduledMessageListView(
          errorBuilder: (_, error) => Text('error: ${error.message}'),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('error: Bad state: Boom'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListView loads the scheduled messages again when retry is tapped', (tester) async {
    _stubClient(client, clientState, clientMessages, [], hasLoadedAll: false);
    when(client.loadScheduledMessages).thenAnswer((_) async => throw const StreamChatError('Boom'));
    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));
    await tester.pump();

    await tester.tap(find.text('Try Again'));
    await tester.pump();

    verify(client.loadScheduledMessages).called(2);
  });

  testWidgets('StreamScheduledMessageListView calls onScheduledMessageTap with the tapped scheduled message', (
    tester,
  ) async {
    final tapped = <ScheduledMessage>[];
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: StreamScheduledMessageListView(onScheduledMessageTap: tapped.add),
      ),
    );

    await tester.tap(find.byType(StreamScheduledMessageListItem).first);

    expect(tapped, [_first()]);
  });

  testWidgets(
    'StreamScheduledMessageListView calls onScheduledMessageLongPress with the long-pressed scheduled message',
    (tester) async {
      final longPressed = <ScheduledMessage>[];
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          client: client,
          child: StreamScheduledMessageListView(onScheduledMessageLongPress: longPressed.add),
        ),
      );

      await tester.longPress(find.byType(StreamScheduledMessageListItem).last);

      expect(longPressed, [_second()]);
    },
  );

  testWidgets('StreamScheduledMessageListView honors per-instance itemBuilder override', (tester) async {
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

  testWidgets('StreamScheduledMessageListView honors global scheduledMessageListItem component builder override', (
    tester,
  ) async {
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

  testWidgets("StreamScheduledMessageListView doesn't resubscribe when its parent rebuilds", (tester) async {
    final messages = _CountingStream();
    addTearDown(messages.close);
    when(() => clientState.scheduledMessagesStream).thenAnswer((_) => messages.stream);
    late StateSetter setParentState;

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: StatefulBuilder(
          builder: (context, setState) {
            setParentState = setState;
            return StreamScheduledMessageListView(onScheduledMessageTap: (_) {});
          },
        ),
      ),
    );
    setParentState(() {});
    await tester.pump();

    expect(messages.listens, 1);
  });

  testWidgets("StreamScheduledMessageListView doesn't load again when its parent rebuilds", (tester) async {
    _stubClient(client, clientState, clientMessages, [], hasLoadedAll: false);
    late StateSetter setParentState;

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: StatefulBuilder(
          builder: (context, setState) {
            setParentState = setState;
            return StreamScheduledMessageListView(onScheduledMessageTap: (_) {});
          },
        ),
      ),
    );
    setParentState(() {});
    await tester.pump();

    verify(client.loadScheduledMessages).called(1);
  });

  testWidgets("StreamScheduledMessageListView lists another channel's scheduled messages when the channel changes", (
    tester,
  ) async {
    var channel = _channel(scheduledMessages: [_scheduledMessage('a', text: 'In the first channel')]);
    late StateSetter setParentState;
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: StatefulBuilder(
          builder: (context, setState) {
            setParentState = setState;
            return StreamScheduledMessageListView(channel: channel);
          },
        ),
      ),
    );

    setParentState(() {
      channel = _channel(scheduledMessages: [_scheduledMessage('b', text: 'In the second channel')]);
    });
    await tester.pumpAndSettle();

    expect(find.textContaining('In the second channel', findRichText: true), findsOneWidget);
    expect(find.textContaining('In the first channel', findRichText: true), findsNothing);
  });

  testWidgets("StreamScheduledMessageListView lists a thread's replies when parentId changes", (tester) async {
    final channel = _channel(
      threadReplies: [_scheduledMessage('reply', text: 'In the first thread', parentId: 'parent')],
    );
    final channelState = channel.state! as MockChannelState;
    final otherReplies = [_scheduledMessage('other', text: 'In the second thread', parentId: 'other')];
    when(() => channelState.scheduledThreadReplies('other')).thenReturn(otherReplies);
    when(() => channelState.scheduledThreadRepliesStream('other')).thenAnswer((_) => Stream.value(otherReplies));
    var parentId = 'parent';
    late StateSetter setParentState;
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: StatefulBuilder(
          builder: (context, setState) {
            setParentState = setState;
            return StreamScheduledMessageListView(channel: channel, parentId: parentId);
          },
        ),
      ),
    );

    setParentState(() => parentId = 'other');
    await tester.pumpAndSettle();

    expect(find.textContaining('In the second thread', findRichText: true), findsOneWidget);
    expect(find.textContaining('In the first thread', findRichText: true), findsNothing);
  });

  testWidgets('StreamScheduledMessageListView stops listening once disposed', (tester) async {
    final messages = _CountingStream();
    addTearDown(messages.close);
    when(() => clientState.scheduledMessagesStream).thenAnswer((_) => messages.stream);
    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    await tester.pumpWidget(const SizedBox.shrink());

    expect(messages.hasListener, isFalse);
  });

  testWidgets('StreamScheduledMessageListView retry reloads without resubscribing', (tester) async {
    final messages = _CountingStream();
    addTearDown(messages.close);
    _stubClient(client, clientState, clientMessages, [], hasLoadedAll: false);
    when(() => clientState.scheduledMessagesStream).thenAnswer((_) => messages.stream);
    when(client.loadScheduledMessages).thenAnswer((_) async => throw const StreamChatError('Boom'));
    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));
    await tester.pump();

    await tester.tap(find.text('Try Again'));
    await tester.pump();

    expect(messages.listens, 1);
    verify(client.loadScheduledMessages).called(2);
  });
}

// Puts [scheduledMessages] in the client state, all loaded unless
// [hasLoadedAll] is false. Later lists come from [messages].
void _stubClient(
  MockClient client,
  MockClientState clientState,
  StreamController<List<ScheduledMessage>> messages,
  List<ScheduledMessage> scheduledMessages, {
  bool hasLoadedAll = true,
}) {
  final state = ScheduledMessageListState(
    scheduledMessages: scheduledMessages,
    hasLoadedAll: hasLoadedAll,
  );
  when(() => clientState.scheduledMessageListState).thenReturn(state);
  when(() => clientState.scheduledMessages).thenReturn(scheduledMessages);
  when(() => clientState.scheduledMessagesStream).thenAnswer((_) => messages.stream);
  when(client.loadScheduledMessages).thenAnswer((_) async => state);
}

// A channel holding [scheduledMessages], and [threadReplies] in the thread of
// 'parent'.
MockChannel _channel({
  List<ScheduledMessage> scheduledMessages = const [],
  List<ScheduledMessage> threadReplies = const [],
}) {
  final channel = MockChannel();
  final channelState = MockChannelState();

  when(() => channel.state).thenReturn(channelState);
  when(() => channelState.scheduledMessages).thenReturn(scheduledMessages);
  when(() => channelState.scheduledMessagesStream).thenAnswer((_) => Stream.value(scheduledMessages));
  when(() => channelState.scheduledThreadReplies('parent')).thenReturn(threadReplies);
  when(() => channelState.scheduledThreadRepliesStream('parent')).thenAnswer((_) => Stream.value(threadReplies));

  return channel;
}

ScheduledMessage _first() {
  return _scheduledMessage('first', text: 'Message from the scheduled list');
}

ScheduledMessage _second() {
  return _scheduledMessage('second', text: 'Another scheduled message');
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

// A broadcast stream of scheduled messages that counts how often it's listened to.
class _CountingStream {
  late final _controller = StreamController<List<ScheduledMessage>>.broadcast(onListen: () => listens += 1);

  int listens = 0;

  Stream<List<ScheduledMessage>> get stream => _controller.stream;

  bool get hasListener => _controller.hasListener;

  Future<void> close() => _controller.close();
}
