import '../../../open_api/api.dart' as api;
import '../../core/models/message.dart';
import '../../core/util/message_decoding.dart';
import 'attachment_mapper.dart';
import 'drafts_mapper.dart';
import 'location_mapper.dart';
import 'moderation_mapper.dart';
import 'polls_mapper.dart';
import 'reaction_mapper.dart';
import 'reminders_mapper.dart';
import 'user_groups_mapper.dart';
import 'user_mapper.dart';

// TODO(openapi-migration): re-point these mappers in group 10.

/// The fields a received [Message] keeps in its extra data, which are not custom data.
const kMessageExtraDataFields = {
  'cid',
  'html',
  'mml',
  'image_labels',
  'deleted_reply_count',
  'mentioned_channel_members',
};

/// Maps a generated [api.MessageResponse] to a [Message].
extension MessageResponseMapper on api.MessageResponse {
  // Custom keys named like one of the message's own fields, including the ones it keeps in its extra data.
  static final _shadowedCustomKeys = {...Message.topLevelFields, ...kMessageExtraDataFields};

  /// Converts this response into a [Message].
  ///
  /// The message's type and state follow from whether and when it was deleted or updated. Without reaction groups,
  /// they are built from the reaction counts and scores.
  ///
  /// The channel id is kept in [Message.extraData], beside the custom data, with custom data named like one of the
  /// message's own fields left out.
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
    extraData: {
      ...{...custom}..removeWhere((key, _) => _shadowedCustomKeys.contains(key)),
      'cid': cid,
    },
    i18n: i18n,
    restrictedVisibility: restrictedVisibility,
    moderation: moderation?.toModel(),
    draft: draft?.toModel(),
    reminder: reminder?.toModel(),
    channelRole: member?.channelRole,
    sharedLocation: sharedLocation?.toModel(),
    html: html,
    mml: mml,
    imageLabels: imageLabels,
    deletedReplyCount: deletedReplyCount,
  ).withDerivedState();
}
