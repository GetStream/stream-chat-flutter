import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  test('StreamChatClient.deleteDraft sends the channel and returns a success', () async {
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.deleteDraft(type: 'messaging', id: 'general'),
    ).thenAnswer((_) async => const Result.success(api.DurationResponse(duration: '0.01ms')));
    final client = _client(defaultApi);

    final res = await client.deleteDraft('general', 'messaging');

    expect(res.isSuccess, isTrue);
    verify(() => defaultApi.deleteDraft(type: 'messaging', id: 'general')).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.deleteDraft sends the parent id to delete the draft of a thread', () async {
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.deleteDraft(type: 'messaging', id: 'general', parentId: 'parent-id'),
    ).thenAnswer((_) async => const Result.success(api.DurationResponse(duration: '0.01ms')));
    final client = _client(defaultApi);

    final res = await client.deleteDraft('general', 'messaging', parentId: 'parent-id');

    expect(res.isSuccess, isTrue);
    verify(() => defaultApi.deleteDraft(type: 'messaging', id: 'general', parentId: 'parent-id')).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.deleteDraft returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.deleteDraft(
        type: any(named: 'type'),
        id: any(named: 'id'),
        parentId: any(named: 'parentId'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.deleteDraft('general', 'messaging');

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
