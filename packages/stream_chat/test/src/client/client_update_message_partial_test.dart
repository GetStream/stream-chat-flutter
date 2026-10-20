import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.UpdateMessagePartialRequest()));

  test(
    'StreamChatClient.updateMessagePartial sends the set and unset fields and returns the updated message',
    () async {
      const request = api.UpdateMessagePartialRequest(
        set: {'text': 'Edited', 'priority': 'low'},
        unset: ['mood'],
        skipEnrichUrl: true,
      );

      final defaultApi = MockDefaultApi();
      when(() => defaultApi.updateMessagePartial(id: 'message-id', updateMessagePartialRequest: request)).thenAnswer(
        (_) async => Result.success(api.UpdateMessagePartialResponse(duration: '0.01ms', message: generatedMessage)),
      );
      final client = _client(defaultApi);

      final res = await client.updateMessagePartial(
        'message-id',
        set: const {'text': 'Edited', 'priority': 'low'},
        unset: const ['mood'],
        skipEnrichUrl: true,
      );

      final response = res.getOrNull()!;
      final updated = response.message!;
      // A channel compares by identity, so it is checked on its own.
      expect(updated.sharedLocation?.channel?.cid, 'messaging:general');
      expect(updated.draft?.channel?.cid, 'messaging:general');
      expect(response, UpdateMessagePartialResponse(duration: '0.01ms', message: expectedMessageLike(updated)));
      verify(() => defaultApi.updateMessagePartial(id: 'message-id', updateMessagePartialRequest: request)).called(1);
      verifyNoMoreInteractions(defaultApi);
    },
  );

  test('StreamChatClient.updateMessagePartial returns no message when the response has none', () async {
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateMessagePartial(
        id: 'message-id',
        updateMessagePartialRequest: any(named: 'updateMessagePartialRequest'),
      ),
    ).thenAnswer((_) async => const Result.success(api.UpdateMessagePartialResponse(duration: '0.01ms')));
    final client = _client(defaultApi);

    final res = await client.updateMessagePartial('message-id', set: const {'text': 'Edited'});

    expect(res.getOrNull(), const UpdateMessagePartialResponse(duration: '0.01ms'));
  });

  test('StreamChatClient.updateMessagePartial returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateMessagePartial(
        id: 'message-id',
        updateMessagePartialRequest: any(named: 'updateMessagePartialRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.updateMessagePartial('message-id', set: const {'text': 'Edited'});

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
