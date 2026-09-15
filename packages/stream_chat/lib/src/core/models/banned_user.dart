import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_core/stream_core.dart' show Filter, FilterField, Sort, SortField;

import 'channel_model.dart';
import 'user.dart';

part 'banned_user.g.dart';

/// Contains information about a [User] that was banned from a [Channel] or App.
@JsonSerializable()
class BannedUser extends Equatable {
  /// Creates a new instance of [BannedUser]
  const BannedUser({
    required this.user,
    this.bannedBy,
    this.channel,
    this.createdAt,
    this.expires,
    this.shadow = false,
    this.reason,
  });

  /// Create a new instance from a json
  factory BannedUser.fromJson(Map<String, dynamic> json) => _$BannedUserFromJson(json);

  /// Banned user.
  final User user;

  /// User that banned the [user].
  final User? bannedBy;

  /// Channel where the [user] was banned.
  final ChannelModel? channel;

  /// Timestamp when the [user] was banned.
  final DateTime? createdAt;

  /// Timestamp when the [user] will be unbanned.
  final DateTime? expires;

  /// Whether the [user] is a shadow banned user.
  final bool shadow;

  /// Reason for the ban.
  final String? reason;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$BannedUserToJson(this);

  /// Returns a copy of this object with the given fields updated.
  BannedUser copyWith({
    User? user,
    User? bannedBy,
    ChannelModel? channel,
    DateTime? createdAt,
    DateTime? expires,
    bool? shadow,
    String? reason,
  }) => BannedUser(
    user: user ?? this.user,
    bannedBy: bannedBy ?? this.bannedBy,
    channel: channel ?? this.channel,
    createdAt: createdAt ?? this.createdAt,
    expires: expires ?? this.expires,
    shadow: shadow ?? this.shadow,
    reason: reason ?? this.reason,
  );

  @override
  List<Object?> get props => [
    user,
    bannedBy,
    channel,
    createdAt,
    expires,
    shadow,
    reason,
  ];
}

/// A filter for a banned-user query.
///
/// See [BannedUserFilterField] for the fields that can be filtered on.
///
/// ```dart
/// final filter = BannedUserFilter.equal(
///   BannedUserFilterField.channelCid,
///   'messaging:general',
/// );
/// ```
typedef BannedUserFilter = Filter<BannedUser>;

/// Represents a field that banned-user queries can be filtered on.
class BannedUserFilterField extends FilterField<BannedUser> {
  /// Creates a banned-user filter field named [remote] on the wire, reading
  /// its value off an instance with [value].
  BannedUserFilterField(
    super.remote,
    super.value, {
    super.collectionEquality,
  });

  /// Filters banned users by their id.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`,
  /// `$exists`
  static final userId = BannedUserFilterField(
    'user_id',
    (it) => it.user.id,
  );

  /// Filters banned users by the id of the user who banned them.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`,
  /// `$exists`
  static final bannedById = BannedUserFilterField(
    'banned_by_id',
    (it) => it.bannedBy?.id,
  );

  /// Filters banned users by the full id of the channel they were banned in,
  /// in the form `type:id`.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final channelCid = BannedUserFilterField(
    'channel_cid',
    (it) => it.channel?.cid,
  );

  /// Filters banned users by the reason given for the ban.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`,
  /// `$exists`, `$autocomplete`
  static final reason = BannedUserFilterField(
    'reason',
    (it) => it.reason,
  );

  /// Filters banned users by the date the ban was created.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`,
  /// `$exists`
  static final createdAt = BannedUserFilterField(
    'created_at',
    (it) => it.createdAt,
  );
}

/// Represents a sorting operation for banned users.
///
/// See [BannedUserSortField] for the fields that can be sorted on.
///
/// ```dart
/// final sort = [BannedUserSort.desc(BannedUserSortField.createdAt)];
/// ```
class BannedUserSort extends Sort<BannedUser> {
  /// Sorts by [field], smallest first.
  const BannedUserSort.asc(
    BannedUserSortField super.field, {
    super.nullOrdering,
  }) : super.asc();

  /// Sorts by [field], largest first.
  const BannedUserSort.desc(
    BannedUserSortField super.field, {
    super.nullOrdering,
  }) : super.desc();
}

/// Represents a field that banned-user queries can be sorted on.
class BannedUserSortField extends SortField<BannedUser> {
  /// Creates a field named [remote] on the wire, reading its value off an
  /// instance with `localValue`.
  ///
  /// For a name the SDK has not modelled; prefer the fields declared here.
  BannedUserSortField(super.remote, super.localValue);

  /// Sorts banned users by their creation date.
  ///
  /// This is the default sort field (in descending order).
  static final createdAt = BannedUserSortField(
    'created_at',
    (it) => it.createdAt,
  );
}
