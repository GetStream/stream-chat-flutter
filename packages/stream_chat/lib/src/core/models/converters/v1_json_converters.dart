import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart' show StreamDateTimeConverter;

import '../../util/serializer.dart';
import '../action.dart';
import '../channel_config.dart';
import '../channel_model.dart';
import '../chat_preferences.dart';
import '../command.dart';
import '../device.dart';
import '../draft.dart';
import '../location.dart';
import '../member.dart';
import '../message.dart';
import '../message_reminder.dart';
import '../moderation.dart';
import '../poll.dart';
import '../poll_option.dart';
import '../poll_vote.dart';
import '../push_level.dart';
import '../push_provider.dart';
import '../reaction.dart';
import '../reaction_group.dart';
import '../read.dart';
import '../thread.dart';
import '../thread_participant.dart';
import '../user.dart';
import '../user_group.dart';
import '../user_group_member.dart';
import '../voting_visibility.dart';

// Converters for plain models embedded in json_serializable models that still decode v1 JSON. Each one is deleted
// by the migration group that turns its parent into a plain model.

/// Converts an [Action] to and from its v1 keys.
// TODO(openapi-migration): remove in group 10
@internal
class ActionV1JsonConverter implements JsonConverter<Action, Map<String, dynamic>> {
  /// Creates a new [ActionV1JsonConverter].
  const ActionV1JsonConverter();

  @override
  Action fromJson(Map<String, dynamic> json) => Action(
    name: json['name'] as String,
    style: json['style'] as String? ?? 'default',
    text: json['text'] as String,
    type: json['type'] as String,
    value: json['value'] as String?,
  );

  // Writes `value` even when it is null, so sent and stored attachments always
  // carry the key.
  @override
  Map<String, dynamic> toJson(Action action) => {
    'name': action.name,
    'style': action.style,
    'text': action.text,
    'type': action.type,
    'value': action.value,
  };
}

/// Converts a [Location] to and from its v1 keys.
///
/// [toJson] writes the request shape: the coordinates, the device and the end
/// date, without the channel, message, user or the other dates.
// TODO(openapi-migration): remove in group 10
@internal
class LocationV1JsonConverter implements JsonConverter<Location, Map<String, dynamic>> {
  /// Creates a new [LocationV1JsonConverter].
  const LocationV1JsonConverter();

  @override
  Location fromJson(Map<String, dynamic> json) => Location(
    channelCid: json['channel_cid'] as String?,
    channel: switch (json['channel']) {
      final Map<String, dynamic> channel => _channelModelFromV1Json(channel),
      _ => null,
    },
    messageId: json['message_id'] as String?,
    message: switch (json['message']) {
      final Map<String, dynamic> message => Message.fromJson(message),
      _ => null,
    },
    userId: json['user_id'] as String?,
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    createdByDeviceId: json['created_by_device_id'] as String?,
    endAt: _dateTimeOrNull(json['end_at']),
    createdAt: _dateTimeOrNull(json['created_at']),
    updatedAt: _dateTimeOrNull(json['updated_at']),
  );

  @override
  Map<String, dynamic> toJson(Location location) => {
    'latitude': location.latitude,
    'longitude': location.longitude,
    if (location.createdByDeviceId case final createdByDeviceId?) 'created_by_device_id': createdByDeviceId,
    if (location.endAt case final endAt?) 'end_at': endAt.toIso8601String(),
  };
}

/// Converts a [ChannelModel] to and from its v1 keys.
///
/// [fromJson] reads the custom data from the root of the v1 map, beside the
/// known keys; the fields the API's channel declares but the model leaves out,
/// such as `hide_messages_before`, are not custom data. [toJson] writes the
/// id, type, frozen flag, cooldown and custom data, each custom entry at the
/// root unless it is named like a known key.
// TODO(openapi-migration): remove when WebSocket payloads decode as v2
@internal
class ChannelModelV1JsonConverter implements JsonConverter<ChannelModel, Map<String, dynamic>> {
  /// Creates a new [ChannelModelV1JsonConverter].
  const ChannelModelV1JsonConverter();

