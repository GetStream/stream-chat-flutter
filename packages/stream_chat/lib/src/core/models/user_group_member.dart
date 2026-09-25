import 'package:freezed_annotation/freezed_annotation.dart';

import '../../db/data_serializable.dart';

part 'user_group_member.freezed.dart';
part 'user_group_member.g.dart';

/// A user's membership in a [UserGroup].
@freezed
// TODO(openapi-migration): remove in group 10
@DataSerializable(includeIfNull: false)
class UserGroupMember with _$UserGroupMember {
  /// Creates a new [UserGroupMember].
  const UserGroupMember({
    required this.createdAt,
    required this.groupId,
    required this.isAdmin,
    required this.userId,
  });

  /// Creates a [UserGroupMember] from data stored by [toData].
  factory UserGroupMember.fromData(Map<String, dynamic> json) => _$UserGroupMemberFromJson(json);

  /// The date when the member was added to the group.
  @override
  final DateTime createdAt;

  /// The id of the group the member belongs to.
  @override
  final String groupId;

  /// Whether the member is an admin of the group.
  @override
  final bool isAdmin;

  /// The id of the member.
  @override
  final String userId;

  /// Serializes this member for local storage.
  Map<String, dynamic> toData() => _$UserGroupMemberToJson(this);
}
