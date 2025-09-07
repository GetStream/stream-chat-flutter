import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/comparable_field.dart';
import 'package:stream_chat/src/core/models/user.dart';

part 'banned_user.g.dart';

/// Contains information about a [User] that was banned from a [Channel] or App.
@JsonSerializable()
class BannedUser extends Equatable implements ComparableFieldProvider {
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
  factory BannedUser.fromJson(Map<String, dynamic> json) =>
      _$BannedUserFromJson(json);

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
  }) =>
      BannedUser(
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

  @override
  ComparableField? getComparableField(String sortKey) {
    final value = switch (sortKey) {
      BannedUserSortKey.createdAt => createdAt,
      _ => null,
    };

    return ComparableField.fromValue(value);
  }
}

/// Extension type representing sortable fields for [BannedUser].
///
/// This type provides type-safe keys that can be used for sorting banned users
/// in queries. Each constant represents a field that can be sorted on.
extension type const BannedUserSortKey(String key) implements String {
  /// Sort banned users by their creation date.
  ///
  /// This is the default sort field (in descending order).
  static const createdAt = BannedUserSortKey('created_at');
}
