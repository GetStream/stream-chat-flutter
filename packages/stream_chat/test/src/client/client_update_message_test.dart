import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.UpdateMessageRequest(message: api.MessageRequest())));

  test('StreamChatClient.updateMessage sends the message and returns the updated message', () async {
    final message = Message(id: 'message-id', text: 'Edited', pinned: true, custom: const {'priority': 'low'});
    const request = api.UpdateMessageRequest(
      message: api.MessageRequest(
        id: 'message-id',
        text: 'Edited',
        type: api.MessageRequestType.regular,
        attachments: [],
        mentionedUsers: [],
        silent: false,
        pinned: true,
        custom: {'priority': 'low'},
      ),
      skipPush: true,
      skipEnrichUrl: false,
    );

    final defaultApi = MockDefaultApi();
    when(() => defaultApi.updateMessage(id: 'message-id', updateMessageRequest: request)).thenAnswer(
      (_) async => Result.success(api.UpdateMessageResponse(duration: '0.01ms', message: generatedMessage)),
    );
    final client = _client(defaultApi);

    final res = await client.updateMessage(message, skipPush: true, skipEnrichUrl: false);

    final response = res.getOrNull()!;
    final updated = response.message;
    // A channel compares by identity, so it is checked on its own.
    expect(updated.sharedLocation?.channel?.cid, 'messaging:general');
    expect(updated.draft?.channel?.cid, 'messaging:general');
    expect(response, UpdateMessageResponse(duration: '0.01ms', message: expectedMessageLike(updated)));
    verify(() => defaultApi.updateMessage(id: 'message-id', updateMessageRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.updateMessage returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateMessage(
        id: 'message-id',
        updateMessageRequest: any(named: 'updateMessageRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.updateMessage(Message(id: 'message-id', text: 'Edited'));

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