  @override
  ChannelModel fromJson(Map<String, dynamic> json) => _channelModelFromV1Json(json);

  @override
  Map<String, dynamic> toJson(ChannelModel channel) => Serializer.moveFromExtraDataToRoot(
    {
      'id': channel.id,
      'type': channel.type,
      'frozen': channel.frozen,
      'cooldown': channel.cooldown,
      'extra_data': channel.custom,
    },
    topLevelFields: _channelV1Keys,
  );
}

ChannelModel _channelModelFromV1Json(Map<String, dynamic> json) {
  final data = Serializer.moveToExtraDataFromRoot(json, _channelV1Keys);
  return ChannelModel(
    id: data['id'] as String?,
    type: data['type'] as String?,
    cid: data['cid'] as String?,
    ownCapabilities: (data['own_capabilities'] as List<dynamic>?)
        ?.map((it) => ChannelCapability(it as String))
        .toList(),
    config: channelConfigFromV1Json(data['config'] as Map<String, dynamic>?),
    createdBy: switch (data['created_by']) {
      final Map<String, dynamic> user => User.fromJson(user),
      _ => null,
    },
    frozen: data['frozen'] as bool? ?? false,
    lastMessageAt: _dateTimeOrNull(data['last_message_at']),
    createdAt: _dateTimeOrNull(data['created_at']),
    updatedAt: _dateTimeOrNull(data['updated_at']),
    deletedAt: _dateTimeOrNull(data['deleted_at']),
    memberCount: (data['member_count'] as num?)?.toInt() ?? 0,
    members: membersFromV1Json(data['members'] as List<dynamic>?),
    custom: data['extra_data'] as Map<String, dynamic>? ?? const {},
    team: data['team'] as String?,
    cooldown: (data['cooldown'] as num?)?.toInt() ?? 0,
    disabled: data['disabled'] as bool?,
    hidden: data['hidden'] as bool?,
    muted: data['muted'] as bool?,
    blocked: data['blocked'] as bool?,
    truncatedAt: _dateTimeOrNull(data['truncated_at']),
    messageCount: (data['message_count'] as num?)?.toInt(),
    filterTags: (data['filter_tags'] as List<dynamic>?)?.cast<String>(),
    truncatedBy: switch (data['truncated_by']) {
      final Map<String, dynamic> user => User.fromJson(user),
      _ => null,
    },
    autoTranslationEnabled: data['auto_translation_enabled'] as bool?,
    autoTranslationLanguage: data['auto_translation_language'] as String?,
  );
}

// The keys a channel's v1 map carries beside its custom data: the fields the
// API's channel declares.
const _channelV1Keys = [
  'auto_translation_enabled',
  'auto_translation_language',
  'blocked',
  'cid',
  'config',
  'cooldown',
  'created_at',
  'created_by',
  'deleted_at',
  'disabled',
  'filter_tags',
  'frozen',
  'hidden',
  'hide_messages_before',
  'id',
  'last_message_at',
  'member_count',
  'members',
  'message_count',
  'mute_expires_at',
  'muted',
  'own_capabilities',
  'team',
  'truncated_at',
  'truncated_by',
  'type',
  'updated_at',
];

/// Reads a [ChannelConfig] from its v1 keys, or the default configuration
/// when there is none.
// TODO(openapi-migration): remove when WebSocket payloads decode as v2
@internal
ChannelConfig channelConfigFromV1Json(Map<String, dynamic>? json) =>
    json == null ? ChannelConfig() : _channelConfigFromV1Json(json);

