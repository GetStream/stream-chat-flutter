import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'scheduled_messages_harness.dart';

void main() {
  final harness = useScheduledMessageClient();

  final original = fakeScheduledMessage('a');
  final later = DateTime.utc(2026, 11, 3, 9);
  final moved = fakeScheduledMessage('a', scheduledAt: later, updatedAt: DateTime.utc(2026, 10, 30));
  final tooFar = StreamChatNetworkError.raw(
    code: 4,
    message: 'Too far ahead',
    statusCode: 400,
    data: ErrorResponse()
      ..code = 4
      ..statusCode = 400
      ..message = 'Too far ahead',
  );
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

  Future<List<ScheduledMessageStatus?>> reschedule({Object? throws}) async {
    await harness.hold([original]);
    return harness.statusesDuring(
      () => expectRequest(harness.client.rescheduleMessage(original.id, scheduledAt: later), throws),
    );
  }

  test('rescheduleMessage lists it at its new time as preparing, then the saved copy', () async {
    stubReschedule(() async => fakeUpdate(moved));

    expect(await reschedule(), [
      ScheduledMessageStatus.preparingToSchedule,
      ScheduledMessageStatus.scheduled,
    ]);
    expect(harness.client.state.scheduledMessages, [moved]);
  });

  test('rescheduleMessage keeps it at its new time as failed when the server is unreachable', () async {
    stubReschedule(() async => throw offline);

    expect(await reschedule(throws: offline), [
      ScheduledMessageStatus.preparingToSchedule,
      ScheduledMessageStatus.failed,
    ]);
    final [failed] = harness.client.state.scheduledMessages;
    expect(failed.failure, const ScheduledMessageUpdatingFailed(isRetriable: true));
    expect(failed.scheduledAt, later);
  });

  test('rescheduleMessage keeps it at its new time as failed when the server refuses the move', () async {
    stubReschedule(() async => throw tooFar);

    expect(await reschedule(throws: tooFar), [
      ScheduledMessageStatus.preparingToSchedule,
      ScheduledMessageStatus.failed,
    ]);
    final [failed] = harness.client.state.scheduledMessages;
    expect(failed.failure, const ScheduledMessageUpdatingFailed(isRetriable: false));
    expect(failed.scheduledAt, later);
  });

  test('rescheduleMessage lists one being sent as it was, at its time', () async {
    stubReschedule(() async => throw sendingError);

    expect(await reschedule(throws: sendingError), [
      ScheduledMessageStatus.preparingToSchedule,
      ScheduledMessageStatus.scheduled,
    ]);
    expect(harness.client.state.scheduledMessages.single.scheduledAt, original.scheduledAt);
  });

  test('rescheduleMessage stops listing one the server no longer has', () async {
    stubReschedule(() async => throw missingError);

    expect(await reschedule(throws: missingError), [
      ScheduledMessageStatus.preparingToSchedule,
      null,
    ]);
    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('rescheduleMessage to the same time replaces the copy being saved with the unchanged server copy', () async {
    when(
      () => harness.api.scheduledMessages.updateScheduledMessage('a', scheduledAt: original.scheduledAt),
    ).thenAnswer((_) async => fakeUpdate(original));
    await harness.hold([original]);

    await harness.client.rescheduleMessage(original.id, scheduledAt: original.scheduledAt);

    expect(harness.client.state.scheduledMessages.single.status, ScheduledMessageStatus.scheduled);
  });
}
