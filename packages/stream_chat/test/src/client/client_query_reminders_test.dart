import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.QueryRemindersRequest()));

  test('StreamChatClient.queryReminders sends the filter, sort, limit and cursor and returns the page', () async {
    const request = api.QueryRemindersRequest(
      filter: {
        'channel_cid': {r'$eq': 'messaging:general'},
      },
      sort: [
        api.SortParamRequest(field: 'remind_at', direction: 1),
        api.SortParamRequest(field: 'message_id', direction: -1),
      ],
      limit: 25,
      next: 'next-cursor',
    );

    final defaultApi = MockDefaultApi();
    when(() => defaultApi.queryReminders(queryRemindersRequest: request)).thenAnswer(
      (_) async => Result.success(
        api.QueryRemindersResponse(
          duration: '0.01ms',
          next: 'later-cursor',
          prev: 'earlier-cursor',
          reminders: [_generatedReminder, _generatedBookmark],
        ),
      ),
    );
    final client = _client(defaultApi);

    final res = await client.queryReminders(
      filter: MessageReminderFilter.equal(MessageReminderFilterField.channelCid, 'messaging:general'),
      sort: [
        MessageReminderSort.asc(MessageReminderSortField.remindAt),
        MessageReminderSort.desc(MessageReminderSortField.messageId),
      ],
      limit: 25,
      next: 'next-cursor',
    );

    final response = res.getOrNull()!;
    final [reminder, bookmark] = response.reminders;
    // A channel compares by identity, so it is checked on its own.
    expect([reminder.channel?.cid, bookmark.channel?.cid], ['messaging:general', 'messaging:general']);
    expect(
      response,
      QueryRemindersResponse(
        duration: '0.01ms',
        reminders: [_expectedReminder(reminder), _expectedBookmark(bookmark)],
        next: 'later-cursor',
        prev: 'earlier-cursor',
      ),
    );
    verify(() => defaultApi.queryReminders(queryRemindersRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.queryReminders sends the default limit of ten and returns the empty page', () async {
    const request = api.QueryRemindersRequest(limit: 10);

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.queryReminders(queryRemindersRequest: request),
    ).thenAnswer((_) async => const Result.success(api.QueryRemindersResponse(duration: '0.01ms', reminders: [])));
    final client = _client(defaultApi);

    final res = await client.queryReminders();

    expect(res.getOrNull(), const QueryRemindersResponse(duration: '0.01ms', reminders: []));
    verify(() => defaultApi.queryReminders(queryRemindersRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.queryReminders sends the previous-page cursor and returns the earlier page', () async {
    const request = api.QueryRemindersRequest(limit: 10, prev: 'prev-cursor');

    final defaultApi = MockDefaultApi();
    when(() => defaultApi.queryReminders(queryRemindersRequest: request)).thenAnswer(
      (_) async => Result.success(
        api.QueryRemindersResponse(duration: '0.01ms', next: 'next-cursor', reminders: [_generatedBookmark]),
      ),
    );
    final client = _client(defaultApi);

    final res = await client.queryReminders(prev: 'prev-cursor');

    final response = res.getOrNull()!;
    final bookmark = response.reminders.single;
    // A channel compares by identity, so it is checked on its own.
    expect(bookmark.channel?.cid, 'messaging:general');
    expect(
      response,
      QueryRemindersResponse(duration: '0.01ms', reminders: [_expectedBookmark(bookmark)], next: 'next-cursor'),
    );
    verify(() => defaultApi.queryReminders(queryRemindersRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.queryReminders returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.queryReminders(queryRemindersRequest: any(named: 'queryRemindersRequest')),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.queryReminders();

    expect(res.exceptionOrNull(), error);
  });
}

// Reminders as a query answers them: with their channel, message and user.
final _generatedReminder = api.ReminderResponseData(
  channel: _generatedChannel,
  channelCid: 'messaging:general',
  createdAt: DateTime.utc(2026, 1, 7),
  expiresAt: DateTime.utc(2027),
  message: generatedMessage,
  messageId: 'message-id',
  remindAt: DateTime.utc(2026, 3),
  updatedAt: DateTime.utc(2026, 1, 8),
  user: fakeUserResponse('sender'),
  userId: 'sender',
);

// A reminder with no due date.
final _generatedBookmark = api.ReminderResponseData(
  channel: _generatedChannel,
  channelCid: 'messaging:general',
  createdAt: DateTime.utc(2026, 2, 7),
  message: generatedLeafMessage('other-message-id'),
  messageId: 'other-message-id',
  updatedAt: DateTime.utc(2026, 2, 8),
  user: fakeUserResponse('sender'),
  userId: 'sender',
);

final _generatedChannel = api.ChannelResponse(
  cid: 'messaging:general',
  createdAt: DateTime.utc(2026),
  custom: const {},
  disabled: false,
  frozen: false,
  id: 'general',
  type: 'messaging',
  updatedAt: DateTime.utc(2026),
);

// The reminder [_generatedReminder] maps to. Its channel compares by identity, and its message's attachment ids are
// created locally, so both are read off [actual].
MessageReminder _expectedReminder(MessageReminder actual) => MessageReminder(
  channelCid: 'messaging:general',
  channel: actual.channel,
  messageId: 'message-id',
  message: expectedMessageLike(actual.message!),
  userId: 'sender',
  user: fakeUser('sender'),
  remindAt: DateTime.utc(2026, 3),
  createdAt: DateTime.utc(2026, 1, 7),
  updatedAt: DateTime.utc(2026, 1, 8),
);

// The reminder [_generatedBookmark] maps to, with its channel read off [actual].
MessageReminder _expectedBookmark(MessageReminder actual) => MessageReminder(
  channelCid: 'messaging:general',
  channel: actual.channel,
  messageId: 'other-message-id',
  message: expectedLeafMessage('other-message-id'),
  userId: 'sender',
  user: fakeUser('sender'),
  createdAt: DateTime.utc(2026, 2, 7),
  updatedAt: DateTime.utc(2026, 2, 8),
);

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
