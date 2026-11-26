import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'event_fixtures.dart';
import 'poll_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.SendEventRequest(event: api.EventRequest(type: 'any'))));

  test('StreamChatClient.sendEvent maps a poll.updated event onto a PollUpdatedEvent', () async {
    final event = await _sentEvent<PollUpdatedEvent>(
      api.PollUpdatedEvent(
        activityId: 'activity-id',
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        messageId: 'poll-message-id',
        poll: generatedPoll,
        receivedAt: eventReceivedAt,
        type: 'poll.updated',
      ),
    );

    expect(
      event,
      PollUpdatedEvent(
        cid: eventCid,
        messageId: 'poll-message-id',
        poll: poll,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a poll.closed event onto a PollClosedEvent', () async {
    final event = await _sentEvent<PollClosedEvent>(
      api.PollClosedEvent(
        activityId: 'activity-id',
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        messageId: 'poll-message-id',
        poll: generatedPoll,
        receivedAt: eventReceivedAt,
        type: 'poll.closed',
      ),
    );

    expect(
      event,
      PollClosedEvent(
        cid: eventCid,
        messageId: 'poll-message-id',
        poll: poll,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a poll.deleted event onto a PollDeletedEvent', () async {
    final event = await _sentEvent<PollDeletedEvent>(
      api.PollDeletedEvent(
        activityId: 'activity-id',
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        messageId: 'poll-message-id',
        poll: generatedPoll,
        receivedAt: eventReceivedAt,
        type: 'poll.deleted',
      ),
    );

    expect(
      event,
      PollDeletedEvent(
        cid: eventCid,
        messageId: 'poll-message-id',
        poll: poll,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a poll.vote_casted event onto a PollVoteCastedEvent', () async {
    final event = await _sentEvent<PollVoteCastedEvent>(
      api.PollVoteCastedEvent(
        activityId: 'activity-id',
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        messageId: 'poll-message-id',
        poll: generatedPoll,
        pollVote: generatedVote,
        receivedAt: eventReceivedAt,
        type: 'poll.vote_casted',
      ),
    );

    expect(
      event,
      PollVoteCastedEvent(
        cid: eventCid,
        messageId: 'poll-message-id',
        poll: poll,
        pollVote: vote,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a poll.vote_changed event onto a PollVoteChangedEvent', () async {
    final event = await _sentEvent<PollVoteChangedEvent>(
      api.PollVoteChangedEvent(
        activityId: 'activity-id',
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        messageId: 'poll-message-id',
        poll: generatedPoll,
        pollVote: generatedVote,
        receivedAt: eventReceivedAt,
        type: 'poll.vote_changed',
      ),
    );

    expect(
      event,
      PollVoteChangedEvent(
        cid: eventCid,
        messageId: 'poll-message-id',
        poll: poll,
        pollVote: vote,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a poll.vote_removed event onto a PollVoteRemovedEvent', () async {
    final event = await _sentEvent<PollVoteRemovedEvent>(
      api.PollVoteRemovedEvent(
        activityId: 'activity-id',
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        messageId: 'poll-message-id',
        poll: generatedPoll,
        pollVote: generatedVote,
        receivedAt: eventReceivedAt,
        type: 'poll.vote_removed',
      ),
    );

    expect(
      event,
      PollVoteRemovedEvent(
        cid: eventCid,
        messageId: 'poll-message-id',
        poll: poll,
        pollVote: vote,
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
