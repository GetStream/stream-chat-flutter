import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'event_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.SendEventRequest(event: api.EventRequest(type: 'any'))));

  test('StreamChatClient.sendEvent maps a typing.start event onto a TypingStartEvent', () async {
    final event = await _sentEvent<TypingStartEvent>(
      api.TypingStartEvent(
        channelId: eventChannelId,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        member: const api.ChannelMemberPartialResponse(
          channelRole: 'channel_member',
          custom: {'nickname': 'Ty'},
          notificationsMuted: true,
        ),
        parentId: 'thread-parent-id',
        receivedAt: eventReceivedAt,
        type: 'typing.start',
        user: generatedEventUser('typist'),
      ),
    );

    expect(
      event,
      TypingStartEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        user: expectedEventUser('typist'),
        parentId: 'thread-parent-id',
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a typing.stop event onto a TypingStopEvent', () async {
    final event = await _sentEvent<TypingStopEvent>(
      api.TypingStopEvent(
        channelId: eventChannelId,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        member: const api.ChannelMemberPartialResponse(
          channelRole: 'channel_member',
          custom: {'nickname': 'Ty'},
          notificationsMuted: true,
        ),
        parentId: 'thread-parent-id',
        receivedAt: eventReceivedAt,
        type: 'typing.stop',
        user: generatedEventUser('typist'),
      ),
    );

    expect(
      event,
      TypingStopEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        user: expectedEventUser('typist'),
        parentId: 'thread-parent-id',
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps an ai_indicator.update event onto an AIIndicatorUpdateEvent', () async {
    final event = await _sentEvent<AIIndicatorUpdateEvent>(
      api.AIIndicatorUpdateEvent(
        aiMessage: 'Looking it up',
        aiState: 'AI_STATE_CHECKING_SOURCES',
        channelId: eventChannelId,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        messageId: 'answer-id',
        receivedAt: eventReceivedAt,
        type: 'ai_indicator.update',
        user: generatedEventUser('assistant'),
      ),
    );

    expect(
      event,
      AIIndicatorUpdateEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        user: expectedEventUser('assistant'),
        aiState: AITypingState.checkingSources,
        aiMessage: 'Looking it up',
        messageId: 'answer-id',
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps an ai_indicator.stop event onto an AIIndicatorStopEvent', () async {
    final event = await _sentEvent<AIIndicatorStopEvent>(
      api.AIIndicatorStopEvent(
        channelId: eventChannelId,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        receivedAt: eventReceivedAt,
        type: 'ai_indicator.stop',
        user: generatedEventUser('assistant'),
      ),
    );

    expect(
      event,
      AIIndicatorStopEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        user: expectedEventUser('assistant'),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps an ai_indicator.clear event onto an AIIndicatorClearEvent', () async {
    final event = await _sentEvent<AIIndicatorClearEvent>(
      api.AIIndicatorClearEvent(
        channelId: eventChannelId,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        receivedAt: eventReceivedAt,
        type: 'ai_indicator.clear',
        user: generatedEventUser('assistant'),
      ),
    );

    expect(
      event,
      AIIndicatorClearEvent(
        cid: eventCid,
        channelId: eventChannelId,
        channelType: eventChannelType,
        user: expectedEventUser('assistant'),
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
