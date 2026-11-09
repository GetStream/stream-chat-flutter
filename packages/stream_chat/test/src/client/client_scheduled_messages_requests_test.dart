// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';

import 'package:clock/clock.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import 'scheduled_messages_harness.dart';

void main() {
  useScheduledMessageClient();

  final a = fakeScheduledMessage('a');

  test('rescheduleMessage asks for only the time', () async {
    final scheduledAt = DateTime.utc(2026, 11, 3, 9);
    when(
      () => api.scheduledMessages.updateScheduledMessage('a', scheduledAt: scheduledAt),
    ).thenAnswer((_) async => fakeUpdate(fakeScheduledMessage('a', scheduledAt: scheduledAt)));

    await client.rescheduleMessage(a, scheduledAt: scheduledAt);

    verify(() => api.scheduledMessages.updateScheduledMessage('a', scheduledAt: scheduledAt)).called(1);
  });

  test('rescheduleMessage lists the result', () async {
    await hold([a]);
    final scheduledAt = DateTime.utc(2026, 11, 3, 9);
    final moved = fakeScheduledMessage('a', scheduledAt: scheduledAt, updatedAt: DateTime.utc(2026, 10, 30));
    when(
      () => api.scheduledMessages.updateScheduledMessage('a', scheduledAt: scheduledAt),
    ).thenAnswer((_) async => fakeUpdate(moved));

    await client.rescheduleMessage(a, scheduledAt: scheduledAt);
    await settle();

    expect(client.state.scheduledMessages, [moved]);
  });

  test('an update event repeating the listed copy emits nothing more', () async {
    await hold([a]);
    final scheduledAt = DateTime.utc(2026, 11, 3, 9);
    ScheduledMessage moved() {
      return fakeScheduledMessage('a', scheduledAt: scheduledAt, updatedAt: DateTime.utc(2026, 10, 30));
    }

    when(
      () => api.scheduledMessages.updateScheduledMessage('a', scheduledAt: scheduledAt),
    ).thenAnswer((_) async => fakeUpdate(moved()));
    final emitted = <List<ScheduledMessage>?>[];
    final subscription = client.state.scheduledMessagesStream.skip(1).listen(emitted.add);
    addTearDown(subscription.cancel);

    await client.rescheduleMessage(a, scheduledAt: scheduledAt);
    await settle();
    await receive(EventType.scheduledMessageUpdated, moved());

    expect(emitted, [
      [moved()],
    ]);
  });

  test('updateScheduledMessage sends the message and time, and lists the result', () async {
    await hold([a]);
    final edited = Message(id: 'a', text: 'Good evening');
    final scheduledAt = DateTime.utc(2026, 11, 3, 9);
    final updated = fakeScheduledMessage(
      'a',
      text: 'Good evening',
      scheduledAt: scheduledAt,
      updatedAt: DateTime.utc(2026, 10, 30),
    );
    when(
      () => api.scheduledMessages.updateScheduledMessage('a', message: edited, scheduledAt: scheduledAt),
    ).thenAnswer((_) async => fakeUpdate(updated));

    await client.updateScheduledMessage(a, edited, scheduledAt: scheduledAt);
    await settle();

    verify(
      () => api.scheduledMessages.updateScheduledMessage('a', message: edited, scheduledAt: scheduledAt),
    ).called(1);
    expect(client.state.scheduledMessages, [updated]);
  });

  test('deleteScheduledMessage drops it', () async {
    await hold([a]);
    when(
      () => api.scheduledMessages.deleteScheduledMessage('a'),
    ).thenAnswer((_) async => fakeDelete(fakeScheduledMessage('a', status: ScheduledMessageStatus.canceled)));

    await client.deleteScheduledMessage(a);
    await settle();

    expect(client.state.scheduledMessages, isEmpty);
  });

  test('sendScheduledMessageNow lists it as sending', () async {
    await hold([a]);
    final sending = fakeScheduledMessage(
      'a',
      status: ScheduledMessageStatus.sending,
      updatedAt: DateTime.utc(2026, 10, 30),
    );
    when(() => api.scheduledMessages.sendScheduledMessageNow('a')).thenAnswer((_) async => fakeSendNow(sending));

    await client.sendScheduledMessageNow(a);
    await settle();

    expect(client.state.scheduledMessages, [sending]);
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
      await hold([a]);
      final deleted = client.on(EventType.scheduledMessageDeleted).first;
      stub(api, missingError);

      await expectLater(request(client), throwsA(missingError));

      final event = await deleted;
      expect(event.scheduledMessage?.id, 'a');
      expect(event.scheduledMessage?.status, ScheduledMessageStatus.canceled);
      expect(client.state.scheduledMessages, isEmpty);
    });
  }

  test('a request refused while the message is being sent keeps it', () async {
    await hold([a]);
    final error = StreamChatNetworkError.raw(code: 121, message: 'Sending', statusCode: 409);
    when(() => api.scheduledMessages.sendScheduledMessageNow('a')).thenAnswer((_) async => throw error);

    await expectLater(client.sendScheduledMessageNow(a), throwsA(error));
    await settle();

    expect(idsOf(client.state.scheduledMessages), ['a']);
  });

  test('a request that fails otherwise keeps it', () async {
    await hold([a]);
    final error = StreamChatNetworkError(ChatErrorCode.inputError, statusCode: 400);
    when(() => api.scheduledMessages.sendScheduledMessageNow('a')).thenAnswer((_) async => throw error);

    await expectLater(client.sendScheduledMessageNow(a), throwsA(error));
    await settle();

    expect(idsOf(client.state.scheduledMessages), ['a']);
  });

  final now = DateTime.utc(2026, 10, 30, 12);
  final scheduledAt = now.add(const Duration(days: 1));

  Future<ScheduleMessageResponse> schedule(Message message, DateTime time) {
    return withClock(
      Clock.fixed(now),
      () => client.scheduleMessage(message, 'general', 'messaging', scheduledAt: time),
    );
  }

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

    expect(client.state.scheduledMessages, isEmpty);
    verifyNever(
      () => api.scheduledMessages.scheduleMessage(
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
