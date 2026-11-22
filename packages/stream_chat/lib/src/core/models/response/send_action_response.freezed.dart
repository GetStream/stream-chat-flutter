// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_action_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SendActionResponse {
  String get duration;
  Message? get message;

  /// Create a copy of SendActionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SendActionResponseCopyWith<SendActionResponse> get copyWith =>
      _$SendActionResponseCopyWithImpl<SendActionResponse>(this as SendActionResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SendActionResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, message);

  @override
  String toString() {
    return 'SendActionResponse(duration: $duration, message: $message)';
  }
}

/// @nodoc
abstract mixin class $SendActionResponseCopyWith<$Res> {
  factory $SendActionResponseCopyWith(SendActionResponse value, $Res Function(SendActionResponse) _then) =
      _$SendActionResponseCopyWithImpl;
  @useResult
  $Res call({String duration, Message? message});
}

/// @nodoc
class _$SendActionResponseCopyWithImpl<$Res> implements $SendActionResponseCopyWith<$Res> {
  _$SendActionResponseCopyWithImpl(this._self, this._then);

  final SendActionResponse _self;
  final $Res Function(SendActionResponse) _then;

  /// Create a copy of SendActionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? message = freezed}) {
    return _then(
      SendActionResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as Message?,
      ),
    );
  }
}
