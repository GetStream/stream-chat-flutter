import 'dart:convert';

import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

/// Useful mapping functions for [MessageEntity]
extension MessageEntityX on MessageEntity {
  /// Maps a [MessageEntity] into [Message]
  Message toMessage({
    User? user,
    User? pinnedBy,
    List<Reaction>? latestReactions,
    List<Reaction>? ownReactions,
    Message? quotedMessage,
  }) =>
      Message(
        shadowed: shadowed,
        latestReactions: latestReactions,
        ownReactions: ownReactions,
        attachments: attachments.map((it) {
          final json = jsonDecode(it);
          return Attachment.fromData(json);
        }).toList(),
        createdAt: createdAt,
        extraData: extraData ?? <String, Object>{},
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
        pinned: pinned,
        pinnedAt: pinnedAt,
        pinExpires: pinExpires,
        pinnedBy: pinnedBy,
        mentionedUsers:
            mentionedUsers.map((e) => User.fromJson(jsonDecode(e))).toList(),
        i18n: i18n,
      );
}

/// Useful mapping functions for [Message]
extension MessageX on Message {
  /// Maps a [Message] into [MessageEntity]
  MessageEntity toEntity({required String cid}) => MessageEntity(
        id: id,
        attachments: attachments.map((it) => jsonEncode(it.toData())).toList(),
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
        mentionedUsers: mentionedUsers.map(jsonEncode).toList(),
        status: status,
        updatedAt: updatedAt,
        extraData: extraData,
        userId: user?.id,
        deletedAt: deletedAt,
        messageText: text,
        pinned: pinned,
        pinnedAt: pinnedAt,
        pinExpires: pinExpires,
        pinnedByUserId: pinnedBy?.id,
        i18n: i18n,
      );
}
