// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moderation_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ModerationPayload {
  List<String>? get audios;
  Map<String, Object?>? get custom;
  Map<String, String>? get imageIds;
  List<String>? get imageOrderedKeys;
  List<String>? get images;
  List<String>? get otherMedia;
  Map<String, String>? get textIds;
  List<String>? get textOrderedKeys;
  List<String>? get texts;
  List<String>? get videos;

  /// Create a copy of ModerationPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModerationPayloadCopyWith<ModerationPayload> get copyWith => _$ModerationPayloadCopyWithImpl<ModerationPayload>(
    this as ModerationPayload,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ModerationPayload &&
            const DeepCollectionEquality().equals(other.audios, audios) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            const DeepCollectionEquality().equals(other.imageIds, imageIds) &&
            const DeepCollectionEquality().equals(
              other.imageOrderedKeys,
              imageOrderedKeys,
            ) &&
            const DeepCollectionEquality().equals(other.images, images) &&
            const DeepCollectionEquality().equals(
              other.otherMedia,
              otherMedia,
            ) &&
            const DeepCollectionEquality().equals(other.textIds, textIds) &&
            const DeepCollectionEquality().equals(
              other.textOrderedKeys,
              textOrderedKeys,
            ) &&
            const DeepCollectionEquality().equals(other.texts, texts) &&
            const DeepCollectionEquality().equals(other.videos, videos));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(audios),
    const DeepCollectionEquality().hash(custom),
    const DeepCollectionEquality().hash(imageIds),
    const DeepCollectionEquality().hash(imageOrderedKeys),
    const DeepCollectionEquality().hash(images),
    const DeepCollectionEquality().hash(otherMedia),
    const DeepCollectionEquality().hash(textIds),
    const DeepCollectionEquality().hash(textOrderedKeys),
    const DeepCollectionEquality().hash(texts),
    const DeepCollectionEquality().hash(videos),
  );

  @override
  String toString() {
    return 'ModerationPayload(audios: $audios, custom: $custom, imageIds: $imageIds, imageOrderedKeys: $imageOrderedKeys, images: $images, otherMedia: $otherMedia, textIds: $textIds, textOrderedKeys: $textOrderedKeys, texts: $texts, videos: $videos)';
  }
}

/// @nodoc
abstract mixin class $ModerationPayloadCopyWith<$Res> {
  factory $ModerationPayloadCopyWith(
    ModerationPayload value,
    $Res Function(ModerationPayload) _then,
  ) = _$ModerationPayloadCopyWithImpl;
  @useResult
  $Res call({
    List<String>? audios,
    Map<String, Object?>? custom,
    Map<String, String>? imageIds,
    List<String>? imageOrderedKeys,
    List<String>? images,
    List<String>? otherMedia,
    Map<String, String>? textIds,
    List<String>? textOrderedKeys,
    List<String>? texts,
    List<String>? videos,
  });
}

/// @nodoc
class _$ModerationPayloadCopyWithImpl<$Res> implements $ModerationPayloadCopyWith<$Res> {
  _$ModerationPayloadCopyWithImpl(this._self, this._then);

  final ModerationPayload _self;
  final $Res Function(ModerationPayload) _then;

  /// Create a copy of ModerationPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? audios = freezed,
    Object? custom = freezed,
    Object? imageIds = freezed,
    Object? imageOrderedKeys = freezed,
    Object? images = freezed,
    Object? otherMedia = freezed,
    Object? textIds = freezed,
    Object? textOrderedKeys = freezed,
    Object? texts = freezed,
    Object? videos = freezed,
  }) {
    return _then(
      ModerationPayload(
        audios: freezed == audios
            ? _self.audios
            : audios // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        imageIds: freezed == imageIds
            ? _self.imageIds
            : imageIds // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        imageOrderedKeys: freezed == imageOrderedKeys
            ? _self.imageOrderedKeys
            : imageOrderedKeys // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        images: freezed == images
            ? _self.images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        otherMedia: freezed == otherMedia
            ? _self.otherMedia
            : otherMedia // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        textIds: freezed == textIds
            ? _self.textIds
            : textIds // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        textOrderedKeys: freezed == textOrderedKeys
            ? _self.textOrderedKeys
            : textOrderedKeys // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        texts: freezed == texts
            ? _self.texts
            : texts // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        videos: freezed == videos
            ? _self.videos
            : videos // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}
