import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets("StreamScheduledMessageListView lists every channel's scheduled messages without a channel", (
    tester,
  ) async {
    final client = _client(scheduledMessages: [_first(), _other()]);

    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    expect(find.byType(StreamScheduledMessageListItem), findsNWidgets(2));
    expect(find.textContaining('Message from the scheduled list', findRichText: true), findsOneWidget);
    expect(find.textContaining('In another channel', findRichText: true), findsOneWidget);
  });

  testWidgets("StreamScheduledMessageListView lists only the channel's scheduled messages when given a channel", (
    tester,
  ) async {
    final client = _client(scheduledMessages: [_first(), _reply(), _other()]);

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: const StreamScheduledMessageListView(cid: 'messaging:general'),
      ),
    );

    expect(find.byType(StreamScheduledMessageListItem), findsOneWidget);
    expect(find.textContaining('Message from the scheduled list', findRichText: true), findsOneWidget);
  });

  testWidgets("StreamScheduledMessageListView lists only a thread's scheduled replies when given a thread", (
    tester,
  ) async {
    final client = _client(scheduledMessages: [_first(), _reply(), _other()]);

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: const StreamScheduledMessageListView(parentId: 'parent'),
      ),
    );

    expect(find.byType(StreamScheduledMessageListItem), findsOneWidget);
    expect(find.textContaining('In the thread', findRichText: true), findsOneWidget);
  });

  testWidgets("StreamScheduledMessageListView lists a thread's scheduled replies when given a channel too", (
    tester,
  ) async {
    final client = _client(scheduledMessages: [_first(), _reply(), _other()]);

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: const StreamScheduledMessageListView(cid: 'messaging:general', parentId: 'parent'),
      ),
    );

    expect(find.byType(StreamScheduledMessageListItem), findsOneWidget);
    expect(find.textContaining('In the thread', findRichText: true), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListView follows the scheduled messages as they change', (tester) async {
    final updates = StreamController<List<ScheduledMessage>>.broadcast();
    addTearDown(updates.close);
    final client = _client(scheduledMessages: [_first()], updates: updates.stream);
    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    updates.add([_first(), _other()]);
    await tester.pump();

    expect(find.byType(StreamScheduledMessageListItem), findsNWidgets(2));
  });

  testWidgets('StreamScheduledMessageListView loads the scheduled messages when they are not all loaded', (
    tester,
  ) async {
    final client = _client(hasLoadedAll: false);

    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    verify(client.loadScheduledMessages).called(1);
  });

  testWidgets('StreamScheduledMessageListView does not load the scheduled messages when they are all loaded', (
    tester,
  ) async {
    final client = _client(scheduledMessages: [_first()]);

    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    verifyNever(client.loadScheduledMessages);
  });

  testWidgets('StreamScheduledMessageListView shows loading rows while the scheduled messages load', (tester) async {
    final client = _client(hasLoadedAll: false);
    final load = Completer<ScheduledMessageListState>();
    when(client.loadScheduledMessages).thenAnswer((_) => load.future);

    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    expect(find.byType(StreamSkeletonLoading), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListView shows the scheduled messages it already holds while loading', (
    tester,
  ) async {
    final client = _client(scheduledMessages: [_first()], hasLoadedAll: false);
    final load = Completer<ScheduledMessageListState>();
    when(client.loadScheduledMessages).thenAnswer((_) => load.future);

    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    expect(find.byType(StreamScheduledMessageListItem), findsOneWidget);
    expect(find.byType(StreamSkeletonLoading), findsNothing);
  });

  testWidgets('StreamScheduledMessageListView says there are none when the list is empty', (tester) async {
    final client = _client();

    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    expect(find.text('No scheduled messages'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListView says there are none once a load finds nothing', (tester) async {
    final client = _client(hasLoadedAll: false);

    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));
    await tester.pump();

    expect(find.text('No scheduled messages'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListView says the scheduled messages could not be loaded', (tester) async {
    final client = _client(hasLoadedAll: false);
    when(client.loadScheduledMessages).thenAnswer((_) async => throw const StreamChatError('Boom'));

    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));
    await tester.pump();

    expect(find.text("Couldn't load scheduled messages"), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListView hands errorBuilder a StreamChatError for any failure', (tester) async {
    final client = _client(hasLoadedAll: false);
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
    final client = _client(hasLoadedAll: false);
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
    final client = _client(scheduledMessages: [_first(), _other()]);
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
      final client = _client(scheduledMessages: [_first(), _other()]);
      final longPressed = <ScheduledMessage>[];
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          client: client,
          child: StreamScheduledMessageListView(onScheduledMessageLongPress: longPressed.add),
        ),
      );

      await tester.longPress(find.byType(StreamScheduledMessageListItem).last);

      expect(longPressed, [_other()]);
    },
  );

  testWidgets('StreamScheduledMessageListView honors per-instance itemBuilder override', (tester) async {
    final client = _client(scheduledMessages: [_first(), _other()]);

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
    final client = _client(scheduledMessages: [_first(), _other()]);

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
    final updates = _CountingStream();
    addTearDown(updates.close);
    final client = _client(scheduledMessages: [_first()], updates: updates.stream);
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

    expect(updates.listens, 1);
  });

  testWidgets("StreamScheduledMessageListView doesn't load again when its parent rebuilds", (tester) async {
    final client = _client(hasLoadedAll: false);
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
    final client = _client(scheduledMessages: [_first(), _other()]);
    var cid = 'messaging:general';
    late StateSetter setParentState;
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: StatefulBuilder(
          builder: (context, setState) {
            setParentState = setState;
            return StreamScheduledMessageListView(cid: cid);
          },
        ),
      ),
    );

    setParentState(() => cid = 'messaging:other');
    await tester.pumpAndSettle();

    expect(find.textContaining('In another channel', findRichText: true), findsOneWidget);
    expect(find.textContaining('Message from the scheduled list', findRichText: true), findsNothing);
  });

  testWidgets("StreamScheduledMessageListView lists a thread's replies when parentId changes", (tester) async {
    final otherReply = _scheduledMessage('other-reply', text: 'In the second thread', parentId: 'other');
    final client = _client(scheduledMessages: [_reply(), otherReply]);
    var parentId = 'parent';
    late StateSetter setParentState;
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: StatefulBuilder(
          builder: (context, setState) {
            setParentState = setState;
            return StreamScheduledMessageListView(parentId: parentId);
          },
        ),
      ),
    );

    setParentState(() => parentId = 'other');
    await tester.pumpAndSettle();

    expect(find.textContaining('In the second thread', findRichText: true), findsOneWidget);
    expect(find.textContaining('In the thread', findRichText: true), findsNothing);
  });

  testWidgets('StreamScheduledMessageListView stops listening once disposed', (tester) async {
    final updates = _CountingStream();
    addTearDown(updates.close);
    final client = _client(scheduledMessages: [_first()], updates: updates.stream);
    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    await tester.pumpWidget(const SizedBox.shrink());

    expect(updates.hasListener, isFalse);
  });

  testWidgets('StreamScheduledMessageListView retry reloads without resubscribing', (tester) async {
    final updates = _CountingStream();
    addTearDown(updates.close);
    final client = _client(hasLoadedAll: false, updates: updates.stream);
    when(client.loadScheduledMessages).thenAnswer((_) async => throw const StreamChatError('Boom'));
    await tester.pumpWidget(_wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));
    await tester.pump();

    await tester.tap(find.text('Try Again'));
    await tester.pump();

    expect(updates.listens, 1);
    verify(client.loadScheduledMessages).called(2);
  });
}

