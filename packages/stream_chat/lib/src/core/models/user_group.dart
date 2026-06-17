import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/user_group_member.dart';

part 'user_group.g.dart';

/// Class that defines a user group.
@JsonSerializable(includeIfNull: false)
class UserGroup extends Equatable {
  /// Create a new instance of [UserGroup].
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

  /// Create a new instance from a json.
  factory UserGroup.fromJson(Map<String, dynamic> json) => _$UserGroupFromJson(json);

  /// The date when the group was created.
  final DateTime createdAt;

  /// The id of the user that created the group
  /// (null when group is created server-side).
  final String? createdBy;

  /// The description of the group (optional).
  final String? description;

  /// The unique identifier of the group.
  final String id;

  /// The members of the group (null when listing/searching user groups).
  final List<UserGroupMember>? members;

  /// The name of the group.
  final String name;

  /// The id of the team the group belongs to (null if no team).
  final String? teamId;

  /// The date when the group was last updated.
  final DateTime updatedAt;

  /// Serialize model to json.
  Map<String, dynamic> toJson() => _$UserGroupToJson(this);

  @override
  List<Object?> get props => [
    createdAt,
    createdBy,
    description,
    id,
    members,
    name,
    teamId,
    updatedAt,
  ];
}
