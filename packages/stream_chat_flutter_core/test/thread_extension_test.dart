import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/stream_thread_list_controller.dart';

void main() {
  test("Thread.deleteReply keeps the thread's dates when it removes the last reply", () {
    final reply = Message(id: 'reply-id', parentId: 'parent-id', createdAt: DateTime.utc(2026, 1, 3));
    final thread = Thread(
      channelCid: 'messaging:general',
      parentMessageId: 'parent-id',
      createdByUserId: 'creator',
      replyCount: 1,
      participantCount: 1,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026, 1, 5),
      lastMessageAt: DateTime.utc(2026, 1, 4),
      latestReplies: [reply],
    );

    final updated = thread.deleteReply(reply);

    expect((updated.updatedAt, updated.lastMessageAt), (DateTime.utc(2026, 1, 5), DateTime.utc(2026, 1, 4)));
  });

  test("Thread.updateParent keeps the thread's deletion date when the parent is not deleted", () {
    final thread = Thread(
      channelCid: 'messaging:general',
      parentMessageId: 'parent-id',
      createdByUserId: 'creator',
      replyCount: 1,
      participantCount: 1,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
      deletedAt: DateTime.utc(2026, 1, 2),
    );

    final updated = thread.updateParent(Message(id: 'parent-id', text: 'Edited'));

    expect(updated.deletedAt, DateTime.utc(2026, 1, 2));
  });
}
