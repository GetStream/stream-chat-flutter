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
      final draft = await draftMessageDao.getDraftMessageByCid(
        'non-existent-cid',
        parentId: 'non-existent-parent-id',
      );
      expect(draft, isNull);
    });

    test('should return the draft message for a valid parent id', () async {
      const cid = 'test:getDraftByParentId';
      final testDrafts = await _prepareTestData(
        cid,
        withParentMessage: true,
        count: 1,
      );
      final parentId = testDrafts.first.parentId;

      final draft = await draftMessageDao.getDraftMessageByCid(
        cid,
        parentId: parentId,
      );

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

      final fetchedDraft = await draftMessageDao.getDraftMessageByCid(cid);
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

      final fetchedDraft = await draftMessageDao.getDraftMessageByCid(cid);
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
            text: 'First channel draft',
          ),
        );

        await draftMessageDao.updateDraftMessages([firstDraft]);

        // Verify first draft exists
        final firstFetchedDraft =
            await draftMessageDao.getDraftMessageByCid(cid);
        expect(firstFetchedDraft, isNotNull);
        expect(firstFetchedDraft!.message.text, 'First channel draft');

        // Create second channel draft with same channelCid but different text
        final secondDraft = Draft(
          channelCid: cid,
          createdAt: DateTime.now(),
          message: DraftMessage(
            text: 'Second channel draft',
          ),
        );

        // This should replace the existing draft due to unique constraint {channelCid, parentId}
        await draftMessageDao.updateDraftMessages([secondDraft]);

        // Verify only the second draft exists
        final secondFetchedDraft =
            await draftMessageDao.getDraftMessageByCid(cid);
        expect(secondFetchedDraft, isNotNull);
        expect(secondFetchedDraft!.message.text, 'Second channel draft');

        // Verify the first draft no longer exists
        final firstDraftAfterUpdate =
            await draftMessageDao.getDraftMessageByCid(firstDraft.channelCid);
        expect(
            firstDraftAfterUpdate!.message.text, isNot('First channel draft'));

        // Verify there's only one draft message for this channel
        final channelDraft = await draftMessageDao.getDraftMessageByCid(cid);
        expect(channelDraft, isNotNull);
        expect(channelDraft!.message.text, 'Second channel draft');
      },
    );

    test(
      'should keep only the last draft when adding multiple thread drafts with same parentId',
      () async {
        const cid = 'test:multipleDraftsWithSameParentId';

        // Create parent message first
        final user = User(id: 'testUserId');
        final parentMessage = Message(
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
            text: 'First thread draft',
            parentId: parentMessage.id,
          ),
        );

        await draftMessageDao.updateDraftMessages([firstDraft]);

        // Verify first thread draft exists
        final firstFetchedDraft = await draftMessageDao
            .getDraftMessageByCid(cid, parentId: firstDraft.parentId);
        expect(firstFetchedDraft, isNotNull);
        expect(firstFetchedDraft!.message.text, 'First thread draft');

        // Create second thread draft for same thread but with different ID
        final secondDraft = Draft(
          channelCid: cid,
          createdAt: DateTime.now(),
          parentId: parentMessage.id,
          message: DraftMessage(
            text: 'Second thread draft',
            parentId: parentMessage.id,
          ),
        );

        // This should replace the existing draft due to unique constraint {channelCid, parentId}
        await draftMessageDao.updateDraftMessages([secondDraft]);

        // Verify only the second draft exists
        final secondFetchedDraft = await draftMessageDao
            .getDraftMessageByCid(cid, parentId: secondDraft.parentId);
        expect(secondFetchedDraft, isNotNull);
        expect(secondFetchedDraft!.message.text, 'Second thread draft');

        // Verify the first draft no longer exists
        final firstDraftAfterUpdate = await draftMessageDao
            .getDraftMessageByCid(cid, parentId: firstDraft.parentId);
        expect(
            firstDraftAfterUpdate!.message.text, isNot('First thread draft'));

        // Verify there's only one draft message for this thread
        final threadDraft = await draftMessageDao.getDraftMessageByCid(cid,
            parentId: parentMessage.id);
        expect(threadDraft, isNotNull);
        expect(threadDraft!.message.text, 'Second thread draft');
      },
    );
  });

  group('deleteDraftMessagesByCids', () {
    test('should delete drafts for specified channel cids', () async {
      const cid1 = 'test:deleteByCids1';
      const cid2 = 'test:deleteByCids2';
      const cid3 = 'test:deleteByCids3';

      // Create drafts for multiple channels
      await _prepareTestData(cid1, count: 1);
      await _prepareTestData(cid2, count: 1);
      await _prepareTestData(cid3, count: 1);

      // Verify all drafts exist
      final draft1Before = await draftMessageDao.getDraftMessageByCid(cid1);
      final draft2Before = await draftMessageDao.getDraftMessageByCid(cid2);
      final draft3Before = await draftMessageDao.getDraftMessageByCid(cid3);
      expect(draft1Before, isNotNull);
      expect(draft2Before, isNotNull);
      expect(draft3Before, isNotNull);

      // Delete drafts for cid1 and cid2
      await draftMessageDao.deleteDraftMessagesByCids([cid1, cid2]);

      // Verify drafts for cid1 and cid2 are deleted
      final draft1After = await draftMessageDao.getDraftMessageByCid(cid1);
      final draft2After = await draftMessageDao.getDraftMessageByCid(cid2);
      expect(draft1After, isNull);
      expect(draft2After, isNull);

      // Verify draft for cid3 still exists
      final draft3After = await draftMessageDao.getDraftMessageByCid(cid3);
      expect(draft3After, isNotNull);
      expect(draft3After!.channelCid, cid3);
    });
  });

  group('DraftMessages entity references', () {
    test(
      'should delete draft messages when referenced channel is deleted',
      () async {
        const cid = 'test:channelRefCascade';
        // Just create one draft
        await _prepareTestData(cid, count: 1);

        // Verify draft exists
        final draftBeforeChannelDelete =
            await draftMessageDao.getDraftMessageByCid(cid);
        expect(draftBeforeChannelDelete, isNotNull);

        // Delete the channel
        await database.channelDao.deleteChannelByCids([cid]);

        // Verify draft has been deleted (cascade)
        final draftAfterChannelDelete =
            await draftMessageDao.getDraftMessageByCid(cid);
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
            await draftMessageDao.getDraftMessageByCid(cid);
        expect(channelDraftBeforeDelete, isNotNull);
        expect(channelDraftBeforeDelete!.parentId, isNull);

        for (var i = 0; i < threadDrafts.length; i++) {
          final threadDraft = await draftMessageDao.getDraftMessageByCid(cid,
              parentId: threadDrafts[i].parentId);
          expect(threadDraft, isNotNull);
          expect(threadDraft!.parentId, messages[i].id);
        }

        // Delete the channel
        await database.channelDao.deleteChannelByCids([cid]);

        // Verify all drafts have been deleted (cascade)
        final channelDraftAfterDelete =
            await draftMessageDao.getDraftMessageByCid(cid);
        expect(channelDraftAfterDelete, isNull);

        for (final threadDraft in threadDrafts) {
          final draft = await draftMessageDao.getDraftMessageByCid(cid,
              parentId: threadDraft.parentId);
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
            await draftMessageDao.getDraftMessageByCid(cid, parentId: parentId);
        expect(draftBeforeMessageDelete, isNotNull);

        // Delete the parent message
        await database.messageDao.deleteMessageByIds([parentId]);

        // Verify draft has been deleted (cascade)
        final draftAfterMessageDelete =
            await draftMessageDao.getDraftMessageByCid(cid, parentId: parentId);
        expect(draftAfterMessageDelete, isNull);
      },
    );
  });
}
