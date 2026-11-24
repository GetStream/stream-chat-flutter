import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'scheduled_messages_harness.dart';

void main() {
  final harness = useScheduledMessageClient();

  final original = fakeScheduledMessage('a');
  final edited = Message(id: 'a', text: 'Good evening');
  final saved = fakeScheduledMessage('a', text: 'Good evening', updatedAt: DateTime.utc(2026, 10, 30));
  final tooLong = StreamChatNetworkError.raw(
    code: 4,
    message: 'Message is too long',
    statusCode: 400,
    data: ErrorResponse()
      ..code = 4
      ..statusCode = 400
      ..message = 'Message is too long',
  );
  final sendingError = StreamChatNetworkError.raw(
    code: scheduledMessageSendingCode,
    message: 'Sending',
    statusCode: 409,
  );
  final conflictError = StreamChatNetworkError.raw(
    code: scheduledMessageConflictCode,
    message: 'Changed at the same time',
    statusCode: 409,
    data: ErrorResponse()
      ..code = scheduledMessageConflictCode
      ..statusCode = 409
      ..message = 'Changed at the same time',
  );

  void stubUpdate(Future<UpdateScheduledMessageResponse> Function() answer, {DateTime? scheduledAt}) {
    when(
      () => harness.api.scheduledMessages.updateScheduledMessage('a', message: edited, scheduledAt: scheduledAt),
    ).thenAnswer((_) => answer());
  }

  Future<List<ScheduledMessageStatus?>> update({Object? throws}) async {
    await harness.hold([original]);
    return harness.statusesDuring(
      () => expectRequest(harness.client.updateScheduledMessage(original.id, edited), throws),
    );
  }

  // Edits [original] with an edit the server refuses.
  Future<ScheduledMessage> editRefused() async {
    stubUpdate(() async => throw tooLong);
    await update(throws: tooLong);
    return harness.client.state.scheduledMessages.single;
  }

  // Edits [original] while the server can't be reached.
  Future<ScheduledMessage> editUnreachable() async {
    stubUpdate(() async => throw offline);
    await update(throws: offline);
    return harness.client.state.scheduledMessages.single;
  }

  test('updateScheduledMessage lists the edit as preparing, then the saved copy', () async {
    stubUpdate(() async => fakeUpdate(saved));

    expect(await update(), [
      ScheduledMessageStatus.preparingToSchedule,
      ScheduledMessageStatus.scheduled,
    ]);
    expect(harness.client.state.scheduledMessages, [saved]);
  });

  test('updateScheduledMessage lists the edit before the server answers', () async {
    final answer = Completer<UpdateScheduledMessageResponse>();
    stubUpdate(() => answer.future);
    await harness.hold([original]);

    harness.client.updateScheduledMessage(original.id, edited).ignore();
    await settle();

    final [updating] = harness.client.state.scheduledMessages;
    expect(updating.status, ScheduledMessageStatus.preparingToSchedule);
    expect(updating.message.text, 'Good evening');
  });

  test('updateScheduledMessage keeps an edit that could not reach the server as failed, to retry', () async {
    final failed = await editUnreachable();

    expect(failed.status, ScheduledMessageStatus.failed);
    expect(failed.failure, const ScheduledMessageUpdatingFailed(isRetriable: true));
    expect(failed.message.text, 'Good evening');
  });

  test('updateScheduledMessage keeps an edit the server refuses as failed, but not to retry', () async {
    stubUpdate(() async => throw tooLong);

    expect(await update(throws: tooLong), [
      ScheduledMessageStatus.preparingToSchedule,
      ScheduledMessageStatus.failed,
    ]);
    final [failed] = harness.client.state.scheduledMessages;
    expect(failed.failure, const ScheduledMessageUpdatingFailed(isRetriable: false));
    expect(failed.message.text, 'Good evening');
  });

  test('updateScheduledMessage keeps an edit stopped by a server error as failed, to retry', () async {
    final serverError = StreamChatNetworkError.raw(
      code: -1,
      message: 'Internal error',
      statusCode: 500,
      data: ErrorResponse()
        ..code = -1
        ..statusCode = 500
        ..message = 'Internal error',
    );
    stubUpdate(() async => throw serverError);

    await update(throws: serverError);

    final [failed] = harness.client.state.scheduledMessages;
    expect(failed.failure, const ScheduledMessageUpdatingFailed(isRetriable: true));
  });

  test('updateScheduledMessage keeps an edit that fails without a network error as failed, to retry', () async {
    final error = StateError('Interrupted');
    stubUpdate(() async => throw error);

    await update(throws: error);

    final [failed] = harness.client.state.scheduledMessages;
    expect(failed.failure, const ScheduledMessageUpdatingFailed(isRetriable: true));
  });

  test(
    'updateScheduledMessage keeps an edit refused without a scheduled message reason as failed, not to retry',
    () async {
      final forbidden = StreamChatNetworkError.raw(
        code: 17,
        message: 'Not allowed',
        statusCode: 403,
        data: ErrorResponse()
          ..code = 17
          ..statusCode = 403
          ..message = 'Not allowed',
      );
      stubUpdate(() async => throw forbidden);

      await update(throws: forbidden);

      final [failed] = harness.client.state.scheduledMessages;
      expect(failed.failure, const ScheduledMessageUpdatingFailed(isRetriable: false));
    },
  );

  test('updateScheduledMessage keeps the reason of a refused edit', () async {
    final tooFar = refusedWith(scheduledAtTooFarCode);
    stubUpdate(() async => throw tooFar);

    await update(throws: tooFar);

    final [failed] = harness.client.state.scheduledMessages;
    expect(
      failed.failure,
      const ScheduledMessageUpdatingFailed(
        reason: ScheduledMessageErrorReason.scheduledAtTooFar,
        isRetriable: false,
      ),
    );
  });

  test('updateScheduledMessage keeps an edit refused for a change made at the same time as failed, to retry', () async {
    stubUpdate(() async => throw conflictError);

    await update(throws: conflictError);

    final [failed] = harness.client.state.scheduledMessages;
    expect(
      failed.failure,
      const ScheduledMessageUpdatingFailed(
        reason: ScheduledMessageErrorReason.scheduledMessageConflict,
        isRetriable: true,
      ),
    );
    expect(failed.message.text, 'Good evening');
  });

  test('deleteScheduledMessage deletes one whose edit is being saved, which stays deleted once saved', () async {
    final answer = Completer<UpdateScheduledMessageResponse>();
    stubUpdate(() => answer.future);
    await harness.hold([original]);
    final request = harness.client.updateScheduledMessage(original.id, edited);
    await settle();
    when(
      () => harness.api.scheduledMessages.deleteScheduledMessage('a'),
    ).thenAnswer((_) async => fakeDelete(original.copyWith(status: ScheduledMessageStatus.canceled)));

    await harness.client.deleteScheduledMessage('a');
    answer.complete(fakeUpdate(saved));
    await request;

    verify(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).called(1);
    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('updateScheduledMessage lists one being sent as it was', () async {
    stubUpdate(() async => throw sendingError);

    expect(await update(throws: sendingError), [
      ScheduledMessageStatus.preparingToSchedule,
      ScheduledMessageStatus.scheduled,
    ]);
    expect(harness.client.state.scheduledMessages.single.message.text, 'Good morning');
  });

  test('updateScheduledMessage stops listing one the server no longer has', () async {
    stubUpdate(() async => throw missingError);

    expect(await update(throws: missingError), [
      ScheduledMessageStatus.preparingToSchedule,
      null,
    ]);
    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  group('with a failed edit', () {
    test('rescheduleMessage saves the failed edit with the new time', () async {
      final failed = await editUnreachable();
      final later = DateTime.utc(2026, 11, 3, 9);
      when(
        () => harness.api.scheduledMessages.updateScheduledMessage('a', message: edited, scheduledAt: later),
      ).thenAnswer((_) async => fakeUpdate(saved));

      await harness.client.rescheduleMessage(failed.id, scheduledAt: later);

      verify(
        () => harness.api.scheduledMessages.updateScheduledMessage('a', message: edited, scheduledAt: later),
      ).called(1);
      verifyNever(() => harness.api.scheduledMessages.updateScheduledMessage('a', scheduledAt: later));
    });

    test('resendScheduledMessage saves a failed edit again, with its message and time', () async {
      final failed = await editUnreachable();
      stubUpdate(() async => fakeUpdate(saved), scheduledAt: original.scheduledAt);

      final scheduled = await harness.client.resendScheduledMessage(failed.id);
      await settle();

      expect(scheduled, saved);
      expect(harness.client.state.scheduledMessages, [saved]);
      verify(
        () => harness.api.scheduledMessages.updateScheduledMessage(
          'a',
          message: edited,
          scheduledAt: original.scheduledAt,
        ),
      ).called(1);
      verifyNever(() => harness.api.scheduledMessages.scheduleMessage(any(), any(), any(), any()));
    });

    test('rescheduleMessage saves a refused edit with the new time', () async {
      final refused = await editRefused();
      final later = DateTime.utc(2026, 11, 3, 9);
      when(
        () => harness.api.scheduledMessages.updateScheduledMessage('a', message: edited, scheduledAt: later),
      ).thenAnswer((_) async => fakeUpdate(saved));

      await harness.client.rescheduleMessage(refused.id, scheduledAt: later);

      verify(
        () => harness.api.scheduledMessages.updateScheduledMessage('a', message: edited, scheduledAt: later),
      ).called(1);
      verifyNever(() => harness.api.scheduledMessages.updateScheduledMessage('a', scheduledAt: later));
    });

    test('resendScheduledMessage saves a refused edit again, for the server to refuse or save', () async {
      final refused = await editRefused();
      stubUpdate(() async => fakeUpdate(saved), scheduledAt: original.scheduledAt);

      final scheduled = await harness.client.resendScheduledMessage(refused.id);

      expect(scheduled, saved);
      verify(
        () => harness.api.scheduledMessages.updateScheduledMessage(
          'a',
          message: edited,
          scheduledAt: original.scheduledAt,
        ),
      ).called(1);
      verifyNever(() => harness.api.scheduledMessages.scheduleMessage(any(), any(), any(), any()));
    });

    test('deleteScheduledMessage asks the server to delete a failed edit, which it still has', () async {
      final failed = await editUnreachable();
      when(
        () => harness.api.scheduledMessages.deleteScheduledMessage('a'),
      ).thenAnswer((_) async => fakeDelete(original));

      await harness.client.deleteScheduledMessage(failed.id);

      verify(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).called(1);
      expect(harness.client.state.scheduledMessages, isEmpty);
    });

    test('deleteScheduledMessage rethrows when a failed edit is already gone', () async {
      final failed = await editUnreachable();
      when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => throw missingError);

      await expectLater(harness.client.deleteScheduledMessage(failed.id), throwsA(missingError));
    });

    test('a complete load keeps a failed edit over the copy the server had', () async {
      final failed = await editUnreachable();
      harness.stubQuery(fakePage([original]));

      await harness.client.loadScheduledMessages();

      expect(harness.client.state.scheduledMessages, [failed]);
    });

    test('a complete load keeps a refused edit over the copy the server had', () async {
      stubUpdate(() async => throw tooLong);
      await update(throws: tooLong);
      final [refused] = harness.client.state.scheduledMessages;
      harness.stubQuery(fakePage([original]));

      await harness.client.loadScheduledMessages();

      expect(harness.client.state.scheduledMessages, [refused]);
    });

    test('a complete load replaces a failed edit with a newer copy from the server', () async {
      await editUnreachable();
      harness.stubQuery(fakePage([saved]));

      await harness.client.loadScheduledMessages();

      expect(harness.client.state.scheduledMessages, [saved]);
    });

    test('a complete load drops a failed edit the server no longer has', () async {
      await editUnreachable();
      harness.stubQuery(fakePage(const []));

      await harness.client.loadScheduledMessages();

      expect(harness.client.state.scheduledMessages, isEmpty);
    });
  });

  test('updateScheduledMessage keeps the edit being saved over a server copy of the same version', () async {
    final answer = Completer<UpdateScheduledMessageResponse>();
    stubUpdate(() => answer.future);
    await harness.hold([original]);
    harness.client.updateScheduledMessage(original.id, edited).ignore();
    await settle();

    await harness.receive(EventType.scheduledMessageUpdated, original);

    expect(harness.client.state.scheduledMessages.single.status, ScheduledMessageStatus.preparingToSchedule);
  });

  test('updateScheduledMessage keeps a failed edit over a server copy of the same version', () async {
    await editUnreachable();

    await harness.receive(EventType.scheduledMessageUpdated, original);

    final [listed] = harness.client.state.scheduledMessages;
    expect(listed.failure, const ScheduledMessageUpdatingFailed(isRetriable: true));
    expect(listed.message.text, 'Good evening');
  });

  test('updateScheduledMessage replaces a failed edit with a newer server copy', () async {
    await editUnreachable();

    await harness.receive(EventType.scheduledMessageUpdated, saved);

    expect(harness.client.state.scheduledMessages, [saved]);
  });

  test('a complete load drops an edit being saved that the server no longer has', () async {
    final answer = Completer<UpdateScheduledMessageResponse>();
    stubUpdate(() => answer.future);
    await harness.hold([original]);
    harness.client.updateScheduledMessage(original.id, edited).ignore();
    await settle();
    harness.stubQuery(fakePage(const []));

    await harness.client.loadScheduledMessages();

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('a complete load keeps a new message being scheduled, which the server never had', () async {
    final local = fakeScheduledMessage('b', status: ScheduledMessageStatus.preparingToSchedule, isOnServer: false);
    await harness.hold([local]);
    harness.stubQuery(fakePage(const []));

    await harness.client.loadScheduledMessages();

    expect(harness.client.state.scheduledMessages, [local]);
  });

  test("updateScheduledMessage doesn't list it again when it was sent while the edit was saved", () async {
    final answer = Completer<UpdateScheduledMessageResponse>();
    stubUpdate(() => answer.future);
    await harness.hold([original]);
    final request = harness.client.updateScheduledMessage(original.id, edited);
    await settle();

    await harness.receive(EventType.scheduledMessageSent, original);
    answer.complete(fakeUpdate(saved));
    await request;

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test("updateScheduledMessage doesn't list it as failed when it was sent while the edit was saved", () async {
    final answer = Completer<UpdateScheduledMessageResponse>();
    stubUpdate(() => answer.future);
    await harness.hold([original]);
    final request = harness.client.updateScheduledMessage(original.id, edited);
    await settle();

    await harness.receive(EventType.scheduledMessageSent, original);
    answer.completeError(offline);
    await expectLater(request, throwsA(offline));

    expect(harness.client.state.scheduledMessages, isEmpty);
  });
}
