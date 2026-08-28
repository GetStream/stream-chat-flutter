// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'images.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Images {
  ImageData get fixedHeight;
  ImageData get fixedHeightDownsampled;
  ImageData get fixedHeightStill;
  ImageData get fixedWidth;
  ImageData get fixedWidthDownsampled;
  ImageData get fixedWidthStill;
  ImageData get original;

  /// Create a copy of Images
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ImagesCopyWith<Images> get copyWith =>
      _$ImagesCopyWithImpl<Images>(this as Images, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Images &&
            (identical(other.fixedHeight, fixedHeight) ||
                other.fixedHeight == fixedHeight) &&
            (identical(other.fixedHeightDownsampled, fixedHeightDownsampled) ||
                other.fixedHeightDownsampled == fixedHeightDownsampled) &&
            (identical(other.fixedHeightStill, fixedHeightStill) ||
                other.fixedHeightStill == fixedHeightStill) &&
            (identical(other.fixedWidth, fixedWidth) ||
                other.fixedWidth == fixedWidth) &&
            (identical(other.fixedWidthDownsampled, fixedWidthDownsampled) ||
                other.fixedWidthDownsampled == fixedWidthDownsampled) &&
            (identical(other.fixedWidthStill, fixedWidthStill) ||
                other.fixedWidthStill == fixedWidthStill) &&
            (identical(other.original, original) ||
                other.original == original));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    fixedHeight,
    fixedHeightDownsampled,
    fixedHeightStill,
    fixedWidth,
    fixedWidthDownsampled,
    fixedWidthStill,
    original,
  );

  @override
  String toString() {
    return 'Images(fixedHeight: $fixedHeight, fixedHeightDownsampled: $fixedHeightDownsampled, fixedHeightStill: $fixedHeightStill, fixedWidth: $fixedWidth, fixedWidthDownsampled: $fixedWidthDownsampled, fixedWidthStill: $fixedWidthStill, original: $original)';
  }
}

/// @nodoc
abstract mixin class $ImagesCopyWith<$Res> {
  factory $ImagesCopyWith(Images value, $Res Function(Images) _then) =
      _$ImagesCopyWithImpl;
  @useResult
  $Res call({
    ImageData fixedHeight,
    ImageData fixedHeightDownsampled,
    ImageData fixedHeightStill,
    ImageData fixedWidth,
    ImageData fixedWidthDownsampled,
    ImageData fixedWidthStill,
    ImageData original,
  });
}

/// @nodoc
class _$ImagesCopyWithImpl<$Res> implements $ImagesCopyWith<$Res> {
  _$ImagesCopyWithImpl(this._self, this._then);

  final Images _self;
  final $Res Function(Images) _then;

  /// Create a copy of Images
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fixedHeight = null,
    Object? fixedHeightDownsampled = null,
    Object? fixedHeightStill = null,
    Object? fixedWidth = null,
    Object? fixedWidthDownsampled = null,
    Object? fixedWidthStill = null,
    Object? original = null,
  }) {
    return _then(
      Images(
        fixedHeight: null == fixedHeight
            ? _self.fixedHeight
            : fixedHeight // ignore: cast_nullable_to_non_nullable
                  as ImageData,
        fixedHeightDownsampled: null == fixedHeightDownsampled
            ? _self.fixedHeightDownsampled
            : fixedHeightDownsampled // ignore: cast_nullable_to_non_nullable
                  as ImageData,
        fixedHeightStill: null == fixedHeightStill
            ? _self.fixedHeightStill
            : fixedHeightStill // ignore: cast_nullable_to_non_nullable
                  as ImageData,
        fixedWidth: null == fixedWidth
            ? _self.fixedWidth
            : fixedWidth // ignore: cast_nullable_to_non_nullable
                  as ImageData,
        fixedWidthDownsampled: null == fixedWidthDownsampled
            ? _self.fixedWidthDownsampled
            : fixedWidthDownsampled // ignore: cast_nullable_to_non_nullable
                  as ImageData,
        fixedWidthStill: null == fixedWidthStill
            ? _self.fixedWidthStill
            : fixedWidthStill // ignore: cast_nullable_to_non_nullable
                  as ImageData,
        original: null == original
            ? _self.original
            : original // ignore: cast_nullable_to_non_nullable
                  as ImageData,
      ),
    );
  }
}
