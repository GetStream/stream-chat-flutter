import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState Function(ChannelState) _seedChannel({required List<Message> messages}) {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(cid: _channelCid),
    messages: messages,
  );
}

void main() {
  group('updateMessage quoted-rewrite', () {
    channelTest(
      'rewrites quotedMessage on every quoter when target is deleted',
      channelType: _channelType,
      channelId: _channelId,
      body: (tester) async {
        final now = DateTime.utc(2021, 3);
        final target = Message(id: 'target', text: 'hi', createdAt: now);
        final quoter1 = Message(
          id: 'q1',
          text: 'reply',
          quotedMessageId: 'target',
          quotedMessage: target,
          createdAt: now.add(const Duration(seconds: 1)),
        );
        final unrelated = Message(
          id: 'u1',
          text: 'other',
          createdAt: now.add(const Duration(seconds: 2)),
        );
        final quoter2 = Message(
          id: 'q2',
          text: 'reply2',
          quotedMessageId: 'target',
          quotedMessage: target,
          createdAt: now.add(const Duration(seconds: 3)),
        );

        await tester.watch(
          modifyResponse: _seedChannel(messages: [target, quoter1, unrelated, quoter2]),
        );

        final unrelatedBefore = tester.channelState!.messages.firstWhere((m) => m.id == 'u1');

        final deleted = target.copyWith(
          type: MessageType.deleted,
          deletedAt: now.add(const Duration(seconds: 5)),
        );
        tester.channelState!.updateMessage(deleted);

        final after = tester.channelState!.messages;
        final q1After = after.firstWhere((m) => m.id == 'q1');
        final q2After = after.firstWhere((m) => m.id == 'q2');
        final uAfter = after.firstWhere((m) => m.id == 'u1');

        expect(q1After.quotedMessage?.deletedAt, isNotNull);
        expect(q1After.quotedMessage?.type, MessageType.deleted);
        expect(q2After.quotedMessage?.deletedAt, isNotNull);
        expect(q2After.quotedMessage?.type, MessageType.deleted);
        // Unrelated messages must not be rebuilt by the rewrite.
        expect(identical(uAfter, unrelatedBefore), isTrue);
      },
    );

    channelTest(
      'preserves messages reference when no message quotes the deleted one',
      channelType: _channelType,
      channelId: _channelId,
      body: (tester) async {
        final now = DateTime.utc(2021, 3);
        final target = Message(id: 'target', text: 'hi', createdAt: now);
        final unrelated = Message(
          id: 'u1',
          text: 'other',
          createdAt: now.add(const Duration(seconds: 1)),
        );

        await tester.watch(modifyResponse: _seedChannel(messages: [target, unrelated]));

        final deleted = target.copyWith(
          type: MessageType.deleted,
          deletedAt: now.add(const Duration(seconds: 5)),
        );
        tester.channelState!.updateMessage(deleted);

        // No message quotes `target`, so `updateIf` short-circuits and the
        // remaining messages keep their identities (only `target` itself was
        // replaced by `sortedUpsert`).
        final unrelatedAfter = tester.channelState!.messages.firstWhere((m) => m.id == 'u1');
        expect(identical(unrelatedAfter, unrelated), isTrue);
      },
    );

    channelTest(
      'does not rewrite quotes when an existing quoted target is updated '
      'without being deleted',
      channelType: _channelType,
      channelId: _channelId,
      body: (tester) async {
        final now = DateTime.utc(2021, 3);
        final target = Message(id: 'target', text: 'original', createdAt: now);
        final quoter = Message(
          id: 'q1',
          text: 'reply',
          quotedMessageId: 'target',
          quotedMessage: target,
          createdAt: now.add(const Duration(seconds: 1)),
        );

        await tester.watch(modifyResponse: _seedChannel(messages: [target, quoter]));

        final quoterBefore = tester.channelState!.messages.firstWhere((m) => m.id == 'q1');

        // Plain text update — not a deletion.
        tester.channelState!.updateMessage(target.copyWith(text: 'edited'));

        final quoterAfter = tester.channelState!.messages.firstWhere((m) => m.id == 'q1');
        // `updateIf` is gated on `message.isDeleted`, so the quoter must keep
        // its identity (no allocation, no quoted-message overwrite).
        expect(identical(quoterAfter, quoterBefore), isTrue);
      },
    );
  });
}
