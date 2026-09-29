// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_threads_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryThreadsResponse {
  String get duration;
  String? get next;
  String? get prev;
  List<ThreadStateResponse> get threads;

  /// Create a copy of QueryThreadsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryThreadsResponseCopyWith<QueryThreadsResponse> get copyWith =>
      _$QueryThreadsResponseCopyWithImpl<QueryThreadsResponse>(
        this as QueryThreadsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryThreadsResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.prev, prev) || other.prev == prev) &&
            const DeepCollectionEquality().equals(other.threads, threads));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    next,
    prev,
    const DeepCollectionEquality().hash(threads),
  );

  @override
  String toString() {
    return 'QueryThreadsResponse(duration: $duration, next: $next, prev: $prev, threads: $threads)';
  }
}

/// @nodoc
abstract mixin class $QueryThreadsResponseCopyWith<$Res> {
  factory $QueryThreadsResponseCopyWith(
    QueryThreadsResponse value,
    $Res Function(QueryThreadsResponse) _then,
  ) = _$QueryThreadsResponseCopyWithImpl;
  @useResult
  $Res call({
    String duration,
    String? next,
    String? prev,
    List<ThreadStateResponse> threads,
  });
}

/// @nodoc
class _$QueryThreadsResponseCopyWithImpl<$Res> implements $QueryThreadsResponseCopyWith<$Res> {
  _$QueryThreadsResponseCopyWithImpl(this._self, this._then);

  final QueryThreadsResponse _self;
  final $Res Function(QueryThreadsResponse) _then;

  /// Create a copy of QueryThreadsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? next = freezed,
    Object? prev = freezed,
    Object? threads = null,
  }) {
    return _then(
      QueryThreadsResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        next: freezed == next
            ? _self.next
            : next // ignore: cast_nullable_to_non_nullable
                  as String?,
        prev: freezed == prev
            ? _self.prev
            : prev // ignore: cast_nullable_to_non_nullable
                  as String?,
        threads: null == threads
            ? _self.threads
            : threads // ignore: cast_nullable_to_non_nullable
                  as List<ThreadStateResponse>,
      ),
    );
  }
}
