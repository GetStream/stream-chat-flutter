// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'duration_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DurationResponse {
  String get duration;

  /// Create a copy of DurationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DurationResponseCopyWith<DurationResponse> get copyWith =>
      _$DurationResponseCopyWithImpl<DurationResponse>(
        this as DurationResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DurationResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration);

  @override
  String toString() {
    return 'DurationResponse(duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $DurationResponseCopyWith<$Res> {
  factory $DurationResponseCopyWith(
    DurationResponse value,
    $Res Function(DurationResponse) _then,
  ) = _$DurationResponseCopyWithImpl;
  @useResult
  $Res call({String duration});
}

/// @nodoc
class _$DurationResponseCopyWithImpl<$Res>
    implements $DurationResponseCopyWith<$Res> {
  _$DurationResponseCopyWithImpl(this._self, this._then);

  final DurationResponse _self;
  final $Res Function(DurationResponse) _then;

  /// Create a copy of DurationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null}) {
    return _then(
      DurationResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
