import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';

/// Defines the API dedicated to user groups operations.
class UserGroupsApi {
  /// Initialize a new user groups API.
  const UserGroupsApi(this._client);

  final StreamHttpClient _client;

  /// Lists user groups with cursor-based pagination.
  Future<ListUserGroupsResponse> listUserGroups({
    int? limit,
    String? idGt,
    DateTime? createdAtGt,
    String? teamId,
  }) async {
    final response = await _client.get(
      '/usergroups',
      queryParameters: {
        if (limit != null) 'limit': limit,
        if (idGt != null) 'id_gt': idGt,
        if (createdAtGt != null) 'created_at_gt': createdAtGt.toUtc().toIso8601String(),
        if (teamId != null) 'team_id': teamId,
      },
    );
    return ListUserGroupsResponse.fromJson(response.data);
  }

  /// Searches user groups by name prefix (autocomplete).
  Future<SearchUserGroupsResponse> searchUserGroups(
    String query, {
    int? limit,
    String? nameGt,
    String? idGt,
    String? teamId,
  }) async {
    final response = await _client.get(
      '/usergroups/search',
      queryParameters: {
        'query': query,
        if (limit != null) 'limit': limit,
        if (nameGt != null) 'name_gt': nameGt,
        if (idGt != null) 'id_gt': idGt,
        if (teamId != null) 'team_id': teamId,
      },
    );
    return SearchUserGroupsResponse.fromJson(response.data);
  }

  /// Gets a user group by ID, including its members.
  Future<GetUserGroupResponse> getUserGroup(
    String id, {
    String? teamId,
  }) async {
    final response = await _client.get(
      '/usergroups/$id',
      queryParameters: {
        if (teamId != null) 'team_id': teamId,
      },
    );
    return GetUserGroupResponse.fromJson(response.data);
  }

  /// Creates a new user group, optionally with initial members.
  Future<CreateUserGroupResponse> createUserGroup(
    String name, {
    String? id,
    String? description,
    String? teamId,
    List<String>? memberIds,
  }) async {
    final response = await _client.post(
      '/usergroups',
      data: {
        'name': name,
        if (id != null) 'id': id,
        if (description != null) 'description': description,
        if (teamId != null) 'team_id': teamId,
        if (memberIds != null) 'member_ids': memberIds,
      },
    );
    return CreateUserGroupResponse.fromJson(response.data);
  }

  /// Updates a user group's name and/or description.
  ///
  /// At least one of [name] / [description] must be provided. Passing
  /// `description: ''` clears the description; passing `null` (or omitting)
  /// leaves it unchanged.
  ///
  /// [teamId] scopes the lookup; a group's team cannot be changed.
  Future<UpdateUserGroupResponse> updateUserGroup(
    String id, {
    String? name,
    String? description,
    String? teamId,
  }) async {
    final response = await _client.put(
      '/usergroups/$id',
      data: {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (teamId != null) 'team_id': teamId,
      },
    );
    return UpdateUserGroupResponse.fromJson(response.data);
  }

  /// Deletes a user group and all its memberships.
  Future<EmptyResponse> deleteUserGroup(
    String id, {
    String? teamId,
  }) async {
    final response = await _client.delete(
      '/usergroups/$id',
      queryParameters: {
        if (teamId != null) 'team_id': teamId,
      },
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Adds members to a user group. All user IDs must exist
  /// (operation is all-or-nothing).
  ///
  /// [asAdmin] is omitted from the request when null; the server defaults
  /// to `false` (regular member).
  Future<AddUserGroupMembersResponse> addUserGroupMembers(
    String id,
    List<String> memberIds, {
    bool? asAdmin,
    String? teamId,
  }) async {
    final response = await _client.post(
      '/usergroups/$id/members',
      data: {
        'member_ids': memberIds,
        if (asAdmin != null) 'as_admin': asAdmin,
        if (teamId != null) 'team_id': teamId,
      },
    );
    return AddUserGroupMembersResponse.fromJson(response.data);
  }

  /// Removes members from a user group. User IDs not currently members
  /// are silently ignored.
  Future<RemoveUserGroupMembersResponse> removeUserGroupMembers(
    String id,
    List<String> memberIds, {
    String? teamId,
  }) async {
    final response = await _client.post(
      '/usergroups/$id/members/delete',
      data: {
        'member_ids': memberIds,
        if (teamId != null) 'team_id': teamId,
      },
    );
    return RemoveUserGroupMembersResponse.fromJson(response.data);
  }
}
