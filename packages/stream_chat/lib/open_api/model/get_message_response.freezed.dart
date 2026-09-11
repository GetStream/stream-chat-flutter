// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_message_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetMessageResponse {
  String get duration;
  MessageWithChannelResponse get message;

  /// Create a copy of GetMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GetMessageResponseCopyWith<GetMessageResponse> get copyWith => _$GetMessageResponseCopyWithImpl<GetMessageResponse>(
    this as GetMessageResponse,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GetMessageResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, message);

  @override
  String toString() {
    return 'GetMessageResponse(duration: $duration, message: $message)';
  }
}

/// @nodoc
abstract mixin class $GetMessageResponseCopyWith<$Res> {
  factory $GetMessageResponseCopyWith(
    GetMessageResponse value,
    $Res Function(GetMessageResponse) _then,
  ) = _$GetMessageResponseCopyWithImpl;
  @useResult
  $Res call({String duration, MessageWithChannelResponse message});
}

/// @nodoc
class _$GetMessageResponseCopyWithImpl<$Res> implements $GetMessageResponseCopyWith<$Res> {
  _$GetMessageResponseCopyWithImpl(this._self, this._then);

  final GetMessageResponse _self;
  final $Res Function(GetMessageResponse) _then;

  /// Create a copy of GetMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? message = null}) {
    return _then(
      GetMessageResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageWithChannelResponse,
      ),
    );
  }
}
