// ignore_for_file: cascade_invocations

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/client/channel_event_handler.dart';
import 'package:stream_chat/src/client/channel_state_mutations.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';

class MockChannel extends Mock implements Channel {}

class MockChannelStateMutations extends Mock implements ChannelStateMutations {}

class FakeDraft extends Fake implements Draft {}

class FakeReaction extends Fake implements Reaction {}

class FakePoll extends Fake implements Poll {}

class FakeMember extends Fake implements Member {}

class FakeMessageReminder extends Fake implements MessageReminder {}

class FakeLocation extends Fake implements Location {}

class FakeChannelPushPreference extends Fake implements ChannelPushPreference {}

class FakeQueryMembersResponse extends Fake implements QueryMembersResponse {
  FakeQueryMembersResponse(this.members);

  @override
  final List<Member> members;
}

void main() {
  late MockChannel channel;
  late MockStreamChatClient client;
  late MockChannelStateMutations mutations;
  late ChannelEventHandler handler;

  // Matches the default current user of [FakeClientState].
  const currentUserId = 'test-user-id';
  final otherUser = User(id: 'other-user');

  setUpAll(() {
    registerFallbackValue(FakeMessage());
    registerFallbackValue(FakeUser());
    registerFallbackValue(FakeEvent());
    registerFallbackValue(FakeDraft());
    registerFallbackValue(FakeReaction());
    registerFallbackValue(FakePoll());
    registerFallbackValue(FakePollVote());
    registerFallbackValue(FakeMember());
    registerFallbackValue(FakeMessageReminder());
    registerFallbackValue(FakeLocation());
    registerFallbackValue(FakeChannelPushPreference());
    registerFallbackValue(Filter.equal('id', ''));
    registerFallbackValue('');
    registerFallbackValue(0);
    registerFallbackValue(false);
    registerFallbackValue(DateTime(0));
    registerFallbackValue(<Channel>[]);
  });

  setUp(() {
    channel = MockChannel();
    client = MockStreamChatClient();
    mutations = MockChannelStateMutations();

    when(() => channel.client).thenReturn(client);
    when(() => client.state).thenReturn(FakeClientState());
    when(() => client.channelDeliveryReporter.reconcileDelivery(any())).thenAnswer((_) async {});

    when(
      () => mutations.onUserMessagesDeleted(
        userId: any(named: 'userId'),
        hardDelete: any(named: 'hardDelete'),
        deletedAt: any(named: 'deletedAt'),
      ),
    ).thenAnswer((_) async {});

    handler = ChannelEventHandler(channel: channel, mutations: mutations);
  });

  group('dispatch', () {
    test('does nothing for an unknown event without payloads', () {
      handler.handleEvent(Event(type: 'unknown.event'));

      verifyZeroInteractions(mutations);
    });

    test('runs the unfiltered handlers around the typed blocks in order', () {
      final member = Member(userId: otherUser.id);
      final event = Event(
        type: EventType.memberAdded,
        member: member,
        user: otherUser,
        channelMessageCount: 5,
      );

      handler.handleEvent(event);

      verifyInOrder([
        () => mutations.onChannelMessageCount(5),
        () => mutations.onMemberAdded(member),
        () => mutations.onMemberUserUpdated(otherUser),
      ]);
    });
  });

  group('typing events', () {
    test('typing.start delegates the typing user and event', () {
      final event = Event(type: EventType.typingStart, user: otherUser);

      handler.handleEvent(event);

      verify(() => mutations.onTypingStart(otherUser, event)).called(1);
    });

    test('typing.start ignores events without a user', () {
      handler.handleEvent(Event(type: EventType.typingStart));

      verifyNever(() => mutations.onTypingStart(any(), any()));
    });

    test('typing.start ignores events from the current user', () {
      final event = Event(
        type: EventType.typingStart,
        user: User(id: currentUserId),
      );

      handler.handleEvent(event);

      verifyNever(() => mutations.onTypingStart(any(), any()));
    });

    test('typing.stop delegates the typing user', () {
      final event = Event(type: EventType.typingStop, user: otherUser);

      handler.handleEvent(event);

      verify(() => mutations.onTypingStop(otherUser)).called(1);
    });

    test('typing.stop ignores events from the current user', () {
      final event = Event(
        type: EventType.typingStop,
        user: User(id: currentUserId),
      );

      handler.handleEvent(event);

      verifyNever(() => mutations.onTypingStop(any()));
    });
  });

  group('message events', () {
    final message = Message(id: 'message-id', user: otherUser);

    test('message.new delegates the message with its watcher count', () {
      final event = Event(
        type: EventType.messageNew,
        message: message,
        watcherCount: 7,
      );

      handler.handleEvent(event);

      verify(() => mutations.onMessageNew(message, watcherCount: 7)).called(1);
    });

    test('notification.message_new never forwards the watcher count', () {
      final event = Event(
        type: EventType.notificationMessageNew,
        message: message,
        watcherCount: 7,
      );

      handler.handleEvent(event);

      verify(() => mutations.onMessageNew(message, watcherCount: null)).called(1);
    });

    test('message.new ignores events without a message', () {
      handler.handleEvent(Event(type: EventType.messageNew));

      verifyNever(() => mutations.onMessageNew(any(), watcherCount: any(named: 'watcherCount')));
    });

    test('message.deleted delegates the message enriched with deletedForMe', () {
      final event = Event(
        type: EventType.messageDeleted,
        message: message,
        hardDelete: true,
        deletedForMe: true,
      );

      handler.handleEvent(event);

      final expected = message.copyWith(deletedForMe: true);
      verify(() => mutations.onMessageDeleted(expected, hardDelete: true)).called(1);
    });

    test('message.deleted defaults to a soft delete', () {
      final event = Event(type: EventType.messageDeleted, message: message);

      handler.handleEvent(event);

      verify(() => mutations.onMessageDeleted(any(), hardDelete: false)).called(1);
    });

    test('message.updated delegates the message', () {
      final event = Event(type: EventType.messageUpdated, message: message);

      handler.handleEvent(event);

      verify(() => mutations.onMessageUpdated(message)).called(1);
    });

    test('message.updated ignores events without a message', () {
      handler.handleEvent(Event(type: EventType.messageUpdated));

      verifyNever(() => mutations.onMessageUpdated(any()));
    });
  });

  group('draft events', () {
    final draft = Draft(
      channelCid: 'messaging:test',
      createdAt: DateTime.now(),
      message: DraftMessage(text: 'draft'),
    );

    test('draft.updated delegates the draft', () {
      handler.handleEvent(Event(type: EventType.draftUpdated, draft: draft));

      verify(() => mutations.onDraftUpdated(draft)).called(1);
    });

    test('draft.deleted delegates the draft', () {
      handler.handleEvent(Event(type: EventType.draftDeleted, draft: draft));

      verify(() => mutations.onDraftDeleted(draft)).called(1);
    });

    test('draft events ignore events without a draft', () {
      handler.handleEvent(Event(type: EventType.draftUpdated));
      handler.handleEvent(Event(type: EventType.draftDeleted));

      verifyNever(() => mutations.onDraftUpdated(any()));
      verifyNever(() => mutations.onDraftDeleted(any()));
    });
  });

  group('reaction events', () {
    final message = Message(id: 'message-id', user: otherUser);
    final reaction = Reaction(
      type: 'like',
      messageId: 'message-id',
      userId: otherUser.id,
      createdAt: DateTime.now(),
    );

    test('reaction.new delegates the message and reaction', () {
      final event = Event(
        type: EventType.reactionNew,
        message: message,
        reaction: reaction,
      );

      handler.handleEvent(event);

      verify(() => mutations.onReactionNew(message, reaction)).called(1);
    });

    test('reaction.updated delegates the message and reaction', () {
      final event = Event(
        type: EventType.reactionUpdated,
        message: message,
        reaction: reaction,
      );

      handler.handleEvent(event);

      verify(() => mutations.onReactionUpdated(message, reaction)).called(1);
    });

    test('reaction.deleted delegates the message and reaction', () {
      final event = Event(
        type: EventType.reactionDeleted,
        message: message,
        reaction: reaction,
      );

      handler.handleEvent(event);

      verify(() => mutations.onReactionDeleted(message, reaction)).called(1);
    });

    test('reaction events ignore events missing the reaction or message', () {
      handler.handleEvent(Event(type: EventType.reactionNew, message: message));
      handler.handleEvent(Event(type: EventType.reactionNew, reaction: reaction));

      verifyNever(() => mutations.onReactionNew(any(), any()));
    });
  });

  group('poll events', () {
    final poll = Poll(
      id: 'poll-id',
      name: 'Favorite color?',
      options: const [PollOption(id: 'option-a', text: 'A')],
    );
    final pollVote = PollVote(
      id: 'vote-id',
      pollId: 'poll-id',
      userId: otherUser.id,
      optionId: 'option-a',
    );

    test('poll.created delegates the poll message', () {
      final message = Message(id: 'message-id', poll: poll);
      final event = Event(type: EventType.pollCreated, message: message);

      handler.handleEvent(event);

      verify(() => mutations.onPollCreated(message)).called(1);
    });

    test('poll.created ignores messages without a poll', () {
      final message = Message(id: 'message-id');
      handler.handleEvent(Event(type: EventType.pollCreated, message: message));
      handler.handleEvent(Event(type: EventType.pollCreated));

      verifyNever(() => mutations.onPollCreated(any()));
    });

    test('poll.updated and poll.closed delegate the poll', () {
      handler.handleEvent(Event(type: EventType.pollUpdated, poll: poll));
      handler.handleEvent(Event(type: EventType.pollClosed, poll: poll));

      verify(() => mutations.onPollUpdated(poll)).called(1);
      verify(() => mutations.onPollClosed(poll)).called(1);
    });

    test('poll.updated ignores events without a poll', () {
      handler.handleEvent(Event(type: EventType.pollUpdated));

      verifyNever(() => mutations.onPollUpdated(any()));
    });

    test('poll vote events delegate the poll and vote', () {
      handler.handleEvent(Event(type: EventType.pollAnswerCasted, poll: poll, pollVote: pollVote));
      handler.handleEvent(Event(type: EventType.pollVoteCasted, poll: poll, pollVote: pollVote));
      handler.handleEvent(Event(type: EventType.pollVoteChanged, poll: poll, pollVote: pollVote));
      handler.handleEvent(Event(type: EventType.pollAnswerRemoved, poll: poll, pollVote: pollVote));
      handler.handleEvent(Event(type: EventType.pollVoteRemoved, poll: poll, pollVote: pollVote));

      verify(() => mutations.onPollAnswerCasted(poll, pollVote)).called(1);
      verify(() => mutations.onPollVoteCasted(poll, pollVote)).called(1);
      verify(() => mutations.onPollVoteChanged(poll, pollVote)).called(1);
      verify(() => mutations.onPollAnswerRemoved(poll, pollVote)).called(1);
      verify(() => mutations.onPollVoteRemoved(poll, pollVote)).called(1);
    });

    test('poll vote events ignore events missing the poll or vote', () {
      handler.handleEvent(Event(type: EventType.pollVoteCasted, poll: poll));
      handler.handleEvent(Event(type: EventType.pollVoteCasted, pollVote: pollVote));

      verifyNever(() => mutations.onPollVoteCasted(any(), any()));
    });
  });

  group('read events', () {
    test('message.read delegates the read with the event creation time', () {
      final event = Event(
        type: EventType.messageRead,
        user: otherUser,
        createdAt: DateTime.now(),
        lastReadMessageId: 'last-read-id',
      );

      handler.handleEvent(event);

      verify(
        () => mutations.onMessageRead(
          otherUser,
          lastRead: event.createdAt,
          lastReadMessageId: 'last-read-id',
        ),
      ).called(1);
      verifyNever(() => client.channelDeliveryReporter.reconcileDelivery(any()));
    });

    test('notification.mark_read routes to the same read handling', () {
      final event = Event(type: EventType.notificationMarkRead, user: otherUser);

      handler.handleEvent(event);

      verify(
        () => mutations.onMessageRead(
          otherUser,
          lastRead: event.createdAt,
          lastReadMessageId: null,
        ),
      ).called(1);
    });

    test('message.read from the current user reconciles channel delivery', () {
      final event = Event(
        type: EventType.messageRead,
        user: User(id: currentUserId),
      );

      handler.handleEvent(event);

      verify(() => client.channelDeliveryReporter.reconcileDelivery([channel])).called(1);
    });

    test('message.read ignores thread reads', () {
      final event = Event(
        type: EventType.messageRead,
        user: otherUser,
        thread: Thread(
          parentMessageId: 'parent-id',
          channelCid: 'messaging:test',
          createdByUserId: otherUser.id,
          participantCount: 1,
          replyCount: 1,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      handler.handleEvent(event);

      verifyNever(
        () => mutations.onMessageRead(
          any(),
          lastRead: any(named: 'lastRead'),
          lastReadMessageId: any(named: 'lastReadMessageId'),
        ),
      );
    });

    test('notification.mark_unread delegates the unread mark', () {
      final lastReadAt = DateTime.now();
      final event = Event(
        type: EventType.notificationMarkUnread,
        user: otherUser,
        lastReadAt: lastReadAt,
        unreadMessages: 3,
        lastReadMessageId: 'last-read-id',
      );

      handler.handleEvent(event);

      verify(
        () => mutations.onNotificationMarkUnread(
          otherUser,
          lastRead: lastReadAt,
          unreadMessages: 3,
          lastReadMessageId: 'last-read-id',
        ),
      ).called(1);
    });

    test('message.delivered delegates the delivery info', () {
      final deliveredAt = DateTime.now();
      final event = Event(
        type: EventType.messageDelivered,
        user: otherUser,
        lastDeliveredAt: deliveredAt,
        lastDeliveredMessageId: 'delivered-id',
      );

      handler.handleEvent(event);

      verify(
        () => mutations.onMessageDelivered(
          otherUser,
          lastDeliveredAt: deliveredAt,
          lastDeliveredMessageId: 'delivered-id',
        ),
      ).called(1);
      verifyNever(() => client.channelDeliveryReporter.reconcileDelivery(any()));
    });

    test('message.delivered from the current user reconciles channel delivery', () {
      final event = Event(
        type: EventType.messageDelivered,
        user: User(id: currentUserId),
      );

      handler.handleEvent(event);

      verify(() => client.channelDeliveryReporter.reconcileDelivery([channel])).called(1);
    });
  });

  group('channel events', () {
    test('channel.truncated wipes persisted messages before mutating', () async {
      final persistentClient = MockStreamChatClientWithPersistence();
      when(() => channel.client).thenReturn(persistentClient);
      when(() => persistentClient.state).thenReturn(FakeClientState());

      final persistence = persistentClient.chatPersistenceClient;
      when(() => persistence.deleteMessageByCid(any())).thenAnswer((_) async {});

      final systemMessage = Message(id: 'system-id');
      final event = Event(
        type: EventType.channelTruncated,
        channel: ChannelModel(cid: 'messaging:test'),
        message: systemMessage,
      );

      handler.handleEvent(event);
      await Future<void>.value();

      verifyInOrder([
        () => persistence.deleteMessageByCid('messaging:test'),
        () => mutations.onChannelTruncated(message: systemMessage),
      ]);
    });

    test('channel.updated delegates the channel model', () {
      final channelModel = ChannelModel(cid: 'messaging:test');
      final event = Event(type: EventType.channelUpdated, channel: channelModel);

      handler.handleEvent(event);

      verify(() => mutations.onChannelUpdated(channelModel)).called(1);
    });

    test('any event carrying a channel message count delegates it', () {
      handler.handleEvent(Event(type: 'unknown.event', channelMessageCount: 42));

      verify(() => mutations.onChannelMessageCount(42)).called(1);
    });

    test('events without a channel message count skip the count update', () {
      handler.handleEvent(Event(type: 'unknown.event'));

      verifyNever(() => mutations.onChannelMessageCount(any()));
    });

    test('channel.push_preference.updated delegates the preferences', () {
      const pushPreference = ChannelPushPreference(chatLevel: ChatLevel.mentions);
      final event = Event(
        type: EventType.channelPushPreferenceUpdated,
        channelPushPreference: pushPreference,
      );

      handler.handleEvent(event);

      verify(() => mutations.onChannelPushPreferenceUpdated(pushPreference)).called(1);
    });

    test('channel.push_preference.updated ignores events without preferences', () {
      handler.handleEvent(Event(type: EventType.channelPushPreferenceUpdated));

      verifyNever(() => mutations.onChannelPushPreferenceUpdated(any()));
    });
  });

  group('member events', () {
    final member = Member(userId: otherUser.id);

    test('member.added delegates the member', () {
      final event = Event(type: EventType.memberAdded, member: member);

      handler.handleEvent(event);

      verify(() => mutations.onMemberAdded(member)).called(1);
    });

    test('member.removed delegates the removed user', () {
      final event = Event(type: EventType.memberRemoved, user: otherUser);

      handler.handleEvent(event);

      verify(() => mutations.onMemberRemoved(otherUser)).called(1);
    });

    test('member.updated delegates the member', () {
      final event = Event(type: EventType.memberUpdated, member: member, user: otherUser);

      handler.handleEvent(event);

      verify(() => mutations.onMemberUpdated(member)).called(1);
    });

    test('any event carrying a user delegates the member-user merge', () {
      handler.handleEvent(Event(type: 'unknown.event', user: otherUser));

      verify(() => mutations.onMemberUserUpdated(otherUser)).called(1);
    });

    test('user.banned refreshes the member before delegating', () async {
      when(
        () => channel.queryMembers(filter: any(named: 'filter')),
      ).thenAnswer((_) async => FakeQueryMembersResponse([member]));

      final event = Event(
        type: EventType.userBanned,
        cid: 'messaging:test',
        user: otherUser,
      );

      handler.handleEvent(event);
      await Future<void>.value();

      verify(() => channel.queryMembers(filter: Filter.equal('id', otherUser.id))).called(1);
      verify(() => mutations.onMemberBanned(member)).called(1);
    });

    test('user.banned ignores app-level bans without a cid', () async {
      handler.handleEvent(Event(type: EventType.userBanned, user: otherUser));
      await Future<void>.value();

      verifyNever(() => channel.queryMembers(filter: any(named: 'filter')));
      verifyNever(() => mutations.onMemberBanned(any()));
    });

    test('user.unbanned refreshes the member before delegating', () async {
      when(
        () => channel.queryMembers(filter: any(named: 'filter')),
      ).thenAnswer((_) async => FakeQueryMembersResponse([member]));

      final event = Event(
        type: EventType.userUnbanned,
        cid: 'messaging:test',
        user: otherUser,
      );

      handler.handleEvent(event);
      await Future<void>.value();

      verify(() => mutations.onMemberUnbanned(member)).called(1);
    });

    test('user.messages.deleted delegates the deletion parameters', () async {
      final event = Event(
        type: EventType.userMessagesDeleted,
        user: otherUser,
        hardDelete: true,
      );

      handler.handleEvent(event);
      await Future<void>.value();

      verify(
        () => mutations.onUserMessagesDeleted(
          userId: otherUser.id,
          hardDelete: true,
          deletedAt: event.createdAt,
        ),
      ).called(1);
    });

    test('user.messages.deleted ignores events without a user', () async {
      handler.handleEvent(Event(type: EventType.userMessagesDeleted));
      await Future<void>.value();

      verifyNever(
        () => mutations.onUserMessagesDeleted(
          userId: any(named: 'userId'),
          hardDelete: any(named: 'hardDelete'),
          deletedAt: any(named: 'deletedAt'),
        ),
      );
    });
  });

  group('watching events', () {
    test('user.watching.start delegates the watcher and count', () {
      final event = Event(
        type: EventType.userWatchingStart,
        user: otherUser,
        watcherCount: 3,
      );

      handler.handleEvent(event);

      verify(() => mutations.onUserStartWatching(otherUser, watcherCount: 3)).called(1);
    });

    test('user.watching.stop delegates the watcher and count', () {
      final event = Event(
        type: EventType.userWatchingStop,
        user: otherUser,
        watcherCount: 2,
      );

      handler.handleEvent(event);

      verify(() => mutations.onUserStopWatching(otherUser, watcherCount: 2)).called(1);
    });

    test('watching events ignore events without a user', () {
      handler.handleEvent(Event(type: EventType.userWatchingStart));
      handler.handleEvent(Event(type: EventType.userWatchingStop));

      verifyNever(() => mutations.onUserStartWatching(any(), watcherCount: any(named: 'watcherCount')));
      verifyNever(() => mutations.onUserStopWatching(any(), watcherCount: any(named: 'watcherCount')));
    });
  });

  group('reminder events', () {
    final reminder = MessageReminder(
      messageId: 'message-id',
      channelCid: 'messaging:test',
      userId: currentUserId,
      remindAt: DateTime.now(),
    );

    test('reminder.created and reminder.updated delegate the reminder', () {
      handler.handleEvent(Event(type: EventType.reminderCreated, reminder: reminder));
      handler.handleEvent(Event(type: EventType.reminderUpdated, reminder: reminder));

      verify(() => mutations.onReminderCreated(reminder)).called(1);
      verify(() => mutations.onReminderUpdated(reminder)).called(1);
    });

    test('reminder.deleted delegates the reminder', () {
      handler.handleEvent(Event(type: EventType.reminderDeleted, reminder: reminder));

      verify(() => mutations.onReminderDeleted(reminder)).called(1);
    });

    test('reminder events ignore events without a reminder', () {
      handler.handleEvent(Event(type: EventType.reminderCreated));
      handler.handleEvent(Event(type: EventType.reminderDeleted));

      verifyNever(() => mutations.onReminderCreated(any()));
      verifyNever(() => mutations.onReminderDeleted(any()));
    });
  });

  group('location events', () {
    final location = Location(
      channelCid: 'messaging:test',
      messageId: 'message-id',
      userId: currentUserId,
      latitude: 1,
      longitude: 2,
      createdByDeviceId: 'device-id',
    );

    test('location.shared delegates the location message', () {
      final message = Message(id: 'message-id', sharedLocation: location);
      final event = Event(type: EventType.locationShared, message: message);

      handler.handleEvent(event);

      verify(() => mutations.onLocationShared(message)).called(1);
    });

    test('location.shared ignores messages without a location', () {
      final message = Message(id: 'message-id');
      handler.handleEvent(Event(type: EventType.locationShared, message: message));

      verifyNever(() => mutations.onLocationShared(any()));
    });

    test('location.updated delegates the location', () {
      final message = Message(id: 'message-id', sharedLocation: location);
      final event = Event(type: EventType.locationUpdated, message: message);

      handler.handleEvent(event);

      verify(() => mutations.onLocationUpdated(location)).called(1);
    });

    test('location.expired delegates the location', () {
      final message = Message(id: 'message-id', sharedLocation: location);
      final event = Event(type: EventType.locationExpired, message: message);

      handler.handleEvent(event);

      verify(() => mutations.onLocationExpired(location)).called(1);
    });

    test('location events ignore events without a location', () {
      handler.handleEvent(Event(type: EventType.locationUpdated));
      handler.handleEvent(Event(type: EventType.locationExpired));

      verifyNever(() => mutations.onLocationUpdated(any()));
      verifyNever(() => mutations.onLocationExpired(any()));
    });
  });
}
