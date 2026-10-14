import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart' show StreamDateTimeConverter;

import '../device.dart';
import '../push_provider.dart';
import '../user_group.dart';
import '../user_group_member.dart';

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
