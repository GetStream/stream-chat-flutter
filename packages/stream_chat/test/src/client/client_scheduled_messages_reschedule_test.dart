import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'scheduled_messages_harness.dart';

void main() {
  final harness = useScheduledMessageClient();

  final original = fakeScheduledMessage('a');
  final later = DateTime.utc(2026, 11, 3, 9);
  final moved = fakeScheduledMessage('a', scheduledAt: later, updatedAt: DateTime.utc(2026, 10, 30));
  final tooFar = StreamChatNetworkError.raw(code: 4, message: 'Too far ahead', statusCode: 400);
  final sendingError = StreamChatNetworkError.raw(
    code: scheduledMessageSendingCode,
    message: 'Sending',
    statusCode: 409,
  );

  void stubReschedule(Future<UpdateScheduledMessageResponse> Function() answer) {
    when(
      () => harness.api.scheduledMessages.updateScheduledMessage('a', scheduledAt: later),
    ).thenAnswer((_) => answer());
  }

  Future<List<(String, ScheduledMessageStatus?)>> reschedule() async {
    await harness.hold([original]);
    return harness.eventsDuring(() => harness.client.rescheduleMessage(original, scheduledAt: later));
  }

  test('rescheduleMessage reports it at its new time as updating, then the saved copy', () async {
    stubReschedule(() async => fakeUpdate(moved));

    expect(await reschedule(), [
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.scheduled),
    ]);
    expect(harness.client.state.scheduledMessages, [moved]);
  });

  test('rescheduleMessage keeps it at its new time as failed when the server is unreachable', () async {
    stubReschedule(() async => throw offline);

    expect(await reschedule(), [
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.failed),
    ]);
    final [failed] = harness.client.state.scheduledMessages;
    expect(failed.failureReason, ScheduledMessageFailureReason.updateFailed);
    expect(failed.scheduledAt, later);
  });

  test('rescheduleMessage keeps it at its new time as failed when the server refuses the move', () async {
    stubReschedule(() async => throw tooFar);

    expect(await reschedule(), [
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.failed),
    ]);
    expect(harness.client.state.scheduledMessages.single.scheduledAt, later);
  });

  test('rescheduleMessage lists one being sent at its time, as sending', () async {
    stubReschedule(() async => throw sendingError);

    expect(await reschedule(), [
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.sending),
    ]);
    expect(harness.client.state.scheduledMessages.single.scheduledAt, original.scheduledAt);
  });

  test('rescheduleMessage reports one the server no longer has as deleted', () async {
    stubReschedule(() async => throw missingError);

    expect(await reschedule(), [
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageDeleted, ScheduledMessageStatus.canceled),
    ]);
    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('rescheduleMessage to the same time replaces the copy being saved with the unchanged server copy', () async {
    when(
      () => harness.api.scheduledMessages.updateScheduledMessage('a', scheduledAt: original.scheduledAt),
    ).thenAnswer((_) async => fakeUpdate(original));
    await harness.hold([original]);

    await harness.client.rescheduleMessage(original, scheduledAt: original.scheduledAt);
    await settle();

    expect(harness.client.state.scheduledMessages.single.status, ScheduledMessageStatus.scheduled);
  });
}
