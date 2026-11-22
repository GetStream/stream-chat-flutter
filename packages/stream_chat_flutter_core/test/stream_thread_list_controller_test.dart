import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

void main() {
  test('Thread.deleteReply moves lastMessageAt to the reply before the deleted one', () {
    final firstReplyAt = DateTime(2026, 10, 20, 10);
    final thread = _thread(
      latestReplies: [
        Message(id: 'first', parentId: 'parent', createdAt: firstReplyAt),
        Message(id: 'last', parentId: 'parent', createdAt: DateTime(2026, 10, 20, 11)),
      ],
    );

    final updated = thread.deleteReply(Message(id: 'last', parentId: 'parent'));

    expect(updated.lastMessageAt, firstReplyAt);
  });

  test('Thread.deleteReply leaves the thread unchanged for a reply it does not hold', () {
    final thread = _thread(
      latestReplies: [
        Message(id: 'first', parentId: 'parent', createdAt: DateTime(2026, 10, 20, 10)),
      ],
    );

    final updated = thread.deleteReply(Message(id: 'unsent', parentId: 'parent'));

    expect(updated, same(thread));
  });
}

// A thread under the 'parent' message whose latest replies are [latestReplies].
Thread _thread({required List<Message> latestReplies}) {
  final lastReplyAt = latestReplies.last.createdAt;
  return Thread(
    channelCid: 'messaging:general',
    parentMessageId: 'parent',
    createdByUserId: 'user',
    replyCount: latestReplies.length,
    participantCount: 1,
    lastMessageAt: lastReplyAt,
    updatedAt: lastReplyAt,
    latestReplies: latestReplies,
  );
}
