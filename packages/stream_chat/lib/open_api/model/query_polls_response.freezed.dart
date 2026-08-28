// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_polls_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryPollsResponse {
  String get duration;
  String? get next;
  List<PollResponseData> get polls;
  String? get prev;

  /// Create a copy of QueryPollsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryPollsResponseCopyWith<QueryPollsResponse> get copyWith =>
      _$QueryPollsResponseCopyWithImpl<QueryPollsResponse>(
        this as QueryPollsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryPollsResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.next, next) || other.next == next) &&
            const DeepCollectionEquality().equals(other.polls, polls) &&
            (identical(other.prev, prev) || other.prev == prev));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    next,
    const DeepCollectionEquality().hash(polls),
    prev,
  );

  @override
  String toString() {
    return 'QueryPollsResponse(duration: $duration, next: $next, polls: $polls, prev: $prev)';
  }
}

/// @nodoc
abstract mixin class $QueryPollsResponseCopyWith<$Res> {
  factory $QueryPollsResponseCopyWith(
    QueryPollsResponse value,
    $Res Function(QueryPollsResponse) _then,
  ) = _$QueryPollsResponseCopyWithImpl;
  @useResult
  $Res call({
    String duration,
    String? next,
    List<PollResponseData> polls,
    String? prev,
  });
}

/// @nodoc
class _$QueryPollsResponseCopyWithImpl<$Res>
    implements $QueryPollsResponseCopyWith<$Res> {
  _$QueryPollsResponseCopyWithImpl(this._self, this._then);

  final QueryPollsResponse _self;
  final $Res Function(QueryPollsResponse) _then;

  /// Create a copy of QueryPollsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? next = freezed,
    Object? polls = null,
    Object? prev = freezed,
  }) {
    return _then(
      QueryPollsResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        next: freezed == next
            ? _self.next
            : next // ignore: cast_nullable_to_non_nullable
                  as String?,
        polls: null == polls
            ? _self.polls
            : polls // ignore: cast_nullable_to_non_nullable
                  as List<PollResponseData>,
        prev: freezed == prev
            ? _self.prev
            : prev // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
