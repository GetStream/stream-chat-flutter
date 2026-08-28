// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll_votes_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PollVotesResponse {
  String get duration;
  String? get next;
  String? get prev;
  List<PollVoteResponseData> get votes;

  /// Create a copy of PollVotesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollVotesResponseCopyWith<PollVotesResponse> get copyWith =>
      _$PollVotesResponseCopyWithImpl<PollVotesResponse>(
        this as PollVotesResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollVotesResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.prev, prev) || other.prev == prev) &&
            const DeepCollectionEquality().equals(other.votes, votes));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    next,
    prev,
    const DeepCollectionEquality().hash(votes),
  );

  @override
  String toString() {
    return 'PollVotesResponse(duration: $duration, next: $next, prev: $prev, votes: $votes)';
  }
}

/// @nodoc
abstract mixin class $PollVotesResponseCopyWith<$Res> {
  factory $PollVotesResponseCopyWith(
    PollVotesResponse value,
    $Res Function(PollVotesResponse) _then,
  ) = _$PollVotesResponseCopyWithImpl;
  @useResult
  $Res call({
    String duration,
    String? next,
    String? prev,
    List<PollVoteResponseData> votes,
  });
}

/// @nodoc
class _$PollVotesResponseCopyWithImpl<$Res>
    implements $PollVotesResponseCopyWith<$Res> {
  _$PollVotesResponseCopyWithImpl(this._self, this._then);

  final PollVotesResponse _self;
  final $Res Function(PollVotesResponse) _then;

  /// Create a copy of PollVotesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? next = freezed,
    Object? prev = freezed,
    Object? votes = null,
  }) {
    return _then(
      PollVotesResponse(
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
        votes: null == votes
            ? _self.votes
            : votes // ignore: cast_nullable_to_non_nullable
                  as List<PollVoteResponseData>,
      ),
    );
  }
}
