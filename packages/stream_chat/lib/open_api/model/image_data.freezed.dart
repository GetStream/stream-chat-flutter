// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImageData {
  String get frames;
  String get height;
  String get size;
  String get url;
  String get width;

  /// Create a copy of ImageData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ImageDataCopyWith<ImageData> get copyWith =>
      _$ImageDataCopyWithImpl<ImageData>(this as ImageData, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ImageData &&
            (identical(other.frames, frames) || other.frames == frames) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.width, width) || other.width == width));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, frames, height, size, url, width);

  @override
  String toString() {
    return 'ImageData(frames: $frames, height: $height, size: $size, url: $url, width: $width)';
  }
}

/// @nodoc
abstract mixin class $ImageDataCopyWith<$Res> {
  factory $ImageDataCopyWith(ImageData value, $Res Function(ImageData) _then) =
      _$ImageDataCopyWithImpl;
  @useResult
  $Res call({
    String frames,
    String height,
    String size,
    String url,
    String width,
  });
}

/// @nodoc
class _$ImageDataCopyWithImpl<$Res> implements $ImageDataCopyWith<$Res> {
  _$ImageDataCopyWithImpl(this._self, this._then);

  final ImageData _self;
  final $Res Function(ImageData) _then;

  /// Create a copy of ImageData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frames = null,
    Object? height = null,
    Object? size = null,
    Object? url = null,
    Object? width = null,
  }) {
    return _then(
      ImageData(
        frames: null == frames
            ? _self.frames
            : frames // ignore: cast_nullable_to_non_nullable
                  as String,
        height: null == height
            ? _self.height
            : height // ignore: cast_nullable_to_non_nullable
                  as String,
        size: null == size
            ? _self.size
            : size // ignore: cast_nullable_to_non_nullable
                  as String,
        url: null == url
            ? _self.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        width: null == width
            ? _self.width
            : width // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
