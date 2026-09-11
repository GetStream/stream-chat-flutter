import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';
const _messageId = 'reaction-message-id';

// Pinned createdAt keeps message index lookups stable in `updateMessage`.
final _createdAt = DateTime.utc(2021, 3);

ChannelState Function(ChannelState) _seedChannel() {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(cid: _channelCid),
  );
}

Message _seedMessage(ChannelTester tester, {String? parentId, List<Reaction> ownReactions = const []}) {
  final message = Message(
    id: _messageId,
    parentId: parentId,
    user: User(id: 'other-user'),
    text: 'react to me',
    createdAt: _createdAt,
    ownReactions: ownReactions,
  );
  tester.channelState!.updateMessage(message);
  return message;
}

void main() {
  group('Reaction events', () {
    channelTest(
      '${EventType.reactionNew} from the current user is added to ownReactions',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        _seedMessage(tester);

        final reaction = Reaction(
          type: 'like',
          messageId: _messageId,
          user: tester.currentUser,
        );
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.reactionNew,
            reaction: reaction,
            message: Message(
              id: _messageId,
              user: User(id: 'other-user'),
              createdAt: _createdAt,
              latestReactions: [reaction],
            ),
          ),
        );

        final stored = tester.channelState!.messages.firstWhere((it) => it.id == _messageId);
        expect(stored.ownReactions?.map((r) => r.type), ['like']);
      },
    );

    channelTest(
      '${EventType.reactionNew} updates a thread message',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        const parentId = 'reaction-parent-id';
        _seedMessage(tester, parentId: parentId);

        final reaction = Reaction(
          type: 'like',
          messageId: _messageId,
          user: tester.currentUser,
        );
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.reactionNew,
            reaction: reaction,
            message: Message(
              id: _messageId,
              parentId: parentId,
              user: User(id: 'other-user'),
              createdAt: _createdAt,
            ),
          ),
        );

        final stored = tester.channelState!.threads[parentId]!.firstWhere((it) => it.id == _messageId);
        expect(stored.ownReactions?.map((r) => r.type), ['like']);
      },
    );

    channelTest(
      '${EventType.reactionUpdated} from the current user replaces ownReactions',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final existing = Reaction(
          type: 'love',
          messageId: _messageId,
          user: tester.currentUser,
        );
        _seedMessage(tester, ownReactions: [existing]);

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.reactionUpdated,
            reaction: Reaction(
              type: 'like',
              messageId: _messageId,
              user: tester.currentUser,
            ),
            message: Message(
              id: _messageId,
              user: User(id: 'other-user'),
              createdAt: _createdAt,
            ),
          ),
        );

        final stored = tester.channelState!.messages.firstWhere((it) => it.id == _messageId);
        expect(stored.ownReactions?.map((r) => r.type), ['like']);
      },
    );

    channelTest(
      '${EventType.reactionDeleted} updates a thread message',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        const parentId = 'reaction-parent-id';
        final removed = Reaction(
          type: 'love',
          messageId: _messageId,
          user: tester.currentUser,
        );
        _seedMessage(tester, parentId: parentId, ownReactions: [removed]);

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.reactionDeleted,
            reaction: removed,
            message: Message(
              id: _messageId,
              parentId: parentId,
              user: User(id: 'other-user'),
              createdAt: _createdAt,
            ),
          ),
        );

        final stored = tester.channelState!.threads[parentId]!.firstWhere((it) => it.id == _messageId);
        expect(stored.ownReactions, isEmpty);
      },
    );
  });
}
