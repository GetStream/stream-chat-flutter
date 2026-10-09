import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  test('StreamChatClient.getThread sends the message id and options and returns the thread', () async {
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.getThread(
        messageId: 'parent-id',
        watch: false,
        replyLimit: 5,
        participantLimit: 20,
        memberLimit: 30,
      ),
    ).thenAnswer((_) async => Result.success(api.GetThreadResponse(duration: '0.01ms', thread: generatedThread)));
    final client = _client(defaultApi);

    final res = await client.getThread(
      'parent-id',
      options: const ThreadOptions(watch: false, replyLimit: 5, participantLimit: 20, memberLimit: 30),
    );

    final response = res.getOrNull()!;
    // A channel compares by identity, so it is checked on its own.
    expect(
      [response.thread.channel?.cid, response.thread.draft?.channel?.cid],
      [
        'messaging:general',
        'messaging:general',
      ],
    );
    expect(response, GetThreadResponse(duration: '0.01ms', thread: expectedThreadLike(response.thread)));
    verify(
      () => defaultApi.getThread(
        messageId: 'parent-id',
        watch: false,
        replyLimit: 5,
        participantLimit: 20,
        memberLimit: 30,
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test(
    'StreamChatClient.getThread sends the default options and returns a thread without reads or participants',
    () async {
      final defaultApi = MockDefaultApi();
      when(
        () => defaultApi.getThread(
          messageId: 'parent-id',
          watch: true,
          replyLimit: 2,
          participantLimit: 10,
          memberLimit: 10,
        ),
      ).thenAnswer((_) async => Result.success(api.GetThreadResponse(duration: '0.01ms', thread: _generatedNewThread)));
      final client = _client(defaultApi);

      final res = await client.getThread('parent-id');

      expect(
        res.getOrNull(),
        GetThreadResponse(
          duration: '0.01ms',
          thread: Thread(
            activeParticipantCount: 0,
            channelCid: 'messaging:general',
            createdAt: DateTime.utc(2026, 2, 1),
            createdByUserId: 'creator',
            lastMessageAt: DateTime.utc(2026, 2, 1),
            parentMessageId: 'parent-id',
            participantCount: 0,
            replyCount: 0,
            title: '',
            updatedAt: DateTime.utc(2026, 2, 1),
          ),
        ),
      );
      verify(
        () => defaultApi.getThread(
          messageId: 'parent-id',
          watch: true,
          replyLimit: 2,
          participantLimit: 10,
          memberLimit: 10,
        ),
      ).called(1);
      verifyNoMoreInteractions(defaultApi);
    },
  );

  test('StreamChatClient.getThread returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.getThread(
        messageId: any(named: 'messageId'),
        watch: any(named: 'watch'),
        replyLimit: any(named: 'replyLimit'),
        participantLimit: any(named: 'participantLimit'),
        memberLimit: any(named: 'memberLimit'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.getThread('parent-id');

    expect(res.exceptionOrNull(), error);
  });
}

// A thread whose reads, participants and replies are all empty: the empty lists the API may leave out are left out.
final _generatedNewThread = api.ThreadStateResponse(
  activeParticipantCount: 0,
  channelCid: 'messaging:general',
  createdAt: DateTime.utc(2026, 2, 1),
  createdByUserId: 'creator',
  custom: const {},
  lastMessageAt: DateTime.utc(2026, 2, 1),
  latestReplies: const [],
  parentMessageId: 'parent-id',
  participantCount: 0,
  replyCount: 0,
  title: '',
  updatedAt: DateTime.utc(2026, 2, 1),
);

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
