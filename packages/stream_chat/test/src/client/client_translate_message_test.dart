import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  test('StreamChatClient.translateMessage sends the language and returns the translated message', () async {
    const request = api.TranslateMessageRequest(language: api.TranslateMessageRequestLanguage.zhTW);

    final defaultApi = MockDefaultApi();
    when(() => defaultApi.translateMessage(id: 'message-id', translateMessageRequest: request)).thenAnswer(
      (_) async => Result.success(api.TranslateMessageResponse(duration: '0.01ms', message: generatedMessage)),
    );
    final client = _client(defaultApi);

    final res = await client.translateMessage('message-id', TranslationLanguage.zhTW);

    final response = res.getOrNull()!;
    final message = response.message;
    // A channel compares by identity, so it is checked on its own.
    expect(message.sharedLocation?.channel?.cid, 'messaging:general');
    expect(message.draft?.channel?.cid, 'messaging:general');
    expect(response, TranslateMessageResponse(duration: '0.01ms', message: expectedMessageLike(message)));
    verify(() => defaultApi.translateMessage(id: 'message-id', translateMessageRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.translateMessage returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    const request = api.TranslateMessageRequest(language: api.TranslateMessageRequestLanguage.fr);
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.translateMessage(id: 'message-id', translateMessageRequest: request),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.translateMessage('message-id', TranslationLanguage.fr);

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
