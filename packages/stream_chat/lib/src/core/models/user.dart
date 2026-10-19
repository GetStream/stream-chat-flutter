import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_core/stream_core.dart'
    show Filter, FilterField, Standard, Sort, SortField, normalizeStringForSort;

import '../util/extension.dart';
import '../util/serializer.dart';

part 'user.g.dart';

/// Class that defines a Stream Chat User.
@JsonSerializable(includeIfNull: false)
class User extends Equatable {
  /// Creates a new user.
  User({
    required this.id,
    this.role,
    this.name,
    this.image,
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
    Map<String, Object?> custom = const {},
    this.deactivatedAt,
    this.deletedAt,
    this.shadowBanned,
    this.blockedUserIds = const [],
  }) : custom = {...custom};

  /// Create a new instance from json.
  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(Serializer.moveToExtraDataFromRoot(json, topLevelFields));

  /// The JSON keys [User.fromJson] reads into named fields, or leaves out;
  /// every other key is kept in [custom].
  static const topLevelFields = [
    'id',
    'name',
    'image',
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
    'deactivated_at',
    'deleted_at',
    'shadow_banned',
    'blocked_user_ids',
  ];

  /// User id.
  final String id;

  /// The user's name.
  ///
  /// Null when the user has none.
  final String? name;

  /// The user's [name], or their [id] when the name is missing or empty.
  ///
  /// Suited to naming a user by text, such as in a mention; [name] tells an
  /// unnamed user apart.
  @JsonKey(includeToJson: false, includeFromJson: false)
  String get nameOrId => switch (name) {
    final name? when name.isNotEmpty => name,
    _ => id,
  };

  /// The URL of the user's image.
  ///
  /// Null when the user has none.
  final String? image;

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

  /// This user's custom data.
  ///
  /// It may hold a key named like one of the user's own fields; [toJson] leaves
  /// such an entry out so it never overwrites the field.
  @JsonKey(name: 'extra_data')
  final Map<String, Object?> custom;

  /// The date at which the user was deactivated.
  ///
  /// Null while the user is active, or when not known.
  final DateTime? deactivatedAt;

  /// The date at which the user was deleted.
  ///
  /// Null while the user exists, or when not known.
  final DateTime? deletedAt;

  /// Whether the user is shadow banned.
  ///
  /// Null when not known.
  final bool? shadowBanned;

  /// The ids of the users this user blocked.
  final List<String> blockedUserIds;

  /// List of users to list of userIds.
  static List<String>? toIds(List<User>? users) => users?.map((u) => u.id).toList();

  /// Serialize to json.
  ///
  /// Writes the entries of [custom] at the root, leaving out any named like one
  /// of [topLevelFields].
  Map<String, dynamic> toJson() => Serializer.moveFromExtraDataToRoot(
    _$UserToJson(this),
    topLevelFields: topLevelFields,
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
    Map<String, Object?>? custom,
    bool? banned,
    DateTime? banExpires,
    List<String>? teams,
    String? language,
    bool? invisible,
    Map<String, String>? teamsRole,
    int? avgResponseTime,
    DateTime? deactivatedAt,
    DateTime? deletedAt,
    bool? shadowBanned,
    List<String>? blockedUserIds,
  }) => User(
    id: id ?? this.id,
    role: role ?? this.role,
    name: name ?? this.name,
    image: image ?? this.image,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastActive: lastActive ?? this.lastActive,
    online: online ?? this.online,
    custom: custom ?? this.custom,
    banned: banned ?? this.banned,
    banExpires: banExpires ?? this.banExpires,
    teams: teams ?? this.teams,
    language: language ?? this.language,
    invisible: invisible ?? this.invisible,
    teamsRole: teamsRole ?? this.teamsRole,
    avgResponseTime: avgResponseTime ?? this.avgResponseTime,
    deactivatedAt: deactivatedAt ?? this.deactivatedAt,
    deletedAt: deletedAt ?? this.deletedAt,
    shadowBanned: shadowBanned ?? this.shadowBanned,
    blockedUserIds: blockedUserIds ?? this.blockedUserIds,
  );

  @override
  List<Object?> get props => [
    id,
    role,
    name,
    image,
    lastActive,
    online,
    custom,
    banned,
    banExpires,
    teams,
    language,
    invisible,
    teamsRole,
    avgResponseTime,
    deactivatedAt,
    deletedAt,
    shadowBanned,
    blockedUserIds,
  ];
}

