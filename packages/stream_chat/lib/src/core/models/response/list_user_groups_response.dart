import 'package:freezed_annotation/freezed_annotation.dart';

import '../user_group.dart';

part 'list_user_groups_response.freezed.dart';

/// The user groups of the app, returned by [StreamChatClient.listUserGroups].
@freezed
class ListUserGroupsResponse with _$ListUserGroupsResponse {
  /// Creates a new [ListUserGroupsResponse].
  const ListUserGroupsResponse({
    required this.duration,
    this.userGroups = const [],
  });

  /// How long the server took to handle the request, such as `4.21ms`.
  @override
  final String duration;

  /// The user groups on this page.
  @override
  final List<UserGroup> userGroups;
}
