// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_watching_start_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserWatchingStartEvent {
  String? get channelId;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields get user;
  int get watcherCount;

  /// Create a copy of UserWatchingStartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserWatchingStartEventCopyWith<UserWatchingStartEvent> get copyWith =>
      _$UserWatchingStartEventCopyWithImpl<UserWatchingStartEvent>(
        this as UserWatchingStartEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserWatchingStartEvent &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.watcherCount, watcherCount) || other.watcherCount == watcherCount));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelId,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
    user,
    watcherCount,
  );

  @override
  String toString() {
    return 'UserWatchingStartEvent(channelId: $channelId, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type, user: $user, watcherCount: $watcherCount)';
  }
}

/// @nodoc
abstract mixin class $UserWatchingStartEventCopyWith<$Res> {
  factory $UserWatchingStartEventCopyWith(
    UserWatchingStartEvent value,
    $Res Function(UserWatchingStartEvent) _then,
  ) = _$UserWatchingStartEventCopyWithImpl;
  @useResult
  $Res call({
    String? channelId,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields user,
    int watcherCount,
  });
}

/// @nodoc
class _$UserWatchingStartEventCopyWithImpl<$Res> implements $UserWatchingStartEventCopyWith<$Res> {
  _$UserWatchingStartEventCopyWithImpl(this._self, this._then);

  final UserWatchingStartEvent _self;
  final $Res Function(UserWatchingStartEvent) _then;

  /// Create a copy of UserWatchingStartEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = null,
    Object? watcherCount = null,
  }) {
    return _then(
      UserWatchingStartEvent(
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
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
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields,
        watcherCount: null == watcherCount
            ? _self.watcherCount
            : watcherCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
