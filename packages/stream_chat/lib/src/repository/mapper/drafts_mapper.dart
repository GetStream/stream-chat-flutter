import '../../../open_api/api.dart' as api;
import '../../core/models/draft.dart';
import '../../core/models/draft_message.dart';
import '../../core/models/message.dart';
import '../../core/models/response/create_draft_response.dart';
import '../../core/models/response/get_draft_response.dart';
import '../../core/models/response/query_drafts_response.dart';
import 'attachment_mapper.dart';
import 'channel_mapper.dart';
import 'message_mapper.dart';
import 'user_mapper.dart';

/// Maps a generated [api.CreateDraftResponse] to a [CreateDraftResponse].
extension CreateDraftResponseMapper on api.CreateDraftResponse {
  /// Converts this response into a [CreateDraftResponse].
  CreateDraftResponse toModel() => CreateDraftResponse(duration: duration, draft: draft.toModel());
}

/// Maps a generated [api.GetDraftResponse] to a [GetDraftResponse].
extension GetDraftResponseMapper on api.GetDraftResponse {
  /// Converts this response into a [GetDraftResponse].
  GetDraftResponse toModel() => GetDraftResponse(duration: duration, draft: draft.toModel());
}

/// Maps a generated [api.QueryDraftsResponse] to a [QueryDraftsResponse].
extension QueryDraftsResponseMapper on api.QueryDraftsResponse {
  /// Converts this response into a [QueryDraftsResponse].
  QueryDraftsResponse toModel() => QueryDraftsResponse(
    duration: duration,
    drafts: [for (final draft in drafts) draft.toModel()],
    next: next,
    prev: prev,
  );
}

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
  /// Custom data named like one of the draft message's own fields is left out of [DraftMessage.extraData].
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
    extraData: {...custom}..removeWhere((key, _) => _shadowedCustomKeys.contains(key)),
    html: html,
    mml: mml,
  );
}

/// Maps a [DraftMessage] to the generated [api.MessageRequest] that saves it.
extension DraftMessageRequestMapper on DraftMessage {
  /// Converts this draft message into the request that saves it.
  ///
  /// Mentioned users the text no longer mentions are left out, and a [command] is written into the text as
  /// `/command text`. The extra data becomes the custom data, except the fields a received message keeps there,
  /// such as [DraftMessage.html] and [DraftMessage.mml]; the markup is sent as a field of its own.
  api.MessageRequest toRequest() {
    final message = removeMentionsIfNotIncluded();
    final custom = {...message.extraData}..removeWhere((key, _) => messageExtraDataFields.contains(key));

    return api.MessageRequest(
      id: message.id,
      text: switch ((message.text, message.command)) {
        (final text?, final command?) when command.isNotEmpty => '/$command $text',
        (final text, _) => text,
      },
      type: switch (MessageType.toJson(message.type)) {
        final type? => api.MessageRequestType.fromJson(type),
        null => null,
      },
      attachments: [for (final attachment in message.attachments) attachment.toRequest()],
      parentId: message.parentId,
      showInChannel: message.showInChannel,
      mentionedUsers: [for (final user in message.mentionedUsers) user.id],
      quotedMessageId: message.quotedMessageId,
      silent: message.silent,
      pollId: message.pollId,
      mml: message.mml,
      custom: custom.isEmpty ? null : custom,
    );
  }
}