/// A filter for a user query.
///
/// See [UserFilterField] for the fields that can be filtered on.
///
/// ```dart
/// final filter = UserFilter.or([
///   UserFilter.autoComplete(UserFilterField.name, 'jo'),
///   UserFilter.autoComplete(UserFilterField.id, 'jo'),
/// ]);
/// ```
typedef UserFilter = Filter<User>;

/// Represents a field that user queries can be filtered on.
class UserFilterField extends FilterField<User> {
  /// Creates a user filter field named [remote] in queries, reading its value
  /// off an instance with [value].
  UserFilterField(super.remote, super.value);

  /// Creates a field the SDK does not model, read from [User.custom].
  ///
  /// A user query compares a custom field for equality only. Anything else is
  /// rejected.
  ///
  /// **Supported operators:** `$eq`, `$in`
  factory UserFilterField.custom(String remote) {
    return UserFilterField(remote, (it) => it.custom[remote]);
  }

  /// Filters users by their id.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$autocomplete`
  static final id = UserFilterField(
    'id',
    (it) => it.id,
  );

  /// Filters users by their name.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$autocomplete`
  static final name = UserFilterField(
    'name',
    (it) => it.name,
  );

  /// Filters users by their username.
  ///
  /// **Supported operators:** `$eq`, `$autocomplete`
  static final username = UserFilterField(
    'username',
    (it) => it.custom['username'].safeCast<String>(),
  );

  /// Filters users by their email address.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final email = UserFilterField(
    'email',
    (it) => it.custom['email'].safeCast<String>(),
  );

  /// Filters users by their role.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final role = UserFilterField(
    'role',
    (it) => it.role,
  );

  /// Filters users by the teams they belong to.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$contains`
  static final teams = UserFilterField(
    'teams',
    (it) => it.teams,
  );

  /// Filters users by whether they are banned.
  ///
  /// **Supported operators:** `$eq`
  static final banned = UserFilterField(
    'banned',
    (it) => it.banned,
  );

  /// Filters users by whether they are shadow banned.
  ///
  /// **Supported operators:** `$eq`
  static final shadowBanned = UserFilterField(
    'shadow_banned',
    (it) => it.shadowBanned,
  );

  /// Filters users by whether they bypass moderation.
  ///
  /// **Supported operators:** `$eq`
  static final bypassModeration = UserFilterField(
    'bypass_moderation',
    (it) => it.custom['bypass_moderation'].safeCast<bool>(),
  );

  /// Filters users by when they were last online.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`,
  /// `$exists`
  static final lastActive = UserFilterField(
    'last_active',
    (it) => it.lastActive,
  );

  /// Filters users by their creation date.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`,
  /// `$exists`
  static final createdAt = UserFilterField(
    'created_at',
    (it) => it.createdAt,
  );

  /// Filters users by their last update date.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`,
  /// `$exists`
  static final updatedAt = UserFilterField(
    'updated_at',
    (it) => it.updatedAt,
  );

  /// Filters users by the language they chose.
  ///
  /// **Supported operators:** `$eq`
  static final language = UserFilterField(
    'language',
    (it) => it.language,
  );
}

/// Represents a sorting operation for users.
///
/// See [UserSortField] for the fields that can be sorted on.
///
/// ```dart
/// final sort = [UserSort.asc(UserSortField.name)];
/// ```
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

  /// An empty sort: the query carries no sort term, and a list keeps the
  /// order it arrived in.
  static const List<UserSort> empty = [];

  /// The ordering the API applies to a user query when none is given.
  ///
  /// Sorts by when the user was created, newest first.
  static final List<UserSort> defaultSort = [
    UserSort.desc(UserSortField.createdAt),
  ];
}

/// Represents a field that user queries can be sorted on.
class UserSortField extends SortField<User> {
  /// Creates a field named [remote] in queries, reading its value off an
  /// instance with `localValue`.
  ///
  /// For a name the SDK has not modelled; prefer the fields declared here.
  UserSortField(super.remote, super.localValue);

  /// Creates a field the SDK does not model, read from [User.custom].
  ///
  /// Declared only where the API accepts a custom sort field.
  factory UserSortField.custom(String remote) {
    return UserSortField(remote, (it) => it.custom[remote]);
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
    (it) => it.name?.let(normalizeStringForSort),
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

  /// Sorts users by the teams they belong to.
  ///
  /// A team list has no ordering, so a page re-sorted locally keeps the order
  /// it arrived in.
  static final teams = UserSortField(
    'teams',
    (it) => it.teams,
  );
}
