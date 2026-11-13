import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_input/stream_chat_message_input.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../message_input/schedule_message/schedule_message_harness.dart' show bannerPill;
import 'channel_page_harness.dart';

void main() {
  testWidgets('shows the scheduled messages banner above the composer', (tester) async {
    await pumpChannelPage(tester, scheduledMessages: [scheduledMessage()]);

    final banner = bannerPill(tester);
    final input = tester.getRect(find.byType(StreamChatMessageInput));
    expect(find.text(_scheduledForLabel), findsOneWidget);
    expect(banner.bottom, lessThanOrEqualTo(input.top));
  });

  testWidgets('adds no space above the composer without scheduled messages', (tester) async {
    await pumpChannelPage(tester);

    final list = tester.getRect(find.byType(StreamMessageListView));
    final composer = tester.getRect(find.byType(StreamMessageComposer));
    expect(composer.top, list.bottom);
  });

  testWidgets('hides the scheduled messages banner while a message is edited', (tester) async {
    await pumpChannelPage(tester, scheduledMessages: [scheduledMessage()]);

    composerController(tester).editMessage(
      Message(id: 'message-id', text: 'Hello', createdAt: DateTime.utc(2026, 10, 29)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(StreamScheduledMessagesBanner), findsNothing);
  });

  testWidgets("tapping the banner's link invokes onScheduledMessagesBannerTap with no parent", (tester) async {
    final parents = <Message?>[];
    await pumpChannelPage(
      tester,
      scheduledMessages: [scheduledMessage()],
      onScheduledMessagesBannerTap: (_, _, parent) => parents.add(parent),
    );

    await tester.tap(find.text('View'));

    expect(parents, [null]);
  });

  testWidgets('shows a screen snackbar above the scheduled messages banner', (tester) async {
    await pumpChannelPage(tester, scheduledMessages: [scheduledMessage()]);

    final context = tester.element(find.byType(StreamMessageListView));
    StreamSnackbarMessenger.of(context).show(StreamSnackbar(message: const Text('Snackbar')));
    await tester.pumpAndSettle();

    final snackbar = tester.getRect(
      find.descendant(of: find.byType(StreamScaffold), matching: find.text('Snackbar')),
    );
    final banner = bannerPill(tester);
    expect(snackbar.bottom, lessThanOrEqualTo(banner.top));
  });

  testWidgets("doesn't resubscribe to the scheduled messages while typing", (tester) async {
    final scheduledMessages = [scheduledMessage()];
    var listens = 0;
    final stream = Stream<List<ScheduledMessage>>.multi((controller) {
      listens += 1;
      controller.add(scheduledMessages);
    });
    await pumpChannelPage(tester, scheduledMessages: scheduledMessages, scheduledMessagesStream: stream);
    final listensBeforeTyping = listens;

    await tester.enterText(find.byType(EditableText), 'Hello');
    await tester.pumpAndSettle();

    expect(listens, listensBeforeTyping);
  });

  testWidgets("doesn't rebuild the scheduled messages banner while typing", (tester) async {
    await pumpChannelPage(tester, scheduledMessages: [scheduledMessage()]);
    final countBefore = tester.widget<Text>(find.text(_scheduledForLabel));

    await tester.enterText(find.byType(EditableText), 'Hello');
    await tester.pumpAndSettle();

    // A rebuild would create a new Text.
    expect(tester.widget<Text>(find.text(_scheduledForLabel)), same(countBefore));
  });

  testWidgets('passes onScheduledMessagesBannerTap to the thread pages it opens', (tester) async {
    void onTap(BuildContext context, Channel channel, Message? parent) {}
    final parentMessage = Message(id: 'parent-id', text: 'Hello world!');

    await pumpChannelPage(tester, onScheduledMessagesBannerTap: onTap);
    final context = tester.element(find.byType(StreamMessageListView));
    final thread = messageListView(tester).threadBuilder!(context, parentMessage);

    expect(
      thread,
      isA<StreamThreadPage>().having(
        (it) => it.onScheduledMessagesBannerTap,
        'onScheduledMessagesBannerTap',
        onTap,
      ),
    );
  });
}

// The banner's label for the channel's only scheduled message.
final _scheduledForLabel = DefaultTranslations.instance.scheduledMessageScheduledForText(
  scheduledAt: scheduledMessage().scheduledAt,
);
