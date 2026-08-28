// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll_option_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PollOptionResponse {
  String get duration;
  PollOptionResponseData get pollOption;

  /// Create a copy of PollOptionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollOptionResponseCopyWith<PollOptionResponse> get copyWith =>
      _$PollOptionResponseCopyWithImpl<PollOptionResponse>(
        this as PollOptionResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollOptionResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.pollOption, pollOption) ||
                other.pollOption == pollOption));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, pollOption);

  @override
  String toString() {
    return 'PollOptionResponse(duration: $duration, pollOption: $pollOption)';
  }
}

/// @nodoc
abstract mixin class $PollOptionResponseCopyWith<$Res> {
  factory $PollOptionResponseCopyWith(
    PollOptionResponse value,
    $Res Function(PollOptionResponse) _then,
  ) = _$PollOptionResponseCopyWithImpl;
  @useResult
  $Res call({String duration, PollOptionResponseData pollOption});
}

/// @nodoc
class _$PollOptionResponseCopyWithImpl<$Res>
    implements $PollOptionResponseCopyWith<$Res> {
  _$PollOptionResponseCopyWithImpl(this._self, this._then);

  final PollOptionResponse _self;
  final $Res Function(PollOptionResponse) _then;

  /// Create a copy of PollOptionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? pollOption = null}) {
    return _then(
      PollOptionResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        pollOption: null == pollOption
            ? _self.pollOption
            : pollOption // ignore: cast_nullable_to_non_nullable
                  as PollOptionResponseData,
      ),
    );
  }
}
