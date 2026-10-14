// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_replies_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetRepliesResponse {
  String get duration;
  List<MessageResponse> get messages;

  /// Create a copy of GetRepliesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GetRepliesResponseCopyWith<GetRepliesResponse> get copyWith => _$GetRepliesResponseCopyWithImpl<GetRepliesResponse>(
    this as GetRepliesResponse,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GetRepliesResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            const DeepCollectionEquality().equals(other.messages, messages));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    const DeepCollectionEquality().hash(messages),
  );

  @override
  String toString() {
    return 'GetRepliesResponse(duration: $duration, messages: $messages)';
  }
}

/// @nodoc
abstract mixin class $GetRepliesResponseCopyWith<$Res> {
  factory $GetRepliesResponseCopyWith(
    GetRepliesResponse value,
    $Res Function(GetRepliesResponse) _then,
  ) = _$GetRepliesResponseCopyWithImpl;
  @useResult
  $Res call({String duration, List<MessageResponse> messages});
}

/// @nodoc
class _$GetRepliesResponseCopyWithImpl<$Res> implements $GetRepliesResponseCopyWith<$Res> {
  _$GetRepliesResponseCopyWithImpl(this._self, this._then);

  final GetRepliesResponse _self;
  final $Res Function(GetRepliesResponse) _then;

  /// Create a copy of GetRepliesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? messages = null}) {
    return _then(
      GetRepliesResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        messages: null == messages
            ? _self.messages
            : messages // ignore: cast_nullable_to_non_nullable
                  as List<MessageResponse>,
      ),
    );
  }
}
