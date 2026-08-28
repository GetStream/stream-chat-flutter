// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feeds_activity_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedsActivityLocation {
  double get lat;
  double get lng;

  /// Create a copy of FeedsActivityLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedsActivityLocationCopyWith<FeedsActivityLocation> get copyWith =>
      _$FeedsActivityLocationCopyWithImpl<FeedsActivityLocation>(
        this as FeedsActivityLocation,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedsActivityLocation &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @override
  int get hashCode => Object.hash(runtimeType, lat, lng);

  @override
  String toString() {
    return 'FeedsActivityLocation(lat: $lat, lng: $lng)';
  }
}

/// @nodoc
abstract mixin class $FeedsActivityLocationCopyWith<$Res> {
  factory $FeedsActivityLocationCopyWith(
    FeedsActivityLocation value,
    $Res Function(FeedsActivityLocation) _then,
  ) = _$FeedsActivityLocationCopyWithImpl;
  @useResult
  $Res call({double lat, double lng});
}

/// @nodoc
class _$FeedsActivityLocationCopyWithImpl<$Res>
    implements $FeedsActivityLocationCopyWith<$Res> {
  _$FeedsActivityLocationCopyWithImpl(this._self, this._then);

  final FeedsActivityLocation _self;
  final $Res Function(FeedsActivityLocation) _then;

  /// Create a copy of FeedsActivityLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? lat = null, Object? lng = null}) {
    return _then(
      FeedsActivityLocation(
        lat: null == lat
            ? _self.lat
            : lat // ignore: cast_nullable_to_non_nullable
                  as double,
        lng: null == lng
            ? _self.lng
            : lng // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}
