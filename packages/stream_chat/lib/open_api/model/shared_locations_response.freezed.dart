// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shared_locations_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SharedLocationsResponse {
  List<SharedLocationResponseData> get activeLiveLocations;
  String get duration;

  /// Create a copy of SharedLocationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SharedLocationsResponseCopyWith<SharedLocationsResponse> get copyWith =>
      _$SharedLocationsResponseCopyWithImpl<SharedLocationsResponse>(
        this as SharedLocationsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SharedLocationsResponse &&
            const DeepCollectionEquality().equals(
              other.activeLiveLocations,
              activeLiveLocations,
            ) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(activeLiveLocations),
    duration,
  );

  @override
  String toString() {
    return 'SharedLocationsResponse(activeLiveLocations: $activeLiveLocations, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $SharedLocationsResponseCopyWith<$Res> {
  factory $SharedLocationsResponseCopyWith(
    SharedLocationsResponse value,
    $Res Function(SharedLocationsResponse) _then,
  ) = _$SharedLocationsResponseCopyWithImpl;
  @useResult
  $Res call({
    List<SharedLocationResponseData> activeLiveLocations,
    String duration,
  });
}

/// @nodoc
class _$SharedLocationsResponseCopyWithImpl<$Res>
    implements $SharedLocationsResponseCopyWith<$Res> {
  _$SharedLocationsResponseCopyWithImpl(this._self, this._then);

  final SharedLocationsResponse _self;
  final $Res Function(SharedLocationsResponse) _then;

  /// Create a copy of SharedLocationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? activeLiveLocations = null, Object? duration = null}) {
    return _then(
      SharedLocationsResponse(
        activeLiveLocations: null == activeLiveLocations
            ? _self.activeLiveLocations
            : activeLiveLocations // ignore: cast_nullable_to_non_nullable
                  as List<SharedLocationResponseData>,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
