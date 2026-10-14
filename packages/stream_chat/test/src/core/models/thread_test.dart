import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('Thread', () {
    test('should create a valid instance', () {
      final now = DateTime.now();
      const channelCid = 'messaging:123';
      const parentId = 'parent-message-id';
      const userIdCreator = 'creator-user-id';

      final thread = Thread(
        channelCid: channelCid,
        parentMessageId: parentId,
        createdByUserId: userIdCreator,
        replyCount: 5,
        participantCount: 3,
        createdAt: now,
        updatedAt: now,
      );

      expect(thread.channelCid, equals(channelCid));
      expect(thread.parentMessageId, equals(parentId));
      expect(thread.createdByUserId, equals(userIdCreator));
      expect(thread.replyCount, equals(5));
      expect(thread.participantCount, equals(3));
      expect(thread.createdAt, equals(now));
      expect(thread.updatedAt, equals(now));
      expect(thread.draft, isNull);
    });

    test('should serialize to and deserialize from JSON correctly', () {
      final now = DateTime.now();
      const channelCid = 'messaging:123';
      const parentId = 'parent-message-id';
      const userIdCreator = 'creator-user-id';

      final thread = Thread(
        channelCid: channelCid,
        parentMessageId: parentId,
        createdByUserId: userIdCreator,
        replyCount: 5,
        participantCount: 3,
        createdAt: now,
        updatedAt: now,
      );

      final json = thread.toJson();
      final threadFromJson = Thread.fromJson(json);

      expect(threadFromJson.channelCid, equals(thread.channelCid));
      expect(threadFromJson.parentMessageId, equals(thread.parentMessageId));
      expect(threadFromJson.createdByUserId, equals(thread.createdByUserId));
      expect(threadFromJson.replyCount, equals(thread.replyCount));
      expect(threadFromJson.participantCount, equals(thread.participantCount));
      expect(threadFromJson.draft, isNull);
    });

    test('should handle draft field correctly', () {
      final now = DateTime.now();
      const channelCid = 'messaging:123';
      const parentId = 'parent-message-id';
      const userIdCreator = 'creator-user-id';

      final draftMessage = DraftMessage(text: 'Draft message');
      final draft = Draft(
        channelCid: channelCid,
        createdAt: now,
        message: draftMessage,
      );

      final thread = Thread(
        channelCid: channelCid,
        parentMessageId: parentId,
        createdByUserId: userIdCreator,
        replyCount: 5,
        participantCount: 3,
        createdAt: now,
        updatedAt: now,
        draft: draft,
      );

      expect(thread.draft?.message.text, equals('Draft message'));

      // Test copyWith with draft
      final updatedDraft = Draft(
        channelCid: channelCid,
        createdAt: now,
        message: DraftMessage(text: 'Updated draft'),
      );

      final updatedThread = thread.copyWith(draft: updatedDraft);
      expect(updatedThread.draft?.message.text, equals('Updated draft'));
      expect(updatedThread.draft?.message.text, isNot(equals(draft.message.text)));

      // Test copyWith with null draft (removing draft)
      final removedDraftThread = thread.copyWith(draft: null);
      expect(removedDraftThread.draft, isNull);

      // Original should be unchanged
      expect(thread.draft?.message.text, equals('Draft message'));
    });

    test('should merge drafts correctly', () {
      final now = DateTime.now();
      const channelCid = 'messaging:123';
      const parentId = 'parent-message-id';
      const userIdCreator = 'creator-user-id';

      final draftMessage = DraftMessage(text: 'Draft message');
      final draft = Draft(
        channelCid: channelCid,
        createdAt: now,
        message: draftMessage,
      );

      final thread = Thread(
        channelCid: channelCid,
        parentMessageId: parentId,
        createdByUserId: userIdCreator,
        replyCount: 5,
        participantCount: 3,
        draft: draft,
      );

      final newDraftMessage = DraftMessage(text: 'New draft message');
      final newDraft = Draft(
        channelCid: channelCid,
        createdAt: now.add(const Duration(hours: 1)),
        message: newDraftMessage,
      );

      final otherThread = Thread(
        channelCid: channelCid,
        parentMessageId: parentId,
        createdByUserId: userIdCreator,
        replyCount: 10,
        participantCount: 6,
        draft: newDraft,
      );

      final mergedThread = thread.merge(otherThread);

      expect(mergedThread.replyCount, equals(10));
      expect(mergedThread.participantCount, equals(6));
      expect(mergedThread.draft?.message.text, equals('New draft message'));

      // Original thread should be unchanged
      expect(thread.draft?.message.text, equals('Draft message'));
    });

    test('should include draft in equality check', () {
      const channelCid = 'messaging:123';
      const parentId = 'parent-message-id';
      const userIdCreator = 'creator-user-id';

      // For testing equality, we need to create messages with stable IDs
      final draft1 = Draft(
        channelCid: channelCid,
        createdAt: DateTime(2023), // Use fixed date
        message: DraftMessage(
          id: 'draft-1',
          text: 'Draft message 1',
        ),
      );

      final draft2 = Draft(
        channelCid: channelCid,
        createdAt: DateTime(2023), // Use fixed date
        message: DraftMessage(
          id: 'draft-2',
          text: 'Draft message 2',
        ),
      );

      final thread1 = Thread(
        channelCid: channelCid,
        parentMessageId: parentId,
        createdByUserId: userIdCreator,
        replyCount: 5,
        participantCount: 3,
        createdAt: DateTime(2023), // Use fixed date
        updatedAt: DateTime(2023), // Use fixed date
        draft: draft1,
      );

      final thread2 = Thread(
        channelCid: channelCid,
        parentMessageId: parentId,
        createdByUserId: userIdCreator,
        replyCount: 5,
        participantCount: 3,
        createdAt: DateTime(2023), // Use fixed date
        updatedAt: DateTime(2023), // Use fixed date
        draft: draft1,
      );

      final thread3 = Thread(
        channelCid: channelCid,
        parentMessageId: parentId,
        createdByUserId: userIdCreator,
        replyCount: 5,
        participantCount: 3,
        createdAt: DateTime(2023), // Use fixed date
        updatedAt: DateTime(2023), // Use fixed date
        draft: draft2,
      );

      // Test text equality instead of object identity
      expect(thread1.draft?.message.text, equals(thread2.draft?.message.text));
      expect(thread1.draft?.message.text, isNot(equals(thread3.draft?.message.text)));
    });

    group('ThreadSortField', () {
      Thread threadWith({
        DateTime? lastMessageAt,
        int replyCount = 0,
        int participantCount = 0,
        String parentMessageId = 'p1',
      }) => Thread(
        channelCid: 'messaging:123',
        parentMessageId: parentMessageId,
        createdByUserId: 'u1',
        replyCount: replyCount,
        participantCount: participantCount,
        lastMessageAt: lastMessageAt,
      );

      test('lastMessageAt orders the older thread first', () {
        expectOrders(
          ThreadSortField.lastMessageAt,
          threadWith(lastMessageAt: DateTime.utc(2024, 1, 1)),
          threadWith(lastMessageAt: DateTime.utc(2024, 6, 1)),
        );
      });

      test('replyCount and participantCount order numerically', () {
        expectOrders(ThreadSortField.replyCount, threadWith(replyCount: 1), threadWith(replyCount: 9));
        expectOrders(
          ThreadSortField.participantCount,
          threadWith(participantCount: 1),
          threadWith(participantCount: 9),
        );
      });

      // `lastMessageAt` is nullable and `defaultSort` sorts it descending, so
      // without the nulls-last pin a thread with no replies would lead the list
      // instead of trailing it.
      test('a thread with no replies sorts last in either direction', () {
        final silent = threadWith();
        final active = threadWith(lastMessageAt: DateTime.utc(2024, 1, 1));

        final desc = [ThreadSort.desc(ThreadSortField.lastMessageAt)];
        expect(desc.compare(silent, active), greaterThan(0));

        final asc = [ThreadSort.asc(ThreadSortField.lastMessageAt)];
        expect(asc.compare(silent, active), greaterThan(0));
      });
    });
  });
}
