import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'event_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.SendEventRequest(event: api.EventRequest(type: 'any'))));

  test(
    'StreamChatClient.sendEvent maps a scheduled_message.created event onto a ScheduledMessageCreatedEvent',
    () async {
      final event = await _sentEvent<ScheduledMessageCreatedEvent>(
        api.ScheduledMessageCreatedEvent(
          cid: eventCid,
          createdAt: eventCreatedAt,
          custom: eventCustom,
          receivedAt: eventReceivedAt,
          scheduledMessage: generatedEventScheduledMessage,
          type: 'scheduled_message.created',
          user: generatedEventUser('scheduler'),
        ),
      );

      expect(
        event,
        ScheduledMessageCreatedEvent(
          cid: eventCid,
          scheduledMessage: expectedEventScheduledMessage(),
          user: expectedEventUser('scheduler'),
          createdAt: eventCreatedAt,
          custom: eventCustom,
          isLocal: false,
        ),
      );
    },
  );

  test(
    'StreamChatClient.sendEvent maps a scheduled_message.updated event onto a ScheduledMessageUpdatedEvent',
    () async {
      final event = await _sentEvent<ScheduledMessageUpdatedEvent>(
        api.ScheduledMessageUpdatedEvent(
          cid: eventCid,
          createdAt: eventCreatedAt,
          custom: eventCustom,
          receivedAt: eventReceivedAt,
          scheduledMessage: generatedEventScheduledMessage,
          type: 'scheduled_message.updated',
          user: generatedEventUser('scheduler'),
        ),
      );

      expect(
        event,
        ScheduledMessageUpdatedEvent(
          cid: eventCid,
          scheduledMessage: expectedEventScheduledMessage(),
          user: expectedEventUser('scheduler'),
          createdAt: eventCreatedAt,
          custom: eventCustom,
          isLocal: false,
        ),
      );
    },
  );

  test(
    'StreamChatClient.sendEvent maps a scheduled_message.deleted event onto a ScheduledMessageDeletedEvent',
    () async {
      final event = await _sentEvent<ScheduledMessageDeletedEvent>(
        api.ScheduledMessageDeletedEvent(
          cid: eventCid,
          createdAt: eventCreatedAt,
          custom: eventCustom,
          receivedAt: eventReceivedAt,
          scheduledMessage: generatedEventScheduledMessage,
          type: 'scheduled_message.deleted',
          user: generatedEventUser('scheduler'),
        ),
      );

      expect(
        event,
        ScheduledMessageDeletedEvent(
          cid: eventCid,
          scheduledMessage: expectedEventScheduledMessage(),
          user: expectedEventUser('scheduler'),
          createdAt: eventCreatedAt,
          custom: eventCustom,
          isLocal: false,
        ),
      );
    },
  );

  test('StreamChatClient.sendEvent maps a scheduled_message.failed event onto a ScheduledMessageFailedEvent', () async {
    final event = await _sentEvent<ScheduledMessageFailedEvent>(
      api.ScheduledMessageFailedEvent(
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        receivedAt: eventReceivedAt,
        scheduledMessage: generatedEventScheduledMessage,
        type: 'scheduled_message.failed',
        user: generatedEventUser('scheduler'),
      ),
    );

    expect(
      event,
      ScheduledMessageFailedEvent(
        cid: eventCid,
        scheduledMessage: expectedEventScheduledMessage(),
        user: expectedEventUser('scheduler'),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a scheduled_message.sent event onto a ScheduledMessageSentEvent', () async {
    final event = await _sentEvent<ScheduledMessageSentEvent>(
      api.ScheduledMessageSentEvent(
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        messageId: 'sent-message-id',
        receivedAt: eventReceivedAt,
        scheduledMessage: generatedEventScheduledMessage,
        type: 'scheduled_message.sent',
        user: generatedEventUser('scheduler'),
      ),
    );

    expect(
      event,
      ScheduledMessageSentEvent(
        cid: eventCid,
        scheduledMessage: expectedEventScheduledMessage(),
        user: expectedEventUser('scheduler'),
        messageId: 'sent-message-id',
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });
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
