import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_chat/src/core/models/role_type.dart';

/// Defines the API dedicated to roles operations.
class RolesApi {
  /// Initialize a new roles API.
  const RolesApi(this._client);

  final StreamHttpClient _client;

  /// Searches roles by name prefix (autocomplete).
  ///
  /// [roleType] filters to user-assignable ([RoleType.user]) or
  /// channel-assignable ([RoleType.channel]) roles when set; both kinds are
  /// returned when omitted.
  ///
  /// [includeGlobalRoles] includes roles prefixed `global_` when set to
  /// `true`. Defaults to `false` on the server.
  Future<SearchRolesResponse> searchRoles(
    String query, {
    int? limit,
    String? nameGt,
    RoleType? roleType,
    bool? includeGlobalRoles,
  }) async {
    final response = await _client.get(
      '/roles/search',
      queryParameters: {
        'query': query,
        if (limit != null) 'limit': limit,
        if (nameGt != null) 'name_gt': nameGt,
        if (roleType != null) 'role_type': roleType,
        if (includeGlobalRoles != null) 'include_global_roles': includeGlobalRoles,
      },
    );
    return SearchRolesResponse.fromJson(response.data);
  }
}
