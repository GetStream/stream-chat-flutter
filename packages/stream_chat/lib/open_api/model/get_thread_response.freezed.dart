// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_thread_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetThreadResponse {
  String get duration;
  ThreadStateResponse get thread;

  /// Create a copy of GetThreadResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GetThreadResponseCopyWith<GetThreadResponse> get copyWith => _$GetThreadResponseCopyWithImpl<GetThreadResponse>(
    this as GetThreadResponse,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GetThreadResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.thread, thread) || other.thread == thread));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, thread);

  @override
  String toString() {
    return 'GetThreadResponse(duration: $duration, thread: $thread)';
  }
}

/// @nodoc
abstract mixin class $GetThreadResponseCopyWith<$Res> {
  factory $GetThreadResponseCopyWith(
    GetThreadResponse value,
    $Res Function(GetThreadResponse) _then,
  ) = _$GetThreadResponseCopyWithImpl;
  @useResult
  $Res call({String duration, ThreadStateResponse thread});
}

/// @nodoc
class _$GetThreadResponseCopyWithImpl<$Res> implements $GetThreadResponseCopyWith<$Res> {
  _$GetThreadResponseCopyWithImpl(this._self, this._then);

  final GetThreadResponse _self;
  final $Res Function(GetThreadResponse) _then;

  /// Create a copy of GetThreadResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? thread = null}) {
    return _then(
      GetThreadResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        thread: null == thread
            ? _self.thread
            : thread // ignore: cast_nullable_to_non_nullable
                  as ThreadStateResponse,
      ),
    );
  }
}
