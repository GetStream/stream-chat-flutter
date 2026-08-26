// ignore_for_file: cascade_invocations

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/client/channel_state_mutations.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';

class MockChannelClientState extends Mock implements ChannelClientState {}

void main() {
  late Channel channel;
  late MockStreamChatClient client;
  late MockChannelClientState state;
  late ChannelStateMutations mutations;

  late List<(User, Event)> upsertTypingEventCalls;
  late List<User> removeTypingEventCalls;
  late List<(User, int?)> removeWatcherCalls;
  late List<Member> updateMemberCalls;
  late List<(String, bool, DateTime?)> deleteMessagesFromUserCalls;

  // Matches the default current user of [FakeClientState].
  const currentUserId = 'test-user-id';
  final otherUser = User(id: 'other-user');

  setUpAll(() {
    registerFallbackValue(FakeMessage());
    registerFallbackValue(FakeChannelState());
    registerFallbackValue(0);
  });

  setUp(() {
    client = MockStreamChatClient();
    state = MockChannelClientState();

    when(() => client.logger).thenReturn(MockLogger());
    when(() => client.state).thenReturn(FakeClientState());

    // A real channel (without an attached state) so that the capability and
    // unread-count lookups the mutations rely on resolve to their defaults.
    channel = Channel(client, 'messaging', 'test');

    upsertTypingEventCalls = [];
    removeTypingEventCalls = [];
    removeWatcherCalls = [];
    updateMemberCalls = [];
    deleteMessagesFromUserCalls = [];

    mutations = ChannelStateMutations(
      channel: channel,
      state: state,
      upsertTypingEvent: (user, event) => upsertTypingEventCalls.add((user, event)),
      removeTypingEvent: removeTypingEventCalls.add,
      removeWatcher: (watcher, {watcherCount}) => removeWatcherCalls.add((watcher, watcherCount)),
      updateMember: updateMemberCalls.add,
      deleteMessagesFromUser: ({required userId, hardDelete = false, deletedAt}) async {
        deleteMessagesFromUserCalls.add((userId, hardDelete, deletedAt));
      },
    );
  });

  ChannelState stubChannelState(ChannelState channelState) {
    when(() => state.channelState).thenReturn(channelState);
    return channelState;
  }

  ChannelState capturedChannelState() {
    return verify(() => state.updateChannelState(captureAny())).captured.single as ChannelState;
  }

  group('typing', () {
    test('onTypingStart records the typing event for the user', () {
      final event = Event(type: EventType.typingStart, user: otherUser);

      mutations.onTypingStart(otherUser, event);

      expect(upsertTypingEventCalls, [(otherUser, event)]);
    });

    test('onTypingStop clears the typing event for the user', () {
      mutations.onTypingStop(otherUser);

      expect(removeTypingEventCalls, [otherUser]);
    });
  });

  group('messages', () {
    final message = Message(id: 'message-id', user: otherUser);

    test('onMessageNew adds the message', () {
      mutations.onMessageNew(message);

      verify(() => state.addNewMessage(message)).called(1);
      verifyNever(() => state.updateChannelState(any()));
    });

    test('onMessageNew also applies the watcher count when provided', () {
      stubChannelState(ChannelState(channel: ChannelModel(cid: 'messaging:test')));

      mutations.onMessageNew(message, watcherCount: 7);

      verify(() => state.addNewMessage(message)).called(1);
      expect(capturedChannelState().watcherCount, 7);
    });

    test('onMessageDeleted soft-deletes without touching the unread count', () {
      mutations.onMessageDeleted(message);

      verify(() => state.deleteMessage(message, hardDelete: false)).called(1);
      verifyNever(() => state.unreadCount = any());
    });

    test('onMessageDeleted decrements the local unread count on hard delete', () {
      client.isLocalUnreadCountEnabled = true;
      when(() => state.unreadCount).thenReturn(5);

      mutations.onMessageDeleted(message, hardDelete: true);

      verify(() => state.unreadCount = 4).called(1);
      verify(() => state.deleteMessage(message, hardDelete: true)).called(1);
    });

    test('onMessageDeleted never decrements the unread count below zero', () {
      client.isLocalUnreadCountEnabled = true;
      when(() => state.unreadCount).thenReturn(0);

      mutations.onMessageDeleted(message, hardDelete: true);

      verify(() => state.unreadCount = 0).called(1);
    });

    test('onMessageDeleted skips the unread count on server-driven channels', () {
      client.isLocalUnreadCountEnabled = false;

      mutations.onMessageDeleted(message, hardDelete: true);

      verifyNever(() => state.unreadCount = any());
      verify(() => state.deleteMessage(message, hardDelete: true)).called(1);
    });

    test('onMessageUpdated applies the message without upserting', () {
      mutations.onMessageUpdated(message);

      verify(() => state.updateMessage(message, upsert: false)).called(1);
    });
  });

  group('drafts', () {
    final draft = Draft(
      channelCid: 'messaging:test',
      createdAt: DateTime.now(),
      message: DraftMessage(text: 'draft'),
    );

    test('onDraftUpdated applies the draft', () {
      mutations.onDraftUpdated(draft);

      verify(() => state.updateDraft(draft)).called(1);
    });

    test('onDraftDeleted removes the draft', () {
      mutations.onDraftDeleted(draft);

      verify(() => state.deleteDraft(draft)).called(1);
    });
  });

  group('reactions', () {
    final ownReaction = Reaction(
      type: 'like',
      messageId: 'message-id',
      userId: currentUserId,
      createdAt: DateTime.now(),
    );

    Message capturedMessage() {
      return verify(() => state.updateMessage(captureAny())).captured.single as Message;
    }

    test('onReactionNew adds an own reaction of the current user', () {
      final existing = Message(id: 'message-id', user: otherUser);
      when(() => state.messages).thenReturn([existing]);
      when(() => state.threads).thenReturn(const {});

      final eventMessage = Message(id: 'message-id', user: otherUser, latestReactions: [ownReaction]);
      mutations.onReactionNew(eventMessage, ownReaction);

      expect(capturedMessage().ownReactions, [ownReaction]);
    });

    test('onReactionNew preserves own reactions for other users', () {
      final existing = Message(id: 'message-id', user: otherUser, ownReactions: [ownReaction]);
      when(() => state.messages).thenReturn([existing]);
      when(() => state.threads).thenReturn(const {});

      final theirReaction = Reaction(
        type: 'love',
        messageId: 'message-id',
        userId: otherUser.id,
        createdAt: DateTime.now(),
      );
      final eventMessage = Message(id: 'message-id', user: otherUser);
      mutations.onReactionNew(eventMessage, theirReaction);

      expect(capturedMessage().ownReactions, [ownReaction]);
    });

    test('onReactionNew finds the message in a thread', () {
      final existing = Message(id: 'message-id', parentId: 'parent-id', user: otherUser);
      when(() => state.messages).thenReturn([]);
      when(() => state.threads).thenReturn({
        'parent-id': [existing],
      });

      final eventMessage = Message(id: 'message-id', parentId: 'parent-id', user: otherUser);
      mutations.onReactionNew(eventMessage, ownReaction);

      expect(capturedMessage().ownReactions, [ownReaction]);
    });

    test('onReactionNew ignores reactions to unknown messages', () {
      when(() => state.messages).thenReturn([]);
      when(() => state.threads).thenReturn(const {});

      mutations.onReactionNew(Message(id: 'message-id'), ownReaction);

      verifyNever(() => state.updateMessage(any()));
    });

    test('onReactionUpdated replaces own reactions of the current user', () {
      final oldReaction = Reaction(
        type: 'love',
        messageId: 'message-id',
        userId: currentUserId,
        createdAt: DateTime.now(),
      );
      final existing = Message(id: 'message-id', user: otherUser, ownReactions: [oldReaction]);
      when(() => state.messages).thenReturn([existing]);
      when(() => state.threads).thenReturn(const {});

      mutations.onReactionUpdated(Message(id: 'message-id', user: otherUser), ownReaction);

      expect(capturedMessage().ownReactions, [ownReaction]);
    });

    test('onReactionDeleted removes the own reaction of the current user', () {
      final existing = Message(id: 'message-id', user: otherUser, ownReactions: [ownReaction]);
      when(() => state.messages).thenReturn([existing]);
      when(() => state.threads).thenReturn(const {});

      mutations.onReactionDeleted(Message(id: 'message-id', user: otherUser), ownReaction);

      expect(capturedMessage().ownReactions, isEmpty);
    });
  });

  group('polls', () {
    const pollId = 'poll-id';

    Poll createPoll({
      String name = 'Favorite color?',
      List<PollVote> latestAnswers = const [],
      List<PollVote> ownVotesAndAnswers = const [],
      bool isClosed = false,
    }) {
      return Poll(
        id: pollId,
        name: name,
        options: const [PollOption(id: 'option-a', text: 'A')],
        latestAnswers: latestAnswers,
        ownVotesAndAnswers: ownVotesAndAnswers,
        isClosed: isClosed,
      );
    }

    PollVote createVote(String id, {String? userId, String optionId = 'option-a'}) {
      return PollVote(
        id: id,
        pollId: pollId,
        userId: userId ?? currentUserId,
        optionId: optionId,
      );
    }

    Message capturedMessage() {
      return verify(() => state.updateMessage(captureAny())).captured.single as Message;
    }

    void seedPollMessage(Poll poll) {
      final message = Message(id: 'poll-message-id', poll: poll);
      when(() => state.messages).thenReturn([message]);
      when(() => state.threads).thenReturn(const {});
    }

    test('onPollCreated adds the poll message', () {
      final message = Message(id: 'poll-message-id', poll: createPoll());

      mutations.onPollCreated(message);

      verify(() => state.addNewMessage(message)).called(1);
    });

    test('onPollUpdated applies the poll preserving known answers and votes', () {
      final answer = createVote('answer-1');
      final ownVote = createVote('vote-1');
      seedPollMessage(createPoll(latestAnswers: [answer], ownVotesAndAnswers: [ownVote]));

      mutations.onPollUpdated(createPoll(name: 'Updated?'));

      final poll = capturedMessage().poll!;
      expect(poll.name, 'Updated?');
      expect(poll.latestAnswers, [answer]);
      expect(poll.ownVotesAndAnswers, [ownVote]);
    });

    test('onPollUpdated ignores polls without a matching message', () {
      when(() => state.messages).thenReturn([]);
      when(() => state.threads).thenReturn(const {});

      mutations.onPollUpdated(createPoll());

      verifyNever(() => state.updateMessage(any()));
    });

    test('onPollClosed closes the known poll', () {
      seedPollMessage(createPoll());

      mutations.onPollClosed(createPoll(isClosed: true));

      final poll = capturedMessage().poll!;
      expect(poll.isClosed, isTrue);
      expect(poll.name, 'Favorite color?');
    });

    test('onPollAnswerCasted appends the answer and tracks own answers', () {
      final existingAnswer = createVote('answer-1', userId: otherUser.id);
      seedPollMessage(createPoll(latestAnswers: [existingAnswer]));

      final castedAnswer = createVote('answer-2');
      mutations.onPollAnswerCasted(createPoll(), castedAnswer);

      final poll = capturedMessage().poll!;
      expect(poll.latestAnswers, [existingAnswer, castedAnswer]);
      expect(poll.ownVotesAndAnswers, [castedAnswer]);
    });

    test('onPollAnswerCasted skips own tracking for other users', () {
      seedPollMessage(createPoll());

      final castedAnswer = createVote('answer-2', userId: otherUser.id);
      mutations.onPollAnswerCasted(createPoll(), castedAnswer);

      final poll = capturedMessage().poll!;
      expect(poll.latestAnswers, [castedAnswer]);
      expect(poll.ownVotesAndAnswers, isEmpty);
    });

    test('onPollVoteCasted tracks own votes preserving known answers', () {
      final answer = createVote('answer-1', userId: otherUser.id);
      seedPollMessage(createPoll(latestAnswers: [answer]));

      final vote = createVote('vote-1');
      mutations.onPollVoteCasted(createPoll(), vote);

      final poll = capturedMessage().poll!;
      expect(poll.latestAnswers, [answer]);
      expect(poll.ownVotesAndAnswers, [vote]);
    });

    test('onPollVoteChanged replaces the own vote with the same id', () {
      final oldVote = createVote('vote-1');
      seedPollMessage(createPoll(ownVotesAndAnswers: [oldVote]));

      final changedVote = createVote('vote-1', optionId: 'option-b');
      mutations.onPollVoteChanged(createPoll(), changedVote);

      final poll = capturedMessage().poll!;
      expect(poll.ownVotesAndAnswers, [changedVote]);
    });

    test('onPollAnswerRemoved removes the answer from both lists', () {
      final answer = createVote('answer-1');
      seedPollMessage(createPoll(latestAnswers: [answer], ownVotesAndAnswers: [answer]));

      mutations.onPollAnswerRemoved(createPoll(), answer);

      final poll = capturedMessage().poll!;
      expect(poll.latestAnswers, isEmpty);
      expect(poll.ownVotesAndAnswers, isEmpty);
    });

    test('onPollVoteRemoved removes the own vote preserving known answers', () {
      final answer = createVote('answer-1', userId: otherUser.id);
      final vote = createVote('vote-1');
      seedPollMessage(createPoll(latestAnswers: [answer], ownVotesAndAnswers: [vote]));

      mutations.onPollVoteRemoved(createPoll(), vote);

      final poll = capturedMessage().poll!;
      expect(poll.latestAnswers, [answer]);
      expect(poll.ownVotesAndAnswers, isEmpty);
    });
  });

  group('reads', () {
    test('onMessageRead resets the unread count preserving delivery info', () {
      final deliveredAt = DateTime.now();
      final existingRead = Read(
        user: otherUser,
        lastRead: DateTime.now().subtract(const Duration(days: 1)),
        unreadMessages: 5,
        lastDeliveredAt: deliveredAt,
        lastDeliveredMessageId: 'delivered-id',
      );
      when(() => state.read).thenReturn([existingRead]);

      final lastRead = DateTime.now();
      mutations.onMessageRead(otherUser, lastRead: lastRead, lastReadMessageId: 'read-id');

      final expectedRead = Read(
        user: otherUser,
        lastRead: lastRead,
        unreadMessages: 0,
        lastReadMessageId: 'read-id',
        lastDeliveredAt: deliveredAt,
        lastDeliveredMessageId: 'delivered-id',
      );
      verify(() => state.updateRead([expectedRead])).called(1);
    });

    test('onNotificationMarkUnread applies the unread mark preserving delivery info', () {
      final deliveredAt = DateTime.now();
      final existingRead = Read(
        user: otherUser,
        lastRead: DateTime.now().subtract(const Duration(days: 1)),
        lastDeliveredAt: deliveredAt,
      );
      when(() => state.read).thenReturn([existingRead]);

      final lastRead = DateTime.now();
      mutations.onNotificationMarkUnread(
        otherUser,
        lastRead: lastRead,
        unreadMessages: 3,
        lastReadMessageId: 'read-id',
      );

      final expectedRead = Read(
        user: otherUser,
        lastRead: lastRead,
        unreadMessages: 3,
        lastReadMessageId: 'read-id',
        lastDeliveredAt: deliveredAt,
      );
      verify(() => state.updateRead([expectedRead])).called(1);
    });

    test('onMessageDelivered applies the delivery preserving read info', () {
      final lastRead = DateTime.now().subtract(const Duration(days: 1));
      final existingRead = Read(
        user: otherUser,
        lastRead: lastRead,
        unreadMessages: 2,
        lastReadMessageId: 'read-id',
      );
      when(() => state.read).thenReturn([existingRead]);

      final deliveredAt = DateTime.now();
      mutations.onMessageDelivered(
        otherUser,
        lastDeliveredAt: deliveredAt,
        lastDeliveredMessageId: 'delivered-id',
      );

      final expectedRead = Read(
        user: otherUser,
        lastRead: lastRead,
        unreadMessages: 2,
        lastReadMessageId: 'read-id',
        lastDeliveredAt: deliveredAt,
        lastDeliveredMessageId: 'delivered-id',
      );
      verify(() => state.updateRead([expectedRead])).called(1);
    });

    test('onMessageDelivered falls back to the epoch without a current read', () {
      when(() => state.read).thenReturn([]);

      mutations.onMessageDelivered(otherUser);

      final expectedRead = Read(
        user: otherUser,
        lastRead: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      );
      verify(() => state.updateRead([expectedRead])).called(1);
    });
  });

  group('channel', () {
    test('onChannelTruncated truncates before applying the system message', () {
      final systemMessage = Message(id: 'system-id');

      mutations.onChannelTruncated(message: systemMessage);

      verifyInOrder([
        () => state.truncate(),
        () => state.updateMessage(systemMessage),
      ]);
    });

    test('onChannelTruncated only truncates without a system message', () {
      mutations.onChannelTruncated();

      verify(() => state.truncate()).called(1);
      verifyNever(() => state.updateMessage(any()));
    });

    test('onChannelUpdated merges the channel and replaces the members', () {
      final member = Member(user: otherUser);
      stubChannelState(ChannelState(channel: ChannelModel(cid: 'messaging:test')));

      mutations.onChannelUpdated(
        ChannelModel(cid: 'messaging:test', frozen: true, members: [member]),
      );

      final updated = capturedChannelState();
      expect(updated.channel?.frozen, isTrue);
      expect(updated.members, [member]);
    });

    test('onChannelMessageCount updates the message count', () {
      stubChannelState(ChannelState(channel: ChannelModel(cid: 'messaging:test')));

      mutations.onChannelMessageCount(42);

      expect(capturedChannelState().channel?.messageCount, 42);
    });

    test('onChannelPushPreferenceUpdated applies the preferences', () {
      const pushPreference = ChannelPushPreference(chatLevel: ChatLevel.mentions);
      stubChannelState(ChannelState(channel: ChannelModel(cid: 'messaging:test')));

      mutations.onChannelPushPreferenceUpdated(pushPreference);

      expect(capturedChannelState().pushPreferences, pushPreference);
    });
  });

  group('members', () {
    final member = Member(user: otherUser);

    test('onMemberAdded appends the member', () {
      final existingMember = Member(user: User(id: 'existing-user'));
      stubChannelState(ChannelState(members: [existingMember]));

      mutations.onMemberAdded(member);

      expect(capturedChannelState().members, [existingMember, member]);
    });

    test('onMemberRemoved removes the member and its read state', () {
      final existingMember = Member(user: User(id: 'existing-user'));
      final existingRead = Read(
        user: User(id: 'existing-user'),
        lastRead: DateTime.now(),
      );
      stubChannelState(
        ChannelState(
          members: [existingMember, member],
          read: [
            existingRead,
            Read(user: otherUser, lastRead: DateTime.now()),
          ],
        ),
      );

      mutations.onMemberRemoved(otherUser);

      final updated = capturedChannelState();
      expect(updated.members, [existingMember]);
      expect(updated.read, [existingRead]);
    });

    test('onMemberUserUpdated merges the user into the member and membership', () {
      final updatedUser = User(id: otherUser.id, name: 'Updated');
      stubChannelState(ChannelState(members: [member], membership: member));

      mutations.onMemberUserUpdated(updatedUser);

      final updated = capturedChannelState();
      expect(updated.members?.single.user, updatedUser);
      expect(updated.membership?.user, updatedUser);
    });

    test('onMemberUserUpdated ignores users that are not members', () {
      stubChannelState(ChannelState(members: [member]));

      mutations.onMemberUserUpdated(User(id: 'not-a-member'));

      verifyNever(() => state.updateChannelState(any()));
    });

    test('onMemberUpdated replaces the matching member and membership', () {
      final updatedMember = Member(user: otherUser, channelRole: 'admin');
      stubChannelState(ChannelState(members: [member], membership: member));

      mutations.onMemberUpdated(updatedMember);

      final updated = capturedChannelState();
      expect(updated.members, [updatedMember]);
      expect(updated.membership, updatedMember);
    });

    test('onMemberBanned and onMemberUnbanned replace the refreshed member', () {
      mutations.onMemberBanned(member);
      mutations.onMemberUnbanned(member);

      expect(updateMemberCalls, [member, member]);
    });

    test('onUserMessagesDeleted deletes the user messages', () async {
      final deletedAt = DateTime.now();

      await mutations.onUserMessagesDeleted(
        userId: otherUser.id,
        hardDelete: true,
        deletedAt: deletedAt,
      );

      expect(deleteMessagesFromUserCalls, [(otherUser.id, true, deletedAt)]);
    });
  });

  group('watchers', () {
    test('onUserStartWatching upserts the watcher and count', () {
      final existingWatcher = User(id: 'existing-watcher');
      stubChannelState(ChannelState(watchers: [existingWatcher, otherUser]));

      final rejoined = User(id: otherUser.id, name: 'Rejoined');
      mutations.onUserStartWatching(rejoined, watcherCount: 3);

      final updated = capturedChannelState();
      expect(updated.watchers, [rejoined, existingWatcher]);
      expect(updated.watcherCount, 3);
    });

    test('onUserStopWatching removes the watcher', () {
      mutations.onUserStopWatching(otherUser, watcherCount: 1);

      expect(removeWatcherCalls, [(otherUser, 1)]);
    });
  });

  group('reminders', () {
    final reminder = MessageReminder(
      messageId: 'message-id',
      channelCid: 'messaging:test',
      userId: currentUserId,
      remindAt: DateTime.now(),
    );

    test('onReminderCreated and onReminderUpdated apply the reminder', () {
      mutations.onReminderCreated(reminder);
      mutations.onReminderUpdated(reminder);

      verify(() => state.updateReminder(reminder)).called(2);
    });

    test('onReminderDeleted removes the reminder', () {
      mutations.onReminderDeleted(reminder);

      verify(() => state.deleteReminder(reminder)).called(1);
    });
  });

  group('locations', () {
    Location createLocation({String? messageId = 'message-id', double latitude = 1}) {
      return Location(
        channelCid: 'messaging:test',
        messageId: messageId,
        userId: currentUserId,
        latitude: latitude,
        longitude: 2,
        createdByDeviceId: 'device-id',
      );
    }

    test('onLocationShared adds the location message', () {
      final message = Message(id: 'message-id', sharedLocation: createLocation());

      mutations.onLocationShared(message);

      verify(() => state.addNewMessage(message)).called(1);
    });

    test('onLocationUpdated applies the location to the message sharing it', () {
      final message = Message(id: 'message-id', sharedLocation: createLocation());
      when(() => state.messages).thenReturn([message]);
      when(() => state.threads).thenReturn(const {});

      final updatedLocation = createLocation(latitude: 42);
      mutations.onLocationUpdated(updatedLocation);

      final captured = verify(() => state.updateMessage(captureAny())).captured.single as Message;
      expect(captured.sharedLocation, updatedLocation);
    });

    test('onLocationUpdated finds the message in a thread', () {
      final message = Message(id: 'message-id', parentId: 'parent-id', sharedLocation: createLocation());
      when(() => state.messages).thenReturn([]);
      when(() => state.threads).thenReturn({
        'parent-id': [message],
      });

      mutations.onLocationUpdated(createLocation(latitude: 42));

      verify(() => state.updateMessage(any())).called(1);
    });

    test('onLocationUpdated ignores locations without a message id', () {
      mutations.onLocationUpdated(createLocation(messageId: null));

      verifyNever(() => state.updateMessage(any()));
    });

    test('onLocationUpdated ignores locations of unknown messages', () {
      when(() => state.messages).thenReturn([]);
      when(() => state.threads).thenReturn(const {});

      mutations.onLocationUpdated(createLocation());

      verifyNever(() => state.updateMessage(any()));
    });

    test('onLocationExpired applies the expired location', () {
      final message = Message(id: 'message-id', sharedLocation: createLocation());
      when(() => state.messages).thenReturn([message]);
      when(() => state.threads).thenReturn(const {});

      final expiredLocation = createLocation(latitude: 42);
      mutations.onLocationExpired(expiredLocation);

      final captured = verify(() => state.updateMessage(captureAny())).captured.single as Message;
      expect(captured.sharedLocation, expiredLocation);
    });
  });
}
