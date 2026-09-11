import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState Function(ChannelState) _seedChannel() {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(cid: _channelCid),
  );
}

Event _updateMessageEvent(Message message) => createDefaultEvent(
  type: EventType.messageUpdated,
  cid: _channelCid,
  message: message,
);

void main() {
  group('Message enrichment preservation on merge', () {
    channelTest(
      'preserves the `poll` on a quotedMessage when the server omits it during '
      're-sync (regression: poll quote disappears after foregrounding)',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-1',
          name: 'Pizza or pasta?',
          options: const [
            PollOption(id: 'opt-1', text: 'Pizza'),
            PollOption(id: 'opt-2', text: 'Pasta'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'poll-msg-1',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
        );

        final replyToPoll = Message(
          id: 'reply-1',
          text: 'Voting now',
          quotedMessageId: pollMessage.id,
          quotedMessage: pollMessage,
          user: User(id: 'reply-user'),
          createdAt: DateTime.utc(2026, 4, 29, 11),
        );

        // Seed channel state with the fully-enriched messages (mirrors what
        // the local DB load produces).
        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            messages: [pollMessage, replyToPoll],
          ),
        );

        // Simulate a re-sync from the API: the server echoes the reply with
        // a `quoted_message` that has only `poll_id` (no `poll` object).
        // Constructed directly (not via copyWith) because copyWith cannot
        // clear `poll` — see Message.copyWith.
        final strippedPollSnapshot = Message(
          id: pollMessage.id,
          pollId: pollMessage.pollId,
          user: pollUser,
          createdAt: pollMessage.createdAt,
        );
        final reSyncedReply = replyToPoll.copyWith(quotedMessage: strippedPollSnapshot);

        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            messages: [reSyncedReply],
          ),
        );

        final mergedReply = tester.channelState?.messages.firstWhere((it) => it.id == replyToPoll.id);

        expect(mergedReply, isNotNull);
        expect(mergedReply!.quotedMessage, isNotNull);
        expect(mergedReply.quotedMessage!.id, pollMessage.id);
        expect(mergedReply.quotedMessage!.poll, isNotNull);
        expect(mergedReply.quotedMessage!.poll!.id, poll.id);
        expect(mergedReply.quotedMessage!.poll!.name, poll.name);
      },
    );

    channelTest(
      'preserves a nested quotedMessage (poll) two levels deep when the '
      'server omits it during re-sync (regression: quote-of-quote of a poll '
      'disappears completely after foregrounding)',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-2',
          name: 'Coffee or tea?',
          options: const [
            PollOption(id: 'opt-a', text: 'Coffee'),
            PollOption(id: 'opt-b', text: 'Tea'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'poll-msg-2',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
        );

        final replyToPoll = Message(
          id: 'reply-A',
          text: 'My pick',
          quotedMessageId: pollMessage.id,
          quotedMessage: pollMessage,
          user: User(id: 'user-a'),
          createdAt: DateTime.utc(2026, 4, 29, 11),
        );

        final replyToReply = Message(
          id: 'reply-B',
          text: 'Same here',
          quotedMessageId: replyToPoll.id,
          quotedMessage: replyToPoll,
          user: User(id: 'user-b'),
          createdAt: DateTime.utc(2026, 4, 29, 12),
        );

        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            messages: [pollMessage, replyToPoll, replyToReply],
          ),
        );

        // Simulate the server response where:
        // - replyA's nested quoted poll is missing the `poll` object.
        // - replyB's nested quoted replyA is missing its own `quoted_message`
        //   (the server typically does not nest two levels deep).
        // Stripped poll snapshot is constructed directly because copyWith
        // cannot clear `poll` — see Message.copyWith.
        final strippedPollSnapshot = Message(
          id: pollMessage.id,
          pollId: pollMessage.pollId,
          user: pollUser,
          createdAt: pollMessage.createdAt,
        );
        final strippedReplyA = replyToPoll.copyWith(quotedMessage: null);

        final reSyncedReplyA = replyToPoll.copyWith(quotedMessage: strippedPollSnapshot);
        final reSyncedReplyB = replyToReply.copyWith(quotedMessage: strippedReplyA);

        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            messages: [pollMessage, reSyncedReplyA, reSyncedReplyB],
          ),
        );

        final mergedReplyA = tester.channelState?.messages.firstWhere((it) => it.id == replyToPoll.id);
        final mergedReplyB = tester.channelState?.messages.firstWhere((it) => it.id == replyToReply.id);

        // First-level quote (reply A's quote of the poll) must keep the poll.
        expect(mergedReplyA?.quotedMessage?.poll, isNotNull);
        expect(mergedReplyA?.quotedMessage?.poll?.id, poll.id);

        // Second-level quote (reply B's quote of reply A) must keep reply A's
        // own nested quotedMessage so the poll preview still resolves.
        expect(mergedReplyB?.quotedMessage, isNotNull);
        expect(mergedReplyB?.quotedMessage?.id, replyToPoll.id);
        expect(mergedReplyB?.quotedMessage?.quotedMessage, isNotNull);
        expect(mergedReplyB?.quotedMessage?.quotedMessage?.id, pollMessage.id);
        expect(mergedReplyB?.quotedMessage?.quotedMessage?.poll, isNotNull);
        expect(mergedReplyB?.quotedMessage?.quotedMessage?.poll?.id, poll.id);
      },
    );

    channelTest(
      'still preserves quotedMessage when the updated payload has no '
      'quoted_message at all (existing behavior should not regress)',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-3',
          name: 'Beach or mountains?',
          options: const [
            PollOption(id: 'opt-x', text: 'Beach'),
            PollOption(id: 'opt-y', text: 'Mountains'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'poll-msg-3',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
        );

        final replyToPoll = Message(
          id: 'reply-3',
          text: 'Definitely beach',
          quotedMessageId: pollMessage.id,
          quotedMessage: pollMessage,
          user: User(id: 'reply-user'),
          createdAt: DateTime.utc(2026, 4, 29, 11),
        );

        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            messages: [pollMessage, replyToPoll],
          ),
        );

        // Simulate an update event that touches the reply but doesn't echo
        // the nested quoted_message at all (only quotedMessageId is set).
        final reSyncedReply = Message(
          id: replyToPoll.id,
          text: 'Definitely beach (edited)',
          quotedMessageId: pollMessage.id,
          user: replyToPoll.user,
          createdAt: replyToPoll.createdAt,
        );

        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            messages: [reSyncedReply],
          ),
        );

        final mergedReply = tester.channelState?.messages.firstWhere((it) => it.id == replyToPoll.id);

        expect(mergedReply, isNotNull);
        expect(mergedReply!.text, 'Definitely beach (edited)');
        expect(mergedReply.quotedMessage, isNotNull);
        expect(mergedReply.quotedMessage!.poll?.id, poll.id);
      },
    );

    channelTest(
      'preserves the top-level `poll` when the server emits a `message.updated`'
      ' that omits the `poll` object (regression: poll disappears from the '
      'parent message after a thread reply is added)',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-thread',
          name: 'What is for lunch?',
          options: const [
            PollOption(id: 'opt-1', text: 'Burgers'),
            PollOption(id: 'opt-2', text: 'Salads'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'parent-poll-msg',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
          replyCount: 0,
        );

        // Seed channel state with the fully-enriched parent poll message.
        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            messages: [pollMessage],
          ),
        );

        // Simulate the `message.updated` event the backend fires for the
        // parent after a thread reply is added: bookkeeping fields are bumped
        // (`reply_count`, `updated_at`) but the `poll` object is omitted from
        // the payload — only `pollId` is set. Constructed directly because
        // copyWith cannot clear `poll` — see Message.copyWith.
        final strippedParentUpdate = Message(
          id: pollMessage.id,
          pollId: pollMessage.pollId,
          user: pollUser,
          createdAt: pollMessage.createdAt,
          replyCount: 1,
          updatedAt: DateTime.utc(2026, 4, 29, 11),
        );

        await tester.emitEvent(_updateMessageEvent(strippedParentUpdate));

        final merged = tester.channelState?.messages.firstWhere((it) => it.id == pollMessage.id);

        // Parent poll message must remain in the channel state after a thread reply.
        expect(merged, isNotNull);
        // Bookkeeping fields from the event should still apply.
        expect(merged!.replyCount, 1);
        // Locally-known poll must be preserved when the server omits it from a
        // `message.updated` payload (e.g. when a thread reply bumps reply_count).
        expect(merged.poll, isNotNull);
        expect(merged.poll!.id, poll.id);
        expect(merged.poll!.name, poll.name);
        expect(merged.pollId, poll.id);
      },
    );

    channelTest(
      'still uses the updated `poll` when the server includes one in '
      '`message.updated` (poll edits should not be reverted to the locally '
      'cached version)',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-edit',
          name: 'Initial name',
          options: const [
            PollOption(id: 'opt-1', text: 'Original A'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'edit-parent',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
        );

        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            messages: [pollMessage],
          ),
        );

        final updatedPoll = poll.copyWith(name: 'Edited name');
        final updatedParent = pollMessage.copyWith(poll: updatedPoll, updatedAt: DateTime.utc(2026, 4, 29, 12));

        await tester.emitEvent(_updateMessageEvent(updatedParent));

        final merged = tester.channelState?.messages.firstWhere((it) => it.id == pollMessage.id);

        // Server-echoed poll must override the locally cached one — poll edits
        // should not be reverted by the local-fallback merge.
        expect(merged?.poll, isNotNull);
        expect(merged?.poll?.name, 'Edited name');
      },
    );
  });
}
