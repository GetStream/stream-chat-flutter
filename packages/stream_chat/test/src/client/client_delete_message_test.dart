import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  test('StreamChatClient.deleteMessage sends a soft delete and returns the deleted message', () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.deleteMessage(id: 'message-id', hard: false)).thenAnswer(
      (_) async => Result.success(api.DeleteMessageResponse(duration: '0.01ms', message: generatedMessage)),
    );
    final client = _client(defaultApi);

    final res = await client.deleteMessage('message-id');

    final response = res.getOrNull()!;
    final deleted = response.message;
    // A channel compares by identity, so it is checked on its own.
    expect(deleted.sharedLocation?.channel?.cid, 'messaging:general');
    expect(deleted.draft?.channel?.cid, 'messaging:general');
    expect(response, DeleteMessageResponse(duration: '0.01ms', message: expectedMessageLike(deleted)));
    verify(() => defaultApi.deleteMessage(id: 'message-id', hard: false)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.deleteMessage sends a hard delete and returns a success', () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.deleteMessage(id: 'message-id', hard: true)).thenAnswer(
      (_) async => Result.success(api.DeleteMessageResponse(duration: '0.01ms', message: generatedMessage)),
    );
    final client = _client(defaultApi);

    final res = await client.deleteMessage('message-id', hard: true);

    expect(res.isSuccess, isTrue);
    verify(() => defaultApi.deleteMessage(id: 'message-id', hard: true)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.deleteMessageForMe sends a delete for the current user and returns a success', () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.deleteMessage(id: 'message-id', deleteForMe: true)).thenAnswer(
      (_) async => Result.success(api.DeleteMessageResponse(duration: '0.01ms', message: generatedMessage)),
    );
    final client = _client(defaultApi);

    final res = await client.deleteMessageForMe('message-id');

    expect(res.isSuccess, isTrue);
    verify(() => defaultApi.deleteMessage(id: 'message-id', deleteForMe: true)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.deleteMessage returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.deleteMessage(id: 'message-id', hard: false),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.deleteMessage('message-id');

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
