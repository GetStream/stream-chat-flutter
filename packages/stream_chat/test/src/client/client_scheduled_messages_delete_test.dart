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

  Future<List<ScheduledMessageStatus?>> delete({Object? throws}) async {
    await harness.hold([original]);
    return harness.statusesDuring(() => expectRequest(harness.client.deleteScheduledMessage(original.id), throws));
  }

  test('deleteScheduledMessage stops listing it right away', () async {
    final answer = Completer<DeleteScheduledMessageResponse>();
    stubDelete(() => answer.future);
    await harness.hold([original]);

    harness.client.deleteScheduledMessage(original.id).ignore();
    await settle();

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('deleteScheduledMessage stops listing it once, before the server answers', () async {
    // The server's copy isn't reported again.
    final deleted = original.copyWith(status: ScheduledMessageStatus.failed);
    stubDelete(() async => fakeDelete(deleted));

    expect(await delete(), [
      null,
    ]);
    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('deleteScheduledMessage lists it again when the server is unreachable', () async {
    stubDelete(() async => throw offline);

    expect(await delete(throws: offline), [
      null,
      ScheduledMessageStatus.scheduled,
    ]);
    expect(harness.client.state.scheduledMessages, [original]);
  });

  test('deleteScheduledMessage lists it again when the server refuses', () async {
    stubDelete(() async => throw refused);

    expect(await delete(throws: refused), [
      null,
      ScheduledMessageStatus.scheduled,
    ]);
    expect(harness.client.state.scheduledMessages, [original]);
  });

  test("deleteScheduledMessage doesn't list one being sent again, as it may be sent by now", () async {
    stubDelete(() async => throw sendingError);

    expect(await delete(throws: sendingError), [
      null,
    ]);
    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('deleteScheduledMessage keeps it unlisted and rethrows when the server no longer has it', () async {
    stubDelete(() async => throw missingError);
    await harness.hold([original]);

    await expectLater(harness.client.deleteScheduledMessage(original.id), throwsA(missingError));

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('deleteScheduledMessage stops listing one whose request failed and the server never got', () async {
    final failed = await harness.scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => throw missingError);

    final statuses = await harness.statusesDuring(() => harness.client.deleteScheduledMessage(failed.id));

    expect(statuses, [null]);
  });

  group('deleteScheduledMessage while the message is being scheduled', () {
    final message = Message(id: 'a', text: 'Good morning');
    final server = fakeScheduledMessage('a', scheduledAt: scheduledAt);

    void stubDelete(Future<DeleteScheduledMessageResponse> Function() answer) {
      when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) => answer());
    }

    // Schedules [message], with the server answering [answer], and deletes it
    // before the server answers.
    Future<(Future<ScheduleMessageResponse>, DeleteScheduledMessageResponse)> deleteWhileScheduling(
      Completer<ScheduleMessageResponse> answer,
    ) async {
      harness.stubSchedule(message, () => answer.future);
      final request = harness.schedule(message);
      await settle();

      final deleted = await harness.client.deleteScheduledMessage('a');
      return (request, deleted);
    }

    test('takes it out of the list at once, and deletes it on the server once it is scheduled', () async {
      final listed = <List<(String, ScheduledMessageStatus)>>[];
      final subscription = harness.client.state.scheduledMessagesStream.listen(
        (it) => listed.add([for (final m in it) (m.id, m.status)]),
      );
      addTearDown(subscription.cancel);
      stubDelete(() async => fakeDelete(server.copyWith(status: ScheduledMessageStatus.canceled)));
      final answer = Completer<ScheduleMessageResponse>();

      final (request, deleted) = await deleteWhileScheduling(answer);
      expect(deleted.scheduledMessage.status, ScheduledMessageStatus.canceled);
      expect(harness.client.state.scheduledMessages, isEmpty);
      verifyNever(() => harness.api.scheduledMessages.deleteScheduledMessage(any()));

      answer.complete(scheduled(message, server));
      await request;

      verify(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).called(1);
      expect(listed, [
        <(String, ScheduledMessageStatus)>[],
        [('a', ScheduledMessageStatus.preparingToSchedule)],
        <(String, ScheduledMessageStatus)>[],
      ]);
    });

    test('asks the server to delete it when scheduling it fails in a way the server may have stored', () async {
      stubDelete(() async => throw missingError);
      final answer = Completer<ScheduleMessageResponse>();

      final (request, _) = await deleteWhileScheduling(answer);
      answer.completeError(offline);
      await expectLater(request, throwsA(offline));

      verify(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).called(1);
      expect(harness.client.state.scheduledMessages, isEmpty);
      expect(harness.logs, isNot(contains('Failed to delete the scheduled message a')));
    });

    test('lists it as failed again when scheduling it fails and so does deleting it', () async {
      stubDelete(() async => throw offline);
      final answer = Completer<ScheduleMessageResponse>();

      final (request, _) = await deleteWhileScheduling(answer);
      answer.completeError(offline);
      await expectLater(request, throwsA(offline));

      final [listed] = harness.client.state.scheduledMessages;
      expect(listed.failure, const ScheduledMessageSchedulingFailed());
    });

    test("doesn't ask the server when the server refuses to schedule it", () async {
      final answer = Completer<ScheduleMessageResponse>();

      final (request, _) = await deleteWhileScheduling(answer);
      answer.completeError(rejected);
      await expectLater(request, throwsA(rejected));

      verifyNever(() => harness.api.scheduledMessages.deleteScheduledMessage(any()));
      expect(harness.client.state.scheduledMessages, isEmpty);
    });

    test('lists nothing when it was sent right away', () async {
      final answer = Completer<ScheduleMessageResponse>();

      final (request, _) = await deleteWhileScheduling(answer);
      answer.complete(ScheduleMessageResponse()..message = message);
      await request;

      verifyNever(() => harness.api.scheduledMessages.deleteScheduledMessage(any()));
      expect(harness.client.state.scheduledMessages, isEmpty);
    });

    test('lists it again, and still schedules, when deleting it on the server fails', () async {
      stubDelete(() async => throw offline);
      final answer = Completer<ScheduleMessageResponse>();

      final (request, _) = await deleteWhileScheduling(answer);
      answer.complete(scheduled(message, server));
      final response = await request;
      await settle();

      expect(response.scheduledMessage, server);
      expect(harness.logs, contains('Failed to delete the scheduled message a'));
      expect(harness.client.state.scheduledMessages, [server]);
    });

    test('keeps it out of the list when the server no longer has it', () async {
      stubDelete(() async => throw missingError);
      final answer = Completer<ScheduleMessageResponse>();

      final (request, _) = await deleteWhileScheduling(answer);
      answer.complete(scheduled(message, server));
      await request;

      expect(harness.logs, isNot(contains('Failed to delete the scheduled message a')));
      expect(harness.client.state.scheduledMessages, isEmpty);
    });

    test("lists it again, and keeps it scheduled, when the server's own created event comes first", () async {
      final answer = Completer<ScheduleMessageResponse>();

      final (request, _) = await deleteWhileScheduling(answer);
      await harness.receive(EventType.scheduledMessageCreated, server);
      answer.complete(scheduled(message, server));
      await request;

      verifyNever(() => harness.api.scheduledMessages.deleteScheduledMessage(any()));
      expect(idsOf(harness.client.state.scheduledMessages), ['a']);
    });

    test('leaves it scheduled on the server when the user disconnects before scheduling it ends', () async {
      final answer = Completer<ScheduleMessageResponse>();

      final (request, _) = await deleteWhileScheduling(answer);
      await harness.client.disconnectUser();
      answer.complete(scheduled(message, server));
      await request;

      verifyNever(() => harness.api.scheduledMessages.deleteScheduledMessage(any()));
    });
  });

  test('deleteScheduledMessage asks the server to delete one whose request failed', () async {
    final failed = await harness.scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    final deleted = fakeScheduledMessage('a', status: ScheduledMessageStatus.canceled);
    when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => fakeDelete(deleted));

    final response = await harness.client.deleteScheduledMessage(failed.id);

    expect(response.scheduledMessage, deleted);
    verify(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).called(1);
  });

  test('deleteScheduledMessage stops listing one whose request failed', () async {
    final failed = await harness.scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    final deleted = fakeScheduledMessage('a', status: ScheduledMessageStatus.canceled);
    when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => fakeDelete(deleted));

    await harness.client.deleteScheduledMessage(failed.id);

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('deleteScheduledMessage succeeds for one whose request failed, and the server never got', () async {
    final failed = await harness.scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => throw missingError);

    final response = await harness.client.deleteScheduledMessage(failed.id);
    await settle();

    expect(response.scheduledMessage.id, 'a');
    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('deleting one whose request failed, and the server never got, returns it canceled', () async {
    final failed = await harness.scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => throw missingError);

    final response = await harness.client.deleteScheduledMessage(failed.id);

    expect(response.scheduledMessage.status, ScheduledMessageStatus.canceled);
  });

  test('deleteScheduledMessage takes one whose request failed out of the list before the server answers', () async {
    final failed = await harness.scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    final answer = Completer<DeleteScheduledMessageResponse>();
    when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) => answer.future);

    final delete = harness.client.deleteScheduledMessage(failed.id);
    await settle();
    expect(harness.client.state.scheduledMessages, isEmpty);

    answer.complete(fakeDelete(failed.copyWith(status: ScheduledMessageStatus.canceled)));
    await delete;
    await settle();

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('deleteScheduledMessage lists one whose request failed again when the server fails', () async {
    final failed = await harness.scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    final serverError = StreamChatNetworkError(ChatErrorCode.internalSystemError, statusCode: 500);
    when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => throw serverError);

    await expectLater(harness.client.deleteScheduledMessage(failed.id), throwsA(serverError));

    expect(harness.client.state.scheduledMessages, [failed]);
  });

  test('deleteScheduledMessage stops listing one whose request failed when the server already sent it', () async {
    final failed = await harness.scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    final alreadySent = refusedWith(scheduledMessageAlreadySentCode);
    when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => throw alreadySent);

    final statuses = await harness.statusesDuring(
      () => expectRequest(harness.client.deleteScheduledMessage(failed.id), alreadySent),
    );

    expect(statuses.last, isNull);
    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('deleteScheduledMessage lists one whose request failed again when deleting it fails on this device', () async {
    final failed = await harness.scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    final error = StateError('Interrupted');
    when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => throw error);

    await expectLater(harness.client.deleteScheduledMessage(failed.id), throwsA(error));

    expect(harness.client.state.scheduledMessages, [failed]);
  });

  for (final (name, code) in [
    ('canceled', scheduledMessageCanceledCode),
  ]) {
    test('deleteScheduledMessage deletes one whose request failed that the server reports $name', () async {
      final failed = await harness.scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
      final gone = refusedWith(code);
      when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => throw gone);

      final response = await harness.client.deleteScheduledMessage(failed.id);
      await settle();

      expect(response.scheduledMessage.status, ScheduledMessageStatus.canceled);
      expect(harness.client.state.scheduledMessages, isEmpty);
    });
  }
}
