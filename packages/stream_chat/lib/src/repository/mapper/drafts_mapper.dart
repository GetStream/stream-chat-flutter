import '../../../open_api/api.dart' as api;
import '../../core/models/draft.dart';
import '../../core/models/draft_message.dart';
import '../../core/models/message.dart';
import 'attachments_mapper.dart';
import 'channels_mapper.dart';
import 'messages_mapper.dart';
import 'users_mapper.dart';

// TODO(openapi-migration): re-point these mappers in group 10.

/// Maps a generated [api.DraftResponse] to a [Draft].
extension DraftResponseMapper on api.DraftResponse {
  /// Converts this response into a [Draft].
  Draft toModel() => Draft(
    channelCid: channelCid,
    createdAt: createdAt,
    message: message.toModel(),
    channel: channel?.toModel(),
    parentId: parentId,
    parentMessage: parentMessage?.toModel(),
    quotedMessage: quotedMessage?.toModel(),
  );
}

/// Maps a generated [api.DraftPayloadResponse] to a [DraftMessage].
extension DraftPayloadResponseMapper on api.DraftPayloadResponse {
  /// Converts this response into a [DraftMessage].
  DraftMessage toModel() => DraftMessage(
    id: id,
    text: text,
    type: type ?? MessageType.regular,
    attachments: attachments?.map((attachment) => attachment.toModel()).toList() ?? const [],
    parentId: parentId,
    showInChannel: showInChannel,
    mentionedUsers: mentionedUsers?.map((user) => user.toModel()).toList() ?? const [],
    quotedMessageId: quotedMessageId,
    silent: silent ?? false,
    pollId: pollId,
    custom: custom,
  );
}
