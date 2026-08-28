// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_banned_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserBannedEvent {
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  UserResponseCommonFields? get createdBy;
  Map<String, Object?> get custom;
  DateTime? get expiration;
  String? get reason;
  DateTime? get receivedAt;
  String? get reviewQueueItemId;
  bool? get shadow;
  String? get team;
  int? get totalBans;
  String get type;
  UserResponseCommonFields get user;

  /// Create a copy of UserBannedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserBannedEventCopyWith<UserBannedEvent> get copyWith =>
      _$UserBannedEventCopyWithImpl<UserBannedEvent>(
        this as UserBannedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserBannedEvent &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) ||
                other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.expiration, expiration) ||
                other.expiration == expiration) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.reviewQueueItemId, reviewQueueItemId) ||
                other.reviewQueueItemId == reviewQueueItemId) &&
            (identical(other.shadow, shadow) || other.shadow == shadow) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.totalBans, totalBans) ||
                other.totalBans == totalBans) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    createdBy,
    const DeepCollectionEquality().hash(custom),
    expiration,
    reason,
    receivedAt,
    reviewQueueItemId,
    shadow,
    team,
    totalBans,
    type,
    user,
  );

  @override
  String toString() {
    return 'UserBannedEvent(channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, createdBy: $createdBy, custom: $custom, expiration: $expiration, reason: $reason, receivedAt: $receivedAt, reviewQueueItemId: $reviewQueueItemId, shadow: $shadow, team: $team, totalBans: $totalBans, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UserBannedEventCopyWith<$Res> {
  factory $UserBannedEventCopyWith(
    UserBannedEvent value,
    $Res Function(UserBannedEvent) _then,
  ) = _$UserBannedEventCopyWithImpl;
  @useResult
  $Res call({
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    UserResponseCommonFields? createdBy,
    Map<String, Object?> custom,
    DateTime? expiration,
    String? reason,
    DateTime? receivedAt,
    String? reviewQueueItemId,
    bool? shadow,
    String? team,
    int? totalBans,
    String type,
    UserResponseCommonFields user,
  });
}

/// @nodoc
class _$UserBannedEventCopyWithImpl<$Res>
    implements $UserBannedEventCopyWith<$Res> {
  _$UserBannedEventCopyWithImpl(this._self, this._then);

  final UserBannedEvent _self;
  final $Res Function(UserBannedEvent) _then;

  /// Create a copy of UserBannedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? createdBy = freezed,
    Object? custom = null,
    Object? expiration = freezed,
    Object? reason = freezed,
    Object? receivedAt = freezed,
    Object? reviewQueueItemId = freezed,
    Object? shadow = freezed,
    Object? team = freezed,
    Object? totalBans = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserBannedEvent(
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: freezed == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        expiration: freezed == expiration
            ? _self.expiration
            : expiration // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reviewQueueItemId: freezed == reviewQueueItemId
            ? _self.reviewQueueItemId
            : reviewQueueItemId // ignore: cast_nullable_to_non_nullable
                  as String?,
        shadow: freezed == shadow
            ? _self.shadow
            : shadow // ignore: cast_nullable_to_non_nullable
                  as bool?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalBans: freezed == totalBans
            ? _self.totalBans
            : totalBans // ignore: cast_nullable_to_non_nullable
                  as int?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields,
      ),
    );
  }
}
