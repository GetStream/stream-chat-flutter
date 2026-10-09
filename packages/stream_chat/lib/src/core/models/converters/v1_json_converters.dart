import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart' show StreamDateTimeConverter;

import '../../util/serializer.dart';
import '../action.dart';
import '../channel_model.dart';
import '../device.dart';
import '../draft.dart';
import '../location.dart';
import '../message.dart';
import '../message_reminder.dart';
import '../moderation.dart';
import '../poll.dart';
import '../poll_option.dart';
import '../poll_vote.dart';
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

  // Writes `value` even when it is null, as v10 did, so sent attachments and the stored ones keep their format.
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
/// [toJson] writes the request shape: the coordinates, the device and the end date, without the channel, message,
/// user or the other dates.
// TODO(openapi-migration): remove in group 10
@internal
class LocationV1JsonConverter implements JsonConverter<Location, Map<String, dynamic>> {
  /// Creates a new [LocationV1JsonConverter].
  const LocationV1JsonConverter();

  @override
  Location fromJson(Map<String, dynamic> json) => Location(
    channelCid: json['channel_cid'] as String?,
    channel: switch (json['channel']) {
      final Map<String, dynamic> channel => ChannelModel.fromJson(channel),
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

/// Converts a [Reaction] to and from its v1 keys.
///
/// Custom data sits at the root of the v1 map, beside the known keys. [toJson] writes the request shape: the type,
/// score, emoji code and custom data, without the message, user or dates.
// TODO(openapi-migration): remove once WebSocket events and messages decode v2 payloads
@internal
class ReactionV1JsonConverter implements JsonConverter<Reaction, Map<String, dynamic>> {
  /// Creates a new [ReactionV1JsonConverter].
  const ReactionV1JsonConverter();

  @override
  Reaction fromJson(Map<String, dynamic> json) {
    final data = Serializer.moveToExtraDataFromRoot(json, Reaction.topLevelFields);
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
      extraData: data['extra_data'] as Map<String, dynamic>,
    );
  }

  @override
  Map<String, dynamic> toJson(Reaction reaction) => Serializer.moveFromExtraDataToRoot({
    'type': reaction.type,
    'score': reaction.score,
    if (reaction.emojiCode case final emojiCode?) 'emoji_code': emojiCode,
    'extra_data': reaction.extraData,
  });
}

/// Converts a [MessageReminder] to and from its v1 keys.
///
/// [toJson] writes the ids and the dates, without the channel, message or user.
// TODO(openapi-migration): remove once WebSocket events and messages decode v2 payloads
@internal
class MessageReminderV1JsonConverter implements JsonConverter<MessageReminder, Map<String, dynamic>> {
  /// Creates a new [MessageReminderV1JsonConverter].
  const MessageReminderV1JsonConverter();

  @override
  MessageReminder fromJson(Map<String, dynamic> json) => MessageReminder(
    channelCid: json['channel_cid'] as String,
    channel: switch (json['channel']) {
      final Map<String, dynamic> channel => ChannelModel.fromJson(channel),
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

  @override
  Map<String, dynamic> toJson(MessageReminder reminder) => {
    'channel_cid': reminder.channelCid,
    'message_id': reminder.messageId,
    'user_id': reminder.userId,
    'remind_at': reminder.remindAt?.toIso8601String(),
    'created_at': reminder.createdAt.toIso8601String(),
    'updated_at': reminder.updatedAt.toIso8601String(),
  };
}

/// Converts a [Thread] to and from its v1 keys, with its custom data at the root.
// TODO(openapi-migration): remove once WebSocket events decode v2 payloads
@internal
class ThreadV1JsonConverter implements JsonConverter<Thread, Map<String, dynamic>> {
  /// Creates a new [ThreadV1JsonConverter].
  const ThreadV1JsonConverter();

  @override
  Thread fromJson(Map<String, dynamic> json) => Thread(
    activeParticipantCount: (json['active_participant_count'] as num?)?.toInt(),
    channel: switch (json['channel']) {
      final Map<String, dynamic> channel => ChannelModel.fromJson(channel),
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
    extraData: {
      for (final MapEntry(:key, :value) in json.entries)
        if (!Thread.topLevelFields.contains(key)) key: value,
    },
  );

  @override
  Map<String, dynamic> toJson(Thread thread) => {
    'active_participant_count': thread.activeParticipantCount,
    'channel_cid': thread.channelCid,
    'channel': thread.channel?.toJson(),
    'created_at': thread.createdAt.toIso8601String(),
    'updated_at': thread.updatedAt.toIso8601String(),
    'deleted_at': thread.deletedAt?.toIso8601String(),
    'created_by_user_id': thread.createdByUserId,
    'created_by': thread.createdBy?.toJson(),
    'title': thread.title,
    'parent_message_id': thread.parentMessageId,
    'parent_message': thread.parentMessage?.toJson(),
    'reply_count': thread.replyCount,
    'participant_count': thread.participantCount,
    'thread_participants': [
      for (final participant in thread.threadParticipants) _threadParticipantToV1Json(participant),
    ],
    'last_message_at': thread.lastMessageAt?.toIso8601String(),
    'latest_replies': [for (final reply in thread.latestReplies) reply.toJson()],
    'read': thread.read?.map((read) => read.toJson()).toList(),
    'draft': thread.draft?.toJson(),
    ...thread.extraData,
  };
}

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

Map<String, dynamic> _threadParticipantToV1Json(ThreadParticipant participant) => {
  'channel_cid': participant.channelCid,
  'created_at': participant.createdAt.toIso8601String(),
  'last_read_at': participant.lastReadAt.toIso8601String(),
  'last_thread_message_at': participant.lastThreadMessageAt?.toIso8601String(),
  'left_thread_at': participant.leftThreadAt?.toIso8601String(),
  'thread_id': participant.threadId,
  'user_id': participant.userId,
  'user': participant.user?.toJson(),
};

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
    textHarms: (json['text_harms'] as List<dynamic>?)?.cast<String>(),
    imageHarms: (json['image_harms'] as List<dynamic>?)?.cast<String>(),
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

/// Converts a [Poll] to and from its v1 keys.
///
/// Custom data sits at the root of the v1 map, beside the known keys.
// TODO(openapi-migration): remove once WebSocket events and messages decode v2 payloads
@internal
class PollV1JsonConverter implements JsonConverter<Poll, Map<String, dynamic>> {
  /// Creates a new [PollV1JsonConverter].
  const PollV1JsonConverter();

  @override
  Poll fromJson(Map<String, dynamic> json) => Poll(
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
    extraData: _customData(json, Poll.topLevelFields),
  );

  // Writes the keys the poll settings use, with custom data at the root; the vote summary and the server's
  // translations are not written.
  @override
  Map<String, dynamic> toJson(Poll poll) => {
    ...poll.extraData,
    'id': poll.id,
    'name': poll.name,
    'description': poll.description,
    'options': poll.options.map(_pollOptionToV1Json).toList(),
    'voting_visibility': poll.votingVisibility.rawType,
    'enforce_unique_vote': poll.enforceUniqueVote,
    'max_votes_allowed': poll.maxVotesAllowed,
    'allow_user_suggested_options': poll.allowUserSuggestedOptions,
    'allow_answers': poll.allowAnswers,
    'is_closed': poll.isClosed,
  };
}

/// Converts a [PollVote] to and from its v1 keys.
// TODO(openapi-migration): remove once WebSocket events decode v2 payloads
@internal
class PollVoteV1JsonConverter implements JsonConverter<PollVote, Map<String, dynamic>> {
  /// Creates a new [PollVoteV1JsonConverter].
  const PollVoteV1JsonConverter();

  @override
  PollVote fromJson(Map<String, dynamic> json) => _pollVoteFromV1Json(json);

  // Writes only the keys that identify the vote and what it selects.
  @override
  Map<String, dynamic> toJson(PollVote vote) => {
    'id': ?vote.id,
    'option_id': ?vote.optionId,
    'answer_text': ?vote.answerText,
  };
}

PollOption _pollOptionFromV1Json(Map<String, dynamic> json) => PollOption(
  id: json['id'] as String?,
  text: json['text'] as String,
  textI18n: _translations(json['text_i18n']),
  extraData: _customData(json, PollOption.topLevelFields),
);

Map<String, dynamic> _pollOptionToV1Json(PollOption option) => {
  ...option.extraData,
  'id': ?option.id,
  'text': option.text,
};

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

Map<String, Object?> _customData(Map<String, dynamic> json, List<String> topLevelFields) =>
    Serializer.moveToExtraDataFromRoot(json, topLevelFields)['extra_data'] as Map<String, Object?>;
