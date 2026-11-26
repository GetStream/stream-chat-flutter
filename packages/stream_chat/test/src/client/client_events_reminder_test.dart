import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'event_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.SendEventRequest(event: api.EventRequest(type: 'any'))));

  test('StreamChatClient.sendEvent maps a reminder.created event onto a ReminderCreatedEvent', () async {
    final event = await _sentEvent<ReminderCreatedEvent>(
      api.ReminderCreatedEvent(
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        messageId: 'reminded-id',
        parentId: 'thread-parent-id',
        receivedAt: eventReceivedAt,
        reminder: generatedEventReminder,
        type: 'reminder.created',
        userId: 'reminded',
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.reminder.channel?.cid, 'messaging:general');
    expect(
      event,
      ReminderCreatedEvent(
        cid: eventCid,
        messageId: 'reminded-id',
        parentId: 'thread-parent-id',
        reminder: expectedEventReminder(channel: event.reminder.channel),
        userId: 'reminded',
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a reminder.updated event onto a ReminderUpdatedEvent', () async {
    final event = await _sentEvent<ReminderUpdatedEvent>(
      api.ReminderUpdatedEvent(
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        messageId: 'reminded-id',
        parentId: 'thread-parent-id',
        receivedAt: eventReceivedAt,
        reminder: generatedEventReminder,
        type: 'reminder.updated',
        userId: 'reminded',
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.reminder.channel?.cid, 'messaging:general');
    expect(
      event,
      ReminderUpdatedEvent(
        cid: eventCid,
        messageId: 'reminded-id',
        parentId: 'thread-parent-id',
        reminder: expectedEventReminder(channel: event.reminder.channel),
        userId: 'reminded',
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a reminder.deleted event onto a ReminderDeletedEvent', () async {
    final event = await _sentEvent<ReminderDeletedEvent>(
      api.ReminderDeletedEvent(
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        messageId: 'reminded-id',
        parentId: 'thread-parent-id',
        receivedAt: eventReceivedAt,
        reminder: generatedEventReminder,
        type: 'reminder.deleted',
        userId: 'reminded',
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.reminder.channel?.cid, 'messaging:general');
    expect(
      event,
      ReminderDeletedEvent(
        cid: eventCid,
        messageId: 'reminded-id',
        parentId: 'thread-parent-id',
        reminder: expectedEventReminder(channel: event.reminder.channel),
        userId: 'reminded',
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test(
    'StreamChatClient.sendEvent maps a notification.reminder_due event onto a NotificationReminderDueEvent',
    () async {
      final event = await _sentEvent<NotificationReminderDueEvent>(
        api.ReminderNotificationEvent(
          cid: eventCid,
          createdAt: eventCreatedAt,
          custom: eventCustom,
          messageId: 'reminded-id',
          parentId: 'thread-parent-id',
          receivedAt: eventReceivedAt,
          reminder: generatedEventReminder,
          type: 'notification.reminder_due',
          userId: 'reminded',
        ),
      );

      // A channel compares by identity, so it is checked on its own.
      expect(event.reminder.channel?.cid, 'messaging:general');
      expect(
        event,
        NotificationReminderDueEvent(
          cid: eventCid,
          messageId: 'reminded-id',
          parentId: 'thread-parent-id',
          reminder: expectedEventReminder(channel: event.reminder.channel),
          userId: 'reminded',
          createdAt: eventCreatedAt,
          custom: eventCustom,
          isLocal: false,
        ),
      );
    },
  );
}

// The event the client returns for a sent event the server answers with
// [event], checked to be a [T].
Future<T> _sentEvent<T extends ChatEvent>(api.WSEvent event) async {
  final defaultApi = MockDefaultApi();
  when(
    () => defaultApi.sendEvent(
      type: any(named: 'type'),
      id: any(named: 'id'),
      sendEventRequest: any(named: 'sendEventRequest'),
    ),
  ).thenAnswer((_) async => Result.success(api.EventResponse(duration: '0.01ms', event: event)));
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);

  final res = await client.sendEvent('general', 'messaging', type: event.type);

  final mapped = res.getOrNull()?.event;
  expect(mapped, isA<T>());
  return mapped! as T;
}
