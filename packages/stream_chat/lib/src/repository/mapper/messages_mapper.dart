import '../../../open_api/api.dart' as api;
import '../../core/models/message.dart';
import '../../core/models/moderation.dart';
import '../../core/util/message_decoding.dart';
import 'attachments_mapper.dart';
import 'drafts_mapper.dart';
import 'locations_mapper.dart';
import 'polls_mapper.dart';
import 'reactions_mapper.dart';
import 'reminders_mapper.dart';
import 'user_groups_mapper.dart';
import 'users_mapper.dart';

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
