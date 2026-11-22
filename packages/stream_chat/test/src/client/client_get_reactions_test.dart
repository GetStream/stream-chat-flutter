import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  test('StreamChatClient.getReactions sends the limit and offset and returns the page', () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.getReactions(id: 'message-id', limit: 20, offset: 40)).thenAnswer(
      (_) async => Result.success(api.GetReactionsResponse(duration: '0.01ms', reactions: [generatedReaction])),
    );
    final client = _client(defaultApi);

    final res = await client.getReactions('message-id', limit: 20, offset: 40);

    expect(res.getOrNull(), GetReactionsResponse(duration: '0.01ms', reactions: [expectedReaction]));
    verify(() => defaultApi.getReactions(id: 'message-id', limit: 20, offset: 40)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test(
    'StreamChatClient.getReactions sends no limit or offset when none is given and returns the empty page',
    () async {
      final defaultApi = MockDefaultApi();
      when(
        () => defaultApi.getReactions(id: 'message-id'),
      ).thenAnswer((_) async => const Result.success(api.GetReactionsResponse(duration: '0.01ms', reactions: [])));
      final client = _client(defaultApi);

      final res = await client.getReactions('message-id');

      expect(res.getOrNull(), const GetReactionsResponse(duration: '0.01ms', reactions: []));
      verify(() => defaultApi.getReactions(id: 'message-id')).called(1);
      verifyNoMoreInteractions(defaultApi);
    },
  );

  test('StreamChatClient.getReactions returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.getReactions(id: 'message-id')).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.getReactions('message-id');

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
