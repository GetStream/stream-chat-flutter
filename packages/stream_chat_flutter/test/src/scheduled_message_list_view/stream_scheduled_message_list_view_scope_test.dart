import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'scheduled_message_list_view_harness.dart';

void main() {
  testWidgets("StreamScheduledMessageListView lists every channel's scheduled messages without a channel", (
    tester,
  ) async {
    final client = mockClient(scheduledMessages: [first(), other()]);

    await tester.pumpWidget(wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    expect(find.byType(StreamScheduledMessageListItem), findsNWidgets(2));
    expect(find.textContaining('Message from the scheduled list', findRichText: true), findsOneWidget);
    expect(find.textContaining('In another channel', findRichText: true), findsOneWidget);
  });

  testWidgets("StreamScheduledMessageListView lists only the channel's scheduled messages when given a channel", (
    tester,
  ) async {
    final client = mockClient(scheduledMessages: [first(), _reply(), other()]);

    await tester.pumpWidget(
      wrapWithMaterialApp(
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
    final client = mockClient(scheduledMessages: [first(), _reply(), other()]);

    await tester.pumpWidget(
      wrapWithMaterialApp(
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
    final client = mockClient(scheduledMessages: [first(), _reply(), other()]);

    await tester.pumpWidget(
      wrapWithMaterialApp(
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
    final client = mockClient(scheduledMessages: [first()], updates: updates.stream);
    await tester.pumpWidget(wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    updates.add([first(), other()]);
    await tester.pump();

    expect(find.byType(StreamScheduledMessageListItem), findsNWidgets(2));
  });

  testWidgets("StreamScheduledMessageListView lists another channel's scheduled messages when the channel changes", (
    tester,
  ) async {
    final client = mockClient(scheduledMessages: [first(), other()]);
    var cid = 'messaging:general';
    late StateSetter setParentState;
    await tester.pumpWidget(
      wrapWithMaterialApp(
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
    final otherReply = fakeScheduledMessage('other-reply', text: 'In the second thread', parentId: 'other');
    final client = mockClient(scheduledMessages: [_reply(), otherReply]);
    var parentId = 'parent';
    late StateSetter setParentState;
    await tester.pumpWidget(
      wrapWithMaterialApp(
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
}

ScheduledMessage _reply() {
  return fakeScheduledMessage('reply', text: 'In the thread', parentId: 'parent');
}
