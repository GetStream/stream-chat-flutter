// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_response_fields.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppResponseFields {
  bool get asyncUrlEnrichEnabled;
  bool get autoTranslationEnabled;
  FileUploadConfig get fileUploadConfig;
  int get id;
  FileUploadConfig get imageUploadConfig;
  String get name;
  String get placement;

  /// Create a copy of AppResponseFields
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppResponseFieldsCopyWith<AppResponseFields> get copyWith =>
      _$AppResponseFieldsCopyWithImpl<AppResponseFields>(
        this as AppResponseFields,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppResponseFields &&
            (identical(other.asyncUrlEnrichEnabled, asyncUrlEnrichEnabled) ||
                other.asyncUrlEnrichEnabled == asyncUrlEnrichEnabled) &&
            (identical(other.autoTranslationEnabled, autoTranslationEnabled) ||
                other.autoTranslationEnabled == autoTranslationEnabled) &&
            (identical(other.fileUploadConfig, fileUploadConfig) ||
                other.fileUploadConfig == fileUploadConfig) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUploadConfig, imageUploadConfig) ||
                other.imageUploadConfig == imageUploadConfig) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.placement, placement) ||
                other.placement == placement));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    asyncUrlEnrichEnabled,
    autoTranslationEnabled,
    fileUploadConfig,
    id,
    imageUploadConfig,
    name,
    placement,
  );

  @override
  String toString() {
    return 'AppResponseFields(asyncUrlEnrichEnabled: $asyncUrlEnrichEnabled, autoTranslationEnabled: $autoTranslationEnabled, fileUploadConfig: $fileUploadConfig, id: $id, imageUploadConfig: $imageUploadConfig, name: $name, placement: $placement)';
  }
}

/// @nodoc
abstract mixin class $AppResponseFieldsCopyWith<$Res> {
  factory $AppResponseFieldsCopyWith(
    AppResponseFields value,
    $Res Function(AppResponseFields) _then,
  ) = _$AppResponseFieldsCopyWithImpl;
  @useResult
  $Res call({
    bool asyncUrlEnrichEnabled,
    bool autoTranslationEnabled,
    FileUploadConfig fileUploadConfig,
    int id,
    FileUploadConfig imageUploadConfig,
    String name,
    String placement,
  });
}

/// @nodoc
class _$AppResponseFieldsCopyWithImpl<$Res>
    implements $AppResponseFieldsCopyWith<$Res> {
  _$AppResponseFieldsCopyWithImpl(this._self, this._then);

  final AppResponseFields _self;
  final $Res Function(AppResponseFields) _then;

  /// Create a copy of AppResponseFields
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? asyncUrlEnrichEnabled = null,
    Object? autoTranslationEnabled = null,
    Object? fileUploadConfig = null,
    Object? id = null,
    Object? imageUploadConfig = null,
    Object? name = null,
    Object? placement = null,
  }) {
    return _then(
      AppResponseFields(
        asyncUrlEnrichEnabled: null == asyncUrlEnrichEnabled
            ? _self.asyncUrlEnrichEnabled
            : asyncUrlEnrichEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        autoTranslationEnabled: null == autoTranslationEnabled
            ? _self.autoTranslationEnabled
            : autoTranslationEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        fileUploadConfig: null == fileUploadConfig
            ? _self.fileUploadConfig
            : fileUploadConfig // ignore: cast_nullable_to_non_nullable
                  as FileUploadConfig,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        imageUploadConfig: null == imageUploadConfig
            ? _self.imageUploadConfig
            : imageUploadConfig // ignore: cast_nullable_to_non_nullable
                  as FileUploadConfig,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        placement: null == placement
            ? _self.placement
            : placement // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
