import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'event_fixtures.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.SendEventRequest(event: api.EventRequest(type: 'any'))));

  test('StreamChatClient.sendEvent maps a reaction.new event onto a ReactionNewEvent', () async {
    final event = await _sentEvent<ReactionNewEvent>(
      api.ReactionNewEvent(
        channel: generatedChannel,
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        message: generatedLeafMessage('message-id'),
        messageId: 'message-id',
        reaction: generatedReaction,
        receivedAt: eventReceivedAt,
        team: eventTeam,
        threadParticipants: [generatedEventUser('participant')],
        type: 'reaction.new',
        user: generatedEventUser('reactor'),
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.channel.cid, 'messaging:general');
    expect(
      event,
      ReactionNewEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channel: event.channel,
        message: expectedLeafMessage('message-id'),
        reaction: expectedReaction,
        user: expectedEventUser('reactor'),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a reaction.updated event onto a ReactionUpdatedEvent', () async {
    final event = await _sentEvent<ReactionUpdatedEvent>(
      api.ReactionUpdatedEvent(
        channel: generatedChannel,
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        message: generatedLeafMessage('message-id'),
        messageId: 'message-id',
        reaction: generatedReaction,
        receivedAt: eventReceivedAt,
        team: eventTeam,
        type: 'reaction.updated',
        user: generatedEventUser('reactor'),
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.channel.cid, 'messaging:general');
    expect(
      event,
      ReactionUpdatedEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channel: event.channel,
        message: expectedLeafMessage('message-id'),
        reaction: expectedReaction,
        user: expectedEventUser('reactor'),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a reaction.deleted event onto a ReactionDeletedEvent', () async {
    final event = await _sentEvent<ReactionDeletedEvent>(
      api.ReactionDeletedEvent(
        channel: generatedChannel,
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        message: generatedLeafMessage('message-id'),
        messageId: 'message-id',
        reaction: generatedReaction,
        receivedAt: eventReceivedAt,
        team: eventTeam,
        threadParticipants: [generatedEventUser('participant')],
        type: 'reaction.deleted',
        user: generatedEventUser('reactor'),
      ),
    );

    // A channel compares by identity, so it is checked on its own.
    expect(event.channel.cid, 'messaging:general');
    expect(
      event,
      ReactionDeletedEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channel: event.channel,
        message: expectedLeafMessage('message-id'),
        reaction: expectedReaction,
        user: expectedEventUser('reactor'),
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
