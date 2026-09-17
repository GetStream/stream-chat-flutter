import 'package:stream_core/stream_core.dart' show Result;

import '../../open_api/api.dart' show DefaultApi;
import '../../open_api/models.dart' show SearchRolesResponse;

/// Repository dedicated to roles operations.
class RolesRepository {
  /// Initialize a new roles repository.
  const RolesRepository(this._api);

  final DefaultApi _api;

  /// Searches roles by name prefix (autocomplete).
  ///
  /// [roleType] filters to user-assignable (`user`) or channel-assignable
  /// (`channel`) roles when set; both kinds are returned when omitted. The
  /// server accepts only those two values and returns a validation error for
  /// anything else.
  ///
  /// [includeGlobalRoles] includes roles prefixed `global_` when set to
  /// `true`. Defaults to `false` on the server.
  Future<Result<SearchRolesResponse>> searchRoles(
    String query, {
    int? limit,
    String? nameGt,
    String? roleType,
    bool? includeGlobalRoles,
  }) => _api.searchRoles(
    query: query,
    limit: limit,
    nameGt: nameGt,
    roleType: roleType,
    includeGlobalRoles: includeGlobalRoles,
  );
}
