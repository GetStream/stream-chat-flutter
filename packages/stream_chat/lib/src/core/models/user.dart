import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/comparable_field.dart';
import 'package:stream_chat/src/core/util/extension.dart';
import 'package:stream_chat/src/core/util/serializer.dart';

part 'user.g.dart';

/// Class that defines a Stream Chat User.
@JsonSerializable()
class User extends Equatable implements ComparableFieldProvider {
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
    this.createdAt,
    this.updatedAt,
    this.lastActive,
    Map<String, Object?> extraData = const {},
    this.online = false,
    this.banned = false,
    this.banExpires,
    this.teams = const [],
    this.language,
    this.teamsRole,
  }) :
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
    'teams_role',
  ];

  /// User id.
  final String id;

  /// Shortcut for user name.
  ///
  /// {@macro name}
  @JsonKey(includeToJson: false, includeFromJson: false)
  String get name {
    final name = extraData['name'].safeCast<String>();
    if (name != null && name.isNotEmpty) return name;

    return id;
  }

  /// Shortcut for user image.
  ///
  /// {@macro image}
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? get image {
    final image = extraData['image'].safeCast<String>();
    if (image != null && image.isNotEmpty) return image;

    return null;
  }

  /// User role.
  @JsonKey(includeToJson: false)
  final String? role;

  /// User teams
  @JsonKey(includeToJson: false)
  final List<String> teams;

  /// Date of user creation.
  @JsonKey(includeToJson: false)
  final DateTime? createdAt;

  /// Date of last user update.
  @JsonKey(includeToJson: false)
  final DateTime? updatedAt;

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

  /// The roles for the user in the teams.
  ///
  /// eg: `{'teamId': 'role', 'teamId2': 'role2'}`
  @JsonKey(includeIfNull: false)
  final Map< /*Team*/ String, /*Role*/ String>? teamsRole;

  /// Map of custom user extraData.
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
    Map<String, String>? teamsRole,
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
        teamsRole: teamsRole ?? this.teamsRole,
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
        teamsRole,
      ];

  @override
  ComparableField? getComparableField(String sortKey) {
    final value = switch (sortKey) {
      UserSortKey.id => id,
      UserSortKey.createdAt => createdAt,
      UserSortKey.updatedAt => updatedAt,
      UserSortKey.name => name,
      UserSortKey.role => role,
      UserSortKey.banned => banned,
      UserSortKey.lastActive => lastActive,
      _ => extraData[sortKey],
    };

    return ComparableField.fromValue(value);
  }
}

/// Extension type representing sortable fields for [User].
///
/// This type provides type-safe keys that can be used for sorting users
/// in queries. Each constant represents a field that can be sorted on.
extension type const UserSortKey(String key) implements String {
  /// Sort users by their ID.
  static const id = UserSortKey('id');

  /// Sort users by their creation date.
  ///
  /// This is part of the default sort (in descending order).
  static const createdAt = UserSortKey('created_at');

  /// Sort users by their last update date.
  static const updatedAt = UserSortKey('updated_at');

  /// Sort users by their name.
  ///
  /// Useful for alphabetical sorting of users.
  static const name = UserSortKey('name');

  /// Sort users by their role.
  static const role = UserSortKey('role');

  /// Sort users by whether they are banned.
  ///
  /// Banned users will appear first when sorting in ascending order.
  static const banned = UserSortKey('banned');

  /// Sort users by their last active date.
  ///
  /// Useful for sorting users by recent activity.
  static const lastActive = UserSortKey('last_active');
}
