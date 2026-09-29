import 'package:freezed_annotation/freezed_annotation.dart';

import '../user_group.dart';

part 'remove_user_group_members_response.freezed.dart';

/// A user group after members were removed from it.
@freezed
class RemoveUserGroupMembersResponse with _$RemoveUserGroupMembersResponse {
  /// Creates a new [RemoveUserGroupMembersResponse].
  const RemoveUserGroupMembersResponse({
    required this.duration,
    this.userGroup,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The user group, without the removed members.
  @override
  final UserGroup? userGroup;
}
