import 'package:freezed_annotation/freezed_annotation.dart';

import '../user_group.dart';

part 'search_user_groups_response.freezed.dart';

/// The user groups matching a search, returned by [StreamChatClient.searchUserGroups].
@freezed
class SearchUserGroupsResponse with _$SearchUserGroupsResponse {
  /// Creates a new [SearchUserGroupsResponse].
  const SearchUserGroupsResponse({
    required this.duration,
    this.userGroups = const [],
  });

  /// How long the server took to handle the request, such as `4.21ms`.
  @override
  final String duration;

  /// The user groups matching the search.
  @override
  final List<UserGroup> userGroups;
}