// A client holding [scheduledMessages], all loaded unless [hasLoadedAll] is
// false. Later lists come from [updates].
MockClient _client({
  List<ScheduledMessage> scheduledMessages = const [],
  bool hasLoadedAll = true,
  Stream<List<ScheduledMessage>> updates = const Stream.empty(),
}) {
  final client = MockClient();
  final clientState = MockClientState();
  final state = ScheduledMessageListState(
    scheduledMessages: scheduledMessages,
    hasLoadedAll: hasLoadedAll,
  );

  when(() => client.state).thenReturn(clientState);
  when(() => client.logger).thenReturn(Logger.detached('test'));
  when(client.loadScheduledMessages).thenAnswer((_) async => state);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'current-user-id'));
  when(() => clientState.channels).thenReturn({});
  when(() => clientState.scheduledMessageListState).thenReturn(state);
  when(() => clientState.scheduledMessages).thenReturn(scheduledMessages);
  when(() => clientState.scheduledMessagesStream).thenAnswer((_) => updates);

  return client;
}

ScheduledMessage _first() {
  return _scheduledMessage('first', text: 'Message from the scheduled list');
}

ScheduledMessage _reply() {
  return _scheduledMessage('reply', text: 'In the thread', parentId: 'parent');
}

ScheduledMessage _other() {
  return _scheduledMessage('other', text: 'In another channel', cid: 'messaging:other');
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
