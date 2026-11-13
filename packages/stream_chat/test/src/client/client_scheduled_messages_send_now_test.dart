import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'scheduled_messages_harness.dart';

void main() {
  final harness = useScheduledMessageClient();

  final original = fakeScheduledMessage('a');
  final accepted = fakeScheduledMessage('a', updatedAt: DateTime.utc(2026, 10, 30));
  final refused = StreamChatNetworkError.raw(code: 4, message: 'Not allowed', statusCode: 400);
  final sendingError = StreamChatNetworkError.raw(
    code: scheduledMessageSendingCode,
    message: 'Sending',
    statusCode: 409,
  );

  void stubSendNow(Future<SendScheduledMessageNowResponse> Function() answer) {
    when(() => harness.api.scheduledMessages.sendScheduledMessageNow('a')).thenAnswer((_) => answer());
  }

  Future<List<(String, ScheduledMessageStatus?)>> sendNow() async {
    await harness.hold([original]);
    return harness.eventsDuring(() => harness.client.sendScheduledMessageNow(original.id));
  }

  test('sendScheduledMessageNow lists it as sending once the server accepts', () async {
    stubSendNow(() async => fakeSendNow(accepted));

    expect(await sendNow(), [
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.sending),
    ]);
    expect(harness.client.state.scheduledMessages.single.status, ScheduledMessageStatus.sending);
  });

  test("sendScheduledMessageNow doesn't list it again when it was sent before the server answered", () async {
    await harness.hold([original]);
    stubSendNow(() async {
      await harness.receive(EventType.scheduledMessageSent, original);
      return fakeSendNow(accepted);
    });

    await harness.client.sendScheduledMessageNow(original.id);
    await settle();

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('sendScheduledMessageNow reports nothing when the server is unreachable', () async {
    stubSendNow(() async => throw offline);

    expect(await sendNow(), isEmpty);
    expect(harness.client.state.scheduledMessages, [original]);
  });

  test('sendScheduledMessageNow reports nothing when the server refuses', () async {
    stubSendNow(() async => throw refused);

    expect(await sendNow(), isEmpty);
    expect(harness.client.state.scheduledMessages, [original]);
  });

  test('sendScheduledMessageNow lists one already being sent as sending', () async {
    stubSendNow(() async => throw sendingError);

    expect(await sendNow(), [
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.sending),
    ]);
  });

  test('sendScheduledMessageNow reports one the server no longer has as deleted', () async {
    stubSendNow(() async => throw missingError);

    expect(await sendNow(), [
      (EventType.scheduledMessageDeleted, ScheduledMessageStatus.canceled),
    ]);
    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test("sendScheduledMessageNow keeps it sending when the server's own update of that version arrives after", () async {
    stubSendNow(() async => fakeSendNow(accepted));
    await sendNow();

    await harness.receive(EventType.scheduledMessageUpdated, accepted);

    expect(harness.client.state.scheduledMessages.single.status, ScheduledMessageStatus.sending);
  });
}
