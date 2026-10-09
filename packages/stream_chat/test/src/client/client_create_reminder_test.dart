import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.CreateReminderRequest()));

  test('StreamChatClient.createReminder sends the due date and returns the created reminder', () async {
    final request = api.CreateReminderRequest(remindAt: DateTime.utc(2026, 3));

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.createReminder(messageId: 'message-id', createReminderRequest: request),
    ).thenAnswer(
      (_) async => Result.success(
        api.CreateReminderResponse(
          duration: '0.01ms',
          reminder: _generatedReminder(remindAt: DateTime.utc(2026, 3)),
        ),
      ),
    );
    final client = _client(defaultApi);

    final res = await client.createReminder('message-id', remindAt: DateTime.utc(2026, 3));

    final response = res.getOrNull()!;
    final message = response.reminder.message!;
    // A channel compares by identity, so it is checked on its own.
    expect(message.sharedLocation?.channel?.cid, 'messaging:general');
    expect(message.draft?.channel?.cid, 'messaging:general');
    expect(
      response,
      CreateReminderResponse(
        duration: '0.01ms',
        reminder: _expectedReminder(expectedMessageLike(message), remindAt: DateTime.utc(2026, 3)),
      ),
    );
    verify(() => defaultApi.createReminder(messageId: 'message-id', createReminderRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.createReminder sends no due date and returns the bookmark', () async {
    const request = api.CreateReminderRequest();

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.createReminder(messageId: 'message-id', createReminderRequest: request),
    ).thenAnswer(
      (_) async => Result.success(
        api.CreateReminderResponse(duration: '0.01ms', reminder: _generatedReminder(remindAt: null)),
      ),
    );
    final client = _client(defaultApi);

    final res = await client.createReminder('message-id');

    final response = res.getOrNull()!;
    expect(
      response,
      CreateReminderResponse(
        duration: '0.01ms',
        reminder: _expectedReminder(expectedMessageLike(response.reminder.message!), remindAt: null),
      ),
    );
    verify(() => defaultApi.createReminder(messageId: 'message-id', createReminderRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test(
    'StreamChatClient.createReminder sends the message id and returns the reminder with reaction groups built from the counts',
    () async {
      const request = api.CreateReminderRequest();

      final defaultApi = MockDefaultApi();
      when(
        () => defaultApi.createReminder(messageId: 'message-id', createReminderRequest: request),
      ).thenAnswer(
        (_) async => Result.success(
          api.CreateReminderResponse(
            duration: '0.01ms',
            reminder: _generatedReminder(remindAt: null).copyWith(message: _generatedMessageWithCounts),
          ),
        ),
      );
      final client = _client(defaultApi);

      final res = await client.createReminder('message-id');

      final response = res.getOrNull()!;
      // The dates of the reactions are unknown, so the groups share one.
      final date = response.reminder.message!.reactionGroups!['love']!.firstReactionAt;
      expect(
        response,
        CreateReminderResponse(
          duration: '0.01ms',
          reminder: _expectedReminder(_expectedMessageWithCounts(reactionDate: date), remindAt: null),
        ),
      );
    },
  );

  test('StreamChatClient.createReminder returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.createReminder(
        messageId: any(named: 'messageId'),
        createReminderRequest: any(named: 'createReminderRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.createReminder('message-id');

    expect(res.exceptionOrNull(), error);
  });
}

// A reminder as a write answers it: with the message and the user, but no channel.
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

// A message without reaction groups, only the counts and scores they are built from.
final _generatedMessageWithCounts = api.MessageResponse(
  attachments: const [],
  cid: 'messaging:general',
  createdAt: DateTime.utc(2026),
  custom: const {},
  deletedReplyCount: 0,
  html: '',
  id: 'message-id',
  latestReactions: const [],
  mentionedChannel: false,
  mentionedHere: false,
  mentionedUsers: const [],
  ownReactions: const [],
  pinned: false,
  reactionCounts: const {'love': 3, 'wow': 1},
  reactionScores: const {'love': 7, 'wow': 2},
  replyCount: 0,
  restrictedVisibility: const [],
  shadowed: false,
  silent: false,
  text: 'Hello',
  type: 'regular',
  updatedAt: DateTime.utc(2026),
  user: fakeUserResponse('sender'),
);

// The message [_generatedMessageWithCounts] maps to, with the date its reaction groups share.
Message _expectedMessageWithCounts({required DateTime reactionDate}) => Message(
  id: 'message-id',
  text: 'Hello',
  mentionedChannel: false,
  mentionedHere: false,
  reactionGroups: {
    'love': ReactionGroup(count: 3, sumScores: 7, firstReactionAt: reactionDate, lastReactionAt: reactionDate),
    'wow': ReactionGroup(count: 1, sumScores: 2, firstReactionAt: reactionDate, lastReactionAt: reactionDate),
  },
  latestReactions: const [],
  ownReactions: const [],
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  user: fakeUser('sender'),
  extraData: const {'cid': 'messaging:general'},
  state: MessageState.sent,
  restrictedVisibility: const [],
  html: '',
  deletedReplyCount: 0,
);

MessageReminder _expectedReminder(Message message, {required DateTime? remindAt}) => MessageReminder(
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
