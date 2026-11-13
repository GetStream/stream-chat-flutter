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
  final tooLong = StreamChatNetworkError.raw(code: 4, message: 'Message is too long', statusCode: 400);
  final sendingError = StreamChatNetworkError.raw(
    code: scheduledMessageSendingCode,
    message: 'Sending',
    statusCode: 409,
  );

  void stubUpdate(Future<UpdateScheduledMessageResponse> Function() answer, {DateTime? scheduledAt}) {
    when(
      () => harness.api.scheduledMessages.updateScheduledMessage('a', message: edited, scheduledAt: scheduledAt),
    ).thenAnswer((_) => answer());
  }

  Future<List<(String, ScheduledMessageStatus?)>> update() async {
    await harness.hold([original]);
    return harness.eventsDuring(() => harness.client.updateScheduledMessage(original, edited));
  }

  // Edits [original] while the server can't be reached.
  Future<ScheduledMessage> editUnreachable() async {
    stubUpdate(() async => throw offline);
    await update();
    return harness.client.state.scheduledMessages.single;
  }

  test('updateScheduledMessage reports the edit as updating, then the saved copy', () async {
    stubUpdate(() async => fakeUpdate(saved));

    expect(await update(), [
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.scheduled),
    ]);
    expect(harness.client.state.scheduledMessages, [saved]);
  });

  test('updateScheduledMessage lists the edit before the server answers', () async {
    final answer = Completer<UpdateScheduledMessageResponse>();
    stubUpdate(() => answer.future);
    await harness.hold([original]);

    harness.client.updateScheduledMessage(original, edited).ignore();
    await settle();

    final [updating] = harness.client.state.scheduledMessages;
    expect(updating.status, ScheduledMessageStatus.preparingToSchedule);
    expect(updating.message.text, 'Good evening');
  });

  test('updateScheduledMessage keeps an edit that could not reach the server as failed', () async {
    final failed = await editUnreachable();

    expect(failed.status, ScheduledMessageStatus.failed);
    expect(failed.failureReason, ScheduledMessageFailureReason.updateFailed);
    expect(failed.message.text, 'Good evening');
  });

  test('updateScheduledMessage keeps an edit the server refuses as failed', () async {
    stubUpdate(() async => throw tooLong);

    expect(await update(), [
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.failed),
    ]);
    final [failed] = harness.client.state.scheduledMessages;
    expect(failed.failureReason, ScheduledMessageFailureReason.updateFailed);
    expect(failed.message.text, 'Good evening');
  });

  test('updateScheduledMessage lists one being sent as it was, as sending', () async {
    stubUpdate(() async => throw sendingError);

    expect(await update(), [
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.sending),
    ]);
    expect(harness.client.state.scheduledMessages.single.message.text, 'Good morning');
  });

  test('updateScheduledMessage reports one the server no longer has as deleted', () async {
    stubUpdate(() async => throw missingError);

    expect(await update(), [
      (EventType.scheduledMessageUpdated, ScheduledMessageStatus.preparingToSchedule),
      (EventType.scheduledMessageDeleted, ScheduledMessageStatus.canceled),
    ]);
    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  group('with a failed edit', () {
    test('retryScheduledMessage saves a failed edit again, with its message and time', () async {
      final failed = await editUnreachable();
      stubUpdate(() async => fakeUpdate(saved), scheduledAt: original.scheduledAt);

      final scheduled = await harness.client.retryScheduledMessage(failed);
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

    test('deleteScheduledMessage asks the server to delete a failed edit, which it still has', () async {
      final failed = await editUnreachable();
      when(
        () => harness.api.scheduledMessages.deleteScheduledMessage('a'),
      ).thenAnswer((_) async => fakeDelete(original));

      await harness.client.deleteScheduledMessage(failed);
      await settle();

      verify(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).called(1);
      expect(harness.client.state.scheduledMessages, isEmpty);
    });

    test('deleteScheduledMessage rethrows when a failed edit is already gone', () async {
      final failed = await editUnreachable();
      when(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).thenAnswer((_) async => throw missingError);

      await expectLater(harness.client.deleteScheduledMessage(failed), throwsA(missingError));
    });

    test('a complete load keeps a failed edit over the copy the server had', () async {
      final failed = await editUnreachable();
      harness.stubQuery(fakePage([original]));

      await harness.client.loadScheduledMessages();

      expect(harness.client.state.scheduledMessages, [failed]);
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
    harness.client.updateScheduledMessage(original, edited).ignore();
    await settle();

    await harness.receive(EventType.scheduledMessageUpdated, original);

    expect(harness.client.state.scheduledMessages.single.status, ScheduledMessageStatus.preparingToSchedule);
  });

  test('updateScheduledMessage keeps a failed edit over a server copy of the same version', () async {
    await editUnreachable();

    await harness.receive(EventType.scheduledMessageUpdated, original);

    final [listed] = harness.client.state.scheduledMessages;
    expect(listed.failureReason, ScheduledMessageFailureReason.updateFailed);
    expect(listed.message.text, 'Good evening');
  });

  test('updateScheduledMessage replaces a failed edit with a newer server copy', () async {
    await editUnreachable();

    await harness.receive(EventType.scheduledMessageUpdated, saved);

    expect(harness.client.state.scheduledMessages, [saved]);
  });

  test('updateScheduledMessage reports its local events with the current user', () async {
    final answer = Completer<UpdateScheduledMessageResponse>();
    stubUpdate(() => answer.future);
    await harness.hold([original]);
    final events = <Event>[];
    final subscription = harness.client.on(EventType.scheduledMessageUpdated).listen(events.add);
    addTearDown(subscription.cancel);

    harness.client.updateScheduledMessage(original, edited).ignore();
    await settle();

    expect(events.single.user, harness.client.state.currentUser);
  });

  test("updateScheduledMessage doesn't overwrite the current user with the message's older copy of them", () async {
    final answer = Completer<UpdateScheduledMessageResponse>();
    stubUpdate(() => answer.future);
    await harness.hold([original]);
    final stale = original.copyWith(
      user: User(id: testUser.id, name: 'Old name'),
    );

    harness.client.updateScheduledMessage(stale, edited).ignore();
    await settle();

    final currentUser = harness.client.state.currentUser!;
    expect(harness.client.state.users[currentUser.id]?.name, currentUser.name);
  });

  test('a complete load drops an edit being saved that the server no longer has', () async {
    final answer = Completer<UpdateScheduledMessageResponse>();
    stubUpdate(() => answer.future);
    await harness.hold([original]);
    harness.client.updateScheduledMessage(original, edited).ignore();
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
}
