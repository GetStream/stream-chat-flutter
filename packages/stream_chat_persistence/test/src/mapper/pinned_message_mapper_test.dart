import 'dart:math' as math;

import 'package:test/test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:stream_chat_persistence/src/mapper/pinned_message_mapper.dart';

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
    final entity = PinnedMessageEntity(
      id: 'testMessageId',
      attachments: [],
      channelCid: 'testCid',
      type: 'testType',
      parentId: 'testParentId',
      quotedMessageId: quotedMessage.id,
      command: 'testCommand',
      createdAt: DateTime.now(),
      shadowed: math.Random().nextBool(),
      showInChannel: math.Random().nextBool(),
      replyCount: 33,
      reactionScores: {for (final r in reactions) r.type: r.score},
      reactionCounts: reactions.fold(
        {},
        (prev, curr) =>
            prev..update(curr.type, (value) => value + 1, ifAbsent: () => 1),
      ),
      status: MessageSendingStatus.sent,
      updatedAt: DateTime.now(),
      extraData: {'extra_test_data': 'extraData'},
      userId: user.id,
      deletedAt: DateTime.now(),
      messageText: 'dummy text',
      pinned: true,
      pinExpires: DateTime.now().toUtc(),
      pinnedAt: DateTime.now(),
      pinnedByUserId: user.id,
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
    expect(message.attachments, entity.attachments);
    expect(message.type, entity.type);
    expect(message.parentId, entity.parentId);
    expect(message.quotedMessageId, entity.quotedMessageId);
    expect(message.command, entity.command);
    expect(message.createdAt, isSameDateAs(entity.createdAt));
    expect(message.shadowed, entity.shadowed);
    expect(message.showInChannel, entity.showInChannel);
    expect(message.replyCount, entity.replyCount);
    expect(message.reactionScores, entity.reactionScores);
    expect(message.reactionCounts, entity.reactionCounts);
    expect(message.status, entity.status);
    expect(message.updatedAt, isSameDateAs(entity.updatedAt));
    expect(message.extraData, entity.extraData);
    expect(message.user.id, entity.userId);
    expect(message.deletedAt, isSameDateAs(entity.deletedAt));
    expect(message.text, entity.messageText);
    expect(message.pinned, entity.pinned);
    expect(message.pinExpires, isSameDateAs(entity.pinExpires));
    expect(message.pinnedAt, isSameDateAs(entity.pinnedAt));
    expect(message.pinnedBy.id, entity.pinnedByUserId);
    expect(message.reactionCounts, entity.reactionCounts);
    expect(message.reactionScores, entity.reactionScores);
  });

  test('toPinnedEntity should map message into PinnedMessageEntity', () {
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
    final message = Message(
      id: 'testMessageId',
      attachments: [],
      type: 'testType',
      parentId: 'testParentId',
      quotedMessageId: quotedMessage.id,
      command: 'testCommand',
      createdAt: DateTime.now(),
      shadowed: math.Random().nextBool(),
      showInChannel: math.Random().nextBool(),
      replyCount: 33,
      reactionScores: {for (final r in reactions) r.type: r.score},
      reactionCounts: reactions.fold(
        {},
        (prev, curr) =>
            prev..update(curr.type, (value) => value + 1, ifAbsent: () => 1),
      ),
      status: MessageSendingStatus.sending,
      updatedAt: DateTime.now(),
      extraData: {'extra_test_data': 'extraData'},
      user: user,
      deletedAt: DateTime.now(),
      text: 'dummy text',
      pinned: true,
      pinExpires: DateTime.now(),
      pinnedAt: DateTime.now(),
      pinnedBy: user,
    );
    final entity = message.toPinnedEntity(cid: cid);
    expect(entity, isA<PinnedMessageEntity>());
    expect(entity.id, message.id);
    expect(entity.attachments, message.attachments);
    expect(entity.type, message.type);
    expect(entity.parentId, message.parentId);
    expect(entity.quotedMessageId, message.quotedMessageId);
    expect(entity.command, message.command);
    expect(entity.createdAt, isSameDateAs(message.createdAt));
    expect(entity.shadowed, message.shadowed);
    expect(entity.showInChannel, message.showInChannel);
    expect(entity.replyCount, message.replyCount);
    expect(entity.reactionScores, message.reactionScores);
    expect(entity.reactionCounts, message.reactionCounts);
    expect(entity.status, message.status);
    expect(entity.updatedAt, isSameDateAs(message.updatedAt));
    expect(entity.extraData, message.extraData);
    expect(entity.userId, message.user.id);
    expect(entity.deletedAt, isSameDateAs(message.deletedAt));
    expect(entity.messageText, message.text);
    expect(entity.pinned, message.pinned);
    expect(entity.pinExpires, isSameDateAs(message.pinExpires));
    expect(entity.pinnedAt, isSameDateAs(message.pinnedAt));
    expect(entity.pinnedByUserId, message.pinnedBy.id);
    expect(entity.reactionCounts, message.reactionCounts);
    expect(entity.reactionScores, message.reactionScores);
  });
}
