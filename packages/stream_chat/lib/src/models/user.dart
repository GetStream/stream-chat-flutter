import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/models/serialization.dart';

part 'user.g.dart';

/// The class that defines the user model
@JsonSerializable()
class User {
  /// Constructor used for json serialization
  User({
    this.id = '',
    this.role = '',
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

  /// Use this named constructor to create a new user instance
  User.init(
    this.id, {
    this.online = false,
    this.extraData = const {},
    required this.createdAt,
    required this.updatedAt,
    this.teams = const [],
    required this.role,
  })   : lastActive = null,
        banned = false;

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
  @JsonKey(
      includeIfNull: false, toJson: Serialization.readOnly, defaultValue: '')
  final String role;

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
  @JsonKey(includeIfNull: false)
  final Map<String, dynamic> extraData;

  @override
  int get hashCode => id.hashCode;

  /// Shortcut for user name
  String? get name =>
      (extraData.containsKey('name') == true && extraData['name'] != '')
          ? extraData['name']
          : id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  /// Serialize to json
  Map<String, dynamic> toJson() =>
      Serialization.moveFromExtraDataToRoot(_$UserToJson(this), topLevelFields);

  /// Creates a copy of [User] with specified attributes overridden.
  User copyWith({
    String? id,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActive,
    bool? online,
    Map<String, dynamic>? extraData,
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
