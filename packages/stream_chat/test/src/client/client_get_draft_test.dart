import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  test("StreamChatClient.getDraft sends the channel and returns the channel's draft", () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.getDraft(type: 'messaging', id: 'general')).thenAnswer(
      (_) async => Result.success(api.GetDraftResponse(duration: '0.01ms', draft: _generatedFetchedDraft)),
    );
    final client = _client(defaultApi);

    final res = await client.getDraft('general', 'messaging');

    final response = res.getOrNull()!;
    expect(
      response,
      GetDraftResponse(
        duration: '0.01ms',
        draft: _expectedFetchedDraft(attachmentId: response.draft.message.attachments.single.id),
      ),
    );
    verify(() => defaultApi.getDraft(type: 'messaging', id: 'general')).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.getDraft sends the parent id to fetch the draft of a thread', () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.getDraft(type: 'messaging', id: 'general', parentId: 'message-id')).thenAnswer(
      (_) async => Result.success(api.GetDraftResponse(duration: '0.01ms', draft: _generatedFetchedDraft)),
    );
    final client = _client(defaultApi);

    final res = await client.getDraft('general', 'messaging', parentId: 'message-id');

    expect(res.isSuccess, isTrue);
    verify(() => defaultApi.getDraft(type: 'messaging', id: 'general', parentId: 'message-id')).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.getDraft returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.getDraft(
        type: any(named: 'type'),
        id: any(named: 'id'),
        parentId: any(named: 'parentId'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.getDraft('general', 'messaging');

    expect(res.exceptionOrNull(), error);
  });
}

// A fetched draft carries the message it quotes, but not its channel or parent message.
final _generatedFetchedDraft = generatedDraft.copyWith(channel: null, parentMessage: null);

Draft _expectedFetchedDraft({required String attachmentId}) {
  final draft = expectedDraft(attachmentId: attachmentId, channel: null);
  return Draft(
    channelCid: draft.channelCid,
    createdAt: draft.createdAt,
    message: draft.message,
    parentId: draft.parentId,
    quotedMessage: draft.quotedMessage,
  );
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
