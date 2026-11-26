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

  test('StreamChatClient.sendEvent maps a channel.updated event onto a ChannelUpdatedEvent', () async {
    final event = await _sentEvent<ChannelUpdatedEvent>(
      api.ChannelUpdatedEvent(
        channel: generatedChannel,
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        message: generatedLeafMessage('system-id'),
        messageId: 'system-id',
        receivedAt: eventReceivedAt,
        team: eventTeam,
        type: EventType.channelUpdated,
        user: generatedEventUser('updater'),
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.channel.cid, 'messaging:general');
    expect(
      event,
      ChannelUpdatedEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channel: event.channel,
        user: expectedEventUser('updater'),
        message: expectedLeafMessage('system-id'),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a channel.deleted event onto a ChannelDeletedEvent', () async {
    final event = await _sentEvent<ChannelDeletedEvent>(
      api.ChannelDeletedEvent(
        channel: generatedChannel,
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        receivedAt: eventReceivedAt,
        team: eventTeam,
        type: EventType.channelDeleted,
        user: generatedEventUser('deleter'),
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.channel.cid, 'messaging:general');
    expect(
      event,
      ChannelDeletedEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channel: event.channel,
        user: expectedEventUser('deleter'),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a channel.truncated event onto a ChannelTruncatedEvent', () async {
    final event = await _sentEvent<ChannelTruncatedEvent>(
      api.ChannelTruncatedEvent(
        channel: generatedChannel,
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        message: generatedLeafMessage('truncation-id'),
        messageId: 'truncation-id',
        receivedAt: eventReceivedAt,
        team: eventTeam,
        type: EventType.channelTruncated,
        user: generatedEventUser('truncator'),
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.channel.cid, 'messaging:general');
    expect(
      event,
      ChannelTruncatedEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channel: event.channel,
        user: expectedEventUser('truncator'),
        message: expectedLeafMessage('truncation-id'),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a channel.hidden event onto a ChannelHiddenEvent', () async {
    final event = await _sentEvent<ChannelHiddenEvent>(
      api.ChannelHiddenEvent(
        channel: generatedChannel,
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        clearHistory: true,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        receivedAt: eventReceivedAt,
        team: eventTeam,
        type: EventType.channelHidden,
        user: generatedEventUser('hider'),
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.channel.cid, 'messaging:general');
    expect(
      event,
      ChannelHiddenEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channel: event.channel,
        user: expectedEventUser('hider'),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a channel.visible event onto a ChannelVisibleEvent', () async {
    final event = await _sentEvent<ChannelVisibleEvent>(
      api.ChannelVisibleEvent(
        channel: generatedChannel,
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        receivedAt: eventReceivedAt,
        team: eventTeam,
        type: EventType.channelVisible,
        user: generatedEventUser('shower'),
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.channel.cid, 'messaging:general');
    expect(
      event,
      ChannelVisibleEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channel: event.channel,
        user: expectedEventUser('shower'),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a member.added event onto a MemberAddedEvent', () async {
    final event = await _sentEvent<MemberAddedEvent>(
      api.MemberAddedEvent(
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
        type: EventType.memberAdded,
        user: generatedEventUser('adder'),
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.channel.cid, 'messaging:general');
    expect(
      event,
      MemberAddedEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channel: event.channel,
        member: fakeChannelMember(),
        user: expectedEventUser('adder'),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a member.removed event onto a MemberRemovedEvent', () async {
    final event = await _sentEvent<MemberRemovedEvent>(
      api.MemberRemovedEvent(
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
        type: EventType.memberRemoved,
        user: generatedEventUser('remover'),
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.channel.cid, 'messaging:general');
    expect(
      event,
      MemberRemovedEvent(
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
  });

  test('StreamChatClient.sendEvent maps a member.updated event onto a MemberUpdatedEvent', () async {
    final event = await _sentEvent<MemberUpdatedEvent>(
      api.MemberUpdatedEvent(
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
        type: EventType.memberUpdated,
        user: generatedEventUser('promoter'),
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.channel.cid, 'messaging:general');
    expect(
      event,
      MemberUpdatedEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channel: event.channel,
        member: fakeChannelMember(),
        user: expectedEventUser('promoter'),
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
