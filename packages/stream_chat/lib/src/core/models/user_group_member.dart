import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_group_member.g.dart';

/// Class that defines a member of a user group.
@JsonSerializable(createToJson: false)
class UserGroupMember extends Equatable {
  /// Create a new instance of [UserGroupMember].
  const UserGroupMember({
    required this.createdAt,
    required this.groupId,
    required this.isAdmin,
    required this.userId,
  });

  /// Create a new instance from a json.
  factory UserGroupMember.fromJson(Map<String, dynamic> json) => _$UserGroupMemberFromJson(json);

  /// The date when the member was added to the group.
  final DateTime createdAt;

  /// The id of the group the member belongs to.
  final String groupId;

  /// Whether the member is an admin of the group.
  final bool isAdmin;

  /// The id of the member.
  final String userId;

  @override
  List<Object?> get props => [
    createdAt,
    groupId,
    isAdmin,
    userId,
  ];
}
