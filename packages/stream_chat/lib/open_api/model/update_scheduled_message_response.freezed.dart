// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_scheduled_message_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateScheduledMessageResponse {
  String get duration;
  ScheduledMessageResponse get scheduledMessage;

  /// Create a copy of UpdateScheduledMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateScheduledMessageResponseCopyWith<UpdateScheduledMessageResponse> get copyWith =>
      _$UpdateScheduledMessageResponseCopyWithImpl<UpdateScheduledMessageResponse>(
        this as UpdateScheduledMessageResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateScheduledMessageResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.scheduledMessage, scheduledMessage) || other.scheduledMessage == scheduledMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, scheduledMessage);

  @override
  String toString() {
    return 'UpdateScheduledMessageResponse(duration: $duration, scheduledMessage: $scheduledMessage)';
  }
}

/// @nodoc
abstract mixin class $UpdateScheduledMessageResponseCopyWith<$Res> {
  factory $UpdateScheduledMessageResponseCopyWith(
    UpdateScheduledMessageResponse value,
    $Res Function(UpdateScheduledMessageResponse) _then,
  ) = _$UpdateScheduledMessageResponseCopyWithImpl;
  @useResult
  $Res call({String duration, ScheduledMessageResponse scheduledMessage});
}

/// @nodoc
class _$UpdateScheduledMessageResponseCopyWithImpl<$Res> implements $UpdateScheduledMessageResponseCopyWith<$Res> {
  _$UpdateScheduledMessageResponseCopyWithImpl(this._self, this._then);

  final UpdateScheduledMessageResponse _self;
  final $Res Function(UpdateScheduledMessageResponse) _then;

  /// Create a copy of UpdateScheduledMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? scheduledMessage = null}) {
    return _then(
      UpdateScheduledMessageResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        scheduledMessage: null == scheduledMessage
            ? _self.scheduledMessage
            : scheduledMessage // ignore: cast_nullable_to_non_nullable
                  as ScheduledMessageResponse,
      ),
    );
  }
}
