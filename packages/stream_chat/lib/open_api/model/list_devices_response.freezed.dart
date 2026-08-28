// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_devices_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListDevicesResponse {
  List<DeviceResponse> get devices;
  String get duration;

  /// Create a copy of ListDevicesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ListDevicesResponseCopyWith<ListDevicesResponse> get copyWith =>
      _$ListDevicesResponseCopyWithImpl<ListDevicesResponse>(
        this as ListDevicesResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ListDevicesResponse &&
            const DeepCollectionEquality().equals(other.devices, devices) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(devices),
    duration,
  );

  @override
  String toString() {
    return 'ListDevicesResponse(devices: $devices, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $ListDevicesResponseCopyWith<$Res> {
  factory $ListDevicesResponseCopyWith(
    ListDevicesResponse value,
    $Res Function(ListDevicesResponse) _then,
  ) = _$ListDevicesResponseCopyWithImpl;
  @useResult
  $Res call({List<DeviceResponse> devices, String duration});
}

/// @nodoc
class _$ListDevicesResponseCopyWithImpl<$Res>
    implements $ListDevicesResponseCopyWith<$Res> {
  _$ListDevicesResponseCopyWithImpl(this._self, this._then);

  final ListDevicesResponse _self;
  final $Res Function(ListDevicesResponse) _then;

  /// Create a copy of ListDevicesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? devices = null, Object? duration = null}) {
    return _then(
      ListDevicesResponse(
        devices: null == devices
            ? _self.devices
            : devices // ignore: cast_nullable_to_non_nullable
                  as List<DeviceResponse>,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
