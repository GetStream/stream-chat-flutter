import 'dart:convert';

import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

/// Useful mapping functions for [MessageEntity]
extension MessageEntityX on MessageEntity {
  /// Maps a [MessageEntity] into [Message]
  Message toMessage({
    User user,
    List<Reaction> latestReactions,
    List<Reaction> ownReactions,
    Message quotedMessage,
  }) {
    return Message(
      shadowed: shadowed,
      latestReactions: latestReactions,
      ownReactions: ownReactions,
      attachments: attachments?.map((it) {
        final json = jsonDecode(it);
        return Attachment.fromJson(json);
      })?.toList(),
      createdAt: createdAt,
      extraData: extraData,
      updatedAt: updatedAt,
      id: id,
      type: type,
      status: status,
      command: command,
      parentId: parentId,
      quotedMessageId: quotedMessageId,
      quotedMessage: quotedMessage,
      reactionCounts: reactionCounts,
      reactionScores: reactionScores,
      replyCount: replyCount,
      showInChannel: showInChannel,
      text: messageText,
      user: user,
      deletedAt: deletedAt,
    );
  }
}

/// Useful mapping functions for [Message]
extension MessageX on Message {
  /// Maps a [Message] into [MessageEntity]
  MessageEntity toEntity({String cid}) {
    return MessageEntity(
      id: id,
      attachments: attachments.map((it) => jsonEncode(it)).toList(),
      channelCid: cid,
      type: type,
      parentId: parentId,
      quotedMessageId: quotedMessageId,
      command: command,
      createdAt: createdAt,
      shadowed: shadowed,
      showInChannel: showInChannel,
      replyCount: replyCount,
      reactionScores: reactionScores,
      reactionCounts: reactionCounts,
      status: status,
      updatedAt: updatedAt,
      extraData: extraData,
      userId: user?.id,
      deletedAt: deletedAt,
      messageText: text,
    );
  }
}
