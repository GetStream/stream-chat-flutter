import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart' show StreamDateTimeConverter;

import '../../util/serializer.dart';
import '../action.dart';
import '../device.dart';
import '../moderation.dart';
import '../push_provider.dart';
import '../reaction.dart';
import '../reaction_group.dart';
import '../user.dart';
import '../user_group.dart';
import '../user_group_member.dart';

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

/// Converts a [Reaction] to and from its v1 keys.
///
/// Custom data sits at the root of the v1 map, beside the known keys. [toJson] writes the request shape: the type,
/// score, emoji code and custom data, without the message, user or dates.
// TODO(openapi-migration): remove in group 10
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
