import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';
import 'channel_page_harness.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Message());
    registerFallbackValue(DateTime(2026));
  });

  void stubSchedule(MockChannel channel, Future<ScheduleMessageResponse> Function() answer) {
    when(
      () => channel.scheduleMessage(any(), scheduledAt: any(named: 'scheduledAt')),
    ).thenAnswer((_) => answer());
  }

  testWidgets('schedules the message for the picked time on a long press of send, then clears it', (tester) async {
    final channel = await pumpChannelPage(tester);
    stubSchedule(channel, () async => ScheduleMessageResponse()..message = Message());
    await _type(tester, 'Hello');
    final controller = composerController(tester);

    await _scheduleWithPreset(tester);

    final [scheduled, _] = verify(
      () => channel.scheduleMessage(captureAny(), scheduledAt: captureAny(named: 'scheduledAt')),
    ).captured;
    expect((scheduled as Message).text, 'Hello');
    expect(controller.text, isEmpty);
  });

  testWidgets('keeps the text and the mentions in the composer when scheduling is refused', (tester) async {
    final channel = await pumpChannelPage(tester);
    stubSchedule(channel, () async => throw const ScheduledMessageRefusedError(.slashCommand, 'Refused'));
    final maya = User(id: 'maya', name: 'Maya');
    await _type(tester, 'Hi @Maya');
    final controller = composerController(tester)..addMentionedUser(maya);
    await tester.pumpAndSettle();

    await _scheduleWithPreset(tester);

    expect(controller.text, 'Hi @Maya');
    expect(controller.mentionedUsers, [maya]);
    expect(find.text(DefaultTranslations.instance.scheduleCommandRefusedError), findsOneWidget);
  });

  testWidgets('says the quoted message was deleted when scheduling is refused for it', (tester) async {
    final channel = await pumpChannelPage(tester);
    stubSchedule(channel, () async => throw const ScheduledMessageRefusedError(.quotedMessageDeleted, 'Refused'));
    await _type(tester, 'Hello');

    await _scheduleWithPreset(tester);

    expect(find.text(DefaultTranslations.instance.scheduleQuotedMessageDeletedError), findsOneWidget);
  });

  testWidgets("says the message can't be scheduled when trying again won't help", (tester) async {
    final channel = await pumpChannelPage(tester);
    stubSchedule(channel, () async => throw const ScheduledMessageRefusedError(.pinExpiresTooSoon, 'Refused'));
    await _type(tester, 'Hello');

    await _scheduleWithPreset(tester);

    expect(find.text(DefaultTranslations.instance.scheduleMessageRefusedError), findsOneWidget);
  });

  testWidgets('asks to try again when the server refuses for a reason it gives no more of', (tester) async {
    final channel = await pumpChannelPage(tester);
    final refused = StreamChatNetworkError.raw(
      code: 4,
      message: 'Refused',
      statusCode: 400,
      data: ErrorResponse()
        ..code = 4
        ..statusCode = 400
        ..message = 'Refused',
    );
    stubSchedule(channel, () async => throw refused);
    await _type(tester, 'Hello');

    await _scheduleWithPreset(tester);

    expect(find.text(DefaultTranslations.instance.scheduleMessageError), findsOneWidget);
  });

  testWidgets('says why the server refused to schedule the message', (tester) async {
    final channel = await pumpChannelPage(tester);
    when(() => channel.config).thenReturn(ChannelConfig(scheduledMessagesMaxPerUser: 100));
    final limitReached = StreamChatNetworkError.raw(
      code: 118,
      message: 'Too many scheduled messages',
      statusCode: 400,
      data: ErrorResponse()
        ..code = 118
        ..statusCode = 400
        ..message = 'Too many scheduled messages',
    );
    stubSchedule(channel, () async => throw limitReached);
    await _type(tester, 'Hello');

    await _scheduleWithPreset(tester);

    expect(find.text(DefaultTranslations.instance.scheduleUserLimitReachedError(limit: 100)), findsOneWidget);
    expect(composerController(tester).text, 'Hello');
  });

  testWidgets('keeps text typed while the message is scheduled, as a new message', (tester) async {
    final channel = await pumpChannelPage(tester);
    final answer = Completer<ScheduleMessageResponse>();
    stubSchedule(channel, () => answer.future);
    await _type(tester, 'First');
    final controller = composerController(tester);
    final scheduledId = controller.value.id;

    await _scheduleWithPreset(tester);
    controller.text = 'Second';
    answer.complete(ScheduleMessageResponse()..message = Message(id: scheduledId));
    await tester.pumpAndSettle();

    expect(controller.text, 'Second');
    expect(controller.value.id, isNot(scheduledId));
  });

  testWidgets("offers no long press of send where the user can't schedule", (tester) async {
    await pumpChannelPage(tester, canSchedule: false);
    await _type(tester, 'Hello');

    expect(_sendButton(tester).props.onLongPress, isNull);
  });

  testWidgets('offers neither the long press nor the banner when scheduled messages are turned off', (tester) async {
    await pumpChannelPage(
      tester,
      scheduledMessages: [scheduledMessage()],
      configData: StreamChatConfigurationData(scheduledMessagesEnabled: false),
    );
    await _type(tester, 'Hello');

    expect(_sendButton(tester).props.onLongPress, isNull);
    expect(find.byType(StreamScheduledMessagesBanner), findsNothing);
  });
}

Future<void> _type(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(EditableText), text);
  await tester.pumpAndSettle();
}

StreamButton _sendButton(WidgetTester tester) {
  return tester.widget<StreamButton>(find.byKey(const ValueKey('send_key')));
}

// Long-presses send, and picks the first preset of the schedule sheet.
Future<void> _scheduleWithPreset(WidgetTester tester) async {
  _sendButton(tester).props.onLongPress!();
  await tester.pumpAndSettle();

  await tester.tap(find.textContaining('Tomorrow').first);
  await tester.pumpAndSettle();
}
