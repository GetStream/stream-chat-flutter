import 'dart:async';

import 'package:clock/clock.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'scheduled_messages_harness.dart';

final now = DateTime.utc(2026, 10, 30, 12);
final scheduledAt = now.add(const Duration(days: 1));
final rejected = StreamChatNetworkError(
  ChatErrorCode.inputError,
  data: ErrorResponse()
    ..code = 4
    ..statusCode = 400
    ..message = 'Too many scheduled messages',
);

void main() {
  final harness = useScheduledMessageClient();

  // Schedules [message], then lets the events it emits through.
  Future<ScheduleMessageResponse> schedule(Message message) async {
    try {
      return await withClock(
        Clock.fixed(now),
        () => harness.client.scheduleMessage(message, 'general', 'messaging', scheduledAt: scheduledAt),
      );
    } finally {
      await settle();
    }
  }

  Future<ScheduleMessageResponse> retry(ScheduledMessage scheduledMessage) async {
    final response = await withClock(Clock.fixed(now), () => harness.client.retryScheduledMessage(scheduledMessage));
    await settle();
    return response;
  }

  // The scheduled message events while [run] runs, as type and status.
  Future<List<(String, ScheduledMessageStatus?)>> eventsDuring(Future<void> Function() run) async {
    final events = <(String, ScheduledMessageStatus?)>[];
    final subscription = harness.client.on().where((it) => it.scheduledMessage != null).listen((it) {
      events.add((it.type, it.scheduledMessage?.status));
    });

    try {
      await run();
    } on StreamChatNetworkError {
      // The events are what is checked.
    }

    await settle();
    await subscription.cancel();
    return events;
  }

  void stubSchedule(Message message, Future<ScheduleMessageResponse> Function() answer) {
    when(
      () => harness.api.scheduledMessages.scheduleMessage('general', 'messaging', message, scheduledAt),
    ).thenAnswer((_) => answer());
  }

  // Schedules [message] while the server can't be reached.
  Future<ScheduledMessage> scheduleUnreachable(Message message) async {
    stubSchedule(message, () async => throw offline);
    await expectLater(schedule(message), throwsA(offline));
    return harness.client.state.scheduledMessages.single;
  }

  test('scheduleMessage lists the message as preparing to schedule before the server answers', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final answer = Completer<ScheduleMessageResponse>();
    stubSchedule(message, () => answer.future);

    final request = schedule(message);
    await settle();
    final [local] = harness.client.state.scheduledMessages;

    expect(local.id, 'a');
    expect(local.status, ScheduledMessageStatus.preparingToSchedule);
    expect(local.user.id, testUser.id);
    expect(local.scheduledAt, scheduledAt);
    expect(local.createdAt, now);

    answer.complete(scheduled(message, fakeScheduledMessage('a', scheduledAt: scheduledAt)));
    await request;
  });

  test('scheduleMessage replaces the local copy with the server copy, even one dated earlier', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final server = fakeScheduledMessage(
      'a',
      scheduledAt: scheduledAt,
      updatedAt: now.subtract(const Duration(days: 1)),
    );
    stubSchedule(message, () async => scheduled(message, server));

    await schedule(message);

    expect(harness.client.state.scheduledMessages, [server]);
  });

  test('a scheduledMessageCreated event replaces the local copy, even when dated earlier', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final answer = Completer<ScheduleMessageResponse>();
    stubSchedule(message, () => answer.future);
    final server = fakeScheduledMessage(
      'a',
      scheduledAt: scheduledAt,
      updatedAt: now.subtract(const Duration(days: 1)),
    );

    final request = schedule(message);
    await settle();
    await harness.receive(EventType.scheduledMessageCreated, server);

    expect(harness.client.state.scheduledMessages, [server]);

    answer.complete(scheduled(message, server));
    await request;
  });

  test('a request that fails after the server copy arrived keeps the server copy', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final answer = Completer<ScheduleMessageResponse>();
    stubSchedule(message, () => answer.future);
    final server = fakeScheduledMessage('a', scheduledAt: scheduledAt);

    final request = schedule(message);
    await settle();
    await harness.receive(EventType.scheduledMessageCreated, server);
    answer.completeError(offline);

    await expectLater(request, throwsA(offline));
    expect(harness.client.state.scheduledMessages, [server]);
  });

  test('scheduleMessage stops listing a message the server sends right away', () async {
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => sentRightAway(message));

    await schedule(message);

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('scheduleMessage lists a message that could not reach the server as failed', () async {
    final failed = await scheduleUnreachable(Message(id: 'a', text: 'Good morning'));

    expect(failed.id, 'a');
    expect(failed.status, ScheduledMessageStatus.failed);
    expect(failed.failureReason, ScheduledMessageFailureReason.requestFailed);
  });

  test('scheduleMessage stops listing a message the server refuses', () async {
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => throw rejected);

    await expectLater(schedule(message), throwsA(rejected));

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('retryScheduledMessage schedules it again with the same ID', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final failed = await scheduleUnreachable(message);
    final server = fakeScheduledMessage('a', scheduledAt: scheduledAt);
    stubSchedule(message, () async => scheduled(message, server));

    await retry(failed);

    verify(() => harness.api.scheduledMessages.scheduleMessage('general', 'messaging', message, scheduledAt)).called(2);
    expect(harness.client.state.scheduledMessages, [server]);
  });

  test('retryScheduledMessage removes one that was sent right away', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final failed = await scheduleUnreachable(message);
    stubSchedule(message, () async => sentRightAway(message));

    await retry(failed);

    verify(() => harness.api.scheduledMessages.scheduleMessage('general', 'messaging', message, scheduledAt)).called(2);
    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('retryScheduledMessage schedules one whose time has passed, with the same ID', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final failed = await scheduleUnreachable(message);
    stubSchedule(message, () async => sentRightAway(message));
    final later = scheduledAt.add(const Duration(hours: 1));

    await withClock(Clock.fixed(later), () => harness.client.retryScheduledMessage(failed));
    await settle();

    verify(() => harness.api.scheduledMessages.scheduleMessage('general', 'messaging', message, scheduledAt)).called(2);
    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('retryScheduledMessage refuses one the server failed to send', () {
    final failed = fakeScheduledMessage('a', status: ScheduledMessageStatus.failed);

    expect(() => harness.client.retryScheduledMessage(failed), throwsA(isA<AssertionError>()));
  });

  test('scheduledMessages lists failed ones after later scheduled ones', () async {
    await scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    await harness.hold([
      fakeScheduledMessage('server-failed', scheduledAt: now, status: ScheduledMessageStatus.failed),
      fakeScheduledMessage('later', scheduledAt: scheduledAt.add(const Duration(days: 1))),
    ]);

    expect(idsOf(harness.client.state.scheduledMessages), ['later', 'server-failed', 'a']);
  });

  test('scheduledMessages lists the ones due at the same time by ID', () async {
    final due = DateTime.utc(2026, 11, 2, 9);

    await harness.hold([
      fakeScheduledMessage('c', scheduledAt: due, updatedAt: DateTime.utc(2026, 10, 27)),
      fakeScheduledMessage('a', scheduledAt: due, updatedAt: DateTime.utc(2026, 10, 29)),
      fakeScheduledMessage('b', scheduledAt: due, updatedAt: DateTime.utc(2026, 10, 28)),
    ]);

    expect(idsOf(harness.client.state.scheduledMessages), ['a', 'b', 'c']);
  });

  test('a complete load keeps the ones not on the server yet', () async {
    await scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    harness.stubQuery(fakePage([fakeScheduledMessage('b')]));

    await harness.client.loadScheduledMessages();

    expect(idsOf(harness.client.state.scheduledMessages), ['b', 'a']);
  });

  test('scheduleMessage reports it as created while preparing, then as created once scheduled', () async {
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => scheduled(message, fakeScheduledMessage('a', scheduledAt: scheduledAt)));

    final events = await eventsDuring(() => schedule(message));

    expect(events, [
      (EventType.scheduledMessageCreated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageCreated, ScheduledMessageStatus.scheduled),
    ]);
  });

  test('scheduleMessage reports one that could not reach the server as updated to failed', () async {
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => throw offline);

    final events = await eventsDuring(() => schedule(message));

    expect(events, [
      (EventType.scheduledMessageCreated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.failed),
    ]);
  });

  test('scheduleMessage reports one the server refuses as deleted', () async {
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => throw rejected);

    final events = await eventsDuring(() => schedule(message));

    expect(events, [
      (EventType.scheduledMessageCreated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageDeleted, ScheduledMessageStatus.canceled),
    ]);
  });

  test('scheduleMessage reports one refused with an error other than a network one as deleted', () async {
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => throw StateError('Broken'));

    final events = await eventsDuring(() async {
      await expectLater(schedule(message), throwsStateError);
    });

    expect(events, [
      (EventType.scheduledMessageCreated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageDeleted, ScheduledMessageStatus.canceled),
    ]);
  });

  test('deleteScheduledMessage reports one whose request failed, and the server never got, as deleted', () async {
    final failed = await scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => throw missingError);

    final events = await eventsDuring(() => harness.client.deleteScheduledMessage(failed));

    expect(events, [(EventType.scheduledMessageDeleted, ScheduledMessageStatus.canceled)]);
  });

  test('scheduleMessage reports its own events as local', () async {
    final local = harness.client.on(EventType.scheduledMessageCreated).first;
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () => Completer<ScheduleMessageResponse>().future);
    unawaited(schedule(message));

    expect((await local).isLocal, isTrue);
  });

  for (final (refusal, code, type, status) in [
    ('already sent', scheduledMessageAlreadySentCode, EventType.scheduledMessageSent, ScheduledMessageStatus.sent),
    ('deleted', scheduledMessageCanceledCode, EventType.scheduledMessageDeleted, ScheduledMessageStatus.canceled),
  ]) {
    test('reports one the server refuses to schedule as $refusal with a $type event', () async {
      final message = Message(id: 'a', text: 'Good morning');
      final error = refusedWith(code);
      stubSchedule(message, () async => throw error);

      final events = await eventsDuring(() => schedule(message));

      expect(events, [
        (EventType.scheduledMessageCreated, ScheduledMessageStatus.preparingToSchedule),
        (type, status),
      ]);
      expect(harness.client.state.scheduledMessages, isEmpty);
    });

    test('reports one the server refuses to schedule again as $refusal with a $type event', () async {
      final message = Message(id: 'a', text: 'Good morning');
      final failed = await scheduleUnreachable(message);
      final error = refusedWith(code);
      stubSchedule(message, () async => throw error);

      final events = await eventsDuring(() => harness.client.retryScheduledMessage(failed));

      expect(events.last, (type, status));
    });
  }

  test('scheduleMessage reports one sent right away as sent', () async {
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => sentRightAway(message));

    final events = await eventsDuring(() => schedule(message));

    expect(events, [
      (EventType.scheduledMessageCreated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageSent, ScheduledMessageStatus.sent),
    ]);
  });

  test("scheduleMessage reports the sent message's ID when it is sent right away", () async {
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => sentRightAway(message));
    final sent = harness.client.on(EventType.scheduledMessageSent).first;

    await schedule(message);

    expect((await sent).messageId, 'a');
  });

  test('scheduleMessage reports no message ID when the message was already sent', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final error = refusedWith(scheduledMessageAlreadySentCode);
    stubSchedule(message, () async => throw error);
    final sent = harness.client.on(EventType.scheduledMessageSent).first;

    await expectLater(schedule(message), throwsA(error));

    expect((await sent).messageId, isNull);
  });

  test('scheduleMessage rethrows an error other than a network one and stops listing it', () async {
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => throw StateError('broken'));

    await expectLater(schedule(message), throwsStateError);

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('scheduleMessage without a current user reports only the scheduled one', () async {
    harness.client.state.currentUser = null;
    final message = Message(id: 'a', text: 'Good morning');
    final server = fakeScheduledMessage('a', scheduledAt: scheduledAt);
    stubSchedule(message, () async => scheduled(message, server));

    final events = await eventsDuring(() => schedule(message));

    expect(events, [(EventType.scheduledMessageCreated, ScheduledMessageStatus.scheduled)]);
  });

  test('scheduleMessage without a current user lists only the scheduled one', () async {
    harness.client.state.currentUser = null;
    final message = Message(id: 'a', text: 'Good morning');
    final server = fakeScheduledMessage('a', scheduledAt: scheduledAt);
    stubSchedule(message, () async => scheduled(message, server));

    await schedule(message);

    expect(harness.client.state.scheduledMessages, [server]);
  });

  test('scheduleMessage leaves one that fails with a retriable server error as failed', () async {
    final unavailable = StreamChatNetworkError(
      ChatErrorCode.internalSystemError,
      statusCode: 503,
      data: ErrorResponse()..statusCode = 503,
    );
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => throw unavailable);

    await expectLater(schedule(message), throwsA(unavailable));

    final [failed] = harness.client.state.scheduledMessages;
    expect(failed.status, ScheduledMessageStatus.failed);
    expect(failed.failureReason, ScheduledMessageFailureReason.requestFailed);
  });

  test('retryScheduledMessage that fails again leaves it as failed', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final failed = await scheduleUnreachable(message);

    await expectLater(retry(failed), throwsA(offline));
    await settle();

    final [again] = harness.client.state.scheduledMessages;
    expect(again.status, ScheduledMessageStatus.failed);
    expect(again.failureReason, ScheduledMessageFailureReason.requestFailed);
  });

  test('deleteScheduledMessage asks the server to delete one whose request failed', () async {
    final failed = await scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    final deleted = fakeScheduledMessage('a', status: ScheduledMessageStatus.canceled);
    when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => fakeDelete(deleted));

    final response = await harness.client.deleteScheduledMessage(failed);

    expect(response.scheduledMessage, deleted);
    verify(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).called(1);
  });

  test('deleteScheduledMessage stops listing one whose request failed', () async {
    final failed = await scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    final deleted = fakeScheduledMessage('a', status: ScheduledMessageStatus.canceled);
    when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => fakeDelete(deleted));

    await harness.client.deleteScheduledMessage(failed);
    await settle();

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('deleteScheduledMessage succeeds for one whose request failed, and the server never got', () async {
    final failed = await scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => throw missingError);

    final response = await harness.client.deleteScheduledMessage(failed);
    await settle();

    expect(response.scheduledMessage.id, 'a');
    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('deleting one whose request failed, and the server never got, returns it canceled', () async {
    final failed = await scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => throw missingError);

    final response = await harness.client.deleteScheduledMessage(failed);

    expect(response.scheduledMessage.status, ScheduledMessageStatus.canceled);
  });

  test('deleteScheduledMessage keeps one whose request failed when the server fails', () async {
    final failed = await scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    final serverError = StreamChatNetworkError(ChatErrorCode.internalSystemError, statusCode: 500);
    when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => throw serverError);

    await expectLater(harness.client.deleteScheduledMessage(failed), throwsA(serverError));
    await settle();

    expect(harness.client.state.scheduledMessages, [failed]);
  });

  test('deleteScheduledMessage asks the server to delete one being scheduled', () async {
    final local = fakeScheduledMessage('a', status: ScheduledMessageStatus.preparingToSchedule);
    await harness.hold([local]);
    when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => fakeDelete(local));

    await harness.client.deleteScheduledMessage(local);

    verify(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).called(1);
  });

  test(
    "scheduleMessage leaves the next user's list alone when the user disconnects before the server answers",
    () async {
      final message = Message(id: 'a', text: 'Good morning');
      final answer = Completer<ScheduleMessageResponse>();
      stubSchedule(message, () => answer.future);
      final request = schedule(message);
      await settle();

      await harness.client.disconnectUser();
      await harness.client.connectUser(testUser, testToken);
      answer.complete(scheduled(message, fakeScheduledMessage('a', scheduledAt: scheduledAt)));
      await request;

      expect(harness.client.state.scheduledMessages, isEmpty);
    },
  );

  test('scheduleMessage schedules one the server refused again with the same ID', () async {
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => throw rejected);
    await expectLater(schedule(message), throwsA(rejected));
    final server = fakeScheduledMessage('a', scheduledAt: scheduledAt);
    stubSchedule(message, () async => scheduled(message, server));

    await schedule(message);

    expect(harness.client.state.scheduledMessages, [server]);
  });
}

ScheduleMessageResponse scheduled(Message message, ScheduledMessage scheduledMessage) {
  return ScheduleMessageResponse()
    ..message = message
    ..scheduledMessage = scheduledMessage;
}

// The error that refuses a scheduled message request with [code].
StreamChatNetworkError refusedWith(int code) {
  return StreamChatNetworkError.raw(
    code: code,
    message: 'Refused',
    statusCode: 400,
    data: ErrorResponse()
      ..code = code
      ..statusCode = 400
      ..message = 'Refused',
  );
}

// The response for [message] when its time had passed and it was sent.
ScheduleMessageResponse sentRightAway(Message message) {
  return ScheduleMessageResponse()..message = message;
}
