import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'thread_page_harness.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Message());
    registerFallbackValue(DateTime(2026));
  });

  testWidgets('schedules a reply in the thread on a long press of send', (tester) async {
    final channel = await pumpThreadPage(tester);
    when(
      () => channel.scheduleMessage(any(), scheduledAt: any(named: 'scheduledAt')),
    ).thenAnswer((_) async => ScheduleMessageResponse()..message = Message());
    await tester.enterText(find.byType(EditableText), 'Hello');
    await tester.pumpAndSettle();

    _sendButton(tester).props.onLongPress!();
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Tomorrow').first);
    await tester.pumpAndSettle();

    final [scheduled, _] = verify(
      () => channel.scheduleMessage(captureAny(), scheduledAt: captureAny(named: 'scheduledAt')),
    ).captured;
    expect((scheduled as Message).parentId, 'parent-id');
  });

  testWidgets('offers no long press of send when scheduled messages are turned off', (tester) async {
    await pumpThreadPage(tester, configData: StreamChatConfigurationData(scheduledMessagesEnabled: false));
    await tester.enterText(find.byType(EditableText), 'Hello');
    await tester.pumpAndSettle();

    expect(_sendButton(tester).props.onLongPress, isNull);
  });
}

StreamButton _sendButton(WidgetTester tester) {
  return tester.widget<StreamButton>(find.byKey(const ValueKey('send_key')));
}
