import 'dart:convert';

import 'package:stream_chat/src/core/api/requests.dart';
import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_chat/src/core/models/filter.dart';
import 'package:stream_chat/src/core/models/user.dart';

/// Defines the api dedicated to users operations
class UserApi {
  /// Initialize a new user api
  UserApi(this._client);

  final StreamHttpClient _client;

  /// Requests users with a given query.
  Future<QueryUsersResponse> queryUsers({
    bool presence = false,
    Filter? filter,
    List<SortOption>? sort,
    PaginationParams? pagination,
  }) async {
    final response = await _client.get(
      '/users',
      queryParameters: {
        'payload': jsonEncode({
          'presence': presence,
          if (sort != null) 'sort': sort,
          if (filter != null) 'filter_conditions': filter,
          if (pagination != null) ...pagination.toJson(),
        }),
      },
    );
    return QueryUsersResponse.fromJson(response.data);
  }

  /// Batch update a list of users
  Future<UpdateUsersResponse> updateUsers(
    List<User> users,
  ) async {
    final response = await _client.post(
      '/users',
      data: {
        'users': {for (final user in users) user.id: user},
      },
    );
    return UpdateUsersResponse.fromJson(response.data);
  }

  /// Batch partial update of [users].
  Future<UpdateUsersResponse> partialUpdateUsers(
    List<PartialUpdateUserRequest> users,
  ) async {
    final response = await _client.patch(
      '/users',
      data: {
        'users': users,
      },
    );
    return UpdateUsersResponse.fromJson(response.data);
  }

  /// Blocks a user
  Future<UserBlockResponse> blockUser(String userId) async {
    final response = await _client.post(
      '/users/block',
      data: {'blocked_user_id': userId},
    );

    return UserBlockResponse.fromJson(response.data);
  }

  /// Unblocks a user
  Future<EmptyResponse> unblockUser(String userId) async {
    final response = await _client.post(
      '/users/unblock',
      data: {'blocked_user_id': userId},
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Requests blocked users.
  Future<BlockedUsersResponse> queryBlockedUsers() async {
    final response = await _client.get(
      '/users/block',
    );

    return BlockedUsersResponse.fromJson(response.data);
  }
}
