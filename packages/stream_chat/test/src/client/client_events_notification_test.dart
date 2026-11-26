import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';
import 'event_fixtures.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.SendEventRequest(event: api.EventRequest(type: 'any'))));

  test(
    'StreamChatClient.sendEvent maps a notification.added_to_channel event onto a NotificationAddedToChannelEvent',
    () async {
      final event = await _sentEvent<NotificationAddedToChannelEvent>(
        api.NotificationAddedToChannelEvent(
          channel: generatedChannel,
          channelCustom: eventChannelCustom,
          channelId: eventChannelId,
          channelMemberCount: eventMemberCount,
          channelMessageCount: eventMessageCount,
          channelType: eventChannelType,
          cid: eventCid,
          createdAt: eventCreatedAt,
          custom: eventCustom,
          groupedUnreadChannels: const {'messaging': 4},
          member: fakeChannelMemberResponse(),
          receivedAt: eventReceivedAt,
          team: eventTeam,
          totalUnreadCount: 11,
          type: EventType.notificationAddedToChannel,
          unreadChannels: 5,
          unreadCount: 13,
        ),
      );

      // A channel compares by identity, so it is checked on its own.
      expect(event.channel.cid, 'messaging:general');
      expect(
        event,
        NotificationAddedToChannelEvent(
          cid: eventCid,
          channelId: eventChannelId,
          channelType: eventChannelType,
          channelMemberCount: eventMemberCount,
          channelMessageCount: eventMessageCount,
          channel: event.channel,
          member: fakeChannelMember(),
          totalUnreadCount: 11,
          unreadChannels: 5,
          createdAt: eventCreatedAt,
          custom: eventCustom,
          isLocal: false,
        ),
      );
    },
  );

  test(
    'StreamChatClient.sendEvent maps a notification.removed_from_channel event onto a '
    'NotificationRemovedFromChannelEvent',
    () async {
      final event = await _sentEvent<NotificationRemovedFromChannelEvent>(
        api.NotificationRemovedFromChannelEvent(
          channel: generatedChannel,
          channelCustom: eventChannelCustom,
          channelId: eventChannelId,
          channelMemberCount: eventMemberCount,
          channelMessageCount: eventMessageCount,
          channelType: eventChannelType,
          cid: eventCid,
          createdAt: eventCreatedAt,
          custom: eventCustom,
          member: fakeChannelMemberResponse(),
          receivedAt: eventReceivedAt,
          team: eventTeam,
          type: EventType.notificationRemovedFromChannel,
          user: generatedEventUser('remover'),
        ),
      );

      // A channel compares by identity, so it is checked on its own.
      expect(event.channel.cid, 'messaging:general');
      expect(
        event,
        NotificationRemovedFromChannelEvent(
          cid: eventCid,
          channelId: eventChannelId,
          channelType: eventChannelType,
          channelMemberCount: eventMemberCount,
          channelMessageCount: eventMessageCount,
          channel: event.channel,
          member: fakeChannelMember(),
          user: expectedEventUser('remover'),
          createdAt: eventCreatedAt,
          custom: eventCustom,
          isLocal: false,
        ),
      );
    },
  );

  test('StreamChatClient.sendEvent maps a notification.invited event onto a NotificationInvitedEvent', () async {
    final event = await _sentEvent<NotificationInvitedEvent>(
      api.NotificationInvitedEvent(
        channel: generatedChannel,
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        member: fakeChannelMemberResponse(),
        receivedAt: eventReceivedAt,
        team: eventTeam,
        type: EventType.notificationInvited,
        user: generatedEventUser('inviter'),
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.channel.cid, 'messaging:general');
    expect(
      event,
      NotificationInvitedEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channel: event.channel,
        member: fakeChannelMember(),
        user: expectedEventUser('inviter'),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test(
    'StreamChatClient.sendEvent maps a notification.invite_accepted event onto a NotificationInviteAcceptedEvent',
    () async {
      final event = await _sentEvent<NotificationInviteAcceptedEvent>(
        api.NotificationInviteAcceptedEvent(
          channel: generatedChannel,
          channelCustom: eventChannelCustom,
          channelId: eventChannelId,
          channelMemberCount: eventMemberCount,
          channelMessageCount: eventMessageCount,
          channelType: eventChannelType,
          cid: eventCid,
          createdAt: eventCreatedAt,
          custom: eventCustom,
          member: fakeChannelMemberResponse(),
          receivedAt: eventReceivedAt,
          team: eventTeam,
          type: EventType.notificationInviteAccepted,
          user: generatedEventUser('invitee'),
        ),
      );

      // A channel compares by identity, so it is checked on its own.
      expect(event.channel.cid, 'messaging:general');
      expect(
        event,
        NotificationInviteAcceptedEvent(
          cid: eventCid,
          channelId: eventChannelId,
          channelType: eventChannelType,
          channelMemberCount: eventMemberCount,
          channelMessageCount: eventMessageCount,
          channel: event.channel,
          member: fakeChannelMember(),
          user: expectedEventUser('invitee'),
          createdAt: eventCreatedAt,
          custom: eventCustom,
          isLocal: false,
        ),
      );
    },
  );

  test(
    'StreamChatClient.sendEvent maps a notification.channel_deleted event onto a NotificationChannelDeletedEvent',
    () async {
      final event = await _sentEvent<NotificationChannelDeletedEvent>(
        api.NotificationChannelDeletedEvent(
          channel: generatedChannel,
          channelCustom: eventChannelCustom,
          channelId: eventChannelId,
          channelMemberCount: eventMemberCount,
          channelMessageCount: eventMessageCount,
          channelType: eventChannelType,
          cid: eventCid,
          createdAt: eventCreatedAt,
          custom: eventCustom,
          groupedUnreadChannels: const {'messaging': 4},
          receivedAt: eventReceivedAt,
          team: eventTeam,
          totalUnreadCount: 11,
          type: EventType.notificationChannelDeleted,
          unreadChannels: 5,
          unreadCount: 13,
        ),
      );

      // A channel compares by identity, so it is checked on its own.
      expect(event.channel.cid, 'messaging:general');
      expect(
        event,
        NotificationChannelDeletedEvent(
          cid: eventCid,
          channelId: eventChannelId,
          channelType: eventChannelType,
          channelMemberCount: eventMemberCount,
          channelMessageCount: eventMessageCount,
          channel: event.channel,
          totalUnreadCount: 11,
          unreadChannels: 5,
          createdAt: eventCreatedAt,
          custom: eventCustom,
          isLocal: false,
        ),
      );
    },
  );

  test(
    'StreamChatClient.sendEvent maps a notification.channel_truncated event onto a NotificationChannelTruncatedEvent',
    () async {
      final event = await _sentEvent<NotificationChannelTruncatedEvent>(
        api.NotificationChannelTruncatedEvent(
          channel: generatedChannel,
          channelCustom: eventChannelCustom,
          channelId: eventChannelId,
          channelMemberCount: eventMemberCount,
          channelMessageCount: eventMessageCount,
          channelType: eventChannelType,
          cid: eventCid,
          createdAt: eventCreatedAt,
          custom: eventCustom,
          groupedUnreadChannels: const {'messaging': 4},
          message: generatedLeafMessage('truncation-id'),
          messageId: 'truncation-id',
          receivedAt: eventReceivedAt,
          team: eventTeam,
          totalUnreadCount: 11,
          type: EventType.notificationChannelTruncated,
          unreadChannels: 5,
          unreadCount: 13,
        ),
      );

      // A channel compares by identity, so it is checked on its own.
      expect(event.channel.cid, 'messaging:general');
      expect(
        event,
        NotificationChannelTruncatedEvent(
          cid: eventCid,
          channelId: eventChannelId,
          channelType: eventChannelType,
          channelMemberCount: eventMemberCount,
          channelMessageCount: eventMessageCount,
          channel: event.channel,
          message: expectedLeafMessage('truncation-id'),
          totalUnreadCount: 11,
          unreadChannels: 5,
          createdAt: eventCreatedAt,
          custom: eventCustom,
          isLocal: false,
        ),
      );
    },
  );

  test('StreamChatClient.sendEvent maps a notification.mark_read event onto a NotificationMarkReadEvent', () async {
    final event = await _sentEvent<NotificationMarkReadEvent>(
      api.NotificationMarkReadEvent(
        channel: generatedChannel,
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        groupedUnreadChannels: const {'messaging': 4},
        lastReadMessageId: 'last-read-id',
        receivedAt: eventReceivedAt,
        team: eventTeam,
        thread: generatedEventThread,
        threadId: 'parent-id',
        totalUnreadCount: 11,
        type: EventType.notificationMarkRead,
        unreadChannels: 5,
        unreadCount: 13,
        unreadThreadMessages: 9,
        unreadThreads: 2,
        user: generatedEventUser('reader'),
      ),
    );

    // A channel compares by identity, so the channels are checked on their own.
    expect([event.channel?.cid, event.thread?.channel?.cid], ['messaging:general', 'messaging:general']);
    expect(
      event,
      NotificationMarkReadEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channel: event.channel,
        user: expectedEventUser('reader'),
        lastReadMessageId: 'last-read-id',
        thread: expectedEventThread(channel: event.thread?.channel),
        totalUnreadCount: 11,
        unreadChannels: 5,
        unreadThreadMessages: 9,
        unreadThreads: 2,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a notification.mark_unread event onto a NotificationMarkUnreadEvent', () async {
    final event = await _sentEvent<NotificationMarkUnreadEvent>(
      api.NotificationMarkUnreadEvent(
        channel: generatedChannel,
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        firstUnreadMessageId: 'first-unread-id',
        groupedUnreadChannels: const {'messaging': 4},
        lastReadAt: DateTime.utc(2026, 3, 1),
        lastReadMessageId: 'last-read-id',
        receivedAt: eventReceivedAt,
        team: eventTeam,
        threadId: 'parent-id',
        totalUnreadCount: 11,
        type: EventType.notificationMarkUnread,
        unreadChannels: 5,
        unreadCount: 13,
        unreadMessages: 17,
        unreadThreadMessages: 9,
        unreadThreads: 2,
        user: generatedEventUser('reader'),
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.channel?.cid, 'messaging:general');
    expect(
      event,
      NotificationMarkUnreadEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channel: event.channel,
        user: expectedEventUser('reader'),
        threadId: 'parent-id',
        lastReadAt: DateTime.utc(2026, 3, 1),
        lastReadMessageId: 'last-read-id',
        totalUnreadCount: 11,
        unreadChannels: 5,
        unreadMessages: 17,
        unreadThreadMessages: 9,
        unreadThreads: 2,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a notification.message_new event onto a NotificationMessageNewEvent', () async {
    final event = await _sentEvent<NotificationMessageNewEvent>(
      api.NotificationNewMessageEvent(
        channel: generatedChannel,
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        groupedUnreadChannels: const {'messaging': 4},
        message: generatedLeafMessage('new-id'),
        messageId: 'new-id',
        parentAuthor: 'parent-author',
        receivedAt: eventReceivedAt,
        team: eventTeam,
        threadParticipants: [generatedEventUser('participant')],
        totalUnreadCount: 11,
        type: EventType.notificationMessageNew,
        unreadChannels: 5,
        unreadCount: 13,
        watcherCount: 3,
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.channel.cid, 'messaging:general');
    expect(
      event,
      NotificationMessageNewEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channel: event.channel,
        message: expectedLeafMessage('new-id'),
        watcherCount: 3,
        totalUnreadCount: 11,
        unreadChannels: 5,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test(
    'StreamChatClient.sendEvent maps a notification.thread_message_new event onto a NotificationThreadMessageNewEvent',
    () async {
      final event = await _sentEvent<NotificationThreadMessageNewEvent>(
        api.NotificationThreadMessageNewEvent(
          channel: generatedChannel,
          channelCustom: eventChannelCustom,
          channelId: eventChannelId,
          channelMemberCount: eventMemberCount,
          channelMessageCount: eventMessageCount,
          channelType: eventChannelType,
          cid: eventCid,
          createdAt: eventCreatedAt,
          custom: eventCustom,
          message: generatedLeafMessage('reply-id'),
          messageId: 'reply-id',
          parentAuthor: 'parent-author',
          receivedAt: eventReceivedAt,
          team: eventTeam,
          threadId: 'parent-id',
          threadParticipants: [generatedEventUser('participant')],
          type: EventType.notificationThreadMessageNew,
          unreadThreadMessages: 9,
          unreadThreads: 2,
          watcherCount: 3,
        ),
      );

      // A channel compares by identity, so it is checked on its own.
      expect(event.channel.cid, 'messaging:general');
      expect(
        event,
        NotificationThreadMessageNewEvent(
          cid: eventCid,
          channelId: eventChannelId,
          channelType: eventChannelType,
          channelMemberCount: eventMemberCount,
          channelMessageCount: eventMessageCount,
          channel: event.channel,
          message: expectedLeafMessage('reply-id'),
          watcherCount: 3,
          unreadThreadMessages: 9,
          unreadThreads: 2,
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
