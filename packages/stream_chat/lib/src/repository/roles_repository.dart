import 'package:stream_core/stream_core.dart' show PatternMatching, Result;

import '../../open_api/api.dart' as api;
import '../core/models/responses/search_roles_response.dart';
import '../core/models/role_type.dart';
import 'mapper/roles_mapper.dart';

/// Repository dedicated to roles operations.
class RolesRepository {
  /// Initialize a new roles repository.
  const RolesRepository(this._api);

  final api.DefaultApi _api;

  /// Searches roles by name prefix (autocomplete).
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
  }) async {
    final result = await _api.searchRoles(
      query: query,
      limit: limit,
      nameGt: nameGt,
      roleType: roleType,
      includeGlobalRoles: includeGlobalRoles,
    );

    return result.map((response) => response.toModel());
  }
}
