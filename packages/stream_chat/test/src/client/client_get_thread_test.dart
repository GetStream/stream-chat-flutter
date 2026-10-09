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

  test('StreamChatClient.getThread sends the default options when none are given', () async {
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.getThread(
        messageId: 'parent-id',
        watch: true,
        replyLimit: 2,
        participantLimit: 10,
        memberLimit: 10,
      ),
    ).thenAnswer((_) async => Result.success(api.GetThreadResponse(duration: '0.01ms', thread: generatedThread)));
    final client = _client(defaultApi);

    final res = await client.getThread('parent-id');

    expect(res.isSuccess, isTrue);
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
  });

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

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
