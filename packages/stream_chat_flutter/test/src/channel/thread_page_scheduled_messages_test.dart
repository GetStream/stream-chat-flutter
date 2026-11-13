import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_input/stream_chat_message_input.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../message_input/schedule_message/schedule_message_harness.dart' show bannerPill;
import 'thread_page_harness.dart';

void main() {
  testWidgets('shows the scheduled messages banner above the composer', (tester) async {
    await pumpThreadPage(tester, scheduledMessages: [scheduledMessage(parentId: 'parent-id')]);

    final banner = bannerPill(tester);
    final input = tester.getRect(find.byType(StreamChatMessageInput));
    expect(find.text(DefaultTranslations.instance.scheduledRepliesCountText(count: 1)), findsOneWidget);
    expect(banner.bottom, lessThanOrEqualTo(input.top));
  });

  testWidgets('hides the scheduled messages banner while a message is edited', (tester) async {
    await pumpThreadPage(tester, scheduledMessages: [scheduledMessage(parentId: 'parent-id')]);

    composerController(tester).editMessage(
      Message(id: 'message-id', text: 'Hello', createdAt: DateTime.utc(2026, 10, 29)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(StreamScheduledMessagesBanner), findsNothing);
  });

  testWidgets('tapping View all invokes onScheduledMessagesBannerTap with the parent message', (tester) async {
    final parents = <Message?>[];
    await pumpThreadPage(
      tester,
      scheduledMessages: [scheduledMessage(parentId: 'parent-id')],
      onScheduledMessagesBannerTap: (_, _, parent) => parents.add(parent),
    );

    await tester.tap(find.text('View all'));

    expect(parents.map((it) => it?.id), ['parent-id']);
  });

  testWidgets('shows a screen snackbar above the scheduled messages banner', (tester) async {
    await pumpThreadPage(tester, scheduledMessages: [scheduledMessage(parentId: 'parent-id')]);

    final context = tester.element(find.byType(StreamMessageListView));
    StreamSnackbarMessenger.of(context).show(StreamSnackbar(message: const Text('Snackbar')));
    await tester.pumpAndSettle();

    final snackbar = tester.getRect(
      find.descendant(of: find.byType(StreamScaffold), matching: find.text('Snackbar')),
    );
    final banner = bannerPill(tester);
    expect(snackbar.bottom, lessThanOrEqualTo(banner.top));
  });
}
