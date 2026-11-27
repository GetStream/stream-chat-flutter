import 'package:freezed_annotation/freezed_annotation.dart';

import '../role.dart';

part 'search_roles_response.freezed.dart';

/// The roles matching a search.
@freezed
class SearchRolesResponse with _$SearchRolesResponse {
  /// Creates a new [SearchRolesResponse].
  const SearchRolesResponse({
    required this.duration,
    this.roles = const [],
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The roles whose names match the search, in the order the search returned them.
  @override
  final List<Role> roles;
}
