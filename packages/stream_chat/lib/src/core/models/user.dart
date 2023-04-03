import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/util/serializer.dart';

part 'user.g.dart';

/// Class that defines a Stream Chat User.
@JsonSerializable()
class User extends Equatable {
  /// Creates a new user.
  ///
  /// {@template name}
  /// If an [name] is provided it will be set on [extraData] with a `key`
  /// of 'name'.
  ///
  /// For example:
  /// ```dart
  /// final user = User(id: 'id', name: 'Sahil Kumar');
  /// print(user.name == user.extraData['name']); // true
  /// ```
  /// {@endtemplate}
  ///
  /// {@template image}
  /// If an [image] is provided it will be set on [extraData] with a `key`
  /// of 'image'.
  ///
  /// For example:
  /// ```dart
  /// final user = User(id: 'id', image: 'https://getstream.io/image.png');
  /// print(user.image == user.extraData['image']); // true
  /// ```
  /// {@endtemplate}
  User({
    required this.id,
    this.role,
    String? name,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastActive,
    Map<String, Object?> extraData = const {},
    this.online = false,
    this.banned = false,
    this.banExpires,
    this.teams = const [],
    this.language,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        // For backwards compatibility, set 'name', 'image' in [extraData].
        extraData = {
          ...extraData,
          if (name != null) 'name': name,
          if (image != null) 'image': image,
        };

  /// Create a new instance from json.
  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(Serializer.moveToExtraDataFromRoot(json, topLevelFields));

  /// Known top level fields.
  ///
  /// Useful for [Serializer] methods.
  static const topLevelFields = [
    'id',
    'role',
    'created_at',
    'updated_at',
    'last_active',
    'online',
    'banned',
    'ban_expires',
    'teams',
    'language',
  ];

  /// User id.
  final String id;

  /// Shortcut for user name.
  ///
  /// {@macro name}
  @JsonKey(includeToJson: false, includeFromJson: false)
  String get name {
    if (extraData.containsKey('name') && extraData['name'] != null) {
      final name = extraData['name']! as String;
      if (name.isNotEmpty) return name;
    }
    return id;
  }

  /// Shortcut for user image.
  ///
  /// {@macro image}
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? get image => extraData['image'] as String?;

  /// User role.
  @JsonKey(includeToJson: false)
  final String? role;

  /// User teams
  @JsonKey(includeToJson: false)
  final List<String> teams;

  /// Date of user creation.
  @JsonKey(includeToJson: false)
  final DateTime createdAt;

  /// Date of last user update.
  @JsonKey(includeToJson: false)
  final DateTime updatedAt;

  /// Date of last user connection.
  @JsonKey(includeToJson: false)
  final DateTime? lastActive;

  /// True if user is online.
  @JsonKey(includeToJson: false)
  final bool online;

  /// True if user is banned from the chat.
  @JsonKey(includeToJson: false)
  final bool banned;

  /// The date at which the ban will expire.
  @JsonKey(includeToJson: false)
  final DateTime? banExpires;

  /// The language this user prefers.
  @JsonKey(includeIfNull: false)
  final String? language;

  /// Map of custom user extraData.
  @JsonKey(includeIfNull: false)
  final Map<String, Object?> extraData;

  /// List of users to list of userIds.
  static List<String>? toIds(List<User>? users) =>
      users?.map((u) => u.id).toList();

  /// Serialize to json.
  Map<String, dynamic> toJson() => Serializer.moveFromExtraDataToRoot(
        _$UserToJson(this),
      );

  /// Creates a copy of [User] with specified attributes overridden.
  User copyWith({
    String? id,
    String? role,
    String? name,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActive,
    bool? online,
    Map<String, Object?>? extraData,
    bool? banned,
    DateTime? banExpires,
    List<String>? teams,
    String? language,
  }) =>
      User(
        id: id ?? this.id,
        role: role ?? this.role,
        name: name ??
            extraData?['name'] as String? ??
            // Using extraData value in order to not use id as name.
            this.extraData['name'] as String?,
        image: image ?? extraData?['image'] as String? ?? this.image,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastActive: lastActive ?? this.lastActive,
        online: online ?? this.online,
        extraData: extraData ?? this.extraData,
        banned: banned ?? this.banned,
        banExpires: banExpires ?? this.banExpires,
        teams: teams ?? this.teams,
        language: language ?? this.language,
      );

  @override
  List<Object?> get props => [
        id,
        role,
        lastActive,
        online,
        extraData,
        banned,
        banExpires,
        teams,
        language,
      ];
}
