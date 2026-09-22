import 'package:stream_core/stream_core.dart' show Result;

import '../../open_api/api.dart' show DefaultApi;
import '../../open_api/models.dart' show SearchRolesResponse;
import '../core/models/role_type.dart';

/// Repository dedicated to roles operations.
class RolesRepository {
  /// Initialize a new roles repository.
  const RolesRepository(this._api);

  final DefaultApi _api;

  /// Searches roles by name prefix (autocomplete).
  ///
  /// [limit] caps how many roles come back in one page.
  ///
  /// [nameGt] is a cursor: only roles ordering after this name are returned.
  /// Pass the last name of the previous page to read the next one.
  ///
  /// [roleType] filters to user-assignable ([RoleType.user]) or
  /// channel-assignable ([RoleType.channel]) roles when set; both kinds are
  /// returned when omitted.
  ///
  /// [includeGlobalRoles] includes roles prefixed `global_` when set to
  /// `true`. Defaults to `false` on the server.
  Future<Result<SearchRolesResponse>> searchRoles(
    String query, {
    int? limit,
    String? nameGt,
    RoleType? roleType,
    bool? includeGlobalRoles,
  }) => _api.searchRoles(
    query: query,
    limit: limit,
    nameGt: nameGt,
    roleType: roleType,
    includeGlobalRoles: includeGlobalRoles,
  );
}
