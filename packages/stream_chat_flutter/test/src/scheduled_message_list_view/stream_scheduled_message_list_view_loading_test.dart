import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'scheduled_message_list_view_harness.dart';

void main() {
  testWidgets('StreamScheduledMessageListView loads the scheduled messages when they are not all loaded', (
    tester,
  ) async {
    final client = mockClient(hasLoadedAll: false);

    await tester.pumpWidget(wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    verify(client.loadScheduledMessages).called(1);
  });

  testWidgets('StreamScheduledMessageListView does not load the scheduled messages when they are all loaded', (
    tester,
  ) async {
    final client = mockClient(scheduledMessages: [first()]);

    await tester.pumpWidget(wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    verifyNever(client.loadScheduledMessages);
  });

  testWidgets('StreamScheduledMessageListView shows loading rows while the scheduled messages load', (tester) async {
    final client = mockClient(hasLoadedAll: false);
    final load = Completer<ScheduledMessageListState>();
    when(client.loadScheduledMessages).thenAnswer((_) => load.future);

    await tester.pumpWidget(wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    expect(find.byType(StreamSkeletonLoading), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListView shows the scheduled messages it already holds while loading', (
    tester,
  ) async {
    final client = mockClient(scheduledMessages: [first()], hasLoadedAll: false);
    final load = Completer<ScheduledMessageListState>();
    when(client.loadScheduledMessages).thenAnswer((_) => load.future);

    await tester.pumpWidget(wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    expect(find.byType(StreamScheduledMessageListItem), findsOneWidget);
    expect(find.byType(StreamSkeletonLoading), findsNothing);
  });

  testWidgets('StreamScheduledMessageListView says there are none when the list is empty', (tester) async {
    final client = mockClient();

    await tester.pumpWidget(wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));

    expect(find.text('No scheduled messages'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListView says there are none once a load finds nothing', (tester) async {
    final client = mockClient(hasLoadedAll: false);

    await tester.pumpWidget(wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));
    await tester.pump();

    expect(find.text('No scheduled messages'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListView says the scheduled messages could not be loaded', (tester) async {
    final client = mockClient(hasLoadedAll: false);
    when(client.loadScheduledMessages).thenAnswer((_) async => throw const StreamChatError('Boom'));

    await tester.pumpWidget(wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));
    await tester.pump();

    expect(find.text("Couldn't load scheduled messages"), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListView hands errorBuilder a StreamChatError for any failure', (tester) async {
    final client = mockClient(hasLoadedAll: false);
    when(client.loadScheduledMessages).thenAnswer((_) async => throw StateError('Boom'));

    await tester.pumpWidget(
      wrapWithMaterialApp(
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
    final client = mockClient(hasLoadedAll: false);
    when(client.loadScheduledMessages).thenAnswer((_) async => throw const StreamChatError('Boom'));
    await tester.pumpWidget(wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));
    await tester.pump();

    await tester.tap(find.text('Try Again'));
    await tester.pump();

    verify(client.loadScheduledMessages).called(2);
  });

  testWidgets("StreamScheduledMessageListView doesn't resubscribe when retry is tapped", (tester) async {
    final updates = CountingStream();
    addTearDown(updates.close);
    final client = mockClient(hasLoadedAll: false, updates: updates.stream);
    when(client.loadScheduledMessages).thenAnswer((_) async => throw const StreamChatError('Boom'));
    await tester.pumpWidget(wrapWithMaterialApp(client: client, child: const StreamScheduledMessageListView()));
    await tester.pump();

    await tester.tap(find.text('Try Again'));
    await tester.pump();

    expect(updates.listens, 1);
  });
}
