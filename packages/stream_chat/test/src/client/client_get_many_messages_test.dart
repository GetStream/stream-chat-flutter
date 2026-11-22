import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  test('StreamChatClient.getManyMessages sends the channel and the message ids and returns the messages', () async {
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.getManyMessages(type: 'messaging', id: 'general', ids: ['message-id', 'missing-id']),
    ).thenAnswer(
      (_) async => Result.success(api.GetManyMessagesResponse(duration: '0.01ms', messages: [generatedMessage])),
    );
    final client = _client(defaultApi);

    final res = await client.getManyMessages('general', 'messaging', ['message-id', 'missing-id']);

    final response = res.getOrNull()!;
    final message = response.messages.single;
    // A channel compares by identity, so it is checked on its own.
    expect(message.sharedLocation?.channel?.cid, 'messaging:general');
    expect(message.draft?.channel?.cid, 'messaging:general');
    expect(response, GetManyMessagesResponse(duration: '0.01ms', messages: [expectedMessageLike(message)]));
    verify(
      () => defaultApi.getManyMessages(type: 'messaging', id: 'general', ids: ['message-id', 'missing-id']),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.getManyMessages returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.getManyMessages(type: 'messaging', id: 'general', ids: ['message-id']),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.getManyMessages('general', 'messaging', ['message-id']);

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
