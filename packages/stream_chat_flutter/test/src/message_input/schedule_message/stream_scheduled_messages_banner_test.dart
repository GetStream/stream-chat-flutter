import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'schedule_message_harness.dart';

void main() {
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> StreamScheduledMessagesBanner looks fine',
      fileName: 'stream_scheduled_messages_banner_scheduled_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 412, height: 80),
      builder: () => wrapWithMaterialApp(
        StreamScheduledMessagesBanner(onTap: () {}),
        channel: scheduleChannel(scheduledMessages: [scheduledMessage('a'), scheduledMessage('b')]),
        brightness: brightness,
      ),
    );

    goldenTest(
      '[${brightness.name}] -> StreamScheduledMessagesBanner with failed messages looks fine',
      fileName: 'stream_scheduled_messages_banner_failed_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 412, height: 80),
      builder: () => wrapWithMaterialApp(
        StreamScheduledMessagesBanner(onTap: () {}),
        channel: scheduleChannel(scheduledMessages: [scheduledMessage('a', status: ScheduledMessageStatus.failed)]),
        brightness: brightness,
      ),
    );
  }

  testWidgets('StreamScheduledMessagesBanner is empty without scheduled messages', (tester) async {
    await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessagesBanner(), channel: scheduleChannel()));
    await tester.pumpAndSettle();

    expect(find.byType(Text), findsNothing);
  });

  testWidgets("StreamScheduledMessagesBanner counts the channel's scheduled messages", (tester) async {
    final channel = scheduleChannel(
      scheduledMessages: [scheduledMessage('a'), scheduledMessage('b')],
    );

    await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessagesBanner(), channel: channel));
    await tester.pumpAndSettle();

    expect(find.text('2 scheduled messages'), findsOneWidget);
  });

  testWidgets("StreamScheduledMessagesBanner counts a thread's scheduled replies", (tester) async {
    final channel = scheduleChannel(
      scheduledMessages: [
        scheduledMessage('a'),
        scheduledMessage('b'),
        scheduledMessage('reply', parentId: 'parent'),
      ],
    );

    await tester.pumpWidget(
      wrapWithMaterialApp(StreamScheduledMessagesBanner(parentId: 'parent'), channel: channel),
    );
    await tester.pumpAndSettle();

    expect(find.text('1 scheduled reply'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessagesBanner shows the failed count instead of the scheduled count', (tester) async {
    final channel = scheduleChannel(
      scheduledMessages: [
        scheduledMessage('a'),
        scheduledMessage('b', status: ScheduledMessageStatus.failed),
      ],
    );

    await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessagesBanner(), channel: channel));
    await tester.pumpAndSettle();

    expect(find.text('1 failed to send'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessagesBanner shows the count out of the limit once the channel reaches it', (
    tester,
  ) async {
    final channel = scheduleChannel(
      config: ChannelConfig(scheduledMessagesMaxPerChannel: 2),
      scheduledMessages: [scheduledMessage('a'), scheduledMessage('b')],
    );

    await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessagesBanner(), channel: channel));
    await tester.pumpAndSettle();

    expect(find.text('2 of 2 scheduled messages'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessagesBanner counts thread replies toward the limit', (tester) async {
    final topLevel = [for (var i = 0; i < 8; i++) scheduledMessage('m$i')];
    final replies = [
      scheduledMessage('r0', parentId: 'parent'),
      scheduledMessage('r1', parentId: 'parent'),
    ];
    final channel = scheduleChannel(
      config: ChannelConfig(scheduledMessagesMaxPerChannel: 10),
      scheduledMessages: [...topLevel, ...replies],
    );

    await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessagesBanner(), channel: channel));
    await tester.pumpAndSettle();

    expect(find.text('10 of 10 scheduled messages'), findsOneWidget);
  });

  testWidgets("StreamScheduledMessagesBanner hides pending ones when the channel can't schedule", (tester) async {
    final channel = scheduleChannel(
      canSchedule: false,
      scheduledMessages: [scheduledMessage('a')],
    );

    await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessagesBanner(), channel: channel));
    await tester.pumpAndSettle();

    expect(find.byType(Text), findsNothing);
  });

  testWidgets("StreamScheduledMessagesBanner shows nothing when the channel can't schedule, failed ones included", (
    tester,
  ) async {
    final channel = scheduleChannel(
      canSchedule: false,
      scheduledMessages: [
        scheduledMessage('a'),
        scheduledMessage('b', status: ScheduledMessageStatus.failed),
      ],
    );

    await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessagesBanner(), channel: channel));
    await tester.pumpAndSettle();

    expect(find.byType(Text), findsNothing);
  });

  testWidgets("StreamScheduledMessagesBanner shows nothing for a channel that isn't created yet", (tester) async {
    final channel = scheduleChannel(isCreated: false, scheduledMessages: [scheduledMessage('a')]);

    await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessagesBanner(), channel: channel));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(Text), findsNothing);
  });

  testWidgets("StreamScheduledMessagesBanner names when the channel's only scheduled message is sent", (tester) async {
    final only = scheduledMessage('a');
    final channel = scheduleChannel(scheduledMessages: [only]);

    await tester.pumpWidget(
      wrapWithMaterialApp(StreamScheduledMessagesBanner(onTap: () {}), channel: channel),
    );
    await tester.pumpAndSettle();

    final label = DefaultTranslations.instance.scheduledMessageScheduledForText(scheduledAt: only.scheduledAt);
    expect(find.text(label), findsOne);
  });

  testWidgets("StreamScheduledMessagesBanner links to the channel's only scheduled message as View", (tester) async {
    final channel = scheduleChannel(scheduledMessages: [scheduledMessage('a')]);

    await tester.pumpWidget(
      wrapWithMaterialApp(StreamScheduledMessagesBanner(onTap: () {}), channel: channel),
    );
    await tester.pumpAndSettle();

    expect(find.text('View'), findsOneWidget);
  });
}
