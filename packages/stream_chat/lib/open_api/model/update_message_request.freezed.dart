// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_message_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateMessageRequest {
  MessageRequest get message;
  bool? get skipEnrichUrl;
  bool? get skipPush;

  /// Create a copy of UpdateMessageRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateMessageRequestCopyWith<UpdateMessageRequest> get copyWith =>
      _$UpdateMessageRequestCopyWithImpl<UpdateMessageRequest>(
        this as UpdateMessageRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateMessageRequest &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.skipEnrichUrl, skipEnrichUrl) ||
                other.skipEnrichUrl == skipEnrichUrl) &&
            (identical(other.skipPush, skipPush) ||
                other.skipPush == skipPush));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, message, skipEnrichUrl, skipPush);

  @override
  String toString() {
    return 'UpdateMessageRequest(message: $message, skipEnrichUrl: $skipEnrichUrl, skipPush: $skipPush)';
  }
}

/// @nodoc
abstract mixin class $UpdateMessageRequestCopyWith<$Res> {
  factory $UpdateMessageRequestCopyWith(
    UpdateMessageRequest value,
    $Res Function(UpdateMessageRequest) _then,
  ) = _$UpdateMessageRequestCopyWithImpl;
  @useResult
  $Res call({MessageRequest message, bool? skipEnrichUrl, bool? skipPush});
}

/// @nodoc
class _$UpdateMessageRequestCopyWithImpl<$Res>
    implements $UpdateMessageRequestCopyWith<$Res> {
  _$UpdateMessageRequestCopyWithImpl(this._self, this._then);

  final UpdateMessageRequest _self;
  final $Res Function(UpdateMessageRequest) _then;

  /// Create a copy of UpdateMessageRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? skipEnrichUrl = freezed,
    Object? skipPush = freezed,
  }) {
    return _then(
      UpdateMessageRequest(
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageRequest,
        skipEnrichUrl: freezed == skipEnrichUrl
            ? _self.skipEnrichUrl
            : skipEnrichUrl // ignore: cast_nullable_to_non_nullable
                  as bool?,
        skipPush: freezed == skipPush
            ? _self.skipPush
            : skipPush // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
