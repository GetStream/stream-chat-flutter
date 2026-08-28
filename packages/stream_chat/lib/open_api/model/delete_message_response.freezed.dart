// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_message_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeleteMessageResponse {
  String get duration;
  MessageResponse get message;

  /// Create a copy of DeleteMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeleteMessageResponseCopyWith<DeleteMessageResponse> get copyWith =>
      _$DeleteMessageResponseCopyWithImpl<DeleteMessageResponse>(
        this as DeleteMessageResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeleteMessageResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, message);

  @override
  String toString() {
    return 'DeleteMessageResponse(duration: $duration, message: $message)';
  }
}

/// @nodoc
abstract mixin class $DeleteMessageResponseCopyWith<$Res> {
  factory $DeleteMessageResponseCopyWith(
    DeleteMessageResponse value,
    $Res Function(DeleteMessageResponse) _then,
  ) = _$DeleteMessageResponseCopyWithImpl;
  @useResult
  $Res call({String duration, MessageResponse message});
}

/// @nodoc
class _$DeleteMessageResponseCopyWithImpl<$Res>
    implements $DeleteMessageResponseCopyWith<$Res> {
  _$DeleteMessageResponseCopyWithImpl(this._self, this._then);

  final DeleteMessageResponse _self;
  final $Res Function(DeleteMessageResponse) _then;

  /// Create a copy of DeleteMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? message = null}) {
    return _then(
      DeleteMessageResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse,
      ),
    );
  }
}
