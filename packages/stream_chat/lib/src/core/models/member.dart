import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/comparable_field.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/util/serializer.dart';

part 'member.g.dart';

/// The class that contains the information about the user membership
/// in a channel
@JsonSerializable()
class Member extends Equatable implements ComparableFieldProvider {
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
    this.pinnedAt,
    this.archivedAt,
    this.deletedMessages = const [],
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
    'pinned_at',
    'archived_at',
    'deleted_messages',
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

  /// The date at which the channel was pinned by the member
  final DateTime? pinnedAt;

  /// The date at which the channel was archived by the member
  final DateTime? archivedAt;

  /// The date of creation
  final DateTime createdAt;

  /// The last date of update
  final DateTime updatedAt;

  /// List of message ids deleted by this member only for himself.
  ///
  /// These messages are not visible to this member anymore, but are still
  /// visible to other channel members.
  final List<String> deletedMessages;

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
    DateTime? pinnedAt,
    DateTime? archivedAt,
    bool? banned,
    DateTime? banExpires,
    bool? shadowBanned,
    List<String>? deletedMessages,
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
        pinnedAt: pinnedAt ?? this.pinnedAt,
        archivedAt: archivedAt ?? this.archivedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedMessages: deletedMessages ?? this.deletedMessages,
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
        pinnedAt,
        archivedAt,
        createdAt,
        updatedAt,
        deletedMessages,
        extraData,
      ];

  @override
  ComparableField? getComparableField(String sortKey) {
    final value = switch (sortKey) {
      MemberSortKey.createdAt => createdAt,
      MemberSortKey.userId => userId,
      MemberSortKey.name => user?.name,
      MemberSortKey.channelRole => channelRole,
      _ => extraData[sortKey],
    };

    return ComparableField.fromValue(value);
  }
}

/// Extension type representing sortable fields for [Member].
///
/// This type provides type-safe keys that can be used for sorting members
/// in queries. Each constant represents a field that can be sorted on.
extension type const MemberSortKey(String key) implements String {
  /// Sort members by their creation date in the channel.
  static const createdAt = MemberSortKey('created_at');

  /// Sort members by the user ID.
  static const userId = MemberSortKey('user_id');

  /// Sort members by user name.
  ///
  /// Note: This requires additional database joins and might be slower.
  static const name = MemberSortKey('name');

  /// Sort members by the channel role.
  static const channelRole = MemberSortKey('channel_role');
}
