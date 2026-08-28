// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upsert_config_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpsertConfigResponse {
  ConfigResponse? get config;
  String get duration;

  /// Create a copy of UpsertConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpsertConfigResponseCopyWith<UpsertConfigResponse> get copyWith =>
      _$UpsertConfigResponseCopyWithImpl<UpsertConfigResponse>(
        this as UpsertConfigResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpsertConfigResponse &&
            (identical(other.config, config) || other.config == config) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, config, duration);

  @override
  String toString() {
    return 'UpsertConfigResponse(config: $config, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $UpsertConfigResponseCopyWith<$Res> {
  factory $UpsertConfigResponseCopyWith(
    UpsertConfigResponse value,
    $Res Function(UpsertConfigResponse) _then,
  ) = _$UpsertConfigResponseCopyWithImpl;
  @useResult
  $Res call({ConfigResponse? config, String duration});
}

/// @nodoc
class _$UpsertConfigResponseCopyWithImpl<$Res>
    implements $UpsertConfigResponseCopyWith<$Res> {
  _$UpsertConfigResponseCopyWithImpl(this._self, this._then);

  final UpsertConfigResponse _self;
  final $Res Function(UpsertConfigResponse) _then;

  /// Create a copy of UpsertConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? config = freezed, Object? duration = null}) {
    return _then(
      UpsertConfigResponse(
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
