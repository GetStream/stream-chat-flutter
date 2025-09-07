import 'dart:convert';

import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

/// Useful mapping functions for [DraftMessageEntity]
extension DraftMessageEntityX on DraftMessageEntity {
  /// Maps a [MessageEntity] into [Message]
  Draft toDraft({
    Message? parentMessage,
    Message? quotedMessage,
    Poll? poll,
  }) {
    return Draft(
      createdAt: createdAt,
      channelCid: channelCid,
      message: DraftMessage(
        id: id,
        text: messageText,
        type: type,
        attachments: attachments.map((it) {
          final json = jsonDecode(it);
          return Attachment.fromData(json);
        }).toList(),
        parentId: parentId,
        showInChannel: showInChannel,
        mentionedUsers: mentionedUsers.map((e) {
          final json = jsonDecode(e);
          return User.fromJson(json);
        }).toList(),
        quotedMessage: quotedMessage,
        quotedMessageId: quotedMessageId,
        silent: silent,
        command: command,
        poll: poll,
        pollId: pollId,
        extraData: extraData ?? <String, Object>{},
      ),
      parentId: parentId,
      parentMessage: parentMessage,
      quotedMessage: quotedMessage,
    );
  }
}

/// Useful mapping functions for [Draft]
extension DraftMessageX on Draft {
  /// Maps a [DraftMessage] into [DraftMessageEntity]
  DraftMessageEntity toEntity() => DraftMessageEntity(
        id: message.id,
        channelCid: channelCid,
        messageText: message.text,
        type: message.type,
        createdAt: createdAt,
        attachments: message.attachments.map((it) {
          return jsonEncode(it.toData());
        }).toList(),
        parentId: parentId,
        showInChannel: message.showInChannel,
        mentionedUsers: message.mentionedUsers.map((e) {
          return jsonEncode(e.toJson());
        }).toList(),
        quotedMessageId: message.quotedMessageId,
        silent: message.silent,
        command: message.command,
        pollId: message.pollId,
        extraData: message.extraData,
      );
}
