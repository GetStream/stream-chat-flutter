import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  test('StreamChatClient.getMessage sends the message id and returns the message with its channel', () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.getMessage(id: 'message-id')).thenAnswer(
      (_) async => Result.success(api.GetMessageResponse(duration: '0.01ms', message: generatedMessageWithChannel)),
    );
    final client = _client(defaultApi);

    final res = await client.getMessage('message-id');

    final response = res.getOrNull()!;
    final message = response.message;
    // A channel compares by identity, so it is checked on its own.
    expect(response.channel.cid, 'messaging:general');
    expect(message.sharedLocation?.channel?.cid, 'messaging:general');
    expect(message.draft?.channel?.cid, 'messaging:general');
    expect(
      response,
      GetMessageResponse(duration: '0.01ms', message: expectedMessageLike(message), channel: response.channel),
    );
    verify(() => defaultApi.getMessage(id: 'message-id')).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.getMessage returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.getMessage(id: 'message-id')).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.getMessage('message-id');

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
