import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'scheduled_message_list_view_harness.dart';

void main() {
  testWidgets('StreamScheduledMessageListView calls onScheduledMessageTap with the tapped scheduled message', (
    tester,
  ) async {
    final client = mockClient(scheduledMessages: [first(), other()]);
    final tapped = <ScheduledMessage>[];
    await tester.pumpWidget(
      wrapWithMaterialApp(
        client: client,
        child: StreamScheduledMessageListView(onScheduledMessageTap: tapped.add),
      ),
    );

    await tester.tap(find.byType(StreamScheduledMessageListItem).first);

    expect(tapped, [first()]);
  });

  testWidgets(
    'StreamScheduledMessageListView calls onScheduledMessageLongPress with the long-pressed scheduled message',
    (tester) async {
      final client = mockClient(scheduledMessages: [first(), other()]);
      final longPressed = <ScheduledMessage>[];
      await tester.pumpWidget(
        wrapWithMaterialApp(
          client: client,
          child: StreamScheduledMessageListView(onScheduledMessageLongPress: longPressed.add),
        ),
      );

      await tester.longPress(find.byType(StreamScheduledMessageListItem).last);

      expect(longPressed, [other()]);
    },
  );

  testWidgets('StreamScheduledMessageListView honors per-instance itemBuilder override', (tester) async {
    final client = mockClient(scheduledMessages: [first(), other()]);

    await tester.pumpWidget(
      wrapWithMaterialApp(
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
    final client = mockClient(scheduledMessages: [first(), other()]);

    await tester.pumpWidget(
      wrapWithMaterialApp(
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
    final updates = CountingStream();
    addTearDown(updates.close);
    final client = mockClient(scheduledMessages: [first()], updates: updates.stream);
    late StateSetter setParentState;

    await tester.pumpWidget(
      wrapWithMaterialApp(
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
    final client = mockClient(hasLoadedAll: false);
    late StateSetter setParentState;

    await tester.pumpWidget(
      wrapWithMaterialApp(
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

  testWidgets('StreamScheduledMessageListView stops listening once disposed', (tester) async {
    final updates = CountingStream();
    addTearDown(updates.close);
    final client = mockClient(scheduledMessages: [first()], updates: updates.stream);
    await tester.pumpWidget(wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    await tester.pumpWidget(const SizedBox.shrink());

    expect(updates.hasListener, isFalse);
  });
}
