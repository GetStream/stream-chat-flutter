import '../../../open_api/api.dart' as api;
import '../../core/models/draft.dart';
import '../../core/models/draft_message.dart';
import '../../core/models/message.dart';
import 'attachment_mapper.dart';
import 'channel_mapper.dart';
import 'message_mapper.dart';
import 'user_mapper.dart';

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
  // Custom keys named like one of the draft message's own fields, including the ones it keeps in its extra data.
  static const _shadowedCustomKeys = {
    ...DraftMessage.topLevelFields,
    'html',
    'mml',
  };

  /// Converts this response into a [DraftMessage].
  ///
  /// The rendered HTML and the message markup are kept in [DraftMessage.extraData], beside the custom data, with
  /// custom data named like one of the draft message's own fields left out.
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
    extraData: {
      ...{...custom}..removeWhere((key, _) => _shadowedCustomKeys.contains(key)),
      'html': ?html,
      'mml': ?mml,
    },
  );
}
