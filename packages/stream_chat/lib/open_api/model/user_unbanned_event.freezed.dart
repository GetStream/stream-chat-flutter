// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_unbanned_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserUnbannedEvent {
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  UserResponseCommonFields? get createdBy;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  bool? get shadow;
  String? get team;
  String get type;
  UserResponseCommonFields get user;

  /// Create a copy of UserUnbannedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserUnbannedEventCopyWith<UserUnbannedEvent> get copyWith =>
      _$UserUnbannedEventCopyWithImpl<UserUnbannedEvent>(
        this as UserUnbannedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserUnbannedEvent &&
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
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.shadow, shadow) || other.shadow == shadow) &&
            (identical(other.team, team) || other.team == team) &&
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
    receivedAt,
    shadow,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'UserUnbannedEvent(channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, createdBy: $createdBy, custom: $custom, receivedAt: $receivedAt, shadow: $shadow, team: $team, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UserUnbannedEventCopyWith<$Res> {
  factory $UserUnbannedEventCopyWith(
    UserUnbannedEvent value,
    $Res Function(UserUnbannedEvent) _then,
  ) = _$UserUnbannedEventCopyWithImpl;
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
    DateTime? receivedAt,
    bool? shadow,
    String? team,
    String type,
    UserResponseCommonFields user,
  });
}

/// @nodoc
class _$UserUnbannedEventCopyWithImpl<$Res>
    implements $UserUnbannedEventCopyWith<$Res> {
  _$UserUnbannedEventCopyWithImpl(this._self, this._then);

  final UserUnbannedEvent _self;
  final $Res Function(UserUnbannedEvent) _then;

  /// Create a copy of UserUnbannedEvent
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
    Object? receivedAt = freezed,
    Object? shadow = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserUnbannedEvent(
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
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        shadow: freezed == shadow
            ? _self.shadow
            : shadow // ignore: cast_nullable_to_non_nullable
                  as bool?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
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
