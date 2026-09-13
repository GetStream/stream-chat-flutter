import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_core/stream_core.dart' show Sort, SortField;

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

/// Represents a sorting operation for banned users.
///
/// See [BannedUserSortField] for the fields that can be sorted on.
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
