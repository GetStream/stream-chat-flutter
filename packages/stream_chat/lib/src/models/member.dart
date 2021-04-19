import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/models/user.dart';

part 'member.g.dart';

/// The class that contains the information about the user membership
/// in a channel
@JsonSerializable()
class Member {
  /// Constructor used for json serialization
  Member({
    this.user,
    this.inviteAcceptedAt,
    this.inviteRejectedAt,
    this.invited = false,
    this.role,
    this.userId,
    this.isModerator = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.banned = false,
    this.shadowBanned = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Create a new instance from a json
  factory Member.fromJson(Map<String, dynamic> json) {
    final member = _$MemberFromJson(json);
    return member.copyWith(
      userId: member.user?.id,
    );
  }

  /// The interested user
  final User? user;

  /// The date in which the user accepted the invite to the channel
  final DateTime? inviteAcceptedAt;

  /// The date in which the user rejected the invite to the channel
  final DateTime? inviteRejectedAt;

  /// True if the user has been invited to the channel
  @JsonKey(defaultValue: false)
  final bool invited;

  /// The role of the user in the channel
  final String? role;

  /// The id of the interested user
  final String? userId;

  /// True if the user is a moderator of the channel
  @JsonKey(defaultValue: false)
  final bool isModerator;

  /// True if the member is banned from the channel
  @JsonKey(defaultValue: false)
  final bool banned;

  /// True if the member is shadow banned from the channel
  @JsonKey(defaultValue: false)
  final bool shadowBanned;

  /// The date of creation
  final DateTime createdAt;

  /// The last date of update
  final DateTime updatedAt;

  /// Creates a copy of [Member] with specified attributes overridden.
  Member copyWith({
    User? user,
    DateTime? inviteAcceptedAt,
    DateTime? inviteRejectedAt,
    bool? invited,
    String? role,
    String? userId,
    bool? isModerator,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? banned,
    bool? shadowBanned,
  }) =>
      Member(
        user: user ?? this.user,
        inviteAcceptedAt: inviteAcceptedAt ?? this.inviteAcceptedAt,
        inviteRejectedAt: inviteRejectedAt ?? this.inviteRejectedAt,
        invited: invited ?? this.invited,
        banned: banned ?? this.banned,
        shadowBanned: shadowBanned ?? this.shadowBanned,
        role: role ?? this.role,
        userId: userId ?? this.userId,
        isModerator: isModerator ?? this.isModerator,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  /// Serialize to json
  Map<String, dynamic> toJson() => _$MemberToJson(this);
}
