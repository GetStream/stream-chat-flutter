// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shared_location_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SharedLocationResponse {
  String get duration;
  Location get location;

  /// Create a copy of SharedLocationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SharedLocationResponseCopyWith<SharedLocationResponse> get copyWith =>
      _$SharedLocationResponseCopyWithImpl<SharedLocationResponse>(
        this as SharedLocationResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SharedLocationResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, location);

  @override
  String toString() {
    return 'SharedLocationResponse(duration: $duration, location: $location)';
  }
}

/// @nodoc
abstract mixin class $SharedLocationResponseCopyWith<$Res> {
  factory $SharedLocationResponseCopyWith(
    SharedLocationResponse value,
    $Res Function(SharedLocationResponse) _then,
  ) = _$SharedLocationResponseCopyWithImpl;
  @useResult
  $Res call({String duration, Location location});
}

/// @nodoc
class _$SharedLocationResponseCopyWithImpl<$Res>
    implements $SharedLocationResponseCopyWith<$Res> {
  _$SharedLocationResponseCopyWithImpl(this._self, this._then);

  final SharedLocationResponse _self;
  final $Res Function(SharedLocationResponse) _then;

  /// Create a copy of SharedLocationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? location = null}) {
    return _then(
      SharedLocationResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        location: null == location
            ? _self.location
            : location // ignore: cast_nullable_to_non_nullable
                  as Location,
      ),
    );
  }
}
