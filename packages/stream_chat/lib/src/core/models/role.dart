import 'package:equatable/equatable.dart';

/// A role that can be granted to a user or a channel member, returned by [StreamChatClient.searchRoles].
class Role extends Equatable {
  /// Create a new instance of [Role].
  const Role({
    required this.createdAt,
    required this.custom,
    required this.name,
    required this.scopes,
    required this.updatedAt,
  });

  /// The date when the role was created.
  final DateTime createdAt;

  /// Whether the role is a custom role (true) or a built-in role (false).
  final bool custom;

  /// The unique name of the role.
  final String name;

  /// The list of permission-grant scopes the role currently appears in.
  final List<String> scopes;

  /// The date when the role was last updated.
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
    createdAt,
    custom,
    name,
    scopes,
    updatedAt,
  ];
}
