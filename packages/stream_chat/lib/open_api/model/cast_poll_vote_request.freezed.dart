// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cast_poll_vote_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CastPollVoteRequest {
  VoteData? get vote;

  /// Create a copy of CastPollVoteRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CastPollVoteRequestCopyWith<CastPollVoteRequest> get copyWith =>
      _$CastPollVoteRequestCopyWithImpl<CastPollVoteRequest>(
        this as CastPollVoteRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CastPollVoteRequest &&
            (identical(other.vote, vote) || other.vote == vote));
  }

  @override
  int get hashCode => Object.hash(runtimeType, vote);

  @override
  String toString() {
    return 'CastPollVoteRequest(vote: $vote)';
  }
}

/// @nodoc
abstract mixin class $CastPollVoteRequestCopyWith<$Res> {
  factory $CastPollVoteRequestCopyWith(
    CastPollVoteRequest value,
    $Res Function(CastPollVoteRequest) _then,
  ) = _$CastPollVoteRequestCopyWithImpl;
  @useResult
  $Res call({VoteData? vote});
}

/// @nodoc
class _$CastPollVoteRequestCopyWithImpl<$Res> implements $CastPollVoteRequestCopyWith<$Res> {
  _$CastPollVoteRequestCopyWithImpl(this._self, this._then);

  final CastPollVoteRequest _self;
  final $Res Function(CastPollVoteRequest) _then;

  /// Create a copy of CastPollVoteRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? vote = freezed}) {
    return _then(
      CastPollVoteRequest(
        vote: freezed == vote
            ? _self.vote
            : vote // ignore: cast_nullable_to_non_nullable
                  as VoteData?,
      ),
    );
  }
}
