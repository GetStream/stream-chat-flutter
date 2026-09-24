import '../../../open_api/api.dart' as api;
import '../../core/models/responses/search_roles_response.dart';
import '../../core/models/role.dart';

/// Maps a generated [api.Role] to a [Role].
extension RoleMapper on api.Role {
  /// Converts this generated role into a [Role].
  Role toModel() => Role(
    createdAt: createdAt,
    custom: custom,
    name: name,
    scopes: scopes,
    updatedAt: updatedAt,
  );
}

/// Maps a generated [api.SearchRolesResponse] to a [SearchRolesResponse].
extension SearchRolesResponseMapper on api.SearchRolesResponse {
  /// Converts this response into a [SearchRolesResponse].
  SearchRolesResponse toModel() => SearchRolesResponse(
    duration: duration,
    roles: [for (final role in roles) role.toModel()],
  );
}
