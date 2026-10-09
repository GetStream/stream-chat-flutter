import '../../../open_api/api.dart' as api;
import '../../core/models/draft.dart';
import '../../core/models/draft_message.dart';
import '../../core/models/message.dart';
import '../../core/models/response/create_draft_response.dart';
import '../../core/models/response/get_draft_response.dart';
import '../../core/models/response/query_drafts_response.dart';
import '../../core/models/user.dart';
import 'attachments_mapper.dart';
import 'channels_mapper.dart';
import 'messages_mapper.dart';
import 'users_mapper.dart';

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
    final custom = {...extraData}..removeWhere((key, _) => MessageResponseMapper.extraDataFields.contains(key));

    return api.MessageRequest(
      id: id,
      text: switch ((text, command)) {
        (final text?, final command?) when command.isNotEmpty => '/$command $text',
        (final text, _) => text,
      },
      type: switch (MessageType.toJson(type)) {
        final type? => api.MessageRequestType.fromJson(type),
        null => null,
      },
      attachments: [for (final attachment in attachments) attachment.toRequest()],
      parentId: parentId,
      showInChannel: showInChannel,
      mentionedUsers: [for (final user in _mentionedUsersInText()) user.id],
      quotedMessageId: quotedMessageId,
      silent: silent,
      pollId: pollId,
      mml: mml,
      custom: custom.isEmpty ? null : custom,
    );
  }

  // The mentioned users the text still mentions by id or name; all of them when there is no text.
  List<User> _mentionedUsersInText() {
    final text = this.text;
    if (text == null) return mentionedUsers;

    final mentioned = [...mentionedUsers];
    for (final user in mentionedUsers.toSet()) {
      if (text.contains('@${user.id}') || text.contains('@${user.name}')) continue;
      mentioned.remove(user);
    }

    return mentioned;
  }
}
