// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_event_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppEventResponse {
  bool? get asyncUrlEnrichEnabled;
  bool get autoTranslationEnabled;
  FileUploadConfig? get fileUploadConfig;
  FileUploadConfig? get imageUploadConfig;
  String get name;

  /// Create a copy of AppEventResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppEventResponseCopyWith<AppEventResponse> get copyWith =>
      _$AppEventResponseCopyWithImpl<AppEventResponse>(
        this as AppEventResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppEventResponse &&
            (identical(other.asyncUrlEnrichEnabled, asyncUrlEnrichEnabled) ||
                other.asyncUrlEnrichEnabled == asyncUrlEnrichEnabled) &&
            (identical(other.autoTranslationEnabled, autoTranslationEnabled) ||
                other.autoTranslationEnabled == autoTranslationEnabled) &&
            (identical(other.fileUploadConfig, fileUploadConfig) ||
                other.fileUploadConfig == fileUploadConfig) &&
            (identical(other.imageUploadConfig, imageUploadConfig) ||
                other.imageUploadConfig == imageUploadConfig) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    asyncUrlEnrichEnabled,
    autoTranslationEnabled,
    fileUploadConfig,
    imageUploadConfig,
    name,
  );

  @override
  String toString() {
    return 'AppEventResponse(asyncUrlEnrichEnabled: $asyncUrlEnrichEnabled, autoTranslationEnabled: $autoTranslationEnabled, fileUploadConfig: $fileUploadConfig, imageUploadConfig: $imageUploadConfig, name: $name)';
  }
}

/// @nodoc
abstract mixin class $AppEventResponseCopyWith<$Res> {
  factory $AppEventResponseCopyWith(
    AppEventResponse value,
    $Res Function(AppEventResponse) _then,
  ) = _$AppEventResponseCopyWithImpl;
  @useResult
  $Res call({
    bool? asyncUrlEnrichEnabled,
    bool autoTranslationEnabled,
    FileUploadConfig? fileUploadConfig,
    FileUploadConfig? imageUploadConfig,
    String name,
  });
}

/// @nodoc
class _$AppEventResponseCopyWithImpl<$Res>
    implements $AppEventResponseCopyWith<$Res> {
  _$AppEventResponseCopyWithImpl(this._self, this._then);

  final AppEventResponse _self;
  final $Res Function(AppEventResponse) _then;

  /// Create a copy of AppEventResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? asyncUrlEnrichEnabled = freezed,
    Object? autoTranslationEnabled = null,
    Object? fileUploadConfig = freezed,
    Object? imageUploadConfig = freezed,
    Object? name = null,
  }) {
    return _then(
      AppEventResponse(
        asyncUrlEnrichEnabled: freezed == asyncUrlEnrichEnabled
            ? _self.asyncUrlEnrichEnabled
            : asyncUrlEnrichEnabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        autoTranslationEnabled: null == autoTranslationEnabled
            ? _self.autoTranslationEnabled
            : autoTranslationEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        fileUploadConfig: freezed == fileUploadConfig
            ? _self.fileUploadConfig
            : fileUploadConfig // ignore: cast_nullable_to_non_nullable
                  as FileUploadConfig?,
        imageUploadConfig: freezed == imageUploadConfig
            ? _self.imageUploadConfig
            : imageUploadConfig // ignore: cast_nullable_to_non_nullable
                  as FileUploadConfig?,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
