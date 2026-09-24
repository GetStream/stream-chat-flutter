import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_group_member.dart';

part 'user_group.freezed.dart';

/// A named group of users that can be mentioned together in a message.
@freezed
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
}
