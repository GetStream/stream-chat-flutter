import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/util/serializer.dart';

part 'member.g.dart';

/// The class that contains the information about the user membership
/// in a channel
@JsonSerializable()
class Member extends Equatable {
  /// Constructor used for json serialization
  Member({
    this.user,
    this.inviteAcceptedAt,
    this.inviteRejectedAt,
    this.invited = false,
    this.channelRole,
    String? userId,
    this.isModerator = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.banned = false,
    this.banExpires,
    this.shadowBanned = false,
    this.extraData = const {},
  })  : userId = userId ?? user?.id,
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Create a new instance from a json
  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(
        Serializer.moveToExtraDataFromRoot(json, _topLevelFields),
      );

  /// Known top level fields.
  ///
  /// Useful for [Serializer] methods.
  static const _topLevelFields = [
    'user',
    'invite_accepted_at',
    'invite_rejected_at',
    'invited',
    'channel_role',
    'user_id',
    'is_moderator',
    'banned',
    'ban_expires',
    'shadow_banned',
    'created_at',
    'updated_at',
  ];

  /// The interested user
  final User? user;

  /// The date in which the user accepted the invite to the channel
  final DateTime? inviteAcceptedAt;

  /// The date in which the user rejected the invite to the channel
  final DateTime? inviteRejectedAt;

  /// True if the user has been invited to the channel
  final bool invited;

  /// The role of this member in the channel
  final String? channelRole;

  /// The id of the interested user
  final String? userId;

  /// True if the user is a moderator of the channel
  final bool isModerator;

  /// True if the member is banned from the channel
  final bool banned;

  /// The date at which the ban will expire.
  final DateTime? banExpires;

  /// True if the member is shadow banned from the channel
  final bool shadowBanned;

  /// The date of creation
  final DateTime createdAt;

  /// The last date of update
  final DateTime updatedAt;

  /// Map of custom member extraData.
  final Map<String, Object?> extraData;

  /// Creates a copy of [Member] with specified attributes overridden.
  Member copyWith({
    User? user,
    DateTime? inviteAcceptedAt,
    DateTime? inviteRejectedAt,
    bool? invited,
    String? role,
    String? channelRole,
    String? userId,
    bool? isModerator,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? banned,
    DateTime? banExpires,
    bool? shadowBanned,
    Map<String, Object?>? extraData,
  }) =>
      Member(
        user: user ?? this.user,
        inviteAcceptedAt: inviteAcceptedAt ?? this.inviteAcceptedAt,
        inviteRejectedAt: inviteRejectedAt ?? this.inviteRejectedAt,
        invited: invited ?? this.invited,
        banned: banned ?? this.banned,
        banExpires: banExpires ?? this.banExpires,
        shadowBanned: shadowBanned ?? this.shadowBanned,
        channelRole: channelRole ?? this.channelRole,
        userId: userId ?? this.userId,
        isModerator: isModerator ?? this.isModerator,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        extraData: extraData ?? this.extraData,
      );

  /// Serialize to json
  Map<String, dynamic> toJson() => Serializer.moveFromExtraDataToRoot(
        _$MemberToJson(this),
      );

  @override
  List<Object?> get props => [
        user,
        inviteAcceptedAt,
        inviteRejectedAt,
        invited,
        channelRole,
        userId,
        isModerator,
        banned,
        banExpires,
        shadowBanned,
        createdAt,
        updatedAt,
        extraData,
      ];
}
