// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_config_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetConfigResponse {
  ConfigResponse? get config;
  String get duration;

  /// Create a copy of GetConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GetConfigResponseCopyWith<GetConfigResponse> get copyWith =>
      _$GetConfigResponseCopyWithImpl<GetConfigResponse>(
        this as GetConfigResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GetConfigResponse &&
            (identical(other.config, config) || other.config == config) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, config, duration);

  @override
  String toString() {
    return 'GetConfigResponse(config: $config, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $GetConfigResponseCopyWith<$Res> {
  factory $GetConfigResponseCopyWith(
    GetConfigResponse value,
    $Res Function(GetConfigResponse) _then,
  ) = _$GetConfigResponseCopyWithImpl;
  @useResult
  $Res call({ConfigResponse? config, String duration});
}

/// @nodoc
class _$GetConfigResponseCopyWithImpl<$Res>
    implements $GetConfigResponseCopyWith<$Res> {
  _$GetConfigResponseCopyWithImpl(this._self, this._then);

  final GetConfigResponse _self;
  final $Res Function(GetConfigResponse) _then;

  /// Create a copy of GetConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? config = freezed, Object? duration = null}) {
    return _then(
      GetConfigResponse(
        config: freezed == config
            ? _self.config
            : config // ignore: cast_nullable_to_non_nullable
                  as ConfigResponse?,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
