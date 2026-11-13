// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';

import 'package:clock/clock.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import 'scheduled_messages_harness.dart';

void main() {
  final harness = useScheduledMessageClient();

  final a = fakeScheduledMessage('a');

  test('rescheduleMessage asks for only the time', () async {
    final scheduledAt = DateTime.utc(2026, 11, 3, 9);
    when(
      () => harness.api.scheduledMessages.updateScheduledMessage('a', scheduledAt: scheduledAt),
    ).thenAnswer((_) async => fakeUpdate(fakeScheduledMessage('a', scheduledAt: scheduledAt)));

    await harness.client.rescheduleMessage(a, scheduledAt: scheduledAt);

    verify(() => harness.api.scheduledMessages.updateScheduledMessage('a', scheduledAt: scheduledAt)).called(1);
  });

  test('rescheduleMessage lists the result', () async {
    await harness.hold([a]);
    final scheduledAt = DateTime.utc(2026, 11, 3, 9);
    final moved = fakeScheduledMessage('a', scheduledAt: scheduledAt, updatedAt: DateTime.utc(2026, 10, 30));
    when(
      () => harness.api.scheduledMessages.updateScheduledMessage('a', scheduledAt: scheduledAt),
    ).thenAnswer((_) async => fakeUpdate(moved));

    await harness.client.rescheduleMessage(a, scheduledAt: scheduledAt);
    await settle();

    expect(harness.client.state.scheduledMessages, [moved]);
  });

  test('an update event repeating the listed copy emits nothing more', () async {
    await harness.hold([a]);
    final scheduledAt = DateTime.utc(2026, 11, 3, 9);
    ScheduledMessage moved() {
      return fakeScheduledMessage('a', scheduledAt: scheduledAt, updatedAt: DateTime.utc(2026, 10, 30));
    }

    when(
      () => harness.api.scheduledMessages.updateScheduledMessage('a', scheduledAt: scheduledAt),
    ).thenAnswer((_) async => fakeUpdate(moved()));
    final emitted = <List<ScheduledMessage>?>[];
    final subscription = harness.client.state.scheduledMessagesStream.skip(1).listen(emitted.add);
    addTearDown(subscription.cancel);

    await harness.client.rescheduleMessage(a, scheduledAt: scheduledAt);
    await settle();
    final before = emitted.length;
    await harness.receive(EventType.scheduledMessageUpdated, moved());

    expect(emitted.last, [moved()]);
    expect(emitted, hasLength(before));
  });

  test('updateScheduledMessage sends the message and time', () async {
    final edited = Message(id: 'a', text: 'Good evening');
    final scheduledAt = DateTime.utc(2026, 11, 3, 9);
    when(
      () => harness.api.scheduledMessages.updateScheduledMessage('a', message: edited, scheduledAt: scheduledAt),
    ).thenAnswer((_) async => fakeUpdate(a));

    await harness.client.updateScheduledMessage(a, edited, scheduledAt: scheduledAt);

    verify(
      () => harness.api.scheduledMessages.updateScheduledMessage('a', message: edited, scheduledAt: scheduledAt),
    ).called(1);
  });

  test('updateScheduledMessage lists the result', () async {
    await harness.hold([a]);
    final edited = Message(id: 'a', text: 'Good evening');
    final scheduledAt = DateTime.utc(2026, 11, 3, 9);
    final updated = fakeScheduledMessage(
      'a',
      text: 'Good evening',
      scheduledAt: scheduledAt,
      updatedAt: DateTime.utc(2026, 10, 30),
    );
    when(
      () => harness.api.scheduledMessages.updateScheduledMessage('a', message: edited, scheduledAt: scheduledAt),
    ).thenAnswer((_) async => fakeUpdate(updated));

    await harness.client.updateScheduledMessage(a, edited, scheduledAt: scheduledAt);
    await settle();

    expect(harness.client.state.scheduledMessages, [updated]);
  });

  test('updateScheduledMessage reports only the edit when the user disconnects before the server answers', () async {
    await harness.hold([a]);
    final edited = Message(id: 'a', text: 'Good evening');
    final answer = Completer<UpdateScheduledMessageResponse>();
    when(
      () => harness.api.scheduledMessages.updateScheduledMessage('a', message: edited),
    ).thenAnswer((_) => answer.future);
    final updates = <Event>[];
    final subscription = harness.client.on(EventType.scheduledMessageUpdated).listen(updates.add);
    addTearDown(subscription.cancel);
    final request = harness.client.updateScheduledMessage(a, edited);

    await harness.client.disconnectUser();
    await harness.client.connectUser(testUser, testToken);
    answer.complete(fakeUpdate(fakeScheduledMessage('a', text: 'Good evening')));
    await request;
    await settle();

    expect(updates.map((it) => it.scheduledMessage?.status), [ScheduledMessageStatus.preparingToSchedule]);
  });

  test('updateScheduledMessage refuses an attachment that is not uploaded', () async {
    final edited = Message(
      id: 'a',
      text: 'Good evening',
      attachments: [
        Attachment(
          type: AttachmentType.image,
          file: AttachmentFile(size: 100, path: 'image.png'),
        ),
      ],
    );

    await expectLater(harness.client.updateScheduledMessage(a, edited), throwsA(isA<ArgumentError>()));

    verifyNever(
      () => harness.api.scheduledMessages.updateScheduledMessage(
        any(),
        message: any(named: 'message'),
        scheduledAt: any(named: 'scheduledAt'),
      ),
    );
  });

  test('deleteScheduledMessage drops it', () async {
    await harness.hold([a]);
    when(
      () => harness.api.scheduledMessages.deleteScheduledMessage('a'),
    ).thenAnswer((_) async => fakeDelete(fakeScheduledMessage('a', status: ScheduledMessageStatus.canceled)));

    await harness.client.deleteScheduledMessage(a);
    await settle();

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('sendScheduledMessageNow lists it as sending', () async {
    await harness.hold([a]);
    final sending = fakeScheduledMessage(
      'a',
      status: ScheduledMessageStatus.sending,
      updatedAt: DateTime.utc(2026, 10, 30),
    );
    when(
      () => harness.api.scheduledMessages.sendScheduledMessageNow('a'),
    ).thenAnswer((_) async => fakeSendNow(sending));

    await harness.client.sendScheduledMessageNow(a);
    await settle();

    final [listed] = harness.client.state.scheduledMessages;
    expect(listed.status, ScheduledMessageStatus.sending);
    expect(listed.remoteUpdatedAt, sending.remoteUpdatedAt);
  });

  final requests = [
    (
      'updateScheduledMessage',
      (FakeChatApi api, StreamChatNetworkError error) => when(
        () => api.scheduledMessages.updateScheduledMessage('a', message: any(named: 'message')),
      ).thenAnswer((_) async => throw error),
      (StreamChatClient client) => client.updateScheduledMessage(a, Message(id: 'a')),
    ),
    (
      'rescheduleMessage',
      (FakeChatApi api, StreamChatNetworkError error) => when(
        () => api.scheduledMessages.updateScheduledMessage('a', scheduledAt: any(named: 'scheduledAt')),
      ).thenAnswer((_) async => throw error),
      (StreamChatClient client) => client.rescheduleMessage(a, scheduledAt: DateTime.utc(2026, 11, 3)),
    ),
    (
      'deleteScheduledMessage',
      (FakeChatApi api, StreamChatNetworkError error) => when(
        () => api.scheduledMessages.deleteScheduledMessage('a'),
      ).thenAnswer((_) async => throw error),
      (StreamChatClient client) => client.deleteScheduledMessage(a),
    ),
    (
      'sendScheduledMessageNow',
      (FakeChatApi api, StreamChatNetworkError error) => when(
        () => api.scheduledMessages.sendScheduledMessageNow('a'),
      ).thenAnswer((_) async => throw error),
      (StreamChatClient client) => client.sendScheduledMessageNow(a),
    ),
  ];

  for (final (name, stub, request) in requests) {
    test('$name reports one that no longer exists as deleted', () async {
      await harness.hold([a]);
      final deleted = harness.client.on(EventType.scheduledMessageDeleted).first;
      stub(harness.api, missingError);

      await expectLater(request(harness.client), throwsA(missingError));

      final event = await deleted;
      expect(event.scheduledMessage?.id, 'a');
      expect(event.scheduledMessage?.status, ScheduledMessageStatus.canceled);
    });

    test('$name keeps one when something else is not found', () async {
      await harness.hold([a]);
      stub(harness.api, quoteDeletedError);

      await expectLater(request(harness.client), throwsA(quoteDeletedError));
      await settle();

      expect(idsOf(harness.client.state.scheduledMessages), ['a']);
    });

    test('$name stops listing one that no longer exists', () async {
      await harness.hold([a]);
      stub(harness.api, missingError);

      await expectLater(request(harness.client), throwsA(missingError));
      await settle();

      expect(harness.client.state.scheduledMessages, isEmpty);
    });
  }

  test('a request refused while the message is being sent keeps it', () async {
    await harness.hold([a]);
    final error = StreamChatNetworkError.raw(code: scheduledMessageSendingCode, message: 'Sending', statusCode: 409);
    when(() => harness.api.scheduledMessages.sendScheduledMessageNow('a')).thenAnswer((_) async => throw error);

    await expectLater(harness.client.sendScheduledMessageNow(a), throwsA(error));
    await settle();

    expect(idsOf(harness.client.state.scheduledMessages), ['a']);
  });

  test('a request that fails otherwise keeps it', () async {
    await harness.hold([a]);
    final error = StreamChatNetworkError(ChatErrorCode.inputError, statusCode: 400);
    when(() => harness.api.scheduledMessages.sendScheduledMessageNow('a')).thenAnswer((_) async => throw error);

    await expectLater(harness.client.sendScheduledMessageNow(a), throwsA(error));
    await settle();

    expect(idsOf(harness.client.state.scheduledMessages), ['a']);
  });

  final now = DateTime.utc(2026, 10, 30, 12);
  final scheduledAt = now.add(const Duration(days: 1));

  Future<ScheduleMessageResponse> schedule(Message message, DateTime time) {
    return withClock(
      Clock.fixed(now),
      () => harness.client.scheduleMessage(message, 'general', 'messaging', scheduledAt: time),
    );
  }

  test('scheduleMessage passes skipPush and skipEnrichUrl on', () async {
    final message = Message(id: 'b', text: 'Good morning');
    Future<ScheduleMessageResponse> request() => harness.api.scheduledMessages.scheduleMessage(
      'general',
      'messaging',
      message,
      scheduledAt,
      skipPush: true,
      skipEnrichUrl: true,
    );
    when(request).thenAnswer(
      (_) async => ScheduleMessageResponse()
        ..message = message
        ..scheduledMessage = fakeScheduledMessage('b', scheduledAt: scheduledAt),
    );

    await withClock(
      Clock.fixed(now),
      () => harness.client.scheduleMessage(
        message,
        'general',
        'messaging',
        scheduledAt: scheduledAt,
        skipPush: true,
        skipEnrichUrl: true,
      ),
    );

    verify(request).called(1);
  });

  test('scheduleMessage refuses a time that is not in the future', () async {
    final past = now.subtract(const Duration(minutes: 5));

    await expectLater(
      schedule(Message(text: 'Good morning'), past),
      throwsA(isA<ArgumentError>().having((it) => it.message, 'message', contains('sendMessage'))),
    );
  });

  test('scheduleMessage refuses attachments that are not uploaded', () async {
    final message = Message(
      text: 'Good morning',
      attachments: [
        Attachment(
          type: AttachmentType.image,
          file: AttachmentFile(size: 100, path: 'image.png'),
        ),
      ],
    );

    await expectLater(schedule(message, scheduledAt), throwsArgumentError);
    await settle();

    expect(harness.client.state.scheduledMessages, isEmpty);
    verifyNever(
      () => harness.api.scheduledMessages.scheduleMessage(
        any(),
        any(),
        any(),
        any(),
        skipPush: any(named: 'skipPush'),
        skipEnrichUrl: any(named: 'skipEnrichUrl'),
      ),
    );
  });
}
