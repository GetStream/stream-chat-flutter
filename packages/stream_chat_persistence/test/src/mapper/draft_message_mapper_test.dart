import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/mapper/draft_message_mapper.dart';

import '../utils/date_matcher.dart';

void main() {
  group('DraftMessageMapper', () {
    test('toDraft should map the entity into Draft', () {
      final user = User(id: 'testUserId');
      final parentMessage = Message(id: 'testParentId');
      final quotedMessage = Message(id: 'testQuotedMessageId');
      final poll = Poll(
        id: 'testPollId',
        name: 'testQuestion',
        options: const [
          PollOption(
            id: 'testOptionId',
            text: 'testOptionText',
          ),
        ],
      );
      final attachments = List.generate(
        3,
        (index) => Attachment(
          id: 'testAttachmentId$index',
          type: 'testAttachmentType',
          assetUrl: 'testAssetUrl',
        ),
      );

      final createdAt = DateTime.now();
      final entity = DraftMessageEntity(
        id: 'testDraftId',
        channelCid: 'testCid',
        messageText: 'Test draft message',
        type: 'regular',
        attachments: attachments.map((it) => jsonEncode(it.toData())).toList(),
        parentId: parentMessage.id,
        showInChannel: true,
        mentionedUsers: [jsonEncode(user.toJson())],
        quotedMessageId: quotedMessage.id,
        silent: false,
        command: 'testCommand',
        pollId: poll.id,
        createdAt: createdAt,
        extraData: {'extra_test_field': 'extraTestData'},
      );

      final draft = entity.toDraft(
        parentMessage: parentMessage,
        quotedMessage: quotedMessage,
        poll: poll,
      );

      expect(draft, isA<Draft>());
      expect(draft.channelCid, entity.channelCid);
      expect(draft.message.id, entity.id);
      expect(draft.message.text, entity.messageText);
      expect(draft.message.type, entity.type);
      expect(draft.message.showInChannel, entity.showInChannel);
      expect(draft.message.silent, entity.silent);
      expect(draft.message.command, entity.command);
      expect(draft.message.extraData, entity.extraData);
      expect(draft.message.parentId, entity.parentId);
      expect(draft.message.quotedMessageId, entity.quotedMessageId);
      expect(draft.message.pollId, entity.pollId);
      expect(draft.createdAt, isSameDateAs(entity.createdAt));
      expect(draft.parentId, entity.parentId);
      expect(draft.parentMessage?.id, parentMessage.id);
      expect(draft.quotedMessage?.id, quotedMessage.id);
      expect(draft.message.poll?.id, poll.id);
      expect(draft.message.mentionedUsers.length, 1);
      expect(draft.message.mentionedUsers.first.id, user.id);
      expect(draft.message.attachments.length, entity.attachments.length);

      for (var i = 0; i < draft.message.attachments.length; i++) {
        final draftAttachment = draft.message.attachments[i];
        final entityAttachmentData = jsonDecode(entity.attachments[i]);
        final entityAttachment = Attachment.fromData(entityAttachmentData);
        expect(draftAttachment.id, entityAttachment.id);
        expect(draftAttachment.type, entityAttachment.type);
        expect(draftAttachment.assetUrl, entityAttachment.assetUrl);
      }
    });

    test('toEntity should map Draft into DraftMessageEntity', () {
      const cid = 'testCid';
      final user = User(id: 'testUserId');
      final parentMessage = Message(id: 'testParentId');
      final quotedMessage = Message(id: 'testQuotedMessageId');
      final poll = Poll(
        id: 'testPollId',
        name: 'testQuestion',
        options: const [
          PollOption(
            id: 'testOptionId',
            text: 'testOptionText',
          ),
        ],
      );
      final attachments = List.generate(
        3,
        (index) => Attachment(
          id: 'testAttachmentId$index',
          type: 'testAttachmentType',
          assetUrl: 'testAssetUrl',
        ),
      );

      final createdAt = DateTime.now();
      final draftMessage = DraftMessage(
        id: 'testDraftId',
        text: 'Test draft message',
        attachments: attachments,
        parentId: parentMessage.id,
        showInChannel: true,
        mentionedUsers: [user],
        quotedMessage: quotedMessage,
        quotedMessageId: quotedMessage.id,
        command: 'testCommand',
        poll: poll,
        pollId: poll.id,
        extraData: const {'extra_test_field': 'extraTestData'},
      );

      final draft = Draft(
        channelCid: cid,
        createdAt: createdAt,
        message: draftMessage,
        parentId: parentMessage.id,
        parentMessage: parentMessage,
        quotedMessage: quotedMessage,
      );

      final entity = draft.toEntity();

      expect(entity, isA<DraftMessageEntity>());
      expect(entity.id, draft.message.id);
      expect(entity.channelCid, cid);
      expect(entity.messageText, draft.message.text);
      expect(entity.type, draft.message.type);
      expect(entity.showInChannel, draft.message.showInChannel);
      expect(entity.silent, draft.message.silent);
      expect(entity.command, draft.message.command);
      expect(entity.extraData, draft.message.extraData);
      expect(entity.parentId, draft.message.parentId);
      expect(entity.quotedMessageId, draft.message.quotedMessageId);
      expect(entity.pollId, draft.message.pollId);
      expect(entity.createdAt, isSameDateAs(draft.createdAt));
      expect(entity.mentionedUsers.length, 1);

      final mentionedUser = User.fromJson(
        jsonDecode(entity.mentionedUsers.first),
      );
      expect(mentionedUser.id, user.id);

      expect(entity.attachments.length, draft.message.attachments.length);
      for (var i = 0; i < entity.attachments.length; i++) {
        final entityAttachmentData = jsonDecode(entity.attachments[i]);
        final entityAttachment = Attachment.fromData(entityAttachmentData);
        final draftAttachment = draft.message.attachments[i];
        expect(entityAttachment.id, draftAttachment.id);
        expect(entityAttachment.type, draftAttachment.type);
        expect(entityAttachment.assetUrl, draftAttachment.assetUrl);
      }
    });
  });
}
