// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PollResponse {
  String get duration;
  PollResponseData get poll;

  /// Create a copy of PollResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollResponseCopyWith<PollResponse> get copyWith =>
      _$PollResponseCopyWithImpl<PollResponse>(
        this as PollResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.poll, poll) || other.poll == poll));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, poll);

  @override
  String toString() {
    return 'PollResponse(duration: $duration, poll: $poll)';
  }
}

/// @nodoc
abstract mixin class $PollResponseCopyWith<$Res> {
  factory $PollResponseCopyWith(
    PollResponse value,
    $Res Function(PollResponse) _then,
  ) = _$PollResponseCopyWithImpl;
  @useResult
  $Res call({String duration, PollResponseData poll});
}

/// @nodoc
class _$PollResponseCopyWithImpl<$Res> implements $PollResponseCopyWith<$Res> {
  _$PollResponseCopyWithImpl(this._self, this._then);

  final PollResponse _self;
  final $Res Function(PollResponse) _then;

  /// Create a copy of PollResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? poll = null}) {
    return _then(
      PollResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        poll: null == poll
            ? _self.poll
            : poll // ignore: cast_nullable_to_non_nullable
                  as PollResponseData,
      ),
    );
  }
}
