import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/util/serialization.dart';

part 'user.g.dart';

/// The class that defines the user model
@JsonSerializable()
class User {
  /// Constructor used for json serialization
  User({
    required this.id,
    this.role,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastActive,
    this.online = false,
    this.extraData = const {},
    this.banned = false,
    this.teams = const [],
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Create a new instance from a json
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(
      Serialization.moveToExtraDataFromRoot(json, topLevelFields));

  /// Known top level fields.
  /// Useful for [Serialization] methods.
  static const topLevelFields = [
    'id',
    'role',
    'created_at',
    'updated_at',
    'last_active',
    'online',
    'banned',
    'teams',
  ];

  /// User id
  final String id;

  /// User role
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final String? role;

  /// User role
  @JsonKey(
      includeIfNull: false,
      toJson: Serialization.readOnly,
      defaultValue: <String>[])
  final List<String> teams;

  /// Date of user creation
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime createdAt;

  /// Date of last user update
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime updatedAt;

  /// Date of last user connection
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime? lastActive;

  /// True if user is online
  @JsonKey(
      includeIfNull: false, toJson: Serialization.readOnly, defaultValue: false)
  final bool online;

  /// True if user is banned from the chat
  @JsonKey(
      includeIfNull: false, toJson: Serialization.readOnly, defaultValue: false)
  final bool banned;

  /// Map of custom user extraData
  @JsonKey(
    includeIfNull: false,
    defaultValue: {},
  )
  final Map<String, Object?> extraData;

  @override
  int get hashCode => id.hashCode;

  /// Shortcut for user name
  String get name {
    if (extraData.containsKey('name')) {
      final name = extraData['name']! as String;
      if (name.isNotEmpty) return name;
    }
    return id;
  }

  /// List of users to list of userIds
  static List<String>? toIds(List<User>? users) =>
      users?.map((u) => u.id).toList();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  /// Serialize to json
  Map<String, dynamic> toJson() => Serialization.moveFromExtraDataToRoot(
        _$UserToJson(this),
      );

  /// Creates a copy of [User] with specified attributes overridden.
  User copyWith({
    String? id,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActive,
    bool? online,
    Map<String, Object?>? extraData,
    bool? banned,
    List<String>? teams,
  }) =>
      User(
        id: id ?? this.id,
        role: role ?? this.role,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastActive: lastActive ?? this.lastActive,
        online: online ?? this.online,
        extraData: extraData ?? this.extraData,
        banned: banned ?? this.banned,
        teams: teams ?? this.teams,
      );
}
