import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  test('StreamChatClient.deleteReminder sends the message id and returns the response duration', () async {
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.deleteReminder(messageId: 'message-id'),
    ).thenAnswer((_) async => const Result.success(api.DeleteReminderResponse(duration: '0.01ms')));
    final client = _client(defaultApi);

    final res = await client.deleteReminder('message-id');

    expect(res.getOrNull(), const DeleteReminderResponse(duration: '0.01ms'));
    verify(() => defaultApi.deleteReminder(messageId: 'message-id')).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.deleteReminder returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.deleteReminder(messageId: any(named: 'messageId')),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.deleteReminder('message-id');

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
