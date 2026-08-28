// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_size.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImageSize {
  String? get crop;
  int? get height;
  String? get resize;
  int? get width;

  /// Create a copy of ImageSize
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ImageSizeCopyWith<ImageSize> get copyWith =>
      _$ImageSizeCopyWithImpl<ImageSize>(this as ImageSize, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ImageSize &&
            (identical(other.crop, crop) || other.crop == crop) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.resize, resize) || other.resize == resize) &&
            (identical(other.width, width) || other.width == width));
  }

  @override
  int get hashCode => Object.hash(runtimeType, crop, height, resize, width);

  @override
  String toString() {
    return 'ImageSize(crop: $crop, height: $height, resize: $resize, width: $width)';
  }
}

/// @nodoc
abstract mixin class $ImageSizeCopyWith<$Res> {
  factory $ImageSizeCopyWith(ImageSize value, $Res Function(ImageSize) _then) =
      _$ImageSizeCopyWithImpl;
  @useResult
  $Res call({String? crop, int? height, String? resize, int? width});
}

/// @nodoc
class _$ImageSizeCopyWithImpl<$Res> implements $ImageSizeCopyWith<$Res> {
  _$ImageSizeCopyWithImpl(this._self, this._then);

  final ImageSize _self;
  final $Res Function(ImageSize) _then;

  /// Create a copy of ImageSize
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? crop = freezed,
    Object? height = freezed,
    Object? resize = freezed,
    Object? width = freezed,
  }) {
    return _then(
      ImageSize(
        crop: freezed == crop
            ? _self.crop
            : crop // ignore: cast_nullable_to_non_nullable
                  as String?,
        height: freezed == height
            ? _self.height
            : height // ignore: cast_nullable_to_non_nullable
                  as int?,
        resize: freezed == resize
            ? _self.resize
            : resize // ignore: cast_nullable_to_non_nullable
                  as String?,
        width: freezed == width
            ? _self.width
            : width // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}
