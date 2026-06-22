import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'role.g.dart';

/// Class that defines a role.
@JsonSerializable(createToJson: false)
class Role extends Equatable {
  /// Create a new instance of [Role].
  const Role({
    required this.createdAt,
    required this.custom,
    required this.name,
    required this.scopes,
    required this.updatedAt,
  });

  /// Create a new instance from a json.
  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

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

/// The type of role used to filter results in
/// [StreamChatClient.searchRoles].
///
/// The server accepts only [user] or [channel]; any other value
/// returns a validation error.
extension type const RoleType(String rawType) implements String {
  /// Restricts results to roles valid as a user-level assignment
  /// (e.g. `user`, `admin`, `anonymous`).
  static const user = RoleType('user');

  /// Restricts results to roles valid as a channel-member assignment
  /// (e.g. `channel_member`, `channel_moderator`).
  static const channel = RoleType('channel');
}
