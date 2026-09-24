import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_group_member.freezed.dart';

/// A user's membership in a [UserGroup].
@freezed
class UserGroupMember with _$UserGroupMember {
  /// Creates a new [UserGroupMember].
  const UserGroupMember({
    required this.createdAt,
    required this.groupId,
    required this.isAdmin,
    required this.userId,
  });

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
}
