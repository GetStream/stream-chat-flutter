// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/draft_message_dao.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

import '../../stream_chat_persistence_client_test.dart';

void main() {
  late DraftMessageDao draftMessageDao;
  late DriftChatDatabase database;

  setUp(() {
    database = testDatabaseProvider('testUserId');
    draftMessageDao = database.draftMessageDao;
  });

  tearDown(() async {
    await database.close();
  });

  Future<List<Draft>> _prepareTestData(
    String cid, {
    int count = 3,
    bool withParentMessage = false,
    bool withQuotedMessage = false,
    bool withPoll = false,
  }) async {
    final channels = [ChannelModel(cid: cid)];
    final users = List.generate(
      count,
      (index) => User(id: 'testUserId$index'),
    );
    final messages = List.generate(
      count,
      (index) => Message(
        id: 'testMessageId$cid$index',
        type: 'testType',
        user: users[index],
        createdAt: DateTime.now(),
        text: 'Hello #$index',
      ),
    );

    final polls = withPoll
        ? List.generate(
            count,
            (index) => Poll(
              id: 'testPollId$index',
              name: 'Test Poll Question #$index',
              options: const [
                PollOption(id: 'option1', text: 'Option 1'),
                PollOption(id: 'option2', text: 'Option 2'),
              ],
            ),
          )
        : null;

    final drafts = List.generate(
      count,
      (index) {
        // When count is 1, use the exact cid provided
        // Otherwise, create unique cids for each draft to avoid conflicts
        final draftChannelCid =
            count == 1 ? cid : (withParentMessage ? cid : '$cid$index');

        final draftMessage = DraftMessage(
          id: 'testDraftId$cid$index',
          text: 'Draft message #$index',
          attachments: [
            Attachment(
              id: 'testAttachmentId$index',
              type: 'testAttachmentType',
              assetUrl: 'testAssetUrl',
            ),
          ],
          mentionedUsers: [users[index]],
          quotedMessageId: withQuotedMessage ? messages[index].id : null,
          parentId: withParentMessage ? messages[index].id : null,
          pollId: withPoll && polls != null ? polls[index].id : null,
          extraData: {'extra_test_field': 'extraTestData$index'},
        );

        return Draft(
          channelCid: draftChannelCid,
          createdAt: DateTime.now().subtract(Duration(minutes: index)),
          message: draftMessage,
          parentId: withParentMessage ? messages[index].id : null,
        );
      },
    );

    await database.userDao.updateUsers(users);

    // Create a channel for each draft to avoid cid conflicts
    final allChannels = [
      for (final draft in drafts) ChannelModel(cid: draft.channelCid),
      ...channels,
    ];

    await database.channelDao.updateChannels(allChannels);

    if (withParentMessage || withQuotedMessage) {
      await database.messageDao.updateMessages(cid, messages);
    }

    if (withPoll && polls != null) {
      await database.pollDao.updatePolls(polls);
    }

    await draftMessageDao.updateDraftMessages(drafts);
    return drafts;
  }

  group('getDraftMessageById', () {
    test('should return null for a non-existent draft message id', () async {
      final draft = await draftMessageDao.getDraftMessageById(
        'non-existent-id',
      );
      expect(draft, isNull);
    });

    test('should return the draft message for a valid id', () async {
      const cid = 'test:getDraftById';
      final testDrafts =
          await _prepareTestData(cid, count: 1); // Just create one draft
      final testDraftId = testDrafts.first.message.id;

      final draft = await draftMessageDao.getDraftMessageById(testDraftId);

      expect(draft, isNotNull);
      expect(draft!.message.id, testDraftId);
      expect(draft.channelCid, cid);
      expect(draft.message.text, 'Draft message #0');
      expect(draft.message.attachments, isNotEmpty);
      expect(draft.message.mentionedUsers, isNotEmpty);
    });
  });

  group('getDraftMessageByCid', () {
    test('should return null for a non-existent channel cid', () async {
      final draft = await draftMessageDao.getDraftMessageByCid(
        'non-existent-cid',
      );
      expect(draft, isNull);
    });

    test('should return the draft message for a valid channel cid', () async {
      const cid = 'test:getDraftByCid';
      await _prepareTestData(cid, count: 1);

      final draft = await draftMessageDao.getDraftMessageByCid(cid);

      expect(draft, isNotNull);
      expect(draft!.channelCid, cid);
      expect(draft.message.text, 'Draft message #0');
    });

    test(
      'should not return thread drafts when querying by channel cid',
      () async {
        const cid = 'test:getDraftByCidNoThread';
        await _prepareTestData(cid, withParentMessage: true);

        final draft = await draftMessageDao.getDraftMessageByCid(cid);

        // The first draft has a parent message, so it's a thread draft
        // getDraftMessageByCid should skip thread drafts
        expect(draft, isNull);
      },
    );
  });

  group('getDraftMessageByParentId', () {
    test('should return null for a non-existent parent id', () async {
      final draft = await draftMessageDao.getDraftMessageByParentId(
        'non-existent-parent-id',
      );
      expect(draft, isNull);
    });

    test('should return the draft message for a valid parent id', () async {
      const cid = 'test:getDraftByParentId';
      final testDrafts =
          await _prepareTestData(cid, withParentMessage: true, count: 1);
      final parentId = testDrafts.first.parentId;

      final draft = await draftMessageDao.getDraftMessageByParentId(parentId!);

      expect(draft, isNotNull);
      expect(draft!.parentId, parentId);
      expect(draft.channelCid, cid);
    });
  });

  group('updateDraftMessages', () {
    test('should insert new draft messages', () async {
      const cid = 'test:updateDraftMessages';
      // Create just one draft to avoid conflicts
      final draft = Draft(
        channelCid: cid,
        createdAt: DateTime.now(),
        message: DraftMessage(
          id: 'newDraftId',
          text: 'New draft message',
        ),
      );

      await database.channelDao.updateChannels([ChannelModel(cid: cid)]);
      await draftMessageDao.updateDraftMessages([draft]);

      final fetchedDraft = await draftMessageDao.getDraftMessageById(
        draft.message.id,
      );
      expect(fetchedDraft, isNotNull);
      expect(fetchedDraft!.message.id, draft.message.id);
      expect(fetchedDraft.message.text, draft.message.text);
    });

    test('should update existing draft messages', () async {
      const cid = 'test:updateExistingDrafts';
      // Just create one draft
      final testDrafts = await _prepareTestData(cid, count: 1);

      final updatedDraft = Draft(
        channelCid: testDrafts.first.channelCid,
        createdAt: testDrafts.first.createdAt,
        message: testDrafts.first.message.copyWith(
          text: 'Updated Draft message',
        ),
      );

      await draftMessageDao.updateDraftMessages([updatedDraft]);

      final fetchedDraft = await draftMessageDao.getDraftMessageById(
        testDrafts.first.message.id,
      );
      expect(fetchedDraft, isNotNull);
      expect(fetchedDraft!.message.text, 'Updated Draft message');
    });

    test(
      'should keep only the last draft when adding multiple channel drafts with same channelCid',
      () async {
        const cid = 'test:multipleDraftsWithSameCid';
        await database.channelDao.updateChannels([ChannelModel(cid: cid)]);

        // Create first channel draft (no parent message)
        final firstDraft = Draft(
          channelCid: cid,
          createdAt: DateTime.now(),
          message: DraftMessage(
            id: 'firstDraftId',
            text: 'First channel draft',
          ),
        );

        await draftMessageDao.updateDraftMessages([firstDraft]);

        // Verify first draft exists
        final firstFetchedDraft =
            await draftMessageDao.getDraftMessageByCid(cid);
        expect(firstFetchedDraft, isNotNull);
        expect(firstFetchedDraft!.message.text, 'First channel draft');

        // Create second channel draft with same channelCid but different ID
        final secondDraft = Draft(
          channelCid: cid,
          createdAt: DateTime.now(),
          message: DraftMessage(
            id: 'secondDraftId', // Different ID
            text: 'Second channel draft',
          ),
        );

        // This should replace the existing draft due to unique constraint {channelCid, parentId}
        await draftMessageDao.updateDraftMessages([secondDraft]);

        // Verify only the second draft exists
        final secondFetchedDraft =
            await draftMessageDao.getDraftMessageByCid(cid);
        expect(secondFetchedDraft, isNotNull);
        expect(secondFetchedDraft!.message.id, 'secondDraftId');
        expect(secondFetchedDraft.message.text, 'Second channel draft');

        // Verify the first draft no longer exists
        final firstDraftAfterUpdate = await draftMessageDao.getDraftMessageById(
          firstDraft.message.id,
        );
        expect(firstDraftAfterUpdate, isNull);

        // Verify there's only one draft message for this channel
        final channelDraft = await draftMessageDao.getDraftMessageByCid(cid);
        expect(channelDraft, isNotNull);
        expect(channelDraft!.message.id, 'secondDraftId');
      },
    );

    test(
      'should keep only the last draft when adding multiple thread drafts with same parentId',
      () async {
        const cid = 'test:multipleDraftsWithSameParentId';

        // Create parent message first
        final user = User(id: 'testUserId');
        final parentMessage = Message(
          id: 'threadParent',
          user: user,
          createdAt: DateTime.now(),
          text: 'Parent message',
        );

        await database.userDao.updateUsers([user]);
        await database.channelDao.updateChannels([ChannelModel(cid: cid)]);
        await database.messageDao.updateMessages(cid, [parentMessage]);

        // Create first thread draft
        final firstDraft = Draft(
          channelCid: cid,
          createdAt: DateTime.now(),
          parentId: parentMessage.id,
          message: DraftMessage(
            id: 'firstThreadDraftId',
            text: 'First thread draft',
            parentId: parentMessage.id,
          ),
        );

        await draftMessageDao.updateDraftMessages([firstDraft]);

        // Verify first thread draft exists
        final firstFetchedDraft = await draftMessageDao.getDraftMessageById(
          firstDraft.message.id,
        );
        expect(firstFetchedDraft, isNotNull);
        expect(firstFetchedDraft!.message.text, 'First thread draft');

        // Create second thread draft for same thread but with different ID
        final secondDraft = Draft(
          channelCid: cid,
          createdAt: DateTime.now(),
          parentId: parentMessage.id,
          message: DraftMessage(
            id: 'secondThreadDraftId', // Different ID
            text: 'Second thread draft',
            parentId: parentMessage.id,
          ),
        );

        // This should replace the existing draft due to unique constraint {channelCid, parentId}
        await draftMessageDao.updateDraftMessages([secondDraft]);

        // Verify only the second draft exists
        final secondFetchedDraft = await draftMessageDao.getDraftMessageById(
          secondDraft.message.id,
        );
        expect(secondFetchedDraft, isNotNull);
        expect(secondFetchedDraft!.message.id, 'secondThreadDraftId');
        expect(secondFetchedDraft.message.text, 'Second thread draft');

        // Verify the first draft no longer exists
        final firstDraftAfterUpdate = await draftMessageDao.getDraftMessageById(
          firstDraft.message.id,
        );
        expect(firstDraftAfterUpdate, isNull);

        // Verify there's only one draft message for this thread
        final threadDraft = await draftMessageDao.getDraftMessageByParentId(
          parentMessage.id,
        );
        expect(threadDraft, isNotNull);
        expect(threadDraft!.message.id, 'secondThreadDraftId');
      },
    );
  });

  group('DraftMessages entity references', () {
    test(
      'should delete draft messages when referenced channel is deleted',
      () async {
        const cid = 'test:channelRefCascade';
        // Just create one draft
        final testDrafts = await _prepareTestData(cid, count: 1);

        // Verify draft exists
        final draftBeforeChannelDelete = await draftMessageDao
            .getDraftMessageById(testDrafts.first.message.id);
        expect(draftBeforeChannelDelete, isNotNull);

        // Delete the channel
        await database.channelDao.deleteChannelByCids([cid]);

        // Verify draft has been deleted (cascade)
        final draftAfterChannelDelete = await draftMessageDao
            .getDraftMessageById(testDrafts.first.message.id);
        expect(draftAfterChannelDelete, isNull);
      },
    );

    test(
      'should delete both channel drafts and thread drafts when the channel '
      'is deleted',
      () async {
        const cid = 'test:allDraftsDeletedWithChannel';

        // Create parent messages first
        final user = User(id: 'testUserId');
        final messages = List.generate(
          2,
          (index) => Message(
            id: 'parentMessage$index',
            user: user,
            createdAt: DateTime.now(),
            text: 'Parent Message $index',
          ),
        );

        await database.userDao.updateUsers([user]);
        await database.channelDao.updateChannels([ChannelModel(cid: cid)]);
        await database.messageDao.updateMessages(cid, messages);

        // Create a channel draft (no parent message)
        final channelDraft = Draft(
          channelCid: cid,
          createdAt: DateTime.now(),
          message: DraftMessage(
            id: 'channelDraftId',
            text: 'Channel draft message',
          ),
        );

        // Create thread drafts (with parent messages)
        final threadDrafts = List.generate(
          2,
          (index) => Draft(
            channelCid: cid,
            createdAt: DateTime.now(),
            parentId: messages[index].id,
            message: DraftMessage(
              id: 'threadDraftId$index',
              text: 'Thread draft message $index',
              parentId: messages[index].id,
            ),
          ),
        );

        // Insert all drafts
        await draftMessageDao.updateDraftMessages(
          [channelDraft, ...threadDrafts],
        );

        // Verify drafts exist before channel deletion
        final channelDraftBeforeDelete =
            await draftMessageDao.getDraftMessageById(channelDraft.message.id);
        expect(channelDraftBeforeDelete, isNotNull);
        expect(channelDraftBeforeDelete!.parentId, isNull);

        for (var i = 0; i < threadDrafts.length; i++) {
          final threadDraft = await draftMessageDao
              .getDraftMessageById(threadDrafts[i].message.id);
          expect(threadDraft, isNotNull);
          expect(threadDraft!.parentId, messages[i].id);
        }

        // Delete the channel
        await database.channelDao.deleteChannelByCids([cid]);

        // Verify all drafts have been deleted (cascade)
        final channelDraftAfterDelete =
            await draftMessageDao.getDraftMessageById(channelDraft.message.id);
        expect(channelDraftAfterDelete, isNull);

        for (final threadDraft in threadDrafts) {
          final draft =
              await draftMessageDao.getDraftMessageById(threadDraft.message.id);
          expect(draft, isNull);
        }
      },
    );

    test(
      'should delete draft messages when referenced parent message is deleted',
      () async {
        const cid = 'test:parentRefCascade';
        final testDrafts =
            await _prepareTestData(cid, withParentMessage: true, count: 1);
        final parentId = testDrafts.first.parentId!;

        // Verify draft with parent exists
        final draftBeforeMessageDelete =
            await draftMessageDao.getDraftMessageByParentId(parentId);
        expect(draftBeforeMessageDelete, isNotNull);

        // Delete the parent message
        await database.messageDao.deleteMessageByIds([parentId]);

        // Verify draft has been deleted (cascade)
        final draftAfterMessageDelete =
            await draftMessageDao.getDraftMessageByParentId(parentId);
        expect(draftAfterMessageDelete, isNull);
      },
    );
  });

  group('deleteDraftMessagesByIds', () {
    test(
      'should delete multiple draft messages by their IDs',
      () async {
        // Create drafts with unique channelCids to avoid conflicts
        const baseCid = 'test:deleteDraftsByIds';
        final drafts = List.generate(
          3,
          (index) => Draft(
            channelCid: '$baseCid$index',
            createdAt: DateTime.now(),
            message: DraftMessage(
              id: 'draftToDelete$index',
              text: 'Draft message $index',
            ),
          ),
        );

        // Create channels for each draft
        await database.channelDao.updateChannels([
          for (final draft in drafts) ChannelModel(cid: draft.channelCid),
        ]);

        // Insert all drafts
        await draftMessageDao.updateDraftMessages(drafts);

        // Get IDs to delete (first and third draft)
        final idsToDelete = [
          drafts.first.message.id,
          drafts.last.message.id,
        ];
        final idToKeep = drafts[1].message.id;

        // Verify all drafts exist before deletion
        for (final draft in drafts) {
          final fetchedDraft = await draftMessageDao.getDraftMessageById(
            draft.message.id,
          );
          expect(fetchedDraft, isNotNull);
        }

        // Delete two out of three drafts
        await draftMessageDao.deleteDraftMessagesByIds(idsToDelete);

        // Verify deleted drafts don't exist anymore
        for (final id in idsToDelete) {
          final fetchedDraft = await draftMessageDao.getDraftMessageById(id);
          expect(fetchedDraft, isNull);
        }

        // Verify the remaining draft still exists
        final remainingDraft =
            await draftMessageDao.getDraftMessageById(idToKeep);
        expect(remainingDraft, isNotNull);
        expect(remainingDraft!.message.id, idToKeep);
      },
    );

    test(
      'should not fail when trying to delete non-existent draft IDs',
      () async {
        // Should not throw any exception
        await expectLater(
          draftMessageDao.deleteDraftMessagesByIds(['non-existent-id']),
          completes,
        );
      },
    );

    test(
      'should handle empty list of IDs gracefully',
      () async {
        // Should not throw any exception
        await expectLater(
          draftMessageDao.deleteDraftMessagesByIds([]),
          completes,
        );
      },
    );
  });
}
