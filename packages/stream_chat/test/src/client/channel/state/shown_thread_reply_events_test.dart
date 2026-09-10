import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';
const _replyId = 'mirrored-reply-id';
const _parentId = 'parent-message-id';

// Pinned createdAt keeps oldIndex lookups stable in `updateMessage`.
final _createdAt = DateTime.utc(2026);

ChannelState _seedChannel(ChannelState _) {
  return createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: _channelCid,
      config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
      ownCapabilities: const [ChannelCapability.readEvents],
    ),
  );
}

// Seeds a single reply into the channel-level `messages` while leaving
// `threads[parentId]` empty — the exact regression scenario.
Message _seedMirroredReply(
  ChannelTester tester, {
  List<Reaction> ownReactions = const [],
  Poll? poll,
}) {
  final reply = Message(
    id: _replyId,
    parentId: _parentId,
    showInChannel: true,
    user: tester.currentUser,
    createdAt: _createdAt,
    ownReactions: ownReactions,
    poll: poll,
    pollId: poll?.id,
  );
  tester.channelState!.updateChannelState(
    tester.channelState!.channelState.copyWith(messages: [reply]),
  );
  return reply;
}

void main() {
  // A reply with `show_in_channel = true` is mirrored into both `messages`
  // and `threads[parentId]`. When the thread isn't loaded (fresh hydration,
  // user never opened the thread) the channel-level copy is the only place
  // locally-cached fields like `ownReactions`/`poll` survive — so reaction
  // and message-update events for such replies must still find it.
  group('reply events with `show_in_channel = true` and unloaded thread', () {
    channelTest(
      '`reaction.new` from another user preserves `ownReactions`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        final ownReaction = Reaction(
          type: 'like',
          messageId: _replyId,
          user: tester.currentUser,
        );
        _seedMirroredReply(tester, ownReactions: [ownReaction]);
        // Pre-condition: thread is not loaded.
        expect(tester.channelState!.threads, isEmpty);

        // Server reaction events don't echo back the recipient's own
        // reactions, so the listener must pull them from the cached copy.
        final otherUserReaction = Reaction(
          type: 'love',
          messageId: _replyId,
          user: User(id: 'other-user'),
        );
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.reactionNew,
            reaction: otherUserReaction,
            message: Message(
              id: _replyId,
              parentId: _parentId,
              showInChannel: true,
              user: tester.currentUser,
              createdAt: _createdAt,
              latestReactions: [otherUserReaction],
            ),
          ),
        );

        final stored = tester.channelState!.messages.firstWhere((it) => it.id == _replyId);
        expect(stored.ownReactions, [ownReaction]);
      },
    );

    channelTest(
      '`reaction.deleted` strips only the removed reaction',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        final kept = Reaction(
          type: 'like',
          messageId: _replyId,
          user: tester.currentUser,
        );
        final removed = Reaction(
          type: 'love',
          messageId: _replyId,
          user: tester.currentUser,
        );
        _seedMirroredReply(tester, ownReactions: [kept, removed]);
        expect(tester.channelState!.threads, isEmpty);

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.reactionDeleted,
            reaction: removed,
            message: Message(
              id: _replyId,
              parentId: _parentId,
              showInChannel: true,
              user: tester.currentUser,
              createdAt: _createdAt,
            ),
          ),
        );

        final stored = tester.channelState!.messages.firstWhere((it) => it.id == _replyId);
        expect(stored.ownReactions, [kept]);
      },
    );

    channelTest(
      '`message.updated` preserves `poll`, `pollId`, and `ownReactions`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        final ownReaction = Reaction(
          type: 'like',
          messageId: _replyId,
          user: tester.currentUser,
        );
        // Partial server updates can omit poll/pollId/ownReactions; the
        // cached copy is what backfills them.
        final poll = Poll(
          id: 'poll-1',
          name: 'Pick one',
          options: const [
            PollOption(text: 'A'),
            PollOption(text: 'B'),
          ],
        );
        _seedMirroredReply(tester, ownReactions: [ownReaction], poll: poll);
        expect(tester.channelState!.threads, isEmpty);

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageUpdated,
            message: Message(
              id: _replyId,
              parentId: _parentId,
              showInChannel: true,
              user: tester.currentUser,
              createdAt: _createdAt,
              text: 'edited',
            ),
          ),
        );

        final stored = tester.channelState!.messages.firstWhere((it) => it.id == _replyId);
        expect(stored.ownReactions, [ownReaction]);
        expect(stored.poll?.id, poll.id);
        expect(stored.pollId, poll.id);
      },
    );
  });
}
