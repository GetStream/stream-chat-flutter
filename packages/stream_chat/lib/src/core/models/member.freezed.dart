// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Member {
  User? get user;
  DateTime? get inviteAcceptedAt;
  DateTime? get inviteRejectedAt;
  bool get invited;
  String? get channelRole;
  String? get userId;
  bool get isModerator;
  bool get banned;
  DateTime? get banExpires;
  bool get shadowBanned;
  DateTime? get pinnedAt;
  DateTime? get archivedAt;
  DateTime get createdAt;
  DateTime get updatedAt;
  List<String> get deletedMessages;
  Map<String, Object?> get custom;
  bool? get notificationsMuted;
  String? get status;
  bool? get banFromFutureChannels;
  DateTime? get futureChannelBanExpires;
  DateTime? get deletedAt;

  /// Create a copy of Member
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MemberCopyWith<Member> get copyWith => _$MemberCopyWithImpl<Member>(this as Member, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Member &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.inviteAcceptedAt, inviteAcceptedAt) || other.inviteAcceptedAt == inviteAcceptedAt) &&
            (identical(other.inviteRejectedAt, inviteRejectedAt) || other.inviteRejectedAt == inviteRejectedAt) &&
            (identical(other.invited, invited) || other.invited == invited) &&
            (identical(other.channelRole, channelRole) || other.channelRole == channelRole) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.isModerator, isModerator) || other.isModerator == isModerator) &&
            (identical(other.banned, banned) || other.banned == banned) &&
            (identical(other.banExpires, banExpires) || other.banExpires == banExpires) &&
            (identical(other.shadowBanned, shadowBanned) || other.shadowBanned == shadowBanned) &&
            (identical(other.pinnedAt, pinnedAt) || other.pinnedAt == pinnedAt) &&
            (identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.deletedMessages, deletedMessages) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.notificationsMuted, notificationsMuted) ||
                other.notificationsMuted == notificationsMuted) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.banFromFutureChannels, banFromFutureChannels) ||
                other.banFromFutureChannels == banFromFutureChannels) &&
            (identical(other.futureChannelBanExpires, futureChannelBanExpires) ||
                other.futureChannelBanExpires == futureChannelBanExpires) &&
            (identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
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
    const DeepCollectionEquality().hash(deletedMessages),
    const DeepCollectionEquality().hash(custom),
    notificationsMuted,
    status,
    banFromFutureChannels,
    futureChannelBanExpires,
    deletedAt,
  ]);

  @override
  String toString() {
    return 'Member(user: $user, inviteAcceptedAt: $inviteAcceptedAt, inviteRejectedAt: $inviteRejectedAt, invited: $invited, channelRole: $channelRole, userId: $userId, isModerator: $isModerator, banned: $banned, banExpires: $banExpires, shadowBanned: $shadowBanned, pinnedAt: $pinnedAt, archivedAt: $archivedAt, createdAt: $createdAt, updatedAt: $updatedAt, deletedMessages: $deletedMessages, custom: $custom, notificationsMuted: $notificationsMuted, status: $status, banFromFutureChannels: $banFromFutureChannels, futureChannelBanExpires: $futureChannelBanExpires, deletedAt: $deletedAt)';
  }
}

/// @nodoc
abstract mixin class $MemberCopyWith<$Res> {
  factory $MemberCopyWith(Member value, $Res Function(Member) _then) = _$MemberCopyWithImpl;
  @useResult
  $Res call({
    User? user,
    DateTime? inviteAcceptedAt,
    DateTime? inviteRejectedAt,
    bool invited,
    String? channelRole,
    String? userId,
    bool isModerator,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool banned,
    DateTime? banExpires,
    bool shadowBanned,
    DateTime? pinnedAt,
    DateTime? archivedAt,
    List<String> deletedMessages,
    Map<String, Object?> custom,
    bool? notificationsMuted,
    String? status,
    bool? banFromFutureChannels,
    DateTime? futureChannelBanExpires,
    DateTime? deletedAt,
  });
}

/// @nodoc
class _$MemberCopyWithImpl<$Res> implements $MemberCopyWith<$Res> {
  _$MemberCopyWithImpl(this._self, this._then);

  final Member _self;
  final $Res Function(Member) _then;

  /// Create a copy of Member
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? inviteAcceptedAt = freezed,
    Object? inviteRejectedAt = freezed,
    Object? invited = null,
    Object? channelRole = freezed,
    Object? userId = freezed,
    Object? isModerator = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? banned = null,
    Object? banExpires = freezed,
    Object? shadowBanned = null,
    Object? pinnedAt = freezed,
    Object? archivedAt = freezed,
    Object? deletedMessages = null,
    Object? custom = null,
    Object? notificationsMuted = freezed,
    Object? status = freezed,
    Object? banFromFutureChannels = freezed,
    Object? futureChannelBanExpires = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(
      Member(
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
        inviteAcceptedAt: freezed == inviteAcceptedAt
            ? _self.inviteAcceptedAt
            : inviteAcceptedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        inviteRejectedAt: freezed == inviteRejectedAt
            ? _self.inviteRejectedAt
            : inviteRejectedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        invited: null == invited
            ? _self.invited
            : invited // ignore: cast_nullable_to_non_nullable
                  as bool,
        channelRole: freezed == channelRole
            ? _self.channelRole
            : channelRole // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: freezed == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isModerator: null == isModerator
            ? _self.isModerator
            : isModerator // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _self.updatedAt!
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        banned: null == banned
            ? _self.banned
            : banned // ignore: cast_nullable_to_non_nullable
                  as bool,
        banExpires: freezed == banExpires
            ? _self.banExpires
            : banExpires // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        shadowBanned: null == shadowBanned
            ? _self.shadowBanned
            : shadowBanned // ignore: cast_nullable_to_non_nullable
                  as bool,
        pinnedAt: freezed == pinnedAt
            ? _self.pinnedAt
            : pinnedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        archivedAt: freezed == archivedAt
            ? _self.archivedAt
            : archivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deletedMessages: null == deletedMessages
            ? _self.deletedMessages
            : deletedMessages // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        notificationsMuted: freezed == notificationsMuted
            ? _self.notificationsMuted
            : notificationsMuted // ignore: cast_nullable_to_non_nullable
                  as bool?,
        status: freezed == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        banFromFutureChannels: freezed == banFromFutureChannels
            ? _self.banFromFutureChannels
            : banFromFutureChannels // ignore: cast_nullable_to_non_nullable
                  as bool?,
        futureChannelBanExpires: freezed == futureChannelBanExpires
            ? _self.futureChannelBanExpires
            : futureChannelBanExpires // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deletedAt: freezed == deletedAt
            ? _self.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}
