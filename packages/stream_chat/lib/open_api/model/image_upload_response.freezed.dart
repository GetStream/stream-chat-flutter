// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_upload_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImageUploadResponse {
  String get duration;
  String? get file;
  String? get thumbUrl;
  List<ImageSize>? get uploadSizes;

  /// Create a copy of ImageUploadResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ImageUploadResponseCopyWith<ImageUploadResponse> get copyWith =>
      _$ImageUploadResponseCopyWithImpl<ImageUploadResponse>(
        this as ImageUploadResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ImageUploadResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.thumbUrl, thumbUrl) ||
                other.thumbUrl == thumbUrl) &&
            const DeepCollectionEquality().equals(
              other.uploadSizes,
              uploadSizes,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    file,
    thumbUrl,
    const DeepCollectionEquality().hash(uploadSizes),
  );

  @override
  String toString() {
    return 'ImageUploadResponse(duration: $duration, file: $file, thumbUrl: $thumbUrl, uploadSizes: $uploadSizes)';
  }
}

/// @nodoc
abstract mixin class $ImageUploadResponseCopyWith<$Res> {
  factory $ImageUploadResponseCopyWith(
    ImageUploadResponse value,
    $Res Function(ImageUploadResponse) _then,
  ) = _$ImageUploadResponseCopyWithImpl;
  @useResult
  $Res call({
    String duration,
    String? file,
    String? thumbUrl,
    List<ImageSize>? uploadSizes,
  });
}

/// @nodoc
class _$ImageUploadResponseCopyWithImpl<$Res>
    implements $ImageUploadResponseCopyWith<$Res> {
  _$ImageUploadResponseCopyWithImpl(this._self, this._then);

  final ImageUploadResponse _self;
  final $Res Function(ImageUploadResponse) _then;

  /// Create a copy of ImageUploadResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? file = freezed,
    Object? thumbUrl = freezed,
    Object? uploadSizes = freezed,
  }) {
    return _then(
      ImageUploadResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        file: freezed == file
            ? _self.file
            : file // ignore: cast_nullable_to_non_nullable
                  as String?,
        thumbUrl: freezed == thumbUrl
            ? _self.thumbUrl
            : thumbUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        uploadSizes: freezed == uploadSizes
            ? _self.uploadSizes
            : uploadSizes // ignore: cast_nullable_to_non_nullable
                  as List<ImageSize>?,
      ),
    );
  }
}