ChannelConfig _channelConfigFromV1Json(Map<String, dynamic> json) => ChannelConfig(
  automod: json['automod'] as String? ?? 'flag',
  commands: [
    for (final command in json['commands'] as List<dynamic>? ?? const [])
      Command.fromJson(command as Map<String, dynamic>),
  ],
  connectEvents: json['connect_events'] as bool? ?? false,
  createdAt: _dateTimeOrNull(json['created_at']),
  updatedAt: _dateTimeOrNull(json['updated_at']),
  maxMessageLength: (json['max_message_length'] as num?)?.toInt() ?? 0,
  messageRetention: json['message_retention'] as String? ?? '',
  mutes: json['mutes'] as bool? ?? false,
  reactions: json['reactions'] as bool? ?? false,
  readEvents: json['read_events'] as bool? ?? false,
  replies: json['replies'] as bool? ?? false,
  search: json['search'] as bool? ?? false,
  polls: json['polls'] as bool? ?? false,
  pushLevel: switch (json['push_level']) {
    final String pushLevel => PushLevel(pushLevel),
    _ => null,
  },
  pushNotifications: json['push_notifications'] as bool? ?? true,
  chatPreferences: switch (json['chat_preferences']) {
    final Map<String, dynamic> chatPreferences => ChatPreferences.fromJson(chatPreferences),
    _ => null,
  },
  typingEvents: json['typing_events'] as bool? ?? false,
  uploads: json['uploads'] as bool? ?? false,
  urlEnrichment: json['url_enrichment'] as bool? ?? false,
  skipLastMsgUpdateForSystemMsgs: json['skip_last_msg_update_for_system_msgs'] as bool? ?? false,
  userMessageReminders: json['user_message_reminders'] as bool? ?? false,
  markMessagesPending: json['mark_messages_pending'] as bool? ?? false,
  deliveryEvents: json['delivery_events'] as bool? ?? false,
  sharedLocations: json['shared_locations'] as bool? ?? false,
);

/// Reads a [Member] from its v1 keys, or null when there is none.
///
/// Custom data sits at the root of the v1 map, beside the known keys. `role`
/// is not custom data and is left out.
// TODO(openapi-migration): remove when WebSocket payloads decode as v2
@internal
Member? memberFromV1Json(Map<String, dynamic>? json) => json == null ? null : _memberFromV1Json(json);

/// Reads a list of [Member]s from their v1 keys, as [memberFromV1Json] reads
/// each one.
// TODO(openapi-migration): remove when WebSocket payloads decode as v2
@internal
List<Member>? membersFromV1Json(List<dynamic>? json) =>
    json?.map((member) => _memberFromV1Json(member as Map<String, dynamic>)).toList();

Member _memberFromV1Json(Map<String, dynamic> json) {
  final data = Serializer.moveToExtraDataFromRoot(json, _memberV1Keys);
  return Member(
    user: switch (data['user']) {
      final Map<String, dynamic> user => User.fromJson(user),
      _ => null,
    },
    inviteAcceptedAt: _dateTimeOrNull(data['invite_accepted_at']),
    inviteRejectedAt: _dateTimeOrNull(data['invite_rejected_at']),
    invited: data['invited'] as bool? ?? false,
    channelRole: data['channel_role'] as String?,
    userId: data['user_id'] as String?,
    isModerator: data['is_moderator'] as bool? ?? false,
    createdAt: _dateTimeOrNull(data['created_at']),
    updatedAt: _dateTimeOrNull(data['updated_at']),
    banned: data['banned'] as bool? ?? false,
    banExpires: _dateTimeOrNull(data['ban_expires']),
    shadowBanned: data['shadow_banned'] as bool? ?? false,
    pinnedAt: _dateTimeOrNull(data['pinned_at']),
    archivedAt: _dateTimeOrNull(data['archived_at']),
    deletedMessages: (data['deleted_messages'] as List<dynamic>?)?.cast<String>() ?? const [],
    custom: data['extra_data'] as Map<String, dynamic>? ?? const {},
    notificationsMuted: data['notifications_muted'] as bool?,
    status: data['status'] as String?,
    banFromFutureChannels: data['ban_from_future_channels'] as bool?,
    futureChannelBanExpires: _dateTimeOrNull(data['future_channel_ban_expires']),
    deletedAt: _dateTimeOrNull(data['deleted_at']),
  );
}

