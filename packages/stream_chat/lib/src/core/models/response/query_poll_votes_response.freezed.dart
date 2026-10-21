// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_poll_votes_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryPollVotesResponse {
  String get duration;
  List<PollVote> get votes;
  String? get next;
  String? get prev;

  /// Create a copy of QueryPollVotesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryPollVotesResponseCopyWith<QueryPollVotesResponse> get copyWith =>
      _$QueryPollVotesResponseCopyWithImpl<QueryPollVotesResponse>(this as QueryPollVotesResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryPollVotesResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            const DeepCollectionEquality().equals(other.votes, votes) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.prev, prev) || other.prev == prev));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, const DeepCollectionEquality().hash(votes), next, prev);

  @override
  String toString() {
    return 'QueryPollVotesResponse(duration: $duration, votes: $votes, next: $next, prev: $prev)';
  }
}

/// @nodoc
abstract mixin class $QueryPollVotesResponseCopyWith<$Res> {
  factory $QueryPollVotesResponseCopyWith(QueryPollVotesResponse value, $Res Function(QueryPollVotesResponse) _then) =
      _$QueryPollVotesResponseCopyWithImpl;
  @useResult
  $Res call({String duration, List<PollVote> votes, String? next, String? prev});
}

/// @nodoc
class _$QueryPollVotesResponseCopyWithImpl<$Res> implements $QueryPollVotesResponseCopyWith<$Res> {
  _$QueryPollVotesResponseCopyWithImpl(this._self, this._then);

  final QueryPollVotesResponse _self;
  final $Res Function(QueryPollVotesResponse) _then;

  /// Create a copy of QueryPollVotesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? votes = null, Object? next = freezed, Object? prev = freezed}) {
    return _then(
      QueryPollVotesResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        votes: null == votes
            ? _self.votes
            : votes // ignore: cast_nullable_to_non_nullable
                  as List<PollVote>,
        next: freezed == next
            ? _self.next
            : next // ignore: cast_nullable_to_non_nullable
                  as String?,
        prev: freezed == prev
            ? _self.prev
            : prev // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
