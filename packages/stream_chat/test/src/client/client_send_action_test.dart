import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  test('StreamChatClient.sendAction sends the form data and returns the message the action left', () async {
    const request = api.MessageActionRequest(formData: {'image_action': 'shuffle'});

    final defaultApi = MockDefaultApi();
    when(() => defaultApi.runMessageAction(id: 'message-id', messageActionRequest: request)).thenAnswer(
      (_) async => Result.success(api.MessageActionResponse(duration: '0.01ms', message: generatedMessage)),
    );
    final client = _client(defaultApi);

    final res = await client.sendAction('message-id', {'image_action': 'shuffle'});

    final response = res.getOrNull()!;
    final message = response.message!;
    // A channel compares by identity, so it is checked on its own.
    expect(message.sharedLocation?.channel?.cid, 'messaging:general');
    expect(message.draft?.channel?.cid, 'messaging:general');
    expect(response, SendActionResponse(duration: '0.01ms', message: expectedMessageLike(message)));
    verify(() => defaultApi.runMessageAction(id: 'message-id', messageActionRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.sendAction returns no message when the action removed it', () async {
    const request = api.MessageActionRequest(formData: {'image_action': 'cancel'});

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.runMessageAction(id: 'message-id', messageActionRequest: request),
    ).thenAnswer((_) async => const Result.success(api.MessageActionResponse(duration: '0.01ms')));
    final client = _client(defaultApi);

    final res = await client.sendAction('message-id', {'image_action': 'cancel'});

    expect(res.getOrNull(), const SendActionResponse(duration: '0.01ms'));
  });

  test('StreamChatClient.sendAction returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    const request = api.MessageActionRequest(formData: {'image_action': 'send'});
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.runMessageAction(id: 'message-id', messageActionRequest: request),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.sendAction('message-id', {'image_action': 'send'});

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
