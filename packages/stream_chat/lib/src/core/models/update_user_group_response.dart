import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_group.dart';

part 'update_user_group_response.freezed.dart';

/// The user group updated by [StreamChatClient.updateUserGroup].
@freezed
class UpdateUserGroupResponse with _$UpdateUserGroupResponse {
  /// Creates a new [UpdateUserGroupResponse].
  const UpdateUserGroupResponse({
    required this.duration,
    this.userGroup,
  });

  /// How long the server took to handle the request, such as `4.21ms`.
  @override
  final String duration;

  /// The updated user group.
  @override
  final UserGroup? userGroup;
}
