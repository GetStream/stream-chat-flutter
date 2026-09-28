import '../../../open_api/api.dart' as api;
import '../../core/models/response/add_user_group_members_response.dart';
import '../../core/models/response/create_user_group_response.dart';
import '../../core/models/response/get_user_group_response.dart';
import '../../core/models/response/list_user_groups_response.dart';
import '../../core/models/response/remove_user_group_members_response.dart';
import '../../core/models/response/search_user_groups_response.dart';
import '../../core/models/response/update_user_group_response.dart';
import '../../core/models/user_group.dart';
import '../../core/models/user_group_member.dart';

/// Maps a generated [api.UserGroupResponse] to a [UserGroup].
extension UserGroupResponseMapper on api.UserGroupResponse {
  /// Converts this response into a [UserGroup].
  ///
  /// [UserGroup.members] stays `null` when the response leaves the members out.
  UserGroup toModel() => UserGroup(
    createdAt: createdAt,
    createdBy: createdBy,
    description: description,
    id: id,
    members: members?.map((member) => member.toModel()).toList(),
    name: name,
    teamId: teamId,
    updatedAt: updatedAt,
  );
}

/// Maps a generated [api.UserGroupMember] to a [UserGroupMember].
extension UserGroupMemberMapper on api.UserGroupMember {
  /// Converts this generated member into a [UserGroupMember].
  UserGroupMember toModel() => UserGroupMember(
    createdAt: createdAt,
    groupId: groupId,
    isAdmin: isAdmin,
    userId: userId,
  );
}

/// Maps a generated [api.ListUserGroupsResponse] to a [ListUserGroupsResponse].
extension ListUserGroupsResponseMapper on api.ListUserGroupsResponse {
  /// Converts this response into a [ListUserGroupsResponse].
  ListUserGroupsResponse toModel() => ListUserGroupsResponse(
    duration: duration,
    userGroups: [for (final userGroup in userGroups) userGroup.toModel()],
  );
}

/// Maps a generated [api.SearchUserGroupsResponse] to a [SearchUserGroupsResponse].
extension SearchUserGroupsResponseMapper on api.SearchUserGroupsResponse {
  /// Converts this response into a [SearchUserGroupsResponse].
  SearchUserGroupsResponse toModel() => SearchUserGroupsResponse(
    duration: duration,
    userGroups: [for (final userGroup in userGroups) userGroup.toModel()],
  );
}

/// Maps a generated [api.GetUserGroupResponse] to a [GetUserGroupResponse].
extension GetUserGroupResponseMapper on api.GetUserGroupResponse {
  /// Converts this response into a [GetUserGroupResponse].
  GetUserGroupResponse toModel() => GetUserGroupResponse(
    duration: duration,
    userGroup: userGroup?.toModel(),
  );
}

/// Maps a generated [api.CreateUserGroupResponse] to a [CreateUserGroupResponse].
extension CreateUserGroupResponseMapper on api.CreateUserGroupResponse {
  /// Converts this response into a [CreateUserGroupResponse].
  CreateUserGroupResponse toModel() => CreateUserGroupResponse(
    duration: duration,
    userGroup: userGroup?.toModel(),
  );
}

/// Maps a generated [api.UpdateUserGroupResponse] to an [UpdateUserGroupResponse].
extension UpdateUserGroupResponseMapper on api.UpdateUserGroupResponse {
  /// Converts this response into an [UpdateUserGroupResponse].
  UpdateUserGroupResponse toModel() => UpdateUserGroupResponse(
    duration: duration,
    userGroup: userGroup?.toModel(),
  );
}

/// Maps a generated [api.AddUserGroupMembersResponse] to an [AddUserGroupMembersResponse].
extension AddUserGroupMembersResponseMapper on api.AddUserGroupMembersResponse {
  /// Converts this response into an [AddUserGroupMembersResponse].
  AddUserGroupMembersResponse toModel() => AddUserGroupMembersResponse(
    duration: duration,
    userGroup: userGroup?.toModel(),
  );
}

/// Maps a generated [api.RemoveUserGroupMembersResponse] to a [RemoveUserGroupMembersResponse].
extension RemoveUserGroupMembersResponseMapper on api.RemoveUserGroupMembersResponse {
  /// Converts this response into a [RemoveUserGroupMembersResponse].
  RemoveUserGroupMembersResponse toModel() => RemoveUserGroupMembersResponse(
    duration: duration,
    userGroup: userGroup?.toModel(),
  );
}
