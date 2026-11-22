import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.SendReactionRequest(reaction: api.ReactionRequest(type: 'like'))));

  test(
    'StreamChatClient.sendReaction sends the emoji code in the custom data and returns the sent reaction',
    () async {
      const request = api.SendReactionRequest(
        reaction: api.ReactionRequest(type: 'love', score: 2, custom: {'mood': 'happy', 'emoji_code': '❤️'}),
        skipPush: true,
        enforceUnique: true,
      );

      final defaultApi = MockDefaultApi();
      when(() => defaultApi.sendReaction(id: 'message-id', sendReactionRequest: request)).thenAnswer(
        (_) async => Result.success(
          api.SendReactionResponse(duration: '0.01ms', message: generatedMessage, reaction: generatedReaction),
        ),
      );
      final client = _client(defaultApi);

      final res = await client.sendReaction(
        'message-id',
        // The message, user and dates stay out of the request.
        Reaction(
          messageId: 'message-id',
          type: 'love',
          user: User(id: 'reactor-id'),
          score: 2,
          emojiCode: '❤️',
          createdAt: DateTime.utc(2026, 1, 5),
          updatedAt: DateTime.utc(2026, 1, 6),
          custom: const {'mood': 'happy'},
        ),
        skipPush: true,
        enforceUnique: true,
      );

      final response = res.getOrNull()!;
      final message = response.message;
      // A channel compares by identity, so it is checked on its own.
      expect(message.sharedLocation?.channel?.cid, 'messaging:general');
      expect(message.draft?.channel?.cid, 'messaging:general');
      expect(
        response,
        SendReactionResponse(duration: '0.01ms', message: expectedMessageLike(message), reaction: expectedReaction),
      );
      verify(() => defaultApi.sendReaction(id: 'message-id', sendReactionRequest: request)).called(1);
      verifyNoMoreInteractions(defaultApi);
    },
  );

  test('StreamChatClient.sendReaction sends a score of one, with push on and duplicates allowed, by default', () async {
    const request = api.SendReactionRequest(
      reaction: api.ReactionRequest(type: 'like', score: 1, custom: {}),
      skipPush: false,
      enforceUnique: false,
    );

    final defaultApi = MockDefaultApi();
    when(() => defaultApi.sendReaction(id: 'message-id', sendReactionRequest: request)).thenAnswer(
      (_) async => Result.success(
        api.SendReactionResponse(duration: '0.01ms', message: generatedMessage, reaction: generatedReaction),
      ),
    );
    final client = _client(defaultApi);

    final res = await client.sendReaction('message-id', Reaction(type: 'like'));

    expect(res.getOrNull()?.reaction, expectedReaction);
    verify(() => defaultApi.sendReaction(id: 'message-id', sendReactionRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.sendReaction sends the emoji code over a custom entry of the same name', () async {
    const request = api.SendReactionRequest(
      reaction: api.ReactionRequest(type: 'love', score: 1, custom: {'emoji_code': '😍'}),
      skipPush: false,
      enforceUnique: false,
    );

    final defaultApi = MockDefaultApi();
    when(() => defaultApi.sendReaction(id: 'message-id', sendReactionRequest: request)).thenAnswer(
      (_) async => Result.success(
        api.SendReactionResponse(duration: '0.01ms', message: generatedMessage, reaction: generatedReaction),
      ),
    );
    final client = _client(defaultApi);

    await client.sendReaction(
      'message-id',
      Reaction(type: 'love', emojiCode: '😍', custom: const {'emoji_code': '❤️'}),
    );

    verify(() => defaultApi.sendReaction(id: 'message-id', sendReactionRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.sendReaction returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.sendReaction(
        id: 'message-id',
        sendReactionRequest: any(named: 'sendReactionRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.sendReaction('message-id', Reaction(type: 'like'));

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
