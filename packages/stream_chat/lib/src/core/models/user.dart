import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/util/serializer.dart';

part 'user.g.dart';

/// Class that defines a Stream Chat User.
@JsonSerializable()
class User extends Equatable {
  /// Creates a new user.
  ///
  /// If an [image] is provided it will be set on [extraData] with a `key`
  /// of 'image'.
  ///
  /// For example:
  /// ```dart
  /// final user = User(id: 'id', image: 'https://getstream.io/image.png');
  /// print(user.image == user.extraData['image']); // true
  /// ```
  User({
    required this.id,
    this.role,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastActive,
    Map<String, Object?> extraData = const {},
    this.online = false,
    this.banned = false,
    this.teams = const [],
    this.language,
  })  : _image = image,
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),

        // For backwards compatibalitity, set 'image' on [extraData].
        extraData =
            (image != null) ? {...extraData, 'image': image} : extraData;

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
    'teams',
    'language',
    'image',
  ];

  /// User id.
  final String id;

  /// User role.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final String? role;

  /// Image for user. This is also set on `extraData['image']`.
  ///
  /// {@template image}
  /// There are a few ways to set an image.
  ///
  /// Setting an image by passing in an image argument:
  /// ```dart
  /// final user = User(
  ///   id: 'id',
  ///   image: 'https://getstream.io/image',
  /// );
  /// ```
  ///
  /// Or by directly setting it in [extraData], for example:
  /// ```dart
  /// final user = User(
  ///   id: 'id',
  ///   extraData: const {'image': 'https://getstream.io/image'},
  /// );
  ///
  /// ```
  /// Parsing json with an 'image' key will automatically set the `image`
  /// property and `extraData['image']` key/value.
  ///
  /// ```dart
  /// final user = User.fromJson({
  ///   id: 'id',
  ///   image: 'https://getstream.io/image', // key: image
  /// });
  ///
  /// print(user.image == user.extraData['image']); // true
  /// ```
  /// {@endtemplate}
  final String? _image;

  /// Shortcut for user image.
  ///
  /// {@macro image}
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  String? get image {
    if (_image != null) {
      return _image;
    } else {
      return extraData['image'] as String?;
    }
  }

  /// User teams
  @JsonKey(
    includeIfNull: false,
    toJson: Serializer.readOnly,
    defaultValue: <String>[],
  )
  final List<String> teams;

  /// Date of user creation.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime createdAt;

  /// Date of last user update.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime updatedAt;

  /// Date of last user connection.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime? lastActive;

  /// True if user is online.
  @JsonKey(
      includeIfNull: false, toJson: Serializer.readOnly, defaultValue: false)
  final bool online;

  /// True if user is banned from the chat.
  @JsonKey(
      includeIfNull: false, toJson: Serializer.readOnly, defaultValue: false)
  final bool banned;

  /// Map of custom user extraData.
  @JsonKey(
    includeIfNull: false,
    defaultValue: {},
  )
  final Map<String, Object?> extraData;

  /// The language this user prefers.
  @JsonKey(includeIfNull: false)
  final String? language;

  /// Shortcut for user name.
  String get name {
    if (extraData.containsKey('name')) {
      final name = extraData['name']! as String;
      if (name.isNotEmpty) return name;
    }
    return id;
  }

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
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActive,
    bool? online,
    Map<String, Object?>? extraData,
    bool? banned,
    List<String>? teams,
    String? language,
    String? image,
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
        language: language ?? this.language,
        image: image, // if null, it will be retrieved from extraData['image']
      );

  @override
  List<Object?> get props => [id];
}
