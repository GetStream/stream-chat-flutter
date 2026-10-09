import 'package:stream_core/stream_core.dart' show Standard;

import '../../../open_api/api.dart' as api;
import '../../core/models/channel_config.dart';
import '../../core/models/channel_model.dart';
import '../../core/models/chat_preferences.dart';
import '../../core/models/command.dart';
import '../../core/models/member.dart';
import '../../core/models/push_level.dart';
import '../../core/models/read.dart';
import '../../core/models/request/message_delivery.dart';
import '../../core/models/response/delete_channel_response.dart';
import '../../core/models/response/hide_channel_response.dart';
import '../../core/models/response/mark_delivered_response.dart';
import '../../core/models/response/mark_read_response.dart';
import '../../core/models/response/show_channel_response.dart';
import '../../core/models/response/update_channel_partial_response.dart';
import '../../core/models/response/update_member_partial_response.dart';
import 'user_mapper.dart';

// TODO(openapi-migration): re-point these mappers in group 11.

/// Maps a generated [api.ChannelResponse] to a [ChannelModel].
extension ChannelResponseMapper on api.ChannelResponse {
  // Custom keys named like one of the channel's own fields, including the ones it keeps in its extra data.
  static const _shadowedCustomKeys = {
    ...ChannelModel.topLevelFields,
    'disabled',
    'hidden',
    'muted',
    'blocked',
    'truncated_at',
    'truncated_by',
    'mute_expires_at',
    'auto_translation_enabled',
    'auto_translation_language',
    'hide_messages_before',
  };

  /// Converts this response into a [ChannelModel].
  ///
  /// Custom data named like one of the channel's own fields is left out of [ChannelModel.extraData].
  ChannelModel toModel() => ChannelModel(
    id: id,
    type: type,
    cid: cid,
    ownCapabilities: ownCapabilities,
    config: config?.toModel(),
    createdBy: createdBy?.toModel(),
    frozen: frozen,
    lastMessageAt: lastMessageAt,
    createdAt: createdAt,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
    memberCount: memberCount ?? 0,
    members: members?.map((member) => member.toModel()).toList(),
    extraData: {...custom}..removeWhere((key, _) => _shadowedCustomKeys.contains(key)),
    team: team,
    cooldown: cooldown ?? 0,
    disabled: disabled,
    hidden: hidden,
    muted: muted,
    blocked: blocked,
    truncatedAt: truncatedAt,
    messageCount: messageCount,
    filterTags: filterTags,
    truncatedBy: truncatedBy?.toModel(),
    autoTranslationEnabled: autoTranslationEnabled,
    autoTranslationLanguage: autoTranslationLanguage,
  );
}

/// Maps a generated [api.ChannelConfigWithInfo] to a [ChannelConfig].
extension ChannelConfigWithInfoMapper on api.ChannelConfigWithInfo {
  // TODO(openapi-migration): revisit exposing the config fields ChannelConfig does not model yet:
  //  allowedFlagReasons, automodBehavior, automodThresholds, blocklist, blocklistBehavior, blocklists,
  //  countMessages, customEvents, grants, name, partitionSize, partitionTtl, quotes and reminders.

  /// Converts this configuration into a [ChannelConfig].
  ChannelConfig toModel() => ChannelConfig(
    automod: automod,
    commands: [for (final command in commands) command.toModel()],
    connectEvents: connectEvents,
    createdAt: createdAt,
    updatedAt: updatedAt,
    maxMessageLength: maxMessageLength,
    messageRetention: messageRetention,
    mutes: mutes,
    reactions: reactions,
    readEvents: readEvents,
    replies: replies,
    search: search,
    polls: polls,
    pushLevel: pushLevel?.let(PushLevel.new),
    pushNotifications: pushNotifications,
    chatPreferences: chatPreferences?.toModel(),
    typingEvents: typingEvents,
    uploads: uploads,
    urlEnrichment: urlEnrichment,
    skipLastMsgUpdateForSystemMsgs: skipLastMsgUpdateForSystemMsgs,
    userMessageReminders: userMessageReminders,
    markMessagesPending: markMessagesPending,
    deliveryEvents: deliveryEvents,
    sharedLocations: sharedLocations,
  );
}

/// Maps a generated [api.Command] to a [Command].
extension CommandMapper on api.Command {
  /// Converts this command into a [Command].
  Command toModel() => Command(
    name: name,
    description: description,
    args: args,
    set: CommandSet(set),
  );
}

/// Maps a generated [api.ChatPreferences] to a [ChatPreferences].
extension ChatPreferencesMapper on api.ChatPreferences {
  /// Converts these preferences into [ChatPreferences].
  ChatPreferences toModel() => ChatPreferences(
    channelMentions: channelMentions?.let(ChatPreferenceLevel.new),
    defaultPreference: defaultPreference?.let(ChatPreferenceLevel.new),
    directMentions: directMentions?.let(ChatPreferenceLevel.new),
    groupMentions: groupMentions?.let(ChatPreferenceLevel.new),
    hereMentions: hereMentions?.let(ChatPreferenceLevel.new),
    roleMentions: roleMentions?.let(ChatPreferenceLevel.new),
    threadReplies: threadReplies?.let(ChatPreferenceLevel.new),
  );
}

