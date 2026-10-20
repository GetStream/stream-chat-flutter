import '../../../open_api/api.dart' as api;
import '../../core/models/message.dart';
import '../../core/models/moderation.dart';
import '../../core/models/response/get_many_messages_response.dart';
import '../../core/models/response/get_message_response.dart';
import '../../core/models/response/get_replies_response.dart';
import '../../core/models/response/search_messages_response.dart';
import '../../core/models/response/translate_message_response.dart';
import '../../core/models/search_message_result.dart';
import '../../core/models/translation_language.dart';
import '../../core/util/message_decoding.dart';
import 'attachments_mapper.dart';
import 'channels_mapper.dart';
import 'drafts_mapper.dart';
import 'locations_mapper.dart';
import 'polls_mapper.dart';
import 'reactions_mapper.dart';
import 'reminders_mapper.dart';
import 'user_groups_mapper.dart';
import 'users_mapper.dart';

/// Maps a generated [api.GetMessageResponse] to a [GetMessageResponse].
extension GetMessageResponseMapper on api.GetMessageResponse {
  /// Converts this response into a [GetMessageResponse].
  GetMessageResponse toModel() => GetMessageResponse(
    duration: duration,
    message: message.toModel(),
    channel: message.channel.toModel(),
  );
}

/// Maps a generated [api.GetManyMessagesResponse] to a
/// [GetManyMessagesResponse].
extension GetManyMessagesResponseMapper on api.GetManyMessagesResponse {
  /// Converts this response into a [GetManyMessagesResponse].
  GetManyMessagesResponse toModel() => GetManyMessagesResponse(
    duration: duration,
    messages: [for (final message in messages) message.toModel()],
  );
}

/// Maps a generated [api.GetRepliesResponse] to a [GetRepliesResponse].
extension GetRepliesResponseMapper on api.GetRepliesResponse {
  /// Converts this response into a [GetRepliesResponse].
  GetRepliesResponse toModel() => GetRepliesResponse(
    duration: duration,
    messages: [for (final message in messages) message.toModel()],
  );
}

/// Maps a generated [api.TranslateMessageResponse] to a
/// [TranslateMessageResponse].
extension TranslateMessageResponseMapper on api.TranslateMessageResponse {
  /// Converts this response into a [TranslateMessageResponse].
  TranslateMessageResponse toModel() => TranslateMessageResponse(
    duration: duration,
    message: message.toModel(),
  );
}

/// Maps a generated [api.SearchResponse] to a [SearchMessagesResponse].
extension SearchResponseMapper on api.SearchResponse {
  /// Converts this response into a [SearchMessagesResponse].
  ///
  /// A result without a message is left out.
  SearchMessagesResponse toModel() => SearchMessagesResponse(
    duration: duration,
    results: [
      for (final result in results)
        if (result.message case final message?)
          SearchMessageResult(message: message.toModel(), channel: message.channel?.toModel()),
    ],
    next: next,
    previous: previous,
  );
}

// TODO(openapi-migration): re-point these mappers in group 10.

/// Maps a generated [api.MessageResponse] to a [Message].
extension MessageResponseMapper on api.MessageResponse {
  /// Converts this response into a [Message].
  ///
  /// The message's type and state follow from whether and when it was deleted
  /// or updated. Without reaction groups, they are built from the reaction
  /// counts and scores.
  Message toModel() => Message(
    id: id,
    text: text,
    type: type,
    attachments: [for (final attachment in attachments) attachment.toModel()],
    mentionedChannel: mentionedChannel,
    mentionedGroupIds: mentionedGroupIds,
    mentionedGroups: mentionedGroups?.map((group) => group.toModel()).toList(),
    mentionedHere: mentionedHere,
    mentionedRoles: mentionedRoles,
    mentionedUsers: [for (final user in mentionedUsers) user.toModel()],
    silent: silent,
    shadowed: shadowed,
    reactionGroups:
        reactionGroups?.map((type, group) => MapEntry(type, group.toModel())) ??
        reactionGroupsFromCounts(reactionCounts, reactionScores),
    latestReactions: [for (final reaction in latestReactions) reaction.toModel()],
    ownReactions: [for (final reaction in ownReactions) reaction.toModel()],
    parentId: parentId,
    quotedMessage: quotedMessage?.toModel(),
    quotedMessageId: quotedMessageId,
    replyCount: replyCount,
    threadParticipants: threadParticipants?.map((user) => user.toModel()).toList(),
    showInChannel: showInChannel,
    command: command,
    createdAt: createdAt,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
    deletedForMe: deletedForMe,
    messageTextUpdatedAt: messageTextUpdatedAt,
    user: user.toModel(),
    pinned: pinned,
    pinnedAt: pinnedAt,
    pinExpires: pinExpires,
    pinnedBy: pinnedBy?.toModel(),
    poll: poll?.toModel(),
    pollId: pollId,
    custom: custom,
    i18n: i18n,
    restrictedVisibility: restrictedVisibility,
    moderation: moderation?.toModel(),
    draft: draft?.toModel(),
    reminder: reminder?.toModel(),
    channelRole: member?.channelRole,
    sharedLocation: sharedLocation?.toModel(),
    cid: cid,
    html: html,
    mml: mml,
    deletedReplyCount: deletedReplyCount,
  ).withDerivedState();
}

