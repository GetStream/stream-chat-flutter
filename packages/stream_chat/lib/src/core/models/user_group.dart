import 'package:freezed_annotation/freezed_annotation.dart';

import '../../db/data_serializable.dart';
import 'user_group_member.dart';

part 'user_group.freezed.dart';
part 'user_group.g.dart';

/// A named group of users that can be mentioned together in a message.
@freezed
// TODO(openapi-migration): remove in group 10
@DataSerializable(includeIfNull: false)
class UserGroup with _$UserGroup {
  /// Creates a new [UserGroup].
  const UserGroup({
    required this.createdAt,
    this.createdBy,
    this.description,
    required this.id,
    this.members,
    required this.name,
    this.teamId,
    required this.updatedAt,
  });

  /// Creates a [UserGroup] from the offline-database format written by [toData].
  ///
  /// It is not a codec for API payloads.
  factory UserGroup.fromData(Map<String, dynamic> json) => _$UserGroupFromJson(json);

  /// The date when the group was created.
  @override
  final DateTime createdAt;

  /// The id of the user that created the group
  /// (null when group is created server-side).
  @override
  final String? createdBy;

  /// The description of the group (optional).
  @override
  final String? description;

  /// The unique identifier of the group.
  @override
  final String id;

  /// The members of the group (null when listing/searching user groups).
  @override
  @JsonKey(fromJson: _membersFromData, toJson: _membersToData)
  final List<UserGroupMember>? members;

  /// The name of the group.
  @override
  final String name;

  /// The id of the team the group belongs to (null if no team).
  @override
  final String? teamId;

  /// The date when the group was last updated.
  @override
  final DateTime updatedAt;

  /// Serializes this group to the format `stream_chat_persistence` stores.
  ///
  /// It is not a codec for API payloads.
  Map<String, dynamic> toData() => _$UserGroupToJson(this);
}

List<UserGroupMember>? _membersFromData(List<dynamic>? data) =>
    data?.map((it) => UserGroupMember.fromData(it as Map<String, dynamic>)).toList();

List<Map<String, dynamic>>? _membersToData(List<UserGroupMember>? members) =>
    members?.map((it) => it.toData()).toList();
