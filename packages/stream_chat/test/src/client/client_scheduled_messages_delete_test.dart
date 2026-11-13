import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'scheduled_messages_harness.dart';

void main() {
  final harness = useScheduledMessageClient();

  final original = fakeScheduledMessage('a');
  final refused = StreamChatNetworkError.raw(code: 4, message: 'Not allowed', statusCode: 400);
  final sendingError = StreamChatNetworkError.raw(
    code: scheduledMessageSendingCode,
    message: 'Sending',
    statusCode: 409,
  );

  void stubDelete(Future<DeleteScheduledMessageResponse> Function() answer) {
    when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) => answer());
  }

  Future<List<(String, ScheduledMessageStatus?)>> delete() async {
    await harness.hold([original]);
    return harness.eventsDuring(() => harness.client.deleteScheduledMessage(original));
  }

  test('deleteScheduledMessage stops listing it right away', () async {
    final answer = Completer<DeleteScheduledMessageResponse>();
    stubDelete(() => answer.future);
    await harness.hold([original]);

    harness.client.deleteScheduledMessage(original).ignore();
    await settle();

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('deleteScheduledMessage reports it deleted once, before the server answers', () async {
    // The server's copy isn't reported again.
    final deleted = original.copyWith(status: ScheduledMessageStatus.failed);
    stubDelete(() async => fakeDelete(deleted));

    expect(await delete(), [
      (EventType.scheduledMessageDeleted, ScheduledMessageStatus.canceled),
    ]);
    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('deleteScheduledMessage lists it again when the server is unreachable', () async {
    stubDelete(() async => throw offline);

    expect(await delete(), [
      (EventType.scheduledMessageDeleted, ScheduledMessageStatus.canceled),
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.scheduled),
    ]);
    expect(harness.client.state.scheduledMessages, [original]);
  });

  test('deleteScheduledMessage lists it again when the server refuses', () async {
    stubDelete(() async => throw refused);

    expect(await delete(), [
      (EventType.scheduledMessageDeleted, ScheduledMessageStatus.canceled),
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.scheduled),
    ]);
    expect(harness.client.state.scheduledMessages, [original]);
  });

  test('deleteScheduledMessage lists one being sent again, as sending', () async {
    stubDelete(() async => throw sendingError);

    expect(await delete(), [
      (EventType.scheduledMessageDeleted, ScheduledMessageStatus.canceled),
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.sending),
    ]);
  });

  test('deleteScheduledMessage keeps it unlisted and rethrows when the server no longer has it', () async {
    stubDelete(() async => throw missingError);
    await harness.hold([original]);

    await expectLater(harness.client.deleteScheduledMessage(original), throwsA(missingError));
    await settle();

    expect(harness.client.state.scheduledMessages, isEmpty);
  });
}
