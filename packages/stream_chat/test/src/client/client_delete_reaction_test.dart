import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  test(
    'StreamChatClient.deleteReaction sends the message id and reaction type and returns the removed reaction',
    () async {
      final defaultApi = MockDefaultApi();
      when(() => defaultApi.deleteReaction(id: 'message-id', type: 'love')).thenAnswer(
        (_) async => Result.success(
          api.DeleteReactionResponse(duration: '0.01ms', message: generatedMessage, reaction: generatedReaction),
        ),
      );
      final client = _client(defaultApi);

      final res = await client.deleteReaction('message-id', 'love');

      final response = res.getOrNull()!;
      final message = response.message;
      // A channel compares by identity, so it is checked on its own.
      expect(message.sharedLocation?.channel?.cid, 'messaging:general');
      expect(message.draft?.channel?.cid, 'messaging:general');
      expect(
        response,
        DeleteReactionResponse(duration: '0.01ms', message: expectedMessageLike(message), reaction: expectedReaction),
      );
      verify(() => defaultApi.deleteReaction(id: 'message-id', type: 'love')).called(1);
      verifyNoMoreInteractions(defaultApi);
    },
  );

  test('StreamChatClient.deleteReaction returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.deleteReaction(id: 'message-id', type: 'love'),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.deleteReaction('message-id', 'love');

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
