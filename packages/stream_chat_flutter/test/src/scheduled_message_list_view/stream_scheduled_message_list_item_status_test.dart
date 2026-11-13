import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'scheduled_message_list_item_harness.dart';

void main() {
  testWidgets('StreamScheduledMessageListItem shows nothing under the preview while it waits for its time', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: fakeScheduledMessage())),
    );

    expect(find.byType(StreamLoadingSpinner), findsNothing);
    expect(find.text('Sending…'), findsNothing);
  });

  testWidgets('StreamScheduledMessageListItem shows nothing under the preview while an edit of it is saved', (
    tester,
  ) async {
    // Already scheduled, so it has a server creation time.
    final saving = fakeScheduledMessage(
      status: ScheduledMessageStatus.preparingToSchedule,
      createdAt: DateTime.utc(2026, 10, 20),
    );

    await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: saving)));

    expect(find.byType(StreamLoadingSpinner), findsNothing);
    expect(find.text('Sending…'), findsNothing);
    expect(find.text('Uploading…'), findsNothing);
  });

  testWidgets('StreamScheduledMessageListItem says it is sending while it is being sent', (tester) async {
    final sending = fakeScheduledMessage(status: ScheduledMessageStatus.sending);

    await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: sending)));

    expect(find.byType(StreamLoadingSpinner), findsOneWidget);
    expect(find.text('Sending…'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListItem says it is sending while a new message is scheduled', (tester) async {
    final scheduling = fakeScheduledMessage(status: ScheduledMessageStatus.preparingToSchedule);

    await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: scheduling)));

    expect(find.byType(StreamLoadingSpinner), findsOneWidget);
    expect(find.text('Sending…'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListItem says it is uploading while its attachments upload', (tester) async {
    await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: uploading())));

    expect(find.text('Uploading…'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListItem says why it could not be sent', (tester) async {
    await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: failed())));

    expect(find.text('This channel now needs approval. Schedule it again.'), findsOneWidget);
  });

  testWidgets(
    'StreamScheduledMessageListItem says the quoted message was deleted when an invalid message quotes a deleted one',
    (tester) async {
      final quoted = Message(id: 'quoted', text: 'Ready?', type: MessageType.deleted);
      final invalid = fakeScheduledMessage(
        status: ScheduledMessageStatus.failed,
        failureReason: ScheduledMessageFailureReason.invalidMessage,
        quotedMessage: quoted,
      );

      await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: invalid)));

      expect(find.text('The quoted message was deleted. Edit it to remove the quote.'), findsOneWidget);
    },
  );

  testWidgets('StreamScheduledMessageListItem dims the scheduled time of one that could not be sent', (tester) async {
    await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: failed())));

    final colorScheme = tester.element(find.byType(StreamScheduledMessageListItem)).streamColorScheme;
    final scheduledAt = tester.widget<Text>(find.text('Send Wed, Oct 21 at 8:00\u202fAM'));
    expect(scheduledAt.style?.color, colorScheme.textDisabled);
  });

  testWidgets('StreamScheduledMessageListItem tints the background when selected', (tester) async {
    await tester.pumpWidget(
      wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: fakeScheduledMessage(), selected: true)),
    );

    final colorScheme = tester.element(find.byType(StreamScheduledMessageListItem)).streamColorScheme;
    expect(_itemBackground(tester), Color.alphaBlend(colorScheme.backgroundSelected, colorScheme.backgroundApp));
  });

  testWidgets('StreamScheduledMessageListItem uses the background color of its theme', (tester) async {
    await tester.pumpWidget(
      wrapWithMaterialApp(
        StreamScheduledMessageListItemTheme(
          data: const StreamScheduledMessageListItemThemeData(backgroundColor: WidgetStatePropertyAll(Colors.red)),
          child: StreamScheduledMessageListItem(scheduledMessage: fakeScheduledMessage()),
        ),
      ),
    );

    expect(_itemBackground(tester), Colors.red);
  });
}

Color? _itemBackground(WidgetTester tester) {
  final ink = tester.widget<Ink>(
    find.descendant(of: find.byType(StreamScheduledMessageListItem), matching: find.byType(Ink)).first,
  );
  return (ink.decoration! as ShapeDecoration).color;
}
