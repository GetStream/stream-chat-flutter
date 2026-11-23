import 'dart:async';

import 'package:clock/clock.dart' show Clock, withClock;
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'scheduled_messages_harness.dart';

void main() {
  final harness = useScheduledMessageClient();

  Future<ScheduledMessage?> resend(String id) async {
    final scheduled = await withClock(
      Clock.fixed(now),
      () => harness.client.resendScheduledMessage(id),
    );
    await settle();
    return scheduled;
  }

  test('scheduleMessage lists the message as preparing to schedule before the server answers', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final answer = Completer<ScheduleMessageResponse>();
    harness.stubSchedule(message, () => answer.future);

    final request = harness.schedule(message);
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
    harness.stubSchedule(message, () async => scheduled(message, server));

    await harness.schedule(message);

    expect(harness.client.state.scheduledMessages, [server]);
  });

  test('a scheduledMessageCreated event replaces the local copy, even when dated earlier', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final answer = Completer<ScheduleMessageResponse>();
    harness.stubSchedule(message, () => answer.future);
    final server = fakeScheduledMessage(
      'a',
      scheduledAt: scheduledAt,
      updatedAt: now.subtract(const Duration(days: 1)),
    );

    final request = harness.schedule(message);
    await settle();
    await harness.receive(EventType.scheduledMessageCreated, server);

    expect(harness.client.state.scheduledMessages, [server]);

    answer.complete(scheduled(message, server));
    await request;
  });

  test('a request that fails after the server copy arrived keeps the server copy', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final answer = Completer<ScheduleMessageResponse>();
    harness.stubSchedule(message, () => answer.future);
    final server = fakeScheduledMessage('a', scheduledAt: scheduledAt);

    final request = harness.schedule(message);
    await settle();
    await harness.receive(EventType.scheduledMessageCreated, server);
    answer.completeError(offline);

    await expectLater(request, throwsA(offline));
    expect(harness.client.state.scheduledMessages, [server]);
  });

  test('scheduleMessage stops listing a message the server sends right away', () async {
    final message = Message(id: 'a', text: 'Good morning');
    harness.stubSchedule(message, () async => sentRightAway(message));

    await harness.schedule(message);

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('scheduleMessage lists a message that could not reach the server as failed', () async {
    final failed = await harness.scheduleUnreachable(Message(id: 'a', text: 'Good morning'));

    expect(failed.id, 'a');
    expect(failed.status, ScheduledMessageStatus.failed);
    expect(failed.failure, const ScheduledMessageSchedulingFailed());
  });

  test('scheduleMessage stops listing a message the server refuses', () async {
    final message = Message(id: 'a', text: 'Good morning');
    harness.stubSchedule(message, () async => throw rejected);

    await expectLater(harness.schedule(message), throwsA(rejected));

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('resendScheduledMessage schedules it again with the same ID', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final failed = await harness.scheduleUnreachable(message);
    final server = fakeScheduledMessage('a', scheduledAt: scheduledAt);
    harness.stubSchedule(message, () async => scheduled(message, server));

    await resend(failed.id);

    verify(() => harness.api.scheduledMessages.scheduleMessage('general', 'messaging', message, scheduledAt)).called(2);
    expect(harness.client.state.scheduledMessages, [server]);
  });

  test('resendScheduledMessage removes one that was sent right away', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final failed = await harness.scheduleUnreachable(message);
    harness.stubSchedule(message, () async => sentRightAway(message));

    await resend(failed.id);

    verify(() => harness.api.scheduledMessages.scheduleMessage('general', 'messaging', message, scheduledAt)).called(2);
    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('resendScheduledMessage schedules one whose time has passed, with the same ID', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final failed = await harness.scheduleUnreachable(message);
    harness.stubSchedule(message, () async => sentRightAway(message));
    final later = scheduledAt.add(const Duration(hours: 1));

    await withClock(Clock.fixed(later), () => harness.client.resendScheduledMessage(failed.id));
    await settle();

    verify(() => harness.api.scheduledMessages.scheduleMessage('general', 'messaging', message, scheduledAt)).called(2);
    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('resendScheduledMessage refuses one the server failed to send', () async {
    final failed = fakeScheduledMessage(
      'a',
      status: ScheduledMessageStatus.failed,
      failure: const ScheduledMessageSendingFailed(),
    );
    await harness.hold([failed]);

    expect(() => harness.client.resendScheduledMessage(failed.id), throwsA(isA<StateError>()));
  });

  test('scheduledMessages lists failed ones by their time like the others', () async {
    await harness.scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    await harness.hold([
      fakeScheduledMessage('server-failed', scheduledAt: now, status: ScheduledMessageStatus.failed),
      fakeScheduledMessage('later', scheduledAt: scheduledAt.add(const Duration(days: 1))),
    ]);

    expect(idsOf(harness.client.state.scheduledMessages), ['server-failed', 'a', 'later']);
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
    await harness.scheduleUnreachable(Message(id: 'a', text: 'Good morning'));
    harness.stubQuery(fakePage([fakeScheduledMessage('b')]));

    await harness.client.loadScheduledMessages();

    expect(idsOf(harness.client.state.scheduledMessages), ['a', 'b']);
  });

  test('scheduleMessage reports it as created while preparing, then as created once scheduled', () async {
    final message = Message(id: 'a', text: 'Good morning');
    harness.stubSchedule(message, () async => scheduled(message, fakeScheduledMessage('a', scheduledAt: scheduledAt)));

    final events = await harness.eventsDuring(() => harness.schedule(message));

    expect(events, [
      (EventType.scheduledMessageCreated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageCreated, ScheduledMessageStatus.scheduled),
    ]);
  });

  test('scheduleMessage reports one that could not reach the server as updated to failed', () async {
    final message = Message(id: 'a', text: 'Good morning');
    harness.stubSchedule(message, () async => throw offline);

    final events = await harness.eventsDuring(() => expectRequest(harness.schedule(message), offline));

    expect(events, [
      (EventType.scheduledMessageCreated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.failed),
    ]);
  });

  test('scheduleMessage reports one the server refuses as deleted', () async {
    final message = Message(id: 'a', text: 'Good morning');
    harness.stubSchedule(message, () async => throw rejected);

    final events = await harness.eventsDuring(() => expectRequest(harness.schedule(message), rejected));

    expect(events, [
      (EventType.scheduledMessageCreated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageDeleted, ScheduledMessageStatus.canceled),
    ]);
  });

  test('scheduleMessage reports one refused with an error other than a network one as deleted', () async {
    final message = Message(id: 'a', text: 'Good morning');
    harness.stubSchedule(message, () async => throw StateError('Broken'));

    final events = await harness.eventsDuring(() async {
      await expectLater(harness.schedule(message), throwsStateError);
    });

    expect(events, [
      (EventType.scheduledMessageCreated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageDeleted, ScheduledMessageStatus.canceled),
    ]);
  });

  test('scheduleMessage reports its own events as local', () async {
    final local = harness.client.on(EventType.scheduledMessageCreated).first;
    final message = Message(id: 'a', text: 'Good morning');
    harness.stubSchedule(message, () => Completer<ScheduleMessageResponse>().future);
    unawaited(harness.schedule(message));

    expect((await local).isLocal, isTrue);
  });

  for (final (refusal, code, type, status) in [
    ('already sent', scheduledMessageAlreadySentCode, EventType.scheduledMessageSent, ScheduledMessageStatus.sent),
    ('deleted', scheduledMessageCanceledCode, EventType.scheduledMessageDeleted, ScheduledMessageStatus.canceled),
  ]) {
    test('reports one the server refuses to schedule as $refusal with a $type event', () async {
      final message = Message(id: 'a', text: 'Good morning');
      final error = refusedWith(code);
      harness.stubSchedule(message, () async => throw error);

      final events = await harness.eventsDuring(() => expectRequest(harness.schedule(message), error));

      expect(events, [
        (EventType.scheduledMessageCreated, ScheduledMessageStatus.preparingToSchedule),
        (type, status),
      ]);
      expect(harness.client.state.scheduledMessages, isEmpty);
    });

    test('reports one the server refuses to schedule again as $refusal with a $type event', () async {
      final message = Message(id: 'a', text: 'Good morning');
      final failed = await harness.scheduleUnreachable(message);
      final error = refusedWith(code);
      harness.stubSchedule(message, () async => throw error);

      final events = await harness.eventsDuring(
        () => expectRequest(harness.client.resendScheduledMessage(failed.id), error),
      );

      expect(events.last, (type, status));
    });
  }

  test('scheduleMessage reports one sent right away as sent', () async {
    final message = Message(id: 'a', text: 'Good morning');
    harness.stubSchedule(message, () async => sentRightAway(message));

    final events = await harness.eventsDuring(() => harness.schedule(message));

    expect(events, [
      (EventType.scheduledMessageCreated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageSent, ScheduledMessageStatus.sent),
    ]);
  });

  test("scheduleMessage reports the sent message's ID when it is sent right away", () async {
    final message = Message(id: 'a', text: 'Good morning');
    harness.stubSchedule(message, () async => sentRightAway(message));
    final sent = harness.client.on(EventType.scheduledMessageSent).first;

    await harness.schedule(message);

    expect((await sent).messageId, 'a');
  });

  test('scheduleMessage reports no message ID when the message was already sent', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final error = refusedWith(scheduledMessageAlreadySentCode);
    harness.stubSchedule(message, () async => throw error);
    final sent = harness.client.on(EventType.scheduledMessageSent).first;

    await expectLater(harness.schedule(message), throwsA(error));

    expect((await sent).messageId, isNull);
  });

  test('scheduleMessage rethrows an error other than a network one and stops listing it', () async {
    final message = Message(id: 'a', text: 'Good morning');
    harness.stubSchedule(message, () async => throw StateError('broken'));

    await expectLater(harness.schedule(message), throwsStateError);

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('scheduleMessage without a current user throws without making the request', () async {
    harness.client.state.currentUser = null;
    final message = Message(id: 'a', text: 'Good morning');

    await expectLater(harness.schedule(message), throwsStateError);

    verifyNever(() => harness.api.scheduledMessages.scheduleMessage(any(), any(), any(), any()));
    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('scheduleMessage leaves one that fails with a retriable server error as failed', () async {
    final unavailable = StreamChatNetworkError(
      ChatErrorCode.internalSystemError,
      statusCode: 503,
      data: ErrorResponse()..statusCode = 503,
    );
    final message = Message(id: 'a', text: 'Good morning');
    harness.stubSchedule(message, () async => throw unavailable);

    await expectLater(harness.schedule(message), throwsA(unavailable));

    final [failed] = harness.client.state.scheduledMessages;
    expect(failed.status, ScheduledMessageStatus.failed);
    expect(failed.failure, const ScheduledMessageSchedulingFailed());
  });

  test('resendScheduledMessage that fails again leaves it as failed', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final failed = await harness.scheduleUnreachable(message);

    await expectLater(resend(failed.id), throwsA(offline));
    await settle();

    final [again] = harness.client.state.scheduledMessages;
    expect(again.status, ScheduledMessageStatus.failed);
    expect(again.failure, const ScheduledMessageSchedulingFailed());
  });

  test(
    "scheduleMessage leaves the next user's list alone when the user disconnects before the server answers",
    () async {
      final message = Message(id: 'a', text: 'Good morning');
      final answer = Completer<ScheduleMessageResponse>();
      harness.stubSchedule(message, () => answer.future);
      final request = harness.schedule(message);
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
    harness.stubSchedule(message, () async => throw rejected);
    await expectLater(harness.schedule(message), throwsA(rejected));
    final server = fakeScheduledMessage('a', scheduledAt: scheduledAt);
    harness.stubSchedule(message, () async => scheduled(message, server));

    await harness.schedule(message);

    expect(harness.client.state.scheduledMessages, [server]);
  });
}