// The keys a member's v1 map carries beside its custom data: the fields the
// API's member declares.
const _memberV1Keys = [
  'archived_at',
  'ban_expires',
  'ban_from_future_channels',
  'banned',
  'channel_role',
  'created_at',
  'deleted_at',
  'deleted_messages',
  'future_channel_ban_expires',
  'invite_accepted_at',
  'invite_rejected_at',
  'invited',
  'is_moderator',
  'notifications_muted',
  'pinned_at',
  'role',
  'shadow_banned',
  'status',
  'updated_at',
  'user',
  'user_id',
];

/// Reads a [Reaction] from its v1 keys.
///
/// Custom data sits at the root of the v1 map, beside the known keys.
// TODO(openapi-migration): remove when WebSocket payloads decode as v2
@internal
Reaction? reactionFromV1Json(Map<String, dynamic>? json) => json == null ? null : _reactionFromV1Json(json);

/// Reads a list of [Reaction]s from their v1 keys, as [reactionFromV1Json]
/// reads each one.
// TODO(openapi-migration): remove when WebSocket payloads decode as v2
@internal
List<Reaction>? reactionsFromV1Json(List<dynamic>? json) =>
    json?.map((reaction) => _reactionFromV1Json(reaction as Map<String, dynamic>)).toList();

Reaction _reactionFromV1Json(Map<String, dynamic> json) {
  final data = Serializer.moveToExtraDataFromRoot(json, _reactionV1Keys);
  return Reaction(
    messageId: data['message_id'] as String?,
    type: data['type'] as String,
    user: switch (data['user']) {
      final Map<String, dynamic> user => User.fromJson(user),
      _ => null,
    },
    userId: data['user_id'] as String?,
    score: (data['score'] as num?)?.toInt() ?? 1,
    emojiCode: data['emoji_code'] as String?,
    createdAt: switch (data['created_at']) {
      final Object it => _dateTime.fromJson(it),
      null => null,
    },
    updatedAt: switch (data['updated_at']) {
      final Object it => _dateTime.fromJson(it),
      null => null,
    },
    custom: data['extra_data'] as Map<String, dynamic>,
  );
}

// The v1 keys a reaction reads into its fields; every other key is custom data.
const _reactionV1Keys = [
  'message_id',
  'type',
  'user',
  'user_id',
  'score',
  'emoji_code',
  'created_at',
  'updated_at',
];

/// Reads a [MessageReminder] from its v1 keys.
// TODO(openapi-migration): remove when WebSocket payloads decode as v2
@internal
MessageReminder? messageReminderFromV1Json(Map<String, dynamic>? json) {
  if (json == null) return null;
  return MessageReminder(
    channelCid: json['channel_cid'] as String,
    channel: switch (json['channel']) {
      final Map<String, dynamic> channel => _channelModelFromV1Json(channel),
      _ => null,
    },
    messageId: json['message_id'] as String,
    message: switch (json['message']) {
      final Map<String, dynamic> message => Message.fromJson(message),
      _ => null,
    },
    userId: json['user_id'] as String,
    user: switch (json['user']) {
      final Map<String, dynamic> user => User.fromJson(user),
      _ => null,
    },
    remindAt: _dateTimeOrNull(json['remind_at']),
    createdAt: _dateTimeOrNull(json['created_at']),
    updatedAt: _dateTimeOrNull(json['updated_at']),
  );
}

