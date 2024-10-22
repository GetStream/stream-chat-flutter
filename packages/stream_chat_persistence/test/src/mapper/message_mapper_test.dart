import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/mapper/message_mapper.dart';

import '../utils/date_matcher.dart';

void main() {
  test('toMessage should map the entity into Message', () {
    final user = User(id: 'testUserId');
    final quotedMessage = Message(id: 'testQuotedMessageId');
    final reactions = List.generate(
      3,
      (index) => Reaction(
        messageId: 'testMessageId',
        createdAt: DateTime.now(),
        type: 'testType$index',
        user: user,
        score: math.Random().nextInt(50),
      ),
    );
    final attachments = List.generate(
      3,
      (index) => Attachment(
        id: 'testAttachmentId',
        type: 'testAttachmentType',
        assetUrl: 'testAssetUrl',
      ),
    );
    final entity = MessageEntity(
      id: 'testMessageId',
      attachments: attachments.map((it) => jsonEncode(it.toData())).toList(),
      channelCid: 'testCid',
      type: 'testType',
      parentId: 'testParentId',
      quotedMessageId: quotedMessage.id,
      command: 'testCommand',
      localCreatedAt: DateTime.now(),
      remoteCreatedAt: DateTime.now().add(const Duration(seconds: 1)),
      shadowed: math.Random().nextBool(),
      showInChannel: math.Random().nextBool(),
      replyCount: 33,
      reactionScores: {for (final r in reactions) r.type: r.score},
      reactionCounts: reactions.fold(
        {},
        (prev, curr) =>
            prev?..update(curr.type, (value) => value + 1, ifAbsent: () => 1),
      ),
      mentionedUsers: [
        jsonEncode(User(id: 'testuser')),
      ],
      state: jsonEncode(MessageState.sent),
      localUpdatedAt: DateTime.now(),
      remoteUpdatedAt: DateTime.now().add(const Duration(seconds: 1)),
      messageTextUpdatedAt: DateTime.now().add(const Duration(minutes: 5)),
      extraData: {'extra_test_data': 'extraData'},
      userId: user.id,
      localDeletedAt: DateTime.now(),
      remoteDeletedAt: DateTime.now().add(const Duration(seconds: 1)),
      messageText: 'Hello',
      pinned: true,
      pinExpires: DateTime.now().toUtc(),
      pinnedAt: DateTime.now(),
      pinnedByUserId: user.id,
      i18n: const {
        'en_text': 'Hello',
        'hi_text': 'नमस्ते',
        'language': 'en',
      },
    );
    final message = entity.toMessage(
      user: user,
      pinnedBy: user,
      latestReactions: reactions,
      ownReactions: reactions,
      quotedMessage: quotedMessage,
    );

    expect(message, isA<Message>());
    expect(message.id, entity.id);
    expect(message.type, entity.type);
    expect(message.parentId, entity.parentId);
    expect(message.quotedMessageId, entity.quotedMessageId);
    expect(message.command, entity.command);
    expect(message.localCreatedAt, isSameDateAs(entity.localCreatedAt));
    expect(message.remoteCreatedAt, isSameDateAs(entity.remoteCreatedAt));
    expect(message.shadowed, entity.shadowed);
    expect(message.showInChannel, entity.showInChannel);
    for (var i = 0; i < message.mentionedUsers.length; i++) {
      final entityMentionedUser =
          User.fromJson(jsonDecode(entity.mentionedUsers[i]));
      expect(message.mentionedUsers[i].id, entityMentionedUser.id);
    }
    expect(message.replyCount, entity.replyCount);
    expect(message.reactionScores, entity.reactionScores);
    expect(message.reactionCounts, entity.reactionCounts);
    expect(message.state, MessageState.fromJson(jsonDecode(entity.state)));
    expect(message.localUpdatedAt, isSameDateAs(entity.localUpdatedAt));
    expect(message.remoteUpdatedAt, isSameDateAs(entity.remoteUpdatedAt));
    expect(
      message.messageTextUpdatedAt,
      isSameDateAs(entity.messageTextUpdatedAt),
    );
    expect(message.extraData, entity.extraData);
    expect(message.user!.id, entity.userId);
    expect(message.localDeletedAt, isSameDateAs(entity.localDeletedAt));
    expect(message.remoteDeletedAt, isSameDateAs(entity.remoteDeletedAt));
    expect(message.text, entity.messageText);
    expect(message.pinned, entity.pinned);
    expect(message.pinExpires, isSameDateAs(entity.pinExpires));
    expect(message.pinnedAt, isSameDateAs(entity.pinnedAt));
    expect(message.pinnedBy!.id, entity.pinnedByUserId);
    expect(message.reactionCounts, entity.reactionCounts);
    expect(message.reactionScores, entity.reactionScores);
    expect(message.i18n, entity.i18n);
    for (var i = 0; i < message.attachments.length; i++) {
      final messageAttachment = message.attachments[i];
      final entityAttachmentData = jsonDecode(entity.attachments[i]);
      final entityAttachment = Attachment.fromData(entityAttachmentData);
      expect(messageAttachment.id, entityAttachment.id);
      expect(messageAttachment.type, entityAttachment.type);
      expect(messageAttachment.assetUrl, entityAttachment.assetUrl);
    }
  });

  test('toEntity should map message into MessageEntity', () {
    const cid = 'testCid';
    final user = User(id: 'testUserId');
    final quotedMessage = Message(id: 'testQuotedMessageId');
    final reactions = List.generate(
      3,
      (index) => Reaction(
        messageId: 'testMessageId',
        createdAt: DateTime.now(),
        type: 'testType$index',
        user: user,
        score: math.Random().nextInt(50),
      ),
    );
    final attachments = List.generate(
      3,
      (index) => Attachment(
        id: 'testAttachmentId',
        type: 'testAttachmentType',
        assetUrl: 'testAssetUrl',
      ),
    );
    final message = Message(
      id: 'testMessageId',
      attachments: attachments,
      type: 'testType',
      parentId: 'testParentId',
      quotedMessageId: quotedMessage.id,
      command: 'testCommand',
      localCreatedAt: DateTime.now(),
      createdAt: DateTime.now().add(const Duration(seconds: 1)),
      shadowed: math.Random().nextBool(),
      showInChannel: math.Random().nextBool(),
      replyCount: 33,
      mentionedUsers: [
        User(id: 'testuser'),
      ],
      reactionScores: {for (final r in reactions) r.type: r.score},
      reactionCounts: reactions.fold(
        {},
        (prev, curr) =>
            prev?..update(curr.type, (value) => value + 1, ifAbsent: () => 1),
      ),
      localUpdatedAt: DateTime.now(),
      updatedAt: DateTime.now().add(const Duration(seconds: 1)),
      messageTextUpdatedAt: DateTime.now().add(const Duration(minutes: 5)),
      extraData: const {'extra_test_data': 'extraData'},
      user: user,
      localDeletedAt: DateTime.now(),
      deletedAt: DateTime.now().add(const Duration(seconds: 1)),
      text: 'Hello',
      pinned: true,
      pinExpires: DateTime.now(),
      pinnedAt: DateTime.now(),
      pinnedBy: user,
      i18n: const {
        'en_text': 'Hello',
        'hi_text': 'नमस्ते',
        'language': 'en',
      },
    );
    final entity = message.toEntity(cid: cid);
    expect(entity, isA<MessageEntity>());
    expect(entity.id, message.id);
    expect(entity.type, message.type);
    expect(entity.parentId, message.parentId);
    expect(entity.quotedMessageId, message.quotedMessageId);
    expect(entity.command, message.command);
    expect(entity.localCreatedAt, isSameDateAs(message.localCreatedAt));
    expect(entity.remoteCreatedAt, isSameDateAs(message.remoteCreatedAt));
    expect(entity.shadowed, message.shadowed);
    expect(entity.showInChannel, message.showInChannel);
    expect(entity.replyCount, message.replyCount);
    expect(
        entity.mentionedUsers, message.mentionedUsers.map(jsonEncode).toList());
    expect(entity.reactionScores, message.reactionScores);
    expect(entity.reactionCounts, message.reactionCounts);
    expect(entity.state, jsonEncode(message.state));
    expect(entity.localUpdatedAt, isSameDateAs(message.localUpdatedAt));
    expect(entity.remoteUpdatedAt, isSameDateAs(message.remoteUpdatedAt));
    expect(
      entity.messageTextUpdatedAt,
      isSameDateAs(message.messageTextUpdatedAt),
    );
    expect(entity.extraData, message.extraData);
    expect(entity.userId, message.user!.id);
    expect(entity.localDeletedAt, isSameDateAs(message.localDeletedAt));
    expect(entity.remoteDeletedAt, isSameDateAs(message.remoteDeletedAt));
    expect(entity.messageText, message.text);
    expect(entity.pinned, message.pinned);
    expect(entity.pinExpires, isSameDateAs(message.pinExpires));
    expect(entity.pinnedAt, isSameDateAs(message.pinnedAt));
    expect(entity.pinnedByUserId, message.pinnedBy!.id);
    expect(entity.reactionCounts, message.reactionCounts);
    expect(entity.reactionScores, message.reactionScores);
    expect(
      entity.attachments,
      message.attachments.map((it) => jsonEncode(it.toData())).toList(),
    );
    expect(entity.i18n, message.i18n);
  });
}
