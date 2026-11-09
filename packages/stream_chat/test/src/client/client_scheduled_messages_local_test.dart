import 'dart:async';

import 'package:clock/clock.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'scheduled_messages_harness.dart';

void main() {
  useScheduledMessageClient();

  final now = DateTime.utc(2026, 10, 30, 12);
  final scheduledAt = now.add(const Duration(days: 1));
  final unreachable = StreamChatNetworkError.raw(code: -1, message: 'No connection');
  final rejected = StreamChatNetworkError(
    ChatErrorCode.inputError,
    data: ErrorResponse()
      ..code = 4
      ..statusCode = 400
      ..message = 'Too many scheduled messages',
  );

  // Schedules [message], then lets the events it emits through.
  Future<ScheduleMessageResponse> schedule(Message message) async {
    try {
      return await withClock(
        Clock.fixed(now),
        () => client.scheduleMessage(message, 'general', 'messaging', scheduledAt: scheduledAt),
      );
    } finally {
      await settle();
    }
  }

  Future<ScheduleMessageResponse> retry(ScheduledMessage scheduledMessage) async {
    final response = await withClock(Clock.fixed(now), () => client.retryScheduledMessage(scheduledMessage));
    await settle();
    return response;
  }

  // The scheduled message events while [run] runs, as type and status.
  Future<List<(String, ScheduledMessageStatus?)>> eventsDuring(Future<void> Function() run) async {
    final events = <(String, ScheduledMessageStatus?)>[];
    final subscription = client.on().where((it) => it.scheduledMessage != null).listen((it) {
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
      () => api.scheduledMessages.scheduleMessage('general', 'messaging', message, scheduledAt),
    ).thenAnswer((_) => answer());
  }

  ScheduleMessageResponse scheduled(Message message, ScheduledMessage scheduledMessage) {
    return ScheduleMessageResponse()
      ..message = message
      ..scheduledMessage = scheduledMessage;
  }

  // Schedules [message] while the server can't be reached.
  Future<ScheduledMessage> scheduleUnreachable(Message message) async {
    stubSchedule(message, () async => throw unreachable);
    await expectLater(schedule(message), throwsA(unreachable));
    return client.state.scheduledMessages.single;
  }

  test('lists the message before the server answers', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final answer = Completer<ScheduleMessageResponse>();
    stubSchedule(message, () => answer.future);

    final request = schedule(message);
    await settle();
    final [local] = client.state.scheduledMessages;

    expect(local.id, 'a');
    expect(local.status, ScheduledMessageStatus.preparingToSchedule);
    expect(local.user.id, testUser.id);
    expect(local.scheduledAt, scheduledAt);
    expect(local.createdAt, now);

    answer.complete(scheduled(message, fakeScheduledMessage('a', scheduledAt: scheduledAt)));
    await request;
  });

  test('the server copy replaces it, even when dated earlier', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final server = fakeScheduledMessage(
      'a',
      scheduledAt: scheduledAt,
      updatedAt: now.subtract(const Duration(days: 1)),
    );
    stubSchedule(message, () async => scheduled(message, server));

    await schedule(message);

    expect(client.state.scheduledMessages, [server]);
  });

  test('the event from the server replaces it, even when dated earlier', () async {
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
    await receive(EventType.scheduledMessageCreated, server);

    expect(client.state.scheduledMessages, [server]);

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
    await receive(EventType.scheduledMessageCreated, server);
    answer.completeError(unreachable);

    await expectLater(request, throwsA(unreachable));
    expect(client.state.scheduledMessages, [server]);
  });

  test('one sent right away is removed', () async {
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => ScheduleMessageResponse()..message = message);

    await schedule(message);

    expect(client.state.scheduledMessages, isEmpty);
  });

  test('one that could not reach the server stays as failed', () async {
    final failed = await scheduleUnreachable(Message(id: 'a', text: 'Good morning'));

    expect(failed.id, 'a');
    expect(failed.status, ScheduledMessageStatus.failed);
    expect(failed.failureReason, ScheduledMessageFailureReason.requestFailed);
  });

  test('one the server refuses is removed', () async {
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => throw rejected);

    await expectLater(schedule(message), throwsA(rejected));

    expect(client.state.scheduledMessages, isEmpty);
  });

  test('retryScheduledMessage schedules it again with the same ID', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final failed = await scheduleUnreachable(message);
    final server = fakeScheduledMessage('a', scheduledAt: scheduledAt);
    stubSchedule(message, () async => scheduled(message, server));

    await retry(failed);

    verify(() => api.scheduledMessages.scheduleMessage('general', 'messaging', message, scheduledAt)).called(2);
    expect(client.state.scheduledMessages, [server]);
  });

  test('retryScheduledMessage removes one that was sent right away', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final failed = await scheduleUnreachable(message);
    stubSchedule(message, () async => ScheduleMessageResponse()..message = message);

    await retry(failed);

    verify(() => api.scheduledMessages.scheduleMessage('general', 'messaging', message, scheduledAt)).called(2);
    expect(client.state.scheduledMessages, isEmpty);
  });

  test('retryScheduledMessage schedules one whose time has passed, with the same ID', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final failed = await scheduleUnreachable(message);
    stubSchedule(message, () async => ScheduleMessageResponse()..message = message);
    final later = scheduledAt.add(const Duration(hours: 1));

    await withClock(Clock.fixed(later), () => client.retryScheduledMessage(failed));
    await settle();

    verify(() => api.scheduledMessages.scheduleMessage('general', 'messaging', message, scheduledAt)).called(2);
    expect(client.state.scheduledMessages, isEmpty);
  });

  test('retryScheduledMessage refuses one the server failed to send', () {
    final failed = fakeScheduledMessage('a', status: ScheduledMessageStatus.failed);

    expect(() => client.retryScheduledMessage(failed), throwsA(isA<AssertionError>()));
  });

  test('lists failed ones after a later scheduled one', () async {
    await scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    await hold([
      fakeScheduledMessage('server-failed', scheduledAt: now, status: ScheduledMessageStatus.failed),
      fakeScheduledMessage('later', scheduledAt: scheduledAt.add(const Duration(days: 1))),
    ]);

    expect(idsOf(client.state.scheduledMessages), ['later', 'server-failed', 'a']);
  });

  test('a complete load keeps the ones not on the server yet', () async {
    await scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    stubQuery(fakePage([fakeScheduledMessage('b')]));

    await client.loadScheduledMessages();

    expect(idsOf(client.state.scheduledMessages), ['b', 'a']);
  });

  test('reports the message as created, then as the server has it', () async {
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => scheduled(message, fakeScheduledMessage('a', scheduledAt: scheduledAt)));

    final events = await eventsDuring(() => schedule(message));

    expect(events, [
      (EventType.scheduledMessageCreated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageCreated, ScheduledMessageStatus.scheduled),
    ]);
  });

  test('reports one that could not reach the server as updated to failed', () async {
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => throw unreachable);

    final events = await eventsDuring(() => schedule(message));

    expect(events, [
      (EventType.scheduledMessageCreated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.failed),
    ]);
  });

  test('reports one the server refuses as deleted', () async {
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => throw rejected);

    final events = await eventsDuring(() => schedule(message));

    expect(events, [
      (EventType.scheduledMessageCreated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageDeleted, ScheduledMessageStatus.canceled),
    ]);
  });

  test('reports one refused with an error other than a network one as deleted', () async {
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

  test('reports one whose request failed, and the server never got, as deleted', () async {
    final failed = await scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    when(() => api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => throw missingError);

    final events = await eventsDuring(() => client.deleteScheduledMessage(failed));

    expect(events, [(EventType.scheduledMessageDeleted, ScheduledMessageStatus.canceled)]);
  });

  test('reports the events it sends itself as local, and the server ones not', () async {
    final local = client.on(EventType.scheduledMessageCreated).first;
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () => Completer<ScheduleMessageResponse>().future);
    unawaited(schedule(message));

    expect((await local).isLocal, isTrue);

    final fromServer = client.on(EventType.scheduledMessageCreated).first;
    client.handleEvent(
      Event.fromJson({
        'type': EventType.scheduledMessageCreated,
        'cid': 'messaging:general',
        'scheduled_message': {
          'id': 'b',
          'cid': 'messaging:general',
          'user': {'id': 'current-user'},
          'message': {'text': 'Hello'},
          'scheduled_at': scheduledAt.toIso8601String(),
          'status': 'scheduled',
        },
      }),
    );

    expect((await fromServer).isLocal, isFalse);
  });

  for (final (refusal, code, type, status) in [
    ('already sent', 123, EventType.scheduledMessageSent, ScheduledMessageStatus.sent),
    ('deleted', 124, EventType.scheduledMessageDeleted, ScheduledMessageStatus.canceled),
  ]) {
    test('reports one the server refuses to schedule as $refusal with a $type event', () async {
      final message = Message(id: 'a', text: 'Good morning');
      final error = StreamChatNetworkError.raw(
        code: code,
        message: 'Refused',
        statusCode: 400,
        data: ErrorResponse()
          ..code = code
          ..statusCode = 400
          ..message = 'Refused',
      );
      stubSchedule(message, () async => throw error);

      final events = await eventsDuring(() => schedule(message));

      expect(events, [
        (EventType.scheduledMessageCreated, ScheduledMessageStatus.preparingToSchedule),
        (type, status),
      ]);
      expect(client.state.scheduledMessages, isEmpty);
    });

    test('reports one the server refuses to schedule again as $refusal with a $type event', () async {
      final message = Message(id: 'a', text: 'Good morning');
      final failed = await scheduleUnreachable(message);
      final error = StreamChatNetworkError.raw(
        code: code,
        message: 'Refused',
        statusCode: 400,
        data: ErrorResponse()
          ..code = code
          ..statusCode = 400
          ..message = 'Refused',
      );
      stubSchedule(message, () async => throw error);

      final events = await eventsDuring(() => client.retryScheduledMessage(failed));

      expect(events.last, (type, status));
      expect(client.state.scheduledMessages, isEmpty);
    });
  }

  test('reports one sent right away as sent', () async {
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => ScheduleMessageResponse()..message = message);

    final events = await eventsDuring(() => schedule(message));

    expect(events, [
      (EventType.scheduledMessageCreated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageSent, ScheduledMessageStatus.sent),
    ]);
  });

  test('an error other than a network one removes it and is rethrown', () async {
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => throw StateError('broken'));

    await expectLater(schedule(message), throwsStateError);

    expect(client.state.scheduledMessages, isEmpty);
  });

  test('without a current user, only the scheduled one is listed', () async {
    client.state.currentUser = null;
    final message = Message(id: 'a', text: 'Good morning');
    final server = fakeScheduledMessage('a', scheduledAt: scheduledAt);
    stubSchedule(message, () async => scheduled(message, server));

    final events = await eventsDuring(() => schedule(message));

    expect(events, [(EventType.scheduledMessageCreated, ScheduledMessageStatus.scheduled)]);
    expect(client.state.scheduledMessages, [server]);
  });

  test('a retriable server error leaves it as failed', () async {
    final unavailable = StreamChatNetworkError(
      ChatErrorCode.internalSystemError,
      statusCode: 503,
      data: ErrorResponse()..statusCode = 503,
    );
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => throw unavailable);

    await expectLater(schedule(message), throwsA(unavailable));

    final [failed] = client.state.scheduledMessages;
    expect(failed.status, ScheduledMessageStatus.failed);
    expect(failed.failureReason, ScheduledMessageFailureReason.requestFailed);
  });

  test('a retry that fails again leaves it as failed', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final failed = await scheduleUnreachable(message);

    await expectLater(retry(failed), throwsA(unreachable));
    await settle();

    final [again] = client.state.scheduledMessages;
    expect(again.status, ScheduledMessageStatus.failed);
    expect(again.failureReason, ScheduledMessageFailureReason.requestFailed);
  });

  test('deleting one whose request failed asks the server', () async {
    final failed = await scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    final deleted = fakeScheduledMessage('a', status: ScheduledMessageStatus.canceled);
    when(
      () => api.scheduledMessages.deleteScheduledMessage('a'),
    ).thenAnswer((_) async => DeleteScheduledMessageResponse()..scheduledMessage = deleted);

    final response = await client.deleteScheduledMessage(failed);
    await settle();

    expect(response.scheduledMessage, deleted);
    expect(client.state.scheduledMessages, isEmpty);
    verify(() => api.scheduledMessages.deleteScheduledMessage('a')).called(1);
  });

  test('deleting one whose request failed, and the server never got, succeeds', () async {
    final failed = await scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    when(() => api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => throw missingError);

    final response = await client.deleteScheduledMessage(failed);
    await settle();

    expect(response.scheduledMessage.id, 'a');
    expect(client.state.scheduledMessages, isEmpty);
  });

  test('deleting one whose request failed keeps it when the server fails', () async {
    final failed = await scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    final serverError = StreamChatNetworkError.raw(code: 16, message: 'Internal', statusCode: 500);
    when(() => api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => throw serverError);

    await expectLater(client.deleteScheduledMessage(failed), throwsA(serverError));
    await settle();

    expect(client.state.scheduledMessages, [failed]);
  });

  test('deleting one being scheduled asks the server', () async {
    final local = fakeScheduledMessage('a', status: ScheduledMessageStatus.preparingToSchedule);
    await hold([local]);
    when(() => api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => fakeDelete(local));

    await client.deleteScheduledMessage(local);

    verify(() => api.scheduledMessages.deleteScheduledMessage('a')).called(1);
  });

  test('one the server refused can be scheduled again with the same ID', () async {
    final message = Message(id: 'a', text: 'Good morning');
    stubSchedule(message, () async => throw rejected);
    await expectLater(schedule(message), throwsA(rejected));
    final server = fakeScheduledMessage('a', scheduledAt: scheduledAt);
    stubSchedule(message, () async => scheduled(message, server));

    await schedule(message);

    expect(client.state.scheduledMessages, [server]);
  });
}
