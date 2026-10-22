import 'package:stream_core/stream_core.dart' show SortDirection, Standard;

import '../../../open_api/api.dart' as api;
import '../../core/api/requests.dart';
import '../../core/models/channel_config.dart';
import '../../core/models/channel_model.dart';
import '../../core/models/channel_state.dart';
import '../../core/models/chat_preferences.dart';
import '../../core/models/command.dart';
import '../../core/models/member.dart';
import '../../core/models/predefined_filter.dart';
import '../../core/models/push_level.dart';
import '../../core/models/push_preference.dart';
import '../../core/models/read.dart';
import '../../core/models/request/message_delivery.dart';
import '../../core/models/response/channel_state_response.dart';
import '../../core/models/response/delete_channel_response.dart';
import '../../core/models/response/event_response.dart';
import '../../core/models/response/hide_channel_response.dart';
import '../../core/models/response/mark_delivered_response.dart';
import '../../core/models/response/mark_read_response.dart';
import '../../core/models/response/query_channels_response.dart';
import '../../core/models/response/query_members_response.dart';
import '../../core/models/response/show_channel_response.dart';
import '../../core/models/response/truncate_channel_response.dart';
import '../../core/models/response/update_channel_partial_response.dart';
import '../../core/models/response/update_channel_response.dart';
import '../../core/models/response/update_member_partial_response.dart';
import 'drafts_mapper.dart';
import 'locations_mapper.dart';
import 'messages_mapper.dart';
import 'users_mapper.dart';

