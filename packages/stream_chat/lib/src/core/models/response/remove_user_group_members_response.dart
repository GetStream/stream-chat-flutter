import 'package:freezed_annotation/freezed_annotation.dart';

import '../user_group.dart';

part 'remove_user_group_members_response.freezed.dart';

/// The user group returned by [StreamChatClient.removeUserGroupMembers].
@freezed
class RemoveUserGroupMembersResponse with _$RemoveUserGroupMembersResponse {
  /// Creates a new [RemoveUserGroupMembersResponse].
  const RemoveUserGroupMembersResponse({
    required this.duration,
    this.userGroup,
  });

  /// How long the server took to handle the request, such as `4.21ms`.
  @override
  final String duration;

  /// The user group, without the removed members.
  @override
  final UserGroup? userGroup;
}
