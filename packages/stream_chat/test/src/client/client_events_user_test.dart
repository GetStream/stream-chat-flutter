import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'event_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.SendEventRequest(event: api.EventRequest(type: 'any'))));

  test('StreamChatClient.sendEvent maps a user.updated event onto a UserUpdatedEvent', () async {
    final event = await _sentEvent<UserUpdatedEvent>(
      api.UserUpdatedEvent(
        createdAt: eventCreatedAt,
        custom: eventCustom,
        receivedAt: eventReceivedAt,
        type: EventType.userUpdated,
        user: generatedEventPrivacyUser('updated'),
      ),
    );

    expect(
      event,
      UserUpdatedEvent(
        user: expectedEventPrivacyUser('updated'),
        privacySettings: expectedEventPrivacySettings,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps the update time of the user a user.updated event carries', () async {
    final event = await _sentEvent<UserUpdatedEvent>(
      api.UserUpdatedEvent(
        createdAt: eventCreatedAt,
        custom: eventCustom,
        type: EventType.userUpdated,
        user: generatedEventPrivacyUser('updated'),
      ),
    );

    expect(event.user.updatedAt, DateTime.utc(2024, 3, 6));
  });

  test('StreamChatClient.sendEvent maps a user.presence.changed event onto a UserPresenceChangedEvent', () async {
    final event = await _sentEvent<UserPresenceChangedEvent>(
      api.UserPresenceChangedEvent(
        createdAt: eventCreatedAt,
        custom: eventCustom,
        receivedAt: eventReceivedAt,
        type: EventType.userPresenceChanged,
        user: generatedEventUser('present'),
      ),
    );

    expect(
      event,
      UserPresenceChangedEvent(
        user: expectedEventUser('present'),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps the update time of the user an event concerns', () async {
    final event = await _sentEvent<UserPresenceChangedEvent>(
      api.UserPresenceChangedEvent(
        createdAt: eventCreatedAt,
        custom: eventCustom,
        type: EventType.userPresenceChanged,
        user: generatedEventUser('present'),
      ),
    );

    expect(event.user.updatedAt, DateTime.utc(2024, 1, 6));
  });

  test('StreamChatClient.sendEvent maps a user.watching.start event onto a UserWatchingStartEvent', () async {
    final event = await _sentEvent<UserWatchingStartEvent>(
      api.UserWatchingStartEvent(
        channelId: eventChannelId,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        receivedAt: eventReceivedAt,
        type: 'user.watching.start',
        user: generatedEventUser('watcher'),
        watcherCount: 3,
      ),
    );

    expect(
      event,
      UserWatchingStartEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        user: expectedEventUser('watcher'),
        watcherCount: 3,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a user.watching.stop event onto a UserWatchingStopEvent', () async {
    final event = await _sentEvent<UserWatchingStopEvent>(
      api.UserWatchingStopEvent(
        channelId: eventChannelId,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        receivedAt: eventReceivedAt,
        type: 'user.watching.stop',
        user: generatedEventUser('watcher'),
        watcherCount: 3,
      ),
    );

    expect(
      event,
      UserWatchingStopEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        user: expectedEventUser('watcher'),
        watcherCount: 3,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a user.banned event onto a UserBannedEvent', () async {
    final event = await _sentEvent<UserBannedEvent>(
      api.UserBannedEvent(
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        createdBy: generatedEventUser('moderator'),
        custom: eventCustom,
        expiration: DateTime.utc(2026, 4),
        reason: 'spam',
        receivedAt: eventReceivedAt,
        reviewQueueItemId: 'review-item-id',
        shadow: true,
        team: eventTeam,
        totalBans: 3,
        type: EventType.userBanned,
        user: generatedEventUser('banned'),
      ),
    );

    expect(
      event,
      UserBannedEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        user: expectedEventUser('banned'),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a user.unbanned event onto a UserUnbannedEvent', () async {
    final event = await _sentEvent<UserUnbannedEvent>(
      api.UserUnbannedEvent(
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        createdBy: generatedEventUser('moderator'),
        custom: eventCustom,
        receivedAt: eventReceivedAt,
        shadow: false,
        team: eventTeam,
        type: EventType.userUnbanned,
        user: generatedEventUser('unbanned'),
      ),
    );

    expect(
      event,
      UserUnbannedEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        user: expectedEventUser('unbanned'),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a user.messages.deleted event onto a UserMessagesDeletedEvent', () async {
    final event = await _sentEvent<UserMessagesDeletedEvent>(
      api.UserMessagesDeletedEvent(
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        hardDelete: true,
        receivedAt: eventReceivedAt,
        team: eventTeam,
        type: EventType.userMessagesDeleted,
        user: generatedEventUser('purged'),
      ),
    );

    expect(
      event,
      UserMessagesDeletedEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        user: expectedEventUser('purged'),
        hardDelete: true,
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
