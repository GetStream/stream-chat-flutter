// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettings {
  String get name;
  UploadConfig get fileUploadConfig;
  UploadConfig get imageUploadConfig;
  bool get autoTranslationEnabled;
  bool get asyncUrlEnrichEnabled;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppSettings &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.fileUploadConfig, fileUploadConfig) || other.fileUploadConfig == fileUploadConfig) &&
            (identical(other.imageUploadConfig, imageUploadConfig) || other.imageUploadConfig == imageUploadConfig) &&
            (identical(other.autoTranslationEnabled, autoTranslationEnabled) ||
                other.autoTranslationEnabled == autoTranslationEnabled) &&
            (identical(other.asyncUrlEnrichEnabled, asyncUrlEnrichEnabled) ||
                other.asyncUrlEnrichEnabled == asyncUrlEnrichEnabled));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    fileUploadConfig,
    imageUploadConfig,
    autoTranslationEnabled,
    asyncUrlEnrichEnabled,
  );

  @override
  String toString() {
    return 'AppSettings(name: $name, fileUploadConfig: $fileUploadConfig, imageUploadConfig: $imageUploadConfig, autoTranslationEnabled: $autoTranslationEnabled, asyncUrlEnrichEnabled: $asyncUrlEnrichEnabled)';
  }
}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
  @useResult
  $Res call({
    String name,
    UploadConfig fileUploadConfig,
    UploadConfig imageUploadConfig,
    bool autoTranslationEnabled,
    bool asyncUrlEnrichEnabled,
  });
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res> implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? fileUploadConfig = null,
    Object? imageUploadConfig = null,
    Object? autoTranslationEnabled = null,
    Object? asyncUrlEnrichEnabled = null,
  }) {
    return _then(
      AppSettings(
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        fileUploadConfig: null == fileUploadConfig
            ? _self.fileUploadConfig
            : fileUploadConfig // ignore: cast_nullable_to_non_nullable
                  as UploadConfig,
        imageUploadConfig: null == imageUploadConfig
            ? _self.imageUploadConfig
            : imageUploadConfig // ignore: cast_nullable_to_non_nullable
                  as UploadConfig,
        autoTranslationEnabled: null == autoTranslationEnabled
            ? _self.autoTranslationEnabled
            : autoTranslationEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        asyncUrlEnrichEnabled: null == asyncUrlEnrichEnabled
            ? _self.asyncUrlEnrichEnabled
            : asyncUrlEnrichEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