/// Reads a [Thread] from its v1 keys, with its custom data at the root.
// TODO(openapi-migration): remove once WebSocket events decode v2 payloads
@internal
Thread? threadFromV1Json(Map<String, dynamic>? json) {
  if (json == null) return null;
  return Thread(
    activeParticipantCount: (json['active_participant_count'] as num?)?.toInt(),
    channel: switch (json['channel']) {
      final Map<String, dynamic> channel => _channelModelFromV1Json(channel),
      _ => null,
    },
    channelCid: json['channel_cid'] as String,
    parentMessageId: json['parent_message_id'] as String,
    parentMessage: switch (json['parent_message']) {
      final Map<String, dynamic> message => Message.fromJson(message),
      _ => null,
    },
    createdByUserId: json['created_by_user_id'] as String,
    createdBy: switch (json['created_by']) {
      final Map<String, dynamic> user => User.fromJson(user),
      _ => null,
    },
    replyCount: (json['reply_count'] as num).toInt(),
    participantCount: (json['participant_count'] as num).toInt(),
    threadParticipants: [
      for (final participant in json['thread_participants'] as List<dynamic>? ?? const [])
        _threadParticipantFromV1Json(participant as Map<String, dynamic>),
    ],
    lastMessageAt: _dateTimeOrNull(json['last_message_at']),
    createdAt: _dateTimeOrNull(json['created_at']),
    updatedAt: _dateTimeOrNull(json['updated_at']),
    deletedAt: _dateTimeOrNull(json['deleted_at']),
    title: json['title'] as String?,
    latestReplies: [
      for (final reply in json['latest_replies'] as List<dynamic>? ?? const [])
        Message.fromJson(reply as Map<String, dynamic>),
    ],
    read: [
      for (final read in json['read'] as List<dynamic>? ?? const []) Read.fromJson(read as Map<String, dynamic>),
    ],
    draft: switch (json['draft']) {
      final Map<String, dynamic> draft => Draft.fromJson(draft),
      _ => null,
    },
    custom: _customData(json, _threadV1Keys),
  );
}

// The keys a v1 thread carries besides its custom data.
const _threadV1Keys = [
  'active_participant_count',
  'channel_cid',
  'channel',
  'created_at',
  'updated_at',
  'deleted_at',
  'created_by_user_id',
  'created_by',
  'title',
  'parent_message_id',
  'parent_message',
  'reply_count',
  'participant_count',
  'thread_participants',
  'last_message_at',
  'latest_replies',
  'read',
  'draft',
];

ThreadParticipant _threadParticipantFromV1Json(Map<String, dynamic> json) => ThreadParticipant(
  channelCid: json['channel_cid'] as String,
  createdAt: _dateTime.fromJson(json['created_at'] as Object),
  lastReadAt: _dateTime.fromJson(json['last_read_at'] as Object),
  lastThreadMessageAt: _dateTimeOrNull(json['last_thread_message_at']),
  leftThreadAt: _dateTimeOrNull(json['left_thread_at']),
  threadId: json['thread_id'] as String?,
  userId: json['user_id'] as String?,
  user: switch (json['user']) {
    final Map<String, dynamic> user => User.fromJson(user),
    _ => null,
  },
);

/// Converts a [Device] to and from its v1 `id` and `push_provider` keys.
// TODO(openapi-migration): remove in group 09
@internal
class DeviceV1JsonConverter implements JsonConverter<Device, Map<String, dynamic>> {
  /// Creates a new [DeviceV1JsonConverter].
  const DeviceV1JsonConverter();

  // Reads the keys directly rather than through the generated device type: that type requires `user_id` and
  // `created_at`, which a device written by [toJson] does not carry.
  @override
  Device fromJson(Map<String, dynamic> json) => Device(
    id: json['id'] as String,
    pushProvider: PushProvider(json['push_provider'] as String),
  );

  @override
  Map<String, dynamic> toJson(Device device) => {
    'id': device.id,
    'push_provider': device.pushProvider,
  };
}

/// Reads the user groups a message mentions from their v1 keys.
///
/// Decode-only: [Message.mentionedGroups] is never written back to JSON.
// TODO(openapi-migration): remove in group 10
@internal
List<UserGroup>? userGroupsFromV1Json(List<dynamic>? json) {
  return json?.map((group) => _userGroupFromV1Json(group as Map<String, dynamic>)).toList();
}

