// ignore_for_file: cascade_invocations

import 'package:clock/clock.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/client/channel/channel_event_handler.dart';
import 'package:stream_chat/src/client/channel/channel_state_mutations.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../fakes.dart';
import '../../mocks.dart';

class MockChannel extends Mock implements Channel {}

class MockChannelStateMutations extends Mock implements ChannelStateMutations {}

class FakeDraft extends Fake implements Draft {}

class FakeReaction extends Fake implements Reaction {}

class FakePoll extends Fake implements Poll {}

class FakeMember extends Fake implements Member {}

class FakeMessageReminder extends Fake implements MessageReminder {}

class FakeLocation extends Fake implements Location {}

class FakeChannelPushPreference extends Fake implements ChannelPushPreference {}

void main() {
  late MockChannel channel;
  late MockStreamChatClient client;
  late MockChannelStateMutations mutations;
  late ChannelEventHandler handler;
  late List<StreamLogRecord> logRecords;

  // Matches the default current user of [FakeClientState].
  const currentUserId = 'test-user-id';
  final otherUser = User(id: 'other-user');
  final channelModel = ChannelModel(cid: 'messaging:test');

  setUpAll(() {
    registerFallbackValue(FakeMessage());
    registerFallbackValue(FakeUser());
    registerFallbackValue(TypingStartEvent());
    registerFallbackValue(FakeDraft());
    registerFallbackValue(FakeReaction());
    registerFallbackValue(DateTime(2026));
    registerFallbackValue(FakePoll());
    registerFallbackValue(FakePollVote());
    registerFallbackValue(FakeMember());
    registerFallbackValue(FakeMessageReminder());
    registerFallbackValue(FakeLocation());
    registerFallbackValue(FakeChannelPushPreference());
    registerFallbackValue(MemberFilter.equal(MemberFilterField.userId, ''));
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

    // A `StreamLogger` writes to the global handler rather than to a stream of
    // its own, so what the handler reports is observed through that handler.
    logRecords = [];
    StreamLogger.handler = _CapturingHandler(logRecords.add);
    StreamLogger.priority = StreamLogPriority.verbose;

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

  tearDown(StreamLogger.reset);

  group('dispatch', () {
    test('does nothing for an unknown event without payloads', () {
      handler.handleEvent(MessageDeliveredEvent());

      verifyZeroInteractions(mutations);
    });

    test('runs the unfiltered handlers around the typed blocks in order', () {
      final member = Member(userId: otherUser.id);
      final event = MemberAddedEvent(
        channel: channelModel,
        member: member,
        user: otherUser,
        channelMessageCount: 5,
      );

      handler.handleEvent(event);

      verifyInOrder([
        () => mutations.onChannelCounts(memberCount: null, messageCount: 5),
        () => mutations.onMemberAdded(member),
        () => mutations.onMemberUserUpdated(otherUser),
      ]);
    });

    // `member.updated` carries both a member and a user, so both stages write
    // the same member. The merge runs first, leaving the event member's user
    // in place; reordering them would copy the event user over it instead.
    test('merges the event user before applying an updated member', () {
      final member = Member(userId: otherUser.id);

      handler.handleEvent(
        MemberUpdatedEvent(channel: channelModel, member: member, user: otherUser),
      );

      verifyInOrder([
        () => mutations.onMemberUserUpdated(otherUser),
        () => mutations.onMemberUpdated(member),
      ]);
    });
  });

  group('typing events', () {
    test('typing.start delegates the typing user and event', () {
      final event = TypingStartEvent(user: otherUser);

      handler.handleEvent(event);

      verify(() => mutations.onTypingStart(otherUser, event)).called(1);
    });

    test('typing.start ignores events without a user', () {
      handler.handleEvent(TypingStartEvent());

      verifyNever(() => mutations.onTypingStart(any(), any()));
    });

    test('typing.start ignores events from the current user', () {
      final event = TypingStartEvent(user: User(id: currentUserId));

      handler.handleEvent(event);

      verifyNever(() => mutations.onTypingStart(any(), any()));
    });

    test('typing.stop delegates the typing user', () {
      final event = TypingStopEvent(user: otherUser);

      handler.handleEvent(event);

      verify(() => mutations.onTypingStop(otherUser)).called(1);
    });

    test('typing.stop ignores events from the current user', () {
      final event = TypingStopEvent(user: User(id: currentUserId));

      handler.handleEvent(event);

      verifyNever(() => mutations.onTypingStop(any()));
    });
  });

  group('message events', () {
    final message = Message(id: 'message-id', user: otherUser);

    test('message.new delegates the message with its watcher count', () {
      final event = MessageNewEvent(message: message, watcherCount: 7);

      handler.handleEvent(event);

      verify(() => mutations.onMessageNew(message, watcherCount: 7)).called(1);
    });

    test('notification.message_new never forwards the watcher count', () {
      final event = NotificationMessageNewEvent(
        channel: channelModel,
        message: message,
        watcherCount: 7,
      );

      handler.handleEvent(event);

      verify(() => mutations.onMessageNew(message, watcherCount: null)).called(1);
    });

    test('message.deleted delegates the message enriched with deletedForMe', () {
      final event = MessageDeletedEvent(
        message: message,
        hardDelete: true,
        deletedForMe: true,
      );

      handler.handleEvent(event);

      final expected = message.copyWith(deletedForMe: true);
      verify(() => mutations.onMessageDeleted(expected, hardDelete: true)).called(1);
    });

    test('message.updated delegates the message', () {
      final event = MessageUpdatedEvent(message: message);

      handler.handleEvent(event);

      verify(() => mutations.onMessageUpdated(message)).called(1);
    });

    test('message.updated passes the user who made the edit', () {
      final editor = User(id: 'editor');
      final event = MessageUpdatedEvent(message: message, user: editor);

      handler.handleEvent(event);

      verify(() => mutations.onMessageUpdated(message, editor: editor)).called(1);
    });
  });

  group('draft events', () {
    final draft = Draft(
      channelCid: 'messaging:test',
      createdAt: DateTime.now(),
      message: DraftMessage(text: 'draft'),
    );

    test('draft.updated delegates the draft', () {
      handler.handleEvent(DraftUpdatedEvent(draft: draft));

      verify(() => mutations.onDraftUpdated(draft)).called(1);
    });

    test('draft.deleted delegates the draft', () {
      handler.handleEvent(DraftDeletedEvent(draft: draft));

      verify(() => mutations.onDraftDeleted(draft)).called(1);
    });

    test('draft.updated ignores events without a draft', () {
      handler.handleEvent(DraftUpdatedEvent());

      verifyNever(() => mutations.onDraftUpdated(any()));
    });

    test('draft.deleted ignores events without a draft', () {
      handler.handleEvent(DraftDeletedEvent());

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
      final event = ReactionNewEvent(
        channel: channelModel,
        message: message,
        reaction: reaction,
      );

      handler.handleEvent(event);

      verify(() => mutations.onReactionNew(message, reaction)).called(1);
    });

    test('reaction.updated delegates the message and reaction', () {
      final event = ReactionUpdatedEvent(
        channel: channelModel,
        message: message,
        reaction: reaction,
      );

      handler.handleEvent(event);

      verify(() => mutations.onReactionUpdated(message, reaction)).called(1);
    });

    test('reaction.deleted delegates the message and reaction', () {
      final event = ReactionDeletedEvent(
        channel: channelModel,
        message: message,
        reaction: reaction,
      );

      handler.handleEvent(event);

      verify(() => mutations.onReactionDeleted(message, reaction)).called(1);
    });

    test('reaction events ignore events missing the reaction or message', () {
      handler.handleEvent(ReactionNewEvent(channel: channelModel, message: message));
      handler.handleEvent(ReactionNewEvent(channel: channelModel, reaction: reaction));

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

    test('poll.updated delegates the poll', () {
      handler.handleEvent(PollUpdatedEvent(poll: poll));

      verify(() => mutations.onPollUpdated(poll)).called(1);
    });

    test('poll.closed delegates the poll', () {
      handler.handleEvent(PollClosedEvent(poll: poll));

      verify(() => mutations.onPollClosed(poll)).called(1);
    });

    test('poll.answer_casted delegates the poll and vote', () {
      handler.handleEvent(PollAnswerCastedEvent(poll: poll, pollVote: pollVote));

      verify(() => mutations.onPollAnswerCasted(poll, pollVote)).called(1);
    });

    test('poll.vote_casted delegates the poll and vote', () {
      handler.handleEvent(PollVoteCastedEvent(poll: poll, pollVote: pollVote));

      verify(() => mutations.onPollVoteCasted(poll, pollVote)).called(1);
    });

    test('poll.vote_changed delegates the poll and vote', () {
      handler.handleEvent(PollVoteChangedEvent(poll: poll, pollVote: pollVote));

      verify(() => mutations.onPollVoteChanged(poll, pollVote)).called(1);
    });

    test('poll.answer_removed delegates the poll and vote', () {
      handler.handleEvent(PollAnswerRemovedEvent(poll: poll, pollVote: pollVote));

      verify(() => mutations.onPollAnswerRemoved(poll, pollVote)).called(1);
    });

    test('poll.vote_removed delegates the poll and vote', () {
      handler.handleEvent(PollVoteRemovedEvent(poll: poll, pollVote: pollVote));

      verify(() => mutations.onPollVoteRemoved(poll, pollVote)).called(1);
    });
  });

  group('read events', () {
    test('message.read delegates the read with the event creation time', () {
      final event = MessageReadEvent(
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
      final event = NotificationMarkReadEvent(
        user: otherUser,
        totalUnreadCount: 0,
        unreadChannels: 0,
      );

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
      final event = MessageReadEvent(user: User(id: currentUserId));

      handler.handleEvent(event);

      verify(() => client.channelDeliveryReporter.reconcileDelivery([channel])).called(1);
    });

    test('message.read ignores thread reads', () {
      final event = MessageReadEvent(
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
      final event = NotificationMarkUnreadEvent(
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
      final event = MessageDeliveredEvent(
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
      final event = MessageDeliveredEvent(user: User(id: currentUserId));

      handler.handleEvent(event);

      verify(() => client.channelDeliveryReporter.reconcileDelivery([channel])).called(1);
    });
  });

  group('channel events', () {
    test('channel.truncated removes the stored messages before mutating', () async {
      final persistentClient = MockStreamChatClientWithPersistence();
      when(() => channel.client).thenReturn(persistentClient);
      when(() => persistentClient.state).thenReturn(FakeClientState());

      final persistence = persistentClient.chatPersistenceClient;
      when(() => persistence.truncateChannel(any(), truncatedAt: any(named: 'truncatedAt'))).thenAnswer((_) async {});

      final truncatedAt = DateTime.utc(2026, 10, 29, 12);
      final systemMessage = Message(id: 'system-id');
      final event = ChannelTruncatedEvent(
        channel: ChannelModel(cid: 'messaging:test', truncatedAt: truncatedAt),
        message: systemMessage,
      );

      handler.handleEvent(event);
      await Future<void>.value();

      verifyInOrder([
        () => persistence.truncateChannel('messaging:test', truncatedAt: truncatedAt),
        () => mutations.onChannelTruncated(event.channel, cutoff: truncatedAt, message: systemMessage),
      ]);
    });

    test("channel.truncated cuts at the channel's truncatedAt", () async {
      final truncatedAt = DateTime.utc(2026, 10, 29, 12);
      final channelModel = ChannelModel(cid: 'messaging:test', truncatedAt: truncatedAt);
      final event = ChannelTruncatedEvent(channel: channelModel);

      handler.handleEvent(event);
      await Future<void>.value();

      verify(() => mutations.onChannelTruncated(channelModel, cutoff: truncatedAt)).called(1);
    });

    test('channel.truncated without a truncatedAt cuts at the event time, not the device clock', () async {
      final persistentClient = MockStreamChatClientWithPersistence();
      when(() => channel.client).thenReturn(persistentClient);
      when(() => persistentClient.state).thenReturn(FakeClientState());

      final persistence = persistentClient.chatPersistenceClient;
      when(() => persistence.truncateChannel(any(), truncatedAt: any(named: 'truncatedAt'))).thenAnswer((_) async {});

      final eventTime = DateTime.utc(2026, 10, 29, 12);
      final channelModel = ChannelModel(cid: 'messaging:test');
      final event = ChannelTruncatedEvent(channel: channelModel, createdAt: eventTime);

      await withClock(Clock.fixed(DateTime.utc(2026, 10, 29, 13)), () async {
        handler.handleEvent(event);
        await Future<void>.value();
      });

      verifyInOrder([
        () => persistence.truncateChannel('messaging:test', truncatedAt: eventTime),
        () => mutations.onChannelTruncated(channelModel, cutoff: eventTime),
      ]);
    });

    test('channel.updated delegates the channel model', () {
      final channelModel = ChannelModel(cid: 'messaging:test');
      final event = ChannelUpdatedEvent(channel: channelModel);

      handler.handleEvent(event);

      verify(() => mutations.onChannelUpdated(channelModel)).called(1);
    });

    test('any event carrying channel counts delegates them', () {
      handler.handleEvent(MessageDeliveredEvent(channelMemberCount: 7, channelMessageCount: 42));

      verify(
        () => mutations.onChannelCounts(memberCount: 7, messageCount: 42),
      ).called(1);
    });

    test('an event carrying only one of the counts still delegates it', () {
      handler.handleEvent(MessageDeliveredEvent(channelMemberCount: 7));

      verify(
        () => mutations.onChannelCounts(memberCount: 7, messageCount: null),
      ).called(1);
    });

    test('events without any channel count skip the count update', () {
      handler.handleEvent(UnknownEvent(type: 'unknown.event'));

      verifyNever(
        () => mutations.onChannelCounts(
          memberCount: any(named: 'memberCount'),
          messageCount: any(named: 'messageCount'),
        ),
      );
    });

    test('channel.push_preference.updated delegates the preferences', () {
      const pushPreference = ChannelPushPreference(chatLevel: ChatLevel.mentions);
      final event = ChannelPushPreferenceUpdatedEvent(channelPushPreference: pushPreference);

      handler.handleEvent(event);

      verify(() => mutations.onChannelPushPreferenceUpdated(pushPreference)).called(1);
    });
  });

  group('member events', () {
    final member = Member(userId: otherUser.id);

    test('member.added delegates the member', () {
      final event = MemberAddedEvent(channel: channelModel, member: member);

      handler.handleEvent(event);

      verify(() => mutations.onMemberAdded(member)).called(1);
    });

    test('member.removed delegates the removed user', () {
      final event = MemberRemovedEvent(channel: channelModel, member: member, user: otherUser);

      handler.handleEvent(event);

      verify(() => mutations.onMemberRemoved(otherUser)).called(1);
    });

    test('member.updated delegates the member', () {
      final event = MemberUpdatedEvent(channel: channelModel, member: member, user: otherUser);

      handler.handleEvent(event);

      verify(() => mutations.onMemberUpdated(member)).called(1);
    });

    test('any event carrying a user delegates the member-user merge', () {
      handler.handleEvent(TypingStopEvent(user: otherUser));

      verify(() => mutations.onMemberUserUpdated(otherUser)).called(1);
    });

    test('user.banned refreshes the member before delegating', () async {
      when(
        () => channel.queryMembers(filter: any(named: 'filter')),
      ).thenAnswer((_) async => Result.success(QueryMembersResponse(duration: '0.01ms', members: [member])));

      final event = UserBannedEvent(
        cid: 'messaging:test',
        user: otherUser,
      );

      handler.handleEvent(event);
      await Future<void>.value();

      // A `Filter` compares by identity, so the query is checked against the
      // filter it serializes to rather than against an equal instance.
      final filter =
          verify(
                () => channel.queryMembers(filter: captureAny(named: 'filter')),
              ).captured.single
              as MemberFilter;

      expect(filter.toJson(), MemberFilter.equal(MemberFilterField.userId, otherUser.id).toJson());
      verify(() => mutations.onMemberBanned(member)).called(1);
    });

    test('user.banned leaves the member as it is when the member query fails', () async {
      when(
        () => channel.queryMembers(filter: any(named: 'filter')),
      ).thenAnswer((_) async => const Result.failure(StreamClientException(message: 'boom')));

      handler.handleEvent(UserBannedEvent(cid: 'messaging:test', user: otherUser));
      await Future<void>.value();

      verifyNever(() => mutations.onMemberBanned(any()));
    });

    test('user.banned leaves the member as it is when the member query finds none', () async {
      when(
        () => channel.queryMembers(filter: any(named: 'filter')),
      ).thenAnswer((_) async => const Result.success(QueryMembersResponse(duration: '0.01ms', members: [])));

      handler.handleEvent(UserBannedEvent(cid: 'messaging:test', user: otherUser));
      await Future<void>.value();

      verifyNever(() => mutations.onMemberBanned(any()));
    });

    test('user.banned ignores app-level bans without a cid', () async {
      handler.handleEvent(UserBannedEvent(user: otherUser));
      await Future<void>.value();

      verifyNever(() => channel.queryMembers(filter: any(named: 'filter')));
      verifyNever(() => mutations.onMemberBanned(any()));
    });

    test('user.unbanned refreshes the member before delegating', () async {
      when(
        () => channel.queryMembers(filter: any(named: 'filter')),
      ).thenAnswer((_) async => Result.success(QueryMembersResponse(duration: '0.01ms', members: [member])));

      final event = UserUnbannedEvent(
        cid: 'messaging:test',
        user: otherUser,
      );

      handler.handleEvent(event);
      await Future<void>.value();

      verify(() => mutations.onMemberUnbanned(member)).called(1);
    });

    test('user.messages.deleted delegates the deletion parameters', () async {
      final event = UserMessagesDeletedEvent(
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
  });

  group('watching events', () {
    test('user.watching.start delegates the watcher and count', () {
      final event = UserWatchingStartEvent(user: otherUser, watcherCount: 3);

      handler.handleEvent(event);

      verify(() => mutations.onUserStartWatching(otherUser, watcherCount: 3)).called(1);
    });

    test('user.watching.stop delegates the watcher and count', () {
      final event = UserWatchingStopEvent(user: otherUser, watcherCount: 2);

      handler.handleEvent(event);

      verify(() => mutations.onUserStopWatching(otherUser, watcherCount: 2)).called(1);
    });
  });

  group('reminder events', () {
    final reminder = MessageReminder(
      messageId: 'message-id',
      channelCid: 'messaging:test',
      userId: currentUserId,
      remindAt: DateTime.now(),
    );

    test('reminder.created delegates the reminder', () {
      handler.handleEvent(
        ReminderCreatedEvent(
          cid: 'messaging:test',
          messageId: 'message-id',
          userId: currentUserId,
          reminder: reminder,
        ),
      );

      verify(() => mutations.onReminderCreated(reminder)).called(1);
    });

    test('reminder.updated delegates the reminder', () {
      handler.handleEvent(
        ReminderUpdatedEvent(
          cid: 'messaging:test',
          messageId: 'message-id',
          userId: currentUserId,
          reminder: reminder,
        ),
      );

      verify(() => mutations.onReminderUpdated(reminder)).called(1);
    });

    test('reminder.deleted delegates the reminder', () {
      handler.handleEvent(
        ReminderDeletedEvent(
          cid: 'messaging:test',
          messageId: 'message-id',
          userId: currentUserId,
          reminder: reminder,
        ),
      );

      verify(() => mutations.onReminderDeleted(reminder)).called(1);
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
      final event = LocationSharedEvent(message: message);

      handler.handleEvent(event);

      verify(() => mutations.onLocationShared(message)).called(1);
    });

    test('location.shared ignores messages without a location', () {
      final message = Message(id: 'message-id');
      handler.handleEvent(LocationSharedEvent(message: message));

      verifyNever(() => mutations.onLocationShared(any()));
    });

    test('location.updated delegates the location', () {
      final message = Message(id: 'message-id', sharedLocation: location);
      final event = LocationUpdatedEvent(message: message);

      handler.handleEvent(event);

      verify(() => mutations.onLocationUpdated(location)).called(1);
    });

    test('location.expired delegates the location', () {
      final message = Message(id: 'message-id', sharedLocation: location);
      final event = LocationExpiredEvent(message: message);

      handler.handleEvent(event);

      verify(() => mutations.onLocationExpired(location)).called(1);
    });

    test('location.updated ignores events without a location', () {
      handler.handleEvent(LocationUpdatedEvent(message: Message(id: 'message-id')));

      verifyNever(() => mutations.onLocationUpdated(any()));
    });

    test('location.expired ignores events without a location', () {
      handler.handleEvent(LocationExpiredEvent(message: Message(id: 'message-id')));

      verifyNever(() => mutations.onLocationExpired(any()));
    });
  });

  group('error isolation', () {
    test('a throwing message and channel dispatch still runs the later stages', () {
      when(
        () => mutations.onMessageNew(any(), watcherCount: any(named: 'watcherCount')),
      ).thenThrow(StateError('boom'));

      handler.handleEvent(
        MessageNewEvent(
          message: Message(id: 'message-id', text: 'hi', user: otherUser),
          user: otherUser,
          watcherCount: 1,
          channelMessageCount: 42,
        ),
      );

      verify(
        () => mutations.onChannelCounts(memberCount: null, messageCount: 42),
      ).called(1);
      verify(() => mutations.onMemberUserUpdated(otherUser)).called(1);
    });

    test('a throwing channel counts stage still runs the later stages', () {
      when(
        () => mutations.onChannelCounts(
          memberCount: any(named: 'memberCount'),
          messageCount: any(named: 'messageCount'),
        ),
      ).thenThrow(StateError('boom'));

      handler.handleEvent(
        UserMessagesDeletedEvent(
          user: otherUser,
          hardDelete: true,
          channelMessageCount: 42,
        ),
      );

      verify(() => mutations.onMemberUserUpdated(otherUser)).called(1);
      verify(
        () => mutations.onUserMessagesDeleted(
          userId: otherUser.id,
          hardDelete: true,
          deletedAt: any(named: 'deletedAt'),
        ),
      ).called(1);
    });

    test('a throwing member list dispatch still runs the later stages', () {
      final member = Member(userId: otherUser.id);
      when(() => mutations.onMemberAdded(any())).thenThrow(StateError('boom'));

      handler.handleEvent(
        MemberAddedEvent(channel: channelModel, member: member, user: otherUser),
      );

      verify(() => mutations.onMemberUserUpdated(otherUser)).called(1);
    });

    test('a throwing member user merge still runs the later stages', () {
      final member = Member(userId: otherUser.id);
      when(() => mutations.onMemberUserUpdated(any())).thenThrow(StateError('boom'));

      handler.handleEvent(
        MemberUpdatedEvent(channel: channelModel, member: member, user: otherUser),
      );

      verify(() => mutations.onMemberUpdated(member)).called(1);
    });

    test('a throwing remaining dispatch does not escape handleEvent', () {
      when(
        () => mutations.onUserStartWatching(any(), watcherCount: any(named: 'watcherCount')),
      ).thenThrow(StateError('boom'));

      handler.handleEvent(
        UserWatchingStartEvent(user: otherUser, watcherCount: 1),
      );

      verify(
        () => mutations.onUserStartWatching(otherUser, watcherCount: 1),
      ).called(1);
    });

    test('a contained error is logged rather than swallowed', () {
      when(() => mutations.onMemberAdded(any())).thenThrow(StateError('boom'));

      handler.handleEvent(
        MemberAddedEvent(
          channel: channelModel,
          member: Member(userId: otherUser.id),
        ),
      );

      expect(logRecords, hasLength(1));
      expect(logRecords.single.priority, StreamLogPriority.warning);
      expect(logRecords.single.message, contains(EventType.memberAdded));
      expect(logRecords.single.error, isA<StateError>());
    });

    test('a contained error names the stage that failed', () {
      when(() => mutations.onMemberAdded(any())).thenThrow(StateError('boom'));

      handler.handleEvent(
        MemberAddedEvent(
          channel: channelModel,
          member: Member(userId: otherUser.id),
        ),
      );

      expect(logRecords.single.message, contains('member list dispatch'));
    });
  });
}

class _CapturingHandler extends StreamLogHandler {
  const _CapturingHandler(this._onRecord);

  final void Function(StreamLogRecord) _onRecord;

  @override
  void handle(StreamLogRecord record) => _onRecord(record);
}
