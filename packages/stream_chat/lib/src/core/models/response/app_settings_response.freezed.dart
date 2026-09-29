// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettingsResponse {
  String get duration;
  AppSettings get app;

  /// Create a copy of AppSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppSettingsResponseCopyWith<AppSettingsResponse> get copyWith =>
      _$AppSettingsResponseCopyWithImpl<AppSettingsResponse>(this as AppSettingsResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppSettingsResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.app, app) || other.app == app));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, app);

  @override
  String toString() {
    return 'AppSettingsResponse(duration: $duration, app: $app)';
  }
}

/// @nodoc
abstract mixin class $AppSettingsResponseCopyWith<$Res> {
  factory $AppSettingsResponseCopyWith(AppSettingsResponse value, $Res Function(AppSettingsResponse) _then) =
      _$AppSettingsResponseCopyWithImpl;
  @useResult
  $Res call({String duration, AppSettings app});
}

/// @nodoc
class _$AppSettingsResponseCopyWithImpl<$Res> implements $AppSettingsResponseCopyWith<$Res> {
  _$AppSettingsResponseCopyWithImpl(this._self, this._then);

  final AppSettingsResponse _self;
  final $Res Function(AppSettingsResponse) _then;

  /// Create a copy of AppSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? app = null}) {
    return _then(
      AppSettingsResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        app: null == app
            ? _self.app
            : app // ignore: cast_nullable_to_non_nullable
                  as AppSettings,
      ),
    );
  }
}
