// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_upload_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FileUploadResponse {
  String get duration;
  String? get file;
  String? get thumbUrl;

  /// Create a copy of FileUploadResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FileUploadResponseCopyWith<FileUploadResponse> get copyWith =>
      _$FileUploadResponseCopyWithImpl<FileUploadResponse>(
        this as FileUploadResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FileUploadResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.thumbUrl, thumbUrl) ||
                other.thumbUrl == thumbUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, file, thumbUrl);

  @override
  String toString() {
    return 'FileUploadResponse(duration: $duration, file: $file, thumbUrl: $thumbUrl)';
  }
}

/// @nodoc
abstract mixin class $FileUploadResponseCopyWith<$Res> {
  factory $FileUploadResponseCopyWith(
    FileUploadResponse value,
    $Res Function(FileUploadResponse) _then,
  ) = _$FileUploadResponseCopyWithImpl;
  @useResult
  $Res call({String duration, String? file, String? thumbUrl});
}

/// @nodoc
class _$FileUploadResponseCopyWithImpl<$Res>
    implements $FileUploadResponseCopyWith<$Res> {
  _$FileUploadResponseCopyWithImpl(this._self, this._then);

  final FileUploadResponse _self;
  final $Res Function(FileUploadResponse) _then;

  /// Create a copy of FileUploadResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? file = freezed,
    Object? thumbUrl = freezed,
  }) {
    return _then(
      FileUploadResponse(
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
      ),
    );
  }
}
