import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.UpdateThreadPartialRequest()));

  test('StreamChatClient.updateThreadPartial sends the set and unset fields and returns the updated thread', () async {
    const request = api.UpdateThreadPartialRequest(set: {'title': 'Trip'}, unset: ['topic']);

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateThreadPartial(messageId: 'parent-id', updateThreadPartialRequest: request),
    ).thenAnswer(
      (_) async => Result.success(api.UpdateThreadPartialResponse(duration: '0.01ms', thread: _generatedThread)),
    );
    final client = _client(defaultApi);

    final res = await client.updateThreadPartial('parent-id', set: {'title': 'Trip'}, unset: ['topic']);

    final response = res.getOrNull()!;
    // A channel compares by identity, so it is checked on its own.
    expect(response.thread.channel?.cid, 'messaging:general');
    expect(
      response,
      UpdateThreadPartialResponse(
        duration: '0.01ms',
        thread: _expectedThread(channel: response.thread.channel),
      ),
    );
    verify(
      () => defaultApi.updateThreadPartial(messageId: 'parent-id', updateThreadPartialRequest: request),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.updateThreadPartial returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateThreadPartial(
        messageId: any(named: 'messageId'),
        updateThreadPartialRequest: any(named: 'updateThreadPartialRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.updateThreadPartial('parent-id', set: {'title': 'Trip'});

    expect(res.exceptionOrNull(), error);
  });
}

// An updated thread carries no latest replies, reads or draft.
final _generatedThread = api.ThreadResponse(
  activeParticipantCount: 2,
  channel: api.ChannelResponse(
    cid: 'messaging:general',
    createdAt: DateTime.utc(2026),
    custom: const {},
    disabled: false,
    frozen: false,
    id: 'general',
    type: 'messaging',
    updatedAt: DateTime.utc(2026),
  ),
  channelCid: 'messaging:general',
  createdAt: DateTime.utc(2026, 2, 1),
  createdBy: fakeUserResponse('creator'),
  createdByUserId: 'creator',
  custom: const {'topic': 'travel', 'reply_count': 'shadowed'},
  deletedAt: DateTime.utc(2026, 2, 3),
  lastMessageAt: DateTime.utc(2026, 2, 4),
  parentMessage: generatedLeafMessage('parent-id'),
  parentMessageId: 'parent-id',
  participantCount: 3,
  replyCount: 4,
  threadParticipants: [
    api.ThreadParticipant(
      channelCid: 'messaging:general',
      createdAt: DateTime.utc(2026, 2, 7),
      custom: const {},
      lastReadAt: DateTime.utc(2026, 2, 8),
      lastThreadMessageAt: DateTime.utc(2026, 2, 9),
      leftThreadAt: DateTime.utc(2026, 2, 10),
      threadId: 'parent-id',
      user: fakeUserResponse('participant'),
      userId: 'participant',
    ),
  ],
  title: 'Trip',
  updatedAt: DateTime.utc(2026, 2, 2),
);

Thread _expectedThread({required ChannelModel? channel}) => Thread(
  activeParticipantCount: 2,
  channel: channel,
  channelCid: 'messaging:general',
  createdAt: DateTime.utc(2026, 2, 1),
  createdBy: fakeUser('creator'),
  createdByUserId: 'creator',
  deletedAt: DateTime.utc(2026, 2, 3),
  lastMessageAt: DateTime.utc(2026, 2, 4),
  parentMessage: expectedLeafMessage('parent-id'),
  parentMessageId: 'parent-id',
  participantCount: 3,
  replyCount: 4,
  threadParticipants: [
    ThreadParticipant(
      channelCid: 'messaging:general',
      createdAt: DateTime.utc(2026, 2, 7),
      lastReadAt: DateTime.utc(2026, 2, 8),
      lastThreadMessageAt: DateTime.utc(2026, 2, 9),
      leftThreadAt: DateTime.utc(2026, 2, 10),
      threadId: 'parent-id',
      user: fakeUser('participant'),
      userId: 'participant',
    ),
  ],
  title: 'Trip',
  updatedAt: DateTime.utc(2026, 2, 2),
  extraData: const {'topic': 'travel'},
);

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
