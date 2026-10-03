import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart' show StreamDateTimeConverter;

import '../../util/serializer.dart';
import '../device.dart';
import '../poll.dart';
import '../poll_option.dart';
import '../poll_vote.dart';
import '../push_provider.dart';
import '../user.dart';
import '../user_group.dart';
import '../user_group_member.dart';
import '../voting_visibility.dart';

// Converters for plain models embedded in json_serializable models that still decode v1 JSON. Each one is deleted
// by the migration group that turns its parent into a plain model.

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

// Dates arrive as ISO-8601 strings on v1 and as epoch nanoseconds on v2; the converter reads both.
const _dateTime = StreamDateTimeConverter();

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
    description: json['description'] as String?,
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

  // Writes the keys the poll settings use, with custom data at the root; the vote summary is not written.
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
  createdAt: _optionalDateTime(json['created_at']),
  updatedAt: _optionalDateTime(json['updated_at']),
  userId: json['user_id'] as String?,
  user: switch (json['user']) {
    final Map<String, dynamic> user => User.fromJson(user),
    _ => null,
  },
);

DateTime? _optionalDateTime(Object? json) => json == null ? null : _dateTime.fromJson(json);

Map<String, Object?> _customData(Map<String, dynamic> json, List<String> topLevelFields) =>
    Serializer.moveToExtraDataFromRoot(json, topLevelFields)['extra_data'] as Map<String, Object?>;
