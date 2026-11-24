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

  Future<List<ScheduledMessageStatus?>> sendNow({Object? throws}) async {
    await harness.hold([original]);
    return harness.statusesDuring(() => expectRequest(harness.client.sendScheduledMessageNow(original.id), throws));
  }

  test('sendScheduledMessageNow lists it as preparing while the request runs, then as the server answers', () async {
    stubSendNow(() async => fakeSendNow(accepted));

    expect(await sendNow(), [
      ScheduledMessageStatus.preparingToSchedule,
      ScheduledMessageStatus.scheduled,
    ]);
    expect(harness.client.state.scheduledMessages, [accepted]);
  });

  test('sendScheduledMessageNow lists the server copy of the version it had over the one being prepared', () async {
    stubSendNow(() async => fakeSendNow(original));

    await sendNow();

    final [listed] = harness.client.state.scheduledMessages;
    expect(listed.status, ScheduledMessageStatus.scheduled);
    expect(listed.updatedAt, original.updatedAt);
  });

  test("sendScheduledMessageNow doesn't list it again when it was sent before the server answered", () async {
    await harness.hold([original]);
    stubSendNow(() async {
      await harness.receive(EventType.scheduledMessageSent, original);
      return fakeSendNow(accepted);
    });

    await harness.client.sendScheduledMessageNow(original.id);

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('sendScheduledMessageNow lists it as it was when the server is unreachable', () async {
    stubSendNow(() async => throw offline);

    expect(await sendNow(throws: offline), [
      ScheduledMessageStatus.preparingToSchedule,
      ScheduledMessageStatus.scheduled,
    ]);
    expect(harness.client.state.scheduledMessages.single.updatedAt, original.updatedAt);
  });

  test('sendScheduledMessageNow lists it as it was when the server refuses', () async {
    stubSendNow(() async => throw refused);

    expect(await sendNow(throws: refused), [
      ScheduledMessageStatus.preparingToSchedule,
      ScheduledMessageStatus.scheduled,
    ]);
  });

  test('sendScheduledMessageNow lists one already being sent as it was, until its own events', () async {
    stubSendNow(() async => throw sendingError);

    expect(await sendNow(throws: sendingError), [
      ScheduledMessageStatus.preparingToSchedule,
      ScheduledMessageStatus.scheduled,
    ]);
  });

  test('sendScheduledMessageNow stops listing one the server no longer has', () async {
    stubSendNow(() async => throw missingError);

    expect(await sendNow(throws: missingError), [
      ScheduledMessageStatus.preparingToSchedule,
      null,
    ]);
    expect(harness.client.state.scheduledMessages, isEmpty);
  });
}
