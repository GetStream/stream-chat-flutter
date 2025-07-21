import 'dart:convert';

import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

/// Useful mapping functions for [PinnedMessageEntity]
extension PinnedMessageEntityX on PinnedMessageEntity {
  /// Maps a [PinnedMessageEntity] into [Message]
  Message toMessage({
    User? user,
    User? pinnedBy,
    List<Reaction>? latestReactions,
    List<Reaction>? ownReactions,
    Message? quotedMessage,
    Poll? poll,
    Draft? draft,
    Location? sharedLocation,
  }) =>
      Message(
        shadowed: shadowed,
        latestReactions: latestReactions,
        ownReactions: ownReactions,
        attachments: attachments.map((it) {
          final json = jsonDecode(it);
          return Attachment.fromData(json);
        }).toList(),
        extraData: extraData ?? <String, Object>{},
        createdAt: remoteCreatedAt,
        localCreatedAt: localCreatedAt,
        updatedAt: remoteUpdatedAt,
        localUpdatedAt: localUpdatedAt,
        deletedAt: remoteDeletedAt,
        localDeletedAt: localDeletedAt,
        messageTextUpdatedAt: messageTextUpdatedAt,
        id: id,
        type: type,
        state: MessageState.fromJson(jsonDecode(state)),
        command: command,
        parentId: parentId,
        quotedMessageId: quotedMessageId,
        quotedMessage: quotedMessage,
        pollId: pollId,
        poll: poll,
        reactionGroups: reactionGroups,
        replyCount: replyCount,
        showInChannel: showInChannel,
        text: messageText,
        user: user,
        pinned: pinned,
        pinnedAt: pinnedAt,
        pinExpires: pinExpires,
        pinnedBy: pinnedBy,
        mentionedUsers:
            mentionedUsers.map((e) => User.fromJson(jsonDecode(e))).toList(),
        i18n: i18n,
        restrictedVisibility: restrictedVisibility,
        draft: draft,
        sharedLocation: sharedLocation,
      );
}

/// Useful mapping functions for [Message]
extension PMessageX on Message {
  /// Maps a [Message] into [PinnedMessageEntity]
  PinnedMessageEntity toPinnedEntity({required String cid}) =>
      PinnedMessageEntity(
        id: id,
        attachments: attachments.map((it) => jsonEncode(it.toData())).toList(),
        channelCid: cid,
        type: type,
        parentId: parentId,
        quotedMessageId: quotedMessageId,
        pollId: pollId,
        command: command,
        remoteCreatedAt: remoteCreatedAt,
        localCreatedAt: localCreatedAt,
        shadowed: shadowed,
        showInChannel: showInChannel,
        replyCount: replyCount,
        reactionGroups: reactionGroups,
        mentionedUsers: mentionedUsers.map(jsonEncode).toList(),
        state: jsonEncode(state),
        remoteUpdatedAt: remoteUpdatedAt,
        localUpdatedAt: localUpdatedAt,
        extraData: extraData,
        userId: user?.id,
        remoteDeletedAt: remoteDeletedAt,
        localDeletedAt: localDeletedAt,
        messageTextUpdatedAt: messageTextUpdatedAt,
        messageText: text,
        pinned: pinned,
        pinnedAt: pinnedAt,
        pinExpires: pinExpires,
        pinnedByUserId: pinnedBy?.id,
        i18n: i18n,
        restrictedVisibility: restrictedVisibility,
      );
}