/// Maps a generated [api.ChannelResponse] to a [ChannelModel].
extension ChannelResponseMapper on api.ChannelResponse {
  /// Converts this response into a [ChannelModel].
  ChannelModel toModel() => ChannelModel(
    id: id,
    type: type,
    cid: cid,
    ownCapabilities: ownCapabilities?.map(ChannelCapability.new).toList(),
    config: config?.toModel(),
    createdBy: createdBy?.toModel(),
    frozen: frozen,
    lastMessageAt: lastMessageAt?.takeUnless(_isEpoch),
    createdAt: createdAt,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
    memberCount: memberCount ?? 0,
    members: members?.map((member) => member.toModel()).toList(),
    custom: custom,
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

// Whether [time] is the Unix epoch, which stands for no date.
bool _isEpoch(DateTime time) => time.microsecondsSinceEpoch == 0;

/// Maps a generated [api.ChannelConfigWithInfo] to a [ChannelConfig].
extension ChannelConfigWithInfoMapper on api.ChannelConfigWithInfo {
  // TODO(openapi-migration): revisit exposing the config fields ChannelConfig
  //  does not model yet: allowedFlagReasons, automodBehavior,
  //  automodThresholds, blocklist, blocklistBehavior, blocklists,
  //  countMessages, customEvents, grants, name, partitionSize, partitionTtl,
  //  quotes and reminders.

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
  /// Converts this response into a [Member].
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
    custom: custom,
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

/// Maps a generated [api.UpdateChannelPartialResponse] to an
/// [UpdateChannelPartialResponse].
extension UpdateChannelPartialResponseMapper on api.UpdateChannelPartialResponse {
  /// Converts this response into an [UpdateChannelPartialResponse].
  UpdateChannelPartialResponse toModel() => UpdateChannelPartialResponse(
    duration: duration,
    channel: channel?.toModel(),
    members: [for (final member in members) member.toModel()],
  );
}

/// Maps a generated [api.UpdateMemberPartialResponse] to an
/// [UpdateMemberPartialResponse].
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
  // TODO(openapi-migration): map `event` in group 09; its user is a
  // `UserResponseCommonFields`.

  /// Converts this response into a [MarkReadResponse].
  MarkReadResponse toModel() => MarkReadResponse(duration: duration);
}

/// Maps a generated [api.MarkDeliveredResponse] to a [MarkDeliveredResponse].
extension MarkDeliveredResponseMapper on api.MarkDeliveredResponse {
  /// Converts this response into a [MarkDeliveredResponse].
  MarkDeliveredResponse toModel() => MarkDeliveredResponse(duration: duration);
}

/// Maps a [MessageDelivery] to the generated [api.DeliveredMessagePayload].
extension MessageDeliveryRequestMapper on MessageDelivery {
  /// Converts this receipt into an [api.DeliveredMessagePayload].
  api.DeliveredMessagePayload toRequest() => api.DeliveredMessagePayload(cid: channelCid, id: messageId);
}

/// Maps a generated [api.EventResponse] to an [EventResponse].
extension EventResponseMapper on api.EventResponse {
  // TODO(openapi-migration): map `event` once `Event` and the WebSocket move to
  // v2.

  /// Converts this response into an [EventResponse].
  EventResponse toModel() => EventResponse(duration: duration);
}

/// Converts the channel [data] a caller gives as one map into the
/// [api.ChannelInput] that creates a channel.
///
/// `members` and `invites`, each a list of user ids or of member maps with a
/// `user_id`, `team`, `frozen`, `disabled`, `auto_translation_enabled`,
/// `auto_translation_language`, `config_overrides` and `filter_tags` become
/// the request's fields; every other entry, `name` and `image` included, is
/// sent as custom data. A value of another type than the field's throws.
api.ChannelInput channelInputFromData(Map<String, Object?> data) {
  final custom = {...data};
  final fields = _extractChannelDataFields(custom);
  final filterTags = custom.remove('filter_tags') as List<Object?>?;

  return api.ChannelInput(
    members: fields.members,
    invites: fields.invites,
    team: fields.team,
    frozen: fields.frozen,
    disabled: fields.disabled,
    autoTranslationEnabled: fields.autoTranslationEnabled,
    autoTranslationLanguage: fields.autoTranslationLanguage,
    configOverrides: fields.configOverrides?.let(api.ChannelConfigOverrides.fromJson),
    filterTags: filterTags?.cast<String>().toList(),
    custom: custom,
  );
}

/// Converts the channel [data] a caller gives as one map into the
/// [api.ChannelInputRequest] that replaces a channel's data.
///
/// The entries map as in [channelInputFromData], except `filter_tags`, which
/// stays custom data.
api.ChannelInputRequest channelInputRequestFromData(Map<String, Object?> data) {
  final custom = {...data};
  final fields = _extractChannelDataFields(custom);

  return api.ChannelInputRequest(
    members: fields.members,
    invites: fields.invites,
    team: fields.team,
    frozen: fields.frozen,
    disabled: fields.disabled,
    autoTranslationEnabled: fields.autoTranslationEnabled,
    autoTranslationLanguage: fields.autoTranslationLanguage,
    configOverrides: fields.configOverrides?.let(api.ConfigOverridesRequest.fromJson),
    custom: custom,
  );
}

// The entries of channel data that both the create and the update request
// carry as fields.
typedef _ChannelDataFields = ({
  List<api.ChannelMemberRequest>? members,
  List<api.ChannelMemberRequest>? invites,
  String? team,
  bool? frozen,
  bool? disabled,
  bool? autoTranslationEnabled,
  String? autoTranslationLanguage,
  Map<String, Object?>? configOverrides,
});

// Removes the field entries from [data], leaving its custom data.
_ChannelDataFields _extractChannelDataFields(Map<String, Object?> data) => (
  members: _memberRequests(data.remove('members')),
  invites: _memberRequests(data.remove('invites')),
  team: data.remove('team') as String?,
  frozen: data.remove('frozen') as bool?,
  disabled: data.remove('disabled') as bool?,
  autoTranslationEnabled: data.remove('auto_translation_enabled') as bool?,
  autoTranslationLanguage: data.remove('auto_translation_language') as String?,
  configOverrides: data.remove('config_overrides') as Map<String, Object?>?,
);

// The member requests for a list of user ids or member maps. A map's
// `user_id` and `channel_role` become fields and its other entries the
// member's custom data.
List<api.ChannelMemberRequest>? _memberRequests(Object? members) {
  if (members == null) return null;

  return [
    for (final member in members as List<Object?>)
      switch (member) {
        final String userId => api.ChannelMemberRequest(userId: userId),
        final Map<String, Object?> member => _memberRequestFromMap(member),
        _ => throw ArgumentError.value(member, 'members', 'Expected a user id or a member map'),
      },
  ];
}

api.ChannelMemberRequest _memberRequestFromMap(Map<String, Object?> member) {
  final custom = {...member};
  final userId =
      custom.remove('user_id') as String? ??
      (throw ArgumentError.value(member, 'members', 'Expected a member map with a user_id'));
  final channelRole = custom.remove('channel_role') as String?;

  return api.ChannelMemberRequest(
    userId: userId,
    channelRole: channelRole,
    custom: custom.isEmpty ? null : custom,
  );
}

/// Maps a [Member] to the generated [api.ChannelMemberRequest] that names it.
extension MemberRequestMapper on Member {
  /// Converts this member into a request carrying only its user id.
  api.ChannelMemberRequest toRequest() => api.ChannelMemberRequest(userId: userId);
}

/// Maps [PaginationParams] to the pagination of the generated requests.
extension PaginationParamsRequestMapper on PaginationParams {
  /// Converts these params into the [api.MessagePaginationParams] of a channel
  /// query.
  ///
  /// [offset] and [next] are left out: messages are paged by id or date.
  api.MessagePaginationParams toMessagePaginationParams() => api.MessagePaginationParams(
    limit: limit,
    idAround: idAround,
    idGt: greaterThan,
    idGte: greaterThanOrEqual,
    idLt: lessThan,
    idLte: lessThanOrEqual,
    createdAtAfter: createdAtAfter,
    createdAtAfterOrEqual: createdAtAfterOrEqual,
    createdAtAround: createdAtAround,
    createdAtBefore: createdAtBefore,
    createdAtBeforeOrEqual: createdAtBeforeOrEqual,
  );

  /// Converts these params into the [api.PaginationParams] of a channel
  /// query's members or watchers, which are paged by [limit] and [offset].
  api.PaginationParams toPaginationParams() => api.PaginationParams(limit: limit, offset: offset);
}

/// Maps a generated [api.ParsedPredefinedFilterResponse] to a
/// [PredefinedFilter].
extension ParsedPredefinedFilterResponseMapper on api.ParsedPredefinedFilterResponse {
  /// Converts this response into a [PredefinedFilter].
  PredefinedFilter toModel() => PredefinedFilter(
    name: name,
    filter: ChannelFilter.raw(filter),
    sort: sort?.map((sort) => sort.toChannelSort()).nonNulls.toList(),
  );
}

/// Maps a generated [api.SortParamRequest] to a [ChannelSort].
extension SortParamRequestMapper on api.SortParamRequest {
  /// Converts this sort into a [ChannelSort], or null when it names no field.
  ChannelSort? toChannelSort() {
    final field = this.field;
    if (field == null) return null;

    final sortField = ChannelSortField.fromRemote(field);
    if (direction == SortDirection.desc.value) return ChannelSort.desc(sortField);
    return ChannelSort.asc(sortField);
  }
}

/// Maps a generated [api.ChannelStateResponse] to a [ChannelStateResponse].
extension ChannelStateResponseMapper on api.ChannelStateResponse {
  /// Converts this response into a [ChannelStateResponse].
  ChannelStateResponse toModel() => ChannelStateResponse(
    duration: duration,
    channelState: api.ChannelStateResponseFields(
      activeLiveLocations: activeLiveLocations,
      channel: channel,
      draft: draft,
      members: members,
      membership: membership,
      messages: messages,
      pendingMessages: pendingMessages,
      pinnedMessages: pinnedMessages,
      pushPreferences: pushPreferences,
      read: read,
      threads: threads,
      watcherCount: watcherCount,
      watchers: watchers,
    ).toModel(),
  );
}

/// Maps a generated [api.ChannelStateResponseFields] to a [ChannelState].
extension ChannelStateResponseFieldsMapper on api.ChannelStateResponseFields {
  // TODO(openapi-migration): revisit exposing hideMessagesBefore and threads.

  /// Converts this channel state into a [ChannelState].
  ///
  /// Pending messages without a message are left out, and none at all reads as
  /// null.
  ChannelState toModel() {
    final pendingMessages = [
      for (final pending in this.pendingMessages ?? const <api.PendingMessageResponse>[])
        if (pending.message case final message?) message.toModel(),
    ];

    return ChannelState(
      channel: channel?.toModel(),
      messages: [for (final message in messages) message.toModel()],
      members: [for (final member in members) member.toModel()],
      pinnedMessages: [for (final message in pinnedMessages) message.toModel()],
      watcherCount: watcherCount,
      watchers: watchers?.map((user) => user.toModel()).toList(),
      read: read?.map((read) => read.toModel()).toList(),
      membership: membership?.toModel(),
      draft: draft?.toModel(),
      pendingMessages: pendingMessages.isEmpty ? null : pendingMessages,
      pushPreferences: pushPreferences?.toModel(),
      activeLiveLocations: activeLiveLocations?.map((location) => location.toModel()).toList(),
    );
  }
}

/// Maps a generated [api.ChannelPushPreferencesResponse] to a
/// [ChannelPushPreference].
extension ChannelPushPreferencesResponseMapper on api.ChannelPushPreferencesResponse {
  /// Converts these preferences into a [ChannelPushPreference].
  ChannelPushPreference toModel() => ChannelPushPreference(
    chatLevel: chatLevel?.let(ChatLevel.new),
    chatPreferences: chatPreferences?.toModel(),
    disabledUntil: disabledUntil,
  );
}

/// Maps a generated [api.ChatPreferencesResponse] to [ChatPreferences].
extension ChatPreferencesResponseMapper on api.ChatPreferencesResponse {
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

/// Maps a generated [api.TruncateChannelResponse] to a
/// [TruncateChannelResponse].
extension TruncateChannelResponseMapper on api.TruncateChannelResponse {
  /// Converts this response into a [TruncateChannelResponse].
  TruncateChannelResponse toModel() => TruncateChannelResponse(
    duration: duration,
    channel: channel?.toModel(),
    message: message?.toModel(),
  );
}

/// Maps a generated [api.UpdateChannelResponse] to an [UpdateChannelResponse].
extension UpdateChannelResponseMapper on api.UpdateChannelResponse {
  /// Converts this response into an [UpdateChannelResponse].
  UpdateChannelResponse toModel() => UpdateChannelResponse(
    duration: duration,
    channel: channel?.toModel(),
    members: [for (final member in members) member.toModel()],
    message: message?.toModel(),
  );
}

/// Maps a generated [api.MembersResponse] to a [QueryMembersResponse].
extension MembersResponseMapper on api.MembersResponse {
  /// Converts this response into a [QueryMembersResponse].
  QueryMembersResponse toModel() => QueryMembersResponse(
    duration: duration,
    members: [for (final member in members) member.toModel()],
  );
}

/// Maps a generated [api.QueryChannelsResponse] to a [QueryChannelsResponse].
extension QueryChannelsResponseMapper on api.QueryChannelsResponse {
  /// Converts this response into a [QueryChannelsResponse].
  QueryChannelsResponse toModel() => QueryChannelsResponse(
    duration: duration,
    channels: [for (final channel in channels) channel.toModel()],
    predefinedFilter: predefinedFilter?.toModel(),
  );
}
