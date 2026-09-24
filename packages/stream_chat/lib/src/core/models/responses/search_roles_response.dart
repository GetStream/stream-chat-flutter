import '../role.dart';

/// The roles matching a search, returned by [StreamChatClient.searchRoles].
class SearchRolesResponse {
  /// Creates a new [SearchRolesResponse].
  const SearchRolesResponse({
    required this.duration,
    this.roles = const [],
  });

  /// How long the server took to handle the request, such as `4.21ms`.
  final String duration;

  /// The roles whose names match the search, in the order the server returned them.
  final List<Role> roles;
}
