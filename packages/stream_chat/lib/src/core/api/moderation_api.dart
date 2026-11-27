import 'dart:convert';

import '../../../stream_chat.dart';

/// Defines the api dedicated to moderation operations
class ModerationApi {
  /// Initialize a new moderation api
  ModerationApi(this._client);

  final StreamHttpClient _client;

  /// Queries banned users.
  Future<QueryBannedUsersResponse> queryBannedUsers({
    BannedUserFilter? filter,
    List<BannedUserSort>? sort,
    PaginationParams? pagination,
  }) async {
    final response = await _client.get(
      '/query_banned_users',
      queryParameters: {
        'payload': jsonEncode({
          if (sort != null) 'sort': sort,
          // Sent even when empty, as in `queryUsers`: a query without it is
          // rejected.
          'filter_conditions': filter ?? const <String, Object?>{},
          if (pagination != null) ...pagination.toJson(),
        }),
      },
    );

    return QueryBannedUsersResponse.fromJson(response.data);
  }
}
