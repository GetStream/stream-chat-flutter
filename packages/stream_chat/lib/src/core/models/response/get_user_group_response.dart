import 'package:freezed_annotation/freezed_annotation.dart';

import '../user_group.dart';

part 'get_user_group_response.freezed.dart';

/// The result of looking up a single user group.
@freezed
class GetUserGroupResponse with _$GetUserGroupResponse {
  /// Creates a new [GetUserGroupResponse].
  const GetUserGroupResponse({
    required this.duration,
    this.userGroup,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The fetched user group.
  @override
  final UserGroup? userGroup;
}
