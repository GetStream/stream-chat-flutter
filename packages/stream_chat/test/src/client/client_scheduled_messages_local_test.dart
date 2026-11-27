import 'dart:async';

import 'package:clock/clock.dart' show Clock, withClock;
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../utils.dart';
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

  test('scheduleMessage stops listing one whose sending right away is refused', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final refused = Message(id: 'a', text: 'The channel is frozen', type: MessageType.error);
    harness.stubSchedule(message, () async => sentRightAway(refused));

    await expectLater(harness.schedule(message), throwsA(isA<ScheduledMessageRefusedError>()));

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('resendScheduledMessage lists the failed copy again when sending it right away is refused', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final failed = await harness.scheduleUnreachable(message);
    final refused = Message(id: 'a', text: 'The channel is frozen', type: MessageType.error);
    harness.stubSchedule(message, () async => sentRightAway(refused));

    await expectLater(resend(failed.id), throwsA(isA<ScheduledMessageRefusedError>()));

    final [listed] = harness.client.state.scheduledMessages;
    expect(listed.failure, const ScheduledMessageSchedulingFailed());
  });

  test('scheduleMessage throws the refusal of sending it right away', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final refused = Message(id: 'a', text: 'The channel is frozen', type: MessageType.error);
    harness.stubSchedule(message, () async => sentRightAway(refused));

    await expectLater(
      harness.schedule(message),
      throwsA(
        isA<ScheduledMessageRefusedError>().having(
          (it) => it.reason,
          'reason',
          ScheduledMessageErrorReason.scheduledMessageSendRefused,
        ),
      ),
    );
  });

  test('resendScheduledMessage removes one whose first attempt was sent right away', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final failed = await harness.scheduleUnreachable(message);
    harness.stubSchedule(message, () async => throw _messageAlreadyExists('a'));

    await resend(failed.id).then<void>((_) {}, onError: (_) {});

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

  test('scheduleMessage lists it as preparing to schedule, then as scheduled', () async {
    final message = Message(id: 'a', text: 'Good morning');
    harness.stubSchedule(message, () async => scheduled(message, fakeScheduledMessage('a', scheduledAt: scheduledAt)));

    final statuses = await harness.statusesDuring(() => harness.schedule(message));

    expect(statuses, [
      ScheduledMessageStatus.preparingToSchedule,
      ScheduledMessageStatus.scheduled,
    ]);
  });

  test('scheduleMessage lists one that could not reach the server as preparing, then as failed', () async {
    final message = Message(id: 'a', text: 'Good morning');
    harness.stubSchedule(message, () async => throw offline);

    final statuses = await harness.statusesDuring(() => expectRequest(harness.schedule(message), offline));

    expect(statuses, [
      ScheduledMessageStatus.preparingToSchedule,
      ScheduledMessageStatus.failed,
    ]);
  });

  test('scheduleMessage lists one the server refuses as preparing, then stops listing it', () async {
    final message = Message(id: 'a', text: 'Good morning');
    harness.stubSchedule(message, () async => throw rejected);

    final statuses = await harness.statusesDuring(() => expectRequest(harness.schedule(message), rejected));

    expect(statuses, [
      ScheduledMessageStatus.preparingToSchedule,
      null,
    ]);
  });

  test('scheduleMessage stops listing one refused with an error other than a network one', () async {
    final message = Message(id: 'a', text: 'Good morning');
    harness.stubSchedule(message, () async => throw StateError('Broken'));

    final statuses = await harness.statusesDuring(() async {
      await expectLater(harness.schedule(message), throwsStateError);
    });

    expect(statuses, [
      ScheduledMessageStatus.preparingToSchedule,
      null,
    ]);
  });

  for (final (refusal, code) in [
    ('already sent', scheduledMessageAlreadySentCode),
    ('deleted', scheduledMessageCanceledCode),
  ]) {
    test('scheduleMessage stops listing one the server reports $refusal', () async {
      final message = Message(id: 'a', text: 'Good morning');
      final error = refusedWith(code);
      harness.stubSchedule(message, () async => throw error);

      final statuses = await harness.statusesDuring(() => expectRequest(harness.schedule(message), error));

      expect(statuses, [ScheduledMessageStatus.preparingToSchedule, null]);
    });

    test('resendScheduledMessage stops listing one the server reports $refusal', () async {
      final message = Message(id: 'a', text: 'Good morning');
      final failed = await harness.scheduleUnreachable(message);
      final error = refusedWith(code);
      harness.stubSchedule(message, () async => throw error);

      final statuses = await harness.statusesDuring(
        () => expectRequest(harness.client.resendScheduledMessage(failed.id), error),
      );

      expect(statuses.last, isNull);
    });
  }

  test('scheduleMessage stops listing one sent right away', () async {
    final message = Message(id: 'a', text: 'Good morning');
    harness.stubSchedule(message, () async => sentRightAway(message));

    final statuses = await harness.statusesDuring(() => harness.schedule(message));

    expect(statuses, [
      ScheduledMessageStatus.preparingToSchedule,
      null,
    ]);
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
    final unavailable = apiException(code: StreamErrorCode.internalError, statusCode: 503);
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

// The error that refuses a message whose ID [id] is already taken by a sent
// message.
StreamApiException _messageAlreadyExists(String id) {
  final message = 'SendMessage failed with error: "a message with ID $id already exists"';
  return apiException(code: StreamErrorCode.inputError, message: message, statusCode: 400);
}
