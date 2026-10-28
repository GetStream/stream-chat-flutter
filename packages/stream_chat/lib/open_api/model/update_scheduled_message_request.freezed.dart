// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_scheduled_message_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateScheduledMessageRequest {
  MessageRequest? get message;
  DateTime? get scheduledAt;

  /// Create a copy of UpdateScheduledMessageRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateScheduledMessageRequestCopyWith<UpdateScheduledMessageRequest> get copyWith =>
      _$UpdateScheduledMessageRequestCopyWithImpl<UpdateScheduledMessageRequest>(
        this as UpdateScheduledMessageRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateScheduledMessageRequest &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, scheduledAt);

  @override
  String toString() {
    return 'UpdateScheduledMessageRequest(message: $message, scheduledAt: $scheduledAt)';
  }
}

/// @nodoc
abstract mixin class $UpdateScheduledMessageRequestCopyWith<$Res> {
  factory $UpdateScheduledMessageRequestCopyWith(
    UpdateScheduledMessageRequest value,
    $Res Function(UpdateScheduledMessageRequest) _then,
  ) = _$UpdateScheduledMessageRequestCopyWithImpl;
  @useResult
  $Res call({MessageRequest? message, DateTime? scheduledAt});
}

/// @nodoc
class _$UpdateScheduledMessageRequestCopyWithImpl<$Res> implements $UpdateScheduledMessageRequestCopyWith<$Res> {
  _$UpdateScheduledMessageRequestCopyWithImpl(this._self, this._then);

  final UpdateScheduledMessageRequest _self;
  final $Res Function(UpdateScheduledMessageRequest) _then;

  /// Create a copy of UpdateScheduledMessageRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = freezed, Object? scheduledAt = freezed}) {
    return _then(
      UpdateScheduledMessageRequest(
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageRequest?,
        scheduledAt: freezed == scheduledAt
            ? _self.scheduledAt
            : scheduledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}