/// Maps a generated [api.ChannelMemberResponse] to a [Member].
extension ChannelMemberResponseMapper on api.ChannelMemberResponse {
  // Custom keys named like one of the member's own fields, including the ones it keeps in its extra data.
  static const _shadowedCustomKeys = {
    ...Member.topLevelFields,
    'notifications_muted',
    'status',
    'role',
    'ban_from_future_channels',
    'future_channel_ban_expires',
    'deleted_at',
  };

  /// Converts this response into a [Member].
  ///
  /// Custom data named like one of the member's own fields is left out of [Member.extraData].
  Member toModel() => Member(
    user: user?.toModel(),
    inviteAcceptedAt: inviteAcceptedAt,
    inviteRejectedAt: inviteRejectedAt,
    invited: invited ?? false,
    channelRole: channelRole,
    userId: userId,
    isModerator: isModerator ?? false,
    createdAt: createdAt,
    updatedAt: updatedAt,
    banned: banned,
    banExpires: banExpires,
    shadowBanned: shadowBanned,
    pinnedAt: pinnedAt,
    archivedAt: archivedAt,
    deletedMessages: deletedMessages ?? const [],
    extraData: {
      ...{...custom}..removeWhere((key, _) => _shadowedCustomKeys.contains(key)),
      if (role case final role?) 'role': role,
    },
    notificationsMuted: notificationsMuted,
    status: status,
    banFromFutureChannels: banFromFutureChannels,
    futureChannelBanExpires: futureChannelBanExpires,
    deletedAt: deletedAt,
  );
}

/// Maps a generated [api.ReadStateResponse] to a [Read].
extension ReadStateResponseMapper on api.ReadStateResponse {
  /// Converts this read state into a [Read].
  Read toModel() => Read(
    lastRead: lastRead,
    user: user.toModel(),
    lastReadMessageId: lastReadMessageId,
    unreadMessages: unreadMessages,
    lastDeliveredAt: lastDeliveredAt,
    lastDeliveredMessageId: lastDeliveredMessageId,
  );
}

/// Maps a generated [api.UpdateChannelPartialResponse] to an [UpdateChannelPartialResponse].
extension UpdateChannelPartialResponseMapper on api.UpdateChannelPartialResponse {
  /// Converts this response into an [UpdateChannelPartialResponse].
  UpdateChannelPartialResponse toModel() => UpdateChannelPartialResponse(
    duration: duration,
    channel: channel?.toModel(),
    members: [for (final member in members) member.toModel()],
  );
}

/// Maps a generated [api.UpdateMemberPartialResponse] to an [UpdateMemberPartialResponse].
extension UpdateMemberPartialResponseMapper on api.UpdateMemberPartialResponse {
  /// Converts this response into an [UpdateMemberPartialResponse].
  UpdateMemberPartialResponse toModel() => UpdateMemberPartialResponse(
    duration: duration,
    channelMember: channelMember?.toModel(),
  );
}

/// Maps a generated [api.HideChannelResponse] to a [HideChannelResponse].
extension HideChannelResponseMapper on api.HideChannelResponse {
  /// Converts this response into a [HideChannelResponse].
  HideChannelResponse toModel() => HideChannelResponse(duration: duration);
}

/// Maps a generated [api.ShowChannelResponse] to a [ShowChannelResponse].
extension ShowChannelResponseMapper on api.ShowChannelResponse {
  /// Converts this response into a [ShowChannelResponse].
  ShowChannelResponse toModel() => ShowChannelResponse(duration: duration);
}

/// Maps a generated [api.DeleteChannelResponse] to a [DeleteChannelResponse].
extension DeleteChannelResponseMapper on api.DeleteChannelResponse {
  /// Converts this response into a [DeleteChannelResponse].
  DeleteChannelResponse toModel() => DeleteChannelResponse(
    duration: duration,
    channel: channel?.toModel(),
  );
}

/// Maps a generated [api.MarkReadResponse] to a [MarkReadResponse].
extension MarkReadResponseMapper on api.MarkReadResponse {
  // TODO(openapi-migration): map `event` in group 09; its user is a `UserResponseCommonFields`.

  /// Converts this response into a [MarkReadResponse].
  MarkReadResponse toModel() => MarkReadResponse(duration: duration);
}

/// Maps a generated [api.MarkDeliveredResponse] to a [MarkDeliveredResponse].
extension MarkDeliveredResponseMapper on api.MarkDeliveredResponse {
  /// Converts this response into a [MarkDeliveredResponse].
  MarkDeliveredResponse toModel() => MarkDeliveredResponse(duration: duration);
}

/// Maps a [MessageDelivery] to a generated [api.DeliveredMessagePayload].
extension MessageDeliveryMapper on MessageDelivery {
  /// Converts this receipt into an [api.DeliveredMessagePayload].
  api.DeliveredMessagePayload toRequest() => api.DeliveredMessagePayload(cid: channelCid, id: messageId);
}