/// Reads the moderation outcome of a message from its v1 keys.
///
/// Decode-only: [Message.moderation] is never written back to JSON.
// TODO(openapi-migration): remove in group 10
@internal
Moderation? moderationFromV1Json(Map<String, dynamic>? json) {
  if (json == null) return null;
  return Moderation(
    action: ModerationAction.fromJson(json['action'] as String),
    originalText: json['original_text'] as String,
    textHarms: (json['text_harms'] as List<dynamic>?)?.map((e) => e as String).toList(),
    imageHarms: (json['image_harms'] as List<dynamic>?)?.map((e) => e as String).toList(),
    blocklistMatched: json['blocklist_matched'] as String?,
    semanticFilterMatched: json['semantic_filter_matched'] as String?,
    platformCircumvented: json['platform_circumvented'] as bool? ?? false,
  );
}

/// Reads the reaction groups of a message from their v1 keys.
///
/// Decode-only: [Message.reactionGroups] is never written back to JSON.
// TODO(openapi-migration): remove in group 10
@internal
Map<String, ReactionGroup>? reactionGroupsFromV1Json(Map<String, dynamic>? json) {
  return json?.map((type, group) => MapEntry(type, _reactionGroupFromV1Json(group as Map<String, dynamic>)));
}

ReactionGroup _reactionGroupFromV1Json(Map<String, dynamic> json) => ReactionGroup(
  count: (json['count'] as num?)?.toInt() ?? 0,
  sumScores: (json['sum_scores'] as num?)?.toInt() ?? 0,
  firstReactionAt: switch (json['first_reaction_at']) {
    final Object it => _dateTime.fromJson(it),
    null => null,
  },
  lastReactionAt: switch (json['last_reaction_at']) {
    final Object it => _dateTime.fromJson(it),
    null => null,
  },
);

// Dates arrive as ISO-8601 strings on v1 and as epoch nanoseconds on v2; the converter reads both.
const _dateTime = StreamDateTimeConverter();

DateTime? _dateTimeOrNull(Object? json) => json == null ? null : _dateTime.fromJson(json);

// Reads the keys directly rather than through the generated group type, whose members require `app_pk`: a payload
// without it should not fail the whole message.
UserGroup _userGroupFromV1Json(Map<String, dynamic> json) => UserGroup(
  createdAt: _dateTime.fromJson(json['created_at'] as Object),
  createdBy: json['created_by'] as String?,
  description: json['description'] as String?,
  id: json['id'] as String,
  members: (json['members'] as List<dynamic>?)
      ?.map((member) => _userGroupMemberFromV1Json(member as Map<String, dynamic>))
      .toList(),
  name: json['name'] as String,
  teamId: json['team_id'] as String?,
  updatedAt: _dateTime.fromJson(json['updated_at'] as Object),
);

UserGroupMember _userGroupMemberFromV1Json(Map<String, dynamic> json) => UserGroupMember(
  createdAt: _dateTime.fromJson(json['created_at'] as Object),
  groupId: json['group_id'] as String,
  isAdmin: json['is_admin'] as bool,
  userId: json['user_id'] as String,
);