/// Maps a generated [api.MessageWithChannelResponse] to a [Message].
extension MessageWithChannelResponseMapper on api.MessageWithChannelResponse {
  /// Converts this message into a [Message], leaving out its channel.
  Message toModel() => _asMessageResponse().toModel();

  // Shares the mapping of [MessageResponseMapper], which this type cannot reach
  // because it does not extend [api.MessageResponse].
  api.MessageResponse _asMessageResponse() => api.MessageResponse(
    attachments: attachments,
    cid: cid,
    command: command,
    createdAt: createdAt,
    custom: custom,
    deletedAt: deletedAt,
    deletedForMe: deletedForMe,
    deletedReplyCount: deletedReplyCount,
    draft: draft,
    html: html,
    i18n: i18n,
    id: id,
    imageLabels: imageLabels,
    latestReactions: latestReactions,
    member: member,
    mentionedChannel: mentionedChannel,
    mentionedChannelMembers: mentionedChannelMembers,
    mentionedGroupIds: mentionedGroupIds,
    mentionedGroups: mentionedGroups,
    mentionedHere: mentionedHere,
    mentionedRoles: mentionedRoles,
    mentionedUsers: mentionedUsers,
    messageTextUpdatedAt: messageTextUpdatedAt,
    mml: mml,
    moderation: moderation,
    ownReactions: ownReactions,
    parentId: parentId,
    pinExpires: pinExpires,
    pinned: pinned,
    pinnedAt: pinnedAt,
    pinnedBy: pinnedBy,
    poll: poll,
    pollId: pollId,
    quotedMessage: quotedMessage,
    quotedMessageId: quotedMessageId,
    reactionCounts: reactionCounts,
    reactionGroups: reactionGroups,
    reactionScores: reactionScores,
    reminder: reminder,
    replyCount: replyCount,
    restrictedVisibility: restrictedVisibility,
    shadowed: shadowed,
    sharedLocation: sharedLocation,
    showInChannel: showInChannel,
    silent: silent,
    text: text,
    threadParticipants: threadParticipants,
    type: type,
    updatedAt: updatedAt,
    user: user,
  );
}

/// Maps a generated [api.SearchResultMessage] to a [Message].
extension SearchResultMessageMapper on api.SearchResultMessage {
  /// Converts this search result into a [Message], leaving out its channel.
  Message toModel() => _asMessageResponse().toModel();

  // Shares the mapping of [MessageResponseMapper], which this type cannot reach
  // because it does not extend [api.MessageResponse].
  api.MessageResponse _asMessageResponse() => api.MessageResponse(
    attachments: attachments,
    cid: cid,
    command: command,
    createdAt: createdAt,
    custom: custom,
    deletedAt: deletedAt,
    deletedForMe: deletedForMe,
    deletedReplyCount: deletedReplyCount,
    draft: draft,
    html: html,
    i18n: i18n,
    id: id,
    imageLabels: imageLabels,
    latestReactions: latestReactions,
    member: member,
    mentionedChannel: mentionedChannel,
    mentionedChannelMembers: mentionedChannelMembers,
    mentionedGroupIds: mentionedGroupIds,
    mentionedGroups: mentionedGroups,
    mentionedHere: mentionedHere,
    mentionedRoles: mentionedRoles,
    mentionedUsers: mentionedUsers,
    messageTextUpdatedAt: messageTextUpdatedAt,
    mml: mml,
    moderation: moderation,
    ownReactions: ownReactions,
    parentId: parentId,
    pinExpires: pinExpires,
    pinned: pinned,
    pinnedAt: pinnedAt,
    pinnedBy: pinnedBy,
    poll: poll,
    pollId: pollId,
    quotedMessage: quotedMessage,
    quotedMessageId: quotedMessageId,
    reactionCounts: reactionCounts,
    reactionGroups: reactionGroups,
    reactionScores: reactionScores,
    reminder: reminder,
    replyCount: replyCount,
    restrictedVisibility: restrictedVisibility,
    shadowed: shadowed,
    sharedLocation: sharedLocation,
    showInChannel: showInChannel,
    silent: silent,
    text: text,
    threadParticipants: threadParticipants,
    type: type,
    updatedAt: updatedAt,
    user: user,
  );
}

/// Maps a [TranslationLanguage] to the generated
/// [api.TranslateMessageRequestLanguage].
extension TranslationLanguageRequestMapper on TranslationLanguage {
  /// Converts this language into an [api.TranslateMessageRequestLanguage].
  api.TranslateMessageRequestLanguage toRequest() => api.TranslateMessageRequestLanguage.fromJson(this);
}

/// Maps a generated [api.ModerationV2Response] to a [Moderation].
extension ModerationV2ResponseMapper on api.ModerationV2Response {
  /// Converts this response into a [Moderation].
  Moderation toModel() => Moderation(
    action: ModerationAction.fromJson(action),
    originalText: originalText,
    textHarms: textHarms,
    imageHarms: imageHarms,
    blocklistMatched: blocklistMatched,
    semanticFilterMatched: semanticFilterMatched,
    platformCircumvented: platformCircumvented ?? false,
  );
}
