import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  test('StreamChatClient.getReplies sends the limit and every cursor and returns the replies', () async {
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.getReplies(
        parentId: 'parent-id',
        limit: 20,
        idLt: 'lt-id',
        idLte: 'lte-id',
        idGt: 'gt-id',
        idGte: 'gte-id',
        idAround: 'around-id',
      ),
    ).thenAnswer(
      (_) async => Result.success(api.GetRepliesResponse(duration: '0.01ms', messages: [generatedMessage])),
    );
    final client = _client(defaultApi);

    final res = await client.getReplies(
      'parent-id',
      limit: 20,
      lessThan: 'lt-id',
      lessThanOrEqual: 'lte-id',
      greaterThan: 'gt-id',
      greaterThanOrEqual: 'gte-id',
      idAround: 'around-id',
    );

    final response = res.getOrNull()!;
    final message = response.messages.single;
    // A channel compares by identity, so it is checked on its own.
    expect(message.sharedLocation?.channel?.cid, 'messaging:general');
    expect(message.draft?.channel?.cid, 'messaging:general');
    expect(response, GetRepliesResponse(duration: '0.01ms', messages: [expectedMessageLike(message)]));
    verify(
      () => defaultApi.getReplies(
        parentId: 'parent-id',
        limit: 20,
        idLt: 'lt-id',
        idLte: 'lte-id',
        idGt: 'gt-id',
        idGte: 'gte-id',
        idAround: 'around-id',
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.getReplies sends only the limit and returns the replies when no cursor is given', () async {
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.getReplies(parentId: 'parent-id', limit: 30),
    ).thenAnswer((_) async => const Result.success(api.GetRepliesResponse(duration: '0.01ms', messages: [])));
    final client = _client(defaultApi);

    final res = await client.getReplies('parent-id', limit: 30);

    expect(res.getOrNull(), const GetRepliesResponse(duration: '0.01ms', messages: []));
    verify(() => defaultApi.getReplies(parentId: 'parent-id', limit: 30)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.getReplies returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.getReplies(parentId: 'parent-id', limit: 30),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.getReplies('parent-id', limit: 30);

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
