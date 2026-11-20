// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UploadConfig {
  int get sizeLimit;
  List<String> get allowedFileExtensions;
  List<String> get blockedFileExtensions;
  List<String> get allowedMimeTypes;
  List<String> get blockedMimeTypes;

  /// Create a copy of UploadConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UploadConfigCopyWith<UploadConfig> get copyWith =>
      _$UploadConfigCopyWithImpl<UploadConfig>(this as UploadConfig, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UploadConfig &&
            (identical(other.sizeLimit, sizeLimit) || other.sizeLimit == sizeLimit) &&
            const DeepCollectionEquality().equals(other.allowedFileExtensions, allowedFileExtensions) &&
            const DeepCollectionEquality().equals(other.blockedFileExtensions, blockedFileExtensions) &&
            const DeepCollectionEquality().equals(other.allowedMimeTypes, allowedMimeTypes) &&
            const DeepCollectionEquality().equals(other.blockedMimeTypes, blockedMimeTypes));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    sizeLimit,
    const DeepCollectionEquality().hash(allowedFileExtensions),
    const DeepCollectionEquality().hash(blockedFileExtensions),
    const DeepCollectionEquality().hash(allowedMimeTypes),
    const DeepCollectionEquality().hash(blockedMimeTypes),
  );

  @override
  String toString() {
    return 'UploadConfig(sizeLimit: $sizeLimit, allowedFileExtensions: $allowedFileExtensions, blockedFileExtensions: $blockedFileExtensions, allowedMimeTypes: $allowedMimeTypes, blockedMimeTypes: $blockedMimeTypes)';
  }
}

/// @nodoc
abstract mixin class $UploadConfigCopyWith<$Res> {
  factory $UploadConfigCopyWith(UploadConfig value, $Res Function(UploadConfig) _then) = _$UploadConfigCopyWithImpl;
  @useResult
  $Res call({
    int sizeLimit,
    List<String> allowedFileExtensions,
    List<String> blockedFileExtensions,
    List<String> allowedMimeTypes,
    List<String> blockedMimeTypes,
  });
}

/// @nodoc
class _$UploadConfigCopyWithImpl<$Res> implements $UploadConfigCopyWith<$Res> {
  _$UploadConfigCopyWithImpl(this._self, this._then);

  final UploadConfig _self;
  final $Res Function(UploadConfig) _then;

  /// Create a copy of UploadConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sizeLimit = null,
    Object? allowedFileExtensions = null,
    Object? blockedFileExtensions = null,
    Object? allowedMimeTypes = null,
    Object? blockedMimeTypes = null,
  }) {
    return _then(
      UploadConfig(
        sizeLimit: null == sizeLimit
            ? _self.sizeLimit
            : sizeLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        allowedFileExtensions: null == allowedFileExtensions
            ? _self.allowedFileExtensions
            : allowedFileExtensions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        blockedFileExtensions: null == blockedFileExtensions
            ? _self.blockedFileExtensions
            : blockedFileExtensions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        allowedMimeTypes: null == allowedMimeTypes
            ? _self.allowedMimeTypes
            : allowedMimeTypes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        blockedMimeTypes: null == blockedMimeTypes
            ? _self.blockedMimeTypes
            : blockedMimeTypes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}
