// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'google_vision_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GoogleVisionConfig {
  bool? get enabled;

  /// Create a copy of GoogleVisionConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoogleVisionConfigCopyWith<GoogleVisionConfig> get copyWith =>
      _$GoogleVisionConfigCopyWithImpl<GoogleVisionConfig>(
        this as GoogleVisionConfig,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoogleVisionConfig &&
            (identical(other.enabled, enabled) || other.enabled == enabled));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enabled);

  @override
  String toString() {
    return 'GoogleVisionConfig(enabled: $enabled)';
  }
}

/// @nodoc
abstract mixin class $GoogleVisionConfigCopyWith<$Res> {
  factory $GoogleVisionConfigCopyWith(
    GoogleVisionConfig value,
    $Res Function(GoogleVisionConfig) _then,
  ) = _$GoogleVisionConfigCopyWithImpl;
  @useResult
  $Res call({bool? enabled});
}

/// @nodoc
class _$GoogleVisionConfigCopyWithImpl<$Res>
    implements $GoogleVisionConfigCopyWith<$Res> {
  _$GoogleVisionConfigCopyWithImpl(this._self, this._then);

  final GoogleVisionConfig _self;
  final $Res Function(GoogleVisionConfig) _then;

  /// Create a copy of GoogleVisionConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? enabled = freezed}) {
    return _then(
      GoogleVisionConfig(
        enabled: freezed == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
