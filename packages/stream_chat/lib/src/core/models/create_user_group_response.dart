import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_group.dart';

part 'create_user_group_response.freezed.dart';

/// The user group created by [StreamChatClient.createUserGroup].
@freezed
class CreateUserGroupResponse with _$CreateUserGroupResponse {
  /// Creates a new [CreateUserGroupResponse].
  const CreateUserGroupResponse({
    required this.duration,
    this.userGroup,
  });

  /// How long the server took to handle the request, such as `4.21ms`.
  @override
  final String duration;

  /// The created user group.
  @override
  final UserGroup? userGroup;
}
