// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheduled_message_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduledMessageLocation {
  String get createdByDeviceId;
  DateTime? get endAt;
  double? get latitude;
  double? get longitude;

  /// Create a copy of ScheduledMessageLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduledMessageLocationCopyWith<ScheduledMessageLocation> get copyWith =>
      _$ScheduledMessageLocationCopyWithImpl<ScheduledMessageLocation>(
        this as ScheduledMessageLocation,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScheduledMessageLocation &&
            (identical(other.createdByDeviceId, createdByDeviceId) || other.createdByDeviceId == createdByDeviceId) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.latitude, latitude) || other.latitude == latitude) &&
            (identical(other.longitude, longitude) || other.longitude == longitude));
  }

  @override
  int get hashCode => Object.hash(runtimeType, createdByDeviceId, endAt, latitude, longitude);

  @override
  String toString() {
    return 'ScheduledMessageLocation(createdByDeviceId: $createdByDeviceId, endAt: $endAt, latitude: $latitude, longitude: $longitude)';
  }
}

/// @nodoc
abstract mixin class $ScheduledMessageLocationCopyWith<$Res> {
  factory $ScheduledMessageLocationCopyWith(
    ScheduledMessageLocation value,
    $Res Function(ScheduledMessageLocation) _then,
  ) = _$ScheduledMessageLocationCopyWithImpl;
  @useResult
  $Res call({
    String createdByDeviceId,
    DateTime? endAt,
    double? latitude,
    double? longitude,
  });
}

/// @nodoc
class _$ScheduledMessageLocationCopyWithImpl<$Res> implements $ScheduledMessageLocationCopyWith<$Res> {
  _$ScheduledMessageLocationCopyWithImpl(this._self, this._then);

  final ScheduledMessageLocation _self;
  final $Res Function(ScheduledMessageLocation) _then;

  /// Create a copy of ScheduledMessageLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdByDeviceId = null,
    Object? endAt = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(
      ScheduledMessageLocation(
        createdByDeviceId: null == createdByDeviceId
            ? _self.createdByDeviceId
            : createdByDeviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        endAt: freezed == endAt
            ? _self.endAt
            : endAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        latitude: freezed == latitude
            ? _self.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _self.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}
