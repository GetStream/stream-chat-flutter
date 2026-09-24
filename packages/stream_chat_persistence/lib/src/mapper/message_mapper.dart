import 'dart:convert';

import 'package:stream_chat/stream_chat.dart';
import '../db/drift_chat_database.dart';

/// Useful mapping functions for [MessageEntity]
extension MessageEntityX on MessageEntity {
  /// Maps a [MessageEntity] into [Message]
  Message toMessage({
    User? user,
    User? pinnedBy,
    List<Reaction>? latestReactions,
    List<Reaction>? ownReactions,
    Message? quotedMessage,
    Poll? poll,
    Draft? draft,
    Location? sharedLocation,
  }) => Message(
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
    deletedForMe: deletedForMe,
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
    channelRole: channelRole,
    pinned: pinned,
    pinnedAt: pinnedAt,
    pinExpires: pinExpires,
    pinnedBy: pinnedBy,
    mentionedChannel: mentionedChannel,
    mentionedGroupIds: mentionedGroupIds,
    mentionedGroups: mentionedGroups?.map((e) => _userGroupFromJson(jsonDecode(e))).toList(),
    mentionedHere: mentionedHere,
    mentionedRoles: mentionedRoles,
    mentionedUsers: mentionedUsers.map((e) => User.fromJson(jsonDecode(e))).toList(),
    i18n: i18n,
    restrictedVisibility: restrictedVisibility,
    draft: draft,
    sharedLocation: sharedLocation,
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
    pollId: pollId,
    command: command,
    remoteCreatedAt: remoteCreatedAt,
    localCreatedAt: localCreatedAt,
    shadowed: shadowed,
    showInChannel: showInChannel,
    replyCount: replyCount,
    reactionGroups: reactionGroups,
    mentionedChannel: mentionedChannel,
    mentionedGroupIds: mentionedGroupIds,
    mentionedGroups: mentionedGroups?.map((e) => jsonEncode(_userGroupToJson(e))).toList(),
    mentionedHere: mentionedHere,
    mentionedRoles: mentionedRoles,
    mentionedUsers: mentionedUsers.map(jsonEncode).toList(),
    state: jsonEncode(state.toJson()),
    remoteUpdatedAt: remoteUpdatedAt,
    localUpdatedAt: localUpdatedAt,
    extraData: extraData,
    userId: user?.id,
    channelRole: channelRole,
    remoteDeletedAt: remoteDeletedAt,
    localDeletedAt: localDeletedAt,
    deletedForMe: deletedForMe,
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

// A mentioned group is stored under the keys earlier versions wrote, so cached rows still read back.
Map<String, Object?> _userGroupToJson(UserGroup group) => {
  'created_at': group.createdAt.toIso8601String(),
  'created_by': ?group.createdBy,
  'description': ?group.description,
  'id': group.id,
  'members': ?group.members?.map(_userGroupMemberToJson).toList(),
  'name': group.name,
  'team_id': ?group.teamId,
  'updated_at': group.updatedAt.toIso8601String(),
};

UserGroup _userGroupFromJson(Map<String, dynamic> json) => UserGroup(
  createdAt: DateTime.parse(json['created_at'] as String),
  createdBy: json['created_by'] as String?,
  description: json['description'] as String?,
  id: json['id'] as String,
  members: (json['members'] as List<dynamic>?)
      ?.map((member) => _userGroupMemberFromJson(member as Map<String, dynamic>))
      .toList(),
  name: json['name'] as String,
  teamId: json['team_id'] as String?,
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, Object?> _userGroupMemberToJson(UserGroupMember member) => {
  'created_at': member.createdAt.toIso8601String(),
  'group_id': member.groupId,
  'is_admin': member.isAdmin,
  'user_id': member.userId,
};

UserGroupMember _userGroupMemberFromJson(Map<String, dynamic> json) => UserGroupMember(
  createdAt: DateTime.parse(json['created_at'] as String),
  groupId: json['group_id'] as String,
  isAdmin: json['is_admin'] as bool,
  userId: json['user_id'] as String,
);
