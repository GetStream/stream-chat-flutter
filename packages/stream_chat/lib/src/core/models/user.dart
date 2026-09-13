import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_core/stream_core.dart' show Standard, Sort, SortField;

import '../util/extension.dart';
import '../util/serializer.dart';
import '../util/string_sort_normalizer.dart';

part 'user.g.dart';

/// Class that defines a Stream Chat User.
@JsonSerializable(includeIfNull: false)
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
    this.createdAt,
    this.updatedAt,
    this.lastActive,
    this.online = false,
    this.banned = false,
    this.banExpires,
    this.teams = const [],
    this.language,
    this.invisible,
    this.teamsRole,
    this.avgResponseTime,
    Map<String, Object?> extraData = const {},
  }) : // For backwards compatibility, set 'name', 'image' in [extraData].
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
    'invisible',
    'teams_role',
    'avg_response_time',
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
  final String? role;

  /// User teams
  final List<String> teams;

  /// Date of user creation.
  final DateTime? createdAt;

  /// Date of last user update.
  final DateTime? updatedAt;

  /// Date of last user connection.
  final DateTime? lastActive;

  /// True if user is online.
  final bool online;

  /// True if user is banned from the chat.
  final bool banned;

  /// The date at which the ban will expire.
  final DateTime? banExpires;

  /// The language this user prefers.
  final String? language;

  /// Whether the user is sharing their online presence.
  final bool? invisible;

  /// The roles for the user in the teams.
  ///
  /// eg: `{'teamId': 'role', 'teamId2': 'role2'}`
  final Map</*Team*/ String, /*Role*/ String>? teamsRole;

  /// The average response time of the user in seconds.
  final int? avgResponseTime;

  /// Map of custom user extraData.
  final Map<String, Object?> extraData;

  /// List of users to list of userIds.
  static List<String>? toIds(List<User>? users) => users?.map((u) => u.id).toList();

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
    bool? invisible,
    Map<String, String>? teamsRole,
    int? avgResponseTime,
  }) => User(
    id: id ?? this.id,
    role: role ?? this.role,
    name:
        name ??
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
    invisible: invisible ?? this.invisible,
    teamsRole: teamsRole ?? this.teamsRole,
    avgResponseTime: avgResponseTime ?? this.avgResponseTime,
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
    invisible,
    teamsRole,
    avgResponseTime,
  ];
}

/// Represents a sorting operation for users.
///
/// See [UserSortField] for the fields that can be sorted on.
class UserSort extends Sort<User> {
  /// Sorts by [field], smallest first.
  const UserSort.asc(
    UserSortField super.field, {
    super.nullOrdering,
  }) : super.asc();

  /// Sorts by [field], largest first.
  const UserSort.desc(
    UserSortField super.field, {
    super.nullOrdering,
  }) : super.desc();

  /// The ordering the API applies to a user query when none is given.
  ///
  /// Sorts by when the user was created, newest first.
  static final List<UserSort> defaultSort = List.unmodifiable([
    UserSort.desc(UserSortField.createdAt),
  ]);
}

/// Represents a field that user queries can be sorted on.
class UserSortField extends SortField<User> {
  /// Creates a user sort field named [remote] on the wire, reading its
  /// value off an instance with `localValue`.
  ///
  /// Prefer the fields this class declares — they are the ones the API accepts.
  /// This is for a field the SDK has not modelled yet.
  UserSortField(super.remote, super.localValue);

  /// Creates a field the SDK does not model, read from [User.extraData].
  ///
  /// Declared only where the API accepts a custom sort field.
  factory UserSortField.custom(String remote) {
    return UserSortField(remote, (it) => it.extraData[remote]);
  }

  /// Sorts users by their ID.
  static final id = UserSortField(
    'id',
    (it) => it.id,
  );

  /// Sorts users by their creation date.
  ///
  /// This is part of the default sort (in descending order).
  static final createdAt = UserSortField(
    'created_at',
    (it) => it.createdAt,
  );

  /// Sorts users by their last update date.
  static final updatedAt = UserSortField(
    'updated_at',
    (it) => it.updatedAt,
  );

  /// Sorts users by their name.
  ///
  /// Compared with case, diacritics and ligatures folded away, so a list
  /// sorted locally matches the order a query returns.
  static final name = UserSortField(
    'name',
    // Deliberately not `User.name`, which answers the id when a user has no
    // name — sorting by that locally would order unnamed users among the
    // named ones, where the API sorts them by an empty `name` column.
    (it) => it.extraData['name'].safeCast<String>()?.let(normalizeStringForSort),
  );

  /// Sorts users by their role.
  static final role = UserSortField(
    'role',
    (it) => it.role,
  );

  /// Sorts users by whether they are banned.
  ///
  /// Banned users will appear first when sorting in ascending order.
  static final banned = UserSortField(
    'banned',
    (it) => it.banned,
  );

  /// Sorts users by their last active date.
  ///
  /// Useful for sorting users by recent activity.
  static final lastActive = UserSortField(
    'last_active',
    (it) => it.lastActive,
  );

  /// Sorts users by their preferred language.
  static final language = UserSortField(
    'language',
    (it) => it.language,
  );
}
