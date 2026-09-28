import 'package:freezed_annotation/freezed_annotation.dart';

part 'role.freezed.dart';

/// A role that can be granted to a user or a channel member, returned by [StreamChatClient.searchRoles].
@freezed
class Role with _$Role {
  /// Creates a new [Role].
  const Role({
    required this.createdAt,
    required this.custom,
    required this.name,
    required this.scopes,
    required this.updatedAt,
  });

  /// The date when the role was created.
  @override
  final DateTime createdAt;

  /// Whether the role is a custom role (true) or a built-in role (false).
  @override
  final bool custom;

  /// The unique name of the role.
  @override
  final String name;

  /// The list of permission-grant scopes the role currently appears in.
  @override
  final List<String> scopes;

  /// The date when the role was last updated.
  @override
  final DateTime updatedAt;
}
