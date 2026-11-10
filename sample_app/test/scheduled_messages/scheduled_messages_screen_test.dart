import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_app/scheduled_messages/screens/scheduled_messages_screen.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'scheduled_messages_harness.dart';

void main() {
  setUpAll(() => registerFallbackValue(fakeScheduledMessage('fallback')));

  testWidgets('tapping one being sent opens nothing', (tester) async {
    final scheduledMessage = fakeScheduledMessage('a', text: '#sending', status: .sending);
    await pumpScheduledMessages(
      tester,
      const ScheduledMessagesPage(),
      client: fakeClient(scheduledMessages: [scheduledMessage]),
    );

    await tester.tap(find.textContaining('#sending', findRichText: true));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(StreamListTile), findsNothing);
  });

  testWidgets('tapping a scheduled one shows its actions', (tester) async {
    final scheduledMessage = fakeScheduledMessage('a', text: '#scheduled');
    await pumpScheduledMessages(
      tester,
      const ScheduledMessagesPage(),
      client: fakeClient(scheduledMessages: [scheduledMessage]),
    );

    await tester.tap(find.textContaining('#scheduled', findRichText: true));
    await tester.pumpAndSettle();

    expect(find.text('Reschedule'), findsOneWidget);
  });

  testWidgets('deleting one that was already sent says so', (tester) async {
    final scheduledMessage = fakeScheduledMessage('a', text: '#sent');
    final client = fakeClient(scheduledMessages: [scheduledMessage]);
    final gone = StreamChatNetworkError.raw(code: 16, statusCode: 404, message: 'Not found');
    when(() => client.deleteScheduledMessage(any())).thenAnswer((_) async => throw gone);
    await pumpScheduledMessages(tester, const ScheduledMessagesPage(), client: client);
    await tester.tap(find.textContaining('#sent', findRichText: true));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete').last);
    await tester.pump();

    expect(find.text("Already sent. It's in the channel now."), findsOneWidget);
  });
}
