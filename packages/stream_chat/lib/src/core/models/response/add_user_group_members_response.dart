import 'package:freezed_annotation/freezed_annotation.dart';

import '../user_group.dart';

part 'add_user_group_members_response.freezed.dart';

/// A user group after members were added to it.
@freezed
class AddUserGroupMembersResponse with _$AddUserGroupMembersResponse {
  /// Creates a new [AddUserGroupMembersResponse].
  const AddUserGroupMembersResponse({
    required this.duration,
    this.userGroup,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The user group, with the added members.
  @override
  final UserGroup? userGroup;
}
