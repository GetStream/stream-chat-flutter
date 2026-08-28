// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'block_users_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockUsersResponse {
  String get blockedByUserId;
  String get blockedUserId;
  DateTime get createdAt;
  String get duration;

  /// Create a copy of BlockUsersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlockUsersResponseCopyWith<BlockUsersResponse> get copyWith =>
      _$BlockUsersResponseCopyWithImpl<BlockUsersResponse>(
        this as BlockUsersResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlockUsersResponse &&
            (identical(other.blockedByUserId, blockedByUserId) ||
                other.blockedByUserId == blockedByUserId) &&
            (identical(other.blockedUserId, blockedUserId) ||
                other.blockedUserId == blockedUserId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    blockedByUserId,
    blockedUserId,
    createdAt,
    duration,
  );

  @override
  String toString() {
    return 'BlockUsersResponse(blockedByUserId: $blockedByUserId, blockedUserId: $blockedUserId, createdAt: $createdAt, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $BlockUsersResponseCopyWith<$Res> {
  factory $BlockUsersResponseCopyWith(
    BlockUsersResponse value,
    $Res Function(BlockUsersResponse) _then,
  ) = _$BlockUsersResponseCopyWithImpl;
  @useResult
  $Res call({
    String blockedByUserId,
    String blockedUserId,
    DateTime createdAt,
    String duration,
  });
}

/// @nodoc
class _$BlockUsersResponseCopyWithImpl<$Res>
    implements $BlockUsersResponseCopyWith<$Res> {
  _$BlockUsersResponseCopyWithImpl(this._self, this._then);

  final BlockUsersResponse _self;
  final $Res Function(BlockUsersResponse) _then;

  /// Create a copy of BlockUsersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blockedByUserId = null,
    Object? blockedUserId = null,
    Object? createdAt = null,
    Object? duration = null,
  }) {
    return _then(
      BlockUsersResponse(
        blockedByUserId: null == blockedByUserId
            ? _self.blockedByUserId
            : blockedByUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        blockedUserId: null == blockedUserId
            ? _self.blockedUserId
            : blockedUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
