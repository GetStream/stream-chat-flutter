import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'event_fixtures.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.SendEventRequest(event: api.EventRequest(type: 'any'))));

  test('StreamChatClient.sendEvent maps a message.new event onto a MessageNewEvent', () async {
    final event = await _sentEvent<MessageNewEvent>(
      api.MessageNewEvent(
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
        type: EventType.messageNew,
        unreadChannels: 5,
        unreadCount: 13,
        user: generatedEventUser('sender'),
        watcherCount: 3,
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.channel?.cid, 'messaging:general');
    expect(
      event,
      MessageNewEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channel: event.channel,
        message: expectedLeafMessage('new-id'),
        user: expectedEventUser('sender'),
        watcherCount: 3,
        totalUnreadCount: 11,
        unreadChannels: 5,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a message.updated event onto a MessageUpdatedEvent', () async {
    final event = await _sentEvent<MessageUpdatedEvent>(
      api.MessageUpdatedEvent(
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        message: generatedLeafMessage('updated-id'),
        messageId: 'updated-id',
        messageUpdate: const api.MessageUpdate(oldText: 'Before'),
        receivedAt: eventReceivedAt,
        team: eventTeam,
        type: EventType.messageUpdated,
        user: generatedEventUser('editor'),
      ),
    );

    expect(
      event,
      MessageUpdatedEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        message: expectedLeafMessage('updated-id'),
        user: expectedEventUser('editor'),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a message.deleted event onto a MessageDeletedEvent', () async {
    final event = await _sentEvent<MessageDeletedEvent>(
      api.MessageDeletedEvent(
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        deletedForMe: true,
        hardDelete: false,
        message: generatedLeafMessage('deleted-id'),
        messageId: 'deleted-id',
        receivedAt: eventReceivedAt,
        team: eventTeam,
        type: EventType.messageDeleted,
        user: generatedEventUser('deleter'),
      ),
    );

    expect(
      event,
      MessageDeletedEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        message: expectedLeafMessage('deleted-id'),
        user: expectedEventUser('deleter'),
        hardDelete: false,
        deletedForMe: true,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a message.read event onto a MessageReadEvent', () async {
    final event = await _sentEvent<MessageReadEvent>(
      api.MessageReadEvent(
        channel: generatedChannel,
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        lastReadMessageId: 'last-read-id',
        receivedAt: eventReceivedAt,
        team: eventTeam,
        thread: generatedEventThread,
        type: EventType.messageRead,
        user: generatedEventUser('reader'),
      ),
    );

    // A channel compares by identity, so the channels are checked on their own.
    expect([event.channel?.cid, event.thread?.channel?.cid], ['messaging:general', 'messaging:general']);
    expect(
      event,
      MessageReadEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channel: event.channel,
        user: expectedEventUser('reader'),
        lastReadMessageId: 'last-read-id',
        thread: expectedEventThread(channel: event.thread?.channel),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a message.delivered event onto a MessageDeliveredEvent', () async {
    final event = await _sentEvent<MessageDeliveredEvent>(
      api.MessageDeliveredEvent(
        channel: generatedChannel,
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        lastDeliveredAt: DateTime.utc(2026, 3, 2),
        lastDeliveredMessageId: 'delivered-id',
        receivedAt: eventReceivedAt,
        team: eventTeam,
        type: EventType.messageDelivered,
        user: generatedEventUser('recipient'),
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.channel?.cid, 'messaging:general');
    expect(
      event,
      MessageDeliveredEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channel: event.channel,
        user: expectedEventUser('recipient'),
        lastDeliveredAt: DateTime.utc(2026, 3, 2),
        lastDeliveredMessageId: 'delivered-id',
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a thread.updated event onto a ThreadUpdatedEvent', () async {
    final event = await _sentEvent<ThreadUpdatedEvent>(
      api.ThreadUpdatedEvent(
        channelId: eventChannelId,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        receivedAt: eventReceivedAt,
        thread: generatedEventThread,
        type: EventType.threadUpdated,
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.thread?.channel?.cid, 'messaging:general');
    expect(
      event,
      ThreadUpdatedEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        thread: expectedEventThread(channel: event.thread?.channel),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a draft.updated event onto a DraftUpdatedEvent', () async {
    final event = await _sentEvent<DraftUpdatedEvent>(
      api.DraftUpdatedEvent(
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        draft: generatedDraft,
        parentId: 'thread-parent-id',
        receivedAt: eventReceivedAt,
        type: EventType.draftUpdated,
      ),
    );

    // A channel compares by identity, and the attachment gets a new local id,
    // so both are read off the result; the channel is checked on its own.
    expect(event.draft?.channel?.cid, 'messaging:general');
    expect(
      event,
      DraftUpdatedEvent(
        cid: eventCid,
        draft: expectedDraft(
          attachmentId: event.draft!.message.attachments.single.id,
          channel: event.draft!.channel,
        ),
        parentId: 'thread-parent-id',
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a draft.deleted event onto a DraftDeletedEvent', () async {
    final event = await _sentEvent<DraftDeletedEvent>(
      api.DraftDeletedEvent(
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        draft: generatedDraft,
        parentId: 'thread-parent-id',
        receivedAt: eventReceivedAt,
        type: EventType.draftDeleted,
      ),
    );

    // A channel compares by identity, and the attachment gets a new local id,
    // so both are read off the result; the channel is checked on its own.
    expect(event.draft?.channel?.cid, 'messaging:general');
    expect(
      event,
      DraftDeletedEvent(
        cid: eventCid,
        draft: expectedDraft(
          attachmentId: event.draft!.message.attachments.single.id,
          channel: event.draft!.channel,
        ),
        parentId: 'thread-parent-id',
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
