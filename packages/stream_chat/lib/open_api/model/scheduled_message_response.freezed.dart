// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheduled_message_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduledMessageResponse {
  String get cid;
  DateTime get createdAt;
  String? get failureReason;
  String get id;
  ScheduledMessageContentResponse get message;
  DateTime get scheduledAt;
  String get status;
  DateTime get updatedAt;
  UserResponse get user;

  /// Create a copy of ScheduledMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduledMessageResponseCopyWith<ScheduledMessageResponse> get copyWith =>
      _$ScheduledMessageResponseCopyWithImpl<ScheduledMessageResponse>(
        this as ScheduledMessageResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScheduledMessageResponse &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.failureReason, failureReason) || other.failureReason == failureReason) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    createdAt,
    failureReason,
    id,
    message,
    scheduledAt,
    status,
    updatedAt,
    user,
  );

  @override
  String toString() {
    return 'ScheduledMessageResponse(cid: $cid, createdAt: $createdAt, failureReason: $failureReason, id: $id, message: $message, scheduledAt: $scheduledAt, status: $status, updatedAt: $updatedAt, user: $user)';
  }
}

/// @nodoc
abstract mixin class $ScheduledMessageResponseCopyWith<$Res> {
  factory $ScheduledMessageResponseCopyWith(
    ScheduledMessageResponse value,
    $Res Function(ScheduledMessageResponse) _then,
  ) = _$ScheduledMessageResponseCopyWithImpl;
  @useResult
  $Res call({
    String cid,
    DateTime createdAt,
    String? failureReason,
    String id,
    ScheduledMessageContentResponse message,
    DateTime scheduledAt,
    String status,
    DateTime updatedAt,
    UserResponse user,
  });
}

/// @nodoc
class _$ScheduledMessageResponseCopyWithImpl<$Res> implements $ScheduledMessageResponseCopyWith<$Res> {
  _$ScheduledMessageResponseCopyWithImpl(this._self, this._then);

  final ScheduledMessageResponse _self;
  final $Res Function(ScheduledMessageResponse) _then;

  /// Create a copy of ScheduledMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = null,
    Object? createdAt = null,
    Object? failureReason = freezed,
    Object? id = null,
    Object? message = null,
    Object? scheduledAt = null,
    Object? status = null,
    Object? updatedAt = null,
    Object? user = null,
  }) {
    return _then(
      ScheduledMessageResponse(
        cid: null == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        failureReason: freezed == failureReason
            ? _self.failureReason
            : failureReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as ScheduledMessageContentResponse,
        scheduledAt: null == scheduledAt
            ? _self.scheduledAt
            : scheduledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse,
      ),
    );
  }
}
