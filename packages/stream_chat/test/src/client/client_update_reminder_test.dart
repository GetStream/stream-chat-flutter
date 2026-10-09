import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.UpdateReminderRequest()));

  test('StreamChatClient.updateReminder sends the new due date and returns the updated reminder', () async {
    final request = api.UpdateReminderRequest(remindAt: DateTime.utc(2026, 4));

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateReminder(messageId: 'message-id', updateReminderRequest: request),
    ).thenAnswer(
      (_) async => Result.success(
        api.UpdateReminderResponse(
          duration: '0.01ms',
          reminder: _generatedReminder(remindAt: DateTime.utc(2026, 4)),
        ),
      ),
    );
    final client = _client(defaultApi);

    final res = await client.updateReminder('message-id', remindAt: DateTime.utc(2026, 4));

    final response = res.getOrNull()!;
    expect(
      response,
      UpdateReminderResponse(
        duration: '0.01ms',
        reminder: _expectedReminder(
          remindAt: DateTime.utc(2026, 4),
          message: expectedMessageLike(response.reminder.message!),
        ),
      ),
    );
    verify(() => defaultApi.updateReminder(messageId: 'message-id', updateReminderRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.updateReminder sends no due date and returns the bookmark', () async {
    const request = api.UpdateReminderRequest();

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateReminder(messageId: 'message-id', updateReminderRequest: request),
    ).thenAnswer(
      (_) async => Result.success(
        api.UpdateReminderResponse(duration: '0.01ms', reminder: _generatedReminder(remindAt: null)),
      ),
    );
    final client = _client(defaultApi);

    final res = await client.updateReminder('message-id');

    final response = res.getOrNull()!;
    expect(
      response,
      UpdateReminderResponse(
        duration: '0.01ms',
        reminder: _expectedReminder(remindAt: null, message: expectedMessageLike(response.reminder.message!)),
      ),
    );
    verify(() => defaultApi.updateReminder(messageId: 'message-id', updateReminderRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.updateReminder returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.updateReminder(
        messageId: any(named: 'messageId'),
        updateReminderRequest: any(named: 'updateReminderRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.updateReminder('message-id');

    expect(res.exceptionOrNull(), error);
  });
}

// A reminder as an update answers it: with the message and the user, but no channel.
api.ReminderResponseData _generatedReminder({required DateTime? remindAt}) => api.ReminderResponseData(
  channelCid: 'messaging:general',
  createdAt: DateTime.utc(2026, 1, 7),
  expiresAt: DateTime.utc(2027),
  message: generatedMessage,
  messageId: 'message-id',
  remindAt: remindAt,
  updatedAt: DateTime.utc(2026, 1, 8),
  user: fakeUserResponse('sender'),
  userId: 'sender',
);

MessageReminder _expectedReminder({required DateTime? remindAt, required Message message}) => MessageReminder(
  channelCid: 'messaging:general',
  messageId: 'message-id',
  message: message,
  userId: 'sender',
  user: fakeUser('sender'),
  remindAt: remindAt,
  createdAt: DateTime.utc(2026, 1, 7),
  updatedAt: DateTime.utc(2026, 1, 8),
);

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