/// Reads a [Poll] from its v1 keys.
///
/// Custom data sits at the root of the v1 map, beside the known keys.
// TODO(openapi-migration): remove once events and messages decode v2 payloads
@internal
Poll? pollFromV1Json(Map<String, dynamic>? json) {
  if (json == null) return null;
  return Poll(
    id: json['id'] as String?,
    name: json['name'] as String,
    nameI18n: _translations(json['name_i18n']),
    description: json['description'] as String?,
    descriptionI18n: _translations(json['description_i18n']),
    options: (json['options'] as List<dynamic>)
        .map((option) => _pollOptionFromV1Json(option as Map<String, dynamic>))
        .toList(),
    votingVisibility: switch (json['voting_visibility']) {
      final String value => VotingVisibility(value),
      _ => VotingVisibility.public,
    },
    enforceUniqueVote: json['enforce_unique_vote'] as bool? ?? true,
    maxVotesAllowed: (json['max_votes_allowed'] as num?)?.toInt(),
    allowAnswers: json['allow_answers'] as bool? ?? false,
    latestAnswers: _pollVotesFromV1Json(json['latest_answers']) ?? const [],
    answersCount: (json['answers_count'] as num?)?.toInt() ?? 0,
    allowUserSuggestedOptions: json['allow_user_suggested_options'] as bool? ?? false,
    isClosed: json['is_closed'] as bool? ?? false,
    createdAt: _optionalDateTime(json['created_at']),
    updatedAt: _optionalDateTime(json['updated_at']),
    voteCountsByOption:
        (json['vote_counts_by_option'] as Map<String, dynamic>?)?.map(
          (optionId, count) => MapEntry(optionId, (count as num).toInt()),
        ) ??
        const {},
    voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
    latestVotesByOption:
        (json['latest_votes_by_option'] as Map<String, dynamic>?)?.map(
          (optionId, votes) => MapEntry(optionId, _pollVotesFromV1Json(votes)!),
        ) ??
        const {},
    createdById: json['created_by_id'] as String?,
    createdBy: switch (json['created_by']) {
      final Map<String, dynamic> user => User.fromJson(user),
      _ => null,
    },
    ownVotesAndAnswers: _pollVotesFromV1Json(json['own_votes']) ?? const [],
    custom: _customData(json, _pollV1Keys),
  );
}

/// Reads a [PollVote] from its v1 keys.
// TODO(openapi-migration): remove once WebSocket events decode v2 payloads
@internal
PollVote? pollVoteFromV1Json(Map<String, dynamic>? json) => json == null ? null : _pollVoteFromV1Json(json);

PollOption _pollOptionFromV1Json(Map<String, dynamic> json) => PollOption(
  id: json['id'] as String?,
  text: json['text'] as String,
  textI18n: _translations(json['text_i18n']),
  custom: _customData(json, _pollOptionV1Keys),
);

List<PollVote>? _pollVotesFromV1Json(Object? json) =>
    (json as List<dynamic>?)?.map((vote) => _pollVoteFromV1Json(vote as Map<String, dynamic>)).toList();

PollVote _pollVoteFromV1Json(Map<String, dynamic> json) => PollVote(
  id: json['id'] as String?,
  pollId: json['poll_id'] as String?,
  optionId: json['option_id'] as String?,
  answerText: json['answer_text'] as String?,
  answerTextI18n: _translations(json['answer_text_i18n']),
  createdAt: _optionalDateTime(json['created_at']),
  updatedAt: _optionalDateTime(json['updated_at']),
  userId: json['user_id'] as String?,
  user: switch (json['user']) {
    final Map<String, dynamic> user => User.fromJson(user),
    _ => null,
  },
);

Map<String, String>? _translations(Object? json) => switch (json) {
  final Map<String, dynamic> translations => Map<String, String>.from(translations),
  _ => null,
};

DateTime? _optionalDateTime(Object? json) => json == null ? null : _dateTime.fromJson(json);

// The keys a v1 poll carries besides its custom data.
const _pollV1Keys = [
  'id',
  'name',
  'name_i18n',
  'description',
  'description_i18n',
  'options',
  'voting_visibility',
  'enforce_unique_vote',
  'max_votes_allowed',
  'allow_user_suggested_options',
  'allow_answers',
  'is_closed',
  'created_at',
  'updated_at',
  'vote_counts_by_option',
  'votes',
  'own_votes',
  'vote_count',
  'answers_count',
  'latest_votes_by_option',
  'latest_answers',
  'created_by_id',
  'created_by',
];

// The keys a v1 poll option carries besides its custom data.
const _pollOptionV1Keys = [
  'id',
  'text',
  'text_i18n',
];

Map<String, Object?> _customData(Map<String, dynamic> json, List<String> knownKeys) =>
    Serializer.moveToExtraDataFromRoot(json, knownKeys)['extra_data'] as Map<String, Object?>;
