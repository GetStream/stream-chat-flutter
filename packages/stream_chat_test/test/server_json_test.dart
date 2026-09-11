import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

// Every case below builds a populated model, serializes it the way the fake
// server does and decodes it again, asserting on the fields the model's own
// `toJson` drops — the whole reason these helpers exist. A helper that stops
// restoring one of them does not fail loudly: the field simply arrives as
// `null` in every event-driven test, which keeps passing. These tests are the
// guard against that, so extend them whenever a model gains a server-sent
// field.
void main() {
  group('serverMessageJson', () {
    test('restores the fields Message.toJson drops', () {
      final user = createDefaultUser(id: 'sender');
      final message = Message(
        id: 'message-1',
        text: 'hello world',
        type: MessageType.deleted,
        user: user,
        shadowed: true,
        replyCount: 3,
        command: 'giphy',
        i18n: const {'en_text': 'hello world'},
        deletedForMe: true,
        threadParticipants: [user],
        latestReactions: [createDefaultReaction(messageId: 'message-1')],
        ownReactions: [createDefaultReaction(type: 'love', messageId: 'message-1')],
        pinned: true,
        pinnedAt: DateTime.utc(2021, 5),
        pinnedBy: user,
        createdAt: DateTime.utc(2021),
        updatedAt: DateTime.utc(2021, 2),
        deletedAt: DateTime.utc(2021, 3),
        messageTextUpdatedAt: DateTime.utc(2021, 4),
        quotedMessage: createDefaultMessage(id: 'quoted-1'),
      );

      final decoded = Message.fromJson(serverMessageJson(message));

      expect(decoded.type, MessageType.deleted);
      expect(decoded.user?.id, user.id);
      expect(decoded.shadowed, isTrue);
      expect(decoded.replyCount, 3);
      expect(decoded.command, 'giphy');
      expect(decoded.i18n, message.i18n);
      expect(decoded.deletedForMe, isTrue);
      expect(decoded.threadParticipants?.single.id, user.id);
      expect(decoded.latestReactions?.single.type, 'like');
      expect(decoded.ownReactions?.single.type, 'love');
      expect(decoded.pinnedAt, message.pinnedAt);
      expect(decoded.pinnedBy?.id, user.id);
      expect(decoded.createdAt, message.createdAt);
      expect(decoded.updatedAt, message.updatedAt);
      expect(decoded.deletedAt, message.deletedAt);
      expect(decoded.messageTextUpdatedAt, message.messageTextUpdatedAt);
      // The quoted message goes through the same patching, so its own
      // server-assigned fields have to survive too.
      expect(decoded.quotedMessage?.id, 'quoted-1');
      expect(decoded.quotedMessage?.user?.id, createDefaultUser().id);
      expect(decoded.quotedMessage?.createdAt, createDefaultMessage().createdAt);
    });

    test('restores a shared location', () {
      final message = createDefaultMessage(id: 'message-1').copyWith(
        sharedLocation: testLocation(),
      );

      final decoded = Message.fromJson(serverMessageJson(message));

      expect(decoded.sharedLocation?.messageId, 'message-1');
      expect(decoded.sharedLocation?.userId, message.sharedLocation?.userId);
      expect(decoded.sharedLocation?.channelCid, message.sharedLocation?.channelCid);
    });
  });

  group('serverChannelJson', () {
    test('restores the fields ChannelModel.toJson drops', () {
      final createdBy = createDefaultUser(id: 'creator');
      final channel = createDefaultChannelModel(
        cid: 'messaging:server-json',
        createdBy: createdBy,
        memberCount: 7,
        members: [createDefaultMember()],
        ownCapabilities: const ['read-events'],
        config: createDefaultChannelConfig(readEvents: true),
        filterTags: const ['tag-1'],
        lastMessageAt: DateTime.utc(2021, 6),
      );

      final decoded = ChannelModel.fromJson(serverChannelJson(channel));

      expect(decoded.cid, 'messaging:server-json');
      expect(decoded.createdBy?.id, createdBy.id);
      expect(decoded.memberCount, 7);
      expect(decoded.members?.single.userId, createDefaultMember().userId);
      expect(decoded.ownCapabilities, const ['read-events']);
      expect(decoded.config.readEvents, isTrue);
      expect(decoded.filterTags, const ['tag-1']);
      expect(decoded.lastMessageAt, channel.lastMessageAt);
      expect(decoded.createdAt, channel.createdAt);
      expect(decoded.updatedAt, channel.updatedAt);
    });
  });

  group('serverReactionJson', () {
    test('restores the fields Reaction.toJson drops', () {
      final reaction = createDefaultReaction(messageId: 'message-1');

      final decoded = Reaction.fromJson(serverReactionJson(reaction));

      expect(decoded.messageId, 'message-1');
      expect(decoded.user?.id, reaction.user?.id);
      expect(decoded.userId, reaction.userId);
      expect(decoded.createdAt, reaction.createdAt);
    });
  });

  group('serverPollJson', () {
    test('restores the fields Poll.toJson drops', () {
      final createdBy = createDefaultUser(id: 'poll-creator');
      final vote = createDefaultPollVote(pollId: 'poll-1', optionId: 'option-1');
      final poll = Poll(
        id: 'poll-1',
        name: 'What is your favorite color?',
        options: [createDefaultPollOption(text: 'Red')],
        createdBy: createdBy,
        createdById: createdBy.id,
        voteCount: 4,
        answersCount: 2,
        voteCountsByOption: const {'option-1': 4},
        latestVotesByOption: {
          'option-1': [vote],
        },
        ownVotesAndAnswers: [vote],
        createdAt: DateTime.utc(2021),
        updatedAt: DateTime.utc(2021, 2),
      );

      final decoded = Poll.fromJson(serverPollJson(poll));

      expect(decoded.voteCount, 4);
      expect(decoded.answersCount, 2);
      expect(decoded.voteCountsByOption, const {'option-1': 4});
      expect(decoded.latestVotesByOption['option-1']?.single.pollId, 'poll-1');
      expect(decoded.ownVotesAndAnswers.single.optionId, 'option-1');
      expect(decoded.createdBy?.id, createdBy.id);
      expect(decoded.createdById, poll.createdById);
      expect(decoded.createdAt, poll.createdAt);
      expect(decoded.updatedAt, poll.updatedAt);
    });
  });

  group('serverPollVoteJson', () {
    test('restores the fields PollVote.toJson drops', () {
      final pollVote = createDefaultPollVote(pollId: 'poll-1', optionId: 'option-1');

      final decoded = PollVote.fromJson(serverPollVoteJson(pollVote));

      expect(decoded.pollId, 'poll-1');
      expect(decoded.userId, pollVote.userId);
      expect(decoded.user?.id, pollVote.user?.id);
      expect(decoded.createdAt, pollVote.createdAt);
    });
  });

  group('serverDraftJson', () {
    test('restores the nested payloads Draft.toJson serializes lossily', () {
      final draft =
          createDefaultDraft(
            message: DraftMessage(
              id: 'draft-1',
              text: 'draft text',
              command: 'giphy',
              mentionedUsers: [createDefaultUser(id: 'mentioned')],
              quotedMessage: createDefaultMessage(id: 'quoted-1'),
            ),
          ).copyWith(
            channel: createDefaultChannelModel(cid: 'messaging:draft'),
            parentMessage: createDefaultMessage(id: 'parent-1'),
          );

      final decoded = Draft.fromJson(serverDraftJson(draft));

      expect(decoded.message.text, 'draft text');
      expect(decoded.message.command, 'giphy');
      expect(decoded.message.mentionedUsers.single.id, 'mentioned');
      expect(decoded.message.quotedMessage?.user?.id, createDefaultUser().id);
      expect(decoded.channel?.cid, 'messaging:draft');
      expect(decoded.parentMessage?.user?.id, createDefaultUser().id);
    });
  });

  group('serverReminderJson', () {
    test('restores the fields MessageReminder.toJson drops', () {
      final reminder = createDefaultMessageReminder(
        channel: createDefaultChannelModel(cid: 'messaging:reminder'),
        message: createDefaultMessage(id: 'reminded-1'),
        user: createDefaultUser(id: 'reminder-user'),
      );

      final decoded = MessageReminder.fromJson(serverReminderJson(reminder));

      expect(decoded.channel?.cid, 'messaging:reminder');
      expect(decoded.message?.user?.id, createDefaultUser().id);
      expect(decoded.user?.id, 'reminder-user');
      expect(decoded.createdAt, reminder.createdAt);
      expect(decoded.updatedAt, reminder.updatedAt);
    });
  });

  group('serverLocationJson', () {
    test('restores the fields Location.toJson drops', () {
      final location = testLocation();

      final decoded = Location.fromJson(serverLocationJson(location));

      expect(decoded.messageId, 'message-1');
      expect(decoded.userId, location.userId);
      expect(decoded.channelCid, location.channelCid);
      expect(decoded.createdAt, location.createdAt);
      expect(decoded.updatedAt, location.updatedAt);
    });
  });

  group('serverEventJson', () {
    test('patches every nested payload the event carries', () {
      final event = createDefaultEvent(
        type: 'message.new',
        cid: 'messaging:test-channel',
        message: createDefaultMessage(id: 'message-1'),
        channel: createDefaultChannelModel(cid: 'messaging:test-channel'),
        reaction: createDefaultReaction(messageId: 'message-1'),
        poll: createDefaultPoll(id: 'poll-1'),
        pollVote: createDefaultPollVote(pollId: 'poll-1', optionId: 'option-1'),
        draft: createDefaultDraft(),
        reminder: createDefaultMessageReminder(),
      );

      final decoded = Event.fromJson(serverEventJson(event));

      // Each nested payload keeps the server-assigned fields its own `toJson`
      // would have dropped.
      expect(decoded.message?.user?.id, createDefaultUser().id);
      expect(decoded.message?.createdAt, createDefaultMessage().createdAt);
      expect(decoded.channel?.cid, 'messaging:test-channel');
      expect(decoded.reaction?.messageId, 'message-1');
      expect(decoded.reaction?.user?.id, createDefaultUser().id);
      expect(decoded.poll?.createdAt, createDefaultPoll().createdAt);
      expect(decoded.pollVote?.pollId, 'poll-1');
      expect(decoded.draft?.message.text, createDefaultDraft().message.text);
      expect(decoded.reminder?.createdAt, createDefaultMessageReminder().createdAt);
    });
  });
}

// Built inline: the package has no `Location` factory, and these two cases
// are its only consumers.
Location testLocation({String messageId = 'message-1'}) => Location(
  channelCid: 'messaging:test-channel',
  messageId: messageId,
  userId: 'luke_skywalker',
  latitude: 40.7128,
  longitude: -74.0060,
  createdByDeviceId: 'device-1',
  createdAt: DateTime.utc(2021),
  updatedAt: DateTime.utc(2021, 2),
);
