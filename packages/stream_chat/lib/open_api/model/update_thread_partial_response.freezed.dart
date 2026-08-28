// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_thread_partial_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateThreadPartialResponse {
  String get duration;
  ThreadResponse get thread;

  /// Create a copy of UpdateThreadPartialResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateThreadPartialResponseCopyWith<UpdateThreadPartialResponse>
  get copyWith =>
      _$UpdateThreadPartialResponseCopyWithImpl<UpdateThreadPartialResponse>(
        this as UpdateThreadPartialResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateThreadPartialResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.thread, thread) || other.thread == thread));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, thread);

  @override
  String toString() {
    return 'UpdateThreadPartialResponse(duration: $duration, thread: $thread)';
  }
}

/// @nodoc
abstract mixin class $UpdateThreadPartialResponseCopyWith<$Res> {
  factory $UpdateThreadPartialResponseCopyWith(
    UpdateThreadPartialResponse value,
    $Res Function(UpdateThreadPartialResponse) _then,
  ) = _$UpdateThreadPartialResponseCopyWithImpl;
  @useResult
  $Res call({String duration, ThreadResponse thread});
}

/// @nodoc
class _$UpdateThreadPartialResponseCopyWithImpl<$Res>
    implements $UpdateThreadPartialResponseCopyWith<$Res> {
  _$UpdateThreadPartialResponseCopyWithImpl(this._self, this._then);

  final UpdateThreadPartialResponse _self;
  final $Res Function(UpdateThreadPartialResponse) _then;

  /// Create a copy of UpdateThreadPartialResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? thread = null}) {
    return _then(
      UpdateThreadPartialResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        thread: null == thread
            ? _self.thread
            : thread // ignore: cast_nullable_to_non_nullable
                  as ThreadResponse,
      ),
    );
  }
}
